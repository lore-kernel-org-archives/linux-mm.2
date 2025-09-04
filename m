Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A17B4CA1002
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 11:49:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 071078E0002; Thu,  4 Sep 2025 07:49:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 021FB8E0001; Thu,  4 Sep 2025 07:49:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E52C28E0002; Thu,  4 Sep 2025 07:49:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D0FA08E0001
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 07:49:19 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 729A083BE8
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 11:49:19 +0000 (UTC)
X-FDA: 83851397238.12.6392648
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	by imf24.hostedemail.com (Postfix) with ESMTP id 65EBF180016
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 11:49:16 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf24.hostedemail.com: domain of tujinjiang@huawei.com designates 45.249.212.191 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756986557;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ro62wfQRLtj9O4DwUFyXPoUnpgOqYhRj56lj38x9QQA=;
	b=qP+s0THSPfYLLLLH7pIElxMgJfeMNkgNtQbmSWsH6pUJFlr3TJGwdYEUbEMl6NHJThU/Ct
	MHhfTx5QWX1gIGwj68HeKBi4bIyGmb0AcSiIa85nnNfn+OxFS5tu8R+/1+TnvIRcODOOVL
	TDmj1OBZ6J702oBZvGr+BRV3CW0uVlU=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf24.hostedemail.com: domain of tujinjiang@huawei.com designates 45.249.212.191 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756986557; a=rsa-sha256;
	cv=none;
	b=lAgqep2D6NFJa3jU7IhmqmKXauEnqmiT2bDaX94wmeQzqr475RUNQ1xbwo82wWDa7bo5kT
	ijNpiel+HXmd/tRu5SCrptMQInZNlWo6vDVY7DvX5j5qSsSWKHa/TvRgdXeVwHl4nRLDON
	cTw5nmtLPcENnCNddIRmdN1t7FGm7ic=
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4cHd3Q6p6Tz1R9F2;
	Thu,  4 Sep 2025 19:46:10 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id C8B1A1402C4;
	Thu,  4 Sep 2025 19:49:10 +0800 (CST)
Received: from [10.174.178.49] (10.174.178.49) by
 kwepemr500001.china.huawei.com (7.202.194.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 4 Sep 2025 19:49:09 +0800
Content-Type: multipart/alternative;
	boundary="------------68GmtYSdYecpnQbAag2L3nqh"
Message-ID: <a985c9f0-1561-45d7-860f-2717a0a72d9e@huawei.com>
Date: Thu, 4 Sep 2025 19:49:08 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 1/6] arm64: Enable permission change on arm64 kernel
 block mappings
To: Ryan Roberts <ryan.roberts@arm.com>, Catalin Marinas
	<catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Andrew Morton
	<akpm@linux-foundation.org>, David Hildenbrand <david@redhat.com>, Lorenzo
 Stoakes <lorenzo.stoakes@oracle.com>, Yang Shi <yang@os.amperecomputing.com>,
	Ard Biesheuvel <ardb@kernel.org>, Dev Jain <dev.jain@arm.com>,
	<scott@os.amperecomputing.com>, <cl@gentwo.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>
References: <20250829115250.2395585-1-ryan.roberts@arm.com>
 <20250829115250.2395585-2-ryan.roberts@arm.com>
 <7705c29b-4f08-4b56-aab3-024795ee9124@huawei.com>
 <42b3b394-a6ec-4d70-b5a1-941a0628cd25@arm.com>
From: Jinjiang Tu <tujinjiang@huawei.com>
In-Reply-To: <42b3b394-a6ec-4d70-b5a1-941a0628cd25@arm.com>
X-Originating-IP: [10.174.178.49]
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 65EBF180016
X-Stat-Signature: ohs3hq9uyhd7cecm7kk9ueuk78frtcak
X-Rspam-User: 
X-HE-Tag: 1756986556-308864
X-HE-Meta: U2FsdGVkX18K0AB+3wh6gnhuLsaopnL69CEz74afpPIdZRnvweJ1TUJZPDZJhCSGQc++OGkvtA9skeK7CGDkAxZD6xYqWthGe2IQfKsHtdIbw699keuyKRt8RD/jjgj0l24MK5SSv/ezKQWvBzjh41Ac0eooFgvJw6KeD9/Mb6pEroodKJwsSx6lPHZvgsYCMM8Zi31dPjD7TD4lISe/KXBDLwhWXJnB/M6kvTdwnEnpTztU+asrGzPEX0sIVd4u7EQyxmVAY0jHhejw67usziE6FgbVnS7ocoBbY0R33YMd+1goUPZKC7SDJay7A1gpLZDBCX5q/UO7os4kfV34dswpeCW9HIukvpSpPA78vwFd5SAAIYqNI099jbx4Fm93WDlkq8+K+29D19tyHnt6DhVMmfzUiTh3NHeBZftoIyA9b0c110XNxyJOpsmN8oIBdZL9An2EP5xtYBTLOVpQvP8RRIZugNbbAd+D2qS8GFLXPJlg2idnC3tguNcGfh+9BHxPixM8NjNNYLJcVLJewyEn21mynVBrsF5aPTzIg/xk4iUnYkc9ralfO1+qmtEsasmkpt+NGjcEuV5ZjsSxeqKBybMktDI9L/0x/qmSmxcwpR9yQHhPKNVYQuEkCX+9REig7uK7lsYaXj1kStjhnqkPCrJlSaQLSwOnxvKbtuLhHJpKfg5IJcljXoBGS65U2lv6oimKD+Z9FtsXcQDNvwfAAdfpVuwq9yawcCe56zXpOUiS858H39pgsc3ATe4SS1Wt1ZllqO+GYMinqa3kR6W7gilzW1Hdxt34R0FlTVHld2HjWwJTFmwS1KX1KER8H3ECTq+AUtiLZzWN767BHyIlANHt/y2B57TbP0j50ufnUK5BYj8rbiYmY1RaYujGTIp8KWaoH1iiQhzKrRIJvUJ6Xun+98JU8TebfB1FfPW+rNRoTEZ6T4kJgigxdYkl+q0JtBsQnW9uMpmrQqc
 0+9Rv32U
 vivdTVt9eclj7UAuhC7B96ZUsv1kDdBCwVvMTLpC3MC+MaO7XMk71Ewre8sLLXRFt9oYjDGCyt4IuRP8tmKGTHfbhI6XgMOlVJxTZ8oozk5mhzJrH/IIbZadxDtjHeT46Q0w/OdWrOdO1VJRNLhTPedw71/fX54i1GHByHfQF7FjrZehIgZ1qPkGY7aj5VUSuU1crhDADn+1LgSup7Hg4448jRrtHH1eckvL1nVI5wfTquaGGPp2nK3A3KnzduhxC/UGQonkZkvQ8U9ToW4nBkjpKxpxA0viAzCYWkWJFniXK4qKOKLGLIJAPokqOECKlJ8fr6aqxTawx48FNwoCx7IHM1QKbNhvBe/W75q52w3yq6YYgQ3fmOujTNJ48lYF8K9nby5G4onS3myb4QYGJnromdRhWGH3kMLlndN/JJg8IDDXPJKdggH/F/B8GbKeDSErB
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--------------68GmtYSdYecpnQbAag2L3nqh
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit


