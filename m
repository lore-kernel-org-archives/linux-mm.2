Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F313EC624D3
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 13:28:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 06BD36B00A2; Wed,  2 Sep 2026 09:28:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0436F6B00A3; Wed,  2 Sep 2026 09:28:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E745A6B00A4; Wed,  2 Sep 2026 09:28:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BA4D06B00A2
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 09:28:01 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4D0BC1A0214
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 13:28:01 +0000 (UTC)
X-FDA: 85168900362.14.9512475
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 68B424000D
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 13:27:59 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Sn6LU0vz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788355679;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TtGXfe3UgrJr2ur/bX83JZ7bo7tBV7HzFH0EsANUt8I=;
	b=ViD8YQvkYOUvFTwpDqVGEbjJxMur7y1yc9diHZ2kqYD1f6UtcCfgIXvWLjRmWlDh8VNcbU
	tgrreuljbL4E3/P9q70JXJX9FmIM1tOSuJMTh3ZUpMUsJv+MD6xr1FHJD0rrQJQlub6GhP
	GJeHIYJiXPja7PyLoP8lvMJeLyAkCQY=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Sn6LU0vz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788355679;
	b=lUQ6qzLeP8iA0PXtDjDEePzlAlhgSJApAfE4GP2/OZffsV2C60he54XNiT8wfMcAOTURLx
	j9j3YKehbJK56jFWqYmHKCXgso9PsGNZRn7NnAfl7wxi3+UgSll5Cf97ifHicS5hfBSgRv
	fdW469KFuHTiSOeLzy/IcBlJ7h579fE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B8DB943F62;
	Wed,  2 Sep 2026 13:27:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 390961F000E9;
	Wed,  2 Sep 2026 13:27:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788355678;
	bh=TtGXfe3UgrJr2ur/bX83JZ7bo7tBV7HzFH0EsANUt8I=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Sn6LU0vzyBw7YCgbOTekoR56JeLfGlyr9O/NrQbQcRubm7gFSB3LYs/mIR0TRsK+A
	 EtAb/CnnubejXMtKLlQdL74bc8Pfp4JLsGSBITYM/2ajlew/IpVT+/2QAl2TwDXmsc
	 ifKjTJpGdFcxOF2Z0pFmRl2V7joTMWuZV4ZGL9n5PLRVLUpvEQdGPLyLPIVUvNAFqr
	 3G1E6/xaQCkPFHRSF4Q8N0evXGOP8wgLrDiAcqSqJWmxJbCF4Hh/1dddYd1vtDsO1q
	 X/9bFUtOU9/hJyo8g4O4ZzioXpOFEUTuto15ImI2EMrqX6Yh5TuWMTmu7pTD+0iWAv
	 /5Ch2dEsGIUTw==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Wed, 02 Sep 2026 15:26:03 +0200
