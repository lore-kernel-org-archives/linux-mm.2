Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 167F8C87FCB
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 05:45:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D03A98E00D7; Tue, 12 Aug 2025 01:44:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C8CC18E00BE; Tue, 12 Aug 2025 01:44:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B2D518E00D7; Tue, 12 Aug 2025 01:44:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 95D658E00BE
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 01:44:52 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6ADB5B6CA4
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 05:44:52 +0000 (UTC)
X-FDA: 83767016424.02.FE5FB72
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf02.hostedemail.com (Postfix) with ESMTP id 812FC80008
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 05:44:50 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=bex0uDqI;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=sTzojLz1;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf02.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754977490; a=rsa-sha256;
	cv=none;
	b=0CvifPmY0iruUBmq0AbBbydvG2TAgcHVDWQD9o1YsdXAUNVHGvlidO/F5RjfR4XDINGpOJ
	wX/u5mmF8JDtVfvLsoslGDnf5O3oqxpxi/pGud9uTxdJGzYWhP4StpQiXJUI1iuWZ3JiLH
	SzrcQqkY1lOri/O5LE6OTfGWTeVSg6o=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=bex0uDqI;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=sTzojLz1;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf02.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754977490;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tKATP4n6UsYsKAR5HymmCjK/vOsSvbOqbAEjaPPKais=;
	b=EdnC201rX6Bt37HDFmV8Pi4J3ynVo+EtLHx2x70rAlV2Ox1HqhZ7wjt6fpt0QLx85XjHQy
	XculPZQltEeSqFuHdLgPQBx6d6WMQhMIa+76YuCthpHjNZ/DPyuFcWCLRpC/OlEeC0Rt5e
	sGk0FsugsmuA5cdlquKjcoj9swmgIBo=
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1754977479;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tKATP4n6UsYsKAR5HymmCjK/vOsSvbOqbAEjaPPKais=;
	b=bex0uDqIIRryXaAvloStzvTEg31Q/TslhPGGgsXrYUJQEuDPVSuExWDJoQ+QwFi7lf0yAO
	URQMEz948bdEqfzWNykOMmx0N0qCkowwyqQ/XW+cqX/t8XUfB3+thiAImpgwWl735nhTDn
	MbXfvG9BhcCGaVw0dqDJx0TWqkzSw7fSuY/OCQ2k788QYQQXlSx3+N/IAcdMnXX7UbQ5NP
	O71dXBXttz5NHvIyavgFoT4UKupvoxlm2Oj7aHwgXryEeW/GW1V3CPKqxcXs/yk7d2I4ko
	Y2pHKtHhDLJcybmOM+Tx+MB/82qgi/3jBA6CJHxpAXP6N5KKv8bnwkxc3G1m1Q==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1754977479;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tKATP4n6UsYsKAR5HymmCjK/vOsSvbOqbAEjaPPKais=;
	b=sTzojLz1t1ocNTNz0HXeQczJ+INJVdOcOb3Rd0Buek8cjuenSqzq6kFPLpRAnPaQ1RQoA4
	MvLiIPaAJKXQzDAA==
Date: Tue, 12 Aug 2025 07:44:30 +0200
Subject: [PATCH v4 17/24] riscv: vdso: Deduplicate CFLAGS_REMOVE_*
 variables
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20250812-vdso-absolute-reloc-v4-17-61a8b615e5ec@linutronix.de>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1754977469; l=1337;
 i=thomas.weissschuh@linutronix.de; s=20240209; h=from:subject:message-id;
 bh=n7rZyBbT5pbmt5M5GrSidThNFcSgij4efiSpxxemwhg=;
 b=0JIHJbt9zi6gUHgjcuSIwo+4izQMegBN32Ik6FgPfMJGJcayTSsoHfu7UHm/d6C4nSaS3Btnn
 B/WNe5Tn1umCM3sBScvC+evhAbZ739AK6c1oCCk0CX0mwimaIdz7FBr
