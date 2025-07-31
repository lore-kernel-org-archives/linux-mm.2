Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C748FC87FD2
	for <linux-mm@archiver.kernel.org>; Thu, 31 Jul 2025 23:19:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 414EA6B00A6; Thu, 31 Jul 2025 19:19:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C5396B00A7; Thu, 31 Jul 2025 19:19:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 28F036B00A8; Thu, 31 Jul 2025 19:19:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 11BBF6B00A6
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 19:19:55 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D2C19C0B6F
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 23:19:54 +0000 (UTC)
X-FDA: 83726129508.26.67AED7A
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	by imf20.hostedemail.com (Postfix) with ESMTP id 250221C0006
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 23:19:52 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=rivosinc-com.20230601.gappssmtp.com header.s=20230601 header.b=mZbG6Py7;
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of debug@rivosinc.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=debug@rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754003993; a=rsa-sha256;
	cv=none;
	b=Iz3hrc3eodqNcZZMn737nXg9nhwMEiALUzJtV+kRc3CR2oloSkRfBesEiwyX0hLdM8yU4u
	5+Qgi37V+xaBBjNCNiNHfIW/WF8EavIu9TeB+8frSdfA0JMea3y4+j/m8DZECfG5aiRmnQ
	MM9IJq0I1LrqjNslwZ5O4xD39zhGneA=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=rivosinc-com.20230601.gappssmtp.com header.s=20230601 header.b=mZbG6Py7;
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of debug@rivosinc.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=debug@rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754003993;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=11wZSikKRoJOMaQhu8Re25aPj6EKzqad2h7fRBMzcVM=;
	b=1RIiR8We6lyJyEEnWLjnA7MupBBEx7yr8U1VqrMGiDv87Rn3qdKgzj3zTJ3vXhenwrjz7q
	NOoi2T3k8fwDDvY/kOPvIMlhZNYLeOynvs8c9j8Im2yj0zqDonGLKNKulDR+eXSAILfhQu
	JLndOywaloKSIEXheXazXK/AhCiCyWg=
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-3137c20213cso1153287a91.3
        for <linux-mm@kvack.org>; Thu, 31 Jul 2025 16:19:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1754003992; x=1754608792; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=11wZSikKRoJOMaQhu8Re25aPj6EKzqad2h7fRBMzcVM=;
        b=mZbG6Py7WuZL7N8xFpTIoNY0J7nfVhXatRcLg7IOVf/VTrjhsAiC47JKQZ2czxONX0
         u5Hano9K2cy6cBDS9xpQe9YIzxIDoWsYMzp4sLKHmbl+pkIEcFuC3m2MAbj4bWDK4HWk
         AyBR0qYHf59OI7kQIOE4wBQIfXb1IG92ULJE8+ZY380Ux+bprKF/o4BwzUdcsq45qs70
         +4EUvQJUbjrhesVNtIdXtL0tsFEjD0kfFUJbed0ZI1wM+ZIRf95Ue/oIMWRtJm9TZIP+
         OuS7aBsgxJwu16MAcVuAN1BjCJIAF3+ikW0NgRZ+QLoTrfFiyTSwQPNJ0RrYt4lv8pvs
         UPUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754003992; x=1754608792;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=11wZSikKRoJOMaQhu8Re25aPj6EKzqad2h7fRBMzcVM=;
        b=D2VLko5/JCD2WFUDzXwQMp9mkrFtU/yf5H0y7NL1zUVZtpJGQED83VEFHIA1eep9bX
         uDib3CtDQOMinuuQvpqEn/KBazShefiANxmmgAkFj1UXEVlM52mOrqjq0kn/y+9E7pAQ
         kyQlw5t4KzodYjuTBjyhsyljkJSfBYGpklqZ75QraFj5FMmWvEQBbRFywRiLLVEW9U2/
         d6D86ohOLahe9QXWuf5tsGc3HiVNWlnrblURr8EmSqKB09ePwxPnmGazKHEvqUe2B61e
         z2p7+DF+V+4e5KUIqIL+Qcvv8aq+SkE2Jv22PrABSDo+NZlj8t0FPCMgFbXmGpz/UQJe
         C5aw==
X-Forwarded-Encrypted: i=1; AJvYcCXHyhBy4Gl7XXfbeLh13xSAeRMSFOSzdL72fqwRsT8fsllhgsXPMbzJpuD7g+VRsQPgQ1NZirkUbw==@kvack.org
X-Gm-Message-State: AOJu0YxfCPv8pk0Hq6ouI8+i87PHyq3dzi8vKLY1u1c5IcILujb1rAua
	tZJTxTw6dbbc56zMCWa9688DQiFEGOQe6y8rozwMA93ukxBua7nNG6ePHMDD5/EKFJ4=
