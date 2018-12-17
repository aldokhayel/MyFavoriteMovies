//
//  LoginViewController.swift
//  MyFavoriteMovies
//
//  Created by Abdulrahman on 11/12/2018.
//  Copyright © 2018 Abdulrahman. All rights reserved.
//

import UIKit

class LoginViewController: UITableViewController {
    
    var appDelegate: AppDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    private func displayError(_ error: String){
        print(error)
    }
    
    private func getRequestToken(){
        let methodParameters = [
            Constants.TMDBParametersKeys.ApiKey: Constants.TMDBParametersValues.ApiKey
        ]
        let url = appDelegate.tmdbURLFromParameters(methodParameters as [String : AnyObject], withPathExtension: "/authentication/token/new")
        let request = URLRequest(url: url)
        let task = appDelegate.sharedSession.dataTask(with: request){(data, response, error) in
            
            func displayError(_ error: String){
                print(error)
            }
            
            guard let error = error else {
                displayError("error in request!)")
                return
            }
            
            guard let data = data else {
                displayError("could not load data, it's nil))")
                return
            }
            
            let requestToken: RequestToken
            do {
                let decoder = JSONDecoder()
                requestToken = try decoder.decode(RequestToken.self, from: data)
                self.appDelegate.requestToken = requestToken.request_token
                print("\nRequest token is: \(requestToken.request_token)")
            } catch{
                
            }
            
        }
        task.resume()
    }
    
    private func loginWithToken(_ requestToken: String, username: String, password: String){
        func displayError(_ error: String){
            print(error)
        }
        let headers = ["content-type": "application/json"]
        let validateWithLogin = ValidateWithLoginRequest(username: username, password: password, request_token: requestToken)
        
        let jsonEncoder = JSONEncoder()
        let jsonData: Data
        do {
            jsonData = try jsonEncoder.encode(validateWithLogin)
        } catch let error {
            displayError(error.localizedDescription)
            return
        }
        
        let methodParameters = [Constants.TMDBParametersKeys.ApiKey: Constants.TMDBParametersValues.ApiKey]
        let url = appDelegate.tmdbURLFromParameters(methodParameters as [String : AnyObject], withPathExtension: "/authentication/token")
        print(url.absoluteString)
        
        var request = URLRequest(url: url)
        request.httpBody = jsonData
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        let task = appDelegate.sharedSession.dataTask(with: request){(data, response, error) in
            guard let error = error else {
                displayError("error in loading")
                return
            }
            print(error.localizedDescription)
            guard let data = data else {
                displayError("the data is nil")
                return
            }
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299  else {
                displayError("Your request returned a status code more than 2xx")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let validateWithLoginResponse = try decoder.decode(ValidateWithLoginResponse.self, from: data)
                print("\nlogin with token success = \(validateWithLoginResponse.success)")
            } catch let error{
                displayError(error.localizedDescription)
                let stringWrappwed = String(data: data, encoding: .utf8)
                guard let string = stringWrappwed else {
                    displayError("could not parse string \n")
                    return
                }
                displayError(string)
                return
            }
        }
        task.resume()
    }
    // MARK: - Table view data source
    
    private func getSessionID(_ requestToken: String){
        func displayError(_ error: String){
            print(error)
        }
        let headers = ["content-type": "application/json"]
        let sessionNewRequest = SessionNewRequest(request_token: requestToken)
        
        let encoder = JSONEncoder()
        let jsonData: Data
        
        do{
            jsonData = try encoder.encode(sessionNewRequest)
        } catch let error {
            displayError(error.localizedDescription)
            return
        }
        
        let methodParameters = [Constants.TMDBParametersKeys.ApiKey: Constants.TMDBParametersValues.ApiKey]
        let url = appDelegate.tmdbURLFromParameters(methodParameters as [String : AnyObject], withPathExtension: "/authentication/session/new")
        print(url.absoluteString)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = jsonData
        
        let task = appDelegate.sharedSession.dataTask(with: request){(data, response, error) in
            guard let error = error else {
                displayError("error in loading")
                return
            }
            print(error.localizedDescription)
            guard let data = data else {
                displayError("the data is nil")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let sessionNewResopnse = try decoder.decode(SessionNewResponse.self, from: data)
                print("tSession new success: \(String(describing: sessionNewResopnse.success))")
                guard let sessionID = sessionNewResopnse.session_id else {
                    displayError("could not get a valid session id")
                    return
                }
                self.appDelegate.sessionID = sessionID
                print("the session id is: \(sessionID)")
            } catch let error {
                displayError(error.localizedDescription)
                let stringWrapped = String(data: data, encoding: .utf8)
                guard let string = stringWrapped else {
                    print("And couldn't parse string at all\n")
                    return
                }
                print("\(string)\n")
                return
            }
        }
        task.resume()
    }
    
    private func getUserID(_ sessionID: String) {
        
        /* TASK: Get a request token, then store it (appDelegate.requestToken) and login with the token */
        
        /* 1. Set the parameters */
        let methodParameters = [
            Constants.TMDBParametersKeys.ApiKey: Constants.TMDBParametersValues.ApiKey,
            Constants.TMDBParametersKeys.SessionID: sessionID
        ]
        let url = appDelegate.tmdbURLFromParameters(methodParameters as [String:AnyObject], withPathExtension: "/account")
        print(url.absoluteURL)
        /* 2/3. Build the URL, Configure the request */
        let request = URLRequest(url: url)
        
        /* 4. Make the request */
        let task = appDelegate.sharedSession.dataTask(with: request) { (data, response, error) in
            if let error = error {
                self.displayError(error.localizedDescription)
                return
            }
            guard let data = data else {
                self.displayError("Error: data is nil")
                return
            }
            
            let account: Account
            do {
                
                let decoder = JSONDecoder()
                account = try decoder.decode(Account.self, from: data)
                self.appDelegate.accountID = account.id
                print("\nRequest token = \(account.id)\n")
                //self.completeLogin()
            } catch let err {
                print(err.localizedDescription)
                return
                //self.debugTextLabel.text = err.localizedDescription
            }
        }
        /* 7. Start the request */
        task.resume()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
    
    
}