在 2025/9/4 19:06, Ryan Roberts 写道:
> On 04/09/2025 04:40, Jinjiang Tu wrote:
>> 在 2025/8/29 19:52, Ryan Roberts 写道:
>>> From: Dev Jain<dev.jain@arm.com>
>>>
>>> This patch paves the path to enable huge mappings in vmalloc space and
>>> linear map space by default on arm64. For this we must ensure that we
>>> can handle any permission games on the kernel (init_mm) pagetable.
>>> Previously, __change_memory_common() used apply_to_page_range() which
>>> does not support changing permissions for block mappings. We move away
>>> from this by using the pagewalk API, similar to what riscv does right
>>> now. It is the responsibility of the caller to ensure that the range
>>> over which permissions are being changed falls on leaf mapping
>>> boundaries. For systems with BBML2, this will be handled in future
>>> patches by dyanmically splitting the mappings when required.
>>>
>>> Unlike apply_to_page_range(), the pagewalk API currently enforces the
>>> init_mm.mmap_lock to be held. To avoid the unnecessary bottleneck of the
>>> mmap_lock for our usecase, this patch extends this generic API to be
>>> used locklessly, so as to retain the existing behaviour for changing
>>> permissions. Apart from this reason, it is noted at [1] that KFENCE can
>>> manipulate kernel pgtable entries during softirqs. It does this by
>>> calling set_memory_valid() -> __change_memory_common(). This being a
>>> non-sleepable context, we cannot take the init_mm mmap lock.
>>>
>>> Add comments to highlight the conditions under which we can use the
>>> lockless variant - no underlying VMA, and the user having exclusive
>>> control over the range, thus guaranteeing no concurrent access.
>>>
>>> We require that the start and end of a given range do not partially
>>> overlap block mappings, or cont mappings. Return -EINVAL in case a
>>> partial block mapping is detected in any of the PGD/P4D/PUD/PMD levels;
>>> add a corresponding comment in update_range_prot() to warn that
>>> eliminating such a condition is the responsibility of the caller.
>>>
>>> Note that, the pte level callback may change permissions for a whole
>>> contpte block, and that will be done one pte at a time, as opposed to an
>>> atomic operation for the block mappings. This is fine as any access will
>>> decode either the old or the new permission until the TLBI.
>>>
>>> apply_to_page_range() currently performs all pte level callbacks while
>>> in lazy mmu mode. Since arm64 can optimize performance by batching
>>> barriers when modifying kernel pgtables in lazy mmu mode, we would like
>>> to continue to benefit from this optimisation. Unfortunately
>>> walk_kernel_page_table_range() does not use lazy mmu mode. However,
>>> since the pagewalk framework is not allocating any memory, we can safely
>>> bracket the whole operation inside lazy mmu mode ourselves. Therefore,
>>> wrap the call to walk_kernel_page_table_range() with the lazy MMU
>>> helpers.
>>>
>>> Link:https://lore.kernel.org/linux-arm-kernel/89d0ad18-4772-4d8f-
>>> ae8a-7c48d26a927e@arm.com/ [1]
>>> Signed-off-by: Dev Jain<dev.jain@arm.com>
>>> Reviewed-by: Ryan Roberts<ryan.roberts@arm.com>
>>> Reviewed-by: Catalin Marinas<catalin.marinas@arm.com>
>>> ---
>>>   arch/arm64/mm/pageattr.c | 153 +++++++++++++++++++++++++++++++--------
>>>   include/linux/pagewalk.h |   3 +
>>>   mm/pagewalk.c            |  36 ++++++---
>>>   3 files changed, 149 insertions(+), 43 deletions(-)
>>>
>>> diff --git a/arch/arm64/mm/pageattr.c b/arch/arm64/mm/pageattr.c
>>> index 04d4a8f676db..6da8cbc32f46 100644
>>> --- a/arch/arm64/mm/pageattr.c
>>> +++ b/arch/arm64/mm/pageattr.c
>>> @@ -8,6 +8,7 @@
>>>   #include <linux/mem_encrypt.h>
>>>   #include <linux/sched.h>
>>>   #include <linux/vmalloc.h>
>>> +#include <linux/pagewalk.h>
>>>   
>>>   #include <asm/cacheflush.h>
>>>   #include <asm/pgtable-prot.h>
>>> @@ -20,6 +21,99 @@ struct page_change_data {
>>>   	pgprot_t clear_mask;
>>>   };
>>>   
>>> +static ptdesc_t set_pageattr_masks(ptdesc_t val, struct mm_walk *walk)
>>> +{
>>> +	struct page_change_data *masks = walk->private;
>>> +
>>> +	val &= ~(pgprot_val(masks->clear_mask));
>>> +	val |= (pgprot_val(masks->set_mask));
>>> +
>>> +	return val;
>>> +}
>>> +
>>> +static int pageattr_pgd_entry(pgd_t *pgd, unsigned long addr,
>>> +			      unsigned long next, struct mm_walk *walk)
>>> +{
>>> +	pgd_t val = pgdp_get(pgd);
>>> +
>>> +	if (pgd_leaf(val)) {
>>> +		if (WARN_ON_ONCE((next - addr) != PGDIR_SIZE))
>>> +			return -EINVAL;
>>> +		val = __pgd(set_pageattr_masks(pgd_val(val), walk));
>>> +		set_pgd(pgd, val);
>>> +		walk->action = ACTION_CONTINUE;
>>> +	}
>>> +
>>> +	return 0;
>>> +}
>>> +
>>> +static int pageattr_p4d_entry(p4d_t *p4d, unsigned long addr,
>>> +			      unsigned long next, struct mm_walk *walk)
>>> +{
>>> +	p4d_t val = p4dp_get(p4d);
>>> +
>>> +	if (p4d_leaf(val)) {
>>> +		if (WARN_ON_ONCE((next - addr) != P4D_SIZE))
>>> +			return -EINVAL;
>>> +		val = __p4d(set_pageattr_masks(p4d_val(val), walk));
>>> +		set_p4d(p4d, val);
>>> +		walk->action = ACTION_CONTINUE;
>>> +	}
>>> +
>>> +	return 0;
>>> +}
>>> +
>>> +static int pageattr_pud_entry(pud_t *pud, unsigned long addr,
>>> +			      unsigned long next, struct mm_walk *walk)
>>> +{
>>> +	pud_t val = pudp_get(pud);
>>> +
>>> +	if (pud_leaf(val)) {
>>> +		if (WARN_ON_ONCE((next - addr) != PUD_SIZE))
>>> +			return -EINVAL;
>>> +		val = __pud(set_pageattr_masks(pud_val(val), walk));
>>> +		set_pud(pud, val);
>>> +		walk->action = ACTION_CONTINUE;
>>> +	}
>>> +
>>> +	return 0;
>>> +}
>>> +
>>> +static int pageattr_pmd_entry(pmd_t *pmd, unsigned long addr,
>>> +			      unsigned long next, struct mm_walk *walk)
>>> +{
>>> +	pmd_t val = pmdp_get(pmd);
>>> +
>>> +	if (pmd_leaf(val)) {
>>> +		if (WARN_ON_ONCE((next - addr) != PMD_SIZE))
>>> +			return -EINVAL;
>>> +		val = __pmd(set_pageattr_masks(pmd_val(val), walk));
>>> +		set_pmd(pmd, val);
>>> +		walk->action = ACTION_CONTINUE;
>>> +	}
>>> +
>>> +	return 0;
>>> +}
>> #define pmd_leaf(pmd)        (pmd_present(pmd) && !pmd_table(pmd))
>> #define pmd_present(pmd)	pte_present(pmd_pte(pmd))
>> #define pte_present(pte)	(pte_valid(pte) || pte_present_invalid(pte))
>>
>> When PTE_VALID is cleared, pmd_leaf() will return false. As a result, the
>> caller won't be able to set PTE_VALID for the pmd.
> Ouch - good spot!
>
> So this will break set_direct_map_default_noflush(), set_memory_valid() and
> __set_memory_enc_dec(). I wonder why it doesn't cause problems with mm selftests
> - I'll investigate.

