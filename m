Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B759ECCD1BE
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 23:29:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 412398E0009; Wed, 22 Oct 2025 19:29:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 39A4D8E0002; Wed, 22 Oct 2025 19:29:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 288C08E0009; Wed, 22 Oct 2025 19:29:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1BEDD8E0002
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 19:29:47 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DB6EE1A0989
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 23:29:46 +0000 (UTC)
X-FDA: 84027344772.18.127DF1E
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	by imf06.hostedemail.com (Postfix) with ESMTP id E90C9180003
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 23:29:44 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=E5DPSQRm;
	spf=pass (imf06.hostedemail.com: domain of debug@rivosinc.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761175785;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=njWxpRWfJB7aZ6YZP/EJ8dyU7DPEUOfUxx+ytpaopVc=;
	b=IvbY80canILyz+jNIKB1PqcwbSCxh0ao2LI/bxBuPqUIlFT/igYVLPN3nbK1RfevzQ5KnG
	yHSlJ4vwkis5ryVX41/EyArWreCKOXs+Ke3OFdMf73tNIeb6b16a1uE1vM3aUMWbtkPeru
	+Kgr7X6BfC019RSCCywi6zmRitC5BHE=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=E5DPSQRm;
	spf=pass (imf06.hostedemail.com: domain of debug@rivosinc.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761175785; a=rsa-sha256;
	cv=none;
	b=1wZAY12g2C6SRame7QxMCRfY4JvGrfwGuQ67obFUvdFrnGptY2c+mRI70qsOaC/1DoSvAX
	gguLvXKnj/H1lCLf/o2+BZuOAFhFWUgcvmVxRnnAJ+lpVoxrPu6L01ogWwMKf2Zf3anefq
	yeuj4o+eWc9JwsFPw73ROEsWmCWCOGI=
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-7a23208a0c2so178352b3a.0
        for <linux-mm@kvack.org>; Wed, 22 Oct 2025 16:29:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1761175784; x=1761780584; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=njWxpRWfJB7aZ6YZP/EJ8dyU7DPEUOfUxx+ytpaopVc=;
        b=E5DPSQRmcFJG3bDLFwjweRHaQdxaw/svQ7aCTXSVh9xS8PCHwsOEW+5juMcQmQgCch
         ECtzowGEws9p+Di+VQg7WIvD14lnUVs/XXFPHwJU3w7g1W0BFMsE94prcl40+N40LLUm
         wsqTzWKEzUw2eOhAHUJyXhVN3JVME5h63HsGljXG/4eng7XfgNyeKlgmDjmTGylnjuqg
         p8fvFDYnruAZGWgd0FwsyXy+P27ZNNfcp0N50BdZxjehB7A7c3h5DMLBL+zR9gDCL1Q7
         RXXhcormFAOGKoViCskcL2tNzFRX28rtedCllRXvCgdF/sOWeCozCKhgtizLl0J5/r0Y
         yEMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761175784; x=1761780584;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=njWxpRWfJB7aZ6YZP/EJ8dyU7DPEUOfUxx+ytpaopVc=;
        b=niNTfhhyoRIAHcWODfu0NaBvWweJgiAAUS8WpOhG70GQjc1vRVxYiDMk1+AdQUPC4W
         hqmuujVXBlOtnQivoJ+Fibm+VaU+sP5IjI6rxpt6AVv8V9ggXhp7wVaGSKEN4GzV4FxR
         9AZ9dXEI43EjaSlKmF0PPPt3OaSOsLyeqPGwY1iDXfva1Wr0GfMLiFmXiLMdkvzSG8G2
         HamnrXjGgn6c+kTryyBMU9ahUpq6bHFsAS3oLBUCCg/Z5rlSFnXpyG6L72sLhdtvbgOo
         ZdckopJAkz6BDkrHPK1Fm4WLYwpOzTCn/L09kv67X0wI0p01QUw+JNFYTaZ6I0K56taQ
         40+A==
X-Forwarded-Encrypted: i=1; AJvYcCWTjL0fwjeDZNr8YPG1psQNfIEUD/ts/BErQhAhXxgS99buOGCtVoe9ehwtn1OUhU+s9o4KM7CiHA==@kvack.org
X-Gm-Message-State: AOJu0YzsySAbXHBLvmnBDdqb6vYTfj5XkAwrSDd9jDUiWtedeHUSIc7I
	3wGxSvyW12uVlarRkbGVQZVK49JF5Pbbdp4s2WOpQ9uwJJ0DcIY11yxKZmyrtFDbpv8=
X-Gm-Gg: ASbGncvBLUZD2b8utY0byxsWgki/oja7wtXkFgOYjypqlqTfaX7W1GccrOGttIUGfox
	bIkhyq5K1eNEYo3zkx8rYsVoR2y6uRBRPWPqjbMPCDyL6LD2MFticpQOE06F7UIKdi+vOK2bkRz
	Hwft4PqWizy8nAd+Rx7nXV6fPdhfuG9R/T0/tzwJoob2rLdYs69WW7Rps9A/kw3OcplzOwiuk6B
	uz2b1Ec4jyIx3CilaPpnLFYQDh6wI557EMYGkXPLtEThYgDft4KPo+LegTPryJAqddQrLXK2MAr
	pDT2IM2mUrsx0XOgKEUmDLRLyLx/tJtbdQNoW9Tmeb5AdC58ry9eGRnOWZ6UwfIfe/KsJebCf68
	ld1DE2eLLUWq0iVMTko3fW6t/ZXFpssmcrPVALFhyVGkDI/FSCqJIu3/5Ys6zMhL7cy8arQFylP
	8779uOMSDlwmXtVNPVsliG
X-Google-Smtp-Source: AGHT+IEj2/4BHi77KVDV3K25rGit5uM1wSRhi8XwQEjo8y8/vid1VCo/oY92lt/nB3p3kXLz5vgA0w==
X-Received: by 2002:a05:6a00:189e:b0:7a1:49f7:ad10 with SMTP id d2e1a72fcca58-7a220aff604mr24424106b3a.27.1761175783761;
        Wed, 22 Oct 2025 16:29:43 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7a274dc12b2sm392646b3a.67.2025.10.22.16.29.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Oct 2025 16:29:43 -0700 (PDT)
From: Deepak Gupta <debug@rivosinc.com>
Date: Wed, 22 Oct 2025 16:29:29 -0700
Subject: [PATCH v22 03/28] riscv: zicfiss / zicfilp enumeration
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251022-v5_user_cfi_series-v22-3-fdaa7e4022aa@rivosinc.com>
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
X-Stat-Signature: dwrbwhfeecrxs3brk1kbepzrndmecunf
X-Rspamd-Queue-Id: E90C9180003
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761175784-798905
X-HE-Meta: U2FsdGVkX1/QZ9UANDyCpiivMw1wOqieVzbiFthjgByJLW1SMAW9shnXsj1j055p4QYkHPAsd29TxQhlZGdgz+gTJxS5n0HDosZ96eB3FGmnNeM0ev4Sd86sXxWHq84oOO4VsmeJRe/YIBmjKz5FmWfrUxrOOJ1R0JYjOv0/QnMbFdACpxAx1IKG1KNY3nNqJ73JMdJAVB8aGBPDT24Eql1ekaMEv9zlItT1EoxFyRLpKe8InfN58hI6fPXzuu14lGZ3nJpEiN5X+HklCtVMAMwIJCzEaizMB7epRVWMeSbsZJgbVMUT0F5jxREhzTqLBqYWGJWTF+XcE6eGmnAW3UhzZ9NDZEEcycmOOJ463nR5McC2PglN16SBWBQtjTaBL+Xj1ousqEWklzzjFw1VXLKXA8lLfuET7mBcqd0umAxMeMhwhthheEs16ztIr2ci/vNbWBLV+C0c5uTVzjPkZemxQ9A5xa8J46y7Co1zTK4n8TuaA2BOkUFhHIGWEgU0ELx1i973IgN18KwyZqnrdCnAF+1yR1JA+PY+t+wkMCOOIbu7lbb8i1IfAKRxUldwYn0Lh/1P/gcjzW9XgwoLDl65Kp+NAyZ6OFw+zX1JKHChuwVUBw+uZGuysjqJglCaoRnlG/MmOH/oUly0LkJdVNcp5LBquebOwoS7yLjgWyWXM1doYZH6fAEOTUQrLi2/ykeVE0UbycNrq2452kqKvrfaNHHolK7rHRZIHdDVFMLJDy7awiH2jgSQu9tN56nMA7jNWvOt96366OZUa69aKN5vbX9gUpQH/dHYAKdQMXjohkdv/7oKf+e0Ag4R2dxnkO06nPDBWR9WrvQPUEm+TjFJuN+wHtlGjaBk/kjC25Ncg2pw379Lx1EyIAmRy0WfJE7uCM9ZLE/8gcxINsu6tvljtRA/KceuHXt9Fj/Ud1gDIatfoO8fwazvJUTiQqBADugw42q2axkyJao0cEJ
 y9KxgR4s
 0rr13jTmr5Bwu6yeoWiv+6Ddpv6cfDf7WRHNwSU2MMX25UOVOcA1cQOIvwvZVwpozdYNAotdOEPcI3hku4xsIBKXK5vE81L7pXOd9gFEOqwZiUGW32X5WP7Pd7qhSo+fugINy0EIUXj164EYCnjWWbjCLl1LgJO5gHwmEVUmM66cPT3GaPpiLTZrxkFx5qpVZv4cIbX/fH47gDFPcGJMrFBC6kFvKphDPLcbHN/q3+6goPjv2O2TfokiqGkk3Vq9Mr2IPK2wQPo/8raCkMgAFgHIcuW+XFHiQVc98v1jF399r8hXVYKjxGrmLbst3N9BmNj/qqhOD2l7RikwgNVTNhnc+09z5IeqkcGrfcfcC5ZqLqEcfSN8wkpQ6Up7r0JxSqkqRZNsS2BTceTFyz5X+VAF/mVPTvHQXxYE2QRRdlQmIPpPNZoI18HIqDl8GRnxrVUaFarGC2IGLTLSw1pn0aR0vTHanIE6yu17N
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


