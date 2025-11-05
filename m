Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0BE5CCFA19
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 23:02:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 251358E000C; Wed,  5 Nov 2025 18:02:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1DACC8E000A; Wed,  5 Nov 2025 18:02:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 005E98E000C; Wed,  5 Nov 2025 18:02:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DBFA28E000A
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 18:02:35 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AEBCF1A04FF
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 23:02:35 +0000 (UTC)
X-FDA: 84078079470.16.B760AF3
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	by imf19.hostedemail.com (Postfix) with ESMTP id 987FB1A000C
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 23:02:33 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=hAsfXKqB;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of levymitchell0@gmail.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=levymitchell0@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762383753; a=rsa-sha256;
	cv=none;
	b=0gLDpNk1eOmNJGNLo5N2ev/Tv1DNgdBeMtSsqz2HdnxkZCfD19uLDs4a3Z45ng1veIkfn/
	mTKk7Sziy1UKqXlthp4NiICKXYzRcMqWktljun+FDjS7xOl2G0DV9Uw11I0+achqN8hD+s
	zUzXCjxKh5z1AjAR5FI59BFhvWdnggE=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=hAsfXKqB;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of levymitchell0@gmail.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=levymitchell0@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762383753;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WFJ1wrPBcxrrD+LBS55P13yiT8NfiLst30CpnCOiPfc=;
	b=2ZerRslqKTQ2z5dLi4fn+fsfZNtu84waqd87OD82rZZkVx+6meBZM4fYhPBSO06Imu/17i
	bpqmikixZ0F/cHaZUNzcWmC+r1ihHEFZ5A/gr4EaQiwEVqCE1xwr1pP6DoEcQtG9G3BVhz
	JaYoRYiV32uue5eH7ISmnZi6Vb/lsdM=
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-341d07c020fso172881a91.2
        for <linux-mm@kvack.org>; Wed, 05 Nov 2025 15:02:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762383752; x=1762988552; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WFJ1wrPBcxrrD+LBS55P13yiT8NfiLst30CpnCOiPfc=;
        b=hAsfXKqBD0M4UDZIdfNI+6DK9hlSqZn9uQOEfLNs5n0mHQZ6d8e38awFRg3NBtQ/Pv
         Ce7O418UrU9YRDChcC4BxWZtgo7EVQq9mhVA2Cl3tYE4vQkeT3s9f+vt9qxZBWk2zsuj
         32FoDCUx4s63QeCV7PUD7ShnnCMmBgmVp48rZxM9eG3ZXRMbQFXj6sSnso17ZuX86lFa
         9ce0K9o1KpJg0LIzivwI7zYEvPHtDlEbesv06UF6BhTG48iGqoFdeQKwLTkXe4ilUZAa
         o0roSlDH/nPm0tREcOdbGDCYsXwSAUhB7CzD0v/xZz7pngSfYXn02kXi67lRz0X8fCVZ
         lNig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762383752; x=1762988552;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WFJ1wrPBcxrrD+LBS55P13yiT8NfiLst30CpnCOiPfc=;
        b=IvpghK1HtKSpNdtzLXrensAnoSaXf68dQeCoy//CinS4GTBc/HigrUg2YZKrgUbMUU
         1McPWx0xNdFXy5DG+j+tBEiH9lWXZkI9+AE7S2jmp6pMHbW5QJRU2eqUn3Dz7WCRabV3
         5RGEaozP2T03aatE0RbSvoohPaaEh0THdv1kWLpbET/l6ZUxOvNU/gqCey97JvSp6hzb
         QkXy3PHIkkhNja76JkSY5ErxLYL97LZhIKJzRNQXwJ6w98MUDq3umCRXGI3r9rjlcSU3
         AlQypCyfdI+ekapfG4IO64+Q1k4DxmMyE6HL3oYzQDSavlUfvIi6eh2wMGd2F5a4Nhjk
         wtWg==
