//
//  ZPConstants.h
//  Quickly
//
//  Created by Ziyad Parekh on 12/31/14.
//  Copyright (c) 2014 Ziyad Parekh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZPConstants : NSObject

#pragma mark - Segues

extern NSString *const kZPLoginToHomeSegue;

#pragma mark - User Profile Class

extern NSString *const kZPUserProfileNameKey;
extern NSString *const kZPUserProfileFirstNameKey;
extern NSString *const kZPUserProfileLastNameKey;
extern NSString *const kZPUserProfileGenderKey;
extern NSString *const kZPUserProfileKey;
extern NSString *const kZPUserProfileFriendsListKey;
extern NSString *const kZPUserProfilePictureURL;

#pragma mark - User Photo Class

extern NSString *const kZPPhotoClassKey;
extern NSString *const kZPPhotoUserKey;
extern NSString *const kZPPhotoPictureKey;

@end
