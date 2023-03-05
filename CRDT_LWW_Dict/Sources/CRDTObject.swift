import Foundation

public struct CRDTObject<Key: Hashable, Value: Hashable>: Equatable {

    public private(set) var payload: (key: Key, value: Value)
    public let timestamp: Timestamp
    
    public init(_ key: Key, value: Value, timestamp: Timestamp = .now) {
        self.payload = (key, value)
        self.timestamp = timestamp
    }
    
    public static func == (lhs: CRDTObject<Key, Value>, rhs: CRDTObject<Key, Value>) -> Bool {
        lhs.payload.key == rhs.payload.key
            && lhs.payload.value == rhs.payload.value
                && lhs.timestamp == rhs.timestamp
    }
    
}
