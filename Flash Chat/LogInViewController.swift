//
//  LogInViewController.swift
//  Flash Chat
//
//  This is the view controller where users login


import UIKit
import Firebase
import SVProgressHUD

class LogInViewController: UIViewController {

    
    var errorHandler : ErrorHandler?
    
    //Textfields pre-linked with IBOutlets
    @IBOutlet var emailTextfield: UITextField!
    @IBOutlet var passwordTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorHandler = ErrorHandler(view: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

   
    @IBAction func logInPressed(_ sender: AnyObject) {

        //Log in the user
        SVProgressHUD.show()
        Auth.auth().signIn(withEmail: emailTextfield.text!, password: passwordTextfield.text!) { (user, error) in
            if error != nil {
                if let errorHandler = self.errorHandler {
                    errorHandler.handleCommonErrors(err: error as NSError?)
                }
                self.handleErrors(err: error)
            }
            else {
                print("Sign in succesful")
                //Transition to chat
                SVProgressHUD.dismiss()
                self.performSegue(withIdentifier: "goToChat", sender: self)
            }
        }
        
    }
    
    // MARK: - Specific Error Handling
    private func handleErrors(err: Error?) {
        if let error = AuthErrorCode(rawValue: err!._code) {
            switch error {
            case .operationNotAllowed:
                print("Operation Not Allowed")
                let alert = UIAlertController(title: "Login Failed", message: "Operation not allowed, please contact Flash Chat for further support", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: "Default action"), style: .`default`, handler: { _ in
                    NSLog("The \"OK\" alert occured.")
                }))
                self.present(alert, animated: true, completion: nil)

            case .invalidEmail:
                print("Invalid Email")
                let alert = UIAlertController(title: "Login Failed", message: "Invalid Email", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("Try Again", comment: "Default action"), style: .`default`, handler: { _ in
                    NSLog("The \"OK\" alert occured.")
                }))
                self.present(alert, animated: true, completion: nil)

            case .userDisabled:
                print("Account banned")
                let alert = UIAlertController(title: "Login Failed", message: "Account disabled, please contact Flash Chat for further support", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: "Default action"), style: .`default`, handler: { _ in
                    NSLog("The \"OK\" alert occured.")
                }))
                self.present(alert, animated: true, completion: nil)

            case .wrongPassword:
                print("Wrong password")
                let alert = UIAlertController(title: "Login Failed", message: "Incorrect Password", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("Try Again", comment: "Default action"), style: .`default`, handler: { _ in
                    NSLog("The \"OK\" alert occured.")
                }))
                self.present(alert, animated: true, completion: nil)

            default:
                print(err!)
            }
        }
    }
    
    
}  
