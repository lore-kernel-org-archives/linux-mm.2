Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C096CAC5A7
	for <linux-mm@archiver.kernel.org>; Tue, 23 Sep 2025 10:27:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A85AE8E000C; Tue, 23 Sep 2025 06:27:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A36678E0001; Tue, 23 Sep 2025 06:27:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8FE1B8E000C; Tue, 23 Sep 2025 06:27:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 72EA38E0001
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 06:27:11 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 13013140455
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 10:27:11 +0000 (UTC)
X-FDA: 83920137462.13.0526F69
Received: from mailrelay-egress16.pub.mailoutpod3-cph3.one.com (mailrelay-egress16.pub.mailoutpod3-cph3.one.com [46.30.212.3])
	by imf13.hostedemail.com (Postfix) with ESMTP id 396D920005
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 10:27:08 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=konsulko.se header.s=rsa2 header.b=ItnT10Q6;
	dkim=pass header.d=konsulko.se header.s=ed2 header.b="6pe/z5df"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758623229;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=izjnLKwy2M9GkRnAIDo3i+C5TcRdEk5i3/LXadNlJtY=;
	b=RbHIsPnkqyZO2BiRes5JF+ocwlvTib7Cf3QESchfGvq/FIoF6q2iH4X/ePYT2/YAPEUn8P
	arwH7tFZ5tFCkxzE/NZ+t6Q+DY517NRNjVkDB6pNLW3nt7a0U0Qosf1w6EiHpQOq8lVvxt
	szNUPn/eGnWoi2yevoABWQCvfBRhVTI=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=konsulko.se header.s=rsa2 header.b=ItnT10Q6;
	dkim=pass header.d=konsulko.se header.s=ed2 header.b="6pe/z5df";
	spf=none (imf13.hostedemail.com: domain of vitaly.wool@konsulko.se has no SPF policy when checking 46.30.212.3) smtp.mailfrom=vitaly.wool@konsulko.se;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758623229; a=rsa-sha256;
	cv=none;
	b=DVtVU1+J3klGU86csVNcVQUaYW6UiBU8FYPCGgu+yzoNFr528GDcB39W817qkshpbKp9fK
	NjmY1TElQbhawgmKxLR9B60vE+nz87uZfR3FXZYS0tYSX5kFDVq8CNA+UvZhstk8d0YvL2
	vflrBspKNS2NT86AK++Y6aM17RkVj/k=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1758623226; x=1759228026;
	d=konsulko.se; s=rsa2;
	h=content-transfer-encoding:mime-version:references:in-reply-to:message-id:date:
	 subject:cc:to:from:from;
	bh=izjnLKwy2M9GkRnAIDo3i+C5TcRdEk5i3/LXadNlJtY=;
	b=ItnT10Q6/N5bmHq8SZrYONJU6XP++Qo9UlCzoVArLKaaJpaJgkDZuStGCMdWIGr22PFbRBIxg4ASw
	 4Gxz2+YkkPzVbPyPdWPAoeB5LtPuXA8D28VJaRd2l9TAclX2cBhuJVAxc5nnE1mQY85EqhoETickTd
	 C5M/ld5B8C+o+I/kJrASsP5kYMVZbjw6M3H6JRu7JDjuBEu4tbe1/AI87nza0hxhw1Vi7UP6bTexRR
	 F7nIZSdLUr09sFNP8x+AhIDb58ycLlemFw298+RYfDalnv/H7UI+FtPpRFZjefrIC2NqJtFOPgRshS
	 YiHgEtC3trzJSI3QwiNsnsm4dZKbk4w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1758623226; x=1759228026;
	d=konsulko.se; s=ed2;
	h=content-transfer-encoding:mime-version:references:in-reply-to:message-id:date:
	 subject:cc:to:from:from;
	bh=izjnLKwy2M9GkRnAIDo3i+C5TcRdEk5i3/LXadNlJtY=;
	b=6pe/z5dfKOCUdhchiM5ptfia8hHNHa3lKTKeDOCfhBdnY5fJQd+s3fUvhISs7mb6dFemnYhhwR3uR
	 nA9BRmhBg==
