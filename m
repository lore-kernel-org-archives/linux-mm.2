Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE1AACA0EC4
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 05:46:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 932588E00DA; Tue, 12 Aug 2025 01:44:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8BC318E00BE; Tue, 12 Aug 2025 01:44:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 75D928E00DA; Tue, 12 Aug 2025 01:44:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5C8028E00BE
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 01:44:56 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2FA911A01C8
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 05:44:56 +0000 (UTC)
X-FDA: 83767016592.11.ED5BC79
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf15.hostedemail.com (Postfix) with ESMTP id 59ECEA0005
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 05:44:54 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b="y6kJZp/a";
	dkim=pass header.d=linutronix.de header.s=2020e header.b=NXZQJgvp;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf15.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754977494; a=rsa-sha256;
	cv=none;
	b=JBxnSXKoZ90C1+9FYWms1XjfmDB8XFGhgbf8Gn7rjUDjX3e48ouEqj7lrGmx7stWjbP1Mz
	LsEqfcyFH9sW9QWpgxzXnIB1M+3CIeQ1vLfGlEVCWF1CRtzdOv/qKX9u7UBlloO6WbIdwQ
	Q1aSZHS47L/vgH3HEl9mndTxH+sRHfc=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b="y6kJZp/a";
	dkim=pass header.d=linutronix.de header.s=2020e header.b=NXZQJgvp;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf15.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754977494;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Mxk1j7bQVP7gkeGhqiBaJTM8Rt+qR7YGqcRddWJjs3Q=;
	b=BdjAsnrG9qPrZw+cWAdd4c3Qixq3ZgMRAFQgxC4QLequPdA50vv7VlY1qCadmEoiPOE5vn
	ZYxGIigfWdVr3AGe2yTkeyZN/rORN6zKAdDV5jO/n9kQZkA8Dw81Ln72fV8eE8Vw4yd47u
	vf131gc49wwu1JIp9wvkWkAKqqS1dmU=
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1754977480;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Mxk1j7bQVP7gkeGhqiBaJTM8Rt+qR7YGqcRddWJjs3Q=;
	b=y6kJZp/aMepqZyqIpu2Ge7fuGhIrg50IqAa8/kDWQydm7It5QCDOz2yKzkQ3nTVNspTLSa
	0Z4k7oD1Q+xCqfzj5lYWkxPTS1MmOTr51kIJLK870+GnX/yGOhUkdCBK3uwWNwW6iPZVQC
	tgpAkrU7Zb0EAA6ZRz5RBZ6MPFx1SbJhfTBFQA4FevsFC+l/Zzx62GlvL4c5g3ZKDTbJWh
	7bvJslx0+0Y9/A2L7wtCdcBkbz4Hhs6lfksVYdjmQ5h4IYF4Bv1fx8akKwgCXeg+i8kq/k
	X4D8gv59NZLmB7c4EWhKN/Uxh5AX9lhl4fWV3oXKTC2YK9nd/9yxz6HJGp2oAA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1754977480;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Mxk1j7bQVP7gkeGhqiBaJTM8Rt+qR7YGqcRddWJjs3Q=;
	b=NXZQJgvpthSi0X2yy7bk/mKr8cSd4B68z61qxsqtB551PCUPMszU49Btx/qpuXPqLXGzsR
	LaQJ4RnSqXSXw+DA==
Date: Tue, 12 Aug 2025 07:44:33 +0200
Subject: [PATCH v4 20/24] LoongArch: vDSO: Enable the vdsocheck tool
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20250812-vdso-absolute-reloc-v4-20-61a8b615e5ec@linutronix.de>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1754977469; l=3338;
 i=thomas.weissschuh@linutronix.de; s=20240209; h=from:subject:message-id;
 bh=1IZrubHrqMbaFtOk3hdvCwRPSsl7pLGR/UJMuiLBbOY=;
 b=LqYg38rSkBwpE7p9p2L9QYuv0JUyTLtER245hHstQoHs7MiLUh2lPURSIZcAihCYxsat6bpQV
 An04KjctmxQDRVzmaoiEcTtq1AzmJcVR/h2OWecT6+BVOcWz8b8Wtr+
