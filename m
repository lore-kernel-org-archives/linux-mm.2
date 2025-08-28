Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E667BC8303F
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 19:01:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 365458E0001; Thu, 28 Aug 2025 15:01:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 31C698E0024; Thu, 28 Aug 2025 15:01:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F52F8E0001; Thu, 28 Aug 2025 15:01:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D58ED8E0024
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 15:00:59 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 999CF1DD64D
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 19:00:59 +0000 (UTC)
X-FDA: 83827083438.27.EE8354E
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	by imf29.hostedemail.com (Postfix) with ESMTP id 958DB120015
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 19:00:57 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=K4Q1LuU+;
	spf=pass (imf29.hostedemail.com: domain of levymitchell0@gmail.com designates 209.85.216.44 as permitted sender) smtp.mailfrom=levymitchell0@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756407657;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1ZhDUhaFQNfQlBtAcofKP9r1jz8p+0mi3JI78z3ft6A=;
	b=CR2OBA549ICjsBYH3WASVV6troQeEXiF0C65aqn9Mj/KxUg5SyTLLuF/vAva/9u6SY7dqr
	NeipERvTJd/1x8PUXjNBq+jARvxAFiNYgw4yG4v+DK0ZwhPyb1jFpj+Is10v6sqApM30CJ
	cbdc8iPt8/P5GacisSflQ1DV3I1TtZ0=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=K4Q1LuU+;
	spf=pass (imf29.hostedemail.com: domain of levymitchell0@gmail.com designates 209.85.216.44 as permitted sender) smtp.mailfrom=levymitchell0@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756407657; a=rsa-sha256;
	cv=none;
	b=cKQlojVM5+qyJnrU+vUOWTbx4VUliG/MKAVLYRwI+VXLu1+lR+ZMOderW0GefPEDM37gv4
	IlgcSBjSmhWmw5uIioIESOu8e51wAgybc9M7gK3K8clUpYJn9PDGHjtIaku5dXNlOrfQhs
	5kkV01HbFrhvlna0NDeepNuAKVlN4+0=
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-32326e202e0so1219472a91.2
        for <linux-mm@kvack.org>; Thu, 28 Aug 2025 12:00:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756407656; x=1757012456; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1ZhDUhaFQNfQlBtAcofKP9r1jz8p+0mi3JI78z3ft6A=;
        b=K4Q1LuU+ClENrOlhkkbecs2ZNxuXaY8Ojk4x3VLlkGpLdKVnvLD2YMsf+ZRkmiJtlB
         3nk20vOXl/+6YGeRenfdbhGIPxCp3NNwjikN2fx9m/AA2X7n28NCvVK3jypSilFvXmwn
         XeLu5RSNH5/2z0tK8ftTPUKf3rDslFRz+BY1iKK8JSppPxWytrcXYsyKiDVuAcc44qng
         jXVanea+ckKQ6Ccvep5EzqUvKAGawPm6DHJxA/fB0wgpYxKtdDxF/1OTGmG9hOZphdBS
         ITjppTfvczLiU0lEGoAs+HTw+XtJTwxdFCrmJkDCiB8/eI08bKp7guoADckEi6g1FP0Y
         b/TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756407656; x=1757012456;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1ZhDUhaFQNfQlBtAcofKP9r1jz8p+0mi3JI78z3ft6A=;
        b=GZdv60DEpnbJ+70M/JJ7iktiH+mPQgf+e267SoFzbO5S1jDsu4A6w/4eqGDW/vGzoj
         wTL/ZkSmEPXjFDAgVHre9fwDJDFQWfz9MLo6KA0jzfIGDROH6i/QVNSfz4rsDpr0pP5s
         U55gGTO8xK5r12C0NKh2tr7LWbRy2Ota7fCVJ4S2op1O8nUZVyCagRv35mTRVW2ASDpF
         q675qKJCoaaX8kvAyH3zoVsZSMr5B/JP9uyBdZNVBhgis98SV+py04vTivbGoNsTh4K6
         +YFB2YEMzY/tgHC+knhiQZnY42H2drgd3GuCcqXiihngoX4KGojCPQ2CugmyxIp5K783
         +iTA==
