Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75294C8303F
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 19:01:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B54738E0032; Thu, 28 Aug 2025 15:01:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B04BA8E0024; Thu, 28 Aug 2025 15:01:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 86DED8E0032; Thu, 28 Aug 2025 15:01:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5FE338E0024
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 15:01:04 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DC3D21DD5E7
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 19:01:03 +0000 (UTC)
X-FDA: 83827083606.24.6833F5D
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	by imf01.hostedemail.com (Postfix) with ESMTP id BF22D4001F
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 19:01:01 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=QmyG6T8S;
	spf=pass (imf01.hostedemail.com: domain of levymitchell0@gmail.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=levymitchell0@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756407661; a=rsa-sha256;
	cv=none;
	b=IRZMwjUnymsq0pLogz7mhmBvJs4J9iOcUOtsAndVZQuMsjRiB8ph2muj4hna0JM/D59P/y
	4B/X7tlfiKOgJZZBz1Bf7WcmSHf8+Z1pWjGlEXYueOgZW8dwIlH7pXCXzUc+PN3oU/2Wvi
	DsZk9qjWsg22X85jU1eZViFMjxCmJYY=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=QmyG6T8S;
	spf=pass (imf01.hostedemail.com: domain of levymitchell0@gmail.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=levymitchell0@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756407661;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MV4GmSdkUNmPQjyOi2VED+Xs96RqoKvGI46q2QRv97g=;
	b=KP/Bw9g0q1g/PYZ7EcbkymQ3vTtb0I7NGHJylM3Khw56o6kkpLuR8rW5g58pqWhXmp342s
	ag1DkSlyvUbvJUSv3iMfqA7BP3AX6yzxGH73ctqj7dPHlz6AohKqUOOKs3vp9qmDbeYGa1
	JZRze8X/uWeEZ5IOlxhTCAfcpGBZRwA=
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-325393d0ddaso1032199a91.3
        for <linux-mm@kvack.org>; Thu, 28 Aug 2025 12:01:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756407661; x=1757012461; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MV4GmSdkUNmPQjyOi2VED+Xs96RqoKvGI46q2QRv97g=;
        b=QmyG6T8SQJlE+QB7edbdjd/vQewSVlz735gCMjhMG/9zojktZbz0eszsqJMetVWWC9
         S90AFRWzmb667T6W9YLo8SespUGdt3wLyKXmRfMq21JaSCvEfoWNAOUhylSibmZWD/gB
         d1sJBDIV7Tlf4vH7aUFXXTkfLvjTZUr1NgYatzK72Xg8p22PpFipYOFLSaELnKBmPUPb
         1rf4hPO6SifGfiUluNl6m6w21wMJEJ9My8OlUvJWKYuvC7efyvIsnMAOHU9lE3wE2T1a
         +Viqgo/I1gbXBxeO9HfJ1i+1y/EaCYh3Va+pCVKWb/JIbF8EAdXOTCjuqqe7PFxQqMzX
         8Kig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756407661; x=1757012461;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MV4GmSdkUNmPQjyOi2VED+Xs96RqoKvGI46q2QRv97g=;
        b=EDSkNs8avixNrOBqmJX2jW6gUTbKDTb1ZIeInqWk9wvGFcgxKW/0a/Dbj1vSc5YCOD
         O9Nrl4X0oh2qIzMhPLohB0y4+F2+Dtz/K2AqxaV3ZZ/qqM7SoHMN6QOMsgLRsiMTIyF1
         nSFCSnUVnFzQ778fPFTBG98gunMoM0ilEnelA07Ly3xMOsHdM7tL3GvatpxbH1/yLVZq
         Vzq1NsRq7ueatrHsfBPp9smXlJs3vwhB1P07Fbluj61YuNggab2V/diSZuZ6he4QQx+V
         vLgEYxENY1vFMhcGxu3eo5A8nJxiMXYP3qEvtcJPkwU78PJCihFZMWv1/XrhpAzXkTSq
         myJQ==
X-Forwarded-Encrypted: i=1; AJvYcCVNUVETryO1HYfYxzIORg6Ujpsn3DfcJxdwsXkwx7fDWNTmb2QB2CNpISDBkmR1PoVRL9e6Dm2fiQ==@kvack.org
X-Gm-Message-State: AOJu0YxeEYHDDC+GJLpHKPATRNwTLnp+vaLHP13HOHrGUaQDc48SXqHi
	LdzOTKj7pLG2Scg3htDx+UG52Fkdf/yeu42t1cpwIuvsdxOEsj85DCvV
X-Gm-Gg: ASbGncty56wmJcqXGlo1CTuhWIGPoa5Pkb34Bky+zQ4oMXoS5SZZ2J4R6t/9CGKo3Vk
	iqsxzbobmygsa4SZ4yTijkYU/rO+pf4vy8G/1uGl69oFPHQx1w01R9msGo/cVqHOWZr7yl/L31q
	wSxlol5BXhfeyU3QKPGtS/DpG4kRhqZnrxrDSlIu1N8aYkdMFWKqc2ziU4Pu+I2LukUF9efnQfb
	GTgNQbLmOomqZuTlmA3WJ+D0g5fVe1B6H9AJJ4MAjeqWnk3Pp3N4DebC+230FVPl89hqDnPQBFH
	UPp40+0EtPIG30Gd8IKYeSJ/e5mHes7jHVLUtW5saP74uGldN3Md3wY0o9DhPbqd5oy/KeJnNJQ
	4Zx1Q7Zf2PPG3LhkTFBO33nz/IlqZP+y9Zx6qfu39U6aVdA==
X-Google-Smtp-Source: AGHT+IHvRbS5E1bKUmmAsVXFtXvCxFUCGJDcz57wzHvVzZP529pa37fN3+oWV7CfzyuGeLcSuQ1SWw==
X-Received: by 2002:a17:90b:2ccd:b0:321:4760:c65a with SMTP id 98e67ed59e1d1-32517d1e054mr30179480a91.27.1756407660486;
        Thu, 28 Aug 2025 12:01:00 -0700 (PDT)
Received: from mitchelllevy.localdomain ([174.127.224.194])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-327da8e5ad5sm405729a91.18.2025.08.28.12.00.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Aug 2025 12:00:59 -0700 (PDT)
From: Mitchell Levy <levymitchell0@gmail.com>
Date: Thu, 28 Aug 2025 12:00:12 -0700
Subject: [PATCH v3 5/7] rust: percpu: Support non-zeroable types for
 DynamicPerCpu
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250828-rust-percpu-v3-5-4dd92e1e7904@gmail.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1756407651; l=11574;
 i=levymitchell0@gmail.com; s=20240719; h=from:subject:message-id;
 bh=+lEJbTpkz2WbxbYDrCnnJg9tQe8ptqmkgyWr5/FAI6E=;
 b=nsWk0v7Bp3XRYlydEETW2ckzGyCaiUq6V4hFLtHmax5ZpM1J/foqW9qb/F9rKhy4xVojaLz9Z
 dAT4xoykz0EDR+zf6iRz4X92+VJiYDuSyBok2JQb7X66hAaNuKTChT9
X-Developer-Key: i=levymitchell0@gmail.com; a=ed25519;
 pk=n6kBmUnb+UNmjVkTnDwrLwTJAEKUfs2e8E+MFPZI93E=
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: BF22D4001F
X-Stat-Signature: axoi8ah5jgaqgdinurnmjy775rfjtc1b
X-Rspam-User: 
X-HE-Tag: 1756407661-761111
X-HE-Meta: U2FsdGVkX1/Y+hdnz05Lack75rzqlLXn1MAhkuGY3hroQHnrgN9gxwRHyLu6aTVdZW8T6IeEQxSFBBqSZczJeJLNd/B1/5lQcp20QUMvLJiNR2gyr0PsEbksCYYp825wskw+el09sX7JdO66mcQkysNw5lLXklp1jeZVSxBNBICWgieh2g9jnmGaTwx9YePTj6Kbk3ykCYKL9G2Ycfj7JEt4GNMrq8lEPObh8pWWnw3pEh59uYAtZzyWh6XWxSqw+g5VJBXwl3GO0Ej5fwZwNK6iHPx6IRkIK0qT7QD0fnVjRASUgqMZUgkw9JhJl/Uur+witqd1eQ8y25ruzdxYgO02QgAD4s1x6y/2DxngKEp3PhoC+sIBfKQN3cFWmfTYrBE7JZMZeJyvA8cV2IHhalVD3ix9fZoqdgK3VRwxhYeRsGbeusnpHEn/VoLDTABhPVRQiBC7JIHerP/DfTQd22c+gzFBu4rWo9MDExhubdTAGTSARI0bftunIIZsx4+cMobbaMLfwuV369kERahiP7I0c6+ikmEK0VfVP2QWdMIqRFUQR9oYq3QSlHaDrpeCG+PyTb3X0u2cI3tgQDu0Ne5cku/VOxTbOmmtLWwmh5CT0kIPTKddZw+18tm2YMJgmF2oyHU7UqyUAo86AfUPI/6wa0pRVUpaYpiV76urN489MjnzKqTW53Xf7rhH+86m9sfgOUNS7AWGiV2KabjHAp/WE5ky9nO+vnE4CMOWGmyJm3qDezvX2Hf/u0cAaPjSDfbl5GS+QHb1kb9UanldFOpp4nq8AZjQJQORghx9G3icBpSigmoS9W4g49ris+wJmiYsGSOuQlHns+RT9UiNnN63p7iXkmYTqXNSzah+rasgNZr1UXHp/PJ9vTDajGVcL2QPgYv8Tka6s8euHquFkLv2BbWVD9rR0t+tbY1mB94R2/6yCnTWhfgL3cNdYkHhDJWZf6gOZSXmS53N1CM
 10eoKavc
 nwPiKoiHoEEC5mVEH71rkMT/bW1eoLHgK8gLO0ndo67uGSrEToexGR02WAb+QVDSUYCtXHw+nwQOGZfV4yJ1VlyPZBevwHx3R0Lsilq/QYPDRF/CKU/0HOiYCR1YaINt42ob8gEuvhYSVfhhS+BSJTQOO/shS1zSxo919+VrXIpmrPP0vZQPRcqNEh9WbMk6FXSt4YBLERD8I8KBG3f7YiGU/WzpqFNE2C7KyDSifDzpKnuS3x/bYVBcT24rWCaO11/r3bsim1b6H4uSMtpMCkg5GbVB76CpIlU92GofGDFLBoy4x0hgvV3Qphh8eRsfjDrb35Bf6Y3gkBsqA1Kxr3yTwusp0Lg9Wk/SAYqiEc2ZIQ7alWr6mfhjbrt6cp7WG80/TXHz9WlVgd3Gii2Hk4x27XA3keXnW6eflSiLTrz9UQm9avIkz5hjIS3NLcsQsK87IfvVCoapq6wc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add functionality to `PerCpuPtr` to compute pointers to per-CPU variable
slots on other CPUs. Use this facility to initialize per-CPU variables
on all possible CPUs when a dynamic per-CPU variable is created with a
non-zeroable type. Since `RefCell` and other `Cell`-like types fall into
this category, `impl CheckedPerCpu` on `DynamicPerCpu` for these
`InteriorMutable` types since they can now be used. Add examples of
these usages to `samples/rust/rust_percpu.rs`.

Signed-off-by: Mitchell Levy <levymitchell0@gmail.com>
---
 rust/helpers/percpu.c         |  5 +++
 rust/kernel/percpu.rs         | 15 +++++++
 rust/kernel/percpu/dynamic.rs | 40 +++++++++++++++++
 samples/rust/rust_percpu.rs   | 99 ++++++++++++++++++++++++++++++++++++++++---
 4 files changed, 152 insertions(+), 7 deletions(-)

diff --git a/rust/helpers/percpu.c b/rust/helpers/percpu.c
index 8cc01d094752..8d83b6b86106 100644
--- a/rust/helpers/percpu.c
+++ b/rust/helpers/percpu.c
@@ -8,6 +8,11 @@ void __percpu *rust_helper_alloc_percpu(size_t sz, size_t align)
 	return __alloc_percpu(sz, align);
 }
 
+void *rust_helper_per_cpu_ptr(void __percpu *ptr, unsigned int cpu)
+{
+	return per_cpu_ptr(ptr, cpu);
+}
+
 void rust_helper_on_each_cpu(smp_call_func_t func, void *info, int wait)
 {
 	on_each_cpu(func, info, wait);
diff --git a/rust/kernel/percpu.rs b/rust/kernel/percpu.rs
index 35afcdba3ccd..c68c7520b67f 100644
--- a/rust/kernel/percpu.rs
+++ b/rust/kernel/percpu.rs
@@ -14,6 +14,7 @@
 use bindings::{alloc_percpu, free_percpu};
 
 use crate::alloc::Flags;
+use crate::cpu::CpuId;
 use crate::percpu::cpu_guard::CpuGuard;
 use crate::prelude::*;
 use crate::sync::Arc;
@@ -115,6 +116,20 @@ pub fn get_ptr(&self) -> *mut MaybeUninit<T> {
         // the invariant that self.0 is a valid offset into the per-CPU area.
         (this_cpu_area).wrapping_add(self.0 as usize).cast()
     }
+
+    /// Get a `*mut MaybeUninit<T>` to the per-CPU variable on the CPU represented by `cpu`. Note
+    /// that without some kind of synchronization, use of the returned pointer may cause a data
+    /// race. It is the caller's responsibility to use the returned pointer in a reasonable way.
+    ///
+    /// # Safety
+    /// - The returned pointer is valid only if `self` is (that is, it points to a live allocation
+    ///   correctly sized and aligned to hold a `T`)
+    /// - The returned pointer is valid only if the bit corresponding to `cpu` is set in
+    ///   `Cpumask::possible()`.
+    pub unsafe fn get_remote_ptr(&self, cpu: CpuId) -> *mut MaybeUninit<T> {
+        // SAFETY: The requirements of this function ensure this call is safe.
+        unsafe { bindings::per_cpu_ptr(self.0.cast(), cpu.as_u32()) }.cast()
+    }
 }
 
 // SAFETY: Sending a `PerCpuPtr<T>` to another thread is safe because as soon as it's sent, the
diff --git a/rust/kernel/percpu/dynamic.rs b/rust/kernel/percpu/dynamic.rs
index ce95e420f943..64f04cef3705 100644
--- a/rust/kernel/percpu/dynamic.rs
+++ b/rust/kernel/percpu/dynamic.rs
@@ -3,6 +3,8 @@
 
 use super::*;
 
+use crate::cpumask::Cpumask;
+
 /// Represents a dynamic allocation of a per-CPU variable via alloc_percpu. Calls free_percpu when
 /// dropped.
 pub struct PerCpuAllocation<T>(PerCpuPtr<T>);
@@ -74,6 +76,36 @@ pub fn new_zero(flags: Flags) -> Option<Self> {
     }
 }
 
