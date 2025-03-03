import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import UIKit

class ChatViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    @IBOutlet var messageTextfield: UITextField!

    let db = Firestore.firestore()

    var messages: [Message] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        title = K.appName
        navigationItem.hidesBackButton = true
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        loadMessages()
    }

    func loadMessages() {
        db.collection(K.FStore.collectionName).addSnapshotListener { querySnapshot, error in
            self.messages = []
            if let e = error {
                print("There was an issue retrieving data from Firestore. \(e)")
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        if let sender = data[K.FStore.senderField] as? String, let messageBody = data[K.FStore.bodyField] as? String {
                            let newMessage = Message(sender: sender, body: messageBody)
                            self.messages.append(newMessage)

                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                        }
                    }
                }
            }
        }
    }

    @IBAction func sendPressed(_ sender: UIButton) {
        if let messageBody = messageTextfield.text, let messageSender = Auth.auth().currentUser?.email {
            db.collection(K.FStore.collectionName).addDocument(data: [K.FStore.senderField: messageSender, K.FStore.bodyField: messageBody]) { error in
                if let e = error {
                    print("There was an issue saving data to firestore, \(e)")
                } else {
                    print("Successfully saved data.")
                }
            }
        }
    }

    @IBAction func logoutPressed(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
}

extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        messages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! MessageCell
        cell.label.text = messages[indexPath.row].body
        return cell
    }
}
