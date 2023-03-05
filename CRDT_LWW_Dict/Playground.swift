import Foundation

class Playground {
    
    // Test entity
    struct Person: Hashable {
        
        let name: String
        let surname: String
        
    }

    var replica1 = CRDTLWWReplica<String, Person>()
    var replica2 = CRDTLWWReplica<String, Person>()
    var replica3 = CRDTLWWReplica<String, Person>()

    lazy var obj1 = CRDTObject<String, Person>("a", value: Person(name: "John", surname: "Smith"), timestamp: 0)
    lazy var obj2 = CRDTObject<String, Person>("a", value: Person(name: "John", surname: "Smith"), timestamp: 1)
    lazy var obj3 = CRDTObject<String, Person>("b", value: Person(name: "Jane", surname: "Doe"), timestamp: 2)
    lazy var obj4 = CRDTObject<String, Person>("b", value: Person(name: "John", surname: "Smith"), timestamp: 3)
    lazy var obj5 = CRDTObject<String, Person>("c", value: Person(name: "Super", surname: "Man"), timestamp: 5)
    lazy var obj6 = CRDTObject<String, Person>("c", value: Person(name: "Super", surname: "Spider"), timestamp: 6)
    lazy var obj7 = CRDTObject<String, Person>("d", value: Person(name: "Super", surname: "Spider"), timestamp: 7)

    func run() {
        replica1.add(obj1)
        replica1.add(obj2)
        replica1.add(obj3)

        replica2.add(obj4)
        replica2.add(obj5)
        replica2.remove(obj1)
        replica2.remove(obj2)
        
        replica3.add(obj6)
        replica3.add(obj7)
        replica3.remove(obj5)
        replica3.remove(obj1)
        replica3.remove(obj2)

        replica1.lookup(by: "a")
    }
}
