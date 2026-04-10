Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D26CCF45A0D
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 21:36:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7765B6B0096; Fri, 10 Apr 2026 17:36:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 68DB86B0098; Fri, 10 Apr 2026 17:36:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5550A6B0099; Fri, 10 Apr 2026 17:36:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4751E6B0096
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 17:36:29 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0B25E1401D0
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 21:36:29 +0000 (UTC)
X-FDA: 84643955298.23.66636B3
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	by imf06.hostedemail.com (Postfix) with ESMTP id D9DBC18000D
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 21:36:26 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=fejWR1O7;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of levymitchell0@gmail.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=levymitchell0@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775856987; a=rsa-sha256;
	cv=none;
	b=Wq4dLTg8Ku/GXROq1Jg2zU/WMZSc2qj6e2xzj5CgvR7VEeucSOEnPpAsCCHNyYFbCjlck+
	mh1qu5H5eqr957AlRoktb6qttrvaPDhpR4xcnYlj8phkHYTNxMaCkHsyc9BjHJWG87mSwR
	UVNcXjO7pMw9SIN/ulGSLCtGXE2hxZY=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=fejWR1O7;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of levymitchell0@gmail.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=levymitchell0@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775856986;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sjXgZakwtxdl0VN9G7aNOYuETb1QANXt4gyFlj+iho8=;
	b=f4pz24EepbjytxUIjO8khvxv4l886C5g98Gc95aUHkXu/0KOkKq+c8cVEcjQUAj2BVP+9H
	RBszKV1hOI71IJsiHN9zQyUa6/QxKI9zqOTDb1X+qBgBPKduW06aNrUe9AuL37io4XAzec
	FfxUpVurpClCvW0km3gS70OgaIQpkAM=
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-82cebbdab08so2001329b3a.2
        for <linux-mm@kvack.org>; Fri, 10 Apr 2026 14:36:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775856986; x=1776461786; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sjXgZakwtxdl0VN9G7aNOYuETb1QANXt4gyFlj+iho8=;
        b=fejWR1O7gVPVbWa/S8j1dkHBQdYzDLGhLIPhl+YmiC5n5oXWXOomYhoLFCUE1iTAO8
         DX1BcS4LcB+8CCX+PlmnEHEjvWpPBObGpdOE2D718pZ1J/Rfg2W9gz90Q1snspGwNk8U
         1UPv1tmuHLSXf0KoKwqjsqQBQSEEtljm1jKyY3Zr8v2hWafQt6JNcaprGV4JrrEbsIGt
         xzBnWJMZPdBj7wHQe2jI6/NUbk2ywgr4yT08+t3wzaw5VIz6/IhHEMonXiTDzOYwi5pH
         H+yT6vGjnIro4nR+bHukeywN+P04N2gZcU+KVVOJSTooMjz0jOtGH8vcbDQhiuY66l7B
         QHqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775856986; x=1776461786;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=sjXgZakwtxdl0VN9G7aNOYuETb1QANXt4gyFlj+iho8=;
        b=j0gEsUxhpIlFifMAABlvb2ZLOZESlPB34dOLRhnpVGAONsUytwJnxjqfEjzXlOfbtk
         cyjpoj2AMkZjT+mAenZWfvwAt8CaENnTI0ioEgBjt/MWDBSZhk6OWH/YKkKFC7iqF5pn
         k/ZhcPduwPWpMBV1SjXvmkH/uOSxl6KPDldyBqtTwGG5kezBNSxlPjSKjylpnPdRj3wf
         u0bJ5IXaaOCeg+QFuDyOKHhvhkMr5kspYsVVEJ/YE+njvyWLdwVvMv298x5CErCf6N69
         szKHbajgoVJ1viywmNuqxTxzF3lwPcOzYSrl9LbeHX2v60yGcrh0iQFadTeNfBX3a/1Q
         Za+A==
