//
//  ViewController.swift
//  PostsApp
//

import UIKit
import AWSAppSync

class PostCell: UITableViewCell {
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    func updateValues(author: String, title:String?, content: String?) {
        authorLabel.text = author
        titleLabel.text = title
        contentLabel.text = content
    }
}

class PostListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var appSyncClient: AWSAppSyncClient?
    var postList: [AllPostsQuery.Data.ListPost.Item?]? = [] {
        didSet {
            tableView.reloadData()
        }
    }

    func loadAllPosts() {

        appSyncClient?.fetch(query: AllPostsQuery(), cachePolicy: .returnCacheDataAndFetch)  { (result, error) in
            if error != nil {
                print(error?.localizedDescription ?? "")
                return
            }
            self.postList = result?.data?.listPosts?.items
        }
    }

    func loadAllPostsFromCache() {

        appSyncClient?.fetch(query: AllPostsQuery(), cachePolicy: .returnCacheDataDontFetch)  { (result, error) in
            if error != nil {
                print(error?.localizedDescription ?? "")
                return
            }
            self.postList = result?.data?.listPosts?.items
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appSyncClient = appDelegate.appSyncClient
        loadAllPosts()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addTapped))
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadAllPostsFromCache()
    }
    
    @objc func addTapped() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "NewPostViewController") as! AddPostViewController
        self.present(controller, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostCell
        let post = postList![indexPath.row]!
        cell.updateValues(author: post.author, title: post.title, content: post.content)
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            let id = postList![indexPath.row]?.id
            let deletePostMutation = DeletePostMutation(input: DeletePostInput(id: id!))
            appSyncClient?.perform(mutation: deletePostMutation) { result, err in
                self.postList?.remove(at: indexPath.row)
            }
            self.tableView.reloadData()
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let post = postList![indexPath.row]!
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "UpdatePostViewController") as! UpdatePostViewController
        controller.updatePostInput = UpdatePostInput(id: post.id, author: post.author, title: post.title, content: post.content, url: post.url, ups: 1, downs: 0, version: post.version)
        self.present(controller, animated: true, completion: nil)
    }

}

