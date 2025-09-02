Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4CD5BCA1009
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 08:35:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0467C8E001B; Tue,  2 Sep 2025 04:35:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F12FE8E0005; Tue,  2 Sep 2025 04:35:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB3DD8E001B; Tue,  2 Sep 2025 04:35:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C1DC18E0005
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 04:35:30 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6DBC7160B24
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 08:35:30 +0000 (UTC)
X-FDA: 83843651220.15.3611D64
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf17.hostedemail.com (Postfix) with ESMTP id 7B12E40003
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 08:35:28 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=bTV4jG8z;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf17.hostedemail.com: domain of 3T6y2aAkKCM4u52wyBI1508805y.w86527EH-664Fuw4.8B0@flex--aliceryhl.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3T6y2aAkKCM4u52wyBI1508805y.w86527EH-664Fuw4.8B0@flex--aliceryhl.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756802128;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aIl0NUntKEgDp6p26JUsJurVmE5xFk9G5xfjA7uAipw=;
	b=NSg0BbRMULPdfe3rjfn9x7MK8ANpmNybkJCTXwhudkJC7C5Aa++Sq8Tjf8ZxOCnnTLV9eu
	Vcr1K8uvXe+i/YSfjzVTkPsTpVVgx9vhvcCY3fpJJFWNY8bn05x7p0cOpHjynRcUcHdKgD
	2Hxryo2M0YSN0uD5kWCnhfc2w7c7W2U=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=bTV4jG8z;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf17.hostedemail.com: domain of 3T6y2aAkKCM4u52wyBI1508805y.w86527EH-664Fuw4.8B0@flex--aliceryhl.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3T6y2aAkKCM4u52wyBI1508805y.w86527EH-664Fuw4.8B0@flex--aliceryhl.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756802128; a=rsa-sha256;
	cv=none;
	b=S5kaBys4yd6bUs7wnvAEPJUfNOYdfFo7FXBVtzlOh8lwMo/VIHJGltPmyiMO2BuIGSqvDv
	R711V0Hf5rugynZzxVs9aUCrCnw3UxRhdgE3CcsCkQGzvfRR/q3r46Oo/MI42TLjF6lZim
	o7COybrnSS7e5fNaeapQFKYBdo1/z7w=
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-45b9c1b74e1so772145e9.1
        for <linux-mm@kvack.org>; Tue, 02 Sep 2025 01:35:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756802127; x=1757406927; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=aIl0NUntKEgDp6p26JUsJurVmE5xFk9G5xfjA7uAipw=;
        b=bTV4jG8zWyx3sREu4vDrnxpVRtfvNzuOpiFDEAcKeqqCYNWwww+qLIlZWZi9p2njik
         uCl7p/WEiIrcLxPEs6LJZpV6vK/GUvTkMlXzpI8iXAiH/V4fPG7sHriMsWkn+vSKaFNG
         ry+WmR72L72B4eZ7gxQ8jDuFSo59wXBAvErPwO/LZ57dazuJtRcWADaP7h0guTrfBnOi
         IvqsBmURBHcIInZ/uZThk5dgS3gsgzYAy56/IBnLMoWW9R+xyWbr0ch7nGoLpWntvnQY
         EtiS1pwFxSCRoPpQdQ5xrQMJUHAJab2Ce4JlyhfAL81ga7MSVyIg5nRqGORms+VitIg4
         9TQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756802127; x=1757406927;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aIl0NUntKEgDp6p26JUsJurVmE5xFk9G5xfjA7uAipw=;
        b=maYM03x1/KCK36/vRW8i3kvhRqEMeJKJvE/hDqFJiglgEfLVFQdTjXaKCsszl+5z7B
         c7frCIZ1SkifrMI7mWNJoCta9CTDmIxT+yN8LjVXjsSthLbe/WfCxpg+C2G1wAer1bEy
         KLkx799dtJFovk8ewzc1TkZmGhh1u0ksA0zy6s/y4dd5VtCwD6nNB/UUvl3eod5MR5bl
         ImVIEpND7hPmCFDQvpzm4T7Vnm7lCQQx9u/iYPkh6WtHBcKYbKHhU5PwutUJjJAaqZeW
         EQ4Fm/2hX/IFFn6fdGIuW3aINmetu2EnGASs2h+nKsLopgQEc1k6FbcGipDGeGDjHahv
         PyVg==
X-Forwarded-Encrypted: i=1; AJvYcCXtEv7nA5DyJzvYuC7UK3BienqAREWJyFGl2SXbK2jo+CO6B9NjzgUfof13WiEnvk22+lUekMsVbg==@kvack.org
X-Gm-Message-State: AOJu0Yyx/w6B5q1tBdMEkLZUOXPf/Wb+kn7KSFH+jQKsBY/veMRoEu7X
	cs1DhDW0x1NY5UXRt8SKD3Q6EVBTMFy71tdIIYr97flXmSR14h5i7u4XWoIQV9YrCx7mtEnknx0
	u4h0SXsb6+ZK1RL50Pw==
