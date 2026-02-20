Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3965C5516E
	for <linux-mm@archiver.kernel.org>; Fri, 20 Feb 2026 09:52:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 63F1F6B0088; Fri, 20 Feb 2026 04:52:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 60C9D6B0092; Fri, 20 Feb 2026 04:52:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 543036B0093; Fri, 20 Feb 2026 04:52:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 429EE6B0088
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 04:52:17 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DB5AA1B4D63
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 09:52:16 +0000 (UTC)
X-FDA: 84464369472.03.47C0DAD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 1F6F72000D
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 09:52:14 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dXf1Qrrr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771581135; a=rsa-sha256;
	cv=none;
	b=bNl31Eg56CZ+WXThdV/04VfzsIAT96V6qSiJT+ppVloGajD2DjkUN09A4euSd/QtrLnluP
	s6SuYz6iDbll3aeYly8kHKORhEv79HfQsb4absEC1TqdX5ry5DT6TzNqpRo96oIh+IpR/J
	PA2KwB5UZrQ2AV16zSyUuE01Rmks63w=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dXf1Qrrr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771581135;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pE/SBXAICjL/Pc2jZ0o9zPT6dEbyEUf/taTW7Mddrig=;
	b=l4W/n/AGY/V0NjYLWAGq4VMEXbWihwV4awgWZdm5yNaHUUh/G5gK0k3g4Q7Lpk5EihyHSd
	CyVG0kk7+iWcFS950sKRZZoy32tkjTwY3HuOBtfeTKSew1cKv3XRGyDNiwj73Vn9WK4B2c
	MFZYo/2MKFOI3wBfFNJiZ1v0fpjue8A=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 90F376184D;
	Fri, 20 Feb 2026 09:52:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1CE7C116D0;
	Fri, 20 Feb 2026 09:52:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771581134;
	bh=PtI8dWeXLCFOQOrt2qgQQvMv1kCph8ZiB7DPs66Ug2g=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=dXf1QrrrR70di7dbarSVglO5Fj69PyruSvuzBcvFbhIgzxWo02br6JPUlDXhjXmrf
	 f2scy0IQU1JRq7+r9QecQihcBPbcNzeRSvZ6jgaehMhs8Gbx6Z+S6H8KZUv2+xBnq4
	 JsH2OTUHS/7hhdnj41GxFJLGN5jwFe2t9y8LAuDRMaouj9svA8xL1j2RnxYikI5h2f
	 XHsusFjjM2ekUAXmqKbnHx8P8of1p6T43UBEdAzQBGEAtMe3ULzWcnOIxjlBD1IbSF
	 hl9elv7O1k0c6N97uk3jhqX1zXltTxyl0SvULg0R6tWDEr5umcPNpw4ijbCbIuauY5
	 U8dz0BwB7aBmw==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Fri, 20 Feb 2026 10:51:16 +0100
Subject: [PATCH v15 7/9] rust: page: convert to `Ownable`
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260220-unique-ref-v15-7-893ed86b06cc@kernel.org>
References: <20260220-unique-ref-v15-0-893ed86b06cc@kernel.org>
In-Reply-To: <20260220-unique-ref-v15-0-893ed86b06cc@kernel.org>
To: Miguel Ojeda <ojeda@kernel.org>, Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Benno Lossin <lossin@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
 Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 Dave Ertman <david.m.ertman@intel.com>, Ira Weiny <ira.weiny@intel.com>, 
 Leon Romanovsky <leon@kernel.org>, Paul Moore <paul@paul-moore.com>, 
 Serge Hallyn <sergeh@kernel.org>, "Rafael J. Wysocki" <rafael@kernel.org>, 
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 Igor Korotin <igor.korotin.linux@gmail.com>, 
 Daniel Almeida <daniel.almeida@collabora.com>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Viresh Kumar <vireshk@kernel.org>, Nishanth Menon <nm@ti.com>, 
 Stephen Boyd <sboyd@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>, 
 =?utf-8?q?Krzysztof_Wilczy=C5=84ski?= <kwilczynski@kernel.org>, 
 Boqun Feng <boqun@kernel.org>, Boqun Feng <boqun@kernel.org>
