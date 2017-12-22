//
//  EventViewController.swift
//  dDayList
//
//  Created by 지현 on 2017. 11. 30..
//  Copyright © 2017년 지현. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications
import EventKit

class EventViewController: UIViewController {
    
    var delegate:MainTableViewController!
    let units: Set<Calendar.Component> = [.day]
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var eventStore: EKEventStore?

    var d_day: Int = 0
  
    
    @IBOutlet var endDateTextField: UITextField!
    @IBOutlet var startDateTextField: UITextField!
    @IBOutlet var dateTextField: UITextField!
    @IBOutlet var titleName: UITextField!
    @IBOutlet var badgeSwitch: UISwitch!
    @IBOutlet var alarmSwitch: UISwitch!
    @IBOutlet var toggleView: UISwitch!
    
    @IBAction func dateSelection(_ sender: UITextField) {
        
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.date
        
        sender.inputView = datePickerView
        
        datePickerView.addTarget(self, action: #selector(EventViewController.datePickerValueChanged), for: UIControlEvents.valueChanged)
    }
   
    @IBAction func startDateSelection(_ sender: UITextField) {
        
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.date
        
        sender.inputView = datePickerView
        
        datePickerView.addTarget(self, action: #selector(EventViewController.datePickerValueChanged2), for: UIControlEvents.valueChanged)
        
    }
 
    @IBAction func endDateSelection(_ sender: UITextField) {
        
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.date
        
        sender.inputView = datePickerView
        
        datePickerView.addTarget(self, action: #selector(EventViewController.datePickerValueChanged3), for: UIControlEvents.valueChanged)
        
    }
    func datePickerValueChanged(sender:UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.none
        dateTextField.text = dateFormatter.string(from: sender.date)
       
    }
    func datePickerValueChanged2(sender:UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.none
        startDateTextField.text = dateFormatter.string(from: sender.date)
        
    }
    func datePickerValueChanged3(sender:UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.none
        endDateTextField.text = dateFormatter.string(from: sender.date)
        
    }
    
    @IBOutlet var subView: UIView!
    
    @IBAction func toggleView(_ sender: UISwitch) {
        self.subView.isHidden = !sender.isOn
    }
    
      override func viewDidLoad() {
        super.viewDidLoad()
        
        badgeSwitch.isOn = false
        
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: view.frame.size.height - 55, width: view.frame.size.width, height: 55))
        
        toolBar.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        toolBar.barStyle = UIBarStyle.blackTranslucent
        toolBar.tintColor = UIColor.white
        toolBar.backgroundColor = UIColor.black
     
        
        let todayBtn = UIBarButtonItem(title: "Today", style: UIBarButtonItemStyle.plain, target: self, action: #selector(EventViewController.tappedToolBarBtn))
        
        let okBarBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(EventViewController.donePressed))
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width / 3, height: self.view.frame.size.height))
        
        label.font = UIFont(name: "Helvetica", size: 12)
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.white
        label.text = "Select date"
        label.textAlignment = NSTextAlignment.center
        
        let textBtn = UIBarButtonItem(customView: label)
        
        toolBar.setItems([todayBtn,flexSpace,textBtn,flexSpace,okBarBtn], animated: true)

        dateTextField.inputAccessoryView = toolBar
        startDateTextField.inputAccessoryView = toolBar
        endDateTextField.inputAccessoryView = toolBar
        // Do any additional setup after loading the view.
        
