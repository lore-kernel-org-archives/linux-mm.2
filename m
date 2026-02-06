Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24CA8EE6B5E
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 21:12:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 90AF76B009B; Fri,  6 Feb 2026 16:12:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8EC7D6B009D; Fri,  6 Feb 2026 16:12:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 80BC66B009E; Fri,  6 Feb 2026 16:12:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6BE276B009B
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 16:12:04 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 39CD558660
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 21:12:04 +0000 (UTC)
X-FDA: 84415279368.30.7C85241
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 69436180009
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 21:12:02 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WpmicoAy;
	spf=pass (imf16.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770412322;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CLpkaaFnD9ss2VGf6NU3YUDOtbf6caA7jDyE19LOdyU=;
	b=waWXpmdll0HUqKnGRyn/scf5TaJfJPp9oLaC1feNswra2MgSn4TRGxHJhRW5JtOC1afZuk
	Ph+ayIrmcya6Ljbowk3qAVEhWSzOrJheU9Z7JTStktH1s+yREVdo0XAaIZDfz2HJQHjSYC
	rr2D23dl8+8wLmjh3AwdW2WXKmiidKg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770412322; a=rsa-sha256;
	cv=none;
	b=8ludCNrQtbBVHLke5OHwmBguIln7j7QE6fNd/+am06ni8u0YFw95zo2v6NH902eCP4uUnt
	xy4DZ7jXRUysWJpP4NM9fC3HuuFjOInrcFmhxuEfYj+EqyVdsC3JP4ZVwMy6mBIUoBA9kr
	TcB6REE91knda5mj3U13NJNA/+71zv8=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WpmicoAy;
	spf=pass (imf16.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B56566014F;
	Fri,  6 Feb 2026 21:12:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC971C116C6;
	Fri,  6 Feb 2026 21:11:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770412321;
	bh=AC4NCWQlfHS+3umvfHK9M7bjjDtFlC6otCKn7IFTKu4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=WpmicoAyOeKMjQbPko5tQxJ5PHYWJdWZJSDHlu48rE5FmgmWXT81IpsJEFiBduXjR
	 k47q8v+tUvVKHT5cdzemTzV+S3KVj1b4tF+HLmD2jKGhRzdleSxb9EouITUPIwa7fo
	 15LtLv4b16pnt9D0xW0CC54xNJQM4zvmwr1Z2jmgbLESlDX2YMygCBDMcsgO59cfd+
	 icUi1evSQxeUK0y58ugkXLBlj5ouIBtTKB75yHZVkuyxFt8mNA9sRItrHbWlwXNmj8
	 y32X0YnKfXQdAcRJrr6yYPWCnZ5g2Z4Ji7gR6jUtD9VQ/uQSGCZksim2tZg72idMjd
	 KRBu7O2cG7RwQ==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Fri, 06 Feb 2026 22:10:57 +0100
Subject: [PATCH v2 11/11] rust: xarray: add preload API
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260206-xarray-entry-send-v2-11-91c41673fd30@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=17136;
 i=a.hindborg@kernel.org; h=from:subject:message-id;
 bh=AC4NCWQlfHS+3umvfHK9M7bjjDtFlC6otCKn7IFTKu4=;
 b=owEBbQKS/ZANAwAKAeG4Gj55KGN3AcsmYgBphljqWbK6JVOB8Dx84iCFFrCbId0d2R0MkNmZS
 4n6fEjxBVGJAjMEAAEKAB0WIQQSwflHVr98KhXWwBLhuBo+eShjdwUCaYZY6gAKCRDhuBo+eShj
 d9HUD/9sT3Dt5h9Ne4yUU3D2G/PVRBEHLzC3kwVweot4CzkGrdTlPPlxfZfiQGCGgcrtxkIyg6Q
 0vqvdlLRsjiCDOE5DljzjyyaI0LdfMODOhKFZRcdowmquevCX+T1+yL2icu2LxsoT0/d6LiUEiD
 AKu5dRn/05+l9kMtsT6fVqw/tzSV3a/OjGfw64JXDCGX2byE+fnJNw9jrtRB41de4D36DKpVxtX
 3g1RUDpdpmEAPQa+6VqZy5Yj8qywIM8kdJjcRe1UEh6ICq0SJhqY406WMYjumk55TBff9Fs37eT
 Q5yotLmTBv03wRfqN9nc5lzmKijn3LHHTvr1NCOYfQEe8myKlzexkvdSa1V89rnx9ZUoKu7lRIh
 Is1pSkdLR7UKknSebRu0r8WqyscEABZUt0Y8vAp3wUsjSMUMM2qfJirwGyxKmLAPm7S0QMwG1V6
 SXkmIwUXAPtiovVUVLH8/TFHARkXVyBAjqlyHAQj+ygsb/T8wYd14GctMLciUxlwMde0Qd452JU
 ITvK/JufwLAfBHfbKDO8BihSIf2zwF3KhMfeHSZl+ExSGzKuzKdEP5r/w+3esOe2yhwO1ttxSWH
 +++hQ5XmwM8CKBvWzU92x9SX31/5DbAog4IVN3Hc6saHTgAn10gN6ritFtxa53nxKeIbDOcrcXM
 FeLsi3EUXVQdsmQ==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Queue-Id: 69436180009
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: zhpkjgaiuwu4tzhao1xcgtcbhrydhgsh
X-HE-Tag: 1770412322-445314
X-HE-Meta: U2FsdGVkX19wON8hnWK/DQ2p779YbKFxJPN5mzzqZ8xHfP0gY2PE+kSkUh+YEJGpYWNR+UG5W9hlI6XtiCckVEoqH6QfnYqT8ghhtf6R/8nizczIwUag5xHTmO62OxjB3bvawdq3Ao8StSCHT01n9GfZpVgF1CZZ5W4Gx14g7uBEMzCTEhyIJyoK7CkVL6nqIJvLit/ezIwqZOObp6AOK5yoS/ZsrxU+gfhbEkqTUqOtCm1nJSxzP1ppj/+qIWxrdR/5nxWazr1zPJnGV5orLVoncYet0ZC1pv3ZU60TO2pP7tGnBXkCmuGqBcS+vnDcgLdDgM8azYgNenMcqCBD/BEDO/IVH0tfP7Y4EgScPf6o9WRxhfKAHrT3t1DhbdcfOkrkkBH5RW7SbtruLXK8bMeNHtwlC8hasjKNl65cp+mATJxvG2rrjedbfxMTX1esHyS2ls10g5adnoVF5wK1HtGsJSbSp/TqohDDIMd8Y/+k9oW4c34Lb8vTXLzAuHloAl0K+rTJda5wwasXwdln87nLTORe14vmc34IBfW6orxVp9fziJ0jLhEI3MGjmwxg+8w+Xqbe9w/y7c/l6cUs16osQxUY6U1n4H4UahARfScemFrbUABGp1B+HXEdMxjwNZOCEbjaiV1ONkK0vI1QTHc89yUAyy5z1Ixetu7xPcHxAAm6ynRA9O2epypTVG3PqI+Bg6mKaWaiaA0RVQBbyHax42ouV1J0PNsYnF1hM+P872gSy58wU6QMQiRvgxuZmgaIGE2/x2hUupOkfzdRfTj6SO8eMyN//8co9k7II6M6XY/oKmsvMZse9wYq7O+PYBIfz+z1cvUog0mG/AtNGDMZQTL+qHOtjGVDT/J700PcBS79ZFT2ZVUVwysNO5U8K6WKUNHDsNR10KTSadGGWiuG6Pt8wqlrJx3h0oVA9VOnurnNv0qlpa++nNcP/81CJrkE7OOyJ2DIBotYrLr
 QzKHMP06
 249RS1aD/hq51CFI/ab4WU0xFEjuG4/14J1U5Gq2s4dU0xqPFBLabvhbw+6c4H0QZcbclaAziUg4Jfadc2qXK8kfmRt22sR7sRIuSDYvI96PTYuttPfJ6YomIaThSrPE3sHTjm0dZ15ougZE82v9UCQNjhzghapPhbsCuaQu2B+5niRqbSMTWEA2y6PP680ckl/xa4IWLKbOmlpZoYZgAa1Rf3G9sp+TwPGoEVLNS90CDUQvFyomdIOna4+Y8Jzu1pdBblK4OH2dOrfICZLfOxVEmuRHU4CrA7UjOgWv+LnsuEJE0UpdDmyF6LKlFY9qpxmSKSI/HDOcotILyz7QqGNfNRbuynQ/shR5JtAl2S/4g+rABQFWnzCtJVH8BVMsSNQmvlcRF/e+EU4I=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a preload API that allows preallocating memory for XArray
insertions. This enables insertions to proceed without allocation
failures in contexts where memory allocation is not desirable, such as
in atomic contexts or where reliability is critical.

The API includes:

- `XArrayPreloadBuffer` for managing a pool of preallocated nodes.
- `XArrayPreloadNode` representing a single preallocated node.
- Integration with the entry API, allowing `VacantEntry::insert` and
  `VacantEntry::insert_entry` to accept an optional preload buffer.
- A new `Guard::insert_entry` method for inserting with preload support.

The implementation uses a circular buffer to efficiently manage
preallocated nodes. When an insertion would fail due to ENOMEM, the
XArray state API automatically consumes a preallocated node from the
buffer if available.

Export `radix_tree_node_ctor` from C to enable Rust code to work with the
radix tree node cache.

Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 include/linux/radix-tree.h      |   3 +
 lib/radix-tree.c                |   5 +-
 rust/bindings/bindings_helper.h |   3 +
 rust/kernel/xarray.rs           | 172 +++++++++++++++++++++++++++++++++++-----
 rust/kernel/xarray/entry.rs     |  29 ++++---
 rust/kernel/xarray/preload.rs   |   3 +
 6 files changed, 185 insertions(+), 30 deletions(-)

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
index 976b9bd02a1b5..b642f2775e89c 100644
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
index 58605c32e8102..652f08ad888cd 100644
--- a/rust/bindings/bindings_helper.h
+++ b/rust/bindings/bindings_helper.h
@@ -118,6 +118,9 @@ const xa_mark_t RUST_CONST_HELPER_XA_PRESENT = XA_PRESENT;
 const gfp_t RUST_CONST_HELPER_XA_FLAGS_ALLOC = XA_FLAGS_ALLOC;
 const gfp_t RUST_CONST_HELPER_XA_FLAGS_ALLOC1 = XA_FLAGS_ALLOC1;
 const size_t RUST_CONST_HELPER_XAS_RESTART = (size_t)XAS_RESTART;
+const size_t RUST_CONST_HELPER_XA_CHUNK_SHIFT = XA_CHUNK_SHIFT;
+const size_t RUST_CONST_HELPER_XA_CHUNK_SIZE = XA_CHUNK_SIZE;
+extern struct kmem_cache *radix_tree_node_cachep;
 
 const vm_flags_t RUST_CONST_HELPER_VM_MERGEABLE = VM_MERGEABLE;
 const vm_flags_t RUST_CONST_HELPER_VM_READ = VM_READ;
diff --git a/rust/kernel/xarray.rs b/rust/kernel/xarray.rs
index 8c10e8fd76f15..89bf531308c88 100644
--- a/rust/kernel/xarray.rs
+++ b/rust/kernel/xarray.rs
@@ -5,6 +5,7 @@
 //! C header: [`include/linux/xarray.h`](srctree/include/linux/xarray.h)
 
 use core::{
+    convert::Infallible,
     iter,
     marker::PhantomData,
     pin::Pin,
@@ -23,11 +24,17 @@
     bindings,
     build_assert, //
     error::{
+        code::*,
         to_result,
         Error,
         Result, //
     },
     ffi::c_void,
+    mm::sheaf::{
+        KMemCache,
+        SBox,
+        StaticSheaf, //
+    },
     types::{
         ForeignOwnable,
         NotThreadSafe,
@@ -35,12 +42,54 @@
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
+pub struct XArrayNode {
+    node: Opaque<bindings::xa_node>,
+}
+
+impl kernel::mm::sheaf::KMemCacheInit<XArrayNode> for XArrayNode {
+    fn init() -> impl Init<Self, Infallible> {
+        init!(Self {
+            // SAFETY:
+            // - This initialization cannot fail and will never return `Err`.
+            // - The xa_node does not move during initalization.
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
@@ -137,15 +186,22 @@ fn iter(&self) -> impl Iterator<Item = NonNull<c_void>> + '_ {
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
 
@@ -166,7 +222,6 @@ pub fn try_lock(&self) -> Option<Guard<'_, T>> {
     pub fn lock(&self) -> Guard<'_, T> {
         // SAFETY: `self.xa` is always valid by the type invariant.
         unsafe { bindings::xa_lock(self.xa.get()) };
-
         Guard {
             xa: self,
             _not_send: NotThreadSafe,
@@ -270,7 +325,7 @@ pub fn get_mut(&mut self, index: usize) -> Option<T::BorrowedMut<'_>> {
     ///
     /// match guard.entry(42) {
     ///     Entry::Vacant(entry) => {
-    ///         entry.insert(KBox::new(0x1337u32, GFP_KERNEL)?)?;
+    ///         entry.insert(KBox::new(0x1337u32, GFP_KERNEL)?, None)?;
     ///     }
     ///     Entry::Occupied(_) => unreachable!("We did not insert an entry yet"),
     /// }
@@ -475,6 +530,45 @@ pub fn store(
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
+    /// let value = KBox::new(0x1337u32, GFP_KERNEL)?;
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
@@ -489,6 +583,25 @@ pub(crate) struct XArrayState<'a, 'b, T: ForeignOwnable> {
     state: bindings::xa_state,
 }
 
+impl<'a, 'b, T: ForeignOwnable> Drop for XArrayState<'a, 'b, T> {
+    fn drop(&mut self) {
+        if !self.state.xa_alloc.is_null() {
+            // SAFETY:
+            // - `xa_alloc` is only set via `SBox::into_ptr()` in `insert()` where
+            //   the node comes from an `XArraySheaf` backed by `radix_tree_node_cachep`.
+            // - `xa_alloc` points to a valid, initialized `XArrayNode`.
+            // - `XArrayState` has exclusive ownership of `xa_alloc`, and no other
+            //   `SBox` or reference exists for this value.
+            drop(unsafe {
+                SBox::<XArrayNode>::static_from_ptr(
+                    bindings::radix_tree_node_cachep,
+                    self.state.xa_alloc.cast(),
+                )
+            })
+        }
+    }
+}
+
 impl<'a, 'b, T: ForeignOwnable> XArrayState<'a, 'b, T> {
     fn new(access: &'b Guard<'a, T>, index: usize) -> Self {
         let ptr = access.xa.xa.get();
@@ -529,16 +642,37 @@ fn status(&self) -> Result {
         to_result(unsafe { bindings::xas_error(&self.state) })
     }
 
-    fn insert(&mut self, value: T) -> Result<*mut c_void, StoreError<T>> {
+    fn insert(
+        &mut self,
+        value: T,
+        mut preload: Option<&mut XArraySheaf<'_>>,
+    ) -> Result<*mut c_void, StoreError<T>> {
         let new = T::into_foreign(value).cast();
 
-        // SAFETY: `self.state.state` is properly initialized and `new` came from `T::into_foreign`.
-        // We hold the xarray lock.
-        unsafe { bindings::xas_store(&mut self.state, new) };
-
-        self.status().map(|()| new).map_err(|error| {
-            // SAFETY: `new` came from `T::into_foreign` and `xas_store` does not take ownership of
-            // the value on error.
+        loop {
+            // SAFETY: `self.state` is properly initialized and `new` came from
+            // `T::into_foreign`. We hold the xarray lock.
+            unsafe { bindings::xas_store(&mut self.state, new) };
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
+                    continue;
+                }
+                Err(e) => break Err(e),
+            }
+        }
+        .map_err(|error| {
+            // SAFETY: `new` came from `T::into_foreign` and `xas_store` does not take
+            // ownership of the value on error.
             let value = unsafe { T::from_foreign(new) };
             StoreError { value, error }
         })
diff --git a/rust/kernel/xarray/entry.rs b/rust/kernel/xarray/entry.rs
index 1b1c21bed7022..ff500be3832b7 100644
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
@@ -29,9 +30,9 @@ impl<T: ForeignOwnable> Entry<'_, '_, T> {
     /// let mut xa = KBox::pin_init(XArray::<KBox<u32>>::new(AllocKind::Alloc), GFP_KERNEL)?;
     /// let mut guard = xa.lock();
     ///
-    ///
     /// let entry = guard.entry(42);
     /// assert_eq!(entry.is_occupied(), false);
+    /// drop(entry);
     ///
     /// guard.store(42, KBox::new(0x1337u32, GFP_KERNEL)?, GFP_KERNEL)?;
     /// let entry = guard.entry(42);
@@ -64,7 +65,8 @@ pub(crate) fn new(guard: &'b mut Guard<'a, T>, index: usize) -> Self {
     /// Returns a reference to the newly inserted value.
     ///
     /// - This method will fail if the nodes on the path to the index
-    ///   represented by this entry are not present in the XArray.
+    ///   represented by this entry are not present in the XArray and no memory
+    ///   is available via the `preload` argument.
     /// - This method will not drop the XArray lock.
     ///
     ///
@@ -79,7 +81,7 @@ pub(crate) fn new(guard: &'b mut Guard<'a, T>, index: usize) -> Self {
     ///
     /// if let Entry::Vacant(entry) = guard.entry(42) {
     ///     let value = KBox::new(0x1337u32, GFP_KERNEL)?;
-    ///     let borrowed = entry.insert(value)?;
+    ///     let borrowed = entry.insert(value, None)?;
     ///     assert_eq!(*borrowed, 0x1337);
     /// }
     ///
@@ -87,8 +89,12 @@ pub(crate) fn new(guard: &'b mut Guard<'a, T>, index: usize) -> Self {
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
@@ -98,7 +104,8 @@ pub fn insert(mut self, value: T) -> Result<T::BorrowedMut<'b>, StoreError<T>> {
     /// Inserts a value and returns an occupied entry representing the newly inserted value.
     ///
     /// - This method will fail if the nodes on the path to the index
-    ///   represented by this entry are not present in the XArray.
+    ///   represented by this entry are not present in the XArray and no memory
+    ///   is available via the `preload` argument.
     /// - This method will not drop the XArray lock.
     ///
     /// # Examples
@@ -112,7 +119,7 @@ pub fn insert(mut self, value: T) -> Result<T::BorrowedMut<'b>, StoreError<T>> {
     ///
     /// if let Entry::Vacant(entry) = guard.entry(42) {
     ///     let value = KBox::new(0x1337u32, GFP_KERNEL)?;
-    ///     let occupied = entry.insert_entry(value)?;
+    ///     let occupied = entry.insert_entry(value, None)?;
     ///     assert_eq!(occupied.index(), 42);
     /// }
     ///
@@ -120,8 +127,12 @@ pub fn insert(mut self, value: T) -> Result<T::BorrowedMut<'b>, StoreError<T>> {
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
diff --git a/rust/kernel/xarray/preload.rs b/rust/kernel/xarray/preload.rs
new file mode 100644
index 0000000000000..745709579a265
--- /dev/null
+++ b/rust/kernel/xarray/preload.rs
@@ -0,0 +1,3 @@
+// SPDX-License-Identifier: GPL-2.0
+
+use kernel::prelude::*;

-- 
2.51.2