X-Forwarded-Encrypted: i=1; AJvYcCU8qLgoSwqqlTk6Fj+pmmpc7ypLn3R2F3D/FLhTeLMQaeIamE8cK+LXTTknIxODgTnQQWGQ+x2AkQ==@kvack.org
X-Gm-Message-State: AOJu0YxRZBEXu8U7leihCE+4vDZBNhnpCmzhdoP2ecuHYEE2gHmv5Ifl
	2b5/DaXC6h2e6vJ1YjMqoQKopVDKBKY3unlYvkNRdcN6n2iJF66LPzcP
X-Gm-Gg: ASbGncubMlHUsV6Vq93LxqnYFhg4EZwZowDyRE9Adj7BjjkXMRDmMGHeOrz48BC3K2w
	zTe2im5SGZeQO22UpTunbBuSs+OaFVdFA/pf0CaiqMp600alGCvpPmJZl84kB4tJ6Ke4c/blYyk
	OWqklUtJXTzwQJKVHcNh7Vo46Py47n2AUBMb6cN4bgQn93DbgEm3ND4U3FBiEbOCfVcLdRjRgQX
	wF87TfGORJMWwoiVtEzrXQnAOKMDoRkP9UOLRrnygHw5MlBhSwB/XHs0RZheYiamrZmed6TlbHZ
	J/aoKCdlcXgSMjczibOcZN1183T7tSSXohliHwiKExeQXtNxFZNcljLaUasxzsUcleemVx0xUE0
	j2XaAqY2pgLmoE6KG1yO2IQa5GU2xAu3QTsTA84NDdETKOT1ss4FSHJbUIh5B1YkCG5dYjM8Fw5
	dccs6sXE2/uu4UuVYwrdTXxE61NmlLnG+bDA==
X-Google-Smtp-Source: AGHT+IE1c9+ZrzqLcSGm3uQ2ejRBT2CJMVQlT9ke7gOJ6htC5411VVsiXKPhB80c9d8mxSq7gHQUCw==
X-Received: by 2002:a17:903:1b65:b0:294:e8a0:382b with SMTP id d9443c01a7336-2962ae57374mr72286265ad.54.1762383752237;
        Wed, 05 Nov 2025 15:02:32 -0800 (PST)
Received: from mitchelllevy.localdomain ([131.107.147.147])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2965096839asm6325645ad.13.2025.11.05.15.02.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Nov 2025 15:02:31 -0800 (PST)
From: Mitchell Levy <levymitchell0@gmail.com>
Date: Wed, 05 Nov 2025 15:01:17 -0800
Subject: [PATCH v4 5/9] rust: percpu: introduce a rust API for dynamic
 per-CPU variables
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251105-rust-percpu-v4-5-984b1470adcb@gmail.com>
References: <20251105-rust-percpu-v4-0-984b1470adcb@gmail.com>
In-Reply-To: <20251105-rust-percpu-v4-0-984b1470adcb@gmail.com>
To: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
 Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Andreas Hindborg <a.hindborg@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
 Trevor Gross <tmgross@umich.edu>, Andrew Morton <akpm@linux-foundation.org>, 
 Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, 
 Christoph Lameter <cl@linux.com>, Danilo Krummrich <dakr@kernel.org>, 
 Benno Lossin <lossin@kernel.org>, Yury Norov <yury.norov@gmail.com>, 
 Viresh Kumar <viresh.kumar@linaro.org>
Cc: Tyler Hicks <code@tyhicks.com>, Allen Pais <apais@linux.microsoft.com>, 
 linux-kernel@vger.kernel.org, rust-for-linux@vger.kernel.org, 
 linux-mm@kvack.org, Mitchell Levy <levymitchell0@gmail.com>
