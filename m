Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 241C1CCD1BC
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 12:06:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A6BF8E000D; Thu, 23 Oct 2025 08:06:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 757278E001A; Thu, 23 Oct 2025 08:06:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 645708E0018; Thu, 23 Oct 2025 08:06:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 45DB48E0016
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 08:06:34 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0398DBD160
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 12:06:33 +0000 (UTC)
X-FDA: 84029251908.29.AF2D413
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	by imf24.hostedemail.com (Postfix) with ESMTP id 98808180015
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 12:06:30 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf24.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 45.249.212.191 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761221192;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dFb7B/QZmmZVgw9xFuC4SjQo8VlrN9sJeva0sCjKlr4=;
	b=MCOK680vTiU/3z9D7eBn1LRFqwIq7GdH84bmCOLKHhraTuVCE7lKp4g4yKCrxKl0GvOLix
	rAsdsXLTg8R0iSisTzUV1LQyaoddwh0cGBnZskEFkuLVOxMxBUWxMIGehlyZdj1Qryql9j
	KnmhZGrnRp96mUXVrgYhIx7FyVbzU3s=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761221192; a=rsa-sha256;
	cv=none;
	b=Ws14CY/+Fip6bSlulzA1N2hoXusoKQDLxX38HR0bDD5ip9YTwwadQEXPfMsoefALvhBNsF
	ZN3KXrnNwAI+GVYxVzgfaRgoSN17IkMff63sOArSabgPf/kzyD4wwKhw1YTzPrBi8KGwGd
	ARRRjQro5aWTGrEzq3eCHGSR/5P7JUw=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf24.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 45.249.212.191 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.17])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4csl5L3C8lz24jKf;
	Thu, 23 Oct 2025 20:02:14 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 8878B1A0188;
	Thu, 23 Oct 2025 20:06:25 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 23 Oct 2025 20:06:24 +0800
Message-ID: <35ec1c59-d6b2-4840-aea0-2e5c219d9d99@huawei.com>
Date: Thu, 23 Oct 2025 20:06:23 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/6] mm: page_alloc: add
 alloc_contig_{range_frozen,frozen_pages}()
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: David Hildenbrand <david@redhat.com>, Andrew Morton
	<akpm@linux-foundation.org>, Oscar Salvador <osalvador@suse.de>, Muchun Song
	<muchun.song@linux.dev>
CC: <sidhartha.kumar@oracle.com>, <jane.chu@oracle.com>, Zi Yan
	<ziy@nvidia.com>, Vlastimil Babka <vbabka@suse.cz>, Brendan Jackman
	<jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
	<linux-mm@kvack.org>, Matthew Wilcox <willy@infradead.org>
References: <20251013133854.2466530-1-wangkefeng.wang@huawei.com>
 <20251013133854.2466530-4-wangkefeng.wang@huawei.com>
 <e1f7ca22-a249-4b24-b308-d46afb2afb29@redhat.com>
 <56ad383f-80c4-43bf-848e-845311f83907@huawei.com>
 <9ee230da-3985-4fd7-96a1-6ea5ce55d298@redhat.com>
 <a10446f4-d069-45dc-94c8-7c22fcf7f30f@huawei.com>
Content-Language: en-US
In-Reply-To: <a10446f4-d069-45dc-94c8-7c22fcf7f30f@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.243]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspamd-Server: rspam01
X-Stat-Signature: 7z8fqym8i3fbfzo37najf1to3aj7wz9s
X-Rspam-User: 
X-Rspamd-Queue-Id: 98808180015
X-HE-Tag: 1761221190-165083
X-HE-Meta: U2FsdGVkX19rPwY/8Tsk04K54TVjjq6UTvP9prOJU2olTGYdwEsBIsbQbdJK9sRRkY+vGl2bqdt51YecZJ4y7Ya9jwZd674umLaa1p0yJbyMUHruJ8Ih8ez5X1UKbbmM8EBd2IWERpWLbH/A1ktCH80wVYOQ5FJDkHT6f1I4qj/xKEkaLVo+dIKNeTP6ZawWe4CSnzwDpvR0tiZFogt3watTGXesY7Ohp+fa6RLJFr8h7O8UaQhYc4nD7NnDOJ2ubpcHygV1S3iTKqoZoj9bZreeOfcZbi5TUTD+G/T0N16lLuzHgQGP5pOnzf+IwHHM0q67wYBs3mOI76gez+CA+EWUf5kljWI452IOaAN03JBTjr7gG3t2wMeDNLO67oGd55Oe1NKyV7ZxK0Z8QLkjAkARukn25DGfgbGnhH2D4HYCa8YVZ+TebtEUeoQyHmNM53KCANWilmyKDu2/tVy1svPVYi7VJOCG/72BV+q0eg2RCQF3aWF0xZ/O9ZkM4Qk60XrMbxwgB0p9jbpXKlPejKhkx/ceD7sPHrVgd6pifXb4jgex4bSd/bnjWhO9D3u3Yj/9G9xEppijg4BVU0AM79lqTurscvMOq6MvTuQws2GgxTpZMewWTg1HikEk6JQdR7zT73ktvqnZFl4tU0XxaiUyRuXAdMX3f23+rZgBw3DdRLUsFg/pIUQNsNefJChvfu+JRdOK2gOT5lxwyxskNLNVIPT2ojLxpGE7sLBJHmlDpO6nSjTn2jfZQow5TUxeDJBxjUVM4z+gz3heW5dFijXkhCyifIrMqQlJnJamj/vW/EXcD9ddhgxqNGaW7mK2Ln7FXNi5/KUqpM/eqzfxAYybYnTrIKREYD54JZspfrEsbx5wu1XL8UpFRCqV8ZDPcIDpg+5sv7Avv4ILraVRLuuwOlPd8AXeDjUS2oXeLLpOvtu6zCrRZTQvdAeG7FmoKa1MSCokyN/l/p2p60d
 QNcMs6SL
 xXxjefDH2XtKAaRXxfU4QKqgIYCniNHQfPSmUykFA2HTFBUQwRWxyFpnocnLEFyfycjwIHFJ2j9P5hr+ezoQppY1EXH2Aj+9smv4z3UWWDrB5LolGYz4z2K/psQcjffjKvxxFek1bwy0oAp8+eXVhQaZRxeQtN3pQnVs0uvol0qzS0apu0bDABDLYiqzMspFgircTpuyX7EfzOY/UAlDOW/dlsfGho8tQcU8nj4r90K89oGTsvFW8GlLKKs/+rUnGlifTLrugArtAdO2Bt/vQpRS/xexWN0EypOz3Ymp8GC8lZNTgopsb/TlGVbH8eNKqaLsnWCAEU1zFjSA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/10/20 23:21, Kefeng Wang wrote:
