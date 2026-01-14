Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3351D29FF4
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 11:40:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5579A6B0089; Wed, 14 Jan 2026 06:40:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 505066B0098; Wed, 14 Jan 2026 06:40:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 407526B00A0; Wed, 14 Jan 2026 06:40:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2BC336B0089
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 06:40:57 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D552EC1C88
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 11:40:56 +0000 (UTC)
X-FDA: 84330377712.15.CF5AA40
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 11BE6A0003
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 11:40:54 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EnISaw+M;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768390855;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wtYK3QIgkxwpwKczKOSBFxk9X3ruwHfu3bc5AbbSRrQ=;
	b=TTkM0uLg9VGh1/Y/x8FUsIBMB6ibNMB7K2vgl8zfBHsWUqk/5Dpa2BR19GnEnqcwulyV2G
	hKw3iAR6r7mfgsYeyfJHYQEbreqAnA2UPYKeVzY2Sl3MXXBKrAwm1rHVNrnan5HBlQ+oDP
	K8T4IDf5N1caqORH/zlc/HuvxlZTYSE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768390855; a=rsa-sha256;
	cv=none;
	b=Tww3OWwHxS4qyx7zywcz4xQlYP7KKKXXNGighnCIwcx/WJnrdlJaKKjDFwNedzK24bcOKO
	+6Llf/NGAfdDIDpwx6/rBO0Efa26w+arouN/xCz5ibyaRRbBU53XZs6N3ySPHf1/uBp0vz
	BMZoXL1CHGdB3rDMP/SpJV1JdmuxHNs=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EnISaw+M;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 11544415F7;
	Wed, 14 Jan 2026 11:40:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD01DC4CEF7;
	Wed, 14 Jan 2026 11:40:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768390853;
	bh=dP+lw/+mW6tC9mSGsXiahpdhcfiBeFh8hQKPJymjUzU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=EnISaw+MJcidIWBxl3b2zyOxLiLqneya2LRIly1pSz+adbT+hIsMBszDoq/1XxQzT
	 EOwmS08G5yDnzw3r7FRUZbwaLNcO/rA2YGJYEh6jGR7CihhTNJ3W5qnRq9k8bhEE0f
	 w+Zj/ndDQj8tzdfVTWrkrIpIj6lgzt8m3oN54PgePS0YgN3ZLCtqEEYtP1dVZmviF+
	 GXwlHxwRsG6SIi1jjZ7Hb+inHCPLpl8RCg4taWSRR2ZmA+H6GBWHVBVnnPKxhFs8z3
	 3pc/+pqwE7BOkwJMB53XTwf6BAlt0meA22RFzZYte+rzecCVAlxWKeH6lZ0/orHghG
	 v+pgANAGokrGQ==
Message-ID: <9924fc6c-e3ad-422a-ad60-756efccba0aa@kernel.org>
Date: Wed, 14 Jan 2026 12:40:50 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-new v4 3/6] mm: khugepaged: just skip when the memory
 has been collapsed
To: Vernon Yang <vernon2gm@gmail.com>, akpm@linux-foundation.org
Cc: lorenzo.stoakes@oracle.com, ziy@nvidia.com, dev.jain@arm.com,
 baohua@kernel.org, lance.yang@linux.dev, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Vernon Yang <yanglincheng@kylinos.cn>
References: <20260111121909.8410-1-yanglincheng@kylinos.cn>
 <20260111121909.8410-4-yanglincheng@kylinos.cn>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <20260111121909.8410-4-yanglincheng@kylinos.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 11BE6A0003
