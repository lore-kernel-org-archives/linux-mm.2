Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 608F1C87FCA
	for <linux-mm@archiver.kernel.org>; Sat, 26 Jul 2025 13:23:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F0746B008A; Sat, 26 Jul 2025 09:23:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C9356B008C; Sat, 26 Jul 2025 09:23:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 06A4A6B0092; Sat, 26 Jul 2025 09:23:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E33706B008A
	for <linux-mm@kvack.org>; Sat, 26 Jul 2025 09:23:43 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7CE95113CCC
	for <linux-mm@kvack.org>; Sat, 26 Jul 2025 13:23:43 +0000 (UTC)
X-FDA: 83706483126.20.1B84CE8
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf25.hostedemail.com (Postfix) with ESMTP id 75134A000A
	for <linux-mm@kvack.org>; Sat, 26 Jul 2025 13:23:41 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=2Sje52o6;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf25.hostedemail.com: domain of 33NaEaAkKCOcJURLNahQUPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--aliceryhl.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=33NaEaAkKCOcJURLNahQUPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--aliceryhl.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753536221;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l1PlHNrbkB2wLR+NzxgcoFHAW2vBd+j3ocXDrnNRVwo=;
	b=TPjeYAAs1ng9ue7GUGDOMfOdvc8rS7K1WDbo/pgROtZ9iyqWntRkV6Ek21ln1Rc1FzQB6/
	5n1MnTSs2+VrUAOBjF2VpVYQwLlmMo9LTW7rX1QP7WK1CByUymC4j5tU2Jm0QsYwj1Sq+6
	+yvREzKV1Rf0aUKjdl3ivIWdbfFtARE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753536221; a=rsa-sha256;
	cv=none;
	b=a781575qnx4Ex3St1URXioZfd+O2H3X9TWnV2r8XsWVvl6bb8DfVTEjQd8HedtnV7CSECt
	ReyA/vw5XjOwBjXjX+el+2T0CuUwV+/b0fMrz6wm+A+uDW9Bd/mbab/2PbTcHwNM/IA3ha
	QebwqH+hyVueQxXbEDCv89AdxfHORJk=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=2Sje52o6;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf25.hostedemail.com: domain of 33NaEaAkKCOcJURLNahQUPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--aliceryhl.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=33NaEaAkKCOcJURLNahQUPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--aliceryhl.bounces.google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-45639e6a320so14445675e9.3
        for <linux-mm@kvack.org>; Sat, 26 Jul 2025 06:23:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753536220; x=1754141020; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=l1PlHNrbkB2wLR+NzxgcoFHAW2vBd+j3ocXDrnNRVwo=;
        b=2Sje52o6JHLbIXMCt4CFD3+Va6miidJ7/rdkxjlyUgZ168lAVl08fdDcGsq47Gp/3w
         oPYrkXXbqkxA1kqEBLv7xXpJdmRXCdLe/NzOgBTRykz0z2727U+SC+qiYudslDQJtX3A
         NUkFb/15SPHGEvGB0mAvvpxN0EeVCaOyqEJzbhCye7EnIx23aA4ozKpvfEc6mjha7xZQ
         wtYGNqkqm6SItRP/7yXBgnwcDTix3x5T0EYLhlxNM7y213VbBjHtTMBMyB0PPgv4OjoZ
         fCyNPk58qDuoseNPlcj8pkBKOhn+18YifgP0A+RjbrOO7nMhBC+6H8/3A2o4jEbQjDGW
         D0GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753536220; x=1754141020;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=l1PlHNrbkB2wLR+NzxgcoFHAW2vBd+j3ocXDrnNRVwo=;
        b=QQG46Jpq+RmZN1OODlnc2rsywkpm8UqiXAh7H5Ftz2Jv+InFvpT8B7G+icwxNImlDY
         mGniO1nQII/LPTgAFrFvmaFHiHVUNMIA7XrjM7vjtCS+mKOhYkIT8opSdYndH51UaUk+
         UBSPELh/IGPhubK/n1V2g5oMdiMceuw+vi8RWB6VuK2rWXTtrYMt9UhHZjt6VHP4bJgx
         AeS/Vpnw4G5qaE+USOuN6gyDMx1E5/yUSjO4I+5KvEb2MSGvhIDIwCZPpqWvSSI3PA9c
         WnxbLWxMarrx+tY4NORTThOxH01Fw9dmpd7e2wSsQ542nyzYdr3yKzpiHLBeF9380GQa
         c+ew==
