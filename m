Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7CA7C79F99
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 06:35:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 527FF6B00AA; Tue,  8 Sep 2026 02:34:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 48AB36B00AB; Tue,  8 Sep 2026 02:34:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 378CE6B00AC; Tue,  8 Sep 2026 02:34:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0F6626B00AA
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 02:34:05 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 86AFDC03BA
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 06:34:04 +0000 (UTC)
X-FDA: 85189630008.03.2CED8D6
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf22.hostedemail.com (Postfix) with ESMTP id 7A256C0008
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 06:34:02 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=Duhd+tzh;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=TsyWF+JN;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf22.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788849242;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B5v9YeHlqv3ovO/ql+3n8/DnO9S76Q/KXTK4Iu9nIj8=;
	b=Rcen65FlpQsbdcWtp25ekNZ/ydibEjfuUrbH3i8vSZZer8+Pr+QoJ0XId+vwlLqLAUaqHZ
	42gaTYcwJrYacCry5YEGsLjuSf6nllRu3xycIc92nulWd2frBL0siT0or6YDYkHCxwv6Kb
	JT95gcI44klZ4LnlwCSNZ8uknkWIzw0=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=Duhd+tzh;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=TsyWF+JN;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf22.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788849242;
	b=5HeUnckcV7GU2clNKhjULNCiLbgUeo9y4vt4idK+m69n2Mmxambi32xYDinQ1Q6nK4bdxF
	i7CSqZqUUaadrSNQQxvX9BYj7Y+oogSFxbaNkjXgsz86MvQwSLzDIh68tNb8oVpCCx72Sj
	z0gnWTNdNPdtYPb2euS3ZKI79ruVfyA=
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1788849237;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=B5v9YeHlqv3ovO/ql+3n8/DnO9S76Q/KXTK4Iu9nIj8=;
	b=Duhd+tzhOIqAKD5Jsk7S5bIW+1/U+0lAyREaDyVMtUfkM+/2g6McMuZ8BVCtyusCW6KJhw
	wjBNCvGCpNGgmhFNn9x5FtX2pPVsVPQncpaQfdGxuDFM2F8njXe/d+MpW+sHlGTHGFoNTq
	Irhfb/b0d78bbsC8nUcr59RO2R6WK1QG6Wmmqjub7uMBsV8HzhabnT8Q3BXaImhnViQuCI
	99Y24z+RnYH8P+/0VTaa0of5QDISRCOgkSmlsMF9mLF5D2je6Fs4Q2NdAPmpcUGUDioSm3
	I7ouCpMLG1e5cQUG5eQhiKpjN9lpx2nzj/DsTf8/2g6tDQdVpp9HJVE2/Kspiw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1788849237;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=B5v9YeHlqv3ovO/ql+3n8/DnO9S76Q/KXTK4Iu9nIj8=;
	b=TsyWF+JNT75r27JmDD427VBvLmTOCV3ff2Y7hv2xF0uvSSVXKhCkoTtj5xhp4+hfJtB9PC
	YrBA0mfCXrb6F8Cw==
Date: Tue, 08 Sep 2026 08:33:51 +0200
Subject: [PATCH v5 17/24] powerpc/vdso: Enable the vdsocheck tool
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260908-vdso-absolute-reloc-v5-17-3a93791af1cf@linutronix.de>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788849226; l=3226;
 i=thomas.weissschuh@linutronix.de; s=20240209; h=from:subject:message-id;
 bh=PdmcaVe7pCu6upu7UTobIjeT+xi6m7cmShZzdDyDUqA=;
 b=KtzFUmFB6ajLIxA6GIlsiL6NZpPyhZkhtmdUQSlrxF2Z0EifBwB7dmyJS0AwkyNYLtHN5Uenz
 k87bxRvOvh3AuR3/IHMkszUyZg00Zcqz3Ne04gmZUna19VeKFdykejP
