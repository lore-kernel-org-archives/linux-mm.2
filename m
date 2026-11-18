Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 451E9606A333
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 16:19:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=csKfBJPG
Received: by kanga.kvack.org (Postfix)
	id 61F606B05BE; Wed, 18 Nov 2026 11:19:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F7776B05BF; Wed, 18 Nov 2026 11:19:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C0CE6B05C0; Wed, 18 Nov 2026 11:19:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1B0566B05BE
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 11:19:55 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AB6A21207DE
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 16:19:54 +0000 (UTC)
X-FDA: 85448751108.10.2671605
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id CBC262000D
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 16:19:52 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=csKfBJPG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795018793;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1n1XOzJlQxzgvILxJQDMMGC1JZ5PGO1BzOg5HrK6H2M=;
	b=IaQwGYOdwd/THiH6d+2JDEyis+QnMS63RgoV6qvgwUQHebEoBUFnPcg5WPOqcqq1tTFpxo
	+1BrqzGe5KLn0DWQoYMeETvcelrpuiLx7m3x+iihL2vm6J+0qL3G0V2T9YM9J6MftPUPcG
	+RDnrdD8fKSu8k9B7G+sDWABw3XrHGE=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=csKfBJPG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795018793;
	b=d5qIO1bbDjV5q8Z622u8ulvWss5HQE6SniKPNiJrarDlKGflDAoG+7+M9lGKK9Ndk3cjNW
	t2WOxEcrpwZ1iJdLeOBuehQYs4+YenaCwE9MlXX+Jt2CWW7hVlgoNOVLynbjmt0/y1Mp7g
	vlLHhGFk/TMSvVMqMGDuDVqNepL0n1o=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2B1F640AC4;
	Wed, 18 Nov 2026 16:19:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 910F81F000C8;
	Wed, 18 Nov 2026 16:19:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795018792;
	bh=1n1XOzJlQxzgvILxJQDMMGC1JZ5PGO1BzOg5HrK6H2M=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=csKfBJPGWWjXKNJBP+G9w2CBT7vIViKqL22f2V85/qakH7c+zWH1tVKvsjAq7TqFL
	 /hoF8P/wSGlxGwaoKWw2sbIdfp1ibgc4gxl57lDsbhFaztstMkbDnrDUYoLfB9pUkh
	 rnwTKq7nQ86abM5rzE1zWY0s88SjNTUWuV2HXTtZyd1+7ziTs2L9kvSqhiA1GPyea5
	 GSrdxuCsDaZSod8HN10yM7/zpyHW2J/i9PWuhqoWzBUs4AHeqAj6ILfUedSm9O0JfR
	 qlJe2ebV4aI93aGj3CCDRzeiUggL2RjINyp2PbFxT6dda7njUSEKXdRUEGOXWI351/
	 +249eUXRV8/Ew==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Wed, 18 Nov 2026 17:18:17 +0100
Subject: [PATCH v22 1/6] rust: page: add page kinds and make `Page`
 reference counted
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261118-page-ownable-v22-1-d63ff73f4075@kernel.org>
References: <20261118-page-ownable-v22-0-d63ff73f4075@kernel.org>
In-Reply-To: <20261118-page-ownable-v22-0-d63ff73f4075@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Uladzislau Rezki <urezki@gmail.com>, 
 David Hildenbrand <david@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Brendan Jackman <brendan.jackman@linux.dev>, 
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
 Mike Rapoport <rppt@kernel.org>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
 Rakie Kim <rakie.kim@sk.com>, Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Matthew Wilcox <willy@infradead.org>, Danilo Krummrich <dakr@kernel.org>, 
 Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun@kernel.org>, 
 Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
 Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
 Daniel Almeida <daniel.almeida@collabora.com>, 
 Tamir Duberstein <tamird@kernel.org>, 
 Alexandre Courbot <acourbot@nvidia.com>, 
 =?utf-8?q?Onur_=C3=96zkan?= <work@onurozkan.dev>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 =?utf-8?q?Arve_Hj=C3=B8nnev=C3=A5g?= <arve@android.com>, 
 Todd Kjos <tkjos@android.com>, Christian Brauner <brauner@kernel.org>, 
 Carlos Llamas <cmllamas@google.com>
