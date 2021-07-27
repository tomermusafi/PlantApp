//
//  DateViewController.swift
//  PlantApp2
//
//  Created by user196209 on 7/26/21.
//
import Photos
import FirebaseStorage
import Firebase
import FirebaseStorageUI
import UIKit

class DateViewController: UIViewController {

    @IBOutlet weak var myDatePicker: UIDatePicker!
    
    @IBOutlet weak var tableView: UITableView!
    
    var pickedDate: String!
    var plants = [Plant]()
    override func viewDidLoad() {
        super.viewDidLoad()

        myDatePicker.addTarget(self, action: #selector(datePickerValueChanged(sender:)), for: UIControl.Event.valueChanged)
        let currentDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        pickedDate = formatter.string(from: currentDate)
        plants = getPlants()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
     super.viewWillAppear(true)
     plants = getPlants()
     self.tableView.reloadData()
         
     }
    
    @objc func datePickerValueChanged(sender: UIDatePicker){
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        let stDate = formatter.string(from: sender.date)
        //print(stDate)
        pickedDate = stDate
        plants = getPlants()
        print(plants.count)
        self.tableView.reloadData()
        
    }
    
    func getPlants() -> [Plant]{
        let userDefault = UserDefaults.standard
        if let plants = userDefault.data(forKey: "plants"){
            let decoder = JSONDecoder()
            let tempArr = try! decoder.decode([Plant].self, from: plants)
            var arrFilter = [Plant]()
            for p in tempArr {
                print(p.getWaterHistory())
                if((p.getWaterHistory().firstIndex(of: pickedDate)) != nil){
                    arrFilter.append(p)
                }
            }
            return arrFilter
        }else{
            return []
        }
    }

    

}

extension DateViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension DateViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(plants.count + 100)
        return plants.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell3", for: indexPath) as! DateTableViewCell
        let plantsList:[Plant] = plants
        cell.plantName.text = plantsList[indexPath.row].getName()
        cell.lastWater.text = "Last Water: \(plantsList[indexPath.row].getWaterHistory().last!)"
        
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
        
        return cell
    }
}
