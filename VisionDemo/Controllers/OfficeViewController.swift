//
//  OfficeViewController.swift
//  VisionDemo
//
//  Created by dexiong on 2023/12/7.
//

import UIKit
import WebKit

class OfficeViewController: UIViewController {
    
    private lazy var webView: WKWebView = {
        let webview: WKWebView = .init(frame: .zero)
        webview.navigationDelegate = self
        if #available(iOS 16.4, *) {
            webview.isInspectable = true
        } else {
            // Fallback on earlier versions
        }
        return webview
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(webView)
        webView.frame = view.bounds
        guard let url = Bundle.main.url(forResource: "本文档由中文文档库提供", withExtension: "doc") else { return }
        let req: URLRequest = .init(url: url)
        webView.load(req)

//        do {
//            let data = try Data(contentsOf: url)
//            let file = try DocFile(data: data)
//            print(file)
//        } catch {
//            print(error)
//        }
    }
    

}
extension OfficeViewController: WKNavigationDelegate {
    internal func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.evaluateJavaScript("document.documentElement.innerText") { text, error in
            print(text)
        }
    }
}
