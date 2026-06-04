Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 733A5CD6E75
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 19:59:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC56A6B008A; Thu,  4 Jun 2026 15:59:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D75FF6B008C; Thu,  4 Jun 2026 15:59:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB39A6B0092; Thu,  4 Jun 2026 15:59:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BCE2F6B008A
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 15:59:44 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 808F612020A
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 19:59:44 +0000 (UTC)
X-FDA: 84843295488.15.7A43E62
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id CD0D240008
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 19:59:42 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VlfIx0wC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780603182;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lMIuC5KfuikN+IJdOVRU49vpMgSH5gGglwhQwCzLUFg=;
	b=6PF+iWjGOsJvXyl7fX3FC4mL4cR20hhsqJCuR3BovNTkDzuVzAHHKAVNSQej49v7pnJOj/
	4UtZN2PlLoFgU01fMI3Aenzvo9Ooi2HwwXwQm09dJCELkfgFuGchPPjbXwUPQi0LoK1Nlc
	V6pPRE0PKYpCUCY1E9X3WCnUupm5qgc=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VlfIx0wC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780603182;
	b=haMcnYiFaO1FCY38BKmX2RsXeyz9jQJ1C1RP5rBL95jLtaO/q7ybe8jFk8IvdEJbmGGYta
	1NBh0IwfyVkLzqkKasywCXUGsrvdNO+m6GfLTIVJsYaU0u0fRfmKxtiDWnt23QZrgIylXI
	+FJ7QsoePy+xelO/1tkf5eQVe44F+0M=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6B57360145;
	Thu,  4 Jun 2026 19:59:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BA0B1F00899;
	Thu,  4 Jun 2026 19:59:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780603182;
	bh=lMIuC5KfuikN+IJdOVRU49vpMgSH5gGglwhQwCzLUFg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=VlfIx0wCRHD2Ke7Wsiv7XSdTrg7Sa6HU7/t+c4g9REs5Qyr8LXkV1krikhS7ObdhM
	 MT7MIlG0zpL4Cmc+xNe6rDPuWF4UlNx5eaNi5sOdPHBfR/PIRAzYyL0vJpTBd6uy1X
	 yBYGIj27ZhHe6qlNfb7Jm3seZDil7qIYkKUDWKuXrQInSCm8peHVNDaaJ6kuhEDhS5
	 NBXCRaCL7WiqPRSsMqQFd9aKMB8y5hWggLRNM5axIXqzL1IDqEtEogZXIeTKSFf7eF
	 ZnGDMcnbQSfND7TL5brTrBWJRHtP5Z0rRkwzCyRdyNPeaPbEpK/9lN6ocFbOqq9oUJ
	 IbTSb3kDkapsA==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Thu, 04 Jun 2026 21:58:12 +0200
Subject: [PATCH v4 06/11] rust: xarray: add `find_next` and `find_next_mut`
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260604-xarray-entry-send-v4-6-965f6028790e@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=4101; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=pYvfABtxRJd+65+UwL/yf+feoNbyxJANq7/Ip719Xh8=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBqIdjvzVaY77frrnGM8IY/dUfo7TEJOl6r6lp4/
 8ZNkt95LtKJAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCaiHY7wAKCRD6UCkIqsW9
 0DctEACTBcYdYrPHXcRAgJacN+h2yee/0JerT2FT+RLQY6DC9bEhyT3fD46b3iRQu/jCAWa675Z
 d6HKR93TpZvIJv8QQHAIb92hONgHK2s5uJsOYAc9P4Qvzs9K/IVUiM0KXvgJNhX5GFyb4TDv1jO
 2smQMdyVMEttC72eLIBDHHpRWSwtXuPTxdU7cv0SBIZN+AE34de28/CINYQt5++uW2UOHytaNi1
 H7RPytogVxfYyRFbJdMd7AMIMBNc616llsluuWsFi3B07RVLNEBZAQEqWOvzC4jV2IWO5TuoO48
 N2cydn6UwqftBqgsNMRSGWXHAlbnbQvFLIOJnk4alxO2BsUZ21HIk5moH06xAo9XUpsUxrzcFI6
 Ed2Vld+ARN11CNYw7quDe8PGtzA66RjkHis+U3sDssztBD4Da32BwiKy6Yigs/hshoPfqAWQPFb
 Q1T07XK7mKWe0a9kKFEBtXQRGWk3BnZNZy51FIgR8eSxtM86GNA9NyBAkTZyGOdMFG/JL+2OKov
 a0s8LpZa+rfWKhROBR8RDm/Adm7j/fW+jUuDbR2YCYpcwQiduU0e6KSPdZ9yBbzmNVfXTXjFKEp
 W9scryc9F1sDDOw0MxkqiuhmCNYvL1Yz0jX13YZJl1r6Xl+Qyn7pgHdTjJEhS8xvsWp3zec5asx
 PQ6xLhqf8mPLl7w==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: CD0D240008
