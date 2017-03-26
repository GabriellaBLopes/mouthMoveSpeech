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
  
  @IBOutlet weak var gabriellaView: UIView!
  @IBOutlet weak var myFace: UIImageView!
  @IBOutlet weak var myMouth: UIImageView!
  
  @IBOutlet weak var background: UIImageView!
  
  
  let faceTapRecognizer = UITapGestureRecognizer()
  
  
  @IBOutlet weak var askButton: UIButton!
  @IBOutlet weak var askLabel: UILabel!
  @IBOutlet weak var askSubLabel: UILabel!
  
  
  
  @IBOutlet weak var captionLabel: UILabel!
  
  
  let synthesizer = AVSpeechSynthesizer()
  var speechMovement:[()->Void] = []
  var speechMovementIndex = 0
  var currentSpeech = 0
  let animationDuration = 0.2
  var animationTimer = Timer()
  
  let faceCout = 4
  var faceIndex = 1
  
  let questionSpeech = ["Hey! What’s up?", "Woah! Cool Siri voice!\nAnd who are you?", "Nice meeting you!\nWhat do you like to do, Gabriella?", "I like to move it too!\nWe have so much in common!\n\nCome to WWDC with me!"]
  
  let gabriellaSpeech = ["Nothing much, just floating around!", "I’m Gabriella Lopes! I’m 20 years old and study Design in Rio de Janeiro, Brazil!","I like to move it move it. I like to move it move it. I like to move it move it. Ya like to. Move it!", "Let’s go! Wohooooooooo!!"]
  
  
  @IBOutlet weak var constraintBottomMouthBottomFace: NSLayoutConstraint!
  
  @IBOutlet weak var constraintFaceCenterY: NSLayoutConstraint!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    synthesizer.delegate = self
    
    self.askButton.layer.cornerRadius = 3
    self.askButton.layer.shadowRadius = 7
    self.askButton.layer.shadowColor = UIColor.black.cgColor
    self.askButton.layer.shadowOpacity = 0.5
    
    
    self.askLabel.text = questionSpeech[currentSpeech]
    
    faceTapRecognizer.addTarget(self, action: #selector(GabriellaViewController.tappedMyFace))
    
    
    gabriellaView.addGestureRecognizer(faceTapRecognizer)
    
    
    
    self.captionLabel.alpha = 0
    
    print("___ \(questionSpeech.count) ___QUESTION TEXT COUNT")
    print("____ \(gabriellaSpeech.count) GABRIELLA SPEECH COUNT")
    
    
    //        NSLayoutConstraint.activate([
    //            safeArea.topAnchor.constraint(equalTo: liveViewSafeAreaGuide.topAnchor, constant: 20),
    //            safeArea.bottomAnchor.constraint(equalTo: liveViewSafeAreaGuide.bottomAnchor)
    //            ])
    
  }
  
  
  
  override func viewDidAppear(_ animated: Bool) {
    
    //Makes head float
  
   // /*
    UIView.animate(withDuration: 1.0, delay: 0.0, options: [.curveEaseInOut, .autoreverse, .repeat, .allowUserInteraction], animations: {
      
      self.constraintFaceCenterY.constant += 20
      
      self.view.layoutIfNeeded()
      
      
    }, completion: nil)
 //*/
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    
  }
  
  func hideAskShowCaption(){
    
    UIView.animate(withDuration: 0.4, animations: {
      
      self.askLabel.alpha = 0
      self.askSubLabel.alpha = 0
      self.askButton.alpha = 0
      self.captionLabel.alpha = 1
    })
  }
  
  func hideCaptionShowAsk(){
    
    UIView.animate(withDuration: 0.4, animations: {
      
      self.askLabel.alpha = 1
      self.askSubLabel.alpha = 1
      self.askButton.alpha = 1
      self.captionLabel.alpha = 0
    })
  }
  
  
  func speak(currentSpeech:Int){
    
    let utterance = AVSpeechUtterance(string: gabriellaSpeech[currentSpeech])
    utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
    
    self.captionLabel.text = gabriellaSpeech[currentSpeech]
    
    synthesizer.speak(utterance)
  }
  
  //MARK:- Animations
  
  func animateMouth(){
    
    if speechMovementIndex <= speechMovement.count - 2{
      speechMovementIndex += 1
    }
    if speechMovementIndex <= speechMovement.count - 1{
      speechMovement[speechMovementIndex]()
    } else{
      speechMovement = []
      animationTimer.invalidate()
      animationTimer = Timer()
    }
    
    
  }
  
  func createAnimationTimer(){
    
    
    animationTimer = Timer.scheduledTimer(timeInterval: animationDuration, target: self, selector: #selector(GabriellaViewController.animateMouth), userInfo: nil, repeats: true)
    
    animationTimer.fire()
  }
  
  //MARK: Open, mid open and close mouth animations
  
  func openMouth(){
    
    print("open mouth")
    
    UIView.animate(withDuration: animationDuration, delay: 0.0, options: [.curveEaseInOut, .allowUserInteraction], animations: {
      
      self.constraintBottomMouthBottomFace.constant = 30
      
      if self.synthesizer.isSpeaking == false{
        self.constraintBottomMouthBottomFace.constant = 0
      }
      
      self.view.layoutIfNeeded()
      
    }, completion: nil)
  }
  
  func openMidMouth(){
    
    print("open MID mouth")
    
    UIView.animate(withDuration: animationDuration, delay: 0.0, options: [.curveEaseInOut, .allowUserInteraction], animations: {
      
      self.constraintBottomMouthBottomFace.constant = 15
      self.view.layoutIfNeeded()
      
    }, completion: nil)
  }
  
  func closeMouth(){
    
    if self.synthesizer.isSpeaking == false{
      
      return
    }
    
    print("close mouth")
    
    
    UIView.animate(withDuration: animationDuration, delay: 0.0, options: [.curveEaseInOut, .allowUserInteraction], animations: {
      
      self.constraintBottomMouthBottomFace.constant = 0
      self.view.layoutIfNeeded()
      
      
    }, completion: nil)
  }
  
  //MARK:- Synthesizer functions
  
  func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, willSpeakRangeOfSpeechString characterRange: NSRange, utterance: AVSpeechUtterance) {
    
    
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
      self.askLabel.text = questionSpeech[currentSpeech]
      hideCaptionShowAsk()
      
    } else{
      
      self.background.image = UIImage(named: "backgroundWWDC")
    }
    
    //speechMovement = []
  }
  
  
  //MARK:- Actions
  
  @IBAction func tappedAskButton(_ sender: Any) {
    
    hideAskShowCaption()
    
    speak(currentSpeech: currentSpeech)
  }
  
  func tappedMyFace(){
      
      
      self.faceIndex += 1
      
      if self.faceIndex > self.faceCout{
        
        self.faceIndex = 1
      }
      
      self.myFace.image = UIImage(named: "cara\(self.faceIndex)")
      self.myMouth.image = UIImage(named: "boca\(self.faceIndex)")
      
      print("OUCH!")
    }
}
extension GabriellaViewController {
  class func loadFromStoryboard() -> GabriellaViewController {
    let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
    return storyboard.instantiateInitialViewController() as! GabriellaViewController
  }
}
