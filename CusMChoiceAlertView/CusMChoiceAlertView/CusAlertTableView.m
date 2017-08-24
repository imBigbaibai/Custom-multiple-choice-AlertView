//
//  CusAlertTableView.m
//  StoreKit App内显示评分
//
//  Created by admin on 2017/8/23.
//  Copyright © 2017年 xuwenbo. All rights reserved.
//

#import "CusAlertTableView.h"

//这些设置颜色的宏，可以放到 pch 文件里
#define HColor(rgbValue) HColorWithAlpha(rgbValue,1)

#define HColorWithAlpha(rgbValue,alphaValue) [UIColor colorWithRed:((float)((rgbValue &0xFF0000) >>16))/255.0 green:((float)((rgbValue &0xFF00) >>8))/255.0 blue:((float)(rgbValue &0xFF))/255.0 alpha:alphaValue]      //16进制宏定义

#define KBaseColor HColor(0x279ef2)
#define KGrayColor HColor(0xf6f6f6)

#define kScreenWidth      CGRectGetWidth([UIScreen mainScreen].applicationFrame)
#define kScreenHeight     CGRectGetHeight([UIScreen mainScreen].applicationFrame)

//对内作用域
@interface CusAlertTableView()
{
    BOOL isShow;//判断是否显示AlertView
    NSMutableArray *allNews;//选中的所有行的信息拼接到一起
}
@property (nonatomic, retain) NSMutableArray *otherButtonTitles;


@end

// 设置弹出窗的一些高度
const static CGFloat XCustomTopHeight = 5;//标题距离顶部高度

const static CGFloat XCustomTitleHeight = 55;//标题高度
const static CGFloat XCustomBtnHeight = 55;//按钮高度

//const static CGFloat XCustomAlertHeight = 300;//弹窗高度
const static CGFloat XCustomAlertWidth = 250;//弹窗宽度

const static CGFloat XTalbeHeight = 40;//cell高度


@implementation CusAlertTableView


#pragma mark - 在这里我们设置控件的一些属性什么的
- (instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {

        allNews = [NSMutableArray new];
        
        UIView *bgView = [[UIView alloc] init];
        bgView.backgroundColor = [UIColor grayColor];
        bgView.alpha = 0.2;
        [self addSubview:bgView];
        self.bgView = bgView;
        
        
        UIView *alertView = [[UIView alloc] init];
        alertView.backgroundColor = [UIColor whiteColor];
        alertView.layer.cornerRadius = 9.0f;
        [self addSubview:alertView];
        self.alertView = alertView;
        
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.font = [UIFont systemFontOfSize:17.0f];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.alertView addSubview:titleLabel];
        self.title = titleLabel;
        
        
        UIView *lineView = [[UIView alloc]init];
        lineView.backgroundColor = [UIColor lightGrayColor];
        lineView.alpha = 0.5;
        [self.alertView addSubview:lineView];
        self.lineView = lineView;
        
        
        UITableView *myTableView = [[UITableView alloc]init];
        myTableView.delegate = self;
        myTableView.dataSource = self;
        myTableView.scrollEnabled = NO;
        [self.alertView addSubview:myTableView];
        self.myTableView = myTableView;

    }
    return self;
}

