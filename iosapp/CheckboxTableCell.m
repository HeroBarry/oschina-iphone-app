//
//  CheckBoxTableCell.m
//  iosapp
//
//  Created by chenhaoxiang on 5/25/15.
//  Copyright (c) 2015 oschina. All rights reserved.
//

#import "CheckboxTableCell.h"
#import "Utils.h"
#import "TeamMember.h"

#import "NSString+FontAwesome.h"

static NSString * const kReuseID = @"reuseID";

@interface CheckboxTableCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *descriptionLabel;

@end

@implementation CheckboxTableCell


- (id)initWithCellType:(CellType)type
{
    self = [super init];
    if (self) {
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor themeColor];
        
        [self initSubviews];
        [self setLayout];
        
        NSMutableAttributedString *attributedTitle = [[NSMutableAttributedString alloc] initWithString:
                                                      [NSString fontAwesomeIconStringForIconIdentifier:@[@"fa-inbox", @"fa-list", @"fa-user", @"fa-clock-o"][type]]
                                                                                            attributes:@{
                                                                                                         NSFontAttributeName: [UIFont fontWithName:kFontAwesomeFamilyName size:20],
                                                                                                         NSForegroundColorAttributeName: [UIColor grayColor]
                                                                                                         }];
        
        [attributedTitle appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"   %@", [@[@"项目", @"任务分组", @"指派人员", @"完成时间"] objectAtIndex:type]]]];
        
        _titleLabel.attributedText = attributedTitle;
        
        _descriptionLabel.text = @[@"不指定项目", @"未指定分组", @"未指派", @""][type];
    }
    
    return self;
}

- (void)initSubviews
{
    _titleLabel = [UILabel new];
    _titleLabel.font = [UIFont boldSystemFontOfSize:15];
    _titleLabel.numberOfLines = 0;
    _titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _titleLabel.textColor = [UIColor colorWithHex:0x555555];
    [self.contentView addSubview:_titleLabel];
    
    _descriptionLabel = [UILabel new];
    _descriptionLabel.font = [UIFont systemFontOfSize:13];
    _descriptionLabel.textColor = [UIColor grayColor];
    _descriptionLabel.text = @"不指定项目";
    [self.contentView addSubview:_descriptionLabel];
}

- (void)setLayout
{
    for (UIView *view in self.contentView.subviews) {view.translatesAutoresizingMaskIntoConstraints = NO;}
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_titleLabel, _descriptionLabel);
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[_titleLabel]-20-|"
                                                                             options:0 metrics:nil views:views]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-15-[_titleLabel]-[_descriptionLabel]-15-|"
                                                                             options:NSLayoutFormatAlignAllCenterY
                                                                             metrics:nil views:views]];
}


@end