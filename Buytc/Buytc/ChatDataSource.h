//
//  ChatDataSource.h
//  Buytc
//
//  Created by Vijay on 25/04/15.
//  Copyright (c) 2015 Himadri. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChatDataSource : NSObject

+ (id)sharedDataSource;

@property (nonatomic, strong) NSMutableArray *dataArray;

- (void)addSpecifiedItem:(NSDictionary *)dic;

@end