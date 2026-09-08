Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 280A3C79FA0
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 06:33:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DBD2F6B0098; Tue,  8 Sep 2026 02:33:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D8A1F6B009B; Tue,  8 Sep 2026 02:33:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C798B6B0099; Tue,  8 Sep 2026 02:33:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9BAF06B008C
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 02:33:52 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2991680385
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 06:33:52 +0000 (UTC)
X-FDA: 85189629504.04.A4790D0
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf12.hostedemail.com (Postfix) with ESMTP id 6B00340008
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 06:33:50 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=XLygM0BD;
	dkim=pass header.d=linutronix.de header.s=2020e header.b="tE8ZkJO/";
	spf=pass (imf12.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788849230;
	b=3GHuAIlxKak6SfOeIyKSGoIOc3xR6Op9EeM0m4haFwdz07sds4FB3VpKe3fLuDv5BW/du4
	c7RYj1Fsl31K+vHv98YM02OUIkfGevq/XSLE0yUlF7oPNUvMGSdG0SM24MFUhGm7fFYXq0
	bGn/rg2xctNc1/mN9VEl45xxk0tI8HE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788849230;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gSPxSNVdJ9KATz6nm8e6AFtICD0FAYsIE0eIna7Agxk=;
	b=t/T3BXx2YMFZKHbLqft2Lkj+DBDny7j0w6sBfFc1BuqbVuurZSdAbI1ncWR6c47xIIANTG
	rd2upF0ojDsUx9aLBaQou2Jaqh35qaA+VN0ntuyh9Trp0UZIaL0u3jvY1EQ5nEBrUZK7yh
	cBPDjS22RvvIGZnh7Nl3nhitU5crZHQ=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=XLygM0BD;
	dkim=pass header.d=linutronix.de header.s=2020e header.b="tE8ZkJO/";
	spf=pass (imf12.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1788849229;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gSPxSNVdJ9KATz6nm8e6AFtICD0FAYsIE0eIna7Agxk=;
	b=XLygM0BDhDyMcEc7+LvxjROHXez8wUnOKjCkYoGOkZ71vrK2CvV3g7A6PnFMd/7RPpu2X+
	pNDzMz+ljiv746G59hnUDGb4KbkCEYM77DK5DR+HUpjivjR0GPAsrblt/1wggCSHMIjQB3
	Je/I0Xr4Sz2mh/eKJHhbsXHXJIxMnR7MOahsvncLHYmqt4W8/PJHO5gm2oR0E2MsaRqRjZ
	HahnzTplivB++1tzgnmMptXhzYC6Tz2TGAvTo3iztkbp46kPWLkgBMUvE4YFQqXKwezoDG
	114klfBAJgZokiASj7vErQNQ/939SoNDdWvLlRASuP6OpCdcI9TCVmIarn15AQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1788849229;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gSPxSNVdJ9KATz6nm8e6AFtICD0FAYsIE0eIna7Agxk=;
	b=tE8ZkJO/4GB5Zgn4Tw4miHDMKei5Wp3KHv2lcXSfX6CnJgXa1zTm4SuH76YUsIIXDDZoT6
	Yx+G/OLJMVOe48Bw==
Date: Tue, 08 Sep 2026 08:33:37 +0200
Subject: [PATCH v5 03/24] ARM: elf: Move relocation constants to UAPI
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260908-vdso-absolute-reloc-v5-3-3a93791af1cf@linutronix.de>
References: <20260908-vdso-absolute-reloc-v5-0-3a93791af1cf@linutronix.de>
In-Reply-To: <20260908-vdso-absolute-reloc-v5-0-3a93791af1cf@linutronix.de>
To: Paul Walmsley <paul.walmsley@sifive.com>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
 Alexandre Ghiti <alex@ghiti.fr>, Nathan Chancellor <nathan@kernel.org>, 
 Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, 
 Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>, 
 Andy Lutomirski <luto@kernel.org>, 
 Vincenzo Frascino <vincenzo.frascino@arm.com>, Kees Cook <kees@kernel.org>, 
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
 "H. Peter Anvin" <hpa@zytor.com>, Richard Weinberger <richard@nod.at>, 
 Anton Ivanov <anton.ivanov@cambridgegreys.com>, 
 Johannes Berg <johannes@sipsolutions.net>, 
 Russell King <linux@armlinux.org.uk>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Madhavan Srinivasan <maddy@linux.ibm.com>, 
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
 Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>, 
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>, 
 Christian Borntraeger <borntraeger@linux.ibm.com>, 
 Sven Schnelle <svens@linux.ibm.com>, 
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>, 
 Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
 Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
 Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
 Danilo Krummrich <dakr@kernel.org>, Thomas Gleixner <tglx@kernel.org>, 
 Christophe Leroy <chleroy@kernel.org>, Boqun Feng <boqun@kernel.org>, 
 Nicolas Schier <nsc@kernel.org>
Cc: linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
 llvm@lists.linux.dev, linux-mm@kvack.org, linux-um@lists.infradead.org, 
 linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org, 
 loongarch@lists.linux.dev, linux-s390@vger.kernel.org, 
 linux-mips@vger.kernel.org, rust-for-linux@vger.kernel.org, 
 linux-kbuild@vger.kernel.org, Jan Stancek <jstancek@redhat.com>, 
 Arnaldo Carvalho de Melo <acme@redhat.com>, 
 Alexandre Ghiti <alexghiti@rivosinc.com>, 
 =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788849226; l=2985;
 i=thomas.weissschuh@linutronix.de; s=20240209; h=from:subject:message-id;
 bh=HxdX8M08dw8dxZbEyC58Tr3vPz+rTbatZUZFgGPo5N4=;
 b=0VdXYSl3gC5PkjWgIegQbm9VVbaiF2T/bXo5db/PU6uM9xe8FhYNs6VkO+iEYNb87F/N6QwN9
 +tR4YHOI9+EAQ/8aaaF3l3022LJ8aC3ngY4qAkmLfpFJ6Ei8JBHO0IO
X-Developer-Key: i=thomas.weissschuh@linutronix.de; a=ed25519;
 pk=pfvxvpFUDJV2h2nY0FidLUml22uGLSjByFbM6aqQQws=
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 6B00340008
X-Stat-Signature: 3j5bu7ey1kdrhh5q8gnmm1pothu369gx
X-HE-Tag: 1788849230-8089
X-HE-Meta: U2FsdGVkX1897G3HrDNq2USzOSBJNzaVYm/04kmzg9zY8KBTjPfsdu0winzhruDSNhXIlfj/zB/7RuXlGt73h2WZGiRAvsrPQj2opvh7ZWw5/nAZ8R4NPKxDfZ9102AmKWP8JHGPzzy+kaHWUa+kvXx2infxORe/3dB7EcfqM3aWB82KI593/MFau7GjIlWY/9VNpvlVRH8F2b0wt7RllG3BnspZy6LDQiSkhRllyJYTZrSGCbncbgdBH6eBRjCh/Kt8rt7M2xDD9aNSVzC1TKR9hVCqbilkW2xRFhh/BtavuBMJI3T5ddFPt5aX5pmUuydRjtnSKmnjCg2j2TAheci5vugHf+hiudluBVjVrFaVCHR31TWKSbJcC/Z0v0yRkYTz3Q3z8OjbHuTdWMHulmBN08+LaZ7+iF8V0YKXdrJLrhX25exUMqhe/9AzRHo+E/RRtQ+hL63og+eyTu4OuIqE35+yRIRcOvR3Nx6gBcplmduvmpD6guNIOGvDp8uQiIKhhyHZiQZq5Nrl8Kz8VA0begxpBGvKOsxGaPgkwMmRKInA/Pw2WluxIBsSSu2c9378RRLfjxFSy90SS17q//TqWyAJLXDTmzjszlTbeDaKxZDNZxJdpOKrdbCbjGEzop9ijXulVxDzLc7MpaFzSTVwWaDj3s6EbZKqTc2QDYXeGIHNiFWE9bICFcHi2bLDePkBW4rVAtJ6bmhrFVI5HzQe89WJFnYImgnMkdF7igsSRHDR/O02wkV5+EQiP/4mB+tO0fbMQbcyEYMyu7AIPUEhSfmVjBzLEmNRAaC4c2k8s15Lh5MakfbyFycWIAlIUGYtHEka1zLGOUE90+cLuFUNtoqwNzjxxkbi3lZnIqi/ZOa7UEZ2S/im7yGQlbkpODZysiNaozry0Nf/k+nNjNFvXqGg80ShT8ImJn47t7lM4l2AlzEtI+3Y8E4ZPnd7vS4cUQu/Z17FR8A4vA4
 Cpb91Udp
 2l88gV0zPZzMveN90PGqFRHoeqFjzRIOYYkuSxxbESXJUQEhXj9L5bYRFlhqExts2XcLG4BaYG41jg7dgoVQ0jgwctfdQneFlmZvbYE1YJHuRde+32lSTRNtio5K0VGCJmOgvAYed5mUbeSIawVa00djJerr8XcKARrhmqMx1poJJ3j5rw4vwqqMY8OZcCHtKZrtk5XJPG6nuDQdHD3AJm/C9qnzsQFhTpkNpVzSv3xR14PnoCPbRqBAS27wN+E3BvAyNlgQBtBLXA8dXbCStZp0J3KSxaidMg8lBPFfj9yqGmuIutVffKdEKzyMSd46lv7PYhKSD5Wt6cky5iGIx9wqJL9ncMkaFaN/HQW3bOMjxfjki0OHnuoVx0zb3v5D7kdkOAp5K2KNHJDKpG/LhSm961zBDnfJcxHnDLwrji3Xy7HJ8NwYenX6KN3VRZFq1PEOvqWuWcCfPvHB8bcClnhrz5Nbmoee0it6wmIOyypxDtQ4Ak5mHudPdtm6+S2dNLfLQhUv/yZsrQBsB7r9/UhK9qHXq5gDh0WKjLj5KPH1AAuU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

These constants are useful for cross-platform userspace, for example to
process ELF files during kernel cross-compilation.

Move them from the kernel-private architecture-specific header to the UAPI.

One arm64 header is also changed as it duplicates an arm definition.

Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
---
 arch/arm/include/asm/elf.h   | 24 ------------------------
 arch/arm64/include/asm/elf.h |  1 -
 include/uapi/linux/elf-r.h   | 25 +++++++++++++++++++++++++
 3 files changed, 25 insertions(+), 25 deletions(-)

diff --git a/arch/arm/include/asm/elf.h b/arch/arm/include/asm/elf.h
index 9f21e170320f..ec2d416baa9f 100644
--- a/arch/arm/include/asm/elf.h
+++ b/arch/arm/include/asm/elf.h
@@ -47,30 +47,6 @@ typedef struct user_fp elf_fpregset_t;
 #define EF_ARM_HASENTRY		0x00000002	/* All */
 #define EF_ARM_RELEXEC		0x00000001	/* All */
 
-#define R_ARM_NONE		0
-#define R_ARM_PC24		1
-#define R_ARM_ABS32		2
-#define R_ARM_REL32		3
-#define R_ARM_CALL		28
-#define R_ARM_JUMP24		29
-#define R_ARM_TARGET1		38
-#define R_ARM_V4BX		40
-#define R_ARM_PREL31		42
-#define R_ARM_MOVW_ABS_NC	43
-#define R_ARM_MOVT_ABS		44
-#define R_ARM_MOVW_PREL_NC	45
-#define R_ARM_MOVT_PREL		46
-#define R_ARM_ALU_PC_G0_NC	57
-#define R_ARM_ALU_PC_G1_NC	59
-#define R_ARM_LDR_PC_G2		63
-
-#define R_ARM_THM_CALL		10
-#define R_ARM_THM_JUMP24	30
-#define R_ARM_THM_MOVW_ABS_NC	47
-#define R_ARM_THM_MOVT_ABS	48
-#define R_ARM_THM_MOVW_PREL_NC	49
-#define R_ARM_THM_MOVT_PREL	50
-
 /*
  * These are used to set parameters in the core dumps.
  */
diff --git a/arch/arm64/include/asm/elf.h b/arch/arm64/include/asm/elf.h
index d2779d604c7b..cfdf4c5ac08b 100644
--- a/arch/arm64/include/asm/elf.h
+++ b/arch/arm64/include/asm/elf.h
@@ -18,7 +18,6 @@
  */
 
 /* Miscellaneous. */
-#define R_ARM_NONE			0
 #define R_AARCH64_NONE			256
 
 /* Data. */
diff --git a/include/uapi/linux/elf-r.h b/include/uapi/linux/elf-r.h
index 45a160ecf405..001884641e77 100644
--- a/include/uapi/linux/elf-r.h
+++ b/include/uapi/linux/elf-r.h
@@ -36,4 +36,29 @@
 #define R_X86_64_PC8		15	/* 8 bit sign extended pc relative */
 #define R_X86_64_PC64		24	/* Place relative 64-bit signed */
 
+/* arm relocation types */
+#define R_ARM_NONE		0
+#define R_ARM_PC24		1
+#define R_ARM_ABS32		2
+#define R_ARM_REL32		3
+#define R_ARM_CALL		28
+#define R_ARM_JUMP24		29
+#define R_ARM_TARGET1		38
+#define R_ARM_V4BX		40
+#define R_ARM_PREL31		42
+#define R_ARM_MOVW_ABS_NC	43
+#define R_ARM_MOVT_ABS		44
+#define R_ARM_MOVW_PREL_NC	45
+#define R_ARM_MOVT_PREL		46
+#define R_ARM_ALU_PC_G0_NC	57
+#define R_ARM_ALU_PC_G1_NC	59
+#define R_ARM_LDR_PC_G2		63
+
+#define R_ARM_THM_CALL		10
+#define R_ARM_THM_JUMP24	30
+#define R_ARM_THM_MOVW_ABS_NC	47
+#define R_ARM_THM_MOVT_ABS	48
+#define R_ARM_THM_MOVW_PREL_NC	49
+#define R_ARM_THM_MOVT_PREL	50
+
 #endif /* _UAPI_LINUX_ELF_R_H */

-- 
2.55.0


