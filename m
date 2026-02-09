Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34DA3E81BCF
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 14:38:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A0946B008C; Mon,  9 Feb 2026 09:38:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 981C96B0092; Mon,  9 Feb 2026 09:38:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 85A126B0093; Mon,  9 Feb 2026 09:38:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 704796B008C
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 09:38:44 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1F2B687FBA
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 14:38:44 +0000 (UTC)
X-FDA: 84425174568.19.F952E44
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 17F2410000F
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 14:38:41 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tllYsx4L;
	spf=pass (imf14.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770647922;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jqKk9fme50qILT6TL36UAcLubp+BM9oPsU/UvwUa7vI=;
	b=Cnrb34GTzXOtlknrh7qR/yWIGkTTT3Fyb2TYZLFVKphWJ99NxDSRCI3GssZjPjmK2T3DQY
	J/W50XyJ8fNHS7JiGr5HxNuEKryoTH4CdwEoQ4+i04Zq/a+dIZ6iDNb8lrPLEWmXdTHUZE
	8qUjRe7TuhlqgMx3vNzb8vB6cSKFXfg=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tllYsx4L;
	spf=pass (imf14.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770647922; a=rsa-sha256;
	cv=none;
	b=X3ycePAMMUzO9dTfEv9qiIV2CU6bvZMlQNprFysOE1lV6Czz5UShjqlCShWmJ97VzzvxJv
	fcSF9PZ71rxLHrChJglGl0axRuRcob2xkhCD7Ema1e1sFHfLsCrbMTrBHUuiR1VBf0ip5z
	W7TA7YopD2ZfeuaLrDJJegpCeoFQLMA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CFEFA42A42;
	Mon,  9 Feb 2026 14:38:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B77DC116C6;
	Mon,  9 Feb 2026 14:38:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770647920;
	bh=tGpkTbkQCs2yz/lXZr74M2PLP6TLYGnHySlF4MFb55o=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=tllYsx4L+h2OpJAeRmCRGiw+Rqo9DtkPIvy4dh4tbf/TitOu0/y3XyRxyrNOKy7/S
	 1skumPTPR37FhhnRawV/FKbE/GydHvbq1ZcKD79S4sV8kCbUobRQVyLaZw7u8hpmH/
	 3GTK5YPpq+7vc24Cea0df/feEBLEH3WrxL9TRPLhPaZp81ZaeOgvF6WL/2VU/TO2to
	 9LAQnBPM8rmKVEYlCvDAjyFW1Dwv5HfVPaFC6/j7uaGKSNgr+2LuSJDdS/PR5scyRb
	 6IWAaS9+BniIZbyoNbBN0NqmIZA8odCYz5lxFtzZakAxXhzRTCIGtaXqWlihoPZUuZ
	 jBoOryj45quWg==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Mon, 09 Feb 2026 15:38:13 +0100
Subject: [PATCH v3 08/12] rust: xarray: add entry API
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260209-xarray-entry-send-v3-8-f777c65b8ae2@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=21192;
 i=a.hindborg@kernel.org; h=from:subject:message-id;
 bh=tGpkTbkQCs2yz/lXZr74M2PLP6TLYGnHySlF4MFb55o=;
 b=owEBbQKS/ZANAwAKAeG4Gj55KGN3AcsmYgBpifFcuCZPpcqewn9lY4/88YakUk04i8FdTR0aX
 STwEMm7OyiJAjMEAAEKAB0WIQQSwflHVr98KhXWwBLhuBo+eShjdwUCaYnxXAAKCRDhuBo+eShj
 dzw6D/90Pktt9jbEw/+eRAhBBEh56lj3lam6VH3pakIyIZCpZczI5NXyGbLGg2fd1y60d3to8Z7
 8fgC3DgpnYilVxYF/FU41/xiv/SJMcmEN29DSFlXz6pP0JHER0BzHfYuJWSu2oO8oHfsa9QYWZq
 eR8ZIqjnYbcjbqt8EmU9fqAvXFYYR4C+246xa32dWt3IJb8iS39GSe60bHIv1CVeZJ3vF8O/gxe
 vbuIFYU7+g8UUH8tKJ5oFPv9iHRbB8GOA60/9q99mW6EBjILxQOJswC3pRtN4PEPQW+0C6Od4Rm
 Hbaz1kOeyh+plrR6hoF9LgN0XFbJePd+cOIbbH0p9Wdx761QlLq+v2/Swq8QMlXkbbcTQy3sNbL
 ddmPePo5VCasM5w37IhOSXN4Zv+WGcoupVmBhUENSG6ZftxM5NVgEzdo26IcnR42EJ6KZw21R0p
 iUQ5KN1YtBPafFIsNT/ayUPX/gi9yCnsSjV6XMSqmZvhD+N29lCAXiVmthvdIFw4Ma6o/pzDwk6
 tyWWJWJ6bBK6NRDYuI3OykGWYAlLg20+1phUpY+Ir23PbdLDytNGTz+hKNauC5ROCOJtLNgtRdJ
 KpWZBvlZSC+5D1eQ5OW8jiMrcLZLMDRcbmijl/Cn8Jj/YXP1JYg4ETGK7T+DnzAcV7Xc0lgfYGb
 oaXxQVjJ+L54qJw==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Stat-Signature: skbejbcp893jub6ugt1k84kxzoo7fysu
X-Rspamd-Queue-Id: 17F2410000F
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1770647921-117089
X-HE-Meta: U2FsdGVkX1/u9m6EgoAxyb3ixGjGE/JSUqMtcRG2APiLDLGhlA8M1gMg8vFqZkivqtmM7u544imYtiBbo55JrdpCmSxFrFEi7aAmToXAtaZRAK1EnY+UbwzGfSViLnTpkJTwDZLIE3AKxHSYMgFMJS9TqcQoAcxo2H6hL1f8xH2vII10uZqYKIEaZ36e2sVE5kJVWoJTfOsqgkdoJObFhk/08eZXjIuETXV+zdB1pLrEVJujIg8Cf/JS2oGwkm6j7YdPtxCDEYsRysu/D2jx36XhijUvC+aJR5udiANJpUVEfI/SPivzRY5y+h7hZ8fkKhFH02zSZeaLVcrn7wVEc6KmhgWrCeha/dlayfLgLnQ8PxX0chvhsleLfye78WL+XABY+ZSA8NuH2c64HeeaS9U3gBMI2weBxDmewsEiH1WAQLCobYy26URkYG53UDx5x/C/XvAhh/QCdm0ULfp56307DRaeMk/iQ/81q8n3IbjoyUkBvKKT9R5kfCbwuQUd3lP0EGKqbA4/fJ0v0aA+Jp9OyP1Szb1WlpdSLsH7TUnZVKdSgYNzDaKszjePwnvmfjidlx8L1Cl9AzhQPG2zyHwxMwS7JMReFKHVzVZ79SdZ21AmpJ2gT7PWG8c/4MKumFE5ZHDJVteEhHrvzbdA7e+OXHvZ5HihOVNqFJBxTdlrNIBeSMIHOWpQ7y+6svFjI2NiB2sgTGQGZdWxFSMY1/U/vwCsC9ume9A5NexmZADPHvbeQV/IE4wrvNoUHWY2PrW2kg+y3GUZHFcyibY3gONV7EsJlbjEKvLM1WMaxqO8og7PQ1yofnzdoo844c0EbnM01Rg1tsn71aB3hRJN/gA2m7MSDhHH8V7tcUDOfeFBPWvirg+1/foWaHDn3hh83L2eC4Kv9UfRXImvhDq+OOE+L5AQ29SCeWy2tApPbP8tYLde12QJ4SRhtIJgvNsAGatC80XbjRnZ2Bhk/Bg
 UkmBt5s3
 M6C8a7E19lCb1ynjutvwLAq9e5COfIVpl/FjD5CCV7TFLoLvaYSQg4yWVPcI1dtWbT62/7aCaJHpz2DnA9YdsO775+xvj6pDV60s/ghAsQkxlwJsBEXTSrPuwFbzXheNTBFT+lcThGScCU5qODR05uiv0mQcHVXsLaXsH1g1EY40nkCCgyMThjY/3rBUVcq+qPn5wJ+TCqdFka+S3koMSPGy3ncmT3HEuxHeBoazpSW8oj6QsKtn/RWi6q4pdaCvPdyHalStcv7kMqF4395ynj84W3D0QUfOhuK6ZO+AFg3jiTbPtt1wqpx76DZ1YzvAAgCgdPfAayDdD/rTB9Vg+tA63VuiOCkKEvVxuBm174O8VYpQwPgx8gv/+Bu80+2wJ6rC/1Brjh+OE7WdLw45UrnaRkpylPdEURForsHkZCA9jD5pMSlIMUoy9LdmFb1SKKWI8mnqSWcVQIiQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add an Entry API for XArray that provides ergonomic access to array
slots that may be vacant or occupied. The API follows the pattern of
Rust's standard library HashMap entry API, allowing efficient
conditional insertion and modification of entries.

The implementation uses the XArray state API (`xas_*` functions) for
efficient operations without requiring multiple lookups. Helper
functions are added to rust/helpers/xarray.c to wrap C macros that are
not directly accessible from Rust.

Also update MAINTAINERS to cover the new rust files.

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 MAINTAINERS                 |   1 +
 rust/helpers/xarray.c       |  17 ++
 rust/kernel/xarray.rs       | 123 +++++++++++++++
 rust/kernel/xarray/entry.rs | 367 ++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 508 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 0efa8cc6775b7..8202515c6065b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -28361,6 +28361,7 @@ B:	https://github.com/Rust-for-Linux/linux/issues
 C:	https://rust-for-linux.zulipchat.com
 T:	git https://github.com/Rust-for-Linux/linux.git xarray-next
 F:	rust/kernel/xarray.rs
+F:	rust/kernel/xarray/
 
 XBOX DVD IR REMOTE
 M:	Benjamin Valentin <benpicco@googlemail.com>
diff --git a/rust/helpers/xarray.c b/rust/helpers/xarray.c
index 60b299f11451d..425a6cc494734 100644
--- a/rust/helpers/xarray.c
+++ b/rust/helpers/xarray.c
@@ -26,3 +26,20 @@ void rust_helper_xa_unlock(struct xarray *xa)
 {
 	return xa_unlock(xa);
 }
+
+void *rust_helper_xas_result(struct xa_state *xas, void *curr)
+{
+	if (xa_err(xas->xa_node))
+		curr = xas->xa_node;
+	return curr;
+}
+
+void *rust_helper_xa_zero_to_null(void *entry)
+{
+	return xa_is_zero(entry) ? NULL : entry;
+}
+
+int rust_helper_xas_error(const struct xa_state *xas)
+{
+	return xas_error(xas);
+}
diff --git a/rust/kernel/xarray.rs b/rust/kernel/xarray.rs
index 656ec897a0c41..8c10e8fd76f15 100644
--- a/rust/kernel/xarray.rs
+++ b/rust/kernel/xarray.rs
@@ -13,11 +13,17 @@
         NonNull, //
     },
 };
