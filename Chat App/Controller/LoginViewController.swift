//
//  LoginViewController.swift
//  Chat App
//
//  Created by Fahim Shahriar on 9/8/20.
//  Copyright © 2020 Fahim Shahriar. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func loginPressed(_ sender: UIButton) {
        
        if let email = emailTextField.text , let password = passwordTextField.text {
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
              if let e = error {
                  print(e.localizedDescription)
              }
              else {
                self.performSegue(withIdentifier: Constants.loginSegue, sender: self)
              }
            }
        }
        
    }
    
}
