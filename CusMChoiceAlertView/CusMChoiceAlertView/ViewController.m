//
//  ViewController.m
//  CusMChoiceAlertView
//
//  Created by admin on 2017/8/24.
//  Copyright © 2017年 xuwenbo. All rights reserved.
//

#import "ViewController.h"
#import "ViewController2.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *buton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    buton.frame = CGRectMake(100, 200, 100, 100);
    buton.backgroundColor = [UIColor yellowColor];
    [buton setTitle:@"点我啊" forState:UIControlStateNormal];
    [buton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [buton addTarget:self action:@selector(asd) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buton];
    
}

- (void)asd{
    
    ViewController2 *v2 = [[ViewController2 alloc] init];
    
    [self presentViewController:v2 animated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
