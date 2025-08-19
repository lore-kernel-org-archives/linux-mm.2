Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A70FCA0EED
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 10:35:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 657278E0030; Tue, 19 Aug 2025 06:34:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5DFE58E0001; Tue, 19 Aug 2025 06:34:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 459218E0030; Tue, 19 Aug 2025 06:34:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2219B8E0001
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 06:34:58 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CA259160301
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 10:34:57 +0000 (UTC)
X-FDA: 83793149034.02.B663DAD
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf24.hostedemail.com (Postfix) with ESMTP id CD123180005
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 10:34:55 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=SkuyfR2z;
	spf=pass (imf24.hostedemail.com: domain of 3TlOkaAkKCNEx85z1EL483BB381.zB985AHK-997Ixz7.BE3@flex--aliceryhl.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3TlOkaAkKCNEx85z1EL483BB381.zB985AHK-997Ixz7.BE3@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755599695;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BYWHG9rV+2DZ17Wm5m0AvZTyVI+nQsfmKfJhbAh/mlo=;
	b=qeMmBfa5PyzZh5T6OeFh81fB/rKS6NdZgi7Fk4AROiIDXf8EUgA2TY156acxR7Ry9rFBGY
	VTPARQytpnXaQ84oohDfOdVhPqrX5M38zmEZQdVY5JT0eN+uWoPawVEZalaTtl2pUblZ0W
	HLOgwKuErKGCsDcq1KLPe9kRGnfUfec=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=SkuyfR2z;
	spf=pass (imf24.hostedemail.com: domain of 3TlOkaAkKCNEx85z1EL483BB381.zB985AHK-997Ixz7.BE3@flex--aliceryhl.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3TlOkaAkKCNEx85z1EL483BB381.zB985AHK-997Ixz7.BE3@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755599695; a=rsa-sha256;
	cv=none;
	b=DpjthIcA4SjRZ5fRHffFg5W705cVT+ANno6Zy4+niTICO6vC5Z72QktHV1V+SKPNPfn+tI
	x/D1Yj/cd1pbDvK1mckaKa1/YLX0l+bjIb1hDpfOG4+wnBc0z8lueKNieF1KvOnLvwNPCJ
	yvtPYzqrBPRSqou/muygMfGsww0H0Cc=
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-45a1b0c5366so23413705e9.3
        for <linux-mm@kvack.org>; Tue, 19 Aug 2025 03:34:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755599694; x=1756204494; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=BYWHG9rV+2DZ17Wm5m0AvZTyVI+nQsfmKfJhbAh/mlo=;
        b=SkuyfR2zR2fzGpdKJQKQnkWBadAp0p2iQt+AhHALdDMy95EAMh/+0dG/d5UsHxVXkx
         LAWKFhYpQHB1otGUJndqib2P+EI1n4kBYyPb4suoERyrJ4Uyl0czCWAUw/iLa+wg6y8Z
         YtORW3IDNXEDRk6Z24Y+zXBf25gtKLaiXOFtLbJbkSA8Auutg5hvb6AM0j4LefaNmrao
         Ie7q1b9nHd9Cl7cyao41O/V9K8L+FNXvYCkW1uqyZvpbfnbIsX8DmPSOUhdNTNd/y+Vj
         BKlWfIjuQAWCXff0I9NBFnSz/u+/G4bXeh9j06+ZAr+YjR0oNyxdm4s2MaMOlF47mbQT
         +29g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755599694; x=1756204494;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BYWHG9rV+2DZ17Wm5m0AvZTyVI+nQsfmKfJhbAh/mlo=;
        b=IuY2SjPSz3KDGwr16qr0HQE9+EC5Fam/ZOx1UGz9bIou4baVYkLk9av0FfakBJ4uSu
         Ie879CNYw5qWQfUcbG0IGTW246BOgRkmxsx6kdjm5PVHqfi0D6cTPcG3aoQuHI6ctTIf
         LmVETtG7zBwZIygPAj23viSaQIUz1h4JyYWFPPWHURllVKIPE5qYGih6yC172O/LbPOd
         1SBPyRM/WLFE+OjKHOEbWQpnI2+RmDvA24aE0/Kxga9z5qZ+D5OL5IYg496ywJ9Yyuwn
         IZTDxbbG0EolcjnZpatBkhha5vpVyB1J3BknJe1G9j7tMN2+Qe/K7orTzo6VkpzmiC33
         w/ew==
X-Forwarded-Encrypted: i=1; AJvYcCWoFd1oyUz+EdllaBkseHpXUD3FzI1pMv3XLHo8wyBqYE9wR0j3ER56+kMeCerv+bGRA8kYvG6HLw==@kvack.org
X-Gm-Message-State: AOJu0YyJK8iNVBPMU6FVtyQiCCFY/j6HO6QKxaSqBqFM+PPj4E3pwjbE
	WgR+MTgawB3fEp8bLoFGul4/jVkhp2zJ/7tOr/inbPQVuYeah/co8IZbR3/2Gn5gzWwojr6QmKx
	k6dDhWjoA3mcVMgKLHw==
X-Google-Smtp-Source: AGHT+IFBgYtRm7CWyI1w4fPitIlOJVfovxFrde4PL+kQ34yH4njzswJ7XwKKVps2PuFHp10ZDY6TrvIKkaD9/sM=
X-Received: from wmv20.prod.google.com ([2002:a05:600c:26d4:b0:459:dfcf:15e4])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:198e:b0:458:c045:ee99 with SMTP id 5b1f17b1804b1-45b43e129c9mr13524705e9.28.1755599694398;
 Tue, 19 Aug 2025 03:34:54 -0700 (PDT)
Date: Tue, 19 Aug 2025 10:34:44 +0000
In-Reply-To: <20250819-maple-tree-v2-0-229b48657bab@google.com>
Mime-Version: 1.0
References: <20250819-maple-tree-v2-0-229b48657bab@google.com>
X-Developer-Key: i=aliceryhl@google.com; a=openpgp; fpr=49F6C1FAA74960F43A5B86A1EE7A392FDE96209F
X-Developer-Signature: v=1; a=openpgp-sha256; l=6917; i=aliceryhl@google.com;
 h=from:subject:message-id; bh=D/ogmv6je6b+B8kZGRNN3fxoNtbqMSGDfVNELXGyhdA=;
 b=owEBbQKS/ZANAwAKAQRYvu5YxjlGAcsmYgBopFNJIFLz4Aprvq7ZI2MNJOKuSzdNGW1/VHJ82
 jvD7kmIfDSJAjMEAAEKAB0WIQSDkqKUTWQHCvFIvbIEWL7uWMY5RgUCaKRTSQAKCRAEWL7uWMY5
 RniPEACGbhxlrlt8/Clyf5Fw+0UpjFP9dH6UWXSI8fN8qGFSUVA3wY2bBoO27kK94+4bXDfQ/AW
 epU1uS8pgyulz3OXpZDKIQ0wxfcwwxJykBGini7ha9XfLO9CwNq0m0Mk2jklKruK0O8C9vwqI1S
 Qb28OmX6lBr6EsXb2frq1JvBY97WxOcOgCekC4uvh+9Q381pwBRh9JteXJ98l1K+Wmn1b8HEHad
 y1kQF24vmus9anM+eamNnUd8RbMOyTzQAc6fJeS9qeJzPKgYGJT0xq6U2qMT1Q3srofjuB4VKix
 JBB6sCMRl+JBW51b50qtb4KomwviFQq0MT66jX/1vah1IdH3TXI+oTD6KgtXITB35GjXHJr4rq3
 XGO4kqyvnRNzkMNgpBrbF0QZd9dRFZ01c2+xXDVtSWPEbLUrgojpO7QM9+/qaSj2aBJEvrwZb61
 GrmZTJ/ayk/tA9yuTt8fNc6IkAz/mTKNMeP2RrHb0Pk1Yjc98aTEIopKJen84AQvD0dR5NuqPJ/
 Mlfa0PgHaCIi5/wac0+Ll/ULm4CgZNEUK6qbJVaQOiKrv/m7akBpbA/s2AaU0HJLQhK8U0kcsbM
 O635DN8aBVluhQjultaKNGfHdOw99rLJnuXfuogdytUIHTP9jANSoicWwtIl0OZvMhdXN+86J8J Kn1zGFMHYK0xA0g==
X-Mailer: b4 0.14.2
Message-ID: <20250819-maple-tree-v2-3-229b48657bab@google.com>
Subject: [PATCH v2 3/5] rust: maple_tree: add MapleTree::lock() and load()
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
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: CD123180005
X-Stat-Signature: zr6tsunpyw51y36srrmhhx1j3b5bq6up
X-Rspam-User: 
X-HE-Tag: 1755599695-534619
X-HE-Meta: U2FsdGVkX18vRC/eoncQg1xkLs0G8wrFvbUHUNFexaDxJnVO45Beg1MybGhw5AKak7WnqIoHACRLS9Nky5FyZWILYXw1lUQ8ijmoGJ9PI6j4AYe3poj2Se1SsXmhBgN5MIeRt/Mb5HWHUt1WAbGo+hkfkR94nJlnc7AcMv4lTOfeIm6UiiNSs0EZ0RL31ZdR17jKJMI81LP2giERD0t1jMK1JjlPwelvukeABbin/931rnrb7VKXpUEQiHweAdc4mFQN19UF0qEKEpNbAs9N/B2NNkwbNe6s+PAjrvv1wHeFm0kmdnMFlgoKPLso7pwUnwwqENIYggWVyb63rgp8lkRaUzK+GA9fwE4v2n4LPfvTnxU5pd8LmSjYmJzaR8vfgsGUhfL6uS7+1JgN0Hcod9D5fylDa/9gRzzFITg5i1lU1DMwvPL+0ucEjqEBn5Mf+Z3ta0fvn6EpXqp1wSqQ/dtue/4Dff2VnM6mnyE+37xOE02m5/7FwjttcA/kafSY48XUOHBONFeJb3zfGYM1JObLBEZGCOgobITj95vQk1F3ZySM3Faoh2ODzJCKVrNTxvOq5lBb8QNB+JEexJZZiv3a64NpBEuLVNnnOY9OWMCmYyiU79GU6GzURVmMuLTubua/u7oLizSFCE7iOb2ZZ/zwqclqmuHQ4A9phmS56uvZ5dPz98EHEK2xK5trCSV0VFczNkO9La/IpHNOOJpje19dhyk5ptcQlpzD/WCz6TD+RM8v4NCN5kM2G7bNR3TakwrIv4n4/HOGgZUmctXoQRimLV7p6k85qwzYIODKDREJbBPW0ppDjLJQjhdij1/5bJi4EUAnNXCNnfeh6Do6sYpV9uKL4L/1l5tvqGpvmyBnEjjCWR3QB247y5Fq7uRFAvO/P7jMsS/jttIWWlnb3CmTM4tLf4LqcUvb6iyUUViQYQgCo9UQOEPBs82WHVoQXoUdK7dHtrjwSddv4Ie
 NOZvMUZX
 jRYnudMCOr3QHDg+Rb6M7+7N5c4K8nwCQOt9OHOP6UyKwwC1UOPhPKU/w4hQne4+M5MeR/WZNGhyyEtnrbaG73Np3uJi5yxfRhAFfl8KfmoQf8C7svTo+teP8Yl4zgJbFEQrIg88RbnSVAWRTmP319jrUL2N4X/CRNBlL4mv4AbbroBB+BAitFSo19eR0AiC6bllwCWDRjTpJ27Yai6YgD2zNUbomtea0H4W4iG0BVpfaBRqtbvY+H6OB3PgAifqup+6YAZxwGh0UtB7Ovnwv9gKLrkQIpMTrfHSKKb+6+nF+LF9d6dKD0vcpks9dH4nnyJQRQIJCbr83UeYzG6kJgFOVtB1iF/yeY0hkwYxGJ9oHBhuP1sGGS+w9zE7E99LnTcDbqSqNS2rXB4L3onxbnE0MMe43e4/P9rxOkfoDN3OJK3GvogStrI0wiJiKGUssdXDQI5Dxza4HZFyPkx7zwzAtHd8JWactbC+vV5H9wbTJFZhmNt+eG1AZmqq0Jhi+8Qo4h5oCB+HQNnNfHWKcAKpz1Kw0saMdhkmhgiaez9pfkx0uIHO8LzXCwBOmNwG7//cjJ9rPrzv2LvdBuqHswAibPXG7u8+jkYQ0GDqpTVF0qo7HQXWHcCX7g9M+yz+pcEs9XmmIr9eEiVRvQt51w2SvaaOBt9iKErP2PDlkzAfKG7pU6YQIaD5rQa1nCuUyqU7vecDRd0Kb9i8=
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

Co-developed-by: Andrew Ballance <andrewjballance@gmail.com>
Signed-off-by: Andrew Ballance <andrewjballance@gmail.com>
Reviewed-by: Andrew Ballance <andrewjballance@gmail.com>
Signed-off-by: Alice Ryhl <aliceryhl@google.com>
---
 rust/kernel/maple_tree.rs | 139 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 139 insertions(+)

diff --git a/rust/kernel/maple_tree.rs b/rust/kernel/maple_tree.rs
index ea1bd694213b73108732aecc36da95342aeafe04..17e4d8586ebad56aee87a97befdfec5741f147de 100644
--- a/rust/kernel/maple_tree.rs
+++ b/rust/kernel/maple_tree.rs
@@ -220,6 +220,22 @@ pub fn erase(&self, index: usize) -> Option<T> {
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
+        unsafe { &raw mut (*self.tree.get()).__bindgen_anon_1.ma_lock }
+    }
+
     /// Free all `T` instances in this tree.
     ///
     /// # Safety
@@ -263,6 +279,91 @@ fn drop(mut self: Pin<&mut Self>) {
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
+    /// use kernel::maple_tree::{MapleTree, InsertErrorKind};
+    ///
+    /// let tree = KBox::pin_init(MapleTree::<KBox<i32>>::new(), GFP_KERNEL)?;
+    ///
+    /// let ten = KBox::new(10, GFP_KERNEL)?;
+    /// let twenty = KBox::new(20, GFP_KERNEL)?;
+    /// tree.insert(100, ten, GFP_KERNEL)?;
+    /// tree.insert(200, twenty, GFP_KERNEL)?;
+    ///
+    /// let mut lock = tree.lock();
+    /// assert_eq!(lock.load(100), Some(&mut 10));
+    /// assert_eq!(lock.load(200), Some(&mut 20));
+    /// assert_eq!(lock.load(300), None);
+    /// # Ok::<_, Error>(())
+    /// ```
+    ///
+    /// Increment refcount while holding spinlock and read afterwards.
+    ///
+    /// ```
+    /// use kernel::maple_tree::{MapleTree, InsertErrorKind};
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
+    /// let value = Arc::from(tree.lock().load(100).unwrap());
+    ///
+    /// // At this point, another thread might remove the value.
+    /// tree.erase(100);
+    ///
+    /// // But we can still access it because we took a refcount.
+    /// assert_eq!(*value, 10);
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
 impl<'tree, T: ForeignOwnable> MaState<'tree, T> {
     /// Initialize a new `MaState` with the given tree.
     ///
@@ -303,6 +404,44 @@ fn mas_find_raw(&mut self, max: usize) -> *mut c_void {
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
+    /// use kernel::maple_tree::{MapleTree, InsertErrorKind};
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
+    /// assert_eq!(*iter.mas_find(usize::MAX).unwrap(), 10);
+    /// assert_eq!(*iter.mas_find(usize::MAX).unwrap(), 20);
+    /// assert!(iter.mas_find(usize::MAX).is_none());
+    /// # Ok::<_, Error>(())
+    /// ```
+    #[inline]
+    pub fn mas_find(&mut self, max: usize) -> Option<T::BorrowedMut<'_>> {
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
2.51.0.rc1.167.g924127e9c0-goog