X-Forwarded-Encrypted: i=1; AJvYcCVEL8VvjncT5SfkZFXDpE+TwPM/Mj5fZfLI9xT/3MLi6AoGfVigd0G7eJZ06bS63DhAeZFI66ecIg==@kvack.org
X-Gm-Message-State: AOJu0YxYrzyJ/Mk7IzsaZVvhGHmm0r+Wh1za4ywszAEbBplzgR3T0/tP
	8KtC5d5ZFowLeoG6/oFdtkhVZLgNmc4663PQO3C0fqI6g0qEw6ow+Fs8Nsykc9n1NkWy1pUK/Gr
	mFceC4+HO7kGhu8HYXw==
X-Google-Smtp-Source: AGHT+IFa549WAC7/2Zp9TH9mHT9emec8EXGjR72hnwYKEZwIZ25eOt8v3XNuQSi0cp2BViD6aiA8OSHxVl/jLO8=
X-Received: from wmqb14.prod.google.com ([2002:a05:600c:4e0e:b0:456:1a41:f922])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:3593:b0:458:6733:fb69 with SMTP id 5b1f17b1804b1-4587631d56bmr51203715e9.14.1753536220088;
 Sat, 26 Jul 2025 06:23:40 -0700 (PDT)
Date: Sat, 26 Jul 2025 13:23:23 +0000
In-Reply-To: <20250726-maple-tree-v1-0-27a3da7cb8e5@google.com>
Mime-Version: 1.0
References: <20250726-maple-tree-v1-0-27a3da7cb8e5@google.com>
X-Developer-Key: i=aliceryhl@google.com; a=openpgp; fpr=49F6C1FAA74960F43A5B86A1EE7A392FDE96209F
X-Developer-Signature: v=1; a=openpgp-sha256; l=4561; i=aliceryhl@google.com;
 h=from:subject:message-id; bh=jbvUxSZMSHeAOtb+L6zXp20Ut43R/IhAlazvT1nIoks=;
 b=owEBbQKS/ZANAwAKAQRYvu5YxjlGAcsmYgBohNbX9xMhZIlJ7rkwetRISa3iC5gQelXgC17we
 wNz5SyM+veJAjMEAAEKAB0WIQSDkqKUTWQHCvFIvbIEWL7uWMY5RgUCaITW1wAKCRAEWL7uWMY5
 RtQSD/9fnIIPodnb4V7IIC8dqWxmhAl1Zv62fgVPQaZH8+6jJ4Er1tViiWorbrQZKd8PhLYsI7w
 kITZA/5FirCmkjdSb7+f/ykUoj/gz/Svop7nwIrzKM+FYGGolvD4ewQScbJ7m2gn7hoTJ98FXiE
 s6FaJFL8tXS6BwdKEaxyBo+IK0N08muXCFvEtcs7OEKFd8j+AX9dPVeAMHP45dksiAwaMRhGkO7
 QVvoK+s4E+/czByctOVFeh6TxbHnym1BAL0sA9SK5z+UzWxlns7l38ftBeWdA+Mz7u/OkAf632N
 JVDHVpJ3tv/xq7wa97vRJ9kT21KRBuB62EdvgCfoPA7iPwB5oPMDW0rAV/bYrTz9M7p03+egRBB
 B2a9MbPNh0sqlnBQTwQEAUb0+iQwTXBf7AzQDenfy4xn5pk8yaBrxKQa0DhAysOiFrB/v7PmZTk
 4BIV59I+qbvoSv8bY64FrviEadvmn85BiLari+ikH5nBRbY1bzgcNjknOousTZKyEXn8dIIWtVp
 hNkuzn1/PQJ98y9F1O2VFQNlv6XubDrxpJdKcLB6LkUachb5cqqVPuzoIzovJXPr5xyFM/RABnF
 Ore52VsW4ws1Op+KYRmC0sbFNPEFqaLwk5Qw7yP5g3n3BiNGeMvj5Be4rJ3S18/LBA0vSQ3CRMO ifZxDBCwEkJksFQ==