> + Matthew
> 
> On 2025/10/20 21:07, David Hildenbrand wrote:
>>
>>>>
>>>>> +void free_contig_range_frozen(unsigned long pfn, unsigned long 
>>>>> nr_pages)
>>>>> +{
>>>>> +    struct folio *folio = pfn_folio(pfn);
>>>>> +
>>>>> +    if (folio_test_large(folio)) {
>>>>> +        int expected = folio_nr_pages(folio);
>>>>> +
>>>>> +        WARN_ON(folio_ref_count(folio));
>>>>> +
>>>>> +        if (nr_pages == expected)
>>>>> +            free_frozen_pages(&folio->page, folio_order(folio));
>>>>> +        else
>>>>> +            WARN(true, "PFN %lu: nr_pages %lu != expected %d\n",
>>>>> +                 pfn, nr_pages, expected);
>>>>> +        return;
>>>>> +    }
>>>>> +
>>>>> +    for (; nr_pages--; pfn++) {
>>>>> +        struct page *page = pfn_to_page(pfn);
>>>>> +
>>>>> +        WARN_ON(page_ref_count(page));
>>>>> +        free_frozen_pages(page, 0);
>>>>> +    }
>>>>
>>>> That's mostly a copy-and-paste of free_contig_range().
>>>>
>>>> I wonder if there is some way to avoid duplicating a lot of
>>>> free_contig_range() here. Hmmm.
>>>>
>>>> Also, the folio stuff in there looks a bit weird I'm afraid.
>>>>
>>>> Can't we just refuse to free compound pages throught this interface and
>>>> free_contig_range() ? IIRC only hugetlb uses it and uses folio_put()
>>>> either way?
>>>>
>>>> Then we can just document that compound allocations are to be freed
>>>> differently.
>>>
>>>
>>> There is a case for cma_free_folio, which calls free_contig_range for
>>> both in cma_release(), but I will try to check whether we could avoid
>>> the folio stuff in free_contig_range().
>>
>>
>> Ah, right, there is hugetlb_cma_free_folio()->cma_free_folio().
>>
>> And we need that, because we have to make sure that CMA stats are 
>> updated properly.
>>
>> All compound page handling in the freeing path is just nasty and not 
>> particularly future-proof regarding memdescs.
>>
>> I wonder if we could just teach alloc_contig to never hand out 
>> compound pages and then let the freeing path similarly assert that 
>> there are no compound pages.
>>
>> Whoever wants a compound page (currently only hugetlb?) can create 
>> that from a frozen range. Before returning the frozen range the 
>> compound page can be dissolved. That way also any memdesc can be 
>> allocated/freed by the caller later.
>>
>> The only nasty thing is the handing of splitting/merging of 
>> set_page_owner/page_table_check_alloc etc. :(
>>
>>
>>
>> As an alternative, we could only allow compound pages for frozen 
>> pages. This way, we'd force any caller to handle the allocation/ 
>> freeing of the memdesc in the future manually.
>>
>> Essentially, only allow GFP_COMPOUND on the frozen interface, which we 
>> would convert hugetlb to.
>>
>> That means that we can simplify free_contig_range() [no need to handle 
>> compound pages]. For free_contig_frozen_range() we would skip refcount 
>> checks on that level and do something like:


I tried to only allocate/free non-compound pages in
alloc_contig_{range,pages}() and free_contig_range(),

The new added alloc_contig_frozen_{range,pages} can allocate compound/
non-compound frozen pages, let's discuss in the new version[1].

[1] 
https://lore.kernel.org/linux-mm/20251023115940.3573158-1-wangkefeng.wang@huawei.com/

>>
>> void free_contig_frozen_range(unsigned long pfn, unsigned long nr_pages)
>> {
>>      struct page *first_page = pfn_to_page(pfn)
>>      const unsigned int order = ilog2(nr_pages);
>>
>>      if (PageHead(first_page)) {
>>          WARN_ON_ONCE(order != compound_order(first_page));
>>          free_frozen_pages(first_page, order);
>>          return;
>>      }
>>
>>      for (; nr_pages--; pfn++)
>>          free_frozen_pages(pfn_to_page(pfn), 0);
>> }
>>
>> CCing Willy, I don't know yet what will be better in the future. But 
>> the folio stuff in there screams for problems.
>>
> 
> Sorry forget to add cc in v3, the full link[1],
> 
> [1] https://lore.kernel.org/linux-mm/20251013133854.2466530-1- 
> wangkefeng.wang@huawei.com/
> 
> 
> 


