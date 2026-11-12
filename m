Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB8A3606A330
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 03:26:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=2212171451 header.b=Z0WoG611
Received: by kanga.kvack.org (Postfix)
	id 050B46B05B3; Wed, 11 Nov 2026 22:26:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F1C1F6B05B4; Wed, 11 Nov 2026 22:26:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E31F86B05B5; Wed, 11 Nov 2026 22:26:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C191F6B05B3
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 22:26:06 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5A8D91A04AA
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 03:26:06 +0000 (UTC)
X-FDA: 85425028332.27.3A9AFCC
Received: from va-1-114.ptr.blmpb.com (va-1-114.ptr.blmpb.com [209.127.230.114])
	by imf26.hostedemail.com (Postfix) with ESMTP id 9BE82140003
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 03:26:02 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=Z0WoG611;
	spf=pass (imf26.hostedemail.com: domain of zhengqi.arch@bytedance.com designates 209.127.230.114 as permitted sender) smtp.mailfrom=zhengqi.arch@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794453964;
	b=YjyYhMg+SaZW5AxaEEZiVba5YRWQMjI2jZeZprrAigZbPHeG6zxI2z6FujAwEP8JcBQHeh
	05rLoLDsUEBVRd7RA5dP1mQuzUoZccbasYuX1OzVnMnWVkN+lMUrSZCRGadHa3hlmyajO/
	kKS/D/yrsrOaFiW6B3JA011djgkoXFE=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=Z0WoG611;
	spf=pass (imf26.hostedemail.com: domain of zhengqi.arch@bytedance.com designates 209.127.230.114 as permitted sender) smtp.mailfrom=zhengqi.arch@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794453964;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KwVkcbc7y+N/n0v3EmYPeXpyF8Leg60aXI1iqgxnOa0=;
	b=LqEzeCDiewQ71PTa8sb409tiEp7xWKuHOpNqREDid1z6FzXUvNrd/KKgAI86+CROYxmvD5
	fdjtdjeLMjv3EH10Q7Lp24fQqYJovk5L6Gl00izayWCfgfPFJa2im+1TlS80E8qOj81M7l
	TG6E0xyLvpxrQCDIoyXJr2OYO1SEM2M=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1794453957; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=KwVkcbc7y+N/n0v3EmYPeXpyF8Leg60aXI1iqgxnOa0=;
 b=Z0WoG611yUE9gGcjG0XpeLIJj6VT4JCy5VpnIaefcKpVYPNuzo32E8xZLThNJ3pBZib0mK
 p1s4SaULdFh5qaLeNcTsbojeBXgfosa8Z/HP3Blrm/iQ8UbgXhyMbSjna7nN7dKySoN7HT
 QxhQ2hD6swpK92wcmH0BicOV9kke84batljU8gfrru5vivB7wKQjskfNaB7u7PDSS0FbmJ
 6my62Te8jMz7J8BcCrRLrvswnYZN0wtj56nxChvwBsrwd1ZwH0v1yO33vhHOVfZkohp9qs
 EQ7XC7TW0PUtKK+ikQXn9hwfZ/Cgk1GsOaiUovpvcnS9VQOLViRShJw7ntJusQ==
Date: Thu, 12 Nov 2026 11:25:38 +0800
Content-Transfer-Encoding: 7bit
X-Original-From: Qi Zheng <zhengqi.arch@bytedance.com>
Content-Type: text/plain; charset=UTF-8
In-Reply-To: <b1c1c835-180a-49e2-86c0-bc3f65981728@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>, 
	"Qi Zheng" <qi.zheng@linux.dev>, <muchun.song@linux.dev>, 
	<osalvador@suse.de>, <akpm@linux-foundation.org>, <azpijr@gmail.com>, 
	<lance.yang@linux.dev>