Subject: [PATCH v5 07/12] rust: xarray: add entry API
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260902-xarray-entry-send-v5-7-d18adae40708@kernel.org>
References: <20260902-xarray-entry-send-v5-0-d18adae40708@kernel.org>
In-Reply-To: <20260902-xarray-entry-send-v5-0-d18adae40708@kernel.org>
To: Tamir Duberstein <tamird@kernel.org>, Miguel Ojeda <ojeda@kernel.org>, 
 Boqun Feng <boqun@kernel.org>, Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Benno Lossin <lossin@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
 Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, 
 Daniel Almeida <daniel.almeida@collabora.com>, 
 Alexandre Courbot <acourbot@nvidia.com>, 
 =?utf-8?q?Onur_=C3=96zkan?= <work@onurozkan.dev>, 
 Matthew Wilcox <willy@infradead.org>, 
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Harry Yoo <harry@kernel.org>, Hao Li <hao.li@linux.dev>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>
Cc: Andreas Hindborg <a.hindborg@kernel.org>, 
 rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=25013;
 i=a.hindborg@kernel.org; h=from:subject:message-id;
 bh=N0seg49LGL+ncCSnIaEcZdb0Lz2Cj3067QB2ZoDt4f8=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBqmCQftwjyRwwB7slItWIwhGpZLWXd6654Bd8iE
 29IpNLZp/KJAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCapgkHwAKCRD6UCkIqsW9
 0EtnD/4x5CwgZg4JMtMZFlVFu8tlgPVC7TMNG9+wpGGez3Q4UvyKtuQGK6Ub2Om3DsS9DwHfKhV
 PuZTgn+Iwy2yp5GNaMz04CIUGDhZrBWtCjAhmKtsh+diz7ZiWeBsatPeW1WaH0DzkJmTeY175ph
 1WgSn1lPiU8KNwOEvju2G7yBtd7K/uq925aP4hwoVR0PcQGASj6OYGPA4O3EweBek+d2RavtotG
 +dKXHbHA3FbGw5Ipg6yAfNOTGMCH2ZJSzMzMaSmQSjNP68H1WCtlkm/qpXjpjcr21K9tXw5MGOJ
 A3vAurUriLWqxwNs8VvHf4O1GrUx7ufRstDqQIFYLLwB1WfipIuddyNy3OfLsyDRp9CISlmAZdj
 UUM9y4L4NB5KPSkZXBk4elN4sfytxeyoypkX/mtgH7CsSN8SE+xDVrKAR/SBONF+7deUhvOYZi9
 tTotY39SPiO0cS1yd+JTsEfuUgag5RvDTjOux9fFtFWxippWoGc6/vXPI4rbsFN72kWiMcHotQh
 GK4Xiba9F5KwaElBLgHbIhJMn5ZR6L8mdDBQGrvpaRBs3nwBBzCL+PBhDt2GTi9IDEsMyC8frA3
 fnji8J//iopnqXd6hQKVolrmbPhWKBuLpgH2d7dTiZgg18+yZxdongcLsFOJOBOtCzRuClOPxK+
 FRCBKdq+HkX0LHw==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 68B424000D
X-Stat-Signature: tqk9gojp38goqyzn8ru53daynxah3xrb
X-Rspam-User: 
X-HE-Tag: 1788355679-344549
X-HE-Meta: U2FsdGVkX19Rp0+MTXek7/UInd8hIMqNT6nB3qqysZokdKIRYQlWqD2zP/HU9uAXjmrTryOmNH/7XrovTSZkdgSDyyJvwGBMUr37XjWJlThtbK4GSwBIJ2uZ4pdLzQmxFJglETgY09yc4BYSKXE8bmrlHH5TNZhDKluLqLd0mzgZJ/EFcKIx2WlXvHlVXEcVFJD/FyUyveYuZZRGd4ws6ioCZmNpOb0zys3n2GEY2IuJujOK4SYnoQIW+RZG3Pl0g6RoFiSuwJGGFYss2aWHVJJlpQY9V0o7zq1jGzoLlBKZn2a6GmS8rgekMTSmsZ5ikzMxpywwGkEVAyf9344x7rargN/fP/ZMqcdRstO0wH8iZQITwDnA7n5f3hMYO2vo0P7NV8c2wIv88A2MF/b30Z/UVGm9cOXAycSMqzlbk8LDw+zZEvEoFrllZFHq6cEjS/7MaqWS/eG2PicsUc3nJlED21XeBtbrneDS4VZfGjyllNqUCGwGc/Y0bcH/Lby4P90Dm/GfnSehWt4esVGhcF5gae174W9ivyJRKm1Uf2s0T5EZRXCSbuML8TBg26dn7oowQboLxiBZmXkYHnuDTQSD+fY/FZ88K6YQmis7MGap3Mh3FLh6M5IX3TYHZkL5DGwffdxSFf415kp9zgLgrCH7tfQQwlZq194SlPCZS5mRsAbeun46wq3SvWMMauyK0IZWpbK+F94W2ifHzeHFPtiLg/hyTfeqvjWFlV8Gi5gENWd4GOU9m+Geq2cvqTnnak9vsaL3L9tg6EgoVGB3L0hUHVleNyOtClOxVZx0pvhGAYkSUh27GcehgZDK/qVMn/fRLYExZlV+3JL8GYoU5i6LWMsmo+CDhCMvuYB5VitTiIPEra90s45gpgDlO6wX6vUi0NgH11AKgdkdk51VV7NRKMtCzv0jJ5By0iZT0+OJsQQYU7lL2s+9DT5QjTiBgyrosjuEhFKGemu7nGW
 QQ+5cAWI
 NdY65n2cLmrG6trcfkb3xqRuNaHLNmY7b9CxdDtjyr8ZULmGu43S4g2R25tsFfOXBVvaGQogCL09KzHeFowvUdR3T+gkXn/LpIiH1sTyYc9Ki6HeaC4DZHq/NZyCOXIUdiEidVnqq5iN3oI9tVfSgT8doesKPDoR3aZnnmXgpxt891FuPbtWi+Xw+XYE6/e4sRkmmZpyeWQLYi7x/g10RMan46VgJGm//GDaUX6x+QgHEP4F3+/iNY/quMrwXUJSPwOtUkicj2BxQgnZjR9hwfHfsNMsLjTKuRLCbXscHNlpa4HehUpmROM962um6NPFQ8IPKyo8kvYFS/bfkiOzyUT3ZvFb0bCqy5O+J78vU96LbU5I/U2whRDmePZN3UH+1/4uathIlQOTUgt4=
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

