Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 430BCD339B2
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 18:37:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A75E6B020D; Fri,  5 Dec 2025 13:37:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 709346B020F; Fri,  5 Dec 2025 13:37:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5AA236B0213; Fri,  5 Dec 2025 13:37:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 37C8F6B020D
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 13:37:00 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D1A31133594
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 18:36:59 +0000 (UTC)
X-FDA: 84186274158.09.E916FB0
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	by imf02.hostedemail.com (Postfix) with ESMTP id D4EBD80004
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 18:36:57 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=XgsWtXI6;
	dmarc=pass (policy=none) header.from=rivosinc.com;
	spf=pass (imf02.hostedemail.com: domain of debug@rivosinc.com designates 209.85.215.172 as permitted sender) smtp.mailfrom=debug@rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764959817; a=rsa-sha256;
	cv=none;
	b=GEGnxn8Ryn4vMI6IqX0iU5em90iiRwn8mEVtPeh4apHIZpoNK4AGtzTQ9aQFyn75ZcEYrQ
	ozDmWZ7Xe+g5maitJcsjzTtTxF69JApNHwA0I+HVD+aiCRrPwEi3PTQTaWwoQzW7AFrjdF
	Ra+CjoIjUcxU5AVTaNI4gSvRX5sUjSQ=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=XgsWtXI6;
	dmarc=pass (policy=none) header.from=rivosinc.com;
	spf=pass (imf02.hostedemail.com: domain of debug@rivosinc.com designates 209.85.215.172 as permitted sender) smtp.mailfrom=debug@rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764959817;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Dse2BU+tFA5XFpg+kLbFKrS+f5gCoIar5kBy1XNyEFE=;
	b=gOT6SvIlrqdcmwVgLgR7q6nXulw/ZJw/uMwaAv0Gj8moEeHHLzKFznNSTt1QMMIegBMlQp
	1kDvuM6fAvIev1PQk5fUUJAO5WeptmeGQ6FIXTlvYlzSdTQdxhpMIbZLuls2Hq+2/59Zha
	kxuc885bT87FAEAa9r3fGXCkHnMV7bY=
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-bf1b402fa3cso2231749a12.3
        for <linux-mm@kvack.org>; Fri, 05 Dec 2025 10:36:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1764959817; x=1765564617; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Dse2BU+tFA5XFpg+kLbFKrS+f5gCoIar5kBy1XNyEFE=;
        b=XgsWtXI6l5E1MXsMFmOAjaZt2iX9CTlBPTsRcp+xCjrIKzVjH3g/gFJ4LMGNVVqTw5
         Gw9LvsSnp8FF0TOGMOmvLsQyp7/Ea4DlOvlGkFNtLO6EEqnR4T46sk/I57HiBXX8pkcz
         l9SdOUeDDX+b9ndk7n0/2Z/kSOEPjf6cHJWEMz5jb4GqJkg2NE7KXjC2HrTDU8zYdp8L
         KodvPysfUiHnIS3fAidHZ3vaQj/rJCzhN2f01oCfcIErH0Nmqy7ZqtruqLigXAWX/Ld8
         f4eeYUIolvdrH4H79SdDE0eT318Skhm2hOAe62GhxiDJOMV2K3RlQlGUMkwH8ZyfRQ8E
         rC0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764959817; x=1765564617;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Dse2BU+tFA5XFpg+kLbFKrS+f5gCoIar5kBy1XNyEFE=;
        b=RxEfLoYP0onDKJ1h5Tp5s3cPOoPhp6ZJAZ0aXhFzfMQn+rRqV2RT/4VwDza+R0Z4v9
         SYsxrQ6pEX1AxmB6q1tbTSLX4IbWIc1CFQwQoCvgNIoUGIxyuSCfxV4RyM7VwEedFElJ
         ibcQc8Zzfg5heWg5Az40xeGU3GNN6jHEE1ZRqUgfcWJxbVVeIdCL9ZjWVGV6UZ+lVMui
         EOjxdEIxOF5x/e0RZjHlFYY4S8MgWIn6XZvgBMbnUhdP2G5YPyU5NiJ2HRnUY24rn3av
         QhCtpOPUp17i/y2H1AAx6v7T9WLhTfaKsEMVnLhGOYTwYlY9iElGnSntdH3wN3VEseOV
         BqIw==
