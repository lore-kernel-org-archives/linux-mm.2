Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45B6ACD4F26
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 11:56:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0EF136B0136; Fri, 26 Jun 2026 07:56:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0795A6B0138; Fri, 26 Jun 2026 07:56:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E83336B0139; Fri, 26 Jun 2026 07:56:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B21016B0136
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 07:56:16 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 29ABE14040C
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 11:56:16 +0000 (UTC)
X-FDA: 84921910752.05.645CDEA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 5EDAB40007
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 11:56:14 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=e2HjqLdX;
	spf=pass (imf11.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782474974;
	b=ntstT7HT7tLeJ7t3vN4B+ap4slWeN0fyNLE/8g0zLqUewL4rKdPeIoL1+RaNDHU71b78Jz
	TYPOKKeBr7EH8GyHpdYv3DOrmQsLA8L3uBKe6NkoBTkFuq8jiJz06AzjkDgy9NgBYojjS1
	iOHicyF5/gCjOM5kMEuCND79ZUMtYHo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782474974;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Bin9OshcS/0Q4LoasQxw3FlG5Jjc6G5Z3KsYRu0B2FU=;
	b=ZpuhZHhjGNI4r5eIt8mh0AScxJEp0kjNZqh5exZ+pOzKwl4NIg3Tm7JCWXZw9oR1fepDoR
	Yto4d9xFazMUp/zC2cPr1aHJmIteigFaeeIC5RzbEB+StX1oI/cIrz2WlGUEZ/U0uZXXkt
	CZZNVH2j1biwnWtQh/9zdpATdfXK12E=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=e2HjqLdX;
	spf=pass (imf11.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D044260098;
	Fri, 26 Jun 2026 11:56:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18FAA1F00A3D;
	Fri, 26 Jun 2026 11:56:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782474973;
	bh=Bin9OshcS/0Q4LoasQxw3FlG5Jjc6G5Z3KsYRu0B2FU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=e2HjqLdX8rb3hYbzK48OJyIhzraVLRWfX+FWMqFMCzo9gXVCLAJmVGfYTaQyp02MM
	 1beqryTAdyWlhi7c8QFSEtZ1CILF3aUHQzOWRlwXByODwaL9Bnq8chl9R+3hbRNzuk
	 LtyKqJECTTnFiJNX/Zg06ZgWVSxdipj7gHPH7WB5O+BYypWSe5Y8ix9aG8b/tJVXXk
	 CIPSlsoIN7RExURrPhXYmZq4TmtaiDl7xRxZeHvMIwAzMJcrjpIEgFd9fAJjE5dwC8
	 kF+Vj3jW3YfynSAzI4cWJenkzrsCZkwf1UYJr7zTsBxi9RwwBDY72q1eQbEDZckG3G
	 MW/uszgOTFUjQ==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Fri, 26 Jun 2026 13:54:01 +0200
Subject: [PATCH v19 4/8] rust: page: convert to `Ownable`
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260626-unique-ref-v19-4-2607ca88dfdf@kernel.org>
References: <20260626-unique-ref-v19-0-2607ca88dfdf@kernel.org>
In-Reply-To: <20260626-unique-ref-v19-0-2607ca88dfdf@kernel.org>
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
 Dave Ertman <david.m.ertman@intel.com>, Ira Weiny <ira.weiny@intel.com>, 
 Leon Romanovsky <leon@kernel.org>, Paul Moore <paul@paul-moore.com>, 
 Serge Hallyn <sergeh@kernel.org>, David Airlie <airlied@gmail.com>, 
 Simona Vetter <simona@ffwll.ch>, Alexander Viro <viro@zeniv.linux.org.uk>, 
 Jan Kara <jack@suse.cz>, Igor Korotin <igor.korotin@linux.dev>, 
 Viresh Kumar <vireshk@kernel.org>, Nishanth Menon <nm@ti.com>, 
 Stephen Boyd <sboyd@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>, 
 =?utf-8?q?Krzysztof_Wilczy=C5=84ski?= <kwilczynski@kernel.org>, 
 Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, 
 Michal Wilczynski <m.wilczynski@samsung.com>
Cc: Andreas Hindborg <a.hindborg@kernel.org>, 
 Philipp Stanner <phasta@kernel.org>, rust-for-linux@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 driver-core@lists.linux.dev, linux-block@vger.kernel.org, 
 linux-security-module@vger.kernel.org, dri-devel@lists.freedesktop.org, 
 linux-fsdevel@vger.kernel.org, linux-pm@vger.kernel.org, 
 linux-pci@vger.kernel.org, linux-pwm@vger.kernel.org, 
 Asahi Lina <lina+kernel@asahilina.net>
X-Mailer: b4 0.16-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=11905;
 i=a.hindborg@kernel.org; h=from:subject:message-id;
 bh=0tBaWt6qkrDUI2N6nu7SQxnFyUvs8y7lmCxwWfJLPDo=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBqPmh3GBh8sy4cjSOhi49SZKrsH/nNhyGHYuGzL
 9PAeUuQrI2JAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCaj5odwAKCRD6UCkIqsW9
 0CbOEACZXh9pBrAlP+99ZXl1KTzM4RDTQOAoAVSi+Bw95O0rsT2J+fuosnuDQ5YrJmItVU/Dz7y
 U61x8Ywaf4j9fvhXN1r1EX4pFWKlnP+DicNMYaH8HEAdBujyiy0meUMBbTy80I6mIvrMIhyUxPO
 vkTlHDUvVFeJTlcDOrj5ckCFf91f7aZxsx+xywEowRddbIQnntWXuCNtoRBV1maJYnKkWzLxWdi
 uAN8dUez524S3zZTvT5f/NlHuASDkrt0LV1I1hsR+SCD+4NaLspTp8x5FXtWhjVYjeopV9ISkt5
 bWOez7NXzMKyrQv0lA2UV+vU0mC46FtIRBSXxNBzEqLjOiWZX3GaRSMG3KKWcPN/Ta42/KJU6UX
 DVF/MQNXw/GoRZvKcYl9RZBwJFPx6U2pprPKk1RuSAVTIDaLCLB8pThJJTnR9p4hgI/1NTQ4TSq
 6/27mPZYD5tstAabYui/go4RXDZs31P0Rmxc2Cmr6H9BXrmTqalswXn5PdKl/+ih5bphPV4igdy
 AoKYXvqrp9aniFd47MZ6EaLEmo2TrATijJ/L1TSRrdr19HZi38Wb0YUOZi0i4zQ3NIZgbErWhCX
 gXfRj0Ks1/xoBreZHj5BauqvyoO83FCCQqthnuOvAI/CgtRMVAqQKHfwKl7pmha31aqzyp95k6Z
 UW7bIu8+7cUEDWg==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Stat-Signature: odda4nwbk83icsoormrpn3nwqogh6y4f
X-Rspam-User: 
X-Rspamd-Queue-Id: 5EDAB40007
X-Rspamd-Server: rspam02
X-HE-Tag: 1782474974-583031
X-HE-Meta: U2FsdGVkX1/eEyd3bwv7Y4Uq2IC232aCmVSyXahUa7nM3f574lB8lUGC9xyVFL17yw2IT9LZlWIR4LDXn93pQSxnZb4nMnjUMN279emhQKe8/fnKcCipafAPX48mqEZyvrDUi8XLHvy78MvbvNi2Kcc4sJfmlHyUufEdDRU6EjrLVGhfZucn7q7xyl7h+1Vo2EY4fHyBDIuH5F60IQyiLbe648F6ZRs5wZAFD0n4ixqTG+dmwadn0x0Rn/5YhxtsMuV/dWeWpBMAffaHeAi4EGBlPpWHRyhuCl/Lc+0uawJRfCqq4RjiThoLIEM9UeNQjKNfKAQUSHy2sMw/Twm5LKfSgavyqR6QTJgjDgl5nRk5gAyRJCtGQFkmazmkrhI/TDeW5K2zes65lygKoyXv4WR8astSmx2/K1y6KUlMy65Mni03uBin5OPvlTEkOU3HJ3mjZibHtQwfzFh1cDYmwWiLNtdiVaRd7F/604CORT4kmPhxRmUss9dRtSWz+M1IUhbyBgFIDDgB8XJ03TqYUXalPEVlymTtf6rvbRjrhIPXu/Qq3aVGde8sFt6DDwa+IubhgOviTomKtwmuiFkfyt2Oy2GV9YXqzp2KrBE7O6lfD/i/MkD0RM6Gu5Sc+83jULMLa1ElFrCFLexzfNt5DXN+8tsBf42mgOptiuEQjWpG7oRzixUWKnagd+J+Gs9cVR06+pzIn8fHy/u7YaYLyhnTKa2NXCvMePVRNBmSpkiXbuKfksFfMN9Adt4MKG+UPcUWwAiRewugH7zHQocGmxWbrk8gOtC2ta/6rx2Egx9NpvOo94WA+HY0KP79v3/A4ezFVSobR02wGqL+IJXBm+QLxctf2G61pBIlvqIPYCdIE8c6SLuHXXS1WIiGgCGJi9C3mAKi0nMWTUNwhoeQZCwrjB+OoHpxHX2yhuVBYCj/I7h3zgQHdwy8Uf7+fyHg8U7vWOJkA2tZbLVxJV9
 fKW57E1l
 12K01PP7pKxmuEkefMLOwHciapymuOjwDDhcmFhAEZPfdD8f+t3GZmE6Twg1iW0EmZjTk+GzBN/zXOdQ6DgSCiNy3xsd14Pr0bZLEoajZ7jRA1ECXpeq3QfS0AzvqlPT+1x0J/X07vYNK7zi2/L2fX/q27vA7xno/Pe2TIRjWyCmODo9QnDgaN1iyifuG9u2YgIRVI5xBsdUIHZTX9wbh/C+U/qdDpx5ukCSsucZ+bneqiN/ItvZY8LIEWDFuUWfV6S5kh6dmr2tmhd+TYBG1jrOYy/lgy/PFR/SSOO9iZ8ZBoW5s8JiEP+L7Tj2IAKRzXt9NQEV+BikGTsMGH4roZ+cZiXgPuuqXly9KOfc44XdCNcFlS+1XO8cs1MJEEbxCxi/5xug2GjVo+g3Qs9Sar4jcNPTuGi74kHTQutMd0gWs+BE1PIsveD2pCjKo/ovsAu2Gm2hJBhILU9UuLsU3qAvcFuBSoo9rctgS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Asahi Lina <lina@asahilina.net>

This allows Page references to be returned as borrowed references,
without necessarily owning the struct page.

Remove `BorrowedPage` and update users to use `Owned<Page>`.

Signed-off-by: Asahi Lina <lina@asahilina.net>
[ Andreas: Fix formatting and add a safety comment, update users. ]
Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
Reviewed-by: Gary Guo <gary@garyguo.net>
---
 drivers/android/binder/page_range.rs |  10 +--
 rust/kernel/alloc/allocator.rs       |  19 +++---
 rust/kernel/alloc/allocator/iter.rs  |   6 +-
 rust/kernel/page.rs                  | 122 +++++++++--------------------------
 4 files changed, 46 insertions(+), 111 deletions(-)

diff --git a/drivers/android/binder/page_range.rs b/drivers/android/binder/page_range.rs
index e54a90e62402a..7941eb85b4ef4 100644
--- a/drivers/android/binder/page_range.rs
+++ b/drivers/android/binder/page_range.rs
@@ -33,7 +33,7 @@
     sync::{aref::ARef, Mutex, SpinLock},
     task::Pid,
     transmute::FromBytes,
-    types::Opaque,
+    types::{Opaque, Owned},
     uaccess::UserSliceReader,
 };
 
@@ -198,7 +198,7 @@ unsafe impl Send for Inner {}
 #[repr(C)]
 struct PageInfo {
     lru: bindings::list_head,
-    page: Option<Page>,
+    page: Option<Owned<Page>>,
     range: *const ShrinkablePageRange,
 }
 
@@ -206,7 +206,7 @@ impl PageInfo {
     /// # Safety
     ///
     /// The caller ensures that writing to `me.page` is ok, and that the page is not currently set.
-    unsafe fn set_page(me: *mut PageInfo, page: Page) {
+    unsafe fn set_page(me: *mut PageInfo, page: Owned<Page>) {
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
+    unsafe fn take_page(me: *mut PageInfo) -> Option<Owned<Page>> {
         // SAFETY: This pointer offset is in bounds.
         let ptr = unsafe { &raw mut (*me).page };
 
diff --git a/rust/kernel/alloc/allocator.rs b/rust/kernel/alloc/allocator.rs
index cd4203f27aed0..c7b9b069cf75d 100644
--- a/rust/kernel/alloc/allocator.rs
+++ b/rust/kernel/alloc/allocator.rs
@@ -169,7 +169,7 @@ unsafe fn realloc(
 }
 
 impl Vmalloc {
-    /// Convert a pointer to a [`Vmalloc`] allocation to a [`page::BorrowedPage`].
+    /// Convert a pointer to a [`Vmalloc`] allocation to a [`Page`](page::Page) reference.
     ///
     /// # Examples
     ///
@@ -202,20 +202,17 @@ impl Vmalloc {
     ///
     /// - `ptr` must be a valid pointer to a [`Vmalloc`] allocation.
     /// - `ptr` must remain valid for the entire duration of `'a`.
-    pub unsafe fn to_page<'a>(ptr: NonNull<u8>) -> page::BorrowedPage<'a> {
+    pub unsafe fn to_page<'a>(ptr: NonNull<u8>) -> &'a page::Page {
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
index 8affd8262891b..6dc1c2395acaf 100644
--- a/rust/kernel/page.rs
+++ b/rust/kernel/page.rs
@@ -12,16 +12,16 @@
         code::*,
         Result, //
     },
+    types::{
+        Opaque,
+        Ownable,
+        Owned, //
+    },
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
@@ -65,93 +65,29 @@ pub const fn page_align(addr: usize) -> Option<usize> {
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
+/// A `Page` is accessed through a shared reference or through an owning [`Owned<Page>`]; the latter
+/// frees the page allocation when it is dropped.
 ///
 /// # Invariants
 ///
-/// The pointer is valid, and has ownership over the page.
+/// The `Page` is backed by a valid `struct page`.
+#[repr(transparent)]
 pub struct Page {
-    page: NonNull<bindings::page>,
+    page: Opaque<bindings::page>,
 }
 
 // SAFETY: Pages have no logic that relies on them staying on a given thread, so moving them across
@@ -185,19 +121,20 @@ impl Page {
     /// # Ok::<(), kernel::alloc::AllocError>(())
     /// ```
     #[inline]
-    pub fn alloc_page(flags: Flags) -> Result<Self, AllocError> {
+    pub fn alloc_page(flags: Flags) -> Result<Owned<Self>, AllocError> {
         // SAFETY: Depending on the value of `gfp_flags`, this call may sleep. Other than that, it
         // is always safe to call this method.
         let page = unsafe { bindings::alloc_pages(flags.as_raw(), 0) };
         let page = NonNull::new(page).ok_or(AllocError)?;
-        // INVARIANT: We just successfully allocated a page, so we now have ownership of the newly
-        // allocated page. We transfer that ownership to the new `Page` object.
-        Ok(Self { page })
+        // SAFETY: We just successfully allocated a page, so we now have ownership of the newly
+        // allocated page. We transfer that ownership to the new `Owned<Page>` object.
+        // Since `Page` is transparent, we can cast the pointer directly.
+        Ok(unsafe { Owned::from_raw(page.cast()) })
     }
 
     /// Returns a raw pointer to the page.
     pub fn as_ptr(&self) -> *mut bindings::page {
-        self.page.as_ptr()
+        Opaque::cast_into(&self.page)
     }
 
     /// Get the node id containing this page.
@@ -372,10 +309,11 @@ pub unsafe fn copy_from_user_slice_raw(
     }
 }
 
-impl Drop for Page {
+impl Ownable for Page {
     #[inline]
-    fn drop(&mut self) {
-        // SAFETY: By the type invariants, we have ownership of the page and can free it.
-        unsafe { bindings::__free_pages(self.page.as_ptr(), 0) };
+    unsafe fn release(this: NonNull<Self>) {
+        // SAFETY: By the function safety requirements, we have ownership of the page and can free
+        // it. Since Page is transparent, we can cast the raw pointer directly.
+        unsafe { bindings::__free_pages(this.as_ptr().cast(), 0) };
     }
 }

-- 
2.51.2



