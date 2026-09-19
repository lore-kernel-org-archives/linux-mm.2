Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44540C982CC
	for <linux-mm@archiver.kernel.org>; Sat, 19 Sep 2026 03:33:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 24EC96B0088; Fri, 18 Sep 2026 23:32:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 226D76B008A; Fri, 18 Sep 2026 23:32:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 164016B0092; Fri, 18 Sep 2026 23:32:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DF90D6B0088
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 23:32:58 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 644274018C
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 03:32:58 +0000 (UTC)
X-FDA: 85229090436.11.158DB23
Received: from mta0.migadu.com (out-144.mta0.migadu.com [91.218.175.144])
	by imf06.hostedemail.com (Postfix) with ESMTP id 2B35F180002
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 03:32:55 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kzM05ZNG;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf06.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.144 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kzM05ZNG;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf06.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.144 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789788776;
	b=jk94/2qDy5OtA/6NAXH7NHthKK+OXHZ54z9cUtHt8/3fVhC62nGw96q/LM8tVAXXFSkWdk
	tRq1XGApgZN56vMoKZj1C2TT7upMOjzCBZH+mlzG43IEjsYCWrU7gbS/89gharua55PfHM
	Hja6NPYvOMoQxdMN71xyFaCp9qJCQJM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789788776;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1FQlH0ywUvJiGpVaUc78KKCKl9KWd80NMf2V0umCvvA=;
	b=M1qJcP0ZOw8jB9YDyf9OG/GFJun01ihYZ89xPYwCktEp0Gb617DDe89WbqvPRJCwsEkXNn
	HJb3kVYmU2504OjAWwd20D12WgL4OnFpR0wNx+YAu2R/lIMJDRwjcTtAdTIbHLzFu0BgUn
	+6xOJk+oTQNT+RCNZcPIpembDQ6I5hk=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=9nH26dxX2irZCfJK0QDvDQYUuTFsWVgnR12/E88VIOo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789788774; v=1; x=1790393574;
 b=kzM05ZNGnotuUIjhWIF7G7JdI2YZfhkHDkDRcsJu+vRmX+KK7/l30oUdPBHOxup9F81gor+z
 BIHpYJqndsnWHUdxtxrBY6SzBVDPNUFCwrNQBX6m/wNSHUiTdz/GB+S6UKVjRocO2vrMnGerZlr
 iiIG4MdMApQX9ZMgypQqmR/0=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id e00fecd0390ef642;
	Sat, 19 Sep 2026 03:32:54 +0000
X-Mizu-Trace-ID: e00fecd0390ef642
X-Migadu-Flow: FLOW_OUT
Message-ID: <e4ec1370-27cf-40db-ba4e-b46fe54fa882@linux.dev>
Date: Sat, 19 Sep 2026 11:32:46 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/4] memcg: move memcg private ID refcount to objcg
To: bingfangguo@tencent.com
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, Dave Chinner
 <david@fromorbit.com>, Qi Zheng <qi.zheng@linux.dev>,
 Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Bingfang Guo <bfguo@icloud.com>
References: <20260918-bingfangguo-memcgid-rework-v1-0-5bbf3220d88f@tencent.com>
 <20260918-bingfangguo-memcgid-rework-v1-4-5bbf3220d88f@tencent.com>
