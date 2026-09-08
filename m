Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5CA3CC79FAB
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 06:34:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ACB2C6B00A1; Tue,  8 Sep 2026 02:33:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A7D576B00A2; Tue,  8 Sep 2026 02:33:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 945526B00A3; Tue,  8 Sep 2026 02:33:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6A4066B00A1
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 02:33:57 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D9694403E3
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 06:33:56 +0000 (UTC)
X-FDA: 85189629672.28.184B0C3
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf10.hostedemail.com (Postfix) with ESMTP id 08234C0004
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 06:33:54 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=da+locf+;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=rGIpB+VW;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf10.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788849235;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5rCxHOjDU+1K4duStPKjAXJyT/7CSkrSSpDiIH+J3gQ=;
	b=4lirPyZ+ZE/gGUTEixrPNXQbly2xDa35gG1bu800tW8yYyeMmbrAv8UBQhHcbrMq4Mec8G
	ZSa1GGECD/bdeh3Y+oqGq0vTP8uW/ghzPrW/HTCTLCl2PIqpMQIxvcySRYHwbufI04WRDT
	odM3D66cZz5ICKlH4jJldUoPrzvZTMs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788849235;
	b=YJ+REiA+KBAbVUN3izyKH/lrBLagphqhLvUf/zvNm6GTSLc/Vue5BtPIgU2xa/Xm/6+oyQ
	4w9Nt94pnBrojwkgqRuV09/a/Pgo4RYkyKaaJ/7c9hA+IotsQO8UBhdyad0teWgspubYwP
	B7OLa5xB25kDmLeHozNXDk22xRB2nik=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=da+locf+;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=rGIpB+VW;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf10.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1788849233;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5rCxHOjDU+1K4duStPKjAXJyT/7CSkrSSpDiIH+J3gQ=;
	b=da+locf+fYZS/T5UEThHqFcTDFXtvv69gxiMsF/ZubAOmr0jXYhOT3/KoH+tH/Op7c1vsy
	bpRepepo9H4IVaLokGW2IAwi1CWeXhd8o+dNwcx4sQhR3qvQh8ZBTI6S3Za8toe475YqL9
	m52Xec1PkVIHNnUIbn3no0eX4OaVjR4eFvZXam8e/0rp6XYFlSAcG0zrJO4CYAxWcD/7Bt
	tANKqUikMG/E33o4//5C703pUa8pqwDoJG3+m2PnIOpEmRRCwvUZcUhOxeAXqdjVJBbxMA
	fBIKwWukg4cdp/joxinRYCAl0XPGoVpBL/l3pBR9qkhcL0hyX26IC/ovUmuN9A==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1788849233;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5rCxHOjDU+1K4duStPKjAXJyT/7CSkrSSpDiIH+J3gQ=;
	b=rGIpB+VWmPNCZoxaugfvlZgtr9WAIBlKJMe9XrdCQurBFn8CcRHDbE0U1PBy6BjjzxN9GO
	PeQVrvH5QgAT1ZCg==
Date: Tue, 08 Sep 2026 08:33:44 +0200
Subject: [PATCH v5 10/24] sparc: elf: Move relocation constants to UAPI
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260908-vdso-absolute-reloc-v5-10-3a93791af1cf@linutronix.de>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788849226; l=5043;
 i=thomas.weissschuh@linutronix.de; s=20240209; h=from:subject:message-id;
 bh=b3nIkO5dCOkLCB+RhAZSMfv9iyr/5udIrKKC/R5UfGI=;
 b=FLRNHzsCqKdcJx3OOfwKa5Me9losfqQALszfZzWeIrGPgKpu5aG5hMJXNy/WjoqfB9MFnNHp1
 jIUinzpdhRoADtkUKsdgIyuWwsFe9f5ZRqdDteADesxBx76m5aXYrxr
