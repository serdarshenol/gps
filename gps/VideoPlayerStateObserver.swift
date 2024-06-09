//
//  VideoPlayerStateObserver.swift
//  gps
//
//  Created by Serdar Senol on 10/06/2024.
//

import Foundation
import AVKit

class VideoPlayerStateObserver : ObservableObject {
    @Published var controlStatus: TimeControlStatus = .idle
        
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidReachEnd), name: .AVPlayerItemDidPlayToEndTime, object: player?.currentItem)
    }
    var player: AVPlayer?
    private var playerObserver: Any?
    private var playerItemObserver: Any?
    private var playerItemEndObserver: Any?
    private var timeControlStatusObserver: Any?
    
    func connectPlayer(player: AVPlayer) {
        self.player = player
        self.player?.actionAtItemEnd = .pause
        setupObservers()
    }
    
    func updateControlStatus(_ status: TimeControlStatus) {
        self.controlStatus = status
    }
    
    func handleError() {
        // Errors can be one of 3 places: AVPlayerItem, AVPlayer or in ErrorQueue
        if let error = player?.currentItem?.error as NSError? {
            self.updateControlStatus(.error("\(error.domain): \(error.code)"))
        } else if let error = player?.error as NSError? {
            self.updateControlStatus(.error("\(error.domain): \(error.code)"))
        } else {
            if let errorLog = player?.currentItem?.errorLog() {
                for event:AVPlayerItemErrorLogEvent in errorLog.events {
                    self.updateControlStatus(.error("\(event.errorDomain): \(event.errorStatusCode)"))
                    // only first one needed, so...
                    break
                }
            }
        }
    }
    
    private func setupObservers() {
        timeControlStatusObserver = player?.observe(\.timeControlStatus, options: [.new], changeHandler: {
            [weak self] (player, change) in
            if (player.timeControlStatus  == AVPlayer.TimeControlStatus.paused) {
                self?.updateControlStatus(.paused)
            } else if (player.timeControlStatus == AVPlayer.TimeControlStatus.waitingToPlayAtSpecifiedRate) {
                self?.updateControlStatus(.waitingToPlayAtSpecifiedRate)
            } else if (player.timeControlStatus == AVPlayer.TimeControlStatus.playing) {
                self?.updateControlStatus(.playing)
            }
        })
        
        // Apple recommends listening to both player and playerItem to capture errors
        
        playerObserver = player?.observe(\AVPlayer.status, options:  [.new], changeHandler: {
            [weak self] (player, change) in
            
            if player.status == .failed {
                self?.handleError()
            }
        })
    }
    
    @objc private func playerItemDidReachEnd(_ notification: Notification) {
        self.controlStatus = .reachedEnd
        print("HELOOOOO")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

public enum TimeControlStatus: Equatable {
    case idle
    case paused
    case waitingToPlayAtSpecifiedRate
    case playing
    case reachedEnd
    case error(String)
}
