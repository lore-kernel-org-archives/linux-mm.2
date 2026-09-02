Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23CCCC624D3
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 13:27:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0DF7F6B00B6; Wed,  2 Sep 2026 09:27:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0912B6B00B7; Wed,  2 Sep 2026 09:27:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E9A726B00B8; Wed,  2 Sep 2026 09:27:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BC8F06B00B6
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 09:27:22 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 517F8C01E8
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 13:27:22 +0000 (UTC)
X-FDA: 85168898724.23.ED755E4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 7369A40006
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 13:27:20 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SSqE9wxP;
	spf=pass (imf17.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788355640;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Un9ds6+NKCC6oaj+ZnxMv2FssWRr9ogFaViHgOUc1jY=;
	b=05URTKrtsXdbMuKpjw4zeevkVFpsN6/T9yykalwYglIJ6OT8QHQq0axy0EoW/SlAR1fLdv
	ir3xPEKKZvIOGLpsAsc8ewmbyxo/Ein2d5goU47TLx0q5bd11qEOs7wiQwpALnBmKGMwAx
	ukopi6xdi7Nzs0Bswp0cj8p5HgapIl4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788355640;
	b=B8noO16i5j3GLwTP9BxEe25T1rfCIVL7OWJh1IL5eOmB+9f2QpW9TliksuoZ7LDDmqp72h
	Slre7vATKyVMgBjAx+rUe6j7ELc8eO0Js+l8nA9W0rIwbPKZScz4nztO/3hjogMTmwBpft
	hV+XVRXA3ITHVSSvCM6PFIcqAAZjYSw=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SSqE9wxP;
	spf=pass (imf17.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E7412600C8;
	Wed,  2 Sep 2026 13:27:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FA3C1F00A3A;
	Wed,  2 Sep 2026 13:27:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788355639;
	bh=Un9ds6+NKCC6oaj+ZnxMv2FssWRr9ogFaViHgOUc1jY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=SSqE9wxP38nP9gBIp4pO/g3IPIw1XL1Sxhh1NhA3N/XrzabRY0P+vX9fzkCGlsZtj
	 0ZBvEhDk3k5MW9wTyqWV7c4T+Ef3KTjy+8SLl2m39gkT0tXUawBh3fRTGvKyZFLd8n
	 0rt6ee1T4lOld3znaGrM1osxkelBSGuvgcJckmlbkzLJf6+eGNUcUdRpwcicpRFAUs
	 JMRm7h3YpmxUUZxzvM2x8x72ieBvXyMAgWHETNQtWzg1dqfFJCZvpGVnFUsQeK+A0J
	 g8NlvFqBHHCIxrkC/sldU1oKa+rk5DwVexvRt+Ok8pGKKaqRfJsDvuCLkJUpFyNnI1
	 7CUzDckSYkMeQ==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Wed, 02 Sep 2026 15:26:05 +0200
Subject: [PATCH v5 09/12] rust: mm: sheaf: allow use of C initialized
 static caches
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260902-xarray-entry-send-v5-9-d18adae40708@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=26935;
 i=a.hindborg@kernel.org; h=from:subject:message-id;
 bh=hSXv4LMWQCbypjAASJ+FoyrW2+2FNqHfuDlOIPK3ZZg=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBqmCQhKOoD7Qw+Ml02pCZuMIZj7noY1O3xY70OM
 w1v6apvx5+JAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCapgkIQAKCRD6UCkIqsW9
 0P/cEACp9buFkbtrQ2WUArAz/OwpG3jFQJPlt9CmqVhv2q/mMGeD+OMXW5IzS807+a5dIKcs0xD
 HL+77/wxWy9/GPUo2DA8l8yxfu0EdFEV530ul4WzXr/yg+W/9WYccghL7g3w5SbeYq3QQWmDciR
 iW1vZ4B1mpxYfKMwCCpTZAiQk3Qd68/7dkdqpIdqGIJVPxXzWsVr6f7hzVTHYccDXmztw5FEHi5
 8a3MkYaZoiBKIL/QwbbvF1XIxHIuZDnuMGS9pNbUAygcooroJehYx755axryK39qgxIdAbJKQ31
 zA2pYr5bimBf/ijQPi/vdQCydDkQLQjWV84EC4nItDKDz6Tsv5fTGjmh52O1yuZ2t2XM/p0EG+F
 bf0bI37HR1jBd8gJR+kcvtodncEX9htXSqO7vfG6HMR85UWXYRcEyOVvioO8EVPxehZy8l8sv9L
 ++D379qatS+hzoW2w4gbk5/LYulj4AMwsoxlMQVsNwe7WZukspkdakzOTWAahSiC+Gnf7dhuaW/
 yjOMKZUY+8gw5gyxwgVlxs1Tk0vAT8dkIqouu0UZEoZcQziy2M/vvDQ5Hk886t/BbHx5CkM37Sg
 HJ3RJRUi7ZMdrcXFHUliqsaQKaz2FAdhFwcnAUGplCVFsdKdctlpWqT14WRixzstOGVjYs/noX7
 aDeVMMaZGhNNf9A==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 7369A40006
X-Stat-Signature: r59ufp67qu69rkzhssqwh9nsr9px48dq
X-HE-Tag: 1788355640-830503
X-HE-Meta: U2FsdGVkX1+2ihmhLv1LfdElv+dziHEWTvdMCdUTBGOMjntHvA92ImQAsBs2uEHYGjnfTi5l5VN63A+Y2rIrhVHs9vL5UbTNvxjuNB+nT+WhmlWIoZmlrXgfquuENNjRmSkM5pkcJxe5tQ8gF2+QhUXgf3N5pBFIpeoquA5nBpVpdVHCyoKS7wJQfr3Bpr04K5bJfr6MR/1XHrDBQlHlmXTYusboYzGv7mqdznj5op02RT3DGbyJDjcBcGV2ybbop8Kir42xkqesczgPgQZ9naV+4YtufY4qlKIKsS8YYTgWTwgq4BTmnsOqg9sBbjU656fqGTeMXafTiv/3iswE/Q/O9ukObT1/GBWHIyrzMHlPP6zNetErEOHwjFVp+oxQvGNXAY9g99LW7wKMMeH+q8PMOVwtWxuoq3/isbIx4jm5harHFTvCqe8zCLtAL7NS4J87Io7Kn3vwW3SDKydwC3vZpQMNo36KJz6FdAUp0sr8c3eLBG5DLC8F3kYPqsomXpAEj0zXsHAfUTEAqqtJVvje0166CWL7IEnoGU+9txdHIy3VIuMpsJ3mWfc5FxHy4tBMnCCNX62lNUF6ui+csuJRf7SLGLngGg9gWI51VV6gWYQMKr61TXEnQZ0dt3uHAvmnpPJICnkVqMqmVgSvXq+4gALEq4ynIm93pwAtUy6oEzwrFii/1klA07y1VL6/rhB+OBQINyw8ONXB9pPy56x7ufVCZiwQdlbEtqY60QRg8vOp/BOigRpknxPu96rCUv+OuUSYnTgU9Vhcn8umLU4A3lnca6RuqyJGTgPhuct6pPL5nBiV44/AnontAc7o1+2UvbNSPG8Fae/iZzVas5ksoPIvAoI6Rf9qVOZ/me4UjNJgetl+piAMzFHBUMwaa7WHmbMYvPBJK3QKMMZT/GgPKtj7paJexXSCQsgWs0JikAlxwW9g3zBiLfndJVa5C0ZXpDjy2AOb7p9S1Dp
 ekmo0EJQ
 CfAHhkuxE+BQ+4Jh1g1gzVWq1xBApj757aztxOTZhvoJr8PSJdzKxutn4j5+f1L/U6vzSah4Ed6eLzZ+iUsrcPSYOLXQnliQSPANQiCOCmwbrpdzysZUyfco/zIuQqlYiVcGb65kbPOuUCW70uc32lQGY5feVfU7sXQ1qa0RrquDgAAJ/Khis8pAZ4JjLJzvW1/3QssakWPhqViHYcc0PzOyhwHUdZsp4i1IGjEdY1yx2z2v5BHD/aK69flLO0nxjuwcQqRz/iX5UqED3JNvHM2xaSbPlUz95RqCWJlQVGTH2l1I7qy7wxWSEsH2r6cnvRz2PbB7VRB1FoWvx0JaXwcdhEnaAhMye/SpMlCRPf5KSboicKdPKJikJrn5T0wcAGRW4
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
Assisted-by: LLM
Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 mm/slub.c               |   4 +
 rust/kernel/mm/sheaf.rs | 401 ++++++++++++++++++++++++++++++++++++++++++------
 2 files changed, 356 insertions(+), 49 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 0337e60db5ac..d81dbf2abb86 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -5101,6 +5101,7 @@ kmem_cache_prefill_sheaf(struct kmem_cache *s, gfp_t gfp, unsigned int size)
 
 	return sheaf;
 }
+EXPORT_SYMBOL(kmem_cache_prefill_sheaf);
 
 /*
  * Use this to return a sheaf obtained by kmem_cache_prefill_sheaf()
@@ -5156,6 +5157,7 @@ void kmem_cache_return_sheaf(struct kmem_cache *s, gfp_t gfp,
 	barn_put_full_sheaf(barn, sheaf);
 	stat(s, BARN_PUT);
 }
+EXPORT_SYMBOL(kmem_cache_return_sheaf);
 
 /*
  * Refill a sheaf previously returned by kmem_cache_prefill_sheaf to at least
@@ -5211,6 +5213,7 @@ int kmem_cache_refill_sheaf(struct kmem_cache *s, gfp_t gfp,
 	*sheafp = sheaf;
 	return 0;
 }
+EXPORT_SYMBOL(kmem_cache_refill_sheaf);
 
 /*
  * Allocate from a sheaf obtained by kmem_cache_prefill_sheaf()
@@ -5249,6 +5252,7 @@ kmem_cache_alloc_from_sheaf_noprof(struct kmem_cache *s, gfp_t gfp,
 
 	return ret;
 }
+EXPORT_SYMBOL(kmem_cache_alloc_from_sheaf_noprof);
 
 unsigned int kmem_cache_sheaf_size(struct slab_sheaf *sheaf)
 {
diff --git a/rust/kernel/mm/sheaf.rs b/rust/kernel/mm/sheaf.rs
index 8f310a06d840..f6df856c7f4b 100644
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
@@ -76,7 +85,114 @@
 
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
+// SAFETY: The C `kmem_cache` is internally synchronized and has no thread
+// affinity, so a `KMemCache<T>` may be sent to another thread if the objects
+// it manages can.
+unsafe impl<T: KMemCacheInit<T> + Send> Send for KMemCache<T> {}
+
+// SAFETY: All operations available through `&KMemCache<T>` (creating sheaves
+// and allocating objects) are internally synchronized by the C side, so the
+// cache may be used from multiple threads concurrently if the objects it
+// manages can be sent between threads.
+unsafe impl<T: KMemCacheInit<T> + Send> Sync for KMemCache<T> {}
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
+    #[inline]
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
@@ -92,9 +208,9 @@
 ///
 /// # Context
 ///
-/// Dropping the last reference to a `KMemCache` destroys the cache via
+/// Dropping the last reference to a `KMemCacheHandle` destroys the cache via
 /// `kmem_cache_destroy`, which may sleep. [`Sheaf`] and [`SBox`] instances
-/// created from the cache each hold a reference, so the last reference may
+/// created from the handle each hold a reference, so the last reference may
 /// be dropped when one of those is dropped. The last reference must not be
 /// dropped from a context where sleeping is not allowed.
 ///
@@ -103,23 +219,23 @@
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
 
-// SAFETY: `KMemCache<T>` owns a `kmem_cache`, which is internally
+// SAFETY: `KMemCacheHandle<T>` owns a `kmem_cache`, which is internally
 // synchronized and has no thread affinity. The cache may be destroyed from a
 // thread other than the one that created it.
-unsafe impl<T: KMemCacheInit<T> + Send> Send for KMemCache<T> {}
+unsafe impl<T: KMemCacheInit<T> + Send> Send for KMemCacheHandle<T> {}
 
-// SAFETY: All operations available through `&KMemCache<T>` are
+// SAFETY: All operations available through `&KMemCacheHandle<T>` are
 // internally synchronized by the C side, so the cache may be used from
 // multiple threads concurrently if the objects it manages can be sent between
 // threads.
-unsafe impl<T: KMemCacheInit<T> + Send> Sync for KMemCache<T> {}
+unsafe impl<T: KMemCacheInit<T> + Send> Sync for KMemCacheHandle<T> {}
 
-impl<T: KMemCacheInit<T>> KMemCache<T> {
+impl<T: KMemCacheInit<T>> KMemCacheHandle<T> {
     /// Creates a new slab cache with sheaf support.
     ///
     /// Creates a kernel slab cache for objects of type `T` with the specified
@@ -171,8 +287,7 @@ pub fn new(name: &CStr, sheaf_capacity: u32) -> Result<Arc<Self>>
         // `kmem_cache_destroy` is called in `Drop`.
         Ok(Arc::new(
             Self {
-                cache: NonNull::new(ptr).ok_or(ENOMEM)?,
-                _p: PhantomData,
+                cache: NonNull::new(ptr.cast()).ok_or(ENOMEM)?,
             },
             GFP_KERNEL,
         )?)
@@ -199,11 +314,11 @@ pub fn new(name: &CStr, sheaf_capacity: u32) -> Result<Arc<Self>>
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
@@ -215,18 +330,19 @@ pub fn sheaf(
         // was created. `dropped` is false since the sheaf has not been returned.
         Ok(Sheaf {
             sheaf: NonNull::new(ptr).ok_or(ENOMEM)?,
-            cache: self.into(),
+            cache: CacheRef::Arc(self.into()),
             dropped: false,
+            _p: PhantomData,
         })
     }
 
     #[inline]
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
@@ -239,13 +355,13 @@ fn drop(&mut self) {
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
@@ -270,13 +386,34 @@ fn drop(&mut self) {
 pub trait KMemCacheInit<T> {
     /// Returns an initializer for creating new objects of type `T`.
     ///
-    /// The initializer is applied to newly allocated objects when they are
-    /// allocated from a sheaf via [`Sheaf::alloc`]. The cache itself has no
-    /// constructor. The initializer should set all fields to their default or
-    /// initial values.
+    /// The initializer is applied to newly allocated objects when they are allocated from a sheaf
+    /// via [`Sheaf::alloc`]. The initializer should set all fields to their default or initial
+    /// values.
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
@@ -287,17 +424,28 @@ pub trait KMemCacheInit<T> {
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
-/// A sheaf holds a reference to the [`KMemCache`] it was created from.
-/// Dropping the sheaf may thus drop the last reference to the cache and
-/// destroy the cache, which may sleep. See the `# Context` section of
-/// [`KMemCache`].
+/// A sheaf created from a [`KMemCacheHandle`] holds a reference to the
+/// handle. Dropping the sheaf may thus drop the last reference to the handle
+/// and destroy the cache, which may sleep. See the `# Context` section of
+/// [`KMemCacheHandle`].
 ///
 /// # Invariants
 ///
@@ -305,10 +453,11 @@ pub trait KMemCacheInit<T> {
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
 
 // SAFETY: A prefilled sheaf is exclusively owned by the caller and has no
@@ -316,13 +465,13 @@ pub struct Sheaf<T: KMemCacheInit<T>> {
 // does not touch percpu state, and `kmem_cache_return_sheaf` reattaches the
 // sheaf to the CPU that is current at return time. Thus the sheaf may be sent
 // to another thread if the objects it manages can.
-unsafe impl<T: KMemCacheInit<T> + Send> Send for Sheaf<T> {}
+unsafe impl<T: KMemCacheInit<T> + Send, A> Send for Sheaf<'_, T, A> {}
 
 // NOTE: `Sheaf` is deliberately not `Sync`. The C side mutates sheaf state
 // without synchronization, relying on the caller's exclusive ownership. The
 // mutable receivers of the methods on `Sheaf` enforce this exclusivity.
 
-impl<T: KMemCacheInit<T>> Sheaf<T> {
+impl<'a, T: KMemCacheInit<T>, A> Sheaf<'a, T, A> {
     #[inline]
     fn as_raw(&self) -> *mut bindings::slab_sheaf {
         self.sheaf.as_ptr()
@@ -346,6 +495,39 @@ pub fn return_refill(mut self, flags: kernel::alloc::Flags) {
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
     /// Allocates an object from the sheaf.
     ///
     /// Returns a new [`SBox`] containing an initialized object, or [`None`]
@@ -382,7 +564,44 @@ pub fn alloc(&mut self) -> Option<SBox<T>> {
     }
 }
 
-impl<T: KMemCacheInit<T>> Drop for Sheaf<T> {
+impl<'a, T: KMemCacheInit<T>> Sheaf<'a, T, Dynamic> {
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
+impl<'a, T: KMemCacheInit<T>, A> Drop for Sheaf<'a, T, A> {
     fn drop(&mut self) {
         if !self.dropped {
             // SAFETY: `self.cache.as_raw()` and `self.as_raw()` return valid
@@ -399,6 +618,40 @@ fn drop(&mut self) {
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
+    #[inline]
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
@@ -408,10 +661,10 @@ fn drop(&mut self) {
 /// The contained `T` is initialized when the `SBox` is returned from alloc and
 /// dropped when the `SBox` is dropped.
 ///
-/// An `SBox` holds a reference to the [`KMemCache`] it was allocated from.
-/// Dropping the `SBox` may thus drop the last reference to the cache and
-/// destroy the cache, which may sleep. See the `# Context` section of
-/// [`KMemCache`].
+/// An `SBox` allocated from a [`KMemCacheHandle`] backed sheaf holds a
+/// reference to the handle. Dropping the `SBox` may thus drop the last
+/// reference to the handle and destroy the cache, which may sleep. See the
+/// `# Context` section of [`KMemCacheHandle`].
 ///
 /// # Invariants
 ///
@@ -420,7 +673,7 @@ fn drop(&mut self) {
 /// - The object remains valid for the lifetime of the `SBox`.
 pub struct SBox<T: KMemCacheInit<T>> {
     ptr: NonNull<T>,
-    cache: Arc<KMemCache<T>>,
+    cache: CacheRef<T>,
 }
 
 // SAFETY: `SBox<T>` owns a `T`. Sheaf allocated objects are ordinary slab
@@ -432,6 +685,56 @@ unsafe impl<T: KMemCacheInit<T> + Send> Send for SBox<T> {}
 // threads only shares `&T`.
 unsafe impl<T: KMemCacheInit<T> + Sync> Sync for SBox<T> {}
 
+impl<T: KMemCacheInit<T>> SBox<T> {
+    /// Consumes the `SBox` and returns the raw pointer to the contained value.
+    ///
+    /// The caller becomes responsible for freeing the memory. The object is not
+    /// dropped and remains initialized. Use [`static_from_ptr`] to reconstruct
+    /// an `SBox` from the pointer.
+    ///
+    /// This method is only intended for objects allocated from a static cache.
+    /// Calling it on an `SBox` backed by a [`KMemCacheHandle`] leaks a
+    /// reference on the handle, preventing the cache from ever being
+    /// destroyed, as [`static_from_ptr`] cannot restore the reference.
+    ///
+    /// [`static_from_ptr`]: SBox::static_from_ptr
+    pub fn into_ptr(self) -> *mut T {
+        debug_assert!(matches!(self.cache, CacheRef::Static(_)));
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
+    /// - `cache` must be a statically allocated cache that is never destroyed.
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
+}
+
 impl<T: KMemCacheInit<T>> Deref for SBox<T> {
     type Target = T;
 

-- 
2.51.2



