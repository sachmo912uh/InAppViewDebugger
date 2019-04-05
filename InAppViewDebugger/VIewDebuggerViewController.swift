//
//  VIewDebuggerViewController.swift
//  InAppViewDebugger
//
//  Created by Indragie Karunaratne on 4/4/19.
//  Copyright © 2019 Indragie Karunaratne. All rights reserved.
//

import UIKit

/// Root view controller for the view debugger.
public final class ViewDebuggerViewController: UIViewController {
    private let snapshot: Snapshot
    private let configuration: Configuration
    private let snapshotViewController: SnapshotViewController
    
    public init(snapshot: Snapshot, configuration: Configuration = Configuration()) {
        self.snapshot = snapshot
        self.configuration = configuration
        self.snapshotViewController = SnapshotViewController(snapshot: snapshot, configuration: configuration.snapshotViewConfiguration)
        
        super.init(nibName: nil, bundle: nil)
        
        configureSegmentedControl()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        addChild(snapshotViewController)
        view.addSubview(snapshotViewController.view)
        snapshotViewController.didMove(toParent: self)
    }
    
    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        snapshotViewController.view.frame = view.bounds
    }
    
    private func configureSegmentedControl() {
        let segmentedControl = UISegmentedControl(items: [
            NSLocalizedString("Snapshot", comment: "The title for the Snapshot tab"),
            NSLocalizedString("Hierarchy", comment: "The title for the Hierarchy tab"),
        ])
        segmentedControl.sizeToFit()
        segmentedControl.selectedSegmentIndex = 0
        navigationItem.titleView = segmentedControl
    }
}
