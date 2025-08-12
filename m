Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CF79C87FCB
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 05:46:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4ECAD8E00D9; Tue, 12 Aug 2025 01:44:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 44F568E00BE; Tue, 12 Aug 2025 01:44:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2EFF28E00D9; Tue, 12 Aug 2025 01:44:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 170CF8E00BE
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 01:44:55 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CB38856B54
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 05:44:54 +0000 (UTC)
X-FDA: 83767016508.02.8122E05
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf26.hostedemail.com (Postfix) with ESMTP id DD179140006
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 05:44:52 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=W4p1ENmO;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=QpnJaONt;
	spf=pass (imf26.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754977493;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7OxEAzTtqHlqZSqHBtrTk0yqq9zTf8Alol22rb21E+I=;
	b=YqEnGclWfB0jKgETlS5zCSG2gdRR/uC2REal3A5PcNX1E70iS+agKXA5JlNjxF7HR7qqh+
	PQJIAkF6TTScYHW3bD3BSkaSyWHsPj9G9zV8BZzsxwh3XOCPgh0JHe4Cvoq/IXGRqngnDU
	TBCpIyxpInXyq5VNV4Z6WM4NYJGVxmo=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=W4p1ENmO;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=QpnJaONt;
	spf=pass (imf26.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754977493; a=rsa-sha256;
	cv=none;
	b=DIjy2gC5J39zRK+fX/+AkeXRCduhCB91D6pJvin3BrQUMROtPI9dYq+KUqytblyLxkr9TK
	iLTIMMffCSScaeAnDOYHcfP4PRQoX8+FCfpITp16CYqC4LedYb7OD8SK0MrOqZo5CEh+P0
	CoobyfXETFNYO8YNMOW1XDRV5ERXpy0=
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1754977480;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7OxEAzTtqHlqZSqHBtrTk0yqq9zTf8Alol22rb21E+I=;
	b=W4p1ENmOvzhLntuYnmqtfute0yp4ze1Q3QiTPF7vb/qMHZT5SVeS3RyfuZ6SosfWMYDc0u
	JMs2EcuwR9ToS+OHSfJMxVN95EcXvMbyX+YnwaBPnk20szUrj7SZvB0qQ8Cx5Ud5jPAbu2
	bSAJPE5T0rS2fD0/jpIO5X9vO5nsQl5irPEsTaTy8WcaVOVElHdD3sISZQVcrKhBVlExNd
	qTlZX8uubN2zgJ0d7g5ExfmZvs1NHebFGWrZVOZILEEoNjXxH0F5ugP5eD9/q2m/JNoopP
	0ooTzzrCPKkGvpwsCRPbNEQKYYZENwH0BDcIHI3be78GBTu1L+fTyldKzt7yjw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1754977480;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7OxEAzTtqHlqZSqHBtrTk0yqq9zTf8Alol22rb21E+I=;
	b=QpnJaONtWulvcUFE59iWrSqLfGPXVLdmPDToQjRzK9BRDs9j+IGPmHbJrdEtNraqkyxN0t
	5141JOl9oriQWEAA==
Date: Tue, 12 Aug 2025 07:44:32 +0200
Subject: [PATCH v4 19/24] riscv: vdso: Enable the vdsocheck tool
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20250812-vdso-absolute-reloc-v4-19-61a8b615e5ec@linutronix.de>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1754977469; l=3732;
 i=thomas.weissschuh@linutronix.de; s=20240209; h=from:subject:message-id;
 bh=J1qM3HCNoG+4ABOAGIaTnVMGxz4Bh3uAYRLzvmLM14o=;
 b=SMRN/ewBWi/CqhkM5mbxFTaVrjrIEecZQJUkuNqZN8Bo84iaFqx4d2EMZvQHzBbVdI97dTqOc
 sZpouIgjOvkAwh1E9FDdFMfyd5/kLUV2gBS+vHirscTGDXTVSaTLPv6
X-Developer-Key: i=thomas.weissschuh@linutronix.de; a=ed25519;
 pk=pfvxvpFUDJV2h2nY0FidLUml22uGLSjByFbM6aqQQws=
X-Rspam-User: 
X-Rspamd-Queue-Id: DD179140006
X-Rspamd-Server: rspam06
X-Stat-Signature: z6kodwfepixe19juno8m1a8pcndgkxij
X-HE-Tag: 1754977492-174033
X-HE-Meta: U2FsdGVkX199aiEBQulkx9lCt9mkmMkSwO/aaTJjdwihA1HKC+avqC/LWTYgPTiCRcS5p29H1+zihiQAMM02kNeuSZ0jjTXXzUe7K/0gMh3B2waNUry2yeBdoWJ0UsTcHrhqlnQxxBkFlnRcoiFWV0n33hsTevl9B6J3qIIwky8C2pNXhTdyDHGwhTE1Fq6ChKq18K24XszUhETXseagcgBFQE9Zesc5C/0TBKNpPadmACDn/qyuyusXjyvKqzcd6gPGsd+hV7C6Ua0EYeX7r6VA/LMCMzc8rbNi72ihO03izLkJ4/JSYUMtWmFTgnVT+P2IG31Lx2eCaUztW/bHscYPyXMU62aLNmRw9/KeBqM9IKEzhOELqS7bnjVcu3LmqweNxU4S87HKoFgylpAP2c2IQUZIK+jfvbz/QayfTO2lMFiMgcd++S7L3vWul2vtWVrFzOGAzQ2oIIoXrmU/ehVQNZfRA0eJIc3MX/ipcONKuuGQOAJfKzkOt94gwwe11SSlV4W4GO0TqdK0cw+QevCSiM0IY6kxtWFRLqUuu+ufkqECCF31cpvbC4MpBSQSq1Lrb5sKBE/f8LtlJJxB6Aqt3wPuDHzqUZQogg2SuqINPGLfUToOkcFsrTTNvtm4AtH8vPA9tDv87CXQjhoqipVhhzMYQYlhKWXoE8RfEyNCHXH3i0tB/IYa8o/rwt/2CTYqe47Ju06Qy5v1xuzzRxsnHId+kth097Tfn5AQoTIVajO88N3yrOLOO9MgwBRJ994vOnuMHdx4BuN0zcPnybn2KVXgQqt21bdzorEUOftihqQBhzMIdHzVqZkQaUPH0SJiavhOdhq+N1z9eyqnDAVmJhr6q2WCCpkNRUriXmPIKLWBktsHxwhVXqqFxphIXovJiSb4kwZkQgy3m+uxaJt3W31fGlKxKYBQzZY5Q2mWgOQeLaksN/Yt/DDOQJM0BYR0Fap+X9Sg8vPeYTM
 Hfat4w7N
 04mxANEGsIqNnTng0SZso9sAFS6NihoXqbrO6z/tJHpP0IHR1c0MPZ4fauTm53yk0mrUussYWEuRETE6KOwb/C75nJ/Vrm/EXBmKoaxj2L6DzbMbu/2IekRaNqIDJoJfUoFk7v2x/ZePyy24KMUNKz2SO9Orhw/Ec7BAGmdAkKVd4CFCcoEW9QDIx/SBcwy2nhI7mH02jNm/5DQp5bAaAVoPQn2aamFS1D64dGCwp05TGRrqvv454hAL5Mo3I6Ry0BEk7CvZfurbB5oHUCqCKPxstQS3dmyF4V+d7cUPn03u3bGyqdBa5c8KHb3ZXLGv4bE4oTC+DSwdQrLulJluyIuFNUgtAFmlV/INM9zKpiXqae7jaTK5MjzIBtZ0EgjB+xVHSnBeW9olEY6xZwazewEi4si2i2+pXtwr3s7HGD6Z74Capcq9hQKlMHhzCSXJ6K1647T6/eOZ4eRN1HA4B5qxLoPoQExq7Y67UBvpkwFBI2bmVC8i40KoVmRiCNW3Di/Aj
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
 arch/riscv/kernel/vdso/Makefile |  4 ++--
 lib/vdso/Kconfig                |  1 +
 lib/vdso/check/vdsocheck.rs     | 25 +++++++++++++++++++++++++
 3 files changed, 28 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/kernel/vdso/Makefile b/arch/riscv/kernel/vdso/Makefile
index 9f1bf5bae9bd473e43d9fd3022e9e1a185128b73..05725a72eaca70a867f59c352a6381402e91c317 100644
--- a/arch/riscv/kernel/vdso/Makefile
+++ b/arch/riscv/kernel/vdso/Makefile
@@ -58,7 +58,7 @@ CFLAGS_REMOVE_hwprobe.o = $(CFLAGS_REMOVE_VDSO)
 $(obj)/vdso.o: $(obj)/vdso.so
 
 # link rule for the .so file, .lds has to be first
-$(obj)/vdso.so.dbg: $(obj)/vdso.lds $(obj-vdso) FORCE
+$(obj)/vdso.so.dbg: $(obj)/vdso.lds $(obj-vdso) $(vdsocheck) FORCE
 	$(call if_changed,vdsold_and_check)
 LDFLAGS_vdso.so.dbg = -shared -soname=linux-vdso.so.1 \
 	--build-id=sha1 --eh-frame-hdr
@@ -80,7 +80,7 @@ include/generated/vdso-offsets.h: $(obj)/vdso.so.dbg FORCE
 # The DSO images are built using a special linker script
 # Make sure only to export the intended __vdso_xxx symbol offsets.
 quiet_cmd_vdsold_and_check = VDSOLD  $@
-      cmd_vdsold_and_check = $(LD) $(ld_flags) -T $(filter-out FORCE,$^) -o $@.tmp && \
+      cmd_vdsold_and_check = $(LD) $(ld_flags) -T $(filter-out FORCE $(vdsocheck),$^) -o $@.tmp && \
                    $(OBJCOPY) $(patsubst %, -G __vdso_%, $(vdso-syms)) $@.tmp $@ && \
                    rm $@.tmp && \
                    $(cmd_vdso_check)
diff --git a/lib/vdso/Kconfig b/lib/vdso/Kconfig
index 8994419d90e7b5c66ac77449b6c3bd96c968983d..441ff03e1028f7bde5104bd01941c6a9b006e21f 100644
--- a/lib/vdso/Kconfig
+++ b/lib/vdso/Kconfig
@@ -55,6 +55,7 @@ config HAVE_VDSOCHECK
 	default y if ARM
 	default y if ARM64
 	default y if PPC
+	default y if RISCV
 	help
 	  Selected for architectures that are supported by the 'vdsocheck' progam.
 	  Only transitional.
diff --git a/lib/vdso/check/vdsocheck.rs b/lib/vdso/check/vdsocheck.rs
index 54372a547b1cde05c1a4454b9a21de357b22b0df..d48c9da6f18270afe883d167955f73f061b9c472 100644
--- a/lib/vdso/check/vdsocheck.rs
+++ b/lib/vdso/check/vdsocheck.rs
@@ -90,6 +90,31 @@ fn allowed_relocations_for_machine(machine: u16) -> Option<AllowedRelocations<'s
                 bindings::R_PPC64_REL16_HA,
             ],
         }),
+        bindings::EM_RISCV => Some(AllowedRelocations {
+            ignored_object_file_sections: None,
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
+        }),
         _ => None,
     }
 }

-- 
2.50.1


