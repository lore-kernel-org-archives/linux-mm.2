Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ACFDCC5B572
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 07:06:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 938F66B03D0; Thu, 13 Aug 2026 03:06:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E9626B03D1; Thu, 13 Aug 2026 03:06:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D8C66B03D2; Thu, 13 Aug 2026 03:06:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 486F56B03D0
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 03:06:21 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A900612050A
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 07:06:20 +0000 (UTC)
X-FDA: 85095362520.29.392F9BD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id D146D1C0011
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 07:06:18 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=endUKs5k;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786604778;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=67bSBr6S3Rgqwv7q/F8MVWiesuWl93Cam+1apB+ncFA=;
	b=CW1sncVafpEeBTc8Nr1muMVqUv4ykyhJZi9yZ/pKl2AwdeeA6tdbb+evJxrv5kbopEBqPD
	kNW8vYXPDhQLxPP2kbjZH4nycrBI4iWaSo3Q0epVTcol+e8aXovCudDTTHzuP1+KIEha4T
	xcJnwMIu/0AvSnsiKxEUYgkSIG+WwIU=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=endUKs5k;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786604778;
	b=zDtO7W++JH0dMjnTbEJFHdjrJsgVhhpjk78+Wj1EI7p/PQXTQeQ7g0RtndoX2PTT19lUgE
	hnOQNaV+jkhr3S1CHeteCTb0l/PvjJ00Us11zCarGRtr8SvTeO20EueA5MdL0iI2BwuZXI
	P75cN92EgzI9wa//NPg+u8tzkcA6Y7c=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 693B740717;
	Thu, 13 Aug 2026 07:06:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 159E41F000E9;
	Thu, 13 Aug 2026 07:06:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786604777;
	bh=67bSBr6S3Rgqwv7q/F8MVWiesuWl93Cam+1apB+ncFA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=endUKs5kXevNRELkHoZkzmtlfWQQNl3PqQkvzJrznXiyhJSn4RbBqYEKJUoJBFr96
	 NtgtWPkL993Kd6o3A+m1qpZcY9HA/BWTdAJaxyQjfnNRrnnSZj6fODT2Q+RKHNaaHy
	 73JLhHhs2TTqp5M2+suj9b1Q7B2VeEjzHy/TKMBrfXoIhY//VG4sL0UO2aEs4mqq7k
	 Ix/zb2BvQ41FclTsBLCBcB5UPS11m8Y+O1T7D+LQg6bZAJF7VvEJL8Ao0z8DSqAaDr
	 4IE6GcrTekiVt1gwuwciH4+XI0DG2cZBVoJ1ysOr/QxCdXwwgycVyDURxdtWp139ac
	 /svtBBFKC98eQ==
Message-ID: <0dc4a8da-b2e1-4eaf-bea7-070b38d6952c@kernel.org>
Date: Thu, 13 Aug 2026 09:06:07 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/Kconfig: allow user to select MIGRATION if
 MEMORY_FAILURE is enabled
To: Xie Yuanbin <xieyuanbin1@huawei.com>, rppt@kernel.org, ljs@kernel.org
Cc: akpm@linux-foundation.org, apopple@nvidia.com, bp@alien8.de,
 byungchul@sk.com, gourry@gourry.net, joshua.hahnjy@gmail.com,
 liam@infradead.org, liaohua4@huawei.com, lilinjie8@huawei.com,
 linmiaohe@huawei.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 matthew.brost@intel.com, mhocko@suse.com, nao.horiguchi@gmail.com,
 rakie.kim@sk.com, surenb@google.com, tony.luck@intel.com, vbabka@kernel.org,
 ying.huang@linux.alibaba.com, ziy@nvidia.com
References: <anxOypktGGq_9PZw@kernel.org>
 <20260813022616.9050-1-xieyuanbin1@huawei.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260813022616.9050-1-xieyuanbin1@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 1sscb9akaoqko7dngt347krikiqptbbx
