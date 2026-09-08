Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AFDD0C79F99
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 06:34:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A09276B00A0; Tue,  8 Sep 2026 02:33:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9BA3F6B00A1; Tue,  8 Sep 2026 02:33:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8CED56B00A2; Tue,  8 Sep 2026 02:33:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5E71D6B00A0
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 02:33:56 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D726E14038E
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 06:33:55 +0000 (UTC)
X-FDA: 85189629630.14.D9F514A
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf27.hostedemail.com (Postfix) with ESMTP id 265FF4000D
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 06:33:54 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=ahR3dXuI;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=VZsZyyx6;
	spf=pass (imf27.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788849234;
	b=hhkOlanWMFw/tjxzqOoVt0gnpqad7BkD1ezosKnceUJeCgDKsu5g0e3F3KLErzxtO2E+I5
	B2RB5gfOWgRrvhTy0tv37SBY0/PNvwWY5JmtD7L2aejkPH8QB54ZqT5r9R2glw3L+dK9Ft
	U+eJ2g7HSVlXipS7k5ExrnQfvQdf0ok=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=ahR3dXuI;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=VZsZyyx6;
	spf=pass (imf27.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788849234;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nJq6yR2p7bWWswQ+1JaEFwknbMonVxi+i+XtDlX1VJE=;
	b=YLHUBfkN9WcWdPZ/1zdDCRk6Q5GqSDLY3FnB2AbiVy+Ol9145jNgo1uTFYPvjAaexxpJDs
	bcA5Pp6U23sIcH8yXZBai/0nd8RTNdqltxv5uif0LMEj6qWMKBOKDFjaOng2DkvHe0sEV4
	V1W6jep3Im7hv6bNwBzAD6WM3TDUoTU=
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1788849232;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nJq6yR2p7bWWswQ+1JaEFwknbMonVxi+i+XtDlX1VJE=;
	b=ahR3dXuIvmy9rLY/NaJKRHDCHK0nSGp3+7XiZcORdfSnIPwrsGHbO7bgDbz8h9Ed9Nqwm2
	aoWGwa9rBrndpnaB9nw64Kj1w1m+8AUs44vqnM7PPYmHMeeEEo406mkBUaoKh9Hj8RAfv7
	jjc7ulGhFOejma1EKD+dVfp5TS189yjYMsgnV7FxGuGah4BrD5a8ivX5lxTOo9D1pUlbi7
	A2kvwa+AUJtq/vfQPN+lxM4XcUiIBNFikfImhIdNpNaFyr/x5u2PjfCgaPu7M+xUn5eqzi
	by8lXtwRNpOWf3XzVgrg9kptObSnF4I4PxRDxSv6HilvMNkMswBwyTjPqcyvjQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1788849232;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nJq6yR2p7bWWswQ+1JaEFwknbMonVxi+i+XtDlX1VJE=;
	b=VZsZyyx6tVMPgVUY8ZTFc6uDIAMDbc5w2oz5UFAf/4aF13Vb6IF0cflWvNHI9lzRI8DjSR
	iNQZmO5z7gh/+JCw==
Date: Tue, 08 Sep 2026 08:33:43 +0200
Subject: [PATCH v5 09/24] MIPS: ELF: Move relocation constants to UAPI
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260908-vdso-absolute-reloc-v5-9-3a93791af1cf@linutronix.de>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788849226; l=4382;
 i=thomas.weissschuh@linutronix.de; s=20240209; h=from:subject:message-id;
 bh=A10H22cVXmPgY/NixL/2JhIgd7FK72hpu8GKd8hQAKo=;
 b=qKSQneyNuKEBUb6rfiRCvkfACMHprRMYmjlZw9I/e5PmwvqMoWeNI3JR4y8qsFGqgWsmxafnd
 O3IJy63bZaPB7kwaUolzd0zlzGxuCuw9umZ22crEBlrxXnL6ZfXMF3b
X-Developer-Key: i=thomas.weissschuh@linutronix.de; a=ed25519;
 pk=pfvxvpFUDJV2h2nY0FidLUml22uGLSjByFbM6aqQQws=
X-Rspam-User: 
X-Stat-Signature: 86pheb9s1tssskcixnu6c9dxkq1zqqzs
X-Rspamd-Queue-Id: 265FF4000D
X-Rspamd-Server: rspam06
X-HE-Tag: 1788849234-405288
X-HE-Meta: U2FsdGVkX1+FGDxkv1KUg59Qak673UQZr0Qlc11JD1mWPTLo8l4nPRCD1cNjwxxrxFE6FCrbvMuMeEInDG6QDZIIB2LLK0kSNHZzo32sIB7PqRIEnUxcitK3kM2klk0H8t6OsP/qesSV3xDZnVo6O2bDBx4JJZ7MZ2FHd9VMzWaHNY+DLWKJWS4m9biMShKryG9Q4L+uwN5WvqKbRGMrs/2IYSYiBi20RXHXlFO+/qvf+YV6oEWBvRxvkjTDJphAutMTpXUQ/iHwJCE9LR/JFFcknuW80Sb2aljkS4CrAbiwJqBIvBeykCKlNOPnciePWyFsHmD3LDmEEvT+xDqLSYDU/e+QhwjhI/IOrPBgEdsWMHfP4sDHTy8t4kZhXy40mHBrPkplBdyuUAHjEx2zolloD6mi8Y4vnHqj7dMo6UmwnvdWG/YJaAWKJ01SyREZakhfiFRLjkk00sbV+OJLF2Rx491qwWBmAX0Cq6SJmxwQZ68v1L3kU9JicpCL1E4Cw5lAQGwEJHyAJ7DLQ83Vv7Wo3qrrZg3U+kL3HW6/lEw8ZIphU2ZeAV9RKOlvOeG5kKVyjSOc5cpSJXPdURDXUB5Mp1ev1h+pkVBKUFRuNmewcNAKhEeb/WteCP5wRIIa3juFWjM6wy1zGHky+EpflgBryyBzVXDl83CkZ+aZ/qv6QoK+v/YRPHCS9BwDSv+RKPdTGRupfOhDyvgvkFUK+m7YyBakaFz8jzpjL82t51vuFTD/ewTB/L1m55CcHUL0zWOHs7weUlgfZmwokKM77osAOMqgbLJqCvfHxzkedVNUYbxIcnHUBcQCsjiLluOLbG5ZFpr2ASgzRdqMAUVI0PlghQ9vVQoa/+5FHJfP50XZ2cbRnmYHVmWmtOJCk2OTE3FGlF27MHpRKb+l+yOFLdPMEcnTmWcwgvFoLD+U77jmKMYQvJtccGvbycLx8CbjX50l4zSLy+DiBZxherL
 xh8Mq2XB
 /KfjsIqIYU+e+KPbM7W5k+Vyp1r/Tv+25MBx3aO1TjWmv7Aeou89p3rTTbbu11gw16lWlT2NngCZ/Clh2kspDSWJgMB/bDgOjoVfYfBCAkqYuTXzewqaSYrxBtBZEzLa9oMVjOLSWu7PE33ztT2WmYOUYd6cEBKxjiSxlOLz8QEGiq2a55YmQx4RN1m0hQJLm6fQGKPMHXcB7yVAfPXK2a/qTron1v6CnnmEgCDTQPwtT4am0LLIq6hE/G/PSK2i2iny5BAnyclYh/8afijlubWKDayK2HJUPftTL8+KmXVvGEk1EPADeQVknDwvZq22KfHeslpzZwuyC0i8UESqW2kYMw17LZ0AgJtZd86MpV+gcQ1+dPHAVhY6fkIUCmdyFD1B8jemUzZ6tF7UfXq8CMmIXwFXtZVIJGf7uHv+0kQJjjD7Ws/WJKSVDzHCoOZnn1FVZJ1JRlOFqg8wGZATZHoCGGzmvKGf3z17H2PJm54zJCOLWdKONIa2DD8bUUczh57Ws3vnb4eQVcF60ldA5WaBpThKezKpepMOnDqZo4lCXstE=
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
 arch/mips/include/asm/elf.h | 55 --------------------------------------------
 include/uapi/linux/elf-r.h  | 56 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 56 insertions(+), 55 deletions(-)

diff --git a/arch/mips/include/asm/elf.h b/arch/mips/include/asm/elf.h
index aaef0eaa68d5..347e12584bee 100644
--- a/arch/mips/include/asm/elf.h
+++ b/arch/mips/include/asm/elf.h
@@ -70,61 +70,6 @@
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
-#define R_MIPS_PC32		248
-
 #define SHN_MIPS_ACCOMON	0xff00		/* Allocated common symbols */
 #define SHN_MIPS_TEXT		0xff01		/* Allocated test symbols.  */
 #define SHN_MIPS_DATA		0xff02		/* Allocated data symbols.  */
diff --git a/include/uapi/linux/elf-r.h b/include/uapi/linux/elf-r.h
index 3d9e3b57f1ff..0c6a8698f300 100644
--- a/include/uapi/linux/elf-r.h
+++ b/include/uapi/linux/elf-r.h
@@ -593,4 +593,60 @@
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
+#define R_MIPS_PC32		248
+
 #endif /* _UAPI_LINUX_ELF_R_H */

-- 
2.55.0


