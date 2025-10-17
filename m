Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7E4CCCD184
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 07:19:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A87EA8E003B; Fri, 17 Oct 2025 03:19:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A09EE8E0002; Fri, 17 Oct 2025 03:19:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B5A28E003B; Fri, 17 Oct 2025 03:19:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 732A08E0002
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 03:19:16 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B4A3811A574
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 07:19:15 +0000 (UTC)
X-FDA: 84006755070.12.7A23074
Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	by imf24.hostedemail.com (Postfix) with ESMTP id 8F434180008
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 07:19:12 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=eZu7sJ0e;
	spf=pass (imf24.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760685554; a=rsa-sha256;
	cv=none;
	b=2TwaN8MSweXsV2JxpzrxaeEMQ4W3hQmbeiYUm5cb8dJzAq12C8x0lEQEzmNZjI39f0JOH4
	QbqNxRIS4wsnQiuLQN/uAf4D1YlVhqWed9G3NOVBB/hObcgUTkEQBYqQLsCIMxJ8O033R+
	fmayNu5j5G0Z+9kSFPRNtgQcAKtGtSU=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=eZu7sJ0e;
	spf=pass (imf24.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760685553;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r/Dks+48w1BdXiFzek6OOlKb+iAYgvFGifA885CHgUw=;
	b=QRKu9f6fOLwG3yYTS/RVgUsZ3bqRXGd2ZPSNnhC8uyEn1UOG2kS6bQ5yGTOqbHRZ3MB5Q5
	u9RQ2L11BE27f5O/WRMyUie5ktCV66Kn/mkD64VXxf1r1t6O83G9abgK9kfqE0XAhNdvfa
	b3YsQ0ijT/++HDYf7fe2GKxuPgxiHqo=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=r/Dks+48w1BdXiFzek6OOlKb+iAYgvFGifA885CHgUw=;
	b=eZu7sJ0e+229j+RC4MywSEDBWrs+KVDQyTl+VENlmbkw7f8upDzW1NTdgzpX40SSkuhkTK6aA
	qNUHyjvG5ux8FoIZi9dpaA4www0y5SCAFmwlHqYdEC/zg6yKMM5Waf1UgD8b26UUAcjwEdJknqZ
	MtHgdYH9vOEmHGjhpzs93HM=
Received: from mail.maildlp.com (unknown [172.19.88.194])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4cnx516Bccz1prMP;
	Fri, 17 Oct 2025 15:18:45 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id AF7DE140123;
	Fri, 17 Oct 2025 15:19:07 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 17 Oct 2025 15:19:06 +0800
Message-ID: <56ad383f-80c4-43bf-848e-845311f83907@huawei.com>
Date: Fri, 17 Oct 2025 15:19:05 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/6] mm: page_alloc: add
 alloc_contig_{range_frozen,frozen_pages}()
To: David Hildenbrand <david@redhat.com>, Andrew Morton
	<akpm@linux-foundation.org>, Oscar Salvador <osalvador@suse.de>, Muchun Song
	<muchun.song@linux.dev>
CC: <sidhartha.kumar@oracle.com>, <jane.chu@oracle.com>, Zi Yan
	<ziy@nvidia.com>, Vlastimil Babka <vbabka@suse.cz>, Brendan Jackman
	<jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
	<linux-mm@kvack.org>
References: <20251013133854.2466530-1-wangkefeng.wang@huawei.com>
 <20251013133854.2466530-4-wangkefeng.wang@huawei.com>
 <e1f7ca22-a249-4b24-b308-d46afb2afb29@redhat.com>
Content-Language: en-US
From: Kefeng Wang <wangkefeng.wang@huawei.com>
In-Reply-To: <e1f7ca22-a249-4b24-b308-d46afb2afb29@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.243]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspam-User: 
X-Stat-Signature: rmqtowe8qifwzda1fb1ux7ywoifief6d
X-Rspamd-Queue-Id: 8F434180008
X-Rspamd-Server: rspam09
X-HE-Tag: 1760685552-292255
X-HE-Meta: U2FsdGVkX1+1FaWHejICG/XoXzuJgFTZXE0gsipziKkDW0PQl8dFWX08M1HKmJsHutGe6mkNFObsfjjipQvQSC0OfFxxp2X+TekffVLhz+XkuyntGJEyRbPyEHcu4G2Z/cM0HY95mWw1vPZYJOpqlvcEZCs26AzFUKqRNybfXoX11rrpCMIjDG1M1cXy046GTqTK7GXVjOMPv+UW7n+xb8X3LVAx773qviov78rLEJSpLJrummumGluLPsGBs2tSKLZmVariYkojHmG+Oo/MAF/PwYiulreG7t7qvRYEdvPz4Ii5nW6PU+C2ZuVIOqpC2UQVdt3FoB6BpP2Gj2mCR3KXvpx1rSJFghv02/z8GuoxzOAnk/XVBJQSF+iZNg8LRLpS9kG2x5J2Fl/eb/G0+JOgFKT3b0MAb0BXoMg1zkEdghPrHL0MqIm9hkCxQzc3PDWmkleAPK9xHEnupzpuuQKLX4iXOESrGDaLebQpJEDLaaB90QQ/jSvLtadh+3UkRpmXd3KzO2dubWH3ClS/vCoxIpFNEMGdI1C7gkXmM1fk9/4XW9rKCJT1jawKK48ZQpg1dMeAQDELZkbl5VpUwwP7zwbmGMqtj6s+dCqf+oPOIqTyoG3XYvPgRAbI4sprNLMA+eQ5JFsKuy9t4qiGzMpvuMQSh5SU5DEpCfyE4SCVgeE8YsAmL4eMmB2oQGJ/wRcS1mJVnT64QOsZ3QL5JDW2fIGqUQX87GcDAeVA06G+pjtijiqXh+oFB/6zjPUh8F84CvMTfiDL7HYnDwpAz8NJoqu6rTQ1aU+RYzP+lRxPNgVZo1L67+3p5GL5hhp1heiU05cP8Pl2lLJmwNx2mec92bUWNHEBQNvs0sRLnNFa1VwN0zN5C602fG/xVtUTcShfWOY7zuWWCUljdFF1tfYnLYcz2Mwp1LXgo4zQ9jUwpwyk1t9bHI3hlkUwBn36i1H9KonYzcatZyZ6x/C
 2nQS+YUE
 KS6nnuRWlKfOXUP7Vclm8BJ0IQww5gU6/L8YeQnIVvNejeG4hOK/vW1G4sOAvi9J8pITI4z+PuU9s4kFv1H3xflcNvZPXPG3NjeyHW2TtNW58MlouUzr6nJgmRRU78beBolm43IKL5A5/P8xFrquziEU5yhsSRfy2N+8RBdD0zgPBM2aIRy59YUEofKl+H/8kdFwgnZ8ouQD585tmSLSG4mB8eSVOvAPYRk3fpZ+TCHdaaBB1/mMHh1Pu4ThU1iXtxkUByT5DsvUxyYquV7vfRSHne9nfPijCqGnSRvIerN0l05xQWPq5UJsAvyQZVF25THaZ73Jc5VtBSBoUUHKem/mUPYn2lrdUefW5mr7qC4Z51j5l4EGvDaWcqXNQvhVXA1dJxd7V2chaJ7oebP9kBMBzOGXlr9V1Q3yF
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/10/17 4:53, David Hildenbrand wrote:
> On 13.10.25 15:38, Kefeng Wang wrote:
>> In order to allocate given range of pages or allocate compound
>> pages without incrementing their refcount, adding two new helper
>> alloc_contig_{range_frozen,frozen_pages}() which may be beneficial
>> to some users (eg hugetlb), also free_contig_range_frozen() is
>> provided to match alloc_contig_range_frozen(), but it is better to
>> use free_frozen_pages() to free frozen compound pages.
>>
>> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
>> ---
>>   include/linux/gfp.h |  29 +++++--
>>   mm/page_alloc.c     | 183 +++++++++++++++++++++++++++++---------------
>>   2 files changed, 143 insertions(+), 69 deletions(-)
>>
>> diff --git a/include/linux/gfp.h b/include/linux/gfp.h
>> index 1fefb63e0480..fbbdd8c88483 100644
>> --- a/include/linux/gfp.h
>> +++ b/include/linux/gfp.h
>> @@ -429,14 +429,27 @@ typedef unsigned int __bitwise acr_flags_t;
>>   #define ACR_FLAGS_CMA ((__force acr_flags_t)BIT(0)) // allocate for CMA
>>   /* The below functions must be run on a range from a single zone. */
>> -extern int alloc_contig_range_noprof(unsigned long start, unsigned 
>> long end,
>> -                     acr_flags_t alloc_flags, gfp_t gfp_mask);
>> -#define alloc_contig_range(...)            
>> alloc_hooks(alloc_contig_range_noprof(__VA_ARGS__))
>> -
>> -extern struct page *alloc_contig_pages_noprof(unsigned long nr_pages, 
>> gfp_t gfp_mask,
>> -                          int nid, nodemask_t *nodemask);
>> -#define alloc_contig_pages(...)            
>> alloc_hooks(alloc_contig_pages_noprof(__VA_ARGS__))
>> -
>> +int alloc_contig_range_frozen_noprof(unsigned long start, unsigned 
>> long end,
>> +        acr_flags_t alloc_flags, gfp_t gfp_mask);
> 
> Just wondering: given alloc_contig_pages() vs. alloc_contig_frozen_pages_()
> 
> Shouldn't it be alloc_contig_range() vs. alloc_contig_frozen_range()
> 
> And then free_contig_frozen_range()?
> 

