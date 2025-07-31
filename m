Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED863C87FD2
	for <linux-mm@archiver.kernel.org>; Thu, 31 Jul 2025 23:20:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C6BA6B00AD; Thu, 31 Jul 2025 19:20:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3772D6B00AE; Thu, 31 Jul 2025 19:20:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 23E3C6B00AF; Thu, 31 Jul 2025 19:20:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0D6896B00AD
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 19:20:08 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8475E1350E1
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 23:20:07 +0000 (UTC)
X-FDA: 83726130054.28.B56428D
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	by imf10.hostedemail.com (Postfix) with ESMTP id 91C9BC0002
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 23:20:05 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=rivosinc-com.20230601.gappssmtp.com header.s=20230601 header.b="fNvofK/g";
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of debug@rivosinc.com designates 209.85.216.53 as permitted sender) smtp.mailfrom=debug@rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754004005; a=rsa-sha256;
	cv=none;
	b=lE3gdTO0F9sqyMqOH7m3Gy6ICwEHRZ2qSZ1xcPCFVdK1jcEL4WQF0tpisMybNrb6Ol/tCo
	hYvjad+Effu0ix2P9PGTJDUoitWqGBEC0vnmnxzwi7JsJvNxlQgrh6FDT98Ev3mFQNvJKD
	TcqWyGNtNbcc8kzrGRucCYqwKG/iKbY=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=rivosinc-com.20230601.gappssmtp.com header.s=20230601 header.b="fNvofK/g";
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of debug@rivosinc.com designates 209.85.216.53 as permitted sender) smtp.mailfrom=debug@rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754004005;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KN7qsbRJwSpz1U0f3zKk0nPzS36Kgnagxj2tSzWZKOM=;
	b=L16IELiiWnLvhRPWaiCJavqjdreJhLZqiP0uHwF74/PZ2yUY0uWuHwMSJU1LDXINcGErHL
	Bl4yRLEBnvmhtrK89/BxU4wq/P1iG29yYROtBof1mg55any/uoda6UaRXqhS2GRrkbSnZz
	6YQtucJpsYaymAR8d6mNzwTAQIk3omg=
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-320dfa8cfa3so937808a91.3
        for <linux-mm@kvack.org>; Thu, 31 Jul 2025 16:20:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1754004004; x=1754608804; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KN7qsbRJwSpz1U0f3zKk0nPzS36Kgnagxj2tSzWZKOM=;
        b=fNvofK/gZMWyHGIekV0SPNgZo45L+4KN9hAITXzsgsjxdWSqVf4PEu8OBQP+vs6kl9
         6AJsTF8PjWdVPlHajg2RFcl8nmas3q6Xsz4/m5qAYwtEYAzC/ccfJKvpS2CbmxyxTXTM
         5E5XM7269gY6lILSa0ADpc1BVq55V4gvi/vEtFFNuk/nDZBEetQ4K4gCSHC2YD6hdfu5
         E7p3xIzdpzwqSeZnLx5lAhpPIWpsuotx1YoAX4avXlZ6SPhDIY+v5l0gUhUUd2Iw5g3A
         8FBJ14e/YyMcciqTJQA3Rchn4skmT4JMOQw8pKvbA6F80TH4nNqZtAnIEkf1TT6EcaE2
         GIwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754004004; x=1754608804;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KN7qsbRJwSpz1U0f3zKk0nPzS36Kgnagxj2tSzWZKOM=;
        b=q8plUYBw51nOV0obiZDrWEhw8UN7I1pjzrtAdNHx1QykmjlMbf0uzkLZgYKEJfjhOH
         Ufy90Ziiq6NNGYILG/zt1iMD7XE4PpGznFcz6yE/4v5WIMR4LRDsTFeS2Fn4D8TqWZ0A
         qpzWsuZhgb1T6U9bhGlEYV886Vxw/Pydy5bv0GUjw1kkS8lQm39ANdROjv0GbiIS/Zdb
         Kz4W5rLLTIXY41VU5nHkJvcNw8H1xwSgThNCpKUcyOoyjGlRyJDBgQ1fzoLBPBpRWiWy
         cmIoDSKlVDi2TAAzJ+dgnkGXc6ZGCW2iSLPMSz0qPxuYsDYWTrcqH5l4R1URxi2tvG7g
         Wo7Q==
