//
//  DEAppDelegate.h
//  DETableViewCell Example
//
//  Created by Jeremy Flores on 3/24/14.
//  Copyright (c) 2014 Dream Engine Interactive, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DEMainController.h"


@interface DEAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) DEMainController *mainController;
@property (strong, nonatomic) UINavigationController *navController;

@end
