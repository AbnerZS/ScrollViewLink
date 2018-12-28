//
//  NSString+Addtion.m
//  ScrollViewLinkDemo
//
//  Created by AbnerZhang on 2018/12/28.
//  Copyright © 2018 cn.abnerzhang.www. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSString+Addtion.h"

@implementation NSString (Addtion)

- (CGFloat)heightWithFont:(UIFont*)font
            withLineWidth:(NSInteger)lineWidth
{
    CGSize size;
    if ([NSString instancesRespondToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        size = [self boundingRectWithSize:CGSizeMake(lineWidth, CGFLOAT_MAX)
                                  options:NSStringDrawingUsesLineFragmentOrigin
                               attributes:@{NSFontAttributeName:font}
                                  context:nil].size;
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        size = [self sizeWithFont:font
                constrainedToSize:CGSizeMake(lineWidth, CGFLOAT_MAX)
                    lineBreakMode:NSLineBreakByTruncatingTail];
#pragma clang diagnostic pop
    }
    return size.height;
    
}

@end
