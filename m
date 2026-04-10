Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D613F4484C
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 12:19:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6538A6B00B3; Fri, 10 Apr 2026 08:19:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 604466B00B5; Fri, 10 Apr 2026 08:19:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4CC636B00B6; Fri, 10 Apr 2026 08:19:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 372636B00B3
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 08:19:48 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F1EF4B3798
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 12:19:47 +0000 (UTC)
X-FDA: 84642552414.28.017C0B9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 57BF9C0011
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 12:19:46 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="lx7PSe/P";
	spf=pass (imf22.hostedemail.com: domain of tglx@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tglx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775823586; a=rsa-sha256;
	cv=none;
	b=t1V6XqNvWXldmheb+QFSw2ToxJlNXprWbKEJwjeaJpiKi0cdHWb4w3wKENQqmgmhcw2YP0
	4uwHZHDN5Gb4jqpOhh6RIF/+CtW6S3LkpnVq1iiLLBzgkGO022udnp9JppPEoQtXsm90ZA
	0LniGKiAO2BW8ajCzw8S4PST5JQfoUc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775823586;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:references:dkim-signature;
	bh=xygFk++4Dzn0dankGqOQGxF6Nzu0dNNvlma/WvdOwrA=;
	b=vgo8IFi5C6rdkpx9dZZZP39dcGLli9dEmsUmu91wN8gmYLIIztwzaBv2ADqUetz8su8ScN
	rAdgG6RA6V+RrQOKZY8StI9KMWz6RcI29Ve7Zz8heGWbR05NBsR0lE2mUYYc+8H+xk1sZl
	Rlg7Hg02kaybBODZKBPm6d+mumccXvk=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="lx7PSe/P";
	spf=pass (imf22.hostedemail.com: domain of tglx@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tglx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id AE51161119;
	Fri, 10 Apr 2026 12:19:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F75AC2BC9E;
	Fri, 10 Apr 2026 12:19:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775823585;
	bh=QeSclCuMiRAS5wk6lWoviUdmtawCgYPJK7955XSCrpk=;
	h=Date:From:To:Cc:Subject:References:From;
	b=lx7PSe/PjadVTpIMwJdhAJBLt/wkFkRfbRhizAqdCmT18BPcbSlnMFeRTECetW5Mz
	 e18kIbNIOdNmzSRNcljN5MiUEDzdauvDtZpRrKPYAQq6HuU0ixY90WW/AT9/9BP1TE
	 G0pmyVH8DHnvheD/Jtznb1TEyB0LG5ezsRLYR23JSrj8T1XCNh6BmAZvkaj4VTBCOk
	 FjtLvndHPm1jEFcE8PqfK7D9YifyYmXQkYky/wPITICuSdRrICGnLkZ3jZxe25sBaP
	 q8ggvP1HMAsaRRMlhxP+iwStOOzZHUsvv+/U0DMMTE0lc38vp99aMg2cqhdxuGrXAu
	 mqm2UYpSfgZaw==
Date: Fri, 10 Apr 2026 14:19:42 +0200
Message-ID: <20260410120318.592237447@kernel.org>
User-Agent: quilt/0.68
From: Thomas Gleixner <tglx@kernel.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: David Woodhouse <dwmw2@infradead.org>,
 Arnd Bergmann <arnd@arndb.de>,
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
Subject: [patch 15/38] ptp: ptp_vmclock: Replace get_cycles() usage
References: <20260410120044.031381086@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 57BF9C0011
X-Stat-Signature: 8n9s17hmiejgbh39kuq6tdu9m8hxz78m
X-HE-Tag: 1775823586-414843
X-HE-Meta: U2FsdGVkX1/l3FMK7PXMeN8zjzZRq9z2837WwkTNvHXI4ycjzy5D42fp4uElEhiuhfpuVdplEWHckx/KLpzGWqedU2ppy+6rt6YudbStrZZ8vmczovxNLyOOnbxDEwfbQ9yPUMKY4uWJtOUnW1k9UeXDRTQ/g7wsS603PxsuamEo4BtJgM21rNrjxy/U2KgrJPzuwff+6HFJFBH1JYcy+tQVE7yNxKpz9J66c6pMiBZZ+tX1K6zfVX7Wj+CMAZul7Bxnym/XDJVPmHpesaEE2Bo1m1gBHRK8nmzcSpbGivpUvNprTuTKbMURE9idUcoPStWlJ+mRkFU6PZMmCKA5aYJobEDn/lN19ZyWP4TmafUo5TLQP1pqeymxC+UG52nfkR14BqLuQwPy1DN0Bn5JjlDuG1s+57ICEoMJKeOD6DKwLf/b6iwq8W41oBYzPvqHAzb24RUVCWMteIhcB1pAXjmB5yXyQlkGM5RtAD2nnGeIDsyVVJWxNg2/YAf+Vg8Dqw0KrjpC76jzXFQMsNr6VvCYCaRKCrllLbkxH2B6y2cfzKBEemQBlrsM4X034zKg+/1bevk9ejZoNPuDgYC4z3qErlxD1Cl+9F7BLmcv+zQvoUHLyggkTUP5uoX0HbKXtblfX/0ITo753MaY4KSj8wBNzLwHh5nyY4o+Z/ykpcUBb+oe38txd18xd6qLIWL924Ll6yCpSrzhwafwBhiBjrFlyF3em+5tV1bn1SPyRjL2nGcnVi/jH9OpcdTkPDAKm5Bd22CxogCLxoCRbF5EzRKaJdSqBj0Qu0LFcsAgwISsYmMt4c30DFsNDgJwu2lnbh9Uf3ZplQr8Mws+Twd6eXpX+s27IT0Kx1l2AJhtsuSrljZDQvcDg6vBe+rRK/FSJ95Mv8YEFdKgnlUDztECGOM9nx8CFLz27GiAdEofA1Oe+SOaSBuUgHRAkVuPwBer+wHgaF6tH7HdOD4i9HC
 kXvq60oS
 C1n7iixMNBPp0ZJX1ft/s0bC+WFm7zOh8xcj6Lqtb+0zk+MWpQeqGHERgpp7zOyTQqwAuKKvtFuqfdEdz4cBbJMdmUyXafh2bJKyuMU+CiVFl+P6EnxipyaxhXZX4/yFoPIcq6N6MCZ6oWUH3SgwZag/XsqpgVKK00W7KeabjlhdjulGcOm+0GhMYm57jXOy06GhyR2TbUuCJ3vKoUTpSkEKmrsX4Qf4C69Ts1U+3dEiR7ovlp4nB9hiNTd3kpOlyqZUshvEpm3KP6hRF1l28AZGkxxXYI5A09Rc1K74lUzRlYA8qnnH0Sq3HWfsaOciXzDkkd0RVcLKVGNEZ+GiyChzVE7D4O7k+fGeTGQEu2tUZ+WWcuuITIBkgKV0ITtcazezjYp6kK276X7l75Ufyji1lIej91l9A7beE0e7sbenrGXs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

get_cycles() is not really well defined and similar to other usaage of the
underlying hardware CPU counters the PTP vmclock should use an explicit
interface as well.

Implement ptp_vmclock_read_cpu_counter() in arm64 and x86 and simplify the
Kconfig selection while at it.

No functional change.

Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Cc: David Woodhouse <dwmw2@infradead.org>
---
 arch/arm64/Kconfig                   |    1 +
 arch/arm64/include/asm/ptp_vmclock.h |   12 ++++++++++++
 arch/x86/Kconfig                     |    1 +
 arch/x86/include/asm/ptp_vmclock.h   |   12 ++++++++++++
 drivers/ptp/Kconfig                  |    6 ++++--
 drivers/ptp/ptp_vmclock.c            |    6 ++++--
 6 files changed, 34 insertions(+), 4 deletions(-)

--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -112,6 +112,7 @@ config ARM64
 	select ARCH_SUPPORTS_SCHED_SMT
 	select ARCH_SUPPORTS_SCHED_CLUSTER
 	select ARCH_SUPPORTS_SCHED_MC
+	select ARCH_SUPPORTS_PTP_VMCLOCK if ARCH_SUPPORTS_INT128
 	select ARCH_WANT_BATCHED_UNMAP_TLB_FLUSH
 	select ARCH_WANT_COMPAT_IPC_PARSE_VERSION if COMPAT
 	select ARCH_WANT_DEFAULT_BPF_JIT
--- /dev/null
+++ b/arch/arm64/include/asm/ptp_vmclock.h
@@ -0,0 +1,12 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef __ASM_PTP_VMCLOCK_H
+#define __ASM_PTP_VMCLOCK_H
+
+#include <asm/arch_timer.h>
+
+static inline u64 ptp_vmclock_read_cpu_counter(void)
+{
+	return arch_timer_read_counter();
+}
+
+#endif
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -135,6 +135,7 @@ config X86
 	select ARCH_SUPPORTS_RT
 	select ARCH_SUPPORTS_AUTOFDO_CLANG
 	select ARCH_SUPPORTS_PROPELLER_CLANG    if X86_64
+	select ARCH_SUPPORTS_PTP_VMCLOCK	if X86_TSC
 	select ARCH_USE_BUILTIN_BSWAP
 	select ARCH_USE_CMPXCHG_LOCKREF		if X86_CX8
 	select ARCH_USE_MEMTEST
--- /dev/null
+++ b/arch/x86/include/asm/ptp_vmclock.h
@@ -0,0 +1,12 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef __ASM_PTP_VMCLOCK_H
+#define __ASM_PTP_VMCLOCK_H
+
+#include <asm/tsc.h>
+
+static inline u64 ptp_vmclock_read_cpu_counter(void)
+{
+	return cpu_feature_enabled(X86_FEATURE_TSC) ? rdtsc() : 0;
+}
+
+#endif
--- a/drivers/ptp/Kconfig
+++ b/drivers/ptp/Kconfig
@@ -131,10 +131,12 @@ config PTP_1588_CLOCK_KVM
 	  To compile this driver as a module, choose M here: the module
 	  will be called ptp_kvm.
 
+config ARCH_SUPPORTS_PTP_VMCLOCK
+	bool
+
 config PTP_1588_CLOCK_VMCLOCK
 	tristate "Virtual machine PTP clock"
-	depends on X86_TSC || ARM_ARCH_TIMER
-	depends on PTP_1588_CLOCK && ARCH_SUPPORTS_INT128
+	depends on PTP_1588_CLOCK && ARCH_SUPPORTS_PTP_VMCLOCK
 	default PTP_1588_CLOCK_KVM
 	help
 	  This driver adds support for using a virtual precision clock
--- a/drivers/ptp/ptp_vmclock.c
+++ b/drivers/ptp/ptp_vmclock.c
@@ -28,6 +28,8 @@
 
 #include <linux/ptp_clock_kernel.h>
 
+#include <asm/ptp_vmclock.h>
+
 #ifdef CONFIG_X86
 #include <asm/pvclock.h>
 #include <asm/kvmclock.h>
@@ -144,11 +146,11 @@ static int vmclock_get_crosststamp(struc
 			if (systime_snapshot.cs_id == st->cs_id) {
 				cycle = systime_snapshot.cycles;
 			} else {
-				cycle = get_cycles();
+				cycle = ptp_vmclock_read_cpu_counter();
 				ptp_read_system_postts(sts);
 			}
 		} else {
-			cycle = get_cycles();
+			cycle = ptp_vmclock_read_cpu_counter();
 		}
 
 		delta = cycle - le64_to_cpu(st->clk->counter_value);


