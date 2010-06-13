//
//  UIImageFiltersAppDelegate.h
//  UIImageFilters
//
//  Created by Ronnie Liew on 6/13/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UIImageFiltersViewController;

@interface UIImageFiltersAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    UIImageFiltersViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UIImageFiltersViewController *viewController;

@end

