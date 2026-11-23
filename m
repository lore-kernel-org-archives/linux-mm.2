Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 917E0606A31E
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 13:51:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.a=rsa-sha256 header.s=2020 header.b=42b6mgLI;
	dkim=pass header.d=linutronix.de header.i=@linutronix.de header.a=ed25519-sha256 header.s=2020e header.b=CrCLsvMt
Received: by kanga.kvack.org (Postfix)
	id 7A61B6B05B9; Mon, 23 Nov 2026 08:51:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7843B6B05BA; Mon, 23 Nov 2026 08:51:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F8346B05BB; Mon, 23 Nov 2026 08:51:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 31A386B05B9
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 08:51:29 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A7718408E4
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 13:51:28 +0000 (UTC)
X-FDA: 85466521056.20.5E5D177
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf09.hostedemail.com (Postfix) with ESMTP id 0322E140003
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 13:51:26 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=42b6mgLI;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=CrCLsvMt;
	spf=pass (imf09.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795441887;
	b=5PxPfpRAxbkLuTx37YqsOGFSYmRZPqS4bBb0minfuA1JHTfYJTH27Ft32bM+YnpV5pQytc
	52z7dmORUZjj8gKkEt6twD5S4ah4h0H9882bVzw6qaULFrCmdrbCaEl5JqDNLbRUJ8Avb5
	+ysViAGrlTIWAaREZcBpzMNgbdhlWTk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795441887;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5sFaXvA9vx15Nywpdl3NvvJxA2pf2Qf5PnzQHGb7eBo=;
	b=h8G1NALRM+U3xz1zx7YcwIzTfU031NQ+q54kGmaP2AqFut0h9lUA1mWqpMHcm+boopvg2v
	jz3ECgAsVPn8zRRyScRAsS85Y9Q4gqLxlTDEOxWzS3X9o5nIbYspggUwQVnWX4hE6vbRos
	KUazZvbhH6DSLnXVkTrpx+LytFRVj9M=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=42b6mgLI;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=CrCLsvMt;
	spf=pass (imf09.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1795441884;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5sFaXvA9vx15Nywpdl3NvvJxA2pf2Qf5PnzQHGb7eBo=;
	b=42b6mgLIuU+F+S2GlLo82F+40zks1I3ParrxfhXxOeiIN6CX7YexYDUC6GXnp4UOaHqvmi
	rueKaxZPgopp3WWrMJ9ivOuGql7vhRwqrTriYEGG6ndX0qCscYb7AEbt2PxUU0+b6nd2dt
	wfv5aG5df/oZSAe7Uer72VZhxJ2OefR6UBZSe70z5F0y/CbxpQ7V1nWZp3oBVfwRdZLO6h
	fs1K74tvJ+MturgKOmuh3EXLBvDYjX2hQCbg3oD9KCR2SWtooXWe03M3nNgv719/F8e2Pv
	8nmNDiuItrU+b5v52Jry8B/LzK2AdBpms0G7k9XW47IxNtIOQAyOXvyqIGdWMg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1795441884;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5sFaXvA9vx15Nywpdl3NvvJxA2pf2Qf5PnzQHGb7eBo=;
	b=CrCLsvMtlydLFWCXif6/L6uV62axTpYtX8NNzE0vRn7tBdCToQxzwCjnmsiMVyWxKbawQz
	71CVQ5Tri+gvE3Ag==
Date: Mon, 23 Nov 2026 14:50:58 +0100
Subject: [PATCH v6 07/11] LoongArch: vDSO: Enable the vdsocheck tool
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20261123-vdso-absolute-reloc-v6-7-161e218dd217@linutronix.de>
References: <20261123-vdso-absolute-reloc-v6-0-161e218dd217@linutronix.de>
In-Reply-To: <20261123-vdso-absolute-reloc-v6-0-161e218dd217@linutronix.de>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795441872; l=3278;
 i=thomas.weissschuh@linutronix.de; s=20240209; h=from:subject:message-id;
 bh=M6WFFqo+yQNRSndBT6wB+Qd/XP3diHhHIC/1+2kgJZg=;
 b=vobOCi8V2Ww5CZjhDGPnGtE/6mmXyQIGHbhp4Ye78sY6UcjVcQ9/rdZ4B/0wQ2qV2tFQT+MYE
 GvphsrL4IijByLExRMrAyOXpewMTgTunrbHm4R5e3R48BMFwZ8xmLki
X-Developer-Key: i=thomas.weissschuh@linutronix.de; a=ed25519;
 pk=pfvxvpFUDJV2h2nY0FidLUml22uGLSjByFbM6aqQQws=
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=unavailable autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 0322E140003
X-Stat-Signature: jrtdr9et6kq85ecpmyct4bso8xx8dig8
X-Rspam-User:
X-HE-Tag: 1795441886-49310
X-HE-Meta: U2FsdGVkX1++t/4Zck3v0Fvg2e5WB/4lyT0WeXLU/WVV2QCsz5/xwbnEehp7Ma/pciqhmXzbQMVm4nJJxBy24BaXIIqdsE5ERElVtsWa8PZFxOkhzO/0+vkqWaDK/1UKNC1SiOqCeSWQcZ876xB6vDNBe5tYGHxz7N7OVRhyC/9rDS1GWBS6LDneKWhBP1V9SX98mEZ1Mp5j5ykIZ717HWd8wulHdWCsgFQQ2rf9lh3KotywCi87IOjkanwMFuG+vqFH+19TF+CxQIRTDrqx54M/S1fyuzGwCDsdtLjAkgI6hgvhagHPShh8d+lTDRMG8X+6rT3kp/dH+FjpqOybfhhDIiwVyT3MDkiKbn7A0zI93lJUTybr0dDwXiyW242Y9g8MhVAcCChl3cYy1UiGlR5VBlEsm26zBN+P2hL27go1JTHwAvdBzYLgmEsKUAieEevGeT2qLVa5rnnAj1pj1Qb9rMyJTyCaxHoHC8PXmnaSlefoxaRdC9g9HBre0oMjDJ18UmpRZCkC26Te5ho2CP23LaGhwVsMoVm5AcpxEcEHbhL/kES3GM/0s2TpNnatBXfnLUQ+QpS/Aas0jZuFoFNFVvMPR/zCkQTV/Sz5l2SER5M+S7JdANeiViH8NXOK4d536R51XmtIOBgG2zJMgnFVKL9PAq5MYzo3pNEmEDmJJM8HtG6fpYNqStB6wiYnE1UCO4FmH4b4G87GIZlN1iVqL+r9tDuq3arrXI0Q5HRHBjbueQ8KPhpsS5y+wQSu6Rknc66RF+nZKjWO+SmXUhZOgzX1KBnjqEkTQx+of1MuZlOg9Y8C0DaUfWzjqHOPRiaysKX6BasVMt1RKE630YslxrdYmj1DliOWcji0O3xCehhVWZCKEpRgJbRGbqv/OqiaLYo/C30NuSNmayd5GA+RFUxZd99wlc5kr9111GiP32unbO3FTa1n1YMTLKD5sdw8qtjxJwpgKjqwgJs
 rv9iag8s
 Mo1NpweoDZiWz30MNQoCSL+ZiDc4600EX8yiw18j3wUv3d3AHdylA4h0Uou2dFI07uiBz5SpNl2rxk9PPx/mLrkpBRPBoasFu7Pj7I5CUkvaoghm05hveR3BXtu9/Txu2ec9P5N/qYBeoiMDTopUh1hg6QBoh0oOtPWWD+hlseMH+SifpPdHNBL2rotnsee2TRfqreXrc/ZcoxmK7KJdAUJor0g4msx1q64fQLPpGvUDJOsyaObiFDzhNcbmYVauOlqN6Y4phQRmsZUii8iUsPwjfiaT5/oJT+Wdz6aSXjDVNi/3sBGa0NS7wQ0FK/4BPScpNcNTET7cymcVLqe8e40xipxX2zYVkFya+auhTVZj/Gfv3Ufpt96bHDKqIbZigclU14Y2pnHqgPf96jmiKh8bqnYO+qN6gowjKF9JsvN4MwERV0hLloY+ocKO5bzQZxImbJWcAqCEweGcZiIHagyc9Um+yisy1WXMu9e8+faxGQBaX7WwVtrBYaSwZ1lyAtqAv1bFxnwUErUceyNydgJjQSoehPrIHFVvijaq7AFhGVqRCDU1krCa2j06kbEXRtfcdmsHwqcBf23sufleV7TN7RXyiCwKzYCzUPD6tpd2CvJmozcPdzugRpKvw5M0sUQOUFHH7I1iAOVf1X4Ezyr/06exkBDiyqtJl9FQF3Mc1NM4I12U1xHW0hTd1r+hThqJedNGOwHbqjv4KXUrKwMo+p250BFTtFgfpqPqEYHTVBPF5qv2gSCCY4Rkd9wi/oJ0r6ei5juE5oNg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The vdsocheck tool validates the object files and final .so library.
It can detect if the compiler created relocations which are incompatible
with the vDSO which need to be worked around.

Wire it up for the architecture.

Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
---
 arch/loongarch/Kconfig       |  1 +
 arch/loongarch/vdso/Makefile |  4 ++--
 lib/vdso/check/vdsocheck.rs  | 26 ++++++++++++++++++++++++++
 3 files changed, 29 insertions(+), 2 deletions(-)

diff --git a/arch/loongarch/Kconfig b/arch/loongarch/Kconfig
index b5ed4881d3c0..ad4cafeddbb8 100644
--- a/arch/loongarch/Kconfig
+++ b/arch/loongarch/Kconfig
@@ -211,6 +211,7 @@ config LOONGARCH
 	select TRACE_IRQFLAGS_SUPPORT
 	select USE_PERCPU_NUMA_NODE_ID
 	select USER_STACKTRACE_SUPPORT
+	select VDSO_CHECK
 	select VDSO_DATASTORE
 	select VDSO_GETRANDOM
 	select ZONE_DMA32 if 64BIT
diff --git a/arch/loongarch/vdso/Makefile b/arch/loongarch/vdso/Makefile
index 0b84892d084b..ad54383b1908 100644
--- a/arch/loongarch/vdso/Makefile
+++ b/arch/loongarch/vdso/Makefile
@@ -51,7 +51,7 @@ ldflags-y := -Bsymbolic --no-undefined -soname=linux-vdso.so.1 \
 #
 
 quiet_cmd_vdsold_and_vdso_check = LD      $@
-      cmd_vdsold_and_vdso_check = $(cmd_ld); $(cmd_vdso_check)
+      cmd_vdsold_and_vdso_check = $(cmd_ld_vdso); $(cmd_vdso_check)
 
 quiet_cmd_vdsoas_o_S = AS       $@
       cmd_vdsoas_o_S = $(CC) $(a_flags) -c -o $@ $<
@@ -80,7 +80,7 @@ $(obj-vdso): KBUILD_AFLAGS := $(aflags-vdso) $(native-abi)
 
 $(obj)/vdso.lds: KBUILD_CPPFLAGS := $(ccflags-vdso) $(native-abi)
 
-$(obj)/vdso.so.dbg: $(obj)/vdso.lds $(obj-vdso) FORCE
+$(obj)/vdso.so.dbg: $(obj)/vdso.lds $(obj-vdso) $(vdsocheck) FORCE
 	$(call if_changed,vdsold_and_vdso_check)
 
 $(obj)/vdso.so: OBJCOPYFLAGS := -S
diff --git a/lib/vdso/check/vdsocheck.rs b/lib/vdso/check/vdsocheck.rs
index 37455d326110..7952ad6ba72b 100644
--- a/lib/vdso/check/vdsocheck.rs
+++ b/lib/vdso/check/vdsocheck.rs
@@ -122,6 +122,32 @@ fn allowed_relocations_for_machine(machine: u16) -> Option<AllowedRelocations<'s
             ..Default::default()
         }
         .into(),
+        bindings::EM_LOONGARCH => AllowedRelocations {
+            in_object_file: &[
+                47,  /* R_LARCH_ADD8 */
+                48,  /* R_LARCH_ADD16 */
+                49,  /* R_LARCH_ADD24 */
+                50,  /* R_LARCH_ADD32 */
+                51,  /* R_LARCH_ADD64 */
+                52,  /* R_LARCH_SUB8 */
+                53,  /* R_LARCH_SUB16 */
+                54,  /* R_LARCH_SUB24 */
+                55,  /* R_LARCH_SUB32 */
+                56,  /* R_LARCH_SUB64 */
+                64,  /* R_LARCH_B16 */
+                65,  /* R_LARCH_B21 */
+                66,  /* R_LARCH_B26 */
+                71,  /* R_LARCH_PCALA_HI20 */
+                72,  /* R_LARCH_PCALA_LO12 */
+                73,  /* R_LARCH_PCALA64_LO20 */
+                74,  /* R_LARCH_PCALA64_HI12 */
+                99,  /* R_LARCH_32_PCREL */
+                128, /* R_LARCH_PCADD_HI20 */
+                128, /* R_LARCH_PCADD_LO12 */
+            ],
+            ..Default::default()
+        }
+        .into(),
         _ => None,
     }
 }

-- 
2.56.1


