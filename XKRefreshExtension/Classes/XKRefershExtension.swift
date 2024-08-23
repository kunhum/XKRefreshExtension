//
//  XKRefershExtension.swift
//  XKRefreshExtension
//
//  Created by kenneth on 2022/4/21.
//

import Foundation
import MJRefresh
import RxCocoa
import RxSwift

public enum XKRefreshError: Equatable {
    case network
    case other
}

public enum XKRefreshStatus: Equatable {
    
    case firstIn
    case headerRefresh
    case footerRefresh
    case noData
    case noMoreData
    case error(XKRefreshError)
    case none
}

public protocol XKRefreshable {
    var refreshStatus: BehaviorRelay<XKRefreshStatus> { get set }
    var autoRefreshBag: DisposeBag { get set }
}

public extension XKRefreshable {
    
    func refresh(header: MJRefreshHeader?, footer: MJRefreshFooter?, errorAction: ((_ error: XKRefreshError) -> Void)? = nil) {
        
//        weak var weakView: UIView? = view
        weak var weakHeader: MJRefreshHeader? = header
        weak var weakFooter: MJRefreshFooter? = footer
        
        refreshStatus
            .skip(1)
            .bind { status in
                
                switch status {
                case .firstIn:
                    break
                case .headerRefresh:
                    weakFooter?.endRefreshing()
                    weakFooter?.isHidden = false
                    weakHeader?.beginRefreshing()
                case .footerRefresh:
                    weakHeader?.endRefreshing()
                    weakFooter?.beginRefreshing()
                case .noData:
                    weakHeader?.endRefreshing()
                    weakFooter?.endRefreshing()
                    weakFooter?.isHidden = true
                case .noMoreData:
                    weakHeader?.endRefreshing()
                    weakFooter?.endRefreshingWithNoMoreData()
                case let .error(err):
                    weakHeader?.endRefreshing()
                    weakFooter?.endRefreshing()
                    errorAction?(err)
                case .none:
                    weakHeader?.endRefreshing()
                    weakFooter?.endRefreshing()
                }
                
            }
            .disposed(by: autoRefreshBag)
    }
    
}

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