X-Forwarded-Encrypted: i=1; AJvYcCXGtImXP3M88KM9bTH0pDIOXkozW1nys87h1BVBDy2VVsjfxBZXrrXAE5NT6bOIVXsd37iem5PajA==@kvack.org
X-Gm-Message-State: AOJu0YwySb0NVQDxXtdXy4i0ISMJtUBgTTXta5fZ5xKHQ8AzdbBxxpF7
	MCn4e+xkZAIY3qMs7+MadMCx2/faH4EU2lImSeZAH4TqYjPP52Ol0602sY6fxrkE8nE=
X-Gm-Gg: ASbGncuGlFlUZ89xzGZ4OZPVES/D7gT8tUKSrXSuQEfDUPyRCeDS74qVFCXAMk3Tkek
	A73D7dF5lduzgjcTndxxVXuNQTwjEisDNWIPhFcPJlB/tIWYGCliTVHm2A/1j1fG88F63E6/XnO
	2kFyVVYRBdmnZrLNlri3M7WhfAFvK+cyr1C7adxx9DH5ljPOFw2E/H+DeY8+aSFoaO+3dbZWBP3
	9AXxvYYQ9hwOGKp/UlXIorlOLcCQwTBOprbrTaVczXUB9NIs/cmYWwGPS3qnKfkKfK3Nkcfp85V
	zsnV7k+ZPVRz7jdJgmvD2eBmaYRqP5gu7hFXWe3zNzJwuIzhzw/omkXK+v329rYP279wTBwNfuB
	aQV8MDFb6lmQ/7toAQCSI8DUDRs1qSErsmsjgLH8DgIw=
X-Google-Smtp-Source: AGHT+IHxrpjZfo/l2y5A/sxDDgOjavtB+BTRcJEcuhmKIdHQ5XFEf+Qh+iYbm7p4G9u0Pc3Qv/HPIw==
X-Received: by 2002:a17:90b:3ecb:b0:2fa:157e:c790 with SMTP id 98e67ed59e1d1-31f5dd7f473mr11237625a91.5.1754004004235;
        Thu, 31 Jul 2025 16:20:04 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-31f63da8fcfsm5773085a91.7.2025.07.31.16.20.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Jul 2025 16:20:03 -0700 (PDT)
