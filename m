Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49FE7CCD18F
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 21:56:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A1138E009B; Mon, 13 Oct 2025 17:56:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 752138E0031; Mon, 13 Oct 2025 17:56:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 52FE08E009B; Mon, 13 Oct 2025 17:56:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 330608E0031
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 17:56:27 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D7E3313B748
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 21:56:26 +0000 (UTC)
X-FDA: 83994450372.18.4277637
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	by imf26.hostedemail.com (Postfix) with ESMTP id CA47514000E
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 21:56:24 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=YYYUIqbv;
	spf=pass (imf26.hostedemail.com: domain of debug@rivosinc.com designates 209.85.216.53 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760392584;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RVfqSsruJ2MSGFolr4q1FtvvuePYAHYekfV2rCXHQ4o=;
	b=ucddNSusdyjfOwlYI9XWxd/DSFYiO/bsGdrQ8u/N7Bxt9YqCvY8KHk9DLaG7o8yrPDZXWM
	qVyf5fXl94MiZTuJvAqoMKRp5rlOO4YMpiebmrqHuo6hgZB/8tGebMWAVloasnCIO6VEmJ
	rdeWzWLjO0QzdunHNyeonCU1O8ZyfqQ=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=YYYUIqbv;
	spf=pass (imf26.hostedemail.com: domain of debug@rivosinc.com designates 209.85.216.53 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760392584; a=rsa-sha256;
	cv=none;
	b=CKbccyUK124OwKkxGQDecCjbUM5yXbLRTi7A+vYf2JhCsXcTGTp53Ovij92XhWBL/AZ6pZ
	OzSursIA9Lg1jAi9md6/Ve5w4xwy843t1AXa/9Ic8vXpBX+HYauDIqw0zCoRdKgakxuPX9
	alH84JPu2ZCmImax6pUFzusaIvALyG4=
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-3327f8ed081so5896166a91.1
        for <linux-mm@kvack.org>; Mon, 13 Oct 2025 14:56:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1760392583; x=1760997383; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RVfqSsruJ2MSGFolr4q1FtvvuePYAHYekfV2rCXHQ4o=;
        b=YYYUIqbv8IBpki2u9v4lsVEvvMpAJuPfu8vxtw8eXxE705GJWJ41r0OFwydPxNLYQq
         ZH2e0I9WnMWtPVgj9J1OLLKxrr/hSSEo2OXdg43FEd8QrblE8G8vvWyFysXGwutwpWXM
         f4Afh8/Jg1/jDqrOHl/nf0V139lsA3HSA9bUAaGe7joMHP6rVjmmggPeii+uwBYdF7NT
         Xz57kbbuKD31VNmQbG57wlvNDlEyU/29ivWWErgoNl12wOuamY5fBrvBg9KNAL6vrIHD
         bi21ZvIqYqwP0jUalY5vm4WAOAmJyPmpMq1ctPn4wHom1mzwNDqR8IsivlSUj3thpl50
         Tb6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760392583; x=1760997383;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RVfqSsruJ2MSGFolr4q1FtvvuePYAHYekfV2rCXHQ4o=;
        b=J4J2vtn9sQkMDPT31dqC0I7xC5JCPWryo0urTLvRATIBHMd+wICh8y5L2YyW6PMUQJ
         VxXXbeEKwTgZVF9p9TQRvPba+CrRbssCk8i2voCUlG68VXx8CawLx4iydP8mXYDbEXym
         wKcmbPnX5yUqM20xp3yPE6auhrXNz2TXlKnY9kw5ZqMIvN32axiRph3FH5N0zHe9WLfv
         sTFCVMiwqbW6U75TUweP8RGh2ze2OF6ES8Ewy/hUMgu01Kt2UW2u7XXLlUCvVhyBfQNT
         CJGzZ4s2VQJV5aOROfx0Lo6LPBf3eMbMcED6ySlJC77wY6um0W8gu+UT+vfkXrBvFBlJ
         zNQA==
X-Forwarded-Encrypted: i=1; AJvYcCW5088eYnxK/j7G0LO9C9mSFi7CvFZosSG7Pz/uJovjKW9Pc69PRXdmz71E45wO3JtHI1UdziSkJw==@kvack.org
X-Gm-Message-State: AOJu0YwfXNNghKOMKmyHZzSH+zbLN78G9jkda7Emt+TXqMVmpkzJvyEB
	fKoDwPf4Gnr8j15KPy+mPLYnJfmz8E/f1oYUHWMSx/NFVHtPNq8uoaqq2ee9KRQNYsc=
X-Gm-Gg: ASbGncuTgif6uG/ZDbyFdzJR/Jtxhfj1SHkTQUpaYdXpoEvlCkjG5ASdQsVme1Kg50U
	U2NTQPpMykvDE21Rj12Oimae3EEDbMjKhHo5HgSpSuYdFEXv2RKNatlYI8PCzgw+XjPL0bzMq56
	y4z7TT7vG6ZN6YAEGcojV02Af/dzYzQ9Uul9u/EQOdIAtLYdpRuA43ANFiP1e/z/YeXxE4w2F5W
	vw5mmixhCnUj/Vkqyic8n44K3cGrI9Yn3gwfZ0cGysTiKBGSwwuuQ7epv1DmnXOk6c0c7lYhOKj
	mrsFgiK6t5WgUfVbgH52UE5bPwlovL6kQ3gQIz+GYK+rqJxj57Qey4yY0V1cJg3vT5Wj4WEx8W0
	B47n5eDoTEMJPItnES5gilj/gVuD1CjKvJQoYeh81OqRQh6/vEz/5Mj0104H9uA==
X-Google-Smtp-Source: AGHT+IHXhRgk6xRwstimf+OnEEIVgdGsdgidBOF9UaoxKi2U5BiG5UC7WEtn6UhcoSMLmEdpcYc+5A==
X-Received: by 2002:a17:90b:4a06:b0:32e:dd8c:dd2a with SMTP id 98e67ed59e1d1-33b50f2c758mr32265857a91.0.1760392583497;
        Mon, 13 Oct 2025 14:56:23 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-33b626bb49esm13143212a91.12.2025.10.13.14.56.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Oct 2025 14:56:23 -0700 (PDT)
From: Deepak Gupta <debug@rivosinc.com>
Date: Mon, 13 Oct 2025 14:56:03 -0700
Subject: [PATCH v20 11/28] riscv/shstk: If needed allocate a new shadow
 stack on clone
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251013-v5_user_cfi_series-v20-11-b9de4be9912e@rivosinc.com>
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
X-Stat-Signature: z3sdcc883uk4buddec3f3tfiamw7u17r
X-Rspamd-Queue-Id: CA47514000E
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1760392584-742308
X-HE-Meta: U2FsdGVkX18P5edMaqylr3XrsfH2gVqxe9s8FBnn0Vp53D9H5sBzzBN9ncrxhi5O/5ngS70gw+rLpaI2OW3pXb3s+28chKXku2vmtNz8uIJiUITd7ZfasiMRtBe2VOqlF1vUB29eEVu3Omz+GJLDRWDK7/OPeA9ydoSPuirXGRULsmDfWlrOuQTBgtdRGzRZfYZJ/KZpBuFUV+8F/2DfEVntfiWSdqHteR68CD2PJ1MX+Ru2o4SIWCfgLX8jR+jnYLCC/2ORSh7ftWuPpxF6CUfyRweJ1e5/Mll5ezg1D8XpNCxSd/09aKTw34hapqCbq0Xx2ZARRgSQqFhIvBVuU6PTYRlXtK6MI20V1xC2LKI0fQxOn0Dg5rT5PYgsxf1JVj41TOdtXsT892OAiz+mryaQa5s8HIe5Ish8Q13uDqzEhmFR4a1PW/DqUXPpouVV2Xqb1/HvmFn21TzwVq/mI5Srt6bXTcE4xjGb6K55VoqAfqZxB4OXyxGZHqXKZI+U5uTWfvYbQEtQ/1eqJflBFCLZ2hyhOHze0SpOi19ZxslxeG9uvSSyzgccbOWpO7Zgw2lAnXazZd+zEDxe2d7iAHxizln29kzPKZypw1HRSLEX2GCf6zB5uQhaid+BaD/dIifUE2lnQ6oygq53jKokPrp5k9ZPHwpaybzaFqY7osXjHZDNFgUo61OLRz+eKmRhwHySopOeCCo6ao/0NYCKg4/2g4PSnmzA31W+mU3r9dMebZ4zqx7+4DSyRvmQEruo5XuB4icj+t6LgExXFyoGFzNK9wYF4I9ecLFiffuvypx+XL8Nc/6yzOlnWKbwinooEXlmYT5XbxtLCmkYddGQAfAxInWMCtUhLMXg820v32wt0lsCHBlLz0U9Dyed09cR8KyMTYJVHmCo6VSg5BLVx90lAKZw5qdguzO5EvWW+0UOYrVjM04kHjEEUAQbcvAWG6uLMXf2T5i141VBvj2
 NvUlZuH5
 LCLcxUDD0MjTmClWMICP06BcJg/fSiUGv5lppaAVbPpu1hGxA4V2s1r8LYx3e0ar09FjW15xvL5Xl0Vxh7YRkk4atY+C4u4i+7vYER33A7OcdGWC11pOZKR6BeomXBAJ24Ii1HFCCbAAn3CAowlPxkFEK9M/72OO/u2d4cp4KbO9Vw8uLQGdW3jQfxNYM6Qe2GSaOxAcCU7fSnayhkCkaDbmzycyRKmyjwHr/igm8ym8Y7xmqERPG7uzVpCriBUk//pKcTGhyw1uinsu3Mds0vwMKIhMz2At65BtkmsxmPAWFr5XQsvC43IThgBfE4MWJhbYEUuDDLGFNVwNt4nLmL/E663hXPr+nk6We5nv4MbzGbs/zAcuwuk3OCIm9BmKhjrlDi6qJy+8X0F5Nb5AHOMGjmeg2al+B6WhtBQfmclB/O7tCdC1P3vq0I0sZ0Bt3PzJujcTzmSaGUURccFP741s/Z747RtLoGzCL
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