+impl<T: Clone> DynamicPerCpu<T> {
+    /// Allocates a new per-CPU variable
+    ///
+    /// # Arguments
+    /// * `val` - The initial value of the per-CPU variable on all CPUs.
+    /// * `flags` - Flags used to allocate an `Arc` that keeps track of the underlying
+    ///   `PerCpuAllocation`.
+    pub fn new_with(val: T, flags: Flags) -> Option<Self> {
+        let alloc: PerCpuAllocation<T> = PerCpuAllocation::new_uninit()?;
+        let ptr = alloc.0;
+
+        for cpu in Cpumask::possible().iter() {
+            // SAFETY: `ptr` is a valid allocation, and `cpu` appears in `Cpumask::possible()`
+            let remote_ptr = unsafe { ptr.get_remote_ptr(cpu) };
+            // SAFETY: Each CPU's slot corresponding to `ptr` is currently uninitialized, and no
+            // one else has a reference to it. Therefore, we can freely write to it without
+            // worrying about the need to drop what was there or whether we're racing with someone
+            // else. `PerCpuPtr::get_remote_ptr` guarantees that the pointer is valid since we
+            // derived it from a valid allocation and `cpu`.
+            unsafe {
+                (*remote_ptr).write(val.clone());
+            }
+        }
+
+        let arc = Arc::new(alloc, flags).ok()?;
+
+        Some(Self { alloc: arc })
+    }
+}
+
 impl<T> PerCpu<T> for DynamicPerCpu<T> {
     unsafe fn get_mut(&mut self, guard: CpuGuard) -> PerCpuToken<'_, T> {
         // SAFETY: The requirements of `PerCpu::get_mut` and this type's invariant ensure that the
@@ -81,3 +113,11 @@ unsafe fn get_mut(&mut self, guard: CpuGuard) -> PerCpuToken<'_, T> {
         unsafe { PerCpuToken::new(guard, &self.alloc.0) }
     }
 }
