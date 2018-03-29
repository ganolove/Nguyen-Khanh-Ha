//
//  RegisterUserViewController.swift
//  Task1
//
//  Created by User11 on 2018/03/07.
//  Copyright © 2018年 テストアプリ. All rights reserved.
//

import UIKit

import SwiftCop



 //画面種類の定義
enum ButtonKind: Int {
    case register = 0
    case edit = 1
}

class RegisterUserViewController: UIViewController,UITextFieldDelegate {
    //SwiftCop初期化p
    private let swiftCop = SwiftCop()
    //画面種類の定義
    var kind: ButtonKind!
    //PickerViewの宣言
    private let pickerView: UIDatePicker = UIDatePicker()
    
    private let userDefaults = UserDefaults.standard
    
    //各種類ボタンの定義
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var repeatPassword: UITextField!
    @IBOutlet weak var birthDate: UITextField!
    @IBOutlet weak var editButtonView: UIButton!
    @IBOutlet weak var registButtonView: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       //画面判定
       setupUI(kind: self.kind)
        
       //誕生日pickerView関数を呼び出す
       createDatePicker()
        
       // SwiftCop　関数を呼び出す
       setupCheck()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        print("cancel button was tapped")
       closeScreen()
    }
    
    @IBAction func memberRegisterButtonTapped(_ sender: Any) {
        print("register button was tapped")
        if validate() {
            if validatePassword() {
            registEntry()
            //displayMessage(userMessage: "登録完了")
            closeScreen()
            
            } else {
                 displayMessage(userMessage: "パスワードは一致していません。もう一度ご確認ください！" )
                password.text = ""
                repeatPassword.text = ""
            }
        } else {
         //   displayMessage(userMessage: "必須な情報を入力してください")
            password.text = ""
            repeatPassword.text = ""
        }
    }
    @IBAction func EditButtonTapped(_ sender: Any) {
        print("edit button was tapped")

        
        if validate() {
            if validatePassword() {
           // displayMessage(userMessage: "登録完了")
            registEntry()
            closeScreen()
            } else {
              displayMessage(userMessage: "パスワードは一致していません。もう一度ご確認ください！"  )
                password.text = ""
                repeatPassword.text = ""
            }
        } else {
          //  displayMessage(userMessage: "必須な情報を入力してください")
            password.text = ""
            repeatPassword.text = ""
        }
    }
    
    @IBAction func textFieldEditing(_ sender: UITextField) {
        createDatePicker()
    }
    
    func createDatePicker() {
        //toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        //done button for toolbar
        let done = UIBarButtonItem(barButtonSystemItem: .done, target:nil, action: #selector(donePressed))
        let cancel = UIBarButtonItem(barButtonSystemItem: .cancel, target:nil, action: #selector(cancelPressed))
        toolbar.setItems([cancel,done], animated:true)
        
        birthDate.inputAccessoryView = toolbar
        birthDate.inputView = pickerView
        
        //format picker
        pickerView.datePickerMode = .date
    }
    
    @objc func donePressed() {
        //formate Date
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        let dateString = formatter.string(from: pickerView.date)

        birthDate.text = "\(dateString)"
        self.view.endEditing(true)
    }
    @objc func cancelPressed() {
        birthDate.text = ""
        self.view.endEditing(true)
        
    }
    
//    private func validate() -> Bool {
//        var check = true
//        if (self.firstName.text?.count == 0) ||
//           (self.lastName.text?.count == 0) ||
//           (self.email.text?.count == 0) ||
//           (self.password.text?.count == 0 ) ||
//           (self.repeatPassword.text?.count == 0) {
//            check = false
//        }
//        return check
//    }
    
    private func setupCheck() {
        // first name
        swiftCop.addSuspect(Suspect(view: self.firstName, sentence:"名前（性）を入力してください ", trial:Trial.length(.minimum,1)))
        // last name
        swiftCop.addSuspect(Suspect(view: self.lastName, sentence:"名前（名）を入力してください", trial: Trial.length(.minimum,1)))
        //email
        swiftCop.addSuspect(Suspect(view: self.email, sentence: "正しいメールアドレスではありません",trial: Trial.email))
        //password
        swiftCop.addSuspect(Suspect(view: self.password, sentence:"パスワードは半角英数字で入力してください", trial: Trial.format("^[0-9a-zA-Z]+$")))
        swiftCop.addSuspect(Suspect(view:self.password, sentence:"パスワードは８文字以上。",trial: Trial.length(.in, 8...16 as ClosedRange)))
    }
    
    private func validate() -> Bool {
        
      if let guilty = swiftCop.isGuilty(firstName) {
        displayMessage(userMessage: guilty.sentence)
        return false
        }

        if let guilty = swiftCop.isGuilty(lastName) {
            //lastName.text = guilty.verdict()
           displayMessage(userMessage: guilty.sentence)
            return false
        }
        if let guilty = swiftCop.isGuilty(email) {
           // email.text = guilty.verdict()
            displayMessage(userMessage: guilty.sentence)
            return false
        }
        if let guilty = swiftCop.isGuilty(password) {
            //password.text = guilty.verdict()
            displayMessage(userMessage: guilty.sentence)
            return false
        }
        return true
    }
    
    func validatePassword() -> Bool {
        if password.text != repeatPassword.text {
            return false
        }
       return true
    }
    
    
    func displayMessage(userMessage: String) -> Void {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title:"Alert", message: userMessage, preferredStyle: .alert)
            let OKAction = UIAlertAction(title:"OK", style: .default) {(action:UIAlertAction!) in}
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    private func setupUI(kind: ButtonKind) {
        //UItextfieldDelegateを受けるため
        self.firstName.delegate = self
        self.lastName.delegate = self
        self.email.delegate = self
        self.password.delegate = self
        self.repeatPassword.delegate = self
        self.birthDate.delegate = self
        
        switch kind {
        case .register:
            regist()
            
        case .edit:
            editInfo()
        }
    }
    
    private func regist() {
        registButtonView.isHidden = false
        editButtonView.isHidden = true
    }
    
    private func editInfo() {
        registButtonView.isHidden = true
        editButtonView.isHidden = false
        
        guard let data = userDefaults.object(forKey :"entry") as? Data else {
            return
        }
        if let unarchiveEntry = NSKeyedUnarchiver.unarchiveObject(with:data) as? Entry {
            print("firstName:\(unarchiveEntry.firstName)")
            firstName.text = unarchiveEntry.firstName
            lastName.text = unarchiveEntry.lastName
            email.text = unarchiveEntry.email
            password.text = unarchiveEntry.password
            birthDate.text = unarchiveEntry.birthDate
        }
    }
    func closeScreen() {
        self.view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
        //private の宣言
    }
    func registEntry() {
        let entry = Entry (
            firstName:self.firstName.text!,
            lastName:self.lastName.text!,
            email:self.email.text!,
            password:self.password.text!,
            birthDate: self.birthDate.text!
        )
        let archive = NSKeyedArchiver.archivedData(withRootObject: entry)
        userDefaults.set(archive,forKey:"entry")
        userDefaults.synchronize()
    }

}
