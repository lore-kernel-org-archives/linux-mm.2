Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8EE7DCCD193
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 20:53:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 91E7A8E001C; Mon, 20 Oct 2025 16:53:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 85AA58E000E; Mon, 20 Oct 2025 16:53:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 65DD58E001C; Mon, 20 Oct 2025 16:53:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4D91C8E000E
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 16:53:44 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E30D25839E
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 20:53:43 +0000 (UTC)
X-FDA: 84019693926.03.A6DC889
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	by imf14.hostedemail.com (Postfix) with ESMTP id 2961B10000A
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 20:53:41 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=JNsZtYq2;
	spf=pass (imf14.hostedemail.com: domain of debug@rivosinc.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760993622;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=njWxpRWfJB7aZ6YZP/EJ8dyU7DPEUOfUxx+ytpaopVc=;
	b=vv3erAhd1td3mi0KmCZiF1bumSrOG903zSG46DRqA+SB5TYEQCI/uC/6A0GpmC6DpBxCQF
	x+hba8Z8qH1QA86Kh7v5PiqdKsrGKf0halFo/uXe9nsm353JkijQ/sjBouCeQlF9PZPnd0
	OgU8NHBQyzTuM7WTeMUKn9Lit6uTsSE=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=JNsZtYq2;
	spf=pass (imf14.hostedemail.com: domain of debug@rivosinc.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760993622; a=rsa-sha256;
	cv=none;
	b=KoNA0bficnQxz6X8R4g5gQsX2Wwdp3Sv3IYDqju/DK39Qmnmdo0APIKI5j2o52X4kYTsQ7
	XwXHklAFPGcJCNeHHv2KJAY4jvUXaR6rm0pTv/4WuLRq/srwGkMCzbLJuZeHnPITkkmSAD
	RJf0JKLdrErr1FjHDVXAtNrm0izcDWA=
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-7a226a0798cso2836333b3a.2
        for <linux-mm@kvack.org>; Mon, 20 Oct 2025 13:53:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1760993621; x=1761598421; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=njWxpRWfJB7aZ6YZP/EJ8dyU7DPEUOfUxx+ytpaopVc=;
        b=JNsZtYq2tv/OSKA8y7qqAGEamU2sgVlqM6mXyclOuvYhfTsoRcxreniJDIHmmXTb0Q
         ZLXu9Kt/fRcZdMVK/D6GE9y3loLJSyJDJTDolUohpKeg6p8vd3estzE5+YSGLHAg402C
         TjAHdeueS7OXjpAAt4iNEpFV9HrRhSbhPmkDyN2N7BUC+AoPk+z/V1XXjLR3E3OVOQRu
         deUei9w7P+4j/qDzH8TqegPjO7y4uPTXLxpSaOw0knoCBqDg5URqLyH5VF8Uf1MVDipr
         cxhvjCrkeYFNhkaEZiLbMKWtisoGDn+XAHV4bWCN08n+N9J8kA2iYs0hjH4q8T0gHMOe
         J8TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760993621; x=1761598421;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=njWxpRWfJB7aZ6YZP/EJ8dyU7DPEUOfUxx+ytpaopVc=;
        b=NT4uqt83VAAL6ffG4kA0bLuRUWK0EexhXX4+HmpW8dh1k5y+0GCztMYYkMVZwPz8Zr
         qfe85ywt5y34wvVWp5D74MhyHJxyTy5qDkOtOW28PQUqfOulZ98USg9N/jek7mo1ikZs
         b6eZvarO5GDjIa++5zV1LjZZTmIAti0xDI4sXNW5mY+5vqJMaRl4dPa04IX+6XRnX4HG
         qsVxWbPp1PStURPKHaJpBBL2Ql4vmSLH2tgzeRFKIN2jxI8aB2pTOZnA/1JlBoP53IOR
         6FicxTAU1s+r5FZQtnniJ5WhWksojQQ4LTu0zKvVlqu54TExE/8Zr893cb1qVnVhEwh9
         tcYQ==
X-Forwarded-Encrypted: i=1; AJvYcCXMbPT7D3wR/iJbM5g3IEYRZJxdA9L61A58kh5SQCYU+UJ9H2+vr94xq25lbjquGO1/gMAGKKLBJQ==@kvack.org
X-Gm-Message-State: AOJu0YyDmY/RmpQL0yz5x2LvRJSs3cnAIl/Y7ytcaCS3y048hNk+0Swv
	lb45ejKs3xRpvEMLeIF/NLT0V9E/GvgM9W8UQrDcNqPFcFcBmzVSNR99UGp9mzDxhXk=
X-Gm-Gg: ASbGncviCLDJy0SNQWEk6XDbkEZrquBuxVpFhDWB69rvvS8SaA0/Xm8XqFYnd7paMts
	uW42ByEWDZylmJH4qUXBll6kOcCA2c86V1dC3vrjPq0O69tR3ezhApAF258E0m+BkryY154rrcL
	VXW5FSfylTQXxCx6MAQVjZ1k7732hlt/85JaZ9jXY8QTXsWI/9yH88PXbvKF/MbYE6ZKJN1ihvy
	p/yqxo3Ekg1X/gbHoC5L4aquxXUNLMlNfkAJQA8BH3tofcQs+Frd30X0XSLycrHMTI5+ZbrTWud
	sHPBl1Q2B/LCX5vd4UGyUJoqj/8dYJn7670p+Xu/jGOjhkYg7kF+ugEfjx4XBnzUFsIDB/y2knP
	zFby3FsIHFTb7HujaIm+aZNIiOSGVWggZ3MOTyiTFh6r1H9rGZwmrvg4bbyoEqk/RWzi8CpAkZB
	DSQO/z+0jtuQ==
X-Google-Smtp-Source: AGHT+IGB6G0bjj0maMKHmuua0hMqc4EqHyqktS5DWO/T8lTTtYUZ5oM/r59RE+hpsUE5upyZQqaDWw==
X-Received: by 2002:a05:6a20:72a4:b0:334:974b:6e0f with SMTP id adf61e73a8af0-334a86256c3mr18865281637.40.1760993620849;
        Mon, 20 Oct 2025 13:53:40 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7a22ff1591dsm9453867b3a.7.2025.10.20.13.53.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Oct 2025 13:53:40 -0700 (PDT)
From: Deepak Gupta <debug@rivosinc.com>
Date: Mon, 20 Oct 2025 13:53:32 -0700
Subject: [PATCH v22 03/28] riscv: zicfiss / zicfilp enumeration
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251020-v5_user_cfi_series-v22-3-9ae5510d1c6f@rivosinc.com>
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
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 2961B10000A
X-Stat-Signature: nmfj97khkiogmutqpketfrhweptoy3nr
X-Rspam-User: 
X-HE-Tag: 1760993621-429484
X-HE-Meta: U2FsdGVkX18APsv/PVFOfxw4oUlI/hvfWrZsd24SR8hVbxvWS+Gfj+EzWwJldvnlpSN5p6FNYT/4fqpPYxEC6+MwSX5Unh1fSSbdVms1Aq0rWV9rqZ3RzgQIm2gb1/+jBXwf3BPcPSWF76ZbtnyY9XiSSBLy0xwmdBOj70GK1JEpNI7NLmYeSDcJOu2mgBFiapXTdByNbCIGzDKoBAwYidhtotXAmyjuWYQGj7xd7D2ki2U86O/tELQajJ2YhaUxqLelhH+kNo6Kr3lqvGSZEHSfD+8QdUgGp3kB7E5Jdi9r/u1fZJpXR3y85w+KSg59QmZ50tLy2AC18Me9ehB+xIGav5C1m5y720R87gsTqS0JG+LEH40W5ryCw3Buy0ayhs61uhiAccwMmAhtMnvF0bhHLfmSfsy0em+I7cXDAUAjr8tzbhCPZ1Ti/CS5J+7rcGRJiTFL5dKwcsGGlocot1ImlfUdPOA7iQf7Wp3SvTatQnqwo0JtV/qdZpO+gLvLCvgyOy5CFFoEw+lgYT9hak3Wb5vLnccXTXV55bOIQFetdWy81rlV0kswNmLeDBvr1FnnGg6MV9SiytTdzWd76jBU3hqLNY/bYbTzzEZdT0cfVe1H/IUzcnDi6QMMkunukGg/cj5Sw7BoSck55EGIb4N4ExYxK1y8zWb3TdrXH7aAcUil+R4WpfUS8qTwW0WyjIsiC4HYMABcM4PBh/u5A/XFRupitSax3bmMCiae2SOIBEDazeO5oJ6c2oeQl/Jx1vG6AfLtGTJJI82VxhJqNwbkgx71tBIBUmIFAgdgFvulmefL3nq7OQWxULhiIcPEmQJ/jb8WH8+SAO7BHQkINO7yf7/vWTbuu/BdmJV9UH6eb5SoNO8+Xfv23FSaMhC1TOYybsNo5Fzqj7tmUBYv+O4zGzOJhvsXFVAOAS4tTd8rt7VqIBJRyV34CSmm2RK47gtxpxQaFqdzhy8cUWq
 TozrVIOl
 8ztyNVooosCd8eHtNSN1SgqzgQn7o/UNnJ8leLkphLw1XdIkWjkpYbIHJLA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch adds support for detecting zicfiss and zicfilp. zicfiss and
zicfilp stands for unprivleged integer spec extension for shadow stack
and branch tracking on indirect branches, respectively.

This patch looks for zicfiss and zicfilp in device tree and accordinlgy
lights up bit in cpu feature bitmap. Furthermore this patch adds detection
utility functions to return whether shadow stack or landing pads are
supported by cpu.

Reviewed-by: Zong Li <zong.li@sifive.com>
Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Signed-off-by: Deepak Gupta <debug@rivosinc.com>
---
 arch/riscv/include/asm/cpufeature.h | 12 ++++++++++++
 arch/riscv/include/asm/hwcap.h      |  2 ++
 arch/riscv/kernel/cpufeature.c      | 22 ++++++++++++++++++++++
 3 files changed, 36 insertions(+)

diff --git a/arch/riscv/include/asm/cpufeature.h b/arch/riscv/include/asm/cpufeature.h
index fbd0e4306c93..481f483ebf15 100644
--- a/arch/riscv/include/asm/cpufeature.h
+++ b/arch/riscv/include/asm/cpufeature.h
@@ -150,4 +150,16 @@ static __always_inline bool riscv_cpu_has_extension_unlikely(int cpu, const unsi
 	return __riscv_isa_extension_available(hart_isa[cpu].isa, ext);
 }
 
+static inline bool cpu_supports_shadow_stack(void)
+{
+	return (IS_ENABLED(CONFIG_RISCV_USER_CFI) &&
+		riscv_has_extension_unlikely(RISCV_ISA_EXT_ZICFISS));
+}
+
+static inline bool cpu_supports_indirect_br_lp_instr(void)
+{
+	return (IS_ENABLED(CONFIG_RISCV_USER_CFI) &&
+		riscv_has_extension_unlikely(RISCV_ISA_EXT_ZICFILP));
+}
+
 #endif
diff --git a/arch/riscv/include/asm/hwcap.h b/arch/riscv/include/asm/hwcap.h
index affd63e11b0a..7c4619a6d70d 100644
--- a/arch/riscv/include/asm/hwcap.h
+++ b/arch/riscv/include/asm/hwcap.h
@@ -106,6 +106,8 @@
 #define RISCV_ISA_EXT_ZAAMO		97
 #define RISCV_ISA_EXT_ZALRSC		98
 #define RISCV_ISA_EXT_ZICBOP		99
+#define RISCV_ISA_EXT_ZICFILP		100
+#define RISCV_ISA_EXT_ZICFISS		101
 
 #define RISCV_ISA_EXT_XLINUXENVCFG	127
 
diff --git a/arch/riscv/kernel/cpufeature.c b/arch/riscv/kernel/cpufeature.c
index 67b59699357d..5a1a194e1180 100644
--- a/arch/riscv/kernel/cpufeature.c
+++ b/arch/riscv/kernel/cpufeature.c
@@ -274,6 +274,24 @@ static int riscv_ext_svadu_validate(const struct riscv_isa_ext_data *data,
 	return 0;
 }
 
+static int riscv_cfilp_validate(const struct riscv_isa_ext_data *data,
+			      const unsigned long *isa_bitmap)
+{
+	if (!IS_ENABLED(CONFIG_RISCV_USER_CFI))
+		return -EINVAL;
+
+	return 0;
+}
+
+static int riscv_cfiss_validate(const struct riscv_isa_ext_data *data,
+			      const unsigned long *isa_bitmap)
+{
+	if (!IS_ENABLED(CONFIG_RISCV_USER_CFI))
+		return -EINVAL;
+
+	return 0;
+}
+
 static const unsigned int riscv_a_exts[] = {
 	RISCV_ISA_EXT_ZAAMO,
 	RISCV_ISA_EXT_ZALRSC,
@@ -461,6 +479,10 @@ const struct riscv_isa_ext_data riscv_isa_ext[] = {
 	__RISCV_ISA_EXT_DATA_VALIDATE(zicbop, RISCV_ISA_EXT_ZICBOP, riscv_ext_zicbop_validate),
 	__RISCV_ISA_EXT_SUPERSET_VALIDATE(zicboz, RISCV_ISA_EXT_ZICBOZ, riscv_xlinuxenvcfg_exts, riscv_ext_zicboz_validate),
 	__RISCV_ISA_EXT_DATA(ziccrse, RISCV_ISA_EXT_ZICCRSE),
+	__RISCV_ISA_EXT_SUPERSET_VALIDATE(zicfilp, RISCV_ISA_EXT_ZICFILP, riscv_xlinuxenvcfg_exts,
+					  riscv_cfilp_validate),
+	__RISCV_ISA_EXT_SUPERSET_VALIDATE(zicfiss, RISCV_ISA_EXT_ZICFISS, riscv_xlinuxenvcfg_exts,
+					  riscv_cfiss_validate),
 	__RISCV_ISA_EXT_DATA(zicntr, RISCV_ISA_EXT_ZICNTR),
 	__RISCV_ISA_EXT_DATA(zicond, RISCV_ISA_EXT_ZICOND),
 	__RISCV_ISA_EXT_DATA(zicsr, RISCV_ISA_EXT_ZICSR),

-- 
2.43.0


