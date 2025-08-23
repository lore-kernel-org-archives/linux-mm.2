Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6FD12CA0EE4
	for <linux-mm@archiver.kernel.org>; Sat, 23 Aug 2025 13:05:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 867CD8E0026; Sat, 23 Aug 2025 09:05:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 83F5D8E0018; Sat, 23 Aug 2025 09:05:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 755738E0026; Sat, 23 Aug 2025 09:05:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5E0538E0018
	for <linux-mm@kvack.org>; Sat, 23 Aug 2025 09:05:29 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DBC3759D86
	for <linux-mm@kvack.org>; Sat, 23 Aug 2025 13:05:28 +0000 (UTC)
X-FDA: 83808043536.12.62A1518
Received: from mailrelay-egress16.pub.mailoutpod3-cph3.one.com (mailrelay-egress16.pub.mailoutpod3-cph3.one.com [46.30.212.3])
	by imf28.hostedemail.com (Postfix) with ESMTP id 0025AC0007
	for <linux-mm@kvack.org>; Sat, 23 Aug 2025 13:05:26 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=konsulko.se header.s=rsa2 header.b=CV1GjsN3;
	dkim=pass header.d=konsulko.se header.s=ed2 header.b=4MlzM4RZ
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755954327;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4zGvXg1y9SeBU8cgWL0AlC/yfYR8vXIZN9LtkXhZ8Ok=;
	b=KdJJPkAehmYvF8b1b6f/8drRuOVcELgH3jk7s2bZL9yL0B6S3MrAYMkWBHF5RByvAU2UMW
	0v6sLcZIphBiARXF2/JI7t0Nn6WQjN3YwRG1QSMY9qYn35mttEGevLTm8oDc5ugf5oX8zh
	46xgQ/tYpxNr6DSeoTPi0nAwQ36YK8Y=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=konsulko.se header.s=rsa2 header.b=CV1GjsN3;
	dkim=pass header.d=konsulko.se header.s=ed2 header.b=4MlzM4RZ;
	spf=none (imf28.hostedemail.com: domain of vitaly.wool@konsulko.se has no SPF policy when checking 46.30.212.3) smtp.mailfrom=vitaly.wool@konsulko.se;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755954327; a=rsa-sha256;
	cv=none;
	b=d0iMeY9WQ20MMT6RgKI9OYnvxrWZuEfErpd+Uod4hYegf4tFHZ4TDLQSV33xrT5UJvx/6o
	vWa0HiCTQmFqTxWx7B+nsnMV4SUp3sxq9OciBF0SnjOzT2+kcuJe1R2UaZtljo6hRGjnHJ
	BQyqs4d42F3Rolhsl0qsUwS+VSdpmww=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1755954325; x=1756559125;
	d=konsulko.se; s=rsa2;
	h=content-transfer-encoding:mime-version:references:in-reply-to:message-id:date:
	 subject:cc:to:from:from;
	bh=4zGvXg1y9SeBU8cgWL0AlC/yfYR8vXIZN9LtkXhZ8Ok=;
	b=CV1GjsN3b5xy3YI/43j9ZjytkE1raoLzfZNC1TIME1ThhM+SWwHGu9eV0FBfichq+lGzZ5qqHqTJs
	 raUdb3v4IXdvXw3wbbbKWwpmAKLaxThvzpVgK5KpnwmEqGBdHClnr+cV3eoMVertf740YS42HzVZ45
	 S0gW4lJgMvQn19/DI2sXLzL2H4H1ZYquhPpFHgsJ7xgz6t3Cqf5y/2UZOvw1mxUEDv6pRoa4poz8K0
	 9AnHyZb+NYvb2AAz098VQlbbZt1XbazRTdjVez/BKb8PUPkngufuya1htfbwr8xDvsGihlICPJfTk8
	 MW5XJ+8vHaNGBkQa4pYBLp8pclM5nSQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1755954325; x=1756559125;
	d=konsulko.se; s=ed2;
	h=content-transfer-encoding:mime-version:references:in-reply-to:message-id:date:
	 subject:cc:to:from:from;
	bh=4zGvXg1y9SeBU8cgWL0AlC/yfYR8vXIZN9LtkXhZ8Ok=;
	b=4MlzM4RZrXxUG481LKKRCLRGkLxIqshj4V5NmZ3QCHTz0014KncuBdjbSnOPovxTU54ykFO8xhUek
	 khqbS0LAA==
