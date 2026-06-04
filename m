Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC749CD6E6E
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 19:59:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3171E6B0088; Thu,  4 Jun 2026 15:59:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2EEB76B008A; Thu,  4 Jun 2026 15:59:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 205BB6B008C; Thu,  4 Jun 2026 15:59:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0D9DF6B0088
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 15:59:39 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A705F401FF
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 19:59:38 +0000 (UTC)
X-FDA: 84843295236.27.2501FB0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id C2E001C0013
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 19:59:36 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SwmGOfJA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780603176;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jWkyJgBS4U3MzwhYPxW5jTWMJGrf1Kb2DOah+vODPh8=;
	b=c9ClmxSlduw+BXLeWttNS5xlIOISgnbcyQLhxPP5grA8oTXluKMQ3jDW960lllO+oSWbtP
	dTDQSiQKxm6+ZG57OmkD7qEhZ7z7UuDvPcE/knw9f8u3NMyA/aYJMuS7FFwAkd8bUy9Y4p
	x3ULySNzVmO5A1d96voC4kO0Lu+Ectw=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SwmGOfJA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780603176;
	b=GdiZrpVAL6Ge4Nevnmtiq424z6e+5Fzrqjo2PMmZglUy08q3H2a02SO+g49+y50Ms6x/lm
	2ztInoFfgOUQa0kPFcpgjQMsS03ba+yvlgegf/n3pkLUQKT5w+REYcbbPiIAMjazmL3Wlz
	EzxRgCCO4uIU7Amxt/SDS9Hn7CBEFfo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1F6FA400E2;
	Thu,  4 Jun 2026 19:59:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5229D1F00898;
	Thu,  4 Jun 2026 19:59:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780603176;
	bh=jWkyJgBS4U3MzwhYPxW5jTWMJGrf1Kb2DOah+vODPh8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=SwmGOfJAmda6pxHHfbwxN4QpX7lHcecQl9WPU7ZRNOQcD9QEPagTkPpG81/6KWpxm
	 fEiqU1PA2h/OC3JpyN+cE20V/hCbhb79VngotsIUSbG3+pPjBRES1oJMQWqRHzI8Fu
	 R4ipfNjA3kv6Bq1SST9Au/THTYq/qeoTLyMc40Aj/mbbDYIoe4pTAc608QdNrqn8YI
	 6kr2fnhJuvw9EoWVO2qpl2MhSAgCdy4IG6NDQdfkMaTTo7xE9x/UFUGN8i18MANKCv
	 SXt7le9RztLatnjNXN2B45UPwgwgwV+45bVY2spuwZ7/giMcZy1n/JVpCF8DqlW4YA
	 n5SECd7VL7oiQ==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Thu, 04 Jun 2026 21:58:17 +0200
Subject: [PATCH v4 11/11] rust: xarray: add preload API
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260604-xarray-entry-send-v4-11-965f6028790e@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=17687;
 i=a.hindborg@kernel.org; h=from:subject:message-id;
 bh=5COargo+4lqjh4Cb4xJSNaFVbCtXU6TNlsW5EcI7kwI=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBqIdjzic/WbeAMQSxtT5hfJijfLPo7w6j7pTmzh
 Fy4wKo9qzGJAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCaiHY8wAKCRD6UCkIqsW9
 0Dz5D/9Hmp7Kqfhv3++IqPtm6wInDWzXBbkl7sElLgvTOgLHcVB4+2BOmABfRb7FwjWNwODY2nb
 rIS8GSWSUO1OVGsj2Srq31QdQikeaRtpUd18P0WJD+GTZGrhrxsQs7buCt89l+9lixtmKsK3Eet
 TGVKBX1SzYuOBPDAn+df1oft90wFo+6i4F6CbpZMxWYDGWZyMJfn10pUAaTY5vE2VR9i2zi5l03
 /cUNzEAgOfWXoiSQqLhorMNBSReyj+a7rUNYWLX68elpTTbigi7d9syAFaETkhtDUThVRUDjuB8
 vjA6NCECGG8Yc3yp9PE3gZ0xkv0cKysPvqUujP6aGpAJiiPXu0n9nWklEFPInOZe5fVHIklYL1w
 dymfMkC6DtlRm4Gt+iaBxFPgRhiW+MSVysHfd1moI3C3kQHnX1MF8Z6Y1vY8PdN2tKkUeIMGWEi
 iU8598v7zuHDM03qP5DaxGhfHjPqK8p2u4NAB43z2AORANubRqpMvf+5PgM6iNBv8TB2X6fNnGQ
 qAGtd8nU1jAGsIkdzocLXFWHFCxQtQzD0XWX0IM64/D+jLkyFNknJObhtkw9f5eUdAbfNuRQKQN
 IVv/bJTRUxcMqjuYiX+2bDR3ueF0RClVV0NeDulGeGvwXkI9rzhSAVAs96q/YYtU9g6YR8req0F
 SnIvLz//mNZsE4g==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: mnx6pkuzbwd4okcdkf7xrnsrhsw4yc6g
