Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3317660A2605
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 13:11:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=coGlmLiA
Received: by kanga.kvack.org (Postfix)
	id 510E46B05B8; Fri, 20 Nov 2026 08:11:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E8DD6B05B9; Fri, 20 Nov 2026 08:11:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3FEEA6B05BA; Fri, 20 Nov 2026 08:11:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 164E86B05B8
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 08:11:34 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9DEFF80F77
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 13:11:33 +0000 (UTC)
X-FDA: 85455534066.28.660B37D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id C54E1160007
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 13:11:31 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=coGlmLiA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795180291;
	b=3O5jLgRogSFpBa+REBvjrvetY0xSPRa3s+qBIbaVIjnc3bebI5zFxV5Y4GkR/g/CKRy3kL
	wFKeXLJvWj7BlQjR/AEHLqKcGDx9lN6UShRNVN/44XeIDpmzKYQlyCmP91L4ON2Lvk8jXO
	28pKT+k8tLWFzNgOkXXbSPX1gMHDAN8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795180291;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/PJ+fV6Wli0/ufVo5txeSumFik4Qq9CkQlCe2J0SDSk=;
	b=FKmEUZdo+VrgC4y79169VsXbFOvzdfz9+Kytcxn3DAG9M8VGQglOy3Xd3EkZQtAULqYCxI
	F2kWsE68l2J/5edpkiN8BGSatC3ZBlIaiTimTuSvigx3mLcMO8DlS655zxLkZcI924Jvo+
	rGcRWn2CnCOx+YkVZ5vMwOSXaE6VVBo=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=coGlmLiA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5C05362BF1;
	Fri, 20 Nov 2026 13:11:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68CE11F000CA;
	Fri, 20 Nov 2026 13:11:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795180290;
	bh=/PJ+fV6Wli0/ufVo5txeSumFik4Qq9CkQlCe2J0SDSk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=coGlmLiAyzwncM1VxQN75wK4DDux1U4WKOy2DoJKRuMNtx9B2PludTAYLzOjeoVYc
	 Nt7WxFLiB1ERf3FOoUqq7gEV6/UhnCx4VVqAGwu82NoJF/2pjw21ZYCwdx7XOd5A8/
	 fVQ6dpc7QFTihh2wcGtRuOq4E/yt1VyfQSePZgDNPi8VTaelad1BPqFxVl4aQBUoIS
	 g4nrUmpBe/IWAjoUkOBWFpd6fQjtWm3Sqo8LK0f8F1tJur78VHM/h1pD3bdVmPMR3n
	 Ay6x4dF4Oc+Ns+bfxw/Htd7HWGKryEmGwdF/SUpWdEx8V3O9UPqktmpy+m//isqIuc
	 V15ZndhGdedOQ==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Fri, 20 Nov 2026 14:10:22 +0100
Subject: [PATCH v6 11/12] rust: xarray: add preload API
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261120-xarray-entry-send-v6-11-1f69d7385f70@kernel.org>
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
 "Liam R. Howlett" <liam@infradead.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=19258;
 i=a.hindborg@kernel.org; h=from:subject:message-id;
 bh=K8skICYVrzBEe9YKk8WgE5W3Wz+7X784k+d7rCJt5sc=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBrAEbNDHPgl+Lj4IKfQNN1q26MKf3kTZkbGZOee
 EGt3gPLUZSJAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCawBGzQAKCRD6UCkIqsW9
 0F77EACXBw4Ks3JdYt+pIQXkT35yAJPURrP+84iNqmNQ/YeUB0MBVY30ioLF/JHOThQkmc4Et6e
 4bi6mWuBR5ovMoSMXbGk5NJbCrgqcKqPoZGLIBZciEEnxhcPn9DXxPM5zWmpi6CPm4ckt5BosaO
 /B6qSXZdNcFhS2nnPiIw90UXlOkNISF6YYec2nuJcZQsAhrMwlCflVZxlfnuhN4ZADDPVK9pn6L
 i1oIb3f3HwWV9gWkc4WkKaRMIfT/S5R9mY/g17hF/RIR5PycZWBsKqUGZ8VtCTysHlHFkNmV/JO
 7N4WKhvU+uaffPxmNIosrytAknOlM0x8dYoCy1MWiZWEjbA2dgzFvVuIEgWSnZHkDBE8eAqZh6T
 /fqH6q+CjH249wP3NbiDQLtB5YzKubnGQ21CH5SGiqWM+mMRARJjagsD040PagxHenvY3nfl1Bi
 ou1+4Zx/w4t5lPag+iXRjjDiVYVwmzJVc8GVvOv0f6qZs4DAVuxPQgyeTnTPovoEBD+LvVRirrg
 Bm2Blvrnad5jPNhADYViZ+jYhWSHyihZdKH4XUqUZNBnml9FyeU85EGoaPeha4iiSiTm/PbWSL+
 8FbAVt4p8PrZ4B3QHoyDC2bs1OliRRoLavmbinLeFYryFFvGarJw+5N7PyN6ERlVJjIrvMxOo8y
 PnF7MSPANmQCDYQ==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspam-User:
X-Spam-Status: No, score=-23.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 3s7ybx8urr6mb5amnn7atqetzz3bmohm
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C54E1160007
X-HE-Tag: 1795180291-569815
X-HE-Meta: U2FsdGVkX1+TcSBjkNdUdV6qVodFWlj8DCjC1WJpD3h+VmCU2GZOydchzdx89RouVVFF4AnPePMO088VpsNq/CH7ogHuKMr/J1wPDX3UZGw99BaJwKKJZRhu/pbuh/AI8woQKGV8VOyR2GVTLnSYZZD3JNyItCrM5LiBmxGrXiOAovvholfd66kPQgSE8BKRf1MswH1Dev8JXOqy2LGfru/3gTKyvivLylf8qTy7kZAEBULVt4KdSnp1B2TxcBxYyXtLYoFM8Ljc+SMfPsV0tlIR4mEvzhokye0mMsGbYFmsmlWxahyxREIU2tnY1eER6oXdybCwRgNlRUXoSuK6waInQzbQJuExBI54Av4y7QRmc8IVMjUNrD/JPhvTahu3C0ssTBoBRN+9ZM4UFQEPABRcBYir9AbG9i+YU/YmYle1I/Q0X4q8Oh8foBaKUSMRW5uvEranSC2Xi9yzTXuRuxfE1r6+D+ebHoLdhNGrHdZKGdRn6w2U90t1iDtAjAT+vw6bT3vZr8POMuFqsHcZcUc3ZQpPTYMmAhF+2XF5DHK+HNiFJQdV9TRUwzvZJIiqa4ayKCpZUmCW++1MA52Qslv4pPBBm45Y1Yi5ud5BMRH3dRQsAHR9EsPE18lBdaQxltDd9J/5vD1Z5vQYHou4i9iH6rI0M02vMq7o2p1F7Jv7QZQf6Nh8f9gzZ1aPAjvuX9aVV0Q+uEoQHCren6hd51yCZz80U+PqIQKhwfkG98AOesvtPDIoWVHlntBeOVRMCCJfqy4G1ZKm9+SfSEfBLNGlb/xIW8fTUIfgOSkI/zq7BD07msc+eQiqsg2sLm+zLG4UKthC3SsEJLwOEbiqnJ10IZlEd7hRVjTTmlyfTuh0+6AuOZYQePxdycT/Hzq3TBVgl1CPWP1iTLqe/9k6ZDz/9ii3w/dy9R5itgzSlGoRgBMvqaCbJ1hRH6ZHBmTufK80mqa04r80hiHW7hB
 bAuOVGmE
 TKa3tRF0MNKtT89c/VD7IS8/DlYK+fruvT7dsUqdrevGkGJU7SYXly61HaICVpgo08dMFNsKQjNrQkXuszj976uTP0Y6ZUAOy2Pxpwz/GDgzqsdoPYvYb8z1xfSap5Bw3nCWRLc3eff2LIH7q6PPb+eJpXCkfrJuyKB6bphHIOV90YgB7jccdJ+mVhZw17diXJCDiRjm5+KdXSqp5K+Q+SvcknccchTvlUsZC1JD61i66W93tQEeVphfCQm1v9vq5vNwagDo+N2uY8Z9yma4oinupWTYFfHaiUYHoH9Fhk0wIHNu2oqoFYXpBD/ibzdbwwfgZfEtMlbzQ8ukOjIjM19XPej5ogD2CByILYMhwgsUAe1NDF6SBvXYLG3TkVCFK+BhAPlS4rtUgHrt+8PZZ2alNamb4I6fQOTG0Okt7+NVWLJIJZoOE7Qy1T9UxwtHsz8gO0xOfr/WGWJslsud//oUhrmsQRCS2T0lJGbWy96229NrJJdWfHsIHnn1SsEkF6pyW6NM43WgkwRG15I2Uewk71my77DLAuLxGZFHgGXQ0SrguC8dnlEierWFpZ5w4nxWbIcy919VlA29FdojAjo72nllfw3NWdFtmOIsTrnZd8NOGMqomQVKyls1gxtk4/DOG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

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
 rust/kernel/xarray.rs           | 214 +++++++++++++++++++++++++++++++++++-----
 rust/kernel/xarray/entry.rs     |  28 ++++--
 5 files changed, 216 insertions(+), 37 deletions(-)

