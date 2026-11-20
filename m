Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CF7C606ABB4
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 13:11:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PbS/FuwL
Received: by kanga.kvack.org (Postfix)
	id 44EA46B05BA; Fri, 20 Nov 2026 08:11:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 425DD6B05BB; Fri, 20 Nov 2026 08:11:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 314A26B05BC; Fri, 20 Nov 2026 08:11:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0BDA36B05BA
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 08:11:48 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 91728C0F2B
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 13:11:47 +0000 (UTC)
X-FDA: 85455534654.17.6B956DD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id BC08080010
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 13:11:45 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="PbS/FuwL";
	spf=pass (imf30.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795180305;
	b=O04NtrGCcwD1RPdzYxAqAn+eEYi4/lWLUSyA9is15q5QUz8U/yGKNzm/xyF32DOIvDn6/n
	eYv4Tu+K8OtfL8jS4tne3mbfPu/QiJ8DAKEwwAv6g/1nLuanrVpvGU+//buQW056yEOjqu
	hnUfLbsNNOxSBrgH6VabpQwefZv3iIw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795180305;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Er/TOYKrkI7vXZl3PXvP6uSAh/8EwkCoewu1OLgyfnM=;
	b=ZH1zZQimHvbr04bSMtHV3CZLVXJHRCACGK+La4JDq31L/Jtg7ovQC8VeoW7Y6L/jl3BxNY
	jP1VlSrhFk3m2sJnORVQxwnPcoAdY9RPE4kgLKdAnnRs9GtjDN/ZaHFlH9RzLUZKM40xiv
	CzAq74PMZZDXWcc2XpYWBk7QgKfsewc=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="PbS/FuwL";
	spf=pass (imf30.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4199A62BEE;
	Fri, 20 Nov 2026 13:11:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22FBB1F01567;
	Fri, 20 Nov 2026 13:11:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795180304;
	bh=Er/TOYKrkI7vXZl3PXvP6uSAh/8EwkCoewu1OLgyfnM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=PbS/FuwLrsFVdV3Ga3o775G75PSbYXF6Wn58BbmOPasZSlCAKtJbUxepfbZSt8FNz
	 pQcWqNDQ5BdRfv52ZFPYFmFi8y5s6bObyXUoP412K2KSNZW4rZxhnmf0YvyWiPvAht
	 E7xMQVQ3HtKXLNC2rcD5NDGk2E1EejanGP6xdK6BjodseHc7bDhbtNmYVIbAC+QZ45
	 dgcC59dsg4OwGHbzi7eDM0N7Vs1Kl3AKeIFsfTvKyvRueuk8mhIapv9KW/2h4JBkCe
	 I5uxYLgRXv14AC9fBf+k57r3BScrh9B26gJteNoxpwdRMa5xtdi+GIZn3zhNOD//JM
	 5vuRHIUej8vGQ==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Fri, 20 Nov 2026 14:10:19 +0100
Subject: [PATCH v6 08/12] rust: mm: add abstractions for allocating from a
 `sheaf`
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261120-xarray-entry-send-v6-8-1f69d7385f70@kernel.org>
References: <20261120-xarray-entry-send-v6-0-1f69d7385f70@kernel.org>
In-Reply-To: <20261120-xarray-entry-send-v6-0-1f69d7385f70@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=21027;
 i=a.hindborg@kernel.org; h=from:subject:message-id;
 bh=Ecpj+HvQHv8cazAjFvadMz6fBqg7JA8DZ0F/0k5WxGo=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBrAEbKAWGh7blOYwnvPqNwoqzaoM/pBYAxZTPeI
 U8DO2G/y4mJAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCawBGygAKCRD6UCkIqsW9
 0DxpD/9ZWZHCeIpC57ppnp5TRIE5hicBe7IFksNJ04CjEpvjKLcS5R26usBJZrYiYm28xhlnAro
 9dPRlNdfLrU/wlmi33rpZbefQVxfWCVNRRTiGpg5SUItGEyrussw7a4tgXRW+3H/QPiAillJpq9
 Zm/iag1SHY/cO7V0xnk8ES/Ap93A/1SinbV/mVfDTzxo6R2DxZhPy5mdVDYSUEERIZ2bmLCFLOC
 Vx8vGp26gMhG881NKbfkCWxfdY3Oc2T21vJNGyBmzclloALR47p/6EtexQPiLWrKamDu+1IhUDE
 80TojqTJ+oZBWkfmPYJeyV+gD7xt1/2h6msIkK/ZDzUDCmWOk5iSauyROWGc9fDhiaAd7VttchQ
 R5X4uoTw5kGNwpGPAEHWbUDvM2c9e+UZ8gpVeaLywvgPiCY8LWDg5ivoTGxtlgxLHtPwai6oG44
 S50IiricCab+psV6r88LU0bc5nNdBnVM9qjpx8M3HpFBWpOLctn3SbxHnA2meY0bRgl2K/C5HtP
 CWUUfCfVPkVMPFTi8ucOVupInABHIuwD4Yn4uslNItR+TVuRZXi41R7fd5s8GrXwUnkPJl7CJgK
 Qnr8tz0vlmt6Vq++TOb+acLbwOFbomhHgy30BnioHEFaRcPyGxzO4QSSj572rjKqtALWPO5Lmgx
 p44v9lsiEmvIFZg==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspam-User:
X-Stat-Signature: 7yqbtx1ty3asoyaoujxaxpamawx1du7p
X-Rspamd-Queue-Id: BC08080010
X-Rspamd-Server: rspam02
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795180305-34971
X-HE-Meta: U2FsdGVkX18FKLGte09CH0VLATL6QdDAWSoUZz4I8DClV09SEFKnpq3qm3fkUEgGiOiTmPBQcyJ3eshwT2hFbnTAr/oQndcdbXInvoKHNCBIuB4B8fF/l91W0W2HFouPxwYw9eO2m8sgqe1LRF4TagtKPYOXvuRJ//5tZqSf+m3IogX/yobmsoc6qNLjxn3UFWy79NdljYzKyqi0mDZO/gOPgku0B8/yrMwBOVww5dwXuQ75N6aGHHxqCN4TInOmeK40a7LghHlQQPvw3msuUkupNMgpEY3SK4YyotRbGauhDcJ20qse7X7JcL29mM/ZqxaIbVBd8c+olpA3/JV8czdsSrjQELpe2+RDsqMWUlwGvK1RYFf93W06uopV6y+8n5tPlqxwF61Xf8dObyVEA6rEW+be9E9JPXLnTAUp3IK5dIkjufR/+DugCCVvZoe8UWzZij5j5RoPd5oJAEnuKabu9RrC2hAyJI9D1u05fqnhLqXfivumrjNIdWi0dhVWaPYicuvGDan2zqju3plM5vWOgrw7JbVxQC3hCwMAFqKrNh9alfX+h7M9q5XP6Vn/RtmNgtWdIbBwLvhkR4ophq/XlV/EVT4QGfmjHo+THR4/qRP/dGmqwezrlIJ+xXzQG6yKmQGlGzduioE8z76+48JW7SPcet44k5JnE2fOEpgSm/tN5Pu/FcJKwMV+T+hCl7KYLHnMSqkhCkxtLIrNfJRx8ceVhE+JeZ20xoBJ4oUPwODnweueSl48BRpolD+oEeLFJy4t7bY8Xho83jWBzY58jKv9dwochey1NKE5aRoq9gB++wyLSdM4m/2EogugmHar/c1nQqriftGwbNsaf80qkF34zlCYoFqR46gecTdp8DuYvkt2Ncl0hSsC6nzHWAvXvs9ZkMxRp1d3LWt+m5/DzSuDpcNTbBWJzxvEyNWwXDoiEnMnOWRvxUbt6qYgpqKVwAADGdCsELd4AAm
 lOsJJZzC
 Uqbis3DYNuQW9Rcu1aEYDwh2ixcgrwd0EsezHYEjeuSJRWN+T79QUbEXtrCJC4HFVJYscsDKPA9Dsvx7nmR3aeqL3axQt/iFM6IrvOfG8iIANjYLeaPVoA+xWPZwSAC0wQ/xxSYm2viKQ45ndHZeE519JjGJhCueS9jkTqRngmNDGvYggSq/8OFEMuEjvtOXokFRzAISP7tgoDlKENE7fSZS55MwgJQJ5xkyRBeLX5qL8tgHVTMWG6KDwAf2FFU3z1iCLSM/fN2T17ubXAJh0M3xBplH4wzEUOCitBow+4mZ5ObjMeptHabgu03wmGYlZnDicEhrViEtl65oQYrUCGL5E5aqZl6bez4quskx2UFQ2vH/1n3LP1Shp+QtMRLokiNLejq6XeGBFaWKuQlKAqIhc7rO6nwqcE0YUVbh4hKJrKRTzKBBBy7GI03ZlUd6emPFXuIooTjT+7MSkWoCjubzV5F+KxEi+QDApvPfIHjJli+Y2jBCTfY926s11tC9hJ1D9SIYWeNl2AyIPprA2o9996epo+DLgllKBKcQhxAN3peba9tbrXcy6GvAqBHRLgJHs/MN/gjvEbFpyg+IScblSTTkHYxC708d5x6pDeNOizoo8S/Obpis+blWV6DZvzG7wUrlP+Vz4Zo3ktj5XdYjpBTo6jZBKoVsZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

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
Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 rust/kernel/mm.rs       |   1 +
 rust/kernel/mm/sheaf.rs | 483 ++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 484 insertions(+)

diff --git a/rust/kernel/mm.rs b/rust/kernel/mm.rs
index 58bc1793fdaf..c1920f049170 100644
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
index 000000000000..1bc0c3dca900
--- /dev/null
+++ b/rust/kernel/mm/sheaf.rs
@@ -0,0 +1,483 @@
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
+//!   atomic operations by using local locks with preemption disabled. Note
+//!   that the abstraction adds reference counting on top of this, see
+//!   [`Sheaf`].
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
+//! // Create a cache with a sheaf capacity of at least 16 objects.
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
+//! - Sheaves are slower when `CONFIG_SLUB_TINY` is enabled, or when slab
+//!   debugging (`slab_debug`) is enabled for the cache, due to cpu sheaves
+//!   being disabled. All prefilled sheaves become "oversize" and go through a
+//!   slower allocation path.
+//! - The sheaf capacity of a cache is decided at cache creation time. The
+//!   capacity requested when creating the cache is a minimum. The allocator
+//!   calculates a capacity based on the object size and uses the larger of the
+//!   two.
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
+    /// Creates a kernel slab cache for objects of type `T` with at least the
+    /// specified sheaf capacity. The cache uses the provided `name` for
+    /// identification in `/sys/kernel/slab/` and debugging output.
+    ///
+    /// # Arguments
+    ///
+    /// - `name`: A string identifying the cache. This name appears in sysfs and
+    ///   debugging output.
+    /// - `sheaf_capacity`: The minimum number of objects a regular sheaf from
+    ///   this cache can hold. The allocator calculates a capacity based on the
+    ///   object size and uses the larger of the two, so a value of zero
+    ///   selects the calculated capacity. Set this to the largest `size` that
+    ///   is expected to be passed to [`sheaf`](Self::sheaf) to avoid oversize
+    ///   sheaves. The value is ignored when `CONFIG_SLUB_TINY` is enabled or
+    ///   when slab debugging (`slab_debug`) is enabled for the cache.
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
+    /// - `size`: The number of objects to pre-allocate. Must not be zero. If
+    ///   `size` exceeds the sheaf capacity of the cache, an "oversize" sheaf
+    ///   is allocated. Oversize sheaves are slower to create, and they are
+    ///   flushed and freed rather than cached for reuse when returned.
+    /// - `gfp`: Allocation flags controlling how memory is obtained. Use
+    ///   [`GFP_KERNEL`] for normal allocations that may sleep, or
+    ///   [`GFP_NOWAIT`] for non-blocking allocations.
+    ///
+    /// # Errors
+    ///
+    /// Returns [`ENOMEM`] if the sheaf or its objects could not be allocated,
+    /// or if `size` is zero.
+    #[inline]
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
+/// local locks with preemption disabled rather than atomic operations. Note
+/// that each [`SBox`] allocated from a sheaf holds a reference to the cache
+/// the sheaf was created from, to keep the cache alive until the object is
+/// freed. [`Sheaf::alloc`] thus increments the reference count of the cache,
+/// and dropping the [`SBox`] decrements it. Both are atomic operations on a
+/// counter that is shared by all users of the cache.
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
+    #[inline]
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
2.54.0



