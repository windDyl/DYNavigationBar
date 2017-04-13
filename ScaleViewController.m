//
//  ScaleViewController.m
//  NavigationBarSample
//
//  Created by Ethank on 2016/3/15.
//  Copyright © 2016年 DY. All rights reserved.
//

#import "ScaleViewController.h"

// 导航栏高度
#define kNavBarH 64.0f
// 头部图片的高度
#define kHeardH 260

#define kWidth [[UIScreen mainScreen] bounds].size.width

@interface ScaleViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong)UITableView *tabView;
@property (nonatomic, strong)UIImageView *scaleImageView;
@property (nonatomic, strong)UIView *navigationView;
@property (nonatomic, assign)CGFloat lastOffsetY;
@end

@implementation ScaleViewController

#pragma mark- 懒加载

-(UITableView *)tabView {
    if (_tabView == nil) {
        UITableView *tabview = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        tabview.contentInset = UIEdgeInsetsMake(kHeardH - 35, 0, 0, 0);
        tabview.dataSource = self;
        tabview.delegate = self;
        tabview.rowHeight = 100;
        [tabview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"ScaleCell"];
        tabview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tabView = tabview;
    }
    return _tabView;
}
// 图片的懒加载
- (UIImageView *)scaleImageView
{
    if (_scaleImageView == nil) {
        _scaleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background"]];
        _scaleImageView.contentMode = UIViewContentModeScaleAspectFill;
        _scaleImageView.layer.masksToBounds = YES;
        _scaleImageView.frame = CGRectMake(0, 0, kWidth, kHeardH);
    }
    return _scaleImageView;
}

// 自定义导航栏
-(UIView *)navigationView{
    
    if(_navigationView == nil){
        _navigationView = [[UIView alloc]init];
        _navigationView.frame = CGRectMake(0, 0, kWidth, kNavBarH);
        _navigationView.backgroundColor = [UIColor clearColor];
        _navigationView.alpha = 1.0;
        
        //添加子控件
        [self configNavigationBar];
    }
    return _navigationView;
}

#pragma mark -lifecircle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor orangeColor];
    self.lastOffsetY = - kHeardH + 35;
    
    [self.view addSubview:self.tabView];
    
    [self.view addSubview:self.scaleImageView];
    
    [self.view addSubview:self.navigationView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

#pragma mark-private

- (void)configNavigationBar{
    //左边返回按钮
    UIButton *backBtn = [[UIButton alloc]init];
    backBtn.frame = CGRectMake(0, 20, 44, 44);
    [backBtn setImage:[UIImage imageNamed:@"nav_detail_back_btn_s"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    //右边分享按钮
    UIButton *shartBtn = [[UIButton alloc]init];
    shartBtn.frame = CGRectMake(kWidth-44, 20, 44, 44);
    [shartBtn setImage:[UIImage imageNamed:@"activity_share_ic"] forState:UIControlStateNormal];
    [shartBtn addTarget:self action:@selector(shareBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationView addSubview:backBtn];
    [self.navigationView addSubview:shartBtn];
}
// 返回
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)shareBtnClick {
    NSLog(@"share");
}


#pragma mark- UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ScaleCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor cyanColor];
    cell.textLabel.text = @"text";
    return cell;
}

#pragma mark -UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001f;
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    // 计算当前偏移位置
    CGFloat offsetY = scrollView.contentOffset.y;
    CGFloat delta = offsetY - _lastOffsetY;
    NSLog(@"delta=%f",delta);
    NSLog(@"offsetY=%f",offsetY);
    CGFloat height = kHeardH - delta;
    NSLog(@"height = %f", height);
    
    self.scaleImageView.frame = CGRectMake(0, 0, CGRectGetWidth([[UIScreen mainScreen] bounds]), height);
    
    CGFloat alpha = delta / (kHeardH - kNavBarH);
    if (alpha >= 1.0) {
        alpha = 1.0;
    }
//    self.navigationView.alpha = alpha;
    [self.navigationView setBackgroundColor:[[UIColor orangeColor] colorWithAlphaComponent:alpha]];
}

@end
