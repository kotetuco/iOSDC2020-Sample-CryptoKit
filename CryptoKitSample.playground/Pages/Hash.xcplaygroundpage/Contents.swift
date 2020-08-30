/*:
# ハッシュ関数サンプルコード

## 概要

UUIDをData型へ変換した上でSHA256というアルゴリズムを使ってハッシュ値を算出します。
*/

import CryptoKit
import Foundation

let uuidA = UUID()
let dataA = uuidA.uuidString.data(using: .utf8)!
let hashA = SHA256.hash(data: dataA) // SHA256.Digest

let uuidB = UUID()
let dataB = uuidB.uuidString.data(using: .utf8)!
let hashB = SHA256.hash(data: dataB)

print(hashA == hashB) // ほぼfalse

let dataC = dataA
let hashC = SHA256.hash(data: dataC)

print(hashA == hashC) // true

/*:
## (おまけ) ハッシュ値からData型、文字列への変換

hashメソッドの戻り値は `SHA256.Digest` 型となっている。アプリによってはサーバなどとの連携のためにData型やString型へ変換する必要が発生するかもしれない。

Apple CryptoKitではData型へはDataのイニシャライザにSHA256.Digest型をそのまま指定することで変換可能。

String型への変換については少し手間がかかり、compactMapを使って[UInt8]型へ変換した上で `%02x` ひとつひとつStringへ変換していく必要がある。
*/

// SHA256.Digest
print(hashA)

// SHA256.Digest -> Data
let hashAData = Data(hashA)

// Data -> [UInt8] -> String
print(hashAData.compactMap { String(format: "%02x", $0) }.joined())

// SHA256.Digest -> [UInt8] -> String
print(hashA.compactMap { String(format: "%02x", $0) }.joined())

//: [トップページに戻る](Top)
