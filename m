Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6255F606A334
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 13:11:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZcZi7483
Received: by kanga.kvack.org (Postfix)
	id 55EDF6B00EF; Fri, 20 Nov 2026 08:11:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 50FFC6B05B0; Fri, 20 Nov 2026 08:11:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3FD906B05B1; Fri, 20 Nov 2026 08:11:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 179576B00EF
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 08:11:01 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 850C11A0F19
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 13:11:00 +0000 (UTC)
X-FDA: 85455532680.19.A155371
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id A97792000D
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 13:10:58 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZcZi7483;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795180258;
	b=TEkQxi5t5gkSfpgN09zmbYE5oSlFMVYJCGYdnLhOaw6w6Kd3051rPTpz38Xv9OlZqa4HX/
	RCIVMlnFfB7fmYqA3rjNwAHbrmWYFkDI67ykrGc8yl+fNKYDvtJFNxk5Ow7L7RBwjFQIJK
	IXNSBFk4InNtaJCp24p80hv8d6ZmcTY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795180258;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Mpa9dw0DO+dndhjgN4lt9sWX+o9lflL7LbOgaT3UTJk=;
	b=Snf8WENWN5Fyl4mhlMVvTKblB06EbgN3eh4XAPbq+xoETr6GxyXAZuEd/dz/xe2B2yEuk3
	5rtsu8FkFTEPnozvYIxCP2uGmxGtGeH1Fz9PDARE2FBWDzW1K08/RddpjGDtcMhoE4bWYB
	QTk1FKcJKfNlUb6bsy29CJgTU6fdgiU=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZcZi7483;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1629B628C8;
	Fri, 20 Nov 2026 13:10:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 036E51F00A03;
	Fri, 20 Nov 2026 13:10:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795180257;
	bh=Mpa9dw0DO+dndhjgN4lt9sWX+o9lflL7LbOgaT3UTJk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=ZcZi7483IjVcLZzz0Q3UxRC0fOWDAUoc5U1ynQvrjbFGx+ZMwWj2HxkmGKJ921ZSS
	 2G0MX33O20sos7abKqqCF93rczEIy5nLialSzh62muaRl5cZkfl/46RaToJomNgeXt
	 H8JMCQjCMkqOxrXh7p4mfW+7SIIMuJffyHrRzqJBQwbjek8TysqIiHlLXzWdXehyum
	 5ZWq+z8Sa+qO8FqYP6ph/dzJQEueeeonjoSeIGGsQDhjlbu9Ww4gO/DEtkzLZ87F3g
	 I6iy/I6QcfWd+lAcUv0IeG5D+UHWcFPwWeRl4ZUDiTdWRqCH4YONhW1E4hqwQvmDos
	 VYkM7vf0FxCKw==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Fri, 20 Nov 2026 14:10:20 +0100
