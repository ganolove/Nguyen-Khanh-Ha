//
//  Entry .swift
//  Task1
//
//  Created by User11 on 2018/03/07.
//  Copyright © 2018年 テストアプリ. All rights reserved.
//

import Foundation

class Entry: NSObject, NSCoding {
    
    var firstName: String
    var lastName: String
    var email: String
    var password: String
    var birthDate: String?
    
    init (
        firstName: String,
        lastName: String,
        email: String,
        password: String,
        birthDate: String
    )
    {
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.password = password
        self.birthDate = birthDate
    }
    
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(firstName, forKey: "firstName")
        aCoder.encode(lastName, forKey: "lastName")
        aCoder.encode(email, forKey: "email")
        aCoder.encode(password, forKey: "password")
        aCoder.encode(birthDate, forKey: "birthDate")
    }
    
    required init?(coder aDecoder: NSCoder){
        self.lastName = aDecoder.decodeObject(forKey: "lastName") as! String
        self.firstName = aDecoder.decodeObject(forKey: "firstName") as! String
        self.email = aDecoder.decodeObject(forKey: "email") as! String
        self.password = aDecoder.decodeObject(forKey:"password") as! String
        self.birthDate = aDecoder.decodeObject(forKey:"birthDate") as? String
    }
}
