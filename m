Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62CE2CCD1BE
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 13:25:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1EDC18E0020; Thu, 23 Oct 2025 09:25:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D7EB8E0002; Thu, 23 Oct 2025 09:25:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F0CBC8E0020; Thu, 23 Oct 2025 09:25:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CD4A28E0002
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 09:25:46 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 921E8C0996
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 13:25:46 +0000 (UTC)
X-FDA: 84029451492.03.A0CF410
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	by imf14.hostedemail.com (Postfix) with ESMTP id 8E9F0100010
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 13:25:44 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=c0myh21N;
	spf=pass (imf14.hostedemail.com: domain of debug@rivosinc.com designates 209.85.215.169 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761225944;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=njWxpRWfJB7aZ6YZP/EJ8dyU7DPEUOfUxx+ytpaopVc=;
	b=dKXij//nzs1+7Vae9MlzL+TcOyM8Pctxmw7b3o9YfIwLy3gBSf+dKAcmKb3IoDQ8vgH/4B
	HYnofPO1ky/0HqCuHWgzgwEAGu2CJcnHj4jdYKpCh/+UZTlNsYAHkBlS01jwbp8telb4Ek
	U0UrGQcPrKKA3GBxBd/h7EC9fNcpLYs=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=c0myh21N;
	spf=pass (imf14.hostedemail.com: domain of debug@rivosinc.com designates 209.85.215.169 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761225944; a=rsa-sha256;
	cv=none;
	b=yM1Iy2BTcnEW3epeGmflp4aDUTurZkdYJ3tJuQQ/nC3lt90T9T6ZfH2D6YUXScy8n16IHr
	+vENLApGZ2soghm6X+bQTYzFRwgIVsqM2iGKKz0HihjF5R0tvMJf4r657/XKYitFyy/MQ6
	kHjf22bFdCy7wxaD5p1r9jbPm/Y/8TM=
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-b6cf257f325so714463a12.2
        for <linux-mm@kvack.org>; Thu, 23 Oct 2025 06:25:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1761225943; x=1761830743; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=njWxpRWfJB7aZ6YZP/EJ8dyU7DPEUOfUxx+ytpaopVc=;
        b=c0myh21NCwaFt5jXMl2VQTZVqTitXMtSjqn5HI3FS1dBy4amsuYN3oLO1lC27Q3w3S
         yxDCAJ/NiGw8/YNCGrZkDxxSj89vgBVsHzAyoARiRghNogcDIDnK3Bh5fIAWoRHCeWSV
         wp0K042Y9+avf9HGTwknIFl1ksoqHF9e0SRI0YiXfmYViQg0f2C1fRYBiK/9su9kPjm8
         KVI/TPIyhIHhiPUi/PeatzsKMWQdpYxLkPZ50fWM8K4AykXR4pWXc6LbLxwt1R1nqVeH
         4eaaZWLCK7bVBZrjIlefB4PYmG/5ykz3dWcckCT0kU8GNTX5oM05qgj++RjjlpDuotwG
         Bcjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761225943; x=1761830743;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=njWxpRWfJB7aZ6YZP/EJ8dyU7DPEUOfUxx+ytpaopVc=;
        b=lT+n616ylLw1y+Ywc2NYRhewMPjz6FkpS9YZnyf9qtiiU3fFTRhMfkaygIzP6e75z7
         bCrd7eQiORijqRsAlsVSCHIXbfF5Wp+EU/RJB3GO+bTVrVxqCpadFA1eaxVd0ilzIFGQ
         6k1JkDluHeuXhsp3ylJCpfsDv49u00CCMbophWvuvoyyR6T1unKsUu6q3T3R9cI+MBs9
         k3cLMqGqvRj2pW5ypnbmFWDSiAdTbRETsZ0NlWQ13YHKsmHYjsMPbJWNl/nUTShjDHhs
         75ii59cVoiDD4rhYKsK8VBzPCqNZ6o2LuIILYEruwPDYERUun+g6mgvHaP//j0rDDw5F
         c9hw==
X-Forwarded-Encrypted: i=1; AJvYcCWXHPVnzrTX+fraD8HxIusFOgXxNVsk7TUSOV+bfoxrbd5+p8JRyI7ce8RFr4WA5gkDBWCWICjaog==@kvack.org
X-Gm-Message-State: AOJu0YxDk++FYZvTzsr7o8hw7yfUk8e9eaPMRLnawitGTdHN4TD+ZHJx
	y4yuE7Sik9bqcCbCL97Wmb68txS86NW3orG4SnwWUxNHbyIAj88lUoS9UlwPEjXyvnE=
X-Gm-Gg: ASbGnctE3O50U7etyfFJoMGMr/Ajg15CHhADhERxwgq8qh2VIfndRc5Ktf9Zy3B1aFP
	yZlWVEP4/HR0LT53DuHPQR7U45LPV+Dok+ovHiyEyTSNoZEnFio+NtLhqlvLo1ooLikykZoqJSv
	fkMZ3eXepqrVZ3PmI4N0JbeSltvet3E94HLF6hzrcjt7OAdKYoFwLxqkC3zj4CNqurdvOtFcYEe
	Cy5Y6wWmHDIF5js+EG1nnVe9W5rtJ5H+jC54y8MLqfEsJrwN3/UQn+WKuhrwz26r9JIuPU0I54i
	Hi1Q0gCWoQTIto6vQsf8V4R0sWwQlu5LPpTJc6NbNK10GrMUMIg4OMtoq5DPcWW/YwtoVq8qJWL
	mNdOX328sQCR7iglRxlwcvzJyfY7wDBnF5kTlSYUMLxVQ159pCYL002B5R9B+wZ6ZibvjWzTqab
	WYntZQST3faQ==
X-Google-Smtp-Source: AGHT+IFvP4Q1thZhdrlkQ+O5ai3McG5WbONbV5748++FuQG+JO3GJT99MXV1Kz1R345XNoIb4pOrLQ==
X-Received: by 2002:a17:902:f691:b0:290:a32b:909b with SMTP id d9443c01a7336-290cbb49987mr324468245ad.44.1761225943304;
        Thu, 23 Oct 2025 06:25:43 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2946e23e4b3sm23432035ad.103.2025.10.23.06.25.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Oct 2025 06:25:42 -0700 (PDT)
From: Deepak Gupta <debug@rivosinc.com>
Date: Thu, 23 Oct 2025 06:25:32 -0700
Subject: [PATCH v22 03/28] riscv: zicfiss / zicfilp enumeration
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251023-v5_user_cfi_series-v22-3-1d53ce35d8fd@rivosinc.com>
References: <20251023-v5_user_cfi_series-v22-0-1d53ce35d8fd@rivosinc.com>
In-Reply-To: <20251023-v5_user_cfi_series-v22-0-1d53ce35d8fd@rivosinc.com>
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
X-Stat-Signature: qm4yusjg8khnis1ynm3swiwyyhdriews
X-Rspamd-Queue-Id: 8E9F0100010
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761225944-961424
X-HE-Meta: U2FsdGVkX18MinoJHE2wjKqVysID9PPhXKRyPFIHkNsXwlkQywDZDVGfj6uP0AER8q3P2PkorePbx5OIVqe7BGg01TpYPMpwdTX3bDDzNFXZ4nqEbLYIqe24Bx2DMEV7oxIrnPXgqGH8Wgh6pRUa66LlNI1xzU8eUCDg4IAaOCmi2KR7S++Mm6F8/RK+movTBOID2ui0XMd+az++beQLRr9WWsgl4oQSVW/DkKObD58PQtv5bS1twCcCtygOw/1HFqmEsaCbK0cTOJhvqH1qMi3R3STCkOihtx4z+1y60B77l+0mqdKT/xh6zFx/SbuxBcrNvC5BFuUmeO3k/ue6LLfMUtbwuUM1LnRdoGZQBsMJdGudEMVOw6y6wdlAfi6/bkPtJUt5fsyZAl7oNQa6fJh4GyzK53iBKjVhlqYg6u7EVDFXmwVcFz2KAGf85qvkenrN58il5LGOeytJwmIdKQXqEY5MhUyuLg7y1aZDy31mjfwnThyOk6XFFkAIh56ssdvRcv0YxXHO9bpP/RMXmrB8JSMqQo94uJdA6UbjHEiE2rDZlgwJC2wytEkeL46lSt0tuYdni0rkyfvV9FDVDbP5f0sPKXsbb1jhaWKF4sARVitWiBKXF3Rehh9M7WcVoq5VM6K4fvh5ilVehLO4d2TZQoVkRCQlvRWVJVicOTkYWeNjCrtjvpHdm5nH2Drax4EBiccXdaygU3bhZfvtHDlnK+ZYQoPWm9mXSrw7J6O7d4Tbk0V798pIguYYLRfjy4ehHbf6XxqngZ21gXpRJM4V3qN6Fdwm+K7Ir0vH/fd2nBLs42fezrlZyqRSEP2HAgJuxRwhTUh7i+D/h1zm2SkahffZwkqYWZ99VqWCiB0BBz57Djx5ccXGhxyIbOaDeiwPP6tY2Rf9tThzrp9fMzxd9aHQLayBkGrbRvsz2ya2XDdOqpWgkOxYP3LtpyZGlgABAJCJL7vIj2PqHHE
 7hiDkPOI
 u7ex/YF6nhS9NRoqeImEz2U8/9YMp1M6PW7+iI7s0BhsePcpMuzS532phnFmJlg3nQJx0EQ0/WJyMH4+Fx/ElEUORPBNQCmyb/Fvuli4IhuOikLlGBUZWHtPVCPW0Mdut7067nyq5+2kghi+3dhmA9SWgKmdzlmMXkx0VS4Y++EMaCZSOLOVGCLiRiF4anLieAxN9wHBAc9AHk1mUktEZyZJDQlO9PhyijGejpS6+HuF9wFIEmoVlrxtO343sJ+iuvMSqM7oBDtQlrqaA4v9fUv4sZT3Gd6Hy1yaa2vcx25Ba241JF933nBmhra5AISh7ZMUtkZEaVT/ku3saV+9sFw3Z1Z4wNWnhZXv/Nafa0N0ZIg9HpwkH2wLqXcivk2/a2zsuEUBoXGRDC/7T9AR2xDXH7T21hXGRfuIo40zRtfFcnCNOCLRCunuUtynZcdAOW6x8yqJU/T3/pe9zrlRkJEtWShvkRx1h56Vt
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


