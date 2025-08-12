Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45C94C87FCB
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 05:44:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B7B168E00C8; Tue, 12 Aug 2025 01:44:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ADDFF8E00BE; Tue, 12 Aug 2025 01:44:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 908F28E00C9; Tue, 12 Aug 2025 01:44:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 72F028E00BE
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 01:44:35 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C768E56A64
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 05:44:34 +0000 (UTC)
X-FDA: 83767015668.15.8B74476
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf12.hostedemail.com (Postfix) with ESMTP id DB10440005
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 05:44:32 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=wFb0RLzj;
	dkim=pass header.d=linutronix.de header.s=2020e header.b="qsESN/r8";
	spf=pass (imf12.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754977473;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1fbs+jreI++pzzR3zWEjWTxnX9u6RnqE0RQf6GOU1NY=;
	b=qEF4NGVVAH/j6xs7RAGrs5igpAwO8eMOH2v/9vkKeV/gWeOGtQQ+6GCRgBBoVtKTx31axF
	tX4X8k9qty9EM8u7YWHBV3H/0gYA71EsTRx96R4oBf7nY24repfNG1JepXreMHx0ijfmo+
	KjIC6DOZRPtEoE4/3cQVgfqAjIORJW0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754977473; a=rsa-sha256;
	cv=none;
	b=WFMgBWTnw4DdrHTMXyigyVQ7N12CGs3a00kcWzmR2WAcASynZ353pytl2KzooLlxqk0oEr
	f1HvBNfWTpgaWhRdGTLkxmMrfl+98xzStFwxPfpKeEW+TuiKPM36+3+nQECHMFQHnFi9Qa
	97wKqtWS95mSjzJcC+Szr5DZ3EJ2alM=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=wFb0RLzj;
	dkim=pass header.d=linutronix.de header.s=2020e header.b="qsESN/r8";
	spf=pass (imf12.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1754977471;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1fbs+jreI++pzzR3zWEjWTxnX9u6RnqE0RQf6GOU1NY=;
	b=wFb0RLzjRR+m6XuM7TOWlo2yvCJnPhA+25xIrhYVyQU7vW3qK3ogLB5/FoNBtbGXFhaQKY
	pr4aI4RliMtnnHAuihu1YwOpPa1YAFE6NNdNYTDGqtqXIgkvCGwOYClR54N7bodbqmR8ib
	3FR59W6tTyZySeu5nec68ShzfSWdVtepYdrHKuUMyY5PDvLGMSfolpeOUlC1s249oPH+6P
	/nNoPZTWkgEcLEgiFvoUsib1/knAtoR53VJtqoUm2UIq7TEvFyRcp1/WlztCfeuCCPyn1R
	c9ok2s6GcRDtHFeAJPnrNr3pTIJwl25pnQginm0asRgcm/Y3wFJdfZ+h1y1MIA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1754977471;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1fbs+jreI++pzzR3zWEjWTxnX9u6RnqE0RQf6GOU1NY=;
	b=qsESN/r84WX54Bw78PaDXL3DZH9tinqCzw/9z447eYrhrk5rauDW2NqzQLxz4cWxfapa1Y
	nlSHAbkBNOdd0fAw==
Date: Tue, 12 Aug 2025 07:44:15 +0200
Subject: [PATCH v4 02/24] x86/elf, um/x86/elf: Move relocation constants to
 UAPI
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20250812-vdso-absolute-reloc-v4-2-61a8b615e5ec@linutronix.de>
References: <20250812-vdso-absolute-reloc-v4-0-61a8b615e5ec@linutronix.de>
In-Reply-To: <20250812-vdso-absolute-reloc-v4-0-61a8b615e5ec@linutronix.de>
To: Paul Walmsley <paul.walmsley@sifive.com>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
 Alexandre Ghiti <alex@ghiti.fr>, Nathan Chancellor <nathan@kernel.org>, 
 Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, 
 Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>, 
 Andy Lutomirski <luto@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, 
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
 Christophe Leroy <christophe.leroy@csgroup.eu>, 
 Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>, 
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>, 
 Christian Borntraeger <borntraeger@linux.ibm.com>, 
 Sven Schnelle <svens@linux.ibm.com>, 
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>, 
 Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
 Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
 Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
 Danilo Krummrich <dakr@kernel.org>, 
 Nicolas Schier <nicolas.schier@linux.dev>
Cc: linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
 llvm@lists.linux.dev, linux-mm@kvack.org, linux-um@lists.infradead.org, 
 linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org, 
 loongarch@lists.linux.dev, linux-s390@vger.kernel.org, 
 linux-mips@vger.kernel.org, rust-for-linux@vger.kernel.org, 
 linux-kbuild@vger.kernel.org, Jan Stancek <jstancek@redhat.com>, 
 Arnaldo Carvalho de Melo <acme@redhat.com>, 
 Alexandre Ghiti <alexghiti@rivosinc.com>, 
 =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
X-Developer-Signature: v=1; a=ed25519-sha256; t=1754977469; l=6035;
 i=thomas.weissschuh@linutronix.de; s=20240209; h=from:subject:message-id;
 bh=1uMAsIGnLSAarJHPAhyn1ZCQ7+laGQoWKQA2Xxq0mGY=;
 b=LSso+CtnXCvSqq7w3arcGFjj/9JO1wvGscYCVoeDZOhj/IpFN3GTrmCLD7/dVw71XSDOqEtKb
 ryK7StfnfXPByrB7+MMfsCwMUX3kib3KkE19P5uuPZjIm2SN2cxtCaS
X-Developer-Key: i=thomas.weissschuh@linutronix.de; a=ed25519;
 pk=pfvxvpFUDJV2h2nY0FidLUml22uGLSjByFbM6aqQQws=
X-Rspamd-Queue-Id: DB10440005
X-Stat-Signature: mmdrre8ki3p76sepjn1i3px78b1n6q5u
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1754977472-293834
X-HE-Meta: U2FsdGVkX1/5tnmiXp/Pntu7q4nAAGkjLgUvqVFUHSAgeAH6C2QlAeM6Eiq03gZ7uM1vZgPwOyLMeTKfDZBMmByItdylCeAvoxCKAzY78VRwT9XVp90Ofj9BDHP7JPAmYXjxBVOE9AqaPl1F8QG1urXLFj5JgXJ6nmAvUfBMTpCT4aPO+620K0V2CW4SWlnM16mprSG+XE+2Agm9OZ3KHDGtTz21Xfug8bvFhSqJFfHND14Y/lqg03il/DHqQY4IgvwJlR1S8DnBD15ILGF6M6Fhs6/kL5fpUWGoXdo6IMTiF+XnTObVnfsv6yUHxEIpH5OtPivVhtqq+5M5QEG7/bRXFZROHOVSywtU3UrTXQchOBuubVFdn1kKREsmPKMfT4afIOho2aws8jRhPprkdJsoB/l26l1b6CUNC926ySUchmBEqW13y+zhr6p2J9PN/2ck1Uc2cnOiamHOb6kIUboUc41GWYtopkT0uPAoGdmJqKW0ejVAZTbcz6NssxkdCQOlS9LxSQeLHWiAMTdEIOffF6MVXNd+desNFjZcJduUTrQzC/eZaOecP7hwLEzz6sn63Mxo4VhUid2wu173iSmh7IXsddsIoYIoa6SKiYjgeJO7fiAGy5bRc6CjgTT7iSdjvMxWWk52+iUK9NaZ3lvfiI+3OeDcBTvqLNcaDft+zwm1Pg6O55gUXvsD9RuQoAcmNGWAwkAFNrADEiWEfH1AQEm+f8pqc3NwvJJsUWXa9AcjQAI3nZNo/1TgwlMS7zFm5ANQQN7FdGWZyqNIc1SU/ZyWErMZLJviyFjHrzvsW5tglKdTaG7u1aZ10sfk+tF+37gqePStzrCWzaG1SnH9xnRrRVD6lIYwdBu/jTKfHawDuzpKBPwbTftY4xRd9HuT0xdGbxaYruNB/kyrb1al8A50y6aLoJrWEp9og+OdG1B3ks1kKSPUfz5r7+B23NymvXGRpWQXZZQ2T6Z
 tgZSdd6A
 9+dstAzHvi8CT2lRIXr6PiwSXvxB8MU/jDrfwWL5OHe+BzUVeXbjkP4Bu2fcOBb9jKdMP2j52smGZxXbs+KtKBUTc5gKL69y2e+WbRkZbNC04EkgfOIH/v1cTRsvhnAj9X30oS5htGuiDYbNIfPL/Q3bvtz4jGpAIBSxxwAvFHHGMgMeIIwHcmxwODXedX/v3cK+/aWEkcPDxGxBjD2RCHmbtrbqDZ9CJLK6Mjh5Wv75RiRZYvYyNzqLpQB0+uRPXhfj/61FYwb+JwEiOo1KVQBMOSs4OoDJqSgmutusefmqFHGpApsS5GSU7r5YEc2yTMUVfBASClyr7zU8k1BJSf8seYLeAScXP76DKK0Rwb2OyNot3jTgO/nIO/qY6vI8qrzG0KtFtjGFBrbFOKB5+JVvgP0JKk3cIL+vmuuUTvsbZ4Qr/TOCrzspKDYhDJ9p8L3VOJCUn25G8kSP3ofjPqarExiQjoFUH7rp/guBhQyp2LO6oOtKGJjIPci180JotuHG7
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
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
 arch/x86/include/asm/elf.h | 34 ----------------------------------
 arch/x86/um/asm/elf.h      | 33 ---------------------------------
 include/uapi/linux/elf-r.h | 34 ++++++++++++++++++++++++++++++++++
 3 files changed, 34 insertions(+), 67 deletions(-)

diff --git a/arch/x86/include/asm/elf.h b/arch/x86/include/asm/elf.h
index 6c8fdc96be7e8bd33919d9b56ae8a8a68f4b0c3f..a2538561a84b8dae0479c43238f6f297fe88924b 100644
--- a/arch/x86/include/asm/elf.h
+++ b/arch/x86/include/asm/elf.h
@@ -22,19 +22,6 @@ typedef struct user_i387_struct elf_fpregset_t;
 
 #ifdef __i386__
 
-#define R_386_NONE	0
-#define R_386_32	1
-#define R_386_PC32	2
-#define R_386_GOT32	3
-#define R_386_PLT32	4
-#define R_386_COPY	5
-#define R_386_GLOB_DAT	6
-#define R_386_JMP_SLOT	7
-#define R_386_RELATIVE	8
-#define R_386_GOTOFF	9
-#define R_386_GOTPC	10
-#define R_386_NUM	11
-
 /*
  * These are used to set parameters in the core dumps.
  */
@@ -44,27 +31,6 @@ typedef struct user_i387_struct elf_fpregset_t;
 
 #else
 
-/* x86-64 relocation types */
-#define R_X86_64_NONE		0	/* No reloc */
-#define R_X86_64_64		1	/* Direct 64 bit  */
-#define R_X86_64_PC32		2	/* PC relative 32 bit signed */
-#define R_X86_64_GOT32		3	/* 32 bit GOT entry */
-#define R_X86_64_PLT32		4	/* 32 bit PLT address */
-#define R_X86_64_COPY		5	/* Copy symbol at runtime */
-#define R_X86_64_GLOB_DAT	6	/* Create GOT entry */
-#define R_X86_64_JUMP_SLOT	7	/* Create PLT entry */
-#define R_X86_64_RELATIVE	8	/* Adjust by program base */
-#define R_X86_64_GOTPCREL	9	/* 32 bit signed pc relative offset to GOT */
-#define R_X86_64_GOTPCRELX	41
-#define R_X86_64_REX_GOTPCRELX	42
-#define R_X86_64_32		10	/* Direct 32 bit zero extended */
-#define R_X86_64_32S		11	/* Direct 32 bit sign extended */
-#define R_X86_64_16		12	/* Direct 16 bit zero extended */
-#define R_X86_64_PC16		13	/* 16 bit sign extended pc relative */
-#define R_X86_64_8		14	/* Direct 8 bit sign extended  */
-#define R_X86_64_PC8		15	/* 8 bit sign extended pc relative */
-#define R_X86_64_PC64		24	/* Place relative 64-bit signed */
-
 /*
  * These are used to set parameters in the core dumps.
  */
diff --git a/arch/x86/um/asm/elf.h b/arch/x86/um/asm/elf.h
index 62ed5d68a9788ffbf9dd0b4ebbe2caad4ac7a7c6..2e79193f396cda854ab4f17af2cd5b15c1e078cd 100644
--- a/arch/x86/um/asm/elf.h
+++ b/arch/x86/um/asm/elf.h
@@ -12,19 +12,6 @@
 
 #ifdef CONFIG_X86_32
 
-#define R_386_NONE	0
-#define R_386_32	1
-#define R_386_PC32	2
-#define R_386_GOT32	3
-#define R_386_PLT32	4
-#define R_386_COPY	5
-#define R_386_GLOB_DAT	6
-#define R_386_JMP_SLOT	7
-#define R_386_RELATIVE	8
-#define R_386_GOTOFF	9
-#define R_386_GOTPC	10
-#define R_386_NUM	11
-
 /*
  * This is used to ensure we don't load something for the wrong architecture.
  */
@@ -100,26 +87,6 @@ do {								\
 
 #else
 
-/* x86-64 relocation types, taken from asm-x86_64/elf.h */
-#define R_X86_64_NONE		0	/* No reloc */
-#define R_X86_64_64		1	/* Direct 64 bit  */
-#define R_X86_64_PC32		2	/* PC relative 32 bit signed */
-#define R_X86_64_GOT32		3	/* 32 bit GOT entry */
-#define R_X86_64_PLT32		4	/* 32 bit PLT address */
-#define R_X86_64_COPY		5	/* Copy symbol at runtime */
-#define R_X86_64_GLOB_DAT	6	/* Create GOT entry */
-#define R_X86_64_JUMP_SLOT	7	/* Create PLT entry */
-#define R_X86_64_RELATIVE	8	/* Adjust by program base */
-#define R_X86_64_GOTPCREL	9	/* 32 bit signed pc relative
-					   offset to GOT */
-#define R_X86_64_32		10	/* Direct 32 bit zero extended */
-#define R_X86_64_32S		11	/* Direct 32 bit sign extended */
-#define R_X86_64_16		12	/* Direct 16 bit zero extended */
-#define R_X86_64_PC16		13	/* 16 bit sign extended pc relative */
-#define R_X86_64_8		14	/* Direct 8 bit sign extended  */
-#define R_X86_64_PC8		15	/* 8 bit sign extended pc relative */
-#define R_X86_64_PC64		24	/* Place relative 64-bit signed */
-
 /*
  * This is used to ensure we don't load something for the wrong architecture.
  */
diff --git a/include/uapi/linux/elf-r.h b/include/uapi/linux/elf-r.h
index 2c382c8a4807f394a3ccabf39a81e9e9b6f7ea45..45a160ecf40570f3ac916344be363d7e74908ea6 100644
--- a/include/uapi/linux/elf-r.h
+++ b/include/uapi/linux/elf-r.h
@@ -2,4 +2,38 @@
 #ifndef _UAPI_LINUX_ELF_R_H
 #define _UAPI_LINUX_ELF_R_H
 
+/* i386 relocation types */
+#define R_386_NONE	0
+#define R_386_32	1
+#define R_386_PC32	2
+#define R_386_GOT32	3
+#define R_386_PLT32	4
+#define R_386_COPY	5
+#define R_386_GLOB_DAT	6
+#define R_386_JMP_SLOT	7
+#define R_386_RELATIVE	8
+#define R_386_GOTOFF	9
+#define R_386_GOTPC	10
+#define R_386_NUM	11
+
+/* x86-64 relocation types */
+#define R_X86_64_NONE		0	/* No reloc */
+#define R_X86_64_64		1	/* Direct 64 bit  */
+#define R_X86_64_PC32		2	/* PC relative 32 bit signed */
+#define R_X86_64_GOT32		3	/* 32 bit GOT entry */
+#define R_X86_64_PLT32		4	/* 32 bit PLT address */
+#define R_X86_64_COPY		5	/* Copy symbol at runtime */
+#define R_X86_64_GLOB_DAT	6	/* Create GOT entry */
+#define R_X86_64_JUMP_SLOT	7	/* Create PLT entry */
+#define R_X86_64_RELATIVE	8	/* Adjust by program base */
+#define R_X86_64_GOTPCREL	9	/* 32 bit signed pc relative
+					   offset to GOT */
+#define R_X86_64_32		10	/* Direct 32 bit zero extended */
+#define R_X86_64_32S		11	/* Direct 32 bit sign extended */
+#define R_X86_64_16		12	/* Direct 16 bit zero extended */
+#define R_X86_64_PC16		13	/* 16 bit sign extended pc relative */
+#define R_X86_64_8		14	/* Direct 8 bit sign extended  */
+#define R_X86_64_PC8		15	/* 8 bit sign extended pc relative */
+#define R_X86_64_PC64		24	/* Place relative 64-bit signed */
+
 #endif /* _UAPI_LINUX_ELF_R_H */

-- 
2.50.1


