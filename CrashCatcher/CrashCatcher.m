//
//  CrashCatcher.m
//  SwiftLOL
//
//  Created by wangJiaJia on 16/4/12.
//  Copyright © 2016年 SwiftLOL. All rights reserved.
//

#import "CrashCatcher.h"

@interface CrashCatcher ()

@property(nonatomic,assign) NSInteger crashCount;

@property(nonatomic,assign) NSInteger launchCount;

@end

void unCaughtExceptionHandler(NSException * _Nullable  exception);
static NSString *const  ExceptionCatcherCrashCount =@"ExceptionCatcherCrashCount";
static NSString *const  ExceptionCatcherLaunchCount =@"ExceptionCatcherLaunchCount";


@implementation CrashCatcher


#pragma mark --initial

+(nonnull instancetype)shareInstance{
    
    static CrashCatcher *catcher =nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        catcher=[[CrashCatcher alloc] init];
    });
    
    return catcher;
}



//初始化  如果当前可以判断一定不是连续崩溃 清0
-(instancetype)init
{
    self=[super init];
    if(self)
    {
        NSSetUncaughtExceptionHandler(&unCaughtExceptionHandler);
        self.crashCount=[[[NSUserDefaults standardUserDefaults] objectForKey:ExceptionCatcherCrashCount] integerValue];
        self.launchCount=[[[NSUserDefaults standardUserDefaults] objectForKey:ExceptionCatcherLaunchCount] integerValue];
        [self recordLaunchInfo];
        //如果不是连续崩溃  清0
        if(self.launchCount-self.crashCount>=2)
        {
            [self cleanCrashInfo];
        }
    }
    return self;
}


#pragma mark --record crash、launch infomation

//判断是不是连续启动崩溃
-(BOOL)isContinuousCrash
{
    if(self.crashCount>=2&&(self.launchCount-self.crashCount<2))
        return YES;
    else
        return NO;
}


//清0
-(void)cleanCrashInfo
{
    self.crashCount=0;
    self.launchCount=0;
    [[NSUserDefaults standardUserDefaults] setObject:@0 forKey:ExceptionCatcherLaunchCount];
    [[NSUserDefaults standardUserDefaults] setObject:@0 forKey:ExceptionCatcherCrashCount];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}


//记录崩溃信息
-(void)recordCrashInfo
{
    if(self.crashCount==0)
        self.launchCount++;
    self.crashCount++;
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:self.launchCount] forKey:ExceptionCatcherLaunchCount];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:self.crashCount] forKey:ExceptionCatcherCrashCount];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


//记录启动信息
-(void)recordLaunchInfo
{
    if(self.crashCount != 0)
    {
        self.launchCount++;
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:self.launchCount] forKey:ExceptionCatcherLaunchCount];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
}



@end



#pragma mark -- global uncaught exception handle

//全局异常崩溃入口
void unCaughtExceptionHandler(NSException * exception){
    //如果是连续崩溃  再次崩溃不记录   始终认为连续崩溃
    if(![[CrashCatcher shareInstance] isContinuousCrash])
    {
        [[CrashCatcher shareInstance] recordCrashInfo];
    }
}
