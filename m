Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2F38F44847
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 12:18:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1BE576B0098; Fri, 10 Apr 2026 08:18:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 16FE46B0099; Fri, 10 Apr 2026 08:18:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 05DED6B009B; Fri, 10 Apr 2026 08:18:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E49F86B0098
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 08:18:43 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7B5131A0532
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 12:18:43 +0000 (UTC)
X-FDA: 84642549726.17.3B58206
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id E8A0AC000A
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 12:18:41 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="nWtTU/8b";
	spf=pass (imf28.hostedemail.com: domain of tglx@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tglx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775823521;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:references:dkim-signature;
	bh=1svmJ9bLZm6y7AkRgd4KZ3wMzChgI+aIwiw2S8Q7kUs=;
	b=FNdPWh6C+fCDPe6KcogSKD783ol843wkHfAjl3WF425SYKSVYX/hi6vVVjsoHAUtuSBa0j
	/Xvh+uULzCvy1EG+TWc/CoWdJY9Kv/8I/KN/v0SupSvW05vRUbaUCUierqdshWJosss+Cg
	rfE2RfOJ5minpx0MhiYx5YecXx/n8/Q=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="nWtTU/8b";
	spf=pass (imf28.hostedemail.com: domain of tglx@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tglx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775823521; a=rsa-sha256;
	cv=none;
	b=FXBvek4ijrzHTlvH/AcrhnMqnn7Sauhut3hzAse0Q6eYYFLP2hQ8IBr/X/EFtP82Bx/F0w
	0KpsIzS9wjnQxecpbookSUl17rluWkW0XFVSU0jSgQz66T05U2KNYXHpvm72l8To2Fywot
	GTDPGrYteEPjt+gPfnXxZ480iJ/PgoU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 60F576111B;
	Fri, 10 Apr 2026 12:18:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34709C2BC87;
	Fri, 10 Apr 2026 12:18:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775823521;
	bh=jM+JreNQ/pvWEKCuy6rQc5u1kgCA5N5UN7yUgNovu14=;
	h=Date:From:To:Subject:References:cc:From;
	b=nWtTU/8bYflAI0sVDZCcTSRoMHHBafK4f8aE8OQUIADFXrWn3gkAS6D8iyeDcGytD
	 IkAJ7wfDdphIDTv0/p2VgJLmG6txpPJj7VHjB28F0wfKCyzE07p6hHvScSQ/hPg40n
	 m5UonCXCWoABi9Y1P5pL07/VfBtvxj5IX/qtz/8nDDpNNssj+hm09ux1rli9d/5Kp7
	 u2W39VabHnp7xFO01m/Vf4vbZzsQaYVQbm/v4/bBGJXSthxziJGUNQp6cLMMBeBrVY
	 Rxdzr0TBEmAzR1XxM10SdBatX0CJ8cwLuQKU2F/sGImGk9kogedHCPTsKBS8t/RjVc
	 cuRhduaM+Iuqw==
Date: Fri, 10 Apr 2026 14:18:37 +0200
Message-ID: <20260410120317.709923681@kernel.org>
User-Agent: quilt/0.68
From: Thomas Gleixner <tglx@kernel.org>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [patch 02/38] x86: Cleanup include recursion hell
References: <20260410120044.031381086@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
cc: Arnd Bergmann <arnd@arndb.de>,
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
X-Rspamd-Queue-Id: E8A0AC000A
X-Stat-Signature: tp6wtop4nqpi7zyfgkjtn5w86abm7ubo
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1775823521-236519
X-HE-Meta: U2FsdGVkX1+0xLB3vUFH73fphDTAENfPpTT9HWGx6+o5peXnwzh8WF5k3LSDMJ0+3xn7nGKjQJ6q3qJfymoL9gbOYVEMnJ59OoicQTHAHGIguDK1lYJB6DLrlCU7TQwjVTOEmQWzSThXlfF1MyOB7QFdEiwn2du5MEpqZ9oSioKJThzhxzJ5IVZfa1IMbJcaqDuD3xkQ7wIxEWjXTi5JUEAjGo9t8Pq038XqYyOFjg/OoFHfTVwurFJErSiT8f8wUCb0ttqmaP709bWtglVDHZB22j9VB/sfEszCXiSd1Fxt+ILePw1xTQdV0xfpBfP2r1Pc/6j9Mc9yU3iMme+TCL5/YH1rCBJurDQcpGPdZy9YhVNfN1WRoRiOk4mUaHIGhwNVzWTtPEobwwJgvJuPsihWQAZz1DdRRZsqnQhw3iaqpPMa6gWiZAGQ2c6WLMfa7S+gkrlZDHp45RaLB5Na+sVaS2O5rdfMlorm1cyVuCu21N3n+sAC6af/KnrSO0Uy+Wuc+Edpla8u2tCBH5lah+mNTM0ZkMuqgXypCfSov3pa03F52NbXp3qVhnvvHWOGHQkIX0HKou+Fm6Ae2HBybw0moMJ6xXDidmaIv7XhVJ+r7lB3qDERToJB1Z0QcI61QaeNLGvjxjur/xQZ9essf5DhqtZVMY33ghxJ0FsqfqYNFWJbqtWXIqVuRU2B3rkDwzyX8pORKsHVGlCUlYyIOlSk5gTkvX52UTQYGWGLcUyz2/xdb5H3mofiWXjnbu9Sy+jvXDDdkAPwLLLL7XGTkgIsUay/zckfHzTQc3xJiDon3ZVC1tWF/XWVsY8iIWRDRzTPTFw0Q2OX0NCnNlWRyQ9mVtU/H23o+g/dUlHSUY0CICMjE7Y4iwqmYCHnuvkwQix8pX4QgsINhXMuCs5P2JCKDXwYeZBVaOpBhJ0zhuRD+RWhZGg7/Z3hVE+l8L8VBtywHs6dlcKa36xZfaX
 NMmlr+pD
 IS/GsNw3TYm6rU3uG39SZF0JDrlbshVF2k1ZVo0zVdf9Yw9HuL/4RUUQ9IoJZNOPjHvMialWpVRbKx0x6GMUg4lCCw5zJTrw5NGpsSVn+Ooo5/TBpEwGpakFVGioJ3OKsDwjEw7Tk7ZN3zie3fEByxe1rBAQJ+7zxHLBm2m2N306ONbNajqvhRWr7iR4C8llAE5w9FaanAzpXA+JhmYZvGdwAbg9RfOEbj5Vq2o+QQG7wNmz7UjyQJy3Z1RjaZ9y6nOWHBWux+TekyLfKaT2W2CAppPNy/yL9mCTslz407BLkB/OxqzDCu7OjqCviPKNljZ+8
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
 arch/x86/include/asm/msr.h               |    5 +++--
 arch/x86/include/asm/pvclock.h           |    1 +
 arch/x86/include/asm/smp.h               |    2 --
 arch/x86/include/asm/vdso/gettimeofday.h |    5 ++---
 arch/x86/kernel/cpu/mce/core.c           |    1 +
 arch/x86/kernel/nmi.c                    |    1 +
 arch/x86/kernel/smpboot.c                |    1 +
 7 files changed, 9 insertions(+), 7 deletions(-)

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


