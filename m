Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2050360A5BD5
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 13:12:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EoPDHkK3
Received: by kanga.kvack.org (Postfix)
	id 4C4426B05C2; Fri, 20 Nov 2026 08:12:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 49BC46B05C3; Fri, 20 Nov 2026 08:12:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B1806B05C4; Fri, 20 Nov 2026 08:12:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 104356B05C2
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 08:12:15 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 924C0A0E7A
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 13:12:14 +0000 (UTC)
X-FDA: 85455535788.13.DFD5803
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id C623412000A
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 13:12:12 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EoPDHkK3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795180332;
	b=KnFPcCSOhhvgwycz5EUktHA8vhb2W5Q2cIEdHGPCQKz39mQt5OnecpsHKnB93df2jk39Jz
	dItpd1AcHRPj0HBn6aeelTLYCKJjVoyNK14TYFTZMWaWkgjV9wKMKQqF1A/uJM4I8+ZMkw
	1cdXZHTsDaguV0iikqbFoe80CZ+mRcE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795180332;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kAHOztSuLEPGTBW9MwTBM7VLtWlAu9cVF9tnWYRfzAg=;
	b=fa5rxwg51OqtPyg/DvgPIv8kpH0SnfBsufrHzQgj87LJbWkSm4KLst2EW/1QypVYRIE2uc
	8OR7I2EXegnweLkq+Mof2qsC6NfTqQP+/bnAO374AkPyRBIC4jxYJG+YVjFN83aWZTiLhn
	lC/hFUPWgQKcpnuhplVseRi+WuplA5I=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EoPDHkK3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1C10E62C0B;
	Fri, 20 Nov 2026 13:12:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 920531F01566;
	Fri, 20 Nov 2026 13:12:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795180331;
	bh=kAHOztSuLEPGTBW9MwTBM7VLtWlAu9cVF9tnWYRfzAg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=EoPDHkK3rLz3pWVOQLqQId6JgQl15pj28DlZ7c4s2M55GalSfAb0YSaSnhVh0Jt1c
	 7pKZYhSyGFUFHUNoLrBAXb7n8ILOQnlrTYc0/Wa7ZdWmyRZegagBx2B3VZjjLE8MGL
	 9tLclhS3wMQLIPkXs735242gOEaMsRUydRtfKDdAXf4hNyqedg4yWgCH0+4HGDuLiM
	 tPPtedpHmloAsHzChbqnoAzj3uMWg3Bs5KOKhnt0XrDaQ59PKO2XoVN3GeVdlISFcw
	 /yCxvoFy6wt3ZT5zpUtXv7Luv3gb/kLePgm1BK1kv9Hq9TssJSovxhrhEKDSFAiKa2
	 XshgUABNHkCPg==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Fri, 20 Nov 2026 14:10:18 +0100
Subject: [PATCH v6 07/12] rust: xarray: add entry API
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261120-xarray-entry-send-v6-7-1f69d7385f70@kernel.org>
References: <20261120-xarray-entry-send-v6-0-1f69d7385f70@kernel.org>
In-Reply-To: <20261120-xarray-entry-send-v6-0-1f69d7385f70@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=25345;
 i=a.hindborg@kernel.org; h=from:subject:message-id;
 bh=HnDr8kHwYtdAlkHoe9+Q48ys+wkFQSeHQ/dTCyc/Hy8=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBrAEbJYJGdYsoayL9XiVABSukC8bepTTOJU1RkL
 uvgHBCYj5aJAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCawBGyQAKCRD6UCkIqsW9
 0IbUD/0cNk+gWGXhJJATPKEy60AolIF4cg9kTyaJB898Ax5mBpsNc89xRYRzbAHaL8MeKwPG0sO
 L85jSgpRw6421FTL0dutwXTHZbhzrtuGFkDY7yF2ymzHMYpS46VFg/T5w/eGxQ3hDJN/ZjM+dW+
 taVx9PUNAeeVsUTBFaNv4iXeCIJEDgSa/+n291edVHTDJRMMf20fTHirCYRaYcopZLHFeJVNgc7
 ARu63OK7UhH0A4wTvELJzq2g9XVx2baEV7EC3Gy0hJ8hDEclM4WWtD/0J3AAItU0CihcUg4Poe7
 H08N4fpsXKvN7eKm+gM0hiC9NUDADz+LwCezpHL7HlxBq19TWH2BynuAO8R/QZ/8Nb/Iv9c06kK
 SY2LBTZ2vnPkViSi5p+KTJ3ODzqUMUGhHcyNUgtWpSMz79RVr9u4mcQx0jg6IyWn5j6ApNaBwtH
 A9irc/vEEvMkGLloTZ+lQxMZd6JptI+2GnJmvjtv03x+6pvZbw8Vvj5YRJK4bHMMBEtuk2mNwfb
 h6T7v/RCDE1BK42AVl5FIqVCWa8snc2iIaT17o9trij34VRBygU97huQAhpItUwL2ltU8gVBKtG
 PZ8QCxk31ydtJcG8byNceWy2EGHe68TuNxXRnwu0aRqAVDJx0wDpHVQRoOAFvzMJ+6CU4SJYifs
 89ZKUJ37/hYSAww==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C623412000A