Cc: linux-kernel@vger.kernel.org, rust-for-linux@vger.kernel.org, 
 linux-block@vger.kernel.org, linux-security-module@vger.kernel.org, 
 dri-devel@lists.freedesktop.org, linux-fsdevel@vger.kernel.org, 
 linux-mm@kvack.org, linux-pm@vger.kernel.org, linux-pci@vger.kernel.org, 
 Andreas Hindborg <a.hindborg@kernel.org>, 
 Asahi Lina <lina+kernel@asahilina.net>, 
 Asahi Lina <lina+kernel@asahilina.net>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=4163; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=6+8Px7vkn1ot/UgoHpPh8rLqE5ThXe9Oldbg1lnNpkQ=;
 b=owEBbQKS/ZANAwAKAeG4Gj55KGN3AcsmYgBpmC6k7RfPZnsjTWms0x9n3CTffEUPkBah98XHN
 US147G+SoWJAjMEAAEKAB0WIQQSwflHVr98KhXWwBLhuBo+eShjdwUCaZgupAAKCRDhuBo+eShj
 dxYZEACJweMLFS/q9Dm1TgYuSREDX3pcc2WCm7GWxm9txjo/5gTIwW/zXsrX37z7tZ7o8YtyFuU
 XPbg69eje9pdUXHRDilmI6KlU04ShDeZo812lmJgMV+NJah9iv3QblmQzw7greeD5ArcP/t6vKo
 APQIUEo8OhYDi7+Uf6HTmglpJKqvQ37nXcRmvFcb4IpLEOAsnFpJ2teFebTrtY1ca/oOlB6arNy
 Vh+HOpyc3Li9e2JdhRQHGMkXi5AmQqLKQsnRE6H7Pmjxm/E1QYVN/FWyxoaYRHErjHQ4rO7QHTh
 LFS/qf5NBk6Q1EUaS2GDmls3B+57VJ2NEIUyMgh9cIb6lMN6+T3EVVEfzqeSGpC8z0+5S3VuJFI
 IPZTv68uPsljfOb8QNysrowdf6KzGXFH047Qk/Ge74gJg9+kgRzTqZI+JxmDn0LWubhvo4TmabC
 o/AvVXVxiKLL2sD0wxsRBXTFNfAh4inpSRigkmlQv+6HTpUJEBuqNeHBIRdwaqQu1+yv2+MG9kt
 0G6BaCyhb6YVQvgSbIjRp6zmRk7Bs4V0aPzqF392zR0XbO1NwkuiPa/HAtknhIqS6WhL8Yi+QrA
 NSRqhV9l6Ad5sxLvkIIEGANdFOBAcK6kzuMfnuOZH0MLB63dDTOtkdp6KERDBSi3aTNZ8lPLNAW
 28WxMmyqzFhJnMA==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 1F6F72000D
X-Stat-Signature: 9ni99fyzfnq8xzk683y7t8rspoafohe5
X-HE-Tag: 1771581134-571323
X-HE-Meta: U2FsdGVkX18d/S5+EwkgKa3Yp3f68Mzk46SWaXOm4mZL5LII90o5xmf4ILINmqP2TxkvSR+6EGM3XcrZq/+FEmvPhCGsUVva3Sym0rTAdaI85wm6aZ7xYPxKii18cu7JBABRK75R7WsI765C+dzoFwpqAgrmsMfhlyyzI/F3UCtgarLyz6w8clyQZrSnE+NH1RQQ05ZvRRUzGNpBwaOGmQhxjux79BvavVjMZbTqvpjVc3+WYA2Wie9lrDWX/7eYDCVMcZfR1U1yrvtyImBar1bDLPA1J45tfWPlZph0airFajkaW+5z4ygWDVDM5fP9BADzDLjwabV/7NTHw9fgu4V6oT8wfU1a0KxWgScuMKGTI0x/sh+YMPUWL0DamY6zyEa55zHcJurBcuPuQROp8IR6e1O2V3vhhZR/KSjr2db4aoA9ZUy2hZLKk/3qS62/l3725EW0P/94kwyK+BTvq3lEGDfDzFr7oiqY2GEXgjp8/u3fQiYM0OwYw/7peUk/FNgjOp2dprGThqFqOr+mJHjtuT6qUBgQx70TTtdW5kEgfaz6pu/YS4t+4x5UN9sgIPPpurJRtEnpDrV8ch+lzcWhwo3VrPQ2ULpbpQAtgZwfZwsKx5YUkSwuvyJiWewwQxbA8+uM73ZsUUtW2Q7C9bQSlCEe8I3exjb9RQ9ebNoVnQPCcajpaZVZ1U5hUdbujqa1nC4MfcAz1QOaRRJbm1omm0J1rhpW7mkiIfbhMkaa1u4MUYzqJCqC/dVm7HokD0rUT8JKsIFyZ7V7Kiiqf1wjuj0nQnh+K53Fg/C4G0j1D1qOC3kraiYchRRUaqFqhGJEfEVTXBQWsOIFYpkLcEZ8MFV/iyJ2Br1WYA8gfQiNVEqlB1wJaDirWCxpVQW7C2ZUcM7Wce2TZYxdwER6Bo3DHp37Tdt+245YKMXxK8SoRJoX1bkziNZ5LFnfDXuWnFHA6KEoePNwTIR0duX
 YGaLfehP
 F8Mc74oCKcpsm7BKowjnUYRmEHY1S3p+HdO0GacDUykwjMkyIOYzUwrnymD63FuRLKZQVI1VjaaMxzzQP/rXtksg1+pIuE7Exq4QoXiK96I/4FAWxicDYepGK7l7CieyNDkYefdbob5nI5Jdx8HEn0oHILZ+CQJ1YvcTSRtrX2AEYhSA7jU2oIo6+ZLeVUCHqyotkQI+bgZEvgFbZLMCxVv0jxslp3sYn+N46a29SZZAfZFt8cQRKFiN8ZUYa8SCmmPPguL/pQ7TeRv7daXbwW/NEo4tI8zTVwuQUIil2cLciDyAzhxK0jR8dMA3+p+p/FfIFo54d2QRv6HJ2Ek6Rp6YxTKO3hxy07SDqFfy9GlflcbmYqkLnOoH33kz7uFMBolyy
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Asahi Lina <lina+kernel@asahilina.net>

