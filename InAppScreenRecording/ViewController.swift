//
//  ViewController.swift
//  InAppScreenRecording
//
//  Created by Ahmed Abdelkarim on 04/09/2021.
//

import UIKit
import ReplayKit

class ViewController: UIViewController {
    //MARK: - Outlets
    @IBOutlet weak var recordButton: UIButton!
    
    //MARK: - Properties
    var isMicrophoneEnabled = true
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - Actions
    @IBAction func recordButtonClicked(_ sender: Any) {
        let recorder = RPScreenRecorder.shared()
        recorder.isMicrophoneEnabled = self.isMicrophoneEnabled
        
        if(!recorder.isRecording) {
            recorder.startRecording(handler: { error in
                guard error == nil else {
                    print("Failed to start recording")
                    return
                }
                
                self.recordButton.setTitle("Stop Recording", for: .normal)
            })
        }
        else {
            recorder.stopRecording { (previewController, error) in
                guard error == nil, let previewController = previewController else {
                    print("Failed to stop recording")
                    return
                }
                
                previewController.previewControllerDelegate = self
                self.present(previewController, animated: true)
                self.recordButton.setTitle("Start Recording", for: .normal)
            }
        }
    }
    
    @IBAction func microphoneSwitchChanged(_ sender: UISwitch) {
        self.isMicrophoneEnabled = sender.isOn
    }
}

//MARK: - Extensions
extension ViewController: RPPreviewViewControllerDelegate {
    func previewControllerDidFinish(_ previewController: RPPreviewViewController) {
        previewController.dismiss(animated: true)
    }
}
