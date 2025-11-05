Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5AF7BCCFA0D
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 23:02:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E10E18E000A; Wed,  5 Nov 2025 18:02:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D9B1B8E000E; Wed,  5 Nov 2025 18:02:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C227B8E000A; Wed,  5 Nov 2025 18:02:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A65DD8E000A
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 18:02:38 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 640B312C49A
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 23:02:38 +0000 (UTC)
X-FDA: 84078079596.28.9FF9E64
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	by imf26.hostedemail.com (Postfix) with ESMTP id 556EF140015
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 23:02:36 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="NhcVya/l";
	spf=pass (imf26.hostedemail.com: domain of levymitchell0@gmail.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=levymitchell0@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762383756;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JlEVe7ZQ+3aZbaXo/QWkECKjdoOcpAx/m3mobBviog0=;
	b=bPjIMIqxPZ+ANt2TI9otkrDKXa//jMInWWjXsceB1MH7sKydjIsh/99JMERGIw6LBmNN8B
	/hlUWGky506IO62s6lMhJM3blOMOlLX/TZmv3KVJZIQNg4HRU0HRGqUEAYV+F2sBFhATYA
	W62MS1trRoAC8JasUWutUpRH/cxSBt8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762383756; a=rsa-sha256;
	cv=none;
	b=z+iQRgdIE/S0jYXUOlF0O7VAqqOzGEX6cYqCj4soBMErMGEcGzZd6TdNq3XxUxjhADCTz4
	mcgZ6VCAbIatHgszTFdbfKOfCcad82yiF+s2+jmScXftc0TrY1a0b4K5JTg4RyjRpVzElk
	nTHgZZYfdvJ09hSQBIA/QYQSA563vNs=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="NhcVya/l";
	spf=pass (imf26.hostedemail.com: domain of levymitchell0@gmail.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=levymitchell0@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-295ceaf8dacso3674645ad.0
        for <linux-mm@kvack.org>; Wed, 05 Nov 2025 15:02:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762383755; x=1762988555; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JlEVe7ZQ+3aZbaXo/QWkECKjdoOcpAx/m3mobBviog0=;
        b=NhcVya/lLkHH+phVo/INgr7V4TIpdwo5Pj8O/lT/RRdfIwDy94AXtOyiaXpzkV4W06
         IhsVLgpfNNBH9HaT4VZdoQux4zLXolxHXJp+1xkWVF499W/QeCh1zjIQwH6fy5XOPrDh
         +9+xbW8wuftbYUtfERPJAmPA7f4sadbfSmh47T3G6BEgstkp2L1wsZqUOmSh0ibKUBDU
         eT5ohLqcRPN8faBKNkkVzUzrKPilCCAnGXOAC2f9XEG3gMalSPCBYe2U93PhFGAjUzeT
         3UeR5m9YHIEYb6lP6cSv+U7oYd/WDEbkDE+hymj4ZPSNhEa6W7gziIjpXP1n+Fibx21b
         wpkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762383755; x=1762988555;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JlEVe7ZQ+3aZbaXo/QWkECKjdoOcpAx/m3mobBviog0=;
        b=t0gbyTt/0w5V9KFHBokraFrBt3KHPTevLCMibBYZfLpV8EYex4l9Ckl9qTlTFbqrLT
         HXypb8PG3kwoLPV5BYV3gXaCYtTGJlkE5IzBH9rvfhbpDl8OWz+38ufuPr+2MK3PykB6
         YI+QRTJjJGc9fm735oSBZT3S+vpKzLiub1pDplFgXQGxAtRiVcrsAMx8Mr21dgIUOTUx
         vbVX5uD3RCGqe9JeFEgZP1zDePjpDTuiA/e58fXKugmOR/uyrcWt3hMJfN/KD/+TkWwj
         0KwbGexVWun7elnWthnB0N5uFQEzJUGzdr21sYPUGSTLZOclxONskK6zPeZtnWC6dbmn
         FlFw==
X-Forwarded-Encrypted: i=1; AJvYcCU3IOOfBr4D4wP26wr3KLRLKTPJIw6l1YQAIlkskJu9xwRmXkGt2Wal3cNCkbxUverOgAZNd8LKqg==@kvack.org
X-Gm-Message-State: AOJu0Yw4PZNqOSVtlf93hLSql0ORMRmO9gBliclXbwiX6LIyVcp3hpr4
	e4xg6o+xUk4IoLHC8PIO5bf2WErCjxiQk7ZUGP3i/g7lWp87AhrQPCnv
X-Gm-Gg: ASbGncuC6HXT27LiKW2rHK8NySBU7J3s7xAtd/SkHt/RAD8VUUjSmRk5UTqzrNN7gy7
	PcPO6FcSTqcUUF2iwlWUuxJBoRKZFN5FIO+PEXbvc6LrAlV40a7iWKDIVQZPEPmxi3ZVgCwI/ki
	oX7hCGoTAK2+xZD+L4dzKHftsul4/PBqWGJhyoUerj++Xi9pQzOnMSrSM0MPw2nO0+c3tq5hR1G
	rJbF151xvvyvz4Gpp7wtEIDiKx/8WuWcZYfGUj1+AjCNvLmI+aE/enc9mli6oaRfzpljmhhPCgR
	U9B3PMrbvrv8HDaocjef/jkF9V2BLrIk7nqauk6cEZVwQtzuE12obyHq9b3L0LNl822EYSkcyMK
	7g+XC/GgDVW/P8YWios6RKrHUL0BgQpfckX5ZqepbFgrukG7+5/3aaBcrZckM9Z1oMLw2MPWfg4
	YQeksLTddg1MU/z7YQzVuB/YYg/XKca4iGGw==
X-Google-Smtp-Source: AGHT+IGL90UCdSoq8ldn75N4+7GWkkl8BPXpNVrFKQinz3VwFnZfYaDmILgoDXuV49BzxLMOOrniRg==
X-Received: by 2002:a17:902:e751:b0:295:1277:7926 with SMTP id d9443c01a7336-2962ad2b031mr67951235ad.23.1762383754797;
        Wed, 05 Nov 2025 15:02:34 -0800 (PST)
Received: from mitchelllevy.localdomain ([131.107.147.147])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2965096839asm6325645ad.13.2025.11.05.15.02.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Nov 2025 15:02:34 -0800 (PST)
From: Mitchell Levy <levymitchell0@gmail.com>
Date: Wed, 05 Nov 2025 15:01:19 -0800
Subject: [PATCH v4 7/9] rust: percpu: Support non-zeroable types for
 DynamicPerCpu
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251105-rust-percpu-v4-7-984b1470adcb@gmail.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1762383744; l=10112;
 i=levymitchell0@gmail.com; s=20240719; h=from:subject:message-id;
 bh=BqnHuY+j+zWWmGsgTf4cjhQ+rYxxpT17fToJwK3G2cU=;
 b=kTPf2rF1bKOOsD6lCvyiNpGrvnXPjibUxkDPtlxWNqeA6HklvELVCnpq28MLWOYvQwBQQswYj
 r6Ije0nlQwZCQZtslxG/M/AMyLX3SwifpWpGi+UEShOEycvwWb6obHp
X-Developer-Key: i=levymitchell0@gmail.com; a=ed25519;
 pk=n6kBmUnb+UNmjVkTnDwrLwTJAEKUfs2e8E+MFPZI93E=
X-Stat-Signature: 8h5zhkbkgi3zb111di9q9u9n39pnymgo
X-Rspam-User: 
X-Rspamd-Queue-Id: 556EF140015
X-Rspamd-Server: rspam01
X-HE-Tag: 1762383756-917903
X-HE-Meta: U2FsdGVkX190gXOgt2TviwUCeZRMVYjv8RROJqgM+3L9f8od4SdL2UvjSrFG63R29QStdPQL82ElKRGJReFgEioS5fh+2jsbk0L4Tt1nSAS3/shabWR3J6y30lT3AtFgb5cdsqnMDSqUfkFyn+XkHyUgb+gYu+4g2XxOfQR2VosNBeEFCp3BCyfNtVj2NWjzAUCduk3Uy3L0r0YM/2rlBOoAhdXLk6r3UUsseucGwFqFZxnnZZ3AyK8fnr//gdCINaBEt8cTs1ZjVFEwXigoSfhcor7T+mj72IVnEFUZFZCzuuNIBKqa18lYmM7YhJhDiurXu9V7cJhK6HbvlTSNmYmFLK7mx1EwANlYKwmt+9Rg+3pfgClOOrsiNAyLVRaOX50KDO1iRz6oWwGSQMGSnPiQXtwC/3XuDAeFU4Mx77gteWlcCkpoMgT9H2K+xBu1hALEVTnBzDRD9oUTIWIIv3R9V+WKR/a6TKNLMG6UlvIAAHsNyPINx1rYuU3hss/G6soGIQfALCUan16EnKqFekGQAmexeq3fDKzrJmURHStEQ0ZUSx+BTrj4bTQKk8ecrLG2mStMb1atMj1Bc4T/tUeNGBIvX6M+GJrEkH9qkCXUlKs5dpxOd6d52yBKiCt7yF/385ZUdTyxRhYcJ3bMrok7cPG8PZPneYzHzCT4E8thz4nb77jQybK3euwO1PAvgktNLg5f6WuaGQSDP0XYAesyDH6lwr11+lIiG/dWJs/542evnBHj7rcQPOywdCWEhfhGVzeDpA9cStOJncMlrUTEo5SXEdH/XyMmkV2vgDrSCAxqjL8bhflEsHwTTgqkOSeXkbQKw+ugjWSAJMsEKyr4vOzIxKlFhZ8EH5s4wMuZAasuMbP/+cyIhCjkYnuN0hrIqUqeppBqr2mzw75JAhae+rTL7PzBg+1DzVC1Q8KDGieGC8h7Eye7rLFcNwGxM3qDOgTjJ9ifrHk7TSy
 wG4P8rCW
 vVzDwterTFp0GgL6C5DAeMYRBb6SPnedN0uX5hbvJJkzDxgucqwRbnK7Yj4bzDonlk0PWHxl+TYZPnhJSJp9mp26Djtlv8NtlXaq29MLSiib4jGEZvE3az7VIxwlFnbBdAtvHkKAa/AfPthI8drGO4wLl9cyOAPLejsXWURCBPbGJnibN7vr/Q0zOLiZ5NP2zZ6uiOtgtlBA0sDT7WANfd/HukaYzChUfeErTopl36eaisK3f5T8EWji09UYAQjXNosWG3MQgyuAnjrFfzHg9fkVh1pYBmDRrmzouwdrEezv8fbS3wfnBeKt1LtUyrV9xPmlzSHJFm0VZoubWK+TCig0BnUURHar7Yh1mMyBnKXUVWVJaP0GrnMoExJqA304yHknU9x87/alBbXZgC74ML0Ddh2/TO7eSHD2K8cnMYpJtr7fYYF/iltGSAPece8M7hjlYFnQcSLyeQLTKwXrMPsQmB+hFwFExYp62dsEilF2H6P50EejvXP+c0Q==
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
these usages to `samples/rust/rust_percpu.rs`. Add a test to ensure
dynamic per-CPU variables properly drop their contents, done here since
non-trivially dropped types often aren't `Zeroable`.

Signed-off-by: Mitchell Levy <levymitchell0@gmail.com>
---
 rust/kernel/percpu/dynamic.rs |  44 +++++++++++++++++
 samples/rust/rust_percpu.rs   | 109 +++++++++++++++++++++++++++++++++++++++---
 2 files changed, 146 insertions(+), 7 deletions(-)

diff --git a/rust/kernel/percpu/dynamic.rs b/rust/kernel/percpu/dynamic.rs
index 1863f31a2817..a74c8841aeb2 100644
--- a/rust/kernel/percpu/dynamic.rs
+++ b/rust/kernel/percpu/dynamic.rs
@@ -89,6 +89,36 @@ pub fn new_zero(flags: Flags) -> Option<Self> {
     }
 }
 
+impl<T: Clone> DynamicPerCpu<T> {
+    /// Allocates a new per-CPU variable
+    ///
+    /// # Arguments
+    /// * `val` - The initial value of the per-CPU variable on all CPUs.
+    /// * `flags` - Flags used to allocate an [`Arc`] that keeps track of the underlying
+    ///   [`PerCpuAllocation`].
+    pub fn new_with(val: &T, flags: Flags) -> Option<Self> {
+        let alloc: PerCpuAllocation<T> = PerCpuAllocation::new_uninit()?;
+        let ptr = alloc.0;
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
+                (*remote_ptr).write(val.clone());
+            }
+        }
+
+        let arc = Arc::new(alloc, flags).ok()?;
+
+        Some(Self { alloc: Some(arc) })
+    }
+}
+
 impl<T> PerCpu<T> for DynamicPerCpu<T> {
     unsafe fn get_mut(&mut self, guard: CpuGuard) -> PerCpuToken<'_, T> {
         // SAFETY:
@@ -105,6 +135,20 @@ unsafe fn get_mut(&mut self, guard: CpuGuard) -> PerCpuToken<'_, T> {
     }
 }
 
