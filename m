Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0600FC87FCB
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 05:46:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA3AC8E00DD; Tue, 12 Aug 2025 01:44:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B53B38E00BE; Tue, 12 Aug 2025 01:44:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F5CE8E00DD; Tue, 12 Aug 2025 01:44:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 818738E00BE
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 01:44:59 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4253181361
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 05:44:59 +0000 (UTC)
X-FDA: 83767016718.28.362FB6C
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf17.hostedemail.com (Postfix) with ESMTP id 67DD64000B
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 05:44:57 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=u02ULTpX;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=dCjTzytX;
	spf=pass (imf17.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754977497;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cZ20UpxcMxk4CxqTAsOEg+d3tEufNIUEKrmXXn+g7es=;
	b=q6/VkCVcG2QRL+gqaOJ2k5J94oTPPsLLX+qEwWw/RX8ETjr1dXWqsaz6ks5p4mgxyS6F+E
	GtFH0tV4rs0nimyBpTP2e0DPBX2T/3XzgJO9NuJfJufeDHlU6C62cK68WUCFV5nKSPA5tE
	I4xqbYeuj2FQbmsA5t7an+jkiNGjsgM=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=u02ULTpX;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=dCjTzytX;
	spf=pass (imf17.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754977497; a=rsa-sha256;
	cv=none;
	b=AuBlS0rhFj9KnJQmfxkpqL3bIqQpBTzMyySOMg16pMudPS0KUd9Jspa2tATYpdIP2kJ6dn
	Cc91mmaTsIfuFKpdSKAKLyf4aN2KZt/hBF7shBHdByn4x9gRAdbi/gVEC9ysouvA69MGgG
	ukSU29nzAYzHfjoJlpoV3YuxvaQmp88=
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1754977482;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cZ20UpxcMxk4CxqTAsOEg+d3tEufNIUEKrmXXn+g7es=;
	b=u02ULTpXMKVYfa57toc79SeSvHFZXxCkrNoUYan+T5r+jzG+jErgF3lH3L6hpXG5GD7AiP
	BIUXfeq2JImvh4BYaqWeRcsPcpQWyQhVM6L37lOS8/C3ZaJKOGeEyLxqjYZEbvX/ROLkBH
	u79IO6ttBD1PVC+tYif7r2bAXlngTkKup+NLj++0//mmwP8JvHnpMe87VUFc0bOwAeIITA
	jDpSHVlj7jvidjWsVLXDskx33s+au1U1XzyN/9KPs2LnIbFp5cV3y+a+R/VTZv4VZHKIAG
	LWkElhMb8xt5p1hHetTPMUO1bZj316mgGQEbOwBvZ0KYDGtgbZwU0kEgUkCLYA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1754977482;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cZ20UpxcMxk4CxqTAsOEg+d3tEufNIUEKrmXXn+g7es=;
	b=dCjTzytXjhSAHdYjPLNNi/GmmKuNlP6Pk8Piyd2jaSGduNETuOdwRfsVItAyacB+69vj23
	yvuwshG6rMcH0pAw==
Date: Tue, 12 Aug 2025 07:44:36 +0200
Subject: [PATCH v4 23/24] MIPS: vdso: Enable the vdsocheck tool
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20250812-vdso-absolute-reloc-v4-23-61a8b615e5ec@linutronix.de>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1754977469; l=3783;
 i=thomas.weissschuh@linutronix.de; s=20240209; h=from:subject:message-id;
 bh=zF65fVgprCI+5PEX2Gd11z0u6ua3JxVTHzfPFJcJjKs=;
 b=Esy6EbfOm7fmj2t+sBDFIgicd0JzbcJSTuk1wzj0YxPaqfzdPFEbZ+ivqSYv677dvrTRTHpOG
 hG06K4nNRAiASYK8xK3m4Pu8PF6fSaApaCF0D/lo8n5VKUT5XEMMGlM
X-Developer-Key: i=thomas.weissschuh@linutronix.de; a=ed25519;
 pk=pfvxvpFUDJV2h2nY0FidLUml22uGLSjByFbM6aqQQws=
X-Rspam-User: 
X-Rspamd-Queue-Id: 67DD64000B
X-Rspamd-Server: rspam06
X-Stat-Signature: yrbc99kfjtmfsp9m9i6xh96f1nefenik
X-HE-Tag: 1754977497-584782
X-HE-Meta: U2FsdGVkX18ytl+XaOsMgZgsHHtbIamXX8KT1A4j1SEgWMU8q1ux0TKvKBQ+rse0LXYPFkHshU0rnLD9f6SlKrmMU8ryRGoU6VaXgzQjacCwf/Ku0S4QTtvxFWpUOxFI9kARTvjdM7F8ZXU92IPZOzCQBKJGJLrpFLfQBX4t2Q193YGdOjadDWJuriejASFlQqtKYm0XJ6XfLvbg+jb8CONbF9QgRDVyt+H3JOVfg7Fxd0q09YUcwQYS7i2v9puhzUFq7MUFy+ovWqN3ezUvcJUOLXywm528P6TGIVa1jtB1lexhKEoURYUJAie0H44RnCXOj62YTgS6RNHwSO8nICYka43me1dyni6nBT02FfXobTeb7S17Uew1InVJZOqKPxB7IL8eub2oOkp8AT+mu5MH0Vvc3+AtypBTDcIaYGT4hxNdTP3bIVV76It9En56402ljJr4eIZFCcZivTqEn+CzHePy78mMqvQ0/GD2l0XS9RgnBMUZapYZVnpwo3bFdD/3LGbOufx+t+HkSIto3NWJp9AePY00yYMdhfMzz4exjrCIOml4RRI4N9KQxM9ISU/dYCdFhpPyqDupBr3J7CUWZPoiDd4vxcA+UleQ4rf+QiFZdwA9DgFUovi6jgIXZAnQ55fgvASKq+JUzqX19M+NGi6gXPluhWf9v2kQIzrCJJbpW89bKAa5GObfIO3We5GazZScPU0HE38toGDSFBhrG03SK+sZWiPQWk/vjIdwzP5UHunMKDIswLWKjElGOx/MHvEVA4EZWQJkTP6hD2o+UwB3cEu0o3bJafYjJ2rC6EPqpV4tWF898fe5D8dWtasmyHgoxkeZe1rcsjHEvZrHDa0/L7Yskm7YIqDYfxbVSP+EGgPqLHAdhVyIjamfCp1KURZy1qku1yz3wyxg5/WhYAI/c6o3ExH186B5ymka35xOpob12F3az+nKMBsitaqFHqSyWhA6zohXmJ3
 1JyHyh1M
 4A2bJ0RI/zvzOKIKdayZ5MFsUMmEns9p0DXjeQ8AuEzCsNBCHjNqaathXTwGyggDY0Oj5LWmDmNxxfxZpTdyTp2bdpjhNYm730vXZ9H7ugrfUWcw4UgfRQoqvnaE3/dqN7r/vhIh0Pm1AxloikpVCNS2eM4CeeOJZzMl6CkuztrqmCk2cQMQym7GA9pI5OhKZciKUXYB/JhicCidGMjTBjY5Aczg/K4OFTnCxlOeNLaPnp50CAU4tsijjsiJrdTkl3rv8dZOSLxclHCml8byVimpzoM2paU1MfVTvHggOHCc6//IdI2IEeWrrs7/bmmTojTnqEa6dqVg8+7g//eCF+lCtVG6LWe1O+vjvUfuoOtGgccmgw4TU7C8fFtTLOnzZEt6e6KxgOZAHOiO0SWAfBt8W9oiySTwMu/Gg4PPKC9G2BC7IrTUoFRbbQefHMaJezRIp1KwTZiEmnBIjVb4vIFLKkpCx4L/qa4Fm0IFpKD0LpUSta/kCadSsMKJj/DP6xmMy
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
 arch/mips/vdso/Makefile     |  8 ++++----
 lib/vdso/Kconfig            |  1 +
 lib/vdso/check/vdsocheck.rs | 13 +++++++++++++
 3 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/arch/mips/vdso/Makefile b/arch/mips/vdso/Makefile
index 69d4593f64fee593c9ea5b030eabdea40b39b89a..24de045737580fb6a0148abb87e459d8f4be1d89 100644
--- a/arch/mips/vdso/Makefile
+++ b/arch/mips/vdso/Makefile
@@ -69,7 +69,7 @@ quiet_cmd_vdso_mips_check = VDSOCHK $@
 #
 
 quiet_cmd_vdsold_and_vdso_check = LD      $@
-      cmd_vdsold_and_vdso_check = $(cmd_ld); $(cmd_vdso_check); $(cmd_vdso_mips_check)
+      cmd_vdsold_and_vdso_check = $(cmd_ld_vdso); $(cmd_vdso_check); $(cmd_vdso_mips_check)
 
 quiet_cmd_vdsoas_o_S = AS      $@
       cmd_vdsoas_o_S = $(CC) $(a_flags) -c -o $@ $<
@@ -106,7 +106,7 @@ $(obj-vdso): KBUILD_AFLAGS := $(aflags-vdso) $(native-abi)
 
 $(obj)/vdso.lds: KBUILD_CPPFLAGS := $(ccflags-vdso) $(native-abi)
 
-$(obj)/vdso.so.dbg.raw: $(obj)/vdso.lds $(obj-vdso) FORCE
+$(obj)/vdso.so.dbg.raw: $(obj)/vdso.lds $(obj-vdso) $(vdsocheck) FORCE
 	$(call if_changed,vdsold_and_vdso_check)
 
 $(obj)/vdso-image.c: $(obj)/vdso.so.dbg.raw $(obj)/vdso.so.raw \
@@ -144,7 +144,7 @@ $(obj)/vdso-o32.lds: KBUILD_CPPFLAGS := $(ccflags-vdso) -mabi=32
 $(obj)/vdso-o32.lds: $(src)/vdso.lds.S FORCE
 	$(call if_changed_dep,cpp_lds_S)
 
-$(obj)/vdso-o32.so.dbg.raw: $(obj)/vdso-o32.lds $(obj-vdso-o32) FORCE
+$(obj)/vdso-o32.so.dbg.raw: $(obj)/vdso-o32.lds $(obj-vdso-o32) $(vdsocheck) FORCE
 	$(call if_changed,vdsold_and_vdso_check)
 
 $(obj)/vdso-o32-image.c: VDSO_NAME := o32
@@ -184,7 +184,7 @@ $(obj)/vdso-n32.lds: KBUILD_CPPFLAGS := $(ccflags-vdso) -mabi=n32
 $(obj)/vdso-n32.lds: $(src)/vdso.lds.S FORCE
 	$(call if_changed_dep,cpp_lds_S)
 
-$(obj)/vdso-n32.so.dbg.raw: $(obj)/vdso-n32.lds $(obj-vdso-n32) FORCE
+$(obj)/vdso-n32.so.dbg.raw: $(obj)/vdso-n32.lds $(obj-vdso-n32) $(vdsocheck) FORCE
 	$(call if_changed,vdsold_and_vdso_check)
 
 $(obj)/vdso-n32-image.c: VDSO_NAME := n32
diff --git a/lib/vdso/Kconfig b/lib/vdso/Kconfig
index b5b6673897e24a1f36147c21d00dff057f293980..567ac937a9c3084fd5669e1b890b667af8a2f12d 100644
--- a/lib/vdso/Kconfig
+++ b/lib/vdso/Kconfig
@@ -58,6 +58,7 @@ config HAVE_VDSOCHECK
 	default y if RISCV
 	default y if LOONGARCH
 	default y if S390
+	default y if MIPS
 	help
 	  Selected for architectures that are supported by the 'vdsocheck' progam.
 	  Only transitional.
diff --git a/lib/vdso/check/vdsocheck.rs b/lib/vdso/check/vdsocheck.rs
index 01073062f2b2d276291ccfbc6aa516f14a13fdd5..d9e660385e154fea179665ef9c5ba90223bf72be 100644
--- a/lib/vdso/check/vdsocheck.rs
+++ b/lib/vdso/check/vdsocheck.rs
@@ -146,6 +146,19 @@ fn allowed_relocations_for_machine(machine: u16) -> Option<AllowedRelocations<'s
                 bindings::R_390_PLT32DBL,
             ],
         }),
+        bindings::EM_MIPS => Some(AllowedRelocations {
+            ignored_object_file_sections: Some(&[".rel.pdr", ".rela.pdr"]),
+            in_object_file: &[
+                bindings::R_MIPS_PC16,
+                bindings::R_MIPS_PC21_S2,
+                bindings::R_MIPS_PC26_S2,
+                bindings::R_MIPS_PC18_S3,
+                bindings::R_MIPS_PC19_S2,
+                bindings::R_MIPS_PCHI16,
+                bindings::R_MIPS_PCLO16,
+                bindings::R_MIPS_PC32,
+            ],
+        }),
         _ => None,
     }
 }

-- 
2.50.1


