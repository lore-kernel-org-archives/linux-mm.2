Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ECA4BEE6B60
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 21:12:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 602066B00A5; Fri,  6 Feb 2026 16:12:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5CF9D6B00A6; Fri,  6 Feb 2026 16:12:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4AE256B00A7; Fri,  6 Feb 2026 16:12:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 363316B00A5
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 16:12:15 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EAD1C16034E
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 21:12:14 +0000 (UTC)
X-FDA: 84415279788.23.FF5ECC8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 2C81040010
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 21:12:13 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=unFx6tXI;
	spf=pass (imf12.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770412333;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6gIsJpHYcfXOUr+HmRTEIPRjY07E6sWk+hIemQcUqww=;
	b=QM7q4+dnButmiQUvWfRx+2h5S+cc5f5ZA1hIrQ9zMVIF4uZZz2RvRMxf3yoGU+rs+FyZv/
	XJadOD5vrwrfA0LY04O9bOsxluGH6W9d6KdLwt7zX/YJvjy/g4zU4SFSVsfwaAaEHdN6JY
	d01PuUBZO960kDD3OHn79x24K+vFHb4=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=unFx6tXI;
	spf=pass (imf12.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770412333; a=rsa-sha256;
	cv=none;
	b=0GJg0/xy6rnhlb1HJ4qkCDZZN76RdOe24sorSFVoPuAuS2yLPPHLy/CrzI9QtoFZ2IMwhS
	N/1qd37eDUo7UonXq/GGstP/mpx+KpKi2I3oGefP4OrBwuf3Lqq+lfAHWPRh9Xs/yMyG4q
	R72r5wnH2ViI9dY3qbLv24ZxmS4jy14=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 35E1A6014A;
	Fri,  6 Feb 2026 21:12:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36E5CC116C6;
	Fri,  6 Feb 2026 21:12:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770412331;
	bh=C8QF46vi4KY242ax7lajp6MFFf081K0dM+QSFTirzLs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=unFx6tXItVCx6MU6Pc1zALMd4icy/GYUrGt67YJCBVNfAeUXJ1WNnJCMzLkmWiIkD
	 z3+hBeXDVjD/szXfSzO1YM7fGhg7zzPy6k+wKdzeb26hyNevvtOUEjs4g6/3G0dTYX
	 7XXmoYYB0J3lhzi+m0R6PmkDirHoySJf+WFP9x2sjcdYY2JBDBdhF3JpwMnx5Bgrg5
	 6Kz8TAc0A7WZefR5WZIoDc3+GCg2A5U54RYok6tjAdCLTq8HY9Ofss9QVJb5aVQe5O
	 ymnY/HhIMJ23EHbU2YUGOViMo+FA5Cx0baEU3Ojh0GyirMRkdSm8uAReIQvzRB6MuL
	 s+jXrkT5CRw9w==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Fri, 06 Feb 2026 22:10:55 +0100
Subject: [PATCH v2 09/11] rust: mm: add abstractions for allocating from a
 `sheaf`
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260206-xarray-entry-send-v2-9-91c41673fd30@kernel.org>
References: <20260206-xarray-entry-send-v2-0-91c41673fd30@kernel.org>
In-Reply-To: <20260206-xarray-entry-send-v2-0-91c41673fd30@kernel.org>
To: Tamir Duberstein <tamird@gmail.com>, Miguel Ojeda <ojeda@kernel.org>, 
 Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
 Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Benno Lossin <lossin@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
 Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>
Cc: Daniel Gomez <da.gomez@kernel.org>, rust-for-linux@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 Andreas Hindborg <a.hindborg@kernel.org>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=16716;
 i=a.hindborg@kernel.org; h=from:subject:message-id;
 bh=C8QF46vi4KY242ax7lajp6MFFf081K0dM+QSFTirzLs=;
 b=owEBbQKS/ZANAwAKAeG4Gj55KGN3AcsmYgBphljpgmj7e9GgNxEZA7YfgF5ubO1egUZc7vVXT
 enlR3PK6oeJAjMEAAEKAB0WIQQSwflHVr98KhXWwBLhuBo+eShjdwUCaYZY6QAKCRDhuBo+eShj
 d4aVD/9gtBnAtpFQT1SQMheqqLPa5ehB0PdhSm6TVkjm4XPDi4zqB7nyGGkUHUcnw+7BNdJf7tf
 mRxYQHOW6ANS5WdQJpn8NsHFo1VLeQG5Fed39IA6odDUDCzijmwwam3r/r5cYieOS0+7EAuvVVJ
 5WE3x9q9ARq0eEhKPpAYGQcPt8A+s01kkdkzON3qctzZYGnRcRneykk1HguTLHkBoipazR+bJUh
 lqgnEGItVv4KlTyX5FJilJ6G84yhTiZLmgn60UawewRuyDLFOm8jZezq8YemnKDJ7QBNno8FLZP
 lXEyBDF7bQ1I7CaWichspzhG7qIIBRAMwO5ydJmFRoRXCnYV/+1hDaMZRq3LIva07Od7ZvBe/9A
 6MECNm0FutiwPKi144DY5A3CjfoHIhLQjIoo3NSO/BQijd2Cm0w4KJRbFRF65BM1BhavevYvG9p
 P+emzliSQhVi5Trt2PAVCg2FB6aA6IY6e2t6ZsYNutu7Fp8vZccQsVUGw6j+KFNe+t+Cvkr7wxs
 ua3ka9eAGJadbzRoUtNzlk3RtWOWxKXf3/O9nTNcfM7JffMaHK0Vx0GZvO1CU9aWCIclpEKEd8i
 xBGQJuqOXAjfABU3MHgbq9JDukMtKE91YbNFUuu7o3z29GOTyWAXi4MgeXreunRAOl5kfM3TY2j
 qR5wqkF8BuMRDuQ==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2C81040010
X-Stat-Signature: u63z8t7ogx711wxa4jhstci5nhs8zqpo
X-Rspam-User: 
X-HE-Tag: 1770412333-574880
X-HE-Meta: U2FsdGVkX1+Fsa7IZrdNFZAo86jLtVwfNB2D8Dcunvoooudtj3BEZtRcOhyBZUG7L6iI39nKfB/lQGHgo6ZvN8rYqebYsCnXp7dXo47Z6GoOlr5RrTAEArYchBB+qhr5q11Qjy+MDfPYrW6i4KDvQ6w4BgIoaAGNBDTSXuVIF/jCzDaXkBFGkmt3/Oo259bUV6KlGh/mJT3flbkBoqjgnRHOOXNB0YnPrq1SEHI9yw/EuetF0F9pfaTloA5zAWC7Qyqo2DcPlSe25gBwG2qX6sAKKizrNnXoVDeRgpcGZ+p1XJ7bVc5e8vWyADZiG07gOAD48StByWBKpwW3DnMCLGVGkH29XXSYhf7nKJRG0g9sRh1Hq9VceJT+33kgVIorNFeZwMxSUa4vHsNNajXVQG6bI6asGhCv42NM0saxeqDfKimRM/GGbQvh8R6CW9q3RsaGPq3+avoWfTtOmvmUnQZCDn45/Lc9/IAKR3KD6n+o++LLEZaOWZJdLic5if2kEGR1pI6TgrPLdpYp4CvkN7/B+KY0yO7RWLgjVsp8kjP4UR6HlECvGGpcZa7aYWSCcqe2EoVNBc6pQndkY/yeg4I6A0XvtuQglXf3eXuxYIhTBZriUhudASobqDRtGsEl/iAXdo2/IHCgAKQ/OAz36HHJexxNtbmsJo7IGZSSI5SKx9msd2mOg6JW7v3fviqrGRGFQ4n199gFFhCV68kAPXa5MZCPd3wJlCkWEHRJ6WNjrpqkBsKo8WrYEIW75oXf1MvwU+r3tBqSt3f6smqicEFv4JXMKH4FLy1u4LyROs9tUCIm+06XVqQyns32doPRccVJeYkJU8ht0kZa/jGMZpA7xf7n9NHawUanD+BueWqglqo/66HU5x/wkA5MCaaYV164Pj4TzKqY22BGtFiwXDUVljttuMJWowvS7u4FRh5ZZ/bl1bdo1PTa4eEfyo2Vldt7DSK9xrBaaMy3L6w
 IjKAltyH
 Gz1J1jGQPUVIMwjRs1QAHPCSrt3M9LjIg8TczXWV9GZNzZJwJx7+fjr1HhEjgstS8jh+/4mue8CCISm9EWx2iQhrXvTsXbn0mXKd3m8nh15Ec/5y4qdx9pX0y2nCWDBkMEkUsZ5l1stJYGRVs4ksoSbeL4aifyq7wyK6N2ySV6ICFIMBfq+BvqfAcKeijKEGAKv4ZlAvDa3PiH8TFQE7Lh9bQhEsRp/9J8WHRqgpVUOG9Ae/4DlN5qQu+zVXWG481lklQxAZIH3+agh6m8kdzcKukHx2m8q895LyuUh4aZRO0EswpNSyXAXXMRLQ9XERw5btYH7NvYhUeIDv+bBrbIq8j/8SOU18YJnB5L/Uc10K2EzWpEh0/HYQtMPiX4gxa2X5IJJtD9gYp6C3TXSFZANkc4wWX4LWw5zRAKvkOYaujlNlObCzwbDAO4E5k3IVWNHwLVSDJdPbiXhM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add Rust APIs for allocating objects from a `sheaf`.

Introduce a reduced abstraction `KMemCacheInit` for `struct kmem_cache` to
support management of the `Sheaf`s.

Initialize objects using in-place initialization when objects are allocated
from a `Sheaf`. This is different from C which tends to do some
initialization when the cache is filled. This approach is chosen because
there is no destructor/drop capability in `struct kmem_cache` that can be
invoked when the cache is dropped.

Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: linux-mm@kvack.org
Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 rust/kernel/mm.rs       |   2 +
 rust/kernel/mm/sheaf.rs | 406 ++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 408 insertions(+)

diff --git a/rust/kernel/mm.rs b/rust/kernel/mm.rs
index 4764d7b68f2a7..fcfa5a97ebf0a 100644
--- a/rust/kernel/mm.rs
+++ b/rust/kernel/mm.rs
@@ -18,6 +18,8 @@
 };
 use core::{ops::Deref, ptr::NonNull};
 
+#[cfg(not(any(CONFIG_SLUB_TINY, CONFIG_SLUB_DEBUG)))]
+pub mod sheaf;
 pub mod virt;
 use virt::VmaRef;
 
diff --git a/rust/kernel/mm/sheaf.rs b/rust/kernel/mm/sheaf.rs
new file mode 100644
index 0000000000000..c92750eaf1c4a
--- /dev/null
+++ b/rust/kernel/mm/sheaf.rs
@@ -0,0 +1,406 @@
+// SPDX-License-Identifier: GPL-2.0
+
+//! Slub allocator sheaf abstraction.
+//!
+//! Sheaves are percpu array-based caching layers for the slub allocator.
+//! They provide a mechanism for pre-allocating objects that can later
+//! be retrieved without risking allocation failure, making them useful in
+//! contexts where memory allocation must be guaranteed to succeed.
+//!
+//! The term "sheaf" is the english word for a bundle of straw. In this context
+//! it means a bundle of pre-allocated objects. A per-NUMA-node cache of sheaves
+//! is called a "barn". Because you store your sheafs in barns.
+//!
+//! # Use cases
+//!
+//! Sheaves are particularly useful when:
+//!
+//! - Allocations must be guaranteed to succeed in a restricted context (e.g.,
+//!   while holding locks or in atomic context).
+//! - Multiple allocations need to be performed as a batch operation.
+//! - Fast-path allocation performance is critical, as sheaf allocations avoid
+//!   atomic operations by using local locks with preemption disabled.
+//!
+//! # Architecture
+//!
+//! The sheaf system consists of three main components:
+//!
+//! - [`KMemCache`]: A slab cache configured with sheaf support.
+//! - [`Sheaf`]: A pre-filled container of objects from a specific cache.
+//! - [`SBox`]: An owned allocation from a sheaf, similar to a `Box`.
+//!
+//! # Example
+//!
+//! ```
+//! use kernel::c_str;
+//! use kernel::mm::sheaf::{KMemCache, KMemCacheInit, Sheaf, SBox};
+//! use kernel::prelude::*;
+//!
+//! struct MyObject {
+//!     value: u32,
+//! }
+//!
+//! impl KMemCacheInit<MyObject> for MyObject {
+//!     fn init() -> impl Init<MyObject> {
+//!         init!(MyObject { value: 0 })
+//!     }
+//! }
+//!
+//! // Create a cache with sheaf capacity of 16 objects.
+//! let cache = KMemCache::<MyObject>::new(c_str!("my_cache"), 16)?;
+//!
+//! // Pre-fill a sheaf with 8 objects.
+//! let mut sheaf = cache.as_arc_borrow().sheaf(8, GFP_KERNEL)?;
+//!
+//! // Allocations from the sheaf are guaranteed to succeed until empty.
+//! let obj = sheaf.alloc().unwrap();
+//!
+//! // Return the sheaf when done, attempting to refill it.
+//! sheaf.return_refill(GFP_KERNEL);
+//! # Ok::<(), Error>(())
+//! ```
+//!
+//! # Constraints
+//!
+//! - Sheaves are disabled when `CONFIG_SLUB_TINY` is enabled.
+//! - Sheaves are disabled when slab debugging (`slub_debug`) is active.
+//! - The sheaf capacity is fixed at cache creation time.
+
+use core::{
+    convert::Infallible,
+    marker::PhantomData,
+    ops::{Deref, DerefMut},
+    ptr::NonNull,
+};
+
+use kernel::prelude::*;
+
+use crate::sync::{Arc, ArcBorrow};
+
+/// A slab cache with sheaf support.
+///
+/// This type wraps a kernel `kmem_cache` configured with a sheaf capacity,
+/// enabling pre-allocation of objects via [`Sheaf`].
+///
+/// For now, this type only exists for sheaf management.
+///
+/// # Type parameter
+///
+/// - `T`: The type of objects managed by this cache. Must implement
+///   [`KMemCacheInit`] to provide initialization logic for new allocations.
+///
+/// # Invariants
+///
+/// - `cache` is a valid pointer to a `kmem_cache` created with
+///   `__kmem_cache_create_args`.
+/// - The cache is valid for the lifetime of this struct.
+pub struct KMemCache<T: KMemCacheInit<T>> {
+    cache: NonNull<bindings::kmem_cache>,
+    _p: PhantomData<T>,
+}
+
+impl<T: KMemCacheInit<T>> KMemCache<T> {
+    /// Creates a new slab cache with sheaf support.
+    ///
+    /// Creates a kernel slab cache for objects of type `T` with the specified
+    /// sheaf capacity. The cache uses the provided `name` for identification
+    /// in `/sys/kernel/slab/` and debugging output.
+    ///
+    /// # Arguments
+    ///
+    /// - `name`: A string identifying the cache. This name appears in sysfs and
+    ///   debugging output.
+    /// - `sheaf_capacity`: The maximum number of objects a sheaf from this
+    ///   cache can hold. A capacity of zero disables sheaf support.
+    ///
+    /// # Errors
+    ///
+    /// Returns an error if:
+    ///
+    /// - The cache could not be created due to memory pressure.
+    /// - The size of `T` cannot be represented as a `c_uint`.
+    pub fn new(name: &CStr, sheaf_capacity: u32) -> Result<Arc<Self>>
+    where
+        T: KMemCacheInit<T>,
+    {
+        let flags = 0;
+        let mut args: bindings::kmem_cache_args = pin_init::zeroed();
+        args.sheaf_capacity = sheaf_capacity;
+
+        // NOTE: We are not initializing at object allocation time, because
+        // there is no matching teardown function on the C side machinery.
+        args.ctor = None;
+
+        // SAFETY: `name` is a valid C string, `args` is properly initialized,
+        // and the size of `T` has been validated to fit in a `c_uint`.
+        let ptr = unsafe {
+            bindings::__kmem_cache_create_args(
+                name.as_ptr().cast::<u8>(),
+                core::mem::size_of::<T>().try_into()?,
+                &mut args,
+                flags,
+            )
+        };
+
+        // INVARIANT: `ptr` was returned by `__kmem_cache_create_args` and is
+        // non-null (checked below). The cache is valid until
+        // `kmem_cache_destroy` is called in `Drop`.
+        Ok(Arc::new(
+            Self {
+                cache: NonNull::new(ptr).ok_or(ENOMEM)?,
+                _p: PhantomData,
+            },
+            GFP_KERNEL,
+        )?)
+    }
+
+    /// Creates a pre-filled sheaf from this cache.
+    ///
+    /// Allocates a sheaf and pre-fills it with `size` objects. Once created,
+    /// allocations from the sheaf via [`Sheaf::alloc`] are guaranteed to
+    /// succeed until the sheaf is depleted.
+    ///
+    /// # Arguments
+    ///
+    /// - `size`: The number of objects to pre-allocate. Must not exceed the
+    ///   cache's `sheaf_capacity`.
+    /// - `gfp`: Allocation flags controlling how memory is obtained. Use
+    ///   [`GFP_KERNEL`] for normal allocations that may sleep, or
+    ///   [`GFP_NOWAIT`] for non-blocking allocations.
+    ///
+    /// # Errors
+    ///
+    /// Returns [`ENOMEM`] if the sheaf or its objects could not be allocated.
+    ///
+    /// # Warnings
+    ///
+    /// The kernel will warn if `size` exceeds `sheaf_capacity`.
+    pub fn sheaf(
+        self: ArcBorrow<'_, Self>,
+        size: usize,
+        gfp: kernel::alloc::Flags,
+    ) -> Result<Sheaf<T>> {
+        // SAFETY: `self.as_raw()` returns a valid cache pointer, and `size`
+        // has been validated to fit in a `c_uint`.
+        let ptr = unsafe {
+            bindings::kmem_cache_prefill_sheaf(self.as_raw(), gfp.as_raw(), size.try_into()?)
+        };
+
+        // INVARIANT: `ptr` was returned by `kmem_cache_prefill_sheaf` and is
+        // non-null (checked below). `cache` is the cache from which this sheaf
+        // was created. `dropped` is false since the sheaf has not been returned.
+        Ok(Sheaf {
+            sheaf: NonNull::new(ptr).ok_or(ENOMEM)?,
+            cache: self.into(),
+            dropped: false,
+        })
+    }
+
+    fn as_raw(&self) -> *mut bindings::kmem_cache {
+        self.cache.as_ptr()
+    }
+}
+
+impl<T: KMemCacheInit<T>> Drop for KMemCache<T> {
+    fn drop(&mut self) {
+        // SAFETY: `self.as_raw()` returns a valid cache pointer that was
+        // created by `__kmem_cache_create_args`. As all objects allocated from
+        // this hold a reference on `self`, they must have been dropped for this
+        // `drop` method to execute.
+        unsafe { bindings::kmem_cache_destroy(self.as_raw()) };
+    }
+}
+
+/// Trait for types that can be initialized in a slab cache.
+///
+/// This trait provides the initialization logic for objects allocated from a
+/// [`KMemCache`]. When the slab allocator creates new objects, it invokes the
+/// constructor to ensure objects are in a valid initial state.
+///
+/// # Implementation
+///
+/// Implementors must provide [`init`](KMemCacheInit::init), which returns
+/// a in-place initializer for the type.
+///
+/// # Example
+///
+/// ```
+/// use kernel::mm::sheaf::KMemCacheInit;
+/// use kernel::prelude::*;
+///
+/// struct MyData {
+///     counter: u32,
+///     name: [u8; 16],
+/// }
+///
+/// impl KMemCacheInit<MyData> for MyData {
+///     fn init() -> impl Init<MyData> {
+///         init!(MyData {
+///             counter: 0,
+///             name: [0; 16],
+///         })
+///     }
+/// }
+/// ```
+pub trait KMemCacheInit<T> {
+    /// Returns an initializer for creating new objects of type `T`.
+    ///
+    /// This method is called by the allocator's constructor to initialize newly
+    /// allocated objects. The initializer should set all fields to their
+    /// default or initial values.
+    fn init() -> impl Init<T, Infallible>;
+}
+
+/// A pre-filled container of slab objects.
+///
+/// A sheaf holds a set of pre-allocated objects from a [`KMemCache`].
+/// Allocations from a sheaf are guaranteed to succeed until the sheaf is
+/// depleted, making sheaves useful in contexts where allocation failure is
+/// not acceptable.
+///
+/// Sheaves provide faster allocation than direct allocation because they use
+/// local locks with preemption disabled rather than atomic operations.
+///
+/// # Lifecycle
+///
+/// Sheaves are created via [`KMemCache::sheaf`] and should be returned to the
+/// allocator when no longer needed via [`Sheaf::return_refill`]. If a sheaf is
+/// simply dropped, it is returned with `GFP_NOWAIT` flags, which may result in
+/// the sheaf being flushed and freed rather than being cached for reuse.
+///
+/// # Invariants
+///
+/// - `sheaf` is a valid pointer to a `slab_sheaf` obtained from
+///   `kmem_cache_prefill_sheaf`.
+/// - `cache` is the cache from which this sheaf was created.
+/// - `dropped` tracks whether the sheaf has been explicitly returned.
+pub struct Sheaf<T: KMemCacheInit<T>> {
+    sheaf: NonNull<bindings::slab_sheaf>,
+    cache: Arc<KMemCache<T>>,
+    dropped: bool,
+}
+
+impl<T: KMemCacheInit<T>> Sheaf<T> {
+    fn as_raw(&self) -> *mut bindings::slab_sheaf {
+        self.sheaf.as_ptr()
+    }
+
+    /// Return the sheaf and try to refill using `flags`.
+    ///
+    /// If the sheaf cannot simply become the percpu spare sheaf, but there's
+    /// space for a full sheaf in the barn, we try to refill the sheaf back to
+    /// the cache's sheaf_capacity to avoid handling partially full sheaves.
+    ///
+    /// If the refill fails because gfp is e.g. GFP_NOWAIT, or the barn is full,
+    /// the sheaf is instead flushed and freed.
+    pub fn return_refill(mut self, flags: kernel::alloc::Flags) {
+        self.dropped = true;
+        // SAFETY: `self.cache.as_raw()` and `self.as_raw()` return valid
+        // pointers to the cache and sheaf respectively.
+        unsafe {
+            bindings::kmem_cache_return_sheaf(self.cache.as_raw(), flags.as_raw(), self.as_raw())
+        };
+        drop(self);
+    }
+
+    /// Allocates an object from the sheaf.
+    ///
+    /// Returns a new [`SBox`] containing an initialized object, or [`None`]
+    /// if the sheaf is depleted. Allocations are guaranteed to succeed as
+    /// long as the sheaf contains pre-allocated objects.
+    ///
+    /// The `gfp` flags passed to `kmem_cache_alloc_from_sheaf` are set to zero,
+    /// meaning no additional flags like `__GFP_ZERO` or `__GFP_ACCOUNT` are
+    /// applied.
+    ///
+    /// The returned `T` is initialized as part of this function.
+    pub fn alloc(&mut self) -> Option<SBox<T>> {
+        // SAFETY: `self.cache.as_raw()` and `self.as_raw()` return valid
+        // pointers. The function returns NULL when the sheaf is empty.
+        let ptr = unsafe {
+            bindings::kmem_cache_alloc_from_sheaf_noprof(self.cache.as_raw(), 0, self.as_raw())
+        };
+
+        // SAFETY:
+        // - `ptr` is a valid pointer as it was just returned by the cache.
+        // - The initializer is infallible, so an error is never returned.
+        unsafe { T::init().__init(ptr.cast()) }.expect("Initializer is infallible");
+
+        let ptr = NonNull::new(ptr.cast::<T>())?;
+
+        // INVARIANT: `ptr` was returned by `kmem_cache_alloc_from_sheaf_noprof`
+        // and initialized above. `cache` is the cache from which this object
+        // was allocated. The object remains valid until freed in `Drop`.
+        Some(SBox {
+            ptr,
+            cache: self.cache.clone(),
+        })
+    }
+}
+
+impl<T: KMemCacheInit<T>> Drop for Sheaf<T> {
+    fn drop(&mut self) {
+        if !self.dropped {
+            // SAFETY: `self.cache.as_raw()` and `self.as_raw()` return valid
+            // pointers. Using `GFP_NOWAIT` because the drop may occur in a
+            // context where sleeping is not permitted.
+            unsafe {
+                bindings::kmem_cache_return_sheaf(
+                    self.cache.as_raw(),
+                    GFP_NOWAIT.as_raw(),
+                    self.as_raw(),
+                )
+            };
+        }
+    }
+}
+
+/// An owned allocation from a cache sheaf.
+///
+/// `SBox` is similar to `Box` but is backed by a slab cache allocation obtained
+/// through a [`Sheaf`]. It provides owned access to an initialized object and
+/// ensures the object is properly freed back to the cache when dropped.
+///
+/// The contained `T` is initialized when the `SBox` is returned from alloc and
+/// dropped when the `SBox` is dropped.
+///
+/// # Invariants
+///
+/// - `ptr` points to a valid, initialized object of type `T`.
+/// - `cache` is the cache from which this object was allocated.
+/// - The object remains valid for the lifetime of the `SBox`.
+pub struct SBox<T: KMemCacheInit<T>> {
+    ptr: NonNull<T>,
+    cache: Arc<KMemCache<T>>,
+}
+
+impl<T: KMemCacheInit<T>> Deref for SBox<T> {
+    type Target = T;
+
+    fn deref(&self) -> &Self::Target {
+        // SAFETY: `ptr` is valid and properly aligned per the type invariants.
+        unsafe { self.ptr.as_ref() }
+    }
+}
+
+impl<T: KMemCacheInit<T>> DerefMut for SBox<T> {
+    fn deref_mut(&mut self) -> &mut Self::Target {
+        // SAFETY: `ptr` is valid and properly aligned per the type invariants,
+        // and we have exclusive access via `&mut self`.
+        unsafe { self.ptr.as_mut() }
+    }
+}
+
+impl<T: KMemCacheInit<T>> Drop for SBox<T> {
+    fn drop(&mut self) {
+        // SAFETY: By type invariant, `ptr` points to a valid and initialized
+        // object. We do not touch `ptr` after returning it to the cache.
+        unsafe { core::ptr::drop_in_place(self.ptr.as_ptr()) };
+
+        // SAFETY: `self.ptr` was allocated from `self.cache` via
+        // `kmem_cache_alloc_from_sheaf_noprof` and is valid.
+        unsafe {
+            bindings::kmem_cache_free(self.cache.as_raw(), self.ptr.as_ptr().cast());
+        }
+    }
+}

-- 
2.51.2



