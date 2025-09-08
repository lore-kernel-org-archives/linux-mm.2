Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74942CAC581
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 12:59:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE5478E001A; Mon,  8 Sep 2025 08:59:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C95D58E000E; Mon,  8 Sep 2025 08:59:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B5CD08E001A; Mon,  8 Sep 2025 08:59:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A05E78E000E
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 08:59:10 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 51A73137FA7
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 12:59:10 +0000 (UTC)
X-FDA: 83866088460.10.F1BFD70
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	by imf23.hostedemail.com (Postfix) with ESMTP id B7F6F14000D
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 12:59:07 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=none;
	spf=pass (imf23.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 45.249.212.190 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757336348; a=rsa-sha256;
	cv=none;
	b=5mpLvTZtfiFD8xwp3lnhYAyhzNnYeESOeKtPKGEww4su4SUtbDidH5FfqcaWp2IGQ+/XXS
	+0goQzazOK+BeWPaLhhvs9u0KJTW90q2H8ZVbi3GjTMRxoiLotDNjWAUsthNlGKKNaHQcP
	LigacdziZDrcizv+oYnlC4TAeEYB1tM=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none;
	spf=pass (imf23.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 45.249.212.190 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757336348;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=U6tCMorUCUNFXLC3i5jZQVVZEW65yVT5DXtucMvFhpU=;
	b=w8deSXhcjD7ISzFwppDJrjgtr5GBlXPpzK9tycb+Nn+VjVYSVQ4UBDmk9oBjqu4FSPSgYI
	QuwJaLgxAeJsa5b5/4efFeN83DYP3eAhB4qa02XWXmi1sAvvfTO+X2ZE9KAd0CLsElrGeo
	WZ9SVwOcFIJ6Q8l2fDL8JZ9e1rqrZDE=
Received: from mail.maildlp.com (unknown [172.19.88.234])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4cL6Py2hxNz2TT9R;
	Mon,  8 Sep 2025 20:55:50 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id E6B871401E0;
	Mon,  8 Sep 2025 20:59:03 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 8 Sep 2025 20:59:02 +0800
Message-ID: <066bf2b2-e91d-4559-9621-3ea9ebb020f7@huawei.com>
Date: Mon, 8 Sep 2025 20:59:01 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/9] mm: hugetlb: convert to use more
 alloc_fresh_hugetlb_folio()
To: Oscar Salvador <osalvador@suse.de>
CC: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@redhat.com>, Muchun Song <muchun.song@linux.dev>,
	<sidhartha.kumar@oracle.com>, <jane.chu@oracle.com>, Zi Yan <ziy@nvidia.com>,
	Vlastimil Babka <vbabka@suse.cz>, Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, <linux-mm@kvack.org>
References: <20250902124820.3081488-1-wangkefeng.wang@huawei.com>
 <20250902124820.3081488-2-wangkefeng.wang@huawei.com>
 <aL6gJPvzXqzrVZTG@localhost.localdomain>
Content-Language: en-US
From: Kefeng Wang <wangkefeng.wang@huawei.com>
In-Reply-To: <aL6gJPvzXqzrVZTG@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.243]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B7F6F14000D
X-Stat-Signature: wsr9iugrmtzchazf6spp8gof53gk8fmq
X-Rspam-User: 
X-HE-Tag: 1757336347-617313
X-HE-Meta: U2FsdGVkX182qvMSe5QaKuQCXRx2amyC0GaWcDjpSPcNAC34w0wg8VohPGN5K7Q/rvQrDhDrMkZ4jbfkILdLmKHqvL5pj2ndSGrQmmHbdylF/ZgoMbEagxZZzagZPBeLka/1B7itOQWUwLw3/OnHRypXvJWvd+QdwdSVwxrcLzGKKEcmZXVrxXfUWUDOytl46B9vkPwoFhH5b4j6g6EDaOLwAt+FIdGx7thxL4jcdOcgZT+sTxJzBP11yiG7Dry8GeITlxZ9elCueK9Z8QRVD19RaimbbukaA2jPUJynH4OEvwfZ8VfENAjvPCS8zTrq1ioW64fl+Gg4wqH5FR8x7k6IN6wjY9Xu2xJ5IZuLkj9heqQDsNqpgC39N1AJ36KszTNCqY6FdZOAWU5xBjiVOVjYe3euk8cZfdlGQeG/SVmK0+021p+acl23ArgSbhaUPC27D5X75g+hyLMzgHHSk/qYrbYuirKye8Hlr3ZyGmwvjJmW7UI1Ao1u31glyK31pgX3XoehaOAc/5RomvUj8fC2nJ9m7WaBL0YBW4JVgXltX9Q7MYmNeA2rBQCCE1UdDJO2w07Sll7sJlpJYHHTwDTzpp1xRJ4lZl4H6mZyPPK0M3D7GA+izlsyRW8MV3OABKV3JLqFKfPPWFiCtOGCt949ujMpK/hKiUTKLv5MsjEImbTNw0zGLSSRl0ZxK0XQMM5YrAYQN15yhaHTZL/vNyYW7qcHQQi9qH5ylH6SMjaFSzj32v6+hBoPAVEChGPCAxzC78GH+7E5+dhVHUuh+NzCTfMmfgNREP0wYjvCR/bUH7AuLs56bUDKHiwO0QzVrVb7k8Za+feuQHu5kK5YCNCc1UqL3UVwraVeIO+V1nVYAEvJ7kinMLHLpbDzi/NFVMPVvPuAqQrSAhoxfJn0Ca85CcqEGjybhRf/2JOsLroBYgneEvdUt/zypV+6WAZpnDG+QcrOFjzN2W3ku68
 K1ARAn0M
 Xm5tj9uQNXSIx9w8jsjdR8SCQNOfIpyXmAY1eBGqKWjyIBaF2eG3+vv4tjctW4legKrNap/HhKtKc6LVYYe6EH5GNW1IARine5KT3grWTGpM4kYDe/9idTKt7hUbfdmD84Esx+auQxBr2TUfg3w0s/qoeFgYiKm+uqISY5KzqFaVdwsxY7F8y+BS4BKXwt8mo9BzfPcGC8iw+C+DAtf/h/IL6a2Oe14yagNHmbypxOIFsa9Q/EMLaebmmGT/jwTkJ0ymPW6N0e6Q3DWOoo+XMGhmw2pduKjzhIpk3PWNeAe7l7nugnAnSMpzBpU1APx5RSX+5Au0mZyiK77D928j5kY5FvQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/9/8 17:21, Oscar Salvador wrote:
> On Tue, Sep 02, 2025 at 08:48:12PM +0800, Kefeng Wang wrote:
>> Simplify alloc_fresh_hugetlb_folio() and convert more functions
>> to use it, which help us to remove prep_new_hugetlb_folio() and
>> __prep_new_hugetlb_folio().
>>
>> Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
>> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
> 
> Acked-by: Oscar Salvador <osalvador@suse.de>
> 
> But...
> 
>>   /*
>> - * Common helper to allocate a fresh hugetlb page. All specific allocators
>> - * should use this function to get new hugetlb pages
>> + * Common helper to allocate a fresh hugetlb folio. All specific allocators
>> + * should use this function to get new hugetlb folio
>>    *
>> - * Note that returned page is 'frozen':  ref count of head page and all tail
>> + * Note that returned folio is 'frozen':  ref count of head page and all tail
>>    * pages is zero.
>>    */
>>   static struct folio *alloc_fresh_hugetlb_folio(struct hstate *h,
>> @@ -2016,14 +2002,9 @@ static struct folio *alloc_fresh_hugetlb_folio(struct hstate *h,
>>   {
>>   	struct folio *folio;
>>   
>> -	if (hstate_is_gigantic(h))
>> -		folio = alloc_gigantic_folio(h, gfp_mask, nid, nmask);
>> -	else
>> -		folio = alloc_buddy_hugetlb_folio(h, gfp_mask, nid, nmask, NULL);
>> -	if (!folio)
>> -		return NULL;
>> -
>> -	prep_new_hugetlb_folio(h, folio, folio_nid(folio));
>> +	folio = only_alloc_fresh_hugetlb_folio(h, gfp_mask, nid, nmask, NULL);
>> +	if (folio)
>> +		hugetlb_vmemmap_optimize_folio(h, folio);
>>   	return folio;
> 
> We no longer do the accounting in the callee but in the caller, so it might be
> tricky to grasp why.
> I would add a comment above after the "Note that returned ..." stating that the
> accounting must be done in the caller, should someone else add another call to
> alloc_fresh_hugetlb_folio().
> Hugetlb code is tricky enough, let us make it crystal clear.

OK， will a comment in next version.

> 
> Thanks
> 
> 


