Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C2E3CCF9F8
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 23:02:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BEE498E000D; Wed,  5 Nov 2025 18:02:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B9FC68E000A; Wed,  5 Nov 2025 18:02:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A66398E000D; Wed,  5 Nov 2025 18:02:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 928738E000A
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 18:02:37 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3F5494B3F8
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 23:02:37 +0000 (UTC)
X-FDA: 84078079554.17.735BBA8
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	by imf10.hostedemail.com (Postfix) with ESMTP id 27A30C000B
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 23:02:34 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Q06X9fpn;
	spf=pass (imf10.hostedemail.com: domain of levymitchell0@gmail.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=levymitchell0@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762383755;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=haGIr4TbAT28iZId1iIOWFqS56QerIllmXw1VE5QblA=;
	b=ax8M7g2goUwXueWwQrkIO08M3/GUjiZc4HiIXRn9TGqcp7EYcDF/miak/YzoPXTHnpNq4k
	hS4A36uhsKM40ntezwEA2BnYkjBSUADexbmQJaYoqKMozkZelzHeTMasYPSNchYATxtBEe
	rcQijsTiBF1nPdqeCLX2qDWkjyZEv8o=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762383755; a=rsa-sha256;
	cv=none;
	b=PqgN+xa5EwN3bUShndSucuMDzFgz0BeUFGXIDo8USrD3n1gkklwkxiSb/KYVRlVALPJh1J
	ZbXkmGqIU3Sr0k+lFFHXDW70oCoFp2MaElN9sa4kGnleY0keZwjBTJfWb9ZwEsbW/DpRLs
	dQS8B2S/5VAd3sgaR9gERCCZe9m2XJA=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Q06X9fpn;
	spf=pass (imf10.hostedemail.com: domain of levymitchell0@gmail.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=levymitchell0@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-29555b384acso3355805ad.1
        for <linux-mm@kvack.org>; Wed, 05 Nov 2025 15:02:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762383754; x=1762988554; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=haGIr4TbAT28iZId1iIOWFqS56QerIllmXw1VE5QblA=;
        b=Q06X9fpnV5pMZUAe2P6zIzJeNlghAq4or1Bpld8NfOHHxeq4d70cIoDYKujitb6Pmc
         1pIxYRC9/6sdbhBljbuAlDDBxmX/aal0qIe+Q8xfvNDBT9H1oVmBEgL5mqku+Saj5NiU
         TEWDTT5A+4FauB8F/sYnSeTWetJ4BVREFp9y2NWtviQJUwLw5mRanMODgwD1cgV38zgc
         RPjbk3GrEzCntWz+05NUs4Y5KYG1tqnetOcqTlpdLuvOKBvYgEhtqZnAwiV7VcycSxa+
         gxJXLThs1vRtrmZDzF8HRadMMFlAEp74VgG+kkDcOP6reL2nRIjbQmrDXZ2Bk1eZYtxu
         P0Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762383754; x=1762988554;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=haGIr4TbAT28iZId1iIOWFqS56QerIllmXw1VE5QblA=;
        b=cj9Fnk70qhW0p9cDUsc4RuitrpB2DM96kzFilx2JjY29Fy5OC7LWoiuWBuDVMmVY7k
         E/to7jnNiAczaz9c/2vKUnkPn8JLDLbFLXq8XkPwMXa2XS4STidW8sPEUfYCAVDK7618
         T3cCpKQ0119zYOvxu9vhiwtdyxaeVlIo3LDLzH4EwmJOAddiQnFO2nVWzcfGEs3BcBVZ
         obenOf7e0fcuZR3VJekBrTPGAwXejVcpCOUxBDiEiOXjvi+p8ZcKLqaqJAuSFI4sdznJ
         qb3I9aijfAUGjD/Uxsha9yUMFZpKia1oICwyJ2TsFFX1+BX+GIgp8/aHoNBzUQMrql2f
         1B7w==
X-Forwarded-Encrypted: i=1; AJvYcCVPY22132D3xutE8QVwO/348LnK4dqawpMhwXob/FT9TcKuokZHA8I0hPTWprti17SATuMYgQrmGg==@kvack.org
X-Gm-Message-State: AOJu0YzmXd6ubj3/VnvkhBnYKK6Pr+Q0UV4HUtjpDc3wVG/1Au0LCxW6
	hl967kAVd9tDaD/N38FaFK7lVbtqT4SKTo2CvDtNkI1e2+4za5gSXWKoOSzW/qmj
X-Gm-Gg: ASbGncvsuqkevT3Z4nmbnHS/0TP2wjl0y4nYzzHK5xucDxeeQQebgki1zSrceWe4LJ0
	GVimaEO6srMmetET2X0SPrsEUn1gLUsNGRJFTu66i5sb2+OMbLLBIsLQPE2Qihm32KrD8bh88ND
	H3+eBttC8OpZB+rvrRRBBZiUFnUlFH4dd53MG0rkkh3vGrJE6ObFNZnjfLqEUuCJbaIxi1qHKwP
	BzqZo8fuq8YwxipIgfa0wfsl2WAZVUF0zyABmvxCYYrul0q/7nsyKnRrX5YnNzVMgZ2sPvib7ul
	9NsSXS3NrwIYeAMeV72804NiVTp1b9fLXz7cX6Mj6CNUfxQ32fIabbMaY1we1M1aE2P4YIMWG/N
	smrGEI4Kzbopuzi88NW55KLlIgSrtXpeTiSIPJsIa3pQ0XzHvb1HE/xV6JyCmtWYd0y7QLyUzF/
	A5XA/RsGjAxwYaAhgtHoFjF4E=
X-Google-Smtp-Source: AGHT+IFzjVuv6+fLc44rVR+754fMYDUlRbQZwzak3bXpRrpiq+jgHmjdZ9t766A4/ZV9UsiO7XyL/w==
X-Received: by 2002:a17:902:f647:b0:295:ceaf:8d76 with SMTP id d9443c01a7336-2962add07f1mr64418025ad.47.1762383753899;
        Wed, 05 Nov 2025 15:02:33 -0800 (PST)
Received: from mitchelllevy.localdomain ([131.107.147.147])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2965096839asm6325645ad.13.2025.11.05.15.02.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Nov 2025 15:02:32 -0800 (PST)
From: Mitchell Levy <levymitchell0@gmail.com>
Date: Wed, 05 Nov 2025 15:01:18 -0800
Subject: [PATCH v4 6/9] rust: percpu: add a rust per-CPU variable sample
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251105-rust-percpu-v4-6-984b1470adcb@gmail.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1762383744; l=8909;
 i=levymitchell0@gmail.com; s=20240719; h=from:subject:message-id;
 bh=ZGvpIhEgvWXGktZnhxfrMhN6hR7bkbAJOIhXp5Aq0Rs=;
 b=ozCkxX8AZS18Od5RqpDdJAKT5PuC+PMadw19K3gHEt4Arzb8pfY48uoQC0iTTZKu5yH9GvgEW
 af2cVxSKoMTDgAGQOQCroH9OOVN/z/g6/S42VKg++yjX4kPceoA4rk9
X-Developer-Key: i=levymitchell0@gmail.com; a=ed25519;
 pk=n6kBmUnb+UNmjVkTnDwrLwTJAEKUfs2e8E+MFPZI93E=
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 27A30C000B
X-Stat-Signature: 1g63fdz7qbk7sbg9kf8b9gf93yd3iwpg
X-Rspam-User: 
X-HE-Tag: 1762383754-14874
X-HE-Meta: U2FsdGVkX1/fj+C2GSjziB4YsGXCuryxUF787MT9OuM/VhSwwjBKEmFDrktZHlZsbIHqZV+6UzHZKL4/jJgULszi7ZYDplHIVDrXUtNhnnJqzQpgKh1X1vAv6qqhWqCZISm2uFRzIYAmnRCBM/nNbcgGbxCQeUjI+nAj6Vq4EwDcc1indIvWzddGoz11bjrBJokjH5R+Uhn6EaUCpEXoMPr8nl1emx7uB3xcR/eaLHpm1hBe0AGJMTrr8pgt8Hu6QU9hmy/dO5nlczjvFV7bVkz4/2jSsuf/618XC6X58ayPBzUtr8KWZCPJQsUOVXXvHs2YuXW9md8sAzhOiOQ8Jv5tMvr34gy4hIJgNyYOxthXXhmonGmK/Hb16nbqoRNcoIfdUSLFHRtl+c86/KCxWiZRxijLAqovOIrKBOYa/9yzWuRQyqEW/uhpMXItZ68Z4Kj5k0LMKYjpAyXdgGIIslO6AAOiMLxi8oRNoYukSTCEvRUVI5NpSr52SbOEy5n4gHOpz98HtrlTZIgNa3o75sbqYPsO1Cq1LZqUp8KeK0gvN1wT8WdRSFn8hb8dcvweu+6xJpH9rpBS2x3lbPaC36AY+tGcrkKi+nRfCtiP2YXvVrYL4mj6FdgQ1zBEMdqVQc+03ajyHS6OxIf40qKrXXzAMDmJFkmZIw1CGxv94BWqjBlNbeZ/ucymTUkMubfHrTho1WCKy9PjsogBWXsG/lmEisPKCkOsBB1xJ0gOKHulPMu+88mIc+OatqUa6QhuQe7web+Ufixbwmor2Fuq85V1Na9hnZld/ekvdTqK6cT5y9cSEsTDOMf2vgwRQdphBx4zqKsYtUembWge1F7bYpc3w52wdhgs3Tf4bJC4uAQCLJshPyvJ9pFSc275M9n7XkFkMQQ+2ktYEJ8JaMrGuLmN2BC8uoaPd3EOHMgPufNsiRb2DippDTsiIwT1TkPMzhpBpegKsi1nVPTsg1O
 C5yPL/Zu
 LxMtgaERId7fE5QqbV23lyRP030yNYF5QUWWQOz3UsfDcdrE1Ey5eQ6BA6QEBL3iPJt9zzuWhmuJuvs4WIA8fUdr9+0+VNeNHHlnKcXqg+DJjBVTpYS2AnBuqG+YkYaRhsTErwsJVqYbFKu4oIAi5XVVeeA//lhiECZ8IRyiu7nOhNwCRZn1XxFpH21H+70AdU7dOgCBME8ZuKLhO5A/1tZaMTflqBRfBZmPiIj8BTQ4SXTo7ZNuQ58A1orGr+WITCkMetStvAWSuy91XwLn7F8ntv3eN39cwX/+/kcstviNqvlfIE0KvptyqgS+HVKLZSuSVogmAqPv2BH4WNHS0J/PfWIZAEkYTJD0vdIk5i6ZoT4YE4ijRmA1NQ5+P8Pm700Bdqi/z1TlSvHfxwORTsVegNDM6qLl2++Q7Z5clMDwpetr5TexwS/H3zlFuSyKJmW+3CYz/yhH8tQ58Oc0TxnJbQW3/oVIv9DiczK2ylmyr/MbXII05xV/zkg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a short exercise for Rust's per-CPU variable API, modelled after
lib/percpu_test.c

Signed-off-by: Mitchell Levy <levymitchell0@gmail.com>
---
 rust/helpers/percpu.c       |   1 +
 rust/kernel/percpu.rs       |   2 +-
 samples/rust/Kconfig        |   9 +++
 samples/rust/Makefile       |   1 +
 samples/rust/rust_percpu.rs | 163 ++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 175 insertions(+), 1 deletion(-)

diff --git a/rust/helpers/percpu.c b/rust/helpers/percpu.c
index 35656333dfae..8d83b6b86106 100644
--- a/rust/helpers/percpu.c
+++ b/rust/helpers/percpu.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 
 #include <linux/percpu.h>
+#include <linux/smp.h>
 
 void __percpu *rust_helper_alloc_percpu(size_t sz, size_t align)
 {
diff --git a/rust/kernel/percpu.rs b/rust/kernel/percpu.rs
index 294b8ffc4f62..2db670c87fae 100644
--- a/rust/kernel/percpu.rs
+++ b/rust/kernel/percpu.rs
@@ -2,7 +2,7 @@
 //! Per-CPU variables.
 //!
 //! See the [`crate::define_per_cpu!`] macro, the [`DynamicPerCpu`] type, and the [`PerCpu<T>`]
-//! trait.
+//! trait. Example usage can be found in `samples/rust/rust_percpu.rs`.
 
 pub mod cpu_guard;
 mod dynamic;
diff --git a/samples/rust/Kconfig b/samples/rust/Kconfig
index 7f7371a004ee..23e35d64ac78 100644
--- a/samples/rust/Kconfig
+++ b/samples/rust/Kconfig
@@ -105,6 +105,15 @@ config SAMPLE_RUST_DRIVER_AUXILIARY
 
 	  If unsure, say N.
 
+config SAMPLE_RUST_PERCPU
+	tristate "Per-CPU support"
+	depends on m
+	help
+	  Enable this option to build a module which demonstrates Rust per-CPU
+	  operations.
+
+	  If unsure, say N.
+
 config SAMPLE_RUST_HOSTPROGS
 	bool "Host programs"
 	help
diff --git a/samples/rust/Makefile b/samples/rust/Makefile
index bd2faad63b4f..8a34d9d74754 100644
--- a/samples/rust/Makefile
+++ b/samples/rust/Makefile
@@ -10,6 +10,7 @@ obj-$(CONFIG_SAMPLE_RUST_DRIVER_PLATFORM)	+= rust_driver_platform.o
 obj-$(CONFIG_SAMPLE_RUST_DRIVER_FAUX)		+= rust_driver_faux.o
 obj-$(CONFIG_SAMPLE_RUST_DRIVER_AUXILIARY)	+= rust_driver_auxiliary.o
 obj-$(CONFIG_SAMPLE_RUST_CONFIGFS)		+= rust_configfs.o
+obj-$(CONFIG_SAMPLE_RUST_PERCPU)		+= rust_percpu.o
 
 rust_print-y := rust_print_main.o rust_print_events.o
 
diff --git a/samples/rust/rust_percpu.rs b/samples/rust/rust_percpu.rs
new file mode 100644
index 000000000000..98ca1c781b6b
--- /dev/null
+++ b/samples/rust/rust_percpu.rs
@@ -0,0 +1,163 @@
+// SPDX-License-Identifier: GPL-2.0
+//! A simple demonstration of the rust per-CPU API.
+
+use core::cell::RefCell;
+use core::ffi::c_void;
+
+use kernel::{
+    bindings::on_each_cpu,
+    cpu::CpuId,
+    define_per_cpu, get_static_per_cpu,
+    percpu::{cpu_guard::*, *},
+    pr_info,
+    prelude::*,
+};
+
+module! {
+    type: PerCpuMod,
+    name: "rust_percpu",
+    authors: ["Mitchell Levy"],
+    description: "Sample to demonstrate the Rust per-CPU API",
+    license: "GPL v2",
+}
+
+struct PerCpuMod;
+
+define_per_cpu!(PERCPU: i64 = 0);
+define_per_cpu!(UPERCPU: u64 = 0);
+define_per_cpu!(CHECKED: RefCell<u64> = RefCell::new(0));
+
+impl kernel::Module for PerCpuMod {
+    fn init(_module: &'static ThisModule) -> Result<Self, Error> {
+        pr_info!("rust percpu test start\n");
+
+        let mut native: i64 = 0;
+        let mut pcpu: StaticPerCpu<i64> = get_static_per_cpu!(PERCPU);
+
+        // SAFETY: We only have one PerCpu that points at PERCPU
+        unsafe { pcpu.get_mut(CpuGuard::new()) }.with(|val: &mut i64| {
+            pr_info!("The contents of pcpu are {}\n", val);
+
+            native += -1;
+            *val += -1;
+            pr_info!("Native: {}, *pcpu: {}\n", native, val);
+            assert!(native == *val && native == -1);
+
+            native += 1;
+            *val += 1;
+            pr_info!("Native: {}, *pcpu: {}\n", native, val);
+            assert!(native == *val && native == 0);
+        });
+
+        let mut unative: u64 = 0;
+        let mut upcpu: StaticPerCpu<u64> = get_static_per_cpu!(UPERCPU);
+
+        // SAFETY: We only have one PerCpu pointing at UPERCPU
+        unsafe { upcpu.get_mut(CpuGuard::new()) }.with(|val: &mut u64| {
+            unative += 1;
+            *val += 1;
+            pr_info!("Unative: {}, *upcpu: {}\n", unative, val);
+            assert!(unative == *val && unative == 1);
+
+            unative = unative.wrapping_add((-1i64) as u64);
+            *val = val.wrapping_add((-1i64) as u64);
+            pr_info!("Unative: {}, *upcpu: {}\n", unative, val);
+            assert!(unative == *val && unative == 0);
+
+            unative = unative.wrapping_add((-1i64) as u64);
+            *val = val.wrapping_add((-1i64) as u64);
+            pr_info!("Unative: {}, *upcpu: {}\n", unative, val);
+            assert!(unative == *val && unative == (-1i64) as u64);
+
+            unative = 0;
+            *val = 0;
+
+            unative = unative.wrapping_sub(1);
+            *val = val.wrapping_sub(1);
+            pr_info!("Unative: {}, *upcpu: {}\n", unative, val);
+            assert!(unative == *val && unative == (-1i64) as u64);
+            assert!(unative == *val && unative == u64::MAX);
+        });
+
+        let mut checked_native: u64 = 0;
+        let mut checked: StaticPerCpu<RefCell<u64>> = get_static_per_cpu!(CHECKED);
+        checked.get(CpuGuard::new()).with(|val: &RefCell<u64>| {
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
+        pr_info!("rust static percpu test done\n");
+
+        pr_info!("rust dynamic percpu test start\n");
+        let mut test: DynamicPerCpu<u64> = DynamicPerCpu::new_zero(GFP_KERNEL).unwrap();
+
+        // SAFETY: No prerequisites for on_each_cpu.
+        unsafe {
+            on_each_cpu(Some(inc_percpu), (&raw mut test).cast(), 0);
+            on_each_cpu(Some(inc_percpu), (&raw mut test).cast(), 0);
+            on_each_cpu(Some(inc_percpu), (&raw mut test).cast(), 0);
+            on_each_cpu(Some(inc_percpu), (&raw mut test).cast(), 1);
+            on_each_cpu(Some(check_percpu), (&raw mut test).cast(), 1);
+        }
+
+        pr_info!("rust dynamic percpu test done\n");
+
+        // Return Err to unload the module
+        Result::Err(EINVAL)
+    }
+}
+
+extern "C" fn inc_percpu(info: *mut c_void) {
+    // SAFETY: We know that info is a void *const DynamicPerCpu<u64> and DynamicPerCpu<u64> is Send.
+    let mut pcpu = unsafe { (*(info as *const DynamicPerCpu<u64>)).clone() };
+    pr_info!("Incrementing on {}\n", CpuId::current().as_u32());
+
+    // SAFETY: We don't have multiple clones of pcpu in scope
+    unsafe { pcpu.get_mut(CpuGuard::new()) }.with(|val: &mut u64| *val += 1);
+}
+
+extern "C" fn check_percpu(info: *mut c_void) {
+    // SAFETY: We know that info is a void *const DynamicPerCpu<u64> and DynamicPerCpu<u64> is Send.
+    let mut pcpu = unsafe { (*(info as *const DynamicPerCpu<u64>)).clone() };
+    pr_info!("Asserting on {}\n", CpuId::current().as_u32());
+
+    // SAFETY: We don't have multiple clones of pcpu in scope
+    unsafe { pcpu.get_mut(CpuGuard::new()) }.with(|val: &mut u64| assert!(*val == 4));
+}

-- 
2.34.1


