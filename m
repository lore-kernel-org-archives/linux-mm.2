Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AAB4C87FCB
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 12:13:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 80C378E0111; Tue, 12 Aug 2025 08:13:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7BDA08E00E5; Tue, 12 Aug 2025 08:13:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6FA9C8E0111; Tue, 12 Aug 2025 08:13:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6045A8E00E5
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 08:13:25 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1461D58333
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 12:13:25 +0000 (UTC)
X-FDA: 83767995570.10.DFF1AEA
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	by imf14.hostedemail.com (Postfix) with ESMTP id 533C9100007
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 12:13:21 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf14.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 45.249.212.187 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755000803; a=rsa-sha256;
	cv=none;
	b=HD1khf4XcmRolw3/XQoBG1mSpX4hGDAFk13xwak3DMjoeyktiFUh/tiGy9Xp+aQRetZmzl
	pPN5FMcaaltOfn6cIwCFNx+zlr0jHsig/A+c1fQ+zreZtXCTaPcAFvksHFVNe+k7foa6Fh
	2LSHnriB2LMZkgEKS5l7QIG57MSlCu0=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf14.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 45.249.212.187 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755000803;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yOFb4ZPQJ6h9N/2lvSchKVHPrgG042ezUq7ePL6gnLU=;
	b=arxUk8Qovpqll776E8lIhj935eq9sLYFIwY0XIPMQdiUprnEfXGW9ahBq0FbejgiOASpZ9
	7QpSBnX4f+4qEpWQHHTzGPAUqocyredwqYpwhQgDS5SAcZzViowI2t4zWWcmo5bd8cK5/Y
	bmJofq12cUkuhTYwKmedAo9cUO4fsNU=
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4c1VgJ5sxhz13MdL;
	Tue, 12 Aug 2025 20:09:48 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id D83BF18007F;
	Tue, 12 Aug 2025 20:13:11 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 12 Aug 2025 20:13:11 +0800
Message-ID: <330622c0-1ef5-4b61-a3dc-a8f5717e12c3@huawei.com>
Date: Tue, 12 Aug 2025 20:13:10 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: Re: [PATCH 6/7] mm: hugeltb: check NUMA_NO_NODE in
 only_alloc_fresh_hugetlb_folio()
To: <jane.chu@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, Muchun
 Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, David
 Hildenbrand <david@redhat.com>
CC: <linux-mm@kvack.org>
References: <20250802073107.2787975-1-wangkefeng.wang@huawei.com>
 <20250802073107.2787975-7-wangkefeng.wang@huawei.com>
 <dd8a3a65-a9c1-41e0-90c6-99c2ea6d9f6a@oracle.com>
Content-Language: en-US
In-Reply-To: <dd8a3a65-a9c1-41e0-90c6-99c2ea6d9f6a@oracle.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.243]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspamd-Queue-Id: 533C9100007
X-Stat-Signature: s1obgtgnu7s8pdos1ibf33ci51uiu5x1
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1755000801-198495
X-HE-Meta: U2FsdGVkX18uko16a2ikn7U8zfuF9q1VbgVIkCQ6I2U9QWQWg1kBQbBdxH8Ty2Ws4hh2GMusBZPKgxwU2dJqiZ9bda1t3r0F196dv4rrHgivvG4p8fO5mZeSDBG6T8KU4xNDb4fbpIdRo5MbORxU8HOCOqR2QVUFQTqwdwuEtTLHHuckAYyp6MOUm7qT/L8hIhdTSmEkLV3UD2e2paXjRr4JolA0P10zHhBw8UzLGZqaWjCryxvNjY2sMHRr7DVAt8B66bIvBAgurw+B0TgtzbYWAV2k8nm1kddJEkh6DVumcSuiJD8wjkyiK91kg9K/C2hF1mkTHZZm/ncI8SeFRrKia95jz/RnkSvXDbQzCKM6MyI+7dXHRTYygiFmUEP4EkXHXQ8xj7UJnCJ4e8rukECx2HQQcCnJDfRoOpV/GlEx5wyZt4rNd6mAh8d9aUnShXS4AfPIJsA2rSLaUB7mAJyvrBJ+539pn9fQmztNT7Y2q91C/cOwRVwHhXLfF64vcy6f60ooK4Nc9RM4gAb3bDYmLZqLzSsIEnmP4jQXMQInZfZxR0J0ororQ0pnZNy1kciF58ogiJ6NeWOvIB9qVOZU9Rffi/XRwKo8dsZ0JP/qpL8zaxJJ7FX1s6ygdTdvFGcUDgu3/t2nbJA/9QaJw2umvHdHpl2Ooj7eWNnRnCpDD9zNiE3gvPLbt44MjuW1GWPuP1B1OFQ906grsgiM7E3pOGKCwjzh1JotnO2F/bcc9hIOlbI+kN0fdHpA7nCLnm2dVw9GKXBVgMaJgYSRyp6opM2qbLapC08O1W/bEHquKp3nveAWa0bW/IP7k5NEtN8y7GTs71TGJYODZvvS9YL14fr7E1IFVVPazmxzrIBRltj0cOxTFdK0ieLOM+zs13GgVEg5LA/Ec1MA24qBp4VZYYapXrRmTH2Ct8X6U8CuUFfxPT8I/Imaam4xWTVcqi93244TGK7wMvP1xu1
 tfq0iYZW
 a+zJuhBX9rvcONcROyl1Rz68dhwbKBwxbdFLaKdA3tpThYmxGsvAsnRbEfVPTFDXdipUqNG9K9M+h0eJP8Cni5s0TFpknu6CuRmp3+t9aC1gmeeSMftQi8CoMluz5SqEEG947k19hZol4wiQdi92pxT8vXJwR7H3kS7CGBCXYUldIR+RFWfSwDJ4wl3GYzIRJHBxfsCG5KNXe6pE9uqiphcOrMRyaGLcuawJ9mnT4JM3nABw8W/W7l3NJkqHmxopDHRDM+7rWI7nH8gjqw4/0E88xDrcqXEmbUQfBJd8yS9Qj20DVShrRcBTu/G5RtFx6V7fjcPceoTo0i/w=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/8/7 4:43, jane.chu@oracle.com wrote:
> 
> 
> On 8/2/2025 12:31 AM, Kefeng Wang wrote:
>> Move the NUMA_NO_NODE check out of buddy and gigantic folio allocation
>> to cleanup code a bit.
>>
>> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
>> ---
>>   mm/hugetlb.c | 7 +++----
>>   1 file changed, 3 insertions(+), 4 deletions(-)
>>
>> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
>> index b16011c9645d..4f73b74a2cff 100644
>> --- a/mm/hugetlb.c
>> +++ b/mm/hugetlb.c
>> @@ -1479,8 +1479,6 @@ static struct folio *alloc_gigantic_folio(int 
>> order, gfp_t gfp_mask,
>>       struct folio *folio;
>>       bool retried = false;
>> -    if (nid == NUMA_NO_NODE)
>> -        nid = numa_mem_id();
>>   retry:
>>       folio = hugetlb_cma_alloc_folio(order, gfp_mask, nid, nodemask);
>>       if (!folio) {
>> @@ -1942,8 +1940,6 @@ static struct folio 
>> *alloc_buddy_hugetlb_folio(int order, gfp_t gfp_mask,
>>           alloc_try_hard = false;
>>       if (alloc_try_hard)
>>           gfp_mask |= __GFP_RETRY_MAYFAIL;
>> -    if (nid == NUMA_NO_NODE)
>> -        nid = numa_mem_id();
> 
> Looks like you're also fixing a bug, because the code block was
>          if (node_alloc_noretry && node_isset(nid, *node_alloc_noretry)) 
>   <--
>                  alloc_try_hard = false;
>          if (alloc_try_hard)
>                  gfp_mask |= __GFP_RETRY_MAYFAIL;
>          if (nid == NUMA_NO_NODE)
>                  nid = numa_mem_id();
> in theory, NUMA_NO_NODE (-1) could be passed as 'nid' to node_isset().

alloc_surplus_hugetlb_folio/hugetlb_hstate_alloc_pages_onenode call
alloc_buddy_hugetlb_folio with node_alloc_noretry = NULL, and
alloc_pool_huge_folio call alloc_buddy_hugetlb_folio  with nid != 
NUMA_NO_NODE, so no issue for now, but we move it ahead which avoid
the possible issue in the future.


> 
>>       folio = (struct folio *)__alloc_frozen_pages(gfp_mask, order, 
>> nid, nmask);
>>       if (folio) {
>> @@ -1976,6 +1972,9 @@ static struct folio 
>> *only_alloc_fresh_hugetlb_folio(struct hstate *h,
>>       struct folio *folio;
>>       int order = huge_page_order(h);
>> +    if (nid == NUMA_NO_NODE)
>> +        nid = numa_mem_id();
>> +
>>       if (order > MAX_PAGE_ORDER)
>>           folio = alloc_gigantic_folio(order, gfp_mask, nid, nmask);
>>       else
> Looks good, thanks!
> 
> Reviewed-by: Jane Chu <jane.chu@oracle.com>

Thanks.


