Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8DC1C87FCB
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 05:46:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B8B48E00DB; Tue, 12 Aug 2025 01:44:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 141B38E00BE; Tue, 12 Aug 2025 01:44:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F25BE8E00DB; Tue, 12 Aug 2025 01:44:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D839A8E00BE
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 01:44:56 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A965681397
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 05:44:56 +0000 (UTC)
X-FDA: 83767016592.27.F4818EF
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf06.hostedemail.com (Postfix) with ESMTP id CD33D180002
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 05:44:54 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=YVIBrzVs;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=AHGoK11e;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf06.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754977495; a=rsa-sha256;
	cv=none;
	b=r2znFinXCf3Wt3FvdgjU5mHjyIifjNV3xJghlBSRpEEDP2RH9tx2Wq0Jca49UauAC6Z9RU
	r+DrIdHodFmtG9dcp7xNPEE507Z5f6PYlRXJFGaLQbcJiO2XAK2hS1DAdPud/VEfJJ3PRu
	sW9OuQGR4KmtbpLs7BGsoslSnNWunl0=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=YVIBrzVs;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=AHGoK11e;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf06.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754977495;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZNmm+0jjK/cu4H5GKrhccpCqW984gVWKwBZnN5hgc4w=;
	b=QCTPOVpqwOgzmVfIX9Veu6q5mcqzGOq9sqZu+6MHhm6ECId55UItUeNS9LOa9w3NGbs7Wp
	Zu0BLxwr2n3ylymUllVXWgKwvwTfMWb/zFHbSTlodH1e45oXktiEBx/YlJ7N4toqKHO/Yg
	uE36gBz265CgIBRwAtBT2ISdBb+0m90=
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1754977481;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZNmm+0jjK/cu4H5GKrhccpCqW984gVWKwBZnN5hgc4w=;
	b=YVIBrzVs6jMRgP60RbLocRZINlpYIvgh/R8TmjjX9sgPwnMSGZAXRyMlQNpfj8cGpZ/fxK
	G1/ToFEH5kb8MyAyKBkqwWZy3FKtIaGyFnw/jDcC7cDfkV57unEWUErdw+4OFfUlhZ4I+Z
	u8LwflPKLpav+TZK1MYkSfenBQn967+uc5qSfgthMGz/rbRyu5ep6Dm6EBqZkIbqP0QvA/
	DEO9YwRG3oLtdNHQfyHGqGzKfO4J2v2y0izQdU6www5cNj6J0F/5SABcNgh9oQkLaiJmvS
	5ypEzeVA2rzpysAIPhXAr1gdv1DqmozBuroN9m2hnP3Ep+YD2Fk+LtTvniAoEQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1754977481;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZNmm+0jjK/cu4H5GKrhccpCqW984gVWKwBZnN5hgc4w=;
	b=AHGoK11e3ONpNsRnJ36Q4yzXjYjg8Xc+9ohCcoySpaOfSk5kLWkDoRsDYtFjalcZguXquc
	0s1EVjzvsI3du6Bg==
Date: Tue, 12 Aug 2025 07:44:34 +0200
Subject: [PATCH v4 21/24] s390/vdso: Enable the vdsocheck tool
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20250812-vdso-absolute-reloc-v4-21-61a8b615e5ec@linutronix.de>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1754977469; l=3294;
 i=thomas.weissschuh@linutronix.de; s=20240209; h=from:subject:message-id;
 bh=PbETMq9VTMEwxP8nGcVWnIK4aa/sB1ug5A+6i2j8Dag=;
 b=0cxT7S8ALFBcremtG1GBYu7CMsjCUUhSxQ1TwTPoImStmnRVATckJ934fbovkMMjfs5d2wReE
 xM4bYW6HkdvAmAnJ8M3DKlcu59tynIH+5lbTlWBXo2H7IRGxFBIBEy2
