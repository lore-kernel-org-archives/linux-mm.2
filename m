Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 882CFCA0EF5
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 10:35:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A27A78E0032; Tue, 19 Aug 2025 06:34:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 988A28E0001; Tue, 19 Aug 2025 06:34:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82A428E0032; Tue, 19 Aug 2025 06:34:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 69A6C8E0001
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 06:34:59 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0417F11763C
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 10:34:58 +0000 (UTC)
X-FDA: 83793149118.04.B3CE442
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf12.hostedemail.com (Postfix) with ESMTP id 11D8140010
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 10:34:56 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=BXdMwH8U;
	spf=pass (imf12.hostedemail.com: domain of 3T1OkaAkKCNIy9602FM594CC492.0CA96BIL-AA8Jy08.CF4@flex--aliceryhl.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3T1OkaAkKCNIy9602FM594CC492.0CA96BIL-AA8Jy08.CF4@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755599697;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jTGsOM3ccmHHhc5WskUdW4VbNNgxc3UCr+/674UGKtg=;
	b=V8OPKuf02HTfqv+TFenNH5TXQU2ZuQUDlGxR86Ww2gX7QB+6qnD/lwvVXzwItXpAb+/N8w
	hxgc056leLbrCkuPR7trvXei7K2m+osNMYB1DnHDErkPikQRRVmE6uDVsfkrymktDEqcsV
	lav92qXFhSA//1kg6S9pjmeN8nZFYjw=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=BXdMwH8U;
	spf=pass (imf12.hostedemail.com: domain of 3T1OkaAkKCNIy9602FM594CC492.0CA96BIL-AA8Jy08.CF4@flex--aliceryhl.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3T1OkaAkKCNIy9602FM594CC492.0CA96BIL-AA8Jy08.CF4@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755599697; a=rsa-sha256;
	cv=none;
	b=s1eNCVULMHglWo7kvVPpqx5eVaVwLs0Vq4JX/XlDWApG9czli8lEGOTZSUzYEQlI7+loIe
	fQk0kUq5GYrCV7kBpmAa7jWJU+iCkYpfhoK6bSvk8BaOP9iKakGwbwUSK2nrL8z+FxVeh4
	vwPDcRoTulNpgb22EBOIykN9u5FYHSE=
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-45a1b00149cso17394045e9.0
        for <linux-mm@kvack.org>; Tue, 19 Aug 2025 03:34:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755599695; x=1756204495; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=jTGsOM3ccmHHhc5WskUdW4VbNNgxc3UCr+/674UGKtg=;
        b=BXdMwH8U6pUWnzQi0kg7fj+chuqQ5TZdLP4qKgXJDvphx6EDKNpQXoR8clhodEGJCt
         pNt6JeM/juvecUKw+b+aRQhJc8lky4HxnqUSC9+6OPRWWDDwn6qBdsxRi/9fq+qF/YWp
         HHJmSGip9zG0vtBS/ILUWLmyS/LzDIsLDYngMgKYct3BBrH/zGqgNa1tbuYsMnrYwqVF
         F9ehyheMhBP8gHwEb5m/MAIWf2iMdwslNDRvKUXKcfAykh1VtVkyAOWoj+9Ng3w5YMXm
         dWyEDYND2uHPwmFiP40oYO+Uo8Ds/QAIyPi8+RBRSe5Mu0PRjg72Gp0SlUwVyaIQTJ6t
         xHAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755599695; x=1756204495;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jTGsOM3ccmHHhc5WskUdW4VbNNgxc3UCr+/674UGKtg=;
        b=Gy3m13Eb0P5WVD0iZ2KPzNEd76rj82IYVD18MB3vCieDhnCU69qet2V5jxXKeEi0pN
         faOfwFBaV4ft4ZVRdYGw78k79WLCohFXDkBT94LUeXo+h4iPZhD44qObhjEYc1By9pta
         GbXKvLJ/Bbps0fe5Qzd4z+z1hUnYB+Udya6C9BhTgN7Fbl2eAhyRR+zUhKSwmHZKNJnk
         5ODoAalhXiMjRaNpzVGTUxgrYW3I8HbJO9Mdf+yytJxJkFBUJedLaM1mGe2hypZ7gxHA
         QeIXoimek3d9BiuIqt4K+UGMcoZK+HR9suV4B6Fpx+WekcizqQMh9b/pDQYq3+s7ICwc
         A8rw==
X-Forwarded-Encrypted: i=1; AJvYcCUpaqBiRdT70vGhHxqQcuI+sE/0X8rpOuvk8knMoNxMNmlWg3J7K+lof8YjwyrD58GHcU7Zg3uZtw==@kvack.org
X-Gm-Message-State: AOJu0YyqClLvP9xbYBuIVYQ1PvnXB/QSvEKRBh6jiXlc857fYnRdRDWo
	1dXZwBxy+01Ez1I1pBUYYs2QECSJXmXkxLTWm3EDC3AKWVgaonL6Oq+Oqrry/3+ZI3War4ubx1E
	cbvmYb+afGWJOchQNhA==
X-Google-Smtp-Source: AGHT+IFY21x4v/c1ZoUPG7tLMqMibOhzvpRD5BMkY3Xd0T8BDUmpsW7QgUomHK+xQi2rAb1pfFGxLGRbobFtkVM=
X-Received: from wmsr19.prod.google.com ([2002:a05:600c:8b13:b0:459:d7a7:e5d4])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:4e88:b0:459:dde3:1a55 with SMTP id 5b1f17b1804b1-45b43e0c021mr17265175e9.24.1755599695523;
 Tue, 19 Aug 2025 03:34:55 -0700 (PDT)
Date: Tue, 19 Aug 2025 10:34:45 +0000
In-Reply-To: <20250819-maple-tree-v2-0-229b48657bab@google.com>
Mime-Version: 1.0
References: <20250819-maple-tree-v2-0-229b48657bab@google.com>
X-Developer-Key: i=aliceryhl@google.com; a=openpgp; fpr=49F6C1FAA74960F43A5B86A1EE7A392FDE96209F
X-Developer-Signature: v=1; a=openpgp-sha256; l=6521; i=aliceryhl@google.com;
 h=from:subject:message-id; bh=X9XFKJ/dRuLjFf9dlRypSpmNCQXkOPPPLNvJwnrWGes=;
 b=owEBbQKS/ZANAwAKAQRYvu5YxjlGAcsmYgBopFNJRvS/NdC9m8TcOEVhic75KUQrLzgS9PtUi
 Y6nIpEm/2GJAjMEAAEKAB0WIQSDkqKUTWQHCvFIvbIEWL7uWMY5RgUCaKRTSQAKCRAEWL7uWMY5
 RhidD/9bOogkPZA/VWPUlEqA1/8iz3EqugHgMIrI+0iosvnnBfQrUU8Ck7XrXwbeBzHmtWzxD66
 TfJxRTgVL9JqZmx+a4DCu63RM9uDqGGSx50ItDgZbLT4bjNgO0eEEbbzVj0yr/OXPKs5/5/ClQW
 iINNCRMbUVhbxsHhqgKJDZuCn26vYQ18E5Re1o/ry8ld2MZmkzfHjyB652N3gE1zk9kb/aVzycw
 Y5L0ksW1ENA9GXp2mM5MZAUWaL6WuKCKZ/GXaoLNKGHQYRWFlK7T1Gbsic+AkQq4HPqWmY7LLAa
 fTxDPJ9mm3zHFxAtIZW+fP3WwU/VCxc4qwqgTOj+CphQZxK3MzGv4xlS2hC40TtuTc3gV01Z09p
 zDITES+B3bASFSzWk496J8CNNjEZ72qSLw+b1JWzzCBJtv7l0DyRUUEBKzuZiXFvUJMsO+gNcLy
 bfYWhWvrICdK+WYU5aPJJxgdzN5f5RV8teyOE9XFC9canILgc8hYUxfzvlIcBrGpeBQk5KvBqiH
 oHH0UThsbT/gaE8Atx39fQmgW4kPaqoKE8/N2o8lbBRrPWvQq1cew46RPhUWsxi2qHHxDIkQ/6k
 A6w7Gx4LU0LhSUTnil1TOfubvtyeWTdvWhSBmsmKH0QTE4Ww9N8YbS4FCUkrAA8yZBJ0Rh9X4wg 10e6HI9o/y1DVzw==
X-Mailer: b4 0.14.2
Message-ID: <20250819-maple-tree-v2-4-229b48657bab@google.com>
Subject: [PATCH v2 4/5] rust: maple_tree: add MapleTreeAlloc
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
X-Rspamd-Queue-Id: 11D8140010
X-Stat-Signature: dt3gpwb4xtf7ipa4icqrb1ph6juazruf
X-Rspam-User: 
X-HE-Tag: 1755599696-383259
X-HE-Meta: U2FsdGVkX18Rw0B+IQV6xqjjWJ+YzbvEFpgDhujctRku2iyMwbhUxRwYtZUIPEa/LXy3LCkE9Qt/ByF8lFSV2943hdNtagr96GJoHt/41aTBhmti+W4XDbEE2WYi5/mE/DhvLk72+/kgeY0kx2NpL3fBrqhwCIFqmQnUxvZbA7WnzmAB0BoiJ0Fde72brLXkft39OgjVigveXx9WQ7WXeeGJ7Ga22IBpEs1bw7yux9xVQ2lAlfOGu65JH4yFzxft8l61xCN6H5J+Uv4bDKVJUjE9aeHlzgHTYDaRPrxr8IZcuxTsJu93vtVsznGiyNCXlIkvcCvd17NVBX7rM94s/JGRblb32U91w8HWspygmh2zVYSa79QXmAiCOOZHqpK82Tl37vFwVcMNIFNCDIhB6P+yJbDvf/4mTr4YnBZqGA1SO78EJX4IL6SDKMwFw5+xqYdVA8w1oxa3fljMcknR4C9ebqq3HwFwyRphQ0IPXD7tEdc7yHTmN7tdIT1aeM4hbW3x/TRC+Fbajx6YKVY2m4ErDrd7AtpKjFvdfcmlixWpn/obaT0OR2SLFMu0vMjSPbtQfnLFxsEZY9uK1GTBjTCUOgMCTPwzma9aGg4Gln/IHmXfN3Use4gRVwbZ75Mlg0ANvzXuT4c/dVFny3WGmXaPoqEPsP7qyHwX3+jAnznrKBHPDEhiDUNaDaBEnm5WqNCg4F+z07AYIq0+0IX4Gt2jnKNFw7Vn8Zh6/DaN64kg4WAJJaiI9vVJqztEAYeSy0dPW10D5X4ixadaN7qsigues1l++qMLR5cEEvFhRgnjbZ/tFRQVX7HS+SM4ZoPPIW+0WJZfKflK1FKHkWSI35DypaGOjk6EshxkffTQFB4eBd/Sg50TmR393qorK8MIbNH+Axk+lzWmhsQU/IbGU1y3H+lZLKg0y6Hf0gZsYRMLza3RQnn7ZVDyPp6X/zDqdIgSDc/xtE4DZ6nUY5Z
 P8THTSpo
 rgaiXon+cO9Ov/FfaU44qtIVpS2k6/Vv7SjusfAWQ8zYeAZcA+mWCk7Eo2opAlfUomIY+1A8E+/uEc94eU5LFKQGymjwAOkz8aLEhE8VZGKbj1YUJ8AwstrsLuvNtO0KDQR8NgGP+b/FgNmahd7LN1dlyN9cwIeX3AMwlJP0RTneW9HHotEubF4e5zcLCZw22rajOO2+GKtXyNdszr1LdAztxTOc50pFlcKzYHiNhFqONl/EOfmx5F26f6xERQtYco/Dr8r3dScDgtTUHT7ciWH6ugtKhDqj+y9nNc2vJobkS7lJk6J6HGCAVgCcDESxwzny6nh/16pd4wIAZAmua40yIWRlxg4wnDvrlDOJM87q4Bau8SuHUriod7W2b37iaNOZc8Uis2ltY1ztGbfO13B8aymKRdaHojrkaCN9iQmaPjLm0RAHZSaQKupUr+kOuyNGd8JJvLXSd8UxGXuBF4DSnxZ2vSTq80uYrKr/jftus26Oo6z9rFO90D1l/h5jTiBOCqvGew8gTW4WC3srMgeSkfSKaUh3toATcGdFw5NwN7uyCgVs66KN/ERiVyo+P3yliyM2jUe2WPNV/7iVJDbR14830RwmWHgic7ESjOk+sM1CBnwJ+s+aV8/p5/n58fCQTwIV17idLM6/M+6f1w+0bWjcKjVgvq182XkYFbSVDJ1LE7Op8PxAiRQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

To support allocation trees, we introduce a new type MapleTreeAlloc for
the case where the tree is created using MT_FLAGS_ALLOC_RANGE. To ensure
that you can only call mtree_alloc_range on an allocation tree, we
restrict thta method to the new MapleTreeAlloc type. However, all
methods on MapleTree remain accessible to MapleTreeAlloc as allocation
trees can use the other methods without issues.

Signed-off-by: Alice Ryhl <aliceryhl@google.com>
---
 rust/kernel/maple_tree.rs | 158 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 158 insertions(+)

diff --git a/rust/kernel/maple_tree.rs b/rust/kernel/maple_tree.rs
index 17e4d8586ebad56aee87a97befdfec5741f147de..1a32960e6e721ca32ca45d8bb63fcffedeae3424 100644
--- a/rust/kernel/maple_tree.rs
+++ b/rust/kernel/maple_tree.rs
@@ -33,6 +33,26 @@ pub struct MapleTree<T: ForeignOwnable> {
     _p: PhantomData<T>,
 }
 
+/// A maple tree with `MT_FLAGS_ALLOC_RANGE` set.
+///
+/// All methods on [`MapleTree`] are also accessible on this type.
+#[pin_data]
+#[repr(transparent)]
+pub struct MapleTreeAlloc<T: ForeignOwnable> {
+    #[pin]
+    tree: MapleTree<T>,
+}
+
+// Make MapleTree methods usable on MapleTreeAlloc.
+impl<T: ForeignOwnable> core::ops::Deref for MapleTreeAlloc<T> {
+    type Target = MapleTree<T>;
+
+    #[inline]
+    fn deref(&self) -> &MapleTree<T> {
+        &self.tree
+    }
+}
+
 /// A helper type used for navigating a [`MapleTree`].
 ///
 /// # Invariants
@@ -364,6 +384,107 @@ pub fn load(&mut self, index: usize) -> Option<T::BorrowedMut<'_>> {
     }
 }
 
