Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7EB5EC79FA0
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 06:34:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC4E66B00A6; Tue,  8 Sep 2026 02:34:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E9C0D6B00A7; Tue,  8 Sep 2026 02:34:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D63C96B00A9; Tue,  8 Sep 2026 02:34:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B39506B00A6
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 02:34:00 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 48C3980399
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 06:34:00 +0000 (UTC)
X-FDA: 85189629840.24.149ADDA
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf28.hostedemail.com (Postfix) with ESMTP id 9A505C0002
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 06:33:58 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=b2Bsc4yZ;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=x7vG3QWi;
	spf=pass (imf28.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788849238;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JkLB6p5Aaygn3v1gYuxHR1a4yxVdgYLi/cxda/p+uN8=;
	b=jtn3OvIrxG69X0ypDVZNIviCr/1wPFFGXesr0xZf1BCNdTeDhtDdXoNfAYXF1ifjSZTycn
	NBqo3HeWpMmtg2EkxjTv2j1OLD+fKAR8SZloE3SVDEE0MqQzo7JUULfsjJMJPg4+vOX6Za
	e24fM2dVadViuYs++QQzhiuw0wW7Osw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788849238;
	b=dH6X9P7d+xj1AN73JdNNpZ6d3l2hsmx7GHcGtgpZW0I/B8G+xPRNKouB9vbUMtwENG+iH2
	zTEW+bQphtDwNmqvsIlxYvxd49aYbuWsAz2mVFfKoevx57bNd3niFI/54vak9OLP0GpEFo
	5utRejrVLSs14Q/xDdLdoIOfSbvXguU=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=b2Bsc4yZ;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=x7vG3QWi;
	spf=pass (imf28.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1788849235;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JkLB6p5Aaygn3v1gYuxHR1a4yxVdgYLi/cxda/p+uN8=;
	b=b2Bsc4yZZCv/2zStvOHZ+5ePWQ0eZmT7xR1lkQClQSx0s+SJJVZsDS9kHDKSOqkV04EXRc
	1Co/AU5QZB8ybfRyD3MRZHLU3U5EN+z2Nsr3nY4EZ3mrza0TUFynEzX8i4hmckaQYL150u
	HvAm/2cY3Kyh3dFmID9+E0Gr7vn8+l1FhXhoHwaiEmKzrb5aHONKrYbeBhQlstbUJV2WVo
	/Cu+QeuJCDvdl0AXRGRduW9ZDawna43n+2sGf3T1TJagsr5MBwClzchUDkvRjVatnSeZtK
	nY2/4prGOYlHHzFHeX8N7JsFwydH46UcNwCZpP1P9canDwGt2uhvHTkqMxjTzg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1788849235;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JkLB6p5Aaygn3v1gYuxHR1a4yxVdgYLi/cxda/p+uN8=;
	b=x7vG3QWiRwmW98omRQPlaZFU76UvHL2q5q8hKbQ0OxRFsx2Px/LNZ+L3EC2Y+ySRKGHhQy
	eS3yU3Z0tTMvxhAg==
Date: Tue, 08 Sep 2026 08:33:48 +0200
Subject: [PATCH v5 14/24] ARM: vdso: Enable the vdsocheck tool
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260908-vdso-absolute-reloc-v5-14-3a93791af1cf@linutronix.de>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788849226; l=2444;
 i=thomas.weissschuh@linutronix.de; s=20240209; h=from:subject:message-id;
 bh=5Gobf0xeM6oQnluCotYvDM+iRhHp/CqDKzVKvDYgKwE=;
 b=lQ6F773yey6sveLRjZ316ezChGjQ/W1VbZFhepBwbB+581BX6rUFfyRGnwkoZjYfE1ZBXrBr1
 697Lhc8ZNfWDhI1gNse15EH3qBq+xOPmSQUzK0CAa+i2HEmHInauhxP
X-Developer-Key: i=thomas.weissschuh@linutronix.de; a=ed25519;
 pk=pfvxvpFUDJV2h2nY0FidLUml22uGLSjByFbM6aqQQws=
X-Stat-Signature: rsm189ewfpf9yxa1dn1qps3r4x7prdtf
X-Rspamd-Queue-Id: 9A505C0002
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788849238-268741
X-HE-Meta: U2FsdGVkX19ytny/t0VYckjds06GekcCh6x7CVWaRuvSj9l2GT6EQqkSGmSNtE1sOzqr6xAY4Jel8qg5kElUip29OqrOvR/bQJi5/FaYbBDBNBwEssTzKd/p2M5fHHyzv8z7VMbALaWg4vvKWnj7KEmIPxrjhy7n/KfulFu6u3cWCM7ywWXWz9M/nVwe7A+zX1iU2DgYx3bnubnKCntHRfWUooOyi3XTAT6vhbY/ND4iWZf2p4rJdw/g72G/3UVoL6tqMPO68iMmcyQpPaujrY7w4KPSi2DjirzxgBUSQkg781WyMBV8iIGYV/7MGAQKFVrirR31zeQUvM/Nw0aqZwd9TMRqOQImjA6CwCoDxNSHrezvAydWt2iHVQFtGYFNAeyqoVKfffEM6Gqo+NyEQo9lT7q8vat5NCM+2I3RlKdLelcR7XVD6QgVRI/n9JAX2OSFRY34lxvexPE0RoTmIjDEE7ZVuxmlWuTQbNQznnbp2u3bNso9/Y66t32UqRsidmMeEIFuFdacZXVNcYYt6Cx3K1pRMstCgb+GF41VaE5GXdOR7tPWY3S6uL/yVw0nixnLgHpzDqfqMtNOYkOlutOs18yuCpEofFIoQ/h9ux0P69kbstZdrEzb7p0yOcRLW7B8+BJ4/m1BtmNGqAtBglYrO+A8U/EV1gvmgly8a0Vfx3egpLaIWuEDKd4BruYN/GUyRo8bAiz//cRQ/IlW4Ronuw7UwBq9jpZ27BYgrophA05TWTsKN4o9BbmIbs1KZyL1cmvc471Rvpwf1un3ZJ8rDpOxnUcJ/9LOGwrnZmK0fStZ0pldBoIBhwU9y6WqyiNXyn2gDvx+R34z1y/sogZUwGl99hD1B9o4axuKWe67ViGCBhEmOHuYWACOMjB+/f0KJHjMRZFLCf/tCNwnYCrqW9FQHPnbzGy/+hCbnZSGH5aK4bdl+Fm70VvuLGyxQTdwYnK4ak75KaWPvIx
 BKymneYm
 CmgQKQFjitTmdeHAbJIHwG7jMm4k5KPuOqOw8zgk6UnDq0Zi7fY7XebkXxIGIObGfayXPilW/Ovc8q3PbFLarWSH+ToJpLMP2UQmm7Ob/1uLc6nqAskD9fqzn5To/6zAxFf6i86eWmXOtrre/v2nOq3dZ6/SLEJvP1RwGRsIWDC5K6lEtoaOmAGy+UvfhfbcIGOnSg3Gu0vUYV40ITCiFmNntOMsKJ6GG6zk34J3/2ekWz6/q6zVGVXw4JinlocnUi2UvPo2uEhGFDV7iOXtT1kUrE9loBNKE0En1zyy/5GHh8V6FlczfcDHRoq11ErDZTIP6OCqiEQi5ER8vNi+CswMf/oet3r3dzIf7yyFDqFG3vGtFcwop5n+JKH45ZKnMdTckY8/Arh5X7k4RjuFEqz4SsZU16m8fOZOsE1igqM3iWusgGxaqoJvrEfkxIDKHhDm7P68ZqFMvkBdjSXiyQaHBKVYDGLiz6OW88+ZJucr/0qvVruQSQL2TljZVkcxmD/ruww0ToJwwxA+OqbeHQ9hwu4XRXM+nfiiFA1992M2VRXw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The vdsocheck tool validates the object files and final .so library.
It can detect if the compiler created relocations which are incompatible
with the vDSO which need to be worked around.

Wire it up for the architecture.

Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
---
 arch/arm/mm/Kconfig         | 1 +
 arch/arm/vdso/Makefile      | 4 ++--
 lib/vdso/check/vdsocheck.rs | 9 +++++++++
 3 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mm/Kconfig b/arch/arm/mm/Kconfig
index 6574659dfb61..565988a66e98 100644
--- a/arch/arm/mm/Kconfig
+++ b/arch/arm/mm/Kconfig
@@ -950,6 +950,7 @@ config VDSO
 	depends on AEABI && MMU && CPU_V7
 	default y if ARM_ARCH_TIMER
 	select GENERIC_GETTIMEOFDAY
+	select VDSO_CHECK
 	help
 	  Place in the process address space an ELF shared object
 	  providing fast implementations of gettimeofday and
diff --git a/arch/arm/vdso/Makefile b/arch/arm/vdso/Makefile
index cf8cd39ab804..fd34d0ff018a 100644
--- a/arch/arm/vdso/Makefile
+++ b/arch/arm/vdso/Makefile
@@ -37,7 +37,7 @@ endif
 $(obj)/vdso.o : $(obj)/vdso.so
 
 # Link rule for the .so file
-$(obj)/vdso.so.raw: $(obj)/vdso.lds $(obj-vdso) FORCE
+$(obj)/vdso.so.raw: $(obj)/vdso.lds $(obj-vdso) $(vdsocheck) FORCE
 	$(call if_changed,vdsold_and_vdso_check)
 
 $(obj)/vdso.so.dbg: $(obj)/vdso.so.raw $(obj)/vdsomunge FORCE
@@ -50,7 +50,7 @@ $(obj)/%.so: $(obj)/%.so.dbg FORCE
 
 # Actual build commands
 quiet_cmd_vdsold_and_vdso_check = LD      $@
-      cmd_vdsold_and_vdso_check = $(cmd_ld); $(cmd_vdso_check)
+      cmd_vdsold_and_vdso_check = $(cmd_ld_vdso); $(cmd_vdso_check)
 
 quiet_cmd_vdsomunge = MUNGE   $@
       cmd_vdsomunge = $(objtree)/$(obj)/vdsomunge $< $@
diff --git a/lib/vdso/check/vdsocheck.rs b/lib/vdso/check/vdsocheck.rs
index 1174d896a68b..fb88ef0be09d 100644
--- a/lib/vdso/check/vdsocheck.rs
+++ b/lib/vdso/check/vdsocheck.rs
@@ -48,6 +48,15 @@ fn allowed_relocations_for_machine(machine: u16) -> Option<AllowedRelocations<'s
             ..Default::default()
         }
         .into(),
+        bindings::EM_ARM => AllowedRelocations {
+            in_object_file: &[
+                bindings::R_ARM_NONE,
+                bindings::R_ARM_REL32,
+                bindings::R_ARM_PREL31,
+            ],
+            ..Default::default()
+        }
+        .into(),
         _ => None,
     }
 }

-- 
2.55.0


