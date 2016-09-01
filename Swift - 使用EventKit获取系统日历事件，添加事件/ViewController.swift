//
//  ViewController.swift
//  Swift - 使用EventKit获取系统日历事件，添加事件
//
//  Created by 道标朱 on 16/9/1.
//  Copyright © 2016年 道标朱. All rights reserved.
//

import UIKit
import EventKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{

    var eventStore:EKEventStore!
    var reminders:[EKReminder]!
    var tableView:UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Swift - 使用EventKit获取系统日历事件，添加事件
//        let eventStrore:EKEventStore = EKEventStore()
//        eventStrore.requestAccessToEntityType(.Event) { (granted, error) in
//            
//            if(granted) && (error == nil){
//                print("granted\(granted)")
//                print("error\(error)")
//                
//                //新建一个事件
//                let event:EKEvent = EKEvent(eventStore:eventStrore)
//                event.title = "新增加一个测试事件"
//                event.startDate = NSDate()
//                event.endDate = NSDate()
//                event.notes = "这个是备注"
//                event.calendar = eventStrore.defaultCalendarForNewEvents
//                
//                do{
//                    try eventStrore.saveEvent(event, span: .ThisEvent)
//                    print("Saved Event")
//                }catch{}
//                //获取所有的事件（前后90天）
//                let starDate = NSDate().dateByAddingTimeInterval(-3600*24*90)
//                let endDate = NSDate().dateByAddingTimeInterval(3600*24*90)
//                let predicate2 = eventStrore.predicateForEventsWithStartDate(starDate, endDate: endDate, calendars: nil)
//                
//                print("查询范围 开始：\(starDate)结束：\(endDate)")
//                let eV = eventStrore.eventsMatchingPredicate(predicate2) as [EKEvent]!
//                
//                if eV != nil{
//                    for i in eV{
//                        print("标题\(i.title)")
//                        print("开始时间:\(i.startDate)")
//                        print("结束时间:\(i.endDate)")
//                    }
//                }
//            }
//        }
        
        
     //创建表视图
        self.tableView = UITableView(frame: self.view.frame, style: .Plain)
        self.tableView!.delegate = self
        self.tableView!.dataSource = self
        self.view.addSubview(self.tableView!)
    //在取得提醒之前，需要先获取授权
        self.eventStore = EKEventStore()
        self.reminders = [EKReminder]()
        self.eventStore.requestAccessToEntityType(EKEntityType.Reminder) { (granted, error) in
            if granted{
                //获取授权后，我们可以得到所有的提醒事件
                let predicate = self.eventStore.predicateForRemindersInCalendars(nil)
                self.eventStore.fetchRemindersMatchingPredicate(predicate, completion: { ( reminders:[EKReminder]?) in
                    self.reminders = reminders
                    print(self.reminders.count)
                    dispatch_async(dispatch_get_main_queue(), {
                        self.tableView?.reloadData()
                    })
                })
            }else{
                print("获取提醒失败！需要授权允许对提醒事项的访问。")
            }
        }
        
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.reminders.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Subtitle,reuseIdentifier: "mycell")
        let reminder:EKReminder! = self.reminders![indexPath.row]
        
        //提醒事项的内容
        cell.textLabel?.text = reminder.title
        
        //提醒事项的时间
        let formatter:NSDateFormatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        if let dueDate = reminder.dueDateComponents?.date {
            cell.detailTextLabel?.text = formatter.stringFromDate(dueDate)
        }else{
            cell.detailTextLabel?.text = "N/A"
        }
        return cell
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

