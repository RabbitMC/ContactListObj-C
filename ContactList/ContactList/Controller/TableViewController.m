//
//  TableViewController.m
//  ContactList
//
//  Created by Miralem Cebic on 02/04/16.
//  Copyright © 2016 Miralem Cebic. All rights reserved.
//

#import "TableViewController.h"
#import "AddViewController.h"
#import <CoreData/CoreData.h>

@interface TableViewController ()
@property (nonatomic, strong) NSMutableArray *contacts;
@end

@implementation TableViewController

- (NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext *moContext = nil;
    id delegate = [[UIApplication sharedApplication] delegate];

    if ([delegate respondsToSelector:@selector(managedObjectContext)]) {
        moContext = [delegate managedObjectContext];
    }

    return moContext;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    NSManagedObjectContext *moContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"ContactData"];
    NSError *fetchRequestError = nil;
    self.contacts = [[moContext executeFetchRequest:fetchRequest error:&fetchRequestError] mutableCopy];

    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.contacts.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"
                                                            forIndexPath:indexPath];
    
    NSManagedObject *contact = self.contacts[indexPath.row];
    cell.textLabel.text = [contact valueForKey:@"name"];
    cell.detailTextLabel.text = [contact valueForKey:@"phonenumber"];
    
    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObjectContext *moContext = [self managedObjectContext];
        NSManagedObject *currentContact = self.contacts[indexPath.row];
        [moContext deleteObject:currentContact];

        NSError *error = nil;
        [moContext save:&error];

        [self.contacts removeObjectAtIndex:indexPath.row];
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"detail"]) {
        AddViewController *destinationController = segue.destinationViewController;
        NSManagedObjectModel *currentContact = self.contacts[self.tableView.indexPathForSelectedRow.row];
        destinationController.contact = currentContact;
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