X-Rspamd-Queue-Id: C2E001C0013
X-HE-Tag: 1780603176-245541
X-HE-Meta: U2FsdGVkX19riHR0U04kBmwI24h1+ARFA6m7/Lm596fgCxexbAG8gbeKZ9o78y1ZxDeEplI7sHbVN0V9UT5P2lpnt6u1Ri87TYS9l9EpUF16ulv2saFCt2Dpb2b761++Cvsjl7bRyHt3aNM9MJCu8dfyk81AmKUJSsdI/3pRwIXFoQQKUYR9+RLSPCXhOvBmV7hOhPaAhmXPv4+1Esu+uhSx5lXN9CZrGfVaNqQPBp21njAMXLXjfYYyxj8pNHOCXs3S6Lso1uz7YSA4uJwwn6Pt9bWqeHt5E1Fg+DLXpHyqBV+oSymdZapgQeNc8dlU7TDKmHFWouDyQ9Jm26DgCEK1mTXRX+tsa+wmFY0WI0xPAaIc+d/JgVwm3eW3dnRjLDFFht/HMIIWncMxwKl1SU/Hd/vI2r3Frnfr/ZqFBtVwMiEAtdcCpBizEIs3ac9365JaMLZ6Dtr0rIpjYwEt63in0r59jVpsAmXGtWHpnpEPUQmDoHhM8VFGatkXfa6izMm6vrJ+fnXdTg29eKEX/Z1eTquxb6wvnUzYKz0da5MJgzDrotqaULbvWvhhieOquFq3Zm3iRavAz9sjIQBuC6Wkb8WcPa+SaRipDr14NmOINj22kvuWzSnwQafTTAiNxvj8B78WW/gvYZYLmi7w8fEVHhdizZLUaDYcUgUVRQcMadMkpaxT41lwou/ZZRFOqsPVlG3m3Y171FxAo25AOLl2VbNHhMeS4yyXgggoB3qTtY+dt16JSsUJtA3Vf+3q9Voba4IRk5XbCGf53K6oGqQTrV+l920sSagGLXZKTEKbrYeNdnUDFDLEiYGh0bC9B1LhqwoaPFEzlpeHmAd2lINUt8uxyotdGWUHveCtGctgS9TDl5iFWK32/bDEeYWNMCawjGm9OAbujUkeMVd1W+9MSDJv91o5qrXnI4r25FhlD+lvd0inSi43ietKr9530qXMoGPEfNgOD7E7HR4
 AdELu7Ea
 HQK0w0gW2g4jcnC+IYCfmoSCJQLKa8KwDiyhYwcrB6fbJwGg0s3ZUtW9xiswjeoMVVlBrQG3Dqlvm2ey5vty3b/XOHrkNfkFTidC8AlIuGptNGvw5IxI5dKUOUGGnGdPLPPmg5ebLjq/IZNU6OCFZ9SE7DpvRo2a7y6b4TF7cC/UXN0mzO+xUS8IWLBA/kAqtt9nSBAL/3Mo+t/F//r166J9rrtWBE29c8JJ0Nl2G/eKUKq81/5LZa5yCcaeJMgOnirUiPhhlzWTd19YFtXi5pY6oo0GDmjuwLinfwmKTJm4UqZK1A9V1aaCei4EHhlDjTeRxSEBNgV0Fd1j2aBP1hccSncF2Gl9AypW+YkyCFn5kl1FxTlFqSPYrJ5lyb9uSQUFs7lAoa9irpq6A3cXyEQnhbHTY6Coat6u13WyjbQx5jmY=
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
Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 include/linux/radix-tree.h      |   3 +
 lib/radix-tree.c                |   5 +-
 rust/bindings/bindings_helper.h |   3 +
 rust/kernel/xarray.rs           | 185 +++++++++++++++++++++++++++++++++++-----
 rust/kernel/xarray/entry.rs     |  29 +++++--
 5 files changed, 194 insertions(+), 31 deletions(-)

