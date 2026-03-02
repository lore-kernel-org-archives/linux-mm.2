Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20E83D58E62
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 06:31:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 88B206B00AD; Mon,  2 Mar 2026 01:31:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 837C86B00AF; Mon,  2 Mar 2026 01:31:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7371B6B00B0; Mon,  2 Mar 2026 01:31:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5EEDC6B00AD
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 01:31:41 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E446EC2C24
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 06:31:40 +0000 (UTC)
X-FDA: 84500151960.06.FF4CBBF
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	by imf19.hostedemail.com (Postfix) with ESMTP id 34CD11A0002
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 06:31:38 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YibaaDZz;
	spf=pass (imf19.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772433099;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I8gx42IHYEQCTDsiOiivkLZbaQbWhY24E85Lk6w39Tk=;
	b=ncgc4pov80CSZyQNI1pFmje5GB1yiI59aIOaDZUYO4nSh7TMQcVP5LPa+VzTArpEkY7mJJ
	fQKxjrAQ8VzjTagalimRwv6OrdYAypDdaG3QcrR7+ws8xQgWVYnfTMnjqtO8ONr9wBWqos
	3WecD3GbHTP3e2GYfDc2pyQon7kxtEg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772433099; a=rsa-sha256;
	cv=none;
	b=lbBcAjWcqA6M18JniK9uxjDH45Rssp7xKJhpfj8VjqcAf+HE4z77+9OWb3A9ubG8ueAPv4
	SP4ogXBXfC7zZOFCu1/71sOcyzSSPIOcF4r0PZ6lvokwxCHlyMOJTMBS9hr8jQGo7EDWsd
	x4JkfH/JvX0YSlluvQTTwzbivfiqPJM=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YibaaDZz;
	spf=pass (imf19.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772433097;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=I8gx42IHYEQCTDsiOiivkLZbaQbWhY24E85Lk6w39Tk=;
	b=YibaaDZzBLg3a/3Lzh5+odGfgFy4rKCclMUZCLJe8oVE/bwTQq5eeGRW2n/iATLhzlFuh5
	X0ieBE+2QbmggG/hWHCuLDq7DvHNaU84T2oUFsxdeTGqgWB5DpcfOGmuitzwpJz9A6mSNO
	KMYpAP3NT27u9rnisSuI3b0J57v1rSU=
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
Subject: [PATCH v5 2/2] x86/tlb: skip redundant sync IPIs for native TLB flush
Date: Mon,  2 Mar 2026 14:30:36 +0800
Message-ID: <20260302063048.9479-3-lance.yang@linux.dev>
In-Reply-To: <20260302063048.9479-1-lance.yang@linux.dev>
References: <20260302063048.9479-1-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: mbuhxtjw6n51yr649nneyrtzyu9m71ej
X-Rspam-User: 
X-Rspamd-Queue-Id: 34CD11A0002
X-Rspamd-Server: rspam12
X-HE-Tag: 1772433098-506439
X-HE-Meta: U2FsdGVkX1+qynb58Qczc4oGIJy7m1kWAk6+6UTXxVDsJIEgekM36OUo7OaE8CZG920PY7Hke21HpdaG355czNtIpxQHds/Pht1n0pcnRcxMz1VHRYOi7/svfVVCM9v+WqdHyY14AlFYq8emEolKOY/pNH56qBNQwSlQBOKKDvW8o9cnygLo4aSxLZC9O1UJGL9q0bTvZRylIOjo2oF6k3KVTpbiuLJtBWU787ZFnFoeqQGWIHD3jPTrFEIxBFGO6zlVW8/aum/k6caplOVQ2eTEFkxR7SH7mn6zNdGEFoZMQIJZ0dnJeQyjoUZPGXB/vQ/42F5d9wkSz6JiVwvTqZYbSk0a/3JIoBkwRToapEcwbdbNDrj67D3polOrtLA2UJxkKxhRTqzy/x0CeYbR1jbEhVBCM3QzkcJ0GySZa3V2QQpVVMP6iZJACBEiPrYBZd22pugTRTavWWlzKYxsAPSK0kDOGkNmwO4rjfPE8RpQhzRe9d3Mooc4CZMIv5043Aqgx+CGlzzERaOF5SFlFKL++ONozR6td7KJd58coECwTntL6gA+wEjVb1Kn8xsgW6YG8JsBmz4ewZO23jn3U6ffLRKLDGTpuTv56Puve01Z+IwOkk0sV5skFEGoaq9EimoZsI3xJ2JHh7MsnXgYUEOv6/1i8hD/gKHbyuyyNEJgmf+9MV3vgNHacH7UvWaAJgH+Lapm+P4O2XjE7iz+X9hsyJb9sc/a+mOAoIImFW1wzE2oYzCPKJdPblZbU3vVNNWXJMaKFrtrAmKpaqJXKis96aDpjMa6fTeqsduuHC+Cwr1oGfO3uFW85Eh7gbgK/uiGsFTF83d6pvnTr30eB5kwugL0K2+7w4UB0eX5FcQV+FVsZDNj3QC/wPcApp8Q/LcNzVKDa/K110a3GDMP4H/kpD3D2H3XKUhY0JOLF5UFELWCRV0PzR6ZHHxGU1PrIa5bgY320/gLUBUgXC9
 1+q+0STN
 yZG2UA7cweboYr9LjJR9NPvWAys3vrUNAfVRLeTkKHFdnNzy3lPbUcR9ZstBMx91O2LUaji2nVBUGFCQzT/nwxOLqUmSsiBTdtQgzrOmyxfoOmpS78VyCPPWcAsFwwwpyubyWkx3OrVx5k2luA4rm10XgGs+iqS7sFAia95TsES0neesBW8PlyAYEcj11KASsaxx8djxDPeKzmv7KH6x3YC0+Q1/o5momQhWwGQ326DD6NVb6d1KizlGgnpSM8750PQND
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
 arch/x86/include/asm/smp.h            |  7 +++++++
 arch/x86/include/asm/tlb.h            | 20 +++++++++++++++++++-
 arch/x86/kernel/paravirt.c            | 16 ++++++++++++++++
 arch/x86/kernel/smpboot.c             |  1 +
 5 files changed, 48 insertions(+), 1 deletion(-)

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
index 84951572ab81..4ac175414ac1 100644
--- a/arch/x86/include/asm/smp.h
+++ b/arch/x86/include/asm/smp.h
@@ -105,6 +105,13 @@ void native_smp_prepare_boot_cpu(void);
 void smp_prepare_cpus_common(void);
 void native_smp_prepare_cpus(unsigned int max_cpus);
 void native_smp_cpus_done(unsigned int max_cpus);
+
+#ifdef CONFIG_PARAVIRT
+void __init native_pv_tlb_init(void);
+#else
+static inline void native_pv_tlb_init(void) { }
+#endif
+
 int common_cpu_up(unsigned int cpunum, struct task_struct *tidle);
 int native_kick_ap(unsigned int cpu, struct task_struct *tidle);
 int native_cpu_disable(void);
diff --git a/arch/x86/include/asm/tlb.h b/arch/x86/include/asm/tlb.h
index 866ea78ba156..87ef7147eac8 100644
--- a/arch/x86/include/asm/tlb.h
+++ b/arch/x86/include/asm/tlb.h
@@ -5,10 +5,23 @@
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
+#ifdef CONFIG_PARAVIRT
+	return pv_ops.mmu.flush_tlb_multi_implies_ipi_broadcast;
+#else
+	return !cpu_feature_enabled(X86_FEATURE_INVLPGB);
+#endif
+}
 
 static inline void tlb_flush(struct mmu_gather *tlb)
 {
@@ -20,7 +33,12 @@ static inline void tlb_flush(struct mmu_gather *tlb)
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
diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
index a6ed52cae003..b681b8319295 100644
--- a/arch/x86/kernel/paravirt.c
+++ b/arch/x86/kernel/paravirt.c
@@ -154,6 +154,7 @@ struct paravirt_patch_template pv_ops = {
 	.mmu.flush_tlb_kernel	= native_flush_tlb_global,
 	.mmu.flush_tlb_one_user	= native_flush_tlb_one_user,
 	.mmu.flush_tlb_multi	= native_flush_tlb_multi,
+	.mmu.flush_tlb_multi_implies_ipi_broadcast = false,
 
 	.mmu.exit_mmap		= paravirt_nop,
 	.mmu.notify_page_enc_status_changed	= paravirt_nop,
@@ -221,3 +222,18 @@ NOKPROBE_SYMBOL(native_load_idt);
 
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
+	if (pv_ops.mmu.flush_tlb_multi_implies_ipi_broadcast)
+		return;
+
+	if (pv_ops.mmu.flush_tlb_multi == native_flush_tlb_multi &&
+	    !cpu_feature_enabled(X86_FEATURE_INVLPGB))
+		pv_ops.mmu.flush_tlb_multi_implies_ipi_broadcast = true;
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
-- 
2.49.0


