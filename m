Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E8F8C624D3
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 13:28:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 65F706B00A7; Wed,  2 Sep 2026 09:28:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 637AF6B00AA; Wed,  2 Sep 2026 09:28:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54D4B6B00AB; Wed,  2 Sep 2026 09:28:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2AA9E6B00A7
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 09:28:20 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BD80C1A0202
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 13:28:19 +0000 (UTC)
X-FDA: 85168901118.10.639267D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 0CBA4A0019
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 13:28:17 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DSA2LjIn;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788355698;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gWLIEeqPSv/ucpXrHg5udp/+YKo5YFuXiXIqJHSm6p8=;
	b=cgDF035rIav6nObuRxTv0ngoUj3xYzEFvvA3kzIQFSq2APxWTW5E5Uj/D8x72pT4SOz46B
	DNZv3Hkoa59YS2hYUJUE3U1/wX0wmn2XsxByL/6QaYaNiP/B35UrY7N2shSRkr2P/TbTZd
	/XAZLJaxX1bKiTqoar6qJxTh0xumKng=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DSA2LjIn;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788355698;
	b=CZgtICNHE9nKLoc3aa6TDcowt8kxUKaHIKZ9DWqHEoZBw/7FoWnlGg2PIsLWAxvQqN2F5v
	btTTjnidawXIGMm4wo3/TCAM124+aamjso00td/Z+xKiiedLeNGZg+IG+IRWr91vH44FGy
	m+tTIMXie+ROQue8LUCYEdKyUUpYwuo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8841E602C8;
	Wed,  2 Sep 2026 13:28:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A23881F00A3A;
	Wed,  2 Sep 2026 13:28:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788355697;
	bh=gWLIEeqPSv/ucpXrHg5udp/+YKo5YFuXiXIqJHSm6p8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=DSA2LjInRx7tF+skCryAG5rdkUJluf9h4hq6bSgNqB5si0IxSMv25i0Cm8sHZdlml
	 +rVmnLEBXPvSgSmTqKcWi0NiCutIynrb4iaMtHSya+Dnr8F+mWrzsssTfkBrOQbuS2
	 MCwtMZknfQ55t+E4DhtHeuPriH4tY3LHa/RUKnhniJdvaAaHCBiOA2XFgmA6j1JUdw
	 s2I8s/Jkw+xOXvAXta80b2gshuxuHSOJdxh0N/RxpySeQFoYvdB+HV2lUrsLbFRIA9
	 XkugaOnbFRjOTI0xaJmkyQfHK6uxa0A/umy19SKUsSBmRfEBmRhejtBHcbJoKH2zsP
	 p5H+DlqTrskEw==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Wed, 02 Sep 2026 15:26:07 +0200
Subject: [PATCH v5 11/12] rust: xarray: add preload API
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260902-xarray-entry-send-v5-11-d18adae40708@kernel.org>
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
 "Liam R. Howlett" <liam@infradead.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=18837;
 i=a.hindborg@kernel.org; h=from:subject:message-id;
 bh=KQvqFkd73+KLhJE+UaIWBrkWmcMkBP46A3dBwLH0V1I=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBqmCQisXwWcJP4hFSKVWaVPMLw7FprpMsPG0D0r
 w7W518G/+OJAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCapgkIgAKCRD6UCkIqsW9
 0IcDEACbok7lfFfJRtX9YoIFrUa7T6ZB2oN/OL5NzGHvbMhMzESzb/FnHv0U/q4uewQaI57Ky4a
 UZOaGrMDy3YZYQkYmjk38DcD9Cn8iBH5PiDgBGqKEwVXxlnc04fHaDWhmql2lUytXKpaksDMNcO
 m2n324OQlQ/mA3pstUygOsyA0Q+F307TIHof1F8i+BdXJZz5IfdCFSFleef70w/diSsytJkRI+U
 +8JJaPHeAeIp+94zvbNdnSzDHC6z1zIGn0we9Fjb0A0oPZCdRom75oEnt3rOL3lojRFM767mkFW
 0vvShSLY4V3sE5yTU2Id30gzW/8cisGn5zOEx3vj2VhGGu9tfy2IdJ40GifbXfTzLW/EDEfJwNK
 I6A4kY6QwvtMDFT9eKbSm0ZCYq8To7/AyqW48JLh8v0/aZfAvXFfUkYrzZHy2782k2QPTUrWA+a
 ypfo9K05uuLFhV6r3Dqk0/rkeJPPmAJMGTGgVe/iBSjyVIFC3FR6MzSnzIgDS2HCTlVXBXHLhlm
 F/cWI0HH6h0HN7K7wpOUp8mjce5E3FxynYVtrS1/Mo6Tpy4LTVMICuP/bxMbMXiGf8p0oYiVYJ3
 jbmscZvUC92Yf66FA246oCxI8Ozby98MG8R7Tbli5eMB6WY7ip6glaurNiTkXM3KPFPvYj9tU8n
 HRj1q/FyfuD8XUw==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: zby5cgn5c3m8jhdzqghop6ga5wydhyxw
