Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6885CA0FFD
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 07:18:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 25D886B002F; Fri, 29 Aug 2025 03:18:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 20E616B0030; Fri, 29 Aug 2025 03:18:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D67C6B0031; Fri, 29 Aug 2025 03:18:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E90116B002F
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 03:18:33 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BAB8F8516A
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 07:18:33 +0000 (UTC)
X-FDA: 83828942106.07.5A7CA1B
Received: from mailrelay-egress16.pub.mailoutpod3-cph3.one.com (mailrelay-egress16.pub.mailoutpod3-cph3.one.com [46.30.212.3])
	by imf19.hostedemail.com (Postfix) with ESMTP id 169451A000A
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 07:18:31 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=konsulko.se header.s=rsa2 header.b=ScJyEpEX;
	dkim=pass header.d=konsulko.se header.s=ed2 header.b=odPTH+GP
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756451912; a=rsa-sha256;
	cv=none;
	b=0KjrfdnHiGd9FBY+MJ/RCwsoBNWoOSNFBCS0OCwpkc1Wl6cCmKnPFMimQ/bALODbSWcMlK
	PbJl0Py3i/wGrOeWf4o3gXQXdzuZZWOTLfAx+LDEbV4CPPkSiRMhH+U/frySL0XdLytO4m
	rCPtf/xrAOvVw/xkO6eVUdu/A9to+Z8=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=konsulko.se header.s=rsa2 header.b=ScJyEpEX;
	dkim=pass header.d=konsulko.se header.s=ed2 header.b=odPTH+GP;
	dmarc=none;
	spf=none (imf19.hostedemail.com: domain of vitaly.wool@konsulko.se has no SPF policy when checking 46.30.212.3) smtp.mailfrom=vitaly.wool@konsulko.se
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756451912;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T9Y+Fj2hUAr+t/jILO9pLud/GiihvaaYAyjQAhHGMt8=;
	b=ighHWjmTUvvahL7EVLZaeBnuLQlZ0q4gEaS1+ePizk7kaNmi0av+Fre3iZTBV+Z7TRrHyP
	imAYJ2IXzqB0FgzrlWZJroN3QECWjXqkhDR/WG7EXGInuK91z/R6/ByYIvMBiEZHiNHU+X
	ScaHMwnrV7V8kOywNd5435q8DtSAKOM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1756451910; x=1757056710;
	d=konsulko.se; s=rsa2;
	h=content-transfer-encoding:mime-version:references:in-reply-to:message-id:date:
	 subject:cc:to:from:from;
	bh=T9Y+Fj2hUAr+t/jILO9pLud/GiihvaaYAyjQAhHGMt8=;
	b=ScJyEpEXWezoa4612nRrHoaPm29GLVRGKU1pF8W0eBAPnUfqZgDUwsUnAr+5CLjfiHX7hzOuCTiTc
	 9rFpOMCvKkSETzXMq2v54YS6q1d6xZOsOCBsXamAqp9T3kr9HtpENWsJ8BDoi3cw3sJvPzZUYvyMvc
	 TI/l53PYxsEY34GU6E/GW+7QhsYp8IavPTd5kCG1+ucMV81jzbZHEQXkzYdt9xC60VZO16b9jK9weW
	 7aKDwGm8SvWtZBhTNc1IMUmSG1YW2Ff+u9LPiHFbFLzVJ/OOmcikoEcU/G+Ni5JjEIP7Nzfu45wpwu
	 gCwub8XzzNFJ6bxvTs7dKV56W9zDKvA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1756451910; x=1757056710;
	d=konsulko.se; s=ed2;
	h=content-transfer-encoding:mime-version:references:in-reply-to:message-id:date:
	 subject:cc:to:from:from;
	bh=T9Y+Fj2hUAr+t/jILO9pLud/GiihvaaYAyjQAhHGMt8=;
	b=odPTH+GPiXF8CDbBXZtXOShz9t2kAkrLWa9JC2VAVzCEPFD0zKPNhEiACcLwbf+T9Dqq23kHQA9Y2
	 iDrs8AZAw==
