Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDAE5CA0EC4
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 05:45:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 699E08E00CF; Tue, 12 Aug 2025 01:44:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6512F8E00BE; Tue, 12 Aug 2025 01:44:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4ECB48E00CF; Tue, 12 Aug 2025 01:44:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 38B3F8E00BE
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 01:44:41 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id F1BD311558B
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 05:44:40 +0000 (UTC)
X-FDA: 83767015920.20.F4B83F3
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf07.hostedemail.com (Postfix) with ESMTP id 2B4464000A
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 05:44:38 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=B1kpGRDy;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=XsxRG5no;
	spf=pass (imf07.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754977479;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bfNfmAZ2eWXIcM3gW1RToAS2jXuE+ttAWjtBaA8JivY=;
	b=OiUNkK2CuMpC40b6kH9cKDHBg2rGx4xeWZ5t+tQBDj78jm2SreQEyQpEyc/uAgt7Os70yp
	aU5Jnr+vCB6Bwn8G7HtrAf4x6zpiatHAmpdM+yE+Cphr3z63ZpxVI3/jPv8YHY3QkzpqAb
	8VallbU+dVTH+oIFfbqTVffo7qzihI8=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=B1kpGRDy;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=XsxRG5no;
	spf=pass (imf07.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754977479; a=rsa-sha256;
	cv=none;
	b=VAZGQOKTuuIQIxrXxsOQlCGRsF3heg9mXRV7T+lPApCbUlT5xKibvLiHqsfTyE9CGKJp0Y
	BPwjdQOnyZsWeWiXnzgBDGVMVJuwZkO257GHWup9cZ72uVguBDhz/d6QROJlO2aFxf/WBt
	YIrL8reBA3WaK5C4YYC/a5Ve2OeD+/o=
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1754977475;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bfNfmAZ2eWXIcM3gW1RToAS2jXuE+ttAWjtBaA8JivY=;
	b=B1kpGRDy3pua7bopWb/954oKgIRuc3FpjRcj8N8/0woGocR6MrlC63NTftBUFibKS/AICQ
	0l4yLvJDAUL9O9Iv8brOnKZbuEK46aY74M50FME3ez3Pqc0JNVP0cah4ZO+nwmJK1ZETG+
	ahGQ2eL4oYMmBUubBb7TW5qooKJgC0dBGwDMZsgzk0S+hvVfKZybnmYIkMpJmtsWOmDXE/
	7A3+CPHb6uwJ43WFXviOiwG4lW30wI8rFjFt/MBD45XXy8SmYdbOVBvgbqsdc9GpTPAv4z
	YPBooaL0o00WA384eonGN+yemrymWJ8qP4EH0Mydpotgh3etmFhObcSWEnpSWw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1754977475;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bfNfmAZ2eWXIcM3gW1RToAS2jXuE+ttAWjtBaA8JivY=;
	b=XsxRG5noqNi3QHUb3PsJMNnR3h1efFABfuNPsU4Tp4BzgulPHL9P4+dkMiySHq2nPf5wzI
	aGxuMRcC3js1Y5AQ==
Date: Tue, 12 Aug 2025 07:44:22 +0200
Subject: [PATCH v4 09/24] MIPS: ELF: Move relocation constants to UAPI
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20250812-vdso-absolute-reloc-v4-9-61a8b615e5ec@linutronix.de>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1754977469; l=4434;
 i=thomas.weissschuh@linutronix.de; s=20240209; h=from:subject:message-id;
 bh=URWumLq5cEfF9wP67bk+ZcYfaIdTPXBTgCA3fiF+CgA=;
 b=L2h7+F73PT6iolsNxcu6S1mxeLogHfAutUNfzT1g4xN2qS8cRMLW7GI8H7DLrsC8VYfYYOVEW
 2yK3W8sGTl1CqHowhCCS2gkuE5kLBohKQe3c+i9dq+/6IUgTR2HRtCc
X-Developer-Key: i=thomas.weissschuh@linutronix.de; a=ed25519;
 pk=pfvxvpFUDJV2h2nY0FidLUml22uGLSjByFbM6aqQQws=
X-Stat-Signature: za6tyn8bx5o5zqmeyyg3yqrrg6uhunyt
X-Rspam-User: 
X-Rspamd-Queue-Id: 2B4464000A
X-Rspamd-Server: rspam01
X-HE-Tag: 1754977478-936080
X-HE-Meta: U2FsdGVkX1/0et5yzqny2sm6QToEioCW8b60IIBQWV84IBW6BRAIA8TSHv2mznfIWYCbumKHOr91GqQOEGJrxHJGNKakIhkVfsMSFu6OFbbvNqxIIoFvZFg/M2TS3TjuMdyMDTGrjH8N6OLPviqpagcCf+rYVDot75Sx/YRpx4g7QDYTlCjInHyR+kMAXBEoaJYvak9oGpYU3KfSMnUKrmeStpFvP5OlHsNmhxgkJgQ471Hpa4FdJQnI9y5VVr30vUZqPZyXYXDOMrRurIIOAAkPM3VryJAX/9ECll5Ut+xpYtecGgWozLybXYq8/+g3Qjb5WF6sxEZO/5xXcZitZoaZ3Vaw/pnROywr1un4z5DDs5sRPhqclAcD2w9YgjkNfOd3Pew6nqSCkfBrhICdG7RzUlnV48ZYAdkmAgaT88x4sHrz8mlyPNXHGJVp/UxBMUMhspt3pjEVBOI/P9EimjPI5dL5BzbtfU+7/0DX2bj3pk3gvyZxzxoSukSS2031tov5L24kxYc9tVwcumvJxpTV1Tw4ypkQJagwIawE+udDesy3cUs06OdrCgieNYMYp4r8ZmHvQ08jXwnImIy/2sSegERy/LFvX96Ohr5vx1BVepJcdLFPMERsMH2VqIiFwgfG9Qfe14c7RSgNENZ+YiLX3k0zlDSud7jmpJs+x++IBsD3Z0pG2FISBh3XgVk5dG4/URhqru59NhmALbTlBnza428/lcg1pqcyvpcQATb+iquiQY5okhZUJ5RBN1z3x4DfnWKWQpjfEGC79tMz2UsRXos3jOEC3JFrk2QuP3TpzwO5T3pLlx6cTey4bm8J1OiTvXglPK6IISk+IOIJsXd0wF/6QHMy6aOEp5CIfIO4qIHrxOJerugdiUGUh7ZSd2g4TjPPArsAFbWK9uwSkjpVIJzN4VpD+81Ri3bMHT4OnH5FOLd/UQDlRrntCpCc+yiynokq1ZMBRAWksap
 wDFRUcHr
 KI8Wxnp2UHbHGuFqiGvubCxG2ukXVh7ud0MWw+iHkZ+Sc8Fv3R4Z2RD1MY2mRAkNe+QL06D1DqdM+hvtdij0MRd3Q68EY6bUY6o+cc4oKLLt0VlAGvTUREAhI3BjkfazgfAxz+WmGPT+fFqRKbMeJq/Kuo+rRYudMX8upbkLtAZIwQMmOtPr5fg6BdAF9Xz2kuuzLkNLfg7hdV8lowl/PXwR2T4AH0s+EgkTzZdetVEPx6H+K2/np6IIJtvJJJIzAXQd0Zmze8wANGK9xmV9HAlcuP1++9rbHHks7ywqlCt1uNS3gCetY1j30JmpBx9Poc+ab69Hna4PXSdYLEPqXWLqNAuhY3P3zP2ifJoaVTaCbgNxpApoEDQtNTYmU7j6N57/zQE7sIK5+AMjQMg4D0r84oJ7pTI7QAdrfyntDKAW+3ysWSoGcfFNYAIjfq4h6g3a6SJ0l/kfZMgyPhl+HOVTAHEyg2jlrUgviA8jP7R6zP+IA/gqEglekAY18Wta5p6/3
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
 arch/mips/include/asm/elf.h | 53 --------------------------------------------
 include/uapi/linux/elf-r.h  | 54 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 54 insertions(+), 53 deletions(-)

diff --git a/arch/mips/include/asm/elf.h b/arch/mips/include/asm/elf.h
index dc8d2863752cfd5e8e2cbd750276f9463e0c32b8..347e12584beebbb5a7290efae3310b01220bbe0a 100644
--- a/arch/mips/include/asm/elf.h
+++ b/arch/mips/include/asm/elf.h
@@ -70,59 +70,6 @@
 #define DT_MIPS_HIPAGENO	0x70000014
 #define DT_MIPS_RLD_MAP		0x70000016
 
-#define R_MIPS_NONE		0
-#define R_MIPS_16		1
-#define R_MIPS_32		2
-#define R_MIPS_REL32		3
-#define R_MIPS_26		4
-#define R_MIPS_HI16		5
-#define R_MIPS_LO16		6
-#define R_MIPS_GPREL16		7
-#define R_MIPS_LITERAL		8
-#define R_MIPS_GOT16		9
-#define R_MIPS_PC16		10
-#define R_MIPS_CALL16		11
-#define R_MIPS_GPREL32		12
-/* The remaining relocs are defined on Irix, although they are not
-   in the MIPS ELF ABI.	 */
-#define R_MIPS_UNUSED1		13
-#define R_MIPS_UNUSED2		14
-#define R_MIPS_UNUSED3		15
-#define R_MIPS_SHIFT5		16
-#define R_MIPS_SHIFT6		17
-#define R_MIPS_64		18
-#define R_MIPS_GOT_DISP		19
-#define R_MIPS_GOT_PAGE		20
-#define R_MIPS_GOT_OFST		21
-/*
- * The following two relocation types are specified in the MIPS ABI
- * conformance guide version 1.2 but not yet in the psABI.
- */
-#define R_MIPS_GOTHI16		22
-#define R_MIPS_GOTLO16		23
-#define R_MIPS_SUB		24
-#define R_MIPS_INSERT_A		25
-#define R_MIPS_INSERT_B		26
-#define R_MIPS_DELETE		27
-#define R_MIPS_HIGHER		28
-#define R_MIPS_HIGHEST		29
-/*
- * The following two relocation types are specified in the MIPS ABI
- * conformance guide version 1.2 but not yet in the psABI.
- */
-#define R_MIPS_CALLHI16		30
-#define R_MIPS_CALLLO16		31
-/*
- * Introduced for MIPSr6.
- */
-#define R_MIPS_PC21_S2		60
-#define R_MIPS_PC26_S2		61
-/*
- * This range is reserved for vendor specific relocations.
- */
-#define R_MIPS_LOVENDOR		100
-#define R_MIPS_HIVENDOR		127
-
 #define SHN_MIPS_ACCOMON	0xff00		/* Allocated common symbols */
 #define SHN_MIPS_TEXT		0xff01		/* Allocated test symbols.  */
 #define SHN_MIPS_DATA		0xff02		/* Allocated data symbols.  */
diff --git a/include/uapi/linux/elf-r.h b/include/uapi/linux/elf-r.h
index c1309a63a7dc4495f22e3d8b51d3f97ab5809190..78085d26f4ab27a003fde65c8e981f575f411758 100644
--- a/include/uapi/linux/elf-r.h
+++ b/include/uapi/linux/elf-r.h
@@ -563,4 +563,58 @@
 /* Keep this the last entry.  */
 #define R_390_NUM	61
 
+/* MIPS relocations defined by the ABIs */
+#define R_MIPS_NONE		0
+#define R_MIPS_16		1
+#define R_MIPS_32		2
+#define R_MIPS_REL32		3
+#define R_MIPS_26		4
+#define R_MIPS_HI16		5
+#define R_MIPS_LO16		6
+#define R_MIPS_GPREL16		7
+#define R_MIPS_LITERAL		8
+#define R_MIPS_GOT16		9
+#define R_MIPS_PC16		10
+#define R_MIPS_CALL16		11
+#define R_MIPS_GPREL32		12
+/* The remaining relocs are defined on Irix, although they are not
+   in the MIPS ELF ABI.	 */
+#define R_MIPS_UNUSED1		13
+#define R_MIPS_UNUSED2		14
+#define R_MIPS_UNUSED3		15
+#define R_MIPS_SHIFT5		16
+#define R_MIPS_SHIFT6		17
+#define R_MIPS_64		18
+#define R_MIPS_GOT_DISP		19
+#define R_MIPS_GOT_PAGE		20
+#define R_MIPS_GOT_OFST		21
+/*
+ * The following two relocation types are specified in the MIPS ABI
+ * conformance guide version 1.2 but not yet in the psABI.
+ */
+#define R_MIPS_GOTHI16		22
+#define R_MIPS_GOTLO16		23
+#define R_MIPS_SUB		24
+#define R_MIPS_INSERT_A		25
+#define R_MIPS_INSERT_B		26
+#define R_MIPS_DELETE		27
+#define R_MIPS_HIGHER		28
+#define R_MIPS_HIGHEST		29
+/*
+ * The following two relocation types are specified in the MIPS ABI
+ * conformance guide version 1.2 but not yet in the psABI.
+ */
+#define R_MIPS_CALLHI16		30
+#define R_MIPS_CALLLO16		31
+/*
+ * Introduced for MIPSr6.
+ */
+#define R_MIPS_PC21_S2		60
+#define R_MIPS_PC26_S2		61
+/*
+ * This range is reserved for vendor specific relocations.
+ */
+#define R_MIPS_LOVENDOR		100
+#define R_MIPS_HIVENDOR		127
+
 #endif /* _UAPI_LINUX_ELF_R_H */

-- 
2.50.1


