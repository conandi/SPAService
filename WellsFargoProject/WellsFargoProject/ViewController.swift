//
//  ViewController.swift
//  WellsFargoProject
//
//  Created by conandi on 2/9/17.
//  Copyright © 2017 conandi. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var fetchResult = [ReserveData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        prepareData()
        prepareView()
        print("Test for new branch!!")

    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func getManageObjectContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    func prepareData() {
        let managedObjectContext = getManageObjectContext()
        let fetchObjectRequest = NSFetchRequest<NSFetchRequestResult>(entityName:"ReserveData")
        
        do {
            fetchResult = try managedObjectContext.fetch(fetchObjectRequest) as! [ReserveData]
        } catch {
            print("\(error)")
        }
    }
    
    func prepareView() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    @IBAction func addBtn_Tapped(_ sender: UIBarButtonItem) {
        let spaVC = self.storyboard?.instantiateViewController(withIdentifier: "SPAViewController") as? SPAViewController
        self.present(spaVC!, animated: true, completion: nil)
    }
    
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchResult.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reservationCell", for: indexPath) as? ReservationCollectionViewCell
        
        cell?.rescheduleDelegate = self
        cell?.cancelBtnDelegate = self
        
        cell?.reservationDate.text = fetchResult[indexPath.item].dateInfo
        cell?.reservationTime.text = fetchResult[indexPath.item].time
        if let partysize = fetchResult[indexPath.item].partySize{
            cell?.partySize.text = "PARTY SIZE - \(partysize)"
        }
        cell?.durationTime.text = fetchResult[indexPath.item].duration
        cell?.serviceName.text = fetchResult[indexPath.item].serviceName
        cell?.descriptionLabel.text = "Massage focused on the deepest layer of muscles to target knots and release chronic muscle tension."
        cell?.rescheduleBtn.layer.cornerRadius = 5.0
        cell?.cancelBtn.layer.cornerRadius = 5.0
        cell?.cancelBtn.tag = indexPath.row
        cell?.rescheduleBtn.tag = indexPath.row
        
        return cell!
    }
}

extension ViewController: ReservationCellDelegate {
    
    func rescheduleBtnDelegate(atIndex tagNum: Int) {
        
        let scheduleVC = self.storyboard?.instantiateViewController(withIdentifier: "ScheduleViewController") as? ScheduleViewController
        scheduleVC?.rescheduleData = fetchResult[tagNum]
        self.present(scheduleVC!, animated: true, completion: nil)
        
    }
    
    func cancelBtnDelegate(atIndex tagNum: Int) {
        
        let managedObjectContext = getManageObjectContext()
        managedObjectContext.delete(fetchResult[tagNum])
        do {
            try managedObjectContext.save()
        } catch {
            print("\(error)")
        }
        
        self.prepareData()
        self.collectionView.reloadData()
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width - 8, height: 261)
    }
}

extension UIViewController {
    func showAlert(withTitle title: String?, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}
