//
//  ActivitiesViewController.m
//  iosapp
//
//  Created by chenhaoxiang on 1/25/15.
//  Copyright (c) 2015 oschina. All rights reserved.
//

#import "ActivitiesViewController.h"
#import "OSCActivity.h"
#import "ActivityCell.h"
#import "ActivityDetailsViewController.h"

#import <SDWebImage/UIImageView+WebCache.h>

static NSString * const kActivtyCellID = @"ActivityCell";


@interface ActivitiesViewController ()

@end

@implementation ActivitiesViewController


- (instancetype)initWithUID:(int64_t)userID
{
    self = [super init];
    
    if (self) {
        self.generateURL = ^NSString * (NSUInteger page) {
            return [NSString stringWithFormat:@"%@%@?uid=%lld&pageIndex=%lu&%@", OSCAPI_PREFIX, OSCAPI_EVENT_LIST, userID, (unsigned long)page, OSCAPI_SUFFIX];
        };
        
        self.objClass = [OSCActivity class];
    }
    
    return self;
}


- (NSArray *)parseXML:(ONOXMLDocument *)xml
{
    return [[xml.rootElement firstChildWithTag:@"events"] childrenWithTag:@"event"];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView registerClass:[ActivityCell class] forCellReuseIdentifier:kActivtyCellID];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.objects.count) {
        ActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:kActivtyCellID forIndexPath:indexPath];
        OSCActivity *activity = self.objects[indexPath.row];
        
        cell.titleLabel.text       = activity.title;
        cell.descriptionLabel.text = [NSString stringWithFormat:@"时间：%@\n地点：%@", activity.startTime, activity.location];
        [cell.posterView sd_setImageWithURL:activity.coverURL placeholderImage:nil];
        
        return cell;
    } else {
        return self.lastCell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < self.objects.count) {
        OSCActivity *activity = self.objects[indexPath.row];
        
        self.label.text = activity.title;
        self.label.font = [UIFont boldSystemFontOfSize:14];
        CGFloat height = [self.label sizeThatFits:CGSizeMake(tableView.frame.size.width - 64, MAXFLOAT)].height;
        
        self.label.text = [NSString stringWithFormat:@"时间：%@\n地点：%@", activity.startTime, activity.location];
        self.label.font = [UIFont systemFontOfSize:13];
        height += [self.label sizeThatFits:CGSizeMake(tableView.frame.size.width - 64, MAXFLOAT)].height;
        
        return height + 26;
    } else {
        return 60;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger row = indexPath.row;
    
    if (row < self.objects.count) {
        OSCActivity *activity = self.objects[indexPath.row];
        ActivityDetailsViewController *activityVC = [[ActivityDetailsViewController alloc] initWithActivity:activity];
        [self.navigationController pushViewController:activityVC animated:YES];
    } else {
        [self fetchMore];
    }
}


@end