//
//  SFMainWindowController.h
//  Nostalgia
//
//  Created by Tyler Hall on 12/30/13.
//  Copyright (c) 2013 Click On Tyler. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface SFMainWindowController : NSWindowController

@property (nonatomic, weak) IBOutlet NSTextField *txtDateFormat;
@property (nonatomic, weak) IBOutlet NSTextField *txtDatePreview;
@property (nonatomic, weak) IBOutlet NSBox *boxDrop;

@end
