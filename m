Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91DD6C79F99
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 06:33:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 108306B0095; Tue,  8 Sep 2026 02:33:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BD1E6B0099; Tue,  8 Sep 2026 02:33:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB2C16B0095; Tue,  8 Sep 2026 02:33:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A5ED26B0095
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 02:33:52 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3A8E51A0280
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 06:33:52 +0000 (UTC)
X-FDA: 85189629504.24.CA0C576
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf17.hostedemail.com (Postfix) with ESMTP id 7114840007
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 06:33:50 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=rfwyK8rj;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=kmw243Q2;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf17.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788849230;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ITX6vbZ0p2MNUnqySgiQU1yaeBX1Pv0fohxsnS17XIE=;
	b=OHLLgcj9Zw2plh9LKvVYsF1vjrE+UhMR16LtCyNRjSpiGLPkWxXzrVfkjtbG6PAIaFnw+F
	LOh4p/rsiMYsoHdJ5IzIb6APawgxisTHJsvvWKz6RNxBAGX8RSaUVeXhn37AuwD8y8WMBN
	O/twROONuei6e6mIvnQpgkmWF55U6uk=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=rfwyK8rj;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=kmw243Q2;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf17.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788849230;
	b=dUAtOu07YfibKomSgrCdNJ5jGzQPhT32pHdElD4HVIDN9lmCQ5gRfv9xo0VN9JjCY093yP
	Sr8Xz+bxqsOhxTx9obTzJ80rfUNmeI38MTYkdZlOfFblXDCigT6kPZbbnQLaVzTZbOTHkt
	iN3DqB7z6Au8kDPgO6E8yGk6xA17adA=
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1788849228;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ITX6vbZ0p2MNUnqySgiQU1yaeBX1Pv0fohxsnS17XIE=;
	b=rfwyK8rjLPkePRrnJHe5/m9/qJsnrWMCt3iK+M7M5ZYc6dfObs52IIDnFx5QgND5xV+RSg
	DULbnxSrs1cNZLOgC5w74szhXRhwXueEKLWD5PiJIbFVmAO7uDHSPwLz9pK6DrIC85jwBv
	NptQJNDLTlAl0caYUrvufk5jk9bhHOty9MKSjt4bQXd4/hUZnyPvtRUw6CVU8HCzHPiKDf
	Qrx91oCLhunvM867s5Vs+oHAu9RifHTN2uGkz5Y7TRc6k2c42aM+pQ0MXz05XTOHWGO/tF
	rgfxs/zda+BfhYnlFo95QXEfk/RSRvCg32nIwzWZtUQue6L7jrsHr6BvZdL3SA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1788849228;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ITX6vbZ0p2MNUnqySgiQU1yaeBX1Pv0fohxsnS17XIE=;
	b=kmw243Q2lOefM6sErINOe0v2bdegFzSBOYOJ/mtefV8467qCIp/KHbzuaZEJV6LMACNvq/
	kbGYSfPlNIXmtvCA==
Date: Tue, 08 Sep 2026 08:33:36 +0200
Subject: [PATCH v5 02/24] x86/elf, um/x86/elf: Move relocation constants to
 UAPI
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260908-vdso-absolute-reloc-v5-2-3a93791af1cf@linutronix.de>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788849226; l=5793;
 i=thomas.weissschuh@linutronix.de; s=20240209; h=from:subject:message-id;
 bh=EP6eD/uZ0V4wHN9+/JxWHWsljJ+xT4xd0R266HOP2Mk=;
 b=9fiwRBRCJd/GEgS5mAJxYeP44dMtEzEA5a59lLmblClvso6Eb+4WwYMKSod5q7tvCst53OR2v
 u8IKRzDMhHhAzblZpImUk9ElKP8BMqVg+cBR+BubteVty4SyzNMiSs+
X-Developer-Key: i=thomas.weissschuh@linutronix.de; a=ed25519;
 pk=pfvxvpFUDJV2h2nY0FidLUml22uGLSjByFbM6aqQQws=
