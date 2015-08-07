//
//  leftMenuView.h
//  leftMenu
//
//  Created by chuck on 15-8-2.
//  Copyright (c) 2015年 ZK. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  leftMenuViewDelegate<NSObject>

- (void)didSelectIndex:(NSInteger)index;

@end

@interface leftMenuView : UIView
@property(nonatomic,strong)NSArray * titlesArray;
@property(nonatomic,strong)NSArray * imageNamesArray;
@property(nonatomic,strong)UIButton * handerView;
@property(nonatomic,strong)NSMutableArray * menuBtnArray;
@property(nonatomic,weak)UIButton * cancelBtn;
@property(nonatomic,assign)NSInteger  animationCompleteCount;
@property(nonatomic,assign)BOOL removeFlag;
@property(nonatomic,assign)BOOL animationComplete;

@property(nonatomic,weak)id<leftMenuViewDelegate>delegate;

- (id)initLeftMenuView:(NSArray *)titles imageNames:(NSArray *)imageNames;
- (void)show;
- (void)dismiss;
@end