X-Developer-Key: i=thomas.weissschuh@linutronix.de; a=ed25519;
 pk=pfvxvpFUDJV2h2nY0FidLUml22uGLSjByFbM6aqQQws=
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 59ECEA0005
X-Stat-Signature: a7j1k8911r5oyxmzeuhomghegpctngba
X-Rspam-User: 
X-HE-Tag: 1754977494-512971
X-HE-Meta: U2FsdGVkX18EVfnKZJzWZZAp4cyt9bU8HXl/BV4ZoOShTj8Hh+o1NEwP7aYqfKmAwJ/T9GVYj8tP4Hj99t0YBDJEj0oUTGBQK9uNmt2KHcJiO2crh14/YYSx3LM7LCq6wk/tP4HKKBh9cYCRNSsNEmWnL0geqvRD0xdHZ/POnEJv6VprZG0lHxfSZN2XAyTdwAo4oMlEh1K+5PQKFku35Waa4U2Bo7NB4tUuSk/jclYsMszhIkQdnOecS9nC0/FO3akkjEvhVIzgQMhNe996NGlNQa9pa6k3iA09G0g8CbVwMpmEybjFCZ14yoQavdb/uKo0so2Hm6AwNkOnX3rorifyRcqy501xkF5y+NHzS1hevbUrNc/5AL4gVGgZvYaP791Kyp/0a92BLIFAY0WFdyrbpDmSHoBZRb1DTcRej4Sh9Tv3zS2BefGTsWYcsTFcT+ei5ss9q493fGOuqhN1YF52HDbD00nx3DqN9XDCzDuZ9yUzLA4M1N+ozndZkw8N5he5H3KpmsXT+Yhaa80E8SlsH59+FFEocIfWtu9K2/gHoGZaptyZyyLDdwivxiXT7UPh2VwtPTGrcWYz8oCtJLvCvGLvGWHw5Ofr5aPHH5pVXyOdlVpZFw7moGcp7YFuLZWUzOH+iXlVQA9gLTRurw8bYoytHGYdLLnEo66Qyij7LyLh36SCA4oGm3KBt6bH09nB4VJJBrPNxQf6QwMLagCPgDV3WquOJexNsiElgBBQ2JsZbRKtaIRBYO+xVBZ0WTA8uLPPVQBXFz/vPQ12oSE/XZvKdIOi5Mm546p0AsfOl07ntLQqzSEUmJ7YtujNfWomj5D/hCQHO077/79+6uUrZbjeXYd25ilGdXdlTUB7xslo5UBQ793pBOmZEMehcxIt4yLKtjg/BxBAUAwcdkX014Fj3kOTEaqRkLPhIJLXkf6r81Oc3Fdv6WJEI+V5TfWCXCt4VssBhLJls/l
 maps/jGG
 f1+pVfhx/Rrt4e49QOFK4IxhfwOmhEbY26BVY8gbx5dIcDGTXMuKs4NmoNBHzKcsUVOAzZPKmemkjrZxg3EVoIBfKiqaDU9ZNoyV/qyyJDUdEVoP9fC8/APiLga01X5AGHutvtx1BvQ3EnC7TzZ0bbPKAqhLpJw4/4CZcqG7TTchFc9Q1nrZ9rucGGDy79vn+BqIWEJV4VeDyhtIUxR1ureP62qj1Kg/7bwfOWIKArmjrCKTqza/f7ItXp89R//QUmsXtTRi1/vGNfzzrpYGgxWh5RSaBnWPehrpX9kYRZ0UJM5Fca5w0psZu2SpCRVgDgDG52niWeG9w+WX8B6RnjoHhQLwDf9vGAqlLo8fAkET4dJAIcPxGCUJ2+qbOaeAMecPGSSnyXcAsPH5zfNwG3vQHUyPdTvZRzAJL8344x+ljWVG9a2j5KDPr0Xs7vv04ISsBIYwY4OwOUgm3W0arzdMBHqczvnETBqcCa6YL9nknP+YbU5rO6kkktzwZsGnm1ABq
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
 arch/loongarch/vdso/Makefile |  4 ++--
 lib/vdso/Kconfig             |  1 +
 lib/vdso/check/vdsocheck.rs  | 23 +++++++++++++++++++++++
 3 files changed, 26 insertions(+), 2 deletions(-)