+pub use entry::{
+    Entry,
+    OccupiedEntry,
+    VacantEntry, //
+};
 use kernel::{
     alloc,
     bindings,
     build_assert, //
     error::{
+        to_result,
         Error,
         Result, //
     },
@@ -251,6 +257,35 @@ pub fn get_mut(&mut self, index: usize) -> Option<T::BorrowedMut<'_>> {
         Some(unsafe { T::borrow_mut(ptr.as_ptr()) })
     }
 
+    /// Gets an entry for the specified index, which can be vacant or occupied.
+    ///
+    /// # Examples
+    ///
+    /// ```
+    /// # use kernel::{prelude::*, xarray::{AllocKind, XArray, Entry}};
+    /// let mut xa = KBox::pin_init(XArray::<KBox<u32>>::new(AllocKind::Alloc), GFP_KERNEL)?;
+    /// let mut guard = xa.lock();
+    ///
+    /// assert_eq!(guard.contains_index(42), false);
+    ///
+    /// match guard.entry(42) {
+    ///     Entry::Vacant(entry) => {
+    ///         entry.insert(KBox::new(0x1337u32, GFP_KERNEL)?)?;
+    ///     }
+    ///     Entry::Occupied(_) => unreachable!("We did not insert an entry yet"),
+    /// }
+    ///
+    /// assert_eq!(guard.get(42), Some(&0x1337));
+    ///
+    /// # Ok::<(), kernel::error::Error>(())
+    /// ```
+    pub fn entry<'b>(&'b mut self, index: usize) -> Entry<'a, 'b, T> {
+        match self.load(index) {
+            None => Entry::Vacant(VacantEntry::new(self, index)),
+            Some(ptr) => Entry::Occupied(OccupiedEntry::new(self, index, ptr)),
+        }
+    }
+
     fn load_next(&self, index: usize) -> Option<(usize, NonNull<c_void>)> {
         XArrayState::new(self, index).load_next()
     }
