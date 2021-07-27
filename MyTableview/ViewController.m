//
//  ViewController.m
//  MyTableview
//
//  Created by shmily on 2021/7/23.
//

#import "ViewController.h"
#import "MyTableViewCell.h"
#define screenWidth ([UIScreen mainScreen].bounds.size.width)
#define screenHeight ([UIScreen mainScreen].bounds.size.height)

@interface ViewController ()
@property(nonatomic,strong)ZRTableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataSource;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView = [[ZRTableView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_tableView];
    
    [self reloadAllData];

}
- (void) reloadAllData
{
    _dataSource = [@[@"a",@"a",@"v",@"a",@"a",@"b",@"a",@"a",@"a",@"a",@"a",@"a",@"a",@"a",@"bb",@"a",@"a",@"a",@"a",@"a",@"a",@"a",@"a",@"a",@"a",@"a",@"b",@"a",@"a",@"a",@"a",@"b",@"a",@"a",@"a",@"a",@"a",@"a",@"a",@"a",@"a",@"a",@"a",@"a",@"b",@"a",@"a",@"a",@"a",@"a",@"b",@"a",@"a",@"a",@"a",@"a",@"a",@"a",@"a",@"a",@"a",@"a",@"a",@"a",@"a",@"a"] mutableCopy];
    [self.tableView reloadData];
}

-(NSInteger)numberOfRowsInZRTableView:(ZRTableView *)tableView{
    return _dataSource.count;
}

-(CGFloat)zrTableView:(ZRTableView *)tableView cellHeightAtRow:(NSInteger)row{
    return 44;
}
-(MyTableViewCell *)zrTableView:(ZRTableView *)tableView cellAtRow:(NSInteger)row{
    static NSString* cellIdentifiy = @"cellIdentifiy";
    MyTableViewCell *cell = [tableView dequeueZRTalbeViewCellForIdentifiy:cellIdentifiy];
    if(!cell){
        cell = [[MyTableViewCell alloc]initWithIdentifiy:cellIdentifiy];
    }
    cell.nameLabel.textColor = [UIColor blackColor];
    cell.nameLabel.font = [UIFont systemFontOfSize:14];
    cell.nameLabel.text = _dataSource[row];

    return cell;

}
@end