Cc: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
Message-Id: <7e733c3b-2aa2-406e-a5ca-cd9a2c872f9f@bytedance.com>
User-Agent: Mozilla Thunderbird
From: "Qi Zheng" <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v3 0/3] mm: hugetlb: fix CMA-related issues
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <cover.1794046188.git.zhengqi.arch@bytedance.com> <b1c1c835-180a-49e2-86c0-bc3f65981728@kernel.org>
X-Lms-Return-Path: <lba+26af531c3+884734+kvack.org+zhengqi.arch@bytedance.com>
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 9BE82140003
X-Stat-Signature: 3qihifz9dqh3q6erzm9r5d5ymqs68acb
X-Rspam-User: 
X-HE-Tag: 1794453962-139695
X-HE-Meta: U2FsdGVkX1+LB3MgRNRlc4X9NnA4SgD4q+C3HikJx08TH3lmkpJ6WZQvzK+WfStrAZIv7VvvF0cMJY5XpIoz/025Qg2G8cNirPSnMvya5Rc3GsraMYifmrzsKgFYz6dr+dw/yw2sh7CYgSlwHaJhvAWKPhMg6GBEvQuIvbyRrQw+4xwBW5z2J6TvAWsV81LFJXpv5Z+aAChipGI1sMEY1douoTD20rgQaJvLLkaSfAVvp2dtbSbUMNO72TyD/ka7ib/7R18FZCO2uiqklWQXaHmitAfLJtD41M7VzD7K8ysWlQa2+DjealB60XlxXB4UFTX229BtRXUg4afUl6OQw6T9gMsUMYUl/L2S7lfyak7OrWQwYFQ7RlQXmPZmadu68U9nZ4TtVYAQSe3Cz6Wdbuh4SVMLqa47QRSO1CpO8YxY3AxJqxPqWxT4GlnjhdQvtgFQvsTrDxARLwu0JhElrOZIKnbPcH6AYD911xROxGwbXxjj7aIKmSS3FEZNvEirlxFb5VN2ElN98qz6gewHgy+bPlibR+Xln8GqFnP2E2rBoCyF8G5WsYZsuG3kNTJ38ejnneQY/rNozJn4ufyUEUDNkbYo5WQDMnVyWsf+kuktena1G+r9aCQH1i1dair5U8zo/tYRlaOVXIyXMOz5Ybf/UclM9u3LsfgjG2z/TWCQ06XGliU1bLHh+G8KDyMQU5WB36A2btbD+TU0k8ckDTwjikfMyEawPoOQjDpfm7BKiLH17rmG0gRpQvBDs5TGkU9ICRTzAV2FGGGbCIjvcYdMCCoCPyWA2TfQHavzVapWEnG1lbePgyMKmW1YMRxlrlzGcCl4LIkNKM1gfQ/Y/zyhfmCWGyHs3+zmnCy9GOaggTqP8CdlZ5hyPenwwf1IM/km5lV4570T14SgnXLbhD1I5S9z6IV60gkD5kYB8Uln51qatc0dcTL97ttH8A0tFzsnwC32PnfGu1moD/y
 99UiagPc
 qJsZrM/wpqRzlAnO6SONXRgw6HNJl6rAafxhSLWnJFBq3RvERIYtxCOfdHfPsOx3YBFpAYH6eTWvxMog30551klcKwGBF8RwndiTLRatavxTNd1BcxQwaAHXzpCt7moKymZHeOBVAswDFzvHWuLo/2ZRcSkXml8GtCQxtfQEONX95bMXsEHuCCxCcWmsc7dOo0l9GQi65OUW7+XIq4ugsnJtD1hXHhuO9n3hRMjZE0B4PnM8KJChOIMjrkZmRSwJNpWV9rJEC9V/cDU6EJVZJBkdtGIRbYeTtAQ1AjQ4d615GJkI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi David,

On 11/12/26 6:05 AM, David Hildenbrand (Arm) wrote:
> On 11/7/26 11:30, Qi Zheng wrote:
>> From: Qi Zheng <zhengqi.arch@bytedance.com>
>>
>> Hi all,
>>
>> This series fixes three CMA-related issues in HugeTLB reservation,
>> long-term pinning and allocation:
>>
> 
> Can I hand you over another CMA-related hugetlb problem?
> 
> On arm64, we can end up allocating 1GiB and 32MiB hugetlb folios from the cma
> region.
> 
> Doing that dynamically is not a problem. Doing it during boot doesn't quite work.
> 
> cma_reserve_early() does not handle any kind of alignment.
> 
> So if you allocate a 32M folio followed by a 1G folio, the 1G folio will
> suddenly start at offset 32M, not being naturally aligned in physical address space.

Yes.

> 
> Likely cma_reserve_early() must be taught to align (and maybe consume an order
> instead of a size), similar to how the dynamic cma allocations work.

However, simply adding alignment would leave gaps that the
current activation code cannot distinguish from actual reservations.

The early allocation path would become:

hugetlb_cma_alloc_bootmem()
   -> cma_reserve_early()
        pfn = ALIGN(cmr->early_pfn, nr_pages);
        cmr->early_pfn = pfn + nr_pages;
        cma->available_count -= nr_pages;

For a CMA range starting at 4 GiB, reserving 32 MiB followed by 1 GiB
would produce:

4 GiB       4 GiB + 32 MiB             5 GiB             6 GiB
| 32 MiB used |------ 992 MiB gap ------| 1 GiB used       |
                                                         ^
                                                     early_pfn

Later, cma_activate_area() marks the entire prefix below early_pfn as
allocated, including the gap:

count = early_pfn[r] - cmr->base_pfn;
bitmap_count = cma_bitmap_pages_to_bits(cma, count);
bitmap_set(cmr->bitmap, 0, bitmap_count);

It only initializes and frees pageblocks after that cursor:

for (pfn = early_pfn[r]; pfn < cmr->base_pfn + cmr->count;
      pfn += pageblock_nr_pages)
	init_cma_reserved_pageblock(pfn_to_page(pfn));

The gap therefore remains reserved and marked allocated. Releasing the
two HugeTLB folios only clears their own ranges through
cma_release_frozen(); neither release covers the gap. Those 992 MiB
would be permanently lost from usable CMA capacity.

So we would also need to track the gaps, clear their bitmap bits during
activation, and initialize them as free CMA pageblocks.

> 

Another possibility would be to give 32 MiB pages their own pool,
similar to the separate PMD-sized pool proposed in the other series. On
arm64 with 4 KiB base pages, 2 MiB, 32 MiB and 1 GiB allocations would
then use separate pools.

This could work during early boot too: hugetlb_cma_reserve() establishes
the CMA areas and their ranges before hugetlb_bootmem_alloc() runs.
Although the bitmaps are allocated later, each range already has its
own early_pfn. With naturally aligned ranges and one allocation size
per pool, the cursors would stay aligned without creating gaps.

What do you think?

Thanks,
Qi

