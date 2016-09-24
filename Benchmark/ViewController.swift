//
//  ViewController.swift
//  Benchmark
//
//  Created by David Franko on 9/22/16.
//  Copyright © 2016 David Franko. All rights reserved.
//

import Cocoa


class ViewController: NSViewController {

    
    
    
//    MARK - IBOUTLETS VARS
    
    @IBOutlet weak var randomNumberLabel: NSTextField!
    
    @IBOutlet weak var randomGenerateButton: NSButton!
    
    @IBOutlet weak var saveDataButton: NSButton!
    
    @IBOutlet weak var bigTextField: NSScrollView!
    
    @IBOutlet weak var readDataButton: NSButton!
    
    
//    MARK - PERSONAL VARIABLES
    
    var dataArray = [String]()
    
    var readedDataArray = [Int]()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        FIRST STEP, GENERATE N RANDOM NUMBERS
        
        randomGenerateButton.target = self
        randomGenerateButton.action = #selector(generateNewNumber)
        
        
//        SECOND STEP, SAVE AND LOAD
        
        saveDataButton.target = self
        saveDataButton.action = #selector(writeFile)
        
        readDataButton.target = self
        readDataButton.action = #selector(readData)
        
        
//        THIRD STEP, GET METRICS...
        
        
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    
    func generateNewNumber() {
        
//        GETTING CURRENT DATE/TIME
        var cDate = self.getCurrentTime()
        print("Start time: ", cDate)
        
        
        for _ in 1...10000000 {
            let randomNum = self.random64(Int64.max)
            self.dataArray.append("\(randomNum)")
        }
        cDate = self.getCurrentTime()
        
        print("\nThe DataArray size is: ", self.dataArray.count, " and the last value is: ", self.dataArray[self.dataArray.count - 1])
        print("\nFinal time: ", cDate)
        
    }
    
    
//    GETTING CURRENT DATE
    func getCurrentTime() -> String {
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Hour, .Minute, .Second, .Nanosecond], fromDate: date)
        let hour = components.hour
        let minute = components.minute
        let second = components.second
        let nanosecond = components.nanosecond
        return "\(hour):\(minute):\(second):\(nanosecond)"
    }

    

//    GENERATING RANDOM INT64 NUMBER
    func random64(upper_bound: Int64) -> Int64 {
        // Generate 64-bit random value in a range that is
        // divisible by upper_bound:
        let range = Int64.max - Int64.max % upper_bound
        var rnd : Int64 = 0
        repeat {
            arc4random_buf(&rnd, sizeofValue(rnd))
        } while rnd >= range
        
        return rnd % upper_bound
    }
    
    
//    RETURN THE DIFFERENCE BETWEEN TWO DATES
    func getTime(startTime: NSDate, endTime: NSDate) {
        
        
        let calendar = NSCalendar(calendarIdentifier: "gregorian")
        let components : NSDateComponents = (calendar?.components(.NSCalendarCalendarUnit, fromDate: startTime, toDate: endTime, options: NSCalendarOptions()))!
        
        
        
    
    }
    
    
    
}


extension ViewController {

