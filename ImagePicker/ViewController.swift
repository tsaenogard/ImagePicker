//
//  ViewController.swift
//  ImagePicker
//
//  Created by XCODE on 2017/5/8.
//  Copyright © 2017年 Gjun. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var imageView: UIImageView!
    var button: UIButton!
    
    let defaultImage = UIImage(named: "add_image")

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let x: CGFloat = 40
        let y: CGFloat = 200
        let w = UIScreen.main.bounds.width - x * 2
        let h = w * 9 / 16
        let rect = CGRect(x: x, y: y, width: w, height: h)
        
        self.imageView = UIImageView(image: self.defaultImage)
        self.imageView.frame = rect
        self.imageView.contentMode = .scaleAspectFit
        self.imageView.clipsToBounds = true
        self.imageView.layer.cornerRadius = 8.0
        self.imageView.layer.borderColor = UIColor(red: 18 / 255, green: 73 / 255, blue: 158 / 255, alpha: 1.0).cgColor
        self.imageView.layer.borderWidth = 1.0
        self.imageView.layer.shadowColor = UIColor.black.cgColor
        self.imageView.layer.shadowRadius = 2.0
        self.imageView.layer.shadowOpacity = 0.85
        self.imageView.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.view.addSubview(self.imageView)
        
        self.button = UIButton(frame: rect)
        self.button.addTarget(self, action: #selector(self.onButtonAction), for: .touchUpInside)
        self.view.addSubview(self.button)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func onButtonAction() {
        if self.imageView.image == self.defaultImage {
            // 開啟相機或相簿
            let alert = UIAlertController(title: nil, message: "請選擇圖片來源", preferredStyle: .actionSheet)
            let camera = UIAlertAction(title: "相機", style: .default, handler: { (alert) in
                let picker = UIImagePickerController()
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    picker.sourceType = .camera
                } else {
                    Utilities.sharedInstance.toast(taget: self, message: "裝置不支援相機功能")
                    return
                }
                picker.delegate = self
                picker.allowsEditing = true
                self.present(picker, animated: true, completion: nil)
            })
            alert.addAction(camera)
            let album = UIAlertAction(title: "相簿", style: .default, handler: { (alert) in
                let picker = UIImagePickerController()
                if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                    picker.sourceType = .photoLibrary
                } else {
                    Utilities.sharedInstance.toast(taget: self, message: "裝置不支援相簿功能")
                    return
                }
                picker.delegate = self
                picker.allowsEditing = true
                self.present(picker, animated: true, completion: nil)
            })
            alert.addAction(album)
            let cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            alert.addAction(cancel)
            alert.popoverPresentationController?.sourceView = self.imageView
            alert.popoverPresentationController?.sourceRect = CGRect(x: 0, y: 0, width: 1, height: 1)
            self.present(alert, animated: true, completion: nil)
        } else {
            // 刪除圖片，其實就只是換回defaultImage
            Utilities.sharedInstance.showAlertView(message: "是否要刪除圖片", target: self, confirmHandler: { (alsert) in
                self.imageView.image = self.defaultImage
            })
        }
    }
    
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerControllerEditedImage] as? UIImage else { return }
        DispatchQueue.main.async {
            self.imageView.image = image
        }
    }
    
}











