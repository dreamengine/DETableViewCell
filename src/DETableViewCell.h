//
//  DETableViewCell.h
//
//  Created by Jeremy Flores on 12/20/13.
//  Copyright (c) 2013 Dream Engine Interactive, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@class DETableViewCell;
@interface UITableView (DETableViewCell)

/*
 
 Class must be a subclass of DETableViewCell.
 
 */
-(void)registerDEClass:(Class)cellClass;

/*
 
 Class must be a subclass of DETableViewCell.
 
 */
-(void)unregisterDEClass:(Class)cellClass;

@end


@interface DETableViewCell : UITableViewCell


#pragma mark - UINib Access
/*
 
 The UINib for the DETableViewCell subclass. Automatically instantiates the UINib object if it is not already in the cache. Returns nil there is not a .nib file matching the class name in the project.
 
 */
+(UINib *)cellNib;


#pragma mark - Cache Reduction

/*
 
 Removes the current class's cell nib from the cache if it exists.
 
 */
+(void)removeCellNibFromCache;

/*
 
 Empties the cache of all cell nibs for all classes.
 
 */
+(void)removeAllCellNibsFromCache;


#pragma mark - Factory/Construction Method

/*
 
 Designated construction method. Loads from a nib if available (the nib file must share the same file name as the DETableViewCell subclass, e.g. a DETableViewCell subclass named MyCustomTableViewCell requires MyCustomTableViewCell.xib/.nib in the app bundle). Otherwise, a nib file is not available, so this method will call -initWithStyle:reuseIdentifier: with UITableViewCellStyleDefault.
 
 Calling this method will also load and cache the associated UINib object when needed.
 
 */
+(instancetype)cell;


#pragma mark - Reuse Identifier

/*
 
 Convenience for providing a standard reuse identifier (NSStringFromClassName) for the class without requiring an instance of the class to access -reuseIdentifier. Meant to be used in conjunction with -reuseIdentifier.
 
 */
+(NSString *)reuseIdentifier;

/*
 
 Returns the string provided by +reuseIdentifier.
 
 */
-(NSString *)reuseIdentifier;

@end
