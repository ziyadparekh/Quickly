//
//  ZPLoginViewController.m
//  Quickly
//
//  Created by Ziyad Parekh on 12/31/14.
//  Copyright (c) 2014 Ziyad Parekh. All rights reserved.
//

#import "ZPLoginViewController.h"
#import "ZPConstants.h"
#import <Parse/Parse.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>

@interface ZPLoginViewController ()
@property (strong, nonatomic) IBOutlet UIButton *loginButton;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) NSMutableData *imageData;

@end

@implementation ZPLoginViewController

#pragma mark - UIViewLifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.activityIndicator.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if ([PFUser currentUser] && [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) {
        [self updateUserInformation];
        [self updateUserFacebookFriendList];
        [self performSegueWithIdentifier:kZPLoginToHomeSegue sender:self];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)loginButtonPressed:(UIButton *)sender
{
    self.activityIndicator.hidden = NO;
    [self.activityIndicator startAnimating];
    NSArray *permissionsArray = @[@"public_profile", @"user_about_me", @"user_friends"];
    
    [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
        [self.activityIndicator stopAnimating];
        self.activityIndicator.hidden = YES;
        if (!user) {
            if (!error) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Log In Error" message:@"The Facebook login was cancelled" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Dismiss", nil];
                [alertView show];
            } else {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Log In Error" message:[error description] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Dismiss", nil];
                [alertView show];
            }
        } else {
            [self updateUserInformation];
            [self updateUserFacebookFriendList];
            [self performSegueWithIdentifier:kZPLoginToHomeSegue sender:self];
        }
    }];
}

#pragma mark - Helper Methods

- (void)updateUserInformation
{
    FBRequest *request = [FBRequest requestForMe];
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            NSDictionary *userDictionary = (NSDictionary *)result;
            
            //create url
            NSString *facebookID = userDictionary[@"id"];
            NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID]];
            
            NSMutableDictionary *userProfile = [[NSMutableDictionary alloc] initWithCapacity:7];
            if (userDictionary[@"name"]) {
                userProfile[kZPUserProfileNameKey] = userDictionary[@"name"];
            }
            if (userDictionary[@"first_name"]) {
                userProfile[kZPUserProfileFirstNameKey] = userDictionary[@"first_name"];
            }
            if (userDictionary[@"last_name"]) {
                userProfile[kZPUserProfileLastNameKey] = userDictionary[@"last_name"];
            }
            if (userDictionary[@"gender"]) {
                userProfile[kZPUserProfileGenderKey] = userDictionary[@"gender"];
            }
            if ([pictureURL absoluteString]) {
                userProfile[kZPUserProfilePictureURL] = [pictureURL absoluteString];
            }
            [[PFUser currentUser] setObject:userProfile forKey:kZPUserProfileKey];
            [[PFUser currentUser] saveInBackground];
            [self requestUserProfileImage];
        } else {
            NSLog(@"There was an error retrieving Users Facebook Information");
        }
    }];
}

- (void)UploadUserProfilePictureFileToParse:(UIImage *)image
{
    NSData *imageData = UIImageJPEGRepresentation(image, 0.8);
    if (!imageData) {
        NSLog(@"Image Data not found - UploadUserProfilePictureFileToParse");
        return;
    }
    PFFile *photoFile = [PFFile fileWithData:imageData];
    [photoFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            PFObject *photo = [PFObject objectWithClassName:kZPPhotoClassKey];
            [photo setObject:[PFUser currentUser] forKey:kZPPhotoUserKey];
            [photo setObject:photoFile forKey:kZPPhotoPictureKey];
            [photo saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                NSLog(@"Photo saved successfully");
            }];
        }
    }];
    
}

- (void)requestUserProfileImage
{
    PFQuery *queryForProfileImage = [PFQuery queryWithClassName:kZPPhotoClassKey];
    [queryForProfileImage whereKey:kZPPhotoUserKey equalTo:[PFUser currentUser]];
    
    [queryForProfileImage countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
        if (number == 0) {
            PFUser *user = [PFUser currentUser];
            self.imageData = [[NSMutableData alloc] init];
            
            NSURL *profilePictureUrl = [NSURL URLWithString:user[kZPUserProfileKey][kZPUserProfilePictureURL]];
            NSURLRequest *urlRequest = [NSURLRequest requestWithURL:profilePictureUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:4.0f];
            NSURLConnection *urlConnection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
            if (!urlConnection) {
                NSLog(@"Failed to download profile picture - requestUserProfileImage");
            }
        }
    }];
}

- (void)updateUserFacebookFriendList
{
    FBRequest *request = [FBRequest requestForMyFriends];
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            NSDictionary *userFriendsDictionary = (NSDictionary *)result;
            if (userFriendsDictionary[@"data"]) {
                NSArray *userFriendsArray = [userFriendsDictionary objectForKey:@"data"];
                NSMutableArray *userFriendsIDs = [[NSMutableArray alloc] init];
                for (NSDictionary<FBGraphUser>* friend in userFriendsArray) {
                    [userFriendsIDs addObject:friend.objectID];
                }
                [[PFUser currentUser] setObject:userFriendsIDs forKey:kZPUserProfileFriendsListKey];
                [[PFUser currentUser] saveInBackground];
            }
        } else {
            NSLog(@"There was an error retrieving Users Facebook Friends");
        }
    }];
}

#pragma mark - NSURLConnectionDataDelegate

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.imageData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    UIImage *profileImage = [UIImage imageWithData:self.imageData];
    [self UploadUserProfilePictureFileToParse:profileImage];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
