//
//  ViewController.swift
//  SmartExchange
//
//  Created by Abhimanyu Saraswat on 15/02/17.
//  Copyright © 2017 ZeroWaste. All rights reserved.
//

import UIKit
import Luminous
import QRCodeReader
import SwiftyJSON
import Toast_Swift
//import Sparrow
//import Crashlytics
import JGProgressHUD
import FirebaseDatabase

extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

public extension UIDevice {
    
    var moName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        
        case "iPod5,1":                                 return "iPod touch (5th generation)"
        case "iPod7,1":                                 return "iPod touch (6th generation)"
        case "iPod9,1":                                 return "iPod touch (7th generation)"
            
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
        case "iPhone4,1":                               return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
        case "iPhone7,2":                               return "iPhone 6"
        case "iPhone7,1":                               return "iPhone 6 Plus"
        case "iPhone8,1":                               return "iPhone 6s"
        case "iPhone8,2":                               return "iPhone 6s Plus"
        case "iPhone8,4":                               return "iPhone SE"
        case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
        case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
        case "iPhone10,1", "iPhone10,4":                return "iPhone 8"
        case "iPhone10,2", "iPhone10,5":                return "iPhone 8 Plus"
        case "iPhone10,3", "iPhone10,6":                return "iPhone X"
        case "iPhone11,2":                              return "iPhone XS"
        case "iPhone11,4", "iPhone11,6":                return "iPhone XS Max"
        case "iPhone11,8":                              return "iPhone XR"
        case "iPhone12,1":                              return "iPhone 11"
        case "iPhone12,3":                              return "iPhone 11 Pro"
        case "iPhone12,5":                              return "iPhone 11 Pro Max"
        case "iPhone12,8":                              return "iPhone SE (2nd generation)"
        case "iPhone13,1":                              return "iPhone 12 mini"
        case "iPhone13,2":                              return "iPhone 12"
        case "iPhone13,3":                              return "iPhone 12 Pro"
        case "iPhone13,4":                              return "iPhone 12 Pro Max"
            
        case "iPhone14,4":                              return "iPhone 13 Mini"
        case "iPhone14,5":                              return "iPhone 13"
        case "iPhone14,2":                              return "iPhone 13 Pro"
        case "iPhone14,3":                              return "iPhone 13 Pro Max"
            
            
        //iPad
        case "iPad1,1", "iPad1,2":                      return "iPad (1st generation)"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad (2nd generation)"
        case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad (3rd generation)"
        case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad (4th generation)"
        case "iPad6,11", "iPad6,12":                    return "iPad (5th generation)"
        case "iPad7,5", "iPad7,6":                      return "iPad (6th generation)"
        case "iPad7,11", "iPad7,12":                    return "iPad (7th generation)"
        case "iPad11,6", "iPad11,7":                    return "iPad (8th generation)"
            
        //iPad Air
        case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air (1st generation)"
        case "iPad5,3", "iPad5,4":                      return "iPad Air (2nd generation)"
        case "iPad11,3", "iPad11,4":                    return "iPad Air (3rd generation)"
        case "iPad13,1", "iPad13,2":                    return "iPad Air (4th generation)"
            
        //iPad Mini
        case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad mini (1st generation)"
        case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad mini (2nd generation)"
        case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad mini (3rd generation)"
        case "iPad5,1", "iPad5,2":                      return "iPad mini (4th generation)"
        case "iPad11,1", "iPad11,2":                    return "iPad mini (5th generation)"
            
        //iPad Pro
        case "iPad6,3", "iPad6,4":                      return "iPad Pro (9.7-inch)"
        case "iPad7,3", "iPad7,4":                      return "iPad Pro (10.5-inch)"
        case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4":return "iPad Pro (11-inch) (1st generation)"
        case "iPad8,9", "iPad8,10":                     return "iPad Pro (11-inch) (2nd generation)"
            
        case "iPad6,7", "iPad6,8":                      return "iPad Pro (12.9-inch) (1st generation)"
        case "iPad7,1", "iPad7,2":                      return "iPad Pro (12.9-inch) (2nd generation)"
        case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8":return "iPad Pro (12.9-inch) (3rd generation)"
        case "iPad8,11", "iPad8,12":                    return "iPad Pro (12.9-inch) (4th generation)"
            
        
        case "AppleTV5,3":                              return "Apple TV"
        case "AppleTV6,2":                              return "Apple TV 4K"
        case "AudioAccessory1,1":                       return "HomePod"
        case "AudioAccessory5,1":                       return "HomePod mini"
        case "i386", "x86_64":                          return "iPhone 13 Pro"
        default:                                        return identifier
        
        }
    }
}

extension String {
    func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }
    
    func substring(from: Int) -> String {
        let fromIndex = index(from: from)
        return substring(from: fromIndex)
    }
    
    func substring(to: Int) -> String {
        let toIndex = index(from: to)
        return substring(to: toIndex)
    }
    
    func substring(with r: Range<Int>) -> String {
        let startIndex = index(from: r.lowerBound)
        let endIndex = index(from: r.upperBound)
        return substring(with: startIndex..<endIndex)
    }
}

extension UIView {
    func rotate360Degrees(duration: CFTimeInterval = 3) {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = CGFloat(Double.pi * 2)
        rotateAnimation.isRemovedOnCompletion = false
        rotateAnimation.duration = duration
        rotateAnimation.repeatCount=Float.infinity
        self.layer.add(rotateAnimation, forKey: nil)
    }
}



class ViewController: UIViewController, QRCodeReaderViewControllerDelegate {
    
    let reachability: Reachability? = Reachability()
    let hud = JGProgressHUD()
    var arrStoreUrlData = [StoreUrlData]()
    
