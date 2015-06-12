//
//  UIColor+Util.m
//  iosapp
//
//  Created by chenhaoxiang on 14-10-18.
//  Copyright (c) 2014年 oschina. All rights reserved.
//

#import "UIColor+Util.h"
#import "AppDelegate.h"

@implementation UIColor (Util)

#pragma mark - Hex

+ (UIColor *)colorWithHex:(int)hexValue alpha:(CGFloat)alpha
{
    return [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0
                           green:((float)((hexValue & 0xFF00) >> 8))/255.0
                            blue:((float)(hexValue & 0xFF))/255.0
                           alpha:alpha];
}

+ (UIColor *)colorWithHex:(int)hexValue
{
    return [UIColor colorWithHex:hexValue alpha:1.0];
}


#pragma mark - theme colors

+ (UIColor *)themeColor
{
    if (((AppDelegate *)[UIApplication sharedApplication].delegate).inNightMode) {
        return [UIColor colorWithRed:0.17 green:0.17 blue:0.17 alpha:1.0];
    }
    return [UIColor colorWithRed:235.0/255 green:235.0/255 blue:243.0/255 alpha:1.0];
}

+ (UIColor *)nameColor
{
    if (((AppDelegate *)[UIApplication sharedApplication].delegate).inNightMode) {
        return [UIColor colorWithRed:37.0/255 green:147.0/255 blue:58.0/255 alpha:1.0];
    }
    return [UIColor colorWithHex:0x087221];
}

+ (UIColor *)titleColor
{
    if (((AppDelegate *)[UIApplication sharedApplication].delegate).inNightMode) {
        return [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0];
    }
    return [UIColor blackColor];
}

+ (UIColor *)separatorColor
{
    if (((AppDelegate *)[UIApplication sharedApplication].delegate).inNightMode) {
        return [UIColor colorWithRed:0.234 green:0.234 blue:0.234 alpha:1.0];
    }
    return [UIColor colorWithRed:217.0/255 green:217.0/255 blue:223.0/255 alpha:1.0];
}

+ (UIColor *)cellsColor
{
    if (((AppDelegate *)[UIApplication sharedApplication].delegate).inNightMode) {
        return [UIColor colorWithRed:0.17 green:0.17 blue:0.17 alpha:1.0];
    }
    return [UIColor whiteColor];
}

+ (UIColor *)titleBarColor
{
    if (((AppDelegate *)[UIApplication sharedApplication].delegate).inNightMode) {
        return  [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0];
    }
    return [UIColor colorWithHex:0xE1E1E1];
}

+ (UIColor *)selectTitleBarColor
{
    
    if (((AppDelegate *)[UIApplication sharedApplication].delegate).inNightMode) {
        return  [UIColor colorWithRed:0.067 green:0.282 blue:0.094 alpha:1.0];
    }
    return [UIColor colorWithHex:0xE1E1E1];
}

+ (UIColor *)navigationbarColor
{
    if (((AppDelegate *)[UIApplication sharedApplication].delegate).inNightMode) {
        return [UIColor colorWithRed:0.067 green:0.282 blue:0.094 alpha:1.0];
    }
    return [UIColor colorWithHex:0x15A230];//0x009000
}

+ (UIColor *)selectCellSColor
{
    if (((AppDelegate *)[UIApplication sharedApplication].delegate).inNightMode) {
        return [UIColor colorWithRed:23.0/255 green:23.0/255 blue:23.0/255 alpha:1.0];
    }
    return [UIColor colorWithRed:203.0/255 green:203.0/255 blue:203.0/255 alpha:1.0];
}


@end
