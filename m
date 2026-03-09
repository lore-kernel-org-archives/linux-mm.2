Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11983EA854C
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 02:08:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6CEC76B008A; Sun,  8 Mar 2026 22:08:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 64EAE6B008C; Sun,  8 Mar 2026 22:08:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 551146B0092; Sun,  8 Mar 2026 22:08:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 43FE56B008A
	for <linux-mm@kvack.org>; Sun,  8 Mar 2026 22:08:08 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D6A441A0685
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 02:08:07 +0000 (UTC)
X-FDA: 84524889414.17.59B8312
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	by imf23.hostedemail.com (Postfix) with ESMTP id 098D1140004
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 02:08:05 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=OPBlw3bs;
	spf=pass (imf23.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773022086;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jRrnNQfohi2smOuuXp+6eVAaybcvsU0A5HfE+uuiZn8=;
	b=Yp9wJtO4IS552Rp7ZFNzMCDcGsgGMaI3mnL9ryUymvXhEWY8m4MNQZ9YDc+fk8VncBgVlP
	zsOVkmI1BzRJo87iVDkYhsYSE33InX4fFRdHmiTLKksJ89WHbhYLL4/59YuSNC3nIfpIHS
	KimKXbRDtuqh49XbpYzNEZsgmt7vjv0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=OPBlw3bs;
	spf=pass (imf23.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773022086; a=rsa-sha256;
	cv=none;
	b=o43oV1YB3tVgODRrISRhcaV1B3bglHTvdYZSZq+dma41a41OzacVIatZrrta7ITyoHDmMe
	N8Xmgr0Ax7EBn/cJNeU8DPDQktqPBvot6yXSgwKHMPuvVab7tD0PyNQ3N64+2+feBvIwyL
	/DLN4UZdyJm43doyc+BM2YRkYiJp9r4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773022084;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jRrnNQfohi2smOuuXp+6eVAaybcvsU0A5HfE+uuiZn8=;
	b=OPBlw3bshdShj+LXx1jxf/i2sidyMs6K6INVu1Eqq69zxGcgpHB0ot3trKQIKuJYqYuDy5
	ehFk/TYtADr5xYatCpUPN2uup5u1nXZixCunYhTa48RdE6Gt9gC5kkOk40vh19xVbehXM5
	dK+HBRY90Wr2TpYlX4ERA2ynUvzhrxY=
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
Subject: [PATCH v7 2/2] x86/tlb: skip redundant sync IPIs for native TLB flush
Date: Mon,  9 Mar 2026 10:07:11 +0800
Message-ID: <20260309020711.20831-3-lance.yang@linux.dev>
In-Reply-To: <20260309020711.20831-1-lance.yang@linux.dev>
References: <20260309020711.20831-1-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 098D1140004
X-Stat-Signature: p1qpg8dgxz1ztd4edb8f1bc4x4s37q63
X-Rspam-User: 
X-HE-Tag: 1773022085-262033
X-HE-Meta: U2FsdGVkX18kzXwscz4zMzSuehRZLa+RbRQmhR/uFc6nEY3QI+R+EY9vlWcEF75gW+F15Z20jB9zHk4SXGl9hhAnU/po642IWYXqxhsgKu922+WgkPnOY8uhDCOdWniIZ7C9Gs6BKElSHDqqIEUAcSFTrKGwnnuPvZXp1iHmKu/qIzKQ7Yu+/DZi5zFxVZCL0Y62Dqn07VuahBHu7+gfAG0qDrYuUcB7pHzllRBYgGVMhyGihoNsypR2ozgXVDljnFF4E1DhuLQisva0AmjxIh8vEFlX2h0xPM0vt35I5smxkuSZmzhgd3003h5MoYBcJAuJsbGOdPFCUg+9GPhuOG2oOifApUh84C3CmgNdEL/37yw+TUu5VX/yalUkuyrxRbd0nMEePnhkIxIJE+XgwuK6+rsMVZX7gVNdnSs2uYN6efQYUi5XZ8KDjvnC7hqN9PvTyo3JBwKtg8I9iEonTG39BtsZ3BRQjud+78E5yLHE3Ujx+qejV1mfejBXFFEVjm8SH38h37bxEXTLMjvOgu59FAzExWzCR9etctLfRQsKEE9o1A18nUFnDFR8bFeFkToo7BosxOugSS1SAFixN4fgKlKT46eSzeKKkBhv8FU5wvWLl2Rt10kgcXk+HbURzDe3eB60cJndayyqE3YwZAbfFZC4Z9U00Ye96yK7QMIUtb4FFEWE27kAAaZ1leXAQtAtMNoK1j5VVRP1xOHGhqWwBbo0Nz6iaHoCWZGCF7p73nHqcGATOQ6MTr8P9ELRg4vZuH4kKhQSloQ5xpv1cTPamEPp1K8arVqx3TPg/QR31RrzuxPO11ig24pkiVInzr5r/npW+P4T5v96r7mpy7+pnY5UtsfOCL9p0pfbycAc3S/MwLIokAyYIUynHO3HLZR4fsK6J0hcPt47fYnzeQeQ+QknefmXyhqHSLqsnUDalz0go8bJNvPjDgvkDEVq1f7PMP9GO4AZorzFdn8
 +TaIwVpS
 HzD8mtTG6KdQGX5sS/xWjQa2XhCj0Lbrqx3MyNlqhPtVh98qUQjdl4hdHhDUYWlrGLszrCeR+AEQrzbnCzvoW+1C3hAc/8I+Cta9rETxi2IKvxTwjYqzCOULWQKILBTG3+FMBPJEEb3FZqEx6iZBISAyCbE7ew7K7Z4OJIfZcgp6Vyem74QyKiWOCfw2/Os83XIxbw8/91FLcvZWOPHOhXGP6PIFBc8kZ3ivx64o/42Pq4cQSkJizdl1uwe1OU+KPMpPvvVY6PY9eHJ+zB/N8ihqNG4YEufVg42xG6HzOBrm5qtG3YhQ1IsjbeTqwHStOBNdob7X14hbz4f9rkJStqjQXjw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Lance Yang <lance.yang@linux.dev>

Enable the optimization introduced in the previous patch for x86.

native_pv_tlb_init() checks whether native_flush_tlb_multi() is in use.
On CONFIG_PARAVIRT systems, it checks pv_ops; on non-PARAVIRT, native
flush is always in use.

It decides once at boot whether to enable the optimization: if using
native TLB flush and INVLPGB is not supported, we know IPIs were sent
and can skip the redundant sync. The decision is fixed via a static
key as Peter suggested[1].

PV backends (KVM, Xen, Hyper-V) typically have their own implementations
and don't call native_flush_tlb_multi() directly, so they cannot be trusted
to provide the IPI guarantees we need.

Two-step plan as David suggested[2]:

Step 1 (this patch): Skip redundant sync when we're 100% certain the TLB
flush sent IPIs. INVLPGB is excluded because when supported, we cannot
guarantee IPIs were sent, keeping it clean and simple.

Step 2 (future work): Send targeted IPIs only to CPUs actually doing
software/lockless page table walks, benefiting all architectures.

Regarding Step 2, it obviously only applies to setups where Step 1 does
not apply: like x86 with INVLPGB or arm64.

[1] https://lore.kernel.org/linux-mm/20260302145652.GH1395266@noisy.programming.kicks-ass.net/
[2] https://lore.kernel.org/linux-mm/bbfdf226-4660-4949-b17b-0d209ee4ef8c@kernel.org/

Suggested-by: Peter Zijlstra <peterz@infradead.org>
Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Lance Yang <lance.yang@linux.dev>
---
 arch/x86/include/asm/tlb.h      | 17 ++++++++++++++++-
 arch/x86/include/asm/tlbflush.h |  2 ++
 arch/x86/kernel/smpboot.c       |  1 +
 arch/x86/mm/tlb.c               | 15 +++++++++++++++
 4 files changed, 34 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/tlb.h b/arch/x86/include/asm/tlb.h
index 866ea78ba156..99de622d3856 100644
--- a/arch/x86/include/asm/tlb.h
+++ b/arch/x86/include/asm/tlb.h
@@ -5,11 +5,21 @@
 #define tlb_flush tlb_flush
 static inline void tlb_flush(struct mmu_gather *tlb);
 
+#define tlb_table_flush_implies_ipi_broadcast tlb_table_flush_implies_ipi_broadcast
+static inline bool tlb_table_flush_implies_ipi_broadcast(void);
+
 #include <asm-generic/tlb.h>
 #include <linux/kernel.h>
 #include <vdso/bits.h>
 #include <vdso/page.h>
 
+DECLARE_STATIC_KEY_FALSE(tlb_ipi_broadcast_key);
+
+static inline bool tlb_table_flush_implies_ipi_broadcast(void)
+{
+	return static_branch_likely(&tlb_ipi_broadcast_key);
+}
+
 static inline void tlb_flush(struct mmu_gather *tlb)
 {
 	unsigned long start = 0UL, end = TLB_FLUSH_ALL;
@@ -20,7 +30,12 @@ static inline void tlb_flush(struct mmu_gather *tlb)
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
index 5a3cdc439e38..8ba853154b46 100644
--- a/arch/x86/include/asm/tlbflush.h
+++ b/arch/x86/include/asm/tlbflush.h
@@ -18,6 +18,8 @@
 
 DECLARE_PER_CPU(u64, tlbstate_untag_mask);
 
+void __init native_pv_tlb_init(void);
+
 void __flush_tlb_all(void);
 
 #define TLB_FLUSH_ALL	-1UL
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
index 621e09d049cb..8f5585ebaf09 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -26,6 +26,8 @@
 
 #include "mm_internal.h"
 
+DEFINE_STATIC_KEY_FALSE(tlb_ipi_broadcast_key);
+
 #ifdef CONFIG_PARAVIRT
 # define STATIC_NOPV
 #else
@@ -1834,3 +1836,16 @@ static int __init create_tlb_single_page_flush_ceiling(void)
 	return 0;
 }
 late_initcall(create_tlb_single_page_flush_ceiling);
+
+void __init native_pv_tlb_init(void)
+{
+#ifdef CONFIG_PARAVIRT
+	if (pv_ops.mmu.flush_tlb_multi != native_flush_tlb_multi)
+		return;
+#endif
+
+	if (cpu_feature_enabled(X86_FEATURE_INVLPGB))
+		return;
+
+	static_branch_enable(&tlb_ipi_broadcast_key);
+}
-- 
2.49.0


