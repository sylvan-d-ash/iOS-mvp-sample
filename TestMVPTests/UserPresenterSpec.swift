//
//  UserPresenterSpec.swift
//  TestMVPTests
//
//  Created by Sylvan Ash on 07/08/2018.
//  Copyright © 2018 is24. All rights reserved.
//

import Quick
import Nimble
@testable import TestMVP

class UserPresenterSpec: QuickSpec {
    
    class UserServiceFake: UserService {
        private let users: [User]
        private let error: Error?
        
        init(_ users: [User], error: Error? = nil) {
            self.users = users
            self.error = error
        }
        
        override func getUsers(_ callBack: @escaping ([User], Error?) -> Void) {
            callBack(users, error)
        }
    }
    
    class UserViewMock: UserView {
        var setEmptyUsersCalled = false
        var wasErrorReturned = false
        var wasProgressShown = false
        var wasProgressHidden = false
        var users: [UserViewData] = []
        
        func setUsers(_ users: [UserViewData]) {
            self.users = users
        }
        func setEmptyUsers() {
            setEmptyUsersCalled = true
        }
        func startLoading() {
            wasProgressShown = true
        }
        func finishLoading() {
            wasProgressHidden = true
        }
        func showError(error: Error) {
            wasErrorReturned = true
        }
    }
    
    override func spec() {
        var sut: UserPresenter!
        
        describe("UserPresenterSpec") {
            context("fetch users") {
                it("should show then hide activity loading indicator when fetching") {
                    // given
                    let userViewMock = UserViewMock()
                    let userServiceFake = UserServiceFake([])
                    sut = UserPresenter(userService: userServiceFake)
                    sut.attachView(userViewMock)
                    
                    // when
                    sut.getUsers()
                    
                    // then
                    expect(userViewMock.wasProgressShown).to(equal(true))
                    expect(userViewMock.wasProgressHidden).to(equal(true))
                }
                
                it("should show empty view if no users available") {
                    // given
                    let userViewMock = UserViewMock()
                    let userServiceFake = UserServiceFake([])
                    sut = UserPresenter(userService: userServiceFake)
                    sut.attachView(userViewMock)
                    
                    // when
                    sut.getUsers()
                    
                    // then
                    expect(userViewMock.setEmptyUsersCalled).to(equal(true))
                }
                
                it("should set users") {
                    // given
                    let users = [
                        User(firstName: "Jon", lastName: "Snow", email: "jon.snow@thewall.com", age: 29),
                        User(firstName: "Arya", lastName: "Stark", email: "arya.stark@winterfell.com", age: 18)
                    ]
                    let userViewMock = UserViewMock()
                    let userServiceFake = UserServiceFake(users)
                    sut = UserPresenter(userService: userServiceFake)
                    sut.attachView(userViewMock)
                    
                    // when
                    sut.getUsers()
                    
                    // then
                    expect(userViewMock.users.count).to(equal(users.count))
                }
                
                it("should show an error if there was one") {
                    // given
                    let userViewMock = UserViewMock()
                    let userServiceFake = UserServiceFake([], error: NetworkError.Unknown)
                    sut = UserPresenter(userService: userServiceFake)
                    sut.attachView(userViewMock)
                    
                    // when
                    sut.getUsers()
                    
                    // then
                    expect(userViewMock.wasErrorReturned).to(equal(true))
                }
            }
        }
    }
}