X-Forwarded-Encrypted: i=1; AJvYcCXJszGCUCArLlb5He+6JGenXN/7cF/2Hg6ce7Pu5IDkm2cFmG2KQIUmV+Ql/0RHFskKHa7PShy01Q==@kvack.org
X-Gm-Message-State: AOJu0YxHM/y1a1tDHTRUJDa3K76Ep00O3Quzj35RbUXSIhQmevHtjKcW
	KBRMD+Oi5v5eFhf38RzKVYYsgWyXI/zfBoezLGxm/VsRdC3sVqUTBvLr
X-Gm-Gg: AeBDieuv/ddjNV1/msqsmBwVb0by/xCqzJcessDACk6e6PFPcUQfEjsX4Se3Z//swiL
	sdqIA5qd67UUjGqGzq+MDrJoNeIWzvsvrJ70ar0xoXaC4eE2YhWXC9aqfoMRkqcMDLjoqEvGe+g
	sjIz37a9cIUjJmQDvO2fPDXq+2bsSus+nQ43al42O7JHVBp73+uPLG7YYMD31OwSMR0Jd4HrBVj
	axhgCaZnE7UCxii+Q+ScPPhopr23NcWTWrmsX0WSa+E5usl2PiTg1S7fxq4z3JBURyFBP6Ws76k
	6ofZsOnXc1IM4vwO/q0mT+ujIDgxfekSkpDcsWEl2/gG+swFg653ejagMqtthWu3AA0Y4rZoe0J
	ICEXMYn2XlFcvbSiNIECvFJ0UpHxfDts/cj/wx+x5Srl1kKF0tgIve5rKS6Tpx73ppNv4wP00Cx
	ueUDE1ZRLe5dPVfst+lRAD6L3sqgEra3+49bwQEUJUI5LW
X-Received: by 2002:a05:6a00:94ed:b0:82c:d7e7:2f8a with SMTP id d2e1a72fcca58-82f0c2cc05emr5545403b3a.39.1775856985480;
        Fri, 10 Apr 2026 14:36:25 -0700 (PDT)
Received: from mitchelllevy.localdomain ([131.107.1.135])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82f0c4e3d41sm5111551b3a.48.2026.04.10.14.36.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Apr 2026 14:36:25 -0700 (PDT)
From: Mitchell Levy <levymitchell0@gmail.com>
Date: Fri, 10 Apr 2026 14:35:35 -0700
Subject: [PATCH v5 5/8] rust: percpu: introduce a rust API for dynamic
 per-CPU variables
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260410-rust-percpu-v5-5-4292380d7a41@gmail.com>
References: <20260410-rust-percpu-v5-0-4292380d7a41@gmail.com>
In-Reply-To: <20260410-rust-percpu-v5-0-4292380d7a41@gmail.com>
To: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
 Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Andreas Hindborg <a.hindborg@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
 Trevor Gross <tmgross@umich.edu>, Andrew Morton <akpm@linux-foundation.org>, 
 Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, 
 Christoph Lameter <cl@linux.com>, Danilo Krummrich <dakr@kernel.org>, 
 Benno Lossin <lossin@kernel.org>, Yury Norov <yury.norov@gmail.com>, 
 Viresh Kumar <viresh.kumar@linaro.org>, Boqun Feng <boqun@kernel.org>
Cc: Tyler Hicks <code@tyhicks.com>, Allen Pais <apais@linux.microsoft.com>, 
 linux-kernel@vger.kernel.org, rust-for-linux@vger.kernel.org, 
 linux-mm@kvack.org, Mitchell Levy <levymitchell0@gmail.com>
X-Mailer: b4 0.15.1
X-Developer-Signature: v=1; a=ed25519-sha256; t=1775856978; l=13283;
 i=levymitchell0@gmail.com; s=20240719; h=from:subject:message-id;
 bh=BjduRcn3ssQj78fY+L89MJz6yy9e4tAyqjivAYqoheo=;
 b=vPb/14JfjlCNy2Aq44p4Ja3wajyFXY8LTQ+t/jJAZ8E1v/jGU8q4uLMF2F0plaErQ17GRtHuV
 5wCbzE4dktkBmGXInmVsi80MCVhObpuRvyc7xVz4vPr/KoprywWlv08
