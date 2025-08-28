Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EBC60CA0EED
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 19:01:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ADF938E0031; Thu, 28 Aug 2025 15:01:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A1A638E0024; Thu, 28 Aug 2025 15:01:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 90A418E0031; Thu, 28 Aug 2025 15:01:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7291D8E0024
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 15:01:03 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 39DEC5896B
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 19:01:03 +0000 (UTC)
X-FDA: 83827083606.17.8D736DC
Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	by imf24.hostedemail.com (Postfix) with ESMTP id 3660318000F
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 19:01:00 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Ir9aOMB1;
	spf=pass (imf24.hostedemail.com: domain of levymitchell0@gmail.com designates 209.85.215.170 as permitted sender) smtp.mailfrom=levymitchell0@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756407661;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Bvt8V2L0ZNh+boeq/LSZQ3FvXwvuba2eMR3cn35JyVE=;
	b=2Eiha+bDbTYcn64yfsvDpBPLhJPpSuxjL0rJLRmESypNCmlOI0jKUurpi0V+rGfERIhYJs
	9z0zOHaD3WsM5Bh32dxHlATMRr19xpLEQ2TriCnEuvEAH8YMdGkHkFOpC0DogeuJ4uUCmL
	tIluRyWKs91Egyw1cxEQ1uDvURICYKU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756407661; a=rsa-sha256;
	cv=none;
	b=TJQTYpOQPXPUhztfRgCufAWUTvMJ5X+YlczDGejhS0enl+8jvvN1IlXDkxzhwB9rE0ORJj
	3uz/qGf2be5Pq9dTf/n1q8WWEBoeZr758I4DHTfp0+glYXgKjHSlnVyqjJ/qFpptCc3Rlt
	FXg4vfZ3OD0Sp1CzERFJ9eZnm5o2Y+k=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Ir9aOMB1;
	spf=pass (imf24.hostedemail.com: domain of levymitchell0@gmail.com designates 209.85.215.170 as permitted sender) smtp.mailfrom=levymitchell0@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-b49d98691faso1014285a12.1
        for <linux-mm@kvack.org>; Thu, 28 Aug 2025 12:01:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756407660; x=1757012460; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Bvt8V2L0ZNh+boeq/LSZQ3FvXwvuba2eMR3cn35JyVE=;
        b=Ir9aOMB15xjCcdzTc1r4Ryze0LhkvbCcfB1LHPInds26Kk0+HDVEJFBmpI90/T5+Lo
         WnQ0g/49CERS6u8rZI3LTNEttiV8G/6RUgif+EMysRLxfjjo4GTjB5DyQt7IcBt5Vnsd
         5JF21b213ZhL2EmmZLZYrL/t8wHmukkuFYmsyiITMRKLr9AuKjX+eVOU2wnsFAq1blVO
         sAKrdGc2fxALkVKhQtfdd2gtQC884k0e/n6ihxLly5y9AyfyZCv7gAwjPF+9zroBAZA2
         /bqppO463aZOTWl4lryt0eORzPDPpfVLvk2of07dUMNoH8BN0u7cdD7R3+V9gWmXoWPQ
         qqnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756407660; x=1757012460;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Bvt8V2L0ZNh+boeq/LSZQ3FvXwvuba2eMR3cn35JyVE=;
        b=LnWRtqmotAmVRcTGwVJ8dqWP7P3/iA6QNXWsWONzB4V/n05xUxVmeUcSx/JNX7qczb
         8JtnxT942OSigM1eS2jjVyXhZwCX4ox/0k4rM/A1wJ+YigIkRBIPPque9l8ZlUn0sil6
         gaXLsFI4Og/KYMncJE85pYBZUCxoTkEkJzxN0Ahh+omqf4CxekzrIDcZhXOH3h0tAhlj
         nw3HqQnRAyi8Rf1nPcLLfLU7BHO48mzaHx+Wup4hL/SqZGrsnlqGYs6Ibnox9Cz+xGMP
         ff9CJaMxvtW6dd4xBmUDmXSYyoB9KIX2SZjZo/LclBgRZrjMaJxHpfkq5MiEtDcTU1H1
         k/lg==
X-Forwarded-Encrypted: i=1; AJvYcCXi9Px1UsYejxTN9DDQBd0BR+mxt0kaJR9uI3JAZJy8W8i6oQU9qh94f0Is9odA1Xa34F20S2FXkA==@kvack.org
X-Gm-Message-State: AOJu0YwT6Jf/pJ3+WPZqMM2Hq+EtnGZHKPzKwU67sY0bTYqyYyZGpoOi
	ryB2o5+nj/EcnbY9XyuyGWHPSmXGm0Id/JWPJgFSNs38GjPPiKpBNRAq9+/6Ay9q
