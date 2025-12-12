Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57B05D41D74
	for <linux-mm@archiver.kernel.org>; Fri, 12 Dec 2025 02:56:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A9F2F6B0006; Thu, 11 Dec 2025 21:56:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A77316B0007; Thu, 11 Dec 2025 21:56:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 98CB16B0008; Thu, 11 Dec 2025 21:56:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 87A9F6B0006
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 21:56:15 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 269B1B5BAB
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 02:56:15 +0000 (UTC)
X-FDA: 84209305110.20.F38E70E
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	by imf04.hostedemail.com (Postfix) with ESMTP id 8B89940004
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 02:56:12 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=fHAW0ABX;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf04.hostedemail.com: domain of baolu.lu@linux.intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=baolu.lu@linux.intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765508173; a=rsa-sha256;
	cv=none;
	b=ArGIlBdqfhZQcgXyAxNB67uEoVSSOcIGWAJfTwaXV0obBsTucymsxcHLA97LXxgAt5AXvm
	/C+qTblcKibDlgVidAENP1DOS70pBnl9g33RhoXd2zBcCs1SdSyDGB5trKRnSbL40p+mmb
	1/wyjlwAHoirvA87h19QtF8XLQFiOUM=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=fHAW0ABX;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf04.hostedemail.com: domain of baolu.lu@linux.intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=baolu.lu@linux.intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765508172;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Gzz5DyjS/U3F3/cidHZBKsbb48AMl+Wwz7DbZpOjtuI=;
	b=nXHoNVYj/EDF6KYwMofUF/A7zi971VwJB5j14JLCZReuseP7av8E8iUOz3E5+SWGRcqYfT
	OfaukwwZ4+J7NddCkkXOgYoihQGxrUV/BJMPf1nbRH3dzsjT4zQO+Ey1kZ9liNzFme0vPY
	JW7AyPO7W+RLTnZBp6qcqvjIIQPdy/0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765508173; x=1797044173;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=kT137sNmfNB8Sc6qW8Hhi0yb56d3CUsss1jHlI43eOw=;
  b=fHAW0ABX3zWOJ/72O7h6WheItKJ8NSjNwy9BGnW5U3TPv8fj5Um7++6C
   jutl/kwHwcovSQ3sTvU6TRnhsrdO9Y0TqOGLV68h/x4t8NR0rLAINN48h
   7genF8Y8K5NvcHZ7IvTbTZWEoNKU+45h3JndPS/pG09phijeNe/ICodLK
   1xBH5NZzwj7EkaCbByYrw2oFi+1HBnq/ILFVeIl4bg+1y7eceZFDEZn9q
   z+w2XxF5sfTdEyxVRhBTVeuKJbLs9AiIEhRketcPADcZ4H8kSQKptSR/G
   bS0ZddzXCySyqStLC8lqIyVL0hPJeicAWRj7Z92030nOqBmCw2NUmZ7qC
   Q==;
X-CSE-ConnectionGUID: tOhcHb4gSxKZkyyaxgbKBA==
X-CSE-MsgGUID: n6Yr2lrzS/Sj9Nl7P9nllw==
X-IronPort-AV: E=McAfee;i="6800,10657,11639"; a="67546828"
X-IronPort-AV: E=Sophos;i="6.21,141,1763452800"; 
   d="scan'208";a="67546828"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Dec 2025 18:56:11 -0800
X-CSE-ConnectionGUID: gI04P57fSR2SYtMNoD/a5w==
X-CSE-MsgGUID: ut7bpy5cR82ss1Mh0YQ5Ew==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,141,1763452800"; 
   d="scan'208";a="196048871"
Received: from allen-sbox.sh.intel.com (HELO [10.239.159.30]) ([10.239.159.30])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Dec 2025 18:56:06 -0800
Message-ID: <aa14d149-dfde-44e9-8fb3-72cb9b0e6920@linux.intel.com>
Date: Fri, 12 Dec 2025 10:51:24 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 4/4] iommu: debug-pagealloc: Check mapped/unmapped
 kernel memory
To: Mostafa Saleh <smostafa@google.com>, linux-mm@kvack.org,
 iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org
Cc: corbet@lwn.net, joro@8bytes.org, will@kernel.org, robin.murphy@arm.com,
 akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com,
 mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
 david@redhat.com, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
 rppt@kernel.org, xiaqinxin@huawei.com, rdunlap@infradead.org
References: <20251211125928.3258905-1-smostafa@google.com>
 <20251211125928.3258905-5-smostafa@google.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <20251211125928.3258905-5-smostafa@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 8B89940004
