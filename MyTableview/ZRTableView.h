//
//  ZRTableView.h
//  MyTableview
//
//  Created by shmily on 2021/7/23.
//

#import <UIKit/UIKit.h>
#import "MyTableViewDataSource.h"
#import "MyTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZRTableView : UIScrollView
@property (nonatomic, strong, readonly) NSArray* visibleCells;
@property (nonatomic, weak) id<MyTableViewDataSource> dataSource;
- (MyTableViewCell*) dequeueZRTalbeViewCellForIdentifiy:(NSString*)identifiy;
- (void) reloadData;

@end

NS_ASSUME_NONNULL_END
