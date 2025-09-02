Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2835DCA0FFE
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 08:35:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C558E8E0014; Tue,  2 Sep 2025 04:35:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB76D8E0005; Tue,  2 Sep 2025 04:35:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A09AE8E0014; Tue,  2 Sep 2025 04:35:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8BF208E0005
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 04:35:29 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 423DA11A8D5
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 08:35:29 +0000 (UTC)
X-FDA: 83843651178.28.B2FC9DE
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf20.hostedemail.com (Postfix) with ESMTP id 572401C0002
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 08:35:27 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=b+28OHlO;
	spf=pass (imf20.hostedemail.com: domain of 3Tay2aAkKCMws30uw9Gz3y66y3w.u64305CF-442Dsu2.69y@flex--aliceryhl.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3Tay2aAkKCMws30uw9Gz3y66y3w.u64305CF-442Dsu2.69y@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756802127; a=rsa-sha256;
	cv=none;
	b=xO6Ydz0xJMWEClCH6l1etlcS8I3VOCp5ns6fwVBs+Ty7LtcS4EqNASRacFptrkOS3BbOvE
	csMKx4nDmNxO4e0/9HN5/UvRz6TrJ/sB08r8Nv7n8vJe9L1UVqJ2E4paFAkUxw6yDle3RI
	OBZ2ZgSwt2TlkUtWTYpuL4YozGgnbU4=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=b+28OHlO;
	spf=pass (imf20.hostedemail.com: domain of 3Tay2aAkKCMws30uw9Gz3y66y3w.u64305CF-442Dsu2.69y@flex--aliceryhl.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3Tay2aAkKCMws30uw9Gz3y66y3w.u64305CF-442Dsu2.69y@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756802127;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yU/qze8dnCVYV9LdgeGw8Qx81Z2zaCpIf3GwmuTVni8=;
	b=HcY3LizRI+xdaevHPdUu19szbt3+y0MxzwYxKJf95PsQV4AkSBw8PnBxAPAmBNn2zSdFiX
	yAEfnRK0FCdmO0JTaipEeR4qZ61MbA2mWDfFlHNtuK8KTfyw5DH3TNot7E2MvgkHKNO18k
	F2/6CBY6S0AzFFOBUJfopwmd2f9pG7A=
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-45b9c1b74d0so1005725e9.3
        for <linux-mm@kvack.org>; Tue, 02 Sep 2025 01:35:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756802126; x=1757406926; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=yU/qze8dnCVYV9LdgeGw8Qx81Z2zaCpIf3GwmuTVni8=;
        b=b+28OHlOhq3WDjHDhLxIeyR0q6eGfoCpZGvjBSjH22sfG4p+riwP72Y755OIP4mdX7
         pyY9bEmqQ5eFffjGWzD33VtTQ6xnsLmfQv1fnSf8ayhyIwZ6fqESbfajzeQTEMyiXX/o
         nwa57+XM6+YpQjPLE1eLvjr/ROKwJ70zsu7Mu0DoQhG5IrwJQUKS3m4L7rs+bvkbNU8U
         AFovHpsvKOszdG4FIt2yfClaadJnArdebcbgmr4Cq5WkiAbhqHDyvMRgi+2gzt5b+lef
         yNPT0YSddkH2IE4HtBqFUgW5+B0u9IC18UWpRWyHcqx8iXbJd5Rohl2Uouc9CkS1Qri4
         75Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756802126; x=1757406926;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yU/qze8dnCVYV9LdgeGw8Qx81Z2zaCpIf3GwmuTVni8=;
        b=lFEsEDKIabqjbV6MelaXbIvhC4SfWmPAsPi8G/tfAPg1mRMId95mVZclcApG0SVQTj
         cXUywSLYeG8EIjdhcXi8YRirgFqYF7xumKP4z65mVq8wfEpmIIXK3eMZyULIM4MW7Vz9
         WHcgjseDA/Ln+nybfkrLgQDEfh4bKHjYK3XUvti6AXu8eAfd1nLcxH2C7VXTLLSVfG+4
         gBt7y334s6hqOHGSM4oMhsFEvEA8zAgbAMWahyb2fN1D/HdVJD1eZfr/0DCMEnzIwGYk
         8OAf4rYum5t5SXSx8w4ZNRjeVeEK9nRWAS96ATwJMJo1dWsaaqhaFuVXrevDO8X/eDV8
         DGbA==
X-Forwarded-Encrypted: i=1; AJvYcCVz4sES5i9fL2DKQXeJHM4zGtV4tsDm8NYDYKefAPjvm6OlE3GvCNIe477Zo3iOETjcFIxMgSrxOQ==@kvack.org
X-Gm-Message-State: AOJu0YwFMRBHtpl6IegT7x3seAQuVyxRt6D1uMMmRVSZ6N1bWw94W9ls
	D1OhVVZDSfKCZ4UiJsMKbRNn3UHt9aKkLXUQknxxETPQ1nr3xNWuUyInxVrOQa2sbS0gx0CAzjB
	h5LfwGWoqusJNPlAiWQ==
X-Google-Smtp-Source: AGHT+IF9928G/RDg2POiXYCI34J+xuTtH6eAcRQJR35jKk9M8durBru7tDsICbW5x3aIHL35LsHQddUk2mV3/BQ=
X-Received: from wmbji5.prod.google.com ([2002:a05:600c:a345:b0:45b:6337:ab6b])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:3b10:b0:45b:8f38:8d36 with SMTP id 5b1f17b1804b1-45b8f388f6bmr46148565e9.30.1756802125863;
 Tue, 02 Sep 2025 01:35:25 -0700 (PDT)
Date: Tue, 02 Sep 2025 08:35:12 +0000
In-Reply-To: <20250902-maple-tree-v3-0-fb5c8958fb1e@google.com>
Mime-Version: 1.0
References: <20250902-maple-tree-v3-0-fb5c8958fb1e@google.com>
X-Developer-Key: i=aliceryhl@google.com; a=openpgp; fpr=49F6C1FAA74960F43A5B86A1EE7A392FDE96209F
X-Developer-Signature: v=1; a=openpgp-sha256; l=7291; i=aliceryhl@google.com;
 h=from:subject:message-id; bh=nJ4NJu0LybzY2zkJ2emxxPlNYEf0DKlu/x4dn5/0JEM=;
 b=owEBbQKS/ZANAwAKAQRYvu5YxjlGAcsmYgBotqxKQ+d3ZZgeyrKEU5/GOWnEUUFAc5xT7zm4Q
 O8tyRrg2oKJAjMEAAEKAB0WIQSDkqKUTWQHCvFIvbIEWL7uWMY5RgUCaLasSgAKCRAEWL7uWMY5
 RnkpD/0TBPpWD3MjV+voZaXzEqa7zbKJ9DhcwELxJRxNJcjje1sdHMNeDDMB037HLZ9R5Ov+UK8
 3hPPN4VvrZNLAacgug22uk78Nt8iKt6vyKESlYNMeEcdws0fJBv4EhPPrPhaGDnEENDqUjbyA3r
 5cRrs55j/1zntPUsfEFzxCcQ0j77AqS0Wtsq7WjWotnXreo6Yd9B8BHEM7l5FghQkNY6/9gitZT
 YwtInur31cI9a/NNpWUO08M5J4Ts3LVi6byLc+F0irXsopiYvZLq9AxJ17h6nfncYt73pJ33A5a
 4D7pnAfokEm6lxVXLqumsnqvvMTHtQnKHO7uGW/UP3pl/ME5EdtIhODxEqBE7re0iAGIziZVyf3
 z2oeOzMgNSn2iOb3JkWcOfrojE3d6/2E6ZWLXnpbReqYdwer+P2kczv309G/VTNQXwz2cmz+CTi
 EyAtDplm87xrTkgQKfxksIb7ETtQc0LrwQjR8r82ebxqdhY1A829fibWbHJ8IUIm1OWsAQe1iW3
 5ere3lQc3ZmojOh4JmT3j42X8okZfFhWPh2YcefcAoElVEWqnmRTtzp+WfaqDhrFqOS6aHwkHJc
 0w3t09uagfg7KRhSZodLY32hdckfc5uJJsb8coEUGQkp3sV0oSEj1vG2XFww6+DG4WZKTJhgY7U UKXWhPpsWvXHzUQ==
X-Mailer: b4 0.14.2
Message-ID: <20250902-maple-tree-v3-2-fb5c8958fb1e@google.com>
Subject: [PATCH v3 2/3] rust: maple_tree: add lock guard for maple tree
From: Alice Ryhl <aliceryhl@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Miguel Ojeda <ojeda@kernel.org>, 
	Andrew Ballance <andrewjballance@gmail.com>
Cc: Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	"=?utf-8?q?Bj=C3=B6rn_Roy_Baron?=" <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, linux-kernel@vger.kernel.org, 
	maple-tree@lists.infradead.org, rust-for-linux@vger.kernel.org, 
	linux-mm@kvack.org, Alice Ryhl <aliceryhl@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 572401C0002
X-Stat-Signature: 99cti6o5571k6yfcoyjrxzjeff7sbjjg
X-Rspam-User: 
X-HE-Tag: 1756802127-194606
X-HE-Meta: U2FsdGVkX19st1DPd4jOEoq8ete6LzQDoKOyMQ51RM6pZfnlggz+U5265g51zRLCuDG/Grxu8OfTvROzyuhzncGnvVtt3psJfG33xzgG5FPtXPIzNMnFL9pvclVa4SBqjC4Whr7C61NqMur+NiWt8IoRb8XsruMLVE/KmzkvXRkokdfezsotLItQ2yvwRc7oLlphveZQYVjxQz4fEYWBwokvuKW9G1UoKfDlWLOOg1MUx+wEAVaISYSA8hNggIzfb0VwgNFlklwX6c2PuyT8t0A80+S49iasZuXiQoMbHkDTKclGQ6K0Dig1O4vLxUaL9i3LttAElElRfVUXMM/Vgi36GMV16e4y+EL72lTJln58sZiY+7ZMobQUsFfCWZbKkx2WROAhn6ADzhJoqF0DdUKMGiP4Z6mzIwimIC1Rd45OWl8fhxJLcuawdNZWEJcayyFoLlSSFxijutDTnfAZ7GkaByGpuIimntqFrYKXeRWHZeb42nvOjKFzXPX/24yzujywutsrqbOJPlpodfSzQpFPxdPC75yeDdaXvTbGrH0kljsyfn9kBpuA0Xtn2F+fIX7popWGSozq+Rvd7BIphBXGbTmGPDWJdafR5aDIcdXTS0geJ1rGiGxDoql8KIMEfQu7GU9W5AtRwJwkdIoe0yRlzRC2zgdghVw9aRN6iqIZ1sYFgWkn70BOn2aMdC6iizdQXQRDrs0+KLW1ZMtdBj/cpoB3uQJr095dwMB4RHNhQvCD7isxqeG7CYbRhmc1iIiUDVfcEwuis5ITKOe9Iz81El3lP0fLihR4Y2TZJ9APFPzu/sNQ2oNhHDDxJU/LEZH3ppfMkmz0dLhIC7+rjGRcKn5OTGYmbfWUgaVjFHSlGIO0vFZdSpdadHG/FnQEEtQBE0M7nyO1Bd8Oqc3ddBoX4fJtMXzkf3BUgWnssSOg8ACM2mjJkmKdSG2c6BEwwE1vcV7CTNdppyeRttB
 cIF3axFC
 i5p+IAY22dU3/Z8PoMeW01RR/MYnDNmt5ctmd9j2Rx5kkf9/W0na4PM/79/sxcMgTvjeFJGmKnfB5+6QBFF86MkVzO1FGpgEQqEBXELg7vHcHu1XoNRFOKps27F/iWFTaSJuBQN1ldglmEgy3oZn3T2PSYthrhJalKDs2wQRQ7oXwA98cuR0wJu+OIzJdTUE7yLmfU+GY2n4jPhHjXTpK1+mSjFvRFwhopdzTX9zbYmcHkM1dHdNmDygx90g95mXEAX7kwn93pa25Y3Q3LIrc7iMj9cZqazQ7XbVSpdotyDcSPp2ktR3DxdI+NGFyIeHvXBcJiFb7svsL5qmBzxw+P/k4e4fAC03Y1NxzHOAwSNQ9HO+gHzc+t0HaLm3RJr3iIoyqJvFoHs1ReFTA6kWgdj2DbYLuMWs9rJmKsqXp8bmNIKvvY6ejiQFSMBayFUgf5s9Vxebh1AMlPDjsPnhyt1QqPDMDDpA7nEmpXfdYSs990DDn+Vapo3dEgI76MHSi8xPpre6gQWIjlGZeVQW31n+j7Z3Di+Er79U1jLJh9NMGpvZIL6HAQ/dZWwqC0iK7UTFhD5+543FMdwqfNXpFrKXOIp/BY1gjxjM/KqEown67DG2QhltVa0IlEnQW5WNWhFLSOedLfRbh36U9Jkbxarwd3KxFhmEAKzdS9qXtRwjNftWzVZHjAp/2ZCRzGY/Y2rf/lFEuUdwyA/r3UWnAaoDg7EATrg6H1CQhUTyCcq11w/c=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

To load a value, one must be careful to hold the lock while accessing
it. To enable this, we add a lock() method so that you can perform
operations on the value before the spinlock is released.

This adds a MapleGuard type without using the existing SpinLock type.
This ensures that the MapleGuard type is not unnecessarily large, and
that it is easy to swap out the type of lock in case the C maple tree is
changed to use a different kind of lock.

There are two ways of using the lock guard: You can call load() directly
to load a value under the lock, or you can create an MaState to iterate
the tree with find().

The find() method does not have the mas_ prefix since it's a method on
MaState, and being a method on that struct serves a similar purpose to
the mas_ prefix in C.

Co-developed-by: Andrew Ballance <andrewjballance@gmail.com>
Signed-off-by: Andrew Ballance <andrewjballance@gmail.com>
Reviewed-by: Andrew Ballance <andrewjballance@gmail.com>
Reviewed-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Alice Ryhl <aliceryhl@google.com>
---
 rust/kernel/maple_tree.rs | 140 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 140 insertions(+)

diff --git a/rust/kernel/maple_tree.rs b/rust/kernel/maple_tree.rs
index 92930b408e9683b6615080a53800f1a393c5f31e..24b674ce07d0481702eccd86a7920f94ca000108 100644
--- a/rust/kernel/maple_tree.rs
+++ b/rust/kernel/maple_tree.rs
@@ -214,6 +214,23 @@ pub fn erase(&self, index: usize) -> Option<T> {
         unsafe { T::try_from_foreign(ret) }
     }
 
+    /// Lock the internal spinlock.
+    #[inline]
+    pub fn lock(&self) -> MapleGuard<'_, T> {
+        // SAFETY: It's safe to lock the spinlock in a maple tree.
+        unsafe { bindings::spin_lock(self.ma_lock()) };
+
+        // INVARIANT: We just took the spinlock.
+        MapleGuard(self)
+    }
+
+    #[inline]
+    fn ma_lock(&self) -> *mut bindings::spinlock_t {
+        // SAFETY: This pointer offset operation stays in-bounds.
+        let lock_ptr = unsafe { &raw mut (*self.tree.get()).__bindgen_anon_1.ma_lock };
+        lock_ptr.cast()
+    }
+
     /// Free all `T` instances in this tree.
     ///
     /// # Safety
@@ -257,6 +274,91 @@ fn drop(mut self: Pin<&mut Self>) {
     }
 }
 
