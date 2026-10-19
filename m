Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67D8CCCF2D3
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 07:37:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 430FD6B00C7; Mon, 19 Oct 2026 03:37:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E2326B00C9; Mon, 19 Oct 2026 03:37:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F7C06B00CB; Mon, 19 Oct 2026 03:37:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F2B266B00C7
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 03:37:38 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 739521606E3
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 07:37:38 +0000 (UTC)
X-FDA: 85338570996.04.41DF6CA
Received: from va-1-115.ptr.blmpb.com (va-1-115.ptr.blmpb.com [209.127.230.115])
	by imf30.hostedemail.com (Postfix) with ESMTP id 3EE0780007
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 07:37:36 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=OEqPjCTZ;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf30.hostedemail.com: domain of zhengqi.arch@bytedance.com designates 209.127.230.115 as permitted sender) smtp.mailfrom=zhengqi.arch@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792395456;
	b=qMmCwYAnIDe9aa7ThMaYHk3xRdbXq9RKczZuZqraG/iBoYBLX+guZmK9bpdYzby3UA5+IW
	UaYSn+/qOrpKYl/KHMJnRD6pvWQDF2+a0XQ2Fz+6vwd28DZZazZwaND7ss0e0rwtjxlj/p
	Pm9bHPpvZ66WmGcrw1K/G7PiIOB3bZQ=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=OEqPjCTZ;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf30.hostedemail.com: domain of zhengqi.arch@bytedance.com designates 209.127.230.115 as permitted sender) smtp.mailfrom=zhengqi.arch@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792395456;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h5Bz8p0/6fFu4pna3JkJBMFOb4VonOxLITU8io1OR8E=;
	b=QmOAJg7CZMW8NMHs/JE/6p+/+giVZW5rK1fAvRxLdDBobCCRnXKwmPHHUJZYyfQb0rOx6P
	h0kRFmadJ6Ya8Zeb9VJDC2Pg2kHMKR9gfXRSF533H8HgLmYu1K7JDMCEn9Lbl5sNrWIuxb
	39YHTsyaFwofUC/KfU0AOB6Ua6vtLbI=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1792395446; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=h5Bz8p0/6fFu4pna3JkJBMFOb4VonOxLITU8io1OR8E=;
 b=OEqPjCTZ6pyKl27vfs+dBiGhnKxia0ayrjPJwTyFr3LBqTLF8SbiP116vt8FeMEKeB8sN/
 LEDpGkphk/FA0bQOLZfObs0vZqqMUQYYLLz9yrya0VILjk+GLGtKz/a/FLf+7HykQujDCt
 NOdrpAPPcxP/5VyHQK7c2WQLkCq/36h3Q4W1qH/G6G6RgK9iyfuc2EKn1DaQSTsIc7Zbln
 H99VmeTLAH88aazkBw0xftL7TI2Fwnc5S6akGrHd4u+sehxNgzoAPwKgvXi6BlSekZfSyf
 ZJKiZi1QsIJvbbwv6YGmJTqjVyUo+XVhAolpH/o2SlQgpk7Hsh2W8xeupj/0wA==
Message-Id: <4a7ad39d-fee6-4390-beff-d40ecf49cbdc@bytedance.com>
X-Original-From: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: <osalvador@suse.de>, <david@kernel.org>, <akpm@linux-foundation.org>, 
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/5] mm: hugetlb: add CMA support for PMD-sized page
Date: Mon, 19 Oct 2026 15:37:09 +0800
Mime-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Type: text/plain; charset=UTF-8
To: "Muchun Song" <muchun.song@linux.dev>, "Qi Zheng" <qi.zheng@linux.dev>
From: "Qi Zheng" <zhengqi.arch@bytedance.com>
References: <cover.1792136742.git.zhengqi.arch@bytedance.com> <FA455F0C-0A46-4B5B-AB50-E9968001D2C9@linux.dev>
X-Lms-Return-Path: <lba+26ad5c8b4+e8dbf8+kvack.org+zhengqi.arch@bytedance.com>
In-Reply-To: <FA455F0C-0A46-4B5B-AB50-E9968001D2C9@linux.dev>
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Rspamd-Queue-Id: 3EE0780007
X-Stat-Signature: 85fauoyhnnnxsr51hmia9jkemcdmihnn
X-HE-Tag: 1792395456-892899
X-HE-Meta: U2FsdGVkX1+CFxpHsFU9bwX4Ml4Mf86IphuUvc4BRfF/DdfmxD5Ud1PzqVxyDlJlNo4nWH7NofAl0R+ATtJZzDL3N33sj7lWxeSyNP5bQCUBHGXiqx1HR8dRNBs5CCgzvVOqw4efAlz5cKXVosqSMgIpR7daFoejSXQxostqA54n5Y3FRagYWTN8qGcWuCLhKWcx7KDZUqTTbY9Zpte/As7tCKBr9oZqsUMcJPq5TuuRQB1pdq1syxZaHoMnNAS9PTr95UwEEllp1V5T4UFM4UhKg/q2A1lzRdUw3tSF5lK6SEeF8Vepze5xs1YuCOHJS/y6tVbdjajVHHgJDky8silWeBYb7jslkUxfChUN0eFp4M/ypVdDD50d50JnnfLWoI9LbaWwLcsTpSrEqGLZRINkFu4WgpZVT+9KUwb3kSCvOoul2ScIyBberi+qTU9O0Xehk9DwmgCQFODWbQp9TgHXVXV1+sXznNZn/QlMr1gUvi7j+dCLP/AzErCaDr1mYIj0PEUMiVZrfpcTQi76rNDNp9xWZdMmFVS0u5v+8VyN56LS09fBONcEz1vPf91YFPWUQ0I/5m0MfIK2UJrCL5v97Ah84DLMCrBxSupOeemXWUllHsAMcl3t0KiRE4gtKo3997Fo8ng3UMMgg/t1Jnts1eJRXy4Xt3yW+Bxc1WTn+wlt2yu5tGr4Gui+DfHvTyBtPda1waREe7SUhVHtScSxmTVNjLM8uODGDwvdCtbinLqr7/P4gHv9FH+k197O9thMjH8m1OlBSce2dfbMboVAwQc0uCdUQc3EzCB5gmYKzfpOb7VAGlK5GjAcSOLMEhhfGdXZ0tZ+/h5eSsBmWa5NFL3d5rN/c5BAOIb3tg+Gs+dxXnah5GYLTs4L8ZakXUHosE+2a8dqzEnW07/TWb4gnoPuhVfMMir+283wiPuPGUQAyyQKCwT0cHtfrkUosLMzZonmj2TQd7wU5wh
 Xo60X41a
 wI45FFT/JCWlBCPi6Jfj7hDa8GMnyccPkbbrJ2msULX69tLj40PdpBBO823gJmJ2RRw4pMTN39IviH/cNwK4PE9XfYkELkrFQwd4XqizYqMYHhdGCwV0QAWr0zcQcnbfsVM5d8gUHGmPWBc+9YCcp4rxgn12xeH9TC1L/E6Rd3pbS+JDL5ji+WvSeMLZr7gjK1gjnAkizNUybi911agLp/Slja+7LUK922eqTKRBH3vqVRnL2F+l1IL0pD9DMM8cMVdhTf1NxUbMPF1Cjb7arRk+qLqgVFZKaJm+TBWI76pUXl2c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Muchun,

