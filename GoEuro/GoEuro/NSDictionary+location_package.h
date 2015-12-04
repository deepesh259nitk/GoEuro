//
//  NSDictionary+location_package.h
//
//

#import <Foundation/Foundation.h>

@interface NSDictionary (location_package)

-(NSDictionary *)currentCondition;
-(NSDictionary *)request;
-(NSArray *)upcomingLocation;

@end