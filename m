Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0ADCED339B4
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 18:37:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 33B396B0028; Fri,  5 Dec 2025 13:37:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2776D6B0029; Fri,  5 Dec 2025 13:37:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0514E6B002A; Fri,  5 Dec 2025 13:37:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E36E56B0028
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 13:37:22 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B41BE1402E1
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 18:37:22 +0000 (UTC)
X-FDA: 84186275124.15.7C4F81C
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	by imf01.hostedemail.com (Postfix) with ESMTP id AB3A240005
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 18:37:20 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=W9A+y03u;
	spf=pass (imf01.hostedemail.com: domain of debug@rivosinc.com designates 209.85.215.180 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764959840;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qkB1OBwYWJndx0ys60aTo8BN+99UJkZg6h3GpJG4ezg=;
	b=Y3q7K2rIfl4ODEmeRyHjNH6rli6aupU2E9ERkkGZ7Cmnub/iT1h+caIiR4WZliZ4w1O18N
	hXwzHm8dOv9rsT98CaZiqYV7SDX7Mh179BgfZCiCrs7fHdgShRDegSPxmV4zkVpMyjzF36
	blEunovTnUzyJOoVjlwzqDuPm7PvSxU=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=W9A+y03u;
	spf=pass (imf01.hostedemail.com: domain of debug@rivosinc.com designates 209.85.215.180 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764959840; a=rsa-sha256;
	cv=none;
	b=LvtbTEzyq/0pJomdeIO6SD8qDqHICpHzpKCyiHij/V42tGqCTPV3xqzJ5rQqFr7oUUm/gE
	90JdcSf4zlouNLRg1ryDCN7f7IJHeE4ZCk2SpKpmTGwJJThIV51uy4GQU3B3EIVDdzZr2W
	Cy0+wixMiTMFwxs+pFsVDTO9xiQnsEk=
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-bc4b952cc9dso2161330a12.3
        for <linux-mm@kvack.org>; Fri, 05 Dec 2025 10:37:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1764959839; x=1765564639; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qkB1OBwYWJndx0ys60aTo8BN+99UJkZg6h3GpJG4ezg=;
        b=W9A+y03u2VjIfd7l3lFR0VlvZQW+v/atZMXzDZW/Ky2rOsW8YTQnaXxOH1HJ4W+8Ay
         RZcAh8ZiV7YlafAS8/uXm/R3bhJdkuMUvcd6a6JL9cOSUyqJiC0Pn7Xm/uvMHtnz2Rin
         u9zdlnMm3ZSh/LC4Lknl3wTZHlOppSOAYrRb6X3AvkBl2c8ynI/pvtuQDoSA74bcsXAI
         8fcRfDBYls6xlho0DW7XfU8wCL0vNhzi005L2x4iBkLJ6VQULA1zLQfEPoL9TfvYOfYt
         IYgUOYYUCH+jLgv+zMVso+lKf+lSbr8Oc2DAS9wjon6u+/VAL20Dx9jzq3M/6Pbp1zor
         UUFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764959839; x=1765564639;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=qkB1OBwYWJndx0ys60aTo8BN+99UJkZg6h3GpJG4ezg=;
        b=UykM8kdlgBNrlVLznmMm/LHcKAmQwupovVrk1vIU4VUaMN3SXub1F7rJiCY1oXhA5H
         SCjhWFTeh/itZfMBlTItpS5Z93t8IC8SOs0A6biOHdhl0jrAZpvhbrG/tcUkxi9JmmWb
         xhj2bw4690uyDQ10NKwZKFyR6ias4HrUsPITleetfzHTWeGIX3wJbufWJJ/iVnXqT//F
         j1ClsmAldqK2MQ9v7GIDpfpf5WcXwSajDO0kMCjvQp8JPZXqLKOmekk/2j3puZp82Ku9
         hjzMkFJuWXnEc5OhcBKB7eNqSSr1Xk94lmj+Qvucyzf5fngwWHFZlS03fjb2AgaoSvTJ
         MkHw==
X-Forwarded-Encrypted: i=1; AJvYcCV/Tc0W/WF7aNWkkmfv6srjd3BFh20no8ocPUNrYglWbo51nhvLda4zx0KfajRPsVfaWqMoTM8hDw==@kvack.org
X-Gm-Message-State: AOJu0YxF80T+I4U+wx+5pUa/ePfeWtZNVWeZqkTCzm+fZwL3/vsHXpe4
	HSpJJPeEdzfMKg9hDttmYFpdgKcd5Hg9gKHtRSxbgEf5TomewSQCvnUhUflKAJXPmnM=
X-Gm-Gg: ASbGnct7ZyVGiM7P7JuWa7soyz90JxaeOt173+8yfzfa6bpBwzf9jgvejMIFb9Yz+Kl
	JP3v61FzHez/gSPtIHNjoOnqPdVzHZr3FMqVt244Et3+u2aUrj+DBYsU+wJEr9THQ53zQz966py
	Goy4PcRAgT8HTVXbKhRzhKLpqPnmoKwsPZDeG2D6YKLlRtF9S1uDIlwT8Hq8UIsqDXf/tv9Bf2w
	RKb6aiVO5uDCN18TS562NUZeRr65NF99Yt5QKxa22wLrcgUSb7CCOb2OJziQVitCGi8tHqSbkdW
	Ipi/Unpo/1tOmBM/DzdTwDLXBGnS6qbz/nFvaCKku5OHlHTbNSE7dTyuIsD7IrM+hMLOd94CWWL
	g07azWeCsSNNdWjec+Hp8NCfEWVtuZp4V0ecDkVUj4QH9Igi7V426mvprggWqplzbZuM3a61evN
	cxtltJpiZM86yaqYTPrH+D
X-Google-Smtp-Source: AGHT+IFl2lAxUTxZd/UMHnfEN5SKsZETIp07mJeyrocE5h/Zbk1n3iF2dXhiweDrrsXrRh4LX4/XJQ==
X-Received: by 2002:a05:7300:ea0c:b0:2a4:5129:feaf with SMTP id 5a478bee46e88-2abc71545d5mr104904eec.10.1764959839451;
        Fri, 05 Dec 2025 10:37:19 -0800 (PST)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2aba8395d99sm23933342eec.1.2025.12.05.10.37.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Dec 2025 10:37:18 -0800 (PST)
From: Deepak Gupta <debug@rivosinc.com>
Date: Fri, 05 Dec 2025 10:37:01 -0800
Subject: [PATCH v25 15/28] riscv/traps: Introduce software check exception
 and uprobe handling
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251205-v5_user_cfi_series-v25-15-8a3570c3e145@rivosinc.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1764959808; l=5652;
 i=debug@rivosinc.com; s=20251023; h=from:subject:message-id;
 bh=TXKZlJ3jSYM/MfSFEFzUAEcoqyLgBWawjPARhtXC+wc=;
 b=fqqB8s7q3jrjphTohe1QCeqP2WPRZ4GGP7ZQ8Ioic29OTBcv30fNnz5G+Mgrb59scgz2SWJ/X
 2rmZL142WAuCMJ8/0Y9SBwZIg7P8qF/MehEGChXgsQ06e4Ooudno4ap
X-Developer-Key: i=debug@rivosinc.com; a=ed25519;
 pk=O37GQv1thBhZToXyQKdecPDhtWVbEDRQ0RIndijvpjk=
X-Stat-Signature: j6od71myndukfow17eiear3w94qsdoen
X-Rspamd-Queue-Id: AB3A240005
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1764959840-197869
X-HE-Meta: U2FsdGVkX18ZsklAJyjjRw2S+D1m6afLqQPZDUVeJAwDzrVadfvuKK3pqu4DJNtL9vOIfTY2QN1cOLlxSf4omaIeI16xy5sqo0v79T1IQYho6rVsP+k1xgjlA/2ySY2mqNEuSH6AQ36i1javLhO1v31sQTbweEEncEIdHiZbp/ZSlE0wXb+rlXytBVsfvVhTM3DXgWrz3L9dQ5RJxF3d7d7oerOGOBU4nSc86YdDIaldl5Mq6UBTW+Dp2vR4xjU/SurSZwnQIxSj6v/B7qIOJWJKbAP5IYL+G/75PEFoogu3gNjeUvgJlsIMxtFRvJXAfiQ/EeCoTrwWq5q6hgqZZT4zwPHD5LP+F97zHXaliX5+A4f6gV/G+eNZvD25fQNePXOPb9gzBtD1gfgtOQ0IAhIMcspYnS3xuNhLXkRcY/oP0Co4HdbPlia7tXTgsfHj4I5yOvz5jdwvVqySGsbzZ05KUeGoLyn7T+51yLA8soZf0ELgUZ/PzGgLk2v8fi7JLTwbbRpDYh3TE1TjdJKu0lF+cpY8Mf1ZEsc0yRzJonx04QaGiCKjGwwQU8REhpr5i7i2XEldjq6kR4jFWCdDFm1/JFAtXPLD/n1EfOj6pNEqDtZGBG3WdsQRmr/2WEgB8nKnp80+YGpmxQyDYSFRkyqxWrNpNI7qbBSnWakkyLBLuYaf4k/vZAMBxHan5aWIHTNia0z5X4h2Abpemce8oAPliLcpKsEVj3jrdrO6VMi2almm5QCI/ffXvQD1cE5bzWwc305FFbJ1M1bCJ0IY2ij/CaoSahtaJLSJsoyuREDty8NnQIxmkymXsuauyzE53rIaA19ssmPIPO1GU5IqGkk+FxZSI3u8n0lRFpjKaXIuxsOuC6XVHyagKWMpkvZl7B3i+84KWMgx3Kds0QBJuRv4idPUwGC+oppCOPA+ymqu/wxMVLewABBG1lCLP6IqMMWvJI6WoGFaixuhFMH
 1dRXOCWi
 /AQrTnqoeAhesSoh2ar0zGBVS5M++FtUh+9Yz+tin+t+MDV03ZnluyVHzVg1+o/GlDgRtEmmpcqXOYhRX5yV6Z853bCztNkXgUsjC4aePZdYnBdHhIKVAgeXCxOwQoYFn4Pz9lZRjJa7U2t9oSAEv96NVaDAp/LqcdHMmImaFcnG9tg/waGWdJNMLUTx7/XsV1IVs8Z0rjLVo/q1njNsVaq1O46xf0tYlfDXRfVcUtyxKTct/GAmp/sW79WHQ+fYL/BQdK8LUwkl69C+sOZ4KZG+Eew1JcjgIWfDZoshXHbFfXnE47jO86y5QOSvdle5iZy5C/jTdD/9IOQPpONhc040oPV+2ijw792hkQCeYn5l6cflOmGJKtUCmfc0WDXtvaiiUTgdYYBPPeR+srRRPwrf9YqsqUKd9y1ITW6gvrshUkeoK+ZlnY+Whn2R2f6YZ/aZdFNBlBHHqas9drporAD0i9oKPiuCILvXuXxEmlU9d7FPoVTh/UD6DN8dIbKe8cohfzK17ugNjoGBS3eyz+74TcrDkZuzQRq5p
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
Tested-by: Andreas Korb <andreas.korb@aisec.fraunhofer.de>
Tested-by: Valentin Haudiquet <valentin.haudiquet@canonical.com>
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
2.45.0