+/// A reference to a [`MapleTree`] that owns the inner lock.
+///
+/// # Invariants
+///
+/// This guard owns the inner spinlock.
+#[must_use = "if unused, the lock will be immediately unlocked"]
+pub struct MapleGuard<'tree, T: ForeignOwnable>(&'tree MapleTree<T>);
+
+impl<'tree, T: ForeignOwnable> Drop for MapleGuard<'tree, T> {
+    #[inline]
+    fn drop(&mut self) {
+        // SAFETY: By the type invariants, we hold this spinlock.
+        unsafe { bindings::spin_unlock(self.0.ma_lock()) };
+    }
+}
+
+impl<'tree, T: ForeignOwnable> MapleGuard<'tree, T> {
+    /// Create a [`MaState`] protected by this lock guard.
+    pub fn ma_state(&mut self, first: usize, end: usize) -> MaState<'_, T> {
+        // SAFETY: The `MaState` borrows this `MapleGuard`, so it can also borrow the `MapleGuard`s
+        // read/write permissions to the maple tree.
+        unsafe { MaState::new_raw(self.0, first, end) }
+    }
+
+    /// Load the value at the given index.
+    ///
+    /// # Examples
+    ///
+    /// Read the value while holding the spinlock.
+    ///
+    /// ```
+    /// use kernel::maple_tree::MapleTree;
+    ///
+    /// let tree = KBox::pin_init(MapleTree::<KBox<i32>>::new(), GFP_KERNEL)?;
+    ///
+    /// let ten = KBox::new(10, GFP_KERNEL)?;
+    /// let twenty = KBox::new(20, GFP_KERNEL)?;
+    /// tree.insert(100, ten, GFP_KERNEL)?;
+    /// tree.insert(200, twenty, GFP_KERNEL)?;
+    ///
+    /// let mut lock = tree.lock();
+    /// assert_eq!(lock.load(100).map(|v| *v), Some(10));
+    /// assert_eq!(lock.load(200).map(|v| *v), Some(20));
+    /// assert_eq!(lock.load(300).map(|v| *v), None);
+    /// # Ok::<_, Error>(())
+    /// ```
+    ///
+    /// Increment refcount under the lock, to keep value alive afterwards.
+    ///
+    /// ```
+    /// use kernel::maple_tree::MapleTree;
+    /// use kernel::sync::Arc;
+    ///
+    /// let tree = KBox::pin_init(MapleTree::<Arc<i32>>::new(), GFP_KERNEL)?;
+    ///
+    /// let ten = Arc::new(10, GFP_KERNEL)?;
+    /// let twenty = Arc::new(20, GFP_KERNEL)?;
+    /// tree.insert(100, ten, GFP_KERNEL)?;
+    /// tree.insert(200, twenty, GFP_KERNEL)?;
+    ///
+    /// // Briefly take the lock to increment the refcount.
+    /// let value = tree.lock().load(100).map(Arc::from);
+    ///
+    /// // At this point, another thread might remove the value.
+    /// tree.erase(100);
+    ///
+    /// // But we can still access it because we took a refcount.
+    /// assert_eq!(value.map(|v| *v), Some(10));
+    /// # Ok::<_, Error>(())
+    /// ```
+    #[inline]
+    pub fn load(&mut self, index: usize) -> Option<T::BorrowedMut<'_>> {
+        // SAFETY: `self.tree` contains a valid maple tree.
+        let ret = unsafe { bindings::mtree_load(self.0.tree.get(), index) };
+        if ret.is_null() {
+            return None;
+        }
+
+        // SAFETY: If the pointer is not null, then it references a valid instance of `T`. It is
+        // safe to borrow the instance mutably because the signature of this function enforces that
+        // the mutable borrow is not used after the spinlock is dropped.
+        Some(unsafe { T::borrow_mut(ret) })
+    }
+}
+
 /// A helper type used for navigating a [`MapleTree`].
 ///
 /// # Invariants
