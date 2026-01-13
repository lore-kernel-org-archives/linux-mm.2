Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EDC39D0C85A
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 11:38:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E62426B0005; Tue, 13 Jan 2026 06:38:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E10316B0089; Tue, 13 Jan 2026 06:38:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1BA06B008A; Tue, 13 Jan 2026 06:38:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id BDC456B0005
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 06:38:51 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 60301580DE
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 11:38:51 +0000 (UTC)
X-FDA: 84326743662.05.24DEA5A
Received: from canpmsgout06.his.huawei.com (canpmsgout06.his.huawei.com [113.46.200.221])
	by imf09.hostedemail.com (Postfix) with ESMTP id 201F714000E
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 11:38:47 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=PQgYyWIa;
	spf=pass (imf09.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.221 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768304329;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bGvDM5C0WHXLd1vEM2jXAPddIAk7oQKjeSAMr0XDWY0=;
	b=MpIlWlLxuHaLCxlm1hyu/Da2fD3PldnC77FQs4gE2yQgMBHT4E+iBNSlu36twI49vV9Z/j
	WHllIIsSaHvnbeL0jVtlNAVzIhLrLI1xH3n6wDLj+dXXC9ck9QE1NVMuz14aGclX4HPyB4
	VyIUBMhjop2Vsc/x510MPN++bg4rzXM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768304329; a=rsa-sha256;
	cv=none;
	b=fPkgtWlxD2ib8dpZwKIpUg9N7HMNC1jAJ5TNXrXJUAe4M4R5qQiVeBa9U9AHf8VP2RNjx6
	oc6k/WC4ikmrgHqO3m4zg9kXp/4U7RroFWNKWohFB3xtDaJ9tr7nXdKEofKYZFmFIsSXkg
	q5Ag932j20T9H+rt8DMFfmF4oo/9pbE=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=PQgYyWIa;
	spf=pass (imf09.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.221 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=bGvDM5C0WHXLd1vEM2jXAPddIAk7oQKjeSAMr0XDWY0=;
	b=PQgYyWIa5ZoPSDzET0W/+ISTN9XQpUtyzgpjz29tnhNhxUBfO44yf6EaA2Vz3wV7PxAikYSDN
	44wck+1BPXpujLzD2GFTRSp24N8DoKXPWf6BZPa2bhNuazVD6zUEUrqNjbppPB8zmGwYAn4BMOq
	nqXg5txD1bH0GvhsPrLIx20=
Received: from mail.maildlp.com (unknown [172.19.163.104])
	by canpmsgout06.his.huawei.com (SkyGuard) with ESMTPS id 4dr6cV1WkmzRhRG;
	Tue, 13 Jan 2026 19:35:22 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 8503A404AD;
	Tue, 13 Jan 2026 19:38:41 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 13 Jan 2026 19:38:40 +0800
Message-ID: <b0616d17-5aaf-432c-8124-902e7a592287@huawei.com>
Date: Tue, 13 Jan 2026 19:38:32 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/5] mm: hugetlb: optimize replace_free_hugepage_folios()
To: Oscar Salvador <osalvador@suse.de>
CC: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@kernel.org>, Muchun Song <muchun.song@linux.dev>,
	<linux-mm@kvack.org>, <sidhartha.kumar@oracle.com>, <jane.chu@oracle.com>, Zi
 Yan <ziy@nvidia.com>, Vlastimil Babka <vbabka@suse.cz>, Brendan Jackman
	<jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Matthew Wilcox
	<willy@infradead.org>
References: <20260112150954.1802953-1-wangkefeng.wang@huawei.com>
 <20260112150954.1802953-4-wangkefeng.wang@huawei.com>
 <aWXX2WqZ6bEpEtee@localhost.localdomain>
Content-Language: en-US
From: Kefeng Wang <wangkefeng.wang@huawei.com>
In-Reply-To: <aWXX2WqZ6bEpEtee@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.177.243]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 201F714000E
X-Rspam-User: 
X-Stat-Signature: igfhfxdixy57qy1qzrysy8nrxho41usk
X-HE-Tag: 1768304327-9151
X-HE-Meta: U2FsdGVkX18D9KT1Ci9SHPFnqOgpHdrcvOwnzs/F1CquB+GbqqUgeI2NydOMyoP6hboG1fHh8T3r2dJgSBwMfjSj/z37NP5PLSPlG/9LF5/HdSVj/echsqklKkwdNJKr0U3vOceHDqTN1bzIexiNOX6qQvL1gEagXUiNaTeX/3u4cssBAgOFDFavLwGgwpRNPqvb66FVZK926RKpvqZqTD3epWdTHEZw9rUdk34u0zXV0aCPhJerNA+1m948YCMgqVF1zcZp4IVlvydDk7WCw3Ir4oWxjbyrYi5CRRzEUkFZ1P9C87dr7FHVEWdeqL5/oMeHZeOLtN7L2P0a9c3iV1vX00ht/Ri4K7sTyh1RYpOs/OSkBFX1832IuVGPzcp9Ho3qrsaS/0w0aTUehspvAd9igiMuj/DOnv9E1MikEEo/41xlUNTeqMmub5ttOVCn8Jg3bZ0stAS/yzjz9uJeK7mW6UyuDTOVD2Km+lN4M90nuykEs5vYHWz5KdJlrptJN+uD1o1FBSDaGo/aE2KWBma1AXgMe+n9mfx3hNL3OjGE9C4YPuCXrJmP5we2GohnhR5NZ1T47Dg/sZBNVidOAj0L9hkBuY9gTbYsHp7i70qOgjcAiiNrboBU58R0SdZA4wBjL02q9RRbIjZIQOiIWQR0akt/s6Yg7XtgqV7R4ZA9sPuLskLGcFljBR1pGeMb3sIzExBXxzDU201c1nNZKt9isqprok5NWVQKTTW+H66TTUBZz+mIRQ0scfr0RUktYV0Pw7DLUcFRf0BwGqvFzBMoyIf703n1Fabf1DWablJiwPQNX+oL2DLyLGo/Nb9aZbsWn3DuluHi2BrueYq9zjRQZADdfK64FN0JHw5zVW+Vxm84v6iaRY8K4VgLQeOJPPs5+V6V5+IDnxenfz5BpwvfeM/KKFIeNGWsdm0MhOWVac2Y4RHluPnBwa1JvdJAoUGPzZgbrWOp/NSatg0
 R+wM3n8l
 BjrmfpV43NGyurKPnhjJOnMLm1b3SDv+cVwxTahNkMS0lWRslbMuh7PcHmoZC6gK89W8bA0GcDY27M/jpzPVUbMqpnpYVL8xDw9BHAwVAUMDSyYSBAfkCx5yCTrbE5yxCpAO1A3DFQBctZbT/FjkFU2bQOpFETtg9gq8iFhCUvVJ+SjmBR2MtITrD14dqKr88e9b0PcHJsZt01uTmPhBwuUeKh9afCCx8zGIkoizeNE61lkKmzQST0uBLEByF4orjH5lDx0TE2m9H7w9KAtMPoE7aW8HWNTkaDs6hCdqNlRXVdDQ4y7APM6nCqUWCfbWXhYi8cV9h5de1oQP8IsUa5Mq8qSNZ+EJAa+bqcfl00fN11Jb6Bn2dgrUtsdQAOqhja17B
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/1/13 13:27, Oscar Salvador wrote:
> On Mon, Jan 12, 2026 at 11:09:52PM +0800, Kefeng Wang wrote:
>> If no free hugepage folios are available, there is no need to perform
>> any replacement operations. Additionally, gigantic folios should not
>> be replaced under any circumstances. Therefore, we only check for the
>> presence of non-gigantic folios.
>>
>> To ensure that gigantic folios are not mistakenly replaced, we utilize
>> isolate_or_dissolve_huge_folio().
>>
>> Lastly, to optimize performance, we skip unnecessary iterations over pfn
>> for compound pages and high-order buddy pages to save processing time.
>>
>> A simple test on machine with 114G free memory, allocate 120 * 1G
>> HugeTLB folios(104 successfully returned),
>>
>>    time echo 120 > /sys/kernel/mm/hugepages/hugepages-1048576kB/nr_hugepages
>>
>> Before: 0m0.602s
>> After:  0m0.431s
>>
>> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
> ...
>>   int replace_free_hugepage_folios(unsigned long start_pfn, unsigned long end_pfn)
>>   {
>> -	struct folio *folio;
>> -	int ret = 0;
>> +	unsigned long nr = 0;
>> +	struct page *page;
>> +	struct hstate *h;
>> +	LIST_HEAD(list);
>>   
>> -	LIST_HEAD(isolate_list);
>> +	/* Avoid pfn iterations if no free non-gigantic huge pages */
>> +	for_each_hstate(h) {
>> +		if (hstate_is_gigantic(h))
>> +			continue;
>> +
>> +		nr += h->free_huge_pages;
>> +		if (nr)
>> +			break;
>> +	}
>> +
>> +	if (!nr)
>> +		return 0;
>>   
>>   	while (start_pfn < end_pfn) {
>> -		folio = pfn_folio(start_pfn);
>> +		page = pfn_to_page(start_pfn);
>> +		nr = 1;
>>   
>> -		/* Not to disrupt normal path by vainly holding hugetlb_lock */
>> -		if (folio_test_hugetlb(folio) && !folio_ref_count(folio)) {
>> -			ret = alloc_and_dissolve_hugetlb_folio(folio, &isolate_list);
>> -			if (ret)
>> -				break;
>> +		if (PageHuge(page) || PageCompound(page)) {
>> +			struct folio *folio = page_folio(page);
>> +
>> +			nr = folio_nr_pages(folio) - folio_page_idx(folio, page);
>> +
>> +			/* Not to disrupt normal path by vainly holding hugetlb_lock */
>> +			if (folio_test_hugetlb(folio) && !folio_ref_count(folio)) {
>> +				if (isolate_or_dissolve_huge_folio(folio, &list))
> 
> isolate_or_dissolve_huge_folio() can also return -EBUSY, but you supersed that with
> ENOMEM in case it fails. Is that alright?> Maybe it is because down the chain we ignore the type of error as 
long as it is
> an error but just brining it up because the log now differs.

The caller(i.e. virtio_mem_fake_offline) may perform some operations
based on different error codes, I will restore this one.

Thanks.



