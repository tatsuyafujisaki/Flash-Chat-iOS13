import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import UIKit

class ChatViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    @IBOutlet var messageTextfield: UITextField!

    override func viewDidLoad() {
        title = "⚡️FlashChat"
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
    }

    @IBAction func sendPressed(_ sender: UIButton) {}

    @IBAction func logoutPressed(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
}
