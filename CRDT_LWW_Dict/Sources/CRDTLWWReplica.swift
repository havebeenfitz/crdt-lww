import Foundation

public class CRDTLWWReplica<Key: Comparable & Hashable, Value: Hashable> {
    
    public typealias Node = CRDTObject<Key, Value>
    
    private var additions: [Key: [Value: Timestamp]] = [:]
    private var removals: [Key: [Value: Timestamp]] = [:]

    public init() {}
    
    // MARK: All resulted additions
    
    public var contents: [Node] {
        var result: [Node] = []
        
        additions.forEach { addition in
            if removals[addition.key] == nil {
                let addedValueDict = addition.value
                if let value = addedValueDict.keys.first, let timestamp = addedValueDict[value] {
                    let node = Node(addition.key, value: value, timestamp: timestamp)
                    result.append(node)
                }
            }
        }
        
        return result.sorted(by: { $0.payload.key < $1.payload.key })
    }
    
    public func add(_ object: Node) {
        let key = object.payload.key
        let value = object.payload.value
        let newTimestamp = object.timestamp
        
        if let timestampedValue = additions[key] {
            let oldTimestamp = timestampedValue.values.first ?? 0
            if newTimestamp >= oldTimestamp {
                additions[key] = [value: newTimestamp]
            }
        } else {
            additions[key] = [value: newTimestamp]
        }
    }
    
    
    
    public func remove(_ object: Node) {
        let key = object.payload.key
        let value = object.payload.value
        let newTimestamp = object.timestamp
        
        if let timestampedValue = removals[key] {
            let oldTimestamp = timestampedValue.values.first ?? 0
            if newTimestamp > oldTimestamp {
                removals[key]?[value] = newTimestamp
            }
        } else {
            removals[key] = [value: object.timestamp]
        }
    }
    
    @discardableResult
    public func lookup(by key: Key) -> [Value: Timestamp] {
        if additions[key] != nil && removals[key] == nil,
           let addTSValueDict = additions[key] {
            return addTSValueDict
        }
        
        if let addTSValueDict = additions[key],
           let removeTSValueDict = removals[key],
           let value = addTSValueDict.keys.first,
           let addTimestamp = addTSValueDict[value],
           let removeTimestamp = removeTSValueDict[value],
           addTimestamp > removeTimestamp {
            return addTSValueDict
        }
        
        return [:]
    }
    
    // MARK: - Merge several dictionaries
    
    public static func +(lhs: CRDTLWWReplica, rhs: CRDTLWWReplica) -> CRDTLWWReplica {
        let newDict = CRDTLWWReplica()
        
        newDict.merge(with: rhs)
        newDict.merge(with: lhs)
        
        return newDict
    }
    
}

// MARK: - Private

private extension CRDTLWWReplica {
    
    func merge(with otherReplica: CRDTLWWReplica) {
        additions.merge(otherReplica.additions) {
            let firstTimestamp = $0.values.first ?? 0
            let secondTimestamp = $1.values.first ?? 0
            
            if firstTimestamp > secondTimestamp {
                return $0
            } else {
                return $1
            }
        }
        
        removals.merge(otherReplica.removals) {
            let firstTimestamp = $0.values.first ?? 0
            let secondTimestamp = $1.values.first ?? 0
            
            if firstTimestamp > secondTimestamp {
                return $0
            } else {
                return $1
            }
        }
    }
    
}