X-Stat-Signature: 3n4obcuwhjxmk4jnx56exfcen14f6rt4
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 7114840007
X-Rspam-User: 
X-HE-Tag: 1788849230-516176
X-HE-Meta: U2FsdGVkX18C043nXOyrxXeILjJvz4/bDL/SSN1gVIpbcf5nMi34ezmZTI+benUXYBQLaFQQtY4P7H9Z2mXiIkqcLPm5jXHAhuN4OuNq+X5tRBuL9VYsL3z+E4T6Z329lrlWjDgqUVwkf2kLu4PJ3mesWXCj0+EO+bbGmzbspcuj5M7nrMdMCxbegR957mnBLhkoncjHSVrvN1aPi23nDdex+a/Ve0gT1EDSj9uh03pZvKCU88gXETQtnA7tiCUDqhUVVqmyLjNVBW0xJJcarqUplnG8ihhwKM+sLK5XLrDN2ln38CFeph6UNn6EJobcaZQ6jpjn17IUR1D5LG7W+gYHeHVfuFyEae6Sqb3fAKikjjMu6y/15HCI4FAK2GCv3Q+TedScnoUJ7YadzvfOmzxdlQcruMxBd0B8dnpKye4wmcDDG23rSWcjdmcegvSp0CnAIrijQeCec6F5JS4iezJdNVvLUyUjzUQ8VWzQdtLS85VyS2GElnXi38QHk1MV7iqBfBiSo4/uurz5MQaqNlpgzwxOvX/NAA4t/uSzvexBMruqrD4yatctQBUgXm1ZwB/PggXj4MV5+CEVvDkOqYdprnqcIlNzR45kNlQdU2q+31hLCsL2yFZQjdd8i2KmjgtIF6YXYMlI+ommwzmrwTmeVWiV9AQN8P2yK/liKPjs6cH0p+e0ELbGBgKsZSZ4n4H4s7gEGqBLFgB2da8Kk1NIF7qf2ImNSP37Tqw4xgvJUDWAWLaeqn6SfW1voSltEIfyYA8XzvRhbZYUhSVm3yPGNK9XSYDCv7HTUc41KJlffj5zhsiMXsChqutIP6qdXZVGnxhqwBUbd0Oi7ItLsDFtNusSXZvqfPdQVPf28Es8smuH0quklOA/xSMu8Ql6TZy0KXB/8pnc3M6v5YUrYpxjtg4MBB5MhYDaZwuiEY+IOKxlkeXt+elCa2/2xqkHHuucuW4L7bfdTEAUxo5
 mq3+HMFe
 Yj9mz37Q9CXAwT4EyJ4SrHoAi83wOlvFsJHUsy9oCzfhY/4s77CPkkiCqaVSbJadxk37xUuKJ1hc/guAfj2HKgWun+HRrWKmWjNRw+40SoJ0M9HIozYC7RLdiBUg9bNRtgxlriL8iRRxtCEn7NlIfIOazqNtRlNQARXmsthZLmZCeYdtHPVGRcmp5Q0fWmF/w/ef/EdKw96faQ7sGJ/2eGjzUy7wTUTD4wv3Mv4UbLFp8rv6gMxbdkdL/J/owf+KGh6Yiecxeb4MugCckWnwJ8vdTttEXCxdmV0VwwmzcIccBRSvxwfMjo+5TGPoKF1Q+O5N3SX0jiKBq9Ym1kSr3WJ4ucjcIFmZXLwwZV0ZK05j5SZ2InLyepaoK0tbkgDqG09L3zXd7t7NBrMJsvwH8dQqhJnWn44jnwHOfYvPh4pkQlrmCO0OAU/LAC5zg/Aeq5AUjbLlmMb63YE3ja/0roK6qSp96KBmMK++5kQZDeWkmts6KOqiP0pHKeqNFScJ9h4r8fDu3rhsBwfLUd18d0CjDNSk3/ZlY4fLo1RveLMpPPW0=
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
 arch/x86/include/asm/elf.h | 33 ---------------------------------
 arch/x86/um/asm/elf.h      | 33 ---------------------------------
 include/uapi/linux/elf-r.h | 34 ++++++++++++++++++++++++++++++++++
 3 files changed, 34 insertions(+), 66 deletions(-)

diff --git a/arch/x86/include/asm/elf.h b/arch/x86/include/asm/elf.h
index 4133c790e71a..ad84c0f60459 100644
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
@@ -44,26 +31,6 @@ typedef struct user_i387_struct elf_fpregset_t;
 
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
  * These are used to set parameters in the core dumps.
  */
diff --git a/arch/x86/um/asm/elf.h b/arch/x86/um/asm/elf.h
index 22d0111b543b..b768497d5ee1 100644
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
@@ -72,26 +59,6 @@
 
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
index 2c382c8a4807..45a160ecf405 100644
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
2.55.0