    var IMEINumber = String()
    @IBOutlet weak var storeImage: UIImageView!
    @IBOutlet weak var storeName: UILabel!
    @IBOutlet weak var imeiLabel: UILabel!
    @IBOutlet weak var findStoreBtn: UIButton!
    @IBOutlet weak var scanQRBtn: UIButton!
    @IBOutlet weak var previousBtn: UIButton!
    //@IBOutlet weak var smartExLoadingImage: UIImageView!
    //@IBOutlet weak var retryBtn: UIButton!
    @IBOutlet weak var tradeInOnlineBtn: UIButton!
    @IBOutlet weak var storeTokenEdit: UITextField!
    @IBOutlet weak var submitStoreBtn: UIButton!
    
    var productId: String = ""
    var appCodes: String = ""
    
    
    var endPoint = "https://exchange.getinstacash.in/stores-asia/api/v1/public/"
    var storeToken: String = ""
    
    var hasScanned = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setStatusBarColor(themeColor: GlobalUtility().AppThemeColor)
        
        self.setStatusBarColor(themeColor: GlobalUtility().AppThemeColor)
        
        self.fetchStoreDataFromFirebase()
        
        //self.submitStoreBtn.isHidden = true
        //self.storeTokenEdit.isHidden = true
        
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            if(key != "imei_number"){
                defaults.removeObject(forKey: key)
            }
            defaults.synchronize()
        }
        self.hideKeyboardWhenTappedAround()
        self.submitStoreBtn.setTitle("Submit".localized, for: .normal)
        
        
        let imei = UserDefaults.standard.string(forKey: "imei_number")
    
        self.scanQRBtn.layer.cornerRadius = 6
        self.previousBtn.layer.cornerRadius = 6
        self.submitStoreBtn.layer.cornerRadius = 6
        
        let uuid = UUID().uuidString
        print(uuid)
        //smartExLoadingImage.isHidden = true
        imeiLabel.text = IMEINumber
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        /*
        if !SPRequestPermission.isAllowPermissions([.camera,.locationWhenInUse,.microphone,.photoLibrary]){
            SPRequestPermission.dialog.interactive.present(on: self, with: [.camera,.microphone,.photoLibrary,.locationWhenInUse], dataSource: DataSource())
        }
        */
        
    }
    
    func fetchStoreDataFromFirebase() {
                
        if reachability?.connection.description != "No Connection" {
            
            self.hud.textLabel.text = ""
            self.hud.backgroundColor = #colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 0.4)
            self.hud.show(in: self.view)
        
            StoreUrlData.fetchStoreUrlsFromFireBase(isInterNet: true, getController: self) { (storeData) in
                
                DispatchQueue.main.async {
                    self.hud.dismiss()
                }
                
                if storeData.count > 0 {
                    
                    self.arrStoreUrlData = storeData
                    
                }else {
                    //DispatchQueue.main.async() {
                        //self.view.makeToast("No Data Found".localized, duration: 2.0, position: .bottom)
                    //}
                }
                
            }
            
        }else {
            DispatchQueue.main.async() {
                self.view.makeToast("Please Check Internet connection.".localized, duration: 2.0, position: .bottom)
            }
        }
        
    }
    
    @IBAction func tradeInOnlineBtnClicked(_ sender: Any) {
        
        let ref = Database.database().reference(withPath: "trade_in_online")
        
        ref.observeSingleEvent(of: .value, with: { snapshot in
            
            if !snapshot.exists() {
                return
            }
            
            let tempDict = snapshot.value as? NSDictionary
            print(tempDict ?? [:])
            
            DispatchQueue.main.async {
                self.storeToken = (tempDict?.value(forKey: "token") as? String) ?? ""
            
                self.endPoint = AppBaseUrl

                let preferences = UserDefaults.standard
                preferences.setValue(AppBaseTnc, forKey: "tncendpoint")
                
                self.verifyUserSmartCode()
                
                UserDefaults.standard.setValue(true, forKey: "Trade_In_Online")
            }
            
        })
        
    }
    
    @IBAction func submitStoreToken(_ sender: Any) {
        
        if self.storeTokenEdit.text?.isEmpty ?? false {
            
            DispatchQueue.main.async() {
                self.view.makeToast("Please Enter Token".localized, duration: 2.0, position: .bottom)
            }
            
        }else if (self.storeTokenEdit.text?.count ?? 0) < 4 {
            
            DispatchQueue.main.async() {
                self.view.makeToast("Please Enter Valid Token".localized, duration: 2.0, position: .bottom)
            }
            
        }else {
            self.fireWebServiceForQuoteId(quoteID: self.storeTokenEdit.text ?? "")
        }
        
        return
        
        /*
        self.storeToken = String(storeTokenEdit.text ?? "0")
        switch(self.storeToken.prefix(4)) {
        case "9100"  :
            self.endPoint = "https://exchange.getinstacash.com/store/api/v1/public/"
            break;
        case "6000"  :
            self.endPoint = "https://exchange.getinstacash.com.my/stores-asia/api/v1/public/"
            break;
        case "6300"  :
            self.endPoint = "https://exchange.getinstacash.com.my/stores-asia/api/v1/public/"
            break;
        case "9000"  :
            self.endPoint = "https://exchange.getinstacash.com.my/stores-asia/api/v1/public/"
            break;
        case "6001"  :
            self.endPoint = "https://exchange.getinstacash.com.my/stores-asia/api/v1/public/"
            break;
        case "6002"  :
            self.endPoint = "https://exchange.getinstacash.com.my/stores-asia/api/v1/public/"
            break;
        case "6301"  :
            self.endPoint = "https://exchange.getinstacash.com.my/stores-asia/api/v1/public/"
            break;
        case "6302"  :
            self.endPoint = "https://exchange.getinstacash.com.my/stores-asia/api/v1/public/"
            break;
        case "6003"  :
            self.endPoint = "https://exchange.getinstacash.com.my/stores-asia/api/v1/public/"
            break;
        case "6004"  :
            self.endPoint = "https://exchange.getinstacash.com.my/stores-asia/api/v1/public/"
            break;
        case "6303"  :
            self.endPoint = "https://exchange.getinstacash.com.my/stores-asia/api/v1/public/"
            break;
        case "6304"  :
            self.endPoint = "https://exchange.getinstacash.com.my/stores-asia/api/v1/public/"
            break;
        case "6005"  :
            self.endPoint = "https://exchange.getinstacash.com.my/stores-asia/api/v1/public/"
            break;
        case "9001"  :
            self.endPoint = "https://exchange.getinstacash.com.my/stores-asia/api/v1/public/"
            break;
        case "6305"  :
            self.endPoint = "https://exchange.getinstacash.com.my/stores-asia/api/v1/public/"
            break;
        case "6305"  :
            self.endPoint = "https://exchange.getinstacash.com.my/stores-asia/api/v1/public/"
            break;
        case "6006"  :
            self.endPoint = "https://exchange.getinstacash.com.my/stores-asia/api/v1/public/"
            break;
        case "6007"  :
            self.endPoint = "https://exchange.getinstacash.com.my/stores-asia/api/v1/public/"
            break;
        case "9002"  :
            self.endPoint = "https://exchange.getinstacash.com.my/stores-asia/api/v1/public/"
            break;
        case "9003"  :
            self.endPoint = "https://exchange.getinstacash.com.my/stores-asia/api/v1/public/"
            break;
        case "6306"  :
            self.endPoint = "https://exchange.getinstacash.com.my/stores-asia/api/v1/public/"
            break;
        case "6307"  :
            self.endPoint = "https://exchange.getinstacash.com.my/stores-asia/api/v1/public/"
            break;
        case "6008"  :
            self.endPoint = "https://exchange.getinstacash.com.my/stores-asia/api/v1/public/"
            break;
        case "6009"  :
            self.endPoint = "https://exchange.getinstacash.com.my/asurionre/api/v1/public/"
            break;
        case "6010"  :
            self.endPoint = "https://exchange.getinstacash.com.my/stores-asia/api/v1/public/"
            break;
        case "6011"  :
            self.endPoint = "https://exchange.getinstacash.com.my/stores-asia/api/v1/public/"
            break;
        case "9004"  :
            self.endPoint = "https://exchange.getinstacash.com.my/stores-asia/api/v1/public/"
            break;
        case "9005"  :
            self.endPoint = "https://exchange.getinstacash.com.my/stores-asia/api/v1/public/"
            break;
        case "9006"  :
            self.endPoint = "https://exchange.getinstacash.com.my/stores-asia/api/v1/public/"
            break;
        case "6308"  :
            self.endPoint = "https://exchange.getinstacash.com.my/stores-asia/api/v1/public/"
            break;
        case "6309"  :
            self.endPoint = "https://exchange.getinstacash.com.my/stores-asia/api/v1/public/"
            break;
        case "6310"  :
            self.endPoint = "https://exchange.getinstacash.com.my/stores-asia/api/v1/public/"
            break;
        case "6311"  :
            self.endPoint = "https://exchange.getinstacash.com.my/stores-asia/api/v1/public/"
            break;
        case "6312"  :
            self.endPoint = "https://exchange.getinstacash.com.my/stores-asia/api/v1/public/"
            break;
        case "6313"  :
            self.endPoint = "https://exchange.getinstacash.com.my/stores-asia/api/v1/public/"
            break;
        case "6314"  :
            self.endPoint = "https://exchange.getinstacash.com.my/stores-asia/api/v1/public/"
            break;
        case "9007"  :
            self.endPoint = "https://exchange.getinstacash.com.my/stores-asia/api/v1/public/"
            break;
        case "9008"  :
            self.endPoint = "https://exchange.getinstacash.com.my/stores-asia/api/v1/public/"
            break;
        case "9009"  :
            self.endPoint = "https://exchange.getinstacash.com.my/stores-asia/api/v1/public/"
            break;
        case "9010"  :
            self.endPoint = "https://exchange.getinstacash.com.my/stores-asia/api/v1/public/"
            break;
        case "8515"  :
            self.endPoint = "https://exchange.getinstacash.com.my/stores-asia/api/v1/public/"
            break;
        case "6016"  :
            self.endPoint = "https://exchange.getinstacash.com.my/stores-asia/api/v1/public/"
            break;
        case "6017"  :
            self.endPoint = "https://exchange.getinstacash.com.my/stores-asia/api/v1/public/"
            break;
        case "6018"  :
            self.endPoint = "https://exchange.getinstacash.com.my/stores-asia/api/v1/public/"
            break;
        case "6019"  :
            self.endPoint = "https://exchange.getinstacash.com.my/stores-asia/api/v1/public/"
            break;
        case "6020"  :
            self.endPoint = "https://exchange.getinstacash.com.my/stores-asia/api/v1/public/"
            break;
        case "6315"  :
            self.endPoint = "https://exchange.getinstacash.com.my/stores-asia/api/v1/public/"
            break;
        case "8516"  :
            self.endPoint = "https://exchange.getinstacash.com.my/stores-asia/api/v1/public/"
            break;
        case "6501"  :
            self.endPoint = "https://exchange.getinstacash.com.my/stores-asia/api/v1/public/"
            break;
        case "9102"  :
            self.endPoint = "https://exchange.getinstacash.com/blynk/api/v1/public/"
            break;
            /* you can have any number of case statements */
        default : /* Optional */
            self.endPoint = "https://exchange.getinstacash.com.my/stores-asia/api/v1/public/"
            break;
        }
        self.verifyUserSmartCode()
        */
        
        
        self.storeToken = String(storeTokenEdit.text ?? "0")
        
        guard self.storeToken != "" else {
            
            DispatchQueue.main.async() {
                self.view.makeToast("Please Enter Token".localized, duration: 2.0, position: .bottom)
            }
            
            return
        }
        
        if self.storeToken.count >= 4 {
            print("self.storeToken submit", self.storeToken)
            
            let enteredToken = self.storeToken.prefix(4)
            
            for tokens in self.arrStoreUrlData {
                if tokens.strPrefixKey == enteredToken {
                    
                    self.endPoint = tokens.strUrl
                    print("self.endPoint submit", self.endPoint)
                    
                    let preferences = UserDefaults.standard
                    preferences.setValue(tokens.strTnc, forKey: "tncendpoint")
                    preferences.setValue(tokens.strType, forKey: "storeType")
                    preferences.setValue(tokens.strIsTradeOnline, forKey: "tradeOnline")
                    
                    self.verifyUserSmartCode()
                    
                    UserDefaults.standard.setValue(false, forKey: "Trade_In_Online")
                    
                    //break
                    return
                }
            }
            
            // If Store Token not add in firebase
            //self.endPoint = "https://exchange.buyblynk.com/api/v1/public" // Blynk
           
            
            self.endPoint = AppBaseUrl
            
            print("self.endPoint", self.endPoint)
            
            let preferences = UserDefaults.standard
            //preferences.setValue("https://exchange.buyblynk.com/tnc.php", forKey: "tncendpoint") // Blynk
           
            preferences.setValue(AppBaseTnc, forKey: "tncendpoint")
            
            preferences.setValue(0, forKey: "storeType")
            preferences.setValue(0, forKey: "tradeOnline")
            
            self.verifyUserSmartCode()
            
            UserDefaults.standard.setValue(false, forKey: "Trade_In_Online")
            
        }else {
            DispatchQueue.main.async() {
                self.view.makeToast("Please Enter Valid Store Token".localized, duration: 2.0, position: .bottom)
            }
        }
        
        
    }
    
    
    var responseData = " "
    
    lazy var reader: QRCodeReader = QRCodeReader()
    lazy var readerVC: QRCodeReaderViewController = {
    let builder = QRCodeReaderViewControllerBuilder {
    $0.reader          = QRCodeReader(metadataObjectTypes: [.qr], captureDevicePosition: .back)
    $0.showTorchButton = true
    
    $0.reader.stopScanningWhenCodeIsFound = false
    }
    
    return QRCodeReaderViewController(builder: builder)
    }()
    
    // MARK: - Actions
    
    private func checkScanPermissions() -> Bool {
        do {
            return try QRCodeReader.supportsMetadataObjectTypes()
        } catch let error as NSError {
            let alert: UIAlertController
    
            switch error.code {
                case -11852:
                    alert = UIAlertController(title: "Error".localized, message: "This app is not authorized to use Back Camera.".localized, preferredStyle: .alert)
    
                    alert.addAction(UIAlertAction(title: "Setting".localized, style: .default, handler: { (_) in
                        DispatchQueue.main.async {
                            if let settingsURL = URL(string: UIApplicationOpenSettingsURLString) {
                                UIApplication.shared.openURL(settingsURL)
                            }
                        }
                    }))
    
                    alert.addAction(UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil))
                default:
                    alert = UIAlertController(title: "Error".localized, message: "Reader not supported by the current device".localized, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK".localized, style: .cancel, handler: nil))
            }
    
            present(alert, animated: true, completion: nil)
    
            return false
        }
    }
    
    
    @IBAction func scanQRPressed(_ sender: Any) {
        
        DispatchQueue.main.async {
            
            guard self.checkScanPermissions() else { return }
            
            self.readerVC.modalPresentationStyle = .formSheet
            self.readerVC.delegate               = self
            
            self.readerVC.completionBlock = { (result: QRCodeReaderResult?) in
                if let result = result {
                    let completeResult = String(result.value)
                    print("completeResult is:-",completeResult)
                    
                    if self.hasScanned {
                        print("self.hasScanned = !self.hasScanned", self.hasScanned)
                        self.hasScanned = !self.hasScanned
                        self.fireWebServiceForQuoteId(quoteID: completeResult)
                    }
                    
                    return
                    
                    let values = completeResult.components(separatedBy: "@@@")
                    print(values)
                    
                    if values.count > 2 {
                        self.storeToken = String(values[0])
                        self.productId = values[1]
                        self.appCodes = values[2]
                    }else{
                        self.storeToken = String(values[0])
                        self.productId = ""
                        self.appCodes = ""
                    }
                    
                    /*
                    switch(self.storeToken.prefix(4)) {
                    case "9100"  :
                        self.endPoint = "https://exchange.getinstacash.com/store/api/v1/public/"
                        break;
                    case "6000"  :
                        self.endPoint = "https://exchange.getinstacash.com.my/stores-asia/api/v1/public/"
                        break;
                    case "6300"  :
                        self.endPoint = "https://exchange.getinstacash.com.my/stores-asia/api/v1/public/"
                        break;
                    case "9000"  :
                        self.endPoint = "https://exchange.getinstacash.com.my/stores-asia/api/v1/public/"
                        break;
                    case "6001"  :
                        self.endPoint = "https://exchange.getinstacash.com.my/stores-asia/api/v1/public/"
                        break;
                    case "6002"  :
                        self.endPoint = "https://exchange.getinstacash.com.my/stores-asia/api/v1/public/"
                        break;
                    case "6301"  :
                        self.endPoint = "https://exchange.getinstacash.com.my/stores-asia/api/v1/public/"
                        break;
                    case "6302"  :
                        self.endPoint = "https://exchange.getinstacash.com.my/stores-asia/api/v1/public/"
                        break;
                    case "6003"  :
                        self.endPoint = "https://exchange.getinstacash.com.my/stores-asia/api/v1/public/"
                        break;
                    case "6004"  :
                        self.endPoint = "https://exchange.getinstacash.com.my/stores-asia/api/v1/public/"
                        break;
                    case "6303"  :
                        self.endPoint = "https://exchange.getinstacash.com.my/stores-asia/api/v1/public/"
                        break;
                    case "6304"  :
                        self.endPoint = "https://exchange.getinstacash.com.my/stores-asia/api/v1/public/"
                        break;
                    case "6005"  :
                        self.endPoint = "https://exchange.getinstacash.com.my/stores-asia/api/v1/public/"
                        break;
                    case "9001"  :
                        self.endPoint = "https://exchange.getinstacash.com.my/stores-asia/api/v1/public/"
                        break;
                    case "6305"  :
                        self.endPoint = "https://exchange.getinstacash.com.my/stores-asia/api/v1/public/"
                        break;
                    case "6305"  :
                        self.endPoint = "https://exchange.getinstacash.com.my/stores-asia/api/v1/public/"
                        break;
                    case "6006"  :
                        self.endPoint = "https://exchange.getinstacash.com.my/stores-asia/api/v1/public/"
                        break;
                    case "6007"  :
                        self.endPoint = "https://exchange.getinstacash.com.my/stores-asia/api/v1/public/"
                        break;
                    case "9002"  :
                        self.endPoint = "https://exchange.getinstacash.com.my/stores-asia/api/v1/public/"
                        break;
                    case "9003"  :
                        self.endPoint = "https://exchange.getinstacash.com.my/stores-asia/api/v1/public/"
                        break;
                    case "6306"  :
                        self.endPoint = "https://exchange.getinstacash.com.my/stores-asia/api/v1/public/"
                        break;
                    case "6307"  :
                        self.endPoint = "https://exchange.getinstacash.com.my/stores-asia/api/v1/public/"
                        break;
                    case "6008"  :
                        self.endPoint = "https://exchange.getinstacash.com.my/stores-asia/api/v1/public/"
                        break;
                    case "6009"  :
                        self.endPoint = "https://exchange.getinstacash.com.my/stores-asia/api/v1/public/"
                        break;
                    case "6010"  :
                        self.endPoint = "https://exchange.getinstacash.com.my/stores-asia/api/v1/public/"
                        break;
                    case "6011"  :
                        self.endPoint = "https://exchange.getinstacash.com.my/stores-asia/api/v1/public/"
                        break;
                    case "9004"  :
                        self.endPoint = "https://exchange.getinstacash.com.my/stores-asia/api/v1/public/"
                        break;
                    case "9005"  :
                        self.endPoint = "https://exchange.getinstacash.com.my/stores-asia/api/v1/public/"
                        break;
                    case "9006"  :
                        self.endPoint = "https://exchange.getinstacash.com.my/stores-asia/api/v1/public/"
                        break;
                    case "6308"  :
                        self.endPoint = "https://exchange.getinstacash.com.my/stores-asia/api/v1/public/"
                        break;
                    case "6309"  :
                        self.endPoint = "https://exchange.getinstacash.com.my/stores-asia/api/v1/public/"
                        break;
                    case "6310"  :
                        self.endPoint = "https://exchange.getinstacash.com.my/stores-asia/api/v1/public/"
                        break;
                    case "6311"  :
                        self.endPoint = "https://exchange.getinstacash.com.my/stores-asia/api/v1/public/"
                        break;
                    case "6312"  :
                        self.endPoint = "https://exchange.getinstacash.com.my/stores-asia/api/v1/public/"
                        break;
                    case "6313"  :
                        self.endPoint = "https://exchange.getinstacash.com.my/stores-asia/api/v1/public/"
                        break;
                    case "6314"  :
                        self.endPoint = "https://exchange.getinstacash.com.my/stores-asia/api/v1/public/"
                        break;
                    case "9007"  :
                        self.endPoint = "https://exchange.getinstacash.com.my/stores-asia/api/v1/public/"
                        break;
                    case "9008"  :
                        self.endPoint = "https://exchange.getinstacash.com.my/stores-asia/api/v1/public/"
                        break;
                    case "9009"  :
                        self.endPoint = "https://exchange.getinstacash.com.my/stores-asia/api/v1/public/"
                        break;
                    case "9010"  :
                        self.endPoint = "https://exchange.getinstacash.com.my/stores-asia/api/v1/public/"
                        break;
                    case "8515"  :
                        self.endPoint = "https://exchange.getinstacash.com.my/stores-asia/api/v1/public/"
                        break;
                    case "6016"  :
                        self.endPoint = "https://exchange.getinstacash.com.my/stores-asia/api/v1/public/"
                        break;
                    case "6017"  :
                        self.endPoint = "https://exchange.getinstacash.com.my/stores-asia/api/v1/public/"
                        break;
                    case "6018"  :
                        self.endPoint = "https://exchange.getinstacash.com.my/stores-asia/api/v1/public/"
                        break;
                    case "6019"  :
                        self.endPoint = "https://exchange.getinstacash.com.my/stores-asia/api/v1/public/"
                        break;
                    case "6020"  :
                        self.endPoint = "https://exchange.getinstacash.com.my/stores-asia/api/v1/public/"
                        break;
                    case "6315"  :
                        self.endPoint = "https://exchange.getinstacash.com.my/stores-asia/api/v1/public/"
                        break;
                    case "8516"  :
                        self.endPoint = "https://exchange.getinstacash.com.my/stores-asia/api/v1/public/"
                        break;
                    case "6501"  :
                        self.endPoint = "https://exchange.getinstacash.com.my/stores-asia/api/v1/public/"
                        break;
                    case "9102"  :
                        self.endPoint = "https://exchange.buyblynk.com/api/v1/public/"
                        break;
                        
                        /* you can have any number of case statements */
                    default : /* Optional */
                        self.endPoint = "https://exchange.buyblynk.com/api/v1/public/"
                        break;
                    }
                    self.verifyUserSmartCode()
                    */
                    
                    if self.storeToken.count >= 4 {
                        print("self.storeToken", self.storeToken)
                        
                        let enteredToken = self.storeToken.prefix(4)
                        
                        for tokens in self.arrStoreUrlData {
                            
                            if tokens.strPrefixKey == enteredToken {
                                
                                self.endPoint = tokens.strUrl
                                print("self.endPoint", self.endPoint)
                                
                                let preferences = UserDefaults.standard
                                preferences.setValue(tokens.strTnc, forKey: "tncendpoint")
                                preferences.setValue(tokens.strType, forKey: "storeType")
                                preferences.setValue(tokens.strIsTradeOnline, forKey: "tradeOnline")
                                
                                self.verifyUserSmartCode()
                                
                                UserDefaults.standard.setValue(false, forKey: "Trade_In_Online")
                                
                                //break
                                return
                            }
                        }
                        
                        // If Store Token not add in firebase
                        //self.endPoint = "https://exchange.buyblynk.com/api/v1/public" // Blynk
                        
                        
                        self.endPoint = AppBaseUrl
                                                
                        print("self.endPoint", self.endPoint)
                        
                        let preferences = UserDefaults.standard
                        //preferences.setValue("https://exchange.buyblynk.com/tnc.php", forKey: "tncendpoint") // Blynk
                        
                        
                        preferences.setValue(AppBaseTnc, forKey: "tncendpoint") 
                        
                        preferences.setValue(0, forKey: "storeType")
                        preferences.setValue(0, forKey: "tradeOnline")
                        
                        self.verifyUserSmartCode()
                        
                        UserDefaults.standard.setValue(false, forKey: "Trade_In_Online")
                        
                    }else {
                        DispatchQueue.main.async() {
                            self.view.makeToast("Store Token Not Valid".localized, duration: 2.0, position: .bottom)
                        }
                    }
                    
                    
                }
            }
        }

        present(readerVC, animated: true, completion: nil)
