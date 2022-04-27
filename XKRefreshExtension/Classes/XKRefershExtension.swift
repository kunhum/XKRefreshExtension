//
//  XKRefershExtension.swift
//  XKRefreshExtension
//
//  Created by kenneth on 2022/4/21.
//

import Foundation
import MJRefresh

public extension UIScrollView {
    
    func setDefaultRefreshConfig() {
        
        if let footer = mj_footer as? MJRefreshBackStateFooter {
            footer.setTitle("加载更多", for: .idle)
            footer.setTitle("加载更多", for: .pulling)
            footer.setTitle("加载更多", for: .willRefresh)
            footer.setTitle("加载中...", for: .refreshing)
        }
        
        if let footer = mj_footer as? MJRefreshAutoStateFooter {
            footer.setTitle("加载更多", for: .idle)
            footer.setTitle("加载更多", for: .pulling)
            footer.setTitle("加载更多", for: .willRefresh)
            footer.setTitle("加载中...", for: .refreshing)
        }
        
        if let header = mj_header as? MJRefreshNormalHeader {
            header.lastUpdatedTimeLabel?.isHidden = true
        }
        
    }
    
    func endHeaderRefresh() {
        mj_header?.endRefreshing()
    }
    
    func endFooterRefresh(noMoreData: Bool) {
        noMoreData ? mj_footer?.endRefreshingWithNoMoreData() : mj_footer?.endRefreshing()
    }
    
    func endRefersh() {
        endHeaderRefresh()
        endFooterRefresh(noMoreData: false)
    }
    
    func endRefreshWithNoMoreData() {
        mj_footer?.endRefreshingWithNoMoreData()
    }
    
}
