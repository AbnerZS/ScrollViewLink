//
//  ViewController.m
//  ScrollViewLinkDemo
//
//  Created by AbnerZhang on 2018/12/28.
//  Copyright © 2018 cn.abnerzhang.www. All rights reserved.
//

#import "ViewController.h"
#import "DataModel.h"
#import "SmallImageScrollView.h"
#import "NSString+Addtion.h"

#define kScreenBoundWidth  [UIScreen mainScreen].bounds.size.width
#define kScreenBoundHeight [UIScreen mainScreen].bounds.size.height

@interface ViewController ()<UIScrollViewDelegate>
{
    CGFloat _bgScrollViewMaxH;// 白色背景的最大高度
    CGFloat _bgScrollViewMinH;// 白色背景的最小高度, 默认高度
    CGFloat _imageHeight;// 背景大图的高度
    CGFloat _topOffset;// 白色背景头部距离背景大图的底部的距离
}
@property (nonatomic, strong) UIScrollView *imagesScrollView;// 放置大图的view
@property (nonatomic, strong) UIScrollView *contentScrollView;// 放置小图, 标题, 描述的view
@property (nonatomic, strong) NSMutableArray<DataModel*> *dataSource;// 数据源
@property (nonatomic, strong) SmallImageScrollView *smallImagesScrollView;// 含有小图左右滑动的scrollView
@property (nonatomic, strong) UILabel *titleLabel;// 标题
@property (nonatomic, strong) UILabel *subTitleLabel;// 描述
@property (nonatomic, assign) NSInteger lastIndex;// 加载的上一个数据源的index
@property (nonatomic, assign) NSInteger currentIndex;// 当前的数据源的index


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self loadData];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)setupUI {
    CGFloat bottomHeight = 200;
    _topOffset = kScreenBoundWidth / 5 / 2;
    _imageHeight = 563;
    _bgScrollViewMaxH = kScreenBoundHeight - _imageHeight + _topOffset + bottomHeight; // 内容scrollView的高度+bottomHeight为白色view的高度
    _bgScrollViewMinH = kScreenBoundHeight - _imageHeight + _topOffset;
    
    UIScrollView *imagesScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenBoundWidth, _imageHeight)];
    imagesScrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:imagesScrollView];
    self.imagesScrollView = imagesScrollView;
    imagesScrollView.delegate = self;
    imagesScrollView.pagingEnabled = YES;
    
    UIScrollView *contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, _imageHeight - _topOffset, kScreenBoundWidth, _bgScrollViewMinH)];
    self.contentScrollView = contentScrollView;
    [self.view addSubview:contentScrollView];
    contentScrollView.delegate = self;
    contentScrollView.backgroundColor = [UIColor clearColor];
    contentScrollView.contentSize = CGSizeMake(kScreenBoundWidth, _bgScrollViewMaxH+20);
    contentScrollView.showsVerticalScrollIndicator = NO;
    UIView *bgClearView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenBoundWidth, kScreenBoundWidth / 5 / 2)];
    bgClearView.backgroundColor = [UIColor clearColor];
    [contentScrollView addSubview:bgClearView];
    
    
    UIView *bgWhiteView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(bgClearView.frame), kScreenBoundWidth, _bgScrollViewMaxH)];
    bgWhiteView.backgroundColor = [UIColor whiteColor];
    [contentScrollView addSubview:bgWhiteView];
    
    SmallImageScrollView *smallImagesScrollView = [[SmallImageScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenBoundWidth, kScreenBoundWidth / 5)];
    smallImagesScrollView.backgroundColor = [UIColor clearColor];
    [contentScrollView addSubview:smallImagesScrollView];
    self.smallImagesScrollView = smallImagesScrollView;
    __weak typeof(self) weakSelf = self;
    [smallImagesScrollView setScrollViewBlock:^(CGFloat contentOffsetX) {
        weakSelf.imagesScrollView.delegate = nil;
        weakSelf.imagesScrollView.contentOffset = CGPointMake(contentOffsetX*5, 0);
        weakSelf.imagesScrollView.delegate = weakSelf;
        CGFloat w = kScreenBoundWidth / 5;
        CGFloat div = contentOffsetX / w;
        weakSelf.currentIndex = round(div);
        if (weakSelf.currentIndex != weakSelf.lastIndex) {// 避免在监听的时候多次刷新显示数据
            [weakSelf reloadData];
        }
    }];
    
   
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLabel.font = [UIFont boldSystemFontOfSize:22];
    titleLabel.textColor = [UIColor blackColor];
    self.titleLabel = titleLabel;
    titleLabel.numberOfLines = 2;
    [contentScrollView addSubview:titleLabel];
    
    UILabel *subTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    subTitleLabel.font = [UIFont systemFontOfSize:14];
    subTitleLabel.textColor = [UIColor blackColor];
    self.subTitleLabel = subTitleLabel;
    subTitleLabel.numberOfLines = 0;
    [contentScrollView addSubview:subTitleLabel];
}

