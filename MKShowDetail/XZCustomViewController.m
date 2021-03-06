//
//  XZCustomViewController.m
//  DetailShow
//
//  Created by 微指 on 16/3/7.
//  Copyright © 2016年 CityNight. All rights reserved.
//

#import "XZCustomViewController.h"

@interface XZCustomViewController () <UITableViewDelegate>

@property (nonatomic, assign) CGFloat lastOffsetY;
@property (nonatomic, assign) CGFloat alpha;
@end

@implementation XZCustomViewController
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.view.hidden = NO;
}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.view.hidden = YES;
}
-(void)viewDidLoad {
    
    if ([self respondsToSelector:@selector( setAutomaticallyAdjustsScrollViewInsets:)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.view.backgroundColor = [UIColor whiteColor];
    
    _lastOffsetY = -(kHeadViewH+ kTitleBarH);
    
    // 设置顶部额外滚动区域
    self.tableView.contentInset = UIEdgeInsetsMake(kHeadViewH + kTitleBarH , 0, 0, 0);
    
    XZTableView *tableView = (XZTableView *)self.tableView;
    tableView.tabBar = _titleBar;
}

-(XZTableView *)tableView {
    if (!_tableView) {
        _tableView = [[XZTableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
        _tableView.delegate = self;
        _tableView.tag = 1024;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}
CGFloat oldTop = 0;
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.tag == 1024) {
        // 获取当前偏移量
        CGFloat offsetY = scrollView.contentOffset.y;
        
        // 获取偏移量差值
        CGFloat delta = offsetY - _lastOffsetY ;
        
        CGFloat headH = kHeadViewH - delta;
        
        if (headH < kHeadViewMinH) {
            headH = kHeadViewMinH;
        }
        _headHCons.constant = headH;
        
        CGFloat top = headH +kTitleBarH;
        if (top>=kTitleBarH +kHeadViewH) {
            top = kTitleBarH + kHeadViewH;
        }
        if (oldTop !=top) {
            self.tableView.contentInset = UIEdgeInsetsMake(top, 0, 0, 0);
            oldTop = top;
        }
        // 计算透明度，刚好拖动200 - 64 136，透明度为1
        
        CGFloat alpha = delta / (kHeadViewH - kHeadViewMinH);
        if (self.changeNavigationBar) {
            self.changeNavigationBar(alpha);
        }
    }
}

@end
