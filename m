Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22FEBCA0EED
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 19:01:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC6538E0034; Thu, 28 Aug 2025 15:01:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D29778E0024; Thu, 28 Aug 2025 15:01:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B06C98E0034; Thu, 28 Aug 2025 15:01:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8DCF78E0024
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 15:01:07 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 568FA1DD5E7
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 19:01:07 +0000 (UTC)
X-FDA: 83827083774.29.4C2762F
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	by imf28.hostedemail.com (Postfix) with ESMTP id 39F5DC0026
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 19:01:05 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=eA84r8nE;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of levymitchell0@gmail.com designates 209.85.216.46 as permitted sender) smtp.mailfrom=levymitchell0@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756407665; a=rsa-sha256;
	cv=none;
	b=1SU4vF6lWPY3dtMF7F+an/1JwC9LoB6EMOkdv947yXaUarVAhVsb05DEeqRM2MwM0vhS4O
	6IyHo72M6W1uKUAo0/w+NpVf6/BTq9IKhWDtnIybB/h7BLbAUyYbMQYs6fxKNtSIkOBFKr
	rPEtNEkj7TT3GhIYD8Kl87tV2Yjdj34=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=eA84r8nE;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of levymitchell0@gmail.com designates 209.85.216.46 as permitted sender) smtp.mailfrom=levymitchell0@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756407665;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aAngSwZJY8wvhRdb+Us7Bf51kKhX3hLhPg8BAwh+qjA=;
	b=O2DrjBKEALxLtWVYTkkiiYMi/nOqOzwFINM8wXH88mX9wSn2fVD6qOIoG3xx0UFPisM9w9
	CVRECc41PcOubA8hACIKqS+cuBw6Mb5ul6uxSDnHY78AgtoLK+kLIhh4oAEuSpb1yVTdqK
	DRh0mWmSSYau1o/WewYBiJJQ+WsghT8=
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-327ae052173so697255a91.0
        for <linux-mm@kvack.org>; Thu, 28 Aug 2025 12:01:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756407664; x=1757012464; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aAngSwZJY8wvhRdb+Us7Bf51kKhX3hLhPg8BAwh+qjA=;
        b=eA84r8nEonIpehDtpVA/H4GCUIQEF3j1RQMeeckT+Gui1h6CSgmlwi0m3kHuhaEIIV
         Y6xKRWPsLjBTC1jOg1QMWsC6cTTq9IpmQZw4bN3Qk9wftJXJ4T+qb0X4Z0+s4BwU2L5E
         RyNmFVowGp8e2NaLktefi8tZwBhh7nqOiPGFleJ6jbe8O7ENEcXqVdN7RCLbjOONFmF/
         O1O87Wl72BHMSvkBKlMrEyT0TFen84saqaC3UfjR/QItPyIxrKXCJ+EGhpq9fFMBV3it
         zNtKlLMax5NrrVXNWzQyZ3Ja27CplkoNwO520F3sJciZm+GknSp0OUR7Jtp3wuSmWD4C
         I7mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756407664; x=1757012464;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aAngSwZJY8wvhRdb+Us7Bf51kKhX3hLhPg8BAwh+qjA=;
        b=f6yoX21aSzSLl1pfO+bhmcnseqPTbJ3WC9AaeZyuwxZwQSegcQ67z7r6Tr58beM1nt
         lnZwa/j6Fo8yCm1e+hqaIeVs5GTPJKoZS01ODhdlzka6z1QTj0TUgeny0bcXa2P36iAT
         VEfuNufR4QKssrIWkvhERwoybhMw7Bg4hEfj48UulsXcJWqn7mLtPy+DCkSx5RHz8vQz
         MaxuxVcDgbiF4ZD+Q84ov5z+w1F/guumWGLdGd5xBNOBBn7intuPCN3AJFPdKl+ald9x
         u24TZY6MCVhQGgsteMOVos6X20rbXrsjt9FYQ/Uh4XLdZCysHJJSX6b/rKlFPxP8sosQ
         8X+Q==
X-Forwarded-Encrypted: i=1; AJvYcCUJGBODNaCou9pBXnQMszPvtq1wOgA47+AZJ97ZdTacl0iP85Ikyib6xYAuSBPvUruH62ZmdAuNwg==@kvack.org
X-Gm-Message-State: AOJu0YwqJhnNHxRUFpNBmpz0HL3DeG+BbahnNHKeEn+vo0MeSqXc/GxN
	ROKaiA1zLScmCDnFXosAu0Q+lTMPwqULW2SfzM5Md2qEakDkz31xcgmP
