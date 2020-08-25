//
//  Constants.swift
//  Chat App
//
//  Created by Fahim Shahriar on 10/8/20.
//  Copyright © 2020 Fahim Shahriar. All rights reserved.
//

struct Constants {
    static let appName = "⚡️FlashChat"
    static let cellIdentifier = "ReusableCell"
    static let cellNibName = "PostCell"
    static let registerSegue = "RegisterToChat"
    static let loginSegue = "LoginToChat"
    static let postSegue = "showDetailedPost"
    
    struct BrandColors {
        static let purple = "BrandPurple"
        static let lightPurple = "BrandLightPurple"
        static let blue = "BrandBlue"
        static let lighBlue = "BrandLightBlue"
    }
    
    struct FStore {
        static let collectionName = "posts"
        static let senderField = "sender"
        static let bodyField = "body"
        static let dateField = "date"
        static let commentsField = "comments"
        static let likesField = "likes"
    }
}
