//
//  NewPostViewController.swift
//  PostsApp
//

import UIKit
import AWSAppSync


class Post {
    let id: String
    let author: String
    let title: String?
    let content: String?
    let url: String?
    
    init(id:String = UUID().uuidString,
         author: String,
         title: String? = nil,
         content: String? = nil,
         url: String? = nil) {
        self.author = author
        self.title = title
        self.content = content
        self.url = url
        self.id = id
    }
}

class AddPostViewController: UIViewController {
    
    @IBOutlet weak var authorInput: UITextField!
    @IBOutlet weak var titleInput: UITextField!
    @IBOutlet weak var contentInput: UITextField!
    @IBOutlet weak var urlInput: UITextField!
    var newPostDelegate: PostUpdates?
    var appSyncClient: AWSAppSyncClient?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appSyncClient = appDelegate.appSyncClient!
    }
    
    @IBAction func addNewPost(_ sender: Any) {
        // Create a GraphQL mutation
        let uniqueId = UUID().uuidString
        let mutationInput = CreatePostInput(author: authorInput.text!,
                                            title: titleInput.text,
                                            content: contentInput.text,
                                            url: urlInput.text,
                                            version: 1)

        let mutation = AddPostMutation(input: mutationInput)
        appSyncClient?.perform(mutation: mutation, optimisticUpdate: { (transaction) in
            do {
                // Update our normalized local store immediately for a responsive UI
                try transaction?.update(query: AllPostsQuery()) { (data: inout AllPostsQuery.Data) in
                    data.listPosts?.items?.append(AllPostsQuery.Data.ListPost.Item.init(id: uniqueId, title: mutationInput.title!, author: mutationInput.author, content: mutationInput.content!, version: 0))
                }
            } catch {
                print("Error updating the cache with optimistic response.")
            }
        }) { (result, error) in
            if let error = error as? AWSAppSyncClientError {
                print("Error occurred: \(error.localizedDescription )")
                return
            }
            // Remove local object from cache.
            let _ = self.appSyncClient?.store?.withinReadWriteTransaction { transaction in
                try? transaction.update(query: AllPostsQuery(), { (data: inout AllPostsQuery.Data) in
                    guard let items = data.listPosts?.items else {
                        return
                    }
                    var pos = -1
                    var counter = 0
                    for post in items {
                        if post?.id == uniqueId {
                            pos = counter
                            continue
                        }
                        counter += 1
                    }
                    if pos != -1 {
                        data.listPosts?.items?.remove(at: pos)
                    }
                })
            }
            self.dismiss(animated: true, completion: nil)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
