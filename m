Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6576C79FA0
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 06:34:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8345B6B0096; Tue,  8 Sep 2026 02:33:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7BDFD6B0099; Tue,  8 Sep 2026 02:33:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6AC186B009B; Tue,  8 Sep 2026 02:33:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 41E656B0096
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 02:33:53 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D2D881203B9
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 06:33:52 +0000 (UTC)
X-FDA: 85189629504.23.F801CC2
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf11.hostedemail.com (Postfix) with ESMTP id 2FF0B40002
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 06:33:51 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=CwOxcB8A;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=UvUYKzc7;
	spf=pass (imf11.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788849231;
	b=CUsOiPe7k/Y52AGYfuKpnURsY5mbbUTGdsampCo5Y1bnhpn8KOM0jj/OaXdRWX+JYuws9K
	b/Qd3IWQuuH2Rc6Hh3oSXoUoZIOS6gQH1zaFAuJpX/QwqJAYehjrPIUQ2NKt+arBJ782aW
	cwkzMAbCKDu8LRrkxzGvD3L8uaF0DKo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788849231;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fTryvsBgAeqTDNlupTdhz6+byj4x0uN8hxYjIi8mWPU=;
	b=EHF6Rw6HUo1DHVJ0dYMewneqdBF9x60kxtp2ThvajwLsGUOh+U1jHVlznNBUbunH9lT1wZ
	lVNDs/gALd/6qQB7/eAYTQcyZxDitNfa3RHF+R9Vp3F/jGhGCKo+0zzbJrVAL+MDsgE87L
	5S8IdOGUUj5DVL996dRozfkU1BPmWHI=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=CwOxcB8A;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=UvUYKzc7;
	spf=pass (imf11.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1788849229;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fTryvsBgAeqTDNlupTdhz6+byj4x0uN8hxYjIi8mWPU=;
	b=CwOxcB8AhS+rAzoxJxOQZHdTCbx79N6KAe69evSjNQbl8+rQOeBnH057j6GmLbV1DALhq8
	17U86cF62BuTdyueeDeto2D3eKopssoZOXhfcShRfEm5vXV6EqTT598jVyGbc2eORkyLVh
	OrwoiGkQRnDZ5E3ZEV6tw1/gABJPNjg4OfwRNlUx3ukssHhmiUBD9qEjMNgBfiYtN8PegH
	fJT8dIULNkNCSoAbP1VkL7AglDnc0gE8QsTSkJtq+4VoaJqGXcwtWw3SUrOnTednE0pAqq
	eJlyWNdWyLf6mcTMJcSduvMoo3qm72MxPilwuvS8hVqXRSHO5+8hOKLulZ6+Tg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1788849229;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fTryvsBgAeqTDNlupTdhz6+byj4x0uN8hxYjIi8mWPU=;
	b=UvUYKzc74oAN8gP1sKHkjA19TUNUTqCMuc0TKrdtCmkCKri8UrtRvdSUSmYYYqwSID6op/
	x/iNcRKTPUHvcBDw==
Date: Tue, 08 Sep 2026 08:33:38 +0200
Subject: [PATCH v5 04/24] arm64: elf: Move relocation constants to UAPI
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260908-vdso-absolute-reloc-v5-4-3a93791af1cf@linutronix.de>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788849226; l=4332;
 i=thomas.weissschuh@linutronix.de; s=20240209; h=from:subject:message-id;
 bh=1i3Et1Jffcz0JOiDRayZilcvn94+w8pBUDpHzT1KG5A=;
 b=gk9oLI1obuvHKDYtmwIh7hRv/wNktDBEtLCnmMT6kMIL5ciJHyu+C7IEaeVwMOyG2DE4YvlNZ
 Q87Mb3y4KJ2C8RfQ2jmI4dzP+9h+ated8T54tLF6WOAYZo1VDmVkg+O
X-Developer-Key: i=thomas.weissschuh@linutronix.de; a=ed25519;
 pk=pfvxvpFUDJV2h2nY0FidLUml22uGLSjByFbM6aqQQws=
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 2FF0B40002
X-Stat-Signature: 6pd81w9n6bymxefm79ory3d3rtso6oeb
X-HE-Tag: 1788849231-969935
X-HE-Meta: U2FsdGVkX1/NA77l1ff484kxE3Wm16xWKFtC2sz99vGugTmE0Lut6pqM2apVjRJHVyO9d80G/fEydUwMZq5aqJKAY0oB2Rk7Dw3xflc8R3MTJ2rtj0K+8UZ2OAmf6LquABZftBGTk59tVsy2nnLXaXFM/M90bEZwjToRsJCS4AUJKCUVSxrvfxWZsoW46d6oicHCdzz77M5xkVEQpltOXEdajurjzeOYXCkz1hCqElVUaQsigeUm/Vn4QxfnYcCKgBVhGCoZPh3q1HtGtn7sed6ERovi3cQkK1e4vKojgnQnzosubkXPMW6n0q7My6uCIDUHzV6U63U9VYarbK6YF0PBSYnB8+eCYlZZ/7yIw40WFtkiGENF7uAQvZ/GSWcaDVkP9rMeqWdbHOasmKKxp1XVnqy6ynpsTI/yOqRdoGh9mNlCTy+rW84lM9/UunrBuA40zFQPX8tINcgIR1yPwhq1nsG/fHtNVXflDhe8OSi/ErrELnejWQQnIroVCmLkXbEo1J1dO7QsKmzB23FC/8KnuLxddc27y/yOKFi07amr+PRQVhALdvGeZzjVCI5A29h0CSBbJZdnpPCsTLlE1+BWAKiks6pI6JnOEGw0lOnSMLEChKKKCW2zVZPo4KYD3GEQJhEhFbbx0O7IaW7PEWv78cfFovUSul1QNS7bIRCPUsISCW+7nyVLiedGYdI3xYBJozXEtuc1m+2zrLmojHH8BF/ZhmpTG9izAmKjGOrNlrPF4EiuKwuTc2qHFk/P1qVMrEttyWARh1E3flmY1GLAXGCuH6atQEpp0ATm1Xrjqn7hSrd/+gZYcRIWJeWyKLL8PcrYt3kMElZHoMx3IjebkukkhUAgY99OrrYb7Rxv3SSh7Z290tge8Tcnr0hVaMteCCjRruR/KzrBAUHgLk79iQ0gAElJsTzP/4fK+uUkJBIOavNe57qw+wyuYfcIcHJQdeuaM83IUziWgkW
 AQY79ytj
 YnB25X+WgunnmrVtUNVCVPnU0U8wdugrdkP9Vd/gkHPBV+xgxVXsZZk33uEcDsLq+w3NNxnESjCmRF4zKqfzlL5l8paeEYIdWvJOFLRpxRC3kgLmM4XZnOV0iz1gL/rGbqREg79F+jEvD3K6ZZ2zusHk+jExvbk8bpJ9UIrNbwTlnRb5qAdbkgZlDxW6hJxnTexNIfhTqwNtJJMFGAE3pFex0nvq41LfopUYk5PPatVpzCwzNEU5++3m18ldrckGgCA4Y0QKr3fBHddJGeijsClaAF6MVXNnhp2HiJt24AApkyCVB0htSd8zUBe9bTrd14JfDRV4dKCbgm8rECvJ381T+kZlg815ebKytuYlpWsfGhtMjXQY/THwEWOBApyQsImBWsNbAaHm643QyZfoOGNeuA2twdlzw0WQlaSiEwm8+NqmeCG2uotRLv3qCXXf2Ut4heC06lXjbwwr6jteF3rQt8WZZDM5lIcKI3nG/il767WgS0zVQ1CJ5KatjLa7F9CI/HAxjw1UtTcZjJ200ldeMmCoXFQT2j423oAclDhYzgno=
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
index cfdf4c5ac08b..43f3763807a2 100644
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
index 001884641e77..cf931fc05afa 100644
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
2.55.0


