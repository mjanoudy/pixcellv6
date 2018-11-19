//
//  ViewController.swift
//  PixcellWorking
//
//  Created by Nahar Alamoudi on 11/5/18.
//  Copyright © 2018 Pixcell Inc. All rights reserved.
//
//THIS IS THE ONE TO KEEP

import UIKit
import Firebase
import UserNotifications

class HomeViewController: UIViewController {

    let ref = Database.database().reference(fromURL: "https://pixcell-working.firebaseio.com/")
    let uid = Auth.auth().currentUser!.uid
    
    var resetMonth: String?
    var resetDay: Int?
    var todayDay: Int?
    var todayMonth: String?
    var deadlineDayToSubmit: String?
    var submittedNotification: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        guard let submittedValue = submittedNotification else {return}
            if submittedValue {
                let ac = UIAlertController(title: "Thank you for Submitting", message: "Sit tight and your album will be on its way to you", preferredStyle: .alert)
                let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
                ac.addAction(action)
                self.present(ac, animated: true)
            }
    }
   override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.ref.child("Reset Date").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            self.resetDay = value?["Day"] as? Int ?? 0
            self.resetMonth = value?["Month"] as? String ?? ""
            self.deadlineDayToSubmit = value?["Deadline"] as? String ?? ""
            let today = Date().dayMonthYear()
            let todayArray = today.components(separatedBy: " ")
            self.todayDay = Int(todayArray[1].dropLast())
            self.todayMonth = todayArray[0]
            
            guard let todayDay = self.todayDay, let todayMonth = self.todayMonth, let resetDay = self.resetDay, let resetMonth = self.resetMonth else {return}
            
            if todayDay == resetDay && todayMonth == resetMonth {
                self.ref.child("users").child(self.uid).child("Albums").setValue(["\(Date().getMonthName())":[[["empty":1000],false, false],[["empty":1000], false, false]]])
                print("values reset")
            } else {
                print("It is not reset day yet")
            }
        })
    }
}
