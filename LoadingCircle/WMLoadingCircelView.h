//
//  WMLoadingCircelView.h
//  LoadingCircle
//
//  Created by wangwendong on 16/1/5.
//  Copyright © 2016年 sunricher. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WMLoadingCircelView : UIView

@property (nonatomic) BOOL isStop;

@property (nonatomic) CGFloat current;

- (void)start;

- (void)updateProgressColor:(UIColor *)aColor;

// completion 用来处理停止后的事情，可置空
- (void)stopWithCompletion:(void(^)(void))completion;

- (void)updateProgressCurrentValue:(CGFloat)current;

@end
