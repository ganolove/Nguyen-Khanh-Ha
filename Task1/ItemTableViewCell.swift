//
//  ItemTableViewCell.swift
//  Task1
//
//  Created by User11 on 2018/03/15.
//  Copyright © 2018年 テストアプリ. All rights reserved.
//

import UIKit

class ItemTableViewCell: UITableViewCell {

    @IBOutlet weak var cellView: UIView!
    //商品画像
    @IBOutlet weak var itemImageView: UIImageView!
    //商品名
    @IBOutlet weak var itemName: UILabel!
    //商品メーカー
    @IBOutlet weak var itemMakerInfo: UILabel!
    //商品価格
    @IBOutlet weak var itemPriceInfo: UILabel!
    
    //商品ページのURL。遷移先の画面で利用する
    var itemUrl: URL?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    override func prepareForReuse() {
        itemImageView.image = nil
    }
    
    
}




    