X-Mailer: b4 0.14.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1762383744; l=9789;
 i=levymitchell0@gmail.com; s=20240719; h=from:subject:message-id;
 bh=mFg9QLMAwyqIxa/N6WNggn20WoF/wqWYILNGfUHwvYw=;
 b=rC6LvrXQz84xbSb5BvGzEQo3PK2NO2XHoHUt+ISh2JaHvuW2RktvXy7YCgzUy8bvkJ1wqFQWO
 bxVWrfmsXOSBxGpV0RbAHoOa2jK6XivWxBpY5qWUYmJnPND48kmTwbK
X-Developer-Key: i=levymitchell0@gmail.com; a=ed25519;
 pk=n6kBmUnb+UNmjVkTnDwrLwTJAEKUfs2e8E+MFPZI93E=
X-Rspamd-Queue-Id: 987FB1A000C
X-Rspamd-Server: rspam07
X-Stat-Signature: r5kj88ng5j3gbzcdj97h7x9d6bfj4b9i
X-Rspam-User: 
X-HE-Tag: 1762383753-53477
X-HE-Meta: U2FsdGVkX19h+HAanawiioJTtmZAn/IEPfxZQuGIeFPORdwEZXvShZEsrv6O4YX4JoGMugMqVKDRTZrtCUu9VMEqE6C3+uZdiX73Fx6UP2hgev0nzz4JUd47RWqcYzrIgy0ZrTXk982BeyTgPVUjgQmn65t+SMFuwYJW1YqEx+LabjI9JO9WDruMJiTxW67HqqWhga0llFm2rejCA4v4rxz0gwrJCvpeOieVbWELLDZQxnHmfhzWon+tAvItJPQU41WSaYkUEvKhpBE8Dks9T0PWd6/SIVRxmB8mLTcYQ8tZ5m37p15iRUEhc4I8+mtjpWGpj0wJ30j8P7j8M1sVKthp+oam39sF2W5iN+dJURw3bUIfudvzMbUZxY76w7V78n8LS/ZxgWbN0j/XxMqzyP2GN/znDzkt6jkxqX6WlQdd6hVqKSpNTvXPt8RZMY8skgjbKwCLKATG82zv1imHnmOSnECyZjroC5BPF6mAy+8hC6dvpSz3OlwRag4X/q0tHdn5PxWW5PFg7MYQzQ0cjl3+eKe9iDJw/6QxDnZVVpBASSH2//NDPEpQL2OE0ljF1gfUDKuB3lChzt0C9/fi4GMngYCCyEzSHJBgtQQoqtKpkBiOOMVRD1XQwYJnA6sSZ1qPzVUn5mg/Dv8W/K4DtLtXW4qCURy41XPzkbvmInlC6emYSWXKnk/1YeRt+UNJ134h4G07k4C151qTG6pqQErewZybHZK1JAsnR+DzUNskLYkIrs9D0795Lmr5ADJ4nc3A6cpMr6irIGn31roDPQjPjHb+wOpmK6s4cwpET5PXz4oHgxJ0y3rChhYtg9woyqZFAlWV2viF3wdsc1QMVvSr0deastgBSvEn2kqTG+E55TfNmI5unztZkLbyc0ZL1E/gOnux0KyzV45LhyCbRJbhiMjouujtvCzl/srBovD4mCuub4hGCyf3595+9EBQz6bMF4FR1uJq0YHqxpu
 PuN91aPJ
 t+QhChD2l2fHTyWqMdNVe8nLhJ9laGhAPjAScj0V2JEZrtXTNeAxyiH52Z9+Cmp+qHk4i/RGcjBPcImt+gR4giz4VSut5QJr8TH8DxwXDOsSNhnLIWHMYiKRlslx2dWBK2+8YGkbO0QkmC5dXPEGAt/36ggn90DwIxWX3Rwhdb46sUy0ulS3QGNMUejVQDtArZHWnr/mZrVSSFbyl8V82s1ApCS1S7ewWLA1BF0FkjozdceErsfEaZ/gjRfVhjleMfhUMnxzVQ888rLQ+qHs55ihIg1tyK497BzhUQPWKYH65Zk2ABqJLmgtr3DakmT72ArcTWY9tmk5Tjz2mG8KCUsvPETxqYeyBmxVymiVqU6w7Py/9IoOKDQxK4RjXcXVf2NnsVKDL8abGjCK4t1YWcYewAl/LVhRUbqktELJwy38MO66E9ZRNnwm8A7FQc2nzDTOr/iJig9St7Er5xzXmyAUsI1mo6ZMpFy5CVPYJowUqgeTtTK0qcZPpNQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Dynamically allocated per-CPU variables are core to many of the
