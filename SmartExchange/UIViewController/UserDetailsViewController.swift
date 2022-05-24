//
//  UserDetailsViewController.swift
//  SmartExchange
//
//  Created by Abhimanyu Saraswat on 28/07/19.
//  Copyright © 2019 ZeroWaste. All rights reserved.
//

import UIKit
import SwiftyJSON
import BEMCheckBox
import iOSDropDown
import JGProgressHUD

class UserDetailsViewController: UIViewController {
    
    @IBOutlet weak var userInfo: UILabel!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var emailId: UITextField!
    @IBOutlet weak var mobile: UITextField!
    
    var email = ""
    var mob = ""
    var nam = ""
    var questionAppCodeStr = ""
    var appCodeStr = ""
    var resultJOSN = JSON()
    
    let hud = JGProgressHUD()

    
    @IBOutlet weak var continueBtn: UIButton!
    //@IBOutlet weak var loaderImg: UIImageView!
    @IBOutlet weak var tnc: UILabel!
    @IBOutlet weak var checkBox: BEMCheckBox!
    
    
    /*
    @IBAction func continueBtnClicked(_ sender: Any) {
        email = emailId.text ?? ""
        if (email.length > 0){
            mob = mobile.text ?? ""
            if (mob.length > 7){
                nam = name.text ?? ""
                if (nam.length > 2){
//                    loaderImg.isHidden = false
//                    loaderImg.rotate360Degrees()
                    if(checkBox.on){
                            call()
                    }else{
                        DispatchQueue.main.async {
                            self.view.makeToast("Please Accept terms to continue", duration: 2.0, position: .bottom)
                        }
                    }
                    
                }else{
                    DispatchQueue.main.async {
                        self.view.makeToast("Please Enter a valid name", duration: 2.0, position: .bottom)
                    }
                }
            }else{
                DispatchQueue.main.async {
                    self.view.makeToast("Please Enter a valid mobile number ", duration: 2.0, position: .bottom)
                }
            }
        }else{
            DispatchQueue.main.async {
                self.view.makeToast("Please Enter a valid email Id ", duration: 2.0, position: .bottom)
            }
        }
        
    }*/
    
    
    @IBAction func continueBtnClicked(_ sender: UIButton) {
        if self.validation() {
            self.view.endEditing(true)
            self.call()
        }
    }
    
