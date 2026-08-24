Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C1E3C5DF94
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 11:20:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E8616B00A6; Mon, 24 Aug 2026 07:20:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 199196B00A7; Mon, 24 Aug 2026 07:20:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 061CE6B00A9; Mon, 24 Aug 2026 07:20:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C93916B00A6
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 07:20:15 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4E5A31604EF
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 11:20:15 +0000 (UTC)
X-FDA: 85135919190.25.9E7B2AD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 76452C0007
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 11:20:13 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KRVia9o3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787570413;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kDuMCVJhBqI1nqWxe278yrezudc3hlS3mEBUqJMOwj4=;
	b=KqFQHlJE7+0GyvMTeLbHib4J2iAZ/SlftauqdiWEFMhXx7hAWRdkXOqJfXgrG/Ii9dfzFs
	GZJvjAKE1owFewDsgM1q3nQ+V+R38ZVNo7n1oVn2zW3n5YrlPDiF6c9aT674IR8mT5xnXx
	6u4lys+j7IxM6QaqqTR6X+cX5Skk/wk=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KRVia9o3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787570413;
	b=jXtzV6HyFeXYHjLuG91pJsVCK5cRPJLbdFdBE2mc2T1cIKTZa3Vn6CkbYsWUer1sSTW49t
	EIzRNG5KZhfGlyZbtVzTf5iuTPUBymQTH20WUkLtXUK9uLyxcXJLbmzI35iiiJcy8sA78D
	82cf6n0bBZjfWL2aNf18kO34jhrwWjY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C4E07402B5;
	Mon, 24 Aug 2026 11:20:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED4271F00A3A;
	Mon, 24 Aug 2026 11:20:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787570412;
	bh=kDuMCVJhBqI1nqWxe278yrezudc3hlS3mEBUqJMOwj4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=KRVia9o3+c+QTPWV+szez05sgvDgo0NMs0Gu1+23Z+Iu5uaprBAw5EsE2ixNGlkut
	 T3J+0+oVEeDwYn1p5XQnAkSkNGuN0n39I3PyPJAc0QUBVM7PGlHtFz/IErcpLcEpQW
	 OxIpqqvhKAv5rFbb3MjLXPTVZcD+CZqokEM2s+5J5kukEgg5JKUiBj4fq8Ekp5llsR
	 l47KpTVlrYGNsxAIiqOs8zWZYiq+SidBHSmnwfwrvGjVXpwaUp2gdCWBP4wZv8i14q
	 oY3l0eZbGfi/xDKq7ZCRZLJQF5FZwCuh2Wz0n7WiSeVTRf+9R58D3jzvLgv2OaSkzC
	 Av8TXMK+84YaA==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Mon, 24 Aug 2026 13:17:56 +0200
Subject: [PATCH v20 4/8] rust: page: convert to `Ownable`
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260824-unique-ref-v20-4-490735672187@kernel.org>
References: <20260824-unique-ref-v20-0-490735672187@kernel.org>
In-Reply-To: <20260824-unique-ref-v20-0-490735672187@kernel.org>
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
 Ira Weiny <iweiny@kernel.org>
Cc: Andreas Hindborg <a.hindborg@kernel.org>, 
 Philipp Stanner <phasta@kernel.org>, rust-for-linux@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 driver-core@lists.linux.dev, linux-block@vger.kernel.org, 
 linux-security-module@vger.kernel.org, dri-devel@lists.freedesktop.org, 
 linux-fsdevel@vger.kernel.org, linux-pm@vger.kernel.org, 
 linux-pci@vger.kernel.org, linux-pwm@vger.kernel.org, 
 linux-usb@vger.kernel.org, Asahi Lina <lina+kernel@asahilina.net>
X-Mailer: b4 0.16-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=11939;
 i=a.hindborg@kernel.org; h=from:subject:message-id;
 bh=G6w43uJEPXw5lopecxdvPOiB5xddhi2+71XcxmRyAs8=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBqjCiD9v9KKGbLCUpwJf5uJb70ntKm8NGC/+1D/
 8jS3Iq06K6JAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCaowogwAKCRD6UCkIqsW9
 0DoLD/9LpWae0rOQtPcUYnTs1LIXKraN0qmPeUbDXPA0KkfOzZCBp1v9Ny5YLNBvJEkpu7zXpDN
 yofW32pkcUVdGLs+LvGvNSV788U7QKCO45TjZEo1FwSifNrnvwK4SpgwtS7Wd3G1E3XeNJaPqxK
 KRySTsFoC12QUffhye1s62ft/d4duGjZXtpCM/sz/7Owt5Cfkuce3g+eeXuMHk1aSuoAIzNRTxW
 vGLMmDgWGo+zSFQqKDu6sBmrZX89sntkV5MxJoweExHZWvaTqPxRKLfXIgo/Np1m/V3MdhHk90h
 s+IT4c/xI6dHWISd69EzdB8XK7f954y+5W3n7Rox9fYIk5hMddl/C6z+wFeFyTH0KRQSjlNvtGJ
 7AzTmD3D8j6z3HUyhYocd4OmuFytudsfN97fY/beJUDVD012XJUuyddj6VDZoH7lcypLvAq8CXd
 8QNhprSja/FXct3vQqidL/0Lu2sIcNjkdp8o8RXaBMHsIWSJtVbiUNbIbbKk4Q6Cbw/Nzd3hnM1
 y3Qz/jImYdAQot079+hRq/7QQXW62nw9o0pwdnSl1nLlgNS2mIhQHQhQyTNuIs05uy6k1L25UDS
 1yCLPL1ZgiyzWM5NnHCuNVe36Z/4q4yOXMQjnXeN+q2Nv1JoiYKq/kX29a32i03XL1+b6Yfuubb
 T0MeqET9MMGvYQw==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspam-User: 
