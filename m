Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F807E81BCF
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 14:39:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E5216B0095; Mon,  9 Feb 2026 09:39:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 69D726B0096; Mon,  9 Feb 2026 09:39:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5727D6B0098; Mon,  9 Feb 2026 09:39:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 418C16B0095
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 09:39:02 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0E02D1B2185
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 14:39:02 +0000 (UTC)
X-FDA: 84425175324.08.D2EAC9D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 084E410000F
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 14:38:59 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OF7VSIeE;
	spf=pass (imf14.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770647940;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W0QeMywRnx+M/A2TQJAP0wWCsBjkmAKDmoXlTbndpcw=;
	b=Q8GpCRWEfSFMqBBH1cPouHoeTU2obtBZSo7gwQm0FK2BMuNTKVGb4cfsrzW8rTHfleuubj
	cTGBMnlONs4HiDVYKykihxi3uW9irVN/UyMhVt3VffLh4175+oesQ4Cu1FmkUVRyeSq1CL
	5gkZ3dcOFjSp8F+hBgqq8vOTTfyS7nI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770647940; a=rsa-sha256;
	cv=none;
	b=vi7cWkRhoLDFmUcRaLQ7gwPCyw7bxdqZlrc3zRwdW0/GbNtL93/43pDFTgAOCV4J4h6BFt
	tZJBSOvz/gJ0C5+7bb7KhSSIYbseQPu0p5AVIT9t6dym03xyEPWPP3prPUUn6bV60JG9KD
	EhnpXs/qV8InW6JrKadeePPCw+kdNuI=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OF7VSIeE;
	spf=pass (imf14.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 11D6D43F98;
	Mon,  9 Feb 2026 14:38:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1543C19425;
	Mon,  9 Feb 2026 14:38:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770647938;
	bh=9Rord1GjbuU/nDocLnmD0XDpfMF4CDFshxEJfFsjWOY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=OF7VSIeEYh7mdVHPfRPc/LxMX4EC9ck4OvNXtBDMmZ9L9xTQc/k0YhYIbZivbxN/N
	 +UpFnXKZqqMkYil9ULay1uz65+sSKXvkkGOrsTWDzcsU25bHl+PS0zQ6+MSrY6SoY2
	 v21z3jFnNSsftxxtxI4qQU4g0s27bXNGLTCRVOKK6/as5j8Pn7eXZt1Ys6YgOaVLr4
	 dNZQCBb3Ip7w/CKVQ2KHn8myRwz4DEXkZb4fwstGwM6kseim83wm+AU3MuqhlhTUCw
	 r+2ma5zpXpgEaUmn7XLdP3uHYxvi/lCeslqsWLwwj/XbdMBA8e7/V6WzyQIzYnHtnT
	 UFzOIVK8azfyA==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Mon, 09 Feb 2026 15:38:15 +0100
Subject: [PATCH v3 10/12] rust: mm: sheaf: allow use of C initialized
 static caches
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260209-xarray-entry-send-v3-10-f777c65b8ae2@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=21503;
 i=a.hindborg@kernel.org; h=from:subject:message-id;
 bh=9Rord1GjbuU/nDocLnmD0XDpfMF4CDFshxEJfFsjWOY=;
 b=owEBbQKS/ZANAwAKAeG4Gj55KGN3AcsmYgBpifFdVEWC4I4vcBuU02CNL1nEBRPJm+FihuZCB
 jRr8v1/g16JAjMEAAEKAB0WIQQSwflHVr98KhXWwBLhuBo+eShjdwUCaYnxXQAKCRDhuBo+eShj
 d8kWD/9KcMP4auGiGg0vTqMX6qBzXoTikq1cmnuNMJmHP3NfkHrVoynDyCQ3ZPBkkfVOr62U5hi
 UUOOT2RVy+e6iFS0C0u1X8ZqLp4vCOQ49KUOezep46MCtFMZsVO49FvuraxgPzneswB8Vy6apt6
 bOpc5i0ywtIykqvLExkC96wkQPKf3nA9QYV1iJBuKPVMhCM/zShtePxpWdMshyiB0cUhgoX2xDJ
 qnmRGsl1xkiV7uHOIuHy4HoFlh+6dR62WWxW6LYjgytVXMr2UTSQOdemKAdE+JEnaILWkg8Oyro
 9gVdnIJA/rSvFVoV7zR3Jd7yk78DNBepIUE2o1L0fzTH/NYi411CvMEWrE5yZZEp4MtOyK8j+OY
 n6VR7N9ShPHtbWQNEuHceGU0Y+0QfFRUB0fXoxoz7nIdcME2HiWFfhLLhlafScYJ8hZjgESvRNl
 3vShvuuUrbSz/45ru0aRoShZ7Se+FHac6h7MS5tsXEIR8zIGGVtdZ7F8oKSLxhVOl33BOaoarmK
 tfOZri6WFKbz8RCgYRr+dLPZXeDlguznDiDwzxhL2WqoCc5RTNrabIiGtq0A3ci0VtB34rLmw01
 39UaUctRFMWrQWqDJ6wYXmTqiWtjTJwuQORB+KCMpW7dWnCRFDHKoX2XJpGALO3JxNYES5Fe98x
 XrHHLbD+2fSctHw==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Queue-Id: 084E410000F
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: wq7tdgux4bq4sgopmgbgo8u1hhdatn3r
X-HE-Tag: 1770647939-850182
X-HE-Meta: U2FsdGVkX18msEqcMf6KnyNGX4UWyE/1NJ+5OL3FYPnm16444fpl010+ipfbEixM4SO/h8cc64OaD4WX1gOP2dh38uIPbALvQVQdhu94IYEhiBs2RDErkD8F5yCVpXPw04W+Qufj9jk2sHywr+tJd953aaaMixUW/a8R11+J69ck9Rzx4poHv+drUlCbh/ASR61YoZeAy/BB9feKmgxUSrqPPy32XrlukNnHi396Jc6iaoFwQpqxxABuhnYoPQcFTWc1QEbhksCH8FzO9JB72hhq8QhuSyf7DaWal54UMg5Pi6NXWI9hwHuzrZljuexaRlO92i14I9STHrtgrrjh2XmaGexn25Tk/HcSndIrmJy8GbPkxVbHPsrXaj3XefNShdtsY2mlyJsa2p/yZW15w1sok9SGeMS9o3ZIw/0W8ZKSdCQPgSXy/sjmRARvq7BE7d4zAmOe0CSbLFMvoroPu9ZBOwalUKWPP/TdfEW54xiop9KES1t6ACemZ+cHHfkRsFORfMQaoIPIlftRJ57BksapMfkZf3CKxO7DxANng/LCBDxDDsoM6SdJ8uvGnmaJklSNq1OsxXJACCdPB6gL1KdV3jyS8qMLfq0FcMb+tRR3m1rgVonn1RgDIgxvv6/vpEPPO4EKgV7FvPXY2k2tNmIo0noEEE3x++Ob5KCJUw0bR4VOaEN437nmZkgfzRwJwBOd62fEvNM+CnVbcnuQRlj/wlGOda3KYpxeSX9EBOVdAqlbzOyj6vqlY4woHUwlM2dpWHCOccW5QuU5w2xsIz5ni00CUOQ7sD6LzppKaS3fGegdFIDHaYVa+4UDHlBC12qhdW9NETNCdtF5zYRqE0J6kaqu/PP+qgGyi5dFMnHogmBL5unGNggF3u99qUNEPLn7JcChOmctQzGHKCI99KyGSOmYLaEh6XQ1Noc3MoZtMFjrfu+T8RUoHEZdaBE/ek6PZR6TOXk9n00/D5J
 rZHEbPMj
 YOy2DMOQY+GdSEIA+P64uczU4CAI4c3r2V0hbm61/hPCAqswTBBcr/TS0hSdqNj+7/gYnP2CHyKLCQuzgIAuV+mSUWRyNsTkCk3uSD9nzGAw5joMR2DlDtj29UtcKLTEUH8M6vzc4cyQwpP/mCELveASOY5ntgRBGD2zEfvoQVxEGdUcKwBBss4rfXDrgPevneCtDfwKUlvjXx8pEDZHNHRuPxqo003AUhhEX2dWgIE+H4PnqF2iLu5CItaix7mFOciFo0Nz7+bUQabKrTfiK7epNL9QFL5m3rVlo86EbqXe/r9H/coQrz865DvfY6hRapGIMmEJ/b/krzBXm5JbvmBUI3qTvaDGy4QntxSygRIwlp/vDBOdupj6wSMp9/NLapNsWDdACOKO4n6y9Bz4TD2n5OZPU0C8qhuiJSXwshZs5W6AvLmjS7BjHnL0rL+Lvt+gUhok0EslBxRs=
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
index b8fd321335ace..e98879f9881c3 100644
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



