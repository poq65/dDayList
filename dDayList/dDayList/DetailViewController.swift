//
//  DetailViewController.swift
//  dDayList
//
//  Created by 지현 on 2017. 11. 30..
//  Copyright © 2017년 지현. All rights reserved.
//

import UIKit
import CoreData

class DetailViewController: UIViewController {

    var detaildDay: NSManagedObject?
    //var restday : String?
    
    @IBOutlet var type1: UILabel!
    @IBOutlet var type2: UILabel!
    @IBOutlet var type3: UILabel!
    @IBOutlet var titleName: UILabel!
    @IBOutlet var starting: UILabel!
    @IBOutlet var ending: UILabel!
    @IBOutlet var pass: UILabel!
    @IBOutlet var left: UILabel!
    @IBOutlet var today: UILabel!
    @IBOutlet var startDate: UILabel!
    @IBOutlet var endDate: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        if let dDay = detaildDay {
            
            let now = Date()
      
            let units: Set<Calendar.Component> = [.day]
           
            
            var calendar = NSCalendar.current

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy. MM. d."
            let todayy = dateFormatter.string(from: now as Date)
        
            self.today.text  = todayy
        
            let dbDate: Date? = dDay.value(forKey: "savedDate") as? Date
            
            //기념일
            if (dDay.value(forKey: "goal") == nil ) {
            
                
                
                var start: String = ""
                if let startDate = dDay.value(forKey: "startDate") as? String {
                    start = startDate
                }
                
                var end: String = ""
                if let endDate = dDay.value(forKey: "endDate") as? String {
                    end = endDate
                }
                
                titleName.text = dDay.value(forKey: "title") as? String
                startDate.text = dDay.value(forKey: "startDate") as? String
                endDate.text = dDay.value(forKey: "endDate") as? String
                type1.isHidden = true
                type2.isHidden = true
                type3.isHidden = true
        
             
                
                
                //날짜 지정
                if ( (dDay.value(forKey: "startDate") as? String == "" ) && (dDay.value(forKey: "endDate") as? String == "" ) && (dDay.value(forKey: "dateText") as? String != "" )){
            
                    var date: String = ""
                    if let dateDate = dDay.value(forKey: "dateText") as? String {
                        date = dateDate
                    }
                  
                    let setting = dateFormatter.date(from: date)
                   
                    
                    let comps = Calendar.current.dateComponents(units, from: now, to: setting as Date!)
                    
                
                    if (Float(comps.day!) <= 0) {
                        
                        let comps = Calendar.current.dateComponents(units, from: setting!, to: now)
                        if (comps.day! < 100){
                        let comps2 = setting?.addingTimeInterval(86400*100)
                        let comps22 = Calendar.current.dateComponents(units, from: now, to: comps2!)
                            
                            left.text = String(comps22.day!) + "일 남았어요"
                            ending.text="100일 까지"
                        }
                        else if (comps.day! < 200) {
                            
                            let comps2 = setting?.addingTimeInterval(86400*200)
                            let comps22 = Calendar.current.dateComponents(units, from: now, to: comps2!)
                            
                            left.text = String(comps22.day!) + "일 남았어요"
                            ending.text="200일 까지"
                            
                        
                        }
                        else if (comps.day! < 300) {
                        
                            let comps2 = setting?.addingTimeInterval(86400*300)
                            let comps22 = Calendar.current.dateComponents(units, from: now, to: comps2!)
                            
                            left.text = String(comps22.day!) + "일 남았어요"
                            ending.text="300일 까지"

                        
                        }
                        else {
                        
                        ending.isHidden=true
                        left.isHidden=true
                        
                        }
                        
                        
                    startDate.text = dDay.value(forKey: "dateText") as! String
                    endDate.text = ""
                    pass.text = String(comps.day! + 1) + "일 지났어요"
                   
                    type1.isHidden = true
                    type2.isHidden = true
                    type3.isHidden = true
          
                        
                    }
                    else {
                    
                        endDate.text = dDay.value(forKey: "dateText") as! String
                        let saveDate = dateFormatter.string(from: dbDate!)
                        if let unwrapDate = dbDate {
                            let displayDate = dateFormatter.string(from: unwrapDate as Date)
                             startDate.text = saveDate
                        }
                        let comps = Calendar.current.dateComponents(units, from: now, to: setting!)
                        let comps2 = Calendar.current.dateComponents(units, from: dbDate as! Date, to: now)
                        pass.text = String(comps2.day! + 1)+"일 지났어요"
                        left.text = String(comps.day! + 1 )+"일 남았어요"
                        type1.isHidden = true
                        type2.isHidden = true
                        type3.isHidden = true
                       
                    
                    
                    }
                }
                    
                    else {
                    
                        let statSetting = dateFormatter.date(from: start)
                        let endSetting = dateFormatter.date(from: end)
                        
                        let passs = Calendar.current.dateComponents(units, from: statSetting!, to: now)
                    print("\(passs.day!)"+"mmmmmmmmmmmm")
                    
                         self.pass.text = String( (passs.day! * -1) - 1 ) + " 일 남았어요"
                    if passs.day! < 0
                    { self.starting.isHidden = true
                      self.pass.text = "시작 전"}
                    else if self.startDate.text == todayy {
                        self.starting.isHidden = true
                        self.pass.text = "시작"
                    }
                    else  {
                    self.pass.text = String(passs.day! + 1 ) + " 일 지났어요"
                    }
                        let leftt = Calendar.current.dateComponents(units, from: now, to: endSetting!)
                    
                    if endDate.text == todayy {
                        
                         self.left.text = "0" + " 일 남았어요"
                        
                    
                    }
                    else if leftt.day! < 0 {
                        self.ending.isHidden = true
                        self.left.text = "종료"
                    
                    }
                    else {
                        self.left.text = String(leftt.day! + 1) + " 일 남았어요"
                    }
                    
                    
                    
                    }
                
            }
                
            //목표
            else {
            
                titleName.text = dDay.value(forKey: "title") as? String
                startDate.text = dDay.value(forKey: "start") as? String
                endDate.text = dDay.value(forKey: "end") as? String
                self.today.text = dDay.value(forKey: "now") as? String
                let endd = Int((dDay.value(forKey: "end") as? String)!)
                let noww = Int((dDay.value(forKey: "now") as? String)!)
                let leftt = endd! - noww!
                left.text = String(leftt)
                pass.isHidden = true
                starting.isHidden = true
                var goal : String = ""
                goal = (dDay.value(forKey: "goal") as? String)!
                type1.text = "[ " + goal + " ]"
                type2.text = dDay.value(forKey: "goal") as? String
                type3.text = dDay.value(forKey: "goal") as? String
                
            
            }
            
            
        }

    }
    
   
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
