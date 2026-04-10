Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F21E6F44847
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 12:18:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 60B596B0095; Fri, 10 Apr 2026 08:18:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B5286B0096; Fri, 10 Apr 2026 08:18:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A3BC6B0098; Fri, 10 Apr 2026 08:18:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3A7F96B0095
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 08:18:39 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 04E2F1B81A0
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 12:18:38 +0000 (UTC)
X-FDA: 84642549558.08.B2A3352
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 589701C0007
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 12:18:37 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PujwWQLA;
	spf=pass (imf21.hostedemail.com: domain of tglx@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tglx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775823517;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:references:dkim-signature;
	bh=PgIshXZYXEu09ocWBqnvQyyErdcYu8PrYSZGXlwB4Zw=;
	b=xroLv7XMW2hqFxvMLIfcVFRl/gyanCfK6qbEhHd2KFvqFTy7nQlRs6mo0qLQdhNARKQ0Bu
	f5jKCLDMeVPtLBQXQVu/b9aalsP5gMlHbySJ25ePgx828+Tl7YkDbfbZ5zfpXyzX5ujEsD
	TXtbzWYUXw6OMOUWSTAMxOxYtCrwBEo=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PujwWQLA;
	spf=pass (imf21.hostedemail.com: domain of tglx@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tglx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775823517; a=rsa-sha256;
	cv=none;
	b=3vfxq64AgGIIVLkxAXgIRfLWMjrJlQFskX7U0NFgPd38r/Jv9Jcj0Zp4ndBfX0klu0BFNO
	+sBetUBnkHd+wfTHbemrzpDHF+lHr038TcidGxcoLQxexaKd1OTguc676B/FjClUfVjxS5
	2wa7UtK4EK/kUHSLj9Vph0q1DeKEKhs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 099C341A7C;
	Fri, 10 Apr 2026 12:18:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DF48C2BC87;
	Fri, 10 Apr 2026 12:18:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775823515;
	bh=Qxe5s7KoLSq5kG1N2smycXiRWybB8taeJTlNsbfy0fg=;
	h=Date:From:To:Cc:Subject:References:From;
	b=PujwWQLA2dOIyLlZvIM0oB1Wg7c5ZIyCwzH/XHGNRGehg+YFil6OmFstHyfDwz6a4
	 UXi7viGoUKPW4HP65M0H75qRplTYAji9Z6ikhUQOkcZXvM13Netjmq5O6I/+9+JQ+w
	 bxUrL+dmChTEREYE3VSmYBwXmygVivr7jmb4e0itrCIHXq31ae3WiG49uZ0Z2PTGdc
	 +od1M1yaD34oi/oFSPoyZ73JAQOxw0kf9oLJ4YVR9wqn75mlEWMpZuBIxST6yrXcHs
	 fYRNY0LFjGxQtZU4+RTQobyzbJWEzJNsARBCqXSJyY40dbr06WXMHmkuYa6yNGx2XV
	 5kZ5/s9dunCZA==
Date: Fri, 10 Apr 2026 14:18:32 +0200
Message-ID: <20260410120317.642797961@kernel.org>
User-Agent: quilt/0.68
From: Thomas Gleixner <tglx@kernel.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
 x86@kernel.org,
 Lu Baolu <baolu.lu@linux.intel.com>,
 iommu@lists.linux.dev,
 Michael Grzeschik <m.grzeschik@pengutronix.de>,
 netdev@vger.kernel.org,
 linux-wireless@vger.kernel.org,
 Herbert Xu <herbert@gondor.apana.org.au>,
 linux-crypto@vger.kernel.org,
 Vlastimil Babka <vbabka@kernel.org>,
 linux-mm@kvack.org,
 David Woodhouse <dwmw2@infradead.org>,
 Bernie Thompson <bernie@plugable.com>,
 linux-fbdev@vger.kernel.org,
 "Theodore Tso" <tytso@mit.edu>,
 linux-ext4@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>,
 Uladzislau Rezki <urezki@gmail.com>,
 Marco Elver <elver@google.com>,
 Dmitry Vyukov <dvyukov@google.com>,
 kasan-dev@googlegroups.com,
 Andrey Ryabinin <ryabinin.a.a@gmail.com>,
 Thomas Sailer <t.sailer@alumni.ethz.ch>,
 linux-hams@vger.kernel.org,
 "Jason A. Donenfeld" <Jason@zx2c4.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 linux-alpha@vger.kernel.org,
 Russell King <linux@armlinux.org.uk>,
 linux-arm-kernel@lists.infradead.org,
 Catalin Marinas <catalin.marinas@arm.com>,
 Huacai Chen <chenhuacai@kernel.org>,
 loongarch@lists.linux.dev,
 Geert Uytterhoeven <geert@linux-m68k.org>,
 linux-m68k@lists.linux-m68k.org,
 Dinh Nguyen <dinguyen@kernel.org>,
 Jonas Bonn <jonas@southpole.se>,
 linux-openrisc@vger.kernel.org,
 Helge Deller <deller@gmx.de>,
 linux-parisc@vger.kernel.org,
 Michael Ellerman <mpe@ellerman.id.au>,
 linuxppc-dev@lists.ozlabs.org,
 Paul Walmsley <pjw@kernel.org>,
 linux-riscv@lists.infradead.org,
 Heiko Carstens <hca@linux.ibm.com>,
 linux-s390@vger.kernel.org,
 "David S. Miller" <davem@davemloft.net>,
 sparclinux@vger.kernel.org
Subject: [patch 01/38] percpu: Sanitize __percpu_qual include hell
References: <20260410120044.031381086@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Rspam-User: 
X-Rspamd-Queue-Id: 589701C0007
X-Stat-Signature: 3doyomd6kaw6guhhoxcko5brewmar5ri
X-Rspamd-Server: rspam06
X-HE-Tag: 1775823517-706946
X-HE-Meta: U2FsdGVkX1/Xbbl0fsWnOX62OTiozofHtp9Wee9jNDGzwdg6VeLhFj5CPyfYtaepkcwkg1GSyzn7vmbn4wDOByWze81JS0D0kUEMr0PtFBf0EFRnD0n9iSwENeQaw6P+26hf+XFLpq8fk7uEClGSAIz0pvru2VQe+CB12a3zsyhB+/DLXFB4LaihxBSzDpdoMAwR+JxaQiJA/nnUFpgfySkbJq8Fk/ctkq8Go4MoZPDgK9jrt2859+bH5JzqxqF75+NCX3f2cMRlnHMk6nwTbELOjQ1573Mb8mL0pOzJpxp7qQeR86GIra+p+uX7XG7/KJzrmCV4LSeme6HiggV2aFqm0Sqce2jgoanWukrN1CyqohE0Ag1HfZrXp7tDWUA6ZplZJpqwLGU3KIeoTaEas30aBlCRNp+S+KEkptFNjZxX3jRe3bwSGm9cXfYaGawcLe5xuK0whtJF/Rh3bGelnjBRKfxbz1fY0IzMU9LpIgjDMVHHUHWSqSIt1IqDbXYIMU27qy11gy3E75+JFaZkLbIpRZtCQWzBmjNp3GSZZn17ZnY3Xq/lG80EKqGZuH+WYsZDuH+afJvqxzW9VJ360vimuYZrVhqsggMuihMmETt3K6Cur51LvfsHa7uXj1I4jIKIKgsB4A95G4epMhumatSCoFsxi74EdQKrQcsPqrnsdzpYvqxUmuPcIocOWtH23OEMkbkvsPAMe9focan9Cu8elLEwEmbvY2ZlruRkHCwZtPVSepp8xC7yyDhU3IIs8eN3UVTJ8wWrBTXSvuXnedZQdPF7wdyhUBAFD5VOqdSBpxQa6O4pcjCuFOFNfQ8ThwJtUb5wozUVU8qwbSlQHz90z84tpz6V0sareSPLavymOtp0E8yZjsQABYiuygFkBTZWTmXPprRweDyCvRQ02EDukyUw+Urmhlp5I472eDrU5RXO7p8eaSwFly85SE/ol3TmguJQxYNrSQAiwvs
 Fola4+qU
 Iek6TbR44phSEwW7cvli8m4sBh1qgOiQbVwE/E3gGvuA/u+k2aTV6x5kcU/jvPpHzLMELskbtFteBV5DMXE207Vcj+U1tUXfCy7EEJw7TRiUvCHGi8gfsfcIcJ1o/MhjhldBhoZUntfw58998k6fqCY+hyVTadCfRiWT1GEm99eWQX5nMosf84C0RcaXk3R2C/KmfxZpw8ATphWABHWwGUGYyyc/kjCSWfxZAfGAOXM8aNzAMIOC5I/3LdGP/gy1dkg0LvOGXwu9jO1d51flwxz+ql65gTcy5II5J8nXrp0u/06dK8UMIFi7joZ28+ZLXd21BML9p26nQICL26bfFDR2COARUB7VK6to6DPq6JVyG98w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Slapping __percpu_qual into the next available header is sloppy at best.

It's required by __percpu which is defined in compiler_types.h and that is
meant to be included without requiring a boatload of other headers so that
a struct or function declaration can contain a __percpu qualifier w/o
further prerequisites.

This implicit dependency on linux/percpu.h makes that impossible and causes
a major problem when trying to seperate headers.

Create asm/percpu_types.h and move it there. Include that from
compiler_types.h and the whole recursion problem goes away.

Signed-off-by: Thomas Gleixner <tglx@kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>
---
 arch/x86/include/asm/percpu.h       |    5 -----
 arch/x86/include/asm/percpu_types.h |   17 +++++++++++++++++
 include/asm-generic/Kbuild          |    1 +
 include/asm-generic/percpu_types.h  |   20 ++++++++++++++++++++
 include/linux/compiler_types.h      |    1 +
 5 files changed, 39 insertions(+), 5 deletions(-)

--- a/arch/x86/include/asm/percpu.h
+++ b/arch/x86/include/asm/percpu.h
@@ -40,12 +40,10 @@
 #endif
 
 #define __percpu_prefix
-#define __percpu_seg_override	CONCATENATE(__seg_, __percpu_seg)
 
 #else /* !CONFIG_CC_HAS_NAMED_AS: */
 
 #define __percpu_prefix		__force_percpu_prefix
-#define __percpu_seg_override
 
 #endif /* CONFIG_CC_HAS_NAMED_AS */
 
@@ -82,7 +80,6 @@
 
 #define __force_percpu_prefix
 #define __percpu_prefix
-#define __percpu_seg_override
 
 #define PER_CPU_VAR(var)	(var)__percpu_rel
 
@@ -92,8 +89,6 @@
 # define __my_cpu_type(var)	typeof(var)
 # define __my_cpu_ptr(ptr)	(ptr)
 # define __my_cpu_var(var)	(var)
-
-# define __percpu_qual		__percpu_seg_override
 #else
 # define __my_cpu_type(var)	typeof(var) __percpu_seg_override
 # define __my_cpu_ptr(ptr)	(__my_cpu_type(*(ptr))*)(__force uintptr_t)(ptr)
--- /dev/null
+++ b/arch/x86/include/asm/percpu_types.h
@@ -0,0 +1,17 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _ASM_X86_PERCPU_TYPES_H
+#define _ASM_X86_PERCPU_TYPES_H
+
+#if defined(CONFIG_SMP) && defined(CONFIG_CC_HAS_NAMED_AS)
+#define __percpu_seg_override	CONCATENATE(__seg_, __percpu_seg)
+#else /* !CONFIG_CC_HAS_NAMED_AS: */
+#define __percpu_seg_override
+#endif
+
+#if defined(CONFIG_USE_X86_SEG_SUPPORT) && defined(USE_TYPEOF_UNQUAL)
+#define __percpu_qual		__percpu_seg_override
+#endif
+
+#include <asm-generic/percpu_types.h>
+
+#endif
--- a/include/asm-generic/Kbuild
+++ b/include/asm-generic/Kbuild
@@ -44,6 +44,7 @@ mandatory-y += module.lds.h
 mandatory-y += msi.h
 mandatory-y += pci.h
 mandatory-y += percpu.h
+mandatory-y += percpu_types.h
 mandatory-y += pgalloc.h
 mandatory-y += preempt.h
 mandatory-y += rqspinlock.h
--- /dev/null
+++ b/include/asm-generic/percpu_types.h
@@ -0,0 +1,20 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _ASM_GENERIC_PERCPU_TYPES_H_
+#define _ASM_GENERIC_PERCPU_TYPES_H_
+
+#ifndef __ASSEMBLER__
+/*
+ * __percpu_qual is the qualifier for the percpu named address space.
+ *
+ * Most arches use generic named address space for percpu variables but
+ * some arches define percpu variables in different named address space
+ * (on the x86 arch, percpu variable may be declared as being relative
+ * to the %fs or %gs segments using __seg_fs or __seg_gs named address
+ * space qualifier).
+ */
+#ifndef __percpu_qual
+# define __percpu_qual
+#endif
+
+#endif /* __ASSEMBLER__ */
+#endif /* _ASM_GENERIC_PERCPU_TYPES_H_ */
--- a/include/linux/compiler_types.h
+++ b/include/linux/compiler_types.h
@@ -41,6 +41,7 @@
 # define BTF_TYPE_TAG(value) /* nothing */
 #endif
 
+#include <asm/percpu_types.h>
 #include <linux/compiler-context-analysis.h>
 
 /* sparse defines __CHECKER__; see Documentation/dev-tools/sparse.rst */


