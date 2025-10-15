Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63883CCD199
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 18:14:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5EDA18E0074; Wed, 15 Oct 2025 14:14:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 59F1F8E006F; Wed, 15 Oct 2025 14:14:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C81B8E0074; Wed, 15 Oct 2025 14:14:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 213478E006F
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 14:14:26 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E3D791390C4
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 18:14:25 +0000 (UTC)
X-FDA: 84001148490.23.E65E54C
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	by imf30.hostedemail.com (Postfix) with ESMTP id E831780011
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 18:14:23 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=Z+qdJYzV;
	spf=pass (imf30.hostedemail.com: domain of debug@rivosinc.com designates 209.85.215.181 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760552064;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l+hioWfUWF0s+MiuUM+GlCDJCZ5YXjJVkBV4mURgf5Q=;
	b=1EdB+vcNwLQwhRMbAb5cTP6M5s8/giXWd3K4yYT4Dvi0Q0wPRSYsiNRQ6jlQYHzEMvPFZw
	xjkPKdbOtYcW6ek78Sp4TX+QbO83SOmfhig5Gl12Z7Br4OSyiQ6K4JEpWJSXnZy+5Y2/Oq
	PVL5eCefn85RxSTgG3kg0sV31qrgz8I=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=Z+qdJYzV;
	spf=pass (imf30.hostedemail.com: domain of debug@rivosinc.com designates 209.85.215.181 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760552064; a=rsa-sha256;
	cv=none;
	b=eTUkVcvDlwHNsUPXSAxzSLARAh5Jlwr4mitmkpZfpdI9Twf44wHHuvvmBR1SpKK89AQKyo
	6Oc4SQaphFPPcMNq59ZxzRXTPiyPYdCl0NV9aLvxN5htJCfAEwW3MPk9Y3iOgik1Iur1+i
	BaJ1v8UmQ+6nV1xBG5KZ5xvHy4F9nLA=
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-b4fb8d3a2dbso4802151a12.3
        for <linux-mm@kvack.org>; Wed, 15 Oct 2025 11:14:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1760552063; x=1761156863; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=l+hioWfUWF0s+MiuUM+GlCDJCZ5YXjJVkBV4mURgf5Q=;
        b=Z+qdJYzVEoa7Ck7BH4Efx40TH/2mHOB7UhlCWhFKYYhMGlAsvqBEXhm4l6jflcGQHL
         i6vgDiKXbDBmBG8Kzk0RQoqJ/zMH9LMcP76fcbJrw9JIJGzQCQFN9qQ37CJ0q0aPRqGF
         ge4Sx2P/rXYSwk7RWfBuo2csVvXHP6tHoC1yQKPb4tm0G2mYheE3nxzGh2ffbr9+Bq2L
         7CFc5I881VH4a6nE+G1hSA7pIYRptbMX/99xhla2ktyeIuCAzd8kaD7IfmCQqFdtd3Ns
         W/igejUVThKAoOKaOcoy4EKpsK2zTieIVBqJA5lffK8wOLkSkL5Zp3H+xzY1WKLJK7eM
         nUBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760552063; x=1761156863;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=l+hioWfUWF0s+MiuUM+GlCDJCZ5YXjJVkBV4mURgf5Q=;
        b=bgBWfpBRATF6h+J8hR+DaiDi+tpXBbcQKN7FR2TVPwkg7qZzB97ghHcok11LroLZX+
         ZZMy4AppscKwH0xHlSvQygYkez0i4W54dIQ8CHBn06GrY/D4UeSDcel8Y4T4NaRwoBqF
         q+fQ72n7p3KWfZvI2hqtTw4HYvTKOjsiKckgl1uuTduzSar9sHgV8czRJsYtzM54Jew8
         RMTv5XqVZ6aO3lLbwzy2ulwDZPPil3EghNpRzryzkxnz3A+E1ocOdq5DagfR+0tMAymx
         RaN1ekhL9PZ+Z85jNyY65SD1jwkVUwZfYavGQi67sS3pmoeKWyZqUOteUtS2XeUeVsOv
         lFxw==
X-Forwarded-Encrypted: i=1; AJvYcCXiC5tal2LX1RMqsMqtkAKG9v7V0Nax0RsMEZ0P3if7wuijfN+4KCHpWBLkGBaPS7nCi6OTq4EhiA==@kvack.org
X-Gm-Message-State: AOJu0Yyt91AyRrhR7wFAlmzsuNgT5I+dX1Qagw8r8/JzpokHdhjIltrA
	Qu91FzRosklBB4T3wTFPsbDlxP79VYrvAyahWZ73lt5OGbobwPU61NY1fA31AyvA91vHZbvT/WU
	9ESIX
X-Gm-Gg: ASbGncuPbuIWkxCB0jRozcMDxSxMEmCzM2/3bzAr7VEPPJmDfbyr4xM8ub/tJ0QIWo7
	HOMdayybQoQfUxOQFFV42w2sfOfdx3yJbUL/0+M+az92TbigbedHquX4qGfC1VEybSNOGAqccyp
	9FJytOF5PEFQT4cYE4yZnFTlPneZSdFcd7ElrO5sDUIJGu5EhvveIKf4wWXyQsUhIuSjRwfKs7p
	nq9PlPuSJqhPoN8dcaFXZe3Wowt1RL+hcOXCN/xj37XmgsTvMxOFDIuUjJKPnAP3vKK0yDXDc8R
	jkuiWpmLni3ig65QDiY+a2aO8bZBfVBrTlxad63MRrUfifQeDX3iqVVxxE1e7CeLDqW1A4VLtdw
	HuQh8nOUfSTRp+bLSGfC60DfHGoZaH7RQBvznQcUDBR4CjHUnGjZDJ0aOWxWoyQ==
X-Google-Smtp-Source: AGHT+IEmusB23JqoF7lYxeYcbCpkPOw54RW4RQUYTK3oSp77Zw+WE67eAab6Pp6xpvID0rEAYTPJgg==
X-Received: by 2002:a17:903:ac7:b0:269:9a8f:a4ab with SMTP id d9443c01a7336-29027321d6fmr313904545ad.60.1760552062542;
        Wed, 15 Oct 2025 11:14:22 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2909930a72esm3126625ad.21.2025.10.15.11.14.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Oct 2025 11:14:22 -0700 (PDT)
From: Deepak Gupta <debug@rivosinc.com>
Date: Wed, 15 Oct 2025 11:13:49 -0700
Subject: [PATCH v21 17/28] riscv/signal: save and restore of shadow stack
 for signal
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251015-v5_user_cfi_series-v21-17-6a07856e90e7@rivosinc.com>
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
 Deepak Gupta <debug@rivosinc.com>, Andy Chiu <andybnac@gmail.com>
X-Mailer: b4 0.13.0
X-Stat-Signature: 81771q6qnyhobhxh9fecc89x6643wcpw
X-Rspamd-Queue-Id: E831780011
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1760552063-278412
X-HE-Meta: U2FsdGVkX1+wgJTWVC2ck2hR1ymljkp6id5OcS29VQAXkVf+V89Vc5pX0PyZ1YiKKzTZpmrzpE5QnHAjLfezDuCmH6PzZBpDTDDJmN2TSHZ2gE2Qyum8aZmqWbrM987pyBnFY6DJGEe+HcefEr5+x+V1Qb2ubgHY7jK3FACDzDOCQ+nHvwikd1q1ASmRDaKcrInN509kBvX0VoEFNRrzm6P3dDL8pqISvlmwZbP8l8X7WtPJj3QenF+v12ttoOXqtO633Hq54NwzD22BkgDPQOFiagkdxck5VxBF6EHBcsvtXwyMy1tU6BQLUEuJ2zvunTDx+npq6KxMfydKhuW5gnWTVBHw/HXuemfiv79YA93GWL9ONOSWqW+n/WdxveZmFiNEhI46jH8TmxHlmnMTmLgTbbUu/BXT9pZtqE4uLu0riBArzEcaAzV692wpks5jNqYli0iScxfacLMJ5YINEMDzQcfztoae8SQX77YBhEqjYwIMYieF6yPj8gM8GCH9f/myeiMfTk7cHun//aaEfm5kwizauX3G1lz368F1NmgtSYzk6Ey8hS9pOqfql0l9iwcq7zHzs1zs3bwgYLi/bRqFTewQrVNsjXNzTOs0+FX28VhosrbbttiFO/mERR4x/T69nJ+tQSTxFDIMUfIqzv8ltsSAMLNROAjWIWyZZ3KLhBK8bwLJO9CEXh0jE27G/w/9YCTx4dOXsVwZUgbsagLMe1nm5a84j7FkbSGKGGW4Tnlai5xzFR0j5OIPZxnsrlnynNuDre3jgB1FSzzveGFp2YAtFnFFq9NAJhuzm0o+kedgTf/t/0XkQ/uzEX+ao4HNx9nk40b5PXrEugzUy/6zTkJOGXTvARnWlMInOsS+bR9Gx3MnDN7xn2XaeOEV/332mpifQFVQvkzAVDx5L7wV5q2T00IlbTJaf+n3+Ng4GoR00hJ+srWzyCJ78DZpQ4rgoGwqPi1EnCgxP0g
 t8ddDkdB
 NLYIad4SQjA0UGYk/Lr91mCZf0870kN2Sta+aR6g4T907HsJeVLxd0ARFuN6cy6+t2Kih/9kLxXRJvoONhtQwn86hdKLTB9aO12fzjgbhoFS3zGLLNFRsD08v2HznY15RjJfag7zDVz3Kaj0xsCRdLcqWZ623Euw6MBu2YGOI4I6t/zDdhRxl7nhQd3izWBsoqqPgoXkjYP19IQj//vl8Nygeajar1QULT7rZ298b8NBRJ+5mc1jWMNCOUzMBNkOjms+79psTu8czJpLeTilosPhQ9lfGIL2STC1lADkEn4eOe5pTMiKEG25+xScW06W6oaro8II5PaYHswao+Dcv064XGlQFlvkeTqFj1qHFCbEc+EJw3s9zuANUcrCZ+S9L4+oApM/Ti5t7gZSU+pFvF8HP5PpJ10VvD0vkvxZCVSDLya6IpMfr4Tt+8g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Save shadow stack pointer in sigcontext structure while delivering signal.
Restore shadow stack pointer from sigcontext on sigreturn.

As part of save operation, kernel uses `ssamoswap` to save snapshot of
current shadow stack on shadow stack itself (can be called as a save
token). During restore on sigreturn, kernel retrieves token from top of
shadow stack and validates it. This allows that user mode can't arbitrary
pivot to any shadow stack address without having a token and thus provide
strong security assurance between signaly delivery and sigreturn window.

Use ABI compatible way of saving/restoring shadow stack pointer into
signal stack. This follows what Vector extension, where extra registers
are placed in a form of extension header + extension body in the stack.
The extension header indicates the size of the extra architectural
states plus the size of header itself, and a magic identifier of the
extension. Then, the extensions body contains the new architectural
states in the form defined by uapi.

Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
Signed-off-by: Deepak Gupta <debug@rivosinc.com>
---
 arch/riscv/include/asm/usercfi.h         | 10 ++++
 arch/riscv/include/uapi/asm/ptrace.h     |  4 ++
 arch/riscv/include/uapi/asm/sigcontext.h |  1 +
 arch/riscv/kernel/signal.c               | 86 ++++++++++++++++++++++++++++++++
 arch/riscv/kernel/usercfi.c              | 56 +++++++++++++++++++++
 5 files changed, 157 insertions(+)

diff --git a/arch/riscv/include/asm/usercfi.h b/arch/riscv/include/asm/usercfi.h
index 4501d741a609..ec4b8a53eb74 100644
--- a/arch/riscv/include/asm/usercfi.h
+++ b/arch/riscv/include/asm/usercfi.h
@@ -8,6 +8,7 @@
 #ifndef __ASSEMBLER__
 #include <linux/types.h>
 #include <linux/prctl.h>
+#include <linux/errno.h>
 
 struct task_struct;
 struct kernel_clone_args;
@@ -34,6 +35,9 @@ bool is_shstk_locked(struct task_struct *task);
 bool is_shstk_allocated(struct task_struct *task);
 void set_shstk_lock(struct task_struct *task);
 void set_shstk_status(struct task_struct *task, bool enable);
+unsigned long get_active_shstk(struct task_struct *task);
+int restore_user_shstk(struct task_struct *tsk, unsigned long shstk_ptr);
+int save_user_shstk(struct task_struct *tsk, unsigned long *saved_shstk_ptr);
 bool is_indir_lp_enabled(struct task_struct *task);
 bool is_indir_lp_locked(struct task_struct *task);
 void set_indir_lp_status(struct task_struct *task, bool enable);
@@ -71,6 +75,12 @@ void set_indir_lp_lock(struct task_struct *task);
 
 #define set_indir_lp_lock(task) do {} while (0)
 
+#define restore_user_shstk(tsk, shstk_ptr) -EINVAL
+
+#define save_user_shstk(tsk, saved_shstk_ptr) -EINVAL
+
+#define get_active_shstk(task) 0UL
+
 #endif /* CONFIG_RISCV_USER_CFI */
 
 #endif /* __ASSEMBLER__ */
diff --git a/arch/riscv/include/uapi/asm/ptrace.h b/arch/riscv/include/uapi/asm/ptrace.h
index beff8df80ac9..261bfe70f60a 100644
--- a/arch/riscv/include/uapi/asm/ptrace.h
+++ b/arch/riscv/include/uapi/asm/ptrace.h
@@ -127,6 +127,10 @@ struct __riscv_v_regset_state {
  */
 #define RISCV_MAX_VLENB (8192)
 
+struct __sc_riscv_cfi_state {
+	unsigned long ss_ptr;   /* shadow stack pointer */
+};
+
 #endif /* __ASSEMBLER__ */
 
 #endif /* _UAPI_ASM_RISCV_PTRACE_H */
diff --git a/arch/riscv/include/uapi/asm/sigcontext.h b/arch/riscv/include/uapi/asm/sigcontext.h
index 748dffc9ae19..d22d0815d605 100644
--- a/arch/riscv/include/uapi/asm/sigcontext.h
+++ b/arch/riscv/include/uapi/asm/sigcontext.h
@@ -10,6 +10,7 @@
 
 /* The Magic number for signal context frame header. */
 #define RISCV_V_MAGIC	0x53465457
+#define RISCV_ZICFISS_MAGIC		0x9487
 #define END_MAGIC	0x0
 
 /* The size of END signal context header. */
diff --git a/arch/riscv/kernel/signal.c b/arch/riscv/kernel/signal.c
index a5e3d54fe54b..1bcda11e0680 100644
--- a/arch/riscv/kernel/signal.c
+++ b/arch/riscv/kernel/signal.c
@@ -22,11 +22,13 @@
 #include <asm/vector.h>
 #include <asm/csr.h>
 #include <asm/cacheflush.h>
+#include <asm/usercfi.h>
 
 unsigned long signal_minsigstksz __ro_after_init;
 
 extern u32 __user_rt_sigreturn[2];
 static size_t riscv_v_sc_size __ro_after_init;
+static size_t riscv_zicfiss_sc_size __ro_after_init;
 
 #define DEBUG_SIG 0
 
@@ -140,6 +142,62 @@ static long __restore_v_state(struct pt_regs *regs, void __user *sc_vec)
 	return copy_from_user(current->thread.vstate.datap, datap, riscv_v_vsize);
 }
 
+static long save_cfiss_state(struct pt_regs *regs, void __user *sc_cfi)
+{
+	struct __sc_riscv_cfi_state __user *state = sc_cfi;
+	unsigned long ss_ptr = 0;
+	long err = 0;
+
+	if (!is_shstk_enabled(current))
+		return 0;
+
+	/*
+	 * Save a pointer to shadow stack itself on shadow stack as a form of token.
+	 * A token on shadow gives following properties
+	 * - Safe save and restore for shadow stack switching. Any save of shadow stack
+	 *   must have had saved a token on shadow stack. Similarly any restore of shadow
+	 *   stack must check the token before restore. Since writing to shadow stack with
+	 *   address of shadow stack itself is not easily allowed. A restore without a save
+	 *   is quite difficult for an attacker to perform.
+	 * - A natural break. A token in shadow stack provides a natural break in shadow stack
+	 *   So a single linear range can be bucketed into different shadow stack segments. Any
+	 *   sspopchk will detect the condition and fault to kernel as sw check exception.
+	 */
+	err |= save_user_shstk(current, &ss_ptr);
+	err |= __put_user(ss_ptr, &state->ss_ptr);
+	if (unlikely(err))
+		return -EFAULT;
+
+	return riscv_zicfiss_sc_size;
+}
+
+static long __restore_cfiss_state(struct pt_regs *regs, void __user *sc_cfi)
+{
+	struct __sc_riscv_cfi_state __user *state = sc_cfi;
+	unsigned long ss_ptr = 0;
+	long err;
+
+	/*
+	 * Restore shadow stack as a form of token stored on shadow stack itself as a safe
+	 * way to restore.
+	 * A token on shadow gives following properties
+	 * - Safe save and restore for shadow stack switching. Any save of shadow stack
+	 *   must have had saved a token on shadow stack. Similarly any restore of shadow
+	 *   stack must check the token before restore. Since writing to shadow stack with
+	 *   address of shadow stack itself is not easily allowed. A restore without a save
+	 *   is quite difficult for an attacker to perform.
+	 * - A natural break. A token in shadow stack provides a natural break in shadow stack
+	 *   So a single linear range can be bucketed into different shadow stack segments.
+	 *   sspopchk will detect the condition and fault to kernel as sw check exception.
+	 */
+	err = __copy_from_user(&ss_ptr, &state->ss_ptr, sizeof(unsigned long));
+
+	if (unlikely(err))
+		return err;
+
+	return restore_user_shstk(current, ss_ptr);
+}
+
 struct arch_ext_priv {
 	__u32 magic;
 	long (*save)(struct pt_regs *regs, void __user *sc_vec);
@@ -150,6 +208,10 @@ struct arch_ext_priv arch_ext_list[] = {
 		.magic = RISCV_V_MAGIC,
 		.save = &save_v_state,
 	},
+	{
+		.magic = RISCV_ZICFISS_MAGIC,
+		.save = &save_cfiss_state,
+	},
 };
 
 const size_t nr_arch_exts = ARRAY_SIZE(arch_ext_list);
@@ -202,6 +264,12 @@ static long restore_sigcontext(struct pt_regs *regs,
 
 			err = __restore_v_state(regs, sc_ext_ptr);
 			break;
+		case RISCV_ZICFISS_MAGIC:
+			if (!is_shstk_enabled(current) || size != riscv_zicfiss_sc_size)
+				return -EINVAL;
+
+			err = __restore_cfiss_state(regs, sc_ext_ptr);
+			break;
 		default:
 			return -EINVAL;
 		}
@@ -223,6 +291,16 @@ static size_t get_rt_frame_size(bool cal_all)
 			total_context_size += riscv_v_sc_size;
 	}
 
+	if (is_shstk_enabled(current))
+		total_context_size += riscv_zicfiss_sc_size;
+
+	/*
+	 * Preserved a __riscv_ctx_hdr for END signal context header if an
+	 * extension uses __riscv_extra_ext_header
+	 */
+	if (total_context_size)
+		total_context_size += sizeof(struct __riscv_ctx_hdr);
+
 	frame_size += total_context_size;
 
 	frame_size = round_up(frame_size, 16);
@@ -359,6 +437,11 @@ static int setup_rt_frame(struct ksignal *ksig, sigset_t *set,
 #ifdef CONFIG_MMU
 	regs->ra = (unsigned long)VDSO_SYMBOL(
 		current->mm->context.vdso, rt_sigreturn);
+
+	/* if bcfi is enabled x1 (ra) and x5 (t0) must match. not sure if we need this? */
+	if (is_shstk_enabled(current))
+		regs->t0 = regs->ra;
+
 #else
 	/*
 	 * For the nommu case we don't have a VDSO.  Instead we push two
@@ -487,6 +570,9 @@ void __init init_rt_signal_env(void)
 {
 	riscv_v_sc_size = sizeof(struct __riscv_ctx_hdr) +
 			  sizeof(struct __sc_riscv_v_state) + riscv_v_vsize;
+
+	riscv_zicfiss_sc_size = sizeof(struct __riscv_ctx_hdr) +
+			  sizeof(struct __sc_riscv_cfi_state);
 	/*
 	 * Determine the stack space required for guaranteed signal delivery.
 	 * The signal_minsigstksz will be populated into the AT_MINSIGSTKSZ entry
diff --git a/arch/riscv/kernel/usercfi.c b/arch/riscv/kernel/usercfi.c
index 2ebe789caa6b..8bc3e1e3f712 100644
--- a/arch/riscv/kernel/usercfi.c
+++ b/arch/riscv/kernel/usercfi.c
@@ -52,6 +52,11 @@ void set_active_shstk(struct task_struct *task, unsigned long shstk_addr)
 	task->thread_info.user_cfi_state.user_shdw_stk = shstk_addr;
 }
 
+unsigned long get_active_shstk(struct task_struct *task)
+{
+	return task->thread_info.user_cfi_state.user_shdw_stk;
+}
+
 void set_shstk_status(struct task_struct *task, bool enable)
 {
 	if (!cpu_supports_shadow_stack())
@@ -169,6 +174,57 @@ static int create_rstor_token(unsigned long ssp, unsigned long *token_addr)
 	return 0;
 }
 
+/*
+ * Save user shadow stack pointer on shadow stack itself and return pointer to saved location
+ * returns -EFAULT if operation was unsuccessful
+ */
+int save_user_shstk(struct task_struct *tsk, unsigned long *saved_shstk_ptr)
+{
+	unsigned long ss_ptr = 0;
+	unsigned long token_loc = 0;
+	int ret = 0;
+
+	if (saved_shstk_ptr == NULL)
+		return -EINVAL;
+
+	ss_ptr = get_active_shstk(tsk);
+	ret = create_rstor_token(ss_ptr, &token_loc);
+
+	if (!ret) {
+		*saved_shstk_ptr = token_loc;
+		set_active_shstk(tsk, token_loc);
+	}
+
+	return ret;
+}
+
+/*
+ * Restores user shadow stack pointer from token on shadow stack for task `tsk`
+ * returns -EFAULT if operation was unsuccessful
+ */
+int restore_user_shstk(struct task_struct *tsk, unsigned long shstk_ptr)
+{
+	unsigned long token = 0;
+
+	token = amo_user_shstk((unsigned long __user *)shstk_ptr, 0);
+
+	if (token == -1)
+		return -EFAULT;
+
+	/* invalid token, return EINVAL */
+	if ((token - shstk_ptr) != SHSTK_ENTRY_SIZE) {
+		pr_info_ratelimited(
+			"%s[%d]: bad restore token in %s: pc=%p sp=%p, token=%p, shstk_ptr=%p\n",
+			tsk->comm, task_pid_nr(tsk), __func__, (void *)(task_pt_regs(tsk)->epc),
+			(void *)(task_pt_regs(tsk)->sp), (void *)token, (void *)shstk_ptr);
+		return -EINVAL;
+	}
+
+	/* all checks passed, set active shstk and return success */
+	set_active_shstk(tsk, token);
+	return 0;
+}
+
 static unsigned long allocate_shadow_stack(unsigned long addr, unsigned long size,
 					   unsigned long token_offset, bool set_tok)
 {

-- 
2.43.0