//        self.verifyUserSmartCode()
    }
    
    func QuoteIdPost(strURL : String , parameters:NSDictionary, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        let web = WebServies()
        web.postRequest(urlString: strURL, paramDict: (parameters as! Dictionary<String, AnyObject>), completionHandler: completionHandler)
    }
    
    func fireWebServiceForQuoteId(quoteID:String)
    {
        var parameters = [String: Any]()
        //let strUrl = "\(self.endPoint)/getQuoteIdData"
        //let strUrl = "https://exchange.buyblynk.com/api/v1/public/getQuoteIdData" // Blynk
        
        let strUrl = AppBaseUrl + "getQuoteIdData"
        
        parameters  = [
            "userName" : "planetm",
            "apiKey" : "fd9a42ed13c8b8a27b5ead10d054caaf",
            "quoteId" : quoteID,
        ]
        
        
        print("url is :", strUrl, "quote id is  \(quoteID)" , parameters)
        
        //self.smartExLoadingImage.isHidden = false
        //self.smartExLoadingImage.rotate360Degrees()
        
        hud.textLabel.text = ""
        self.hud.backgroundColor = #colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 0.4)
        hud.show(in: self.view)
        
        self.QuoteIdPost(strURL: strUrl, parameters: parameters as NSDictionary, completionHandler: {responseObject , error in
            
            self.hasScanned = !self.hasScanned
            print(responseObject ?? [:])
            
            DispatchQueue.main.async {
                //self.smartExLoadingImage.layer.removeAllAnimations()
                //self.smartExLoadingImage.isHidden = true
                
                self.hud.dismiss()
            }
            
            if error == nil {
                
                if responseObject?["status"] as? String == "Success" {
                    
                    print(responseObject?["msg"] as? String ?? "")
                    
                    let values = (responseObject?["msg"] as? String ?? "").components(separatedBy: "@@@")
                   print(values)
                    
                    if values.count > 2 {
                        self.storeToken = String(values[0])
                        self.productId = values[1]
                        self.appCodes = values[2]
                    }else{
                        self.storeToken = String(values[0])
                        self.productId = ""
                        self.appCodes = ""
                    }
                    
                    
                    if self.storeToken.count >= 4 {
                        print("self.storeToken", self.storeToken)
                        
                        let enteredToken = self.storeToken.prefix(4)
                        
                        for tokens in self.arrStoreUrlData {
                            if tokens.strPrefixKey == enteredToken {
                                
                                self.endPoint = tokens.strUrl
                                print("self.endPoint", self.endPoint)
                                
                                let preferences = UserDefaults.standard
                                preferences.setValue(tokens.strTnc, forKey: "tncendpoint")
                                preferences.setValue(tokens.strType, forKey: "storeType")
                                preferences.setValue(tokens.strIsTradeOnline, forKey: "tradeOnline")
                                
                                self.verifyUserSmartCode()
                                
                                UserDefaults.standard.setValue(false, forKey: "Trade_In_Online")
                                
                                //break
                                return
                            }
                        }
                        
                        // If Store Token not add in firebase
                        //self.endPoint = "https://exchange.buyblynk.com/api/v1/public" // Blynk
                        
                        self.endPoint = AppBaseUrl
                        
                        print("self.endPoint", self.endPoint)
                        print("store token not matched in firebase database storeUrl Data")
                        
                        let preferences = UserDefaults.standard
                        //preferences.setValue("https://exchange.buyblynk.com/tnc.php", forKey: "tncendpoint") // Blynk
                        
                        preferences.setValue(AppBaseTnc, forKey: "tncendpoint") 
                        
                         
                        
                        preferences.setValue(0, forKey: "storeType")
                        preferences.setValue(0, forKey: "tradeOnline")
                        
                        self.verifyUserSmartCode()
                        
                        UserDefaults.standard.setValue(false, forKey: "Trade_In_Online")
                        
                    }else {
                        DispatchQueue.main.async() {
                            self.view.makeToast("Store Token Not Valid".localized, duration: 2.0, position: .bottom)
                        }
                    }
                
                }
                else{
                    
                    DispatchQueue.main.async() {
                        self.view.makeToast(responseObject?["msg"] as? String, duration: 2.0, position: .bottom)
                    }
                    
                }
                
            }
            else
            {
                // check for fundamental networking error
                DispatchQueue.main.async() {
                    self.view.makeToast("Error".localized, duration: 2.0, position: .bottom)
                }
                
            }
        })
        
    }
    
    
