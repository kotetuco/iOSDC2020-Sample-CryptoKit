/*:
# メッセージ認証コードサンプルコード

## 概要

HMACというアルゴリズムを用いてメッセージ認証コードを算出します。
*/

import CryptoKit
import Foundation

let uuidData = UUID().uuidString.data(using: .utf8)!
let encryptionKey = SymmetricKey(size: .bits256)

// HMAC<SHA512>.MAC
let authenticationCode = HMAC<SHA512>.authenticationCode(for: uuidData, using: encryptionKey)
authenticationCode

let isValid = HMAC<SHA512>.isValidAuthenticationCode(authenticationCode,
                                                     authenticating: uuidData,
                                                     using: encryptionKey)
print(isValid) // true

/*:
## (おまけ)メッセージ認証コードのData型への変換について

HMAC<SHA512>.MAC型はDataProtocolに準拠しているため、Dataのイニシャライザを使って容易にData型へ変換できる。
*/

let authData = Data(authenticationCode)
print(authData.compactMap{ String(format: "%02x", $0) }.joined())

//: [トップページに戻る](Top)
