Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD816C79F85
	for <linux-mm@archiver.kernel.org>; Sun,  6 Sep 2026 10:25:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD9696B0088; Sun,  6 Sep 2026 06:25:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB14A6B008A; Sun,  6 Sep 2026 06:25:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC71D6B008C; Sun,  6 Sep 2026 06:25:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AF8AD6B0088
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 06:25:35 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1EC1F1604C6
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 10:25:35 +0000 (UTC)
X-FDA: 85182955830.17.FD52F96
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 740D380002
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 10:25:33 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aT+A71hJ;
	spf=pass (imf30.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788690333;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2XPq6jBsWxzSGkLN5JMNAqBj9VumCx6phCWWl2LqB4Y=;
	b=JTctQHhzFVHGBrg3+MXVuqCxUf+0Z4fZfNbsI4ylcjp2KbML+qYT0nq2Th1NCGM5ctSnI+
	SLw1BBlmWIRdbcTVo5TPVw00HbfcDMYLZDCdpsYD/5vXxfhd+TU1KsxSbnfB5AucE3sE5o
	KCE8ghakASejgWSbB6gP1ogmTRc7fK8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788690333;
	b=L/4oxPcOMq++xaank63fVxIvyVsshvigsp6K6ZgDi/UX31TnwI8D9oVHydeq0q8oo/ZJLl
	HIUmH/tggViRz2KcYXcAm/R5EQWODRbDWm5O+zgsUOT4GNHhuIp3FMETUujiOvCFW80P7W
	sSIshVFHma1z7eGm8q3jQoSa56PrxGA=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aT+A71hJ;
	spf=pass (imf30.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 51F6F40C51;
	Sun,  6 Sep 2026 10:25:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C4E71F00A3A;
	Sun,  6 Sep 2026 10:25:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788690332;
	bh=2XPq6jBsWxzSGkLN5JMNAqBj9VumCx6phCWWl2LqB4Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=aT+A71hJ8NCIRzwZvUAlmCF2acDHq2xysOzGVgGT3iPsEhswJ4mdi3jeaJj0iN+1f
	 HJ8Wr8RRz4il12phVpTJYqK7TZm6HBoFHc23BkPlzoVI5sOLzIcKxRJuafbti3zxqq
	 bBXfVWqy+KEdv6XsvE4Qy0digyusQeELvEYWRpU8teA74oWoYP3Zt0fHRT4wrmKt5g
	 0m94g72F2kB5Tbe47F6EGnNZHQc88m1JsxF1TNvzE9iMJY45iWStpPyPTxmO6fgjcY
	 wZ3IdvyxptArEnj1FQAsXDPHZTNWBFUPdAkGExdGbWnfmejDhiw5BQZPl6GBlhefSg
	 0tHqpXaRiaZLg==
Date: Sun, 6 Sep 2026 13:25:25 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Tarun Sahu <tarunsahu@google.com>
Cc: dmatlack@google.com, Pasha Tatashin <pasha.tatashin@soleen.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Pratyush Yadav <pratyush@kernel.org>, linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org, linux-mm@kvack.org
Subject: Re: [PATCH] memblock: use binary search to locate candidate regions
Message-ID: <ap0_lSVF43FP3PPb@kernel.org>
References: <20260903155907.1065681-1-tarunsahu@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260903155907.1065681-1-tarunsahu@google.com>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 740D380002
X-Stat-Signature: z44q8w81z6cyexkfanxm8rn7dapd9osc
X-HE-Tag: 1788690333-967575
X-HE-Meta: U2FsdGVkX18ofRKIctarkkROj7dq1Kb/gDfYtzD6AV4zRmqSvtwgF6CXrVvyABAyR3Lkb4Mun6apiDlSMWF84+eYCvsbrGUvkF8W7by0kKlWogNuVHbafOVezbHA0cslwXQn8GmqFGHRqF37Co29Hn48waBbeVIG8Diu8IkAmz9aliWANeVKpJfvdoPOKatuPoOYQ5cT1Mbt3zfdRe4N+Hp6CVEzLMhOsK+/yWRnjcd0SYcZT1Lu8wFE/l2R3i2eyFCKusK/owJk5//xpI+NLXbnJ/EKNBswvuBuOZE9LjiM0hz2pl1KD684WhIpfSEHM2n46HJH7eVJTG5jxruPrjLsFq4IAYO52L0kihGdNP3SlWEhpfl8gn2D9JHxPPsfXg+ySsHKFQagm5OwW3/pcs7f0uoLenPb1trYKiw5s+WFE/bDhkaqLdcvVkgDhG7gESHndY88qRhQziOie9G/8cYJrO4b8OV9YV+q03goEGTlFxs/ud5Hhj1YyG4FzcUVzihSF4UhHoBctTJFJr5/6RuvydSIoERePOz0Zpfep7KMZGNaAYQWDAHjsCke6N8jRAu2R/K3K+YQO9A4mKfx5GtpUr92GaLgyvkhuYBgIas96EjhpNSK44mQ6RorlhxwBZVCv9fYsg83VHtdgDzQKsKXoUqbqnM3HV3fiJeDbJWc8aUCxibQaHtlF7Pyo0pWlqU2JM8H3x3bOpAd+UiHmxCWt4CzzB4SjwNDS0wq81lv1qrOAkuHg0OzassIaIg5sAyCiljM+Gxjvbxt726cL1y8eFCMIZ0uW4e9QvLp2OqOx89FUM97JdYTDSFf59wcEp/tgyWlBsG8yhuISloKjbWAOXZrTVtSYS57QJLgHX9seRRD9x4P8M68b1MbkENa/0DCHPWyptX0vWRrfYaL7SGDE7LjWCrHr/VLWcNM2Hjjx4z67fNY/HjGmNadRcsXxpgkgIWUlCZj/MiOSmP
 7x54evNO
 vv3ESpk+9SFjhJNeswBlLVv+5mVIPU3wQBv96XN1BkyG9J/leaFN6Jpumo5HWgWHhFasBLK1hpCfOiG5hgVhNf0ZtmAt0vAGT/mxkGkzRnYsJs8/G+DHS2R19KRRSUo+nHo4YmFQAGVELlUUjltPsz7OXUPxsHE4f8GItzuzS5f+/OwDchMytm6f4hsDKsVxPuZCL1yT0h7Wh2Xp5/dHBbQc6juUQ3dzKQOBLsCerGmCh9yG1r2YWjCnMsBX4TUhahUD0Y63M1xU2YRKkZfrcuw5LuA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Tarun,

On Thu, Sep 03, 2026 at 03:59:06PM +0000, Tarun Sahu wrote:
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

We already have memblock_search() ;-)

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

I think we can just kill for_each_memblock_type() and open code all loops
that use it and make memblock_add_range() and memblock_isolate_range() use
binary search.

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
> -- 
> 2.55.0.970.g62bdec98f9-goog
> 

-- 
Sincerely yours,
Mike.

