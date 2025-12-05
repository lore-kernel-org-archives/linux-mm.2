Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D83AD339B5
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 18:37:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2ECC66B026E; Fri,  5 Dec 2025 13:37:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C5606B0271; Fri,  5 Dec 2025 13:37:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1DAB46B0272; Fri,  5 Dec 2025 13:37:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 03FAF6B026E
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 13:37:36 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C161913A6FB
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 18:37:35 +0000 (UTC)
X-FDA: 84186275670.19.5E829F1
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	by imf28.hostedemail.com (Postfix) with ESMTP id B2169C0008
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 18:37:33 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=L7GXJxT6;
	spf=pass (imf28.hostedemail.com: domain of debug@rivosinc.com designates 209.85.215.181 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764959853; a=rsa-sha256;
	cv=none;
	b=l0zZtMQP5NC5C1D2hhv3Xpr9JH6WvIImoCR0gt1JjWkxLzNFag5r93NQ5J1irUJy1T0dLi
	JmgPALLdz79RKoHo5R2OJh3Hvtg5dVEOnuFW3C7o8+3c6Y0tqRS4F8sxDP+dAlttBcm6Jw
	Ba9uJcpNUnIeWkdsBeIeNgwx17H511A=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764959853;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7RnuI2UkBizC29w22/jrSl2sQbK2qqJuozv4nJOkh7A=;
	b=Rn9alYHS0TYU7N0T+jtLDSMv5qFnJkCXMPcD4yP73yCXfg8eey3S6q5Ab2qX9GHGl3Yriy
	ujMjTYbaii6cDPsHTbbE4Qy+lXxiMgT4iDuuiCUP6y0EGOJbo71Kr/Fej3PtqDu8PmoSx1
	4co7QtM3FrGxvTnAy9v7+Vz1pjBCtKs=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=L7GXJxT6;
	spf=pass (imf28.hostedemail.com: domain of debug@rivosinc.com designates 209.85.215.181 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-b553412a19bso2097618a12.1
        for <linux-mm@kvack.org>; Fri, 05 Dec 2025 10:37:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1764959852; x=1765564652; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7RnuI2UkBizC29w22/jrSl2sQbK2qqJuozv4nJOkh7A=;
        b=L7GXJxT6XmC/5N6gSJ3e5H4mSmtICVFHS3BF8s2jwZRMmyUMJdmantnPdXOzWGtVFe
         uEXS/bOhYSGFEhtXnZrNIyKToyXoISWY4232uhuKagxR4RbsB/ZzjOn+AGuqscbdajdh
         suuLzR2ZzupT4ZVbYxgPVhpzizm70Z40ohmMLzkAApGdJX0REk51TePrzMP9On80AcGq
         CSMg5jAPq6pyMbCnt40PL4r+MQ6e5e6zDJboyvvxeXbTIEPgH8icN4H5poNzAOjJdKvl
         M0ld2AkuPmupCrTOgb2aQSU/oWg1foHLfymqrBdkaUPIClbW/Xs+JNDA8s/lRfPc0KkE
         sHHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764959852; x=1765564652;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=7RnuI2UkBizC29w22/jrSl2sQbK2qqJuozv4nJOkh7A=;
        b=V01Os/6pZoT6DQqRlXftt9ZS4s/YJ0XAKRgVRlUNP3nqRnzbgG+mca7E274MNnTCRQ
         TlKWFQhEoNzJhNdNhBoEFCgWc5dSs4aRr+08E2HLE+/BWMeFaHaAOeB9J8/9EfDUHUHj
         fGGkHQHrCnqnd1xeEXTzt08KG5IB6863SIj11IjJFGucgA5qfoNWtFov9zPH/mW/kMTm
         dXxCZkJ91mv86Eta2OymVevYzc0QEcQCuoDJMa/jrGnZA2LIksBVgOdRaZb9EeFEMDr8
         VPngGUcb+09A8BrPysOfD9vezZBOuNX7d+hQBFDpGO9jfInHfmn6NdMgBbCtTLUt+arv
         NWDg==
X-Forwarded-Encrypted: i=1; AJvYcCU3O+6YLmHv4rfJOpq3vFpbGSA6LHyv9pWHIXGZ1pwWzfjcR5Xl0XuvCGHS8slPbvOmGFxAF6y2vQ==@kvack.org
X-Gm-Message-State: AOJu0Ywgb7LpPiuJgQaGReNQj6G3y3JreE/VMJUmdmfvnieE7cFepAI/
	Plq3/QMRbRHJWai9eq0IOsGWOteIefWlnzJ1h5HaOtjEd4Rulp/lgTVHPhgg3SpxQHM=
X-Gm-Gg: ASbGncu8i3GfeBrMXfLK/3yYd0xoHDx2etHSFSZEEfAKW41SoJxMxkGNEQ9FUKJCp+Z
	qUSVeiox8Ci5giG3uv9TTCPezJ1tS6ZdQwSeQDiotFQpqyiADL2UQCqFHwZEChlPSTuIpbDS0SX
	HGicgh41F20PKZn0QnEL9Wp87uTNJ+Mu3TBB2JMal4Sc4MInFO+X/g2FE0OW55e7pxBxDU3JNiu
	32otxg8j5lMky80mAWGg5ss6/arQ35Cawy9DzdIVtV6Ny4OUYOUo+vPH/Yxj0YvlIo4ioXYKwrI
	+euLCy1dHBEwVnJ4rOAmmLo8CtUOL3rE9y/2cMc/OJkxTNqNq8mbzBu4TNpPXfVsC9y3QrQzvau
	jmChyvm9VwGrqMGR3trFRCkOA5oliWbk8oTfgbTbuIez+KgMvyfng7GZhEptRkPTWUqxyRJjhUb
	m2hELgNe7wTe1rd+IGEVra
X-Google-Smtp-Source: AGHT+IFwWQQuMqwR1+ed74jDMY/CSXapqooDG8iNUOlxCqzdKYEOKwnXkGf4vaTbspDREQ1pfREY3Q==
X-Received: by 2002:a05:7300:ce8d:b0:2a4:3593:6450 with SMTP id 5a478bee46e88-2abc6f4d29dmr119392eec.0.1764959852461;
        Fri, 05 Dec 2025 10:37:32 -0800 (PST)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2aba8395d99sm23933342eec.1.2025.12.05.10.37.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Dec 2025 10:37:31 -0800 (PST)
From: Deepak Gupta <debug@rivosinc.com>
Date: Fri, 05 Dec 2025 10:37:08 -0800
Subject: [PATCH v25 22/28] riscv: enable kernel access to shadow stack
 memory via FWFT sbi call
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251205-v5_user_cfi_series-v25-22-8a3570c3e145@rivosinc.com>
References: <20251205-v5_user_cfi_series-v25-0-8a3570c3e145@rivosinc.com>
In-Reply-To: <20251205-v5_user_cfi_series-v25-0-8a3570c3e145@rivosinc.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1764959808; l=2983;
 i=debug@rivosinc.com; s=20251023; h=from:subject:message-id;
 bh=UW9zPS2E4TbdsfJtyu+1aU02XU1fbJS+cjnllb5pNMY=;
 b=f2KU+fCOkVj7mMjxZQYYSKXqi4DC7zhXlZZWWremH2iJ9TKnGVTmf9UQKwNWQYisAJhI9NDY8
 wDPYzH1n8XfDJHQBz0URPXJgVJBe8mEcqmkwauMK0YTBxPK3RkLVc7B
X-Developer-Key: i=debug@rivosinc.com; a=ed25519;
 pk=O37GQv1thBhZToXyQKdecPDhtWVbEDRQ0RIndijvpjk=
X-Rspamd-Queue-Id: B2169C0008
X-Stat-Signature: egtbd97p6r8dno8o9x46wzrz4hqwzdjs
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1764959853-603802
X-HE-Meta: U2FsdGVkX19qRXkAz+79JtReaY2/GjK0E8auI6k4XdhhyqMoOC8gZN0ClRWeQk4SZNFCNIC7Pl8qJFbAXq5fpsRNT4Z3gkdjuIF2SPqwFy+jB8rq97l6b/X6PjkDuc0/9EhJYcTc+ucLnch6hZEX0V+DOJMuTY0Flwg3bCeolMkNcnMOcIYvAz8X7SSL6ERVMZSlGp4A+izJuvpeCkq3k0V7yWJwff9t0pwaxTNDzgoJl8PbnoPBmhytV4XIi5F28XrbHBE1qKASTg+lFUlQOVyJVBhvW/lnsYOI8A1jhyqPUIw4U4+FeZUNE6Xm+G3m+XmBxrl3tM6+uaPUpYE4DhJeXxEOfpk5xUDhZKNsZ9PEig5xXW0xY1fjJdCK2lgerC7nsG77zvhw/GnSXGRAF/97LsiLWvwkwiMpF9iHSBq3QxqCsM/hmvsZhYrvhZZ/RaGQyNx89wQJAf8Fj8rd94gxw/KS7so1EiqbMe8dRv7CgpE7W+WgG34tfp9EsXa16DOpL75VFmwEb9RoJqL5Tp104W3A48n8EKQ1FmAjeZOGlKwyowZAJ+X6D6Yd9P2GgMi6VUk6k/NLWcZyDTcekOY0hHB9M7rmw2DXH5GMQmzbEIj1guwRPsYTVwopzYezfpnmeZm8Z9NnNaokj4wN4eSSfbxx4CyJDPsw1ejp2H3gERaYgqJErTql5UR4Gx51nLPq59pEdgKjhRjGVdr+cHY/BaTg2P0xDVa2QVT4vtj/Dgn8oP1gHBao5XlmJ2ns3sRW4gx9E8t5X+0zyvHnHmE0rAp5y4ROILFJ57OcEo3dHbGZJbrGpHaLA+fmtg9dBmtjfujlX59NGaPnIb+SJKdy/9OGQCZR3uJiuYqfAixLssbzsIucbYnZ2r5vMpR2Uxa4WBqr3NnWIpo9JWfuG8Vwk0qi88gYSfKxJg++kEKFGFdyz7L9s3IIBfL8+7fKej4v0bH4lxSz36MTTEP
 xFcOd5rI
 /Fv6VVHhH3EJSctjbMZYW0IPRPlgNJNNb5QZC9Y+c+flhKKwLRrpZAd6dVKzXXqqeGMiRkvIWR6GztStu1sryPvm1U3fcKRguD5pF4O1Tb0xsLruawHgiwW80+FZDcUDUi47SLri3wb1FBknOwcn0mO75zB1s7CJdKEefGVnMvVUvZRF/iw8V1J3Zv2r/S/q/QWxepQ6GsKo711poo/oBNYofVukMpwRP3z1k7edxDX0yfzJxW9mCOdvOtnOk7/cWDB9wqa+QkmL4RIiqshii22qqywtXUH7n61SETyeY16ZzVUhrJIOxv8mlQvgbA0ijZ3IQU39ctapZpooN9R0I8W85QvH/s2XwMmOz29UmmU69v6qRIv00SfAjYRG8DqyHmYH/HZoXP9GcSiesghWy+X+RAlXIdoRP2n9IlLBuA3Xf14Xib5eR2VeCbT6fM5Rwzct+x0Kkh0/flF+bGr602VoLoLJHs5cWhoL3bfMxjx3iyj5iz8KTZIkhfgsyxxMRpqa4YFg3SCg6L5zN8SUSzuQa3aJ3ZVnR7lCQ
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
Tested-by: Andreas Korb <andreas.korb@aisec.fraunhofer.de>
Tested-by: Valentin Haudiquet <valentin.haudiquet@canonical.com>
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
2.45.0


