Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC4EDC43458
	for <linux-mm@archiver.kernel.org>; Sat, 11 Jul 2026 13:13:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9EBFF6B0005; Sat, 11 Jul 2026 09:13:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 99D7B6B0088; Sat, 11 Jul 2026 09:13:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 88B116B008A; Sat, 11 Jul 2026 09:13:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 61ACB6B0005
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 09:13:16 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CECB91A0188
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 13:13:15 +0000 (UTC)
X-FDA: 84976536750.19.897E9A5
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf26.hostedemail.com (Postfix) with ESMTP id 0456014000E
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 13:13:13 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=PzBTIHNN;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf26.hostedemail.com: domain of 3Z0FSagkKCIwq1ysu7Ex1w44w1u.s421y3AD-220Bqs0.47w@flex--aliceryhl.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3Z0FSagkKCIwq1ysu7Ex1w44w1u.s421y3AD-220Bqs0.47w@flex--aliceryhl.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783775594;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=n+knwv7wId+1eUW5sB+uND4i/4j6+R241YuCQ9i0Ajk=;
	b=7qjUza6VzddenHwLRoznAibUeqCIv2jL3W9PHOqeqhX6qWCPH2p3aIUj0QTEdcNsxsTLV4
	rX5Ny/EmBxigFy/2O3dxPaHqG8k8BoryLg6uK7Ljq8nECetJt/Bp6QcbGFx4dD8d+i0TZg
	nVm5RX/ibYd7zIfUIgnDAt79YngLfso=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=PzBTIHNN;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf26.hostedemail.com: domain of 3Z0FSagkKCIwq1ysu7Ex1w44w1u.s421y3AD-220Bqs0.47w@flex--aliceryhl.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3Z0FSagkKCIwq1ysu7Ex1w44w1u.s421y3AD-220Bqs0.47w@flex--aliceryhl.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783775594;
	b=H466EyH0ofiNW6UqbvX03+60vUh7dX0soit7a2IgGGAioeZmGSUnfKiNXkzWrNxHnodMfJ
	q+YwjeGF/W59rGi1jEwpc93xeWnpMv3KIx9rJbb/5XN/N1kRNGRlNfKcI4r7Dh07KDple4
	sXh4iNBnRL+/eYlYFHo7fYOKseLapUg=
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-493f75ebec5so6939315e9.1
        for <linux-mm@kvack.org>; Sat, 11 Jul 2026 06:13:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783775592; x=1784380392; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=n+knwv7wId+1eUW5sB+uND4i/4j6+R241YuCQ9i0Ajk=;
        b=PzBTIHNNXtPXerB8AZ0sPlBSl0AnTPXaz5BSbmH+2qMkiCPcYKlTFRTUUSh8uWs/+R
         f7I4WCvtWcwqfC65UJ4zBbqgocuJ7Te7bH9yymkq0d442ZEbbZ3kebNnl0CCK786AYzz
         /1bM8jcOMyyuI1l0zEmeZ7v5LfkSHDSDzXQfjQ6jmDgqABRe4EZuKNxhmyvqUz8gyICz
         9QoArGNGGdrpHXWMSDfkoi5rskQc+V48hftxD2egQDyrB1yf8U97EGdcJQUAnaRU2+nj
         r1T0B+ETfY5ARk871yK/Zc5xff2fzbM2ggzkIqV0VctCY4RK52xIP0OpKUuTYNKBVWQo
         PA1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783775592; x=1784380392;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=n+knwv7wId+1eUW5sB+uND4i/4j6+R241YuCQ9i0Ajk=;
        b=VMLMksXxEV3kMev18ZJlccV6qN5rx+MsBD7710zmSzjcriNuAb9+g4QbbThxcDP/0y
         w8PgrjOrSqwxnayYzifc51o5X+26iVIRuhlrYRoQPS6FaN9lWr6xNKrSn/i7KQiiRmU3
         JLJ+dUnQtj1c0mr3gB7mbf2Ao8/HYwpsErEYmsxL5AU1ppNjRaB5zLUSaLRAhCTnluFd
         5QMmAq0/wUuZgk86W/yHtVHQ6eOktyBsaIxRxRvSIosBDek60SA9IItB1uBTEQLGcrvl
         5qgFC8c7+KGhcLUbBQ6k8cbqv5pzI2N3hKXns0OtgS1HRtxptHvgldJxy2OJtK3EqEDs
         u6cA==
