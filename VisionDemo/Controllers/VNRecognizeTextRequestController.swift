//
//  VNRecognizeTextRequestController.swift
//  VisionDemo
//
//  Created by dexiong on 2023/12/7.
//  文字识别

import UIKit
import Vision

class VNRecognizeTextRequestController: UIViewController {
    @IBOutlet private weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.global().async {
            self.recognizeText()
        }
    }
    
    private func recognizeText() {
        let imageNames = ["2.png"]// "1.png", "2.png", "3.png", "4.png", "5.png", "6.png", "7.png", "8.png", "9.png", "10.png", "11.png", "12.png", "13.png"
        imageNames.forEach { name in
            let request = VNRecognizeTextRequest { [weak self] request, error in
                guard let this = self else { return }
                guard let observations = request.results as? [VNRecognizedTextObservation] else { return }
                let text = observations.compactMap { $0.topCandidates(1).first?.string }.joined()
                DispatchQueue.main.async { [weak this] in
                    guard let this = this else { return }
                    this.textView.text.append(text)
                    this.textView.text.append("\n\n\n\n")
                }
            }
            request.progressHandler = { _, progress, _ in
                print(progress)
            }
            request.recognitionLevel = .accurate
            if #available(iOS 16.0, *) {
                request.automaticallyDetectsLanguage = true
            }
            guard let cgImage = UIImage(named: name)?.cgImage else { return }
            let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            try? handler.perform([request])
        }
    }
    
}
