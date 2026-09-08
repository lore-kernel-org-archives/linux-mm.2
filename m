Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6EF3C79FAA
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 06:35:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D4AC6B00AB; Tue,  8 Sep 2026 02:34:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 686B36B00AC; Tue,  8 Sep 2026 02:34:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59C9C6B00AD; Tue,  8 Sep 2026 02:34:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2B9D46B00AB
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 02:34:06 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C98BB140394
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 06:34:05 +0000 (UTC)
X-FDA: 85189630050.27.5710DEF
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf15.hostedemail.com (Postfix) with ESMTP id 123E3A0004
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 06:34:03 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=hBTTSmMh;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=pnROhmeQ;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf15.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788849244;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R8S5zUcti2qRnvnqiwdZ99APOoLvCYmczAvcwW6T+78=;
	b=YT5EcsGDLUkvgiho83/PTA4R+DoAj3pSjNE2XQ1zrZpxPtqHLais7g/kH/NI0YomshQ2tv
	CpsocFl4NxEAgIbAOWR2R5sVmfoEEo+W42Yxi6ni/MoBGsZ4X7sWcztfwOkSHMQbdP0s40
	CQjnChx3Ff6AXuXbXyeH6F4PvS1peTA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788849244;
	b=W/piCegCV5rvXSdWQJXqfNI3qWfiTxPUmOFVwHJhrBKyqtImoqjGWjesY09ZIRKP1ru1xC
	UsK6R3YtO9KIY3P4DvKbYbYPo6d38N2vTYEkOe77U/rOiLmMvvyEuf87qB3gZR7Ie0wKVE
	+0vH8AAsdtzaUaOcQ7VqmSeBiMZlUSc=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=hBTTSmMh;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=pnROhmeQ;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf15.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1788849237;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=R8S5zUcti2qRnvnqiwdZ99APOoLvCYmczAvcwW6T+78=;
	b=hBTTSmMhDdM2I6kdqJpAUOIrF69Iua1sqGHZrZEeJV+RrcDKO3Lh6TsXgdenOxFOnA4PoA
	412uPFiR4UGcIb6zo/ixzKsRV5LZO72namgWFB+cnr4EH1Utd/VSj8gvUK8F63ekFmUhqH
	e4ILH1GjbVqWGvLNLwK9XP+4Ygy6HN0YUB9kGB3oz57J5JzxQBb26TeNDe+cNb6xv87TOy
	Z4jMkBFqsKI4y45ukbIyST/V0/zEwljrr2NXcntK+uBr0cM363V1w55zye9RhNq6wnigOn
	7fYPjipzEFO17Oeq+ED1P9qQWrEtAGBcvP+xMvJvi49Am978rgJgX00l+QbCZg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1788849237;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=R8S5zUcti2qRnvnqiwdZ99APOoLvCYmczAvcwW6T+78=;
	b=pnROhmeQiS3cU0albwBwH9dlRL1TxZa9HToYE3xYcsDLiQflLOIHiW/vhhcx0oenTo2D8f
	TUqAyVRELIZVMCDg==
Date: Tue, 08 Sep 2026 08:33:52 +0200
Subject: [PATCH v5 18/24] riscv: vdso: Enable the vdsocheck tool
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260908-vdso-absolute-reloc-v5-18-3a93791af1cf@linutronix.de>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788849226; l=3596;
 i=thomas.weissschuh@linutronix.de; s=20240209; h=from:subject:message-id;
 bh=rB4eegSBfTJvyEpPR1AwSf8HHKeuiOU4EBXL8/NjovM=;
 b=ckjkIaN/2GD1n4ZD/6VNQXvUS4c8EPXkV5wm26xnc8Ipzseks5mvPh9EdV3eGaQ2tZQZNlGho
 JgbUjoNJu6vBrX5nqStpT8ES8eXNkaNjgeSRWwJDzlvAf1sCbw19+8k
