# CooperAFNetworkSingleton：

CooperAFNetworkSingleton是基于AFNetworking再封装的框架;
支持cookie

# Usage:

[[NetworkSingleton sharedManager] postDataToServer:nil url:@"" successBlock:^(id responseBody) {
		
	} failureBlock:^(NSString *error) {
		
	}];
}
