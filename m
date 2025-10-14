Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A32FCCD184
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 03:46:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C2F738E008A; Mon, 13 Oct 2025 23:46:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BDF9E8E0007; Mon, 13 Oct 2025 23:46:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B1D318E008A; Mon, 13 Oct 2025 23:46:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A04FA8E0007
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 23:46:09 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4E8358851A
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 03:46:09 +0000 (UTC)
X-FDA: 83995331658.08.62C6C0B
Received: from canpmsgout11.his.huawei.com (canpmsgout11.his.huawei.com [113.46.200.226])
	by imf07.hostedemail.com (Postfix) with ESMTP id B58DF4000C
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 03:46:06 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=DfsgoES4;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf07.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.226 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760413567;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vV+CmLQ1cXdFlzStGvw1Jiq+/JhsjRL80mmsJdo4exw=;
	b=721ePtJhC/61PWfVbi6XohHUR56yORLrrp8ELIYbB2YweKZUT2dkUp7TwB/5eFG3EgYqBF
	MmlfVJi1DehHKBzegY4okc2e9UxNsXYnl0WLhgwvoW64WVq5evWynvip5Cg95UGEZPmlh0
	04vV1inrs6VN4GYGZLec5Z5tYbdqK/c=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=DfsgoES4;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf07.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.226 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760413567; a=rsa-sha256;
	cv=none;
	b=Cg6mHjAzPzU9bTaiHRER/zJZW9R4MKCXNYpji5yrIfrbdBZJJDJiWrOIE+S5iCoqeafMvZ
	GkSFEUL7W2DyaHazitw7avKbWqBsrcloP1+3ddpiJRtNSa5pO9JtFZEsxe33T0kmDIxjo4
	mB4XDU5AVfBupaAFwtLVrvh2bSRWpN4=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=vV+CmLQ1cXdFlzStGvw1Jiq+/JhsjRL80mmsJdo4exw=;
	b=DfsgoES4Qj+g0PXyEm63t0V8MFaqpWOuI/VWfSGR0q3unvAFwIxYr1n2EYe7Jwc34vpNKOLKL
	23MhhJTWYgDEW0HHMMk2g3oMf0WTJg2fZGuVy6kRBi233c2Vxl0AogA7+ERIALmbk+GGsdD3Q31
	XZ5kZ/fz7zxqKCH+WkgyFgs=
Received: from mail.maildlp.com (unknown [172.19.88.214])
	by canpmsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4cm0VZ2tPzzKm5G;
	Tue, 14 Oct 2025 11:45:42 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id D1A631A016C;
	Tue, 14 Oct 2025 11:46:01 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 14 Oct 2025 11:46:00 +0800
Message-ID: <83dd4882-d8c6-4953-a986-af6dbf74f792@huawei.com>
Date: Tue, 14 Oct 2025 11:45:57 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 4/6] mm: cma: add __cma_release()
To: David Hildenbrand <david@redhat.com>, Andrew Morton
	<akpm@linux-foundation.org>, Oscar Salvador <osalvador@suse.de>, Muchun Song
	<muchun.song@linux.dev>
CC: <sidhartha.kumar@oracle.com>, <jane.chu@oracle.com>, Zi Yan
	<ziy@nvidia.com>, Vlastimil Babka <vbabka@suse.cz>, Brendan Jackman
	<jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
	<linux-mm@kvack.org>
References: <20251013133854.2466530-1-wangkefeng.wang@huawei.com>
 <20251013133854.2466530-5-wangkefeng.wang@huawei.com>
 <5c1fb165-cb99-44c2-b274-09419f156ad2@redhat.com>