X-Gm-Gg: ASbGncvd3mQm3gPbXi6s4AZRra60pM8fKGuke2w/3wx25Q1djYFBxDGZYuZgHO1dBKm
	JL2Acgrnvwqn3v5GLNM0Xc1EEltKOzQ5UxaW+4vV7RubkJ+HitWGH1a6LxIJLfwVTdFwZ6FRGnk
	cWkLvbbDEzKNxlIpLnzD6obeaA1WdeqWxT71n8+752flaq41VvJz5YW5x8cd7izlWtes72ays73
	M7tr5SGrXZVXbTneZx4/K0KfiyEXwEg3n7jJdY1RJ2bMOHlrtajN1vlmB5nfpIGKRAkLfbpwD+0
	HPFLfdNqzQ/xazHtfL/x3G9C63fY1icy/cJHtrfGF+UkiVu/NGWBeoPGnomicxTiaMmHOc6jswg
	epnh+CRvKYcf9qPwLviJSfauUtU2EpkQB4GQ2fX2405VKTg==
X-Google-Smtp-Source: AGHT+IE26/lrl4f3dGjJW6QGStTgLdmIa26piskyaGIsHE5TO9Dbkag/vLov52+DzHKlj+iq5a9ckw==
X-Received: by 2002:a17:90b:3ec9:b0:327:5360:5b11 with SMTP id 98e67ed59e1d1-327536061fdmr12677471a91.27.1756407662991;
        Thu, 28 Aug 2025 12:01:02 -0700 (PDT)
Received: from mitchelllevy.localdomain ([174.127.224.194])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-327da8e5ad5sm405729a91.18.2025.08.28.12.01.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Aug 2025 12:01:01 -0700 (PDT)
From: Mitchell Levy <levymitchell0@gmail.com>
Date: Thu, 28 Aug 2025 12:00:13 -0700
Subject: [PATCH v3 6/7] rust: percpu: Add pin-hole optimizations for
 numerics
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250828-rust-percpu-v3-6-4dd92e1e7904@gmail.com>
References: <20250828-rust-percpu-v3-0-4dd92e1e7904@gmail.com>
In-Reply-To: <20250828-rust-percpu-v3-0-4dd92e1e7904@gmail.com>
To: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
 Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Andreas Hindborg <a.hindborg@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
 Trevor Gross <tmgross@umich.edu>, Andrew Morton <akpm@linux-foundation.org>, 
 Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, 
 Christoph Lameter <cl@linux.com>, Danilo Krummrich <dakr@kernel.org>, 
 Benno Lossin <lossin@kernel.org>, Yury Norov <yury.norov@gmail.com>, 
 Viresh Kumar <viresh.kumar@linaro.org>
Cc: Tyler Hicks <code@tyhicks.com>, linux-kernel@vger.kernel.org, 
 rust-for-linux@vger.kernel.org, linux-mm@kvack.org, 
 Mitchell Levy <levymitchell0@gmail.com>
X-Mailer: b4 0.14.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1756407651; l=9614;
 i=levymitchell0@gmail.com; s=20240719; h=from:subject:message-id;
 bh=FkPibw/wTeWHpca1nOecK532ZikijOEsQLvkO8BhfQs=;
 b=G3nMpuN/5qYzhXKfS67YeHPg6iQlvPE/KO79sTBsc4eHDPXaEL+ZfiGMssCN5FNO96iohtJUT
 XZe3XfI2Na1Dz4CdbL+lGwMMy+olOmlki7WomhFHkbFKPpofXIRqhnD
X-Developer-Key: i=levymitchell0@gmail.com; a=ed25519;
 pk=n6kBmUnb+UNmjVkTnDwrLwTJAEKUfs2e8E+MFPZI93E=
