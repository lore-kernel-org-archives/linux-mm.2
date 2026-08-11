Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87C12C5AD55
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 00:12:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E3A046B008A; Mon, 10 Aug 2026 20:12:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E10596B008C; Mon, 10 Aug 2026 20:12:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D4E8E6B0092; Mon, 10 Aug 2026 20:12:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 955626B008A
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 20:12:50 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1A07E40302
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 00:12:50 +0000 (UTC)
X-FDA: 85087062900.03.DE82EBA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 6950E180008
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 00:12:48 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MRYQoqK3;
	spf=pass (imf16.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786407168;
	b=x01x8rXH6qsOxU843ow57CTMXG7hFwxEtFw0ZLf91QKyw26zlll/iLAwqaPF7+vNKxBXmc
	bqRQwureWyGhsMVbXahRnhwYuF23dLBM+Ei1SQFKG3wXlMqDHz8tg7MFbIMxuyoWGY9cU5
	CSUtmosZmZHm1IcbQGYa246ypco9maE=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MRYQoqK3;
	spf=pass (imf16.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786407168;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3T6JgGC76v/Qc26IiCVVRPE74vRurEDwCMQZ6951TmA=;
	b=2VimzorpABUBOlLKRxGBReO6P9i+sjp3MTm45V0s4bfhRlb4XqCRxkv27LKVH6nab+spSr
	d4/Q/qP5AhFNo+160cyfRczPkTbKuhm4WfWqrV3Y6EzVcTJNlGUYtjxMxfeY6OgUgY1Jbk
	hMMjn4vO3JmjaGk2J9PUHyFkSShRgWI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BF3CE4350A;
	Tue, 11 Aug 2026 00:12:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 591031F000E9;
	Tue, 11 Aug 2026 00:12:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786407166;
	bh=3T6JgGC76v/Qc26IiCVVRPE74vRurEDwCMQZ6951TmA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MRYQoqK3kO6QB2hE3UIMp56L/IeDzXmghlQvijiJyv3LWBthh+y8WZSy4mgZqxIUj
	 CAGzQKEWVjsHVFPDicczAJEnP+C74k8XIRtBNQzl1/w5w63Ic5GPga5CGpYVBYNpo6
	 pLMZEFMoQoec+Y13E5ohx5K5o2Bit1EOaqy+KIRiDLH3lWYIhl/oQujVw8tmtZImoT
	 eQT/dWofozedMoHMbwafKKsG06JlByaFY4bIVEBakw23wxsE2yhXZHmSV/ODuRvqEM
	 vJHQaOMg7Wsc3PiM808sATR24jC1Uxj1DB22QuVmb1c4XOsRrhreb6S/UFmhEKw925
	 RYDh8jBzlWefw==
Date: Tue, 11 Aug 2026 00:12:44 +0000
From: Yosry Ahmed <yosry@kernel.org>
To: Jianyue Wu <wujianyue000@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Johannes Weiner <hannes@cmpxchg.org>, Nhat Pham <nphamcs@gmail.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Chris Li <chrisl@kernel.org>
Subject: Re: [PATCH RFC v2 1/2] mm/zswap: replace the zswap_pools list with a
 fixed pools array
Message-ID: <anpnowepnexrNea_@google.com>
References: <20260731-shrink_zswap_entry_v2-0-0-v2-0-e72083aa8734@gmail.com>
 <20260731-shrink_zswap_entry_v2-0-0-v2-1-e72083aa8734@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260731-shrink_zswap_entry_v2-0-0-v2-1-e72083aa8734@gmail.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 6950E180008
X-Stat-Signature: atxeqgu454nbb4w17qc7ficnu3fmwoir
X-Rspam-User: 
X-HE-Tag: 1786407168-591349
X-HE-Meta: U2FsdGVkX1/CokIS7mEjLhbdZiD6TBEEbYdKxNImPUltvpMIXH9Cpz0tmX0G+0YoKLsuwqji4qnTU4bCC9Vxwbs7GhOMXtkkJZ10uMH5SDGrfNT7XmB+kh5BHJdW1lBJ1UCPyqb3efLV4AenbDN6qM9/faLEVMxzhFx8cjkBg0zjEGWK9+vpIf5rRmC/xo+aUHAwgo0LEGMwswm0avdYtChNVo563eKM9iJqN6UQojJq0Ay3QkE/hzrlc6xmWa/qsfHixl9K/22m5aKerfIDMg9mQSxsTZoUcrZX2FpVHPq5NBEQQ2RE9wVzYj0GRMu2XgJwHvkRnnpHA6UiJcZZmufB/iob90k/S4XHLpFP4VcuJH0ccRMq76c+xH6G/JxyW9m3egJ0rI/t6rz1gCk+NGOIa/N66O6Jz8R8fOpzzzaKf54RnMCsLqvYR/C6eDcASLIbifQCYigc2swCk2CCN83HmJ4qanV6luBn6S+aDdLjp0fz4GRFcgZmOzLI1RMDE3SUSS4LdbdBewi3GqNZqYI02yAJQm8a4tfu9SH6Jm21YRqd/V0R2l4NyWTFxZHFGXroXiqF6NLEL5rZkgznkK2TvTub1Rsso6oPtJdUXhllDn1m3s2lr4ED1PHPLdXMn39atpjYUcU2GRw0jlgsZnHmp2dJbgNEB6YLtcTP+Fepd9/i5X3XxcZ2O//A6NOU99NdrA/G1U3wvu2F5Y+2aBF8tRNYB/+UehQ2XmTSIRmxPzvS1jRuO3cmDTbzdeI6a52jY08b/e5vR2diPseXWz8sjLW9UwKJfFm+mh2bqpIjSJlQaokLn/w4m5YZ0cw4DYb7zYE60cGDbZhQZMglDMcYi4hdHDk9W45wt2/WiZtmMLry8RQwZtjgGgBn+Z1mO7eHON9Z4QaaIEk519JvsGCac1ThuJn+WxORtndFdpWivVd88pa42dVSv0phulxJpRF5XleWspIrCIagH2p
 PxnWdnT4
 NtZuJ+zytyZvvC40p90DQdCOU6wf8SCtKNfDy3gk2yr11qah9t7iMZL67hxOohb4Kfh8JkC4Rw1lZuwJ9MwhGNPt190GEn8kh7JM5IP5yotdgcnCKqAyppUP7UnAJqpasq9A5Qapa3AD0tN9i2zE4cFh79ELLS6aRBwCszChS8mG/O1vZbJ3N5ci77Nh0Uz3Ho78THgwmm7XbrMVtoSP3zUgeG8z0A7uUWnogfUKQAtNy5tyxIWgbY2EYwGZRNIXEPFAGzJSvU1L+UrXc1/bhsC+T9rEfvP5sp4qUuNgnQ+IljlBkjXKGT+g0Z7PD+/DxwUXitomMnIT9O4QJj6qeSX9jTHHFoWa9Fp1+7LLtnKfhLcHzpiCMIHQ5DavTORZsyAGz2Fcb+DLKyRuyPIUtqsm6PA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 31, 2026 at 08:32:47AM +0800, Jianyue Wu wrote:
> Originally zswap holds its pools on an RCU list whose head also serves as
> the "current pool".  Only a handful of pools are ever live at once, since
> a new pool is only created when the compressor is (re)set and pools are
> reused across compressor switches.
> 
> A later change wants to store a reference to each entry's pool in every
> zswap_entry, where a pointer would cost 8 bytes but a small pool index
> only one.  To make that index possible, the current change holds the
> pools in a fixed ZSWAP_MAX_POOLS-element array so each pool has a stable
> slot number, and tracks the current pool with a separate rcu-protected
> pointer.
> 
> The array keeps the same RCU publish/retire discipline the list had, so
> lookup and teardown stay equivalent.  Newly created pools are published
> into the array before they become current, so zswap_total_pages() can
> observe an empty pool briefly; that is harmless.

I don't follow. A newly created pool is empty anyway, so not being
iterated in zswap_total_pages() should be normal. Why do we need to call
this out?

> This also caps the
> number of live pools at ZSWAP_MAX_POOLS (16), which is plenty in
> practice; pool creation warns and fails if the array ever fills, and the
> limit can be raised.
> 
> Suggested-by: Nhat Pham <nphamcs@gmail.com>
> Suggested-by: Yosry Ahmed <yosry@kernel.org>
> Signed-off-by: Jianyue Wu <wujianyue000@gmail.com>
> ---
>  mm/zswap.c | 88 +++++++++++++++++++++++++++++++++++++++++++++++---------------
>  1 file changed, 67 insertions(+), 21 deletions(-)
> 
> diff --git a/mm/zswap.c b/mm/zswap.c
> index 4e76a4a87cdc..b203934d3be8 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -154,12 +154,20 @@ struct zswap_pool {
>  	struct zs_pool *zs_pool;
>  	struct crypto_acomp_ctx __percpu *acomp_ctx;
>  	struct percpu_ref ref;
> -	struct list_head list;
>  	struct work_struct release_work;
>  	struct hlist_node node;
> +	u8 idx;
>  	char tfm_name[CRYPTO_MAX_ALG_NAME];
>  };
>  
> +#define ZSWAP_MAX_POOLS 16
> +static struct zswap_pool __rcu *zswap_pools[ZSWAP_MAX_POOLS];
> +/*
> + * The current pool (NULL if none): an alias of one zswap_pools[] slot.  It
> + * always holds a ref, so it is never retired from under us.
> + */
> +static struct zswap_pool __rcu *zswap_current_pool;
> +
>  /* Global LRU lists shared by all zswap pools. */
>  static struct list_lru zswap_list_lru;
>  
> @@ -200,9 +208,7 @@ struct zswap_entry {
>  static struct xarray *zswap_trees[MAX_SWAPFILES];
>  static unsigned int nr_zswap_trees[MAX_SWAPFILES];
>  
> -/* RCU-protected iteration */
> -static LIST_HEAD(zswap_pools);
> -/* protects zswap_pools list modification */
> +/* protects the zswap_pools array and zswap_current_pool */
>  static DEFINE_SPINLOCK(zswap_pools_lock);
>  /* pool counter to provide unique names to zsmalloc */
>  static atomic_t zswap_pools_count = ATOMIC_INIT(0);
> @@ -270,6 +276,25 @@ static void acomp_ctx_free(struct crypto_acomp_ctx *acomp_ctx)
>  	acomp_ctx->buffer = NULL;
>  }
>  
> +static int zswap_pool_reserve_slot(struct zswap_pool *pool)
> +{
> +	int i, ret = -ENOSPC;
> +
> +	spin_lock_bh(&zswap_pools_lock);
> +	for (i = 0; i < ZSWAP_MAX_POOLS; i++) {
> +		if (!rcu_access_pointer(zswap_pools[i])) {
> +			/* Set idx before publishing so readers never see it stale. */
> +			pool->idx = i;
> +			rcu_assign_pointer(zswap_pools[i], pool);

Sashiko points out a seemingly real problem here because we add the pool
to the array before actually making it the current pool.

https://sashiko.dev/#/patchset/20260731-shrink_zswap_entry_v2-0-0-v2-0-e72083aa8734%40gmail.com

What if we just reserve an index here but not actually assign the pool?
We can add a marker to the array or sth (e.g. (void *)-1UL)).


> +			ret = i;
> +			break;
> +		}
> +	}
> +	spin_unlock_bh(&zswap_pools_lock);
> +
> +	return ret;
> +}
> +
>  static struct zswap_pool *zswap_pool_create(char *compressor)
>  {
>  	struct zswap_pool *pool;
> @@ -313,19 +338,27 @@ static struct zswap_pool *zswap_pool_create(char *compressor)
>  	if (ret)
>  		goto cpuhp_add_fail;
>  
> -	/* being the current pool takes 1 ref; this func expects the
> -	 * caller to always add the new pool as the current pool
> +	/*
> +	 * After a successful create, the caller makes this the current pool.
> +	 * If the caller fails, it kills the ref to free the reserved slot.
>  	 */
>  	ret = percpu_ref_init(&pool->ref, __zswap_pool_empty,
>  			      PERCPU_REF_ALLOW_REINIT, GFP_KERNEL);
>  	if (ret)
>  		goto ref_fail;
> -	INIT_LIST_HEAD(&pool->list);
> +
> +	ret = zswap_pool_reserve_slot(pool);
> +	if (ret < 0) {
> +		pr_err("cannot create more than %d pools\n", ZSWAP_MAX_POOLS);
> +		goto slot_fail;
> +	}
>  
>  	zswap_pool_debug("created", pool);
>  
>  	return pool;
>  
> +slot_fail:
> +	percpu_ref_exit(&pool->ref);
>  ref_fail:
>  	cpuhp_state_remove_instance(CPUHP_MM_ZSWP_POOL_PREPARE, &pool->node);
>  
> @@ -388,7 +421,7 @@ static void __zswap_pool_release(struct work_struct *work)
>  	WARN_ON(!percpu_ref_is_zero(&pool->ref));
>  	percpu_ref_exit(&pool->ref);
>  
> -	/* pool is now off zswap_pools list and has no references. */
> +	/* Slot cleared in __zswap_pool_empty(); synchronize_rcu() drained readers. */
>  	zswap_pool_destroy(pool);
>  }
>  
> @@ -404,7 +437,11 @@ static void __zswap_pool_empty(struct percpu_ref *ref)
>  
>  	WARN_ON(pool == zswap_pool_current());
>  
> -	list_del_rcu(&pool->list);
> +	/*
> +	 * Clear the slot before scheduling the release so new readers cannot
> +	 * see it; __zswap_pool_release()'s synchronize_rcu() drains the rest.
> +	 */
> +	rcu_assign_pointer(zswap_pools[pool->idx], NULL);
>  
>  	INIT_WORK(&pool->release_work, __zswap_pool_release);
>  	schedule_work(&pool->release_work);

Not related to this change, but I wonder if we can use call_rcu() or
similar here instead of the manual synchronize_rcu().

> @@ -435,7 +472,8 @@ static struct zswap_pool *__zswap_pool_current(void)
>  {
>  	struct zswap_pool *pool;
>  
> -	pool = list_first_or_null_rcu(&zswap_pools, typeof(*pool), list);
> +	pool = rcu_dereference_check(zswap_current_pool,
> +				     lockdep_is_held(&zswap_pools_lock));
>  	WARN_ONCE(!pool && zswap_has_pool,
>  		  "%s: no page storage pool!\n", __func__);
>  
> @@ -468,11 +506,14 @@ static struct zswap_pool *zswap_pool_current_get(void)
>  static struct zswap_pool *zswap_pool_find_get(char *compressor)
>  {
>  	struct zswap_pool *pool;
> +	int i;
>  
>  	assert_spin_locked(&zswap_pools_lock);
>  
> -	list_for_each_entry_rcu(pool, &zswap_pools, list) {
> -		if (strcmp(pool->tfm_name, compressor))
> +	for (i = 0; i < ZSWAP_MAX_POOLS; i++) {
> +		pool = rcu_dereference_protected(zswap_pools[i],
> +					lockdep_is_held(&zswap_pools_lock));

We already have an assertion that we are holding the lock above.

> +		if (!pool || strcmp(pool->tfm_name, compressor))
>  			continue;
>  		/* if we can't get it, it's about to be destroyed */
>  		if (!zswap_pool_tryget(pool))
 

