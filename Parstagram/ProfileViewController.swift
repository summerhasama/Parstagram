//
//  ProfileViewController.swift
//  Parstagram
//
//  Created by Summer Hasama on 10/29/20.
//

import UIKit
import AlamofireImage
import Parse

class ProfileViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let username = PFUser.current()?["username"] as! String
        usernameLabel.text = username
        
        
        // Do any additional setup after loading the view.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let objectId = PFUser.current()!.objectId! as String
        let query = PFQuery(className:"Profile")
        query.whereKey("user", equalTo:PFUser.current()?["username"] as! String)
        
        query.findObjectsInBackground { (profile, error) in
            if profile != nil{
                if profile?.isEmpty != true{
                    let imageFile = profile?[0]["image"] as! PFFileObject
                    let urlString = imageFile.url!
                    let url = URL(string: urlString)!
                
                    self.imageView.af_setImage(withURL: url)
                }
            }
        }
        
    }
    
    
    
    
    
    @IBAction func onSaveButton(_ sender: Any) {
        let user = PFUser.current()?["username"]

        let profile = PFObject(className:"Profile")
        
        profile["user"] = user
        
        print(imageView.image!)
        
        let imageData = imageView.image!.pngData()
        let file = PFFileObject(data: imageData!)
        
        profile["image"] = file
        
        profile.saveInBackground { (success, error) in
            if success{
                self.dismiss(animated: true, completion: nil)
                print("saved")
            }else{
                print("error")
            }
        }
        
        
        
    }
    
    
    @IBAction func onCameraButton(_ sender: Any) {
        print("tapped image")
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            picker.sourceType = .camera
        }else{
            picker.sourceType = .photoLibrary
        }
        
        present(picker,animated:true, completion:nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.editedImage] as! UIImage
        let size = CGSize(width: 300, height: 300)
        let scaledImage = image.af_imageAspectScaled(toFill: size)
        
        imageView.image = scaledImage
        
        dismiss(animated: true, completion: nil)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