X-Rspamd-Queue-Id: 0CBA4A0019
X-HE-Tag: 1788355697-740808
X-HE-Meta: U2FsdGVkX192UjPMiN7MHRgbUb2l0MtuYPLxaMJQYy6OaeWob6U4n4Uh7AYbGpvpCUNhRwdte5CJt71nywf97O3KjQb22th8enZHEERph5Yh5+9s58Qx3sBZu14E40i5mhV5LFtu7FtBAw4Wi2/61j1FlkwOPVFoOU+UaoaDkZx6yhiEJeLPZ7aKXFvRBkFhSgF4xHK8/klbALlnRjfFZLHuK3kOzQ0SG7cSIjR3V3hWzo/79lJOqSSd5tYY3sAsl+ZFKymWcgwDf8ECH2t/plTZA3RzXD7yrl8dONfcjN28RwKC+qoyfVthvIKTS8R7Jp/kLygXMBizT4mpRtekRgs2gEr+UfS3Fz4mgGR6ny4ijbOPmcgRRppjPH/6/QZOzDbgFAkhECsto4EjnI6cmnmSyi3LWFbT5RVnmjMevFfUqr2eKLjq+OL4GQVD5RcDCDo+heGr4YaA3WOgGzWXaESWS6jnQkz+ofIN4KreWSfY/VjzFpyBJ0uZt8AEWjq1Xd0qPSv7Fcm5tuRaSkDAAk93Wanbzj2uUDwM5xFpF6t+41PKM/Fjg8Hqi2pdK23MNb+OJrrMPp8fSfNunzc9bYVUCBiLlqUAyLMsUKTlrPGXUxoY2f/7akn0InS/WMgocJp34Z3efHj78+ZlsJoeO/OecwuXSjDaGaMT0XOeMzyHJ8EqTueK196sR7HH62yNxhxnmXvt3PgYKt1X6Bt/6ahrovPUqdCCHbHbXwFXRtvf+8rSXU23cFGkApFy1JXqkjR4obMMPKE10nz/c6uOwEsG3S+CVrP+2TwFZspVSdA7dHBx5nTbz4V6A33tA01lkUy+hJlP3D2PjsxJ7EXKdK8gsTP+yhtECxnAXfk7IMO+cvUmKogS+P0sth3mrPuSVu0MwMJWhKdYxaohGv+kk8gF0Io+xGRJuy6aZswVSB91LLeZAZzVnnmXfTxrbn8RPAH9boY0YKNI3TqWHWM
 rUuLYhcL
 Kq/FBvvZ+QCMgcvFB6FT7+byrkgqIZ7RX6UGv1XBmYa1GjZdPUBBqO2l9pUIQRuM40zh2UdH17s9cGKTuTzlvWt8uHXn8CkFeKzVf1yv0M/dW8GUDYgLxMR9kMwJO1h1n/fOV38WjVO9f0DJqZU2aQBhatJofXLLFACNuZjIqrUxsPOC76mmyPS0WqHj0zuBbg9IuBIaEMTZ49y0sc+EghEHz5GJucbZnHQeRPkuGo0OgeO5zJWM1IROy4DOgdCiL4cnfp3YKTBz7u1vqFx9YJxaD4kXQUzAWrqvpn7eqMqzHjxrmIVgHtVFcB6HIoaj5QnK7jTDbBt1RR8HZzaENXZyl2baWyKfOLxnk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a preload API that allows preallocating memory for XArray
