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
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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
                //self.getS
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
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
