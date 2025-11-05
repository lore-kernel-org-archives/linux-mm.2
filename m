Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF10BCCFA0D
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 23:02:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F35D8E0010; Wed,  5 Nov 2025 18:02:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 97C1E8E000E; Wed,  5 Nov 2025 18:02:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 86B348E0010; Wed,  5 Nov 2025 18:02:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 708A28E000E
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 18:02:41 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3E44D1604D0
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 23:02:41 +0000 (UTC)
X-FDA: 84078079722.24.AF4F6EE
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	by imf30.hostedemail.com (Postfix) with ESMTP id 2F40280020
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 23:02:39 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=RYfOCNDQ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of levymitchell0@gmail.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=levymitchell0@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762383759; a=rsa-sha256;
	cv=none;
	b=bpwUWiuclga6mmO0Px7Xjm185x9N1YGTITwf0jF1J7EjGDPLYoaQr5ylwdFqFuscgkMGp5
	8Z6ut+qR0Mg9ZbseYhCyiPxJ1s0A9jHr0WsBxxkqMFF8OafYlaQ+wbuIlv4IZ2bwPxy4Br
	tWDGvBVdlYug+1CnRyVBVL6vtUxnHQY=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=RYfOCNDQ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of levymitchell0@gmail.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=levymitchell0@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762383759;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4CKxB9LH52Z/bMQCpny1rQR1F6MuknwX7Uens3YkL/M=;
	b=XZdrYrjlW2CeaRSDOmGotsVoAAKT5YfUDuarciYjQykHCTAt8KCxob6D2XqftwOzasI2DR
	Vlnpdw1T36EOwfY1m7sjtoICjOmlC9XhX2Bnr9QpRCPdtTM8OTLpikDks9zlnHAYKU1g/j
	L0fMI4v2Ske/IJXaAgWroIfesEoaods=
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2955805b7acso12378315ad.1
        for <linux-mm@kvack.org>; Wed, 05 Nov 2025 15:02:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762383758; x=1762988558; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4CKxB9LH52Z/bMQCpny1rQR1F6MuknwX7Uens3YkL/M=;
        b=RYfOCNDQM+j5SBM0oRRhBsp8eXu94rwFV6UG+VFgogfzjDm8vnxMLDleMwbOj8wCo5
         GdyF5JK7jfj8in1w3E9MHh+2ar1m2C/q8bLyj2gC3eslNGt1YFb20tgsRauWhqf89eG0
         mP0zSi5BUrthvIqDvB4c7859RquUEV65U6lqbJp8LjSIxgN1DcsIMNDKhdDwx+mc8yge
         cILy03+/kYy1KhgAbIwTHxQ8aBtLA6kL13HEzMIDfkt8GkldSDC4ohLYc6KMEyMgsO+8
         Nsk+HGRKYWcpR9Yfq/jHImRnZo/TMMAAC1YkPS3YA1Amg6hcRYLueNM/8f7AVz4NQhkV
         jvxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762383758; x=1762988558;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4CKxB9LH52Z/bMQCpny1rQR1F6MuknwX7Uens3YkL/M=;
        b=Qs634hYUDlCtzO0NBfSTDjRdW1HCb3L8Q9f0EnKx0UTU29xi5jA5jezPP/Z4YEF3o+
         AFBuI8x/b3nMjpKE52+zvMaUTqmx7T5XAayyISgRGBAEoWRiGgAutQnnM2QvjQ9F/J+U
         KJdHst+yalFm6K9MQkTF5M+NaPwO+tKK5P/BF0AHyBHBzlVErVdRpFqKUBBO7erC28xD
         +93HdtzHuMatOnHljl7SuYyUkM4vQgj27L9zgXmUOOTwAGp7i4Fka1cYjcCsAm9aZXS4
         dfVlJK2taa+Py+1tNP+ZPj6/abM8oYm25lPBqCEZnj8e9SAmd8JfEJ7xdUPWW4X6TmRu
         3KGQ==
X-Forwarded-Encrypted: i=1; AJvYcCXXvT6/JwuioYBdCOpFEuAxrDjSoibncq2XMH+bCyp71ueg4hn0zqVt9T/w0vdnvkrR4Zqp9LKD5A==@kvack.org
X-Gm-Message-State: AOJu0YwnjIlgc7TMg5l7O8K6v9QOpblRCQlzMvM9Iob2dYhzlMp/WABE
	4puPU5rt+bSoK3O3VywPv3DaH9PfgrV0l8ZaFfX1xVJQ6wN/HDIf/E7K