X-Developer-Key: i=thomas.weissschuh@linutronix.de; a=ed25519;
 pk=pfvxvpFUDJV2h2nY0FidLUml22uGLSjByFbM6aqQQws=
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 7wstfyk5qesgtds5hy81z11msfwy535j
X-Rspamd-Queue-Id: 7A256C0008
X-HE-Tag: 1788849242-822598
X-HE-Meta: U2FsdGVkX19y+xhOKxLIicryBI5vrW5AS2zNCY82GQKuxVfvoTlrwO9SUw5SDvZkQ2lwrMj+GLNG9JrntOF9phAyfQFjjPMU9zfzbZN23o8KGhxnkRiOivivYYNfpvsfMcDyxgYPShTurDYwm7viO23JrOkVsmLO+4CkwmkIDJHmBy1pZzaZ1g1r0rv6JY9stZupOQFrdPgV9CsrdC4k6qcN3CSdiJG/wgqnwA4otU3ALXj2mVlUcurzV5NF7+pV+WFoB0ymeojnhLaEGUPWThMiOC/udwFty9omOrNcGswe2t7Ay0gV6NVMyaoXE9LeHebyN+kJ4dvl6zey53ZiZSAaXh0AAQlUST/TbHXS0TfJZ3V3KsgkEcQZQu/6RylpYzsD7J6nAR/u+c5UQOQyHglKdbKUlM4WkHAC87oZSAV1lYKAqNfSCSEWTYDnQ0f3CiA6XxchdWNNWjHXIkEVmCqIwfcy/k/dCODg5EwiZavfJ0POt6qT2dY1BXWdME1kqs2/DLU8oEG/xsfIJIrwwj6r75Ye9AAxh7UBLjjq/yrk9SPGkRuxGmTFKju7CaASIDyKRnP9FR8H06s16QwsQjZXYMR5IphAeqvBMNQthWBD30+rtOv5EHwbeAU/8Jsl6YAJ/APSFFs2It04MH1eBIdvHnIAGPpLJHzRKgLl3h4kS/78mMYYHG6JtCd2jHDi4j98hZNu+26lGKDgb+0+7f8EwvXOLYIMAGlEwT5X0CJSPKtte6U8BEioDCot0HoqO1kbWFeAUYJDcYVszvvGbna5MLwm4BDXboYjcKqwat1EuaqJd/LcCR0FejNtSD4fmU9i243d/uavMH/4irBtmmJBirlesNUth22LjkXyg+UIhCffR1lQZgg8QzBkydXVIQUAXcGcidDuyXGhu3dcKpVADw2XDtvWyWQEAX80/ir4iEM8Z8hIOAY7M9yuYGRsgS0q1fw4n+W7rGRw/C8
 sql7j0FK
 hj12HpU9Y9Balgg779mfQZuWH0Vu279JAOuIJTcRX7y60MKr6nai42whOAwww4S/2BHnWnHJRIHCiSo032dxvPF2JXM72ZueEUaWkr1L0CxC71nL6Wcih9Ws4KK/fUUj/JKuZFVZ9eO42E13LM0E0wEcoqG97eNEKB0PzRhbl/PqxBJMgXO//vBSiDUh6lX631lUN82WZIPXAgOQjssp0h6vYXFSmn0RH3oQW+30rnQtOYFUuZVQCLilL4BMwSRb3tuWvzVkQrJsE4CreyYhVYEb+IojnJ+6fLTKTgzedksaeWPquMTw/klkjzRkh/XNtqArhUk1zsYM4ifiXfR226mwoJrra0UobN6ENoxeqQ7IbObJjyQFslqwmYUn1QvxVbdRCCgrJNnZ5rcpU6U0s0nPaRmlU5/DwXUgSO5ZEPRliHqsCfLBMqbT91h9eQPkeE4+nnfrMDEJlg1pcnqvSd7gdEj9u1xrxT5f8IHJxaBM5ww5ibQJx/jgrbRVyFPoOnrsjC96oE7oMK2NJY6M9CFDb/ZvTl4JiEUuSaKK9d/W6bgg=
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
 arch/powerpc/Kconfig              |  1 +
 arch/powerpc/kernel/vdso/Makefile |  4 ++--
 lib/vdso/check/vdsocheck.rs       | 27 +++++++++++++++++++++++++++
 3 files changed, 30 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 2580e27e4328..f19e225cfc5c 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -330,6 +330,7 @@ config PPC
 	select SYSCTL_EXCEPTION_TRACE
 	select THREAD_INFO_IN_TASK
 	select TRACE_IRQFLAGS_SUPPORT