insertions. This enables insertions to proceed without allocation
failures in contexts where memory allocation is not desirable, such as
in atomic contexts.

The implementation introduces `XArrayNode` representing a single XArray
node and `XArraySheaf` as a type alias for a sheaf of preallocated
nodes.

Add the function `xarray_kmem_cache` to provide access to the global XArray
node cache for creating sheaves.

Update `VacantEntry::insert` and `VacantEntry::insert_entry` to accept
an optional sheaf argument for preloaded memory. Add a new
`Guard::insert_entry` method for inserting with preload support. When an
insertion would fail due to ENOMEM, the XArray state API automatically
consumes a preallocated node from the sheaf if available.

Export `radix_tree_node_ctor` and `radix_tree_node_cachep` from C to
enable Rust code to work with the radix tree node cache.

Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Assisted-by: LLM
Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 include/linux/radix-tree.h      |   3 +
 lib/radix-tree.c                |   5 +-
 rust/bindings/bindings_helper.h |   3 +
 rust/kernel/xarray.rs           | 214 +++++++++++++++++++++++++++++++++++-----
 rust/kernel/xarray/entry.rs     |  27 +++--
 5 files changed, 215 insertions(+), 37 deletions(-)

diff --git a/include/linux/radix-tree.h b/include/linux/radix-tree.h
index eae67015ce51a..c3699f12b070c 100644
--- a/include/linux/radix-tree.h
+++ b/include/linux/radix-tree.h
@@ -469,4 +469,7 @@ static __always_inline void __rcu **radix_tree_next_slot(void __rcu **slot,
 	     slot = radix_tree_next_slot(slot, iter,			\
 				RADIX_TREE_ITER_TAGGED | tag))
 
+
+void radix_tree_node_ctor(void *arg);
+
 #endif /* _LINUX_RADIX_TREE_H */
diff --git a/lib/radix-tree.c b/lib/radix-tree.c
index 1cf0012b15ade..ddd67ce672f5c 100644
--- a/lib/radix-tree.c
+++ b/lib/radix-tree.c
@@ -33,6 +33,7 @@
  * Radix tree node cache.
  */
 struct kmem_cache *radix_tree_node_cachep;
+EXPORT_SYMBOL(radix_tree_node_cachep);
 
 /*
  * The radix tree is variable-height, so an insert operation not only has
@@ -1566,14 +1567,14 @@ void idr_destroy(struct idr *idr)
 }
 EXPORT_SYMBOL(idr_destroy);
 
-static void
-radix_tree_node_ctor(void *arg)
+void radix_tree_node_ctor(void *arg)
 {
 	struct radix_tree_node *node = arg;
 
 	memset(node, 0, sizeof(*node));
 	INIT_LIST_HEAD(&node->private_list);
 }
+EXPORT_SYMBOL(radix_tree_node_ctor);
 
 static int radix_tree_cpu_dead(unsigned int cpu)
 {
diff --git a/rust/bindings/bindings_helper.h b/rust/bindings/bindings_helper.h
index 5dda2bb36e3c2..ccbd92880dc88 100644
--- a/rust/bindings/bindings_helper.h
+++ b/rust/bindings/bindings_helper.h
@@ -132,6 +132,9 @@ const gfp_t RUST_CONST_HELPER_XA_FLAGS_ALLOC1 = XA_FLAGS_ALLOC1;
  * see https://github.com/rust-lang/rust-bindgen/issues/3347.
  */
 const size_t RUST_CONST_HELPER_XAS_RESTART = (size_t)XAS_RESTART;
+const size_t RUST_CONST_HELPER_XA_CHUNK_SHIFT = XA_CHUNK_SHIFT;
+const size_t RUST_CONST_HELPER_XA_CHUNK_SIZE = XA_CHUNK_SIZE;
+extern struct kmem_cache *radix_tree_node_cachep;
 
 const vm_flags_t RUST_CONST_HELPER_VM_MERGEABLE = VM_MERGEABLE;
 const vm_flags_t RUST_CONST_HELPER_VM_READ = VM_READ;