X-Developer-Key: i=thomas.weissschuh@linutronix.de; a=ed25519;
 pk=pfvxvpFUDJV2h2nY0FidLUml22uGLSjByFbM6aqQQws=
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 812FC80008
X-Stat-Signature: hqft1x3gkpmwypygwoxrchpmmqcwsm11
X-HE-Tag: 1754977490-458361
X-HE-Meta: U2FsdGVkX18C5pQUjHzT+c3+RCdBEz43U7TzG9aFEFENIcdcWkXwp4nHxkb7w64983umzuTI9mAIKbN6I5tqvaTPr+uz3r07X2t5KODiD0ifXIZ2cHtsyz/Sz1OI/tPPVPdph22sqQZ+GobSqCuPgF0J6NzN/2VId4nCoYUgGmdrqxlz7ruxg4R2+kW1mDXhdaGWe2TKfcZcnzQPEtdvng24HY04N3wkY9h3yiYnZfdoW5J9YHLQjkJQOZ9CwROdnHI4RDQ0JdnYqo5FJcsqUoXsaEnaBJLb5MbxrxaDjNCOJf6eaHp6IqxGG+VH0e8Mk2WBSaZKpqjWOOy/XX0N3Hi3BzkhvaydUyOuowGj4IZOwLf+0abD2g365bOYkMD/CaCzOEN39hZ3HAC6WAWqFKLsc/Sch2nrAwEDLu4c+CNCzEKsWH1frVY3xyrXxsug82AFwkvaOsgpC9j/1r0kLq1ylKmLtIlde+skh1TNVz5d8PaS7illsqDczDEGaWvSmUWaV3r8VHQ/Ef4aGcFcVCG20OIXvBg6c0D1ynbjrJ4+jFjTPpSUbNasRiSSZn0q2/z9zAMsWfnhr7ACYYESgvrF1yJLd6zlCwDTG0mAhJrJgK/HoccSqLm2ISurF9my9kKQ+xdPK2V+GHy1thBMRlEeaNYfGJzO4mhPzh4idn9pr52vCEZCBubRwUnUbhWsEXLnnjdNHRJ9MZOh3ztjoe2k0HSMTA9EgsIbwj6nSYDg+whogV0R5RB/d0sylXGAAWpy3MAm4cPzqG58njjyB3RLQSe7T/uxwrsARQXQnvCnINGPA58h1zXQ19M2WRKu2z9MY8TfxAJNpivPvAl+PYCHDILXzBIlHSVrPVDdVVcf0vO7/+qC4QXD6Td8Mdwn9LRfHQJTWnx3SfvWPR5wwkmvFXumsz8b3zG44G4lxMBFSLv8Hf7WJUVza+86mGuPwdbA7HrQaa9b39Qf8bw
 ezmgO/ZF
 BqzpSPjG1uD07zQk5pMwhZybrrVonqtjyyUzo0C/cwiNAfHnzs+nkOozGklQp/jBoDpnpC5MAglDno9ehCqC/W5jld7S1ayPg5ha56TpEAw+l2I8WxgrD1SnyVZvDqBFcNu8SKmupCqa3hfVuqIptzZG70QaQ90R5EEtrR5XS5xu8rYP3KucR3F/1afWQCKqWO9pfS0CMxeQqGc1lW+alUz/J/bLT0REL6bWqfHTfmkxQn8sErgMh8gp4PK3bj1Zui4x1oJhD5maNqPdSTb8sXaiNylwespRdtSrM858k25Vh3ukR5qBsjrRtrwWyTMIsqP9XJ3qU/tmieVL1U2wiIDc+4iBGgMS1Ec3hV5131wSt9cpJyr4MoGd6sTfJWFfIwVrSKlQzGrTskPKBsdlkiflfTQsLiPPXG/gb/VpvywsiySl/sD18Iuup2rfHozFveifqA/PpL6z/+4mNMAvxlbtRfyt4VUrUHCFIClmhwED9bpOFSnpjGSk4c1eqnERlkzruByXmRF4fncAMnaLZThrC55hdQEevxP/Abhzk4J3BRBlKc7WxxoiLGoJF+yaYbjqnV2RAhP8WFA7YkKRVLB9AsR1LkJhdhDvH/yxloQyBCYzta0fr90/Cn1GHFq+1sHloQLGQJfi39l3TQa4XpNP+SckZJH7oJySZ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

All vDSO objects need the same treatment.
To make changes to both the list of objects and the list of removed flags
easier, introduce a helper variable.

Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Tested-by: Jan Stancek <jstancek@redhat.com>
---
 arch/riscv/kernel/vdso/Makefile | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/riscv/kernel/vdso/Makefile b/arch/riscv/kernel/vdso/Makefile
index 9ebb5e590f93a3228c451dca58e6d5cfbbc03ff7..c19c3c76f7c9f6b2f7523a59269de3b683656323 100644
--- a/arch/riscv/kernel/vdso/Makefile
+++ b/arch/riscv/kernel/vdso/Makefile
@@ -49,9 +49,10 @@ CPPFLAGS_vdso.lds += -DHAS_VGETTIMEOFDAY
 endif
 
 # Disable -pg to prevent insert call site
-CFLAGS_REMOVE_vgettimeofday.o = $(CC_FLAGS_FTRACE) $(CC_FLAGS_SCS)
-CFLAGS_REMOVE_getrandom.o = $(CC_FLAGS_FTRACE) $(CC_FLAGS_SCS)
-CFLAGS_REMOVE_hwprobe.o = $(CC_FLAGS_FTRACE) $(CC_FLAGS_SCS)
+CFLAGS_REMOVE_VDSO = $(CC_FLAGS_FTRACE) $(CC_FLAGS_SCS)
+CFLAGS_REMOVE_vgettimeofday.o = $(CFLAGS_REMOVE_VDSO)
+CFLAGS_REMOVE_getrandom.o = $(CFLAGS_REMOVE_VDSO)
+CFLAGS_REMOVE_hwprobe.o = $(CFLAGS_REMOVE_VDSO)
 
 # Force dependency
 $(obj)/vdso.o: $(obj)/vdso.so

-- 
2.50.1