        let application = UIApplication.shared
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in
            if granted { print("Approval granted to send notifications") }
            else { print(error!) }
        }
        application.registerForRemoteNotifications()
        
        
    
    }

    //배지 계산
    func calcDate() {
    
        let cal = Calendar(identifier:.gregorian)

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd."
        
        let today = Date()
        let todayy = dateFormatter.string(from: today)
        let todayyy = dateFormatter.date(from: todayy)
        
        let start = startDateTextField.text
        let startdate = dateFormatter.date(from: start!)
        
        let end = endDateTextField.text
        let enddate = dateFormatter.date(from: end!)
        
        if (startdate != nil && enddate != nil ) {
        let rest = cal.dateComponents([.day], from:startdate!, to:enddate!)
        let rest2 = cal.dateComponents([.day], from: startdate!, to: todayyy!)
        
        let rest3 = cal.dateComponents([.day], from: todayyy!, to: enddate!)
    
     
            
        print(rest.day!)
        
            if (rest2.day! > 0)
            {
            d_day = rest3.day!
            appDelegate.badge = String("\(d_day)")
            }
            else {
            d_day = 0
            appDelegate.badge = String("\(d_day)")
            }
        }
        
        
        
        var dateText = dateTextField.text
        let dateTextt = dateFormatter.date(from: dateText!)
        
        if (startdate == nil && enddate == nil ) {
       
            let rest = cal.dateComponents([.day], from:todayyy!, to:dateTextt!)
            
            //이후 날짜 입력
            if (rest.day! > 0) {
                d_day = rest.day!
            }
            //이전 날짜 입력
            else {
                d_day = (rest.day! - 1 ) * -1
            }
        }
        
        if self.eventStore == nil {
            self.eventStore = EKEventStore()
            self.eventStore!.requestAccess(to: EKEntityType.reminder, completion:
                {(isAccessible,errors) in })
        }
        
        let predicateForEvents:NSPredicate = self.eventStore!.predicateForReminders (in: [self.eventStore!.defaultCalendarForNewReminders()])
        
        self.eventStore!.fetchReminders(matching: predicateForEvents, completion: { (reminders) in
            for reminder in reminders! {
                if reminder.title == "Calli Alarm" {
                    do {
                        try self.eventStore!.remove(reminder, commit: true)
                    } catch {
                        
                    }
                }
            }
        })
        
        if alarmSwitch.isOn  {
            
            if toggleView.isOn {
            
                let reminder = EKReminder(eventStore: self.eventStore!)
                reminder.title = "D-day 입니다"
                reminder.calendar = self.eventStore!.defaultCalendarForNewReminders()
                
                
                let alarm = EKAlarm(absoluteDate: enddate!)
                reminder.addAlarm(alarm)
                
                do {
                    try self.eventStore!.save(reminder, commit: true)
                } catch {
                    NSLog("알람 설정 실패")
                }
            
            }
            
            else{
            let reminder = EKReminder(eventStore: self.eventStore!)
            reminder.title = "D-day 입니다"
            reminder.calendar = self.eventStore!.defaultCalendarForNewReminders()
            
          
            let alarm = EKAlarm(absoluteDate: dateTextt!)
            reminder.addAlarm(alarm)
                
                do {
                    try self.eventStore!.save(reminder, commit: true)
                } catch {
                    NSLog("알람 설정 실패")
                }
            }
            
            
        }
    

    
    }
    
    @IBAction func cancel(_ sender: Any) {
     
      dismiss(animated: true, completion: nil)
        
    }

    @IBAction func savePress(_ sender: UIBarButtonItem) {

            
        if ( (self.titleName.text != "" && self.startDateTextField.text != "" && self.endDateTextField.text != "" ) || ( self.titleName.text != "" && self.dateTextField.text != "" )   ){
        //1. context통해 얻어옴
        let context = getContext()
        let entity = NSEntityDescription.entity(forEntityName: "Dday", in: context)
        
        //2. 디스트립션통해 생성
        // friend record를 새로 생성함
        let object = NSManagedObject(entity: entity!, insertInto: context)
        object.setValue(startDateTextField.text, forKey: "startDate")
        object.setValue(endDateTextField.text, forKey: "endDate")
        object.setValue(dateTextField.text, forKey: "dateText")
        object.setValue(titleName.text, forKey: "title")
        object.setValue(Date(), forKey: "savedDate")
      
        
        do {
            //3. 진짜 디비에 저장
            try context.save()
            print("saved!")
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        }
            
        calcDate();
        
        if self.badgeSwitch.isOn {
            let application = UIApplication.shared
            application.applicationIconBadgeNumber = d_day
        }
            
            print("badge setting" + "\(d_day)" )
            dismiss(animated: true, completion: nil)
        }
       
        else {
            
            let alert = UIAlertController(title: "알림", message: "모두 입력해주세요!", preferredStyle: UIAlertControllerStyle.alert)
            
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler : nil )
            
            alert.addAction(okAction)
            
            present(alert, animated: true, completion: nil)
        }
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func donePressed(sender: UIBarButtonItem) {
        
        dateTextField.resignFirstResponder()
        startDateTextField.resignFirstResponder()
        endDateTextField.resignFirstResponder()
    }

    func tappedToolBarBtn(sender: UIBarButtonItem) {
        
        let dateformatter = DateFormatter()
        
        dateformatter.dateStyle = DateFormatter.Style.medium
        
        dateformatter.timeStyle = DateFormatter.Style.none
        
        dateTextField.text = dateformatter.string(from: NSDate() as Date)
        dateTextField.resignFirstResponder()
        startDateTextField.text = dateformatter.string(from: NSDate() as Date)
        startDateTextField.resignFirstResponder()
        endDateTextField.text = dateformatter.string(from: NSDate() as Date)
        endDateTextField.resignFirstResponder()
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
         self.view.endEditing(true)
    }
    
    func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