X-HalOne-ID: d42fd706-8021-11f0-b365-4f541c8bf1cc
Received: from localhost.localdomain (host-95-203-16-218.mobileonline.telia.com [95.203.16.218])
	by mailrelay3.pub.mailoutpod2-cph3.one.com (Halon) with ESMTPSA
	id d42fd706-8021-11f0-b365-4f541c8bf1cc;
	Sat, 23 Aug 2025 13:05:24 +0000 (UTC)
From: Vitaly Wool <vitaly.wool@konsulko.se>
To: rust-for-linux@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Uladzislau Rezki <urezki@gmail.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	Bjorn Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Trevor Gross <tmgross@umich.edu>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Nhat Pham <nphamcs@gmail.com>,
	linux-mm@kvack.org,
	Vitaly Wool <vitaly.wool@konsulko.se>
Subject: [PATCH v4 2/2] rust: zpool: add abstraction for zpool drivers
Date: Sat, 23 Aug 2025 15:05:22 +0200
Message-Id: <20250823130522.867263-1-vitaly.wool@konsulko.se>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250823130420.867133-1-vitaly.wool@konsulko.se>
References: <20250823130420.867133-1-vitaly.wool@konsulko.se>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ejguryoyt8ge1qwfsjgca147a5xn8dtb
X-Rspam-User: 
X-Rspamd-Queue-Id: 0025AC0007
X-Rspamd-Server: rspam01
X-HE-Tag: 1755954326-877359
X-HE-Meta: U2FsdGVkX18VkH2KY7bagPCjS/uqzR4TKLdxZ4SOQTVW0K052uAtJZSTxRYSENdb4mjHa9c3XeW+cK9SzQdynzl8xWU2+laVTKQV6TbzGo2Bbd8fhVG3YMISvT9iaiyUcinA7sBGRarzuG0akKhqhfJP/uTOvTah4CRUnHdKcg+1BQiqnwcuTIu1zC7nXvzTsDPkkGeEPaxrRc72qr6BmKBmlKhy9vPK8t/eENPRyJls3CRI1al+y8Om4DhlgI56YDlf7z+PPAT6DkHYj/k9Jyv4yLm8/9b1krwdXFPZi/B7vTW23ZtY7bC2NhqHeHeUOkOxzRE2HCdzfhgTYtwkpCgYjUluUglFkFZ+b7K60nUxXKM5TgvGD8h09oavSSvVP0GYk+e+dPUESpM5JeTJER7vKwhSWo3evKlMzUtVJ0xavzWviyTWU2z9aZWlDL9jVJK3gzEycmVriFQRt2FWGd+f3SN3eNIALFDZonBWMNzDIWmFhhy7L2X/E+gmaOGqDo9C7l9S2FMLyD4vAYmRIVyp4rmyyf78ntYF1UZA0XVJ36l7E3Lub6+s+rG6FSVDutSMwUuQzAbdLAanDGGZO+vaoRllJ6vR2evk3w5jiaaZjiRHYrMBub7eDW7GnVSl4IxxUv0jFrFAEke3JOwjre5PcZQTzYts+NYxhfFb7q9IMPDQOme8eExZocqXidotQ00kVuMRdUSC0i3hZKquKK69GlG738xD+A3DuflVj/bYF4+BSBQ0FF7IGiypf6DV8YvMtPv0DU5YeSk65h1uWYjy3Hr918xxMJgdMa2NqGltCgE5gUajmpjD4Hfs+mgapFMqYq6PZAQfd4g98R7KUqZULpI0O974dzC2ObNSr+++yCGnp1+0KWoJZ/Fz8kQIPp3/r5FvZ+N+JsXBUBvT0Jcw9fh7bA8EGuZYLaHB28oRbmAyZ4y0iqBn53eX+aR0iOOTo6FLEjyt9KExWh8
 Xb2BS0yQ
 JbOdnE51pjaixsBGSkTU+nkQpQQl/erQpxlNpfDyzIy8ubShR3aBQCT1CwR5Jn6cohBIhZVVWn2W1CMxmZZaulPvJNbTOD3xdDbd5ZJl/jKfJqtTphzQvjELZM85t3tGaWozbW5Bi9x7WWDrxW5BhwHqrf4PQmFfhG4rZHmVYxWpxKAVshPuR91rbAFD2fF9AOynWWkFahkEZXeHnoHadXFUjOAJbBcSkv2E8dYL8r9+CwPs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Zpool is a common frontend for memory storage pool implementations.
These pools are typically used to store compressed memory objects,
e. g. for Zswap, the lightweight compressed cache for swap pages.