Cc: Igor B <igor.b@beldev.am>, Vitaly Wool <vitaly.wool@konsulko.se>, 
 linux-mm@kvack.org, rust-for-linux@vger.kernel.org, 
 linux-kernel@vger.kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=18291;
 i=a.hindborg@kernel.org; h=from:subject:message-id;
 bh=z/Mzn3PEi/ttFCVU2HVZ9F/yTlxTQ9jP24bZW/honOo=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBq/c/uOwT4wsCuapPqtFmMN09pYA+kGjsOezx9y
 itt81dr5n+JAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCav3P7gAKCRD6UCkIqsW9
 0MloEACZuQ5d1SVAVYcZ0XesuoZrp1p6pCb2muhBGeHRupM++XelDntfiLDG17xtZj/gaJKAlTp
 bN0haicjSibbnuvZJQUOMC5BwOZWRm1Pg8bGactilfMR7PLKrBXyzZJ5+Jm9F2sh4rtXKpmpPeK
 afpXGoBBHz51eT6RQLsowAFvf7X7khIZs+ttEAeiQN1h7RdS/CNq+eYXP6PDz+k76Y5jvx9UnRi
 NXLIpSG0B2S74oJW1+nYgXS/+yrjieS2a4h8NOAA5ngw5c2GwKhQUWo5OWGAX6A3u0t1GBFG0ld
 5GwRzJ0aGB3P9HJM+q0ogK4M0FgSf/i+a41oRfYlbnXk0maiGZ6ecvWidk5sD8V4JCKwKm+zRBa
 /jln5AaaPhJePPoPjU91UoxDermPeeiD+o5jcxxWXktVx1/DTnHJMzpyeJ48l/RZ6W3XMJJ4ONJ
 Fb4P4P/D97rTzNeehK6ygX+GShMaoeL0LkDE7KG9U93ifLJk260EOwOQt4a1dfxCMihEUZGkoiu
 WOu15+QLhkOmYLnjglAUtCKWEyZ8OD0moHkfNLu8xO46pXejl7uYr6EJMk2IKw2upMFP4NWrdya
 Xre8Pu5gpwEVJiqudby76pUlJPDk/+JXX2IrhE7QVmkFs9eCRCOhVBMpU9KpxuTv6EnDdKf6Oy3
 lRNZ8ANOQVIxExQ==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Queue-Id: CBC262000D
X-Stat-Signature: hwb7qux95ug8zx6k3d5nrejsjuztpy58
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1795018792-413620
X-HE-Meta: U2FsdGVkX1/mM707w6jCMGFG5NDdZIBBwEyAsYNvGRxqSeI21xg+0iaiUcR5x/nHmdLQxs+2vuk4FTA+Qe0wfSfwHKSkT2M1CY1T5OT54EpYUwKjIh/Zsl2aChVG4yG+H7enawVNaaViSlUCWaCDVVEtbqPqXUAqZvkNcvfmbT376YOtTNVT9v1W5X1S70ff3oQ2NLx+tu9gur9ag0chxT5x4ofwmSwKkD7Ae/OZSiDLfMUY3tX/ohLJ5i5NumTj2nZHBOV1UBjTj1eUcqGM6ue3lPps85wtzsDyyz+f+FbdyG8iL2Y3xaN4RWrhJbXDA9Mj/KknxlEbUojiZREGxeTCkxOfjE/8zU70mHhvhQsaNMb1hMTRHc73Wzn5udlJ1f32bWDkARaGvqkdYHiIvh/2bTxD3wog0NsyHuwDrFrmilqNJqWVNwmDrUbHK6sqWBqkI05RlvaJ2TsVHphJa4kx4etl2F7F1V569DWgCR5nj+5QBR+M3VLc0K53hFqL/ANnRugaZafilQ8JHagPIysazpQKgeWQQ3JcCA74ERz4zmRSuv/zDzVUfWIuGeGMtQLqN0VsCMrtAgUiYVgmBTVhsXPRYxN5NX6hQOnONn1XhkEn8DE5QQMu+rbF5EL+D7SHjnazDVXCIqC34n6GMBWTuVq2AdgLuFEW2Evmfz6MIkCAGqia1ieaC1wCi9RKh6wFTZWxCltYmCpsDDAb8T2eAu4u27bM0Wo12bZhI1O3RD/gjsPwFN7uqU2bWmlMQvWANTecsp3QKFbivOKVzl4eIIHYwwJkAfpB2yaiiGks7ZFywCnjjI6feuVCVIOPil9D7bTx1m4G7jVY3R01L1rcLGemsA9MB0lFrDvX4EIfb9/lmN81OhtHEpNquAEA5wqllWEsaXzSrUQ3Jj2OsHY45grWcbP+DTY6MT3yJBjX8ooGQewbLZZKMGJFwQUm6dm2jxb7YdaF/P6T5Tl
 YNmWFcaP
 sXQWw/dKAcq/FKQR6WQbcFvQbaPCc9xmQghLodLg+5i3VN/J9+8g31Mgnts2hLfEhztiBcTGqmsyldMDuahZifN/+kdPxZV+Z0tcSTVZgXVDyTKhUZj46kO/82qKfL1Bc8B1UTCJKN2bZ9ub/D4L7VXh+0rWCKsaLfhBKak57Z47Au/NleYVtg5vaVTEiRJkkVEs+RtFo8q17GwQoDqAlNz5ZM53oMiBmviibT8oiwhJzIFW9tu3r4cK6cVkAamckdYvQnTfZa9q/yyygzk0J/XR9xCFmaAlNN/5hBnp5VnCc4+IgSRlDW7bPKP31D6QVpmm241AW7dL8x4GhYEthPbOILsmF2MDFru/9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

