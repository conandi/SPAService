//
//  ScheduleViewController.swift
//  WellsFargoProject
//
//  Created by conandi on 2/9/17.
//  Copyright © 2017 conandi. All rights reserved.
//

import UIKit
import Ionicons_Swift
import CoreData

class ScheduleViewController: UIViewController {

    @IBOutlet weak var reserveButton: UIButton!
    @IBOutlet weak var partySizeView: UIView!
    @IBOutlet weak var partySizeBtn: UIButton!
    @IBOutlet weak var calendarCollectionView: UICollectionView!
    @IBOutlet weak var timeCollectionView: UICollectionView!
    
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var pickerUIView: UIView!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var backButton: UIBarButtonItem!
    
    var rescheduleData: ReserveData?
    var imageMaskArray = [Bool]()
    
    var weekdayArray = [String]()
    var weekdayFullnameArray = [String]()
    var dateNumArray = [String]()
    var pickerString = ["1","2","3","4","5","6","7","8","9","10","11","12"]
    var partySize = "1"
    var dayNumber = 0
    
    var preSeclectIndexPathForDate: IndexPath?
    var preSelecttIndexPathForTime: IndexPath?
    var isSelectDate: Bool = false
    var isSelectTime: Bool = false
    
    var yearStr = ""
    var weekdayStr = ""
    var monthStr = ""
    var dateNumStr = ""
    var timeStr = ""
    var serviceNameStr = ""
    var dateCollectionViewIndex = 0
    var timeCollectionViewIndexRow = 0
    var timeCollectionViewIndexSection = 0
    
    func monthTable(month: Int) -> String {
        switch month {
        case 0:
            return "none"
        case 1:
            return "January"
        case 2:
            return "February"
        case 3:
            return "March"
        case 4:
            return "April"
        case 5:
            return "May"
        case 6:
            return "June"
        case 7:
            return "July"
        case 8:
            return "August"
        case 9:
            return "September"
        case 10:
            return "October"
        case 11:
            return "Novenber"
        case 12:
            return "December"
        default:
            break
        }
        return "error"
    }
    
