Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C79ED64085
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 08:02:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9FAE06B00AC; Wed, 17 Dec 2025 03:02:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A9166B00AE; Wed, 17 Dec 2025 03:02:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8AB9C6B00AF; Wed, 17 Dec 2025 03:02:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7915A6B00AC
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 03:02:51 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 24575136CB6
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 08:02:51 +0000 (UTC)
X-FDA: 84228221742.05.27A7B16
Received: from canpmsgout05.his.huawei.com (canpmsgout05.his.huawei.com [113.46.200.220])
	by imf03.hostedemail.com (Postfix) with ESMTP id E07892000A
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 08:02:46 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=0FqlLm9j;
	spf=pass (imf03.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.220 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765958569; a=rsa-sha256;
	cv=none;
	b=79bMpbjkVHoYmi+5fLS32UkNOtD+VnQndVffXDbEda/GRIxU3U0g4xj5nDGDt+Edn0q6Od
	2DX04cNVdv1NX3DAjg4l4Ag4oqSWBOidbBqkdCTHysODZgFckQVQyRRIM/lWkaMDFaSMfW
	fbZiLLjwCGSDXf4ZmYTGhElfxhwM5D4=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=0FqlLm9j;
	spf=pass (imf03.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.220 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765958569;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rdZziF7eV1SyePx1vjEWwL3mwaoUJ/Cvf+ZIo7Fz79Y=;
	b=iUz9tv3nUALrYPh9ThQ3VWnt3SX6JWxZGonL6CrRbx3wxqIJgmiKVmyT9x50Q80MrztcAW
	NvDvlzR+YD3tKkBqcILsRfjip24u8ioZHoXdsi6JbPmcE6B6fp2nJCoYegoMLmk9f4EfS7
	2PkVNaOciYkHaby3t/K8ZSeq4oagrng=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=rdZziF7eV1SyePx1vjEWwL3mwaoUJ/Cvf+ZIo7Fz79Y=;
	b=0FqlLm9jsmX4NUWmrlq8d23dM/OhZZRuimM7CafiilUofTwa+gpm6HV7O3rcVwf+Ek99ocp5e
	S8PmiO4GEo74Z1FUmh92jWKDDKQuq77hGfEZrJC9fPDLc9gtA+YaT0p5cKle0gggEaE2j6bSaCI
	S6eTnGjfSWhR9yW6vzcu8ak=
Received: from mail.maildlp.com (unknown [172.19.88.194])
	by canpmsgout05.his.huawei.com (SkyGuard) with ESMTPS id 4dWR7027Xcz12LDy;
	Wed, 17 Dec 2025 16:00:28 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 167D71401F4;
	Wed, 17 Dec 2025 16:02:42 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 17 Dec 2025 16:02:40 +0800
Message-ID: <0eb081b8-3982-48aa-a9ba-9cdde702b4df@huawei.com>
Date: Wed, 17 Dec 2025 16:02:39 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 5/6] mm: cma: add cma_alloc_frozen{_compound}()
To: Zi Yan <ziy@nvidia.com>
CC: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@redhat.com>, Oscar Salvador <osalvador@suse.de>, Muchun Song
	<muchun.song@linux.dev>, <linux-mm@kvack.org>, <sidhartha.kumar@oracle.com>,
	<jane.chu@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, Brendan Jackman
	<jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Matthew Wilcox
	<willy@infradead.org>, David Hildenbrand <david@kernel.org>
References: <20251216114844.2126250-1-wangkefeng.wang@huawei.com>
 <20251216114844.2126250-6-wangkefeng.wang@huawei.com>
 <4B10600F-A837-4FCA-808D-6F8637B073F7@nvidia.com>
Content-Language: en-US
From: Kefeng Wang <wangkefeng.wang@huawei.com>
In-Reply-To: <4B10600F-A837-4FCA-808D-6F8637B073F7@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.243]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspam-User: 
X-Rspamd-Queue-Id: E07892000A
X-Rspamd-Server: rspam04
X-Stat-Signature: zk8uubwd9hc5rbti71jrpe9k9xfxutkb
X-HE-Tag: 1765958566-428278
X-HE-Meta: U2FsdGVkX1+8SD1ndka7+wpVQ9XeBVJpjWEbuLW+xDY7iPvvFaIwLPUzKE8K0sGujBDshPjHAqvCEeFv/38+Go+f6yJI72+fsFA5fXHpfkp3BWJNVum0ENx4F7QBOYOnNBISQzkRq76T6hOQqW3spmqFVCSXdGL3KAJkvFS6Xmr8tSQDeJjtCOXoUKLCuidBgUlsaHTGrhLF3cqO2BUZe03TEfQaZVDqb/Z3aLZpmJ3hKZucsZ7HsYRTlU991MgiPE+g8OqvBcYVeBaRb7amG6MtGQnZAIZjA/uHo1cE3WleEjMwAdkAtPKgos4oK9eY+z1b+Q6jEX39vXsG+y1KI6D6EKE2IUo5hcKBq8femxUvGNOtqrGKQstKtD+oe+5dE4+Z8NSbLS0K2B/JDAXKZiRd2K8yEeMkMlrtdU6lpb34YiIeKMqddc1glkQ5sUz3XC/IdsBolrC5HQLc2rzoYUmbdVb0hULuiWmYOUKIkB0oxe0ufctGmvrpaiZNIHUnQoU8GX4nMRNOGsjWvCS2/Q1fZFMVoejJMglY0yVSij5dDaUwTWMRAm4usLsTPfYBW6ejTQ5ZNJjPSZWodxLnGKfyBkl7zm7nIreWic2WKtjitNGQIGhHyn+gk+KmncQJzGH8W1ZRFyBEV3i/qcS15peA1HB2LmtfOuDC9KA22xW7YH7HjIsDulCHSFL/m/VyHL0eEk9yJN+DCPF0zB1WfPKXYgZsSawRwRMHBjePOwNpiWOOWH5HNB9IN/h7kH7ZO8vDpC7SchSVacjpw3PGOWcnl9eohtZRYiCD8ezB9Hrdq3JswjltcxTPH1ZAbhrwv63FPkCzBQi4WHlLYxjKDMJzswOIVLiPv448gF491Qd05+ccGMiOskpYS0kTCj4B9HvWPfaq+is182jfMwcaB2Yuk9eRia8df+a9IRHTXhsIo9pFC6ISjh5oHQqVkLhmzEFm0wDORlO1u1YabZq
 GzYHdDRe
 UmQoyEf/64JHenAgedt5DIaLylVXOoTgfVAj3DpQFeHjdMzhZw7PGy6e10hDbRZgpdWEcm4ZoKo0TM41eW8Eg0AqLNo9dtjn7tDRDz4U84TgfeeRcjt3KylTtUnFn7s4CAN/XrWTjcH2YSDQq53rPrSRR5C/fJTnLSNX+uXibh/4v8dEfJm4BF0aXwGCVTn49eD5fcGuMjhUWn27F3Zsz8ILSTfqU1dgKzJDHDTKyYP3J0LzVgfjD2Hq2lEtjyJRlN5DtYQy/rSUEADhxrrSId7aacDYedg8sUeiWEBRleAylbDsSQCqMkZPMEeRm2e6CmTX5tdQt5NWxROkwUYww7/odbQp2knNCK/7lCitgA5S99as+pfceT/M67/w6a6/KvPRdRrMPS+gisQ6e6NtrQb+EWGYsk1X3E6I1
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/12/17 2:40, Zi Yan wrote:
> On 16 Dec 2025, at 6:48, Kefeng Wang wrote:
> 
>> Introduce cma_alloc_frozen{_compound}() helper to alloc pages without
>> incrementing their refcount, then convert hugetlb cma to use the
>> cma_alloc_frozen_compound() and cma_release_frozen() and remove the
>> unused cma_{alloc,free}_folio(), also move the cma_validate_zones()
>> into mm/internal.h since no outside user.
>>
>> The set_pages_refcounted() is only called to set non-compound pages
>> after above changes, so remove the processing about PageHead.
>>
>> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
>> ---
>>   include/linux/cma.h | 26 ++++++------------------
>>   mm/cma.c            | 48 +++++++++++++++++++++++++--------------------
>>   mm/hugetlb_cma.c    | 24 +++++++++++++----------
>>   mm/internal.h       | 10 +++++-----
>>   4 files changed, 52 insertions(+), 56 deletions(-)
>>

