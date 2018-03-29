//
//  SearchTableViewController.swift
//  Task1
//
//  Created by User11 on 2018/03/08.
//  Copyright © 2018年 テストアプリ. All rights reserved.
//

import UIKit
import SafariServices


class SearchTableViewController: UITableViewController, UISearchBarDelegate, SFSafariViewControllerDelegate {
    
    let priceFormat = NumberFormatter()
    
    var okashiList: [(maker:String, name:String, url:URL, image:String, price: String?)] = []
    
    var imageCache = NSCache<AnyObject,UIImage>()
    
    @IBOutlet var searchBar: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        //価格のフォーマット指定
        priceFormat.numberStyle = .currency
        priceFormat.currencyCode = "JPY"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //keyboardのSearchボタンがタップされたときに呼び出される
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
        if let searchWord = searchBar.text {
            print(searchWord)
            searchOkashi(keyword: searchWord)
            searchBar.resignFirstResponder()
        }
    }

    func searchOkashi(keyword: String) {        
        //パラメータのURLエンコード処理
        guard let keyword_encode = keyword.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return
        }
        //リクエストを行う
        guard let req_url = URL(string: "http://www.sysbird.jp/toriko/api/?apikey=guest&format=json&keyword=\(keyword_encode)&max=10&order=r" ) else {
            return
        }
        print(req_url)
        //リクエスト生成
        let req = URLRequest(url:req_url)
        //商品検索APIをコールして商品検索を行う
        let session = URLSession(configuration: .default,delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: req, completionHandler: {(data, response, error) in
            session.finishTasksAndInvalidate()

            do {
                //パース実施
                let decoder = JSONDecoder()
                let downloadResultJson = try decoder.decode(ResultJson.self, from: data!)
                
               // 商品のリストに追加
                if let items = downloadResultJson.item {
                    //保存している商品をいったん削除
                    self.okashiList.removeAll()

                    for item in items {
                        if let maker = item.maker, let name = item.name, let url = item.url, let image = item.image {
                            //if price != "{}"{
                                let okashi = (maker, name, url, image,item.price)
                                self.okashiList.append(okashi)
                        }
                    }
                    
                    //tableViewを更新する
                    DispatchQueue.main.async {
                        self.tableView.reloadData() }
                    if let okashidbg = self.okashiList.first {
                        print("------")
                        print("okashiList[0] = \(okashidbg)")
                    }
                }
            } catch {
                print(error.localizedDescription)
            }
        })
        task.resume()
    }
    override func tableView(_ tableView:UITableView, numberOfRowsInSection section: Int) -> Int {
        return okashiList.count
    }
    
    //Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return  1
    }
    // setting height
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90.0
    }
    override  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as? ItemTableViewCell else {
            return UITableViewCell()
        }
        cell.cellView.layer.cornerRadius = cell.cellView.frame.height / 0.05
        cell.itemImageView.layer.cornerRadius = cell.itemImageView.frame.height / 2
        
        let itemData = okashiList[indexPath.row]
        //商品名
        cell.itemName.text = "商品名:　" + itemData.name
        cell.itemMakerInfo.text = "メーカー:　" + itemData.maker
        
        //cell color setting
       //cell.contentView.backgroundColor = UIColor.darkGray
        //cell.backgroundColor = UIColor.lightGray
        //商品価格
        if let price = itemData.price {
            if let atai = Int(price) {
        let number = NSNumber(integerLiteral: atai)
                cell.itemPriceInfo.text = "価格:　" + priceFormat.string(from:number)!
            } else { cell.itemPriceInfo.text = "数値ではない" }
        } else {
            cell.itemPriceInfo.text = "在庫切れ"
        }
        //商品のURL
        cell.itemUrl = itemData.url
        
        
        //画像の設定処理
        //すでにセルに設定されている画像と同じかどうかチェックする
        //画像がまだ設定されていない場合に処理を行う
        
        guard let itemImageUrl = itemData.image  as Optional else {
            return cell
        }
        //キャッシュの画像を取り出す
        if let cacheImage = imageCache.object(forKey: itemImageUrl as AnyObject) {
            //キャッシュ画像の設定
            cell.itemImageView.image = cacheImage
            return cell
        }
        //キャッシュの画像がないためダウンロードする
        guard let url = URL(string: itemImageUrl) else {
            return cell
        }
        let request = URLRequest(url:url)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { ( data:Data?, response: URLResponse?, error:Error?) in
            guard error == nil else {
                return
            }
            guard let data = data else {
                return
            }
            guard let image = UIImage(data:data) else {
                print("something is wrong")
                return
            }
            //ダウンロードした画像をキャッシュに登録しておく
            self.imageCache.setObject(image, forKey: itemImageUrl as AnyObject)
            //画像はメインスレッド上で設定する
            DispatchQueue.main.async {
                cell.itemImageView.image = image
            }
        }
        task.resume()
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let safariViewController = SFSafariViewController(url: okashiList[indexPath.row].url)
        safariViewController.delegate = self
        present(safariViewController, animated: true, completion: nil)
    }
    
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        dismiss(animated:true, completion: nil)
    }
    
}

 



