//
//  TreeTableViewDataSource.swift
//  InAppViewDebugger
//
//  Created by Indragie Karunaratne on 4/6/19.
//  Copyright © 2019 Indragie Karunaratne. All rights reserved.
//

import UIKit

protocol Tree {
    var children: [Self] { get }
}

final class TreeTableViewDataSource<TreeType: Tree>: NSObject, UITableViewDataSource {
    typealias CellFactory = (UITableView /* tableView */, TreeType /* value */, Int /* depth */, Bool /* isCollapsed */) -> UITableViewCell
    
    private let tree: TreeType
    private let cellFactory: CellFactory
    private let flattenedTree: [FlattenedTree<TreeType>]
    
    init(tree: TreeType, cellFactory: @escaping CellFactory) {
        self.tree = tree
        self.cellFactory = cellFactory
        self.flattenedTree = flatten(tree: tree, depth: 0)
    }
    
    // MARK: UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return flattenedTree.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tree = flattenedTree[indexPath.row]
        return cellFactory(tableView, tree.value, tree.depth, tree.isCollapsed)
    }
}

private struct FlattenedTree<TreeType: Tree> {
    let value: TreeType
    let depth: Int
    var isCollapsed = false
    
    init(value: TreeType, depth: Int) {
        self.value = value
        self.depth = depth
    }
}

private func flatten<TreeType: Tree>(tree: TreeType, depth: Int = 0) -> [FlattenedTree<TreeType>] {
    let initial = [FlattenedTree<TreeType>(value: tree, depth: depth)]
    return tree.children.reduce(initial) { (result, child) in
        var newResult = result
        newResult.append(contentsOf: flatten(tree: child, depth: depth + 1))
        return newResult
    }
}
