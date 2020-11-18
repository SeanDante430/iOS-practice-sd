//
//  ViewController.swift
//  iOSpracetice
//
//  Created by sean on 2020/2/15.
//  Copyright © 2020 Channel Sean. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    enum ButtonColor:Int{
        case red = 1
        case Green = 2
        case Blue = 3
        case Yellow = 4
    }
    
    enum WhoseTurn{
        case Human
        case Computer
    }
    
    //view related objects and variables
    @IBOutlet weak var redButton: UIButton!
    @IBOutlet weak var greenButton: UIButton!
    @IBOutlet weak var blueButton: UIButton!
    @IBOutlet weak var yellowButton: UIButton!
    
    //model related objectts and variables
    let winningNumber: Int = 25
    var currentPlater: WhoseTurn = .Computer
    var inputs = [ButtonColor]()
    var indexOfNextButtonTotouch: Int = 0
    var highlightSquareTime = 0.5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        startNewGame()
    }

    func buttonByColor(color: ButtonColor)-> UIButton {
        switch color{
        case .red:
            return redButton;
        case .Green:
            return greenButton;
        case .Blue:
            return blueButton;
        case .Yellow:
            return yellowButton;
        }
    }
    
    func playSequence(index: Int, highlightTime: Double){
        currentPlater = .Computer
        
        if index == inputs.count {
            currentPlater = .Human
            return
        }
        
        let button: UIButton = buttonByColor(color: inputs[index])
        let originalColor: UIColor? = button.backgroundColor
        let highlightColor: UIColor = UIColor.white
        
        UIView.animate(withDuration: highlightTime, delay: 0.0, options: [.curveLinea, .allowUserInteraction], animations: {
            button.backgroundColor = highlightColor
        }, completion: { (finished) in
            button.backgroundColor = originalColor
            let newIndex: Int = index + 1
            self.playSequence(index: newIndex, highlightTime: highlightTime)
        })
        
        func buttonTouched(sender: UIButton){
            let buttonTag: Int = sender.tag
            
            if let colorTouched = ButtonColor(rawValue: buttonTag){
                if currentPlater == .Computer{
                    return
                }
                
                if colorTouched == inputs[indexOfNextButtonTotouch]{
                    indexOfNextButtonTotouch+=1
                    
                    if indexOfNextButtonTotouch == inputs.count{
                        if advanceGame() == false {
                            playerWins()
                        }
                        indexOfNextButtonTotouch = 0
                        
                    } else {
                        // there are more buttons letf intthis round... keep going
                    }
                } else {
                  playerLoses()
                    indexOfNextButtonTotouch = 0
                }
            }
        }
        
        func alertView(alertView: UIAlertController, clickedButtonAtIndex: Int){
            
            startNewGame()
        }
        
        func playerWins(){
            let winner: UIAlertController = UIAlertController(
                title: "You Won!",
                message: "Congratulations!",
                preferredStyle: .alert
            )
            self.present(winner, animated: true){}
        }
        
        func playerLoses(){
            let loser: UIAlertController = UIAlertController(
                title: "You Lost!",
                message: "Sorry!",
                preferredStyle: .alert
            )
            self.present(loser, animated: true){}
        }
        
        func randomButton() -> ButtonColor{
            let v: Int = Int(arc4random_uniform(UInt32(4))) + 1
            let result = ButtonColor(rawValue: v)
            
            return result!
        }
        
        func startNewGame() -> Void{
            inputs = [ButtonColor]()
            advanceGame()
        }
        
        func advanceGame() -> Bool{
            var result: Bool = true
            
            if inputs.count == winningNumber {
                result = false
            } else {
                inputs += [randomButton()]
                
                // play the buon sequence
                playSequence(index: 0, highlightTime: highlightSquareTime)
                
            }
            
            return result
        }
    }

}

