//
//  WMLoadingCircelView.m
//  LoadingCircle
//
//  Created by wangwendong on 16/1/5.
//  Copyright © 2016年 sunricher. All rights reserved.
//

#import "WMLoadingCircelView.h"

typedef void(^WMLoadingCircleViewStop)(void);

@interface WMLoadingCircelView ()

@property (strong, nonatomic) CAShapeLayer *backgroundLayer;
@property (strong, nonatomic) CAShapeLayer *frontLayer;

@property (strong, nonatomic) NSTimer *mTimer;
@property (strong, nonatomic) UIColor *progressColor;

@property (strong, nonatomic) WMLoadingCircleViewStop stopCompletion;

- (void)stop;

@end

@implementation WMLoadingCircelView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupDidInit];
    }
    return self;
}

- (void)awakeFromNib {
    [self setupDidInit];
}

- (void)setupDidInit {
    _progressColor = [UIColor redColor];
    _isStop = YES;
    _current = 0;
    
    _backgroundLayer = [CAShapeLayer layer];
    _backgroundLayer.lineCap = kCALineCapRound;
    _backgroundLayer.strokeColor = [UIColor lightGrayColor].CGColor;
    _backgroundLayer.fillColor = [UIColor clearColor].CGColor;
    _backgroundLayer.strokeStart = 0;
    _backgroundLayer.strokeEnd = 1;
    _backgroundLayer.lineWidth = 8.f;
    
    [self.layer addSublayer:_backgroundLayer];
    
    _frontLayer = [CAShapeLayer layer];
    _frontLayer.lineCap = kCALineCapRound;
    _frontLayer.strokeColor = _progressColor.CGColor;
    _frontLayer.fillColor = [UIColor clearColor].CGColor;
    _frontLayer.strokeStart = 0;
    _frontLayer.strokeEnd = 0;
    _frontLayer.lineWidth = 8.f;
    
    [self.layer addSublayer:_frontLayer];
    
    _current = 0;
}

- (void)drawRect:(CGRect)rect {
    UIBezierPath *path = [[UIBezierPath alloc] init];
    
    CGFloat halfWidth = round(CGRectGetWidth(self.bounds) / 2.f);
    CGFloat halfHeight = round(CGRectGetHeight(self.bounds) / 2.f);
    
    CGPoint center = CGPointMake(halfWidth, halfHeight);
    CGFloat radius0 = halfHeight > halfWidth ? halfWidth : halfHeight;
    
    [path addArcWithCenter:center radius:radius0 startAngle:-M_PI_2 endAngle:(M_PI_2 * 3) clockwise:YES];
    
    _backgroundLayer.path = path.CGPath;
    _frontLayer.path = path.CGPath;
}

- (void)start {
    if (!_isStop) {
        return;
    }
    _isStop = NO;
    
    [self stop];
    
    [self updateProgress];
    _mTimer = [NSTimer scheduledTimerWithTimeInterval:2.1f target:self selector:@selector(updateProgress) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_mTimer forMode:NSRunLoopCommonModes];
}

- (void)stop {
    if (_mTimer.isValid) {
        [_mTimer invalidate];
    }
    
    _mTimer = nil;
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    [_frontLayer removeAllAnimations];
    
    // Other properties reset in here.
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
//    NSLog(@"end %@", anim);

    _frontLayer.strokeEnd = 1.f;
    
    CABasicAnimation *anim1 = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    anim1.duration = 1.f;
    anim1.removedOnCompletion = NO;
    anim1.fillMode = kCAFillModeBoth;
    anim1.fromValue = [NSNumber numberWithFloat:0.f];
    anim1.toValue = [NSNumber numberWithFloat:1.f];
    anim1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [_frontLayer addAnimation:anim1 forKey:@"anim1"];
}

- (void)updateProgress {
    [_frontLayer removeAllAnimations];
    
    _frontLayer.strokeEnd = 0.f;
    _frontLayer.strokeStart = 0.f;
    
    if (_isStop) {
        if (_mTimer.isValid) {
            [_mTimer invalidate];
        }
        
        _mTimer = nil;
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        
        if (_stopCompletion) {
            dispatch_async(dispatch_get_main_queue(), _stopCompletion);
        }
        
        return;
    }
    
    CABasicAnimation *anim0 = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    anim0.duration = 1.f;
    anim0.removedOnCompletion = NO;
    anim0.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    anim0.fillMode = kCAFillModeBoth;
    anim0.delegate = self;
    anim0.fromValue = [NSNumber numberWithFloat:_current];
    anim0.toValue = [NSNumber numberWithFloat:1.f];
    [_frontLayer addAnimation:anim0 forKey:@"anim0"];
    
    _current = 0;
}

- (void)updateProgressColor:(UIColor *)aColor {
    if (!aColor) {
        return;
    }
    _progressColor = aColor;
    _frontLayer.strokeColor = _progressColor.CGColor;
}

- (void)stopWithCompletion:(void (^)(void))completion {
    _isStop = YES;
    
    _stopCompletion = completion;
}

- (void)updateProgressCurrentValue:(CGFloat)current {
//    _frontLayer.strokeEnd = current;
    if (!_isStop) {
        [self stopWithCompletion:^ {
            [self updateProgressCurrentValue:current];
        }];
        
        return;
    }
    
    CABasicAnimation *anim0 = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    anim0.duration = 1.f;
    anim0.removedOnCompletion = NO;
    anim0.fillMode = kCAFillModeBoth;
//    anim0.delegate = self;
    anim0.fromValue = [NSNumber numberWithFloat:_current];
    anim0.toValue = [NSNumber numberWithFloat:current];
    [_frontLayer addAnimation:anim0 forKey:@"anim0"];
    
    _current = current;
}

@end
