//
//  VNClassifyImageRequestController.swift
//  VisionDemo
//
//  Created by dexiong on 2023/12/7.
//  图片分类

import UIKit
import Vision

class VNClassifyImageRequestController: UIViewController {
    
    @IBOutlet private var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.global().async {
            self.classifyImage()
        }
    }
    
    private func classifyImage() {
        // 图片分类
        let handler = VNClassifyImageRequest { [unowned self] request, error in
            guard let results = (request.results as? [VNClassificationObservation]) else { return }
            // 按识别进度筛选结果
//            results = results.filter({ $0.hasMinimumPrecision(0.5, forRecall: 0.7) })
            let text = results.map(\.identifier).joined(separator: "\n")
            DispatchQueue.main.async { [unowned self] in
                self.textView.text = text
            }
            //print(results.map(\.identifier).joined(separator: "|")) // adult_cat|animal|cat|feline|mammal|clothing|headgear
        }
        guard let cgimage = UIImage(named: "cat.png")?.cgImage else { return }
        let request = VNImageRequestHandler(cgImage: cgimage)
        
        try? request.perform([handler])
        
    }
    
    
}
