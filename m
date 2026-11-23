Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 259BA606A697
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 13:51:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.a=rsa-sha256 header.s=2020 header.b=NuQxcyBf;
	dkim=pass header.d=linutronix.de header.i=@linutronix.de header.a=ed25519-sha256 header.s=2020e header.b=Ee7e9mzF
Received: by kanga.kvack.org (Postfix)
	id CD7336B05B6; Mon, 23 Nov 2026 08:51:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CAF236B05B7; Mon, 23 Nov 2026 08:51:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B50356B05B8; Mon, 23 Nov 2026 08:51:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 851CB6B05B6
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 08:51:25 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2417E1C3C76
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 13:51:25 +0000 (UTC)
X-FDA: 85466520930.29.DFA6CF6
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf01.hostedemail.com (Postfix) with ESMTP id 4652D40003
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 13:51:23 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=NuQxcyBf;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=Ee7e9mzF;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf01.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795441883;
	b=40OoRrVi6mFCrfYIVjyILUVuNyKNlYGxSdQ9dQs0LHCxizzw3YADWv/wKdqABfSnyt4g6l
	LENzi7K1rrLFJMYCc+QZpNZX2OUedj0VqthvdelgEBk8gqjnTm7aH6fALdA1C1vGs+wgyP
	5Xhl2Qh0UJILfiCTK6Jvu0d9Uc71TLw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795441883;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Guhg1K0FMFBPE0u0CIJl3O+ZgtOjrn7cr+GEqqxWqko=;
	b=2TTSr/FcSCV58zdzagdN9DyltEh6IHOpVxaRHPMZnrSDFhendVjYC+qKbx86dDnD7rlxNS
	93QLuyXagJ6Bylf2Yv3gAyJ7RSTqbpOJElxMa2rOmdjLtUF1Dv49801i5Lc8LfC7gyQ5/S
	jlsAE5GzLpCV53JMd9DKIr2iiEVbfOM=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=NuQxcyBf;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=Ee7e9mzF;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf01.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1795441881;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Guhg1K0FMFBPE0u0CIJl3O+ZgtOjrn7cr+GEqqxWqko=;
	b=NuQxcyBfhV7EAPhhJJ0IrWwI8Sg6agHEvml/ui+39lfH4IvCvHOhVb3sTcEszxrptDYhzM
	KOTWGp0s724CoC63fsCVglfZK3pNCVB8Dpc4O3J+oZJetwugA7rRVDeJweiqPTc8fFxGvo
	RmhJHmEu3rwm40c8zSLI4bxEI1qi65sJ8cASKE5pWCVY38ce3oB6mbJaStD5r9bHbVd18/
	R42vVr0ltwptVz13BPAw5JmRofzhPG5tYJKVGp3gS5RHItjXpfpb6NKiTXVnBsh/nC0c3b
	8kgM8WRRit79N6lKDO5GVLdWFOxuL3Rdld+lG35LGAQjhk+TpvfZuqpuvy+zig==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1795441881;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Guhg1K0FMFBPE0u0CIJl3O+ZgtOjrn7cr+GEqqxWqko=;
	b=Ee7e9mzFD85deKLGcm8e5YD0L+U1o17HaFbybIhTLTjFkWWkRB4gFePrbUFQEhupkaPgbn
	0vbj4CqmhgO4CrAg==
Date: Mon, 23 Nov 2026 14:50:55 +0100
Subject: [PATCH v6 04/11] arm64: vdso: Enable the vdsocheck tool
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20261123-vdso-absolute-reloc-v6-4-161e218dd217@linutronix.de>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795441872; l=2617;
 i=thomas.weissschuh@linutronix.de; s=20240209; h=from:subject:message-id;
 bh=ORz4l21C1iPuk7FCAsvH2byEFW0UweMz0824cCTy53M=;
 b=q7DXOLJiNCyz2OBeq2mHIOnoqJ70WoExeUnEefxSG/lSMIqTsqHDcIrncJ9VEiIXA1Umw12+U
 OOQlmf3HB4zBZUGjar3eMCLr8sFDPZAeV+wIvbVyQBy37Hse7yPcaaY
