//
//  Judge.swift
//  MasterW
//
//  Created by 國維 賴 on 2/18/18.
//  Copyright © 2018 Sherry. All rights reserved.
//

import Foundation
import CoreGraphics
import UIKit

extension UIImage {
    func getPixelColor(pos: CGPoint) -> Int {
        
        let pixelData = self.cgImage!.dataProvider!.data
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        
        let pixelInfo: Int = ((Int(self.size.width) * Int(pos.y)) + Int(pos.x)) * 4
        
        let r = CGFloat(data[pixelInfo]) / CGFloat(255.0)
        let g = CGFloat(data[pixelInfo+1]) / CGFloat(255.0)
        let b = CGFloat(data[pixelInfo+2]) / CGFloat(255.0)
        let a = CGFloat(data[pixelInfo+3]) / CGFloat(255.0)
        let gray = Int(0.21*r  + 0.72*g + 0.07*b)
        return gray
    }
    
}

class Judgesystem {
    
    func testRating(handwriting: [[Bool]]) -> Double {
        
        let pattern1 = UIImage(named: "Rouge_test_Best_s")!
        let pattern2 = UIImage(named: "Rouge_test_hack_s")!
        let pattern3 = UIImage(named: "Rouge_test_ever_s")!
        
        var pattern = [[[Bool]]]()
        let p1_width = Int(pattern1.size.width*pattern1.scale)
        let p1_height = Int(pattern1.size.height*pattern1.scale)
        let p2_width = Int(pattern2.size.width*pattern2.scale)
        let p2_height = Int(pattern2.size.height*pattern2.scale)
        let p3_width = Int(pattern3.size.width*pattern3.scale)
        let p3_height = Int(pattern3.size.height*pattern3.scale)
        
        
        pattern.append(Array(repeating: Array(repeating: false, count: p1_width), count: p1_height))
        pattern.append(Array(repeating: Array(repeating: false, count: p2_width), count: p2_height))
        pattern.append(Array(repeating: Array(repeating: false, count: p3_width), count: p3_height))
        
        for xx in 0..<p1_width {
            for yy in 0..<p1_height {
                var point = CGPoint(x:xx,y:yy)
                var color = pattern1.getPixelColor(pos: point)
                if color == 1 {
                    pattern[0][yy][xx] = true
                }
            }
        }
        for xx in 0..<p2_width {
            for yy in 0..<p2_height {
                var point = CGPoint(x:xx,y:yy)
                var color = pattern1.getPixelColor(pos: point)
                if color == 1 {
                    pattern[1][yy][xx] = true
                }
            }
        }
        for xx in 0..<p3_width {
            for yy in 0..<p3_height {
                var point = CGPoint(x:xx,y:yy)
                var color = pattern1.getPixelColor(pos: point)
                if color == 1 {
                    pattern[2][yy][xx] = true
                }
            }
        }
        
        
        
        let seg_num = pattern.count
        var histogram = Array(repeating: 0, count: handwriting[0].count)
        
        for j in 0..<histogram.count {
            var temp = 0
            for i in 0..<handwriting.count {
                if handwriting[i][j] {
                    temp += 1
                }
            }
            histogram[j] = temp
        }
        
        var flag = -1
        var temp_len = 0
        var temp_end_pos = 0
        let threshold = 30
        var seg = 0
        var seg_pos = Array(repeating: Array(repeating: 0, count: 4), count: seg_num)
        for i in 0..<histogram.count {
            if flag == -1 && histogram[i] > 0 {
                flag = 1
                seg_pos[seg][0] = i
            }
            
            if histogram[i] == 0 && flag == 1 && seg == (seg_num - 1) {
                temp_end_pos = i - 1
                seg_pos[seg][1] = temp_end_pos
                break
            }else if histogram[i] == 0 && flag == 1 {
                temp_len += 1
                flag = 0
                temp_end_pos = i - 1
            }else if histogram[i] == 0 && flag == 0 {
                temp_len += 1
                flag = 0
            }
            
            if histogram[i] > 0 && flag == 0 && temp_len > threshold {
                seg_pos[seg][1] = temp_end_pos
                flag = 1
                seg += 1
                seg_pos[seg][0] = i
                temp_len = 0
            }
            if histogram[i] > 0 {
                flag = 1
                temp_len = 0
            }
            if i == (histogram.count - 1) {
                seg_pos[seg][1] = i
            }
        }
        
        for i in 0..<seg_num {
            for jj in seg_pos[i][0]..<(seg_pos[i][1]+1) {
                for ii in 0..<handwriting.count {
                    if handwriting[ii][jj] {
                        seg_pos[i][2] = ii
                        
                        break
                    }
                }
            }
            
            
            for jjj in seg_pos[i][0]..<(seg_pos[i][1]+1) {
                for iii in stride(from: (handwriting.count-1), through: 0, by: -1) {
                    if handwriting[iii][jjj] {
                        seg_pos[i][3] = iii
                        
                        break
                    }
                }
            }
            
        }
        
        var total = 0
        var hit = 0
        for i in 0..<seg_num {
            var temp_image = Array(repeating: Array(repeating: false, count: pattern[i][0].count), count: pattern[i].count)
            let width_para = (seg_pos[i][1] - seg_pos[i][0] + 1) / pattern[i][0].count
            let height_para = (seg_pos[i][3] - seg_pos[i][2] + 1) / pattern[i].count
            for ii in 0..<pattern[i].count{
                for jj in 0..<pattern[i][0].count{
                    temp_image[ii][jj] = handwriting[Int(ii*height_para)][Int(jj*width_para)]
                    total += 1
                    if temp_image[ii][jj] == pattern[i][ii][jj]{
                        hit += 1
                    }
                }
            }
            
        }
        
        let result = (Double(hit)/Double(total))
        
        
        return result
        
    }
    
    func trainRtFB() {
        
        
    }
    
}