Subject: [PATCH v6 09/12] rust: mm: sheaf: allow use of C initialized
 static caches
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261120-xarray-entry-send-v6-9-1f69d7385f70@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=27880;
 i=a.hindborg@kernel.org; h=from:subject:message-id;
 bh=Mi/qCDI3qg93wNLU78CgBGotFoxviRpcaJWjNnUodCo=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBrAEbLTwKcUqDbXMkbPrxzZ4WGOhqd2rdcafcjJ
 esRB7cz+muJAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCawBGywAKCRD6UCkIqsW9
 0NEuD/96nFThf4IuSjuLkW0B/YN/JY0gRRamnNjTLuxrIj69qn/8Oe58UufYnTjXK/mETq4kSxF
 GpYLc/dFQrEFKY82WT8Ng5iGr3d7NK0WmZ9aLYzpQ8tAWVuQ0Ub2mlfPCaOfIXlaTH+7hmZ1g/i
 XAUy5S1pYO+q6MLxPl2ZvOtfc+Hvm/4b+KJ1DPfMEXcc+Pzm+EIGW2X1mR4yFDT6bpJRVoasimv
 4hiPlk0SRwrL9buYgjJgNmU80JBuid5YFLutb4pRYjZ4A1rrR9g4bFnXDdBAIlQu1N5cy+hcw36
 slmrNKMv824B79lvJaxObbGixroJU/kbBqCxCX7BMRwE3kpcP12s8oIQrN0M9+cl3oiG/f/bikK
 uMfKVXEribGyMLokJCvXy+YPb2fp9H7SuIqMhlJ1h/e3WWuOXeFA3kxLHukji/uIZ+/J3xlWNH4
 y9/h3dgM8wZvxdggkpsCvh1MZqsjglNZTGEKeflaIpK+rJYVlvfL47hAHhCLRoQ9CieW4CyLJr7
 eIPKVNV/uJadBCWku/DxzEBtkFdNnNZtXw/7VBup9J2qytsfSVoojKhHJMbLOlH12jhi+ngHPZm
 gLatFjvb1kmwK6wj2hRk0x5PKfOIm2JBmqnQxCEwv9MlqK5/HMwDU9glCnDTmC9uRnOglAGgLcg
 4+ipxmK4/2IAoUQ==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Queue-Id: A97792000D
X-Stat-Signature: 7748847qf8xyakpzh4uaa9ytqycnwrod
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam08
X-HE-Tag: 1795180258-538827
X-HE-Meta: U2FsdGVkX1+hN7cgPhJTEjZZsziBLELJtXfuE8LRSylo81Ddio1dm8zndZn4L63GMZ6RwWKip3C816iXuQRCfSdpBBtCICUosvDHk3w55lB/a8rjG7XOUQS9zgpsy/Oi+nZ/RvF3zM9rcU3vdo2rI6WqlSLXw/uV5+1qAfgJzZqtxyq/xomQeJxQ1nWAUdwBEjV4QENKFf/KSlkbSwwr2odjR6dSzGM4KnkQxxSjdT8TxvrEsWc+dv7SchGSKwxfav1TUao48lNZ/mPqgoTeqHYwduPmlH/IoZv0EZBvK+DlesrGvPu57PXj0Mq84apeDTGkIYT2Kate8bWlZRVWqiR/Oyy4X7BJpLHvkUipNHfk5rTkTTTKmy16rRhUrN8w5JaPSscO0c3KbclP2JwQJkNKqhUaNGwjorYNsYALauypSqd6zV54xJSeNDEyNziUcd26eyEoj+1udJNYy1bsm5JIobYrJNt2gjgXqtVdpn0yr+PKDC+A2Yx7+A8PhL4TlKm05nnILLs5Qpm1AVHGuIG5H8VzePD+BY2FCw4IhgW7KPvOjN7G5R1ej6dXqPRR7E6FdW5InF14djZ3eFe5y7GFSp8XXMXvFkEBcYl4lpyRslienSPJIv9ndWTqus5tcphwjN80bpX9HWAHIbGerzcaitbrlBuzoaskovGJzYnBKmJEIRTIyhN8GXO6Ijqht4Un9dOPslxJX95EtkiQvJPGZ7QVf+gF4lK1ugtd1gc6S6Or4A+XbTMZVYbF6Lew9fWJLWd4ZEgh3ihrVdZB2lVbg/aXi+Vcg1DzkdHo9dYf6h+xSkm9ACpcv4gWTmI+81oc1Z4jmCbBbC+FqhtNor0bXCs9+meyLY+eqlA07gj5KNbZQPbunQpWoDKdm7HVOQgkFEXtB29pi3VmPgMlzRSx3urtJ5AR+uG75Z+d6tekiY4wAfhCKkrkx8omnX5bAxb0Uhx8j0XRp8uqPIc
 wi6s0gyt
 1LrtWO+of8kQVSOQYzzneBoHjzoyQRawxvsFT/tojmDtC5bcmS4nj6cXm+rA9000tnSXu084IQz7Nuoc3l8aYGeNxpARjsY3QWVGGLUoIzECIG6NiQ3902f6wAH9+K/N1YR/KvG7BxSrbwPsPhznMoaHtibslQQ/2t4/9GtS0pBVOmK4GqncasSqJg4RNb+8mY45qEM2phLzelRgMPTlgi5d+FZJckU2K0sz1yqAhQcFNNdAJuO0SXCHRmU4F2QiX1wV3ouJ9ju96hZ9N8sH9mhkJW0Gkg2dB07H1vLxRPhTsoN4m6Xrb4JdEylZvuCAkDQ0+9T+zjEVzGUDMc42irywgMUDdIV+SP0hc3I3zCO1TZL2xddd3GhiaZPKTqRrfNJ8Yihv2hmCDyXlifDgtWCAKiAfZbAfq/fgM/cHpNXBtx6TyVOgecD8LOFnz9Dy+7zxnTmwXTQwGcWjrT39UTedVTB6ysE91/9+a210Fc1rtEfYjk3hNjR3iQMuJd0tDeshUGLQH2ZdtEg5bvrxaGfj8hDSKRtDDEJL4Q/dH5JkErxe/4VV4FoUcLfUolG1kyDOS7Trvaj9Q4ttVil8gqweeG0U3WBfnH30R4x3M9w9KqZLk//2S5ut5gw3zpxz28fcxRpyUbYVeUFjvqsP6ebaWgDthzXVkCcms
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Extend the sheaf abstraction to support caches that are never destroyed,
such as caches created by C code at kernel boot time, in addition to
reference-counted caches created through the abstraction.

