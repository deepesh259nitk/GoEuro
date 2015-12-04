//
//  DataDriver.m
//  GoEuro
//
//  Created by ITRMG on 2015-10-10.
//  Copyright (c) 2015 djrecker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataDriver.h"

@implementation DataDriver

@synthesize toData, fromData;

+ (DataDriver*)sharedInstance
{
    static DataDriver* sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (id) init{
   
    self.toData = [[NSMutableArray alloc] init];
    self.fromData = [[NSMutableArray alloc] init];
    return self;
}

/*
- (void) setFromData:(NSArray *)fromData{

    self.fromData = fromData;
    
}

- (void) setToData:(NSArray *)toData{

    self.toData = toData;

}
*/

@end
