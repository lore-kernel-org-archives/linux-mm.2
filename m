Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D35EFD6ACFE
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 12:54:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 42EB06B0088; Thu, 18 Dec 2025 07:54:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3EFF66B0089; Thu, 18 Dec 2025 07:54:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 301CC6B008A; Thu, 18 Dec 2025 07:54:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 236B86B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 07:54:33 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C76B31DEA17
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 12:54:32 +0000 (UTC)
X-FDA: 84232585584.16.1704802
Received: from canpmsgout10.his.huawei.com (canpmsgout10.his.huawei.com [113.46.200.225])
	by imf06.hostedemail.com (Postfix) with ESMTP id 0511D18000E
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 12:54:28 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=HGgFihqd;
	spf=pass (imf06.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.225 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766062471; a=rsa-sha256;
	cv=none;
	b=L+7Ae38LlTRjwgH0/TQDPWrD9guwjjCV+qkLYW90eAWwSlOBnzX1c/hnb0iQ5uOZphHAZI
	EI6/2yJ4/EyMyseX9Nz+VarVy6B9gyF6vQ+TGpttcsMHUTEPZm0/up0rIGeO01fRxi4LTB
	iRxZxKMQE+xGwtMcKeQRRc0y40jLV1E=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=HGgFihqd;
	spf=pass (imf06.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.225 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766062471;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DNE/oqQPqSuacojKiJOF90rLiaQVdMM5emi/fs6Pl94=;
	b=D8EBEbhvsGfosSi3tCtEDm+tTiMOCw3ergXmeqeAvi/9EjpDRNUGAKMLbxwOa2Ei0f6UUU
	oQWsrXYcvS0qwdx3VbNyy869Klfji72E0rY5IbBR4KCQ4eOv9IaPGL4l9l3JAG4IvXbDTF
	AEKLsS19h3YDTaohNXQy14M1/OXeSs4=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=DNE/oqQPqSuacojKiJOF90rLiaQVdMM5emi/fs6Pl94=;
	b=HGgFihqdRZj5LmEdb4yfHkge/H7zRhog/MkgMULyyHMYMb672JVW7TZClQca43cvt5QAs4z2h
	ZK9ZhdhmerH/7bB90FFWY0UtuFAopFXQdOVnO5hAMbLaLzcnXDiZiJvHEgTCoQFLx6lyl2zFK34
	PZ12IC726sDGqsnoDaAGuLc=
Received: from mail.maildlp.com (unknown [172.19.163.17])
	by canpmsgout10.his.huawei.com (SkyGuard) with ESMTPS id 4dX9X837zgz1K98s;
	Thu, 18 Dec 2025 20:51:20 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id BA8AA1A0188;
	Thu, 18 Dec 2025 20:54:21 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 18 Dec 2025 20:54:20 +0800
Message-ID: <6e7df7a8-aaf4-4960-82be-dea118c5955c@huawei.com>
Date: Thu, 18 Dec 2025 20:54:19 +0800
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
 <0eb081b8-3982-48aa-a9ba-9cdde702b4df@huawei.com>
 <A276ED1B-89C8-45A0-8DA9-9D5CA1D8E2FF@nvidia.com>
Content-Language: en-US
From: Kefeng Wang <wangkefeng.wang@huawei.com>
In-Reply-To: <A276ED1B-89C8-45A0-8DA9-9D5CA1D8E2FF@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.243]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspam-User: 
X-Rspamd-Queue-Id: 0511D18000E
X-Rspamd-Server: rspam04
X-Stat-Signature: fz5bi7rekatt6tip5uucjarwz1qmcnto
X-HE-Tag: 1766062468-15452
X-HE-Meta: U2FsdGVkX183Pb8KodJvft86m/u8NloA1iG6oFukGpSCXK0Nv/PiWnmv6Sx/XVFoGj6p2v37yy8iWo04tnrD7nfpSdsGXybdXEqy6QcWOPp2mtQfvULWpnJh0NFXHq8heicForhxBtvmwA+dhU4Cr49apXpTOXVjjcUku8Nb037OaYL89LjT+X+yK5FR4Bqztjq9xn13DxKwc7YC3lQpRygElyxRm7Z4hGAM3jsAdNDaISz7A8SlAgYwmkusI6HAaREsTc2zr3TmsLKgHG0IZCNXKawYxx9YmzyOEzSzFpxNamHDkBbiKplxkprxXU61jBBcd5C7HQomojTLT2Va/8DMWman26XaBdsDME5A318RSOCsm4KEorY4LO1wa7qFTvIBj+X07zOM69xzz4VWpnzMOACduGcaO/cOvrc+YkNpZKDfO0wTmOyaEEjwqwgqzXtExuyJKaZb0awyKeIz0B75tWIRM11k1ch4gRojrWwoyriTkbpgE4fSHOmK1XStT3buOF8tXSEVTbj+3XuaV2bNN9/x+QKosEHtRaZKHQhgEw1WfomkJYcT53AQcU1io9UAtoMhSlnwopqS2+iB7rxtOpfdBr6J493Y8/gg0dbvdMfBVS8SodArP0xZ4AWCBYFd1AGCebJOzjiNNfhXeJhfLfqrdo0cyKCbvT4FiOatXdl3/anD4k7Er2fN4AavMLYb2QplS/YyqWedm9hPkQ+JU6yohjsa1/sfe/Pp6lNoXnOYAWXyqQ3s8l2MBV7UjuVMUoUz7hK8NoNsgovQN5BZPGSU+qcgaFWaDNt/xbdt2VhyKVjt704ZgonrPHQ2d7DbbzB2kt6Y9Ihy45sn3dgpdbsXAMaqoN9orv+2wiXVLBC5DCZnGQ6oIISPD7eXLAHOku6Xsyv4nOimTBGmJpGtLfJbqlYv/Q7fYTp88vGGzCsyJZLg+0ifj9g6j02ZkVf2uesDp08ChMVmM41
 NQngLoJU
 9C1e6u9/ByQlnK6g2K/q9IFPgkTIv7i4u82gkyR2u7y/HcinNAnp5aISvyJ1y5jUahpyZg7bN2egJxIGJdqYbIcb5SYRfWjxCABuu2z0llrAwDTp6zl7VQhWn6aVYVcqEmEgBXwYUTiggpKUcKeIh39GPdOBSgWOkg5A0Udsy7N0JxZHnEd5pVaaaUgqXkHevkBTBuFSU0OSmVhaUsaQzRRx6M5BTNggWdJGXUFaMI8d4vfisTnb7pmmrWLUwrHkZovAgJ0RuavgX9PBz5ywJM2QwhD3hl4FLjJW4CS/aUqHn04uURoHQV/ncTlg8pjGICq2uiP3W3OD1NgO/wVIB/Jae44MvAuWm/FJYKzqcZ522R987XA0k81qO+YkpW5IAg+9FAkKK2PdttDbwq1bkVdmXsEdqciL1Ih1j
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/12/18 3:38, Zi Yan wrote:
> On 17 Dec 2025, at 3:02, Kefeng Wang wrote:
> 
>> On 2025/12/17 2:40, Zi Yan wrote:
>>> On 16 Dec 2025, at 6:48, Kefeng Wang wrote:
>>>
>>>> Introduce cma_alloc_frozen{_compound}() helper to alloc pages without
>>>> incrementing their refcount, then convert hugetlb cma to use the
>>>> cma_alloc_frozen_compound() and cma_release_frozen() and remove the
>>>> unused cma_{alloc,free}_folio(), also move the cma_validate_zones()
>>>> into mm/internal.h since no outside user.
>>>>
>>>> The set_pages_refcounted() is only called to set non-compound pages
>>>> after above changes, so remove the processing about PageHead.
>>>>
>>>> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
>>>> ---
>>>>    include/linux/cma.h | 26 ++++++------------------
>>>>    mm/cma.c            | 48 +++++++++++++++++++++++++--------------------
>>>>    mm/hugetlb_cma.c    | 24 +++++++++++++----------
>>>>    mm/internal.h       | 10 +++++-----
>>>>    4 files changed, 52 insertions(+), 56 deletions(-)
>>>>
>>
>> ...
>>
>>>>    static bool __cma_release(struct cma *cma, const struct page *pages,
>>>> -			  unsigned long count, bool compound)
>>>> +			  unsigned long count, bool frozen)
>>>>    {
>>>>    	unsigned long pfn, end;
>>>>    	int r;
>>>> @@ -974,8 +982,8 @@ static bool __cma_release(struct cma *cma, const struct page *pages,
>>>>    		return false;
>>>>    	}
>>>>
>>>> -	if (compound)
>>>> -		__free_pages((struct page *)pages, compound_order(pages));
>>>> +	if (frozen)
>>>> +		free_contig_frozen_range(pfn, count);
>>>>    	else
>>>>    		free_contig_range(pfn, count);
>>>
>>> Can we get rid of free_contig_range() branch by making cma_release() put
>>> each page’s refcount? Then, __cma_relase() becomes cma_release_frozen()
>>> and the release pattern matches allocation pattern:
>>> 1. cma_alloc() calls cma_alloc_frozen() and manipulates page refcount.
>>> 2. cma_release() manipulates page refcount and calls cma_release_frozen().
>>>
>>
>> Have considered similar things before, but we need manipulates page
>> refcount only find the correct cma memrange from cma/pages, it seems
>> that no big improvement, any more comments?
>>
>> 1) for cma_release:
>>     a. cma find memrange
>>     b. manipulates page refcount when cmr found
>>     c. free page and release cma resource
>> 2) for cma_release_frozen
>>     a. cma find memrange
>>     b. free page and release cma resource whne cmr found
> 
> Right, I think it makes code simpler.
> 
> Basically add a helper function:
> struct cma_memrange* find_cma_memrange(struct cma *cma,
> 		const struct page *pages, unsigned long count);
> 
> Then
> 
> __cma_release_frozen()
> {
> 	free_contig_frozen_range(pfn, count);
> 	cma_clear_bitmap(cma, cmr, pfn, count);
> 	cma_sysfs_account_release_pages(cma, count);
> 	trace_cma_release(cma->name, pfn, pages, count);
> }
> 
> 
> cma_release()
> {
> 	cmr = find_cma_memrange();
> 
> 	if (!cmr)
> 		return false;
> 	
> 	for (; count--; pages++)
> 		VM_WARN_ON(!put_page_testzero(pages);
> 
> 	__cma_release_frozen();
> }
> 
> cma_release_frozen()
> {
> 	cmr = find_cma_memrange();
> 
> 	if (!cmr)
> 		return false;
> 
> 	__cma_release_frozen();
> 
> }
> 
> Let me know your thoughts.

Yes, this is exactly what I described above that needs to be done, but I
think it will add more codes :)

Our goal is that convert all cma_{alloc,release} caller to
cma_frozen_{alloc,release}, and complete remove free_contig_range in 
cma, Maybe no changes? But if you prefer above way, I can also update
it.

Thanks


