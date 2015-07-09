//
//  PlaySoundViewController.swift
//  Pitch Perfect
//
//  Created by ismdeveloper on 7/7/15.
//  Copyright (c) 2015 PHA. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundViewController: UIViewController {

    var audioPlayer:AVAudioPlayer!
    var audioEngine:AVAudioEngine!
    var receivedAV:RecordedAudio!
    var audioFile:AVAudioFile!
    
    override func viewDidLoad() {

        super.viewDidLoad()
        
        if var filePath = NSBundle.mainBundle().pathForResource("movie_quote2", ofType: "mp3") {
            let url = NSURL.fileURLWithPath(filePath)
            //audioPlayer = AVAudioPlayer(contentsOfURL: url, error: nil)
            
            //audioFile = AVAudioFile(forReading: url, error: nil)
            
            //println("File Found")
        } else {
            println("File Not Found")
        }
        
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAV.filePathUrl, error: nil)
        
        audioPlayer.enableRate = true
        
        audioFile = AVAudioFile(forReading: receivedAV.filePathUrl, error: nil)
        
        audioEngine = AVAudioEngine()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func playAudio() {
        audioPlayer.stop()
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
    }
    
    @IBAction func playSlowAudio(sender: UIButton) {
        audioPlayer.rate = 0.5
        playAudio()
    }
    
    
    @IBAction func PlayFastAudio(sender: AnyObject) {
        audioPlayer.rate = 1.5
        playAudio()
    }
    
    @IBAction func stopAudio(sender: AnyObject) {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    }
    
    func playAudiowithPitch(pitch:Float) {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        var pitchPlayer = AVAudioPlayerNode()
        audioEngine.attachNode(pitchPlayer)
        
        var timePitch = AVAudioUnitTimePitch()
        timePitch.pitch = pitch
        audioEngine.attachNode(timePitch)
        
        audioEngine.connect(pitchPlayer, to: timePitch, format: nil)
        audioEngine.connect(timePitch, to: audioEngine.outputNode, format: nil)
        
        pitchPlayer.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        pitchPlayer.play()
        
    }
    
    
    @IBAction func playChipmunkAudio(sender: AnyObject) {
        //println("in playChipmunkAudio")
        playAudiowithPitch(1000)
    }
    
    @IBAction func playDarthVaderAudio(sender: AnyObject) {
        playAudiowithPitch(-500)
    }
    

}
