//
//  TKTask.h
//  Tasks
//
//  Created by Devon Tivona on 11/13/12.
//  Copyright (c) 2012 Devon Tivona. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TKTask : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSDate *dueDate;
@property (nonatomic, assign) BOOL complete;
@property (nonatomic, strong) NSNumber *userId;
@property (nonatomic, strong) NSNumber *remoteId;

@end
