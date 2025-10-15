Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7BA1CCD185
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 18:14:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3565E8E0079; Wed, 15 Oct 2025 14:14:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 32E568E006F; Wed, 15 Oct 2025 14:14:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1CECD8E0079; Wed, 15 Oct 2025 14:14:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 06C0D8E006F
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 14:14:37 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D03EF83CC1
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 18:14:36 +0000 (UTC)
X-FDA: 84001148952.27.EE2FBC4
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	by imf02.hostedemail.com (Postfix) with ESMTP id 10AC280014
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 18:14:34 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=IGYUQsHO;
	spf=pass (imf02.hostedemail.com: domain of debug@rivosinc.com designates 209.85.215.172 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760552075;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bdNStz76VWOE6F3y+SVDIONwXTUEF86LLBNXBRlWzEc=;
	b=Yj9rXN3LKgcDRzg1HWOET1WoELSAgZD4aH7qFfHASxdxVRVLMriA7fEDFcFjwE2F7iH4p9
	NAX2XLM2WKYnEx29Ibn03WWfgHyB4zMEn8vhrA9dxtNrhRsZHFGPwUFLQGvHdPc4oOCRbz
	adkbx+2ZuZ7YJGNpuy4GWdKdO4rZbPU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760552075; a=rsa-sha256;
	cv=none;
	b=EczLFcQbSwMK+kPrJwKg7d8IqtQ1kRfKtRTooeXUdaOViq9Lrp+Ij3K+V5EiRDQN9LcPGt
	yYm1BC1SNjbo0+zRPTTHlY2uHjHXR41TB3+gpJJTG0SXBcp/w/YQliwznNEx364zMGycMC
	qQaL7rBhqLrVduNNVYI5t+K+ISpv+WU=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=IGYUQsHO;
	spf=pass (imf02.hostedemail.com: domain of debug@rivosinc.com designates 209.85.215.172 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-b556284db11so5985859a12.0
        for <linux-mm@kvack.org>; Wed, 15 Oct 2025 11:14:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1760552074; x=1761156874; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bdNStz76VWOE6F3y+SVDIONwXTUEF86LLBNXBRlWzEc=;
        b=IGYUQsHOGXetqr9a/BFbCbviI6GbmXK16ZNO2wlInZN8dujh6zdlXonxiFdSpcUJuX
         RBylIpJ3Oh6lZpEzAYc1sNWyUGkzebE602VUYdCnxAolX1T4zYqQrdcKTEzrmP7uMFbF
         /P2G+K7W3UTM784UpDcXPCAH1EBjt0Qg2gE6XemxQ63LxBvUZKVnYBl1+bN+uCD/AVnQ
         ixKiCDvyzpvpfurTF81pzhsRIElPGn+tzrU0MXGqytFXrc5j4DChkQHQAlto3ThEYPHl
         qwVg+WlxDj5AqGNPbiozf+coU5e9ON0pPYgQgUUyuMGYM9470vmxoT+QJfqddrHJZtdh
         /LMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760552074; x=1761156874;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bdNStz76VWOE6F3y+SVDIONwXTUEF86LLBNXBRlWzEc=;
        b=eL5t+MZ7NdhbARaKHRsL9HHQ+EgUiDgCt1D9YHudXDAhx6V9qlV7grTU6beh/kS5wG
         dqFJvlNikDqqrMvclqRG9V6Sqb6mem/1EhvfCwhI+GYQ+2C8eJoNXprqK/YRW9obRsWW
         GjZFdDN9W89Kih4PP3N0QZ0mzmTiKhac1dAavwxxx4QN7489jDFFX4Ifil9G4HnzlO3z
         91E5SZD2AG16pCNmrNHwR6NhQ6rWDhlATEenSdcwLxuW1+v3Gq1yXUHvearmMxaHpOle
         HVQQoWxFGAmynZn0zxkMNM42Qe4yDOqQl7Ea/q1mV4/IheWpqEA0cT0HsyU0M9Jbt370
         qxMQ==
X-Forwarded-Encrypted: i=1; AJvYcCWp6CZjCMpq0ZY8WlbBcEyCamKpjcrWdL4IVfaBjZiPqPK8udvrCY1KAHaics5Da1oqd4EOetSwDw==@kvack.org
X-Gm-Message-State: AOJu0Yzoi4imhVrc/wDKn8XCiy6uBI/uMHH15SB5SsbsHcNa3/f3Su5M
	hpgq8rUFFIBtrgWKRAXyWmCpQLZoUXlatJ0agNnZop5cdUmTjQ8yRtbIIUbHb8gGZ4FXYTgBRFh
	ZsVq1
X-Gm-Gg: ASbGnctSGyL7vWWG+tVpNanAww0Del75wHgWvCcOfKRmwyWkbFkf6IC3RxVzZjdTheq
	3ng48omzeIVHwd1BBpJQ59XcdroTax+kSut3fl/U4H8eBPr1i3tqT50UTMWFAIOULEFWG+gaTK8
	Fnz2rAfGiMuSlQ0W2SA3XCBzKHpGZD/rgVc/vZxW7dUu41WXCIunYq4JgHiCNW7GR6Jd+njNueU
	iPrcgi6MbUQPRR5CrnufsutUzeyEiIlqquZ6wnBTRb/x0thyPXynUOAc7eu58n0jXS3GwXWxnRc
	uBDqMecK/JLZPhZ2Ec+wjt2EX6JEu46hIG3rzjkMuNZK8innO+SQBP8KGeY92ZV39e8SkPvNmRd
	w5qFbMq/I3tgTb/w59JYRz91Jhnlwxs0vx3ljGWhTuCvG0e1qbGx0uY7W9edBKA7ahX52TbOf
X-Google-Smtp-Source: AGHT+IFCUl9nXn6/g4/QRMrFFJf2GC+QgAYmJMvxx+BmD+RDmRwOcXPgXjT+VcwPuM2j+ySbUUEM8A==
X-Received: by 2002:a17:903:1b0b:b0:269:91b2:e9d6 with SMTP id d9443c01a7336-29027402c3cmr409235785ad.46.1760552073655;
        Wed, 15 Oct 2025 11:14:33 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2909930a72esm3126625ad.21.2025.10.15.11.14.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Oct 2025 11:14:33 -0700 (PDT)
From: Deepak Gupta <debug@rivosinc.com>
Date: Wed, 15 Oct 2025 11:13:54 -0700
Subject: [PATCH v21 22/28] riscv: enable kernel access to shadow stack
 memory via FWFT sbi call
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251015-v5_user_cfi_series-v21-22-6a07856e90e7@rivosinc.com>
References: <20251015-v5_user_cfi_series-v21-0-6a07856e90e7@rivosinc.com>
In-Reply-To: <20251015-v5_user_cfi_series-v21-0-6a07856e90e7@rivosinc.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@suse.cz>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 Paul Walmsley <paul.walmsley@sifive.com>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
 Conor Dooley <conor@kernel.org>, Rob Herring <robh@kernel.org>, 
 Krzysztof Kozlowski <krzk+dt@kernel.org>, Arnd Bergmann <arnd@arndb.de>, 
 Christian Brauner <brauner@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>, 
 Eric Biederman <ebiederm@xmission.com>, Kees Cook <kees@kernel.org>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>, 
 Jann Horn <jannh@google.com>, Conor Dooley <conor+dt@kernel.org>, 
 Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
 Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Andreas Hindborg <a.hindborg@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
 Trevor Gross <tmgross@umich.edu>, Benno Lossin <lossin@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 linux-mm@kvack.org, linux-riscv@lists.infradead.org, 
 devicetree@vger.kernel.org, linux-arch@vger.kernel.org, 
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 alistair.francis@wdc.com, richard.henderson@linaro.org, jim.shu@sifive.com, 
 andybnac@gmail.com, kito.cheng@sifive.com, charlie@rivosinc.com, 
 atishp@rivosinc.com, evan@rivosinc.com, cleger@rivosinc.com, 
 alexghiti@rivosinc.com, samitolvanen@google.com, broonie@kernel.org, 
 rick.p.edgecombe@intel.com, rust-for-linux@vger.kernel.org, 
 Zong Li <zong.li@sifive.com>, Deepak Gupta <debug@rivosinc.com>
X-Mailer: b4 0.13.0
X-Rspamd-Server: rspam05
X-Stat-Signature: qzdjwgp9gid87iy768bit58319t1hyr3
X-Rspam-User: 
X-Rspamd-Queue-Id: 10AC280014
X-HE-Tag: 1760552074-942221
X-HE-Meta: U2FsdGVkX19R2EYW0Cmd2/z1SYRC541/eVb8msFB1LmIt9pdAuumhK5KfDSOci8XicNwJWpWDMUgNRTWwIFRGsjE6dGR9PagalDklU1fX20N7dZWu9rcCwTp9pvfadvold44EqSgxEOAPqWQtSWNmTWGvMV+SfzrayqQZoeg6wYb8C4haRVin7xSucXX7c/uZyZRANc2I/iJZPr/+TNFD5SE/w16qghiO0Lo5ykwrAtSqWEUN7dcwTeQ5JTDu3Ia89paImHmAMpPeSum+EKBPBNW06EQQk3QgiO1cxzSxkQR8hI7vHoIwzQSM6eonbpQkG+Cur38Cx1bdHqM41EGcSOHSunOUO3exnp6QPMwZ+qZrU63IYd+nYKbWi58t5KyUZOlSWs8cm4uEztgRLPRydWSD96pD5TKPf+gJGDJwoIr3fNYGYXyTgKPsJ1nPQvZ51X7qCcpXtUMUCbtemSKRFTwDJnipzfPSx51/w3b+xbuZJTyW11Zehf7yTtxZnIEwYY69wp0ZkpAe3pNRMCHTzafHro5w0KvynOoplqbGxSYp5PGWDoHqu23QJ1OEhdYsZi07WPPJjJka0v+cFb+JnFV/IoJSqm13nSvppSpsIZmi6X7+TyzuNy8ll2pzacaoS+FTUfBVT1H3PzIcGp6ypyiJZ96eVw8PB87u/ZrwlxzqcMBWeyxK1IyfOV7O+4LzPJmvx+q36Zu3p3L5eOTPyQHS1Uc4ssChZFsJvqFKwk0puizi1dn3LRl+ZjHHHPH+fZ878EilGP8M+mmwV8L4noMb1TCzzs56gnwGWt8lqwtzSu4303lsb0jeRKdbFu38xsw1BYPEMXUPYClMRTcPRKmHCCFK/mJXTuDYvDK2/bu0OzOqmvYwXmXlF8YB4PtxGffFWML3zSwtIGbvp5Qv87fht7wdljcU1HddALAOTo59HQiLYsaQOOTfbdVGjZt47LrUtEqGLzw/APHXbj
 f7c8moE+
 BvVUv8jABlSnHMoskLpReC15ITuW+udXEQsSOsjomlha2UjTNGCMPkdVyR7vtlTHiwRq3
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Kernel will have to perform shadow stack operations on user shadow stack.
Like during signal delivery and sigreturn, shadow stack token must be
created and validated respectively. Thus shadow stack access for kernel
must be enabled.

In future when kernel shadow stacks are enabled for linux kernel, it must
be enabled as early as possible for better coverage and prevent imbalance
between regular stack and shadow stack. After `relocate_enable_mmu` has
been done, this is as early as possible it can enabled.

Reviewed-by: Zong Li <zong.li@sifive.com>
Signed-off-by: Deepak Gupta <debug@rivosinc.com>
---
 arch/riscv/kernel/asm-offsets.c |  6 ++++++
 arch/riscv/kernel/head.S        | 27 +++++++++++++++++++++++++++
 2 files changed, 33 insertions(+)

diff --git a/arch/riscv/kernel/asm-offsets.c b/arch/riscv/kernel/asm-offsets.c
index 8a2b2656cb2f..af827448a609 100644
--- a/arch/riscv/kernel/asm-offsets.c
+++ b/arch/riscv/kernel/asm-offsets.c
@@ -533,4 +533,10 @@ void asm_offsets(void)
 	DEFINE(FREGS_A6,	    offsetof(struct __arch_ftrace_regs, a6));
 	DEFINE(FREGS_A7,	    offsetof(struct __arch_ftrace_regs, a7));
 #endif
+#ifdef CONFIG_RISCV_SBI
+	DEFINE(SBI_EXT_FWFT, SBI_EXT_FWFT);
+	DEFINE(SBI_EXT_FWFT_SET, SBI_EXT_FWFT_SET);
+	DEFINE(SBI_FWFT_SHADOW_STACK, SBI_FWFT_SHADOW_STACK);
+	DEFINE(SBI_FWFT_SET_FLAG_LOCK, SBI_FWFT_SET_FLAG_LOCK);
+#endif
 }
diff --git a/arch/riscv/kernel/head.S b/arch/riscv/kernel/head.S
index bdf3352acf4c..9c99c5ad6fe8 100644
--- a/arch/riscv/kernel/head.S
+++ b/arch/riscv/kernel/head.S
@@ -15,6 +15,7 @@
 #include <asm/image.h>
 #include <asm/scs.h>
 #include <asm/xip_fixup.h>
+#include <asm/usercfi.h>
 #include "efi-header.S"
 
 __HEAD
@@ -170,6 +171,19 @@ secondary_start_sbi:
 	call relocate_enable_mmu
 #endif
 	call .Lsetup_trap_vector
+#if defined(CONFIG_RISCV_SBI) && defined(CONFIG_RISCV_USER_CFI)
+	li a7, SBI_EXT_FWFT
+	li a6, SBI_EXT_FWFT_SET
+	li a0, SBI_FWFT_SHADOW_STACK
+	li a1, 1 /* enable supervisor to access shadow stack access */
+	li a2, SBI_FWFT_SET_FLAG_LOCK
+	ecall
+	beqz a0, 1f
+	la a1, riscv_nousercfi
+	li a0, CMDLINE_DISABLE_RISCV_USERCFI_BCFI
+	REG_S a0, (a1)
+1:
+#endif
 	scs_load_current
 	call smp_callin
 #endif /* CONFIG_SMP */
@@ -330,6 +344,19 @@ SYM_CODE_START(_start_kernel)
 	la tp, init_task
 	la sp, init_thread_union + THREAD_SIZE
 	addi sp, sp, -PT_SIZE_ON_STACK
+#if defined(CONFIG_RISCV_SBI) && defined(CONFIG_RISCV_USER_CFI)
+	li a7, SBI_EXT_FWFT
+	li a6, SBI_EXT_FWFT_SET
+	li a0, SBI_FWFT_SHADOW_STACK
+	li a1, 1 /* enable supervisor to access shadow stack access */
+	li a2, SBI_FWFT_SET_FLAG_LOCK
+	ecall
+	beqz a0, 1f
+	la a1, riscv_nousercfi
+	li a0, CMDLINE_DISABLE_RISCV_USERCFI_BCFI
+	REG_S a0, (a1)
+1:
+#endif
 	scs_load_current
 
 #ifdef CONFIG_KASAN

-- 
2.43.0


