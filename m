Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D852606A32E
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 13:51:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.a=rsa-sha256 header.s=2020 header.b=dhUms7oH;
	dkim=pass header.d=linutronix.de header.i=@linutronix.de header.a=ed25519-sha256 header.s=2020e header.b=SZJ7c1JZ
Received: by kanga.kvack.org (Postfix)
	id 647396B05B5; Mon, 23 Nov 2026 08:51:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A73D6B05B6; Mon, 23 Nov 2026 08:51:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 472376B05B8; Mon, 23 Nov 2026 08:51:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1114B6B05B5
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 08:51:24 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 052B11408AC
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 13:51:21 +0000 (UTC)
X-FDA: 85466520804.12.CE00E55
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf13.hostedemail.com (Postfix) with ESMTP id 2861620004
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 13:51:20 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=dhUms7oH;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=SZJ7c1JZ;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf13.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795441880;
	b=kxO86Uvv7f1OiQ6+e1Pt3LPlMIkNvfLalYhEDou1h8s9dsb3XVip+8zz5ZHol+FdTcSJbo
	Dx/FIHqgRmQZAbi9+oPyit+SmABiZJaMzrrXCeCURSV+XxTs3s+D0rI8ueHVXpvB6zOBHA
	AnEnWw2noILGLboZI/dgyh5IgjfmfKQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795441880;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=eDaWEGVSberGT3lup7BUtg92+nPcoIl/POEYu2Hk/qs=;
	b=7DoBuRnztYg3Eqf4To7XKyLPQd87KalZrtPDfPULvqCemql084aUdlzzpTMIWJgrZQLRHl
	u3rKwCi32AjDKIlFsFBwq7u1UI6TzQ7BY9KR9rXtj1TVe2exd5YsEuNygXUQagK+39tS8z
	DOOptSUuTC4Nez6JImZo7qjR6tgNLoE=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=dhUms7oH;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=SZJ7c1JZ;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf13.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1795441877;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=eDaWEGVSberGT3lup7BUtg92+nPcoIl/POEYu2Hk/qs=;
	b=dhUms7oHgMAyTwjaFQ4RcmHZy3AcRiYZGHrtxzyko2OKJq9ppnxdmoYRgjmCHmDl72nUPK
	L/7fYN96Dq/EWTGaIbc6mSLcy31gm1eTfI4kwupFpFPjC112yyZkM8ESt8bMlcCF8FmAER
	KmEK8t92o7JvwtqkOPsvSFKiP0dHe4+qaQz5h0vFdUIKKWIuL0I9ZQNNlUKxBIx2c7YsVt
	9wFwFcCd8I9ee05oaCZWhsyhqcXGDWdhcn0TprHoLVGNWll7eYv0kGf1d15Xde8wEa17I2
	nVKIeHL9cL2tRun1gCxK7pNUw/9eoEPay1jdaqJRmlkyRrC7OYH3x68J6Bc0fg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1795441877;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=eDaWEGVSberGT3lup7BUtg92+nPcoIl/POEYu2Hk/qs=;
	b=SZJ7c1JZEJleqouSHibtjvawagbQZiztXnKad+RaVrzqS2CEbt3LfVh0aVKUf8rCz1vARk
	veQbOsz5bF+5U/DA==
Subject: [PATCH v6 00/11] vdso: Reject absolute relocations during build
Date: Mon, 23 Nov 2026 14:50:51 +0100
Message-Id: <20261123-vdso-absolute-reloc-v6-0-161e218dd217@linutronix.de>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/23QzWoDIRDA8VcJnmtx/LanvkfJQd3ZRljWohtJC
 PvuNYGQUjz+B+Y3MDdSsSSs5ONwIwVbqimvPfTbgcSTX7+Rpqk34YwrJrmlbaqZ+lDzct6QFlx
 ypJ5zzZ2IYDSQvvlTcE6Xh/p17H1Kdcvl+jjS4D59em7oNaCMOms88/MELKjPJa3nreQ1Xd4nJ
 Hez8T+OYGOHd0fhHKMIUQauR454ORpg7IjuSGOdmYwwVoaRI1+OBT52ZHc0eBs0KFQYR456Opo
 5Nv53U90R3gnjwM8Q5//Ovu+/Goaqs9oBAAA=
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
 Peter Zijlstra <peterz@infradead.org>, 
 =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795441872; l=3723;
 i=thomas.weissschuh@linutronix.de; s=20240209; h=from:subject:message-id;
 bh=838wXNltovAdYq5DnbIAatCSo/HDl9G1xi3tlTew/l4=;
 b=JGW/t5g7XakafXkEmZgN47zuaZVRMd5P5Z1iLiNybaoBHrfSDWqN9ASPR8Bxcs9mW00guv58q
 XTXxW/DfNA2DS7eGKT7s34DDNPA2BkV8xQIeN4+3mlNlEP2jFFXWeWs
