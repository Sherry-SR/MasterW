//
//  CanvasView.swift
//  MasterW
//
//  Created by Sherry on 17/02/2018.
//  Copyright © 2018 Sherry. All rights reserved.
//

import UIKit

//let π = CGFloat(M_PI)
let π = CGFloat(Double.pi)

class CanvasView: UIImageView {
    // Parameters
    private let forceSensitivity: CGFloat = 4.0
    private var pencilTexture = UIColor(patternImage: UIImage(named: "PencilTexture")!)
    private let tiltThreshold = π/6  // 30º
    private let minLineWidth: CGFloat = 5
    private var eraserColor: UIColor {
        return backgroundColor ?? UIColor.white
    }
    private let defaultLineWidth:CGFloat = 6
    
    
    //  private var drawColor: UIColor = UIColor.redColor()
    private var drawColor: UIColor = UIColor.black
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        //
        //    }
        //  override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0.0)
        let context = UIGraphicsGetCurrentContext()
        
        // Draw previous image into context
        //    image?.drawInRect(bounds)
        image?.draw(in: bounds)
        
        //    drawStroke(context, touch: touch)
        // 1
        var touches = [UITouch]()
        
        // 2
        if let coalescedTouches = event?.coalescedTouches(for: touch) {
            touches = coalescedTouches
        } else {
            touches.append(touch)
        }
        
        // 3
        for touch in touches {
            drawStroke(context: context, touch: touch)
        }
        
        // Update image
        image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
    
    private func drawStroke(context: CGContext?, touch: UITouch) {
        let previousLocation = touch.previousLocation(in: self)
        //    let previousLocation = touch.previousLocationInView(self)
        let location = touch.location(in: self)
        
        //    let location = touch.locationInView(self)
        // Calculate line width for drawing stroke
        
        var lineWidth:CGFloat
        
        // Apply eraser/shade
        if touch.type == .stylus {
            if touch.altitudeAngle < tiltThreshold {
                lineWidth = lineWidthForShading(context: context, touch: touch)
            } else {
                lineWidth = lineWidthForDrawing(context: context, touch: touch)
            }
            // Set texture
            drawColor.setStroke()
            //pencilTexture.setStroke()
            
            // Get pencil information
            print("Azimuth:",touch.azimuthUnitVector(in: self)," Altitude:",touch.altitudeAngle, " Location:", touch.location(in: self))
        } else {
            lineWidth = 40
            eraserColor.setStroke()
        }
        
        
        // Configure line
        context?.setLineWidth(lineWidth)
        context?.setLineCap(.round)
        //    CGContextSetLineWidth(context, lineWidth)
        //    CGContextSetLineCap(context, .Round)
        
        
        // Set up the points
        context?.move(to: CGPoint(x: previousLocation.x, y: previousLocation.y))
        context?.addLine(to: CGPoint(x: location.x, y: location.y))
        //    CGContextMoveToPoint(context, previousLocation.x, previousLocation.y)
        //    CGContextAddLineToPoint(context, location.x, location.y)
        // Draw the stroke
        context?.strokePath()
        //    CGContextStrokePath(context)
        
    }
    
    private func lineWidthForDrawing(context: CGContext?, touch: UITouch) -> CGFloat {
        
        var lineWidth = defaultLineWidth
        if touch.force > 0 {
            lineWidth = touch.force * forceSensitivity
        }
        return lineWidth
    }
    
    func clearCanvas(animated: Bool) {
        if animated {
            UIView.animate(
                withDuration: 0.5,
                animations: { self.alpha = 0},
                completion: {   finished in
                    self.alpha = 1
                    self.image = nil
            })
            
            //
            //      UIView.animateWithDuration(0.5, animations: {
            //        self.alpha = 0
            //        }, completion: { finished in
            //          self.alpha = 1
            //          self.image = nil
            //      })
        } else {
            image = nil
        }
    }
    
    private func lineWidthForShading(context: CGContext?, touch: UITouch) -> CGFloat {
        
        // 1
        let previousLocation = touch.previousLocation(in: self)
        let location = touch.location(in: self)
        
        // 2 - vector1 is the pencil direction
        let vector1 = touch.azimuthUnitVector(in: self)
        
        // 3 - vector2 is the stroke direction
        let vector2 = CGPoint(x: location.x - previousLocation.x, y: location.y - previousLocation.y)
        
        // 4 - Angle difference between the two vectors
        var angle = abs(atan2(vector2.y, vector2.x) - atan2(vector1.dy, vector1.dx))
        
        // 5
        if angle > π {
            angle = 2 * π - angle
        }
        if angle > π / 2 {
            angle = π - angle
        }
        
        // 6
        let minAngle: CGFloat = 0
        let maxAngle = π / 2
        let normalizedAngle = (angle - minAngle) / (maxAngle - minAngle)
        
        // 7
        let maxLineWidth: CGFloat = 60
        var lineWidth = maxLineWidth * normalizedAngle
        
        // Using azimuth to adjust width
        // 1
        let minAltitudeAngle: CGFloat = 0.25
        let maxAltitudeAngle = tiltThreshold
        
        // 2
        let altitudeAngle = touch.altitudeAngle < minAltitudeAngle ? minAltitudeAngle : touch.altitudeAngle
        
        // 3
        let normalizedAltitude = 1 - ((altitudeAngle - minAltitudeAngle) / (maxAltitudeAngle - minAltitudeAngle))
        
        // 4
        lineWidth = lineWidth * normalizedAltitude + minLineWidth
        
        return lineWidth
    }
}