X-HalOne-ID: d88d183f-9867-11f0-99e2-d510462faafc
Received: from localhost.localdomain (host-95-203-13-255.mobileonline.telia.com [95.203.13.255])
	by mailrelay4.pub.mailoutpod3-cph3.one.com (Halon) with ESMTPSA
	id d88d183f-9867-11f0-99e2-d510462faafc;
	Tue, 23 Sep 2025 10:27:05 +0000 (UTC)
From: Vitaly Wool <vitaly.wool@konsulko.se>
To: linux-mm@kvack.org,
	rust-for-linux@vger.kernel.org
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Nhat Pham <nphamcs@gmail.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Minchan Kim <minchan@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-kernel@vger.kernel.org,
	Vitaly Wool <vitaly.wool@konsulko.se>
Subject: [PATCH v6 2/2] rust: zpool: add abstraction for zpool drivers
Date: Tue, 23 Sep 2025 12:27:02 +0200
Message-Id: <20250923102702.2552392-1-vitaly.wool@konsulko.se>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250923102547.2545992-1-vitaly.wool@konsulko.se>
References: <20250923102547.2545992-1-vitaly.wool@konsulko.se>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 396D920005
X-Stat-Signature: 58j4z8es79kx97za6y878kgdjzkrcmt8
X-HE-Tag: 1758623228-970672
X-HE-Meta: U2FsdGVkX1+gmzHO2u4NNefgeSnoEPZCSAi/v+kydWIHd3gHstYAyZ4mwZ3oh49WqHNcjQetdvZG/HyecTCfgUCKqeTw8z90U1sSEumgaR6BREmfXdJfBsB9yiq+ezCPaT9JeW08NnS6xa3ydt0riuM9cUX6VVRrEtLRxclKSThwpHV8HSJqdebUo6WbSDTJpRMysJgO4wi1SqzTpMT3K+gxGMc/OKdZw2K8xUltqCW2U0xMr/undHHjlTZI2KejwMkvAI1Pdt1/tVTqNEFPyjaoDDLsByJsfuxMcsDLc33bHGnzNnKGh2wZTeZaYhkYUOoDV7iOPzpFON9+yMMcrbV9uOgdIBI2jo6oliXs4QS1LM0UwyYcODqFgxEpVMAbXKtzYitM8hnwGbEOP0e+xobgKiQpj639pRaECUxDcYDs8aRQBAW//5HwO9pev81icDZYaVWb2jI18Ra9SXRbXXcUi2cD97UIhS2Uuvws/3ky7SK38FvtYHaKwp2v7HNkt5nFFWPVmDZzTzfNqnUTg/5RXnB1oh6OYY50os39gAFlHoDre3O7A9+yBrJIq0d4ZEL527WesUUrjZN+tZPUQmy6adc3IRGeTvplTXTcjlHorzd5Bi08gWudKGMZE+CBcMnf/W05U02zDwQDtfyod9EkUUQFrE6eGfLAobuZpaRl6gFSFWLZlk2tLIC6wtgzXPQDrxdE2AhwN0BraRfPIg3X97ujp9PFxzgJZnd24KXueNUg4onKw3RIYHSJ4RyCkTYtmp1n2hmF2GOfnW5YVHxgpdApokT3WvyekUq2jI/CQaraTbjhVmm5aZszAeZIhBW9XvXLTHzuPjSE47pgvRu6FVHrNCYyjho/RNwtfeA2wAH4yFFJGBtuqFa8EXCt34Ow3A1ovy83Ezai5wNPjWhmnGarY95HRDZOpvzHRSZYdRB3/VkY8kpd8K9Y8thFU+E66B1mkfLXAXRSULK
 VbW35VZJ
 b1NMK0moAlQBxdeYyC/75yHNAlu+sY0lUsPYbspEnLfDLQG2McTQcLzHqhsQWj9LdZEYGP0Inn3aL1plBFlJkr/a/66+Y4mmr+d/WkGKhSg6GJT59/zsDVV6zewjV6Id9fcymvDYCWaE21iayE0SGpIXrvMGaRnrCm/GJJEw1OrbvVb+dqs77DJtiI/7uQLJBQdZYh+lXTrln3FinrY3qY4vESisqvccLB83syYcKTmLNrFo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

zpool is a common thin API for memory storage pool implementations.
A backend implementing this API will be used to store compressed
memory objects, e. g. for zswap, the lightweight compressed cache for
swap pages.