X-Developer-Key: i=thomas.weissschuh@linutronix.de; a=ed25519;
 pk=pfvxvpFUDJV2h2nY0FidLUml22uGLSjByFbM6aqQQws=
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 2861620004
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=unavailable autolearn_force=no version=4.0.1
X-Stat-Signature: xn3of9a3fw9ojqzdgxsufaez9fpr93yt
X-Rspam-User:
X-HE-Tag: 1795441880-216732
X-HE-Meta: U2FsdGVkX18enQoOh9J020CCUWOnWsfTu3wvj2b2a8z4kmEoYYZ+ve/Ze7lJmqXkNAKpzRuWDN/gou1p4jj1T8CYmmubVaRoXMY8Bje/TR8uzzFHCQtfWgQnzMqKGgqq/EcwPwmqb3nPdpe4z1W3Gt7JZ0Re1kSyQrimJDw5c3K7sC6bZpOf8nuzYm+WmtJcbs0t3sfb/Y6xPPF3Myl1zufbeVJux43J1Aq5AQYd4Z5UQbaLLwNUWGY3uy8zXgZVPZh6qhT5/P+FI1CdfF7DjhHIaEJFGB47wSdJP17lzOjUgBKhWppycJMNiw4suQ0fXHQIzeUvw2t/FQ90imQaXr4O5VG2JxhKk4hM8ltjvHq+MmL4XLmnjuhKN4GmpGEpQSigrKYx081KIUuQyZQm0qK8BMMDlYA1kPcGYHN71jwxtj+lfMvpBRqX4H/Z4mlD84vrTlQqgvJX1ExHXCeaK+eMD2ovOqIvQY/55VcUH2qJlNRShG1lfJcvlWJdSjN6dHm9bkyh5zVdqwvW7o8Wuu0VXzme1swyP2JbAtUQ6t2yQWS7B+W3eF3KCJfpAKpXIrHLH/LvqbexhABfTKQQDDRvYmkNaTZglDiMD1cgaO+7tOH26gvz6kX6PEYkqx2YzXbAtptibXtZNKb1KEPNlGN2v9jIJ8+OkNFmh4YkKWJbla/ROn/c6e0PCXbCcvJrNj5bmb2hGRYI7m52w5rWYpS/oWgX1V7yR8io6m+zTa0BwvpvYrB+dOhle8LIkJMokLXVls3taoDe5Lg2kU5DfemSTUzSmJoGqPV1xrCW1hAx1Wdl8TwOJR+fQ0XEV3KvLUwi1QCe1faYVleSMD9yNnn/PKSmVBAtTqzT8akgdIdkefqhVeICBe1drk02/QRIfuTcrEK5GuyxmSi6xT8Ktdu8IJZIqY98BnufIcaGdC0fo8I/KqjD2vpsovIEBj2BMdc9juLM21ffRybTr1I
 8x5K0Ue7
 38gfmhCMK0zRvdgDus9JyUXBbdRIs0qVEpMKgFN50iOvgqVThEgLuc27bFnQd+lpOMsh52nOyGROxl1x3tRmL7JG9Qmj+xswCDWGZXesI6QC6d7edymYsxco0xYkHYVrlpk8FKBc1b1tkZHC6onm/1Di7QHh3DlZBkN3WxjBg6h4M/7F2gUBatPBiMFwj7N80KgyBqcnYBqycM15LfAf7tigk82zcp5PPrqKa1BVi0VUiazPM/Q5VdnpbBFLpGFT8QAgTA3duwdUFOsNCK5N+wCnUPBIAkBwon08wRkNBTw9T0E2sximcC3rot4ffTp6mGEWpFS9KvRxxNEWS590NaZBTXNyHdK4o4Y2hxYmVdwEWQv2Sldzv4dVqbBLSW4l4NyuoK1DGQC9kH/nxHZwyn6t/sb7stuFGPmz+uvKDpstcnq23q5MUcsYlmyY+Iqi12j6jDk1KNbST56SIVE8V9MYqhmM19nNuREMNO8rT/NzEui8GV/z38C0mGdkngBpoXYGOp+O+fmtCwF/Tf3cXesc9D0p0ye0spFdmfqGhiF6oX8+QwLz2WQF63j6MPwoExq4AtqoxAJqQghMd0kXc6yql/l2FSNti2EFjPSHN0zV/I+aHzZ/MLySr4Jf3lImg3M1q8b6YX0RS4fQTWCVyvezeFG+/R55nHfO1316N65tcPN1+liMajVIW1Dc2HGAUfvdoV3C4VO+KEjjYS5Yy5CAHsgCt9OxRygmiYK2eibzQqZEbV6n260A+8Rea9pj+f6EZYFQwS/kp2oJUCI99YeFVOCCZ59teCAFQAyAOge8kx+5i5NcVX3alOdBhv7pks+J7l3IgJUVadlqo8yjFChNP47VQIRzz7Skwn7Mg2lAJwSBdJBXISdxOwDPeC9xKYkDw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The compiler can emit absolute relocations in vDSO code,
