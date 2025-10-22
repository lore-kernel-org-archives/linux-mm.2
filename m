Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37C6FCCD1BF
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 23:29:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C6A48E000B; Wed, 22 Oct 2025 19:29:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 102208E0002; Wed, 22 Oct 2025 19:29:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F0C338E000B; Wed, 22 Oct 2025 19:29:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D90438E0002
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 19:29:51 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8F1818864C
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 23:29:51 +0000 (UTC)
X-FDA: 84027344982.15.403C665
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	by imf28.hostedemail.com (Postfix) with ESMTP id 972C9C000B
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 23:29:49 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=PBcemzWI;
	dmarc=pass (policy=none) header.from=rivosinc.com;
	spf=pass (imf28.hostedemail.com: domain of debug@rivosinc.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=debug@rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761175789; a=rsa-sha256;
	cv=none;
	b=pUXxUmSKw7cpl7ztpiI9wyBtBNZ6NkQNQzK6YVIirJHkfKZX+h9t2/eoKxmW/7L7pERecb
	L1xXeYYLH+62S2IF7L2zmOaQOTgDfXms8M0aM3ZYtkQ0jTmAxtnBGpSJ+n0JLvppftbG+j
	9hVzrvCVDek1ElrYVvDgIarLynquyIY=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=PBcemzWI;
	dmarc=pass (policy=none) header.from=rivosinc.com;
	spf=pass (imf28.hostedemail.com: domain of debug@rivosinc.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=debug@rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761175789;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MT7G2FWEtOvbLIeJ4rFRIEDlr9+XyxGZrLE08/iHBzA=;
	b=U2RYlzlbBVI9eK4ChknjlfJC+/AcQMGxK3GrR2AmkBF0HW6tjXp32etbuZVBgeqpZ3QJV1
	xyOuNq+nfQOPZTKR6+9Ji4iBX1jQfYTrd0/5HoEeV6S2iew9SlTI40EOae/6XFLzzl6TB+
	dEK1JMV2ygWYBGYcpAeDgSa+9qyb+30=
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-76e2ea933b7so170325b3a.1
        for <linux-mm@kvack.org>; Wed, 22 Oct 2025 16:29:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1761175788; x=1761780588; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MT7G2FWEtOvbLIeJ4rFRIEDlr9+XyxGZrLE08/iHBzA=;
        b=PBcemzWIfulU644P7UfoKW6uSZbIMowW12YExYIDmNhfpYktG70cQnwtoQbApsHG4n
         wnRN018bM9xCP3Ba69VyXemynCK8Sa7kXOKHVdfwtuaNpovSP1Oc6tCpXgudF/smZOs+
         MO2J6XY+TGuQGhHZ6JMk44waEtWRb+2fYWsFkkYUsTUmV/m2Qr5t8V3sxzPK0LGCDzS5
         rpY+hkudmM0iwqmVr7bjwlQxW5MCf5OGvIlrqjJYQwFCnhQPxrAU2bWPYeRvUPMqxAq2
         C2m/M4LEVqhH3LMoUdPXui3xpuK1+7JKNmQetEhGApfoAOfq67Dsi/Yh8LdsLw1sWFVQ
         9YJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761175788; x=1761780588;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MT7G2FWEtOvbLIeJ4rFRIEDlr9+XyxGZrLE08/iHBzA=;
        b=YaI7drUbAFFZ4+m0zYQ3bBQKsT1xBaHB14kNrn+SQI1zekV1bRjtwjrhY0qgePIxRG
         r274xMUOJc3DuZbceshfqUMh83R8sgp7B1tuggxYZJxYoCCqHL+lRx/9Qf/P/Ktx/3YH
         m+4JDDoJXCn5W3oUAz5sskyrHzpUfMLc6055K8ki6XpquSj6tFMcb5bBDPy9pFW9+96o
         3qJ6YLZp2ZAguXLrr7Vi2B077FHPQvHPFL22WK2ZwdjQVQgUeGDrNVEHX1GVHH1U/B5e
         Iw0hxv5vLVEFaTkc9A5a9gvY+bm3gsm5/fUZSxCqaUQE6NuIouV2hiscDswGIobE6WMJ
         mZZw==
X-Forwarded-Encrypted: i=1; AJvYcCW0r4PeTwUZZ0U89YlDU/cWmm+hIXksCjgamX/7etNnX/aoKQd/EqEITXumTYU4PnpnoEKl8vNXsQ==@kvack.org
X-Gm-Message-State: AOJu0Yz1OrpnL1m20t2s2sdDc4ObFC2fZAUVYHKsno5CtoCfAgbbyau3
	fniiS3puG8+FSzveeF/ISX1kPm47MY/fxCA4lJ1TneA7YJnzB15AH/D+Oft2SAn5VHk=
X-Gm-Gg: ASbGncsMWUgogoerYzLlvCGW3Kcz4o6eT8xJ/qeXa3//ti1WO9FEHQUJxuwxr4yr+4g
	QOFBdiudwCI0hgkM+cfix/HFqmdYNgSRiwzvsVA2vAR3N1aUv7eGJYjo8czCNU2cKfEQVEeWui3
	Qh1fL5h60ettxKww00cV3cAtaJtDY3FeaFZLvqgM0OLhNadduqc6WG5TZlYQuecd1cAyBn4hC66
	s9XOLKApSOQj//Mm4UL3gi+UTyWK+xslt5boI9LT8sawkxEo6G42JKV8hANlGT5ydS4ZvV4Wgc1
	KHCPDRTv+FzcHf9J2OEHcX4Zr/NcF8FN8BERNwSntu98OtmVgWfYaNr8hV6jJH+gAFQCVHU16Na
	o86eRVWaYJN8D9M3xph7RUHLDnY1aWvJY81pPQxdEykl/TRFAaOJp1noRPKnaPjlqO4yg7xc9sz
	SYLKq6c0zAcai26+UnFmFs
X-Google-Smtp-Source: AGHT+IFJrD99AT1GPkEdjNgaczEVZ5BBMes1aow9qnmWkHtYysKIO8R7ix9CzZyv1gwdzsgzCnWfSQ==
X-Received: by 2002:a05:6a00:1a92:b0:772:6856:e663 with SMTP id d2e1a72fcca58-7a2647a54afmr5238393b3a.8.1761175788374;
        Wed, 22 Oct 2025 16:29:48 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7a274dc12b2sm392646b3a.67.2025.10.22.16.29.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Oct 2025 16:29:48 -0700 (PDT)
From: Deepak Gupta <debug@rivosinc.com>
Date: Wed, 22 Oct 2025 16:29:31 -0700
Subject: [PATCH v22 05/28] riscv: usercfi state for task and save/restore
 of CSR_SSP on trap entry/exit
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251022-v5_user_cfi_series-v22-5-fdaa7e4022aa@rivosinc.com>
References: <20251022-v5_user_cfi_series-v22-0-fdaa7e4022aa@rivosinc.com>
In-Reply-To: <20251022-v5_user_cfi_series-v22-0-fdaa7e4022aa@rivosinc.com>
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
X-Stat-Signature: x9jm8jd41k6x9grsno8je9nmxpt9pyg4
X-Rspamd-Queue-Id: 972C9C000B
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1761175789-633162
X-HE-Meta: U2FsdGVkX194HY9Nn9coPPhIk4yEUkxkcpai5Kr4aJxsxo5vhS5JQCUxpuoos+UzuySK1WJ9hQiTP+Rt5gRyrtbF4JvwLvL205oBKL5AK27TTMJcGSeV9tj2lXJqEUhvyCVXFNVyctBVt1OAMLeFu7kVRZ2xjiTWihJNG5PKeQXm3DcgzDYVCeKe9OGUbclGZo+0fV5OTMEFNFmaOOaBwqI5N+W1c2qAwzfHROHdxPrvPBiPe4c+9y9D1Ht9ukyY/tRrLF5PtD0cC6jcqEPm2hr1vTWzjuwUZYIdfVpAv+WiIwQ1vs6KsNb7j/ZT44INtobhTHVUFHLN8IotJCsiSJf4MreZhsQYv37votSAFKKEsXxBWReuCnzqxV2ebdo0l1ggBowa/lgQEUsWEfp86GqPZos/TGKVVDql3LacC6qMiNNVjFNvEuKbVDuFZTpD1kCcAsiDDRjASBwbjU5oBnsawiKE1imgNEhWnKPabr4lDZJ3vkaFNkXF32Z5gQjCTilDkO0kQ0ADzyITluOGdNHGK6ZmW8P0oASj0TfXxxXyO5w7bLEdBqQEdVTgbCTiQiwrGvfauBk7/TBmOVLCo+spuHT+k7lbL0s2LNGuhTzNkOwFZzsD9yjvS74PpGhCeyqt3dMB0z4upkalpiLSsucb0jhMpU6mgVNcD0mIs15IHOMi0lJ5Ir8gjKs0frPx2e4eIYH16hZuSkr5W/yKdbWfaY5k9v6zWjTEa2LFKnwWJpLRwUFdMpB92UoKeBfNsMZn2i9cH9CjV3HCXkXL1QZol/ZRLDWA5oUrFfmqcR30NNp54A+H4ZZtA5MIuSgXM5Xe12pIQontN36OFzBbS1bf0Objw5zzoy/hxu0WVqhm+xBV/oMxDiot1Oe02D+1wSabPsQ5o4m0mgqrv8zlVgpw0BGbLh1tRaWUBktnz3/W06pUurrTG6+AVp0hs6eEGl00Ds3XEOi3FfewPyd
 nEViQOfW
 7w0Ofaf1q6Fr/g2pdOxEP6wx2JBJq5ujR1U2i90P0T4QMG3qt9Rz/d9aoUCNo/1jaQ6jemIMjpjwJkJIJlne6+1HKqrkuAmHKyKYFnWdndzpCwCaLzCVwtobrldP9TlcbHaU7VQOVhpqkuTrz019ItkKQM8ve4eBGeI+8Y3rKHu1qTEaD9hWEE2NLQR+a2jLJEhVgDoX3ThGWFulorJ/CaCJHD16gkGG1DXRMIWSqD2AVzMfOgm9H++7fn/wXfnyehtX8wi8K56rCHxOIgH7Aw1yadpD9Jaas51tL5MQq9jP9j21RS3iYIRFiHdg253Edwm9Z9f1J/56Uu+x77euY4dooZyl6JIMPlnlQ4FsdhAJhd2qnKIIMCuyRCuKX3WG3wKS4P76GcG7ureeLfec9pV5FfDapQ5Ax9kEpRvHCK7Phs4GRx1rvIEJrE/yR+PrkuwccUrMQXR4RCIKKNJ7jMMNAq/qfKsriQBDdp/xUZSR84m/yl33/VSqRE7mHt7IeoC/FnykiRvbYICg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Carves out space in arch specific thread struct for cfi status and shadow
stack in usermode on riscv.

This patch does following
- defines a new structure cfi_status with status bit for cfi feature
- defines shadow stack pointer, base and size in cfi_status structure
- defines offsets to new member fields in thread in asm-offsets.c
- Saves and restore shadow stack pointer on trap entry (U --> S) and exit
  (S --> U)

Shadow stack save/restore is gated on feature availiblity and implemented
using alternative. CSR can be context switched in `switch_to` as well but
soon as kernel shadow stack support gets rolled in, shadow stack pointer
will need to be switched at trap entry/exit point (much like `sp`). It can
be argued that kernel using shadow stack deployment scenario may not be as
prevalant as user mode using this feature. But even if there is some
minimal deployment of kernel shadow stack, that means that it needs to be
supported. And thus save/restore of shadow stack pointer in entry.S instead
of in `switch_to.h`.

Reviewed-by: Charlie Jenkins <charlie@rivosinc.com>
Reviewed-by: Zong Li <zong.li@sifive.com>
Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Signed-off-by: Deepak Gupta <debug@rivosinc.com>
---
 arch/riscv/include/asm/processor.h   |  1 +
 arch/riscv/include/asm/thread_info.h |  3 +++
 arch/riscv/include/asm/usercfi.h     | 23 +++++++++++++++++++++++
 arch/riscv/kernel/asm-offsets.c      |  4 ++++
 arch/riscv/kernel/entry.S            | 31 +++++++++++++++++++++++++++++++
 5 files changed, 62 insertions(+)

diff --git a/arch/riscv/include/asm/processor.h b/arch/riscv/include/asm/processor.h
index da5426122d28..4c3dd94d0f63 100644
--- a/arch/riscv/include/asm/processor.h
+++ b/arch/riscv/include/asm/processor.h
@@ -16,6 +16,7 @@
 #include <asm/insn-def.h>
 #include <asm/alternative-macros.h>
 #include <asm/hwcap.h>
+#include <asm/usercfi.h>
 
 #define arch_get_mmap_end(addr, len, flags)			\
 ({								\
diff --git a/arch/riscv/include/asm/thread_info.h b/arch/riscv/include/asm/thread_info.h
index 836d80dd2921..36918c9200c9 100644
--- a/arch/riscv/include/asm/thread_info.h
+++ b/arch/riscv/include/asm/thread_info.h
@@ -73,6 +73,9 @@ struct thread_info {
 	 */
 	unsigned long		a0, a1, a2;
 #endif
+#ifdef CONFIG_RISCV_USER_CFI
+	struct cfi_state	user_cfi_state;
+#endif
 };
 
 #ifdef CONFIG_SHADOW_CALL_STACK
diff --git a/arch/riscv/include/asm/usercfi.h b/arch/riscv/include/asm/usercfi.h
new file mode 100644
index 000000000000..4c5233e8f3f9
--- /dev/null
+++ b/arch/riscv/include/asm/usercfi.h
@@ -0,0 +1,23 @@
+/* SPDX-License-Identifier: GPL-2.0
+ * Copyright (C) 2024 Rivos, Inc.
+ * Deepak Gupta <debug@rivosinc.com>
+ */
+#ifndef _ASM_RISCV_USERCFI_H
+#define _ASM_RISCV_USERCFI_H
+
+#ifndef __ASSEMBLER__
+#include <linux/types.h>
+
+#ifdef CONFIG_RISCV_USER_CFI
+struct cfi_state {
+	unsigned long ubcfi_en : 1; /* Enable for backward cfi. */
+	unsigned long user_shdw_stk; /* Current user shadow stack pointer */
+	unsigned long shdw_stk_base; /* Base address of shadow stack */
+	unsigned long shdw_stk_size; /* size of shadow stack */
+};
+
+#endif /* CONFIG_RISCV_USER_CFI */
+
+#endif /* __ASSEMBLER__ */
+
+#endif /* _ASM_RISCV_USERCFI_H */
diff --git a/arch/riscv/kernel/asm-offsets.c b/arch/riscv/kernel/asm-offsets.c
index 7d42d3b8a32a..8a2b2656cb2f 100644
--- a/arch/riscv/kernel/asm-offsets.c
+++ b/arch/riscv/kernel/asm-offsets.c
@@ -51,6 +51,10 @@ void asm_offsets(void)
 #endif
 
 	OFFSET(TASK_TI_CPU_NUM, task_struct, thread_info.cpu);
+#ifdef CONFIG_RISCV_USER_CFI
+	OFFSET(TASK_TI_CFI_STATE, task_struct, thread_info.user_cfi_state);
+	OFFSET(TASK_TI_USER_SSP, task_struct, thread_info.user_cfi_state.user_shdw_stk);
+#endif
 	OFFSET(TASK_THREAD_F0,  task_struct, thread.fstate.f[0]);
 	OFFSET(TASK_THREAD_F1,  task_struct, thread.fstate.f[1]);
 	OFFSET(TASK_THREAD_F2,  task_struct, thread.fstate.f[2]);
diff --git a/arch/riscv/kernel/entry.S b/arch/riscv/kernel/entry.S
index d3d92a4becc7..8410850953d6 100644
--- a/arch/riscv/kernel/entry.S
+++ b/arch/riscv/kernel/entry.S
@@ -92,6 +92,35 @@
 	REG_L	a0, TASK_TI_A0(tp)
 .endm
 
+/*
+ * If previous mode was U, capture shadow stack pointer and save it away
+ * Zero CSR_SSP at the same time for sanitization.
+ */
+.macro save_userssp tmp, status
+	ALTERNATIVE("nops(4)",
+		__stringify(				\
+		andi \tmp, \status, SR_SPP;		\
+		bnez \tmp, skip_ssp_save;		\
+		csrrw \tmp, CSR_SSP, x0;		\
+		REG_S \tmp, TASK_TI_USER_SSP(tp);	\
+		skip_ssp_save:),
+		0,
+		RISCV_ISA_EXT_ZICFISS,
+		CONFIG_RISCV_USER_CFI)
+.endm
+
+.macro restore_userssp tmp, status
+	ALTERNATIVE("nops(4)",
+		__stringify(				\
+		andi \tmp, \status, SR_SPP;		\
+		bnez \tmp, skip_ssp_restore;		\
+		REG_L \tmp, TASK_TI_USER_SSP(tp);	\
+		csrw CSR_SSP, \tmp;			\
+		skip_ssp_restore:),
+		0,
+		RISCV_ISA_EXT_ZICFISS,
+		CONFIG_RISCV_USER_CFI)
+.endm
 
 SYM_CODE_START(handle_exception)
 	/*
@@ -148,6 +177,7 @@ SYM_CODE_START(handle_exception)
 
 	REG_L s0, TASK_TI_USER_SP(tp)
 	csrrc s1, CSR_STATUS, t0
+	save_userssp s2, s1
 	csrr s2, CSR_EPC
 	csrr s3, CSR_TVAL
 	csrr s4, CSR_CAUSE
@@ -243,6 +273,7 @@ SYM_CODE_START_NOALIGN(ret_from_exception)
 	call riscv_v_context_nesting_end
 #endif
 	REG_L a0, PT_STATUS(sp)
+	restore_userssp s3, a0
 	/*
 	 * The current load reservation is effectively part of the processor's
 	 * state, in the sense that load reservations cannot be shared between

-- 
2.43.0