#pragma mark - 在这里我们来设置控件的frame
- (void)layoutSubviews{
    
    //必须要调用父类的layoutSubViews 方法
    [super layoutSubviews];
    
    //蒙版背景
    self.bgView.frame = self.frame;
    
    //标题，PS：标题的高度需要计算文字的高度，实现动态
    self.title.frame = CGRectMake(0, XCustomTopHeight, XCustomAlertWidth, XCustomTitleHeight);
    
    self.title.text = self.titleStr;
//    self.title.text = @"我是标题";
    
    //横线,
    self.lineView.frame = CGRectMake(1, CGRectGetMaxY(_title.frame), XCustomAlertWidth-2, 0.5);
    
    //TableView
    if (_alertArr.count>4) {
        self.myTableView.scrollEnabled = YES;
        self.myTableView.frame = CGRectMake(0, CGRectGetMaxY(_lineView.frame), XCustomAlertWidth-2, 160+2);
        
    }else{
        
        self.myTableView.frame = CGRectMake(0, CGRectGetMaxY(_lineView.frame), XCustomAlertWidth-2, XTalbeHeight*_alertArr.count+2);
    }

    //取消，确定等按钮，建议最多3个
    if (_otherButtonTitles) {
        
        //按钮数量
        NSUInteger count = _otherButtonTitles.count;
        
        for (int i = 0; i < _otherButtonTitles.count; i++) {
         
            UIButton *otherBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            
            otherBtn.backgroundColor = [UIColor clearColor];
            
            [otherBtn setTitle:[_otherButtonTitles objectAtIndex:i] forState:UIControlStateNormal];

            //设置按钮 1-2个按钮，按钮按横向摆放
            if ( 3> count >=1) {
                
                otherBtn.frame = CGRectMake(0+i*XCustomAlertWidth/count, CGRectGetMaxY(_myTableView.frame)-2, XCustomAlertWidth/count, XCustomBtnHeight);
            
                if (i == 0) {
            
                    [otherBtn setTitleColor:KBaseColor forState:UIControlStateNormal];
                    
                }else if (i == 1){
                    
                    [otherBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                }
                
                [otherBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
                
                otherBtn.tag = i;
                
                [self.alertView addSubview:otherBtn];
                
                //竖线
                if (count == 2) {
                    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(XCustomAlertWidth/2, CGRectGetMaxY(_myTableView.frame)-2, 0.5, XCustomBtnHeight-4)];
                    lineView.alpha = 0.5;
                    lineView.backgroundColor = [UIColor lightGrayColor];
                    [self.alertView addSubview:lineView];
                    
                }
            
            //如果按钮数量大于2个，按钮将纵列摆放
            }else if (count>2){
                
                otherBtn.frame = CGRectMake(0, CGRectGetMaxY(_myTableView.frame)-2 + XCustomBtnHeight*i, XCustomAlertWidth, XCustomBtnHeight);
                
                if (i == 0) {
                    
                    [otherBtn setTitleColor:KBaseColor forState:UIControlStateNormal];
                    
                }else if (i == 1){
                    
                    [otherBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                    
                }else if (i == 2){
                    
                    [otherBtn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];

                }
                
                [otherBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
                
                otherBtn.tag = i;
                
                [self.alertView addSubview:otherBtn];
                
                //横线
                if (i > 0){
                    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0.5, CGRectGetMaxY(_myTableView.frame)-2 + XCustomBtnHeight*i, XCustomAlertWidth-1, 0.5)];
                    lineView.alpha = 0.5;
                    lineView.backgroundColor = [UIColor lightGrayColor];
                    [self.alertView addSubview:lineView];
                }
            }
        }
        
        //弹窗高
        CGFloat nAlertH;
        
        //按钮数量大于2个
        if (count > 2) {
            
            nAlertH = XCustomTitleHeight + _myTableView.frame.size.height + XCustomBtnHeight*3;
        }else{
            
            nAlertH = XCustomTitleHeight + _myTableView.frame.size.height + XCustomBtnHeight;
        }
        self.alertView.frame = CGRectMake((kScreenWidth-XCustomAlertWidth)/2, (kScreenHeight-nAlertH)/2, XCustomAlertWidth, nAlertH);

    }
}


#pragma mark  设置TableView的代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //分几个区
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //一个区显示多少行
    return [_alertArr count];
}

#pragma mark - 设置Cell 的内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //设置cell的内容
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
    }
    for (UIView *sub in cell.subviews) {
        [sub removeFromSuperview];
    }
    
    //隐藏掉tableView自带横线，并将选择效果设置为 None
    tableView.separatorColor = [UIColor clearColor];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //添加自己的横线
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(1, XTalbeHeight-1, XCustomAlertWidth, 0.5)];
    
    lineView.backgroundColor = [UIColor lightGrayColor];
    
    lineView.alpha = 0.5;
    
    [cell addSubview:lineView];
    
    //设置显示内容
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, XCustomAlertWidth, XTalbeHeight)];
    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.font = [UIFont systemFontOfSize:15.0f];
    textLabel.text = [_alertArr objectAtIndex:indexPath.row];
    [cell addSubview:textLabel];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row=[indexPath row];
    if (row==0) {
//        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        cell.textLabel.textColor=[UIColor redColor];
    }
    
}

