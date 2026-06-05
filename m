Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5AA4CD6E7C
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 12:49:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 204AA6B008A; Fri,  5 Jun 2026 08:49:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1DCE06B008C; Fri,  5 Jun 2026 08:49:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0CAE46B0092; Fri,  5 Jun 2026 08:49:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EF1266B008A
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 08:49:41 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 959F240BF1
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 12:49:41 +0000 (UTC)
X-FDA: 84845840562.01.5B94CC3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id D7559C0004
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 12:49:39 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lCC93ulo;
	spf=pass (imf22.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780663779;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j747jOREbIkvFsg/aHzSYOHlVF+tB6wBTmNCEvHgfnA=;
	b=jIoz8lPvY9I50CUpuTVaHAcYuEqvloyHZiD9zoNLUSwu5lxh+Uv3q7L1OhkdsKy+iAgeyG
	mN8uOzECz6LNIiMylzlXXPOiOYRMf5CtvQ9reIR9WhkNQCwxRW2xS7ObHrUIassGdXeky3
	E2qv2SLBRX/VVLWGNuDgwr2SXBCtUtg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780663779;
	b=XNoO4gneikrSTyY8XdtaJTXXNW/BdlOSxqyiQM83CHOWHJrguKJ4BbNP4dbt17ptwVjL5L
	ntIbkgdqFPQpuAhGhP9f/On8mHO6GdVVLekvKvvoidNhoQDD18Ag2H3wZVihnMv7GfLrVV
	exjhpGSUZPLdFfX1w6s0m5tPlkyn0kQ=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lCC93ulo;
	spf=pass (imf22.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 74878601F5;
	Fri,  5 Jun 2026 12:49:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B10051F00899;
	Fri,  5 Jun 2026 12:49:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780663779;
	bh=j747jOREbIkvFsg/aHzSYOHlVF+tB6wBTmNCEvHgfnA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=lCC93uloqOF6Saw4qFLkFpI/H4rGKgYjI51PNWwxmotH8za1SoVm56NPQqTXeY7/2
	 ne0HYAGSfgKUAraTPThkkiJKcsyK3eo90LhQ1idfdBtxgA9hwA7Ji3DP4YuNjpiie4
	 D7ULucSlvem2NtX+aAdW1OjdvVQdykCaoRtvFVpEs04KRc1WGTN189VhaU6XwitOSU
	 mgUT+o8ojnPwq5ye5vLfi0/Xb2wSlyTf2rqQRGVHbUT+dutEWrRKtvILXIZEg7hNFd
	 AajWgDpq40hmDymOTPaj4r0qs36S6g059nwsqXKvxUxfmBlt0XrdccdVv4E9Hfml4W
	 +HVn+kYY9ONcA==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Fri, 05 Jun 2026 14:49:15 +0200
Subject: [PATCH v2 2/2] rust: page: add method to copy data between safe
 pages
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260605-page-additions-v2-2-03f04c8fdbbf@kernel.org>
References: <20260605-page-additions-v2-0-03f04c8fdbbf@kernel.org>
In-Reply-To: <20260605-page-additions-v2-0-03f04c8fdbbf@kernel.org>
To: Alice Ryhl <aliceryhl@google.com>, Miguel Ojeda <ojeda@kernel.org>, 
 Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Benno Lossin <lossin@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
 Danilo Krummrich <dakr@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Boqun Feng <boqun@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Boqun Feng <boqun@kernel.org>
Cc: linux-mm@kvack.org, rust-for-linux@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Andreas Hindborg <a.hindborg@kernel.org>
X-Mailer: b4 0.16-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=3310; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=dzp6cOSqfyflttG0MeQMpzGj5B+SlllJR/JvQBXauF8=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBqIsXPwpB4FTMvmdQ+DkEJMq1tlEwRJQ/YlCbJg
 EfQD8YbWNOJAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCaiLFzwAKCRD6UCkIqsW9
 0IwqD/9kbmi0nAXUhpyZgyZPFjcP242UtyBBoopaXPnPhF7rf8pCj6WUmqGhbm4Q1qUYj3KueeY
 82yfgiSPhEWM2JNNVDwfBAN4e98UQDMRKw6Kv7IgXnk0XLh93TYmUKl/gxJBvJuDmqfJ8it63r4
 jBmNdGkw608QaFXnUloqPKJ9TB7LLo55kQzeSqwexJ1eNRj38rt3Hnh6+ziOF08KuCHjxrJ2vGq
 zDd7l36PLd139G7vEbvWwfjDgu+mXs9CktjRuoC4xyjf/qirnfi64PFHsRLPDb8LaKvcQSpMZJm
 wp4IZCWZmllxSEj9QvAlbup+7aLjUQFhF3nr/UepEikqdXbHWddCNWrYvtUcytaZHh8nSw5oeVF
 z02cvlo67msFQ1ten/H5E/OxB7imEn41OEU5EWs7NsK78baW7sskoqlEhGwwEZOVE5ZB18Sjbdb
 aGDReVZgJsoOqzVwPBooFvJOm/QUpgGYUE+wuscrF28+y7jU57zWD/W9Up7pclit3ObfWbDMsT9
 hsDUaqK884CSWo46BzaeOZQoeptZ1DwSIjwINW0ts5LGFBlTt8U9FZAA1DYThGaSm2k6ctusbL8
 SHVS0JSxHWDUvQNqB/JGVAnQBsa8/TavOFKCWiYqQbUS2cFlRu97C0YUa97wVnFffojf08mCu7D
 ubZxxW+0Krag5bw==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D7559C0004
X-Stat-Signature: qzgi18pb495rwcjd4y4zab3iyp7p6mbh
X-HE-Tag: 1780663779-776258
X-HE-Meta: U2FsdGVkX1/O9aE6DAodxSn2EjUOJ/5i6k4ej+pNM3fcHmovWoUz1KH9FmjQ/pY+qmUEhc3jSC77HdxUiO/HzGxj1Kr8SU6rwExHwq+uqkefUV34Zwcd07uy0cSHRZ/NXaZeAAG2aOCRpsaroKQJGbLnsFkXsNes3MBcvmRzKy+1BNMK47NralMtGa5z9mvn9YRqLASNU5nkpWPGNEK79C+GvQYisbWHiATrfzaUybc3aMyrbWUpUUNnTt4kq5LO3o6MFMdo4ndP7gbg66VtQ5m/kcYpGhbccnsvjkEGO6byzmgf/gmEB0tGMA6DRV0/guZA5724oOqh0J7XBJaugYHK1psDoOHCNktinit4FtewjZF3TccFaE1N00f3PCggYL7C7Jqoln9FptJbNgcFBVrsS03LgkYmMPJyd61m+coZGru3tLW8W9gN2BMquDY8kTiF8cWcn8c91TYpaid9eumV6Z1MeT4fo1vSTMzPJgBrs5TK+RHvRRBghHfHF9DpKJJfPuNgEPLuVPlUbs/xt+OJEMOa3i7utYkt9tZSNS+hfR/BioigX/Z86cjomKxnxo8XawTIEEj3TmNOW7If6v+copG7lmMy0iHITKMv471BXC0ekvygLrBjaiKsRPPq5H2Fn4eDmuE/EsW+EkK3+f5X29yBmtbHKymPxu3qMt3mIwqYbez5MqSePZr5LVvpLqUdrUa23Cxg9WzS6ghK7y1/zGxPn/C3iIsQt+jFQ2+7pL94jhnYip0wgINPrQbQOj1Yq7iRjGMk/SgOadx8JTMSuW9CvTTIRCmjfwGhRm2Pc4gHu7/re5JKCGdJH0k/JSJy9aPJMiV8wYoC/RpUeNMsHlr2kPjo1Mkh3Ts+QsHbFuQHnSmP6nX/Dj9csBflLc77JCXQCX50nXpe+86nwLVh0uCAIM9PWimbGTMTvIquu+pXQpYR/XZ8jna05kubXX51upGxorKGLi6Pw/j
 aQDdYSJC
 R6ADLY8LZemeixR6AbXQNKNja3cS6iRVDm/h/aCArU6epXYzkaHAxhRFYv9Dwyex4MlI/30mG2eUbfigrWn/pYfv5n9LpHfg1hn0mH3GLMV3nEMHNBKvrJKLEQqtJfw4Ajj/mOW3OKNdqCNNw0mnL1rIUw4w5JTbd0B2NzntdE/HSCv08VX9b2FNPlRCznCPgWB+VgD5+qLH5Ed0cHMEm1PvLAt1K0WZSXAHsNAka1i/Zt7LIuN3KG/SC3w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add `SafePage::copy_to_page` to copy data from one page to another at a
given offset. Because `SafePage` cannot be mapped to user space or shared
with devices, there are no data races and the copy can be performed using
the existing `with_pointer_into_page` and `write_raw` methods.

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 rust/kernel/page.rs | 48 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 48 insertions(+)

diff --git a/rust/kernel/page.rs b/rust/kernel/page.rs
index f143b42d1bd6..2307e1f06360 100644
--- a/rust/kernel/page.rs
+++ b/rust/kernel/page.rs
@@ -23,6 +23,7 @@
     marker::PhantomData,
     mem::ManuallyDrop,
     ops::{Deref, DerefMut},
+    pin::Pin,
     ptr::{
         self,
         NonNull, //
@@ -427,6 +428,53 @@ pub fn alloc_page(flags: Flags) -> Result<Owned<Self>, AllocError> {
         // `Page` and `SafePage` are transparent, we can cast to the raw page pointer directly.
         Ok(unsafe { Owned::from_raw(page.cast()) })
     }
+
+    /// Copies `len` bytes from this page to `dst` at the specified byte offset.
+    ///
+    /// Copying starts within both pages at the same offset.
+    ///
+    /// # Examples
+    ///
+    /// ```
+    /// use kernel::error::code::EINVAL;
+    /// use kernel::page::{SafePage, PAGE_SIZE};
+    ///
+    /// let mut src_page = SafePage::alloc_page(GFP_KERNEL)?;
+    /// let mut dst_page = SafePage::alloc_page(GFP_KERNEL)?;
+    ///
+    /// let data = [0xdeu8, 0xad, 0xbe, 0xef];
+    /// // SAFETY: `data` is valid for reading `data.len()` bytes, and `src_page` is exclusively
+    /// // owned, so there is no concurrent access to its data.
+    /// unsafe { src_page.write_raw(data.as_ptr(), 0, data.len())? };
+    ///
+    /// assert!(src_page.copy_to_page(dst_page.as_pin_mut(), 0, data.len()).is_ok());
+    ///
+    /// let mut buf = [0u8; 4];
+    /// // SAFETY: `buf` is valid for writing `buf.len()` bytes, and `dst_page` is exclusively
+    /// // owned, so there is no concurrent access to its data.
+    /// unsafe { dst_page.read_raw(buf.as_mut_ptr(), 0, buf.len())? };
+    /// assert_eq!(buf, data);
+    ///
+    /// // A copy that would extend past the end of the page fails with `EINVAL`.
+    /// assert_eq!(
+    ///     src_page.copy_to_page(dst_page.as_pin_mut(), 0, PAGE_SIZE + 1),
+    ///     Err(EINVAL),
+    /// );
+    /// # Ok::<(), kernel::error::Error>(())
+    /// ```
+    pub fn copy_to_page(&self, dst: Pin<&mut Self>, offset: usize, len: usize) -> Result {
+        // INVARIANT: The following code makes sure to not cause data races.
+        self.with_pointer_into_page(offset, len, |src| {
+            // SAFETY:
+            // - If `with_pointer_into_page` calls into this closure, then it has performed a
+            //   bounds check and guarantees that `src` is valid for `len` bytes.
+            // - By type invariant and existence of shared reference, there are no writes to
+            //   `src` during this call.
+            // - By exclusive ownership of `dst`, there are no other writes to `dst` during this
+            //   call.
+            unsafe { dst.write_raw(src, offset, len) }
+        })
+    }
 }
 
 impl Ownable for SafePage {

-- 
2.51.2