diff --git a/rust/kernel/xarray.rs b/rust/kernel/xarray.rs
index cf7248bddb8b9..87123ab96a92f 100644
--- a/rust/kernel/xarray.rs
+++ b/rust/kernel/xarray.rs
@@ -5,6 +5,7 @@
 //! C header: [`include/linux/xarray.h`](srctree/include/linux/xarray.h)
 
 use core::{
+    convert::Infallible,
     iter,
     marker::PhantomData,
     pin::Pin,
@@ -23,12 +24,18 @@
     bindings,
     build_assert::build_assert, //
     error::{
+        code::*,
         to_result,
         Error,
         Result, //
     },
     ffi::c_void,
     fmt,
+    mm::sheaf::{
+        KMemCache,
+        SBox,
+        StaticSheaf, //
+    },
     types::{
         ForeignOwnable,
         NotThreadSafe,
@@ -36,12 +43,63 @@
     },
 };
 use pin_init::{
+    init,
     pin_data,
     pin_init,
     pinned_drop,
+    Init,
     PinInit, //
 };
 
+/// Sheaf of preallocated [`XArray`] nodes.
+pub type XArraySheaf<'a> = StaticSheaf<'a, XArrayNode>;
+
+/// Returns a reference to the global XArray node cache.
+///
+/// This provides access to the kernel's `radix_tree_node_cachep`, which is the
+/// slab cache used for allocating internal XArray nodes. This cache can be used
+/// to create sheaves for preallocating XArray nodes.
+pub fn xarray_kmem_cache() -> &'static KMemCache<XArrayNode> {
+    // SAFETY: `radix_tree_node_cachep` is a valid, statically initialized
+    // kmem_cache that remains valid for the lifetime of the kernel. The cache
+    // is configured for `xa_node` objects which match our `XArrayNode` type.
+    unsafe { KMemCache::from_raw(bindings::radix_tree_node_cachep) }
+}
+
+/// An preallocated XArray node.
+///
+/// This represents a single preallocated internal node for an XArray.
+///
+/// This type is `#[repr(transparent)]` as it is cast to and from pointers to
+/// the inner [`bindings::xa_node`].
+#[repr(transparent)]
+pub struct XArrayNode {
+    node: Opaque<bindings::xa_node>,
+}
+
+// SAFETY: A preallocated `xa_node` is opaque storage for the C XArray
+// implementation, which moves nodes between CPUs freely. It is not tied to
+// the thread that allocated it.
+unsafe impl Send for XArrayNode {}
+
+impl kernel::mm::sheaf::KMemCacheInit<XArrayNode> for XArrayNode {
+    fn init() -> impl Init<Self, Infallible> {
+        init!(Self {
+            // SAFETY:
+            // - This initialization cannot fail and will never return `Err`.
+            // - The xa_node does not move during initialization.
+            node <- unsafe {
+                pin_init::init_from_closure(
+                    |place: *mut Opaque<bindings::xa_node>| -> Result<(), Infallible> {
+                        bindings::radix_tree_node_ctor(place.cast::<c_void>());
+                        Ok(())
+                    },
+                )
+            }
+        })
+    }
+}
+
 /// An array which efficiently maps sparse integer indices to owned objects.
 ///
 /// This is similar to a [`crate::alloc::kvec::Vec<Option<T>>`], but more efficient when there are
@@ -138,15 +196,22 @@ fn iter(&self) -> impl Iterator<Item = NonNull<c_void>> + '_ {
         let mut index = 0;
 
         // SAFETY: `self.xa` is always valid by the type invariant.
-        iter::once(unsafe {
-            bindings::xa_find(self.xa.get(), &mut index, usize::MAX, bindings::XA_PRESENT)
-        })
-        .chain(iter::from_fn(move || {
-            // SAFETY: `self.xa` is always valid by the type invariant.
-            Some(unsafe {
-                bindings::xa_find_after(self.xa.get(), &mut index, usize::MAX, bindings::XA_PRESENT)
-            })
-        }))
+        Iterator::chain(
+            iter::once(unsafe {
+                bindings::xa_find(self.xa.get(), &mut index, usize::MAX, bindings::XA_PRESENT)
+            }),
+            iter::from_fn(move || {
+                // SAFETY: `self.xa` is always valid by the type invariant.
+                Some(unsafe {
+                    bindings::xa_find_after(
+                        self.xa.get(),
+                        &mut index,
+                        usize::MAX,
+                        bindings::XA_PRESENT,
+                    )
+                })
+            }),
+        )
         .map_while(|ptr| NonNull::new(ptr.cast()))
     }
 
