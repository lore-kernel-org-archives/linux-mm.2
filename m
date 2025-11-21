Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 206A1CFC29F
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 18:56:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B9F06B00A0; Fri, 21 Nov 2025 13:55:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 843056B00A1; Fri, 21 Nov 2025 13:55:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E3C86B00A4; Fri, 21 Nov 2025 13:55:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 532DC6B00A0
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 13:55:50 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 17BE8C06F6
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 18:55:50 +0000 (UTC)
X-FDA: 84135518460.08.8893BEC
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf11.hostedemail.com (Postfix) with ESMTP id 63DBB4000F
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 18:55:48 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=ZumgaSzH;
	spf=pass (imf11.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763751348;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CIZNG/FavMs+HtFoA4fu2KhD+yCsuK7pGx2ljUvhcCo=;
	b=ojap4tjcqhk1RhJvEGW7ioFWjzvPKBQUFuHEBQ2KvO1srLhsWV5yz5I/TPioI2vQj48wGC
	Q2CcTZtwjtY7d7FG5HWkAj02vI/vLE85b3NTNsN0Hp24Hu6QaMaYQMggolEXgvOSJ2/uMM
	MSsq8GcffbvT2odFo7IJxIA7ljTIpko=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=ZumgaSzH;
	spf=pass (imf11.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763751348; a=rsa-sha256;
	cv=none;
	b=QzRsEh/sibXDnaP/NO/llPKlf9f1fglH8et66NOMdyRr3biev7Vq9BA+waPGIMIHj73dEZ
	D37dxr1D1O9s5sW7aTj1EEd/hBjuezjhxEibaBUtUxoCWicZHDJxxmIIveCFVYJiF3wj2x
	drO+vNG5QKqT2jiYMem+TtYflwpir4E=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=CIZNG/FavMs+HtFoA4fu2KhD+yCsuK7pGx2ljUvhcCo=; b=ZumgaSzH1xr2UOGHUoas28T14K
	3G/MTOQI5YByOXZui8oe40rn/NeooVPleSRwNFaZpxgV9B43T8E3JxiyCz8Npl4p4Hf3aVbyQ+Kl3
	kd+pskURWotTZ0/g/WfE+BqV5ynOsYMelRdQGtjAjEQshW5O0DozDn7YNfmgpNiGNw6uRwySw4rlC
	zp03MKHqmmW/7ITDXPN9MqvSCmqmW41k2aImU5sRzTf5h++vGwZxLiV3KOz/Ohj52jwj0vEiOFQhb
	mcNO6mxVMnkS+GaBOEBF9+tWa6szUQccDETNDXMG8leKnPQv7Ruoheamg5Pird5dNB6GlhXBON1hy
	glwfo/qw==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1vMWI9-000000003i4-1bNF;
	Fri, 21 Nov 2025 13:55:34 -0500
From: Rik van Riel <riel@surriel.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org,
	x86@kernel.org,
	dave.hansen@linux.intel.com,
	peterz@infradead.org,
	kernel-team@meta.com,
	bp@alien8.de,
	Yu-cheng Yu <yu-cheng.yu@intel.com>,
	Rik van Riel <riel@surriel.com>
Subject: [RFC v5 5/8] x86/mm: Introduce Remote Action Request
Date: Fri, 21 Nov 2025 13:54:26 -0500
Message-ID: <20251121185530.21876-6-riel@surriel.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251121185530.21876-1-riel@surriel.com>
References: <20251121185530.21876-1-riel@surriel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 63DBB4000F
X-Stat-Signature: nfpmktcpqbjbpqm9d6yhertoqbcn9aai
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1763751348-56073
X-HE-Meta: U2FsdGVkX1+iCdzvIjkugN/GfBasTD6uxbd+RCz30lhZfAHpMpRTXUskr40mrPHT68hdzRR0gHkUMvAPVnADpE5kLp/MqQ89fp+0fzynFIAx45SIddKp0XLCzaWr53tNJCoiiNn2aOu5kUxcF3ZYg9psellPRPx/V5lJZTuCXoIrf+geltolYFO0W9tQY+TQfaO/88yJArtcEcWOQTQ8TLsuAVxtaifOf4pjPn+ftvbFyFKNVMN3oLUAAV6Xk7HcG1WurwCuTMHHLrrpalbegR1LhmYJsJ1rKPU5jzzHyEbR95pLVBIF5eMCllDlpW9mPdfTjaMm61ipSPCVdpk7pC8XKQUnaMBQ4rWtroWgFZaS3njRTeA+ZW4AolCd6s5PH9ICjQuCA8zeXSqPu1ZAI9CAVr4x34qhREb/YBml0Rbejw1lEk8Ef1CIm44jJjXYerDAJjKvSTYLLAZr+VKIMkZJp0speIjGKoL4AMNCcrGnkB9hRuCTEvEtp3GVXmEjeYaI4CbQ1T3203ezMusqRdbFROUs4565ORBpxvr+ZQz3n4QjCwMAdJ6BwdkP0BHnoQVYm2TW18sFYynCMY207Px8umHVK7LG+ftxmr7FWoWzPE13Nc5QWoNt6w4crgPx1vQ4L0Z98b/cLWXik9w+RHgwUEIgSOZX5Fn1HCQWJ1EH1m/JivjdF1HJc4XLotk8C6x2k6ZYWoiTL+Fhe8Qy8/ChgkS0JHFEgymR5aPwPUROpX+YhI63YZPB9QHLhN6mJGGCiXMn1hsEFg+nUzRuIvy5Xm13NcyYjqiRfBNeP73SFckTLfLnmxrnnDAjDbo1IEgM7o7All/TsvCxPP9TgNQm0cSDs+XB58P12aJk3PSoil+CCNcwiUud8sz1POm4z6oeok+CNYrUmnNU/uBpDAZ36CFq0/t1dHMi7fEuycR5NaKHKyIyEisnFtd/C/NfKIQGrg8ZqigQhVXmoee
 xy2orSOg
 R7vsqIGOuIs0TdE/OCyNj/HG4sfhP32ZkqT/8P9k6zdIisNA6lvZXY/9UdlOwpgWl85tXTnScFG4f3GCbrSjBHBBtBahgWFYjnEdoIgcCXDEmEsp0AHVSilnp50ZQWo4eKYPdiuxCE++G1dlFqDzzFKgAu8WPdFIr5HB8xZxwhEU6ah3fzts1RqcKRfPv6Mmy4m2+pqcybD18zxxIOedpaPutv0QM3PTqEYIc4Y5vdgkdOv8/LSS1JkM7G/pAS+xltAavsYkQS2aG6yxfeDz4gpNG+Uw5ia39tOAhDWsEHcXvgLs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Yu-cheng Yu <yu-cheng.yu@intel.com>

Remote Action Request (RAR) is a TLB flushing broadcast facility.
To start a TLB flush, the initiator CPU creates a RAR payload and
sends a command to the APIC.  The receiving CPUs automatically flush
TLBs as specified in the payload without the kernel's involement.

[ riel: add pcid parameter to smp_call_rar_many so other mms can be flushed ]

Signed-off-by: Yu-cheng Yu <yu-cheng.yu@intel.com>
Signed-off-by: Rik van Riel <riel@surriel.com>
---
 arch/x86/include/asm/rar.h  |  76 ++++++++++++
 arch/x86/kernel/cpu/intel.c |   8 +-
 arch/x86/mm/Makefile        |   1 +
 arch/x86/mm/rar.c           | 236 ++++++++++++++++++++++++++++++++++++
 4 files changed, 320 insertions(+), 1 deletion(-)
 create mode 100644 arch/x86/include/asm/rar.h
 create mode 100644 arch/x86/mm/rar.c

diff --git a/arch/x86/include/asm/rar.h b/arch/x86/include/asm/rar.h
new file mode 100644
index 000000000000..c875b9e9c509
--- /dev/null
+++ b/arch/x86/include/asm/rar.h
@@ -0,0 +1,76 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _ASM_X86_RAR_H
+#define _ASM_X86_RAR_H
+
+/*
+ * RAR payload types
+ */
+#define RAR_TYPE_INVPG		0
+#define RAR_TYPE_INVPG_NO_CR3	1
+#define RAR_TYPE_INVPCID	2
+#define RAR_TYPE_INVEPT		3
+#define RAR_TYPE_INVVPID	4
+#define RAR_TYPE_WRMSR		5
+
+/*
+ * Subtypes for RAR_TYPE_INVLPG
+ */
+#define RAR_INVPG_ADDR			0 /* address specific */
+#define RAR_INVPG_ALL			2 /* all, include global */
+#define RAR_INVPG_ALL_NO_GLOBAL		3 /* all, exclude global */
+
+/*
+ * Subtypes for RAR_TYPE_INVPCID
+ */
+#define RAR_INVPCID_ADDR		0 /* address specific */
+#define RAR_INVPCID_PCID		1 /* all of PCID */
+#define RAR_INVPCID_ALL			2 /* all, include global */
+#define RAR_INVPCID_ALL_NO_GLOBAL	3 /* all, exclude global */
+
+/*
+ * Page size for RAR_TYPE_INVLPG
+ */
+#define RAR_INVLPG_PAGE_SIZE_4K		0
+#define RAR_INVLPG_PAGE_SIZE_2M		1
+#define RAR_INVLPG_PAGE_SIZE_1G		2
+
+/*
+ * Max number of pages per payload
+ */
+#define RAR_INVLPG_MAX_PAGES 63
+
+struct rar_payload {
+	u64 for_sw		: 8;
+	u64 type		: 8;
+	u64 must_be_zero_1	: 16;
+	u64 subtype		: 3;
+	u64 page_size		: 2;
+	u64 num_pages		: 6;
+	u64 must_be_zero_2	: 21;
+
+	u64 must_be_zero_3;
+
+	/*
+	 * Starting address
+	 */
+	union {
+		u64 initiator_cr3;
+		struct {
+			u64 pcid	: 12;
+			u64 ignored	: 52;
+		};
+	};
+	u64 linear_address;
+
+	/*
+	 * Padding
+	 */
+	u64 padding[4];
+};
+
+void rar_cpu_init(void);
+void rar_boot_cpu_init(void);
+void smp_call_rar_many(const struct cpumask *mask, u16 pcid,
+		       unsigned long start, unsigned long end);
+
+#endif /* _ASM_X86_RAR_H */
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index b53bf3452d6a..032e0c840537 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -22,6 +22,7 @@
 #include <asm/microcode.h>
 #include <asm/msr.h>
 #include <asm/numa.h>
+#include <asm/rar.h>
 #include <asm/resctrl.h>
 #include <asm/thermal.h>
 #include <asm/uaccess.h>
@@ -624,6 +625,9 @@ static void init_intel(struct cpuinfo_x86 *c)
 	split_lock_init();
 
 	intel_init_thermal(c);
+
+	if (cpu_feature_enabled(X86_FEATURE_RAR))
+		rar_cpu_init();
 }
 
 #ifdef CONFIG_X86_32
@@ -725,8 +729,10 @@ static void intel_detect_tlb(struct cpuinfo_x86 *c)
 
 		rdmsrl(MSR_IA32_CORE_CAPS, msr);
 
-		if (msr & MSR_IA32_CORE_CAPS_RAR)
+		if (msr & MSR_IA32_CORE_CAPS_RAR) {
 			setup_force_cpu_cap(X86_FEATURE_RAR);
+			rar_boot_cpu_init();
+		}
 	}
 }
 
