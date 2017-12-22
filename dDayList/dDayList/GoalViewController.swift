//
//  GoalViewController.swift
//  dDayList
//
//  Created by 지현 on 2017. 11. 30..
//  Copyright © 2017년 지현. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

class GoalViewController: UIViewController {


    @IBOutlet var titleName: UITextField!
    @IBOutlet var startGoal: UITextField!
    @IBOutlet var nowGoal: UITextField!
    @IBOutlet var endGoal: UITextField!

    @IBOutlet var goal: UITextField!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //목표치 입력은 숫자만 가능
        startGoal.keyboardType = UIKeyboardType.numberPad
        nowGoal.keyboardType = UIKeyboardType.numberPad
        endGoal.keyboardType = UIKeyboardType.numberPad
        
        // Do any additional setup after loading the view.
        let application = UIApplication.shared
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in
            if granted { print("Approval granted to send notifications") }
            else { print(error!) }
        }
        application.registerForRemoteNotifications()

    }
  
    @IBAction func cancel(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        
    }


    @IBAction func savePress(_ sender: UIBarButtonItem) {
        
        if self.goal.text == "" {
            
            let alert = UIAlertController(title: "알림", message: "단위를 입력해주세요!", preferredStyle: UIAlertControllerStyle.alert)
            
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler : nil )
            
            alert.addAction(okAction)
            
            present(alert, animated: true, completion: nil)
        
        }
        
        else {
            
            
        //1. context통해 얻어옴
        let context = getContext()
        let entity = NSEntityDescription.entity(forEntityName: "Dday", in: context)
        
        //2. 디스트립션통해 생성
        // friend record를 새로 생성함
        let object = NSManagedObject(entity: entity!, insertInto: context)
        object.setValue(startGoal.text, forKey: "start")
        object.setValue(endGoal.text, forKey: "end")
        object.setValue(nowGoal.text, forKey: "now")
        object.setValue(titleName.text, forKey: "title")
        object.setValue(goal.text, forKey: "goal")
        object.setValue(Date(), forKey: "savedDate")
        
        do {
            //3. 진짜 디비에 저장
            try context.save()
            print("saved!")
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        }
            
    
        dismiss(animated: true, completion: nil)

        
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
