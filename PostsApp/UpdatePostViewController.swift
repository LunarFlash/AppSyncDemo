//
//  UpdatePostViewController.swift
//  PostsApp
//

import UIKit
import AWSAppSync

class UpdatePostViewController: UIViewController {
    
    var post: Post?
    @IBOutlet weak var authorInput: UITextField!
    @IBOutlet weak var titleInput: UITextField!
    @IBOutlet weak var contentInput: UITextField!
    @IBOutlet weak var urlInput: UITextField!
    var updatePostDelegate: PostUpdates?

    var updatePostMutation: UpdatePostMutation?
    var updatePostInput: UpdatePostInput?
    var appSyncClient: AWSAppSyncClient?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appSyncClient = appDelegate.appSyncClient!
        authorInput.text = updatePostInput?.author!
        titleInput.text = updatePostInput?.title!
        contentInput.text = updatePostInput?.content!
        urlInput.text = updatePostInput?.url!
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func updatePost(_ sender: Any) {
        updatePostInput?.author = authorInput.text!
        updatePostInput?.title = titleInput.text
        updatePostInput?.content = contentInput.text
        updatePostInput?.url = urlInput.text
        updatePostMutation = UpdatePostMutation(input: updatePostInput!)

        appSyncClient?.perform(mutation: updatePostMutation!) { (result, error) in
            if let error = error as? AWSAppSyncClientError {
                print("Error occurred while making request: \(error.localizedDescription )")
                return
            }
            if let resultError = result?.errors {
                print("Error saving the item on server: \(resultError)")
                return
            }
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func onCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
