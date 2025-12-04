Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D28AD2A520
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 20:04:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E22A66B0028; Thu,  4 Dec 2025 15:04:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DCCFB6B00D2; Thu,  4 Dec 2025 15:04:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C94716B00D3; Thu,  4 Dec 2025 15:04:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B38B66B0028
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 15:04:32 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6F416160397
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 20:04:32 +0000 (UTC)
X-FDA: 84182865984.23.EED7C2E
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	by imf04.hostedemail.com (Postfix) with ESMTP id 609AD40014
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 20:04:30 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=bG8rRGeu;
	spf=pass (imf04.hostedemail.com: domain of debug@rivosinc.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764878670;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qkB1OBwYWJndx0ys60aTo8BN+99UJkZg6h3GpJG4ezg=;
	b=eSAViVdno5UpYxejU0jHvp2PbVLDWwfCZwXJiKgd/c8/AwC49mEnBF8M9h5BHh98iOpsLZ
	xcGIFoR1PbhLJxypnjHruvRTxT3LqzKseLRjpYOX+vfqS63Gzuyb5ku/6u546HF72tPeF6
	j7W7Kth1scxn0XnqZCtPMdxvR53dQ9M=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764878670; a=rsa-sha256;
	cv=none;
	b=SbdB5DTJR+2Fv+33bOvuDtrWqej/qPK25GTm5yJhxcC5Uxyxx0fqG/J8CPZPQMA/aJHxVx
	i7xsLhliq3rGGQ36MFjt7R4HuQ97RYHulDw5FAsjB8WufcOPWKn6RhES10srhGsWm2tr7S
	0//huN/o/sFyG6JbSlK295zitV+hmxs=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=bG8rRGeu;
	spf=pass (imf04.hostedemail.com: domain of debug@rivosinc.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-29555b384acso14022395ad.1
        for <linux-mm@kvack.org>; Thu, 04 Dec 2025 12:04:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1764878669; x=1765483469; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qkB1OBwYWJndx0ys60aTo8BN+99UJkZg6h3GpJG4ezg=;
        b=bG8rRGeuC2f8ZyVUwysqa3aA0D/v9k5cOZTK4bXXGrQrwxkmJY9beIHEnCfTOHMYXc
         1sLOzC3kJf4tGZVD8MQJj9jdeqYAsKiU5YlBYCatPwxAmHSv5Rt7u40nt+xHxveddN51
         mBK84NLuzmuVCLrZnXfW/FJ9gml7FoA4g0+wuGnuZusgfM07TdLs7dncbTGoVAych46V
         mgBDxAqogzJOxyOnxFCjIY2HESLaMFUMOxHqb+QfLyz+dUNl05ZiK1dJgRUHw1L6yOGD
         PqzeUhWk68eBVpkiBCiMJdjvornhqVfBlHRUIcwZoGzhkvW+R1FMnsJQMMDqGFMIszDK
         Vm+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764878669; x=1765483469;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=qkB1OBwYWJndx0ys60aTo8BN+99UJkZg6h3GpJG4ezg=;
        b=FKeacNPb9Z73isrkyiWCVrSa8hF0N9iItyqlt9q7mRGy2dudgXpiZdRmDIm3JukcpA
         2pl/gICEtXS6B1uSCPo6UfbRBdSGwQ06b6pqHr6QG16nBNnXtokEsxV/ppcavH1FKxXm
         zObr79PROs5703ge22fPRO36/E+jqzDawKMVFfOeWNykVTaQZT+xvx9QFuDzdpRNejB6
         ElmLmIiZs6xrr4145pa2JfGRo+b+9r6QG0bdbomn6lvHuL6qO6q1f3eNHnCEnEIWy2Yz
         +0Cs4rqAZcFkFAtgA1crYMbt4ICiY0qIADDzoCbTbjmoUfLxje1EEvesi3QkEX5PZYuE
         rIZw==
X-Forwarded-Encrypted: i=1; AJvYcCWEWkdjl2OJueH3dxE5BzmgkF8srElv47yrQVWRa8fux0bg+hmjEIsmnmzg3ce9UB7i5sfXk54GHw==@kvack.org
X-Gm-Message-State: AOJu0YxAv61wxNwqG+Uar+n0UhKxtwRNZz7kFSna0JvWgpThWCORXNf2
	P+Pp4y2LYG5y9LltqwFcA90xO5aBYrjx1njK7u4ldlGMxG28VYCsb44CqB9ek1e014c=
X-Gm-Gg: ASbGncs1VqDEcCsPdr2jZEPl/mJk40utdpCeCbtnxtQUGHLZyEL9l2lBZevWV1tb+/u
	k+Tk85lsF7+0JP3WgbamxJ1q5GebxGOaQthBFLfuIfOc+Bwvg2hM0IyBzKuKolDf5S5q/8Bq5KW
	XSXpkVwLCh1B+AdUOKByt+ideSTXZ/jGLN0WN8jW8Gs+dpYb5HMGhgYDbaug0UA2qBFsT3ntCHE
	+fH85EImJxq8ICoQ0aDY6KmrPZfBBtOgxxZbFCKBnyrgVOjGBOrA6Gw8NzUtM97uAPAW82c5TFG
	TDjcIMUUmyxPb8x9gDM0pM/+u7RIqU9AbI3tdqWixG6kmaQ5EBCtNrz7sRi8ydtfeeVg6NY5D3k
	yizCnFItBd14cwD8zbOpWcpHlQFyRMQlrQLE3zJvESLHpRMCBHnxF4Ju+JQD9PFrE+kZkz3F+u2
	MTqVg+ShTCY2oGx9MPxL9q
X-Google-Smtp-Source: AGHT+IHPx7V3oyF9894ZTzaeXu1IYdL7MnhPw9p6Pze6D3DEKLTqry4qdsiaQ056IInDpLwSf3YZtg==
X-Received: by 2002:a05:7022:101:b0:11b:9386:825b with SMTP id a92af1059eb24-11df0c4a9aemr5955049c88.48.1764878668954;
        Thu, 04 Dec 2025 12:04:28 -0800 (PST)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11df76e2eefsm10417454c88.6.2025.12.04.12.04.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Dec 2025 12:04:28 -0800 (PST)
From: Deepak Gupta <debug@rivosinc.com>
Date: Thu, 04 Dec 2025 12:04:04 -0800
Subject: [PATCH v24 15/28] riscv/traps: Introduce software check exception
 and uprobe handling
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251204-v5_user_cfi_series-v24-15-ada7a3ba14dc@rivosinc.com>
References: <20251204-v5_user_cfi_series-v24-0-ada7a3ba14dc@rivosinc.com>
In-Reply-To: <20251204-v5_user_cfi_series-v24-0-ada7a3ba14dc@rivosinc.com>
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
 Zong Li <zong.li@sifive.com>, 
 Andreas Korb <andreas.korb@aisec.fraunhofer.de>, 
 Valentin Haudiquet <valentin.haudiquet@canonical.com>, 
 Deepak Gupta <debug@rivosinc.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1764878636; l=5652;
 i=debug@rivosinc.com; s=20251023; h=from:subject:message-id;
 bh=TXKZlJ3jSYM/MfSFEFzUAEcoqyLgBWawjPARhtXC+wc=;
 b=2MdUL9dDxsTYXvbWgWD4UKRZ4Xhy/CtmCZPNxXxp0jork024MsfpZe5j9KF0iAs6+4kwtmUOS
 tqefTpptf2vC2VK12ioYc8+5z27ZylQ31H0jQa1yY0ol5K5E3amAUs0
X-Developer-Key: i=debug@rivosinc.com; a=ed25519;
 pk=O37GQv1thBhZToXyQKdecPDhtWVbEDRQ0RIndijvpjk=
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 609AD40014
X-Stat-Signature: ymgkoji8ud8cyy8oq7zzyadhstamxdo1
X-HE-Tag: 1764878670-136696
X-HE-Meta: U2FsdGVkX1/IIKxhjmYvJIhohNTwlpU5k0F3+k3SRmuomWluNBhCdLBterFWXXfkWE08H+F971pfTz4CjWo8HIJJnXkPykSEAc9r7wYJ0zWdB/HnTlWZO15SZ/nfJ9Lh9AKrv5vBAGW1OmYg2F5dsQvKUeRyQlSHvfKaZwBRTfOisThrGLn2YHxNWVBZBbtQpwYf0IeJUkcDbL7oBgmrzqXA7U4RpsvzGn3hoAzjGVPthklYZqxuxAzMUkbjKUd6eQ5viY0JcdNpYvRpwuox1F/Cq18XSGRIaFs5BUGER3wPiRFq21UiLp1CQfUCng1bEACfnfl5MycLum+N68OLM1LYWs2ppGUwyNgZyw6MW2MdCzZH33zyfSVO9tqeShsYthOEV9gII8b+Lzi2a0Xnu06ekb7W0CYZrC6Xe6iiFiK0ZqBF57TURH8iypHFI0Nj0FTUYjM8A6GMiFuhXN7pe+K5emGPJvZxt6lTfw90NKw2WsT6ZNqWE+ScLeZkuGXPWGtWOUPwgd7nlpQv5M8g3Kq4Y8eK+JU2HRp2YtR5k0idnGrJnHWrXHjqa+2JmPb9krfpioJ9ZM4BS0cGDb46lKdLGhEqz0290G/yrNdNd+A79A0D8myJTuJ0IYvIy4syThEoEe8x+bgsrDlIgL2uEZXLOBU91irJyiZj8/3L+uVFTkG3W+7QUSeM6F1i9bg0SSiMfF3Ch1w0+KGdJrrRLbDpWfuiqOHYvY9OBImsG2gIuuGEtqs/BNAP76H6klsqageaaBUZXBT4jugDz4Ms9eD0cwqJFXA8mc77DMR1ni3NOaAs5gVW/XNsyGLAv3Qgw3Fya5oGKK0/Rcmev9z645gl9bAIEovPb0UtyBB5nmhORgeANNOsOvyJWhM6vA0IuoGPn/D+pgvaEyfm1NiZ3LRc7CQK2cFtKr4vnqZPrOUY7LrtflcTUgrpP43yLIOdE9YrkUWYRYpVAEK5bEw
 ZJnp8PfQ
 Bf8RiEMTLfcjyeoYbS9g01Ec55u2DZ4FA3SWP3MwvEGEY4ZZZBQ9l+DiVacSeMrBOtZ8axL1KNUclQxgIpOKlvqtdvZWVB/j533BGXYlxNO2HDooE1YTSElrYv/tB/hPQQjHGTmYYXv2Cs2oLKfTjJGquDeIUiXAlhEhnqeFYe0aq7SvHkswehZpBeu8nLkhRMF3Sp0o2lcY/cI827KvYLNPfk3CDOkwQkum/E9mVysD2kXHyOauZdlvmo1+Qp81JakZqFqWhUsmPXzzD+PdQ91A3S/MujyZhBI097h/zhPDSBWzejngY+Q8S8Gul0Af5ko9B1PjIY7usvVvafq5SlGTJf9aO9f675Pl1FYbnvxB4TdYjHW11be26/KctktX+NaWJtro7hBNgvZ/SE4WH9Nbhv1z6CAXEtl4Jm1RGn2+Q2ixjt7+S60NgoZz6G5q+6a9aF6FTybdJshPBRoGM0CYuIiSfWAmo3kcZIa93p5DsgF/BmZz7mJermxiBR5GEw8I1RBODhlZHkZU192iQcEg349TvvCHauet3
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

zicfiss / zicfilp introduces a new exception to priv isa `software check
exception` with cause code = 18. This patch implements software check
exception.

Additionally it implements a cfi violation handler which checks for code
in xtval. If xtval=2, it means that sw check exception happened because of
an indirect branch not landing on 4 byte aligned PC or not landing on
`lpad` instruction or label value embedded in `lpad` not matching label
value setup in `x7`. If xtval=3, it means that sw check exception happened
because of mismatch between link register (x1 or x5) and top of shadow
stack (on execution of `sspopchk`).

In case of cfi violation, SIGSEGV is raised with code=SEGV_CPERR.
SEGV_CPERR was introduced by x86 shadow stack patches.

To keep uprobes working, handle the uprobe event first before reporting
the CFI violation in software-check exception handler. Because when the
landing pad is activated, if the uprobe point is set at the lpad
instruction at the beginning of a function, the system triggers a software
-check exception instead of an ebreak exception due to the exception
priority, then uprobe can't work successfully.

Co-developed-by: Zong Li <zong.li@sifive.com>
Reviewed-by: Zong Li <zong.li@sifive.com>
Signed-off-by: Zong Li <zong.li@sifive.com>
Tested-by: Andreas Korb <andreas.korb@aisec.fraunhofer.de>
Tested-by: Valentin Haudiquet <valentin.haudiquet@canonical.com>
Signed-off-by: Deepak Gupta <debug@rivosinc.com>
---
 arch/riscv/include/asm/asm-prototypes.h |  1 +
 arch/riscv/include/asm/entry-common.h   |  2 ++
 arch/riscv/kernel/entry.S               |  3 ++
 arch/riscv/kernel/traps.c               | 54 +++++++++++++++++++++++++++++++++
 4 files changed, 60 insertions(+)

diff --git a/arch/riscv/include/asm/asm-prototypes.h b/arch/riscv/include/asm/asm-prototypes.h
index a9988bf21ec8..41ec5cdec367 100644
--- a/arch/riscv/include/asm/asm-prototypes.h
+++ b/arch/riscv/include/asm/asm-prototypes.h
@@ -51,6 +51,7 @@ DECLARE_DO_ERROR_INFO(do_trap_ecall_u);
 DECLARE_DO_ERROR_INFO(do_trap_ecall_s);
 DECLARE_DO_ERROR_INFO(do_trap_ecall_m);
 DECLARE_DO_ERROR_INFO(do_trap_break);
+DECLARE_DO_ERROR_INFO(do_trap_software_check);
 
 asmlinkage void ret_from_fork_kernel(void *fn_arg, int (*fn)(void *), struct pt_regs *regs);
 asmlinkage void ret_from_fork_user(struct pt_regs *regs);
diff --git a/arch/riscv/include/asm/entry-common.h b/arch/riscv/include/asm/entry-common.h
index b28ccc6cdeea..34ed149af5d1 100644
--- a/arch/riscv/include/asm/entry-common.h
+++ b/arch/riscv/include/asm/entry-common.h
@@ -40,4 +40,6 @@ static inline int handle_misaligned_store(struct pt_regs *regs)
 }
 #endif
 
+bool handle_user_cfi_violation(struct pt_regs *regs);
+
 #endif /* _ASM_RISCV_ENTRY_COMMON_H */
diff --git a/arch/riscv/kernel/entry.S b/arch/riscv/kernel/entry.S
index 036a6ca7641f..53c5aa0b6a16 100644
--- a/arch/riscv/kernel/entry.S
+++ b/arch/riscv/kernel/entry.S
@@ -495,6 +495,9 @@ SYM_DATA_START_LOCAL(excp_vect_table)
 	RISCV_PTR do_page_fault   /* load page fault */
 	RISCV_PTR do_trap_unknown
 	RISCV_PTR do_page_fault   /* store page fault */
+	RISCV_PTR do_trap_unknown /* cause=16 */
+	RISCV_PTR do_trap_unknown /* cause=17 */
+	RISCV_PTR do_trap_software_check /* cause=18 is sw check exception */
 SYM_DATA_END_LABEL(excp_vect_table, SYM_L_LOCAL, excp_vect_table_end)
 
 #ifndef CONFIG_MMU
diff --git a/arch/riscv/kernel/traps.c b/arch/riscv/kernel/traps.c
index 80230de167de..d939a8dbdb15 100644
--- a/arch/riscv/kernel/traps.c
+++ b/arch/riscv/kernel/traps.c
@@ -366,6 +366,60 @@ void do_trap_ecall_u(struct pt_regs *regs)
 
 }
 
