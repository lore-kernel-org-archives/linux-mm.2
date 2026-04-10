Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68700F45A11
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 21:36:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E0B26B0098; Fri, 10 Apr 2026 17:36:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B61B6B0099; Fri, 10 Apr 2026 17:36:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D3656B009B; Fri, 10 Apr 2026 17:36:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0E6066B0098
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 17:36:30 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C7241E3345
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 21:36:29 +0000 (UTC)
X-FDA: 84643955298.30.9780810
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	by imf06.hostedemail.com (Postfix) with ESMTP id C25FE180010
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 21:36:27 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=FyJkcyz8;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of levymitchell0@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=levymitchell0@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775856987;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Qp18656DxFkgwOS2U3bgLEL3hq8+puEOLyZcxkp/3uY=;
	b=aFoUznxBx6AR3Z6W2WPMSNq03Lv6xytc2G+MsYGMdYXpKThQgfzP51VdE6v9A6UkXOjaRV
	vdD3ts1L3QKRyzcalSslzAr2XHskBViCjgotzwpVripokg5k5ui0OKeRnVw8HTPpUdrUBj
	0cWO8tVnUrSp8w87l0gQIcTrhEGHDQI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775856987; a=rsa-sha256;
	cv=none;
	b=KzkYfskWlLhM2paTaETXTIJj9svs/QfXNTamBm6cMWxyRtM303BlfwTgp4RX4zC/5XHb32
	xBcolrVB6Co3UgqKywQ90I14LbQvH+luYZyNKcLuZCco1LOxy0muDlbv++cJrTvHyXLtUi
	uWA6gmA40Vj/f9EFunGpd+E/ufGS1Mc=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=FyJkcyz8;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of levymitchell0@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=levymitchell0@gmail.com
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-82a655cfab5so2402899b3a.1
        for <linux-mm@kvack.org>; Fri, 10 Apr 2026 14:36:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775856987; x=1776461787; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Qp18656DxFkgwOS2U3bgLEL3hq8+puEOLyZcxkp/3uY=;
        b=FyJkcyz87sPMPi2iDnstEu7/+Q2gW48AhtjGjZvUueqcbcujrz4ppplDOqiVrHf1Pk
         Hhu9yrN8aNKpXdHO3pS1AxsG2kQsp0Tv339VihoIE6cuF1qDOQjyFVxTmbWi1hajEIfc
         M4dTDvuiVuK0aLlBd8PrBC5ArC4TMkl+L+Ja6D7j8eRf/I1OVy0Bnn6yuBnLX+gM23sq
         m5mZElPpRugnB9ZJgdxykGoaU4A1a4kaoTUi3grutIDZRINc0J1ubLLRREUs6gq9qyx7
         EHXQdOuDue/UgpS7Q97X5fjQdR7+qiwbJ/udNANIE1as5iID4z9hHkovce2wTqnIUiV/
         wToA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775856987; x=1776461787;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Qp18656DxFkgwOS2U3bgLEL3hq8+puEOLyZcxkp/3uY=;
        b=BlhnB4icTXNLQ2Ltd/tXRs35QxSoENsZMC/nt7maY7lUnnVb7aO6FGOgmxZW0Pr11x
         CYyfmtMxh6UGX24XymfiqFO4wlgnNOyU+oEIzWHzX8w5SSeswKCUNv1O7Orv5FACv/vH
         N7UHnQpIOTXRG9vtw87VJkxdeNTqzOOC6mD9y2kPSGKYcwLg8IbJRBMmjYXWa59kZkgz
         ZamKF/OKdfhJuY1p0DbaED5diGbJbNysM7HDE3doBG1cY3ciIMti+glWa4dHKL5qMHbr
         mc6TLEN3Xuaq8t/KboFCbQDd3gMGsxZanNwMFLBt9AyjXbaN7wEYDuU4ujs0DkUoLPe2
         Mf0w==