//    @IBAction func retryBtnPressed(_ sender: Any?) {
//        verifyUserSmartCode()
//    }
    
    func verifyUserSmartCode() {
        let device = UIDevice.current.moName
//        retryBtn.isHidden = true
        
        //smartExLoadingImage.isHidden = false
        //smartExLoadingImage.rotate360Degrees()
        
        self.hud.textLabel.text = ""
        self.hud.backgroundColor = #colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 0.4)
        self.hud.show(in: self.view)
        
        
        var request = URLRequest(url: URL(string: "\(self.endPoint)/startSession")!)
        let preferences = UserDefaults.standard
        preferences.set(self.endPoint, forKey: "endpoint")
        request.httpMethod = "POST"
        //        let mName = UIDevice.current.modelName
        let modelCapacity = getTotalSize()
        //        let model =  "\(mName)"
        let IMEI = imeiLabel.text
        let ram =  ProcessInfo.processInfo.physicalMemory
        //let ram = 3221223823
        let postString = "IMEINumber=\(IMEI!)&device=\(device)&memory=\(modelCapacity)&userName=planetm&apiKey=fd9a42ed13c8b8a27b5ead10d054caaf&ram=\(ram)&storeToken=\(self.storeToken)"
//        let postString = "IMEINumber=\(IMEI!)&device=iPhone XR&memory=64&userName=planetm&apiKey=fd9a42ed13c8b8a27b5ead10d054caaf&ram=2919613952&storeToken=6017"
//                let postString = "IMEINumber=\(IMEI!)&device=a0001&memory=64&userName=planetm&apiKey=fd9a42ed13c8b8a27b5ead10d054caaf&ram=1919613952&storeToken=6016"
        
        print("url is :",request,"\nParam is :",postString)
        
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            DispatchQueue.main.async() {
                self.hud.dismiss()
            }
            
            guard let data = data, error == nil else {
                DispatchQueue.main.async() {
                    //self.smartExLoadingImage.layer.removeAllAnimations()
                    //self.smartExLoadingImage.isHidden = true
                    self.hud.dismiss()
                }
//                self.retryBtn.isHidden = false
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response?.description)")
                
                DispatchQueue.main.async() {
                    //self.smartExLoadingImage.layer.removeAllAnimations()
                    //self.smartExLoadingImage.isHidden = true
                    
                    self.hud.dismiss()
                }
                
            } else{
                
               DispatchQueue.main.async() {
                    //self.smartExLoadingImage.layer.removeAllAnimations()
                    //self.smartExLoadingImage.isHidden = true
                
                    self.hud.dismiss()
                }
                do {
                    let json = try JSON(data: data)
                    if json["status"] == "Success" {
                        print("\(json)")
                                                
                        let responseString = String(data: data, encoding: .utf8)
                        self.responseData = responseString!
                        let preferences = UserDefaults.standard
                        var productIdenti = "0"
                        let productData = json["productData"]
                        if productData["id"].string ?? "" != "" {
                        
                            productIdenti = productData["id"].string ?? ""
                            
                            let isTradeInOnline = UserDefaults.standard.value(forKey: "Trade_In_Online") as! Bool
                            print("isTradeInOnline value is",isTradeInOnline)
                            
                            if isTradeInOnline {
                                
                                let productName = productData["name"]
                                let productImage = productData["image"]
                                preferences.set(productIdenti, forKey: "product_id")
                                preferences.set("\(productName)", forKey: "productName")
                                preferences.set("\(self.appCodes)", forKey: "appCodes")
                                preferences.set("\(productImage)", forKey: "productImage")
                                
                                preferences.set(json["customerId"].string!, forKey: "customer_id")
                                preferences.set(self.storeToken, forKey: "store_code")
                                let serverData = json["serverData"]
                                print("\n\n\(serverData["currencyJson"])")
                                let jsonEncoder = JSONEncoder()
                                
                                let currencyJSON = serverData["currencyJson"]
                                let jsonData = try jsonEncoder.encode(currencyJSON)
                                let jsonString = String(data: jsonData, encoding: .utf8)
                                preferences.set(jsonString, forKey: "currencyJson")
                                let priceData = json["priceData"]
                                let uptoPrice = priceData["msg"].string ?? ""
                                
                                DispatchQueue.main.async() {
                                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "DeadPixelVC") as! DeadPixelVC
                                    
                                    //let vc = self.storyboard?.instantiateViewController(withIdentifier: "UserDetailsVC") as! UserDetailsVC
                                    
                                    self.present(vc, animated: true, completion: nil)
                                }
                                
                                
                            }else {
                                
                                if productIdenti == self.productId {
                                    let productName = productData["name"]
                                    let productImage = productData["image"]
                                    preferences.set(productIdenti, forKey: "product_id")
                                    preferences.set("\(productName)", forKey: "productName")
                                    preferences.set("\(self.appCodes)", forKey: "appCodes")
                                    preferences.set("\(productImage)", forKey: "productImage")
                                    
                                    preferences.set(json["customerId"].string!, forKey: "customer_id")
                                    preferences.set(self.storeToken, forKey: "store_code")
                                    let serverData = json["serverData"]
                                    print("\n\n\(serverData["currencyJson"])")
                                    let jsonEncoder = JSONEncoder()
                                    
                                    let currencyJSON = serverData["currencyJson"]
                                    let jsonData = try jsonEncoder.encode(currencyJSON)
                                    let jsonString = String(data: jsonData, encoding: .utf8)
                                    preferences.set(jsonString, forKey: "currencyJson")
                                    let priceData = json["priceData"]
                                    let uptoPrice = priceData["msg"].string ?? ""
                                    
                                    DispatchQueue.main.async() {
                                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DeadPixelVC") as! DeadPixelVC
                                        self.present(vc, animated: true, completion: nil)
                                    }
                                }else{
                                    DispatchQueue.main.async {
                                        self.view.makeToast("Device Mismatch found!", duration: 2.0, position: .bottom)
                                    }
                                }
                                
                            }
                            
                            
                        }else{
                            DispatchQueue.main.async() {
                                self.view.makeToast("Device not found!", duration: 2.0, position: .bottom)
                            }
                        }
                        //                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "InternalVC") as! InternalTestsVC
                        //                        self.present(vc, animated: true, completion: nil)
                        DispatchQueue.main.async() {
                            //self.smartExLoadingImage.layer.removeAllAnimations()
                            //self.smartExLoadingImage.isHidden = true
                            
                            self.hud.dismiss()
                        }
//                        self.retryBtn.isHidden = false
                    }else{
                        
                        DispatchQueue.main.async() {
                            //self.smartExLoadingImage.layer.removeAllAnimations()
                            //self.smartExLoadingImage.isHidden = true
                            
                            self.hud.dismiss()
                            
//                            self.retryBtn.isHidden = false
                            DispatchQueue.main.async {
                                self.view.makeToast("Please make sure you've entered the details in the POS.", duration: 2.0, position: .bottom)
                            }
                        }
                    }
                }catch{
                    
                    DispatchQueue.main.async() {
                        //self.smartExLoadingImage.layer.removeAllAnimations()
                        //self.smartExLoadingImage.isHidden = true
                        
                        self.hud.dismiss()
                        self.view.makeToast("JSON Exception", duration: 2.0, position: .bottom)
                        
//                        self.retryBtn.isHidden = false
                        
                    }
                }
            }
        }
        task.resume()
    }
    
    func getTotalSize() -> Int64{
        var space: Int64 = 0
        do {
            let systemAttributes = try FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory() as String)
            space = ((systemAttributes[FileAttributeKey.systemSize] as? NSNumber)?.int64Value)!
            space = space/1000000000
            if space<8{
                space = 8
            } else if space<16{
                space = 16
            } else if space<32{
                space = 32
            } else if space<64{
                space = 64
            } else if space<128{
                space = 128
            } else if space<256{
                space = 256
            } else if space<512{
                space = 512
            }
        } catch {
            space = 0
        }
        return space
    }
    
    // MARK: - QRCodeReader Delegate Methods
    
    func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        reader.stopScanning()
        
        reader.dismiss(animated: true) {
            
        }
        
        /*
        dismiss(animated: true) { [weak self] in
//            let alert = UIAlertController(
//                title: "QRCodeReader",
//                message: String (format:"%@ (of type %@)", result.value, result.metadataType),
//                preferredStyle: .alert
//            )
//            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
//
//            self?.present(alert, animated: true, completion: nil)
        }
        */
        
    }
    
   
    
    func readerDidCancel(_ reader: QRCodeReaderViewController) {
        reader.stopScanning()
        
        reader.dismiss(animated: true) {
            
        }
        //dismiss(animated: true, completion: nil)
        
    }
    
    
    func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
            }.resume()
    }
    
    func downloadImage(url: URL) {
        getDataFromUrl(url: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            DispatchQueue.main.async() {
                self.storeImage.image = UIImage(data: data)
            }
        }
    }


   
}

