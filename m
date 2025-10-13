Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2C8FCCD183
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 21:56:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 112378E009F; Mon, 13 Oct 2025 17:56:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C3D38E009E; Mon, 13 Oct 2025 17:56:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E57B78E009F; Mon, 13 Oct 2025 17:56:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CEC358E009E
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 17:56:35 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A0FA6BA6A8
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 21:56:35 +0000 (UTC)
X-FDA: 83994450750.02.E738315
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	by imf03.hostedemail.com (Postfix) with ESMTP id AFCB520008
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 21:56:33 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=N9plz6Gx;
	dmarc=pass (policy=none) header.from=rivosinc.com;
	spf=pass (imf03.hostedemail.com: domain of debug@rivosinc.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=debug@rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760392593; a=rsa-sha256;
	cv=none;
	b=YXdM0tum1mTTu6bcTniUfJqBXsnBlfSXaC9vHOU7NQlivjTMy/FpE/i2C5GjwWbPKDb+9D
	S6fQnNl7gglH/MFy0t/VcGTAAQTJCXCAIbY1O9Xbv768d9AhJfahD31FyOb6e93L5Pq5J/
	hmFJqAmB0eqAvtfs3RNGckiY8brv7EU=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=N9plz6Gx;
	dmarc=pass (policy=none) header.from=rivosinc.com;
	spf=pass (imf03.hostedemail.com: domain of debug@rivosinc.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=debug@rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760392593;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AJ8YuZo0JJXCWTlV3c5ln2FfCDj9ZwahQ+XrbVt5Sig=;
	b=jiefeYTpB4OkA01xfCjV4xTZIlw0N/3fWtsfJGsf9pkFZYKlXb7limmIE9otW+Nue7qHcs
	nLXMFOitNKAOQieJmRRfp4lDUmg1u6VfMKViFZ2B1R/UoK9W6MARxSZXVZV08K4KVC74Hs
	MgykeHduZOk0p5aX1Zk/ceqIeOUlkgM=
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-32eb76b9039so5992639a91.1
        for <linux-mm@kvack.org>; Mon, 13 Oct 2025 14:56:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1760392592; x=1760997392; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AJ8YuZo0JJXCWTlV3c5ln2FfCDj9ZwahQ+XrbVt5Sig=;
        b=N9plz6Gxffud5ByPg8lNz6oqyTTfqu2jVzfqRSMrFLXFlSP38ogw1tXwQULXj6w3Y2
         SjgvHBuhWBfYBQIkk5Cldj9jDIm5XkAY+7akSG1rnbcld7ZlhA+bNDHPz+KeToJSITf1
         pySIhOUpX35dpajfFuWWyAcQQITqOQJ8K7oHytoxb92K7X3GFXer+Z8Q/nL8O96UzX0i
         KgfYXDGiCwIkHdJHJYKcOCj6lEiumbYWUrADfmlnBj5rbb7ugVdbjXb0P0wkUjyyYOTr
         JjRipw4LZT5LNgXqEXwZrl8eV44WFvUPpywv2C/wMSYFMqfDLRj+nxnJewgGEK1mO5iz
         niDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760392592; x=1760997392;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AJ8YuZo0JJXCWTlV3c5ln2FfCDj9ZwahQ+XrbVt5Sig=;
        b=SSNX1ulfFrRbmNUgWa0ZM9czMI12Z7j6btiH8aMS33VLkub287X4+CVF/cVHYZu4fP
         EqTAc5xDl8IxlG3gdgokCbsq0KwRwx59o/kF5Wc3vNVqsLMUPMUMEXXkn643EBAv1Ck8
         6NMqG2FIKoIUesJ8+2llzesp36TXdxyCl887Eo/dP53O1lSynD2/YMbcV9r21eg21TbL
         bqDB4mYwmwwsi2pvrDD4qnmwrrduR6LzKyFiN/jKPifauItBJPxRZVLOgJqtezDC6pK0
         CGbPyXNxyf+FtpmcfBNXL1bot7FLGt1pbIunB1xfLlFwNUuU7WumygXZSrhKPf2xkWqH
         XU0A==
X-Forwarded-Encrypted: i=1; AJvYcCX9im00BY55ZiZtEtkSUYpjspwCuAmT5fCPeNLUNyCx6n3h4HsrpzIAnsfIlTmDXeW4p39BYomaAQ==@kvack.org
X-Gm-Message-State: AOJu0YxVPUHA6dvegUYAK+fbPuX59pbRV9OSA0LmIscEo1c5JzJcX3tR
	+0ZwH5O+EeYoBgjbx1+KPfHaL8f5wZlD49P4EVstzMP4YNgzA29YxogWrPHGJJFwalw=
X-Gm-Gg: ASbGnctoXJF5X3xfWBHKhDaU7btpU7TMnVZtJS0Tye3fXI/qtLK5I2wT/1Y0m8hkUus
	5uBgKOsNLuJRyZ6Oy5UVp8ek9uGyKFUzhSXlR0oQvrQYH25O3zZjvOZeHZCMl1rpHQMwb3iY3p/
	feveQYq5W2kIf6pcymvajFuKFb4koXktwbeIxpYWxjHpwUYr0PpSG4v4UXnhsxVpQPQyIO8bZGp
	rPVkAt7lh5iKglQfHn3rZgT6cV7ym2Ln/XEh5t0iT+cLu6ASe03JTcyDFLDU8LgK3cIWIoxoyWo
	v6CANa/m3/IUkW+fuKB2/6m+GdMMwGWv7gV0rSeJKxmsjRkYCym+v2n0/O3k08ZgdIZEQ2MxIb2
	1dZNVtRZjoBzHujqEI99Da+uFCbs/b1mFyQOFtvT9/MgpumD3HEU8+RINCYVncg==
X-Google-Smtp-Source: AGHT+IE4VGn07elYQKVEUQYU44OBV+76pji2Yc6kXyu+BJcDVImYjZ5tvzToR33l15+3FSGsJYkKNA==
X-Received: by 2002:a17:90b:1a86:b0:338:3d07:5174 with SMTP id 98e67ed59e1d1-33b510f907amr31855639a91.5.1760392592510;
        Mon, 13 Oct 2025 14:56:32 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-33b626bb49esm13143212a91.12.2025.10.13.14.56.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Oct 2025 14:56:32 -0700 (PDT)
From: Deepak Gupta <debug@rivosinc.com>
Date: Mon, 13 Oct 2025 14:56:07 -0700
Subject: [PATCH v20 15/28] riscv/traps: Introduce software check exception
 and uprobe handling
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251013-v5_user_cfi_series-v20-15-b9de4be9912e@rivosinc.com>
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
X-Stat-Signature: tu5bcgj8uxe7ikqy3zhzeoqq7otoftcn
X-Rspamd-Queue-Id: AFCB520008
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1760392593-929313
X-HE-Meta: U2FsdGVkX1/i5h41sz1/IbHCceKXZ6DBha8CiqTxHuQzqshA7iTK9c1GqfhYLZsaHEvdHBREQ0JsAmyTXhe1C7ANZzAoJ6+S9U6xkBkD5u8ShJE/oPiDHXj8zibVkX7f5GjEMnMGfA7Joel89BX/T9BUU7649dueCQbISrvWpAR2Wu9l7lBJ0jZ/kIHXFdC9QhOJVYLm19EXCdsO0nHU/n7SdTxInL2K85UnQZtRqzZU4mLv3Wv5zeJGyw8D+Jom2a0dWQJWjXtcN1cxyoxvCW4iwKhRsF1jhXANz/bIGdM3/94D385t24GzTRVWl1ur7u+FebSDkUtdnUVq3KTxDbIa4+pKWMHN0msn9IHFap0XsRgSefK15ItWMpN/pTttnNS9G8637267pS0mv4HkuuWMYAUR8hmt9fzcy6qZjcEJJwMprDxYtfi3l0UHITEYMnAXI562ky9DRg4O7BiFvyVdy/pW3mmwgLmlXhg0I4StIGq5GxVLhxhtlotS0TeDZoRhgptFv2ebeQ+R/yglHBzpzGlEji4Jt7XUdE69gxxJLH6GijTINBHn5ruFJfobMQUnLlraAxaAn+DWsljOxwEpIMPIJA3IkdP4RdcY1lJ4wY8rM26EgA75a9/nKhyphTUK8zOX45+3IewBtGy/MKn6kJpxqD9GZcGWHnNM27IpFbvtIKgZLcT7R4KFZDeRbpz6bhc4h5aaLtn1YK6TQcz4nEt2lXgEg8Ijo523sE9Tuv6d5kH44iRs3fKhsPHBliTxgCdn8Wmpq9gGzMkJiVa6LfloCsXWRFJ8xAjWmR8Ue4kPFZHCiE3GKqbv1X2hsZ/OGL70Y3vqAdBVCoZYxr9k5rzuvSC2DrlcMSAP+Mymo1guq+BUynWG2Dq4ShRDUBhiX3peOhddPucaPgxsi2P0R/Hg4kViP8LAztt8ZhTYCXtFcysC/5raDUtesqVB4ScfrMbDNUzQ8cRsQXj
 5JOFsGm7
 8aQZM+FgvMbpUpqz69IKxwaXUC80/rJlo1eIb7O0fw2yNIislXfOHojY193sUmSHETeOK//cbZLzncv7h3Ip37C5JX5diDuPHz3K2PAgwNPQ8w5Hivo0LZrktHzSBJ0kXelIOnEkGDRI2scJvrRH1iBMIL61lg2DQ/4EXaJpPE29kfWZS5ZBhi1kfMvX6+1ewCwqACsuc0Xlx7VWgHkePGeyyqF31i053LOuLPDNlcq3eriRZGZFV/zKWw7DtI57vzY5X7k18dFkYr0m1KqGWrhzc7euSyX+m4OfyhilaxFa4FZh9g/VQLEeUZM+Y2M59aSWdN3rvjOxjT72ayInO5KJfJJLPIVYxhhsDcrV8at+Ku8wO4xnti+effHAkbHjpmalnLBtUGlW5mXBWji4fditQlpRUTpEnDHC3qkR8MRsXh0QxsY3bEsNq1PQac+BQFF6IisE+1ojoX61NuZXXBbjBaoslvh4cCUE5
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
2.43.0


