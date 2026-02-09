Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B110E81BCF
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 14:39:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D40496B00AB; Mon,  9 Feb 2026 09:39:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF71B6B00AD; Mon,  9 Feb 2026 09:39:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C0D826B00AE; Mon,  9 Feb 2026 09:39:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AEAD46B00AB
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 09:39:56 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 373C616018D
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 14:39:56 +0000 (UTC)
X-FDA: 84425177592.03.CC2DC04
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 919011A000C
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 14:39:54 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=W0LbIhu3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770647994; a=rsa-sha256;
	cv=none;
	b=wgK0h2jQ27363VlZ43XkqVlVZEFI660NL+MFXZxgLRvTFzbYnQ50BhEqQPZfy4aquh15Z6
	SZAEcpEZBEU38941OqJpiOyfQET96pBK0axeMa8yTWcyzfYQC/KW6Fjqhz+ZMGKin72xvW
	AZbNTe7CWfuWIZgDjNoegEFn6NEdNI4=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=W0LbIhu3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770647994;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MKg0Do/lzSCgl7PzmCRNDAWTy9AxFmrT2kRbJguGA2Y=;
	b=chg+e0nIbpxr9rX019vt9UlRPxHNcVgeRKYk/wHBVIcH2wfgvgWOWkxEcHZ0JSLITQ2idC
	pVVYKYQifnbcJGppSq3rLhdIimyP3TxMaxXEzce//HHGbR6b4MeJhMiasCnS+EYYZQGqcS
	IblqqIkkcaj4p4oGekUBcr9NKVgJalY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 14E4660131;
	Mon,  9 Feb 2026 14:39:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72255C19422;
	Mon,  9 Feb 2026 14:39:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770647993;
	bh=ziAsziTOC+GzNf139Ut4jKaT94DhutbUW+Q40shocZ0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=W0LbIhu3yXflRjlR51USLzE6TCZblrZPirDrUOTQtPBBtw8E+4tXEVs83O6SNUJ1b
	 yp6nZLa99Zuka8FviQlmEioGfKOP9SvbsquuhAHvTaT30J2/EpWzwX3vvFtiPwTBRT
	 0svmi+1DGm/1KkGXe2Nt8+K0GQemFVPx4VZVdsE4uTOTrFH0A1LHLT04fOmHqXUYMb
	 SdeLtezbZXJFSm/vhX4WVgZajI8YGyffgd3+mmlTfM0U8zDH2lk8bXrxjYvhJISkKM
	 Y/vETLiIsKg9eEjO78ENWxTiqprHdyGoexU7OIT0HH1yV9z2NIbtb5hEy9tK1LVxmX
	 whdxZYQjQJgjQ==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Mon, 09 Feb 2026 15:38:12 +0100
