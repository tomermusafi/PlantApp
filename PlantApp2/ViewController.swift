//
//  ViewController.swift
//  PlantApp2
//
//  Created by user196209 on 7/2/21.
//

import FirebaseDatabase
import Photos
import FirebaseStorage
import Firebase
import FirebaseStorageUI
import UIKit

class ViewController: UIViewController {
    
    private let database = Database.database().reference()

    @IBOutlet var tableView: UITableView!
    
    var plants = [Plant]()
  
    override func viewDidLoad() {
        super.viewDidLoad()
        plants = getPlants()
        tableView.delegate = self
        tableView.dataSource = self
        
        
        let object: [String:Any] = ["name":"tomer" as NSObject, "ggg":"jdsak"]
        //database.child("something").setValue(object)
        
        
        
    }
    
    func getAllPlants(){
        var userId = UIDevice.current.identifierForVendor!.uuidString
        
        database.child(userId).observeSingleEvent(of: .value, with: {snapshot in
            guard let value = snapshot.value as? [String:Any] else{
                return
            }
            print("value: \(value.values)")
            
        })
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
   override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
    plants = getPlants()
    self.tableView.reloadData()
        
    }
    
    


}

extension ViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return plants.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MyHomeTableViewCell
        let plantsList:[Plant] = plants
        cell.plantDescription.text = plantsList[indexPath.row].getDescription()
        cell.plantName.text = plantsList[indexPath.row].getName()
        cell.plantWater.text = String(plantsList[indexPath.row].getWaterF())
        
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let ref = storageRef.child(plantsList[indexPath.row].getId())
        
        cell.plantImage.sd_setImage(with: ref)
        
//        if let data = try? Data(contentsOf: URL(string:plantsList[indexPath.row].getImageUrl())!){
//            if let image = UIImage(data: data){
//                DispatchQueue.main.async {
//                    cell.plantImage?.image = image
//                }
//            }
//        }
        
      
        
//        cell.plantImage.image = UIImage(contentsOfFile: plantsList[indexPath.row].getImageUrl())
        return cell
    }
}

