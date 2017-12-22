//
//  MainTableViewController.swift
//  dDayList
//
//  Created by 지현 on 2017. 11. 30..
//  Copyright © 2017년 지현. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications


class MainTableViewController: UITableViewController {

    var dDay: [NSManagedObject] = []
    let application = UIApplication.shared
    let units: Set<Calendar.Component> = [.day]
    let notificationIdentifier = "myNotification"
    
    @IBAction func addButton(_ sender: UIBarButtonItem) {
        let newTabBarController = storyboard?.instantiateViewController(withIdentifier: "NewTabBarController") as! NewTabBarController
        
        present(newTabBarController, animated: true, completion: nil)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // "shared" returns the singleton app instance
        let application = UIApplication.shared
        let center = UNUserNotificationCenter.current()
        // Requests authorization to interact with the user
        // when local and remote notifications arrive
        center.requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in
            if granted { print("Approval granted to send notifications") }
            else { print(error!) } }
        application.registerForRemoteNotifications()
      
        //application.applicationIconBadgeNumber = 0
        
        
    }

   
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 100.0;//Choose your custom row height
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dDay.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Dday Cell", for: indexPath) as! CustomTableViewCell
        //let row = indexPath.row
        
        // Configure the cell...
        let dDay = self.dDay[indexPath.row]
        
        var start: String = ""
        if let startDate = dDay.value(forKey: "startDate") as? String {
            start = startDate
        }
     
        if let startValue = dDay.value(forKey: "start") as? String {
            start = startValue
        }
        
        var end: String = ""
        if let endDate = dDay.value(forKey: "endDate") as? String {
            end = endDate
        }
        
        if let endValue = dDay.value(forKey: "end") as? String {
            end = endValue
        }
        
        var date: String = ""
        if let dateDate = dDay.value(forKey: "dateText") as? String {
            date = dateDate
        }
        
        if let nowValue = dDay.value(forKey: "now") as? String {
            date = nowValue
        }
        
        var goall: String = ""
        if let goal = dDay.value(forKey: "goal") as? String {
            goall = goal
        }
        
     
    
        let cal = Calendar(identifier:.gregorian)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd."
        
        let startdate = dateFormatter.date(from: start)
        let enddate = dateFormatter.date(from: end)

        //오늘 날짜 받아오기
        
        let now = Date()
        let comp = cal.dateComponents([.year, .month, .day], from: now)
        var comp2 = DateComponents()
        (comp2.year, comp2.month, comp2.day) = (comp.year, comp.month, comp.day)
        let result = cal.date(from:comp2)!
        let today = result
        
        //테이블 셀에 나오는 부분
        cell.goal.text = goall
        
