//
//  CallViewController.swift
//  ZegoExpressDemo
//
//  Created by Larry on 2022/3/26.
//

import UIKit
import ZegoToken
import ZegoExpressEngine

class CallViewController: UIViewController {

    @IBOutlet weak var localVideoView: UIView!
    @IBOutlet weak var remoteVideoView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        ZegoExpressManager.shared.setLocalVideoView(renderView: localVideoView)
        
    }
    
    @IBAction func pressLeaveRoomButton(_ sender: Any) {
        ZegoExpressManager.shared.leaveRoom()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func pressCameraButton(_ sender: UIButton) {
        ZegoExpressManager.shared.enableCamera(enable: sender.isSelected)
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func pressMicButton(_ sender: UIButton) {
        ZegoExpressManager.shared.enableMic(enable: sender.isSelected)
        sender.isSelected = !sender.isSelected
    }
}

extension CallViewController: ZegoExpressManagerHandler {
    func onRoomUserUpdate(udpateType: ZegoUpdateType, userList: [String], roomID: String) {
        for userID in userList {
            ZegoExpressManager.shared.setRemoteVideoView(userID:userID, renderView: remoteVideoView)
        }
    }
    
    func onRoomUserDeviceUpdate(updateType: ZegoDeviceUpdateType, userID: String, roomID: String) {
        
    }
    
    func onRoomTokenWillExpire(_ remainTimeInSecond: Int32, roomID: String) {
        let token = generateToken(userID: ZegoExpressManager.shared.localParticipant?.userID ?? "")
        ZegoExpressEngine.shared().renewToken(token, roomID: roomID)
    }
    
    // !!! When your app is ready to go live, remember not to generate the Token on your client; Otherwise, there is a risk of the ServerSecret being exposed!!!
    func generateToken(userID: String) -> String {
        let tokenResult = ZegoToken.generate(AppCenter.appID, userID: userID, secret: AppCenter.serverSecret)
        return tokenResult.token
    }
}
