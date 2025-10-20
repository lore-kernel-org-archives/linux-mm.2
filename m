Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F4C7CCD193
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 15:22:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB7E28E000D; Mon, 20 Oct 2025 11:22:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E8F8E8E0002; Mon, 20 Oct 2025 11:22:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DCCA48E000D; Mon, 20 Oct 2025 11:22:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CB41E8E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 11:22:06 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 52BE5567C6
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 15:22:06 +0000 (UTC)
X-FDA: 84018858252.23.8361EEF
Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	by imf29.hostedemail.com (Postfix) with ESMTP id 512CB12000A
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 15:22:02 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=Z5fkZteM;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf29.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.217 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760973724;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=77bmcNeyfqxfGv/mzhRVYSkVnEbpP1TyuysFNgXZFkg=;
	b=UOtx4mD6eQGecunYY8NInXrXOpSmX4HuevdKWyqGbxSVt4odlUcCd3G2GPcWRk/gfkPFmf
	FDVkh8ylqXoN/NeENf6SK/XSBfqjTD3fcJJIbuqR0ucio4hjoilXTG9k6oMRPk5TzmfMj6
	j7ocQbcRdIqWZjJHfjUWe8KvFRjfPuc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760973724; a=rsa-sha256;
	cv=none;
	b=dzyCTxs2/gqWrSfFyTov/E1MipinlE5zI7QZboOFDvAvA7BxzLpwtiIc7Gic1tGcBNQ/lQ
	3sId/cyHp5sLEJb8gENEhU1qt1u0iJ95/QZ7UKX6xyz0W1Mrbb8cB0Leo4SNu2NLjCr5Bv
	g0YsW+wJhXpiYn62NiS8GLbpAwCUCtk=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=Z5fkZteM;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf29.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.217 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=77bmcNeyfqxfGv/mzhRVYSkVnEbpP1TyuysFNgXZFkg=;
	b=Z5fkZteMRw8xKDeJKdbglp0Y+B7bn4/Ymptorlj71XgsurVHkG/vV6xfTuNPfDlQ4BJ0ij8v3
	8lUWmsGCQRFQAaCZUe6yk63o1SVBK7unlG5H1MiUECK8yO6aSSg9qvXqghSRduyVEd/tVnbyAjb
	v2atQzlt9Khywq7gGsINVeM=
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4cqzdt0sHJzcb1s;
	Mon, 20 Oct 2025 23:20:50 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 0C7CD180B62;
	Mon, 20 Oct 2025 23:21:58 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 20 Oct 2025 23:21:56 +0800
Message-ID: <a10446f4-d069-45dc-94c8-7c22fcf7f30f@huawei.com>
Date: Mon, 20 Oct 2025 23:21:56 +0800
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
	<linux-mm@kvack.org>, Matthew Wilcox <willy@infradead.org>
References: <20251013133854.2466530-1-wangkefeng.wang@huawei.com>
 <20251013133854.2466530-4-wangkefeng.wang@huawei.com>
 <e1f7ca22-a249-4b24-b308-d46afb2afb29@redhat.com>
 <56ad383f-80c4-43bf-848e-845311f83907@huawei.com>
 <9ee230da-3985-4fd7-96a1-6ea5ce55d298@redhat.com>
Content-Language: en-US
From: Kefeng Wang <wangkefeng.wang@huawei.com>
In-Reply-To: <9ee230da-3985-4fd7-96a1-6ea5ce55d298@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.243]
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspamd-Server: rspam01
X-Stat-Signature: djskzt67hec8xi787gj6gmyfyg4itx6q
X-Rspam-User: 
X-Rspamd-Queue-Id: 512CB12000A
X-HE-Tag: 1760973722-232189
X-HE-Meta: U2FsdGVkX18BGHChZV0GNg96+tkl6pKULrcimNygerhz6TwUOUknOE6BAxTY47F5uNpbVBX4zggUtlFe4NJHaIkrhcuY9/FYtVxtAVknDHUsbdo3xmrIvm9qgUw2xNJv77xe37DV1eL5r4D7YJ76lNZrLFx7OzmFcl+mbd8Yb+rXyY9d2h+paYD3HflHZbNj+fhM3DXPt00lmEsshK4L5Z8vc0Oz1OHtnDDV7CFKbP+X/Moe1/kd3fLhnpCvr4louMqgaChFpgdD3fAmpJZkDN9S1pZ/psGa16HhbytaAP1nozJql7Q/TGyQhdPXxeNwUAxV4wkd7AWMJxAQM+J2NWRnPi2lTFBkehQOUT1zROMqDJYSt5QcTKuE2hwbkzM/7C/0WI3CC46Sr3XmKPz917MMfxdlR0VL+g15nQf4SbB4Duj7hmNgQsfpO4k+BQ/XoucCYWXZa+AIN/e3KsJEvvMLf5hzvga4CgZhKR0k/9O9ncW+6dBQoP3AdQBLsgzpso6FE6LPsz5amr3BkjpOS/+ioFoQfxK4aux7RFQcr0wvhZy5j9sHbT50XKYH+TecIdQ5d9a5qTmXpSkoh4lDzjP8rkuYirxqZc3mb6VBn5Hz59k154+d8S/0+jbe4RUI9v/bcRked6iUqOeK2AdnV6MuDveSIcC9mTrzQC1L1FVYNhWqNcDfMfp4b1rRsMjmgqNTmI8Na6wsiC8zyWBI9AB4NCqmP8CRHBjG5Gp54ZaW9MvPZ4FNu+JYYimCOHHFQ57dRXqLRMtxx5aMwHJklQ38JL/Rxkxrb2dIbF+LFW45OZo1JDhIJjtHZhDl3tL1hkeopfmm6lIIibpVbJllzttHkeSxqmGJ8DCw6K02oiWX9lfq9eHblJZBCSSHFEaUllw0qw8HxadpTVUn9WnpBrf68RMroExOpMQwGpXhsmn8Wvr1H5p8TZEc2Gg2ityVa1aH1Mdp+69eK/cbnHW
 OLom06gD
 k1r4CzrDsoPNcieajm6qF/RQmadgHB2mwRkL89AcZNRTnLDrPPuTB3IgiIyyUripdbRnRaDOe9r718hXbD9FxTZjT4wsEtqYsY9V1N6lHTI6YdjrrOM05kuOcEFXmefsr0/DX7UkrcFuRkXYpf63JKhUO2iLAsWKKlAV4gSrFqeoj4Un5dMRO3uOQ0rJ9vU+6J734KrxwqRI2r1/1TWJjtSZgd4+Z1GoYTSOyrMZDmD36FmE24ZGqNmPFMcRwQBJ6z9Jj+VFuypfwQUfb69/9bsN/ZH1z7rJkkSKLql30lGNETvpuAFg4mruV3xsV8rIYkNXw8kSmL0OJi07q7k+l0qRH2gcN6hXdIgwV+WjDzmGLZAIvKSOop06uKd/xy0PV5mvJN1KBUsE5vhS53vqJ9zoz5mDFqTLaMFDhBVb/98OzpkahLeWDcoScUQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

