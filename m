Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE161CA0EFF
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 13:39:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 07CE228001E; Fri, 22 Aug 2025 09:39:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 054168E009D; Fri, 22 Aug 2025 09:39:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E8A7628001E; Fri, 22 Aug 2025 09:39:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CDFE28E009D
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 09:39:52 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6CF8E56C72
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 13:39:52 +0000 (UTC)
X-FDA: 83804501424.30.C1B07EA
Received: from mailrelay-egress16.pub.mailoutpod3-cph3.one.com (mailrelay-egress16.pub.mailoutpod3-cph3.one.com [46.30.212.3])
	by imf27.hostedemail.com (Postfix) with ESMTP id EF67840017
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 13:39:48 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=konsulko.se header.s=rsa1 header.b=GecjSJE6;
	dkim=pass header.d=konsulko.se header.s=ed1 header.b=OUb4g+Kc
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755869989; a=rsa-sha256;
	cv=none;
	b=fDRNFeZWKzhmyz+x4AVLh+rEbVad8AYBJhCmIVzjb9p7ncSMT5ST2PtUt2T0jD7q3b8AVZ
	bQG5d9Bf+0ULSE19eYYBubxPkdtT3dC1BQ+lm4cZe/7CLYiQraMs9M//sotQdBS0D7WcTe
	Eypz7yf0ARHsdRbiqI0U7tWNvCnZY4c=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=konsulko.se header.s=rsa1 header.b=GecjSJE6;
	dkim=pass header.d=konsulko.se header.s=ed1 header.b=OUb4g+Kc;
	dmarc=none;
	spf=none (imf27.hostedemail.com: domain of vitaly.wool@konsulko.se has no SPF policy when checking 46.30.212.3) smtp.mailfrom=vitaly.wool@konsulko.se
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755869989;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=RF+nHIv2P+5gWVjUKLJEAmRaVE8S3qtIpyyvl43WTUk=;
	b=E88LNJ3uXuzHYM8FjoqZgOIQnz0QkcPXzQ+UoTYPDlfZM6xq7UIXaZ7wcvmISAnhGDeznx
	D4uwN7c1LMt0S8jqlKK0sVo1y6bIHCoADlGU1M6+/dVPszLO8m4eAGGVSeJr2INVFQ6EOj
	Di36eqsGvRZR3mvLER0pj5yZaXQeuT8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1755869986; x=1756474786;
	d=konsulko.se; s=rsa1;
	h=content-transfer-encoding:mime-version:message-id:date:subject:cc:to:from:
	 from;
	bh=RF+nHIv2P+5gWVjUKLJEAmRaVE8S3qtIpyyvl43WTUk=;
	b=GecjSJE6ihwd08HHVByNwFjFCufAyUE5yITB4DgrB4j/yhC0RcJWAYJBkNc4zOvIveBH9LGwFY53o
	 ssApNTW9uRADuviceu2n2JP72GwcNJgWXACMRKweLditlKrMXzKMzRdw1hxYnHO6iq+RmM5PN9oIL/
	 jydXwUwixyr/3hWS2HFIsEAVflOuKIq+Ks92Pij5SXB9nUYCTwQZTrnp53VVxtzU50ztzUbfspdpeb
	 JB2SjvVTWX0ir8JP3r2FrmQl8R138RHxr3L9GEASOJypabYGPH8edlFkfA2T8Wo4+TtWuxxcd9QNQ6
	 /iwWRzxzQ3yUoIH4P0+XQRRCeGb7ycw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1755869986; x=1756474786;
	d=konsulko.se; s=ed1;
	h=content-transfer-encoding:mime-version:message-id:date:subject:cc:to:from:
	 from;
	bh=RF+nHIv2P+5gWVjUKLJEAmRaVE8S3qtIpyyvl43WTUk=;
	b=OUb4g+Kc3kD7jgCHwdRs5Ymngu1vOyLbBtt89xnQSm6ym1uPFb1C48yaBpV9e5UYqDZKLU//IAACE
	 SjKp4LYDw==