diff --git a/include/linux/radix-tree.h b/include/linux/radix-tree.h
index eae67015ce51..c3699f12b070 100644
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
index 1cf0012b15ad..ddd67ce672f5 100644
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
index d4093367a4a8..03fae45d5076 100644
--- a/rust/bindings/bindings_helper.h
+++ b/rust/bindings/bindings_helper.h
@@ -130,6 +130,9 @@ const gfp_t RUST_CONST_HELPER_XA_FLAGS_ALLOC1 = XA_FLAGS_ALLOC1;
  * see https://github.com/rust-lang/rust-bindgen/issues/3347.
  */
 const size_t RUST_CONST_HELPER_XAS_RESTART = (size_t)XAS_RESTART;
+const size_t RUST_CONST_HELPER_XA_CHUNK_SHIFT = XA_CHUNK_SHIFT;
+const size_t RUST_CONST_HELPER_XA_CHUNK_SIZE = XA_CHUNK_SIZE;
+extern struct kmem_cache *radix_tree_node_cachep;
 
 const vm_flags_t RUST_CONST_HELPER_VM_MERGEABLE = VM_MERGEABLE;
 const vm_flags_t RUST_CONST_HELPER_VM_READ = VM_READ;
diff --git a/rust/kernel/xarray.rs b/rust/kernel/xarray.rs
index f6d5e5908c8b..cbb16368c2ca 100644
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
@@ -250,7 +305,7 @@ pub fn get_mut(&mut self, index: usize) -> Option<T::BorrowedMut<'_>> {
     ///
     /// match guard.entry(42) {
     ///     Entry::Vacant(entry) => {
-    ///         entry.insert(KBox::new(0x1337u32, GFP_KERNEL)?)?;
+    ///         entry.insert(KBox::new(0x1337u32, GFP_ATOMIC)?, None)?;
     ///     }
     ///     Entry::Occupied(_) => unreachable!("We did not insert an entry yet"),
     /// }