`Guard::entry` returns an `Entry` that is either `Vacant` or
`Occupied`. The functionality provided by the two entry types is
motivated by the needs of the Rust null block driver memory backing
implementation:

- `VacantEntry::insert` inserts a value and returns a borrow of it.
  `VacantEntry::insert_entry` inserts a value and returns an
  `OccupiedEntry` instead, for callers that need to perform further
  operations on the slot after insertion.
- `OccupiedEntry` provides access to the value through `Deref` and
  `DerefMut`, replaces the value through `insert` or `swap`, and
  removes it from the array through `remove`.
- `Entry::is_occupied` and the `index` methods support conditional
  logic and bookkeeping in callers.
- `into_guard` releases the borrow of the slot and returns the
  underlying guard, so a caller can continue operating on the array
  without dropping the lock.
- `Guard::find_next_entry` and `Guard::find_next_entry_circular`
  return an `OccupiedEntry` for the next occupied slot, the latter
  wrapping around at the end of the array. `Guard::insert_entry`
  combines lookup and insertion into one operation.

The implementation uses the XArray state API (`xas_*` functions) for
efficient operations without requiring multiple lookups. Helper
functions are added to rust/helpers/xarray.c to wrap static inline C
functions that are not directly accessible from Rust.

Also update MAINTAINERS to cover the new rust files.

Assisted-by: LLM
Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 MAINTAINERS                     |   1 +
 rust/bindings/bindings_helper.h |   1 +
 rust/helpers/xarray.c           |  10 ++
 rust/kernel/xarray.rs           | 174 ++++++++++++++++++-
 rust/kernel/xarray/entry.rs     | 362 ++++++++++++++++++++++++++++++++++++++++
 5 files changed, 544 insertions(+), 4 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 8014b9f8253ed..b2c9911b88d1d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -29347,6 +29347,7 @@ B:	https://github.com/Rust-for-Linux/linux/issues
 C:	https://rust-for-linux.zulipchat.com
 T:	git https://github.com/Rust-for-Linux/linux.git xarray-next
 F:	rust/kernel/xarray.rs
+F:	rust/kernel/xarray/
 
 XBOX DVD IR REMOTE
 M:	Benjamin Valentin <benpicco@googlemail.com>
diff --git a/rust/bindings/bindings_helper.h b/rust/bindings/bindings_helper.h
index 419e6b74fedc3..5dda2bb36e3c2 100644
--- a/rust/bindings/bindings_helper.h
+++ b/rust/bindings/bindings_helper.h
@@ -121,6 +121,7 @@ const blk_features_t RUST_CONST_HELPER_BLK_FEAT_ROTATIONAL = BLK_FEAT_ROTATIONAL
 const fop_flags_t RUST_CONST_HELPER_FOP_UNSIGNED_OFFSET = FOP_UNSIGNED_OFFSET;
 
 const xa_mark_t RUST_CONST_HELPER_XA_PRESENT = XA_PRESENT;
