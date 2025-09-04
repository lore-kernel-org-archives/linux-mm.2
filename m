Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA7B4CA1002
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 13:21:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 407968E0005; Thu,  4 Sep 2025 09:21:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3DECF8E0001; Thu,  4 Sep 2025 09:21:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F4D28E0005; Thu,  4 Sep 2025 09:21:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1CA988E0001
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 09:21:56 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CAB48B6A28
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 13:21:55 +0000 (UTC)
X-FDA: 83851630590.21.1287D86
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf08.hostedemail.com (Postfix) with ESMTP id 024C2160015
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 13:21:53 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=none;
	spf=pass (imf08.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756992114; a=rsa-sha256;
	cv=none;
	b=AOqUh9wBx3dOOVYNKs+/pWn0stl/3FjxGpCk0y00c8fbpc2AkQU05B0KuXlaG2ASLNa4TG
	wmybJvDixSQ8TMa8SAObO245l3bi9sICFi2nuoyXcM0ySflue6DgFVSXLNeK63RVUd0I9g
	ZciCWdeF1n8aCkjHR4ZfFLENBvqvOBI=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=none;
	spf=pass (imf08.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756992114;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LyIIgnsEy8sNC03BP9Y5uyU9X6Od4/BTkRF3tf10mzE=;
	b=TERQg470Ovc3XxrAqy8lYuQ1vD3qYlhwTTIOKrvIbMprH8vMsGPEIR3egu9W6BlCMvBEHn
	v767VZOUK9Q25ooWRsRg6g461U08SRj1S3YY2Xl9b98PgO3243r/GIsbQIS23XWUSNOQcT
	AZMIDVo+w3ARph18eCSJ1m5IggaH0dw=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A46451756;
	Thu,  4 Sep 2025 06:21:44 -0700 (PDT)
Received: from [10.1.37.179] (XHFQ2J9959.cambridge.arm.com [10.1.37.179])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E876C3F6A8;
	Thu,  4 Sep 2025 06:21:50 -0700 (PDT)
Message-ID: <f940ddc9-9b1f-49fa-9d50-ea3b65f39a81@arm.com>
Date: Thu, 4 Sep 2025 14:21:49 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 1/6] arm64: Enable permission change on arm64 kernel
 block mappings
Content-Language: en-GB
To: Jinjiang Tu <tujinjiang@huawei.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Yang Shi <yang@os.amperecomputing.com>, Ard Biesheuvel <ardb@kernel.org>,
 Dev Jain <dev.jain@arm.com>, scott@os.amperecomputing.com, cl@gentwo.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
References: <20250829115250.2395585-1-ryan.roberts@arm.com>
 <20250829115250.2395585-2-ryan.roberts@arm.com>
 <7705c29b-4f08-4b56-aab3-024795ee9124@huawei.com>
 <42b3b394-a6ec-4d70-b5a1-941a0628cd25@arm.com>
 <a985c9f0-1561-45d7-860f-2717a0a72d9e@huawei.com>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <a985c9f0-1561-45d7-860f-2717a0a72d9e@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 024C2160015
X-Stat-Signature: u8mytu6ohx54ggz1f1qtm38irodd494a
X-Rspam-User: 
X-HE-Tag: 1756992113-392598
X-HE-Meta: U2FsdGVkX1/lVD452bGPyQWbNEKp1wN8A+cMzxqKQQhflpsd8bUnTixpC2aWKoC/NDUwkSo+Ba2aiwS4DLitaWhxXqOmZPvMbRvfQroXMsBwCLwthZAx/oAznTgL4C64HoTui+qbmFXsF2kEFthTC9vZLdOcG11iK3pjMCo2L/k2CSImBlvx9hdHSTvQkPSxq75CfaU0aWWCIi3j82zURl27DW9v9AGqkpbNluvfl1+WX31MmGyj78IoZiI8goopmbqO6J8oSaC2ykTcCtTsGEyQAhf6SrYEnC2hGvFD3vQFoiIsa1zwCtulcRo3aqyCDV54OW6fjMLSOjaHven2ls8J6PDFKr05Ci6sIYfiN0IjSlf3Gka59Ty4m0rW+dDGWz4+lh8h31ARQ8ZtYyvy/eugg1om/U9kQ3zP7pxkJFsN6QqGLDzCTQ2DwWpurOCITSbxtRCTFtvSXFFl8Qge1wKZ/T5AifVD7Z4X2f2U70VBaOSmp5nSzjtM85tTDNO6oNdhYdkpNJI4XfQFkQrEaWytUzVQu87BvliYCwzKSAj+5nm1MlmXIYMKzPtSlVrJGs1zf3dS6LZ4+u1RFsmZnroc1JIBmdqAOUFNzQ8S/nEm5u+DcYMtGojGKwqzsM0k6UILzKJYDRky9bxbmJ/ootG2y4ZtnVtEjwDwMet6eiqadAT6t1vhAtlHSHriANeENcI55aqjruSaMVQnPLBfwfLXZ6YkjRPae4PKgRMzehaNF54p28moWtuoHkAnLLzyhmVDQtIngyXzK3U7nHP9pobMNSB+/44vCKirtwxxIoWMVIU61CtbULucQbCFUZgkLPI8ZRgDoBKXr2st8EKEOsdkK25r/QXNWW/I206EcMFzidRiBqhl5BdACAu5u785ObOODzbUhG419fSQmzw+iYdAWitkPhe72CsxAyDezSXDizNsz79WbZ4U4YTHMNJPuehR02o3hpxGIdt21WB
 swMYWCkv
 gi/YOSIBWc5T0AmVmY46Z2yzc8QbbVlrrpWjNeRjqwPVoaH7kCCTmDPw8vjJPXuX4sNwiAxcMRS7IRGe6BW2FwLH2wmYhEk7jAI5ztHX8ZgelYKMhBW9iJ9bc3N5SK4g+JkNBHZH4CYMqr24R8RYld+moDhgdIc9ZlohnSZ4ZP0WLnLHpn1QRH9uURUlFLZGu9dNHKTZ+hXmWbHsjjEj0duLl0g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 04/09/2025 12:49, Jinjiang Tu wrote:
> 
> 在 2025/9/4 19:06, Ryan Roberts 写道:
>> On 04/09/2025 04:40, Jinjiang Tu wrote:
>>> 在 2025/8/29 19:52, Ryan Roberts 写道:
>>>> From: Dev Jain <dev.jain@arm.com>
>>>>
>>>> This patch paves the path to enable huge mappings in vmalloc space and
>>>> linear map space by default on arm64. For this we must ensure that we
>>>> can handle any permission games on the kernel (init_mm) pagetable.
>>>> Previously, __change_memory_common() used apply_to_page_range() which
>>>> does not support changing permissions for block mappings. We move away
>>>> from this by using the pagewalk API, similar to what riscv does right
>>>> now. It is the responsibility of the caller to ensure that the range
>>>> over which permissions are being changed falls on leaf mapping
>>>> boundaries. For systems with BBML2, this will be handled in future
>>>> patches by dyanmically splitting the mappings when required.
>>>>
>>>> Unlike apply_to_page_range(), the pagewalk API currently enforces the
>>>> init_mm.mmap_lock to be held. To avoid the unnecessary bottleneck of the
>>>> mmap_lock for our usecase, this patch extends this generic API to be
>>>> used locklessly, so as to retain the existing behaviour for changing
>>>> permissions. Apart from this reason, it is noted at [1] that KFENCE can
>>>> manipulate kernel pgtable entries during softirqs. It does this by
>>>> calling set_memory_valid() -> __change_memory_common(). This being a
>>>> non-sleepable context, we cannot take the init_mm mmap lock.
>>>>
>>>> Add comments to highlight the conditions under which we can use the
>>>> lockless variant - no underlying VMA, and the user having exclusive
>>>> control over the range, thus guaranteeing no concurrent access.
>>>>
>>>> We require that the start and end of a given range do not partially
>>>> overlap block mappings, or cont mappings. Return -EINVAL in case a
>>>> partial block mapping is detected in any of the PGD/P4D/PUD/PMD levels;
>>>> add a corresponding comment in update_range_prot() to warn that
>>>> eliminating such a condition is the responsibility of the caller.
>>>>
>>>> Note that, the pte level callback may change permissions for a whole
>>>> contpte block, and that will be done one pte at a time, as opposed to an
>>>> atomic operation for the block mappings. This is fine as any access will
>>>> decode either the old or the new permission until the TLBI.
>>>>
>>>> apply_to_page_range() currently performs all pte level callbacks while
>>>> in lazy mmu mode. Since arm64 can optimize performance by batching
>>>> barriers when modifying kernel pgtables in lazy mmu mode, we would like
>>>> to continue to benefit from this optimisation. Unfortunately
>>>> walk_kernel_page_table_range() does not use lazy mmu mode. However,
>>>> since the pagewalk framework is not allocating any memory, we can safely
>>>> bracket the whole operation inside lazy mmu mode ourselves. Therefore,
>>>> wrap the call to walk_kernel_page_table_range() with the lazy MMU
>>>> helpers.
>>>>
>>>> Link: https://lore.kernel.org/linux-arm-kernel/89d0ad18-4772-4d8f-
>>>> ae8a-7c48d26a927e@arm.com/ [1]
>>>> Signed-off-by: Dev Jain <dev.jain@arm.com>
>>>> Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
>>>> Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
>>>> ---
>>>>  arch/arm64/mm/pageattr.c | 153 +++++++++++++++++++++++++++++++--------
>>>>  include/linux/pagewalk.h |   3 +
>>>>  mm/pagewalk.c            |  36 ++++++---
>>>>  3 files changed, 149 insertions(+), 43 deletions(-)
>>>>
>>>> diff --git a/arch/arm64/mm/pageattr.c b/arch/arm64/mm/pageattr.c
>>>> index 04d4a8f676db..6da8cbc32f46 100644
>>>> --- a/arch/arm64/mm/pageattr.c
>>>> +++ b/arch/arm64/mm/pageattr.c
>>>> @@ -8,6 +8,7 @@
>>>>  #include <linux/mem_encrypt.h>
>>>>  #include <linux/sched.h>
>>>>  #include <linux/vmalloc.h>
>>>> +#include <linux/pagewalk.h>
>>>>  
>>>>  #include <asm/cacheflush.h>
>>>>  #include <asm/pgtable-prot.h>
>>>> @@ -20,6 +21,99 @@ struct page_change_data {
>>>>  	pgprot_t clear_mask;
>>>>  };
>>>>  
>>>> +static ptdesc_t set_pageattr_masks(ptdesc_t val, struct mm_walk *walk)
>>>> +{
>>>> +	struct page_change_data *masks = walk->private;
>>>> +
>>>> +	val &= ~(pgprot_val(masks->clear_mask));
>>>> +	val |= (pgprot_val(masks->set_mask));
>>>> +
>>>> +	return val;
>>>> +}
>>>> +
>>>> +static int pageattr_pgd_entry(pgd_t *pgd, unsigned long addr,
>>>> +			      unsigned long next, struct mm_walk *walk)
>>>> +{
>>>> +	pgd_t val = pgdp_get(pgd);
>>>> +
>>>> +	if (pgd_leaf(val)) {
>>>> +		if (WARN_ON_ONCE((next - addr) != PGDIR_SIZE))
>>>> +			return -EINVAL;
>>>> +		val = __pgd(set_pageattr_masks(pgd_val(val), walk));
>>>> +		set_pgd(pgd, val);
>>>> +		walk->action = ACTION_CONTINUE;
>>>> +	}
>>>> +
>>>> +	return 0;
>>>> +}
>>>> +
>>>> +static int pageattr_p4d_entry(p4d_t *p4d, unsigned long addr,
>>>> +			      unsigned long next, struct mm_walk *walk)
>>>> +{
>>>> +	p4d_t val = p4dp_get(p4d);
>>>> +
>>>> +	if (p4d_leaf(val)) {
>>>> +		if (WARN_ON_ONCE((next - addr) != P4D_SIZE))
>>>> +			return -EINVAL;
>>>> +		val = __p4d(set_pageattr_masks(p4d_val(val), walk));
>>>> +		set_p4d(p4d, val);
>>>> +		walk->action = ACTION_CONTINUE;
>>>> +	}
>>>> +
>>>> +	return 0;
>>>> +}
>>>> +
>>>> +static int pageattr_pud_entry(pud_t *pud, unsigned long addr,
>>>> +			      unsigned long next, struct mm_walk *walk)
>>>> +{
>>>> +	pud_t val = pudp_get(pud);
>>>> +
>>>> +	if (pud_leaf(val)) {
>>>> +		if (WARN_ON_ONCE((next - addr) != PUD_SIZE))
>>>> +			return -EINVAL;
>>>> +		val = __pud(set_pageattr_masks(pud_val(val), walk));
>>>> +		set_pud(pud, val);
>>>> +		walk->action = ACTION_CONTINUE;
>>>> +	}
>>>> +
>>>> +	return 0;
>>>> +}
>>>> +
>>>> +static int pageattr_pmd_entry(pmd_t *pmd, unsigned long addr,
>>>> +			      unsigned long next, struct mm_walk *walk)
>>>> +{
>>>> +	pmd_t val = pmdp_get(pmd);
>>>> +
>>>> +	if (pmd_leaf(val)) {
>>>> +		if (WARN_ON_ONCE((next - addr) != PMD_SIZE))
>>>> +			return -EINVAL;
>>>> +		val = __pmd(set_pageattr_masks(pmd_val(val), walk));
>>>> +		set_pmd(pmd, val);
>>>> +		walk->action = ACTION_CONTINUE;
>>>> +	}
>>>> +
>>>> +	return 0;
>>>> +}
>>> #define pmd_leaf(pmd)        (pmd_present(pmd) && !pmd_table(pmd))
>>> #define pmd_present(pmd)	pte_present(pmd_pte(pmd))
>>> #define pte_present(pte)	(pte_valid(pte) || pte_present_invalid(pte))
>>>
>>> When PTE_VALID is cleared, pmd_leaf() will return false. As a result, the
>>> caller won't be able to set PTE_VALID for the pmd.
>> Ouch - good spot!
>>
>> So this will break set_direct_map_default_noflush(), set_memory_valid() and
>> __set_memory_enc_dec(). I wonder why it doesn't cause problems with mm selftests
>> - I'll investigate.
> 
> This only triggers when operating on a PMD_SIZE folio and the linear mapping of the
> folio is PMD-mapped. set_direct_map_default_noflush() only operates on base page.
> set_memory_valid() and __set_memory_enc_dec() seems to be called for base page too,
> or when can_set_direct_map() is required to be true, i.e. the linear mapping is PTE level.

Ahh so we will have split to base pages while making invalid, then when making
valid again, they are ptes so it works as expected.


> 
>> Anyway, I think the simplest solution is to replace the pmd_leaf()/pud_leaf()
>> checks with !pmd_table()/!pud_table() checks. (and I think we can entirely
>> remove the pgd and p4d callbacks because pgd_leaf() and p4d_leaf() always return
>> false on arm64). As long as no code ever clears PTE_VALID from a table entry, I
>> think this works.
>>
>> Thanks,
>> Ryan
>>
>>>> +
>>>> +static int pageattr_pte_entry(pte_t *pte, unsigned long addr,
>>>> +			      unsigned long next, struct mm_walk *walk)
>>>> +{
>>>> +	pte_t val = __ptep_get(pte);
>>>> +
>>>> +	val = __pte(set_pageattr_masks(pte_val(val), walk));
>>>> +	__set_pte(pte, val);
>>>> +
>>>> +	return 0;
>>>> +}
>>>> +
>>>> +static const struct mm_walk_ops pageattr_ops = {
>>>> +	.pgd_entry	= pageattr_pgd_entry,
>>>> +	.p4d_entry	= pageattr_p4d_entry,
>>>> +	.pud_entry	= pageattr_pud_entry,
>>>> +	.pmd_entry	= pageattr_pmd_entry,
>>>> +	.pte_entry	= pageattr_pte_entry,
>>>> +};
>>>> +
>>>>  bool rodata_full __ro_after_init = IS_ENABLED(CONFIG_RODATA_FULL_DEFAULT_ENABLED);
>>>>  
>>>>  bool can_set_direct_map(void)
>>>> @@ -37,32 +131,35 @@ bool can_set_direct_map(void)
>>>>  		arm64_kfence_can_set_direct_map() || is_realm_world();
>>>>  }
>>>>  
>>>> -static int change_page_range(pte_t *ptep, unsigned long addr, void *data)
>>>> +static int update_range_prot(unsigned long start, unsigned long size,
>>>> +			     pgprot_t set_mask, pgprot_t clear_mask)
>>>>  {
>>>> -	struct page_change_data *cdata = data;
>>>> -	pte_t pte = __ptep_get(ptep);
>>>> +	struct page_change_data data;
>>>> +	int ret;
>>>>  
>>>> -	pte = clear_pte_bit(pte, cdata->clear_mask);
>>>> -	pte = set_pte_bit(pte, cdata->set_mask);
>>>> +	data.set_mask = set_mask;
>>>> +	data.clear_mask = clear_mask;
>>>>  
>>>> -	__set_pte(ptep, pte);
>>>> -	return 0;
>>>> +	arch_enter_lazy_mmu_mode();
>>>> +
>>>> +	/*
>>>> +	 * The caller must ensure that the range we are operating on does not
>>>> +	 * partially overlap a block mapping, or a cont mapping. Any such case
>>>> +	 * must be eliminated by splitting the mapping.
>>>> +	 */
>>>> +	ret = walk_kernel_page_table_range_lockless(start, start + size,
>>>> +						    &pageattr_ops, NULL, &data);
>>>> +	arch_leave_lazy_mmu_mode();
>>>> +
>>>> +	return ret;
>>>>  }
>>>>  
>>>> -/*
>>>> - * This function assumes that the range is mapped with PAGE_SIZE pages.
>>>> - */
>>>>  static int __change_memory_common(unsigned long start, unsigned long size,
>>>> -				pgprot_t set_mask, pgprot_t clear_mask)
>>>> +				  pgprot_t set_mask, pgprot_t clear_mask)
>>>>  {
>>>> -	struct page_change_data data;
>>>>  	int ret;
>>>>  
>>>> -	data.set_mask = set_mask;
>>>> -	data.clear_mask = clear_mask;
>>>> -
>>>> -	ret = apply_to_page_range(&init_mm, start, size, change_page_range,
>>>> -					&data);
>>>> +	ret = update_range_prot(start, size, set_mask, clear_mask);
>>>>  
>>>>  	/*
>>>>  	 * If the memory is being made valid without changing any other bits
>>>> @@ -174,32 +271,26 @@ int set_memory_valid(unsigned long addr, int numpages, int enable)
>>>>  
>>>>  int set_direct_map_invalid_noflush(struct page *page)
>>>>  {
>>>> -	struct page_change_data data = {
>>>> -		.set_mask = __pgprot(0),
>>>> -		.clear_mask = __pgprot(PTE_VALID),
>>>> -	};
>>>> +	pgprot_t clear_mask = __pgprot(PTE_VALID);
>>>> +	pgprot_t set_mask = __pgprot(0);
>>>>  
>>>>  	if (!can_set_direct_map())
>>>>  		return 0;
>>>>  
>>>> -	return apply_to_page_range(&init_mm,
>>>> -				   (unsigned long)page_address(page),
>>>> -				   PAGE_SIZE, change_page_range, &data);
>>>> +	return update_range_prot((unsigned long)page_address(page),
>>>> +				 PAGE_SIZE, set_mask, clear_mask);
>>>>  }
>>>>  
>>>>  int set_direct_map_default_noflush(struct page *page)
>>>>  {
>>>> -	struct page_change_data data = {
>>>> -		.set_mask = __pgprot(PTE_VALID | PTE_WRITE),
>>>> -		.clear_mask = __pgprot(PTE_RDONLY),
>>>> -	};
>>>> +	pgprot_t set_mask = __pgprot(PTE_VALID | PTE_WRITE);
>>>> +	pgprot_t clear_mask = __pgprot(PTE_RDONLY);
>>>>  
>>>>  	if (!can_set_direct_map())
>>>>  		return 0;
>>>>  
>>>> -	return apply_to_page_range(&init_mm,
>>>> -				   (unsigned long)page_address(page),
>>>> -				   PAGE_SIZE, change_page_range, &data);
>>>> +	return update_range_prot((unsigned long)page_address(page),
>>>> +				 PAGE_SIZE, set_mask, clear_mask);
>>>>  }
>>>>  
>>>>  static int __set_memory_enc_dec(unsigned long addr,
>>>> diff --git a/include/linux/pagewalk.h b/include/linux/pagewalk.h
>>>> index 682472c15495..88e18615dd72 100644
>>>> --- a/include/linux/pagewalk.h
>>>> +++ b/include/linux/pagewalk.h
>>>> @@ -134,6 +134,9 @@ int walk_page_range(struct mm_struct *mm, unsigned long start,
>>>>  int walk_kernel_page_table_range(unsigned long start,
>>>>  		unsigned long end, const struct mm_walk_ops *ops,
>>>>  		pgd_t *pgd, void *private);
>>>> +int walk_kernel_page_table_range_lockless(unsigned long start,
>>>> +		unsigned long end, const struct mm_walk_ops *ops,
>>>> +		pgd_t *pgd, void *private);
>>>>  int walk_page_range_vma(struct vm_area_struct *vma, unsigned long start,
>>>>  			unsigned long end, const struct mm_walk_ops *ops,
>>>>  			void *private);
>>>> diff --git a/mm/pagewalk.c b/mm/pagewalk.c
>>>> index 648038247a8d..936689d8bcac 100644
>>>> --- a/mm/pagewalk.c
>>>> +++ b/mm/pagewalk.c
>>>> @@ -606,10 +606,32 @@ int walk_page_range(struct mm_struct *mm, unsigned long start,
>>>>  int walk_kernel_page_table_range(unsigned long start, unsigned long end,
>>>>  		const struct mm_walk_ops *ops, pgd_t *pgd, void *private)
>>>>  {
>>>> -	struct mm_struct *mm = &init_mm;
>>>> +	/*
>>>> +	 * Kernel intermediate page tables are usually not freed, so the mmap
>>>> +	 * read lock is sufficient. But there are some exceptions.
>>>> +	 * E.g. memory hot-remove. In which case, the mmap lock is insufficient
>>>> +	 * to prevent the intermediate kernel pages tables belonging to the
>>>> +	 * specified address range from being freed. The caller should take
>>>> +	 * other actions to prevent this race.
>>>> +	 */
>>>> +	mmap_assert_locked(&init_mm);
>>>> +
>>>> +	return walk_kernel_page_table_range_lockless(start, end, ops, pgd,
>>>> +						     private);
>>>> +}
>>>> +
>>>> +/*
>>>> + * Use this function to walk the kernel page tables locklessly. It should be
>>>> + * guaranteed that the caller has exclusive access over the range they are
>>>> + * operating on - that there should be no concurrent access, for example,
>>>> + * changing permissions for vmalloc objects.
>>>> + */
>>>> +int walk_kernel_page_table_range_lockless(unsigned long start, unsigned long end,
>>>> +		const struct mm_walk_ops *ops, pgd_t *pgd, void *private)
>>>> +{
>>>>  	struct mm_walk walk = {
>>>>  		.ops		= ops,
>>>> -		.mm		= mm,
>>>> +		.mm		= &init_mm,
>>>>  		.pgd		= pgd,
>>>>  		.private	= private,
>>>>  		.no_vma		= true
>>>> @@ -620,16 +642,6 @@ int walk_kernel_page_table_range(unsigned long start, unsigned long end,
>>>>  	if (!check_ops_valid(ops))
>>>>  		return -EINVAL;
>>>>  
>>>> -	/*
>>>> -	 * Kernel intermediate page tables are usually not freed, so the mmap
>>>> -	 * read lock is sufficient. But there are some exceptions.
>>>> -	 * E.g. memory hot-remove. In which case, the mmap lock is insufficient
>>>> -	 * to prevent the intermediate kernel pages tables belonging to the
>>>> -	 * specified address range from being freed. The caller should take
>>>> -	 * other actions to prevent this race.
>>>> -	 */
>>>> -	mmap_assert_locked(mm);
>>>> -
>>>>  	return walk_pgd_range(start, end, &walk);
>>>>  }
>>>>  


