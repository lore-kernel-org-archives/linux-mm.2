Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 210D5F45A0F
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 21:36:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 444136B0092; Fri, 10 Apr 2026 17:36:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3CBE56B0093; Fri, 10 Apr 2026 17:36:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 10FD16B0095; Fri, 10 Apr 2026 17:36:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 026536B0092
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 17:36:25 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C0EFF1605B5
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 21:36:25 +0000 (UTC)
X-FDA: 84643955130.30.7C7AE78
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	by imf19.hostedemail.com (Postfix) with ESMTP id C278C1A0007
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 21:36:23 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="oV/0aDbU";
	spf=pass (imf19.hostedemail.com: domain of levymitchell0@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=levymitchell0@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775856983;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d/ZkXAjTN+MjWCqsB5McracnlHQTzul2ROdtvOpaZMM=;
	b=7qArpzofIuTKeX0eAFhDIJTc2q+Rz5ldhq0RoLsYsGueHRpS9VZflOnwOuXcxBCpID9P0J
	x6HgvBTC89B8NBHIPqvqFho9U6Kn62cacSURCRiqhOkb/czYTb4FRImU1av5eGGdYO12DV
	fkomwQ7YcOck4FUibernZGO/thUO7jk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775856983; a=rsa-sha256;
	cv=none;
	b=HTS8V/ZVgnBzxHbkWZ40Z9ZeYXWk71gohFULrBX7ATU7VWAzeZHFyHLC6jrT2Zk+OddFVm
	pR3Aah7SnO2rtjP/k05IuRcIa/5ydfgfECFbANztrgCRaTxm9ceiOoFl49pCKivzqMqh4m
	4HUELO1hTaSFKUABn8BMRWfda+NBuDs=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="oV/0aDbU";
	spf=pass (imf19.hostedemail.com: domain of levymitchell0@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=levymitchell0@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-82cf636dac8so1295935b3a.3
        for <linux-mm@kvack.org>; Fri, 10 Apr 2026 14:36:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775856983; x=1776461783; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=d/ZkXAjTN+MjWCqsB5McracnlHQTzul2ROdtvOpaZMM=;
        b=oV/0aDbUpfT6TNomqFaVsYbbDb0gwF3Jf2g5NKK/YAr5p9xsBFZ2QKNgLECSLE+tpQ
         pfeiHz5j8CqMmDeoEnLWnICvRYlt+/PTvfMwO6bWIPIjlNiZR6rAkPkQXeRe/Jvp3B53
         3WCzQPrFQMVtipWFOo2ATpjDUYmpVTpvgZDEIUeJzpdjIUFvOpFqwWi/u4rXmlVQ0NTN
         kiqExfs2gBngZyZBfhi6Qw7hgThzFH/INGr4b2+XJByggGSZ4j8JGvn+T/O+AjRYVJpl
         2JGSEWjnbZmmC2zPK+fBhU1QaH3OyRDPWasKAlwLq9OkCTGP3Ai00TCmHwPgt6t/95Er
         whMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775856983; x=1776461783;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=d/ZkXAjTN+MjWCqsB5McracnlHQTzul2ROdtvOpaZMM=;
        b=acJ+E/ZVySqi3b+argOC0AnSkrT/Iplh3Ofrthpwe1CFrCQx6VKIlo73agkIm20Xlz
         kil58sNP13zAF7ZB2kLoqYvQ09k6L1RLVXOwjowLFA+w+QklNdFJELqKqYG3CjB6cOg3
         3Jhn/WZ3d+vp7ebAh5z94sVmpRCgH8iKeVG7qQWLNgIIhn6mt8ydtskYu2r1b/O3AhaL
         pglwWwD4dIHmkCmQqI4fm3cKpCdIZIPkpq8It3dYxc7rY/9ymZvQTIfujnF20uH1FkAq
         C4142u08etRyJv772R7MpAyxKE9ZsERK0bJL4qAqoZmeq1xx8p755j2ojwaf+Fq2YXwp
         XnTQ==
X-Forwarded-Encrypted: i=1; AJvYcCWGwCu4jv8LV3gcuBnBy0W/sJ2wY29Njyt418DQxSXSioPOk7JlQySUtvgxZV2ClaeTew0kXIu6jg==@kvack.org
X-Gm-Message-State: AOJu0YyG/Wi+KU8pxopEDwz27bSVYj0NV6OUxZrv7aCcYdS0hWbTOxTB
	SFmOJApSCtLQOzBQp5Fi2fvk1ediHsTHFHaiBaft+vL/WNBSSWBHCemj
X-Gm-Gg: AeBDieuZ06Vs2nOOEzicf+9a8N5TtxuqInwwIRA7jWgu4jVldfw/M9FwN+QgxzoFHtu
	w+QqvPIfrAkqVf8gcwmrYRxRV5Ypjb5oKvKfxlvjxmtUi2wneWBhketU2lC2k7mKIyCxmzsUamg
	Qwb7P0san8T41wtijD77bbKts7n45V4IcRsl7XjqY/hL8VlZerhjioTTCwbRmuF88oO6Ay+OhSk
	GMXpmapoXN6pGCScE+0xKFuU8WYI7ZAtD07AKUZo/p2UufOu249kFdhxKnSKd7tazmqbcZVrmpD
	3/BYynOJoz3AMRdZzxdoa4A/nawg0sPCPJkS49W12rVRYE2GlffQnM2KD1rQiDFePVPfWkCip4x
	Dqj024D7z54V9kwchcp2I1OYgcsXTC4Ws8JqmP7QoD7UULLxAuMChhcw4AwFBTkZmiBBrTD7wnR
	U4CGje6rAAwPSZIdGdCFRahoo+LcmD2k/8BhTEUl7LtLP9
X-Received: by 2002:a05:6a00:3a29:b0:82f:48e:241c with SMTP id d2e1a72fcca58-82f0c2c8063mr4788741b3a.23.1775856982403;
        Fri, 10 Apr 2026 14:36:22 -0700 (PDT)
Received: from mitchelllevy.localdomain ([131.107.1.135])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82f0c4e3d41sm5111551b3a.48.2026.04.10.14.36.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Apr 2026 14:36:22 -0700 (PDT)
From: Mitchell Levy <levymitchell0@gmail.com>
Date: Fri, 10 Apr 2026 14:35:32 -0700
Subject: [PATCH v5 2/8] rust: cpumask: Add getters for globally defined
 cpumasks
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260410-rust-percpu-v5-2-4292380d7a41@gmail.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1775856978; l=3267;
 i=levymitchell0@gmail.com; s=20240719; h=from:subject:message-id;
 bh=nFa6XzGa0lobebiKoERWPKmf/z75UhcpF+sR2BSl5r8=;
 b=Ny8jZTTn2nKtMFz16cbqPqojORJoc5t7WJOTlcvhg5M1RO1POOoBpvS/N5eE8SvhWzbrrt1xm
 JYMPyeawyXqBUwkQqwAmSvTiNScQlLsQgAT/Ju6d08ZnAo5kY7HdGdW
X-Developer-Key: i=levymitchell0@gmail.com; a=ed25519;
 pk=n6kBmUnb+UNmjVkTnDwrLwTJAEKUfs2e8E+MFPZI93E=
X-Rspamd-Server: rspam12
X-Stat-Signature: 43xu1g3rkbdsxon17pt9ga4dot6t4aek
X-Rspamd-Queue-Id: C278C1A0007
X-Rspam-User: 
X-HE-Tag: 1775856983-405551
X-HE-Meta: U2FsdGVkX18YaWmaLohjGIrIIyIqWZtgs5XOD5GGz7O5MWKZsegMVFpl/YeaZSrASLRixBr5rqN1OQi01/lXmqffS0x1/AicWw7JKWOvqNq4yAgAlZkOJ/WYK2+6Z5my0Qso8VD2rT0EMCZJJnFP6EBdgLRT9Oei6cuk82s/noSXrz1QOeBjqaeD8yhwOvhbYV3YXqI8QDPFg9QwZdyi2stnLOEZJwSq8tlG8pyASkpTSOVfNG+Suq0xACrF6MwB5FFv6MPW/Nj/A7y8mXTBMWlH6wTlimWYmCQXIXH3WRAIPuC6R3UnTcRQuQOj/CP+GqWMbr/x+qnkGmMog4fG3CdaF0q2A7AmwGs4xNNvQWkhMqYngDY1r1Hjn/R2uwWeIHNKyMOrIefisiQbWeDXafH4jbBewkSQRkD3Dp44bWM6YSPGt2vuSiC9sgk0UFx77uftmp7IAQweB/2Mm+ZEOBlDpt08avT7YQtqJR30S+p1Xq4AD8w8fOqZWACSIyMQifwXV2rt6Kvn9ffz/SGaHbIzAsNK2jK6KbEYMqxqbwrYIgf0HIeQrrc1HhPrfw5ymiowNLrQwmomJOVuvVniGjDKh/gWFtJgPQ4UxS74xbTU/NKPua6d2u7ftW5b2kKGyo5+gLqV8lcSavsBr9JE/FVyfNzli7vSzCtYaCXK1tOETha8CKlfVMuRnonNsUug5xGo6wHRKWfVi0e3z+E9Ut45XLHcOxA2+my1UXPpWspCCxePLxeEhkLKXG128KrA85aXFj5gIwSxBbbjnlYZfktL5g9yYUe3LaY/9rvPgememtpjvAslyi2/J/ZHdnv1s+/czOW6yWN+l90Of6ZxMfiaxxJur3AXc1+6zxtpiJM2Fl9yDo1+mnMg+PCprd2Z0HiEwDDI/OYBeQG8V7QHfwve5d/EHHXBHIC2eZCinWCz+8XaQXW9+UdefC1uHTO6W2gZvHnYHBoEahAx1QO
 AK1bEtXj
 qPHyQoBULEzJcaayN/qaSGn0U4G4y+r0Df0D6ftz5th1S/D94ZaDv5aSe9uVGSxhPcYZCToUM5zBUWmS02vE1H//CkoGZ7+Qo37gvlALYmtftEo0DrO0YskDECkZbU2LTQM9rYJ9lcrQP6UP9ToNea217cvGO4e3spTOcNciD5Y/1XPxr43AIMqFWsUQHIbb/TZ7Fj2BaH+wDqZ88xgoYqh4TwAAfNmPmiG2tKUZqMPvD5Q7JCnH6iSd/JIe012QkghjywysAVwBZMzc8BbZsSHdpPfruapz5umD9dSDs6eHm0z/DuLruivO8e+epiw7H/eSdDlBNzOEKQVDkSiJ9xknbyJ3T7yYqQ++kVWCQOakeK2UMTl0eThry3rqtW31gpz8Xg8SX8S/yxdJk2AWmhHf4lrb9Pud06mV0NUeC+ft+ZrRe+01m/ephCG2HflSNmYn8QNC6xOqT7j+Qd/3Xj3yAQENye1L19ZxMd2ytw2PuFNybuUFJ+Zfs6RTVLghOxvfrEwufNLLpZCRqYIFvUfhfDiYgC+1WCwiCGre4L6z630a+nqMiphGZEg==
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
index b74a3fccf4b4..2d61f1323837 100644
--- a/rust/kernel/cpumask.rs
+++ b/rust/kernel/cpumask.rs
@@ -80,6 +80,52 @@ pub unsafe fn from_raw<'a>(ptr: *const bindings::cpumask) -> &'a Self {
         unsafe { &*ptr.cast() }
     }
 
+    /// Get a CPU mask representing possible CPUs; has bit `cpu` set iff cpu is populatable
+    #[inline]
+    pub fn possible_cpus() -> &'static Self {
+        // SAFETY: `__cpu_possible_mask` is a valid global provided by the kernel that lives
+        // forever.
+        unsafe { Cpumask::from_raw(&raw const bindings::__cpu_possible_mask) }
+    }
+
+    /// Get a CPU mask representing online CPUs; has bit `cpu` set iff cpu available to the
+    /// scheduler
+    #[inline]
+    pub fn online_cpus() -> &'static Self {
+        // SAFETY: `__cpu_online_mask` is a valid global provided by the kernel that lives forever.
+        // Since we wrap the returned pointer in an `Opaque`, it's ok that `__cpu_online_mask`
+        // may change its value.
+        unsafe { Cpumask::from_raw(&raw const bindings::__cpu_online_mask) }
+    }
+
+    /// Get a CPU mask representing enabled CPUs; has bit `cpu` set iff cpu can be brought online
+    #[inline]
+    pub fn enabled_cpus() -> &'static Self {
+        // SAFETY: `__cpu_enabled_mask` is a valid global provided by the kernel that lives forever.
+        // Since we wrap the returned pointer in an `Opaque`, it's ok that `__cpu_enabled_mask`
+        // may change its value.
+        unsafe { Cpumask::from_raw(&raw const bindings::__cpu_enabled_mask) }
+    }
+
+    /// Get a CPU mask representing present CPUs; has bit `cpu` set iff cpu is populated
+    #[inline]
+    pub fn present_cpus() -> &'static Self {
+        // SAFETY: `__cpu_present_mask` is a valid global provided by the kernel that lives
+        // forever. Since we wrap the returned pointer in an `Opaque`, it's ok that
+        // `__cpu_present_mask` may change its value.
+        unsafe { Cpumask::from_raw(&raw const bindings::__cpu_present_mask) }
+    }
+
+    /// Get a CPU mask representing active CPUs; has bit `cpu` set iff cpu is available to
+    /// migration.
+    #[inline]
+    pub fn active_cpus() -> &'static Self {
+        // SAFETY: `__cpu_active_mask` is a valid global provided by the kernel that lives forever.
+        // Since we wrap the returned pointer in an `Opaque`, it's ok that `__cpu_active_mask`
+        // may change its value.
+        unsafe { Cpumask::from_raw(&raw const bindings::__cpu_active_mask) }
+    }
+
     /// Obtain the raw `struct cpumask` pointer.
     pub fn as_raw(&self) -> *mut bindings::cpumask {
         let this: *const Self = self;

-- 
2.34.1