/*
class DataSource: SPRequestPermissionDialogInteractiveDataSource {
    
    //override title in dialog view
    override func headerTitle() -> String {
        return "Blynk Exchange"
    }
    
    override func headerSubtitle() -> String {
        return "header_title".localized
    }
 
}
*/

import Alamofire
class WebServies: NSObject {
    
        func postRequest(urlString: String, paramDict:Dictionary<String, AnyObject>? = nil,
                     completionHandler:@escaping (NSDictionary?, NSError?) -> ()) {
                    
        Alamofire.request(urlString, method: .post, parameters: paramDict, encoding: URLEncoding.httpBody, headers: nil).responseJSON { (response:DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
//                if let data = response.result.value{
//                    print(data)
//                }
                completionHandler(response.result.value as! NSDictionary?, nil)
            case .failure(_):
//                if let data = response.result.value{
//                    print(data)
//                }
                completionHandler(nil, response.result.error as NSError?)
                break
                
            }
        }
        
    }
    
    
    func getRequest(urlString: String, paramDict:Dictionary<String, AnyObject>? = nil,
                     completionHandler:@escaping (NSDictionary?, NSError?) -> ()) {
       
        Alamofire.request(urlString, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
            
          if response.response?.statusCode == 200
          {
            switch(response.result) {
            case .success(_):

                completionHandler(response.result.value as! NSDictionary?, nil)
                
            case .failure(_):
                
                completionHandler(nil, response.result.error as NSError?)
                break
                
            }
        }
            else
          {
            completionHandler(nil, response.result.error as NSError?)

            }
        }
    }
    
 
    
}
