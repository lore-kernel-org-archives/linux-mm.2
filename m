Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0D28CA0EED
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 19:08:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D2BF78E0035; Thu, 28 Aug 2025 15:01:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF05B8E0024; Thu, 28 Aug 2025 15:01:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A6B1C8E0035; Thu, 28 Aug 2025 15:01:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 813908E0024
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 15:01:08 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0C99D118C36
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 19:01:08 +0000 (UTC)
X-FDA: 83827083816.07.5199E1F
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	by imf14.hostedemail.com (Postfix) with ESMTP id E3E0D100018
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 19:01:05 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=SGDBVmWG;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of levymitchell0@gmail.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=levymitchell0@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756407666; a=rsa-sha256;
	cv=none;
	b=dQ+KCAr6fQXoqHLDg6wWtK3aDMTfQNx5znVhrDxBAvED4q9DOZ9YTGS7+hiGwmHfcujIk3
	FoCYF9XWDmoQTRpvTb18BX1or/VxWvhabC9ipDFErNWkypl0lPt6Sm41vhj0Au7h3OqDpc
	TGYm6kzvdFWbTZ8x1ZzZqkqlKUxaMJo=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=SGDBVmWG;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of levymitchell0@gmail.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=levymitchell0@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756407666;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PofwN+sl6dw2dDWCuPOORWJpa23jS48M28BtJ3SIOeU=;
	b=lD7SjJMMxt2iNGtTvL94d5ayHO8V6S+z1HzJA3t0cavIvgm28M3+YV2+E4P4jccxKHE8yR
	M35hoNt+Mu9UKtg9r1y2ET57O2ctEKYYdVHclWudqVYSVCOEU4B0izsCoFuZ85mnbj4i+a
	0Ii+hxwlvXeDzfsFm1kEG3uLjtMoYJM=
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-32783de3e87so1355574a91.0
        for <linux-mm@kvack.org>; Thu, 28 Aug 2025 12:01:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756407665; x=1757012465; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PofwN+sl6dw2dDWCuPOORWJpa23jS48M28BtJ3SIOeU=;
        b=SGDBVmWGldLkoMG2q6d74OshBoVprInizRcQsni0qHAg2lEd9v58gWPfOItaC18t6E
         aeHw4XvyB92T+Ii3Py9a+MAtau/vvmX1Q/AkKsJ24MwIiKagnQigPyeWrwzYNpL/9KRj
         MoD8RDaCPn+NhDR56qCNH7Ki1/eNlHl7w5T7P8Zr4805pzw/hTNaA3OvMtQ6xxcXV8I2
         3bpuKaX0aCg+hqKvO2Bp48ymbLJywXstxGQoUPPIuCzZaEQmnj6gsix/AxWvNHxtt6CI
         hndjpLBa4oF8s1MJ617wOaApTip9xHQBi5xE9Hb4nuZ27sNSbifF4THUJbgOX+y6deAk
         oi5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756407665; x=1757012465;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PofwN+sl6dw2dDWCuPOORWJpa23jS48M28BtJ3SIOeU=;
        b=OSdkdTBbfezXTQnsU+pGzpZOuM5My+qQFZX7itxk9g3hKUGNzNzukeMlJvTNKJTm6g
         0jgGcYS3FliaoNY9QPMuO9jRkbczZQQe3U/u5/QlhNmKzydt7XNiK5Y12aY1xpI9qeJI
         +fD4JiWohsZpBHKfr4keEab4tzrMTE/BIBxDYWTMm6S7RXYHU87z1Qmd/HTH+EbjXr53
         mTMmjYXMr2UM5fEvhvLYT2expEvxtGPz77PuyG3hJ5INXtyHt3oABRkrYbNAuBXV7KxS
         tWjzke5e41WjCzfwVlvgJ1gWKBfIU0DBdGfOCuusWUnqzl0Q4s8OnJeAz2NAe6qG/+I+
         Vz2Q==
X-Forwarded-Encrypted: i=1; AJvYcCUY0fB20pZH3mXltj/z40PCJ5yiGzI5EkYe1ilwwQkIOU1ViU3CURpV/qOFF0dd83jwK1vg3Clf1w==@kvack.org
X-Gm-Message-State: AOJu0Yz07VephD3Sc76RktYvxsQNZYLzg7PQDTZ4yeJ59/yIjwpjRWfq
	YyQ+/XdFUdA1EDvCY/zzkSo0OIs8ujYJDP65EP7rzF20dtE/OPUVcVYH
