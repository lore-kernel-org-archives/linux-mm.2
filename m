Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CDB79CCD193
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 16:51:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 36F688E000F; Thu, 23 Oct 2025 12:51:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 323238E0005; Thu, 23 Oct 2025 12:51:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E8038E0010; Thu, 23 Oct 2025 12:51:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0CD138E000F
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 12:51:14 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C6FF588F6F
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 16:51:13 +0000 (UTC)
X-FDA: 84029969226.28.AE904B8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id AFAE880008
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 16:51:11 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VexfKeP+;
	spf=pass (imf30.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761238271;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QC0ScNAjSCKXxLj5YwICpMXqrnAgaozDlP976Z8mznA=;
	b=0xsZyZxOUxJ+bxjbElvxVM2GjC+InshMUQ+an7cckVA9ssv0+J3ExNNu/iPt/sn7iBlFf5
	NN1n/bCbiUYDwmXxr16vUuRknTCQrbPjpc9PH3Ef9EXFUqqDFSc5F97xfoqvFWAUd7PDXH
	dqGoQ7nZhmv5cOkssAvKhvPeo4S0HP4=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VexfKeP+;
	spf=pass (imf30.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761238271; a=rsa-sha256;
	cv=none;
	b=GSG+Y4U6L6Yb2P9lY/0Ob3A4IMF7mGriZdyCrjHGOVQ3Ay7t9i435CYwJNJ260NU7FhUev
	rDwUrbj48qnRIHQYXF7n+/Rh+U+GEA0AXWxxhI8xZCkwY8jI68CuP7pXX1H8ggbbZnYhn5
	ElV3YYeskoRpk3zJS7/qpmz1SAg6j0Q=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 142264AFEE;
	Thu, 23 Oct 2025 16:51:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C0D51C2BCB0;
	Thu, 23 Oct 2025 16:51:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761238269;
	bh=qy72dCosHMlyVaEZSO/0x0kMtkg5SMH4dAjVj3FsaHM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=VexfKeP+0GjqQFjAzE5L+oif3T5em6hRrQJM306Vp8C5F7F0rCcsLxpeEuAYeCI1I
	 8NjBSEfuQAcYhYhTWQreFFnNZocUXdjoFeVtV/RNEmvdQiaw9fz5YYumGsP3FFQetf
	 J7usdZjDhqoDb4hKYSL/QlFhVtRrLXUysCY4GuXyUW/mlU0AvdJytiaENX/2G6BKeX
	 KqtTVUnFWMGign2esWSSqBR8fVudxfy87PD8tL34hv0hSKZPUc0DfrWsWvkjjYNHiD
	 5fxu+ZnKoh40/vzBHxoQN9HoMulY21Owfu5AgEYdV/OGz1r1k5edY4lhwyuhiJhi/a
	 smppIJMFlM+Dg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0562CCF9E3;
	Thu, 23 Oct 2025 16:51:09 +0000 (UTC)
From: Deepak Gupta via B4 Relay <devnull+debug.rivosinc.com@kernel.org>
Date: Thu, 23 Oct 2025 09:51:08 -0700
Subject: [PATCH v22 03/28] riscv: zicfiss / zicfilp enumeration
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251023-v5_user_cfi_series-v22-3-1935270f7636@rivosinc.com>
References: <20251023-v5_user_cfi_series-v22-0-1935270f7636@rivosinc.com>
In-Reply-To: <20251023-v5_user_cfi_series-v22-0-1935270f7636@rivosinc.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1761238267; l=3586;
 i=debug@rivosinc.com; s=20251023; h=from:subject:message-id;
 bh=deI8AoZPctoPZRL1uqTvQmr6gi6xgPskQ2JbS5WJlvk=;
 b=YQro2OnbakPseUD/kFjeSVeE/iiyJeU35txlhId36bc8S/GO70B2r5RwUtPmX2Oe2A5vQhCAM
 9DaIjK+Ro39C0PnhGyRdJTEo4pb1xgSns4EiwWJHlwXzQ7VmsXEai4t
X-Developer-Key: i=debug@rivosinc.com; a=ed25519;
 pk=O37GQv1thBhZToXyQKdecPDhtWVbEDRQ0RIndijvpjk=
X-Endpoint-Received: by B4 Relay for debug@rivosinc.com/20251023 with
 auth_id=553
X-Original-From: Deepak Gupta <debug@rivosinc.com>
Reply-To: debug@rivosinc.com
X-Stat-Signature: y8t3mtydr8dt8uqq4tm8utqirbbg433k
X-Rspamd-Queue-Id: AFAE880008
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761238271-810057
X-HE-Meta: U2FsdGVkX1/fjUYDPjRGnklfhJ1TuyNNoHLBBZ87drX35Upi9gMvtI/Q/vQCKrwJ19q8nETyPbnD0RgHa87WB6Kci51bBzpaTBbbvU9nGv/nbT22TdJW1m3gRACaDTTZZiu1dHSwpWw7w5N0I7v4dYd8T7WI/RzQb9uMAxyd3I5g0L23TJ4HCJchqT4kUGXLIkRNBU5mPwjniB5mpjGFwS6+zoAD+iw3YgTDbKXPXwVId32y7DeR0lw0crLXUa6ETkJPNJT2RiH8gtDUUlRRhJXEeZQKRewp5KvgSFSjO+zSKDl8eXtM3hsbzXjUIGZc5hsREPnfr4E7d+0nFuvQ7hp7eHnG4W1fs2CDZDCwpfdElF50QeuoxuOX8/GyuDJgCu6YepW/6W28raZdXIfx0pxxVefQK3EWx0g6vL6C4p4wGKNboaASWBeOYOovVH3kJCqXZ1MMHod0UctPHZfzqQChZKKbO3/8RT1Y1KkUyDR3VjC+isycQjSFLi+Nm26fs5LWj/ZLgYYWnjr019zA0qbsXwpChw9VM1gXu754jSYGce0Lwtttly9eYubz9nUktEtlbZmqMem2eOMTgSm90AeFhb+x/5Vx2h4DbW9U3cTuWGEemRuZ3n47xoVcuqpSVUOjlrK9WEjyyuY6OXPILHAv3ZqYOOR+jfvhUmeX3AB6SHPFV76npTeP3q68IcMcZyp62UNJWg7xHDgukvw6evOJDPsEi7fElWheyspoHsnhyed5TgjHOt35KNj3l9TJ6EJoBdQg8iuudmql6F5vzP6wB1rbaM6AFdloh9CvcNBJnieLh6lAEyIS2n2/WVsp2ESf0BjDvhcvM+PrnUQxvbiJMxdJSCs61Y/tPjFmf0eY7uHUN+Y7GHhSPYfyMeF4lE6wQV2sjpSsPoBc9QInqbju9QuHFswa8wEklwFBJa0u9fI//RqpAUb1SnAqnwSNNWqJH8TKjPRTnQYFG9t
 whRwrK1d
 ngoiaKwnHXEOKDFblDMRklxluX7yVFdHvMS3dn7gDfORPSqWZ9HO9djlb0Pn9CICYSl9rTiXU8lAo0QPQQlJKNixFP5MRmZh2N4WDmqmJVS/islrR6cyfabpmOxMBd38aEC3uVRZmrel3EOohh/DgTqg4LHENFhjejBpo9l7jSnn1NVLvC4MQMraOWTXw9HJuKfDztfc+R/3k9udQSMxNYUhRzM37ZZsNXA0XpnLc5ix0NxwLLxLwPHTjbgEKxhoNAJozkt7V0/Xl0C5DtWyCFEY06p6gdo1NmImh4CwAPh5ubIMiMa30InxBgj+RI9ZI+yVED367RmSjb5Cvr6xb1aPxFsF2GVLs4BtAPCeuMwWvSCpzwFm6+uoDLrhmMHQDUs8T/Vckx1wUrpWFpZcy6lKp1wtXMnUXtmllhJmKGOdaRUzCUyPvRITPY/hdpQQqp1QPDJPavuwTr6DnIV1hwps726YFSfj9g5yMSP2XwvoHB5HYQC+trZFsjA6lSPLexuqS3kNEPJ78GmiEsnmkMAzbmGQfLaNjGyoT
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



