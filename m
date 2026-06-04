Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89FD1CD6E75
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 20:00:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F26446B0005; Thu,  4 Jun 2026 16:00:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EFE306B00A0; Thu,  4 Jun 2026 16:00:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E14B76B00A2; Thu,  4 Jun 2026 16:00:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CF0A86B0005
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 16:00:23 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6B774C0BE6
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 20:00:23 +0000 (UTC)
X-FDA: 84843297126.13.5FA11C9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 7D92EA0015
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 20:00:21 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JImfcU0y;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780603221;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9JCKYElz/+/RJ/zhCN0Vl5fzPuI/cBiMyLCI6JtnVSQ=;
	b=ms7ebpUEbJib2vZeUeEYmfOo0gJrDac4Os9M1BGFrt8JjDfCGx261ikCbgKmt7SJ9OS9fL
	IO2jnqlnFwsa/ih6/67V4CjUSRrWy9cF9FQcolff+VjoM/ikgrbbB4FtotJB0xs0dDeWG1
	uPUPCKrhD7ykqh9OtmZGzF8oG3eqVX0=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JImfcU0y;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780603221;
	b=AxP2x7f8fGYFAN2tbpGdTDbr2c4zzRyXjGwqNMYQ6/TENbu1qSnUZfRAQrlbxjyHd55pCU
	Q/MkSkwG+XhsX1aVQ6LVKf1p6AtEJk193dDgssElK6PwElacnyNNKhWXAyIjSgij4AJ/EC
	O3URlzfPS8kvvGsdWrNr37pydf86djo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C5D1D41850;
	Thu,  4 Jun 2026 20:00:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02E341F00898;
	Thu,  4 Jun 2026 20:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780603220;
	bh=9JCKYElz/+/RJ/zhCN0Vl5fzPuI/cBiMyLCI6JtnVSQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=JImfcU0yR/fTF+GGsQGxddNSyWkJxrQ+w+G0O/PyAXVSWK0AUwubE49wjNhckOWGI
	 05T/RmHE2dmyMERpEYQDFzs2s2Xwz6CMbLn3NCbDTosv6UoyaCENNGo9JOojmyo4w5
	 rPZulbVb161v+ktZwe6tAjo7czPRNVAnQor6tuhhb1Qrirpa9Syp7KDxsC5sJeKGaO
	 k17k9Ed7ahoQlbV82hMdjsQYo5w2ctEl/I/xDigQtZNdl2s1O9x0HFxAfYP/e2eEwh
	 vrJiDRKAcQGbjwTP2OYp5qN02eosxmeqH1zAwsQauiOsssWtCZIJMRycxTpyD5MD04
	 SR7B8Dan0Jb0A==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Thu, 04 Jun 2026 21:58:15 +0200
Subject: [PATCH v4 09/11] rust: mm: sheaf: allow use of C initialized
 static caches
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260604-xarray-entry-send-v4-9-965f6028790e@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=21499;
 i=a.hindborg@kernel.org; h=from:subject:message-id;
 bh=OXlzrpYOmH6xGYf35dAObz77Rlr5Pswn0A4JAdJKpCw=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBqIdjxOzytE41FB5Im0cfyJj1khIhKTWJJ5z9xi
 KhhuDXTP5KJAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCaiHY8QAKCRD6UCkIqsW9
 0NfiD/9o0zd3/3T/+ujR6+5qwoazeyra/SZPobXlJk1hFkvJw68gmJ+TxIulH/yJ4xx1sPrnQRX
 HbF6ZS+m7POgBwLFC5TRGAQTOKkvcmFxqLzOeuXqjWz74ldz3KxthFjViNlgEpXqcGjL6CsJMXE
 W4A5bhe0Mm58kr8vSFWMH7QvPVUV4pV3TjEMBqKGkrn90e18n5ayovszEZcn38v9XMsVlzubuhU
 qiZtre8ljRtyOJRsSbdEumJbdnJU5Hg0qKB3CmouH86I4JbKSyWtGZ3qnCzebk1kwbC8dQrzNR3
 0VHkchpTS/5NxG7Pq5UokaIVw1ha1myQqshWkAXK2B9PkhgeIYtsN0jcl+LKErI76kgSC+DDtyp
 xFyOv4XibkXEPmO1+fWusPq6OCSXk5kOQm54NWVhZzwKo6ieZTOk1JZJ2qFAXMTTNQNqvkfCCj2
 ajoHKMa8JF/Gla0das5Nl9hiK0gwkUb5DUGDFA7ER3BdyF++tE60DW1y3I66qtBqOcMV34UORBj
 YR/qhgqUw5Oonx4m9BJT7ReWailmaYoSwEDZwc6zhyoEVPmKaFGigtLWGiJid3rIa1fgRG0V/Ar
 JDJtmqMpH4X0EB2bGxkUmXZstG60M8JTEPmzlMpPUWNsLbQ3p9U3vZ8qOx2NIluNisCYulKXQRu
 5ifZTmoCADBUKdg==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Queue-Id: 7D92EA0015
