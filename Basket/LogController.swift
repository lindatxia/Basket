//
//  LogController.swift
//  Basket
//
//  Created by Linda Xia on 8/22/16.
//  Copyright © 2016 Linda Xia. All rights reserved.
//

import Foundation

#if os(OSX)
    import Cocoa
#elseif os(iOS) || os(tvOS)
    import UIKit
#endif


var nums = 0

public struct LindaOnlineLogs
    
{
    /// Online logs does not work while QorumLogs is enabled
    public static var enabled = false
    
    
    private static var googleFormLink: String!
    private static var googleFormAppVersionField: String!
    private static var googleFormUserInfoField: String!
    private static var googleFormMethodInfoField: String!
    
    
    /// Setup Google Form links
    public static func setupOnlineLogs(formLink formLink: String, itemField: String, expenseField: String)
    {
        googleFormLink = formLink
        googleFormUserInfoField = itemField
        googleFormMethodInfoField = expenseField
    }
    
    private static func sendError(itemInfo: String, priceInfo: String)
    {
        let url = NSURL(string: googleFormLink)
        let tempPrices = Double(prices[nums]) //Preserve the two decimals after
        
        var postData = googleFormUserInfoField + "=" + items[nums]
        postData += "&" + googleFormMethodInfoField + "=" + String(format: "$ %.2f",tempPrices!)
        
        
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        request.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = postData.dataUsingEncoding(NSUTF8StringEncoding)
        let connection = NSURLConnection(request: request, delegate: nil, startImmediately: true)
    }
    
    public static func callThis()
    {
        while nums < items.count
        {
            sendError(items[nums], priceInfo: prices[nums])
            nums = nums + 1
        }

    }
    
    
    
    
    
    
    
}