//
//  ContentView.swift
//  gps
//
//  Created by Serdar Senol on 09/06/2024.
//

import SwiftUI
import AVKit

struct ContentView: View {
    private var player = AVPlayer()
    
    @State private var selectedVideo: Video

    @ObservedObject private var playerStateObserver: VideoPlayerStateObserver = VideoPlayerStateObserver()
    
    @State var timeControlStatus: TimeControlStatus = .idle

    private let videos: [Video] = [
        Video(url: URL(string: "https://acorn.nu/no-cup-is-safe.mp4")!, title: "DL 89%", icon: "arrow.up.square"),
        Video(url: URL(string: "https://acorn.nu/apologies.mp4")!, title: "FO Left 87%", icon: "arrow.right.square"),
        Video(url: URL(string: "https://acorn.nu/golfsmith.mp4")!, title: "FO Right 89%", icon: "arrow.backward.square")
    ]
    
    init() {
        _selectedVideo = State(initialValue: videos[0])
    }
    
    var body: some View {
            ZStack {
                VideoPlayer(player: player, videoOverlay: {
                    if timeControlStatus == .idle {
                        Button(action: {
                            initAndPlay(video: selectedVideo)
                        }, label: {
                            Image(systemName: "play.fill")
                                .resizable()
                                .foregroundStyle(.white)
                                .scaledToFit()
                                .frame(width: 40, height: 40)

                        })
                    }
                })
                .padding(.top, 60)
                VStack {
                    nativePicker
                        .padding(.top, 100)
                    .frame(height: 40)
                    Spacer()
                }
            }
            .onChange(of: selectedVideo, {
                player.pause()
                initAndPlay(video: selectedVideo)
            })
            .onChange(of: playerStateObserver.controlStatus) { oldPlayerStatus, newPlayerStatus in
                print("STATUS: \(newPlayerStatus)")
                timeControlStatus = newPlayerStatus
            }
        }
    
    func initAndPlay(video: Video) {
        player.replaceCurrentItem(with: AVPlayerItem(url: video.url))
        playerStateObserver.connectPlayer(player: player)
        player.play();
    }
    
    private var nativePicker: some View {
        Picker("Select Video", selection: $selectedVideo) {
            ForEach(videos, id: \.id) { video in
                Text(video.title)
                    .tag(video)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
        .frame(height: 40)
        .padding()
    }
}

struct Video: Identifiable, Hashable {
    let id = UUID()
    let url: URL
    let title: String
    let icon: String
}

#Preview {
    ContentView()
}
