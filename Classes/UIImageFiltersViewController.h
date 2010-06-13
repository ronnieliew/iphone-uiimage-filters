//
//  UIImageFiltersViewController.h
//  UIImageFilters
//
//  Created by Ronnie Liew on 6/13/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageFiltersViewController : UIViewController {
    UIImageView*    _blurredImageView;
}



@property(nonatomic, retain)IBOutlet UIImageView* blurredImageView;
@end