X-Forwarded-Encrypted: i=1; AJvYcCVO4YdHfbJSx5JFUJiQ7pxyBnGg/A3W8kZzwyAvzQ0GSXkXA9F9B3TVnEB1ZYQ0gmIZhl5PIpKdZQ==@kvack.org
X-Gm-Message-State: AOJu0YyfJB7hKXH0AcjrftsxocvcT7PMTR+On1rOupvzYCbcbNxmc3xs
	41U9ADJcileTFoMrqxQFkn6WN6ShiZxvuU3owPj9mmPok1nqAAyq4TW4
X-Gm-Gg: AeBDievLdGIijayKTiUi4RrR9g1fAzgdOc7BiAIaVo5xN9p6+zgB/5drrGwLDac+m86
	96/jm4pUNdpfr6uKQRACQg7NzNz5WMwcdLHvTsZa25IsraL77sKGshlFtzqRsPQHadLApV/OajO
	UnhL/Yeuk5nd3ErIIdkrkseNukT2rXRhlmCA06nXTPeeGzDnsbE3ml7VippOzMmxCO05zdc2rLR
	skdG+AQs9nu8VcsGhAK0lPiIDyztY52owLlMCme8fUfTFolw/Yz0vXaTXTjEzynoEVvYWCN23F8
	21JGitEEjMYeySRQVn71trRCalpUdXvQzqf64bWZw7yoNN9pIDPecKBkRPANtsXxmpoHPLpmhXd
	iif2AZDGSGQsjAr162lOCUu9OAkV3fCUDyU4f4gvYaGYvc07Z4U67MLLXJOSFfzaorrIo5SfODN
	Ko5XeaSePCUZGZu+uXid9zsEbiKKlwMv4bb9aNffNsGDhi
X-Received: by 2002:a05:6a00:4388:b0:82c:daa4:ce2b with SMTP id d2e1a72fcca58-82f0c2f1536mr5606609b3a.49.1775856986535;
        Fri, 10 Apr 2026 14:36:26 -0700 (PDT)
Received: from mitchelllevy.localdomain ([131.107.1.135])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82f0c4e3d41sm5111551b3a.48.2026.04.10.14.36.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Apr 2026 14:36:26 -0700 (PDT)
From: Mitchell Levy <levymitchell0@gmail.com>
Date: Fri, 10 Apr 2026 14:35:36 -0700
Subject: [PATCH v5 6/8] rust: percpu: add a rust per-CPU variable sample
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260410-rust-percpu-v5-6-4292380d7a41@gmail.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1775856978; l=13379;
 i=levymitchell0@gmail.com; s=20240719; h=from:subject:message-id;
 bh=MZsr3UdiERwV1f/QQfUp88/S78aGt9zYSriryeD+vLw=;
 b=rKc93uyRO4qfeWUI6y1uol7p76Ye5NgzhZp3pAGG5J/gi0WD/mvuCE/Sq1fkPMzpQCuRmoB/N
 Ur2QmXulKQ9BolYILXGzMRLyvFRjw8NpVKiAPCPSKhnRjb0Yh6UWMrz
X-Developer-Key: i=levymitchell0@gmail.com; a=ed25519;
 pk=n6kBmUnb+UNmjVkTnDwrLwTJAEKUfs2e8E+MFPZI93E=