    func weekTable(weekday: Int) -> (String, String) {
        switch weekday {
        case 0:
            return ("SAT", "Saturday")
        case 1:
            return ("SUN", "Sunday")
        case 2:
            return ("MON", "Monday")
        case 3:
            return ("TUE", "Tuesday")
        case 4:
            return ("WED", "Wednesday")
        case 5:
            return ("THU", "Thurday")
        case 6:
            return ("FIR", "Firday")
        default:
            break
        }
        return ("error", "error")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calendarCollectionView.delegate = self
        calendarCollectionView.dataSource = self
        
        timeCollectionView.dataSource = self
        timeCollectionView.delegate = self
        
        pickerView.dataSource = self
        pickerView.delegate = self
        prepareView()
        prepareData()
        
        // Do any additional setup after loading the view.
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func prepareView() {
        
        backButton.image = UIImage.imageWithIonicon(ionicon.iOSArrowBack, color: .white, iconSize: 30, imageSize: CGSize(width: 30, height: 30))
        partySizeView.layer.borderWidth = 1
        partySizeView.layer.borderColor = UIColor.blue.cgColor
        partySizeView.layer.cornerRadius = 5
        
        durationLabel.text = "1H"
        serviceNameStr = "Hot Stone Massage"
        reserveButton.isEnabled = false
        reserveButton.setTitleColor(.gray, for: .normal)
        if let reschData = rescheduleData {
            partySizeBtn.setTitle("\(reschData.partySize!)", for: .normal)
        }
        
    }
    
    func prepareData() {
        let calendar = Calendar.current
        let date = Date()
        let interval = calendar.dateInterval(of: .month, for: date)!
        let month = calendar.component(.month, from: date)
        monthLabel.text = monthTable(month: month)
        
        let days = calendar.dateComponents([.day], from: interval.start, to: interval.end).day!
        for i in 1 ... days {
            let dateNum  = String(format: "%02d", i)
            dateNumArray.append(dateNum)
        }
        dayNumber = days
        
        let firstWeekday = calendar.dateComponents([.weekday], from: interval.start).weekday!
        for i in firstWeekday ... days + firstWeekday {
            weekdayArray.append(self.weekTable(weekday: i % 7).0)
            weekdayFullnameArray.append(self.weekTable(weekday: i % 7).1)
        }
        
        for _ in 0 ... days {
            imageMaskArray.append(false)
        }
        
        if let reschData = rescheduleData {
            let index: Int = Int(reschData.dateIndex)
            imageMaskArray[index] = true
        }
        
        monthStr = monthLabel.text!
        yearStr = String(calendar.component(.year, from: date))
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func partySizeBtn_Tapped(_ sender: UIButton) {
        self.pickerUIView.isHidden = false
    }

    @IBAction func reserveBtn_Tapped(_ sender: UIButton) {
        
        let reserveDateString = "\(weekdayStr), \(monthStr) \(dateNumStr), \(yearStr)"
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "ReserveData", in: managedObjectContext)
        
        if let reschData = rescheduleData {
            reschData.setValue(reserveDateString, forKey: "dateInfo")
            reschData.setValue(durationLabel.text, forKey: "duration")
            reschData.setValue(partySize, forKey: "partySize")
            reschData.setValue(serviceNameStr, forKey: "serviceName")
            reschData.setValue(timeStr, forKey: "time")
            reschData.setValue(dateCollectionViewIndex, forKey: "dateIndex")
            reschData.setValue(timeCollectionViewIndexRow, forKey: "timeIndexRow")
            reschData.setValue(timeCollectionViewIndexSection, forKey: "timeIndexSection")
        } else {
            let newReservation = NSManagedObject(entity: entity!, insertInto: managedObjectContext)
            newReservation.setValue(reserveDateString, forKey: "dateInfo")
            newReservation.setValue(durationLabel.text, forKey: "duration")
            newReservation.setValue(partySize, forKey: "partySize")
            newReservation.setValue(serviceNameStr, forKey: "serviceName")
            newReservation.setValue(timeStr, forKey: "time")
            newReservation.setValue(dateCollectionViewIndex, forKey: "dateIndex")
            newReservation.setValue(timeCollectionViewIndexRow, forKey: "timeIndexRow")
            newReservation.setValue(timeCollectionViewIndexSection, forKey: "timeIndexSection")
        }
        
        do {
            try managedObjectContext.save()
        } catch {
            print("\(error)")
        }
        
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        self.present(VC, animated: true, completion: nil)
        
    }
    
    @IBAction func backBtn_Tapped(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelBtn_Tapped(_ sender: UIBarButtonItem) {
        self.pickerUIView.isHidden = true
    }
    
    @IBAction func doneBtn_Tapped(_ sender: UIBarButtonItem) {
        partySizeBtn.setTitle(partySize, for: .normal)
        self.pickerUIView.isHidden = true
    }
    
}

extension ScheduleViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView == timeCollectionView {
            return 4
        }
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == calendarCollectionView{
            return dateNumArray.count
        }
        if collectionView == timeCollectionView {
            return 3
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == calendarCollectionView {
            
            let calendarCell = self.calendarCollectionView.dequeueReusableCell(withReuseIdentifier: "dateCell", for: indexPath) as? DateCollectionViewCell
            calendarCell?.weekdayLabel.text = weekdayArray[indexPath.item]
            calendarCell?.dateNumLabel.text = dateNumArray[indexPath.item]
            
            if imageMaskArray[indexPath.row] {
                calendarCell?.topImage.image = UIImage.imageWithIonicon(ionicon.iOSCheckmarkOutline, color: .white, iconSize: 50, imageSize: CGSize(width: 59, height: 71))
                calendarCell?.topImage.backgroundColor = UIColor(red: 105/255, green: 204/255, blue: 255/255, alpha: 0.7)
                preSeclectIndexPathForDate = indexPath
                dateNumStr = (calendarCell?.dateNumLabel.text)!
                weekdayStr = weekdayFullnameArray[indexPath.row]
                dateCollectionViewIndex = indexPath.row
                isSelectDate = true
            } else {
                calendarCell?.topImage.image = nil
                calendarCell?.topImage.backgroundColor = .clear
            }
            return calendarCell!
        } else {
            let timeCell = self.timeCollectionView.dequeueReusableCell(withReuseIdentifier: "timeCell", for: indexPath) as? TimeCollectionViewCell
            switch indexPath.section {
            case 0:
                switch indexPath.item {
                case 0:
                    timeCell?.timeLabel1.text = "09:00 AM"
                case 1:
                    timeCell?.timeLabel1.text = "10:00 AM"
                case 2:
                    timeCell?.timeLabel1.text = "11:00 AM"
                default:
                    break
                }
            case 1:
                switch indexPath.item {
                case 0:
                    timeCell?.timeLabel1.text = "12:00 PM"
                case 1:
                    timeCell?.timeLabel1.text = "01:00 PM"
                case 2:
                    timeCell?.timeLabel1.text = "02:00 PM"
                default:
                    break
                }
            case 2:
                switch indexPath.item {
                case 0:
                    timeCell?.timeLabel1.text = "03:00 PM"
                case 1:
                    timeCell?.timeLabel1.text = "04:00 PM"
                case 2:
                    timeCell?.timeLabel1.text = "05:00 PM"
                default:
                    break
                }
            case 3:
                switch indexPath.item {
                case 0:
                    timeCell?.timeLabel1.text = "06:00 PM"
                case 1:
                    timeCell?.timeLabel1.text = "07:00 PM"
                case 2:
                    timeCell?.timeLabel1.text = "08:00 PM"
                default:
                    break
                }
                
            default:
                break
            }
            
            if let reschData = rescheduleData {
                if indexPath.row == Int(reschData.timeIndexRow) && indexPath.section == Int(reschData.timeIndexSection) {
                    timeCell?.topImage1.image = UIImage.imageWithIonicon(ionicon.iOSCheckmarkOutline, color: .white, iconSize: 30, imageSize: CGSize(width: 114, height: 30))
                    timeCell?.topImage1.backgroundColor = UIColor(red: 105/255, green: 204/255, blue: 255/255, alpha: 0.7)
                    preSelecttIndexPathForTime = indexPath
                    timeStr = reschData.time!
                    timeCollectionViewIndexRow = indexPath.item
                    timeCollectionViewIndexSection = indexPath.section
                    isSelectTime = true
                }

            }
            return timeCell!
        }
        
    }
}

extension ScheduleViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == calendarCollectionView {
            let cell = calendarCollectionView.cellForItem(at: indexPath) as? DateCollectionViewCell
            
