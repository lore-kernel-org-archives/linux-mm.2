Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 186E5CCD199
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 18:14:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7EB538E006B; Wed, 15 Oct 2025 14:14:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D60D8E006E; Wed, 15 Oct 2025 14:14:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59C5F8E006B; Wed, 15 Oct 2025 14:14:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3C6808E006B
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 14:14:12 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id F1D4883CC1
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 18:14:11 +0000 (UTC)
X-FDA: 84001147902.29.E05F8EE
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	by imf13.hostedemail.com (Postfix) with ESMTP id 02BC62000A
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 18:14:09 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b="Vm/fHIhE";
	spf=pass (imf13.hostedemail.com: domain of debug@rivosinc.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760552050;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RVfqSsruJ2MSGFolr4q1FtvvuePYAHYekfV2rCXHQ4o=;
	b=MN6Cuta9c17pshapew05AZ+ovI6A+SuaGv36TUGLuzojp7Ta3Zh4iy9Kj20W4HJttk66CW
	sJwhz1IwX4raTmXudp6ruHLs80dsGrk1D5c+EBy64hQ3UtU8MmpN1Cfipi3n2bc56EC/RK
	uZ457vZmmBbvaMTEX0WN8d1sDlx5Xfs=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b="Vm/fHIhE";
	spf=pass (imf13.hostedemail.com: domain of debug@rivosinc.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760552050; a=rsa-sha256;
	cv=none;
	b=hhvyxGNv5sZCxT7OpKRKDEoVtLB8B165P1mVe9uv/VUkjEtT93NKc97f1JuwgJ0UsYTmhd
	0gNcuMWds24ajWjt9V8vxzP4+I9NrFgOv97zBL5ydlE1nJJcMd+C18roijhFgl4Arp7yc5
	ekzRE1V/WTmRMv2b8XLMQzNfZhUSTBU=
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-29091d29fc8so3018455ad.0
        for <linux-mm@kvack.org>; Wed, 15 Oct 2025 11:14:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1760552048; x=1761156848; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RVfqSsruJ2MSGFolr4q1FtvvuePYAHYekfV2rCXHQ4o=;
        b=Vm/fHIhEG0c9wYtav0MAqUKywMKJIU1rf7zYBpugTR2kjHmDV9V4nKV3lAz2sffVvF
         4Pr+USILX+cnCjbF9bpUuAmuG9eM0tg2fDfdJRI3gc2nY+GT6QltuYQb0CgG3Bd4/UGk
         e/RoytuN9JRlZaSJAHl4kNAFHjMG7P6kmqg7euMsAcxfKJhX52c8Tfl5hkv6kWdhToKk
         KTH5XdGQJ7y1RsMKDbUtOGUfpFwd9xUKLd+tupq/nLqWZ/L7vyacSg+v6y2gU12dXmJQ
         6lFvAyb/+fzycmq3xC7zVNMV81HzuMRGQqWHMs49crVs7f5KQDpERSJGx266j/AMAusP
         20iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760552048; x=1761156848;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RVfqSsruJ2MSGFolr4q1FtvvuePYAHYekfV2rCXHQ4o=;
        b=igKurOSdQ6H/W9cu3L8GTdkl7E0IitrHLoVfDTOW6iTi2BkacviHbrJ0syK9rHZilo
         jS4g+pCG48idzqum95TG1vC3JjeFSKLG+amo2ex+mXDMznqBCs7PYxX0QNVVGjN1Ikmi
         9qfXnYbx+KbiH5dkueYs80kIdoU2UCm2StJkCV2pgjbeJVN7Rt5XTVZA5de59Q4DAUUG
         kob1toPZzwTKI3ud3VZu9I30Wayv9C5j4Ta8ald15EhxCOs2fpdNKjHHCr5B/wARAEKG
         OGVTIWdVR6KPTKO85MxzRNqWNviJ1tllXZurqNri1v8ucOmk0ohw3Lzb+5YlRwkI9LrX
         duag==
X-Forwarded-Encrypted: i=1; AJvYcCU+M/zHfpU2gUnokEGNwvdDjW6dbXpB79pPr5YhG9ArMmR6xElpN4uwULxab2oLlzUzbxWoq9xDMg==@kvack.org
X-Gm-Message-State: AOJu0YxTacDoXdBUx+Q+fDvHXnFkNtAOTPVAd1WuOrLSbcYxoXsPze9K
	Lt6lU744/OQTZBEBDwkbq6bas5w1CxVb54vYVsum0y0CNuq8gRYE0uQrsBZLF0SuFfRY3cgMgrE
	GchRt
X-Gm-Gg: ASbGncvwg35aXAHvqgrFd4Yh9VQJ6FPCDgUp7u1GIq4o3tHTYgPlOni18bgeqPLy3U/
	XbeznZw7IRfc1hzGXD3pEWPlbNyizCUMFdmqktgd0JV+eL13va5RICfum8DC7VG72LXgw/uSFfy
	mi0yLLqKR3pGegg01yhuAxyq7cHENBx1hKOAO7fEv6HvGyiLee8XRtnmR92OA3YIkVFBfs9rArd
	hFihEqDlPpEBwlmyjaTXTHs43xOZ/hsY6CdnIBSfXaTNHu83YXZPIpRc6OQsjgM+X/+gsumWTMu
	UbfNqGV0vFvn6G7NttrlCtfBLkeIThISyX/2vJ3SnBJqL0RnXVKEtZ10xXSDTrnnmsIRozpodL5
	3hZRYcQZVmpawhlBmh5mHzf37k7elusyBwK9L9TNrsLr4KdHb+eWvZexwGiTvIA==
X-Google-Smtp-Source: AGHT+IH4y3/JYV67n2Zz+qZOtEBwEYwpGw71Q2pkG9zdTwMD6nqUHY4NfW8jZr4VR5wcHzxSbl+MpA==
X-Received: by 2002:a17:903:1aef:b0:250:1c22:e7b with SMTP id d9443c01a7336-290272e3a78mr384338655ad.43.1760552048435;
        Wed, 15 Oct 2025 11:14:08 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2909930a72esm3126625ad.21.2025.10.15.11.14.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Oct 2025 11:14:08 -0700 (PDT)
From: Deepak Gupta <debug@rivosinc.com>
Date: Wed, 15 Oct 2025 11:13:43 -0700
Subject: [PATCH v21 11/28] riscv/shstk: If needed allocate a new shadow
 stack on clone
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251015-v5_user_cfi_series-v21-11-6a07856e90e7@rivosinc.com>
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
X-Rspamd-Queue-Id: 02BC62000A
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 7b7wmfxy3fxf4iqnhaa3df694zefcwab
X-HE-Tag: 1760552049-659541
X-HE-Meta: U2FsdGVkX1+2rE35t3Ky2K3B7CKMEGg1b4TjeiAvTzx9YJNN9MAloz34Lg6SgsP3ydA3EP4XC6bz4hR/peT0CG8DhIutd/7gK2gDnvgptGF7Tm4AhyfM0LGfj4KbAshHaX4w842AAxwzUkSSr6wEGdr15I5w2BxEWiX4g7A1H4VqM/cVy9TfqG5AFcwKYDQQyLS94qCr6oG5Zt7jRLU+faiWYUe8Omsn4j6FtO39+HI0/0AgyGnuSz4Y4LJBnUwHLLlhyK1pv9cR/Xe+il2xM3hG3DQm2O4L4Rl44LA8MUX3JNuzpJ+W/nWgI+v8NqUQAeCFtEXsBXjg3qPckXiCU3wv1r8iLkilAdCyO9mBIHJqKjzzUj2vqi4RKBE4YvnC+Ti3Op6j9byeuv1XO4mCe8VD/2IwrAvlbIRhgE6Nfh670lS+DPC+iQXAydrN0iHzyftEFxx0vGzaGieiR67hX0Y2E6fv0tUML9COmwkZLVOa9Efix75kjvAWEJVre1NMTWcmonhjS+6YtPplEi71agVIZiT8xK/wv+t3/EGQn2yzICuZ6UQonQ87R6ECjNPNoh+1cb7CW41YjXiffHBQOujqPCeOmbmvQ8QbwCwktmb+x+jwn9toVQjovdIhyhRyWGeOskieW0vi7PRI35Gl9nT6d3XCbMUQHY6iDtAjabjNRE2wIjyeWWQldnggsHhdXWbMpCT7rnCma0KgS4VkUcSJVwml6won+BGXaf7KSJEOXPODFIJngoZXyzo6S7NxtfjVDu6NVCXqgGgUXGML4YapGny8QOCRc4y2ntBDwA7JS19GgBgFLAEIa3Cd82Oa3ysDoTYJB9cQuQwZWcVcjIZFMaiNkDHetmhVflv4W4nRH1+GChXVYGln4heP/+nJVCIupp2Pp4iirdBveQHnJov0C5pt0SKU4znyCnFh/0tsTMxd6sKLp5PdyMqgr6yIk2BvKtC9LxmzIX3snc1
 AYt6d+d/
 pKNFGPOtnDWZ3wi2GWJlZ/HdcAsLhCF2Xw9l1fLAcPdSxccwM7/N46zt++EFO5y3CSu+yUU5qVHMrnlI263zg3VL38f4HPyaGadHtqzLgi3c6CvoE6ZN5yA+ImNH0MdckxMVE+5/xkKVsvvuBMl+hozVy1Z9oIfpNv+e0N0ljbA7feWnRY3SgFz/ZlzHVAp4hW8VNVwNGg7AYB7C64dRAqsOYXfRYPzmixqU+WtRiiyCcjmozbk5kz+8onSBZEmTbx/J88JYtr5yRMAqhEqeXHbdhsKSGViQJStSHa5VOTC4LS5HaTi+nVOe0SmVnsSpuZ+LFF73Z6KFo3vTKqXZoH2/9RWqCHyoD2I4UCPd3xtHiSMvHHlic9ChaiHbqsPLAgIaBrHE0b4Pec0O86Dd+ioT+OV1Nzc9D1NEODnPSYV8I88/2ktVrhirOSQdvfPzTPGPOTF1PHyZJqcS9xGe0scA3p/65xjn8Un5c
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


