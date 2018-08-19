//
//  DYLoadviewHud.h
//  DYKit
//
//  Created by Dainty on 2018/8/14.
//  Copyright © 2018年 DAINTY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface DYLoadviewHud : NSObject

+(instancetype)shareInstance;
@property (nonatomic, copy) NSString *message ;

+(instancetype) new __attribute__((unavailable("call sharedInstance instead")));
-(instancetype) copy __attribute__((unavailable("call sharedInstance instead")));
-(instancetype) mutableCopy __attribute__((unavailable("call sharedInstance instead")));

-(void)showLoading;
-(void)dismissLoading;

@end