This only triggers when operating on a PMD_SIZE folio and the linear mapping of the
folio is PMD-mapped. set_direct_map_default_noflush() only operates on base page.
set_memory_valid() and __set_memory_enc_dec() seems to be called for base page too,
or when can_set_direct_map() is required to be true, i.e. the linear mapping is PTE level.

> Anyway, I think the simplest solution is to replace the pmd_leaf()/pud_leaf()
> checks with !pmd_table()/!pud_table() checks. (and I think we can entirely
> remove the pgd and p4d callbacks because pgd_leaf() and p4d_leaf() always return
> false on arm64). As long as no code ever clears PTE_VALID from a table entry, I
> think this works.
>
> Thanks,
> Ryan
>
>>> +
>>> +static int pageattr_pte_entry(pte_t *pte, unsigned long addr,
>>> +			      unsigned long next, struct mm_walk *walk)
>>> +{
>>> +	pte_t val = __ptep_get(pte);
>>> +
>>> +	val = __pte(set_pageattr_masks(pte_val(val), walk));
>>> +	__set_pte(pte, val);
>>> +
>>> +	return 0;
>>> +}
>>> +
>>> +static const struct mm_walk_ops pageattr_ops = {
>>> +	.pgd_entry	= pageattr_pgd_entry,
>>> +	.p4d_entry	= pageattr_p4d_entry,
>>> +	.pud_entry	= pageattr_pud_entry,
>>> +	.pmd_entry	= pageattr_pmd_entry,
>>> +	.pte_entry	= pageattr_pte_entry,
>>> +};
>>> +
>>>   bool rodata_full __ro_after_init = IS_ENABLED(CONFIG_RODATA_FULL_DEFAULT_ENABLED);
>>>   
>>>   bool can_set_direct_map(void)
>>> @@ -37,32 +131,35 @@ bool can_set_direct_map(void)
>>>   		arm64_kfence_can_set_direct_map() || is_realm_world();
>>>   }
>>>   
>>> -static int change_page_range(pte_t *ptep, unsigned long addr, void *data)
>>> +static int update_range_prot(unsigned long start, unsigned long size,
>>> +			     pgprot_t set_mask, pgprot_t clear_mask)
>>>   {
>>> -	struct page_change_data *cdata = data;
>>> -	pte_t pte = __ptep_get(ptep);
>>> +	struct page_change_data data;
>>> +	int ret;
>>>   
>>> -	pte = clear_pte_bit(pte, cdata->clear_mask);
>>> -	pte = set_pte_bit(pte, cdata->set_mask);
>>> +	data.set_mask = set_mask;
>>> +	data.clear_mask = clear_mask;
>>>   
>>> -	__set_pte(ptep, pte);
>>> -	return 0;
>>> +	arch_enter_lazy_mmu_mode();
>>> +
>>> +	/*
>>> +	 * The caller must ensure that the range we are operating on does not
>>> +	 * partially overlap a block mapping, or a cont mapping. Any such case
>>> +	 * must be eliminated by splitting the mapping.
>>> +	 */
>>> +	ret = walk_kernel_page_table_range_lockless(start, start + size,
>>> +						    &pageattr_ops, NULL, &data);
>>> +	arch_leave_lazy_mmu_mode();
>>> +
>>> +	return ret;
>>>   }
>>>   
>>> -/*
>>> - * This function assumes that the range is mapped with PAGE_SIZE pages.
>>> - */
>>>   static int __change_memory_common(unsigned long start, unsigned long size,
>>> -				pgprot_t set_mask, pgprot_t clear_mask)
>>> +				  pgprot_t set_mask, pgprot_t clear_mask)
>>>   {
>>> -	struct page_change_data data;
>>>   	int ret;
>>>   
>>> -	data.set_mask = set_mask;
>>> -	data.clear_mask = clear_mask;
>>> -
>>> -	ret = apply_to_page_range(&init_mm, start, size, change_page_range,
>>> -					&data);
>>> +	ret = update_range_prot(start, size, set_mask, clear_mask);
>>>   
>>>   	/*
>>>   	 * If the memory is being made valid without changing any other bits
>>> @@ -174,32 +271,26 @@ int set_memory_valid(unsigned long addr, int numpages, int enable)
>>>   
>>>   int set_direct_map_invalid_noflush(struct page *page)
>>>   {
>>> -	struct page_change_data data = {
>>> -		.set_mask = __pgprot(0),
>>> -		.clear_mask = __pgprot(PTE_VALID),
>>> -	};
>>> +	pgprot_t clear_mask = __pgprot(PTE_VALID);
>>> +	pgprot_t set_mask = __pgprot(0);
>>>   
>>>   	if (!can_set_direct_map())
>>>   		return 0;
>>>   
>>> -	return apply_to_page_range(&init_mm,
>>> -				   (unsigned long)page_address(page),
>>> -				   PAGE_SIZE, change_page_range, &data);
>>> +	return update_range_prot((unsigned long)page_address(page),
>>> +				 PAGE_SIZE, set_mask, clear_mask);
>>>   }
>>>   
>>>   int set_direct_map_default_noflush(struct page *page)
>>>   {
>>> -	struct page_change_data data = {
>>> -		.set_mask = __pgprot(PTE_VALID | PTE_WRITE),
>>> -		.clear_mask = __pgprot(PTE_RDONLY),
>>> -	};
>>> +	pgprot_t set_mask = __pgprot(PTE_VALID | PTE_WRITE);
>>> +	pgprot_t clear_mask = __pgprot(PTE_RDONLY);
>>>   
>>>   	if (!can_set_direct_map())
>>>   		return 0;
>>>   
>>> -	return apply_to_page_range(&init_mm,
>>> -				   (unsigned long)page_address(page),
>>> -				   PAGE_SIZE, change_page_range, &data);
>>> +	return update_range_prot((unsigned long)page_address(page),
>>> +				 PAGE_SIZE, set_mask, clear_mask);
>>>   }
>>>   
>>>   static int __set_memory_enc_dec(unsigned long addr,
>>> diff --git a/include/linux/pagewalk.h b/include/linux/pagewalk.h
>>> index 682472c15495..88e18615dd72 100644
>>> --- a/include/linux/pagewalk.h
>>> +++ b/include/linux/pagewalk.h
>>> @@ -134,6 +134,9 @@ int walk_page_range(struct mm_struct *mm, unsigned long start,
>>>   int walk_kernel_page_table_range(unsigned long start,
>>>   		unsigned long end, const struct mm_walk_ops *ops,
>>>   		pgd_t *pgd, void *private);
>>> +int walk_kernel_page_table_range_lockless(unsigned long start,
>>> +		unsigned long end, const struct mm_walk_ops *ops,
>>> +		pgd_t *pgd, void *private);
>>>   int walk_page_range_vma(struct vm_area_struct *vma, unsigned long start,
>>>   			unsigned long end, const struct mm_walk_ops *ops,
>>>   			void *private);
>>> diff --git a/mm/pagewalk.c b/mm/pagewalk.c
>>> index 648038247a8d..936689d8bcac 100644
>>> --- a/mm/pagewalk.c
>>> +++ b/mm/pagewalk.c
>>> @@ -606,10 +606,32 @@ int walk_page_range(struct mm_struct *mm, unsigned long start,
>>>   int walk_kernel_page_table_range(unsigned long start, unsigned long end,
>>>   		const struct mm_walk_ops *ops, pgd_t *pgd, void *private)
>>>   {
>>> -	struct mm_struct *mm = &init_mm;
>>> +	/*
>>> +	 * Kernel intermediate page tables are usually not freed, so the mmap
>>> +	 * read lock is sufficient. But there are some exceptions.
>>> +	 * E.g. memory hot-remove. In which case, the mmap lock is insufficient
>>> +	 * to prevent the intermediate kernel pages tables belonging to the
>>> +	 * specified address range from being freed. The caller should take
>>> +	 * other actions to prevent this race.
>>> +	 */
>>> +	mmap_assert_locked(&init_mm);
>>> +
>>> +	return walk_kernel_page_table_range_lockless(start, end, ops, pgd,
>>> +						     private);
>>> +}
>>> +
>>> +/*
>>> + * Use this function to walk the kernel page tables locklessly. It should be
>>> + * guaranteed that the caller has exclusive access over the range they are
>>> + * operating on - that there should be no concurrent access, for example,
>>> + * changing permissions for vmalloc objects.
>>> + */
>>> +int walk_kernel_page_table_range_lockless(unsigned long start, unsigned long end,
>>> +		const struct mm_walk_ops *ops, pgd_t *pgd, void *private)
>>> +{
>>>   	struct mm_walk walk = {
>>>   		.ops		= ops,
>>> -		.mm		= mm,
>>> +		.mm		= &init_mm,
>>>   		.pgd		= pgd,
>>>   		.private	= private,
>>>   		.no_vma		= true
>>> @@ -620,16 +642,6 @@ int walk_kernel_page_table_range(unsigned long start, unsigned long end,
>>>   	if (!check_ops_valid(ops))
>>>   		return -EINVAL;
>>>   
>>> -	/*
>>> -	 * Kernel intermediate page tables are usually not freed, so the mmap
>>> -	 * read lock is sufficient. But there are some exceptions.
>>> -	 * E.g. memory hot-remove. In which case, the mmap lock is insufficient
>>> -	 * to prevent the intermediate kernel pages tables belonging to the
>>> -	 * specified address range from being freed. The caller should take
>>> -	 * other actions to prevent this race.
>>> -	 */
>>> -	mmap_assert_locked(mm);
>>> -
>>>   	return walk_pgd_range(start, end, &walk);
>>>   }
>>>   
>
--------------68GmtYSdYecpnQbAag2L3nqh
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: 8bit

<!DOCTYPE html>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  </head>
  <body>
    <p><br>
    </p>
    <div class="moz-cite-prefix">在 2025/9/4 19:06, Ryan Roberts 写道:<br>
    </div>
    <blockquote type="cite"
      cite="mid:42b3b394-a6ec-4d70-b5a1-941a0628cd25@arm.com">
      <pre wrap="" class="moz-quote-pre">On 04/09/2025 04:40, Jinjiang Tu wrote:
</pre>
      <blockquote type="cite">
        <pre wrap="" class="moz-quote-pre">
在 2025/8/29 19:52, Ryan Roberts 写道:
</pre>
        <blockquote type="cite">
          <pre wrap="" class="moz-quote-pre">From: Dev Jain <a class="moz-txt-link-rfc2396E" href="mailto:dev.jain@arm.com">&lt;dev.jain@arm.com&gt;</a>

This patch paves the path to enable huge mappings in vmalloc space and
linear map space by default on arm64. For this we must ensure that we
can handle any permission games on the kernel (init_mm) pagetable.
Previously, __change_memory_common() used apply_to_page_range() which
does not support changing permissions for block mappings. We move away
from this by using the pagewalk API, similar to what riscv does right
now. It is the responsibility of the caller to ensure that the range
over which permissions are being changed falls on leaf mapping
boundaries. For systems with BBML2, this will be handled in future
patches by dyanmically splitting the mappings when required.

Unlike apply_to_page_range(), the pagewalk API currently enforces the
init_mm.mmap_lock to be held. To avoid the unnecessary bottleneck of the
mmap_lock for our usecase, this patch extends this generic API to be
used locklessly, so as to retain the existing behaviour for changing
permissions. Apart from this reason, it is noted at [1] that KFENCE can
manipulate kernel pgtable entries during softirqs. It does this by
calling set_memory_valid() -&gt; __change_memory_common(). This being a
non-sleepable context, we cannot take the init_mm mmap lock.

Add comments to highlight the conditions under which we can use the
lockless variant - no underlying VMA, and the user having exclusive
control over the range, thus guaranteeing no concurrent access.

We require that the start and end of a given range do not partially
overlap block mappings, or cont mappings. Return -EINVAL in case a
partial block mapping is detected in any of the PGD/P4D/PUD/PMD levels;
add a corresponding comment in update_range_prot() to warn that
eliminating such a condition is the responsibility of the caller.

Note that, the pte level callback may change permissions for a whole
contpte block, and that will be done one pte at a time, as opposed to an
atomic operation for the block mappings. This is fine as any access will
decode either the old or the new permission until the TLBI.

apply_to_page_range() currently performs all pte level callbacks while
in lazy mmu mode. Since arm64 can optimize performance by batching
barriers when modifying kernel pgtables in lazy mmu mode, we would like
to continue to benefit from this optimisation. Unfortunately
walk_kernel_page_table_range() does not use lazy mmu mode. However,
since the pagewalk framework is not allocating any memory, we can safely
bracket the whole operation inside lazy mmu mode ourselves. Therefore,
wrap the call to walk_kernel_page_table_range() with the lazy MMU
helpers.

Link: <a class="moz-txt-link-freetext" href="https://lore.kernel.org/linux-arm-kernel/89d0ad18-4772-4d8f">https://lore.kernel.org/linux-arm-kernel/89d0ad18-4772-4d8f</a>-
<a class="moz-txt-link-abbreviated" href="mailto:ae8a-7c48d26a927e@arm.com/">ae8a-7c48d26a927e@arm.com/</a> [1]
Signed-off-by: Dev Jain <a class="moz-txt-link-rfc2396E" href="mailto:dev.jain@arm.com">&lt;dev.jain@arm.com&gt;</a>
Reviewed-by: Ryan Roberts <a class="moz-txt-link-rfc2396E" href="mailto:ryan.roberts@arm.com">&lt;ryan.roberts@arm.com&gt;</a>
Reviewed-by: Catalin Marinas <a class="moz-txt-link-rfc2396E" href="mailto:catalin.marinas@arm.com">&lt;catalin.marinas@arm.com&gt;</a>
---
 arch/arm64/mm/pageattr.c | 153 +++++++++++++++++++++++++++++++--------
 include/linux/pagewalk.h |   3 +
 mm/pagewalk.c            |  36 ++++++---
 3 files changed, 149 insertions(+), 43 deletions(-)

diff --git a/arch/arm64/mm/pageattr.c b/arch/arm64/mm/pageattr.c
index 04d4a8f676db..6da8cbc32f46 100644
--- a/arch/arm64/mm/pageattr.c
+++ b/arch/arm64/mm/pageattr.c
@@ -8,6 +8,7 @@
 #include &lt;linux/mem_encrypt.h&gt;
 #include &lt;linux/sched.h&gt;
 #include &lt;linux/vmalloc.h&gt;
+#include &lt;linux/pagewalk.h&gt;
 
 #include &lt;asm/cacheflush.h&gt;
 #include &lt;asm/pgtable-prot.h&gt;
@@ -20,6 +21,99 @@ struct page_change_data {
 	pgprot_t clear_mask;
 };
 
+static ptdesc_t set_pageattr_masks(ptdesc_t val, struct mm_walk *walk)
+{
+	struct page_change_data *masks = walk-&gt;private;
+
+	val &amp;= ~(pgprot_val(masks-&gt;clear_mask));
+	val |= (pgprot_val(masks-&gt;set_mask));
+
+	return val;
+}
+
+static int pageattr_pgd_entry(pgd_t *pgd, unsigned long addr,
+			      unsigned long next, struct mm_walk *walk)
+{
+	pgd_t val = pgdp_get(pgd);
+
+	if (pgd_leaf(val)) {
+		if (WARN_ON_ONCE((next - addr) != PGDIR_SIZE))
+			return -EINVAL;
+		val = __pgd(set_pageattr_masks(pgd_val(val), walk));
+		set_pgd(pgd, val);
+		walk-&gt;action = ACTION_CONTINUE;
+	}
+
+	return 0;
+}
+
+static int pageattr_p4d_entry(p4d_t *p4d, unsigned long addr,
+			      unsigned long next, struct mm_walk *walk)
+{
+	p4d_t val = p4dp_get(p4d);
+
+	if (p4d_leaf(val)) {
+		if (WARN_ON_ONCE((next - addr) != P4D_SIZE))
+			return -EINVAL;
+		val = __p4d(set_pageattr_masks(p4d_val(val), walk));
+		set_p4d(p4d, val);
+		walk-&gt;action = ACTION_CONTINUE;
+	}
+
+	return 0;
+}
+
+static int pageattr_pud_entry(pud_t *pud, unsigned long addr,
+			      unsigned long next, struct mm_walk *walk)
+{
+	pud_t val = pudp_get(pud);
+
+	if (pud_leaf(val)) {
+		if (WARN_ON_ONCE((next - addr) != PUD_SIZE))
+			return -EINVAL;
+		val = __pud(set_pageattr_masks(pud_val(val), walk));
+		set_pud(pud, val);
+		walk-&gt;action = ACTION_CONTINUE;
+	}
+
+	return 0;
+}
+
+static int pageattr_pmd_entry(pmd_t *pmd, unsigned long addr,
+			      unsigned long next, struct mm_walk *walk)
+{
+	pmd_t val = pmdp_get(pmd);
+
+	if (pmd_leaf(val)) {
+		if (WARN_ON_ONCE((next - addr) != PMD_SIZE))
+			return -EINVAL;
+		val = __pmd(set_pageattr_masks(pmd_val(val), walk));
+		set_pmd(pmd, val);
+		walk-&gt;action = ACTION_CONTINUE;
+	}
+
+	return 0;
+}
</pre>
        </blockquote>
        <pre wrap="" class="moz-quote-pre">
#define pmd_leaf(pmd)        (pmd_present(pmd) &amp;&amp; !pmd_table(pmd))
#define pmd_present(pmd)	pte_present(pmd_pte(pmd))
#define pte_present(pte)	(pte_valid(pte) || pte_present_invalid(pte))

When PTE_VALID is cleared, pmd_leaf() will return false. As a result, the
caller won't be able to set PTE_VALID for the pmd.
</pre>
      </blockquote>
      <pre wrap="" class="moz-quote-pre">
Ouch - good spot!

So this will break set_direct_map_default_noflush(), set_memory_valid() and
__set_memory_enc_dec(). I wonder why it doesn't cause problems with mm selftests
- I'll investigate.
</pre>
    </blockquote>
    <pre>This only triggers when operating on a PMD_SIZE folio and the linear mapping of the
folio is PMD-mapped. set_direct_map_default_noflush() only operates on base page.
set_memory_valid() and __set_memory_enc_dec() seems to be called for base page too,
or when can_set_direct_map() is required to be true, i.e. the linear mapping is PTE level.</pre>
    <blockquote type="cite"
      cite="mid:42b3b394-a6ec-4d70-b5a1-941a0628cd25@arm.com">
      <pre wrap="" class="moz-quote-pre">
Anyway, I think the simplest solution is to replace the pmd_leaf()/pud_leaf()
checks with !pmd_table()/!pud_table() checks. (and I think we can entirely
remove the pgd and p4d callbacks because pgd_leaf() and p4d_leaf() always return
false on arm64). As long as no code ever clears PTE_VALID from a table entry, I
think this works.

Thanks,
Ryan

</pre>
      <blockquote type="cite">
        <pre wrap="" class="moz-quote-pre">
</pre>
        <blockquote type="cite">
          <pre wrap="" class="moz-quote-pre">+
+static int pageattr_pte_entry(pte_t *pte, unsigned long addr,
+			      unsigned long next, struct mm_walk *walk)
+{
+	pte_t val = __ptep_get(pte);
+
+	val = __pte(set_pageattr_masks(pte_val(val), walk));
+	__set_pte(pte, val);
+
+	return 0;
+}
+
+static const struct mm_walk_ops pageattr_ops = {
+	.pgd_entry	= pageattr_pgd_entry,
+	.p4d_entry	= pageattr_p4d_entry,
+	.pud_entry	= pageattr_pud_entry,
+	.pmd_entry	= pageattr_pmd_entry,
+	.pte_entry	= pageattr_pte_entry,
+};
+
 bool rodata_full __ro_after_init = IS_ENABLED(CONFIG_RODATA_FULL_DEFAULT_ENABLED);
 
 bool can_set_direct_map(void)
@@ -37,32 +131,35 @@ bool can_set_direct_map(void)
 		arm64_kfence_can_set_direct_map() || is_realm_world();
 }
 
-static int change_page_range(pte_t *ptep, unsigned long addr, void *data)
+static int update_range_prot(unsigned long start, unsigned long size,
+			     pgprot_t set_mask, pgprot_t clear_mask)
 {
-	struct page_change_data *cdata = data;
-	pte_t pte = __ptep_get(ptep);
+	struct page_change_data data;
+	int ret;
 
-	pte = clear_pte_bit(pte, cdata-&gt;clear_mask);
-	pte = set_pte_bit(pte, cdata-&gt;set_mask);
+	data.set_mask = set_mask;
+	data.clear_mask = clear_mask;
 
-	__set_pte(ptep, pte);
-	return 0;
+	arch_enter_lazy_mmu_mode();
+
+	/*
+	 * The caller must ensure that the range we are operating on does not
+	 * partially overlap a block mapping, or a cont mapping. Any such case
+	 * must be eliminated by splitting the mapping.
+	 */
+	ret = walk_kernel_page_table_range_lockless(start, start + size,
+						    &amp;pageattr_ops, NULL, &amp;data);
+	arch_leave_lazy_mmu_mode();
+
+	return ret;
 }
 
-/*
- * This function assumes that the range is mapped with PAGE_SIZE pages.
- */
 static int __change_memory_common(unsigned long start, unsigned long size,
-				pgprot_t set_mask, pgprot_t clear_mask)
+				  pgprot_t set_mask, pgprot_t clear_mask)
 {
-	struct page_change_data data;
 	int ret;
 
-	data.set_mask = set_mask;
-	data.clear_mask = clear_mask;
-
-	ret = apply_to_page_range(&amp;init_mm, start, size, change_page_range,
-					&amp;data);
+	ret = update_range_prot(start, size, set_mask, clear_mask);
 
 	/*
 	 * If the memory is being made valid without changing any other bits
@@ -174,32 +271,26 @@ int set_memory_valid(unsigned long addr, int numpages, int enable)
 
 int set_direct_map_invalid_noflush(struct page *page)
 {
-	struct page_change_data data = {
-		.set_mask = __pgprot(0),
-		.clear_mask = __pgprot(PTE_VALID),
-	};
+	pgprot_t clear_mask = __pgprot(PTE_VALID);
+	pgprot_t set_mask = __pgprot(0);
 
 	if (!can_set_direct_map())
 		return 0;
 
-	return apply_to_page_range(&amp;init_mm,
-				   (unsigned long)page_address(page),
-				   PAGE_SIZE, change_page_range, &amp;data);
+	return update_range_prot((unsigned long)page_address(page),
+				 PAGE_SIZE, set_mask, clear_mask);
 }
 
 int set_direct_map_default_noflush(struct page *page)
 {
-	struct page_change_data data = {
-		.set_mask = __pgprot(PTE_VALID | PTE_WRITE),
-		.clear_mask = __pgprot(PTE_RDONLY),
-	};
+	pgprot_t set_mask = __pgprot(PTE_VALID | PTE_WRITE);
+	pgprot_t clear_mask = __pgprot(PTE_RDONLY);
 
 	if (!can_set_direct_map())
 		return 0;
 
-	return apply_to_page_range(&amp;init_mm,
-				   (unsigned long)page_address(page),
-				   PAGE_SIZE, change_page_range, &amp;data);
+	return update_range_prot((unsigned long)page_address(page),
+				 PAGE_SIZE, set_mask, clear_mask);
 }
 
 static int __set_memory_enc_dec(unsigned long addr,
diff --git a/include/linux/pagewalk.h b/include/linux/pagewalk.h
index 682472c15495..88e18615dd72 100644
--- a/include/linux/pagewalk.h
+++ b/include/linux/pagewalk.h
@@ -134,6 +134,9 @@ int walk_page_range(struct mm_struct *mm, unsigned long start,
 int walk_kernel_page_table_range(unsigned long start,
 		unsigned long end, const struct mm_walk_ops *ops,
 		pgd_t *pgd, void *private);
+int walk_kernel_page_table_range_lockless(unsigned long start,
+		unsigned long end, const struct mm_walk_ops *ops,
+		pgd_t *pgd, void *private);
 int walk_page_range_vma(struct vm_area_struct *vma, unsigned long start,
 			unsigned long end, const struct mm_walk_ops *ops,
 			void *private);
diff --git a/mm/pagewalk.c b/mm/pagewalk.c
index 648038247a8d..936689d8bcac 100644
--- a/mm/pagewalk.c
+++ b/mm/pagewalk.c
@@ -606,10 +606,32 @@ int walk_page_range(struct mm_struct *mm, unsigned long start,
 int walk_kernel_page_table_range(unsigned long start, unsigned long end,
 		const struct mm_walk_ops *ops, pgd_t *pgd, void *private)
 {
-	struct mm_struct *mm = &amp;init_mm;
+	/*
+	 * Kernel intermediate page tables are usually not freed, so the mmap
+	 * read lock is sufficient. But there are some exceptions.
+	 * E.g. memory hot-remove. In which case, the mmap lock is insufficient
+	 * to prevent the intermediate kernel pages tables belonging to the
+	 * specified address range from being freed. The caller should take
+	 * other actions to prevent this race.
+	 */
+	mmap_assert_locked(&amp;init_mm);
+
+	return walk_kernel_page_table_range_lockless(start, end, ops, pgd,
+						     private);
+}
+
+/*
+ * Use this function to walk the kernel page tables locklessly. It should be
+ * guaranteed that the caller has exclusive access over the range they are
+ * operating on - that there should be no concurrent access, for example,
+ * changing permissions for vmalloc objects.
+ */
+int walk_kernel_page_table_range_lockless(unsigned long start, unsigned long end,
+		const struct mm_walk_ops *ops, pgd_t *pgd, void *private)
+{
 	struct mm_walk walk = {
 		.ops		= ops,
-		.mm		= mm,
+		.mm		= &amp;init_mm,
 		.pgd		= pgd,
 		.private	= private,
 		.no_vma		= true
@@ -620,16 +642,6 @@ int walk_kernel_page_table_range(unsigned long start, unsigned long end,
 	if (!check_ops_valid(ops))
 		return -EINVAL;
 
-	/*
-	 * Kernel intermediate page tables are usually not freed, so the mmap
-	 * read lock is sufficient. But there are some exceptions.
-	 * E.g. memory hot-remove. In which case, the mmap lock is insufficient
-	 * to prevent the intermediate kernel pages tables belonging to the
-	 * specified address range from being freed. The caller should take
-	 * other actions to prevent this race.
-	 */
-	mmap_assert_locked(mm);
-
 	return walk_pgd_range(start, end, &amp;walk);
 }
 
</pre>
        </blockquote>
      </blockquote>
      <pre wrap="" class="moz-quote-pre">

</pre>
    </blockquote>
  </body>
</html>

--------------68GmtYSdYecpnQbAag2L3nqh--

