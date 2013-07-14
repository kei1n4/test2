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

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    NSURL *url = [NSURL URLWithString:@"https://api.pushover.net/1/messages.json"];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];

    UIDevice *device = [UIDevice currentDevice];
    NSString *uniqueIdentifier = [device uniqueIdentifier];
    
    //ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    NSDictionary* postBody = [[NSDictionary alloc] initWithObjectsAndKeys:postBody, @"user","S1CezgKG7IHhLEXEYI9OPeYXvPysvB", @"message", "iPad",@"token","ViBPpGWfwHEZQWkbdeSJ2ntfMpdZzd"];
    [request setPostValue:@"S1CezgKG7IHhLEXEYI9OPeYXvPysvB" forKey:@"user"];
    [request setPostValue:@"ViBPpGWfwHEZQWkbdeSJ2ntfMpdZzd" forKey:@"token"];
    [request setPostValue:uniqueIdentifier forKey:@"message"];
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    [request setDelegate:self];
    [request startAsynchronous];
    
    NSString *filePath = @"/Applications/Cydia.app";
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath])
    {
        NSLog(@"Cydia exists on disk");
        // do something useful
    }
    else
    {
        NSLog(@"Cydia does not exist");
    }

    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
