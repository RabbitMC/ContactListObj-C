//
//  AddViewController.m
//  ContactList
//
//  Created by Miralem Cebic on 02/04/16.
//  Copyright © 2016 Miralem Cebic. All rights reserved.
//

#import "AddViewController.h"
#import <CoreData/CoreData.h>

@interface AddViewController ()
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *phonenumber;

@end

@implementation AddViewController
@synthesize contact;

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
    // Do any additional setup after loading the view.

    if (self.contact) {
        self.name.text = [self.contact valueForKey:@"name"];
        self.phonenumber.text = [self.contact valueForKey:@"phonenumber"];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)dismissKeyboard:(id)sender
{
    [self resignFirstResponder];
}

- (IBAction)saveNewContact:(UIButton *)sender
{
    NSManagedObjectContext *moContext = [self managedObjectContext];
    if (self.contact) {
        [self.contact setValue:self.name.text forKey:@"name"];
        [self.contact setValue:self.phonenumber.text forKey:@"phonenumber"];

    } else {
        NSManagedObject *newContact = [NSEntityDescription insertNewObjectForEntityForName:@"ContactData"
                                                                    inManagedObjectContext:moContext];
        [newContact setValue:self.name.text forKey:@"name"];
        [newContact setValue:self.phonenumber.text forKey:@"phonenumber"];
    }

    NSError *saveError = nil;
    [moContext save:&saveError];

    [self.navigationController popViewControllerAnimated:YES];

}
- (IBAction)makePhoneCall:(UIButton *)sender
{

}
- (IBAction)sendSMSMessage:(UIButton *)sender
{

}

@end