diff --git a/arch/loongarch/vdso/Makefile b/arch/loongarch/vdso/Makefile
index d8316f993482406c2633b49b1daa475fc415a82c..a9b1934dce7c821df96e636a9833e70f22ee1b31 100644
--- a/arch/loongarch/vdso/Makefile
+++ b/arch/loongarch/vdso/Makefile
@@ -43,7 +43,7 @@ ldflags-y := -Bsymbolic --no-undefined -soname=linux-vdso.so.1 \
 #
 
 quiet_cmd_vdsold_and_vdso_check = LD      $@
-      cmd_vdsold_and_vdso_check = $(cmd_ld); $(cmd_vdso_check)
+      cmd_vdsold_and_vdso_check = $(cmd_ld_vdso); $(cmd_vdso_check)
 
 quiet_cmd_vdsoas_o_S = AS       $@
       cmd_vdsoas_o_S = $(CC) $(a_flags) -c -o $@ $<
@@ -72,7 +72,7 @@ $(obj-vdso): KBUILD_AFLAGS := $(aflags-vdso) $(native-abi)
 
 $(obj)/vdso.lds: KBUILD_CPPFLAGS := $(ccflags-vdso) $(native-abi)
 
-$(obj)/vdso.so.dbg: $(obj)/vdso.lds $(obj-vdso) FORCE
+$(obj)/vdso.so.dbg: $(obj)/vdso.lds $(obj-vdso) $(vdsocheck) FORCE
 	$(call if_changed,vdsold_and_vdso_check)
 
 $(obj)/vdso.so: OBJCOPYFLAGS := -S
diff --git a/lib/vdso/Kconfig b/lib/vdso/Kconfig
index 441ff03e1028f7bde5104bd01941c6a9b006e21f..0fe70b3604f9925ef8c5608bb4cac24d3a28faab 100644
--- a/lib/vdso/Kconfig
+++ b/lib/vdso/Kconfig
@@ -56,6 +56,7 @@ config HAVE_VDSOCHECK
 	default y if ARM64
 	default y if PPC
 	default y if RISCV
+	default y if LOONGARCH
 	help
 	  Selected for architectures that are supported by the 'vdsocheck' progam.
 	  Only transitional.
diff --git a/lib/vdso/check/vdsocheck.rs b/lib/vdso/check/vdsocheck.rs
index d48c9da6f18270afe883d167955f73f061b9c472..93819f668d8a4f623f41403bb09b42c4aec2c8de 100644
--- a/lib/vdso/check/vdsocheck.rs
+++ b/lib/vdso/check/vdsocheck.rs
@@ -115,6 +115,29 @@ fn allowed_relocations_for_machine(machine: u16) -> Option<AllowedRelocations<'s
                 bindings::R_RISCV_32_PCREL,
             ],
         }),
+        bindings::EM_LOONGARCH => Some(AllowedRelocations {
+            ignored_object_file_sections: None,
+            in_object_file: &[
+                bindings::R_LARCH_ADD8,
+                bindings::R_LARCH_ADD16,
+                bindings::R_LARCH_ADD24,
+                bindings::R_LARCH_ADD32,
+                bindings::R_LARCH_ADD64,
+                bindings::R_LARCH_SUB8,
+                bindings::R_LARCH_SUB16,
+                bindings::R_LARCH_SUB24,
+                bindings::R_LARCH_SUB32,
+                bindings::R_LARCH_SUB64,
+                bindings::R_LARCH_B16,
+                bindings::R_LARCH_B21,
+                bindings::R_LARCH_B26,
+                bindings::R_LARCH_PCALA_HI20,
+                bindings::R_LARCH_PCALA_LO12,
+                bindings::R_LARCH_PCALA64_LO20,
+                bindings::R_LARCH_PCALA64_HI12,
+                bindings::R_LARCH_32_PCREL,
+            ],
+        }),
         _ => None,
     }
 }

-- 
2.50.1