    func writeFile() {
        
        let strings = dataArray
        let file = "file.txt"
        
        
        let joinedString = strings.joinWithSeparator("\n")
        
        if let dir = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory,
                                                         NSSearchPathDomainMask.AllDomainsMask, true).first {
            
            let path = NSURL(fileURLWithPath: dir).URLByAppendingPathComponent(file)
            do {
                try joinedString.writeToURL(path, atomically: false, encoding: NSUTF8StringEncoding)
            } catch {
                
            }
        }
        
    }
    
    
    func readData() {
        
        let file = "file.txt" //this is the file. we will write to and read from it
        var lines = [String]()
        
        if let dir = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true).first {
            let path = NSURL(fileURLWithPath: dir).URLByAppendingPathComponent(file)
            
            do {
                let text2 = try NSString(contentsOfURL: path, encoding: NSUTF8StringEncoding)
                let texV = NSTextView(frame: CGRectMake(0, 0, 200,200))
                texV.textStorage?.appendAttributedString(NSAttributedString(string: text2 as String))
    
                bigTextField.documentView = texV
                lines = text2.componentsSeparatedByString("\n")
            }
            catch {/* error handling here */}
        }
        
        for line in lines {
            readedDataArray.append(Int(line)!)
        }
        print("@@@@ TO BEGIN TEST -------------")
        self.test()
    }


    func test() {
    
        let date1 = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Hour, .Minute, .Second, .Nanosecond], fromDate: date1)
        
        let nanosecond = components.nanosecond
        print(date1, " | ", nanosecond , " mili: ", date1.timeIntervalSince1970 * 1000)
        var sds = [String]()
        for it in readedDataArray {
            sds.append("\(it)")
        }
        for it in readedDataArray {
            sds.append("\(it)")
        }
        for it in readedDataArray {
            sds.append("\(it)")
        }
        for it in readedDataArray {
            sds.append("\(it)")
        }
            
        let date2 = NSDate()
        let calendar2 = NSCalendar.currentCalendar()
        let components2 = calendar2.components([.Hour, .Minute, .Second, .Nanosecond], fromDate: date2)
        
        let nanosecond2 = components2.nanosecond
        print(date2, " | ", nanosecond2, " mili: ", date2.timeIntervalSince1970 * 1000)
        
        
        print(date2.hoursFrom(date1))
        print(date2.minutesFrom(date1))
        print(date2.secondsFrom(date1))
        print(date2.nanoSecondsFrom(date1))
        
    }



}






//    EXTRACTED FROM http://stackoverflow.com/questions/27182023/getting-the-difference-between-two-nsdates-in-months-days-hours-minutes-seconds
extension NSDate {
    func yearsFrom(date: NSDate) -> Int {
        return NSCalendar.currentCalendar().components(.Year, fromDate: date, toDate: self, options: []).year
    }
    func monthsFrom(date: NSDate) -> Int {
        return NSCalendar.currentCalendar().components(.Month, fromDate: date, toDate: self, options: []).month
    }
    func weeksFrom(date: NSDate) -> Int {
        return NSCalendar.currentCalendar().components(.WeekOfYear, fromDate: date, toDate: self, options: []).weekOfYear
    }
    func daysFrom(date: NSDate) -> Int {
        return NSCalendar.currentCalendar().components(.Day, fromDate: date, toDate: self, options: []).day
    }
    func hoursFrom(date: NSDate) -> Int {
        return NSCalendar.currentCalendar().components(.Hour, fromDate: date, toDate: self, options: []).hour
    }
    func minutesFrom(date: NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Minute, fromDate: date, toDate: self, options: []).minute
    }
    func secondsFrom(date: NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Second, fromDate: date, toDate: self, options: []).second
    }
    func nanoSecondsFrom(date: NSDate) -> Int {
        return NSCalendar.currentCalendar().components(.Nanosecond, fromDate: date, toDate: self, options: []).nanosecond
    }
    
    func offsetFrom(date: NSDate) -> String {
        if yearsFrom(date)   > 0 { return "\(yearsFrom(date))y"   }
        if monthsFrom(date)  > 0 { return "\(monthsFrom(date))M"  }
        if weeksFrom(date)   > 0 { return "\(weeksFrom(date))w"   }
        if daysFrom(date)    > 0 { return "\(daysFrom(date))d"    }
        if hoursFrom(date)   > 0 { return "\(hoursFrom(date))h"   }
        if minutesFrom(date) > 0 { return "\(minutesFrom(date))m" }
        if secondsFrom(date) > 0 { return "\(secondsFrom(date))s" }
        if nanoSecondsFrom(date) > 0 {return "\(nanoSecondsFrom(date))ns"}
        return ""
    }
}