This patch provides the interface to use Zpool in Rust kernel code,
thus enabling Rust implementations of Zpool allocators for Zswap.

Co-developed-by: Alice Ryhl <aliceryhl@google.com>
Signed-off-by: Alice Ryhl <aliceryhl@google.com>
Signed-off-by: Vitaly Wool <vitaly.wool@konsulko.se>
---
 rust/bindings/bindings_helper.h |   1 +
 rust/helpers/helpers.c          |   1 +
 rust/helpers/zpool.c            |   6 +
 rust/kernel/lib.rs              |   2 +
 rust/kernel/zpool.rs            | 338 ++++++++++++++++++++++++++++++++
 5 files changed, 348 insertions(+)
 create mode 100644 rust/helpers/zpool.c
 create mode 100644 rust/kernel/zpool.rs

diff --git a/rust/bindings/bindings_helper.h b/rust/bindings/bindings_helper.h
index 84d60635e8a9..f0c4c454882b 100644
--- a/rust/bindings/bindings_helper.h
+++ b/rust/bindings/bindings_helper.h
@@ -75,6 +75,7 @@
 #include <linux/wait.h>
 #include <linux/workqueue.h>
 #include <linux/xarray.h>
+#include <linux/zpool.h>
 #include <trace/events/rust_sample.h>
 
 #if defined(CONFIG_DRM_PANIC_SCREEN_QR_CODE)
diff --git a/rust/helpers/helpers.c b/rust/helpers/helpers.c
index 7cf7fe95e41d..e1a7556cc700 100644
--- a/rust/helpers/helpers.c
+++ b/rust/helpers/helpers.c
@@ -51,3 +51,4 @@
 #include "wait.c"
 #include "workqueue.c"
 #include "xarray.c"
+#include "zpool.c"
diff --git a/rust/helpers/zpool.c b/rust/helpers/zpool.c
new file mode 100644
index 000000000000..71ba173f917a
--- /dev/null
+++ b/rust/helpers/zpool.c
@@ -0,0 +1,6 @@
+#include <linux/zpool.h>
+
+void rust_helper_zpool_register_driver(struct zpool_driver *driver)
+{
+	zpool_register_driver(driver);
+}
diff --git a/rust/kernel/lib.rs b/rust/kernel/lib.rs
index ed53169e795c..165d52feeea4 100644
--- a/rust/kernel/lib.rs
+++ b/rust/kernel/lib.rs
@@ -129,6 +129,8 @@
 pub mod uaccess;
 pub mod workqueue;
 pub mod xarray;
+#[cfg(CONFIG_ZPOOL)]
+pub mod zpool;
 
 #[doc(hidden)]
 pub use bindings;
