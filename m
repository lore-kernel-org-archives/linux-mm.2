Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90FA7C61DD3
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 16:17:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6683C6B0088; Thu,  3 Sep 2026 12:17:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 618F66B008A; Thu,  3 Sep 2026 12:17:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 556096B008C; Thu,  3 Sep 2026 12:17:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 29C6C6B0088
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 12:17:44 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A81B716057D
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 16:17:43 +0000 (UTC)
X-FDA: 85172956806.03.46B6D55
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf16.hostedemail.com (Postfix) with ESMTP id 91962180003
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 16:17:41 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=WQPzl4p+;
	spf=pass (imf16.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788452262;
	b=LBM4MR/+Zj9hVp91acR+hXjhnKcYR9Dr2R8Rm1tHA5eFp1wfh6LFzdOaWwyhgWWHyp8Nic
	BFGfAHG9qN435t16GYNPgq2W7IIQJ3xxWNTTWGbnUweNNIuPS3l4cCKuNg+PsYoQFXhpsZ
	opna9OauRtdfzxAyWWXnSl2UihKPJZ4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788452262;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cfLON0vOIMCx4YMExE8wsRsSHfIcGi/GWtHqeu9S6sQ=;
	b=o1K7mWU7rRMKKHcCgWdhyCcYjmdb45qhHWKa1/HJF7ycMBXrf/gIdqEL3O0wLvQsmemYpa
	mJ411kUNe2SekE9+r2TnOCDxg4ds/6fNAuIWTAf9R6kqiVMBHfbRMm8EbtGrL8NS3BNyLk
	VAxTZekhKY86WcVLHTXgN43empK/vEE=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=WQPzl4p+;
	spf=pass (imf16.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BCDBD1596;
	Thu,  3 Sep 2026 09:17:36 -0700 (PDT)
Received: from [10.163.139.221] (unknown [10.163.139.221])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BE5C93F673;
	Thu,  3 Sep 2026 09:17:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788452260; bh=IGCjKrKbxdeYpXYZSvcnw7WtqBMc/XxE/M/sNq1isXU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=WQPzl4p+HAJJT3jsTl/2zRjvDVPFttOla1UX2/d2fnrmHSi/X9XHK6EUHX86G52sl
	 aFC0pXXEixydbGJmrY7+FmHm2AJEi6SywD11/HP5SrdlLNCzmEuNeuiY+f242VepQL
	 LXKrXyZOLn3ldtBr3xwOJPf52LEwEBXJ/ZMDjR0s=
Message-ID: <925c45d9-91dc-406a-9ff5-8c16f3ee0d9f@arm.com>
Date: Thu, 3 Sep 2026 21:47:34 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] memblock: use binary search to locate candidate regions
To: Tarun Sahu <tarunsahu@google.com>, dmatlack@google.com,
 Pasha Tatashin <pasha.tatashin@soleen.com>, Mike Rapoport <rppt@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Pratyush Yadav <pratyush@kernel.org>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
 linux-mm@kvack.org
References: <20260903155907.1065681-1-tarunsahu@google.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20260903155907.1065681-1-tarunsahu@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 91962180003
X-Stat-Signature: fwntinbyap8w1ax6apko3bw8x3toi8hf
X-HE-Tag: 1788452261-253115
X-HE-Meta: U2FsdGVkX1++VLMPXOf38w2csj9HCYeX/7/muYClQ0iIWFwzx27g5zyrO8OmT3noRr0s+Y7lwQZOwQx1g+2v0rke6NUyK5ufqLKLWWPpOtd1ZhfykqwkJf7dVkHwg/of2/iOMR+ozSznBzw1r6HSgVo7eVnFSvI3+K9Xt8I+cE38bGwarMh0dEZrwYiDPv3KB1Rkx57UMULbsCIaRJM1RCgJ/vlwSjBZxBLYXZn21NEdEvGxPBajUt1u/B3KdNsgLxJeReclyYHddTHs7F8cqmD6jRBCSXb9qcsu0saPkQahUxOD0Kxt7phA9VXPoqPslSS1vXNELP3xDRIfiyKNDQJeP90pu5yRTK9EFr96XWQnuovAgQPPfsZAhnmAd+Rz0zW04JLU0tba+WZfi2q7OQu/K8Vzm81SLqgGgJ7XAnTwQSEaPH3ongFykzgVtvfOgsNK1y0aRqoEpMUV4F5KOWaHQMm2k2u9MxkAYBLDnw9+x9NXhnBZjRpncea1Lj0MQeWWJkEGziW53OhLOeeErBiwVcJaYcM3suTlW6voJSYNLBx8xOhZmLM4BO78YidBtjrbU8cgtW2bbR1IWQOwFwXmRq2FPwAJUREdwtyncho8ER2gLl8n+/iPReHcQnsa7iPfYKrhuMTmV/blSAc+9KT/AcVJo7TxXWudYjriUIt0Bwj+dVIVRdvteuBbdgbm85gSBZGuyFhFCcO0JaOhx8VXV3VmpDWb0zLMD4s/0hE8DmLrGZ73uj2mUzTHleBQjm0aXgKtocuxkZwE2+Jhhn+vrNbCQeSzYaoOEQGADoMSfNJ68tEPa3cz06w6mvOWVM4lzrCZpC/mwnL3Yybpa5Ahpt+QpLxHSFcxOplLyKvZDWqKSCH9l3tRFygu54O8UuiVVKrGOHegwxIdMH2nR5zyKXeRMY0xV7/IFReVMuc8mpLJMBiFY+zQFVUH3Uj2vh8MOYKC2zZizcTPauJ
 +MjND4r3
 Lg2LqT4NouR2GJZV/LSaokymjlFOJT9IBsXr5kZTkzKR6lkxNZLOwInBH6eHa9UWzyUuNF/4PRTAryheEexocBpbQNF0T+nmNHIBDSwS7B5CvlwReMgREOKUgaVrVJF7QyHXjaiq5dYyRbaP5Az+Zmc+D4awiAkPGGxzF/YTirOrTdrYbgIWQSIAF0CZbObwysEClQuE0y+FVFHZh59j/bf4MxN/Yj4iqk0YFbi2O7e/wHaw0YyN7GuRAs/TLhK1K1hwp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 03/09/26 9:29 pm, Tarun Sahu wrote:
> Use binary search (memblock_bsearch_start) in memblock_add_range() and
> memblock_isolate_range() to locate candidate regions instead of linearly
> scanning from index 0.
> 
> Under heavy memory fragmentation (such as KHO page preservation registering
> hundreds of thousands of disjoint folios), scanning from index 0 on every
> insertion and isolation results in O(N^2) complexity, causing boot-time
> memory retrieval to take several minutes (~268s for 393k pages).
> 
> Using binary search reduces the worst-case complexity to O(N log N)
> (and O(N) for sequential appends), cutting KHO memory retrieval time
> from ~268s to ~50ms.
> 
> Signed-off-by: Tarun Sahu <tarunsahu@google.com>
> ---

I recall noticing this 2 years ago : ) but then abandoned because
I couldn't think of a usecase.

