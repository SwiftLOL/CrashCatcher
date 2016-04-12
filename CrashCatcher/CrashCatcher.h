//
//  CrashCatcher.h
//  SwiftLOL
//
//  Created by wangJiaJia on 16/4/12.
//  Copyright © 2016年 SwiftLOL. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 
 用法：
 1. 在didFinishLaunchingWithOptions里,判断是否连续崩溃，做相应操作:
 if(![[CrashCatcher ExceptionCatcher] isContinuousCrash])
 {
 //for example,load local js file by JSPatch
 }
 

 
 原理: 设计两个标志
 1.launchCount  第几次启动
 2.crashCount   第几次崩溃
 只要不发生崩溃，两者一直为0。当第一次发生崩溃的时候，两者都＋1,此时都为1，记为第一次启动并且崩溃。第二次启动的时候,luanchCount++，这时两者分别为2\1。如果这个时候再次崩溃，crashCount++,此时两者均为2，则被视为连续崩溃。如果没有发生崩溃，则下次打开app时，lauchCount++,这个时候可以认为是不连续崩溃，清0。之后循环。。。。。
 
 */



@interface CrashCatcher : NSObject

//获取异常捕手单例
+(nonnull instancetype)shareInstance;

//判断是不是连续启动崩溃
-(BOOL)isContinuousCrash;

//清除启动和崩溃纪录
-(void)cleanCrashInfo;






@end