X-HalOne-ID: 5b54343f-84a8-11f0-8d94-fb5fec76084d
Received: from localhost.localdomain (host-95-203-16-218.mobileonline.telia.com [95.203.16.218])
	by mailrelay3.pub.mailoutpod3-cph3.one.com (Halon) with ESMTPSA
	id 5b54343f-84a8-11f0-8d94-fb5fec76084d;
	Fri, 29 Aug 2025 07:18:29 +0000 (UTC)
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
Subject: [PATCH v5 2/2] rust: zpool: add abstraction for zpool drivers
Date: Fri, 29 Aug 2025 09:18:27 +0200
Message-Id: <20250829071827.1973212-1-vitaly.wool@konsulko.se>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250829071709.1973086-1-vitaly.wool@konsulko.se>
References: <20250829071709.1973086-1-vitaly.wool@konsulko.se>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 169451A000A
X-Stat-Signature: yc3uwe545hy8touak3snngq7e3wox3eb
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756451911-328512
X-HE-Meta: U2FsdGVkX1+Tfn56n64kc+i1q42m1xcmO8c+ECkFS6LaD50pQVp2De212htt6fEOFfMTr1oVbywNKG7KjL6pPRpqJIjHcO36WhJl6b+D+8l6OrT9vor8wpXTUCZxUZY2upyzL0ew+iD7D3XRyMqXzMaWsldvx3IBeuw4bbrmJnrQ0MssJaupULiMBiBRaN5a/+Gg5mjPqbdI96sd/qXUVbgpBIw0bOHv/D9+vNEAVX4D3jCo1u1qtpmU8j1Xz1utkpCbpvILU+28QrHSUgQ1Y5h/EAG63dZwdYXveieb5z3GnE2dI1iu0euiF2CZkN2cZaO7E71e1+MWCLo9dLhR4oJCu9Oai5txZ0MO9rNY3PWe1Ki8rDL7s7g/5bampKyhHPw3n5AdQnq7SPivopPHDDNlOenwNnXyLBC5dvX+SBhDyl7C4U064uR2mkJaG96i8TQK9gxxLBcWRP69yx1v0gPAOk3tqD5veuzf+Ujb2yr/Ex6Wwv1ZqMy7iLOhMM97fvArhy2bIlKraC5dxm0/twC77vfAm7CFnCvp8aLAp43PzUjmLHjDBP67slFbvSmoRb/w9jW46Fq6W3l5LbJ5pZiNeN+umPqeB5Zqb93pqpsM6/N31PxZaHKnTP6frQApFaQ0gtbzsZpCOTIsmQ+utFhFgmK1vJlJo/wMqVZa9ClWsQrtm0kPA7bQKcczxBhe8zyZL+I0Ya1tXLBnLfZkEw+U2hqiRXbNaJhC+eStv89VBcCw39yHUfd+VY8db+NwyoaRHHaPfHAEIP3boX4ujGPvQR4NLb3ZK2G9AAK5xfC4PUjULcNs0PXjMXyjvI/kmv2J4cnbpaKlKcfStTUTsoBQjIij5NAga1bSPuZW9MFpNPF2AlYJeu5+t4as0l32G7vq+2/rpl6+HGDWjmsd5iCFe7NaY1Rc0mtANVBCfFO58xxbhxKo9w==
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
 MAINTAINERS                     |   2 +
 rust/bindings/bindings_helper.h |   1 +
 rust/helpers/helpers.c          |   1 +
 rust/helpers/zpool.c            |   8 +
 rust/kernel/lib.rs              |   2 +
 rust/kernel/zpool.rs            | 377 ++++++++++++++++++++++++++++++++
 6 files changed, 391 insertions(+)
 create mode 100644 rust/helpers/zpool.c
 create mode 100644 rust/kernel/zpool.rs

diff --git a/MAINTAINERS b/MAINTAINERS
index b6f7c6939ff8..42b68dc800fb 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -16267,9 +16267,11 @@ W:	http://www.linux-mm.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
 F:	rust/helpers/mm.c
 F:	rust/helpers/page.c
+F:	rust/helpers/zpool.c
 F:	rust/kernel/mm.rs
 F:	rust/kernel/mm/
 F:	rust/kernel/page.rs