//        cell.startDate.text = start
//        cell.endDate.text=end
//        cell.percent.text=" "
//        cell.titleName.text = dDay.value(forKey: "title") as? String
      
        
        //기념일
        if (cell.goal.text == "" ) {
            
            cell.startDate.text = start
            cell.endDate.text=end
            cell.percent.text=" "
            cell.titleName.text = dDay.value(forKey: "title") as? String
    
            //기간설정 아님
            if (cell.startDate.text == "") && (cell.endDate.text == "") {
                
                //cell.startDate.text = date
                
                let setting = dateFormatter.date(from: date)
                
                var plusday = cal.dateComponents([.day], from: today, to: setting!)
                
                let dbDate: Date? = dDay.value(forKey: "savedDate") as? Date
                //오늘 날짜 이후 설정
                if (Float(plusday.day!) > 0) {
                    
                    let formatter: DateFormatter = DateFormatter()
                    formatter.dateFormat = "yyyy.MM.dd"
                    let todayy = formatter.string(from: now as Date)
               
                    cell.startDate.text=todayy
                    cell.endDate.text=date
                    
                    //오늘날 - 저장된날 
                    var restday = cal.dateComponents(units, from: dbDate!, to: today)
                    
                    if "\(plusday.day!)" == "0" {
                        cell.percent.text = "d-day!"
                 
                      
                    }
                    else{
                    cell.percent.text = "-"+"\(plusday.day!)" + "일"
                    }
                    cell.progressbar.setProgress( Float(restday.day!+1) /  Float(plusday.day!), animated: true)
                }
                //오늘 날짜 이전 설정
                else{
                    let formatter: DateFormatter = DateFormatter()
                    formatter.dateFormat = "yyyy.MM.dd"
                    let todayy = formatter.string(from: now as Date)
                    
                    cell.startDate.text=date
                    
                    //cell.endDate.text=todayy
                    
                    if "\(plusday.day! * -1 + 1)" == "0" {
                        cell.percent.text = "d-day!"
                

                       
                    }
                    else {
                    cell.percent.text = "+"+"\(plusday.day! * -1 + 1)" + "일"
                    }
                    cell.progressbar.setProgress( Float(plusday.day! * -1 + 1) /  Float(plusday.day!+500), animated: true)
                
                }
            }
            //기간설정
            else {
                
                let rest = cal.dateComponents([.day], from: startdate!, to: enddate!)
                print(rest.day!)
                
                var percent = cal.dateComponents([.day], from: today, to: startdate!)
                print(percent.day!)
                
                let restDay = cal.dateComponents([.day], from: today, to: enddate!)
                
                if (Float(percent.day!) < 0) {
                    percent.day! = percent.day! * -1
                }
                
                cell.progressbar.setProgress(Float(percent.day!+1) / Float(rest.day!), animated: true)
                if "\(restDay.day!)" == "0" {
                    cell.percent.text = "d-day!"
                    
             
                    
                }
                else{
                cell.percent.text = "-"+"\(restDay.day!)" + "일"
                }
            }
        
        }
        //목표인 경우
        else {
        
            cell.startDate.text = start
            cell.endDate.text=end
            cell.titleName.text = dDay.value(forKey: "title") as? String
            cell.progressbar.setProgress(Float((dDay.value(forKey: "now") as? String)!)! / Float(end)!, animated: true)
            cell.goal.text=" "
            cell.percent.text="\(Int((dDay.value(forKey: "now") as? String)!)! ) " + goall
        
        }
        
       
        
      
    
//        //이미지 추가
//        let cellIdentifier = "cell"
//        
//        var cell2 : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! UITableViewCell
//
//        var image : UIImage = UIImage(named: "osx_design_view_messages")!
//        //println("The loaded image: \(image)")
//        cell2.imageView?.image = image
      
        return cell
    }
    
    
    func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }

    // 나타날때마다 전체 다시 보여줌 : viewWillAppear
    // View가 보여질 때 자료를 DB에서 가져오도록 한다. 뷰가 나타나고 추가되는 효과(업데이트) 줄때 사용
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let context = self.getContext()
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Dday")
        
        //정렬
        let sortDescriptor = NSSortDescriptor (key: "savedDate", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        
        do {
            dDay = try context.fetch(fetchRequest) //해당 패치 정보가 담겨있는거 가져옴
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        
        
        self.tableView.reloadData()
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            // Core Data 내의 해당 자료삭제(실제 데베 속 자료삭제)
            let context = getContext()
            context.delete(dDay[indexPath.row])
            do {
                try context.save()
                print("deleted!")
            } catch let error as NSError {
                print("Could not delete \(error), \(error.userInfo)")
            }
            
            // 배열에서 해당 자료 삭제
            dDay.remove(at: indexPath.row)
            
            // 테이블뷰 Cell 삭제
            tableView.deleteRows(at: [indexPath], with: .fade)
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let application = UIApplication.shared
            if appDelegate.badge == nil {
            appDelegate.badge = ""
            }
            application.applicationIconBadgeNumber = Int(appDelegate.badge!)!

        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    override func prepare (for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "toDetailView" {
            if let destination = segue.destination as? DetailViewController {
               
                if let selectedIndex = self.tableView.indexPathsForSelectedRows?.first?.row {
                    destination.detaildDay = dDay[selectedIndex]
                }
        }
    }


    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
}
