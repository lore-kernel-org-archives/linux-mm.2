Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49F6DC5DF81
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 13:05:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 450C26B0095; Thu, 20 Aug 2026 09:05:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 401E86B009B; Thu, 20 Aug 2026 09:05:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F0D46B009D; Thu, 20 Aug 2026 09:05:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F36D46B0095
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 09:05:28 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7607A80137
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 13:05:28 +0000 (UTC)
X-FDA: 85121669136.27.E9E5BE0
Received: from mta1.migadu.com (out-32.mta1.migadu.com [95.215.58.32])
	by imf17.hostedemail.com (Postfix) with ESMTP id A6CF74000C
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 13:05:24 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=keBYfGDd;
	spf=pass (imf17.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.32 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787231126;
	b=VXUl12ziu5V0BnuPs2hAa2V3h7xGbBACwom/y+kvEcig/s94fx7KT2VvrG7dJnuJM+ssX5
	EqvUfu1uMrq/7apQ+rXwQ1NPzEbGNKc0QR5OapqovycM3qdnj+FskClGboFbVAIlwIFyBT
	ePcHc7UoiMG1WgMEEbA7+6QKrFIdV0c=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=keBYfGDd;
	spf=pass (imf17.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.32 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787231126;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WAkSZaSxnyCAKhvQ0SR1fp7aiGmnQ0ZVPE+PR7Y5/v8=;
	b=0GfLzsYJDV2oGIva/U1JE3vIg43oMrhr5yqnsNnPDz1f4wDpnmE4CsQ6/pJ0JmWGoGqxME
	0T2Zhm9qTsKTayc8qvFYfgDYClqD9iFJjRVOpcnnDdEIYeOLgAz2LEuXEnMjRDSFCMgubh
	h2Fjw2thsKCHvd5X+WXWIbBHuKi6Grw=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=bjfAF+DwUd5o4Ol8gxdF2GrPJxEj8ISy6MRdno5usoI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787231123; v=1; x=1787835923;
 b=keBYfGDdc9DdqB9j5aWEhNtwSZTf4wohgiMGnej9uaoUVkmpWNx1Y3kk8yabu3TIkMfpmDOu
 Lh6sII2e94UWoH2QFCyd0mYkJAoEWlLdc5CnGBhWGrPijh6hjCiP3djVyLzWRgx/3oovcoZP2F5
 qiHvR8D5Vt/rBpHMhSt62hgc=
X-Envelope-To: linux-mm@kvack.org
Received: from [IPV6:2a03:83e0:1126:4:9d:a05e:5bd8:c200] (2620:10d:c092:500::4:2d0d)
	by smtp.migadu.com with ESMTPS id 7a05402a501057d5;
	Thu, 20 Aug 2026 13:05:23 +0000
X-Mizu-Trace-ID: 7a05402a501057d5
X-Migadu-Flow: FLOW_OUT
Message-ID: <566e638c-9ebb-4f01-85ec-4f78516d748e@linux.dev>
Date: Thu, 20 Aug 2026 14:05:20 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/huge_memory: transfer the pmd dirty bit to the folio
 on zap
From: Usama Arif <usama.arif@linux.dev>
To: Lance Yang <lance.yang@linux.dev>, kas@kernel.org
Cc: hughd@google.com, akpm@linux-foundation.org, baohua@kernel.org,
 baolin.wang@linux.alibaba.com, david@kernel.org, dev.jain@arm.com,
 liam@infradead.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 ljs@kernel.org, nico.pache@linux.dev, ryan.roberts@arm.com, ziy@nvidia.com,
 nphamcs@gmail.com, hannes@cmpxchg.org, riel@surriel.com,
 shakeel.butt@linux.dev, kernel-team@meta.com, stable@vger.kernel.org
References: <aoWw_iKEDLjKL2jr@thinkstation>
 <20260819161728.70270-1-lance.yang@linux.dev>
 <1d0271fc-9f60-4b7f-8b89-e82a4f7034d5@linux.dev>
Content-Language: en-US
In-Reply-To: <1d0271fc-9f60-4b7f-8b89-e82a4f7034d5@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: A6CF74000C
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: 1n4xjgh9okeypkrr8fao7fwizd7xpftj
X-HE-Tag: 1787231124-768959
X-HE-Meta: U2FsdGVkX19VULSYUYzfyXzB+4VYETfH4HvZFONohEC7dDTpSQ/NK92cWAhYXBPCQdA0+s9NiWSkJZ08kvC3tERfmm7OdiIO9Hb4x/zCBlU81kuzXck7QZyhYVASPxb1PnmN8VgR+4IWGMvtfAesYSP3VyA38T0/71Nx1Qp6Sz0+ilbWN2ElZwOQJjld2s4dPwfKEzTSPK11eUG53qqtpvc77VzI97Pd/3wTmReGNg/XfBEZS1Z2suJo4jMnpCRF555dn1s0KwrWYhaB603sJpVhAQm9C5IBMrmFEQPTG2GBMhuOmk1w/Wx/WcgdWiWLJi6qqugTl1Gw/klwZpKQOGxpuj2S5uapYNkKpSe93vXkeqBDRR9UKKik87IIy8Ds+jESL32GXXe4S2tQ06DQeQ3mXZwAL86pKz1hH0x/biiV32hJvayiyzvX57dsEk4DokAE5J8GkehAEpkIlW43G3Lu5AuT4oraz6O7ejYIHjMGGFgcbG8oM/W9UBwr16tCOuGvS/x+JPz7UI9891tZc5tDSN7+xpFM6gzk5xA/ojXrUk/PM+DFassb94OwciNqZ5hgVvJgpge2+VWqhELhdWTdVVs8f5J9tqchmF16XKQIya/EaZ1syCef9HA61/MQQDdZpcuKIeBiaml7e8NKSIqj2FaFwd/IbDYxSL/bxUwHHWCVzGpdxWkVvDu0RtZ77U+jyPepf6dMl/W4ryrYi2BDvVjJJtbUiDxAOAHX+vF0BgoOioDjfxDXdQsnuGixM1iAiYhHo1PdSTr7V/udUtg4A7Gm78jhrn4fDAGp3cmg/PRSBnNI/IRz27tHeErRL8iA7bxMmA/f8c9A9Ez/p93ZaUPngcU/DPpkMVrnMfWKv+7iEPo9t5HPWTEbqAG5fn1UhM/y+zEP5ffNTGUr5atca3zjfo69W+0HMtt/m6Vhq5qnjuoZkjBuU7/cbOdG1HRp55gtS9H0cqBEn5U
 ywjfOwUg
 Hj49DP0yA4T6exz2yAxTWRyKMKljrPQMCEhYVpsI6IPzga5VDI/kZUEuYTk7sfSQ6HJGLTKRh7Gbl4YFaE7714JQsZI5CVD6nNLx4Ks1DwcNvwoQqfydipe1XyT8+4ASdlI7eMlllceCeQDA6xhkjC0CohfOH2/cTj+aJi9CpURFHJ0kK3LNRP6gh14NumudHX6VlnFe0TaV6FWvb6+eFlmt4Udn+U17dQ4j0ZMwqS42b/a6Sv4nEy7Fg3gd3h8PgsjbEgLbQwpmJUqrxzymd03OHjQ4EHVNuHK1xVZFPrWLSZg/jul6KCDUmDpMAGH7xmCCtmqKdw5goQIYrmnbo3qbIpXfoHkCBw2Om
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 19/08/2026 17:32, Usama Arif wrote:
> 
> 
> On 19/08/2026 17:17, Lance Yang wrote:
>>
>> On Wed, Aug 19, 2026 at 03:31:40PM +0100, Kiryl Shutsemau wrote:
>>> On Wed, Aug 19, 2026 at 03:12:22AM -0700, Usama Arif wrote:
>> [...]
>>>> ---
>>>>  mm/huge_memory.c | 2 ++
>>>>  1 file changed, 2 insertions(+)
>>>>
>>>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>>>> index ced400f72d43a..afbb5974bd225 100644
>>>> --- a/mm/huge_memory.c
>>>> +++ b/mm/huge_memory.c
>>>> @@ -2449,6 +2449,8 @@ static void zap_huge_pmd_folio(struct mm_struct *mm, struct vm_area_struct *vma,
>>>>  		add_mm_counter(mm, mm_counter_file(folio),
>>>>  			       -HPAGE_PMD_NR);
>>>>  
>>>> +		if (is_present && pmd_dirty(pmdval))
>>>> +			folio_mark_dirty(folio);
>>>
>>> Unrelated to your patch, but noticed while looking at it: we drop the rmap
>>> here under the pmd lock, while the TLB flush is deferred to
>>> tlb_finish_mmu(). The pte path handles this with
>>> tlb_delay_rmap()/force_flush (5df397dec7c4), but there's no pmd equivalent:
>>> tlb_flush_rmap_batch() only knows folio_remove_rmap_ptes(), and
>>> zap_huge_pmd() uses tlb_remove_page_size(), which takes no delay_rmap.
>>
>> Well spotted!
>>
>>> Doesn't matter for shmem, but xfs & friends do get PMD-order folios, and
>>
>> Right. pageout() cannot pass its refcount check while PMD mapping still
>> holds an extra folio ref, and mmu_gather drops that ref only after TLB
>> flush.
>>
>>> do_set_pmd() makes the pmd dirty+writable once page_mkwrite() has run. So
>>> folio_mkclean() can clean the folio while another CPU still stores through a
>>> stale TLB entry -- silently lost write, no PG_dirty left behind.
>>
>> Yep. Writeback can run folio_mkclean() while that ref is still held,
>> though, and with rmap already gone it misses the PMD ...
>>
>>> I think we need to fix this too.
>>
>> +1
>>
>>> Wanna give it a try?
>>
>> zap_huge_pmd() only handles one PMD under PTL anyway ... how about just
>> flushing before folio_remove_rmap_pmd()?
>>
>> ---8<---
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index afbb5974bd22..6fb34924ef66 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -2531,6 +2531,14 @@ bool zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
>>  	is_present = pmd_present(orig_pmd);
>>  	folio = normal_or_softleaf_folio_pmd(vma, addr, orig_pmd, is_present);
>>  	has_deposit = has_deposited_pgtable(vma, orig_pmd, folio);
>> +	/*
>> +	 * folio_mkclean() relies on the rmap to find writable mappings.
>> +	 * Flush stale TLB entries before removing it below.
>> +	 */
>> +	if (folio && is_present && !folio_test_anon(folio) &&
>> +	    pmd_dirty(orig_pmd))
>> +		tlb_flush_mmu_tlbonly(tlb);
>> +
>>  	if (folio)
>>  		zap_huge_pmd_folio(mm, vma, orig_pmd, folio, is_present);
>>  	if (has_deposit)
>> ---
> 

Hey Lance,

Just wanted to check, do you want to takeover fixing this? I got involved in
a couple of others things and might not be able to dedicate the time it deserves
in the next few days.

I think the main concern above is that tlb flush was being done in cases that was not
needed. The other thing is we dont batch flushing with either your or my change,
which is an important optimization to keep.

Thanks!
Usama

> 
> I am currently at below to reduce tlb flushes, but still WIP
> 
> 
> diff --git a/include/asm-generic/tlb.h b/include/asm-generic/tlb.h
> index bdcc2778ac64f..60bdd6287b5a9 100644
> --- a/include/asm-generic/tlb.h
> +++ b/include/asm-generic/tlb.h
> @@ -301,6 +301,12 @@ bool __tlb_remove_folio_pages(struct mmu_gather *tlb, struct page *page,
>   * function, except we define it before the 'struct mmu_gather'.
>   */
>  #define tlb_delay_rmap(tlb) (((tlb)->delayed_rmap = 1), true)
> +/*
> + * Like tlb_delay_rmap() but without the side effect, for callers that must
> + * flush rather than delay: can another CPU still reach this mapping through a
> + * stale TLB entry once its rmap entry is gone? Not during fullmm teardown.
> + */
> +#define tlb_rmap_needs_flush(tlb) (!(tlb)->fullmm)
>  extern void tlb_flush_rmaps(struct mmu_gather *tlb, struct vm_area_struct *vma);
>  #endif
> 
> @@ -315,6 +321,7 @@ extern void tlb_flush_rmaps(struct mmu_gather *tlb, struct vm_area_struct *vma);
>   */
>  #ifndef tlb_delay_rmap
>  #define tlb_delay_rmap(tlb) (false)
> +#define tlb_rmap_needs_flush(tlb) (false)
>  static inline void tlb_flush_rmaps(struct mmu_gather *tlb, struct vm_area_struct *vma) { }
>  #endif
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index afbb5974bd225..76d8d5cf92ee0 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -2493,6 +2493,33 @@ static bool has_deposited_pgtable(struct vm_area_struct *vma, pmd_t pmdval,
>         return folio && folio_test_anon(folio);
>  }
> 
> 
> +static bool pmd_zap_needs_tlb_flush(struct mmu_gather *tlb, pmd_t pmdval,
> +                                   struct folio *folio, bool is_present)
> +{
> +       struct address_space *mapping;
> +
> +       if (!is_present || !pmd_dirty(pmdval) || folio_test_anon(folio))
> +               return false;
> +       if (!tlb_rmap_needs_flush(tlb))
> +               return false;
> +
> +       mapping = folio_mapping(folio);
> +       return mapping && mapping_can_writeback(mapping);
> +}
> +
>  /**
>   * zap_huge_pmd - Zap a huge THP which is of PMD size.
>   * @tlb: The MMU gather TLB state associated with the operation.
> @@ -2531,8 +2558,15 @@ bool zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
>         is_present = pmd_present(orig_pmd);
>         folio = normal_or_softleaf_folio_pmd(vma, addr, orig_pmd, is_present);
>         has_deposit = has_deposited_pgtable(vma, orig_pmd, folio);
> -       if (folio)
> +       if (folio) {
> +               /* Flush before zap_huge_pmd_folio() drops the rmap entry. */
> +               if (pmd_zap_needs_tlb_flush(tlb, orig_pmd, folio, is_present)) {
> +                       tlb_flush_mmu_tlbonly(tlb);
> +                       /* Re-arm: tlb_remove_page_size() needs tlb->end set. */
> +                       tlb_remove_pmd_tlb_entry(tlb, pmd, addr);
> +               }
>                 zap_huge_pmd_folio(mm, vma, orig_pmd, folio, is_present);
> +       }
>         if (has_deposit)
>                 zap_deposited_table(mm, pmd);
> 
>>
>> Cheers, Lance
>>
>>>
>>>>  		if (is_present && pmd_young(pmdval) &&
>>>>  		    likely(vma_has_recency(vma)))
>>>>  			folio_mark_accessed(folio);
>>>> -- 
>>>> 2.53.0-Meta
>>>>
>>>
>>> -- 
>>>  Kiryl Shutsemau / Kirill A. Shutemov
>>>
> 