X-Rspam-User: 
X-Stat-Signature: sh8j7zah67ieukn63x1oh9jspmexi6db
X-Rspamd-Server: rspam09
X-HE-Tag: 1780603221-235721
X-HE-Meta: U2FsdGVkX18lgiJboAZPVmthYkBk8EPZqtFMjNikMDuEymCTqnxfo+Mz+K9azdOp8MrUJ9G21Vq3UFHzcoxUqsR5ICevDjuPmAaYQCVDL/P6gkjn4UMjF3+jis0Vt451VaOaLNhYJ1cOAqeAWRyybrZLniJnhN14euLezDSkLyXqpya+RKFKMMl+HRccA5AlIYWnq5xDMAGGP200bnPQP39mg5wfCW/vj1grXV/6jvdLhLENGd8vvusUbmsSUcaStS5wLl/E8wt3auqCxdi+fBpk/hGKPtypiAp2sxX06yrYnokNkF6HbeHdoDPIp5/VaK+/XuEsoCNYVt1Tme9PxtjrYkKPpDcQw19Z//AvFkaOSfihbYBtlg8wjnoF1zhDwWENe6GfD3Q5p7XZHzk4WTZZ4/4qAKKA9p5sBxsiuWwAgWcBUB+dg/6wsgl7GPY2tWEARf+BGQzBc1Fb9Jx0uJP0uzzW6sSHv/2lNmY3+AISwxDUdZaCxZuyjG0iW+2509tVGVAyKRG0u1E1rKbEzc1ECFc4gWrRANKXEmNyrMof4wyO2cEOIWFg8pzgC+qlaFygSjnh5cxbr9XEP7S8qJixcy5JVAu8y2HumgZ/67mOSMp1ODzhx7+VN+gxBpfCqFqCVSBA9uJ9ePrI7Wf85qh7d6qybpV2v27p/GU/OPql9i7VNW4fcBWAZ9wyYaVvBUQtUHJKokVgVfrWDUnA6vyF3qcEtdpB7UmdXHgTSsmdn+k0jnib0+aTcL2g2llSDEu56ZfMR4Y39OxPUso7LJBdnTFC8hWfr6IoKTjpI+Pnf61w9mM3IootPmxg098wxQuafhnbBboOyoYoc/ajMiTZIQHULXrOsrpq1fEH8FG7SutEYK3FGDlRQeW23z/65TLYp9Fooxg8Ef4BjJI/RnkmjngAXgUP+UqYZSO7UILbxrcwmf8aBwWhIwzDXH5cebrKiIoVlT2ukXfUJmS
 tDtROR4a
 PSUIZjwzubJrIwhbFCKQ3JIrDjb43GyORy9Xg0DCxWNTmZPGqb34pTVz93o2zQZDAtxMunQESJhoZul9CpSxm+Q/VSnx1BUL75+zbXkkHG+2ZrLFUHwO/Nk3iAC5dEIjzTIYCg8Cc9/HdpZiAro43/Nrve8nmERAyffUYy0SpNvMFwi3APk0Z+a7GPcFsYQlKnDycR5ZZaTj0GQk4rDsBCKNhBa1EFHLejcZUaJzH6f4C/zz08gyUgaA4+DIsgsXXnRQ6s2YooNC+h4AiaIIpAoLpn/KeODxt6/CRpLnqeUQbz/ZSli6l/K58vUZn6eMsxccdP/FzqY21Q2w3ASCS2nZV+BbXkBoUl1TbFPjRHyStlikFB9G85sADUWQvTzl2ZMr16l2IWQ3vqMKQSM1TUe0uhNiRJtd83mU7MXJhnF0NpTxXzeStbkN+uk0ibFK0XQxjurZ36qYZX4A=
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
index 0baa906f39ab..87f138588100 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -5063,6 +5063,7 @@ kmem_cache_prefill_sheaf(struct kmem_cache *s, gfp_t gfp, unsigned int size)
 
 	return sheaf;
 }
