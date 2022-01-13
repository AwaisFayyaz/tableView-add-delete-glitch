//
//  ViewController.swift
//  TableView-BatchUpdates
//
//  Created by Awais Fayyaz on 01/10/2021.
//

import UIKit

class ViewController: UIViewController {

  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var fieldSendMessage: UITextField!
    
  var originalArray: [String] = []
  var updatedArray: [String] = []
    
  let cellID = "cell"
  var messsageSendingCounter = 100
  
  var scrollInProgress = false
  var removalInProgress = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.delegate = self
    tableView.dataSource = self
    
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
    
    for i in 1...100 {
      originalArray.append("\(i)")
    }
    
    fieldSendMessage.text = "\(messsageSendingCounter )"
    updatedArray = originalArray
    tableView.reloadData()
    scrollToBottom()
    
    Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { timer in
      
      if self.scrollInProgress { return }
      print("Inside second timer")
      self.removalInProgress = true
      let updates = {

        let rowToDelete = 0
        self.updatedArray.remove(at: rowToDelete)
        let indexPath = IndexPath.init(row: rowToDelete, section: 0)
        self.tableView.deleteRows(at: [indexPath], with: .fade)
      }
      let completion = { (success: Bool) in
        self.removalInProgress = false
        print("completion")
      }
      self.tableView.performBatchUpdates(updates, completion: completion)
    }
  }
  
  func scrollToBottom() {
    if removalInProgress { return }
    scrollInProgress = true
    let lastIndexPath = IndexPath.init(row: updatedArray.count - 1, section: 0)
    tableView.scrollToRow(at: lastIndexPath, at: .bottom, animated: true)
    scrollInProgress = false
  }
  
  
  @IBAction func btnSendTapped(_ sender: Any) {
    guard let searchText = fieldSendMessage.text, !searchText.isEmpty else {
      return
    }
    //tableView.beginUpdates()
    updatedArray.append(searchText)
    
//    let indexPathRow = updatedArray.count - 1
//    tableView.insertRows(at: [IndexPath.init(row: indexPathRow, section: 0)], with: .automatic)
//    tableView.endUpdates()
    
    tableView.reloadData()
    scrollToBottom()
    messsageSendingCounter += 1
    fieldSendMessage.text = "\(messsageSendingCounter)"
  }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return updatedArray.count
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: cellID)
    cell?.textLabel?.text = updatedArray[indexPath.row]
    cell?.textLabel?.font = UIFont.boldSystemFont(ofSize: 20)
    return cell!
  }
}



//  @IBAction func btnTapped(_ sender: Any) {
//
//    tableView.performBatchUpdates {
//
//      updatedArray = [
//        "bob [17]",  // this row has had its value updated
//        "chloe [13]",
//        "anna [19]", // this row has moved from its previous position of index 0
//    ]
//
//      tableView.reloadRows(at: [IndexPath.init(row: 1, section: 0)], with: .automatic)
//
//      tableView.moveRow(at: IndexPath.init(row: 0, section: 0), to: IndexPath.init(row: 2, section: 0))
//
//
////      let indexPathsToDelete = [IndexPath.init(row: 1, section: 0)]
////      tableView.deleteRows(at: indexPathsToDelete, with: .automatic)
////      var indexPathsToReload: [IndexPath] = []
////      for (index, _) in updatedArray.enumerated() {
////        indexPathsToReload.append(IndexPath.init(row: index, section: 0))
////      }
////      tableView.reloadRows(at: indexPathsToReload, with: .automatic)
//    } completion: { complete in
//
//    }
//
//
//
//  }