X-Gm-Gg: ASbGncsydchK/MWC/EVzakcqbmeAsNfYqc1Ht3j7jLe72xlZ1l14hXnbwftHtvtlOeS
	MG6FhijjE7jwPbJHScE7bH5ffTO/wuyiNVu+OoIyP9vf1mgmCe/ZIov7CWSyZvYTy9+Hyd0XRD0
	jmhMhA2lLP5yHPBwqhgNvV6JTd4Mo/D4ygyBH6s+3Q0owitiyDQfn5PkjjcJSJ+SWDZS0KSpAwu
	+gO11DTjBCHZnUHDsBLS78xp2UfmExgXLu5SmFl5e8EEfECEIwmCf4bZsrtKzf9gcMk+m+Z6Q29
	8hbKIj5ho05AI5Oexv1HoVVg3kFoqec18K11L+tDkhBXc9+1qfWKFcJEAdmY4zXZdw2Juf904L0
	X205m2UsJQuW5mCwkFy+or9ueVP/3dK/VNITawMc04T0=
X-Google-Smtp-Source: AGHT+IF1WHeaVHeH3w5h9e7R1XhQ2SFzqM37oVfklpJ2xq2aDMdRF7ccrkSivKquiWJwvHcJtvVopQ==
X-Received: by 2002:a17:90b:3505:b0:31f:652b:e67e with SMTP id 98e67ed59e1d1-320fb9af105mr888087a91.15.1754003991833;
        Thu, 31 Jul 2025 16:19:51 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-31f63da8fcfsm5773085a91.7.2025.07.31.16.19.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Jul 2025 16:19:51 -0700 (PDT)
From: Deepak Gupta <debug@rivosinc.com>
Date: Thu, 31 Jul 2025 16:19:21 -0700
Subject: [PATCH v19 11/27] riscv/shstk: If needed allocate a new shadow
 stack on clone
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250731-v5_user_cfi_series-v19-11-09b468d7beab@rivosinc.com>
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
X-Rspamd-Queue-Id: 250221C0006
X-Stat-Signature: bm4npujjys8jnbuc9d8pko866toki15i
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1754003992-518551
X-HE-Meta: U2FsdGVkX1+NKmw1nKyVFVOvy1uHTBIQ7PYOmdkLH36+nDSVQI6O2lpFLI4TUL4hGDmiK+KSHf9yEPbG+/4WBBziSv31p09+2yY+sSiHJICG2yg1wArfLuCFlIM4H4Kxc8eTlb6RTITV6lzB1HrltRDOkMf5+/m1RNfyfwl4l/5V8A3iIMKuE01aa7XEh/e84E0Jxc6Yc+0U03s4QieqtQ4zHwo3PQafnR4ho6c3ZBgDJcZAI6/xS+WCFA4GTNazRWJjc9Ilw37F+Ujy/TynJDDNu5+EmJJAlWBMCITkIlVWe1AN35ntxo8S1UAe0ae259px0WbNF7MW85aBeEfIuOlZWBxufEEoXim2ewTD7SJDUtg4q1RXaacaj2zqqdaA7K5XTLUKvAMAsw+o5J3g4utWqqrT4flmo6gmxpqdxUZ4oo3jFgA1BlL8FHievxW7upWLu7zO37jIZq3N8axXglbt0jX45TwK9lopYKRyZ9XpJJh1h/5de2LtAS+ps8XlAUNIErc5WgyFmlIhiETR1k68Di19orG61AWq/oNBKjv4pSCswqpvHYjXkOh/5geeqlwAjNacTIQw30WDCIGX7YBAkHaSJrwuXT79HsUqc29pCpDqOwIj9y9Zgxopas4rxTPDOg89Ztyyrbq6f4D6BF1k4BaLA3kOB9DDh+8u0JfQExyoo8g2oK4yrrAtWUqMLR0rjnJ6DeY8UbbMbBtL2syrPod3+XokAnffE0rO9pa7jwcERlvHJ/9W0zuuNieOS+e4z/wyBuCEAtPPuHZhUR6ZLTE3WEAdzpAB+PCCqd7GHaFAV6txneWvuqdQ7HpaQNy4mHrrI5gHE7cwRT1/4vDPeoPH6JOxU0H2y7RJpUDe6tQCZunp1n6JzcGooqeA9AeOEbdB8p7KPonIlHxvIV/PO70SpRE+06c8Emu1oDFsglgCxfsQvPOG5Jv384i+fOcrodr+653TtpGH4me
 kgn7Afcq
 nLAlDQod1ETWhSJV2MABBwKCIW8fXzBTPharp1h04SGo1XzLcSf5cCoOP3BEj1+QcmIx9YiNCXcjaQGcCPTli3it7kTugako95kcv
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
index 94b214c295c0..0c81cc9a2b6d 100644
--- a/arch/riscv/include/asm/usercfi.h
+++ b/arch/riscv/include/asm/usercfi.h
@@ -8,6 +8,9 @@
 #ifndef __ASSEMBLY__
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
 
 #endif /* __ASSEMBLY__ */
diff --git a/arch/riscv/kernel/process.c b/arch/riscv/kernel/process.c
index a0a40889d79a..2d009cfc09e8 100644
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
 	unsigned long clone_flags = args->flags;
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