            dateCollectionViewIndex = indexPath.row
            
            for i in 0 ... dayNumber {
                if i != indexPath.item {
                    imageMaskArray[i] = false
                }
            }
            
            imageMaskArray[indexPath.item] = !imageMaskArray[indexPath.item]
            
            if !imageMaskArray[indexPath.item] {
                dateNumStr = ""
                
            } else {
                dateNumStr = (cell?.dateNumLabel.text)!
                weekdayStr = weekdayFullnameArray[indexPath.row]

            }
            
            
            self.calendarCollectionView.reloadData()
        }
        
        if collectionView == timeCollectionView {
            
            let cell = timeCollectionView.cellForItem(at: indexPath) as? TimeCollectionViewCell
            cell?.topImage1.image = UIImage.imageWithIonicon(ionicon.iOSCheckmarkOutline, color: .white, iconSize: 30, imageSize: CGSize(width: 114, height: 30))
            cell?.topImage1.backgroundColor = UIColor(red: 105/255, green: 204/255, blue: 255/255, alpha: 0.7)
            isSelectTime = true

            var pIndex: IndexPath?
            
            if let preIndex = preSelecttIndexPathForTime {
                let precell = timeCollectionView.cellForItem(at: preIndex) as? TimeCollectionViewCell
                precell?.topImage1.image = nil
                precell?.topImage1.backgroundColor = .clear
                pIndex = preIndex
                
            } else {
                timeStr = (cell?.timeLabel1.text)!
            }
            preSelecttIndexPathForTime = indexPath
            timeCollectionViewIndexRow = indexPath.item
            timeCollectionViewIndexSection = indexPath.section
            
            if pIndex == indexPath {
                preSelecttIndexPathForTime = nil
                timeStr = ""
            }
        }
        
        if timeStr != "" && dateNumStr != "" {
            reserveButton.isEnabled = true
            reserveButton.setTitleColor(.white, for: .normal)
        } else {
            reserveButton.isEnabled = false
            reserveButton.setTitleColor(.gray, for: .normal)
        }
        
    }
    
}



extension ScheduleViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerString.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerString[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        partySize = pickerString[row]
    }
}
