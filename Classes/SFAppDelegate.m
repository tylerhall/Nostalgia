//
//  SFAppDelegate.m
//  Nostalgia
//
//  Created by Tyler Hall on 11/20/13.
//  Copyright (c) 2013 Click On Tyler. All rights reserved.
//

#import "SFAppDelegate.h"
#import "SFMainWindowController.h"
#import "SFPhotoDater.h"

@interface SFAppDelegate ()

@property (nonatomic, strong) SFMainWindowController *mainWindowController;
@property (nonatomic, assign) BOOL applicationDidFinishLaunching;

@end

@implementation SFAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    self.applicationDidFinishLaunching = YES;
    self.mainWindowController = [[SFMainWindowController alloc] initWithWindowNibName:@"MainWindow"];
    [self.mainWindowController showWindow:nil];
}

- (void)application:(NSApplication *)sender openFiles:(NSArray *)filenames
{
    SFPhotoDater *pd = [[SFPhotoDater alloc] init];

    for(NSString *fn in filenames) {
        [pd renamePhotoWithFilename:fn];
    }

    [[NSApplication sharedApplication] replyToOpenOrPrint:NSApplicationDelegateReplySuccess];

    // If the user launched the app by dropping files onto it's icon, quit afterwards.
    // (There's got to be a more official way of detecting this...)
    if(!self.applicationDidFinishLaunching) {
        [[NSApplication sharedApplication] terminate:nil];
    }
}

@end
