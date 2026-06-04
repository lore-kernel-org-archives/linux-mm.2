Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A517CD6E6E
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 20:00:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A1DA86B0098; Thu,  4 Jun 2026 16:00:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F4A66B0099; Thu,  4 Jun 2026 16:00:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 90B596B009B; Thu,  4 Jun 2026 16:00:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7D0916B0098
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 16:00:10 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3C1F140285
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 20:00:10 +0000 (UTC)
X-FDA: 84843296580.17.6007030
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 68C29C001D
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 20:00:08 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=F6a6LUuZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780603208;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ENe2+RbkrnGLbFAMfmpauwPqW9/ZPihu1GWKc3En83U=;
	b=SUy8fsMMBZr/XhIrHcfvXadIIlfpToXOkpZE/A4wkTKT1KDrJN2RC5o4HizdVUlILxVQkh
	CSfDsX1CNxJKb2wUov0tk3s/CfGvZKTia192v9Pk5Uvh6uoo3W2dNgI1ee/PcbqBDzr/J5
	sckwDOdIcoMT0KCyAxxLFfo1S6XSn4M=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=F6a6LUuZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780603208;
	b=TJCpTwW+n5otaoZBWvPr2tXJfcgv9oGW/r1I+G+Qa7obPPp8eFTHD4HKbCEwTnwsMfZYrm
	Q/3RewYzfla3Gom0gygKGFjIE8A7XPCTxW2cF86ScCOKiLj+jsTgC6Tz38gSZBKuOvv3G1
	4SzlOvmW64Y7S4lTkjZyWA8IbHvIrYg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E6F36601F4;
	Thu,  4 Jun 2026 20:00:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBD4A1F00898;
	Thu,  4 Jun 2026 20:00:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780603207;
	bh=ENe2+RbkrnGLbFAMfmpauwPqW9/ZPihu1GWKc3En83U=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=F6a6LUuZ+0uA4IscK29EpyKW8gRosVRCxCRHMd7Mt1uW9slQSDL6S2H39Ldm9qLwP
	 7IAmxzA63lVD3WIkhYhCQuPjZanRSGKyo0aZezcZfSKWnhQxT8oVXaJIXjQs55LoPf
	 B+9LxHjqdSFTbMecw8zrIpdBQbb2X2LWbJGrK/J9RxVDyaUxZ13sqMVIaND9pJ5itb
	 VMVCRx0il+Sn9gsKsp10EdKjjBiXGn726PLL5jN+kNMYFsGBdQa913euX1X5EJXoan
	 1v+eYMzUPVK6sPwLag3hdN+Ifls9mGJYCJMhPwJl27YHumi28OjIEm+xhopWuyQXHa
	 mnWutRkq/oYZw==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Thu, 04 Jun 2026 21:58:13 +0200
Subject: [PATCH v4 07/11] rust: xarray: add entry API
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260604-xarray-entry-send-v4-7-965f6028790e@kernel.org>
References: <20260604-xarray-entry-send-v4-0-965f6028790e@kernel.org>
In-Reply-To: <20260604-xarray-entry-send-v4-0-965f6028790e@kernel.org>
To: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
 Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Benno Lossin <lossin@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
 Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Tamir Duberstein <tamird@kernel.org>, Boqun Feng <boqun@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>, 
 Hao Li <hao.li@linux.dev>, Tamir Duberstein <tamird@kernel.org>, 
 Boqun Feng <boqun@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Harry Yoo <harry@kernel.org>