X-Google-Smtp-Source: AGHT+IEUSQM7nZXMzj+AIYbd6XN4GdZq1gsDpWixNjdGWvgeC8W+TzZqnS/0jc0vD0/bKpKJe9KRqMdH7F9ulyU=
X-Received: from wmsr6.prod.google.com ([2002:a05:600c:8b06:b0:45b:7a6f:5dc0])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:1f84:b0:45b:7ce0:fb8a with SMTP id 5b1f17b1804b1-45b8559bd2fmr85044535e9.35.1756802127114;
 Tue, 02 Sep 2025 01:35:27 -0700 (PDT)
Date: Tue, 02 Sep 2025 08:35:13 +0000
In-Reply-To: <20250902-maple-tree-v3-0-fb5c8958fb1e@google.com>
Mime-Version: 1.0
References: <20250902-maple-tree-v3-0-fb5c8958fb1e@google.com>
X-Developer-Key: i=aliceryhl@google.com; a=openpgp; fpr=49F6C1FAA74960F43A5B86A1EE7A392FDE96209F
X-Developer-Signature: v=1; a=openpgp-sha256; l=6643; i=aliceryhl@google.com;
 h=from:subject:message-id; bh=4uYv4Iubagq9TjaCiZNut2UuDeIkZERacgR6dwoufHI=;
 b=owEBbQKS/ZANAwAKAQRYvu5YxjlGAcsmYgBotqxK9LELnU0l7nr6Ds+UR7jzifKGecSBsFYX6
 GjCSHj4OhKJAjMEAAEKAB0WIQSDkqKUTWQHCvFIvbIEWL7uWMY5RgUCaLasSgAKCRAEWL7uWMY5
 RivPEACozBYZQe8keKEhBEblZVlxG9uN6kQfOkkFjspfe41X5Ikn0hBIloZvsK5jq/peLsY7xzj
 Vw2Zl8ahbagtvMbHy2iUIzRw/vGBBGV93VmxtQPOxL31NMi7YzBBpvEQlx3sZbL1qEOqJAgfx/t
 CCtGcH08JoB2YdIHYWn6etDM21QIeJav8mVBfSemvZ6IYmd9V8WJJFrULQ2orZzgU8cvtnGBTMl
 7pffN32gyEbvwwEKLTjk1bOYbJUORkRf0Av5CW9P9HOVBPxqxB2tlv1pftqT8Qy9uEcEDg6BSUx
 VvR6qFyD+QoNkLk3mUdgdFiIV9cKZLyI7cA80dnpvlYtqeWMRhBPaQsj8tj47t7P5Vh0bEuFSou
 SkFGv78+4CdvMMd3CwQxUPPx3P+qc5ZB57Tf0GucXv2u6fiDljO40HTMbLgHZrJ4u8jy8wIbM5g
 u864horwELA7jXzvTdEZQ2+KlFo9rPwuWxCNiL7zx/+bFfyb6tG3GSJR9AxJQXS24fJLWq8QSXY
 Xou4vc+3SJUwsF8DClEyudG2FhB9+pYRY3k0RQt6zggxrfw3yjk1BU4mtpYb2qWaXF3k3qc0SYY
 CFZWL+apaExJqC3X2pVAdvqBfoEo9OPKgdaMVSihvO0A7sQyz0P1RjyFHLGxbd4x6AcxU83/RAz pkLtbiY3v7g59fw==
X-Mailer: b4 0.14.2
Message-ID: <20250902-maple-tree-v3-3-fb5c8958fb1e@google.com>
Subject: [PATCH v3 3/3] rust: maple_tree: add MapleTreeAlloc
From: Alice Ryhl <aliceryhl@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Miguel Ojeda <ojeda@kernel.org>, 
	Andrew Ballance <andrewjballance@gmail.com>
Cc: Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	"=?utf-8?q?Bj=C3=B6rn_Roy_Baron?=" <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, linux-kernel@vger.kernel.org, 
	maple-tree@lists.infradead.org, rust-for-linux@vger.kernel.org, 
	linux-mm@kvack.org, Alice Ryhl <aliceryhl@google.com>, 
	Daniel Almeida <daniel.almeida@collabora.com>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 7B12E40003