X-Forwarded-Encrypted: i=1; AJvYcCV3vMd+HK+m9ST/jMtZVsNB9iN/RTpMz14ECDIepYU72xoBElzhrd8IGUuQvrm6W6WrDlRrXTeS5w==@kvack.org
X-Gm-Message-State: AOJu0YxFwxlGsMHYgi8+5VDrM3vZBGPyFfz8Q+10CC/+Dx57nD7YqkCY
	uUi/vWGUrxCNCYv7POSp2nMvCX3OoETP6L6bu30tHS87juTesRhiB6UOX4XNMy2w+l4=
X-Gm-Gg: ASbGnctJD/TAVzof3xbjeSlZa0+GZEM7wX7bIkVoDE5SfYFYvoDgbSKdVFMA+IrZloT
	GATXyH+2D4mfR+q/yWLRQ4mR4dPXGd/SQ/p4qI8dt/mepX0wYc6324CHYbW4XOE+dCeaAoIOpcb
	CfdIw5kKWr7fzWBSTCi+1Yrp1/Xj7cbGkZFOT0LOaeeYz6zgw0s3WRPGVkikBuNrcljbUF0gTi0
	1vyHJub/Eeem84anCg8dIvtJTiLHTtEbcPPAD60w7+ZqPZvkF6QAWhcE07ijzu9ENJsgwgaVFkY
	v1AC/03MRGLs2t6AEz8OfEkhD6GOYtPhRycROjgGQhi/lrVhU/cg9Ffx2EI7EsSu8c9fxJ5tvfz
	U5Bjm9b4ROO8Pd1AZ+D+JEdRHC5lCWg0dGrlpiM1oA+AJ4LKm2xkIjmJSnJY8nNwLI5MGiHCqyr
	9hNCIUuc0jGNgJXZiX7gEV
X-Google-Smtp-Source: AGHT+IFyM1iqMXt+qSrwno3qrNX4RPHWfEVVmVOUeAMA6kfv6cT+uLIoklBexS5RYMXJgxPECC8Iuw==
X-Received: by 2002:a05:7300:e916:b0:2a4:5a26:25e1 with SMTP id 5a478bee46e88-2abc720560emr74735eec.30.1764959816568;
        Fri, 05 Dec 2025 10:36:56 -0800 (PST)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2aba8395d99sm23933342eec.1.2025.12.05.10.36.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Dec 2025 10:36:56 -0800 (PST)
From: Deepak Gupta <debug@rivosinc.com>
Date: Fri, 05 Dec 2025 10:36:49 -0800
Subject: [PATCH v25 03/28] riscv: zicfiss / zicfilp enumeration
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251205-v5_user_cfi_series-v25-3-8a3570c3e145@rivosinc.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1764959808; l=3702;
 i=debug@rivosinc.com; s=20251023; h=from:subject:message-id;
 bh=ZNC9a/En39m8CKIDJtxwHFeTcpc9wzeOUsHgDemdXXU=;
 b=CKnG5DfBkhW3eeubJ0rh/DdIBdxV1q/U+YHdRfoYgzWhJJIPEPPX9RsQ4SKbZaD16hCGQTrkw
 Ly4EGhODA2TBk6N0k+rFvqtbSJeUjXlZqiTKuE/5YDUsrnziMdkP0MK
