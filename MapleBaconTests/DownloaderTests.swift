//
//  Copyright © 2017 Jan Gorman. All rights reserved.
//

import XCTest
import MapleBacon
import Hippolyte

class DownloaderTests: XCTestCase {
  
  private let helper = TestHelper()

  override func setUp() {
    super.setUp()
    Hippolyte.shared.start()
  }

  override func tearDown() {
    super.tearDown()
    Hippolyte.shared.stop()
  }

  func testDownload() {
    let expectation = self.expectation(description: "Download image")
    let downloader = Downloader()
    let url = URL(string: "https://www.apple.com/mapleBacon.png")!
    Hippolyte.shared.add(stubbedRequest: helper.request(url: url, response: helper.imageResponse()))

    downloader.download(url) { data in
      XCTAssertNotNil(data)
      expectation.fulfill()
    }

    wait(for: [expectation], timeout: 1)
  }

  func testMultipleDownloads() {
    let expectation = self.expectation(description: "Download image")
    let downloader = Downloader()
    let url1 = URL(string: "https://www.apple.com/mapleBacon.png")!
    let url2 = URL(string: "https://www.apple.com/moreBacon.png")!
    Hippolyte.shared.add(stubbedRequest: helper.request(url: url1, response: helper.imageResponse()))
    Hippolyte.shared.add(stubbedRequest: helper.request(url: url2, response: helper.imageResponse()))

    downloader.download(url1) { data in
      XCTAssertNotNil(data)
    }
    downloader.download(url2) { data in
      XCTAssertNotNil(data)
      expectation.fulfill()
    }

    wait(for: [expectation], timeout: 1)
  }

  func testFailedDownload() {
    let expectation = self.expectation(description: "Download image")
    let downloader = Downloader()
    let url = URL(string: "https://www.apple.com/mapleBacon.png")!
    let anyError = NSError(domain: NSURLErrorDomain, code: NSURLErrorUnknown, userInfo: nil)
    Hippolyte.shared.add(stubbedRequest: helper.request(url: url, response: StubResponse(error: anyError)))

    downloader.download(url) { data in
      XCTAssertNil(data)
      expectation.fulfill()
    }

    wait(for: [expectation], timeout: 1)
  }
}