X-Gm-Gg: ASbGncvuHlCfS2EgsgKeceMrB2CawDE+VKJBhLbCSOsw6k5oE04XhJY9AAYOQFqQHDK
	n1lVsxH6zIDHs2y0e8GrxsucXhaT0I4uTFjpek9Eecfys429caSVBF7N9LoY9WHuUPVxx2P3g+X
	12lg+9ueZo6ceiHfH8tw6bk2G/ILBs+WKGJXdFyW93/bFZqEv3XMo2X2AS0avTiXlGc3sWNF8AI
	CbLuUA1ZpHIXUPKOcLEoIIQAiicUPa9GRGhOR3FSf06Qxt0C/vhuOAX7xEc89/LTwZl1gSU6k4i
	0TurjkqdgfPDgPrOTPYWk1FuuTFnKtIAeRY29e8gA17lfeOYF5fpDxE/3tfYxLSAXRxthZvWGKI
	ZluLf7BKl1l7FqUKEMP45HdubpWyyHWIqoymR7b7aBUPMdkpcnHjcaT07DZv++YNoa4nYe/w8aJ
	DKNONTx4gEM4GoLLtMuJatWk3S8ua5XW4LDA==
X-Google-Smtp-Source: AGHT+IHhgn+8YeMFZ6PkDMcRo+YCf1hZhzierVrKIefbBTSFSntXm/b76xNV6gdhRNX1LQibgdMpiQ==
X-Received: by 2002:a17:903:19c5:b0:295:50f5:c0e3 with SMTP id d9443c01a7336-29650c5af22mr13633165ad.14.1762383757680;
        Wed, 05 Nov 2025 15:02:37 -0800 (PST)
Received: from mitchelllevy.localdomain ([131.107.147.147])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2965096839asm6325645ad.13.2025.11.05.15.02.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Nov 2025 15:02:37 -0800 (PST)
From: Mitchell Levy <levymitchell0@gmail.com>
Date: Wed, 05 Nov 2025 15:01:21 -0800
Subject: [PATCH v4 9/9] rust: percpu: cache per-CPU pointers in the dynamic
 case
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251105-rust-percpu-v4-9-984b1470adcb@gmail.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1762383744; l=3408;
 i=levymitchell0@gmail.com; s=20240719; h=from:subject:message-id;
 bh=D3RYV7HLnBtitWmFErq2p8agS2TaxcSWS/fZMuq/eYY=;
 b=F3SsT9YaklVAwHq+tWc26blxo+XKhI/hNXdvlsqIbyeoSRfdd0pXKRoUeMLZ44FBDlWmhxL/e
 gWSNZYhRA9NAl0i5KEtL+ADOegGqjFQajhB5DktuXDNdnfmDxdg1IZC
X-Developer-Key: i=levymitchell0@gmail.com; a=ed25519;
 pk=n6kBmUnb+UNmjVkTnDwrLwTJAEKUfs2e8E+MFPZI93E=
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2F40280020
X-Stat-Signature: kxjdb8famo166yzxoc1989uqzn4p8dz4
X-HE-Tag: 1762383759-661622
X-HE-Meta: U2FsdGVkX1+ybFvt2/9pJrqeI5dqU45/YIXUVouvECaTg62GT8EwfvUWpaEkbFng+IJtVLUpSOvdPQjYJUSXbzZOjXKPXTIX6Y1kcqfkiWS527ZtuT4OYVYUaDPNcm23fvQFdOh8LYPzTilo+faY5cPKc8V5of2HFRbSXlVxQNhkjh6e2qwirYVNfXvP8FxNsYk7dtUyp1p7SnGJICmj/QkibDYyZ3e0Rfj9PMrAZsSN/PZHmGQRSDMAu4opZ4csueoy2bHvgsWuwNQmEK0FbqVwhcGAqcsknjIS+Y4n72yqgOEgeuLkNLcHv7QPDWZKcFoKscGxKt2eh9PeBDN001BdcYC6zck+2C6vhWZ0PIzMaqtRMEpKQwXuy2xpp6PZMat/0I7UBXK0Bf9uopbdHwckXC8itI6I4T1v7rYIUrFmFLt1ZABvhWn+GPerkH5Gs278Y91k9IDNrJPsaJK2WJNFp09Cves4qm/b8fZI3S5FxvlY3RSfYxDjXyS+9/7yxNPmfyt+RIpso52lTh+oYl5d1hne4QSorKwlwpfSvXj/PfKcSPR0aJEiwYguqjTmZPL7S3ALShpiu/RwvtuvZPGOIWIVKBCXAp9JiSiMNWdEWqPJUwsYyGwp/WUZ9j40Q2VW7prVE8zK0dksl+5orJWCNkeh5guDtOrGDTpt6E520y1EA+ETq8SbD9AFLXU7+vTzolWZjQDfu/H4RL+gc/SgaKA2DwCi+AA+21M6siBmbeggg/l7dv0/+aSGxjjTDmrLGeu97vQPPa22dijFdh/lHPUlIzXgRuaPKGm4pbQoPxU24Oll/YZg35DS0/JTILuAHxY6kWOC9Fi+g/HdoNiZuznWQhKePh40EhOZ8r8S7vEIKnWHxFMNteewmywFg1B3CnsxnZnS1P7xD3WFoCRpNstJ3Fo0hXEYgYQTQlgcUGhyouOxYXsNFMJeAA9LLKdLmUg/ouY1GXYigo1
 8MYmI5jX
 pQo7KGkoRzj1/XeGASScyRwDTzEcv0xsxSQ7y1T8IUB/RxFBqOuUyLMNaN/ZVL5zit3/O13DpFvWIKzaX5VMdaJh4xZu6TU5Cj2JFZ45ayJoU/j4mE2uilNoOSNOhWtkasEjJOi+A2NSPlB8br/FvELXffcbNVu+Ld+Neunx1HqcBFw14IBMqsHdvSz2AYXvQjDhZpyowu1H/aEQpwxVRMVCkEkAHX8vG+CuW+z6v5pXea+cz+47ACRoUceNLTF48U0f17VSG+ADvZlMVFRQKXmFb6DNeQL5C8bPaC2CPGOgAooHoxFlVBXKfohLlk4N4XFt3t4WWfz2Z2iHvgXXlg0XEWAEhd/6SRvJ3wCTb4gl1bMaEnn5yeQRGYGAHJrcl9UqPWve+Q/zA3mzGg5LuypAfd3N4lmNhdGhM04YD4tpTPsFaFVjTPpUqQxsrzDYVZ3BfXy+bNa/Y9MbfQEnllonIL7xXjBjejJBoUxbxzfjZ5+ZlZvEXr73cbw==
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
 rust/kernel/percpu/dynamic.rs | 22 ++++++++++++----------
 rust/kernel/percpu/numeric.rs |  4 ++--
 2 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/rust/kernel/percpu/dynamic.rs b/rust/kernel/percpu/dynamic.rs