X-Stat-Signature: cb4mfft48s5xcizm85tbfheiugwgamcu
X-Rspam-User: 
X-HE-Tag: 1756802128-975705
X-HE-Meta: U2FsdGVkX18RkRu3As8sVkvsKmj/q+n6xypThZxTNijt+Y/ozX8Bc5KdPi8CziQqlYUXViG5VhMDgleRbFupDH2P7ZK/I9gai31ldeRm7l4+HCESsdkBbzNuNCcf6HL6+Vt8Zo7kQZLAPMq/7lbdbD3xuVBY6kns638SKqLDtogJpLZFmL4ifUy7vUBqgj9fCS6xoo4tufYq4lKTOB9YTJUvCQ4YRDUHmE+oGw1B7FAzQtMSJyC3TDXAnsksrRACquRarJKTYcqlmXU2yOqIBbgNO5/hArH1Blr4NIlmGKrI/i7ImyXW5SbX6ff8Uot4WVmSDlrg4a4OMMxokIXHX/uSbh0vA+3+tLe0ewfrvehWPnvy52NgPVufbOO81jTrBXGhF76cEf10Z7qf4JJSt/A/NPDFoFQXDdkHf4BU1Ogc4gnmKtFtEZ9H3U7dgrErK7ipaS6Jg5KQf/Eyg+rXyUXEWNylUKLANgKUA950YBhWjrr92bW7KPJ1n0qWrBCkCwlzhkPuZURitnfJMHZkG7jqoGNz0Wxk0napsbjYTdidLraTIWnSHchwkr5FLr7ZLihFDe8NjwmAMSeGfY9EXAgZZpXt0VqEVTSYHpttu7AG2yjmD9vKEnD9SeLm8qHpDAoZ3Q3RRuJWnLCnpaR2EcGnxzwlayzLkIe1JyiGz3763OESgYK724DECgsmk7zE6KSny06l4JZYIMK/idjyeMJ5GRoKseMLCgfWbDnnA8xmLoT8yMJKyjq+fo6tYP4Jg6MCDx9YJcFp9QqGqbyj8TQEd20bIwfXRJs91dK1v18hyJXpN+J8sT/QJB66za+DR44xU+re8hXzTY0SiF3jbYljGkc6LI+9gryELloOoChLrspaoPL0FDqCwanTWbjnRJQkogK4Bnojh2I0XPZJ5Q33GCh5NMbbfKAVQYtNV61JeN1/ebdnissa6S4d3hGj5TPIEMSWDmm0C7TxT9l
 gMWtI27R
 Mmbm4iy2oBdwwbcKV+3OEyUAKGUVvuzxkXK5ctvkyTUEd2SQDg7EjPosDlxbAmA0hG4UeVxTslY/+Ndm/xdAHDTPxSWNkP3lo0q9lsFsdK8pzxvLpCULmzYs6rtPxfIK1+35OMIDk9kOtvTDxwnWfTxgSgG9de06lWAS0ApAYOSH+bMxg85xqt+fdwe6IPM8v/bRWChMwFVrPesTG5KIGAoNGbHnuM694ZOkTwjzwAWl5SIWQaQ3EjYUt71fFcoYYT/dbYyM22Yur2I55fXzzfasQtTdbWuRtGuDTh6FRfVwBR8gz93Wsz+wpvkxURTQYiVn0Tk9p+d8Av/z9UCiantouopSSiZXEHHlf4M66ISH2KpmWPZwnIXHdx9CaT8kR/TlwoV6h6nA7kbRQ+fe2WepSRYDbPtmZzL+h3/cohb4wqUpYEc2wynQJKfSTncHtcMSBOFIrpHMHJEd2e2UcZhIYioKp+zsMe2bxZipkILxjAarqY5VipyMZDpj6W7xOt++oY6ufTDTDTUuQcks/hIwpEOm6s+snY0EKSoCI+2aH58/ybKL4ixDfFsqgjI8icxKxt0HyqIlwULvTQaWS3sg6e/pM3CXiH9kMJ7d6Zaz4/+rsRnaA2ZvDImBr1rB0U6afA6aHO7fBBIFYNTmu9EEUtHU2OpHUHRr36BjbOa1VB2Kf6p4JESdOQUciopf6cYJ7L4HDR81rNTY8ZvstTraFy4xuyY3vYxUdrJL/IK64CBiSPFRsfUEieMGw1cYwFjd+T6GKAk4wzmg=
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

Reviewed-by: Daniel Almeida <daniel.almeida@collabora.com>
Reviewed-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Alice Ryhl <aliceryhl@google.com>
---
 rust/kernel/maple_tree.rs | 158 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 158 insertions(+)

diff --git a/rust/kernel/maple_tree.rs b/rust/kernel/maple_tree.rs
index 24b674ce07d0481702eccd86a7920f94ca000108..31b6c13d08efab23f7fb20bf97e36c33bf9f6ad9 100644
--- a/rust/kernel/maple_tree.rs
+++ b/rust/kernel/maple_tree.rs
@@ -32,6 +32,26 @@ pub struct MapleTree<T: ForeignOwnable> {
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
 #[inline]
 fn to_maple_range(range: impl RangeBounds<usize>) -> Option<(usize, usize)> {
     let first = match range.start_bound() {
@@ -359,6 +379,107 @@ pub fn load(&mut self, index: usize) -> Option<T::BorrowedMut<'_>> {
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
 /// A helper type used for navigating a [`MapleTree`].
 ///
 /// # Invariants
@@ -488,3 +609,40 @@ fn from(insert_err: InsertError<T>) -> Error {
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
2.51.0.338.gd7d06c2dae-goog