X-Forwarded-Encrypted: i=1; AHgh+Roes8xoZy5GQDYJHwY/BTBrFBc2RtJ9Vm3G8IG9nO/l+KZEEXfNyQdYCwRSVkWlOtz3LLYaGDD3hg==@kvack.org
X-Gm-Message-State: AOJu0Yx2/sYtEgg4fHvPP/fCDaWy0Jud79+IUjFSe31cfuacFD0G+GdB
	sRYBA7tsQmXvDi/KHaxkybTv969ENoxow3UfPoWzl294uMllWv1hvkhKiEyzPFK9Pric/UBmxVi
	F/39W7Ih1OQ0l8uakvw==
X-Received: from wmpr37.prod.google.com ([2002:a05:600c:3225:b0:492:4527:3dee])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:4f8a:b0:492:43d2:9e6e with SMTP id 5b1f17b1804b1-493f87e9bd4mr24086725e9.9.1783775591956;
 Sat, 11 Jul 2026 06:13:11 -0700 (PDT)
Date: Sat, 11 Jul 2026 13:13:05 +0000
Mime-Version: 1.0
X-B4-Tracking: v=1; b=H4sIAGBBUmoC/x3MTQqAIBBA4avErBtQoYKuEi38GWugVDQikO6et
 PwW71UolJkKzF2FTDcXjqFB9h3YXYeNkF0zKKFGMUnZiCnGA894Exq+Tp1wMMJZ4ZQhb6GVKZP n578u6/t+k/oinmUAAAA=
X-Change-Id: 20260711-id-pool-move-bitmap-5b0dc0d2befc
X-Developer-Key: i=aliceryhl@google.com; a=openpgp; fpr=49F6C1FAA74960F43A5B86A1EE7A392FDE96209F
X-Developer-Signature: v=1; a=openpgp-sha256; l=4839; i=aliceryhl@google.com;
 h=from:subject:message-id; bh=Ehox8SAP1hezi8192+oo1JkH+FPtt5zIvzxy9/kfZGc=;
 b=owEBbQKS/ZANAwAKAQRYvu5YxjlGAcsmYgBqUkFiYB1ZfFNogUbkqBSFnOdU9xXdxT0rGba7U
 So70gI9pUWJAjMEAAEKAB0WIQSDkqKUTWQHCvFIvbIEWL7uWMY5RgUCalJBYgAKCRAEWL7uWMY5
 Rm00D/9Jy7mPt/8dcJQvJK/skF38LpJgSMTWFsYw/AWmfs9TJMRPjkmQmyNNfqxju9XfPmgo2Ng
 4f92LVU6u6cnVIiz6zzs/970sUT6iTZF+BioI34VANCeFyKsQJjnJmLqBO8AoO3tJuT0rLP6tIk
 NiiZcChneS5Jx+WrujfRAcFHxtmDwiNhFgLVB5ZzyJYxxXHi9xTWEwacglVJuW9EecRzxo9Td1S
 JI+ZQY3fENIvYDjj9qznHukXVaSbNH/KQXW6jTRQjFgRK5RjXJXrKmPTg3v5zGSUHiffi2x21fI
 3t8R6uYcqDOAjKDbBAlazdr3ls/di1FE5jYU3NgSkM7ijmr6ASL9ZzhQv6UxMe7pZC8eQtaLkQv
 uIPbFHnX/WWx+/tVEmHL9hWKR4SRrlacaijRPMYScxqot65w6NMiXbeQ6rwBwiNioSv7puiqbAp
 cgc+74Jv+L2ZMqjZmeQZ11G4ZjmISzDkE4DH9q+NBbCnou1Yy+jYy6NHyEwEv70D1Q43HGRTj+B
 oXCuKfAnxqgGvky/hudvJL0+K9TazU8+mJ6y7rqdRr0YkEDjRCOja2I/3UvXEEGUeC9TXj8twj9
 yXet1dlKdG7ZEUWYoY3x+d7pxYgheuorbFJGE+A7pNIcF5WTAKo1OspsqLm3XuMLZujHd5n+iCK HYfZm7sK9PwE96g==