X-Developer-Key: i=thomas.weissschuh@linutronix.de; a=ed25519;
 pk=pfvxvpFUDJV2h2nY0FidLUml22uGLSjByFbM6aqQQws=
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4652D40003
X-Stat-Signature: o33srdim9ddcmgknwuehij15gpmnjm11
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=unavailable autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795441883-664757
X-HE-Meta: U2FsdGVkX1/u0rAfYa4wFUg6G2qsEDSxe5wmCVw0ZhfiK+TmIpOMwoO7KoCOFsLT8D8k31j1yJ261dpGtIoVi4oGVpfYWAdYSIC+vasOUAgPGOy7HuqnqPAm9SC0Mm9gMN6ycDwcs2Ti7y5iKtYgfaSgLg9NQ4sLW/ozR7jLV0UzYwOg5yUsdTytX2y5ZqZpMwsEUnw5C/95TxuajdC8RUd0DjXT5ljV2B3Gw6LSiqYyksqj/PoTMVhftzNMM2kYJWwZDG0L9SedBUreqWiw5ObPi11dvgBVJTzs9SYLKozuAn9i30Fzrs+WI/s0RR4fq9f03m1yBQAmyIiP5zeNVuiHEjCfR2o4g3JnNj3dwJ0WlDwCqCL4o6J5S+9W3ud8ufnZXA4m25GzlODX2RAKr3R8u+CIn721EgRcKBPN3MhHW4qAJqCHFd0IufF54Ruj2jvYs33Voptf5Twob6Lty8BVin/F8eYfW82EZI5hahkyFxajAK3LFp6gaPq0rxJ3evebd+zCOaqWyzh3vA60Rz3LmXBxbf5pUCQqnAbo2ipYsNyZrV1RtRlXlLpEUZ8AMSjLKAwyzG9tXLFj3kwD+y9ZOgqoMZAF55kZsBDq257YnhPSWnVu69LKg9UbTrLMeX1e6dCi3R/uMYQbDghUEuVeXl/2BIvbNk1UQb3dTpw6cOb5qyVvgzCkzI3cZFHEArQAEsCZPZu0NpZ4k9AjnxZ4SX4uMBV+800g7wwIqUCF4UsSsIP/HnvH4Gqb8QqO5KEb/pINlFxNFJQxmdTBR7fXh0FrkZwyrrHmbDTCVUo3SghVr58j9OWnGKq0LJGpfb9Ax0eIJoCFUUHYdeUWrlrUODFmVlnUKEObMl5/sUzANugwJr5nyFloHSctucjsFZd3Ph9Msvy5RTKPuDn2+Uclx/m4+Cj5tK4NS2GVijju4/3i8LZWAAwonFowN6sPpmnX0Xn0edLkdHC6w+E
 UniHtTS4
 IMTmH3Ld5Mfrk3lmEkEpz5xo8ZASN2k43LHeKs27FrUOztSiNcnpsEMpsbnI7bTJmNJxwj8btGLgRAJkq2JCb9sk5qr8vGtwSKhQJOzUADlx9TUl6QgJh6cPe7jZi2hGppuu8UGDzisoT2AwyA9sYFhYdssoKIIsrVlPoz99FkNTbZVGa6Ch+b13hZP1Z4Mhe5+KdyjxFeFaYC7pnb/uPioP8a5LSbiQep4JbuDWGPB/cPOgbyXudnmIj8gUBMZjedZVaJ3h79JyZxIi7rxSEfYkon2oKzAtzvlEGbgJ8ZhRdBv/iaE2O6WwrlLuqrtAm20PWfk8Dv8/jimvI5ub0ub5G11tYaP7FyuRdIT7ePAGzgQzrRIlIrBLnEazvDrqmeYeGaSSNOVV3BI3nNLvvXqbGBswhnJABP9G8E9Ypcy2hGMjP2AmdNb7vkZPsfhQqiFYG219uJUFHqyb5V4Juk94Hj2GaSuBwDIOr0r6mKK6Mb5+LXpuIoHA33AN7871rZRtxtZwM6NQbwumLPIc4RgBgbGUbe8G+mOm1jNlS2RD4qRnhSPrxweZgFObLlpHIb1Jg3f291c0+3FAK/lPYlh6E6kEu7LCxmszTUirym6uULBrMUhFgvgUbKPTG7alYzduj70sJ+5b41hMxL6i3BVBcgWsODa2zh6sDfIzMHAQcPtoVjpbCG5ybNWjVGA1ZFFxm7QxgJlk9M/ySfzxNpho6kmIT8SVvpH1G7XPRcZw+yAxQP37If29fXplUViCr3DGUMU05fSpbWrM=
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