X-Gm-Gg: ASbGncvVGKEoTeTUAgnGbbPcSLMW+uir2SXvFYbIOmsQuQGOIZGzxUhJ2Q7iUk+uxhX
	Ql2RBexJYrEUG0B0roa0glGBMcgBo7UV2/Wud27X0p+7ZbjUoLIguzDPy4FkD94T0MI38UBS3hk
	KEvAJuog3j8/PLxYeAHzKejmzJzEce+wXbPfgmdgQM7q7/RPn3+5/G7M5s4qDQB753AkRkjX+9M
	/kF+svjNokPvUgEuwDnpPx6mbyBS42KaFVpAhK95jvIJzTnxBcMGRm6D3d4e/7tiYUCzSYvJt/c
	Iym3/CLmYsd1ryCkPjB/1c3vLTGp2msgbKEEfzxUBx9x9MStzDJ+5lJVeCPkulfEfXmkjdN6xhh
	yo8M3RzsR4WhV93ntU+7QfdHHq9LHjrvM3M/YIY+py/e6hQ==
X-Google-Smtp-Source: AGHT+IGQ0nXDwQcd/znOgAHZEvb/bzRjgwuKUmEsfOnNkUUtXy/qInCtHGgW4wGogHPA6Xq9dBOiiw==
X-Received: by 2002:a17:90b:2810:b0:325:4c48:af54 with SMTP id 98e67ed59e1d1-3254c48af7fmr24907043a91.11.1756407659077;
        Thu, 28 Aug 2025 12:00:59 -0700 (PDT)
Received: from mitchelllevy.localdomain ([174.127.224.194])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-327da8e5ad5sm405729a91.18.2025.08.28.12.00.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Aug 2025 12:00:58 -0700 (PDT)
From: Mitchell Levy <levymitchell0@gmail.com>
Date: Thu, 28 Aug 2025 12:00:11 -0700
Subject: [PATCH v3 4/7] rust: cpumask: Add getters for globally defined
 cpumasks
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250828-rust-percpu-v3-4-4dd92e1e7904@gmail.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1756407651; l=3131;
 i=levymitchell0@gmail.com; s=20240719; h=from:subject:message-id;
 bh=7jLeexJ2MkarSDLXB95v3y9TJT2OgU8sLC2vrrP6MLQ=;
 b=zdA4F+LZY4slMG5Ve/I8Wi53or1iBeA2t76HP1S/w0KxfOdIOk6rZ4Cn8dc+CTq5sE+G9IGfS
 wDLwFlpvR9NCANhbfUBEg7Q4L7XNwOUKLYnJTuUUrEqPZkM8zn1ec0T
X-Developer-Key: i=levymitchell0@gmail.com; a=ed25519;
 pk=n6kBmUnb+UNmjVkTnDwrLwTJAEKUfs2e8E+MFPZI93E=
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3660318000F
X-Stat-Signature: 4dh1quatomp915ocor3rypkq4dzun8en
X-Rspam-User: 
X-HE-Tag: 1756407660-508492
X-HE-Meta: U2FsdGVkX1+4Nc5JhBjLbUromlbZ1jScuHu5+2UqsVSCW+UifvPazlpGq5bA/GXSWutKS06H93Hut3l7QD3lVLp191dD6U08HNgmEBbOJ6exunYEZEOXZfN99nDsu8MTztDzQ/UC8y3wI0eW8YPd2qvbV4LGxPCN9IOCNT0u33HGO8HL/czmZRszzqnU/bycDFrCgPIHHebBXRIs6ARVrkxSDWKKvBzJQZnUNFFKugdLaYOt+iEAJw1xIz231NmV2WAoHMVQZTBKLg4yvrzzPQyU/DYlRrUBmLSchXQOPJXDSNWZiE21lQoXeb9qBP59bUaY42wp4efLlYBO9gT7H1MY21A7SgcL9g4X15OD3Pj1acP5u6wd3DN8H2MioAhn2XPXFe5qFAxdLwVLgsWZcVXtTsw+5Jc8D+N6SB64dWjnojIYrEV5AOz80dnoMiu71YhSf6TDZpJIjBy2AkWz6gRLBatcMdZIQIAJw2yWQnTXwlOXezdNLMlRKtwED6/vIrFG9vHQaKJNm3lJYnioAPhYQvKwIwrGipPKId45z8fFnoOGP/L5JJ+SYB72q8Ld1f3iUkQdpiDSWjW9GKTVAEVoQ9ZCe6TcGPEajXQlVzDpk8JKuDjCBFTFAHR9Cxeq2Rafn6LiXQdRPFnY9CO2lWIZvtgGdWK20CJlxDss7ACPX8nase4UE2pOcf+t/redWmwtHgZaaiwd87Gkg1XjFdU75glj5IpbG2v+9HRiNKkHCz3pSDpMcxNWgaF2gAyGi0iG3Plr8+sP3K0C6xiJ2AyA/u/pFUDjGUJ1mzdZ3xGYmgoSsPz3SzgUu4HK3+JiXxhyiypkmyOAFPVh7+xTEkEvNFWCID2F+olhwCrV4vm3xQxCGhbMAkzx15b4GhpCQINcmkgEIFsGH2fvPjq/eY1Okvygd8jKZQ8iRHqPioysDhVI9AFr9uNXXSTbNuh/yQ//iU8sWproFbD31C4
 ENmcW/cd
 Xnl/wqdZi02nIofQ0PjvFFzLDGrNgnFtdCa62mYMxzUKcWWSsNBJB9rl7Ty7Nkdv6tIRHW32s2ZdIYJzkYz8Lff12sBb7wWaSs1ytwvb/4jAXRYrg56QUfUnfgeHx3VXYaTh1Wsirf0GTMYYmYk0wcNw8QjJYbRL69fOhcXt79TcxgwHvbJ2t/mqdimPTd0vPfmEtz6ty12AC+YO9GTc5WAYTz8eopRTvyAYmTiiixTDz9vdmFEORuBJbnVz9qOVj08X95dxcRwQHllkcXKijKzm6ZrixjQKfXa4ehptk1ERHrxzuTLesGUDXuYIn6p1GmzDMJqUIn/hnPCXM0t0V0R1A72f/6e/iextO5EHq3oryqbr726YdW+DmMRX5LV7nsQ+XGGK3gubIP54sPxWpQE+G2WrXTjuq7ypEmmmyEUXmU5C4PnxrJ60RdTWeo5nOQ22CCNeBS/SpsmMgpYlMLBPdFiDFH2/C8M/iSHxmesvwDMSFrYDit1U6dw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add getters for the global cpumasks documented in
