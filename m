Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02920C5CFC1
	for <linux-mm@archiver.kernel.org>; Fri, 14 Aug 2026 07:29:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D30F6B0638; Fri, 14 Aug 2026 03:29:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1843A6B0639; Fri, 14 Aug 2026 03:29:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09ABD6B063A; Fri, 14 Aug 2026 03:29:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DB7506B0638
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 03:29:19 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E072312026C
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 07:29:11 +0000 (UTC)
X-FDA: 85099048902.24.EA213DA
Received: from mta0.migadu.com (out-38.mta0.migadu.com [91.218.175.38])
	by imf03.hostedemail.com (Postfix) with ESMTP id CB16120002
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 07:29:09 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="qZfv5/ON";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.38 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786692550;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4bMfRB5+gnuvj7v3SU5G5JHv4v+t+64/b+hHPxVIHtk=;
	b=ZY1whWq6venMKxCp++eXqgnmXroJs46Q9j2qYLe9fkUl+NoEkqWQMinDPQbDX5UEJVyAh5
	YmgoaIb512EORq4TXNVtdweigx5CjB1o8iPxjFycUKROM0ysEue+OBXRGiGgv3dKGamuAC
	QHpuxM8wr2Wv2B09aDgL8exRAcia+gc=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="qZfv5/ON";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.38 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786692550;
	b=pQ0FqjxbiJa/JbhvB2ErS/Uyh9qjRhXwJkFQg43KMfh9p8OfzuanVQFPZ6Lcp70+U7dJfo
	3n0LQnLhB35fL4PnTQqIkHsEa+z0NTMT7W64IlIbOz9Ol80QXG/z8LdHMJBDcRTMgu6OsQ
	hG9vHSjSoyuxbLN8TSiRcJho2zQQ4D4=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=CUoyu6aX2EaLFf6CkIL9A6s2yLAOnA9F4p2InMLCBOo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786692548; v=1; x=1787297348;
 b=qZfv5/ONotx/yRIWGLcNwl2uH1gA6Mxplo6oQNGZDAhuUAgKnzYRhh8KFn5iLoOLLqCOSu6M
 TzDnWXGzMzzfz3x21I6EctAQEwoszF2+hftL/KleYSXznwW50e/UvK5pP8uXo9IOnWmDmsP8iQ3
 ktXDLIBzlRb0vtViHJNpqkFQ=
X-Envelope-To: linux-mm@kvack.org
Received: from [10.67.156.244] (114.251.196.87)
	by smtp.migadu.com with ESMTPS id 5bec0d8127702ed1;
	Fri, 14 Aug 2026 07:29:08 +0000
X-Migadu-Flow: FLOW_OUT
Message-ID: <5b13eb55-4e27-47e0-adef-ef4c2f46f4c8@linux.dev>
Date: Fri, 14 Aug 2026 15:29:03 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 08/17] mm/sparse-vmemmap: support section-based vmemmap
 optimization
From: Muchun Song <muchun.song@linux.dev>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Mike Rapoport <rppt@kernel.org>, Vlastimil Babka <vbabka@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>,
 David Laight <david.laight.linux@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>
References: <20260804035535.2846016-1-songmuchun@bytedance.com>
 <20260804035535.2846016-9-songmuchun@bytedance.com>
 <978060e0-a202-43b2-b84d-b1950b2d28c1@linux.dev>