X-Rspamd-Queue-Id: 39F5DC0026
X-Stat-Signature: 3xzhp91bebc191m4onccr3qd98ons5ro
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756407665-682809
X-HE-Meta: U2FsdGVkX1/fTmXpXIBB6hHXgE8L+8F+Z91bQ15NSRLngGPx5w9NoqxuzGeTnc2SC7o9KV0EuR0YWk2vLBayS3hUhCBBGq/Yn/xcYKXYLZwFECfV9AATA6H8x8+JP+N5wxQ1uk7N42pflEcIcDtjMHMakk+xnkD/YGmfMf4hEcT0+BI8BgOHTUL1Ymb+pcHCBrGZJcu+Mdh8I167YhMetBm1r6VZjfLpbNz1OgV1M2i4szLz/EjRjMTvNiiCVkYMqZmk2A+WCrjvpX8xmjXjFgz9qduvkLoyEMGD6aLBFrWzZbgP0FL/23fVx6vl7JiYDPhBVDfqyM/iQ4qIdiDDyourZ4J6ns+QG8mFtGB+dNJUSh1VIz1SMtEb0EG7+5YyliDVrSMaSSC2QmECgxNitups4ral4qOrM349MtPxdCTjr7ZBWVKmqsNIXNTOCCLKL7tWVvdJZormHMnRQWgfPjDVFROECi8Hou5Qyq/nDq/bPOWKEbDElC+N3MDG/mL/qgURG1orPPM1DfLCWZdCUA9F6d/nc2ZFBKeKe7J2Jr+T5/X3yPaE0yjAcqUrsjfKJAOvW2mA/oopL+X6KT9vBxrIiSs4I46aUTOuBvRTD3ML/EUnpfYVkiQ1cc2gzgkTroWT0E8f1ipDQ7DeUoCR8wAGEvCaPuB04ZADzgecY6IjFM3He6tSsywxOsJGTJX2qSocbSrEOa0fJvrLEaCkLqq/Mp3W+oLMWVJjTCUWUG35/5nJI4n1E50VB+ub97rvgFHEykTeYTZ3JMMEF7jZRRjH7/uK7viTdY6m2IN2r1i3Dib0VXy7xdIedL+aOcFBLFZ9sUUYf1JHwScBVd7+MT0Seke6f70Z3VuetV80Qqar8QeHS5Jp/Zxo1wLvxecerPCZB9qUPFiMSylmEPpuqBymihHbkvFt2Aeo+r3iTz0OElCR5QnCvjo7NkTU4jkkQJ5q1DZM2VFLEkcO3r3
 2Bn3Ai4r
 yqe/2olOqN4XAFBgQcL/F4E4cWqYiHWf9/kXzeFJkqt214zNOuP9wTT6Arg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The C implementations of `this_cpu_add`, `this_cpu_sub`, etc., are
optimized to save an instruction by avoiding having to compute
`this_cpu_ptr(&x)` for some per-CPU variable `x`. For example, rather
than

    u64 *x_ptr = this_cpu_ptr(&x);
    *x_ptr += 5;

the implementation of `this_cpu_add` is clever enough to make use of the
fact that per-CPU variables are implemented on x86 via segment
registers, and so we can use only a single instruction (where we assume
`&x` is already in `rax`)

    add gs:[rax], 5

Add this optimization via a `PerCpuNumeric` type to enable code-reuse
between `DynamicPerCpu` and `StaticPerCpu`.

Signed-off-by: Mitchell Levy <levymitchell0@gmail.com>
---
 rust/kernel/percpu.rs         |   1 +
 rust/kernel/percpu/dynamic.rs |   2 +-
 rust/kernel/percpu/numeric.rs | 128 ++++++++++++++++++++++++++++++++++++++++++
 samples/rust/rust_percpu.rs   |  36 ++++++++++++
 4 files changed, 166 insertions(+), 1 deletion(-)

diff --git a/rust/kernel/percpu.rs b/rust/kernel/percpu.rs
index c68c7520b67f..c693d16518d2 100644
--- a/rust/kernel/percpu.rs
+++ b/rust/kernel/percpu.rs
@@ -4,6 +4,7 @@
 
 pub mod cpu_guard;
 mod dynamic;
+pub mod numeric;
 mod static_;
 
 #[doc(inline)]
diff --git a/rust/kernel/percpu/dynamic.rs b/rust/kernel/percpu/dynamic.rs
index 64f04cef3705..aad08e4b4251 100644
--- a/rust/kernel/percpu/dynamic.rs
+++ b/rust/kernel/percpu/dynamic.rs
@@ -7,7 +7,7 @@
 
 /// Represents a dynamic allocation of a per-CPU variable via alloc_percpu. Calls free_percpu when
 /// dropped.
