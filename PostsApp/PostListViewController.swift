//
//  ViewController.swift
//  PostsApp
//

import UIKit

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

protocol PostUpdates {
    func newPostAdded(post: Post)
    func postUpdated(post: Post)
    func postDeleted(post: Post)
}

class PostListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, PostUpdates {
    func postUpdated(post: Post) {
        var postition = -1
        for  i in 0..<postList.count {
            if (post.id == postList[i].id) {
                postition = i
            }
        }
        
        if (postition != -1) {
            postList.remove(at: postition)
            postList.insert(post, at: postition)
        }
        self.tableView.reloadData()
    }
    
    func postDeleted(post: Post) {
        var postition = -1
        for  i in 0..<postList.count {
            if (post.id == postList[i].id) {
                postition = i
            }
        }
        if (postition != -1) {
            postList.remove(at: postition)
        }
        self.tableView.reloadData()
    }
    
    
    @IBOutlet weak var tableView: UITableView!
    var postList = [Post]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addTapped))
    }
    
    @objc func addTapped() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "NewPostViewController") as! AddPostViewController
        controller.newPostDelegate = self
        self.present(controller, animated: true, completion: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostCell
        let post = postList[indexPath.row]
        cell.updateValues(author: post.author, title: post.title, content: post.content)
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            postList.remove(at: indexPath.row)
            self.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let post = postList[indexPath.row]
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "UpdatePostViewController") as! UpdatePostViewController
        controller.post = post
        controller.updatePostDelegate = self
        self.present(controller, animated: true, completion: nil)
    }
    
    func newPostAdded(post: Post) {
        postList.append(post)
        tableView.reloadData()
    }

}

