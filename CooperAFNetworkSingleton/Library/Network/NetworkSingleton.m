//
//  NetworkSingleton.m
//  cjl
//
//  Created by 陈家黎 on 15/9/24.
//  Copyright (c) 2015年 cjl. All rights reserved.
//



#import "NetworkSingleton.h"
#import "AFHTTPRequestOperationManager.h"
#import "AppDelegate.h"

@implementation NetworkSingleton{
    NSUserDefaults *ud;
    AppDelegate *appdelegate;
}

+(NetworkSingleton *)sharedManager{
    static NetworkSingleton *sharedNetworkSingleton = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate,^{
        sharedNetworkSingleton = [[self alloc] init];
    });
    return sharedNetworkSingleton;
}


-(BOOL) isConnectionAvailable{
    BOOL isExistenceNetwork = YES;
    
    if (!isExistenceNetwork) {
        return NO;
    }
    
    return isExistenceNetwork;
}

-(AFHTTPRequestOperationManager *)baseHtppRequest{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.requestSerializer.HTTPShouldHandleCookies = YES;
    [manager.requestSerializer setTimeoutInterval:TIMEOUT];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"text/html", @"application/json", nil];
    [self isConnectionAvailable];
    //[NSException raise:@"网络错误" format:@"当前网络不可以用，请检查网络连"];
    return manager;
}


-(void) uploadFileToServer:(UIImage *)image successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock{
//    AFHTTPRequestOperationManager *manager = [self baseHtppRequest];
//
//        NSData *imageData = UIImageJPEGRepresentation(image, 1);
    
//        [manager POST:urlUploadFile parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//            [formData appendPartWithFileData :imageData name:@"myimage" fileName:@"1.png" mimeType:@"image/jpeg"];
//        } success:^(AFHTTPRequestOperation *operation,id responseObject) {
//            successBlock(responseObject);
//            //NSLog(@"Success: %@", responseObject);
//        } failure:^(AFHTTPRequestOperation *operation,NSError *error) {
//            NSLog(@"Error: %@", error);
//        }];
};

-(void)loginToServer:(NSDictionary *)parameters url:(NSString *)url successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock{
    AFHTTPRequestOperationManager *manager = [self baseHtppRequest];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.HTTPShouldHandleCookies = YES;
    NSString *urlStr = [url stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    urlStr= (NSString*) CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,(CFStringRef)urlStr, NULL,(CFStringRef)@"!*'();@$,%#[]", kCFStringEncodingUTF8 ));
    
    [manager POST:[self URLEncodedStringValue:urlStr] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        successBlock(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"Error: %@", error);
    }];
}

-(void)postDataToServer:(NSMutableDictionary *)parameters url:(NSString *)url successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock{
    //开始网络请求发送通知
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 15.0;//超时时间
    //  将dict中的数组转成json
    parameters = [self dealDictArray:parameters];
    //
    NSLog(@"%@",url);
    NSLog(@"%@",parameters);
    //申明返回的结果是json类型
    NSString *urlStr = [url stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [manager POST:urlStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        successBlock(responseObject);
		
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
		
    }];
}

//  将dict中的数组转成json
- (NSMutableDictionary *)dealDictArray:(NSMutableDictionary *)dict{
    for (NSString *keyStr in [dict allKeys]) {
        id tempValue = [dict objectForKey:keyStr];
        if ([tempValue isKindOfClass:[NSArray class]] || [tempValue isKindOfClass:[NSMutableArray class]]) {
			
        }
    }
    
    return dict;
}

-(void)getDateFormServer:(NSDictionary *)parameters url:(NSString *)url successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock{
    AFHTTPRequestOperationManager *manager = [self baseHtppRequest];
    NSString *urlStr = [url stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [manager GET:urlStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        successBlock(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"Error: %@", error);
    }];
}

-(void)updateImageFace:(NSDictionary *)parameters url:(NSString *)url filePath:(NSString*) filePath
              fileName:(NSString*) fileName successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //申明返回的结果是json类型
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSData *imageData = UIImageJPEGRepresentation([UIImage imageWithContentsOfFile:filePath], 0.1);
    //
    if (imageData != nil) {
        [manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            [formData appendPartWithFileData:imageData name:fileName fileName:fileName mimeType:@"image/jpeg"];
        } success:^(AFHTTPRequestOperation *operation, id responseObject){
            successBlock(responseObject);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error){
            NSLog(@"%@",error);
        }];
        
    }else{
        NSLog(@"数据为空");
    }
}

-(void)updateManyImages:(NSDictionary *)parameters url:(NSString *)url fileDataDic:(NSMutableDictionary*)dataDic  filePathArray:(NSMutableArray*) filePathArray
               fileName:(NSString*) fileName successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
    //申明返回的结果是json类型
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    AFHTTPRequestOperation *operation = [manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData){
        for (int i=0; i<filePathArray.count; i++) {
            NSData *imageData = UIImageJPEGRepresentation([UIImage imageWithContentsOfFile:filePathArray[i]], 0.1);
            NSString * name = [NSString stringWithFormat:@"image%d.jpg", i];
            [formData appendPartWithFileData:imageData name:name fileName:name mimeType:@"image/jpeg"];
        }
        
    }success:^(AFHTTPRequestOperation *operation, id responseObject){
        successBlock(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"%@",error);
    }];
    //上传进度
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        float result = (totalBytesWritten*0.1)/(totalBytesExpectedToWrite*0.1);
        NSLog(@"%f",result);
    }];
    
}

#pragma mark - cookie保存
- (void)saveCookies{
    NSData *cookiesData = [NSKeyedArchiver archivedDataWithRootObject: [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject: cookiesData forKey: @"sessionCookies"];
    [defaults synchronize];
    
}

- (void)loadCookies{
    NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData: [[NSUserDefaults standardUserDefaults] objectForKey: @"sessionCookies"]];
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    
    for (NSHTTPCookie *cookie in cookies){
        [cookieStorage setCookie: cookie];
        NSLog(@"%@",cookie);
    }
}

//utf8
- (NSString *)URLEncodedStringValue:(NSString *)string {
    NSString *utfStr = [[NSString alloc] init];
    static NSString * const kAFCharactersGeneralDelimitersToEncode = @"#[]@"; // does not include "?" or "/" due to RFC 3986 - Section 3.4
    static NSString * const kAFCharactersSubDelimitersToEncode = @"!$'()*,;";
    NSMutableCharacterSet * allowedCharacterSet = [[NSCharacterSet URLQueryAllowedCharacterSet] mutableCopy];
    [allowedCharacterSet removeCharactersInString:[kAFCharactersGeneralDelimitersToEncode stringByAppendingString:kAFCharactersSubDelimitersToEncode]];
    utfStr = [string stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacterSet];
    
    return utfStr;
}

//setsecretkey
-(void)setSecretKeyToServer:(NSMutableDictionary *)parameters url:(NSString *)url successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //安全参数设置
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval dateInterval = [date timeIntervalSince1970]*1000;
    NSString *timeString = [[NSString stringWithFormat:@"%f", dateInterval] substringToIndex:13];//时间戳
    NSString *sortStr = [[NSString alloc] init];
    ud = [NSUserDefaults standardUserDefaults];
    //申明返回的结果是json类型
    NSString *urlStr = [url stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [manager POST:urlStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        successBlock(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"Error: %@", error);
        failureBlock([NSString stringWithFormat:@"Error: %@", error]);
    }];
}


@end
