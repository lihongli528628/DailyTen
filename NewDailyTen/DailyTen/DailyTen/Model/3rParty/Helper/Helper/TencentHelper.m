//
//  TencentHelper.m
//  weiboDemo
//
//  Created by lebo on 13-5-28.
//  Copyright (c) 2013年 lihongli. All rights reserved.
//

#import "TencentHelper.h"
#import "GetIPAddress.h"

#define tencent_client_id       @"tencent_client_id"
#define tencent_client_openid   @"tencent_client_openid"
#define tencent_token           @"tencent_token"
#define tencent_expirationDate  @"tencent_expirationDate"
#define tencent_redirectURI     @"tencent_redirectURI"

@implementation TencentHelper

static TencentHelper *helper = nil;


// 获取手机ip
- (NSString *)getIPAddress{
    // 本机ip
    InitAddresses();
    GetIPAddresses();
    GetHWAddresses();
    
    NSLog(@"%s", ip_names[1]);
    NSString *ip  = [NSString stringWithUTF8String:ip_names[1]];
    return ip;
}

+ (id)shareInstance{
    if (!helper) {
        helper = [[TencentHelper alloc] init];
        [helper instanceOauthHelper:(id)helper];
    }
    return helper;
}

- (void)instanceOauthHelper:(id)helper{
    self.tencentOauth = [[TencentOAuth alloc] initWithAppId:tencentAppID andDelegate:helper];
    NSArray* permissions = [NSArray arrayWithObjects:
                            kOPEN_PERMISSION_GET_USER_INFO,
                            kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
                            kOPEN_PERMISSION_ADD_ALBUM,
                            kOPEN_PERMISSION_ADD_IDOL,
                            kOPEN_PERMISSION_ADD_ONE_BLOG,
                            kOPEN_PERMISSION_ADD_PIC_T,
                            kOPEN_PERMISSION_ADD_SHARE,
                            kOPEN_PERMISSION_ADD_TOPIC,
                            kOPEN_PERMISSION_CHECK_PAGE_FANS,
                            kOPEN_PERMISSION_DEL_IDOL,
                            kOPEN_PERMISSION_DEL_T,
                            kOPEN_PERMISSION_GET_FANSLIST,
                            kOPEN_PERMISSION_GET_IDOLLIST,
                            kOPEN_PERMISSION_GET_INFO,
                            kOPEN_PERMISSION_GET_OTHER_INFO,
                            kOPEN_PERMISSION_GET_REPOST_LIST,
                            kOPEN_PERMISSION_LIST_ALBUM,
                            kOPEN_PERMISSION_UPLOAD_PIC,
                            kOPEN_PERMISSION_GET_VIP_INFO,
                            kOPEN_PERMISSION_GET_VIP_RICH_INFO,
                            kOPEN_PERMISSION_GET_INTIMATE_FRIENDS_WEIBO,
                            kOPEN_PERMISSION_MATCH_NICK_TIPS_WEIBO,
                            //微云的api权限
                            @"upload_pic",
                            @"download_pic",
                            @"get_pic_list",
                            @"delete_pic",
                            @"upload_pic",
                            @"download_pic",
                            @"get_pic_list",
                            @"delete_pic",
                            @"get_pic_thumb",
                            @"upload_music",
                            @"download_music",
                            @"get_music_list",
                            @"delete_music",
                            @"upload_video",
                            @"download_video",
                            @"get_video_list",
                            @"delete_video",
                            @"upload_photo",
                            @"download_photo",
                            @"get_photo_list",
                            @"delete_photo",
                            @"get_photo_thumb",
                            @"check_record",
                            @"create_record",
                            @"delete_record",
                            @"get_record",
                            @"modify_record",
                            @"query_all_record",
                            nil];
    self.permissions = permissions;
//    self.permissions = @[@"get_user_info",@"add_share", @"add_topic",@"add_one_blog", @"list_album",@"upload_pic",@"list_photo", @"add_album", @"check_page_fans"];
}

