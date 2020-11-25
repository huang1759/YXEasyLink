//
//  YXViewController.m
//  YXEasyLink
//
//  Created by huang1759 on 11/25/2020.
//  Copyright (c) 2020 huang1759. All rights reserved.
//

#import "YXViewController.h"
#import <EasyLink.h>

@interface YXViewController ()<EasyLinkFTCDelegate>

@end

@implementation YXViewController
{
    EasyLinkMode easylinkMode;
    NSData *targetSsid;
    NSMutableDictionary *deviceIPConfig;
    NSMutableDictionary *apInforRecord;
    EASYLINK *easylink_config;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)top:(id)sender {
    //开始配网
    if(apInforRecord == nil)
        apInforRecord = [NSMutableDictionary dictionaryWithCapacity:10];
    
    if( easylink_config == nil){
        easylink_config = [[EASYLINK alloc]initForDebug:YES WithDelegate:self];
    }
    deviceIPConfig = [[NSMutableDictionary alloc] init];
    targetSsid = [NSData data];
    easylinkMode = EASYLINK_AWS;
    
    [deviceIPConfig setObject:@YES forKey:@"DHCP"];
    [deviceIPConfig setObject:[EASYLINK getIPAddress] forKey:@"IP"];
    [deviceIPConfig setObject:[EASYLINK getNetMask] forKey:@"NetMask"];
    [deviceIPConfig setObject:[EASYLINK getGatewayAddress] forKey:@"GateWay"];
    [deviceIPConfig setObject:[EASYLINK getGatewayAddress] forKey:@"DnsServer"];
    
    NSLog(@"devieIPconfig %@",deviceIPConfig);
    
    [self startTransmitting: easylinkMode];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)startTransmitting: (EasyLinkMode)mode {
    NSMutableDictionary *wlanConfig = [NSMutableDictionary dictionaryWithCapacity:20];

    if([targetSsid length] > 0) [wlanConfig setObject:targetSsid forKey:KEY_SSID];
    else [wlanConfig setObject:[@"YX-TECH" dataUsingEncoding:NSUTF8StringEncoding] forKey:KEY_SSID];
    [wlanConfig setObject:@"helloworld" forKey:KEY_PASSWORD];
    [wlanConfig setObject:[NSNumber numberWithBool:[[deviceIPConfig objectForKey:@"DHCP"] boolValue]] forKey:KEY_DHCP];
    
    if([[deviceIPConfig objectForKey:@"IP"] length] > 0)  [wlanConfig setObject:[deviceIPConfig objectForKey:@"IP"] forKey:KEY_IP];
    if([[deviceIPConfig objectForKey:@"NetMask"] length] > 0)  [wlanConfig setObject:[deviceIPConfig objectForKey:@"NetMask"] forKey:KEY_NETMASK];
    if([[deviceIPConfig objectForKey:@"GateWay"] length] > 0)  [wlanConfig setObject:[deviceIPConfig objectForKey:@"GateWay"] forKey:KEY_GATEWAY];
    if([[deviceIPConfig objectForKey:@"DnsServer"] length] > 0)  [wlanConfig setObject:[deviceIPConfig objectForKey:@"DnsServer"] forKey:KEY_DNS1];

    NSString *userInfo = @"";
    const char *temp = [userInfo cStringUsingEncoding:NSUTF8StringEncoding];
    [easylink_config prepareEasyLink:wlanConfig info:[NSData dataWithBytes:temp length:strlen(temp)] mode:mode ];
    [self sendAction];
    targetSsid = [wlanConfig objectForKey:KEY_SSID];
}
-(void) sendAction{
    [easylink_config transmitSettings];
}

-(void) stopAction{
    [easylink_config stopTransmitting];
}

- (void)onFoundByFTC:(NSNumber *)client withConfiguration: (NSDictionary *)configDict{
    
}

- (void)onFound:(NSNumber *)client withName:(NSString *)name mataData: (NSDictionary *)mataDataDict{
    
}


- (void)onDisconnectFromFTC:(NSNumber *)client  withError:(bool)err{
    
}
@end
