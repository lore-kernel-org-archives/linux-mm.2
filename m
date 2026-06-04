Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35122CD6E77
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 20:14:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9BF236B00AA; Thu,  4 Jun 2026 16:14:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 996F06B00AB; Thu,  4 Jun 2026 16:14:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8ACA46B00AC; Thu,  4 Jun 2026 16:14:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 78FA26B00AA
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 16:14:08 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 104DA120220
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 20:14:08 +0000 (UTC)
X-FDA: 84843331776.17.67301C1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 32CAB20006
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 20:14:06 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mosbAMrt;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780604046;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ggqzvyh9uUTse6J1YdoRnT592sarnIvZOvO6Wa4kRj8=;
	b=SAY7QiankrJtv2yvcutjeNINKI9nAWyURHkHW3wzvwkMc5U+pT+wXHq27tl1WJR6nEOfjr
	CpL6JWw9rX+eGuKxK1HydIimmu4bpYKpWsG6inx9JhXmxS97ml6aJGe2fGS+Ll9WWGitHN
	aDYePF+z+hRtrj7FA49RAhSZFzdcNg8=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mosbAMrt;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780604046;
	b=70lx7bsYDGBL4KHmr4rKezrQcJ0ZWKDGesRPYbmC8vxzi90cAtP+o4PpPaXQ3wDwMnMC+f
	XfxYJA6c7twAjhXmtlGVk7dMJLWK/Xu3w+XYGQGQyoI3oLe3uQpv0GT8UNOakD8YDsAYLG
	3Wbg080lnyxKyt98qtarSwLhufKrOz8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 85C7A43D82;
	Thu,  4 Jun 2026 20:14:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AF801F00898;
	Thu,  4 Jun 2026 20:13:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780604045;
	bh=ggqzvyh9uUTse6J1YdoRnT592sarnIvZOvO6Wa4kRj8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=mosbAMrt0jG/xwYtdddVY5gYoUg9wgN+ozIsSOGkb00aJo2V5TW1V46BLxB++Cg+H
	 0rNUlnojJwS954L3LqDM8Nt36WFjTCbu9FJ04Vi/r28HzCtgwAzhPVLn2k9abRFge2
	 IkQylc9PHxvlb9O3dgj0BiGX8E0hTYwHjcPkxhBqcOGjRZV37J8xOPwxExoD0tW3y/
	 b71NSSfft8LE7/lHE/rvbgZrHYHDvvzTU4jmRlTbYX1jHHauOny6TTpusfBCyVZYlf
	 dMlSEmvqx2/jhl4GiNKzN4kzIWAEWxHIhpyR49eMKRAhlAZLU0Ol9o5Le7U3D0R/EB
	 XWD6EH2BagOHQ==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Thu, 04 Jun 2026 22:11:17 +0200
Subject: [PATCH v17 05/10] rust: page: convert to `Ownable`
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260604-unique-ref-v17-5-7b4c3d2930b9@kernel.org>
References: <20260604-unique-ref-v17-0-7b4c3d2930b9@kernel.org>
In-Reply-To: <20260604-unique-ref-v17-0-7b4c3d2930b9@kernel.org>
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
 Daniel Almeida <daniel.almeida@collabora.com>, 
 Viresh Kumar <vireshk@kernel.org>, Nishanth Menon <nm@ti.com>, 
 Stephen Boyd <sboyd@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>, 
 =?utf-8?q?Krzysztof_Wilczy=C5=84ski?= <kwilczynski@kernel.org>, 
 Boqun Feng <boqun@kernel.org>, Uladzislau Rezki <urezki@gmail.com>, 
 Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, 
 Igor Korotin <igor.korotin@linux.dev>, 
 Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, Boqun Feng <boqun@kernel.org>, 
 Igor Korotin <igor.korotin@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>