X-Mailer: b4 0.14.3
Message-ID: <20260711-id-pool-move-bitmap-v1-1-cd5b7efc2c12@google.com>
Subject: [PATCH] rust: bitmap: encourage using xarray/maple_tree instead of id_pool
From: Alice Ryhl <aliceryhl@google.com>
To: "Liam R . Howlett" <liam@infradead.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Andrew Ballance <andrewjballance@gmail.com>, Burak Emir <burak.emir@gmail.com>, 
	Eliot Courtney <ecourtney@nvidia.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	John Hubbard <jhubbard@nvidia.com>, Matthew Wilcox <willy@infradead.org>, 
	Tamir Duberstein <tamird@kernel.org>, Yury Norov <yury.norov@gmail.com>
Cc: Alexandre Courbot <acourbot@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Benno Lossin <lossin@kernel.org>, 
	"=?utf-8?q?Bj=C3=B6rn_Roy_Baron?=" <bjorn3_gh@protonmail.com>, Boqun Feng <boqun@kernel.org>, 
	Carlos Llamas <cmllamas@google.com>, Daniel Almeida <daniel.almeida@collabora.com>, 
	Danilo Krummrich <dakr@kernel.org>, Gary Guo <gary@garyguo.net>, Lorenzo Stoakes <ljs@kernel.org>, 
	Miguel Ojeda <ojeda@kernel.org>, "=?utf-8?q?Onur_=C3=96zkan?=" <work@onurozkan.dev>, Trevor Gross <tmgross@umich.edu>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	rust-for-linux@vger.kernel.org, Alice Ryhl <aliceryhl@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Queue-Id: 0456014000E
