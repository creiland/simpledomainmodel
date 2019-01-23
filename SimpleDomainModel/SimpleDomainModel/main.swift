//
//  main.swift
//  SimpleDomainModel
//
//  Created by Ted Neward on 4/6/16.
//  Copyright © 2016 Ted Neward. All rights reserved.
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

////////////////////////////////////
// Money
//
public struct Money {
    public var amount : Int
    public var currency : String
    
    public func convert(_ to: String) -> Money {
        let new = self.amount
        var ret = 0.0
        if self.currency != to {
            if self.currency == "USD" {
                if to == "GBP" {
                    ret = Double(new) / 2
                } else if to == "EUR" {
                    ret = Double(new) * 1.5
                } else if to == "CAN" {
                    ret = Double(new) * 1.25
                }
            } else if self.currency == "GBP" {
                if to == "USD" {
                    ret = Double(new) * 2
                } else if to == "EUR" {
                    ret = Double(new) * 2 * 1.5
                } else if to == "CAN" {
                    ret = Double(new) * 2 * 1.25
                }
            } else if self.currency == "EUR" {
                if to == "USD" {
                    ret = Double(new) / 1.5
                } else if to == "GBP" {
                    ret = Double(new) / 3
                } else if to == "CAN" {
                    ret = (Double(new) / 1.5) * 1.25
                }
            } else if self.currency == "CAN" {
                if to == "USD" {
                    ret = Double(new) / 1.25
                } else if to == "EUR" {
                    ret = (Double(new) / 1.25) * 1.5
                } else if to == "GBP" {
                    ret = (Double(new) / 1.25) / 2
                }
            }
        } else {
            ret = Double(self.amount)
        }
        return Money(amount : Int(ret), currency : to)
    }
    
    public func add(_ to: Money) -> Money {
        let new = to.convert(self.currency)
        let total = new.amount + self.amount
        return Money(amount: total, currency: self.currency).convert(to.currency)
    }
    public func subtract(_ from: Money) -> Money {
        let new = from.convert(self.currency)
        let total = new.amount - self.amount
        return Money(amount: total, currency: self.currency).convert(from.currency)
    }
    
    init(amount a : Int, currency c : String){
        amount = a
        currency = c
    }
}

////////////////////////////////////
// Job
//
open class Job {
    fileprivate var title : String
    fileprivate var type : JobType
    
    public enum JobType {
        case Hourly(Double)
        case Salary(Int)
    }
    
    public init(title : String, type : JobType) {
        self.title = title
        self.type = type
    }
    
    open func calculateIncome(_ hours: Int) -> Int {
        switch self.type{
        case .Hourly(let rate):
            if hours > 0 {
                return Int(rate * Double(hours))
            } else {
                return Int(rate * 2000.0)
            }
        case .Salary(let salary):
            return salary
        }
    }
    
    //need to figure out case from enum
    open func raise(_ amt : Double) {
        switch type{
        case .Hourly(let num):
            self.type = .Hourly(num + amt)
        case .Salary(let num):
            self.type = .Salary(num + Int(amt))
        }
    }
}

////////////////////////////////////
// Person
//
open class Person {
    open var firstName : String = ""
    open var lastName : String = ""
    open var age : Int = 0
    
    fileprivate var _job : Job? = nil
    open var job : Job? {
        get {
            return _job
        }
        set(value) {
            if self.age > 16{
                _job = value
            }
        }
    }
    
    fileprivate var _spouse : Person? = nil
    open var spouse : Person? {
        get {
            return _spouse}
        set(value) {
            if self.age > 18 {
                _spouse = value
            }
        }
    }
    
    public init(firstName : String, lastName: String, age : Int) {
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
    }
    
    open func toString() -> String {
        var str = "[Person: firstName:\(self.firstName) lastName:\(self.lastName) age:\(self.age) "
        
        if self.job != nil {
            str = str + "job:\(self._job!.title) "
        } else {
            str = str + "job:nil "
        }
        if self.spouse != nil {
            str = str + "spouse:\(self._spouse!)]"
        } else {
            str = str + "spouse:nil]"
        }
        return str
    }
}

////////////////////////////////////
// Family
//
open class Family {
    var members : [Person] = []
    
    public init(spouse1: Person, spouse2: Person) {
            spouse1.spouse = spouse2
            spouse2.spouse = spouse1
            self.members.append(spouse1)
            self.members.append(spouse2)
    }
    
    open func haveChild(_ child: Person) -> Bool {
        if members.count > 1 {
            if members[0].age > 21 || members[1].age > 21 {
                self.members.append(child)
            }
            return true
        } else {
            return false
        }
    }
    
    open func householdIncome() -> Int {
        var total = 0
        for person in members {
            if person.job != nil{
                total = total + person.job!.calculateIncome(0)
            }
        }
        return total
    }
}


