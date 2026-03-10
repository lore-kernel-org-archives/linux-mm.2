Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A254EB104C
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 11:05:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B02516B0089; Tue, 10 Mar 2026 07:05:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AAC6B6B008A; Tue, 10 Mar 2026 07:05:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9AF1A6B008C; Tue, 10 Mar 2026 07:05:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8C60B6B0089
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 07:05:47 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4F6EAB9DF7
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 11:05:47 +0000 (UTC)
X-FDA: 84529873134.02.BFE0119
Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	by imf26.hostedemail.com (Postfix) with ESMTP id 53262140007
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 11:05:44 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=N2aZCT3r;
	spf=pass (imf26.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773140745;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4akV6MaGHmSnJk/SzTCTQAyiJw3QkRpB6h4z0N/jqq8=;
	b=fgGvK6HKH4xO2RDravPYA/NvqdQlrK5Uj7DHmoTap+cthP1i62cQAhiDtW4bGx1oMJcIGc
	HodhhWzoJS5uVlcjtTlF9CI7eMuTk5/ZwE1xdRIZpovjR0vLRJbHzksd9PTEzGaSvhPhsV
	Wyb4bidMKvG34FwLzvLf6/TRWC5svoU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773140745; a=rsa-sha256;
	cv=none;
	b=oICcpUjIg4+JnV3ckBLCx18Ymbj0Eb6n9LyCpzIQIcP+RwWEC5eksRrwYKCjeSUBwAjmyN
	yz7LHvOC/d8ikcnvMPFOd+Mksa8eRo7Fraknpvby2Fl8GI/GOnr2QxNCqz3B94CeiqEYwo
	PMNlAh4eLi/t8RkAx4BtWEfOFa3lhOo=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=N2aZCT3r;
	spf=pass (imf26.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773140742;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4akV6MaGHmSnJk/SzTCTQAyiJw3QkRpB6h4z0N/jqq8=;
	b=N2aZCT3rN2A3bOZSlbE7ME1QU04ADUX5sf4VTjCoc9fD9LpEnEWln0NYOQ3yekfQsRaAYm
	ZJtjwe4EN6xrYEh8/Rvej1KTyC4MqGuZ00a6hifeCnDtBYLGJ/RSow0VzgweOWvqn17XDT
	11zMIsUABN8SKCd0hAR4CLeT0cOIR3I=
From: Usama Arif <usama.arif@linux.dev>
To: Haifeng Xu <haifeng.xu@shopee.com>
Cc: Usama Arif <usama.arif@linux.dev>,
	akpm@linux-foundation.org,
	david@fromorbit.com,
	roman.gushchin@linux.dev,
	zhengqi.arch@bytedance.com,
	muchun.song@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 3/4] mm: shrinker: optimize the allocation of shrinker_info when setting cgroup_memory_nokmem
Date: Tue, 10 Mar 2026 04:05:35 -0700
Message-ID: <20260310110536.3474739-1-usama.arif@linux.dev>
In-Reply-To: <20260310031250.289851-4-haifeng.xu@shopee.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 53262140007
X-Stat-Signature: 5t6wfp9915u3xcn1rs5p315my6g68ae6
X-Rspam-User: 
X-HE-Tag: 1773140744-785412
X-HE-Meta: U2FsdGVkX1/XwTuxWNxdF6HM/9INvcH62llU++CC3cvU/BKZUw91h/nnY1N1hPQgy0pBd1lq0RagBiqLlRgjabLjyGZ/hlnQH7noMWcijxPVjlonXZmGJpBgMTnmcEvrw2VLZk+GzKiRkmV8hbyf+fMNu1n2tRP+n0QBxfjC+F78HXiJLju0wPo0IdV2bcSZoLMAzSghjVRerNXrqHretujgdw5DAd4mHvc4xvSuMWhXwnUweZxWbQ3ahFjBbi3PbrNGyQK3ZhP9M7dkXhtI8LrWeEOQ7fslaOrAeZ5YI6tBIYx+Idz7pIyELraPWry/YArE3EVQp8Xm1W7/b3PXLETqXYbcQUtx87nQ7+gTZ687GRi/IIsUp72MR3iEYWBBZzr0F81KQOR/yJ7qeLzBYMBTXV3125U3oOgXQEEe/DBHx347VMV69iLMML7OIKh8N1t1bT3H16zqtEB8lfYCs+gxF8oOSiUgC+KgAmY4NCGhKZCYIC2QH1KouB0wpPDkOuVjSb7ggvxX90fo41zCog6hD7kgBNqsesE4hJneap3m7tTYkbaN02vedGXjvwQe+t8orIWkQiRKyuHODA1nfsXF6Q1kjJuFq/KaAjBZa0X4MwLECYa1yvpb4ysh2gXaD6cWNPd4RsTeTfo5C9KqGe2eeeR60MlH/M65lU+AETfpZJFwDhDHxjDvlbpJmKxd5Mcxathl7YhGY0i16suawihWz7m8xWg5BNgeGFN4emxm1ce1SscYo0HbJ7v1YSzCBPR576Dp8xUD4LDP19MJh0pU7diZJkThZJlBqwviod6y927kXhpj5J9HQpTZEUXD7G3otZ6Cd20AGUl0hYp/wB8o1/ZBADh54mPfeWIck0bY3S1fn+h71YONvgZV0TnftANAn7ueFt4R7Ssxj2GgeeOzGiBpzV1cRwM38fwPDJeVCiUjVsWtoWUPSYq3UfkEHKdu8VAIA3ajJZHpj2k
 vORngs3E
 fvlG19BYXtQ5EuhYq7zNN9FuM8dvZPVonvVDUuzxb2ISr410LDQvVQcbZQ8AFo441NzGbVvt6st22ttiiohI+e/HrNr9haNaZPoAfG2Bs/3fugEGr81t/ewAZB1NUL2SkxyVNpWtxYbeU3u3lJCGNURifG7yQLfLdIa3upI9AHGI+1guXM2MIMx1MDl50geDY5B7LG7q0/wELREKZmiua7tg0/8Fj9Jtm8m8C2og+U2FbIHTSg6+jm455TGT+3MHNjSvh/aEXo7c+UPz+QBUyyY+VjfhlVlgA8SDB3D48NfQIYxuHb8IbL41xI44KXXhG+vqvJE5IqqWXxAqvgXhgE1g9lw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 10 Mar 2026 11:12:49 +0800 Haifeng Xu <haifeng.xu@shopee.com> wrote:

> When kmem is disabled, memcg slab shrink only call non-slab shrinkers,
> so just allocates shrinker info for non-slab shrinkers to non-root memcgs.
> 
> Therefore, if memcg_kmem_online is true, all things keep same as before.
> Otherwise, root memcg allocates id from shrinker_idr to identify each
> shrinker and non-root memcgs use nonslab_id to identify non-slab shrinkers.
> The size of shrinkers_info in non-root memcgs can be very low because the
> number of shrinkers marked as SHRINKER_NONSLAB | SHRINKER_MEMCG_AWARE is
> few. Also, the time spending in expand_shrinker_info() can reduce a lot.
> 
> When setting shrinker bit or updating nr_deferred, use nonslab_id for
> non-root memcgs if the shrinker is marked as SHRINKER_NONSLAB.
> 
> Signed-off-by: Haifeng Xu <haifeng.xu@shopee.com>
> ---
>  include/linux/memcontrol.h |   8 ++-
>  include/linux/shrinker.h   |   3 +
>  mm/shrinker.c              | 116 +++++++++++++++++++++++++++++++++----
>  3 files changed, 114 insertions(+), 13 deletions(-)
> 
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index ce7b5101bc02..3edd6211aed2 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -1804,7 +1804,13 @@ void reparent_shrinker_deferred(struct mem_cgroup *memcg);
>  
>  static inline int shrinker_id(struct mem_cgroup *memcg, struct shrinker *shrinker)
>  {
> -	return shrinker->id;
> +	int id = shrinker->id;
> +
> +	if (!memcg_kmem_online() && (shrinker->flags & SHRINKER_NONSLAB) &&
> +	    memcg != root_mem_cgroup)
> +		id = shrinker->nonslab_id;
> +
> +	return id;
>  }
>  #else
>  #define mem_cgroup_sockets_enabled 0
> diff --git a/include/linux/shrinker.h b/include/linux/shrinker.h
> index 1a00be90d93a..df53008ed8b5 100644
> --- a/include/linux/shrinker.h
> +++ b/include/linux/shrinker.h
> @@ -107,6 +107,9 @@ struct shrinker {
>  #ifdef CONFIG_MEMCG
>  	/* ID in shrinker_idr */
>  	int id;
> +
> +	/* ID in shrinker_nonslab_idr */
> +	int nonslab_id;
>  #endif
>  #ifdef CONFIG_SHRINKER_DEBUG
>  	int debugfs_id;
> diff --git a/mm/shrinker.c b/mm/shrinker.c
> index 61dbb6afae52..68ea2d49495c 100644
> --- a/mm/shrinker.c
> +++ b/mm/shrinker.c
> @@ -12,6 +12,7 @@ DEFINE_MUTEX(shrinker_mutex);
>  
>  #ifdef CONFIG_MEMCG
>  static int shrinker_nr_max;
> +static int shrinker_nonslab_nr_max;
>  
>  static inline int shrinker_unit_size(int nr_items)
>  {
> @@ -78,15 +79,25 @@ int alloc_shrinker_info(struct mem_cgroup *memcg)
>  {
>  	int nid, ret = 0;
>  	int array_size = 0;
> +	int alloc_nr_max;
> +
> +	if (memcg_kmem_online()) {
> +		alloc_nr_max = shrinker_nr_max;
> +	} else {
> +		if (memcg == root_mem_cgroup)
> +			alloc_nr_max = shrinker_nr_max;
> +		else
> +			alloc_nr_max = shrinker_nonslab_nr_max;
> +	}
>  
>  	mutex_lock(&shrinker_mutex);

Hello!

The patch reads shrinker_nonslab_nr_max and shrinker_nr_max before
acquiring shrinker_mutex. The original code read shrinker_nr_max
UNDER the lock. Both variables are modified under shrinker_mutex by
concurrent shrinker registrations. A stale read could cause
alloc_shrinker_info() to allocate an undersized shrinker_info,
leading to out-of-bounds access in set_shrinker_bit() or the
nr_deferred functions.