Cc: linux-kernel@vger.kernel.org, rust-for-linux@vger.kernel.org, 
 linux-block@vger.kernel.org, linux-security-module@vger.kernel.org, 
 dri-devel@lists.freedesktop.org, linux-fsdevel@vger.kernel.org, 
 linux-mm@kvack.org, linux-pm@vger.kernel.org, linux-pci@vger.kernel.org, 
 Andreas Hindborg <a.hindborg@kernel.org>, driver-core@lists.linux.dev, 
 Asahi Lina <lina+kernel@asahilina.net>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=4419; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=Rg2v6tz0XwCXNwaYk5oY+uEcooXMgwXc01B3VEHvrOM=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBqIdvqHYkB8MyfIOoBDF1dSU61Fxib1oa4Dt9RG
 PgIQ0wtLluJAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCaiHb6gAKCRD6UCkIqsW9
 0IqcD/sFotgaGhMKDajo2vE0qEhGdVZ65uCHkiTMoKJrdcB+u/EW3F8VpV/IBvLFdHjNpsvogco
 E6hiRlSOOQyWBKf6qLQT3kNcckJUFca2rKOfxiHDoyO0g3ZhjKdB36WHeMksAohI3e5393Ar7A3
 JMomk1USO6WVyn0G69K23Cfa5gxuU0ODBR7cKy8U9dnlAnseoKo790PpO1ndbKqIm1XmJflmg9Z
 BamGGuMTLke1RIf510z6jyUIfdP8QxBXpXDELofQVg1il1vgaiS/tSkjhE5CLPJMkfVAEgul4hZ
 LyLB4oVXmjIOosFVwOx3BIagjIV19MAkiMIAY6wM0ovnXQCt55Qi6Py+KJy0cAsokL+xT//Xdjn
 p9iM3+z839r8nvxM97PFts/FKYW1cByF4oDNG+l4W250i9L/Nj9I1xyNMaA7e73/W4sG9ez0aNK
 snOob3lVbaC6MC/UYTey2mtt+QzOsF4BIfH2cvKEVRwH8aAKqChai103IF19OccUq7xLqyRQYf3
 gEGpIVah68briyXNnatyiyC9YSJJr2dVfLa6atP8DrONRO67JJ0tvEyiDWHoO3VvaZ/WV5fXj1c
 kYW2Iclhgcq7FVDvpyhKjFxoQ2h6IAQD0233nnJeT/ZRmTs6tk4ymr07hr22Hg8IOkv612sntSB
 qvL9y8ZQV0udSbA==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 32CAB20006
X-Stat-Signature: zmiy4dgsz5an3sck9nrjg4rnm6ucytfe
X-Rspam-User: 
X-HE-Tag: 1780604046-398613
X-HE-Meta: U2FsdGVkX1/XJwzReiQMZHnbYtJoNE3UzKfNgrvQOGT4vcfEGO0203btl8AqEKeTzN0vbZASA8gx+yuhN6/HUV6yi6ew+1f0kONhRnLQjKPaoZnRK6IymQdMuFYynSeZ+yK9nK2VkM7EeM0MaxzYubhE5y399J9vFeaomjAfSRGK+VDV2VEt7/a0NkLN5oAssOMVv7JrCXhOQsFX3rtuC/0PYoahRAMH2VeKvpfsFRGILtNkZVx3kOvn/Mkl0B6XI29T4YwjKP7FxMn8D2SoCBxUynjQmJHFNvrO+/JEfuVFHuIkIkm2D2NbRisCdDxm35tOjXYGcMntIVxme+pdFCLPfqhXpeXirq1X+VVcbksqw6B3XepDxDPIgYvdFq9C73H3K9EdE9jRefk/gKwK/gy51HauIwiBGgmfCyj/ggLPb2+SRQ6gNi/TiLY1K+k6A71rynQVViwTnYbvtVJ+e5zMI3N9CrsqrBEkiwzoHPaggaIpoxT0mSHP9m+kG7lrzf6cgY66S1qI2wG1BEFFg8fRocIQ4uyrlucHfEe55/JwI4FhNXW6qAfKhdgXhQHYPbirjONnK7EIQ3x5PCFoD5tg9ZX8yWsAfvcmKZ/PmOyL4nQ3KicC6utoilxMFWsPTvhgXU0G8AczK1pEmGFj2OUwOmVXI4bKMj9K3P6kDK0uKQDrwYNt/AO/1mq8NIuTBARbiQDuCcOklZ7dj9JNslTBzgeYH8qsaGBluWfuoPibvMHypYgSuCC496kQNsPY8kgJqbBZsxeFZj8+5xyQvaHmlcH2c7HGOOojTKW6vJ6QnCnbYh3WHtly3E05amVrxThsEvHboYJOu9KcjsUfRjQdukaTO/RC5X0B3EhMMVPbPbHEnoyx/TTZwRjL+Uu3lU5fqSCdIGr5u8uFR4iao745y1V7W9Oss7AdriybL2jSnH147rVUcLRMxlhB/+YnT8MHiyl3kRFlS47Jk/D
 tfEL8+Ol
 ynHUh8jZTLmPrdjssvmX+Cu7lfwR2Mjq2iuZM+6X0pUuDn1eBckJJUuTROnCvpgQDkz878SwPIMcceDl8nDkY7bQ1W3WFQFvQWSgPJigg6rcqIaC+q19qSDcU3Kmg4ZEiENCtvHSDAkh9QAIK8/0caT7wcNbgG4kqSJfVjEsW+hhyr93AsKYXz2pl74A5EXgP4yrMcP73WNhaeQxkrig6gorsqoSqSV9ee++1OJCl8zArrYt7m/WQX0AUYxPue29kn5sMLS1VFc6hwLt4uan+gAVNpLDavgu1Gg7bqt59CiWFhAFulxByMDjeFkRTHKgiG51GoYziasy3rRJSAq7UyEjH/Jz0M0x5RZzkQYINlv9wYNBVt0oYkvnM2uEOhsGgPktGWEi11TOrfyNHwFV5P4uKbTYRevK5U1wULEDOeNyF7O8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Asahi Lina <lina@asahilina.net>

