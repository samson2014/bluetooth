//
//  searchController.h
//  MusicBluetooth
//
//  Created by APT-IT on 7/6/14.
//  Copyright (c) 2014 APT-IT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>
#import "MCManager.h"
@interface searchController : UIViewController <MCBrowserViewControllerDelegate, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>


@property (retain, nonatomic) IBOutlet UITextField *txtName;
@property (retain, nonatomic) IBOutlet UISwitch *swVisible;
@property (retain, nonatomic) IBOutlet UITableView *tblConnectedDevices;
@property (retain, nonatomic) IBOutlet UIButton *btnDisconnect;

@property (nonatomic, strong) NSMutableArray *arrConnectedDevices;


- (IBAction)browseForDevices:(id)sender;
- (IBAction)toggleVisibility:(id)sender;
- (IBAction)disconnect:(id)sender;
-(void)peerDidChangeStateWithNotification:(NSNotification *)notification;


@end
