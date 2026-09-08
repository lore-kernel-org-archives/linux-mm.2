Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7FE4DC79FA0
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 06:41:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 81D226B0093; Tue,  8 Sep 2026 02:41:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F4FA6B00C0; Tue,  8 Sep 2026 02:41:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 70BCC6B00C1; Tue,  8 Sep 2026 02:41:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 490CC6B0093
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 02:41:52 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D4A351C2172
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 06:41:51 +0000 (UTC)
X-FDA: 85189649622.27.7D12271
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf12.hostedemail.com (Postfix) with ESMTP id 188DE40002
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 06:41:49 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=MfWNTOL9;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=0B3ADoRp;
	spf=pass (imf12.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788849710;
	b=qUXzKx5xg6xZOBVRDnRV5VfVGJC//QIRlg4RqxBDTjHevXEG3pwORDCwhlZlcScPVxqjJ2
	DLhHNbrehVhssyKs0TOBpvp/Uuw1eErk264QmWTyM9dXiV5UWSaQWreRreHPpHTnnZcCnY
	fj3UGx0JgPnM8dZcD3NYEoHaiHQsdAo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788849710;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Euss1hU2x2ZhK7+uMEH3xqUmzL1+lNLDeNKt8zx8Zkc=;
	b=bRFe6P0u+DuvWEkWHCtvN9qVBU93p6jq9lZHmkZxpIq3u4aOquvK7zXGhbzgR5gmc14unf
	ToVDCbTpMjnQeZ0COKIf4pEXSEQW8jo99k1lvsfXOXX2h4Ao+FFPr2uee2gpYS7KKQ7fjg
	UWJkJB1vCOyxTyzwItv83+di8VYEzGg=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=MfWNTOL9;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=0B3ADoRp;
	spf=pass (imf12.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1788849232;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Euss1hU2x2ZhK7+uMEH3xqUmzL1+lNLDeNKt8zx8Zkc=;
	b=MfWNTOL9A5T1vKJNwIjD59pmTGPuW36oTts5TGKycfknuZNPWHLCXMwTXagPiM5olzrNXC
	A2KmwpugkTYWoeqHDnToD2jl3QNHOIswTcybHrvOnlc4JoDkIlR04nz6Ibidrn5s8nZAZz
	+GciVMvzSge9Vlz1fsbKdU1Wzkef0/Ky0c3NjMs6MjUvAKfXGksre3HmkLYGKqnLW9o7Wn
	y8T2cq5/LZljl4BGC0uXKmxYxgMrXPXUbQC7B4GuVjrnj5HS4uJCzASAlVzsyHkX0YuIgX
	nDze63+7a6KzaBfAEIy7iVTyLPX+eaJ2jVHV39+R1eshowrRkZ8BFQiTOfpc0Q==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1788849232;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Euss1hU2x2ZhK7+uMEH3xqUmzL1+lNLDeNKt8zx8Zkc=;
	b=0B3ADoRpJrC3qmibbpi8s3Rm0FLlooEMu2n34FPnb6gxO/K5fuylFaQ0QT96IU14e1TUB7
	7fSguoDBSlga1zDQ==
Date: Tue, 08 Sep 2026 08:33:42 +0200
Subject: [PATCH v5 08/24] s390/elf: Move relocation constants to UAPI
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260908-vdso-absolute-reloc-v5-8-3a93791af1cf@linutronix.de>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788849226; l=11064;
 i=thomas.weissschuh@linutronix.de; s=20240209; h=from:subject:message-id;
 bh=lWVxO2QThO9KZ071syRFd2yqH7yAImHYPgjFRfvsAZw=;
 b=2TWWP6HVLxWfv7jDIA/m6Eu8ceLWfYcGBhxvF6/tO1AGkQbV7fcELQWaBtCEJ6WUoq40vLhZF
 7P+tlHmMhvyCp8JHYjB2hZYnihD6Uft1M/hUydD9OHIL1FS1MCFcQ9m
X-Developer-Key: i=thomas.weissschuh@linutronix.de; a=ed25519;
 pk=pfvxvpFUDJV2h2nY0FidLUml22uGLSjByFbM6aqQQws=
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 188DE40002
X-Stat-Signature: pkz93msqe1ct8y5utqp1h93uc3odakrp
X-HE-Tag: 1788849709-473928
X-HE-Meta: U2FsdGVkX1/4kZ2kHLmJ1Qzr15BeiAHT/rDzXILn1V8M3yLjIsvhOiKZHhahuyKGwo4ye1WQf4g8USfdPP18XrlKL01nUtNPWBrMgGodTrFj8wEt53OOq+ZYaxnMTjrUR6Pm5ItC3Sy/s77PHj+KPk9ovsNFy8v7QdcM7XRvlpwJu14RklfhrCChJl5dGh9rrPApHdpsN6nuBM7W2scuD9qWXQYHR3jCaWhMgIN1haACZblUzgU4QOnUqMg0zAXunz24v908ouAOEdc+EtxSA8zx5SlQSrOo4TKdZCiv5T7pOYAksIVGo3YKB0NLHHIYPp0cfG02jX8oCHd7Ivf1MpuEKRabr+hNxrbpN2vC8v1fOz8znjhjGXbwnNr6Csidz6GOOZ41JX525NQ+moj+kYAMObEMz/odIgJTmMwOlUl7yfARZXfbpD48C7b9BtAbcKbOIt57lrRdQPsGAI7djj4LiSriM9MV1LLscTTwtMM7k7ySoYqyceTYfv+1dd5O7uD7KiJiQCDS/0JF3uZHdHneHnIB9MuNY/BlXE+ttFYgFJX2S8GO7kleSQ8gGE/jFgjTVBCE5i+S+dnqJG8SitHbi0ygTnp6WWbqscSH6WmPYxs3wPKh1Z/3oB6+gZ+dkkW6FhZKYmOg0QxlQfh69BAuWLdApROhQBqTs0Vg+xTIY1cQw5ltoSIkwQyJ5g2oYcrXiFhvsPaqCUeeyqzxrAAYRrGBTb45HWXf8KvfAkSq2RzGH50aqhj17ZL+mSWjfLXV6XHq2COT8vBQU3Zikeh1mcCr53RRZa1A5ligL4kuBI90s+RtdM3kyo/fSqldV61vctKEKsXj6N1CFhXNI5LDm4McAh2xopKHAO0wfM+DHW11ouD/obDzHM9fBHa6iCz9Cj4JHd5d4MSPZQzFAgGWTK/ocTK5qKH0yxgEKFlaGSekK3/AGg/iQU4r05JGjZ3rW0+FLAYK/YqegZU
 isOaV2Tf
 K7s0JNBBWIIiIsFefuIK0HDsqiAFsVE63FoJKr0LzxSxEJQ3zmiuR9/Qh9urz1Dd0/3sr8aTChTNeqXyl05Y8cNIyD3XPqdgm7G6+ZVwl6IPuY1MLSCgUQo9MYEXKesuKoYgSYvQXl8mNpMvDulNMvBEtwa+2vgG1A5bICUSDLMmt3JgK3xqVQunnD2mQjLTy5DHl4gNuHVgOG6u+9mcrsb/FOhoxBnawXFdfT0PV2tlBK510UMbMwcx5GRRdIlvoBDD3hR7dwsNVd675P09wIH+Vou6oxsiFz4qq/oTSFicpRmHQNwb7VY4/Ac7af5VaJDVwY1HoqLmhBaA0F2MHYebCEBaVoi42Th1m4dVH4RJ5N/wgAEnP6Zl33VBIM/wDpbjCqRsZDl9BbtCoMVMWLdVZuLCEOYH8eUxNQISD5+zVIeiUL/qlcMcBGGUnk25VWqTQ1yLcX768smpyMw1cCcPb8gS3oCz1C1uGHYkbYuoG0WCf+xazKh33xIRzVQErQlBC+VIxZ/WoKs948kiSR8jRfTkW0J8InjsPWirwndVcmRU=
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
 arch/s390/include/asm/elf.h | 83 ---------------------------------------------
 include/uapi/linux/elf-r.h  | 83 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 83 insertions(+), 83 deletions(-)

diff --git a/arch/s390/include/asm/elf.h b/arch/s390/include/asm/elf.h
index bb63fa4d20bb..c3fa168f0c30 100644
--- a/arch/s390/include/asm/elf.h
+++ b/arch/s390/include/asm/elf.h
@@ -8,89 +8,6 @@
 #ifndef __ASMS390_ELF_H
 #define __ASMS390_ELF_H
 
-/* s390 relocations defined by the ABIs */
-#define R_390_NONE		0	/* No reloc.  */
-#define R_390_8			1	/* Direct 8 bit.  */
-#define R_390_12		2	/* Direct 12 bit.  */
-#define R_390_16		3	/* Direct 16 bit.  */
-#define R_390_32		4	/* Direct 32 bit.  */
-#define R_390_PC32		5	/* PC relative 32 bit.	*/
-#define R_390_GOT12		6	/* 12 bit GOT offset.  */
-#define R_390_GOT32		7	/* 32 bit GOT offset.  */
-#define R_390_PLT32		8	/* 32 bit PC relative PLT address.  */
-#define R_390_COPY		9	/* Copy symbol at runtime.  */
-#define R_390_GLOB_DAT		10	/* Create GOT entry.  */
-#define R_390_JMP_SLOT		11	/* Create PLT entry.  */
-#define R_390_RELATIVE		12	/* Adjust by program base.  */
-#define R_390_GOTOFF32		13	/* 32 bit offset to GOT.	 */
-#define R_390_GOTPC		14	/* 32 bit PC rel. offset to GOT.  */
-#define R_390_GOT16		15	/* 16 bit GOT offset.  */
-#define R_390_PC16		16	/* PC relative 16 bit.	*/
-#define R_390_PC16DBL		17	/* PC relative 16 bit shifted by 1.  */
-#define R_390_PLT16DBL		18	/* 16 bit PC rel. PLT shifted by 1.  */
-#define R_390_PC32DBL		19	/* PC relative 32 bit shifted by 1.  */
-#define R_390_PLT32DBL		20	/* 32 bit PC rel. PLT shifted by 1.  */
-#define R_390_GOTPCDBL		21	/* 32 bit PC rel. GOT shifted by 1.  */
-#define R_390_64		22	/* Direct 64 bit.  */
-#define R_390_PC64		23	/* PC relative 64 bit.	*/
-#define R_390_GOT64		24	/* 64 bit GOT offset.  */
-#define R_390_PLT64		25	/* 64 bit PC relative PLT address.  */
-#define R_390_GOTENT		26	/* 32 bit PC rel. to GOT entry >> 1. */
-#define R_390_GOTOFF16		27	/* 16 bit offset to GOT. */
-#define R_390_GOTOFF64		28	/* 64 bit offset to GOT. */
-#define R_390_GOTPLT12		29	/* 12 bit offset to jump slot.	*/
-#define R_390_GOTPLT16		30	/* 16 bit offset to jump slot.	*/
-#define R_390_GOTPLT32		31	/* 32 bit offset to jump slot.	*/
-#define R_390_GOTPLT64		32	/* 64 bit offset to jump slot.	*/
-#define R_390_GOTPLTENT		33	/* 32 bit rel. offset to jump slot.  */
-#define R_390_PLTOFF16		34	/* 16 bit offset from GOT to PLT. */
-#define R_390_PLTOFF32		35	/* 32 bit offset from GOT to PLT. */
-#define R_390_PLTOFF64		36	/* 16 bit offset from GOT to PLT. */
-#define R_390_TLS_LOAD		37	/* Tag for load insn in TLS code. */
-#define R_390_TLS_GDCALL	38	/* Tag for function call in general
-                                           dynamic TLS code.  */
-#define R_390_TLS_LDCALL	39	/* Tag for function call in local
-                                           dynamic TLS code.  */
-#define R_390_TLS_GD32		40	/* Direct 32 bit for general dynamic
-                                           thread local data.  */
-#define R_390_TLS_GD64		41	/* Direct 64 bit for general dynamic
-                                           thread local data.  */
-#define R_390_TLS_GOTIE12	42	/* 12 bit GOT offset for static TLS
-                                           block offset.  */
-#define R_390_TLS_GOTIE32	43	/* 32 bit GOT offset for static TLS
-                                           block offset.  */
-#define R_390_TLS_GOTIE64	44	/* 64 bit GOT offset for static TLS
-                                           block offset.  */
-#define R_390_TLS_LDM32		45	/* Direct 32 bit for local dynamic
-                                           thread local data in LD code.  */
-#define R_390_TLS_LDM64		46	/* Direct 64 bit for local dynamic
-                                           thread local data in LD code.  */
-#define R_390_TLS_IE32		47	/* 32 bit address of GOT entry for
-                                           negated static TLS block offset.  */
-#define R_390_TLS_IE64		48	/* 64 bit address of GOT entry for
-                                           negated static TLS block offset.  */
-#define R_390_TLS_IEENT		49	/* 32 bit rel. offset to GOT entry for
-                                           negated static TLS block offset.  */
-#define R_390_TLS_LE32		50	/* 32 bit negated offset relative to
-                                           static TLS block.  */
-#define R_390_TLS_LE64		51	/* 64 bit negated offset relative to
-                                           static TLS block.  */
-#define R_390_TLS_LDO32		52	/* 32 bit offset relative to TLS
-                                           block.  */
-#define R_390_TLS_LDO64		53	/* 64 bit offset relative to TLS
-                                           block.  */
-#define R_390_TLS_DTPMOD	54	/* ID of module containing symbol.  */
-#define R_390_TLS_DTPOFF	55	/* Offset in TLS block.  */
-#define R_390_TLS_TPOFF		56	/* Negate offset in static TLS
-                                           block.  */
-#define R_390_20		57	/* Direct 20 bit.  */
-#define R_390_GOT20		58	/* 20 bit GOT offset.  */
-#define R_390_GOTPLT20		59	/* 20 bit offset to jump slot.  */
-#define R_390_TLS_GOTIE20	60	/* 20 bit GOT offset for static TLS
-					   block offset.  */
-/* Keep this the last entry.  */
-#define R_390_NUM	61
-
 /*
  * HWCAP flags - for AT_HWCAP
  *
diff --git a/include/uapi/linux/elf-r.h b/include/uapi/linux/elf-r.h
index 4b6d3f111d7b..3d9e3b57f1ff 100644
--- a/include/uapi/linux/elf-r.h
+++ b/include/uapi/linux/elf-r.h
@@ -510,4 +510,87 @@
 #define R_LARCH_TLS_DESC_PCADD_HI20		138
 #define R_LARCH_TLS_DESC_PCADD_LO12		139
 
+/* s390 relocations defined by the ABIs */
+#define R_390_NONE		0	/* No reloc.  */
+#define R_390_8			1	/* Direct 8 bit.  */
+#define R_390_12		2	/* Direct 12 bit.  */
+#define R_390_16		3	/* Direct 16 bit.  */
+#define R_390_32		4	/* Direct 32 bit.  */
+#define R_390_PC32		5	/* PC relative 32 bit.	*/
+#define R_390_GOT12		6	/* 12 bit GOT offset.  */
+#define R_390_GOT32		7	/* 32 bit GOT offset.  */
+#define R_390_PLT32		8	/* 32 bit PC relative PLT address.  */
+#define R_390_COPY		9	/* Copy symbol at runtime.  */
+#define R_390_GLOB_DAT		10	/* Create GOT entry.  */
+#define R_390_JMP_SLOT		11	/* Create PLT entry.  */
+#define R_390_RELATIVE		12	/* Adjust by program base.  */
+#define R_390_GOTOFF32		13	/* 32 bit offset to GOT.	 */
+#define R_390_GOTPC		14	/* 32 bit PC rel. offset to GOT.  */
+#define R_390_GOT16		15	/* 16 bit GOT offset.  */
+#define R_390_PC16		16	/* PC relative 16 bit.	*/
+#define R_390_PC16DBL		17	/* PC relative 16 bit shifted by 1.  */
+#define R_390_PLT16DBL		18	/* 16 bit PC rel. PLT shifted by 1.  */
+#define R_390_PC32DBL		19	/* PC relative 32 bit shifted by 1.  */
+#define R_390_PLT32DBL		20	/* 32 bit PC rel. PLT shifted by 1.  */
+#define R_390_GOTPCDBL		21	/* 32 bit PC rel. GOT shifted by 1.  */
+#define R_390_64		22	/* Direct 64 bit.  */
+#define R_390_PC64		23	/* PC relative 64 bit.	*/
+#define R_390_GOT64		24	/* 64 bit GOT offset.  */
+#define R_390_PLT64		25	/* 64 bit PC relative PLT address.  */
+#define R_390_GOTENT		26	/* 32 bit PC rel. to GOT entry >> 1. */
+#define R_390_GOTOFF16		27	/* 16 bit offset to GOT. */
+#define R_390_GOTOFF64		28	/* 64 bit offset to GOT. */
+#define R_390_GOTPLT12		29	/* 12 bit offset to jump slot.	*/
+#define R_390_GOTPLT16		30	/* 16 bit offset to jump slot.	*/
+#define R_390_GOTPLT32		31	/* 32 bit offset to jump slot.	*/
+#define R_390_GOTPLT64		32	/* 64 bit offset to jump slot.	*/
+#define R_390_GOTPLTENT		33	/* 32 bit rel. offset to jump slot.  */
+#define R_390_PLTOFF16		34	/* 16 bit offset from GOT to PLT. */
+#define R_390_PLTOFF32		35	/* 32 bit offset from GOT to PLT. */
+#define R_390_PLTOFF64		36	/* 16 bit offset from GOT to PLT. */
+#define R_390_TLS_LOAD		37	/* Tag for load insn in TLS code. */
+#define R_390_TLS_GDCALL	38	/* Tag for function call in general
+                                           dynamic TLS code.  */
+#define R_390_TLS_LDCALL	39	/* Tag for function call in local
+                                           dynamic TLS code.  */
+#define R_390_TLS_GD32		40	/* Direct 32 bit for general dynamic
+                                           thread local data.  */
+#define R_390_TLS_GD64		41	/* Direct 64 bit for general dynamic
+                                           thread local data.  */
+#define R_390_TLS_GOTIE12	42	/* 12 bit GOT offset for static TLS
+                                           block offset.  */
+#define R_390_TLS_GOTIE32	43	/* 32 bit GOT offset for static TLS
+                                           block offset.  */
+#define R_390_TLS_GOTIE64	44	/* 64 bit GOT offset for static TLS
+                                           block offset.  */
+#define R_390_TLS_LDM32		45	/* Direct 32 bit for local dynamic
+                                           thread local data in LD code.  */
+#define R_390_TLS_LDM64		46	/* Direct 64 bit for local dynamic
+                                           thread local data in LD code.  */
+#define R_390_TLS_IE32		47	/* 32 bit address of GOT entry for
+                                           negated static TLS block offset.  */
+#define R_390_TLS_IE64		48	/* 64 bit address of GOT entry for
+                                           negated static TLS block offset.  */
+#define R_390_TLS_IEENT		49	/* 32 bit rel. offset to GOT entry for
+                                           negated static TLS block offset.  */
+#define R_390_TLS_LE32		50	/* 32 bit negated offset relative to
+                                           static TLS block.  */
+#define R_390_TLS_LE64		51	/* 64 bit negated offset relative to
+                                           static TLS block.  */
+#define R_390_TLS_LDO32		52	/* 32 bit offset relative to TLS
+                                           block.  */
+#define R_390_TLS_LDO64		53	/* 64 bit offset relative to TLS
+                                           block.  */
+#define R_390_TLS_DTPMOD	54	/* ID of module containing symbol.  */
+#define R_390_TLS_DTPOFF	55	/* Offset in TLS block.  */
+#define R_390_TLS_TPOFF		56	/* Negate offset in static TLS
+                                           block.  */
+#define R_390_20		57	/* Direct 20 bit.  */
+#define R_390_GOT20		58	/* 20 bit GOT offset.  */
+#define R_390_GOTPLT20		59	/* 20 bit offset to jump slot.  */
+#define R_390_TLS_GOTIE20	60	/* 20 bit GOT offset for static TLS
+					   block offset.  */
+/* Keep this the last entry.  */
+#define R_390_NUM	61
+
 #endif /* _UAPI_LINUX_ELF_R_H */

-- 
2.55.0


