//
//  ViewController.swift
//  XKRefreshExtension
//
//  Created by kenneth on 04/21/2022.
//  Copyright (c) 2022 kenneth. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import MJRefresh
import XKRefreshExtension

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, XKRefreshable {
    
    var autoRefreshBag = DisposeBag()
    
    var refreshStatus = BehaviorRelay<XKRefreshStatus>(value: .none)
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.description())
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            [weak self] in
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.0) {
                [weak self] in
                self?.refreshStatus.accept(.none)
            }
        })
        tableView.mj_footer = MJRefreshBackStateFooter(refreshingBlock: {
            [weak self] in
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.0) {
                [weak self] in
                self?.refreshStatus.accept(.noMoreData)
            }
        })
        tableView.setDefaultRefreshConfig()
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        
        refresh(header: tableView.mj_header, footer: tableView.mj_footer) { error in
            debugPrint("error")
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.frame = view.bounds
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.description(), for: indexPath)
        cell.textLabel?.text = "\(indexPath.row)"
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            refreshStatus.accept(.firstIn)
        case 1:
            refreshStatus.accept(.headerRefresh)
        case 2:
            refreshStatus.accept(.footerRefresh)
        case 3:
            refreshStatus.accept(.noData)
        case 4:
            refreshStatus.accept(.noMoreData)
        case 5:
            refreshStatus.accept(.error(0))
        case 6:
            refreshStatus.accept(.none)
        default:
            break
        }
    }
    
    deinit {
        debugPrint("")
    }
}

