/*:
# 共通鍵暗号サンプルコード

## 概要

AESというアルゴリズムを用いて暗号化と復号化を行います。
*/

import CryptoKit
import Foundation

let uuidString = UUID().uuidString
let uuidData = uuidString.data(using: .utf8)!
let encryptionKey = SymmetricKey(size: .bits256)

let sealed = try! AES.GCM.seal(uuidData, using: encryptionKey) // AES.GCM.SealedBox
let decrypted = try! AES.GCM.open(sealed, using: encryptionKey) // Data

print(uuidData == decrypted) // true

/*:
## (おまけ)AES.GCM.SealedBox型以外へ変換した上での復号化について

Apple CryptoKitを使ってAES暗号化を行った場合、単純なAES暗号化ではなく `AES-GCM` 方式で暗号化が行われる。

AES-GCM方式で暗号化を行う際には暗号化キーの他に `ノンス` (Apple CryptoKitだとnonceと呼ばれるAES.GCM.Nonce型のパラメータ)というランダムな値を初期ベクトルとして使うことで暗号化が行われます(ノンスはApple CryptoKit内で生成されます)。

また、暗号化を行うことにより、暗号化したデータ(CryptoKitだとciphertextというData型のパラメータ)の他に `認証タグ` (Apple CryptoKitだとtagと呼ばれるData型のパラメータ)という情報が出力されます。認証タグは復号化時の暗号の認証に使われます。

従って、復号化を行う場合は暗号化キーと暗号化したデータの他に、ノンスと認証タグも保持しておく必要があることに注意してください。

ノンスと認証タグを個別に取得するようなニーズがなく、単純に暗号化と復号化を行いたいだけであれば、暗号化したデータ、ノンス、タグを結合したデータ(Apple CryptoKitだと `combined` というData型のパラメータ)として出力することで、復号化時はこのデータと暗号化キーのみで復号化を行うことができます。

※ combinedは [nonce, ciphertext, tag] の順番で結合されて出力されます。データサイズはこれら3つのパラメータの和です。
*/

// ciphertext
let ciphertext = sealed.ciphertext
print(ciphertext.compactMap{ String(format: "%02x", $0) }.joined())

// nonce
let nonce = sealed.nonce
print(Data(nonce).compactMap{ String(format: "%02x", $0) }.joined())

// tag
let tag = sealed.tag
print(tag.compactMap{ String(format: "%02x", $0) }.joined())

// combined
let combined = sealed.combined!
print(combined.compactMap{ String(format: "%02x", $0) }.joined())

// ciphertext, nonce, tagを使ってAES.GCM.SealedBoxを復元した上で復号化する
let sealedBoxFromSomeData
    = try! AES.GCM.SealedBox(nonce: nonce, ciphertext: ciphertext, tag: tag)
let decryptedFromSomeData = try! AES.GCM.open(sealedBoxFromSomeData, using: encryptionKey)
print(uuidData == decryptedFromSomeData) // true

// combinedを使ってAES.GCM.SealedBoxを復元した上で復号化する
let sealedBoxFromCombinedData = try! AES.GCM.SealedBox(combined: combined)
let decryptedFromCombinedData = try! AES.GCM.open(sealedBoxFromCombinedData, using: encryptionKey)
print(uuidData == decryptedFromCombinedData) // true

//: [トップページに戻る](Top)
