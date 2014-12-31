//
//  ZPConstants.m
//  Quickly
//
//  Created by Ziyad Parekh on 12/31/14.
//  Copyright (c) 2014 Ziyad Parekh. All rights reserved.
//

#import "ZPConstants.h"

@implementation ZPConstants

#pragma mark - Segues

NSString *const kZPLoginToHomeSegue             = @"LoginToHomeSegue";

#pragma mark - User Profile Class

NSString *const kZPUserProfileNameKey           = @"userName";
NSString *const kZPUserProfileFirstNameKey      = @"userFirstName";
NSString *const kZPUserProfileLastNameKey       = @"userLastName";
NSString *const kZPUserProfileGenderKey         = @"userGender";
NSString *const kZPUserProfileKey               = @"profile";
NSString *const kZPUserProfileFriendsListKey    = @"userFriendsList";
NSString *const kZPUserProfilePictureURL        = @"userPictureURL";

#pragma mark - User Photo Class

NSString *const kZPPhotoClassKey            = @"Photo";
NSString *const kZPPhotoUserKey             = @"userObjectPointer";
NSString *const kZPPhotoPictureKey          = @"imageFilePointer";

@end
