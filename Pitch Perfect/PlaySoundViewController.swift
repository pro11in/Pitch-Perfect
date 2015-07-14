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
        
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAV.filePathUrl, error: nil)
        
        audioPlayer.enableRate = true
        
        audioFile = AVAudioFile(forReading: receivedAV.filePathUrl, error: nil)
        
        audioEngine = AVAudioEngine()
        
        
        for i in 0...N {
            reverbPlayers.append(audioPlayer)
        }
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
    
    // SR - Reverb the input audio
    func fnPlayReverb() {
        fnstopAudio()
        
        var revPlayer = AVAudioPlayerNode()
        var reverb = AVAudioUnitReverb()
        
        // SR - This is a reverb with a cathedral preset.
        reverb.loadFactoryPreset(AVAudioUnitReverbPreset.Cathedral)
        reverb.wetDryMix = 50.0
        
        audioEngine.attachNode(revPlayer)
        audioEngine.attachNode(reverb)
        
        audioEngine.connect(revPlayer, to: reverb, format: nil)
        audioEngine.connect(reverb, to: audioEngine.outputNode, format: nil)
        
        revPlayer.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        revPlayer.play()
        
    }
    
    // SR - Echo the input audio
    func fnPlayEcho() {
        fnstopAudio()
        
        var echoPlayer = AVAudioPlayerNode()
        audioEngine.attachNode(echoPlayer)
        
        var echo = AVAudioUnitDelay()
        echo.delayTime = 1.0
        echo.feedback = 80.0
        audioEngine.attachNode(echo)
        
        audioEngine.connect(echoPlayer, to: echo, format: nil)
        audioEngine.connect(echo, to: audioEngine.outputNode, format: nil)
        
        echoPlayer.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        echoPlayer.play()
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
