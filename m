Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1084DCA0EF8
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 09:18:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A3D6C6B00DC; Wed, 20 Aug 2025 05:18:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9EDF56B00DE; Wed, 20 Aug 2025 05:18:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8DD958E0002; Wed, 20 Aug 2025 05:18:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 761C86B00DC
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 05:18:24 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3ECF613872A
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 09:18:24 +0000 (UTC)
X-FDA: 83796584928.13.7257AF7
Received: from mailrelay-egress16.pub.mailoutpod3-cph3.one.com (mailrelay-egress16.pub.mailoutpod3-cph3.one.com [46.30.212.3])
	by imf15.hostedemail.com (Postfix) with ESMTP id CA938A000D
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 09:18:21 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=konsulko.se header.s=rsa1 header.b=v1T+Fmk+;
	dkim=pass header.d=konsulko.se header.s=ed1 header.b="B0SWB/hI"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755681502;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=FRyhRFkMbqSc15zT+4bIDmxfwF/9e4IBdudaDc/b6pk=;
	b=ZfNseNTzI4VNfmmvK1DjTQ9sAvkT4LdJUIfjzrqtafi+3V5k28RokTNJQl3HUgQVI8zl6/
	UvmIHKv8BtAF4vujJfPp10XEmJC2XoEjKsyBZ3sXo3ED4i+o95Yf28bNe2dv76pgDstGU+
	TrtvGwZnZLweMOYOsp5yUUR7nbfL/rY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755681502; a=rsa-sha256;
	cv=none;
	b=68jjkGtzlWN5cqIvtJbfOp+Mr2h9sce20M3muhnC+7AXzNHMa7cLok4hNxUOkEt7MO958+
	EknBgddzBtoFSOsn0nf0lzZ9ahq9hSPF/ksHozW8G3bbiDGE6lyDnOGpF4P4OjcZnfbfjx
	pX611oD+jeOjtRsuipLXfbtux7vPZbo=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=konsulko.se header.s=rsa1 header.b=v1T+Fmk+;
	dkim=pass header.d=konsulko.se header.s=ed1 header.b="B0SWB/hI";
	spf=none (imf15.hostedemail.com: domain of vitaly.wool@konsulko.se has no SPF policy when checking 46.30.212.3) smtp.mailfrom=vitaly.wool@konsulko.se;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1755681499; x=1756286299;
	d=konsulko.se; s=rsa1;
	h=content-transfer-encoding:mime-version:message-id:date:subject:cc:to:from:
	 from;
	bh=FRyhRFkMbqSc15zT+4bIDmxfwF/9e4IBdudaDc/b6pk=;
	b=v1T+Fmk+rYHVKkagsqWXrJhbI+15dYTV2cYUAtuFtG+DxQjxcF+Elx3g6owxjkHee6POKqZTz3nCF
	 PHBd8I8iMud/cNhpcqYTwFiukA9v6EZX4ZqJijvKJTfO88mdC9YgdTkjOAPO0hhx0afuysyBPsnpWD
	 P/IwdapxIXPvjTB0z54i6aiWonPNHtxTQQn+yCt8tzwm/vJ4Zed+GsWNPxLG4VUYmqa4jxoIOOnqfB
	 iKJSMmH4jtdKjED7G1Ts6DMw2QPrxEmzdopQoy01F3y7hpX7vRsfUN5XLVk0kovMfdUq8baVJ1uGvL
	 Pkbh1tg90JpFwGSklzHjGYCqRKavOyg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1755681499; x=1756286299;
	d=konsulko.se; s=ed1;
	h=content-transfer-encoding:mime-version:message-id:date:subject:cc:to:from:
	 from;
	bh=FRyhRFkMbqSc15zT+4bIDmxfwF/9e4IBdudaDc/b6pk=;
	b=B0SWB/hIXek0qGZv2HrpW7HW5kE0HhZPpB0MaKZtCUkdnrdM5TFfLjGA1Fbl6b2hQ/E5msI8JZFBT
	 eywUvoBAQ==
