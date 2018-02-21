//
//  ViewController.m
//  CryptoTokenKitSample
//
//  Created by admin on 14.02.18.
//  Copyright © 2018 admin. All rights reserved.
//

#import "ViewController.h"
#import "SCard.h"

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

- (IBAction)start:(id)sender {
    NSLog(@"Start!");
    [[[SCard alloc] init] run];
}



@end
