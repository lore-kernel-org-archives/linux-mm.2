Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36F9CCD6E6E
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 19:59:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 512CC6B0005; Thu,  4 Jun 2026 15:59:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C38E6B0088; Thu,  4 Jun 2026 15:59:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B2A06B008A; Thu,  4 Jun 2026 15:59:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 27B516B0005
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 15:59:33 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CB0F91202AC
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 19:59:32 +0000 (UTC)
X-FDA: 84843294984.25.2C9DF92
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id E2320160002
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 19:59:30 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Xvg0uI4y;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780603171;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HkrPB3YSV5eoOFoyhfAfX4Z/mUMvl7lJVOyi27h88P0=;
	b=vyVHyU1ol1BicVYqfLid9WnycHUJO4PFRQh2s+S+VHTgzOGkirZ/sDFU87tlLkSpIuZjD4
	ApiDvlFkgFlQr11DEvP2Zwkn6Sgh9ogc3G0a/fKwb8PUSlYC42sQdYx7pvhPqdPMPDyeRl
	Wr83E7k6llK3U5SXc/ELVKags7ftdgk=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Xvg0uI4y;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780603171;
	b=TJOfjpOYSvHXm9Da2yHx+Cjlax2hknAcnFnNyHmNGfQW2gdEpi3tDeE5eBpyMGmdiAnRN7
	g3ofelkPWLmK+KKADoI+kkotDaBt3C/LbURlefMLWpXG/8yLVprgJE7l1mhKIjBpCFDKc7
	mheNLc6/TbPwuda6XpioIBKQ7QdFpnQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CA605403EF;
	Thu,  4 Jun 2026 19:59:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC1241F00893;
	Thu,  4 Jun 2026 19:59:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780603169;
	bh=HkrPB3YSV5eoOFoyhfAfX4Z/mUMvl7lJVOyi27h88P0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Xvg0uI4yPw6dAeAd1KVMxqccdfEKlCn1/n5arQlO8nEPUDH8u7UqR9ghH/2PeGv+r
	 qEfEFG9BYEKz6p3dipOvSO/W0pGjwtRUCS2++6rb7NZjbIR8QViJYpM1ZjvhBYHLKR
	 eqW2UnZt+Xm0qEzAJX+4K8UbqY0itnJNK6UQBCCn67E93k28mbZJ4OSi1OA7wI1col
	 oBvtYzm5eMyZjH7bo8CYPS6r52xU5OsozrDZGRLME6JOe4Mbmo3y8Uw+AVRK98fifU
	 yyR0iJ1d3/+2vl5N90alJpzxFwA7NWtr3kSYtGFOUqrMdyUe75DhAmQwgiVc56m+Gm
	 O+oZ5eAygN60A==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Thu, 04 Jun 2026 21:58:14 +0200
Subject: [PATCH v4 08/11] rust: mm: add abstractions for allocating from a
 `sheaf`
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260604-xarray-entry-send-v4-8-965f6028790e@kernel.org>
References: <20260604-xarray-entry-send-v4-0-965f6028790e@kernel.org>
In-Reply-To: <20260604-xarray-entry-send-v4-0-965f6028790e@kernel.org>
To: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
 Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Benno Lossin <lossin@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
 Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Tamir Duberstein <tamird@kernel.org>, Boqun Feng <boqun@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>, 
 Hao Li <hao.li@linux.dev>, Tamir Duberstein <tamird@kernel.org>, 
 Boqun Feng <boqun@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Harry Yoo <harry@kernel.org>
Cc: Daniel Gomez <da.gomez@kernel.org>, rust-for-linux@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 Andreas Hindborg <a.hindborg@kernel.org>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=16725;
 i=a.hindborg@kernel.org; h=from:subject:message-id;
 bh=viLP6+3hpO8mvWihp4DUk3gqlSHe9yjJWhzRprF92ok=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBqIdjwZfTi7enAUEzhtZXOHEZYr5m9Nt438lwNU
 VMFyGhts7yJAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCaiHY8AAKCRD6UCkIqsW9
 0GU7EACirZDEMZs6fIt/24kf/2CBcsMDTt+Qdsk1uNoEQxOdA7ABsHbpu83iwz3IyTQOtBrRcDk
 +QoNEx+h5dGozUYlbEnTTBzQMYVRLdJfJ5k38uoolzf/2ATvetpoPCDN5upxezVuxev6RsBbn9g
 hovzXCL/Y/ff1NfsPTM61C7B0tGI4d1AFJh1EZppxvGGS3JlOtcvguLchPkZwiairkgGvrQrnL7
 HtjpoMmgkdpgNbPjUjn9HE8BN+dYpVAuw7CVox90PVtp4kf2D/AMgYzNrQqmurCbfWrwlotDUb8
 hYN8awj8YzcAdfPjW+nQpQ4sxXCVAMr4A+3vv1xHpOa0Q4VI7UW0t5FOf4njnFtNFH04vjDttes
 tVp+BHeyc2Z4tpNL3tPRNYvDhftihFb6Y/J3pa4ezo6pamGYMLCiXBTx9LxITFxBUkZawS23wKf
 hE6N4irm3VpTOj9BDc0e0PoNVfRUn+ReJhGs+jwIb4AuSLCjAJnxH+Fd1j5D9CkjHo9bZwIzQXi
 P6TaHogbHIGaRH5/gc5ay8Qb04IDMe7IEKEhyV2qNcUnU5LNXYO4VzqRcLgMfLO/RkOkUvfB+OS
 347z8fQ8FU8pIaC5XwyxpdHjgsF5Po5DNNO9EQ1VcWuh43Umoi0LxbDvQajcTOBmgO6rbcCYpCY
 cu+X3R/SO5m/5Tw==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: 85gsgf4yp71trrs6uriepdhcx5fcmkjx
