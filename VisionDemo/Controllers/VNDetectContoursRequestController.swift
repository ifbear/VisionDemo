//
//  VNDetectContoursRequestController.swift
//  VisionDemo
//
//  Created by dexiong on 2023/12/7.
//  图形轮廓

import UIKit
import Vision

class VNDetectContoursRequestController: UIViewController {

    @IBOutlet private var imageView: UIImageView!
    
    /// cgImage
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
            self.contours()
        }
        
    }
    private func contours() {
        if #available(iOS 14.0, *) {
            let request = VNDetectContoursRequest { [weak self] request, error in
                guard let this = self else { return }
                guard let results = request.results as? [VNContoursObservation] else { return }
                DispatchQueue.main.async { [weak this] in
                    guard let this = this else { return }
                    results.forEach { contoursObservation in
                        this.imageView.image = this.drawContours(contoursObservation: contoursObservation)
                    }
                }
            }
            guard let cgimage = cgImage else { return }
            let handler = VNImageRequestHandler(cgImage: cgimage, options: [:])
            try? handler.perform([request])
        }
    }
    
    @available(iOS 14.0, *)
    func drawContours(contoursObservation: VNContoursObservation) -> UIImage {
        guard let sourceImage = cgImage else { return .init() }
        let size = CGSize(width: sourceImage.width, height: sourceImage.height)
        let renderer = UIGraphicsImageRenderer(size: size)
        
        let renderedImage = renderer.image { (context) in
            let renderingContext = context.cgContext
            
            let flipVertical = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: size.height)
            renderingContext.concatenate(flipVertical)
            //renderingContext.draw(sourceImage, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            
            renderingContext.scaleBy(x: size.width, y: size.height)
            renderingContext.setLineWidth(5.0 / CGFloat(size.width))
            let redUIColor = UIColor.lightGray
            renderingContext.setStrokeColor(redUIColor.cgColor)
            renderingContext.addPath(contoursObservation.normalizedPath)
            renderingContext.strokePath()
        }
        return renderedImage
    }

}
