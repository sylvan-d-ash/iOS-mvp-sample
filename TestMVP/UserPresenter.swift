
import Foundation

struct UserViewData{
    let name: String
    let age: String
}

protocol UserView: NSObjectProtocol {
    func startLoading()
    func finishLoading()
    func setUsers(_ users: [UserViewData])
    func setEmptyUsers()
    func showError(error: Error)
}

class UserPresenter {
    fileprivate let userService: UserService
    weak fileprivate var userView: UserView?
    
    init(userService: UserService) {
        self.userService = userService
    }
    
    func attachView(_ view: UserView) {
        userView = view
    }
    
    func detachView() {
        userView = nil
    }
    
    func getUsers() {
        self.userView?.startLoading()
        
        userService.getUsers{ [weak self] users, error in
            self?.userView?.finishLoading()
            
            guard error == nil else {
                self?.userView?.showError(error: error!)
                return
            }
            
            if (users.count == 0) {
                self?.userView?.setEmptyUsers()
            } else {
                let mappedUsers = users.map {
                    return UserViewData(name: "\($0.firstName) \($0.lastName)", age: "\($0.age) years")
                }
                self?.userView?.setUsers(mappedUsers)
            }
        }
    }
}
