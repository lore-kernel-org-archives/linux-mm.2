Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36546CCFA0D
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 23:02:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 92F608E0009; Wed,  5 Nov 2025 18:02:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 907748E0002; Wed,  5 Nov 2025 18:02:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F7208E0009; Wed,  5 Nov 2025 18:02:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6AD708E0002
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 18:02:32 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 32936B9BDA
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 23:02:32 +0000 (UTC)
X-FDA: 84078079344.01.103DC0E
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	by imf02.hostedemail.com (Postfix) with ESMTP id 288C980008
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 23:02:29 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Inp7CGWH;
	spf=pass (imf02.hostedemail.com: domain of levymitchell0@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=levymitchell0@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762383750;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N6ObyT3Tt6gveKOeNa7NjmSIElr//qB7g+FJoPS22Qs=;
	b=ftYuyVyNUfwowWgcpD2L7vtRLpJodV5fUA8Boi1pts9LWBF63Q+7AM8BxpMc19kip6LYny
	szIzLqGHuPNgGo835UcKMbIDW0YsU4fk+9yPDtY/8jhrlsNSUsHDeH+qibhf8/bOLqNY2o
	yxt2Mqv/9WkT+JCPwFDGk5Np6ZiENRs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762383750; a=rsa-sha256;
	cv=none;
	b=aF7PgfgVuJS3AsIrxuwr87eQGF3BPf6WQOZS9AlZPs3HStho2x58p25vMUlS3v42/b5KyQ
	hog5DBe27jqMdzR22NA/HudrX70f0+JKAICOI0NwM3Zi8hZlqk3elPZ6UYcWtj98ruGwi2
	aJO10yeZpLNE0+mgMpfHvceGheVj2Fg=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Inp7CGWH;
	spf=pass (imf02.hostedemail.com: domain of levymitchell0@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=levymitchell0@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-294fd2ca6acso11323475ad.0
        for <linux-mm@kvack.org>; Wed, 05 Nov 2025 15:02:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762383749; x=1762988549; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=N6ObyT3Tt6gveKOeNa7NjmSIElr//qB7g+FJoPS22Qs=;
        b=Inp7CGWHFf7so9D380q8+XD/nliwkwY1Wfxz3e4PeGzt+x19xqOblyNRW+R47x24S7
         JHzCz0gTaBwv9xVXPXNBb6hM+Qtc0VFMflIhzXJbxkk9KuEoJngpPJVutUBNaQxWLbcZ
         1qU5xkSqvA7CHXn+SfUp0GCrjC5FbeD+AT467Q25avUY3dAhoUVzkAFIBGmOiwCXQfhH
         50FVzCXSs8AbvNAFrtizNQYu9W4Ab/jASgjLiJ4bYXpjDfzF+iDCtJgy3O9Gr8xgi9ih
         5k4xsaqJS+QQ8Sva5SHLmAsfM0CxpdC9nq/yCDoZCLl0YRdkLCXN1mS3Lu3ZW3/jRKkh
         3zdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762383749; x=1762988549;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=N6ObyT3Tt6gveKOeNa7NjmSIElr//qB7g+FJoPS22Qs=;
        b=aiXrnCtMlvlcIPvKKK9TgwXCsBEcXZAJQqjKwBJK7onJplxDbq2dyXQd4x7AvNRGDc
         cSyHELoEyDx1NWDBND1yEiPeWU/NOG7JsL6beJfo0iBnAvjJXBIP2AxxlELAMtyDPO6s
         qrmyZrAU9WxB+ueYywx2d2qlULu3UiZIjMxeQsegrdM+eR9IEMw/U09OdyNnaAm/TnYD
         wExOnfrNZbI9DXAoc2VPn5B8qUnyPrJBUBKV0G5FJnG5F5cg4DcV4vxg9MKC6g//St84
         La88oDAupL+9TQGbss5n2Muzs1AmRTccaf6b2of8s466CxCKTB5PT83NtmFDQSrWJqpP
         jK/Q==
X-Forwarded-Encrypted: i=1; AJvYcCXj1RhP5Z99R7ZXPvsUZONKYtGQ+4XA3PxKuOIqpaNZ1WfBsgJzYTWFVbZF46PLDIbCL9pdiAKrtg==@kvack.org
X-Gm-Message-State: AOJu0YyaXL4z0J92t+cpEnjC4OZ8WmgIp3K6HPNyiN62xWHO2Tjo9rIR
	PQ6AmKkAsX6kJSZdO5zmOnn0KH9ohU5tHOc9gQEKMj7VK1pj54fV6PmU
X-Gm-Gg: ASbGncueOEiBsICYcl2lk3qmoKDPoYiC64kFbxML/ngQmiyWT72mKLe962Hx0a2jq5l
	zghDlraUW8pPDByTKtW8ytj2O28HogN/R7hvCvA9McrgLr9hSwhzjt7jWMyL4031tu/q0dZFfUm
	ahXglHLAF9VQ4MYSR410YvZIrAM6S0V2lXZbeGMgLhvuYZvbZv7Lg6aArJKVqxYPnfiPEVv3i9t
	PAL/Vik9Job4cOVk4GTXZNuWTi3/ctCjPby62utgKTPxII6mIk3m876LWtO52SPi/xB3sf4TwwD
	Xqj3wTWhcrdA1ZmInLH3Jg9Ujg43ZT8gy+P1zmQMc4KpvktdXPp6l25lzSic3FQ+atTpYfxZBEk
	EPhdJyaUITLvjjigxKIPRAhzcwxPSKCawCQxuLTIEgZsgxLzBCgZz2Nsk7VRTd4hGE2SWUmrhHW
	jAgU4TTY/QeIW7tBkVs75YpPs=
X-Google-Smtp-Source: AGHT+IGQIBe/+YtHTkbz7bKrh6tH5nkd3eR2+Az8/eXaBw/mQbeZbYIkMzrirQWpuRr+NTG9Wz3U+w==
X-Received: by 2002:a17:903:3ba4:b0:271:9b0e:54c7 with SMTP id d9443c01a7336-296509646ecmr14131025ad.11.1762383748599;
        Wed, 05 Nov 2025 15:02:28 -0800 (PST)
Received: from mitchelllevy.localdomain ([131.107.147.147])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2965096839asm6325645ad.13.2025.11.05.15.02.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Nov 2025 15:02:27 -0800 (PST)
From: Mitchell Levy <levymitchell0@gmail.com>
Date: Wed, 05 Nov 2025 15:01:14 -0800
Subject: [PATCH v4 2/9] rust: cpumask: Add getters for globally defined
 cpumasks
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251105-rust-percpu-v4-2-984b1470adcb@gmail.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1762383744; l=3255;
 i=levymitchell0@gmail.com; s=20240719; h=from:subject:message-id;
 bh=YISdcADBQqzuvoNcCs3nt3kan2jGJvuSVytELmc4hYw=;
 b=2O8l3qrtYhENMJ4ZqlEU7sc/NrZB0x6OGnOnA5sdLydLEIj+Vo8YliGfFxguuE1tvcxcUt3d7
 91hJBW1anFIDRnuwpi6vwLUehbr2kbnrL4UdQbknVNHrFetNwdFUNHM
X-Developer-Key: i=levymitchell0@gmail.com; a=ed25519;
 pk=n6kBmUnb+UNmjVkTnDwrLwTJAEKUfs2e8E+MFPZI93E=
X-Stat-Signature: b6t4hu1h1n1tnpx4jmiknbagb9tkuyfj
X-Rspam-User: 
X-Rspamd-Queue-Id: 288C980008
X-Rspamd-Server: rspam01
X-HE-Tag: 1762383749-662915
X-HE-Meta: U2FsdGVkX19HgCn2MPfz+A0BIbHd5+ZfBbFUxIG7tsr+Vz2y+GHO9Yi4QnPAg54J04AqSsTWWngBYffxvBfeNDdaeJ1Qr4cKL/zdl9dzMpyUR+s5x9WI7MsRyzdIpX0FI98pLFRUVmBPmdXcuMQUzBtgvllcN5XnwDy2b62+jVHHEA4l0aubFotkzVxNi03iTDipA5IcV0YcXpfF6S6YijWpiUxJTh4RDEHYOe3+R0R1JhNuTZpV2NWne8BbUtkPId0o8P4UWZOC7Tmt/MXki7J8LaTJ+pvpAXUY5D+fWqH/dA0WhPx09P2Y65IF1EuFW81MVU9dhCBACviKYVEZ273EF6qprmSYDtih+gTlsLUah8hktj3Wc3gn2jiqt7fnSwlkBxRLpsZ+jBr/GTlx9QJM/CWNz785wGUD9thM9iDksx+HWvbKmvHsJOx8/OmuMm1RWIOkhmX1LZgu2FJzncKqRy4c4HoThlU/J3ij5vpGpIN8XXnI1C7F2qZ8d1AhRckBqDmGW8MKsQytThoPiRTzb69a/q7md24EAdY1P7oiSNIfNOd0DnisIOIaGhVLFSsdmQZJ4Dbk98rixpz5IBKrqt3aV8nBOPYzK5+pobw6+0Xw0v7YFpOoa8YWO2AhvugTbuy3fhRsD+N31iHzGf+c0LEBOUbpR5HPx+Olqw3iB+ViS4BmBepXpsmTwgYlvUp9PVLaKrNUX7hAa4Pq16RVdDXXTxpbDu2IBBADpUguLVFRcC989zM8FZpvQ81Y/GBgNhDEHOa/+zoMnYM9gMaxy/Y4M5a1bjzgR/kdKOM1PU1rADxQDE+dxnfcd7TMm2pNfVVHPFc74zhdMJh31K1K5skaWAxO3rfk98GsmTsiS5iljZiFzTtUUREhQ9mlQmWRDC54oZfiRDYDTv8je7mFCP9WR3g0mjYPm/LQrXg0Z+7+uBJtdjprH0eAHwHV5wm7WW8gTM6/9UWAlpG
 sBs9mh/C
 b9tmTsMl5ls18R+3XKTqXZyu3uHj1MJOMzJrQBp/oQSofKRxOHxo7SinF7dcjm8tvJkpyliu6VOpjW63XLq3Qyio/MgRsDjHnnFIsGo1g+ahrHOzByJqfk2xTKIZl5sN4TUT3f4s63GCHdsCHM7NgCx3WdZaFqgCX9BGpgypH528Rh3WB9ljdX6i8eBFcyHkWaFVbrbqcOqWNsF22kkeFPGzG5nUiNBHsjuyuWO7liYBEQVe4hHfF5zjDmzUkvxESaqRs7oDXPFdo80rUjfA5Jy/7Iqe4RYv5jJ52HqEm61mxx8Rcxkuu/3Hc9OfF+a8JD5ib1sXTGd+jr5LmkFfFC82XkeE6HiCEn6hBtwPLk9Fm8C8fSPwi9EhZWvmvXQZU9DzzJvTFvId5haV8GAKpM+7lkWVLdp7uqrJttONyLgycRC+iNBur94tlTrZiHhGtkEH5RpJTeTnVRt1zpYPwFmHmmGkt7JESRRKqajMAnY7tQCuZsBHzHcPbqLFiwjsxSkVH9nVhxivUfcFuJmDnYL3sHGNQD/YqATSm7xBTZ/vaFaS1AOh8Vs6jtw==
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

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Suggested-by: Yury Norov <yury.norov@gmail.com>
Signed-off-by: Mitchell Levy <levymitchell0@gmail.com>
---
 rust/kernel/cpumask.rs | 46 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)

diff --git a/rust/kernel/cpumask.rs b/rust/kernel/cpumask.rs
index b7401848f59e..a6a130092fcb 100644
--- a/rust/kernel/cpumask.rs
+++ b/rust/kernel/cpumask.rs
@@ -77,6 +77,52 @@ pub unsafe fn as_ref<'a>(ptr: *const bindings::cpumask) -> &'a Self {
         unsafe { &*ptr.cast() }
     }
 
+    /// Get a CPU mask representing possible CPUs; has bit `cpu` set iff cpu is populatable
+    #[inline]
+    pub fn possible_cpus() -> &'static Self {
+        // SAFETY: `__cpu_possible_mask` is a valid global provided by the kernel that lives
+        // forever.
+        unsafe { Cpumask::as_ref(&raw const bindings::__cpu_possible_mask) }
+    }
+
+    /// Get a CPU mask representing online CPUs; has bit `cpu` set iff cpu available to the
+    /// scheduler
+    #[inline]
+    pub fn online_cpus() -> &'static Self {
+        // SAFETY: `__cpu_online_mask` is a valid global provided by the kernel that lives forever.
+        // Since we wrap the returned pointer in an `Opaque`, it's ok that `__cpu_online_mask`
+        // may change its value.
+        unsafe { Cpumask::as_ref(&raw const bindings::__cpu_online_mask) }
+    }
+
+    /// Get a CPU mask representing enabled CPUs; has bit `cpu` set iff cpu can be brought online
+    #[inline]
+    pub fn enabled_cpus() -> &'static Self {
+        // SAFETY: `__cpu_enabled_mask` is a valid global provided by the kernel that lives forever.
+        // Since we wrap the returned pointer in an `Opaque`, it's ok that `__cpu_enabled_mask`
+        // may change its value.
+        unsafe { Cpumask::as_ref(&raw const bindings::__cpu_enabled_mask) }
+    }
+
+    /// Get a CPU mask representing present CPUs; has bit `cpu` set iff cpu is populated
+    #[inline]
+    pub fn present_cpus() -> &'static Self {
+        // SAFETY: `__cpu_present_mask` is a valid global provided by the kernel that lives
+        // forever. Since we wrap the returned pointer in an `Opaque`, it's ok that
+        // `__cpu_present_mask` may change its value.
+        unsafe { Cpumask::as_ref(&raw const bindings::__cpu_present_mask) }
+    }
+
+    /// Get a CPU mask representing active CPUs; has bit `cpu` set iff cpu is available to
+    /// migration.
+    #[inline]
+    pub fn active_cpus() -> &'static Self {
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


