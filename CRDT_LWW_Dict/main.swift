import Foundation

let testSuite = CRDTTests()
testSuite.testAssociativity()
testSuite.testCommutativity()
testSuite.testIdempotancy()

testSuite.testObjectCountAfterAdding()
testSuite.testObjectCountAfterRemoval()

let playgroud = Playground()
playgroud.run()
