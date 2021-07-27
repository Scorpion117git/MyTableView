//
//  MyTableViewCell.m
//  MyTableview
//
//  Created by shmily on 2021/7/23.
//

#import "MyTableViewCell.h"

@implementation MyTableViewCell
@synthesize identifiy = _identifiy;
@synthesize index = _index;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIView* contentV = [UIView new];
        contentV.backgroundColor = [UIColor clearColor];
        [self setContentView:contentV];
        _nameLabel = [[UILabel alloc]init];

    }
    return self;
}

- (void) setContentView:(UIView *)contentView
{
    if (_contentView != contentView) {
        [_contentView removeFromSuperview];
        _contentView = contentView;
        [self addSubview:contentView];
        
        [self setNeedsLayout];
    }
}
-(void)setLine:(UIView *)line{
    if (_line != line){
        [_line removeFromSuperview];
        _line = line;
        [self addSubview:line];
        [self setNeedsLayout];
    }
}
- (void)layoutSubviews{
    _contentView.frame = self.bounds;
    _nameLabel.textColor = [UIColor blackColor];
    _nameLabel.font = [UIFont systemFontOfSize:14];
    _nameLabel.frame = CGRectMake(10,
                                  0,
                                  self.bounds.size.width-10,
                                  CGRectGetHeight(self.frame));
    [_contentView addSubview:_nameLabel];
    _line = [[UIView alloc]init];
    _line.backgroundColor = [UIColor lightGrayColor];
    _line.frame = CGRectMake(0, self.bounds.size.height-1, self.bounds.size.width, 1);
    [_contentView addSubview:_line];
    [_contentView bringSubviewToFront:_line];

}
- (void) prepareForReused
{
    _index = NSNotFound;
}
- (instancetype) initWithIdentifiy:(NSString*)identifiy
{
    self = [super init];
    if (self) {
        _identifiy = identifiy;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