This patch provides the interface to use zpool in Rust kernel code,
thus enabling Rust implementations of zpool allocators for zswap. Now
that zpool API doesn't provide runtime registration option and presumes
compile time selection of an allocation backend, an allocator is
expected to call DECLARE_ZPOOL! macro to register itself during compile
time. Please also see the example in zpool.rs for more details.

Co-developed-by: Alice Ryhl <aliceryhl@google.com>
Signed-off-by: Alice Ryhl <aliceryhl@google.com>
Signed-off-by: Vitaly Wool <vitaly.wool@konsulko.se>
---
 rust/bindings/bindings_helper.h |   1 +
 rust/kernel/lib.rs              |   2 +
 rust/kernel/zpool.rs            | 366 ++++++++++++++++++++++++++++++++
 3 files changed, 369 insertions(+)
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
diff --git a/rust/kernel/lib.rs b/rust/kernel/lib.rs
index 6b0a5689669f..4d5b0cc881d8 100644
--- a/rust/kernel/lib.rs
+++ b/rust/kernel/lib.rs
@@ -130,6 +130,8 @@
 pub mod uaccess;
 pub mod workqueue;
 pub mod xarray;
+#[cfg(CONFIG_ZPOOL_ALLOCATOR)]
+pub mod zpool;
 
 #[doc(hidden)]
 pub use bindings;
