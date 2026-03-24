Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BDC77E9A776
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 11:55:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 346CF6B008C; Tue, 24 Mar 2026 07:55:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F7BC6B0098; Tue, 24 Mar 2026 07:55:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 234566B009B; Tue, 24 Mar 2026 07:55:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0E7366B008C
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 07:55:29 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 92ADD5FC20
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 11:55:28 +0000 (UTC)
X-FDA: 84580801536.30.1A8D2FC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 62665180005
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 11:55:25 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MM73kTrw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774353325; a=rsa-sha256;
	cv=none;
	b=zkBy3NPYyvAeBHW3M74S95+DyU4HhrYnjtlnyHBxtRgIuSZ2cXv9meXyvDKOOg6jcDh7B+
	DjIh1eBX5ZYepA6cQUPRMDLGq0XaZT9WrN84hvEZ6YncIKzrHdvuOMR4kJwUbyAUwtVdPW
	Lp/FXZBEmZImMiw9DaIIAUr/UG0/8aM=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MM73kTrw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774353325;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4aoswuigb9pptB4b99OxbYqWTJMODvGvLNCo01k9wt8=;
	b=e/nABl80yvPltY7Ei1BESceMEZRbgc154kZAJ+6GAOodEoV/VCfJCGKPjgMp20hdVy+6/a
	empEoQna+fxrr/wmSVKytNJLlJrkPoiRVeb766gaArJYK4B7ja+k/wLxDbJDyoJGfAh7kd
	Xu4jDtki0ZXYJuiVIapPAPyhJWFmXyo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6D44C43AA5;
	Tue, 24 Mar 2026 11:55:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A89ACC19424;
	Tue, 24 Mar 2026 11:55:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774353324;
	bh=Jkt1tnUrlRTR5DlZDf8v4+vX2SPpsQcdw82i0A0s22I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MM73kTrwGx81AqIJ6Jzd+dVNWpWk41YgLXuOHkRwnP9FBdt8CMTO+V04nfIiN7KXT
	 g1L0YCNezDV11kcbYhPXH7iVR9mkc4gE/sYJvUxrbGYUaySzbpPCiWgdgwZzXQ1rth
	 4icSmE6RECSbYN4mLm14O65IS09CRn+Ie9dEGMEhcZa/3QEhsFPd5Mf0e7y9nqL9Yy
	 rve5kc6cvndS/MZIgy+VEhu8/HJ9VsXl7Vx/ff6DWeWkW5zdImQC8FNxXOMDmKBIjC
	 rtOnacLtHUF1jRF1zeQcgCBEqwM5ap5R8F27Rmm1k+DsoGkx0TbOya1R/UjBcfAoGO
	 F62WDW/NcENLw==
Date: Tue, 24 Mar 2026 11:55:21 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, Zi Yan <ziy@nvidia.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Usama Arif <usama.arif@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Dave Chinner <david@fromorbit.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 5/7] mm: list_lru: introduce caller locking for
 additions and deletions
Message-ID: <a7cbe907-b8dc-4181-8dcb-a0986a09f1a6@lucifer.local>
References: <20260318200352.1039011-1-hannes@cmpxchg.org>
 <20260318200352.1039011-6-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260318200352.1039011-6-hannes@cmpxchg.org>