X-Spam-Status: No, score=-23.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 6dcjiunerj8hekdhf1hrnfwj7tmkomdx
X-Rspam-User:
X-HE-Tag: 1795180332-953172
X-HE-Meta: U2FsdGVkX18tPzxoCma9+dSwWIeZeCuq4lfn1sbA0/9EUWo8TsW/5qhdBfKdJdkrBdAb8xPa5uiMJYPPLz6PYxcLlThXbBQthNfl+INgTwXjuutRjetZ4sjzZFhdort44+n3JPhjgZquWJ8dYZVF16q4Ja/Lj9LMqroJIFvCsUlke5G503z7JXlKXXtsUNdI+WSMOjr0Cw5P8CSOde96bWQgmn1AykVRoqyLPvYp2/IEOKcD5qizjfwtz9tb/gmjKVFksNBSvgR0w2tYKP9p3nOauZxfVvi3o9L3gAgUzJIWFzKlrFhyWDOSeso+Ir1/fmmzTcBwo9ChBp0L042KJj3Mni4tK5PKqls7agK9kMWatit8+zrfFLyTc7CvzLaDanSqWG+b1T8mGbNklUxi9OpaVH3KsGSqLN0yQWG/R/7TbM4bL94B7RM/PDCTtLtBMZ7ReJHeLXiffp4DLCv4HC74gPvZlEqNddtlA8yHKL4OEjJ2N2AVuA5sCGkpV58NJJxJZQETno4mbLoMMtmC0DVXmF688Z6OH5cX2eBM2LmC6TfFOf/Xat4KzWx1rACVoHtOB8shBv8+7cEblt0E/oVmliuWUy+efp3AIJvpqWSjgH1EOjUDey2440kgR7gOQ6vocA1ufJYUWu2yW7d3NTooz44ZR7ebHaAdNl2EY1U+C8CTY4X4oRBJqGVQLzxUPfAAXKd7BFiijcMMPknmRfxVlMc5DK+QntwipvtpgyDFOS+dfHI4ZQH1YUXr0kOZ+le/T2fbmT41+bbJRcD921OJwHdLzJQZpq34cfNWIh+ZH1Uo1NXgTOplcQ7AyhYupm7f59Tk/7t8hGJq2rvgg0NYoNSDnxcJscDUlATEwfOum0jKu7hpdnJQOk7AdfQDqgaxX9R40PCozRpJrYhpyKSi0zkSJ8k6RJhceMeX3FSU4NfcMV2MXceUB15vWPggfG1dU5ZD+4AJRrNtHQ3
 Ywik6psQ
 Bvfph7pWAPRhfL3W7g2+HHCfdLBbsrTU5t6b0dlFebYKlFX6L7FEYp/1ZtVQNcCIkv5kAq2gK0xd5HCCy3MpbeZCDeMfn7U+XbEgRl1Z7iBuM46ss7QnfqorGbuYFXC9RZnhX6dY0tTm/tJX54YQwEb+r+lJXuCv/nUDcZQUzBywYDmR/L53QSGbAcSIdEVwktcNS4n0lk5cAhSP+x3Sik6uMb8g7eelkhr68k5gCPxQKcnCluWpmZDL/AHF5lj3hQVyGVsV3V14/XDuKsgPUcN7wMuuxfPgEa3HgHz7n71GmN1g9KI/uAxdZBJajXhgKNjGy3bZpfp1Ylr1fWJ/zRbVbL6MofFEMskT3uFwUbWlb9TNM3t8brZnOUIMytovTha3rZeNcpww+jfSIOirjyHEUflhecO8PouKBsVV9sUYIT1nnQudY8Kz8oEOzgEhmdpmKLiZ5j4VnBF25eQlZEYLbt+R/Rj1n9jEIFChb2FBUhi/m2dX1mKdLFQYFPEUA5C8tltZuEbAtbD6lFH8d422E0C7jV4i2ZIalF/5mTKo58CZ6I23NrXgCxe80U/4CU6BrzZixQFye3NsVtjO6h1J6p/YSYpQTteBb97kzjvFlow1BJJHZS1G4Dhd9etCJTGttX8e59anQK6/bQO9b8TL7f5V1NiQ6kHIi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

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

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 MAINTAINERS                     |   1 +
 rust/bindings/bindings_helper.h |   1 +
 rust/helpers/xarray.c           |  10 ++
 rust/kernel/xarray.rs           | 179 ++++++++++++++++++-
 rust/kernel/xarray/entry.rs     | 369 ++++++++++++++++++++++++++++++++++++++++
 5 files changed, 556 insertions(+), 4 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 222b7fc2c3aa..845503be1f28 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -30500,6 +30500,7 @@ B:	https://github.com/Rust-for-Linux/linux/issues
 C:	https://rust-for-linux.zulipchat.com
 T:	git https://github.com/Rust-for-Linux/linux.git xarray-next
 F:	rust/kernel/xarray.rs