X-Rspam-User: 
X-Stat-Signature: gcxyd6iayb57b54wm8b9ygmarpmruuqd
X-HE-Tag: 1768390854-364739
X-HE-Meta: U2FsdGVkX1/0+Cf99C6+MbnnWspX6P4VFgtAyYswUBhZlUgodkne1fq/37RaIU9BmEf1K9ZZ8YetfmXKgsGVGspL75fP1/491Vgx/UqubrdQ/1TaoptD+CYTxUdYX0eUdRNx61378aTlUEW1Jk/oXbfYwH9WxDCcOiC9QTXwh+61VZKKnZCXsTaUpJOr7qHYvE6ZOTP6OeqFS3/cjGKNCX3dUmvzbbbP2v2XB0j+d9g6SgtHID/hVUIUkjLeJYDbLlgsJaxcpAK55s61d8tVWoMEYLYHHrHVz+fJMrLO9g/wlAhINjhN/l7mYOrMWc22gYA/XvFZg3LNbvXstzqGj+GU740pcl3Q480cjvH5TNWNQ1Dp16Af/txUjoge+fffYJrHtbLy1/F/WR6Kea13gwPCtEczsUDQB6oAud9d/POTaUsInXtSr3bgfKGMURGS190RgN+y6BcTLMadDMEKguhY0XgLSbo/WGK6Fp7jrV8XpbIIYq/tgd8B4Jzovtleu7ggIC93IdWKZrrzSnZBd0g+RO9iVEtsMUhAT2wwr/Crkg9C3hymO7V2IzSW1cjTeWpyqXYIKz4b8UHsMosoSRcr8aUs/S2lNtCDkWsIn23GSs68qc1anf8esPxJFGtFVQbVnXhV23EJW31i6lBJ+MgmXCUsMmGIul3jEoVfB9yWx/VhEnz2HSZFIiE+U8JQHqaTCiVF0volDJpF05hjOHefWURHcCu6KNjH1BDUZnV3sliG/jadVLY8tK8XmUa38wJTRJCgFoQ5YaBdaweTwHgyOKtARCAOfvoJ8f3G7a4eb3O8W4Ct/EBq0GH7+KxyuiCarLh+KpGzYtOr237J3Apj3C67H2stl54o44+4ftXPH+BOSIqx0UQXhBCq0q+EQ/i5aXPRY0iIRGim+Xu6GgrGmyz0wjznixG8eK2uwHV6ZaGC4U4cesYVbznUO1cC709GIH4wRFO8nTc6Rko
 rgv2wNC2
 0ClFU7rYvZG4L6+WGK108gn13jL592OHvvs48ca3plnscbJPINyPzqJHX72T05RuPTglwGgFBf6Jz0tL49AOS4BYm4wEg46SLiWIEHN8nt6CUFisP+SXHwfLVNHQ2sevhp3UrXvOxUQ+xgkHhzHArpABenhnGGdiI+4yYFhgJpY4CJtHk+qwVB4JfapybcGvAfU3eiQBn5nt4ht8yL/eNx1noKGrVtFh/6Nw6
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/11/26 13:19, Vernon Yang wrote:
> The following data is traced by bpftrace on a desktop system. After
> the system has been left idle for 10 minutes upon booting, a lot of
> SCAN_PMD_MAPPED or SCAN_NO_PTE_TABLE are observed during a full scan
> by khugepaged.
> 
> @scan_pmd_status[1]: 1           ## SCAN_SUCCEED
> @scan_pmd_status[6]: 2           ## SCAN_EXCEED_SHARED_PTE
> @scan_pmd_status[3]: 142         ## SCAN_PMD_MAPPED
> @scan_pmd_status[2]: 178         ## SCAN_NO_PTE_TABLE
> total progress size: 674 MB
> Total time         : 419 seconds ## include khugepaged_scan_sleep_millisecs
> 
> The khugepaged_scan list save all task that support collapse into hugepage,
> as long as the task is not destroyed, khugepaged will not remove it from
> the khugepaged_scan list. This exist a phenomenon where task has already
> collapsed all memory regions into hugepage, but khugepaged continues to
> scan it, which wastes CPU time and invalid, and due to
> khugepaged_scan_sleep_millisecs (default 10s) causes a long wait for
> scanning a large number of invalid task, so scanning really valid task
> is later.
> 
> After applying this patch, when the memory is either SCAN_PMD_MAPPED or
> SCAN_NO_PTE_TABLE, just skip it, as follow:
> 
> @scan_pmd_status[6]: 2
> @scan_pmd_status[3]: 147
> @scan_pmd_status[2]: 173
> total progress size: 45 MB
> Total time         : 20 seconds
> 
> Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
> ---
>   mm/khugepaged.c | 17 +++++++++++------
>   1 file changed, 11 insertions(+), 6 deletions(-)
> 
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 5c6015ac7b5e..6df2857d94c6 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -68,7 +68,10 @@ enum scan_result {
>   static struct task_struct *khugepaged_thread __read_mostly;
>   static DEFINE_MUTEX(khugepaged_mutex);
>   
> -/* default scan 8*HPAGE_PMD_NR ptes (or vmas) every 10 second */
> +/*
> + * default scan 8*HPAGE_PMD_NR ptes, pmd_mapped, no_pte_table or vmas
> + * every 10 second.
> + */
>   static unsigned int khugepaged_pages_to_scan __read_mostly;
>   static unsigned int khugepaged_pages_collapsed;
>   static unsigned int khugepaged_full_scans;
> @@ -1267,7 +1270,7 @@ static enum scan_result hpage_collapse_scan_pmd(struct mm_struct *mm,
>   	result = find_pmd_or_thp_or_none(mm, start_addr, &pmd);
>   	if (result != SCAN_SUCCEED) {
>   		if (cur_progress)
> -			*cur_progress = HPAGE_PMD_NR;
> +			*cur_progress = 1;
>   		goto out;
>   	}
>   
> @@ -1276,7 +1279,7 @@ static enum scan_result hpage_collapse_scan_pmd(struct mm_struct *mm,
>   	pte = pte_offset_map_lock(mm, pmd, start_addr, &ptl);
>   	if (!pte) {
>   		if (cur_progress)
> -			*cur_progress = HPAGE_PMD_NR;
> +			*cur_progress = 1;
>   		result = SCAN_NO_PTE_TABLE;
>   		goto out;
>   	}

The above checks are clear.

> @@ -2347,9 +2350,6 @@ static enum scan_result hpage_collapse_scan_file(struct mm_struct *mm, unsigned
>   			continue;
>   		}
>   
> -		if (cur_progress)
> -			*cur_progress += folio_nr_pages(folio);
> -

This is a all a bit hairy.

Assume we found a single 4k folio in the xarray, but then collapse a 2M THP.

Is the progress really "1" ?

What about shmem swap entries (xa_is_value)?

So I think the whole file path needs more thought

-- 
Cheers

David

