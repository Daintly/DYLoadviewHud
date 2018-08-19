//
//  DYLoadviewHud.m
//  DYKit
//
//  Created by Dainty on 2018/8/14.
//  Copyright © 2018年 DAINTY. All rights reserved.
//
#define DYSCREEN_W [UIScreen mainScreen].bounds.size.width
#define DYSCREEN_H [UIScreen mainScreen].bounds.size.height

#define ANIMATION_DURATION_SECS 0.5f
#import "DYLoadviewHud.h"
@interface DYLoadviewHud ()

@property (nonatomic, assign) int stepNumber;
@property (nonatomic, assign) BOOL isAnimating;
@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) UIView *loadView;
@end
@implementation DYLoadviewHud{
UIImageView *_shapView;
UIImageView *_shadowView;
float _toValue;
float _fromValue;

float _scaletoValue;
float _scalefromValue;

UILabel *_label;
}
+ (void)initialize{
    [DYLoadviewHud shareInstance];
}

+(instancetype)shareInstance{
    static  DYLoadviewHud *load = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (load == nil) {
            load = [[DYLoadviewHud alloc] init];
        }
    });
    
    
    return load;
    
}
- (void)showloadingWith:(NSString *)status{
    [self showLoading];
    
    _message = status;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.loadView removeFromSuperview];
        self.loadView = nil;
        [self stopAnimating];
    });
    
}
- (void)setMessage:(NSString *)message{
    _message = message;
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        _label.text = message;
    });
    
}
- (void)dismissLoading{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)( 1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.loadView removeFromSuperview];
        self.loadView = nil;
        [self stopAnimating];
    });
    
    
}
- (void)showLoading{
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.loadView];
    [self step];
    [self startAnimating];
    
}


- (UIView *)loadView{
    if (!_loadView) {
        _loadView = [UIView new];
        
        _loadView.backgroundColor = [UIColor colorWithWhite:50 / 255.0f alpha:0.3];
        
        _loadView.layer.cornerRadius =10;
        _loadView.layer.masksToBounds = YES;
        
        [_loadView setFrame: CGRectMake([UIScreen mainScreen].bounds.size.width/2-100/2, [UIScreen mainScreen].bounds.size.height/2-120/2, 120, 120)];
        
        
    }return _loadView;
}



-(void) step
{
    
    
    
    _shapView=[[UIImageView alloc] init];
    _shapView.frame=CGRectMake(self.loadView.frame.size.width/2-31/2, 0, 31, 31);
    _shapView.image=[UIImage imageNamed:@"loadingView.bundle/loading_circle"];//DY_Picture.bundle/hx_original_normal@2x
    _shapView.contentMode=UIViewContentModeScaleAspectFit;
    [self.loadView addSubview:_shapView];
    
    
    
    
    //阴影
    _shadowView=[[UIImageView alloc] init];
    _shadowView.frame=CGRectMake(self.loadView.frame.size.width/2-37/2, self.loadView.frame.size.height-2.5-30, 37, 2.5);
    _shadowView.image=[UIImage imageNamed:@"loadingView.bundle/loading_shadow"];
    [self.loadView addSubview:_shadowView];
    
    
    _label=[[UILabel alloc] init];
    _label.frame=CGRectMake(0, self.loadView.frame.size.height-20, self.loadView.frame.size.width, 20);
    _label.textColor=[UIColor grayColor];
    _label.textAlignment=NSTextAlignmentCenter;
    _label.text= self.message;
    _label.font=[UIFont systemFontOfSize:13.0f];
    
    [self.loadView addSubview:_label];
    
    
    
    _fromValue=_shapView.frame.size.height/2;
    _toValue=self.loadView.frame.size.height-30-_shapView.frame.size.height/2-_shadowView.frame.size.height;
    
    
    _scalefromValue=0.3f;
    _scaletoValue=1.0f;
    
    self.loadView.alpha=0;
    
}


