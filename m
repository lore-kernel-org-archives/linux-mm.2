Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD501C44506
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 17:58:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B6656B0005; Thu,  9 Jul 2026 13:58:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88EAC6B0093; Thu,  9 Jul 2026 13:58:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A4D46B0096; Thu,  9 Jul 2026 13:58:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 56CFF6B0005
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 13:58:08 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E1C0514022C
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 17:58:07 +0000 (UTC)
X-FDA: 84969997014.07.DB70D68
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	by imf29.hostedemail.com (Postfix) with ESMTP id 0B41B120008
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 17:58:04 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=QinGRakq;
	spf=pass (imf29.hostedemail.com: domain of dave.jiang@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=dave.jiang@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783619885;
	b=vkj0M35kSUhFMiEZihGebrmlbYQni+z7klZRxE7/mbL2DO4LsWfhHvywXW36PG2xwv6XAu
	fm4W05ZSJhZoHO3Ckp3nrqCRPwNDHhK7+y+ep4xLXK62vpb9xCyIGkgyNqBa5crHseGhKd
	eR6dD+G7NdTMrriFxtIFeoh9PFV7XUw=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=QinGRakq;
	spf=pass (imf29.hostedemail.com: domain of dave.jiang@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=dave.jiang@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783619885;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J8oTXoMIeSNhsW15lhFkm553ZQb04PxScfwo/mcUww8=;
	b=JQ2eN8M3adms6HdVd1WaprZn8j9S3gaKAFf8KzE2y09LyMMG/om19aV2s/nQ7bv0IhyiHH
	P5wvV0SqHNjCWqkhqUGbcpVXJ+zj4K1QKd6fDwiyMG3HiquAbzoxAW5YFtVTxfdG/kwqUp
	U+Fn0M/Sj1lW2EuuORdichB8KstET4w=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1783619885; x=1815155885;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ueCfC8mj9W6I1SlYqEpl674vMNV2wFKokvVZLAzEXzA=;
  b=QinGRakq01yGwXdvDvTquHr/s0RRan5Ir9XySXk02l8qZeAiKN9413ae
   3MtNp0rnXpHM3kzqarMKgLcB7pM6Fe6tdspo3gIerElyAEREkn6zX3FPt
   aERtWyPEE0DecN+W6ea/LB56siGEjTzLIvcyYC2aeDDGfiv2tsdgT5cBO
   /7Tp6HlwCQ0U/R7isW3ZiZmG3Tbm5M0XtH39PqZ70wgezHqv3o1bEXq//
   gJR7XHW5i7h4esRokBI7hasKC5zaFsrHoo9rPRqBeCKL0tDmXrFsmAKYr
   F2bMhE5zt8t+gYsqiJjWjNryf+dCM6HiGZNQ1Gz7rsPN9TEVTvYQJ0J7m
   g==;
X-CSE-ConnectionGUID: MXdQV1tAR5W1jgVNCt+9VQ==
X-CSE-MsgGUID: DqjvzKuWREyi1BgKEsIUiQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11841"; a="88139587"
X-IronPort-AV: E=Sophos;i="6.25,154,1779174000"; 
   d="scan'208";a="88139587"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2026 10:58:04 -0700
X-CSE-ConnectionGUID: hf/hEBL1SMaZOpk5XqzpzA==
X-CSE-MsgGUID: mMZej/BNT82mbag9beBfMw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,154,1779174000"; 
   d="scan'208";a="252920685"
Received: from bradocaj-mobl.ger.corp.intel.com (HELO [10.125.111.142]) ([10.125.111.142])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2026 10:58:02 -0700
Message-ID: <c4e18591-137f-4827-b635-a8662a44fe9d@intel.com>
Date: Thu, 9 Jul 2026 10:58:00 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 01/10] mm/memory: add memory_block_aligned_range()
 helper
To: Gregory Price <gourry@gourry.net>, linux-mm@kvack.org
Cc: nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org,
 linux-cxl@vger.kernel.org, driver-core@lists.linux.dev,
 linux-kselftest@vger.kernel.org, kernel-team@meta.com, david@kernel.org,
 osalvador@suse.de, gregkh@linuxfoundation.org, rafael@kernel.org,
 dakr@kernel.org, djbw@kernel.org, vishal.l.verma@intel.com,
 alison.schofield@intel.com, akpm@linux-foundation.org, ljs@kernel.org,
 liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, shuah@kernel.org, iweiny@kernel.org,
 Smita.KoralahalliChannabasappa@amd.com, apopple@nvidia.com
References: <20260630211842.2252800-1-gourry@gourry.net>
 <20260630211842.2252800-2-gourry@gourry.net>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20260630211842.2252800-2-gourry@gourry.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 0B41B120008
X-Stat-Signature: yix6peftbqncbijdehjmfx4ho8hwuqc9
X-HE-Tag: 1783619884-590274
X-HE-Meta: U2FsdGVkX1+ezO9UoVLpS/AY3ApVfZzq8euagFtsYLZ/udJ5k0Aei6g2X5iATjsUQQ2Qyv74U62PIqtQbbkU4FmAJ49XQT1W505dGyUnB7qAqwr2Liu+MW3rimVXJ19zTtMUIArK5EgPrtBDttcTOtujKpY565fVA5uHRw1RX2kEuWOsqxncTJImxT+iW7xSyrlt3VPAnV5gB0BUKTWztyZ+wtkgt/I85Gbc7Mq6+z536C3H5XHZ24x+6MXdvNKlDWOX0pv8XH4ZYQLZFYjoLCeF7eyfy1H0C6ch0gEMqhR53ldntmbsAVs/MIO9arvCu0FAbPmjESatdXcS8ugD2cELEpEtuGKWlQp+J4WCEXo7anXdVZtiTnGYyORAFfRSpSeOd8tonCTJJ33zS5aPsLSrub8+9ejLXoYacFy92LJqVV6OBASfrUSD88Te96sH9hfB1UAae+CXYSzhwwda+GJcvRWT1REVI2ulvYvfNAtZNPSm8RVEEpjAeRXZaMIZ+G1IxxdU7aUblyXYAWKKC92cEXrlWeL7v2lOByQx6STsXA9QRhzAzPm2GxaNU23FU4XLHNqEIi7gNzIROeRJapkyu6QNpL/GPRSD4u1TOxQuVfBZVBu99gWsba0FmmHks2Nem8lvmYXFgUK7wmD8mWdtsPZy2RN2QdoI0gJCEoYB6n+8/n0XnjvaBIwd+izWS/8Hj7JBDWIja9SsxINz9rLCtZNqjtvJbhJWcNvwmQjzR2ryaLAMQQxFVKTtsJrkQY8HK3oN4r8M+m6kvaB16xBUs/Q7Rn6fme0QURtkWpGlLFEcQQC39ERq65T2wQx5ExjpKzVyvLbRMgv9MLcgN0UOVreQQ2MBjalWnz1cVKAgA8x7y1Mpd2ooo5htngY2UTH0ONl+1vDW3lOPujAsLCe5EOQyiVywWsHIRHYNZCTuODeddHue8L1MJFE28Yd7HBGu0HvR6zpAIBkeh9X
 RO9r88KL
 5vftiKAgYkjbFIJmZKPoc+OMF1KsRXFOfbWz8QTxcaRZhZ1pybtruKAfAdWfaO51vUe1CMxnVcNoAfg6SPdI3V8uEP+Gu9r6Cb9/6TEiVv2J9phsYVNnBk2qY050U+1hJvw/pB0ezEUAdXllqKbZq5XdHVCQypKIZsEvncVjD+q4GTp5JjdJUzpsPkMV4LEc0FX0s8j3k0eKnhKZK2oRdHUYwWrIndG7U76msxklYA9+kkQdTJ+SfEjyMSHYIf4V8FPMiXWBoVyc5poAvKfNCM85FJVXYOM5fX5UZUmIML1zUAs3Y4lH0+jJKnO7lkjOBKRlCMjsgMNGZ4UAJVIq/z9To1/7wA4RUl6gSlt0RSBlCroVDtWlREeKxjzSV9XzaZI1cat62uqzJJThal47GwvpjDYBABSrSCoon94v+ALxfJI0prDHwiAu6kw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 6/30/26 2:18 PM, Gregory Price wrote:
> Memory hotplug operations require ranges aligned to memory block
> boundaries.  This is a generic operation for hotplug.
> 
> Add memory_block_aligned_range() as a common helper in <linux/memory.h>
> that aligns the start address up and end address down to memory block
> boundaries.  Guard against end underflow when the range falls below the
> first memory block boundary, returning an empty range instead.
> 
> Update dax/kmem to use this helper.
> 
> Signed-off-by: Gregory Price <gourry@gourry.net>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> ---
>  drivers/dax/kmem.c     |  4 +---
>  include/linux/memory.h | 27 +++++++++++++++++++++++++++
>  2 files changed, 28 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/dax/kmem.c b/drivers/dax/kmem.c
> index a18e2b968e4d..592171ec10f4 100644
> --- a/drivers/dax/kmem.c
> +++ b/drivers/dax/kmem.c
> @@ -33,9 +33,7 @@ static int dax_kmem_range(struct dev_dax *dev_dax, int i, struct range *r)
>  	struct dev_dax_range *dax_range = &dev_dax->ranges[i];
>  	struct range *range = &dax_range->range;
>  
> -	/* memory-block align the hotplug range */
> -	r->start = ALIGN(range->start, memory_block_size_bytes());
> -	r->end = ALIGN_DOWN(range->end + 1, memory_block_size_bytes()) - 1;
> +	*r = memory_block_aligned_range(range);
>  	if (r->start >= r->end) {
>  		r->start = range->start;
>  		r->end = range->end;
> diff --git a/include/linux/memory.h b/include/linux/memory.h
> index 463dc02f6cff..1783299073e4 100644
> --- a/include/linux/memory.h
> +++ b/include/linux/memory.h
> @@ -20,6 +20,7 @@
>  #include <linux/compiler.h>
>  #include <linux/mutex.h>
>  #include <linux/memory_hotplug.h>
> +#include <linux/range.h>
>  
>  #define MIN_MEMORY_BLOCK_SIZE     (1UL << SECTION_SIZE_BITS)
>  
> @@ -100,6 +101,32 @@ int arch_get_memory_phys_device(unsigned long start_pfn);
>  unsigned long memory_block_size_bytes(void);
>  int set_memory_block_size_order(unsigned int order);
>  
> +/**
> + * memory_block_aligned_range - align a physical address range to memory blocks
> + * @range: the input range to align
> + *
> + * Aligns the start address up and the end address down to memory block
> + * boundaries. This is required for memory hotplug operations which must
> + * operate on memory-block aligned ranges.
> + *
> + * Returns the aligned range. Callers should check that the returned
> + * range is valid (aligned.start < aligned.end) before using it.
> + */
> +static inline struct range memory_block_aligned_range(const struct range *range)
> +{
> +	struct range aligned;
> +
> +	aligned.start = ALIGN(range->start, memory_block_size_bytes());
> +	aligned.end = ALIGN_DOWN(range->end + 1, memory_block_size_bytes());
> +	/* No whole block fits (e.g. range below the first boundary): empty. */
> +	if (aligned.end <= aligned.start)
> +		aligned.start = aligned.end;
> +	else
> +		aligned.end -= 1;
> +
> +	return aligned;
> +}
> +
>  struct memory_notify {
>  	unsigned long start_pfn;
>  	unsigned long nr_pages;