From: Deepak Gupta <debug@rivosinc.com>
Date: Thu, 31 Jul 2025 16:19:25 -0700
Subject: [PATCH v19 15/27] riscv/traps: Introduce software check exception
 and uprobe handling
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250731-v5_user_cfi_series-v19-15-09b468d7beab@rivosinc.com>
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
X-Stat-Signature: b89ftoeofpjeucy1pdz8gzny6kmbrup7
X-Rspam-User: 
X-Rspamd-Queue-Id: 91C9BC0002
X-Rspamd-Server: rspam02
X-HE-Tag: 1754004005-159573
X-HE-Meta: U2FsdGVkX189swghAfMpDkvVkd8Q9YwpDyFEVEf4WkIn2dcNNdP78KKjQDAeFxu5RpvPk6Mro2lmnBh1l1si10QPAzX1qJVh5kcU8i3DgyhLUQc0i9M43KgJS7MbvXtkP78BQGmxwDFEPRAUOhsETM/8PVlflP6MOVTSKcgVO6Rm+7WfcKzJjRnAQzkYT9trhf+yIH03guzljzzSXyoRNFQ6sl8bVLTo63ScG57dH8ygRIHQnJ99f1MSZYzPRVRbDtbnbrchMhoPfcbHpNtGzfFqzfoOOHW49ft8lp7ZN8VSwK2BnCFWPGbIUwupOWMwNlXV7CmYHlxIB9juJTrQbledL4iCmqvJlX61EVqm5vU/u30P1nXMMAozyogrqbNvYPQU/JqzQTOeyPTZ1uL/8oF57I3dRfvVZffTVmcU0d5yN6SFq+N9gk5xpdlHCXH8HkePIaQfOPQNWSUuks32Rn/cGKzEKvu1gWuJd/PDbynbezmhF8fpfUUsiQJySVfU0pnucctwNMTygoA2GekmaBgXY50TrhJ2P3VIX6ZVJPPxcLaEHPhQHi3VL9ez69YUKzBR4JD22UEYRMRNIhalsXz77S73L7Jg85UBlnsGJJmlm8LbB1eEolJroTyfbWD6eoFaDoU8z/J8OO01TenGsPEE4NzjWNTN8KRr93PMZa8u7MUUqzmUFMKN5IkjMg/E6uKSvkyc1hQ5OydSvfBb2y1rp71LusqfJhi4s34wvarfHPKIT6On2SVESOSEWNsOhi5GQQVM5ZtNOEhc2c3CEgVK9niUCT9Ai892uazb6S/7L2iM7/AP5GUzdSQUMLU+aLh21Ai8qZFUcbkITqcOvOfd/nKOUK9EoxvUNDkS42NrQvdzeL7p/bX2vp8hkUnFYS00F2l/pDT6cf6wrmy/OnG9MWp1z8Kjxqz5UAiAzWikmrAr/6JXcpfZ9yqjNRstog3wYo0xuai6iKSjKB9
 6OKYT5kS
 HaFbApurwnAkrg246v1EBrZ3QLkknaQ4EoDseLMtXkgaJGn1ErYxJNcjCuzwmnNgjNt5jeKW11fjrM4wdFmEX8RVhuAHyigkOf8sswLX/CCriRKAZuhc4iJdHCYgkFom3S+4gfqBrxAZlYn0BRsOXMrlHpfZLg3EfE3v2KmuH9lVwFKtQiBJkifZRmwgGJ+C4NEMDttp8q/EXhIX0QMcFcItr4aIeEqvIm9FWn8srTX8ahGyElNMjFadGRM+rCK0CmmVPEKqLBk0ZvEg97G2r6bvtK4yJVWWo0ubUqspwbaoq7sfXrRXtdyu2xaKVzWEH5dKaVQ2/1fHfaIlz5+F8s/L1GX/4IJEPuBabRkLpTDFe3fUFX6oMDZznFdeuhrghL0JWUN9LjrbykAej0IThX9D2wD4B7gVnwNmCP6KH6pLvuBDfWAPh/zsOO0JinfUs/oABy48eo93xEdjVM5KhHDAmbmVtL8t2P+UCL5irVN5+PSJupF9xPh2KRuHrpq9F97DhihCw1n2RApT4U/yH8m4Uwu76XijVrac0N2LL1VRHFkMw3qbNpLi7HA==
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
index 633d66b5ae71..09954c6835ef 100644
--- a/arch/riscv/kernel/entry.S
+++ b/arch/riscv/kernel/entry.S
@@ -494,6 +494,9 @@ SYM_DATA_START_LOCAL(excp_vect_table)
 	RISCV_PTR do_page_fault   /* load page fault */
 	RISCV_PTR do_trap_unknown
 	RISCV_PTR do_page_fault   /* store page fault */
+	RISCV_PTR do_trap_unknown /* cause=16 */
+	RISCV_PTR do_trap_unknown /* cause=17 */
+	RISCV_PTR do_trap_software_check /* cause=18 is sw check exception */
 SYM_DATA_END_LABEL(excp_vect_table, SYM_L_LOCAL, excp_vect_table_end)
 
 #ifndef CONFIG_MMU
diff --git a/arch/riscv/kernel/traps.c b/arch/riscv/kernel/traps.c
index 9c83848797a7..2489abbbdb5d 100644
--- a/arch/riscv/kernel/traps.c
+++ b/arch/riscv/kernel/traps.c
@@ -364,6 +364,60 @@ void do_trap_ecall_u(struct pt_regs *regs)
 
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


