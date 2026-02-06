Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D27BEE6B5E
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 21:12:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 77B396B0099; Fri,  6 Feb 2026 16:11:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 731DD6B009B; Fri,  6 Feb 2026 16:11:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 627A96B009D; Fri,  6 Feb 2026 16:11:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4BC746B0099
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 16:11:59 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 24009B833B
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 21:11:59 +0000 (UTC)
X-FDA: 84415279158.20.F089E54
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 3C8A91C0004
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 21:11:57 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QYuRK1L3;
	spf=pass (imf20.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770412317;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ppHbMqT7emHrFp5+5rmduHjWM8l6EYYzIL7mrzT4Q6M=;
	b=Co5kl+GU2bacZAcQsmO4KuAWl/Ef3xDwBeFW6VphE0u7jcxX+4qsJU7wgqPLiBazJCVng9
	zTK5hJhHW4hOLR/tM7C6+a+MC+3m1UzYjR0YkUOmAU3e1IyCCINlT1ErVbLZ8ytkKP+7sQ
	7s1TDcjXjOlIRyt/HwBHquQi+L6BB/g=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QYuRK1L3;
	spf=pass (imf20.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770412317; a=rsa-sha256;
	cv=none;
	b=moYCC/N9C2KHrFb2kBRQ0Bj1G3MhmvU0UuApyXy2EOLj2PBBM9anrWO78fK0UXRrHvp5bk
	QZaSuZy/uxBKNyyUXmd536458n0+J41o4lo9+LuhnLwgSqYd1b42IcRU6/WOIGosHYin2k
	CmA24LbjCEgN1YpGbL0UekvwxaksJbE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4115F44381;
	Fri,  6 Feb 2026 21:11:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 975CEC116C6;
	Fri,  6 Feb 2026 21:11:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770412316;
	bh=yDktjoOvxUj5UzZCRZYJztqCsy8J1BqG4VuAbKzhGVM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=QYuRK1L3VHaNyOyxJ2zyBeowLDBfuXpuxz9w1TFXWWhcRd0T/qinNnrDJUHG2j7XM
	 lv09TXjQIOF15GtPyMSFsHA625gMUdQLXeKPMuqkomkkywNsGoHFsNo3PCYC/g7Fbd
	 7IhEtmaRqsgUUboVe3TfYEvTbLdvPWbSEWBon3C18RpFQ6t3mQTKupXB004TYLmTX5
	 VCY36Jc9VVbARvBjR+rgIba8qrPvT9oiJ95Yp6ewPifjsHEc+vmxn4OutNJWW0Eijf
	 VQa2yWubU14qJ0/3qHdmGH2BgwTaqcXASbXTBh/Sr2CEbwS5i+h3PoKr4uRuSkuQc7
	 XMMJ5V0krH2ug==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Fri, 06 Feb 2026 22:10:56 +0100
Subject: [PATCH v2 10/11] rust: mm: sheaf: allow use of C initialized
 static caches
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260206-xarray-entry-send-v2-10-91c41673fd30@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=21503;
 i=a.hindborg@kernel.org; h=from:subject:message-id;
 bh=yDktjoOvxUj5UzZCRZYJztqCsy8J1BqG4VuAbKzhGVM=;
 b=owEBbQKS/ZANAwAKAeG4Gj55KGN3AcsmYgBphljqqXLQm4Ui2fm/F6g9svnOtGV2NsNdN5ysM
 sWS7I1xBnSJAjMEAAEKAB0WIQQSwflHVr98KhXWwBLhuBo+eShjdwUCaYZY6gAKCRDhuBo+eShj
 d+0CD/9025QcoAqR2C6buBG07j9NGla+7qRh9BZ6UcaxA0EoY0EyZpG6S1ZK2O+gsFQtzjtmUN/
 5m83jltkZY6db81CW3loYUGG5ew6T319jWJNRAHBjXsvzLNpvbv/dCcZQxgTcthwlb4KCVaW9yu
 bG3zCr5yBTo1hfYnn8CkZ6nI4p+CXmcJXgjrPuiOPO4f7+MKAYEfufz7aksZingeXS8E+X6KDRz
 FHGK7RIzc0IX3x1JLvrYPDZcU4QVGUMvaKJxMKkLYDmKh8tFasMZ3iBTkOYZAsgEGFY8QmCIctT
 8AIG0iTL5H5XAOVmMUcHloS4P4lrlo0fL+4GlhlUYbPJrHmi3uSdsr27RIZb87a0hyN4IIBjsPc
 GiN2fJ4tIISN7WLdcoPQJysZq5SKgqhHeHwPg2eKgZY+0D+RiXA5eK32C6wM3payqUCRHkuaB9X
 5BpygRvMnwEquQX6ecAABGyL3faxc6v7Au0CY/vjML3Pa6GrIlKThKNkI/EM98rz01fWVVzlBZN
 AMbG1gMcKsBfkW8u00ZIChWLUhiQs5zChW7Bw4xy3vmQFF0fwRJgta5hBldAyq9o9G2iCk8UJ7I
 5Q19TXoYepiJd+owPGFuMqGaECnwcyaWPKiy+vnFSPnZ5KGcN8D6uZ8n0C8zg69p7yUKSZERsWK
 vRTmCN8xgrfMyrQ==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 3C8A91C0004
X-Stat-Signature: kam5cqiga1g9xxja4bdd198c5gcmiapr
X-Rspam-User: 
X-HE-Tag: 1770412317-943427
X-HE-Meta: U2FsdGVkX19Kjy8KXfpsoEthMKs1j/6lvN3aWnQ7NRLF0J/a2uG4m74Jxu3d2Mz/KgkLMAigfVaYR1PDDl6F5lZvvLD5CU5f5cU1buRVpYkNUyHsWFGINsKMjrjIo6fmDA1eoeKpuMnjxa219VhJffbtBk59+RJpze8XcwMZ3RAqXOy8NPqNglLFXPt8SMsyT356OsBHtqScG4+wAPaC9g1VCublKfKQRyZ7qCH89ozUpfFyLWY5mk+ILZydjSPCHTDHlEWeA3EzMpPZrGJ3vzI2jpst7cO5iNWqWy1FAoOiWiO9dSdSelYzLxW1V0h5B0PZ+gKR2VcGZtJtHOIDgZ+j8FvPg6FS5qKX5BGKPjlchmUd2O4hBv2a/7lZe/UziX3ljP7+UyRDY6vNwsFjeamNnur5KI6nnvGWzkMTFGEbIMRxr59zOetcCcUDZMJuVNMavGqdP4pb2f0TvvozLHpufoaYGtSTGodbcZVx8abXEXAAnyZTyTRgzdDZLX2Gu+twgbpxr6ArPhvgJm/U7lxsCZNGiAyMBvk8dJl/2WbnUD15lS/+mzqjaEgNoCtFk0pYfCBiVGq6/iKqo646QjEO2cRKYagnCY1iHWvxvO/djXhfDZVqqS84Ntg+FDNhaVi1k8gaSH4ujeVk95pkpCW9Mv4gXS3b/IRtilLP2aqFcWLR8A9U5xqjL3cO/bu+ncjC8eyMAvXZc3qoqAvgu7wbOCMHrtDUi9/uGmZ5dXPFGE0jvILLXWFGTYaH3j2bAecVpHvnX9CqCYXc5PecA0mS24tmUBnvoziMd+985Zm/tAVHluAQSkYt4O3w4sVbtHViQQ+TE/PLG7kWAyDYFQDM3u+C+jq2cnmW01Ode4zdrx4IZfP9313GtRbvj5pVJQZEGpC3OGuRGtgaDNRUYFgUhuEm91csV13lf/uOfBpgGKcqr7k2bhu2L1NOb60oqkw3eH87fybX3WgMffN
 XKvvKLxH
 zgp+VWPcJwF2Vih5d1vDr9qhFLYNKNqm673U26W1O8sKQmnE6nylcredaULpVFwyv+JvjYZKG3BSL3W7gOtfj1x7yS0sSJ50aET9X/9vrApD99DcTj0WhSzKCVMVvHmpgI4ityYt8sptfciaehEyl52KAhP2Xemmy+vXe5Q0NivqEngGbRi4Kdf9InzXIpaue64tXOHWRSXLM+iYT3iGs2GHTwseYGqNPn2fhExMrZoJf+OUVpMlAQmh1jV9+2cJaAt7ZGSsFm4gnX6k0CMrz5xiy+uKlEvMocPdCwT/jwXDQYC2sx5sIbPVhD+OCzqgFF3U28QTh5/S6c/fUyAKUTllmPqP0mUDx/zjeWIg7OFs32uq769dUi51ep2OqGCEd7tsbuMbjiE4qsk0CpIA4jZudG8y4+fR5OzA8
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extend the sheaf abstraction to support caches initialized by C at kernel
boot time, in addition to dynamically created Rust caches.

Introduce `KMemCache<T>` as a transparent wrapper around `kmem_cache` for
static caches with `'static` lifetime. Rename the previous `KMemCache<T>`
to `KMemCacheHandle<T>` to represent dynamically created, reference-counted
caches.

Add `Static` and `Dynamic` marker types along with `StaticSheaf` and
`DynamicSheaf` type aliases to distinguish sheaves from each cache type.
The `Sheaf` type now carries lifetime and allocation mode type parameters.

Add `SBox::into_ptr()` and `SBox::static_from_ptr()` methods for passing
allocations through C code via raw pointers.

Add `KMemCache::from_raw()` for wrapping C-initialized static caches and
`Sheaf::refill()` for replenishing a sheaf to a minimum size.

Export `kmem_cache_prefill_sheaf`, `kmem_cache_return_sheaf`,
`kmem_cache_refill_sheaf`, and `kmem_cache_alloc_from_sheaf_noprof` to
allow Rust module code to use the sheaf API.

Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: linux-mm@kvack.org
Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 mm/slub.c               |   4 +
 rust/kernel/mm/sheaf.rs | 343 +++++++++++++++++++++++++++++++++++++++++++-----
 2 files changed, 317 insertions(+), 30 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index f77b7407c51bc..7c6b1d28778d0 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -5428,6 +5428,7 @@ kmem_cache_prefill_sheaf(struct kmem_cache *s, gfp_t gfp, unsigned int size)
 
 	return sheaf;
 }
+EXPORT_SYMBOL(kmem_cache_prefill_sheaf);
 
 /*
  * Use this to return a sheaf obtained by kmem_cache_prefill_sheaf()
@@ -5483,6 +5484,7 @@ void kmem_cache_return_sheaf(struct kmem_cache *s, gfp_t gfp,
 	barn_put_full_sheaf(barn, sheaf);
 	stat(s, BARN_PUT);
 }
+EXPORT_SYMBOL(kmem_cache_return_sheaf);
 
 /*
  * refill a sheaf previously returned by kmem_cache_prefill_sheaf to at least
@@ -5536,6 +5538,7 @@ int kmem_cache_refill_sheaf(struct kmem_cache *s, gfp_t gfp,
 	*sheafp = sheaf;
 	return 0;
 }
+EXPORT_SYMBOL(kmem_cache_refill_sheaf);
 
 /*
  * Allocate from a sheaf obtained by kmem_cache_prefill_sheaf()
@@ -5573,6 +5576,7 @@ kmem_cache_alloc_from_sheaf_noprof(struct kmem_cache *s, gfp_t gfp,
 
 	return ret;
 }
+EXPORT_SYMBOL(kmem_cache_alloc_from_sheaf_noprof);
 
 unsigned int kmem_cache_sheaf_size(struct slab_sheaf *sheaf)
 {
diff --git a/rust/kernel/mm/sheaf.rs b/rust/kernel/mm/sheaf.rs
index c92750eaf1c4a..a604246714f7b 100644
--- a/rust/kernel/mm/sheaf.rs
+++ b/rust/kernel/mm/sheaf.rs
@@ -23,17 +23,26 @@
 //!
 //! # Architecture
 //!
-//! The sheaf system consists of three main components:
+//! The sheaf system supports two modes of operation:
+//!
+//! - **Static caches**: [`KMemCache`] represents a cache initialized by C code at
+//!   kernel boot time. These have `'static` lifetime and produce [`StaticSheaf`]
+//!   instances.
+//! - **Dynamic caches**: [`KMemCacheHandle`] wraps a cache created at runtime by
+//!   Rust code. These are reference-counted and produce [`DynamicSheaf`] instances.
+//!
+//! Both modes use the same core types:
 //!
-//! - [`KMemCache`]: A slab cache configured with sheaf support.
 //! - [`Sheaf`]: A pre-filled container of objects from a specific cache.
 //! - [`SBox`]: An owned allocation from a sheaf, similar to a `Box`.
 //!
 //! # Example
 //!
+//! Using a dynamically created cache:
+//!
 //! ```
 //! use kernel::c_str;
-//! use kernel::mm::sheaf::{KMemCache, KMemCacheInit, Sheaf, SBox};
+//! use kernel::mm::sheaf::{KMemCacheHandle, KMemCacheInit, Sheaf, SBox};
 //! use kernel::prelude::*;
 //!
 //! struct MyObject {
@@ -47,7 +56,7 @@
 //! }
 //!
 //! // Create a cache with sheaf capacity of 16 objects.
-//! let cache = KMemCache::<MyObject>::new(c_str!("my_cache"), 16)?;
+//! let cache = KMemCacheHandle::<MyObject>::new(c_str!("my_cache"), 16)?;
 //!
 //! // Pre-fill a sheaf with 8 objects.
 //! let mut sheaf = cache.as_arc_borrow().sheaf(8, GFP_KERNEL)?;
@@ -75,7 +84,102 @@
 
 use kernel::prelude::*;
 
-use crate::sync::{Arc, ArcBorrow};
+use crate::{
+    sync::{Arc, ArcBorrow},
+    types::Opaque,
+};
+
+/// A slab cache with sheaf support.
+///
+/// This type is a transparent wrapper around a kernel `kmem_cache`. It can be
+/// used with caches created either by C code or via [`KMemCacheHandle`].
+///
+/// When a reference to this type has `'static` lifetime (i.e., `&'static
+/// KMemCache<T>`), it typically represents a cache initialized by C at boot
+/// time. Such references produce [`StaticSheaf`] instances via [`sheaf`].
+///
+/// [`sheaf`]: KMemCache::sheaf
+///
+/// # Type parameter
+///
+/// - `T`: The type of objects managed by this cache. Must implement
+///   [`KMemCacheInit`] to provide initialization logic for allocations.
+#[repr(transparent)]
+pub struct KMemCache<T: KMemCacheInit<T>> {
+    inner: Opaque<bindings::kmem_cache>,
+    _p: PhantomData<T>,
+}
+
+impl<T: KMemCacheInit<T>> KMemCache<T> {
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
+        &'static self,
+        size: usize,
+        gfp: kernel::alloc::Flags,
+    ) -> Result<Sheaf<'static, T, Static>> {
+        // SAFETY: `self.as_raw()` returns a valid cache pointer, and `size`
+        // has been validated to fit in a `c_uint`.
+        let ptr = unsafe {
+            bindings::kmem_cache_prefill_sheaf(self.inner.get(), gfp.as_raw(), size.try_into()?)
+        };
+
+        // INVARIANT: `ptr` was returned by `kmem_cache_prefill_sheaf` and is
+        // non-null (checked below). `cache` is the cache from which this sheaf
+        // was created. `dropped` is false since the sheaf has not been returned.
+        Ok(Sheaf {
+            sheaf: NonNull::new(ptr).ok_or(ENOMEM)?,
+            // SAFETY: `self` is a valid reference, so the pointer is non-null.
+            cache: CacheRef::Static(unsafe {
+                NonNull::new_unchecked((&raw const *self).cast_mut())
+            }),
+            dropped: false,
+            _p: PhantomData,
+        })
+    }
+
+    fn as_raw(&self) -> *mut bindings::kmem_cache {
+        self.inner.get()
+    }
+
+    /// Creates a reference to a [`KMemCache`] from a raw pointer.
+    ///
+    /// This is useful for wrapping a C-initialized static `kmem_cache`, such as
+    /// the global `radix_tree_node_cachep` used by XArrays.
+    ///
+    /// # Safety
+    ///
+    /// - `ptr` must be a valid pointer to a `kmem_cache` that was created for
+    ///   objects of type `T`.
+    /// - The cache must remain valid for the lifetime `'a`.
+    /// - The caller must ensure that the cache was configured appropriately for
+    ///   the type `T`, including proper size and alignment.
+    pub unsafe fn from_raw<'a>(ptr: *mut bindings::kmem_cache) -> &'a Self {
+        // SAFETY: The caller guarantees that `ptr` is a valid pointer to a
+        // `kmem_cache` created for objects of type `T`, that it remains valid
+        // for lifetime `'a`, and that the cache is properly configured for `T`.
+        unsafe { &*ptr.cast::<Self>() }
+    }
+}
 
 /// A slab cache with sheaf support.
 ///
@@ -94,12 +198,12 @@
 /// - `cache` is a valid pointer to a `kmem_cache` created with
 ///   `__kmem_cache_create_args`.
 /// - The cache is valid for the lifetime of this struct.
-pub struct KMemCache<T: KMemCacheInit<T>> {
-    cache: NonNull<bindings::kmem_cache>,
-    _p: PhantomData<T>,
+#[repr(transparent)]
+pub struct KMemCacheHandle<T: KMemCacheInit<T>> {
+    cache: NonNull<KMemCache<T>>,
 }
 
-impl<T: KMemCacheInit<T>> KMemCache<T> {
+impl<T: KMemCacheInit<T>> KMemCacheHandle<T> {
     /// Creates a new slab cache with sheaf support.
     ///
     /// Creates a kernel slab cache for objects of type `T` with the specified
@@ -147,8 +251,7 @@ pub fn new(name: &CStr, sheaf_capacity: u32) -> Result<Arc<Self>>
         // `kmem_cache_destroy` is called in `Drop`.
         Ok(Arc::new(
             Self {
-                cache: NonNull::new(ptr).ok_or(ENOMEM)?,
-                _p: PhantomData,
+                cache: NonNull::new(ptr.cast()).ok_or(ENOMEM)?,
             },
             GFP_KERNEL,
         )?)
@@ -175,11 +278,11 @@ pub fn new(name: &CStr, sheaf_capacity: u32) -> Result<Arc<Self>>
     /// # Warnings
     ///
     /// The kernel will warn if `size` exceeds `sheaf_capacity`.
-    pub fn sheaf(
-        self: ArcBorrow<'_, Self>,
+    pub fn sheaf<'a>(
+        self: ArcBorrow<'a, Self>,
         size: usize,
         gfp: kernel::alloc::Flags,
-    ) -> Result<Sheaf<T>> {
+    ) -> Result<Sheaf<'a, T, Dynamic>> {
         // SAFETY: `self.as_raw()` returns a valid cache pointer, and `size`
         // has been validated to fit in a `c_uint`.
         let ptr = unsafe {
@@ -191,17 +294,18 @@ pub fn sheaf(
         // was created. `dropped` is false since the sheaf has not been returned.
         Ok(Sheaf {
             sheaf: NonNull::new(ptr).ok_or(ENOMEM)?,
-            cache: self.into(),
+            cache: CacheRef::Arc(self.into()),
             dropped: false,
+            _p: PhantomData,
         })
     }
 
     fn as_raw(&self) -> *mut bindings::kmem_cache {
-        self.cache.as_ptr()
+        self.cache.as_ptr().cast()
     }
 }
 
-impl<T: KMemCacheInit<T>> Drop for KMemCache<T> {
+impl<T: KMemCacheInit<T>> Drop for KMemCacheHandle<T> {
     fn drop(&mut self) {
         // SAFETY: `self.as_raw()` returns a valid cache pointer that was
         // created by `__kmem_cache_create_args`. As all objects allocated from
@@ -214,13 +318,13 @@ fn drop(&mut self) {
 /// Trait for types that can be initialized in a slab cache.
 ///
 /// This trait provides the initialization logic for objects allocated from a
-/// [`KMemCache`]. When the slab allocator creates new objects, it invokes the
-/// constructor to ensure objects are in a valid initial state.
+/// [`KMemCache`]. The initializer is called when objects are allocated from a
+/// sheaf via [`Sheaf::alloc`].
 ///
 /// # Implementation
 ///
-/// Implementors must provide [`init`](KMemCacheInit::init), which returns
-/// a in-place initializer for the type.
+/// Implementors must provide [`init`](KMemCacheInit::init), which returns an
+/// infallible initializer for the type.
 ///
 /// # Example
 ///
@@ -251,6 +355,28 @@ pub trait KMemCacheInit<T> {
     fn init() -> impl Init<T, Infallible>;
 }
 
+/// Marker type for sheaves from static caches.
+///
+/// Used as a type parameter for [`Sheaf`] to indicate the sheaf was created
+/// from a `&'static KMemCache<T>`.
+pub enum Static {}
+
+/// Marker type for sheaves from dynamic caches.
+///
+/// Used as a type parameter for [`Sheaf`] to indicate the sheaf was created
+/// from a [`KMemCacheHandle`] via [`ArcBorrow`].
+pub enum Dynamic {}
+
+/// A sheaf from a static cache.
+///
+/// This is a [`Sheaf`] backed by a `&'static KMemCache<T>`.
+pub type StaticSheaf<'a, T> = Sheaf<'a, T, Static>;
+
+/// A sheaf from a dynamic cache.
+///
+/// This is a [`Sheaf`] backed by a reference-counted [`KMemCacheHandle`].
+pub type DynamicSheaf<'a, T> = Sheaf<'a, T, Dynamic>;
+
 /// A pre-filled container of slab objects.
 ///
 /// A sheaf holds a set of pre-allocated objects from a [`KMemCache`].
@@ -261,12 +387,23 @@ pub trait KMemCacheInit<T> {
 /// Sheaves provide faster allocation than direct allocation because they use
 /// local locks with preemption disabled rather than atomic operations.
 ///
+/// # Type parameters
+///
+/// - `'a`: The lifetime of the cache reference.
+/// - `T`: The type of objects in this sheaf.
+/// - `A`: Either [`Static`] or [`Dynamic`], indicating whether the backing
+///   cache is a static reference or a reference-counted handle.
+///
+/// For convenience, [`StaticSheaf`] and [`DynamicSheaf`] type aliases are
+/// provided.
+///
 /// # Lifecycle
 ///
-/// Sheaves are created via [`KMemCache::sheaf`] and should be returned to the
-/// allocator when no longer needed via [`Sheaf::return_refill`]. If a sheaf is
-/// simply dropped, it is returned with `GFP_NOWAIT` flags, which may result in
-/// the sheaf being flushed and freed rather than being cached for reuse.
+/// Sheaves are created via [`KMemCache::sheaf`] or [`KMemCacheHandle::sheaf`]
+/// and should be returned to the allocator when no longer needed via
+/// [`Sheaf::return_refill`]. If a sheaf is simply dropped, it is returned with
+/// `GFP_NOWAIT` flags, which may result in the sheaf being flushed and freed
+/// rather than being cached for reuse.
 ///
 /// # Invariants
 ///
@@ -274,13 +411,14 @@ pub trait KMemCacheInit<T> {
 ///   `kmem_cache_prefill_sheaf`.
 /// - `cache` is the cache from which this sheaf was created.
 /// - `dropped` tracks whether the sheaf has been explicitly returned.
-pub struct Sheaf<T: KMemCacheInit<T>> {
+pub struct Sheaf<'a, T: KMemCacheInit<T>, A> {
     sheaf: NonNull<bindings::slab_sheaf>,
-    cache: Arc<KMemCache<T>>,
+    cache: CacheRef<T>,
     dropped: bool,
+    _p: PhantomData<(&'a KMemCache<T>, A)>,
 }
 
-impl<T: KMemCacheInit<T>> Sheaf<T> {
+impl<'a, T: KMemCacheInit<T>, A> Sheaf<'a, T, A> {
     fn as_raw(&self) -> *mut bindings::slab_sheaf {
         self.sheaf.as_ptr()
     }
@@ -303,6 +441,75 @@ pub fn return_refill(mut self, flags: kernel::alloc::Flags) {
         drop(self);
     }
 
+    /// Refills the sheaf to at least the specified size.
+    ///
+    /// Replenishes the sheaf by preallocating objects until it contains at
+    /// least `size` objects. If the sheaf already contains `size` or more
+    /// objects, this is a no-op. In practice, the sheaf is refilled to its
+    /// full capacity.
+    ///
+    /// # Arguments
+    ///
+    /// - `flags`: Allocation flags controlling how memory is obtained.
+    /// - `size`: The minimum number of objects the sheaf should contain after
+    ///   refilling. If `size` exceeds the cache's `sheaf_capacity`, the sheaf
+    ///   may be replaced with a larger one.
+    ///
+    /// # Errors
+    ///
+    /// Returns an error if the objects could not be allocated. If refilling
+    /// fails, the existing sheaf is left intact.
+    pub fn refill(&mut self, flags: kernel::alloc::Flags, size: usize) -> Result {
+        // SAFETY: `self.cache.as_raw()` returns a valid cache pointer and
+        // `&raw mut self.sheaf` points to a valid sheaf per the type invariants.
+        kernel::error::to_result(unsafe {
+            bindings::kmem_cache_refill_sheaf(
+                self.cache.as_raw(),
+                flags.as_raw(),
+                (&raw mut (self.sheaf)).cast(),
+                size.try_into()?,
+            )
+        })
+    }
+}
+
+impl<'a, T: KMemCacheInit<T>> Sheaf<'a, T, Static> {
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
+impl<'a, T: KMemCacheInit<T>> Sheaf<'a, T, Dynamic> {
     /// Allocates an object from the sheaf.
     ///
     /// Returns a new [`SBox`] containing an initialized object, or [`None`]
@@ -338,7 +545,7 @@ pub fn alloc(&mut self) -> Option<SBox<T>> {
     }
 }
 
-impl<T: KMemCacheInit<T>> Drop for Sheaf<T> {
+impl<'a, T: KMemCacheInit<T>, A> Drop for Sheaf<'a, T, A> {
     fn drop(&mut self) {
         if !self.dropped {
             // SAFETY: `self.cache.as_raw()` and `self.as_raw()` return valid
@@ -355,6 +562,39 @@ fn drop(&mut self) {
     }
 }
 
+/// Internal reference to a cache, either static or reference-counted.
+///
+/// # Invariants
+///
+/// - For `CacheRef::Static`: the `NonNull` points to a valid `KMemCache<T>`
+///   with `'static` lifetime, derived from a `&'static KMemCache<T>` reference.
+enum CacheRef<T: KMemCacheInit<T>> {
+    /// A reference-counted handle to a dynamically created cache.
+    Arc(Arc<KMemCacheHandle<T>>),
+    /// A pointer to a static lifetime cache.
+    Static(NonNull<KMemCache<T>>),
+}
+
+impl<T: KMemCacheInit<T>> Clone for CacheRef<T> {
+    fn clone(&self) -> Self {
+        match self {
+            Self::Arc(arg0) => Self::Arc(arg0.clone()),
+            Self::Static(arg0) => Self::Static(*arg0),
+        }
+    }
+}
+
+impl<T: KMemCacheInit<T>> CacheRef<T> {
+    fn as_raw(&self) -> *mut bindings::kmem_cache {
+        match self {
+            CacheRef::Arc(handle) => handle.as_raw(),
+            // SAFETY: By type invariant, `ptr` points to a valid `KMemCache<T>`
+            // with `'static` lifetime.
+            CacheRef::Static(ptr) => unsafe { ptr.as_ref() }.as_raw(),
+        }
+    }
+}
+
 /// An owned allocation from a cache sheaf.
 ///
 /// `SBox` is similar to `Box` but is backed by a slab cache allocation obtained
@@ -371,7 +611,50 @@ fn drop(&mut self) {
 /// - The object remains valid for the lifetime of the `SBox`.
 pub struct SBox<T: KMemCacheInit<T>> {
     ptr: NonNull<T>,
-    cache: Arc<KMemCache<T>>,
+    cache: CacheRef<T>,
+}
+
+impl<T: KMemCacheInit<T>> SBox<T> {
+    /// Consumes the `SBox` and returns the raw pointer to the contained value.
+    ///
+    /// The caller becomes responsible for freeing the memory. The object is not
+    /// dropped and remains initialized. Use [`static_from_ptr`] to reconstruct
+    /// an `SBox` from the pointer.
+    ///
+    /// [`static_from_ptr`]: SBox::static_from_ptr
+    pub fn into_ptr(self) -> *mut T {
+        let ptr = self.ptr.as_ptr();
+        core::mem::forget(self);
+        ptr
+    }
+
+    /// Reconstructs an `SBox` from a raw pointer and cache.
+    ///
+    /// This is intended for use with objects that were previously converted to
+    /// raw pointers via [`into_ptr`], typically for passing through C code.
+    ///
+    /// [`into_ptr`]: SBox::into_ptr
+    ///
+    /// # Safety
+    ///
+    /// - `cache` must be a valid pointer to the `kmem_cache` from which `value`
+    ///   was allocated.
+    /// - `value` must be a valid pointer to an initialized `T` that was
+    ///   allocated from `cache`.
+    /// - The caller must ensure that no other `SBox` or reference exists for
+    ///   `value`.
+    pub unsafe fn static_from_ptr(cache: *mut bindings::kmem_cache, value: *mut T) -> Self {
+        // INVARIANT: The caller guarantees `value` points to a valid,
+        // initialized `T` allocated from `cache`.
+        Self {
+            // SAFETY: By function safety requirements, `value` is not null.
+            ptr: unsafe { NonNull::new_unchecked(value) },
+            cache: CacheRef::Static(
+                // SAFETY: By function safety requirements, `cache` is not null.
+                unsafe { NonNull::new_unchecked(cache.cast()) },
+            ),
+        }
+    }
 }
 
 impl<T: KMemCacheInit<T>> Deref for SBox<T> {

-- 
2.51.2



