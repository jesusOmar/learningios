//
//  ViewController.swift
//  Tootbot
//
//  Created by Jesus Fernandez on 4/24/18.
//  Copyright © 2018 JO. All rights reserved.
//

import UIKit
import RealmSwift
import Alamofire
import SwiftyJSON
import ChameleonFramework

class TimelineViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var timelineTableView: UITableView!
    @IBOutlet weak var tabBar: UITabBar!
    @IBOutlet weak var newCountLabel: UILabel!
    
    let realm = try! Realm()
    let refreshControl = UIRefreshControl()
    var mastodonPosts: Results<MastodonPost>?
    
    // TODO: Refresh messages every X minutes
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeMastodon()

        configureTableView()

        loadMessages() // From Cache
        
        loadAdditionalMessages() // From Instance
        
    }

    //MARK: - Mastodon Messages Methods
    func initializeMastodon() {
        
        // TODO: This one fails
        // curl -X POST -d "client_id=cf89f71f2b078e2d2df9693e0e4ed363a37e1434514f519f3217120a2710f05d&client_secret=5c75250c1286ff8416e4cb48bca3df83634e06cf97577ef0a4593d6c5f6931eb&grant_type=password&username=jesus.fndz@gmail.com&password=Masqjode00" -Ss https://counter.social/oauth/token
        
        // This one works
        // curl --header "Authorization: Bearer cd5e0aa10b7f9639485232bdf991e49942fd0d05d2131f668e301efb799cfd9c" -sS https://counter.social/api/v1/timelines/home
        
        
        // TODO: Check for initial setup or instantiate previous mastodon instance
        // TODO: Delete older cached posts (Maybe keep the newest 200 or something)
    }
    
    func loadMessages() {
        mastodonPosts = realm.objects(MastodonPost.self).sorted(byKeyPath: "id", ascending: false)
        timelineTableView.reloadData()
    }

    @objc func loadAdditionalMessages() {
        
        let lastShown = 0
        var newPosts = 0
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer cd5e0aa10b7f9639485232bdf991e49942fd0d05d2131f668e301efb799cfd9c"
        ]
        
        Alamofire.request("https://counter.social/api/v1/timelines/home", headers: headers).responseJSON { response in
            
            if let json = response.result.value {
                
                let results = JSON(json)
                
                for (index,post):(String, JSON) in results {
                    
                    // See if the post id already exists in realm db
                    let found = self.realm.objects(MastodonPost.self).filter("id = \(post["id"].intValue)")
                    
                    if found.count == 0 { // Prevent duplicates in db
                        
                        try! self.realm.write {
                            
                            let newPost = MastodonPost()
                            
                            newPost.id = post["id"].intValue
                            newPost.author_name = post["account"]["display_name"].stringValue
                            newPost.author_image = post["account"]["avatar"].stringValue
                            newPost.html = post["content"].stringValue
                            
                            self.realm.add(newPost)
                            newPosts = newPosts + 1
                        }
                        
                    }
                    
                }
                
                if newPosts > 0 {
                    
                    self.newCountLabel.text = String(newPosts)
                    self.newCountLabel.isHidden = false // TODO: Hide when finished scrolling and decrement count
                    
                    
                    let rowToScrollTo = lastShown == 0 ? results.count - 1 : results.count
                    
                    self.timelineTableView.reloadData()
                    self.timelineTableView.scrollToRow(at: IndexPath(item: rowToScrollTo, section: 0), at: .top, animated: false)
                    
                }

                self.refreshControl.endRefreshing()

                
            }
            
            
        }

    }
    
    //MARK: - Table View Configuration
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tootbotMessageCell") as! TootbotMessageCell
        
        cell.authorName.text = "@\(self.mastodonPosts?[indexPath.row].author_name ?? "unknown")"
        
        let data = self.mastodonPosts?[indexPath.row].html.data(using: String.Encoding.unicode, allowLossyConversion: true)
        
        let formatedText = try? NSMutableAttributedString(data: data!, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
        
        formatedText?.addAttribute(.font, value: UIFont.systemFont(ofSize: 12), range: NSRange(location: 0, length: formatedText!.length))

        cell.html.attributedText = formatedText

        // TODO: Figure out how to cache the image for each user so I don't need a network call each time.
        Alamofire.request((self.mastodonPosts?[indexPath.row].author_image)!).responseData { response in
            if let data = response.result.value {
                let image = UIImage(data: data)
                
                cell.author_image.image = image
                cell.author_image.layer.borderWidth = 1
                cell.author_image.layer.borderColor = FlatGray().cgColor
                cell.author_image.layer.masksToBounds = false
                cell.author_image.layer.cornerRadius = cell.author_image.frame.height/2
                cell.author_image.clipsToBounds = true
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mastodonPosts?.count ?? 0
    }
    
    func configureTableView() {
        // Configure the table
        timelineTableView.delegate = self
        timelineTableView.dataSource = self

        timelineTableView.register(UINib(nibName: "TootbotMessageCell", bundle: nil), forCellReuseIdentifier: "tootbotMessageCell")

        timelineTableView.rowHeight = UITableViewAutomaticDimension
        timelineTableView.estimatedRowHeight = 120.0

        // Add refresh control
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(loadAdditionalMessages), for: .valueChanged)
        refreshControl.backgroundColor = FlatWhite()
        //timelineTableView.addSubview(refreshControl)
        timelineTableView.refreshControl = refreshControl
        //timelineTableView.insertSubview(refreshControl, at: 0)
        
        //  Select default timeline
        tabBar.selectedItem = tabBar.items![0] as UITabBarItem
        
        // Configure the new label
        newCountLabel.layer.cornerRadius = 5

    }
    
}