+ (BOOL)isSessionValid{
    helper = [TencentHelper shareInstance];
    [helper getTokenMessage];
    NSLog(@"%d" , [helper.tencentOauth isSessionValid]);
    return [helper.tencentOauth isSessionValid];
}

+ (void)login:(id)delegate{
    helper = [TencentHelper shareInstance];
    helper.TencentDelegate = delegate;
    [helper.tencentOauth authorize:helper.permissions inSafari:NO];
}

+ (void)login:(id)delegate naVC:(UINavigationController *)naVC{
    helper = [TencentHelper shareInstance];
    helper.TencentDelegate = delegate;
    [helper.tencentOauth authorize:helper.permissions inSafari:NO];
}

+ (void)logout:(id)delegate{
    helper = [TencentHelper shareInstance];
    helper.TencentDelegate = delegate;
    [helper.tencentOauth logout:helper];
}

+ (void)shareToQZoneTitle:(NSString *)title url:(NSString *)url comment:(NSString *)comment summary:(NSString *)summary images:(NSString *)images type:(NSString *)type playurl:(NSString *)playurl delegate:(id)delegate
{
    helper = [TencentHelper shareInstance];
    helper.TencentDelegate = delegate;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (title)[params setObject:title forKey:@"title"];
    if (url)[params setObject:url forKey:@"url"];
    if (comment) [params setObject:comment forKey:@"comment"];
    [params setObject:APPLICATIONDISCRIPTION forKey:@"summary"];
    if (images) [params setObject:images forKey:@"images"];
    if (type) [params setObject:@"5" forKey:@"type"];
    if (playurl) [params setObject:playurl forKey:@"playurl"];
    [params setObject:APPLICATIONTITLE forKey:@"site"];
    [params setObject:@"json" forKey:@"format"];
    [params setObject:@"http://lebooo.com" forKey:@"fromurl"];
    [params setObject:@"1" forKey:@"nswb"];
    [helper.tencentOauth addShareWithParams:params];
}

+ (NSString *)getUserNikeName:(id)delegate{
    
    NSString *nickName = [[NSUserDefaults standardUserDefaults] objectForKey:@"tencentNickName"];
    
    if (!nickName) {
        [TencentHelper getUserInfo:delegate];
    }
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"tencentNickName"];
}

+ (void)getUserInfo:(id)delegate{
    helper = [TencentHelper shareInstance];
    helper.TencentDelegate = delegate;
    
    if (NO == [[helper tencentOauth] getUserInfo])
    {
        NSLog(@"获取用户信息失败");
    };
    return;
}

// 腾讯微博图片微博：
+ (void)tenxunWeiboSharePicContent:(NSString *)content pic:(UIImage *)previewImage syncflag:(BOOL)syncflag target:(id)target{
    helper = [TencentHelper shareInstance];
    helper.TencentDelegate = target;
    
//    WeiBo_add_pic_t_POST *request = [[WeiBo_add_pic_t_POST alloc] init];
//    request.param_pic = previewImage;
//    request.param_content = content;
//    request.param_compatibleflag = @"0x2|0x4|0x8|0x20";
//    request.param_latitude = @"39.909407";
//    request.param_longitude = @"116.397521";
//    
//    if(NO == [helper.tencentOauth sendAPIRequest:request callback:helper])
//    {
//        NSLog(@"失败");
//    }
}

// 腾讯微博文字微博：
+ (void)tenxunWeiboShareTextContent:(NSString *)content  syncflag:(BOOL)syncflag target:(id)target{
    helper = [TencentHelper shareInstance];
    helper.TencentDelegate = target;
    
//    WeiBo_add_t_POST *request = [[WeiBo_add_t_POST alloc] init];
//    request.param_content = content;
//    request.param_compatibleflag = @"0x2|0x4|0x8|0x20";
//    request.param_latitude = @"39.909407";
//    request.param_longitude = @"116.397521";
//    
//    if(NO == [helper.tencentOauth sendAPIRequest:request callback:helper])
//    {
//        NSLog(@"失败");
//    }
}