X-Developer-Key: i=levymitchell0@gmail.com; a=ed25519;
 pk=n6kBmUnb+UNmjVkTnDwrLwTJAEKUfs2e8E+MFPZI93E=
X-Stat-Signature: jte935uiz4qqkbqhqxhxqk3ccmk84q7n
X-Rspamd-Queue-Id: D9DBC18000D
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775856986-344121
X-HE-Meta: U2FsdGVkX1/XzpuvgjZk/dCTC5JKipJKGNv5Jwqhyd6j3M8z7L2QdEHSouwo5kd3vbjI5p+rKfcAyUFnczHXYaOGEriorI1WRuxvsHqdUPptVLY+cMod44O3M4xHfAxdyEYBKN3T0PUFfBn6XzDfRuLvXKdISdzZd1VR5JYiodyEKA7GI9kXDbPyuvSw0I1FwlOLOmIz5ALRUFJPjz7Cpznvt9zw+EmEC8fEGGnPhXXFRyVS0d4tgfPcNMq4F7Mv4BFF75XpYJX92SwiYrHqCcBBM+hLXTfyqx+7I2OXZabvf9rwUerPEXIq2+rwkE0PKUe2YOWHcfnx3XD5Kiq+KELhOquvt2CrZDYRXoR4Y0obZv2TCaXaEu76AK4qC5tkr/VH9q+MBmOd5wK6dfIaGKnQusgrowiUTvwd31FkEs47P6Zl3n0yCffv6KGhOOYK1DJFX8jyCG9AK+IMEqbMLh62gEDikzF+0ErUKvxqSFg5VzOSvD01ykJTE5dPVAUcmlkMw5Gfa74FrMow1vyYfX7jryedgGG9ONAPWvb+jOcPl+njL8c931x7VQl8Ku21Ce2b+A2iJ1ReXgw1fwW/nkWbmQ3xsOXinkCFcThXuDhdr67POcJedWhsIwUQGVgVT6M1Wtiukk+EFPOv2453S7ks3NRAipfYGxhc1D/Zj+W4zhlSpmGdQNoqglcVYMewgCmpJIGVdlcThSp6RNnSYivXZJ2/vNg1xjbIQitY3UGjoqwEQK6lf/P5chPG32DiW09mFn5T5GcsUIN5j3nlOyE9rK3BzQ6Rysa3p9xd/eE+kLewxct+v3/AK0UPyOnU/6XBnc9cqyaDN/YQtBV48/I3Xid5+IrXL8uUVbyDTirfdYFrUBxfIzPtm/0i7ynV7amGGBymdzdOUienPT5fO6V4qzKEEtDLrGxjuCKiTGEmw5rqf2lWmAohyR86m/unPOhdADwebXizlfqwqH9
 riwCmne9
 FHhiD8SZTts6060zFRdCiyck3PAUfaNTARSFJqS0DsqnwcgMNQf/IWZ6OxNg7NJHCODpod4wId8BdGCYNsiVmbvp7e5cXhgdSp+XrA+HsXsnmX4VKqZfI3JPe4xe5aYG3Ri2olgd1bMwZqlATRFY1hucPFD11cvmKWswXb73rUJ96XtazHGSciJYIV3Ak3pegaHsYoWvVDkTilVFomOBv7c/WIOvuGES6Ycq4AzEIc4UGSzzYbhFklcOmNr/qxk9WGQASld3/UxKuELIUP0hn2g2gxGYefjIIFssMf+pehFHkUKdgPcdRJiVyq+OH6GXfmvc8uG6lI6X6d2rVMeGzSqrdcqNb44VmeC18g4MB8D1mAAdI9BPZl/UtpPb57B50mJ14KE9siEkysgC3Nw4WAyxWN1FYWYvaN+n0EeACefrDKd219jeA8XbrZtZYV55Uch+jbz5zd+n72sJM8CCx6jrBjyFxSQUo5zVnO7CyEYLTMKKE0NwQh+YZMh6EGLIh5B/pGpO6cuURw14=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Dynamically allocated per-CPU variables are core to many of the