X-HalOne-ID: 9b35c4ba-7da6-11f0-9cad-f3c0f7fef5ee
Received: from localhost.localdomain (host-95-203-16-218.mobileonline.telia.com [95.203.16.218])
	by mailrelay4.pub.mailoutpod2-cph3.one.com (Halon) with ESMTPSA
	id 9b35c4ba-7da6-11f0-9cad-f3c0f7fef5ee;
	Wed, 20 Aug 2025 09:18:18 +0000 (UTC)
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
Subject: [PATCH] rust: zpool: add abstraction for zpool drivers
Date: Wed, 20 Aug 2025 11:15:43 +0200
Message-Id: <20250820091543.4165305-1-vitaly.wool@konsulko.se>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: CA938A000D
X-Stat-Signature: 7jr15u8wkmb9bok88px6omdre493so7n
X-Rspam-User: 
X-HE-Tag: 1755681501-563688
X-HE-Meta: U2FsdGVkX19dDhXl9zh/nwoPnx7+LRrfORcafOG1Z5Mb9PEm6iJXUTEjvAgy1tjqZDSkTDIsFpExDVs5OmcKu1lOZPy2Qagdo/m8w5528MVtSLT6g+LnyomhzDOYPsU/ugEgyclD7/8R9cs7zaLm+nXNA0JX9DZM8c+V1MvlzVei3fA5LNNaVZ2TeY33PcgnJ8w6OjQY+dRjb5hKFUoW/5M5XUNwP9F2GhwtfHuCMa/XKXMgC2TuCPpMQEJGGWkCpMir31WiMur43thsdBdqZJh+1Hy1HPENlYT/Gc/slkTtYvgvdDq3rMi6jkh3f4s8V3tUpj7NcV96fh+tY+yIvmYaQGDYqF9M52cM/KReD6uyLlMUAuGqcl5ysoj9Wbe4T8rdxkB+FGgUhiUn41DQ15oHGreoq7LtL+Km45AACveuyuzrwBR0yJyIRa1ZGvDX5OlhMjqu1BEn/Z5neO5410lHravLAORvcFTtbu0fYLSAkAl2A7okan6nv8JgIHqTC/IS//sNw8C/eHcH2KtJzO1H8rR4WDAZnsCptCrazPZER6IPN68XMUwBn72QKO3+7pwHFjM5cnCy5/fer0wgeN4vUEWPx7Q94+twJy67UqMU12UdTAF7czsM3aGpyEEKAT7ZGjj6VzczV9qlIMQAMHiT3uCaVQ/JJnw2GtZc5DdH6eocdIQN2Q9e+lyDRRxR10L3TwzRggpaybzxo3+3twHs1FjJr5wyC4o8w4chdgHMLDK8rKwXdhm3rmEbpE+kCvAIWVNf7COw0ENJEeJrwJbmDUTgpon242Y5nfQ+v46Ee65ieQQkpK25jQ9AX1qDEGCiF0hhidZPI8QqK8FAFXNMTkX4OPkHa3U9jvCvotssL2huHhsHGNC83c2vjeT0jeC8xTVm6qZieiFb6/rgyOQEUzXS0Le6L5B5C6ZFTue6YkEs0ovvOEs2Sdv1wAVdb3aXTUd5svIlTxKMR4I
 xcxsVVMp
 z/MVev3I1ZSOyG7YsI31fHDY6ZkEv3Zn0236iLx+D2fLjQIxj4Q0fA+Q55XB/xwZ8Ym8QDIo99RIOXyBIz5rDqfTTHh5ueNwd+fgcaxHHNfB8GRIPQNaua0LkyG8pwrwjNW5wty7vZroajS0AQ2c5UfzEkDrWCCha8HykRwzl6JczXimDTJZJl0QvTs4h5OXiHGL8
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

