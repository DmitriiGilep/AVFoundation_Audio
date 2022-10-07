//
//  VideoViewController.swift
//  AVFoundation_Audio
//
//  Created by DmitriiG on 03.10.2022.
//

import UIKit
import AVFoundation
import AVKit
import WebKit

final class VideoViewController: UIViewController {
    
    // вебплейер с конфигурацией
    var webPlayer =  WKWebView()
    let webConfiguration = WKWebViewConfiguration()
    
    // кнопка Х для закрытия вэбплейера
    private let closeButton: UIButton = {
        let button = UIButton()
        button.setTitle("X", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 25)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(closeWebPlayer), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // функция, которая убирает вэбплейер с экрана
    @objc func closeWebPlayer() {
        webPlayer.removeFromSuperview()
    }
    
    // словарь имен и соответствующих им ссылок. Добавлять в конце ?playsinline=1
    private var referenceDict = [
        "The Solar System 🪐 | Sarah & Duck": "https://youtu.be/n2wZrat6deY?playsinline=1",
        "Moon and the Planets - MARATHON | Sarah & Duck": "https://youtu.be/rR-HdvGl8Ok?playsinline=1",
        "Lot's of Shallots | Quacky Flappy Clips | Sarah and Duck": "https://youtu.be/Uua4gx2cKR0?playsinline=1",
        "Pillow Fill | Quacky Flappy Clips | Sarah & Duck": "https://youtu.be/eJnD6znwoNk?playsinline=1",
        "Rainbow Lemon | Quacky Flappy Clips | Sarah & Duck": "https://youtu.be/fTQgeHq4ovk?playsinline=1"]
    
    
    @IBOutlet var tableView: UITableView!
    
    // функция проигрывания вэбплейера
    private func playVideo(urlReference: String) {
        
        // создаем вэбплеер
        webConfiguration.allowsInlineMediaPlayback = true
        webPlayer = WKWebView(frame: self.view.bounds, configuration: webConfiguration)
        webPlayer.isUserInteractionEnabled = true
        webPlayer.translatesAutoresizingMaskIntoConstraints = false
        
        let streamURL = URL(string: urlReference)!

        // добавлям плейер и кнопку закрытия на экран
        self.view.addSubview(webPlayer)
        webPlayer.addSubview(self.closeButton)
        NSLayoutConstraint.activate([
            webPlayer.topAnchor.constraint(equalTo: self.view.topAnchor),
            webPlayer.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            webPlayer.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            webPlayer.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            
            closeButton.bottomAnchor.constraint(equalTo: webPlayer.bottomAnchor, constant: -30),
            closeButton.centerXAnchor.constraint(equalTo: webPlayer.centerXAnchor),
            closeButton.heightAnchor.constraint(equalToConstant: 15),
            closeButton.widthAnchor.constraint(equalToConstant: 15)
        ])
        
        // загружаем видео в другом потоке
        DispatchQueue.main.async {
            self.webPlayer.load(URLRequest(url: streamURL))
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
        tableView.delegate = self
        tableView.dataSource = self
    }
    
}

extension VideoViewController: UITableViewDelegate {
    
}

extension VideoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return referenceDict.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        // создает экземпляр UIListContentConfiguration и передает его в ячейку
        var content = cell.defaultContentConfiguration()
        content.text = "\(Array(referenceDict)[indexPath.row].key)"
        cell.contentConfiguration = content
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // ссылка из словаря, доступк к словарю через массив ключей с индексом ячейки
        guard let urlReference = referenceDict[Array(referenceDict)[indexPath.row].key] else {return}
        
        playVideo(urlReference: urlReference)
    }
    
    
}
