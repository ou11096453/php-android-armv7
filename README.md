# PHP 7.3.22 for Ku9 Android TV (32-bit)

酷9 的 PHP 运行包要求 bin/php 和 runner/，脚本通过 php://play.php、php://channel/list.php 运行，HTTP 模式使用 php -S。现有 ARM64 包的 bin/php 是 ELF64/AArch64，而酷9 APK 的 native 库目录是 lib/armeabi-v7a，必须重新编译 ELF32 ARM；重命名不能改变 ABI。

GitHub Actions 固定 NDK 25.2.9519653、API 21、armeabi-v7a，从 PHP 7.3.22 构建 CLI/CGI、OpenSSL、cURL、zlib 和常用扩展，产出 php-7.3.22-android-armeabi-v7a.zip。Actions 结束前会检查 ELF32/ARM、PHP 版本、PHP_INT_SIZE=4 及 curl/json/mbstring/openssl。当前工作区未执行云端构建，因此不能把该 ZIP 声称为已编译成品。

在酷9「工具 -> PHP 设置」安装 ZIP，确认解压后有 bin/php 与 runner/，再把脚本放到设备 php/ 目录，用 php://play.php 或 php://channel/list.php 调用。32 位 APK 在 64 位电视上能否运行取决于厂商是否保留 32 位 native 支持。