Signed-off-by: Vitaly Wool <vitaly.wool@konsulko.se>
Signed-off-by: Alice Ryhl <aliceryhl@google.com>
---
 rust/bindings/bindings_helper.h |   1 +
 rust/helpers/helpers.c          |   1 +
 rust/helpers/zpool.c            |   6 +
 rust/kernel/alloc.rs            |   5 +
 rust/kernel/lib.rs              |   2 +
 rust/kernel/zpool.rs            | 269 ++++++++++++++++++++++++++++++++
 6 files changed, 284 insertions(+)
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
index 000000000000..91926c2e99e8
--- /dev/null
+++ b/rust/kernel/zpool.rs
@@ -0,0 +1,269 @@
+use crate::{
+    bindings,
+    error::Result,
+    kernel::alloc::Flags,
+    str::CStr,
+    types::{ForeignOwnable, Opaque},
+};
+use core::ffi::{c_int, c_uchar, c_void};
+use core::ptr::null_mut;
+use kernel::alloc::NumaNode;
+use kernel::ThisModule;
+
+/// zpool API
+pub trait Zpool {
+    /// Opaque Rust representation of `struct zpool`.
+    type Pool: ForeignOwnable;
+
+    /// Create a pool.
+    fn create(name: *const c_uchar, gfp: Flags) -> Result<Self::Pool>;
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
+        -> *mut c_void;
+
+    /// Finish reading from a previously allocated `handle`. `handle_mem` must be the pointer
+    /// previously returned by `read_begin`.
+    fn read_end(
+        pool: <Self::Pool as ForeignOwnable>::Borrowed<'_>,
+        handle: usize,
+        handle_mem: *mut c_void,
+    );
+
+    /// Write to the object represented by a previously allocated `handle`. `handle_mem` points
+    /// to the memory to copy data from, and `mem_len` defines the length of the data block to
+    /// be copied.
+    fn write(
+        pool: <Self::Pool as ForeignOwnable>::Borrowed<'_>,
+        handle: usize,
+        handle_mem: *mut c_void,
+        mem_len: usize,
+    );
+
+    /// Get the number of pages used by the `pool`.
+    fn total_pages(pool: <Self::Pool as ForeignOwnable>::Borrowed<'_>) -> u64;
+}
+
+/// Zpool driver registration trait.
+pub trait Registration {
+    /// Register a zpool driver.
+    fn register(&self, name: &'static CStr, module: &'static ThisModule) -> Result;
+
+    /// Pool creation callback.
+    extern "C" fn _create(name: *const c_uchar, gfp: u32) -> *mut c_void;
+
+    /// Pool destruction callback.
+    ///
+    /// # Safety
+    ///
+    /// The caller must ensure that `pool` is a valid pointer to `struct zpool`.
+    unsafe extern "C" fn _destroy(pool: *mut c_void);
+
+    /// Callback for object allocation in the pool.
+    ///
+    /// # Safety
+    ///
+    /// The caller must ensure that `pool` is a valid pointer to `struct zpool` and that `handle`
+    /// is a valid pointer to usize.
+    unsafe extern "C" fn _malloc(
+        pool: *mut c_void,
+        size: usize,
+        gfp: u32,
+        handle: *mut usize,
+        nid: c_int,
+    ) -> c_int;
+
+    /// Callback for object release.
+    ///
+    /// # Safety
+    ///
+    /// The caller must ensure that `pool` is a valid pointer to `struct zpool`.
+    unsafe extern "C" fn _free(pool: *mut c_void, handle: usize);
+
+    /// Callback to prepare the object for reading.
+    ///
+    /// # Safety
+    ///
+    /// The caller must ensure that `pool` is a valid pointer to `struct zpool`.
+    unsafe extern "C" fn _obj_read_begin(
+        pool: *mut c_void,
+        handle: usize,
+        local_copy: *mut c_void,
+    ) -> *mut c_void;
+
+    /// Callback to signal the end of reading from an object.
+    ///
+    /// # Safety
+    ///
+    /// The caller must ensure that `pool` is a valid pointer to `struct zpool`.
+    unsafe extern "C" fn _obj_read_end(pool: *mut c_void, handle: usize, handle_mem: *mut c_void);
+
+    /// Callback for writing to an object.
+    ///
+    /// # Safety
+    ///
+    /// The caller must ensure that `pool` is a valid pointer to `struct zpool`.
+    unsafe extern "C" fn _obj_write(
+        pool: *mut c_void,
+        handle: usize,
+        handle_mem: *mut c_void,
+        mem_len: usize,
+    );
+
+    /// Callback to return the number of pages in the pool.
+    ///
+    /// # Safety
+    ///
+    /// The caller must ensure that `pool` is a valid pointer to `struct zpool`.
+    unsafe extern "C" fn _total_pages(pool: *mut c_void) -> u64;
+}
+
+/// Zpool driver structure.
+pub struct ZpoolDriver<T: Zpool> {
+    inner: Opaque<bindings::zpool_driver>,
+
+    /// Zpool callback functions that a zpool driver must provide
+    pub callbacks: T,
+}
+
+impl<T: Zpool> Clone for ZpoolDriver<T> {
+    fn clone(&self) -> Self {
+        todo!()
+    }
+}
+
+// SAFETY: zpool driver must ensure that ZpoolDriver's `callbacks` are thread safe
+unsafe impl<T: Zpool> Sync for ZpoolDriver<T> {}
+
+impl<T: Zpool> ZpoolDriver<T> {
+    /// create an instance of a zpool driver
+    pub const fn new(t: T) -> Self {
+        Self {
+            inner: Opaque::uninit(),
+            callbacks: t,
+        }
+    }
+}
+
+impl<T: Zpool> Registration for ZpoolDriver<T> {
+    extern "C" fn _create(name: *const c_uchar, gfp: u32) -> *mut c_void {
+        let pool = T::create(name, Flags::new(gfp));
+        match pool {
+            Err(_) => null_mut(),
+            Ok(p) => T::Pool::into_foreign(p),
+        }
+    }
+    unsafe extern "C" fn _destroy(pool: *mut c_void) {
+        // SAFETY: The pointer originates from an `into_foreign` call.
+        T::destroy(unsafe { T::Pool::from_foreign(pool) })
+    }
+    unsafe extern "C" fn _malloc(
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
+    unsafe extern "C" fn _free(pool: *mut c_void, handle: usize) {
+        // SAFETY: The pointer originates from an `into_foreign` call. If `pool` is passed to
+        // `from_foreign`, then that happens in `_destroy` which will not be called during this
+        // method.
+        let pool = unsafe { T::Pool::borrow(pool) };
+        T::free(pool, handle)
+    }
+    unsafe extern "C" fn _obj_read_begin(
+        pool: *mut c_void,
+        handle: usize,
+        _local_copy: *mut c_void,
+    ) -> *mut c_void {
+        // SAFETY: The pointer originates from an `into_foreign` call. If `pool` is passed to
+        // `from_foreign`, then that happens in `_destroy` which will not be called during this
+        // method.
+        let pool = unsafe { T::Pool::borrow(pool) };
+        T::read_begin(pool, handle)
+    }
+    unsafe extern "C" fn _obj_read_end(pool: *mut c_void, handle: usize, handle_mem: *mut c_void) {
+        // SAFETY: The pointer originates from an `into_foreign` call. If `pool` is passed to
+        // `from_foreign`, then that happens in `_destroy` which will not be called during this
+        // method.
+        let pool = unsafe { T::Pool::borrow(pool) };
+        T::read_end(pool, handle, handle_mem)
+    }
+    unsafe extern "C" fn _obj_write(
+        pool: *mut c_void,
+        handle: usize,
+        handle_mem: *mut c_void,
+        mem_len: usize,
+    ) {
+        // SAFETY: The pointer originates from an `into_foreign` call. If `pool` is passed to
+        // `from_foreign`, then that happens in `_destroy` which will not be called during this
+        // method.
+        let pool = unsafe { T::Pool::borrow(pool) };
+        T::write(pool, handle, handle_mem, mem_len);
+    }
+    unsafe extern "C" fn _total_pages(pool: *mut c_void) -> u64 {
+        // SAFETY: The pointer originates from an `into_foreign` call. If `pool` is passed to
+        // `from_foreign`, then that happens in `_destroy` which will not be called during this
+        // method.
+        let pool = unsafe { T::Pool::borrow(pool) };
+        T::total_pages(pool)
+    }
+
+    fn register(&self, name: &'static CStr, module: &'static ThisModule) -> Result {
+        // SAFETY: `ZpoolDriver::new()` ensures that `self.inner` is a valid pointer
+        unsafe {
+            (*(self.inner.get())).create = Some(Self::_create);
+            (*(self.inner.get())).destroy = Some(Self::_destroy);
+            (*(self.inner.get())).malloc = Some(Self::_malloc);
+            (*(self.inner.get())).free = Some(Self::_free);
+            (*(self.inner.get())).obj_read_begin = Some(Self::_obj_read_begin);
+            (*(self.inner.get())).obj_read_end = Some(Self::_obj_read_end);
+            (*(self.inner.get())).obj_write = Some(Self::_obj_write);
+            (*(self.inner.get())).total_pages = Some(Self::_total_pages);
+
+            (*(self.inner.get())).owner = module.0;
+            (*(self.inner.get())).type_ = name.as_char_ptr().cast_mut();
+
+            bindings::zpool_register_driver(self.inner.get());
+        }
+        Ok(())
+    }
+}
-- 
2.39.2


