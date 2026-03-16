Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C6B7F30298
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 02:36:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B29A6B00FA; Sun, 15 Mar 2026 22:36:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 636756B00FB; Sun, 15 Mar 2026 22:36:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 517696B00FC; Sun, 15 Mar 2026 22:36:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3E69D6B00FA
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 22:36:46 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C872A1A0DBF
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 02:36:45 +0000 (UTC)
X-FDA: 84550363170.16.AADE69C
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	by imf28.hostedemail.com (Postfix) with ESMTP id B44AEC0005
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 02:36:43 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JyucV4QL;
	spf=pass (imf28.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773628604;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fL2ocGYrCU73YIvyxsIf7Pv7ZgK5y+PdJrpmfGXFYuY=;
	b=73CHVjSQuBgSmWHwGz7XbXdEYmO7cWAiHDs+mz524asZHUzSBemZrGdshJb1KOv0kfKGwr
	6T18qppSUcf7cw9CDbISKFis6/SUOiDt+DpGRpANLg4asaWoKgsxVReLIti6U7iZnRCzl2
	QvWvU8zxKGtFNv5/2JAfH2Ek+nw3axQ=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JyucV4QL;
	spf=pass (imf28.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773628604; a=rsa-sha256;
	cv=none;
	b=YqIekx9onraWfURg3ImYbeoIi4w/VAfSGXwU/hG2alRLTQmybKg8SB1HXTsEVJpirBhJtr
	qfJAb0L+sHJJXflzc11nT+j6uHOVG/koRRP30E7a1dX6c+PoxpOPsCI3bvd3Hrk5+FXsOx
	c9NmecZVcBdxnmnDC6BQ6YdPrn4ko00=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773628600;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fL2ocGYrCU73YIvyxsIf7Pv7ZgK5y+PdJrpmfGXFYuY=;
	b=JyucV4QL5mIFot5WZ/H/DQExVZoMvI++Bbbamzm67TTpLUQmbnNIpJComi8c84KBV+zqEd
	+3WpzzW3KVAYXUYO54k++7UTAtCr31rZG2j+U4VUNK5TozudqnpHjFdU6BbReevmLv9cIl
	o+0/ctOpiVrJvPCSAmWaSxXTK1rbHEk=
From: Lance Yang <lance.yang@linux.dev>
To: dave.hansen@intel.com,
	peterz@infradead.org
Cc: akpm@linux-foundation.org,
	david@kernel.org,
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
Subject: Re: [PATCH v7 2/2] x86/tlb: skip redundant sync IPIs for native TLB flush
Date: Mon, 16 Mar 2026 10:36:30 +0800
Message-Id: <20260316023630.92368-1-lance.yang@linux.dev>
In-Reply-To: <20260309020711.20831-3-lance.yang@linux.dev>
References: <20260309020711.20831-3-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: B44AEC0005
X-Rspamd-Server: rspam08
X-Stat-Signature: m58d3rhfnuhibebekf3xuufuhrm5xnpj
X-HE-Tag: 1773628603-395864
X-HE-Meta: U2FsdGVkX1/S3vOUO4GCZIDJTL6Ac6CfDcjwD0Uoaj6HGcXTI7I5JnfOaDmI7aVMpihIlpN7PqrFZsnvKnpLJt9T0LdA9bJsCNFcjAraOpzwWmN2U4z2ti463EY+JHpCrAOKWdpIJqpX3V9A8CkdxBwVFaOTq180gOLmju+1j/lE2+zS2x4hlUwhOltCvj2bn7dkygUAd0k5dwhMTpgC/Pta4WXeH8+g7clJU2Md7mDneP6NBFTeDh306dEyRxUsZg1IMfmr4PBx43RYvZQ4i/VUrIha+jn1ecRBu7eBGvm6CR5UoyGh5/X18JloEloq4BE8hZgft5HIlLgVv6NXCDw6XGlZmBnStewZLHhNvNTSYd5C9I/gUNOxqA3NTdNbijBjVvyjf3InZ3tmXSoUv1LybqEhJZjvrkxl+SzNhbTanvvvb96EzbBCIPQ/yWv6V61axqfZvw9et7Erqg7jwbxPZhyfE3R17iZ3QI7SJaP1S8A9HTilnbjgqcIqKW84ZqOIBIDIatEuyxWmP0ug5hovfdV/67AReWaOp20vrpJ3VEFpbaRBx52JvO1I+KTBrsEkIQ6mkR50NlbDIr6ZUhMN2m6cIsphVD1X5fURELD5QZvT0q4VdQdBT/Dlq7BHr9jbB5XqKesAfF0Gvi6Fm0lWpZKbHaHnq3FZ4kb3vf4N96MsGcEg+mapUqTagjmzOZp8nqeFT4zDp6yKGy6Td5NAQlGA7nBqH6Noxgk3Sw9G45wdKhZUPIyBkv8D/pywu4tv50GItJ4TidXRX3apRjCfND80caNWwtaHCVQI4iRjaQ6oUW1PLrA3zhdzRc2zagLUuL5Qz7AMsFEx7YX7vKjtgUL5GYwPx8yRB4L6L5AP/briZm/AdZHwynYMjbZwZo822waOpPCcS73zhems79mXoMyVYGu2N0QIZ63bGE6peSqGrLV7yd5bT2hOGv9KgJUb4ZPRPNnj/ylmmZr
 GTPzllfU
 KxrBo+ZG6ZfDxagXy8OXsw2kQbMML3F8NZLz3u6k1+yPECDknQ8p+R0AdEbTV46SXkZiZ1STZXwBe1xvvYDusgnkGblJABybvVeLg0PPOs++YqCtLY9qRRp8aM9IPNxGPf8h6Rn4ZrfzNX/LnEOJZMxjfsSv9hQO4nqm2yR+UU/tcc5+SnreiyLiLfWgwY3qIbeS5rgRuI4hG1xtRwLFQaiSgjQAEM7Mww2MZEsnc42N+zk4R6y8sI4TCSCAO2DmPpJJyHyscjbOGzBUlA8Cbom8UFJnbLR6sywI25CYYEuxpUbTEEPRGzKrL6Rs5a5OCYj2PcMoD4R8eS1RFYkLvNC9CHj8u2oBxVHn8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Gently ping :)

On Mon, Mar 09, 2026 at 10:07:11AM +0800, Lance Yang wrote:
>From: Lance Yang <lance.yang@linux.dev>
>
>Enable the optimization introduced in the previous patch for x86.
>
>native_pv_tlb_init() checks whether native_flush_tlb_multi() is in use.
>On CONFIG_PARAVIRT systems, it checks pv_ops; on non-PARAVIRT, native
>flush is always in use.
>
>It decides once at boot whether to enable the optimization: if using
>native TLB flush and INVLPGB is not supported, we know IPIs were sent
>and can skip the redundant sync. The decision is fixed via a static
>key as Peter suggested[1].
>
>PV backends (KVM, Xen, Hyper-V) typically have their own implementations
>and don't call native_flush_tlb_multi() directly, so they cannot be trusted
>to provide the IPI guarantees we need.
>
>Two-step plan as David suggested[2]:
>
>Step 1 (this patch): Skip redundant sync when we're 100% certain the TLB
>flush sent IPIs. INVLPGB is excluded because when supported, we cannot
>guarantee IPIs were sent, keeping it clean and simple.
>
>Step 2 (future work): Send targeted IPIs only to CPUs actually doing
>software/lockless page table walks, benefiting all architectures.
>
>Regarding Step 2, it obviously only applies to setups where Step 1 does
>not apply: like x86 with INVLPGB or arm64.
>
>[1] https://lore.kernel.org/linux-mm/20260302145652.GH1395266@noisy.programming.kicks-ass.net/
>[2] https://lore.kernel.org/linux-mm/bbfdf226-4660-4949-b17b-0d209ee4ef8c@kernel.org/
>
>Suggested-by: Peter Zijlstra <peterz@infradead.org>
>Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
>Signed-off-by: Lance Yang <lance.yang@linux.dev>
>---
> arch/x86/include/asm/tlb.h      | 17 ++++++++++++++++-
> arch/x86/include/asm/tlbflush.h |  2 ++
> arch/x86/kernel/smpboot.c       |  1 +
> arch/x86/mm/tlb.c               | 15 +++++++++++++++
> 4 files changed, 34 insertions(+), 1 deletion(-)
>
>diff --git a/arch/x86/include/asm/tlb.h b/arch/x86/include/asm/tlb.h
>index 866ea78ba156..99de622d3856 100644
>--- a/arch/x86/include/asm/tlb.h
>+++ b/arch/x86/include/asm/tlb.h
>@@ -5,11 +5,21 @@
> #define tlb_flush tlb_flush
> static inline void tlb_flush(struct mmu_gather *tlb);
> 
>+#define tlb_table_flush_implies_ipi_broadcast tlb_table_flush_implies_ipi_broadcast
>+static inline bool tlb_table_flush_implies_ipi_broadcast(void);
>+
> #include <asm-generic/tlb.h>
> #include <linux/kernel.h>
> #include <vdso/bits.h>
> #include <vdso/page.h>
> 
>+DECLARE_STATIC_KEY_FALSE(tlb_ipi_broadcast_key);
>+
>+static inline bool tlb_table_flush_implies_ipi_broadcast(void)
>+{
>+	return static_branch_likely(&tlb_ipi_broadcast_key);
>+}
>+
> static inline void tlb_flush(struct mmu_gather *tlb)
> {
> 	unsigned long start = 0UL, end = TLB_FLUSH_ALL;
>@@ -20,7 +30,12 @@ static inline void tlb_flush(struct mmu_gather *tlb)
> 		end = tlb->end;
> 	}
> 
>-	flush_tlb_mm_range(tlb->mm, start, end, stride_shift, tlb->freed_tables);
>+	/*
>+	 * Pass both freed_tables and unshared_tables so that lazy-TLB CPUs
>+	 * also receive IPIs during unsharing page tables.
>+	 */
>+	flush_tlb_mm_range(tlb->mm, start, end, stride_shift,
>+			   tlb->freed_tables || tlb->unshared_tables);
> }
> 
> static inline void invlpg(unsigned long addr)
>diff --git a/arch/x86/include/asm/tlbflush.h b/arch/x86/include/asm/tlbflush.h
>index 5a3cdc439e38..8ba853154b46 100644
>--- a/arch/x86/include/asm/tlbflush.h
>+++ b/arch/x86/include/asm/tlbflush.h
>@@ -18,6 +18,8 @@
> 
> DECLARE_PER_CPU(u64, tlbstate_untag_mask);
> 
>+void __init native_pv_tlb_init(void);
>+
> void __flush_tlb_all(void);
> 
> #define TLB_FLUSH_ALL	-1UL
>diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
>index 5cd6950ab672..3cdb04162843 100644
>--- a/arch/x86/kernel/smpboot.c
>+++ b/arch/x86/kernel/smpboot.c
>@@ -1167,6 +1167,7 @@ void __init native_smp_prepare_boot_cpu(void)
> 		switch_gdt_and_percpu_base(me);
> 
> 	native_pv_lock_init();
>+	native_pv_tlb_init();
> }
> 
> void __init native_smp_cpus_done(unsigned int max_cpus)
>diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
>index 621e09d049cb..8f5585ebaf09 100644
>--- a/arch/x86/mm/tlb.c
>+++ b/arch/x86/mm/tlb.c
>@@ -26,6 +26,8 @@
> 
> #include "mm_internal.h"
> 
>+DEFINE_STATIC_KEY_FALSE(tlb_ipi_broadcast_key);
>+
> #ifdef CONFIG_PARAVIRT
> # define STATIC_NOPV
> #else
>@@ -1834,3 +1836,16 @@ static int __init create_tlb_single_page_flush_ceiling(void)
> 	return 0;
> }
> late_initcall(create_tlb_single_page_flush_ceiling);
>+
>+void __init native_pv_tlb_init(void)
>+{
>+#ifdef CONFIG_PARAVIRT
>+	if (pv_ops.mmu.flush_tlb_multi != native_flush_tlb_multi)
>+		return;
>+#endif
>+
>+	if (cpu_feature_enabled(X86_FEATURE_INVLPGB))
>+		return;
>+
>+	static_branch_enable(&tlb_ipi_broadcast_key);
>+}