Introduce `KMemCache<T>` as a transparent wrapper around `kmem_cache` for
static caches with `'static` lifetime. Rename the previous `KMemCache<T>`
to `KMemCacheHandle<T>` to represent caches that are created through the
abstraction, reference-counted, and destroyed when the last reference is
dropped.

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
Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 mm/slub.c               |   4 +
 rust/kernel/mm/sheaf.rs | 397 +++++++++++++++++++++++++++++++++++++++++-------
 2 files changed, 342 insertions(+), 59 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index cd671b934719..21811b9ff791 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -5292,6 +5292,7 @@ kmem_cache_prefill_sheaf(struct kmem_cache *s, gfp_t gfp, unsigned int size)
 
 	return sheaf;
 }
+EXPORT_SYMBOL(kmem_cache_prefill_sheaf);
 
 /*
  * Use this to return a sheaf obtained by kmem_cache_prefill_sheaf()
@@ -5347,6 +5348,7 @@ void kmem_cache_return_sheaf(struct kmem_cache *s, gfp_t gfp,
 	barn_put_full_sheaf(barn, sheaf);
 	stat(s, BARN_PUT);
 }
+EXPORT_SYMBOL(kmem_cache_return_sheaf);
 
 /*
  * Refill a sheaf previously returned by kmem_cache_prefill_sheaf to at least
@@ -5402,6 +5404,7 @@ int kmem_cache_refill_sheaf(struct kmem_cache *s, gfp_t gfp,
 	*sheafp = sheaf;
 	return 0;
 }
+EXPORT_SYMBOL(kmem_cache_refill_sheaf);
 
 /*
  * Allocate from a sheaf obtained by kmem_cache_prefill_sheaf()
@@ -5440,6 +5443,7 @@ kmem_cache_alloc_from_sheaf_noprof(struct kmem_cache *s, gfp_t gfp,
 
 	return ret;
 }
+EXPORT_SYMBOL(kmem_cache_alloc_from_sheaf_noprof);
 
 unsigned int kmem_cache_sheaf_size(struct slab_sheaf *sheaf)
 {
diff --git a/rust/kernel/mm/sheaf.rs b/rust/kernel/mm/sheaf.rs
index 1bc0c3dca900..9afbac202418 100644
--- a/rust/kernel/mm/sheaf.rs
+++ b/rust/kernel/mm/sheaf.rs
@@ -20,22 +20,32 @@
 //! - Multiple allocations need to be performed as a batch operation.
 //! - Fast-path allocation performance is critical, as sheaf allocations avoid
 //!   atomic operations by using local locks with preemption disabled. Note
-//!   that the abstraction adds reference counting on top of this, see
-//!   [`Sheaf`].
+//!   that the abstraction adds reference counting on top of this for dynamic
+//!   caches, see [`Sheaf`].
 //!
 //! # Architecture
 //!
-//! The sheaf system consists of three main components:
+//! The sheaf system supports two modes of operation:
+//!
+//! - **Static caches**: [`KMemCache`] represents a cache that is never
+//!   destroyed, typically one created by C code at kernel boot time. These
+//!   have `'static` lifetime and produce [`StaticSheaf`] instances.
+//! - **Dynamic caches**: [`KMemCacheHandle`] owns a cache created through
+//!   this abstraction. These are reference-counted, destroyed when the last
+//!   reference is dropped, and produce [`DynamicSheaf`] instances.
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
@@ -49,7 +59,7 @@
 //! }
 //!
 //! // Create a cache with a sheaf capacity of at least 16 objects.
-//! let cache = KMemCache::<MyObject>::new(c_str!("my_cache"), 16)?;
+//! let cache = KMemCacheHandle::<MyObject>::new(c_str!("my_cache"), 16)?;
 //!
 //! // Pre-fill a sheaf with 8 objects.
 //! let mut sheaf = cache.as_arc_borrow().sheaf(8, GFP_KERNEL)?;
@@ -82,7 +92,115 @@
 
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
+/// KMemCache<T>`), it represents a cache that is never destroyed, typically
+/// one created by C code at boot time. Such references produce
+/// [`StaticSheaf`] instances via [`sheaf`].
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
@@ -98,34 +216,38 @@
 ///
 /// # Context
 ///
-/// Dropping the last reference to a `KMemCache` destroys the cache via
-/// `kmem_cache_destroy`, which may sleep. [`Sheaf`] and [`SBox`] instances
-/// created from the cache each hold a reference, so the last reference may
-/// be dropped when one of those is dropped. The last reference must not be
-/// dropped from a context where sleeping is not allowed.
+/// Dropping the last reference to a `KMemCacheHandle` destroys the cache via
+/// `kmem_cache_destroy`, which may sleep. [`SBox`] instances allocated from
+/// the handle each hold a reference, so the last reference may be dropped
+/// when an [`SBox`] is dropped. The last reference must not be dropped from a
+/// context where sleeping is not allowed.
+///
+/// A [`Sheaf`] created from the handle also holds a reference, but dropping
+/// a [`Sheaf`] never drops the last one. See the `# Lifecycle` section of
+/// [`Sheaf`].
 ///
 /// # Invariants
 ///
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
     /// Creates a kernel slab cache for objects of type `T` with at least the
@@ -182,8 +304,7 @@ pub fn new(name: &CStr, sheaf_capacity: u32) -> Result<Arc<Self>>
         // `kmem_cache_destroy` is called in `Drop`.
         Ok(Arc::new(
             Self {
-                cache: NonNull::new(ptr).ok_or(ENOMEM)?,
-                _p: PhantomData,
+                cache: NonNull::new(ptr.cast()).ok_or(ENOMEM)?,
             },
             GFP_KERNEL,
         )?)
@@ -210,11 +331,11 @@ pub fn new(name: &CStr, sheaf_capacity: u32) -> Result<Arc<Self>>
     /// Returns [`ENOMEM`] if the sheaf or its objects could not be allocated,
     /// or if `size` is zero.
     #[inline]
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
@@ -226,18 +347,19 @@ pub fn sheaf(
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
@@ -250,13 +372,13 @@ fn drop(&mut self) {
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
@@ -281,13 +403,34 @@ fn drop(&mut self) {
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
@@ -297,23 +440,43 @@ pub trait KMemCacheInit<T> {
 ///
 /// Sheaves provide faster allocation than direct allocation because they use
 /// local locks with preemption disabled rather than atomic operations. Note
-/// that each [`SBox`] allocated from a sheaf holds a reference to the cache
-/// the sheaf was created from, to keep the cache alive until the object is
-/// freed. [`Sheaf::alloc`] thus increments the reference count of the cache,
-/// and dropping the [`SBox`] decrements it. Both are atomic operations on a
-/// counter that is shared by all users of the cache.
+/// that each [`SBox`] allocated from a [`DynamicSheaf`] holds a reference to
+/// the [`KMemCacheHandle`] the sheaf was created from, to keep the cache
+/// alive until the object is freed. [`Sheaf::alloc`] thus increments the
+/// reference count of the handle, and dropping the [`SBox`] decrements it.
+/// Both are atomic operations on a counter that is shared by all users of the
+/// cache.
+///
+/// This does not apply to a [`StaticSheaf`]. A static cache is never
+/// destroyed, so objects allocated from it do not hold a reference and no
+/// reference counting takes place.
+///
+/// # Type parameters
+///
+/// - `'a`: The lifetime of the cache reference the sheaf was created from.
+///   The cache is guaranteed to outlive `'a`.
+/// - `T`: The type of objects in this sheaf.
+/// - `A`: Either [`Static`] or [`Dynamic`], indicating whether the backing
+///   cache is a static reference or a reference-counted handle.
+///
+/// For convenience, [`StaticSheaf`] and [`DynamicSheaf`] type aliases are
+/// provided.
 ///
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
+/// handle. Dropping the sheaf never drops the last reference to the handle,
+/// and thus never destroys the cache: [`KMemCacheHandle::sheaf`] ties the
+/// lifetime `'a` of the sheaf to the [`ArcBorrow`] it is called on, so the
+/// reference the [`ArcBorrow`] was created from outlives the sheaf. A sheaf
+/// can therefore be dropped in a context where sleeping is not allowed. Note
+/// that this does not extend to [`SBox`] instances allocated from the sheaf.
 ///
 /// # Invariants
 ///
@@ -321,10 +484,11 @@ pub trait KMemCacheInit<T> {
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
@@ -332,13 +496,13 @@ pub struct Sheaf<T: KMemCacheInit<T>> {
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
@@ -363,6 +527,37 @@ pub fn return_refill(mut self, flags: kernel::alloc::Flags) {
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
+
     /// Allocates an object from the sheaf.
     ///
     /// Returns a new [`SBox`] containing an initialized object, or [`None`]
@@ -399,7 +594,7 @@ pub fn alloc(&mut self) -> Option<SBox<T>> {
     }
 }
 
-impl<T: KMemCacheInit<T>> Drop for Sheaf<T> {
+impl<'a, T: KMemCacheInit<T>, A> Drop for Sheaf<'a, T, A> {
     fn drop(&mut self) {
         if !self.dropped {
             // SAFETY: `self.cache.as_raw()` and `self.as_raw()` return valid
@@ -416,6 +611,40 @@ fn drop(&mut self) {
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
@@ -425,10 +654,10 @@ fn drop(&mut self) {
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
@@ -437,7 +666,7 @@ fn drop(&mut self) {
 /// - The object remains valid for the lifetime of the `SBox`.
 pub struct SBox<T: KMemCacheInit<T>> {
     ptr: NonNull<T>,
-    cache: Arc<KMemCache<T>>,
+    cache: CacheRef<T>,
 }
 
 // SAFETY: `SBox<T>` owns a `T`. Sheaf allocated objects are ordinary slab
@@ -449,6 +678,56 @@ unsafe impl<T: KMemCacheInit<T> + Send> Send for SBox<T> {}
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
2.54.0



