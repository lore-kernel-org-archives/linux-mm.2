Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA2B7E6BF09
	for <linux-mm@archiver.kernel.org>; Fri, 30 Jan 2026 12:34:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0374D6B0005; Fri, 30 Jan 2026 07:34:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00ECF6B0089; Fri, 30 Jan 2026 07:34:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E5DFA6B008A; Fri, 30 Jan 2026 07:34:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D59DA6B0005
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 07:34:06 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 83626C22E1
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 12:34:06 +0000 (UTC)
X-FDA: 84388572492.17.1F8F11E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 9C2CFA0015
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 12:34:04 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UPSciKCJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769776444;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=w4tja1SaSlm3Xe+7ZDDKXZZYzwf1Kox3PuUcV4o382c=;
	b=3hSjNWdaPATsv2xITNevzObZWr/B8Q1v/fT03ooEqt6TQUpg9kSaeWBL1LoILp5V7WUH/h
	g81WBKkxmstcTrpN3poeDXvP/u/8LSXNZjttjGDFDWx7p8FJ+0l2gD16Rn7gH39UZ/wGU8
	6iN0LWwitIxhtnpemN1D39C/gLRJV34=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769776444; a=rsa-sha256;
	cv=none;
	b=qB6vwLQ4pHgXGvKWk4/kzczE4+zP0YOqoWa8Tl80/ZWAcmxA9iJKXbAk7rFEEFxRg8Z2fM
	pQNS44exlyamn/Jruldb8v1rjbNcMS7O+NFHhTV98OJ16tsmFiM9IpIjrkzickU8N3yXBt
	X0NQACtTvK7MsdKAHiRXM5Y2qaONoP4=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UPSciKCJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6C27E404D7;
	Fri, 30 Jan 2026 12:34:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31197C116D0;
	Fri, 30 Jan 2026 12:34:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769776443;
	bh=iZzpNEAujmycUgTI/h9S+Zxb+pjdstnZT2VsHNdpb6w=;
	h=From:Date:Subject:To:Cc:From;
	b=UPSciKCJW3vx0x9g39qyILSkxW/plroKdQf3kg+IaLVG8W4qqoYLi/oKXVCYf0dl6
	 /ibOyaxK2uC4Wd0/QhqtnpWml6NLF2xwf2+wpJsNinzbIbyd7hp/xPMmRFyEvpVMJH
	 fgAhkWkWHxGTSVpL2/y03k/QBX389tE0XOINdl4AXG6myO0Lcnn7PeqF0K+nfIUeQx
	 P/BdJ/GoFWBWcNhYA2F6AxTlL555lBbcSzJEuEQKkPGkwbS3x75s2qZGxOZVX1C+sE
	 Z5QxQ9LbnUnNKIy2ZxlNwGWKWoiZdjBSqiFnr/+TZ85OxmmcAoBmgxgfy3Gg9cCa4w
	 /rlsO3X+QqmYw==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Fri, 30 Jan 2026 13:33:38 +0100
Subject: [PATCH] rust: page: add volatile memory copy methods
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260130-page-volatile-io-v1-1-19f3d3e8f265@kernel.org>
X-B4-Tracking: v=1; b=H4sIACGlfGkC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIzMDQ2MD3YJEoFhZfk5iSWYOUDJf18A0Lc3U0tTUwDzFWAmoraAoNS2zAmx
 kdGxtLQCfFwNbYgAAAA==
X-Change-ID: 20260130-page-volatile-io-05ff595507d3
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=5554; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=iZzpNEAujmycUgTI/h9S+Zxb+pjdstnZT2VsHNdpb6w=;
 b=owEBbQKS/ZANAwAKAeG4Gj55KGN3AcsmYgBpfKUtQhVPsKXzyLGXH3fkMmnJyCtj/n/+nP5+f
 MolQXKgF+OJAjMEAAEKAB0WIQQSwflHVr98KhXWwBLhuBo+eShjdwUCaXylLQAKCRDhuBo+eShj
 dznoD/9P26y0YDv1cPE86Bh1YGhktvCuaw1sp27fWh7YxQ0wX6O0WA5IlgEaGSx8xF2hOHJi2w+
 LJeLQnALyrOPIvSzNPzAfx2pPBNK6w0QQxXiU0ebgMtk+UPHFbQMS64irBjLi0bL3xQoesmOrP+
 2bB99pbdVY4gC0Dq12XeoM9HfDUIYAOurPpQfpIpsUKAPiIEDhesIr5AuZJsi/AdNxirHuDiqdT
 S4+OWdHaGeHte6w4qjZl2fujURG66lxR1MVsaOdhs5ov44CBROneErN/q0EMqXCdqnzXGBk6ieF
 66zeZxekJHEaTK+HFXPBOIOKu4Bpl8Xs+FAa5e6axWbZt6JodaOaOmYH05l550eQLsGFl3Ambz6
 eAI6AuhlcnmnYADQzAjks1mzQHCQZptXzxs3Y0cV0gfbbZ+1PtTI/xWTeXKkju9iKM3A7w5PdUE
 T9j9/jJjaZt0oeD73MKrU+eZCX1fcigGKLhc7zLs4YwuXQd29q4K7fKKgNzSDn6vvlI6LP5s2D2
 wi7AOHKisq/Un/Tt6DzSvzH6DnHXJjjYJ62AkuJ02PLXMQaUnSodNF60W6uDwkB2tMl+AJ2ElsS
 tAQXWMJrendvBe6gPjwEmuc+cDFYTxfUrBjjsTiHnvSklJdVA/U62bIgX++vjhdrzWe8qP5t39P
 KzawbSp67BdAooQ==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Queue-Id: 9C2CFA0015
