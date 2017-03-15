//
//  ViewController.m
//  CooperAFNetworkSingleton
//
//  Created by cjlcooper@163.com on 17/3/15.
//  Copyright © 2017年 Cooper. All rights reserved.
//

#import "ViewController.h"
#import "NetworkSingleton.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	[self postNetworkAction];
}

//post
- (void)postNetworkAction{
	[[NetworkSingleton sharedManager] postDataToServer:nil url:@"" successBlock:^(id responseBody) {
		
	} failureBlock:^(NSString *error) {
		
	}];
}

//get
- (void)getNetworkAction{
	[[NetworkSingleton sharedManager] getDateFormServer:nil url:@"" successBlock:^(id responseBody) {
		
	} failureBlock:^(NSString *error) {
		
	}];
}


- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}


@end