On 10/19/26 2:50 PM, Muchun Song wrote:
> 
> 
>> On Oct 16, 2026, at 18:07, Qi Zheng <qi.zheng@linux.dev> wrote:
>>
>> From: Qi Zheng <zhengqi.arch@bytedance.com>
>>
>> Hi all,
>>
>> Allocating PMD-sized HugeTLB pages at runtime can become slow or fail
>> as physical memory becomes fragmented. Reserving HugeTLB pages at boot
>> avoids this problem, but keeps unused pages unavailable to ordinary
>> allocations.
>>
>> Live upgrades are one example: they need additional HugeTLB pages only
>> during the upgrade. HugeTLB already supports CMA for gigantic pages,
>> but reserving a CMA pool for 1 GiB pages can fail when physical KASLR
>> and other early reservations leave too few suitable 1 GiB-aligned
>> ranges. At runtime, 1 GiB allocations can also fail when pages cannot
>> be migrated out of a suitable contiguous range.
> 
> Yes, that's our use case at ByteDance. Allocating a 1GB HugeTLB page from
> the CMA pool is more prone to failure than allocating a 2MB one. To improve
> the probability of successful allocation, we typically configure the CMA
> size to be larger than our actual requirement, keeping a certain margin to
> handle cases where temporary kernel operations (such as DMA) prevent successful
> migration. For 1G HugeTLB pages, since the margin must be an integer multiple
> of 1G, the extra memory configured as headroom is also relatively large,
> making it less flexible than 2M pages.
> 
>>
>> Extend CMA support to PMD-sized pages so their backing memory can be
>> reserved at boot while remaining usable for movable allocations until
>> needed. This relaxes the reservation alignment requirement and reduces
>> the contiguous range required per allocation.
>>
>> The series adds an optional @<page-size> suffix to hugetlb_cma and a
>> separate PMD-sized pool. For example, on x86-64:
>>
>> hugetlb_cma=4G hugetlb_cma=1G@2M
> 
> Different sizes of gigantic pages already share a single HugeTLB CMA pool.
> Given that, why not let 2M pages also reuse this same pool? Would that make
> the overall code implementation simpler? And if it does make things simpler,
> should we go ahead and do it first?

Sharing the pool would simplify the implementation. My concern is that
small PMD allocations could fragment the default pool and prevent later
gigantic allocations.

32M allocations can already cause this, but 2M allocations can block
the same number of 1G-aligned ranges with much less allocated memory.

Thanks,
Qi

> 
> Thanks,
> Muchun
> 
>>
>> This reserves 4G for the existing gigantic-page pool and 1G for the
>> PMD-sized pool. Existing unsuffixed parameters and gigantic-page pool
>> sharing are preserved. The new size follows the architecture's PMD
>> size rather than being fixed at 2M.
>>
>> The preparatory patches introduce per-pool state and prevent recursive
>> CMA allocation during migration before enabling PMD-sized allocation.
>>
>> Thanks,
>> Qi
>>
>> Qi Zheng (5):
>>   mm: hugetlb: add explicit page size to hugetlb_cma
>>   mm: hugetlb: group CMA pool and reservation state
>>   mm: hugetlb: track CMA reservations by page order
>>   mm: hugetlb: avoid recursive CMA allocation during migration
>>   mm: hugetlb: enable CMA allocation for PMD-sized pages
>>
>> .../admin-guide/kernel-parameters.txt         |  39 ++-
>> include/linux/hugetlb.h                       |   4 +-
>> mm/hugetlb.c                                  |  80 +++--
>> mm/hugetlb_cma.c                              | 328 ++++++++++++------
>> mm/hugetlb_cma.h                              |  11 +-
>> mm/mempolicy.c                                |   2 +-
>> mm/migrate.c                                  |   3 +-
>> 7 files changed, 306 insertions(+), 161 deletions(-)
>>
>>
>> base-commit: b810335a0699d1810683796b0e3ffe8827ddfe6c
>> -- 
>> 2.54.0
>>

