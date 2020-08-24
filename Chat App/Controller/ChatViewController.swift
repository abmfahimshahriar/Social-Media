//
//  ChatViewController.swift
//  Chat App
//
//  Created by Fahim Shahriar on 9/8/20.
//  Copyright © 2020 Fahim Shahriar. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class ChatViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    
    let db = Firestore.firestore()
    
    var messages: [Message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //to interact with each cell in table view need to set the delegate to self
        //tableView.delegate = self
        tableView.dataSource = self
        title = Constants.appName
        navigationItem.hidesBackButton = true
        // need to register the external tableview cell design to work with
        tableView.register(UINib(nibName: Constants.cellNibName, bundle: nil), forCellReuseIdentifier: Constants.cellIdentifier)
        loadMessages()
    }
    
    func loadMessages() {
        
        db.collection(Constants.FStore.collectionName).order(by: Constants.FStore.dateField).addSnapshotListener { (querySnapshot, error) in
            
            self.messages = []
            
            if let e = error {
                print("there was an issue retrieving the data \(e)")
            }
            else {
                if let snapshotDocuments = querySnapshot?.documents {
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        
                        if let messageSender = data[Constants.FStore.senderField] as? String, let messageBody = data[Constants.FStore.bodyField] as? String {
                            let newMessage = Message(sender: messageSender, body: messageBody)
                            self.messages.append(newMessage)
                            
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                                let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                                self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                            }
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        if let messageBody = messageTextField.text,let messageSender = Auth.auth().currentUser?.email {
            db.collection(Constants.FStore.collectionName).addDocument(data: [
                Constants.FStore.senderField: messageSender,
                Constants.FStore.bodyField: messageBody,
                Constants.FStore.dateField: Date().timeIntervalSince1970
            ]) { (error) in
                if let e = error {
                    print("there was an error while saving data \(e)")
                }
                else {
                    DispatchQueue.main.async {
                        self.messageTextField.text = ""
                    }
                    print("saved data successfully")
                }
            }
        }
        
    }
    
    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
        }
          
    }
    
}

extension ChatViewController: UITableViewDataSource{
    // counts the number of data to be shown in the tableview cells and returns to the next function
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    // renders tableview cell as the count provided by the previous function
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier, for: indexPath) as! MessageCell
        cell.label.text = message.body
        
//        //if the sender is the currentuser
//        if message.sender == Auth.auth().currentUser?.email {
//            cell.leftImageView.isHidden = true
//            cell.rightImageView.isHidden = false
//            cell.messageBubble.backgroundColor = UIColor(named: Constants.BrandColors.lightPurple)
//            cell.label.textColor = UIColor(named: Constants.BrandColors.purple)
//        }
//            //if the sender is not the current user
//        else {
//            cell.leftImageView.isHidden = false
//            cell.rightImageView.isHidden = true
//            cell.messageBubble.backgroundColor = UIColor(named: Constants.BrandColors.purple)
//            cell.label.textColor = UIColor(named: Constants.BrandColors.lightPurple)
//        }
        
        
        return cell
    }
    
    
}


// to interact with each of the cell in table view
//extension ChatViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(indexPath.row)
//    }
//}