-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //NSLog(@"----hello----,%@",indexPath);
    return indexPath;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return XTalbeHeight;
}

#pragma mark - 在tableView选择事件中，将我们选中的值，放到数组里来用（按自己需求来，你也可以直接拼成字符串来用）
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //选择与取消选中
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:NO];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (cell.accessoryType == UITableViewCellAccessoryNone)		{
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
      
        //将选中的行信息拼接
        [allNews addObject:[_alertArr objectAtIndex:indexPath.row]];
        
    }
    else if (cell.accessoryType == UITableViewCellAccessoryCheckmark)	{
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        //取消选中的话，判断contanin字符串中是否包含取消选中的字符，然后删除即可
        if ([allNews containsObject:[_alertArr objectAtIndex:indexPath.row]]) {
            [allNews removeObject:[_alertArr objectAtIndex:indexPath.row]];
        }
    }
}
#pragma mark - TableView代理结束


- (id)init
{
    self = [super initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight + 20)];
    if (self)
    {
        isShow = NO;
    }
    return self;
}

#pragma mark - 初始化方法
- (id)initWithTitle:(NSString *)title delegate:(id)delegate otherButtonTitles:(NSString *)otherButtonTitles, ...
{
    if (self = [self initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight + 20)]) {
        
        self.delegate = delegate;
    
        if (!_otherButtonTitles)
        {
//            编写一些通用类的时候经常会遇到可变参数的处理。就好比 :UIAlertView的init方法中的otherButtonTitles:(NSString *)otherButtonTitles, ...可变参数。
//            
//            iOS实现传递不定长的多个参数的方法是使用va_list
            va_list argList;
            if (otherButtonTitles)
            {
                self.otherButtonTitles = [NSMutableArray array];
                [self.otherButtonTitles addObject:otherButtonTitles];
            }
            va_start(argList, otherButtonTitles);
            id arg;
            while ((arg = va_arg(argList, id)))
            {
                [self.otherButtonTitles addObject:arg];
            }
        }
        self.titleStr = title;

    }
    return self;
}

- (void)initTitle:(NSString *)title delegate:(id)delegate otherButtonTitles:(NSString *)otherButtonTitles, ...
{
    if (self) {
        
        self.delegate = delegate;
        
        if (_otherButtonTitles.count > 0)
        {
            //            编写一些通用类的时候经常会遇到可变参数的处理。就好比 :UIAlertView的init方法中的otherButtonTitles:(NSString *)otherButtonTitles, ...可变参数。
            //
            //            iOS实现传递不定长的多个参数的方法是使用va_list
            va_list argList;
            if (otherButtonTitles)
            {
                self.otherButtonTitles = [NSMutableArray array];
                [self.otherButtonTitles addObject:otherButtonTitles];
            }
            va_start(argList, otherButtonTitles);
            id arg;
            while ((arg = va_arg(argList, id)))
            {
                [self.otherButtonTitles addObject:arg];
            }
        }
        self.titleStr = title;
        
    }
}
#pragma mark - 显示 AlertView 视图
- (void)show
{
    if (!isShow){
        [[[UIApplication sharedApplication].delegate window]  addSubview:self];
        
    }
    isShow = YES;
}

#pragma mark - 取消，确定按钮点击事件
- (void)buttonClicked:(id)sender
{
    UIButton *btn = (UIButton *) sender;
    isShow = NO;
    if (btn)
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(alertView:clickedButtonAtIndex:)])
        {
            [self.delegate mbAlertView:self clickedButtonAtIndex:btn.tag moveData:allNews];
        }
        [self removeFromSuperview];
    }
}
@end
