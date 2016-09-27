//
//  ViewController.swift
//  Benchmark
//
//  Created by David Franko on 9/22/16.
//  Copyright © 2016 David Franko. All rights reserved.
//

import Cocoa
import Darwin

class ViewController: NSViewController {

    
    
    
//    MARK - IBOUTLETS VARS
    
    @IBOutlet weak var randomGenerateButton: NSButton!
    
    @IBOutlet weak var randomGenerateButtomDouble: NSButton!
    
    @IBOutlet weak var saveDataButton: NSButton!
    
    @IBOutlet weak var bigTextField: NSScrollView!
    
    @IBOutlet weak var readDataButton: NSButton!
    
    @IBOutlet weak var comboBox: NSComboBox!
    
    
    
    
//    MARK - PERSONAL VARIABLES
    
    var dataArray = [String]()
    
    var readedDataArrayForInt = [Int]()
    var readedDataArrayForDouble = [Double]()
    let texV = NSTextView(frame: CGRectMake(0, 0, 200,200))
    
    var control = ""
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        FIRST STEP, GENERATE N RANDOM NUMBERS

        randomGenerateButton.target = self
        randomGenerateButton.action = #selector(generateNewNumber)
        
        randomGenerateButtomDouble.target = self
        randomGenerateButtomDouble.action = #selector(generateDoubleNumbers)
        
        
//        SECOND STEP, SAVE AND LOAD
        
        saveDataButton.target = self
        saveDataButton.action = #selector(writeFile)
        
        readDataButton.target = self
        readDataButton.action = #selector(readData)
        
        
//        THIRD STEP, GET METRICS...
        texV.frame = self.bigTextField.frame
        bigTextField.documentView = texV
        
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    
    func generateNewNumber() {
        
        
        control = "INT"
        self.dataArray.removeAll()

        self.printInConsoleController("\n@ GENERATING 10000000 INT VALUES ---------")
        
        let date1 = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Hour, .Minute, .Second, .Nanosecond], fromDate: date1)
        
        self.printInConsoleController("Generating Int Values Start: \(date1) | \(components.hour):\(components.minute):\(components.second):\(components.nanosecond)")
        
        
        
        for _ in 1...10000000 {
            let randomNum = self.random64(Int64.max)
            self.dataArray.append("\(randomNum)")
        }
        
        let date2 = NSDate()
        let calendar2 = NSCalendar.currentCalendar()
        let components2 = calendar2.components([.Hour, .Minute, .Second, .Nanosecond], fromDate: date1)
        
        self.printInConsoleController("Generating Int Values End: \(date2) | \(components2.hour):\(components2.minute):\(components2.second):\(components2.nanosecond)")
        
        self.printInConsoleController("difference: \(date2.hoursFrom(date1)):\(date2.minutesFrom(date1)):\(date2.secondsFrom(date1)):\(date2.nanoSecondsFrom(date1))")
        
        
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

    
    
    
}


extension ViewController {

    func writeFile() {
        
        
        let strings = dataArray
        var file = "file.txt"
        if control == "INT" {
            file = "IntFile.txt"
        } else if (control == "DOUBLE") {
            file = "DoubleFile.txt"
        } else {
            printInConsoleController("Error Saving Data, please Generate Data")
            return
        }
        
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
        
        var file = "file.txt" //this is the file. we will write to and read from it
        
        if (comboBox.objectValueOfSelectedItem == nil) {
            printInConsoleController("Error Reading, please select any data type")
            return
        }
        var type = String()
        
        if (comboBox.objectValueOfSelectedItem as! String) == "Integer" {
            file = "IntFile.txt"
            type = "INTS"
        } else if ((comboBox.objectValueOfSelectedItem as! String) == "Double") {
            file = "DoubleFile.txt"
            type = "DOUBLES"
        }
        
        
        let date1 = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Hour, .Minute, .Second, .Nanosecond], fromDate: date1)
        
        self.printInConsoleController("\n@READING \(type) ----------\n")
        self.printInConsoleController("reading data begins: \(date1) | \(components.hour):\(components.minute):\(components.second):\(components.nanosecond)")
        
        
        
        var lines = [String]()
        
        if let dir = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true).first {
            let path = NSURL(fileURLWithPath: dir).URLByAppendingPathComponent(file)
            
            do {
                let text2 = try NSString(contentsOfURL: path, encoding: NSUTF8StringEncoding)
                lines = text2.componentsSeparatedByString("\n")
            }
            catch {/* error handling here */}
        }
        
        
        
        
        
        for line in lines {
            
            
            if (comboBox.objectValueOfSelectedItem as! String) == "Integer" {
                readedDataArrayForInt.append(Int(line)!)
            } else {
                readedDataArrayForDouble.append(Double(line)!)
            }
            
        }
        
        let date2 = NSDate()
        
        let calendar2 = NSCalendar.currentCalendar()
        let components2 = calendar2.components([.Hour, .Minute, .Second, .Nanosecond], fromDate: date2)
        
        self.printInConsoleController("reading data ends: \(date2) | \(components2.hour):\(components2.minute):\(components2.second):\(components2.nanosecond)")
        self.printInConsoleController("difference: \(date2.hoursFrom(date1)):\(date2.minutesFrom(date1)):\(date2.secondsFrom(date1)):\(date2.nanoSecondsFrom(date1))")
    
