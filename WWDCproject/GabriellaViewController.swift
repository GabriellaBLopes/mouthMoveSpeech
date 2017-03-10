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
    let animationDuration = 0.045
    var animationTimer:Timer!

    
    
    @IBOutlet weak var constraintBottomMouthBottomFace: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        synthesizer.delegate = self
        animationTimer = Timer()
        //        NSLayoutConstraint.activate([
        //            safeArea.topAnchor.constraint(equalTo: liveViewSafeAreaGuide.topAnchor, constant: 20),
        //            safeArea.bottomAnchor.constraint(equalTo: liveViewSafeAreaGuide.bottomAnchor)
        //            ])
        
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        speakIntro()
        openMouth()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    func speakIntro(){
        
        let utterance = AVSpeechUtterance(string: "Hi! My name is Gabriella Lopes.")
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        
        synthesizer.speak(utterance)
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, willSpeakRangeOfSpeechString characterRange: NSRange, utterance: AVSpeechUtterance) {
        
        print("will speak")
        
/*
         
        let analyzedUtterance = analyzeUtterance(utterance: utterance.speechString)
        
        for vowelCount in analyzedUtterance.vowels{
            
            speechMovement.append(openMouth)
            if vowelCount <= 1{
                speechMovement.append(closeMouth)
            } else{
                for _ in 1...vowelCount{
                    speechMovement.append(openMidMouth)
                    speechMovement.append(openMouth)
                }
                speechMovement.append(closeMouth)
            }
            
        }
 */
        
        
        //print("speechMovement = \(speechMovement)")
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        
        //print("did start utterance")
        let analyzedUtterance = analyzeUtterance(utterance: utterance.speechString)
        
        for vowelCount in analyzedUtterance.vowels{
            
            speechMovement.append(openMouth)
            if vowelCount <= 1{
                speechMovement.append(closeMouth)
            } else{
                for _ in 1...vowelCount{
                    speechMovement.append(openMidMouth)
                    speechMovement.append(openMouth)
                }
                speechMovement.append(closeMouth)
            }
            
        }
        
        createAnimationTimer()
        
    }
    
    func analyzeUtterance(utterance: String) -> (vowels:[Int], words:Int){
        
        var vowelsCount:[Int] = [0]
        var wordCount = 1
        
        
        for character in utterance.characters {
            
            switch character{
                
            case " ":
                wordCount += 1
                vowelsCount.append(0)
                
            case "a","e","i","o","u":
                
                if vowelsCount.count == wordCount{
                    vowelsCount[wordCount-1] += 1
                }
                
            default:
                print(" ")
            }
        }
        
        print("vowelsCount: \(vowelsCount)\nwordCount: \(wordCount)")
        return (vowelsCount, wordCount)
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
