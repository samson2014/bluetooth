//
//  MusicController.swift
//  MusicBluetooth
//
//  Created by APT-IT on 7/6/14.
//  Copyright (c) 2014 APT-IT. All rights reserved.
//

import UIKit
import AVFoundation
import MultipeerConnectivity
class MusicController: UIViewController,AVAudioPlayerDelegate {
    
    @IBOutlet var pauseButton:UIButton
    @IBOutlet var  playButton:UIButton
    @IBOutlet var  seButton:UIButton
    @IBOutlet var  Button:UIButton
        var appDelegate:AppDelegate?
    
    @IBOutlet var inputSlider0:UISlider
    
    
    @IBOutlet var jdProgress:UISlider
    @IBOutlet var ylProgress:UISlider
    var avPlayer:AVAudioPlayer?
    var sliderTimer:NSTimer?
    var bundlePath:NSString?
    var musicName:NSArray?
    var localMusicPath:NSString?
    override func viewDidLoad() {
        super.viewDidLoad()
           appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
        self.playButton.addTarget(self, action: "playTab", forControlEvents: UIControlEvents.TouchUpInside)
        self.pauseButton.addTarget(self, action: "pauseTab", forControlEvents: UIControlEvents.TouchUpInside)
         self.seButton.addTarget(self, action: "sendTagButtonTab", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.inputSlider0.addTarget(self, action: "mixerInput0GainChanged:", forControlEvents: UIControlEvents.ValueChanged)
        
        
        
      self.ylProgress.addTarget(self, action: "changeVolume:", forControlEvents: UIControlEvents.ValueChanged)
       bundlePath = NSBundle.mainBundle().bundlePath
             var manager = NSFileManager.defaultManager()
//        musicName = manager.contentsOfDirectoryAtPath(bundlePath!.stringByAppendingString("/Music"), error: nil) as NSArray
      NSNotificationCenter.defaultCenter().addObserver(self, selector: "didReceiveDataNotification:", name: "MusicDidReceiveDataNotification", object: nil)
          NSNotificationCenter.defaultCenter().addObserver(self, selector: "ValumeReceiveDataNotification:", name: "ValumeDidReceiveDataNotification", object: nil)
        
       localMusicPath = NSBundle.mainBundle().pathForResource("1", ofType: "m4a")
   
         }
    
    
    func sendTagButtonTab(){
        
        sendMyMessage()
         startPlay(localMusicPath!, Slider: self.jdProgress)
    
    }
    
    func  mixerInput0GainChanged(sender:UISlider)  {
        var inputBus = sender.tag
        sendVolumeMessage(sender.value)
        
        //   audioObject!.setMixerInput(UInt32(inputBus), gain:AudioUnitParameterValue(sender.value))
    }
    
    
    func sendVolumeMessage(value:CFloat){
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
    
    
    
    func changeVolume(sender:UISlider){
        
        self.avPlayer!.volume = sender.value
    
    }
    
    func sendMyMessage(){
        var message = "playthemusic:playthemusic"
        var dataToSend = message.dataUsingEncoding(4)
        
        var allPeers = appDelegate!.mcManager!.session.connectedPeers
        
        var error:NSError?
        
        appDelegate!.mcManager!.session.sendData(dataToSend, toPeers: allPeers, withMode: MCSessionSendDataMode.Reliable, error: &error)
        if error {
            NSLog("%@",error!.localizedDescription)
        }
        
        
       
        
    }
    
    
    func didReceiveDataNotification(notification:NSNotification){
        
        var peerID : (AnyObject!) = notification.userInfo.objectForKey("peerID")
        var peerDisplayName = peerID.displayName
        var receivedData:NSData = notification.userInfo.objectForKey("data") as NSData
        
        var receiveedText = NSString(data: receivedData, encoding: 4)
        
        NSLog(receiveedText)
        var tag = "playthemusic"
        if receiveedText == tag {

            startPlay(localMusicPath!, Slider: self.jdProgress)
            
        }else{
            NSLog("The signal is not right")
        }

        
    }
    
    
    
  

    
    func ValumeReceiveDataNotification(notification:NSNotification){
        
        var peerID : (AnyObject!) = notification.userInfo.objectForKey("peerID")
        var peerDisplayName = peerID.displayName
        var receivedData:NSData = notification.userInfo.objectForKey("data") as NSData
        
        var receiveedText = NSString(data: receivedData, encoding: 4)
        
       
      
        
        
            NSLog("Musiccontroller volume"+receiveedText)
        
         self.avPlayer!.volume = receiveedText.floatValue
            self.ylProgress.value = receiveedText.floatValue
        
        
    }


    
    func startPlay(urlString:NSString,Slider:UISlider){
        var audioSession=AVAudioSession.sharedInstance()
        self.jdProgress = Slider
        var error:NSError?
        audioSession.setCategory(AVAudioSessionCategoryPlayback,error:&error)
        //    [audioSessionsetCategory:AVAudioSessionCategoryPlaybackerror:&err];
        var url = NSURL(string:urlString)
        avPlayer = AVAudioPlayer(contentsOfURL: url, error: &error)
        self.avPlayer!.delegate = self
        self.avPlayer!.volume = 1.0
        avPlayer!.prepareToPlay()
        sliderTimer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: "updateSlider", userInfo: nil, repeats: true )
        
        
        
        // Set the maximum value of the UISlider
        // NSLog("slidevalue:%f",avPlayer!.duration)
        
        var dura = avPlayer!.duration
        self.jdProgress.maximumValue = CFloat(dura)
        //    NSLog("slidevalue:%f",self.aSlider!.maximumValue)
        
        // Set the valueChanged target
        
        self.jdProgress.addTarget(self,action:"sliderChanged:", forControlEvents: UIControlEvents.ValueChanged)
        
        
        if avPlayer! == nil{
            NSLog("ERror creating player: %@", "error")
        }else{
            
            avPlayer!.play()
            
            
        }

    
    }
    
    func updateSlider() {
        
        // Update the slider about the music time
       
        self.jdProgress.value = CFloat(avPlayer!.currentTime)
        
    }

    
    // Stop the timer when the music is finished (Need to implement the AVAudioPlayerDelegate in the Controller header)
    
    func audioPlayerDidFinishPlaying(player:AVAudioPlayer, flag:Bool) {
        
        // Music completed
        
        if flag {
            
            sliderTimer!.invalidate()
            
            
        }
        
        
        
    }
    
    
    
    func sliderChanged(sender:UISlider) {
        
        // Fast skip the music when user scroll the UISlider
        avPlayer!.stop()
        // NSLog("sender.value:%f",sender.value)
        self.avPlayer!.currentTime = NSTimeInterval(sender.value)
        //NSLog("self.avPlayer!.currentTime:%f",self.avPlayer!.currentTime)
        //self.aSlider!.value = CFloat(avPlayer!.currentTime)
        avPlayer!.prepareToPlay()
        avPlayer!.play()
        
        
    }

    
    
    func MusicDta(){
    
    }
    
    func playTab(){
//        var path0 = bundlePath!.stringByAppendingString("/Music/").stringByAppendingString(musicName!.objectAtIndex(0) as NSString)
//        NSLog(path0)
//        var musicPath:NSString = "MusicBluetooth/1.m4a"
        startPlay(localMusicPath!, Slider: self.jdProgress)
    }
    
    func pauseTab(){
        avPlayer!.stop()

    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
