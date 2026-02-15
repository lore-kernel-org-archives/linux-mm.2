Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F09F5E63F11
	for <linux-mm@archiver.kernel.org>; Sun, 15 Feb 2026 20:04:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 41E506B00A1; Sun, 15 Feb 2026 15:04:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C8FE6B00A2; Sun, 15 Feb 2026 15:04:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E2F76B00A3; Sun, 15 Feb 2026 15:04:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id ED3FC6B00A1
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 15:04:00 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 934F11A0B5B
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 20:04:00 +0000 (UTC)
X-FDA: 84447767040.06.86772A6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id B455F180008
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 20:03:58 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UJZxpCU8;
	spf=pass (imf16.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771185838;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g3d0l2+NqeuRbpsH4DQN1UZrMKFmpjByL1bC0IzaIDU=;
	b=Cs2DGf9CzW7BuCVfRuI+W2Oayh8IFzDnDJV5slBvgIhjC3VCUwCdr9DvaydRhjtPjEqCf/
	2Qq8SUniEFmJ7431HBWS0N+b9Qoknlv3rmZ7AQHYAuCRwFDPe6y7NxD97wRR6p2XErEUk8
	6EGnUT7QZfO5WH3E0wTVUXSJLMV/3Fw=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UJZxpCU8;
	spf=pass (imf16.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771185838; a=rsa-sha256;
	cv=none;
	b=oBd251AgOQK0vtEZAeiLC4y1W81CS+bcyWE8zb5Web45yEnqWCDgeXFLdHXUr0+pMHKMgd
	Z472dzEwyKTwYKMU3Gul5q8vNKzZjKk93iJeawbRH3iKE8fKzCxIXQuDMMjiKri9iAA86r
	vMKMsi07uhS5onFDmUjFt4ubDWYRXK0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E68314454B;
	Sun, 15 Feb 2026 20:03:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E00AC4CEF7;
	Sun, 15 Feb 2026 20:03:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771185837;
	bh=16ErT7tLYfWISzpJ8b5qwJAb4ilevh+0/RrBfgm5lwk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=UJZxpCU874plNifAdpneFJpY9yx3zf5ItZ17fPfIhmJP+AaRU5qKxMDo8RIYv/wbe
	 eY1kho6Vgic9sto7kbzCXRBBQ0N/h6rYLW0/SYC3sV6AP3qUoh19WQ7s6Y/PvF8U3p
	 nHaQT5LVOG+qZhuHGVR8Kx1p2ohO7YQFNBPer4MrEwbVwYCU1/fGVV8rbK9uT6hnjs
	 HhlLxaWJx3tD5LKYuNbeerw3a4QGHJLNI3o93kpI3H35XFVMNuZj4qlTb/a6fwhHHf
	 bu2ldrKVYM5ZzW5354EVqhjcPez+/7IS7i5MxJ0OGYsObw3flHp3NEG2bXGJc8eKfT
	 mKc3S3DUqItcg==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Sun, 15 Feb 2026 21:03:30 +0100
Subject: [PATCH 1/2] rust: page: add `SafePage` for race-free page access
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260215-page-additions-v1-1-4827790a9bc4@kernel.org>
References: <20260215-page-additions-v1-0-4827790a9bc4@kernel.org>
In-Reply-To: <20260215-page-additions-v1-0-4827790a9bc4@kernel.org>
To: Alice Ryhl <aliceryhl@google.com>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun.feng@gmail.com>, 
 Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Benno Lossin <lossin@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
 Danilo Krummrich <dakr@kernel.org>
Cc: linux-mm@kvack.org, rust-for-linux@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Andreas Hindborg <a.hindborg@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=4184; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=16ErT7tLYfWISzpJ8b5qwJAb4ilevh+0/RrBfgm5lwk=;
 b=owEBbQKS/ZANAwAKAeG4Gj55KGN3AcsmYgBpkiadRVY9lpm/5LZoWI728311H4v535vYULVUX
 UcUi+8W+tuJAjMEAAEKAB0WIQQSwflHVr98KhXWwBLhuBo+eShjdwUCaZImnQAKCRDhuBo+eShj
 d2mED/9sVfNPy46IZ/jMpmYFSjo/ki9ckRVDjR7guwCQ/QRD6BQUhSpqDYxDryxI4ia/9Q7d2Kr
 RYS+gJFgpX+3/zYH97BBk5Tji+MY85/R0CdYsUGj0wG4yfTDY5+fYb2JZvmeYTpv1H5mxT7OgmL
 LTJAa3GHWSquacf2EyRQi6H0q9jO4ZcrMo59zqhUzScZ//CXuRQUibcNgnDuUplzrQ4sCeXJdpU
 afzCWzbNq//sJjQrijzPa5obnqvB4xhQ/hQRcrHPnCVjJi3sutlw5OJEbH74qRd3Ws9Kyf+wVSq
 nru8NP7U9yE9wgcj6gTjqzcM53Y7sr8F1p8XClcZ9pZh88sr4XfA4GrcMWgMNvn+f26ja8gHW1Y
 nDVRXK31h3RtrnEvXJQAwb59BXVHLKD0MZj0AGeotKLudo9TgIDgNqfCn1XKcmYkro654ZP4kCI
 Fx/6LeVsF9oamkZ85dvv16bAZl4SbVKEz8Z38ltereGxCUDyDcomSDIE4C0Bo6InH+ZXSPgqJIx
 1+cvFKJdOJjQaeSflubAM+Gi4xdqmCMZGF9SxLE5ylFqfwYACzdT+eM4qmFeoFnSgrMg4+qzMe6
 HWrXHEc0cK27FiQchXUHXsnm4a/LLV25ee6iHkG50qBfufMApZSSxu6PyOPM8yze8l7w4NyRiQt
 RGy79GLA4Lawtfg==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B455F180008
X-Stat-Signature: 66egiratok4tx377rcouq6m8wmnfcqn8
X-Rspam-User: 
X-HE-Tag: 1771185838-411407
X-HE-Meta: U2FsdGVkX18RWaydbDYMgxOAHz5bRQDKu048BtR539NBwDVsjquaTlZ8DrHf+5jza6TQZfKrtJJ90PIMW9e8A8A5/HWV/xc86cmVDmk8LyF1f2TneIpKVKiYLEQws6VlbLDrsZpDbWFyoGFAz2pYcdb2o4H1ob+Wy354mWq9u0ivTA0OORnGRHSgooFc6JQnptLtze8oG9tG/LLg0J3lg+rE3TZKi2u35W9xXtKzIGs8Zfk2GuFigE2PQvFHFaCdYfpvYDGSeWBrtiQC0BtMws6cEC4FTI3P7OlwMD5/03kHkLAcWtNe+66eeYfmcEmOO6G8OVNqow9DUX69uD9lZ69jDLlOLOZJ2Ea/CEkcJsz3sJXB4s2fgBTL5nxROe66fcZPmvhKni44QR9Lpt5Dy5GaTei4bqjfvoQAITTvWAZCH2USYUBY6mPS7tYRcGI21rwiALzcly14JQwZIA+Y6BO/mtl5mFQttpbomwcZDvkb9Bk7HHLfaQwmYUAxKK2NWiV3gW+y3zBhVUi6dKQPaJvMilPCfmY5ztbLAX2yP/AlRMl4qTt7arHyf7PWSwL2+WrwgytWE9So3vC0Jp4i0LKPVNDGvdgmFtLqSkodtov4+Nn6HW3hNRdu2DErmmNatxGPlklgPpPFpSk2ShBlI+I/pNAsbLoqfq8Nc6us/zncX+pEl91yyfbZVXApZ4our5D1rKWMtUOolXzQYeuXGxah3j7amxf+pN+XIPDlBdMCnb0jTVB/tTGyk2t5vMJKXWND0mMfB0ZWL+ST7jvNUmfxUJf7eBAsxY0xtcQbMPYlDhcUNABGehNy1f/lEJjhPRGv9rTgqf8OmsegJiE8mDV/40BhlBb/1mgQkwxlMKXTE5wX/6jmjqd9yaaIl8HQwBFTc2cEgiUr2Rbu45IHMbMng0uFclEA9O5uPuHEHELG4Q29vT1GzY6rY6CdNnnz/1swEiFX0b8dMLFMmQc
 KBHIOtbO
 STbASNqF9v7tL1sf79FQA+S2CtNq25wGlYoFi05Z4ct84htgVIGvbiNTVU9dCgQVuGqyWTP564MsGHhlOqYbAGCY4By1p0K7S7F1aNj+G7w91mE3MrQzYTEnFpcCAY37ROxXelIdRZ8ErNWGVjZc7kJ46l0YO0wERP/+0T1u/y8gJ6IZ5RYeGUsmCLlrBHljG6ZkG4xG7afK5cKsKkMHdD57VDC3owYoXMUM/svtAzz+FZe2nBudhrIpYFw8JJIH3TbR+BzWrSYwk/n2mhZpekWKs2NFV9+1AokTEdsHSeJBNYPT0n7PmreJ7C8NNYZSDpBQN
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

`SafePage` wraps a regular page but adds an invariant that the page data
area does not incur data races. This means `SafePage` cannot be mapped to
user space or shared with devices, and it becomes simpler to directly
reference the contents of the page.

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 rust/kernel/page.rs | 69 +++++++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 62 insertions(+), 7 deletions(-)

diff --git a/rust/kernel/page.rs b/rust/kernel/page.rs
index 803f3e3d76b22..af6d2ad408ed7 100644
--- a/rust/kernel/page.rs
+++ b/rust/kernel/page.rs
@@ -8,8 +8,10 @@
         Flags, //
     },
     bindings,
-    error::code::*,
-    error::Result,
+    error::{
+        code::*,
+        Result, //
+    },
     types::{
         Opaque,
         Ownable,
@@ -20,7 +22,7 @@
 use core::{
     marker::PhantomData,
     mem::ManuallyDrop,
-    ops::Deref,
+    ops::{Deref, DerefMut},
     ptr::{
         self,
         NonNull, //
@@ -147,6 +149,13 @@ unsafe impl Send for Page {}
 unsafe impl Sync for Page {}
 
 impl Page {
+    fn alloc_page_raw(flags: Flags) -> Result<NonNull<bindings::page>, AllocError> {
+        // SAFETY: Depending on the value of `gfp_flags`, this call may sleep. Other than that, it
+        // is always safe to call this method.
+        let page = unsafe { bindings::alloc_pages(flags.as_raw(), 0) };
+        NonNull::new(page).ok_or(AllocError)
+    }
+
     /// Allocates a new page.
     ///
     /// # Examples
@@ -170,10 +179,7 @@ impl Page {
     /// ```
     #[inline]
     pub fn alloc_page(flags: Flags) -> Result<Owned<Self>, AllocError> {
-        // SAFETY: Depending on the value of `gfp_flags`, this call may sleep. Other than that, it
-        // is always safe to call this method.
-        let page = unsafe { bindings::alloc_pages(flags.as_raw(), 0) };
-        let page = NonNull::new(page).ok_or(AllocError)?;
+        let page = Self::alloc_page_raw(flags)?;
         // SAFETY: We just successfully allocated a page, so we now have ownership of the newly
         // allocated page. We transfer that ownership to the new `Owned<Page>` object.
         // Since `Page` is transparent, we can cast the pointer directly.
@@ -378,3 +384,52 @@ unsafe fn release(this: NonNull<Self>) {
         unsafe { bindings::__free_pages(this.cast().as_ptr(), 0) };
     }
 }
+
+/// A page whose data area does not incur data races.
+///
+/// [`SafePage`] has the same usage constraints as other Rust types. Thus, it cannot be mapped to
+/// user space or shared with devices. This makes it safe to reference the contents of the page
+/// while the page is mapped in kernel space.
+///
+/// # Invariants
+///
+/// There are no data races for the contents of this page.
+#[repr(transparent)]
+pub struct SafePage(Page);
+
+impl SafePage {
+    /// Allocate a new `SafePage`.
+    pub fn alloc_page(flags: Flags) -> Result<Owned<Self>, AllocError> {
+        let page = Page::alloc_page_raw(flags)?;
+
+        // SAFETY: We just successfully allocated a page, so we now have ownership of the newly
+        // allocated page. We transfer that ownership to the new `Owned<Page>` object.
+        // Since `Page` and `SafePage` is transparent, we can cast the pointer directly.
+        Ok(unsafe { Owned::from_raw(page.cast()) })
+    }
+}
+
+// SAFETY: `Owned<SafePage>` objects returned by SafePage::alloc_page() follow the requirements of
+// the Ownable abstraction.
+unsafe impl Ownable for SafePage {
+    #[inline]
+    unsafe fn release(this: NonNull<Self>) {
+        // SAFETY: By the type invariants, we have ownership of the page and can free it. Since
+        // `SafePage` and `Page` are transparent, we can cast the raw pointer directly.
+        unsafe { bindings::__free_pages(this.cast().as_ptr(), 0) };
+    }
+}
+
+impl Deref for SafePage {
+    type Target = Page;
+
+    fn deref(&self) -> &Self::Target {
+        &self.0
+    }
+}
+
+impl DerefMut for SafePage {
+    fn deref_mut(&mut self) -> &mut Self::Target {
+        &mut self.0
+    }
+}

-- 
2.51.2



