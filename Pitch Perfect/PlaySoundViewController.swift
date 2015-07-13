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
    var reverbPlayers:[AVAudioPlayer]! = []
    var N:Int = 10

    
    override func viewDidLoad() {

        super.viewDidLoad()
        
        if var filePath = NSBundle.mainBundle().pathForResource("movie_quote2", ofType: "mp3") {
            let url = NSURL.fileURLWithPath(filePath)        } else {
            println("File Not Found")
        }
        
        
        
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAV.filePathUrl, error: nil)
        
        audioPlayer.enableRate = true
        
        audioFile = AVAudioFile(forReading: receivedAV.filePathUrl, error: nil)
        
        audioEngine = AVAudioEngine()
        
        
        for i in 0...N {
            reverbPlayers.append(audioPlayer)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // SR - Stop and reset the player
    func fnstopAudio() {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    }
    
    // SR - stop and play the audio
    func playAudio() {
        fnstopAudio()
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
    }
    
    // SR - stop and play the audio with pitch parameter
    func playAudiowithPitch(pitch:Float) {
        fnstopAudio()
        
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
    
    func fnPlayReverb() {
        let delay:NSTimeInterval = 0.02
        fnstopAudio()
        for i in 0...N {
            audioPlayer.playAtTime(audioPlayer.deviceCurrentTime + delay)
        }
    }
    
    func fnPlayEcho() {
        let delay:NSTimeInterval = 0.1
        fnstopAudio()
        audioPlayer.playAtTime(audioPlayer.deviceCurrentTime + delay)
    }
    
    @IBAction func playReverb(sender: AnyObject) {
        fnPlayReverb()
    }
    
    @IBAction func playEcho(sender: AnyObject) {
        fnPlayEcho()
    }
    
    @IBAction func playSlowAudio(sender: UIButton) {
        audioPlayer.rate = 0.5
        playAudio()
    }
    
    @IBAction func PlayFastAudio(sender: AnyObject) {
        audioPlayer.rate = 1.5
        playAudio()
    }
    
    @IBAction func playChipmunkAudio(sender: AnyObject) {
        playAudiowithPitch(1000)
    }
    
    @IBAction func playDarthVaderAudio(sender: AnyObject) {
        playAudiowithPitch(-500)
    }
    
    @IBAction func stopAudio(sender: AnyObject) {
        fnstopAudio()
    }

}
