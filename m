Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A0F8D2A522
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 20:04:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DCE876B0026; Thu,  4 Dec 2025 15:04:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D30A66B0028; Thu,  4 Dec 2025 15:04:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BFABF6B00D2; Thu,  4 Dec 2025 15:04:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AD2D86B0026
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 15:04:30 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6B94A897C6
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 20:04:30 +0000 (UTC)
X-FDA: 84182865900.29.7E22F0A
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	by imf12.hostedemail.com (Postfix) with ESMTP id 5EA834001E
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 20:04:28 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=a7XzUTSW;
	dmarc=pass (policy=none) header.from=rivosinc.com;
	spf=pass (imf12.hostedemail.com: domain of debug@rivosinc.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=debug@rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764878668; a=rsa-sha256;
	cv=none;
	b=e09PF5aTtCVVZh8uUFgFCbPoy2YmJxkDEOlfNgMWPQbuTkeYu+8hCIo3FFt17S+r8VAEaT
	XUrWvZxRaRDlmV8TI5xd6WHo4fCI/EWvnxqeZjXBuJt6MSOrxLUyvUnS0bUZqcjSdFLcbi
	ZsCLRQeKFQw9cGltpWy5KNDLmaeYbTY=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=a7XzUTSW;
	dmarc=pass (policy=none) header.from=rivosinc.com;
	spf=pass (imf12.hostedemail.com: domain of debug@rivosinc.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=debug@rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764878668;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mHOUzGluaxo3JyDkvm0DelDdzPjfzrCQtbG2RJzIJW4=;
	b=ZwlIYkg38NF/cP7/KTZWyajypGYe1AQsQhbGJLE2jIO8GpxxR/M45RRXQavtSxn3qEpI03
	OfPF91+zPEg2KYfIYvjBXUxwFJj4IXooXY2irj+MElZLMsF+DEkcRdDn2QyNHrtsxuNEp2
	53TaYccSVwrd1FMZDUdtp8psLzBtjuc=
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-7bb710d1d1dso2108363b3a.1
        for <linux-mm@kvack.org>; Thu, 04 Dec 2025 12:04:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1764878667; x=1765483467; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mHOUzGluaxo3JyDkvm0DelDdzPjfzrCQtbG2RJzIJW4=;
        b=a7XzUTSWjZ9WXsNYEruJySzLAvwmtHpH2VOCyLdGPZSS3rcWpofxFMPiO8059JpXK1
         14oF2pwBG3tGIGgEdOEvKeTmT2x9dBYSgIjB6tiJ/wcl6iai3hmvsinAEawtbTMfjlSW
         6fLu3VkT8AjnobLAMobPvW+rX6NbFOOEPwKhSpiuoUPvwW2Vcaa5D9jTFr4uPaVfU9uo
         EDUFx80k+1XZkuzvqN5/fjMmqqLrg3ZRJ+BIi/bF4udR4L0owxupzqqGARjC4O5cNTuM
         HRhASOh+7MG4n3eqfRF7hPXhqtu4RV0TdVYXhwf/9TbJe7IIL2nfGaMTEjcqrNVb8nib
         Ygdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764878667; x=1765483467;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=mHOUzGluaxo3JyDkvm0DelDdzPjfzrCQtbG2RJzIJW4=;
        b=hhxstjxvrEinpkTlucLlSKiD1DzosULsMh3mIwd91FNDFCQND91jnF44RQmTO7ZDVn
         vkn5szPVhUo68tqSLhPFCxLf/WB0Szv59xdWzO18FVzdD6fAn5KBICdK3N2vPpMKtNyk
         l54JixwqZazFVu3pADoonvkKDuBUwhHEpjZN1dpJL/Y+kKD6+M5qh2P9fRqf4kUQtk6F
         kZDaNbomdU3kfyIZlH4dUHw0tiQI5Zx13abGzbmsdcMpUVEkZZJDGh3Xeztlkn6J/Gci
         ysHNQzZmoMJGqlyH9R+htDwUDojlWIbggPmKrsPlrLOiaPSDzuJyV4ANM932XBmLsgq4
         6B4g==
X-Forwarded-Encrypted: i=1; AJvYcCVdFm0+qAzDWrEeXmsZgk9I9yD52oe2pJlJ6U/J5j497rAb1jZ6sn8weFl4Yc4iRsTXE7Y8HCALmw==@kvack.org
X-Gm-Message-State: AOJu0YzAzbEqZTdgToc2gOleAuJJHnYQgH2J0v+5lV81Icw2SGqta4zZ
	FHo7DbyIZKNJHeoO+0f1xv7D1KpgcbCtsREgegBlmTabvAsopwSV3LFq4uW0sv14X3Y=
X-Gm-Gg: ASbGncsBA+6vOS0DH4hyDRxgomawPjFICa+Mq5Poh7NuyMB4DDkmlcHwt4UgEiG2u3g
	rPGu2krKIqekozMsd5SfJq5tdUW1G1Abd6UbQZCGlV1rqfaWtRr01QJKOq/C5k2pwk3MsxkPfBG
	bAtkORHqo88GfOG2C4y1bsFifv856Gk88lC0GymqHx6Oek0UZq6ddSU+oUztIOpBUtbN4vUltgG
	v5xrC9zKkJd1TzaKSzWSDdB3MQnF4c5dHKKP2OaLjeASuhQa7ck3UhN17qnzmvkFKxVI3PP2RK8
	Nsp3WRl23RZKy5f4Znll3fdDxCZxsjjWRIczFQmxsJCX+zvsLv0yMKXeLJML3RpTdcChUmOj0JT
	04YriQ9re0PV7H+UzeMNaZeE2pMjwFFqG1RNIO+pBXe4wWdWJyf+YGpyKUY36CNubq+3K1YwxRW
	WXSbclGJbqCNo0h8ABGIZy
X-Google-Smtp-Source: AGHT+IGNLu7L4dxKZ303vItIG098+8ymQjbL/ZwPmdXmE6qFCt2YmM8p56pKX3RYmGLCYMsXVf+DBw==
X-Received: by 2002:a05:7022:ba8:b0:11b:9386:7ed2 with SMTP id a92af1059eb24-11df64bf864mr2937483c88.47.1764878666983;
        Thu, 04 Dec 2025 12:04:26 -0800 (PST)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11df76e2eefsm10417454c88.6.2025.12.04.12.04.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Dec 2025 12:04:26 -0800 (PST)
From: Deepak Gupta <debug@rivosinc.com>
Date: Thu, 04 Dec 2025 12:04:03 -0800
Subject: [PATCH v24 14/28] riscv: Implements arch agnostic indirect branch
 tracking prctls
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251204-v5_user_cfi_series-v24-14-ada7a3ba14dc@rivosinc.com>
References: <20251204-v5_user_cfi_series-v24-0-ada7a3ba14dc@rivosinc.com>
In-Reply-To: <20251204-v5_user_cfi_series-v24-0-ada7a3ba14dc@rivosinc.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1764878635; l=5844;
 i=debug@rivosinc.com; s=20251023; h=from:subject:message-id;
 bh=BmRDk5kl415SSdS7KRLKb7mvXOYSjIyVafSykDVbYjI=;
 b=ilUG3cMsBqOV9RL2lZohsBPPP9XlcpJJeeL071SF1KM9njw4zjsKLGFqFN8kbYi6Kq1D0bP1e
 Sn0Ds7Eft1EB9QkVtB7A5V/s0PWZ9m5nOI6qVGGwNU7MEGXlo4mjhr2
X-Developer-Key: i=debug@rivosinc.com; a=ed25519;
 pk=O37GQv1thBhZToXyQKdecPDhtWVbEDRQ0RIndijvpjk=
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 5EA834001E
X-Stat-Signature: dhkhrih84483rox7qb6imjeez57ihyk5
X-Rspam-User: 
X-HE-Tag: 1764878668-728097
X-HE-Meta: U2FsdGVkX19C/uzs70RLR+fIr6hVXLavhDJ/MbGgYDGYoeyF1uE+Ka6WxLQQMgL1Si7J9Nwuj8Ul75RxKyTG/prP0pXA2eCwwNCUxava9ndX14jPdVedjs0OcNQLYB0LM0SUxvVHsekg5qTODljM3ZrDlfSe/MOuy7oLZT72s8MDDbgx8LBk7KfyYmEjCqXNiy6zqdmJOKRp616maSAbZtV9JA9ZuUSBabuaM7qTm8EH2wezTKgyS2Lm7B8WNaSkNJTEZzv5yNSfTSQP6+X69RZRBspYzCBPt/+VBGE0t3kZIgb9RAj1nHojm+ZcDphJmxEhMWWVa80W6BQ1eca+aZTGA8BwNOIBukRVg35FIl0N3WKuc/4yIWgJybrgwewic99cWWQzDDDcmCm90W3Nrua6cvw4CuKP39T8Y83Apw71P3Mb/9xcG8P7Mcq1nTqFI9Vs4STTezcGvgqNFGXELlye6I99jWbL/Y3yB608wkJ11IZ9obWlVGzdsecfau7p7pd/lyIgmrJKOCAWrHBTkTINDD9LbeUHcCfN0J2LipTYyFWwgdIIQ8gRrCBj0U2YgdqPP5Y4iX/mqZIleDqCZD+gzTZ5QOs3FPm63smhgtXPkHDG4lHOfw3AI7vsAJqhEo2s7DIdtg3Q/P/2ZWShzQFbj+dj5kqLW5iWQmG8YtsPFosOQgkcF/3X8t4pBA6hg/o7778+A9CdSTwklMeMhsLcQO//dx8SRAnIy4sFtEZVoFowwMifroxPHNKv8YajSLmvjh1ql+t3e3UTP6VSWQs45vRM2rD8RUPoXDuYUW+Rg8hVCQwqBMUFojpolEjAydxilpYt8muj5tIKbfXCnjT/KvTZIXQu2LkVS/HP1YQ/K29t72zfQmwkxHxce4Wdv/5BhwNNuDVe3wX0fCr0IGlnb1f0p4C9eW2MtJa5JdYQflrGcHbPy2thWvsNTLBMHl0CRZ6C2gslmB8SUA/
 JqBJB0em
 M9I3ecSi+WpXtZ1z9cJegebnM2NKbsL/9etdB3Ux9tzDZ68njQjC81ZnTUrgRtx6j60rLNL/toXLFCe6BkpAQUzYVgL2ap0o7QC+/AfmtF576GWzWfeI6FDq8vaOcLl82sN93H/kf/B5/SRBro3SsKd2GMcokLEjixJ/VhUrJRoi+gX+IOREWDAy4IGCnYVEkWKrV+XKmRXckcofO5Ei0K14yrRKBCcE8LrupsjdkZRgJXyEXH1HYsCUsLotKWSUS2YWKL/ywSLN9eawDA88Yj3w5AQJdeKlKLtPhD3Y3X5W8qaLxAyV94AhSL3UvYYXNkRn8FrOU0rR/iwVQnVGKzccbJx2HKvo/C+LqbhxCGyVWA8BpR05efoSGd798QYCAGEAKK6z3PXNWL8NZ9+PAVHcUdMwwI2aFqZvnXeWuXsQ6xrnK3vk8t+o7TxlGgRcxr1SiG1NpJf3IAyU36uV87xO4AVHRrahwabQ9o6PyNTlOZUas6NDS5zRA/FdnDFBB7QQeWXhRMT8PWEGthtX0jMKGwGqpXapn1lpB
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

prctls implemented are:
PR_SET_INDIR_BR_LP_STATUS, PR_GET_INDIR_BR_LP_STATUS and
PR_LOCK_INDIR_BR_LP_STATUS

Reviewed-by: Zong Li <zong.li@sifive.com>
Tested-by: Andreas Korb <andreas.korb@aisec.fraunhofer.de>
Tested-by: Valentin Haudiquet <valentin.haudiquet@canonical.com>
Signed-off-by: Deepak Gupta <debug@rivosinc.com>
---
 arch/riscv/include/asm/usercfi.h | 14 +++++++
 arch/riscv/kernel/entry.S        |  4 ++
 arch/riscv/kernel/process.c      |  5 +++
 arch/riscv/kernel/usercfi.c      | 79 ++++++++++++++++++++++++++++++++++++++++
 4 files changed, 102 insertions(+)

diff --git a/arch/riscv/include/asm/usercfi.h b/arch/riscv/include/asm/usercfi.h
index d71093f414df..4501d741a609 100644
--- a/arch/riscv/include/asm/usercfi.h
+++ b/arch/riscv/include/asm/usercfi.h
@@ -16,6 +16,8 @@ struct kernel_clone_args;
 struct cfi_state {
 	unsigned long ubcfi_en : 1; /* Enable for backward cfi. */
 	unsigned long ubcfi_locked : 1;
+	unsigned long ufcfi_en : 1; /* Enable for forward cfi. Note that ELP goes in sstatus */
+	unsigned long ufcfi_locked : 1;
 	unsigned long user_shdw_stk; /* Current user shadow stack pointer */
 	unsigned long shdw_stk_base; /* Base address of shadow stack */
 	unsigned long shdw_stk_size; /* size of shadow stack */
@@ -32,6 +34,10 @@ bool is_shstk_locked(struct task_struct *task);
 bool is_shstk_allocated(struct task_struct *task);
 void set_shstk_lock(struct task_struct *task);
 void set_shstk_status(struct task_struct *task, bool enable);
+bool is_indir_lp_enabled(struct task_struct *task);
+bool is_indir_lp_locked(struct task_struct *task);
+void set_indir_lp_status(struct task_struct *task, bool enable);
+void set_indir_lp_lock(struct task_struct *task);
 
 #define PR_SHADOW_STACK_SUPPORTED_STATUS_MASK (PR_SHADOW_STACK_ENABLE)
 
@@ -57,6 +63,14 @@ void set_shstk_status(struct task_struct *task, bool enable);
 
 #define set_shstk_status(task, enable) do {} while (0)
 
+#define is_indir_lp_enabled(task) false
+
+#define is_indir_lp_locked(task) false
+
+#define set_indir_lp_status(task, enable) do {} while (0)
+
+#define set_indir_lp_lock(task) do {} while (0)
+
 #endif /* CONFIG_RISCV_USER_CFI */
 
 #endif /* __ASSEMBLER__ */
diff --git a/arch/riscv/kernel/entry.S b/arch/riscv/kernel/entry.S
index 8410850953d6..036a6ca7641f 100644
--- a/arch/riscv/kernel/entry.S
+++ b/arch/riscv/kernel/entry.S
@@ -174,6 +174,10 @@ SYM_CODE_START(handle_exception)
 	 * or vector in kernel space.
 	 */
 	li t0, SR_SUM | SR_FS_VS
+#ifdef CONFIG_64BIT
+	li t1, SR_ELP
+	or t0, t0, t1
+#endif
 
 	REG_L s0, TASK_TI_USER_SP(tp)
 	csrrc s1, CSR_STATUS, t0
diff --git a/arch/riscv/kernel/process.c b/arch/riscv/kernel/process.c
index a137d3483646..49f527e3acfd 100644
--- a/arch/riscv/kernel/process.c
+++ b/arch/riscv/kernel/process.c
@@ -163,6 +163,11 @@ void start_thread(struct pt_regs *regs, unsigned long pc,
 	set_shstk_status(current, false);
 	set_shstk_base(current, 0, 0);
 	set_active_shstk(current, 0);
+	/*
+	 * disable indirect branch tracking on exec.
+	 * libc will enable it later via prctl.
+	 */
+	set_indir_lp_status(current, false);
 
 #ifdef CONFIG_64BIT
 	regs->status &= ~SR_UXL;
diff --git a/arch/riscv/kernel/usercfi.c b/arch/riscv/kernel/usercfi.c
index 0b77b812e4d7..a384ce9ed25c 100644
--- a/arch/riscv/kernel/usercfi.c
+++ b/arch/riscv/kernel/usercfi.c
@@ -72,6 +72,35 @@ void set_shstk_lock(struct task_struct *task)
 	task->thread_info.user_cfi_state.ubcfi_locked = 1;
 }
 
+bool is_indir_lp_enabled(struct task_struct *task)
+{
+	return task->thread_info.user_cfi_state.ufcfi_en;
+}
+
+bool is_indir_lp_locked(struct task_struct *task)
+{
+	return task->thread_info.user_cfi_state.ufcfi_locked;
+}
+
+void set_indir_lp_status(struct task_struct *task, bool enable)
+{
+	if (!cpu_supports_indirect_br_lp_instr())
+		return;
+
+	task->thread_info.user_cfi_state.ufcfi_en = enable ? 1 : 0;
+
+	if (enable)
+		task->thread.envcfg |= ENVCFG_LPE;
+	else
+		task->thread.envcfg &= ~ENVCFG_LPE;
+
+	csr_write(CSR_ENVCFG, task->thread.envcfg);
+}
+
+void set_indir_lp_lock(struct task_struct *task)
+{
+	task->thread_info.user_cfi_state.ufcfi_locked = 1;
+}
 /*
  * If size is 0, then to be compatible with regular stack we want it to be as big as
  * regular stack. Else PAGE_ALIGN it and return back
@@ -370,3 +399,53 @@ int arch_lock_shadow_stack_status(struct task_struct *task,
 
 	return 0;
 }
+
+int arch_get_indir_br_lp_status(struct task_struct *t, unsigned long __user *status)
+{
+	unsigned long fcfi_status = 0;
+
+	if (!cpu_supports_indirect_br_lp_instr())
+		return -EINVAL;
+
+	/* indirect branch tracking is enabled on the task or not */
+	fcfi_status |= (is_indir_lp_enabled(t) ? PR_INDIR_BR_LP_ENABLE : 0);
+
+	return copy_to_user(status, &fcfi_status, sizeof(fcfi_status)) ? -EFAULT : 0;
+}
+
+int arch_set_indir_br_lp_status(struct task_struct *t, unsigned long status)
+{
+	bool enable_indir_lp = false;
+
+	if (!cpu_supports_indirect_br_lp_instr())
+		return -EINVAL;
+
+	/* indirect branch tracking is locked and further can't be modified by user */
+	if (is_indir_lp_locked(t))
+		return -EINVAL;
+
+	/* Reject unknown flags */
+	if (status & ~PR_INDIR_BR_LP_ENABLE)
+		return -EINVAL;
+
+	enable_indir_lp = (status & PR_INDIR_BR_LP_ENABLE);
+	set_indir_lp_status(t, enable_indir_lp);
+
+	return 0;
+}
+
+int arch_lock_indir_br_lp_status(struct task_struct *task,
+				 unsigned long arg)
+{
+	/*
+	 * If indirect branch tracking is not supported or not enabled on task,
+	 * nothing to lock here
+	 */
+	if (!cpu_supports_indirect_br_lp_instr() ||
+	    !is_indir_lp_enabled(task) || arg != 0)
+		return -EINVAL;
+
+	set_indir_lp_lock(task);
+
+	return 0;
+}

-- 
2.45.0


