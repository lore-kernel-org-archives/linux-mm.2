Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1BEA0606A319
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 02:15:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=MtTqySqA
Received: by kanga.kvack.org (Postfix)
	id B6F3C6B0121; Mon, 19 Oct 2026 22:15:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B468B6B0122; Mon, 19 Oct 2026 22:15:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A355F6B0125; Mon, 19 Oct 2026 22:15:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 66E966B0121
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 22:15:02 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 002D8808AD
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 02:15:01 +0000 (UTC)
X-FDA: 85341386844.04.5A6EC90
Received: from mta1.migadu.com (out-14.mta1.migadu.com [95.215.58.14])
	by imf28.hostedemail.com (Postfix) with ESMTP id BC670C0002
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 02:14:59 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MtTqySqA;
	spf=pass (imf28.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.14 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792462500;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H5koWBlEkzUtVRPXaV/v1U0rZzsCMMRJSatrplJvvdI=;
	b=4rajWK8ApJbtOMzQkC3tvRejt2c3E0S/oSV7e/tmkULWlesKu5sy8UTgjbFtZYUuWepkV0
	7SLsD4o+v9jrcqZFCjVnti680wT29SzxImo3aWVaxyeJ7i7D2gOCSHxBaozCkshaYuvE89
	Qun2np4oFD3le37yZfJGqCOSzhirDMA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792462500;
	b=waDtkM4Erq4tPEMY68up/mKsBP/Aq9yFDx1RsSZbkC8R5sxJm8uLREmcEO90m28SdXES9J
	7DZ9u+7DygK+cDTg4CJfa2Ea8i6qxwb2j5meeHUxHiZk/aNU5IeIVw0B48rRtEz36t79Dp
	RteKaDDUz8PKqwucN6fER052olTEFsU=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MtTqySqA;
	spf=pass (imf28.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.14 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=RIrheAYm8hykGe22Eq3j94xLVcRIa2q6YiEDm7rvq1I=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792462498; v=1; x=1793067298;
 b=MtTqySqABRAkFsDiyocbxlm1d9OrkRuNkd5LlWHji6/bhhwnZuwybc6iZbny2iJF29J8rO84
 k45ctSv0WYakcFKuJ6QKpSoB9ZaSCyoQJdjOji+otlausoKPjDUEChFLZRBH6o0srn03qBWoMlR
 d7AfDngwtMkve4uGwALBDn6U=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 1bfec103754fcc10;
	Tue, 20 Oct 2026 02:14:58 +0000
X-Mizu-Trace-ID: 1bfec103754fcc10
X-Migadu-Flow: FLOW_OUT
Message-ID: <f8d85b59-971d-4397-a785-b4ab4d301874@linux.dev>
Date: Tue, 20 Oct 2026 10:14:54 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/shrinker: allocate shrinker_info_unit from a
 dedicated kmem_cache
To: Konstantin Khorenko <khorenko@virtuozzo.com>,
 Andrew Morton <akpm@linux-foundation.org>, Dave Chinner
 <david@fromorbit.com>, Roman Gushchin <roman.gushchin@linux.dev>,
 Muchun Song <muchun.song@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
References: <20261019-vstor-144715-shrinker_info_unit-kmem_cache-v3-1-0fb061e09bf4@virtuozzo.com>
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <20261019-vstor-144715-shrinker_info_unit-kmem_cache-v3-1-0fb061e09bf4@virtuozzo.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: BC670C0002
X-Stat-Signature: ym61eqcb3kyqnkqgyzxc3gz33kcf53d5
X-Rspam-User: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1792462499-563553
X-HE-Meta: U2FsdGVkX19K7ssy3OAOPy6nneOz3hPmxsm0tFajhJ+HTXzo0yvjTDJEsx2agNTY2uwX9VRdaLxMe3RYYRd26TPcBZs0J9lZo0OAjWVQnzytKBAuDX0zKhQefWxHvSZxqSYMDJRP3QoegXXyGEDtL+TvOdhRmRVAmUuHa0R0f+LnoSPw1R7waJqs87nqlCCYptZ7PKcRUTS/ot2wPUipHxufBN4YwmEmPd734pkGQBK/7MZtib5UyXeX7UmNn9QoMvZXKjIAJ6+J/Z2RGjx0OqB7KiDMqCeyqMxq8QwXa6s1JhqaMGiDOx827KnkblbtaS5M4Y9B0nMLVki6SxWSPC47cLdSGPCop9ScUubT0C4udsHdfhNP8eewMqVIQhZ12z6Z8I6ZgeusVcv+3/DJOkluplcgxAdzKBHQtr/irVoPteKGc2K1NyBS+kozc0DbecAAjdUt5FB2KHwiHfLNvPCKJ2d2rS2HVjXUJFec0PRR4WQu50qgTkGSZK4hENXMKXAa9Q0dxNSefHCuaO8bfpeJBV9ElY/+DIU9UlaXJmPyJEq5uDa+iO1DDN+8Adv9dgrh2YmzVNngjwcX+ZpVdEs4orNitQToi8XMth+/Vgoavc23uOUrAn+V9JcwqSfpaIade3ZD+9raJjBotKVNvZRg9jU3bl2PxJ8RQ6o/NwGlpPOYpOvMOMOcusHk4H88Ie93v6q/Z/xPl6wfAjTkGnJE59OVAXbOQ3NKwRUkKZ7/rBAb8w6dMikvCcuVEYVz5O6H9Km1jn+0e39CqI4oNuQi4z0OuTTD32owmn9GN9oANTffFhts1Tv33j09Yq4ePY+R8/Af1Mx9TkTV0h6Dj/1p9MB3HdqS2NSNll+0HfwdzpSqImATC3ihtIwqTlLElM+2wBfhTwLt5tQIcQdb/JtxTcVDNx6zHh44dwhcqufBtLOBbo+CS5s+lkFG5CjEhRidwktWpG8znojF2VM
 k9M5FFh1
 CGTI/XHPX7Z1JahskQur5oSENUi5JY3o1ihpMww3DmvAidDUyzfuNqWRAQj+FUZU6EdowGIE2eJgP7604QFizRwQs5ACG8ndo4XR7E/jBr8X2Jw1t0pfOTI/26PLhwLCAIFNw5nTx3dRNaXu62i14/3OyJy15rG0Sq0Y95sxYqGxuiqHbImGKGjUITw+aNwy7t7+6dEK2SLXwXX5G197g1iRTPp9Da2naIF0wALlOjrBuPPATbnFqolIRNWl9eHTQtsmTMTJ5sfTcMgn/F3p6VgDyLHg7wIL/gySoujx3I3zwlex7NlrbrsgrsT0ZOahQS82cWaG886A1XQelCVw8Y0bjNlfQGr9N1ifsFY+POcxoBZWzZ+oFIOkcVkQTjx2LMK0zriixTzdg2BE3vj+rl81tuXxHR4XTJOAcQoBOVRLWpYhEyssMuHgBduU6yvWf5ampUpP5k7iybVhf38h9Mkhg3/FrLHyP50she6J7P5OtdkwS6XYm8cs2O00AC0XbEfFepV5PzNJYR7ppzNnkfBF7LA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 10/20/26 12:11 AM, Konstantin Khorenko wrote:
> shrinker_info_unit holds BITS_PER_LONG atomic_long_t of deferred work
> plus a one-word bitmap, 520 bytes on 64-bit. kzalloc_node() takes it
> from kmalloc-1k, so almost half of every unit is padding.
> 
> Allocate the units from a cache of their own, sized to the unit. The
> cache is not cache-line aligned: the counters of a unit already share
> cache lines between shrinkers, and aligning the unit would only keep
> neighbouring units off each other's boundary line, at the cost of part
> of the saving.
> 
> Suggested-by: Andrew Morton <akpm@linux-foundation.org>
> Assisted-by: LLM
> Signed-off-by: Konstantin Khorenko <khorenko@virtuozzo.com>
> ---
> This is v3 of patch 1/2 of "mm/shrinker: make per-memcg shrinker units
> cheaper", sent on its own as Andrew asked in the v2 thread.
> 
> Patch 2/2 of v1-v2, "mm/shrinker: allocate the per-memcg shrinker units
> on demand", is not part of this posting. It is the change that makes a
> memcg pay only for the shrinkers it uses, and it is discussed separately
> in the v2 thread.
> 
> Tested on a 4-CPU, single-node VM with the test from the earlier cover
> letters: 8000 tmpfs mounts, then 2000 empty memory cgroups. The units
> move from kmalloc-1k to the new cache, 31 per order-2 slab, and the
> unreclaimable slab per cgroup goes from 144 KB to 87 KB. Removing the
> cgroups and dropping the caches returns the cache to its earlier size.
> 
> memory.reclaim on a cgroup still frees its objects on 140 ext4
> superblocks, and cgroups making their first objects while mounts keep
> raising shrinker_nr_max leave nothing in dmesg, also with
> slub_debug=FZPU on the cache. selftests/cgroup test_memcontrol passes.
> test_kmem_memcg_deletion also fails without the patch, by a similar
> margin.
> 
> Changes in v3:
> - Allocate the unit from a dedicated kmem_cache instead of shrinking it
>    to 63 ids so that it fits kmalloc-512 (Andrew Morton, Muchun Song).
>    New subject, since the unit keeps its size.
> - Link to v2: https://patch.msgid.link/20261014-b4-prep-vstor-144715-size-shrinker_info_unit-to-a-power-of-two-v2-0-51af2aedbe6c@virtuozzo.com
> 
> Changes in v2:
> - Patch 1: check the unit size with BUILD_BUG_ON(!is_power_of_2())
>    in shrinker_unit_alloc() instead of an open-coded static_assert()
>    in the header (Muchun Song).
> - Link to v1: https://patch.msgid.link/20261012-b4-prep-vstor-144715-size-shrinker_info_unit-to-a-power-of-two-v1-0-5a7608393b7a@virtuozzo.com
> ---
>   include/linux/memcontrol.h |  1 +
>   mm/memcontrol.c            |  2 ++
>   mm/shrinker.c              | 11 +++++++++--
>   3 files changed, 12 insertions(+), 2 deletions(-)

Reviewed-by: Qi Zheng <qi.zheng@linux.dev>

Thanks,
Qi

> 
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index 7d1c0ce189a88..b5a89594c263c 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -1675,6 +1675,7 @@ static inline u64 mem_cgroup_get_socket_pressure(struct mem_cgroup *memcg)
>   }
>   #endif
>   
> +void shrinker_unit_cache_init(void);
>   int alloc_shrinker_info(struct mem_cgroup *memcg);
>   void free_shrinker_info(struct mem_cgroup *memcg);
>   void set_shrinker_bit(struct mem_cgroup *memcg, int nid, int shrinker_id);
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 856a7d07586cc..7a817181168ed 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -5717,6 +5717,8 @@ int __init mem_cgroup_init(void)
>   	memcg_pn_cachep = KMEM_CACHE(mem_cgroup_per_node,
>   				     SLAB_PANIC | SLAB_HWCACHE_ALIGN);
>   
> +	shrinker_unit_cache_init();
> +
>   	return 0;
>   }
>   
> diff --git a/mm/shrinker.c b/mm/shrinker.c
> index 7ec2a9704f6f2..4fb424e721bca 100644
> --- a/mm/shrinker.c
> +++ b/mm/shrinker.c
> @@ -12,6 +12,12 @@ DEFINE_MUTEX(shrinker_mutex);
>   
>   #ifdef CONFIG_MEMCG
>   static int shrinker_nr_max;
> +static struct kmem_cache *shrinker_unit_cachep;
> +
> +void __init shrinker_unit_cache_init(void)
> +{
> +	shrinker_unit_cachep = KMEM_CACHE(shrinker_info_unit, SLAB_PANIC);
> +}
>   
>   static inline int shrinker_unit_size(int nr_items)
>   {
> @@ -33,7 +39,7 @@ static inline void shrinker_unit_free(struct shrinker_info *info, int start)
>   		if (!unit[i])
>   			break;
>   
> -		kfree(unit[i]);
> +		kmem_cache_free(shrinker_unit_cachep, unit[i]);
>   		unit[i] = NULL;
>   	}
>   }
> @@ -47,7 +53,8 @@ static inline int shrinker_unit_alloc(struct shrinker_info *new,
>   	int i;
>   
>   	for (i = start; i < nr; i++) {
> -		unit = kzalloc_node(sizeof(*unit), GFP_KERNEL, nid);
> +		unit = kmem_cache_alloc_node(shrinker_unit_cachep,
> +					     GFP_KERNEL | __GFP_ZERO, nid);
>   		if (!unit) {
>   			shrinker_unit_free(new, start);
>   			return -ENOMEM;
> 
> ---
> base-commit: a5ebb76233b79db01e82e061173cb73c6d2b5c6b
> change-id: 20261016-vstor-144715-shrinker_info_unit-kmem_cache-69ea3f78b635
> 
> Best regards,
> --
> Konstantin Khorenko <khorenko@virtuozzo.com>
> 


