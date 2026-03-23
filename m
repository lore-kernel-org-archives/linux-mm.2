Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F2BFEC01C4
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 10:48:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E93956B0093; Mon, 23 Mar 2026 06:48:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E6BBA6B0095; Mon, 23 Mar 2026 06:48:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D86C96B0096; Mon, 23 Mar 2026 06:48:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C6F0B6B0093
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 06:48:58 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 694921EC6B
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 10:48:58 +0000 (UTC)
X-FDA: 84577005156.29.0634CAA
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	by imf27.hostedemail.com (Postfix) with ESMTP id 675394000B
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 10:48:56 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MF2ZZBzr;
	spf=pass (imf27.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774262936;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IIWA57EXEjW5hjoCtv+I9HTIMV/HrYvLk+JVmnYDAwg=;
	b=lMlPTkCqLejaaFuP+0zEolWA1sPBjmOJlBT47hUAEMgJYJ++8JxAFnzgrH7XHQiaPOvhWC
	MBZauZ+4jUbo8hMWMtNzhU5D4KDdjriv5BSH9Q5MdooUJG7JX1kJtS64xNy8FmP06Z00Ln
	AQ02X5RO0wiRdmWNr9O9Dx8iD0aipPs=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MF2ZZBzr;
	spf=pass (imf27.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774262936; a=rsa-sha256;
	cv=none;
	b=JsIjvc4xyKOKjZR82PLyTaTxEX4uUjRrpDyxETHLg39tFhCVnZomIUChOOV4BFdDGFmGY6
	2N+uaVZkMHAvKDSV0Rpu8yDUJpZ6g5d/2z3fRaOq29ArEG7BSYOn/7jMhX9V5r/STTN7cl
	dr1CG5QcJBogSxFsX5BN68EZWOGRKN0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1774262932;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IIWA57EXEjW5hjoCtv+I9HTIMV/HrYvLk+JVmnYDAwg=;
	b=MF2ZZBzrtuNrSpZLTH2a3gF6RV1eNpmkt3BAmaWgG6S8RxOxlaeNFX4d222z2xmMeS3l0s
	PIWBBUZQzzpEaGMYLzW4Fl7YjT6YlY42cEP+aWy63xavFj9szHY6GcdXWHYrO71AUkL9uE
	pmzv4xes6AXSJgB1d4qf9aX8eXVokxw=
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
Date: Mon, 23 Mar 2026 18:48:28 +0800
Message-Id: <20260323104828.55481-1-lance.yang@linux.dev>
In-Reply-To: <20260316023630.92368-1-lance.yang@linux.dev>
References: <20260316023630.92368-1-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 675394000B
X-Stat-Signature: jzxjnknaqs1h4dnpzhw96weop8h5nicn
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1774262936-614928
X-HE-Meta: U2FsdGVkX18RhU7MLmXZr8MQhheQy/xwBMVstl18SsYiU2VbrUa5vDYvpBUnUh7EfSl2OsPeQ4stkQcvHCkcfXQvaF1tEV7tIrputN0U0+npJXzBTAgoO4cx7A1taskO3XUhzv5C6sJLRnRA1y8kvMpdNbgI6DVUJUBSu4o48m5QxJFBT/19VAgQu/Pa8mFyeQ4mrKNUWlBcam8vnuKhoRMj50mAjM4iN0FG/XAYV02LhFWmzzZNWAxkLReRvsUBpdzHSZtYgmyoWSAzheLojSy7nIFb/c7sASo6/xwFtAaITEk7f3It66IPPYbkjn47hbO1g52mS/cvMeSPxxr/E2tMEhJjC1U5KlgL3h2wzViXVPMSZ35XGjOUhqLsmgnBWZX0jXFRBQrBQ3MZxadtjkJB+uXyAJADK8bEANb8rZy/Z4NbguMYpD6mTkRg6HZrRwcSN4Ze5mKDnGbwKWhm4JyAfGouUPR77Zeog4LtBKmwmH8b/XuogwDGveTDHPpSjiYvyJcJxEIC5q7PZBqQPwt1AZ2zCepBo7xJbps/NODZlqaUjaCf3nR49s/n6XqCwCXhf9E9d2XXBFTBcXg2vEHexVPtqz5/8mpwh7TqCyMWvvw5K9vYvT72l7IpgOKBlcePPCv0lwkm010GspvZ0Rh6RMu1OGO2Eui9VLTJdZJYF/NG06RnhKexAs2vMn5xnbXs+G58IRCiAjd2Qfk+VdZWwvESCkyMsB7F91NkFzdf1B91smMcCWgWj/dhzKYVwpU/EysE2ESNn15rNsaE4FKL6mKibQq0G7u7I2Xss0grgaErczWbKtEkBmoLSGrttR87ulkIU0yJAN+9kRmo8izFpcrXp7SDMyFRXfPxKrGJjwlwfr/uaQC/UaaitT46DemuLuWIS1KMCzXgX5tTmY3F6/+q8NEUElzmplLmrTLzdHgydiQj5xzoCct1cJC1bxYEYfvwnaL1kKMUrxu
 hZUsO003
 +fhfN3+MfWrmTiMdWTo9BjkijIteEgiUrZ/0sUI5KPE2nrH3eDVvHKwB34Q31CTvI+9Slabe8sOCaoFD/qwZ5R/9N4h9eJaPbFTMQjpoMmxtEP8JomkhekARVpZw3FDLBmnWSyi+KKB6cbIFZ6lmSn2l0nKuOAs2ltqHU8+GX39F3yHcnr6OoGH5OLhDYRT1zcXBaefJqp7jk/Z3gbyule5GLfsF2tduSlSIBr7cxZvqX1suPNvOmcAeMnF3IKH2i/QPttXxwVYy7sKKo0Xfm0+DrQ4tDdvAV/7+K2lRvL9qDc3vK+5iwe3cdRYKLsECHLcEHjNINOM96RV6rTwqWsY1AkxLmEmWbsT0+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Just following up on this series. Any feedback would be appreciated!

Thanks,
Lance

On Mon, Mar 16, 2026 at 10:36:30AM +0800, Lance Yang wrote:
>
>Gently ping :)
>
>On Mon, Mar 09, 2026 at 10:07:11AM +0800, Lance Yang wrote:
>>From: Lance Yang <lance.yang@linux.dev>
>>
>>Enable the optimization introduced in the previous patch for x86.
>>
>>native_pv_tlb_init() checks whether native_flush_tlb_multi() is in use.
>>On CONFIG_PARAVIRT systems, it checks pv_ops; on non-PARAVIRT, native
>>flush is always in use.
>>
>>It decides once at boot whether to enable the optimization: if using
>>native TLB flush and INVLPGB is not supported, we know IPIs were sent
>>and can skip the redundant sync. The decision is fixed via a static
>>key as Peter suggested[1].
>>
>>PV backends (KVM, Xen, Hyper-V) typically have their own implementations
>>and don't call native_flush_tlb_multi() directly, so they cannot be trusted
>>to provide the IPI guarantees we need.
>>
>>Two-step plan as David suggested[2]:
>>
>>Step 1 (this patch): Skip redundant sync when we're 100% certain the TLB
>>flush sent IPIs. INVLPGB is excluded because when supported, we cannot
>>guarantee IPIs were sent, keeping it clean and simple.
>>
>>Step 2 (future work): Send targeted IPIs only to CPUs actually doing
>>software/lockless page table walks, benefiting all architectures.
>>
>>Regarding Step 2, it obviously only applies to setups where Step 1 does
>>not apply: like x86 with INVLPGB or arm64.
>>
>>[1] https://lore.kernel.org/linux-mm/20260302145652.GH1395266@noisy.programming.kicks-ass.net/
>>[2] https://lore.kernel.org/linux-mm/bbfdf226-4660-4949-b17b-0d209ee4ef8c@kernel.org/
>>
>>Suggested-by: Peter Zijlstra <peterz@infradead.org>
>>Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
>>Signed-off-by: Lance Yang <lance.yang@linux.dev>
>>---
>> arch/x86/include/asm/tlb.h      | 17 ++++++++++++++++-
>> arch/x86/include/asm/tlbflush.h |  2 ++
>> arch/x86/kernel/smpboot.c       |  1 +
>> arch/x86/mm/tlb.c               | 15 +++++++++++++++
>> 4 files changed, 34 insertions(+), 1 deletion(-)
>>
>>diff --git a/arch/x86/include/asm/tlb.h b/arch/x86/include/asm/tlb.h
>>index 866ea78ba156..99de622d3856 100644
>>--- a/arch/x86/include/asm/tlb.h
>>+++ b/arch/x86/include/asm/tlb.h
>>@@ -5,11 +5,21 @@
>> #define tlb_flush tlb_flush
>> static inline void tlb_flush(struct mmu_gather *tlb);
>> 
>>+#define tlb_table_flush_implies_ipi_broadcast tlb_table_flush_implies_ipi_broadcast
>>+static inline bool tlb_table_flush_implies_ipi_broadcast(void);
>>+
>> #include <asm-generic/tlb.h>
>> #include <linux/kernel.h>
>> #include <vdso/bits.h>
>> #include <vdso/page.h>
>> 
>>+DECLARE_STATIC_KEY_FALSE(tlb_ipi_broadcast_key);
>>+
>>+static inline bool tlb_table_flush_implies_ipi_broadcast(void)
>>+{
>>+	return static_branch_likely(&tlb_ipi_broadcast_key);
>>+}
>>+
>> static inline void tlb_flush(struct mmu_gather *tlb)
>> {
>> 	unsigned long start = 0UL, end = TLB_FLUSH_ALL;
>>@@ -20,7 +30,12 @@ static inline void tlb_flush(struct mmu_gather *tlb)
>> 		end = tlb->end;
>> 	}
>> 
>>-	flush_tlb_mm_range(tlb->mm, start, end, stride_shift, tlb->freed_tables);
>>+	/*
>>+	 * Pass both freed_tables and unshared_tables so that lazy-TLB CPUs
>>+	 * also receive IPIs during unsharing page tables.
>>+	 */
>>+	flush_tlb_mm_range(tlb->mm, start, end, stride_shift,
>>+			   tlb->freed_tables || tlb->unshared_tables);
>> }
>> 
>> static inline void invlpg(unsigned long addr)
>>diff --git a/arch/x86/include/asm/tlbflush.h b/arch/x86/include/asm/tlbflush.h
>>index 5a3cdc439e38..8ba853154b46 100644
>>--- a/arch/x86/include/asm/tlbflush.h
>>+++ b/arch/x86/include/asm/tlbflush.h
>>@@ -18,6 +18,8 @@
>> 
>> DECLARE_PER_CPU(u64, tlbstate_untag_mask);
>> 
>>+void __init native_pv_tlb_init(void);
>>+
>> void __flush_tlb_all(void);
>> 
>> #define TLB_FLUSH_ALL	-1UL
>>diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
>>index 5cd6950ab672..3cdb04162843 100644
>>--- a/arch/x86/kernel/smpboot.c
>>+++ b/arch/x86/kernel/smpboot.c
>>@@ -1167,6 +1167,7 @@ void __init native_smp_prepare_boot_cpu(void)
>> 		switch_gdt_and_percpu_base(me);
>> 
>> 	native_pv_lock_init();
>>+	native_pv_tlb_init();
>> }
>> 
>> void __init native_smp_cpus_done(unsigned int max_cpus)
>>diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
>>index 621e09d049cb..8f5585ebaf09 100644
>>--- a/arch/x86/mm/tlb.c
>>+++ b/arch/x86/mm/tlb.c
>>@@ -26,6 +26,8 @@
>> 
>> #include "mm_internal.h"
>> 
>>+DEFINE_STATIC_KEY_FALSE(tlb_ipi_broadcast_key);
>>+
>> #ifdef CONFIG_PARAVIRT
>> # define STATIC_NOPV
>> #else
>>@@ -1834,3 +1836,16 @@ static int __init create_tlb_single_page_flush_ceiling(void)
>> 	return 0;
>> }
>> late_initcall(create_tlb_single_page_flush_ceiling);
>>+
>>+void __init native_pv_tlb_init(void)
>>+{
>>+#ifdef CONFIG_PARAVIRT
>>+	if (pv_ops.mmu.flush_tlb_multi != native_flush_tlb_multi)
>>+		return;
>>+#endif
>>+
>>+	if (cpu_feature_enabled(X86_FEATURE_INVLPGB))
>>+		return;
>>+
>>+	static_branch_enable(&tlb_ipi_broadcast_key);
>>+}
>
>