X-Rspamd-Queue-Id: E2320160002
X-HE-Tag: 1780603170-616341
X-HE-Meta: U2FsdGVkX19BFYE5Oovu1YnojGEwF5XTmdeRX1tg3fMXtHl6rO+/lviGrO/Qh/0xojKSyZytYxavBYZtj/SU4VJ+deP8cFXSLp9ubDwenE+t+pnAX9G5L0PIe8gEFlUsPt9aAA9djLYUnh2jFDN0Wz2qYv3dLQcxlXwH1fDH0SAc7a50vGF4IoRRnS44SdB0VVpWPTNXp1k+bn5lwEC1fuH5MB2yBOVtAO8a2MqRihikmv4+R7ON6f6UiRMSLE3DoNwizJMWcrEzCh2i6nbBir/0/Bv1bIearRXPDxZjruMfMjv9NgI5Mt4Iu6R2wzQxcnu6jyiqLcvkVEoU7tP0vxgq6exfuaoPDr7OM3oNckKg0sq+3DmlMLDy1dnF3/oqsvDo7IeN1xOvoc2Z3Io9w1l4pGygYn5PZey8AkSVKXTHKZSAAmHZQK/h4J4rEywwQPve5EX/oUKkagxnjX+ZKsDfSAml/qGLs2Q+Cv7Lq0+/iwATt74D7ixOKGmfeGDacE0ygfdTi1IU+g4O98E96Bt4c7ZRSYyTL2kbLTGIw0mx1788xWZn64ne2hdXboa+25qHtr03GN6OEb+IsRfDS/Ku9x3PPqGg4GRBXkWWPvLL7cIW4DVHWNXNvSdz6GFWbpeTDlCuaIkhc7IF4Hh24+bCBEjRGuFQI/R5/eJHSUSBySkEtckxTtRz3lbvlhBTT33vtBblK9aKAcnhuR3s/oLY8ojLyboEU2fvNNTXjW7uFbmjq/5BzxacAsPr8tuSrND2uqA5DWe2tQj1vghc1s6x1JWQBsE0yNqpxYCCwEDV/BV/CzbBL4xbiZa6dUqgwJvqj3WDcy8CcExSaK2IjCJJ3QUc1fCO6KME+9ptyHBIEk7E8cV6AZr7Q7/IIRfVgT23It6M0DsCCXARu9ZwJea9dETF+Vug2Ub+q8vtjRLbI+FHSl5qKCkwbZSuQXC0MexnxyHOKKhws8tE6kR
 sRVs6jT7
 wQY/n7W+I/rXhcdjLfcYYPGRNkgrN3SaG+J4PFV+vP74swcqbaHrMxsyN/mWoZMkqm2wCH78yvzPw44hsO46P/CGFr80NJS6EkUIur31juCGqgGiL/TIu7RnxZvRLVG4LpVakghJmNJp8pwJh2KxihwzQweZNzGuA2XwVtYe2dlYzV62lQTdhGr5ScR8A1EZorBpVKm28HI0SvyFkMFAw68Y44sweZZodd/kMIE6CI5/LBoZPK04FN0Y9AmgfP0Wk0Vc3LNuxECpedbzh56Z/LSb6Fjt+a3Os+l3K8OqbYSL/1Ae0riR8OL2nfM0CL+yv2daOn+T9GBRyCBqVq5kTh9ABxBB3/jtmH4kMaa/F8HHV7OL+AtRo2HVOD7FMFdskbCgUctmfgdNUBGUUndI4Sa+Q3JL6KBlRZJU2givTw9hwbuybgW9tpgzRK6sSeLL4MvUo1RhVbThRRno=
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
index 4764d7b68f2a..1aa44424b0d5 100644
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
index 000000000000..f23fdaa2dbc3
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