Cc: Daniel Gomez <da.gomez@kernel.org>, rust-for-linux@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 Andreas Hindborg <a.hindborg@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=22322;
 i=a.hindborg@kernel.org; h=from:subject:message-id;
 bh=nlvjywsgkgwKWYwmhZEaELFYOvxdO57Snukucz2qinw=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBqIdjwnrGRdAGGtUGeZ9sdbYVzKA6crQiwDMufW
 SjZm0k1NeeJAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCaiHY8AAKCRD6UCkIqsW9
 0AkTEACMpaYXBU4br85iiZ2DCHt3qwwPV4t9RoZdnqiKrdQNH8DH2W7F5AUdTt0DaNGLLQXZSrN
 6eBYB7xHG3UsWSIEe9jcr9IZjRvPIEa82EbRfy7jB4DYXwKy2Sjm2TXqHR5BSVOUM2Y4Ybb5O/d
 Telr9uHs3oz9BR1XXDc0lnOeF4Np4DkFP843AUY0HZ2dLWDvTGoMAcrN4lc3WYT5iASf521VbAZ
 03qXpt6OoHOIJ5pYpp3jBurvjfSRx5AJFti78bingHYBx09KRxqqLygCYROw384r2DHHEH/C2wu
 cra3mzNx4QVqCFXIRWjHAjSHIuwH+nYDgpTHmU8O6AzazYDZCNaOj9YJ4j3m2HAwVHtD8x91PFw
 DK7iwquwS6uNjq1I0otFGt2vkxdZxQHICZ4kSnYGJRJrrxIuHv9GhPVxfHNab3yp3PFtbnu5Wiz
 4h9UoMRMDwJuuY9A1LOiyNuO6zOQndYQP+9dsCSuoIUwsi/cqnJofOs6ZwRPXKFjo0Yw9LL20nn
 cCm9HA+tQ+MmXJyE/3PVg7mphoyE2uFtmpeEINysjxc7L6vdkRTwDcxtNRLnpye/n1QE+N+qy8R
 ISvMxcJnsSOlFNJ9gLH9Guwi90js4FM9DBzmGgX7ekKkYtFbhSY50x/XP5Sv+FqLYO/KvzqPnGa
 cnPmvw53r9xcw6g==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: 3zaq1x5oew6dpbbgcfjjkkfk7k9cbhbe
X-Rspamd-Queue-Id: 68C29C001D
X-HE-Tag: 1780603208-644113
X-HE-Meta: U2FsdGVkX1+KaAxUv2u+AbArIDeC6owdrTDZE1tCr1PH9YFE8dc7od4a1qW3CJWKl2zv+ZUHfchxUElhM+l0v5eHDCGmr3bcKQoiP0axiCC1bHq5YD5CHxkqWVvOOVrbbttSckQydyPlJ6fHg7uP0y9u+1swdYUQ903+k/venb87dA7fMe9yerrfVLGiMHTDSsnWvcKR3X6dLZ+clYlS9mOrLhZcnAvci3Iy0Qy+KCw5w+y4h4DFokATv1O0Exyu1lX/saoT7rmT47L9ptXoG/U4id+QgHZAXFyDnuOzzt9dFtIXlzS9LH3aJRF/L1ZzQV8+zqCbDDS0jYM0YZSslLWRXhPViFZqVeS9ahGi+yaQjx9x6cu+0kp5TaMcNtPYRPHmMDhl0xkOWWeDX+cIRkih7TakSBtFdFIboe63kT6ml9Oim8CVZ1EXco8xR/6QooaxXjMYXwJTdb3aUgYq2Tw2TZ0+4BVfkbQ0Qb5FygZkXiYtPnWtFvKs58WOOZGXtyfkAnJkAMcrYMqI+Ih2JGqyttvDIDlFmUOwFXptPLAOIUux31QPc6Qf51A0ONuat8N43ZtNw+bftTAr9dN+yrO75Q6uEv7kp1e3tLZv7mb+ELa7opCpZrzerkZ2ZCfoG5jUBsMfzWG/t14TxaW1KxMGza/opnqlDIuIWDgT9JnXAqhfbAghQjz25hXgrtbntRvsee3Kz5redWaLCxGQXnuB5sMV19qJZ6xRZaBYsMhEKRe+p98rxUGEzoFA+K7d3yrQsY+iKrCUjBz8h+98HhCzqKk/X7QY8h9yUJLsptmE29i10JxaZff2Uh02OtsFLAezANI8jDubAU4+us6foccZc4Q4ZAmHVbZBaRFLg81BXEJMptZlUC+X8Psqg+wCrjYYWIHi43PJaQ9oKJQVblJkVx9L7HTHiawMVU+uea4/i7KeCvc+UFojgZtLf9iTXG/nHLOJBivvxwJrvhK
 ALZIvvP7
 rHcPP3Dqj78lvC8wDciY68UCquDwKXXAOpkTXmbMWIH62XS9q3Xj/pjI2QRzDJMgxrmC3p8QsewNJZmyHdKh/IxefL+45tEorB4Zl15unF3bz+mxG4NTBmgcSE+69ofhXsPc60vtD7JowhdzNlwpCit4jdUIiysFFOm2Hz+eb2soBtSxpYe3ad1cEERenPZE7Gy5dP8yrmI9eES11PGFXBhCNaju7ziTzIqACCSennTnSKmZpYUXDxLXPGkUlEfjI46mrOEDBH453mym0gzIV5jRmqATCt4hPWlsqceEP/e8wTBRQj+50OQcnEGYPoLuXs0RRMkRSa3x+iYu/08KhiAhv7D7+ofBF6IMiuWVD+IvMrBt26MNWLUwUbDc4ocdShxQzQ+kFRosCwwkgMF7UBcJG9JYz63GgyT5LyykWKGNxEczMs5/HCBj5Xo3duQ0jq3HwW6b3mPFAhjo=
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
 rust/kernel/xarray.rs       | 131 +++++++++++++++
 rust/kernel/xarray/entry.rs | 385 ++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 534 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 882214b0e7db..8bc0f7d95dce 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -28984,6 +28984,7 @@ B:	https://github.com/Rust-for-Linux/linux/issues
 C:	https://rust-for-linux.zulipchat.com
 T:	git https://github.com/Rust-for-Linux/linux.git xarray-next
 F:	rust/kernel/xarray.rs