-(void) startAnimating
{
    
    if (!_isAnimating)
    {
        _isAnimating = YES;
        
        self.loadView.alpha=1;
        
        //        self.displayLink = [CADisplayLink displayLinkWithTarget:self
        //                                                       selector:@selector(handleDisplayLink:)];
        //        [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop]
        //                               forMode:NSDefaultRunLoopMode];
        
        _timer = [NSTimer scheduledTimerWithTimeInterval:ANIMATION_DURATION_SECS target:self selector:@selector(animateNextStep) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
    }
    
}


-(void) stopAnimating
{
    
    _isAnimating = NO;
    
    [_timer invalidate];
    
    _stepNumber = 0;
    
    self.loadView.alpha=0;
    
    
    [_shapView.layer removeAllAnimations];
    
    [_shadowView.layer removeAllAnimations];
    
    _shapView.image=[UIImage imageNamed:@"loadingView.bundle/loading_circle"];
    
    
}


-(void)animateNextStep
{
    switch (_stepNumber)
    {
        case 0:
        {
            
            
            _shapView.image=[UIImage imageNamed:@"loadingView.bundle/loading_circle"];
            
            
            [self loadingAnimation:_fromValue toValue:_toValue timingFunction:kCAMediaTimingFunctionEaseIn];
            
            [self scaleAnimation:_scalefromValue toValue:_scaletoValue timingFunction:kCAMediaTimingFunctionEaseIn];
            
            
        }
            break;
        case 1:
        {
            
            
            _shapView.image=[UIImage imageNamed:@"loadingView.bundle/loading_square"];
            
            [self loadingAnimation:_toValue toValue:_fromValue timingFunction:kCAMediaTimingFunctionEaseOut];
            
            [self scaleAnimation:_scaletoValue toValue:_scalefromValue timingFunction:kCAMediaTimingFunctionEaseIn];
            
        }
            break;
        case 2:
        {
            
            
            
            _shapView.image=[UIImage imageNamed:@"loadingView.bundle/loading_square"];
            
            [self loadingAnimation:_fromValue toValue:_toValue timingFunction:kCAMediaTimingFunctionEaseIn];
            
            [self scaleAnimation:_scalefromValue toValue:_scaletoValue timingFunction:kCAMediaTimingFunctionEaseIn];
            
            
        }
            break;
            
        case 3:
        {
            
            _shapView.image=[UIImage imageNamed:@"loadingView.bundle/loading_triangle"];
            
            
            [self loadingAnimation:_toValue toValue:_fromValue timingFunction:kCAMediaTimingFunctionEaseOut];
            
            [self scaleAnimation:_scaletoValue toValue:_scalefromValue timingFunction:kCAMediaTimingFunctionEaseIn];
            
            
            
        }
            
            break;
            
        case 4:
        {
            
            _shapView.image=[UIImage imageNamed:@"loadingView.bundle/loading_triangle"];
            
            [self loadingAnimation:_fromValue toValue:_toValue timingFunction:kCAMediaTimingFunctionEaseIn];
            
            
            [self scaleAnimation:_scalefromValue toValue:_scaletoValue timingFunction:kCAMediaTimingFunctionEaseIn];
            
        }
            
            break;
        case 5:
        {
            
            _shapView.image=[UIImage imageNamed:@"loadingView.bundle/loading_circle"];
            
            [self loadingAnimation:_toValue toValue:_fromValue timingFunction:kCAMediaTimingFunctionEaseOut];
            
            [self scaleAnimation:_scaletoValue toValue:_scalefromValue timingFunction:kCAMediaTimingFunctionEaseIn];
            
            
            _stepNumber = -1;
            
        }
            
            break;
            
        default:
            break;
    }
    
    _stepNumber++;
}


-(void) loadingAnimation:(float)fromValue toValue:(float)toValue timingFunction:(NSString * const)tf
{
    
    
    //位置
    CABasicAnimation *panimation = [CABasicAnimation animation];
    panimation.keyPath = @"position.y";
    panimation.fromValue =@(fromValue);
    panimation.toValue = @(toValue);
    panimation.duration = ANIMATION_DURATION_SECS;
    
    panimation.timingFunction = [CAMediaTimingFunction functionWithName:tf];
    
    
    //旋转
    CABasicAnimation *ranimation = [CABasicAnimation animation];
    ranimation.keyPath = @"transform.rotation";
    ranimation.fromValue =@(0);
    ranimation.toValue = @(M_PI_2);
    ranimation.duration = ANIMATION_DURATION_SECS;
    
    ranimation.timingFunction = [CAMediaTimingFunction functionWithName:tf];
    
    
    
    //组合
    CAAnimationGroup *group = [[CAAnimationGroup alloc] init];
    group.animations = @[ panimation,ranimation];
    group.duration = ANIMATION_DURATION_SECS;
    group.beginTime = 0;
    group.fillMode=kCAFillModeForwards;
    group.removedOnCompletion = NO;
    
    
    [_shapView.layer addAnimation:group forKey:@"basic"];
    
    
    
    
    
}

-(void) scaleAnimation:(float) fromeValue toValue:(float)toValue timingFunction:(NSString * const)tf
{
    
    //缩放
    CABasicAnimation *sanimation = [CABasicAnimation animation];
    sanimation.keyPath = @"transform.scale";
    sanimation.fromValue =@(fromeValue);
    sanimation.toValue = @(toValue);
    sanimation.duration = ANIMATION_DURATION_SECS;
    
    sanimation.fillMode = kCAFillModeForwards;
    sanimation.timingFunction = [CAMediaTimingFunction functionWithName:tf];
    sanimation.removedOnCompletion = NO;
    
    [_shadowView.layer addAnimation:sanimation forKey:@"shadow"];
    
    
}


- (BOOL)isAnimating
{
    return _isAnimating;
}



- (void)dealloc
{
    
    
    
    
}
@end
