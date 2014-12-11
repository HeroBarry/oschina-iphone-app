//
//  MyInfoViewController.m
//  iosapp
//
//  Created by ChanAetern on 12/10/14.
//  Copyright (c) 2014 oschina. All rights reserved.
//

#import "MyInfoViewController.h"
#import "OSCUser.h"
#import "OSCAPI.h"
#import "Config.h"
#import "Utils.h"

#import <AFNetworking.h>
#import <AFOnoResponseSerializer.h>
#import <Ono.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface MyInfoViewController ()

@property (nonatomic, strong) OSCUser *user;

@property (nonatomic, strong) UIImageView *portrait;
@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UIButton *creditsBtn;
@property (nonatomic, strong) UIButton *collectionsBtn;
@property (nonatomic, strong) UIButton *followsBtn;
@property (nonatomic, strong) UIButton *fansBtn;

@end


@implementation MyInfoViewController

- (instancetype)initWithUser:(OSCUser *)user
{
    self = [super init];
    if (!self) {return nil;}
    
    _user = user;
    
    return self;
}

- (instancetype)initWithUserID:(int64_t)userID
{
    self = [super init];
    if (!self) {return self;}
    
    __block BOOL done = NO;
    __block OSCUser *tmpUser;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFOnoResponseSerializer XMLResponseSerializer];
    [manager GET:[NSString stringWithFormat:@"%@%@?uid=%lld&hisuid=%lld&pageIndex=0&pageSize=20", OSCAPI_PREFIX, OSCAPI_USER_INFORMATION, [Config getOwnID], userID]
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, ONOXMLDocument *responseDocument) {
             ONOXMLElement *userXML = [responseDocument.rootElement firstChildWithTag:@"user"];
             tmpUser = [[OSCUser alloc] initWithXML:userXML];
             done = YES;
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"网络异常，错误码：%ld", (long)error.code);
             done = YES;
         }];
    
    while (!done) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    _user = tmpUser;
    
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIView *footer = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.tableFooterView = footer;
    
    self.view.backgroundColor = [UIColor colorWithHex:0xF5F5F5];
}



- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *header = [UIView new];
    header.backgroundColor = [UIColor colorWithHex:0x00CD66];
    
    _portrait = [UIImageView new];
    _portrait.contentMode = UIViewContentModeScaleAspectFit;
    [_portrait setCornerRadius:25];
    [_portrait sd_setImageWithURL:_user.portraitURL placeholderImage:nil];
    [header addSubview:_portrait];
    
    _nameLabel = [UILabel new];
    _nameLabel.text = _user.name;
    [header addSubview:_nameLabel];
    
    UIView *countView = [UIView new];
    [header addSubview:countView];
    
    _creditsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _collectionsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _followsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _fansBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    void (^setButtonStyle)(UIButton *, NSString *) = ^(UIButton *button, NSString *title) {
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        [button setTitle:title forState:UIControlStateNormal];
        [countView addSubview:button];
    };
    
    setButtonStyle(_creditsBtn, [NSString stringWithFormat:@"积分\n%lu", _user.score]);
    setButtonStyle(_collectionsBtn, [NSString stringWithFormat:@"收藏\n83", nil]);
    setButtonStyle(_followsBtn, [NSString stringWithFormat:@"关注\n%lu", _user.followersCount]);
    setButtonStyle(_fansBtn, [NSString stringWithFormat:@"粉丝\n%lu", _user.fansCount]);
    
    for (UIView *view in header.subviews) {view.translatesAutoresizingMaskIntoConstraints = NO;}
    for (UIView *view in countView.subviews) {view.translatesAutoresizingMaskIntoConstraints = NO;}
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_portrait, _nameLabel, _creditsBtn, _collectionsBtn, _followsBtn, _fansBtn, countView);
    NSDictionary *metrics = @{@"width": @(tableView.frame.size.width / 4)};
    
    [header addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-15-[_portrait(50)]-8-[_nameLabel]-15-[countView(50)]|"
                                                                   options:NSLayoutFormatAlignAllCenterX metrics:nil views:views]];
    [header addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[_portrait(50)]" options:0 metrics:nil views:views]];
    [header addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[countView]|" options:0 metrics:nil views:views]];
    
    
    [countView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[_creditsBtn(width)][_collectionsBtn(width)][_followsBtn(width)][_fansBtn(width)]|"
                                                                      options:NSLayoutFormatAlignAllTop | NSLayoutFormatAlignAllBottom metrics:metrics views:views]];
    [countView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_creditsBtn]|" options:0 metrics:nil views:views]];
    
    return header;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [UITableViewCell new];
    
    UIView *selectedBackground = [UIView new];
    selectedBackground.backgroundColor = [UIColor colorWithHex:0xF5FFFA];
    [cell setSelectedBackgroundView:selectedBackground];
    
    cell.textLabel.text = @[@"消息", @"团队", @"博客", @"便签"][indexPath.row];
    //cell.imageView.image = [UIImage imageNamed:@[@"", @"", @"", @""][indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 158;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}





@end