diff --git a/rust/kernel/zpool.rs b/rust/kernel/zpool.rs
new file mode 100644
index 000000000000..88b863b71c8d
--- /dev/null
+++ b/rust/kernel/zpool.rs
@@ -0,0 +1,338 @@
+use crate::{
+    bindings,
+    error::{from_result, Result},
+    kernel::alloc::Flags,
+    str::CStr,
+    types::{ForeignOwnable, Opaque},
+};
+use core::ffi::{c_int, c_uchar, c_void};
+use core::ptr::{null_mut, NonNull};
+use kernel::alloc::NumaNode;
+use kernel::driver;
+use kernel::ThisModule;
+
+/// Zpool API.
+///
+/// The [`ZpoolDriver`] trait serves as an interface for Zpool drivers implemented in Rust.
+/// Such drivers implement memory storage pools in accordance with the zpool API.
+///
+/// # Example
+///
+/// A zpool driver implementation which uses KVec of 2**n sizes, n = 6, 7, ..., PAGE_SHIFT.
+/// Every zpool object is packed into a KVec that is sufficiently large, and n (the
+/// denominator) is saved in the least significant bits of the handle, which is guaranteed
+/// to be at least 2**6 aligned by kmalloc.
+///
+/// ```
+/// use core::ptr::{NonNull, copy_nonoverlapping};
+/// use core::sync::atomic::{AtomicU64, Ordering};
+/// use kernel::alloc::{Flags, KBox, KVec, NumaNode};
+/// use kernel::page::PAGE_SHIFT;
+/// use kernel::prelude::EINVAL;
+/// use kernel::zpool::*;
+///
+/// struct MyZpool {
+///     name: &'static CStr,
+///     bytes_used: AtomicU64,
+/// }
+///
+/// struct MyZpoolDriver;
+///
+/// impl ZpoolDriver for MyZpoolDriver {
+///     type Pool = KBox<MyZpool>;
+///
+///     fn create(name: &'static CStr, gfp: Flags) -> Result<KBox<MyZpool>> {
+///         let my_pool = MyZpool { name, bytes_used: AtomicU64::new(0) };
+///         let pool = KBox::new(my_pool, gfp)?;
+///
+///         Ok(pool)
+///     }
+///
+///     fn destroy(p: KBox<MyZpool>) {
+///         drop(p);
+///     }
+///
+///     fn malloc(pool: &mut MyZpool, size: usize, gfp: Flags, _nid: NumaNode) -> Result<usize> {
+///         let mut pow: usize = 0;
+///         for n in 6..=PAGE_SHIFT {
+///             if size <= 1 << n {
+///                 pow = n;
+///                 break;
+///             }
+///         }
+///         match pow {
+///             0 => Err(EINVAL),
+///             _ => {
+///                 let vec = KVec::<u64>::with_capacity(1 << (pow - 3), gfp)?;
+///                 let (ptr, _len, _cap) = vec.into_raw_parts();
+///                 pool.bytes_used.fetch_add(1 << pow, Ordering::Relaxed);
+///                 Ok(ptr as usize | (pow - 6))
+///             }
+///         }
+///     }
+///
+///     unsafe fn free(pool: &MyZpool, handle: usize) {
+///         let n = (handle & 0x3F) + 3;
+///         let uptr = handle & !0x3F;
+///
+///         // SAFETY:
+///         // - uptr comes from handle which points to the KVec allocation from `alloc`.
+///         // - size == capacity and is coming from the first 6 bits of handle.
+///         let vec = unsafe { KVec::<u64>::from_raw_parts(uptr as *mut u64, 1 << n, 1 << n) };
+///         drop(vec);
+///         pool.bytes_used.fetch_sub(1 << (n + 3), Ordering::Relaxed);
+///     }
+///
+///     unsafe fn read_begin(_pool: &MyZpool, handle: usize) -> NonNull<u8> {
+///         let uptr = handle & !0x3F;
+///         // SAFETY: uptr points to a memory area allocated by KVec
+///         unsafe { NonNull::new_unchecked(uptr as *mut u8) }
+///     }
+///
+///     unsafe fn read_end(_pool: &MyZpool, _handle: usize, _handle_mem: NonNull<u8>) {}
+///
+///     unsafe fn write(_p: &MyZpool, handle: usize, handle_mem: NonNull<u8>, mem_len: usize) {
+///         let uptr = handle & !0x3F;
+///         // SAFETY: handle_mem is a valid non-null pointer provided by zpool, uptr points to
+///         // a KVec allocated in `malloc` and is therefore also valid.
+///         unsafe {
+///             copy_nonoverlapping(handle_mem.as_ptr().cast(), uptr as *mut c_void, mem_len)
+///         };
+///     }
+///
+///     fn total_pages(pool: &MyZpool) -> u64 {
+///         pool.bytes_used.load(Ordering::Relaxed) >> PAGE_SHIFT
+///     }
+/// }
+/// ```
+///
+pub trait ZpoolDriver {
+    /// Opaque Rust representation of `struct zpool`.
+    type Pool: ForeignOwnable;
+
+    /// Create a pool.
+    fn create(name: &'static CStr, gfp: Flags) -> Result<Self::Pool>;
+
+    /// Destroy the pool.
+    fn destroy(pool: Self::Pool);
+
+    /// Allocate an object of size `size` bytes from `pool`, with the allocation flags `gfp` and
+    /// preferred NUMA node `nid`. If the allocation is successful, an opaque handle is returned.
+    fn malloc(
+        pool: <Self::Pool as ForeignOwnable>::BorrowedMut<'_>,
+        size: usize,
+        gfp: Flags,
+        nid: NumaNode,
+    ) -> Result<usize>;
+
+    /// Free a previously allocated from the `pool` object, represented by `handle`.
+    ///
+    /// # Safety
+    ///
+    /// - `handle` must be a valid handle previously returned by `malloc`.
+    /// - `handle` must not be used any more after the call to `free`.
+    unsafe fn free(pool: <Self::Pool as ForeignOwnable>::Borrowed<'_>, handle: usize);
+
+    /// Make all the necessary preparations for the caller to be able to read from the object
+    /// represented by `handle` and return a valid pointer to the `handle` memory to be read.
+    ///
+    /// # Safety
+    ///
+    /// - `handle` must be a valid handle previously returned by `malloc`.
+    /// - `read_end` with the same `handle` must be called for each `read_begin`.
+    unsafe fn read_begin(
+        pool: <Self::Pool as ForeignOwnable>::Borrowed<'_>,
+        handle: usize,
+    ) -> NonNull<u8>;
+
+    /// Finish reading from a previously allocated `handle`. `handle_mem` must be the pointer
+    /// previously returned by `read_begin`.
+    ///
+    /// # Safety
+    ///
+    /// - `handle` must be a valid handle previously returned by `malloc`.
+    /// - `handle_mem` must be the pointer previously returned by `read_begin`.
+    unsafe fn read_end(
+        pool: <Self::Pool as ForeignOwnable>::Borrowed<'_>,
+        handle: usize,
+        handle_mem: NonNull<u8>,
+    );
+
+    /// Write to the object represented by a previously allocated `handle`. `handle_mem` points
+    /// to the memory to copy data from, and `mem_len` defines the length of the data block to
+    /// be copied.
+    ///
+    /// # Safety
+    ///
+    /// - `handle` must be a valid handle previously returned by `malloc`.
+    /// - `handle_mem` must be a valid pointer to an allocated memory area.
+    /// - `handle_mem` + `mem_len` must not point outside the allocated memory area.
+    unsafe fn write(
+        pool: <Self::Pool as ForeignOwnable>::Borrowed<'_>,
+        handle: usize,
+        handle_mem: NonNull<u8>,
+        mem_len: usize,
+    );
+
+    /// Get the number of pages used by the `pool`.
+    fn total_pages(pool: <Self::Pool as ForeignOwnable>::Borrowed<'_>) -> u64;
+}
+
+/// An "adapter" for the registration of zpool drivers.
+pub struct Adapter<T: ZpoolDriver>(T);
+
+impl<T: ZpoolDriver> Adapter<T> {
+    extern "C" fn create_(name: *const c_uchar, gfp: u32) -> *mut c_void {
+        // SAFETY: the memory pointed to by name is guaranteed by zpool to be a valid string
+        let pool = unsafe { T::create(CStr::from_char_ptr(name), Flags::from_raw(gfp)) };
+        match pool {
+            Err(_) => null_mut(),
+            Ok(p) => T::Pool::into_foreign(p),
+        }
+    }
+    extern "C" fn destroy_(pool: *mut c_void) {
+        // SAFETY: The pointer originates from an `into_foreign` call.
+        T::destroy(unsafe { T::Pool::from_foreign(pool) })
+    }
+    extern "C" fn malloc_(
+        pool: *mut c_void,
+        size: usize,
+        gfp: u32,
+        handle: *mut usize,
+        nid: c_int,
+    ) -> c_int {
+        // SAFETY: The pointer originates from an `into_foreign` call. If `pool` is passed to
+        // `from_foreign`, then that happens in `_destroy` which will not be called during this
+        // method.
+        let pool = unsafe { T::Pool::borrow_mut(pool) };
+
+        from_result(|| {
+            let real_nid = match nid {
+                bindings::NUMA_NO_NODE => NumaNode::NO_NODE,
+                _ => NumaNode::new(nid)?,
+            };
+            let h = T::malloc(pool, size, Flags::from_raw(gfp), real_nid)?;
+            // SAFETY: handle is guaranteed to be a valid pointer by zpool.
+            unsafe { *handle = h };
+            Ok(0)
+        })
+    }
+    extern "C" fn free_(pool: *mut c_void, handle: usize) {
+        // SAFETY: The pointer originates from an `into_foreign` call. If `pool` is passed to
+        // `from_foreign`, then that happens in `_destroy` which will not be called during this
+        // method.
+        let pool = unsafe { T::Pool::borrow(pool) };
+
+        // SAFETY: the caller (zswap) guarantees that `handle` is a valid handle previously
+        // allocated by `malloc`.
+        unsafe { T::free(pool, handle) }
+    }
+    extern "C" fn obj_read_begin_(
+        pool: *mut c_void,
+        handle: usize,
+        _local_copy: *mut c_void,
+    ) -> *mut c_void {
+        // SAFETY: The pointer originates from an `into_foreign` call. If `pool` is passed to
+        // `from_foreign`, then that happens in `_destroy` which will not be called during this
+        // method.
+        let pool = unsafe { T::Pool::borrow(pool) };
+
+        // SAFETY: the caller (zswap) guarantees that `handle` is a valid handle previously
+        // allocated by `malloc`.
+        let non_null_ptr = unsafe { T::read_begin(pool, handle) };
+        non_null_ptr.as_ptr().cast()
+    }
+    extern "C" fn obj_read_end_(pool: *mut c_void, handle: usize, handle_mem: *mut c_void) {
+        // SAFETY: The pointer originates from an `into_foreign` call. If `pool` is passed to
+        // `from_foreign`, then that happens in `_destroy` which will not be called during this
+        // method.
+        let pool = unsafe { T::Pool::borrow(pool) };
+
+        // SAFETY: handle_mem is guaranteed to be non-null by the caller (zswap)
+        let handle_mem_ptr = unsafe { NonNull::new_unchecked(handle_mem.cast()) };
+
+        // SAFETY: the caller (zswap) guarantees that `handle` is a valid handle previously
+        // allocated by `malloc`.
+        unsafe { T::read_end(pool, handle, handle_mem_ptr) }
+    }
+    extern "C" fn obj_write_(
+        pool: *mut c_void,
+        handle: usize,
+        handle_mem: *mut c_void,
+        mem_len: usize,
+    ) {
+        // SAFETY: The pointer originates from an `into_foreign` call. If `pool` is passed to
+        // `from_foreign`, then that happens in `_destroy` which will not be called during this
+        // method.
+        let pool = unsafe { T::Pool::borrow(pool) };
+
+        // SAFETY: handle_mem is guaranteed to be non-null by the caller (zswap)
+        let handle_mem_ptr = unsafe { NonNull::new_unchecked(handle_mem.cast()) };
+
+        // SAFETY: the caller (zswap) guarantees that `handle` is a valid handle previously
+        // allocated by `malloc`.
+        unsafe {
+            T::write(pool, handle, handle_mem_ptr, mem_len);
+        }
+    }
+    extern "C" fn total_pages_(pool: *mut c_void) -> u64 {
+        // SAFETY: The pointer originates from an `into_foreign` call. If `pool` is passed to
+        // `from_foreign`, then that happens in `_destroy` which will not be called during this
+        // method.
+        let pool = unsafe { T::Pool::borrow(pool) };
+        T::total_pages(pool)
+    }
+}
+
+// SAFETY: A call to `unregister` for a given instance of `RegType` is guaranteed to be valid
+// because preceding call to `register` never fails for zpool.
+unsafe impl<T: ZpoolDriver + 'static> driver::RegistrationOps for Adapter<T> {
+    type RegType = bindings::zpool_driver;
+
+    unsafe fn register(
+        pdrv: &Opaque<Self::RegType>,
+        name: &'static CStr,
+        _module: &'static ThisModule,
+    ) -> Result {
+        // SAFETY: It's safe to set the fields of `struct zpool_driver` on initialization.
+        unsafe {
+            (*(pdrv.get())).type_ = name.as_char_ptr().cast_mut();
+            (*(pdrv.get())).create = Some(Self::create_);
+            (*(pdrv.get())).destroy = Some(Self::destroy_);
+            (*(pdrv.get())).malloc = Some(Self::malloc_);
+            (*(pdrv.get())).free = Some(Self::free_);
+            (*(pdrv.get())).obj_read_begin = Some(Self::obj_read_begin_);
+            (*(pdrv.get())).obj_read_end = Some(Self::obj_read_end_);
+            (*(pdrv.get())).obj_write = Some(Self::obj_write_);
+            (*(pdrv.get())).total_pages = Some(Self::total_pages_);
+
+            bindings::zpool_register_driver(pdrv.get());
+        }
+        Ok(())
+    }
+    unsafe fn unregister(pdrv: &Opaque<Self::RegType>) {
+        // SAFETY: `pdrv` is guaranteed to be a valid `RegType`.
+        unsafe { bindings::zpool_unregister_driver(pdrv.get()) };
+    }
+}
+
+/// Declares a kernel module that exposes a zpool driver (i. e. an implementation of the zpool
+/// API).
+///
+/// # Examples
+///
+///```ignore
+/// kernel::module_zpool_driver! {
+///     type: MyDriver,
+///     name: "Module name",
+///     authors: ["Author name"],
+///     description: "Description",
+///     license: "GPL",
+/// }
+///```
+#[macro_export]
+macro_rules! module_zpool_driver {
+($($f:tt)*) => {
+    $crate::module_driver!(<T>, $crate::zpool::Adapter<T>, { $($f)* });
+};
+}
-- 
2.39.2


