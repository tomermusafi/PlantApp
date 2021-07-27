//
//  AddPlantViewController.swift
//  PlantApp2
//
//  Created by user196209 on 7/24/21.
//
import FirebaseDatabase
import Photos
import FirebaseStorage
import Firebase
import UIKit

class AddPlantViewController: UIViewController {

    
    @IBOutlet weak var plantName: UITextField!
    
    @IBOutlet weak var plantDescription: UITextField!
    
    @IBOutlet weak var plantWaterF: UITextField!
    
    @IBOutlet weak var savePlant: UIButton!
    
    @IBOutlet weak var plantImage: UIImageView!
    
    var url: URL!
    
    private let database = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)

        
    }
    
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
    @IBAction func imageClicked(){
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    func uploadImage(id:String){
        let storage = Storage.storage()
        let data = Data()
        let storageRef = storage.reference()
        let localFile = url!
        let photoRef = storageRef.child(id)
        let uploadTask = photoRef.putFile(from: localFile, metadata: nil){(metadata, err) in
            guard let metadata = metadata else {
                return
            }
            print("sssss")
        }
    }
    
    @IBAction func save(){
        let id1 = NSUUID().uuidString
        let name1 = plantName.text!
        let description1 = plantDescription.text!
        let waterF1 = Int(plantWaterF.text ?? "0")!
        let plant: Plant = Plant(id: id1, name: name1, description: description1, waterF: waterF1, imageUrl: url.absoluteString)
        
        uploadImage(id: id1)
    
        
        var plants = getPlants()
        plant.setWaterHistory(waterHistory: ["07/20/2021"])
        plants.append(plant)
        
        var userId = UIDevice.current.identifierForVendor!.uuidString
        let customPlant = ["id":plant.getId(),"name":plant.getName(), "description":plant.getDescription(),"waterF": plant.getWaterF(),"imageUrl":plant.getImageUrl(),"waterHistory":plant.getWaterHistory()] as [String : Any]
        database.child(userId).child(plant.getId()).setValue(customPlant)
        
            let jsonEncoder = JSONEncoder()
            let jsonData = try! jsonEncoder.encode(plants)
            let user = UserDefaults.standard
            user.set(jsonData,forKey: "plants")
        
        print(plants)
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
        
    }
    
    func getPlants() -> [Plant]{
        let userDefault = UserDefaults.standard
        if let plants = userDefault.data(forKey: "plants"){
            let decoder = JSONDecoder()
            return try! decoder.decode([Plant].self, from: plants)
        }else{
            return []
        }
    }

}
extension AddPlantViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage{
            plantImage.image = image
            
            if let imageUrl = info[UIImagePickerController.InfoKey.imageURL] as? URL{
                url = imageUrl
            print(imageUrl)
            }
            
        }
        picker.dismiss(animated: true, completion: nil)
            

    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
            
        
    }
    
}
