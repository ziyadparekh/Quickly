//
//  ZPTestViewController.m
//  Quickly
//
//  Created by Ziyad Parekh on 1/1/15.
//  Copyright (c) 2015 Ziyad Parekh. All rights reserved.
//

#import "ZPTestViewController.h"

@interface ZPTestViewController ()
- (IBAction)cancelBarButtonItemPressed:(UIBarButtonItem *)sender;


@end

@implementation ZPTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)cancelBarButtonItemPressed:(UIBarButtonItem *)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
@end
