//
//  MessageViewController.swift
//  Chat App
//
//  Created by Fahim Shahriar on 25/8/20.
//  Copyright © 2020 Fahim Shahriar. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class PostViewController: UIViewController {

    @IBOutlet weak var postLabel: UILabel!
    @IBOutlet weak var likesCommentsLabel: UILabel!
    @IBOutlet weak var commentsTableView: UITableView!
    @IBOutlet weak var commentTextField: UITextField!
    
    var selectedPost: Post?
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commentsTableView.dataSource = self
    
        if let post = selectedPost {
            //print(post)
            postLabel.text = "\(post.sender) posted : \n" + "\(post.body)"
            postLabel.numberOfLines = 0
            getUpdatedPost(id: post.id)
            
        }
        
    }
    
    @IBAction func likeButtonPressed(_ sender: UIButton) {
        
    }
    
    @IBAction func commentButtonPressed(_ sender: UIButton) {
        if let commentBody = commentTextField.text,
            let commenter = Auth.auth().currentUser?.email,
            let docId = selectedPost?.id {
            
            db.collection(Constants.FStore.collectionName).document(docId).updateData([
                "comments": FieldValue.arrayUnion(["\(commentBody) -- \(commenter)"])
            ]){ err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("Document successfully updated")
                    self.commentTextField.text = ""
                }
            }
            
            
//            db.collection(Constants.FStore.collectionName).whereField("sender", isEqualTo: commenter)
//            .getDocuments() { (querySnapshot, err) in
//                if let err = err {
//                    print("error occured \(err)")
//                }
//                else {
//                    let document = querySnapshot!.documents.first
//                    document!.reference.updateData([
//                        "comments": FieldValue.arrayUnion([commentBody])
//                    ])
//                }
//            }
//            print(commentBody)
//            print(commenter)
//
//            selectedPost?.comments.append(newComment)
//
//            commentsTableView.reloadData()

            
        }
        
    }
    
    func getUpdatedPost(id: String) {
        db.collection(Constants.FStore.collectionName).document(id)
        .addSnapshotListener { documentSnapshot, error in
          guard let document = documentSnapshot else {
            print("Error fetching document: \(error!)")
            return
          }
          guard let data = document.data() else {
            print("Document data was empty.")
            return
          }
            self.selectedPost?.comments = (data[Constants.FStore.commentsField] as? [String])!
            self.selectedPost?.likes = (data[Constants.FStore.likesField] as? [String])!
            
            DispatchQueue.main.async {
                self.commentsTableView.reloadData()
            }
        }
        

    }
    
}

extension PostViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let numberOfComments = selectedPost?.comments.count {
            return numberOfComments
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let comment = selectedPost?.comments[indexPath.row]
        
        //let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath)
        let cell = UITableViewCell()
        cell.textLabel?.text = comment ?? "no comments yet"
        cell.textLabel?.numberOfLines = 0

        return cell
        
    }
    
    
}