X-Stat-Signature: cfrohfio411rsqfic7b6cyp1myoc7pqg
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783775593-86520
X-HE-Meta: U2FsdGVkX1/K3+CnTMW0zC86TjEWVfENHvihoIGkBxKItiXEMqqu5rf/8soH3+9AAq9KPBjTYWx+xUC+HJo0kiOrmk8JgCbKoBZqRL5x+k3Ou0MC7gibnGQr0zma2WceibB3KwlocgqCraBI0gjvFqJ5MnsT5UgeI0/6QVxzDpbZ4taABByhv1OGZQYAunjFVodJmNSJT/t8RlUd+cuZTOIgQBmwkbgjHY992ymClbqLXQe+gDDD1zJ3X2XKtsWlgpRYMUKAjD+M5VwFfsLHVH/q6BFphrzClfrLvUp/uGQuPiYGP14Ekjp/+l3hz8s4IkVkuCmzqbhU7srjk0B7wNQsfyP7Eji5S8IrBvxXqsCGpFEqYI72oYTeSHnZzFP0HEmMBmSYaFO4osuH3jWSWcvhd4KO8dfR1WjWUJSnt217Bsb4ubyYETimnV+SjbBDk3FYq5Gu6B5V95MqFUHnP9qs85kawXohYehZ/vQijhHzcM4ClvKg+lz7avkz4vab38GJDGGqQExaeooMWvaZlQQ95J7JL58Q3m71Qo1AW98TBBw+zewJfMK7BA6/QWjDtVKbk+DOtMfKHW5BYxRzWdutFbrPtSmPQ5ruZy4g+EVAEGu/kbmnewI9meQaimxtqwpaJKchUQy5vQyPMLhi1tFlMsyxlKieBfgHd+Weddx2UndAFmD/BDAUQXdkwj7sfAOM98a0YgvM3PYfivBLhWmsXDNTygCh4NU4At9VRBXGlrl1N4RkYBp+nf57Z97MrtlajykUDSEg5kuSbOwTmPukq3+dD3cbwLA2N3uwhmPYQBp++ucEb8uIGcYQF2dWAoofiZaYF0KiEJgla2RegAIbrXUzUxrtzIYCPrxzAiFwhCvTp3kJdgbiLOeEvtx+vXxiVSmfk78+riD5gD8zrZ8Y0RyFG0dlxAstvtJWqlaFIswXzWf+Y9T4dA/sBVQiaGOKGfeDmM5LybAgNhD
 UGyq59fl
 7tB6Zillv2v7LXcAnPv5g8LpazSZKROo4ALLIY5PszgnvsVaS4SznTmjEKSMUu1gaLtJDv1xasA5pXS6tISoHX+K1dfWYqND8N9KezbnWnDrwiaHdm+N15bTyGBSD2ixE1IB2wk8Me+Qxqk2WyeYRufiuWpAlTFAM9+Gr+/2Hv83GXP/9MujfKKiNoYdcKNJZs4S0vomZm40ptmEOat4fqpK0uXiGkNw8z21jzLHJncMxUmBIcA9uvuQ2PH3VO7uu2tO/cEA/8cPtdVqA4chiL4VdPqAsV83tL5vVpqSlTonRkwhIZbCl9m+4P7n/qx8rjveVb6m+65xtRBoLNknxdeLFD3xRv9hZ/kGzQodHTnJNfgYT4DKCa+snm/RzP1lyOu/y0uGjcTZlNvHyBtS/youSkvLZB5dXvy+pHdtLOC2vxku8Kw/CS6shWL7dkO1F5oDzIQqtN87nB7j+jWJCq5D0k0YhRP9wGjMvkTwM+i5RyXRNomJc58yCyup+P0DE8zaPdF7vllpOpSapiADydu4BIo5HdeC8TCAn1cnPMMXslqgY/ylV5sx6LMuBW0Qld7hzloGw5rCDO87HcpIcMu0mCULAJG8INtiN635gIjD6WAova/qLhx6BkKEunj1BJA8g+zWf5nnHgABtUzX6q3Wbiiyr9gim3TPNoEQeaIJDzG4Pf5wjPKSFudlUGGBcnHUgOwpyYUhujtcNJv2gbpdeXes1TXED+zZcmV5BgC4ZndM167t2Z8n3CE8Trvu9+PV4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The id_pool.rs file was added for use in the Binder driver, which is
using a bitmap rather than the normal IDR implementation due its
specialized needs and performance/spinlock requirements. However, its
current name as kernel::id_pool encourages using it over other IDR
solutions.

To discourage choosing this pool when you don't need it, move it to
kernel::bitmap and add a comment recommending the xarray or maple tree
for generic IDR use-cases.

Please see the below links for the discussion that prompted moving this
file.

Link: https://lore.kernel.org/rust-for-linux/2026070334-dollar-hexagram-e49c@gregkh/
Link: https://lore.kernel.org/rust-for-linux/84bc8bd2-e292-4b84-9580-a1b5df4c5bdc@nvidia.com/
Link: https://lore.kernel.org/rust-for-linux/20260711063602.426311-1-ynorov@nvidia.com/
Signed-off-by: Alice Ryhl <aliceryhl@google.com>
---
 MAINTAINERS                         |  2 +-
 drivers/android/binder/process.rs   |  2 +-
 rust/kernel/bitmap.rs               |  2 ++
 rust/kernel/{ => bitmap}/id_pool.rs | 26 +++++++++++++++++++-------
 rust/kernel/lib.rs                  |  1 -
 5 files changed, 23 insertions(+), 10 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 4a8b0fd665ce..d80377d06c3a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4639,7 +4639,7 @@ R:	Yury Norov <yury.norov@gmail.com>
 S:	Maintained
 F:	lib/find_bit_benchmark_rust.rs
 F:	rust/kernel/bitmap.rs
-F:	rust/kernel/id_pool.rs
+F:	rust/kernel/bitmap/
 
 BITOPS API
 M:	Yury Norov <yury.norov@gmail.com>
