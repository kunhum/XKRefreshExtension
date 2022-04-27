//
//  ViewController.swift
//  XKRefreshExtension
//
//  Created by kenneth on 04/21/2022.
//  Copyright (c) 2022 kenneth. All rights reserved.
//

import UIKit
import MJRefresh
import XKRefreshExtension

class ViewController: UIViewController, UITableViewDataSource {
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.description())
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            [weak self] in
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.0) {
                [weak self] in
                self?.tableView.endRefersh()
            }
        })
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.frame = view.bounds
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.description(), for: indexPath)
        cell.textLabel?.text = "\(indexPath.row)"
        return cell
    }

}