diff --git a/arch/x86/mm/Makefile b/arch/x86/mm/Makefile
index 5b9908f13dcf..f36fc99e8b10 100644
--- a/arch/x86/mm/Makefile
+++ b/arch/x86/mm/Makefile
@@ -52,6 +52,7 @@ obj-$(CONFIG_ACPI_NUMA)		+= srat.o
 obj-$(CONFIG_X86_INTEL_MEMORY_PROTECTION_KEYS)	+= pkeys.o
 obj-$(CONFIG_RANDOMIZE_MEMORY)			+= kaslr.o
 obj-$(CONFIG_MITIGATION_PAGE_TABLE_ISOLATION)	+= pti.o
+obj-$(CONFIG_BROADCAST_TLB_FLUSH)		+= rar.o
 
 obj-$(CONFIG_X86_MEM_ENCRYPT)	+= mem_encrypt.o
 obj-$(CONFIG_AMD_MEM_ENCRYPT)	+= mem_encrypt_amd.o
diff --git a/arch/x86/mm/rar.c b/arch/x86/mm/rar.c
new file mode 100644
index 000000000000..76959782fb03
--- /dev/null
+++ b/arch/x86/mm/rar.c
@@ -0,0 +1,236 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * RAR TLB shootdown
+ */
+#include <linux/sched.h>
+#include <linux/bug.h>
+#include <asm/current.h>
+#include <asm/io.h>
+#include <asm/sync_bitops.h>
+#include <asm/rar.h>
+#include <asm/tlbflush.h>
+
+static DEFINE_PER_CPU(struct cpumask, rar_cpu_mask);
+
+#define RAR_SUCCESS	0x00
+#define RAR_PENDING	0x01
+#define RAR_FAILURE	0x80
+
+#define RAR_MAX_PAYLOADS 64UL
+
+/* How many RAR payloads are supported by this CPU */
+static int rar_max_payloads __ro_after_init = RAR_MAX_PAYLOADS;
+
+/*
+ * RAR payloads telling CPUs what to do. This table is shared between
+ * all CPUs; it is possible to have multiple payload tables shared between
+ * different subsets of CPUs, but that adds a lot of complexity.
+ */
+static struct rar_payload rar_payload[RAR_MAX_PAYLOADS] __page_aligned_bss;
+
+/*
+ * Reduce contention for the RAR payloads by having a small number of
+ * CPUs share a RAR payload entry, instead of a free for all with all CPUs.
+ */
+struct rar_lock {
+	union {
+		raw_spinlock_t lock;
+		char __padding[SMP_CACHE_BYTES];
+	};
+};
+
+static struct rar_lock rar_locks[RAR_MAX_PAYLOADS] __cacheline_aligned;
+
+/*
+ * The action vector tells each CPU which payload table entries
+ * have work for that CPU.
+ */
+static DEFINE_PER_CPU_ALIGNED(u8[RAR_MAX_PAYLOADS], rar_action);
+
+/*
+ * TODO: group CPUs together based on locality in the system instead
+ * of CPU number, to further reduce the cost of contention.
+ */
+static int cpu_rar_payload_number(void)
+{
+	int cpu = raw_smp_processor_id();
+	return cpu % rar_max_payloads;
+}
+
+static int get_payload_slot(void)
+{
+	int payload_nr = cpu_rar_payload_number();
+	raw_spin_lock(&rar_locks[payload_nr].lock);
+	return payload_nr;
+}
+
+static void free_payload_slot(unsigned long payload_nr)
+{
+	raw_spin_unlock(&rar_locks[payload_nr].lock);
+}
+
+static void set_payload(struct rar_payload *p, u16 pcid, unsigned long start,
+			long pages)
+{
+	p->must_be_zero_1	= 0;
+	p->must_be_zero_2	= 0;
+	p->must_be_zero_3	= 0;
+	p->page_size		= RAR_INVLPG_PAGE_SIZE_4K;
+	p->type			= RAR_TYPE_INVPCID;
+	p->pcid			= pcid;
+	p->linear_address	= start;
+
+	if (pcid) {
+		/* RAR invalidation of the mapping of a specific process. */
+		if (pages < RAR_INVLPG_MAX_PAGES) {
+			p->num_pages = pages;
+			p->subtype = RAR_INVPCID_ADDR;
+		} else {
+			p->subtype = RAR_INVPCID_PCID;
+		}
+	} else {
+		/*
+		 * Unfortunately RAR_INVPCID_ADDR excludes global translations.
+		 * Always do a full flush for kernel invalidations.
+		 */
+		p->subtype = RAR_INVPCID_ALL;
+	}
+
+	/* Ensure all writes are visible before the action entry is set. */
+	smp_wmb();
+}
+
+static void set_action_entry(unsigned long payload_nr, int target_cpu)
+{
+	u8 *bitmap = per_cpu(rar_action, target_cpu);
+
+	/*
+	 * Given a remote CPU, "arm" its action vector to ensure it handles
+	 * the request at payload_nr when it receives a RAR signal.
+	 * The remote CPU will overwrite RAR_PENDING when it handles
+	 * the request.
+	 */
+	WRITE_ONCE(bitmap[payload_nr], RAR_PENDING);
+}
+
+static void wait_for_action_done(unsigned long payload_nr, int target_cpu)
+{
+	u8 status;
+	u8 *rar_actions = per_cpu(rar_action, target_cpu);
+
+	status = READ_ONCE(rar_actions[payload_nr]);
+
+	while (status == RAR_PENDING) {
+		cpu_relax();
+		status = READ_ONCE(rar_actions[payload_nr]);
+	}
+
+	WARN_ON_ONCE(rar_actions[payload_nr] != RAR_SUCCESS);
+}
+
+void rar_cpu_init(void)
+{
+	u8 *bitmap;
+	u64 r;
+
+	/* Check if this CPU was already initialized. */
+	rdmsrl(MSR_IA32_RAR_PAYLOAD_BASE, r);
+	if (r == (u64)virt_to_phys(rar_payload))
+		return;
+
+	bitmap = this_cpu_ptr(rar_action);
+	memset(bitmap, 0, RAR_MAX_PAYLOADS);
+	wrmsrl(MSR_IA32_RAR_ACT_VEC, (u64)virt_to_phys(bitmap));
+	wrmsrl(MSR_IA32_RAR_PAYLOAD_BASE, (u64)virt_to_phys(rar_payload));
+
+	/*
+	 * Allow RAR events to be processed while interrupts are disabled on
+	 * a target CPU. This prevents "pileups" where many CPUs are waiting
+	 * on one CPU that has IRQs blocked for too long, and should reduce
+	 * contention on the rar_payload table.
+	 */
+	wrmsrl(MSR_IA32_RAR_CTRL, RAR_CTRL_ENABLE | RAR_CTRL_IGNORE_IF);
+}
+
+void rar_boot_cpu_init(void)
+{
+	int max_payloads;
+	u64 r;
+
+	/* The MSR contains N defining the max [0-N] rar payload slots. */
+	rdmsrl(MSR_IA32_RAR_INFO, r);
+	max_payloads = (r >> 32) + 1;
+
+	/* If this CPU supports less than RAR_MAX_PAYLOADS, lower our limit. */
+	if (max_payloads < rar_max_payloads)
+		rar_max_payloads = max_payloads;
+	pr_info("RAR: support %d payloads\n", max_payloads);
+
+	for (r = 0; r < rar_max_payloads; r++)
+		rar_locks[r].lock = __RAW_SPIN_LOCK_UNLOCKED(rar_lock);
+
+	/* Initialize the boot CPU early to handle early boot flushes. */
+	rar_cpu_init();
+}
+
+/*
+ * Inspired by smp_call_function_many(), but RAR requires a global payload
+ * table rather than per-CPU payloads in the CSD table, because the action
+ * handler is microcode rather than software.
+ */
+void smp_call_rar_many(const struct cpumask *mask, u16 pcid,
+		       unsigned long start, unsigned long end)
+{
+	unsigned long pages = (end - start + PAGE_SIZE) / PAGE_SIZE;
+	int cpu, this_cpu = smp_processor_id();
+	cpumask_t *dest_mask;
+	unsigned long payload_nr;
+
+	/* Catch the "end - start + PAGE_SIZE" overflow above. */
+	if (end == TLB_FLUSH_ALL)
+		pages = RAR_INVLPG_MAX_PAGES + 1;
+
+	/*
+	 * Can deadlock when called with interrupts disabled.
+	 * Allow CPUs that are not yet online though, as no one else can
+	 * send smp call function interrupt to this CPU and as such deadlocks
+	 * can't happen.
+	 */
+	if (cpu_online(this_cpu) && !oops_in_progress && !early_boot_irqs_disabled) {
+		lockdep_assert_irqs_enabled();
+		lockdep_assert_preemption_disabled();
+	}
+
+	/*
+	 * A CPU needs to be initialized in order to process RARs.
+	 * Skip offline CPUs.
+	 *
+	 * TODO:
+	 * - Skip RAR to CPUs that are in a deeper C-state, with an empty TLB
+	 *
+	 * This code cannot use the should_flush_tlb() logic here because
+	 * RAR flushes do not update the tlb_gen, resulting in unnecessary
+	 * flushes at context switch time.
+	 */
+	dest_mask = this_cpu_ptr(&rar_cpu_mask);
+	cpumask_and(dest_mask, mask, cpu_online_mask);
+
+	/* Some callers race with other CPUs changing the passed mask */
+	if (unlikely(!cpumask_weight(dest_mask)))
+		return;
+
+	payload_nr = get_payload_slot();
+	set_payload(&rar_payload[payload_nr], pcid, start, pages);
+
+	for_each_cpu(cpu, dest_mask)
+		set_action_entry(payload_nr, cpu);
+
+	/* Send a message to all CPUs in the map */
+	native_send_rar_ipi(dest_mask);
+
+	for_each_cpu(cpu, dest_mask)
+		wait_for_action_done(payload_nr, cpu);
+
+	free_payload_slot(payload_nr);
+}
+EXPORT_SYMBOL(smp_call_rar_many);
-- 
2.51.1


