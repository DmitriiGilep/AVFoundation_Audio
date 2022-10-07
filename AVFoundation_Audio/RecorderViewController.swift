//
//  RecorderViewController.swift
//  AVFoundation_Audio
//
//  Created by DmitriiG on 05.10.2022.
//

import UIKit
import AVFoundation

final class RecorderViewController: UIViewController, AVAudioRecorderDelegate {
    
    // диктофон и сессия записи
    private var recorder: AVAudioRecorder!
    private var recordingSession: AVAudioSession!
    
    // плейер
    private var player: AVAudioPlayer!
    
    // статус доступка к микрофону
    let audioStatus = AVCaptureDevice.authorizationStatus(for: .audio)
    
    // номер трека
    private var number = 0
    
    
    @IBOutlet weak var recordButton: UIButton!
    
    @IBOutlet weak var playButton: UIButton!
    
    // старт записи диктофона
    @IBAction func startRecording(_ sender: Any) {
        if recorder == nil {
            if audioStatus == .authorized {
                recordInProcess()
            } else {
                getStatus()
            }
        }
        else {
            recorder.stop()
            UserDefaults.standard.set(number, forKey: "number")
            recordButton.setTitle("Запись", for: .normal)
            recorder = nil
        }
    }
    
    // проигрывание записи
    @IBAction func startPlaying(_ sender: Any) {
        let fileName = getPath().appendingPathComponent("\(number).m4a")
        if player == nil {
            do {
                player = try AVAudioPlayer(contentsOf: fileName)
                player.play()
                playButton.setTitle("Стоп", for: .normal)
            } catch {
                return
            }
        } else {
            player.stop()
            playButton.setTitle("Воспроизведение", for: .normal)
            player = nil
            
        }
    }
    
    // функция записии
    private func recordInProcess() {
        number += 1
        let fileName = getPath().appendingPathComponent("\(number).m4a")
        let settings = [AVFormatIDKey: Int(kAudioFormatMPEG4AAC), AVSampleRateKey: 12000, AVNumberOfChannelsKey: 1, AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue]
        
        do {
            recorder = try AVAudioRecorder(url: fileName, settings: settings)
            recorder.delegate = self
            recorder.record()
            recordButton.setTitle("Остановить", for: .normal)
        } catch {
            preconditionFailure("Something wrong with the recorder")
        }
    }
    
    // получение места хранения
    private func getPath() -> URL {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let directory = path[0]
        return directory
    }
    
    // запрос разрешения на доступ к микрофону
    private func getStatus() {
        AVCaptureDevice.requestAccess(for: .audio) { response in
            if response && self.audioStatus == .authorized {
                self.recordInProcess()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        recordingSession = AVAudioSession.sharedInstance()
//        AVAudioSession.sharedInstance().requestRecordPermission() { response in
//                switch response {
//                case true:
//                    self.accessResult =  .accepted
//                case false:
//                    self.accessResult = .rejected
//                }
//            }
        
        // хранение имени файла
        if let numberStored: Int = UserDefaults.standard.object(forKey: "number") as? Int {
            number = numberStored
        }
        
        
    }
}