X-Stat-Signature: mnzwm5ek71tf8syof6axbyiohztuee4s
X-Rspamd-Queue-Id: 62665180005
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774353325-957731
X-HE-Meta: U2FsdGVkX19ACwIpkNb3dRnru1ecfsMQuo8WhbqxTk62plH1jDEQ2ZYlI47qruLEtENh9FC3BoQT328jl2KE15TtdrlE2zJJS/JF+3oLfrkDk2VRb/wrxjwUhMDn5kw1oR2Q6hbxbNOkNz0y6SQZSzF4LWkWBxhYcsczTMHDHY3uvefn1GUv/I7pHt9jC6sTaR7w+pfJFuxViveZpJ2eoKqb8NOUIU/hQ5RGH354hTnwbJbFWc0fpTQfVBQ4dYzSaNbdrHM76dGnFgiNvruz/37c6chGVVmqy39VwWjCt/2iG1B3RNW3GVUA65OoG1PyPaclfJWtr58zRyRF2tXtWUyt+d3tO1bYo1ayOiJLj1IX4c80LGrr8/lrt922RldYomaRYcyhLVO01RTA/TEnawHYlbI6kisHFzLq+vYcd2TU0ZaGUGFlyQv8VIYfibO00l8o+2qypH2ifXQtxhbZM+laoyM/H/onNyKEEAgxlFCKNcz7U/KeBu1hBbuIJEqfs3bTMjIfFR5J6sBbbQeew3gMMDRd5yxqx98OtBSHeTPIwW5q0PY1psjO2Vw9SX4SztaoiHLoIJ9FK2ALdyoaX/snXkBQcCbhZlvJpXuHsj8317jr94aDCZ5EZMH4tlDPaqmVz9L6MzfLP5w/9LMGxoNnfqOiZzHnikOzWZMMOvX7pbYMOICqnhqnL5v4XCYhM0jxx11vGC0fd0H0seIpKP5Qzp3lh0opplWQez2A9u+mPN9Gpek4+XG+AizW+9FyOTQRzNycPC0GH6Lc1OjGeGotwtOF4HFXLCYHUbIyQVxZDxXzXQMeiDp3CswAWhFr8giQIqqgHj5lqpJALoqGvZ7ZtgrHdktDa8wAa4vqN6Nv3+NYGBo0pakbOT2C3C8dmYFprltnnhzlbgg7cR76ObkW9ycnxw1mxmjciM0+43TTCMSqTckO1l0d2MidVuqmbIO5xXaSx9kGDGDkDvw
 qx7qYhkB
 OOpmFgcD0L+oW369df8ViYDKx4FP0+dI+42TKJDBWK7Frft1r0Yw0zbiD3r7R/V2uDpY8UxbqyOVrH/GjFi4t6MCPqTcGIEn649esUjNDzYMQ59oyI+0BY1nFp4wZIX8+9K4/Mgd2OzzCrMb5JMX54FsYv8QqPsAhazK8X9D7kADn6c7dx/PvL8jgLMw0a2DG2bniU7iudFRTHEjiloyD6JXeNnhpX2PRhI1n3aarQndwj7y0iAc1ZzAW3x7zCj0w2MVyA5ZIAmgBW4Z/VKbT9aNselFuTrKNcuKqiEBEVU9KDcOzoix+28BsYNd1GSa82N9F/nmXbWcD3jA6vv9n54hC7tm3qi7e3FJa
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 18, 2026 at 03:53:23PM -0400, Johannes Weiner wrote:
> Locking is currently internal to the list_lru API. However, a caller
> might want to keep auxiliary state synchronized with the LRU state.
>
> For example, the THP shrinker uses the lock of its custom LRU to keep
> PG_partially_mapped and vmstats consistent.
>
> To allow the THP shrinker to switch to list_lru, provide normal and
> irqsafe locking primitives as well as caller-locked variants of the
> addition and deletion functions.
>
> Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Had a good look through the logic, went to write comments more than once then
realised I didn't need to, so LGTM and:

Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

