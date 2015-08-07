//
//  ViewController.m
//  leftMenu
//
//  Created by chuck on 15-8-2.
//  Copyright (c) 2015年 ZK. All rights reserved.
//

#import "ViewController.h"
#import "leftMenuView.h"

#define kWidth 60
#define kHeight 44

@interface ViewController () <leftMenuViewDelegate>
@property(nonatomic,strong)UIImageView * imageView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(clickLeftBarButtonItem)];
    self.imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.image = [UIImage imageNamed:@"m1.jpg"];
    
    [self.view addSubview:self.imageView];
}

- (void)clickLeftBarButtonItem{
    leftMenuView *leftMenu = [[leftMenuView alloc] initLeftMenuView:@[@"cancel",@"jack",@"kson",@"mary",@"tom",@"chuck",@"kate",@"john"] imageNames:nil];
    leftMenu.delegate = self;
    [leftMenu show];
}

- (void)didSelectIndex:(NSInteger)index{
    self.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"m%d.jpg",index]];
    
    CGRect btnFrame = CGRectMake(0, 64 + (index - 1)*kHeight, kWidth, kHeight);
    
    CGFloat newR = sqrt((self.view.frame.size.width- btnFrame.size.width/2.0)*(self.view.frame.size.width-btnFrame.size.width/2.0) + (self.view.frame.size.height-btnFrame.size.height/2.0)*(self.view.frame.size.height-btnFrame.size.height/2.0));

    UIBezierPath * initPath = [UIBezierPath bezierPathWithOvalInRect:btnFrame];
    UIBezierPath * finalPath = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(btnFrame, - newR, - newR)];
    CAShapeLayer * maskLayer = [CAShapeLayer layer];
    maskLayer.path = [finalPath CGPath]; //设置最后的遮罩效果，从而不适用了动画forward的属性
    self.imageView.layer.mask = maskLayer; //注意我更改了这里。想让哪个图层包含遮罩效果就为哪个图层的mask添加遮罩即可。
    
    CABasicAnimation * animation = [CABasicAnimation animation];
    animation.keyPath = @"path";
    animation.fromValue = (__bridge id)([initPath CGPath]);
    animation.toValue = (__bridge id)([finalPath CGPath]);
    animation.duration = 1.0;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [maskLayer addAnimation:animation forKey:nil]; //注意是对遮罩层实现动画，而不是view.layer层
}


@end
