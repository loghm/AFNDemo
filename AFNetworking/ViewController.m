//
//  ViewController.m
//  AFNetworking
//
//  Created by 黄明族 on 16/6/27.
//  Copyright © 2016年 黄明族. All rights reserved.
//

#import "ViewController.h"
#import "NetManager.h"
#import "WeChatDetailViewController.h"

#import <AFHTTPSessionManager.h>


#define BASE_URL @"http://op.juhe.cn/robot/index?"
#define SCREEN_WIDTH self.view.frame.size.width

//实现问答机器人

@interface ViewController ()<UITextFieldDelegate>

@property (nonatomic, strong)NSString *resultStr;

@end

@implementation ViewController {
    UITextField *questionTextField;
    UILabel *answerLabel;
    UIButton *startBtn;
    UIButton *weixinBtn;
    NSString *questionStr;

    //网络请求类
    NetManager *manager;
    
    NSDictionary *resultArray;
    NSMutableArray *wechatDic;
}

-(void)UIInit {
    resultArray = [NSDictionary dictionary];
    wechatDic = [NSDictionary dictionary];
    manager = [[NetManager alloc] init];
    self.view.backgroundColor = [UIColor colorWithRed:162.0/255 green:205.0/255 blue:249.0/255 alpha:1];
    questionTextField = [[UITextField alloc] init];
    questionTextField.delegate = self;
    answerLabel = [[UILabel alloc] init];
    questionTextField.backgroundColor = [UIColor whiteColor];
    answerLabel.backgroundColor = [UIColor whiteColor];
    questionTextField.frame = CGRectMake(0, 0, 0.8*SCREEN_WIDTH, 50);
    questionTextField.center = self.view.center;
    
    
    answerLabel.frame = CGRectMake(0,0,0.8*SCREEN_WIDTH,30);
    [answerLabel setNumberOfLines:0];
    answerLabel.center = CGPointMake(self.view.center.x, questionTextField.center.y-150);
    
    
    startBtn = [[UIButton alloc] init];
    startBtn.frame = CGRectMake(0, 0, 100, 50);
    startBtn.center = CGPointMake(self.view.center.x, questionTextField.center.y+100);
    startBtn.backgroundColor = [UIColor blueColor];
    [startBtn addTarget:self action:@selector(start) forControlEvents:UIControlEventTouchUpInside];
    
    weixinBtn = [[UIButton alloc] init];
    weixinBtn.frame = CGRectMake(0, 0, 100, 50);
    [weixinBtn setTitle:@"微信精选" forState:UIControlStateNormal];
    weixinBtn.center = CGPointMake(self.view.center.x, startBtn.center.y+60);
    weixinBtn.backgroundColor = [UIColor grayColor];
    [weixinBtn addTarget:self action:@selector(weixin) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.view addSubview:startBtn];
    [self.view addSubview:weixinBtn];
    [self.view addSubview:questionTextField];
    [self.view addSubview:answerLabel];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    //视图取消第一响应者
    [self.view endEditing:YES];
}

#pragma mark - textfield的代理方法
-(void)textFieldDidEndEditing:(UITextField *)textField {
    questionStr = textField.text;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    textField.text = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self UIInit];
    [self checkNetStatus];
}

//在给resultStr赋值的时候，进行label的frame的设置
-(void)setResultStr:(NSString *)resultStr {
    _resultStr = resultStr;
    CGSize size = [self getLabelSizeWithLabel:answerLabel andLineSpacing:6 andText:resultStr];
    NSLog(@"size:...%f", size.height);
    answerLabel.frame = CGRectMake(0, 0, size.width, size.height);
    answerLabel.center = CGPointMake(self.view.center.x, questionTextField.center.y-150);
}

#pragma mark - 检测网络状态
-(void)checkNetStatus {
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    // 检测网络连接的单例,网络变化时的回调方法
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSLog(@"status:....%ld", (long)status);
    }];
}
#pragma mark - 开始网络请求事件
-(void)start {
    /*
    NSString *urlString = [NSString stringWithFormat:@"info=%@&key=21078b7888033e4ded76671929b0bb18", questionStr];
    NSString *requestString = [BASE_URL stringByAppendingString:urlString];
    requestString = [requestString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    //初始化
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manger POST:requestString parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"response:....%@", responseObject);
        resultArray = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
        if (resultArray[@"result"][@"text"]) {
            answerLabel.text = resultArray[@"result"][@"text"];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error:...%@", [error description]);
    }];
     */
    
    if ([questionStr isEqualToString:@""]) {
        answerLabel.text = @"请输入提问内容。。";
        return;
    }
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:questionStr, @"info", @"21078b7888033e4ded76671929b0bb18", @"key", nil];
    [NetManager requestData:@"http://op.juhe.cn/robot/index?" HTTPMethod:@"post" params:dic completionHandle:^(id result) {
         resultArray = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
        answerLabel.text = resultArray[@"result"][@"text"];
        self.resultStr = resultArray[@"result"][@"text"];
    } errorHandle:^(NSError *error) {
        NSLog(@"error:...%@", [error description]);
    }];
    
}

-(void)weixin {
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"9897c2acf7bee835d3e9513d88e11a1a", @"key", nil];
    [NetManager requestData:@"http://v.juhe.cn/weixin/query?" HTTPMethod:@"post" params:dic completionHandle:^(id result) {
        NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
        wechatDic = resultDic[@"result"][@"list"];
        NSLog(@"resultDic:...%@", resultDic[@"result"][@"list"][0][@"title"]);
        WeChatDetailViewController *chat = [[WeChatDetailViewController alloc] init];
        chat.resultArray = wechatDic;
        NSLog(@"chat:...%@", chat.resultArray);
        [self.navigationController pushViewController:chat animated:YES];
    } errorHandle:^(NSError *error) {
        NSLog(@"error:...%@", [error description]);
    }];
   

}




#pragma mark - 自适应的label的size
//获取自适应的label的size
-(CGSize)getLabelSizeWithLabel:(UILabel *)label andLineSpacing:(CGFloat)lineSpacing andText:(NSString *)text{
    if (text == nil) {
        return CGSizeZero;
    }
    label.numberOfLines = 0;
    CGFloat oneRowHeight = [text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}].height;
    CGSize textSize = [text boundingRectWithSize:CGSizeMake(0.8*SCREEN_WIDTH, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
    
    NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:text];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentJustified;
    [paragraphStyle setLineSpacing:lineSpacing];
    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
    
    CGFloat rows = textSize.height / oneRowHeight;
    CGFloat realHeight = oneRowHeight;
    if (rows > 1) {
        realHeight = (rows * oneRowHeight) + (rows - 1) * lineSpacing;
    }
    [label setAttributedText:attributedString1];
    //    * 返回该label的长宽
    return CGSizeMake(textSize.width, realHeight);
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
