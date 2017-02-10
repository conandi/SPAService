//
//  SPAViewController.swift
//  WellsFargoProject
//
//  Created by conandi on 2/9/17.
//  Copyright © 2017 conandi. All rights reserved.
//

import UIKit

class SPAViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var myTimer: Timer!
    var duration = 0.5
    var currentPage = 0
    let imageViewArray = [#imageLiteral(resourceName: "spa1"), #imageLiteral(resourceName: "spa2"),#imageLiteral(resourceName: "spa3"),#imageLiteral(resourceName: "spa1")]
    
//    let button = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.layer.cornerRadius = 10.0
        self.scrollViewConfig()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        myTimer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(SPAViewController.changePage), userInfo: nil, repeats: true)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        myTimer.invalidate()
    }
    
    func scrollViewConfig() {
        
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.isUserInteractionEnabled = true
        scrollView.isScrollEnabled = true
        scrollView.backgroundColor = .white
        
        var xp = 0
        var index = 0
        for image in imageViewArray {
            let imageView = UIImageView()
            let screenWidth = self.view.frame.size.width
            xp = Int(screenWidth) * index
            imageView.frame = CGRect(x: xp, y: 0, width: Int(self.view.frame.size.width), height: Int(self.view.frame.size.height))
            
            imageView.contentMode = UIViewContentMode.scaleToFill
            imageView.image = image
            
            let buttonView = UIView()
            buttonView.frame = CGRect(x: 40 + xp, y: 200, width: 140, height: 40)
            buttonView.backgroundColor = UIColor(red: 45/255, green: 105/255, blue: 190/255, alpha: 0.8)
            
            let button1 = UIButton()
            button1.frame = CGRect(x: 40, y: 210, width: 140, height: 40)
            button1.setTitle("RESERVE", for: .normal)
            button1.backgroundColor = UIColor(red: 45/255, green: 105/255, blue: 190/255, alpha: 0.8)
            button1.titleLabel?.font = UIFont.systemFont(ofSize: 20)
            button1.isEnabled = false
            buttonView.addSubview(button1)
            
            let button2 = UIButton()
            button2.frame = CGRect(x: 40 + Int(screenWidth), y: 210, width: 140, height: 40)
            button2.setTitle("RESERVE", for: .normal)
            button2.backgroundColor = UIColor(red: 45/255, green: 105/255, blue: 190/255, alpha: 0.8)
            button2.titleLabel?.font = UIFont.systemFont(ofSize: 20)
            button2.addTarget(self, action: #selector(SPAViewController.reserveBtn_Tapped), for: .touchUpInside)
            buttonView.addSubview(button2)
            
            let button3 = UIButton()
            button3.frame = CGRect(x: 40 + Int(screenWidth) * 2, y: 210, width: 140, height: 40)
            button3.setTitle("RESERVE", for: .normal)
            button3.backgroundColor = UIColor(red: 45/255, green: 105/255, blue: 190/255, alpha: 0.8)
            button3.titleLabel?.font = UIFont.systemFont(ofSize: 20)
            button3.isEnabled = false
            buttonView.addSubview(button3)
            
            scrollView.addSubview(imageView)
            scrollView.addSubview(button1)
            scrollView.addSubview(button2)
            scrollView.addSubview(button3)

            index += 1
            
        }
        
        
        scrollView.contentSize = CGSize(width: (scrollView.frame.size.width) * CGFloat(imageViewArray.count - 1)+50, height: (scrollView.frame.size.height))
        self.pageControlConfig()
    }
    
    func pageControlConfig() {
        pageControl.numberOfPages = imageViewArray.count - 1
    }
    
    func changePage() {
        UIView.animate(withDuration: duration, animations:{ [unowned self] in
            self.scrollView.setContentOffset(CGPoint(x: self.currentPage * 375, y:0), animated: false)
            self.currentPage += 1
            if self.currentPage > 2 {
                self.duration = 0
                self.currentPage = 0
            } else {
                self.duration = 0.5
            }
            self.loadViewIfNeeded()
        })
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func reserveBtn_Tapped() {
        let scheduleVC = self.storyboard?.instantiateViewController(withIdentifier: "ScheduleViewController") as? ScheduleViewController
        self.present(scheduleVC!, animated: true, completion: nil)
    }

}

extension SPAViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell")
        switch indexPath.row {
        case 0:
            cell?.textLabel?.text = "Swedish Massage"
            cell?.isUserInteractionEnabled = false
            cell?.textLabel?.textColor = .gray
        case 1:
            cell?.textLabel?.text = "Deep Tissue Massage"
            cell?.isUserInteractionEnabled = false
            cell?.textLabel?.textColor = .gray

        case 2:
            cell?.textLabel?.text = "Hot Stone Massage"
        case 3:
            cell?.textLabel?.text = "Reflexology"
            cell?.isUserInteractionEnabled = false
            cell?.textLabel?.textColor = .gray

        case 4:
            cell?.textLabel?.text = "Trigger Point Therapy"
            cell?.isUserInteractionEnabled = false
            cell?.textLabel?.textColor = .gray

        default:
            break
        }
        
        
        cell?.accessoryType = .disclosureIndicator
        return cell!
    }
 
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.tableView.frame.height / 5
    }
}

extension SPAViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: false)
        let scheduleVC = self.storyboard?.instantiateViewController(withIdentifier: "ScheduleViewController") as? ScheduleViewController
        self.present(scheduleVC!, animated: true, completion: nil)
    }
}

extension SPAViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x > 800 {
            scrollView.setContentOffset(CGPoint.zero , animated: false)
        }
        currentPage = Int(round(scrollView.contentOffset.x / scrollView.frame.width))
        pageControl.currentPage = currentPage
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            break
        case 1:
            break
        case 2:
            let scheduleVC = self.storyboard?.instantiateViewController(withIdentifier: "ScheduleViewController") as? ScheduleViewController
            self.present(scheduleVC!, animated: true, completion: nil)
        case 3:
            break
        case 4:
            break
            
        default:
            break
        }
    }
    
}
