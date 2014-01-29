//
//  SFMainWindowController.m
//  Nostalgia
//
//  Created by Tyler Hall on 12/30/13.
//  Copyright (c) 2013 Click On Tyler. All rights reserved.
//

#import "SFMainWindowController.h"
#import "SFConstants.h"
#import "SFPhotoDater.h"

@interface SFMainWindowController ()

@end

@implementation SFMainWindowController

- (void)awakeFromNib
{
    [super awakeFromNib];

    [self.window registerForDraggedTypes:@[ NSFilenamesPboardType ]];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name:NSControlTextDidChangeNotification object:nil];

    [self textDidChange:nil];
}

#pragma mark -
#pragma mark - Drag and Drop
#pragma mark -

- (NSDragOperation)draggingEntered:(id <NSDraggingInfo>)sender
{
    NSPasteboard *pboard;
    NSDragOperation sourceDragMask;
    
    sourceDragMask = [sender draggingSourceOperationMask];
    pboard = [sender draggingPasteboard];
    
    if([[pboard types] containsObject:NSFilenamesPboardType]) {
        NSArray *files = [pboard propertyListForType:NSFilenamesPboardType];
        
        NSFileManager *fm = [NSFileManager defaultManager];

        for(NSString *path in files) {
            BOOL isDirectory;
            if([fm fileExistsAtPath:path isDirectory:&isDirectory] && isDirectory) {
                return NSDragOperationNone;
            }
        }
    }

    return NSDragOperationCopy;
}

- (BOOL)performDragOperation:(id <NSDraggingInfo>)sender
{
    NSPasteboard *pboard;
    NSDragOperation sourceDragMask;
    
    sourceDragMask = [sender draggingSourceOperationMask];
    pboard = [sender draggingPasteboard];
    
    if([[pboard types] containsObject:NSFilenamesPboardType]) {
        NSArray *files = [pboard propertyListForType:NSFilenamesPboardType];
        SFPhotoDater *pd = [[SFPhotoDater alloc] init];
        for(NSString *path in files) {
            [pd renamePhotoWithFilename:path];
        }
    }

    return YES;
}

#pragma mark -
#pragma mark - NSTextFieldDelegate
#pragma mark -

- (void)textDidChange:(NSNotification *)notification
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:[self.txtDateFormat stringValue]];
    [self.txtDatePreview setStringValue:[df stringFromDate:[NSDate date]]];
    
    [[NSUserDefaults standardUserDefaults] setValue:[self.txtDateFormat stringValue] forKey:SFUserDefaultsOutputDateFormat];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
