Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7C29CAC5B5
	for <linux-mm@archiver.kernel.org>; Sun, 28 Sep 2025 12:56:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D0A228E0006; Sun, 28 Sep 2025 08:56:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE1C18E0001; Sun, 28 Sep 2025 08:56:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF73F8E0006; Sun, 28 Sep 2025 08:56:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AD3A78E0001
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 08:56:18 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 741C2BBEEE
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 12:56:18 +0000 (UTC)
X-FDA: 83938657236.05.5782FC1
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf09.hostedemail.com (Postfix) with ESMTP id A04DF140003
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 12:56:16 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=none;
	spf=pass (imf09.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759064176;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=udi6HVYKEx4qFTnbwnnrWvCDrCf9fRdWqb2BDRJ6/SY=;
	b=rhiQviRZhp1gshPJbOH+aj+Ievng8KKH4+Za5y3LRbYJ5l7t36jbjh8NkU/kqi8ufsGzFB
	Wyh8ZMZfAQNQTj5wFIZV57HXBA4tORhqW11hT6htv7CQpsxmWcRAsI6r1jdZcBYoyRlbBa
	ihDNQnxEaacdKLNW4aHre0uL3JJuW1o=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	spf=pass (imf09.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759064176; a=rsa-sha256;
	cv=none;
	b=UDHRFgt3hA/MOWvD8jitvG9S7POd2UD4hhHhfcGQ9t8tYWEYxpkPzhfFKbJzwZX8WcwQ6O
	2SsktVEvf9ModL50dVsVU5H4i/2nA8Ad/U+fadaBWJG+XCCRDoinDcUJnWIhKU9wwop/yK
	QOBdgtgTJN7xitWIR+rXIblibkFiJ5g=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7BBC826BC;
	Sun, 28 Sep 2025 05:56:07 -0700 (PDT)
Received: from [10.163.64.48] (unknown [10.163.64.48])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B8CD43F694;
	Sun, 28 Sep 2025 05:56:12 -0700 (PDT)
Message-ID: <933cfdc7-9e3f-4dec-a5d9-bb193b0b7f13@arm.com>
Date: Sun, 28 Sep 2025 18:26:09 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/hugetlb: Fix some typos in hugetlb module
To: "jianyun.gao" <jianyungao89@gmail.com>, linux-mm@kvack.org
Cc: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 David Hildenbrand <david@redhat.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 open list <linux-kernel@vger.kernel.org>
References: <20250927064926.1496579-1-jianyungao89@gmail.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20250927064926.1496579-1-jianyungao89@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: A04DF140003
X-Rspamd-Server: rspam05
X-Stat-Signature: pyziohihemhihehpnc5opnrk75teriyx
X-Rspam-User: 
X-HE-Tag: 1759064176-888046
X-HE-Meta: U2FsdGVkX18eiLNAYzgTFy5dDVCrUQAuKC3+wzkJ6QNpmcQpRaGU/Neeyah0W8Ecci1yHH0ZBcV4/7jiF/WGIuj4XtTFfotg9NJMhgMRIUGSnISvNOsV51SXrl1G7kkrFQzXjR80v/46CAinocIMDi5ITZZ337zh/73DJUkvd1bqDJ6dsYl28aqoy7QCQ7+BRQ7/O0IfMIw2yBFmdhlJcnFKT7U2xtMRq06SG60fB+y6RvyVMVJD0qSUQBq7dDBIVlNuB2MLPfqSzKitfRJA4FC7kwse4SJ6fTknpx8NKSQA/07FdjKz6lzFhzx48IbqNZp5j4jQyioRBdY+a8xRsAPiwToe/9anhPNE7/IEgmXmzC/8rcgvdGT/65o+Q54BkuLJKkID1ktfBJ1kr8jJ0lnq3jubQxAWwdX0Gd/V0E+vT81+/E7fEgW/KKIMjxMqxhdyfypcIHxHmJ98BkV8BRdvBsNj/qOUiixEyzTTcAyoVw6RatL7QaWbqfqUlElnd3j/1fqudLLfCmEbfNQUQmanWCEQkRifbdFJKrsYieiCkGaW2UyFsd4XVur8JebaH3J6RIjC6W14W8FoPHHfcsgUhBj2n7RlPHlc37m7Y+oAz1rXsA0YYYLyMFmzbyAtUCkmDXDpo4+rGMhIHAlqbfN2Vkx3FuekJ66UXL2Jr3NsF3KZZ3TuT6br9Lu1eVBD0LFeWRJHsWjAp6UEZjjHOb8ABV19ZPJZ3pu3Ml+xePR6sIBimWpAy6LmupZiSnZmwfe+018VPxhiugNitWFVpyPHHm3pn5DoTB/uAGLmfJLgIUg08PnrjxU6T8jAJlQHt1NvyQeZxsT5T0JfuA4rqMnT49veDH4ZpWi3YudzJ9/x94QbwRrJaYypi5IMwFSOOz7C7dplIKcgTXtAnRxCAbYQIixB6HTBFCMooC5Yl8q9bhEKZNNVk/b/ITUTIct6zTgS6blWhTp2RJd2Ygs
 zbAo/dLT
 QbY5JkXzF3jbmcaQCjFD4Jw/ZtB6hd+VB1toe3Jz+DmFKvW1bEGYFueaDRJRTn+IhpdH07F2h9WDjBQFHCI2FqyljVeCmmVEVPUcoW8j+MSYTFWfDbEGvgxPosupffxjFHelkQC+74WHyIZyqE7s/yviIoXs5n3cUs5hj
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 27/09/25 12:19 pm, jianyun.gao wrote:
> There are som typos in the code comments as follows:
>
>    differenciate ==> differentiate
>    refernece ==> reference
>    permissons ==> permissions
>    indepdenent ==> independent
>    Spliting ==> Splitting
>
> Just fix it.
>
> Signed-off-by: jianyun.gao <jianyungao89@gmail.com>
> ---
>   mm/hugetlb.c         | 6 +++---
>   mm/hugetlb_vmemmap.c | 6 +++---
>   2 files changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index eed59cfb5d21..8ff9edd09504 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -2954,7 +2954,7 @@ typedef enum {
>   	 * NOTE: This is mostly identical to MAP_CHG_NEEDED, except
>   	 * that currently vma_needs_reservation() has an unwanted side
>   	 * effect to either use end() or commit() to complete the
> -	 * transaction.	 Hence it needs to differenciate from NEEDED.
> +	 * transaction.	 Hence it needs to differentiate from NEEDED.
>   	 */
>   	MAP_CHG_ENFORCED = 2,
>   } map_chg_state;
> @@ -5998,7 +5998,7 @@ void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct *vma,
>   	/*
>   	 * If we unshared PMDs, the TLB flush was not recorded in mmu_gather. We
>   	 * could defer the flush until now, since by holding i_mmap_rwsem we
> -	 * guaranteed that the last refernece would not be dropped. But we must
> +	 * guaranteed that the last reference would not be dropped. But we must
>   	 * do the flushing before we return, as otherwise i_mmap_rwsem will be
>   	 * dropped and the last reference to the shared PMDs page might be
>   	 * dropped as well.
> @@ -7179,7 +7179,7 @@ long hugetlb_change_protection(struct vm_area_struct *vma,
>   		} else if (unlikely(is_pte_marker(pte))) {
>   			/*
>   			 * Do nothing on a poison marker; page is
> -			 * corrupted, permissons do not apply.  Here
> +			 * corrupted, permissions do not apply.  Here

Can also fix the extra space between "apply" and "Here".

>   			 * pte_marker_uffd_wp()==true implies !poison
>   			 * because they're mutual exclusive.
>   			 */
> diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
> index ba0fb1b6a5a8..e6f79b2c63ee 100644
> --- a/mm/hugetlb_vmemmap.c
> +++ b/mm/hugetlb_vmemmap.c
> @@ -75,7 +75,7 @@ static int vmemmap_split_pmd(pmd_t *pmd, struct page *head, unsigned long start,
>   	if (likely(pmd_leaf(*pmd))) {
>   		/*
>   		 * Higher order allocations from buddy allocator must be able to
> -		 * be treated as indepdenent small pages (as they can be freed
> +		 * be treated as independent small pages (as they can be freed
>   		 * individually).
>   		 */
>   		if (!PageReserved(head))
> @@ -684,7 +684,7 @@ static void __hugetlb_vmemmap_optimize_folios(struct hstate *h,
>   		ret = hugetlb_vmemmap_split_folio(h, folio);
>   
>   		/*
> -		 * Spliting the PMD requires allocating a page, thus lets fail
> +		 * Splitting the PMD requires allocating a page, thus lets fail

lets -> let's or let us

>   		 * early once we encounter the first OOM. No point in retrying
>   		 * as it can be dynamically done on remap with the memory
>   		 * we get back from the vmemmap deduplication.
> @@ -715,7 +715,7 @@ static void __hugetlb_vmemmap_optimize_folios(struct hstate *h,
>   		/*
>   		 * Pages to be freed may have been accumulated.  If we
>   		 * encounter an ENOMEM,  free what we have and try again.
> -		 * This can occur in the case that both spliting fails
> +		 * This can occur in the case that both splitting fails
>   		 * halfway and head page allocation also failed. In this
>   		 * case __hugetlb_vmemmap_optimize_folio() would free memory
>   		 * allowing more vmemmap remaps to occur.

As Wei says, this patch can be merged with the earlier, thanks.


