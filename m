Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D74860A3808
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 13:11:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lyy+di5v
Received: by kanga.kvack.org (Postfix)
	id 5602B6B05BC; Fri, 20 Nov 2026 08:11:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5378E6B05BD; Fri, 20 Nov 2026 08:11:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 44D556B05BE; Fri, 20 Nov 2026 08:11:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2318F6B05BC
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 08:11:55 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7E45E1A0E44
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 13:11:54 +0000 (UTC)
X-FDA: 85455534948.07.DB1477B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id B761214000C
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 13:11:52 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lyy+di5v;
	spf=pass (imf23.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795180312;
	b=opUEtO1MV9Mv1PitqzfeA34ooLd/MzcGpokv0bwCbbMTc/pFLIE+T3E8VuVjw90iWjK0al
	uVLXikUJ1xY2dyFplG5Y9mHv5dg8+NLR4XWKhVqfIY1QXpf5oFZ5m3XzK1zNiItXmSVn4E
	5vQsaHE2MwFcErZkN1Iq/BeqUVPWYpc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795180312;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gqLfJsppzt0bobg6k5RSzGuyBhJDJxtFjMmDgLlOsEI=;
	b=N+6RkDzBAKk9mSSyY3QlcNxcwgNWJgz9dQFnUBdE6L17r7vdso1FbRBIBAwDCnkAwPQTZV
	JDyNbiZCwuoQgM7zapr/ND4j94UtxtU80sVjfL3edOc7gFwEAsFN2OyDyxeWKtMtoa+74v
	YZWGbMf+0e79kXaIoFBdGWiu/Pbg1Ts=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lyy+di5v;
	spf=pass (imf23.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1ADCB410EE;
	Fri, 20 Nov 2026 13:11:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4206A1F01569;
	Fri, 20 Nov 2026 13:11:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795180311;
	bh=gqLfJsppzt0bobg6k5RSzGuyBhJDJxtFjMmDgLlOsEI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=lyy+di5vtOR4obXghB110cGopjnUbxlBWNX0db+usG4+43Nnm6/AntuujrvZb1PU7
	 csvsuwR6rB1XFCwRAA1KJwEvtcAo4HKEXyS8kYeRmc+SGdHST5oBrMi7OhZJz4UXs7
	 9JLhBh4Eokris3PlyVn5ylrm4+1UoVLe0ymzEYhszY6w1kLmx35Uw5MFI8jqU1Ma24
	 G7i4MFr9lO/EfLva+3pJyVNJzTvDmWd5mQ6Ryf5WIPNBo1OVlu4+6H60VVk6jhXaDP
	 LOYqn4nEYpl61LpLYXiuA4F9TR/P8zwXOe/3+c/650C1JFEHqx99RR93bbli6Uy8m7
	 JZhx6bl8AG3fQ==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Fri, 20 Nov 2026 14:10:17 +0100
Subject: [PATCH v6 06/12] rust: xarray: add `find_next` and `find_next_mut`
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261120-xarray-entry-send-v6-6-1f69d7385f70@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=5968; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=jINgMPg5g4/dlMBkBia86AcDidALlNNcvPEg68+PUEY=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBrAEbIreNmBUJDVCCTeQ2qKfoguy2Vd5fGVmND7
 KeQW99mI9+JAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCawBGyAAKCRD6UCkIqsW9
 0GphD/9wAEux9+T6rbwFt41YJn+QmcqhYxU+IWcqcmMpat5/xm3Ss9HxTEv4jxWSVP1Bs2Bs6BD
 hS0lPQ3lIBy3MSKHacKEKXr2OGN1BIXqPbS2zovlkYZgqoAQ5+wELbjsObGGQPGBxK6FYGGdyYU
 RLflm0W+tCeRjroKOqIdXAJyI6CMCOMLiIn0qPP2BUlvKQLPxUWr1tk/yWc7OUKXlp30XgKN4w8
 jvEY4pb7aXlOw+oMEDmG8RPSiPfnM4+zuqc7KNRK2rP2sv5dZV941FdxhaavxfounsbIWBmmrk1
 NvSTNO+EwCl3SliLw3NS5stMNrcgN9ln8NZdn9L7Ta8ejwscsnqBpSwzBc9IUnJxncYlf8Oj4Jv
 occWNsqWXMcP9wfXwKGP3yw/JFE3lf7sAKDZrndkc2NMNfKBxxowMg+70hZ2SS1MG/96Dy8oV7f
 AUP9K+/JNBiknVEeAiNhmFDPMBy8prckR9zvX65VRTzrrms4M+hUHDFGQ8aWY5ogYioQSoSOjpH
 HTrRS5+tX2eyed+jNumfGuhu82dD5LlzzQgk2GggikA4j0lbsP7Tn+1xMhJYv0VoMhjh+dOji38
 NTLtRhWvrGm+6NN5xu05Y4TiDJLGK3gogv+AO+wTfxZZ5Wz+btYf0uWGwl10R8s3+kfLaGrbtmf
 YHxM8/rxewp64/g==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: B761214000C
X-Rspam-User:
X-Stat-Signature: 7y4i3ehpjftjaq88kyeydz5s71wy1a4u
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795180312-183634
X-HE-Meta: U2FsdGVkX1+UpIVo7SP0AEqgLIfxmEsT/Ow9s5onRBNSWK1HBc580ysffFkSo2H+LX13SKjyhVFk+n4TciwngzjoLVtGqq8eSTMkvG6d7ayVfY1VSHwuWQlQLiscfkV8JpBZ/rOijrpYUPN9TKdEfCxtY/3QLw816S9QOIA9wgDCfW61QWBFs0ogd67zY6NeE1a34V+cmv6s1ZT0/9scHv5grDwbHqNarFSHousQOXItjuOfyyYDDxfqM/EyFyN8cljXlECGoiciFLE6rm70b7SFsXaZHJmr+A+91og5S4YU7hHa55P8Hg3/RDSu/AbdVAOXR/s8oy1j8JL5SSmz6r+bknLj+mRBniWvLfenPOQ/+47+TRWYw4B8Noy0QnDoSiAfQENx5yt8SxET2W/pK+KzchIwz2i6UXhNBSowtz4PfrSvxe6PHYUuuKH5zDYkEosIgHdPl50SXC5ZAwG9kz0I3Fxu80EHaB8af6259lziP6qtVgTAjZ9nrZOCUuZ5WVKK2lnbBXNVTirrmZlIcj9d9ONHV+QENdST5wh1GcAYFdPpetmEF9tyyfHSUG49KvwKprZEe1I0jjR6JUZvE28QG4Npyundsij0TCuUHrKwWMwOHNG4kgmD3uLerqZjkG8O8cyZv6+xTp0h8LtbkkS76Bp2oi2VDgU8TTGP1JAnAurSVd3+JZl5wMxeN1tSYrj8O0PzkSFy39TmQzcJVLMynsvU7H8sbxxQPeRngDG3NrFl0FZ7SW51mrR/qSRbH4jSbV5qXDXcq8XAriATk9iXA97lR2gv2+HgkBwhNSvR1suVZjCWdmuvIb0TTZpDdjoYmJxBP//UxlkzK1uumQYct3SV7Yqxoo5dl2iUXDC2cvHDDOSvAwzkQf2SlD91rkPoa6f8HuJlWM9rFz5uyNBJ1C9wmbOlvY9IY9C3oHk6Vf5k0ACnyyrFhA8DYqNddx7EciwBSukWgE8mc/v
 pg231VWR
 114VZdDWqLhtxOrIV41tOhX24YMr/VN6ajkYR/EQBBfi0ddk+IEIc75NJEx/Ol2FDc7r5wgCMwSb9NoN4XFQXB/5DPV4lwTIcw5bem161pClSSnvSsys5JEcOm0LZ8xbfbHu+sCkMbMWLVo5VXvzdBYtFidiXGfuLxxgD6JHQAaSsrOsqM1MRI0C5/qEsqd/TdZSnfWNbazpjDT7kRzHEMLRTGlPowc1BIOwFN1raBIfR0VECA0nyIimsFwQxWRd2bdyR2LhKRw8jtoKRQc1qUxYDvIL9LEkIgFZqZC7VqbeSPiyREO2pC7azo8b3FzysDD0uyKq5WJhqcriSeBxl3pslXLiJjuo08qQ03dPtUY+ZqtPYcgZeMTgrxFJVw590+9ibKnmlzAJHmU+ukOK12jSmgi3HoZeefdMkNTWDcdiDdBrxZmsGq8KQ0xsonHOrGcC3IOKlgymQPulOxsmU7JaBr80YvpHUWVmsgtoUqdG/7YVInoIhT4CbGBj6MctZhOlQh9sHlO2ma38=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Add methods to find the next element in an XArray starting from a
given index. The methods return a tuple containing the index where the
element was found and a reference to the element.

The implementation uses the XArray state API via `xas_find` to avoid taking
the rcu lock as an exclusive lock is already held by `Guard`.

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 rust/kernel/xarray.rs | 104 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 104 insertions(+)

diff --git a/rust/kernel/xarray.rs b/rust/kernel/xarray.rs
index 94386678ef81..07ec08223fbd 100644
--- a/rust/kernel/xarray.rs
+++ b/rust/kernel/xarray.rs
@@ -220,6 +220,22 @@ fn load(&self, index: usize) -> Option<NonNull<c_void>> {
     }
 
     /// Provides a reference to the element at the given index.
+    ///
+    /// # Examples
+    ///
+    /// ```
+    /// # use kernel::{prelude::*, xarray::{AllocKind, XArray}};
+    /// let xa = KBox::pin_init(XArray::<KBox<u32>>::new(AllocKind::Alloc1), GFP_KERNEL)?;
+    /// let mut guard = xa.lock();
+    ///
+    /// // Expanding an empty `Alloc1` array stores an internal zero entry at
+    /// // index 0. It must not be visible through the API.
+    /// guard.store(5, KBox::new(0xcafeu32, GFP_ATOMIC)?, GFP_ATOMIC)?;
+    /// assert_eq!(guard.get(0), None);
+    /// assert_eq!(guard.find_next(0).map(|(i, v)| (i, *v)), Some((5, 0xcafe)));
+    ///
+    /// # Ok::<(), kernel::error::Error>(())
+    /// ```
     #[inline]
     pub fn get(&self, index: usize) -> Option<T::Borrowed<'_>> {
         let ptr = self.load(index)?;
@@ -235,6 +251,70 @@ pub fn get_mut(&mut self, index: usize) -> Option<T::BorrowedMut<'_>> {
         Some(unsafe { T::borrow_mut(ptr.as_ptr()) })
     }
 
+    #[inline]
+    fn load_next(&self, index: usize) -> Option<(usize, NonNull<c_void>)> {
+        XArrayState::new(self, index).load_next(usize::MAX)
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
+    /// guard.store(10, KBox::new(10u32, GFP_ATOMIC)?, GFP_ATOMIC)?;
+    /// guard.store(20, KBox::new(20u32, GFP_ATOMIC)?, GFP_ATOMIC)?;
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
+    #[inline]
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
+    /// guard.store(10, KBox::new(10u32, GFP_ATOMIC)?, GFP_ATOMIC)?;
+    /// guard.store(20, KBox::new(20u32, GFP_ATOMIC)?, GFP_ATOMIC)?;
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
+    #[inline]
+    pub fn find_next_mut(&mut self, index: usize) -> Option<(usize, T::BorrowedMut<'_>)> {
+        self.load_next(index)
+            // SAFETY: `ptr` came from `T::into_foreign`.
+            .map(move |(index, ptr)| (index, unsafe { T::borrow_mut(ptr.as_ptr()) }))
+    }
+
     /// Removes and returns the element at the given index.
     pub fn remove(&mut self, index: usize) -> Option<T> {
         // SAFETY:
@@ -361,6 +441,30 @@ fn load(&mut self) -> Option<NonNull<c_void>> {
         // SAFETY: `xa_zero_to_null` only inspects the value of `ptr`.
         NonNull::new(unsafe { bindings::xa_zero_to_null(ptr) }.cast())
     }
+
+    fn load_next(&mut self, max: usize) -> Option<(usize, NonNull<c_void>)> {
+        loop {
+            // SAFETY: `self.state` is a valid `xa_state` by the type invariant. By the same
+            // invariant, `self.state.xa` aliases the xarray reachable through `self.guard`,
+            // whose lock we hold.
+            let ptr = unsafe { bindings::xas_find(&raw mut self.state, max) };
+            if ptr.is_null() {
+                break None;
+            }
+
+            // Unlike the normal API, `xas_find` does not filter out internal entries. Arrays
+            // created with [`AllocKind::Alloc1`] store `XA_ZERO_ENTRY` at index 0 when they
+            // are expanded from empty. Skip zero entries and continue the search, like the
+            // `xas_retry` loop in `xa_find` does. Retry entries cannot be observed here
+            // because they require concurrent modification of the array, and we hold the
+            // lock.
+            //
+            // SAFETY: `xa_zero_to_null` only inspects the value of `ptr`.
+            if let Some(ptr) = NonNull::new(unsafe { bindings::xa_zero_to_null(ptr) }) {
+                break Some((self.state.xa_index, ptr));
+            }
+        }
+    }
 }
 
 // SAFETY: `XArray<T>` has no shared mutable state so it is `Send` iff `T` is `Send`.

-- 
2.54.0



