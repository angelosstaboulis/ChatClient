//
//  ViewController.swift
//  ChatClient
//
//  Created by Angelos Staboulis on 26/1/24.
//

import UIKit
import StreamChat
import StreamChatUI
class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var lblChannel: UILabel!
    @IBOutlet weak var txtMessage: UITextField!
    @IBOutlet weak var tableViewMessages: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    @IBAction func btnSend(_ sender: Any) {
        Client.shared.sendMessage(message: txtMessage.text!)
        tableViewMessages.reloadData()
    }
    
}

extension ViewController{
    func setupView(){
        Client.shared.initializeStream()
        self.navigationItem.title = "ChatClient(GetStream-Demo)"
        self.lblChannel.text =   Client.shared.getChannelID().rawValue
        tableViewMessages.delegate = self
        tableViewMessages.dataSource = self
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Client.shared.getController().messages.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if indexPath.row < Client.shared.getController().messages.count{
            cell.textLabel!.text = Client.shared.getController().messages[indexPath.row].text
        }
        return cell
    }
}
