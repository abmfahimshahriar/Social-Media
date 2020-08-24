//
//  MessageCell.swift
//  Chat App
//
//  Created by Fahim Shahriar on 10/8/20.
//  Copyright © 2020 Fahim Shahriar. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {
//    @IBOutlet weak var messageBubble: UIView!
//    @IBOutlet weak var label: UILabel!
//    @IBOutlet weak var rightImageView: UIImageView!
//    @IBOutlet weak var leftImageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        messageBubble.layer.cornerRadius = messageBubble.frame.size.height / 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func likeButtonPressed(_ sender: UIButton) {
        print("like button pressed")
        print(sender)
    }
    @IBAction func commentButtonPressed(_ sender: UIButton) {
        print("comment button pressed")
        print(sender)
    }
    
}