-pub struct PerCpuAllocation<T>(PerCpuPtr<T>);
+pub struct PerCpuAllocation<T>(pub(super) PerCpuPtr<T>);
 
 impl<T: Zeroable> PerCpuAllocation<T> {
     /// Dynamically allocates a space in the per-CPU area suitably sized and aligned to hold a `T`,
diff --git a/rust/kernel/percpu/numeric.rs b/rust/kernel/percpu/numeric.rs
new file mode 100644
index 000000000000..4de93f653f0e
--- /dev/null
+++ b/rust/kernel/percpu/numeric.rs
@@ -0,0 +1,128 @@
+// SPDX-License-Identifier: GPL-2.0
+//! Pin-hole optimizations for PerCpu<T> where T is a numeric type.
+
+use super::*;
+use core::arch::asm;
+
+/// Represents a per-CPU variable that can be manipulated with machine-intrinsic numeric
+/// operations.
+pub struct PerCpuNumeric<'a, T> {
+    // INVARIANT: `ptr.0` is a valid offset into the per-CPU area and is initialized on all CPUs
+    // (since we don't have a CPU guard, we have to be pessimistic and assume we could be on any
+    // CPU).
+    ptr: &'a PerCpuPtr<T>,
+}
+
+macro_rules! impl_ops {
+    ($ty:ty, $reg:tt) => {
+        impl DynamicPerCpu<$ty> {
+            /// Returns a `PerCpuNumeric` that can be used to manipulate the underlying per-CPU variable.
+            pub fn num(&mut self) -> PerCpuNumeric<'_, $ty> {
+                // The invariant is satisfied because `DynamicPerCpu`'s invariant guarantees that
+                // this pointer is valid and initialized on all CPUs.
+                PerCpuNumeric { ptr: &self.alloc.0 }
+            }
+        }
+        impl StaticPerCpu<$ty> {
+            /// Returns a `PerCpuNumeric` that can be used to manipulate the underlying per-CPU variable.
+            pub fn num(&mut self) -> PerCpuNumeric<'_, $ty> {
+                // The invariant is satisfied because `StaticPerCpu`'s invariant guarantees that
+                // this pointer is valid and initialized on all CPUs.
+                PerCpuNumeric { ptr: &self.0 }
+            }
+        }
+
+        impl PerCpuNumeric<'_, $ty> {
+            /// Adds `rhs` to the per-CPU variable.
+            pub fn add(&mut self, rhs: $ty) {
+                // SAFETY: `self.ptr.0` is a valid offset into the per-CPU area (i.e., valid as a
+                // pointer relative to the `gs` segment register) by the invariants of this type.
+                unsafe {
+                    asm!(
+                        concat!("add gs:[{off}], {val:", $reg, "}"),
+                        off = in(reg) self.ptr.0.cast::<*mut $ty>(),
+                        val = in(reg) rhs,
+                    );
+                }
+            }
+        }
+        impl PerCpuNumeric<'_, $ty> {
+            /// Subtracts `rhs` from the per-CPU variable.
+            pub fn sub(&mut self, rhs: $ty) {
+                // SAFETY: `self.ptr.0` is a valid offset into the per-CPU area (i.e., valid as a
+                // pointer relative to the `gs` segment register) by the invariants of this type.
+                unsafe {
+                    asm!(
+                        concat!("sub gs:[{off}], {val:", $reg, "}"),
+                        off = in(reg) self.ptr.0.cast::<*mut $ty>(),
+                        val = in(reg) rhs,
+                    );
+                }
+            }
+        }
+    };
+}
+
+macro_rules! impl_ops_byte {
+    ($ty:ty) => {
+        impl DynamicPerCpu<$ty> {
+            /// Returns a `PerCpuNumeric` that can be used to manipulate the underlying per-CPU
+            /// variable.
+            pub fn num(&mut self) -> PerCpuNumeric<'_, $ty> {
+                // The invariant is satisfied because `DynamicPerCpu`'s invariant guarantees that
+                // this pointer is valid and initialized on all CPUs.
+                PerCpuNumeric { ptr: &self.alloc.0 }
+            }
+        }
+        impl StaticPerCpu<$ty> {
+            /// Returns a `PerCpuNumeric` that can be used to manipulate the underlying per-CPU
+            /// variable.
+            pub fn num(&mut self) -> PerCpuNumeric<'_, $ty> {
+                // The invariant is satisfied because `DynamicPerCpu`'s invariant guarantees that
+                // this pointer is valid and initialized on all CPUs.
+                PerCpuNumeric { ptr: &self.0 }
+            }
+        }
+
+        impl PerCpuNumeric<'_, $ty> {
+            /// Adds `rhs` to the per-CPU variable.
+            pub fn add(&mut self, rhs: $ty) {
+                // SAFETY: `self.ptr.0` is a valid offset into the per-CPU area (i.e., valid as a
+                // pointer relative to the `gs` segment register) by the invariants of this type.
+                unsafe {
+                    asm!(
+                        concat!("add gs:[{off}], {val}"),
+                        off = in(reg) self.ptr.0.cast::<*mut $ty>(),
+                        val = in(reg_byte) rhs,
+                    );
+                }
+            }
+        }
+        impl PerCpuNumeric<'_, $ty> {
+            /// Subtracts `rhs` from the per-CPU variable.
+            pub fn sub(&mut self, rhs: $ty) {
+                // SAFETY: `self.ptr.0` is a valid offset into the per-CPU area (i.e., valid as a
+                // pointer relative to the `gs` segment register) by the invariants of this type.
+                unsafe {
+                    asm!(
+                        concat!("sub gs:[{off}], {val}"),
+                        off = in(reg) self.ptr.0.cast::<*mut $ty>(),
+                        val = in(reg_byte) rhs,
+                    );
+                }
+            }
+        }
+    };
+}
+
+impl_ops_byte!(i8);
+impl_ops!(i16, "x");
+impl_ops!(i32, "e");
+impl_ops!(i64, "r");
+impl_ops!(isize, "r");
+
+impl_ops_byte!(u8);
+impl_ops!(u16, "x");
+impl_ops!(u32, "e");
+impl_ops!(u64, "r");
+impl_ops!(usize, "r");
diff --git a/samples/rust/rust_percpu.rs b/samples/rust/rust_percpu.rs
index 06b322019134..e3a46a053b8d 100644
--- a/samples/rust/rust_percpu.rs
+++ b/samples/rust/rust_percpu.rs
@@ -27,6 +27,26 @@
 define_per_cpu!(UPERCPU: u64 = 0);
 define_per_cpu!(CHECKED: RefCell<u64> = RefCell::new(0));
 