@@ -312,6 +347,72 @@ pub fn find_next_mut(&mut self, index: usize) -> Option<(usize, T::BorrowedMut<'
             .map(move |(index, ptr)| (index, unsafe { T::borrow_mut(ptr.as_ptr()) }))
     }
 
+    /// Finds the next occupied entry starting from the given index.
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
+    /// if let Some(entry) = guard.find_next_entry(5) {
+    ///     assert_eq!(entry.index(), 10);
+    ///     let value = entry.remove();
+    ///     assert_eq!(*value, 10);
+    /// }
+    ///
+    /// assert_eq!(guard.get(10), None);
+    ///
+    /// # Ok::<(), kernel::error::Error>(())
+    /// ```
+    pub fn find_next_entry<'b>(&'b mut self, index: usize) -> Option<OccupiedEntry<'a, 'b, T>> {
+        let mut state = XArrayState::new(self, index);
+        let (_, ptr) = state.load_next()?;
+        Some(OccupiedEntry { state, ptr })
+    }
+
+    /// Finds the next occupied entry starting at the given index, wrapping around.
+    ///
+    /// Searches for an entry starting at `index` up to the maximum index. If no entry
+    /// is found, wraps around and searches from index 0 up to `index`.
+    ///
+    /// # Examples
+    ///
+    /// ```
+    /// # use kernel::{prelude::*, xarray::{AllocKind, XArray}};
+    /// let mut xa = KBox::pin_init(XArray::<KBox<u32>>::new(AllocKind::Alloc), GFP_KERNEL)?;
+    /// let mut guard = xa.lock();
+    ///
+    /// guard.store(100, KBox::new(42u32, GFP_KERNEL)?, GFP_KERNEL)?;
+    /// let entry = guard.find_next_entry_circular(101);
+    /// assert_eq!(entry.map(|e| e.index()), Some(100));
+    ///
+    /// # Ok::<(), kernel::error::Error>(())
+    /// ```
+    pub fn find_next_entry_circular<'b>(
+        &'b mut self,
+        index: usize,
+    ) -> Option<OccupiedEntry<'a, 'b, T>> {
+        let mut state = XArrayState::new(self, index);
+
+        // SAFETY: `state.state` is properly initialized by XArrayState::new and the caller holds
+        // the lock.
+        let ptr = NonNull::new(unsafe { bindings::xas_find(&mut state.state, usize::MAX) })
+            .or_else(|| {
+                state.state.xa_node = bindings::XAS_RESTART as *mut bindings::xa_node;
+                state.state.xa_index = 0;
+                // SAFETY: `state.state` is properly initialized and by type invariant, we hold the
+                // xarray lock.
+                NonNull::new(unsafe { bindings::xas_find(&mut state.state, index) })
+            })?;
+
+        Some(OccupiedEntry { state, ptr })
+    }
+
     /// Removes and returns the element at the given index.
     pub fn remove(&mut self, index: usize) -> Option<T> {
         // SAFETY:
@@ -422,8 +523,30 @@ fn load_next(&mut self) -> Option<(usize, NonNull<c_void>)> {
         let ptr = unsafe { bindings::xas_find(&raw mut self.state, usize::MAX) };
         NonNull::new(ptr).map(|ptr| (self.state.xa_index, ptr))
     }
+
+    fn status(&self) -> Result {
+        // SAFETY: `self.state` is properly initialized and valid.
+        to_result(unsafe { bindings::xas_error(&self.state) })
+    }
+
+    fn insert(&mut self, value: T) -> Result<*mut c_void, StoreError<T>> {
+        let new = T::into_foreign(value).cast();
+
+        // SAFETY: `self.state.state` is properly initialized and `new` came from `T::into_foreign`.
+        // We hold the xarray lock.
+        unsafe { bindings::xas_store(&mut self.state, new) };
+
+        self.status().map(|()| new).map_err(|error| {
+            // SAFETY: `new` came from `T::into_foreign` and `xas_store` does not take ownership of
+            // the value on error.
+            let value = unsafe { T::from_foreign(new) };
+            StoreError { value, error }
+        })
+    }
 }
 
