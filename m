Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED733C79FAD
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 06:34:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 32B2D6B009F; Tue,  8 Sep 2026 02:33:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 303696B00A0; Tue,  8 Sep 2026 02:33:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F13A6B00A1; Tue,  8 Sep 2026 02:33:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E42886B009F
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 02:33:55 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 742018039D
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 06:33:55 +0000 (UTC)
X-FDA: 85189629630.30.2DFFA3F
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf26.hostedemail.com (Postfix) with ESMTP id B32C1140007
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 06:33:53 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=ugOOuW9q;
	dkim=pass header.d=linutronix.de header.s=2020e header.b="An9/D7tx";
	spf=pass (imf26.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788849233;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Cp0o8EDFYqgaI/CEiEvUg/mXT7EeRnDPR+/NOomvS88=;
	b=6LyA2Pv+w3XzC6CkZPRE1Idv0MiKR3B5HScGmTbM3NQaMrQuT/W320R8EUtA65MkBnsiwv
	nr+fIj00g/xirBsFJ5ufZuwYhsYG9PjnuZfNj9pm+y/24qL9BFlDkbTCeoSrby1fqVg9nE
	FV3s+9cgeisHuiX0WaOJtoxCA46fzFY=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=ugOOuW9q;
	dkim=pass header.d=linutronix.de header.s=2020e header.b="An9/D7tx";
	spf=pass (imf26.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788849233;
	b=PrlQj//uVpxz6M4V5NxwuR9vS7WaA1TT6geGg9h3gDzvTb5aan7+VacGwmZRhBdq6fsMLA
	xItZbwxdjPDeVFWXslNFI2ojbnyPDyE+dveY66HZun0WxmZUGNjGYldwiTcmOuQpUWN/ZO
	MSSvzb+oDNJgcgxu9Fj7pYq0O9y9Gkg=
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1788849227;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Cp0o8EDFYqgaI/CEiEvUg/mXT7EeRnDPR+/NOomvS88=;
	b=ugOOuW9qKhAU3jefF5rh08PT3vrE2IXdbueWnqZqCpmyV5bvOudbWlrbHjpeje1u8xgjfv
	AKlGo1M9CxgVkcWML1tdQGO/+Yr8wRNl4W1A12PQz3BNS1oUOkekAz+Ae2u3Y3gaWX6IOs
	JtboaftOyUindIxACXrEnFvSVVXEFw0jfPd2Zaq9Wtkkl+YHzfskypxnguHiNVMOQLXuwJ
	ChiyKIktCY98YbQi6nKlJ+gVx5YgpcujMOZYC1T+Yw0xzGUGXsCB76CVtAr/DucEjwjQ3A
	sF3OFbYIbiqCePh0eg5o0M79ii6HYcWDmcoD0jLFasuMbIDQ6s/LvL3pagYykA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1788849227;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Cp0o8EDFYqgaI/CEiEvUg/mXT7EeRnDPR+/NOomvS88=;
	b=An9/D7tx9snxErbmaoktle4MclQvGq4BeA4eqME/OXmkgI1ozhe/GSz/tKB6Fu1fAZBtoW
	ktDVIIqBQgCerXCw==
Subject: [PATCH v5 00/24] vdso: Reject absolute relocations during build
Date: Tue, 08 Sep 2026 08:33:34 +0200
Message-Id: <20260908-vdso-absolute-reloc-v5-0-3a93791af1cf@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/23Ny2rDMBCF4VcJWldFGl3dVd+jZKHLuBEYK0iOS
 Al+9yiBklK0/A/MNzdSsSSs5ONwIwVbqimvPdTbgYSTW7+RptibAAPFJFjaYs3U+ZqXy4a04JI
 DdQAaJhG40Zz0y3PBOV2f6tex9ynVLZef55PGH+uvNw29ximjkzWOuTly5tXnktbLVvKaru8Ry
 cNs8McRbOxAdxTOIQgfpAc9csTL0ZyPHdEdaexkohHGSj9y5MuxHMaO7I7mznrNFSoM/5193+9
 FRYP1kgEAAA==
X-Change-ID: 20250428-vdso-absolute-reloc-a226293c1761
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788849226; l=5051;
 i=thomas.weissschuh@linutronix.de; s=20240209; h=from:subject:message-id;
 bh=HrYSsshejm3MdwopK0QyrP0YNb7baHfULTYkmKafnyk=;
 b=6vZ688HbgWJhdTRQDorQBzK+M44QpmiNq6teG+NERQLRF70axqHuYGFGpQXkaBAwsvu/byckc
 GVjxkQ/ryyNA0SOqbZDiyxRuUih42hmJ5lsZUQGQM/E4vA20m25CVaf
X-Developer-Key: i=thomas.weissschuh@linutronix.de; a=ed25519;
 pk=pfvxvpFUDJV2h2nY0FidLUml22uGLSjByFbM6aqQQws=
X-Stat-Signature: rmtpps3z6m96xtezzi73sffqyxdh9z8b
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B32C1140007
X-Rspam-User: 
X-HE-Tag: 1788849233-80494
X-HE-Meta: U2FsdGVkX1/v5u3SfdwW2kl3NjKQPsUdi/LI/KafYyEnyufPchXBXDbijL4aZdtGgpadwRE7+Ggpc7eDOiIzFZuK57FYqYCQUoZXIiOUtCEL9DeRDuchp33QsJl4f/VZasG7VeKAE5A2f3h+/66BAXqvhvHkhX/j+Z8QNr8ZniwOLH0fHcXXuclvVvePF7KpBfckv60KNFT2OygO/NmgOtmXfY64mskPEKKqxgtMZN4s7gP24AZ5Cfqe/zh8QkFAgmO5rT2qG2XvYz/zGcm4DSG+YTUZ/ZUmykKtKJ7eXfpy2sFhxV1qVX3N67UIRPXXu65+xkXPSPYpY9msPArR3zDkDUpgL9l48ZxVgWK77+Sdg+1/8pOjQdFHwF6iEnPDZWNXmEtmJQ4eE5EFal88Qfdkf+e9BJZgh4IdanHl3vqdkHDLzK07+7nmP9CvlC6BKZIXKra3tvNS7Fh1BCGNgWlWaqJAeRl+6WGLirNSfSPGZM3eMISIEvSr5BMlLIlobZi7ac8AibPeIp53mYwVqyhJhkisZqL/aEqlYxHUc7oERMSNDauH8uVrSn9/YubJE50Gk5JKStpUyQeWjkFLzwi/Rw/ZYH/KO2P+ALu8v1qdsqD3ev1bFtEJwb75IyYzd05/TtTUgdfdup2gXhL4i7rEesApRxfycklJjSGgdyZw49k/PXWxKrzO6FSkHKjmpWt57Zy0muqF3JVBKc9yEemA+PeS41sAdS7/u7XPSkLh1HC8VFeOuLtqdN6npczEmW6S6UhiQ1Mu8nMcV8sSZmWOf6KahmDQIDaoiaQnSxuzB4AN3VCdh+lBBPVAgzvNYG/LbwJtqgb+1c0aMhTtJG8Mv7YXT+8bw4Q7VE4Yo/Uzaih1m+FPuO9Q8WG0UgamfUfCxzgXk9eyrQvy2mGWLrgO/EgC6N6sGew8e/BZEnF6RkOYvFJ8JDzEV0m5J+ThA7LKh9WNdQoy9TC8AIj
 2hxUH3/H
 fqVs5TlQd38Y/leawIbnTwmCpN4cFIqKp3PEAiNNwHo/aVt9tSr+KtAgWXAqLbOfw3uVLBdKooL8Lw415UnOIQTwIvsAFmTAFuHJ0/RGarqAXl51OKmfVdNQAg7vpjNvrNO0Vd2DXnNe3uOGzt8miWHbY3qdtWLXtLykvadwt/46XCzctCy5FB8vNO/4JWGu7Dngw0CL6nxHCFLdzKBR2aWx7tDXrglIuKEwwJZwiMpZYk/+U+6JHqrgsBz9/q5ZzlxdJhMCXBuFtnALz0Kbg7uWl23UPB+6mgy+qUbRI68fydDfzZ8xoAuIKHVsUotLjurhpkhFg4tNJaCt+OaQ4Z+ws24V9Bd3aS02bIo0TP8zsmwbW6wfZenaE8HeLmgY7lv8Gw8h420W22pGIcABh97whql4PfjKpVH1G60MJBEJZEw7wm03Bw/bMMZON9zIQhMHeU7S+iD4DEctT9/itOcC6n54L+xoTeJOY+g/uvP50ISBCnwj5PH4vBy0TlgO8m+ppCoOK//q/POKLpQytHSXeqW2u7zqIS1GkD+55YjET+x7YQbOPkdDa5zoPZAT6YBsF
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
so make use of the kernels own UAPI headers instead.

Patches 13 onward contain the architecture specific changes,
interesting for the architecture maintaines.

Kbuild and Rust folks: This contains custom definitions of hostprog
bindgen and rust library commands.
These are currently only defined inside the subsystem directory.
Let me know if they should go into scripts/Makefile.host.

Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
---
Changes in v5:
- Rebase on v7.3-rc1
- s/HOSTRUSTLIB/HOSTRUSTC L/
- Pick up review tags.
- Also handle SPARC.
- Build 'vdsocheck' during the prepare phase.
- Drop now unnecessary riscv LTO preparation patches.
- Link to v4: https://lore.kernel.org/r/20250812-vdso-absolute-reloc-v4-0-61a8b615e5ec@linutronix.de

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
      sparc: elf: Move relocation constants to UAPI
      tools headers UAPI: Sync ELF headers with the kernel sources
      vdso: Add the vdsocheck tool
      x86/vdso: Enable the vdsocheck tool
      ARM: vdso: Enable the vdsocheck tool
      arm64: vdso: Enable the vdsocheck tool
      powerpc/elf: Add 32-bit REL16 relocation definitions
      powerpc/vdso: Enable the vdsocheck tool
      riscv: vdso: Enable the vdsocheck tool
      LoongArch: vDSO: Enable the vdsocheck tool
      s390/vdso: Enable the vdsocheck tool
      MIPS: ELF: Add more PC-relative relocation definitions
      MIPS: vdso: Enable the vdsocheck tool
      sparc: vdso: Enable the vdsocheck tool
      vDSO: Automatically enable VDSO_CHECK

 Makefile                                    |  19 +
 arch/arm/include/asm/elf.h                  |  24 -
 arch/arm/vdso/Makefile                      |   4 +-
 arch/arm64/include/asm/elf.h                |  55 ---
 arch/arm64/kernel/vdso/Makefile             |   4 +-
 arch/loongarch/include/asm/elf.h            | 130 -----
 arch/loongarch/vdso/Makefile                |   4 +-
 arch/mips/include/asm/elf.h                 |  55 ---
 arch/mips/vdso/Makefile                     |   8 +-
 arch/powerpc/include/uapi/asm/elf.h         | 201 --------
 arch/powerpc/kernel/vdso/Makefile           |   4 +-
 arch/riscv/include/uapi/asm/elf.h           |  66 ---
 arch/riscv/kernel/vdso/Makefile             |   4 +-
 arch/s390/include/asm/elf.h                 |  83 ----
 arch/s390/kernel/vdso/Makefile              |   4 +-
 arch/sparc/include/asm/elf_32.h             |  43 --
 arch/sparc/include/asm/elf_64.h             |  44 --
 arch/sparc/vdso/Makefile                    |   5 +-
 arch/x86/entry/vdso/common/Makefile.include |   2 +-
 arch/x86/include/asm/elf.h                  |  33 --
 arch/x86/um/asm/elf.h                       |  33 --
 include/uapi/linux/elf-r.h                  | 705 ++++++++++++++++++++++++++++
 include/uapi/linux/elf.h                    |   1 +
 lib/vdso/Kconfig                            |   7 +
 lib/vdso/Makefile                           |   2 +
 lib/vdso/Makefile.include                   |  14 +
 lib/vdso/check/.gitignore                   |   3 +
 lib/vdso/check/Makefile                     |  34 ++
 lib/vdso/check/elf.rs                       | 498 ++++++++++++++++++++
 lib/vdso/check/vdsocheck.rs                 | 299 ++++++++++++
 tools/include/uapi/linux/elf-em.h           |  71 +++
 tools/include/uapi/linux/elf-r.h            | 705 ++++++++++++++++++++++++++++
 tools/include/uapi/linux/elf.h              | 112 ++++-
 33 files changed, 2479 insertions(+), 797 deletions(-)
---
base-commit: 2f737a133fad3808f9993f704fb27fd7791a0a41
change-id: 20250428-vdso-absolute-reloc-a226293c1761

Best regards,
--  
Thomas Weißschuh <thomas.weissschuh@linutronix.de>


