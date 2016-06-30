//
//  WeChatDetailViewController.m
//  AFNetworking
//
//  Created by 黄明族 on 16/6/30.
//  Copyright © 2016年 黄明族. All rights reserved.
//

#import "WeChatDetailViewController.h"
#import "WebViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface WeChatDetailViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)NSArray *dataArray;

@end

@implementation WeChatDetailViewController {
    UITableView *WechatTableView;
}


-(NSArray *)dataArray {
    if (!_dataArray) {
        NSLog(@"dictionary:...%@", self.resultArray);
        _dataArray = self.resultArray;
    }
    return _dataArray;
}

-(instancetype)init {
    if (self = [super init]) {
        
    }
    return self;
}

-(void)UIInit {
    WechatTableView = [[UITableView alloc] init];
    WechatTableView .frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    WechatTableView.delegate = self;
    WechatTableView.dataSource = self;
    WechatTableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    [self.view addSubview:WechatTableView];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.automaticallyAdjustsScrollViewInsets = NO;
//    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self UIInit];
}


#pragma mark - tableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identity = @"identity";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identity];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identity];
    }
    NSDictionary *dic = self.dataArray[indexPath.row];
    NSString *urlString = dic[@"firstImg"];
    NSString *textStr = dic[@"title"];
    NSURL *ImageUrl = [NSURL URLWithString:urlString];
    //图片，精选的详细名称，以及点击跳转的webView页面。
    [cell.imageView sd_setImageWithURL:ImageUrl placeholderImage:[UIImage new]];
    [cell.textLabel setFont:[UIFont systemFontOfSize:10]];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.text = textStr;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = self.dataArray[indexPath.row];
    NSString *urlStr = dic[@"url"];
    NSURL *detailUrl = [NSURL URLWithString:urlStr];
    NSLog(@"当前选中的URL：...%@", detailUrl);
    WebViewController *webvc = [[WebViewController alloc] init];
    webvc.url = detailUrl;
    [self.navigationController pushViewController:webvc animated:YES];
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

@end