X-Stat-Signature: wpfk7kt1tgxokdkujmnmsqjaam6d1oif
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1769776444-926506
X-HE-Meta: U2FsdGVkX1+ykb5OQAg9X5kEWP6kNQqVzj3Cx1LMkC8ITg0wXbnwmM427VpB3vmy2Ywp+p6FDdStgWGUyRke3CDi5Zgo252C2vHMdjbjvBhKO/TnM67GvPbOmGL+6HRNoMuZABGDcjfjBxIQ0CQ1uCWUwUcfQ9frawOsRwuqyNI2mck9y0Ckazl5Fp/XMNzJk4lv4Oj5E+EBAK8CezXk6gdW77OIDTTzcO3nBuzMvrGtuV+hWM7UBLYS1FD634f/qtFwkmCDQotU1U5ONuNOm4D6EWcrYr9Qv7cIGQoWPfhNdc1Bf8KZ1/CjZkcY0g4uvIYm4SfhQiUVF5I/Gcd2aWJXD2PG9f++K30fVj40ZoKN9vEYwSgzA8b0lYZwSxjHApFLaP1Yot+GbJXnWFTxzIf/q1JRBi4ol198De0qyTvO6zZsdQshC3ADCQxv8zYJlzVrpxOOsVDOWnBHRDltuAb7LN8m+1qyYmxitW2fynr7UIlSbh5wWM019Qp5CyUydsh7uTLur1MkBChSvgv/d/l/RHryrZFLih7273PH01HsQw/Jp5PEv3n+tZ9p/6m7TvcV5uvhBsokct5wpfjqKlm+3m/naby6C4sCKQQQ3PMdxF/QTaVFbFtHwdgMIYD9oC1B5NhXiZW5PUMEcXZMw0i3bpl7zzXOPlr+n6369JQPdGFaNYMHqaOtK+SOIMVqIMksXWgzKn56k42UQVzS/t4NZedJv8ANJH+4pI9SYq5zgq6pxh0UdU/ZD5kTIagC8PQOhj1K8HZahofVWnUnIJbQu6xB3qSOpwEcBt8DXN46o9gkiqFafvn0FM0BNpbcoDMPScZfngDaGHD/u8tJc5PsBReBojwDu8M+k1gd7TJebWg/bAstKfz/NwlsWSOvDiJbgLDAXk2whzEaiBdMwnn1jMNuio5kC3ExCFIv8gxdro5SQlV0qUxfpRlTRu+T8i/3eKFN6S0Znjz4aEa
 jg4/m5+f
 i/wJcK098Bm2cW2KAj33JDiwrGdQsaS/SAmUfUY66USVm6u2+HoXVob1Pyh7rBjnuJnzrO2sEjxTJ783xkCSlkbNFnl4/JrR0gVmZGUbaG9HRzFgEeQxuTDd6DytuJsdRDOJXC5hECLzOHRp7xFw6UanWjl8mbWPPE2rWy88+TVpqsHbcTgQF+bxprmVDFlM5IrpGg7L5Isq9UhGW/GCBVTcRXziPonRsNGJ7siWNScSbDQG+CPO1oqwLzL/ugA5Nr3/XGD+2e7GWGocTJqkkOyJ7uuTsUBgaIDQCi698G/mIXq5Wli26oPv3qBopt+P6yCkH1YNKlE/1iRCSZeX3SkHaHFsUGBROwfYO
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When copying data from buffers that are mapped to user space, or from
buffers that are used for dma, it is impossible to guarantee absence of
concurrent memory operations on those buffers. Copying data to/from `Page`
from/to these buffers would be undefined behavior if regular memcpy
operations are used.

The operation can be made well defined, if the buffers that potentially
observe racy operations can be said to exist outside of any Rust
allocation. For this to be true, the kernel must only interact with the
buffers using raw volatile reads and writes.

