//
//  NetworkSingleton.m
//  cjl
//
//  Created by 陈家黎 on 15/9/24.
//  Copyright (c) 2015年 cjl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "AFHTTPRequestOperationManager.h"

//请求超时
#define TIMEOUT 5

typedef void(^SuccessBlock)(id responseBody);
typedef void(^FailureBlock)(NSString *error);


@interface NetworkSingleton : NSObject

+(NetworkSingleton *)sharedManager;
-(AFHTTPRequestOperationManager *)baseHtppRequest;

#pragma mark - LOGIN
-(void)loginToServer:(NSDictionary *)parameters url:(NSString *)url successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock;

#pragma mark - POST
-(void)postDataToServer:(NSMutableDictionary *)parameters url:(NSString *)url successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock;

#pragma mark - GET
-(void)getDateFormServer:(NSDictionary *)parameters url:(NSString *)url successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock;

#pragma mark - updateImageFace
-(void)updateImageFace:(NSDictionary *)parameters url:(NSString *)url filePath:(NSString*) filePath
              fileName:(NSString*) fileName successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock;

-(void)updateManyImages:(NSDictionary *)parameters url:(NSString *)url fileDataDic:(NSMutableDictionary*)dataDic  filePathArray:(NSMutableArray*) filePathArray
               fileName:(NSString*) fileName successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock;

-(void) uploadFileToServer:(UIImage *)image successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock;

-(void) saveCookies;
- (void)loadCookies;

#pragma mark - setSecretkey
-(void)setSecretKeyToServer:(NSMutableDictionary *)parameters url:(NSString *)url successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock;


@end
