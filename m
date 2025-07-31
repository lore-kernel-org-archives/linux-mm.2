Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C643C87FD3
	for <linux-mm@archiver.kernel.org>; Thu, 31 Jul 2025 23:19:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A55166B0093; Thu, 31 Jul 2025 19:19:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A05EA6B0095; Thu, 31 Jul 2025 19:19:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8CDD16B0096; Thu, 31 Jul 2025 19:19:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 785E36B0093
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 19:19:30 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3F95A140340
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 23:19:30 +0000 (UTC)
X-FDA: 83726128500.09.380F4CB
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	by imf17.hostedemail.com (Postfix) with ESMTP id 4ED5E40005
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 23:19:28 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=rivosinc-com.20230601.gappssmtp.com header.s=20230601 header.b=Zy8Y4Y39;
	dmarc=none;
	spf=pass (imf17.hostedemail.com: domain of debug@rivosinc.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=debug@rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754003968; a=rsa-sha256;
	cv=none;
	b=lxjOnAcncYMX71H73y7fA4TxCkWnKW+XcVIusXcjC9BWgysJdHA6zbArsfe73V2LuyBqtQ
	D/eNNXiMOvyF8TEfnTrT1+2W9uLxnqZcGGhKRshLNJg9n0OIfhRNFkCpdJmtm3EKbDSMlT
	+0wyqNtn/VX+q6cEbaQ4s9J3OQg3S3Q=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=rivosinc-com.20230601.gappssmtp.com header.s=20230601 header.b=Zy8Y4Y39;
	dmarc=none;
	spf=pass (imf17.hostedemail.com: domain of debug@rivosinc.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=debug@rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754003968;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R/zH7pR/lYDXTCsVz0jr8PjmlJlgvFu5fq+fqB2fhJ8=;
	b=aB7d+nUwqoBu0w3rPZcWd+JfgkfV2L6YeF7ricYmBqBP/DCoWQohXKH+bPALCk7Gd3TA08
	TfU23RfB/9qOC24hTTNFEuEFsmqEK9JxHba9TB7HHHRjjq20ZP8YWVyctIram87MGpKcc3
	E7ni78++KManHKOwrj+MEv0Lct8d4hc=
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-76bd041c431so1168360b3a.2
        for <linux-mm@kvack.org>; Thu, 31 Jul 2025 16:19:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1754003967; x=1754608767; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=R/zH7pR/lYDXTCsVz0jr8PjmlJlgvFu5fq+fqB2fhJ8=;
        b=Zy8Y4Y39o/uM/PVTBamoaGGFvMJP2dZWFTMDQEQRr5y4QMEiF7Rl5scSTUWHUR9pD0
         TYoIWPFVxtc//ohN8LOBzqGrAoGYXd0l4i5JLHHWzuB4GuS9ufyVik9vZlqQ3KGy4hga
         nLALvU7uH8hk8l0bL81jnV1/KLYkX+ID0hM/xK3+ckXbHwGp3WsLdeGUouSkRjLzD6Yo
         vHPfn2EaIgYeJsIKtovS9EeIO5sycfBewTzUOqsPEsYzUv8nbrZTmEbdY79Ru0ay6dsM
         s8DsZCHJ7AI0qzdWjXtIhuhqhIsilaA3OxYJMaCrfx2e6cP35CygoRNUjTlC8Q5EiqP4
         MO+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754003967; x=1754608767;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=R/zH7pR/lYDXTCsVz0jr8PjmlJlgvFu5fq+fqB2fhJ8=;
        b=OQb401H1ksZGDzSHsBthBLnjfxkwHJL2ScJFOmdLWMx9UCKxMmiNfP990q13/6b8iZ
         /rqOP+iKEkEKjJPIMPKU+Oed0AfqvnpwCjd1eCFMrV60obPlhjmTefu3dWzhlbJ5fSY/
         Sy+bB57Jm2xNBA/i67q2CKj5lpEnEohI00c1MLRJXx6QvlCIUJ25kJOqyHxYu/BjJH8c
         BevBzJKt+Ke6nhFvvtnWIMZ3idH2bs82IJUXW9H0r0GdOEzPq/p5INmBvBkQDU+f9aKd
         G7Os/AN3zDHVaxY9DKc4PavLFB3+1op+PiSlJEFbtUCMnj86p9u9VvjvAHRuamI4rDoz
         DIUw==
X-Forwarded-Encrypted: i=1; AJvYcCULfQd3eqH1n7YKSwdJq8zJRYBZuCvD19NsfGCfMfq71GN4M7CqTIbNGwsZTZ5reKZBjSvGBK52VQ==@kvack.org
X-Gm-Message-State: AOJu0YwkjpAJcYswVSXbflaz7j19U803nR7wZ+e9DG66e6s5j+OLXeOJ
	SrErGBTq0YNn5tGlqGfaYxb2q4xD2D5MQsADJw3k1SILFLOQyVC/zlTqFtE0JnHWVQU=
X-Gm-Gg: ASbGncvk/nLAgJ6V71bBaiFOkP72oHZijSITDWf7hcZLxUYETA9aookjqZaAp6pnE1f
	JWdZWk9Fn8sLJsM1FZy/i6FBXlMk1bp+XQar6U1Iz6vVfJwiLZIJBmESaxdHFz8yuumYII4f4CV
	voyJGKR0kvdllya2h/eLpuqJDpKhewONAHhW/MrvYFFXqOcjWl9AopVyt/ZMmr8q65MRB0HNKF7
	uh/2pmuUWH4ftNoBamGybbhqgV2mfqZ/YO/QUY85sSPiSPjlbz4mK30F4aWrtvqV7ge2AZMZ7kk
	xq1TU/k52Bt7n5r20KKxk7VK1bd9U+a1IzCqHyJKurB4RaNjiWTYaEwirFOTrGfVDQNaOvuBl2c
	Tp8lzi7pUR3Cgqsg5weIBt0to21/cAdwMc0KuSb2exz4=
X-Google-Smtp-Source: AGHT+IGYtHbkIIYCjaK0pApil9XPoWC3HM910LxxJmFY6X3GTvEXVCJzuEQBTa4Y+eDTOHWGTwIO1w==
X-Received: by 2002:a17:902:ce05:b0:240:7753:3c22 with SMTP id d9443c01a7336-24096ae530dmr117950085ad.33.1754003967144;
        Thu, 31 Jul 2025 16:19:27 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-31f63da8fcfsm5773085a91.7.2025.07.31.16.19.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Jul 2025 16:19:26 -0700 (PDT)
From: Deepak Gupta <debug@rivosinc.com>
Date: Thu, 31 Jul 2025 16:19:13 -0700
Subject: [PATCH v19 03/27] riscv: zicfiss / zicfilp enumeration
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250731-v5_user_cfi_series-v19-3-09b468d7beab@rivosinc.com>
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
X-Rspamd-Queue-Id: 4ED5E40005
X-Stat-Signature: rtmhacfjz5dzosor6oey1a7g1k5mgac7
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1754003968-986713
X-HE-Meta: U2FsdGVkX1/j1+gXZ59N+QasuatUKwxZYEUbrTqaAhC29D9HYqxvW6Xwyspzr+kd+/r2xaJdiauTTleIjThbC8FZbgbOQL3/BBrIVwqXrqBp64IGb7BBogJyr6Ate4fbkaaVf9ohyCAGnVp3ihEiBNtOpN+WOeR/jco1l12JPYPuKjmJKze6Ts0fgVrwHAqhr+IeP2P1wu/B76CKZBOqyf1cJWT5O1xPRG2wGHbYH/y0s9sYxmzhUNvWpJG3tWDPcNqw/tUStpQM+fUr+0CilRap2MBq18k/vVmpBqFPRuKYUmaFXuSF7gyXAVvPiAVctOkUF1OWq2xu7c+UQpLCrU+8TAJ+vKoL+NB+kFiFBhNq4eMpB4FEJgmSk3ZvV0xFYIYWStaAxh5JNAlp3KpTJiUu9Bz9zoL8leJzX/oQG3LXJfyjCPLbWPUMQZk1xyM3IwAvMOh6fUWD/6npHJW/tR5HiV5MNe5BB1fY7Idp2KViGmCVFsCYUxofVp5TmLG9RZxaqXTgQbouZWCFTCjS0b1/kbjo6Uu2nRCvmaOO2zGd9m2RP3Ri/aJnI4MTDp13Pej1XacFUT8q8VLVutFfuK5RMi2Isb0c3AizqzpA/VS6wX9eqZ2tcWjK18xNY/ZeaXNgsSOPxtrPcRgbUaKSxZe2Y5Tx05sm0xzKtFJx9+pWYCzR5Q7nbnkof4o1BUGp7oW9Kic5yx1BsNYe57k8rPUez51HLolJmtEZDGrDi0nH3ylP4Ww4NUrLWcqFpxtDIMzVRkS3jDaPv2kKe/P4PTef5IsnO4bEaLzi6UTYqeMWVM1baLIzo5o2B/xAJmlNM1vCXHUmdXlMpXWoy8gtT1ZDUCBd8wwlByZ0BGso8QsW3TfrjKDOeJOPEGbyOES+ojSQiUA16m18nBHGiW80u+A0Vi7YTB/oeeEx39M5/nNvx27t67M2P4yyr/e0FQqs9jfprogZZ3YpaHrCk6w
 3JAsuztn
 KzIVRwoAv1HHwHDkfEw8yrUcJ13FY9TZBgdd8q50Mwf1tqEOcUyMqtyr5oENa92IZBSBfYPEU2q8pHPG9nk/br28qXr2C50rdt4Od4HgXOQprSmLMKFrcO9RCFD5gMdcayhmQJeI1H+MjnLOK9rsyqUuKdq6446MGCaai2lTrGatuA92l9V6OkfOlKPVhOe7KcLaCTug6bb0tbCMu2ix0zfFDFhiYcLqPG8Xiu3y7OzNny1m3buqOgtREeK50pppAB3U8pt8SzdfvN7kNVWQLgS6/ZwKn7r+OhLgLT2IGH8Rk8Tp2XIxRSFbl8c/OS6hfc9tZI5MbLfLJ4JJ7DLra+OMS5nytq1ZUheBjl82y8TCQH44oogvWI/JJDS9nawRvdaSE5oh178CyabZw1NvHkK58e/+SgqVFUYe9v5iQOE6i9K4sAufK7EyjPETHrn1Zy+cO+kOgw7I+rYZWt86A9QvbH5pjrzLkXwVcicl6jktw3Jtw4ohRLmbPZq5CNfHWMqffwcJRmhCid1hjOa9KCQUA9tGTlsYl4nG9m59MJehmwhY=
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
index 9430dc198caa..c5c01efba3e7 100644
--- a/arch/riscv/include/asm/cpufeature.h
+++ b/arch/riscv/include/asm/cpufeature.h
@@ -156,4 +156,16 @@ static __always_inline bool riscv_cpu_has_extension_unlikely(int cpu, const unsi
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
index 743d53415572..d38136672650 100644
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


