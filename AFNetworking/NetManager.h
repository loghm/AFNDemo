//
//  NetManager.h
//  AFNetworking
//
//  Created by 黄明族 on 16/6/28.
//  Copyright © 2016年 黄明族. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetManager : NSObject


+ (void)requestData:(NSString *)urlString HTTPMethod:(NSString *)method  params:(NSMutableDictionary *)params completionHandle:(void(^)(id result))completionblock errorHandle:(void(^)(NSError *error))errorblock;

@end