use-cases of per-CPU variables (e.g., ref counting). Add support for
them using the core `PerCpuPtr<T>` primitive, implementing the
`PerCpu<T>` and `CheckedPerCpu<T>` traits.

Co-developed-by: Boqun Feng <boqun@kernel.org>
Signed-off-by: Boqun Feng <boqun@kernel.org>
Signed-off-by: Mitchell Levy <levymitchell0@gmail.com>
---
 rust/helpers/percpu.c         |  12 +++
 rust/kernel/percpu.rs         |  30 +++++-
 rust/kernel/percpu/dynamic.rs | 217 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 255 insertions(+), 4 deletions(-)

diff --git a/rust/helpers/percpu.c b/rust/helpers/percpu.c
index 463186b8af9d..3b2f69a96c66 100644
--- a/rust/helpers/percpu.c
+++ b/rust/helpers/percpu.c
@@ -7,3 +7,15 @@ void __percpu *rust_helper_alloc_percpu(size_t sz, size_t align)
 {
 	return __alloc_percpu(sz, align);
 }
+
+__rust_helper
+void *rust_helper_per_cpu_ptr(void __percpu *ptr, unsigned int cpu)
+{
+	return per_cpu_ptr(ptr, cpu);
+}
+
+__rust_helper
+void rust_helper_on_each_cpu(smp_call_func_t func, void *info, int wait)
+{
+	on_each_cpu(func, info, wait);
+}
diff --git a/rust/kernel/percpu.rs b/rust/kernel/percpu.rs
index 615859d4daad..0ec1245038bb 100644
--- a/rust/kernel/percpu.rs
+++ b/rust/kernel/percpu.rs
@@ -1,15 +1,20 @@
 // SPDX-License-Identifier: GPL-2.0
 //! Per-CPU variables.
 //!
-//! See the [`crate::define_per_cpu!`] macro and the [`PerCpu<T>`] trait.
+//! See the [`crate::define_per_cpu!`] macro, the [`DynamicPerCpu`] type, and the [`PerCpu<T>`]
+//! trait.
 
 pub mod cpu_guard;
+mod dynamic;
 mod static_;
 
+#[doc(inline)]
+pub use dynamic::*;
 #[doc(inline)]
 pub use static_::*;
 
 use crate::{
+    cpu::CpuId,
     declare_extern_per_cpu,
     percpu::cpu_guard::CpuGuard,
     types::Opaque, //
@@ -132,6 +137,23 @@ pub fn get_ptr(&self) -> *mut MaybeUninit<T> {
         // the invariant that self.0 is a valid offset into the per-CPU area.
         (this_cpu_area).wrapping_add(self.0 as usize).cast()
     }
+
+    /// Get a [`*mut MaybeUninit<T>`](MaybeUninit) to the per-CPU variable on the CPU represented
+    /// by `cpu`. Note that without some kind of synchronization, use of the returned pointer may
+    /// cause a data race. It is the caller's responsibility to use the returned pointer in a
+    /// reasonable way.
+    ///
+    /// # Returns
+    /// - The returned pointer is valid only if `self` is (that is, it points to a live allocation
+    ///   correctly sized and aligned to hold a `T`)
+    /// - The returned pointer is valid only if the bit corresponding to `cpu` is set in
+    ///   [`kernel::cpumask::Cpumask::possible_cpus()`].
+    pub fn get_remote_ptr(&self, cpu: CpuId) -> *mut MaybeUninit<T> {
+        // SAFETY: `bindings::per_cpu_ptr` is just doing pointer arithmetic. The returned pointer
+        // may not be valid (under the conditions specified in this function's documentation), but
+        // the act of producing the pointer is safe.
+        unsafe { bindings::per_cpu_ptr(self.0.cast(), cpu.as_u32()) }.cast()
+    }
 }
 
 // SAFETY: Sending a [`PerCpuPtr<T>`] to another thread is safe because as soon as it's sent, the
