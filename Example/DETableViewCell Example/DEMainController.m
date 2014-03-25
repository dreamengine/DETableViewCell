//
//  DEMainController.m
//  DETableViewCell Example
//
//  Created by Jeremy Flores on 3/24/14.
//  Copyright (c) 2014 Dream Engine Interactive, Inc. All rights reserved.
//

#import "DEMainController.h"

#import "DEFirstCell.h"
#import "DESecondCell.h"


@interface DEMainController () <UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end


@implementation DEMainController

-(void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"DETableViewCell Example";
    
    NSLog(@"\n\n");
    NSLog(@"First cell: %@", DEFirstCell.cellNib);
    NSLog(@"Second cell: %@", DESecondCell.cellNib);
    
    [self.tableView registerDEClass:DEFirstCell.class];
    [self.tableView registerDEClass:DESecondCell.class];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 15;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        DEFirstCell *firstCell =
        [tableView dequeueReusableCellWithIdentifier: DEFirstCell.reuseIdentifier
                                        forIndexPath: indexPath];

        [self configureFirstCell: firstCell
                     atIndexPath: indexPath];
    
        return firstCell;
    }
    else {
        DESecondCell *secondCell =
        [tableView dequeueReusableCellWithIdentifier: DESecondCell.reuseIdentifier
                                        forIndexPath: indexPath];
    
        [self configureSecondCell: secondCell
                      atIndexPath: indexPath];

        return secondCell;
    }
}

-(void)configureFirstCell: (DEFirstCell *)firstCell
              atIndexPath: (NSIndexPath *)indexPath {
    firstCell.centerLabel.text = [NSString stringWithFormat:@"Type 1:   %01d", indexPath.row];
}

-(void)configureSecondCell: (DESecondCell *)secondCell
               atIndexPath: (NSIndexPath *)indexPath {
    secondCell.centerLabel.text = [NSString stringWithFormat:@"Type 2:   %01d", indexPath.row];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.navigationController.viewControllers.count % 3 == 0) {
        NSLog(@"\n\n***************clear***************\n\n");
        //[DEFirstCell removeCellNibFromCache];
        [DEFirstCell removeAllCellNibsFromCache];
    }

    DEMainController *controller = [[DEMainController alloc] initWithNibName: @"DEMainController"
                                                                      bundle: nil];

    [self.navigationController pushViewController: controller
                                         animated: YES];
}

@end