diff --git a/drivers/android/binder/process.rs b/drivers/android/binder/process.rs
index 96b8440ceac6..eec417604806 100644
--- a/drivers/android/binder/process.rs
+++ b/drivers/android/binder/process.rs
@@ -16,10 +16,10 @@
 
 use kernel::{
     bindings,
+    bitmap::id_pool::IdPool,
     cred::Credential,
     error::Error,
     fs::file::{self, File},
-    id_pool::IdPool,
     list::{List, ListArc, ListArcField, ListLinks},
     mm,
     prelude::*,
diff --git a/rust/kernel/bitmap.rs b/rust/kernel/bitmap.rs
index b27e0ec80d64..ecf8f194cf3a 100644
--- a/rust/kernel/bitmap.rs
+++ b/rust/kernel/bitmap.rs
@@ -12,6 +12,8 @@
 use crate::pr_err;
 use core::ptr::NonNull;
 
+pub mod id_pool;
+
 /// Represents a C bitmap. Wraps underlying C bitmap API.
 ///
 /// # Invariants
diff --git a/rust/kernel/id_pool.rs b/rust/kernel/bitmap/id_pool.rs
similarity index 93%
rename from rust/kernel/id_pool.rs
rename to rust/kernel/bitmap/id_pool.rs
index 384753fe0e44..d6440ec8f60f 100644
--- a/rust/kernel/id_pool.rs
+++ b/rust/kernel/bitmap/id_pool.rs
@@ -3,6 +3,14 @@
 // Copyright (C) 2025 Google LLC.
 
 //! Rust API for an ID pool backed by a [`BitmapVec`].
+//!
+//! The id pool provided by this file is designed for specialized use-cases
+//! that need an implementation backed by a bitmap. If you just want a generic
+//! ID allocator, please use [`XArray`] instead. Or for use-cases that require
+//! contiguous ranges of IDs, use the [`MapleTree`].
+//!
+//! [`XArray`]: crate::xarray::XArray
+//! [`MapleTree`]: crate::maple_tree::MapleTree
 
 use crate::alloc::{AllocError, Flags};
 use crate::bitmap::BitmapVec;
@@ -23,8 +31,10 @@
 /// Basic usage
 ///
 /// ```
-/// use kernel::alloc::AllocError;
-/// use kernel::id_pool::{IdPool, UnusedId};
+/// use kernel::{
+///     alloc::AllocError,
+///     bitmap::id_pool::{IdPool, UnusedId},
+/// };
 ///
 /// let mut pool = IdPool::with_capacity(64, GFP_KERNEL)?;
 /// for i in 0..64 {
@@ -47,7 +57,7 @@
 /// ```no_run
 /// use kernel::alloc::{AllocError, flags::GFP_KERNEL};
 /// use kernel::sync::{new_spinlock, SpinLock};
-/// use kernel::id_pool::IdPool;
+/// use kernel::bitmap::id_pool::IdPool;
 ///
 /// fn get_id_maybe_realloc(guarded_pool: &SpinLock<IdPool>) -> Result<usize, AllocError> {
 ///     let mut pool = guarded_pool.lock();
@@ -134,10 +144,12 @@ pub fn capacity(&self) -> usize {
     /// ```
     /// use kernel::{
     ///     alloc::AllocError,
-    ///     bitmap::BitmapVec,
-    ///     id_pool::{
-    ///         IdPool,
-    ///         ReallocRequest,
+    ///     bitmap::{
+    ///         id_pool::{
+    ///             IdPool,
+    ///             ReallocRequest,
+    ///         },
+    ///         BitmapVec,
     ///     },
     /// };
     ///
diff --git a/rust/kernel/lib.rs b/rust/kernel/lib.rs
index 9512af7156df..8e7717bb8b9f 100644
--- a/rust/kernel/lib.rs
+++ b/rust/kernel/lib.rs
@@ -77,7 +77,6 @@
 pub mod gpu;
 #[cfg(CONFIG_I2C = "y")]
 pub mod i2c;
-pub mod id_pool;
 #[doc(hidden)]
 pub mod impl_flags;
 pub mod init;

---
base-commit: 8cdeaa50eae8dad34885515f62559ee83e7e8dda
change-id: 20260711-id-pool-move-bitmap-5b0dc0d2befc

Best regards,
-- 
Alice Ryhl <aliceryhl@google.com>


