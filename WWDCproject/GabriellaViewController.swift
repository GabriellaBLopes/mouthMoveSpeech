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
    @IBOutlet weak var askButton: UIButton!
    @IBOutlet weak var captionLabel: UILabel!
    
    
    let synthesizer = AVSpeechSynthesizer()
    var speechMovement:[()->Void] = []
    var speechMovementIndex = 0
    var currentSpeech = 0
    let animationDuration = 0.2
    var animationTimer = Timer()
    
    let questionText = ["Nice Siri voice, Gabriella! Tell me a bit about yourself. What do you like to do?", "Cool dance. But seriously, what do you do?", "Really? Why is it that you want to go to WWDC?", "You’re in! Let’s go!"]

    let gabriellaSpeech = ["Well, hello there! Nice to talk to you! It gets boring sometimes... Being a floating head and all. My name is Gabriella Lopes, I’m 20 years old and live in Rio de Janeiro, Brazil.", "I like to move it move it. I like to move it move it. I like to move it move it. Ya like to. Move it!","Thanks! I’m a design undergraduate and I’m really fascinated by technology. I’m currently learning iOS development and really enjoy making apps, I even got a few of them on the App Store! I’m also really looking forward to this year’s W W D C!", "Are you kidding me? It would be so awesome and rewarding! Going to W W D C would be a great opportunity to meet people from all over the world who also want to use technology as a tool to make a change for what they believe in. Haha! I get really excited just thinking about it!", "I’m in? WOOOOOOOOOOOOOOOOOOOHOOOOOO!"]

    
    @IBOutlet weak var constraintBottomMouthBottomFace: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        synthesizer.delegate = self
        self.askButton.layer.cornerRadius = 3
        
        print("___ \(questionText.count) ___QUESTION TEXT COUNT")
        print("____ \(gabriellaSpeech.count) GABRIELLA SPEECH COUNT")


        //        NSLayoutConstraint.activate([
        //            safeArea.topAnchor.constraint(equalTo: liveViewSafeAreaGuide.topAnchor, constant: 20),
        //            safeArea.bottomAnchor.constraint(equalTo: liveViewSafeAreaGuide.bottomAnchor)
        //            ])
        
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    func speak(currentSpeech:Int){
        
        let utterance = AVSpeechUtterance(string: gabriellaSpeech[currentSpeech])
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        
        self.captionLabel.text = utterance.speechString
        
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
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        
        if currentSpeech < gabriellaSpeech.count - 1{
        
            currentSpeech += 1
        }
        
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
    
    //MARK: Actions
    
    @IBAction func tappedAskButton(_ sender: Any) {
        
        speak(currentSpeech: currentSpeech)
    }
    
    
    //MARK: Open, mid open and close mouth animations
    
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
