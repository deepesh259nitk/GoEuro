//
//  NSDictionary+location_package.m

#import "NSDictionary+location_package.h"

@implementation NSDictionary (location_package)

- (NSDictionary *)currentCondition
{
    NSDictionary *dict = self[@"data"];
    NSArray *ar = dict[@"current_condition"];
    return ar[0];
}

- (NSDictionary *)request
{
    NSDictionary *dict = self[@"data"];
    NSArray *ar = dict[@"request"];
    return ar[0];
}

- (NSArray *)upcomingLocation
{
    NSDictionary *dict = self[@"data"];
    return dict[@"country"];
}

@end