# PaginatedTable

A ViewController with a tableView which manage pagination and loaders for iOS, in Swift


## Installation

## Screenshots

![Example](./Screens/example.gif "Example View")

## Usage

### Basic usage

#### Swift

```swift

import PaginatedController

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, PaginatedController {
    
    // PaginatedController requires 3 propertiest to be defined
    @IBOutlet weak var tableView: PaginatedTable!
    @IBOutlet weak var nextPageLoaderView: UIView!
    
    // results variable is generic and you can put anyting you want here eg [Int], [Email], [NSManagedObject]
    var results:[String] = []
    
    // Add in viewDidLoad in addition to other delegates paginatedDelegate, so protocol can track scroll position
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.paginatedDelegate = self
        
        startFetchingResults()
    }
    
    
    // implement here your service logic for calling backend apis or CoreData
    // start block should be called, to clear the table result
    func fetchResults(start:()->(), finish:(result:[String]?, error:ErrorType?, haveMoreData:Bool)->()) {
        start()
        finish(result:self.fakeData(), error:nil, haveMoreData:true)
    }
    
    // implement this method - it will be called when we scroll to bottom and will return nextpage items
    func fetchNextResults(start:()->(), finish:(result:[String]?, error:ErrorType?, haveMoreData:Bool)->()) {
        start()
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
            finish(result:self.fakeData(), error:nil, haveMoreData:true)
        })
    }
    
    // protocol call this after new data is recieved and table should be reloaded
    // you could make the tableView to animate the rows on refresh
    func reloadData() {
        tableView.reloadData()
    }
    
    func reloadNextData() {
        tableView.reloadData()
    }
}
```