@@ -167,7 +232,6 @@ pub fn try_lock(&self) -> Option<Guard<'_, T>> {
     pub fn lock(&self) -> Guard<'_, T> {
         // SAFETY: `self.xa` is always valid by the type invariant.
         unsafe { bindings::xa_lock(self.xa.get()) };
-
         Guard {
             xa: self,
             _not_send: NotThreadSafe,
@@ -269,7 +333,7 @@ pub fn get_mut(&mut self, index: usize) -> Option<T::BorrowedMut<'_>> {
     ///
     /// match guard.entry(42) {
     ///     Entry::Vacant(entry) => {
-    ///         entry.insert(KBox::new(0x1337u32, GFP_KERNEL)?)?;
+    ///         entry.insert(KBox::new(0x1337u32, GFP_ATOMIC)?, None)?;
     ///     }
     ///     Entry::Occupied(_) => unreachable!("We did not insert an entry yet"),
     /// }
@@ -468,6 +532,45 @@ pub fn store(
             Ok(unsafe { T::try_from_foreign(old) })
         }
     }
+
+    /// Inserts a value and returns an occupied entry for further operations.
+    ///
+    /// If a value is already present, the operation fails.
+    ///
+    /// This method will not drop the XArray lock. If memory allocation is
+    /// required for the operation to succeed, the user should supply memory
+    /// through the `preload` argument.
+    ///
+    /// # Examples
+    ///
+    /// ```
+    /// # use kernel::{prelude::*, xarray::{AllocKind, XArray}};
+    /// let mut xa = KBox::pin_init(XArray::<KBox<u32>>::new(AllocKind::Alloc), GFP_KERNEL)?;
+    /// let mut guard = xa.lock();
+    ///
+    /// assert_eq!(guard.get(42), None);
+    ///
+    /// let value = KBox::new(0x1337u32, GFP_ATOMIC)?;
+    /// let entry = guard.insert_entry(42, value, None)?;
+    /// let borrowed = entry.into_mut();
+    /// assert_eq!(borrowed, &0x1337);
+    ///
+    /// # Ok::<(), kernel::error::Error>(())
+    /// ```
+    pub fn insert_entry<'b>(
+        &'b mut self,
+        index: usize,
+        value: T,
+        preload: Option<&mut XArraySheaf<'_>>,
+    ) -> Result<OccupiedEntry<'a, 'b, T>, StoreError<T>> {
+        match self.entry(index) {
+            Entry::Vacant(entry) => entry.insert_entry(value, preload),
+            Entry::Occupied(_) => Err(StoreError {
+                error: EBUSY,
+                value,
+            }),
+        }
+    }
 }
 
 /// Internal state for XArray iteration and entry operations.
@@ -485,6 +588,30 @@ pub(crate) struct XArrayState<R> {
     state: bindings::xa_state,
 }
 
+impl<R> Drop for XArrayState<R> {
+    fn drop(&mut self) {
+        free_xa_alloc(&mut self.state);
+    }
+}
+
+fn free_xa_alloc(state: &mut bindings::xa_state) {
+    if !state.xa_alloc.is_null() {
+        // SAFETY:
+        // - `xa_alloc` is only set via `SBox::into_ptr()` in `insert()` where
+        //   the node comes from an `XArraySheaf` backed by `radix_tree_node_cachep`.
+        // - `xa_alloc` points to a valid, initialized `XArrayNode`.
+        // - The caller has exclusive ownership of `xa_alloc`, and no other
+        //   `SBox` or reference exists for this value.
+        drop(unsafe {
+            SBox::<XArrayNode>::static_from_ptr(
+                bindings::radix_tree_node_cachep,
+                state.xa_alloc.cast(),
+            )
+        });
+        state.xa_alloc = null_mut();
+    }
+}
+
 impl<'a, R, T> XArrayState<R>
 where
     T: ForeignOwnable + 'a,
