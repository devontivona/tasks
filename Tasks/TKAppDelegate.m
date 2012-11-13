//
//  TKAppDelegate.m
//  Tasks
//
//  Created by Devon Tivona on 11/13/12.
//  Copyright (c) 2012 Devon Tivona. All rights reserved.
//

#import "TKAppDelegate.h"
#import <RestKit/RestKit.h>
#import "TKTask.h"

@implementation TKAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Set up the base URL
    RKURL *baseURL = [RKURL URLWithBaseURLString:@"http://tasks.monospacecollective.com/"];
    RKObjectManager *objectManager = [RKObjectManager objectManagerWithBaseURL:baseURL];
    objectManager.client.baseURL = baseURL;
    
    // Map TKTask class with the JSON response
    RKObjectMapping *taskMapping = [RKObjectMapping mappingForClass:[TKTask class]];
    [taskMapping mapKeyPathsToAttributes: @"name", @"name",
                                          @"id", @"remoteId",
                                          @"due_datetime", @"dueDate",
                                          @"user_id", @"userId",
                                          @"complete", @"complete", nil];
    [objectManager.mappingProvider setMapping:taskMapping forKeyPath:@""];
    
    RKObjectMapping *taskSerializationMapping = [taskMapping inverseMapping];
    [objectManager.mappingProvider registerMapping:taskSerializationMapping withRootKeyPath:@"task"];
    [objectManager.mappingProvider setSerializationMapping:taskSerializationMapping forClass:[TKTask class]];
    
    [objectManager.router routeClass:[TKTask class] toResourcePath:@"/tasks.json" forMethod:RKRequestMethodPOST];
    [objectManager.router routeClass:[TKTask class] toResourcePath:@"/tasks/:remoteId\\.json" forMethod:RKRequestMethodPUT];
    [objectManager.router routeClass:[TKTask class] toResourcePath:@"/tasks/:remoteId\\.json" forMethod:RKRequestMethodDELETE];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