+	select VDSO_CHECK
 	select VDSO_DATASTORE
 	select VDSO_GETRANDOM
 	#
diff --git a/arch/powerpc/kernel/vdso/Makefile b/arch/powerpc/kernel/vdso/Makefile
index 368759f81708..ca20b91b4373 100644
--- a/arch/powerpc/kernel/vdso/Makefile
+++ b/arch/powerpc/kernel/vdso/Makefile
@@ -81,9 +81,9 @@ targets += vdso64.lds
 CPPFLAGS_vdso64.lds += -P -C
 
 # link rule for the .so file, .lds has to be first
-$(obj)/vdso32.so.dbg: $(obj)/vdso32.lds $(obj-vdso32) $(obj)/vgettimeofday-32.o $(obj)/vgetrandom-32.o $(obj)/crtsavres-32.o FORCE
+$(obj)/vdso32.so.dbg: $(obj)/vdso32.lds $(obj-vdso32) $(obj)/vgettimeofday-32.o $(obj)/vgetrandom-32.o $(obj)/crtsavres-32.o $(vdsocheck) FORCE
 	$(call if_changed,vdso32ld_and_check)
-$(obj)/vdso64.so.dbg: $(obj)/vdso64.lds $(obj-vdso64) $(obj)/vgettimeofday-64.o $(obj)/vgetrandom-64.o FORCE
+$(obj)/vdso64.so.dbg: $(obj)/vdso64.lds $(obj-vdso64) $(obj)/vgettimeofday-64.o $(obj)/vgetrandom-64.o $(vdsocheck) FORCE
 	$(call if_changed,vdso64ld_and_check)
 
 # assembly rules for the .S files
diff --git a/lib/vdso/check/vdsocheck.rs b/lib/vdso/check/vdsocheck.rs
index e45a1fbc6829..429bdcd65818 100644
--- a/lib/vdso/check/vdsocheck.rs
+++ b/lib/vdso/check/vdsocheck.rs
@@ -69,6 +69,33 @@ fn allowed_relocations_for_machine(machine: u16) -> Option<AllowedRelocations<'s
             ..Default::default()
         }
         .into(),
+        bindings::EM_PPC => AllowedRelocations {
+            in_object_file: &[
+                bindings::R_PPC_REL24,
+                bindings::R_PPC_REL14,
+                bindings::R_PPC_REL32,
+                bindings::R_PPC_REL16,
+                bindings::R_PPC_REL16_LO,
+                bindings::R_PPC_REL16_HI,
+                bindings::R_PPC_REL16_HA,
+            ],
+            ..Default::default()
+        }
+        .into(),
+        bindings::EM_PPC64 => AllowedRelocations {
+            in_object_file: &[
+                bindings::R_PPC64_REL24,
+                bindings::R_PPC64_REL14,
+                bindings::R_PPC64_REL32,
+                bindings::R_PPC64_REL64,
+                bindings::R_PPC64_REL16,
+                bindings::R_PPC64_REL16_LO,
+                bindings::R_PPC64_REL16_HI,
+                bindings::R_PPC64_REL16_HA,
+            ],
+            ..Default::default()
+        }
+        .into(),
         _ => None,
     }
 }

-- 
2.55.0