This allows Page references to be returned as borrowed references,
without necessarily owning the struct page.

Signed-off-by: Asahi Lina <lina@asahilina.net>
[ Andreas: Fix formatting and add a safety comment. ]
Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 rust/kernel/page.rs | 38 +++++++++++++++++++++++++-------------
 1 file changed, 25 insertions(+), 13 deletions(-)

diff --git a/rust/kernel/page.rs b/rust/kernel/page.rs
index 3bdcee0e16a8..844c75e54134 100644
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
@@ -105,7 +110,7 @@ pub const fn page_align(addr: usize) -> Option<usize> {
 ///
 /// [`VBox`]: kernel::alloc::VBox
 /// [`Vmalloc`]: kernel::alloc::allocator::Vmalloc
-pub struct BorrowedPage<'a>(ManuallyDrop<Page>, PhantomData<&'a Page>);
+pub struct BorrowedPage<'a>(ManuallyDrop<NonNull<Page>>, PhantomData<&'a Page>);
 
 impl<'a> BorrowedPage<'a> {
     /// Constructs a [`BorrowedPage`] from a raw pointer to a `struct page`.
@@ -115,7 +120,9 @@ impl<'a> BorrowedPage<'a> {
     /// - `ptr` must point to a valid `bindings::page`.
     /// - `ptr` must remain valid for the entire lifetime `'a`.
     pub unsafe fn from_raw(ptr: NonNull<bindings::page>) -> Self {
-        let page = Page { page: ptr };
+        let page: NonNull<Page> =
+            // SAFETY: By function safety requirements `ptr` is non null.
+            unsafe { NonNull::new_unchecked(ptr.as_ptr().cast()) };
 
         // INVARIANT: The safety requirements guarantee that `ptr` is valid for the entire lifetime
         // `'a`.
@@ -127,7 +134,8 @@ impl<'a> Deref for BorrowedPage<'a> {
     type Target = Page;
 
     fn deref(&self) -> &Self::Target {
-        &self.0
+        // SAFETY: By type invariant `self.0` is convertible to a reference for `'a`.
+        unsafe { self.0.as_ref() }
     }
 }
 
@@ -148,8 +156,9 @@ pub trait AsPageIter {
 /// # Invariants
 ///
 /// The pointer is valid, and has ownership over the page.
+#[repr(transparent)]
 pub struct Page {
-    page: NonNull<bindings::page>,
+    page: Opaque<bindings::page>,
 }
 
 // SAFETY: Pages have no logic that relies on them staying on a given thread, so moving them across
@@ -183,19 +192,20 @@ impl Page {
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
@@ -370,10 +380,12 @@ pub unsafe fn copy_from_user_slice_raw(
     }
 }
 
-impl Drop for Page {
+impl Ownable for Page {
     #[inline]
-    fn drop(&mut self) {
-        // SAFETY: By the type invariants, we have ownership of the page and can free it.
-        unsafe { bindings::__free_pages(self.page.as_ptr(), 0) };
+    unsafe fn release(&mut self) {
+        let ptr: *mut Self = self;
+        // SAFETY: By the function safety requirements, we have ownership of the page and can free
+        // it. Since Page is transparent, we can cast the raw pointer directly.
+        unsafe { bindings::__free_pages(ptr.cast(), 0) };
     }
 }

-- 
2.51.2



