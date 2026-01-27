//
//  StoreTests.swift
//  StoreTests
//
//  Created by Ted Neward on 2/29/24.
//

import XCTest

final class StoreTests: XCTestCase {

    var register = Register()

    override func setUpWithError() throws {
        register = Register()
    }

    override func tearDownWithError() throws { }

    func testBaseline() throws {
        XCTAssertEqual("0.1", Store().version)
        XCTAssertEqual("Hello world", Store().helloWorld())
    }
    
    func testOneItem() {
        register.scan(Item(name: "Beans (8oz Can)", priceEach: 199))
        XCTAssertEqual(199, register.subtotal())
        
        let receipt = register.total()
        XCTAssertEqual(199, receipt.total())

        let expectedReceipt = """
Receipt:
Beans (8oz Can): $1.99
------------------
TOTAL: $1.99
"""
        XCTAssertEqual(expectedReceipt, receipt.output())
    }
    
    func testThreeSameItems() {
        register.scan(Item(name: "Beans (8oz Can)", priceEach: 199))
        register.scan(Item(name: "Beans (8oz Can)", priceEach: 199))
        register.scan(Item(name: "Beans (8oz Can)", priceEach: 199))
        XCTAssertEqual(199 * 3, register.subtotal())
    }
    
    func testThreeDifferentItems() {
        register.scan(Item(name: "Beans (8oz Can)", priceEach: 199))
        XCTAssertEqual(199, register.subtotal())
        register.scan(Item(name: "Pencil", priceEach: 99))
        XCTAssertEqual(298, register.subtotal())
        register.scan(Item(name: "Granols Bars (Box, 8ct)", priceEach: 499))
        XCTAssertEqual(797, register.subtotal())
        
        let receipt = register.total()
        XCTAssertEqual(797, receipt.total())

        let expectedReceipt = """
Receipt:
Beans (8oz Can): $1.99
Pencil: $0.99
Granols Bars (Box, 8ct): $4.99
------------------
TOTAL: $7.97
"""
        XCTAssertEqual(expectedReceipt, receipt.output())
    }
    
    func testEmptyRegisterSubtotal() {
        let register = Register()
        XCTAssertEqual(0, register.subtotal())
    }
    
    func testRegisterResetsAfterTotal() {
        let register = Register()
        register.scan(Item(name: "Pencil", priceEach: 99))
        XCTAssertEqual(99, register.subtotal())

        _ = register.total()
        XCTAssertEqual(0, register.subtotal())
    }
    
    func testReceiptTotalMatchesRegisterSubtotal() {
        let register = Register()
        register.scan(Item(name: "Beans", priceEach: 199))
        register.scan(Item(name: "Pencil", priceEach: 99))

        let expectedSubtotal = register.subtotal()
        let receipt = register.total()

        XCTAssertEqual(expectedSubtotal, receipt.total())
    }
    
    // Extra credit tests
    func testThreeItemsNoScheme() {
        let register = Register()
        register.scan(Item(name: "Beans (8oz Can)", priceEach: 199))
        register.scan(Item(name: "Beans (8oz Can)", priceEach: 199))
        register.scan(Item(name: "Beans (8oz Can)", priceEach: 199))

        XCTAssertEqual(199 * 3, register.subtotal())
    }
    
    func testThreeItemsWithScheme_DiscountApplies() {
        let register = Register()
        register.addPricingScheme(BuyTwoGetOneFree(itemName: "Beans (8oz Can)"))

        register.scan(Item(name: "Beans (8oz Can)", priceEach: 199))
        register.scan(Item(name: "Beans (8oz Can)", priceEach: 199))
        register.scan(Item(name: "Beans (8oz Can)", priceEach: 199))

        XCTAssertEqual(199 * 2, register.subtotal())
    }
    func testSixItemsWithScheme_DiscountAppliesTwice() {
        let register = Register()
        register.addPricingScheme(BuyTwoGetOneFree(itemName: "Beans (8oz Can)"))

        for _ in 0..<6 {
            register.scan(Item(name: "Beans (8oz Can)", priceEach: 199))
        }

        XCTAssertEqual(199 * 4, register.subtotal())
    }
    
}