+#define CFI_TVAL_FCFI_CODE	2
+#define CFI_TVAL_BCFI_CODE	3
+/* handle cfi violations */
+bool handle_user_cfi_violation(struct pt_regs *regs)
+{
+	unsigned long tval = csr_read(CSR_TVAL);
+	bool is_fcfi = (tval == CFI_TVAL_FCFI_CODE && cpu_supports_indirect_br_lp_instr());
+	bool is_bcfi = (tval == CFI_TVAL_BCFI_CODE && cpu_supports_shadow_stack());
+
+	/*
+	 * Handle uprobe event first. The probe point can be a valid target
+	 * of indirect jumps or calls, in this case, forward cfi violation
+	 * will be triggered instead of breakpoint exception. Clear ELP flag
+	 * on sstatus image as well to avoid recurring fault.
+	 */
+	if (is_fcfi && probe_breakpoint_handler(regs)) {
+		regs->status &= ~SR_ELP;
+		return true;
+	}
+
+	if (is_fcfi || is_bcfi) {
+		do_trap_error(regs, SIGSEGV, SEGV_CPERR, regs->epc,
+			      "Oops - control flow violation");
+		return true;
+	}
+
+	return false;
+}
+
+/*
+ * software check exception is defined with risc-v cfi spec. Software check
+ * exception is raised when:-
+ * a) An indirect branch doesn't land on 4 byte aligned PC or `lpad`
+ *    instruction or `label` value programmed in `lpad` instr doesn't
+ *    match with value setup in `x7`. reported code in `xtval` is 2.
+ * b) `sspopchk` instruction finds a mismatch between top of shadow stack (ssp)
+ *    and x1/x5. reported code in `xtval` is 3.
+ */
+asmlinkage __visible __trap_section void do_trap_software_check(struct pt_regs *regs)
+{
+	if (user_mode(regs)) {
+		irqentry_enter_from_user_mode(regs);
+
+		/* not a cfi violation, then merge into flow of unknown trap handler */
+		if (!handle_user_cfi_violation(regs))
+			do_trap_unknown(regs);
+
+		irqentry_exit_to_user_mode(regs);
+	} else {
+		/* sw check exception coming from kernel is a bug in kernel */
+		die(regs, "Kernel BUG");
+	}
+}
+
 #ifdef CONFIG_MMU
 asmlinkage __visible noinstr void do_page_fault(struct pt_regs *regs)
 {

-- 
2.45.0


