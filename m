Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98AC8EE6B5E
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 21:11:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E3D6E6B0093; Fri,  6 Feb 2026 16:11:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E1F276B0096; Fri,  6 Feb 2026 16:11:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D3E936B0098; Fri,  6 Feb 2026 16:11:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C30716B0093
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 16:11:43 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9B9C413A249
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 21:11:43 +0000 (UTC)
X-FDA: 84415278486.20.C675E59
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id B67A5140004
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 21:11:41 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LgnSA+7b;
	spf=pass (imf09.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770412301;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MKg0Do/lzSCgl7PzmCRNDAWTy9AxFmrT2kRbJguGA2Y=;
	b=UOBq0hhrCgXEwQ7BFt6ANFsFOesKF9EOu3PrgSvCR0F7hl4T4pW6waJSUh4R8tDy/LNWHU
	MzBvNzDJjfprHDq+31e3hCK5n6hP9PpAhZekKC5FG8R4k8FT9Y0/uutRbJrBFMyc72rPsi
	YcyNZMDE/4m7lq5vstrPAqQ43cKS25I=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LgnSA+7b;
	spf=pass (imf09.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770412301; a=rsa-sha256;
	cv=none;
	b=rLvc5KRYaP6DNwzHpUo5PwL45C/M0I4niM//s67B17Uwr9SFrLQ/4EMBjZ2/IM7DR7PhMG
	jFguKKoZwoleXawXIa2SfUU1QXpKCVkD/bEt1IRigi/vCNjqhAiHIIMZxsrOeT7xiEwcf4
	7flWE2vq3e0oWPBzvxwehobxkB0220o=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D2A1A4176B;
	Fri,  6 Feb 2026 21:11:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61DB3C16AAE;
	Fri,  6 Feb 2026 21:11:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770412300;
	bh=ziAsziTOC+GzNf139Ut4jKaT94DhutbUW+Q40shocZ0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=LgnSA+7bY0qxDvdMzITJ+FXZElGwsDv68y49w/cMLIlIBvXk+1Tzi5v7YD1gwAjZj
	 I+winp0JvJ2kd6OyT58TLMLbPUrvwC4wYIzvaXFb3IpiwzThADBBzwIKAWGYpRHmdI
	 3vQanmMlFSsfzLrGSxQnjvsI2n8ic8y1y6CGE03/gGNs5tN8Z1sn4E50azERG+OM5F
	 eVr+3JX4ZL0qo7ngGbxA1WPy1rVJYOVqrW6/donr6nWD4Zw6+GBPdg9iEnyPYUo38v
	 1lX+h/R5cW5ZzZRp1N5+md3aCSrIAH4/pKBthbX9JDw8VzudKOQxA/nwxAV8+Djqd6
	 PQZKmchAO5C+w==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Fri, 06 Feb 2026 22:10:53 +0100
Subject: [PATCH v2 07/11] rust: xarray: add `find_next` and `find_next_mut`
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260206-xarray-entry-send-v2-7-91c41673fd30@kernel.org>
References: <20260206-xarray-entry-send-v2-0-91c41673fd30@kernel.org>
In-Reply-To: <20260206-xarray-entry-send-v2-0-91c41673fd30@kernel.org>
To: Tamir Duberstein <tamird@gmail.com>, Miguel Ojeda <ojeda@kernel.org>, 
 Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
 Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Benno Lossin <lossin@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
 Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>
Cc: Daniel Gomez <da.gomez@kernel.org>, rust-for-linux@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 Andreas Hindborg <a.hindborg@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=4023; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=ziAsziTOC+GzNf139Ut4jKaT94DhutbUW+Q40shocZ0=;
 b=owEBbQKS/ZANAwAKAeG4Gj55KGN3AcsmYgBphljnlh0PwhOjbdwrAoJpOnH1unnfNaF62jnVf
 OpMfNpflSuJAjMEAAEKAB0WIQQSwflHVr98KhXWwBLhuBo+eShjdwUCaYZY5wAKCRDhuBo+eShj
 d8lxD/96tdOwjEygElTB5W6BwdRyLgvYB/hCTUV/zpbiLgUPQl0pzk+j00jlWUivFwhQBOnlwrE
 YEgUGsY/y5uzXaAiw5NXnitAZoS6ZGWv2tpbAHvUCwwc/flX1p5Uu6leUtXPY6T8t+ok4lz9DR1
 fGSwg7Gb4f1ffmZkq62vlMR9FqECeE+RmhnAT3e9r2m86CSHMgXP5/qHqmzJlmSLxx+3YXqBR6U
 Yrh1rib85R+ov46tLBhvLSAKzrL6BSdNV8tklv3VD6n6gsCV7q7/JX3FgKFSw24OOX2x6sbc8oo
 zGsiXe2tpDo6CRpW9wavJsKgtq/VDBtvN7UohRxYDjmJXzRuYW88v4vMnUfPhOz5zgpYbbOEuZC
 M+vfJ29OIKm2qyjV2440+qdZP3PQFKHf4qOfOowsUnl/l6cBO2mj3GvbRXQ9I/1YcSj/Lt8mBIf
 hx9fybxfvq/KPIruXbehNTsdyXANogQmXTM5FNNbNLzYWLRarWRxU5cLHl38aMYDJLZwSfYQYlT
 fP5dvm4HKTSK0uw6wgVIg0dKjwug2PyccQwuqOtW71GIX20wNp89kFn3Dvh16L15xMTuxvxwjMd
 AltU2qTF9HFwtjnkMPV7R0bERe3P/+XCRDU64hmmiITp7fSgoqnSVu+poZABp+Ue1z5gi/tT4sH
 gUswhjAe8geVmNg==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspam-User: 
X-Rspamd-Queue-Id: B67A5140004
X-Rspamd-Server: rspam07
X-Stat-Signature: rm5g3yk5a1k4wsx448pbfz7ghkww4jbo
X-HE-Tag: 1770412301-576878
X-HE-Meta: U2FsdGVkX19jdnuA41d6V23Ngivz3AbFNtbDQqsxHtBBCAgmcz5MYYTqsQ2QrKUndUxcYk+NsDuahWX31tGbvbCUOBnIgvsp6wqIG944H/BeVtVYk+NxXVu2Lsm/F7nd69+zCltjFbVTJW5XJtI/jIwFt94/4RuHpS6LadkR9eeuEgB8ij3W4+yYQFf80eAmtI2l18EKqVdSRl+tzFi4HPKmzu/GXMM3ECy4LGctbbt0eLvOcNPGtEI2ndRdSkw5WQmNjGi3Ri9KRY4Zvm8u7rG0c8sGUPcDuc/gFY9oN7lxZ8OzafGBOWP+hkAFKI9yfC6e4Cs6SZcg1Hj+Kw9SeS3+KblbGRIuVYGRWD8ObVvYNNqRGuFlLptxS3CS9gF11a6YAv7C9ClhqECURg4Zp3PGkjH7c5aRUgIbvVMDhSy8UJ4xLuQVo27cmu7KxOzkb0PD5Wo+UAfLqNoHMyVFqiC11J1mwrnaXuE4+hpepY/W8rLe6kJSn2z1NWHCG8sOELI9IHC+a5myZ8W6D1/XzAuIxi0tfq+DtyQihuXq1xSVPqGKPD15AzBk1z7MJBqZx/kwl0pnn5jcJ+dZA+WPtJay/LkvKasnnb2SanHH7tYMaHCYZ0wtNl/rXdvyFiTEIH4jw48IcPc82N9/9LZ7GitKhg9wzgenj9wwz1eLHrroBmM/2XAI5ioV+UbioycDjkEYGGgv8SnGETNfulFehXynA7J0bILMHXDChgWZGYccRltf3Vt1RKFMG00Ar8waxZlNHTbufWSEF7nfrCa/1go4lVJzE5Hs0OFApioVJadybujPY9f9x/sZM84/Y6EByRnRLAX5+ScxPhWEhKISx54OSKpN1An3y2+5HP6n6yUpXVzQj4V/30qoiVXT0MryNEiHrU7om2FuJs070IL0uqQ8z5hJxr7OOwyTO4kLu95uWZ2Nw61mroCzjL69HMxd5/XK+hOV8VE/QsNiAA+
 V5DWZIsq
 yeZP5pTBqpPMR3WOLUMKG9YVXUkC32X+HEPWY/vUgU4oFE/MfrakJBHW6BbGnt8tjLA+Ab6JWJRDjEJ9ovE/LTxv9Y3sG4jXD3QkaZJbNxuCF/KKDkLIOKCngLRS2OQkHMhiyzsBPF8zPuKbB7Jsw6Ps3p31Z4Cb/yW9Txa43Gc7klbV+hJrgNlq4q45TG4Duqbwgpx8mMyoWNn9pFi7uYGKQ1vTc+lEzRaiKGP9d10D2ENdSOkTyOFjZtxyc/oMJdmdJParC93cOmmWV76tC+OIpYogtpQLQ1lyZ8O/T7oKGU9FJ9eSQmcxMeXzLuop6VHkfXZpU650MmW0tQXmp2Ls+6ysefWyUTnhHu7cZYxviwi4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add methods to find the next element in an XArray starting from a
given index. The methods return a tuple containing the index where the
element was found and a reference to the element.

The implementation uses the XArray state API via `xas_find` to avoid taking
the rcu lock as an exclusive lock is already held by `Guard`.

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 rust/kernel/xarray.rs | 68 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 68 insertions(+)

diff --git a/rust/kernel/xarray.rs b/rust/kernel/xarray.rs
index e654bf56dc97c..656ec897a0c41 100644
--- a/rust/kernel/xarray.rs
+++ b/rust/kernel/xarray.rs
@@ -251,6 +251,67 @@ pub fn get_mut(&mut self, index: usize) -> Option<T::BorrowedMut<'_>> {
         Some(unsafe { T::borrow_mut(ptr.as_ptr()) })
     }
 
+    fn load_next(&self, index: usize) -> Option<(usize, NonNull<c_void>)> {
+        XArrayState::new(self, index).load_next()
+    }
+
+    /// Finds the next element starting from the given index.
+    ///
+    /// # Examples
+    ///
+    /// ```
+    /// # use kernel::{prelude::*, xarray::{AllocKind, XArray}};
+    /// let mut xa = KBox::pin_init(XArray::<KBox<u32>>::new(AllocKind::Alloc), GFP_KERNEL)?;
+    /// let mut guard = xa.lock();
+    ///
+    /// guard.store(10, KBox::new(10u32, GFP_KERNEL)?, GFP_KERNEL)?;
+    /// guard.store(20, KBox::new(20u32, GFP_KERNEL)?, GFP_KERNEL)?;
+    ///
+    /// if let Some((found_index, value)) = guard.find_next(11) {
+    ///     assert_eq!(found_index, 20);
+    ///     assert_eq!(*value, 20);
+    /// }
+    ///
+    /// if let Some((found_index, value)) = guard.find_next(5) {
+    ///     assert_eq!(found_index, 10);
+    ///     assert_eq!(*value, 10);
+    /// }
+    ///
+    /// # Ok::<(), kernel::error::Error>(())
+    /// ```
+    pub fn find_next(&self, index: usize) -> Option<(usize, T::Borrowed<'_>)> {
+        self.load_next(index)
+            // SAFETY: `ptr` came from `T::into_foreign`.
+            .map(|(index, ptr)| (index, unsafe { T::borrow(ptr.as_ptr()) }))
+    }
+
+    /// Finds the next element starting from the given index, returning a mutable reference.
+    ///
+    /// # Examples
+    ///
+    /// ```
+    /// # use kernel::{prelude::*, xarray::{AllocKind, XArray}};
+    /// let mut xa = KBox::pin_init(XArray::<KBox<u32>>::new(AllocKind::Alloc), GFP_KERNEL)?;
+    /// let mut guard = xa.lock();
+    ///
+    /// guard.store(10, KBox::new(10u32, GFP_KERNEL)?, GFP_KERNEL)?;
+    /// guard.store(20, KBox::new(20u32, GFP_KERNEL)?, GFP_KERNEL)?;
+    ///
+    /// if let Some((found_index, mut_value)) = guard.find_next_mut(5) {
+    ///     assert_eq!(found_index, 10);
+    ///     *mut_value = 0x99;
+    /// }
+    ///
+    /// assert_eq!(guard.get(10).copied(), Some(0x99));
+    ///
+    /// # Ok::<(), kernel::error::Error>(())
+    /// ```
+    pub fn find_next_mut(&mut self, index: usize) -> Option<(usize, T::BorrowedMut<'_>)> {
+        self.load_next(index)
+            // SAFETY: `ptr` came from `T::into_foreign`.
+            .map(move |(index, ptr)| (index, unsafe { T::borrow_mut(ptr.as_ptr()) }))
+    }
+
     /// Removes and returns the element at the given index.
     pub fn remove(&mut self, index: usize) -> Option<T> {
         // SAFETY:
@@ -354,6 +415,13 @@ fn load(&mut self) -> Option<NonNull<c_void>> {
         let ptr = unsafe { bindings::xas_load(&raw mut self.state) };
         NonNull::new(ptr.cast())
     }
+
+    fn load_next(&mut self) -> Option<(usize, NonNull<c_void>)> {
+        // SAFETY: `self.state` is always valid by the type invariant of
+        // `XArrayState` and the we hold the xarray lock.
+        let ptr = unsafe { bindings::xas_find(&raw mut self.state, usize::MAX) };
+        NonNull::new(ptr).map(|ptr| (self.state.xa_index, ptr))
+    }
 }
 
 // SAFETY: `XArray<T>` has no shared mutable state so it is `Send` iff `T` is `Send`.

-- 
2.51.2



