Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8D14D41D74
	for <linux-mm@archiver.kernel.org>; Thu, 11 Dec 2025 17:21:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B38D26B000D; Thu, 11 Dec 2025 12:21:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE9696B000E; Thu, 11 Dec 2025 12:21:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B1626B0010; Thu, 11 Dec 2025 12:21:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 816AC6B000D
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 12:21:11 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4370B1A025E
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 17:21:11 +0000 (UTC)
X-FDA: 84207855942.29.70B7292
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 4EA7CC0008
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 17:21:09 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kHsf7v3C;
	spf=pass (imf28.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765473669;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SffyuK5GCVuIGJkkqfZl/rcjNamup4GISt21xN/0eCE=;
	b=OaqVwV8yhCjBfd547LVN/fUmOMW5x2fI+SkNXjRokOPAJpkQbGmSYrstGVQDqCSHYY50QY
	28YD+P+M6qTnbik7QqzhGGp2Nu0+WctVnba3WawLRO3zXLIcpmJe47t540/r7NvdNonUPQ
	4eLuF3psuV2x4XdSXYeLZiFMU/6VLp0=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kHsf7v3C;
	spf=pass (imf28.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765473669; a=rsa-sha256;
	cv=none;
	b=4qXuHPPCPHtT7mf+yAfSk+OxYe0273VkyDQnHNuJziELoYA0IwpTl/QRuEtJvSCYQv0SIU
	DVZ3wCbHFPpOLO6wSs+5b+u9GRMafagHuiEtPrRVAvA7E0B6ykpIG2GYEX/wINYG8sYLp/
	wjdCOUn8iXBT4eQekc31gFv9tRLxI3A=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0B77A44459;
	Thu, 11 Dec 2025 17:21:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id AABACC2BCB4;
	Thu, 11 Dec 2025 17:21:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765473666;
	bh=uDer5meXOB/owYL/ZK1ACAWj8r+T+Qrdn3VNOnnw9Z4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=kHsf7v3CP4Q+N01Zu6rk4ye1TPQOcNNagl942W4R/2jcZpOgT9wUoYxPqjUq5YSRd
	 0cHs+IsGzoidmDcXdExhmwudC4CCPlxZE8eqCIKXRPniPjx5XPRiMtvaggtM5zt6gG
	 jeC9Cd7FbDQ102fXE+CbPpLh291IBMuI2Tr1P3HLzlWKuRLp9+1F655XGAXzG7mq3S
	 70mnPu5wJIUzbbMSlDLiR5G/Nd9TMc5GAZFKdnmHxoDnX/sBROT/fUnwZGbRaYNZND
	 7Y8O8kaxQkjLG6gSCMj/4nmRPuAXQI/zuvZ0jyMFiYPagdvy0gaGsk0luIVI2vZgdS
	 ni+eB7rIDnljQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EDD9D41C15;
	Thu, 11 Dec 2025 17:21:06 +0000 (UTC)
From: Deepak Gupta via B4 Relay <devnull+debug.rivosinc.com@kernel.org>
Date: Thu, 11 Dec 2025 09:20:36 -0800
Subject: [PATCH v26 03/28] riscv: zicfiss / zicfilp enumeration
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251211-v5_user_cfi_series-v26-3-f0f419e81ac0@rivosinc.com>
References: <20251211-v5_user_cfi_series-v26-0-f0f419e81ac0@rivosinc.com>
In-Reply-To: <20251211-v5_user_cfi_series-v26-0-f0f419e81ac0@rivosinc.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1765473664; l=3702;
 i=debug@rivosinc.com; s=20251023; h=from:subject:message-id;
 bh=tN+UqM0xPUhz8OyGQ7x+rHI6rGO+XR4AZvntK+Oh3u8=;
 b=OJBdF6romT8wDF8maL6Qct6Qr/OO3r9pSNoaTSsPWMVTUoNJA2PaEXUSOBF4dIxCT/DEJB1iB
 5y0OzfHqo8PDxUEvCT9OnJ300Q86uAq/vYMgLLYfk36mmzlKLOqtf+E
X-Developer-Key: i=debug@rivosinc.com; a=ed25519;
 pk=O37GQv1thBhZToXyQKdecPDhtWVbEDRQ0RIndijvpjk=
X-Endpoint-Received: by B4 Relay for debug@rivosinc.com/20251023 with
 auth_id=553
X-Original-From: Deepak Gupta <debug@rivosinc.com>
Reply-To: debug@rivosinc.com
X-Stat-Signature: 465wtxk47sftqj8rhdyun3pbn5ftamby
X-Rspam-User: 
X-Rspamd-Queue-Id: 4EA7CC0008
X-Rspamd-Server: rspam07
X-HE-Tag: 1765473669-287609
X-HE-Meta: U2FsdGVkX1+ckixFmecwI5hkz4yKtbEjvYFbRehRwNXGlCVsDyEokm4xxDmQRmrb4QRqOsCMJZqKZA1grx4Sd9RgN094JAkeiNa98xRZ9AAmoVWumgKpbi+kSTB3NpiOgTyTNCQufTysrnWHod01Psj7MMTbg5GrG+d9GGeMa6DX7i5iIlowJ6AFsOzoTCe+FGdhBQbh3I/zs9SoUrB06Rt9aLcmH0KvB/BJH6gfVrcRHMfqJFvXZshEvSTNZXlFWyikJKLQ/vCEuEddgNlLWuwRBlH7Pna6g3RiQNtlB+xPwvYC6II3YyvfGgFPwU+QxFCdfHvtcJnmZvMyvbTZjkwvEPXL0yHMILhOa4l7/IZJyhRF1Zlc6DZ7GHj5ly4/VAQh/UlDcikZt1VyrC2OsY6dKZ4j7Fc2r8oMc3ymrS65IhNbwgCQlXeh2ORd9w22TrNN6GS9esgbtLjprZi3ZTVC3poF+1zQ92m666wkJrhgpwonGsl4z4k3S/vQXAn+yh3xhMTrxg4jJNWDfUbgpWt1qJEGb6GIwVgnu+2yVfPvDMLq6kbSFy5ZpEYvPvcGpruEMeIIw6beXhR8Al+sQYhOQ0a7tnQnloD54qTQ9S5QrGMcFUUANf4g80AZPucGH716YtHpC5rlvFtwRpbWh+B8g2As3rtNwTk13vlQY89j5Usn3pgqGN7wQN6vbUL4rYZunDeQ+b9hRRfBAI6frttsu9feBLyJewWisYPmnv9cvmwLkugJ+3BPsXFP8h64Lr9ukAG7VQ2oNv3+6l497KtXrSdoLMJpUiY4YmCh6KiLWle9pypGoRT0aNZ+M7G7FBjzVqvqoRLpJyNkvEehOqM/cLQjsHgDTrM5JUHEPSdBbYiV6WtVFpEc1YFh6ULZI5lUZxogmsP3jbnatuSBg3fPcWSpKmUEJQqZpA4FMIRQ0D4P/G0CeNVXWdLJ79Jwv9QUN7ezxt+J7mUv/D1
 I+5beSu/
 jWqLEPq86Xhr/TxDjVUHBgOA+5b/Gpe5mx/nzFUN0Wfj6sem1UGe4K6vyZfDbR4KlDH8Ckn65lgo8pQzzH7q32nGkNz7fz48wFXCgC0Eug9mQ5iCbNV46RELrZw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Deepak Gupta <debug@rivosinc.com>

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
2.43.0



