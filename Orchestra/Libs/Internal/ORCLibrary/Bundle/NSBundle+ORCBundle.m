//
//  NSBundle+ORCBundle.m
//  Orchestra
//
//  Created by Judith Medina on 22/6/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import "NSBundle+ORCBundle.h"

@implementation NSBundle (ORCBundle)

+ (NSBundle*)resourcesBundle
{
    static dispatch_once_t onceToken;
    static NSBundle *myLibraryResourcesBundle = nil;
    
    dispatch_once(&onceToken, ^
                  {
                      myLibraryResourcesBundle = [NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:@"Orchextra" withExtension:@"bundle"]];
                  });
    
    return myLibraryResourcesBundle;
}

+ (NSBundle*)preferredLanguageResourcesBundle
{
    static dispatch_once_t onceToken;
    static NSBundle *myLanguageResourcesBundle = nil;
    
    dispatch_once(&onceToken, ^
                  {
                      NSString *language = [NSLocale preferredLanguages][0];
                      myLanguageResourcesBundle = [NSBundle bundleWithPath:[[NSBundle resourcesBundle] pathForResource:language ofType:@"lproj"]];
                      
                      if( myLanguageResourcesBundle == nil )
                      {
                          myLanguageResourcesBundle = [NSBundle resourcesBundle];
                      }
                  });
    
    return myLanguageResourcesBundle;
}

+ (NSBundle *)bundleSDK
{
    return [NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:@"Orchextra" withExtension:@"bundle"]];
}

+ (UIImage *)imageFromBundleWithName:(NSString *)imageName
{
    return [UIImage imageNamed:[NSString stringWithFormat:@"Orchextra.bundle/%@", imageName]];
}

+ (NSURL *)fileFromBundleWithName:(NSString *)filename
{
    NSString *path = [[NSBundle bundleSDK] pathForResource:filename ofType:nil];
    NSURL *url = [NSURL fileURLWithPath:path];
    return url;
}

+ (UIFont *)fontORCWithSize:(CGFloat)size
{
    for (NSString *familyName in [UIFont familyNames]) {
        for (NSString *fontName in [UIFont fontNamesForFamilyName:familyName]) {
            NSLog(@"%@", fontName);
        }
    }
    return [UIFont fontWithName:@"icomoon" size:size];
}

@end