+mod entry;
+
 // SAFETY: `XArray<T>` has no shared mutable state so it is `Send` iff `T` is `Send`.
 unsafe impl<T: ForeignOwnable + Send> Send for XArray<T> {}
 
diff --git a/rust/kernel/xarray/entry.rs b/rust/kernel/xarray/entry.rs
new file mode 100644
index 0000000000000..1b1c21bed7022
--- /dev/null
+++ b/rust/kernel/xarray/entry.rs
@@ -0,0 +1,367 @@
+// SPDX-License-Identifier: GPL-2.0
+
+use super::{
+    Guard,
+    StoreError,
+    XArrayState, //
+};
+use core::ptr::NonNull;
+use kernel::{
+    prelude::*,
+    types::ForeignOwnable, //
+};
+
+/// Represents either a vacant or occupied entry in an XArray.
+pub enum Entry<'a, 'b, T: ForeignOwnable> {
+    /// A vacant entry that can have a value inserted.
+    Vacant(VacantEntry<'a, 'b, T>),
+    /// An occupied entry containing a value.
+    Occupied(OccupiedEntry<'a, 'b, T>),
+}
+
+impl<T: ForeignOwnable> Entry<'_, '_, T> {
+    /// Returns true if this entry is occupied.
+    ///
+    /// # Examples
+    ///
+    /// ```
+    /// # use kernel::{prelude::*, xarray::{AllocKind, XArray, Entry}};
+    /// let mut xa = KBox::pin_init(XArray::<KBox<u32>>::new(AllocKind::Alloc), GFP_KERNEL)?;
+    /// let mut guard = xa.lock();
+    ///
+    ///
+    /// let entry = guard.entry(42);
+    /// assert_eq!(entry.is_occupied(), false);
+    ///
+    /// guard.store(42, KBox::new(0x1337u32, GFP_KERNEL)?, GFP_KERNEL)?;
+    /// let entry = guard.entry(42);
+    /// assert_eq!(entry.is_occupied(), true);
+    ///
+    /// # Ok::<(), kernel::error::Error>(())
+    /// ```
+    pub fn is_occupied(&self) -> bool {
+        matches!(self, Entry::Occupied(_))
+    }
+}
+
+/// A view into a vacant entry in an XArray.
+pub struct VacantEntry<'a, 'b, T: ForeignOwnable> {
+    state: XArrayState<'a, 'b, T>,
+}
+
+impl<'a, 'b, T> VacantEntry<'a, 'b, T>
+where
+    T: ForeignOwnable,
+{
+    pub(crate) fn new(guard: &'b mut Guard<'a, T>, index: usize) -> Self {
+        Self {
+            state: XArrayState::new(guard, index),
+        }
+    }
+
+    /// Inserts a value into this vacant entry.
+    ///
+    /// Returns a reference to the newly inserted value.
+    ///
+    /// - This method will fail if the nodes on the path to the index
+    ///   represented by this entry are not present in the XArray.
+    /// - This method will not drop the XArray lock.
+    ///
+    ///
+    /// # Examples
+    ///
+    /// ```
+    /// # use kernel::{prelude::*, xarray::{AllocKind, XArray, Entry}};
+    /// let mut xa = KBox::pin_init(XArray::<KBox<u32>>::new(AllocKind::Alloc), GFP_KERNEL)?;
+    /// let mut guard = xa.lock();
+    ///
+    /// assert_eq!(guard.get(42), None);
+    ///
+    /// if let Entry::Vacant(entry) = guard.entry(42) {
+    ///     let value = KBox::new(0x1337u32, GFP_KERNEL)?;
+    ///     let borrowed = entry.insert(value)?;
+    ///     assert_eq!(*borrowed, 0x1337);
+    /// }
+    ///
+    /// assert_eq!(guard.get(42).copied(), Some(0x1337));
+    ///
+    /// # Ok::<(), kernel::error::Error>(())
+    /// ```
+    pub fn insert(mut self, value: T) -> Result<T::BorrowedMut<'b>, StoreError<T>> {
+        let new = self.state.insert(value)?;
+
+        // SAFETY: `new` came from `T::into_foreign`. The entry has exclusive
+        // ownership of `new` as it holds a mutable reference to `Guard`.
+        Ok(unsafe { T::borrow_mut(new) })
+    }
+
+    /// Inserts a value and returns an occupied entry representing the newly inserted value.
+    ///
+    /// - This method will fail if the nodes on the path to the index
+    ///   represented by this entry are not present in the XArray.
+    /// - This method will not drop the XArray lock.
+    ///
+    /// # Examples
+    ///
+    /// ```
+    /// # use kernel::{prelude::*, xarray::{AllocKind, XArray, Entry}};
+    /// let mut xa = KBox::pin_init(XArray::<KBox<u32>>::new(AllocKind::Alloc), GFP_KERNEL)?;
+    /// let mut guard = xa.lock();
+    ///
+    /// assert_eq!(guard.get(42), None);
+    ///
+    /// if let Entry::Vacant(entry) = guard.entry(42) {
+    ///     let value = KBox::new(0x1337u32, GFP_KERNEL)?;
+    ///     let occupied = entry.insert_entry(value)?;
+    ///     assert_eq!(occupied.index(), 42);
+    /// }
+    ///
+    /// assert_eq!(guard.get(42).copied(), Some(0x1337));
+    ///
+    /// # Ok::<(), kernel::error::Error>(())
+    /// ```
+    pub fn insert_entry(mut self, value: T) -> Result<OccupiedEntry<'a, 'b, T>, StoreError<T>> {
+        let new = self.state.insert(value)?;
+
+        Ok(OccupiedEntry::<'a, 'b, T> {
+            state: self.state,
+            // SAFETY: `new` came from `T::into_foreign` and is guaranteed non-null.
+            ptr: unsafe { core::ptr::NonNull::new_unchecked(new) },
+        })
+    }
+
+    /// Returns the index of this vacant entry.
+    ///
+    /// # Examples
+    ///
+    /// ```
+    /// # use kernel::{prelude::*, xarray::{AllocKind, XArray, Entry}};
+    /// let mut xa = KBox::pin_init(XArray::<KBox<u32>>::new(AllocKind::Alloc), GFP_KERNEL)?;
+    /// let mut guard = xa.lock();
+    ///
+    /// assert_eq!(guard.get(42), None);
+    ///
+    /// if let Entry::Vacant(entry) = guard.entry(42) {
+    ///     assert_eq!(entry.index(), 42);
+    /// }
+    ///
+    /// # Ok::<(), kernel::error::Error>(())
+    /// ```
+    pub fn index(&self) -> usize {
+        self.state.state.xa_index
+    }
+}
+
+/// A view into an occupied entry in an XArray.
+pub struct OccupiedEntry<'a, 'b, T: ForeignOwnable> {
+    pub(crate) state: XArrayState<'a, 'b, T>,
+    pub(crate) ptr: NonNull<c_void>,
+}
+
+impl<'a, 'b, T> OccupiedEntry<'a, 'b, T>
+where
+    T: ForeignOwnable,
+{
+    pub(crate) fn new(guard: &'b mut Guard<'a, T>, index: usize, ptr: NonNull<c_void>) -> Self {
+        Self {
+            state: XArrayState::new(guard, index),
+            ptr,
+        }
+    }
+
+    /// Removes the value from this occupied entry and returns it, consuming the entry.
+    ///
+    /// # Examples
+    ///
+    /// ```
+    /// # use kernel::{prelude::*, xarray::{AllocKind, XArray, Entry}};
+    /// let mut xa = KBox::pin_init(XArray::<KBox<u32>>::new(AllocKind::Alloc), GFP_KERNEL)?;
+    /// let mut guard = xa.lock();
+    ///
+    /// guard.store(42, KBox::new(0x1337u32, GFP_KERNEL)?, GFP_KERNEL)?;
+    /// assert_eq!(guard.get(42).copied(), Some(0x1337));
+    ///
+    /// if let Entry::Occupied(entry) = guard.entry(42) {
+    ///     let value = entry.remove();
+    ///     assert_eq!(*value, 0x1337);
+    /// }
+    ///
+    /// assert_eq!(guard.get(42), None);
+    ///
+    /// # Ok::<(), kernel::error::Error>(())
+    /// ```
+    pub fn remove(mut self) -> T {
+        // SAFETY: `self.state.state` is properly initialized and valid for XAS operations.
+        let ptr = unsafe {
+            bindings::xas_result(
+                &mut self.state.state,
+                bindings::xa_zero_to_null(bindings::xas_store(
+                    &mut self.state.state,
+                    core::ptr::null_mut(),
+                )),
+            )
+        };
+
+        // SAFETY: `ptr` is a valid return value from xas_result.
+        let errno = unsafe { bindings::xa_err(ptr) };
+
+        // NOTE: Storing NULL to an occupied slot never fails. This is by design
+        // of the xarray data structure. If a slot is occupied, a store is a
+        // simple pointer swap.
+        debug_assert!(errno == 0);
+
+        // SAFETY:
+        // - `ptr` came from `T::into_foreign`.
+        // - As this method takes self by value, the lifetimes of any [`T::Borrowed`] and
+        //   [`T::BorrowedMut`] we have created must have ended.
+        unsafe { T::from_foreign(ptr.cast()) }
+    }
+
+    /// Returns the index of this occupied entry.
+    ///
+    /// # Examples
+    ///
+    /// ```
+    /// # use kernel::{prelude::*, xarray::{AllocKind, XArray, Entry}};
+    /// let mut xa = KBox::pin_init(XArray::<KBox<u32>>::new(AllocKind::Alloc), GFP_KERNEL)?;
+    /// let mut guard = xa.lock();
+    ///
+    /// guard.store(42, KBox::new(0x1337u32, GFP_KERNEL)?, GFP_KERNEL)?;
+    ///
+    /// if let Entry::Occupied(entry) = guard.entry(42) {
+    ///     assert_eq!(entry.index(), 42);
+    /// }
+    ///
+    /// # Ok::<(), kernel::error::Error>(())
+    /// ```
+    pub fn index(&self) -> usize {
+        self.state.state.xa_index
+    }
+
+    /// Replaces the value in this occupied entry and returns the old value.
+    ///
+    /// # Examples
+    ///
+    /// ```
+    /// # use kernel::{prelude::*, xarray::{AllocKind, XArray, Entry}};
+    /// let mut xa = KBox::pin_init(XArray::<KBox<u32>>::new(AllocKind::Alloc), GFP_KERNEL)?;
+    /// let mut guard = xa.lock();
+    ///
+    /// guard.store(42, KBox::new(0x1337u32, GFP_KERNEL)?, GFP_KERNEL)?;
+    ///
+    /// if let Entry::Occupied(mut entry) = guard.entry(42) {
+    ///     let new_value = KBox::new(0x9999u32, GFP_KERNEL)?;
+    ///     let old_value = entry.insert(new_value);
+    ///     assert_eq!(*old_value, 0x1337);
+    /// }
+    ///
+    /// assert_eq!(guard.get(42).copied(), Some(0x9999));
+    ///
+    /// # Ok::<(), kernel::error::Error>(())
+    /// ```
+    pub fn insert(&mut self, value: T) -> T {
+        let new = T::into_foreign(value).cast();
+        // SAFETY: `new` came from `T::into_foreign` and is guaranteed non-null.
+        self.ptr = unsafe { NonNull::new_unchecked(new) };
+
+        // SAFETY: `self.state.state` is properly initialized and valid for XAS operations.
+        let old = unsafe {
+            bindings::xas_result(
+                &mut self.state.state,
+                bindings::xa_zero_to_null(bindings::xas_store(&mut self.state.state, new)),
+            )
+        };
+
+        // SAFETY: `old` is a valid return value from xas_result.
+        let errno = unsafe { bindings::xa_err(old) };
+
+        // NOTE: Storing NULL to an occupied slot never fails. This is by design
+        // of the xarray data structure. If a slot is occupied, a store is a
+        // simple pointer swap.
+        debug_assert!(errno == 0);
+
+        // SAFETY:
+        // - `ptr` came from `T::into_foreign`.
+        // - As this method takes self by value, the lifetimes of any [`T::Borrowed`] and
+        //   [`T::BorrowedMut`] we have created must have ended.
+        unsafe { T::from_foreign(old) }
+    }
+
+    /// Converts this occupied entry into a mutable reference to the value in the slot represented
+    /// by the entry.
+    ///
+    /// # Examples
+    ///
+    /// ```
+    /// # use kernel::{prelude::*, xarray::{AllocKind, XArray, Entry}};
+    /// let mut xa = KBox::pin_init(XArray::<KBox<u32>>::new(AllocKind::Alloc), GFP_KERNEL)?;
+    /// let mut guard = xa.lock();
+    ///
+    /// guard.store(42, KBox::new(0x1337u32, GFP_KERNEL)?, GFP_KERNEL)?;
+    ///
+    /// if let Entry::Occupied(entry) = guard.entry(42) {
+    ///     let value_ref = entry.into_mut();
+    ///     *value_ref = 0x9999;
+    /// }
+    ///
+    /// assert_eq!(guard.get(42).copied(), Some(0x9999));
+    ///
+    /// # Ok::<(), kernel::error::Error>(())
+    /// ```
+    pub fn into_mut(self) -> T::BorrowedMut<'b> {
+        // SAFETY: `ptr` came from `T::into_foreign`.
+        unsafe { T::borrow_mut(self.ptr.as_ptr()) }
+    }
+
+    /// Swaps the value in this entry with the provided value.
+    ///
+    /// Returns the old value that was in the entry.
+    ///
+    /// # Examples
+    ///
+    /// ```
+    /// # use kernel::{prelude::*, xarray::{AllocKind, XArray, Entry}};
+    /// let mut xa = KBox::pin_init(XArray::<KBox<u32>>::new(AllocKind::Alloc), GFP_KERNEL)?;
+    /// let mut guard = xa.lock();
+    ///
+    /// guard.store(42, KBox::new(100u32, GFP_KERNEL)?, GFP_KERNEL)?;
+    ///
+    /// if let Entry::Occupied(mut entry) = guard.entry(42) {
+    ///     let mut other = 200u32;
+    ///     entry.swap(&mut other);
+    ///     assert_eq!(other, 100);
+    ///     assert_eq!(*entry, 200);
+    /// }
+    ///
+    /// # Ok::<(), kernel::error::Error>(())
+    /// ```
+    pub fn swap<U>(&mut self, other: &mut U)
+    where
+        T: for<'c> ForeignOwnable<Borrowed<'c> = &'c U, BorrowedMut<'c> = &'c mut U>,
+    {
+        use core::ops::DerefMut;
+        core::mem::swap(self.deref_mut(), other);
+    }
+}
+
+impl<T, U> core::ops::Deref for OccupiedEntry<'_, '_, T>
+where
+    T: for<'a> ForeignOwnable<Borrowed<'a> = &'a U, BorrowedMut<'a> = &'a mut U>,
+{
+    type Target = U;
+
+    fn deref(&self) -> &Self::Target {
+        // SAFETY: `ptr` came from `T::into_foreign`.
+        unsafe { T::borrow(self.ptr.as_ptr()) }
+    }
+}
+
+impl<T, U> core::ops::DerefMut for OccupiedEntry<'_, '_, T>
+where
+    T: for<'a> ForeignOwnable<Borrowed<'a> = &'a U, BorrowedMut<'a> = &'a mut U>,
+{
+    fn deref_mut(&mut self) -> &mut Self::Target {
+        // SAFETY: `ptr` came from `T::into_foreign`.
+        unsafe { T::borrow_mut(self.ptr.as_ptr()) }
+    }
+}

-- 
2.51.2