+const xa_mark_t RUST_CONST_HELPER_XA_FREE_MARK = XA_FREE_MARK;
 
 const gfp_t RUST_CONST_HELPER_XA_FLAGS_ALLOC = XA_FLAGS_ALLOC;
 const gfp_t RUST_CONST_HELPER_XA_FLAGS_ALLOC1 = XA_FLAGS_ALLOC1;
diff --git a/rust/helpers/xarray.c b/rust/helpers/xarray.c
index 79799c55c3d73..d7548a17ae0d0 100644
--- a/rust/helpers/xarray.c
+++ b/rust/helpers/xarray.c
@@ -27,7 +27,17 @@ __rust_helper void rust_helper_xa_unlock(struct xarray *xa)
 	return xa_unlock(xa);
 }
 
+__rust_helper void *rust_helper_xas_result(struct xa_state *xas, void *curr)
+{
+	return xas_result(xas, curr);
+}
+
 __rust_helper void *rust_helper_xa_zero_to_null(void *entry)
 {
 	return xa_zero_to_null(entry);
 }
+
+__rust_helper int rust_helper_xas_error(const struct xa_state *xas)
+{
+	return xas_error(xas);
+}
diff --git a/rust/kernel/xarray.rs b/rust/kernel/xarray.rs
index 9993783fc854a..cf7248bddb8b9 100644
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
     build_assert::build_assert, //
     error::{
+        to_result,
         Error,
         Result, //
     },
@@ -250,6 +256,35 @@ pub fn get_mut(&mut self, index: usize) -> Option<T::BorrowedMut<'_>> {
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
+    /// assert!(guard.get(42).is_none());
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
         XArrayState::new(self, index).load_next(usize::MAX)
     }
@@ -311,6 +346,66 @@ pub fn find_next_mut(&mut self, index: usize) -> Option<(usize, T::BorrowedMut<'
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
+    /// guard.store(10, KBox::new(10u32, GFP_ATOMIC)?, GFP_ATOMIC)?;
+    /// guard.store(20, KBox::new(20u32, GFP_ATOMIC)?, GFP_ATOMIC)?;
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
+        let (_, ptr) = state.load_next(usize::MAX)?;
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
+    /// guard.store(100, KBox::new(42u32, GFP_ATOMIC)?, GFP_ATOMIC)?;
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
+        let (_, ptr) = state.load_next(usize::MAX).or_else(|| {
+            state.restart_at(0);
+            state.load_next(index)
+        })?;
+
+        Some(OccupiedEntry { state, ptr })
+    }
+
     /// Removes and returns the element at the given index.
     pub fn remove(&mut self, index: usize) -> Option<T> {
         // SAFETY:
@@ -386,10 +481,6 @@ pub fn store(
 /// - `state` is always a valid `bindings::xa_state`.
 /// - `state.xa` aliases the xarray reachable through `guard`.
 pub(crate) struct XArrayState<R> {
-    // The borrow is held to guarantee exclusive access to the array. It is
-    // not read until a later patch adds `into_guard`, so silence the dead
-    // code warning until then.
-    #[expect(dead_code)]
     guard: R,
     state: bindings::xa_state,
 }
@@ -460,8 +551,83 @@ fn load_next(&mut self, max: usize) -> Option<(usize, NonNull<c_void>)> {
             }
         }
     }
+
+    fn status(&self) -> Result {
+        // SAFETY: `self.state` is a valid `xa_state` by the type invariant.
+        to_result(unsafe { bindings::xas_error(&self.state) })
+    }
+
+    /// Resets the state so the next operation walks the tree from the root,
+    /// starting at `index`.
+    fn restart_at(&mut self, index: usize) {
+        self.state.xa_index = index;
+        self.state.xa_node = bindings::XAS_RESTART as *mut bindings::xa_node;
+    }
 }
 
