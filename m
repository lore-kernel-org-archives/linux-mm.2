Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23090CCD1A2
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 20:54:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 59BF48E0028; Mon, 20 Oct 2025 16:54:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 54A028E000E; Mon, 20 Oct 2025 16:54:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 39EFE8E0028; Mon, 20 Oct 2025 16:54:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 21A988E000E
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 16:54:03 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DB5CA1DF5AD
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 20:54:02 +0000 (UTC)
X-FDA: 84019694724.09.4066E5A
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	by imf07.hostedemail.com (Postfix) with ESMTP id DD4A24000B
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 20:54:00 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=AFP0mKcq;
	spf=pass (imf07.hostedemail.com: domain of debug@rivosinc.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760993640;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RVfqSsruJ2MSGFolr4q1FtvvuePYAHYekfV2rCXHQ4o=;
	b=2EsH3oIKf0d8gvgs3f1Xk4kp0169caO2KSjK4emjGzKnJu/yDvloh+Tq8BxPINd9azMf+G
	9MXcREJFqhHESaVi5NOT8FO6XiXmZ2M1JatL/x883Vv//L3BjkO3YSFBskfIJOs1BaDzgB
	EzMvS/4ti6vF2/ByQh3OnOunsPI0Yh8=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=AFP0mKcq;
	spf=pass (imf07.hostedemail.com: domain of debug@rivosinc.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760993641; a=rsa-sha256;
	cv=none;
	b=tRPzxKy59hjS2tx4d0Mw/KC3+uBgfIY80cNqAZr5IbRsV2U/Ux98EoSBHNL8unolbHaDCa
	EcwfG5Ewh8GysDl6DYiEkVUPVHkONxlNr1OzzVBy9YegPe7T63/6Ja3x1+r80rl0wlWzUr
	9eRUKUXqaRU+GaCjAfF3mDbPY21fWNk=
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-781ea2cee3fso4288480b3a.0
        for <linux-mm@kvack.org>; Mon, 20 Oct 2025 13:54:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1760993640; x=1761598440; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RVfqSsruJ2MSGFolr4q1FtvvuePYAHYekfV2rCXHQ4o=;
        b=AFP0mKcqKyAJx4GPAyNbR0FJoFsNUDpwHYZ11FMBvK4RWeQjh3KlKSuXBvDeQX27AC
         H3W9sP1jk3L2snW/f9UFBWumXJDwdXGYunn8bIVYz2M1f+pmqzygajeJgkCAuR87iSpT
         EQFRF9eOQQBEubv3xsksFaGY7U/MHtfCNcl8KEsfe+0pDpjfTxpAqgjOg6PV4ZqktjzT
         ORE1xlmR1iiIiVk5Y2tN73kSDq5KCbFjQKVPTkSNOKMS4g41tikwBEtJt0shonZAA/uf
         dfr5V/GgK4dVSJHxNin7Vhlmdg2ga8Z/J5LvBSeKPMHQF6gX42p6s5hjMplER+cxb3DL
         pmHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760993640; x=1761598440;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RVfqSsruJ2MSGFolr4q1FtvvuePYAHYekfV2rCXHQ4o=;
        b=n6nd/GervmDPwC0FYP66mnDtEMYeGQrXVfQQTdiNAjTAoSmJhj44sf87o7yuIq9a/E
         V6Wo+IFY/UiE4xNZu4OcBsNeW0xtXAbIMmbZ1bgxaE/wsVSFwkz27ufuUR5A6q/i3tUb
         84cuXL3Mf1DDMOXiGcoYVYblwFEoWEcEMdgqJ+MKGHbVA5PZZMiGW6gyMOA8LhMVESIL
         WnGq0W+JybalHCqevwLiVGt4AmGIKsI/uEhZQtaqAmLfN4KmA8H4cBzgfRrmN/lAEFn2
         KVF9oSvLY4AgkiTcT19L7G+J12ZNEOKgQ6a+1WWHdhXymWgekkClXA2c8mCZCjE2pylt
         vDNQ==
X-Forwarded-Encrypted: i=1; AJvYcCVToUoOHf68kIeT2Z8PBvWx4cq8w9MADvVkMzlF5HwV0xa7fF8MgnyBI3zfYzxg66th3irk14gmuw==@kvack.org
X-Gm-Message-State: AOJu0YwPvnCoAWYtE13PROhjBZEXQPLiU9fUnKvx9go9ovh2TAQOdLoU
	e4TmZjxZRsY1ySm6E9NVp+qZ8ocCsi58sl+0ly3PIo8DO6pKTGFXmA5TFvoEGKfzA3Q=
X-Gm-Gg: ASbGncuneBxb4oiJzuZXO4liIHypuIZZMYI5XLA4237JlvDr3quPKfFXk3wdrJ219AR
	9/86nlImSJOlGo1AklQOtpeDarnRy5EsSBYY3Qhn/o/dJAtAYcXjDcbG/F4A7f+Wq+vEaAAS46A
	bCnbmekU5b1i+gxVrbeR9Fy4fAMxbm+4sXnDpdbzYcKZbhNfcP7R90tmoctdqgNNbvxJ5zVGmCw
	0y5lPBZYak1WtHldNoNIWavdYf1zLKuWz1XpRRplBi2ZgyzRfWRPMT4q7ITaV0fOkXNxI+g+SOC
	Va3mho1u/S0Lluzv5IAvi9eLpjlK49HJYVrQNdkQa7vDUBr1fh72uL1ScRr8MHsygSgxT4XJF/W
	MIvgWV2tVAtkIsPG0B+zGtrIGLFVyJu/Nq8+SZCLNqipV3jLqTskiXvvI/vC4+Cjb/V0qCTLg6d
	+Nsxv2a5geSdv9YcSI7/iN
X-Google-Smtp-Source: AGHT+IEqxHM5HsYYZFifBsCKZW7lfB37wmX6SS52cIA5bTxj0uBkT7i3YMICKEyyHIpsXCMRf1pqOA==
X-Received: by 2002:a05:6a20:1591:b0:334:a681:389c with SMTP id adf61e73a8af0-334a8531bb5mr20216613637.15.1760993639353;
        Mon, 20 Oct 2025 13:53:59 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7a22ff1591dsm9453867b3a.7.2025.10.20.13.53.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Oct 2025 13:53:58 -0700 (PDT)
From: Deepak Gupta <debug@rivosinc.com>
Date: Mon, 20 Oct 2025 13:53:40 -0700
Subject: [PATCH v22 11/28] riscv/shstk: If needed allocate a new shadow
 stack on clone
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251020-v5_user_cfi_series-v22-11-9ae5510d1c6f@rivosinc.com>
References: <20251020-v5_user_cfi_series-v22-0-9ae5510d1c6f@rivosinc.com>
In-Reply-To: <20251020-v5_user_cfi_series-v22-0-9ae5510d1c6f@rivosinc.com>
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
X-Stat-Signature: onf98fdi79jmrixsdg9g8gmmunwdhjoi
X-Rspamd-Queue-Id: DD4A24000B
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1760993640-64346
X-HE-Meta: U2FsdGVkX1/u2cIi9BaQAYcyyfOwvt7Bs01b6WSRwFdAZDp76pmFQ9aBcfXKzoYFb6HUBFmmzsRp91k1LZdYlqECsm0+5weOzKEQWNvvPeaIXRmCSylXBoIJ7Gdg9j7H9GBoF3w/MlHkf00LxdhlzcBL0K7Utr1tWBo7SPaoS7HMhQjseKZn/FMJvS8yN9M0+ffzPPGah6SAJhL53fPhxkM/lekvd0fj4JDalgjm2px7sfV1Gm26023oewhR39JD8rU0HycF0nwGUhUZn0Qd44WNGtg5dKi4AGODASQjB42AhECYjYpfV6EWx2N+e39fWiiSHydzYZwg7kEKImdXjjuJ75qByQ5Mem58YIkUA4OhemJmFZd3ebCpVro8LxLhIzLgIrscjFOh27iRWaHOkT9KPTFIJmz2aXykbuQL0GsDnyS71Jy2I1fH+J7lpVkRK6aHw78gyfYTugU2TGScLDOlwExL4Jv7YR8vLj1kNI2XrXvuWoyMnUxvM2GQAYrDivMmuzNhQJanfuroYRmux6oi62M9cjTk7hckCWtNzlFbOiEVtD6XYRYZ1JJl4sYqzeoJLC25bWZ4TpJ6fwnLi69HMz/uZ2dkA+Nf6waCtzJ5TKV6DfMXxLrSw9mEkS0gI1ICUosXbjkSQWkAQrej+l/eowEF5FK1r+7w/zD8PoCL1j3neJMmv/4+70kkMzqfRmsaZ1Jk0OsFCCbJ25vOJWrzJRlESL+k2z/GeEQ0BD/zPlQwrPPxNcX56C0Jf143n/q2jTyqeCmeuakpyO74Y1j9x0qxEFkzyoH/r76yQ6xgDFyEfcK/P6R2SsT0Miam/+9B8NDtsIdFbWdeoan2PbkPipt/Uib+wpI5G55UCyg/S39cVQwZ4U2Xgmhw/40SjKj81zVZFRr17rLIzHqjZzd3hnyXNffng4V0GNN51Szj5T7WyhkaxMEL+o6fgWkC+BlCzL6llYKAhi57kVF
 ursqvP/P
 K7GtnSmFHnbRbydFAuPVN8dFTpmKDqri6Q2LWYRnPMZE45msk9v1dr+2GmVV07OhQbbS0oJ6QhP/X7rJ63w4KpkVRQoNVuyDHbdJf7K4lig1m5gDVXYDDoJpKLWtFqwKAMi9PzwatFpxmAVfJfqy7+qRcNrg6oJMQz6nXKb1dhGWUuP1sBQ5E0qugp6j0jdI4AKqhpqduleao+/E3RPvN3C01lBWPqCabh1IUrp24ZONU888K4rZU36clzVtRmoWfUinoSMRWACH/Jf4AnlzfS6bTXUjygMWyFEnzPmRq79Z2D2B0aK7f1W+6UZwA3+/V/K3US6B2E//hadJQs/Cdi9dCtDT71lmAidPQ4kgOriAepGJ0HIb4gLi2Q1F7Yja68dR2KtjwVkg9+g65yUBmQs4x01gC4j712vWi/in77sBja1DIES0qfHO2rOQSXUC9MjSTPRiol3OTCX7yLppgZIEZXCQYH3BM/2Ko
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Userspace specifies CLONE_VM to share address space and spawn new thread.
`clone` allow userspace to specify a new stack for new thread. However
there is no way to specify new shadow stack base address without changing
API. This patch allocates a new shadow stack whenever CLONE_VM is given.

In case of CLONE_VFORK, parent is suspended until child finishes and thus
can child use parent shadow stack. In case of !CLONE_VM, COW kicks in
because entire address space is copied from parent to child.

`clone3` is extensible and can provide mechanisms using which shadow stack
as an input parameter can be provided. This is not settled yet and being
extensively discussed on mailing list. Once that's settled, this commit
will adapt to that.

Reviewed-by: Zong Li <zong.li@sifive.com>
Signed-off-by: Deepak Gupta <debug@rivosinc.com>
---
 arch/riscv/include/asm/mmu_context.h |   7 ++
 arch/riscv/include/asm/usercfi.h     |  25 ++++++++
 arch/riscv/kernel/process.c          |  10 +++
 arch/riscv/kernel/usercfi.c          | 120 +++++++++++++++++++++++++++++++++++
 4 files changed, 162 insertions(+)

diff --git a/arch/riscv/include/asm/mmu_context.h b/arch/riscv/include/asm/mmu_context.h
index 8c4bc49a3a0f..dbf27a78df6c 100644
--- a/arch/riscv/include/asm/mmu_context.h
+++ b/arch/riscv/include/asm/mmu_context.h
@@ -48,6 +48,13 @@ static inline unsigned long mm_untag_mask(struct mm_struct *mm)
 }
 #endif
 
+#define deactivate_mm deactivate_mm
+static inline void deactivate_mm(struct task_struct *tsk,
+				 struct mm_struct *mm)
+{
+	shstk_release(tsk);
+}
+
 #include <asm-generic/mmu_context.h>
 
 #endif /* _ASM_RISCV_MMU_CONTEXT_H */
diff --git a/arch/riscv/include/asm/usercfi.h b/arch/riscv/include/asm/usercfi.h
index 4c5233e8f3f9..a16a5dff8b0e 100644
--- a/arch/riscv/include/asm/usercfi.h
+++ b/arch/riscv/include/asm/usercfi.h
@@ -8,6 +8,9 @@
 #ifndef __ASSEMBLER__
 #include <linux/types.h>
 
+struct task_struct;
+struct kernel_clone_args;
+
 #ifdef CONFIG_RISCV_USER_CFI
 struct cfi_state {
 	unsigned long ubcfi_en : 1; /* Enable for backward cfi. */
@@ -16,6 +19,28 @@ struct cfi_state {
 	unsigned long shdw_stk_size; /* size of shadow stack */
 };
 
+unsigned long shstk_alloc_thread_stack(struct task_struct *tsk,
+				       const struct kernel_clone_args *args);
+void shstk_release(struct task_struct *tsk);
+void set_shstk_base(struct task_struct *task, unsigned long shstk_addr, unsigned long size);
+unsigned long get_shstk_base(struct task_struct *task, unsigned long *size);
+void set_active_shstk(struct task_struct *task, unsigned long shstk_addr);
+bool is_shstk_enabled(struct task_struct *task);
+
+#else
+
+#define shstk_alloc_thread_stack(tsk, args) 0
+
+#define shstk_release(tsk)
+
+#define get_shstk_base(task, size) 0UL
+
+#define set_shstk_base(task, shstk_addr, size) do {} while (0)
+
+#define set_active_shstk(task, shstk_addr) do {} while (0)
+
+#define is_shstk_enabled(task) false
+
 #endif /* CONFIG_RISCV_USER_CFI */
 
 #endif /* __ASSEMBLER__ */
diff --git a/arch/riscv/kernel/process.c b/arch/riscv/kernel/process.c
index 31a392993cb4..72d35adc6e0e 100644
--- a/arch/riscv/kernel/process.c
+++ b/arch/riscv/kernel/process.c
@@ -31,6 +31,7 @@
 #include <asm/vector.h>
 #include <asm/cpufeature.h>
 #include <asm/exec.h>
+#include <asm/usercfi.h>
 
 #if defined(CONFIG_STACKPROTECTOR) && !defined(CONFIG_STACKPROTECTOR_PER_TASK)
 #include <linux/stackprotector.h>
@@ -226,6 +227,7 @@ int copy_thread(struct task_struct *p, const struct kernel_clone_args *args)
 	u64 clone_flags = args->flags;
 	unsigned long usp = args->stack;
 	unsigned long tls = args->tls;
+	unsigned long ssp = 0;
 	struct pt_regs *childregs = task_pt_regs(p);
 
 	/* Ensure all threads in this mm have the same pointer masking mode. */
@@ -245,11 +247,19 @@ int copy_thread(struct task_struct *p, const struct kernel_clone_args *args)
 		p->thread.s[1] = (unsigned long)args->fn_arg;
 		p->thread.ra = (unsigned long)ret_from_fork_kernel_asm;
 	} else {
+		/* allocate new shadow stack if needed. In case of CLONE_VM we have to */
+		ssp = shstk_alloc_thread_stack(p, args);
+		if (IS_ERR_VALUE(ssp))
+			return PTR_ERR((void *)ssp);
+
 		*childregs = *(current_pt_regs());
 		/* Turn off status.VS */
 		riscv_v_vstate_off(childregs);
 		if (usp) /* User fork */
 			childregs->sp = usp;
+		/* if needed, set new ssp */
+		if (ssp)
+			set_active_shstk(p, ssp);
 		if (clone_flags & CLONE_SETTLS)
 			childregs->tp = tls;
 		childregs->a0 = 0; /* Return value of fork() */
diff --git a/arch/riscv/kernel/usercfi.c b/arch/riscv/kernel/usercfi.c
index 0b3bbb41490a..ec3d78efd6f3 100644
--- a/arch/riscv/kernel/usercfi.c
+++ b/arch/riscv/kernel/usercfi.c
@@ -19,6 +19,41 @@
 
 #define SHSTK_ENTRY_SIZE sizeof(void *)
 
+bool is_shstk_enabled(struct task_struct *task)
+{
+	return task->thread_info.user_cfi_state.ubcfi_en;
+}
+
+void set_shstk_base(struct task_struct *task, unsigned long shstk_addr, unsigned long size)
+{
+	task->thread_info.user_cfi_state.shdw_stk_base = shstk_addr;
+	task->thread_info.user_cfi_state.shdw_stk_size = size;
+}
+
+unsigned long get_shstk_base(struct task_struct *task, unsigned long *size)
+{
+	if (size)
+		*size = task->thread_info.user_cfi_state.shdw_stk_size;
+	return task->thread_info.user_cfi_state.shdw_stk_base;
+}
+
+void set_active_shstk(struct task_struct *task, unsigned long shstk_addr)
+{
+	task->thread_info.user_cfi_state.user_shdw_stk = shstk_addr;
+}
+
+/*
+ * If size is 0, then to be compatible with regular stack we want it to be as big as
+ * regular stack. Else PAGE_ALIGN it and return back
+ */
+static unsigned long calc_shstk_size(unsigned long size)
+{
+	if (size)
+		return PAGE_ALIGN(size);
+
+	return PAGE_ALIGN(min_t(unsigned long long, rlimit(RLIMIT_STACK), SZ_4G));
+}
+
 /*
  * Writes on shadow stack can either be `sspush` or `ssamoswap`. `sspush` can happen
  * implicitly on current shadow stack pointed to by CSR_SSP. `ssamoswap` takes pointer to
@@ -141,3 +176,88 @@ SYSCALL_DEFINE3(map_shadow_stack, unsigned long, addr, unsigned long, size, unsi
 
 	return allocate_shadow_stack(addr, aligned_size, size, set_tok);
 }
+
+/*
+ * This gets called during clone/clone3/fork. And is needed to allocate a shadow stack for
+ * cases where CLONE_VM is specified and thus a different stack is specified by user. We
+ * thus need a separate shadow stack too. How does separate shadow stack is specified by
+ * user is still being debated. Once that's settled, remove this part of the comment.
+ * This function simply returns 0 if shadow stack are not supported or if separate shadow
+ * stack allocation is not needed (like in case of !CLONE_VM)
+ */
+unsigned long shstk_alloc_thread_stack(struct task_struct *tsk,
+				       const struct kernel_clone_args *args)
+{
+	unsigned long addr, size;
+
+	/* If shadow stack is not supported, return 0 */
+	if (!cpu_supports_shadow_stack())
+		return 0;
+
+	/*
+	 * If shadow stack is not enabled on the new thread, skip any
+	 * switch to a new shadow stack.
+	 */
+	if (!is_shstk_enabled(tsk))
+		return 0;
+
+	/*
+	 * For CLONE_VFORK the child will share the parents shadow stack.
+	 * Set base = 0 and size = 0, this is special means to track this state
+	 * so the freeing logic run for child knows to leave it alone.
+	 */
+	if (args->flags & CLONE_VFORK) {
+		set_shstk_base(tsk, 0, 0);
+		return 0;
+	}
+
+	/*
+	 * For !CLONE_VM the child will use a copy of the parents shadow
+	 * stack.
+	 */
+	if (!(args->flags & CLONE_VM))
+		return 0;
+
+	/*
+	 * reaching here means, CLONE_VM was specified and thus a separate shadow
+	 * stack is needed for new cloned thread. Note: below allocation is happening
+	 * using current mm.
+	 */
+	size = calc_shstk_size(args->stack_size);
+	addr = allocate_shadow_stack(0, size, 0, false);
+	if (IS_ERR_VALUE(addr))
+		return addr;
+
+	set_shstk_base(tsk, addr, size);
+
+	return addr + size;
+}
+
+void shstk_release(struct task_struct *tsk)
+{
+	unsigned long base = 0, size = 0;
+	/* If shadow stack is not supported or not enabled, nothing to release */
+	if (!cpu_supports_shadow_stack() || !is_shstk_enabled(tsk))
+		return;
+
+	/*
+	 * When fork() with CLONE_VM fails, the child (tsk) already has a
+	 * shadow stack allocated, and exit_thread() calls this function to
+	 * free it.  In this case the parent (current) and the child share
+	 * the same mm struct. Move forward only when they're same.
+	 */
+	if (!tsk->mm || tsk->mm != current->mm)
+		return;
+
+	/*
+	 * We know shadow stack is enabled but if base is NULL, then
+	 * this task is not managing its own shadow stack (CLONE_VFORK). So
+	 * skip freeing it.
+	 */
+	base = get_shstk_base(tsk, &size);
+	if (!base)
+		return;
+
+	vm_munmap(base, size);
+	set_shstk_base(tsk, 0, 0);
+}

-- 
2.43.0