> ---
>  include/linux/list_lru.h |  34 +++++++++++++
>  mm/list_lru.c            | 107 +++++++++++++++++++++++++++------------
>  2 files changed, 110 insertions(+), 31 deletions(-)
>
> diff --git a/include/linux/list_lru.h b/include/linux/list_lru.h
> index fe739d35a864..4afc02deb44d 100644
> --- a/include/linux/list_lru.h
> +++ b/include/linux/list_lru.h
> @@ -83,6 +83,40 @@ int memcg_list_lru_alloc(struct mem_cgroup *memcg, struct list_lru *lru,
>  			 gfp_t gfp);
>  void memcg_reparent_list_lrus(struct mem_cgroup *memcg, struct mem_cgroup *parent);
>
> +/**
> + * list_lru_lock: lock the sublist for the given node and memcg
> + * @lru: the lru pointer
> + * @nid: the node id of the sublist to lock.
> + * @memcg: the cgroup of the sublist to lock.
> + *
> + * Returns the locked list_lru_one sublist. The caller must call
> + * list_lru_unlock() when done.
> + *
> + * You must ensure that the memcg is not freed during this call (e.g., with
> + * rcu or by taking a css refcnt).
> + *
> + * Return: the locked list_lru_one, or NULL on failure
> + */
> +struct list_lru_one *list_lru_lock(struct list_lru *lru, int nid,
> +		struct mem_cgroup *memcg);
> +
> +/**
> + * list_lru_unlock: unlock a sublist locked by list_lru_lock()
> + * @l: the list_lru_one to unlock
> + */
> +void list_lru_unlock(struct list_lru_one *l);
> +
> +struct list_lru_one *list_lru_lock_irqsave(struct list_lru *lru, int nid,
> +		struct mem_cgroup *memcg, unsigned long *irq_flags);
> +void list_lru_unlock_irqrestore(struct list_lru_one *l,
> +		unsigned long *irq_flags);
> +
> +/* Caller-locked variants, see list_lru_add() etc for documentation */
> +bool __list_lru_add(struct list_lru *lru, struct list_lru_one *l,
> +		struct list_head *item, int nid, struct mem_cgroup *memcg);
> +bool __list_lru_del(struct list_lru *lru, struct list_lru_one *l,
> +		struct list_head *item, int nid);
> +
>  /**
>   * list_lru_add: add an element to the lru list's tail
>   * @lru: the lru pointer
> diff --git a/mm/list_lru.c b/mm/list_lru.c
> index 4d74c2e9c2a5..b817c0f48f73 100644
> --- a/mm/list_lru.c
> +++ b/mm/list_lru.c
> @@ -15,17 +15,23 @@
>  #include "slab.h"
>  #include "internal.h"
>
> -static inline void lock_list_lru(struct list_lru_one *l, bool irq)
> +static inline void lock_list_lru(struct list_lru_one *l, bool irq,
> +				 unsigned long *irq_flags)
>  {
> -	if (irq)
> +	if (irq_flags)
> +		spin_lock_irqsave(&l->lock, *irq_flags);
> +	else if (irq)
>  		spin_lock_irq(&l->lock);
>  	else
>  		spin_lock(&l->lock);
>  }
>
> -static inline void unlock_list_lru(struct list_lru_one *l, bool irq_off)
> +static inline void unlock_list_lru(struct list_lru_one *l, bool irq_off,
> +				   unsigned long *irq_flags)
>  {
> -	if (irq_off)
> +	if (irq_flags)
> +		spin_unlock_irqrestore(&l->lock, *irq_flags);
> +	else if (irq_off)
>  		spin_unlock_irq(&l->lock);
>  	else
>  		spin_unlock(&l->lock);
> @@ -78,7 +84,7 @@ list_lru_from_memcg_idx(struct list_lru *lru, int nid, int idx)
>
>  static inline struct list_lru_one *
>  lock_list_lru_of_memcg(struct list_lru *lru, int nid, struct mem_cgroup *memcg,
> -		       bool irq, bool skip_empty)
> +		       bool irq, unsigned long *irq_flags, bool skip_empty)
>  {
>  	struct list_lru_one *l;
>
> @@ -86,12 +92,12 @@ lock_list_lru_of_memcg(struct list_lru *lru, int nid, struct mem_cgroup *memcg,
>  again:
>  	l = list_lru_from_memcg_idx(lru, nid, memcg_kmem_id(memcg));
>  	if (likely(l)) {
> -		lock_list_lru(l, irq);
> +		lock_list_lru(l, irq, irq_flags);
>  		if (likely(READ_ONCE(l->nr_items) != LONG_MIN)) {
>  			rcu_read_unlock();
>  			return l;
>  		}
> -		unlock_list_lru(l, irq);
> +		unlock_list_lru(l, irq, irq_flags);
>  	}
>  	/*
>  	 * Caller may simply bail out if raced with reparenting or
> @@ -132,37 +138,81 @@ list_lru_from_memcg_idx(struct list_lru *lru, int nid, int idx)
>
>  static inline struct list_lru_one *
>  lock_list_lru_of_memcg(struct list_lru *lru, int nid, struct mem_cgroup *memcg,
> -		       bool irq, bool skip_empty)
> +		       bool irq, unsigned long *irq_flags, bool skip_empty)
>  {
>  	struct list_lru_one *l = &lru->node[nid].lru;
>
> -	lock_list_lru(l, irq);
> +	lock_list_lru(l, irq, irq_flags);
>
>  	return l;
>  }
>  #endif /* CONFIG_MEMCG */
>
> -/* The caller must ensure the memcg lifetime. */
> -bool list_lru_add(struct list_lru *lru, struct list_head *item, int nid,
> -		  struct mem_cgroup *memcg)
> +struct list_lru_one *list_lru_lock(struct list_lru *lru, int nid,
> +				   struct mem_cgroup *memcg)
>  {
> -	struct list_lru_node *nlru = &lru->node[nid];
> -	struct list_lru_one *l;
> +	return lock_list_lru_of_memcg(lru, nid, memcg, /*irq=*/false,
> +				      /*irq_flags=*/NULL, /*skip_empty=*/false);
> +}
> +
> +void list_lru_unlock(struct list_lru_one *l)
> +{
> +	unlock_list_lru(l, /*irq_off=*/false, /*irq_flags=*/NULL);
> +}
> +
> +struct list_lru_one *list_lru_lock_irqsave(struct list_lru *lru, int nid,
> +					   struct mem_cgroup *memcg,
> +					   unsigned long *flags)
> +{
> +	return lock_list_lru_of_memcg(lru, nid, memcg, /*irq=*/true,
> +				      /*irq_flags=*/flags, /*skip_empty=*/false);
> +}
> +
> +void list_lru_unlock_irqrestore(struct list_lru_one *l, unsigned long *flags)
> +{
> +	unlock_list_lru(l, /*irq_off=*/true, /*irq_flags=*/flags);
> +}
>
> -	l = lock_list_lru_of_memcg(lru, nid, memcg, false, false);
> +bool __list_lru_add(struct list_lru *lru, struct list_lru_one *l,
> +		    struct list_head *item, int nid,
> +		    struct mem_cgroup *memcg)
> +{
>  	if (list_empty(item)) {
>  		list_add_tail(item, &l->list);
>  		/* Set shrinker bit if the first element was added */
>  		if (!l->nr_items++)
>  			set_shrinker_bit(memcg, nid, lru_shrinker_id(lru));
> -		unlock_list_lru(l, false);
> -		atomic_long_inc(&nlru->nr_items);
> +		atomic_long_inc(&lru->node[nid].nr_items);
> +		return true;
> +	}
> +	return false;
> +}
> +
> +bool __list_lru_del(struct list_lru *lru, struct list_lru_one *l,
> +		    struct list_head *item, int nid)
> +{
> +	if (!list_empty(item)) {
> +		list_del_init(item);
> +		l->nr_items--;
> +		atomic_long_dec(&lru->node[nid].nr_items);
>  		return true;
>  	}
> -	unlock_list_lru(l, false);
>  	return false;
>  }
>
> +/* The caller must ensure the memcg lifetime. */
> +bool list_lru_add(struct list_lru *lru, struct list_head *item, int nid,
> +		  struct mem_cgroup *memcg)
> +{
> +	struct list_lru_one *l;
> +	bool ret;
> +
> +	l = list_lru_lock(lru, nid, memcg);
> +	ret = __list_lru_add(lru, l, item, nid, memcg);
> +	list_lru_unlock(l);
> +	return ret;
> +}
> +
>  bool list_lru_add_obj(struct list_lru *lru, struct list_head *item)
>  {
>  	bool ret;
> @@ -184,19 +234,13 @@ EXPORT_SYMBOL_GPL(list_lru_add_obj);
>  bool list_lru_del(struct list_lru *lru, struct list_head *item, int nid,
>  		  struct mem_cgroup *memcg)
>  {
> -	struct list_lru_node *nlru = &lru->node[nid];
>  	struct list_lru_one *l;
> +	bool ret;
>
> -	l = lock_list_lru_of_memcg(lru, nid, memcg, false, false);
> -	if (!list_empty(item)) {
> -		list_del_init(item);
> -		l->nr_items--;
> -		unlock_list_lru(l, false);
> -		atomic_long_dec(&nlru->nr_items);
> -		return true;
> -	}
> -	unlock_list_lru(l, false);
> -	return false;
> +	l = list_lru_lock(lru, nid, memcg);
> +	ret = __list_lru_del(lru, l, item, nid);
> +	list_lru_unlock(l);
> +	return ret;
>  }
>
>  bool list_lru_del_obj(struct list_lru *lru, struct list_head *item)
> @@ -269,7 +313,8 @@ __list_lru_walk_one(struct list_lru *lru, int nid, struct mem_cgroup *memcg,
>  	unsigned long isolated = 0;
>
>  restart:
> -	l = lock_list_lru_of_memcg(lru, nid, memcg, irq_off, true);
> +	l = lock_list_lru_of_memcg(lru, nid, memcg, /*irq=*/irq_off,
> +				   /*irq_flags=*/NULL, /*skip_empty=*/true);
>  	if (!l)
>  		return isolated;
>  	list_for_each_safe(item, n, &l->list) {
> @@ -310,7 +355,7 @@ __list_lru_walk_one(struct list_lru *lru, int nid, struct mem_cgroup *memcg,
>  			BUG();
>  		}
>  	}
> -	unlock_list_lru(l, irq_off);
> +	unlock_list_lru(l, irq_off, NULL);
>  out:
>  	return isolated;
>  }
> --
> 2.53.0
>