Content-Language: en-US
In-Reply-To: <978060e0-a202-43b2-b84d-b1950b2d28c1@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: CB16120002
X-Rspamd-Server: rspam07
X-Stat-Signature: ux5g8jn4q1pkcn5typb5mnx1qb4dswnk
X-HE-Tag: 1786692549-174326
X-HE-Meta: U2FsdGVkX1/+nkXraIFI7IiE1yiOgUicgHh5959ezmLXhv4G+ddqI7DXYn2URfsKyWON9Yg7km75PbrZDT8Dps/qKCNaz2odYGJ20hXjGlbm2ttJPqq/Ln/8XkmbLhNC1XzArkN/MIykRXxHhHibSChW+0Ep25mrm+aCwBi7o13q5DaYLj+ExVa3wvJRGYTfyVTEQrU16ebzq0JbwyTAqFlING3rW5InDDWEa5bHIZugJhEu0Brl5eqxn1WIDDfqkfIrfxnJ8afeDWH9ueGhd2rhXibPpeQa9fsDRSjey7rZmfts/6ed98VW60Hzc9EpxkdQS34jTK8rGwIY+HMO8mHZfV1/c38ilrJVZdxRqbW+s5t0OD+6F5hcb1cnwhiztAU7FAMVm+1AZ1tjJqncsbVjBjlsGyp51cAYHx8au3rOIwSim+hgErjnW4DBb5U3kD2dTaIAK0HHb9h578cQTE9Tz/wegSub8NSah/KOBOIKKCYnmXvJIMPvxuuhqKOJoUqpXjofxtC7t5RBVanj3CfZTvfv/c95xr94GWGJ3793tpKnWDhvkd3jLfdMh9KYEImsuu0diG351SRHHPb5GZr9YzoPwzhZfIJDDZzU1j/SlccWqVnBMkIblIfigyse8Tvm7JeypE9aQMLSn0dV2h8jngYmCoAn6FKjiIS0scpgAD4jIW/cCsNrePxKvZQ23sJhwJU5Ujv10HAhSbtwgB5PZaOrUhWv3PSNYj+PhsN7uUAlE7xWZmphVzjFdymVAZrGwRKP+/XIKGXThToYidVE8KSntpOiY/EI3W9S1+BHbDncuwzA9Pm3DKrnMrwmJptWbGSB9uvVcf0nqqSgF72IO49S9atQCc2o9bNE6XYn8X4g1Qp9+cpRDa18S9MTFgfU2GhjqwIlWm1yRZS1V2iPRbVzY8LWy+V6fYnVGPsKUgccJZthjP4vxCtuUi3LOlAzgksVL7QuEKd2Z1o
 tGtaoPcW
 wsZ8B9CuADZU2Z7lCOymEFvkqswINKbW9BXe/5EHHbyyVb4LhJ23as7OK8QnEWD4aWFc8LaulvJYhK9UolHI95YIGuxkE8nfKZZF17i5Mib8mBA4XSQbEj4OoY3Swnkaw/2TMNDmclqYp/aWEDAXstuGlps1FgMvFqvzv+SPdudv2zSeorJaH6ES4M49MLoc/kba8oGPTnY7yyiHn8Up2nJupyBdBJs+ck8IgykPdK6lKpLHjdH3KGLP1pqu36rBqc0eqvE4DX00HgRh4QzK65pSd/GpIuT/0EtMfyATxUzf3tWfWoW0jlViLIQ9v/LusthCTRwQDPPrNs2FhISEcHZClTKnihbarFF3kLk4AhK2PafJolJE7Grn5Lzg2r/N7cJEhu+W3/K4rbTsJHrttBHWSjg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/8/6 11:04, Muchun Song wrote:
>
>
> On 2026/8/4 11:55, Muchun Song wrote:
>> Teach sparse-vmemmap population code to use the compound page order
>> when deciding whether a vmemmap page can be optimized.
>>
>> With this information, the common sparse-vmemmap population path can
>> allocate or reuse shared tail vmemmap pages directly instead of relying
>> on HugeTLB-specific handling.
>>
>> This centralizes vmemmap optimization logic in the sparse-vmemmap code,
>> based on section metadata, and prepares for sharing the same mechanism
>> across different users of vmemmap optimization, including HugeTLB and
>> DAX.
>>
>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>> ---
>> v2:
>> - Keep vmemmap accounting and population logic in sparse-vmemmap.c
>>    (suggested by Mike Rapoport)
>> - Move vmemmap_get_tail() before its first use instead of adding only a
>>    forward declaration in the previous patch (suggested by Mike 
>> Rapoport)
>> - Simplify the PMD path handling for HVO-covered sections
>> ---
>>   mm/sparse-vmemmap.c | 36 ++++++++++++++++++++++++++++++------
>>   mm/sparse.c         |  4 ++--
>>   mm/sparse.h         |  7 +++++++
>>   3 files changed, 39 insertions(+), 8 deletions(-)
>>
>> diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
>> index b770fe2428fd..b69a7af76858 100644
>> --- a/mm/sparse-vmemmap.c
>> +++ b/mm/sparse-vmemmap.c
>> @@ -186,6 +186,11 @@ static __meminit struct page 
>> *vmemmap_get_tail(unsigned int order, struct zone *
>>         return tail;
>>   }
>> +#else
>> +static inline struct page *vmemmap_get_tail(unsigned int order, 
>> struct zone *zone)
>> +{
>> +    return NULL;
>> +}
>>   #endif
>>     static pte_t * __meminit vmemmap_pte_populate(pmd_t *pmd, 
>> unsigned long addr, int node,
>> @@ -193,12 +198,24 @@ static pte_t * __meminit 
>> vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, in
>>                          unsigned long ptpfn, unsigned long flags)
>>   {
>>       pte_t *pte = pte_offset_kernel(pmd, addr);
>> +    unsigned long pfn = page_to_pfn((struct page *)addr);
>> +
>>       if (pte_none(ptep_get(pte))) {
>>           pte_t entry;
>> -        void *p;
>> +
>> +        if (pfn_vmemmap_optimizable(pfn) && ptpfn == (unsigned 
>> long)-1) {
>> +            unsigned int order = pfn_to_section_order(pfn);
>> +            struct zone *zone = pfn_to_zone(pfn, node);
>> +            struct page *page = vmemmap_get_tail(order, zone);
>> +
>> +            if (!page)
>> +                return NULL;
>> +            ptpfn = page_to_pfn(page);
>> +        }
>>             if (ptpfn == (unsigned long)-1) {
>> -            p = vmemmap_alloc_block_buf(PAGE_SIZE, node, altmap);
>> +            void *p = vmemmap_alloc_block_buf(PAGE_SIZE, node, altmap);
>> +
>>               if (!p)
>>                   return NULL;
>>               ptpfn = PHYS_PFN(__pa(p));
>> @@ -217,7 +234,8 @@ static pte_t * __meminit 
>> vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, in
>>           }
>>           entry = pfn_pte(ptpfn, PAGE_KERNEL);
>>           set_pte_at(&init_mm, addr, pte, entry);
>> -    }
>> +    } else if (WARN_ON_ONCE(pfn_vmemmap_optimizable(pfn)))
>> +        return NULL;
>>       return pte;
>>   }
>>   @@ -406,6 +424,9 @@ int __meminit 
>> vmemmap_populate_hugepages(unsigned long start, unsigned long end,
>>       pmd_t *pmd;
>>         for (addr = start; addr < end; addr = next) {
>> +        unsigned long pfn = page_to_pfn((struct page *)addr);
>> +        const struct mem_section *ms = __pfn_to_section(pfn);
>> +
>>           next = pmd_addr_end(addr, end);
>>             pgd = vmemmap_pgd_populate(addr, node);
>> @@ -421,7 +442,7 @@ int __meminit vmemmap_populate_hugepages(unsigned 
>> long start, unsigned long end,
>>               return -ENOMEM;
>>             pmd = pmd_offset(pud, addr);
>> -        if (pmd_none(pmdp_get(pmd))) {
>> +        if (pmd_none(pmdp_get(pmd)) && 
>> !section_vmemmap_optimizable(ms)) {
>>               void *p;
>>                 p = vmemmap_alloc_block_buf(PMD_SIZE, node, altmap);
>> @@ -439,8 +460,11 @@ int __meminit 
>> vmemmap_populate_hugepages(unsigned long start, unsigned long end,
>>                    */
>>                   return -ENOMEM;
>>               }
>> -        } else if (vmemmap_check_pmd(pmd, node, addr, next))
>> +        } else if (vmemmap_check_pmd(pmd, node, addr, next)) {
>> +            if (WARN_ON_ONCE(section_vmemmap_optimizable(ms)))
>> +                return -ENOTSUPP;
>>               continue;
>> +        }
>>           if (vmemmap_populate_basepages(addr, next, node, altmap))
>>               return -ENOMEM;
>>       }
>> @@ -648,7 +672,7 @@ void offline_mem_sections(unsigned long 
>> start_pfn, unsigned long end_pfn)
>>       }
>>   }
>>   -static int __meminit section_nr_vmemmap_pages(unsigned long pfn, 
>> unsigned long nr_pages,
>> +int __meminit section_nr_vmemmap_pages(unsigned long pfn, unsigned 
>> long nr_pages,
>
> The kernel test robot reported a compilation issue: when
> CONFIG_MEMORY_HOTPLUG = n && CONFIG_SPARSEMEM_VMEMMAP=y,
> section_nr_vmemmap_pages is undefined. This problem is easy to fix, and
> I will move the entire function outside the CONFIG_MEMORY_HOTPLUG guard
> in the next version. 

Hi,

I will wait a few more days to see if there are any reviews. If there is
no further input during this period, I will update a new version to resolve
this compilation issue.

Muchun,
Thanks

