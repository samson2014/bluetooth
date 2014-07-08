//
//  MixerHostController.swift
//  BlueToothMusic
//
//  Created by APT-IT on 7/7/14.
//  Copyright (c) 2014 APT-IT. All rights reserved.
//

import UIKit
import AVFoundation

class MixerHostController: UIViewController {
    
    @IBOutlet var pauseButton: UIBarButtonItem
    @IBOutlet var backButton: UIBarButtonItem
    var appDelegate:AppDelegate?
    
    @IBOutlet var inputSlider0:UISlider
    @IBOutlet var inputSlider1:UISlider
    @IBOutlet var outputSlider:UISlider
    @IBOutlet var jiTaSwitch:UISwitch
    @IBOutlet var boomSwitch:UISwitch
    
    var cmAudioManage:CMOpenALSoundManager?
//    var audioObject: MixerHostAudio?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cmAudioManage = CMOpenALSoundManager()
        NSBundle.mainBundle().pathForResource("1", ofType: "m4a")
        var guitarLoop = NSBundle.mainBundle().URLForResource("guitarStereo", withExtension: "caf")
        var beatLoop = NSBundle.mainBundle().URLForResource("beatsMono", withExtension: "caf")
        // Do any additional setup after loading the view, typically from a nib.
//        audioObject = MixerHostAudio()
        
//        audioObject!.enableMixerInput(0, isOn: AudioUnitParameterValue(jiTaSwitch.on))
//         audioObject!.enableMixerInput(1, isOn: AudioUnitParameterValue(boomSwitch.on))
//        
//        audioObject!.setMixerOutputGain(outputSlider.value)
//        audioObject!.setMixerInput(0, gain: inputSlider0.value)
//        audioObject!.setMixerInput(1, gain: inputSlider1.value)
               self.outputSlider.addTarget(self, action: "mixerOutputGainChanged:", forControlEvents: UIControlEvents.ValueChanged)
        
        self.inputSlider0.addTarget(self, action: "mixerInput0GainChanged:", forControlEvents: UIControlEvents.ValueChanged)
        
         self.inputSlider1.addTarget(self, action: "mixerInput1GainChanged:", forControlEvents: UIControlEvents.ValueChanged)
        
        self.inputSlider0.maximumValue = 1.0
         self.inputSlider0.minimumValue = 0.0
        self.inputSlider0.value = 1.0
        self.inputSlider1.maximumValue = 1.0
        self.inputSlider1.minimumValue = 0.0
        self.inputSlider1.value = 1.0
        self.registerForAudioObjectNotifications()
         cmAudioManage!.playBackgroundMusic("guitarStereo.caf")
        cmAudioManage!.soundFileNames = NSArray(object: "beatsMono.caf")
    //   soundMgr.soundFileNames = [NSArray arrayWithObject:@"Start.caf"];
    
    }
    
    // Handle a change in the mixer output gain slider.
    func mixerOutputGainChanged(sender:UISlider) {
//    audioObject!.setMixerOutputGain(AudioUnitParameterValue(sender.value))
  
    }
    
    // Handle a change in a mixer input gain slider. The "tag" value of the slider lets this
    //    method distinguish between the two channels.
    func  mixerInput0GainChanged(sender:UISlider)  {
    var inputBus = sender.tag
        
        cmAudioManage!.backgroundMusicVolume = sender.value
//   audioObject!.setMixerInput(UInt32(inputBus), gain:AudioUnitParameterValue(sender.value))
      }
    func  mixerInput1GainChanged(sender:UISlider)  {
        var inputBus = sender.tag
        
         cmAudioManage!.soundEffectsVolume = sender.value
        //   audioObject!.setMixerInput(UInt32(inputBus), gain:AudioUnitParameterValue(sender.value))
    }
    // Handle a play/stop button tap
    @IBAction func playBackgroundMusic(sender:AnyObject) {
        
        if cmAudioManage!.isBackGroundMusicPlaying() {
                       cmAudioManage!.stopBackgroundMusic()
                        self.pauseButton.title = "Play"
                    } else {
                        cmAudioManage!.resumeBackgroundMusic()
            
                        self.pauseButton.title = "Stop"
                    }
        
       // 	[soundMgr playSoundWithID:AUDIOEFFECT];

       

        
    }
    @IBAction func playEffectMusic(sender:AnyObject) {
        
        
       
        if cmAudioManage!.isPlayingSoundWithID(0) {
            cmAudioManage!.stopSoundWithID(0)
            self.backButton.title = "Stop"

        }else{
            
            cmAudioManage!.playSoundWithID(0)
            self.backButton.title = "Play"
            
        }
        //        if audioObject!.playing {
        //            audioObject!.stopAUGraph()
        //            self.pauseButton.title = "Play"
        //        } else {
        //            audioObject!.startAUGraph()
        //            self.pauseButton.title = "Stop"
        //        }
        
    }
    
    
    // Handle a change in playback state that resulted from an audio session interruption or end of interruption
    func handlePlaybackStateChanged(notification:AnyObject) {
    
      //  self.playOrStop()
    }
    
    
    
    // Handle a Mixer unit input on/off switch action. The "tag" value of the switch lets this
    //    method distinguish between the two channels.
    @IBAction func enableMixerInput(sender:UISwitch)  {
        var inputBus = UInt32(sender.tag)
          var isOn = AudioUnitParameterValue(sender.on)
//        audioObject!.enableMixerInput(inputBus, isOn: isOn)
        
      
    }
    
    
 
    // Respond to remote control events
    override func remoteControlReceivedWithEvent(receivedEvent:UIEvent )  {
        if receivedEvent.type == UIEventType.RemoteControl {
            switch receivedEvent.subtype {
            case UIEventSubtype.RemoteControlTogglePlayPause:
              //  self.playOrStop = nil
                break
            default:
                break
            }
        }

    

    }
    
       // If this app's audio session is interrupted when playing audio, it needs to update its user interface
    //    to reflect the fact that audio has stopped. The MixerHostAudio object conveys its change in state to
    //    this object by way of a notification. To learn about notifications, see Notification Programming Topics.
    func registerForAudioObjectNotifications() {
    
    var notificationCenter = NSNotificationCenter.defaultCenter()
    
//    notificationCenter.addObserver(self, selector: "handlePlaybackStateChanged:", name: "MixerHostAudioObjectPlaybackStateDidChangeNotification", object: audioObject!)
  
    }
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        UIApplication.sharedApplication().endReceivingRemoteControlEvents()
        
        self.becomeFirstResponder()
    
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        UIApplication.sharedApplication().beginReceivingRemoteControlEvents()
        
        self.becomeFirstResponder()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidUnload() {
    super.viewDidUnload()
        self.pauseButton             = nil
        self.jiTaSwitch       = nil;
        self.boomSwitch     = nil;
        self.inputSlider0  = nil;
        self.inputSlider1    = nil;
        self.outputSlider  = nil;
//        NSNotificationCenter.defaultCenter().removeObserver(self, name: "MixerHostAudioObjectPlaybackStateDidChangeNotification", object: audioObject!)
//               self.audioObject            = nil;


    }

    deinit {
//        NSNotificationCenter.defaultCenter().removeObserver(self, name: "MixerHostAudioObjectPlaybackStateDidChangeNotification", object: audioObject!)
       

        UIApplication.sharedApplication().endReceivingRemoteControlEvents()
        
        
    }

}
