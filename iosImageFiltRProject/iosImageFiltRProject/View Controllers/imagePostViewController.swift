//
//  ImagePostViewController.swift
//  ImageFilterEditR
//
//  Created by BrysonSaclausa on 10/27/20.
//
import UIKit
import CoreImage
import CoreImage.CIFilterBuiltins
import Photos


class ImagePostViewController: UIViewController {
    
    //MARK: - IBOUTLETS
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var slider1: UISlider!
    @IBOutlet weak var slider2: UISlider!
    @IBOutlet weak var slider3: UISlider!
    @IBOutlet weak var segmentedControl1: UISegmentedControl!
    
    var originalImage: UIImage? {
        didSet {
            updateImage()
        }
    }
    
    private let context = CIContext()
    private let filter = CIFilter.colorControls()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        originalImage = imageView.image
//        introspecting the attributes of filter
//        let filter = CIFilter.gaussianBlur()
//        print(filter.attributes)
        
    }
    
    //MARK: - FUNCTIONS
    
    private func presentImagePickerController() {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            print("The photo library is not available.")
            return
        }
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    private func image(byFilterimg image: UIImage) -> UIImage {
        let inputImage = CIImage(image: image)
        
        filter.inputImage = inputImage
        filter.saturation = slider1.value
        filter.brightness = slider2.value
        filter.contrast = slider3.value
        
        
        guard let outputImage = filter.outputImage else { return image }
        
        guard let renderedImage = context.createCGImage(outputImage, from: outputImage.extent) else {
            return image }
        
        return UIImage(cgImage: renderedImage)
    }
    
    private func updateImage() {
        if let originalImage = originalImage {
            imageView.image = image(byFilterimg: originalImage)
        } else {
            imageView.image = nil
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: - IBACTIONS
    
    @IBAction func choosePhotoButtonTapped(_ sender: Any) {
        presentImagePickerController()
    }
    
    
    @IBAction func slider1Changed(_ sender: Any) {
        updateImage()
    }
    @IBAction func slider2Changed(_ sender: Any) {
        updateImage()
    }
    @IBAction func slider3Changed(_ sender: Any) {
        updateImage()
    }
    
}

extension ImagePostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.editedImage] as? UIImage {
            originalImage = image
        } else if let image = info[.originalImage] as? UIImage {
            originalImage = image
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}
