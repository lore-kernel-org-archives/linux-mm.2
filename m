Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ABC65CCD193
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 20:22:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 79E338E0011; Mon, 20 Oct 2025 16:22:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 74F758E0002; Mon, 20 Oct 2025 16:22:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C8868E0011; Mon, 20 Oct 2025 16:22:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4D6428E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 16:22:47 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1D0031A02AB
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 20:22:47 +0000 (UTC)
X-FDA: 84019615974.17.065E249
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	by imf18.hostedemail.com (Postfix) with ESMTP id 3D01F1C000F
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 20:22:45 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=WIblnoRK;
	dmarc=pass (policy=none) header.from=rivosinc.com;
	spf=pass (imf18.hostedemail.com: domain of debug@rivosinc.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=debug@rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760991765;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h8lTWrnuaZtUDDzLxyuxBqYWe/ZHwy+gfZN7UuG+M9I=;
	b=J+o88xqpLV5Skyxpb/0Gg8tUQp2i73JA1jyzdSexJHzy3t96DA8SMWL16LCR+IMhXGitf9
	M5TMrZR26+she2mZJRTCXr64QxirgdPlBwX849+Fi6ps/sSHf9NhuNDSMB8fHEUMuMtUEw
	dsrqXsW81R0DsOlQM6miNS1eSg1HjsU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760991765; a=rsa-sha256;
	cv=none;
	b=paH77h03VQepTZsNNTfvchTwcVPjZ4ynrXWTq4Wxik35nvifxIrPAKq8F/meZw0lty7dmW
	WOEEmqOBZEtcVUa8b/AGdGkLBsiBpEeozq9gUUCWcwVnMB4P632RQcy6UlVciO0F/Hkr5Q
	M9Xzr4qD8yPX9KYxra0nMK19FMv51fw=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=WIblnoRK;
	dmarc=pass (policy=none) header.from=rivosinc.com;
	spf=pass (imf18.hostedemail.com: domain of debug@rivosinc.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=debug@rivosinc.com
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-7811a02316bso3295251b3a.3
        for <linux-mm@kvack.org>; Mon, 20 Oct 2025 13:22:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1760991764; x=1761596564; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=h8lTWrnuaZtUDDzLxyuxBqYWe/ZHwy+gfZN7UuG+M9I=;
        b=WIblnoRKFtkm8hnFQRMAi6nBSVa0k+1wv42hqs8pgabAVG5YgoaltGp+W4BJtdwo9W
         d1zU5wKQpwEAnH1QyZXniwZ6uVG/bqaRQohsihzHAxxLxmTdX0NY11+TZUL+5KEd8DNI
         QO2YPAZcyU5tPB0GbhpoGTMswksPkm1cmivkVq5dDMK+ybJGetXddtco+WYPA7cjwQ3Z
         d64mDmK6M5DeAhIAx3gUVjAUNZq3CKCUYGD0iX7b4PuUAg/T1SQxMNW1YtSYWGaVlw4W
         Dk21tvh/fx6Lr5ue11hN2mrss4cnt5ihe5PloNLCnE10rdP4G2v6knWdm6BCE3DpnIxo
         W6bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760991764; x=1761596564;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=h8lTWrnuaZtUDDzLxyuxBqYWe/ZHwy+gfZN7UuG+M9I=;
        b=iCcWbC/9Fuf+sYjeIDAohCVaQDLfuhRHONyGf024XxzhUhON/e4M6bWCTeB5aSDRn6
         ruTnuyi0aaiFKticHUmm4H+ymCnQ9UyniBoO+gsndURh4EwYqF7KPEey6qCsZurxGru2
         dq2lEhN7kviPJvU+aE5042BFPy1rFpu1Oy5ZJGR0GzlxAL7PnYD2z7+v0ZQ+AmFSAqMj
         i53JZ0RZJ/bsCh0OlKPigXWHh7L7ZL3la7Cgvhsh76WzCWvO3Bt0seB9UgYK2G/dWa73
         +El5zWLNgulQGiKarnRvhGzulkAYk4YXsjZxuIEWoAaL6kv36Ym36pJilCqdDQW/L1ns
         poMw==
X-Forwarded-Encrypted: i=1; AJvYcCXWihRWLE757nnO303xqtDHg81G2NarQrdZDJBMcudh7B2/RqHckOujBuVYYK7o0PMB0BFgTXtmsA==@kvack.org
X-Gm-Message-State: AOJu0Yybc1PimNzf9vEM3ILKT6cEs9xD+Q4upWkRfdBZ/F3C4aYGrAgc
	WSaicCI7v0WOUjxWn2lK2/W/h+k2GwKV6MYVSW/jnxB49puczeyY8+qTAi9Y1e9eC/o=
X-Gm-Gg: ASbGncsnsY3a3C9V61z+t7V8FCvAqFKo1BecQ/Mv8/O28jd6+IWAwcf0w8gRedMiD43
	IddML4KTyWrB5QcFnGFJxoWxtl9ilwlcZ8oqvkgNpmVcLV2KTnC2RCiTf4IOrxts5mj6MSvD+xn
	5mQ7u60D9ha/Gr62ab/qKMCT+jjz2z1+EOW7RAse4YyLdafLOm7XKWz2uqU+lWjvyvGi/LZgAAB
	/rwtcHt78DxN0+7b4Bc2kFHBWHfJ/6NZ68JJWpmplBPyarafagkvU3sbNrKZgw1pKuzzxM0yeRv
	ho0BLMmgxMDj1jnsPvNk/OSFRGZK+WTbv4TwALlMnpCJtvIZp9bv+VwOj3n8XMLA0cj1XCOveLO
	TPoEwmYN21Pp7+EOxmPdrlh0hGlf1a8awyRXr0Hozhfa833vJtvFT8oEZclIKoKszTvooDdl582
	8gYC/SCwfd5dEEKKwFc2lt
X-Google-Smtp-Source: AGHT+IFYCNd5k3pGg0Gz/iIE7tYiAa0kkuCVaIcl8Ah/rVJcGwXUTlIvT7nX8rovlHoPNgWT7bMyjQ==
X-Received: by 2002:a05:6a20:1592:b0:32d:a91a:74d8 with SMTP id adf61e73a8af0-334a854654fmr19468716637.27.1760991763968;
        Mon, 20 Oct 2025 13:22:43 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b6a766745dasm8443240a12.14.2025.10.20.13.22.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Oct 2025 13:22:43 -0700 (PDT)
From: Deepak Gupta <debug@rivosinc.com>
Date: Mon, 20 Oct 2025 13:22:32 -0700
Subject: [PATCH v22 03/28] riscv: zicfiss / zicfilp enumeration
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251020-v5_user_cfi_series-v22-3-66732256ad8f@rivosinc.com>
References: <20251020-v5_user_cfi_series-v22-0-66732256ad8f@rivosinc.com>
In-Reply-To: <20251020-v5_user_cfi_series-v22-0-66732256ad8f@rivosinc.com>
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
X-Rspam-User: 
X-Rspamd-Queue-Id: 3D01F1C000F
X-Rspamd-Server: rspam02
X-Stat-Signature: 7pktroiddhbkgnhsfas73wtoisi981dn
X-HE-Tag: 1760991765-561156
X-HE-Meta: U2FsdGVkX18cM+x74xB8szAfgmC8a6C3q+qhk8REdjtqsQE3aTTT52ehCbIFhL8DGou8v9PL8QbZpBNLPldR/IHDk1REcjpai1jjIHj+gN870UqmFU/qSOeKrlf61QjKaBq0UcPAyGimyLgtjGGrZL5ajhkdwWBjF0C9jKqmF9ch9fmI7SRhSueor5idSK6NvO16XJY77uPe+UdUpPofZdD7yLyL/IgdDwFf2OQE+O4/1Dw0YYHXrMeqpOWOnIls2gqKz4EM2JWloePaSTwqVP4IOhZK3qh3IdsALyXd71v9MoBmsMbXiKXHRxAiVqwmlg9hXidJe1Fugd/w9ToD7SzswsPktSHpdgid6jx8NFoBmBfk8S20/1NSoUf0gcK8sbtM1lSACZMCzePOVvh0AOZIq9zSa9TbJulhOSH/tb03XEoWlkYuQgMo4A2f/VijThewn6ahcSfa2gJNCSEphPyHxC3fC60JEy0/AhnpbAgge6OPNxYzKl7wx2JjQzRTAbIF9h/mqK/HrDfvsOa3FShdx+cUQE9nQcZPY8IJG6xRqJVML/lPx+XAMMP7Wyo48SOB++y9tsOdrizJVwmodFKlGNT3DiRgsnUiHEyPDR4vfgy/9QJXCBSDU+CLZt3dHc7prkbIVRDkzw3Rq9Z1wITpg841cWpqUSaPLdtViSimvsOxvFXTA+/LJ1gbyrKRmC+FEof0wvHYydZDxXsuaqdWioG7emgFEtgn94eIpodfINLr+1edFqyui1Pz2C6s9Rzq8Z+PX8lPXBzAe0XvzaMtsJsqYsXFTTlKvn4HrqiM3dsRSpqm4LnikTE0s4pBzitN67eww4tprmg1gK5l5P9AsqRNCL3rdONBhSiKaQ4eLb2WyJJoY72sACNBEokcUvxwXUTL69ZCEBNdSBrGHn7qwB26ebcMDKTOTg1u6TN0VxwujUywkpbYxUNnsHx+n8SI48pwZiwzqxXT4pu
 rKE62REx
 N6gfjhALn40o4lQZ7DzHlB1DOgTF9T76c0GQSwXPZ1yqisUVvLlW6rcqaHTTpK4N70+0Ptf8qu6HE78MN4wq75sQhTnVcI2Q29itegEwN7l7ch1XQnTpdBSd8pz9S/0VNmrDgyU6ZkzI3bTf48D1j1PVfai/nEDVr8+XnNWZaD22W57tDfohQSVtqHGKFqAgyVmF9G1STDe6TM1cxvwOCOXy4gqV200fEMCMsLDzOS9d7wcMaRpPqxsBeryqx0Lz/kTrnPtK5VFfkMaJeoH1Euv90YsKWLKw7S7fwI2wFamgnrqSbnp0h8aRQPg62kO1HeQrqAyrualDh43CoL/YbB/titOom5JqSgQ+rY1Wa3eSLj13WLZh0on28YiaQ8w3McVcVZpnoLTYv2O2Prcn/7KTpWUwr3zpC3qlj+bAIHo5aatFRZlRo5p8cNNKMus8AGDBcjmBozsTW0yqwmFK0W2WPSOEUw1aQoyAb
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
2.45.0


