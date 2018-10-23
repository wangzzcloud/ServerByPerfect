// swift-tools-version:4.0

import PackageDescription

//let versions = Version(0,0,0)..<Version(10,0,0)
//
//let urls = [
//    "https://github.com/PerfectlySoft/Perfect-HTTPServer.git",
//    "https://github.com/PerfectlySoft/Perfect-FastCGI.git",
//    "https://github.com/PerfectlySoft/Perfect-CURL.git",
//    "https://github.com/PerfectlySoft/Perfect-PostgreSQL.git",
//    "https://github.com/PerfectlySoft/Perfect-SQLite.git",
//    "https://github.com/PerfectlySoft/Perfect-Redis.git",
//    "https://github.com/PerfectlySoft/Perfect-MySQL.git",
//    "https://github.com/PerfectlySoft/Perfect-MongoDB.git",
//    "https://github.com/PerfectlySoft/Perfect-WebSockets.git",
//    "https://github.com/PerfectlySoft/Perfect-Notifications.git",
//    "https://github.com/PerfectlySoft/Perfect-Mustache.git"
//]


let package = Package(
    name: "MyAwesomeProject",
    dependencies: [
        /*
         每次导入新的依存关系时，需要删除**.xcodeproj,并重新执行添加
         */
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/PerfectlySoft/Perfect-HTTPServer.git", from: "3.0.0"),
        .package(url: "https://github.com/PerfectlySoft/Perfect-MySQL.git", from: "3.0.0"),
        //.package(url: "https://github.com/PerfectlySoft/Perfect-Mustache.git", from: "3.0.0"),
        .package(url: "https://github.com/PerfectlySoft/Perfect-SysInfo.git", from: "3.0.0"),
        ],
    //dependencies: urls.map { .package(url: $0, Range: versions) },
    
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "MyAwesomeProject",
            dependencies: ["PerfectHTTPServer", "PerfectMySQL", "PerfectSysInfo",/*, "PerfectMustache"*/]),
        ]
)
//软件包管理
//import PackageDescription
//
//let versions = Version(0,0,0)..<Version(10,0,0)
//let urls = [
//    "https://github.com/PerfectlySoft/Perfect-HTTPServer.git",      //HTTP服务
//    "https://github.com/PerfectlySoft/Perfect-MySQL.git",           //MySQL服务
//    "https://github.com/PerfectlySoft/Perfect-Mustache.git"         //Mustache
//]
//
//let package = Package(
//    name: "PerfectDemoProject",
//    targets: [],
//    dependencies: urls.map { .Package(url: $0, versions: versions) }
//)

