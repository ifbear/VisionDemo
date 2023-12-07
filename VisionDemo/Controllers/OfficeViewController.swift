//
//  OfficeViewController.swift
//  VisionDemo
//
//  Created by dexiong on 2023/12/7.
//

import UIKit
import OfficeFileReader


class OfficeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let url = Bundle.main.url(forResource: "本文档由中文文档库提供", withExtension: "doc") else { return }
        do {
            let data = try Data(contentsOf: url)
            let file = try DocFile(data: data)
            print(file)
        } catch {
            print(error)
        }
    }
    

}
