//
//  PlaySyntax.swift
//  SwiftPamphletApp
//
//  Created by Ming Dai on 2022/1/17.
//

import Foundation

extension URLSession {
    func dataTaskWithResult(
        with url: URL,
        handler: @escaping (Result<Data, Error>) -> Void
    ) -> URLSessionDataTask {
        dataTask(with: url) { data, _, err in
            if let err = err {
                handler(.failure(err))
            } else {
                handler(.success(data ?? Data()))
            }
        }
    }
}

class PlaySyntax {
    
    static func result() {
        
        let url = URL(string: "https://ming1016.github.io/")!
        
        // 以前网络请求
        let t1 = URLSession.shared.dataTask(with: url) {
            data, response, error in
            if let err = error {
                print(err)
            } else if let data = data {
                print(String(decoding: data, as: UTF8.self))
            }
        }
        t1.resume()
        
        // 使用 Result 网络请求
        let t2 = URLSession.shared.dataTaskWithResult(with: url) { result in
            switch result {
            case .success(let data):
                print(String(decoding: data, as: UTF8.self))
            case .failure(let err):
                print(err)
            }
        }
        t2.resume()
    }
    
    static func array() {
        var a0: [Int] = [1, 10]
        a0.append(2)
        a0.remove(at: 0)
        print(a0) // [10, 2]

        let a1 = ["one", "two", "three"]
        let a2 = ["three", "four"]

        // 找两个集合的不同
        let dif = a1.difference(from: a2) // swift的 diffing 算法在这 http://www.xmailserver.org/diff2.pdf swift实现在  swift/stdlib/public/core/Diffing.swift
        for c in dif {
            switch c {
            case .remove(let o, let e, let a):
                print("offset:\(o), element:\(e), associatedWith:\(String(describing: a))")
            case .insert(let o, let e, let a):
                print("offset:\(o), element:\(e), associatedWith:\(String(describing: a))")
            }
        }
        /*
         remove offset:1, element:four, associatedWith:nil
         insert offset:0, element:one, associatedWith:nil
         insert offset:1, element:two, associatedWith:nil
         */
        let a3 = a2.applying(dif) ?? [] // 可以用于添加删除动画
        print(a3) // ["one", "two", "three"]
        
        // 排序
        struct S1 {
            let n: Int
            var b = true
        }
        
        let a4 = [
            S1(n: 1),
            S1(n: 10),
            S1(n: 3),
            S1(n: 2)
        ]
        let a5 = a4.sorted { i1, i2 in
            i1.n < i2.n
        }
        for n in a5 {
            print(n)
        }
        /// S1(n: 1)
        /// S1(n: 2)
        /// S1(n: 3)
        /// S1(n: 10)
        
        let a6 = [1,10,4,7,2]
        print(a6.sorted(by: >)) // [10, 7, 4, 2, 1]
        
        // 第一个满足条件了就返回
        let a7 = a4.first {
            $0.n == 10
        }
        print(a7?.n ?? 0)
        
        // 是否都满足了条件
        print(a4.allSatisfy { $0.n == 1 }) // false
        print(a4.allSatisfy(\.b)) // true
        
        // 找出最大的那个
        print(a4.max(by: { e1, e2 in
            e1.n < e2.n
        }) ?? S1(n: 0))
        // S1(n: 10, b: true)
        
        // 看看是否包含某个元素
        print(a4.contains(where: {
            $0.n == 7
        }))
        // false
        
        // 切片
        // 取前3个，并不是直接复制，对于大的数组有性能优势。
        print(a6[..<3]) // [1, 10, 4] 需要做越界检查
        print(a6.prefix(30)) // [1, 10, 4, 7, 2] 不需要做越界检查，也是切片，性能一样
        
        // 去掉前3个
        print(a6.dropFirst(3)) // [7, 2]
        
        
    }
    
    static func set() {
        let s0: Set<Int> = [2, 4]
        let s1: Set = [2, 10, 6, 4, 8]
        let s2: Set = [7, 3, 5, 1, 9, 10]

        let s3 = s1.union(s2) // 合集
        let s4 = s1.intersection(s2) // 交集
        let s5 = s1.subtracting(s2) // 非交集部分
        let s6 = s1.symmetricDifference(s2) // 非交集的合集
        print(s3) // [4, 2, 1, 7, 3, 10, 8, 9, 6, 5]
        print(s4) // [10]
        print(s5) // [8, 4, 2, 6]
        print(s6) // [9, 1, 3, 4, 5, 2, 6, 8, 7]

        // s0 是否被 s1 包含
        print(s0.isSubset(of: s1)) // true
        // s1 是否包含了 s0
        print(s1.isSuperset(of: s0)) // true

        let s7: Set = [3, 5]
        // s0 和 s7 是否有交集
        print(s0.isDisjoint(with: s7)) // true

        // 可变 Set
        var s8: Set = ["one", "two"]
        s8.insert("three")
        s8.remove("one")
        print(s8) // ["two", "three"]
    }
    
    static func dictionary() {
        var d = [
            "k1": "v1",
            "k2": "v2"
        ]
        d["k3"] = "v3"
        d["k4"] = nil

        print(d) // ["k2": "v2", "k3": "v3", "k1": "v1"]

        for (k, v) in d {
            print("key is \(k), value is \(v)")
        }
        /*
         key is k1, value is v1
         key is k2, value is v2
         key is k3, value is v3
         */
         
        if d.isEmpty == false {
            print(d.count) // 3
        }
    }
    
    static func string() {
        let s1 = "Hi! This is a string. Cool?"

        /// 转义符 \n 表示换行。
        /// 其它转义字符有 \0 空字符)、\t 水平制表符 、\n 换行符、\r 回车符
        let s2 = "Hi!\nThis is a string. Cool?"
        
        let _ = s1 + s2
        
        // 多行
        let s3 = """
        Hi!
        This is a string.
        Cool?
        """

        // 长度
        print(s3.count)
        print(s3.isEmpty)

        // 拼接
        print(s3 + "\nSure!")

        // 字符串中插入变量
        let i = 1
        print("Today is good day, double \(i)\(i)!")

        /// 遍历字符串
        /// 输出：
        /// o
        /// n
        /// e
        for c in "one" {
            print(c)
        }

        // 查找
        print(s3.lowercased().contains("cool")) // true

        // 替换
        let s4 = "one is two"
        let newS4 = s4.replacingOccurrences(of: "two", with: "one")
        print(newS4)

        // 删除空格和换行
        let s5 = " Simple line. \n\n  "
        print(s5.trimmingCharacters(in: .whitespacesAndNewlines))

        // 切割成数组
        let s6 = "one/two/three"
        let a1 = s6.components(separatedBy: "/") // 继承自 NSString 的接口
        print(a1) // ["one", "two", "three"]
        
        let a2 = s6.split(separator: "/")
        print(a2) // ["one", "two", "three"] 属于切片，性能较 components 更好
        
        // 判断是否是某种类型
        let c1: Character = "🤔"
        print(c1.isASCII) // false
        print(c1.isSymbol) // true
        print(c1.isLetter) // false
        print(c1.isNumber) // false
        print(c1.isUppercase) // false
        
        // 字符串和 Data 互转
        let data = Data("hi".utf8)
        let s7 = String(decoding: data, as: UTF8.self)
        print(s7) // hi
    }
}

