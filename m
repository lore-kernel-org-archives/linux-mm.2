Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE0B8CCF9F8
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 23:02:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1DC9B8E000B; Wed,  5 Nov 2025 18:02:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F0938E000A; Wed,  5 Nov 2025 18:02:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED3C48E000B; Wed,  5 Nov 2025 18:02:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D81148E000A
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 18:02:34 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9625C5932F
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 23:02:34 +0000 (UTC)
X-FDA: 84078079428.25.4D9AB95
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	by imf23.hostedemail.com (Postfix) with ESMTP id 6B6D3140005
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 23:02:32 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=By+sdXQK;
	spf=pass (imf23.hostedemail.com: domain of levymitchell0@gmail.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=levymitchell0@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762383752;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TlxfvP2XGyBZ9ZWjp2nJWnVnTjycomxw0c/RHXKyKQo=;
	b=zv4wBl3n7H3l4dzpJo4qFsZy/uEAJqeQt1QXfdbz8uynfnbTEUTnCl5qlKveUfM8FN8LxJ
	X+a9VwZk3EB2JlAM5z6qY1epcY0HQ1Z9/IQozM5AtnItOhOvnx7pnaOg7d7h+LpYdnFUAx
	uBv0k8wsizfvjReaokvTmmMmGcVAW28=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=By+sdXQK;
	spf=pass (imf23.hostedemail.com: domain of levymitchell0@gmail.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=levymitchell0@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762383752; a=rsa-sha256;
	cv=none;
	b=f6xru4fl3n0NKGZDr9QKfHTz3ZA6YriQlWsUTZoRY4YsCSnkTm/JMDyQyars9bQVc+xURm
	fCxgj6q5PXab87KisCgWamvZZ+1U+eVMQVBxmj3Wq9i+wBQS/CHLEUUL58wykJvwsuTA5l
	QzY4leDzQXWWEUzxbDyrap83kvST6BU=
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-29524abfba3so3795035ad.1
        for <linux-mm@kvack.org>; Wed, 05 Nov 2025 15:02:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762383751; x=1762988551; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TlxfvP2XGyBZ9ZWjp2nJWnVnTjycomxw0c/RHXKyKQo=;
        b=By+sdXQK3Voxa1zeqMgbWlfkoZxK8HUtfGcgwAtDRalr9fNhzwIT+rhzwuBxfymhUs
         Zg3lTgy3Iac0c4L1r0WIOsmgvV/8MsHDtj+ikf5czIMIjLJhRnm3mnBjWNPOss8G1wTl
         Pm82oiJYPjvnet+UgI9rJQiUhPvSke7bFEiwfsta0PzMCus9UgKjrWZAjRi8SOQunNmO
         A+rJUQeN3wJ0cNpPXnTZDfD5T9zjDI8ZMHb13Q9zljj59WSVdRkmpkwGVVAGXnlTj5X0
         bXPyO0QHo6IAZhN+xM5q45DPfNMkzPLXjiR8PP1Ltex+qJNiCBh7MRLo3SitN5Ol1t68
         el8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762383751; x=1762988551;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TlxfvP2XGyBZ9ZWjp2nJWnVnTjycomxw0c/RHXKyKQo=;
        b=vc4l13ij6o5+hDDTWoBPXwiBwrqOKiwuRCig+AH2UScvYBghapknpZ77YyczEAwMq6
         VHOnmZ6oGdjR75DAiOS09sEWRoK3tOTrbfPZ/+podXEQP64NUeIbKTi3epcHprWqfKvo
         lOUj3L+RFhSS7LM7J2TxY76jLEUEokNlCxzydUwAPfaq3zC7Tt6aBuXsJCs1BjY94NZY
         xqXGpHlDfMUcZwz8cHhBVx0sVTunXPP6l/7BeAQqAjyYSWmogcW/GsAip2eBchbpwoyJ
         CozkbGt4vovDjo/bNQJ/qCsgHZAE3Xkd6yp/LIIVDpp0IX4k+wSyz99n3Ema4o8B1sSs
         Rd2A==
X-Forwarded-Encrypted: i=1; AJvYcCUYGwZ920aRWo0HGTJkV6EckVG7XW/uxy3SuJxB4zsTRWolhr+Ehfkubqe6TGcIagojKpmXM0xJ6w==@kvack.org
X-Gm-Message-State: AOJu0YxJTGscxRwYNt8UzzDvXZFAmPXBCpa4Sagz6kdw1JpeXOyXhAMU
	78ri6M5s7y9RmSUceeAYsSQeLTXGEJ4CLta/Ejf4AL4xpXSmk8+LZXMV
X-Gm-Gg: ASbGncu2myx6dGCNxpjTXUZcEScVCwvn3bEJpqdLue0Yweq09+epYlfbPTQ0GdsO4pJ
	RzecK/zLQYlP0AJfRy5FRwGZz4pXYJpyNY/SoLBcQMI5/GxP467KSRuNF5j1G/A7SFjMJDNzs91
	Cg1Z2ep2b5cb3iySld1yeFJGEYTkpd21vQQPAM6SfwJLJeVngbDtxoJyAHctYNfziEfyRYzfumG
	YMvlEdDHruHFj84NK117GtShKI04mr9+4AI1TGo9tQ7NQ+CZu2xZPBBM3ByLuviiK6m9WDHRHMU
	9xvGezrvXmjCiriNiDVyRqOefT5Rq1DqCek1hJMmnbCwlLOeVxT9yWFlxOUB16bWqJ+J7fgcCO6
	4xG40tk6rkwqoJxHYmc1hpASm4WyP5MnF30MUNXdu3QfbDJyzj15fEzjU+Yokos1WJexV8Yw7wQ
	rxjgX5nkED8gGhGusQK8Nw5WMPVfG2XUHLqA==
X-Google-Smtp-Source: AGHT+IEtcWPd7dB7RyrIUrheYv6CSgAxUf5dQTAqNss54XpxzEwcb9AjvOpQDtFIWbEWDoKZJmhUyw==
X-Received: by 2002:a17:903:1aa7:b0:295:98a1:7ddb with SMTP id d9443c01a7336-2962ade3309mr64506435ad.61.1762383750699;
        Wed, 05 Nov 2025 15:02:30 -0800 (PST)
Received: from mitchelllevy.localdomain ([131.107.147.147])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2965096839asm6325645ad.13.2025.11.05.15.02.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Nov 2025 15:02:30 -0800 (PST)
From: Mitchell Levy <levymitchell0@gmail.com>
Date: Wed, 05 Nov 2025 15:01:16 -0800
Subject: [PATCH v4 4/9] rust: percpu: introduce a rust API for static
 per-CPU variables
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251105-rust-percpu-v4-4-984b1470adcb@gmail.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1762383744; l=25644;
 i=levymitchell0@gmail.com; s=20240719; h=from:subject:message-id;
 bh=EZGO8S2GHg8ntWACzHd3jQtK+CxASeBX96N1M29X+1M=;
 b=VY87PCbOUQoIFarob7CleTCefLCX58T7Xi/O86w4FVkbK2dRHCYn55PyyLKrH1P8O+5VJk7sb
 KrXKjVUVQrzDb3qkJZBuLWCNge7F1wC5APDoK+DQXjg7loYU4SbbEUS
X-Developer-Key: i=levymitchell0@gmail.com; a=ed25519;
 pk=n6kBmUnb+UNmjVkTnDwrLwTJAEKUfs2e8E+MFPZI93E=
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 6B6D3140005
X-Stat-Signature: 15r1ufagx58phm9d7c4jsfcw8tpemqoa
X-Rspam-User: 
X-HE-Tag: 1762383752-899103
X-HE-Meta: U2FsdGVkX1/EDHG9bhhHoWhgA1jfo6Wjwl0ol5Ov2IfKrL/T7bzKMGqrv/iB85ULGgnPhfco9oxgABldYVxxRll5aB8mcimGwRnqwWgfe11phcLxrfTH50TUPriM+3IyTRUfDJYr6yuUw/xG6GPq+cE+x8mriwV4MOus/Q87naFa+WzHx20TJTGxAjxxDnAvz5r2P6AAAJCvZMM7FI6hjOf8Dvvmi81nuRttGGl1f6EPANcmwK7awdT5Iuhg5pJcfWDtF6CBDWiecxCOnQO0xWz3lnz8XoXFREqm1UM2OXZpKyw4lKu5Ek5065yW7KijdK8E+Gh0MMt7noJ5j1rLQisv/bIKVs5h/jF5mmDL2lD0YxKqWqd24Fo8fvF8oMi4Dk/bxgZouiUxjuBFjZbdolmZTdmFCclfjGtvkLq2+8YeG6IaRNOFghk+x0fjbUYuXMUn1+hjmXSy6V3AReP1EScTjzJtWlb5bV1UyN6ZNcp/AEAffHuMD+R5Je6xYmd2nkStTNUGdY8Wi59MC/7BNs9rsQEjBR/JUnUTA/SzX6CkyyZlJCNIueva/HRPYS3F2zG8Jm2sWOBdUp2fQ2n6GBQrBjuRM6IO907co/5j6s5cZ13PcCj3IF0CNQQrYAnDjszHrLkWKiU4EWln1ru8zsxDNIxee+ki4qhCMqsVIkCNKWqbGjUDso5SsD24BFX1tthcf/+ErMXlUistdj/wdZ/jZzWM/NprNRWjQnKNHhNhSGbcrdKde3a3Ngw7TPqqxbqLwOMop2MEuifhd0+nGQtWEfV53MtxfsS7Wj6doouzZjvb9Pq1E60ZStupsrZPIW3be+Bx38pmVW3kc678fvojUe6DKKWYWKRV57oNcsxNtyDMjRP+Y80Bm+H1vbQCjp3h0ea4O+KWDXemUw5bMP2wMHYKMl+36ec2izWGuoqw2kC9vyxKKDw51upxzgMrfeld9EqyB5Uit7mCO60
 hO78+BAx
 sKXt+5hJOupW1ZVPOfoojJw7NHaNNjmEYnSC9JVc4LHaHu5M7dW5eseXJfWc7WES+CSUDPX3nF3q6fNo3nR3OIP8Idnz0JqwqYaWJYLy88Bx8kDb1ePS1PvvXjlRkZ+rn6+ydgnuRvSyqVo1RAkQtHVn0UMU40/UizFLD3EYa75bWtqy5rhGuY8cVSQefX5jhzFWhM3l+nfGJKcXRWjkgt5DBDOFNds5vMPf+3EGWp3OhT0siCTm49tKlNMIrw5YBepqSTRVMqibjMtzazznyrPgM6H2lbPccjGEv+gI1mQeXhINlQhFSsGIEPYu5inyFyLNuWR0Ad1LWb6e3AHiP+q04Fpjign3QhQbbKkg1RJFRni//h+ImKJqXGSH/8Dvu2glW3rzMpxB6yWMnyH9ld0C3h6BTp9dBX/M5E7KQoDG4flStCThZP1Y8PBI1FJVJWnUu/KGppRB7DNKxwGMxRYMk68DAWpdgqkBi+6Br7kILjFkRW1L2EXjBGg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Per-CPU variables are an important tool for reducing lock contention,
especially in systems with many processors. They also provide a
convenient way to handle data that are logically associated with a
particular CPU (e.g., the currently running task).

Therefore, add a Rust API to make use of statically-allocated per-CPU
variables. Add a RAII `CpuGuard` type for disabling CPU preemption.
Introduce unifying abstractions that can be reused for a Rust API for
dynamically-allocated per-CPU variables.

Co-developed-by: Boqun Feng <boqun.feng@gmail.com>
Signed-off-by: Boqun Feng <boqun.feng@gmail.com>
Signed-off-by: Mitchell Levy <levymitchell0@gmail.com>
---
Using `rustc` 1.83.0, I can confirm that the symbols `__INIT_$id` are
optimized out by the compiler and do not appear in the final `.ko` file
when compiling `samples/rust/rust_percpu.rs` (introduced in a later
patch in this series).
---
 rust/kernel/lib.rs              |   3 +
 rust/kernel/percpu.rs           | 250 ++++++++++++++++++++++++++++++++++++++++
 rust/kernel/percpu/cpu_guard.rs |  36 ++++++
 rust/kernel/percpu/static_.rs   | 218 +++++++++++++++++++++++++++++++++++
 4 files changed, 507 insertions(+)

diff --git a/rust/kernel/lib.rs b/rust/kernel/lib.rs
index f910a5ab80ba..2fdb194aa068 100644
--- a/rust/kernel/lib.rs
+++ b/rust/kernel/lib.rs
@@ -108,6 +108,9 @@
 pub mod page;
 #[cfg(CONFIG_PCI)]
 pub mod pci;
+// Only x86_64 is supported by percpu for now
+#[cfg(CONFIG_X86_64)]
+pub mod percpu;
 pub mod pid_namespace;
 pub mod platform;
 pub mod prelude;
diff --git a/rust/kernel/percpu.rs b/rust/kernel/percpu.rs
new file mode 100644
index 000000000000..2fba9a165636
--- /dev/null
+++ b/rust/kernel/percpu.rs
@@ -0,0 +1,250 @@
+// SPDX-License-Identifier: GPL-2.0
+//! Per-CPU variables.
+//!
+//! See the [`crate::define_per_cpu!`] macro and the [`PerCpu<T>`] trait.
+
+pub mod cpu_guard;
+mod static_;
+
+#[doc(inline)]
+pub use static_::*;
+
+use crate::declare_extern_per_cpu;
+use crate::percpu::cpu_guard::CpuGuard;
+use crate::types::Opaque;
+
+use core::arch::asm;
+use core::cell::{Cell, RefCell, UnsafeCell};
+use core::mem::MaybeUninit;
+
+use ffi::c_void;
+
+/// A per-CPU pointer; that is, an offset into the per-CPU area.
+///
+/// Note that this type is NOT a smart pointer, it does not manage the allocation.
+pub struct PerCpuPtr<T>(*mut MaybeUninit<T>);
+
+/// Represents exclusive access to the memory location pointed at by a particular [`PerCpu<T>`].
+pub struct PerCpuToken<'a, T> {
+    // INVARIANT: the current CPU's memory location associated with the per-CPU variable pointed at
+    // by `ptr` (i.e., the entry in the per-CPU area on the current CPU) has been initialized.
+    _guard: CpuGuard,
+    ptr: &'a PerCpuPtr<T>,
+}
+
+/// Represents access to the memory location pointed at by a particular [`PerCpu<T>`] where the
+/// type `T` manages access to the underlying memory to avoid aliaising troubles.
+///
+/// For example, `T` might be a [`Cell`] or [`RefCell`].
+pub struct CheckedPerCpuToken<'a, T> {
+    // INVARIANT: the current CPU's memory location associated with the per-CPU variable pointed at
+    // by `ptr` (i.e., the entry in the per-CPU area on the current CPU) has been initialized.
+    _guard: CpuGuard,
+    ptr: &'a PerCpuPtr<T>,
+}
+
+impl<T> PerCpuPtr<T> {
+    /// Makes a new [`PerCpuPtr`] from a raw per-CPU pointer.
+    ///
+    /// Note that the returned [`PerCpuPtr`] is valid only as long as the given pointer is. This
+    /// also requires that the allocation pointed to by `ptr` must be correctly sized and aligned
+    /// to hold a `T`.
+    pub fn new(ptr: *mut MaybeUninit<T>) -> Self {
+        Self(ptr)
+    }
+
+    /// Get a [`&mut MaybeUninit<T>`](MaybeUninit) to the per-CPU variable on the current CPU
+    /// represented by `&self`
+    ///
+    /// # Safety
+    ///
+    /// The returned `&mut T` must follow Rust's aliasing rules. That is, no other `&(mut) T` may
+    /// exist that points to the same location in memory. In practice, this means that
+    /// [`Self::get_ref`] and [`Self::get_mut_ref`] must not be called on another [`PerCpuPtr<T>`]
+    /// that is a copy/clone of `&self` for as long as the returned reference lives. If the per-CPU
+    /// variable represented by `&self` is available to C, the caller of this function must ensure
+    /// that the C code does not modify the variable for as long as this reference lives.
+    ///
+    /// `self` must point to a live allocation correctly sized and aligned to hold a `T`.
+    ///
+    /// CPU preemption must be disabled before calling this function and for the lifetime of the
+    /// returned reference. Otherwise, the returned reference might end up being a reference to a
+    /// different CPU's per-CPU area, causing the potential for a data race.
+    #[allow(clippy::mut_from_ref)] // Safety requirements prevent aliasing issues
+    pub unsafe fn get_mut_ref(&self) -> &mut MaybeUninit<T> {
+        // SAFETY: `self.get_ptr()` returns a valid pointer to a `MaybeUninit<T>` by its contract,
+        // and the safety requirements of this function ensure that the returned reference is
+        // exclusive.
+        unsafe { &mut *(self.get_ptr()) }
+    }
+
+    /// Get a [`&mut MaybeUninit<T>`](MaybeUninit) to the per-CPU variable on the current CPU
+    /// represented by `&self`
+    ///
+    /// # Safety
+    ///
+    /// The returned `&T` must follow Rust's aliasing rules. That is, no `&mut T` may exist that
+    /// points to the same location in memory. In practice, this means that [`Self::get_mut_ref`]
+    /// must not be called on another [`PerCpuPtr<T>`] that is a copy/clone of `&self` for as long
+    /// as the returned reference lives. If the per-CPU variable represented by `&self` is
+    /// available to C, the caller of this function must ensure that the C code does not modify the
+    /// variable for as long as this reference lives.
+    ///
+    /// `self` must point to a live allocation correctly sized and aligned to hold a `T`.
+    ///
+    /// CPU preemption must be disabled before calling this function and for the lifetime of the
+    /// returned reference. Otherwise, the returned reference might end up being a reference to a
+    /// different CPU's per-CPU area, causing the potential for a data race.
+    pub unsafe fn get_ref(&self) -> &MaybeUninit<T> {
+        // SAFETY: `self.get_ptr()` returns a valid pointer to a `MaybeUninit<T>` by its contract.
+        // The safety requirements of this function ensure that the returned reference isn't
+        // aliased by a `&mut MaybeUninit<T>`.
+        unsafe { &*self.get_ptr() }
+    }
+
+    /// Get a [`*mut MaybeUninit<T>`](MaybeUninit) to the per-CPU variable on the current CPU
+    /// represented by `&self`. Note that if CPU preemption is not disabled before calling this
+    /// function, use of the returned pointer may cause a data race without some other
+    /// synchronization mechanism. Buyer beware!
+    pub fn get_ptr(&self) -> *mut MaybeUninit<T> {
+        let this_cpu_off_pcpu = ExternStaticPerCpuSymbol::ptr(&raw const this_cpu_off);
+        let mut this_cpu_area: *mut c_void;
+        // SAFETY: gs + this_cpu_off_pcpu is guaranteed to be a valid pointer because `gs` points
+        // to the per-CPU area and this_cpu_off_pcpu is a valid per-CPU allocation.
+        unsafe {
+            asm!(
+                "mov {out}, gs:[{off_val}]",
+                off_val = in(reg) this_cpu_off_pcpu.0,
+                out = out(reg) this_cpu_area,
+            )
+        };
+
+        // This_cpu_area + self.0 is guaranteed to be a valid pointer by the per-CPU subsystem and
+        // the invariant that self.0 is a valid offset into the per-CPU area.
+        (this_cpu_area).wrapping_add(self.0 as usize).cast()
+    }
+}
+
+// SAFETY: Sending a [`PerCpuPtr<T>`] to another thread is safe because as soon as it's sent, the
+// pointer is logically referring to a different place in memory in the other CPU's per-CPU area.
+// In particular, this means that there are no restrictions on the type `T`.
+unsafe impl<T> Send for PerCpuPtr<T> {}
+
+// SAFETY: Two threads concurrently making use of a [`PerCpuPtr<T>`] will each see the `T` in their
+// own per-CPU area, so there's no potential for a data race (regardless of whether `T` is itself
+// `Sync`).
+unsafe impl<T> Sync for PerCpuPtr<T> {}
+
+impl<T> Clone for PerCpuPtr<T> {
+    fn clone(&self) -> Self {
+        *self
+    }
+}
+
+/// [`PerCpuPtr`] is just a wrapper around a pointer.
+impl<T> Copy for PerCpuPtr<T> {}
+
+/// A trait representing a per-CPU variable.
+///
+/// This is implemented for [`StaticPerCpu<T>`]. The main usage of this trait is to call
+/// [`Self::get_mut`] to get a [`PerCpuToken`] that can be used to access the underlying per-CPU
+/// variable.
+///
+/// See [`PerCpuToken::with`].
+pub trait PerCpu<T> {
+    /// Produces a token, asserting that the holder has exclusive access to the underlying memory
+    /// pointed to by `self`
+    ///
+    /// # Safety
+    ///
+    /// No other [`PerCpuToken`] or [`CheckedPerCpuToken`] may exist on the current CPU (which is a
+    /// sensible notion, since we keep a [`CpuGuard`] around) that is derived from the same
+    /// [`PerCpu<T>`] or a clone thereof.
+    unsafe fn get_mut(&mut self, guard: CpuGuard) -> PerCpuToken<'_, T>;
+}
+
+/// A marker trait for types that are interior mutable. Types that implement this trait can be used
+/// to create "checked" per-CPU variables. See [`CheckedPerCpu<T>`].
+pub trait InteriorMutable {}
+
+impl<T> InteriorMutable for Cell<T> {}
+impl<T> InteriorMutable for RefCell<T> {}
+impl<T> InteriorMutable for UnsafeCell<T> {}
+impl<T> InteriorMutable for Opaque<T> {}
+
+/// A trait representing a per-CPU variable that is usable via a `&T`.
+///
+/// The unsafety of [`PerCpu<T>`] stems from the fact that the holder of a [`PerCpuToken`] can use
+/// it to get a `&mut T` to the underlying per-CPU variable. This is problematic because the
+/// existence of aliaising `&mut T` is undefined behavior in Rust. This type avoids that issue by
+/// only allowing access via a `&T`, with the tradeoff that then `T` must be interior mutable or
+/// the underlying per-CPU variable must be a constant for the lifetime of any corresponding
+/// [`CheckedPerCpuToken<T>`].
+///
+/// Currently, only the case where `T` is interior mutable has first-class support, though a custom
+/// implementation of [`PerCpu<T>`]/[`CheckedPerCpu<T>`] could be created for the const case.
+pub trait CheckedPerCpu<T>: PerCpu<T> {
+    /// Produces a token via which the holder can access the underlying per-CPU variable.
+    fn get(&mut self, guard: CpuGuard) -> CheckedPerCpuToken<'_, T>;
+}
+
+impl<'a, T> PerCpuToken<'a, T> {
+    /// Asserts that the holder has exclusive access to the initialized underlying memory pointed
+    /// to by `ptr` on the current CPU, producing a token.
+    ///
+    /// # Safety
+    ///
+    /// No other [`PerCpuToken`] or [`CheckedPerCpuToken`] may exist on the current CPU (which is a
+    /// sensible notion, since we keep a `CpuGuard` around) that uses the same [`PerCpuPtr<T>`].
+    ///
+    /// The current CPU's memory location associated with the per-CPU variable pointed at by `ptr`
+    /// (i.e., the entry in the per-CPU area on this CPU) must be initialized; `ptr` must be valid
+    /// (that is, pointing at a live per-CPU allocation correctly sized and aligned to hold a `T`)
+    /// for `'a`.
+    pub unsafe fn new(guard: CpuGuard, ptr: &'a PerCpuPtr<T>) -> PerCpuToken<'a, T> {
+        Self { _guard: guard, ptr }
+    }
+
+    /// Immediately invokes `func` with a `&mut T` that points at the underlying per-CPU variable
+    /// that `&mut self` represents.
+    pub fn with<U>(&mut self, func: U)
+    where
+        U: FnOnce(&mut T),
+    {
+        // SAFETY: The existence of a PerCpuToken means that the requirements for get_mut_ref are
+        // satisfied. Likewise, the requirements for assume_init_mut are satisfied because the
+        // invariants of this type ensure that on the current CPU (which is a sensible notion
+        // because we have a CpuGuard), the memory location pointed to by `ptr` is initialized.
+        func(unsafe { self.ptr.get_mut_ref().assume_init_mut() });
+    }
+}
+
+impl<'a, T> CheckedPerCpuToken<'a, T> {
+    /// Asserts that the memory pointed to by `ptr` is initialized on the current CPU, producing a
+    /// token.
+    ///
+    /// # Safety
+    ///
+    /// The current CPU's memory location associated with the per-CPU variable pointed at by `ptr`
+    /// (i.e., the entry in the per-CPU area on this CPU) must be initialized; `ptr` must be valid
+    /// (that is, pointing at a live per-CPU allocation correctly sized and aligned to hold a `T`)
+    /// for `'a`.
+    pub unsafe fn new(guard: CpuGuard, ptr: &'a PerCpuPtr<T>) -> CheckedPerCpuToken<'a, T> {
+        Self { _guard: guard, ptr }
+    }
+
+    /// Immediately invokes `func` with a `&T` that points at the underlying per-CPU variable that
+    /// `&mut self` represents.
+    pub fn with<U>(&mut self, func: U)
+    where
+        U: FnOnce(&T),
+    {
+        // SAFETY: The existence of a CheckedPerCpuToken means that the requirements for get_ref
+        // are satisfied. Likewise, the requirements for assume_init_ref are satisfied because the
+        // invariants of this type ensure that on the current CPU (which is a sensible notion
+        // because we have a CpuGuard), the memory location pointed to by `ptr` is initialized.
+        func(unsafe { self.ptr.get_ref().assume_init_ref() });
+    }
+}
+
+declare_extern_per_cpu!(this_cpu_off: *mut c_void);
diff --git a/rust/kernel/percpu/cpu_guard.rs b/rust/kernel/percpu/cpu_guard.rs
new file mode 100644
index 000000000000..2fb4c9218922
--- /dev/null
+++ b/rust/kernel/percpu/cpu_guard.rs
@@ -0,0 +1,36 @@
+// SPDX-License-Identifier: GPL-2.0
+//! Contains abstractions for disabling CPU preemption. See [`CpuGuard`].
+
+/// A RAII guard for `bindings::preempt_disable` and `bindings::preempt_enable`.
+///
+/// Guarantees preemption is disabled for as long as this object exists.
+pub struct CpuGuard {
+    // Don't make one without using new()
+    _phantom: (),
+}
+
+impl CpuGuard {
+    /// Create a new [`CpuGuard`]. Disables preemption for its lifetime.
+    pub fn new() -> Self {
+        // SAFETY: There are no preconditions required to call preempt_disable
+        unsafe {
+            bindings::preempt_disable();
+        }
+        CpuGuard { _phantom: () }
+    }
+}
+
+impl Default for CpuGuard {
+    fn default() -> Self {
+        Self::new()
+    }
+}
+
+impl Drop for CpuGuard {
+    fn drop(&mut self) {
+        // SAFETY: There are no preconditions required to call preempt_enable
+        unsafe {
+            bindings::preempt_enable();
+        }
+    }
+}
diff --git a/rust/kernel/percpu/static_.rs b/rust/kernel/percpu/static_.rs
new file mode 100644
index 000000000000..418fc2fa06f2
--- /dev/null
+++ b/rust/kernel/percpu/static_.rs
@@ -0,0 +1,218 @@
+// SPDX-License-Identifier: GPL-2.0
+//! Statically allocated per-CPU variables.
+
+use super::*;
+
+/// A wrapper used for declaring static per-CPU variables.
+///
+/// These symbols are "virtual" in that the linker uses them to generate offsets into each CPU's
+/// per-CPU area, but shouldn't be read from/written to directly. The fact that the statics are
+/// immutable prevents them being written to (generally), this struct having _val be non-public
+/// prevents reading from them.
+///
+/// The end-user of the per-CPU API should make use of the [`crate::define_per_cpu!`] macro instead
+/// of declaring variables of this type directly. All instances of this type must be `static` and
+/// `#[link_section = ".data..percpu"]` (which the macro handles).
+#[repr(transparent)]
+pub struct StaticPerCpuSymbol<T> {
+    _val: T, // generate a correctly sized type
+}
+
+/// A wrapper for per-CPU variables declared in C.
+///
+/// As with [`StaticPerCpuSymbol`], this type should not be used directly. Instead, use the
+/// [`crate::declare_extern_per_cpu!`] macro.
+#[repr(transparent)]
+pub struct ExternStaticPerCpuSymbol<T>(StaticPerCpuSymbol<T>);
+
+/// Holds a statically-allocated per-CPU variable.
+#[derive(Clone)]
+pub struct StaticPerCpu<T>(pub(super) PerCpuPtr<T>);
+
+impl<T: PerCpuSyncMarkerType> StaticPerCpuSymbol<T> {
+    /// Removes the per-CPU marker type from a static per-CPU symbol.
+    ///
+    /// To declare a static per-CPU variable, Rust requires that the variable be `Sync`. However,
+    /// in the case of per-CPU variables, this is silly. See [`PerCpuSyncMarkerType`]. Thus, our
+    /// statics are actually of type `StaticPerCpuSymbol<PerCpuSyncMarkerType<T>>`, and this
+    /// produces a `StaticPerCpuSymbol<T>`.
+    pub fn forward(ptr: *const Self) -> *const StaticPerCpuSymbol<T::Inner> {
+        ptr.cast()
+    }
+}
+
+impl<T> ExternStaticPerCpuSymbol<T> {
+    /// Gets a [`PerCpuPtr`] to the per-CPU variable.
+    ///
+    /// Usage of this [`PerCpuPtr`] must be very careful to keep in mind what's happening in C. In
+    /// particular, the C code cannot modify the variable while any reference derived from the
+    /// returned pointer is live.
+    pub fn ptr(ptr: *const Self) -> PerCpuPtr<T> {
+        // These casts are OK because, ExternStaticPerCpuSymbol, StaticPerCpuSymbol, and
+        // MaybeUninit are transparent, everything is just a `T` from a memory layout perspective.
+        // Casting to `mut` is OK because any usage of the returned pointer must satisfy the
+        // soundness requirements for using it as such.
+        PerCpuPtr::new(ptr.cast::<StaticPerCpuSymbol<T>>().cast_mut().cast())
+    }
+}
+
+impl<T> StaticPerCpu<T> {
+    /// Creates a [`StaticPerCpu<T>`] from a [`StaticPerCpuSymbol<T>`].
+    ///
+    /// Users should probably declare static per-CPU variables with [`crate::define_per_cpu!`] and
+    /// then get instances of [`StaticPerCpu`] using [`crate::get_static_per_cpu!`].
+    ///
+    /// # Safety
+    /// You should probably be using [`crate::get_static_per_cpu!`] instead.
+    ///
+    /// `ptr` must be a valid offset into the per-CPU area, sized and aligned for access to a `T`;
+    /// typically this is the address of a static in the `.data..percpu` section, which is managed
+    /// by the per-CPU subsystem.
+    pub unsafe fn new(ptr: *const StaticPerCpuSymbol<T>) -> StaticPerCpu<T> {
+        let pcpu_ptr = PerCpuPtr::new(ptr.cast_mut().cast());
+        Self(pcpu_ptr)
+    }
+}
+
+impl<T> PerCpu<T> for StaticPerCpu<T> {
+    unsafe fn get_mut(&mut self, guard: CpuGuard) -> PerCpuToken<'_, T> {
+        // SAFETY:
+        // 1. By the requirements of `PerCpu::get_mut`, no other `[Checked]PerCpuToken` exists on
+        //    the current CPU.
+        // 2. The per-CPU subsystem guarantees that each CPU's instance of a statically allocated
+        //    variable begins with a copy of the contents of the corresponding symbol in
+        //    `.data..percpu` and is therefore initialized.
+        // 3. The per-CPU subsystem guarantees that `self.0` is correctly aligned for a `T`.
+        // 4. The per-CPU subsystem guarantees that `self.0` is lives forever as a per-CPU
+        //    allocation, and that this allocation is the proper size for a `T`.
+        unsafe { PerCpuToken::new(guard, &self.0) }
+    }
+}
+
+impl<T: InteriorMutable> CheckedPerCpu<T> for StaticPerCpu<T> {
+    fn get(&mut self, guard: CpuGuard) -> CheckedPerCpuToken<'_, T> {
+        // SAFETY:
+        // 1. The per-CPU subsystem guarantees that each CPU's instance of a statically allocated
+        //    variable begins with a copy of the contents of the corresponding symbol in
+        //    `.data..percpu` and is therefore initialized.
+        // 2. The per-CPU subsystem guarantees that `self.0` is correctly aligned for a `T`.
+        // 3. The per-CPU subsystem guarantees that `self.0` is lives forever as a per-CPU
+        //    allocation, and that this allocation is the proper size for a `T`.
+        unsafe { CheckedPerCpuToken::new(guard, &self.0) }
+    }
+}
+
+/// Gets a [`StaticPerCpu<T>`] from a symbol declared with [`crate::define_per_cpu!`].
+///
+/// # Arguments
+///
+/// * `ident` - The identifier declared
+#[macro_export]
+macro_rules! get_static_per_cpu {
+    ($id:ident) => {
+        unsafe {
+            // SAFETY: The signature of `StaticPerCpuSymbol::forward` guarantees that `&raw const
+            // $id` is a `*const StaticPerCpuSymbol<PerCpuSyncMarkerType<T>>` if the macro
+            // invocation compiles.
+            //
+            // Values of type `StaticPerCpuSymbol<T>` must be created via `define_per_cpu`, and so
+            // the per-CPU subsystem guarantees that the requirements for `StaticPerCpu::new` are
+            // satisfied.
+            $crate::percpu::StaticPerCpu::new($crate::percpu::StaticPerCpuSymbol::forward(
+                &raw const $id,
+            ))
+        }
+    };
+}
+
+/// Declares an [`ExternStaticPerCpuSymbol`] corresponding to a per-CPU variable defined in C.
+#[macro_export]
+macro_rules! declare_extern_per_cpu {
+    ($id:ident: $ty:ty) => {
+        extern "C" {
+            static $id: ExternStaticPerCpuSymbol<$ty>;
+        }
+    };
+}
+
+/// A trait implemented by static per-CPU wrapper types.
+///
+/// Internally, static per-CPU variables are declared as `static` variables. However, Rust doesn't
+/// allow you to declare statics of a `!Sync` type. This trait is implemented by the marker type
+/// that is declared as `Sync` and used to declare the static. See [`crate::define_per_cpu!`] for
+/// the gory details.
+///
+/// # Safety
+///
+/// Implementations must be `#[repr(transparent)]` wrappers around an `Inner`. This trait should
+/// only be used from the [`crate::define_per_cpu!`] macro.
+pub unsafe trait PerCpuSyncMarkerType {
+    /// The "true" type of the per-CPU variable. It must always be valid to cast a `*const Self` to
+    /// a `*const Self::Inner`, which is guarnateed by this trait's safety requirement.
+    type Inner;
+}
+
+/// Declares and initializes a static per-CPU variable.
+///
+/// Analogous to the C `DEFINE_PER_CPU` macro.
+///
+/// See also [`crate::get_static_per_cpu!`] for how to get a [`StaticPerCpu`] from this
+/// declaration.
+///
+/// # Example
+/// ```
+/// use kernel::define_per_cpu;
+/// use kernel::percpu::StaticPerCpuSymbol;
+///
+/// define_per_cpu!(pub MY_PERCPU: u64 = 0);
+/// ```
+#[macro_export]
+macro_rules! define_per_cpu {
+    ($vis:vis $id:ident: $ty:ty = $expr:expr) => {
+        $crate::macros::paste! {
+            // We might want to have a per-CPU variable that doesn't implement `Sync` (not paying
+            // sync overhead costs is part of the point), but Rust won't let us declare a static of
+            // a `!Sync` type. Of course, we don't actually have any synchronization issues, since
+            // each CPU will see its own copy of the variable, so we cheat a little bit and tell
+            // Rust it's fine.
+            #[doc(hidden)]
+            #[allow(non_camel_case_types)]
+            #[repr(transparent)] // It needs to be the same size as $ty
+            struct [<__PRIVATE_TYPE_ $id>]($ty);
+
+            // SAFETY: [<__PRIVATE_TYPE_ $id>] is a `#[repr(transparent)]` wrapper around a `$ty`.
+            unsafe impl PerCpuSyncMarkerType for [<__PRIVATE_TYPE_ $id>] {
+                type Inner = $ty;
+            }
+
+            impl [<__PRIVATE_TYPE_ $id>] {
+                #[doc(hidden)]
+                const fn new(val: $ty) -> Self {
+                    Self(val)
+                }
+            }
+
+            // Expand $expr outside of the unsafe block to avoid silently allowing unsafe code to be
+            // used without a user-facing unsafe block
+            #[doc(hidden)]
+            static [<__INIT_ $id>]: [<__PRIVATE_TYPE_ $id>] = [<__PRIVATE_TYPE_ $id>]::new($expr);
+
+            // SAFETY: This type will ONLY ever be used to declare a `StaticPerCpuSymbol`
+            // (which we then only ever use as input to `&raw`). Reading from the symbol is
+            // already UB, so we won't ever actually have any variables of this type where
+            // synchronization is a concern.
+            #[doc(hidden)]
+            unsafe impl Sync for [<__PRIVATE_TYPE_ $id>] {}
+
+            // SAFETY: StaticPerCpuSymbol<T> is #[repr(transparent)], so we can freely convert from
+            // [<__PRIVATE_TYPE_ $id>], which is also `#[repr(transparent)]` (i.e., everything is
+            // just a `$ty` from a memory layout perspective).
+            #[link_section = ".data..percpu"]
+            $vis static $id: StaticPerCpuSymbol<[<__PRIVATE_TYPE_ $id>]> = unsafe {
+                core::mem::transmute_copy::<
+                    [<__PRIVATE_TYPE_ $id>], StaticPerCpuSymbol<[<__PRIVATE_TYPE_ $id>]>
+                >(&[<__INIT_ $id>])
+            };
+        }
+    };
+}

-- 
2.34.1