X-Developer-Key: i=thomas.weissschuh@linutronix.de; a=ed25519;
 pk=pfvxvpFUDJV2h2nY0FidLUml22uGLSjByFbM6aqQQws=
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 08234C0004
X-Stat-Signature: bdkn8y5hhepdbjursjdssdqqpa78wrxh
X-Rspam-User: 
X-HE-Tag: 1788849234-991434
X-HE-Meta: U2FsdGVkX1+DpBpR+zY0hgbVBz0ITGfOSz+L7dbkZZTmzvMAQC2LpMhO+KuS8q0utBhvyB5Iaj2WU7MOdAqdLMaVJBKQBGwAl6VVmyn4Ye+t8AAswbuA6pOunoiDnwmCIbRL8azbPjtPCQhPhGPRPvCyQDMCzBjcc7LextZSWxhB6C3EzeUfy0atdLZZgHpl5JR9F1WuA3TN4PWuLQrT8f5slqOm8VVMICnlHw1tG6k1hB09ZE6WJ/BbeJRF7Lf9P19QrBoihVZfhn6wsiAQqm4p8UY0sl72zFAR0gMNTChgdbLwV2cSW2xc8YB5GHeotiPrYrWJ77Lg0toqY1yeoQf4/60wZW3UshmAsc0HfWpLVduCG8+tz+TYcZOAp1TcSVVDiW4ndChT6/+DDx4KUGPqWdwGQh3OOMF2tCoqv4TkEJQeB7PRO9K5rxWt9ixVO/plQcJ7+lpOSXIR6dnh8BjTlzn0nnxtBkDFIXXK5ZXi1tFjy6JjRNwFLdTEAA587xV/dkj7tL/CfesK1oNHBt5unZ++g7AQLO921S6PCEBqaSQcMEY8ou8hewHAvND/gCF+jkF7OzWRZfcZ8cRjzdVHO2b27YRI3REG8IRLPHo2gdRyKdkVAcY7HMM0RDjbk7hSPqXcc1qZaIEwXqnyuHuaXGBdbw1HFpddjjKxdDTEmrM4GX8YosI6g/cgAHakQAZi+Pp38edVKhBGTuurv7hjd79Hfu+IUXAURU/pMr1a4DFqnJc/dRywwDm6Cb7IgZ0tdIMXZ4nMyb27EPvCSOLaS2AVewMyH4Vuo9ZZ5Xi8D390kS+SvwMfV4WvawKNImnyqa18DJSLJpw3zbYfCL7EsB6ANwq1aslSJtVR72yBE8S39bwi9bXztlutLTnPQzc68aADZowI3AjZvxZax45e2ho73yABrop+xHxTFk/epyvRNYn/2j+Bbiiiak1mL4Y2YAg8E7N2yie+uma
 8zSo2FC0
 1RIbd9YHc6p4yqail+eh49BjsNUjpMRRs2Ta6VgP3fHHDM1QOb8V5c3fAG1M/ZsbIv6ocz2oDUwfVNJ8geabsIiWBuJXLUnfd0VRa1VXeBAmD8D3EvhamOdECr+c3UVuhodHBgibj5z53UYgiLLm9NII09h9atrgMiw7b2mnv09RI5TQ8pM437lv8ZEZVDWctGuv7iIf+us1m66Fm0ImAR7+emjJrc2nZ2SGuCHOwX25LMrklaoWaB+bWu1nsPTv4Ojpa25ivDvDFTDSWhT4/v1oyyn/cilpMrv2IJCrNUXm/z4Hp/Fes1QuJ6OfMNpode76Xg+Y6moZivFJLEczLpJCBkc4MQN0/ZKLKRZca1odJS2NNTYpM+Irdr1myBkoPykA3sp7aSXMF4E3eaapweAFsS4pQ+7bsY/iGNXhfVigKLtIsW7j3S559FwrG41QZV8R3LJ6IM2ysE7ohyu0L60yHuGgZ1E5uZNGjUT3e+RkHPif5irSlxOlHKj29lOjrU5a4TItwG7hPW6G/wzkvB2U/5xiiFX84vd57KDBwJ0xg6oc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

These constants are useful for cross-platform userspace, for example to
process ELF files during kernel cross-compilation.

Move them from the kernel-private architecture-specific header to the UAPI.

Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
---
 arch/sparc/include/asm/elf_32.h | 43 ----------------------------------------
 arch/sparc/include/asm/elf_64.h | 44 -----------------------------------------
 include/uapi/linux/elf-r.h      | 44 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 44 insertions(+), 87 deletions(-)

diff --git a/arch/sparc/include/asm/elf_32.h b/arch/sparc/include/asm/elf_32.h
index 37a6016c9ccd..02736284f7af 100644
--- a/arch/sparc/include/asm/elf_32.h
+++ b/arch/sparc/include/asm/elf_32.h
@@ -13,49 +13,6 @@
  */
 #define STT_REGISTER		13
 
-/*
- * Sparc ELF relocation types
- */
-#define	R_SPARC_NONE		0
-#define	R_SPARC_8		1
-#define	R_SPARC_16		2
-#define	R_SPARC_32		3
-#define	R_SPARC_DISP8		4
-#define	R_SPARC_DISP16		5
-#define	R_SPARC_DISP32		6
-#define	R_SPARC_WDISP30		7
-#define	R_SPARC_WDISP22		8
-#define	R_SPARC_HI22		9
-#define	R_SPARC_22		10
-#define	R_SPARC_13		11
-#define	R_SPARC_LO10		12
-#define	R_SPARC_GOT10		13
-#define	R_SPARC_GOT13		14
-#define	R_SPARC_GOT22		15
-#define	R_SPARC_PC10		16
-#define	R_SPARC_PC22		17
-#define	R_SPARC_WPLT30		18
-#define	R_SPARC_COPY		19
-#define	R_SPARC_GLOB_DAT	20
-#define	R_SPARC_JMP_SLOT	21
-#define	R_SPARC_RELATIVE	22
-#define	R_SPARC_UA32		23
-#define R_SPARC_PLT32		24
-#define R_SPARC_HIPLT22		25
-#define R_SPARC_LOPLT10		26
-#define R_SPARC_PCPLT32		27
-#define R_SPARC_PCPLT22		28
-#define R_SPARC_PCPLT10		29
-#define R_SPARC_10		30
-#define R_SPARC_11		31
-#define R_SPARC_64		32
-#define R_SPARC_OLO10		33
-#define R_SPARC_WDISP16		40
-#define R_SPARC_WDISP19		41
-#define R_SPARC_7		43
-#define R_SPARC_5		44
-#define R_SPARC_6		45
-
 /* Bits present in AT_HWCAP, primarily for Sparc32.  */
 
 #define HWCAP_SPARC_FLUSH       1    /* CPU supports flush instruction. */
