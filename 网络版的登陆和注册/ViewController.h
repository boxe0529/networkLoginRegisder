//
//  ViewController.h
//  网络版的登陆和注册
//
//  Created by 邓云方 on 15/9/12.
//  Copyright (c) 2015年 邓云方. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<NSURLConnectionDataDelegate>
{
    NSMutableData * receivedata;
    BOOL isAction; // yes register no login
}
@property (weak, nonatomic) IBOutlet UITextField *pasw;
- (IBAction)call:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *uname;
- (IBAction)login:(id)sender;
- (IBAction)register:(id)sender;
- (IBAction)closekey:(id)sender;

- (IBAction)colsek:(id)sender;

- (IBAction)login1:(id)sender;
- (IBAction)register1:(id)sender;
- (BOOL)isMobileNumber:(NSString *)mobileNum;
- (void)shake;
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
@end

