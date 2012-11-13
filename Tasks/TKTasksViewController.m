//
//  TKTasksViewController.m
//  Tasks
//
//  Created by Devon Tivona on 11/13/12.
//  Copyright (c) 2012 Devon Tivona. All rights reserved.
//

#import "TKTasksViewController.h"
#import "TKTaskAddViewController.h"
#import "TKTask.h"

@interface TKTasksViewController ()

- (void)fetchTasks;

@property (nonatomic, strong) NSArray *tasks;

@end

@implementation TKTasksViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchTasks) forControlEvents:UIControlEventValueChanged];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self fetchTasks];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - TKTasksViewController

- (void)fetchTasks
{
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    NSDictionary *queryParameters = [NSDictionary dictionaryWithObjectsAndKeys:@"1", @"user_id", nil];
    RKURL *URL = [RKURL URLWithBaseURL:[objectManager baseURL] resourcePath:@"/tasks.json" queryParameters:queryParameters];
    [objectManager loadObjectsAtResourcePath:[NSString stringWithFormat:@"%@?%@", [URL resourcePath], [URL query]] delegate:self];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tasks.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TaskCell" forIndexPath:indexPath];
    
    TKTask *task = [self.tasks objectAtIndex:indexPath.row];
    
    cell.textLabel.text = task.name;
    
    if (task.complete) {
        cell.detailTextLabel.text = @"Complete";
    } else {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateStyle = NSDateFormatterMediumStyle;
        cell.detailTextLabel.text = [dateFormatter stringFromDate:task.dueDate];
    }
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        TKTask *task = [self.tasks objectAtIndex:indexPath.row];
        [[RKObjectManager sharedManager] deleteObject:task delegate:self];
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TKTask *task = [self.tasks objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"addTask" sender:task];
}

#pragma mark - RKObjectLoaderDelegate

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error
{
    [self.refreshControl endRefreshing];
    NSLog(@"Error: %@", [error localizedDescription]);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Could not fetch tasks. Please try again later." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles: nil];
    [alert show];
}

- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response
{
    [self.refreshControl endRefreshing];
    NSLog(@"Response Code: %d", [response statusCode]);
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects
{
    if (objectLoader.response.statusCode == 204) {
        [self fetchTasks];
    } else {
        self.tasks = objects;
        [self.tableView reloadData];
    }
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([sender isKindOfClass:[TKTask class]]) {
        TKTaskAddViewController *addViewController = ((UINavigationController *)segue.destinationViewController).viewControllers[0];
        addViewController.title = @"Edit Task";
        addViewController.task = sender;
    }
}

@end
