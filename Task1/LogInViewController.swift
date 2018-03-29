//
//  LogInViewController.swift
//  Task1
//
//  Created by User11 on 2018/03/08.
//  Copyright © 2018年 テストアプリ. All rights reserved.
//

import UIKit
import AudioToolbox

class LogInViewController: UIViewController {
    
    private let userDefaults = UserDefaults.standard
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var incorrectImageView: UIImageView!
    //無名関数はclosure, method名がありません。
    var callbackReturnTapped: ((_ userName:String)  -> Void)? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func logInButtonTapped(_ sender: Any) {
        print("Sign in button was tapped")
        
        //Read values from text fields
        let email = emailTextField.text
        let password = passwordTextField.text

        // check if required fields are not empty
        if (email?.isEmpty)! || (password?.isEmpty)! {
            //Display alert message here
            print("User name \(String(describing:email)) or password \(String(describing: password)) is empty")
            displayMessage(userMessage: "One of the required fields is missing")
            return
        }
        // check if required fields are not matched
        guard let data = userDefaults.object(forKey :"entry") as? Data else {
            return
           }
        if let unarchiveEntry = NSKeyedUnarchiver.unarchiveObject(with:data) as? Entry {
            print("firstName:\(unarchiveEntry.firstName)")
            if (emailTextField.text  != (unarchiveEntry.email) || passwordTextField.text != (unarchiveEntry.password) ) {
                AudioServicesPlayAlertSound(1006)
                UIView.animate(withDuration: 3.5, animations: {
                    self.incorrectImageView.alpha = 1.0
                }) { (Bool) in
                   // super.viewDidLoad()
                    self.displayMessage(userMessage: "メールアドレスまたはパスワードは正しくありません。もう一度試してください。")
                    self.incorrectImageView.alpha = 0.0
                }
            } else {
                //検索画面遷移させる
                self.view.endEditing(true)
                self.dismiss(animated: true, completion: nil)
                //cal backの処理。ログイン成功。スタート画面に知らせる処理
                callbackReturnTapped?(self.emailTextField.text!)
            }
        }
    }
    func displayMessage(userMessage: String) -> Void {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title:"Alert", message: userMessage, preferredStyle: .alert)
            let OKAction = UIAlertAction(title:"OK", style: .default) {(action:UIAlertAction!) in}
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }

}
