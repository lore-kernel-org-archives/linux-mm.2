Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F014E606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 02:05:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=Tvbarng+
Received: by kanga.kvack.org (Postfix)
	id EC1C96B05B1; Mon, 16 Nov 2026 21:05:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E99346B05B2; Mon, 16 Nov 2026 21:05:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB0736B05BE; Mon, 16 Nov 2026 21:05:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AB10D6B05B1
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 21:05:14 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 20985A0207
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 02:05:14 +0000 (UTC)
X-FDA: 85442968548.08.CBF3C1C
Received: from canpmsgout08.his.huawei.com (canpmsgout08.his.huawei.com [113.46.200.223])
	by imf28.hostedemail.com (Postfix) with ESMTP id EB183C0008
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 02:05:01 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	none
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=P2kl9bmDpnx5W8SyppCCYb8VU8HmiAYUv1LDem15tug=;
	b=Tvbarng+qEm8i0NGBZHOj3t/HfrQNPH0bwWvWLAT4NvWCcAoAThVZOvbbp+b/dJ75v4k6SY2O
	gwcEFzBfUHBX4UhmL1GzIDr058+6HZM0AUeh7/SG0vbb4kLC38ol5cIvFLOOUAHlJc9haTgP+Je
	7GMdA+2tlwUNWoUg+7D5iHQ=
Received: from mail.maildlp.com (unknown [172.19.163.15])
	by canpmsgout08.his.huawei.com (SkyGuard) with ESMTPS id 4jT7Ml04GLzmVcC;
	Tue, 17 Nov 2026 10:04:35 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id 9BB5B40578;
	Tue, 17 Nov 2026 10:04:53 +0800 (CST)
Received: from [10.174.178.56] (10.174.178.56) by
 kwepemr500001.china.huawei.com (7.202.194.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Tue, 17 Nov 2026 10:04:52 +0800
Message-ID: <14024665-9d98-4645-a280-7c0dce4cac82@huawei.com>
Date: Tue, 17 Nov 2026 10:04:51 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RESEND 3/3] arm64: Add PUD THP support for DAX and pfnmap
To: <sashiko-reviews@lists.linux.dev>, <akpm@linux-foundation.org>,
	<david@kernel.org>, <ljs@kernel.org>, <catalin.marinas@arm.com>,
	<will@kernel.org>, <mark.rutland@arm.com>, <ryan.roberts@arm.com>,
	<peterx@redhat.com>, <dave.jiang@intel.com>, <linux-mm@kvack.org>
CC: <wangkefeng.wang@huawei.com>, <sunnanyong@huawei.com>
References: <20261028121404.853944-1-tujinjiang@huawei.com>
 <20261028121404.853944-4-tujinjiang@huawei.com>
 <sashiko-outbox-189265@kernel.org>
From: Jinjiang Tu <tujinjiang@huawei.com>
In-Reply-To: <sashiko-outbox-189265@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Rspamd-Queue-Id: EB183C0008
X-Rspam-User: nil
X-Stat-Signature: g7j6cpoupbgq3dmf7n8443oabw6hkf6a
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam12
X-HE-Tag: 1794881101-398316
X-HE-Meta: U2FsdGVkX1+PHGAj+3bC93+z52Sm3KzGhnAqyi+C3iMWlzvphXBX1StKEeKrH6RMz0AYhXG9bTs0LKhkTuLzLxJrlwJwYHoYCcW413JGBuDFfB6MiaRwIDZ01/UBni0SemaIQhsezLabjbFOsXPP750Q+MFZT1TxEVIBIsamCLGVwEs4W6UYuXjBdJdqF43TNhXKjPgbw7ClPwp1g0O4aqsT8XZuAiGyhgsYXKdjzU2G27zaqtBmYlfnXhRzzTRhmpEEIyIdcKw4KFxlK97Am137yws0L0Qr7BU46LEv6SmF/qGtzAnzbNI5rDqb3zpWWkOeYgiHFt4fcKdTr6gDZhb3gLWmpQBLWrkZXrmACbCEo6fF1rqoAPr9ABu9YErtAkX/ZBG1icbVIIAwgzVs96RXr3thGk1r6k3QFuOahYcaQWS7iX8FhGqIf50xL0WAlbaq4R34eH+L5RVbZhDDmvewTVes6at0VS9AGor8MGXKHNyh0UWYrmZCPRT8pzf0Jrpq+3SroFIA9coRdwFUOA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