@@ -155,9 +177,9 @@ impl<T> Copy for PerCpuPtr<T> {}
 
 /// A trait representing a per-CPU variable.
 ///
-/// This is implemented for [`StaticPerCpu<T>`]. The main usage of this trait is to call
-/// [`Self::get_mut`] to get a [`PerCpuToken`] that can be used to access the underlying per-CPU
-/// variable.
+/// This is implemented for both [`StaticPerCpu<T>`] and [`DynamicPerCpu<T>`]. The main usage of
+/// this trait is to call [`Self::get_mut`] to get a [`PerCpuToken`] that can be used to access the
+/// underlying per-CPU variable.
 ///
 /// See [`PerCpuToken::with`].
 pub trait PerCpu<T> {
diff --git a/rust/kernel/percpu/dynamic.rs b/rust/kernel/percpu/dynamic.rs
new file mode 100644
index 000000000000..40514704b3d0
--- /dev/null
+++ b/rust/kernel/percpu/dynamic.rs
@@ -0,0 +1,217 @@
+// SPDX-License-Identifier: GPL-2.0
+//! Dynamically allocated per-CPU variables.
+
+use super::*;
+
+use crate::{
+    alloc::Flags,
+    bindings::{
+        alloc_percpu,
+        free_percpu, //
+    },
+    cpumask::Cpumask,
+    prelude::*,
+    sync::Arc, //
+};
+
+use core::mem::{
+    align_of,
+    size_of,
+    MaybeUninit, //
+};
+
+/// Represents a dynamic allocation of a per-CPU variable via `alloc_percpu`. Calls `free_percpu`
+/// when dropped.
+///
+/// # Contents
+/// Note that the allocated memory need not be initialized, and this type does not track when/if
+/// the memory location on any particular CPU has been initialized. This means that it cannot tell
+/// whether it should drop the *contents* of the allocation when it is dropped. It is up to the
+/// user to do this via something like [`core::ptr::drop_in_place`].
+pub struct PerCpuAllocation<T>(PerCpuPtr<T>);
+
+impl<T: Zeroable> PerCpuAllocation<T> {
+    /// Dynamically allocates a space in the per-CPU area suitably sized and aligned to hold a `T`,
+    /// initially filled with the zero value for `T`.
+    ///
+    /// Returns [`None`] under the same circumstances the C function `alloc_percpu` returns `NULL`.
+    pub fn new_zero() -> Option<PerCpuAllocation<T>> {
+        let ptr: *mut MaybeUninit<T> =
+            // SAFETY: No preconditions to call `alloc_percpu`. The pointer is sized/aligned for a
+            // `T`, and `MaybeUninit<T>` is `#[repr(transparent)]` (and thus same size/align), so
+            // we can cast this `*mut c_void` to it.
+            unsafe { alloc_percpu(size_of::<T>(), align_of::<T>()) }.cast();
+        if ptr.is_null() {
+            return None;
+        }
+
+        // alloc_percpu returns zero'ed memory
+        Some(Self(PerCpuPtr::new(ptr)))
+    }
+}
+
+impl<T> PerCpuAllocation<T> {
+    /// Makes a per-CPU allocation sized and aligned to hold a `T`.
+    ///
+    /// Returns [`None`] under the same circumstances the C function `alloc_percpu` returns `NULL`.
+    pub fn new_uninit() -> Option<PerCpuAllocation<T>> {
+        let ptr: *mut MaybeUninit<T> =
+            // SAFETY: No preconditions to call `alloc_percpu`. The pointer is sized/aligned for a
+            // `T`, and `MaybeUninit<T>` is `#[repr(transparent)]` (and thus same size/align), so
+            // we can cast this `*mut c_void` to it.
+            unsafe { alloc_percpu(size_of::<T>(), align_of::<T>()) }.cast();
+        if ptr.is_null() {
+            return None;
+        }
+
+        Some(Self(PerCpuPtr::new(ptr)))
+    }
+}
+
+impl<T> Drop for PerCpuAllocation<T> {
+    fn drop(&mut self) {
+        // SAFETY: self.0.0 was returned by alloc_percpu, and so was a valid pointer into
+        // the percpu area, and has remained valid by the invariants of PerCpuAllocation<T>.
+        unsafe { free_percpu(self.0 .0.cast()) }
+    }
+}
+
+/// Holds a dynamically-allocated per-CPU variable.
+///
+/// # Examples
+/// ```
+/// # use kernel::prelude::*;
+/// # use kernel::percpu::*;
+/// # use kernel::percpu::cpu_guard::CpuGuard;
+///
+/// let mut pcpu: DynamicPerCpu<u32> =
+///   DynamicPerCpu::new_zero(GFP_KERNEL).expect("failed to allocate per-CPU variable");
+/// {
+///   let _guard = CpuGuard::new();
+///   // SAFETY: No other `pcpu` reference
+///   unsafe { pcpu.get_mut(CpuGuard::new()) }.with(|val| *val = 42);
+///   // SAFETY: No other `pcpu` reference
+///   unsafe { pcpu.get_mut(CpuGuard::new()) }.with(|val| assert!(*val == 42));
+/// }
+/// ```
+#[derive(Clone)]
+pub struct DynamicPerCpu<T> {
+    // INVARIANT: `alloc` is `Some` unless this object is in the process of being dropped.
+    // INVARIANT: The allocation held by `alloc` is sized and aligned for a `T`.
+    // INVARIANT: The memory location in each CPU's per-CPU area pointed at by the alloc is
+    // initialized.
+    alloc: Option<Arc<PerCpuAllocation<T>>>,
+}
+
+impl<T: Zeroable> DynamicPerCpu<T> {
+    /// Allocates a new per-CPU variable
+    ///
+    /// # Arguments
+    /// * `flags` - [`Flags`] used to allocate an [`Arc`] that keeps track of the underlying
+    ///   [`PerCpuAllocation`].
+    pub fn new_zero(flags: Flags) -> Option<Self> {
+        let alloc: PerCpuAllocation<T> = PerCpuAllocation::new_zero()?;
+
+        let arc = Arc::new(alloc, flags).ok()?;
+
+        Some(Self { alloc: Some(arc) })
+    }
+}
+
+impl<T: Clone> DynamicPerCpu<T> {
+    /// Allocates a new per-CPU variable
+    ///
+    /// # Arguments
+    /// * `val` - The initial value of the per-CPU variable on all CPUs.
+    /// * `flags` - Flags used to allocate an [`Arc`] that keeps track of the underlying
+    ///   [`PerCpuAllocation`].
+    pub fn new_with(val: &T, flags: Flags) -> Option<Self> {
+        Self::new_from(|_| val.clone(), flags)
+    }
+}
+
+impl<T> DynamicPerCpu<T> {
+    /// Allocates a new per-CPU variable
+    ///
+    /// # Arguments
+    /// * `initer` - A function that takes a `CpuId` and returns the initial value of the per-CPU
+    ///   variable on the corresponding CPU. Called once for each possible CPU (i.e.,
+    ///   `Cpumask::possible_cpus().weight()` times).
+    /// * `flags` - Flags used to allocate an [`Arc`] that keeps track of the underlying
+    ///   [`PerCpuAllocation`].
+    pub fn new_from(mut initer: impl FnMut(CpuId) -> T, flags: Flags) -> Option<Self> {
+        let alloc: PerCpuAllocation<T> = PerCpuAllocation::new_uninit()?;
+        let ptr = alloc.0;
+
+        let arc = Arc::new(alloc, flags).ok()?;
+
+        for cpu in Cpumask::possible_cpus().iter() {
+            let remote_ptr = ptr.get_remote_ptr(cpu);
+            // SAFETY: `remote_ptr` is valid because `ptr` points to a live allocation and `cpu`
+            // appears in `Cpumask::possible_cpus()`.
+            //
+            // Each CPU's slot corresponding to `ptr` is currently uninitialized, and no one else
+            // has a reference to it. Therefore, we can freely write to it without worrying about
+            // the need to drop what was there or whether we're racing with someone else.
+            unsafe {
+                (*remote_ptr).write(initer(cpu));
+            }
+        }
+
+        Some(Self { alloc: Some(arc) })
+    }
+}
+
+impl<T> PerCpu<T> for DynamicPerCpu<T> {
+    unsafe fn get_mut(&mut self, guard: CpuGuard) -> PerCpuToken<'_, T> {
+        // SAFETY:
+        // 1. Invariants of this type assure that `alloc` is `Some`.
+        // 2. The requirements of `PerCpu::get_mut` ensure that no other `[Checked]PerCpuToken`
+        //    exists on the current CPU.
+        // 3. The invariants of `DynamicPerCpu` ensure that the contents of the allocation are
+        //    initialized on each CPU.
+        // 4. The existence of a reference to the `PerCpuAllocation` ensures that the allocation is
+        //    live.
+        // 5. The invariants of `DynamicPerCpu` ensure that the allocation is sized and aligned for
+        //    a `T`.
+        unsafe { PerCpuToken::new(guard, &self.alloc.as_ref().unwrap_unchecked().0) }
+    }
+}
+
+impl<T: InteriorMutable> CheckedPerCpu<T> for DynamicPerCpu<T> {
+    fn get(&self, guard: CpuGuard) -> CheckedPerCpuToken<'_, T> {
+        // SAFETY:
+        // 1. Invariants of this type assure that `alloc` is `Some`.
+        // 2. The invariants of `DynamicPerCpu` ensure that the contents of the allocation are
+        //    initialized on each CPU.
+        // 3. The existence of a reference to the `PerCpuAllocation` ensures that the allocation is
+        //    live.
+        // 4. The invariants of `DynamicPerCpu` ensure that the allocation is sized and aligned for
+        //    a `T`.
+        unsafe { CheckedPerCpuToken::new(guard, &self.alloc.as_ref().unwrap_unchecked().0) }
+    }
+}
+
+impl<T> Drop for DynamicPerCpu<T> {
+    fn drop(&mut self) {
+        // SAFETY: This type's invariant ensures that `self.alloc` is `Some`.
+        let alloc = unsafe { self.alloc.take().unwrap_unchecked() };
+        if let Some(unique_alloc) = Arc::into_unique_or_drop(alloc) {
+            let ptr = unique_alloc.0;
+            for cpu in Cpumask::possible_cpus().iter() {
+                let remote_ptr = ptr.get_remote_ptr(cpu);
+                // SAFETY: `remote_ptr` is valid because the allocation it points to is still live,
+                // `cpu` appears in `Cpumask::possible_cpus()`, and the original allocation was
+                // sized and aligned for a `T`.
+                //
+                // This type's invariant ensures that the memory location in each CPU's per-CPU
+                // area pointed at by `alloc.0` has been initialized. We have a `UniqueArc`, so we
+                // know we're the only ones with a reference to the memory. These two facts
+                // together satisfy the requirements for `assume_init_drop`.
+                unsafe {
+                    (*remote_ptr).assume_init_drop();
+                }
+            }
+        }
+    }
+}

-- 
2.34.1