@@ -310,6 +412,44 @@ fn mas_find_raw(&mut self, max: usize) -> *mut c_void {
         // to the tree.
         unsafe { bindings::mas_find(self.as_raw(), max) }
     }
+
+    /// Find the next entry in the maple tree.
+    ///
+    /// # Examples
+    ///
+    /// Iterate the maple tree.
+    ///
+    /// ```
+    /// use kernel::maple_tree::MapleTree;
+    /// use kernel::sync::Arc;
+    ///
+    /// let tree = KBox::pin_init(MapleTree::<Arc<i32>>::new(), GFP_KERNEL)?;
+    ///
+    /// let ten = Arc::new(10, GFP_KERNEL)?;
+    /// let twenty = Arc::new(20, GFP_KERNEL)?;
+    /// tree.insert(100, ten, GFP_KERNEL)?;
+    /// tree.insert(200, twenty, GFP_KERNEL)?;
+    ///
+    /// let mut ma_lock = tree.lock();
+    /// let mut iter = ma_lock.ma_state(0, usize::MAX);
+    ///
+    /// assert_eq!(iter.find(usize::MAX).map(|v| *v), Some(10));
+    /// assert_eq!(iter.find(usize::MAX).map(|v| *v), Some(20));
+    /// assert!(iter.find(usize::MAX).is_none());
+    /// # Ok::<_, Error>(())
+    /// ```
+    #[inline]
+    pub fn find(&mut self, max: usize) -> Option<T::BorrowedMut<'_>> {
+        let ret = self.mas_find_raw(max);
+        if ret.is_null() {
+            return None;
+        }
+
+        // SAFETY: If the pointer is not null, then it references a valid instance of `T`. It's
+        // safe to access it mutably as the returned reference borrows this `MaState`, and the
+        // `MaState` has read/write access to the maple tree.
+        Some(unsafe { T::borrow_mut(ret) })
+    }
 }
 
 /// Error type for failure to insert a new value.

-- 
2.51.0.338.gd7d06c2dae-goog