+impl<T: ForeignOwnable> MapleTreeAlloc<T> {
+    /// Create a new allocation tree.
+    pub fn new() -> impl PinInit<Self> {
+        let tree = pin_init!(MapleTree {
+            // SAFETY: This initializes a maple tree into a pinned slot. The maple tree will be
+            // destroyed in Drop before the memory location becomes invalid.
+            tree <- Opaque::ffi_init(|slot| unsafe {
+                bindings::mt_init_flags(slot, bindings::MT_FLAGS_ALLOC_RANGE)
+            }),
+            _p: PhantomData,
+        });
+
+        pin_init!(MapleTreeAlloc { tree <- tree })
+    }
+
+    /// Insert an entry with the given size somewhere in the given range.
+    ///
+    /// The maple tree will search for a location in the given range where there is space to insert
+    /// the new range. If there is not enough available space, then an error will be returned.
+    ///
+    /// The index of the new range is returned.
+    ///
+    /// # Examples
+    ///
+    /// ```
+    /// use kernel::maple_tree::{MapleTreeAlloc, AllocErrorKind};
+    ///
+    /// let tree = KBox::pin_init(MapleTreeAlloc::<KBox<i32>>::new(), GFP_KERNEL)?;
+    ///
+    /// let ten = KBox::new(10, GFP_KERNEL)?;
+    /// let twenty = KBox::new(20, GFP_KERNEL)?;
+    /// let thirty = KBox::new(30, GFP_KERNEL)?;
+    /// let hundred = KBox::new(100, GFP_KERNEL)?;
+    ///
+    /// // Allocate three ranges.
+    /// let idx1 = tree.alloc_range(100, ten, ..1000, GFP_KERNEL)?;
+    /// let idx2 = tree.alloc_range(100, twenty, ..1000, GFP_KERNEL)?;
+    /// let idx3 = tree.alloc_range(100, thirty, ..1000, GFP_KERNEL)?;
+    ///
+    /// assert_eq!(idx1, 0);
+    /// assert_eq!(idx2, 100);
+    /// assert_eq!(idx3, 200);
+    ///
+    /// // This will fail because the remaining space is too small.
+    /// assert_eq!(
+    ///     tree.alloc_range(800, hundred, ..1000, GFP_KERNEL).unwrap_err().cause,
+    ///     AllocErrorKind::Busy,
+    /// );
+    /// # Ok::<_, Error>(())
+    /// ```
+    pub fn alloc_range<R>(
+        &self,
+        size: usize,
+        value: T,
+        range: R,
+        gfp: Flags,
+    ) -> Result<usize, AllocError<T>>
+    where
+        R: RangeBounds<usize>,
+    {
+        let Some((min, max)) = to_maple_range(range) else {
+            return Err(AllocError {
+                value,
+                cause: AllocErrorKind::InvalidRequest,
+            });
+        };
+
+        let ptr = T::into_foreign(value);
+        let mut index = 0;
+
+        // SAFETY: The tree is valid, and we are passing a pointer to an owned instance of `T`.
+        let res = to_result(unsafe {
+            bindings::mtree_alloc_range(
+                self.tree.tree.get(),
+                &mut index,
+                ptr,
+                size,
+                min,
+                max,
+                gfp.as_raw(),
+            )
+        });
+
+        if let Err(err) = res {
+            // SAFETY: As `mtree_alloc_range` failed, it is safe to take back ownership.
+            let value = unsafe { T::from_foreign(ptr) };
+
+            let cause = if err == ENOMEM {
+                AllocErrorKind::AllocError(kernel::alloc::AllocError)
+            } else if err == EBUSY {
+                AllocErrorKind::Busy
+            } else {
+                AllocErrorKind::InvalidRequest
+            };
+            Err(AllocError { value, cause })
+        } else {
+            Ok(index)
+        }
+    }
+}
+
 impl<'tree, T: ForeignOwnable> MaState<'tree, T> {
     /// Initialize a new `MaState` with the given tree.
     ///
@@ -480,3 +601,40 @@ fn from(insert_err: InsertError<T>) -> Error {
         Error::from(insert_err.cause)
     }
 }
+
+/// Error type for failure to insert a new value.
+pub struct AllocError<T> {
+    /// The value that could not be inserted.
+    pub value: T,
+    /// The reason for the failure to insert.
+    pub cause: AllocErrorKind,
+}
+
+/// The reason for the failure to insert.
+#[derive(PartialEq, Eq, Copy, Clone)]
+pub enum AllocErrorKind {
+    /// There is not enough space for the requested allocation.
+    Busy,
+    /// Failure to allocate memory.
+    AllocError(kernel::alloc::AllocError),
+    /// The insertion request was invalid.
+    InvalidRequest,
+}
+
+impl From<AllocErrorKind> for Error {
+    #[inline]
+    fn from(kind: AllocErrorKind) -> Error {
+        match kind {
+            AllocErrorKind::Busy => EBUSY,
+            AllocErrorKind::AllocError(kernel::alloc::AllocError) => ENOMEM,
+            AllocErrorKind::InvalidRequest => EINVAL,
+        }
+    }
+}
+
+impl<T> From<AllocError<T>> for Error {
+    #[inline]
+    fn from(insert_err: AllocError<T>) -> Error {
+        Error::from(insert_err.cause)
+    }
+}

-- 
2.51.0.rc1.167.g924127e9c0-goog