X-Forwarded-Encrypted: i=1; AJvYcCWvW2A+YS8tzF5bE3Mf9imL2zyPteqHazC7rBcOjeNSnkHxodSym9P72EGFKdxM7s8cvtVS3Y4oHg==@kvack.org
X-Gm-Message-State: AOJu0Yz23Di6ZjRm+PsC8repRUGkyj1Z5LVzvjTMshHjOcmSKO//UcsL
	ZFR8A6zHCb/H6kcRAMDCg4m7Qlj6KJ6WJEhNvJ4gbg2g/eyGcU4Vw1e/
X-Gm-Gg: ASbGnctjCBtWTPsDxVEoUK3R7ESmrA45qcmqizTWkd6T0okia2WcA3xO+R6kHmo+B/H
	Q3sZiuS3vTbaiEX/f0G1oc/wKMAlRMvGFxaeGGBbz9mUbT9wqM6bQB/6yKQC/yZKxMrjeUumqKg
	5X2zZb1tveH82gHZ7OrcWnLjAnmfLKostBNGxTzWWbKzxsXhT7op9/aQkeS45tsoHdIYUaK/nOr
	KCup/VB2JlzpvoB2Y//wBh8qQ04gGHCbgvOa5BufutYhIQKzPbLHLBPuixM4E6aR46SKI72KdQo
	2F5dv8gyEOn73B3f9gUMqWPrE3Dqsyo8Yak7R9LoEfpj4PBROlo+14iiP2T3ktzHbEi0cKiiA6o
	hEftg7JBQxv0NUP5Qocbvy1SLZ1kRP+cKeThwdsRb4FiNCsSqbbRqMxw/+T4Hl94N/wY=
X-Google-Smtp-Source: AGHT+IHo7oikH+vFaY9+hLdTEQynZ5bmtJTwKQPd/bkYuk10/5MoVZOnXrdbi27adYGqQTrDB9+UAg==
X-Received: by 2002:a17:90b:5101:b0:313:2206:adf1 with SMTP id 98e67ed59e1d1-32515ec3611mr32905500a91.4.1756407656141;
        Thu, 28 Aug 2025 12:00:56 -0700 (PDT)
Received: from mitchelllevy.localdomain ([174.127.224.194])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-327da8e5ad5sm405729a91.18.2025.08.28.12.00.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Aug 2025 12:00:55 -0700 (PDT)
From: Mitchell Levy <levymitchell0@gmail.com>
Date: Thu, 28 Aug 2025 12:00:09 -0700
Subject: [PATCH v3 2/7] rust: percpu: add a rust per-CPU variable sample
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250828-rust-percpu-v3-2-4dd92e1e7904@gmail.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1756407651; l=8590;
 i=levymitchell0@gmail.com; s=20240719; h=from:subject:message-id;
 bh=pd7OPcbrPdAWI/7kgDpMFHa6ITv6ppIv2SVJeXLx/4I=;
 b=4mAs3HCOL9pJ49x1leBl0+kcOiuQILdFXWsH7vNLoFF1Wq1q/MBWhoCiT2WAwz0Md1dx4ui2m
 v3yZReoHe2iAs8mOLddeXU1f7l6uG4C5ye4DJW8gUYzwd2VbteBC/J8
X-Developer-Key: i=levymitchell0@gmail.com; a=ed25519;
 pk=n6kBmUnb+UNmjVkTnDwrLwTJAEKUfs2e8E+MFPZI93E=
