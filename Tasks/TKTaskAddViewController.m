//
//  TKTaskAddViewController.m
//  Tasks
//
//  Created by Devon Tivona on 11/13/12.
//  Copyright (c) 2012 Devon Tivona. All rights reserved.
//

#import "TKTaskAddViewController.h"
#import "TKTextFieldCell.h"

@interface TKTaskAddViewController ()

- (void)postTask;

@end

@implementation TKTaskAddViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.cancelBarButtonItem.target = self;
    self.cancelBarButtonItem.action = @selector(dismissModalViewControllerAnimated:);

    
    self.doneBarButtonItem.target = self;
 
    if (self.task) {
        self.doneBarButtonItem.action = @selector(putTask);
    } else {
        self.doneBarButtonItem.action = @selector(postTask);
        self.task = [[TKTask alloc] init];
        self.task.userId = [NSNumber numberWithInteger:1];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - TKTaskAddViewController

- (void)putTask
{
    [self.view endEditing:YES];
    [[RKObjectManager sharedManager] putObject:self.task delegate:self];
}

- (void)postTask
{
    [self.view endEditing:YES];
    [[RKObjectManager sharedManager] postObject:self.task delegate:self];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return 1;
}

- (TKTextFieldCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TKTextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TextFieldCell" forIndexPath:indexPath];
    cell.textField.delegate = self;
    cell.textField.text = self.task.name;
    return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

#pragma mark - RKObjectLoaderDelegate

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error
{
    NSLog(@"Error: %@", [error localizedDescription]);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Could not post task. Please try again later." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles: nil];
    [alert show];
}

- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response
{
    NSLog(@"Response Code: %d", [response statusCode]);
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects
{

}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.task.name = textField.text;
}

@end