X-Rspamd-Queue-Id: D146D1C0011
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1786604778-303711
X-HE-Meta: U2FsdGVkX1/RtKGYZjdAAm2+n37oQgkKsM2PwJUhWJcWXOSgbBo5M1UKo7aKLdmNSl1nNs1Eg4noTfCEUF8R9cVRbDvbrI+GH1h9t3xlsoJK682MAQG2LavE+5gFXLDrQTRHzAbTI2GtpLydXjMKxieXoO4YXV/j26TkbpaaP5QBzXzxqzcnG0VODokCMAGrPgUGjUeptWL3GuJhvLeZ6w+KakzC9h3bEl4msvMUjc3beOuSZNxNl+pP3sMtvAC7pOXuwdGwaQtl8B+ru41MSUGFAUGtz+iWLdQtxrDSon4tma1MK/ztDhHmXsc32ThD3Sh0y0KmQ0CbNd5uO0xo3CGvMI/8XeOVFG4RY0htnJ0s2cGZtZZyI8CAcfYcjoFWynkgrkzs/h7Ox7V16t2g54c90I8Y7GZ94WENjejG88ZQ4rMzmjs3Gq9QhCvgKh+nKF23pLBkVVF74Yqb3CkRpQwRZDziZdjky/7zm4HpIF3LUvdHZQZavzPDZtkHdMd54Ptpsd0UHAXJp6iEsplU4diSgtiq72it7Wc3wPj+zpJ301g4wP865b9amx0GtYLozmUXk94NK8oWqRZDePc6wR+svfmQre/cWebOkUkNj1l9vDdU86eLwIcZl5WZPq5W61b+t57k3BG/X3BiwtTKQcN8r/5z+Mzi36dWdwN1HkRtWXYG+zq67hUSY/vQ7tg+hRTIK4zU8/7L+NerDbAaLfcXrMDBX/aJoe+nWj5dbmxu4VrL8B+n6a0HnvJ9LXBgOdyUDcDVQcprokZu/qSq1UUv3TBcRU5PKYtx7e514rYtkas8yLOWFLmO8SQhX9Q0zTTwJwRjQWMVuQev/NotrqTQomBT+i+3vegsMgQTaqZUBfDQh4R3Gx03PJL94SyDNiec6HV6GAkapzZ7rL82fR3yGPaBtAkYbIAy+KdoXhta6EbsgUrw00WLSXN5kGOpkTKS89DzCS2NBxEYIdV
 R0K80JNR
 DA3V/EdZXU9QU3ZJdDBDNnqXFFXol67W+0LDM4WJ5rMAiFA8MUJisFtBhLeeLilDXk2t3kqhaFvmu8h6QpSySvrf/hstwY4810X5qj8Pa28iSUJe9jXHeqeFUSTchq0BUo/dXAfZ4B86z7YD4WJnIU9K54heDt+3ep1Ktqo3JY/eiodbODNQLDJg/fVgO9CuXgAU2SNfxDUrm64Z7YNE0t59PkMfRcRExP7ptD4y5M+2nqI/GOk+plsogfvML5gYpngWw7mDqa1ZSvGGxSPT+qcczNwerQAVSieYfWQr6ga7HtmAof+D6WCtz7IvRPuqfDpZmqPnO5fEzb2O2GHtDzYY1Gzh1MuL5ODy/4rIP25JGNXCHmxfu4VVV7ZJOazcQO8jA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/13/26 04:26, Xie Yuanbin wrote:
> On Wed, 12 Aug 2026 13:45:30 +0300, Mike Rapoport wrote:
>> Do we want to make users decide if they need MIGRATION when MEMORY_FAILURE
>> is enabled?
>>
>> Just make MEMORY_FAILURE select MIGRATION.
> 
> I agree with this solution, but I discovered another way: just like
> commit 6ebf98d71f9b509e833e ("mm: introduce CONFIG_NUMA_MIGRATION and
> simplify CONFIG_MIGRATION") done, add CONFIG_MEMORY_FAILURE_MIGRATION
> to select MIGRATION. The Modification is also very simple:
> ```patch
> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index a8b03e2920ba..500e54ace6c9 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
> @@ -1340,9 +1340,11 @@ static inline bool HWPoisonHandlable(struct page *page, unsigned long flags)
>  	if (PageSlab(page))
>  		return false;
> 
> +#ifdef CONFIG_MEMORY_FAILURE_MIGRATION
>  	/* Soft offline could migrate movable_ops pages */
>  	if ((flags & MF_SOFT_OFFLINE) && page_has_movable_ops(page))
>  		return true;
> +#endif
> 
>  	return PageLRU(page) || is_free_buddy_page(page);
>  }
> @@ -2028,7 +2030,8 @@ static int get_huge_page_for_hwpoison(unsigned long pfn, int flags,
>  		count_increased = true;
>  	} else if (folio_test_hugetlb_freed(folio)) {
>  		ret = MF_HUGETLB_FREED;
> -	} else if (folio_test_hugetlb_migratable(folio)) {
> +	} else if (IS_ENABLED(CONFIG_MEMORY_FAILURE_MIGRATION) &&
> +		   folio_test_hugetlb_migratable(folio)) {
>  		if (folio_try_get(folio)) {
>  			ret = MF_HUGETLB_IN_USED;
>  			count_increased = true;
> @@ -2051,10 +2054,12 @@ static int get_huge_page_for_hwpoison(unsigned long pfn, int flags,
>  	 * Clearing hugetlb_migratable for hwpoisoned hugepages to prevent them
>  	 * from being migrated by memory hotremove.
>  	 */
> +#ifdef CONFIG_MEMORY_FAILURE_MIGRATION
>  	if (count_increased && folio_test_hugetlb_migratable(folio)) {
>  		folio_clear_hugetlb_migratable(folio);
>  		*migratable_cleared = true;
>  	}
> +#endif
> 
>  	spin_unlock_irq(&hugetlb_lock);
>  	return ret;
> @@ -2903,7 +2908,7 @@ static int soft_offline_in_use_page(struct page *page)
>  		return 0;
>  	}
> 
> -	isolated = isolate_folio_to_list(folio, &pagelist);
> +	isolated = IS_ENABLED(CONFIG_MEMORY_FAILURE_MIGRATION) && isolate_folio_to_list(folio, &pagelist);
> 
>  	/*
>  	 * If we succeed to isolate the folio, we grabbed another refcount on
> ```
> 
> Would this be a better way?

Why add a new config option?

-- 
Cheers,

David