//        self.test()
        self.sum(readedDataArrayForInt)
    }


    func test() {
    
        let date1 = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Hour, .Minute, .Second, .Nanosecond], fromDate: date1)
        
        self.printInConsoleController("\n@@@@ TO BEGIN TEST -------------\n")
        
        self.printInConsoleController("Test begins: \(date1) | \(components.hour):\(components.minute):\(components.second):\(components.nanosecond)")
        
        var sds = [String]()
        
        if (comboBox.objectValueOfSelectedItem as! String) == "Integer" {
            for it in readedDataArrayForInt {
                sds.append("\(it)")
            }
        } else {
            for it in readedDataArrayForDouble {
                sds.append("\(it)")
            }
        }
        
            
        let date2 = NSDate()
        let calendar2 = NSCalendar.currentCalendar()
        let components2 = calendar2.components([.Hour, .Minute, .Second, .Nanosecond], fromDate: date2)
        
        self.printInConsoleController("Test ends: \(date2) | \(components2.hour):\(components2.minute):\(components2.second):\(components2.nanosecond)")
        self.printInConsoleController("difference: \(date2.hoursFrom(date1)):\(date2.minutesFrom(date1)):\(date2.secondsFrom(date1)):\(date2.nanoSecondsFrom(date1))")
        
    }

    
    
    
    func printInConsoleController(text: String) {
        texV.textStorage?.appendAttributedString(NSAttributedString(string: "\(text)\n"))
        print("\(text)\n")
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





//    DOUBLE MODULE

extension ViewController {
    

    func generateDoubleNumbers() {
        
        control = "DOUBLE"
        self.dataArray.removeAll()

        self.printInConsoleController("\n@ GENERATING 10000000 DOUBLE VALUES ---------")
        
        let date1 = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Hour, .Minute, .Second, .Nanosecond], fromDate: date1)
        
        self.printInConsoleController("Generating Double Values Start: \(date1) | \(components.hour):\(components.minute):\(components.second):\(components.nanosecond)")
        
        
        for _ in 1...10000000 {
            let randomNum = self.randomDouble(DBL_MAX)
            self.dataArray.append("\(randomNum)")
        }
        
        
        let date2 = NSDate()
        let calendar2 = NSCalendar.currentCalendar()
        let components2 = calendar2.components([.Hour, .Minute, .Second, .Nanosecond], fromDate: date1)
        
        self.printInConsoleController("Generating Double Values End: \(date2) | \(components2.hour):\(components2.minute):\(components2.second):\(components2.nanosecond)")
        
        self.printInConsoleController("difference: \(date2.hoursFrom(date1)):\(date2.minutesFrom(date1)):\(date2.secondsFrom(date1)):\(date2.nanoSecondsFrom(date1))")
        
        
    }
    
    
    func randomDouble(upper_bound: Double) -> Double {
        // Generate 64-bit random value in a range that is
        // divisible by upper_bound:
        let range = DBL_MAX - DBL_MIN % upper_bound
        var rnd : Double = 0
        repeat {
            arc4random_buf(&rnd, sizeofValue(rnd))
        } while rnd >= range
        
        return rnd % upper_bound
    }
    
}




//  MATH MODULE AND QUICKSORT
extension ViewController {

    func quickSort(data: [AnyObject]) {
        var bla = [AnyObject]()
        
        if control == "INT" {
            bla = data as! [Int]
        } else {
            bla = data as! [Double]
        }
        
        
    }
    
    
    func sum(data: [AnyObject]) {
        
        print("empezará suma")
        if (comboBox.objectValueOfSelectedItem as! String) == "Integer" {
            
            print("data:", data.count)
            print(((data[3] as! Int) + 1))
        
            var sum = Int()
            for i in 0...(data.count - 1) {
                if (i + 1) == data.count {
                    sum = (data[i] as! Int) + (data[i] as! Int)
                    break
                }
                print(((data[i] as! Int) + 1))
                print(((data[i + 1] as! Int) + 1))
                sum = (data[i] as! Int) + (data[i + 1] as! Int)
//                No cabe el Int
            }
            
            print("terminó")
        } else {
            
        }
        
    }
    
    func mult(data: [AnyObject]) {
        var bla = [AnyObject]()
        
        if control == "INT" {
            bla = data as! [Int]
        } else {
            bla = data as! [Double]
        }
        
        
        
    }
    
    func div(data: [AnyObject]) {
        var bla = [AnyObject]()
        
        if control == "INT" {
            bla = data as! [Int]
        } else {
            bla = data as! [Double]
        }
    }
    
    func res(data: [AnyObject]) {
        var bla = [AnyObject]()
        
        if control == "INT" {
            bla = data as! [Int]
        } else {
            bla = data as! [Double]
        }
    }
    
}