X-Developer-Key: i=debug@rivosinc.com; a=ed25519;
 pk=O37GQv1thBhZToXyQKdecPDhtWVbEDRQ0RIndijvpjk=
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D4EBD80004
X-Stat-Signature: 99q3ejpde5bdf5y7whmgehpuanrwa9t4
X-Rspam-User: 
X-HE-Tag: 1764959817-443190
X-HE-Meta: U2FsdGVkX19g5Vp3qYz4oF7kMNoX7wPt2yf+lMJK+7YHMxzClIYDAPnyrhqv8ZKkJ495Iv+FTzC4aBwhuCfnMW7FLBSnZf8d4JIF4af3mSN8p++I1smlC83bSnnQCwUHoNzaxsU9gHB2FU6AJFzLKJC5J8yzc34LG6DmMImkVOopaq+9cURa0DM6lCHhyloGncDpaMt7bKJ/M8C+sxeaXWzF3B6p3msOR7VTkoiO4Y8gkAdLqEqIqpQxjfNWL2+tCPBBUWmhs1K5GjkJ/9mVwMn6M6+X44PK8j4FHKIsHO8AS2Kd0VrSrnearHH1RFJfeVn2s3WcnGrMjdrBMADJdj4pzThFkkJd+s2ObyeF7KZmcOjZ8AASlRgu1aIqcYfL5L3mpswjqX20ryGVIYZpTeChrgyKyzEkuNdOgktYTHAPDiSE4O8sA7Jgf3pezDVu/rIIXfZaF1zCfakW+sX5vO9pcwxXNPSuWB+7W1FTokeoJpNch+IhjJ4omDALMBtBCc/qDYo6MfVs5nrbjUzDfLhlVHDl7BRRi/FkALzlm/c/67Hapefna3Mij7GqzAas0/5GV2WFTiMwMQDGtPcHG/oDjznRJ2iKTjd9wxDl/qCGoNZ3w+Flp7taYlTPNzeTv58elVFBtZsULdShKh6Wapvs1pfauXyd26XqPCMsfx5ectMMjdkCQ/XMp8vHG330X8+e24LErlFJpucFOH7dfFnzn5n/ee7un7Epho1v7Iy2rs1kwYqiHUfqsTxNRU6k3xQxHrtvrQAadL0KmAWHGqa+fRU7UJ+23C1YYV09SwyVQBfW99aGLWPaybJzRF0NRB1cEu4fcLbT8eKlVebNO1maaRMVA6hXCEmOfJ2rwtO5OHPg6LMJwraj/mvY7rnr1t7ihBu1zJiIQhp9+6W7ORHIs3+hYUT7TEwyQ+LdIxtoSMWiE4Vg9fQMPJ43onIkltN44JHBBN8T/C26cCl
 ctx3w7Rw
 GWsTrHPBcAE/w2BZqON0iqV9OjhzRLw76K7gTBX3S9BiO+xMJtetaWg5LfHLnh7y9j7IjIOCLFzivm7dAdkLrEaEu3Hfn87YcO3YgEWyv0T4J0JeNBIB5yWE20MrEDmKsCzQTUmR/NiZ/KcI59ARkWQXW1uTpz36mWw6D7zPk3tjnxSSpS30IAN3FGpz8CoVN3KwEQSaCwtTxzxq3VmiXWdDrKKUtiAt4EnHORn8Bj1a1cFE9MWzJ/MZoRzSwnkazeJq/xK8GI10/engIYRmmv4RQpFy7e37274j/UpwE+/0m9qJlCi17mdI5bhOQyREYwDxMsSwX2U95OScH/5QSHuZNB17HQXf9MRJn+rA/iFRgZ0sMdJC5V9JVGEGt9WjSNfGVfjcJq3qKaarcRWUAR9zGXcvRWW/gOW/ZA5NRKS/x+DGYf56VGyTEacsLRZqR+Cmgs8OXywLuI+9L58dwupD6oW1FERieKYqXOKHq7+b0Hsb5PxAny/qmu4g7C9z22A4hPpnkRKvKxowNCcMWdDdkR6LZ4rMJgNYy
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
Tested-by: Andreas Korb <andreas.korb@aisec.fraunhofer.de>
Tested-by: Valentin Haudiquet <valentin.haudiquet@canonical.com>
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
index 67b59699357d..17b9e77bafc3 100644
--- a/arch/riscv/kernel/cpufeature.c
+++ b/arch/riscv/kernel/cpufeature.c
@@ -274,6 +274,24 @@ static int riscv_ext_svadu_validate(const struct riscv_isa_ext_data *data,
 	return 0;
 }
 
+static int riscv_cfilp_validate(const struct riscv_isa_ext_data *data,
+				const unsigned long *isa_bitmap)
+{
+	if (!IS_ENABLED(CONFIG_RISCV_USER_CFI))
+		return -EINVAL;
+
+	return 0;
+}
+
+static int riscv_cfiss_validate(const struct riscv_isa_ext_data *data,
+				const unsigned long *isa_bitmap)
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