diff --git a/rust/kernel/zpool.rs b/rust/kernel/zpool.rs
new file mode 100644
index 000000000000..53a0dc0607e6
--- /dev/null
+++ b/rust/kernel/zpool.rs
@@ -0,0 +1,366 @@
+// SPDX-License-Identifier: GPL-2.0
+
+//! Implementation of Rust interface towards zpool API.
+
+use crate::{error::Result, kernel::alloc::Flags, str::CString, types::ForeignOwnable};
+use core::ptr::NonNull;
+use kernel::alloc::NumaNode;
+
+/// The Rust representation of zpool handle.
+pub struct ZpoolHandle(usize);
+
+impl ZpoolHandle {
+    /// Create `ZpoolHandle` from the raw representation.
+    pub fn from_raw(h: usize) -> Self {
+        Self(h)
+    }
+
+    /// Get the raw representation of the handle.
+    pub fn as_raw(self) -> usize {
+        self.0
+    }
+}
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
+/// use kernel::alloc::{Flags, flags, KBox, KVec, NumaNode};
+/// use kernel::page::PAGE_SHIFT;
+/// use kernel::prelude::EINVAL;
+/// use kernel::str::CString;
+/// use kernel::zpool::*;
+///
+/// struct MyZpool {
+///     name: CString,
+///     bytes_used: AtomicU64,
+/// }
+///
+/// struct MyZpoolDriver;
+///
+/// impl ZpoolDriver for MyZpoolDriver {
+///     type Pool = KBox<MyZpool>;
+///
+///     fn create(name: CString, gfp: Flags) -> Result<KBox<MyZpool>> {
+///         let my_pool = MyZpool { name, bytes_used: AtomicU64::new(0) };
+///         let pool = KBox::new(my_pool, gfp)?;
+///
+///         pr_debug!("Pool {:?} created\n", pool.name);
+///         Ok(pool)
+///     }
+///
+///     fn malloc(pool: &MyZpool, size: usize, _gfp: Flags, _nid: NumaNode) -> Result<ZpoolHandle> {
+///         let pow = size.next_power_of_two().trailing_zeros().max(6);
+///         match pow {
+///             0 => Err(EINVAL),
+///             m if m > PAGE_SHIFT as u32 => Err(ENOSPC),
+///             _ => {
+///                 let vec = KVec::<u8>::with_capacity(1 << pow, GFP_KERNEL)?;
+///                 let (ptr, _len, _cap) = vec.into_raw_parts();
+///
+///                 // We assume that kmalloc-64, kmalloc-128 etc. kmem caches will be used for
+///                 // our allocations, so it's actually `1 << pow` bytes that we have consumed.
+///                 pool.bytes_used.fetch_add(1 << pow, Ordering::Relaxed);
+///
+///                 // `kmalloc` guarantees that an allocation of size x*2^n is 2^n aligned.
+///                 // Therefore the 6 lower bits are zeros and we can use these to store `pow`.
+///                 Ok(ZpoolHandle::from_raw(ptr as usize | (pow as usize - 6)))
+///             }
+///         }
+///     }
+///
+///     unsafe fn free(pool: &MyZpool, handle: ZpoolHandle) {
+///         let h = handle.as_raw();
+///         let n = (h & 0x3F) + 6;
+///         let uptr = h & !0x3F;
+///
+///         // SAFETY:
+///         // - we derive `uptr` from handle by zeroing 6 lower bits where we store the power
+///         //   denominator for the vector capacity. As noted above, the result will be exactly the
+///         //   pointer to the area allocated by `KVec`. Thus, uptr is a valid pointer pointing to
+///         //   the vector allocated by `alloc` function above.
+///         // - 1 << n == capacity and is coming from the first 6 bits of handle.
+///         let vec = unsafe { KVec::<u8>::from_raw_parts(uptr as *mut u8, 0, 1 << n) };
+///         drop(vec);
+///         pool.bytes_used.fetch_sub(1 << n, Ordering::Relaxed);
+///     }
+///
+///     unsafe fn read_begin(_pool: &MyZpool, handle: ZpoolHandle) -> NonNull<u8> {
+///         let uptr = handle.as_raw() & !0x3F;
+///         // SAFETY:
+///         // - we derive `uptr` from handle by zeroing 6 lower bits where we store the power
+///         //   denominator for the vector capacity. As noted above, the result will be exactly the
+///         //   pointer to the area allocated by `KVec`. Thus, uptr is a valid pointer pointing to
+///         //   the vector allocated by `alloc` function above.
+///         unsafe { NonNull::new_unchecked(uptr as *mut u8) }
+///     }
+///
+///     unsafe fn read_end(_pool: &MyZpool, _handle: ZpoolHandle, _handle_mem: NonNull<u8>) {}
+///
+///     unsafe fn write(_p: &MyZpool, handle: ZpoolHandle, h_mem: NonNull<u8>, mem_len: usize) {
+///         let uptr = handle.as_raw() & !0x3F;
+///         // SAFETY:
+///         // - `h_mem` is a valid non-null pointer provided by zswap.
+///         // - `uptr` is derived from handle by zeroing 6 lower bits where we store the power
+///         //   denominator for the vector capacity. As noted above, the result will be exactly the
+///         //   pointer to the area allocated by `KVec`. Thus, uptr is a valid pointer pointing to
+///         //   the vector allocated by `alloc` function above.
+///         unsafe {
+///             copy_nonoverlapping(h_mem.as_ptr().cast(), uptr as *mut c_void, mem_len)
+///         };
+///     }
+///
+///     fn total_pages(pool: &MyZpool) -> u64 {
+///         pool.bytes_used.load(Ordering::Relaxed) >> PAGE_SHIFT
+///     }
+/// }
+///
+/// // Uncomment this for compile time registration (disabled to avoid build error when KUNIT
+/// // tests and zsmalloc are enabled):
+/// // kernel::DECLARE_ZPOOL!(MyZpoolDriver);
+/// ```
+///
+pub trait ZpoolDriver {
+    /// Opaque Rust representation of `struct zpool`.
+    type Pool: ForeignOwnable;
+
+    /// Create a pool.
+    fn create(name: CString, gfp: Flags) -> Result<Self::Pool>;
+
+    /// Allocate an object of `size` bytes from `pool`, with the allocation flags `gfp` and
+    /// preferred NUMA node `nid`. If the allocation is successful, an opaque handle is returned.
+    fn malloc(
+        pool: <Self::Pool as ForeignOwnable>::Borrowed<'_>,
+        size: usize,
+        gfp: Flags,
+        nid: NumaNode,
+    ) -> Result<ZpoolHandle>;
+
+    /// Free an object previously allocated from the `pool`, represented by `handle`.
+    ///
+    /// # Safety
+    ///
+    /// - `handle` must be a valid handle previously returned by `malloc`.
+    /// - `handle` must not be used any more after the call to `free`.
+    unsafe fn free(pool: <Self::Pool as ForeignOwnable>::Borrowed<'_>, handle: ZpoolHandle);
+
+    /// Make all the necessary preparations for the caller to be able to read from the object
+    /// represented by `handle` and return a valid pointer to that object's memory to be read.
+    ///
+    /// # Safety
+    ///
+    /// - `handle` must be a valid handle previously returned by `malloc`.
+    /// - `read_end` with the same `handle` must be called for each `read_begin`.
+    unsafe fn read_begin(
+        pool: <Self::Pool as ForeignOwnable>::Borrowed<'_>,
+        handle: ZpoolHandle,
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
+        handle: ZpoolHandle,
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
+    /// - `handle_mem` must be a valid pointer into the allocated memory aread represented by
+    ///   `handle`.
+    /// - `handle_mem + mem_len - 1` must not point outside the allocated memory area.
+    unsafe fn write(
+        pool: <Self::Pool as ForeignOwnable>::Borrowed<'_>,
+        handle: ZpoolHandle,
+        handle_mem: NonNull<u8>,
+        mem_len: usize,
+    );
+
+    /// Get the number of pages used by the `pool`.
+    fn total_pages(pool: <Self::Pool as ForeignOwnable>::Borrowed<'_>) -> u64;
+}
+
+/// Provide a zpool allocator to zswap
+#[macro_export]
+macro_rules! DECLARE_ZPOOL {
+    ($t: ident) => {
+        use core::ptr::null_mut;
+        use kernel::error::from_result;
+        use kernel::types::ForeignOwnable;
+
+        const __LOG_PREFIX: &[u8] = b"zpool_rust\0";
+
+        fn handle_from_result<T, F>(f: F) -> T
+        where
+            T: From<usize>,
+            F: FnOnce() -> Result<T>,
+        {
+            match f() {
+                Ok(v) => v,
+                Err(e) => T::from(0),
+            }
+        }
+
+        /// Create a pool.
+        #[no_mangle]
+        pub unsafe extern "C" fn zpool_create_pool(name: *const c_uchar) -> *mut c_void {
+            match (|| -> Result<<$t as ZpoolDriver>::Pool> {
+                // SAFETY: the memory pointed to by name is guaranteed by `zpool` to be a valid
+                // string.
+                let name_r = unsafe { CStr::from_char_ptr(name).to_cstring() }?;
+                $t::create(name_r, flags::GFP_KERNEL)
+            })() {
+                Err(_) => null_mut(),
+                Ok(pool) => <$t as ZpoolDriver>::Pool::into_foreign(pool),
+            }
+        }
+
+        /// Destroy the pool.
+        #[no_mangle]
+        pub unsafe extern "C" fn zpool_destroy_pool(pool: *mut c_void) {
+            // SAFETY: The pointer originates from an `into_foreign` call.
+            drop(unsafe { <$t as ZpoolDriver>::Pool::from_foreign(pool) })
+        }
+
+        /// Allocate an object of `size` bytes from `pool`, with the allocation flags `gfp` and
+        /// preferred NUMA node `nid`. If the allocation is successful, an opaque handle
+        /// is returned.
+        #[no_mangle]
+        pub unsafe extern "C" fn zpool_malloc(
+            pool: *mut c_void,
+            size: usize,
+            gfp: u32,
+            nid: c_int,
+        ) -> c_ulong {
+            // SAFETY: The pointer originates from an `into_foreign` call. If `pool` is passed to
+            // `from_foreign`, then that happens in `zpool_destroy_pool` which will not be called
+            // during this method.
+            let pool = unsafe { <$t as ZpoolDriver>::Pool::borrow(pool) };
+            handle_from_result(|| {
+                let the_nid = match nid {
+                    kernel::bindings::NUMA_NO_NODE => NumaNode::NO_NODE,
+                    _ => NumaNode::new(nid)?,
+                };
+                let h = $t::malloc(
+                    pool,
+                    size,
+                    flags::GFP_NOWAIT | flags::__GFP_HIGHMEM,
+                    the_nid,
+                )?;
+                Ok(h.as_raw())
+            })
+        }
+
+        /// Free an object previously allocated from the `pool`, represented by `handle`.
+        #[no_mangle]
+        pub unsafe extern "C" fn zpool_free(pool: *mut c_void, handle: usize) {
+            // SAFETY: The pointer originates from an `into_foreign` call. If `pool` is passed to
+            // `from_foreign`, then that happens in `zpool_destroy_pool` which will not be called
+            // during this method.
+            let pool = unsafe { <$t as ZpoolDriver>::Pool::borrow(pool) };
+
+            // SAFETY:
+            // - the caller (`zswap`) guarantees that `handle` is a valid handle previously
+            // allocated by `malloc`.
+            // - the caller (`zswap`) guarantees that it will not call any other function with this
+            //   `handle` as a parameter after this call.
+            unsafe { $t::free(pool, ZpoolHandle::from_raw(handle)) }
+        }
+
+        /// Make all the necessary preparations for the caller to be able to read from the object
+        /// represented by `handle` and return a valid pointer to that object's memory to be read.
+        #[no_mangle]
+        pub unsafe extern "C" fn zpool_obj_read_begin(
+            pool: *mut c_void,
+            handle: usize,
+            _local_copy: *mut c_void,
+        ) -> *mut c_void {
+            // SAFETY: The pointer originates from an `into_foreign` call. If `pool` is passed to
+            // `from_foreign`, then that happens in `zpool_destroy_pool` which will not be called
+            // during this method.
+            let pool = unsafe { <$t as ZpoolDriver>::Pool::borrow(pool) };
+
+            // SAFETY: the caller (`zswap`) guarantees that `handle` is a valid handle previously
+            // allocated by `malloc`.
+            let non_null_ptr = unsafe { $t::read_begin(pool, ZpoolHandle::from_raw(handle)) };
+            non_null_ptr.as_ptr().cast()
+        }
+
+        /// Finish reading from a previously allocated `handle`. `handle_mem` must be the pointer
+        /// previously returned by `read_begin`.
+        #[no_mangle]
+        pub unsafe extern "C" fn zpool_obj_read_end(
+            pool: *mut c_void,
+            handle: usize,
+            handle_mem: *mut c_void,
+        ) {
+            // SAFETY: The pointer originates from an `into_foreign` call. If `pool` is passed to
+            // `from_foreign`, then that happens in `zpool_destroy_pool` which will not be called
+            // during this method.
+            let pool = unsafe { <$t as ZpoolDriver>::Pool::borrow(pool) };
+
+            // SAFETY: `handle_mem` is guaranteed to be non-null by the caller (`zswap`).
+            let handle_mem_ptr = unsafe { NonNull::new_unchecked(handle_mem.cast()) };
+
+            // SAFETY: the caller (`zswap`) guarantees that `handle` is a valid handle previously
+            // allocated by `malloc`.
+            unsafe { $t::read_end(pool, ZpoolHandle::from_raw(handle), handle_mem_ptr) }
+        }
+
+        /// Write to the object represented by a previously allocated `handle`. `handle_mem` points
+        /// to the memory to copy data from, and `mem_len` defines the length of the data block to
+        /// be copied.
+        #[no_mangle]
+        pub unsafe extern "C" fn zpool_obj_write(
+            pool: *mut c_void,
+            handle: usize,
+            handle_mem: *mut c_void,
+            mem_len: usize,
+        ) {
+            // SAFETY: The pointer originates from an `into_foreign` call. If `pool` is passed to
+            // `from_foreign`, then that happens in `zpool_destroy_pool` which will not be called
+            // during this method.
+            let pool = unsafe { <$t as ZpoolDriver>::Pool::borrow(pool) };
+
+            // SAFETY: `handle_mem` is guaranteed to be non-null by the caller (`zswap`).
+            let handle_mem_ptr = unsafe { NonNull::new_unchecked(handle_mem.cast()) };
+
+            // SAFETY: the caller (`zswap`) guarantees that `handle` is a valid handle previously
+            // allocated by `malloc`.
+            unsafe {
+                $t::write(pool, ZpoolHandle::from_raw(handle), handle_mem_ptr, mem_len);
+            }
+        }
+
+        /// Get the number of pages used by the `pool`.
+        #[no_mangle]
+        pub unsafe extern "C" fn zpool_get_total_pages(pool: *mut c_void) -> u64 {
+            // SAFETY: The pointer originates from an `into_foreign` call. If `pool` is passed to
+            // `from_foreign`, then that happens in `zpool_destroy_pool` which will not be called
+            // during this method.
+            let pool = unsafe { <$t as ZpoolDriver>::Pool::borrow(pool) };
+            $t::total_pages(pool)
+        }
+    };
+}
-- 
2.39.2