+// Operations that modify the array require exclusive access to the guard, so
+// they are only implemented for `XArrayState<&mut Guard>`.
+impl<'a, 'b, T: ForeignOwnable> XArrayState<&'b mut Guard<'a, T>> {
+    /// Stores `new` at the index of this state, returning the previous entry.
+    ///
+    /// The slot at the index of this state must be occupied. Storing to an
+    /// occupied slot is a simple pointer swap that cannot fail, by design of
+    /// the xarray data structure.
+    fn replace(&mut self, new: *mut c_void) -> *mut c_void {
+        // SAFETY: `self.state` is a valid `xa_state` by the type invariant. By the same
+        // invariant, `self.state.xa` aliases the xarray reachable through `self.guard`, whose
+        // lock we hold.
+        let old = unsafe {
+            bindings::xas_result(
+                &raw mut self.state,
+                bindings::xa_zero_to_null(bindings::xas_store(&raw mut self.state, new)),
+            )
+        };
+
+        // SAFETY: `old` is a valid return value from `xas_result`.
+        let errno = unsafe { bindings::xa_err(old) };
+
+        // NOTE: Storing to an occupied slot never fails. This is by design of
+        // the xarray data structure. If a slot is occupied, a store is a
+        // simple pointer swap.
+        debug_assert!(errno == 0);
+
+        old
+    }
+
+    fn insert(&mut self, value: T) -> Result<*mut c_void, StoreError<T>> {
+        let new = T::into_foreign(value).cast();
+
+        // SAFETY: `self.state` is a valid `xa_state` by the type invariant. By the same
+        // invariant, `self.state.xa` aliases the xarray reachable through `self.guard`,
+        // whose lock we hold. `new` came from `T::into_foreign`.
+        unsafe { bindings::xas_store(&mut self.state, new) };
+
+        // All arrays created by this abstraction have `XA_FLAGS_TRACK_FREE` set, so the
+        // free mark must be cleared for a newly occupied index, as `__xa_store` does.
+        // This is a no-op if the store above failed.
+        //
+        // SAFETY: `self.state` is a valid `xa_state` by the type invariant, and we hold
+        // the lock on the xarray it refers to.
+        unsafe { bindings::xas_clear_mark(&self.state, bindings::XA_FREE_MARK) };
+
+        self.status().map(|()| new).map_err(|error| {
+            // SAFETY: `new` came from `T::into_foreign` and `xas_store` does not take
+            // ownership of the value on error.
+            let value = unsafe { T::from_foreign(new) };
+            StoreError { value, error }
+        })
+    }
+
+    /// Consumes `self` and returns the inner `&mut Guard`.
+    #[inline]
+    pub(crate) fn into_guard(self) -> &'b mut Guard<'a, T> {
+        self.guard
+    }
+}
+
+mod entry;
+
 // SAFETY: `XArray<T>` has no shared mutable state so it is `Send` iff `T` is `Send`.
 unsafe impl<T: ForeignOwnable + Send> Send for XArray<T> {}
 
