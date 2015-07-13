//
//  RecordSoundViewController.swift
//  Pitch Perfect
//
//  Created by ismdeveloper on 6/24/15.
//  Copyright (c) 2015 PHA. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundViewController: UIViewController, AVAudioRecorderDelegate {

    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    
    @IBOutlet weak var recordingInProgress: UILabel!
    @IBOutlet weak var stopBtn: UIButton!
    @IBOutlet weak var recordAudio: UIButton!
    @IBOutlet weak var recordLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        stopBtn.hidden = true
        recordAudio.enabled = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func recAudio() {
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask , true)[0] as!String
        let recordingName = "myAduio.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        //println(filePath)
        
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if (flag) {
            recordedAudio = RecordedAudio(filePathUrl: recorder.url, title: recorder.url.lastPathComponent!)
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
            
        } else {
            println("Recording Failed.")
            recordAudio.enabled = true
            stopBtn.hidden = true
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording") {
            let playSoundVC:PlaySoundViewController = segue.destinationViewController as!PlaySoundViewController
            let data = sender as! RecordedAudio
            playSoundVC.receivedAV = data
        }
    }
    
    func stopAudio() {
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
    }

    @IBAction func RecordAudio(sender: UIButton) {
            //recordingInProgress.hidden = false
            recordLabel.text = "Recording"
            stopBtn.hidden = false
            recordAudio.enabled = false
        
            recAudio()
    }

    @IBAction func StopRecording(sender: UIButton) {
        //recordingInProgress.hidden = true
        recordLabel.text = "Tap to Record"
        stopBtn.hidden = true
        
        stopAudio()
    }
}