Content-Language: en-US
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260918-bingfangguo-memcgid-rework-v1-4-5bbf3220d88f@tencent.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 2B35F180002
X-Stat-Signature: memkyxktgkyj518kwgu3jdx4xpenqscd
X-Rspamd-Server: rspam01
X-HE-Tag: 1789788775-767384
X-HE-Meta: U2FsdGVkX18jppzCJZPApINUcTc2xz+FWezJuaoy8oiNxcSvBdFjmhUz37gmP4HbknXoXniVfYJDI6nikGqne8gFIMkRBajbsItM8If1R928qVnM9B9ZfseKnsrTT/5E0m/R/CNnFhP+U7mOWSRadzwoRG2TXh13n+CfKTvmlWUyS/OAmQtl9VxY31+01bYgeu2TSb8D2a8Xen2PRFtG+LDB/gr20eQBGay9+bBuW1kzYw6bi98q+Pm8KMXEUHbzn7YHrQTz3pJxfgQh4BKfTmvhTpN1VBWGThZHf18GIk25lZzilopnwkrO49FYJif0GAGEWGtzU2wxOGTa9Yi9eiiPsux3v9tH5kqCP/igAn0U0b9NvXArNCgikHTHFH8bvXMEO2XlsYIxVHiQ3MdLlCzZT6Eym1PyB0I0IvGCWsyD/UrFTdEQ+ea6CGArOeKjHuqRS+xX3swiDZ2P7VfILHHqRHJJX/TBMuDmMXSv9vp1AOB6aVj51qAycRsVYPNS2p1KKdUd6SjF9lPFqp4tBaaohZbTDPOa7IpbWHu+Ju3vH1XBj8R1cCIItDeNrBeVfzYiMEaa2RjkZZMRuX7oE/5ynDgDmYkv16LeymA4X+WzpU1NusphFcd58Cc0SPlEnQtWTuZlaxyxgFZbRlAPrJ8xcqnHELp24FyRvL0Xo/XCWr6OCfBn0RrO8klx+zczfvOp5orZnByix6/T4xTGGXjPYnYi7PJ0ux//3mJk/+uJw2NZsUqtOygRimD6B5a4vWrQDrGKVHfgIykenbGT70in8ZyV3X+v6KBSGIVc4XHvXoL/hP12PdfGgqO6ho4osFIqtVITMsPiTUTLdaZFD9rRGuJd/8qrb7QFkEx7wLUBw68cyyjCqAyARFtfEUHYc61h4/3Z3+uzMUBhZI816ZRBoPOHbiL4OxOr0qz3Bq7+7A+XQBJI/wCBDX1Qbsu5ysMEYWhd2bSS35cHJ1/
 5WoHEPl6
 ulCbiRYgUKUDTmdZ1Lddf22sx8amtqQh7MOqhsTxdUAEdkmsKniGeOQZWvJtd0PTDZKVJelelSMuhbWEyccs0UdCiktNvc6tap51bSd0757Led146i2WkfhPIlbpJC68Z9ghjvHDYxwYNIDdbuXPayxZ0B8Ff2i+4+mELu/G0Z42F0meuhVIKi26sctROjm0PmukZZK7bryi1mlDqf+27MxZhR52+RD/8udSfgHCQ6+HlFx1DNTplGIf+bxFHjXvbjpZTK2KsZTYyI8puCkg9ai17yN4o59zwvc/DQL4B77HgTUQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/9/18 17:18, Bingfang Guo via B4 Relay wrote:
> From: Bingfang Guo <bingfangguo@tencent.com>
>
> The memcg private ID is used by objects that can't afford storing a
> whole pointer and can outlive memcgs to track the memcg (notably swap
> entries). The current design holds a refcount to the css, preventing the
> memcg from being freed.
>
> This patch unbinds the lifetime of memcgid from the memcg so it can be
> freed.  The idea is to move the refcount of memcgid to one of the
> memcg's objcg. The objcg is stored in the global memcgid xarray instead
> and used for retrieving the online memcg from it.  So swapped out pages
> no longer pin the dying memcg.
>
> After the change, a memcgid can refer to a non present memcg. To handle
> this situation, when trying to get the original memcg from the id,
> compare the memcgid passed in with that of the memcg, and return NULL to
> indicate its death if they differ. NULL checks are added for
> list_lru_walk_node(), workingset_test_recent() and lru_gen_test_recent()
> to skip dead memcgs.
>
> In the earlier patch, an extra xarray lookup was introduced in swap
> uncharging path.  Now that we have the objcg pointer in the function,
> the extra overhead can be removed by using it for putting directly.
>
> Signed-off-by: Bingfang Guo <bingfangguo@tencent.com>
> ---
>   include/linux/memcontrol.h |  9 +++---
>   mm/list_lru.c              |  2 +-
>   mm/memcontrol.c            | 81 ++++++++++++++++++++++++++++++++++------------
>   mm/workingset.c            |  5 ++-
>   4 files changed, 71 insertions(+), 26 deletions(-)
>
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index 46bf724cae7af..3fb18191cfbd1 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -180,6 +180,7 @@ struct obj_cgroup {
>   	struct percpu_ref refcnt;
>   	struct mem_cgroup *memcg;
>   	atomic_t nr_charged_bytes;
> +	refcount_t private_id_ref;
>   	union {
>   		struct list_head list; /* protected by objcg_lock */
>   		struct rcu_head rcu;
> @@ -225,9 +226,6 @@ struct mem_cgroup {
>   	/* vmpressure notifications. Written on every reclaim iteration. */
>   	struct vmpressure vmpressure;
>   
> -	/* Written on every swap charge and uncharge. */
> -	refcount_t private_id_ref;
> -
>   #ifdef CONFIG_MEMCG_NMI_SAFETY_REQUIRES_ATOMIC
>   	/* MEMCG_KMEM for nmi context */
>   	atomic_t		kmem_stat;
> @@ -324,8 +322,11 @@ struct mem_cgroup {
>   	unsigned long zswap_max;
>   #endif
>   
> +	/* The objcg holding private memcg ID. */
> +	struct obj_cgroup *private_id_objcg;
> +
>   	/* Private memcg ID. Used to ID objects that outlive the cgroup */
> -	int private_id;
> +	unsigned short private_id;
>   
>   	int kmemcg_id;
>   
> diff --git a/mm/list_lru.c b/mm/list_lru.c
> index 8a6dd0a489e12..7edd79113cc56 100644
> --- a/mm/list_lru.c
> +++ b/mm/list_lru.c
> @@ -428,7 +428,7 @@ unsigned long list_lru_walk_node(struct list_lru *lru, int nid,
>   		xa_for_each(&lru->xa, index, mlru) {
>   			rcu_read_lock();
>   			memcg = mem_cgroup_from_private_id(index);
> -			if (!mem_cgroup_tryget(memcg)) {
> +			if (!memcg || !mem_cgroup_tryget(memcg)) {
>   				rcu_read_unlock();
>   				continue;
>   			}
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index ed44b3e7ac938..22deee8312856 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -4074,6 +4074,18 @@ static void memcg_wb_domain_size_changed(struct mem_cgroup *memcg)
>   #define MEM_CGROUP_ID_MAX	((1UL << MEM_CGROUP_ID_SHIFT) - 1)
>   static DEFINE_XARRAY_ALLOC1(mem_cgroup_private_ids);
>   
> +/**
> + * obj_cgroup_from_private_id - look up the objcg holding the memcg id.
> + * @id: the memcg id to look up
> + *
> + * Caller must hold rcu_read_lock().

This comment is really redundant since you already include a lockdep
assertion. My advice for writing good comments: when the code is
self-explanatory, explain why rather than what.

> + */
> +static inline struct obj_cgroup *obj_cgroup_from_private_id(unsigned short id)
> +{
> +	lockdep_assert_once(rcu_read_lock_held());
> +	return xa_load(&mem_cgroup_private_ids, id);
> +}
> +
>   static void mem_cgroup_private_id_remove(struct mem_cgroup *memcg)
>   {
>   	if (memcg->private_id > 0) {
> @@ -4082,34 +4094,43 @@ static void mem_cgroup_private_id_remove(struct mem_cgroup *memcg)
>   	}
>   }
>   
> -static void __mem_cgroup_private_id_put(struct mem_cgroup *memcg, unsigned int n)
> +static void __mem_cgroup_private_id_put(struct obj_cgroup *objcg,
> +		unsigned short id, unsigned int n)
>   {
> -	if (refcount_sub_and_test(n, &memcg->private_id_ref)) {
> -		mem_cgroup_private_id_remove(memcg);
> +	struct obj_cgroup *objcg_free;
>   
> -		/* Memcg ID pins CSS */
> -		css_put(&memcg->css);
> +	if (refcount_sub_and_test(n, &objcg->private_id_ref)) {
> +		objcg_free = xa_erase(&mem_cgroup_private_ids, id);
> +		VM_WARN_ON(objcg_free != objcg);
> +
> +		/* Memcg ID pins the objcg */
> +		obj_cgroup_put(objcg);
>   	}
>   }
>   
>   static inline void mem_cgroup_private_id_put(unsigned short id, unsigned int n)
>   {
> -	struct mem_cgroup *memcg;
> +	struct obj_cgroup *objcg;
>   
>   	rcu_read_lock();
> -	memcg = mem_cgroup_from_private_id(id);
> -	__mem_cgroup_private_id_put(memcg, n);
> +	objcg = obj_cgroup_from_private_id(id);
> +	__mem_cgroup_private_id_put(objcg, id, n);
>   	rcu_read_unlock();
>   }
>   
>   static void mem_cgroup_private_id_kill(struct mem_cgroup *memcg)
>   {
> -	__mem_cgroup_private_id_put(memcg, 1);
> +	__mem_cgroup_private_id_put(memcg->private_id_objcg, memcg->private_id, 1);
>   }
>   
>   unsigned short mem_cgroup_private_id_get(struct mem_cgroup *memcg, unsigned int n)
>   {
> -	while (!refcount_add_not_zero(n, &memcg->private_id_ref)) {
> +	struct obj_cgroup *objcg;

Please add a blank line between the variable definition and the assertion.

> +	lockdep_assert_once(rcu_read_lock_held());
> +
> +	objcg = memcg->private_id_objcg;
> +
> +	while (!refcount_add_not_zero(n, &objcg->private_id_ref)) {
>   		/*
>   		 * The root cgroup cannot be destroyed, so it's refcount must
>   		 * always be >= 1.
> @@ -4119,6 +4140,7 @@ unsigned short mem_cgroup_private_id_get(struct mem_cgroup *memcg, unsigned int
>   			break;
>   		}
>   		memcg = parent_mem_cgroup(memcg);
> +		objcg = memcg->private_id_objcg;
>   	}
>   
>   	return mem_cgroup_private_id(memcg);
> @@ -4129,11 +4151,24 @@ unsigned short mem_cgroup_private_id_get(struct mem_cgroup *memcg, unsigned int
>    * @id: the memcg id to look up
>    *
>    * Caller must hold rcu_read_lock().
> + *
> + * @return: the memcg, or NULL if the memcg referred to is already dead.
>    */
>   struct mem_cgroup *mem_cgroup_from_private_id(unsigned short id)
>   {
> +	struct obj_cgroup *objcg;
> +	struct mem_cgroup *memcg;

It would be better to add a blank line here as well.

>   	WARN_ON_ONCE(!rcu_read_lock_held());
> -	return xa_load(&mem_cgroup_private_ids, id);
> +
> +	objcg = obj_cgroup_from_private_id(id);
> +	if (!objcg)
> +		return NULL;
> +
> +	memcg = obj_cgroup_memcg(objcg);
> +	if (mem_cgroup_private_id(memcg) != id)
> +		return NULL;
> +
> +	return memcg;
>   }
>   
>   struct mem_cgroup *mem_cgroup_get_from_id(u64 id)
> @@ -4228,18 +4263,21 @@ static struct mem_cgroup *mem_cgroup_alloc(struct mem_cgroup *parent)
>   	struct mem_cgroup *memcg;
>   	int node, cpu;
>   	int __maybe_unused i;
> +	unsigned int private_id;

This could be a separate cleanup patch.

>   	long error;
>   
>   	memcg = kmem_cache_zalloc(memcg_cachep, GFP_KERNEL);
>   	if (!memcg)
>   		return ERR_PTR(-ENOMEM);
>   
> -	error = xa_alloc(&mem_cgroup_private_ids, &memcg->private_id, NULL,
> +	error = xa_alloc(&mem_cgroup_private_ids, &private_id, NULL,
>   			 XA_LIMIT(1, MEM_CGROUP_ID_MAX), GFP_KERNEL);
>   	if (error)
>   		goto fail;
>   	error = -ENOMEM;
>   
> +	memcg->private_id = private_id;
> +
>   	memcg->vmstats = kzalloc_obj(struct memcg_vmstats, GFP_KERNEL_ACCOUNT);
>   	if (!memcg->vmstats)
>   		goto fail;
> @@ -4380,9 +4418,10 @@ static int mem_cgroup_css_online(struct cgroup_subsys_state *css)
>   				   FLUSH_TIME);
>   	lru_gen_online_memcg(memcg);
>   
> -	/* Online state pins memcg ID, memcg ID pins CSS */
> -	refcount_set(&memcg->private_id_ref, 1);
> -	css_get(css);
> +	/* CSS pins memcg ID, memcg ID pins obj cgroup */
> +	memcg->private_id_objcg = objcg;
> +	refcount_set(&memcg->private_id_objcg->private_id_ref, 1);
> +	obj_cgroup_get(memcg->private_id_objcg);
>   
>   	/*
>   	 * Ensure mem_cgroup_from_private_id() works once we're fully online.
> @@ -4394,7 +4433,7 @@ static int mem_cgroup_css_online(struct cgroup_subsys_state *css)
>   	 * publish it here at the end of onlining. This matches the
>   	 * regular ID destruction during offlining.
>   	 */
> -	xa_store(&mem_cgroup_private_ids, memcg->private_id, memcg, GFP_KERNEL);
> +	xa_store(&mem_cgroup_private_ids, memcg->private_id, memcg->private_id_objcg, GFP_KERNEL);
>   
>   	return 0;
>   free_objcg:
> @@ -5832,8 +5871,6 @@ static void __init memcg_struct_check(void)
>   				      memory_events_local);
>   	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup, memcg_write_hot,
>   				      vmpressure);
> -	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup, memcg_write_hot,
> -				      private_id_ref);
>   #ifdef CONFIG_MEMCG_NMI_SAFETY_REQUIRES_ATOMIC
>   	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup, memcg_write_hot,
>   				      kmem_stat);
> @@ -5878,6 +5915,8 @@ static void __init memcg_struct_check(void)
>   	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup, memcg_read_mostly,
>   				      zswap_writeback);
>   #endif
> +	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup, memcg_read_mostly,
> +				      private_id_objcg);
>   	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup, memcg_read_mostly,
>   				      private_id);
>   	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup, memcg_read_mostly,
> @@ -6015,10 +6054,12 @@ int __mem_cgroup_try_charge_swap(struct folio *folio)
>    */
>   void __mem_cgroup_uncharge_swap(unsigned short id, unsigned int nr_pages)
>   {
> +	struct obj_cgroup *objcg;
>   	struct mem_cgroup *memcg;
>   
>   	rcu_read_lock();
> -	memcg = mem_cgroup_from_private_id(id);
> +	objcg = obj_cgroup_from_private_id(id);
> +	memcg = obj_cgroup_memcg(objcg);
>   	if (memcg) {
>   		if (!mem_cgroup_private_id_is_root(id)) {
>   			if (do_memsw_account())
> @@ -6027,7 +6068,7 @@ void __mem_cgroup_uncharge_swap(unsigned short id, unsigned int nr_pages)
>   				page_counter_uncharge(&memcg->swap, nr_pages);
>   		}
>   		mod_memcg_state(memcg, MEMCG_SWAP, -nr_pages);
> -		mem_cgroup_private_id_put(id, nr_pages);
> +		__mem_cgroup_private_id_put(objcg, id, nr_pages);
>   	}
>   	rcu_read_unlock();
>   }
> diff --git a/mm/workingset.c b/mm/workingset.c
> index 8412f4840ae35..7e4fbc5a786d6 100644
> --- a/mm/workingset.c
> +++ b/mm/workingset.c
> @@ -281,6 +281,9 @@ static bool lru_gen_test_recent(void *shadow, struct lruvec **lruvec,
>   	unpack_shadow(shadow, &memcg_id, &pgdat, token, workingset);
>   
>   	memcg = mem_cgroup_from_private_id(memcg_id);
> +	if (!memcg)
> +		return false;
> +
>   	*lruvec = mem_cgroup_lruvec(memcg, pgdat);
>   
>   	max_seq = READ_ONCE((*lruvec)->lrugen.max_seq);
> @@ -470,7 +473,7 @@ bool workingset_test_recent(void *shadow, bool file, bool *workingset,
>   	 * configurations instead.
>   	 */
>   	eviction_memcg = mem_cgroup_from_private_id(memcgid);
> -	if (!mem_cgroup_tryget(eviction_memcg))
> +	if (eviction_memcg && !mem_cgroup_tryget(eviction_memcg))
>   		eviction_memcg = NULL;
>   	rcu_read_unlock();
>   
>