A `struct page` has a reference count, and the lifetime of most pages is
managed by it. Kernel C code routinely takes its own references to such
pages, for example when a page is inserted into a VMA with
`vm_insert_page()`.

However, not every page is managed by its reference count, and not every
page may have references taken. For instance, a frozen page has a
reference count of zero, and `get_page()` must not be used on pages owned
by the slab allocator. Thus, a single `Page` type cannot represent both
pages that are known to be reference counted and pages for which this is
not known.

Make `Page` generic over a sealed `PageKind`, and add two page kinds:

 - `Base` is the base kind. Nothing is known about a `Page<Base>` beyond
   the validity of the `struct page`.
 - `RefCounted` is the default kind. A `Page<RefCounted>` is managed by
   the page reference count, and taking additional references to it is
   permitted.

Implement the `RefCounted` trait for `Page<RefCounted>`, backed by
`get_page()` and `put_page()`, mark it `AlwaysRefCounted`, and return
`ARef<Page>` from `Page::alloc_page()`. The page is freed when the last
reference to it is dropped; for the order-0 pages allocated here, this is
equivalent to `__free_pages()`.

The `RefCounted` page kind shares its name with the `RefCounted` trait.
The name matches the mm term for a page that is not frozen, and the kind
is the default, so it is rarely spelled out. In `page.rs`, the trait is
referred to as `aref::RefCounted`.

Operations that are valid for any page are available for all page
kinds.

Let `Page<RefCounted>` dereference to `Page<Base>`. The purpose of the
dereference is coercion: a `&Page<RefCounted>` can be passed to code
that takes a `&Page<Base>`.

This also allows pages to be handed out as plain references without
owning the `struct page`. Remove `BorrowedPage` and update users:
`Vmalloc::to_page()` and `AsPageIter` hand out `&Page<Base>`, and binder
uses `&Page` and `ARef<Page>`.

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 drivers/android/binder/page_range.rs |   8 +-
 rust/helpers/page.c                  |  10 ++
 rust/kernel/alloc/allocator.rs       |  26 ++---
 rust/kernel/alloc/allocator/iter.rs  |   7 +-
 rust/kernel/page.rs                  | 195 ++++++++++++++++++++---------------
 5 files changed, 142 insertions(+), 104 deletions(-)

diff --git a/drivers/android/binder/page_range.rs b/drivers/android/binder/page_range.rs
index b0c797523bc2..451369e07e7f 100644
--- a/drivers/android/binder/page_range.rs
+++ b/drivers/android/binder/page_range.rs
@@ -198,7 +198,7 @@ unsafe impl Send for Inner {}
 #[repr(C)]
 struct PageInfo {
     lru: bindings::list_head,
-    page: Option<Page>,
+    page: Option<ARef<Page>>,
     range: *const ShrinkablePageRange,
 }
 
