//
//  ViewController.swift
//  PaginatedTable
//
//  Created by Danny on 5/15/16.
//  Copyright © 2016 Danny. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, PaginatedController {

    @IBOutlet weak var tableView: PaginatedTable!
    @IBOutlet weak var nextPageLoaderView: UIView!
    
    var results:[String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.paginatedDelegate = self
        
        startFetchingResults()
    }
    
    // MARK: Fetching
    
    func fetchResults(start:()->(), finish:(result:[String]?, error:ErrorType?, haveMoreData:Bool)->()) {
        start()
        finish(result:self.fakeData(), error:nil, haveMoreData:true)
    }
    
    func fetchNextResults(start:()->(), finish:(result:[String]?, error:ErrorType?, haveMoreData:Bool)->()) {
        start()
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
            finish(result:self.fakeData(), error:nil, haveMoreData:true)
        })
    }
    
    func reloadData() {
        tableView.reloadData()
    }
    
    func reloadNextData() {
        tableView.reloadData()
    }

    //MARK: UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.textLabel?.text = results[indexPath.row]
    }

    //MARK: UITableViewDelegate
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44
    }
 
    // MARK: helpers
    
    func fakeData() -> [String] {
        return ["Dock Gaylord", "Mr. Izabella Ziemann", "Haskell Medhurst DDS", "Rebeka Torp", "Shannon Kub", "Kara Donnelly", "Johnathan Kuphal", "Jermaine Shanahan", "Mrs. Rudy Hilll", "Nathen Kutch Jr.", "Elissa Lehner", "Emmanuel Cruickshank", "Annette Bechtelar", "Ashleigh Wolff", "Roberto Crist", "Rocky Stamm", "Adolphus Streich MD", "Andres Rau", "Ms. Opal Olson", "Glenda Balistreri", "Dr. Javon Sipes", "Devante Leuschke", "Liliana Bins", "Mr. Rosie VonRueden", "Nina Batz", "Mrs. Garth Rau", "Jeffrey Bauch", "Judge Schmitt", "Raymundo Rau", "Mr. Kayley Bruen", "Wava Reilly", "Ms. Pablo Mosciski", "Estrella Cremin", "Bertram Gutmann", "Raleigh Schuppe", "Dr. Jace Kuvalis", "Kelly Terry", "Mr. Broderick Crooks", "Tevin Reinger", "Mckenna Graham V", "Howard Kuhn", "Payton Terry", "Ofelia Osinski", "Lera Bogan", "Luz Gutmann DVM", "Bulah Schaefer", "Elissa Williamson", "Joanne Schamberger", "Orpha Eichmann", "Haylee Hartmann", "Cary Toy", "Danial Marvin", "Mrs. Wilbert Reynolds", "Dr. Mable Ledner", "Albin Leffler", "Osbaldo Marks", "Omari Wolf MD", "Isabelle Schroeder", "Douglas Kohler", "Tomasa Reichert", "Larue Von", "Taylor Roberts MD", "Mose Frami", "Patrick Kautzer I", "Godfrey Gottlieb V", "Pearlie Kuhlman MD", "Dixie Kiehn I", "Karianne Larson", "Terry Daugherty Sr.", "Newell Pfannerstill I", "Lola Johns", "Freeda Wintheiser PhD", "Yolanda Abbott", "Lauryn Howe", "June Kautzer", "Zoie Bradtke", "Ms. Vanessa Watsica", "Janae Davis", "Norene Harris", "Brooks Ebert Sr."]
    }
}

