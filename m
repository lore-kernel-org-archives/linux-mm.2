Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B8C9F45A0D
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 20:55:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 121EF6B0089; Fri, 10 Apr 2026 16:55:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D2C56B008A; Fri, 10 Apr 2026 16:55:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F2A256B0092; Fri, 10 Apr 2026 16:55:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E0F476B0089
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 16:55:32 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6EB08C1E6A
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 20:55:32 +0000 (UTC)
X-FDA: 84643852104.02.77A0E7C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id C096314000C
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 20:55:30 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uBb+aK4w;
	spf=pass (imf09.hostedemail.com: domain of tglx@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tglx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775854530;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EaKhODvxi/ucukRjiZOPM52dL9n0W3z89ySIPcNqMX0=;
	b=WWzWXO7oGjST1MYCs2fY4pJy5iA6g76dfGfvz0Z2vSG3KdTk83x7+53Rn1az1xNkGz9uv9
	OKTMHGKrDUMvGk9568PC9ViBGQo4AiaAYfguSCW429YWL0GDzqfEPN9KLWh8SYxutRzVPk
	nNVDOzL392FHdEl8v8SzUSOX1vzTAt8=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uBb+aK4w;
	spf=pass (imf09.hostedemail.com: domain of tglx@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tglx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775854530; a=rsa-sha256;
	cv=none;
	b=TRWug+01OAd/RRpUOB7dqg6wEuZfRqinWSIZ6qRBEFeklL50daeVy5ID2rynHxghyXiFrW
	BWEzt96waggaqRAyTkRUR3I9CCI8cfzEWxCKWjrPNmmCMYdNYjWBL4gqGU3iohdTh2mGrD
	4YXo5fpYqFFNvzaXLClhfjKlJLxLR9s=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6479E4031C;
	Fri, 10 Apr 2026 20:55:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25D0DC19421;
	Fri, 10 Apr 2026 20:55:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775854529;
	bh=NCLwUcavida6lTRmcWsaKb5HSspL1nWNySBxMvO4hO8=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=uBb+aK4w3/2u4kyVJBiptzM0/JeHVU+h0LyuAGmXhRBB/wmY8nVPEGLrH6PIUauly
	 xZ5jhTx/pd4jDAH6N0E8699fbCvDPdRPvQ/1U9PBOdvPEbxrui2vDJcfwacrKBJbAt
	 K2KgH8S8N6W61I5bQqua5TC/HTbe1JJBDb2jmaIXqh11mio1s1ulWsCUgh1TEd2HU0
	 +ZMxNL6Px/beH32xwdxJ9u73C9h58Vy+EiUKACVtBOcR0D3eWoYoTnffZnDWdkv8Q1
	 Jq57olSI26FETBnKfPSYv2rHfBfCG49DcVZq8FGFKIXdb41avCYxrEXRj1YRJAzkeo
	 CA0Wg7vMsMitA==
From: Thomas Gleixner <tglx@kernel.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>, x86@kernel.org, Lu Baolu
 <baolu.lu@linux.intel.com>, iommu@lists.linux.dev, Michael Grzeschik
 <m.grzeschik@pengutronix.de>, netdev@vger.kernel.org,
 linux-wireless@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
 linux-crypto@vger.kernel.org, Vlastimil Babka <vbabka@kernel.org>,
 linux-mm@kvack.org, David Woodhouse <dwmw2@infradead.org>, Bernie Thompson
 <bernie@plugable.com>, linux-fbdev@vger.kernel.org, Theodore Tso
 <tytso@mit.edu>, linux-ext4@vger.kernel.org, Andrew Morton
 <akpm@linux-foundation.org>, Uladzislau Rezki <urezki@gmail.com>, Marco
 Elver <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>,
 kasan-dev@googlegroups.com, Andrey Ryabinin <ryabinin.a.a@gmail.com>,
 Thomas Sailer <t.sailer@alumni.ethz.ch>, linux-hams@vger.kernel.org,
 "Jason A. Donenfeld" <Jason@zx2c4.com>, Richard Henderson
 <richard.henderson@linaro.org>, linux-alpha@vger.kernel.org, Russell King
 <linux@armlinux.org.uk>, linux-arm-kernel@lists.infradead.org, Catalin
 Marinas <catalin.marinas@arm.com>, Huacai Chen <chenhuacai@kernel.org>,
 loongarch@lists.linux.dev, Geert Uytterhoeven <geert@linux-m68k.org>,
 linux-m68k@lists.linux-m68k.org, Dinh Nguyen <dinguyen@kernel.org>, Jonas
 Bonn <jonas@southpole.se>, linux-openrisc@vger.kernel.org, Helge Deller
 <deller@gmx.de>, linux-parisc@vger.kernel.org, Michael Ellerman
 <mpe@ellerman.id.au>, linuxppc-dev@lists.ozlabs.org, Paul Walmsley
 <pjw@kernel.org>, linux-riscv@lists.infradead.org, Heiko Carstens
 <hca@linux.ibm.com>, linux-s390@vger.kernel.org, "David S. Miller"
 <davem@davemloft.net>, sparclinux@vger.kernel.org
Subject: [patch V1.1 02/38] x86: Cleanup include recursion hell
In-Reply-To: <20260410120317.709923681@kernel.org>
References: <20260410120044.031381086@kernel.org>
 <20260410120317.709923681@kernel.org>
Date: Fri, 10 Apr 2026 22:55:25 +0200
Message-ID: <87ldeuzgaq.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C096314000C
X-Stat-Signature: zs4g9sihhhq7cj7ss95x59djxr8xxx5p
X-Rspam-User: 
X-HE-Tag: 1775854530-248437
X-HE-Meta: U2FsdGVkX1+qerph8GK7f8LGnc5fplEA67e2CSQR23vHPSz8eWSQBQts+mZz4AkC1zVMWp+Skb4khofQ9FAtoFKKtPRODOU0bCiE5hKE8vJWfLwmo14SO/PvbO+PhfNACrzJPNnPWJ21fn/Qh6hcVmeFMsgrdvme4niox6q2tbrQ4OPjMG3s6Zjw2a2qcToOBji98DoCSzBZHce5J9+C3egj5Yqg3z2tMgLamZ0VY/0IVWFQ3MVgdwLTMyQaADJwJikUmyxanlxXMtV9sNyk3rsLPvADKJPBT/QQXJSeDQ8DERbh10PmAjPw4A3r+I/2U+hHj0GBFXy4cSeGmtdjQIOgefLVg23O/m5i9xZ9RCcQkXb/Ko2VDlw86g0S+EV8c5F/IEL3PeSJo3brI5OfM8NAEByPFxQEVUOTmrTY2RyU0dQje6Z0p/aQADcpdO3fUJp6je9xvhnprR0+iu/wlCG40VgV0qbuFNhS6Su5pvmzEHPnpXw5jQAAZFXRuDK4AUBjc4l7eI/tPE4V6BISKFN3grcIbpkkNCJW+h/rWDf5asBtwMeLXW1U61qc9vyzfsB8JpMmJ3dSRL5FMsEAsm14mu9oHq9IGZV5I+DelC7UC/gpf4ovtlwyNqljrg1hV3cCvd6gZtah9CFosI4XhuGJdPNruwwvaHhnpm8UUs1Y52ljc7NYSLRubR1mD4L6oWAapelAJaly2t9ns7yxqgOjvFhVuPeBGxszf5yGsP73kUJSQhzMwycDylUTc15p4lJNe1rT4GET8EQ8dCFL/mWun4ri6CSTqboLVBNnc+MHQCpHbFfRbQ9zccfHwzNu20Ke13joqeHvnw7Y70Cpk+cENueBuaEkNfHBV+6PBtbzS7Lwd3mY5eHcB6As5kvfOwQWa2WEMwbbG2DwKiUcI1hxF22VJsCAIwDlmz9O4qKpuqKSc66JCUrsL7EoqaYh6oa00jjw2x9nDMifn5G
 0m+2zrB6
 gh35kNidKL4z8o5KivgEG1Zy8zYXTiTFGmhMn8FAIOML8eiMJLegMP+tsgpLiMuYtCZRg6AI+yJbGQHulJJehqmSyQuVxb5rU2L9rU/77OJvQMF3YeqdyzgFnG6W9p4qZ3IcZvoaV3M2q3xGFAjOSUhyTwFIa1nIUDlV+yF6Xd5gZ0AUVEiKTc5vhowJlYnPV7ex/e6pxvf2JaMNNIivZv6KM0uqCkAWnGYmr6FV8pFmC+K4fTK/EtuEmTdAMX6u4nXDgOmwgyIlxdvupCl/UopYqu6RkQakS0sLqWCMimA7wvXgMnc7dnWMRBQxZxlZAdDHb9oED858RoxPVIj0Xau+pm6OaNENK25bk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Including a random architecture specific header which requires global
headers just to avoid including that header at the two usage sites is
really beyond lazy and tasteless. Including global headers just to get the
__percpu macro from linux/compiler_types.h falls into the same category.

Remove the linux/percpu.h and asm/cpumask.h includes from msr.h and smp.h
and fix the resulting fallout by a simple forward struct declaration and by
including the x86 specific asm/cpumask.h header where it is actually
required.

Signed-off-by: Thomas Gleixner <tglx@kernel.org>
---
V1.1: Fix PARAVIRT_XXL fallout....
---
 arch/x86/include/asm/cache.h             |    1 +
 arch/x86/include/asm/msr.h               |    5 +++--
 arch/x86/include/asm/paravirt.h          |    3 ++-
 arch/x86/include/asm/pvclock.h           |    1 +
 arch/x86/include/asm/smp.h               |    2 --
 arch/x86/include/asm/vdso/gettimeofday.h |    5 ++---
 arch/x86/kernel/cpu/mce/core.c           |    1 +
 arch/x86/kernel/nmi.c                    |    1 +
 arch/x86/kernel/smpboot.c                |    1 +
 9 files changed, 12 insertions(+), 8 deletions(-)

--- a/arch/x86/include/asm/cache.h
+++ b/arch/x86/include/asm/cache.h
@@ -2,6 +2,7 @@
 #ifndef _ASM_X86_CACHE_H
 #define _ASM_X86_CACHE_H
 
+#include <vdso/page.h>
 #include <linux/linkage.h>
 
 /* L1 cache line size */
--- a/arch/x86/include/asm/msr.h
+++ b/arch/x86/include/asm/msr.h
@@ -8,12 +8,11 @@
 
 #include <asm/asm.h>
 #include <asm/errno.h>
-#include <asm/cpumask.h>
 #include <uapi/asm/msr.h>
 #include <asm/shared/msr.h>
 
+#include <linux/compiler_types.h>
 #include <linux/types.h>
-#include <linux/percpu.h>
 
 struct msr_info {
 	u32			msr_no;
@@ -256,6 +255,8 @@ int msr_set_bit(u32 msr, u8 bit);
 int msr_clear_bit(u32 msr, u8 bit);
 
 #ifdef CONFIG_SMP
+struct cpumask;
+
 int rdmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 *l, u32 *h);
 int wrmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 l, u32 h);
 int rdmsrq_on_cpu(unsigned int cpu, u32 msr_no, u64 *q);
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -16,9 +16,10 @@
 
 #ifndef __ASSEMBLER__
 #include <linux/types.h>
-#include <linux/cpumask.h>
 #include <asm/frame.h>
 
+struct cpumask;
+
 /* The paravirtualized I/O functions */
 static inline void slow_down_io(void)
 {
--- a/arch/x86/include/asm/pvclock.h
+++ b/arch/x86/include/asm/pvclock.h
@@ -2,6 +2,7 @@
 #ifndef _ASM_X86_PVCLOCK_H
 #define _ASM_X86_PVCLOCK_H
 
+#include <asm/barrier.h>
 #include <asm/clocksource.h>
 #include <asm/pvclock-abi.h>
 
--- a/arch/x86/include/asm/smp.h
+++ b/arch/x86/include/asm/smp.h
@@ -5,8 +5,6 @@
 #include <linux/cpumask.h>
 #include <linux/thread_info.h>
 
-#include <asm/cpumask.h>
-
 DECLARE_PER_CPU_CACHE_HOT(int, cpu_number);
 
 DECLARE_PER_CPU_READ_MOSTLY(cpumask_var_t, cpu_sibling_map);
--- a/arch/x86/include/asm/vdso/gettimeofday.h
+++ b/arch/x86/include/asm/vdso/gettimeofday.h
@@ -11,13 +11,12 @@
 #define __ASM_VDSO_GETTIMEOFDAY_H
 
 #ifndef __ASSEMBLER__
-
+#include <clocksource/hyperv_timer.h>
 #include <uapi/linux/time.h>
+
 #include <asm/vgtod.h>
 #include <asm/unistd.h>
-#include <asm/msr.h>
 #include <asm/pvclock.h>
-#include <clocksource/hyperv_timer.h>
 #include <asm/vdso/sys_call.h>
 
 #define VDSO_HAS_TIME 1
--- a/arch/x86/kernel/cpu/mce/core.c
+++ b/arch/x86/kernel/cpu/mce/core.c
@@ -48,6 +48,7 @@
 #include <linux/vmcore_info.h>
 
 #include <asm/fred.h>
+#include <asm/cpumask.h>
 #include <asm/cpu_device_id.h>
 #include <asm/processor.h>
 #include <asm/traps.h>
--- a/arch/x86/kernel/nmi.c
+++ b/arch/x86/kernel/nmi.c
@@ -26,6 +26,7 @@
 #include <linux/sched/clock.h>
 #include <linux/kvm_types.h>
 
+#include <asm/cpumask.h>
 #include <asm/cpu_entry_area.h>
 #include <asm/traps.h>
 #include <asm/mach_traps.h>
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -70,6 +70,7 @@
 #include <asm/irq.h>
 #include <asm/realmode.h>
 #include <asm/cpu.h>
+#include <asm/cpumask.h>
 #include <asm/numa.h>
 #include <asm/tlbflush.h>
 #include <asm/mtrr.h>

