//
//  leftMenuView.m
//  leftMenu
//
//  Created by chuck on 15-8-2.
//  Copyright (c) 2015年 ZK. All rights reserved.
//

#import "leftMenuView.h"

#define kWidth 60
#define kHeight 44
#define ANIMATION_DUARTION  0.5f
#define BUTTON_TAG_BEGIN_INDEX 2000
#define ANIMATION_KEY  @"animationKey"

@implementation leftMenuView

- (id)initLeftMenuView:(NSArray *)titles imageNames:(NSArray *)imageNames{
    self = [super init];
    //self.backgroundColor = [UIColor redColor];
    if (self) {
        self.titlesArray = titles;
        self.imageNamesArray = imageNames;
        self.frame = CGRectMake(0, 0, kWidth, [UIScreen mainScreen].bounds.size.height);
        [self addMenuDetail];
        _animationComplete = YES;
    }
    return self;
}

- (void)addMenuDetail{
    for (int i= 0 ; i<self.titlesArray.count; i++) {
        UIButton * btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        btn.layer.anchorPoint = CGPointMake(0, 0.5);
        if (i == 0) {
            btn.frame = CGRectMake(0, 0, kWidth, 64); //cacle btn
        }else{
            btn.frame = CGRectMake(0, 64 + (i - 1)*kHeight, kWidth, kHeight);//menu btn
        }
        CGFloat red = arc4random()/(CGFloat)INT_MAX;
        CGFloat green = arc4random()/(CGFloat)INT_MAX;
        CGFloat blue = arc4random()/(CGFloat)INT_MAX;
        
        UIColor * color = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
        btn.backgroundColor = color;
        btn.tag = BUTTON_TAG_BEGIN_INDEX + i;
        [btn setTitle:self.titlesArray[i] forState:(UIControlStateNormal)];
        [btn addTarget:self action:@selector(clickButtonIndex:) forControlEvents:(UIControlEventTouchUpInside)];
        [self.menuBtnArray addObject:btn];
        [self addSubview:btn];
    }
}

//double radians(float degrees) {
//    return ( degrees * 3.14159265 ) / 180.0;
//}

- (void)show{
    self.handerView = [UIButton buttonWithType:(UIButtonTypeCustom)];
    _handerView.frame = [UIScreen mainScreen].bounds;
    _handerView.backgroundColor = [UIColor clearColor];
    [_handerView addTarget:self action:@selector(clickHandleView) forControlEvents:(UIControlEventTouchUpInside)];
    [_handerView addSubview:self];
    
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:_handerView];

    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = - 1.0/500.0;
    transform = CATransform3DRotate(transform, M_PI/2, 0, 1, 0);
    for (int i = 0; i<self.menuBtnArray.count; i++) {
        UIButton * btn = self.menuBtnArray[i];
        btn.layer.transform = transform;
        btn.layer.allowsEdgeAntialiasing = YES;
    }
    
    for (int i = 0; i<self.menuBtnArray.count; i++) {
        UIButton * btn = self.menuBtnArray[i];
        [btn.layer addAnimation:[self Animation:M_PI_2 toValue:0.0f beginTime:CACurrentMediaTime() + ANIMATION_DUARTION/self.menuBtnArray.count * (i) animationValue:[NSString stringWithFormat:@"%d",i]] forKey:nil];
    }
}
- (void)dismiss{
    _removeFlag = YES;
    for (int i = 0; i<self.menuBtnArray.count; i++) {
        UIButton * btn = self.menuBtnArray[i];
        btn.layer.allowsEdgeAntialiasing = YES;
        [btn.layer addAnimation:[self Animation:0.0f toValue:-M_PI_2 beginTime:CACurrentMediaTime() + ANIMATION_DUARTION/self.titlesArray.count * (i) animationValue:[NSString stringWithFormat:@"%d",i]] forKey:nil];
    }
}


- (CABasicAnimation *)Animation:(CGFloat)fromValue toValue:(CGFloat)toValue beginTime:(CFTimeInterval)beginTime animationValue:(NSString *)animationValue{
    CABasicAnimation * animation = [CABasicAnimation animation];
    animation.delegate = self;
    animation.keyPath = @"transform.rotation.y";
    animation.fromValue = @(fromValue);
    animation.toValue = @(toValue);
    animation.duration = ANIMATION_DUARTION;
    animation.beginTime = beginTime;
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [animation setValue:animationValue forKey:ANIMATION_KEY];
    return animation;
}

- (void)clickHandleView{
    if (_animationComplete) {
        [self dismiss];
    }
}

- (void)clickButtonIndex:(UIButton *)btn{
    NSInteger index = btn.tag - BUTTON_TAG_BEGIN_INDEX;
    [self dismiss];
    if (index) {
        if ([self.delegate conformsToProtocol:@protocol(leftMenuViewDelegate)] && [self.delegate respondsToSelector:@selector(didSelectIndex:)]) {
            [self.delegate didSelectIndex:index];
        }
    }
}

- (void)animationDidStart:(CAAnimation *)anim{
    _animationComplete = NO;
}

- (void)animationDidStop:(CABasicAnimation *)anim finished:(BOOL)flag{
    if (_removeFlag) {
        NSString * AnimationValue = [NSString stringWithFormat:@"%d",self.menuBtnArray.count - 1];
        if ([[anim valueForKey:ANIMATION_KEY] isEqualToString:AnimationValue]) {
            _animationComplete = YES;
            [_handerView removeFromSuperview];
        }
    }else{
        NSInteger index = [[anim valueForKey:ANIMATION_KEY] intValue];
        CATransform3D transform = CATransform3DIdentity;
        transform.m34 = - 1.0/500.0;
        transform = CATransform3DRotate(transform, 0, 0, 1, 0);
        [self.menuBtnArray[index] layer].transform = transform;
        if (index == self.menuBtnArray.count - 1) _animationComplete = YES;
    }
}

- (NSMutableArray *)menuBtnArray{
    if (!_menuBtnArray) {
        _menuBtnArray = [[NSMutableArray alloc] init];
    }
    return _menuBtnArray;
}

@end
