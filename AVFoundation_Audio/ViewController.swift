//
//  ViewController.swift
//  AVFoundation_Audio
//
//  Created by Niki Pavlove on 18.02.2021.
//

import UIKit
import AVFoundation

final class ViewController: UIViewController {
    
    private var currentTime = 0.00
    
    // плейер
    var Player = AVAudioPlayer()
    var initialText = "Название композиции"
    
    // словарь названий песен
    let songsDict = [
        1: "Besame Mucho",
        2: "Sodade",
        3: "Luiza",
        4: "Tudo Tem Se Limite",
        5: "Sabine Largam",
        6: "Queen"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameOfSong.text = initialText
        nameOfSong.textAlignment = .center
        
    }
    
    @IBOutlet weak var nameOfSong: UILabel!
    
    // кнопка начала проигрывания плейера: если плейер играет, то пауза и установление текущего времени проигрывания; если не игрывает, но время больше нуля, то просто продолжить играть после паузы; иначе (если не играет и время 0) - новая композиция
    @IBAction func PlayButton(_ sender: Any) {
        if Player.isPlaying {
            Player.pause()
            currentTime = Player.currentTime
        } else if currentTime != 0.00 {
            Player.play()
        } else {
            if let currentSong = Player.url?.deletingPathExtension().lastPathComponent {
                playSong(nameOfSong: currentSong)
            } else {
                playSong(nameOfSong: songsDict[1]!)
            }
        }
        
    }
    
    // кнопка остановки: если играет, то стоп и время проигрывания 0 (то есть плей будет играть заново; если не играет (то есть на паузе, например, то обнулить, чтобы опять играл заново)
    @IBAction func StopButton(_ sender: Any) {
        if Player.isPlaying {
            Player.stop()
            Player.currentTime = 0
            nameOfSong.text = initialText
        }
        else {
            Player.currentTime = 0
            nameOfSong.text = initialText
            print("Already stopped!")
        }
    }
    
    // переход назад в зависимости от ключа текущей композиции
    @IBAction func BackButton(_ sender: UIButton) {
        if let currentSong = Player.url?.deletingPathExtension().lastPathComponent {
            for (key, song) in songsDict {
                if currentSong == song {
                    playSong(nameOfSong: songsDict[key - 1] ?? songsDict[6]!)
                }
            }
        }
    }
    
    // аналогично вперед
    @IBAction func ForwardButton(_ sender: Any) {
        if let currentSong = Player.url?.deletingPathExtension().lastPathComponent {
            for (key, song) in songsDict {
                if currentSong == song {
                    playSong(nameOfSong: songsDict[key + 1] ?? songsDict[1]!)
                }
            }
            
        }
    }
    
    // запуск плейера
    private func playSong(nameOfSong: String) {
        guard let path = Bundle.main.path(forResource: nameOfSong, ofType: "mp3") else {
            preconditionFailure("No any songs")
        }
        let url = URL.init(fileURLWithPath: path)
        
        do {
            Player = try AVAudioPlayer(contentsOf: url)
            Player.prepareToPlay()
            Player.play()
            self.nameOfSong.text = Player.url?.deletingPathExtension().lastPathComponent
        }
        catch {
            print(error)
        }
        
    }
    
    
}