`include/linux/cpumask.h`, specifically:
- cpu_possible_mask
- cpu_online_mask
- cpu_enabled_mask
- cpu_present_mask
- cpu_active_mask

Signed-off-by: Mitchell Levy <levymitchell0@gmail.com>
---
 rust/kernel/cpumask.rs | 46 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)

diff --git a/rust/kernel/cpumask.rs b/rust/kernel/cpumask.rs
index b7401848f59e..ca9aa6875b4a 100644
--- a/rust/kernel/cpumask.rs
+++ b/rust/kernel/cpumask.rs
@@ -77,6 +77,52 @@ pub unsafe fn as_ref<'a>(ptr: *const bindings::cpumask) -> &'a Self {
         unsafe { &*ptr.cast() }
     }
 
+    /// Get a CPU mask representing possible CPUs; has bit `cpu` set iff cpu is populatable
+    #[inline]
+    pub fn possible() -> &'static Self {
+        // SAFETY: `__cpu_possible_mask` is a valid global provided by the kernel that lives
+        // forever.
+        unsafe { Cpumask::as_ref(&raw const bindings::__cpu_possible_mask) }
+    }
+
+    /// Get a CPU mask representing online CPUs; has bit `cpu` set iff cpu available to the
+    /// scheduler
+    #[inline]
+    pub fn online() -> &'static Self {
+        // SAFETY: `__cpu_online_mask` is a valid global provided by the kernel that lives forever.
+        // Since we wrap the returned pointer in an `Opaque`, it's ok that `__cpu_online_mask`
+        // may change its value.
+        unsafe { Cpumask::as_ref(&raw const bindings::__cpu_online_mask) }
+    }
+
+    /// Get a CPU mask representing enabled CPUs; has bit `cpu` set iff cpu can be brought online
+    #[inline]
+    pub fn enabled() -> &'static Self {
+        // SAFETY: `__cpu_enabled_mask` is a valid global provided by the kernel that lives forever.
+        // Since we wrap the returned pointer in an `Opaque`, it's ok that `__cpu_enabled_mask`
+        // may change its value.
+        unsafe { Cpumask::as_ref(&raw const bindings::__cpu_enabled_mask) }
+    }
+
+    /// Get a CPU mask representing present CPUs; has bit `cpu` set iff cpu is populated
+    #[inline]
+    pub fn present() -> &'static Self {
+        // SAFETY: `__cpu_present_mask` is a valid global provided by the kernel that lives
+        // forever. Since we wrap the returned pointer in an `Opaque`, it's ok that
+        // `__cpu_present_mask` may change its value.
+        unsafe { Cpumask::as_ref(&raw const bindings::__cpu_present_mask) }
+    }
+
+    /// Get a CPU mask representing active CPUs; has bit `cpu` set iff cpu is available to
+    /// migration.
+    #[inline]
+    pub fn active() -> &'static Self {
+        // SAFETY: `__cpu_active_mask` is a valid global provided by the kernel that lives forever.
+        // Since we wrap the returned pointer in an `Opaque`, it's ok that `__cpu_active_mask`
+        // may change its value.
+        unsafe { Cpumask::as_ref(&raw const bindings::__cpu_active_mask) }
+    }
+
     /// Obtain the raw `struct cpumask` pointer.
     pub fn as_raw(&self) -> *mut bindings::cpumask {
         let this: *const Self = self;

-- 
2.34.1


