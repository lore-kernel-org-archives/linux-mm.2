Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C94ACD6E5D
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 10:34:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8AC5A6B0005; Fri,  5 Jun 2026 06:34:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 883D96B0088; Fri,  5 Jun 2026 06:34:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 79A6D6B008A; Fri,  5 Jun 2026 06:34:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6AA2E6B0005
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 06:34:34 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 134104068F
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 10:34:34 +0000 (UTC)
X-FDA: 84845500068.21.0969B57
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 42FD74000C
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 10:34:32 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iGC2KChr;
	spf=pass (imf01.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780655672;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dFrQhcTjYjYlQDboe4vfQTAW28MKKhrj+2TnMlIO5uI=;
	b=ZfGolebmeVZkwDXUde0LQoFiDM39PqmlvlOy//sOu/H/bw15YFCz4cPqolPGG+qE23M3GA
	TDlAcUFdFbQFwbJm201Ztd9AbCtjS261HRb/OleQBRYSggXT4Tl3pg0ZH0KCtVVpm2ps9E
	cRwY2LZ5asXV/vnOhRWpSiu+JFKC2PY=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iGC2KChr;
	spf=pass (imf01.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780655672;
	b=kXnlwzgZOyH30nEbtwCv07OFtMGb75tWP3+8X/+wcCkVKsEiEtzQ3R28mQC4tHW3WKJUym
	Sw+pWpsoNAp1yXIlPGKQcQU+HTPsFuB5Zaf8thbmo2Ns2DBx3SsFLY9SldUkunLnfq4FBy
	KJSIoObXUfTXrgRwIAlrn0ya7vUWCyk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6940843A67;
	Fri,  5 Jun 2026 10:34:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AA091F00893;
	Fri,  5 Jun 2026 10:34:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780655671;
	bh=dFrQhcTjYjYlQDboe4vfQTAW28MKKhrj+2TnMlIO5uI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=iGC2KChr+cM2ShXwX3tEWOKqXt5ArIT5thwI9IvtSsOdSElCRqDB5wZzh4JJuHkPm
	 k0hqAYp/ZaOPUPhjIrphb10bvG3JyQcC/q1vkXtIN55OJMZS4QqO/agY3zwS9yOFYu
	 i1JJGQR2W25GI8iWhaSaR8/YGXqWzYH4FKEQmHa6C5NAOOdaorhiYzPU/FczqiFVvy
	 5c7x6vV+sSk9dx26IDFXsQ2l1a67/eSfiJioaiqEbNSauQSPHBvKsOKlnuJvGr52u1
	 Z61ZJZIS99KE/OB1HRZi3lRAwKJlrizHbL1CnaKH3/MIKcu3sNbKZP8rfTmVpwVTB6
	 NfED15UIHCS2g==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Fri, 05 Jun 2026 12:34:13 +0200
Subject: [PATCH v4 1/2] rust: sync: atomic: add atomic_per_byte_memcpy
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260605-page-volatile-io-v4-1-0e217d9bf11a@kernel.org>
References: <20260605-page-volatile-io-v4-0-0e217d9bf11a@kernel.org>
In-Reply-To: <20260605-page-volatile-io-v4-0-0e217d9bf11a@kernel.org>
To: Alice Ryhl <aliceryhl@google.com>, Miguel Ojeda <ojeda@kernel.org>, 
 Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Benno Lossin <lossin@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
 Danilo Krummrich <dakr@kernel.org>, Will Deacon <will@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, Mark Rutland <mark.rutland@arm.com>, 
 Boqun Feng <boqun@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Boqun Feng <boqun@kernel.org>
Cc: linux-mm@kvack.org, rust-for-linux@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Andreas Hindborg <a.hindborg@kernel.org>
X-Mailer: b4 0.16-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=3097; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=eRfxmUkQqrmh+7ydAl1CyAaP+7fYfnTrTU8habC1k08=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBqIqYpP6qiupR/U70KNHOs89WvnUNI/gtu/Zo+7
 I2fFFhQiB2JAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCaiKmKQAKCRD6UCkIqsW9
 0KeKEACD8pnjBqC3fn4EZ4nMld6CxkNc5dIvf62nnvTRQ9TfcKZ55qD3cn26nWR3IgsvXuOQ7FS
 sZMCsWA5S93ZlCU2egckrQByPuy6y02y1FFoFDWon2RzwGnk5rRSB5iwIweKS2UxmUXRI8slSxD
 A4+Fj6P9iBMXDSlOsVbSFVqgKBjU8i0WYExpQYvaLldVS3BgU/QB0ox4Xo0C5ac+0YiDYnc8WnY
 lUJ3cqJ7L7GOG/jj9IzFDy3HQvzvmLIZ7LGNaw1kzHNf6PxitsWdeg7GZZJ1GU4CiEd9soq4trD
 dhYxD2Z6pYiONUDXkrAukSUBGPhO/6Wggoo+nZJ/gG2t+4G5DlZsPs+KHMu97myYs70ZizEuzmh
 LbYRRyMNDK3dES8QEgRZTThIAD+MKhlREdR/FDBHi7leiFRzGBT2RM5i1NpL2c3xbDQHZOEKk79
 +zu4SAMu4Ybii5E6FMJxIq6duOOVwNzCealyZ7QgmaP0YCF+lZBWlzO3Ode17DSPSDn1H+2YgV6
 KYn6cGor9f91TO30z+Pes0qekQyGSA9adg/ick7oJqHC47OyZj6vvB7mINgIyagCCxNYmZAlVff
 1SbIVuRcSPEqMNPrIIiVhut7pxJPJIYi6L+4pfGpvO3M4wZgSt2KL5FnnHeu7sp5GYOlFRx+5VI
 cHUC+hGGeYphYbA==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 42FD74000C
X-Stat-Signature: bufo1kufo6qhp37phan9wmh4w893uuq1
X-Rspam-User: 
X-HE-Tag: 1780655672-383649
X-HE-Meta: U2FsdGVkX1+LmVNEkjIMolAfktz8yUwKgG5QGLQO7do+gz/qn0beoE8MXpvvOzC96pzZ1Wz6pq2/CJvSbCD8uw/bTycCH6POnfl66Xr+4Yq91xCEZn2gRZG8EYPYkRa8+gogoWYv5xwrITEQacHW1hgkW8ohKxFsm2myVqeW4rXQHZAXWBrnLz/JMIiqToMwyz+jwLmkdzS8PXeHZwbUE5h+Ph3uYGEa58KUkzLAsGCFxPENB87OXxSfr0AJhfD//fzdhmOnUAy+7IjKuEmh4jc1LG6dHLxjTmi2ArMWzaz9BM6vaRbAf00dC8Kw2wyDV331NLjao5tGejnvCqUcrLlkBSGowEzrBxSBZbuWxnANu1OF105haEmMf1RLJU3ZhLhXj64s9VmQt5Uyv87Ks/ttRVFZioy0dRN/Xvdvfr/ZdLvmxqjE/hfYLjFWqAsNsRf2aA9ZD4Eb5ZkRzwCKAFYRHNDk5TCFAYWzXca8qCQx+FSwF5EeCZCM7V03hvnEaiDRGhqTnhBvl0XkwXsc5hKgcF/0VE3qmfMPj1QiahTM6cUGF3Bk/u5iwVPhAoQdC5QQIw9ZSrw6+BUJDWgRTss8gxc3SrRXi6pcgnnhZUYh68ou02qv3stvsVcGgNsJvtdIdqmJUxCS54XRXt+W7VOV+OWM2cIi8G8o3/xgXI6GcU3M5mhsHthqJCRHwbsUb5eSbUQ9uVeLyZNaFMKOB+MO8CBHsC9SRvvpgbuMMUf6B3X7W1q74LT/tA4FDhAL6Xz6bp6Tl+GotbtTF92oHmxYTdDrCyImtYsfXvOl07JekAtwG16GS1YD8J7hAYE6cu9bbd8sNmKCfZEWIUwfL0Nvj6bF1lgOqZgPtdz3PiwjIAelXMr5ejHMGbYY39uMY/st5Y8eq9LoRi9vcnsa9smd5eeBOCrl6UKrLCFGz2vqHEXa+/Wq4E/uhneG7y3C6EJzavtnnLEliF8qye5
 8iJd35uw
 uVGkrWN+E8iWLeQyDgoHoEuUOf8dUOOK2WxKFbq6it4nqLiE8ELNyz9oWrBJsgr7EpYvylwhk4cEJWrUEUXVv+8xcLxDzVBgrZBwbkcLf1UdO0rO8vgGPvsyxa2bdk2wRMrV5M10CPu2D/vF+rKyky8GcD0Vc/o0ezPF625FfomhrzO6pMxOSO4Sfr8jZZ1L3YDfHgNyUylbnvyXodR7Lp8Plr9o1pW5flo1ja1pQ70r408lWlPIy24pJcOeSkxDYRBCmYflWlWSWOMG9kUlJCEg/KQLDElcBRG9r1veH/+oP/o68c3bcjiHgCCkPVT2yhSEc1O961eYy+YyY2PNlfU/tSujYKorQOyqDQSmilAsGsg0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a helper to copy `len` bytes from `src` to `dst` using byte-wise
atomic memory operations. This is the concurrent-safe counterpart of
`core::ptr::copy()` (the equivalent of standard C's `memcpy()`).
Because of the atomicity at byte level, when the copy races with
another concurrent atomic access (or when a normal read races with
an atomic read), or with an external access (from DMA or userspace),
the behavior of this function is defined: the memory is copied at
(at least) byte granularity.

The helper is the building block for higher-level byte-wise atomic
copy methods (e.g., on `Page`) that need to remain defined under
racing accesses, such as when copying to or from a buffer that may
be concurrently accessed by userspace or DMA.

The implementation forwards to the kernel's `memcpy()`, which is
implemented in a way that byte-wise atomic memory load/store
instructions are used.

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 rust/kernel/sync/atomic.rs | 35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/rust/kernel/sync/atomic.rs b/rust/kernel/sync/atomic.rs
index 9cd009d57e35..3c76f1a14b53 100644
--- a/rust/kernel/sync/atomic.rs
+++ b/rust/kernel/sync/atomic.rs
@@ -848,3 +848,38 @@ pub unsafe fn cmpxchg<T: AtomicType, Ordering: ordering::Ordering>(
     // per LKMM.
     unsafe { Atomic::from_ptr(ptr) }.cmpxchg(old, new, o)
 }
+
+/// Copy `len` bytes from `src` to `dst` using byte-wise atomic operations.
+///
+/// This is the concurrent-safe counterpart of `core::ptr::copy()` (the equivalent of standard
+/// C's `memcpy()`). Because of the atomicity at byte level, when racing with another concurrent
+/// atomic access (or when a normal read races with an atomic read), or with an external access
+/// (from DMA or userspace), the behavior of this function is defined: the memory is copied at
+/// (at least) byte granularity.
+///
+/// Implementation note: this is currently implemented by the kernel's `memcpy()`, which is
+/// implemented in a way such that byte-wise atomic memory load/store instructions are used.
+///
+/// This copy operation is volatile.
+///
+/// # Safety
+///
+/// Callers must ensure that:
+///
+/// - `src` is valid for atomic reads for `len` bytes for the duration of the call.
+/// - `dst` is valid for atomic writes for `len` bytes for the duration of the call.
+pub unsafe fn atomic_per_byte_memcpy(src: *const u8, dst: *mut u8, len: usize) {
+    // SAFETY: By the safety requirements of this function, the following operation will not:
+    //  - Trap.
+    //  - Invalidate any reference invariants.
+    //  - Race with any operation by the Rust AM, as `bindings::memcpy` is a byte-wise atomic
+    //    operation and all operations by the Rust AM to the involved memory areas use byte-wise
+    //    atomic semantics.
+    unsafe {
+        bindings::memcpy(
+            dst.cast::<kernel::ffi::c_void>(),
+            src.cast::<kernel::ffi::c_void>(),
+            len,
+        )
+    };
+}

-- 
2.51.2



