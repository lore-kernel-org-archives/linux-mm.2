Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB3B8CAC587
	for <linux-mm@archiver.kernel.org>; Sat, 13 Sep 2025 04:13:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 13C5A8E0005; Sat, 13 Sep 2025 00:13:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 113FD8E0001; Sat, 13 Sep 2025 00:13:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 050E78E0005; Sat, 13 Sep 2025 00:13:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E88D58E0001
	for <linux-mm@kvack.org>; Sat, 13 Sep 2025 00:13:47 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 83A4E1A0A2B
	for <linux-mm@kvack.org>; Sat, 13 Sep 2025 04:13:47 +0000 (UTC)
X-FDA: 83882908494.09.F66125F
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	by imf19.hostedemail.com (Postfix) with ESMTP id 9A4C11A0005
	for <linux-mm@kvack.org>; Sat, 13 Sep 2025 04:13:43 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=none;
	spf=pass (imf19.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 45.249.212.187 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757736825;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=K5u2GS7vsAOSZ5yshlHoZ1AbFGgkSFsUNwNS7dJtLeg=;
	b=ZfFcqZRQBvVOSvh0PpvVFEXKnmZSCMSTcPiWaFyvA4dMlbbBPh43VSWCo4beW58ikqjiKS
	eihs8PYzHuFEjWxKsi8Qu3g3elvLp5KcPDWi/p8hLPy19gNwLF80+OSP9WG86IqD54x6oU
	pwK6D80QFmz/11gdGhUFkDLL5ll437M=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	spf=pass (imf19.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 45.249.212.187 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757736825; a=rsa-sha256;
	cv=none;
	b=CV1K+lvuhrJrJwoihPpiJO0HCJwfHz8nDSh84RyyPYGtH7L1kcB4Hw3+ytQrRT2+8VH+SY
	qzXHYKsQY4JdzGOGsm+6WewzY/iDXcSkspRUOLnAHc+zWQ13XuuvqHbX0HjrLIL5WKK37M
	4MP9rykteq8rFzpoFeJYj8DEDanVEzU=
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4cNyZr3c95z14Mn3;
	Sat, 13 Sep 2025 12:13:24 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 0615618006C;
	Sat, 13 Sep 2025 12:13:39 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 13 Sep 2025 12:13:37 +0800
Message-ID: <39ea6d31-ec9c-4053-a875-8e86a8676a62@huawei.com>
Date: Sat, 13 Sep 2025 12:13:36 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/4] mm: hugetlb: allocate frozen pages in
 alloc_gigantic_folio()
To: David Hildenbrand <david@redhat.com>, Andrew Morton
	<akpm@linux-foundation.org>, Oscar Salvador <osalvador@suse.de>, Muchun Song
	<muchun.song@linux.dev>, Zi Yan <ziy@nvidia.com>, Matthew Wilcox
	<willy@infradead.org>
CC: <sidhartha.kumar@oracle.com>, <jane.chu@oracle.com>, Vlastimil Babka
	<vbabka@suse.cz>, Brendan Jackman <jackmanb@google.com>, Johannes Weiner
	<hannes@cmpxchg.org>, <linux-mm@kvack.org>
References: <20250911065659.617954-1-wangkefeng.wang@huawei.com>
 <20250911065659.617954-5-wangkefeng.wang@huawei.com>
 <90e926c9-40cb-4791-8360-e3d145fe3503@redhat.com>
 <8508e8fb-77cc-43a7-8460-456f68a552ba@huawei.com>
 <667133bd-0021-4d4e-9cde-fc8c1324522a@redhat.com>
 <d63e7e02-b2ab-46fb-b981-ad4f4f28d634@huawei.com>
 <3a842ae3-f13a-4f5d-8870-d81cf1f0d56d@redhat.com>
 <1da42002-9dad-45a7-98f8-90a97801002d@redhat.com>
 <8a524eda-c3fe-4e28-a24b-4050484e472f@huawei.com>
 <5ede233c-c8c6-4067-afb3-df94b4222cda@redhat.com>
Content-Language: en-US
From: Kefeng Wang <wangkefeng.wang@huawei.com>
In-Reply-To: <5ede233c-c8c6-4067-afb3-df94b4222cda@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.243]
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9A4C11A0005
X-Stat-Signature: zdk69ccd3uayg3yc5ptjaik8nrfhmxsb
X-HE-Tag: 1757736823-44818
X-HE-Meta: U2FsdGVkX1/JmXAkyp08Wu2O6chsDyuv2dXx9lRHVDfvLH0iuGmYR9z4ltJ0B+og9d8zYHZfHCybBzziMSnc6POw/UpnVp8/FD8/eCU0NpPdHzuhizipD7QxwK2Vi1AU12UB+iAdTIQ1+gj+L3uJDszjYkrBjZ70cg9MLA+3NwBnCKg0hrXreaI/nl3I9/YbeQD18Xxxll9ufZgHpeRyx0Lip3NnviA5fAe/T+fr1Ru9W0wG0I/Uq8RrV7Ym0lZXD1MdUPvfUq/ztT7YbI40KIMed7v+/kjghSvoUWYvRGMIvM8GujKW+14ce7i1Kw+demPrKyu6y7Spfqkl+vbvi+9GLGy1aMv2nMoKCx3NImsb1zuz5L8b5dhfAq+/5+5j6GymdCzgMDN4HISE4VbvvnaZFjtRTf7SJawG209Rf5AiMTKA+KPSJxOkLPqM6jkJgS03BPGcox0o4Da5/3cGfZ16+f8P4zccXlxeP//qlMTT6rjr3wZLa8Nu3cAAbsdjk/aCudMjbJpDrblsj4Vbdu2Bf9vWV1rpHZ8QhsNvGCPZTZ5guhVHmh+8KsMuJu1rMXm92+JmxMZDH4quYEH8Mtbx8haBHQAT2EL09o84opbxkfjB0Jj326HGWoAYFbpg2MdteCQvlPjzjxm21/yrYCTDIJpv9zXKzqmTEHO1SjcIxH5JBIeJVkMLLpaWy8tcaSbpLlQZh1wfgK9uy3WrcwVN38IkDKh5ENu8kB6keTGpfkR1RK6mMnMcqS4k+MKqjcT1XsTAzuUZ1KzFA1d/2BHyFKOgHuKE8CfjNOhr4OomG8M0P+q0NqWpk8+RUcqOwvZzSmo39kpxNq2s9kFoWt/seZhm4VMV+arZap1lvPuHC0FIozLsaop1YwkdRL3Fjsmxtqwclai+xiBLBi6roYRXF8heqGI7biWb8FJX3dvPUepdSxdr70356izHIsItf3yCW1QCsVJkWRC/RzU
 ROFZK7I4
 /MpmhLwFTnbuUMGZm4KlmBg4Emppd1tlULRfual6SJooeONBanO7tRcYK3OAxhdDrA3GFTWsBt+iruEqVO72sFdCk5HOiQxkDE7QrLwCQuSlhX68ix28PDXyGFi57ehh5suOZlmS8HhOhl7RhaJPvCmQ2PAIwWeUmROQ0p43y4rvtQNT/PXDxCtHvVHO9GBZStpiViky/NqTY+VDw4v4d9YhYjMcGVUkK7NJA8bChTAn7R1nGXOGuC+GnVeAW4m1pDjn0g6MgagHdaY8WGJFhTS/Y2u/3XegpYOwu
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/9/13 2:07, David Hildenbrand wrote:
> 
>>>>
>>>> Would be interesting trying to see how much overhead would remain when
>>>> just dealing
>>
>> Patch2 skip atomic update in split_page() with 
>> alloc_contig_frozen_pages(),
>> I could test performance about old alloc_contig_pages() with/without
>> GFP_COMP and new alloc_contig_frozen_pages() when allocate same size.
> 
> Yes, that would be very interesting.


