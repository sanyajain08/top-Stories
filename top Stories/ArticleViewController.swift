//
//  ViewController.swift
//  top Stories
//
//  Created by Sanya Jain on 10/07/18.
//  Copyright © 2018 Sanya Jain. All rights reserved.
//

import UIKit

class ArticleViewController: UITableViewController {
    
    var articles = [[String: String]]()
    var apiKey = ""
    var source = [String: String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Top Stories"
        
        let query = "https://newsapi.org/v1/articles?" + "source=\(source["id"]!)&apiKey=\(apiKey)"
        DispatchQueue.global(qos: .userInitiated).async {
            [unowned self] in
            if let url = URL(string: query) {
                if let data = try? Data(contentsOf: url) {
                    let json = try! JSON (data: data)
                    if json["status"] == "ok" {
                        self.parse(json: json)
                        return
                    }
                }
            }
            self.loadError()         
        }
        
    }
    
    func parse(json: JSON) {
        for result in json["articles"].arrayValue {
            let name = result["name"].stringValue
            let description = result["description"].stringValue
            let url = result["url"].stringValue
            let article = ["name": name, "description": description, "url": url]
            articles.append(article)
        }
        DispatchQueue.main.async {
            [unowned self] in
            self.tableView.reloadData()
        }
    }
    
    func loadError() {
        DispatchQueue.main.async {
            [unowned self] in
            let alert = UIAlertController(title: "Loading Error",
                                          message: "There was a problem loading the news feed",
                                          preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let article = articles[indexPath.row]
        cell.textLabel?.text = article["name"]
        cell.detailTextLabel?.text = article["description"]
        return cell
        
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let url = URL(string: articles[indexPath.row]["url"]!)
        UIApplication.shared.open(url! as URL, options: [:], completionHandler: nil)
    }
    
}