diff --git a/include/linux/radix-tree.h b/include/linux/radix-tree.h
index 057edc4cbb6e..ac5fc299399c 100644
--- a/include/linux/radix-tree.h
+++ b/include/linux/radix-tree.h
@@ -470,4 +470,7 @@ static __always_inline void __rcu **radix_tree_next_slot(void __rcu **slot,
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
index dd7c84b1a564..fb76a2d30449 100644
--- a/rust/bindings/bindings_helper.h
+++ b/rust/bindings/bindings_helper.h
@@ -138,6 +138,9 @@ const gfp_t RUST_CONST_HELPER_XA_FLAGS_ALLOC1 = XA_FLAGS_ALLOC1;
  * see https://github.com/rust-lang/rust-bindgen/issues/3347.
  */
 const size_t RUST_CONST_HELPER_XAS_RESTART = (size_t)XAS_RESTART;
+const size_t RUST_CONST_HELPER_XA_CHUNK_SHIFT = XA_CHUNK_SHIFT;
+const size_t RUST_CONST_HELPER_XA_CHUNK_SIZE = XA_CHUNK_SIZE;
+extern struct kmem_cache *radix_tree_node_cachep;
 
 const vm_flags_t RUST_CONST_HELPER_VM_MERGEABLE = VM_MERGEABLE;
 const vm_flags_t RUST_CONST_HELPER_VM_READ = VM_READ;
diff --git a/rust/kernel/xarray.rs b/rust/kernel/xarray.rs
index 3ff94c05a15a..b13d06f9b0df 100644
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
     build_assert::build_assert,
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
     }, //
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
@@ -270,7 +334,7 @@ pub fn get_mut(&mut self, index: usize) -> Option<T::BorrowedMut<'_>> {
     ///
     /// match guard.entry(42) {
     ///     Entry::Vacant(entry) => {
-    ///         entry.insert(KBox::new(0x1337u32, GFP_KERNEL)?)?;
+    ///         entry.insert(KBox::new(0x1337u32, GFP_ATOMIC)?, None)?;
     ///     }
     ///     Entry::Occupied(_) => unreachable!("We did not insert an entry yet"),
     /// }
@@ -472,6 +536,45 @@ pub fn store(
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
@@ -489,6 +592,30 @@ pub(crate) struct XArrayState<R> {
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
@@ -601,27 +728,54 @@ fn replace(&mut self, new: *mut c_void) -> *mut c_void {
         old
     }
 
-    fn insert(&mut self, value: T) -> Result<*mut c_void, StoreError<T>> {
+    fn insert(
+        &mut self,
+        value: T,
+        mut preload: Option<&mut XArraySheaf<'_>>,
+    ) -> Result<*mut c_void, StoreError<T>> {
         build_assert!(
             T::FOREIGN_ALIGN >= 4,
             "pointers stored in XArray must be 4-byte aligned"
         );
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
@@ -629,10 +783,16 @@ fn insert(&mut self, value: T) -> Result<*mut c_void, StoreError<T>> {
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
index e2f01a49c55e..3d004f6f8c6c 100644
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
@@ -32,6 +33,7 @@ impl<T: ForeignOwnable> Entry<'_, '_, T> {
     ///
     /// let entry = guard.entry(42);
     /// assert_eq!(entry.is_occupied(), false);
+    /// drop(entry);
     ///
     /// guard.store(42, KBox::new(0x1337u32, GFP_ATOMIC)?, GFP_ATOMIC)?;
     /// let entry = guard.entry(42);
@@ -75,7 +77,8 @@ pub fn into_guard(self) -> &'b mut Guard<'a, T> {
     /// Returns a reference to the newly inserted value.
     ///
     /// - This method will fail if the nodes on the path to the index
-    ///   represented by this entry are not present in the XArray.
+    ///   represented by this entry are not present in the XArray and no memory
+    ///   is available via the `preload` argument.
     /// - This method will not drop the XArray lock.
     ///
     ///
@@ -90,7 +93,7 @@ pub fn into_guard(self) -> &'b mut Guard<'a, T> {
     ///
     /// if let Entry::Vacant(entry) = guard.entry(42) {
     ///     let value = KBox::new(0x1337u32, GFP_ATOMIC)?;
-    ///     let borrowed = entry.insert(value)?;
+    ///     let borrowed = entry.insert(value, None)?;
     ///     assert_eq!(*borrowed, 0x1337);
     /// }
     ///
@@ -98,8 +101,12 @@ pub fn into_guard(self) -> &'b mut Guard<'a, T> {
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
@@ -109,7 +116,8 @@ pub fn insert(mut self, value: T) -> Result<T::BorrowedMut<'b>, StoreError<T>> {
     /// Inserts a value and returns an occupied entry representing the newly inserted value.
     ///
     /// - This method will fail if the nodes on the path to the index
-    ///   represented by this entry are not present in the XArray.
+    ///   represented by this entry are not present in the XArray and no memory
+    ///   is available via the `preload` argument.
     /// - This method will not drop the XArray lock.
     ///
     /// # Examples
@@ -123,7 +131,7 @@ pub fn insert(mut self, value: T) -> Result<T::BorrowedMut<'b>, StoreError<T>> {
     ///
     /// if let Entry::Vacant(entry) = guard.entry(42) {
     ///     let value = KBox::new(0x1337u32, GFP_ATOMIC)?;
-    ///     let occupied = entry.insert_entry(value)?;
+    ///     let occupied = entry.insert_entry(value, None)?;
     ///     assert_eq!(occupied.index(), 42);
     /// }
     ///
@@ -131,8 +139,12 @@ pub fn insert(mut self, value: T) -> Result<T::BorrowedMut<'b>, StoreError<T>> {
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
2.54.0



