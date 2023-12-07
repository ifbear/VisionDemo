//
//  VNDetectFaceRectanglesRequestController.swift
//  VisionDemo
//
//  Created by dexiong on 2023/12/7.
//  人脸区识别

import UIKit
import Vision

class VNDetectFaceRectanglesRequestController: UIViewController {
    @IBOutlet private weak var imageView: UIImageView!
    
    private var cgImage: CGImage? {
        if Thread.isMainThread == true {
            return imageView.image?.cgImage
        } else {
            var cgImage: CGImage?
            DispatchQueue.main.sync {
                cgImage = imageView.image?.cgImage
            }
            return cgImage
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.global().async {
            self.faceRectangles()
        }
        
    }
    
    
    private func faceRectangles() {
        // 人脸识别
        let request = VNDetectFaceRectanglesRequest { request, error in
            guard let results = request.results as? [VNFaceObservation] else { return }
            results.forEach { face in
                DispatchQueue.main.async {
                    self.highlightFace(with: face)
                }
            }
        }
        guard let cgimage = cgImage else { return }
        let handler = VNImageRequestHandler(cgImage: cgimage, options: [:])
        try? handler.perform([request])
    }
    
    private func highlightFace(with landmark: VNFaceObservation) {
        guard let source = imageView.image else { return }
        let boundary = landmark.boundingBox
        
        UIGraphicsBeginImageContextWithOptions(source.size, false, 1)
        
        let context = UIGraphicsGetCurrentContext()!
        context.setShouldAntialias(true)
        context.setAllowsAntialiasing(true)
        context.translateBy(x: 0, y: source.size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        context.setLineJoin(.round)
        context.setLineCap(.round)
        
        let rect = CGRect(x: 0, y:0, width: source.size.width, height: source.size.height)
        context.draw(source.cgImage!, in: rect)
        
        let fillColor: UIColor = .green
        fillColor.setStroke()
        
        let rectangleWidth = source.size.width * boundary.size.width
        let rectangleHeight = source.size.height * boundary.size.height
        context.setLineWidth(2)
        context.addRect(CGRect(x: boundary.origin.x * source.size.width, y:boundary.origin.y * source.size.height, width:
                                rectangleWidth, height: rectangleHeight))
        context.drawPath(using: CGPathDrawingMode.stroke)
        let highlightedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        DispatchQueue.main.async {
            self.imageView.image = highlightedImage
        }
    }
}
