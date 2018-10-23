//
//  DataBaseManager.swift
//  COpenSSL
//
//  Created by 王增战 on 2018/10/16.
//

import Foundation

import PerfectMySQL

//MARK:---------------- 数据库信息 ----------------
let mysql_host = "127.0.0.1"
let mysql_user = "root"
let mysql_password = "19921010"
let mysql_database = "DB_WeSecrects"

//MARK:---------------- 表信息 ----------------
let tableName_UsersTable = "UsersTable"

//MARK: 表 列名
let levelId = "LEVELID"

let userName = "NAME"




open class DataBaseManager {
    
    
    fileprivate var mysql:MySQL
    internal init() {
        mysql = MySQL.init()
        guard connectedDataBase() else {
            return
        }
    }
    
    
    //MARK:---------------- 连接数据库，并开启开启 ----------------
    private func connectedDataBase() ->Bool {
        
        //let connect = mysql.connect(host: mysql_host, user: mysql_user, password: mysql_password, db: mysql_database, port: 3306, socket: <#T##String?#>, flag: <#T##UInt#>)
        let connect = mysql.connect(host: mysql_host, user: mysql_user, password: mysql_password, db: mysql_database, port: 3306)
        guard connect else {
            print("MySQL连接失败"+mysql.errorMessage())
            return false
        }
        print("MySQL连接成功")
        return true
    }
    //MARK:---------------- 执行SQL语句 ----------------
    
    @discardableResult
    func mysqlStatement(_ sql: String) -> (success: Bool, mysqlResuslt: MySQL.Results?, errMsg: String) {
        
        guard mysql.selectDatabase(named: mysql_database) else {
            let msg = "未找到\(mysql_database)数据库"
            print(msg)
            return (false, nil, msg)
        }
        
        let successQuery = mysql.query(statement: sql)
        guard successQuery else {
            let msg = "SQL语句执行失败:\(sql)"
            print(msg)
            return (false, nil, msg)
            
        }
        
        let msg = "SQL成功:\(sql)"
        print(msg)
        return (true, mysql.storeResults(), msg)
    }
    
    // 插入数据
    func insertDatabaseSQL(tableName: String, levelId: Int, name: String) -> (success: Bool, mysqlResuslt: MySQL.Results?, errMsg: String) {
        let sqlString = "INSERT INTO `\(mysql_database)`.`\(tableName_UsersTable)` (`level_id`, `name`) VALUES('\(levelId)', '\(name)')"
//        let sqlString = "INSERT INTO `DB_WeSecrects`.`UsersTable` (`level_id`, `name`) VALUES('1009', '事实上')"
        return mysqlStatement(sqlString)
        
    }
    /// 删除数据
    /// DELETE FROM `DB_WeSecrects`.`UsersTable` WHERE (`level_id` = '1010');
    ///
    /// - Parameters:
    ///   - tableName: <#tableName description#>
    ///   - key: <#key description#>
    ///   - value: <#value description#>
    /// - Returns: <#return value description#>
    func deleteDatabaseSQL(tableName: String, key: String, value: String) -> (success: Bool, mysqlResuslt: MySQL.Results?, errMsg: String) {
        let sqlString = "DELETE FROM `\(mysql_database)`.`\(tableName)` WHERE (`\(key)` = '\(value)')"
        return mysqlStatement(sqlString)
    }

    /// 改：更新数据
    ///
    /// - Parameters:
    ///   - tableName: UsersTable
    ///   - keyValue: 键值对( 键='值', 键='值', 键='值' )
    ///   - whereKey: 查找key
    ///   - whereValue: 查找value
    /// - Returns: 执行SQL语句的结果
    func updateDatabaseSQL(tableName: String, keyValue: String, whereKey: String, whereValue: String) -> (success: Bool, mysqlResuslt: MySQL.Results?, errMsg: String) {
        let sqlString = "UPDATE `\(mysql_database)`.`\(tableName)` SET \(keyValue) WHERE (`\(whereKey)` = '\(whereValue)')"
        return mysqlStatement(sqlString)
    }

    func selectAllDatabaseSQL(tableName: String) -> (success: Bool, mysqlResuslt: MySQL.Results?, errMsg: String) {
        
        let sqlString = "SELECT * from \(tableName)"
        return mysqlStatement(sqlString)
        
    }
    
    
    /// 查找某一条数据
    ///
    /// - Parameters:
    ///   - tableName: UsersTable
    ///   - keyValue: 键值对( 键='值', 键='值', 键='值' )
    /// - Returns: 执行结构
    func selectAllDatabaseSQLwhere(tableName: String, keyValue: String) -> (success: Bool, mysqlResuslt: MySQL.Results?, errMsg: String) {
        let sqlString = "SELECT * FROM `\(mysql_database)`.`\(tableName)` WHERE \(keyValue);"
        return mysqlStatement(sqlString)
    }

    //
    func selectAllDataFromUsersTable() -> [Dictionary<String, String>] {
        
        let result = selectAllDatabaseSQL(tableName: tableName_UsersTable)
//        var resultArray = [Dictionary<String, String>]()
//        var dic = [String: String]()
//        result.mysqlResuslt?.forEachRow(callback: { (row) in
//            dic[levelId] = row[0]
//            dic[userName] = row[1]
//            resultArray.append(dic)
//        })
//        return resultArray
        return self.changeDataArrayFromTable(result: result.mysqlResuslt)
    }
    
    //MARK: 转换数据
    func changeDataArrayFromTable(result: MySQL.Results?) -> [Dictionary<String, String>] {
        var resultArray = [Dictionary<String, String>]()
        var dic = [String: String]()
        result?.forEachRow(callback: { (row) in
            dic[levelId] = row[0]
            dic[userName] = row[1]
            resultArray.append(dic)
        })
        return resultArray
    }

    
}