+
+impl<T: InteriorMutable> CheckedPerCpu<T> for DynamicPerCpu<T> {
+    fn get(&mut self, guard: CpuGuard) -> CheckedPerCpuToken<'_, T> {
+        // SAFETY: By the invariant of `DynamicPerCpu`, the memory location in each CPU's
+        // per-CPU area corresponding to this variable has been initialized.
+        unsafe { CheckedPerCpuToken::new(guard, &self.alloc.0) }
+    }
+}
diff --git a/samples/rust/rust_percpu.rs b/samples/rust/rust_percpu.rs
index 98ca1c781b6b..06b322019134 100644
--- a/samples/rust/rust_percpu.rs
+++ b/samples/rust/rust_percpu.rs
@@ -130,13 +130,72 @@ fn init(_module: &'static ThisModule) -> Result<Self, Error> {
 
         // SAFETY: No prerequisites for on_each_cpu.
         unsafe {
-            on_each_cpu(Some(inc_percpu), (&raw mut test).cast(), 0);
-            on_each_cpu(Some(inc_percpu), (&raw mut test).cast(), 0);
-            on_each_cpu(Some(inc_percpu), (&raw mut test).cast(), 0);
-            on_each_cpu(Some(inc_percpu), (&raw mut test).cast(), 1);
-            on_each_cpu(Some(check_percpu), (&raw mut test).cast(), 1);
+            on_each_cpu(Some(inc_percpu_u64), (&raw mut test).cast(), 0);
+            on_each_cpu(Some(inc_percpu_u64), (&raw mut test).cast(), 0);
+            on_each_cpu(Some(inc_percpu_u64), (&raw mut test).cast(), 0);
+            on_each_cpu(Some(inc_percpu_u64), (&raw mut test).cast(), 1);
+            on_each_cpu(Some(check_percpu_u64), (&raw mut test).cast(), 1);
         }
 
+        let mut checked: DynamicPerCpu<RefCell<u64>> =
+            DynamicPerCpu::new_with(RefCell::new(100), GFP_KERNEL).unwrap();
+
+        // SAFETY: No prerequisites for on_each_cpu.
+        unsafe {
+            on_each_cpu(Some(inc_percpu_refcell_u64), (&raw mut checked).cast(), 0);
+            on_each_cpu(Some(inc_percpu_refcell_u64), (&raw mut checked).cast(), 0);
+            on_each_cpu(Some(inc_percpu_refcell_u64), (&raw mut checked).cast(), 0);
+            on_each_cpu(Some(inc_percpu_refcell_u64), (&raw mut checked).cast(), 1);
+            on_each_cpu(Some(check_percpu_refcell_u64), (&raw mut checked).cast(), 1);
+        }
+
+        checked.get(CpuGuard::new()).with(|val: &RefCell<u64>| {
+            assert!(*val.borrow() == 104);
+
+            let mut checked_native = 0;
+            *val.borrow_mut() = 0;
+
+            checked_native += 1;
+            *val.borrow_mut() += 1;
+            pr_info!(
+                "Checked native: {}, *checked: {}\n",
+                checked_native,
+                val.borrow()
+            );
+            assert!(checked_native == *val.borrow() && checked_native == 1);
+
+            checked_native = checked_native.wrapping_add((-1i64) as u64);
+            val.replace_with(|old: &mut u64| old.wrapping_add((-1i64) as u64));
+            pr_info!(
+                "Checked native: {}, *checked: {}\n",
+                checked_native,
+                val.borrow()
+            );
+            assert!(checked_native == *val.borrow() && checked_native == 0);
+
+            checked_native = checked_native.wrapping_add((-1i64) as u64);
+            val.replace_with(|old: &mut u64| old.wrapping_add((-1i64) as u64));
+            pr_info!(
+                "Checked native: {}, *checked: {}\n",
+                checked_native,
+                val.borrow()
+            );
+            assert!(checked_native == *val.borrow() && checked_native == (-1i64) as u64);
+
+            checked_native = 0;
+            *val.borrow_mut() = 0;
+
+            checked_native = checked_native.wrapping_sub(1);
+            val.replace_with(|old: &mut u64| old.wrapping_sub(1));
+            pr_info!(
+                "Checked native: {}, *checked: {}\n",
+                checked_native,
+                val.borrow()
+            );
+            assert!(checked_native == *val.borrow() && checked_native == (-1i64) as u64);
+            assert!(checked_native == *val.borrow() && checked_native == u64::MAX);
+        });
+
         pr_info!("rust dynamic percpu test done\n");
 
         // Return Err to unload the module
@@ -144,7 +203,7 @@ fn init(_module: &'static ThisModule) -> Result<Self, Error> {
     }
 }
 