X-Rspamd-Queue-Id: 958DB120015
X-Rspam-User: 
X-Stat-Signature: wuogm6uqtfat499cfe8faq6expbpyhz3
X-Rspamd-Server: rspam09
X-HE-Tag: 1756407657-386796
X-HE-Meta: U2FsdGVkX1/j8iqx5eW6r68qGwyLAqEoFf35L8wPxpyag+39ZrWqWP/r7Or26jcwBUdbsYQ1+i0QxGvUFQQZMYsHe549OX65aN6xLTcfqQk+UxRidiK2YZ1mW3dwic0BJO2ade3rKTPZ+fx0jALjGuKcBxn6ZtfxFqNFz2VY8QANqko3/YikZ8L5l4S/oNGgYfLeip1zPGrSCrheUF4Lv8vh3cXaQD+3b4V0YBnxucYhy7md4Y106IBKnotwY9ECkJ8fBSkz37ZnRUxMxN1FLOqaV5UaaoonY39jzeukX5zBeBD+7/ayof5plnDCiexCNGzjJtSaytRZkaimwtyZGKeDn6ISYOVMTxlYNfOnMm3iQ2M3eLHNvAF5rcvO9Rwz0fS0NNKC4epD9k/GlgDPk4vR3Xj1ZFcwnwnJC2tOaGsxjFXAuguE9R6RMRErA45KfCGs1eWJpFMSywEAenB2uNoqvizHMaw+yUGtlaZcht1LKdWwCZ8EcQikTLKTBZuQp6w3H0fUVUHykW+trQhj00i0Z2hNezVTXZvhQJfOfyOcxuNSAX/221ivg1x65peltu7nDPau0XBQWYe6rLjUi8zVUhX1Tl9BHzRc4v7SSgo1QFA7dYtqnfr/ZBn8wRZ75KVQ/U4/QFtb1qLCK2aN87noe76/6BFiLtV65elILg32/Rpk3DRy+uOVdxtBDS73qrH5V8rpbwIATslVl79npcCiDpAJjPXyfFM02kcBrO+qK/AtKFO7DRb0/2/bnYzpC/5gjxDxqbzp8h9UAZP9h/uAoEjdokf/H/aZweku9kTcevkZUsXWnRJA74VSnRH++hqjhXmPksUfeh3OqwRlhE494POtZ9WW+WGd6LsRhPyPKd8rl3/wKJN+jr3DYf1sIDJqzZQWRI8cUM5QnkwMIcMQPEngsNa3Nq/y1K3S1OKSHVBWfr7mP6QtQLF/dI1wKec0Z8hapyOStdaK0Y3
 CoRHCodU
 V7L8O8wZD0XnJnH0hXO/nIam8x23b7XExzrhIWYzaEcXQyl5Moi5Clr5BCnt1aJVpJ2PsZQWNX9cWLxYHSMgtdVmtrDVRI5Trgnj5ECCSxUDs9jdXGhjEVgx7EDjlpCn1uWXZTMxoGqcBiLfA0B5FdmeFoHjTWkjjZaFnwYX0NLZm+2fbM1BUV16fpL2SNYwtSlvE1AH/fW89wH8zcYNFOPHqfGiUi089WBsokvb0X9kDARi9RDieEBNutW0wLFviJurmIRyCxOFUOVumyrDKRGt01qaQCyZKJYYq1Hwg+L2F24aXn/WJVie3ykPLVWPIYtYXf6OV7lybfWcT2ez0RWZK3I4HO2FZkM14gnRmDseW1JPdew8GOg+xCcgJVZPo681T95fq3eUyIsJIzyBuPRgF6F2WhvUkVcGRFny982HCBfW3fKsvCzHSqrEys5BkIrfenOIaTwTgtsytO66HvACEd3nnMgl1UD4Knh34K9lGQtRTX7zhYcrRHw==
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
 rust/helpers/percpu.c       |   6 ++
 samples/rust/Kconfig        |   9 +++
 samples/rust/Makefile       |   1 +
 samples/rust/rust_percpu.rs | 163 ++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 179 insertions(+)

diff --git a/rust/helpers/percpu.c b/rust/helpers/percpu.c
index a091389f730f..8cc01d094752 100644
--- a/rust/helpers/percpu.c
+++ b/rust/helpers/percpu.c
@@ -1,9 +1,15 @@
 // SPDX-License-Identifier: GPL-2.0
 
 #include <linux/percpu.h>
+#include <linux/smp.h>
 
 void __percpu *rust_helper_alloc_percpu(size_t sz, size_t align)
 {
 	return __alloc_percpu(sz, align);
 }
 
+void rust_helper_on_each_cpu(smp_call_func_t func, void *info, int wait)
+{
+	on_each_cpu(func, info, wait);
+}
+
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