diff --git a/rust/kernel/xarray/entry.rs b/rust/kernel/xarray/entry.rs
new file mode 100644
index 0000000000000..c6c5385e6b4f9
--- /dev/null
+++ b/rust/kernel/xarray/entry.rs
@@ -0,0 +1,362 @@
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
+    /// let entry = guard.entry(42);
+    /// assert_eq!(entry.is_occupied(), false);
+    /// drop(entry);
+    ///
+    /// guard.store(42, KBox::new(0x1337u32, GFP_ATOMIC)?, GFP_ATOMIC)?;
+    /// let entry = guard.entry(42);
+    /// assert_eq!(entry.is_occupied(), true);
+    ///
+    /// # Ok::<(), kernel::error::Error>(())
+    /// ```
+    #[inline]
+    pub fn is_occupied(&self) -> bool {
+        matches!(self, Entry::Occupied(_))
+    }
+}
+
+/// A view into a vacant entry in an XArray.
+pub struct VacantEntry<'a, 'b, T: ForeignOwnable> {
+    state: XArrayState<&'b mut Guard<'a, T>>,
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
+    /// Consumes the entry and returns a mutable reference to the underlying
+    /// guard.
+    ///
+    /// This releases the slot reservation but retains the lock guard so the
+    /// caller can perform further operations on the array.
+    #[inline]
+    pub fn into_guard(self) -> &'b mut Guard<'a, T> {
+        self.state.into_guard()
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
+    ///     let value = KBox::new(0x1337u32, GFP_ATOMIC)?;
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
+    ///     let value = KBox::new(0x1337u32, GFP_ATOMIC)?;
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
+    #[inline]
+    pub fn index(&self) -> usize {
+        self.state.state.xa_index
+    }
+}
+
+/// A view into an occupied entry in an XArray.
+pub struct OccupiedEntry<'a, 'b, T: ForeignOwnable> {
+    pub(crate) state: XArrayState<&'b mut Guard<'a, T>>,
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
+    /// Consumes the entry and returns a mutable reference to the underlying
+    /// guard.
+    ///
+    /// This releases the borrow on the entry's slot but retains the lock
+    /// guard so the caller can perform further operations on the array.
+    #[inline]
+    pub fn into_guard(self) -> &'b mut Guard<'a, T> {
+        self.state.into_guard()
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
+    /// guard.store(42, KBox::new(0x1337u32, GFP_ATOMIC)?, GFP_ATOMIC)?;
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
+        let ptr = self.state.replace(core::ptr::null_mut());
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
+    /// guard.store(42, KBox::new(0x1337u32, GFP_ATOMIC)?, GFP_ATOMIC)?;
+    ///
+    /// if let Entry::Occupied(entry) = guard.entry(42) {
+    ///     assert_eq!(entry.index(), 42);
+    /// }
+    ///
+    /// # Ok::<(), kernel::error::Error>(())
+    /// ```
+    #[inline]
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
+    /// guard.store(42, KBox::new(0x1337u32, GFP_ATOMIC)?, GFP_ATOMIC)?;
+    ///
+    /// if let Entry::Occupied(mut entry) = guard.entry(42) {
+    ///     let new_value = KBox::new(0x9999u32, GFP_ATOMIC)?;
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
+        let old = self.state.replace(new);
+
+        // SAFETY:
+        // - `old` came from `T::into_foreign`.
+        // - As this method takes `self` by mutable reference, the lifetimes of any
+        //   [`T::Borrowed`] and [`T::BorrowedMut`] we have created must have ended.
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
+    /// guard.store(42, KBox::new(0x1337u32, GFP_ATOMIC)?, GFP_ATOMIC)?;
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
+    /// guard.store(42, KBox::new(100u32, GFP_ATOMIC)?, GFP_ATOMIC)?;
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
+        T: ForeignOwnable<Borrowed<'b> = &'b U, BorrowedMut<'b> = &'b mut U> + 'b,
+        U: 'b,
+    {
+        use core::ops::DerefMut;
+        core::mem::swap(self.deref_mut(), other);
+    }
+}
+
+impl<'a, 'b, T, U> core::ops::Deref for OccupiedEntry<'a, 'b, T>
+where
+    T: ForeignOwnable<Borrowed<'b> = &'b U, BorrowedMut<'b> = &'b mut U> + 'b,
+    U: 'b,
+{
+    type Target = U;
+
+    fn deref(&self) -> &Self::Target {
+        // SAFETY: `ptr` came from `T::into_foreign`.
+        unsafe { T::borrow(self.ptr.as_ptr()) }
+    }
+}
+
+impl<'a, 'b, T, U> core::ops::DerefMut for OccupiedEntry<'a, 'b, T>
+where
+    T: ForeignOwnable<Borrowed<'b> = &'b U, BorrowedMut<'b> = &'b mut U> + 'b,
+    U: 'b,
+{
+    fn deref_mut(&mut self) -> &mut Self::Target {
+        // SAFETY: `ptr` came from `T::into_foreign`.
+        unsafe { T::borrow_mut(self.ptr.as_ptr()) }
+    }
+}

-- 
2.51.2



