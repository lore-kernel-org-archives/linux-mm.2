Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7EC6DFD7065
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 10:10:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC9E46B0088; Tue, 17 Mar 2026 06:09:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B7A746B0089; Tue, 17 Mar 2026 06:09:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A90726B008A; Tue, 17 Mar 2026 06:09:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 982C36B0088
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 06:09:59 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2BF91BA3B4
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 10:09:59 +0000 (UTC)
X-FDA: 84555134118.23.508ABA4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 51BEF80008
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 10:09:57 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BXNcEhrp;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773742197;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0+XbCq0LvEGQVHbIBU6RRND3h2y4j6CzHhf7VutLFxY=;
	b=QcdoW+rNAFhWOD+VDvhYpNDhxcD3U3Y9Gfh/xF+W2MD+Xo7pdSZup4tuA1WpfvziArHQvm
	P8ETXyhfmbhSQHguILUzjWu02h5/CtjreMdZ9ziE/3e52tRtNqlGCQeMioAaiUXlREqzu+
	ojXSmrR4rADHte0/VofwJ7+glpbySuI=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BXNcEhrp;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773742197; a=rsa-sha256;
	cv=none;
	b=LD4yCUgY8MnXPCIRDIVuBH21Ac1xPMcd3cuLcuWQI9R0G9KbkxYymz5OB1NaIgXTlKr0wS
	NOGNNbxx5RwqVpSSCkxDtGniGymUcHprbRD2Y+CvWIlHtm9Yl2qDTj5/ClA0u2gfgzOHZL
	VhgUXt0b+urf7j8fp46QJJyQ+AEtT0c=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5E58942AD7;
	Tue, 17 Mar 2026 10:09:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08E92C4CEF7;
	Tue, 17 Mar 2026 10:09:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773742196;
	bh=QQlenSLdnpmr2kj2nKKcyLITns2TcK1wgsb6jYePg08=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=BXNcEhrphAFIjFkkidWl+xycRjMqjZATxemeThUCTqHMYJFaC+EqDxhOXQGds5ATZ
	 h/iCh3rWcSTRxarrO11MiW24yhkpMMRco3TqOaJe+y1eDwmFPuAt2L6NtlojqSrKTa
	 AsJ+025bq9vmqg0yBYsG3bHP3mpNUeiHr2m0u3l4BRjY5jbOZ569DgsnMiKAkpJpe8
	 nRYy19NTxsksDdys56uHVEGSF3UNnruzKKMEg8vIab1w1HXg0ZhGpji8F23mGsOA8c
	 pHy2Ipa+qF3KIJ8m5COnOyJ99/hP7Emy17STNrtM49TmpGgM0jxoi8iMFnxpjHN4Qj
	 WdBzs2yX6at+g==
Message-ID: <b0aafab0-bd8c-4b86-85a8-eb0add363cbe@kernel.org>
Date: Tue, 17 Mar 2026 11:09:51 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 6/7] mm: list_lru: introduce
 memcg_list_lru_alloc_folio()
To: Johannes Weiner <hannes@cmpxchg.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>, Yosry Ahmed
 <yosry.ahmed@linux.dev>, Zi Yan <ziy@nvidia.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Dave Chinner <david@fromorbit.com>, Roman Gushchin
 <roman.gushchin@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260312205321.638053-1-hannes@cmpxchg.org>
 <20260312205321.638053-7-hannes@cmpxchg.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260312205321.638053-7-hannes@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 51BEF80008
X-Stat-Signature: uws7anjhkpfcabrgroj44f9mz3gtw1mo
X-Rspam-User: 
X-HE-Tag: 1773742197-626543
X-HE-Meta: U2FsdGVkX1/y8xKE+RHQ/nw2GXnfevCHjm0MJwWrP9h0sa+oC3W0pKXzHFvpmDDYL6PgBGO7WarJR1FUdyKQMR2RLQxnZ2/olHaBzfuyaZ2ciDfUMhVryVK1uFAUYBjz6dzVac5BXW4UV/3RCkqzCSI4uOVgzlVLzkTkzUyNyMRGmi+IxFHlnNomL+MlI6LIohgvWZ7qb1NmgEWaBJrFitzkvr3stK1k08FD0byWIF0gBQ4Qb4ZmQV1Kee0QSYVJCITwS0NeFFPVR1tmXTQhDNueb9mDqCH3g8WeufpKQSsoql76Ig549e82adABuegCGGfVa7dyhS1KsU31Zdmqa5Km+da1XlvV094bJ8Ha6OS5bqSy6Ly0KUVvNNdqMN1UJFZzPUjhDrgIaj7makxTFlqc5nirCWEAuHlx3uWzy/Di5GOp6acy+XH3fnY9uxxPt9NkGy968uY+l6zXimIxKkmHicx4cF7snV8TlLV4Rg7rDOJ2uzsS1PtnVigxB/NSEWpQLm4h5MZYlQtLt8poDckTMXv8baUVS04TanbXEF8qbFnZ3GTIyFIch8pSwdUK4z5FMI+W/Qv3GlzV4BvqPsamRbSF4uLvkOos4p6zyHTNBwOQQvqvI+exAJwOW2Wj6i+a4Iv6xyM0R5HTcL27kTWrxsRFRurewv4WAuNmC1IX3q/iMribLLuDawQgIQkq4Ly9Y7ynyPCx33fsgaPPYaRlCHtjalYsV9q1qCK0ok3NyCNx9JGyg1hKApS1ugO2FpSpHdA5V+yHix31eGroFuNe9mhO645Lj/lYgM7pvUN18TjjfS7LTn9sR3vsbIV6IF0vY8UxV9ekK0BdeVq2KMHyRMRv5rfu/9bLGnLw68rkZlBLgF9RuAzG0bROT9KxkaQmrCnpYSMjupRau1/Q+urXzOGhnDi1kk84/rTi7XCJnczm8JedT96WUY3zK/ENFXKYT13UKlT04pz/NHQ
 kLiUWeBx
 SrUO6uoM3UMzmaZsrLV+v19rZRNKBZCuqef3fdWyGIdqy57faUjhDfoL+YxiuWzLWYSO52FJUdYySsrq1R4VYOGcmOkPUMWNuW9oWJszezdnoAkA2YpX8vso/th1QKsA3uD6AasP3xqtdGXUMv8wgCZL2/OzmMMi9xMUelaKvu4y3vnWGbplxNsHvzy1btb9fsXXuHoXLhdQNhS+vQYgmwpsEt+tg9FH1CVscBKxNlFGEGrV90RE5DubWvb9C8aoP6qDuJGwgi18l6mt2MV8FoiUUqe619j6NoUaGnkCl3LhDbOaxwLOQAyb6e0V4SnFKi7PNq2oxOTMKWhF2Xz+eZNW7i63zKFLlkdM3/2I5V/ZxhJ4mAo5HjYtPdX9E7bm22FfEy2r9Zx7DmwN7EEPz7PCtvAGIBQa9pE4F/3YZjVN+yjw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/12/26 21:51, Johannes Weiner wrote:
> memcg_list_lru_alloc() is called every time an object that may end up
> on the list_lru is created. It needs to quickly check if the list_lru
> heads for the memcg already exist, and allocate them when they don't.
> 
> Doing this with folio objects is tricky: folio_memcg() is not stable
> and requires either RCU protection or pinning the cgroup. But it's
> desirable to make the existence check lightweight under RCU, and only
> pin the memcg when we need to allocate list_lru heads and may block.
> 
> In preparation for switching the THP shrinker to list_lru, add a
> helper function for allocating list_lru heads coming from a folio.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> ---
>  include/linux/list_lru.h | 12 ++++++++++++
>  mm/list_lru.c            | 39 ++++++++++++++++++++++++++++++++++-----
>  2 files changed, 46 insertions(+), 5 deletions(-)
> 
> diff --git a/include/linux/list_lru.h b/include/linux/list_lru.h
> index 4afc02deb44d..df6bd3c64b06 100644
> --- a/include/linux/list_lru.h
> +++ b/include/linux/list_lru.h
> @@ -81,6 +81,18 @@ static inline int list_lru_init_memcg_key(struct list_lru *lru, struct shrinker
>  
>  int memcg_list_lru_alloc(struct mem_cgroup *memcg, struct list_lru *lru,
>  			 gfp_t gfp);
> +
> +#ifdef CONFIG_MEMCG
> +int memcg_list_lru_alloc_folio(struct folio *folio, struct list_lru *lru,
> +			       gfp_t gfp);
> +#else
> +static inline int memcg_list_lru_alloc_folio(struct folio *folio,
> +					     struct list_lru *lru, gfp_t gfp)
> +{
> +	return 0;
> +}
> +#endif
> +
>  void memcg_reparent_list_lrus(struct mem_cgroup *memcg, struct mem_cgroup *parent);
>  
>  /**
> diff --git a/mm/list_lru.c b/mm/list_lru.c
> index 779cb26cec84..562b2b1f8c41 100644
> --- a/mm/list_lru.c
> +++ b/mm/list_lru.c
> @@ -534,17 +534,14 @@ static inline bool memcg_list_lru_allocated(struct mem_cgroup *memcg,
>  	return idx < 0 || xa_load(&lru->xa, idx);
>  }
>  
> -int memcg_list_lru_alloc(struct mem_cgroup *memcg, struct list_lru *lru,
> -			 gfp_t gfp)
> +static int __memcg_list_lru_alloc(struct mem_cgroup *memcg,
> +				  struct list_lru *lru, gfp_t gfp)
>  {
>  	unsigned long flags;
>  	struct list_lru_memcg *mlru = NULL;
>  	struct mem_cgroup *pos, *parent;
>  	XA_STATE(xas, &lru->xa, 0);
>  
> -	if (!list_lru_memcg_aware(lru) || memcg_list_lru_allocated(memcg, lru))
> -		return 0;
> -
>  	gfp &= GFP_RECLAIM_MASK;
>  	/*
>  	 * Because the list_lru can be reparented to the parent cgroup's
> @@ -585,6 +582,38 @@ int memcg_list_lru_alloc(struct mem_cgroup *memcg, struct list_lru *lru,
>  
>  	return xas_error(&xas);
>  }
> +
> +int memcg_list_lru_alloc(struct mem_cgroup *memcg, struct list_lru *lru,
> +			 gfp_t gfp)
> +{
> +	if (!list_lru_memcg_aware(lru) || memcg_list_lru_allocated(memcg, lru))
> +		return 0;
> +	return __memcg_list_lru_alloc(memcg, lru, gfp);
> +}
> +
> +int memcg_list_lru_alloc_folio(struct folio *folio, struct list_lru *lru,
> +			       gfp_t gfp)

The function reads as if we would be allocating a folio ...

folio_memcg_list_lru_alloc() ?

Or memcg_list_lru_alloc_for_folio() ?


LGTM, with my limited understanding of memcg lifetimes :)

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