TEST1： alloc_contig_frozen_pages（split without atomic） + GFP_KERNEL
TEST2： alloc_contig_pages（split with atomic） + GFP_KERNEL
TEST3： alloc_contig_frozen_pages（split without atomic） + 
GFP_KERNEL|__GFP_COMP
TEST4： alloc_contig_pages（split with atomic） + GFP_KERNEL|__GFP_COMP

Alloc/free 10 * 1G, the result shows as usec

        TEST1  TEST2   TEST3   TEST4
alloc
       301024  296947  286681  288125
       297099  297194  286810  289906
       297134  300445  289950  288393
				
free				
       215014  215332  16730   16613
       214730  214948  16516   16588
       215727  214945  16589   16507

The perf profile show below,

split_free_frozen_pages()'s proportion is lower than split_free_pages，
but the total time is not reduced.

TEST1 alloc:
- sysctl_test_sysctl_handler.part.0
    - 96.92% alloc_contig_frozen_pages_noprof
       - 82.69% pfn_range_valid_contig
            pfn_to_online_page
       - 13.97% alloc_contig_range_frozen_noprof
            4.39% replace_free_hugepage_folios
          - 4.34% split_free_frozen_pages
               __list_add_valid_or_report
          - 3.22% undo_isolate_page_range
             - 3.04% unset_migratetype_isolate
                - __move_freepages_block_isolate
                     2.96% __move_freepages_block
          - 0.86% __drain_all_pages
               drain_pages_zone
               free_pcppages_bulk
          - 0.59% start_isolate_page_range
             - 0.51% set_migratetype_isolate
                  __move_freepages_block_isolate

