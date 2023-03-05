import Foundation

public typealias Timestamp = TimeInterval

public extension TimeInterval {
    
    static var now: TimeInterval {
        Date.now.timeIntervalSince1970
    }
}