在 2026/10/29 20:14, sashiko-bot@kernel.org 写道:
> Thank you for your contribution! Sashiko AI review found 4 potential issue(s) to consider:
> - [High] arm64: mm: local-only TLB flush in pudp_set_access_flags() causes fault livelock
> - [High] arm64: mm: missing pudp_set_wrprotect() loses HAFDBS dirty bits and triggers warning
> - [High] arm64: mm: missing pudp_huge_get_and_clear() loses concurrent HAFDBS A/D updates
> - [Low] arm64: mm: redefinition of pud_trans_huge() when CONFIG_TRANSPARENT_HUGEPAGE=n
> --

These issues are confirmed and have been fixed in v2.

https://lore.kernel.org/all/20261117020237.4037980-1-tujinjiang@huawei.com/

> commit 7dc812ccee714c3818da8b998f785b9073deeacd
> Author: Jinjiang Tu <tujinjiang@huawei.com>
>
> arm64: Add PUD THP support for DAX and pfnmap
>
> This patch adds PUD transparent hugepage page table helpers on arm64 and
> enables HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD for 4KB page size configurations to
> support PUD THP for DAX and pfnmap mappings.
>
>> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
>> index 7de2487e4d353..feca481b20795 100644
>> --- a/arch/arm64/include/asm/pgtable.h
>> +++ b/arch/arm64/include/asm/pgtable.h
> [ ... ]
>
>> @@ -826,6 +838,13 @@ static inline bool pud_leaf(pud_t pud)
>>   #define pud_user(pud)		pte_user(pud_pte(pud))
>>   #define pud_user_exec(pud)	pte_user_exec(pud_pte(pud))
>>   
>> +#ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
>> +static inline int pud_trans_huge(pud_t pud)
>> +{
>> +	return pud_present(pud) && !pud_table(__pud(pud_val(pud) | PTE_VALID));
>> +}
>> +#endif
> [Severity: Low]
> Will this cause a redefinition error for pud_trans_huge() when building with
> CONFIG_PAGE_SIZE_4KB=y and CONFIG_TRANSPARENT_HUGEPAGE=n (for example,
> allnoconfig or tinyconfig)?
>
> In arch/arm64/Kconfig, config ARM64 selects
> HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD whenever PAGE_SIZE_4KB is enabled, even
> when CONFIG_TRANSPARENT_HUGEPAGE is disabled:
>
> 	select HAVE_ARCH_TRANSPARENT_HUGEPAGE
> 	select HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD if PAGE_SIZE_4KB
>
> However, include/linux/pgtable.h includes asm/pgtable.h and then provides a
> fallback definition of pud_trans_huge() whenever CONFIG_TRANSPARENT_HUGEPAGE
> is not defined:
>
> #if !defined(CONFIG_TRANSPARENT_HUGEPAGE) || \
> 	!defined(CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD)
> static inline int pud_trans_huge(pud_t pud)
> {
> 	return 0;
> }
> #endif
>
> Should pud_trans_huge() in arch/arm64/include/asm/pgtable.h also be guarded by
> CONFIG_TRANSPARENT_HUGEPAGE (matching pmd_trans_huge() in the same file)?
>
> [ ... ]
>
>> @@ -1207,6 +1231,16 @@ static inline int pmdp_set_access_flags(struct vm_area_struct *vma,
>>   }
>>   #endif
>>   
>> +#ifdef CONFIG_ARCH_SUPPORTS_PUD_PFNMAP
>> +static inline int pudp_set_access_flags(struct vm_area_struct *vma,
>> +					unsigned long address, pud_t *pudp,
>> +					pud_t entry, int dirty)
>> +{
>> +	return __ptep_set_access_flags_anysz(vma, address, (pte_t *)pudp,
>> +					     pud_pte(entry), dirty, PUD_SIZE);
>> +}
>> +#endif
> [Severity: High]
> Can delegating pudp_set_access_flags() to __ptep_set_access_flags_anysz() lead
> to an infinite spurious write page-fault livelock on remote CPUs?
>
> In arch/arm64/mm/fault.c, __ptep_set_access_flags_anysz() only invalidates the
> local CPU's TLB via TLBF_NOBROADCAST when upgrading a read-only entry to
> writable/dirty, relying on remote CPUs to invalidate their stale read-only TLB
> entries on a subsequent permission fault:
>
> 	if (pte_same(pte, entry))
> 		return 0;
> 	...
> 	/*
> 	 * Invalidate the local stale read-only entry.  Remote stale entries
> 	 * may still cause page faults and be invalidated via
> 	 * flush_tlb_fix_spurious_fault().
> 	 */
> 	if (dirty) {
> 		...
> 		__flush_tlb_range(vma, address, address + pgsize, pgsize, level,
> 				  TLBF_NOWALKCACHE | TLBF_NOBROADCAST);
> 	}
>
> Suppose two CPUs fault in a shared PUD mapping as hardware read-only
> (PTE_RDONLY=1, such as on an initial read fault for fsdax, a PFNMAP/devdax
> mapping on a CPU without hardware DBM, or after copy_huge_pud() write-protects
> the PUD), and CPU A then writes to the mapping. CPU A updates *pudp via
> wp_huge_pud() -> insert_pud() -> pudp_set_access_flags() or
> huge_pud_set_accessed() -> touch_pud() -> pudp_set_access_flags(), flushing
> only CPU A's local TLB.
>
> When CPU B subsequently writes to the same PUD range, it takes a permission
> fault from its stale read-only local TLB entry and enters:
>
> __handle_mm_fault()
>    huge_pud_set_accessed()
>      touch_pud()
>        pudp_set_access_flags()
>          __ptep_set_access_flags_anysz()
>
> Because *pudp in memory already matches entry (with PTE_AF, PTE_DIRTY, and
> PTE_WRITE set and PTE_RDONLY cleared), pte_same(pte, entry) is true and
> __ptep_set_access_flags_anysz() returns 0 without flushing CPU B's TLB.
>
> Unlike the PTE and PMD paths, which call flush_tlb_fix_spurious_fault() and
> flush_tlb_fix_spurious_fault_pmd() when ptep_set_access_flags() or
> pmdp_set_access_flags() returns 0, neither touch_pud(),
> huge_pud_set_accessed(), __handle_mm_fault(), nor insert_pud() performs a
> local TLB flush on a spurious PUD fault. Wouldn't CPU B return to userspace
> with the stale read-only PUD TLB entry still in place and fault in an infinite
> loop?
>
> [ ... ]
>
>> @@ -1281,6 +1315,14 @@ static inline bool pmdp_test_and_clear_young(struct vm_area_struct *vma,
>>   }
>>   #endif /* CONFIG_TRANSPARENT_HUGEPAGE || CONFIG_ARCH_HAS_NONLEAF_PMD_YOUNG */
>>   
>> +#ifdef CONFIG_ARCH_SUPPORTS_PUD_PFNMAP
>> +static inline bool pudp_test_and_clear_young(struct vm_area_struct *vma,
>> +		unsigned long address, pud_t *pudp)
>> +{
>> +	return __ptep_test_and_clear_young(vma, address, (pte_t *)pudp);
>> +}
>> +#endif
>> +
>>   static inline pte_t __ptep_get_and_clear_anysz(struct mm_struct *mm,
>>   					       unsigned long address,
>>   					       pte_t *ptep,
> [Severity: High]
> Should arm64 also define __HAVE_ARCH_PUDP_HUGE_GET_AND_CLEAR and implement
> pudp_huge_get_and_clear() via __ptep_get_and_clear_anysz(..., PUD_SIZE)?
>
> __ptep_get_and_clear_anysz() in arch/arm64/include/asm/pgtable.h already uses
> an atomic xchg_relaxed() and has a PUD_SIZE case for
> page_table_check_pud_clear(). Without an arch definition of
> pudp_huge_get_and_clear(), arm64 falls back to the generic implementation in
> include/linux/pgtable.h:
>
> #ifndef __HAVE_ARCH_PUDP_HUGE_GET_AND_CLEAR
> static inline pud_t pudp_huge_get_and_clear(struct mm_struct *mm,
> 					    unsigned long address,
> 					    pud_t *pudp)
> {
> 	pud_t pud = *pudp;
>
> 	pud_clear(pudp);
> 	page_table_check_pud_clear(mm, address, pud);
>
> 	return pud;
> }
> #endif
>
> When splitting a DAX PUD via split_huge_pud() -> __split_huge_pud_locked() ->
> pudp_huge_clear_flush() -> pudp_huge_get_and_clear(), __split_huge_pud_locked()
> propagates the dirty and young bits from old_pud to the folio:
>
> 	old_pud = pudp_huge_clear_flush(vma, haddr, pud);
>
> 	if (!vma_is_dax(vma))
> 		return;
>
> 	page = pud_page(old_pud);
> 	folio = page_folio(page);
>
> 	if (!folio_test_dirty(folio) && pud_dirty(old_pud))
> 		folio_mark_dirty(folio);
> 	if (!folio_test_referenced(folio) && pud_young(old_pud))
> 		folio_set_referenced(folio);
>
> On systems with FEAT_HAFDBS, couldn't a concurrent hardware access or dirty
> state update between the non-atomic read of *pudp and pud_clear(pudp) be lost?
>
> [ ... ]
>
>> @@ -1443,6 +1485,15 @@ static inline pmd_t pmdp_establish(struct vm_area_struct *vma,
>>   }
>>   #endif
>>   
>> +#ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
>> +static inline pud_t pudp_establish(struct vm_area_struct *vma,
>> +		unsigned long address, pud_t *pudp, pud_t pud)
>> +{
>> +	page_table_check_pud_set(vma->vm_mm, address, pudp, pud);
>> +	return __pud(xchg_relaxed(&pud_val(*pudp), pud_val(pud)));
>> +}
>> +#endif
> [Severity: High]
> Is __HAVE_ARCH_PUDP_SET_WRPROTECT with pudp_set_wrprotect() also needed here,
> matching pmdp_set_wrprotect() right above pmdp_establish()?
>
> Without an architecture-specific pudp_set_wrprotect() wrapping
> __ptep_set_wrprotect(), arm64 uses the generic fallback in
> include/linux/pgtable.h:
>
> static inline void pudp_set_wrprotect(struct mm_struct *mm,
> 				      unsigned long address, pud_t *pudp)
> {
> 	pud_t old_pud = *pudp;
>
> 	set_pud_at(mm, address, pudp, pud_wrprotect(old_pud));
> }
>
> When fork() copies a COW PUD via copy_page_range() -> copy_p4d_range() ->
> copy_pud_range() -> copy_huge_pud() -> pudp_set_wrprotect():
>
> 1. The non-atomic read of *pudp followed by set_pud_at() races with hardware
>     AF/DBM updates (FEAT_HAFDBS), unlike __ptep_set_wrprotect() which uses a
>     cmpxchg_relaxed() loop to atomically transfer hardware dirty state to
>     PTE_DIRTY while setting PTE_RDONLY and clearing PTE_WRITE.
>
> 2. Updating a live valid PUD in place via set_pud_at() -> __set_ptes_anysz()
>     calls __check_safe_pte_update() in arch/arm64/mm/mmu.c, which triggers
>     VM_WARN_ONCE() when the entry is old or writable-clean on a live mm:
>
> 	VM_WARN_ONCE(!pte_young(pte),
> 		     "%s: racy access flag clearing: %s -> %s",
> 		     __func__, pte_str_old, pte_str);
> 	VM_WARN_ONCE(pte_write(old_pte) && !pte_dirty(pte),
> 		     "%s: racy dirty state clearing: %s -> %s",
> 		     __func__, pte_str_old, pte_str);
>
> 3. set_pud_at() also runs __sync_cache_and_tags() across PUD_SIZE >> PAGE_SHIFT
>     (262,144) pages unnecessarily when only write-protecting an existing entry.
>

