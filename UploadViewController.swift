//
//  UploadMultipart.swift
//  DownloadInBGSession
//
//  Created by Karthik on 02/02/21.
//

import Foundation
import UIKit
import Alamofire

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true, completion: nil)
        
        imageView.image = info[.originalImage] as? UIImage
        
        let imageData = (imageView.image?.jpegData(compressionQuality: 0.8))!
        
        // https://stackoverflow.com/a/40521003
    
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(imageData, withName: "uploaded_file", fileName: "test.jpg", mimeType: "image/jpg")
        }, to: "https://mz-main-makzan.c9.io/php-upload-demo/upload.php") { (result) in
            switch result {
            case .success(let upload, _, _):
                upload.uploadProgress(closure: { (progress) in
                    print("Upload Progress: \(progress.fractionCompleted)")
                })
                
                upload.responseJSON { response in
                    print("Success")
                    print(response.result.value)
                }
                
            case .failure(let encodingError):
                print("Error")
                print(encodingError)
            }
        }
        
        
    }


}
