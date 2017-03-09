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
        openMouth()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    
    func speakIntro(){
        
        let utterance = AVSpeechUtterance(string: "aag hhj eior trey bb")
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        
        synthesizer.speak(utterance)
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        
        print("did start utterance")
        
        let analyzedUtterance = analyzeUtterance(utterance: utterance.speechString)
        
        let speechMovement:[()->Void] = [openMouth]
        
        //speechMovement.append(<#T##newElement: () -> Void##() -> Void#>)
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
            print("not vowel")
            }
        }
        
        print("vowelsCount: \(vowelsCount)\nwordCount: \(wordCount)")
        return (vowelsCount, wordCount)
    }
    
    func openMouth(){
        
        UIView.animate(withDuration: 0.2, delay: 0.0, options: [.curveEaseInOut], animations: {
            
            self.constraintBottomMouthBottomFace.constant = 30
            self.view.layoutIfNeeded()
            
        }, completion: { _ in
            
            
            self.closeMouth()
        })
    }
    
    func openMidMouth(){
        
        UIView.animate(withDuration: 0.2, delay: 0.0, options: [.curveEaseInOut], animations: {
            
            self.constraintBottomMouthBottomFace.constant = 15
            self.view.layoutIfNeeded()
            
        }, completion: { _ in
            
            
            self.closeMouth()
        })
    }
    
    func closeMouth(){
        
        UIView.animate(withDuration: 0.2, delay: 0.0, options: [.curveEaseInOut], animations: {
            
            self.constraintBottomMouthBottomFace.constant = 0
            self.view.layoutIfNeeded()

            
        }, completion: { _ in
            
            self.openMouth()
        })
    }
}
extension GabriellaViewController {
    class func loadFromStoryboard() -> GabriellaViewController {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        return storyboard.instantiateInitialViewController() as! GabriellaViewController
    }
}