@@ -206,7 +206,7 @@ impl PageInfo {
     /// # Safety
     ///
     /// The caller ensures that writing to `me.page` is ok, and that the page is not currently set.
-    unsafe fn set_page(me: *mut PageInfo, page: Page) {
+    unsafe fn set_page(me: *mut PageInfo, page: ARef<Page>) {
         // SAFETY: This pointer offset is in bounds.
         let ptr = unsafe { &raw mut (*me).page };
 
@@ -229,13 +229,13 @@ unsafe fn get_page<'a>(me: *const PageInfo) -> Option<&'a Page> {
         let ptr = unsafe { &raw const (*me).page };
 
         // SAFETY: The pointer is valid for reading.
-        unsafe { (*ptr).as_ref() }
+        unsafe { (*ptr).as_deref() }
     }
 
     /// # Safety
     ///
     /// The caller ensures that writing to `me.page` is ok for the duration of 'a.
-    unsafe fn take_page(me: *mut PageInfo) -> Option<Page> {
+    unsafe fn take_page(me: *mut PageInfo) -> Option<ARef<Page>> {
         // SAFETY: This pointer offset is in bounds.
         let ptr = unsafe { &raw mut (*me).page };
 
diff --git a/rust/helpers/page.c b/rust/helpers/page.c
index f8463fbed2a2..906eb4b18f02 100644
--- a/rust/helpers/page.c
+++ b/rust/helpers/page.c
@@ -10,6 +10,16 @@ __rust_helper struct page *rust_helper_alloc_pages(gfp_t gfp_mask,
 	return alloc_pages(gfp_mask, order);
 }
 
+__rust_helper void rust_helper_get_page(struct page *page)
+{
+	get_page(page);
+}
+
+__rust_helper void rust_helper_put_page(struct page *page)
+{
+	put_page(page);
+}
+
 __rust_helper void *rust_helper_kmap_local_page(struct page *page)
 {
 	return kmap_local_page(page);
diff --git a/rust/kernel/alloc/allocator.rs b/rust/kernel/alloc/allocator.rs
index cd4203f27aed..bf20714156c5 100644
--- a/rust/kernel/alloc/allocator.rs
+++ b/rust/kernel/alloc/allocator.rs
@@ -17,7 +17,10 @@
 
 use crate::{
     bindings,
-    page, //
+    page::{
+        Base,
+        Page, //
+    }, //
 };
 
 use core::{
@@ -169,7 +172,7 @@ unsafe fn realloc(
 }
 
 impl Vmalloc {
-    /// Convert a pointer to a [`Vmalloc`] allocation to a [`page::BorrowedPage`].
+    /// Convert a pointer to a [`Vmalloc`] allocation to a [`Page<Base>`] reference.
     ///
     /// # Examples
     ///
@@ -202,20 +205,19 @@ impl Vmalloc {
     ///
     /// - `ptr` must be a valid pointer to a [`Vmalloc`] allocation.
     /// - `ptr` must remain valid for the entire duration of `'a`.
-    pub unsafe fn to_page<'a>(ptr: NonNull<u8>) -> page::BorrowedPage<'a> {
+    pub unsafe fn to_page<'a>(ptr: NonNull<u8>) -> &'a Page<Base> {
         // SAFETY: `ptr` is a valid pointer to `Vmalloc` memory.
         let page = unsafe { bindings::vmalloc_to_page(ptr.as_ptr().cast()) };
 
-        // SAFETY: `vmalloc_to_page` returns a valid pointer to a `struct page` for a valid pointer
-        // to `Vmalloc` memory.
-        let page = unsafe { NonNull::new_unchecked(page) };
-
+        // INVARIANT: `Base` has no invariants in addition to the validity of the `struct page`,
+        // which is argued below.
         // SAFETY:
-        // - `page` is a valid pointer to a `struct page`, given that by the safety requirements of
-        //   this function `ptr` is a valid pointer to a `Vmalloc` allocation.
-        // - By the safety requirements of this function `ptr` is valid for the entire lifetime of
-        //   `'a`.
-        unsafe { page::BorrowedPage::from_raw(page) }
+        // - `vmalloc_to_page` returns a valid, non-null pointer to a `struct page` for a valid
+        //   pointer to `Vmalloc` memory, given that by the safety requirements of this function
+        //   `ptr` is a valid pointer to a `Vmalloc` allocation.
+        // - By the safety requirements of this function `ptr`, and hence the `struct page`, is
+        //   valid for the entire lifetime of `'a`.
+        unsafe { &*page.cast() }
     }
 }
 
diff --git a/rust/kernel/alloc/allocator/iter.rs b/rust/kernel/alloc/allocator/iter.rs
index 02fda3ea5cae..7c69ef31fb0c 100644
--- a/rust/kernel/alloc/allocator/iter.rs
+++ b/rust/kernel/alloc/allocator/iter.rs
@@ -9,7 +9,8 @@
     ptr::NonNull, //
 };
 
-/// An [`Iterator`] of [`page::BorrowedPage`] items owned by a [`Vmalloc`] allocation.
+/// An [`Iterator`] of [`Page<Base>`](page::Page) references to the pages of a [`Vmalloc`]
+/// allocation.
 ///
 /// # Guarantees
 ///
@@ -28,11 +29,11 @@ pub struct VmallocPageIter<'a> {
     size: usize,
     /// The current page index of the [`Iterator`].
     index: usize,
-    _p: PhantomData<page::BorrowedPage<'a>>,
+    _p: PhantomData<&'a page::Page<page::Base>>,
 }
 
 impl<'a> Iterator for VmallocPageIter<'a> {
-    type Item = page::BorrowedPage<'a>;
+    type Item = &'a page::Page<page::Base>;
 
     fn next(&mut self) -> Option<Self::Item> {
         let offset = self.index.checked_mul(page::PAGE_SIZE)?;
diff --git a/rust/kernel/page.rs b/rust/kernel/page.rs
index 1c0796ea229f..b2a17c86e7de 100644
--- a/rust/kernel/page.rs
+++ b/rust/kernel/page.rs
@@ -12,11 +12,16 @@
         code::*,
         Result, //
     },
+    sync::aref::{
+        self,
+        ARef,
+        AlwaysRefCounted, //
+    },
+    types::Opaque,
     uaccess::UserSliceReader, //
 };
 use core::{
     marker::PhantomData,
-    mem::ManuallyDrop,
     ops::Deref,
     ptr::{
         self,
@@ -65,104 +70,106 @@ pub const fn page_align(addr: usize) -> Option<usize> {
     Some(sum & PAGE_MASK)
 }
 
-/// Representation of a non-owning reference to a [`Page`].
-///
-/// This type provides a borrowed version of a [`Page`] that is owned by some other entity, e.g. a
-/// [`Vmalloc`] allocation such as [`VBox`].
-///
-/// # Example
-///
-/// ```
-/// # use kernel::{bindings, prelude::*};
-/// use kernel::page::{BorrowedPage, Page, PAGE_SIZE};
-/// # use core::{mem::MaybeUninit, ptr, ptr::NonNull };
+/// Trait to be implemented by types which provide an [`Iterator`] of [`Page<Base>`] references,
+/// such as [`VmallocPageIter`](kernel::alloc::allocator::VmallocPageIter).
+pub trait AsPageIter {
+    /// The [`Iterator`] type, e.g. [`VmallocPageIter`](kernel::alloc::allocator::VmallocPageIter).
+    type Iter<'a>: Iterator<Item = &'a Page<Base>>
+    where
+        Self: 'a;
+
+    /// Returns an [`Iterator`] of [`Page<Base>`] references over all pages owned by `self`.
+    fn page_iter(&mut self) -> Self::Iter<'_>;
+}
+
+mod private {
+    pub trait Sealed {}
+}
+
+/// Marker trait for the kinds of a [`Page`].
 ///
-/// fn borrow_page<'a>(vbox: &'a mut VBox<MaybeUninit<[u8; PAGE_SIZE]>>) -> BorrowedPage<'a> {
-///     let ptr = ptr::from_ref(&**vbox);
+/// A page kind describes what is known about a `struct page`, and thereby what a [`Page`] of that
+/// kind can be used for. See [`Base`] and [`RefCounted`].
 ///
-///     // SAFETY: `ptr` is a valid pointer to `Vmalloc` memory.
-///     let page = unsafe { bindings::vmalloc_to_page(ptr.cast()) };
+/// A [`Page`] of any other kind dereferences to a [`Page`] of the base kind [`Base`]. The
+/// purpose of the dereference is coercion: a reference to a page of any kind can be passed to code
+/// that takes a `&Page<Base>`.
+pub trait PageKind: private::Sealed {}
+
+/// The base [`PageKind`]: a valid page with no further guarantees.
 ///
-///     // SAFETY: `vmalloc_to_page` returns a valid pointer to a `struct page` for a valid
-///     // pointer to `Vmalloc` memory.
-///     let page = unsafe { NonNull::new_unchecked(page) };
+/// Nothing is known about how the allocation of a [`Page<Base>`] is managed. In particular,
+/// the page is not necessarily managed by the page reference count. For instance, pages owned by
+/// the slab allocator are not. Thus, it is not possible to obtain an [`ARef`] from a
+/// `&Page<Base>`.
 ///
-///     // SAFETY:
-///     // - `self.0` is a valid pointer to a `struct page`.
-///     // - `self.0` is valid for the entire lifetime of `self`.
-///     unsafe { BorrowedPage::from_raw(page) }
-/// }
+/// # Invariants
 ///
-/// let mut vbox = VBox::<[u8; PAGE_SIZE]>::new_uninit(GFP_KERNEL)?;
-/// let page = borrow_page(&mut vbox);
+/// A [`Page<Base>`] has no invariants in addition to the ones of [`Page`].
+pub struct Base;
+
+impl private::Sealed for Base {}
+impl PageKind for Base {}
+
+/// The default [`PageKind`]: a page that is managed by the page reference count.
 ///
-/// // SAFETY: There is no concurrent read or write to this page.
-/// unsafe { page.fill_zero_raw(0, PAGE_SIZE)? };
-/// # Ok::<(), Error>(())
-/// ```
+/// A [`Page<RefCounted>`] is accessed through a shared reference or through an owning
+/// [`ARef<Page>`]. The page allocation is freed when the last reference to it is dropped.
 ///
 /// # Invariants
 ///
-/// The borrowed underlying pointer to a `struct page` is valid for the entire lifetime `'a`.
+/// For a [`Page<RefCounted>`]:
 ///
-/// [`VBox`]: kernel::alloc::VBox
-/// [`Vmalloc`]: kernel::alloc::allocator::Vmalloc
-pub struct BorrowedPage<'a>(ManuallyDrop<Page>, PhantomData<&'a Page>);
-
-impl<'a> BorrowedPage<'a> {
-    /// Constructs a [`BorrowedPage`] from a raw pointer to a `struct page`.
-    ///
-    /// # Safety
-    ///
-    /// - `ptr` must point to a valid `bindings::page`.
-    /// - `ptr` must remain valid for the entire lifetime `'a`.
-    pub unsafe fn from_raw(ptr: NonNull<bindings::page>) -> Self {
-        let page = Page { page: ptr };
-
-        // INVARIANT: The safety requirements guarantee that `ptr` is valid for the entire lifetime
-        // `'a`.
-        Self(ManuallyDrop::new(page), PhantomData)
-    }
-}
+/// - The allocation of the page is managed by the page reference count, and the reference count is
+///   non-zero.
+/// - It is permitted to take additional references to the page with `get_page()`.
+pub struct RefCounted;
 
-impl<'a> Deref for BorrowedPage<'a> {
-    type Target = Page;
+impl private::Sealed for RefCounted {}
+impl PageKind for RefCounted {}
 
-    fn deref(&self) -> &Self::Target {
-        &self.0
-    }
-}
-
-/// Trait to be implemented by types which provide an [`Iterator`] implementation of
-/// [`BorrowedPage`] items, such as [`VmallocPageIter`](kernel::alloc::allocator::VmallocPageIter).
-pub trait AsPageIter {
-    /// The [`Iterator`] type, e.g. [`VmallocPageIter`](kernel::alloc::allocator::VmallocPageIter).
-    type Iter<'a>: Iterator<Item = BorrowedPage<'a>>
-    where
-        Self: 'a;
-
-    /// Returns an [`Iterator`] of [`BorrowedPage`] items over all pages owned by `self`.
-    fn page_iter(&mut self) -> Self::Iter<'_>;
-}
-
-/// A pointer to a page that owns the page allocation.
+/// A `struct page`.
+///
+/// A `Page` is generic over a [`PageKind`], which describes what is known about the page:
+///
+/// - `Page<Base>` is a page for which nothing is known beyond its validity.
+/// - `Page<RefCounted>`, or just `Page`, is a page that is managed by the page reference count.
+///
+/// Operations that are valid for any page are available for all page kinds. All other page kinds
+/// dereference to [`Page<Base>`], so that a reference to a page of any kind coerces to a
+/// `&Page<Base>`.
 ///
 /// # Invariants
 ///
-/// The pointer is valid, and has ownership over the page.
-pub struct Page {
-    page: NonNull<bindings::page>,
+/// - The `Page` is backed by a valid `struct page`.
+/// - The invariants of `Kind` hold for the page, see the documentation of the [`PageKind`] types.
+#[repr(transparent)]
+pub struct Page<Kind: PageKind = RefCounted> {
+    page: Opaque<bindings::page>,
+    _kind: PhantomData<Kind>,
 }
 
 // SAFETY: Pages have no logic that relies on them staying on a given thread, so moving them across
 // threads is safe.
-unsafe impl Send for Page {}
+unsafe impl<Kind: PageKind> Send for Page<Kind> {}
 
 // SAFETY: Pages have no logic that relies on them not being accessed concurrently, so accessing
 // them concurrently is safe.
-unsafe impl Sync for Page {}
+unsafe impl<Kind: PageKind> Sync for Page<Kind> {}
 
-impl Page {
+impl Deref for Page<RefCounted> {
+    type Target = Page<Base>;
+
+    #[inline]
+    fn deref(&self) -> &Self::Target {
+        // SAFETY: `Page` is transparent over `struct page` for all page kinds, so the pointer cast
+        // is valid. `Base` has no invariants in addition to the ones of `Page`, which hold for
+        // `self`.
+        unsafe { &*ptr::from_ref(self).cast() }
+    }
+}
+
+impl Page<RefCounted> {
     /// Allocates a new page.
     ///
     /// # Examples
@@ -185,19 +192,22 @@ impl Page {
     /// # Ok::<(), kernel::alloc::AllocError>(())
     /// ```
     #[inline]
-    pub fn alloc_page(flags: Flags) -> Result<Self, AllocError> {
+    pub fn alloc_page(flags: Flags) -> Result<ARef<Self>, AllocError> {
         // SAFETY: Depending on the value of `gfp_flags`, this call may sleep. Other than that, it
         // is always safe to call this method.
         let page = unsafe { bindings::alloc_pages(flags.as_raw(), 0) };
         let page = NonNull::new(page).ok_or(AllocError)?;
-        // INVARIANT: We just successfully allocated a page, so we now have ownership of the newly
-        // allocated page. We transfer that ownership to the new `Page` object.
-        Ok(Self { page })
+        // SAFETY: We just successfully allocated a page, so we own the reference count returned
+        // by `alloc_pages`, and we transfer that reference to the new `ARef<Page>`. Since `Page`
+        // is transparent, we can cast the pointer directly.
+        Ok(unsafe { ARef::from_raw(page.cast()) })
     }
+}
 
+impl<Kind: PageKind> Page<Kind> {
     /// Returns a raw pointer to the page.
     pub fn as_ptr(&self) -> *mut bindings::page {
-        self.page.as_ptr()
+        self.page.get()
     }
 
     /// Get the node id containing this page.
@@ -373,10 +383,25 @@ pub unsafe fn copy_from_user_slice_raw(
     }
 }
 
-impl Drop for Page {
+// SAFETY: By the type invariant, a `Page<RefCounted>` is managed by the page reference count.
+// Incrementing it via `get_page()` keeps the page alive at least until a matching `put_page()`,
+// which frees the page when the count reaches zero.
+unsafe impl aref::RefCounted for Page<RefCounted> {
+    #[inline]
+    fn inc_ref(&self) {
+        // SAFETY: By the type invariant, `self.as_ptr()` points to a valid `struct page` with a
+        // non-zero reference count.
+        unsafe { bindings::get_page(self.as_ptr()) };
+    }
+
     #[inline]
-    fn drop(&mut self) {
-        // SAFETY: By the type invariants, we have ownership of the page and can free it.
-        unsafe { bindings::__free_pages(self.page.as_ptr(), 0) };
+    unsafe fn dec_ref(obj: NonNull<Self>) {
+        // SAFETY: By the function safety requirements, the caller relinquishes a reference count
+        // on the page. Since `Page` is transparent, we can cast the pointer directly.
+        unsafe { bindings::put_page(obj.cast().as_ptr()) };
     }
 }
+
+// SAFETY: All instances of `Page` are reference counted, so a `&Page` proves that the refcount is
+// non-zero and it is okay to obtain an `ARef<Page>` from it.
+unsafe impl AlwaysRefCounted for Page {}

-- 
2.54.0