@@ -595,23 +722,50 @@ fn replace(&mut self, new: *mut c_void) -> *mut c_void {
         old
     }
 
-    fn insert(&mut self, value: T) -> Result<*mut c_void, StoreError<T>> {
+    fn insert(
+        &mut self,
+        value: T,
+        mut preload: Option<&mut XArraySheaf<'_>>,
+    ) -> Result<*mut c_void, StoreError<T>> {
         let new = T::into_foreign(value).cast();
 
-        // SAFETY: `self.state` is a valid `xa_state` by the type invariant. By the same
-        // invariant, `self.state.xa` aliases the xarray reachable through `self.guard`,
-        // whose lock we hold. `new` came from `T::into_foreign`.
-        unsafe { bindings::xas_store(&mut self.state, new) };
-
-        // All arrays created by this abstraction have `XA_FLAGS_TRACK_FREE` set, so the
-        // free mark must be cleared for a newly occupied index, as `__xa_store` does.
-        // This is a no-op if the store above failed.
-        //
-        // SAFETY: `self.state` is a valid `xa_state` by the type invariant, and we hold
-        // the lock on the xarray it refers to.
-        unsafe { bindings::xas_clear_mark(&self.state, bindings::XA_FREE_MARK) };
+        loop {
+            // SAFETY: `self.state` is a valid `xa_state` by the type invariant. By the same
+            // invariant, `self.state.xa` aliases the xarray reachable through `self.guard`,
+            // whose lock we hold. `new` came from `T::into_foreign`.
+            unsafe { bindings::xas_store(&mut self.state, new) };
 
-        self.status().map(|()| new).map_err(|error| {
+            // All arrays created by this abstraction have `XA_FLAGS_TRACK_FREE` set, so the
+            // free mark must be cleared for a newly occupied index, as `__xa_store` does.
+            // This is a no-op if the store above failed.
+            //
+            // SAFETY: `self.state` is a valid `xa_state` by the type invariant, and we hold
+            // the lock on the xarray it refers to.
+            unsafe { bindings::xas_clear_mark(&self.state, bindings::XA_FREE_MARK) };
+
+            match self.status() {
+                Ok(()) => break Ok(new),
+                Err(ENOMEM) => {
+                    debug_assert!(self.state.xa_alloc.is_null());
+                    let node = match preload.as_mut().map(|sheaf| sheaf.alloc().ok_or(ENOMEM)) {
+                        None => break Err(ENOMEM),
+                        Some(Err(e)) => break Err(e),
+                        Some(Ok(node)) => node,
+                    };
+
+                    self.state.xa_alloc = node.into_ptr().cast();
+
+                    // On allocation failure, `xas_store` leaves `XA_ERROR(-ENOMEM)` in
+                    // `self.state.xa_node`, which makes further operations on the state fail
+                    // immediately without consuming `xa_alloc`. Reset the state so the retry
+                    // walks the tree again, as `xas_nomem` does.
+                    self.restart_at(self.state.xa_index);
+                    continue;
+                }
+                Err(e) => break Err(e),
+            }
+        }
+        .map_err(|error| {
             // SAFETY: `new` came from `T::into_foreign` and `xas_store` does not take
             // ownership of the value on error.
             let value = unsafe { T::from_foreign(new) };
@@ -619,10 +773,16 @@ fn insert(&mut self, value: T) -> Result<*mut c_void, StoreError<T>> {
         })
     }
 
-    /// Consumes `self` and returns the inner `&mut Guard`.
+    /// Consumes `self`, releases any preallocated node held in `xa_alloc`, and
+    /// returns the inner `&mut Guard`.
     #[inline]
     pub(crate) fn into_guard(self) -> &'b mut Guard<'a, T> {
-        self.guard
+        // Suppress the `Drop` impl so we can move `guard` out by hand.
+        let mut this = core::mem::ManuallyDrop::new(self);
+        free_xa_alloc(&mut this.state);
+        // SAFETY: `ManuallyDrop` prevents `Drop::drop` from running, so this is the only place
+        // that consumes `guard`. `state` has no other resources after `free_xa_alloc`.
+        unsafe { core::ptr::read(&this.guard) }
     }
 }
 
diff --git a/rust/kernel/xarray/entry.rs b/rust/kernel/xarray/entry.rs
index c6c5385e6b4f9..bd295358d9751 100644
--- a/rust/kernel/xarray/entry.rs
+++ b/rust/kernel/xarray/entry.rs
@@ -3,6 +3,7 @@
 use super::{
     Guard,
     StoreError,
+    XArraySheaf,
     XArrayState, //
 };
 use core::ptr::NonNull;
@@ -75,7 +76,8 @@ pub fn into_guard(self) -> &'b mut Guard<'a, T> {
     /// Returns a reference to the newly inserted value.
     ///
     /// - This method will fail if the nodes on the path to the index
-    ///   represented by this entry are not present in the XArray.
+    ///   represented by this entry are not present in the XArray and no memory
+    ///   is available via the `preload` argument.
     /// - This method will not drop the XArray lock.
     ///
     ///
@@ -90,7 +92,7 @@ pub fn into_guard(self) -> &'b mut Guard<'a, T> {
     ///
     /// if let Entry::Vacant(entry) = guard.entry(42) {
     ///     let value = KBox::new(0x1337u32, GFP_ATOMIC)?;
-    ///     let borrowed = entry.insert(value)?;
+    ///     let borrowed = entry.insert(value, None)?;
     ///     assert_eq!(*borrowed, 0x1337);
     /// }
     ///
@@ -98,8 +100,12 @@ pub fn into_guard(self) -> &'b mut Guard<'a, T> {
     ///
     /// # Ok::<(), kernel::error::Error>(())
     /// ```
-    pub fn insert(mut self, value: T) -> Result<T::BorrowedMut<'b>, StoreError<T>> {
-        let new = self.state.insert(value)?;
+    pub fn insert(
+        mut self,
+        value: T,
+        preload: Option<&mut XArraySheaf<'_>>,
+    ) -> Result<T::BorrowedMut<'b>, StoreError<T>> {
+        let new = self.state.insert(value, preload)?;
 
         // SAFETY: `new` came from `T::into_foreign`. The entry has exclusive
         // ownership of `new` as it holds a mutable reference to `Guard`.
@@ -109,7 +115,8 @@ pub fn insert(mut self, value: T) -> Result<T::BorrowedMut<'b>, StoreError<T>> {
     /// Inserts a value and returns an occupied entry representing the newly inserted value.
     ///
     /// - This method will fail if the nodes on the path to the index
-    ///   represented by this entry are not present in the XArray.
+    ///   represented by this entry are not present in the XArray and no memory
+    ///   is available via the `preload` argument.
     /// - This method will not drop the XArray lock.
     ///
     /// # Examples
@@ -123,7 +130,7 @@ pub fn insert(mut self, value: T) -> Result<T::BorrowedMut<'b>, StoreError<T>> {
     ///
     /// if let Entry::Vacant(entry) = guard.entry(42) {
     ///     let value = KBox::new(0x1337u32, GFP_ATOMIC)?;
-    ///     let occupied = entry.insert_entry(value)?;
+    ///     let occupied = entry.insert_entry(value, None)?;
     ///     assert_eq!(occupied.index(), 42);
     /// }
     ///
@@ -131,8 +138,12 @@ pub fn insert(mut self, value: T) -> Result<T::BorrowedMut<'b>, StoreError<T>> {
     ///
     /// # Ok::<(), kernel::error::Error>(())
     /// ```
-    pub fn insert_entry(mut self, value: T) -> Result<OccupiedEntry<'a, 'b, T>, StoreError<T>> {
-        let new = self.state.insert(value)?;
+    pub fn insert_entry(
+        mut self,
+        value: T,
+        preload: Option<&mut XArraySheaf<'_>>,
+    ) -> Result<OccupiedEntry<'a, 'b, T>, StoreError<T>> {
+        let new = self.state.insert(value, preload)?;
 
         Ok(OccupiedEntry::<'a, 'b, T> {
             state: self.state,

-- 
2.51.2