X-Rspamd-Queue-Id: C25FE180010
X-Stat-Signature: 9cre89two4xnesaobrexymzwxxrnyath
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1775856987-278368
X-HE-Meta: U2FsdGVkX1+ED6Rpynlukl77lqvlVu3M5rCPfHYjroNRPepyWlYI4vXmkwQTVp54AvcXvtSnNSH/BgdekIoPo46gi+5qryhEXWod1mU6L+vT4myq2c/PrD4UT/4Aav74AlJDHM6mNeLsNeG9W8aWer4OU7Oci/fOGtgReUJBw6jrpoHHq5kqtLBs63nTHVMhytzKFGS8Ljpq7MoQuXlkYyekH2AmjyERQO/CSyMnUI7is5W+AUdghHQXX5kko6laqfGZO2WSdgLJPvxlX89kCY5W5rDX0iW6JzLGjQ283PrhkvGLzd3Cj5xaLoookYQwOBs2xYCayhIUTvRjJRcmxIXjNt9LLqUjjIkPG2qXJB1RDGDe3QO8wqR1YyQw3Q1Pv1Cu8VLaDApw38L4b42D5RCeFrSRomh2139PrBjfyxaWULm7h+deITUqdJsHO0Qj5vKWuV7dKRmsX/cwH6etOiNB6LtM6VJ+WerjV0e5lltPKrVo0eAhQBaVhIGVPoXrDk5yTzIretoO9/eXfG8Qafk/J33bAlIJyfM67urTs6dYEmvWdp/tLnZT2JRl497F3o3zHlyh2z7SAdttJEHNjO6TAWIdhNTBUbZfwWPTPLBT1EQowDHLvlUGzmRH6Ggu+/CZMCOG64IonTXreXVJKDb1zBUIl/ZNWyeZS3edTTQHUDL+LtPf5WK871K9zEUI49ieEIunIjWGQb2tOjozr9sAcAtrB1WWrKO1oXC+a41c93NhIK3iCqhCBvSGrrXSEV1gVTxCVUjRP6dgxtIDyf7iHHj8eayRRj2qF2v0XydU4GeC6yWiVSr3IVg1o0SQv3eZwdNyOzcIfxSVETHWU/7ORIGy75JJLZc37com2Y1W3sdj6Gk3OcnJ04v5EjFsstPESwwWEWkmb9bnvgSRRM0mo6i2BHp98nFsnoYT8uJPXnu2ipEJ6DaBqWZL8UzksIbISxdZ2+x8yFhmdvZ
 pHV6eK4S
 fuqKrfm0qNGOrSV780TsiHQnJRQDU1UbBhEkw2xQQDDGFuYGvtd/2S03+q0EOvPrgA3yYE0VRxAjVD6/Pll7QppeiAIskJ7LXPyAWEGNV8tzlwmwwY4SybVfDRK1Nls7R18ouOvbzNxG5qFVXfB07hnx6ajOxda8pmjvFiPVSauiqHY7IVJHvvowQlPRh8hyju42TaQI6uA3EikH0wNxcv2F3xi4MEFTkTJ0Ip3I0latBlULCO+/EDihDOifRxP9IduluIaEXkt1aaUNaE9pEyDrtXiyRNKx+cF51cHFQzWP6Hzi5kSj+o/mbBwUZX+gA9VUNUI5NJHvxIAx+AXxXdEro6t+krca2i4tWA2z+Diq7nYB95k9bRc902uaXVyxAq0GyQUeeGx8MfaEWvx4p/4qjwnP/FLe0o9Gjj+RVIoNJLzAh0Ms126muDj995bHFVTyMYLSLwhCndw+OBUzmmRKfRTM958bnJyxprFV9TxcY5NiSJR52rw4H4g==
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
 samples/rust/Kconfig        |   9 ++
 samples/rust/Makefile       |   1 +
 samples/rust/rust_percpu.rs | 278 ++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 290 insertions(+), 1 deletion(-)

diff --git a/rust/helpers/percpu.c b/rust/helpers/percpu.c
index 3b2f69a96c66..173b516cd813 100644
--- a/rust/helpers/percpu.c
+++ b/rust/helpers/percpu.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 
 #include <linux/percpu.h>
+#include <linux/smp.h>
 
 __rust_helper
 void __percpu *rust_helper_alloc_percpu(size_t sz, size_t align)
