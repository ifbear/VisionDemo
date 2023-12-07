//
//  PDFKitViewController.swift
//  VisionDemo
//
//  Created by dexiong on 2023/12/7.
//

import UIKit
import PDFKit

class PDFKitViewController: UIViewController {
    
    private lazy var pdfView: PDFView = {
        let _view: PDFView = .init(frame: .zero)
        _view.autoScales = true
        return _view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(pdfView)
        
        
        guard let url = Bundle.main.url(forResource: "2023_PDF", withExtension: "pdf") else { return }
        let document = PDFDocument.init(url: url)
        pdfView.document = document
//        print(pdfView.currentPage?.string)
//        print(document?.string)
        
        if let attributes = document?.documentAttributes, let title = attributes[kCGPDFOutlineTitle as String] as? String {
            print(title)
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        pdfView.frame = view.bounds
    }


}
