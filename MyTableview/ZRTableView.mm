//
//  ZRTableView.m
//  MyTableview
//
//  Created by shmily on 2021/7/23.
//

#import "ZRTableView.h"
#import <map>
#import <vector>
#define kZRTableViewDefaultHeight 44.0f

using namespace std;
typedef struct {
    BOOL funcNumberOfRows;
    BOOL funcCellAtRow;
    BOOL funcHeightRow;
}ZRTableDataSourceResponse;
//map是STL的一个关联容器，它提供一对一的hash。
typedef map<int, float> ZRCellYoffsetMap;
typedef vector<float>   ZRCellHeightVector;

@interface ZRTableView ()
{
    ZRTableDataSourceResponse _dataSourceReponse;
    NSMutableSet*  _cacheCells;
    NSMutableDictionary* _visibleCellsMap;
    int64_t     _numberOfCells;
    ZRCellHeightVector _cellHeights;
    ZRCellYoffsetMap _cellYOffsets;
    BOOL    _isLayoutCells;
}

@end
@implementation ZRTableView
@synthesize dataSource  = _dataSource;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _visibleCellsMap = [NSMutableDictionary new];
        _cacheCells = [NSMutableSet new];
        
    }
    return self;
}
//设置数据
- (void) setDataSource:(id<MyTableViewDataSource>)dataSource
{
    _dataSource = dataSource;
    _dataSourceReponse.funcNumberOfRows = [_dataSource respondsToSelector:@selector(numberOfRowsInZRTableView:)];
    _dataSourceReponse.funcCellAtRow    = [_dataSource respondsToSelector:@selector(zrTableView:cellAtRow:)];
    _dataSourceReponse.funcHeightRow    = [_dataSource respondsToSelector:@selector(zrTableView:cellHeightAtRow:)];
}
//通过标识符从复用池获取cell
- (MyTableViewCell*) dequeueZRTalbeViewCellForIdentifiy:(NSString*)identifiy
{
    MyTableViewCell* cell = Nil;
    for (MyTableViewCell* each  in _cacheCells) {
        if ([each.identifiy isEqualToString:identifiy]) {
            cell = each;
            break;
        }
    }
    if (cell) {
        [_cacheCells removeObject:cell];
    }
    return cell;
}
//按顺序放入复用池
- (void)enqueueTableViewCell:(MyTableViewCell*)cell
{
    if (cell) {
        [cell prepareForReused];
        [_cacheCells addObject:cell];
        [cell removeFromSuperview];
    }
}
//可用cell
- (NSArray*) visibleCells
{
    return _visibleCellsMap.allValues;
}
- (MyTableViewCell*) _cellForRow:(NSInteger)rowIndex
{
    MyTableViewCell* cell = [_visibleCellsMap objectForKey:@(rowIndex)];
    if (!cell) {
        cell = [_dataSource zrTableView:self cellAtRow:rowIndex];
    }
    return cell;
}

- (void) reloadData
{
    NSCAssert(_dataSourceReponse.funcNumberOfRows, @"zrtalbeview %@ delegate %@ not response to selector numberOfRowsInZRTableView: ", self, _dataSource);
    NSCAssert(_dataSourceReponse.funcCellAtRow, @"zrtalbeview %@ delegate %@ not response to selector zrTableView:cellAtRow: ", self, _dataSource);
    

    [self reduceContentSize];
    [self layoutNeedDisplayCells];
}
- (void)reduceContentSize
{
    //个数
    _numberOfCells = [_dataSource numberOfRowsInZRTableView:self];
    
    _cellYOffsets = ZRCellYoffsetMap();
    _cellHeights = ZRCellHeightVector();
    float height = 0;
    for (int i = 0  ; i < _numberOfCells; i ++) {
        float cellHeight = (_dataSourceReponse.funcHeightRow? [_dataSource zrTableView:self cellHeightAtRow:i] : kZRTableViewDefaultHeight);
        //在最后插入新的元素
        _cellHeights.push_back(cellHeight);
        height += cellHeight;
        _cellYOffsets.insert(pair<int, float>(i, height));
    }
    if (height < CGRectGetHeight(self.frame)) {
        height = CGRectGetHeight(self.frame) + 2;
    }
    height += 10;
    CGSize size = CGSizeMake(CGRectGetWidth(self.frame), height);
    
    [self setContentSize:size];
}

- (NSRange) displayRange
{
    if (_numberOfCells == 0) {
        return NSMakeRange(0, 0);
    }
    int  beginIndex = 0;
    float beiginHeight = self.contentOffset.y;
    float displayBeginHeight = -0.00000001f;
    
    for (int i = 0 ; i < _numberOfCells; i++) {
        float cellHeight = _cellHeights.at(i);
        displayBeginHeight += cellHeight;
        if (displayBeginHeight > beiginHeight) {
            beginIndex = i;
            break;
        }
    }
    
    int endIndex = beginIndex;
    float displayEndHeight = self.contentOffset.y + CGRectGetHeight(self.frame);
    for (int i = beginIndex; i < _numberOfCells; i ++) {
        float cellYoffset = _cellYOffsets.at(i);
        if (cellYoffset > displayEndHeight) {
            endIndex = i;
            break;
        }
        if (i == _numberOfCells - 1) {
            endIndex = i;
            break;
        }
    }
    return NSMakeRange(beginIndex, endIndex - beginIndex + 1);
}
- (CGRect) _rectForCellAtRow:(int)rowIndex
{
    if (rowIndex < 0 || rowIndex >= _numberOfCells) {
        return CGRectZero;
    }
    float cellYoffSet = _cellYOffsets.at(rowIndex);
    float cellHeight  = _cellHeights.at(rowIndex);
    return CGRectMake(0, cellYoffSet - cellHeight, CGRectGetWidth(self.frame), cellHeight);
}
//划出页面的cell放入复用池
- (void) cleanUnusedCellsWithDispalyRange:(NSRange)range
{
    NSDictionary* dic = [_visibleCellsMap copy];
    NSArray* keys = dic.allKeys;
    for (NSNumber* rowIndex  in keys) {
        int row = [rowIndex intValue];
        if (!NSLocationInRange(row, range)) {
            MyTableViewCell* cell = [_visibleCellsMap objectForKey:rowIndex];
            [_visibleCellsMap removeObjectForKey:rowIndex];
            [self enqueueTableViewCell:cell];
        }
    }
}
//添加cell
- (void) addCell:(MyTableViewCell*)cell atRow:(NSInteger)row
{
    [self addSubview:cell];
    cell.index =  row;
    [self updateVisibleCell:cell withIndex:row];

}
- (void) updateVisibleCell:(MyTableViewCell*)cell withIndex:(NSInteger)index
{
    _visibleCellsMap[@(index)] = cell;
}
- (void) layoutNeedDisplayCells
{
    [self beginLayoutCells];
    NSRange displayRange = [self displayRange];
    for (int i = (int)displayRange.location ; i < displayRange.length + displayRange.location; i ++) {
        MyTableViewCell* cell = [self _cellForRow:i];
        [self addCell:cell atRow:i];
        cell.frame = [self _rectForCellAtRow:i];
        
    }
    [self cleanUnusedCellsWithDispalyRange:displayRange];
    [self endLayoutCells];
    
}

- (void) layoutSubviews
{
    if ([self canBeginLayoutCells]) {
        [self layoutNeedDisplayCells];
    }
}
- (void) beginLayoutCells
{
    _isLayoutCells = YES;
}


- (void) endLayoutCells
{
    _isLayoutCells = YES;
}

- (BOOL) canBeginLayoutCells
{
    return _isLayoutCells;
}





@end

