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
    @IBOutlet weak var postTextField: UITextField!
    
    
    let db = Firestore.firestore()
    
    var posts: [Post] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //to interact with each cell in table view need to set the delegate to self
        tableView.delegate = self
        tableView.dataSource = self
        title = Constants.appName
        navigationItem.hidesBackButton = true
        // need to register the external tableview cell design to work with
        tableView.register(UINib(nibName: Constants.cellNibName, bundle: nil), forCellReuseIdentifier: Constants.cellIdentifier)
        loadPosts()
    }
    
    func loadPosts() {
        
        db.collection(Constants.FStore.collectionName).order(by: Constants.FStore.dateField).addSnapshotListener { (querySnapshot, error) in
            
            self.posts = []
            
            if let e = error {
                print("there was an issue retrieving the data \(e)")
            }
            else {
                if let snapshotDocuments = querySnapshot?.documents {
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        let docId = doc.documentID
                        if let postSender = data[Constants.FStore.senderField] as? String,
                            let postBody = data[Constants.FStore.bodyField] as? String,
                            let commentsData = data[Constants.FStore.commentsField] as? [String],
                            let likesData = data[Constants.FStore.likesField] as? [String] {
                            let newPost = Post(id:docId, sender: postSender, body: postBody, comments: commentsData, likes: likesData)
                            self.posts.append(newPost)
                            
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                                let indexPath = IndexPath(row: self.posts.count - 1, section: 0)
                                self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                            }
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        if let postBody = postTextField.text,let postSender = Auth.auth().currentUser?.email {            db.collection(Constants.FStore.collectionName).addDocument(data: [
                Constants.FStore.senderField: postSender,
                Constants.FStore.bodyField: postBody,
                Constants.FStore.dateField: Date().timeIntervalSince1970,
                Constants.FStore.commentsField: [],
                Constants.FStore.likesField: []
            ]) { (error) in
                if let e = error {
                    print("there was an error while saving data \(e)")
                }
                else {
                    DispatchQueue.main.async {
                        self.postTextField.text = ""
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
        return posts.count
    }
    
    // renders tableview cell as the count provided by the previous function
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = posts[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier, for: indexPath) as! PostCell
        cell.label.text = post.body
        
        
        return cell
    }
    
    
}


// to interact with each of the cell in table view
extension ChatViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: Constants.postSegue, sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! PostViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedPost = posts[indexPath.row]
        }
    }
}
