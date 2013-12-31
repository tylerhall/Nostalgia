//
//  SFPhotoDater.m
//  Nostalgia
//
//  Created by Tyler Hall on 12/30/13.
//  Copyright (c) 2013 Click On Tyler. All rights reserved.
//

#import "SFPhotoDater.h"

@interface SFPhotoDater ()

@property (nonatomic, strong) NSDateFormatter *exifDateFormatter;
@property (nonatomic, strong) NSDateFormatter *outDateFormatter;

@end

@implementation SFPhotoDater

- (id)init
{
    self = [super init];

    if(self) {
        self.exifDateFormatter = [[NSDateFormatter alloc] init];
        [self.exifDateFormatter setDateFormat:@"yyyy:MM:dd HH:mm:ss"];

        self.outDateFormatter = [[NSDateFormatter alloc] init];
        [self.outDateFormatter setDateFormat:@"yyyy-MM-dd HH.mm.ss"];
        [self.outDateFormatter setLocale:[NSLocale currentLocale]];
    }

    return self;
}

- (void)renamePhotoWithFilename:(NSString *)originalFullPath
{
    if(![self isValidImageFilename:originalFullPath]) {
        return;
    }

    NSURL *photoURL = [NSURL fileURLWithPath:originalFullPath];
    CGImageSourceRef imageSource = CGImageSourceCreateWithURL((__bridge CFURLRef)photoURL, NULL);
    NSDictionary *options = @{ (NSString *)kCGImageSourceShouldCache : [NSNumber numberWithBool:NO] };
    CFDictionaryRef imageProperties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, (__bridge CFDictionaryRef)options);
    CFRelease(imageSource);

    if(imageProperties) {
        NSDictionary *treeDict = [NSDictionary dictionaryWithDictionary:(__bridge NSDictionary*)(imageProperties)];
        id exifTree = [treeDict objectForKey:@"{Exif}"];
        NSDate *date = [self dateFromExif:exifTree];

        if(date) {
            NSFileManager *fm = [NSFileManager defaultManager];

            NSString *fullDirectoryPath = [originalFullPath stringByDeletingLastPathComponent];
            NSString *newFilename = [NSString stringWithFormat:@"%@.jpg", [self.outDateFormatter stringFromDate:date]];
            NSString *newFullPath = [NSString stringWithFormat:@"%@/%@", fullDirectoryPath, newFilename];

            if(![originalFullPath isEqualToString:newFullPath]) {
                NSUInteger counter = 0;
                while([fm fileExistsAtPath:newFullPath isDirectory:NULL]) {
                    counter++;
                    newFilename = [NSString stringWithFormat:@"%@ (%lu).jpg", [self.outDateFormatter stringFromDate:date], (unsigned long)counter];
                    newFullPath = [NSString stringWithFormat:@"%@/%@", fullDirectoryPath, newFilename];
                }
                [fm moveItemAtPath:originalFullPath toPath:newFullPath error:nil];
            }
        }
    }
}

- (BOOL)isValidImageFilename:(NSString *)filename
{
    BOOL isDir;
    [[NSFileManager defaultManager] fileExistsAtPath:filename isDirectory:&isDir];
    
    if(isDir) {
        return NO;
    }
    
    if([[[filename pathExtension] lowercaseString] isEqualToString:@"jpg"]) {
        return YES;
    }

    if([[[filename pathExtension] lowercaseString] isEqualToString:@"jpeg"]) {
        return YES;
    }

    return NO;
}

- (NSDate *)dateFromExif:(NSDictionary *)exifTree
{
    NSString *strDate = [exifTree valueForKey:@"DateTimeDigitized"];
    if(!strDate) {
        strDate = [exifTree valueForKey:@"DateTimeOriginal"];
    }
    
    if(!strDate) {
        return nil;
    }

    NSDate *date = [self.exifDateFormatter dateFromString:strDate];
    NSLog(@"%@", date);

    return date;

}

@end