    func validation() -> Bool {
        
        if self.name.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? false {
            
            DispatchQueue.main.async {
                self.view.makeToast("Please Enter a valid name", duration: 2.0, position: .bottom)
            }
            
            return false
        }else if self.emailId.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? false {
            
            DispatchQueue.main.async {
                self.view.makeToast("Please Enter a email Id ", duration: 2.0, position: .bottom)
            }
            
            return false
        }else if !self.isValidEmail(self.emailId.text!.trimmingCharacters(in: .whitespacesAndNewlines)) {
            
            DispatchQueue.main.async {
                self.view.makeToast("Please Enter a valid email Id ", duration: 2.0, position: .bottom)
            }
            
            return false
        } else if self.mobile.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? false {
            
            DispatchQueue.main.async {
                self.view.makeToast("Please Enter a mobile number ", duration: 2.0, position: .bottom)
            }
            
            return false
        }else if (self.mobile.text?.trimmingCharacters(in: .whitespacesAndNewlines).count ?? 0) < 10 {
            
            DispatchQueue.main.async {
                self.view.makeToast("Please Enter a valid mobile number ", duration: 2.0, position: .bottom)
            }
            
            return false
        }else if !checkBox.on {
            
            DispatchQueue.main.async {
                self.view.makeToast("Please Accept terms to continue", duration: 2.0, position: .bottom)
            }
            
            return false
        } else {
            return true
        }
        
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{0,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func call(){
        
        /*
        var functional = "Functional Issue: "
        var start = 0;
        
        
        var l = UserDefaults.standard.string(forKey: "lcd") ?? ""
        if(appCodeStr.contains("SPTS01")) {
            l = "flawless".localized
        }
        if(appCodeStr.contains("SPTS02")) {
            l = "Minor_Scratches".localized
        }
        if(appCodeStr.contains("SPTS03")) {
            l = "Heavily_Scratched".localized
        }
        if(appCodeStr.contains("SPTS04")) {
            l = "cracked".localized
        }
        if(appCodeStr.contains("SBRK01")) {
            l = "Not_Working".localized
        }
        
        
        let lc = "lcd".localized
        let lcd = "\(lc): \(l)"
        let db = "device_body".localized
    
        var b = UserDefaults.standard.string(forKey: "back") ?? ""
        print("devie body: \(b)")
        
        if(appCodeStr.contains("CPBP01")){
            b = "flawless".localized
        }
        if(appCodeStr.contains("CPBP02")){
            b = "Minor_Scratches".localized
        }
        if(appCodeStr.contains("CPBP03")){
            b = "Heavily_Scratched".localized
        }
        if(appCodeStr.contains("CPBP05")){
            b = "cracked".localized
        }
        if(appCodeStr.contains("CPBP04")){
            b = "Dented".localized
        }
        
        
        
        let back = "\(db): \(b)"
        
        var myArray: Array = [lcd, back ]
        
        if(!UserDefaults.standard.bool(forKey: "rotation")){
            functional = "rotation_info".localized
            myArray.append(functional)
        }
        
        if((!UserDefaults.standard.bool(forKey: "proximity"))){
            functional = "Proximity_info".localized
            myArray.append(functional)
        }
        
        if(!UserDefaults.standard.bool(forKey: "volume")){
            functional = "hardware_info".localized
            myArray.append(functional)
        }
        
        /*
        if(!UserDefaults.standard.bool(forKey: "connection")){
            functional = "Wifi_info".localized
            myArray.append(functional)
        }
        */
 
        if(!UserDefaults.standard.bool(forKey: "earphone")){
            functional = "earphone_info".localized
            myArray.append(functional)
        }

        if(!UserDefaults.standard.bool(forKey: "charger")){
            functional = "charger_info".localized
            myArray.append(functional)
        }
        
        if(!UserDefaults.standard.bool(forKey: "camera")){
            functional = "camera_info".localized
            myArray.append(functional)
        }
        
        if(!UserDefaults.standard.bool(forKey: "fingerprint")){
            functional = "fingerprint_info".localized
            myArray.append(functional)
        }
        
        if(!UserDefaults.standard.bool(forKey: "WIFI")){
            functional = "wifi_info".localized
            myArray.append(functional)
        }
        
        if(!UserDefaults.standard.bool(forKey: "GSM")) {
            functional = "gsm_info".localized
            myArray.append(functional)
        }
        
        if(!UserDefaults.standard.bool(forKey: "Bluetooth")) {
            functional = "bluetooth_info".localized
            myArray.append(functional)
        }
        
        if(!UserDefaults.standard.bool(forKey: "GPS")) {
            functional = "gps_info".localized
            myArray.append(functional)
        }
        
        if(!UserDefaults.standard.bool(forKey: "mic")){
            functional = "mic_info".localized
            myArray.append(functional)
        }
        
        if(!UserDefaults.standard.bool(forKey: "Speakers")) {
            functional = "speakers_info".localized
            myArray.append(functional)
        }
        
        if(!UserDefaults.standard.bool(forKey: "Vibrator")) {
            functional = "vibrator_info".localized
            myArray.append(functional)
        }
        
        /*
        if(!UserDefaults.standard.bool(forKey: "NFC")) {
            functional = "nfc_info".localized
            myArray.append(functional)
        }
        */
        
        */
        
   
        
//        let endPoint = UserDefaults.standard.string(forKey: "endpoint")!
        
        //var request = URLRequest(url: URL(string: "https://exchange.buyblynk.com/api/v1/public/updateCustomer")!) // Blynk
        var request = URLRequest(url: URL(string: "https://xcover-uat.getinstacash.in/xtracoverexchange/api/v1/public/updateCustomer")!) // XtraCover
        
        request.httpMethod = "POST"
        let customerId = UserDefaults.standard.string(forKey: "customer_id")
        let cust = customerId ?? ""
        let postString = "customerId=\(cust)&name=\(self.nam)&mobile=\(self.mob)&userName=planetm&apiKey=fd9a42ed13c8b8a27b5ead10d054caaf&email=\(self.email)"
        print(postString)
        request.httpBody = postString.data(using: .utf8)
        
        
        self.hud.textLabel.text = ""
        self.hud.backgroundColor = #colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 0.4)
        self.hud.show(in: self.view)
        
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            DispatchQueue.main.async() {
                self.hud.dismiss()
            }
            
            guard let data = data, error == nil else {
                // check for fundamental networking error
                DispatchQueue.main.async() {
                    print("error=\(error.debugDescription)")
                    //self.loaderImg.layer.removeAllAnimations()
                    //self.loaderImg.isHidden = true
                    //self.retryBtn.isHidden = false
                    
                    self.hud.dismiss()
                }
                
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response?.description)")
                //self.retryBtn.isHidden = false
            } else{
                print(response)
                DispatchQueue.main.async() {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "PriceVC") as! PriceViewController
                    
                    if self.questionAppCodeStr != "" {
                        vc.appPhysicalQuestionCodeStr = self.questionAppCodeStr
                        print("self.questionAppCodeStr", self.questionAppCodeStr)
                    }else {
                        vc.appCodeStr = self.appCodeStr
                        print("self.appCodeStr", self.appCodeStr)
                    }
                    
                    print("Result JSON 4: \(self.resultJOSN)")
                    vc.resultJOSN = self.resultJOSN
                    //vc.myArray = myArray
                    //print(myArray)
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true, completion: nil)
                }
            }
        }
        task.resume()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setStatusBarColor(themeColor: GlobalUtility().AppThemeColor)
        
        self.hideKeyboardWhenTappedAround()
        
       print("Starting Update Users VC")
        //loaderImg.isHidden = true
        let info = "user_btn_continue".localized
        continueBtn.setTitle(info, for: .normal)
        userInfo.text = "user_details_info".localized
        emailId.placeholder = "email_place".localized
        name.placeholder = "name_place".localized
        mobile.placeholder = "mobile_place".localized
        let tap = UITapGestureRecognizer(target: self, action: #selector(UserDetailsViewController.handleTap))
        tnc.isUserInteractionEnabled = true
        tnc.addGestureRecognizer(tap)
    }
    
    /*
     func handleTap(gestureRecognizer: UIGestureRecognizer) {
        guard let url = URL(string: "https://exchange.buyblynk.com/tnc.php") else {
            return //be safe
        }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    */
    
    @objc func handleTap(gestureRecognizer: UIGestureRecognizer) {
        //let tncendpoint = UserDefaults.standard.string(forKey: "tncendpoint") ?? "https://exchange.buyblynk.com/tnc.php" // Blynk
        let tncendpoint = UserDefaults.standard.string(forKey: "tncendpoint") ?? "https://xcover-uat.getinstacash.in/xtracoverexchange/tnc.php" // XtraCover
        
        guard let url = URL(string: tncendpoint) else {
            return //be safe
        }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    

}