+impl<T: InteriorMutable> CheckedPerCpu<T> for DynamicPerCpu<T> {
+    fn get(&mut self, guard: CpuGuard) -> CheckedPerCpuToken<'_, T> {
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
 impl<T> Drop for DynamicPerCpu<T> {
     fn drop(&mut self) {
         // SAFETY: This type's invariant ensures that `self.alloc` is `Some`.
diff --git a/samples/rust/rust_percpu.rs b/samples/rust/rust_percpu.rs
index 98ca1c781b6b..be70ee2e513f 100644
--- a/samples/rust/rust_percpu.rs
+++ b/samples/rust/rust_percpu.rs
@@ -11,6 +11,7 @@
     percpu::{cpu_guard::*, *},
     pr_info,
     prelude::*,
+    sync::Arc,
 };
 
 module! {
@@ -130,13 +131,81 @@ fn init(_module: &'static ThisModule) -> Result<Self, Error> {
 
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
+            DynamicPerCpu::new_with(&RefCell::new(100), GFP_KERNEL).unwrap();
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
+        let arc = Arc::new(0, GFP_KERNEL).unwrap();
+        {
+            let _arc_pcpu: DynamicPerCpu<Arc<u64>> =
+                DynamicPerCpu::new_with(&arc, GFP_KERNEL).unwrap();
+        }
+        // `arc` should be unique, since all the clones on each CPU should be dropped when
+        // `_arc_pcpu` is dropped
+        assert!(arc.into_unique_or_drop().is_some());
+
         pr_info!("rust dynamic percpu test done\n");
 
         // Return Err to unload the module
@@ -144,7 +213,7 @@ fn init(_module: &'static ThisModule) -> Result<Self, Error> {
     }
 }
 
-extern "C" fn inc_percpu(info: *mut c_void) {
+extern "C" fn inc_percpu_u64(info: *mut c_void) {
     // SAFETY: We know that info is a void *const DynamicPerCpu<u64> and DynamicPerCpu<u64> is Send.
     let mut pcpu = unsafe { (*(info as *const DynamicPerCpu<u64>)).clone() };
     pr_info!("Incrementing on {}\n", CpuId::current().as_u32());
@@ -153,7 +222,7 @@ extern "C" fn inc_percpu(info: *mut c_void) {
     unsafe { pcpu.get_mut(CpuGuard::new()) }.with(|val: &mut u64| *val += 1);
 }
 
-extern "C" fn check_percpu(info: *mut c_void) {
+extern "C" fn check_percpu_u64(info: *mut c_void) {
     // SAFETY: We know that info is a void *const DynamicPerCpu<u64> and DynamicPerCpu<u64> is Send.
     let mut pcpu = unsafe { (*(info as *const DynamicPerCpu<u64>)).clone() };
     pr_info!("Asserting on {}\n", CpuId::current().as_u32());
@@ -161,3 +230,29 @@ extern "C" fn check_percpu(info: *mut c_void) {
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


