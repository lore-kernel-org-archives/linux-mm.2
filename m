Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB0EDD339B2
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 18:37:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E0886B002C; Fri,  5 Dec 2025 13:37:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B7C06B002F; Fri,  5 Dec 2025 13:37:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7CB946B002C; Fri,  5 Dec 2025 13:37:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 647F16B002C
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 13:37:30 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2BE27B7872
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 18:37:30 +0000 (UTC)
X-FDA: 84186275460.06.1953BDA
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	by imf29.hostedemail.com (Postfix) with ESMTP id 26ECF120011
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 18:37:27 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=V6y22+ku;
	dmarc=pass (policy=none) header.from=rivosinc.com;
	spf=pass (imf29.hostedemail.com: domain of debug@rivosinc.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=debug@rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764959848; a=rsa-sha256;
	cv=none;
	b=DTyX8UFGMDCuV3N/zl5Sk2JEnGDyXAQwuMdiu0sP3ymGMpwhpZhTcF9cW7053Go4f8Uiu4
	gr6p2VF5PronHvdqK5nupWdwE0exn2X+vaqVn2d7HKR+AkZRl4BeHmonPr00xK/INrXdE3
	DLMXAYoRwbos0YFsBGcLz/tHPBYCxy0=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=V6y22+ku;
	dmarc=pass (policy=none) header.from=rivosinc.com;
	spf=pass (imf29.hostedemail.com: domain of debug@rivosinc.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=debug@rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764959848;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dN7+nGNlab1CM7HVM/7LyQrPieDz8A5oMJ4/DSch7hs=;
	b=q2Vd61mE4YxCSPTr0TITk1KXcbb8A93ag8ObYmd1cXlZVUfFo2a/LnQDUpUuzpYP0KgOM8
	BS5ezPP9sKYL2sa1w6a+xHjsQyaL0L6dN45GI+vhyOjB/anOX8CveQ18afcfwMCQVwLu3W
	TAcX5JfoSGZ9M5uBKn8vz5+WyxRChrY=
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-29555b384acso25021265ad.1
        for <linux-mm@kvack.org>; Fri, 05 Dec 2025 10:37:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1764959847; x=1765564647; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dN7+nGNlab1CM7HVM/7LyQrPieDz8A5oMJ4/DSch7hs=;
        b=V6y22+kuAdJ1CEGMKSGPwJ3ItgWyKjqycbVLW2YJ7gr7peCmijushBJPaW1l/d5muV
         JrTLlw06sEIqcDMardZMEdF1pXAksLSMyDB7Bul5VJfYQ6vX++UW4LAVM6A8kW1wWmE1
         kjCQbt+U6VxXYzSSB/fHKr75nLhsjahkNlAxa2l+Z7zAkTQoUlaVekBaaBpA6WrvwP3t
         LLNZ9A7xz2vfyyI1i8a7Lju2vhnJ8d/LXieOj9WmWEARH7XJQgEP8VmqpsFqTfg9v5aJ
         AvtaIa0TGw73nPVacN+ndDYzKt2IR7/FNGb1/wvG+YSnFd2BQRsarxX5oNGHjkHQhDSx
         2QBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764959847; x=1765564647;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=dN7+nGNlab1CM7HVM/7LyQrPieDz8A5oMJ4/DSch7hs=;
        b=qMyld/zYhNaMJj1UftBtkYq+PSuMhfSv1eYSsSwTft00UAL8acC5Sw0o+D/s97+LKR
         BgpIl0KIf/Ue//PynKQMkvYXWHF6l/WvtgSgjllGs0ErG57rw+knJLhG1FyvSRqY95v3
         4XFGCiS9Sk9r98PYDAKC0nj/F0UDvkQbcJN4DyJxznh3yuZ3v41zEH2msj7EjvntR1H/
         drxpe295+ZtOdOUEsaudVonEiJO3KXjc0Fx5mwKmhCCLRqkx31ldlPW95WnhNQAJnX5C
         OVdvBICHbAC52uUcaOA++wm1bYM84yM3W8ERjPe5tOpDnnutuucBgzHkYJUcuvK6r1OG
         hA6g==
X-Forwarded-Encrypted: i=1; AJvYcCXe1Hr2GxOlCOfo0dqnokOP0yJfxjyEbkm19VKG73g0KSFKCdd04g4BeAMNNmq8yCC6BeA6qGK/Lw==@kvack.org
X-Gm-Message-State: AOJu0YydVpQwwQewb4+FJdsZ1o2qyy8YaPWqmzdvS6nWUib9DGd8cenV
	jJJWXPJYOLPdkGurowWbuMQv15URFoHdx5W4e9Mlk8sZhuoTWUsRftDoRxrTM0pY28E=
X-Gm-Gg: ASbGncuyTDS96/riy0goCUFsQ1ui5tJlBm6hKy94afhDHYDyeupmZMkPvPsDaOCKHAW
	PQ5wndvWEb5afeyaleEV8ThUYp08qfuFxmovFHAtG/to7Oxmt0FT0x54ok41T/YMk206yKxHlGO
	w03L+q4iFOoV6KUK+mtrb/xymjnGA7BPRxypAtBPinhsNrtiCpfdYeUcrgcOmRGP8KI2s0hMfmW
	0W/raE8lgWAczG4q7yNROMqxtBeCSzPNrRzrzB7KTZno3rcz3CvKEro/FcnYNlV7YV1fJCdmXlQ
	r6cEqjeB9z3ef9HGsGbjuwff98iBza+XrrogjCctm6X6MDoaWnJmzizB7jGmgzYDCymUv+wwufA
	/jZf+6XOiBhfVNhQS2k31PxITAZ1Ro5njgDOzDL6XNu3R3tyXI7MxPSJsC7MZQCpjCBL0PBIwfG
	moI3YHhQEnSQIJjfkgcqSX
X-Google-Smtp-Source: AGHT+IG+6LyUx2tM/k36kqcPvlEX1BgR291UtFm9wJEb6bkZ5c6p7px6GhQAq+25PY/uF2wA0uAxkg==
X-Received: by 2002:a05:7301:1315:b0:2a4:6a87:7285 with SMTP id 5a478bee46e88-2abc721c390mr85254eec.39.1764959846860;
        Fri, 05 Dec 2025 10:37:26 -0800 (PST)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2aba8395d99sm23933342eec.1.2025.12.05.10.37.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Dec 2025 10:37:26 -0800 (PST)
From: Deepak Gupta <debug@rivosinc.com>
Date: Fri, 05 Dec 2025 10:37:05 -0800
Subject: [PATCH v25 19/28] riscv/ptrace: riscv cfi status and state via
 ptrace and in core files
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251205-v5_user_cfi_series-v25-19-8a3570c3e145@rivosinc.com>
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
 Valentin Haudiquet <valentin.haudiquet@canonical.com>, 
 Deepak Gupta <debug@rivosinc.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1764959808; l=6975;
 i=debug@rivosinc.com; s=20251023; h=from:subject:message-id;
 bh=10adw+B6s48GPS/UC8IWlsl2AVRKonZeAmtNEJH3LPo=;
 b=znhzKW6NSvqeHo3JQ6zQcdbRj+RyAn82Npyt1c5aJBUxOsTq7Vreb9XQeTI3npOm+kpvaJYTK
 B9N0+VKBxr0Dv4bC8Ew1+haNmqt8N2X/BeMtNob1JG/TurgNWd57LF9
X-Developer-Key: i=debug@rivosinc.com; a=ed25519;
 pk=O37GQv1thBhZToXyQKdecPDhtWVbEDRQ0RIndijvpjk=
X-Rspam-User: 
X-Rspamd-Queue-Id: 26ECF120011
X-Rspamd-Server: rspam10
X-Stat-Signature: k97f95pc3kxpqxemigooy775s9rz5axx
X-HE-Tag: 1764959847-756856
X-HE-Meta: U2FsdGVkX1+7oFmvI4gyJsa4GdXH8WGY0tIXGxt1Cagu4zelKEq+wfKuLdhaaUjn3TF08rqiDbBBcFkKrUcrpO6BZZj6hcRgU+Z8NQZR5K9mPpE+GQPDNzPFOuyyeu019Gu6Vpl1VQzW3KVSnKWT2nG9NexK38WWEmAB60NBbpI+Fy2TibagzAAiL7Eb1nkaIc3SRcAH6VQghE8eNhdZrJPh7usyB7wVMS0f8tpYE2qIKm7diD80Sr8WFKba+B0Lfn7hx0h1csOc3G9vJdTDJIXi5p8xzusMG71YCPC8rR90d2txFBmQBj/yiwYzIUrmfZV9ROy8aC1TCQMGtV4xFkA/61wGdT3SmoYJ4BsNnKvfcb4YkYjKPEoyirwkFhhutrm0s1EKSmXF6qzij2b5ZEYhen7E3nUMkdLXE646PpmEN7/1mIra7B5+3TA3HqQePDCAUN7XQ6umiN81bq9Od5WzVfFxG7dvgNv5pQw+azS2bya6rC+gGFSKiS4yny2q8CV9hmnBvJ2plzIkwz0eW9ZUMLaTBFoyREezgjpqXf/gt25tUlSHNhm4Xj73mtv3QaMSd2YtEElGexY6GXMjw9ZRrnQidR4krVX0eyP6cGSj3OR+2ocU2wsDml9FE6qW8FhXnfafqCaeawUyJgyem63OCcxwYjl+Tku5UwTle81WIjwEGZEVG4U9UbE5GHFvfrERvAxHIpSYXSzI8ystAM5/B9jW4iKQJtdqJU6MZ2OIM5ZOAHoQFDsiPHYBsrPDEEKkvbs5nBZqobeMmZ7fMhePo/kuDUy1ATGfwCiYq7r8IdWxOpwKPfkTd+WojukWWGqwHQP3K/GlzZUOiYPVgoiwalJ0DqAU71I6N0FyD7loWVQaC0rXB7T2Qwd+znGoUNmwBAJ25kfrjphupiO3uKEQOLx4Afpr7SxsmxSQKjgPI3gnlB3sUh+8dSMiiANfrzQvLmNMN+MoBDboBk6
 x7NVYq8p
 0ALLAe8N5Y5Y1o8xIngcyhngAK0zZjtcBp2FBhfmT+ZVo/HBEyrGPXg5J5dy8+Jcs2Tui0DacYsFXOFvo8/Tu6wcQk4f5Chm1YAzlJ35T3U0q8DvOyXqDV1MJCX19O1/JuZe36WyP9Pr3F/+PAG2RIBqdYVEBVT1ejHw1pH/ju3CcW9L2+BLbtF0ZDatsc+w0qP7J8qg2L+mEBiHjdB2dyi2ySdeiPLQpqWmqJvSZe4a/w4OxiS+YweXwXaAnkLEWa769tSn5NA8durvqAYSgMuAEHNQzlSc+jfHdeqdgkdp42YbNcGqgE6sizfu90Yhob/vphQcXFz6DVEObr328ODTq0EJHy+2vvsz++m+O5EuRcGv0/EGUrTzXbS3bmYOuBvSU3FjBEKtdqRtqpl9CzJFx1S+gXyqyGTMc0o8u7Uu7l5W3tZlXfS1hCk22ibkk66sPa3/Ds8cqpdxZeUppAXwQh0iGOxHcfCNu
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Expose a new register type NT_RISCV_USER_CFI for risc-v cfi status and
state. Intentionally both landing pad and shadow stack status and state
are rolled into cfi state. Creating two different NT_RISCV_USER_XXX would
not be useful and wastage of a note type. Enabling, disabling and locking
of feature is not allowed via ptrace set interface. However setting `elp`
state or setting shadow stack pointer are allowed via ptrace set interface
. It is expected `gdb` might have use to fixup `elp` state or `shadow
stack` pointer.

Tested-by: Valentin Haudiquet <valentin.haudiquet@canonical.com>
Signed-off-by: Deepak Gupta <debug@rivosinc.com>
---
 arch/riscv/include/uapi/asm/ptrace.h | 30 ++++++++++++
 arch/riscv/kernel/ptrace.c           | 95 ++++++++++++++++++++++++++++++++++++
 include/uapi/linux/elf.h             |  2 +
 3 files changed, 127 insertions(+)

diff --git a/arch/riscv/include/uapi/asm/ptrace.h b/arch/riscv/include/uapi/asm/ptrace.h
index 261bfe70f60a..b2a18dfeb2fb 100644
--- a/arch/riscv/include/uapi/asm/ptrace.h
+++ b/arch/riscv/include/uapi/asm/ptrace.h
@@ -131,6 +131,36 @@ struct __sc_riscv_cfi_state {
 	unsigned long ss_ptr;   /* shadow stack pointer */
 };
 
+#define PTRACE_CFI_LP_EN_BIT	0
+#define PTRACE_CFI_LP_LOCK_BIT	1
+#define PTRACE_CFI_ELP_BIT	2
+#define PTRACE_CFI_SS_EN_BIT	3
+#define PTRACE_CFI_SS_LOCK_BIT	4
+#define PTRACE_CFI_SS_PTR_BIT	5
+
+#define PTRACE_CFI_LP_EN_STATE		(1 << PTRACE_CFI_LP_EN_BIT)
+#define PTRACE_CFI_LP_LOCK_STATE	(1 << PTRACE_CFI_LP_LOCK_BIT)
+#define PTRACE_CFI_ELP_STATE		(1 << PTRACE_CFI_ELP_BIT)
+#define PTRACE_CFI_SS_EN_STATE		(1 << PTRACE_CFI_SS_EN_BIT)
+#define PTRACE_CFI_SS_LOCK_STATE	(1 << PTRACE_CFI_SS_LOCK_BIT)
+#define PTRACE_CFI_SS_PTR_STATE	(1 << PTRACE_CFI_SS_PTR_BIT)
+
+#define PRACE_CFI_STATE_INVALID_MASK	~(PTRACE_CFI_LP_EN_STATE | \
+					  PTRACE_CFI_LP_LOCK_STATE | \
+					  PTRACE_CFI_ELP_STATE | \
+					  PTRACE_CFI_SS_EN_STATE | \
+					  PTRACE_CFI_SS_LOCK_STATE | \
+					  PTRACE_CFI_SS_PTR_STATE)
+
+struct __cfi_status {
+	__u64 cfi_state;
+};
+
+struct user_cfi_state {
+	struct __cfi_status	cfi_status;
+	__u64 shstk_ptr;
+};
+
 #endif /* __ASSEMBLER__ */
 
 #endif /* _UAPI_ASM_RISCV_PTRACE_H */
diff --git a/arch/riscv/kernel/ptrace.c b/arch/riscv/kernel/ptrace.c
index 8e86305831ea..56b9e3871862 100644
--- a/arch/riscv/kernel/ptrace.c
+++ b/arch/riscv/kernel/ptrace.c
@@ -19,6 +19,7 @@
 #include <linux/regset.h>
 #include <linux/sched.h>
 #include <linux/sched/task_stack.h>
+#include <asm/usercfi.h>
 
 enum riscv_regset {
 	REGSET_X,
@@ -31,6 +32,9 @@ enum riscv_regset {
 #ifdef CONFIG_RISCV_ISA_SUPM
 	REGSET_TAGGED_ADDR_CTRL,
 #endif
+#ifdef CONFIG_RISCV_USER_CFI
+	REGSET_CFI,
+#endif
 };
 
 static int riscv_gpr_get(struct task_struct *target,
@@ -184,6 +188,87 @@ static int tagged_addr_ctrl_set(struct task_struct *target,
 }
 #endif
 
+#ifdef CONFIG_RISCV_USER_CFI
+static int riscv_cfi_get(struct task_struct *target,
+			 const struct user_regset *regset,
+			 struct membuf to)
+{
+	struct user_cfi_state user_cfi;
+	struct pt_regs *regs;
+
+	memset(&user_cfi, 0, sizeof(user_cfi));
+	regs = task_pt_regs(target);
+
+	if (is_indir_lp_enabled(target)) {
+		user_cfi.cfi_status.cfi_state |= PTRACE_CFI_LP_EN_STATE;
+		user_cfi.cfi_status.cfi_state |= is_indir_lp_locked(target) ?
+						 PTRACE_CFI_LP_LOCK_STATE : 0;
+		user_cfi.cfi_status.cfi_state |= (regs->status & SR_ELP) ?
+						PTRACE_CFI_ELP_STATE : 0;
+	}
+
+	if (is_shstk_enabled(target)) {
+		user_cfi.cfi_status.cfi_state |= (PTRACE_CFI_SS_EN_STATE |
+						  PTRACE_CFI_SS_PTR_STATE);
+		user_cfi.cfi_status.cfi_state |= is_shstk_locked(target) ?
+						 PTRACE_CFI_SS_LOCK_STATE : 0;
+		user_cfi.shstk_ptr = get_active_shstk(target);
+	}
+
+	return membuf_write(&to, &user_cfi, sizeof(user_cfi));
+}
+
+/*
+ * Does it make sense to allowing enable / disable of cfi via ptrace?
+ * Not allowing enable / disable / locking control via ptrace for now.
+ * Setting shadow stack pointer is allowed. GDB might use it to unwind or
+ * some other fixup. Similarly gdb might want to suppress elp and may want
+ * to reset elp state.
+ */
+static int riscv_cfi_set(struct task_struct *target,
+			 const struct user_regset *regset,
+			 unsigned int pos, unsigned int count,
+			 const void *kbuf, const void __user *ubuf)
+{
+	int ret;
+	struct user_cfi_state user_cfi;
+	struct pt_regs *regs;
+
+	regs = task_pt_regs(target);
+
+	ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf, &user_cfi, 0, -1);
+	if (ret)
+		return ret;
+
+	/*
+	 * Not allowing enabling or locking shadow stack or landing pad
+	 * There is no disabling of shadow stack or landing pad via ptrace
+	 * rsvd field should be set to zero so that if those fields are needed in future
+	 */
+	if ((user_cfi.cfi_status.cfi_state &
+	     (PTRACE_CFI_LP_EN_STATE | PTRACE_CFI_LP_LOCK_STATE |
+	      PTRACE_CFI_SS_EN_STATE | PTRACE_CFI_SS_LOCK_STATE)) ||
+	     (user_cfi.cfi_status.cfi_state & PRACE_CFI_STATE_INVALID_MASK))
+		return -EINVAL;
+
+	/* If lpad is enabled on target and ptrace requests to set / clear elp, do that */
+	if (is_indir_lp_enabled(target)) {
+		if (user_cfi.cfi_status.cfi_state &
+		    PTRACE_CFI_ELP_STATE) /* set elp state */
+			regs->status |= SR_ELP;
+		else
+			regs->status &= ~SR_ELP; /* clear elp state */
+	}
+
+	/* If shadow stack enabled on target, set new shadow stack pointer */
+	if (is_shstk_enabled(target) &&
+	    (user_cfi.cfi_status.cfi_state & PTRACE_CFI_SS_PTR_STATE))
+		set_active_shstk(target, user_cfi.shstk_ptr);
+
+	return 0;
+}
+#endif
+
 static const struct user_regset riscv_user_regset[] = {
 	[REGSET_X] = {
 		USER_REGSET_NOTE_TYPE(PRSTATUS),
@@ -224,6 +309,16 @@ static const struct user_regset riscv_user_regset[] = {
 		.set = tagged_addr_ctrl_set,
 	},
 #endif
+#ifdef CONFIG_RISCV_USER_CFI
+	[REGSET_CFI] = {
+		.core_note_type = NT_RISCV_USER_CFI,
+		.align = sizeof(__u64),
+		.n = sizeof(struct user_cfi_state) / sizeof(__u64),
+		.size = sizeof(__u64),
+		.regset_get = riscv_cfi_get,
+		.set = riscv_cfi_set,
+	},
+#endif
 };
 
 static const struct user_regset_view riscv_user_native_view = {
diff --git a/include/uapi/linux/elf.h b/include/uapi/linux/elf.h
index 819ded2d39de..ee30dcd80901 100644
--- a/include/uapi/linux/elf.h
+++ b/include/uapi/linux/elf.h
@@ -545,6 +545,8 @@ typedef struct elf64_shdr {
 #define NT_RISCV_VECTOR	0x901		/* RISC-V vector registers */
 #define NN_RISCV_TAGGED_ADDR_CTRL "LINUX"
 #define NT_RISCV_TAGGED_ADDR_CTRL 0x902	/* RISC-V tagged address control (prctl()) */
+#define NN_RISCV_USER_CFI	"LINUX"
+#define NT_RISCV_USER_CFI	0x903		/* RISC-V shadow stack state */
 #define NN_LOONGARCH_CPUCFG	"LINUX"
 #define NT_LOONGARCH_CPUCFG	0xa00	/* LoongArch CPU config registers */
 #define NN_LOONGARCH_CSR	"LINUX"

-- 
2.45.0