X-Gm-Gg: ASbGncsQEDx7xnhPSpEo83bLhfljxwddrEWaXIdH+43LqG9oRegRttqaokKhsI2VIL2
	HewLUAx4n+BeMahPdUGFr3PyM9dDYITpyMgg4T1ujGds5nov8enYBEjjNHZH1GNO/1tisVKgi7N
	SxfRz83+cSNC9Gtkg3ZNNbs/KCeGShUxbgVCtDTQLRAbgnMgqBotH0S3JBpVvcLl0xosGBv+xbj
	TIaBocDEGJ8+bIzYjItXxhD10JZSlp381KLM8bxI/Itw8w34nxB+nhPZBcO5KFYfHaGiKZ37iSq
	A4vQuSgd5NBjGKKKbSJO/Lfqz4kcQGsw/zXX0DkQNtPI4+hVy5Uy4pCJQmzmLgTmjp2/mCUclT2
	y/YRlvK6LzJYn91Gblx2uOevJ0P0yaqgVoi+Zyfr4nv+3+kJJOqLaFYY5
X-Google-Smtp-Source: AGHT+IFS3JVNNhR3zNJyk8gBLIrCVFra0me8HIrQNR73Yc/VuaZrqjY1lLTK7uNwZToUsptvYvMAug==
X-Received: by 2002:a17:90b:52cc:b0:327:d4e9:c4ea with SMTP id 98e67ed59e1d1-327d4e9c960mr1680821a91.4.1756407664152;
        Thu, 28 Aug 2025 12:01:04 -0700 (PDT)
Received: from mitchelllevy.localdomain ([174.127.224.194])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-327da8e5ad5sm405729a91.18.2025.08.28.12.01.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Aug 2025 12:01:03 -0700 (PDT)
From: Mitchell Levy <levymitchell0@gmail.com>
Date: Thu, 28 Aug 2025 12:00:14 -0700
Subject: [PATCH v3 7/7] rust: percpu: cache per-CPU pointers in the dynamic
 case
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250828-rust-percpu-v3-7-4dd92e1e7904@gmail.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1756407651; l=3005;
 i=levymitchell0@gmail.com; s=20240719; h=from:subject:message-id;
 bh=E3oVGdPxyaJFgaTqf2y8btrQgXMEMCM/zUm8ETp1y5c=;
 b=EzwFDp+SiJdNfpKZyQsIfCPW4wWXpRD3O7suWpzgYPTt0ZCT0wH9WnekbdPgj5jQlRyhAXkKS
 RUSwrYD8Pa1BCS54cUq+TOw4bSu3hPrC3vCTdt3FbdvBg5XQJzJ5KH3
X-Developer-Key: i=levymitchell0@gmail.com; a=ed25519;
 pk=n6kBmUnb+UNmjVkTnDwrLwTJAEKUfs2e8E+MFPZI93E=
X-Rspamd-Queue-Id: E3E0D100018
X-Stat-Signature: j4cp554r3bdg3mi39thmt9rndmwwmaq8
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756407665-76378
X-HE-Meta: U2FsdGVkX1845KjmxMViro+IduMVUl9j5dOhdHcOBqZZnl4TFBnQQ2OsIe8UfEUR+rAgoE0vxDMpjlL4b2FNfvCOgtGlP2o9Bb8PDKwGW+3gCQ4oeIgtk5NqC6qN7Nx5Cya4YPjv8bj7b9akdCYdYuXQdPrrDBgUIwe7EiVI6AhLoDPQeIEqGoxVITCkGHBi7ITxnwVJOsgZCy7DjatFS/YG0GCq0Ho21yZFPfV1bNlZ6Aj+jfLWMpn8lg4EFpUV/4vyuE/UOAT3JfQrZiUFJ5yimd7lShuY4bJyYo+3wzF4KvZMD7xbDJSVpOKx6jBITVvux90UZdTkQkEc7meJcBqZv7ITh9UcK+aooNJlUnSwDQfxb67rcYY1bkQt3qG0gfbO/7MNA3i+j2clAqIjj6kcExG8WDhxj+isiP0wF1h5F725Qp6bF7ShcCQ+5U5l5XESH7BizTXvsyi9NvsJYRdB5w4FRDGO6JAFhMAs+xkoJ12It2TzxhjsXXqaMDeaKJTYtw6kpfMCmoBKLgiOrmb2IwakVNdEhyNdGA1PKRlKK61BlDEGJjJtHhmcn1wFv8sYrjHeOJZDhQEyxoQ0rcpJDmzNQRg80Y6h2Kf0Y5aYGQWCbE/S8WL8bXrPpmCwUwu/OfwLB/FWwHxY/rj++D0NreguI7HyLUAXMY2IXVy0X3qDq64CHZSCG7KQIPf4iXeTlpM+ndFgZChLHtyfEV4jHZ5KBZ0UEuU/ispAu2vSQ62JLnWiWIPHThZ7XFlZRnadaLxWmOA+ZprevyK73NrxQFEfGqgcqNtgXdDhSMAES57YIF+Zci+ITMZWAd2T6YMnVCKELItYF+lvHY9JjY0Fcvobo9Sk2H6AVE+zDSmTQ+yToYRS8u6ze4rwWFUy3Kp6gv11wp7TGr4IKgUt77epcie5aEfYw5UrJ6L/aFELe+XyDW/oNgB+v+/ht4oM3oMqapjr2cXhQRHRNKJ
 ta/PARRa
 CmmD0W7J8GpfNsexMNRleFaJWjZpHP9Ldqxiq99yEac3Bi0eV2G6WqerA03y45t+7kZOOOiKNAkX5Mgt7S3+TGVMUHg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, the creation of a `PerCpuNumeric` requires a memory read via