@@ -455,6 +510,45 @@ pub fn store(
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
 
 /// A reference to a [`Guard`], either shared or mutable, that exposes the
@@ -493,6 +587,30 @@ pub(crate) struct XArrayState<R: GuardRef> {
     state: bindings::xa_state,
 }
 
+impl<R: GuardRef> Drop for XArrayState<R> {
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
 impl<R: GuardRef> XArrayState<R> {
     fn new(guard: R, index: usize) -> Self {
         let xa_ptr = guard.xa_ptr();
@@ -536,15 +654,36 @@ fn status(&self) -> Result {
         to_result(unsafe { bindings::xas_error(&self.state) })
     }
 
-    fn insert(&mut self, value: R::Value) -> Result<*mut c_void, StoreError<R::Value>> {
+    fn insert(
+        &mut self,
+        value: R::Value,
+        mut preload: Option<&mut XArraySheaf<'_>>,
+    ) -> Result<*mut c_void, StoreError<R::Value>> {
         let new = R::Value::into_foreign(value).cast();
 
-        // SAFETY: `self.state` is a valid `xa_state` by the type invariant. By the same
-        // invariant, `self.state.xa` aliases the xarray reachable through `self.guard`,
-        // whose lock we hold. `new` came from `R::Value::into_foreign`.
-        unsafe { bindings::xas_store(&mut self.state, new) };
-
-        self.status().map(|()| new).map_err(|error| {
+        loop {
+            // SAFETY: `self.state` is a valid `xa_state` by the type invariant. By the same
+            // invariant, `self.state.xa` aliases the xarray reachable through `self.guard`,
+            // whose lock we hold. `new` came from `R::Value::into_foreign`.
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
             // SAFETY: `new` came from `R::Value::into_foreign` and `xas_store` does not take
             // ownership of the value on error.
             let value = unsafe { R::Value::from_foreign(new) };
@@ -554,9 +693,15 @@ fn insert(&mut self, value: R::Value) -> Result<*mut c_void, StoreError<R::Value
 }
 
 impl<'a, 'b, T: ForeignOwnable> XArrayState<&'b mut Guard<'a, T>> {
-    /// Consumes `self` and returns the inner `&mut Guard`.
+    /// Consumes `self`, releases any preallocated node held in `xa_alloc`, and
+    /// returns the inner `&mut Guard`.
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
index 5ad79a499156..e979481dd57e 100644
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
     /// guard.store(42, KBox::new(0x1337u32, GFP_ATOMIC)?, GFP_ATOMIC)?;
     /// let entry = guard.entry(42);
@@ -73,7 +74,8 @@ pub fn into_guard(self) -> &'b mut Guard<'a, T> {
     /// Returns a reference to the newly inserted value.
     ///
     /// - This method will fail if the nodes on the path to the index
-    ///   represented by this entry are not present in the XArray.
+    ///   represented by this entry are not present in the XArray and no memory
+    ///   is available via the `preload` argument.
     /// - This method will not drop the XArray lock.
     ///
     ///
@@ -88,7 +90,7 @@ pub fn into_guard(self) -> &'b mut Guard<'a, T> {
     ///
     /// if let Entry::Vacant(entry) = guard.entry(42) {
     ///     let value = KBox::new(0x1337u32, GFP_ATOMIC)?;
-    ///     let borrowed = entry.insert(value)?;
+    ///     let borrowed = entry.insert(value, None)?;
     ///     assert_eq!(*borrowed, 0x1337);
     /// }
     ///
@@ -96,8 +98,12 @@ pub fn into_guard(self) -> &'b mut Guard<'a, T> {
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
@@ -107,7 +113,8 @@ pub fn insert(mut self, value: T) -> Result<T::BorrowedMut<'b>, StoreError<T>> {
     /// Inserts a value and returns an occupied entry representing the newly inserted value.
     ///
     /// - This method will fail if the nodes on the path to the index
-    ///   represented by this entry are not present in the XArray.
+    ///   represented by this entry are not present in the XArray and no memory
+    ///   is available via the `preload` argument.
     /// - This method will not drop the XArray lock.
     ///
     /// # Examples
@@ -121,7 +128,7 @@ pub fn insert(mut self, value: T) -> Result<T::BorrowedMut<'b>, StoreError<T>> {
     ///
     /// if let Entry::Vacant(entry) = guard.entry(42) {
     ///     let value = KBox::new(0x1337u32, GFP_ATOMIC)?;
-    ///     let occupied = entry.insert_entry(value)?;
+    ///     let occupied = entry.insert_entry(value, None)?;
     ///     assert_eq!(occupied.index(), 42);
     /// }
     ///
@@ -129,8 +136,12 @@ pub fn insert(mut self, value: T) -> Result<T::BorrowedMut<'b>, StoreError<T>> {
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



