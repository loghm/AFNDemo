//
//  WebViewController.m
//  AFNetworking
//
//  Created by 黄明族 on 16/6/30.
//  Copyright © 2016年 黄明族. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController {
    UIWebView *webView;

}

-(void)UIInit {
    webView = [[UIWebView alloc] init];
    webView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    [self.view addSubview:webView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //不延伸
    self.edgesForExtendedLayout = NO;
    [self UIInit];
    NSURLRequest *request = [NSURLRequest requestWithURL:self.url];
    [webView loadRequest:request];
    
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