the `Arc` managing the dynamic allocation. While the compiler might be
clever enough to consolidate these reads in some cases, the read must
happen *somewhere*, which, when we're concerning ourselves with
individual instructions, is a very high burden.

Instead, cache the `PerCpuPointer` inside the `DynamicPerCpu` structure;
then, the `Arc` is used solely to manage the allocation.

Signed-off-by: Mitchell Levy <levymitchell0@gmail.com>
---
 rust/kernel/percpu/dynamic.rs | 8 ++++++--
 rust/kernel/percpu/numeric.rs | 4 ++--
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/rust/kernel/percpu/dynamic.rs b/rust/kernel/percpu/dynamic.rs
index aad08e4b4251..8683e94bcd9f 100644
--- a/rust/kernel/percpu/dynamic.rs
+++ b/rust/kernel/percpu/dynamic.rs
@@ -58,7 +58,10 @@ fn drop(&mut self) {
 pub struct DynamicPerCpu<T> {
     // INVARIANT: The memory location in each CPU's per-CPU area pointed at by `alloc.0` has been
     // initialized.
+    // INVARIANT: `ptr` is the per-CPU pointer managed by `alloc`, which does not change for the
+    // lifetime of `self`.
     pub(super) alloc: Arc<PerCpuAllocation<T>>,
+    pub(super) ptr: PerCpuPtr<T>,
 }
 
 impl<T: Zeroable> DynamicPerCpu<T> {
@@ -70,9 +73,10 @@ impl<T: Zeroable> DynamicPerCpu<T> {
     pub fn new_zero(flags: Flags) -> Option<Self> {
         let alloc: PerCpuAllocation<T> = PerCpuAllocation::new_zero()?;
 
+        let ptr = alloc.0;
         let arc = Arc::new(alloc, flags).ok()?;
 
-        Some(Self { alloc: arc })
+        Some(Self { alloc: arc, ptr })
     }
 }
 
@@ -102,7 +106,7 @@ pub fn new_with(val: T, flags: Flags) -> Option<Self> {
 
         let arc = Arc::new(alloc, flags).ok()?;
 
-        Some(Self { alloc: arc })
+        Some(Self { alloc: arc, ptr })
     }
 }
 
diff --git a/rust/kernel/percpu/numeric.rs b/rust/kernel/percpu/numeric.rs
index 4de93f653f0e..3412c2de85fd 100644
--- a/rust/kernel/percpu/numeric.rs
+++ b/rust/kernel/percpu/numeric.rs
@@ -20,7 +20,7 @@ impl DynamicPerCpu<$ty> {
             pub fn num(&mut self) -> PerCpuNumeric<'_, $ty> {
                 // The invariant is satisfied because `DynamicPerCpu`'s invariant guarantees that
                 // this pointer is valid and initialized on all CPUs.
-                PerCpuNumeric { ptr: &self.alloc.0 }
+                PerCpuNumeric { ptr: &self.ptr }
             }
         }
         impl StaticPerCpu<$ty> {
@@ -71,7 +71,7 @@ impl DynamicPerCpu<$ty> {
             pub fn num(&mut self) -> PerCpuNumeric<'_, $ty> {
                 // The invariant is satisfied because `DynamicPerCpu`'s invariant guarantees that
                 // this pointer is valid and initialized on all CPUs.
-                PerCpuNumeric { ptr: &self.alloc.0 }
+                PerCpuNumeric { ptr: &self.ptr }
             }
         }
         impl StaticPerCpu<$ty> {

-- 
2.34.1


