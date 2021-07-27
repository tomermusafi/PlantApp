//
//  WaterViewController.swift
//  PlantApp2
//
//  Created by user196209 on 7/27/21.
//

import Photos
import FirebaseStorage
import Firebase
import FirebaseStorageUI
import UIKit

class WaterViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var plants = [Plant]()
    var allPlants = [Plant]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        plants = getPlants()
        tableView.delegate = self
        tableView.dataSource = self

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
     super.viewWillAppear(true)
     self.tableView.reloadData()
         
     }
    
    func getPlants() -> [Plant]{
        let userDefault = UserDefaults.standard
        if let plants = userDefault.data(forKey: "plants"){
            let decoder = JSONDecoder()
            let tempArr = try! decoder.decode([Plant].self, from: plants)
            allPlants = tempArr
            var arrFilter = [Plant]()
            for p in tempArr {
                let diff = calculateDate(lastWaterDate: p.getWaterHistory().last!)
                let green = p.getWaterF() * 1
                print(diff)
                if(diff >= green ){
                    arrFilter.append(p)
                }
            }
            return arrFilter
        }else{
            return []
        }
    }
    
    func calculateDate(lastWaterDate:String) -> Int{
        print(lastWaterDate)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let date = dateFormatter.date(from: lastWaterDate)!
        let currentDate = Date()
        print(date)
        print(currentDate)
        let diff = Calendar.current.dateComponents([.day], from: date,to: currentDate).day!
        return diff
    }
    
    @objc func didButtoonClick(_ sender: UIButton){
        print("hello")
        let btnTag = sender.tag
        let currentDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        let stDate = formatter.string(from: currentDate)
        var history = plants[btnTag].getWaterHistory()
        history.append(stDate)
        //plants[btnTag].setWaterHistory(waterHistory: history)
        allPlants.filter({$0.getId() == plants[btnTag].getId()}).first?.setWaterHistory(waterHistory: history)
        
        let jsonEncoder = JSONEncoder()
        let jsonData = try! jsonEncoder.encode(allPlants)
        let user = UserDefaults.standard
        user.set(jsonData,forKey: "plants")
        print("-----\(plants.count)")
        plants = getPlants()
        self.tableView.reloadData()
    }

    

}
extension WaterViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension WaterViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return plants.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! WaterTableViewCell
        let plantsList:[Plant] = plants
        cell.plantName.text = plantsList[indexPath.row].getName()
        cell.plantWaterBTN.addTarget(self, action: #selector(didButtoonClick(_:)), for: .touchUpInside)
        cell.plantWaterBTN.tag = indexPath.row
        
        let diff = calculateDate(lastWaterDate: plantsList[indexPath.row].getWaterHistory().last!)
        let green = plantsList[indexPath.row].getWaterF() * 1
        let orange = plantsList[indexPath.row].getWaterF() * 2
        let red = plantsList[indexPath.row].getWaterF() * 3
        
        if(diff >= green){
            cell.backgroundColor = .green
        }
        if(diff >= orange){
            cell.backgroundColor = .orange
        }
        if(diff >= red){
            cell.backgroundColor = .red
        }
        
        
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let ref = storageRef.child(plantsList[indexPath.row].getId())
        
        cell.plantImage.sd_setImage(with: ref)
    

        
        return cell
    }
}
