//
//  Message.swift
//  Chat App
//
//  Created by Fahim Shahriar on 10/8/20.
//  Copyright © 2020 Fahim Shahriar. All rights reserved.
//

import Foundation

struct Post {
    let id: String
    let sender: String
    let body: String
    var comments: [String]
    var likes: [String]
}

//struct Comment {
//    let name: String
//    let commentBody: String
//}
//
//struct Like {
//    let name: String
//}