X-Stat-Signature: nwjjw1puc3awrzgkxrm4bonj3pear647
X-Rspam-User: 
X-HE-Tag: 1780603182-396286
X-HE-Meta: U2FsdGVkX1/1LoSbIFRKfTMAFRaEe2eK+XiwD10uMmhSwCABDj9SHFn8p9TS4F3BInWVliRupKGIpHK/VVziKCzye1ndBuzAXappw4JgCWl3+TLXIbfHgObX2YjtOG1aaFipHHtJbPFZ8snGdvw/+xZC4XLFP+wJOR+eAevEK1MRXUDsumVavmMP14L7hdBphmMUip1hjEr5hLUYXvZh6l7oAK+B8/x+sOGAEMafH8HJ1qrsknKOWWQjpjFgnElDlVkXQ+uJDlXJjJEgYTkMG67U2JzkmH+9QeFnZSBDi4Vkv9qQdjH1l6tZGoG3y5xBJTYC8MJbMPtBocWE0If95d9Aoml1OfsnbiF28ZbT/KEZVtIJmN06b2t76s0zgCsLNXaAIGnzECX46CH485FlaOGYodO6rEsytxY963XqJFyo62Bfl1qNmFabzU+F62V/5g1zCX2tUNReAU8Ln824Hwv0TODT/VZk4E0et8vmmVbT4Xqp5UutjL3yrv3c2NxgJshIKfsv9SPU2ruqQnfpu+HC2GE2PNLlz7oAg50BVyFpdQOuJBfS/afyVTWO/Pftk7Sxlg8t5Frfw3oRqyBnVXU7PB7jDE8Z8fc1XTQJhr/mDJARF2qkyQDyhETc7J/qDAN6BiaEeAyOFA8g4jH7zlllDo1mo4cyT7jNA+RODu76udbRzsJ4YuS6dR1Uwd5NPDRVqvOwEQXAyfcH1s6nFsxBnorShOBeeXx//77mlcQ6RMt/XeN54lSRDUBSUA6sIJ6MCkdI8g3jtVZ5dX4pGd+tTtU7FK+31zDUdYBk3m+Dwj+yLdeE2hZM+Y6+wWUPn1LlD/k1ZdF4pQGMHIJD/JfQsXHzVplRJuZnwU4vIbojbh5IRuZqHdbIW4Vjc9r+Y81oMO8deczaXdQG6vnz3qLtess6eKjozsWkiiBht1McWfEL7Ue97X4H4k3IW8ONjW8E0vG31q9WBhE/QtU
 PfaHKQqK
 HTzRHYtIVI1AlVqZLA3oGUjcGODLNsgxKAGKEoIK5RRMxTSjxyLOyZrlmlp0znY8bgMeCGDQXryHVydTk5CEj7/9qXM677Iq7EKaBvUXq2tXIjtgYBFN+eMkhe5QVFn2qQa5CPebHFjFVLWhA8qebD3n1KMjUX4/vRw2oyWExwRxcENIdcAd9hMzJvoBYywOyaMvJ0tD+JWEMrDdUb+ZXz5gz0Jheq35i/87pSNLH3q/QdFG0zMnIZt9Dg93hxuYYmCIx3kZqW9EbN3N+0we+XfxgMm/puL3nsE3nyJR62USNkA8k+NyOQxs4Z/gSXk2PKP5uCamGc+kOywDo8QRlekPIucCJRdA6H4rCLr6jlJHKsl4=
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
 rust/kernel/xarray.rs | 69 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 69 insertions(+)

diff --git a/rust/kernel/xarray.rs b/rust/kernel/xarray.rs
index 7da57c778669..7efa8a36d559 100644
--- a/rust/kernel/xarray.rs
+++ b/rust/kernel/xarray.rs
@@ -231,6 +231,67 @@ pub fn get_mut(&mut self, index: usize) -> Option<T::BorrowedMut<'_>> {
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
+    pub fn find_next_mut(&mut self, index: usize) -> Option<(usize, T::BorrowedMut<'_>)> {
+        self.load_next(index)
+            // SAFETY: `ptr` came from `T::into_foreign`.
+            .map(move |(index, ptr)| (index, unsafe { T::borrow_mut(ptr.as_ptr()) }))
+    }
+
     /// Removes and returns the element at the given index.
     pub fn remove(&mut self, index: usize) -> Option<T> {
         // SAFETY:
@@ -360,6 +421,14 @@ fn load(&mut self) -> Option<NonNull<c_void>> {
         let ptr = unsafe { bindings::xas_load(&raw mut self.state) };
         NonNull::new(ptr.cast())
     }
+
+    fn load_next(&mut self) -> Option<(usize, NonNull<c_void>)> {
+        // SAFETY: `self.state` is a valid `xa_state` by the type invariant. By the same
+        // invariant, `self.state.xa` aliases the xarray reachable through `self.guard`, whose
+        // lock we hold.
+        let ptr = unsafe { bindings::xas_find(&raw mut self.state, usize::MAX) };
+        NonNull::new(ptr).map(|ptr| (self.state.xa_index, ptr))
+    }
 }
 
 // SAFETY: `XArray<T>` has no shared mutable state so it is `Send` iff `T` is `Send`.

-- 
2.51.2



