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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        canvasView.clearCanvas(animated:false)
    }
    
    // Shake to clear screen
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        canvasView.clearCanvas(animated: true)
    }
    //  override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
    //    canvasView.clearCanvas(animated: true)
    //  }
}