+F:	rust/kernel/zpool.rs
 
 MEMORY MAPPING
 M:	Andrew Morton <akpm@linux-foundation.org>
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
index 000000000000..6dd3edfc7fc8
--- /dev/null
+++ b/rust/helpers/zpool.c
@@ -0,0 +1,8 @@
+// SPDX-License-Identifier: GPL-2.0
+
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
index 000000000000..ae564ea22b77
--- /dev/null
+++ b/rust/kernel/zpool.rs
@@ -0,0 +1,377 @@
+// SPDX-License-Identifier: GPL-2.0
+
+//! Implementation of Rust interface towards zpool API.
+
+use crate::{
+    bindings,
+    error::{from_result, Result},
+    kernel::alloc::Flags,
+    str::{CString, CStr},
+    types::{ForeignOwnable, Opaque},
+};
+use core::ffi::{c_int, c_uchar, c_void};
+use core::ptr::{null_mut, NonNull};
+use kernel::alloc::NumaNode;
+use kernel::driver;
+use kernel::ThisModule;
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
+/// use kernel::alloc::{Flags, KBox, KVec, NumaNode};
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
+///         // - `h_mem` is a valid non-null pointer provided by zpool.
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
+/// An "adapter" for the registration of zpool drivers.
+pub struct Adapter<T: ZpoolDriver>(T);
+
+impl<T: ZpoolDriver> Adapter<T> {
+    extern "C" fn create_(name: *const c_uchar, gfp: u32) -> *mut c_void {
+        match (|| -> Result<T::Pool> {
+            // SAFETY: the memory pointed to by name is guaranteed by `zpool` to be a valid string.
+            let name_r = unsafe { CStr::from_char_ptr(name).to_cstring() }?;
+            T::create(name_r, Flags::from_raw(gfp))
+        }) () {
+            Err(_) => null_mut(),
+            Ok(pool) => T::Pool::into_foreign(pool),
+        }
+    }
+
+    extern "C" fn destroy_(pool: *mut c_void) {
+        // SAFETY: The pointer originates from an `into_foreign` call.
+        drop(unsafe { T::Pool::from_foreign(pool) })
+    }
+
+    extern "C" fn malloc_(
+        pool: *mut c_void,
+        size: usize,
+        gfp: u32,
+        handle: *mut usize,
+        nid: c_int,
+    ) -> c_int {
+        // SAFETY: The pointer originates from an `into_foreign` call. If `pool` is passed to
+        // `from_foreign`, then that happens in `destroy_` which will not be called during this
+        // method.
+        let pool = unsafe { T::Pool::borrow(pool) };
+
+        from_result(|| {
+            let real_nid = match nid {
+                bindings::NUMA_NO_NODE => NumaNode::NO_NODE,
+                _ => NumaNode::new(nid)?,
+            };
+            let h = T::malloc(pool, size, Flags::from_raw(gfp), real_nid)?;
+            // SAFETY: `handle` is guaranteed to be a valid pointer by `zpool`.
+            unsafe { *handle = h.as_raw() };
+            Ok(0)
+        })
+    }
+
+    extern "C" fn free_(pool: *mut c_void, handle: usize) {
+        // SAFETY: The pointer originates from an `into_foreign` call. If `pool` is passed to
+        // `from_foreign`, then that happens in `destroy_` which will not be called during this
+        // method.
+        let pool = unsafe { T::Pool::borrow(pool) };
+
+        // SAFETY:
+        // - the caller (`zpool`) guarantees that `handle` is a valid handle previously allocated
+        //   by `malloc`.
+        // - the caller (`zpool`) guarantees that it will not call any other function with this
+        //   `handle` as a parameter after this call.
+        unsafe { T::free(pool, ZpoolHandle::from_raw(handle)) }
+    }
+
+    extern "C" fn obj_read_begin_(
+        pool: *mut c_void,
+        handle: usize,
+        _local_copy: *mut c_void,
+    ) -> *mut c_void {
+        // SAFETY: The pointer originates from an `into_foreign` call. If `pool` is passed to
+        // `from_foreign`, then that happens in `destroy_` which will not be called during this
+        // method.
+        let pool = unsafe { T::Pool::borrow(pool) };
+
+        // SAFETY: the caller (`zpool`) guarantees that `handle` is a valid handle previously
+        // allocated by `malloc`.
+        let non_null_ptr = unsafe { T::read_begin(pool, ZpoolHandle::from_raw(handle)) };
+        non_null_ptr.as_ptr().cast()
+    }
+
+    extern "C" fn obj_read_end_(pool: *mut c_void, handle: usize, handle_mem: *mut c_void) {
+        // SAFETY: The pointer originates from an `into_foreign` call. If `pool` is passed to
+        // `from_foreign`, then that happens in `destroy_` which will not be called during this
+        // method.
+        let pool = unsafe { T::Pool::borrow(pool) };
+
+        // SAFETY: `handle_mem` is guaranteed to be non-null by the caller (`zpool`).
+        let handle_mem_ptr = unsafe { NonNull::new_unchecked(handle_mem.cast()) };
+
+        // SAFETY: the caller (`zpool`) guarantees that `handle` is a valid handle previously
+        // allocated by `malloc`.
+        unsafe { T::read_end(pool, ZpoolHandle::from_raw(handle), handle_mem_ptr) }
+    }
+
+    extern "C" fn obj_write_(
+        pool: *mut c_void,
+        handle: usize,
+        handle_mem: *mut c_void,
+        mem_len: usize,
+    ) {
+        // SAFETY: The pointer originates from an `into_foreign` call. If `pool` is passed to
+        // `from_foreign`, then that happens in `destroy_` which will not be called during this
+        // method.
+        let pool = unsafe { T::Pool::borrow(pool) };
+
+        // SAFETY: `handle_mem` is guaranteed to be non-null by the caller (zpool).
+        let handle_mem_ptr = unsafe { NonNull::new_unchecked(handle_mem.cast()) };
+
+        // SAFETY: the caller (`zpool`) guarantees that `handle` is a valid handle previously
+        // allocated by `malloc`.
+        unsafe {
+            T::write(pool, ZpoolHandle::from_raw(handle), handle_mem_ptr, mem_len);
+        }
+    }
+    extern "C" fn total_pages_(pool: *mut c_void) -> u64 {
+        // SAFETY: The pointer originates from an `into_foreign` call. If `pool` is passed to
+        // `from_foreign`, then that happens in `destroy_` which will not be called during this
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
+    ($($f:tt)*) => {
+        $crate::module_driver!(<T>, $crate::zpool::Adapter<T>, { $($f)* });
+    };
+}
-- 
2.39.2


