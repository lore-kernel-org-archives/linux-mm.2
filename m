Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BC8DCA0EDC
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 11:17:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 971898E002A; Thu, 21 Aug 2025 07:17:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9494D8E0013; Thu, 21 Aug 2025 07:17:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 864708E002A; Thu, 21 Aug 2025 07:17:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 75C1C8E0013
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 07:17:35 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CEBDE1603A5
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 11:17:34 +0000 (UTC)
X-FDA: 83800514028.29.A3319DD
Received: from mailrelay-egress16.pub.mailoutpod3-cph3.one.com (mailrelay-egress16.pub.mailoutpod3-cph3.one.com [46.30.212.3])
	by imf26.hostedemail.com (Postfix) with ESMTP id 8C16A140012
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 11:17:32 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=konsulko.se header.s=rsa1 header.b=mrHgVwxF;
	dkim=pass header.d=konsulko.se header.s=ed1 header.b=U1Qaw8Wq
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755775053;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=90mdrgdRq9HDlMW2ikk8FQxgFJBsKRfFPXP+WnfuSBA=;
	b=gFUH2xCZI9OmUxk8wUylEE6wd//qiOvYRC5rvVn1ypuecHIztK4WIb5ld8hkGCwXD8V1nT
	F42oTsY396/ToHJ28gyfYwcl9JCVxmlnjfcz83Y4damBTxiA8aZ6HNrOD9lTZe4Jvs9GGn
	iCryWm/DhMFvXQkPt2zsWdu0V3teSKs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755775053; a=rsa-sha256;
	cv=none;
	b=ROEUNwrwvwlCt+fnSWh9jIJ7vLOz9w6W53v6PeMptgWO2xoNB8lQ32Oor+X0zCAWb5AFEk
	GAh22BpsHSCH+S5CXDkmnkIDhi4ahlQ2JZed/MvuMGI8NAnMFAoOn9kIHd/PTsZcpWPEus
	264iEVmqq99e7EGqbgESu/0CjQIbRUA=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=konsulko.se header.s=rsa1 header.b=mrHgVwxF;
	dkim=pass header.d=konsulko.se header.s=ed1 header.b=U1Qaw8Wq;
	spf=none (imf26.hostedemail.com: domain of vitaly.wool@konsulko.se has no SPF policy when checking 46.30.212.3) smtp.mailfrom=vitaly.wool@konsulko.se;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1755775049; x=1756379849;
	d=konsulko.se; s=rsa1;
	h=content-transfer-encoding:mime-version:message-id:date:subject:cc:to:from:
	 from;
	bh=90mdrgdRq9HDlMW2ikk8FQxgFJBsKRfFPXP+WnfuSBA=;
	b=mrHgVwxFroahu7FKfc3q3GusY2eSbRM0nPGfQvGZptMXkiA/Ehd8Bn3NDqCOe4nrGNnCr8HUi8CRo
	 f/dW3tLbq9NaMzbtDrIYrif/eW+GQXi3Z8kgf0p3FLpuhog2tFhV9A/K0j1/vbTK4vVhq6A22L3WT7
	 EZ4iZNaljCJ6t5dodOv9FVdy49wp+MFJh6jMItcKKqvc5kwcZqIE5PUuxLXO0A7g2DpR319ttq33E3
	 16ITBJz3j7BbQGc/5YBDv1kiCc+csGkEC4Ofi8iMnKgQpSUkJDtChTdG/CYhz97a94IQxuI3Vo+20s
	 nBFBMUflHhUU9Wh4P6mKInvAQO2WRQg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1755775049; x=1756379849;
	d=konsulko.se; s=ed1;
	h=content-transfer-encoding:mime-version:message-id:date:subject:cc:to:from:
	 from;
	bh=90mdrgdRq9HDlMW2ikk8FQxgFJBsKRfFPXP+WnfuSBA=;
	b=U1Qaw8WqBDBhI0gpgYRoGAcb67fkq1VZgEKwHQugnRDY+SlSWG9U+MagGM7aHJjlflrJlBY5k9ArA
	 DlWe9s2BQ==
