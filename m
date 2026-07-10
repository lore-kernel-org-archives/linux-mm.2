Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC230C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 07:05:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A49A86B0088; Fri, 10 Jul 2026 03:05:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9FA466B008A; Fri, 10 Jul 2026 03:05:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E86E6B008C; Fri, 10 Jul 2026 03:05:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 64F8D6B0088
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 03:05:51 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DC2DE14038D
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 07:05:50 +0000 (UTC)
X-FDA: 84971982060.16.6AA306E
Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	by imf04.hostedemail.com (Postfix) with ESMTP id 11F0740006
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 07:05:48 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PfumpgFU;
	spf=pass (imf04.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783667149;
	b=lHXSHGNxh70vLajLCB5qkzjhwJFs0Ef4hIeB4C8l7a3a1YSN5JacBPrrk13NHo89aWpqSI
	ydxvEwtvmwdtVwuNrSsP1jbL4fJMSL6DzdyjAwn2LnHqd6jotKrUdO1XSsR8IASBUDNqxY
	0sJvWdBBLOxFdeEsztvhMxrzC8QBoX0=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PfumpgFU;
	spf=pass (imf04.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783667149;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2IeWWRnXJl0FyJaE8bU1EmfZ2s+EZ/aZ88TxmbZe9QA=;
	b=2Mcx+BDaihiqOoWdaPzqaewM1GUlZs9x5uohDO0tLpIlHreoCO6zgoTCMfuFHNciMq87DR
	aJpip6IcTXYnOgvw3Z2GIYbjYg0QYPc8k8Mjz+I4p4RQey0Myt+d5pjiaza8cke3SS03bu
	97tcWwCD0lvExpjzchVVPQ2sPuZNrQg=
Message-ID: <9d8627fe-1fb6-47ff-9ca9-ff3b90a12bd8@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783667147;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2IeWWRnXJl0FyJaE8bU1EmfZ2s+EZ/aZ88TxmbZe9QA=;
	b=PfumpgFUc91Ke3c1jMEhn6jql0L7RatPOOPesyVnqRXUKc1TX6MQ6By9Q1FgPLmxbiGVlQ
	ttEihD1vbh7LnM1q5LEYFOR1UMmrApPmSiORLB1gWcIJRRZczywx2FIhnf/fyFbgz8g9S6
	Snsc6khHrR7KNX8xPXw91Sbz2tINA2k=
Date: Fri, 10 Jul 2026 15:05:18 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v5 0/9] mm/page_owner: misc cleanups
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Zi Yan <ziy@nvidia.com>, Vlastimil Babka <vbabka@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260701061101.344679-1-ye.liu@linux.dev>
 <20260701171115.79148d1c7e4f07ebf419c185@linux-foundation.org>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Ye Liu <ye.liu@linux.dev>
In-Reply-To: <20260701171115.79148d1c7e4f07ebf419c185@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 11F0740006
X-Stat-Signature: babgdedajb9t9t6bqynsae311r1dojpd
X-HE-Tag: 1783667148-4599
X-HE-Meta: U2FsdGVkX19UrNpSNIWeRdoFBuERRGdTzAdi6MdFPjDNRDu8hMOJlXWeJbe14wHG/vV7sDcIHrBmNpVyqOXu+uONg4n/fF5Fl0PSfRdgvg42ut+vmh4GLM/JvKhN1cjv8ZVCGqt6HrSes4xcRc6nsQmqCckHpVZ4En059lYNkXXwSYXaNy6Vc0TMbrD43sSLPezWvU1izOyv7YpsXZmICOnS3TUPjSfjOrsO/269v3hqnUcqu/BjIuVMJqxlL+JQYThHz/+1KBXwunOpBjXVdJa6oyIBjtg/IA49OBTrIXrheEN6wzEcXEobMLfPUugHV89dZJDzY4OzoLLlIxTA/8hRP7Bnq2uGge+2aeANt8KeMIpCVHpI0bx57sxZ+TUcA5GNVywosC9K/S4BzQ2hvpDWEXUK4q8NRPcyDKRzwD4R3V1VNii46wu+1xn7aYLGOVzHDOGK3ZhuoBN0YCAdth7huJrAK4MHVHyKsftdtln8j0utWw5Zq0TIdy4s1QZKVCTjURyajbpjsPdvDEYAuyB1ZF3y3TiqxfLiPjy+I1fcHrrPNjpeYut1rnSgamBRviFzF20gp4/P9Huvbo4R3SNO3HDHo2fwjGjQHEUf7YlcY+0BZcooQJOerBGY2egvUMRVA1YM/7FyMqkct9l+dgOf8IA6W4GNf0di3AViTY8+hjkwv842QFEsrhL8DhXBNDBs32QDLEqakZS50kXWMWU47PLJzVBucYXajGNoCgO2elzlJqwQhzIOdanpgijdcWjh91yhMdpuO+s9ypR6oTi8pnp08PeIQkKaS0j7by/CmYtg7bgztqiU1Sjhot8nXtIckjHB0PfzcSocV1/rXY+PWETBqK9s0deLne6zh0G5mQQJSbIunEbSPJdqCLjNOe2muY/lZelcsdH/VQfah4er6/ebaONHj7kl1SJL7tH487Z1T4lfJxRHGYt9cywy0grD+DbiR4DEClAoqAB
 DXqVnDLZ
 RgLM1nv2UNUnm6qhcVSQh+y/Pd+tPbLxY3363e8ujlo1rDGBcnbi0/1R/Vq+9g9AkQ6Q06y8kBYa0ICxrKczvRll99rpdeD/q02Rvbm0Efqza3+fOuv0MM40bkfYzPEYvjOF7h+101gg1TkQGdlrSVeYx3djQJHXNQXFELemrM5kehJOsaXiGgf6XJrSl0HGGkeh7RJldXeYIED92ca71JOGXNPoPxx3m1EWLvbcHnq/R/x+oLe3XNfBGiw+zM3OATi1XNq+Z7pfYz+Ry/xqJtI1TNGnvRaNcN7MnFcW90L8FUoftKj22OQB6Dj8fBaFu6oXvMehhwQMcNdgnV6g9t7fMEnceEstvN6/NztSP/KLej44=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2026/7/2 08:11, Andrew Morton 写道:
> On Wed,  1 Jul 2026 14:10:43 +0800 Ye Liu <ye.liu@linux.dev> wrote:
> 
>> This series collects a few cleanups for mm/page_owner.c that have been
>> accumulated while reading through the file.  There is no functional
>> change -- the goal is to make the code easier to read and maintain.
> 
> Thanks, updated.
> 
> And...  this series is wearing out my keyboard.  Please leave it a
> week, gather up any additional feedback and only then send v6, if
> needed?
> 
Sorry Andrew, I had more time last week and updated more frequently.
I will wait and communicate fully for each version.

> btw, it's conventional to place the what-changed-since-last-time info
> below the ^---$ separator rather than at top-of-changelog.  That's where
> we place info which isn't appropriate for the mainline tree.
> 
I also have a question about this. Is the changelog placed in [PATCH 0/N] 
or in the patch [PATCH M/N] that needs to be modified? 
I've looked at some content on the mailing list, 
and it seems there are both options.
> AI review flagged another possible pre-existing issue.  A second
> occurrence of the race your "mm/page_owner: fix TOCTOU races in
> lockless page state reading" series addresses:
> 
> 	https://sashiko.dev/#/patchset/20260701061101.344679-1-ye.liu@linux.dev
> 
I will fix this warning in [PATCH 9/9] of V6.
>> v5:
>>  - Place the two patches corresponding to the Close connection, patch8 
>>    and patch9, together in this part.
>>  - Close: https://lore.kernel.org/all/20260625014708.87386-1-ye.liu@linux.dev/
>>  - Link: https://lore.kernel.org/all/20260701012239.315262-1-ye.liu@linux.dev/
> 
> Below is how v9 altered mm.git.  This is the addition of your
> "mm/page_owner: fix TOCTOU races in lockless page state reading"
> series, 
> 
I've added this part to this patch series. 
And how to close https://lore.kernel.org/all/20260625014708.87386-1-ye.liu@linux.dev/ ?
> 
> 
>  mm/page_owner.c |   16 +++++++++++++---
>  1 file changed, 13 insertions(+), 3 deletions(-)
> 
> --- a/mm/page_owner.c~b
> +++ a/mm/page_owner.c
> @@ -428,6 +428,12 @@ void __folio_copy_owner(struct folio *ne
>   * to skip less than the full buddy block, but that is acceptable for page owner
>   * iteration purposes.
>   *
> + * The lockless read of buddy_order_unsafe() can also return a garbage order if
> + * the page is concurrently allocated and PageBuddy is cleared between the check
> + * and the read. Clamp the advance at the next MAX_ORDER_NR_PAGES boundary so
> + * that a bogus order cannot carry @pfn into an unvalidated memory section,
> + * which would break callers that rely on boundary-aligned pfn_valid() checks.
> + *
>   * Return: true if the page was skipped (caller should continue its loop),
>   *         false if the page is not a buddy page and should be processed normally.
>   */
> @@ -439,8 +445,12 @@ static inline bool skip_buddy_pages(unsi
>  		return false;
>  
>  	order = buddy_order_unsafe(page);
> -	if (order <= MAX_PAGE_ORDER)
> -		*pfn += (1UL << order) - 1;
> +	if (order <= MAX_PAGE_ORDER) {
> +		unsigned long new_pfn = *pfn + (1UL << order);
> +		unsigned long boundary = ALIGN(*pfn + 1, MAX_ORDER_NR_PAGES);
> +
> +		*pfn = min(new_pfn, boundary) - 1;
> +	}
>  
>  	return true;
>  }
> @@ -551,7 +561,7 @@ static inline int print_page_owner_memcg
>  	cgroup_name(memcg->css.cgroup, name, sizeof(name));
>  	ret += scnprintf(kbuf + ret, count - ret,
>  			"Charged %sto %smemcg %s\n",
> -			PageMemcgKmem(page) ? "(via objcg) " : "",
> +			(memcg_data & MEMCG_DATA_KMEM) ? "(via objcg) " : "",
>  			online ? "" : "offline ",
>  			name);
>  out_unlock:
> _
> 

-- 
Thanks,
Ye Liu


