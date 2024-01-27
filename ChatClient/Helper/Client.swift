//
//  Client.swift
//  ChatClient
//
//  Created by Angelos Staboulis on 26/1/24.
//

import Foundation
import StreamChat
import StreamChatUI
import Combine
class Client{
    static let shared = Client()
    private init(){}
    var config:ChatClientConfig!
    var chatClient:ChatClient!
    var channelController:ChatChannelController!
    let userID = "Angelos-Staboulis"
  
    func initializeStream(){
        self.config = ChatClientConfig(apiKey: .init("zvr44zrmf28n"))
        self.chatClient = ChatClient(config: self.config)
        do{
             try self.chatClient.setToken(token: getToken())
        }catch{
            debugPrint("something went wrong!!!!")
        }
    }
    func getToken() throws -> Token{
        return try .init(rawValue: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiQW5nZWxvcy1TdGFib3VsaXMifQ.J9Eb2CkNhes5UNmXgDCJWtGzEL6ZJXhlLP40ArM4IY4")
    }
    func connectUser(){
        do{
            try self.chatClient.connectUser(userInfo:UserInfo(id:.init(stringLiteral: userID)), token: getToken()) { error in
                if let error = error {
                    print("Connection failed with: \(error)")
                } else {
                    print("User successfully connected")
                }
            }
            
            self.chatClient.currentUserController().reloadUserIfNeeded()
        }catch{
            debugPrint("something went wrong!!!!")
        }
    }
    func getChannelID()->ChannelId{
        let channelId = ChannelId(type: .messaging, id: "general")
        return channelId
    }
    func getMessagesCount()async -> Int{
        return await withCheckedContinuation { continuation in
            continuation.resume(returning: self.getController().messages.count)
        }
    }
    func getController()->ChatChannelController{
        self.channelController = self.chatClient.channelController(for: getChannelID())
        self.channelController.synchronize { error in
            if let error = error {
                print(error)
            }
        }
        return self.channelController
    }
    func sendMessage(message:String){
        self.channelController.createNewMessage(text: message) { result in
            switch result {
            case .success(let messageId):
                print(messageId)
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
}