use-cases of per-CPU variables (e.g., ref counting). Add support for
them using the core `PerCpuPtr<T>` primitive, implementing the
`PerCpu<T>` trait.

Co-developed-by: Boqun Feng <boqun.feng@gmail.com>
Signed-off-by: Boqun Feng <boqun.feng@gmail.com>
Signed-off-by: Mitchell Levy <levymitchell0@gmail.com>
---
 rust/helpers/percpu.c         |  10 ++++
 rust/kernel/percpu.rs         |  30 ++++++++--
 rust/kernel/percpu/dynamic.rs | 130 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 166 insertions(+), 4 deletions(-)

diff --git a/rust/helpers/percpu.c b/rust/helpers/percpu.c
index a091389f730f..35656333dfae 100644
--- a/rust/helpers/percpu.c
+++ b/rust/helpers/percpu.c
@@ -7,3 +7,13 @@ void __percpu *rust_helper_alloc_percpu(size_t sz, size_t align)
 	return __alloc_percpu(sz, align);
 }
 
+void *rust_helper_per_cpu_ptr(void __percpu *ptr, unsigned int cpu)
+{
+	return per_cpu_ptr(ptr, cpu);
+}
+
+void rust_helper_on_each_cpu(smp_call_func_t func, void *info, int wait)
+{
+	on_each_cpu(func, info, wait);
+}
+
diff --git a/rust/kernel/percpu.rs b/rust/kernel/percpu.rs
index 2fba9a165636..294b8ffc4f62 100644
--- a/rust/kernel/percpu.rs
+++ b/rust/kernel/percpu.rs
@@ -1,14 +1,19 @@
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
 
+use crate::cpu::CpuId;
 use crate::declare_extern_per_cpu;
 use crate::percpu::cpu_guard::CpuGuard;
 use crate::types::Opaque;
@@ -123,6 +128,23 @@ pub fn get_ptr(&self) -> *mut MaybeUninit<T> {
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
@@ -146,9 +168,9 @@ impl<T> Copy for PerCpuPtr<T> {}
 
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
index 000000000000..1863f31a2817
--- /dev/null
+++ b/rust/kernel/percpu/dynamic.rs
@@ -0,0 +1,130 @@
+// SPDX-License-Identifier: GPL-2.0
+//! Dynamically allocated per-CPU variables.
+
+use super::*;
+
+use crate::alloc::Flags;
+use crate::bindings::{alloc_percpu, free_percpu};
+use crate::cpumask::Cpumask;
+use crate::prelude::*;
+use crate::sync::Arc;
+use core::mem::{align_of, size_of, MaybeUninit};
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
+            // SAFETY: No preconditions to call `alloc_percpu`; `MaybeUninit<T>` is
+            // `#[repr(transparent)]`, so we can cast a `*mut T` to it.
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
+            // SAFETY: No preconditions to call `alloc_percpu`; `MaybeUninit<T>` is
+            // `#[repr(transparent)]`, so we can cast a `*mut T` to it.
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
+impl<T> Drop for DynamicPerCpu<T> {
+    fn drop(&mut self) {
+        // SAFETY: This type's invariant ensures that `self.alloc` is `Some`.
+        let alloc = unsafe { self.alloc.take().unwrap_unchecked() };
+        if let Some(unique_alloc) = alloc.into_unique_or_drop() {
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


