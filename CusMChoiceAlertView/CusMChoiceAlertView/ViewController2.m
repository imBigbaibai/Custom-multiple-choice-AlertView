//
//  ViewController2.m
//  StoreKit App内显示评分
//
//  Created by admin on 2017/8/23.
//  Copyright © 2017年 xuwenbo. All rights reserved.
//

#import "ViewController2.h"
#import "CusAlertTableView.h"

@interface ViewController2 ()<MBAlertViewDelegate>

@end

@implementation ViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor orangeColor];
    
    UIButton *buton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    buton.frame = CGRectMake(100, 20, 100, 100);
    buton.backgroundColor = [UIColor yellowColor];
    [buton setTitle:@"点我返回" forState:UIControlStateNormal];
    [buton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [buton addTarget:self action:@selector(goBacka) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buton];
    
    
    CusAlertTableView *cusView = [[CusAlertTableView alloc] initWithTitle:@"我是一个‘小’标题" delegate:self otherButtonTitles: @"确定",@"警告",nil];
    cusView.alertArr = @[@"123",@"打",@"过去玩",@"qwe"];
    [cusView show];
    
}
- (void)goBacka{

    [self dismissModalViewControllerAnimated:YES];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"123");
}
-(void)mbAlertView:(CusAlertTableView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex moveData:(NSMutableArray *)allNews{
    
    NSLog(@"%@",allNews);
    switch (buttonIndex) {
        case 0:
            NSLog(@"取消");
            break;
        case 1:
            NSLog(@"确定");
            break;
        default:
            break;
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