// 腾讯微博视频微博：
/*******
 * 视频接口暂时不可使用
 */
/*****
+ (void)tenxunWeiboShareVideoContent:(NSString *)content videoUrl:(NSString *)videoUrl  syncflag:(BOOL)syncflag target:(id)target{
    helper = [TencentHelper shareInstance];
    helper.TencentDelegate = target;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"json" forKey:@"format"];
    if(content)     [params setObject:content forKey:@"content"];
    if(videoUrl)    [params setObject:videoUrl forKey:@"video_url"];
    [params setObject:[helper getIPAddress] forKey:@"clientip"];
    [params setObject:[NSString stringWithFormat:@"%d",syncflag] forKey:@"syncflag"];
    
    [helper.tencentOauth shareAddVideoWithParams:params];
}
 */


- (void)saveTokenMessage{
    [[NSUserDefaults standardUserDefaults] setObject:self.tencentOauth.accessToken forKey:tencent_token];
    [[NSUserDefaults standardUserDefaults] setObject:self.tencentOauth.openId forKey:tencent_client_openid];
    [[NSUserDefaults standardUserDefaults] setObject:self.tencentOauth.redirectURI forKey:tencent_redirectURI];
    [[NSUserDefaults standardUserDefaults] setObject:self.tencentOauth.localAppId forKey:tencent_client_id];
    [[NSUserDefaults standardUserDefaults] setObject:self.tencentOauth.expirationDate forKey:tencent_expirationDate];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

// 获取token信息
- (void)getTokenMessage{
    self.tencentOauth.accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:tencent_token];
    self.tencentOauth.expirationDate = [[NSUserDefaults standardUserDefaults] objectForKey:tencent_expirationDate];
    self.tencentOauth.openId = [[NSUserDefaults standardUserDefaults] objectForKey:tencent_client_openid];
    self.tencentOauth.localAppId = [[NSUserDefaults standardUserDefaults] objectForKey:tencent_client_id];
    self.tencentOauth.localAppId = [[NSUserDefaults standardUserDefaults] objectForKey:tencent_redirectURI];
}

// 移除token信息
- (void)deleteTokenMessage{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:tencent_token];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:tencent_client_id];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:tencent_client_openid];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:tencent_expirationDate];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:tencent_redirectURI];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - callback
- (void)tencentDidLogin
{
    [self deleteTokenMessage];
    [self saveTokenMessage];
    [TencentHelper getUserInfo:self.TencentDelegate];
    if ([[TencentHelper shareInstance] TencentDelegate]){
        if ([[[TencentHelper shareInstance] TencentDelegate] respondsToSelector:@selector(tencentDidLoginSuccess)]) {
            [[[TencentHelper shareInstance] TencentDelegate] performSelector:@selector(tencentDidLoginSuccess)];
        }
    }

}

- (void)tencentDidNotLogin:(BOOL)cancelled{
    NSLog(@"登录失败");
    if ([[TencentHelper shareInstance] TencentDelegate]){
        if ([[[TencentHelper shareInstance] TencentDelegate] respondsToSelector:@selector(tencentDidDotLogined:)]) {
            [[[TencentHelper shareInstance] TencentDelegate] performSelector:@selector(tencentDidDotLogined:) withObject:[NSNumber numberWithBool:cancelled]];
        }
    }
}

- (void)tencentDidNotNetWork{
    NSLog(@"无网络");
    if ([[TencentHelper shareInstance] TencentDelegate]){
        if ([[[TencentHelper shareInstance] TencentDelegate] respondsToSelector:@selector(tencentDidNotNetWork)]) {
            [[[TencentHelper shareInstance] TencentDelegate] performSelector:@selector(tencentDidNotNetWork)];
        }
    }
}