X-Developer-Key: i=thomas.weissschuh@linutronix.de; a=ed25519;
 pk=pfvxvpFUDJV2h2nY0FidLUml22uGLSjByFbM6aqQQws=
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 123E3A0004
X-Stat-Signature: 5gghyg9tei9pwutjbr8m1txdeba8zn3j
X-Rspam-User: 
X-HE-Tag: 1788849243-189508
X-HE-Meta: U2FsdGVkX1+IBJWo52lMxagRNx+zOfVM7Agchky3Gicoc9xoar/mOJLFizs6e8FIpEVVrUl2gl/9WKIR2M1NJccAJ5vVsKaM49zqaDqmkUXu9mw1DD88R6tzlgKSPfonlAd4h8wFfr/Q9Dt2oFs1tZiryTBj4FYyCRpD2fYCw1g+kaYrBOwk9TA/k7UAT0hYiYSd0NTv2bamycOl/d09KqMQeugH88cG0Ib4xTux9Mg5+dP2G7kfj5NkrDJeqitr9IY7zOzQOptos5wk3PHWMN2u53aSz2CMyrzb3MwvrHiTde49b97FVGXNGfHuRyH5Qdm6AFrjSSnffCC6m7UpkhXX8tCO30ZFRXzUIqqHias8aOoZCjGNw6Q8Zt1VDVDGmaGIOX0j1XtkU4z2g/1VkQOoGmm/d2Wb4ferwhwBfIAcjeWMaww9YLFmvRGFNL4hj0ohKI5j6XUj2nfo+N8101jmjLd1c+en/Z7dvWjVeHU2u3Xi9nYA7/991jdmP+7Im7y29Laf6iD3T6V8aDXU5OmfxarpBWdhZFGbZZcYoplEkQVY6fLbcDVqVP1Zpp8ucYZLUhT6ISKBhNZorAUEfuHz2JfZAjO+QSQBHC7lZ1nNaBOTPqMIQ39feh1/59jofhfIFe8To7CXFRKoHPsK1C+XhiUCw9vNVRZG9e9M7HS1E058H/b1HoiIsEwJ+7TKMtZNMv4u+prtNT4uwGKBopSVFAkcFbVnW+Y4bvk8K2tx3G4vxYOCgX5aHEvDg5SLfDLOvV5PGNTyWxOOKFSo7nLem5r79cWSLmEZM6zR/DS2mULniHGi653kSm8JtEAuEr3S+v5N9gNHvqkt7e3FcVyQFqXcHvdiljEUFgAmB8KFkOT7aLEtVKD67D1bgBnoDvCja9wsw0bDMGajD0HXLByqqVZ01S1pxzohFT8ihBu87TMuhyAJE4jesmSylpu3EMpcrLfag+M9BiTUjui
 GrhDP7Ca
 LfbQRL2PCtFadM5mZS1A/JFyN8TuYvBb93+/JwntUAGJ6rFpTBG/pFe8omqW7w7cahDHPkm9og8EerAKbGLoEQERu/oUQf/3TPwJ72JGAa5crUCgzqJmdPafwkxzpYXvkfvMNERok8Tstvpn7ggkHNVuo8cV/srpRDS1lEYnaOhu4DOPBRzdXR59jnnPYO0JPv5ugAX1DrmYBibDEKOjaKpQ4IIE2JBuAQdqbXhEFxPpby0gSm/zP8eRmVOpmmeKf3PinJrTyJ/Rkle0ISPYFRZTArwkeem1zn3DitqRcRJ4mQhAND8F+fC4Vbdy9bWM+eSUqvoVzWMewbg1tzSS5LVZrTPo84SNMUvSqVyXNW2WdcFC9F90yS0iYN6TQ1GjybigVrO6UiKgF5oUChkXx31M4JbiAT5EcroDqyil0AfJeDu8HD34RtdojzJ3oFMsgcIE3978QZOV+58CTlzAfmq/AiTHY11Ed/JPgdC+zq9GuwDHw+aubugqDZtOR+5IJ1svbMcG9W10slEiuyioBWhIQ20rHWv8Z1pUutgh+zj0KolHE63jUPb1DxSuzlMZm4mKWyYUcBBbXw9fgAdnvA0u2Yw==
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
 arch/riscv/Kconfig              |  1 +
 arch/riscv/kernel/vdso/Makefile |  4 ++--
 lib/vdso/check/vdsocheck.rs     | 26 ++++++++++++++++++++++++++
 3 files changed, 29 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