- (void)loadData {
    self.dataSource = [NSMutableArray array];
    DataModel *model1 = [DataModel new];
    model1.coverImg = @"1";
    model1.titleStr = @"测试标题1";
    model1.subTitleStr = @"测试描述1测试描述1测试描述1测试描述1测试描述1测试描述1测试描述1测试描述1测试描述1测试描述1测试描述1测试描述1测试描述1测试描述1测试描述1测试描述1测试描述1测试描述1测试描述1测试描述1";
    [self.dataSource addObject:model1];
    
    DataModel *model2 = [DataModel new];
    model2.coverImg = @"2";
    model2.titleStr = @"测试标题2测试标题2测试标题2测试标题2测试标题2测试标题2";
    model2.subTitleStr = @"测试描述2";
    [self.dataSource addObject:model2];
    
    
    DataModel *model3 = [DataModel new];
    model3.coverImg = @"3";
    model3.titleStr = @"测试标题3";
    model3.subTitleStr = @"测试描述3";
    [self.dataSource addObject:model3];
    
    DataModel *model4 = [DataModel new];
    model4.coverImg = @"4";
    model4.titleStr = @"测试标题4";
    model4.subTitleStr = @"测试描述4测试描述4测试描述4测试描述4测试描述4测试描述4测试描述4测试描述4测试描述4测试描述4测试描述4测试描述4测试描述4测试描述4";
    [self.dataSource addObject:model4];
    
    DataModel *model5 = [DataModel new];
    model5.coverImg = @"5";
    model5.titleStr = @"测试标题5测试标题5测试标题5测试标题5测试标题5测试标题5";
    model5.subTitleStr = @"测试描述5测试描述5测试描述5测试描述5测试描述5测试描述5测试描述5测试描述5测试描述5";
    [self.dataSource addObject:model5];
    
    [self loadImageView];
    self.smallImagesScrollView.dataSource = self.dataSource.copy;
    [self reloadData];
    
}
// 加载图片...
- (void)loadImageView {
    for (int i = 0; i < self.dataSource.count; i++) {
        UIImageView *imageV = [UIImageView new] ;
        [self.imagesScrollView addSubview:imageV];
        imageV.image = [UIImage imageNamed:self.dataSource[i].coverImg];;
        imageV.frame = CGRectMake(i*kScreenBoundWidth, 0, kScreenBoundWidth, _imageHeight);
    }
    self.imagesScrollView.contentSize = CGSizeMake(kScreenBoundWidth *self.dataSource.count, 0);
}

// 滚动翻页的时候重新加载显示数据
- (void)reloadData {
    if (self.currentIndex > self.dataSource.count - 1) {
        return;
    }
    NSString *currentPage = [NSString stringWithFormat:@"%02ld ", self.currentIndex+1];
    NSString *totalPage = [NSString stringWithFormat:@"/%02ld  ", self.dataSource.count];
    NSString *titleStr = self.dataSource[self.currentIndex].titleStr;
    
    NSMutableAttributedString *attr = [NSMutableAttributedString new];
    NSAttributedString *attr1 = [[NSAttributedString alloc] initWithString:currentPage attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:36],NSForegroundColorAttributeName:[UIColor blackColor]}];
    [attr appendAttributedString:attr1];
    
    NSAttributedString *attr2 = [[NSAttributedString alloc] initWithString:totalPage attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:16],NSForegroundColorAttributeName:[UIColor blackColor]}];
    [attr appendAttributedString:attr2];
    
    NSAttributedString *attr3 = [[NSAttributedString alloc] initWithString:titleStr attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:22],NSForegroundColorAttributeName:[UIColor blackColor]}];
    [attr appendAttributedString:attr3];
    self.titleLabel.attributedText = attr;
    
    CGFloat height = [titleStr heightWithFont:[UIFont boldSystemFontOfSize:22] withLineWidth:kScreenBoundWidth - 60];
    CGFloat tempSpace = 15;

    self.titleLabel.frame = CGRectMake(30, CGRectGetHeight(self.smallImagesScrollView.frame)+tempSpace, kScreenBoundWidth - 60, height+20);
    NSString *subTitleStr = self.dataSource[self.currentIndex].subTitleStr;
    CGFloat subHeight = [subTitleStr heightWithFont:[UIFont boldSystemFontOfSize:22] withLineWidth:kScreenBoundWidth - 60];
    self.subTitleLabel.text = subTitleStr;
    self.subTitleLabel.frame = CGRectMake(30, CGRectGetMaxY(self.titleLabel.frame)+20, kScreenBoundWidth - 60, subHeight+30);
    [self.titleLabel sizeToFit];
    [self.subTitleLabel sizeToFit];
    self.lastIndex = self.currentIndex;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    // 左右滚动的时候刷新显示数据,
    if (scrollView == self.imagesScrollView) {
        [self.smallImagesScrollView scrollViewDidScroll:self.imagesScrollView isLinking:NO];// 大图scrollView不合小图scrollView联动
        CGFloat quo = scrollView.contentOffset.x / kScreenBoundWidth;
        self.currentIndex = round(quo);
        if (self.currentIndex != self.lastIndex) {
            [self reloadData];
        }
    }
    // 上下滚动改变内容scrollView的frame, 对此限制区域
    if (scrollView == self.contentScrollView) {
        CGFloat scrollHeight = CGRectGetHeight(scrollView.frame);
        CGFloat scrollOffsetY = scrollView.contentOffset.y;
        if (scrollHeight>_bgScrollViewMinH || scrollHeight<=_bgScrollViewMaxH) {
            self.contentScrollView.frame = CGRectMake(0, CGRectGetMinY(scrollView.frame)-scrollOffsetY, kScreenBoundWidth, scrollHeight+scrollOffsetY);
        }
        
        if (scrollHeight > _bgScrollViewMaxH) {
            self.contentScrollView.frame = CGRectMake(0, kScreenBoundHeight - _bgScrollViewMaxH, kScreenBoundWidth, _bgScrollViewMaxH);
        }
        
        if (scrollHeight < _bgScrollViewMinH) {
            self.contentScrollView.frame = CGRectMake(0, _imageHeight - _topOffset, kScreenBoundWidth, _bgScrollViewMinH);
        }
        
        scrollView.contentOffset = CGPointMake(0, 0);
    }
}

@end