which are invalid in vDSO code.
Detect them at compile-time.

The tool is written in Rust. However this does *not* introduce a Rust
dependency for kernel builds with CONFIG_RUST=n. If no Rust toolchain is
available, the new comprehensive check is skipped automatically.

libc elf.h is missing some of the relocation constants,
so hardcode the magic numbers instead.

Kbuild and Rust folks: This contains custom definitions of hostprog
bindgen and rust library commands.
These are currently only defined inside the subsystem directory.
Let me know if they should go into scripts/Makefile.host.

Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
---
Changes in v6:
- Drop all UAPI header changes, hardcode relocation numbers instead.
- Add note about Rust *non*-dependency to cover letter.
- Link to v5: https://patch.msgid.link/20260908-vdso-absolute-reloc-v5-0-3a93791af1cf@linutronix.de

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
Thomas Weißschuh (11):
      vdso: Add the vdsocheck tool
      x86/vdso: Enable the vdsocheck tool
      ARM: vdso: Enable the vdsocheck tool
      arm64: vdso: Enable the vdsocheck tool
      powerpc/vdso: Enable the vdsocheck tool
      riscv: vdso: Enable the vdsocheck tool
      LoongArch: vDSO: Enable the vdsocheck tool
      s390/vdso: Enable the vdsocheck tool
      MIPS: vdso: Enable the vdsocheck tool
      sparc: vdso: Enable the vdsocheck tool
      vDSO: Automatically enable VDSO_CHECK

 Makefile                                    |  19 ++
 arch/arm/vdso/Makefile                      |   4 +-
 arch/arm64/kernel/vdso/Makefile             |   4 +-
 arch/loongarch/vdso/Makefile                |   4 +-
 arch/mips/vdso/Makefile                     |   8 +-
 arch/powerpc/kernel/vdso/Makefile           |   4 +-
 arch/riscv/kernel/vdso/Makefile             |   4 +-
 arch/s390/kernel/vdso/Makefile              |   4 +-
 arch/sparc/vdso/Makefile                    |   5 +-
 arch/x86/entry/vdso/common/Makefile.include |   2 +-
 lib/vdso/Kconfig                            |   7 +
 lib/vdso/Makefile                           |   2 +
 lib/vdso/Makefile.include                   |  14 +
 lib/vdso/check/.gitignore                   |   3 +
 lib/vdso/check/Makefile                     |  34 ++
 lib/vdso/check/elf.rs                       | 498 ++++++++++++++++++++++++++++
 lib/vdso/check/vdsocheck.rs                 | 299 +++++++++++++++++
 17 files changed, 896 insertions(+), 19 deletions(-)
---
base-commit: 0e2fcd5208a4bbe53419a0e4359df3a614135649
change-id: 20250428-vdso-absolute-reloc-a226293c1761

Best regards,
--  
Thomas Weißschuh <thomas.weissschuh@linutronix.de>