- (void)tencentDidLogout
{
    [self deleteTokenMessage];
    if ([[TencentHelper shareInstance] TencentDelegate]){
        if ([[[TencentHelper shareInstance] TencentDelegate] respondsToSelector:@selector(tencentDidLogout)]) {
            [[[TencentHelper shareInstance] TencentDelegate] performSelector:@selector(tencentDidLogout)];
        }
    }
}

// 分享回调
- (void)addShareResponse:(APIResponse *)response
{
    if (response.retCode == URLREQUEST_SUCCEED) {
        NSMutableString *message = [NSMutableString string];
        for (id key in response.jsonResponse) {
            [message appendString:[NSString stringWithFormat:@"%@:%@\n", key, [response.jsonResponse objectForKey:key]]];
        }
        
        if (((TencentHelper*)[TencentHelper shareInstance]).TencentDelegate){
            if ([((TencentHelper*)[TencentHelper shareInstance]).TencentDelegate respondsToSelector:@selector(tencentshareSuccess:)]) {
                [((TencentHelper*)[TencentHelper shareInstance]).TencentDelegate performSelector:@selector(tencentshareSuccess:) withObject:message];
            }
        }
        
    } else {
        if (((TencentHelper*)[TencentHelper shareInstance]).TencentDelegate){
            if ([((TencentHelper*)[TencentHelper shareInstance]).TencentDelegate respondsToSelector:@selector(tencentshareFail:)]) {
                [((TencentHelper*)[TencentHelper shareInstance]).TencentDelegate performSelector:@selector(tencentshareFail:) withObject:response.errorMsg];
            }
        }
    }
}

// 腾讯微博回调
- (void)cgiRequest:(TCAPIRequest *)request didResponse:(APIResponse *)response
{
    if (URLREQUEST_SUCCEED == response.retCode && kOpenSDKErrorSuccess == response.detailRetCode)
    {
        NSMutableString *message=[NSMutableString stringWithFormat:@""];
        for (id key in response.jsonResponse)
        {
            [message appendString: [NSString stringWithFormat:@"%@:%@\n",key,[response.jsonResponse objectForKey:key]]];
        }
        if (((TencentHelper*)[TencentHelper shareInstance]).TencentDelegate){
            if ([((TencentHelper*)[TencentHelper shareInstance]).TencentDelegate respondsToSelector:@selector(tencentshareSuccess:)]) {
                [((TencentHelper*)[TencentHelper shareInstance]).TencentDelegate performSelector:@selector(tencentshareSuccess:) withObject:message];
            }
        }
    }
    else
    {
        NSString *errMsg = [NSString stringWithFormat:@"errorMsg:%@\n%@", response.errorMsg, [response.jsonResponse objectForKey:@"msg"]];
        
        if (((TencentHelper*)[TencentHelper shareInstance]).TencentDelegate){
            if ([((TencentHelper*)[TencentHelper shareInstance]).TencentDelegate respondsToSelector:@selector(tencentshareFail:)]) {
                [((TencentHelper*)[TencentHelper shareInstance]).TencentDelegate performSelector:@selector(tencentshareFail:) withObject:errMsg];
            }
        }

    }
}

// 用户信息回调
- (void)getUserInfoResponse:(APIResponse*) response
{
    if (URLREQUEST_SUCCEED == response.retCode && kOpenSDKErrorSuccess == response.detailRetCode)
    {
        if ([response.jsonResponse objectForKey:@"nickname"]) {
            [[NSUserDefaults standardUserDefaults] setObject:[response.jsonResponse objectForKey:@"nickname"] forKey:@"tencentNickName"];
        }
        
        if (helper.TencentDelegate && [helper.TencentDelegate respondsToSelector:@selector(getUserInfoSuccess:)]) {
            [helper.TencentDelegate getUserInfoSuccess:(NSDictionary *)response.jsonResponse];
        }
        
    }
    else
    {
        if (helper.TencentDelegate && [helper.TencentDelegate respondsToSelector:@selector(getUserInfoFail:)]) {
            [helper.TencentDelegate getUserInfoFail:(NSDictionary *)response.jsonResponse];
        }
        
    }
}


@end
