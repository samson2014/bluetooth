//
//  FirstViewController.swift
//  MusicBluetooth
//
//  Created by APT-IT on 7/6/14.
//  Copyright (c) 2014 APT-IT. All rights reserved.
//

import UIKit
import MultipeerConnectivity


class FirstViewController: UIViewController,UITextFieldDelegate{
    @IBOutlet var txtMessage:UITextField
    @IBOutlet var tvChat:UITextView
    @IBOutlet var cancelButton:UIButton
    @IBOutlet var sendButton:UIButton
    var appDelegate:AppDelegate?
  //  var mcManager:MCManager?
     
    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
        self.cancelButton.addTarget(self, action: "cancelTab", forControlEvents: UIControlEvents.TouchUpInside)
         self.sendButton.addTarget(self, action: "sendTab", forControlEvents: UIControlEvents.TouchUpInside)
        // Do any additional setup after loading the view, typically from a nib.
        self.txtMessage.delegate = self
       // mcManager = MCManager()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didReceiveDataWithNotification:", name: "MCDidReceiveDataNotification", object: nil)
        
      //  var strName = NSBundle.mainBundle().infoDictionary.objectForKey("UIMainStoryboardFile")
//        var Mystory = UIStoryboard(name: "Main", bundle: nil)
      
        
     //      var  stbName = [[NSBundle mainBundle].infoDictionary objectForKey:@"UIMainStoryboardFile"];
        //    UIStoryboard *Mystoryboard = [UIStoryboard storyboardWithName:stbName bundle:nil];
        //    searchController *searchController = [Mystoryboard instantiateViewControllerWithIdentifier:@"searchController"];
        //    [self presentModalViewController:[_mcManager browser] animated:YES];
        // [self presentModalViewController:[_mcManager browser] animated:YES];
    }
    
    func textFieldShouldReturn(textField:UITextField)->Bool{
        textField.resignFirstResponder()
        return true
    }
    
    
    func sendMyMessage(){
     
        var dataToSend = self.txtMessage.text.dataUsingEncoding(4)
     
        var allPeers = appDelegate!.mcManager!.session.connectedPeers
        
        var error:NSError?
      
     appDelegate!.mcManager!.session.sendData(dataToSend, toPeers: allPeers, withMode: MCSessionSendDataMode.Reliable, error: &error)
        if error {
            NSLog("%@",error!.localizedDescription)
        }
        
     
        tvChat.text = tvChat.text.stringByAppendingString(NSString(format:"I wrote:\n%@\n\n", txtMessage.text))
            txtMessage.text = ""
        txtMessage.resignFirstResponder()
        }
    
    
    func didReceiveDataWithNotification(notification:NSNotification){
        
        var peerID : (AnyObject!) = notification.userInfo.objectForKey("peerID")
        var peerDisplayName = peerID.displayName
        var receivedData:NSData = notification.userInfo.objectForKey("data") as NSData
        
        var receiveedText = NSString(data: receivedData, encoding: 4)
        
        NSLog(receiveedText)
        
        dispatch_async(dispatch_get_main_queue()) {
            () -> Void in
          self.updateTextfield(peerDisplayName, receiveedText: receiveedText)
        }
        //tvChat.performSelectorOnMainThread("text", withObject: tvChat.text.stringByAppendingString(NSString(format:"I wrote:\n%@\n\n", peerDisplayName,receiveedText)),waitUntilDone: false)

//        tvChat.performSelectorOnMainThread(Selector(text), tvChat.text.stringByAppendingString(NSString(format:"I wrote:\n%@\n\n", peerDisplayName,receiveedText)),waitUntilDone: false)
//    tvChat.performSelectorOnMainThread(Selector(text) , withObject: tvChat.text.stringByAppendingString(NSString(format:"I wrote:\n%@\n\n", peerDisplayName,receiveedText)),waitUntilDone: false)
    
    }
    
    func updateTextfield(peerDisplayName:NSString,receiveedText:NSString){
            self.tvChat.text = self.tvChat.text.stringByAppendingString(NSString(format: "\n%@\n\n", peerDisplayName+":"+receiveedText))
    
    }

    
    func cancelTab(){
        txtMessage.resignFirstResponder()
    }
    func sendTab(){
      
        sendMyMessage()
     

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

