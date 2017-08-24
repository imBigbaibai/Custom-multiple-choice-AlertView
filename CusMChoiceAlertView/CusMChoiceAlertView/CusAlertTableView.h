//
//  CusAlertTableView.h
//  StoreKit App内显示评分
//
//  Created by admin on 2017/8/23.
//  Copyright © 2017年 xuwenbo. All rights reserved.
//

#import <UIKit/UIKit.h>

#warning 现在每一行没有图片，我们可以在tableView的行里设置图片
@class CusAlertTableView;

@protocol MBAlertViewDelegate <NSObject>

@optional

// - 代理方法
-(void)mbAlertView:(CusAlertTableView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex moveData:(NSMutableArray *)allNews;
-(void)alertViewClosed:(CusAlertTableView *)alertView;
-(void)willPresentCustomAlertView:(UIView *)alertView;

// - 隐藏实用类弹出键盘
- (void)hideCurrentKeyBoard;

@end

@interface CusAlertTableView : UIView<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, assign) id <MBAlertViewDelegate> delegate;

@property(nonatomic, strong)UILabel *title;//标题文字
@property(nonatomic, copy)NSString *titleStr;
@property(nonatomic, strong)UIColor *titleColor;//标题颜色

@property(nonatomic, strong)UIButton *cButton;//取消确定按钮

@property(nonatomic, strong)UIView *bgView;//蒙版背景视图
@property(nonatomic, strong)UIView *alertView;//弹窗视图

@property(nonatomic, strong)UITableView *myTableView;//
@property(nonatomic, strong)UIView *lineView;//横线

@property(nonatomic, strong)NSArray *alertArr;//显示内容数组


//初始化方法，title=弹窗框标题，otherButtonTitles=确定、取消按钮等。
- (id)initWithTitle:(NSString *)title delegate:(id)delegate otherButtonTitles:(NSString *)otherButtonTitles,... NS_REQUIRES_NIL_TERMINATION;

- (void)initTitle:(NSString *)title delegate:(id)delegate otherButtonTitles:(NSString *)otherButtonTitles,... NS_REQUIRES_NIL_TERMINATION;

- (void)show;

@end