+macro_rules! make_optimization_test {
+    ($ty:ty) => {
+        let mut test: DynamicPerCpu<$ty> = DynamicPerCpu::new_zero(GFP_KERNEL).unwrap();
+        {
+            let _ = CpuGuard::new();
+            // SAFETY: No other usage of `test`
+            unsafe { test.get_mut(CpuGuard::new()) }.with(|val: &mut $ty| *val = 10);
+            test.num().add(1);
+            // SAFETY: No other usage of `test`
+            unsafe { test.get_mut(CpuGuard::new()) }.with(|val: &mut $ty| assert_eq!(*val, 11));
+            test.num().add(10);
+            // SAFETY: No other usage of `test`
+            unsafe { test.get_mut(CpuGuard::new()) }.with(|val: &mut $ty| assert_eq!(*val, 21));
+            test.num().sub(5);
+            // SAFETY: No other usage of `test`
+            unsafe { test.get_mut(CpuGuard::new()) }.with(|val: &mut $ty| assert_eq!(*val, 16));
+        }
+    };
+}
+
 impl kernel::Module for PerCpuMod {
     fn init(_module: &'static ThisModule) -> Result<Self, Error> {
         pr_info!("rust percpu test start\n");
@@ -198,6 +218,22 @@ fn init(_module: &'static ThisModule) -> Result<Self, Error> {
 
         pr_info!("rust dynamic percpu test done\n");
 
+        pr_info!("rust numeric optimizations test start\n");
+
+        make_optimization_test!(u8);
+        make_optimization_test!(u16);
+        make_optimization_test!(u32);
+        make_optimization_test!(u64);
+        make_optimization_test!(usize);
+
+        make_optimization_test!(i8);
+        make_optimization_test!(i16);
+        make_optimization_test!(i32);
+        make_optimization_test!(i64);
+        make_optimization_test!(isize);
+
+        pr_info!("rust numeric optimizations test done\n");
+
         // Return Err to unload the module
         Result::Err(EINVAL)
     }

-- 
2.34.1


