Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3729C5DF97
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 03:24:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 819006B0088; Tue, 25 Aug 2026 23:24:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F04A6B008A; Tue, 25 Aug 2026 23:24:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6DEFF6B008C; Tue, 25 Aug 2026 23:24:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3AFC86B0088
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 23:24:34 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BC20FA0233
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 03:24:33 +0000 (UTC)
X-FDA: 85141978026.10.7294419
Received: from mta0.migadu.com (out-250.mta0.migadu.com [91.218.175.250])
	by imf17.hostedemail.com (Postfix) with ESMTP id 820B840003
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 03:24:31 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ARh8fbgu;
	spf=pass (imf17.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.250 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787714671;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9ytlF+PA2dkAhDRIspuBkU+nb+TzX0lKIezhge+FdJM=;
	b=JxGecZYfaSS2DR5FxCzWirVf2PjHSf1jwaM1Q12Fc5MNO0J6MCbyyQo/a6LL0OgCqRDnrb
	FOjNUhYbwxGNL12mDPaLl9rCNG06w7M94Wj/aS7LGn7nR+JrHtF8pZ3HA7o4osSr4i7vbr
	oguckiRLNb8sY6fboECTa3x7+2uQVoM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787714671;
	b=DyFJR5L9BLKU6WdqHxynab6BN2eIZSwC3X33JUnsVuKQLwZ3rMJIdIRbNBJItGUe18ockJ
	wU8uNPpVyoEpQ8+HujNdADPg3dgB17P4dd17I8TxMdg54VzrsXwKsUC8FIS/zrTj5kUuLo
	Pdg6RRw91JEnrdxumrh30Pdk1qTcurU=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ARh8fbgu;
	spf=pass (imf17.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.250 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=ilcBa0x2PBxT31raRJ9YJHGQoebktmijIA8hcg3h/7I=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787714670; v=1; x=1788319470;
 b=ARh8fbgukkjUJVZLhmXVQMkO36lyF+y+3XnA+NPY+lVoJvcY7/1NacqB2wd4dJSQSfREehLr
 iD0wBlwv3Ir8bZBKXnTjJouCCl5ZkaZKgxzyVtnX2ulI9QIooM4smNTYVYHmkYSI8/cYo7fBpGn
 JiCOortsoz2JzMijHGH2bKno=
X-Envelope-To: linux-mm@kvack.org
Received: from [10.254.116.35] (101.126.56.83)
	by smtp.migadu.com with ESMTPS id da7f930ca1c05538;
	Wed, 26 Aug 2026 03:24:30 +0000
X-Mizu-Trace-ID: da7f930ca1c05538
X-Migadu-Flow: FLOW_OUT
Message-ID: <976369f1-7806-4c0d-b2b1-f91c3ac84b8b@linux.dev>
Date: Wed, 26 Aug 2026 11:24:20 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 10/17] mm/hugetlb: switch HugeTLB to section-based
 vmemmap optimization
To: Muchun Song <muchun.song@linux.dev>
Cc: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>, Oscar Salvador
 <osalvador@suse.de>, David Hildenbrand <david@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Vlastimil Babka <vbabka@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>,
 David Laight <david.laight.linux@gmail.com>,
 "Liam R . Howlett" <liam@infradead.org>,
 Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260825084608.47437-1-songmuchun@bytedance.com>
 <20260825084608.47437-11-songmuchun@bytedance.com>
 <83d8d1f2-6ca2-4c72-a494-23ce07bb4181@linux.dev>
 <C06EECC2-9025-49D8-91ED-EC58685398C4@linux.dev>
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <C06EECC2-9025-49D8-91ED-EC58685398C4@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 820B840003
X-Stat-Signature: g639h19f4m316kaqms3x4csrbgtyb58h
X-HE-Tag: 1787714671-178864
X-HE-Meta: U2FsdGVkX18SVTxDFUC1O694dHlySSLRrYvQB7q3Gc+i1tRO+P94J7ZLTCYib9P2BFzORHAFkXkLiP/8jV0FsvHqDbhxeuADU0Dsu945nJ6koP+IuGZHLP9dFbXRojw8kkUbHmSKIF3c5wn6mT70h/7PUiN8enUJ5igCOkH7dkGEIutqFli1wVCf75yAJNF5leU63+FuFFKddjXq1Lpzeh77EWVTm3/4dAv//AxpzLtA1V/Ymrs0mkTr/6SotgpIOKxKhssrbt35GAZVqfAGQPDN58vCYwe0uFbxKffyjelWbgHG9gE8u1uEZ78VavvSrAstoRoEav4k7I0wC+XngXCIz1c6ZIXW4HmUpn1Nb8/VlKqtM5LZQzcAG94zwEoOayWiRTBXwn4kVltXTFGEZ9WeJv7jnJZWvbJZwl/5nS/vxxfLS+EUXT7AA0pPROOynfHJaD5c3YC3erps89edEn1GwJCpnX3geZ3GUPxnoyd1SkfV0k5bwQTg3qOUkIsEcPr6aiE+Z4/cHzF1Af4OXkOkxes7KvJPHcACHJWGvLs11RjweYwxyUy2o/DvkU2wm/St1RIjw0Nmp53sWHirCyKPJ+EW9wTfGkDW62wcT9zqCX2uwfAWJqJ+m3MQXyZeqFiKRNY50ULjWlmVefEQEoJ+exoiRgc4iVVqyfjsJlNZpwWAyj7DBF7QNUaFpOn0bl+Pnopj7kcr212Et0tui8B7iyjX4Y8ZqPY0jMqy+jyylRyKBs84ZCoMCi4WpAbi+vq6fvVasFN5M+Ru6McZhcGgCpegSf7b/1d1DSgtl6568lVQBtali6wHHkWh80lqJheW7ydu5I8qWp1S5SZNe3V0hIXcWA4a/ZYZgSG4MNxrwiABnrRbUJTiGwJjicj5cSwrLfzo3RcuWRLNLM7NevHL8JyEsAe+u2sYKXR3p9s810VzXTD/R2Ul14ljsQM9D7//xtolL1qhXJW93+Z
 C5OZMRpz
 sIWfXjNytmKG/yS8EC8d+qY5TfCqrWtJtHvK3RaazmLN11xOCzb+aBzVND1x57xtCohbE6sYDx0bRh3a7966bm3W4ALOXMsWDAjpOVYjx8ElIc1kAw83Cu6YGJwstGOJWyQMy9hzZQUCmK2KSp/NhDYLaRb0zaVQpJCNtvYNY3Gln4DsJxTI/l+iS6BXXNWxJXfstaYhzYU7r4DVEEItHbLCw3dUZTPV2wfeFJp92fYXezPR0TLkDquJuo8TPoW36fxnfLUZWHOQFka8i705CCuomyEYtshv+bjdEal//uUONdAhNdVZro2Kv0vmoaKPsRZCJ6Y4J0QeJ5XSdQ8hLUzBjh8FdR5EIoZNSB+nPKEEDulbf/jcOZ9w8BNN6D2P1IZyvDlJB+B7fxjqFq02Yk31f6Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/26/26 10:38 AM, Muchun Song wrote:
> 
> 
>> On Aug 25, 2026, at 21:12, Qi Zheng <qi.zheng@linux.dev> wrote:
>>
>>
>>
>> On 8/25/26 4:46 PM, Muchun Song wrote:
>>> HugeTLB bootmem vmemmap optimization still carries its own early setup
>>> path, including pre-populating optimized mappings before the generic
>>> sparse-vmemmap code runs.
>>> Now that the section-based vmemmap optimization can derive HugeTLB
>>> vmemmap deduplication from section metadata, HugeTLB only needs to mark
>>> the bootmem huge page range with the appropriate order. The generic
>>> sparse-vmemmap population path can then allocate and map the shared tail
>>> vmemmap pages without any HugeTLB-specific early population code.
>>> Do that by setting the section order when a bootmem huge page is
>>> allocated and dropping the dedicated pre-HVO helpers and related
>>> special-casing.
>>> This removes duplicate early setup logic and switches HugeTLB to the
>>> section-based vmemmap optimization path.
>>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>>> Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
>>> ---
>>> v3:
>>> - Use the order-based helper for the bootmem vmemmap-optimized check
>>> v2:
>>> - Collect Acked-by from Mike Rapoport
>>> ---
>>>   include/linux/hugetlb.h |  1 -
>>>   include/linux/mm.h      |  3 --
>>>   mm/hugetlb.c            | 30 ++------------
>>>   mm/hugetlb_vmemmap.c    | 90 +++--------------------------------------
>>>   mm/hugetlb_vmemmap.h    | 14 +++----
>>>   mm/sparse-vmemmap.c     | 31 --------------
>>>   mm/sparse.h             | 27 +++++++++++++
>>>   7 files changed, 42 insertions(+), 154 deletions(-)
>>> diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
>>> index 16c4c4caa126..fe28f98e1b22 100644
>>> --- a/include/linux/hugetlb.h
>>> +++ b/include/linux/hugetlb.h
>>> @@ -171,7 +171,6 @@ struct address_space *hugetlb_folio_mapping_lock_write(struct folio *folio);
>>>     extern int movable_gigantic_pages __read_mostly;
>>>   extern int sysctl_hugetlb_shm_group __read_mostly;
>>> -extern struct list_head huge_boot_pages[MAX_NUMNODES];
>>>     void hugetlb_bootmem_struct_page_init(void);
>>>   void hugetlb_bootmem_alloc(void);
>>> diff --git a/include/linux/mm.h b/include/linux/mm.h
>>> index dd09c438fa23..441bd39eab73 100644
>>> --- a/include/linux/mm.h
>>> +++ b/include/linux/mm.h
>>> @@ -5159,9 +5159,6 @@ int vmemmap_populate_hugepages(unsigned long start, unsigned long end,
>>>           int node, struct vmem_altmap *altmap);
>>>   int vmemmap_populate(unsigned long start, unsigned long end, int node,
>>>    struct vmem_altmap *altmap);
>>> -int vmemmap_populate_hvo(unsigned long start, unsigned long end,
>>> -  unsigned int order, struct zone *zone,
>>> -  unsigned long headsize);
>>>   void vmemmap_wrprotect_hvo(unsigned long start, unsigned long end, int node,
>>>      unsigned long headsize);
>>>   void vmemmap_populate_print_last(void);
>>> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
>>> index 04e6c4244cd6..fbb0c83bea79 100644
>>> --- a/mm/hugetlb.c
>>> +++ b/mm/hugetlb.c
>>> @@ -52,6 +52,7 @@
>>>   #include "hugetlb_cma.h"
>>>   #include "hugetlb_internal.h"
>>>   #include "mm_init.h"
>>> +#include "sparse.h"
>>>   #include <linux/page-isolation.h>
>>>     int hugetlb_max_hstate __read_mostly;
>>> @@ -59,7 +60,7 @@ unsigned int default_hstate_idx;
>>>   struct hstate hstates[HUGE_MAX_HSTATE];
>>>     __initdata nodemask_t hugetlb_bootmem_nodes;
>>> -__initdata struct list_head huge_boot_pages[MAX_NUMNODES];
>>> +static struct list_head huge_boot_pages[MAX_NUMNODES] __initdata;
>>> /*
>>>   * Due to ordering constraints across the init code for various
>>> @@ -3139,6 +3140,7 @@ static bool __init alloc_bootmem_huge_page(struct hstate *h, int nid)
>>>    	} else {
>>>    		list_add_tail(&m->list, &huge_boot_pages[nid]);
>>>    		m->flags |= HUGE_BOOTMEM_ZONES_VALID;
>>> + 		hugetlb_vmemmap_optimize_bootmem_page(m);
>>>    		/*
>>>    		 * Only initialize the head struct page in memmap_init_reserved_pages,
>>>    		 * rest of the struct pages will be initialized by the HugeTLB
>>> @@ -3299,6 +3301,7 @@ static void __init gather_bootmem_prealloc_node(unsigned long nid)
>>>    	 * this folio.
>>>    	 */
>>>    	folio_set_hugetlb_vmemmap_optimized(folio);
>>> + 	section_set_order_range(folio_pfn(folio), folio_nr_pages(folio), 0);
>>
>> So section->order is only used during initialization. Is it ever
>> accessed later at runtime? If not, can we just skip zeroing it out?
> 
> You have keenly noticed a detail. This was actually done deliberately,
> because in patch 14, HUGE_BOOTMEM_HVO was removed and replaced with
> section->order. The ->order field may store a value that is less than
> VMEMMAP_OPTIMIZATION_MIN_ORDER, so clearing it to 0 here is to prevent
> potential issues with this memory region during the hotplug/hotremove
> process in the future (in my future series).
> 
> However, is there also a way to avoid clearing it to 0? There is. We
> could add an extra check in hugetlb_vmemmap_optimize_bootmem_page to
> only call section_set_order_range when the current hstate->order is
> greater than or equal to VMEMMAP_OPTIMIZATION_MIN_ORDER. I just feel
> that this would add a bit more code. And then during the boot phase,
> doing one extra zeroing-out doesn't introduce much overhead anyway.
> Therefore, I chose the simpler implementation approach.

Got it. Thanks for the detailed explanation!




