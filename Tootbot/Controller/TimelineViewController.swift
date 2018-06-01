//
//  ViewController.swift
//  Tootbot
//
//  Created by Jesus Fernandez on 4/24/18.
//  Copyright © 2018 JO. All rights reserved.
//

import UIKit
import RealmSwift
//import MastodonKit

class TimelineViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var timelineTableView: UITableView!
    
    let realm = try! Realm()
    let refreshControl = UIRefreshControl()
    var mastodonPosts: Results<MastodonPost>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         initializeMastodon()

         configureTableView()
        
         loadMessages()
    }

    //MARK: - Mastodon Messages Methods
    func initializeMastodon() {
        
    }
    
    func loadMessages() {
        mastodonPosts = realm.objects(MastodonPost.self).sorted(byKeyPath: "id", ascending: false)
        timelineTableView.reloadData()
    }

    @objc func loadAdditionalMessages() {
        //TODO: Replace with API Call for timeline messages
        // Fake network delay
        let lastShown = mastodonPosts!.count
        var newPosts = 0
        let delayInSeconds = 3.0
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delayInSeconds) {
            // Fake mastodon posts
            try! self.realm.write {
                let newPost = MastodonPost()
                let postId = self.mastodonPosts!.count + 1
                newPost.id = postId
                newPost.author_name = "jester"
                newPost.html = "\(postId). We count thirty Rebel ships, Lord Vader. But they're so small they're evading our turbo-lasers! We'll have to destroy them ship to ship. Get the crews to their fighters. Luke, let me know when you're going in. I'm on my way in now... Watch yourself! There's a lot of fire coming from the right side of that deflection tower. I'm on it. Squad leaders, we've picked up a new group of signals. Enemy fighters coming your way."

                self.realm.add(newPost)

                let newPost2 = MastodonPost()
                let postId2 = self.mastodonPosts!.count + 1
                newPost2.id = postId2
                newPost2.author_name = "jester"
                newPost2.html = "\(postId2). We count thirty Rebel ships, Lord Vader. But they're so small they're evading our turbo-lasers! We'll have to destroy them ship to ship. Get the crews to their fighters. Luke, let me know when you're going in. I'm on my way in now... Watch yourself! There's a lot of fire coming from the right side of that deflection tower. I'm on it. Squad leaders, we've picked up a new group of signals. Enemy fighters coming your way."

                self.realm.add(newPost2)

                let newPost3 = MastodonPost()
                let postId3 = self.mastodonPosts!.count + 1
                newPost3.id = postId3
                newPost3.author_name = "jester"
                newPost3.html = "\(postId3). We count thirty Rebel ships, Lord Vader. But they're so small they're evading our turbo-lasers! We'll have to destroy them ship to ship. Get the crews to their fighters. Luke, let me know when you're going in. I'm on my way in now... Watch yourself! There's a lot of fire coming from the right side of that deflection tower. I'm on it. Squad leaders, we've picked up a new group of signals. Enemy fighters coming your way."

                self.realm.add(newPost3)
                
                // Need to keep and show that we finished
                self.refreshControl.endRefreshing()

                newPosts = 3

                let rowToScrollTo = lastShown == 0 ? newPosts - 1 : newPosts

                self.timelineTableView.reloadData()
                self.timelineTableView.scrollToRow(at: IndexPath(item: rowToScrollTo, section: 0), at: .top, animated: false)
            }

        }

    }
    
    //MARK: - Table View Configuration
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tootbotMessageCell") as! TootbotMessageCell
        
        cell.authorName.text = "@\(self.mastodonPosts?[indexPath.row].author_name ?? "unknown")"
        cell.html.text = self.mastodonPosts?[indexPath.row].html
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mastodonPosts?.count ?? 0
    }
    
    func configureTableView() {
        timelineTableView.delegate = self
        timelineTableView.dataSource = self

        timelineTableView.register(UINib(nibName: "TootbotMessageCell", bundle: nil), forCellReuseIdentifier: "tootbotMessageCell")

        timelineTableView.rowHeight = UITableViewAutomaticDimension
        timelineTableView.estimatedRowHeight = 120.0

        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(loadAdditionalMessages), for: .valueChanged)
        timelineTableView.addSubview(refreshControl)

    }
    
}

