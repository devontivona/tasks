//
//  TKTaskAddViewController.h
//  Tasks
//
//  Created by Devon Tivona on 11/13/12.
//  Copyright (c) 2012 Devon Tivona. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>

#import "TKTask.h"

@interface TKTaskAddViewController : UITableViewController <RKObjectLoaderDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelBarButtonItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneBarButtonItem;
@property (nonatomic, strong) TKTask *task;

@end