diff --git a/arch/sparc/include/asm/elf_64.h b/arch/sparc/include/asm/elf_64.h
index 694ed081cf8d..3be9e2d3a94a 100644
--- a/arch/sparc/include/asm/elf_64.h
+++ b/arch/sparc/include/asm/elf_64.h
@@ -16,50 +16,6 @@
  */
 #define STT_REGISTER		13
 
-/*
- * Sparc ELF relocation types
- */
-#define	R_SPARC_NONE		0
-#define	R_SPARC_8		1
-#define	R_SPARC_16		2
-#define	R_SPARC_32		3
-#define	R_SPARC_DISP8		4
-#define	R_SPARC_DISP16		5
-#define	R_SPARC_DISP32		6
-#define	R_SPARC_WDISP30		7
-#define	R_SPARC_WDISP22		8
-#define	R_SPARC_HI22		9
-#define	R_SPARC_22		10
-#define	R_SPARC_13		11
-#define	R_SPARC_LO10		12
-#define	R_SPARC_GOT10		13
-#define	R_SPARC_GOT13		14
-#define	R_SPARC_GOT22		15
-#define	R_SPARC_PC10		16
-#define	R_SPARC_PC22		17
-#define	R_SPARC_WPLT30		18
-#define	R_SPARC_COPY		19
-#define	R_SPARC_GLOB_DAT	20
-#define	R_SPARC_JMP_SLOT	21
-#define	R_SPARC_RELATIVE	22
-#define	R_SPARC_UA32		23
-#define R_SPARC_PLT32		24
-#define R_SPARC_HIPLT22		25
-#define R_SPARC_LOPLT10		26
-#define R_SPARC_PCPLT32		27
-#define R_SPARC_PCPLT22		28
-#define R_SPARC_PCPLT10		29
-#define R_SPARC_10		30
-#define R_SPARC_11		31
-#define R_SPARC_64		32
-#define R_SPARC_OLO10		33
-#define R_SPARC_WDISP16		40
-#define R_SPARC_WDISP19		41
-#define R_SPARC_7		43
-#define R_SPARC_5		44
-#define R_SPARC_6		45
-#define R_SPARC_UA64		54
-
 /* Bits present in AT_HWCAP, primarily for Sparc32.  */
 #define HWCAP_SPARC_FLUSH       0x00000001
 #define HWCAP_SPARC_STBAR       0x00000002
diff --git a/include/uapi/linux/elf-r.h b/include/uapi/linux/elf-r.h
index 0c6a8698f300..72fc9045a5d4 100644
--- a/include/uapi/linux/elf-r.h
+++ b/include/uapi/linux/elf-r.h
@@ -649,4 +649,48 @@
 
 #define R_MIPS_PC32		248
 
+/*
+ * Sparc ELF relocation types
+ */
+#define	R_SPARC_NONE		0
+#define	R_SPARC_8		1
+#define	R_SPARC_16		2
+#define	R_SPARC_32		3
+#define	R_SPARC_DISP8		4
+#define	R_SPARC_DISP16		5
+#define	R_SPARC_DISP32		6
+#define	R_SPARC_WDISP30		7
+#define	R_SPARC_WDISP22		8
+#define	R_SPARC_HI22		9
+#define	R_SPARC_22		10
+#define	R_SPARC_13		11
+#define	R_SPARC_LO10		12
+#define	R_SPARC_GOT10		13
+#define	R_SPARC_GOT13		14
+#define	R_SPARC_GOT22		15
+#define	R_SPARC_PC10		16
+#define	R_SPARC_PC22		17
+#define	R_SPARC_WPLT30		18
+#define	R_SPARC_COPY		19
+#define	R_SPARC_GLOB_DAT	20
+#define	R_SPARC_JMP_SLOT	21
+#define	R_SPARC_RELATIVE	22
+#define	R_SPARC_UA32		23
+#define R_SPARC_PLT32		24
+#define R_SPARC_HIPLT22		25
+#define R_SPARC_LOPLT10		26
+#define R_SPARC_PCPLT32		27
+#define R_SPARC_PCPLT22		28
+#define R_SPARC_PCPLT10		29
+#define R_SPARC_10		30
+#define R_SPARC_11		31
+#define R_SPARC_64		32
+#define R_SPARC_OLO10		33
+#define R_SPARC_WDISP16		40
+#define R_SPARC_WDISP19		41
+#define R_SPARC_7		43
+#define R_SPARC_5		44
+#define R_SPARC_6		45
+#define R_SPARC_UA64		54
+
 #endif /* _UAPI_LINUX_ELF_R_H */

-- 
2.55.0


