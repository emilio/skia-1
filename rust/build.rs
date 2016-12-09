fn main() {
    println!("cargo:rustc-link-search=native=/home/emilio/projects/ig/chromium/src/out/Debug");
    println!("cargo:rustc-link-lib=skia");
    println!("cargo:rustc-link-lib=base");
}
