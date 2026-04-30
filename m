Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64544FF886F
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 06:47:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F3F36B0088; Thu, 30 Apr 2026 02:47:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A4826B008A; Thu, 30 Apr 2026 02:47:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B9D86B008C; Thu, 30 Apr 2026 02:47:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4BD8C6B0088
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 02:47:27 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E7F01140401
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 06:47:26 +0000 (UTC)
X-FDA: 84714290892.13.03DF4CB
Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	by imf18.hostedemail.com (Postfix) with ESMTP id D14A31C0005
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 06:47:24 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YEKGo+al;
	spf=pass (imf18.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777531645;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fFYELBEUS3uPsTbb7PVX2xjkT/NGP+Q0yACp8mSnVi4=;
	b=m8l2Q6dlgh7V/bY94dibzS0qanDEhWKCTymCOsD2LsaR670SmMa2gG5KSuNT7d86vk2s5+
	X52eLOEAQmPWUDaofJJjR5TOV/pDbmmejbTgw2Jd84YJgfg8YRG0v6ZK8CTntbcTtxfEUi
	8sRyZMpl4Ae+/EhO7rowGBeSFE9Osa4=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YEKGo+al;
	spf=pass (imf18.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777531645; a=rsa-sha256;
	cv=none;
	b=P9eiW0ePsyhfLK8rAcZQ4S+3jS7mfhB04tL+4pOFmUH0Htc/XUQ4om34tUf4RtnK4kSGC5
	HeDSSGwlijZVeTISC4Vh1tNMybyodugopFPxY1KMCIVuUaJesYbfbZvhsGpzvc9InuDZQi
	c2tAzGreCRbkfBKTRMeFBdtPXLUdEC0=
Message-ID: <d6ff6b1f-8247-4265-b998-bd99283685ef@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777531642;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fFYELBEUS3uPsTbb7PVX2xjkT/NGP+Q0yACp8mSnVi4=;
	b=YEKGo+al8lqEhUvs4ZLCLYudOJIpPmmA2MtEHDom5QlHbCuz+V+rQndEcVgyp83Ec7QalR
	8UF7fZmmNkL1GSot1qMsUEOgCR+mOpuofjeAi6h4hx695hvmORWsPI9mBR4vveX+Z1xH7/
	EX12JsfhwO2ADyHDMr1Pmie9B/2xR5g=
Date: Thu, 30 Apr 2026 14:46:43 +0800
MIME-Version: 1.0
Subject: Re: [PATCH hotfix] mm: fix pmd_special() fallback to observe
 huge_zero
To: "David Hildenbrand (Arm)" <david@kernel.org>, hughd@google.com
Cc: akpm@linux-foundation.org, baolin.wang@linux.alibaba.com,
 baohua@kernel.org, dev.jain@arm.com, liam.howlett@oracle.com,
 ljs@kernel.org, mhocko@suse.com, rppt@kernel.org, npache@redhat.com,
 zhengqi.arch@bytedance.com, ryan.roberts@arm.com, surenb@google.com,
 ziy@nvidia.com, linux-mm@kvack.org
References: <e7cbc92b-ce9d-432a-ae5b-c8715dcd922f@kernel.org>
 <20260429065743.67054-1-lance.yang@linux.dev>
 <ea1453a6-14c9-4334-ac7e-2758586393b2@kernel.org>
 <aa3937bb-7f06-4136-ba36-ce4a06acf80a@linux.dev>
 <4d950326-6944-409b-b108-a4e67256857f@kernel.org>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <4d950326-6944-409b-b108-a4e67256857f@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D14A31C0005
X-Rspam-User: 
X-Stat-Signature: kqz6tfud8u3e6pbz3ufzbad79yhm6zrr
X-HE-Tag: 1777531644-547832
X-HE-Meta: U2FsdGVkX1/22SI7s3x2ZCw6OroOVHuZ4392OFi8lu8EleY/4ttFC39L6QrsvArKSt1hTQ7lmjhUZctTpOrRGX2vF9GjyFlpZA77lIL+TwUKqjYhwRnz8tAoGAKKjTI+wcsXIr4/eWt9zHZo0+rBXR5NlKVKoHG8IFhmtLS75eTZ/SnI5OmJ5PqLTo4t2U4GMHIkY5/UJ1x9Lfj4A2dk36nL0irEbZEZkd++7P2HGlcvzAJJU336qH//IM+rPHMi58L21oyOhsOj9NW6Z4xppXpMwheZnUz+tctaLE62qd5dhHoRnG4ZInhpSrGifrAiUNi8xWRYCJNfdRPhaxjVrkePnZot4pbYvy/kx7MCa2kt+rvnx+e5qKJEsIN5bbVY99ptPrFIVTKqtlcP/+pCZPuFe2oK6m20ON6MLiBTVo29JmIOkpxMiteYFPW24XP3b+2vZ9AYz6wu9ZtlaWg3pQ4iqdbO+B29Zz6ZjwcAPmLj2ay8/aTmlbP4PZkhvCi4obRtW35N40iD0FCezn7s307oxQeppFrqrl0DQCza045hRT7g/1GhNGARsbqYsKWADrLOb00/kA169BTLrtM4dqJcnYCBpRXuTpqUrRWKiscj+B7zSr77e/rNOsJ+v+30UjK8tfePqzLA7uurYwQbMg1WqoCfXpqZsvqqFVmVlXVtmdBKKUWccekyc8q89OX/r9FMlxGb2nLY+HqbgzlSvkkbhzLgNdkHrxLK243zW81tJSoDOFdAJH1+F67Nx05YNNpgHv3kYVtb6Qw5AR9GQzAP/FwAwtC5mn94j0TS8UvHzUXIOhqledrZg4IAaim1OO+4EGI+3/GSygQNYpsnf/IdofYdoDg7BtD+QRQqtuWL8vAzSzmHNNk1lZGrnf5eFLPWGjCJU21KOGPbS/RIxkZjJd6b5CwfRdWtTSalah3lv25R+aO1R0eLuSYv4o7LVjsA0LqptFFl+QsKWVU
 KVkfs6AW
 xdq/DOlnSbWzd5cQZNkLvl7bhEL/xA2Dyh0Fx7ED+EL6JBzr4yu7dfEYdbeU0KgQ7SJ/dBE/kDf3yePEtXSUuD1Knz4O8ZMSvM0dWt2yYQGDZ2xuea2yJY/nxrVGfbqqUaL+x/fFGvFthSbR47H52AuhEF5V9pOjkl6c3NdCeJmHCS74WPYhubeKXS//u2aYAbo2EBV5XPYQlCP9IQyt3KKnasmWFwQ4wNfiF+BUeJSnfFIMoR9KQwUIjKIwvDAv7AbFoAAv+jTOEH7aBKXO9YaXeqUPaKFksvyQJrN3GEiea4uDvqoI2R21kOW+h2oU8CZ7VF5b/dToxkOw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/4/30 13:53, David Hildenbrand (Arm) wrote:
> On 4/29/26 09:33, Lance Yang wrote:
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
>>>>      2025-09-13 d82d09e48219 ("mm/huge_memory: mark PMD mappings of the huge
>>>> zero folio special")
>>>>      2025-09-13 af38538801c6 ("mm/memory: factor out common code from
>>>> vm_normal_page_*()")
>>>>
>>>> After d82d09e48219, vm_normal_page_pmd() still had the explicit huge
>>>> zero check before returning the page:
>>>>
>>>> --8<---
>>>> struct page *vm_normal_page_pmd(struct vm_area_struct *vma, unsigned long addr,
>>>>                  pmd_t pmd)
>>>> {
>>>>      unsigned long pfn = pmd_pfn(pmd);
>>>>
>>>>      if (unlikely(pmd_special(pmd)))
>>>>          return NULL;
>>>>
>>>>      if (unlikely(vma->vm_flags & (VM_PFNMAP|VM_MIXEDMAP))) {
>>>>          if (vma->vm_flags & VM_MIXEDMAP) {
>>>>              if (!pfn_valid(pfn))
>>>>                  return NULL;
>>>>              goto out;
>>>>          } else {
>>>>              unsigned long off;
>>>>              off = (addr - vma->vm_start) >> PAGE_SHIFT;
>>>>              if (pfn == vma->vm_pgoff + off)
>>>>                  return NULL;
>>>>              if (!is_cow_mapping(vma->vm_flags))
>>>>                  return NULL;
>>>>          }
>>>>      }
>>>>
>>>>      if (is_huge_zero_pfn(pfn))
>>>>          return NULL;
>>>>      if (unlikely(pfn > highest_memmap_pfn))
>>>>          return NULL;
>>>>
>>>>      /*
>>>>       * NOTE! We still have PageReserved() pages in the page tables.
>>>>       * eg. VDSO mappings can cause them to exist.
>>>>       */
>>>> out:
>>>>      return pfn_to_page(pfn);
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
>>>>                  pmd_t pmd)
>>>> {
>>>>      return __vm_normal_page(vma, addr, pmd_pfn(pmd), pmd_special(pmd),
>>>>                  pmd_val(pmd), PGTABLE_LEVEL_PMD);
>>>> }
>>>> ---
>>>>
>>>> For CONFIG_ARCH_HAS_PTE_SPECIAL=y, __vm_normal_page() only returns NULL
>>>> for the huge zero PFN if special == true. On x86 32-bit, pmd_special()
>>>> stays false, so this can now fall through to VM_WARN_ON_ONCE():
>>>>
>>>> ---8<---
>>>>      if (IS_ENABLED(CONFIG_ARCH_HAS_PTE_SPECIAL)) {
>>>>          if (unlikely(special)) {
>>>>              if (is_zero_pfn(pfn) || is_huge_zero_pfn(pfn))
>>>>                  return NULL;
>>>> ...
>>>>          }
>>>> ...
>>>>      } else {
>>>> ...
>>>>          if (is_zero_pfn(pfn) || is_huge_zero_pfn(pfn))
>>>>              return NULL;
>>>>      }
>>>>
>>>> ...
>>>>      VM_WARN_ON_ONCE(is_zero_pfn(pfn) || is_huge_zero_pfn(pfn));
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
> Okay, I'd say we do the following:
> 
>  From fd9ead548f102f7c257980ccc7b96cce7e42a570 Mon Sep 17 00:00:00 2001
> From: Hugh Dickins <hughd@google.com>
> Date: Thu, 30 Apr 2026 07:35:31 +0200
> Subject: [PATCH] mm: fix pmd_special() fallback to observe huge_zero
> 
> On x86 32-bit with THP enabled, zap_huge_pmd() is seen to generate a
> "WARNING: mm/memory.c:735 at __vm_normal_page+0x6a/0x7d", from the
> VM_WARN_ON_ONCE(is_zero_pfn(pfn) || is_huge_zero_pfn(pfn)); followed
> by "BUG: Bad rss-counter state"s, then later "BUG: Bad page state"s
> when reclaim gets to call shrink_huge_zero_folio_scan().
> 
> It's as if the _PAGE_SPECIAL bit never got set in the huge_zero pmd:
> and indeed, whereas pte_special() and pte_mkspecial() are subject to a
> dedicated CONFIG_ARCH_HAS_PTE_SPECIAL, pmd_special() and pmd_mkspecial()
> are subject to CONFIG_ARCH_SUPPORTS_PMD_PFNMAP, which is never enabled
> on any 32-bit architecture.
> 
> While the problem was exposed through d80a9cb1a64a ("mm/huge_memory: add
> and use normal_or_softleaf_folio_pmd()"), it was an oversight in
> af38538801c6 ("mm/memory: factor out common code from vm_normal_page_*()")
> and would result in other problems:
> * huge zero folio accounted in smaps, pagemap (PAGE_IS_FILE) and
>    numamaps as file-backed THP
> * folio_walk_start() returning the folio even without FW_ZEROPAGE set.
>    Callers seem to tolerate that, though.
> 
> ... and triggering the VM_WARN_ON_ONE(), although never reported so far.
> 
> To fix it, teach vm_normal_page_pmd()/vm_normal_page_pud() whether
> pmd_special/pud_special is actually implemented.
> 
> Fixes: af38538801c6 ("mm/memory: factor out common code from vm_normal_page_*()")
> Signed-off-by: Hugh Dickins <hughd@google.com>>
> Co-developed-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---

Thanks, LGTM! Feel free to add:

Reviewed-by: Lance Yang <lance.yang@linux.dev>

Cheers, Lance

>   mm/memory.c | 17 ++++++++++++++++-
>   1 file changed, 16 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/memory.c b/mm/memory.c
> index 7322a40e73b9..a60bc07b48b2 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -612,6 +612,21 @@ static void print_bad_page_map(struct vm_area_struct *vma,
>   	dump_stack();
>   	add_taint(TAINT_BAD_PAGE, LOCKDEP_NOW_UNRELIABLE);
>   }
> +
> +static inline bool pgtable_level_has_pxx_special(enum pgtable_level level)
> +{
> +	switch (level) {
> +	case PGTABLE_LEVEL_PTE:
> +		return IS_ENABLED(CONFIG_ARCH_HAS_PTE_SPECIAL);
> +	case PGTABLE_LEVEL_PMD:
> +		return IS_ENABLED(CONFIG_ARCH_SUPPORTS_PMD_PFNMAP);
> +	case PGTABLE_LEVEL_PUD:
> +		return IS_ENABLED(CONFIG_ARCH_SUPPORTS_PUD_PFNMAP);
> +	default:
> +		return false;
> +	}
> +}
> +
>   #define print_bad_pte(vma, addr, pte, page) \
>   	print_bad_page_map(vma, addr, pte_val(pte), page, PGTABLE_LEVEL_PTE)
>   
> @@ -684,7 +699,7 @@ static inline struct page *__vm_normal_page(struct vm_area_struct *vma,
>   		unsigned long addr, unsigned long pfn, bool special,
>   		unsigned long long entry, enum pgtable_level level)
>   {
> -	if (IS_ENABLED(CONFIG_ARCH_HAS_PTE_SPECIAL)) {
> +	if (pgtable_level_has_pxx_special(level)) {
>   		if (unlikely(special)) {
>   #ifdef CONFIG_FIND_NORMAL_PAGE
>   			if (vma->vm_ops && vma->vm_ops->find_normal_page)