I have forgotten memblock and no idea on KHO, but are you sure
this patch won't have negative consequence for the usual cases?
In other words is this something KHO specific, and in the usual
cases a linear search is more cache/CPU friendly?

Also below I see you have implemented a custom binary search helper.
I recall a generic one is there in some .h file somewhere in the
codebase, perhaps that may be useful, just FYI, ignore if already
tried that.

>  mm/memblock.c | 38 ++++++++++++++++++++++++++++++++++++--
>  1 file changed, 36 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/memblock.c b/mm/memblock.c
> index 9ce86349a29f..88940474b020 100644
> --- a/mm/memblock.c
> +++ b/mm/memblock.c
> @@ -160,6 +160,11 @@ static __refdata struct memblock_type *memblock_memory = &memblock.memory;
>  	     i < memblock_type->cnt;					\
>  	     i++, rgn = &memblock_type->regions[i])
>  
> +#define for_each_memblock_type_from(i, memblock_type, rgn, start)	\
> +	for (i = (start), rgn = &memblock_type->regions[i];		\
> +	     i < memblock_type->cnt;					\
> +	     i++, rgn = &memblock_type->regions[i])
> +
>  #define memblock_dbg(fmt, ...)						\
>  	do {								\
>  		if (memblock_debug)					\
> @@ -591,6 +596,33 @@ static void __init_memblock memblock_insert_region(struct memblock_type *type,
>  	type->total_size += size;
>  }
>  
> +/**
> + * memblock_bsearch_start - Find the first region index where rend > base
> + * @type: memblock type to search
> + * @base: base physical address of the candidate range
> + *
> + * Returns the first region index that could potentially overlap @base.
> + */
> +static int __init_memblock memblock_bsearch_start(struct memblock_type *type,
> +						  phys_addr_t base)
> +{
> +	int mid, low = 0;
> +	int high = type->cnt;
> +
> +	if (type->cnt && base >= type->regions[type->cnt - 1].base +
> +				 type->regions[type->cnt - 1].size)
> +		return type->cnt;
> +
> +	while (low < high) {
> +		mid = (low + high) / 2;
> +		if (type->regions[mid].base + type->regions[mid].size <= base)
> +			low = mid + 1;
> +		else
> +			high = mid;
> +	}
> +	return low;
> +}
> +
>  /**
>   * memblock_add_range - add new memblock region
>   * @type: memblock type to add new region into
> @@ -651,7 +683,8 @@ static int __init_memblock memblock_add_range(struct memblock_type *type,
>  	base = obase;
>  	nr_new = 0;
>  
> -	for_each_memblock_type(idx, type, rgn) {
> +	for_each_memblock_type_from(idx, type, rgn,
> +				    memblock_bsearch_start(type, base)) {
>  		phys_addr_t rbase = rgn->base;
>  		phys_addr_t rend = rbase + rgn->size;
>  
> @@ -827,7 +860,8 @@ static int __init_memblock memblock_isolate_range(struct memblock_type *type,
>  		if (memblock_double_array(type, base, size) < 0)
>  			return -ENOMEM;
>  
> -	for_each_memblock_type(idx, type, rgn) {
> +	for_each_memblock_type_from(idx, type, rgn,
> +				    memblock_bsearch_start(type, base)) {
>  		phys_addr_t rbase = rgn->base;
>  		phys_addr_t rend = rbase + rgn->size;
>  


