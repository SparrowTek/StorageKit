import Foundation

public enum StorageError: Error {
    case createURL
    case removeObject
    case clearDirectory
    case createURLError
}

public struct Storage {
    
    public enum Directory {
        /// Only documents and other data that is user-generated, or that cannot otherwise be recreated by your application, should be stored in the <Application_Home>/Documents directory and will be automatically backed up by iCloud.
        case documents
        
        /// Data that can be downloaded again or regenerated should be stored in the <Application_Home>/Library/Caches directory. Examples of files you should put in the Caches directory include database cache files and downloadable content, such as that used by magazine, newspaper, and map applications.
        case caches
    }
    
    /// Returns URL constructed from specified directory
    private static func getURL(for directory: Directory, fileManager: FileManager) throws -> URL {
        let searchPathDirectory: FileManager.SearchPathDirectory = switch directory {
        case .documents: .documentDirectory
        case .caches: .cachesDirectory
        }
        
        guard let url = fileManager.urls(for: searchPathDirectory, in: .userDomainMask).first else { throw StorageError.createURLError }
        return url
    }
    
    /// returns the URL location for the file name and directory
    /// - Parameters
    ///     - fileName: the name of the file
    ///     - directory: `Directory` to look in
    ///     - fileManager: An optional FileManager` argument. Defaults to `FileManager.default`
    ///  - Returns: an optional `URL`
    public static func url(for fileName: String, in directory: Directory, fileManager: FileManager = .default) -> URL? {
        try? getURL(for: directory, fileManager: fileManager).appendingPathComponent(fileName, isDirectory: false)
    }
    
    /// Store an encodable struct to the specified directory on disk
    ///
    /// - Parameters:
    ///   - data: the data to store
    ///   - directory: where to store the struct
    ///   - fileName: what to name the file where the struct data will be stored
    ///   - fileManager: An optional FileManager` argument. Defaults to `FileManager.default`
    public static func store(_ data: Data, to directory: Directory, as fileName: String, fileManager: FileManager = .default) throws {
        guard !fileExists(fileName, in: directory) else { return }
        guard let url = try? getURL(for: directory, fileManager: fileManager).appendingPathComponent(fileName, isDirectory: false) else { throw StorageError.createURLError }
        try data.write(to: url, options: .completeFileProtection)
    }
    
    /// Remove specified file from specified directory
    public static func remove(_ fileName: String, from directory: Directory, fileManager: FileManager = .default) throws {
        guard !fileExists(fileName, in: directory) else { return }
        guard let url = try? getURL(for: directory, fileManager: fileManager).appendingPathComponent(fileName, isDirectory: false) else { throw StorageError.createURLError }
        
        do {
            try fileManager.removeItem(at: url)
        } catch {
            throw StorageError.removeObject
        }
    }
    
    /// - Returns: `Bool` indicating whether file exists at specified directory with specified file name
    public static func fileExists(_ fileName: String, in directory: Directory, fileManager: FileManager = .default) -> Bool {
        guard let url = try? getURL(for: directory, fileManager: fileManager).appendingPathComponent(fileName, isDirectory: false) else { return false }
        return fileManager.fileExists(atPath: url.path)
    }
    
    /// Remove all files at specified directory
    public static func clear(_ directory: Directory, fileManager: FileManager = .default) throws {
        guard let url = try? getURL(for: directory, fileManager: fileManager) else { return }
        let contents = try fileManager.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: [])
        
        for fileUrl in contents {
            try fileManager.removeItem(at: fileUrl)
        }
    }
}