-extern "C" fn inc_percpu(info: *mut c_void) {
+extern "C" fn inc_percpu_u64(info: *mut c_void) {
     // SAFETY: We know that info is a void *const DynamicPerCpu<u64> and DynamicPerCpu<u64> is Send.
     let mut pcpu = unsafe { (*(info as *const DynamicPerCpu<u64>)).clone() };
     pr_info!("Incrementing on {}\n", CpuId::current().as_u32());
@@ -153,7 +212,7 @@ extern "C" fn inc_percpu(info: *mut c_void) {
     unsafe { pcpu.get_mut(CpuGuard::new()) }.with(|val: &mut u64| *val += 1);
 }
 
-extern "C" fn check_percpu(info: *mut c_void) {
+extern "C" fn check_percpu_u64(info: *mut c_void) {
     // SAFETY: We know that info is a void *const DynamicPerCpu<u64> and DynamicPerCpu<u64> is Send.
     let mut pcpu = unsafe { (*(info as *const DynamicPerCpu<u64>)).clone() };
     pr_info!("Asserting on {}\n", CpuId::current().as_u32());
@@ -161,3 +220,29 @@ extern "C" fn check_percpu(info: *mut c_void) {
     // SAFETY: We don't have multiple clones of pcpu in scope
     unsafe { pcpu.get_mut(CpuGuard::new()) }.with(|val: &mut u64| assert!(*val == 4));
 }
+
+extern "C" fn inc_percpu_refcell_u64(info: *mut c_void) {
+    // SAFETY: We know that info is a void *const DynamicPerCpu<RefCell<u64>> and
+    // DynamicPerCpu<RefCell<u64>> is Send.
+    let mut pcpu = unsafe { (*(info as *const DynamicPerCpu<RefCell<u64>>)).clone() };
+    // SAFETY: smp_processor_id has no preconditions
+    pr_info!("Incrementing on {}\n", CpuId::current().as_u32());
+
+    pcpu.get(CpuGuard::new()).with(|val: &RefCell<u64>| {
+        let mut val = val.borrow_mut();
+        *val += 1;
+    });
+}
+
+extern "C" fn check_percpu_refcell_u64(info: *mut c_void) {
+    // SAFETY: We know that info is a void *const DynamicPerCpu<RefCell<u64>> and
+    // DynamicPerCpu<RefCell<u64>> is Send.
+    let mut pcpu = unsafe { (*(info as *const DynamicPerCpu<RefCell<u64>>)).clone() };
+    // SAFETY: smp_processor_id has no preconditions
+    pr_info!("Asserting on {}\n", CpuId::current().as_u32());
+
+    pcpu.get(CpuGuard::new()).with(|val: &RefCell<u64>| {
+        let val = val.borrow();
+        assert!(*val == 104);
+    });
+}

-- 
2.34.1


