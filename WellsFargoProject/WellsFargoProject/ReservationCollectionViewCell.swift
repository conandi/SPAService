//
//  ReservationCollectionViewCell.swift
//  WellsFargoProject
//
//  Created by conandi on 2/10/17.
//  Copyright © 2017 conandi. All rights reserved.
//

import UIKit

protocol ReservationCellDelegate {
    func rescheduleBtnDelegate(atIndex tagNum: Int)
    func cancelBtnDelegate(atIndex tagNum: Int)
}

class ReservationCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var reservationDate: UILabel!
    @IBOutlet weak var reservationTime: UILabel!
    @IBOutlet weak var serviceName: UILabel!
    @IBOutlet weak var partySize: UILabel!
    @IBOutlet weak var durationTime: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var rescheduleBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    
    var rescheduleDelegate: ReservationCellDelegate?
    var cancelBtnDelegate: ReservationCellDelegate?
    
    @IBAction func rescheduleBtn_Tapped(_ sender: UIButton) {
        rescheduleDelegate?.rescheduleBtnDelegate(atIndex: rescheduleBtn.tag)
    }
    
    @IBAction func cancelBtn_Tapped(_ sender: UIButton) {        
        cancelBtnDelegate?.cancelBtnDelegate(atIndex: cancelBtn.tag)
    }
    
}
