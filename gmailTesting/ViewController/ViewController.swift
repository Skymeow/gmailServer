//
//  ViewController.swift
//  gmailTesting
//
//  Created by Sky Xu on 1/28/18.
//  Copyright © 2018 Sky Xu. All rights reserved.
//

import UIKit
import GoogleSignIn
import Google
import GoogleAPIClientForREST
import Alamofire

class ViewController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate {

    private let scopes = [kGTLRAuthScopeGmailReadonly]
    private let service = GTLRGmailService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure Google Sign-in.
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().scopes = scopes
    }
    
    @IBAction func gmailSignInTapped(_ sender: UIButton) {
        GIDSignIn.sharedInstance().signIn()
    }
    
    // Helper for showing an alert
    func showAlert(title : String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: UIAlertControllerStyle.alert
        )
        let ok = UIAlertAction(
            title: "OK",
            style: UIAlertActionStyle.default,
            handler: nil
        )
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
    func getMessages(Id: String, completion: @escaping ([GTLRGmail_Message], Bool) -> ()) {
        
        let query = GTLRGmailQuery_UsersMessagesList.query(withUserId: Id)
        service.executeQuery(query) { (ticket, result, err) in
            if let err = err {
                self.showAlert(title: "unAuthorized", message: err.localizedDescription)
                return
            }
            let msgResponse = result as! GTLRGmail_ListMessagesResponse
            let msgList = msgResponse.messages![0..<11]
            completion(Array(msgList), true)
        }
    }
    
    //   MARK: (helper) main func to call google Signin
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        //  if error is not nil, show alert
        if error != nil {
            showAlert(title: "Authentication Error", message: error.localizedDescription)
            self.service.authorizer = nil
            return
        } else {
            guard let userId = user.userID else { return }
            print(userId)
            self.service.authorizer = user.authentication.fetcherAuthorizer()
            let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
            let gmailVC = storyBoard.instantiateViewController(withIdentifier: "gmailVC") as! GmailViewController
            
            getMessages(Id: userId) { (result, success) in
                if success {
                    gmailVC.msgArr = result
                    self.present(gmailVC, animated: true, completion: nil)
                }
            }
        }
    }
}


