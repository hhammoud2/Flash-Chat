//
//  ViewController.swift
//  Flash Chat
//
//  Created by Angela Yu on 29/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit
import Firebase
import ChameleonFramework


class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    // Declare instance variables here
    var messageArray : [Message] = [Message]()
    let keyboardHeight : CGFloat = 270
    var currentUser: User?
    
    // We've pre-linked the IBOutlets
    @IBOutlet var heightConstraint: NSLayoutConstraint!
    @IBOutlet var sendButton: UIButton!
    @IBOutlet var messageTextfield: UITextField!
    @IBOutlet var messageTableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        
        currentUser = Auth.auth().currentUser
        //Set delegate and datasource
        messageTableView.delegate = self
        messageTableView.dataSource = self
        messageTextfield.delegate = self

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped))
        messageTableView.addGestureRecognizer(tapGesture)

        //Register your MessageCell.xib file here:
        messageTableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "customMessageCell")
        
        configureTableView()
        retrieveMessages()
        messageTableView.separatorStyle = .none
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.navigationItem.hidesBackButton = true
    }

    ///////////////////////////////////////////
    
    //MARK: - TableView DataSource Methods
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customMessageCell", for: indexPath) as! CustomMessageCell

        cell.messageBody.text = messageArray[indexPath.row].messageBody
        cell.senderUsername.text = messageArray[indexPath.row].sender
        cell.avatarImageView.image = UIImage(named: "egg")
        
        if cell.senderUsername.text == Auth.auth().currentUser?.email as String! {
            cell.avatarImageView.isHidden = true
            cell.messageBackground.backgroundColor = UIColor.flatSkyBlue()
        }
        else {
            cell.avatarImageView.isHidden = false
            cell.messageBackground.backgroundColor = .flatMint()
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageArray.count
    }
    
    @objc func tableViewTapped() {
        messageTextfield.endEditing(true)
    }
    
    func configureTableView() {
        messageTableView.rowHeight = UITableViewAutomaticDimension
        messageTableView.estimatedRowHeight = 120.0
    }
    
    
    ///////////////////////////////////////////
    
    //MARK:- TextField Delegate Methods
    func textFieldDidBeginEditing(_ textField: UITextField) {

        UIView.animate(withDuration: 0.5, animations: {
            self.heightConstraint.constant = self.heightConstraint.constant + self.keyboardHeight
            self.view.layoutIfNeeded()
        })
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5, animations: {
            self.heightConstraint.constant = self.heightConstraint.constant - self.keyboardHeight
            self.view.layoutIfNeeded()
            })

    }

    
    ///////////////////////////////////////////
    
    
    //MARK: - Send & Recieve from Firebase
    
    @IBAction func sendPressed(_ sender: AnyObject) {
        messageTextfield.endEditing(true)
        messageTextfield.isEnabled = false
        sendButton.isEnabled = false

        let messagesDB = Database.database().reference().child("Messages")
        //Following line for seperating messages into indiviual user things
        //let messagesDB = Database.database().reference().child("users").child(currentUser!.uid).child("Messages")
        let messageDictionary = ["Sender": Auth.auth().currentUser?.email, "MessageBody": messageTextfield.text!]
        messagesDB.childByAutoId().setValue(messageDictionary) {
            (error, reference) in
            if error != nil {
                //TODO: Handle errors for setValue in message database
                print(error!)
            }
            else {
                print("Message saved successfully")
                self.messageTextfield.isEnabled = true
                self.sendButton.isEnabled = true
                self.messageTextfield.text = ""
            }
        }

    }
    
    private func retrieveMessages() {
        let messageDB = Database.database().reference().child("Messages")
        //For seperate groups
        //let messageDB = Database.database().reference().child("users/\(currentUser!.uid)/Messages")
        messageDB.observe(.childAdded) { (snapshot) in
            let snapshotValue = snapshot.value as! Dictionary<String, String>
            let text = snapshotValue["MessageBody"]!
            let sender = snapshotValue["Sender"]!
            let message = Message(sender: sender, messageBody: text)
            self.messageArray.append(message)

            self.configureTableView()
            self.messageTableView.reloadData()
        }
    }
    
    @IBAction func logOutPressed(_ sender: AnyObject) {
        
        do {
            try Auth.auth().signOut()
            print("Sign out successful")
            navigationController?.popToRootViewController(animated: true)
        } catch {
            print("Error!")
        }
    }
    
}
