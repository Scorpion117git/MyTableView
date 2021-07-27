//
//  MyTableViewCell.h
//  MyTableview
//
//  Created by shmily on 2021/7/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyTableViewCell : UIView

@property (nonatomic, strong) NSString* identifiy;
@property (nonatomic, assign) NSInteger index;

@property (nonatomic, strong) UIView* contentView;
@property (nonatomic, strong) UIView* line;
@property (nonatomic, strong) UILabel* nameLabel;

- (instancetype) initWithIdentifiy:(NSString*)identifiy;
- (void) prepareForReused;

@end

NS_ASSUME_NONNULL_END
