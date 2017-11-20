//
//  RegisterViewController.swift
//  Flash Chat
//
//  This is the View Controller which registers new users with Firebase
//

import UIKit
import Firebase
import SVProgressHUD

class RegisterViewController: UIViewController {

    let requiredPasswordLength = 8
    var errorHandler : ErrorHandler?
    
    //Pre-linked IBOutlets
    @IBOutlet var emailTextfield: UITextField!
    @IBOutlet var passwordTextfield: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorHandler = ErrorHandler(view: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

  
    @IBAction func registerPressed(_ sender: AnyObject) {
  
//      THIS BLOCK IS TRYING TO STRENGTHEN PASSWORD REQUIREMENTS BUT IS ANNOYING ME
//        if passwordTextfield.text!.count < requiredPasswordLength {
//            //Show some error that say password must be at least 8 characters
//            self.handleErrors(err: ".weakPassword" as? Error, email: emailTextfield.text!, password: passwordTextfield.text!)
//        }
//        //else if emailTextfield.text! != "" && passwordTextfield.text! != "" {
//        else {
        
        //Create a new user
        SVProgressHUD.show()
        Auth.auth().createUser(withEmail: emailTextfield.text!, password: passwordTextfield.text!, completion: { (user, error) in
                if error != nil {
                    if let errorHandler = self.errorHandler {
                        errorHandler.handleCommonErrors(err: error as NSError?)
                    }
                    self.handleErrors(err: error, email: self.emailTextfield.text!, password: self.passwordTextfield.text!)
                }
                else {
                    //Successful register
                    print("Registration successful")
                    Database.database().reference().child("users").child(user!.uid).setValue(["username": user!.email])
                    SVProgressHUD.dismiss()
                    self.performSegue(withIdentifier: "goToChat", sender: self)
                }
            })
    }
    
    // MARK: - Specific Error Handling
    private func handleErrors(err: Error?, email: String, password: String) {
        if let error = AuthErrorCode(rawValue: err!._code) {
            switch error {
            
            case .invalidEmail:
                let alert = UIAlertController(title: "Registration Failed", message: "Invalid email", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("Try Again", comment: "Default action"), style: .`default`, handler: { _ in
                    NSLog("The \"OK\" alert occured.")
                }))
                self.present(alert, animated: true, completion: nil)

            case .emailAlreadyInUse:
                Auth.auth().fetchProviders(forEmail: email, completion: { (email1, error) in
                    if let emailString = email1 {
                        print(emailString)
                    }
                    else {
                        print("No email")
                    }
                })
                let usernameAlert = UIAlertController(title: "Registration Failed", message: "This username is already in use by another account", preferredStyle: .alert)
                usernameAlert.addAction(UIAlertAction(title: NSLocalizedString("Try Again", comment: "Default action"), style: .`default`, handler: { _ in
                    NSLog("The \"OK\" alert occured.")
                }))
                self.present(usernameAlert, animated: true, completion: nil)
                
            case .operationNotAllowed:
                let alert = UIAlertController(title: "Registration Failed", message: "Operation not allowed, please contact Flash Chat for further support", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: "Default action"), style: .`default`, handler: { _ in
                    NSLog("The \"OK\" alert occured.")
                }))
                self.present(alert, animated: true, completion: nil)
                
            case .weakPassword:
                print("Password too short, only \(passwordTextfield.text!.count) characters")
                let passwordAlert = UIAlertController(title: "Registration Failed", message: "Password must be 6 or more characters", preferredStyle: .alert)
                passwordAlert.addAction(UIAlertAction(title: NSLocalizedString("Try Again", comment: "Default action"), style: .`default`, handler: { _ in
                    NSLog("The \"OK\" alert occured.")
                }))
                self.present(passwordAlert, animated: true, completion: nil)
            default:
                print(err!)
            }

        }
    }

    
}