The compat vDSO will be handled by the existing 32-bit ARM configuration.

Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
---
 arch/arm64/Kconfig              |  1 +
 arch/arm64/kernel/vdso/Makefile |  4 ++--
 lib/vdso/check/vdsocheck.rs     | 12 ++++++++++++
 3 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 1075bc661833..df22b4ed5e29 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -258,6 +258,7 @@ config ARM64
 	select TRACE_IRQFLAGS_NMI_SUPPORT
 	select HAVE_SOFTIRQ_ON_OWN_STACK
 	select USER_STACKTRACE_SUPPORT
+	select VDSO_CHECK
 	select VDSO_GETRANDOM
 	select VMAP_STACK
 	help
diff --git a/arch/arm64/kernel/vdso/Makefile b/arch/arm64/kernel/vdso/Makefile
index f6619e1cb2ce..5d8c34c7be51 100644
--- a/arch/arm64/kernel/vdso/Makefile
+++ b/arch/arm64/kernel/vdso/Makefile
@@ -61,7 +61,7 @@ targets += vdso.lds
 CPPFLAGS_vdso.lds += -P -C -U$(ARCH)
 
 # Link rule for the .so file, .lds has to be first
-$(obj)/vdso.so.dbg: $(obj)/vdso.lds $(obj-vdso) FORCE
+$(obj)/vdso.so.dbg: $(obj)/vdso.lds $(obj-vdso) $(vdsocheck) FORCE
 	$(call if_changed,vdsold_and_vdso_check)
 
 # Strip rule for the .so file
@@ -79,4 +79,4 @@ include/generated/vdso-offsets.h: $(obj)/vdso.so.dbg FORCE
 
 # Actual build commands
 quiet_cmd_vdsold_and_vdso_check = LD      $@
-      cmd_vdsold_and_vdso_check = $(cmd_ld); $(cmd_vdso_check)
+      cmd_vdsold_and_vdso_check = $(cmd_ld_vdso); $(cmd_vdso_check)
diff --git a/lib/vdso/check/vdsocheck.rs b/lib/vdso/check/vdsocheck.rs
index e28ee59a900d..0d5ceaca34d7 100644
--- a/lib/vdso/check/vdsocheck.rs
+++ b/lib/vdso/check/vdsocheck.rs
@@ -57,6 +57,18 @@ fn allowed_relocations_for_machine(machine: u16) -> Option<AllowedRelocations<'s
             ..Default::default()
         }
         .into(),
+        bindings::EM_AARCH64 => AllowedRelocations {
+            in_object_file: &[
+                260, /* R_AARCH64_PREL64 */
+                261, /* R_AARCH64_PREL32 */
+                262, /* R_AARCH64_PREL16 */
+                273, /* R_AARCH64_LD_PREL_LO19 */
+                274, /* R_AARCH64_ADR_PREL_LO21 */
+                283, /* R_AARCH64_CALL26 */
+            ],
+            ..Default::default()
+        }
+        .into(),
         _ => None,
     }
 }

-- 
2.56.1


