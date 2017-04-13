//
//  main.swift
//  ExtDomainModel
//
//  Created by Sydnie Fenske on 4/13/17.
//  Copyright © 2017 Sydnie Fenske. All rights reserved.
//

import Foundation

print("Hello, World!")

public func testMe() -> String {
    return "I have been tested"
}

open class TestMe {
    open func Please() -> String {
        return "I have been tested"
    }
}


protocol Mathematics {
    static func +(_ money1: Self, _ money2: Money) -> Money
    static func -(_ money1: Self, _ money2: Money) -> Money
}

////////////////////////////////////
// Money
//
public struct Money: Mathematics, CustomStringConvertible {
    public var amount : Int
    public var currency : String
    public var description : String
    
    public enum Currency : String {
        case USD = "USD"
        case CAN = "CAN"
        case EUR = "EUR"
        case GBP = "GBP"
    }
    
    init(amount: Int, currency: String) {
        self.amount = amount
        self.currency = currency
        self.description = "\(currency)\(amount)"
    }
    
    static public func +(_ money1: Money,_ money2: Money) -> Money {
        return money1.add(money2)
    }
    static public func -(_ money1: Money,_ money2: Money) -> Money {
        return money1.subtract(money2)
    }
    
    public func convert(_ to: String) -> Money {
        var temp = convertToUSD(amount: amount, currency: currency)
        switch to {
        case "CAN":
            temp = temp * 5 / 4
        case "EUR":
            temp = temp * 3 / 2
        case "GBP":
            temp = temp / 2
        default:
            break
        }
        return Money(amount: temp, currency: to)
    }
    
    public func add(_ to: Money) -> Money {
        var temp = amount
        if(currency != to.currency) {
            temp = convert(to.currency).amount
        }
        return Money(amount: to.amount + temp, currency: to.currency)
    }
    
    public func subtract(_ from: Money) -> Money {
        var temp = amount
        if(currency != from.currency) {
            temp = convert(from.currency).amount
        }
        return Money(amount: from.amount - temp, currency: from.currency)
    }
    
    public func convertToUSD(amount: Int, currency: String) -> Int {
        switch currency {
        case "CAN":
            return amount * 4/5
        case "EUR":
            return amount * 2/3
        case "GBP":
            return amount * 2
        default:
            return amount
        }
    }
}

extension Double {
    var USD: Money {return Money(amount:Int(self),currency:"USD")}
    var EUR: Money {return Money(amount:Int(self),currency:"EUR")}
    var GBP: Money {return Money(amount:Int(self),currency:"GBP")}
    var YEN: Money {return Money(amount:Int(self),currency:"YEN")}
}

////////////////////////////////////
// Job
//
open class Job : CustomStringConvertible {
    fileprivate var title : String
    fileprivate var type : JobType
    public var description : String
    
    public enum JobType {
        case Hourly(Double)
        case Salary(Int)
    }
    
    
    public init(title : String, type : JobType) {
        self.title = title
        self.type = type
        self.description = "\(title), \(type)"
    }
    
    open func calculateIncome(_ hours: Int) -> Int {
        switch type {
        case .Hourly(let pay):
            return Int(pay * Double(hours))
        case .Salary(let pay):
            return pay
        }
    }
    
    open func raise(_ amt : Double) {
        switch type {
        case .Hourly(let pay):
            type = JobType.Hourly(pay + amt)
        case .Salary(let pay):
            type = JobType.Salary(pay + Int(amt))
        }
    }
}

////////////////////////////////////
// Person
//
open class Person : CustomStringConvertible {
    open var firstName : String = ""
    open var lastName : String = ""
    open var age : Int = 0
    public var description : String
    
    fileprivate var _job : Job? = nil
    open var job : Job? {
        get {
            return _job
        }
        set(value) {
            if(age < 16) {
                _job = nil
            } else {
                _job = value
            }
        }
    }
    
    fileprivate var _spouse : Person? = nil
    open var spouse : Person? {
        get {
            return _spouse
        }
        set(value) {
            if(age < 18) {
                _spouse = nil
            } else {
                _spouse = value
            }
        }
    }
    
    public init(firstName : String, lastName: String, age : Int) {
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
        self.description = "\(firstName) \(lastName), \(age)"
    }
    
    open func toString() -> String {
        return "[Person: firstName:\(firstName) lastName:\(lastName) age:\(age) job:\(job) spouse:\(spouse)]"
    }
}

////////////////////////////////////
// Family
//
open class Family : CustomStringConvertible {
    fileprivate var members : [Person] = []
    public var description : String
    
    public init(spouse1: Person, spouse2: Person) {
        if(spouse1.spouse == nil && spouse2.spouse == nil) {
            spouse1.spouse = spouse2
            spouse2.spouse = spouse1
            members.append(spouse1)
            members.append(spouse2)
        }
        self.description = "Family Members: "
        for i in members {
            self.description += "[\(i.description)] "
        }
    }
    
    open func haveChild(_ child: Person) -> Bool {
        var allowed = false
        for i in members {
            if(i.age > 21) {
                allowed = true
            }
        }
        if(allowed) {
            members.append(child)
        }
        return allowed
    }
    
    open func householdIncome() -> Int {
        var total = 0;
        for i in members {
            if(i.job != nil) {
                total += (i.job?.calculateIncome(2000))!
            }
        }
        return total
    }
}