X-Mailer: b4 0.14.2
Message-ID: <20250726-maple-tree-v1-2-27a3da7cb8e5@google.com>
Subject: [PATCH 2/3] rust: maple_tree: add MapleTree::lock() and load()
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
X-Stat-Signature: qpdi976ju1qxb49hfmzkd37wffrupj9q
X-Rspamd-Queue-Id: 75134A000A
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1753536221-954865
X-HE-Meta: U2FsdGVkX1+vLOUGR+UBC3ijRtFdszf4gMQktsfC3z7a7sV7x08+rnawLQ/q9zIoxBV3ILH8ZtuUUk7Vd8yXkpj5WYhM8nV+NvXwMWsX9CFWX0FNCtMdb1o7W8UzTDgTSYKV3v1j9LYliHN/D9zE7QQm213GJcbr1PTfW7xtGF6GhWaznjCWp+dEfCngyswdCa/SjIYd/JcZcRcj3vkSSKAxocEZGGYrinRRKgD1ZHYxyVsr6/WCVH4BpDq4xRFKhzsb1FY3bJFPqh53Asg1eR7PxmEDx2J5SK2wkKn33pEjNQ3cLJ9pkcKZxAgLklKIL2RA5Yr+Kyy6x+1rdcMkq2idkoWcHn4q+khjInqu5d15l16Ix9WwQTlKIXKZATzotHb1hGA0+53vfx5sIzJJumC7V/b+Kkap5vUdnsIpv2FppxKs4UB8kBtfWUPFNSyyoTNxkJ2hqnj98OJpnfV2wAonlAAljDeEmsuBJZML4JdLnmM4eQvU/aa1hW1e+TdMQNVZDC6LBxOr7FOCpZpaguDnQ2hCd0/OizSSn5ZLPGyuddjPrsx7p1OKFxy6NNt8vqk9Dolw3WER2v1x4AudgvvmKKKzY6dcpzTTqOj0KFbjR7wKXvUI4RMnzauMMl4+fluH4WCtq1uMaCbOoju+tP8r+ucDatP4maXrFajYxNXutcRHW4Ok8xavBIvlZ0pAEmwI4PknOnoq0pBNVFJuf9D1pwDASVRx0/9Fb/4k9FMO4nQ/7OdWpm1aNYL4SO1m9Piwy5BK0d7v1yESrK9CnezWH1Nwt3iZFZHz1VASMPepx9b+NTDlt+Ya2Gn8HShFtkdBwgHeuu5mfxFEPiawsecAX0aiOHWGOYwE+2SH09G4RTGyD1IoTjqpCj9zIIimGfjrlnA7hFI65rtp55joWEgXnXMPGf9JY6oI/Nh1ubpOiYZk7eVtwZ3saH5zH5R8GxdLauj2x+AuBcck1IB
 pstqGI6i
 JNLJJ8AmVFbzm1wRKJyWWmKC+O3AmrglVFh/awRux0MZaotQ4x3czr/cqS6ZdVYG1lL03vajnOe11thbVZtRQpxZfQmeAQ6UqlXBi/fE9Sy1ZfNBy7/AwAnuAJ/DSHPZDWtcBLsH1vr2JFNBqbkhPQJNYXXUmy07qN7OX2QwRWNp1wZtaSM72nLvUPWpSIKfvmYPG0v4oOpdPzwsvtLv+/rRO7RK60dKHFqSwjmi+hw2Yy80KAkJuFIAXmmQ80sJ8p0PdI0lHsln4Gi6r3eaIK4XR0G0fsVzierFqIWou0M8bb2rxVV1J1DP2d3sXeG0V/kZCkDCLEwpP1AYb1MQnHjotuD8EFwIHpEnMaBAIAM/LI7GKT7r7n0w4K8334lNuVz5rAHI2yQnvhupVt89NHU4cPNMsrj89Q4SJw8PpO06R+cpG/xVd6phcwS7dVCCQr7HnZeVYLlS7KFLhhmNxvBpuhG1on+L16aMoVPv+xUbJ0KVO9Ynyph70+kM+5Y2BJHH1Fu+P5lo3j3LWXStKmYxXivZTLCATRe3BWYAzxPCOqCtlCKs9o08IPvadxCTHTOjWJGVf0FTiyCP5g7BEnEBEohKZk0ybrU07cqB2jEsXjoJp4hmaJQYyy+Zqxn+3+uRx5456B16i12i2cc5g29VN+xPEt+QBs03hLCXe2m2pnGEbP1Sjn3V6f7dgIUSgN5W3gX3KiNldYf8=
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

