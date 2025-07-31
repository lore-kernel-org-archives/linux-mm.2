Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3F15C87FD3
	for <linux-mm@archiver.kernel.org>; Thu, 31 Jul 2025 23:19:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F1236B0099; Thu, 31 Jul 2025 19:19:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A19E6B009A; Thu, 31 Jul 2025 19:19:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 06BF66B009B; Thu, 31 Jul 2025 19:19:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DC2DA6B0099
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 19:19:36 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 640C81A0B60
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 23:19:36 +0000 (UTC)
X-FDA: 83726128752.17.9E9C690
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	by imf26.hostedemail.com (Postfix) with ESMTP id 77D39140006
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 23:19:34 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=rivosinc-com.20230601.gappssmtp.com header.s=20230601 header.b=O5XxsUEj;
	spf=pass (imf26.hostedemail.com: domain of debug@rivosinc.com designates 209.85.215.171 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754003974;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jJcDEj0kSL6FF+r1wSTl23b4dwmXD5irWs8+pcmXa0U=;
	b=BzE+mjF9YqvzZ/5k/w5/qgDuOkW8aNFe1OjXLz4BmrEzrI3GFIRMuJDlesQJ+JvUxdYwq8
	V1iTkOjxUTGitU2c1NAFuKd/B4/ReIJnzQoNxRb+w5g9oYPeQduAt65rNeNzp6ezBvZcS3
	j2xpWnNovPiyBvQ8+BJSMmhZ02be4Yk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754003974; a=rsa-sha256;
	cv=none;
	b=yDWwoFuUI+6n77BGs4YR9bYxQa8CtRapzFkhem+k+wUonaeMCRTLCmhlaLOf26xItW1W0/
	Ykp1bah1YpxGz8qIQLh4hzEdQRmhBivltZwlKXpqtJpdtDKlatQgT0lzpwrJhjp0ItTml9
	WWzL6aw6hSUZetjtcUhHYc8NHDN5Bd0=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=rivosinc-com.20230601.gappssmtp.com header.s=20230601 header.b=O5XxsUEj;
	spf=pass (imf26.hostedemail.com: domain of debug@rivosinc.com designates 209.85.215.171 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=none
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-b4233978326so590392a12.1
        for <linux-mm@kvack.org>; Thu, 31 Jul 2025 16:19:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1754003973; x=1754608773; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jJcDEj0kSL6FF+r1wSTl23b4dwmXD5irWs8+pcmXa0U=;
        b=O5XxsUEjtrhcOgrWg86UXbJm1cTrvv0yiRYeVUuJb8QS387bn9U8PXH2UvSbmQDdM7
         zbSHrc6VklgnQelms07v1KZkTcWTQrNNm/vgwG65JYkCNDbcNAzn1dfkOO6yNuaExt6r
         qHPlHJKeKi1f4NeMs1QEndDpRVd3awiwguUwT8H9OQZCACw2wU6FXhlPLc5f7cE1xHaD
         WpJPBq8qqM5EzlRTWlKFbWp2s9S2zClz5AJCwa8ALwKu58mZloMu56FbuttFBI6ujJa+
         J+FAj18L9x5M36ybVK2Cr+++i5KFjZUHs0QNUKwkOoFQqGPjYTe1B0+KR/qihRgzQeyf
         Zjcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754003973; x=1754608773;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jJcDEj0kSL6FF+r1wSTl23b4dwmXD5irWs8+pcmXa0U=;
        b=kGZWtbDHKAw+2KvFSdxWs8GYxt2Qq5/RQnUs5qhGT1Ka0vPIHvvyw45tk/cNr6444r
         ZxRIRD2efSv58xwL7oKHYuXpik7JA89Z6XHARNIVkYmXHjYaPYzc5TeZSAJbPBq6UAc6
         aFVmQdoLF1duan7YzK+t53G2QHt6P5ETmtYewmU6HJSmpP0PkWpLk9HkVHzi90r4ZZUc
         Vd4BaL590Dj3V4qyvFYDwhoJL6TACT7ix9HbcC2oQeBaLnSPgEPzV/p6QRfKOdzU0H5Q
         1/H+b2Lm4ABve8ypLqgThxacwAz1Zk/GTfasJElR8D2RxFgWjtoXYL0z3e+sXVetqbRk
         UJFw==
X-Forwarded-Encrypted: i=1; AJvYcCX+JGLM57lNTrMoO91BufsPlVbhA7tasL8Bm7iSX3pHPzMKSOgHNbqBEbbirAXKqA4dfV/pU4gSmg==@kvack.org
X-Gm-Message-State: AOJu0YzluvEJ/GjqeP3t5a0vwUIiTXJuHCswXy5uFKAXkj2+OsDNKKTv
	9O9AGOABLpLMi+EkEvNgG8GhIKek1DyWn8CIWFdFa+CfLtyMNtk1f0BFgu7o01W8ZU4=
X-Gm-Gg: ASbGncs7CaZ18yNgN3NZtlBkIddLdgY3t1PgLU3zZ1ly81odi/zXvywcHnpbyOiuTzb
	PLxGMKKx6D3B6YdusRgUmvLRuIn0edWvMInRUCtazcneZxKoygqQFSb+DL5H/WG+9K+r5mc2mEC
	NSMsgQ/3IYI+oiofIfAmTfQAxDr6HwqsOWEnQJa143iRYYM0KgsjXCv2kIT4/CFOePoeH+psjyt
	iOLIU7QkOwi1NcjJHcMjHoDRV83xbiq53VI2LxkRZ4okx6zChAKcUO4SQsopviJGO6T/V6gSuID
	WS9o3ZVbQavT9b6A/t9v18S2OLX7MTl6g/gO5QWV+vB3M0Ghi/rrxdKyeZmkWVdF2uJ/eP/RzvE
	ynyQD+Wu/lT9uN7sV4DWG9MuRgIIS4b0316979NIm01E=
X-Google-Smtp-Source: AGHT+IGMEQ5niniQ3qLa5MxtUOLxlUvWpxLuHsKl9h9OLnJQ1EjG9uF9gu4DhTCezHIarNxo3AhVnw==
X-Received: by 2002:a17:90b:1b06:b0:313:283e:e881 with SMTP id 98e67ed59e1d1-320fb77b1c0mr935071a91.11.1754003973247;
        Thu, 31 Jul 2025 16:19:33 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-31f63da8fcfsm5773085a91.7.2025.07.31.16.19.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Jul 2025 16:19:32 -0700 (PDT)
From: Deepak Gupta <debug@rivosinc.com>
Date: Thu, 31 Jul 2025 16:19:15 -0700
Subject: [PATCH v19 05/27] riscv: usercfi state for task and save/restore
 of CSR_SSP on trap entry/exit
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250731-v5_user_cfi_series-v19-5-09b468d7beab@rivosinc.com>
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
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 77D39140006
X-Stat-Signature: es9o3uk5s596yanwg7xod71udsmsjigt
X-Rspam-User: 
X-HE-Tag: 1754003974-961966
X-HE-Meta: U2FsdGVkX181WyaGwJec0gd5oWt3pkHhITeTqdZTT8RX+3S9WwDSjCVlvTNzE6p8BdrihC+XBy4ePcgsCFUW5GJQ1XgCLJU/ea8h/zKnBvlNCH6hpMIfKKNQwUS5b8QrmN+b2XxvBTonWe+NAgKmMN1nwhG8/aU7mWzANbuNiL3W77NTZkLPp+1gijIbaFDGfKp22pHRGayVQhHk3Mp3Vv9TsrEoOf1uqoLfsoxEuqnPxRMvNwaHsbge485jGzGfDSxqToCNv1CLnWvdkZHgnVbKVkiKzshExwrF02PG4OfkrA04Kb8UQrcEFRyNp6O8HdTd6z1xs74lnTGb4EWYetk/+rH3LbLtfuV+muVYIon8gxQRoipZWkJGd1/zfj6wxEAkOIxVW5xQvz7lM1wRBdkikh4e1YJ2DZjNWixTsA9UbQcibYcvdXP5tVoaiJcMVMToDDuK6h0B60kEclDHYt2IHW9ilJVTVdyVsvQ0AfSojfZZT9ZrbF7IpzAXEA9dx9f+itYoOb6Z37cngVm2TW6xq9KVj8urAtwX+mWjJG0ceQbqWu8/zkMW//D3iB7mB1myKXyn5ouH+lsC+PpF3qN0Vj+oJBZcpO8OpuIwH1vrruddcsmwdqcP8J6M2WOD8wgGTCM2PYk2OnjuU/ZSDlYPxv9FRniCJn3aF4HWSb+cejnfmjpQnuMudjGwoveVSs8VaO+6nzJtD0LcntCHwXj01YgT7znIJU8KeSy7jfaaEAx+gZ81P/P9nZ4Jsju8e8BEChbZ6aez3KUy0i3oduyWzQUIslhYcQCURrufe8At1j18TdYGMg9khE4b9CAQJT74w4hjlnz2NDoMbDHdbVzlWdjZJQ0INZ+Ia6/dnCEPzmY9bmbhLv2TRifipMWI9U4mRFF90/IFXkgFW7WagGo1tDiS5DZ36JnRxbpzxyfSfPQtdSmvYOOIcRXX/8b3VARgWMO9Z9+aOIHcZZD
 fDe84uZn
 nPylMFH8SmPBYLF5x2pi16DmthNiI8OkYU/BXdctTtHBmVtGIqhKweMO9m1t+uhxb+cbXrwwY1wOHFOLr7wNmVepONMW1VNrPlV91z8k3UVyR0lUF86FkUdsrPPxM1p3JsLa021+U/3mCNEOBZYXbA4w5JSeh0GIH8acEoFjqwjcdxV3tvuL4eSTVBxLGUtPbKS75/U3M1EqV5d3izcoTszissG1ANysClLHhDaV4OJ1k2o6oZku3ypYXOMqZFZIMXGFQzy+IRNIvZbf5sXzdR0Pi8YaH8jH0XyGgPPPZuDLHhTiauUT5N8FsdoAQ+eMzxpjknNQM9Kvrxy5q1OEiz7+PMDaOZisJI7O7i48+K3ShCCFlEiGRblD+Y3KfSZPe6JnnyjvNtK/ATnirGCFxIySrPtt+rMKIQwdfVzygxWgiygVBV/ejdNyoOHfLtMI2NLWlT/fuX3f5gEv+67+0wdK9IqHHPOdhiQcxTsIciOfRY9X4UzKzaSIOHIrYcgK6XBdQRkthiat9Wiu0+HNVe8n2lFgNLc8+jj1dFFO4XQHAJhd+xPw2AgE1Z7lUVxCDryzNMN5lJukz3uhS+E3hgZrmY8jOMKTLBvBt
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
index 24d3af4d3807..05eb65fe9578 100644
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
index f5916a70879a..e066f41176ca 100644
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
index 000000000000..94b214c295c0
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
+#ifndef __ASSEMBLY__
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
+#endif /* __ASSEMBLY__ */
+
+#endif /* _ASM_RISCV_USERCFI_H */
diff --git a/arch/riscv/kernel/asm-offsets.c b/arch/riscv/kernel/asm-offsets.c
index 6e8c0d6feae9..9bd6c3e868c9 100644
--- a/arch/riscv/kernel/asm-offsets.c
+++ b/arch/riscv/kernel/asm-offsets.c
@@ -50,6 +50,10 @@ void asm_offsets(void)
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
index 75656afa2d6b..3513ade7a4f2 100644
--- a/arch/riscv/kernel/entry.S
+++ b/arch/riscv/kernel/entry.S
@@ -91,6 +91,35 @@
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
@@ -147,6 +176,7 @@ SYM_CODE_START(handle_exception)
 
 	REG_L s0, TASK_TI_USER_SP(tp)
 	csrrc s1, CSR_STATUS, t0
+	save_userssp s2, s1
 	csrr s2, CSR_EPC
 	csrr s3, CSR_TVAL
 	csrr s4, CSR_CAUSE
@@ -242,6 +272,7 @@ SYM_CODE_START_NOALIGN(ret_from_exception)
 	call riscv_v_context_nesting_end
 #endif
 	REG_L a0, PT_STATUS(sp)
+	restore_userssp s3, a0
 	/*
 	 * The current load reservation is effectively part of the processor's
 	 * state, in the sense that load reservations cannot be shared between

-- 
2.43.0