X-Developer-Key: i=thomas.weissschuh@linutronix.de; a=ed25519;
 pk=pfvxvpFUDJV2h2nY0FidLUml22uGLSjByFbM6aqQQws=
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: CD33D180002
X-Stat-Signature: chgh1d48bofxxd6f5fzm7kq8ncos36mz
X-HE-Tag: 1754977494-725305
X-HE-Meta: U2FsdGVkX1/fBOn3GiGTdy1+fxC5iXBtbNVQJsvsUfusOHt6BGeaAHn7d/fltrG8yd/RleSTLAZ79+FDMuCqR+3nlHJ3fr/o69aBfFZ7Dtd34jON2MAkHbjEO/YMKq82aA+fOAMDXNL48rVBPoScpMaR+4pUuA4HcUju74d5DQM57WOIHUsAAMlE+z+zq2cgOEfC0AVzKiny0PdBmGaS1VM84lmRUzzUOkWBV84VWRcSlouWmQyqSz+rIUAaDEVkLsWLulDrgUaMbqo12eQ1JuAnDDJACAc8F0Vipn5NQBXvr6zXBzEdY9A7rrpOnmBOhXREOoOAOwqTeHSb018ry47kBhN6Xw6t98As/MYZIQWw6BoAIOHBmiue5EA9OF7e/ZbusJRDoyGIm9EP3tlT7mZHPOXJPN7My4P6ztvfzPNDS4awYazSpdhLkaODR5O3YykM2KhG+IwUKjamWpu9V48NbNvw0aDSBNCB79ZD4dtuTYepFIkLcbQlZYuHH5ALtPIHcqcjAkoXy7EoIe3xbOQDUXgxKm5Nt9Q8P9CbIFhhJ+G5vFncwGBD0ymqGEuRoWI7sgcdC53KMWk0U2j25JtlguSvn3/B4/KTya/AMNHRiXZ5j7DyEGEAzGHxGh3i4R0I1ktz8DU+Rl/OGCY+gsCgiSfbO+l275RxvvNAwgFdHPDSM8rfDcHzCqFmbD6GHFl5rEqCDhcLF3k9FOeHEePGyF0xC4zHDDydIgriB2q4BCkf3Pog3QhEJY4Ik3bqmBLUoeSfwDBfyXxxzrwpZCjTC4/NY2y3G73z27CzrvcHZZ3/eJGOQm/hwgHLbMa1nlndGu7yEuYO+/XyFaRiXKIUsKMiZww+a1InThQjbnpjjIk6nTzS9tja70c+XdGsN7ioHVgaEc4soYj2y2OIknf8woJiUk0E1D0nlaPFZVpwCcKQaTXfo6YLnekpWuNuKe2v6fIi5GTz9fm3F0v
 rJQDD0ki
 zt2FqJu0rRwRAUo12km9osb+12EHffpnh4viff6gUESKm4aoeD6N6vsxOoaRX/Ewta7Z+Z7OI+wNesBF+x+r9HxJyLv9CwZNK/GUKt83ECUk6VlqKNCwz4qXfx382imJ61bDolu4Acn0Teo1d2Lf3FXem3aqxaOIKOeHKlIHACvKLghRncR01N3ofNSyOR0IEdBKem2fwpKRnfPfmPlO0ECgVa4WOO3gG5yyXHK9LImJBgoD04cX5IOu2bYEN0wU1QoQdbBSuZbNxFW6pDiIFvNLZvPQXo82VXdX89AMEQD94IYlkB6eyQwGAn/+Y182YDj8+rMoEQt/qegRyI4diX/inWXqQchvx5+Gt4MKr8e8FtAR+xX6Q+anaBDYhqbzarWC5zMDYS2CKfY0TyTMMBUNgH24GoIGqUfZR4x5ka7CTucl0rCEPtxmuIC4wPfq0T7+qrcreyGOvU+lR6s6qS9UkPcpM4PZwfxH6j0kayYov4uZLjZFezpGurK2fw9CIb2XH
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
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
 arch/s390/kernel/vdso32/Makefile | 4 ++--
 arch/s390/kernel/vdso64/Makefile | 4 ++--
 lib/vdso/Kconfig                 | 1 +
 lib/vdso/check/vdsocheck.rs      | 8 ++++++++
 4 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/arch/s390/kernel/vdso32/Makefile b/arch/s390/kernel/vdso32/Makefile
