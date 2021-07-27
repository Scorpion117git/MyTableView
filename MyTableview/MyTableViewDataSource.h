//
//  MyTableViewDataSource.h
//  MyTableview
//
//  Created by shmily on 2021/7/27.
//

#import <Foundation/Foundation.h>
@class ZRTableView;
@class MyTableViewCell;
@protocol MyTableViewDataSource <NSObject>
- (NSInteger) numberOfRowsInZRTableView:(ZRTableView*)tableView;
- (MyTableViewCell*)zrTableView:(ZRTableView*)tableView cellAtRow:(NSInteger)row;
- (CGFloat) zrTableView:(ZRTableView*)tableView cellHeightAtRow:(NSInteger)row;
@end
