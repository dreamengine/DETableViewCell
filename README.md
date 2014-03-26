# DETableViewCell
[https://github.com/dreamengine/DETableViewCell](https://github.com/dreamengine/DETableViewCell)

## What It Does

`DETableViewCell` is an MIT-licensed `UITableViewCell` replacement that makes table cell management easy. It takes care of creating and maintaining `UINibs` for each `DETableViewCell` subclass, allowing the `UINibs` to be reused across multiple controllers without ever worrying about them.

## How It Works


### DETableViewCell Subclassing

When creating custom cells, subclass from `DETableViewCell` instead of `UITableViewCell`. `DETableViewCell` is itself a subclass of `UITableViewCell`, so nothing is lost by changing your custom cell's superclass.

#### Example

	@interface MyCustomCell : DETableViewCell
	...
	@end
	
	@implementation MyCustomCell
	...
	@end

### Accessing UINibs

To access a cell class's `UINib`, simply use `+cellNib` on that class. If a UINib instance has already been created for that class, this method will simply return that object. Otherwise, this method will automatically create a new `UINib` for the class, store it in the `DETableViewCell` cache, and return that object. The nib instantiation process requires that the .xib/.nib file has the same name as the `DETableViewCell` subclass.

#### Example

	#import "MyCustomCell.h"
	#import "OtherCustomCell.h"
	
	@implementation SomeObject

	-(void)someMethod {
		UINib *myNib = [MyCustomCell cellNib];	// returns a UINib loaded with "MyCustomCell.nib"
		UINib *otherNib = [OtherCustomCell cellNib];	// returns a UINib loaded with "OtherCustomCell.nib"
	}
	
	@end
	
### Manual Instantiation

If the need arises to manually create a cell instance, you can simply use `+cell` on your `DETableViewCell` subclass, which will utilize the `UINib` caching system to inflate from the corresponding nib file.

#### Example

	-(void)someMethod {
		MyCustomCell *customCell = [MyCustomCell cell];
	}


### Reuse Identifiers

To further simplify table cell usage in apps, `DETableViewCell` provides a default reuse identifier using `NSStringFromClass()`. Both `+reuseIdentifier` as well as `-reuseIdentifier` return the same string, making both registering nibs in as well as dequeuing cells from `UITableViews` easier.

#### Example
	#import "MyCustomCell.h"
	#import "OtherCustomCell.h"
	
	@implementation SomeController
	
	-(void)viewDidLoad {
		[super viewDidLoad];
		
		[self.tableView registerNib:MyCustomCell.cellNib forCellReuseIdentifier:MyCustomCell.reuseIdentifier];
		[self.tableView registerNib:OtherCustomCell.cellNib forCellReuseIdentifier:OtherCustomCell.reuseIdentifier];
	}
	
	- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
		if (indexPath.section == 0) {
			MyCustomCell *customCell = [self.tableView dequeueReusableCellWithIdentifier:MyCustomCell.reuseIdentifier forIndexPath:indexPath];
			return customCell;
		}
		else {
			OtherCustomCell *otherCell = [self.tableView dequeueReusableCellWithIdentifier:OtherCustomCell.reuseIdentifier forIndexPath:indexPath];
			return otherCell;
		}
	}

### UITableView Category

A `UITableView` category has also been provided to simplify reuse registration. Instead of using `-registerNib:forCellReuseIdentifier:`, simply use `-registerDETableViewCellClass:`.

#### Example

	-(void)viewDidLoad {
		[super viewDidLoad];
		
		[self.tableView registerDETableViewCellClass:MyCustomCell.class];
		[self.tableView registerDETableViewCellClass:OtherCustomCell.class];
	}

### Manual Memory Management

`DETableViewCell` uses a custom NSCache object that is also sensitive to low memory warnings. The cache will automatically evict items as memory constraints increase, which means you don't have to worry about `DETableViewCell's` caching strategies.

However, there may be times where you want to manually remove a cached `UINib` from memory before memory constraints occur. To do so, call `+removeCellNibFromCache` on the corresponding class.

There may also be situations where it makes sense to manually clear the `UINib` cache entirely. To do so, call `+removeAllCellNibsFromCache` on any `DETableViewCell` class.

#### Example

	-(void)someMethod {
		[MyCustomCell removeCellNibFromCache];	// remove MyCustomCell's UINib from the cache
		[DETableViewCell removeAllCellNibsFromCache]; // remove all UINibs from the cache
	}