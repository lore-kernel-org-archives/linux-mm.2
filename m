Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0454CCD185
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 21:56:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD6898E00A7; Mon, 13 Oct 2025 17:56:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A87688E00A2; Mon, 13 Oct 2025 17:56:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8DC048E00A7; Mon, 13 Oct 2025 17:56:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6FEBC8E00A2
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 17:56:51 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 31D3C5A05D
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 21:56:51 +0000 (UTC)
X-FDA: 83994451422.27.CCF7AE3
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	by imf08.hostedemail.com (Postfix) with ESMTP id 1D41016000F
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 21:56:48 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=DRl5aZdE;
	dmarc=pass (policy=none) header.from=rivosinc.com;
	spf=pass (imf08.hostedemail.com: domain of debug@rivosinc.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=debug@rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760392609; a=rsa-sha256;
	cv=none;
	b=LXnfSz3hI4tAqy+Q4VGt/d6c7992Y5lNqm/4pPjfD5nfosYgAsND7BXP2UlctuRXSHwuQv
	G5KO5pmRGs3WbWLhctVNEBl7c7c1OgdmdSbio+Irx5jX/LLnR7wKQoTazERxPoB/CY5Z3a
	N+EQw97Qn3wmxHxZeG7B/ywmoklfN+8=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=DRl5aZdE;
	dmarc=pass (policy=none) header.from=rivosinc.com;
	spf=pass (imf08.hostedemail.com: domain of debug@rivosinc.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=debug@rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760392609;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bdNStz76VWOE6F3y+SVDIONwXTUEF86LLBNXBRlWzEc=;
	b=Y5T/Eh5wnT+z41mOMH84xv2UCZj95mq8Dx8gd6cryIKdaJD2Gvmf0e3a4Wvck49Ej2NwG+
	TEFgeUMpBVgO1XJ9DpSLNCU36UFWXLhspGI6KZr0Nq1XBoGnPW2DUTrTVEBTEAVTVaEP/7
	ZW7URaxhQ0KopBQERUcvBR2V6bIWUHs=
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-33082aed31dso4846106a91.3
        for <linux-mm@kvack.org>; Mon, 13 Oct 2025 14:56:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1760392608; x=1760997408; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bdNStz76VWOE6F3y+SVDIONwXTUEF86LLBNXBRlWzEc=;
        b=DRl5aZdExonnWKQJdbL5Q1UDq/DLTFOHwwWGK6oB5yZ8LhSp/gdt6LTZM7ZfZ80VPy
         /kaJzqd/KehYizkIfVzzHthDNYGwPjz/9cKzfCY2ls84Uh/XdbfuzynghyWPRNm3ugfS
         SRvu/xX07E3V/8+GbahhTtSqc97A4GfUxPp2zpfZf90zILJ8inMsy2cjuApy8Mo32ecF
         GdOxvhMOf4ala0YiTBiM+dr8tcMRfFtRkJRHe5MHa1LJzb7JUe5mnu1HzyYAuTz1os8N
         M5pUyeOJP0sC4T/ItAiYsBfhq+ZVjm0FzLyZyLq3dYSBPBoghEW271ia8hBPu5CRFKy2
         ajnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760392608; x=1760997408;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bdNStz76VWOE6F3y+SVDIONwXTUEF86LLBNXBRlWzEc=;
        b=tCpV6/Zto0UtB4cMxaYKnl/t6squLgzC/tSpqm3bSOmS52h+F9TWzDPMnRsDzVwMeI
         O6NGXivDPimm27/SXArsD256LULDvBlais8k0SukbbeF46yZGYmKoYjZhPFStX/yP++x
         PBIWFvZy+R3uP/bdsvtX8asibmTgNemYR7i2Y9Ycp2/t5Zxc2dHFS3RRPm4oGZVj5np9
         hJMwiBL1ic9Z3F2ue1LyCXXibKpb5UD3GZGgPkwg0UbwMpM225YDVr9mIodUgsThUcM9
         iX81DW1sQkmiXo51HbIss7xLRBd2mzZ53C0cpusjuR1tTsbLu/cAeITbvD035rBBZYyn
         TGPQ==
X-Forwarded-Encrypted: i=1; AJvYcCXigWs9jb3vAhuPB1+Az5/5QQWPh1qI5YXkkXdkSkb5Q2+zIWz9pji591bQUt6OaTT/aDXJonDMRQ==@kvack.org
X-Gm-Message-State: AOJu0Yx8mXOenFVc44ybaFyv4ILmTdwFi/I44km+rF01PVccPdM2TJRM
	wND8ij6g0BzWX11CgPPioMZkKr80rWc6u4sAAotoTwF50BLlHO+hXbzjkFXEYldrXw4=
X-Gm-Gg: ASbGncvVbi6VozMr6uVFwN9VMmMCAwQ5eYf6GuP9nw3yY598BjB/mun37mJ2FD9O88i
	DFRUzyCTFOjJ50DsJlPCg7ClozIPH9zmR3ZqefQN6XiMy5gHf3TbGfSM87CS6qHGjrkNmfDTMeq
	91ktl1LAQpEoRJpWkC73/geaQW3toUGKimqrrfFIA9kCEke64KKqndQY8JYgSxPpJbYi5TQk/Ur
	J8pXhRNoIGo7WQbg+tJwB++I74YgZTGn1GGl1dnGbw9+YH6sru+/NS6EY1BvA2AeGcKeKqBNaX+
	S0CZXmAksGlLc5TrzJhD8FYOngXJnUQFiq1VjxCfLI0IiE3UoxPRO0N5EFGcdfcpj1TGUve3RuD
	zcEnJ3uygtC/OxWOf6KnozH87InTiQ+15QPeBbF3tIXvbvj5Y5EkEQKc0/8hUyw==
X-Google-Smtp-Source: AGHT+IEpDqoontntF3sIrR5a3fhwgo8215k0m01p1A4l+Szf/Qfs7CCjIFRuTV7hnhhmb/2mstaCGw==
X-Received: by 2002:a17:90b:4d06:b0:32c:2cd:4d67 with SMTP id 98e67ed59e1d1-33b511188dcmr28426761a91.13.1760392607917;
        Mon, 13 Oct 2025 14:56:47 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-33b626bb49esm13143212a91.12.2025.10.13.14.56.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Oct 2025 14:56:47 -0700 (PDT)
From: Deepak Gupta <debug@rivosinc.com>
Date: Mon, 13 Oct 2025 14:56:14 -0700
Subject: [PATCH v20 22/28] riscv: enable kernel access to shadow stack
 memory via FWFT sbi call
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251013-v5_user_cfi_series-v20-22-b9de4be9912e@rivosinc.com>
References: <20251013-v5_user_cfi_series-v20-0-b9de4be9912e@rivosinc.com>
In-Reply-To: <20251013-v5_user_cfi_series-v20-0-b9de4be9912e@rivosinc.com>
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
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1D41016000F
X-Stat-Signature: 6jwgowh74ncfgkijra3ak5bx6fskka7z
X-HE-Tag: 1760392608-186998
X-HE-Meta: U2FsdGVkX18v7YJWpYQ0raZdxtzohYISr+K+gwT+vfLaFZgbBrcd66OrF8z4VI9GRFLKTDT7WpptdiJHWXH13jRm+/q/DJJALYk+Nz8CPOFxSe0Kd55oRsuX+RAvEa1DGI6kv6lbyVx0o5bnfyoQFbqLh7YM++aqf/Wcu8dRlb/rXNzndRfRWUVHj8Zm0PgbBSa4BkWzybA62/E30IX8nk/p6Ghu6gH57wavSLJog70DJiI2WiawpVoim30DHCcJdAASuwmYbhdSogtcM0ZkVuhYd+dFd3yvsWKaX91ciIglUwLUk/5beVGzrDUgNpdyTcJBPRcGgb6uZdajuVBAcE5nry9XRqNyKomVPPPQVz2ZYxsEB1xnBEci2POGZ+C1Lw5O9mIHAbwkTPrJqjecZ6rAlTliGj4IVUpIQAoZ7g0K2DX5LoRv4gOo5sanQEK0sXSt7CH5BAwgzjWMbqKScqY4c1lxaRZDVvNRbHf8a7o8RHnmbHtLj3LIff5sExx0JjNrP/U5vluj3qTYRYBlEqIT//i3XIzZol9IOHpavKl5+EG3MhWhpXKkryvLDiCjkPyjPPq3p/3RWCvfGOizByntmPN21qlNyxgFmAw5kdLOtcqNDsxEMD+ndQaNTY1YA73XgE2DeLlv54KagNqeG3o+UixPOgs4DYgqwKKVpQNsI5fkYCPvf6yWZ3m7o9LcNb54lKNXizdpGDVoq+PWQ5VDozlAMK5huMRkH9xOjW/xWC+r5FTzXO/TfxGT35qsgaH7k8OJwZHlBUn9jr3As/62BE4FhIIlrzjW/Bo5WJoVpP4RnRaOk/abiUbQh2Ud2UvIJCHnnmkFPMc/Z7mBCdrMQPQFGgiEjYYWh17EgN+kg+VEcvSruD4tkOm/ZoyTV+Irepcw2HM/MC4cr8UjbO8pZlB3Xzwvu7TZIf5laaxzbZhwdSm+3261OKZG3soDM5qCJMQY7QyTFj7pdpB
 zRc1dSw8
 kgMmaHeGAlPBVYWAqnES5+HElSu5B1vDWdtkcTSLXuG/783WcMVc4zYpaYIiOOzjjjfWrPKIdguHJi3npEHiY4WoVizkweVhcUXasmEoP9RUCt3G1orRO+/uOin5qSXffxtJyQ1rAkEdpBpp/cabPDEstevsWMmjWrkrDQHTWDd5qXfJBorl+x9beUPel7NvmvVh3gnbRxs+tu2DAfTwifshVFgXMNihuhiMZDZtWXB/HkjQsGI9hw9iCnknQlc4yJRjpY/Tj3ZzhbbchT5gm/0q4F5FEj03dhIwUYl+HQ2C/rJxNPW6TYRrj7nnkZKLKk9LzzwsljNFpKr2HkJzAr2BaSFcSY5MgzeNUXANcGv3xEsSR2E0kU9P5cgVY1IX15PtQSYc3sD6YYHy1sjLFX2P4dXjGOU/l/IsWFCpUZXmhz8CeoVw478DAvb50537KS0nqzMSZZGpOoC13UY4C75xW+TSO9reTWgVc
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


