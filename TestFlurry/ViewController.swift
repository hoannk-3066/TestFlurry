//
//  ViewController.swift
//  TestFlurry
//
//  Created by nguyen.khai.hoan on 05/08/2022.
//

import UIKit
import Flurry_iOS_SDK
import AppTrackingTransparency
import AdSupport
class ViewController: UIViewController {

    @IBOutlet weak var apiKeyTF: UITextField!
    @IBOutlet weak var IDFALB: UILabel!
    @IBOutlet weak var StandardButton: UIButton!
    @IBOutlet weak var customNoParamButton: UIButton!
    @IBOutlet weak var customWithParam: UIButton!
    var checkStartFlurry = false
    override func viewDidLoad() {
        super.viewDidLoad()
        apiKeyTF.text = "5HNVR36S6DVSKHNDRY85"
        IDFALB.text = "IDFA: " + (getIDFA() ?? "")
    }
    
    func getIDFA() -> String? {
        if #available(iOS 14, *) {
            if ATTrackingManager.trackingAuthorizationStatus != ATTrackingManager.AuthorizationStatus.authorized  {
                return nil
            }
        } else {
            if ASIdentifierManager.shared().isAdvertisingTrackingEnabled == false {
                return nil
            }
        }

        return ASIdentifierManager.shared().advertisingIdentifier.uuidString
    }
    @IBAction func copyLabel(_ sender: Any) {
        UIPasteboard.general.string = getIDFA() ?? ""
        displayAlertWithTitle(title: "Copied", message: "")
    }
    
    @IBAction func crash(_ sender: Any) {
        view.endEditing(true)
        checkFlurry {
            fatalError()
        }
    }
    
    @IBAction func StartLog(_ sender: Any) {
        view.endEditing(true)
        let builder = FlurrySessionBuilder.init()
        builder.build(crashReportingEnabled: true)
        builder.build(logLevel: .all)
        builder.build(sessionContinueSeconds: 10)
        Flurry.startSession(apiKey: apiKeyTF.text ?? "", sessionBuilder: builder)
        displayAlertWithTitle(title: "Log Event", message: "Started Session")
        checkStartFlurry = true
    }
    
    @IBAction func standardEventsDemo(_ sender: Any) {
        view.endEditing(true)
        checkFlurry {
            let param = FlurryParamBuilder()
                 .set(stringVal: "Standard events demo", param: FlurryParamBuilder.contentName())
             Flurry.log(standardEvent: FlurryEvent.adClick, param: param)
             displayAlertWithTitle(title: "Log Event", message: "Standard events demo")
        }
    }
    
    @IBAction func customEventsWithoutParam(_ sender: Any) {
        view.endEditing(true)
        checkFlurry {
            Flurry.log(eventName: "sample log event name")
            displayAlertWithTitle(title: "Log Event without Params",
                                  message: "sample log event name")
        }
    }
    
    @IBAction func customEventsWithParam(_ sender: Any) {
        view.endEditing(true)
        checkFlurry {
            Flurry.log(eventName: "sample log event name with params", parameters: ["item purchased":"cool item"])
             displayAlertWithTitle(title: "Log Event with Params",
                                   message: "sample log event name with params")
        }
    }
    
    func displayAlertWithTitle(title: String, message: String?) -> Void {
        // set alert controller
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        self.present(alertController, animated: true, completion: {
            let delay = DispatchTime.now() + 0.3
            DispatchQueue.main.asyncAfter(deadline: delay){
                alertController.dismiss(animated: true, completion: nil)
            }
        })
    }
    
    func checkFlurry(completion: () -> ()) {
        if checkStartFlurry {
            completion()
        } else {
            displayAlertWithTitle(title: "False",
                                  message: "Please start flurry then try again")
        }
    }
}

