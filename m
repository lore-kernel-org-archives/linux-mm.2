Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D4C2E81BCB
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 14:39:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF6416B0099; Mon,  9 Feb 2026 09:39:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED7CC6B009B; Mon,  9 Feb 2026 09:39:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DED646B009D; Mon,  9 Feb 2026 09:39:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CD47D6B0099
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 09:39:19 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9473D1B213B
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 14:39:19 +0000 (UTC)
X-FDA: 84425176038.12.A3E6179
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id A19031A0019
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 14:39:17 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iSvHcaO6;
	spf=pass (imf19.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770647957;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sIzwtTK78v2HgiP7AkppmL2kslADxdt0guhKtTTzt5g=;
	b=h2Ygx4bao9mU5tgTu4S2IvlYvUTm1BXUHnSINNZNuKei3nVZtrvB9PxnBT3FGbTZH43FGt
	gGd+d7hHfNxUA/dQjlQWrviozmWvxm0UwPbazd9rppXtRev7IuibKczXNqF3r0o4n9F0IJ
	MBi4piJ+rYavzW5VP5eR1oHfDpfPAIA=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iSvHcaO6;
	spf=pass (imf19.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770647957; a=rsa-sha256;
	cv=none;
	b=GU97qAFWKXvzi7p5ESON6k74jVv0BQx9j4tITM1f1MibApuY5Iu6w0DkO3no/VVmH7kpmj
	4w4coKZp92Itz1z4vsLWKM0fSMPWQD/+/xHBYVKVo4rp50JSa9fzZ+Gm8y21w9QEJhaRmu
	/ZahGWbB2U7BXFMJO0ZBnfE7tzgWanM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BC85740687;
	Mon,  9 Feb 2026 14:39:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A061C16AAE;
	Mon,  9 Feb 2026 14:39:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770647956;
	bh=zWHl+04q+Q7aOEAbamA9+ysRpObfDy8AGvyFnLTXyU4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=iSvHcaO6nOFEO+/hH5VUA/iXZEfVSAlND1h5WXVX4EOCpphGJONC32zFGes6UaH2M
	 DEyR45XMS7NENe8PGHYLjvT7xP3oYY0qlhaB/o7KyBy6DNSu5zwZEPWPScg9to+MCG
	 tgTPhfoZQqVuq5OqfZr0w1smuhrdfkJcVi0u8lJiLMqxlUxVzm6O//O7elBwjv42Im
	 flGrcsIdjWgjw6h03IsmcVsXFfBL0ywAccBAwV8jxXHbE5guXJTkL/W4L+Gzyy64Zi
	 VWEEIwrHDTRQ+6KuepBrK1C75fIf6C91mIXq6lxp7PYkr7kWYkIdUrG02qvKGHux7h
	 s4ZjDGb7CjQ4A==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Mon, 09 Feb 2026 15:38:14 +0100
Subject: [PATCH v3 09/12] rust: mm: add abstractions for allocating from a
 `sheaf`
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260209-xarray-entry-send-v3-9-f777c65b8ae2@kernel.org>
References: <20260209-xarray-entry-send-v3-0-f777c65b8ae2@kernel.org>
In-Reply-To: <20260209-xarray-entry-send-v3-0-f777c65b8ae2@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=16737;
 i=a.hindborg@kernel.org; h=from:subject:message-id;
 bh=zWHl+04q+Q7aOEAbamA9+ysRpObfDy8AGvyFnLTXyU4=;
 b=owEBbQKS/ZANAwAKAeG4Gj55KGN3AcsmYgBpifFcVepVTEYkwpOzWlqjoF2ly/X0G2TUoK1rr
 tAoXoLfavOJAjMEAAEKAB0WIQQSwflHVr98KhXWwBLhuBo+eShjdwUCaYnxXAAKCRDhuBo+eShj
 d49MD/9e1TKVqfiU351/eXktlb+bV8ydHFdGIZBDapOfelWzGSl+zZ5KcPEyckk7AjiBagrZi50
 1LZVJxgL7DL0WAHrl0xkGS//I+l5AEca10X/Q0gh1JF4t6cqoAQ2xeXa8t00zz4EEwzoPDkVr5G
 XVNKCfff9+fCkkmdIjEwbS4J1A04L4tkBgJ6nuhWgi0lCG5XuD8MAM71Wdt5J5XM6fU1PZ9frJG
 l5P+bs3XfhugoktF3lf3pBwTZ0m/xXhdhZgkPbSVJHkU3YD74UrwsYpncxEe9ooTFVIFHww6Sl3
 U27ZbCY7e+CEVO1LT4QJQZ3Qn8Bp8/8tVy971mCCu5UtJi7zkEU1m6ajuJ/PbuverlUmi70gisS
 16GMKWGr0O34TTKFpaYijecjz0U6pTSEYLF6uvPMOxuJZFG7KfsruK1C4bWKtN3p4QtHTelMM0B
 Z1KiLghmVacEjDsHqxktPVzJ86ej0hZHdUu++vVh+IWhXBlvUPFA13gksa1vt+y9PH1RPAPdLbx
 FU1VtfiavI2slGfX6PCd5l6IyEx5dWOCNY5KDqb6GVRW5M1nmyKzvC1b75pmHRNo38DDrdNBOXO
 b/pATT0cXz2SLykFRqj+ATSmbzxYjdYRQwKuM4j30YsLg3eShuy1oxqxndfVasg92pEn2Aa5E99
 uqR0iAtpexRIJMw==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Stat-Signature: 5dybmbtxctm4itikh8hiz4gddjh8kc36
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A19031A0019
X-HE-Tag: 1770647957-574550
X-HE-Meta: U2FsdGVkX1/DBR1p7nlaY1Ivix/5crjIkN3bI+Co/6QJgbd32OX2xNcr0PGOEIjr0f+aiYKCfKqixanwRh8Fj+pVc8kASIKMP3/8ZAaCiaMunfKbm/S9bdGuI61aoBHyEQD4pthWZ1OvBadqlxTAo01rgP51E7USZEt2I7AaGvxLEGwWe3JVJi75FvGcGz+z0daVLRhNotvmvxadXfU/B0qia+cJ39Hnnt/xMdRAZBBo0+nvNDAjXQveIyffh9qUtQLSU+YQ84lNgi2eJWAnUXDWOj+Uasud2JdJCMcRyenJbd3v+a8rHsMtDlWa3E6E3HuE0/EjPD7XBEpNUXRBhwZtK2oLkEgKDjsy10DAH0rUwxQBc0t9p33FksB3sjWpA3Kbpf4TKlzgjgUYILFc4Iai9t1opL4CTi9pDmK5uuqO1IJ74PTBFzx61Cm4vQiE1+qktKgi58j+RtDSptH5WNt3htVBXMz7U39PT16S5B+ijPRdw83VJqHu5GpiN0h2i5OM7/GrxciDybF77ozLxcG32GphXg/BiLFwtc4hwCrUDXco9qc/WbGDmC9zjRH4V8p34FIgfKfgdGpXwdtnqzfbOa22qdiMv1OH2MriMs9QVeRbGbyHr2kekS0FOYM/KFLKAhZ+PSPk+K2cw38ayBEE9ulLDA3Wfu7dUTGZoE0oGVaF2KCKZExVn9OHAYAHO2BnJhog+bi6LK+IRJqhWmvgBtFzOoSfW657pIVa5Ri8Y2ktrkLMP1UgDea77e16KVS5Gf3zfVyPxpRxhNPd9RlpWps9e6DT8XkAJRgCQ590U+gyFQDe+gXtfjZnMoyW5m+/FxD6jQvwYLzLXUeQaVkKankPbeMNWZjPDMFOMPuNp4WN0fgH8WaeIQHV0508JfI63eaEcUuEd1ZG1nUXS27OQI9BP0eH+8ZgIClwOwN1XliYIUo1og3iq9PyB1LESTu+7RWCTRoJkP2dLSF
 B+D5o89N
 PRloNW3Xv/oVikeE7xZXuQNl8S4/BHmRMnWbsZykPNPo5k+6ivx2ldKLf+3W7IbJJlCTmWbUJG2fviZY3Ea7geP217CZnOhVWoKPGyUlTMFZllHyo2TL9lZvRK8p6giu5EXtVsMIdCz7qWthrG/WpnxFHwlgfMI3jw7ZkEw59G//h7CJIlC+mMk6rdr3HsBD0gRb8GmAALfYAno8XyvPtWQv/FD0P4iLfcIrFku/jmu+kanQENL32Xi9mzhaxCYuhUgZz0dkYmMA/A4PqyzIIMpyQ5No1mEJjj4cKk7Gtz3Zo0r+Mhtu09fo7zoyK9H0X0FEtPJQxZvlWet7g9nd9yVf2urMnvU3orN3n/Rt29sjXj9tgrR03KPuyEksS/3yEbmQ5ORAfCoeu3yCTHjuG00g0QrAZUcLLAXyb2jWyfrPuM91BGjZkG9/XwwRdhigg8QpTJ4sUHcZq5lU=
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
 rust/kernel/mm.rs       |   1 +
 rust/kernel/mm/sheaf.rs | 407 ++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 408 insertions(+)

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
index 0000000000000..b8fd321335ace
--- /dev/null
+++ b/rust/kernel/mm/sheaf.rs
@@ -0,0 +1,407 @@
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



