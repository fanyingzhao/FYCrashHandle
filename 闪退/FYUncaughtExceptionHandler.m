//
//  FYUncaughtExceptionHandler.m
//  闪退
//
//  Created by mac on 15/10/20.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import "FYUncaughtExceptionHandler.h"

static NSDateFormatter* formatter;
@implementation FYUncaughtExceptionHandler

+ (void)load
{
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    
    NSString* direction = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"Crash"];
    [FYUncaughtExceptionHandler createDirectionWithUrl:direction];
}

void uncaughtExceptionHandler(NSException *exception)

{
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM-dd HH-mm-ss"];
    
    // 异常的堆栈信息
    NSArray *stackArray = [exception callStackSymbols];
    
    // 出现异常的原因
    NSString *reason = [exception reason];
    
    // 异常名称
    NSString *name = [exception name];
    
    NSString *exceptionInfo = [NSString stringWithFormat:@"Exception reason：%@\nException name：%@\nException stack：%@",name, reason, stackArray];
    
    NSMutableArray *tmpArr = [NSMutableArray arrayWithArray:stackArray];
    
    [tmpArr insertObject:reason atIndex:0];
    
    
    [exceptionInfo writeToFile:[FYUncaughtExceptionHandler crashDirector] atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

#pragma mark - helper
+ (NSString*)crashDirector
{
    NSBundle* bundle = [NSBundle mainBundle];
    NSDictionary* info = [bundle infoDictionary];
    NSString* prodName = [info objectForKey:@"CFBundleName"];
    
    NSString* date = [FYUncaughtExceptionHandler currentTime];
    NSString* time = [[date componentsSeparatedByString:@" "] lastObject];
    
    return [NSString stringWithFormat:@"%@/%@(%@).txt",[FYUncaughtExceptionHandler createCurrentDateDirection],prodName,time];
}

+ (NSString*)createCurrentDateDirection
{
    NSString* cash = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"Crash"];
    
    NSString* date = [FYUncaughtExceptionHandler currentTime];
    NSString* currentDate = [FYUncaughtExceptionHandler currentDate:date];
    NSString* direction = [cash stringByAppendingString:[NSString stringWithFormat:@"/%@",currentDate]];
    
    [FYUncaughtExceptionHandler createDirectionWithUrl:direction];
    
    return direction;
}

+ (NSString*)currentDate:(NSString*)date
{
    if ([FYUncaughtExceptionHandler checkStringIsValid:date]) {
        
        NSArray* array = [date componentsSeparatedByString:@" "];
        return [array firstObject];
    }
    
    return nil;
}

+ (BOOL)checkStringIsValid:(NSString*)string
{
    return ((nil == string) || [string isEqual:[NSNull null]] || [string isEqualToString:@"(null)"] || [string isEqualToString:@""])?nil:string;
}

+ (void)createDirectionWithUrl:(NSString*)urlString
{
    NSFileManager* file = [NSFileManager defaultManager];
    BOOL isDir;
    BOOL result = [file fileExistsAtPath:urlString isDirectory:&isDir];
    
    if (!(isDir && result)) {
        [[NSFileManager defaultManager] createDirectoryAtPath:urlString withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

+ (NSString*)currentTime
{
    return [formatter stringFromDate:[NSDate date]];
}
@end