TEST2 alloc:
  - sysctl_test_sysctl_handler.part.0
    - 99.82% alloc_contig_pages_old_noprof
       - 81.59% pfn_range_valid_contig
            pfn_to_online_page
       - 18.16% alloc_contig_range_old_noprof.constprop.0
          - 8.10% split_free_pages
               4.72% __split_page
               1.38% __list_add_valid_or_report
            5.83% replace_free_hugepage_folios
          - 3.07% undo_isolate_page_range
             - 3.01% unset_migratetype_isolate
                - __move_freepages_block_isolate
                     2.88% __move_freepages_block

TEST3 alloc:
- sysctl_test_sysctl_handler.part.0
    - 99.85% alloc_contig_frozen_pages_noprof
       - 86.04% pfn_range_valid_contig
            pfn_to_online_page
       - 13.52% alloc_contig_range_frozen_noprof
            4.23% replace_free_hugepage_folios
          - 3.99% prep_new_page
               prep_compound_page
          - 3.86% undo_isolate_page_range
             - 3.43% unset_migratetype_isolate
                - __move_freepages_block_isolate
                     3.35% __move_freepages_block
            0.54% __alloc_contig_migrate_range 



> 
>>
>>>>
>>>> OTOH, maybe we can leave GFP_COMPOUND support in but make the function
>>>> more generic, not limited to folios (I suspect many users will not want
>>>> folios, except hugetlb).
>>>>
>>
>> Maybe just only add cma_alloc_frozen(), and
>> cma_alloc()/hugetlb_cma_alloc_folio()
>> is the wrapper that calls it and set page refcount, like what we did in
>> other frozen allocation.
>>
>> struct page *cma_alloc_frozen(struct cma *cma, unsigned long count,
>>                 unsigned int align, gfp_t gfp);
> 
> I think it's weird that cma_alloc_frozen() consumes gfp_t when 
> cma_alloc() doesn't. So I would wish that we can clean that up (-> 
> remove gfp if possible).
> 
> So maybe we really want a
> 
> cma_alloc_frozen
> 
> and
> 
> cma_alloc_frozen_compound
> 
> whereby the latter consumes an "order" instead of "count + align".
> 
>>
>>>> Maybe just a
>>>>
>>>> struct page * cma_alloc_compound(struct cma *cma, unsigned int order,
>>>> unsigned int align, bool no_warn);
>>>
>>> ^ no need for the align as I realized, just like
>>> cma_alloc_folio() doesn't have.
>>
>> since cma_alloc_frozen is more generic, we need keep align,
>>
>>>
>>> I do wonder why we decided to allow cma_alloc_folio() to consume gfp_t
>>> flags when we don't do the same for cma_alloc().
>>>
>>
>> cma_alloc_folio() now is called by hugetlb allocation, the gfp could be
>> htlb_alloc_mask(), with/without __GFP_THISNODE/__GFP_RETRY_MAYFAIL...
>> and this could be used in alloc_contig_frozen_pages(),(eg,
>> gfp_zone).
> 
> Take a look at alloc_contig_range_noprof() where I added
> 
>      __alloc_contig_verify_gfp_mask()
> 
> Essentially, we ignore
> 
>      GFP_ZONEMASK | __GFP_RECLAIMABLE | __GFP_WRITE | __GFP_HARDWALL
>         | __GFP_THISNODE | __GFP_MOVABLE
> 
> And we *always* set __GFP_RETRY_MAYFAIL
> 
> I'd argue that hugetlb passing in random parameters that don't really 
> make sense for contig allcoations is rather an issue and makes you 
> believe that they would have any effect.
> 
> If cma_alloc doesn't provide them a cma_alloc_frozen or cma_alloc_folio 
> shouldn't provide them.

Oh, I make a mistake, the cma_alloc_folio calls  alloc_contig_range
(not alloc_contig_pages) to  alloc page from special cma ranges, and
__GFP_THISNODE only needed by hugetlb_cma_alloc_folio(), so the gfp
flags is not useful for cma_alloc_frozen or cma_alloc_folio, let's
remove it.



> 
>>
>> For cma_alloc() unconditional use GFP_KERNEL from commit
>> 6518202970c1 "mm/cma: remove unsupported gfp_mask parameter from
>> cma_alloc()", but this is another story.
>>
>> Back to this patchset, just add a new cma_alloc_frozen() shown
>> above and directly call it in cma_alloc()/hugetlb_cma_alloc_folio(),
>> get rid of folio_alloc_frozen_gigantic() and cma_alloc_folio(), and
>> we could do more optimization in the next step.
> 
> Yeah, that's probably a good first step, but while at it I would hope we 
> could just cleanup the gfp stuff and provide a more consistent interface.
> 

So
struct page *cma_alloc_frozen(struct cma *cma, unsigned long count, 
unsigned int align, bool no_warn) in include/linux/cma.h

and
struct page *cma_alloc_frozen_compound(struct cma *cma, unsigned int 
order) in mm/internal.h since maybe only hugetlb use it.

or keep cma_alloc_folio() but remove gfp,
struct folio *cma_alloc_folio(struct cma *cma, int order, gfp_t gfp)

Any comments?

Thanks.






