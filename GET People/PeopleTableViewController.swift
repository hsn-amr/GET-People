//
//  PeopleTableViewController.swift
//  GET People
//
//  Created by administrator on 20/12/2021.
//

import UIKit

class PeopleTableViewController: UITableViewController {
    
    let defaultPage = 1
    var peopleNames = [Result]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        requestApi(url: createApiLink(pageNumber: defaultPage))
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func createApiLink(pageNumber:Int) -> String{
        return "https://swapi.dev/api/people/?page=\(pageNumber)&format=json"
    }

    func requestApi(url: String)  {
        let url = URL(string: url)
        
        let session = URLSession.shared
        
        session.dataTask(with: url!, completionHandler: { [self]
            data, response, error in
            
            guard let myData = data else { return }
            do {
                let decoder = JSONDecoder()
                let r = try decoder.decode(Welcome.self, from: myData)
                let number = Float(r.count) / Float(r.results.count)
                let lastPage = Int(ceil(number))
                for page in 1...lastPage{
                    requastApiForGetPeopleNames(url: createApiLink(pageNumber: page))
                }
            } catch {
                print("\(error)")
            }
        }).resume()
    }
    
    func requastApiForGetPeopleNames(url: String){
        let url = URL(string: url)
        
        let session = URLSession.shared
        
        session.dataTask(with: url!, completionHandler: {
            data, response, error in
            
            guard let myData = data else {return}
            
            do {
                //codable
                let decoder = JSONDecoder()
                let result = try decoder.decode(Welcome.self, from: myData)
                self.peopleNames += result.results
                self.updateTableView()
            }catch{
                print(error)
            }
        }).resume()
    }
    
    func updateTableView(){
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return peopleNames.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = peopleNames[indexPath.row].name

        return cell
    }
   
    

}
