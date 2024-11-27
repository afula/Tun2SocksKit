import Foundation
import Tun2SocksKitC
import HevSocks5Tunnel

public enum Socks5Tunnel {

    public enum Config {
        case file(path: URL)
    }


    private static var tunnelFileDescriptor: Int32? {
        var ctlInfo = ctl_info()
        withUnsafeMutablePointer(to: &ctlInfo.ctl_name) {
            $0.withMemoryRebound(to: CChar.self, capacity: MemoryLayout.size(ofValue: $0.pointee)) {
                _ = strcpy($0, "com.apple.net.utun_control")
            }
        }
        for fd: Int32 in 0...1024 {
            var addr = sockaddr_ctl()
            var ret: Int32 = -1
            var len = socklen_t(MemoryLayout.size(ofValue: addr))
            withUnsafeMutablePointer(to: &addr) {
                $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                    ret = getpeername(fd, $0, &len)
                }
            }
            if ret != 0 || addr.sc_family != AF_SYSTEM {
                continue
            }
            if ctlInfo.ctl_id == 0 {
                ret = ioctl(fd, CTLIOCGINFO, &ctlInfo)
                if ret != 0 {
                    continue
                }
            }
            if addr.sc_id == ctlInfo.ctl_id {
                return fd
            }
        }
        return nil
    }
    
    public static func run(withConfig config: Config, completionHandler: @escaping (Int32) -> ()) {
        DispatchQueue.global(qos: .userInitiated).async { [completionHandler] () in
            let code: Int32 = Socks5Tunnel.run(withConfig: config)
            completionHandler(code)
        }
    }

    public static func run(withConfig config: Config) -> Int32 {
        guard let fileDescriptor = tunnelFileDescriptor else {
            return -1
        }
        switch config {
        case .file(let path):
            return hev_socks5_tunnel_main(path.path.cString(using: .utf8), fileDescriptor)
        }
    }
    
    
    public static func quit() {
        hev_socks5_tunnel_quit()
    }
}
