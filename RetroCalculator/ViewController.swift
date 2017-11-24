//
//  ViewController.swift
//  RetroCalculator
//
//  Created by ronny abraham on 5/8/17.
//  Copyright © 2017 ronny abraham. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var outputlabel: UILabel!
    
    var runningNumber = ""
    var btnSound: AVAudioPlayer!
    
    var currentOperation = Operation.Empty
    var leftValStr = ""
    var rightValStr = ""
    var result = ""
    
    enum Operation: String {
        case Divide = "/"
        case Multiply = "*"
        case Subtract = "-"
        case Add = "+"
        case Empty = "Empty"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // create url to button sound on system
        let path = Bundle.main.path(forResource: "btn", ofType: "wav")
        let soundURL = URL(fileURLWithPath: path!)
        
        // create an audio palyer and attach it to the soundURL
        do {
            try btnSound = AVAudioPlayer(contentsOf: soundURL)
            btnSound.prepareToPlay()
        } catch let err as NSError {
            print(err.debugDescription)
        }
        
        outputlabel.text = "0"
    }
    
    func playSound() {
        if btnSound.isPlaying {
            btnSound.stop()
        }
        
        btnSound.play()
    }
    
    func processOperation(operation: Operation) {
        
        playSound()
        
        // we've already selected an operation before this time
        if currentOperation != Operation.Empty {
            
            // user selected an operator and then selected another operator without
            // first entering a number
            
            
            if runningNumber != "" {
                
                // get the running number and set it to nothing if there is something in it
                rightValStr = runningNumber
                runningNumber = ""
                
                // perform an operation - this only works because we had something in running number
                
                if currentOperation == Operation.Multiply {
                    result = "\(Double(leftValStr)! * Double(rightValStr)!)"
                } else if currentOperation == Operation.Divide {
                    result = "\(Double(leftValStr)! / Double(rightValStr)!)"
                } else if currentOperation == Operation.Subtract {
                    result = "\(Double(leftValStr)! - Double(rightValStr)!)"
                } else if currentOperation == Operation.Add {
                    result = "\(Double(leftValStr)! + Double(rightValStr)!)"
                }
                
                // mvoe the result (which is the total up till now) into 
                // the left value string and output it to the calculator too
                
                leftValStr = result
                outputlabel.text = result
            }
            
            currentOperation = operation
        } else {
            // this is the first time we've selected an operation
            
            // move whatever is in the running number over to leftvalstr so we can apply it the
            // next time an opeartion (such as equals or whatever) is added
            
            // then set running number to blank, an store this operation for later so we know
            // stuff has been entered and we can use the if-code block above instead of this one
            // which is an initializer code block
            
            leftValStr = runningNumber
            runningNumber = ""
            currentOperation = operation
        }
    }

    @IBAction func numberPressed(sender: UIButton) {
        playSound()
        
        runningNumber += "\(sender.tag)"
        outputlabel.text = runningNumber
    }
    
    @IBAction func onDividePressed(sender: Any) {
        processOperation(operation: .Divide)
    }
    @IBAction func onMultiplyPressed(sender: Any) {
        processOperation(operation: .Multiply)
        
    }
    @IBAction func onSubtractPressed(sender: Any) {
        processOperation(operation: .Subtract)
        
    }
    @IBAction func onAddPressed(sender: Any) {
        processOperation(operation: .Add)
    }
    
    @IBAction func onEqualPressed(sender: Any) {
        processOperation(operation: currentOperation)
    }
    
    @IBAction func onClearPressed( sender: Any ) {
        playSound()
        currentOperation = Operation.Empty
        runningNumber = ""
        leftValStr = ""
        rightValStr = ""
        outputlabel.text = ""
    }
}