Co-developed-by: Andrew Ballance <andrewjballance@gmail.com>
Signed-off-by: Andrew Ballance <andrewjballance@gmail.com>
Signed-off-by: Alice Ryhl <aliceryhl@google.com>
---
 rust/kernel/maple_tree.rs | 94 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 94 insertions(+)

diff --git a/rust/kernel/maple_tree.rs b/rust/kernel/maple_tree.rs
index 0f26c173eedc7c79bb8e2b56fe85e8a266b3ae0c..c7ef504a9c78065b3d5752b4f5337fb6277182d1 100644
--- a/rust/kernel/maple_tree.rs
+++ b/rust/kernel/maple_tree.rs
@@ -206,6 +206,23 @@ pub fn erase(&self, index: usize) -> Option<T> {
         unsafe { T::try_from_foreign(ret) }
     }
 
+    /// Lock the internal spinlock.
+    #[inline]
+    pub fn lock(&self) -> MapleLock<'_, T> {
+        // SAFETY: It's safe to lock the spinlock in a maple tree.
+        unsafe { bindings::spin_lock(self.ma_lock()) };
+
+        // INVARIANT: We just took the spinlock.
+        MapleLock(self)
+    }
+
+    #[inline]
+    fn ma_lock(&self) -> *mut bindings::spinlock_t {
+        // SAFETY: This pointer offset operation stays in-bounds.
+        let lock = unsafe { &raw mut (*self.tree.get()).__bindgen_anon_1.ma_lock };
+        lock.cast()
+    }
+
     /// Free all `T` instances in this tree.
     ///
     /// # Safety
@@ -248,6 +265,83 @@ fn drop(mut self: Pin<&mut Self>) {
     }
 }
 
+/// A reference to a [`MapleTree`] that owns the inner lock.
+///
+/// # Invariants
+///
+/// This guard owns the inner spinlock.
+pub struct MapleLock<'tree, T: ForeignOwnable>(&'tree MapleTree<T>);
+
+impl<'tree, T: ForeignOwnable> Drop for MapleLock<'tree, T> {
+    #[inline]
+    fn drop(&mut self) {
+        // SAFETY: By the type invariants, we hold this spinlock.
+        unsafe { bindings::spin_unlock(self.0.ma_lock()) };
+    }
+}
+
+impl<'tree, T: ForeignOwnable> MapleLock<'tree, T> {
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
 /// Error type for failure to insert a new value.
 pub struct InsertError<T> {
     /// The value that could not be inserted.

-- 
2.50.1.470.g6ba607880d-goog


