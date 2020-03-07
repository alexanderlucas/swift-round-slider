import XCTest
@testable import swift_slider

final class swift_sliderTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(swift_slider().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
