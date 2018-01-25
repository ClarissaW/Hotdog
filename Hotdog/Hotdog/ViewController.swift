//
//  ViewController.swift
//  test
//
//  Created by Wang, Zewen on 2018-01-25.
//  Copyright © 2018 Wang, Zewen. All rights reserved.
//

import UIKit
import VisualRecognitionV3

class ViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    let apiKey = "711fbc31b523ebc2e73cf41e162251688da3c1ed"
    let version = "2018-01-25"
    var classificationResults : [String] = []
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var imageView: UIImageView!
    let imagePicker = UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            imageView.image = image
            imagePicker.dismiss(animated: true, completion: nil)
            let visualRecognition = VisualRecognition(apiKey: apiKey, version: version)
            let imageData = UIImageJPEGRepresentation(image, 0.01) // downsize the image
            let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let fileURL = documentURL.appendingPathComponent("tempImage.jpg")
            try? imageData?.write(to: fileURL, options: [])
            visualRecognition.classify(imageFile: fileURL, success: { (classifiedImages) in
                //print(classifiedImages)
                let classes = classifiedImages.images.first!.classifiers.first!.classes
                for index in 0..<classes.count{
                    self.classificationResults.append(classes[index].classification)
                }
                print(self.classificationResults)
            })
            
        }else{
            print("There was an error")
        }
    }

    @IBAction func cameraButtonPressed(_ sender: UIBarButtonItem) {
        imagePicker.sourceType = .savedPhotosAlbum
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)
    }
    
}

