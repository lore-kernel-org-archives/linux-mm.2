Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F6EDE9538C
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 11:58:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A6956B00A2; Wed,  4 Feb 2026 06:58:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 653D66B00A3; Wed,  4 Feb 2026 06:58:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 527E66B00A4; Wed,  4 Feb 2026 06:58:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 405266B00A2
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 06:58:08 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C677AC0110
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 11:58:07 +0000 (UTC)
X-FDA: 84406625814.24.CF2B7BB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 0E00218000D
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 11:58:05 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pWgJ7vqN;
	spf=pass (imf16.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770206286;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SRMcgVLDtJ5++x9gFTNXV83X6Ab7B0i1jEhhVHQk9JE=;
	b=ryAK61Wce4j5RtO92NwhX5JMlaeb9QD96fdCg3mt8yqUjuBD72i5pS25aFR7zbMbxTnTJH
	cg5hE8Z7modkkWPZvVdxlOLnOw4nanmNJyjCZHXGZBB9sonq0zUby+4KoJkOrV7csXgMeo
	+v2eIfe8GteUq9DuiQflTP+ShEFrSls=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pWgJ7vqN;
	spf=pass (imf16.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770206286; a=rsa-sha256;
	cv=none;
	b=codkLKCV84F6chm6UiDgxzEwtE2B8oXya55Hj+/1NNzOpxMYez8HcsLoMaCJmFoCecah64
	CgB+FuoQtVlMeCDDkIBuVVRQM5iC6QK7jFHRX/AUNwVx2BToJKg4AmjjGkC966H6OBWo0q
	3WKQDdHD3YQJDWdosp9TXR5GeGqsF3I=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8F2B160054;
	Wed,  4 Feb 2026 11:58:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED0BCC4CEF7;
	Wed,  4 Feb 2026 11:57:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770206285;
	bh=c2p54y/pAhnBEdMSbuIx3iZj3XWho61Cf1y9xR2YDhM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=pWgJ7vqNJD8qw9H62F41a+IyFWjd51pc+AHkRbmLJuxmCSc4sZOUMvjcri+R6nekk
	 XY/gZrjgCGaOI9A8tVQsKCS1RNjnQcAfRGuDLXvKA281qgwBo126KEMXpK6grvmVZw
	 Bw8ByJxEZ+PZ0f0GpeDewSgVQ91hK5150Ls76Bo8cm2S2PlC+5JNUcri0yc++EIQl+
	 kNfwrMU/0yG4VQt9vY2sOEdrXibri84JnGLDgDOfUqpuxFyBJKi7YdcAtralLSqLfV
	 yduxBbniHcTFDcClY5YKR1ODZuDOLaA6CQJH0Den9kJWI1c68FgJMXZph8PTEh0gHP
	 6U4R0xV8UPZKg==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Wed, 04 Feb 2026 12:56:51 +0100
Subject: [PATCH v14 7/9] rust: page: convert to `Ownable`
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260204-unique-ref-v14-7-17cb29ebacbb@kernel.org>
References: <20260204-unique-ref-v14-0-17cb29ebacbb@kernel.org>
In-Reply-To: <20260204-unique-ref-v14-0-17cb29ebacbb@kernel.org>
To: Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun.feng@gmail.com>, 
 Gary Guo <gary@garyguo.net>, 
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
 =?utf-8?q?Krzysztof_Wilczy=C5=84ski?= <kwilczynski@kernel.org>
Cc: linux-kernel@vger.kernel.org, rust-for-linux@vger.kernel.org, 
 linux-block@vger.kernel.org, linux-security-module@vger.kernel.org, 
 dri-devel@lists.freedesktop.org, linux-fsdevel@vger.kernel.org, 
 linux-mm@kvack.org, linux-pm@vger.kernel.org, linux-pci@vger.kernel.org, 
 Andreas Hindborg <a.hindborg@kernel.org>, 
 Asahi Lina <lina+kernel@asahilina.net>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=4220; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=FvgSRVnZWbKwiBgsZbTbds4VyUjBG0VqS2LEVRR8T4M=;
 b=owEBbQKS/ZANAwAKAeG4Gj55KGN3AcsmYgBpgzQF3kN9mHdfQUXkp64epI5aSl8D87Au9J4JZ
 BI3oEDLgDeJAjMEAAEKAB0WIQQSwflHVr98KhXWwBLhuBo+eShjdwUCaYM0BQAKCRDhuBo+eShj
 d2ywEAC8FyaOp71E081s63SKilLPbpt7rb1EA7gDcRJwDI58JBuU7jJKM6yOk3RjZKzUIPPMobB
 hd0UD25zrRDuhGWxP7k1YmEBBEMggWw6ns+CGJcab1yS3ckrPdrrtXq9c/iL02VE7VgV11Wrl+G
 SWUO2BuZbFK2apxYAbl21RMf3MAQ8j1My4Dmulq1xjb0oh6SekC8BPCR/PU0sGNaX3HBcOFVaKi
 WWq8YfG5J6M7mk0RTA9LCq0qp03TfGiDv6FhGp2vVqBRj2HzH6A8SJ17zMyVHAziyQi3ll7I5/7
 Imw2djBsHJxwwbDYkFG4kYNzWG83iTXw8C5XRO5AHQzDtrO9I9HcUUn1WGvzb1YngNXrwcKs7/h
 6vIPOGYTsj7sme89ANt8DLQhEpWPXGHntpUjhgfwCWN+Y+mJlM9Zl0mev2GUlpUcTIula7EA2DA
 lg6iFabhl48WFVLZT2PBo+wvckSqcirMcacSliac3mYkKGh/f2OibUcRho4idWDOjMmIItNdPbA
 EEx2NPX8c239fzWWo4sG2MS8YKjiH70VXEAEemFDKdPOKeyBvhQz0LaFzmMMVwKyC9AQNYWYSWU
 lbAwIYkUsVBFT/oXjGsQNrUWaX/mKjFJHa1gUS9Ts3frcSXpOa9pPb0ORpCZYOAf51nACen/nor
 YuBBF93SjC6LvMQ==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Stat-Signature: ye5w78j79btkr4acpjbpmc4ju8n8d5q5
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0E00218000D
X-HE-Tag: 1770206285-20387
X-HE-Meta: U2FsdGVkX1/6FEricj+UVVqCu7IeVaR7zAsCDpsn9gdUA+jzHdMrnto1aftNQ/9nSacNq6Eoq0z1mZ+azwi1xhhE0WkF+PuRjHEoBOPSb8gcWGHGyavXjK41rjnKD7XkTwiLIfyxhGJwES0gTu2zjce7aOGqRuXjlzS7bd/c0UtAG/rXNHBJpHDRzGGuOVAspj7Kn3CIph1ADplvBj6+YvrXmMrit3L7wQ5Kkl4oqYdSpwdm/yiyhT9JBjEKkOsPPn6Xj8mUXkVgDn1ee94fpV1azkdaFzuNi1ZT+VpIhUubdFGEyxKy0vXQMgcspJc0zZIpUIfbJ2i2wsNMKGGhL8TYTL0Wcer3r2mNymwPOv+uucnJ1jYLg4QI7S5CUFK8lGLdj6REzeoPAiO9Gjg/Pi5ZcWllQ4lABvUhVr7UbmWGc+8KRrLXauOCFwFl35iuH0bXdcI2PldyIxq2aJTEugUz4tmMn+Q33aTl3Xm8kWnaBYkG6MXXZv9Pd4h26crbOK54ifW8aXjOXEZphijEkcf8QahLB3ioFfW10XXdktBL7vn2sq5zkvXaZFqLesZZAjlwkvpLuAZhs7LCRkiYGZosbJ4UPi+iS8sZJIXhtew08/JkxVx5YvqKAwhoHHwOYqhnUw2rWj1K7A8GFWwi0GFDc5/QzH+mhqbXf89hUXp0yrDjwcHO5CRmDXM+Z+FiAY4uuK+ueIk3uGGYTt4m6HST5dawG2/GpLO278v40WszVisi1M1tnT2iYiR/Ox6QB/hO3eKxodC9QZKi/0Q70nLkS1hKfKOdOrA/u7NNB2mru3pTxVbhn6LRscy5kX2PTioAYJRQYOzdMRSGSTa9v7GM1xlg2QpnmgCWBjqHGnHqyMY+LbOsHTef/sZYtseT2+6CE8UO7JAOOyu33ri0cKS+FGgwEC5ChtbEcWkcd52pV2c/hdv6VU5vRDPS4YQ+yhcC568KlTr6Rk9xtHK
 2BaLiQAv
 lN6BrYCxklgoEr9bSPx0Ljfn8GEqYrNq6e3QqnZAImQGXg1uSVUva70QO6qXk4WyGid3F8Pp6EHa7w6PlVfVIi/xEHzXORYTpgjkaSv++Txmt0EWPpGYM/2gdJbYQ2l4dsDHaUkvrORaUFio13ySGWU29op9741yEjZXhWfSgsLpSyGj8q7xpG/qqHElg4PVJiEzTqE3hMiKGbRD7VeYpVBT+ROhbeOZoEes57g+f2ylQH7P5s1edY+welweCEqlV+FxUMFkROZXVTyACSyMn/6rk94B6zyof/LlMOtLnq2LQcOKRuvPBcld3kEu/tkxm4zY1Hj//LkzLpXuT1Z1280ybKxynOpQWAVEsFQtjRJ80H+8z0aOZRr9FFeyP5Fq7ho1i
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

Original patch by Asahi Lina <lina@asahilina.net> [1].

Link: https://lore.kernel.org/rust-for-linux/20250202-rust-page-v1-2-e3170d7fe55e@asahilina.net/ [1]
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



