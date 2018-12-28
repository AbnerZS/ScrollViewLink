//
//  SmallImageScrollView.h
//  ScrollViewLinkDemo
//
//  Created by AbnerZhang on 2018/12/28.
//  Copyright © 2018 cn.abnerzhang.www. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DataModel;

NS_ASSUME_NONNULL_BEGIN

@interface SmallImageScrollView : UIView

@property (nonatomic, strong) NSArray<DataModel *>*dataSource;

@property (nonatomic, copy) void(^scrollViewBlock)(CGFloat contentOffsetX);

- (void)setupScrollViewOffsetWithIndex:(NSInteger)index animated:(BOOL)animated;

- (void)scrollViewDidScroll:(UIScrollView *)scrollView isLinking:(BOOL)isLinking;

@end

NS_ASSUME_NONNULL_END
