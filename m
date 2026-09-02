Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5E32C624D3
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 13:27:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A2ED46B00B9; Wed,  2 Sep 2026 09:27:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A067B6B00BD; Wed,  2 Sep 2026 09:27:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F5C26B00BE; Wed,  2 Sep 2026 09:27:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5FB126B00B9
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 09:27:36 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F1405120205
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 13:27:35 +0000 (UTC)
X-FDA: 85168899270.27.F291BC3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 0BF588000F
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 13:27:33 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dGbKuYye;
	spf=pass (imf30.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788355654;
	b=S9HyBkcIyG7iXMxYxK9ngaS/jCt0vlTBNa6ZWI/G9xiYv2YQI/YuT1hPaeho2fEMegxEqb
	lK0JRmCAOMxO1VKQ0DtWbyvxWRZnuzPSK3HoDeLarWHNMJqJJQcIsGUxCvgOhJq3nWAwgt
	gjNAAykqwz9mVc2PKuyVqyFNBKIQrFU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788355654;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lA7FWSljb2LQaxATt6lejnbnwqONrNFpZpcIwgRu0wY=;
	b=ZfG+dKOSG8Xl27FU9eaZ+l+OXI/nZX9rY2b6iRGr6qZmj5zlcdsNA9P2Y0hp4eU4nYXfHP
	L6fIOzITN0hrM1Qwz6A78OUYnzJExvvyAls/o7dCeW5CD1rel3XGeC/53m7DkLp9FGuPh1
	AZ1Q82GBqtvsMAgs7v55bWKYtC/1E2g=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dGbKuYye;
	spf=pass (imf30.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7A63B407DC;
	Wed,  2 Sep 2026 13:27:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 618841F00A3E;
	Wed,  2 Sep 2026 13:27:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788355652;
	bh=lA7FWSljb2LQaxATt6lejnbnwqONrNFpZpcIwgRu0wY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=dGbKuYyeTksF1KkirkhK/VWSN3TLarmu2BveEY9w1msKkaZH5gfoUBQgQ1C1Ms2sJ
	 G+l+2dSfcgRE1zgpYaLtkXj2zDjEucv0ANfMUL1N453hQhbNVT0hr2wx39o4Atgg0B
	 fJOdJtDmuat208RIbRwL7XvKnVuOjYXCOoyrMnWuHszrHX2mJSo5fWTSnK46vQBh9d
	 7CHhZY2DaADC85mE9XjivccZmYLt/s2CKRJwPKeibQ/V9XJhs8EjTj0lbdB3xFMsiZ
	 0pHnAoPzidSxQ6YpKz4N/yIULerQF+C7/KEGuG3yL7ttFNLvSWxKUpNbXWKVYV+/mM
	 Sa/YdduBbyPFw==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Wed, 02 Sep 2026 15:26:04 +0200
Subject: [PATCH v5 08/12] rust: mm: add abstractions for allocating from a
 `sheaf`
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260902-xarray-entry-send-v5-8-d18adae40708@kernel.org>
References: <20260902-xarray-entry-send-v5-0-d18adae40708@kernel.org>
In-Reply-To: <20260902-xarray-entry-send-v5-0-d18adae40708@kernel.org>
To: Tamir Duberstein <tamird@kernel.org>, Miguel Ojeda <ojeda@kernel.org>, 
 Boqun Feng <boqun@kernel.org>, Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Benno Lossin <lossin@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
 Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, 
 Daniel Almeida <daniel.almeida@collabora.com>, 
 Alexandre Courbot <acourbot@nvidia.com>, 
 =?utf-8?q?Onur_=C3=96zkan?= <work@onurozkan.dev>, 
 Matthew Wilcox <willy@infradead.org>, 
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Harry Yoo <harry@kernel.org>, Hao Li <hao.li@linux.dev>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>
Cc: Andreas Hindborg <a.hindborg@kernel.org>, 
 rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
 Vlastimil Babka <vbabka@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Lorenzo Stoakes <ljs@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=19705;
 i=a.hindborg@kernel.org; h=from:subject:message-id;
 bh=RjS4bVXdE61HMAu4upNw+EYFUe3wUNyGbYdxylQjok8=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBqmCQg11lMGYGlRZeIE/G3smnqwEx46oHVePm6J
 HYpVyUg7xWJAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCapgkIAAKCRD6UCkIqsW9
 0IpxEACe00crXipmdKSsy/VkKKKxGhySGh7cNmoCQUxbK3okXnfzOR41t3JdSYQEzS4ZkVAgrNZ
 0FQSzuJB5y7p0dJqe0Dki2IXge4fcjKYIxnTbHwD5ik8uv/ygiIes07NhGeYP9i2bJtCKFz5rg1
 TcKtiaT71OHHCWIe48/kJrg0s8iv/XNSR6WvpsfdYYMUR7y17unWC28TVP5cXTvPtcHZYRiYos3
 5d/vVg0VU7UFGedaioSU6xv+xhNgg2zGgG6rR8Z+q2YYDMkr8Ddv/E/2lQ6/xMmSDLpK7fMQMf8
 YHBysrfzQbd9IzQdtoomdJFwRXwtR4EjSVXP+oLf3L+Cekbk+0gsELq8M5EbJCbjxJvgG2SvgHz
 nkSNIYFzkI7y7c6Ct260B0ALSutL6QhNtVQlGhVlw8Ow/Sij7IUhfWUGkLmhELrBEJIWVqEv+zs
 /EgyOsA72GnvM31mnFwk6UbAykdibbvY56tGatYwSUJaXEAO0GZ2nVk1aZChIaAp57VO6mepE5Z
 m1Fo8I854GnNNlgzWO2FZctE0o5Hfn01mWKUrP+qnHifaOEhBgFzE0+IsCU555FalncqHtHBbJe
 q5iV3ZVkapMe8UUVRoXJO+fqIiRkUuYZuB9volWr/AsbF6wrmFyfrLsGAffNmDnEcBYm+t5eoX5
 FLG31NRui7k6EtQ==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 0BF588000F
X-Stat-Signature: mdm4hf7kxm84bf3ms51oieczpz6z1a9s
X-HE-Tag: 1788355653-482914
X-HE-Meta: U2FsdGVkX18eAArBGAzBHa1HCk8oBWXhq3ES5m47vnVVSVnviqXtqpDBm1vYnPZukkdM/7snjKdd2vrJxYUKxPvXY4GoIKzJBncZENA518pNgHdjzlkMqwsD82lzJVzL8nfEGkrGZ+h6+JpGyDqPoZbnShKeVX4ONtciIDNkLujfs/G5+7AV8E9TacJHm5/SWd7M2T2tB3qj0Sae6bJWoit16M7QSTnSnbaStI1f00At681tU+OeDp9zaWNe4vFbnoimNg7o7Gbs+dgdIuGbU2hWUPb9e/yD/rO/XsmfN/NrHFpUWlSrMfQdeLsIt3rQWs8r58gS79CzeTB4rLmnmo1fdOzi2m+4a0wP6Q6cah8sKtCy1YL3Rxn5uh27ONU3/VGDQXdZeuKdsm6v/HOLah4I4HMzHddbCJctPecV/C9KsGJwG0o87DwBbPg1FOD8jT/iGcnne0iPuImKlZ8IacfPsJO5EsEltKCZNkYP/EwArhOUF2dKc2psk1i1B1uLpK5zGvRK9tVzaHN+1/bNibBH4DV7tCG420GjokAs2maCxHwnD4hZoUnYGATLN2Krq3tDwSuX+5SF76/9zTodt4C1xiBm81x/qLAGia9BVBVuPJg7U07pOgKmO6qX+KiGoEg6kXzxSoNm/U3Win2NVtQvDg9UYwEGbYxJi4VmOCjP8psOd06mUqliS1rAP0s5TkgnjjPCaBRtFlJa2vUXWEM5Xl6Uq2o3vJMFrb4B05hyn1u+Ewe534ueGJmVZpBUaETFyZ/GtM7xPSSbWMTAZu1x3FplGyBacCmKlf0ckF/LL+uSCB8O9PWyPe4WsgBKD+OwboRls1Ilx6leVZuqAE3788eu+xmyhfd9fmp4N0VyE3UGZWfvoh7BaclZEG5PUms2fEQMkLU1tEKT1x9nDxlcARS6WCZPav8tqFhk7gWj6fzaZVM1pJGs+MOexguZpxicyWA0uMNK2iLzwXj
 8gFoQ0Hx
 Je0L5Kr7cvzxyZF8VMQygL+p0dMPhdkeUrEFyDoFgUdaIXlt0QRSpU7sdf/EWtSnx7WzDNXakiPVHzpdCfLBD8aK7+OCLwoISXsGd9lRSE9VPxp419xdDScpn3Ufc7NelD7HqVULGoR4E4UAclIsX5qqNG2kN0DmP56It5liD6oBFxGpV7tAk7JRFaY6Dx9nkWEgAnNE1Wh17fqtDDQAbor/jCDIErbeNQGfEpQUL+xYHCKOFd1xshg4dUeGhv+YkNUUpi3mnLUF7LvQDCTmQ1OPFJc03MGH+Dc9JitUQmyrDYZP6Ukkmv6DHc4njldV/CX8dX9I/eOV+Fu+BBILuw7AG0B+yVTlj4bx6dRwm1SzqMdslpsr/gyB3qxdsckGA/Fd2
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
Assisted-by: LLM
Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 rust/kernel/mm.rs       |   1 +
 rust/kernel/mm/sheaf.rs | 466 ++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 467 insertions(+)

diff --git a/rust/kernel/mm.rs b/rust/kernel/mm.rs
index 4764d7b68f2a7..1aa44424b0d53 100644
--- a/rust/kernel/mm.rs
+++ b/rust/kernel/mm.rs
@@ -18,6 +18,7 @@
 };
 use core::{ops::Deref, ptr::NonNull};
 
+pub mod sheaf;
 pub mod virt;
 use virt::VmaRef;
 
diff --git a/rust/kernel/mm/sheaf.rs b/rust/kernel/mm/sheaf.rs
new file mode 100644
index 0000000000000..8f310a06d8404
--- /dev/null
+++ b/rust/kernel/mm/sheaf.rs
@@ -0,0 +1,466 @@
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
+//! - Sheaves are slower when `CONFIG_SLUB_TINY` or `CONFIG_SLUB_DEBUG` is
+//!   enabled due to cpu sheaves being disabled. All prefilled sheaves become
+//!   "oversize" and go through a slower allocation path.
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
+/// # Context
+///
+/// Dropping the last reference to a `KMemCache` destroys the cache via
+/// `kmem_cache_destroy`, which may sleep. [`Sheaf`] and [`SBox`] instances
+/// created from the cache each hold a reference, so the last reference may
+/// be dropped when one of those is dropped. The last reference must not be
+/// dropped from a context where sleeping is not allowed.
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
+// SAFETY: `KMemCache<T>` owns a `kmem_cache`, which is internally
+// synchronized and has no thread affinity. The cache may be destroyed from a
+// thread other than the one that created it.
+unsafe impl<T: KMemCacheInit<T> + Send> Send for KMemCache<T> {}
+
+// SAFETY: All operations available through `&KMemCache<T>` are
+// internally synchronized by the C side, so the cache may be used from
+// multiple threads concurrently if the objects it manages can be sent between
+// threads.
+unsafe impl<T: KMemCacheInit<T> + Send> Sync for KMemCache<T> {}
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
+        // With an alignment of zero, the slab allocator only guarantees
+        // `ARCH_SLAB_MINALIGN`, which may be smaller than the alignment of `T`.
+        args.align = core::mem::align_of::<T>().try_into()?;
+
+        // NOTE: We are not initializing at object allocation time, because
+        // there is no matching teardown function on the C side machinery.
+        args.ctor = None;
+
+        // SAFETY: `name` is a valid C string, `args` is properly initialized,
+        // and the size of `T` has been validated to fit in a `c_uint`.
+        let ptr = unsafe {
+            bindings::__kmem_cache_create_args(
+                name.as_char_ptr(),
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
+    #[inline]
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
+    /// The initializer is applied to newly allocated objects when they are
+    /// allocated from a sheaf via [`Sheaf::alloc`]. The cache itself has no
+    /// constructor. The initializer should set all fields to their default or
+    /// initial values.
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
+/// A sheaf holds a reference to the [`KMemCache`] it was created from.
+/// Dropping the sheaf may thus drop the last reference to the cache and
+/// destroy the cache, which may sleep. See the `# Context` section of
+/// [`KMemCache`].
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
+// SAFETY: A prefilled sheaf is exclusively owned by the caller and has no
+// affinity to the CPU or thread that created it: `kmem_cache_alloc_from_sheaf`
+// does not touch percpu state, and `kmem_cache_return_sheaf` reattaches the
+// sheaf to the CPU that is current at return time. Thus the sheaf may be sent
+// to another thread if the objects it manages can.
+unsafe impl<T: KMemCacheInit<T> + Send> Send for Sheaf<T> {}
+
+// NOTE: `Sheaf` is deliberately not `Sync`. The C side mutates sheaf state
+// without synchronization, relying on the caller's exclusive ownership. The
+// mutable receivers of the methods on `Sheaf` enforce this exclusivity.
+
+impl<T: KMemCacheInit<T>> Sheaf<T> {
+    #[inline]
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
+        let ptr = NonNull::new(ptr.cast::<T>())?;
+
+        // SAFETY:
+        // - `ptr` is a valid, non-null pointer as it was just returned by the
+        //   cache.
+        // - The initializer is infallible, so an error is never returned.
+        unsafe { T::init().__init(ptr.as_ptr()) }.expect("Initializer is infallible");
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
+/// An `SBox` holds a reference to the [`KMemCache`] it was allocated from.
+/// Dropping the `SBox` may thus drop the last reference to the cache and
+/// destroy the cache, which may sleep. See the `# Context` section of
+/// [`KMemCache`].
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
+// SAFETY: `SBox<T>` owns a `T`. Sheaf allocated objects are ordinary slab
+// objects that may be freed from any thread, so an `SBox<T>` may be sent to
+// another thread if `T` can.
+unsafe impl<T: KMemCacheInit<T> + Send> Send for SBox<T> {}
+
+// SAFETY: `SBox<T>` has no interior mutability, so sharing `&SBox<T>` between
+// threads only shares `&T`.
+unsafe impl<T: KMemCacheInit<T> + Sync> Sync for SBox<T> {}
+
+impl<T: KMemCacheInit<T>> Deref for SBox<T> {
+    type Target = T;
+
+    #[inline]
+    fn deref(&self) -> &Self::Target {
+        // SAFETY: `ptr` is valid and properly aligned per the type invariants.
+        unsafe { self.ptr.as_ref() }
+    }
+}
+
+impl<T: KMemCacheInit<T>> DerefMut for SBox<T> {
+    #[inline]
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



