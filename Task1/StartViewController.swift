import UIKit

class StartViewController: UIViewController {
    
    private let userDefaults = UserDefaults.standard
    //各種類ボタンの定義
    @IBOutlet weak var startButtonView: UIButton!
    @IBOutlet weak var memberRegistButtonView: UIButton!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var editButtonView: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        setupUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //スタートボタンを押下する時
    @IBAction func startButtonTapped(_ sender: Any) {
        print("startButton was Tapped")
        let loginViewController = self.storyboard?.instantiateViewController(withIdentifier:"LogInViewController") as! LogInViewController
        //コールバック処理
        loginViewController.callbackReturnTapped = {(userName:String) -> Void in
            print("success")
             let searchTableViewController = self.storyboard?.instantiateViewController(withIdentifier:"SearchTableViewController") as! SearchTableViewController
            //navigationcontroller push　実装する. navigationを出す方法です
            // 1つ　storyboard と　複数storyboard の呼び方が違います
            self.navigationController?.pushViewController(searchTableViewController, animated: true)
        }
        self.present(loginViewController, animated: true)
    }
    //新規登録ボタンを押下する時
    @IBAction func memberRegistButtonTapped(_ sender: Any) {
        print("memberRegistButton was Tapped")
        let registerViewController = self.storyboard?.instantiateViewController(withIdentifier:"RegisterUserViewController") as! RegisterUserViewController
        registerViewController.kind = .register
        self.present(registerViewController, animated: true)
    }
    //編集ボタンを押下する時
    @IBAction func editButtonTapped(_ sender: Any) {
        print("editButton was Tapped")
        let registerViewController = self.storyboard?.instantiateViewController(withIdentifier:"RegisterUserViewController") as! RegisterUserViewController
        registerViewController.kind = .edit
        self.present(registerViewController, animated: true)
    }
    
    //setupUI()関数の定義
    private func setupUI() {
        //会員登録した事がないとき、以下のボタンを表示させる
        guard let data = userDefaults.object(forKey: "entry") as? Data else {
            startButtonView.isHidden  = true
            editButtonView.isHidden = true
            memberRegistButtonView.isHidden = false
            label.isHidden = false
            return
        }
        //会員情報登録済みのボタン表示以下のボタンを表示させる
        startButtonView.isHidden = false
        editButtonView.isHidden = false
        label.isHidden = true
        memberRegistButtonView.isHidden = true
        //登録情報を取得
       if let unarchiveEntry = NSKeyedUnarchiver.unarchiveObject(with: data) as? Entry {
          print("firstName:\(unarchiveEntry.firstName)")
        }
    }
    
}
