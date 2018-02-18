//
//  ViewController.swift
//  MasterW
//
//  Created by Sherry on 17/02/2018.
//  Copyright © 2018 Sherry. All rights reserved.
//

import UIKit

class ViewController: UIViewController, MyDelgate {

    @IBOutlet weak var writescoreTextView: UITextView!
    @IBOutlet weak var forceView: UIView!
    @IBOutlet weak var canvasView: CanvasView!
    @IBOutlet weak var BestHWImageView: UIImageView!
    private var fontsInd: CGFloat = 0
    private var levelInd: CGFloat = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        canvasView.clearCanvas(animated:false)
        canvasView.delegate = self
        
        canvasView.backgroundColor = UIColor(white: 1, alpha: 1)
        BestHWImageView.backgroundColor = UIColor(white: 1, alpha: 0)
    }
    
    // Shake to clear screen
    
    @IBAction func clearButton(_ sender: UIButton) {
        canvasView.clearCanvas(animated: true)
    }
    private func clickedConfirmHWButtonAction(sender: AnyObject){
        let indicator = 10 * fontsInd + levelInd
        var imagename: String = "sen_cav.png"
        switch indicator {
        case 0:
            imagename = "sen_cav.png"
            break
        case 1:
            imagename = "sen_cav.png"
            break
        case 2:
            imagename = "sen_cav.png"
            break
        case 3:
            imagename = "sen_cav.png"
            break
        case 10:
            imagename = "sen_cav.png"
            break
        case 11:
            imagename = "sen_cav.png"
            break
        case 12:
            imagename = "sen_cav.png"
            break
        case 13:
            imagename = "sen_cav.png"
            break
        case 20:
            imagename = "sen_cav.png"
            break
        case 21:
            imagename = "sen_cav.png"
            break
        case 22:
            imagename = "sen_cav.png"
            break
        case 23:
            imagename = "sen_cav.png"
            break
        default:
            break
        }
        BestHWImageView.image = UIImage(named: imagename)
    }
    //  override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
    //    canvasView.clearCanvas(animated: true)
    //  }
    
    func sendForce(forceData: Float) {
        self.writescoreTextView?.text = String(forceData)
        
        let forceColor = mixGreenAndRed(greenAmount: (Float(forceData)-0.7)/1.3)
        forceView.backgroundColor = forceColor
        
    }
    
    func mixGreenAndRed(greenAmount: Float) -> UIColor {
        // the hues between red and green go from 0…1/3, so we can just divide percentageGreen by 3 to mix between them
        return UIColor(hue: CGFloat(greenAmount / 3), saturation: CGFloat(1.0), brightness: CGFloat(1.0), alpha: CGFloat(1.0))
        
    }
}

