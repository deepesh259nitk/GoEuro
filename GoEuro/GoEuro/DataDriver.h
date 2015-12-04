//
//  DataDriver.h
//  GoEuro
//
//  Created by ITRMG on 2015-10-10.
//  Copyright (c) 2015 djrecker. All rights reserved.
//

@interface DataDriver : NSObject {
    // Protected instance variables (not recommended)
    NSArray  * toData, *fromData;
}

@property(nonatomic, retain) NSArray * toData, *fromData;
@property (nonatomic, strong) NSObject* object;

+ (DataDriver*)sharedInstance;

@end