+F:	rust/kernel/xarray/
 
 XBOX DVD IR REMOTE
 M:	Benjamin Valentin <benpicco@googlemail.com>
diff --git a/rust/helpers/xarray.c b/rust/helpers/xarray.c
index 08979b304341..19fce6862c78 100644
--- a/rust/helpers/xarray.c
+++ b/rust/helpers/xarray.c
@@ -26,3 +26,20 @@ __rust_helper void rust_helper_xa_unlock(struct xarray *xa)
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
index 7efa8a36d559..f6d5e5908c8b 100644
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
@@ -231,6 +237,35 @@ pub fn get_mut(&mut self, index: usize) -> Option<T::BorrowedMut<'_>> {
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
         XArrayState::new(self, index).load_next()
     }
@@ -292,6 +327,72 @@ pub fn find_next_mut(&mut self, index: usize) -> Option<(usize, T::BorrowedMut<'
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
+        // SAFETY: `state.state` is a valid `xa_state` by the type invariant of `XArrayState`. By
+        // the same invariant, `state.state.xa` aliases the xarray reachable through `state.guard`,
+        // whose lock we hold.
+        let ptr = NonNull::new(unsafe { bindings::xas_find(&mut state.state, usize::MAX) })
+            .or_else(|| {
+                state.state.xa_node = bindings::XAS_RESTART as *mut bindings::xa_node;
+                state.state.xa_index = 0;
+                // SAFETY: As above.
+                NonNull::new(unsafe { bindings::xas_find(&mut state.state, index) })
+            })?;
+
+        Some(OccupiedEntry { state, ptr })
+    }
+
     /// Removes and returns the element at the given index.
     pub fn remove(&mut self, index: usize) -> Option<T> {
         // SAFETY:
@@ -429,8 +530,38 @@ fn load_next(&mut self) -> Option<(usize, NonNull<c_void>)> {
         let ptr = unsafe { bindings::xas_find(&raw mut self.state, usize::MAX) };
         NonNull::new(ptr).map(|ptr| (self.state.xa_index, ptr))
     }
+
+    fn status(&self) -> Result {
+        // SAFETY: `self.state` is a valid `xa_state` by the type invariant.
+        to_result(unsafe { bindings::xas_error(&self.state) })
+    }
+
+    fn insert(&mut self, value: R::Value) -> Result<*mut c_void, StoreError<R::Value>> {
+        let new = R::Value::into_foreign(value).cast();
+
+        // SAFETY: `self.state` is a valid `xa_state` by the type invariant. By the same
+        // invariant, `self.state.xa` aliases the xarray reachable through `self.guard`,
+        // whose lock we hold. `new` came from `R::Value::into_foreign`.
+        unsafe { bindings::xas_store(&mut self.state, new) };
+
+        self.status().map(|()| new).map_err(|error| {
+            // SAFETY: `new` came from `R::Value::into_foreign` and `xas_store` does not take
+            // ownership of the value on error.
+            let value = unsafe { R::Value::from_foreign(new) };
+            StoreError { value, error }
+        })
+    }
 }
 
+impl<'a, 'b, T: ForeignOwnable> XArrayState<&'b mut Guard<'a, T>> {
+    /// Consumes `self` and returns the inner `&mut Guard`.
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
index 000000000000..5ad79a499156
--- /dev/null
+++ b/rust/kernel/xarray/entry.rs
@@ -0,0 +1,385 @@
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
+    /// guard.store(42, KBox::new(0x1337u32, GFP_ATOMIC)?, GFP_ATOMIC)?;
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
+    /// guard.store(42, KBox::new(0x1337u32, GFP_ATOMIC)?, GFP_ATOMIC)?;
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



