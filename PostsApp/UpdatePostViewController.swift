//
//  UpdatePostViewController.swift
//  PostsApp
//

import Foundation
import UIKit

class UpdatePostViewController: UIViewController {
    
    var post: Post?
    @IBOutlet weak var authorInput: UITextField!
    @IBOutlet weak var titleInput: UITextField!
    @IBOutlet weak var contentInput: UITextField!
    @IBOutlet weak var urlInput: UITextField!
    var updatePostDelegate: PostUpdates?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authorInput.text = post?.author
        titleInput.text = post?.title
        contentInput.text = post?.content
        urlInput.text = post?.url
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func updatePost(_ sender: Any) {
        let post = Post(id: self.post!.id, author: authorInput.text!, title: titleInput.text, content: contentInput.text, url: urlInput.text)
        updatePostDelegate?.postUpdated(post: post)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
