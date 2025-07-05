# StorageKit

### WARNING
This package is subject to change a lot. If you want to use this it probably makes sense to copy and paste the code (it is only 1 file with 82 lines of code).   

Sometimes Core Data or SQLite are overkill for your app. In those situations, StorageKit is a great solution to save `Codable` objects to disk.

## Install StorageKit

StorageKit currently only supports installation via Swift Package Manager. 

### Add Package Dependency
In Xcode, select `File` > `Add Packages...`.

### Specify the Repository
Copy and paste the following into the search/input box.
`https://github.com/SparrowTek/StorageKit.git`

### Specify Options
In the options for the StorageKit package, we recommend setting the Dependency Rule to Up to Next Major Version, and enter the 
current StorageKit version. Then, click `Add Package`.

### Select the Package Products
Select `StorageKit`, then click Add Package.

## Getting started
First import StorageKit

```swift
import StorageKit
```

For any `Codable` object save and retrieve from disk.

```swift
struct User: Codable {
    let name: String
    let id: Int
}
```

### Store
```swift
do {
    let user = User(name: "Thomas", id: 123)
    try Storage.store(user, to: .documents, as: "user.json")
} catch {
    // TODO: handle error
}
```

### retrieve
```swift
let user = Storage.retrieve("user.json", from: .documents, as: User.self)
```

### delete
```swift
do {
    try Storage.remove("user.json", from: .documents)
} catch {
    // TODO: handle error
}
```

### does a file exist?
```swift
let exists = Storage.fileExists("user.json", in: .documents)
```