+ Matthew

On 2025/10/20 21:07, David Hildenbrand wrote:
> 
>>>
>>>> +void free_contig_range_frozen(unsigned long pfn, unsigned long 
>>>> nr_pages)
>>>> +{
>>>> +    struct folio *folio = pfn_folio(pfn);
>>>> +
>>>> +    if (folio_test_large(folio)) {
>>>> +        int expected = folio_nr_pages(folio);
>>>> +
>>>> +        WARN_ON(folio_ref_count(folio));
>>>> +
>>>> +        if (nr_pages == expected)
>>>> +            free_frozen_pages(&folio->page, folio_order(folio));
>>>> +        else
>>>> +            WARN(true, "PFN %lu: nr_pages %lu != expected %d\n",
>>>> +                 pfn, nr_pages, expected);
>>>> +        return;
>>>> +    }
>>>> +
>>>> +    for (; nr_pages--; pfn++) {
>>>> +        struct page *page = pfn_to_page(pfn);
>>>> +
>>>> +        WARN_ON(page_ref_count(page));
>>>> +        free_frozen_pages(page, 0);
>>>> +    }
>>>
>>> That's mostly a copy-and-paste of free_contig_range().
>>>
>>> I wonder if there is some way to avoid duplicating a lot of
>>> free_contig_range() here. Hmmm.
>>>
>>> Also, the folio stuff in there looks a bit weird I'm afraid.
>>>
>>> Can't we just refuse to free compound pages throught this interface and
>>> free_contig_range() ? IIRC only hugetlb uses it and uses folio_put()
>>> either way?
>>>
>>> Then we can just document that compound allocations are to be freed
>>> differently.
>>
>>
>> There is a case for cma_free_folio, which calls free_contig_range for
>> both in cma_release(), but I will try to check whether we could avoid
>> the folio stuff in free_contig_range().
> 
> 
> Ah, right, there is hugetlb_cma_free_folio()->cma_free_folio().
> 
> And we need that, because we have to make sure that CMA stats are 
> updated properly.
> 
> All compound page handling in the freeing path is just nasty and not 
> particularly future-proof regarding memdescs.
> 
> I wonder if we could just teach alloc_contig to never hand out compound 
> pages and then let the freeing path similarly assert that there are no 
> compound pages.
> 
> Whoever wants a compound page (currently only hugetlb?) can create that 
> from a frozen range. Before returning the frozen range the compound page 
> can be dissolved. That way also any memdesc can be allocated/freed by 
> the caller later.
> 
> The only nasty thing is the handing of splitting/merging of 
> set_page_owner/page_table_check_alloc etc. :(
> 
> 
> 
> As an alternative, we could only allow compound pages for frozen pages. 
> This way, we'd force any caller to handle the allocation/freeing of the 
> memdesc in the future manually.
> 
> Essentially, only allow GFP_COMPOUND on the frozen interface, which we 
> would convert hugetlb to.
> 
> That means that we can simplify free_contig_range() [no need to handle 
> compound pages]. For free_contig_frozen_range() we would skip refcount 
> checks on that level and do something like:
> 
> void free_contig_frozen_range(unsigned long pfn, unsigned long nr_pages)
> {
>      struct page *first_page = pfn_to_page(pfn)
>      const unsigned int order = ilog2(nr_pages);
> 
>      if (PageHead(first_page)) {
>          WARN_ON_ONCE(order != compound_order(first_page));
>          free_frozen_pages(first_page, order);
>          return;
>      }
> 
>      for (; nr_pages--; pfn++)
>          free_frozen_pages(pfn_to_page(pfn), 0);
> }
> 
> CCing Willy, I don't know yet what will be better in the future. But the 
> folio stuff in there screams for problems.
> 

Sorry forget to add cc in v3, the full link[1],

[1] 
https://lore.kernel.org/linux-mm/20251013133854.2466530-1-wangkefeng.wang@huawei.com/ 




