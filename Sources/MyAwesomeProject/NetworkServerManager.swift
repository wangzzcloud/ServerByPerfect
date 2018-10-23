//
//  NetworkServerManager.swift
//  MyAwesomeProject
//  Cloud PC 961286
//  login 96
//  pw 19921010wzz
//  Created by 王增战 on 2018/10/15.
//

import PerfectLib
import PerfectHTTP
import PerfectHTTPServer
import PerfectSysInfo

open class NetworkServerManager {
    
    fileprivate var server: HTTPServer
    
    internal init(root: String, port: UInt16) {
        
        server = HTTPServer.init()                              //创建HTTPServer服务器
        var routes = Routes.init(baseUri: "/api")               //创建路由器
        configure(routes: &routes)                              //注册路由
        server.addRoutes(routes)                                //路由添加进服务
        server.documentRoot = root                              //根目录
        server.serverName = "localhost"                         //服务器名称
        server.serverPort = port                                //端口
        server.setResponseFilters([(Filter404(), .high)])       //404过滤
        //server.serverAddress = "192.168.2.199"
    }
    
    //MARK:---------------- 开启服务 ----------------
    open func startServer() {
        
        do {
            print("启动HTTP服务器")
            try server.start()
        } catch PerfectError.networkError(let errorCode, let msg) {
            print("网络出现错误:\(errorCode) \(msg)")
        } catch {
            print("未知错误")
        }
        
        
    }
    
    
    /*
     
     contentType: 由苦户端决定，返回客户端支持的编码方式
     
     */
    
    //MARK:---------------- 注册路由 ----------------
    fileprivate func configure(routes: inout Routes) {
        //添加接口1，请求方式，路径
        
        routes.add(method: .get, uri: "/home") { (request, response) in
            
            //response.setHeader(.contentType, value: "text/html")                //响应头
            //response.setHeader(.contentType, value: "text/html,charset=utf-8")                //响应头
            response.setHeader(.contentType, value: "application/json")                //响应头
            
            let jsonDic = ["name":"Samara"]
            let jsonString = self.baseResponseBodyJSONData(status: 200, message: "GET success!", data: jsonDic)
            response.setBody(string: jsonString)                                //响应体
            response.completed()                                                //响应
        }
        
        //添加接口2: 查 查询某数据库中所有的数据
        routes.add(method: .post, uri: "/home1") { (request, response) in
            
            //需要解析的数据在request.postParams里
            
            response.setHeader(.contentType, value: "application/json")                //响应头
//            response.setHeader(.contentType, value: "text/html")                //响应头
            let result = DataBaseManager.init().selectAllDataFromUsersTable()
            let jsonString = self.baseResponseBodyJSONData(status: 200, message: "GET", data: result)
            
            response.setBody(string: jsonString)                                //响应体
            response.completed()                                                //响应
        }
        
        //添加接口3: 增：插入数据
        routes.add(method: .get, uri: "home2") { (request, response) in
            response.setHeader(.contentType, value: "application/json")
            
            let result = DataBaseManager().insertDatabaseSQL(tableName: tableName_UsersTable, levelId: 1010, name: "王增战")
            let jsonString = self.baseResponseBodyJSONData(status: 200, message: "GET", data: result.errMsg)
            response.setBody(string: jsonString)
            
            response.completed()
            
        }

        // 删
        routes.add(method: .get, uri: "home3") { (request, response) in
            
            response.setHeader(.contentType, value: "application/json")
            
            let result = DataBaseManager().deleteDatabaseSQL(tableName: tableName_UsersTable, key: "level_id", value: "1010")
            let jsonString = self.baseResponseBodyJSONData(status: 200, message: "删", data: result.errMsg)
            
            response.setBody(string: jsonString)
            response.completed()
        }
        
        // 改
        routes.add(method: .get, uri: "home4") { (request, response) in
            
            response.setHeader(.contentType, value: "application/json")
            
            let result = DataBaseManager().updateDatabaseSQL(tableName: tableName_UsersTable, keyValue: "`name` = '铂金'", whereKey: "level_id", whereValue: "1002")
            let jsonString = self.baseResponseBodyJSONData(status: 200, message: result.errMsg, data: result.mysqlResuslt)
            
            response.setBody(string: jsonString)
            response.completed()
            
        }
        
        // 查
        routes.add(method: .get, uri: "home5") { (request, response) in
            response.setHeader(.contentType, value: "application/json")
            
            let result = DataBaseManager().selectAllDatabaseSQLwhere(tableName: tableName_UsersTable, keyValue: "`level_id` = '1000'")
            let resultArray = DataBaseManager().changeDataArrayFromTable(result: result.mysqlResuslt)
            let jsonString = self.baseResponseBodyJSONData(status: 200, message: "查", data: resultArray)
            response.setBody(string: jsonString)
            response.completed()
            
        }
        
    }
    
    //MARK:---------------- 通用响应格式 ----------------
    func baseResponseBodyJSONData(status: Int, message: String, data: Any!) -> String {
        
        var result = Dictionary<String, Any>()
        result.updateValue(status, forKey: "STATUS")
        result.updateValue(message, forKey: "MESSAGE")
        if data != nil {
            result.updateValue(data, forKey: "DATA")
        } else {
            result.updateValue("", forKey: "DATA")
        }
        guard let jsonString = try? result.jsonEncodedString() else {
            return ""
        }
        return jsonString
    }
    
    //MARK:---------------- 404过滤 ----------------
    struct Filter404: HTTPResponseFilter {
        
        func filterBody(response: HTTPResponse, callback: (HTTPResponseFilterResult) -> ()) {
            callback(.continue)
        }
        
        func filterHeaders(response: HTTPResponse, callback: (HTTPResponseFilterResult) -> ()) {
            if case .notFound = response.status {
                response.setBody(string: "404 文件\(response.request.path)不存在")
                response.setHeader(.contentLength, value: "\(response.bodyBytes.count)")
                callback(.done)
            } else {
                callback(.continue)
            }
            
            //打印服务器硬件详情
//            print(SysInfo.CPU)
//            print(SysInfo.Disk)
//            print(SysInfo.Memory)
//            print(SysInfo.Net)
            
            
        }
    }
    
}

