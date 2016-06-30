//
//  NetManager.m
//  AFNetworking
//
//  Created by 黄明族 on 16/6/28.
//  Copyright © 2016年 黄明族. All rights reserved.
//

#import "NetManager.h"
#import <AFHTTPSessionManager.h>


@implementation NetManager

+(void)requestData:(NSString *)urlString HTTPMethod:(NSString *)method params:(NSMutableDictionary *)params completionHandle:(void (^)(id))completionblock errorHandle:(void (^)(NSError *))errorblock {
    
    // 初始化Manager
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    // 不加上这句话，会报“Request failed: unacceptable content-type: text/plain”错误，因为我们要获取text/plain类型数据
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    // post请求
    [manager POST:urlString parameters:params constructingBodyWithBlock:^(id  _Nonnull formData) {
        // 拼接data到请求体，这个block的参数是遵守AFMultipartFormData协议的。
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        // 这里可以获取到目前的数据请求的进度
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        // 请求成功，解析数据
        NSLog(@"%@", responseObject);
        completionblock(responseObject);
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
        
        NSLog(@"%@", dic);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        errorblock(error);
        // 请求失败
        NSLog(@"%@", [error localizedDescription]);
    }];
}

@end
