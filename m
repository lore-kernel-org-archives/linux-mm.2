Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FF68CA0EDB
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 05:44:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D2E28E00C6; Tue, 12 Aug 2025 01:44:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 698698E00C8; Tue, 12 Aug 2025 01:44:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 44DF48E00C6; Tue, 12 Aug 2025 01:44:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1B5A48E00BE
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 01:44:35 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C08D011551D
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 05:44:34 +0000 (UTC)
X-FDA: 83767015668.16.C21EFDB
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf01.hostedemail.com (Postfix) with ESMTP id E05F040005
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 05:44:32 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b="s12TFd7/";
	dkim=pass header.d=linutronix.de header.s=2020e header.b=1xZIjm9+;
	spf=pass (imf01.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754977473;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=we+MV6CKFDKB3+12vM9P1VJPX4SvAjkcslQ93yTTcGw=;
	b=fIA/I1smTVBlc3yigdS/8l2A8U8P4q3hkveeHOs2T3Psgo120I6wPab6+rHzB8yc3KdfIu
	v8NshWlDntjliGCKt0bmt+N1LHTBCl7shu8FfTa0JqME5F7r8oJbVyQx3VDEdILhSbd15F
	RCXAv6/HBU1bClt2an12Ynwzf2pXKJA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754977473; a=rsa-sha256;
	cv=none;
	b=4jraCcwKwm4NB/MUGew5V0sWTXnfWkzoDZA7JCwi4iZ27wnLwWyvrlHZ7SEZvQGk9UMunK
	+K7bVhyKWrVmhdKzht2XF3fTTAcv7C1VyMvI1tuHzLVpVi928eiexKJdGqlHN09bwdU5uT
	+kFZ9CnZd1PbpLQ5TSATsR88u9TdoUs=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b="s12TFd7/";
	dkim=pass header.d=linutronix.de header.s=2020e header.b=1xZIjm9+;
	spf=pass (imf01.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1754977470;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=we+MV6CKFDKB3+12vM9P1VJPX4SvAjkcslQ93yTTcGw=;
	b=s12TFd7/GLX46A/G/+ECg+vpcMIUu0jowZ+SXwxJhxDEsbG2Hk35x8v41vFM9k2Z6++tsZ
	wOtHuHp8ijmTygwaNTx5/PxJl0C+PgVmopiqAYeFmyp93fiK/W5LuEbOsh3IyEHTsumXei
	i6tmk/KqRX9b+fFm1uMDLY5pyDp5iNUz+97nooXxtzabAVuLTdOGAwSvyTWcI7khghsSLE
	bdXXXK8T2K95P4cnyN2lV0/O0LrMoPZgp2MK6ZFO1mlvjPQFPMcdSkak5L9lDmVY5EFNW5
	a/A3FtNlNwOAu9xQb3LgvY1NyNxolVCEeOfvRv+8gK4bJAO7/0Oi4JyTYshi3A==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1754977470;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=we+MV6CKFDKB3+12vM9P1VJPX4SvAjkcslQ93yTTcGw=;
	b=1xZIjm9+RbXypIoRNrLytkIGg05FC3Q9oFSLlRkVe8Czn4YJK0dWQqTugq0BBK8RrgRbhf
	1YCXBpgKwYxPOoBg==
Subject: [PATCH v4 00/24] vdso: Reject absolute relocations during build
Date: Tue, 12 Aug 2025 07:44:13 +0200
Message-Id: <20250812-vdso-absolute-reloc-v4-0-61a8b615e5ec@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-B4-Tracking: v=1; b=H4sIAK3UmmgC/23NTQrCMBCG4auUrI0kk7RpXXkPcZGfqQ2URpI2K
 NK7GwVRpMv3g3nmQRJGj4kcqgeJmH3yYSohdxWxg54uSL0rTYBBzSS0NLsUqDYpjMuMNOIYLNU
 ADXTCctVwUi6vEXt/e6unc+nBpznE+/tJ5q/143WbXuaU0a5VmunecWbq4+inZY5h8re9Q/IyM
 /w4gm07UJwae2uFsdJAs+WIr9Nwvu2I4kjVdsopoVpp/p11XZ/4YfWZSgEAAA==
X-Change-ID: 20250428-vdso-absolute-reloc-a226293c1761
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1754977469; l=4542;
 i=thomas.weissschuh@linutronix.de; s=20240209; h=from:subject:message-id;
 bh=sDpXnmBm5KPtwZhOpphGdEN7DYn98pmvrlCD54kPOyk=;
 b=F8W0Goo6R91Iz0mLdbkaVEXEi6NqkHjpz8K4uOJrCpNewCuaYX7400FmNfqyauYk9G9vfxPln
 QO8tldIHen+Dtqsaw7111LfaE5FavUHmtVgedZWUvqMPyN9fiN2z4ak
X-Developer-Key: i=thomas.weissschuh@linutronix.de; a=ed25519;
 pk=pfvxvpFUDJV2h2nY0FidLUml22uGLSjByFbM6aqQQws=
X-Rspamd-Queue-Id: E05F040005
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: 3cbj8ru151oobuputqq58i4stq4t9o8f
X-HE-Tag: 1754977472-47931
X-HE-Meta: U2FsdGVkX19jeu0L4/WnHpwzkKc16hs3heQz5hfswS83W3CLOQe2duhrR8KWKczYfNMkCGwAB4a4efrpPmMTKxEaHGrzpIZPzPXFFNUF+GOqASkuykUlsYifDA+sFOa98C4L1q/zv+oWoTyJ/2S6W0rJ5rdXgiO2LlYRESrxT4GkZpAI3wWrUw0v1pfF7h1oZhjwn5Rc7KPnCBsgdxQBJ0aUy+WCkbZ4PB42+7gB8Sjgtjum8ex8k/m0g24Plnj0gYWDN118ML2QWtqkTPtzLsOksabdcEthwCWPmuzRGm6LevyLqz4x/vUfLfxWkEBDZpsQ0NBuP4707SQXOUhJmnvIZ3ILyqj9kJ1QfS0S868Aowj4gGewxlmAYrbq/Wi/A6wlTTD8ov0cXGasBhaknxi9QHqG2zwc8yfjIOHQLwx2uikMgO8BGbQVGeEWbqcaHJ1Kg3HWllNbuBrhETWrfDcjfCQm3ll2wZUhDRcLj1+kkIhu9jjktCmQVjR8fCTqIWWcCoaS1z2JKmh6FQKeP5DKPUKSaYI9Jj7epIQzLUlZl7IdhpByRnxIzee4tWLnRsJHlg9SO9N4XmPiBrZbJBohduifWoMqVy/aQhv+Yrk616XhOauNCARzleNYbAOZYG27C7MGDJlt2XzY0NFg17C84LaSC048tqo996nuuFPE7Ja0MyPSiN4I7LTYNoTHwmXP1ormtN74hkUD1oElS/7wENchB/a5m02sb1jsXO2g/n+CZgy5yPznYC4SieJ8ETIvGcqNtTITXQO7OOdtO9BtKY0kExcjE3TBtCOyGo0IRNBXfZjint0Ot2Z16EPF5a3TSJNN+L5NPqcaeNXIHQ6g/iofpxJM66WjDVu1A/zSN94Rpdy8n9Hgd6y2TY2I+l69ttGEWns0s76NPUINc3mXT+gVL4VNM1WAOETLlD8+bhrQ9q8SEW/aTveUOLawB0SkBbBRS2BF8Hqn6Pk
 WV35Hegy
 DyIS5MbEECRjr8nhXhagOuw2hkRG6EDvpLuDLqxZJv1wdDcyf9R+ey9oYGceBIUM3xc6A8fKRDZzt/ntGcoST0CJpkReZdal5PqnKzlgsgSnIgeb8Ah7Pje2ov6W1z6R31pA6M8S8mRw4ZEg9x0gUDfyuZo8PRCxssk/BuiQuShFbJnQlbflu6xeBJ398eknJCBP0szBxfAv0iUoGYDIaEd63vKKxv/gZi1v47aflDk+2dt8ijeFDCfzDfkbIXSRD12zZeEnvx7xQIotTMobtsPS1SCAeiGDfAb0bBUUaHhedvqynQbKjY9Oqpc2PZk00HbUb5VDIUHIOhq1DWuHvcEk8ZsM9R4AgZuzm4aF+hzhWHAY78Vb8Mn19Z5Z+WI/+iHws5bC5ts1+VMMHNpfBf6yXzAzqY720o5pYshyD4mphBj3QkbtzyN/BPAV3m7kwquEUbi3iBw/Ia8h9OLG+2ExKVQSnQIrAta9Z18r9mdNXAOVNOwXBThl/hCnGBvOioN4FQbg6rICMGCiN4NuouFR/21vwE5wSZ4S5
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The compiler can emit absolute relocations in vDSO code,
which are invalid in vDSO code.
Detect them at compile-time.

libc elf.h is missing some of the relocation constants,
so make user of the kernels own UAPI headers instead.

Kbuild and Rust folks: This contains custom definitions of hostprog
bindgen and rust library commands.
These are currently only defined inside the subsystem directory.
Let me know if they should go into scripts/Makefile.host.

This will conflict with my SPARC64 generic vDSO patches [0].
If both end up being applied at the same time, please leave out commit 
'vdso/vdsocheck: Drop the transitional kconfig option' from this series.

[0] https://lore.kernel.org/lkml/20250724-vdso-sparc64-generic-2-v1-0-e376a3bd24d1@linutronix.de/

Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
---
Changes in v4:
- Replace the inline shell logic with a dedicated build-time tool
- Link to v3: https://lore.kernel.org/r/20250611-vdso-absolute-reloc-v3-0-47897d73784b@linutronix.de

Changes in v3:
- Drop already applied bugfix for arm64
- Disable LTO for the riscv vDSO, as it is incompatible
- Link to v2: https://lore.kernel.org/r/20250430-vdso-absolute-reloc-v2-0-5efcc3bc4b26@linutronix.de

Changes in v2:
- Link to openend (invalid) GCC bug containing more explanations
- Refine commit messages
- Don't fail on commit absolute relocations in debug info
- Link to v1: https://lore.kernel.org/r/20250429-vdso-absolute-reloc-v1-0-987a0afd10b5@linutronix.de

---
Thomas Weißschuh (24):
      elf, uapi: Add a header for relocation constants
      x86/elf, um/x86/elf: Move relocation constants to UAPI
      ARM: elf: Move relocation constants to UAPI
      arm64: elf: Move relocation constants to UAPI
      powerpc/elf: Move relocation constants to UAPI
      riscv: elf: Move relocation constants to UAPI
      LoongArch: Move relocation constants to UAPI
      s390/elf: Move relocation constants to UAPI
      MIPS: ELF: Move relocation constants to UAPI
      tools headers UAPI: Sync ELF headers with the kernel sources
      vdso: Add the vdsocheck tool
      x86/vdso: Enable the vdsocheck tool
      ARM: vdso: Enable the vdsocheck tool
      arm64: vdso: Enable the vdsocheck tool
      powerpc/elf: Add 32-bit REL16 relocation definitions
      powerpc/vdso: Enable the vdsocheck tool
      riscv: vdso: Deduplicate CFLAGS_REMOVE_* variables
      riscv: vdso: Disable LTO for the vDSO
      riscv: vdso: Enable the vdsocheck tool
      LoongArch: vDSO: Enable the vdsocheck tool
      s390/vdso: Enable the vdsocheck tool
      MIPS: ELF: Add more PC-relative relocation definitions
      MIPS: vdso: Enable the vdsocheck tool
      vdso/vdsocheck: Drop the transitional kconfig option

 arch/arm/include/asm/elf.h          |  24 --
 arch/arm/vdso/Makefile              |   4 +-
 arch/arm64/include/asm/elf.h        |  55 ----
 arch/arm64/kernel/vdso/Makefile     |   4 +-
 arch/loongarch/include/asm/elf.h    | 100 ------
 arch/loongarch/vdso/Makefile        |   4 +-
 arch/mips/include/asm/elf.h         |  53 ---
 arch/mips/vdso/Makefile             |   8 +-
 arch/powerpc/include/uapi/asm/elf.h | 201 ------------
 arch/powerpc/kernel/vdso/Makefile   |   4 +-
 arch/riscv/include/uapi/asm/elf.h   |  66 ----
 arch/riscv/kernel/vdso/Makefile     |  11 +-
 arch/s390/include/asm/elf.h         |  83 -----
 arch/s390/kernel/vdso32/Makefile    |   4 +-
 arch/s390/kernel/vdso64/Makefile    |   4 +-
 arch/x86/entry/vdso/Makefile        |   6 +-
 arch/x86/include/asm/elf.h          |  34 --
 arch/x86/um/asm/elf.h               |  33 --
 include/uapi/linux/elf-r.h          | 631 ++++++++++++++++++++++++++++++++++++
 include/uapi/linux/elf.h            |   1 +
 lib/vdso/Makefile                   |   2 +
 lib/vdso/Makefile.include           |  17 +
 lib/vdso/check/.gitignore           |   3 +
 lib/vdso/check/Makefile             |  28 ++
 lib/vdso/check/elf.rs               | 488 ++++++++++++++++++++++++++++
 lib/vdso/check/vdsocheck.rs         | 279 ++++++++++++++++
 tools/include/uapi/linux/elf-em.h   |  71 ++++
 tools/include/uapi/linux/elf-r.h    | 631 ++++++++++++++++++++++++++++++++++++
 tools/include/uapi/linux/elf.h      | 112 ++++++-
 29 files changed, 2277 insertions(+), 684 deletions(-)
---
base-commit: 5180c6526acc9f1cb58f8b11fba67583c22e0854
change-id: 20250428-vdso-absolute-reloc-a226293c1761

Best regards,
-- 
Thomas Weißschuh <thomas.weissschuh@linutronix.de>


