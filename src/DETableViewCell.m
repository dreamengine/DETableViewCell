//
//  DETableViewCell.m
//
//  Created by Jeremy Flores on 12/20/13.
//  Copyright (c) 2013 Dream Engine Interactive, Inc. All rights reserved.
//

#import "DETableViewCell.h"


@interface DETableViewCellCache : NSCache
@end

@implementation DETableViewCellCache

// from: http://stackoverflow.com/a/19549090/708798
-(id)init {
    if (self=[super init]) {
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc addObserver: self
               selector: @selector(removeAllObjects)
                   name: UIApplicationDidReceiveMemoryWarningNotification
                 object: nil];
    }

    return self;
}

-(void)dealloc {
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver: self
                  name: UIApplicationDidReceiveMemoryWarningNotification
                object: nil];
}

@end


@implementation UITableView (DETableViewCell)

-(void)registerDEClass:(Class)cellClass {
    if ([cellClass isSubclassOfClass:[DETableViewCell class]]) {
        [self registerNib: [cellClass cellNib]
   forCellReuseIdentifier: [cellClass reuseIdentifier]];
    }
}

-(void)unregisterDEClass:(Class)cellClass {
    if ([cellClass isSubclassOfClass:[DETableViewCell class]]) {
        [self registerNib: nil
   forCellReuseIdentifier: [cellClass reuseIdentifier]];
    }
}

@end


@implementation DETableViewCell

static DETableViewCellCache *CellNibCache = nil;


#pragma mark - Cell Nib Cache

+(DETableViewCellCache *)CellNibCache {
    @synchronized(self) {
        if (!CellNibCache) {
            CellNibCache = [DETableViewCellCache new];
        }
    }

    return CellNibCache;
}


#pragma mark - UINib Access

+(UINib *)cellNib {
    UINib *cellNib = nil;

    @synchronized(self) {
        DETableViewCellCache *cellNibCache = self.class.CellNibCache;

        cellNib = [cellNibCache objectForKey:self];

        if (!cellNib) {
            NSURL *url = [[NSBundle mainBundle] URLForResource: NSStringFromClass(self)
                                                 withExtension: @"nib"];
            BOOL doesNibExist = [url checkResourceIsReachableAndReturnError:nil];

            if (doesNibExist) {
                cellNib = [UINib nibWithNibName: NSStringFromClass(self)
                                         bundle: nil];
                [cellNibCache setObject: cellNib
                                 forKey: self];
            }
        }
    };

    return cellNib;
}


#pragma mark - Cache Reduction

+(void)removeCellNibFromCache {
    @synchronized(self) {
        DETableViewCellCache *cellNibCache = self.CellNibCache;
        [cellNibCache removeObjectForKey:self];
    };
}

+(void)removeAllCellNibsFromCache {
    @synchronized(self) {
        DETableViewCellCache *cellNibCache = self.CellNibCache;
        [cellNibCache removeAllObjects];
    }
}


#pragma mark - Factory/Construction Method

+(instancetype)cell {
    NSURL *url = [[NSBundle mainBundle] URLForResource: NSStringFromClass(self)
                                         withExtension: @"nib"];
    BOOL doesNibExist = [url checkResourceIsReachableAndReturnError:nil];

    DETableViewCell *cell;
    if (doesNibExist) {
        cell = [self.cellNib instantiateWithOwner: nil
                                          options: nil][0];
    }
    else {
        cell = [[self alloc] initWithStyle: UITableViewCellStyleDefault
                           reuseIdentifier: self.reuseIdentifier];
    }

    return cell;
}


#pragma mark - Reuse Identifier

+(NSString *)reuseIdentifier {
    return NSStringFromClass(self);
}

-(NSString *)reuseIdentifier {
    return [self.class reuseIdentifier];
}

@end
