Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 792AACA0EDA
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 05:44:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8BC678E00CA; Tue, 12 Aug 2025 01:44:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8465A8E00BE; Tue, 12 Aug 2025 01:44:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 698D08E00CA; Tue, 12 Aug 2025 01:44:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 50F498E00BE
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 01:44:36 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 171DF1A0165
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 05:44:36 +0000 (UTC)
X-FDA: 83767015752.09.18C7AC1
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf16.hostedemail.com (Postfix) with ESMTP id 3425F180004
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 05:44:33 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=LKiTWvfb;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=4TwJQtL0;
	spf=pass (imf16.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754977474;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dkZKFkMLET6nFcPB2WNffaOSCveGBK/DoVsJr+6leSI=;
	b=rnTm4m5LAsb4PiD7CgvuX3Kjcf9+uGV5IZ306zdqOSL4zBdlCQ5sxQ4k33FY7lS8ZaPx/V
	3SGkBUvD2367jxzbXJcDB8zQEheF/22sCtNFDgPvwioSSJhiB1ROyyGH/71aDMzOJd6xnj
	dBOSttDjzJZS1gbup03jSqjtxjV2OyU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754977474; a=rsa-sha256;
	cv=none;
	b=ZIoDMhcFrmViucMmFIqH+huZkB91QajQkMgLSci8YMaSFwQTh6XWNoxGTbEsKvf1mPIppP
	r34b/UBcOCFbwGjDN56KfzyRyxTyQOyw/2miSm3Kq+XYUBhOTV1ddTL5PmlNzVbh9jHC84
	m0pcQCJgMS/c7BoA9dGbREWY1mZSgsU=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=LKiTWvfb;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=4TwJQtL0;
	spf=pass (imf16.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1754977472;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dkZKFkMLET6nFcPB2WNffaOSCveGBK/DoVsJr+6leSI=;
	b=LKiTWvfbe4sMF2JqJpsl5CRdkfSHca9QAI6VsemqVTqROhwCEorsYpYPKmr+pCeUzczBPL
	lHiLvd6vhjMW+nDOKYD8HJiFnADn8FYNXoy3PLssT7rxID6/ofIv5S6BU93tu/BjTQ3zFZ
	f+21QfpLHJ+20Cv6mZbG6zxNBKvj7HT/hFCAA3DjqZwewTsOPEzPa95cGSRO7jioU6muIg
	r+AfsplYFpXa1HtHFAkSc/u3FYPvQslQo5BqvTx3yjG40NQJEXQgELqm3Y/R91vyPu6YFj
	lnGELQzhXrNx6pRaRRbu8P9vTDjg6NfngtEE3BLPdXDCaAsI48w14NVifsW7gQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1754977472;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dkZKFkMLET6nFcPB2WNffaOSCveGBK/DoVsJr+6leSI=;
	b=4TwJQtL0DH1Y8FEY0nXw5JLyqTIDve3EQ5RM8bs+Izei6SC/5r+S+kSlkbwlcwESU+Bzxx
	vL69R3DfS2dxTZAg==
Date: Tue, 12 Aug 2025 07:44:17 +0200
Subject: [PATCH v4 04/24] arm64: elf: Move relocation constants to UAPI
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20250812-vdso-absolute-reloc-v4-4-61a8b615e5ec@linutronix.de>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1754977469; l=4444;
 i=thomas.weissschuh@linutronix.de; s=20240209; h=from:subject:message-id;
 bh=HzT2SYHSNRm4ZtRujeJaJIJT/indjE0TyRY6RtPSNtQ=;
 b=S9P2n5/cBPWTmkH8+DZZ91/PGYQizVg5PAYegpw8TUQhE90iFtIunP8BCI0PJECMORxxw1wn5
 kPEmqcrLaUdCEdmy5grg/+JQY5xzBpIU7jPXrEa9kA+HChds1EvqNqF
X-Developer-Key: i=thomas.weissschuh@linutronix.de; a=ed25519;
 pk=pfvxvpFUDJV2h2nY0FidLUml22uGLSjByFbM6aqQQws=
X-Rspamd-Queue-Id: 3425F180004
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: n6xw3amxtwhsi71zw8ctttbd9c4jzusy
X-HE-Tag: 1754977473-951251
X-HE-Meta: U2FsdGVkX1+oqxFlikGoj/5IiRN6X8DE/C4OivDjOuajxtU/k/EiQMeTh1g92ZDb5DTlQHUnFJh1z2fvUAtwLQPq+CABp60/EG5Bfl6u+fIdtU/MsOZeU97WDqmbT4wEUI4zgEpkmh4cstjiFiYkPrZPrd1lyUnngQMcLkaz0MMt+HHmvlygAuwQ33Ocw+Iv3qZnz+DhVZ9sR3f3/iBuRgK2bTli3UKed6ZTpi1C4SNoZpGPsiijFB8Cnfbn6fXoMmPGTxXVRBkvvUlAeGeLc1wC2dmg/1AJ6WwdydEk6N7wyLu6cLbJOTb5RzrJi5s0jPwVWrNz21x3K3XtUSio7S5RO+Ld6kxsV0VCFMp3W87p0zJQh87WuqNx5ns6iuortPd0XItqtuGAmA6G6PAdRVqeuPB9KI+OLnlx08ww9JCQQkd5clQdtj7VsQS0ZZYcINdw0d0CiaH08KsFbuXT82tS+gYtUnzGWxaLOp7Oi2lZExSgaG2+3Vm4Yj5fE/zx+6k92f6n6qupXi9Wzjy/4oIsl/GVCqky3hHNyT2xHzM4wO27sRgixT70BJ6MTxSv3yF2ce01135h/S9Rb7XhyzpB0GlZ8yxEgFMtXeW3f4xXyDN86Q9hiPVqGCMuJz6LdxE5LrKbtEEphapVqt3X8v56sKsiAAg0rL+WUaJFifXaK+v03IcphxpESvJ9xex0A7GGtMUKEClW63quibZyQL1eS1J/mX60l7wVTtFGg6+KqSMhbwAuvVOdbmxzVwI4ghwWTF9LZSsEOeefXeKcDzi7qlNGbEVUFE78fLXfyNlxv3aHXnT3Z3FuAfnIhL3qBFXSqEVB79/cJ/yHGSLbcDWKiAOX6YdUblLN1OGU+GoZJpr+J8tjrQ8nwzQFr7j+n4a06XOZG/fXXu1MH9wmQDvlFOUxl5SGbjTAAxEuAHFIO7sZ7+NAVDUKv8PzAt7c4yYeyY8pXRNisujvqbn
 m5qow8/6
 c0SYxmOY7PTg6C//9EPqmOvf16OqzoR5jZr2wGf1SI9m+JD4ObOVotNomXGfgpVUQMvrXQM8NlCasMdSYTgaijYMhTh4JZvlHWdDJ39tWZFW528U5aflqpfgSJ6obikoQRo567ZwUj4IOyzLiQhrHPPeysIuSnMo+pRyFB8xDo0yLa9Pdjs27PDCeb8zVoasA8UXpUeJPpOzhhzucrvBvjv9djcH0cizFrnrKsEE35RxdXWWcI7F4cUd9H/TW5EICaf+Kvi+IV3r0tWRUdmxa78GYACKe1ogwrNeRMlFHD/elkAwvM/5TpYCTO9phXC/og+jo9mxfXkgF5LLt1sJ77+DMDQZm+3gkQpngmlpbdESD1SAUFU4o5N/pUugarVy97Bc07myMvKXLNW39lxkEJECGP0/dc/84C4rR8Sh8klW9Tr0Hnf+pFkAiasOVgaxCDvsYh+EzTEf4nDJ8hTigeTT2kQvVZT2QXEiCGUNfdYeph+h4JJG2T2H44El7QbKn0A39
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
 arch/arm64/include/asm/elf.h | 54 --------------------------------------------
 include/uapi/linux/elf-r.h   | 52 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 52 insertions(+), 54 deletions(-)

diff --git a/arch/arm64/include/asm/elf.h b/arch/arm64/include/asm/elf.h
index 8efcfe7efe0c70c59b9b81f93ac9c1442bc7656a..a14b88fb485e60f89332f0c6b58ed929eb6600b6 100644
--- a/arch/arm64/include/asm/elf.h
+++ b/arch/arm64/include/asm/elf.h
@@ -13,60 +13,6 @@
 #include <asm/ptrace.h>
 #include <asm/user.h>
 
-/*
- * AArch64 static relocation types.
- */
-
-/* Miscellaneous. */
-#define R_AARCH64_NONE			256
-
-/* Data. */
-#define R_AARCH64_ABS64			257
-#define R_AARCH64_ABS32			258
-#define R_AARCH64_ABS16			259
-#define R_AARCH64_PREL64		260
-#define R_AARCH64_PREL32		261
-#define R_AARCH64_PREL16		262
-
-/* Instructions. */
-#define R_AARCH64_MOVW_UABS_G0		263
-#define R_AARCH64_MOVW_UABS_G0_NC	264
-#define R_AARCH64_MOVW_UABS_G1		265
-#define R_AARCH64_MOVW_UABS_G1_NC	266
-#define R_AARCH64_MOVW_UABS_G2		267
-#define R_AARCH64_MOVW_UABS_G2_NC	268
-#define R_AARCH64_MOVW_UABS_G3		269
-
-#define R_AARCH64_MOVW_SABS_G0		270
-#define R_AARCH64_MOVW_SABS_G1		271
-#define R_AARCH64_MOVW_SABS_G2		272
-
-#define R_AARCH64_LD_PREL_LO19		273
-#define R_AARCH64_ADR_PREL_LO21		274
-#define R_AARCH64_ADR_PREL_PG_HI21	275
-#define R_AARCH64_ADR_PREL_PG_HI21_NC	276
-#define R_AARCH64_ADD_ABS_LO12_NC	277
-#define R_AARCH64_LDST8_ABS_LO12_NC	278
-
-#define R_AARCH64_TSTBR14		279
-#define R_AARCH64_CONDBR19		280
-#define R_AARCH64_JUMP26		282
-#define R_AARCH64_CALL26		283
-#define R_AARCH64_LDST16_ABS_LO12_NC	284
-#define R_AARCH64_LDST32_ABS_LO12_NC	285
-#define R_AARCH64_LDST64_ABS_LO12_NC	286
-#define R_AARCH64_LDST128_ABS_LO12_NC	299
-
-#define R_AARCH64_MOVW_PREL_G0		287
-#define R_AARCH64_MOVW_PREL_G0_NC	288
-#define R_AARCH64_MOVW_PREL_G1		289
-#define R_AARCH64_MOVW_PREL_G1_NC	290
-#define R_AARCH64_MOVW_PREL_G2		291
-#define R_AARCH64_MOVW_PREL_G2_NC	292
-#define R_AARCH64_MOVW_PREL_G3		293
-
-#define R_AARCH64_RELATIVE		1027
-
 /*
  * These are used to set parameters in the core dumps.
  */
diff --git a/include/uapi/linux/elf-r.h b/include/uapi/linux/elf-r.h
index 001884641e7703146f91e2dd96fb5a2bbfc7a324..cf931fc05afa1825aa9737a4e6259ec0da678d3a 100644
--- a/include/uapi/linux/elf-r.h
+++ b/include/uapi/linux/elf-r.h
@@ -61,4 +61,56 @@
 #define R_ARM_THM_MOVW_PREL_NC	49
 #define R_ARM_THM_MOVT_PREL	50
 
+/* AArch64 static relocation types */
+
+/* Miscellaneous. */
+#define R_AARCH64_NONE			256
+
+/* Data. */
+#define R_AARCH64_ABS64			257
+#define R_AARCH64_ABS32			258
+#define R_AARCH64_ABS16			259
+#define R_AARCH64_PREL64		260
+#define R_AARCH64_PREL32		261
+#define R_AARCH64_PREL16		262
+
+/* Instructions. */
+#define R_AARCH64_MOVW_UABS_G0		263
+#define R_AARCH64_MOVW_UABS_G0_NC	264
+#define R_AARCH64_MOVW_UABS_G1		265
+#define R_AARCH64_MOVW_UABS_G1_NC	266
+#define R_AARCH64_MOVW_UABS_G2		267
+#define R_AARCH64_MOVW_UABS_G2_NC	268
+#define R_AARCH64_MOVW_UABS_G3		269
+
+#define R_AARCH64_MOVW_SABS_G0		270
+#define R_AARCH64_MOVW_SABS_G1		271
+#define R_AARCH64_MOVW_SABS_G2		272
+
+#define R_AARCH64_LD_PREL_LO19		273
+#define R_AARCH64_ADR_PREL_LO21		274
+#define R_AARCH64_ADR_PREL_PG_HI21	275
+#define R_AARCH64_ADR_PREL_PG_HI21_NC	276
+#define R_AARCH64_ADD_ABS_LO12_NC	277
+#define R_AARCH64_LDST8_ABS_LO12_NC	278
+
+#define R_AARCH64_TSTBR14		279
+#define R_AARCH64_CONDBR19		280
+#define R_AARCH64_JUMP26		282
+#define R_AARCH64_CALL26		283
+#define R_AARCH64_LDST16_ABS_LO12_NC	284
+#define R_AARCH64_LDST32_ABS_LO12_NC	285
+#define R_AARCH64_LDST64_ABS_LO12_NC	286
+#define R_AARCH64_LDST128_ABS_LO12_NC	299
+
+#define R_AARCH64_MOVW_PREL_G0		287
+#define R_AARCH64_MOVW_PREL_G0_NC	288
+#define R_AARCH64_MOVW_PREL_G1		289
+#define R_AARCH64_MOVW_PREL_G1_NC	290
+#define R_AARCH64_MOVW_PREL_G2		291
+#define R_AARCH64_MOVW_PREL_G2_NC	292
+#define R_AARCH64_MOVW_PREL_G3		293
+
+#define R_AARCH64_RELATIVE		1027
+
 #endif /* _UAPI_LINUX_ELF_R_H */

-- 
2.50.1


