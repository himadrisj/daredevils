//
//  ChatDataSource.m
//  Buytc
//
//  Created by Vijay on 25/04/15.
//  Copyright (c) 2015 Himadri. All rights reserved.
//

#import "ChatDataSource.h"
#import "UUMessage.h"
#import "UUMessageFrame.h"
#import "CardModel.h"

@interface ChatDataSource ()
@property (nonatomic,strong) NSString *filePath;
@end
@implementation ChatDataSource

+ (id)sharedDataSource {
    static ChatDataSource *sharedDataSource = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedDataSource = [[ChatDataSource alloc] init];
    });
    return sharedDataSource;
}

- (id)init {
    if (self = [super init]) {
        _dataArray = [[NSMutableArray alloc] init];
        [_dataArray addObjectsFromArray:[NSArray arrayWithContentsOfFile:self.filePath]];
    }
    return self;
}

- (void)addMessage:(UUMessage *)message {
    [self.dataArray addObject:message];
}

- (void)writeDataToMemory {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self.dataArray writeToFile:self.filePath atomically:YES];
    });
    
}

- (NSString *)filePath {
    if (_filePath) {
        return  _filePath;
    }
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentFolder = [path objectAtIndex:0];
    _filePath = [documentFolder stringByAppendingPathComponent:@"Database.plist"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:_filePath]) {
        [[NSFileManager defaultManager] createFileAtPath:_filePath contents:nil attributes:nil];
    }
    
    return _filePath;
}

- (void)addSpecifiedItem:(NSDictionary *)dic
{
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    
    if([dataDic objectForKey:@"from"]) {
        [dataDic setObject:[dataDic objectForKey:@"from"] forKey:@"from"];
        [dataDic setObject:@"Mynt" forKey:@"strName"];

    }
    else {
        [dataDic setObject:@(UUMessageFromMe) forKey:@"from"];
        [dataDic setObject:@"Me" forKey:@"strName"];

    }

    [dataDic setObject:[[NSDate date] description] forKey:@"strTime"];
    
    [self.dataArray addObject:dataDic];
    //[self writeDataToMemory];
}

- (void)addCard:(CardModel *)card {
    
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionaryWithCapacity:3];
    if (card.itemBrandName) {
        [dataDict setValue:card.itemBrandName forKey:@"brandName"];
    }
    if (card.imageUrl) {
        [dataDict setValue:card.imageUrl forKey:@"imageUrl"];
    }
    if (card.price) {
        [dataDict setValue:card.price forKey:@"price"];
    }
    [dataDict setValue:card.size forKey:@"size"];
    if(card.disCount) {
        [dataDict setValue:card.disCount forKey:@"discount"];
    }
    [dataDict setValue:@(UUMessageFromOther) forKey:@"from"];
    [dataDict setValue:@(UUMessageTypeCard) forKey:@"type"];
    
    [self.dataArray addObject:dataDict];
    //[self writeDataToMemory];
}

@end
