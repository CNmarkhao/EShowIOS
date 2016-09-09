//
//  SettingViewController.m
//  EShowIOS
//
//  Created by 金璟 on 16/4/5.
//  Copyright © 2016年 金璟. All rights reserved.
//

#import "MeSettingViewController.h"
#import "TitleDisclosureCell.h"
#import "WebViewController.h"
#import "LoginViewController.h"
#import "SettingWebViewController.h"
#import "ApplyViewController.h"
@interface MeSettingViewController () <UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *myTableView;
@end

@implementation MeSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"系统设置";
    
    _myTableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        tableView.backgroundColor = ColorTableSectionBg;
        tableView.dataSource = self;
        tableView.delegate = self;
        [tableView registerClass:[TitleDisclosureCell class] forCellReuseIdentifier:kCellIdentifier_TitleDisclosure];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:tableView];
        [tableView mas_makeConstraints:^(MASConstraintMaker *make){
            make.edges.equalTo(self.view);
        }];
        tableView;
    });
}

#pragma mark Table
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger row = 0;
    switch (section) {
        case 0:
            row = 2;
            break;
            
         case 1:
            row = 2;
            break;
            
        default:
            row = 1;
            break;
    }
    return row;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TitleDisclosureCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_TitleDisclosure forIndexPath:indexPath];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [cell setTitleStr:@"意见反馈"];
        }else{
            [cell setTitleStr:@"常见问题"];
        }
    }else if (indexPath.section == 1){
    
        if (indexPath.row == 0) {
            [cell setTitleStr:@"关于我们"];
        }else{
            [cell setTitleStr:@"欢迎页"];
        }
    }else{
    
            [cell setTitleStr:@"退出系统"];
        
    }
    
    [tableView addLineforPlainCell:cell forRowAtIndexPath:indexPath withLeftSpace:kPaddingLeftWidth];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
    headerView.backgroundColor = ColorTableSectionBg;
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.5;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            SettingWebViewController *web_vc = [[SettingWebViewController alloc] init];
            web_vc.title = @"意见反馈";
            NSString *str = [NSString stringWithFormat:@"http://api.eshow.org.cn/info/feedback"];
            web_vc.url = str;
            [self.navigationController pushViewController:web_vc animated:YES];
        }
        else
        {
            SettingWebViewController *question_vc = [[SettingWebViewController alloc] init];
            question_vc.title = @"常见问题";
            NSString *str = [NSString stringWithFormat:@"http://api.eshow.org.cn/info/question"];
            question_vc.url = str;
            [self.navigationController pushViewController:question_vc animated:YES];
        }
    }
    else if (indexPath.section == 1)
    {
        if (indexPath.row == 0)
        {
            SettingWebViewController *about_vc = [[SettingWebViewController alloc] init];
            about_vc.title = @"关于我们";
            NSString *str = [NSString stringWithFormat:@"http://api.eshow.org.cn/info/about"];
            about_vc.url = str;
            [self.navigationController pushViewController:about_vc animated:YES];
        }
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"退出系统" message:@"是否确定退出登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            EMError *error = [[EMClient sharedClient] logout:YES];
            dispatch_async(dispatch_get_main_queue(), ^{
//                [weakSelf hideHud];
                if (error != nil) {
                    NSLog(@"%@",error.errorDescription);
//                    [weakSelf showHint:error.errorDescription];
                }
                else{
                    [[ApplyViewController shareController] clear];
                    [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
                }
            });
        });

    }
}


- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults removeObjectForKey:@"user.username"];
        [userDefaults removeObjectForKey:@"user.password"];
        [userDefaults synchronize];
        
        LoginViewController *vc = [[LoginViewController alloc] init];
        UINavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:vc];
        [self presentViewController:nav animated:YES completion:nil];
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