diff --git a/rust/kernel/percpu.rs b/rust/kernel/percpu.rs
index 0ec1245038bb..72c83fef68ee 100644
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
index c49ab9106345..2616dbd7b37a 100644
--- a/samples/rust/Kconfig
+++ b/samples/rust/Kconfig
@@ -172,6 +172,15 @@ config SAMPLE_RUST_SOC
 
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
index 6c0aaa58cccc..1ce120ac0402 100644
--- a/samples/rust/Makefile
+++ b/samples/rust/Makefile
@@ -16,6 +16,7 @@ obj-$(CONFIG_SAMPLE_RUST_DRIVER_FAUX)		+= rust_driver_faux.o
 obj-$(CONFIG_SAMPLE_RUST_DRIVER_AUXILIARY)	+= rust_driver_auxiliary.o
 obj-$(CONFIG_SAMPLE_RUST_CONFIGFS)		+= rust_configfs.o
 obj-$(CONFIG_SAMPLE_RUST_SOC)			+= rust_soc.o
+obj-$(CONFIG_SAMPLE_RUST_PERCPU)		+= rust_percpu.o
 
 rust_print-y := rust_print_main.o rust_print_events.o
 
diff --git a/samples/rust/rust_percpu.rs b/samples/rust/rust_percpu.rs
new file mode 100644
index 000000000000..5adb30509bd4
--- /dev/null
+++ b/samples/rust/rust_percpu.rs
@@ -0,0 +1,278 @@
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
+    sync::Arc,
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
+            pr_info!("The contents of pcpu are {}\n", *val);
+
+            native += -1;
+            *val += -1;
+            pr_info!("Native: {}, *pcpu: {}\n", native, *val);
+            assert!(native == *val && native == -1);
+
+            native += 1;
+            *val += 1;
+            pr_info!("Native: {}, *pcpu: {}\n", native, *val);
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
+            pr_info!("Unative: {}, *upcpu: {}\n", unative, *val);
+            assert!(unative == *val && unative == 1);
+
+            unative = unative.wrapping_add((-1i64) as u64);
+            *val = val.wrapping_add((-1i64) as u64);
+            pr_info!("Unative: {}, *upcpu: {}\n", unative, *val);
+            assert!(unative == *val && unative == 0);
+
+            unative = unative.wrapping_add((-1i64) as u64);
+            *val = val.wrapping_add((-1i64) as u64);
+            pr_info!("Unative: {}, *upcpu: {}\n", unative, *val);
+            assert!(unative == *val && unative == (-1i64) as u64);
+
+            unative = 0;
+            *val = 0;
+
+            unative = unative.wrapping_sub(1);
+            *val = val.wrapping_sub(1);
+            pr_info!("Unative: {}, *upcpu: {}\n", unative, *val);
+            assert!(unative == *val && unative == (-1i64) as u64);
+            assert!(unative == *val && unative == u64::MAX);
+        });
+
+        let mut checked_native: u64 = 0;
+        let checked: StaticPerCpu<RefCell<u64>> = get_static_per_cpu!(CHECKED);
+        checked.get(CpuGuard::new()).with(|val: &RefCell<u64>| {
+            checked_native += 1;
+            *val.borrow_mut() += 1;
+            pr_info!(
+                "Checked native: {}, *checked: {}\n",
+                checked_native,
+                *val.borrow()
+            );
+            assert!(checked_native == *val.borrow() && checked_native == 1);
+
+            checked_native = checked_native.wrapping_add((-1i64) as u64);
+            val.replace_with(|old: &mut u64| old.wrapping_add((-1i64) as u64));
+            pr_info!(
+                "Checked native: {}, *checked: {}\n",
+                checked_native,
+                *val.borrow()
+            );
+            assert!(checked_native == *val.borrow() && checked_native == 0);
+
+            checked_native = checked_native.wrapping_add((-1i64) as u64);
+            val.replace_with(|old: &mut u64| old.wrapping_add((-1i64) as u64));
+            pr_info!(
+                "Checked native: {}, *checked: {}\n",
+                checked_native,
+                *val.borrow()
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
+                *val.borrow()
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
+            on_each_cpu(Some(inc_percpu_u64), (&raw mut test).cast(), 0);
+            on_each_cpu(Some(inc_percpu_u64), (&raw mut test).cast(), 0);
+            on_each_cpu(Some(inc_percpu_u64), (&raw mut test).cast(), 0);
+            on_each_cpu(Some(inc_percpu_u64), (&raw mut test).cast(), 1);
+            on_each_cpu(Some(check_percpu_u64), (&raw mut test).cast(), 1);
+        }
+
+        let checked: DynamicPerCpu<RefCell<u64>> =
+            DynamicPerCpu::new_with(&RefCell::new(100), GFP_KERNEL).unwrap();
+
+        // SAFETY: No prerequisites for on_each_cpu.
+        unsafe {
+            on_each_cpu(
+                Some(inc_percpu_refcell_u64),
+                (&raw const checked) as *mut c_void,
+                0,
+            );
+            on_each_cpu(
+                Some(inc_percpu_refcell_u64),
+                (&raw const checked) as *mut c_void,
+                0,
+            );
+            on_each_cpu(
+                Some(inc_percpu_refcell_u64),
+                (&raw const checked) as *mut c_void,
+                0,
+            );
+            on_each_cpu(
+                Some(inc_percpu_refcell_u64),
+                (&raw const checked) as *mut c_void,
+                1,
+            );
+            on_each_cpu(
+                Some(check_percpu_refcell_u64),
+                (&raw const checked) as *mut c_void,
+                1,
+            );
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
+                *val.borrow()
+            );
+            assert!(checked_native == *val.borrow() && checked_native == 1);
+
+            checked_native = checked_native.wrapping_add((-1i64) as u64);
+            val.replace_with(|old: &mut u64| old.wrapping_add((-1i64) as u64));
+            pr_info!(
+                "Checked native: {}, *checked: {}\n",
+                checked_native,
+                *val.borrow()
+            );
+            assert!(checked_native == *val.borrow() && checked_native == 0);
+
+            checked_native = checked_native.wrapping_add((-1i64) as u64);
+            val.replace_with(|old: &mut u64| old.wrapping_add((-1i64) as u64));
+            pr_info!(
+                "Checked native: {}, *checked: {}\n",
+                checked_native,
+                *val.borrow()
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
+                *val.borrow()
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
+        assert!(Arc::into_unique_or_drop(arc).is_some());
+
+        pr_info!("rust dynamic percpu test done\n");
+
+        // Return Err to unload the module
+        Result::Err(EINVAL)
+    }
+}
+
+extern "C" fn inc_percpu_u64(info: *mut c_void) {
+    // SAFETY: We know that info is a void *const DynamicPerCpu<u64> and DynamicPerCpu<u64> is Send.
+    let mut pcpu = unsafe { (*(info as *const DynamicPerCpu<u64>)).clone() };
+    pr_info!("Incrementing on {}\n", CpuId::current().as_u32());
+
+    // SAFETY: We don't have multiple clones of pcpu in scope
+    unsafe { pcpu.get_mut(CpuGuard::new()) }.with(|val: &mut u64| *val += 1);
+}
+
+extern "C" fn check_percpu_u64(info: *mut c_void) {
+    // SAFETY: We know that info is a void *const DynamicPerCpu<u64> and DynamicPerCpu<u64> is Send.
+    let mut pcpu = unsafe { (*(info as *const DynamicPerCpu<u64>)).clone() };
+    pr_info!("Asserting on {}\n", CpuId::current().as_u32());
+
+    // SAFETY: We don't have multiple clones of pcpu in scope
+    unsafe { pcpu.get_mut(CpuGuard::new()) }.with(|val: &mut u64| assert!(*val == 4));
+}
+
+extern "C" fn inc_percpu_refcell_u64(info: *mut c_void) {
+    // SAFETY: We know that info is a void *const DynamicPerCpu<RefCell<u64>> and
+    // DynamicPerCpu<RefCell<u64>> is Send.
+    let pcpu = unsafe { (*(info as *const DynamicPerCpu<RefCell<u64>>)).clone() };
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
+    let pcpu = unsafe { (*(info as *const DynamicPerCpu<RefCell<u64>>)).clone() };
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


