//
//  searchController.m
//  MusicBluetooth
//
//  Created by APT-IT on 7/6/14.
//  Copyright (c) 2014 APT-IT. All rights reserved.
//

#import "searchController.h"
#import "BlueTest-Swift.h"

 @implementation searchController
    {
        AppDelegate *appDelegate;
                   }



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
       
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
   
    
    [appDelegate.mcManager setupPeerAndSessionWithDisplayName:[UIDevice currentDevice].name];
    [appDelegate.mcManager advertiseSelf:_swVisible.isOn];
    
    [_txtName setDelegate:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(peerDidChangeStateWithNotification:)
                                                 name:@"MCDidChangeStateNotification"
                                               object:nil];
    
    _arrConnectedDevices = [[NSMutableArray alloc] init];
    
    [_tblConnectedDevices setDelegate:self];
    [_tblConnectedDevices setDataSource:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITextField Delegate method implementation

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [_txtName resignFirstResponder];
    
    appDelegate.mcManager.peerID = nil;
    appDelegate.mcManager.session = nil;
    appDelegate.mcManager.browser = nil;
    
    if ([_swVisible isOn]) {
        [appDelegate.mcManager.advertiser stop];
    }
    appDelegate.mcManager.advertiser = nil;
    
    
    [appDelegate.mcManager setupPeerAndSessionWithDisplayName:_txtName.text];
    [appDelegate.mcManager setupMCBrowser];
    [appDelegate.mcManager advertiseSelf:_swVisible.isOn];
    
    return YES;
}


#pragma mark - Public method implementation

- (IBAction)browseForDevices:(id)sender {
    [appDelegate.mcManager setupMCBrowser];
    [[appDelegate.mcManager browser] setDelegate:self];

//    NSString *stbName = [[NSBundle mainBundle].infoDictionary objectForKey:@"UIMainStoryboardFile"];
//    UIStoryboard *Mystoryboard = [UIStoryboard storyboardWithName:stbName bundle:nil];
//    searchController *searchController = [Mystoryboard instantiateViewControllerWithIdentifier:@"searchController"];
//    [self presentModalViewController:[appDelegate.mcManager browser] animated:YES];
     // [self presentModalViewController:[appDelegate.mcManager browser] animated:YES];
    [self presentViewController:[appDelegate.mcManager browser] animated:YES completion:nil];
}


- (IBAction)toggleVisibility:(id)sender {
    [appDelegate.mcManager advertiseSelf:_swVisible.isOn];
}


- (IBAction)disconnect:(id)sender {
    [appDelegate.mcManager.session disconnect];
    
    _txtName.enabled = YES;
    
    [_arrConnectedDevices removeAllObjects];
    [_tblConnectedDevices reloadData];
}


#pragma mark - MCBrowserViewControllerDelegate method implementation

-(void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController{
    [appDelegate.mcManager.browser dismissViewControllerAnimated:YES completion:nil];
}


-(void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController{
    [appDelegate.mcManager.browser dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Private method implementation

-(void)peerDidChangeStateWithNotification:(NSNotification *)notification{
    MCPeerID *peerID = [[notification userInfo] objectForKey:@"peerID"];
    NSString *peerDisplayName = peerID.displayName;
    MCSessionState state = [[[notification userInfo] objectForKey:@"state"] intValue];
    
    if (state != MCSessionStateConnecting) {
        if (state == MCSessionStateConnected) {
            [_arrConnectedDevices addObject:peerDisplayName];
        }
        else if (state == MCSessionStateNotConnected){
            if ([_arrConnectedDevices count] > 0) {
                int indexOfPeer = [_arrConnectedDevices indexOfObject:peerDisplayName];
                [_arrConnectedDevices removeObjectAtIndex:indexOfPeer];
            }
        }
        [_tblConnectedDevices reloadData];
        
        BOOL peersExist = ([[appDelegate.mcManager.session connectedPeers] count] == 0);
        [_btnDisconnect setEnabled:!peersExist];
        [_txtName setEnabled:peersExist];
    }
}


#pragma mark - UITableView Delegate and Datasource method implementation

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_arrConnectedDevices count];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellIdentifier"];
    }
    
    cell.textLabel.text = [_arrConnectedDevices objectAtIndex:indexPath.row];
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0;
}


@end