This allows Page references to be returned as borrowed references,
without necessarily owning the struct page.

Signed-off-by: Asahi Lina <lina@asahilina.net>
[ Andreas: Fix formatting and add a safety comment. ]
Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 rust/kernel/page.rs | 34 +++++++++++++++++++++++-----------
 1 file changed, 23 insertions(+), 11 deletions(-)

diff --git a/rust/kernel/page.rs b/rust/kernel/page.rs
index bf3bed7e2d3fe..4591b7b01c3d2 100644
--- a/rust/kernel/page.rs
+++ b/rust/kernel/page.rs
@@ -10,6 +10,11 @@
     bindings,
     error::code::*,
     error::Result,
+    types::{
+        Opaque,
+        Ownable,
+        Owned, //
+    },
     uaccess::UserSliceReader, //
 };
 use core::{
@@ -83,7 +88,7 @@ pub const fn page_align(addr: usize) -> usize {
 ///
 /// [`VBox`]: kernel::alloc::VBox
 /// [`Vmalloc`]: kernel::alloc::allocator::Vmalloc
-pub struct BorrowedPage<'a>(ManuallyDrop<Page>, PhantomData<&'a Page>);
+pub struct BorrowedPage<'a>(ManuallyDrop<Owned<Page>>, PhantomData<&'a Owned<Page>>);
 
 impl<'a> BorrowedPage<'a> {
     /// Constructs a [`BorrowedPage`] from a raw pointer to a `struct page`.
@@ -93,7 +98,9 @@ impl<'a> BorrowedPage<'a> {
     /// - `ptr` must point to a valid `bindings::page`.
     /// - `ptr` must remain valid for the entire lifetime `'a`.
     pub unsafe fn from_raw(ptr: NonNull<bindings::page>) -> Self {
-        let page = Page { page: ptr };
+        let page: Owned<Page> =
+            // SAFETY: By function safety requirements `ptr` is non null and valid for 'a.
+            unsafe { Owned::from_raw(NonNull::new_unchecked(ptr.as_ptr().cast())) };
 
         // INVARIANT: The safety requirements guarantee that `ptr` is valid for the entire lifetime
         // `'a`.
@@ -126,8 +133,9 @@ pub trait AsPageIter {
 /// # Invariants
 ///
 /// The pointer is valid, and has ownership over the page.
+#[repr(transparent)]
 pub struct Page {
-    page: NonNull<bindings::page>,
+    page: Opaque<bindings::page>,
 }
 
 // SAFETY: Pages have no logic that relies on them staying on a given thread, so moving them across
@@ -161,19 +169,20 @@ impl Page {
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
@@ -348,10 +357,13 @@ pub unsafe fn copy_from_user_slice_raw(
     }
 }
 
-impl Drop for Page {
+// SAFETY: `Owned<Page>` objects returned by Page::alloc_page() follow the requirements of
+// the Ownable abstraction.
+unsafe impl Ownable for Page {
     #[inline]
-    fn drop(&mut self) {
+    unsafe fn release(this: NonNull<Self>) {
         // SAFETY: By the type invariants, we have ownership of the page and can free it.
-        unsafe { bindings::__free_pages(self.page.as_ptr(), 0) };
+        // Since Page is transparent, we can cast the raw pointer directly.
+        unsafe { bindings::__free_pages(this.cast().as_ptr(), 0) };
     }
 }

-- 
2.51.2



