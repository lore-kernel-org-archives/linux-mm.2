Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B2DFEDEC01
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 02:11:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE60A6B008A; Tue,  3 Mar 2026 21:11:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC7326B008C; Tue,  3 Mar 2026 21:11:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F0866B0092; Tue,  3 Mar 2026 21:11:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9064B6B008A
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 21:11:35 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3C4C01C344
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 02:11:35 +0000 (UTC)
X-FDA: 84506754150.22.B8B9187
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf03.hostedemail.com (Postfix) with ESMTP id 80BBF2000B
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 02:11:33 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VnOIi4NJ;
	spf=pass (imf03.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772590293;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6zO2kH0svbHx3wC9dGJj7zDc7KLoM6zIa0KkqCo/aKA=;
	b=hJ0EJxdLJDDsScDP4Z2N64vY3Tq+o0j9YOaN9lmlTwA3YzE7xf60c6qsxJH/+tgbIUaM1p
	WJCtaQ06LiK5FCqFXArV59ulO88O3onuu1i0Q+2zcM4XWhSQn/AEhYwdm0s0Nf6dYrSGez
	LULnz+36Njmp6Dl/onDpHz/aN78b618=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VnOIi4NJ;
	spf=pass (imf03.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772590293; a=rsa-sha256;
	cv=none;
	b=q1sbaxEqFdLaTBKBsAc/z0QPs6o9ORwn3tgZzKMnkJTxKEsdGaaoI3oEYhT4ICzJXcIAUO
	cr8PwNnjCpfRmUP1pdl59iIQWrpcVf/0m9qe8BjAjcaZCIUdlBjl8WwDes7y9Baw5+MAC4
	srjpMtviH2LfuQ6xZSVC5TMId5i4nKw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772590291;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6zO2kH0svbHx3wC9dGJj7zDc7KLoM6zIa0KkqCo/aKA=;
	b=VnOIi4NJ2EAfX/nJqT5BK5btiveTdW/sa7Ufo95ckq7KxfH+fb9DlRhbQLGWI10vo44wj6
	THZ5iYwXvG+I5znKhcEaqG2aVir82NnjBTbMyM/LATr4O8EOzIcytdSBKzKgrrG9Igngfp
	5zJ8ygBTJBc4R4ThrC5ulNktptEwybI=
From: Lance Yang <lance.yang@linux.dev>
To: akpm@linux-foundation.org
Cc: peterz@infradead.org,
	david@kernel.org,
	dave.hansen@intel.com,
	dave.hansen@linux.intel.com,
	ypodemsk@redhat.com,
	hughd@google.com,
	will@kernel.org,
	aneesh.kumar@kernel.org,
	npiggin@gmail.com,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	x86@kernel.org,
	hpa@zytor.com,
	arnd@arndb.de,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	shy828301@gmail.com,
	riel@surriel.com,
	jannh@google.com,
	jgross@suse.com,
	seanjc@google.com,
	pbonzini@redhat.com,
	boris.ostrovsky@oracle.com,
	virtualization@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arch@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	ioworker0@gmail.com,
	Lance Yang <lance.yang@linux.dev>
Subject: [PATCH v6 2/2] x86/tlb: skip redundant sync IPIs for native TLB flush
Date: Wed,  4 Mar 2026 10:10:44 +0800
Message-ID: <20260304021046.18550-3-lance.yang@linux.dev>
In-Reply-To: <20260304021046.18550-1-lance.yang@linux.dev>
References: <20260304021046.18550-1-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 80BBF2000B
X-Rspamd-Server: rspam08
X-Stat-Signature: omzwrhj1axxyo3fkifspyex4xzqh36pn
X-HE-Tag: 1772590293-658656
X-HE-Meta: U2FsdGVkX18SZjUzIs+PFR85+6XKHuq3KRIManCZttsEuv6tunp4vYX35V/2HARdY3JHnoh6ZBXKgWZj8TSECx1jvl6Zbcr7g0rl06zpPKjWmVJhgkVY9FVHuT0qm7ykYw4ODIWV69Q/tctSf6SFY2uQw8KeJ22C3B4H36EwqUn1hA0irUb+pkDIZ5vYy/nm/mILcgZKlR8F3mNvTAIMvFoydSoQdUOjnkKiCl7B7bhrsptfue+hhP8rR2HqWo0ZUavWLgJAPCzbeYNntJswqYkaWSVfklXneHWkmjTP3f/VEZmwqvfnG//HsTYTXP63rosMNgPxMTunGlgBMFI+PGTPPi/SgE0lSgmWQ9upUXUh/ZpS7/stWypS+ZfSvkidzAaQRtJ28ghhr5xk70DGrfYIGCeasEpvKsW9yuCsxNU6MO3YfIh/ViWEBbEcjjq4mJqySOZk8HeIMF/d82ciYu+U6iMatVwagDXrC6lzyE0j3yjq2YJTlnN9mD5xgSkvmi/L5c42S34DzQpUHBlj2vaiWoIOU8XoXk2C2cbT00UbdxQqGPLlBz6jUNcqaE74yZpOKdPC1MN3xvQeX5piU4UyzabL3gs38/1Ee6mKkY/DIElXpLNGUKtzWfmEMjPKp2HIDvEtjAsIGP66hgiUEwrwoIebSqCaJ0myeqE3VAvyofvVQ6qwuuGDMKl1snZU4iRDE5D6Af1Z7twGubKDP3J1LyLvaSZueS5i6uYbDXyqe+aRNm7EocB2DyZPBERrW0nnSI6gMrGcv86RiEqCxrv8hIPOTbmyiXFC+18KtNrqxag/Ht57fi3rPoaNtfMvqbeVdHVP9Tz1k27F1Yk9vL6OMtTQXsu7J5thLic+QkoTQKjwhf3hVu3WbizuSK//ZAQVs24BDGXZ9lfIJsCdVyhiq1K0j/ovH4mkh37FOQswu8E+0HeL5Q4Pb3J3OHDgIj63w2+X0SOYNd7G134
 Qbq8yYyn
 YuhYctRymVJOEQIbOR9jcWou+BVdO7t2KSciy+C5culBIFKzVhbTDhKn23vmKMR5D7BqGp14rmjrAfvBz5/hL1kS+s+8FL0PQZHXsbCpOSUk7Tp62VvfzLDo1IvA02Ah1Me2YmRV5adGXCrEfBgxZ9UhH0TJfabdUNMd7+EZonA54PGPH58jI5uO4D8SVVjNlOEfjPjZrrn1/Py6tyPtG/RFOKw23VsYM7a6r
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Lance Yang <lance.yang@linux.dev>

Enable the optimization introduced in the previous patch for x86.

Add pv_ops.mmu.flush_tlb_multi_implies_ipi_broadcast to track whether
flush_tlb_multi() sends real IPIs. Initialize it once in
native_pv_tlb_init() during boot.

On CONFIG_PARAVIRT systems, tlb_table_flush_implies_ipi_broadcast() reads
the pv_ops property. On non-PARAVIRT, it directly checks for INVLPGB.

PV backends (KVM, Xen, Hyper-V) typically have their own implementations
and don't call native_flush_tlb_multi() directly, so they cannot be trusted
to provide the IPI guarantees we need. They keep the property false.

Two-step plan as David suggested[1]:

Step 1 (this patch): Skip redundant sync when we're 100% certain the TLB
flush sent IPIs. INVLPGB is excluded because when supported, we cannot
guarantee IPIs were sent, keeping it clean and simple.

Step 2 (future work): Send targeted IPIs only to CPUs actually doing
software/lockless page table walks, benefiting all architectures.

Regarding Step 2, it obviously only applies to setups where Step 1 does
not apply: like x86 with INVLPGB or arm64.

[1] https://lore.kernel.org/linux-mm/bbfdf226-4660-4949-b17b-0d209ee4ef8c@kernel.org/

Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Lance Yang <lance.yang@linux.dev>
---
 arch/x86/include/asm/paravirt_types.h |  5 +++++
 arch/x86/include/asm/smp.h            |  3 +++
 arch/x86/include/asm/tlb.h            | 16 +++++++++++++++-
 arch/x86/include/asm/tlbflush.h       |  3 +++
 arch/x86/kernel/paravirt.c            | 20 ++++++++++++++++++++
 arch/x86/kernel/smpboot.c             |  1 +
 arch/x86/mm/tlb.c                     | 14 ++++++++++++++
 7 files changed, 61 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/paravirt_types.h b/arch/x86/include/asm/paravirt_types.h
index 9bcf6bce88f6..ec01268f2e3e 100644
--- a/arch/x86/include/asm/paravirt_types.h
+++ b/arch/x86/include/asm/paravirt_types.h
@@ -112,6 +112,11 @@ struct pv_mmu_ops {
 	void (*flush_tlb_multi)(const struct cpumask *cpus,
 				const struct flush_tlb_info *info);
 
+	/*
+	 * True if flush_tlb_multi() sends real IPIs to all target CPUs.
+	 */
+	bool flush_tlb_multi_implies_ipi_broadcast;
+
 	/* Hook for intercepting the destruction of an mm_struct. */
 	void (*exit_mmap)(struct mm_struct *mm);
 	void (*notify_page_enc_status_changed)(unsigned long pfn, int npages, bool enc);
diff --git a/arch/x86/include/asm/smp.h b/arch/x86/include/asm/smp.h
index 84951572ab81..ef1fe0cc4c73 100644
--- a/arch/x86/include/asm/smp.h
+++ b/arch/x86/include/asm/smp.h
@@ -105,6 +105,9 @@ void native_smp_prepare_boot_cpu(void);
 void smp_prepare_cpus_common(void);
 void native_smp_prepare_cpus(unsigned int max_cpus);
 void native_smp_cpus_done(unsigned int max_cpus);
+
+void __init native_pv_tlb_init(void);
+
 int common_cpu_up(unsigned int cpunum, struct task_struct *tidle);
 int native_kick_ap(unsigned int cpu, struct task_struct *tidle);
 int native_cpu_disable(void);
diff --git a/arch/x86/include/asm/tlb.h b/arch/x86/include/asm/tlb.h
index 866ea78ba156..532578c5a2e7 100644
--- a/arch/x86/include/asm/tlb.h
+++ b/arch/x86/include/asm/tlb.h
@@ -5,10 +5,19 @@
 #define tlb_flush tlb_flush
 static inline void tlb_flush(struct mmu_gather *tlb);
 
+#define tlb_table_flush_implies_ipi_broadcast tlb_table_flush_implies_ipi_broadcast
+static inline bool tlb_table_flush_implies_ipi_broadcast(void);
+
 #include <asm-generic/tlb.h>
 #include <linux/kernel.h>
 #include <vdso/bits.h>
 #include <vdso/page.h>
+#include <asm/paravirt.h>
+
+static inline bool tlb_table_flush_implies_ipi_broadcast(void)
+{
+	return static_branch_likely(&tlb_ipi_broadcast_key);
+}
 
 static inline void tlb_flush(struct mmu_gather *tlb)
 {
@@ -20,7 +29,12 @@ static inline void tlb_flush(struct mmu_gather *tlb)
 		end = tlb->end;
 	}
 
-	flush_tlb_mm_range(tlb->mm, start, end, stride_shift, tlb->freed_tables);
+	/*
+	 * Pass both freed_tables and unshared_tables so that lazy-TLB CPUs
+	 * also receive IPIs during unsharing page tables.
+	 */
+	flush_tlb_mm_range(tlb->mm, start, end, stride_shift,
+			   tlb->freed_tables || tlb->unshared_tables);
 }
 
 static inline void invlpg(unsigned long addr)
diff --git a/arch/x86/include/asm/tlbflush.h b/arch/x86/include/asm/tlbflush.h
index 5a3cdc439e38..a1b5efef3b90 100644
--- a/arch/x86/include/asm/tlbflush.h
+++ b/arch/x86/include/asm/tlbflush.h
@@ -5,6 +5,7 @@
 #include <linux/mm_types.h>
 #include <linux/mmu_notifier.h>
 #include <linux/sched.h>
+#include <linux/jump_label.h>
 
 #include <asm/barrier.h>
 #include <asm/processor.h>
@@ -18,6 +19,8 @@
 
 DECLARE_PER_CPU(u64, tlbstate_untag_mask);
 
+DECLARE_STATIC_KEY_FALSE(tlb_ipi_broadcast_key);
+
 void __flush_tlb_all(void);
 
 #define TLB_FLUSH_ALL	-1UL
diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
index a6ed52cae003..c8decadf16e0 100644
--- a/arch/x86/kernel/paravirt.c
+++ b/arch/x86/kernel/paravirt.c
@@ -154,6 +154,7 @@ struct paravirt_patch_template pv_ops = {
 	.mmu.flush_tlb_kernel	= native_flush_tlb_global,
 	.mmu.flush_tlb_one_user	= native_flush_tlb_one_user,
 	.mmu.flush_tlb_multi	= native_flush_tlb_multi,
+	.mmu.flush_tlb_multi_implies_ipi_broadcast = false,
 
 	.mmu.exit_mmap		= paravirt_nop,
 	.mmu.notify_page_enc_status_changed	= paravirt_nop,
@@ -221,3 +222,22 @@ NOKPROBE_SYMBOL(native_load_idt);
 
 EXPORT_SYMBOL(pv_ops);
 EXPORT_SYMBOL_GPL(pv_info);
+
+void __init native_pv_tlb_init(void)
+{
+	/*
+	 * If PV backend already set the property, respect it.
+	 * Otherwise, check if native TLB flush sends real IPIs to all target
+	 * CPUs (i.e., not using INVLPGB broadcast invalidation).
+	 */
+	if (pv_ops.mmu.flush_tlb_multi_implies_ipi_broadcast) {
+		static_branch_enable(&tlb_ipi_broadcast_key);
+		return;
+	}
+
+	if (pv_ops.mmu.flush_tlb_multi == native_flush_tlb_multi &&
+	    !cpu_feature_enabled(X86_FEATURE_INVLPGB)) {
+		pv_ops.mmu.flush_tlb_multi_implies_ipi_broadcast = true;
+		static_branch_enable(&tlb_ipi_broadcast_key);
+	}
+}
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 5cd6950ab672..3cdb04162843 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1167,6 +1167,7 @@ void __init native_smp_prepare_boot_cpu(void)
 		switch_gdt_and_percpu_base(me);
 
 	native_pv_lock_init();
+	native_pv_tlb_init();
 }
 
 void __init native_smp_cpus_done(unsigned int max_cpus)
diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
index 621e09d049cb..7b1acfb97782 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -26,6 +26,8 @@
 
 #include "mm_internal.h"
 
+DEFINE_STATIC_KEY_FALSE(tlb_ipi_broadcast_key);
+
 #ifdef CONFIG_PARAVIRT
 # define STATIC_NOPV
 #else
@@ -1834,3 +1836,15 @@ static int __init create_tlb_single_page_flush_ceiling(void)
 	return 0;
 }
 late_initcall(create_tlb_single_page_flush_ceiling);
+
+#ifndef CONFIG_PARAVIRT
+void __init native_pv_tlb_init(void)
+{
+	/*
+	 * For non-PARAVIRT builds, check if native TLB flush sends real IPIs
+	 * (i.e., not using INVLPGB broadcast invalidation).
+	 */
+	if (!cpu_feature_enabled(X86_FEATURE_INVLPGB))
+		static_branch_enable(&tlb_ipi_broadcast_key);
+}
+#endif
-- 
2.49.0


