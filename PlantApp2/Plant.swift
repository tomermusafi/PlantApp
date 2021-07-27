//
//  Plant.swift
//  PlantApp2
//
//  Created by user196209 on 7/24/21.
//

import Foundation

public class Plant: Codable{
    private var id:String!
    private var name:String!
    private var description:String!
    private var waterF:Int!
    private var imageUrl:String!
    private var waterHistory:[String]!
    
    init(id:String, name:String, description:String, waterF:Int, imageUrl:String) {
        self.id = id
        self.name = name
        self.description = description
        self.waterF = waterF
        self.imageUrl = imageUrl
        self.waterHistory = [String]()
        let date = Date()
        let formatter = DateFormatter()
        formatter.timeZone = .current
        formatter.locale = .current
        formatter.dateFormat = "MM/dd/yyyy"
        
        self.waterHistory.append(formatter.string(from: date))
    }
    
    init(){
        self.waterHistory = [String]()
    }
    
    func getId() -> String{
        return self.id
    }
    
    func  setID(id: String){
        self.id = id
    }
    
    func getName() -> String{
        return self.name
    }
    
    func setName(name: String){
        self.name = name
    }
    
    func getWaterF() -> Int{
        return self.waterF
    }
    
    func setWaterF(watreF : Int){
        self.waterF = watreF
    }
    
    func getDescription() -> String{
        return self.description
    }
    
    func setDescription(description : String){
        self.description = description
    }
    
    func getImageUrl() -> String{
        return self.imageUrl
    }
    
    func setImageUrl(imageUrl: String){
        self.imageUrl = imageUrl
    }
    
    func getWaterHistory() -> [String]{
        return self.waterHistory
    }
    
    func setWaterHistory(waterHistory:[String]){
        self.waterHistory = waterHistory
    }
    
    func insertLastWater(date :String){
        self.waterHistory.append(date)
    }
    
    func getLastWater() -> String{
        return self.waterHistory.last ?? "none"
    }
}