index 1e4ddd1a683ff84492f0f4b48d0efa00688129c2..6e8fba248d1aa8787f44aca2d82d77c245871b65 100644
--- a/arch/s390/kernel/vdso32/Makefile
+++ b/arch/s390/kernel/vdso32/Makefile
@@ -36,9 +36,9 @@ CPPFLAGS_vdso32.lds += -P -C -U$(ARCH)
 $(obj)/vdso32_wrapper.o : $(obj)/vdso32.so
 
 quiet_cmd_vdso_and_check = VDSO    $@
-      cmd_vdso_and_check = $(cmd_ld); $(cmd_vdso_check)
+      cmd_vdso_and_check = $(cmd_ld_vdso); $(cmd_vdso_check)
 
-$(obj)/vdso32.so.dbg: $(obj)/vdso32.lds $(obj-vdso32) FORCE
+$(obj)/vdso32.so.dbg: $(obj)/vdso32.lds $(obj-vdso32) $(vdsocheck) FORCE
 	$(call if_changed,vdso_and_check)
 
 # strip rule for the .so file
diff --git a/arch/s390/kernel/vdso64/Makefile b/arch/s390/kernel/vdso64/Makefile
index d8f0df74280960cb351154a8a73b4f7fe83a9125..1334b6a188cedc883fe98dc271a995ee690c7fad 100644
--- a/arch/s390/kernel/vdso64/Makefile
+++ b/arch/s390/kernel/vdso64/Makefile
@@ -46,10 +46,10 @@ CPPFLAGS_vdso64.lds += -P -C -U$(ARCH)
 $(obj)/vdso64_wrapper.o : $(obj)/vdso64.so
 
 quiet_cmd_vdso_and_check = VDSO    $@
-      cmd_vdso_and_check = $(cmd_ld); $(cmd_vdso_check)
+      cmd_vdso_and_check = $(cmd_ld_vdso); $(cmd_vdso_check)
 
 # link rule for the .so file, .lds has to be first
-$(obj)/vdso64.so.dbg: $(obj)/vdso64.lds $(obj-vdso64) $(obj-cvdso64) FORCE
+$(obj)/vdso64.so.dbg: $(obj)/vdso64.lds $(obj-vdso64) $(obj-cvdso64) $(vdsocheck) FORCE
 	$(call if_changed,vdso_and_check)
 
 # strip rule for the .so file
diff --git a/lib/vdso/Kconfig b/lib/vdso/Kconfig
index 0fe70b3604f9925ef8c5608bb4cac24d3a28faab..b5b6673897e24a1f36147c21d00dff057f293980 100644
--- a/lib/vdso/Kconfig
+++ b/lib/vdso/Kconfig
@@ -57,6 +57,7 @@ config HAVE_VDSOCHECK
 	default y if PPC
 	default y if RISCV
 	default y if LOONGARCH
+	default y if S390
 	help
 	  Selected for architectures that are supported by the 'vdsocheck' progam.
 	  Only transitional.
diff --git a/lib/vdso/check/vdsocheck.rs b/lib/vdso/check/vdsocheck.rs
index 93819f668d8a4f623f41403bb09b42c4aec2c8de..01073062f2b2d276291ccfbc6aa516f14a13fdd5 100644
--- a/lib/vdso/check/vdsocheck.rs
+++ b/lib/vdso/check/vdsocheck.rs
@@ -138,6 +138,14 @@ fn allowed_relocations_for_machine(machine: u16) -> Option<AllowedRelocations<'s
                 bindings::R_LARCH_32_PCREL,
             ],
         }),
+        bindings::EM_S390 => Some(AllowedRelocations {
+            ignored_object_file_sections: None,
+            in_object_file: &[
+                bindings::R_390_PC32,
+                bindings::R_390_PC32DBL,
+                bindings::R_390_PLT32DBL,
+            ],
+        }),
         _ => None,
     }
 }

-- 
2.50.1


