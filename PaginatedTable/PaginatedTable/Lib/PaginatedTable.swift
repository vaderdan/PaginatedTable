
//
//  PaginatedTable.swift
//  Sinkmail
//
//  Created by Danny on 4/25/16.
//  Copyright © 2016 Danny. All rights reserved.
//

import Foundation
import UIKit

protocol PaginatedTableDelegate {
    func startFetchingNextResults()
}

class PaginatedTable:UITableView {
    var paginatedDelegate:PaginatedTableDelegate?
    
    override var contentOffset:CGPoint {
        didSet {
            func startFetchingNextResults() {
                let tableHeaderViewHeight = tableHeaderView?.bounds.height ?? 0
                let tableFooterViewHeight = tableFooterView?.bounds.height ?? 0
                let height = contentSize.height - contentInset.top - contentInset.bottom - nextPageLoaderOffset - bounds.height - tableHeaderViewHeight - tableFooterViewHeight
                
                
                if contentOffset.y > 0 && contentOffset.y > height && !loading && haveMoreData {
                    self.paginatedDelegate?.startFetchingNextResults()
                }
            }
            
            dispatch_async(dispatch_get_main_queue()) {
                startFetchingNextResults()
            }
        }
    }
    
    var loading:Bool = false
    var haveMoreData:Bool = false
    var nextPageLoaderOffset:CGFloat = 300
}

protocol PaginatedController: class, PaginatedTableDelegate {
    associatedtype T
    
    var tableView:PaginatedTable! { get set }
    var results:[T] { get set }
    
    var nextPageLoaderView:UIView! { get }
    
    func fetchResults(start:()->(), finish:(result:[T]?, error:ErrorType?, haveMoreData:Bool)->())
    func fetchNextResults(start:()->(), finish:(result:[T]?, error:ErrorType?, haveMoreData:Bool)->())
    func reloadData()
    func reloadNextData()
}




extension PaginatedController {
    func startFetchingResults() {
        fetchResults(willFetchingResults, finish:didFetchResults)
    }
    
    func startFetchingNextResults() {
        fetchNextResults(willFetchingResults, finish:didFetchNextResults)
    }
    
    //MARK: privates
    
    func willFetchingResults() {
        tableView.loading = true
        tableView.tableFooterView = nextPageLoaderView
    }
    
    func didFetchResults(results:[T]?, error:ErrorType?, haveMoreData:Bool) {
        if let _ = error {
            return didFailedToFetchResults()
        }
        
        tableView.loading = false
        tableView.haveMoreData = haveMoreData
        tableView.tableFooterView = haveMoreData ? nextPageLoaderView : nil
        
        endRefreshing(false)
        self.results = results ?? []
        reloadData()
    }
    
    func didFetchNextResults(results:[T]?, error:ErrorType?, haveMoreData:Bool) {
        if let _ = error {
            return didFailedToFetchResults()
        }
        
        tableView.loading = false
        tableView.haveMoreData = haveMoreData
        tableView.tableFooterView = haveMoreData ? nextPageLoaderView : nil
        
        endRefreshing(false)
        self.results.appendContentsOf(results ?? [])
        reloadNextData()
    }
    
    func didFailedToFetchResults() {
        tableView.loading = false
        endRefreshing(true)
    }
    
    //MARK: overrides
    
    func endRefreshing(hasError:Bool) {
        
    }
    
    func reloadData() {
        tableView.reloadData()
    }
    
    func reloadNextData() {
        let offset = tableView.contentOffset
        tableView.reloadData()
        tableView.setContentOffset(offset, animated: false)
    }
}
