Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 976CACCD193
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 20:53:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1CB648E0021; Mon, 20 Oct 2025 16:53:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DF2E8E000E; Mon, 20 Oct 2025 16:53:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC5CF8E0021; Mon, 20 Oct 2025 16:53:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DCB4C8E000E
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 16:53:48 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A122DB7FA0
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 20:53:48 +0000 (UTC)
X-FDA: 84019694136.28.43C6CF0
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	by imf23.hostedemail.com (Postfix) with ESMTP id A7EE1140013
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 20:53:46 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b="D/h0/oJ/";
	spf=pass (imf23.hostedemail.com: domain of debug@rivosinc.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760993626;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MT7G2FWEtOvbLIeJ4rFRIEDlr9+XyxGZrLE08/iHBzA=;
	b=frUnEV6pdXyXp9xnFD9rHx+7p3INnBx1q5FslEQaKsSjWUqzML880caU4ExzWoHQCw1icG
	FUItCw6gDbpPVoft5GVteeruU62+k26loElZMo2K12twp3RaIe9x/bBas7DudKqlAdDqN6
	ANG6U7T6tutJFOgxTXlctJc9Wqkg744=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760993626; a=rsa-sha256;
	cv=none;
	b=toQYI0JVGRB2auaaYxQ5GXmNjliLLC3joT1+JM87hj9p82+1WUFDTERkaCrMlBuba9KudF
	jktZkuzdGVwTlq94AtvvNuHYPQ8xir0BP8pFaGDRh1k/3J0XoMPoshFyCWiwVQwMxFWDBq
	8X0pc+OnZKWl38MTdCCNPiiuoMhGIxw=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b="D/h0/oJ/";
	spf=pass (imf23.hostedemail.com: domain of debug@rivosinc.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-789fb76b466so4010711b3a.0
        for <linux-mm@kvack.org>; Mon, 20 Oct 2025 13:53:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1760993625; x=1761598425; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MT7G2FWEtOvbLIeJ4rFRIEDlr9+XyxGZrLE08/iHBzA=;
        b=D/h0/oJ/XhjeEKhERZ+zqHlg4terGJYvrK0ZhveKWtwe4bG436dIzphh6ONT3e9CBd
         H7vRPDYf3MBtZ5y+hBsO+zeYUaUtVVw8GvgS696hPbd60fdrjL98qzgteU5lCB12PjQa
         oV4vaOHOX27HlLcWHQhCLSSOBxgEPkabU4//36njqsAKcvmPxwpRsoAqJmeZD+O+OLJM
         TMRq72ALMrKRdw7HKKEBrP4UCnS1ZI1BFA9RYkynzrwPspANIeKg8Gqblf/hGeIWSUoK
         SmcxaC+L72mJ1JKa0gCQNdISOAybd8zyBvxC2kcMmRlo5Ikpha3NU9/0hnJJiW1o31v5
         G6lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760993625; x=1761598425;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MT7G2FWEtOvbLIeJ4rFRIEDlr9+XyxGZrLE08/iHBzA=;
        b=vbmlmRwO3UkE8ik+uy0Z31AiBP7fK/puXSRck0KmoLdOx0ZFSp3bhBczmtxiO/tsX4
         6TfEAwRm2bNTehh6VVTQnFGHDlAHrvJbhVLuKnuKyPdFWXm5x8xNstoOoRCsL4UC7qNd
         TddCcUVggZfkm9zTPYOfCFdRdntrgQ+02jA3GIC5Tzz9fwJsTFg4M8n8tdF5ptNUu8es
         1tN9EieBC5Tm1LVfTRL8P+JI+cSqUUagwc5VU/hR4MAZ24PgOXjtxpOR7j9f5n9PXg1k
         oHr9CTiIM/MtSN6UgLCmarPQCEHHel+wTCSEQ73x847rohn2XFopCVI6cvzyDQJALPB+
         AdIw==
X-Forwarded-Encrypted: i=1; AJvYcCV9JLA9veunuCUG+WMsjrvq7VS+sSyC/8IpPLCrUQLtlNwtnQ78af5kG1Xm98jNfL0otrxaCMQn5A==@kvack.org
X-Gm-Message-State: AOJu0Yx71Am8o/HswC4Qt4+1fRzPx5lollcFp6znD0nQ0LpoiYgMpIAe
	3U9+4+dEPRhhjmXaMx7WJblYDiOANwkPB/44RVb7mQeOBtz9xXYqvStYyfsVer/RMQk=
X-Gm-Gg: ASbGncv5qvoJ/mphKqsDxbzCEZkzgHbMrJq4Tmub6jxwZS/9rsCK/QLCjDX6zzfRBMw
	EzUk80E0cW3fP7DLDe/CcstCU4ZwrNSRdW5zPZgFZMUSUVg0zZXYQlOHtIKOSpqahOW25JtSbnh
	EV8rxpK5lG/k6GJcejhwA+bWGzSxBibdmniFLiyAlko+6BICxsgAIAu3CoQOxf6AoOkrrtNchcW
	JysvI6qGGoCvrTu8qZFEfAtepQ6ES9ZvoQ6CeY1TZ17/S3vCGryloGxIoF71R1FvTz0eWm0x8cC
	mY4xXuadRWdnYMG4N8Q3t0UzqGQ+4bLmK8r3v44D/gVDTt1RT+0QIbJiiWkxfF0xC7s79udQP4V
	iFTvqXRVMVqv4xt6Qk0lG9ok8Bv9aanolJuOCV88ZNOePfdxcv0XyuteIX0c7cS7GLaB0cCpa6V
	yFz3U2aMPJqNQpDhjQQTSw
X-Google-Smtp-Source: AGHT+IGXwMYaDVdcIc8A66BKgGJixjgYHD56Xsel19AXjGE4Pyw+x/8QgXo63NUTPmJUti9dv8B+CQ==
X-Received: by 2002:a05:6a20:4309:b0:2da:f4be:c8d9 with SMTP id adf61e73a8af0-334a8606e88mr19355739637.37.1760993625361;
        Mon, 20 Oct 2025 13:53:45 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7a22ff1591dsm9453867b3a.7.2025.10.20.13.53.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Oct 2025 13:53:44 -0700 (PDT)
From: Deepak Gupta <debug@rivosinc.com>
Date: Mon, 20 Oct 2025 13:53:34 -0700
Subject: [PATCH v22 05/28] riscv: usercfi state for task and save/restore
 of CSR_SSP on trap entry/exit
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251020-v5_user_cfi_series-v22-5-9ae5510d1c6f@rivosinc.com>
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
X-Rspamd-Server: rspam05
X-Stat-Signature: ww1p74gpcowbrb9twrwjf33shaza8ucr
X-Rspam-User: 
X-Rspamd-Queue-Id: A7EE1140013
X-HE-Tag: 1760993626-762551
X-HE-Meta: U2FsdGVkX1+h9XyGBmkmqjaL2uOAzMRXl+XwJBEbn9PA5u3mwrafnQZfPAwPc0JceNUVBVCAMFypn/5fBEdDeLQQ2W3zcmChFhLGC+U+x4JvA9DRZeMh/AFKR0hrOHKtMVyhKJH5dc1IVxZr2O0EtPO/Q8qFmEVqLk2ZWILRUsWfM/lwnT5KlfC4qHNjPfvRvG3R9vmh7vU40Ngfm9X97MyH8yUwdUeKb9ZvcA64+lii1vAGAeXxlOX2VGMl5oRQHTyT/VuCGH/FqizJPrKtZQKwR88owXPqtr25pLeQ11JcuydBFFgJ/MoJ6Zcu576FYD1edo/df64xzxbtwvOyKNU68gfSHGVmeQ1zrgkKABAnvT2h7eQ/xCer2N6BeMY16TWh9zZtNZNr9kyJE/7/EJIzg2G2vBzR1kcqr5NpQrXmRnidGKmdPTYtsM7oZhuuzTF76/LHJX8I7aHkQluc30onBZIH3Ql1ffyMKM5nIWudiNVg8tjnWPDo8QTJHOQwGEcmtnwpjUe/0shL/0Sv7oc5mwVb9Ju6kwReH8jG/w1ti/4I7hoUxpwh6sJQCTyVW9PkRXupr9KLWTm66t73SdL6nK6Wx/86sc+cFAw3buOxDpO7ghnymNiQwpqZVeyQTt3kewcesbwBaFOzXIVaSCN25iNmATUgUvq+rjP//OYMoDIiFGvwcBSawroiluuCvqV6MY9GuO+lDwMDZwnSY9ODSfF9OESjS6r0UmYHdo4GVl0RMplQbRJoNkodFaLErfUBA5Ps7pV6dWOvnWxUDZp0ZmE4nwdPTHBb8bAgytaOy/6z3QbwJp6GzF5X0SY32R9CkJDVsx6WqxQvNMavFjShQeF6z6ebON3da1Bp7qrG+VsYJDHgvWv16kdi/3IuPKyaz5G51uSCN6L2NYlkURRjawVC0ifsJb65O3GnKEAp5zQVucphmEhibfzW/HCjzwkQ1pFL+VLNqmid0qG
 1mN58lHb
 lmmBkLzbSPNdq9YPRO/Cd+DDt9SG+Ra0jkUGthTqikCfFNsQBiC7kitFAMXI9UjKmIS1ymE851c4qDIp2TJlJjG8ZMtB13qWP3F6OU7tUJMWNSFHDyuZn86SY5KkQyPDE4Jvn/Z5n8JJRBWfNFcy5ZkFh1n5PCCL6RyTzU8KAfvoNKXmZcfCOhWoCyYLnZuQ5rqcwUacO6LBG1ntV2JwnCVW8Ltel7F8e7mImg27r7Ez3ja0a2SuiEajZwpCv1vaLZBXqFRvA29D8g6bEz9a/cGsFFQYNgX9MfDMTy+RkdoNykwDRKbQoRet2zREaevmTj6CB39Pn6PmZ3zy9kVWG9Xa0hrZYevBy/wt9D/j0QgUtFha5YyN4wKn0P2R6L7QnRtwTK7DaIc1xDW0mzXKdZWVh2FGGYJ0XYnHlW96324oQugmrJFpQSZvq5Xn0wTMej9T88Yn3tP7TY0uLbwZQeFmSJaPOkmdMD/Q1/nwYO3Jma8Dcn+88uUsqQJm+9//W/d9l1PrSserd4ZU=
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


