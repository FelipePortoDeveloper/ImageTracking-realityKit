//
//  ContentView.swift
//  ImageTracking
//
//  Created by Felipe Porto on 10/07/24.
//

import SwiftUI
import RealityKit
import Combine
import ARKit
import AVFoundation

struct ContentView : View {
    var body: some View {
        ARViewContainer().edgesIgnoringSafeArea(.all)
    }
}
 
class Coordinator: NSObject, ARSessionDelegate {
    
    weak var arView: ARView?
    weak var cancellable: AnyCancellable?
    
    func setupUI() {
        
        // Carregando o arView
        
        guard let arView = arView else {return}
        
        // Carregando o vídeo
        
        guard let video = Bundle.main.url(forResource: "horaVideo", withExtension: "mp4") else {fatalError("carai cade o video?")}
        
        let player = AVPlayer(url: video)
        player.volume = 0.5
        
        let videoMaterial = VideoMaterial(avPlayer: player)
        
        let anchor = AnchorEntity(.image(group: "AR Resources", name: "reicopas"))
        
        let plane = ModelEntity(mesh: .generatePlane(width: 0.5, height: 0.5 ), materials: [videoMaterial])
        
        anchor.addChild(plane)
        
        arView.scene.addAnchor(anchor)
            
            player.play()
        
    }
    
}

struct ARViewContainer: UIViewRepresentable {
    
    func makeUIView(context: Context) -> ARView {
        
        let arView = ARView(frame: .zero)

        // Config inicial para o Coordinator
        
        context.coordinator.arView = arView
        arView.session.delegate = context.coordinator
        context.coordinator.setupUI()

        return arView
        
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
}

#Preview {
    ContentView()
}
