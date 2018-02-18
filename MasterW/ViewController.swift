//
//  ViewController.swift
//  MasterW
//
//  Created by Sherry on 17/02/2018.
//  Copyright © 2018 Sherry. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var canvasView: CanvasView!
    @IBOutlet weak var BestHWImageView: UIImageView!
    private var fontsInd: CGFloat = 0
    private var levelInd: CGFloat = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        canvasView.clearCanvas(animated:false)
        canvasView.backgroundColor = UIColor(white: 1, alpha: 1)
        BestHWImageView.backgroundColor = UIColor(white: 1, alpha: 0)
    }
    
    // Shake to clear screen
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        canvasView.clearCanvas(animated: true)
    }
    
    private func clickedConfirmHWButtonAction(sender: AnyObject){
        let indicator = 10 * fontsInd + levelInd
        var imagename: String = ""
        switch indicator {
        case 0:
            imagename = ""
            break
        case 1:
            imagename = ""
            break
        case 2:
            imagename = ""
            break
        case 3:
            imagename = ""
            break
        case 10:
            imagename = ""
            break
        case 11:
            imagename = ""
            break
        case 12:
            imagename = ""
            break
        case 13:
            imagename = ""
            break
        case 20:
            imagename = ""
            break
        case 21:
            imagename = ""
            break
        case 22:
            imagename = ""
            break
        case 23:
            imagename = ""
            break
        default:
            break
        }
        imagename = "Bal_train_a_d_cav.png"
        BestHWImageView.image = UIImage(named: imagename)
    }
    //  override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
    //    canvasView.clearCanvas(animated: true)
    //  }
}