Sure, it's better to align them, not thought much about the naming.

> 
> Do we want kerneldoc here as well?

OK, will add a short kerneldoc for this one.

> 
>> +int alloc_contig_range_frozen_noprof(unsigned long start, unsigned 
>> long end,
>> +        acr_flags_t alloc_flags, gfp_t gfp_mask)
>>   {
>>       const unsigned int order = ilog2(end - start);
>>       unsigned long outer_start, outer_end;
>> @@ -7003,19 +6982,18 @@ int alloc_contig_range_noprof(unsigned long 
>> start, unsigned long end,
>>       }
>>       if (!(gfp_mask & __GFP_COMP)) {
>> -        split_free_pages(cc.freepages, gfp_mask);
>> +        split_free_frozen_pages(cc.freepages, gfp_mask);
>>           /* Free head and tail (if any) */
>>           if (start != outer_start)
>> -            free_contig_range(outer_start, start - outer_start);
>> +            free_contig_range_frozen(outer_start, start - outer_start);
>>           if (end != outer_end)
>> -            free_contig_range(end, outer_end - end);
>> +            free_contig_range_frozen(end, outer_end - end);
>>       } else if (start == outer_start && end == outer_end && 
>> is_power_of_2(end - start)) {
>>           struct page *head = pfn_to_page(start);
>>           check_new_pages(head, order);
>>           prep_new_page(head, order, gfp_mask, 0);
>> -        set_page_refcounted(head);
>>       } else {
>>           ret = -EINVAL;
>>           WARN(true, "PFN range: requested [%lu, %lu), allocated [%lu, 
>> %lu)\n",
>> @@ -7025,16 +7003,48 @@ int alloc_contig_range_noprof(unsigned long 
>> start, unsigned long end,
>>       undo_isolate_page_range(start, end);
>>       return ret;
>>   }
>> -EXPORT_SYMBOL(alloc_contig_range_noprof);
>> -static int __alloc_contig_pages(unsigned long start_pfn,
>> -                unsigned long nr_pages, gfp_t gfp_mask)
>> +/**
>> + * alloc_contig_range() -- tries to allocate given range of pages
>> + * @start:    start PFN to allocate
>> + * @end:    one-past-the-last PFN to allocate
>> + * @alloc_flags:    allocation information
>> + * @gfp_mask:    GFP mask. Node/zone/placement hints are ignored; 
>> only some
>> + *        action and reclaim modifiers are supported. Reclaim modifiers
>> + *        control allocation behavior during compaction/migration/ 
>> reclaim.
>> + *
>> + * The PFN range does not have to be pageblock aligned. The PFN range 
>> must
>> + * belong to a single zone.
>> + *
>> + * The first thing this routine does is attempt to MIGRATE_ISOLATE all
>> + * pageblocks in the range.  Once isolated, the pageblocks should not
>> + * be modified by others.
>> + *
>> + * Return: zero on success or negative error code.  On success all
>> + * pages which PFN is in [start, end) are allocated for the caller and
>> + * need to be freed with free_contig_range().
>> + */
>> +int alloc_contig_range_noprof(unsigned long start, unsigned long end,
>> +                  acr_flags_t alloc_flags, gfp_t gfp_mask)
>>   {
>> -    unsigned long end_pfn = start_pfn + nr_pages;
>> +    int ret;
>> +
>> +    ret = alloc_contig_range_frozen_noprof(start, end, alloc_flags, 
>> gfp_mask);
>> +    if (ret)
>> +        return ret;
>> +
>> +    if (gfp_mask & __GFP_COMP) {
>> +        set_page_refcounted(pfn_to_page(start));
>> +    } else {
>> +        unsigned long pfn;
>> +
>> +        for (pfn = start; pfn < end; pfn++)
>> +            set_page_refcounted(pfn_to_page(pfn));
>> +    }
> 
> Might read better as
> 
> unsigned long pfn;
> 
> ...
> 
> if (gfp_mask & __GFP_COMP) {
>      set_page_refcounted(pfn_to_page(start));
>      return 0;
> }
> 
> for (pfn = start; pfn < end; pfn++)
>      set_page_refcounted(pfn_to_page(pfn));
> return 0;
> 
> 

I like this one, avoid gfp_mask check in the loop.

> One could also do something fancy like
> 
> unsigned long pfn;
> ...
> 
> for (pfn = start; pfn < end; pfn++) {
>      set_page_refcounted(pfn_to_page(pfn));
>      if (gfp_mask & __GFP_COMP)
>          break;
> }
> return 0:
> 
> 
>> -    return alloc_contig_range_noprof(start_pfn, end_pfn, ACR_FLAGS_NONE,
>> -                     gfp_mask);
>> +    return 0;
>>   }
>> +EXPORT_SYMBOL(alloc_contig_range_noprof);
>>   static bool pfn_range_valid_contig(struct zone *z, unsigned long 
>> start_pfn,
>>                      unsigned long nr_pages)
>> @@ -7067,31 +7077,8 @@ static bool zone_spans_last_pfn(const struct 
>> zone *zone,
>>       return zone_spans_pfn(zone, last_pfn);
>>   }
> 
> 
> ... kerneldoc? :)

Sure.

> 
>> +struct page *alloc_contig_frozen_pages_noprof(unsigned long nr_pages,
>> +        gfp_t gfp_mask, int nid, nodemask_t *nodemask)
>>   {
>>       unsigned long ret, pfn, flags;
>>       struct zonelist *zonelist;
>> @@ -7114,7 +7101,9 @@ struct page *alloc_contig_pages_noprof(unsigned 
>> long nr_pages, gfp_t gfp_mask,
>>                    * and cause alloc_contig_range() to fail...
>>                    */
>>                   spin_unlock_irqrestore(&zone->lock, flags);
>> -                ret = __alloc_contig_pages(pfn, nr_pages,
>> +                ret = alloc_contig_range_frozen_noprof(pfn,
>> +                            pfn + nr_pages,
>> +                            ACR_FLAGS_NONE,
>>                               gfp_mask);
>>                   if (!ret)
>>                       return pfn_to_page(pfn);
>> @@ -7126,6 +7115,78 @@ struct page *alloc_contig_pages_noprof(unsigned 
>> long nr_pages, gfp_t gfp_mask,
>>       }
>>       return NULL;
>>   }
>> +EXPORT_SYMBOL(alloc_contig_range_frozen_noprof);
>> +
> 
> kerneldoc? :)
> 
>> +void free_contig_range_frozen(unsigned long pfn, unsigned long nr_pages)
>> +{
>> +    struct folio *folio = pfn_folio(pfn);
>> +
>> +    if (folio_test_large(folio)) {
>> +        int expected = folio_nr_pages(folio);
>> +
>> +        WARN_ON(folio_ref_count(folio));
>> +
>> +        if (nr_pages == expected)
>> +            free_frozen_pages(&folio->page, folio_order(folio));
>> +        else
>> +            WARN(true, "PFN %lu: nr_pages %lu != expected %d\n",
>> +                 pfn, nr_pages, expected);
>> +        return;
>> +    }
>> +
>> +    for (; nr_pages--; pfn++) {
>> +        struct page *page = pfn_to_page(pfn);
>> +
>> +        WARN_ON(page_ref_count(page));
>> +        free_frozen_pages(page, 0);
>> +    }
> 
> That's mostly a copy-and-paste of free_contig_range().
> 
> I wonder if there is some way to avoid duplicating a lot of
> free_contig_range() here. Hmmm.
> 
> Also, the folio stuff in there looks a bit weird I'm afraid.
> 
> Can't we just refuse to free compound pages throught this interface and
> free_contig_range() ? IIRC only hugetlb uses it and uses folio_put() 
> either way?
> 
> Then we can just document that compound allocations are to be freed 
> differently.


There is a case for cma_free_folio, which calls free_contig_range for 
both in cma_release(), but I will try to check whether we could avoid
the folio stuff in free_contig_range().

> 
> And do something like
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 600d9e981c23d..776b4addc3685 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -7123,29 +7123,25 @@ struct page *alloc_contig_pages_noprof(unsigned 
> long nr_pages, gfp_t gfp_mask,
>   }
>   #endif /* CONFIG_CONTIG_ALLOC */
> 
> -void free_contig_range(unsigned long pfn, unsigned long nr_pages)
> +static inline void __free_contig_range(unsigned long pfn, unsigned long 
> nr_pages, bool put_ref)
>   {
> -       unsigned long count = 0;
> -       struct folio *folio = pfn_folio(pfn);
> -
> -       if (folio_test_large(folio)) {
> -               int expected = folio_nr_pages(folio);
> -
> -               if (nr_pages == expected)
> -                       folio_put(folio);
> -               else
> -                       WARN(true, "PFN %lu: nr_pages %lu != expected 
> %d\n",
> -                            pfn, nr_pages, expected);
> -               return;
> -       }
> +       if (WARN_ON_ONCE(PageHead(pfn_to_page(pfn))))
> +               break;
> 
>          for (; nr_pages--; pfn++) {
>                  struct page *page = pfn_to_page(pfn);
> 
> -               count += page_count(page) != 1;
> -               __free_page(page);
> +               if (put_ref)
> +                       page_ref_dec(page);
> +               if (WARN_ON_ONCE(page_count(page)))
> +                       continue;
> +               free_frozen_pages(page, 0);
>          }
> -       WARN(count != 0, "%lu pages are still in use!\n", count);
> +}
> +
> +void free_contig_range(unsigned long pfn, unsigned long nr_pages)
> +{
> +       return __free_contig_range(pfn, nr_pages, /* put_ref= */ true);
>   }
>   EXPORT_SYMBOL(free_contig_range);
> 
> 
> Just a thought, I dislike current free_contig_range() and the duplicated
> variant.
> 
>> +}
>> +EXPORT_SYMBOL(free_contig_range_frozen);
>> +
>> +/**
>> + * alloc_contig_pages() -- tries to find and allocate contiguous 
>> range of pages
>> + * @nr_pages:    Number of contiguous pages to allocate
>> + * @gfp_mask:    GFP mask. Node/zone/placement hints limit the 
>> search; only some
>> + *        action and reclaim modifiers are supported. Reclaim modifiers
>> + *        control allocation behavior during compaction/migration/ 
>> reclaim.
>> + * @nid:    Target node
>> + * @nodemask:    Mask for other possible nodes
>> + *
>> + * This routine is a wrapper around alloc_contig_range(). It scans 
>> over zones
>> + * on an applicable zonelist to find a contiguous pfn range which can 
>> then be
>> + * tried for allocation with alloc_contig_range(). This routine is 
>> intended
>> + * for allocation requests which can not be fulfilled with the buddy 
>> allocator.
>> + *
>> + * The allocated memory is always aligned to a page boundary. If 
>> nr_pages is a
>> + * power of two, then allocated range is also guaranteed to be 
>> aligned to same
>> + * nr_pages (e.g. 1GB request would be aligned to 1GB).
>> + *
>> + * Allocated pages can be freed with free_contig_range() or by 
>> manually calling
>> + * __free_page() on each allocated page.
>> + *
>> + * Return: pointer to contiguous pages on success, or NULL if not 
>> successful.
>> + */
>> +struct page *alloc_contig_pages_noprof(unsigned long nr_pages, gfp_t 
>> gfp_mask,
>> +        int nid, nodemask_t *nodemask)
>> +{
>> +    struct page *page;
>> +
>> +    page =  alloc_contig_frozen_pages_noprof(nr_pages, gfp_mask, nid,
>> +                         nodemask);
>> +    if (!page)
>> +        return NULL;
>> +
>> +    if (gfp_mask & __GFP_COMP) {
>> +        set_page_refcounted(page);
>> +    } else {
>> +        unsigned long pfn = page_to_pfn(page);
>> +
>> +        for (; nr_pages--; pfn++)
>> +            set_page_refcounted(pfn_to_page(pfn));
>> +    }
>> +
>> +    return page;
> 
> Same here, might be able to make it easier to read like I suggested for the
> alloc_contig_range_noprof().
> 
> Or that part can just be factored out?
> 
> void set_pages_refcounted(struct page *page, unsigned long nr_pages, 
> gfp_t gfp_mask)
> 
> or better
> 
> void set_pages_refcounted(struct page *page, unsigned long nr_pages)
> 
> And deriving __GFP_COMP from PageHead().
> 

Will try to fact it out.

Thanks.


