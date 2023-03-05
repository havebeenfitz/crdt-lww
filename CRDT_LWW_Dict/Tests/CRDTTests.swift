import Foundation

struct TestStub {
    
    var replica1 = CRDTLWWReplica<String, Int>()
    var replica2 = CRDTLWWReplica<String, Int>()
    var replica3 = CRDTLWWReplica<String, Int>()

    let obj1 = CRDTObject<String, Int>("a", value: 1, timestamp: 0)
    let obj2 = CRDTObject<String, Int>("b", value: 2, timestamp: 1)
    let obj3 = CRDTObject<String, Int>("c", value: 3, timestamp: 2)
    let obj4 = CRDTObject<String, Int>("c", value: 4, timestamp: 3)
    let obj5 = CRDTObject<String, Int>("d", value: 5, timestamp: 5)
    let obj6 = CRDTObject<String, Int>("e", value: 6, timestamp: 6)
    let obj7 = CRDTObject<String, Int>("f", value: 7, timestamp: 7)
    
}

class CRDTTests {
    
    // MARK: - Tests of basic properties
    // As in `A comprehensive study of Convergent and Commutative Replicated Data Types` page 10
    
    func testAssociativity() {
        // - Associativity of merge. Priority of merges should not matter
        let stub = TestStub()
        stub.replica1.add(stub.obj1)
        stub.replica1.add(stub.obj2)
        stub.replica2.add(stub.obj4)
        stub.replica2.add(stub.obj5)
        stub.replica3.add(stub.obj7)
        stub.replica3.add(stub.obj6)

        let newReplica1 = stub.replica1 + (stub.replica2 + stub.replica3)
        let newReplica2 = (stub.replica1 + stub.replica2) + stub.replica3

        assert(newReplica2.contents == newReplica1.contents)
    }
    
    func testCommutativity() {
        // - Commutativity of merge. Order of merges should not matter
        let stub = TestStub()
        stub.replica1.add(stub.obj1)
        stub.replica1.add(stub.obj2)
        stub.replica2.add(stub.obj4)
        stub.replica2.add(stub.obj5)

        let newReplica1 = stub.replica1 + stub.replica2
        let newReplica2 = stub.replica2 + stub.replica1

        assert(newReplica1.contents == newReplica2.contents)
    }
    
    func testIdempotancy() {
        // - Idempotency of merge. Same operation should not affect the outcome
        let stub = TestStub()
        
        let newReplica = stub.replica1 + stub.replica1 + stub.replica1
        
        assert(newReplica.contents == stub.replica1.contents)
    }
    
    // MARK: Test basic funcionality
    
    func testObjectCountAfterAdding() {
        let stub = TestStub()
        
        stub.replica1.add(stub.obj1)
        stub.replica1.add(stub.obj2)
        
        assert(stub.replica1.contents.count == 2)
    }
    
    func testObjectCountAfterRemoval() {
        let stub = TestStub()
        
        stub.replica1.add(stub.obj3)
        stub.replica1.remove(stub.obj3)
        
        assert(stub.replica1.contents.count == 0)
    }
    
}
