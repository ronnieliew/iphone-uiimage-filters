//
//  UIImageFiltersViewController.m
//  UIImageFilters
//
//  Created by Ronnie Liew on 6/13/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "UIImageFiltersViewController.h"
#import "UIImage+Filter.h"


@implementation UIImageFiltersViewController
@synthesize blurredImageView = _blurredImageView;


/////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark NSObject
- (void)dealloc {
    [_blurredImageView release];
    [super dealloc];
}



/////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UIViewController
- (void)viewDidUnload {
    self.blurredImageView = nil;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.blurredImageView.image = [UIImage blur:self.blurredImageView.image radius:9.0];
}






@end