Subject: [PATCH v3 07/12] rust: xarray: add `find_next` and `find_next_mut`
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260209-xarray-entry-send-v3-7-f777c65b8ae2@kernel.org>
References: <20260209-xarray-entry-send-v3-0-f777c65b8ae2@kernel.org>
In-Reply-To: <20260209-xarray-entry-send-v3-0-f777c65b8ae2@kernel.org>
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
 b=owEBbQKS/ZANAwAKAeG4Gj55KGN3AcsmYgBpifFb+WmuAcVCQgvEERtgQ/qOeo8uSZnzezgaA
 +8xw4pzCZmJAjMEAAEKAB0WIQQSwflHVr98KhXWwBLhuBo+eShjdwUCaYnxWwAKCRDhuBo+eShj
 d4DhD/9wCbNkHivRJZdlO3SafsRrM1Jz/9FULnqXMomuVFOyx4R8DA04Vr1ryCJ05XWJyhekl4Z
 G5vVUO8k7DN6sWkUJEoaVgwaA+cAdqR6vETzYtNa8CNUYFrBH7F7IuNhOehoVVMRvTViVrfBiHn
 Omr9wEVK9MuXNHJWTwnGsLCVyGGgpqzlbwlL0r9HilBKQ2sJM4Ms/9G2LmyjDh8PExLTNxDxl/f
 n6TZWTg20i8MW5Ah6w0oDUrXSzduI0NuQTki4WxhKTtaRzvofUZuAztzg0lyT49muXqhhqMLBas
 JGmniyaN9E+oneAYw1iXPAZGQ6BSioVn5m6JPVB/FdUc3w7+4Yh6WG//E9j6bJHQn+Nwh0Csc/W
 OOVLjAamz/vGabbs7W8G+tWP3rJhq01jdtXaAONXcE/S2CT5B3exP5+ymlnemY9MqAVktGE2mvg
 5OTbekmZVE37vqI9e9/9CjVsFw6dyC0espFckCrEbgE0zh6CpPt5IEaSGPF4sBhm9WyLmQsZCpw
 GdbWMoq0K9av8QM75C7DvHme4QBQJWpvAlBhaRNX4F+G2MzpBZZTMGes/bcWRSW+igfHxyum7j5
 /uriDRU6pIaS6gsbLqj+fjWHKwrsxdFBlP9Ix+nyDnMigT+SRQZm2PlAuEwSok+Ws/jmFTFBW/m
 GYLsZBX4KKU+Zrg==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 919011A000C
X-Stat-Signature: tqx9f7prjzupjtsq3u468w3hpt8c5h63
X-HE-Tag: 1770647994-676667
X-HE-Meta: U2FsdGVkX1/ZCqqHFARmAfCSjdlKdpbE0palA7AdALvGTSiI+tTGCQ6/3tncACiWXpZ34/UmV8+ys91NAGvFFcwS+f6UyxRZw5VqhrL/csqsNOCdPUun478MptkZdDeCyMPK69ERGNtIgyTaKI+EtlG78n1rHc45rY6sOP40C5dW4wrryg3utMgzfcXQb2WHNBQ9I+msJXx0F0PQY749y7m7XrQ111WKE0NN2SnNfNP9k7lBv7TXoIW3/YTTqsMxCqUL9weh/RdJq2acpn6K+Y+4OsW9TFLNwSz09rnsB07MweeKICj4DJeKJBtU6mQ5iF9nsp2egrdRiw683zWO9rMc9bdQ9d0jGa6j8g+w6NoAcXQ4c5zCn0tcro2Vwxjw1nfuoXv+jOpWQzxqSJWOGrgHkJ/x90FEZXHb9PSqjQXmqr2r/9L1sH21GS/XUSqH4pkKnVfUF86UmvIE2zTgcdc71ZYkp2zfSKY+rUMZK0ZvPs/9UjK3Gy/OkBFz++W/9oWYKkGJ+X8u0Td+Xl2lKh1HsGndtBjVbxJc/dEqm7Zd3QLbzZbNnDn8sreRssRgzGKsZs4HomJXVsSOkN5G/Z0K6HFVI7TzssXF+AdMYoP/CwoSOePZqPym+sGooDB7Fd53ANmYefHchbvktPxnTQHiQlDDFwZYcQYyqBkebjoWIr60dVBXopFPkUqjsKAD+WrvE/sw68GV0lJ+N/xzXNqMmojjE+C7yGJqPHMqX2AsGM0gJ/yOv0WaLisGoF0sQ08NiCcrDAcVA5HhDQZrcT8qwlREYJAmbm3VBs9QI953GvGBzaQI2/9bzVtFZWYCiP3RTMjkK7kV2VfmW5dMDauBj7y/vXhBsHqPI05/eK5oF3ZS4G2//wXegAu8qDj9c7nT5cWMVNWFHowg5lObS/8hVDFqWoCYnbjV2tWfZwnGkkRY/+a98fTGGNoxAPj6qx74cOuA86fXaeisXu7
 ogK2JbNw
 kgjEdCjT81DSrRGW4luofJFn+990kYuYk4RPlUuH6BYlM2aU=
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