index 99acbf6363f5..dcf3e1c4f7a9 100644
--- a/rust/kernel/percpu/dynamic.rs
+++ b/rust/kernel/percpu/dynamic.rs
@@ -72,6 +72,9 @@ pub struct DynamicPerCpu<T> {
     // INVARIANT: The memory location in each CPU's per-CPU area pointed at by the alloc is
     // initialized.
     alloc: Option<Arc<PerCpuAllocation<T>>>,
+    // INVARIANT: `ptr` is the per-CPU pointer managed by `alloc`, which does not change for the
+    // lifetime of `self`.
+    pub(super) ptr: PerCpuPtr<T>,
 }
 
 impl<T: Zeroable> DynamicPerCpu<T> {
@@ -83,9 +86,13 @@ impl<T: Zeroable> DynamicPerCpu<T> {
     pub fn new_zero(flags: Flags) -> Option<Self> {
         let alloc: PerCpuAllocation<T> = PerCpuAllocation::new_zero()?;
 
+        let ptr = alloc.0;
         let arc = Arc::new(alloc, flags).ok()?;
 
-        Some(Self { alloc: Some(arc) })
+        Some(Self {
+            alloc: Some(arc),
+            ptr,
+        })
     }
 }
 
@@ -115,15 +122,10 @@ pub fn new_with(val: &T, flags: Flags) -> Option<Self> {
 
         let arc = Arc::new(alloc, flags).ok()?;
 
-        Some(Self { alloc: Some(arc) })
-    }
-}
-
-impl<T> DynamicPerCpu<T> {
-    /// Gets the allocation backing this per-CPU variable.
-    pub(crate) fn alloc(&self) -> &Arc<PerCpuAllocation<T>> {
-        // SAFETY: This type's invariant ensures that `self.alloc` is `Some`.
-        unsafe { self.alloc.as_ref().unwrap_unchecked() }
+        Some(Self {
+            alloc: Some(arc),
+            ptr,
+        })
     }
 }
 
diff --git a/rust/kernel/percpu/numeric.rs b/rust/kernel/percpu/numeric.rs
index e76461f05c66..23a7a09216d0 100644
--- a/rust/kernel/percpu/numeric.rs
+++ b/rust/kernel/percpu/numeric.rs
@@ -22,7 +22,7 @@ impl DynamicPerCpu<$ty> {
             pub fn num(&mut self) -> PerCpuNumeric<'_, $ty> {
                 // The invariant is satisfied because `DynamicPerCpu`'s invariant guarantees that
                 // this pointer is valid and initialized on all CPUs.
-                PerCpuNumeric { ptr: &self.alloc().0 }
+                PerCpuNumeric { ptr: &self.ptr }
             }
         }
         impl StaticPerCpu<$ty> {
@@ -78,7 +78,7 @@ impl DynamicPerCpu<$ty> {
             pub fn num(&mut self) -> PerCpuNumeric<'_, $ty> {
                 // The invariant is satisfied because `DynamicPerCpu`'s invariant guarantees that
                 // this pointer is valid and initialized on all CPUs.
-                PerCpuNumeric { ptr: &self.alloc().0 }
+                PerCpuNumeric { ptr: &self.ptr }
             }
         }
         impl StaticPerCpu<$ty> {

-- 
2.34.1


