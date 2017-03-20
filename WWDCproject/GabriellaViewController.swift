//
//  ViewController.swift
//  WWDCproject
//
//  Created by Gabriella Lopes on 09/03/17.
//  Copyright © 2017 Gabriella Lopes. All rights reserved.
//

import UIKit
import AVFoundation


@objc(GabriellaViewController)
class GabriellaViewController: UIViewController, AVSpeechSynthesizerDelegate {
    
    @IBOutlet var safeArea: UIView!
    @IBOutlet weak var myFace: UIImageView!
    @IBOutlet weak var myMouth: UIImageView!
    let synthesizer = AVSpeechSynthesizer()
    var speechMovement:[()->Void] = []
    var speechMovementIndex = 0
    let animationDuration = 0.2
    var animationTimer = Timer()

    
    
    @IBOutlet weak var constraintBottomMouthBottomFace: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        synthesizer.delegate = self

        //        NSLayoutConstraint.activate([
        //            safeArea.topAnchor.constraint(equalTo: liveViewSafeAreaGuide.topAnchor, constant: 20),
        //            safeArea.bottomAnchor.constraint(equalTo: liveViewSafeAreaGuide.bottomAnchor)
        //            ])
        
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        speakIntro()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    func speakIntro(){
        
        let utterance = AVSpeechUtterance(string: "Hello. My name is Gabriella Lopes. I'm Brazilian and I'm 20 years old. I like to move it move it. I like to move it move it. I like to move it move it. We like to. Move it! Okay ladies, now let's get in formation. Because I slay.")
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        
        synthesizer.speak(utterance)
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, willSpeakRangeOfSpeechString characterRange: NSRange, utterance: AVSpeechUtterance) {
        
        print("will speak")
        
        speechMovement.append(openMouth)
        
        let microMovements = ceil(Float(characterRange.length) / 3.0)
        print("Micro movements = \(microMovements)") // ceil rounds float up
        
        if microMovements > 1{
            
            for _ in 0...Int(microMovements){
            speechMovement.append(openMidMouth)
            speechMovement.append(openMouth)
            }
        }
        
        speechMovement.append(closeMouth)
        
        createAnimationTimer()
    }
    
    
    func animateMouth(){
        
        if speechMovementIndex <= speechMovement.count - 2{
            speechMovementIndex += 1
        }
        if speechMovementIndex <= speechMovement.count - 1{
            speechMovement[speechMovementIndex]()
        } else{
            animationTimer.invalidate()
            animationTimer = Timer()
        }
        
        
    }
    
    func createAnimationTimer(){
        
        
        animationTimer = Timer.scheduledTimer(timeInterval: animationDuration, target: self, selector: #selector(GabriellaViewController.animateMouth), userInfo: nil, repeats: true)
        
        animationTimer.fire()
    }
    
    func openMouth(){
        
        print("open mouth")
        
        UIView.animate(withDuration: animationDuration, delay: 0.0, options: [.curveEaseInOut], animations: {
            
            self.constraintBottomMouthBottomFace.constant = 30
            self.view.layoutIfNeeded()
            
        }, completion: nil)
    }
    
    func openMidMouth(){
        
        print("open MID mouth")
        
        UIView.animate(withDuration: animationDuration, delay: 0.0, options: [.curveEaseInOut], animations: {
            
            self.constraintBottomMouthBottomFace.constant = 15
            self.view.layoutIfNeeded()
            
        }, completion: nil)
    }
    
    func closeMouth(){
        
        print("close mouth")
        
        
        UIView.animate(withDuration: animationDuration, delay: 0.0, options: [.curveEaseInOut], animations: {
            
            self.constraintBottomMouthBottomFace.constant = 0
            self.view.layoutIfNeeded()
            
            
        }, completion: nil)
    }
}
extension GabriellaViewController {
    class func loadFromStoryboard() -> GabriellaViewController {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        return storyboard.instantiateInitialViewController() as! GabriellaViewController
    }
}
