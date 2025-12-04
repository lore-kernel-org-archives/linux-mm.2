Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55A02D2A525
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 20:04:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 878F16B002B; Thu,  4 Dec 2025 15:04:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 829256B00C0; Thu,  4 Dec 2025 15:04:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F2036B00D9; Thu,  4 Dec 2025 15:04:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5454E6B002B
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 15:04:44 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2B80F1330B2
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 20:04:44 +0000 (UTC)
X-FDA: 84182866488.11.2A58916
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	by imf12.hostedemail.com (Postfix) with ESMTP id F349440011
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 20:04:41 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=LfNbLm1A;
	dmarc=pass (policy=none) header.from=rivosinc.com;
	spf=pass (imf12.hostedemail.com: domain of debug@rivosinc.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=debug@rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764878682;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XHjrAmDwFydg0rUtX9inr2Oq90aeC61paCwDNVe0mW4=;
	b=s7Bv+955Ke2cxc8/Lz1CmQvTop3WJqG4UmzxnqSEdEVWUru1J1+crlS0RsMpyOM6gK4+8w
	9k6mmbjUDlmACkzrLtRKiKENahprDu8uWnkl+ye5HJzduJCfRDRcNPyIL+FzZieoBkbk6c
	wxpvOLG2rlf/TQeS0mKXvQrMRZn28bs=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=LfNbLm1A;
	dmarc=pass (policy=none) header.from=rivosinc.com;
	spf=pass (imf12.hostedemail.com: domain of debug@rivosinc.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=debug@rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764878682; a=rsa-sha256;
	cv=none;
	b=CI49tLKBRxvzbYwFquxogvD+R4YV0EWET6sV7HS3EvBKwnpZ5ev0oQowKwPyQmCnnDy8Rw
	/Qnhko4egU/vaYBF/0bfHRlfXHNtDhsphzW/uCQMDRm64of9ER4o7qRMwofU7hDY8VEiaS
	XbaRsvx+L0rLAy23Nna05pVAaGPEM5I=
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-29586626fbeso16580685ad.0
        for <linux-mm@kvack.org>; Thu, 04 Dec 2025 12:04:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1764878681; x=1765483481; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XHjrAmDwFydg0rUtX9inr2Oq90aeC61paCwDNVe0mW4=;
        b=LfNbLm1AgPEP+1qpWmoTwPdIG5NbLXG+0ciS+mYxNOt/O54twk917NbDHUbORXplrf
         CkwYhu9ky2mZYGtCBfIE+00LVsqhe5WX+flxQaGoE2ovKxtkdXFEL7nxUyf0/g8OpZc4
         dkuyheFADnNpgGWe7FQBf/vMLIzzG/hywFrSkTcZCCrZWeuQSFL5aPH4z1dC2F7FCbBN
         GLx+y03P3XdeljuofXDzHuNa++yWWoD4It1WLiNmALcCODHtH1JdsPiykyLZLpeQBZsX
         /g9cyAkcYsOlsQT7u01PgBEc0IA3hv6weAn4Ac2vH1J4cn9d2qr4+4ZNK2CUXN2gKJY6
         zBuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764878681; x=1765483481;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=XHjrAmDwFydg0rUtX9inr2Oq90aeC61paCwDNVe0mW4=;
        b=ckbkly+t8exOgUquMZ75PcN3SuWwvWlEZOTbiDiolrz4AOyvmfW1u4jhdlYjPH6DOU
         fV9/WfvRIYy17+GXqlPj3NZxDMd4ryui4u8FxXX2/LWjs60tof7+XuU8i5W4m9pxGIgZ
         POFEu4gxMyrvcXWrPn6wChKDMpokr0jt+jRKlhj8PlyGqW6r84uRDga+JqZyer1WBUiM
         gCHlXavMprpmVwNwQZFJtt+WYLgF2iCeIR7FJ1B9yGF2hMS2V8Xtif4yyWR4EORXlR45
         aTKdUNsYE1GDyNpYpq4dUAqOB20H73ilNEfeRXY0uLbTi0yvEhRZcssjVYsmZHo2xcLm
         wIrw==
X-Forwarded-Encrypted: i=1; AJvYcCWOwYiUFgrJ0qkpcMsrxaKossydq/KMkRAYh0ctQPu0WHyAL64ErnobVrtd1Rwi0vxIa7PkPHhIGQ==@kvack.org
X-Gm-Message-State: AOJu0YzR3i5wdhNE7UA/MR3Q3nn1qS6NV2nbQZ85UAhITcigMQwRFBUH
	aYidZvxgLsy2JQWImUwGcdPrYDNKocnqO48lhmQv032+RkeRswTw9kRBVUiNg8FqD1M=
X-Gm-Gg: ASbGncvXJGCmTE6191ONI563mbHezyhRCAUw8qprXZfBcQ+7pSFiXTkQV7nMEsjSrAQ
	F22EjZ+CfRFlT46pDYRAMvbHzwUnK7MQ1/4MwkDBHA3s6JZMCMhta7pStsGcg+DIIHls0jw7mJ9
	qcENsGatChL7g/mPoo71fpj2nJY5Hbl242z7BlgR1dWc+iSMjkEoIkvxfybr33J1GJ1Gvizx1PB
	0vndk4wSQ3yFeN2vmtYvTnOLoMnXjLt2h0fZOn+3GQm4r0tWj1xQBuPtJw/JC3Br/TYfY9f+wBl
	vDhQD2Mhtg/3kFpM/EnrpJyB/ayDc07KHXQW4i2n7f6m2NsRCbk4PD3Byo5tx868lMoPbYRrVR2
	3FZ4o5Vqz9J00C83QcTYs+vY7taWx/bOIV4f8f8OPjU+L+Hwk4BMMQb1CG+LUjXhpr6maEYsz9J
	Y2qUBvH7z9jhRoMjSD9iVg
X-Google-Smtp-Source: AGHT+IHihmTssZxpaR8jKCNF60zG7vDxysx92DhvBWZ0sch18KMj2b5xAoUSanti6s7KOcdefD4jxA==
X-Received: by 2002:a05:7022:1b02:b0:119:e56b:9596 with SMTP id a92af1059eb24-11df0cc4bd1mr5257350c88.27.1764878680537;
        Thu, 04 Dec 2025 12:04:40 -0800 (PST)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11df76e2eefsm10417454c88.6.2025.12.04.12.04.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Dec 2025 12:04:39 -0800 (PST)
From: Deepak Gupta <debug@rivosinc.com>
Date: Thu, 04 Dec 2025 12:04:10 -0800
Subject: [PATCH v24 21/28] riscv: kernel command line option to opt out of
 user cfi
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251204-v5_user_cfi_series-v24-21-ada7a3ba14dc@rivosinc.com>
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
 Paul Walmsley <pjw@kernel.org>, 
 Valentin Haudiquet <valentin.haudiquet@canonical.com>, 
 Deepak Gupta <debug@rivosinc.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1764878636; l=8780;
 i=debug@rivosinc.com; s=20251023; h=from:subject:message-id;
 bh=TB72t4QkR0jaMWYCEBGwsuRCuXX2jjdz+x7p0H9MJuY=;
 b=kbOhzGSnEyoS4SXSTD7e9yoCCCLUCCC/r0uBr66iw4HeeA894XR3V3ktjKnx8V695fNRyiTxD
 cmbY25eyOxSBYy5Zxrj2Hr/Q1bmgfycABNbNt8XUGGNi6VEBhprw146
X-Developer-Key: i=debug@rivosinc.com; a=ed25519;
 pk=O37GQv1thBhZToXyQKdecPDhtWVbEDRQ0RIndijvpjk=
X-Rspam-User: 
X-Rspamd-Queue-Id: F349440011
X-Rspamd-Server: rspam11
X-Stat-Signature: na35mpqrcn8yu3zso1fgcemcjtz1w5ns
X-HE-Tag: 1764878681-334740
X-HE-Meta: U2FsdGVkX1/4jvbw1JgseBLc0TEXcR3cBgAaPcSN2WgdqIqRL/xOjFYHBvhwCgqqF9tvcnis0Cpl+ByCzkHxQgCmxGaSQQY8fFwVukHMcROVGOf3HGSY5LZtHDxZV5HpQ9vDVt1dvjqqqoU/nBRL/cXDDDAbdhvY5GM3s+5LUkb8sb9T1qWEg+y0jvoGViymWdnkrCYVfYSnV3L2Oo+aIMMQq2Vu82ZiuBDtwNwzYnlDdq7wYTXImuHdT5l0FMTQpisbD38GnJcg8bHiB01Jz8mXQCoJRiLuICG1cHZtcK+uHo0lV1djnVf1wwkcSENPkKHDInQ8PVW36UXmlKTmD+SfBFMC8D2ivuAiKGqCsQcRT/k+RsARfUlMUxEZajKOevoWMfBGu+shwEjayJ/de3oQX9VjfYRuQ6w9GYKvWuVWcjM1/ySbMXs4cJj5TVk2JRa8p5q1JuT6W0lewxzFcsnqY5F6bhf8vnF52sRl19Ra5870a75VWg76dFBUHBSieEEbPIUOFM2DsksPoCdlTbqGiixbjsMV1Q93eU3ZIqvhlgMhAlaYp+QzLEWLR0gfHxT+WActtx8LdLr0PCRquLB9L+U/2LfBti4XDS/SRSB3TiewVEJvqKNn0oDNbK6QjYswO2JuEgnojMwOUON67t2UIW/yKqb1d1bOfrFE2OYrgRkqbQwU4G2jrYL8RCQsD/QCTSJjmg5Iay7af/hzhE+5aVEDnr0h6BZGrtZ4fICtcGbUHxUj0Y3McKbW2a8myrIRnWOhiD/cG67paj+cO5ZDBs5t2HL6UgxBK3KlQJ1MdZqKwF1A/aL3hc2VG5YLFjmoNeQGZE4HJaJkxP5eIT78ZEnZ+20t6ZnNMZqgLIbuq7cx35ug9DrUx9gnK6f+pTA9lhQeC9tWZ7hecuxlbCAcVMBqxNg40sVZY/1ghWL7QXn8aa270lkMPUX5Z4G839aSDpBNSuAPJILQPWF
 Z4LywZSh
 UOc1rJuwc2/gKwaMh0pLVIi34rxv/B0mxCvat3kgP6ZAhXCpYqFkU1PMITn6xObOUgzrS919298ghy2ueCicGrHUDH7DB7ZF5PE5yNTZINJZBt2wmTEaoy0nFfFy8LaVQV9rgPlQ2uqCLTRDR+6EhIGaIHyswb/NHSjMxUXaXk907RCCWUY9O1cUEPkxr1AdAbsM1adZf4zPeKkgxZ2m3pPWWTfui1kqRQdc71zGE08BoW8s0Pk/5SogTRUJmwtm1yR2Epsa7hmvEuQuEklzcDdsDOGrvQBX4Adgx6b09pCcy/1sHMkzn63dUNpqAWyDmEtnkKXMhs/IZQk/j/7zjKHXu1tg4hFKgbot7ZlvmtnBOvBOhdnvmPh4PuUDPegZ1zZX1jItxb7VJJeNVyrBvPrmgniVHulBQqoHpZ6yOp2ABFPDFTlMaYVQ5f2HXMUDSaLVirq0WpsJPZsOeUBxyIc6prKESjjqvQEcSOWyYE6djdE7BwURqhdcihg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This commit adds a kernel command line option to disable part or all of
user cfi. User backward cfi and forward cfi can be controlled
independently. Kernel command line parameter "riscv_nousercfi" can take
the following values:
 - "all" : Disable forward and backward cfi both.
 - "bcfi" : Disable backward cfi.
 - "fcfi" : Disable forward cfi

Signed-off-by: Paul Walmsley <pjw@kernel.org>
Tested-by: Valentin Haudiquet <valentin.haudiquet@canonical.com>
Signed-off-by: Deepak Gupta <debug@rivosinc.com>
---
 Documentation/admin-guide/kernel-parameters.txt |  8 ++++
 arch/riscv/include/asm/usercfi.h                | 10 +++++
 arch/riscv/kernel/cpufeature.c                  |  7 ++-
 arch/riscv/kernel/usercfi.c                     | 59 ++++++++++++++++++++-----
 4 files changed, 71 insertions(+), 13 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 6c42061ca20e..453127ef8746 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -6453,6 +6453,14 @@
 			replacement properties are not found. See the Kconfig
 			entry for RISCV_ISA_FALLBACK.
 
+	riscv_nousercfi=
+		all	Disable user cfi ABI to userspace even if cpu extension
+			are available.
+		bcfi	Disable user backward cfi ABI to userspace even if
+			shadow stack extension is available.
+		fcfi	Disable user forward cfi ABI to userspace even if landing
+			pad extension is available.
+
 	ro		[KNL] Mount root device read-only on boot
 
 	rodata=		[KNL,EARLY]
diff --git a/arch/riscv/include/asm/usercfi.h b/arch/riscv/include/asm/usercfi.h
index ec4b8a53eb74..356f2c4d087d 100644
--- a/arch/riscv/include/asm/usercfi.h
+++ b/arch/riscv/include/asm/usercfi.h
@@ -5,6 +5,10 @@
 #ifndef _ASM_RISCV_USERCFI_H
 #define _ASM_RISCV_USERCFI_H
 
+#define CMDLINE_DISABLE_RISCV_USERCFI_FCFI	1
+#define CMDLINE_DISABLE_RISCV_USERCFI_BCFI	2
+#define CMDLINE_DISABLE_RISCV_USERCFI		3
+
 #ifndef __ASSEMBLER__
 #include <linux/types.h>
 #include <linux/prctl.h>
@@ -14,6 +18,9 @@ struct task_struct;
 struct kernel_clone_args;
 
 #ifdef CONFIG_RISCV_USER_CFI
+
+extern unsigned long riscv_nousercfi;
+
 struct cfi_state {
 	unsigned long ubcfi_en : 1; /* Enable for backward cfi. */
 	unsigned long ubcfi_locked : 1;
@@ -83,6 +90,9 @@ void set_indir_lp_lock(struct task_struct *task);
 
 #endif /* CONFIG_RISCV_USER_CFI */
 
+bool is_user_shstk_enabled(void);
+bool is_user_lpad_enabled(void);
+
 #endif /* __ASSEMBLER__ */
 
 #endif /* _ASM_RISCV_USERCFI_H */
diff --git a/arch/riscv/kernel/cpufeature.c b/arch/riscv/kernel/cpufeature.c
index 17b9e77bafc3..32ad463545fa 100644
--- a/arch/riscv/kernel/cpufeature.c
+++ b/arch/riscv/kernel/cpufeature.c
@@ -28,6 +28,7 @@
 #include <asm/vector.h>
 #include <asm/vendor_extensions.h>
 #include <asm/vendor_extensions/thead.h>
+#include <asm/usercfi.h>
 
 #define NUM_ALPHA_EXTS ('z' - 'a' + 1)
 
@@ -277,7 +278,8 @@ static int riscv_ext_svadu_validate(const struct riscv_isa_ext_data *data,
 static int riscv_cfilp_validate(const struct riscv_isa_ext_data *data,
 				const unsigned long *isa_bitmap)
 {
-	if (!IS_ENABLED(CONFIG_RISCV_USER_CFI))
+	if (!IS_ENABLED(CONFIG_RISCV_USER_CFI) ||
+	    (riscv_nousercfi & CMDLINE_DISABLE_RISCV_USERCFI_FCFI))
 		return -EINVAL;
 
 	return 0;
@@ -286,7 +288,8 @@ static int riscv_cfilp_validate(const struct riscv_isa_ext_data *data,
 static int riscv_cfiss_validate(const struct riscv_isa_ext_data *data,
 				const unsigned long *isa_bitmap)
 {
-	if (!IS_ENABLED(CONFIG_RISCV_USER_CFI))
+	if (!IS_ENABLED(CONFIG_RISCV_USER_CFI) ||
+	    (riscv_nousercfi & CMDLINE_DISABLE_RISCV_USERCFI_BCFI))
 		return -EINVAL;
 
 	return 0;
diff --git a/arch/riscv/kernel/usercfi.c b/arch/riscv/kernel/usercfi.c
index 7f01befabd11..27b36034ea85 100644
--- a/arch/riscv/kernel/usercfi.c
+++ b/arch/riscv/kernel/usercfi.c
@@ -17,6 +17,8 @@
 #include <asm/csr.h>
 #include <asm/usercfi.h>
 
+unsigned long riscv_nousercfi;
+
 #define SHSTK_ENTRY_SIZE sizeof(void *)
 
 bool is_shstk_enabled(struct task_struct *task)
@@ -59,7 +61,7 @@ unsigned long get_active_shstk(struct task_struct *task)
 
 void set_shstk_status(struct task_struct *task, bool enable)
 {
-	if (!cpu_supports_shadow_stack())
+	if (!is_user_shstk_enabled())
 		return;
 
 	task->thread_info.user_cfi_state.ubcfi_en = enable ? 1 : 0;
@@ -89,7 +91,7 @@ bool is_indir_lp_locked(struct task_struct *task)
 
 void set_indir_lp_status(struct task_struct *task, bool enable)
 {
-	if (!cpu_supports_indirect_br_lp_instr())
+	if (!is_user_lpad_enabled())
 		return;
 
 	task->thread_info.user_cfi_state.ufcfi_en = enable ? 1 : 0;
@@ -259,7 +261,7 @@ SYSCALL_DEFINE3(map_shadow_stack, unsigned long, addr, unsigned long, size, unsi
 	bool set_tok = flags & SHADOW_STACK_SET_TOKEN;
 	unsigned long aligned_size = 0;
 
-	if (!cpu_supports_shadow_stack())
+	if (!is_user_shstk_enabled())
 		return -EOPNOTSUPP;
 
 	/* Anything other than set token should result in invalid param */
@@ -306,7 +308,7 @@ unsigned long shstk_alloc_thread_stack(struct task_struct *tsk,
 	unsigned long addr, size;
 
 	/* If shadow stack is not supported, return 0 */
-	if (!cpu_supports_shadow_stack())
+	if (!is_user_shstk_enabled())
 		return 0;
 
 	/*
@@ -352,7 +354,7 @@ void shstk_release(struct task_struct *tsk)
 {
 	unsigned long base = 0, size = 0;
 	/* If shadow stack is not supported or not enabled, nothing to release */
-	if (!cpu_supports_shadow_stack() || !is_shstk_enabled(tsk))
+	if (!is_user_shstk_enabled() || !is_shstk_enabled(tsk))
 		return;
 
 	/*
@@ -381,7 +383,7 @@ int arch_get_shadow_stack_status(struct task_struct *t, unsigned long __user *st
 {
 	unsigned long bcfi_status = 0;
 
-	if (!cpu_supports_shadow_stack())
+	if (!is_user_shstk_enabled())
 		return -EINVAL;
 
 	/* this means shadow stack is enabled on the task */
@@ -395,7 +397,7 @@ int arch_set_shadow_stack_status(struct task_struct *t, unsigned long status)
 	unsigned long size = 0, addr = 0;
 	bool enable_shstk = false;
 
-	if (!cpu_supports_shadow_stack())
+	if (!is_user_shstk_enabled())
 		return -EINVAL;
 
 	/* Reject unknown flags */
@@ -448,7 +450,7 @@ int arch_lock_shadow_stack_status(struct task_struct *task,
 				  unsigned long arg)
 {
 	/* If shtstk not supported or not enabled on task, nothing to lock here */
-	if (!cpu_supports_shadow_stack() ||
+	if (!is_user_shstk_enabled() ||
 	    !is_shstk_enabled(task) || arg != 0)
 		return -EINVAL;
 
@@ -461,7 +463,7 @@ int arch_get_indir_br_lp_status(struct task_struct *t, unsigned long __user *sta
 {
 	unsigned long fcfi_status = 0;
 
-	if (!cpu_supports_indirect_br_lp_instr())
+	if (!is_user_lpad_enabled())
 		return -EINVAL;
 
 	/* indirect branch tracking is enabled on the task or not */
@@ -474,7 +476,7 @@ int arch_set_indir_br_lp_status(struct task_struct *t, unsigned long status)
 {
 	bool enable_indir_lp = false;
 
-	if (!cpu_supports_indirect_br_lp_instr())
+	if (!is_user_lpad_enabled())
 		return -EINVAL;
 
 	/* indirect branch tracking is locked and further can't be modified by user */
@@ -498,7 +500,7 @@ int arch_lock_indir_br_lp_status(struct task_struct *task,
 	 * If indirect branch tracking is not supported or not enabled on task,
 	 * nothing to lock here
 	 */
-	if (!cpu_supports_indirect_br_lp_instr() ||
+	if (!is_user_lpad_enabled() ||
 	    !is_indir_lp_enabled(task) || arg != 0)
 		return -EINVAL;
 
@@ -506,3 +508,38 @@ int arch_lock_indir_br_lp_status(struct task_struct *task,
 
 	return 0;
 }
+
+bool is_user_shstk_enabled(void)
+{
+	return (cpu_supports_shadow_stack() &&
+		!(riscv_nousercfi & CMDLINE_DISABLE_RISCV_USERCFI_BCFI));
+}
+
+bool is_user_lpad_enabled(void)
+{
+	return (cpu_supports_indirect_br_lp_instr() &&
+		!(riscv_nousercfi & CMDLINE_DISABLE_RISCV_USERCFI_FCFI));
+}
+
+static int __init setup_global_riscv_enable(char *str)
+{
+	if (strcmp(str, "all") == 0)
+		riscv_nousercfi = CMDLINE_DISABLE_RISCV_USERCFI;
+
+	if (strcmp(str, "fcfi") == 0)
+		riscv_nousercfi |= CMDLINE_DISABLE_RISCV_USERCFI_FCFI;
+
+	if (strcmp(str, "bcfi") == 0)
+		riscv_nousercfi |= CMDLINE_DISABLE_RISCV_USERCFI_BCFI;
+
+	if (riscv_nousercfi)
+		pr_info("riscv user cfi disabled via cmdline "
+			"shadow stack status : %s, landing pad status : %s\n",
+			(riscv_nousercfi & CMDLINE_DISABLE_RISCV_USERCFI_BCFI) ? "disabled" :
+			"enabled", (riscv_nousercfi & CMDLINE_DISABLE_RISCV_USERCFI_FCFI) ?
+			"disabled" : "enabled");
+
+	return 1;
+}
+
+__setup("riscv_nousercfi=", setup_global_riscv_enable);

-- 
2.45.0


