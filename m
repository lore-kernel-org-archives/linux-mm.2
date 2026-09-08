Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18A9FC79F99
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 06:35:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 883E46B00B1; Tue,  8 Sep 2026 02:34:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 85B676B00B2; Tue,  8 Sep 2026 02:34:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 74AE46B00B3; Tue,  8 Sep 2026 02:34:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 45FF16B00B1
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 02:34:11 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D0244A03BE
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 06:34:10 +0000 (UTC)
X-FDA: 85189630260.24.60BC48A
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf09.hostedemail.com (Postfix) with ESMTP id 19D7E14000A
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 06:34:08 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=XPrer1rN;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=f9FPRGn6;
	spf=pass (imf09.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788849249;
	b=YrkYGy+HDLqUeXFhZxQxAyIi1PPHPJCZKJbhKZBnPlmpS6j93CHPvlJv6XMpI+qtNEfjFq
	N1Eq5vUjy/50QV3iQ64a1ihOdA5luaWVnYD7DDdEBr3K3eW86fS328Iz/+6f2Fc12igvm9
	W/68xEWSv5i899rROKyTS4BH81YEKpQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788849249;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pQENS+2l3jE9bZko+PkLsKR5sNnfI5HJVcqDCuCIVEw=;
	b=BgEyUIcD9ZxoL5kc8EeFSvzu7p2RJRCtbe9ynKb8TnRaiHuj9jGC0xP/v+M/tjD7QPYRkk
	izvJcNmVbwNRaso572Wt38HaBhzLvJ6u9ZojmdbMPRgDPsRqhnJvffgMC+ljJMZf68V6VH
	PbvHfv9/nLEoq84Veo4cj2l4TBNKqWM=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=XPrer1rN;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=f9FPRGn6;
	spf=pass (imf09.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1788849243;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pQENS+2l3jE9bZko+PkLsKR5sNnfI5HJVcqDCuCIVEw=;
	b=XPrer1rNUAnaGlK6vBf4LguK9S6cEYlB8nZZrjRH44T0JYQMAKyYETb6FU7higRUl2aap8
	WPSjupacb2z13S04FQ0SJwG7i5o+PC1OLnBB5YCADw0UGpC2KSsaA9trHc8qBOetMTQve0
	NqaQl/n+ar+DEQjQWhkSInykqClLoMkc1uWPEodTVaq598SF88TtmGIx1H2fHIe1AwzdxB
	0wspvPUe1V8QhduMDS69XofBa/hyc2iRwUnB8p3goy0lgh6Z7KeHRDqnvOkRg7zB8SW8Qb
	FqrCyZ8Y06A671+Lr4boaBg9FZESkcMcbumRwfxWCaD3ADQPhCoX+US7aH30zw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1788849243;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pQENS+2l3jE9bZko+PkLsKR5sNnfI5HJVcqDCuCIVEw=;
	b=f9FPRGn66gCreVPpSFc3v18Vb8RE2PZIstfZMu10x/SOVv9mER00NGNKQm9o2b9lG/56PF
	Oy/Vw7WBWfgQcDDQ==
Date: Tue, 08 Sep 2026 08:33:58 +0200
Subject: [PATCH v5 24/24] vDSO: Automatically enable VDSO_CHECK
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260908-vdso-absolute-reloc-v5-24-3a93791af1cf@linutronix.de>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788849226; l=4650;
 i=thomas.weissschuh@linutronix.de; s=20240209; h=from:subject:message-id;
 bh=8YBIXCqpUcZIhKo2ozvfdc454ybWMwplCW6yYOuJO9M=;
 b=QeYK3jQJuWSOc5ZUbflHX/mM5G6ZrF/wQ5dZ1MsnWSa5wV32FY94s+AgAEqJT3r76pNju6OUd
 jvOXRT9ewDOBI2Td8ZRhAKi0jUGb3Ma2dwo847OeLvKpvkhvaACA78Q
X-Developer-Key: i=thomas.weissschuh@linutronix.de; a=ed25519;
 pk=pfvxvpFUDJV2h2nY0FidLUml22uGLSjByFbM6aqQQws=
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 19D7E14000A
X-Stat-Signature: 1j8bg8rsgnpfhe31anbbrmpoe1k9srms
X-HE-Tag: 1788849248-837957
X-HE-Meta: U2FsdGVkX1/ZcjxRf1JyRGynqj+gJ9c70DQcdz+je81Pqk6jIINOTgwLj9z7BUiyUtRi+UwEcwaCBuLH2fgoV2leUr7mse4e6XIsb5QzcsZPwuKkSfTKmTPKXQ8e46A8qgLdpeS6M5sjQT0lxbIz9KI+E6M8n/SGvIOgjZldT5BP4r1wg9J5MXzWupgkiFD/5gsM4bVEtqwbpphXKDgwl0al4xV45fudvjhDm0FummhvFj0NMPUUzt0rQMpu7xNCU01UKnUKZUfNH3b44J+vKai+BDXAUdsK0f4kdhRzUw9l/fgWbC8VRUch+roVfMnaWC/tGDpmEA7CvPReKpdmtWGRy+IU0uimI5ZBB+e6+BN+7J6qbblTEu/AgcWQs4R1mqy6hwWFqSn/QCnW9c/tnOhiqNNulcZnt4kyMNLqMRmuHcmt6Tr091tvVVk96kUMInkvND9pUjtOyP8+cBBXAm37uDzWk76QaxIjWhc000+Q3lpw5JN6lYbIahDc3P6iUB5UL+r7YMxwCateOA5cP4xgX2VrCgrasWTjW4RkfSGuB0mqJYTuSVM5IbQBq09uGcZrAW5QynsPJrPWU0FRc+3j76+1C+o7W/Q8SuqUcIQMnk5Ny1jxwInj1Wdy3hneyoVzj5Ut7W5BD5/s0s3YfzggVMcALk/1R5fYNlu8wzk7cOf0HYMF+bulZAcG2miH2bF3vsMJ5ge4V1P2KPDn5mBLXjHMX/uADqOV/ilY9nyH9HMU2cD+IzpHlnRoEK8PmT6guUcUoiweRHoerwshsP+ijqpJ7+iAAhu+xYwxQ5axVnYR0dgl35S8/puWeTuUyt9TxrC9ga4frGuKEhm8XbisHcVXZvwIuTwU4gzBWQ8I4TUJSB0Liy8RDkQrs44z7t1p7g9an8ygRzKX7jhlHSCqitGYTRX7vlet6o032gMfOizxcTXwPTWoe2tKcKNzJ3Q7Y1g59qPl0uhvNoU
 wt6itkj5
 Xn3qj3lORxXnPgexzCI7a19+PIwvFKWjpkR+l7G0H0kDbVDsY1ZfGOs0ELNrFf/VwSgb9ekLsuofHkeeM+cx+BSmZ07Tr3EZK4CgFcjRHdtzfq517nHVU8t/nfjrHlm/bqNhJLBfBrf65CaI1ZgUsEHsCPPjksoOahzxlAkTrET1xl0MaIQUvHqY0orUBHMaxdkxBuSrsy33v2S/z23L5RTHFsoUXmiMvj7iPeLT+LeW2qoFPrFoOPN0Bsz2ova4SUrgnZH04BYfaPSgRMz2h7VIA/xGXo3IbgxOqedIpvX5c/hfH3yNn6Fi108fJ2yMw7c3kwBBF2C3GWPVI9uDoh2QUbfZCgzh6QWzkIyWjjC0C7DV6lqnWbDXQkupf7b0un6Ps4q6iFCbVUDBLQNyvNiY51Qtt1of5wt4DquACbFUkX84pwpMAbTUlZRFKg7DUvJTB31wDxX3khfz0fjjN2wrm6ZR8nE7gFuNZ/SFbLJw3Q7yKGPDCmwQS09TU8lKA6tVOXFGZGG8rn6VAr81ABdiMDv35sm4g3uSWM6+ZfcqI4DnL2TienPmy+mI91d+Gphwcv4bHLpvGF2N/FSc9QZL+nJ9vK2nRND46tcA9pb2a20zcxCIupUqbdytFC9m5YUCStxlwdKefJCcOKQfxQnOeluOHKgooVO1HDtckCPmVHGk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

All architectures using the generic vDSO library should enable
VDSO_CHECK. Now that this is the case, enable VDSO_CHECK automatically.

Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
---
 arch/arm/mm/Kconfig    | 1 -
 arch/arm64/Kconfig     | 1 -
 arch/loongarch/Kconfig | 1 -
 arch/mips/Kconfig      | 1 -
 arch/powerpc/Kconfig   | 1 -
 arch/riscv/Kconfig     | 1 -
 arch/s390/Kconfig      | 1 -
 arch/sparc/Kconfig     | 1 -
 arch/x86/Kconfig       | 1 -
 lib/vdso/Kconfig       | 2 ++
 10 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/arch/arm/mm/Kconfig b/arch/arm/mm/Kconfig
index 565988a66e98..6574659dfb61 100644
--- a/arch/arm/mm/Kconfig
+++ b/arch/arm/mm/Kconfig
@@ -950,7 +950,6 @@ config VDSO
 	depends on AEABI && MMU && CPU_V7
 	default y if ARM_ARCH_TIMER
 	select GENERIC_GETTIMEOFDAY
-	select VDSO_CHECK
 	help
 	  Place in the process address space an ELF shared object
 	  providing fast implementations of gettimeofday and
diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 1caaf4737f02..b5a51b0ef944 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -258,7 +258,6 @@ config ARM64
 	select TRACE_IRQFLAGS_NMI_SUPPORT
 	select HAVE_SOFTIRQ_ON_OWN_STACK
 	select USER_STACKTRACE_SUPPORT
-	select VDSO_CHECK
 	select VDSO_GETRANDOM
 	select VMAP_STACK
 	help
diff --git a/arch/loongarch/Kconfig b/arch/loongarch/Kconfig
index 5dc98a4b9c7f..a21f51e5815e 100644
--- a/arch/loongarch/Kconfig
+++ b/arch/loongarch/Kconfig
@@ -213,7 +213,6 @@ config LOONGARCH
 	select TRACE_IRQFLAGS_SUPPORT
 	select USE_PERCPU_NUMA_NODE_ID
 	select USER_STACKTRACE_SUPPORT
-	select VDSO_CHECK
 	select VDSO_DATASTORE
 	select VDSO_GETRANDOM
 	select ZONE_DMA32 if 64BIT
diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index 9a3ce550c95d..e2eb9627bd14 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -107,7 +107,6 @@ config MIPS
 	select TRACE_IRQFLAGS_SUPPORT
 	select ARCH_HAS_ELFCORE_COMPAT
 	select HAVE_ARCH_KCSAN if 64BIT
-	select VDSO_CHECK
 
 config MIPS_FIXUP_BIGPHYS_ADDR
 	bool
diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index f19e225cfc5c..2580e27e4328 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -330,7 +330,6 @@ config PPC
 	select SYSCTL_EXCEPTION_TRACE
 	select THREAD_INFO_IN_TASK
 	select TRACE_IRQFLAGS_SUPPORT
-	select VDSO_CHECK
 	select VDSO_DATASTORE
 	select VDSO_GETRANDOM
 	#
diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
index f580d2afecf7..f8e26c4bed2b 100644
--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@ -229,7 +229,6 @@ config RISCV
 	select THREAD_INFO_IN_TASK
 	select TRACE_IRQFLAGS_SUPPORT
 	select UACCESS_MEMCPY if !MMU
-	select VDSO_CHECK if MMU
 	select VDSO_DATASTORE if MMU
 	select VDSO_GETRANDOM if MMU && 64BIT
 	select USER_STACKTRACE_SUPPORT
diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index bc12367a7b00..4b51bc6e8948 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -291,7 +291,6 @@ config S390
 	select TRACE_IRQFLAGS_SUPPORT
 	select TTY
 	select USER_STACKTRACE_SUPPORT
-	select VDSO_CHECK
 	select VDSO_GETRANDOM
 	select VIRT_CPU_ACCOUNTING
 	select VMAP_STACK
diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index 628bdfc2f088..ab77d3f2536e 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -114,7 +114,6 @@ config SPARC64
 	select ARCH_SUPPORTS_SCHED_SMT if SMP
 	select ARCH_SUPPORTS_SCHED_MC  if SMP
 	select ARCH_HAS_LAZY_MMU_MODE
-	select VDSO_CHECK
 	select GENERIC_GETTIMEOFDAY
 
 config ARCH_PROC_KCORE_TEXT
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index ee0f2c401980..15fd9ec5ecac 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -305,7 +305,6 @@ config X86
 	select HAVE_UNSTABLE_SCHED_CLOCK
 	select HAVE_UNWIND_USER_FP		if X86_64
 	select HAVE_USER_RETURN_NOTIFIER
-	select VDSO_CHECK
 	select VDSO_GETRANDOM			if X86_64
 	select HOTPLUG_PARALLEL			if SMP && X86_64
 	select HOTPLUG_SMT			if SMP
diff --git a/lib/vdso/Kconfig b/lib/vdso/Kconfig
index 112b42a5aeb1..12a640c78b72 100644
--- a/lib/vdso/Kconfig
+++ b/lib/vdso/Kconfig
@@ -6,6 +6,7 @@ config VDSO_DATASTORE
 config GENERIC_GETTIMEOFDAY
 	bool
 	select VDSO_DATASTORE
+	select VDSO_CHECK
 	help
 	  This is a generic implementation of gettimeofday vdso.
 	  Each architecture that enables this feature has to
@@ -21,6 +22,7 @@ config GENERIC_VDSO_OVERFLOW_PROTECT
 config VDSO_GETRANDOM
 	bool
 	select VDSO_DATASTORE
+	select VDSO_CHECK
 	help
 	  Selected by architectures that support vDSO getrandom().
 

-- 
2.55.0