+EXPORT_SYMBOL(kmem_cache_prefill_sheaf);
 
 /*
  * Use this to return a sheaf obtained by kmem_cache_prefill_sheaf()
@@ -5118,6 +5119,7 @@ void kmem_cache_return_sheaf(struct kmem_cache *s, gfp_t gfp,
 	barn_put_full_sheaf(barn, sheaf);
 	stat(s, BARN_PUT);
 }
+EXPORT_SYMBOL(kmem_cache_return_sheaf);
 
 /*
  * Refill a sheaf previously returned by kmem_cache_prefill_sheaf to at least
@@ -5174,6 +5176,7 @@ int kmem_cache_refill_sheaf(struct kmem_cache *s, gfp_t gfp,
 	*sheafp = sheaf;
 	return 0;
 }
+EXPORT_SYMBOL(kmem_cache_refill_sheaf);
 
 /*
  * Allocate from a sheaf obtained by kmem_cache_prefill_sheaf()
@@ -5211,6 +5214,7 @@ kmem_cache_alloc_from_sheaf_noprof(struct kmem_cache *s, gfp_t gfp,
 
 	return ret;
 }
+EXPORT_SYMBOL(kmem_cache_alloc_from_sheaf_noprof);
 
 unsigned int kmem_cache_sheaf_size(struct slab_sheaf *sheaf)
 {
diff --git a/rust/kernel/mm/sheaf.rs b/rust/kernel/mm/sheaf.rs
index f23fdaa2dbc3..1881a78670ac 100644
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
@@ -76,7 +85,102 @@
 
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
@@ -95,12 +199,12 @@
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
@@ -148,8 +252,7 @@ pub fn new(name: &CStr, sheaf_capacity: u32) -> Result<Arc<Self>>
         // `kmem_cache_destroy` is called in `Drop`.
         Ok(Arc::new(
             Self {
-                cache: NonNull::new(ptr).ok_or(ENOMEM)?,
-                _p: PhantomData,
+                cache: NonNull::new(ptr.cast()).ok_or(ENOMEM)?,
             },
             GFP_KERNEL,
         )?)
@@ -176,11 +279,11 @@ pub fn new(name: &CStr, sheaf_capacity: u32) -> Result<Arc<Self>>
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
@@ -192,17 +295,18 @@ pub fn sheaf(
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
@@ -215,13 +319,13 @@ fn drop(&mut self) {
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
@@ -252,6 +356,28 @@ pub trait KMemCacheInit<T> {
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
@@ -262,12 +388,23 @@ pub trait KMemCacheInit<T> {
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
@@ -275,13 +412,14 @@ pub trait KMemCacheInit<T> {
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
@@ -304,6 +442,75 @@ pub fn return_refill(mut self, flags: kernel::alloc::Flags) {
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
@@ -339,7 +546,7 @@ pub fn alloc(&mut self) -> Option<SBox<T>> {
     }
 }
 
-impl<T: KMemCacheInit<T>> Drop for Sheaf<T> {
+impl<'a, T: KMemCacheInit<T>, A> Drop for Sheaf<'a, T, A> {
     fn drop(&mut self) {
         if !self.dropped {
             // SAFETY: `self.cache.as_raw()` and `self.as_raw()` return valid
@@ -356,6 +563,39 @@ fn drop(&mut self) {
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
@@ -372,7 +612,50 @@ fn drop(&mut self) {
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



