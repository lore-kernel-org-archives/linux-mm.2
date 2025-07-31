Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9E32C87FD2
	for <linux-mm@archiver.kernel.org>; Thu, 31 Jul 2025 23:20:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 414BF6B00BA; Thu, 31 Jul 2025 19:20:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C5246B00BB; Thu, 31 Jul 2025 19:20:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 28D5C6B00BC; Thu, 31 Jul 2025 19:20:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 12D016B00BA
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 19:20:29 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DDFB21A0B63
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 23:20:28 +0000 (UTC)
X-FDA: 83726130936.04.F4F40C6
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	by imf12.hostedemail.com (Postfix) with ESMTP id EF1CE4000A
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 23:20:26 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=rivosinc-com.20230601.gappssmtp.com header.s=20230601 header.b="pb2w/9Cn";
	spf=pass (imf12.hostedemail.com: domain of debug@rivosinc.com designates 209.85.215.180 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754004027;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FCs/0Fatb6WpZ5Wu0/kqxIeaRjS6p6fggeAegEn66Xo=;
	b=ant+igpZV2Ssgdesa7RS/pcx1jPDFSS3008G3JhU4GRu2Lxo97mSz70mdf6sCZM+tHUkLu
	mjEPw1IdSvbKSALEUunIjhFZNvrblFAdIwwVhC7wEoFlAkXjlU5HK24sj2rvTrdpAazItP
	zu7Y131TwE3RbOfNtBtIMUx/N3c0iBQ=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=rivosinc-com.20230601.gappssmtp.com header.s=20230601 header.b="pb2w/9Cn";
	spf=pass (imf12.hostedemail.com: domain of debug@rivosinc.com designates 209.85.215.180 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754004027; a=rsa-sha256;
	cv=none;
	b=oUdJbrcBv2eUeszWytXrv/mMjVACzo2AlwZ34omWIAOwcCJQv77JfXAUPKb2fYtiuQLO1U
	ah1FruPQCq0xqujDR0vmS/EsAzLE04lJVkiTVwfbR6QXjGDiCJouKIkRCEiXG/6T7BZqN6
	VreUvK7ymknR9Dl/7JIFU1R6uEYfWE0=
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-b421b70f986so1319555a12.1
        for <linux-mm@kvack.org>; Thu, 31 Jul 2025 16:20:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1754004026; x=1754608826; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FCs/0Fatb6WpZ5Wu0/kqxIeaRjS6p6fggeAegEn66Xo=;
        b=pb2w/9CnVVYxGxkJxZlgOh6t8FfqnjIAZqo4hUZYXj8+Or3WjdeMtzj9LLrZoaTWxy
         cicaW+B3ZBxXlGT82muugVljPNcsC6Egrj+NTUsIye9EzTjb7FRg6/C4ubdz8LY3YZiH
         rJgD6a/M+uW2nKumNKCM0lN27UEFxU8yqDsjQxgsSjh3m477Jvcaf1eQVupgr9YweTVK
         bJvLcaQgo4jXcA9O02G2PpoxcI7qUidvPHHZzb3A9OMsxO44f7sHtkNcYch9fDeYFWPP
         gLRhHxr3U0prm5M5DlYgIbPtzKMpPAeyixSVjuEnxT7Z2xb0ZJCn9/hWtQKIo6C/ppur
         cByw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754004026; x=1754608826;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FCs/0Fatb6WpZ5Wu0/kqxIeaRjS6p6fggeAegEn66Xo=;
        b=JGIg1YagdqT+Uxc7whAb74HmT+S5WVph9jTDLht/+1Gj76NfvBiSwtOtxaBgigwBkY
         eBQKaT1ymSEx8RAex15wEqNOwZyUA/hH/UNh6bLO/h9r6nRTZeFNpilkg+Z9HgcajfdI
         L02pjogg9PCoDU9tjv++KjNHv0vxwMTTRpAJfPW/qKl5DfYBUGWqxFRQPjhqBt9wDZJg
         bZbV5MzseR0zPh9QCUq0hfTbodeavzRISrMNJ036RTA2kA5T0m6AIkBiVhCPt3s1AAzZ
         x4rB/rMNDJnFJ94oL1yRauyDrtU8S/hvwhyaelnvJ6T4PGHPHgkexMXibb1KuiEfnStH
         5KVA==
X-Forwarded-Encrypted: i=1; AJvYcCXoiJ8uAj4fWOxz3zN/r6IjY1RgjaEaiWLys3PkkyyAIHcB6YpqxOyZ1sxx1bzu3DCOGuinEWHYwQ==@kvack.org
X-Gm-Message-State: AOJu0YyKf/0+8i0EqPfo21JSnC2KtKCowZSEp+GHB0nIbdIA7gHpG9EF
	OwKpDOJYji6sQkRnsEGSsV3G/yrfndKIzQiOStYkqOCJZZjWYY9Dw7rhod1mvgIpyjo=
X-Gm-Gg: ASbGncuwrvd94yhcrBaX9Y7Mqb7uNCOQuB9FxTLLhEZEUDBBZk4m7HBBhjwaQX4nekh
	IcU7tqa5otpIkYyJgchBON9uSzBVoNYBnxoYZgFoL2yErwaZaMUyz99+1XOGnF84N6Xn0glQN72
	O5fsOPQ3sfIV+tsRrRHeCfhxLxbaRxFc81JoNQ4RRbCDEeyW2vp4P/m56R0pScU9phsrOhV0qae
	skEclYSzztvIYDrJOfmB3ozaPFJWSzXwm6XQstULtwdVHGCBqjWrT4rf3eNffJW2yMMTMjUUofl
	BsfGgWLVP+5l/KjbWCHKfPxv54GmZ+iKKpY/ml+HmB8tV1JOa+DlUTXoxdNspkJj33VFOxFAWA3
	VHbIh92m1OXpan34WbQsm7edGvPF4fQLZ
X-Google-Smtp-Source: AGHT+IETA2G7ZhjRbQN0xuROBq+0VqhH9fPK1orAROPzgEITxVXarVWrHD2QyQoEaE6LCbCpd2wuMQ==
X-Received: by 2002:a17:90b:3d06:b0:31f:335d:3424 with SMTP id 98e67ed59e1d1-31f5de6ba06mr14027297a91.27.1754004025799;
        Thu, 31 Jul 2025 16:20:25 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-31f63da8fcfsm5773085a91.7.2025.07.31.16.20.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Jul 2025 16:20:25 -0700 (PDT)
From: Deepak Gupta <debug@rivosinc.com>
Date: Thu, 31 Jul 2025 16:19:32 -0700
Subject: [PATCH v19 22/27] riscv: enable kernel access to shadow stack
 memory via FWFT sbi call
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250731-v5_user_cfi_series-v19-22-09b468d7beab@rivosinc.com>
References: <20250731-v5_user_cfi_series-v19-0-09b468d7beab@rivosinc.com>
In-Reply-To: <20250731-v5_user_cfi_series-v19-0-09b468d7beab@rivosinc.com>
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
X-Stat-Signature: xtnd33ghig9qbf8xwxjp6i4x1do7rtxb
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: EF1CE4000A
X-Rspam-User: 
X-HE-Tag: 1754004026-940711
X-HE-Meta: U2FsdGVkX18XqXAOZgWz5ULClrbzMyEFfJyclvHj9T1GNZ66/1l+D8R1tudeJPl4VRHbqwHVQmYRZCqiUpR6X1slAuYUkHRy9WnRWMTrRzSDTJTNUPCH3x5hiCgDRQ1XbONEQV5CtXw4mXJ/q7usAlnYe10oFy6bqLt+HtQY97ZPtk90xCkyDU7CqVyjKyUlCzm11Z3YAXZtv1bZIcreiHHN/236JXAooIr0hueO3QhhqsI+iBLTanA6d/pApkJUlvlPmNEFmzYNhFx1oikdRPd8pqNYxPnhMbDTEUNL70WbcPEmOeSD7X7HeZuL8ABLdVa6T1iKLiZf7v+4qq34OJapWifLkEGDLfihjqueooVSdjc8gZuSUIOFn4QClSQ+S4cM5gv25goq52EqdyoKl5hF/Ri/fmI3qVU6rGbjns2+II0vu5s/GDXDWPgwVzh4hmA7Kj918YOlTr5912imWFTWwh5oM1lvqTEvADXiotSq2NP7Kq06lZteJgDgRYhfhbWlurgO5QOBuFkSJpr6Zq845vcb7cwWPron2KP6AgeGVoqM+dykfkwHH6rvU2CGcTTiXISi5DViXxsewEI4xr0hZl2rDWC90CiDqGOnLYhPFFxIIlbsfimGx+J6Y/xbFesnsEuLmHpLDc/vHtUR5uqFONluiYwWGrmjxKyjRpUvbBh6cZhEBpjEyPdH0gwNo/1/RzeTHa8ywtXEXd+npTGqq1QpLQLrYTHAiD9EE4iTd3yKJfPTZu+JfM1v09VXE0BwgpaQrop5xtyDVbkgo1Haef0Hspck37AYJFGiKI+izQn+f8mhAObGgPsiIghOi3rPP6P9Giv2Lo9N5y+gl93zhsbCG16XcBU1skfgEryK4DeOSj850H61GbL8MX53kY0dE5JY0FVXJLkvMoREHXm1q2+vvTocqfMlSBnFzX/6H5sWpMIRQ90Ws7D1+Alz07Cu03isn0Zhzekt30p
 OT/LWvm/
 aGPFofoEvbDZBS9L00vbz1LoXGPCz/Tphpt4DTrgZrF1VIBiRnCCTSpoAIefvcM5jnhZqoj/nTNAZMH5H0y07WoDkHN43k874J++dcYLE2kI3NnKzSt0rzZojAxFQZ2K2uS3kS6ZZnESanm1rVV+aPnRLUmgMTkOZAmgcG8WSYhn8pC3h6p99aNLVInu4y7WjX9N5ZmzHILO6l4sft+h9gmlRjXHN/Y+XFtgVpGN3vDBC/IHLp0CS/XjLvlCvnNl0Ic+MPltM71H5wmdU9mXU+h6bQF+UPUpf7IrKtDXIgYQqUD+2ljmbY1qElThKS6J9EPHajP7eQ+SSDGacE1m7j2Aiw6dBAakDC9drDs1+vK8/N3d/C0B8k304XmyA5m8d+U5g1zwBn1NkUqls4DMWTUmsWUJGIGOQtX4beBKUKdCSTMlbJWO7Mqh1q9pCJbO8SqrLExbNF0fWZ5J54fz3m4UddbutYYvPMbuISqOt75efi2g23dYSFNRmlFhcUW8df28C4CwFXoLkZYfXOybKGMXnLUJQs01fH+nRzTNp+RWkKnfwejsa3jqwTA==
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
index 9bd6c3e868c9..e4d55126dc3e 100644
--- a/arch/riscv/kernel/asm-offsets.c
+++ b/arch/riscv/kernel/asm-offsets.c
@@ -532,4 +532,10 @@ void asm_offsets(void)
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


