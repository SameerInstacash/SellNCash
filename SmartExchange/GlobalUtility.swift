//
//  GlobalUtility.swift
//  SmartExchange
//
//  Created by Sameer Khan on 13/05/22.
//  Copyright © 2022 ZeroWaste. All rights reserved.
//

import UIKit

class GlobalUtility: NSObject {
    
    let AppFontRegular = "Poppins-Regular"
    let AppFontMedium = "Poppins-Medium"
    let AppFontBold = "Poppins-Bold"

    var AppThemeColor : UIColor = UIColor().HexToColor(hexString: "#20409A", alpha: 1.0)
    
}

extension UIViewController {
    
    func setStatusBarColor(themeColor : UIColor) {
        if #available(iOS 13.0, *) {
            
            let app = UIApplication.shared
            let statusBarHeight: CGFloat = app.statusBarFrame.size.height
            
            let statusbarView = UIView()
            statusbarView.backgroundColor = themeColor
            view.addSubview(statusbarView)
            
            statusbarView.translatesAutoresizingMaskIntoConstraints = false
            statusbarView.heightAnchor
                .constraint(equalToConstant: statusBarHeight).isActive = true
            statusbarView.widthAnchor
                .constraint(equalTo: view.widthAnchor, multiplier: 1.0).isActive = true
            statusbarView.topAnchor
                .constraint(equalTo: view.topAnchor).isActive = true
            statusbarView.centerXAnchor
                .constraint(equalTo: view.centerXAnchor).isActive = true
            
        } else {
            
            let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView
            statusBar?.backgroundColor = themeColor
            
        }
    }
    
}

extension UIColor
{
    func HexToColor(hexString: String, alpha:CGFloat? = 1.0) -> UIColor
    {
        let hexint = Int(self.intFromHexString(hexStr: hexString))
        let red = CGFloat((hexint & 0xff0000) >> 16) / 255.0
        let green = CGFloat((hexint & 0xff00) >> 8) / 255.0
        let blue = CGFloat((hexint & 0xff) >> 0) / 255.0
        let alpha = alpha!
        
        // Create color object, specifying alpha as well
        let color = UIColor(red: red, green: green, blue: blue, alpha: alpha)
        return color
    }
    
    func intFromHexString(hexStr: String) -> UInt64
    {
        var hexInt: UInt64 = 0
        // Create scanner
        let scanner: Scanner = Scanner(string: hexStr)
        // Tell scanner to skip the # character
        scanner.charactersToBeSkipped = NSCharacterSet(charactersIn: "#") as CharacterSet
        // Scan hex value
        scanner.scanHexInt64(&hexInt)
        return hexInt
    }
}

@IBDesignable class CornerButton: UIButton {
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
            self.layer.masksToBounds = true
            setNeedsLayout()
        }
    }
    
}

