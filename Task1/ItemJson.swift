//
//  ItemSearchResultSet.swift
//  Task1
//
//  Created by User11 on 2018/03/15.
//  Copyright © 2018年 テストアプリ. All rights reserved.
//

import Foundation

struct ItemJson: Codable {
    
    let name: String?
    let maker: String?
    let url: URL?
    let image: String?
    let price: String?
    
    enum Key: String, CodingKey {
        case name, maker, url, image, price
    }
    
    init (from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: Key.self)
        
        if container.contains(.name) {
            name = try? container.decode(String.self, forKey: .name)
        } else {
            name = nil
        }
        
        if container.contains( .maker) {
            maker = try? container.decode(String.self, forKey: .maker)
        } else {
            maker = nil
        }
        
        if container.contains( .url) {
            let urlStr = try? container.decode(String.self, forKey: .url)
            if let urlStr = urlStr {
                self.url = URL(string: urlStr)
         } else {
            url = nil
            }
         } else {
                url = nil
            }
        
        if container.contains( .price) {
            price = try? container.decode(String.self, forKey: .price)
        } else {
            price = nil
        }
            
        if container.contains( .image) {
            image = try? container.decode(String.self, forKey: .image)
        } else {
            image = nil
        }
  }
}
    struct ResultJson: Codable {
      let item:[ItemJson]?
}





