//
//  RawDataPoint.m
//  OpenData
//
//  Created by Michael Walker on 5/25/14.
//  Copyright (c) 2014 Lazer-Walker. All rights reserved.
//

#import "RawDataPoint.h"
#import "CDRawDataPoint.h"

#import <Asterism.h>

@interface RawDataPoint ()
@property (nonatomic, strong) NSManagedObjectContext *context;
@end

@implementation RawDataPoint

+ (Class)modelClass {
    @throw @"Not implemented";
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"model": NSNull.null,
             @"context": NSNull.null};
}

+ (NSDateFormatter *)dateFormatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss'Z'";
    return dateFormatter;
}

+ (NSValueTransformer *)timestampJSONTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSString *str) {
        return [self.dateFormatter dateFromString:str];
    } reverseBlock:^(NSDate *date) {
        return [self.dateFormatter stringFromDate:date];
    }];
}


- (id)initWithContext:(NSManagedObjectContext *)context {
    if (!(self = [super init])) return nil;
    self.context = context;
    self.model = [self.class.modelClass MR_createInContext:context];
    return self;
}

- (id)initWithCDModel:(NSManagedObject<CDRawDataPoint> *)model {
    if (!model) return nil;
    if (!(self = [super init])) return nil;
    self.model = model;
    return self;
}

- (id)initWithCDModel:(NSManagedObject<CDRawDataPoint> *)model
            context:(NSManagedObjectContext *)context {
    if (!model) return nil;
    if (!(self = [super init])) return nil;
    self.model = model;
    self.context = context;
    return self;
}

#pragma mark - Accessors
- (NSDate *)timestamp {
    return self.model.timestamp;
}

- (void)setTimestamp:(NSDate *)timestamp {
    self.model.timestamp = timestamp;
}

#pragma mark - MagicalRecord
+ (NSArray *) MR_findAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending withPredicate:(NSPredicate *)searchTerm inContext:(NSManagedObjectContext *)context {
    NSArray *array = [self.modelClass MR_findAllSortedBy:sortTerm ascending:ascending withPredicate:searchTerm inContext:context];
    return ASTMap(array, ^id(id<CDRawDataPoint> obj) {
        return [[self alloc] initWithCDModel:obj context:context];
    });
}

+ (NSArray *) MR_findAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending inContext:(NSManagedObjectContext *)context {
    NSArray *array = [self.modelClass MR_findAllSortedBy:sortTerm ascending:ascending inContext:context];
    return ASTMap(array, ^id(id<CDRawDataPoint> obj) {
        return [[self alloc] initWithCDModel:obj context:context];
    });
}

+ (NSArray *) MR_findAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending; {
    NSArray *array = [self.modelClass MR_findAllSortedBy:sortTerm ascending:ascending];
    return ASTMap(array, ^id(id<CDRawDataPoint> obj) {
        return [[self alloc] initWithCDModel:obj];
    });
}
@end
