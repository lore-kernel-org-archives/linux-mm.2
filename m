Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2DB19CCD199
	for <linux-mm@archiver.kernel.org>; Thu, 16 Oct 2025 18:02:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 709CF8E001A; Thu, 16 Oct 2025 14:02:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E1A98E0002; Thu, 16 Oct 2025 14:02:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F7568E001A; Thu, 16 Oct 2025 14:02:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 516B28E0002
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 14:02:18 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 006811603AD
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 18:02:17 +0000 (UTC)
X-FDA: 84004746714.05.797C2B6
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf22.hostedemail.com (Postfix) with ESMTP id 31871C0007
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 18:02:15 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf22.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760637736;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CDyD+83Zo3DzePbPJTIkzIjAtOee0UDN1S4jTNJhoE8=;
	b=7qRaoypVnr9WkbgNluOjvBElNXaFxKw7MrEbEEgC+swdu1tj/Bxj9S7IiZRHngYWtembR6
	DewiMbfjgEa12ToB71bdDj+GNBw1lAhoHG2d3DO00Wbp1HEi+0z/gzM9poRKWR1fYUtcCP
	JCLYdxzkwBlWWTl4M1wSTOKTI6qUyG0=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf22.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760637736; a=rsa-sha256;
	cv=none;
	b=t9xbdGo8SaBTOW7zDL9RYlW5vxk1ictNaIRREUOJi2JPhgz7bhmh6ifx3l18F102PaAe4H
	H1OF/h564Dz0qCYNzNA1ZsxjkSQOIlhNLu1FHi/LeEUtuD6nWm7cQHN4EOGo8v1NQUNw6k
	V/Ic4PlLQFhR/HZZ3h8O8Erw90Vs4C8=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 48A041655;
	Thu, 16 Oct 2025 11:02:07 -0700 (PDT)
Received: from [10.163.66.205] (unknown [10.163.66.205])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 450B13F738;
	Thu, 16 Oct 2025 11:02:10 -0700 (PDT)
Message-ID: <5a5ba43e-e575-4b7c-8dc6-80c25cd77a74@arm.com>
Date: Thu, 16 Oct 2025 23:32:07 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/3] mm: mprotect: avoid unnecessary struct page
 accessing if pte_protnone()
To: Kefeng Wang <wangkefeng.wang@huawei.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, linux-mm@kvack.org
Cc: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Liam.Howlett@oracle.com,
 Sidhartha Kumar <sidhartha.kumar@oracle.com>
References: <20251015123516.2703660-1-wangkefeng.wang@huawei.com>
 <20251015123516.2703660-3-wangkefeng.wang@huawei.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20251015123516.2703660-3-wangkefeng.wang@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 31871C0007
X-Stat-Signature: 4c9o3sxca8dj8t6cwen3r7sbo89rzzro
X-Rspam-User: 
X-HE-Tag: 1760637735-176019
X-HE-Meta: U2FsdGVkX1/s8iDhJivWvan3ouwUqVJ2aQ2OnPJ/Je8KjbPab36DvSXqq5ujoAvHFfW6tAdRAQs7KWkC3DmTiO+5Rr40LOks2oBpax0GYoschpsQHddAwLB4VChUDYSaFknt0XVOhKEgiq5ssvToBUUvlB8PF8f0gw2qUuSW0weEuM8doGbsxG5GaU3sePKXhf1BFZ5NvfyH1iyhMfUxHoJuCD7IhvndyV8qTx44fB7uxR5x8iey9bKVdUt+GLXAInyT56TOUt0je9aqt+eJ1H3CzZ+WVfsc2ZHYesbeiYkxVc0YXSaIkMtc0hUUwUfHJCJHahfQWIb/v7e9lhHBY2a51hFpm/dpxQTq0n4unYYJ6OD4rzO54KnL1i/gyKhomerzKHaBILLQoTQKgtIXUVdqDQvTUnYexeo3zAgOsbDpSrjo96cQUp4n1HyRYfs8fnXX8wIyRwbZNF/UHIuMB0vqsuzVCifSx5U9VN4X2zcWEZCSxHy4Bp86gLPdYuB09rR4UbG2bdpA25XPD3gdEdEb0TnEC67av6+nuViVVRdGkN+yhbgvPIor0sh83c4/Z1JYs1QRk1UcM5gtB7AdcATTYcGnYQ3VU1dhbAyAtXEQH0WEt+S/KpGyMdDO2hc2F3Q99BedRx1vLcEdPdGjeS1kg/CUr8Ab8jGs1a2vRo2dtlB4c6zjhUw3kNnvOTWjx/o/csCaSnraiKRvUdGItpvL+uESkrFtQ9AYVNo+ErkTA4U2rm9fL4GmgsE7XlxQPbqEBp91haMucJK4uIxzy0io1cgvN73BnAjtSRitj1nuSUxKfWDhf/KgYIGH93OnUCz1xnPEDp7JqfgAi99GOrhYA2YXWm0qhaJ9TiZJrNfrYCosOJpA3QezQvBaXvhrex6HFIuRUALxYAvpXTUYo7GW+7ZO4It9hmrnYq/0Z0EzUHvVAHtjK/q5Ta92rmgk6Iq+eZpWqW4x66Rktdu
 xgFM4o7q
 N3iwu7JHXOLeriRNgDo8jlDJrHHgYOXexQrcw6AYqwjSBtSRTm2LjsJfBZzlAPNju3lY9woUmfnLphDKt9TRruh/Ye6r1Nv0RfkpkmiF/c5Thk2YfqPw0Zij0DYvh6n344JDX360W6m25bVc0lTfid6mMDhid/X+G4pUausqKkbk96uKmVfw1U+OUtMWEJ7FjS/U8UPlT92pC7nLzi8xjmkBaM3k70kTJdKaD0x1RhIr3PqdX6S3Z/WFjhoPN3L/H/IeG+DwnInOiEC/O8ettHx4fdwnd8+sAVJ2to+fWp5Zc3Y8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 15/10/25 6:05 pm, Kefeng Wang wrote:
> If the pte_protnone() is true, we could avoid unnecessary struct page
> accessing and reduce cache footprint when scanning page tables for prot
> numa, the performance test of pmbench memory accessing benchmark
> should be benifit, see more commit a818f5363a0e ("autonuma: reduce cache
> footprint when scanning page tables").
>
> Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
> ---
>   mm/mprotect.c | 30 +++++++++++++-----------------
>   1 file changed, 13 insertions(+), 17 deletions(-)
>
> diff --git a/mm/mprotect.c b/mm/mprotect.c
> index bb59a42809b8..ed44aadb7aaa 100644
> --- a/mm/mprotect.c
> +++ b/mm/mprotect.c
> @@ -118,18 +118,13 @@ static int mprotect_folio_pte_batch(struct folio *folio, pte_t *ptep,
>   	return folio_pte_batch_flags(folio, NULL, ptep, &pte, max_nr_ptes, flags);
>   }
>   
> -static bool prot_numa_skip(struct vm_area_struct *vma, unsigned long addr,
> -			   pte_t oldpte, pte_t *pte, int target_node,
> -			   struct folio *folio)
> +static bool prot_numa_skip(struct vm_area_struct *vma, int target_node,
> +		struct folio *folio)
>   {

Wow, so while refactoring stuff, I had introduced two unused parameters :)
Thanks.

Reviewed-by: Dev Jain <dev.jain@arm.com>


