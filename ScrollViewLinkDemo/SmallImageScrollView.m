//
//  SmallImageScrollView.m
//  ScrollViewLinkDemo
//
//  Created by AbnerZhang on 2018/12/28.
//  Copyright © 2018 cn.abnerzhang.www. All rights reserved.
//

#import "SmallImageScrollView.h"
#import "DataModel.h"

@interface SmallImageScrollView ()<UIScrollViewDelegate>
{
    CGFloat _unitW;
    CGFloat _unitH;
}
@property (nonatomic,strong) NSMutableArray<UIButton*> * buttonSubViews;
@property (nonatomic,strong) UIScrollView * scrollView;

@property (nonatomic, assign) BOOL isLinking;// 是否与外部scrollView联动

@end
@implementation SmallImageScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _buttonSubViews = [NSMutableArray array];
        _unitW = self.frame.size.width / 5;
        _unitH = self.frame.size.height;
        self.scrollView.frame = CGRectMake(0, 0, _unitW, _unitH);
        self.scrollView.center = CGPointMake(self.bounds.size.width/2.0, _unitW/2.0);
        [self addSubview:self.scrollView];
        self.isLinking = YES;
    }
    return self;
}


- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.clipsToBounds = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}


- (void)layoutSubviews {
    _unitW = self.frame.size.width / 5;
    _unitH = self.frame.size.height;
    self.scrollView.frame = CGRectMake(0, 0, _unitW, _unitH);
    self.scrollView.center = CGPointMake(self.bounds.size.width/2.0, _unitH/2.0);
}

- (void)setDataSource:(NSArray<DataModel *> *)dataSource {
    _dataSource = dataSource;
    NSInteger count = dataSource.count;
    //NSMutableArray * array = [[NSMutableArray alloc]init];
    for (int i = 0; i < count; i++)
    {
        UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(i * _unitW, 0, _unitW, _unitW)];
        button.backgroundColor = [UIColor whiteColor];
        CGRect bounds = button.bounds;
        bounds.origin.y = bounds.size.height;
        bounds.origin.x = 2;
        bounds.size.height = 2;
        bounds.size.width = bounds.size.width - 4;
        button.layer.shadowPath = [UIBezierPath bezierPathWithRect:bounds].CGPath;
        button.layer.shadowColor = [UIColor blackColor].CGColor;
        button.layer.shadowOpacity = 0.8;
        button.tag = i;
        button.layer.cornerRadius = 10;
        [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:button];
        [self.buttonSubViews addObject:button];
        button.layer.cornerRadius = 10;
        
        CGFloat space = 2.0;
        CGRect subViewBounds = (CGRect){space, space, _unitW - space*2, _unitW - space*2};
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:subViewBounds];
        imageV.image = [UIImage imageNamed:dataSource[i].coverImg];
        imageV.layer.cornerRadius = 10;
        imageV.layer.masksToBounds = YES;
        [button addSubview:imageV];
    }
    [self scrollViewDidScroll:self.scrollView];
    self.scrollView.contentSize = CGSizeMake(_unitW * count, _unitH);
}
// 当外部scrollView滚动时带动当前scrollViewh滚动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView isLinking:(BOOL)isLinking {
    self.isLinking = isLinking;
    self.scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x / 5, 0);
}

//如果没有写这个方法,那么ScrollView frmae之外的卡片将无法响应滚动事件
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    CGPoint newPoint = [self convertPoint:point toView:self];
    if ([self pointInside:newPoint withEvent:event]) {
        
        for (UIButton *button in self.buttonSubViews) {
            CGRect frame = [button convertRect:button.bounds toView:self];
            if (CGRectContainsPoint(frame, newPoint)) {
                return button;
            }
        }
        return self.scrollView;
    }
    
    return [super hitTest:point withEvent:event];
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat viewHeight = scrollView.frame.size.width;
    
    for (int i = 0; i < self.buttonSubViews.count; i++) {
        UIButton *btn = self.buttonSubViews[i];
        CGFloat y = btn.center.x - scrollView.contentOffset.x;
        CGFloat p = y - viewHeight / 2;
        float scale = cos(0.6 * p / viewHeight);
        
        if (scale<0.7)
        {
            scale = 0.7;
        }
        
        if (scale > 0.95) {
            btn.backgroundColor = [UIColor whiteColor];
        } else {
            btn.backgroundColor = [UIColor clearColor];
        }
        
        btn.transform = CGAffineTransformMakeScale(scale, scale);
    }
// 当外部scrollView滚动时带动这个方法执行 但是并不能触发当前scrollView再次带动外部scrollView
    if (self.isLinking && self.scrollViewBlock) {
        self.scrollViewBlock(scrollView.contentOffset.x);
    }
    self.isLinking = YES;
}

- (void)btnClick:(UIButton *)btn {
    [self setupScrollViewOffsetWithIndex:btn.tag animated:YES];
}
// 设置当前的index
- (void)setupScrollViewOffsetWithIndex:(NSInteger)index animated:(BOOL)animated {
    self.isLinking = YES;
    [self.scrollView setContentOffset:CGPointMake(index * self.scrollView.frame.size.width, 0) animated:animated];
    
}


@end