index f8e26c4bed2b..f580d2afecf7 100644
--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@ -229,6 +229,7 @@ config RISCV
 	select THREAD_INFO_IN_TASK
 	select TRACE_IRQFLAGS_SUPPORT
 	select UACCESS_MEMCPY if !MMU
+	select VDSO_CHECK if MMU
 	select VDSO_DATASTORE if MMU
 	select VDSO_GETRANDOM if MMU && 64BIT
 	select USER_STACKTRACE_SUPPORT
diff --git a/arch/riscv/kernel/vdso/Makefile b/arch/riscv/kernel/vdso/Makefile
index 8dbf2532a573..7e707fdff26c 100644
--- a/arch/riscv/kernel/vdso/Makefile
+++ b/arch/riscv/kernel/vdso/Makefile
@@ -74,7 +74,7 @@ endif
 $(obj)/$(vdso_o): $(obj)/$(vdso_so)
 
 # link rule for the .so file, .lds has to be first
-$(obj)/$(vdso_so_dbg): $(obj)/$(vdso_lds) $(obj-vdso) FORCE
+$(obj)/$(vdso_so_dbg): $(obj)/$(vdso_lds) $(obj-vdso) $(vdsocheck) FORCE
 	$(call if_changed,vdsold_and_check)
 LDFLAGS_$(vdso_so_dbg) = -shared -soname=linux-vdso.so.1 \
 	--build-id=sha1 --eh-frame-hdr
@@ -96,7 +96,7 @@ include/generated/$(vdso_offsets): $(obj)/$(vdso_so_dbg) FORCE
 # The DSO images are built using a special linker script
 # Make sure only to export the intended __vdso_xxx symbol offsets.
 quiet_cmd_vdsold_and_check = VDSOLD  $@
-      cmd_vdsold_and_check = $(LD) $(CFI_FULL) $(ld_flags) -T $(filter-out FORCE,$^) -o $@.tmp && \
+      cmd_vdsold_and_check = $(LD) $(CFI_FULL) $(ld_flags) -T $(filter-out FORCE $(vdsocheck),$^) -o $@.tmp && \
                    $(OBJCOPY) $(patsubst %, -G __vdso_%, $(vdso-syms)) $@.tmp $@ && \
                    rm $@.tmp && \
                    $(cmd_vdso_check)
diff --git a/lib/vdso/check/vdsocheck.rs b/lib/vdso/check/vdsocheck.rs
index 429bdcd65818..67562d21f877 100644
--- a/lib/vdso/check/vdsocheck.rs
+++ b/lib/vdso/check/vdsocheck.rs
@@ -96,6 +96,32 @@ fn allowed_relocations_for_machine(machine: u16) -> Option<AllowedRelocations<'s
             ..Default::default()
         }
         .into(),
+        bindings::EM_RISCV => AllowedRelocations {
+            in_object_file: &[
+                bindings::R_RISCV_BRANCH,
+                bindings::R_RISCV_JAL,
+                bindings::R_RISCV_CALL,
+                bindings::R_RISCV_CALL_PLT,
+                bindings::R_RISCV_PCREL_HI20,
+                bindings::R_RISCV_PCREL_LO12_I,
+                bindings::R_RISCV_PCREL_LO12_S,
+                bindings::R_RISCV_ADD8,
+                bindings::R_RISCV_ADD16,
+                bindings::R_RISCV_ADD32,
+                bindings::R_RISCV_ADD64,
+                bindings::R_RISCV_SUB8,
+                bindings::R_RISCV_SUB16,
+                bindings::R_RISCV_SUB32,
+                bindings::R_RISCV_SUB64,
+                bindings::R_RISCV_ALIGN,
+                bindings::R_RISCV_RVC_BRANCH,
+                bindings::R_RISCV_RVC_JUMP,
+                bindings::R_RISCV_RELAX,
+                bindings::R_RISCV_32_PCREL,
+            ],
+            ..Default::default()
+        }
+        .into(),
         _ => None,
     }
 }

-- 
2.55.0