X-HalOne-ID: 759e0b94-7f5d-11f0-bde3-494313b7f784
Received: from slottsdator.home (host-95-203-16-218.mobileonline.telia.com [95.203.16.218])
	by mailrelay6.pub.mailoutpod2-cph3.one.com (Halon) with ESMTPSA
	id 759e0b94-7f5d-11f0-bde3-494313b7f784;
	Fri, 22 Aug 2025 13:39:45 +0000 (UTC)
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
Subject: [PATCH v3] rust: zpool: add abstraction for zpool drivers
Date: Fri, 22 Aug 2025 15:39:35 +0200
Message-Id: <20250822133935.674282-1-vitaly.wool@konsulko.se>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: EF67840017
X-Stat-Signature: 6hz1stres573kkbp76s6r7mo6n8uebzd
X-HE-Tag: 1755869988-453328
X-HE-Meta: U2FsdGVkX19etsrVQZexFyX4fMUV4/1qBNx4jdZt/Dc1uuJz6rkpCavLlzXcXS4Z2PAw7SPDVM9WnQzyencXElyoBTO0OTfddpcDzPIJpNb7eGvMsqupXlqutJf7JmfCYbLvVuNFy+zw4klQHexmt45F6FoBLV2rmf1PnDr1K2bQO05x61tQlqGl3BzPhmSfiyEbpNP+hFiQjx+pWQLIfXlmMxzUnYZClgnHbJlyLGgOpM7shaqWu7v7oLTSQz8/kQtwd0DEQ4mmXgP65lsOBe7yGo9QI4RKk3d3PovTw44b6FaJwa9KULOsQP7k0SVCjKsbFnLwOB9op8ltTqF0K8tlThtasjXX4ExiuyBGDzuJDq3MdmSev5+PJwPJwkMjpGzpAA/63JPXWEA96CKgGttuNBRCiUrowJtXuMw3zCLQaGSmw/CkW/q/PSTKWPTPMlB2TB247SZFvUhyvGNVCGIKgT2+2G2wdO5+cmAYk86gOWYpcVFMj7N1TbdEZp7Tro4ul+f/83x31Y7QgFvwFo019/TKEc6bkDXIR4WFruO8PCEgec5EIDh1/nXVUy2H7eba2qHWQ3FsbJdpK8mQnUHuIjpDz5doKzoiYt1jgH1vzyEcRXCaieoEBUuZSX1i8Wo8UtbF/Uv1MkQqKR4gJIl5ObXzTbEhD9djqUrDY1th7olkHa5kU+dJLQZUhjgO2GWkCaKzX2E9dzOy389eHj3DmznowbP4jP75BI4qwAeFr1BZUzS8JacwsarGt9rbaGcHCyDk5MyVPn2uJ6vyG458PJXaQQQ2zWNFn1Kpz7Ethi3m4OMWW27XruOkE5tHr3JuVWsNFB3ezTAqEju2dNqTpcg7VosGRdwmVz4nfauqQ7sRKMK6jsrrIoEV+ZRfpeWMe3ztNF+fMhQ3dRIqvIOkIIh+ODjv8rEMzppvtn0R5qgBNKqz2i6gWuUe1euDVULIOHBni1bUdn76PHF
 6uq5UEtq
 UkBXpaJLSSXbLdDaqh68G1iWcLatxOs7IbkWBMl9uYABbnLwwmNj282AyWpoYNaFMM4RUoTJINyAfUrl7pX5/lSZR/HelUK74Pq7wcD4nBpgs9SdfSDZHEtYEn0Dc1j6en5WBGAUPKOUhvl5iPxcRrjYO5Jlg1CQurAkrtXoysxGw/5agPkuUKhb+5MUvUnYBihR6
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
Changelog:
v1 -> v2:
* reworked to stick to the existing Rust driver infrastructure
* removed raw pointers from the Rust API
v2 -> v3:
* detailed safety requirements for unsafe API functions
* removed unwrap()
* some typo corrections
---
 MAINTAINERS                     |   1 +
 rust/bindings/bindings_helper.h |   1 +
 rust/helpers/helpers.c          |   1 +
 rust/helpers/zpool.c            |   8 +
 rust/kernel/alloc.rs            |   5 +
 rust/kernel/lib.rs              |   2 +
 rust/kernel/zpool.rs            | 291 ++++++++++++++++++++++++++++++++
 7 files changed, 309 insertions(+)
 create mode 100644 rust/helpers/zpool.c
 create mode 100644 rust/kernel/zpool.rs

diff --git a/MAINTAINERS b/MAINTAINERS
index b6f7c6939ff8..aa6815763246 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -27870,6 +27870,7 @@ F:	include/linux/zpool.h
 F:	include/linux/zswap.h
 F:	mm/zpool.c
 F:	mm/zswap.c
+F:	rust/kernel/zpool.rs
 F:	tools/testing/selftests/cgroup/test_zswap.c
 
 SENARYTECH AUDIO CODEC DRIVER
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
index 000000000000..762977aca46b
--- /dev/null
+++ b/rust/helpers/zpool.c
@@ -0,0 +1,8 @@
+// SPDX-License-Identifier: GPL-2.0'
+
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
index 000000000000..8b7249956b61
--- /dev/null
+++ b/rust/kernel/zpool.rs
@@ -0,0 +1,291 @@
+// SPDX-License-Identifier: GPL-2.0
+
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
+///     unsafe fn free(_pool: &MyZpool, _handle: usize) {
+///         // TODO
+///     }
+///     unsafe fn read_begin(_pool: &MyZpool, _handle: usize) -> NonNull<u8> {
+///         panic!("read_begin not implemented\n"); // TODO
+///     }
+///     unsafe fn read_end(_pool: &MyZpool, _handle: usize, _handle_mem: NonNull<u8>) {}
+///     unsafe fn write(_p: &MyZpool, _h: usize, _handle_mem: NonNull<u8>, _mem_len: usize) {}
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
+    /// Allocate an object of size `size` using GFP flags `gfp` from the pool `pool`, with the
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
+    /// - `handle` should be a valid handle previously returned by `malloc`
+    unsafe fn free(pool: <Self::Pool as ForeignOwnable>::Borrowed<'_>, handle: usize);
+
+    /// Make all the necessary preparations for the caller to be able to read from the object
+    /// represented by `handle` and return a valid pointer to the `handle` memory to be read.
+    ///
+    /// # Safety
+    ///
+    /// - `handle` should be a valid handle previously returned by `malloc`
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
+    /// - `handle` should be a valid handle previously returned by `malloc`
+    /// - `handle_mem` should be the pointer previously returned by `read_begin`
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
+    /// - `handle` should be a valid handle previously returned by `malloc`
+    /// - `handle_mem` should be a valid pointer to an allocated memory area
+    /// - `handle_mem` + `mem_len` should not point outside the allocated memory area
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
+
+        from_result(|| {
+            let real_nid = match nid {
+                bindings::NUMA_NO_NODE => NumaNode::NO_NODE,
+                _ => NumaNode::new(nid)?,
+            };
+            let h = T::malloc(pool, size, Flags::new(gfp), real_nid)?;
+            // SAFETY: handle is guaranteed to be a valid pointer by zpool
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
-- 
2.39.2


