Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E25B4C55182
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 08:05:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0644E6B00B3; Wed,  5 Aug 2026 04:05:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 03BE06B00B5; Wed,  5 Aug 2026 04:05:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E93746B00B7; Wed,  5 Aug 2026 04:05:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C57266B00B3
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 04:05:44 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 354791C0BCC
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 08:05:44 +0000 (UTC)
X-FDA: 85066481808.19.A156B11
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 656D9C000C
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 08:05:42 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=N+BPo4fJ;
	spf=pass (imf22.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785917142;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WlWmclLxMbxgIKt8ZJlnFMYyToasIJDqcYbt0xVIxfc=;
	b=xPXwcJ+bya+NFFKXavk6zxRGDTKRP9uTAOVK1S54EqbdS0WULihWwtqyj4Wu02klwdNrTU
	LRukEjVoBGileu2ZP+4PMqpBfHbOSfmg8ssrEUkjfG8UaOvnJux0KCoAZQG287fiQ/XZS6
	9TClpU9jUZGpDEHiY0KC20bMgK0QpQE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785917142;
	b=eH/teDCpm4cFs0FurJV2DhpTVtTjb3QTrLTtKHJb5w3BKx9Z7Jz8RmCjCyQGacvH9hwIs6
	2v4WaUWo9mDfW6ti9iSJyzoAHs4QYnzDtN05EF8RzbLtrvQMiYm76ALfkrV4J+Q/UQFnEy
	LRc6c1Uvy4kqHXgfI7JzPqo1VNdPEps=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=N+BPo4fJ;
	spf=pass (imf22.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CD33540135;
	Wed,  5 Aug 2026 08:05:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 736A91F00A3A;
	Wed,  5 Aug 2026 08:05:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785917140;
	bh=WlWmclLxMbxgIKt8ZJlnFMYyToasIJDqcYbt0xVIxfc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=N+BPo4fJW0lH1WBNMYiJ0hH2jemyATsVOoVT0bVK3mgS+shzCNJOwl8DD1Z4N4j5h
	 rowtvOyYMjqTyMUCYX4T7JqjQbJy3F9voh8tmlQeqKGa/apS+UDtNJmo7T5JdFyNoK
	 /I/H4xwDV6ZtGADOkfoop9mpTNLRC5IQMfnhf78Uorjm4Yvt8hZNvyCokeCJ4BynRk
	 azXWwrQXWdeOyo2tc8moU9RO7s+IMTo5O+NFT3y+l14T8XkothYCOBZCU5+2szXZ3E
	 Y9yotlM5XnD3fhpvp+/53ibHDpUypnXAqvRdixhEJVo69ctN7ZYABZWFCRpxsDafU7
	 eJ0OyKNEIlJJw==
Message-ID: <15be272e-a42a-4141-bd57-a8abae435728@kernel.org>
Date: Wed, 5 Aug 2026 10:05:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/show_mem: fix format string inconsistencies and type
 mismatches
Content-Language: en-US
To: Ye Liu <ye.liu@linux.dev>, Andrew Morton <akpm@linux-foundation.org>
Cc: Ye Liu <liuye@kylinos.cn>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <brendan.jackman@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260805021556.1908807-1-ye.liu@linux.dev>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260805021556.1908807-1-ye.liu@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 656D9C000C
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: kthwmeq66bb86ch5rrsk4zs7w85x6i5x
X-HE-Tag: 1785917142-135182
X-HE-Meta: U2FsdGVkX19dwWsjYyuSuAYS9neCNLC0u8ywRAh0VsQGLvDotAV7+ThrnMd8Z/JpztqbBQBCl13bccldU7HLNtZbEaM8Dt1JzBnzE25bxqFYFW1Nx3frH46AWXNNuj37GCsne3FhAmcL37RemwLMUg8lREIJqYxAqtXYJNKpOl78+doVhgkwZ1N9ci9qCOuzBeXE1lAMsnak37HawcLkrS5vV7fx35pwUHenFkyDJplOjYCWXpzM+pCy+NwG3DPGIqrzmed8yJG+JpQmYuYCLuYyW0imve2Wz7Y2FS8e3/JMhgCmJvTUM2lJuuI1eF1w4nE2CgAECT9EMQvB5U80r01yC36+fzpDthDA/gpm+BLEvCY0+TdtDFU7aOHwKSNsDfd3Zurgse12+CSIl4hF88+W9sW5fa8m7O47Iq+GtGjdD4OCvqYYvDzj3t+Gd7digOLJa2xh4KEOajm+mEGkKZsli+5CMP0xeTF9DgluLk+fIFqO+opJ6J2ab9ewe2OcKNOitRGk5kgXfUa6VOL07BxW3bNS3n2jP0zE7PQ/614ir4medspVB5YKnLOtHL6XCzjjuqJdzvQH1uvAoBtrYEolP6AShAC01bwnw8c/yQdpVoBhSZhOOvSAZD4u9oP89a1ciQBzSftrwZh54rKW1VWn3oCg46QCLrGH6iSOaR9aT4COA1OrniJPErmQV8tWbHqYLz9Nxh2WmOp0ULx5sthY3LvuoxXSi389dZc/NH9qCaO412OuaT6maXOVEQuHWkycjPtb857vV0zYfTYUH4VqMfSieo+t5agMxuJlWZciQKg4e+6N25VajL3sdFIOuUY9c5nFtp9/FLnnG+Sw9H5JK9PZqm0U8CwZjN1zrUUpjnKFItCsv1fuAR8aJG0AdNN6hzS2iNrfBUtz6kGvXrdqjmFSn6Oi2Ss7WP8KNTFOWLcbpNtKebALVEd0Fnvl6V0X8y/UCJfGn0KTLB8
 3rlAU44v
 QZvSWoKfxRn+/oaw0h/DUtJC+LezKD+XdEQWZSQ/wCMllegzSun3n8M8/PxMM6PRSp+/u+6ndI9Kkbogdvypr40MVq13UwwHo5rR9imp3RGw3UebNjd6dOGVrsR/K3Vt3sNxwRa+ZGsXqdyr0VKZTFdXh5lklPceZZyQOo5wQibDZruHFCrP8dlH9XjX/ipgAv3XHy98NafTc2sXRA3xiHJfLnKd3Du1JNHDr0CsX9+gd4/wfX5s545NBpeUZAHBjR9p7/wxxwnf8oaW057BSA4evu8XvXk/i259Zxu8cg4S+39kQBTVnq0iLaIz/PdRWRm4qkj1umiayyl0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/5/26 04:15, Ye Liu wrote:
> From: Ye Liu <liuye@kylinos.cn>
> 
> Fix five format string issues in show_free_areas() and __show_mem():
> 
> 1-2. reserved_highatomic and free_highatomic: %luKB -> %lukB
>    The uppercase "KB" is inconsistent with all other fields in the
>    same output block and with /proc/meminfo convention.
> 
> 3. local_pcp: %ukB -> %lukB with explicit (unsigned long) cast
>    per_cpu_pages.count is int, so K(count) yields int. Using %u
>    was a signed/unsigned mismatch. Cast to unsigned long and use
>    %lu for consistency with all other K() usages in the file.
> 
> 4. total pagecache pages: %ld -> %lu
>    global_node_page_state() returns unsigned long. Using %ld is a
>    signedness mismatch caught by gcc -Wformat-signedness.
> 
> 5. hwpoisoned pages: %lu -> %ld
>    atomic_long_read() returns long (signed). Using %lu is a
>    signedness mismatch caught by gcc -Wformat-signedness.
> 
> Verified with: make KCFLAGS="-Wformat -Wformat-signedness" mm/show_mem.o
> 
> Signed-off-by: Ye Liu <liuye@kylinos.cn>

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

> ---
>  mm/show_mem.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/mm/show_mem.c b/mm/show_mem.c
> index d1288b4c2b64..b938cbcd774a 100644
> --- a/mm/show_mem.c
> +++ b/mm/show_mem.c
> @@ -309,8 +309,8 @@ static void show_free_areas(unsigned int filter, const nodemask_t *nodemask,
>  			" min:%lukB"
>  			" low:%lukB"
>  			" high:%lukB"
> -			" reserved_highatomic:%luKB"
> -			" free_highatomic:%luKB"
> +			" reserved_highatomic:%lukB"
> +			" free_highatomic:%lukB"
>  			" active_anon:%lukB"
>  			" inactive_anon:%lukB"
>  			" active_file:%lukB"
> @@ -323,7 +323,7 @@ static void show_free_areas(unsigned int filter, const nodemask_t *nodemask,
>  			" mlocked:%lukB"
>  			" bounce:%lukB"
>  			" free_pcp:%lukB"
> -			" local_pcp:%ukB"
> +			" local_pcp:%lukB"
>  			" free_cma:%lukB"
>  			"\n",
>  			zone->name,
> @@ -350,7 +350,7 @@ static void show_free_areas(unsigned int filter, const nodemask_t *nodemask,
>  			K(zone_page_state(zone, NR_MLOCK)),
>  			0UL,
>  			K(free_pcp),
> -			K(this_cpu_read(zone->per_cpu_pageset->count)),
> +			K((unsigned long)this_cpu_read(zone->per_cpu_pageset->count)),
>  			K(zone_page_state(zone, NR_FREE_CMA_PAGES)));
>  		printk("lowmem_reserve[]:");
>  		for (i = 0; i < MAX_NR_ZONES; i++)
> @@ -400,7 +400,7 @@ static void show_free_areas(unsigned int filter, const nodemask_t *nodemask,
>  		hugetlb_show_meminfo_node(nid);
>  	}
>  
> -	printk("%ld total pagecache pages\n", global_node_page_state(NR_FILE_PAGES));
> +	printk("%lu total pagecache pages\n", global_node_page_state(NR_FILE_PAGES));
>  
>  	show_swap_cache_info();
>  }
> @@ -430,7 +430,7 @@ void __show_mem(unsigned int filter, const nodemask_t *nodemask,
>  	printk("%lu pages cma reserved\n", totalcma_pages);
>  #endif
>  #ifdef CONFIG_MEMORY_FAILURE
> -	printk("%lu pages hwpoisoned\n", atomic_long_read(&num_poisoned_pages));
> +	printk("%ld pages hwpoisoned\n", atomic_long_read(&num_poisoned_pages));
>  #endif
>  #ifdef CONFIG_MEM_ALLOC_PROFILING
>  	static DEFINE_SPINLOCK(mem_alloc_profiling_spinlock);


