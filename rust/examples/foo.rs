extern crate skia;

use std::ptr;

use skia::skia_bind::{SkImageInfo, SkSurface, SkAlphaType};

fn main() {
    unsafe {
        let image_info = SkImageInfo::MakeS32(100, 100, SkAlphaType::kPremul_SkAlphaType);
        let surface = SkSurface::MakeRaster(&image_info, 0, ptr::null());
    }
}