Content-Language: en-US
From: Kefeng Wang <wangkefeng.wang@huawei.com>
In-Reply-To: <5c1fb165-cb99-44c2-b274-09419f156ad2@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.243]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspam-User: 
X-Rspamd-Queue-Id: B58DF4000C
X-Rspamd-Server: rspam03
X-Stat-Signature: 8gdfet6w381gigmofm73tjr9w4nqiuwt
X-HE-Tag: 1760413566-6914
X-HE-Meta: U2FsdGVkX18DbLoz4wLH05XARmoAVEmqLQKcDjiqx9OTIsOzL+Ie0asX86gBUCLvifMswfP3nAR37OkPYwG7SpMq2c6oSonNirz/N6E6AMPZnlqN1LbnZJknusLBUSVnsC0zMJ5V0HD/CBwu2kANMapIr+bi0Wx7L10DgBwotXincCNSxQywFyH5HlE+yZLrC2/HfhYzzQ9J/Dqmpy3DjeP9CVZE+VnlHvp3eabRerWBy7XETdysqiyQ9fi2Gg6gIoDfvUL3/jFXn81ibgJzk7DRwx3HdUCb8hjmUSIMeb5zDTyE3qPFatupduC8cgLcbr8CYv1WAl5xNRRqBvidycw25A93n02WPdNMXuP4PM5wml8aPSE62HJXQMX4gZ/7TjnTt4AmKQzvIcSPXWoGWLoRZXJWPlPD30pPMxgErrsCmF5WsumpbPpp/ngUAQc6FmVmF+ztY8nIZAGojZ34mYS3XhzPS8l0E45vLgBWOYrOz4O4hxNPurLNOFMe7LRQkDb4AD5gciCIyrsiitbzUg850YWProfY9ZdXDMlSt1/7MRgTWu66mAIbxB4uEqOYjVjN9OQoZxhnIMf4hjASdz60dEzVyeOd9z4aaIYdHSs1kwtMoeDQE8VQIDmG8tEArkfq5gAaegiFP5InzzIxttTCmoPHFWBBu3b0bdgJ+pqpfmjrLKTMvNTizmr8KOQGKHTuDTdvqS3+nscqVFwdZRRJS/B0925S14YPs5DaLgvX3yoBmJoBE32H+e3qgRMJBPvFORuyqzhDOE6JKcPlLevOEB60NQd6NnYeuoEtMm3fbXQKKg01VsyzOf7S7Nr9+HoVeOI9yuEWgSaf9imzClGyWaFXsqx8NGiAnfYoTPHkhtGLSfb6LLkcN9xZf1tJ74aMuSCD159ZZfvFwQFiW8nor7VYv2+TNB7QTH5Q8I/1CHsfZymio3rQG05dvysd3O/QP3BnrCZQBaprFbU
 JBHKnXp3
 SK2506o8H1ng/tHBZzTT6YH46hfFi58sf0RfENPJ7sNRKxSV3xcE5pVPRvcntxfdBFWQB9o3Dz1wKeQQz4I9eOVT89G0+yelS/Bd5zbzXgJJFlPlzrbrhZcO/xaFE4MCnVpyKoKFWDuKHeBxYHXgg6dB0ZnHt1Eq+x7U8IOVOVCynZiusca/londhSr98kkVaWmGHlt0v4ZnYmGWpDNq1JJoMa40lhyQYhtjDhAJp07fMbGD2t7IGnOKJypb34HHDtWt+Z4soruJXDnlNBwyupDhxWzr/kRBr7sWjuH3OYRl6juqy/r+roRwi+ZXYPekwLqlDn0mYLHtMpr+kQfluHhMN1a2wFmIYaBciYw9wiHsPep83zGJ6I7PtTr+qa1V5J6K4dmDtcwXQP4SLpdzbdNnpiBwnreH66Rvg6RrLaUxf6K5UetuGR6LoH/cUQzpgyRyhLP3xPbzACrU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/10/14 3:48, David Hildenbrand wrote:
> On 13.10.25 15:38, Kefeng Wang wrote:
>> Kill cma_pages_valid() which only used in cma_release(), also
>> cleanup code duplication between cma pages valid checking and
>> cma memrange finding, add __cma_release() helper to prepare for
>> the upcoming frozen page release.
>>
>> Reviewed-by: Jane Chu <jane.chu@oracle.com>
>> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
>> ---
>>   include/linux/cma.h |  1 -
>>   mm/cma.c            | 62 +++++++++++++++------------------------------
>>   2 files changed, 21 insertions(+), 42 deletions(-)
>>
>> diff --git a/include/linux/cma.h b/include/linux/cma.h
>> index 62d9c1cf6326..e5745d2aec55 100644
>> --- a/include/linux/cma.h
>> +++ b/include/linux/cma.h
>> @@ -49,7 +49,6 @@ extern int cma_init_reserved_mem(phys_addr_t base, 
>> phys_addr_t size,
>>                       struct cma **res_cma);
>>   extern struct page *cma_alloc(struct cma *cma, unsigned long count, 
>> unsigned int align,
>>                     bool no_warn);
>> -extern bool cma_pages_valid(struct cma *cma, const struct page 
>> *pages, unsigned long count);
>>   extern bool cma_release(struct cma *cma, const struct page *pages, 
>> unsigned long count);
>>   extern int cma_for_each_area(int (*it)(struct cma *cma, void *data), 
>> void *data);
>> diff --git a/mm/cma.c b/mm/cma.c
>> index 813e6dc7b095..88016f4aef7f 100644
>> --- a/mm/cma.c
>> +++ b/mm/cma.c
>> @@ -942,34 +942,43 @@ struct folio *cma_alloc_folio(struct cma *cma, 
>> int order, gfp_t gfp)
>>       return page ? page_folio(page) : NULL;
>>   }
>> -bool cma_pages_valid(struct cma *cma, const struct page *pages,
>> -             unsigned long count)
>> +static bool __cma_release(struct cma *cma, const struct page *pages,
>> +              unsigned long count)
>>   {
>>       unsigned long pfn, end;
>>       int r;
>>       struct cma_memrange *cmr;
>> -    bool ret;
>> +
>> +    pr_debug("%s(page %p, count %lu)\n", __func__, (void *)pages, 
>> count);
>>       if (!cma || !pages || count > cma->count)
>>           return false;
>>       pfn = page_to_pfn(pages);
>> -    ret = false;
>>       for (r = 0; r < cma->nranges; r++) {
>>           cmr = &cma->ranges[r];
>>           end = cmr->base_pfn + cmr->count;
>>           if (pfn >= cmr->base_pfn && pfn < end) {
>> -            ret = pfn + count <= end;
>> -            break;
>> +            if (pfn + count <= end)
>> +                break;
>> +
>> +            VM_WARN_ON_ONCE(1);
>>           }
>>       }
>> -    if (!ret)
>> -        pr_debug("%s(page %p, count %lu)\n",
>> -                __func__, (void *)pages, count);
>> +    if (r == cma->nranges) {
>> +        pr_debug("%s(no cma range match the page %p)\n",
>>
> 
> ".. matches the page range ..." ?

Yeah，will update， thanks
> 
> With that
> 
> Acked-by: David Hildenbrand <david@redhat.com>
> 


