//
//  MexerController.swift
//  BlueTest
//
//  Created by APT-IT on 7/8/14.
//  Copyright (c) 2014 APT-IT. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import MultipeerConnectivity
class MexerController:UIViewController{
    
    @IBOutlet var inputSlider0:UISlider
    @IBOutlet var inputSlider1:UISlider

      var appDelegate:AppDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
           appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
        self.inputSlider0.addTarget(self, action: "mixerInput0GainChanged:", forControlEvents: UIControlEvents.ValueChanged)
        
        self.inputSlider1.addTarget(self, action: "mixerInput1GainChanged:", forControlEvents: UIControlEvents.ValueChanged)
        
        
    //    NSNotificationCenter.defaultCenter().addObserver(self, selector: "didReceiveDataWithNotification:", name: "MCDidReceiveDataNotification", object: nil)

    }
    
    func sendMyMessage(value:CFloat){
        var valueString:NSString = NSString(format: "%f",value) as NSString
        var message = "changeVolume"+":"+valueString
        var dataToSend = message.dataUsingEncoding(4)
        
        var allPeers = appDelegate!.mcManager!.session.connectedPeers
        
        var error:NSError?
        
        appDelegate!.mcManager!.session.sendData(dataToSend, toPeers: allPeers, withMode: MCSessionSendDataMode.Reliable, error: &error)
        if error {
            NSLog("%@",error!.localizedDescription)
        }
        
        
        
        
    }
    
    

    
    
    

    
    func  mixerInput0GainChanged(sender:UISlider)  {
        var inputBus = sender.tag
        sendMyMessage(sender.value)
      
        //   audioObject!.setMixerInput(UInt32(inputBus), gain:AudioUnitParameterValue(sender.value))
    }
    func  mixerInput1GainChanged(sender:UISlider)  {
        var inputBus = sender.tag
        sendMyMessage(sender.value)
     
        //   audioObject!.setMixerInput(UInt32(inputBus), gain:AudioUnitParameterValue(sender.value))
    }


}