...

>>   static bool __cma_release(struct cma *cma, const struct page *pages,
>> -			  unsigned long count, bool compound)
>> +			  unsigned long count, bool frozen)
>>   {
>>   	unsigned long pfn, end;
>>   	int r;
>> @@ -974,8 +982,8 @@ static bool __cma_release(struct cma *cma, const struct page *pages,
>>   		return false;
>>   	}
>>
>> -	if (compound)
>> -		__free_pages((struct page *)pages, compound_order(pages));
>> +	if (frozen)
>> +		free_contig_frozen_range(pfn, count);
>>   	else
>>   		free_contig_range(pfn, count);
> 
> Can we get rid of free_contig_range() branch by making cma_release() put
> each page’s refcount? Then, __cma_relase() becomes cma_release_frozen()
> and the release pattern matches allocation pattern:
> 1. cma_alloc() calls cma_alloc_frozen() and manipulates page refcount.
> 2. cma_release() manipulates page refcount and calls cma_release_frozen().
> 

Have considered similar things before, but we need manipulates page
refcount only find the correct cma memrange from cma/pages, it seems
that no big improvement, any more comments?

1) for cma_release:
    a. cma find memrange
    b. manipulates page refcount when cmr found
    c. free page and release cma resource
2) for cma_release_frozen
    a. cma find memrange
    b. free page and release cma resource whne cmr found

> The rest of changes looks good to me.

Thanks.
> 
> Best Regards,
> Yan, Zi
> 