+F:	rust/kernel/xarray/
 
 XBOX DVD IR REMOTE
 M:	Benjamin Valentin <benpicco@googlemail.com>
diff --git a/rust/bindings/bindings_helper.h b/rust/bindings/bindings_helper.h
index 517c5872ad25..dd7c84b1a564 100644
--- a/rust/bindings/bindings_helper.h
+++ b/rust/bindings/bindings_helper.h
@@ -127,6 +127,7 @@ const blk_features_t RUST_CONST_HELPER_BLK_FEAT_ROTATIONAL = BLK_FEAT_ROTATIONAL
 const fop_flags_t RUST_CONST_HELPER_FOP_UNSIGNED_OFFSET = FOP_UNSIGNED_OFFSET;
 
 const xa_mark_t RUST_CONST_HELPER_XA_PRESENT = XA_PRESENT;
+const xa_mark_t RUST_CONST_HELPER_XA_FREE_MARK = XA_FREE_MARK;
 
 const gfp_t RUST_CONST_HELPER_XA_FLAGS_ALLOC = XA_FLAGS_ALLOC;
 const gfp_t RUST_CONST_HELPER_XA_FLAGS_ALLOC1 = XA_FLAGS_ALLOC1;
diff --git a/rust/helpers/xarray.c b/rust/helpers/xarray.c
index 79799c55c3d7..d7548a17ae0d 100644
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
index 07ec08223fbd..3ff94c05a15a 100644
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
     build_assert::build_assert,
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
     #[inline]
     fn load_next(&self, index: usize) -> Option<(usize, NonNull<c_void>)> {
         XArrayState::new(self, index).load_next(usize::MAX)
@@ -315,6 +350,66 @@ pub fn find_next_mut(&mut self, index: usize) -> Option<(usize, T::BorrowedMut<'
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
@@ -390,10 +485,6 @@ pub fn store(
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
@@ -465,8 +556,88 @@ fn load_next(&mut self, max: usize) -> Option<(usize, NonNull<c_void>)> {
             }
         }
     }
+
+    #[inline]
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
+}
+
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
+        build_assert!(
+            T::FOREIGN_ALIGN >= 4,
+            "pointers stored in XArray must be 4-byte aligned"
+        );
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
 }
 
+mod entry;
+
 // SAFETY: `XArray<T>` has no shared mutable state so it is `Send` iff `T` is `Send`.
 unsafe impl<T: ForeignOwnable + Send> Send for XArray<T> {}
 
diff --git a/rust/kernel/xarray/entry.rs b/rust/kernel/xarray/entry.rs
new file mode 100644
index 000000000000..e2f01a49c55e
--- /dev/null
+++ b/rust/kernel/xarray/entry.rs
@@ -0,0 +1,369 @@
+// SPDX-License-Identifier: GPL-2.0
+
+use super::{
+    Guard,
+    StoreError,
+    XArrayState, //
+};
+use core::ptr::NonNull;
+use kernel::{
+    build_assert::build_assert,
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
+        build_assert!(
+            T::FOREIGN_ALIGN >= 4,
+            "pointers stored in XArray must be 4-byte aligned"
+        );
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
+    #[inline]
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
+    #[inline]
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
+    #[inline]
+    fn deref_mut(&mut self) -> &mut Self::Target {
+        // SAFETY: `ptr` came from `T::into_foreign`.
+        unsafe { T::borrow_mut(self.ptr.as_ptr()) }
+    }
+}

-- 
2.54.0



