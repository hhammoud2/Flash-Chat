//
//  ErrorHandler.swift
//  Flash Chat
//
//  Created by Hammoud Hammoud on 11/20/17.
//  Copyright © 2017 London App Brewery. All rights reserved.
//

import UIKit
import Firebase

class ErrorHandler {
    let view : UIViewController?
    init(view: UIViewController) {
        self.view = view
    }
    // MARK - Error Handling
    func handleCommonErrors(err: NSError?) {
        if let error = AuthErrorCode(rawValue: err!._code) {
            switch error {
            case .networkError:
                let alert = UIAlertController(title: "Error", message: "Network unavailable", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: "Default action"), style: .`default`, handler: { _ in
                    NSLog("The \"OK\" alert occured.")
                }))
                view!.present(alert, animated: true, completion: nil)
                
            case .userNotFound:
                let alert = UIAlertController(title: "Error", message: "User not found", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: "Default action"), style: .`default`, handler: { _ in
                    NSLog("The \"OK\" alert occured.")
                }))
                view!.present(alert, animated: true, completion: nil)
                
            case .userTokenExpired:
                let alert = UIAlertController(title: "Error", message: "User token has expired, please sign in again", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: "Default action"), style: .`default`, handler: { _ in
                    NSLog("The \"OK\" alert occured.")
                }))
                view!.present(alert, animated: true, completion: nil)
                
            case .tooManyRequests:
                let alert = UIAlertController(title: "Request quota exceeded", message: "Please try again later", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: "Default action"), style: .`default`, handler: { _ in
                    NSLog("The \"OK\" alert occured.")
                }))
                view!.present(alert, animated: true, completion: nil)
                
            case .invalidAPIKey:
                let alert = UIAlertController(title: "Error", message: "Invalid API Key", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: "Default action"), style: .`default`, handler: { _ in
                    NSLog("The \"OK\" alert occured.")
                }))
                view!.present(alert, animated: true, completion: nil)
                
            case .appNotAuthorized:
                let alert = UIAlertController(title: "Error", message: "Not connected to Firebase Authentication", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: "Default action"), style: .`default`, handler: { _ in
                    NSLog("The \"OK\" alert occured.")
                }))
                view!.present(alert, animated: true, completion: nil)
                
            case .keychainError:
                let alert = UIAlertController(title: "Error", message: "Could not access keychain", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: "Default action"), style: .`default`, handler: { _ in
                    NSLog("The \"OK\" alert occured.")
                }))
                view!.present(alert, animated: true, completion: nil)
                if let errorInfo = err {
                    if let failureReason = errorInfo.userInfo["NSLocalizedFAilureReasonErrorKey"] {
                        print(failureReason)
                    }
                    if let underlyingError = errorInfo.userInfo["NSUnderlyingErrorKey"] {
                        print(underlyingError)
                    }
                }
                
            case .internalError:
                let alert = UIAlertController(title: "Error", message: "Internal Error, please report to Firebase/Google", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: "Default action"), style: .`default`, handler: { _ in
                    NSLog("The \"OK\" alert occured.")
                }))
                view!.present(alert, animated: true, completion: nil)
                
            default:
                print(err!)
            }
        }
    }
}