Add methods on `Page` to read and write the contents using volatile
operations.

Also improve clarity by specifying additional requirements on
`read_raw`/`write_raw` methods regarding concurrent operations on involved
buffers.

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 rust/kernel/page.rs | 53 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 53 insertions(+)

diff --git a/rust/kernel/page.rs b/rust/kernel/page.rs
index 432fc0297d4a8..6568a0d3b3baa 100644
--- a/rust/kernel/page.rs
+++ b/rust/kernel/page.rs
@@ -7,6 +7,7 @@
     bindings,
     error::code::*,
     error::Result,
+    ffi::c_void,
     uaccess::UserSliceReader,
 };
 use core::{
@@ -260,6 +261,8 @@ fn with_pointer_into_page<T>(
     /// # Safety
     ///
     /// * Callers must ensure that `dst` is valid for writing `len` bytes.
+    /// * Callers must ensure that there are no other concurrent reads or writes to/from the
+    ///   destination memory region.
     /// * Callers must ensure that this call does not race with a write to the same page that
     ///   overlaps with this read.
     pub unsafe fn read_raw(&self, dst: *mut u8, offset: usize, len: usize) -> Result {
@@ -274,6 +277,30 @@ pub unsafe fn read_raw(&self, dst: *mut u8, offset: usize, len: usize) -> Result
         })
     }
 
+    /// Maps the page and reads from it into the given IO memory region using volatile memory
+    /// operations.
+    ///
+    /// This method will perform bounds checks on the page offset. If `offset .. offset+len` goes
+    /// outside of the page, then this call returns [`EINVAL`].
+    ///
+    /// # Safety
+    /// Callers must ensure that:
+    ///
+    /// * The destination memory region is outside of any Rust memory allocation.
+    /// * The destination memory region is writable.
+    /// * This call does not race with a write to the same source page that overlaps with this read.
+    pub unsafe fn read_raw_toio(&self, dst: *mut u8, offset: usize, len: usize) -> Result {
+        self.with_pointer_into_page(offset, len, move |src| {
+            // SAFETY: If `with_pointer_into_page` calls into this closure, then
+            // it has performed a bounds check and guarantees that `src` is
+            // valid for `len` bytes.
+            //
+            // There caller guarantees that there is no data race at the source.
+            unsafe { bindings::memcpy_toio(dst.cast::<c_void>(), src.cast::<c_void>(), len) };
+            Ok(())
+        })
+    }
+
     /// Maps the page and writes into it from the given buffer.
     ///
     /// This method will perform bounds checks on the page offset. If `offset .. offset+len` goes
@@ -282,6 +309,7 @@ pub unsafe fn read_raw(&self, dst: *mut u8, offset: usize, len: usize) -> Result
     /// # Safety
     ///
     /// * Callers must ensure that `src` is valid for reading `len` bytes.
+    /// * Callers must ensure that there are no concurrent writes to the source memory region.
     /// * Callers must ensure that this call does not race with a read or write to the same page
     ///   that overlaps with this write.
     pub unsafe fn write_raw(&self, src: *const u8, offset: usize, len: usize) -> Result {
@@ -295,6 +323,31 @@ pub unsafe fn write_raw(&self, src: *const u8, offset: usize, len: usize) -> Res
         })
     }
 
+    /// Maps the page and writes into it from the given IO memory region using volatile memory
+    /// operations.
+    ///
+    /// This method will perform bounds checks on the page offset. If `offset .. offset+len` goes
+    /// outside of the page, then this call returns [`EINVAL`].
+    ///
+    /// # Safety
+    ///
+    /// Callers must ensure that:
+    ///
+    /// * The source memory region is outside of any Rust memory allocation.
+    /// * The source memory region is readable.
+    /// * This call does not race with a read or write to the same destination page that overlaps
+    ///   with this write.
+    pub unsafe fn write_raw_fromio(&self, src: *const u8, offset: usize, len: usize) -> Result {
+        self.with_pointer_into_page(offset, len, move |dst| {
+            // SAFETY: If `with_pointer_into_page` calls into this closure, then it has performed a
+            // bounds check and guarantees that `dst` is valid for `len` bytes.
+            //
+            // There caller guarantees that there is no data race at the destination.
+            unsafe { bindings::memcpy_fromio(dst.cast::<c_void>(), src.cast::<c_void>(), len) };
+            Ok(())
+        })
+    }
+
     /// Maps the page and zeroes the given slice.
     ///
     /// This method will perform bounds checks on the page offset. If `offset .. offset+len` goes

---
base-commit: 63804fed149a6750ffd28610c5c1c98cce6bd377
change-id: 20260130-page-volatile-io-05ff595507d3

Best regards,
-- 
Andreas Hindborg <a.hindborg@kernel.org>