X-Rspamd-Server: rspam03
X-Stat-Signature: kdsdzjfihnxiqghh815xwg1nx45orqsn
X-Rspam-User: 
X-HE-Tag: 1765508172-648761
X-HE-Meta: U2FsdGVkX188g7LMH6vANSZHZTBFYR3IJ+E0sc7+aiFi0uZKx4zKLIElzbBSfzRks0tOeeR0INz0KY9kHBrPqxNH7O3vwj/1mCv/eObVqYEux5gzvkkwbS4rYaxQOnXmVffOTIyPkTt+4R8UIgdV92i7wqBEA7np4TM8k7eYlfjWycoQjBP5MRlHBsDmrQS9EALJbXNH8tPAT9mxn2iQM6sPNvAtOYiPyQjDUGj/+FKzmlBPnqYhDd57nyNQahqLqK9/r1N2M6lGcNkRJM3Rxrey2YrGePpFRZJgcgK8enh8TkVI4ed2qP6ijHw815STaLBQsXXmcVkbeI6up+JSnx2Vrm9el/8s72GArQbO7rE3Hy4Q8f9FJU3X1jxCDM824UUcCOsurLkKUCE7roa2VP8UN/9Ed68HVjsdDLZUFCVMujW4K+Z8bsgiOfMNhF21/p0AkSBA/ZUwzg5GJHA1A4GTiL4CQedFTBw56QLJ6fttqCwvV0Gbqx38nhE+lMUh9iXnD89kb8GUw/tCqScHMQqtyAB1hNX+G/HGGv8iB/Alzn31enHVZmSJxAgRVrW9o2fgfGeSdKUtBPkMAPcfsZro90ZGsxo5wtniWlcTTMmerTnXrA6a4jWdySMwk8aslSnu/bBMekKXSZvnBp1oZs3rWuZ8t1UWTTyqbEOAycZus8h+1VgLfMFErDhmIOIHOoEfpJuhtouT0cAp9Y35h6w0YFnK29GcLd8hvi0mpcAF2+rmdinmpQuvvkbGUgHPdHih8CZ9MMNZpx7JNVvN8zus1YtQyYn/ZHsWhT5xdiYBxVx+M5O7dybGF7LvKUKRraZwhEcdVdpOhoMX53AIqf4h8LVn0QTDuwma09lmJnes3xFgEvXzksO3pZjsTRZlzLShmi+9ap6STZDI71U2mLmj0f29zWU+5yim3CtTBeKcMPpmceHn45k0wmX+Ha00ImDfr524zkSIto0OkVD
 WEfLfrh3
 iCJ+FK/ntbS1GixdCTjsKxjxFVahRs1CeYssq4lRbmuNq0Z9K4A6B2WVvLfeNp2wQ5qX4lq5wYVNM9L8/DIVV6p6qtGznpYDr0EF2XW/qddD7e5lRy2In4mwc4xvPW645Xyl4SIgCVRb9HJ088QL3xUOgMVZeB/zlxss2tP2cYtR5+3vSrhNTrGZeqXWx8rbScoGaiT5307HlBKoMTSGFZq8jst2cvFUQ4xgFMIPH7d7ETYp6Nhjrz3zGySeqg3FjrzubvhzxelnBejpkjBRXw+AWkA68KCGYwTXD2vJXcxS1bAHMLbkZ+Relkg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/11/25 20:59, Mostafa Saleh wrote:
> Now, as the page_ext holds count of IOMMU mappings, we can use it to
> assert that any page allocated/freed is indeed not in the IOMMU.
> 
> The sanitizer doesn’t protect against mapping/unmapping during this
> period. However, that’s less harmful as the page is not used by the
> kernel.
> 
> Signed-off-by: Mostafa Saleh <smostafa@google.com>
> ---
>   drivers/iommu/iommu-debug-pagealloc.c | 23 +++++++++++++++++++++++
>   include/linux/iommu-debug-pagealloc.h | 14 ++++++++++++++
>   include/linux/mm.h                    |  5 +++++
>   3 files changed, 42 insertions(+)

[...]

> diff --git a/include/linux/iommu-debug-pagealloc.h b/include/linux/iommu-debug-pagealloc.h
> index a439d6815ca1..46c3c1f70150 100644
> --- a/include/linux/iommu-debug-pagealloc.h
> +++ b/include/linux/iommu-debug-pagealloc.h
> @@ -13,6 +13,20 @@ DECLARE_STATIC_KEY_FALSE(iommu_debug_initialized);
>   
>   extern struct page_ext_operations page_iommu_debug_ops;
>   
> +void __iommu_debug_check_unmapped(const struct page *page, int numpages);
> +
> +static inline void iommu_debug_check_unmapped(const struct page *page, int numpages)
> +{
> +	if (static_branch_unlikely(&iommu_debug_initialized))
> +		__iommu_debug_check_unmapped(page, numpages);
> +}

Same here, possible to make iommu_debug_initialized static?

> +#else
> +static inline void iommu_debug_check_unmapped(const struct page *page,
> +					      int numpages)
> +{
> +}
> +
>   #endif /* CONFIG_IOMMU_DEBUG_PAGEALLOC */
>   
>   #endif /* __LINUX_IOMMU_DEBUG_PAGEALLOC_H */
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 7a1819c20643..3763b71a7d3e 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -36,6 +36,7 @@
>   #include <linux/rcuwait.h>
>   #include <linux/bitmap.h>
>   #include <linux/bitops.h>
> +#include <linux/iommu-debug-pagealloc.h>
>   
>   struct mempolicy;
>   struct anon_vma;
> @@ -4133,12 +4134,16 @@ extern void __kernel_map_pages(struct page *page, int numpages, int enable);
>   #ifdef CONFIG_DEBUG_PAGEALLOC
>   static inline void debug_pagealloc_map_pages(struct page *page, int numpages)
>   {
> +	iommu_debug_check_unmapped(page, numpages);
> +
>   	if (debug_pagealloc_enabled_static())
>   		__kernel_map_pages(page, numpages, 1);
>   }
>   
>   static inline void debug_pagealloc_unmap_pages(struct page *page, int numpages)
>   {
> +	iommu_debug_check_unmapped(page, numpages);
> +
>   	if (debug_pagealloc_enabled_static())
>   		__kernel_map_pages(page, numpages, 0);
>   }

Other changes look good to me,

Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>

