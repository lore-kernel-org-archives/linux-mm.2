Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CDF4AF45A0D
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 21:36:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A39F86B009B; Fri, 10 Apr 2026 17:36:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A0FC26B009D; Fri, 10 Apr 2026 17:36:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 926516B009E; Fri, 10 Apr 2026 17:36:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 839056B009B
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 17:36:32 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4EB57E32FE
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 21:36:32 +0000 (UTC)
X-FDA: 84643955424.28.9972787
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	by imf26.hostedemail.com (Postfix) with ESMTP id 442D2140008
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 21:36:30 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=guz5bEZv;
	spf=pass (imf26.hostedemail.com: domain of levymitchell0@gmail.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=levymitchell0@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775856990;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1kY8tNpZZWpISJZ66yxQbfZrkvSCDqL724L2ETykFfw=;
	b=8kJgizHPfhcPsP9Ap2x6pNlOtXGykSrsej2PyyO/QP7gEasMN9sPgfk3sAS8JCu8cNZirn
	dwNpMciIgbXSa4cTsEn3SDxshdrwfiesjRuvwtWOouh5hXiwV0ddMKNu9XrZsXuh+Sp7Kd
	Kv1x2RmAaghn35XLErPePjNFQGdfAkU=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=guz5bEZv;
	spf=pass (imf26.hostedemail.com: domain of levymitchell0@gmail.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=levymitchell0@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775856990; a=rsa-sha256;
	cv=none;
	b=4nZ1NVjh3brqQF0YbhHHzOl/DHUtO1fXzcyOR49Z3EluAXqB/QjKJGwl2kaCIsqqgnCba2
	Jiy6uwKvWzQ5xjqBz396+6rtiSIEfTFIhi1tLzBUg4W1vn02k4dtS/lVo+zhWyRA2rPwzM
	jrlotQITEcHVAfV4wwolwDbKEalKwXk=
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-82f138a6d5aso450010b3a.0
        for <linux-mm@kvack.org>; Fri, 10 Apr 2026 14:36:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775856989; x=1776461789; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1kY8tNpZZWpISJZ66yxQbfZrkvSCDqL724L2ETykFfw=;
        b=guz5bEZvflCJQ2Qz+NQXLMUsYHTXfqxgnh0aPaoRQodDIZ5ur9HSXRMJ61Tz3mByud
         UFDeUAVjsLeTsNf3OBOsanlUt0GG5GYubMTSOjfaZ3EtMFWBR+0g+KaJGbdvxYNtsA0n
         ESDed6h/u35EMzCNPZW2L5cZIeL80cX8oWH8Kik20dE8TZgkij5qySm7FU7sozqRkhAe
         kGECaD+vAj6Zd9usDQK1PK931vxeY1GccTyYK4mktILWOvhUmz4I4w1SvWz3x8nS02MK
         pvyq797m9/FVbTigiv+9459OBinTnKZnIboqcD2KakHlduvYh74TatXA9WOotlPN/m19
         hg7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775856989; x=1776461789;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=1kY8tNpZZWpISJZ66yxQbfZrkvSCDqL724L2ETykFfw=;
        b=UV68gfQaUosiLhF080pegrbhJui2cUWvXwe5duDjyw2QWu+q0NH3RUQM6Xyz6hUkti
         tEn1yi9o0zniZIAZc2Y5wtQ3ABD21Y+A7Ycew55NhRTvFjTbqdDqBgCzMKDP8EqjSr8O
         MCVfcau3UyBWikhXD8RvIwC68dbYRZCHNspzZoCcMvChbeQ7UvEABsZNnFW3EMu7T7nZ
         zcwvdRrmqjJc/MzrsJqPArKK51UFpolEZJvRo2lNNX4n6vQEfrcUYbRpGvAoWX9KGi/L
         TA3+OQJcPT6pbdeBdie3iYUU7dwli1qj4lSQmdkaNoXTBa9o0HVtZlXDXb1uzH/Rjmgg
         8iew==
X-Forwarded-Encrypted: i=1; AJvYcCUTSRQlkrR2ysxH0pt8+priqIrtaKwE5M5YB0h3yTzEBZCviYV3qIXIXmp/Nq78GQMnebPZANcJYQ==@kvack.org
X-Gm-Message-State: AOJu0Yx1CBb9naxU30BkQ4+jJa8Ji2Bg94RM4A150kl3Wxa5MCOmW3F3
	G2lvCgFJsFMDm67Ms3x8cx4pT9Ktou1y1+Bra6NQmHJCKaP4DDwbTRZA
X-Gm-Gg: AeBDievWfgzEBPzds8X9qG6NdWOM9G/M1kpi+8G5xo+cA2u34f9ayhY+TTCk5kdG/Y4
	c38HlBdJW7Jf8mR1Le/vMV0qsP9yBHnqV5z2ygBe+7LpEY32qkv1zz9iB/Q8OXSg3Ecz6/lDXz7
	KE+Tpvm0JxaKFw+HFHZMVlH9e/tXDduefzKX8UQuItHuaYDqZtcgwRG/BpKNiAg0sXfUtcMc8t0
	YiPZTTUiKMvYm9qBewbPzhulbX5ImUE2M1R8qWmKfU05Y4yQ8xUW62uf+FgH3UwjxODWE3Pf3Ao
	UDsJvS5jcnLFCLSxlRumDILGHPvG3Hp8C0ntZPeKNdtoUoCfsDdXubwwORI3Vhc1a5e/tUiyFIF
	OwdKkVzeV664F4xP7h2344wszayAaju7uil27iM8/nYP6TApXd6r2QRK1I3cxfwxynU0/bLaERA
	vO2zAsep0fY03iSZmsTm0i+GBJQasIgR/44XbJGAT8smYc
X-Received: by 2002:a05:6a00:1827:b0:82c:f041:765d with SMTP id d2e1a72fcca58-82f0c2a1cccmr5690404b3a.16.1775856988978;
        Fri, 10 Apr 2026 14:36:28 -0700 (PDT)
Received: from mitchelllevy.localdomain ([131.107.1.135])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82f0c4e3d41sm5111551b3a.48.2026.04.10.14.36.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Apr 2026 14:36:28 -0700 (PDT)
From: Mitchell Levy <levymitchell0@gmail.com>
Date: Fri, 10 Apr 2026 14:35:38 -0700
Subject: [PATCH v5 8/8] rust: percpu: cache per-CPU pointers in the dynamic
 case
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260410-rust-percpu-v5-8-4292380d7a41@gmail.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1775856978; l=5201;
 i=levymitchell0@gmail.com; s=20240719; h=from:subject:message-id;
 bh=FHBR4Wnqy/ydHjiZKFZpGeMrvO4ZgH/nNhnHVQU7j4U=;
 b=ogoO04gAaNoTx75+C8BHdZL3inRGIgFDQvjKAC93cMw2HAcpU+LGo/rKWNrCe0NdbiWcyOwiV
 B35F+4kaHNtDVfLlWS+JakD7AUAmkILOvgE7I4iFqEvMzB6fhBKWQAz
X-Developer-Key: i=levymitchell0@gmail.com; a=ed25519;
 pk=n6kBmUnb+UNmjVkTnDwrLwTJAEKUfs2e8E+MFPZI93E=
X-Rspam-User: 
X-Rspamd-Queue-Id: 442D2140008
X-Stat-Signature: k8dy4eh7ke6o1adf3orir66qygawf84n
X-Rspamd-Server: rspam06
X-HE-Tag: 1775856990-62367
X-HE-Meta: U2FsdGVkX1/+AqSx2DzHZYzf9H9liSBHf26+/KvOkEz/XDTaLy9nKlWl+tKgYv5M1T84HBkJHNVvg64Dobs8O7dxasP1PwJRdAduvT4g300TpjbDNtTetJZCj7cWym6+dAKhx1DENt4kKAA2Yq3atQ7RgKgJkIuyKgqC00QGacBHIvHSTf9066JtM8Bn/XooqnAseG9hGDJ1m6LolhUMg8G3bYOXTEc2sfoG0sJHqfAL4PqeGAv/iJkZsVLj82CcBNT7CBJIrfyylh5TACir1TobHWheuPW3V57x+NP3zgIyKgDUYOqNVsPYjdJhjaQqqWqVoJhlwUryfZLM5RWqghkGgVAGXt6KNj4Rs/DlsqakzRz4TMmyFrih9rSaFgVbMom1N1AU3GcjGge2XDUdjV7LRDPqdvWDEFizU2JWucRISKMg9+E5S/ROg6Oa25ZHswTLDS7bpfWHAdWJIR1JPaYAfRW57WnxaYYiVYL6A8lOwqaWn+JmV2NduQEArqc+rRbFGwzW5XjRDL4QYFcy6f7eveoRwemdGmUjwSHY6MKWJWq0ejBvZdNtL82ED/CegdZhHgKMCncjvJfJRn8VSoamxUK/te/2MQWze83/MX9trVlRkmJ9FpLcNOQRGFJ0XCsSbz7tNZ0BdB2hp5rSF822lF8oPO1l5QwYxMpzFvx2cdOrdOEfJ3cAqabHURb37gtG8plGx4ETla2ZJ0OJf8jCni2fNqJjtge1L14US/KRUAStK1t7PoRUOltS5mKrKNwbI2nFknhLB+mmU6u6quqDrb/8QuTyYO6loOCChT8eUZXOb5jNTgCm89bhmzZYu4OzLEvAFky4OiXu3iRZd4aGieyWQQ++zvzALvFduR3Y/cTBylgFUWavVkq+RjaIFc1pPnaPWlQC67y6ZFQEbI34fcmyEjtfmD9Y43+S0Y6OeA0ivMWrRrcZJxqa3CB7mSFXKdX8W3Qrd4O/H4D
 ++9vQfg3
 Chq7QdHjXqyu7KIk8l1YWDRpilvHuIsILpGw8tHxOPyvPR+pgMv83rH+MsnrAQoRnWS3QHlvtmMSUKQ51so8hyRta7zI7vDghbM04UlxSv27PqYQzM8+1w8Ub+C8pUu8BYRqzxoOidvPQFALfXDTKIhez50Q9AnWUkboO3TU4iYVscKXGkjjNLRWxdyEuErtltncok35LFD77tLabD3OtaBmWj2Cqa/ZpL8SdEP2VruETSeHtl/sMS4s5jOZBLDSveLkCHzmLh2ljLZGvcJS4jE+EbPa1e+hScsSFfV1OrjWue/Sms0jiMI0Bk9u5OrqlqxnHEqJkZltQE72Vs6tAK0xxNBqkrm5BGTQ/cAUULH9LnDrqq/4aE9TMZiI3zgavhyZz3NlxPjrASVx/4o/qG2VNcxTI5qgVT3qa9BeYWZ6WaqlBnwA/0qq+1s3UUF4656KKb90tpUEbxgO0g3AqRUUPKmFtbT0/iJWfgxipJ7Pu+uQttJJ8on0cqw==
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

We might as well also use this speed-up in the standard `get` and
`get_mut` accessors that give a `{Checked,}PerCpuToken`

Signed-off-by: Mitchell Levy <levymitchell0@gmail.com>
---
 rust/kernel/percpu/dynamic.rs | 34 ++++++++++++++++++----------------
 rust/kernel/percpu/numeric.rs |  4 ++--
 2 files changed, 20 insertions(+), 18 deletions(-)

diff --git a/rust/kernel/percpu/dynamic.rs b/rust/kernel/percpu/dynamic.rs
index a717138b93dc..675210098ed8 100644
--- a/rust/kernel/percpu/dynamic.rs
+++ b/rust/kernel/percpu/dynamic.rs
@@ -101,6 +101,9 @@ pub struct DynamicPerCpu<T> {
     // INVARIANT: The memory location in each CPU's per-CPU area pointed at by the alloc is
     // initialized.
     alloc: Option<Arc<PerCpuAllocation<T>>>,
+    // INVARIANT: `ptr` is the per-CPU pointer managed by `alloc`, which does not change for the
+    // lifetime of `self`.
+    pub(super) ptr: PerCpuPtr<T>,
 }
 
 impl<T: Zeroable> DynamicPerCpu<T> {
@@ -112,9 +115,13 @@ impl<T: Zeroable> DynamicPerCpu<T> {
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
 
@@ -158,15 +165,10 @@ pub fn new_from(mut initer: impl FnMut(CpuId) -> T, flags: Flags) -> Option<Self
             }
         }
 
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
 
@@ -178,11 +180,11 @@ unsafe fn get_mut(&mut self, guard: CpuGuard) -> PerCpuToken<'_, T> {
         //    exists on the current CPU.
         // 3. The invariants of `DynamicPerCpu` ensure that the contents of the allocation are
         //    initialized on each CPU.
-        // 4. The existence of a reference to the `PerCpuAllocation` ensures that the allocation is
-        //    live.
+        // 4. `&mut self` holds a reference to the `PerCpuAllocation`, so the allocation it manages
+        //    is live.
         // 5. The invariants of `DynamicPerCpu` ensure that the allocation is sized and aligned for
         //    a `T`.
-        unsafe { PerCpuToken::new(guard, &self.alloc.as_ref().unwrap_unchecked().0) }
+        unsafe { PerCpuToken::new(guard, &self.ptr) }
     }
 }
 
@@ -192,11 +194,11 @@ fn get(&self, guard: CpuGuard) -> CheckedPerCpuToken<'_, T> {
         // 1. Invariants of this type assure that `alloc` is `Some`.
         // 2. The invariants of `DynamicPerCpu` ensure that the contents of the allocation are
         //    initialized on each CPU.
-        // 3. The existence of a reference to the `PerCpuAllocation` ensures that the allocation is
-        //    live.
+        // 3. `&mut self` holds a reference to the `PerCpuAllocation`, so the allocation it manages
+        //    is live.
         // 4. The invariants of `DynamicPerCpu` ensure that the allocation is sized and aligned for
         //    a `T`.
-        unsafe { CheckedPerCpuToken::new(guard, &self.alloc.as_ref().unwrap_unchecked().0) }
+        unsafe { CheckedPerCpuToken::new(guard, &self.ptr) }
     }
 }
 
diff --git a/rust/kernel/percpu/numeric.rs b/rust/kernel/percpu/numeric.rs
index 13b4ab4a794d..4841843b05f7 100644
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