X-Rspamd-Queue-Id: 76452C0007
X-Rspamd-Server: rspam07
X-Stat-Signature: b4mjzt5jihwbtezpgnumt9s4agcha6hh
X-HE-Tag: 1787570413-91282
X-HE-Meta: U2FsdGVkX1+cM+sENs2B0YOdHnYw08j/5nMtnw23wMUnOz5umhKFXkUvxR4y+8oTarJYgurphTd8wAxNxsGTa3uXwHbYQqLk4K/IK+UEQSTqn6iT6RZov4B9VaMtT1f2AkD6Hsblib4Ne+lUKB2V1/uihdY+dJAun94gCvb55xVHFPzGoum8/tsgigCDJGrmW5cMK5B6+w8T0kFpXRrRF1O4lUQ/g/GwPnvEeSkzeMGXhXyZJOVC6ClKSIRESzEqgE9ocHl5JY9CUi6tlR2mZ6Xq4/Aw7GO3DIf52ZagxWKBr932Wb4vT2OAyxn3ZeL4929EKurleVMtpCNYAk6uYI/G1nmERFz5bRzFsfqC1OHVavVOmp1YQdOCT6c6jnfsyV1MoRKS2PQlnK8vQgbWjcWCxJpxHJgaV2g7jmIX2bIsdF7GSBEtMI0B3VEvx6TCgYQmx9rjQx8ObqkZTCgDyIlNOjYdfe/fM7zJMl1ee1cYgXJ30yBA0owd34opf1KgAuQF1lORKbZpI2j8wJ2ieclLf9hbPf2XChF/DewLJsR8Jnnz7kE5VEFm7nCQ6eRhCA0xIA0uM2EfFO1z628qE1tPXk67oU+FOsSH/FUDcG6WLCvRl3hNThnKAU5ql14ol//IEY6K1Fk3uGM1vVpoXy/ZLBTUhahlaiANwGSgLPeO9aXuevj1kUPDL2ByEP6mHZGHZrLWawu85heT5RoHfUbze7cuYV4JGQuiwrr2e7d717idJK0EdKkWuXL5UIDuZ2fzxZ0azvPXFEnFXX6vK6VmJrq3rcXy19+gkUy3ebudniVHux4YtF15kGRe1pZmMP0aRs/IUzdyB4jTHfVWpvLEcbjzXgtshGibwPYlxaAp3CozYCjySwPKLcdHTHv23hTcUl2+8dpCAif8VXHq1Erk7j1A2fK77ddW4NDy+nSD+bErETnGKiZQth3Y+jr9UbPXXKqOHc/8oB58K+L
 WqE1qVuu
 MoHxEH2S34jX8QdJXatuASsCIFUgV00cDRi2J7RQv83BvHfPuCAvg44wU5fTUWy0O0HKnk4IYtN13pcqSiv/l+2ZAsy9Qap3SF1MppPSn7dcyTgYmPHYrnYAlQRFHjdXa5hAwxQmUTeQvkSnGFBkO7H9S9EI7OMk+mCWL5BIgn+yYnLSx0c5su9qS/X9qO9jvrXW/4NdRhmLNczrxvty1lYrFu33zUQNz2upiwNonN3kJdvNqriXbj9F9tbVfNJsecHmjxDsuvITdE1xDjyk87E7Ffpm42z/sgysVNrc0r4whplMuwRBufa/rYqRcc2gNLhjA1LPfH1Vaa9Qz6l5Vtdm1LOrVoGnhtVGv5+0CqSksf97HOND/qpu1hjWBdB7MfrQToeo9oD7ai8E8ybn1vBRRk73KSd0qXJ9jZATIvSCU0gjE7Lib4VQhWREDlKtGT7TmMd4ja3j9nK7K5WyotLcPOV2alA9+c89rKD3MnQ71leHg4I73LCwrAw==
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
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
---
 drivers/android/binder/page_range.rs |  10 +--
 rust/kernel/alloc/allocator.rs       |  19 +++---
 rust/kernel/alloc/allocator/iter.rs  |   6 +-
 rust/kernel/page.rs                  | 122 +++++++++--------------------------
 4 files changed, 46 insertions(+), 111 deletions(-)

diff --git a/drivers/android/binder/page_range.rs b/drivers/android/binder/page_range.rs
index e82a5523804f4..c55ba29abea71 100644
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
index 1c0796ea229f0..e807ffe3cfefb 100644
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
+        self.page.get()
     }
 
     /// Get the node id containing this page.
@@ -373,10 +310,11 @@ pub unsafe fn copy_from_user_slice_raw(
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



