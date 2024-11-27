import SDWebImage
import Foundation
import os

@available(iOS 14.0, *)
@objc(FastGifViewManager)
class FastGifViewManager: RCTViewManager {

  override func view() -> (FastGifView) {
    return FastGifView()
  }

  @objc override static func requiresMainQueueSetup() -> Bool {
    return true
  }
  @objc(clearCache:rejecter:)
  func clearCache(resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
      DispatchQueue.global(qos: .userInteractive).async {
      SDImageCache.shared.clearMemory()
      SDImageCache.shared.clearDisk()
      DispatchQueue.main.async {
        resolve(true)
        }
      }
  }
}

struct ImageOptions: Decodable {
  let url: String
  let color: String?
}


@available(iOS 14.0, *)
class FastGifView : UIView {
  @available(iOS 14.0, *)
  private static let logger = Logger(
         subsystem: Bundle.main.bundleIdentifier!,
         category: String(describing: FastGifView.self)
     )

  init() {
    super.init(frame: .zero)
    self.addSubview(imageView)
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.contentMode = .scaleToFill


    SDWebImageManager.shared.optionsProcessor = SDWebImageOptionsProcessor() { url, options, context in
        var mutableOptions = options
        mutableOptions.insert(.avoidDecodeImage)
        return SDWebImageOptionsResult(options: mutableOptions, context: context)
    }

    NSLayoutConstraint.activate([
      imageView.topAnchor.constraint(equalTo: topAnchor),
      imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
      imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
      imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
          ])

  }


  required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Views

  private lazy var imageView = SDAnimatedImageView()


  // MARK: - Callbacks

  @objc var onError: RCTDirectEventBlock?
  @objc var onSuccess: RCTDirectEventBlock?

  @objc var source: NSDictionary? = nil {
    didSet{

      guard let source = source else {
                      onError?([
                          "error": "Expected a valid source but got: \("nil")",
                      ])
                      return
                  }
      do {

        let options = try KeyValueDecoder().decode(ImageOptions.self, from: source)
        if #available(iOS 14.0, *) {
          Self.logger.trace("Start product list fetching")
        } else {
          // Fallback on earlier versions
        }
        if let url = URL(string: options.url) {
          let urlRequestFromOptions = url

          urlRequest = urlRequestFromOptions
        }

        if let color = (options.color) {
          colorSet = color
        }

        Self.logger.trace("url = \(options.url)")
      } catch {
        Self.logger.trace("Start product list error")

      }
    }
  }

  @objc var urlRequest: URL? = nil {
          didSet {
            imageView.sd_setImage(with: urlRequest)
          }
      }

  @objc var colorSet: String = "" {
      didSet {
        self.backgroundColor = hexStringToUIColor(hexColor: colorSet)
      }
    }


  func hexStringToUIColor(hexColor: String) -> UIColor {
      let stringScanner = Scanner(string: hexColor)

      if(hexColor.hasPrefix("#")) {
        stringScanner.scanLocation = 1
      }
      var color: UInt32 = 0
      stringScanner.scanHexInt32(&color)

      let r = CGFloat(Int(color >> 16) & 0x000000FF)
      let g = CGFloat(Int(color >> 8) & 0x000000FF)
      let b = CGFloat(Int(color) & 0x000000FF)



      return UIColor(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: 1)
    }
}
