//
//  Disk.swift
//  
//
//  Created by Thomas Rademaker on 6/17/23.
//

import Foundation

@propertyWrapper
public struct Disk<T: Codable> {
    let fileName: String
    let directory: StorageKit.Directory
    
    public var wrappedValue: T? {
        StorageKit.retrieve(fileName, from: directory, as: T.self)
    }
    
    public init(fileName: String, directory: StorageKit.Directory = .documents) {
        self.fileName = fileName
        self.directory = directory
    }
}