X-HalOne-ID: 6abf2def-7e80-11f0-beae-494313b7f784
Received: from slottsdator.home (host-95-203-16-218.mobileonline.telia.com [95.203.16.218])
	by mailrelay6.pub.mailoutpod2-cph3.one.com (Halon) with ESMTPSA
	id 6abf2def-7e80-11f0-beae-494313b7f784;
	Thu, 21 Aug 2025 11:17:28 +0000 (UTC)
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
Subject: [PATCH v2] rust: zpool: add abstraction for zpool drivers
Date: Thu, 21 Aug 2025 13:17:18 +0200
Message-Id: <20250821111718.512936-1-vitaly.wool@konsulko.se>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 8C16A140012
X-Stat-Signature: q9pw7jcjrzz68fjxoktgf3xoco7iii91
X-Rspam-User: 
X-HE-Tag: 1755775052-109557
X-HE-Meta: U2FsdGVkX18c8RJlfSUOrtmDBfscB33snu8yDW3upRPazlE1z+ovzUFO6GkG0P0aHXzqSm+n8h9sv3fV0C26d8wJUy7Cgyct514Ldh0aNu0e/GBRMKn8a5HKGmZxPMx20bbz2FChmGong91yd2/Y824BERlF+tXDzV6PCzIqYnUxvtsuPw1tk0WsCQCw8tFQI79tE4AltvdjPbTre7bn1lYQkbpjl9bGUWgV7I/7V/OJ5Rp7y3vgzGmfHUsmrNkX8Lyy8pY30ozgXVTPEBjpsqBNLu1ly1VFrciZduYl397alui229ykPr2bjzgr2M/fg7u5YPt1wFK2l3ktN0NYPZho+/T4yjRB4dtn2BT1uNf4amcTs7PdtXHqN3VgkobPq2tlb63YuJsoTczAL4Alk5dEC+vFREgiWpBZjOhThvsd9lO4aDMocgXQBen3EIQtOFLAXi16iJ4za1K9PQfMhBCJoKZDOMsRe+q1UJfGiMTNwD+X2UIerLkZcWGBrK3L5mi9UABKZPoTQqyIikyU4TRmjNkV7jF4Paz6pGuaq6ZPLJHu394hv+C04m+eP+g7nqD+6V0FqEDsUMFONh3twK4SYU/PBngHOgWbhthKgoWn7huDw643ESMplaNCgv5frr6tnR6bSxZXr6NBp3kTvdktR0l9bruPFgCLLNMYysihfLScYmTdTTf8ow3twRPLG/gom56OHr1v161HwG4VJw0+Cv032tVwgJoFhIA8kUOqqguHrcEYbcs95wyBFiUqR/EFeQKUh0kniUa3I4raIFPLoWWV3f/P74shVeFpRUD6sYR5jdw6NYw0sT/lSizczRSz20pmotjQU1F+oaFHzd0L2R7xbrqSiYrhpKrEfUDdVlxbQT0Z9t3z+qXdl91qFxuUtry7nyMr2YqdprzOILcE1k51E7pW5Vlilb0e3kCLcx0fJQg2Vw==
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
Signed-off-by: Vitaly Wool <vitaly.wool@konsulko.se>
---
 rust/bindings/bindings_helper.h |   1 +
 rust/helpers/helpers.c          |   1 +
 rust/helpers/zpool.c            |   6 +
 rust/kernel/alloc.rs            |   5 +
 rust/kernel/lib.rs              |   2 +
 rust/kernel/zpool.rs            | 262 ++++++++++++++++++++++++++++++++
 6 files changed, 277 insertions(+)
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
diff --git a/rust/kernel/alloc.rs b/rust/kernel/alloc.rs
index b39c279236f5..0fec5337908c 100644
--- a/rust/kernel/alloc.rs
+++ b/rust/kernel/alloc.rs
@@ -41,6 +41,11 @@
 pub struct Flags(u32);
 
 impl Flags {
+    /// Create from the raw representation
+    pub fn new(f: u32) -> Self {
+        Self(f)
+    }
+
     /// Get the raw representation of this flag.
     pub(crate) fn as_raw(self) -> u32 {
         self.0
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
index 000000000000..1d143ff7fed1
--- /dev/null
+++ b/rust/kernel/zpool.rs
@@ -0,0 +1,262 @@
+use crate::{
+    bindings,
+    error::Result,
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
+/// A zpool driver implementation which does nothing but prints pool name on its creation and
+/// destruction, and panics if zswap tries to actually read from a pool's alleged object.
+///
+/// ```
+/// use core::ptr::NonNull;
+/// use kernel::alloc::{Flags, KBox, NumaNode};
+/// use kernel::zpool::*;
+///
+/// struct MyZpool {
+///     name: &'static CStr,
+/// }
+///
+/// struct MyZpoolDriver;
+///
+/// impl ZpoolDriver for MyZpoolDriver {
+///     type Pool = KBox<MyZpool>;
+///
+///     fn create(name: &'static CStr, gfp: Flags) -> Result<KBox<MyZpool>> {
+///         let myPool = MyZpool { name };
+///         let mut pool = KBox::new(myPool, gfp)?;
+///
+///         pr_info!("Created pool {}\n", pool.name);
+///         Ok(pool)
+///     }
+///     fn destroy(p: KBox<MyZpool>) {
+///         let pool = KBox::into_inner(p);
+///         pr_info!("Removed pool {}\n", pool.name);
+///     }
+///     fn malloc(_pool: &mut MyZpool, _size: usize, _gfp: Flags, _nid: NumaNode) -> Result<usize> {
+///         Ok(0) // TODO
+///     }
+///     fn free(_pool: &MyZpool, _handle: usize) {
+///         // TODO
+///     }
+///     fn read_begin(_pool: &MyZpool, _handle: usize) -> NonNull<u8> {
+///         panic!("read_begin not implemented\n"); // TODO
+///     }
+///     fn read_end(_pool: &MyZpool, _handle: usize, _handle_mem: NonNull<u8>) {}
+///     fn write(_pool: &MyZpool, _handle: usize, _handle_mem: NonNull<u8>, _mem_len: usize) {}
+///     fn total_pages(_pool: &MyZpool) -> u64 { 0 }
+/// }
+/// ```
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
+    /// Allocate an object of size `size` using GFP flags `gfp` from the pool `pool`, wuth the
+    /// preferred NUMA node `nid`. If the allocation is successful, an opaque handle is returned.
+    fn malloc(
+        pool: <Self::Pool as ForeignOwnable>::BorrowedMut<'_>,
+        size: usize,
+        gfp: Flags,
+        nid: NumaNode,
+    ) -> Result<usize>;
+
+    /// Free a previously allocated from the `pool` object, represented by `handle`.
+    fn free(pool: <Self::Pool as ForeignOwnable>::Borrowed<'_>, handle: usize);
+
+    /// Make all the necessary preparations for the caller to be able to read from the object
+    /// represented by `handle` and return a valid pointer to the `handle` memory to be read.
+    fn read_begin(pool: <Self::Pool as ForeignOwnable>::Borrowed<'_>, handle: usize)
+        -> NonNull<u8>;
+
+    /// Finish reading from a previously allocated `handle`. `handle_mem` must be the pointer
+    /// previously returned by `read_begin`.
+    fn read_end(
+        pool: <Self::Pool as ForeignOwnable>::Borrowed<'_>,
+        handle: usize,
+        handle_mem: NonNull<u8>,
+    );
+
+    /// Write to the object represented by a previously allocated `handle`. `handle_mem` points
+    /// to the memory to copy data from, and `mem_len` defines the length of the data block to
+    /// be copied.
+    fn write(
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
+        let pool = unsafe { T::create(CStr::from_char_ptr(name), Flags::new(gfp)) };
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
+        let real_nid = match nid {
+            bindings::NUMA_NO_NODE => Ok(NumaNode::NO_NODE),
+            _ => NumaNode::new(nid),
+        };
+        if real_nid.is_err() {
+            return -(bindings::EINVAL as i32);
+        }
+
+        let result = T::malloc(pool, size, Flags::new(gfp), real_nid.unwrap());
+        match result {
+            Err(_) => -(bindings::ENOMEM as i32),
+            Ok(h) => {
+                // SAFETY: handle is guaranteed to be a valid pointer by zpool
+                unsafe { *handle = h };
+                0
+            }
+        }
+    }
+    extern "C" fn free_(pool: *mut c_void, handle: usize) {
+        // SAFETY: The pointer originates from an `into_foreign` call. If `pool` is passed to
+        // `from_foreign`, then that happens in `_destroy` which will not be called during this
+        // method.
+        let pool = unsafe { T::Pool::borrow(pool) };
+        T::free(pool, handle)
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
+        let non_null_ptr = T::read_begin(pool, handle);
+        non_null_ptr.as_ptr().cast()
+    }
+    extern "C" fn obj_read_end_(pool: *mut c_void, handle: usize, handle_mem: *mut c_void) {
+        // SAFETY: The pointer originates from an `into_foreign` call. If `pool` is passed to
+        // `from_foreign`, then that happens in `_destroy` which will not be called during this
+        // method.
+        let pool = unsafe { T::Pool::borrow(pool) };
+
+        // SAFETY: handle_mem is guaranteed to be non-null by zpool
+        let handle_mem_ptr = unsafe { NonNull::new_unchecked(handle_mem.cast()) };
+        T::read_end(pool, handle, handle_mem_ptr)
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
+        // SAFETY: handle_mem is guaranteed to be non-null by zpool
+        let handle_mem_ptr = unsafe { NonNull::new_unchecked(handle_mem.cast()) };
+        T::write(pool, handle, handle_mem_ptr, mem_len);
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
+            // SAFETY: `pdrv` is guaranteed to be a valid `RegType`.
+            unsafe { bindings::zpool_unregister_driver(pdrv.get()) };
+    }
+}
+
+/// Declares a kernel module that exposes a zpool driver (i. e. an implementation of the zpool API)
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
+
+
-- 
2.39.2


