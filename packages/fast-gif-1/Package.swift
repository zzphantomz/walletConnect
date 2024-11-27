// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "react-native-fast-gif",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        .library(
            name: "react-native-fast-gif",
            targets: ["react-native-fast-gif"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/SDWebImage/SDWebImage.git", from: "5.1.0")
        .package(url: "https://github.com/swhitty/KeyValueCoder.git", branch: "main")
        // .package(url: "https://github.com/liujunliuhong/Crypto-Swift.git", .branchItem("master"))
    ]
)
