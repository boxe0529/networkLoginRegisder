//
//  ViewController.m
//  网络版的登陆和注册
//
//  Created by 邓云方 on 15/9/12.
//  Copyright (c) 2015年 邓云方. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property(nonatomic,strong)NSTimer * timer;
@property(nonatomic,strong)CAShapeLayer * shapelayer;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.uname addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    _shapelayer=[CAShapeLayer layer];
    _shapelayer.frame=CGRectMake(40, 250, 200, 40);
    _shapelayer.position=self.view.center;
    //_shapelayer.path=
    _shapelayer.fillColor=[UIColor clearColor].CGColor;
    _shapelayer.strokeColor=[UIColor redColor].CGColor;
    _shapelayer.lineWidth =2.f;
    [self.view.layer addSublayer:_shapelayer];
    _timer =[NSTimer scheduledTimerWithTimeInterval:1.f target:self selector:@selector(pathAnimation) userInfo:nil repeats:YES];
    // Do any additional setup after loading the view, typically from a nib.
}
-(void)pathAnimation
{
    static int i=0;
    if(i++ %2==0)
    {
        CABasicAnimation * cirle=[CABasicAnimation animationWithKeyPath:@"path"];
        cirle.removedOnCompletion=NO;
        cirle.duration=1;
        
    }
}
//输入框限制字数
- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField == self.uname) {
        if (textField.text.length > 10) {
            textField.text = [textField.text substringToIndex:10];
        }
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)shake
{
    
    CAKeyframeAnimation *animationKey = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    [animationKey setDuration:0.5f];
    
    NSArray *array = [[NSArray alloc] initWithObjects:
                      [NSValue valueWithCGPoint:CGPointMake(self.uname.center.x, self.uname.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(self.uname.center.x-5, self.uname.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(self.uname.center.x, self.uname.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(self.uname.center.x-5, self.uname.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(self.uname.center.x, self.uname.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(self.uname.center.x-5, self.uname.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(self.uname.center.x, self.uname.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(self.uname.center.x-5, self.uname.center.y)],
                      nil];
    [animationKey setValues:array];

    
    NSArray *times = [[NSArray alloc] initWithObjects:
                      [NSNumber numberWithFloat:0.1f],
                      [NSNumber numberWithFloat:0.2f],
                      [NSNumber numberWithFloat:0.3f],
                      [NSNumber numberWithFloat:0.4f],
                      [NSNumber numberWithFloat:0.5f],
                      [NSNumber numberWithFloat:0.6f],
                      [NSNumber numberWithFloat:0.7f],
                      [NSNumber numberWithFloat:0.8f],
                      [NSNumber numberWithFloat:0.9f],
                      [NSNumber numberWithFloat:1.0f],
                      nil];
    [animationKey setKeyTimes:times];
    
    
    [self.uname.layer addAnimation:animationKey forKey:@"TextFieldShake"];
}
- (IBAction)login:(id)sender
{
    
    NSString * name= self.uname.text;
    NSString * pasw=self.pasw.text;
    
    name=[name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    pasw=[pasw stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if([name isEqualToString:@""]||[pasw isEqualToString:@""])
    {
        UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"" message:@"name or pasword is whitespace!" delegate:nil cancelButtonTitle:@"i know" otherButtonTitles:nil, nil];
        [alert show];
        self.uname.text=@"";
        [self.uname becomeFirstResponder];
        return;
    }
    [self disablesAutomaticKeyboardDismissal];
    //[self lockview:@"登陆中" andbool:NO andsender:self.loginbut];
    NSString * path=[NSString stringWithFormat:@"http://192.168.0.106/php/login.php?action=login&name=%@&pass=%@",name,pasw];
    NSLog(@"%@",path);
    NSURL * url=[NSURL URLWithString:path];
    NSURLRequest * request=[NSURLRequest requestWithURL:url];
    //NSURLResponse * resp;
    NSData * data=[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if(data==nil)
    {
        
        UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"" message:@"连接服务器失败，请检查网络连接。" delegate:nil cancelButtonTitle:@"i know" otherButtonTitles:nil, nil];
        [alert show];
        
    }
    else
    {
        NSString * str=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@",str);
        NSRange range=[str rangeOfString:@"login成功"];
        if(range.location!=NSNotFound)
        {
            UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"" message:@"登陆成功" delegate:nil cancelButtonTitle:@"i know" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
        range=[str rangeOfString:@"login失败"];
        if(range.location!=NSNotFound)
        {
            UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"" message:@"账号或密码错误，登陆失败" delegate:nil cancelButtonTitle:@"i know" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
        
        UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"" message:@"登陆失败，请稍后再试!" delegate:nil cancelButtonTitle:@"i know" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
   
}

- (IBAction)register:(id)sender
{
    
    [self shake];
    NSString * name= self.uname.text;
    NSString * pasw=self.pasw.text;
    name=[name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    pasw=[pasw stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if([name isEqualToString:@""]||[pasw isEqualToString:@""])
    {
        UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"" message:@"name or pasword is whitespace!" delegate:nil cancelButtonTitle:@"i know" otherButtonTitles:nil, nil];
        //[alert show];
        self.uname.text=@"";
        [self.uname becomeFirstResponder];
        return;
    }
    [self disablesAutomaticKeyboardDismissal];
    //[self lockview:@"登陆中" andbool:NO andsender:self.loginbut];
    NSString * path=[NSString stringWithFormat:@"http://192.168.0.106/php/login.php?action=register&name=%@&pass=%@",name,pasw];
    NSLog(@"%@",path);
    NSURL * url=[NSURL URLWithString:path];
    NSURLRequest * request=[NSURLRequest requestWithURL:url];
    //NSURLResponse * resp;
    NSData * data=[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if(data==nil)
    {
        
        UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"" message:@"连接服务器失败，请检查网络连接。" delegate:nil cancelButtonTitle:@"i know" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        NSString * str=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@",str);
        NSRange range=[str rangeOfString:@"恭喜你"];
        if(range.location!=NSNotFound)
        {
            UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"" message:@"注册成功" delegate:nil cancelButtonTitle:@"i know" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
        range=[str rangeOfString:@"存在"];
        if(range.location!=NSNotFound)
        {
            UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"" message:@"用户名已经存在" delegate:nil cancelButtonTitle:@"i know" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
        
        UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"" message:@"注册失败，请稍后再试!" delegate:nil cancelButtonTitle:@"i know" otherButtonTitles:nil, nil];
        [alert show];
        return;
      
    }

}
- (IBAction)closekey:(id)sender {
}

- (IBAction)colsek:(id)sender
{
    [self.uname resignFirstResponder];
    [self.pasw resignFirstResponder];
}

//限制输入框字数
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
{
    if ([string isEqualToString:@"\n"])
    {
        return YES;
    }
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (self.uname == textField)
    {
        if ([toBeString length] > 20) {
            textField.text = [toBeString substringToIndex:20];
            //UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"" message:@"12312!" delegate:nil cancelButtonTitle:@"i know" otherButtonTitles:nil, nil];
           // [alert show];
            return NO;
        }
    }
    return YES;
}
// 手机号合法性检查
- (BOOL)isMobileNumber:(NSString *)mobileNum
{
    
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (IBAction)login1:(id)sender
{
    isAction=NO;
    NSString * name= self.uname.text;
    NSString * pasw=self.pasw.text;
    BOOL B= [self isMobileNumber:name];
    if(!B)
    {
        UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"" message:@"手机号不合法" delegate:nil cancelButtonTitle:@"i know" otherButtonTitles:nil, nil];
        [alert show];
        return;
 
    }
    name=[name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    pasw=[pasw stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if([name isEqualToString:@""]||[pasw isEqualToString:@""])
    {
        UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"" message:@"name or pasword is whitespace!" delegate:nil cancelButtonTitle:@"i know" otherButtonTitles:nil, nil];
        [alert show];
        self.uname.text=@"";
        [self.uname becomeFirstResponder];
        return;
    }
    [self disablesAutomaticKeyboardDismissal];
    //[self lockview:@"登陆中" andbool:NO andsender:self.loginbut];
    NSString * path=[NSString stringWithFormat:@"http://192.168.0.106/php/login.php?action=login&name=%@&pass=%@",name,pasw];
    NSLog(@"%@",path);
    NSURL * url=[NSURL URLWithString:path];
    NSURLRequest * request=[NSURLRequest requestWithURL:url];
    NSURLConnection * conn=[NSURLConnection connectionWithRequest:request delegate:self];
    if(conn==nil)
    {
        
        UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"" message:@"连接服务器失败，请检查网络连接。" delegate:nil cancelButtonTitle:@"i know" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    else
    {
        receivedata=[[NSMutableData alloc]init];
    }
}

-(IBAction)register1:(id)sender
{
    isAction=YES;
    NSString * name= self.uname.text;
    NSString * pasw=self.pasw.text;
    name=[name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    pasw=[pasw stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if([name isEqualToString:@""]||[pasw isEqualToString:@""])
    {
        UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"" message:@"name or pasword is whitespace!" delegate:nil cancelButtonTitle:@"i know" otherButtonTitles:nil, nil];
        [alert show];
        self.uname.text=@"";
        [self.uname becomeFirstResponder];
        return;
    }
    [self disablesAutomaticKeyboardDismissal];
    //[self lockview:@"登陆中" andbool:NO andsender:self.loginbut];
    NSString * path=[NSString stringWithFormat:@"http://192.168.0.106/php/login.php?action=register&name=%@&pass=%@",name,pasw];
    NSLog(@"%@",path);
    NSURL * url=[NSURL URLWithString:path];
    NSURLRequest * request=[NSURLRequest requestWithURL:url];
    NSURLConnection * conn=[NSURLConnection connectionWithRequest:request delegate:self];
    if(conn==nil)
    {
        
        UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"" message:@"连接服务器失败，请检查网络连接。" delegate:nil cancelButtonTitle:@"i know" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    else
    {
        receivedata=[[NSMutableData alloc]init];
    }

}
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"response");
    [receivedata setLength:0];
}
//接受数据 可能产生多次 如果数据量大
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
     NSLog(@"receivingdata");
    [receivedata appendData:data];
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
     NSLog(@"finishload");
    NSString * str=[[NSString alloc]initWithData:receivedata encoding:NSUTF8StringEncoding];
    NSLog(@"%@",str);
     NSRange range=[str rangeOfString:@"login成功"];
    if(!isAction)
    {
    if(range.location!=NSNotFound)
    {
        UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"" message:@"登陆成功" delegate:nil cancelButtonTitle:@"i know" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    range=[str rangeOfString:@"login失败"];
    if(range.location!=NSNotFound)
    {
        UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"" message:@"账号或密码错误，登陆失败" delegate:nil cancelButtonTitle:@"i know" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"" message:@"登陆失败，请稍后再试!" delegate:nil cancelButtonTitle:@"i know" otherButtonTitles:nil, nil];
    [alert show];
        return;
        
    }
    else
    {
        range=[str rangeOfString:@"恭喜你"];
        if(range.location!=NSNotFound)
        {
            UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"" message:@"注册成功" delegate:nil cancelButtonTitle:@"i know" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
        range=[str rangeOfString:@"存在"];
        if(range.location!=NSNotFound)
        {
            UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"" message:@"用户名已经存在" delegate:nil cancelButtonTitle:@"i know" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
        
        UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"" message:@"注册失败，请稍后再试!" delegate:nil cancelButtonTitle:@"i know" otherButtonTitles:nil, nil];
        [alert show];
        return;
 
    }

}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
     NSLog(@"error");
    UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"" message:@"连接服务器失败，请检查网络连接。" delegate:nil cancelButtonTitle:@"i know" otherButtonTitles:nil, nil];
    [alert show];
    return;
}


- (IBAction)call:(id)sender {
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://10086"]];
}
@end
