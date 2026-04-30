Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0772ACCFA13
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 08:30:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 14D336B0088; Thu, 30 Apr 2026 04:30:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0FEA16B008A; Thu, 30 Apr 2026 04:30:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 013EB6B008C; Thu, 30 Apr 2026 04:30:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E4C6A6B0088
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 04:30:43 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 87AF9404A7
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 08:30:43 +0000 (UTC)
X-FDA: 84714551166.28.C497F93
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	by imf09.hostedemail.com (Postfix) with ESMTP id A7633140005
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 08:30:41 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jnX1PIZW;
	spf=pass (imf09.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777537842;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PPbgHJVU6qWAtZ37vvl/VRP2CQW0+Ny7Cb0Wr44aRGA=;
	b=fj8iO+Bx5qEyhkfmO+Ehw5mcQAz63QUnxzOH9RIBeCTjA46KdJqG5A071lBg3bG2qCu/Eo
	G1wyJ9X817aHGxtFyDD7Cl8Bq/e2/Kn6jM/KFRLkCRsaad20easy7Dn2gUlPtKcERTWBYP
	KuboeizZqsDxbSs3BaHd4ScBHiJ2m5Q=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777537842; a=rsa-sha256;
	cv=none;
	b=wy3k/cb0p/y95cSYlwlxYfp99SgY9js/57KCs0N9gs0Tn9hYjEtaCmwFDzgroYu3LikKFY
	7ArwK8gFmU+MuRWcZVrNqx6Di+pN0GS5cMBtJcOEsehFsX38JvhudvGXT4d7xazBKV9B0m
	zniJgvwvCoQpz28RKQcTGBloaqb1FBQ=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jnX1PIZW;
	spf=pass (imf09.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777537839;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PPbgHJVU6qWAtZ37vvl/VRP2CQW0+Ny7Cb0Wr44aRGA=;
	b=jnX1PIZW07vIOOwG50oaj/AMBEYrMrioFW6gAyt0bk1XQZcRVM1lO2zCx5vENojXhf6cpk
	VLyjBqGet2ypzh95wIqN7DQuzkTuwJI2KvTn5+vZ3zFE2jMakOLVEXuYiErBldizus8MAc
	W50s9ENBVZD+L1mwNJcrGfHO6KqkNls=
From: Lance Yang <lance.yang@linux.dev>
To: david@kernel.org,
	maobibo@loongson.cn
Cc: lance.yang@linux.dev,
	hughd@google.com,
	akpm@linux-foundation.org,
	baolin.wang@linux.alibaba.com,
	baohua@kernel.org,
	dev.jain@arm.com,
	liam.howlett@oracle.com,
	ljs@kernel.org,
	mhocko@suse.com,
	rppt@kernel.org,
	npache@redhat.com,
	zhengqi.arch@bytedance.com,
	ryan.roberts@arm.com,
	surenb@google.com,
	ziy@nvidia.com,
	linux-mm@kvack.org
Subject: Re: [PATCH hotfix] mm: fix pmd_special() fallback to observe huge_zero
Date: Thu, 30 Apr 2026 16:30:26 +0800
Message-Id: <20260430083026.83559-1-lance.yang@linux.dev>
In-Reply-To: <4d950326-6944-409b-b108-a4e67256857f@kernel.org>
References: <4d950326-6944-409b-b108-a4e67256857f@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A7633140005
X-Rspam-User: 
X-Stat-Signature: etbo44s3efbm9mwyz1d556ed3akw97n5
X-HE-Tag: 1777537841-47963
X-HE-Meta: U2FsdGVkX18lLKMD5SDCSTTck63K84ocmxFZTwyBiPxfr4LFlRJGv47bw8hJ4puYmq1pitOv35krnpXlIiUbmPsnFDhnmV1NgzG/xN4Rp8uGmVgYOxoWPD8DPBFVKLhQ/TPnzxSSy0qXWaQXvZuib3SX0XoDnHdsMi5WJ6+hynWrOO7fL+Kbs5mJreL2vYLreEaT1PXSK83gl7MMI+0XoWx6WgUv8F0rlTD39cV+M+tWa3mOCA2exBnZDFyFjpTxXlon3Gz2C/pqj+v2iVMRUD22qidXd/Gwma9wp4lUrdL2GU2qL5ZtVk2HRnWKOJg9utFaU4Us8RaxRKtLRYZbJL50meNjRS+LanZW1Iuc+w1251vcsTBO1UXgpxdqaFgVJxd17JGlWmmq9SnFSifbs5G+hqMM8lamm+OjvwHla5Cw09+adtPQiyG4M3xAEFkl8FK5jJQhhEt7B8UMJ77TkpjSUPaaPBl+A6fhh0w0fCo5gdhzodLDQ9gG9syoWyon4rOL7boDJkXzxhWOFbj+gep6h10XXnobpgRh6nPQRwlt1fpCooqTbIxU3tmHJkcCO4PxQB5gGMQx2GBKmYtAOfVGtw7y2E2eAMbmGYaJdkS6ytMX5LW6IdTDVM9Exl9bbPpU9qTYa1lL5etyHAhU8iEptEmCxDg1pp5lH+4VHh/K9w4Ncle1X5nhVbm2HUoKwLdEtxudW+uU2DUsxHym7Geyfy22gLS6oUiPZoGohDeUlMA0hMzLDcQR2gX1kn6iQm7tpnSjExDCkyUt7cjSpAEYvulU2c9AI4AOVzx/nJmsPM2SJDTMvteRP+zzSYrv5oSa9RgqO5bHDQq824ZuQ/Fwqd/qNvV+2wU+lxZOr4rYC8x5plYpvrlxLs2BK4hSEZ8KRdDLsY8QOHflSQNZSEkG9mQbKBqjDrDmWfc1DzAcGTx5bydQkkJYOAjBXBFBv269r18Nlb+v0NYu1f8
 /Sq7nuqR
 zsKB7ajJFK9laFPJlZdHyLU7h7nS8Bmmca3/2Xga/+uYBC9CX6BR1sm7cfrvqfBRYR+yILH8z8G9UcA/2hZa6dzJOjCWzn13YZi0btXCtm2TlkMlDlJeNkO34tY53AijcdWAfSOcVbCbWP+aZxeO/dqNC1WWqOJ1qNc7SvceceJET/dr6isyEU3eIanv4xhWAenUilokik7ooNPuLIbHRxApTupn0ko121Ioa5SZ8TMltc2AbFdxzgk31wCcnv6n/OoXezbRsgVXfPR5xzzPcwbMY+wXzLq3oxYc2XxR/ILdgm2aTuEVorI7ZUO770W8vB0UoeW7R6x8Yzf4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Cc Bibo Mao

On Thu, Apr 30, 2026 at 07:53:05AM +0200, David Hildenbrand (Arm) wrote:
>On 4/29/26 09:33, Lance Yang wrote:
>> 
>> 
>> On 2026/4/29 15:14, David Hildenbrand (Arm) wrote:
>>> On 4/29/26 08:57, Lance Yang wrote:
>>>>
>>>>
>>>> Right.
>>>>
>>>>
>>>> The history seems to be:
>>>>
>>>>     2025-09-13 d82d09e48219 ("mm/huge_memory: mark PMD mappings of the huge
>>>> zero folio special")
>>>>     2025-09-13 af38538801c6 ("mm/memory: factor out common code from
>>>> vm_normal_page_*()")
>>>>
>>>> After d82d09e48219, vm_normal_page_pmd() still had the explicit huge
>>>> zero check before returning the page:
>>>>
>>>> --8<---
>>>> struct page *vm_normal_page_pmd(struct vm_area_struct *vma, unsigned long addr,
>>>>                 pmd_t pmd)
>>>> {
>>>>     unsigned long pfn = pmd_pfn(pmd);
>>>>
>>>>     if (unlikely(pmd_special(pmd)))
>>>>         return NULL;
>>>>
>>>>     if (unlikely(vma->vm_flags & (VM_PFNMAP|VM_MIXEDMAP))) {
>>>>         if (vma->vm_flags & VM_MIXEDMAP) {
>>>>             if (!pfn_valid(pfn))
>>>>                 return NULL;
>>>>             goto out;
>>>>         } else {
>>>>             unsigned long off;
>>>>             off = (addr - vma->vm_start) >> PAGE_SHIFT;
>>>>             if (pfn == vma->vm_pgoff + off)
>>>>                 return NULL;
>>>>             if (!is_cow_mapping(vma->vm_flags))
>>>>                 return NULL;
>>>>         }
>>>>     }
>>>>
>>>>     if (is_huge_zero_pfn(pfn))
>>>>         return NULL;
>>>>     if (unlikely(pfn > highest_memmap_pfn))
>>>>         return NULL;
>>>>
>>>>     /*
>>>>      * NOTE! We still have PageReserved() pages in the page tables.
>>>>      * eg. VDSO mappings can cause them to exist.
>>>>      */
>>>> out:
>>>>     return pfn_to_page(pfn);
>>>> }
>>>> ---
>>>>
>>>> So even if pmd_mkspecial() was a no-op and pmd_special() stayed false,
>>>> we would still return NULL there.
>>>>
>>>> Then af38538801c6 moved the PMD path into __vm_normal_page():
>>>>
>>>> ---8<---
>>>> struct page *vm_normal_page_pmd(struct vm_area_struct *vma, unsigned long addr,
>>>>                 pmd_t pmd)
>>>> {
>>>>     return __vm_normal_page(vma, addr, pmd_pfn(pmd), pmd_special(pmd),
>>>>                 pmd_val(pmd), PGTABLE_LEVEL_PMD);
>>>> }
>>>> ---
>>>>
>>>> For CONFIG_ARCH_HAS_PTE_SPECIAL=y, __vm_normal_page() only returns NULL
>>>> for the huge zero PFN if special == true. On x86 32-bit, pmd_special()
>>>> stays false, so this can now fall through to VM_WARN_ON_ONCE():
>>>>
>>>> ---8<---
>>>>     if (IS_ENABLED(CONFIG_ARCH_HAS_PTE_SPECIAL)) {
>>>>         if (unlikely(special)) {
>>>>             if (is_zero_pfn(pfn) || is_huge_zero_pfn(pfn))
>>>>                 return NULL;
>>>> ...
>>>>         }
>>>> ...
>>>>     } else {
>>>> ...
>>>>         if (is_zero_pfn(pfn) || is_huge_zero_pfn(pfn))
>>>>             return NULL;
>>>>     }
>>>>
>>>> ...
>>>>     VM_WARN_ON_ONCE(is_zero_pfn(pfn) || is_huge_zero_pfn(pfn));
>>>> ...
>>>> ---
>>>>
>>>> So my guess is that the warning above became possible after
>>>> af38538801c6, IIUC.
>>>
>>> Yes, I think you are right about af38538801c6.
>>>
>>> What about the following then as a temporary solution:
>> 
>> Nice, that works for me :)
>
>Okay, I'd say we do the following:
>
>>From fd9ead548f102f7c257980ccc7b96cce7e42a570 Mon Sep 17 00:00:00 2001
>From: Hugh Dickins <hughd@google.com>
>Date: Thu, 30 Apr 2026 07:35:31 +0200
>Subject: [PATCH] mm: fix pmd_special() fallback to observe huge_zero
>
>On x86 32-bit with THP enabled, zap_huge_pmd() is seen to generate a
>"WARNING: mm/memory.c:735 at __vm_normal_page+0x6a/0x7d", from the
>VM_WARN_ON_ONCE(is_zero_pfn(pfn) || is_huge_zero_pfn(pfn)); followed
>by "BUG: Bad rss-counter state"s, then later "BUG: Bad page state"s
>when reclaim gets to call shrink_huge_zero_folio_scan().
>
>It's as if the _PAGE_SPECIAL bit never got set in the huge_zero pmd:
>and indeed, whereas pte_special() and pte_mkspecial() are subject to a
>dedicated CONFIG_ARCH_HAS_PTE_SPECIAL, pmd_special() and pmd_mkspecial()
>are subject to CONFIG_ARCH_SUPPORTS_PMD_PFNMAP, which is never enabled
>on any 32-bit architecture.
>
>While the problem was exposed through d80a9cb1a64a ("mm/huge_memory: add
>and use normal_or_softleaf_folio_pmd()"), it was an oversight in
>af38538801c6 ("mm/memory: factor out common code from vm_normal_page_*()")
>and would result in other problems:
>* huge zero folio accounted in smaps, pagemap (PAGE_IS_FILE) and
>  numamaps as file-backed THP
>* folio_walk_start() returning the folio even without FW_ZEROPAGE set.
>  Callers seem to tolerate that, though.
>
>... and triggering the VM_WARN_ON_ONE(), although never reported so far.
>
>To fix it, teach vm_normal_page_pmd()/vm_normal_page_pud() whether
>pmd_special/pud_special is actually implemented.
>
>Fixes: af38538801c6 ("mm/memory: factor out common code from vm_normal_page_*()")
>Signed-off-by: Hugh Dickins <hughd@google.com>>
>Co-developed-by: David Hildenbrand (Arm) <david@kernel.org>
>Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>---

Bibo Mao also hit the same bad rss-counter state issue while running
QEMU "make check" on LoongArch, and confirmed[1] that this patch fixes
it.

[1] https://lore.kernel.org/linux-mm/4807181d-c111-5568-b040-140706e56b4f@loongson.cn/

Cheers, Lance

> mm/memory.c | 17 ++++++++++++++++-
> 1 file changed, 16 insertions(+), 1 deletion(-)
>
>diff --git a/mm/memory.c b/mm/memory.c
>index 7322a40e73b9..a60bc07b48b2 100644
>--- a/mm/memory.c
>+++ b/mm/memory.c
>@@ -612,6 +612,21 @@ static void print_bad_page_map(struct vm_area_struct *vma,
> 	dump_stack();
> 	add_taint(TAINT_BAD_PAGE, LOCKDEP_NOW_UNRELIABLE);
> }
>+
>+static inline bool pgtable_level_has_pxx_special(enum pgtable_level level)
>+{
>+	switch (level) {
>+	case PGTABLE_LEVEL_PTE:
>+		return IS_ENABLED(CONFIG_ARCH_HAS_PTE_SPECIAL);
>+	case PGTABLE_LEVEL_PMD:
>+		return IS_ENABLED(CONFIG_ARCH_SUPPORTS_PMD_PFNMAP);
>+	case PGTABLE_LEVEL_PUD:
>+		return IS_ENABLED(CONFIG_ARCH_SUPPORTS_PUD_PFNMAP);
>+	default:
>+		return false;
>+	}
>+}
>+
> #define print_bad_pte(vma, addr, pte, page) \
> 	print_bad_page_map(vma, addr, pte_val(pte), page, PGTABLE_LEVEL_PTE)
> 
>@@ -684,7 +699,7 @@ static inline struct page *__vm_normal_page(struct vm_area_struct *vma,
> 		unsigned long addr, unsigned long pfn, bool special,
> 		unsigned long long entry, enum pgtable_level level)
> {
>-	if (IS_ENABLED(CONFIG_ARCH_HAS_PTE_SPECIAL)) {
>+	if (pgtable_level_has_pxx_special(level)) {
> 		if (unlikely(special)) {
> #ifdef CONFIG_FIND_NORMAL_PAGE
> 			if (vma->vm_ops && vma->vm_ops->find_normal_page)
>-- 
>2.43.0
>
>
>
>-- 
>Cheers,
>
>David
>
>

