//
//  ZPHomeViewController.m
//  Quickly
//
//  Created by Ziyad Parekh on 12/31/14.
//  Copyright (c) 2014 Ziyad Parekh. All rights reserved.
//

#import "ZPHomeViewController.h"
#import <Parse/Parse.h>

@interface ZPHomeViewController ()
@property (strong, nonatomic) IBOutlet UIButton *logoutButton;

@end

@implementation ZPHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)logoutButtonPressed:(UIButton *)sender
{
    [PFUser logOut];
    [self.navigationController popToRootViewControllerAnimated:YES];
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
