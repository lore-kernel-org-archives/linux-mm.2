Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC172C79F9F
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 09:01:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B9A5F6B0098; Thu, 10 Sep 2026 05:01:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4B746B0099; Thu, 10 Sep 2026 05:01:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A623A6B009B; Thu, 10 Sep 2026 05:01:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 79D606B0098
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 05:01:38 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DD80F1C237C
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 09:01:37 +0000 (UTC)
X-FDA: 85197259434.04.A825BB2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 2089B10000E
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 09:01:35 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FfRrjUoI;
	spf=pass (imf05.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789030896;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w08aFcBZiHcoZ2r5Zzk3hvO4D194rjKTlY03OdL6b/o=;
	b=O2uavQIGfgF2iE++fn4Qqb0zOx9RtcFTNTL8uv0KZSBeMXCywem7IgfgRmsf5YGz49jJCg
	W9lu9jthtSYQPighPpSUUWzTeXHuheTL4zw69wMkViHAqeSCqwf44BTeNDBCIi3jLEOeta
	mshvATTG9sFE0RdFYZPkMjoewraFnyk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789030896;
	b=DkEu3nUsaNP6O7ssKEyjFk/eQ+sO56760E6dLbaholdHUysMebZMSR9/ME8Unl8WKQkcIk
	uKq5MQrMt9t0N7oPQJM8V5eHol4rLjRXRzioDJkmamfime7yhqLN55V9G5UXOQNL+uzUJQ
	BU8xoHa+AXToDuwYMRdu5KvDGjWabDQ=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FfRrjUoI;
	spf=pass (imf05.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9BA99600CB;
	Thu, 10 Sep 2026 09:01:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF21B1F00893;
	Thu, 10 Sep 2026 09:01:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789030895;
	bh=w08aFcBZiHcoZ2r5Zzk3hvO4D194rjKTlY03OdL6b/o=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=FfRrjUoI2hpiRRSKPTHPsbEm+xn40k/OwGKhAma58ndbXeIeB6v9/CJqcDA3X15Yl
	 gpavGcMwOLjRFXFoWNJ25+l5+t/LABe09ZFQC5GhHSZ4ANY3FdwcV/aAXRS1IKdwoE
	 AT4ZJxcx2Jf1/A6B9R0JgBF8I6ZLWBjbd3JcuRmijxF6330obnkModGJZyc6kJjw6K
	 STJAM8uKTOt5gPdl6F3oeg6oGMTaWL2Zivy62/wi0+QOPQ0q3zeZ9gaEGn7tkrSJ3i
	 3qJnSElae92pP5H7cLkeW3SIHWDp6MNVeVAaNkgKxDwYn0U9dpC1W9JRtZWusMWjTX
	 izLtjNAl9CAYg==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Thu, 10 Sep 2026 11:00:11 +0200
Subject: [PATCH v21 7/9] rust: page: convert to `AlwaysRefCounted`
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260910-unique-ref-v21-7-e83257373062@kernel.org>
References: <20260910-unique-ref-v21-0-e83257373062@kernel.org>
In-Reply-To: <20260910-unique-ref-v21-0-e83257373062@kernel.org>
To: Danilo Krummrich <dakr@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Uladzislau Rezki <urezki@gmail.com>, Miguel Ojeda <ojeda@kernel.org>, 
 Boqun Feng <boqun@kernel.org>, Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Benno Lossin <lossin@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
 Trevor Gross <tmgross@umich.edu>, 
 Daniel Almeida <daniel.almeida@collabora.com>, 
 Tamir Duberstein <tamird@kernel.org>, 
 Alexandre Courbot <acourbot@nvidia.com>, 
 =?utf-8?q?Onur_=C3=96zkan?= <work@onurozkan.dev>, 
 Lyude Paul <lyude@redhat.com>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 =?utf-8?q?Arve_Hj=C3=B8nnev=C3=A5g?= <arve@android.com>, 
 Todd Kjos <tkjos@android.com>, Christian Brauner <brauner@kernel.org>, 
 Carlos Llamas <cmllamas@google.com>, 
 "Rafael J. Wysocki" <rafael@kernel.org>, 
 Dave Ertman <david.m.ertman@intel.com>, Leon Romanovsky <leon@kernel.org>, 
 Paul Moore <paul@paul-moore.com>, Serge Hallyn <sergeh@kernel.org>, 
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Igor Korotin <igor.korotin@linux.dev>, Viresh Kumar <vireshk@kernel.org>, 
 Nishanth Menon <nm@ti.com>, Stephen Boyd <sboyd@kernel.org>, 
 Bjorn Helgaas <bhelgaas@google.com>, 
 =?utf-8?q?Krzysztof_Wilczy=C5=84ski?= <kwilczynski@kernel.org>, 
 Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, 
 Michal Wilczynski <m.wilczynski@samsung.com>, Ira Weiny <iweiny@kernel.org>, 
 Matthew Brost <matthew.brost@intel.com>, 
 =?utf-8?q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>, 
 Ira Weiny <iweiny@kernel.org>
Cc: Andreas Hindborg <a.hindborg@kernel.org>, 
 Philipp Stanner <phasta@kernel.org>, rust-for-linux@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 driver-core@lists.linux.dev, linux-block@vger.kernel.org, 
 linux-security-module@vger.kernel.org, dri-devel@lists.freedesktop.org, 
 linux-fsdevel@vger.kernel.org, linux-pm@vger.kernel.org, 
 linux-pci@vger.kernel.org, linux-pwm@vger.kernel.org, 
 linux-usb@vger.kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=13638;
 i=a.hindborg@kernel.org; h=from:subject:message-id;
 bh=MzvogiSVtIi0JzAdUhuy0ypaJ0xsEpb23czzoBLd/44=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBqonGnRfwXpyx8BzJPC8ZRC+TfpL+BfWiRRFCaX
 Fb46cvs4waJAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCaqJxpwAKCRD6UCkIqsW9
 0KcqD/4+0srT0ERXRO6+ouXfDxwXH6yF/vbr4iCkHuscqs8CwfwnUTkiSgVXWv2dXaeJRrReD04
 UZWExYv67OUTplV2uxHUaVfy3P/rdaaaPmxSvTnaIPM37c/I9tpef2WDMfTpPse9XmudhC6Y49J
 W+Bc6u8rgpiM+9Lqad7+0EFcim3rvIh9Whfsn76nIVxm/SZUD/EhRL5aW2wXymy2uCWKDstaPyi
 XaHpX07cbVWVNYKoEUquLfBzE23B/KjAbPssJAXGv3AQAcyUFLu6buPNGEcMen8x3n2YZVNcQFP
 6WnX+R+gOarjBG960qcMm8h4DjeFJsQOBvYhwQU06RfqE1O91xERvJs43qas3IZfw3fB2sWks2L
 tYtjZjSFrgY1yv59VzdOOviIdipWV52+v/BaaXoZ3VDVclXjka7Hf+i6+i8OpS4gKcpXMoXwZ5H
 fHAP5myQTqLnOgRCDgKpLSM59QZg68nYK1MZZ5bUmXO8RFzef3FRxi+SSUEZBWT734iduuwOjAr
 BL1AhHg/1/duKXV3TgsazOrEIoWrpaytAPjdjbCv/onIDDphaH4HD+SbPWlYApHgBzcz9Tvg1Sk
 qP60+qzkDO+8fKi0+VExIe0n65NokRY8zXy8HchaD5m1j8PUtPmQ08RYqAmQb8QSugb3TNNu0dz
 FkFk1E97MntHDZQ==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2089B10000E
X-Stat-Signature: dkw6mphoucgxxmiugrodnhta8y1ky54y
X-Rspam-User: 
X-HE-Tag: 1789030895-430222
X-HE-Meta: U2FsdGVkX18pbTFFrg7p/9kjUQesBCoYuUzp/1znwmeKqs4XS4oN1FNV93BlZTRsNYr19seyUIRqfQJHHraLlP2Py9fvIPc65/YkiXHcR2qfFr0u0etsNjv6atWkgOuoXaPquYPWKGDkPA9YOuIG8uuXHyTGfhHErazJ/Yi1b0HonViU+/fUQzPbXw8f0Ws0VkqiNTlAQYZW4ioPJjz/gnC9LXyjPlbtlvby5vf3gvyy5mg5i6IfMYi7nxpp2FVf6JQt9Z+5VmSPP9HYt0qtoq6ga6Buudf14WHzLjJrfaO4ywhsfDAqkdfoUfr21Gof9GT+lQC/Qpk4H6gVyTxKX9kgn2ToiQjjIH8cc+DDL7mbu6bQOd/eKAHyoLXPIebVpuZA730ZKetuVbGkLRM8qb7CZssFJS45WJdbcFID94ZsGbGQ6bQgsaBM2vlawBiz7LahTDinAfSkuI2f/3hGa76oi72lfXDBSe2fVEdltTVLNtzya9g0+MGTQ79jt1g968OCzNCJVa+Sui0weLDkcvoUfqIyX/WpVRNC5WaPSaMGi2j2v5p3ykQRAvr1tqFOMpMHlloPSzTP933WIESTQlJNQRSRVaTvgTGNFJwjwt/lsrZkzH9hWT7DsXRZudErcAexBB1j9+RaIgV1bSXiZj9JIiZ91+takJL4tQzBeXuII/nnRrL999jEdrTeor9H6NjtaEkBq5s+xIWQFRW79fR/Qrk2ZUiwgl2gfehSsD4wDOSfK8K+Z1cjkX9ffyzH6Ha7L7mrpKO0+jnCruqWpYKKx7YkmUc3foeqxfVHkEHr7UFibPatKnnBS9/7E8S45IHuVFREdR1wNp8LDAZh/BukMiudnmGQ0S9xPA3WkI//Qjf6YSqbkkdYfwJBFUGY0PCHNeZl22xTovudymRzo4Z0Ub7e61bn9/2mxOG7ZfdZpGCZyJpk/H1fY++30YkTyBH6qhQAalwcDgQoMgT
 enn7q11L
 Rei+r9MqDoBi6yy1zh9xQpLxM6wAtIjVHc0lPITPNWX2t9PVdrKKA7Z57j9R7TpqPx78C7WvQ/NfsxmV199hPdDL5RktI3M8UxK8nSXEgiP6JHuFuOxJS8q5C1NCbdCSmXPVQC7Q3jgGih2R4xFGbxfQGAik/QrlIw2WrNk+dExacbTXssxt5JUV8+uyL48HNGtKfbxkoea6efO04ehqd9xKTlChZU/1eZb+gAyiML9LF9YEKdUso/MaTOe/NoenZCsBtBYZTcm9udl2RadVPA0E9b1D3er/cS7WlbepyFG7/ZhWnEwl7nTmhIA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

`struct page` is managed by a native reference count, and kernel C
code routinely takes its own references to pages, for example when a
page is inserted into a VMA with `vm_insert_page()`.

Thus, implement `RefCounted` for `Page`, backed by `get_page()` and
`put_page()`, mark it `AlwaysRefCounted`, and return `ARef<Page>` from
`Page::alloc_page()`. The page is freed when the last reference to it is
dropped; for the order-0 pages allocated here, this is equivalent to
`__free_pages()`.

This also allows `Page` references to be returned as borrowed
references without owning the `struct page`. Remove `BorrowedPage`
and update users to use `&Page` and `ARef<Page>`.

Assisted-by: LLM
Suggested-by: Alice Ryhl <aliceryhl@google.com>
Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 drivers/android/binder/page_range.rs |   8 +-
 rust/helpers/page.c                  |  10 +++
 rust/kernel/alloc/allocator.rs       |  21 +++---
 rust/kernel/alloc/allocator/iter.rs  |   6 +-
 rust/kernel/page.rs                  | 139 ++++++++++++-----------------------
 5 files changed, 73 insertions(+), 111 deletions(-)

diff --git a/drivers/android/binder/page_range.rs b/drivers/android/binder/page_range.rs
index 52ffbf3504e7f..1117e1f6ece02 100644
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
index f8463fbed2a26..906eb4b18f029 100644
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
index cd4203f27aed0..27d957b7956e5 100644
--- a/rust/kernel/alloc/allocator.rs
+++ b/rust/kernel/alloc/allocator.rs
@@ -17,7 +17,7 @@
 
 use crate::{
     bindings,
-    page, //
+    page::Page, //
 };
 
 use core::{
@@ -169,7 +169,7 @@ unsafe fn realloc(
 }
 
 impl Vmalloc {
-    /// Convert a pointer to a [`Vmalloc`] allocation to a [`page::BorrowedPage`].
+    /// Convert a pointer to a [`Vmalloc`] allocation to a [`Page`] reference.
     ///
     /// # Examples
     ///
@@ -202,20 +202,17 @@ impl Vmalloc {
     ///
     /// - `ptr` must be a valid pointer to a [`Vmalloc`] allocation.
     /// - `ptr` must remain valid for the entire duration of `'a`.
-    pub unsafe fn to_page<'a>(ptr: NonNull<u8>) -> page::BorrowedPage<'a> {
+    pub unsafe fn to_page<'a>(ptr: NonNull<u8>) -> &'a Page {
         // SAFETY: `ptr` is a valid pointer to `Vmalloc` memory.
         let page = unsafe { bindings::vmalloc_to_page(ptr.as_ptr().cast()) };
 
-        // SAFETY: `vmalloc_to_page` returns a valid pointer to a `struct page` for a valid pointer
-        // to `Vmalloc` memory.
-        let page = unsafe { NonNull::new_unchecked(page) };
-
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
index 02fda3ea5cae6..8dcc16ed89893 100644
--- a/rust/kernel/alloc/allocator/iter.rs
+++ b/rust/kernel/alloc/allocator/iter.rs
@@ -9,7 +9,7 @@
     ptr::NonNull, //
 };
 
-/// An [`Iterator`] of [`page::BorrowedPage`] items owned by a [`Vmalloc`] allocation.
+/// An [`Iterator`] of [`Page`](page::Page) references owned by a [`Vmalloc`] allocation.
 ///
 /// # Guarantees
 ///
@@ -28,11 +28,11 @@ pub struct VmallocPageIter<'a> {
     size: usize,
     /// The current page index of the [`Iterator`].
     index: usize,
-    _p: PhantomData<page::BorrowedPage<'a>>,
+    _p: PhantomData<&'a page::Page>,
 }
 
 impl<'a> Iterator for VmallocPageIter<'a> {
-    type Item = page::BorrowedPage<'a>;
+    type Item = &'a page::Page;
 
     fn next(&mut self) -> Option<Self::Item> {
         let offset = self.index.checked_mul(page::PAGE_SIZE)?;
diff --git a/rust/kernel/page.rs b/rust/kernel/page.rs
index 1c0796ea229f0..a2610774c7499 100644
--- a/rust/kernel/page.rs
+++ b/rust/kernel/page.rs
@@ -12,16 +12,17 @@
         code::*,
         Result, //
     },
+    sync::aref::{
+        ARef,
+        AlwaysRefCounted,
+        RefCounted, //
+    },
+    types::Opaque,
     uaccess::UserSliceReader, //
 };
-use core::{
-    marker::PhantomData,
-    mem::ManuallyDrop,
-    ops::Deref,
-    ptr::{
-        self,
-        NonNull, //
-    }, //
+use core::ptr::{
+    self,
+    NonNull, //
 };
 
 /// A bitwise shift for the page size.
@@ -65,93 +66,30 @@ pub const fn page_align(addr: usize) -> Option<usize> {
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
-///
-/// fn borrow_page<'a>(vbox: &'a mut VBox<MaybeUninit<[u8; PAGE_SIZE]>>) -> BorrowedPage<'a> {
-///     let ptr = ptr::from_ref(&**vbox);
-///
-///     // SAFETY: `ptr` is a valid pointer to `Vmalloc` memory.
-///     let page = unsafe { bindings::vmalloc_to_page(ptr.cast()) };
-///
-///     // SAFETY: `vmalloc_to_page` returns a valid pointer to a `struct page` for a valid
-///     // pointer to `Vmalloc` memory.
-///     let page = unsafe { NonNull::new_unchecked(page) };
-///
-///     // SAFETY:
-///     // - `self.0` is a valid pointer to a `struct page`.
-///     // - `self.0` is valid for the entire lifetime of `self`.
-///     unsafe { BorrowedPage::from_raw(page) }
-/// }
-///
-/// let mut vbox = VBox::<[u8; PAGE_SIZE]>::new_uninit(GFP_KERNEL)?;
-/// let page = borrow_page(&mut vbox);
-///
-/// // SAFETY: There is no concurrent read or write to this page.
-/// unsafe { page.fill_zero_raw(0, PAGE_SIZE)? };
-/// # Ok::<(), Error>(())
-/// ```
-///
-/// # Invariants
-///
-/// The borrowed underlying pointer to a `struct page` is valid for the entire lifetime `'a`.
-///
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
-
-impl<'a> Deref for BorrowedPage<'a> {
-    type Target = Page;
-
-    fn deref(&self) -> &Self::Target {
-        &self.0
-    }
-}
-
-/// Trait to be implemented by types which provide an [`Iterator`] implementation of
-/// [`BorrowedPage`] items, such as [`VmallocPageIter`](kernel::alloc::allocator::VmallocPageIter).
+/// Trait to be implemented by types which provide an [`Iterator`] of [`Page`] references, such as
+/// [`VmallocPageIter`](kernel::alloc::allocator::VmallocPageIter).
 pub trait AsPageIter {
     /// The [`Iterator`] type, e.g. [`VmallocPageIter`](kernel::alloc::allocator::VmallocPageIter).
-    type Iter<'a>: Iterator<Item = BorrowedPage<'a>>
+    type Iter<'a>: Iterator<Item = &'a Page>
     where
         Self: 'a;
 
-    /// Returns an [`Iterator`] of [`BorrowedPage`] items over all pages owned by `self`.
+    /// Returns an [`Iterator`] of [`Page`] references over all pages owned by `self`.
     fn page_iter(&mut self) -> Self::Iter<'_>;
 }
 
-/// A pointer to a page that owns the page allocation.
+/// A `struct page`.
+///
+/// A `Page` is accessed through a shared reference or through an owning [`ARef<Page>`]. The page
+/// allocation is freed when the last reference to it is dropped.
 ///
 /// # Invariants
 ///
-/// The pointer is valid, and has ownership over the page.
+/// The `Page` is backed by a valid `struct page` whose allocation is managed by the page
+/// reference count.
+#[repr(transparent)]
 pub struct Page {
-    page: NonNull<bindings::page>,
+    page: Opaque<bindings::page>,
 }
 
 // SAFETY: Pages have no logic that relies on them staying on a given thread, so moving them across
@@ -185,19 +123,20 @@ impl Page {
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
 
     /// Returns a raw pointer to the page.
     pub fn as_ptr(&self) -> *mut bindings::page {
-        self.page.as_ptr()
+        self.page.get()
     }
 
     /// Get the node id containing this page.
@@ -373,10 +312,26 @@ pub unsafe fn copy_from_user_slice_raw(
     }
 }
 
-impl Drop for Page {
+// SAFETY: `struct page` is managed by the page reference count. Incrementing it via `get_page()`
+// keeps the page alive at least until a matching `put_page()`, which frees the page when the
+// count reaches zero. By the type invariant, all `Page` instances are backed by refcounted
+// pages.
+unsafe impl RefCounted for Page {
     #[inline]
-    fn drop(&mut self) {
-        // SAFETY: By the type invariants, we have ownership of the page and can free it.
-        unsafe { bindings::__free_pages(self.page.as_ptr(), 0) };
+    fn inc_ref(&self) {
+        // SAFETY: By the type invariant, `self.as_ptr()` points to a valid `struct page` with a
+        // non-zero reference count.
+        unsafe { bindings::get_page(self.as_ptr()) };
+    }
+
+    #[inline]
+    unsafe fn dec_ref(obj: NonNull<Self>) {
+        // SAFETY: By the function safety requirements, the caller relinquishes a reference count
+        // on the page. Since `Page` is transparent, we can cast the pointer directly.
+        unsafe { bindings::put_page(obj.cast().as_ptr()) };
     }
 }
+
+// SAFETY: We do not implement `Ownable`, thus it is okay to obtain an `ARef<Page>` from a
+// `&Page`.
+unsafe impl AlwaysRefCounted for Page {}

-- 
2.51.2



