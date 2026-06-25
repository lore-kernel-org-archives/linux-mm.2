Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93EB6CDE00B
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 23:50:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 580AF6B00A0; Thu, 25 Jun 2026 19:50:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 531456B00A1; Thu, 25 Jun 2026 19:50:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 446F56B00A3; Thu, 25 Jun 2026 19:50:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 17AE06B00A0
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 19:50:29 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8FD18A02C1
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 23:50:28 +0000 (UTC)
X-FDA: 84920081736.01.387B6CB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id D53A78000A
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 23:50:26 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VO8YTXhZ;
	spf=pass (imf02.hostedemail.com: domain of dlemoal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dlemoal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782431426;
	b=DaJXd+244Zxbbaz2MqOyq5Zbn56ja7UrKb5ymifsmTPu1X+C6rPQdtbVpThUIfIa1qnyxU
	wifoEt/KcAp6+oXcaNwgsyPWzXnYE22FRcYgsiAVDquv3EJHQmD6tvu9qDjyh21C+HUJlS
	s8qlJXelDtbeywU00Q8SY4fE1y8QgkQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782431426;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nPKUZaKOV+T0YJEXJcsPSJeM+eppQ2kUQs5Ru8ktT/0=;
	b=j8cLzllsF4b1UtEHKq3CDfOpjpFeAqYUFiKLai4JxNfzNoWsJvsGO5z4YXNlVCPaBRMwCE
	ZBKXF7azQ9G+1y6G/ULLtC5sjUsWouCNA2QGz2zKD1PrOkmU1CGwa8B7pI+kaDb/oqBo3p
	aYrYn1+U61g+jOpl0jUp0aA54f+/1N4=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VO8YTXhZ;
	spf=pass (imf02.hostedemail.com: domain of dlemoal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dlemoal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0C08C60098;
	Thu, 25 Jun 2026 23:50:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C1391F000E9;
	Thu, 25 Jun 2026 23:50:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782431425;
	bh=nPKUZaKOV+T0YJEXJcsPSJeM+eppQ2kUQs5Ru8ktT/0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=VO8YTXhZvxJBWT9+DE82g3PxL+51L6Ww30E759CA9otYOPqXMzpdghOPFjzZQdRp6
	 xoS/VKzUyYgGHtLLnsY+B3QzC3DrvuKaCpoPQLBYD9sfKu869hg0tSUHpxShvZkNdB
	 CL4b1HQ6bCZ2kds0Xljo6dmvXh3Oi4WgNZYnUVykkl1wgJe7crmfIDaZ6/BJqZYCcu
	 UnlRzImqbm7x4BHF7Q6WfBMyGbNChpP8DbDLLm4Ljq1UbbJAqR547QE1DafRc3x9y0
	 XINwDn5zgzgXjiOrvlXgsnPX/eXpaVVLnmszxoCy9S6ATtIYXPyJdet/NRJOSSbhDZ
	 TbXYaoymzju1w==
Message-ID: <9104ac5d-ed2b-409d-8220-512dd4581966@kernel.org>
Date: Fri, 26 Jun 2026 08:50:11 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mempool: optimize mempool resizing
To: Vitaly Wool <vitaly.wool@konsulko.se>,
 Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <axboe@kernel.dk>,
 Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>
Cc: Sagi Grimberg <sagi@grimberg.me>, Vlastimil Babka <vbabka@kernel.org>,
 Harry Yoo <harry@kernel.org>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, linux-block@vger.kernel.org,
 linux-nvme@lists.infradead.org, linux-mm@kvack.org,
 Vitaly Vul <vitaly.vul@partner.samsung.com>
References: <20260625194915.387663-1-vitaly.wool@konsulko.se>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20260625194915.387663-1-vitaly.wool@konsulko.se>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: D53A78000A
X-Stat-Signature: fzfz9nr1hrjhm1mm6idtmqtojzwkwwge
X-HE-Tag: 1782431426-126545
X-HE-Meta: U2FsdGVkX19Z1Itzr+1Q4towG+LQiK07ofOaRwAtX23GAwRgqFYH19fcWQ8hN2oYsfp8aXDjh2+9g7aUiOiLCLc/n6GTqaa/RWFnqd9mdFqNFvSU6rRV5DeMZjno1epkeJJH86iERPXDt7tU9IX55EPAR3dPI/A8Y61SovBMIYGqZYZANv5D9MP5ZZe0uiq9CyK3QPprn4zGrrWKIHJ+YcT0cRmfRFtqPIldvY3+RdGCCKRH4Q2DO73lUsTnhj5mn/Y+yVlSD+U/tKIfVIUBDixdsvfQv0DZZ+Vt0wrKCJzcW1Xo6a+AZUhQ3iUWZOCMQm8HruZhIXvvJUzTrUcux+l08v7RCcuShg5T+4notkSiGIg8WL4/bw47ULj/+HiYqxXGE60v7HVC9/Dw1GCabDDobErLX1mL5Gu48mb0P9hP69S7qlevNzovSTsiC5UCI//LtBn5x3q5a2yjgUibsuaiuiNS5LDj4xJ91mtgQo2jEYe4PQW0y1r73Oe8HNHY6w7JaUe8eBh8gYCN1uHQvvtw1Rlo5Ng2vB2T4gcjL28zt3HU/Ev2mMMjzu/4w/rI1bydInrcYpGbafph178AEcrabyO4kJhfP63zCniPnUiVo69yiaftskwd6l68mooqfGnwXr7KUI2HknKnCRb/XP6cSmQHJolhRqZfpfHff7wrooSIh/LKNqAgsNg9oZ+FXJG5SCeTV1rNeEr4zB8H1kjz9+PWuqX7oSEp6DOfB5EFiJnzcfL0mGy84BB3q+QDjjVNgADox5RJFfrCiIDHGlDgXaO6j66mPPmLUAtoa2dxv12dDmuk5fzj0fnh8Grxeb2GJR2b4n3+nMtsXg7bduu6FXr/2axhFg3s1pklTHoAFWuGwJjybHMrv6IpYvB7+Fvo0Hk5FfR0yCwYxZHU4UbYLn/4XrEenVNJ3djI7cs41tnUvjFem1ZYmhIRbCHoaTxPfeGJjRA9ixlUcF4
 rmxMyU0W
 46plulTAZ/gHygB9ReWqhQN/qCzalYhhef69qJ1G6Yy5/VRV5R+5yf0reBsi1aKYEIJlmlL5RqG4jmY18L3PbOVC68+W0JXDcg27yr7vu+E45n37NZKcK8RfIuRDpoJbVfID8WGrCCWOqNXBT1pDw64b4WpCtbtG7mbldvDHkxxcB7FIp/kNQCl0UcvoDlXmzLjPzes/408V5aKJUhQMbIcmmxHS0+FncRH7LLeDg7NdtuR+hx7bGM6qyQOWDpXd6oBb/uOqSpdKvppYU4x2kdS+SSxC+EZAoXWWBmMZ9qGE0S/gAbbN68YgtNiV9zIGQTqwh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/26/26 4:49 AM, Vitaly Wool wrote:
> From: Vitaly Vul <vitaly.vul@partner.samsung.com>
> 
> Resizing mempool to a bigger size currently requires a new allocation and a
> data copy to a new larger elements array which doesn't go well with the
> idea of having a fast and deadlock free memory allocations during exreme VM
> load.
> 
> This patch introduces a new parameter max_nr for a part of the mempool API,
> which denotes the maximum size of the pool. With it in place we can avoid
> any allocations in mempool_resize() since we can either grant the resizing
> request or reject it basing on thr maximum allowed size of the elements
> array. For those few users of the mempool API that actually use
> mempool_resize() it is a clear upgrade because the maximum number of
> elements is known upfront.
> 
> Derivative APIs (like mempool_init_kmalloc_pool()) are mostly left intact,
> substituted by the new mempool_init_kmalloc_resizable_pool() API where the
> pool is actually meant to be resizable.
> 
> Signed-off-by: Vitaly Vul <vitaly.vul@partner.samsung.com>
> ---
>  block/blk-zoned.c       |  6 ++--
>  drivers/nvme/host/pci.c |  2 +-
>  include/linux/mempool.h | 18 +++++++---
>  mm/mempool.c            | 75 +++++++++++------------------------------
>  4 files changed, 38 insertions(+), 63 deletions(-)
> 
> diff --git a/block/blk-zoned.c b/block/blk-zoned.c
> index 6a221c180889..5d31597f2fe6 100644
> --- a/block/blk-zoned.c
> +++ b/block/blk-zoned.c
> @@ -1918,8 +1918,10 @@ static int disk_alloc_zone_resources(struct gendisk *disk,
>  	for (i = 0; i < disk_zone_wplugs_hash_size(disk); i++)
>  		INIT_HLIST_HEAD(&disk->zone_wplugs_hash[i]);
>  
> -	disk->zone_wplugs_pool = mempool_create_kmalloc_pool(pool_size,
> -						sizeof(struct blk_zone_wplug));
> +	disk->zone_wplugs_pool = mempool_create_kmalloc_resizable_pool(
> +					pool_size,
> +					BLK_ZONE_WPLUG_DEFAULT_POOL_SIZE,

Even though that is not encouraged, we can have far more than
BLK_ZONE_WPLUG_DEFAULT_POOL_SIZE zone write plugs for a device, if the user is
writting to more zones that the device advertized max open zone limit.

Furthermore, a device can have a max open zone limit that is far larger than
BLK_ZONE_WPLUG_DEFAULT_POOL_SIZE, in which case, we would ve the min_nr
(pool_size argument) greater than the max_nr argument
(BLK_ZONE_WPLUG_DEFAULT_POOL_SIZE).

So this does not look correct to me. But more importantly, I am failing to see
what you are after here, and as Andrew asked, I do not see the issue that you
are trying to solve. The mempool resizing to pool_size is always done so that
we can have at least enough zone write plugs in the mempool to satisfy the
device max open zones (or max active zones) limit. Any allocation beyond that
limit is still possible but not relying on having a free element in the mempool.

> +					sizeof(struct blk_zone_wplug));
>  	if (!disk->zone_wplugs_pool)
>  		goto free_hash;
>  
> diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
> index b5f846200678..eaa4804ab3c3 100644
> --- a/drivers/nvme/host/pci.c
> +++ b/drivers/nvme/host/pci.c
> @@ -3349,7 +3349,7 @@ static int nvme_pci_alloc_iod_mempool(struct nvme_dev *dev)
>  {
>  	size_t alloc_size = sizeof(struct nvme_dma_vec) * NVME_MAX_SEGS;
>  
> -	dev->dmavec_mempool = mempool_create_node(1,
> +	dev->dmavec_mempool = mempool_create_node(1, 2,
>  			mempool_kmalloc, mempool_kfree,
>  			(void *)alloc_size, GFP_KERNEL,
>  			dev_to_node(dev->dev));
> diff --git a/include/linux/mempool.h b/include/linux/mempool.h
> index e8e440e04a06..8b950efded18 100644
> --- a/include/linux/mempool.h
> +++ b/include/linux/mempool.h
> @@ -18,6 +18,7 @@ typedef void (mempool_free_t)(void *element, void *pool_data);
>  typedef struct mempool {
>  	spinlock_t lock;
>  	int min_nr;		/* nr of elements at *elements */
> +	int max_nr;		/* max nr of elements at *elements */
>  	int curr_nr;		/* Current nr of elements at *elements */
>  	void **elements;
>  
> @@ -38,7 +39,7 @@ static inline bool mempool_is_saturated(struct mempool *pool)
>  }
>  
>  void mempool_exit(struct mempool *pool);
> -int mempool_init_node(struct mempool *pool, int min_nr,
> +int mempool_init_node(struct mempool *pool, int min_nr, int max_nr,
>  		mempool_alloc_t *alloc_fn, mempool_free_t *free_fn,
>  		void *pool_data, gfp_t gfp_mask, int node_id);
>  int mempool_init_noprof(struct mempool *pool, int min_nr,
> @@ -49,15 +50,15 @@ int mempool_init_noprof(struct mempool *pool, int min_nr,
>  
>  struct mempool *mempool_create(int min_nr, mempool_alloc_t *alloc_fn,
>  		mempool_free_t *free_fn, void *pool_data);
> -struct mempool *mempool_create_node_noprof(int min_nr,
> +struct mempool *mempool_create_node_noprof(int min_nr, int max_nr,
>  		mempool_alloc_t *alloc_fn, mempool_free_t *free_fn,
>  		void *pool_data, gfp_t gfp_mask, int nid);
>  #define mempool_create_node(...)					\
>  	alloc_hooks(mempool_create_node_noprof(__VA_ARGS__))
>  
> -#define mempool_create(_min_nr, _alloc_fn, _free_fn, _pool_data)	\
> -	mempool_create_node(_min_nr, _alloc_fn, _free_fn, _pool_data,	\
> -			    GFP_KERNEL, NUMA_NO_NODE)
> +#define mempool_create(_min_nr, _alloc_fn, _free_fn, _data)	\
> +	mempool_create_node(_min_nr, (_min_nr)*2, _alloc_fn, _free_fn,	\
> +			    _data, GFP_KERNEL, NUMA_NO_NODE)
>  
>  int mempool_resize(struct mempool *pool, int new_min_nr);
>  void mempool_destroy(struct mempool *pool);
> @@ -102,6 +103,13 @@ void mempool_kfree(void *element, void *pool_data);
>  	mempool_create((_min_nr), mempool_kmalloc, mempool_kfree,	\
>  		       (void *)(unsigned long)(_size))
>  
> +#define mempool_init_kmalloc_resizable_pool(_pool, _min_nr, _max_nr, _size)		\
> +	mempool_init_node(_pool, _min_nr, _max_nr, mempool_kmalloc, mempool_kfree,	\
> +		     (void *)(unsigned long)(_size), GFP_KERNEL, NUMA_NO_NODE)
> +#define mempool_create_kmalloc_resizable_pool(_min_nr, _max_nr, _size)			\
> +	mempool_create_node(_min_nr, _max_nr, mempool_kmalloc, mempool_kfree,		\
> +		       (void *)(unsigned long)(_size), GFP_KERNEL, NUMA_NO_NODE)
> +
>  /*
>   * A mempool_alloc_t and mempool_free_t for a simple page allocator that
>   * allocates pages of the order specified by pool_data
> diff --git a/mm/mempool.c b/mm/mempool.c
> index db23e0eef652..4675405c0bd8 100644
> --- a/mm/mempool.c
> +++ b/mm/mempool.c
> @@ -207,7 +207,7 @@ void mempool_exit(struct mempool *pool)
>  		void *element = remove_element(pool);
>  		pool->free(element, pool->pool_data);
>  	}
> -	kfree(pool->elements);
> +	kvfree(pool->elements);
>  	pool->elements = NULL;
>  }
>  EXPORT_SYMBOL(mempool_exit);
> @@ -230,22 +230,22 @@ void mempool_destroy(struct mempool *pool)
>  }
>  EXPORT_SYMBOL(mempool_destroy);
>  
> -int mempool_init_node(struct mempool *pool, int min_nr,
> +int mempool_init_node(struct mempool *pool, int min_nr, int max_nr,
>  		mempool_alloc_t *alloc_fn, mempool_free_t *free_fn,
>  		void *pool_data, gfp_t gfp_mask, int node_id)
>  {
>  	spin_lock_init(&pool->lock);
>  	pool->min_nr	= min_nr;
> +	pool->max_nr	= max_nr;
>  	pool->pool_data = pool_data;
>  	pool->alloc	= alloc_fn;
>  	pool->free	= free_fn;
>  	init_waitqueue_head(&pool->wait);
> -	/*
> -	 * max() used here to ensure storage for at least 1 element to support
> -	 * zero minimum pool
> -	 */
> -	pool->elements = kmalloc_array_node(max(1, min_nr), sizeof(void *),
> -					    gfp_mask, node_id);
> +
> +	if (WARN_ON(max_nr < 1 || min_nr < 0))
> +		return -EINVAL;
> +
> +	pool->elements = kvmalloc_array_node_noprof(max_nr, sizeof(void *), gfp_mask, node_id);
>  	if (!pool->elements)
>  		return -ENOMEM;
>  
> @@ -253,7 +253,7 @@ int mempool_init_node(struct mempool *pool, int min_nr,
>  	 * First pre-allocate the guaranteed number of buffers,
>  	 * also pre-allocate 1 element for zero minimum pool.
>  	 */
> -	while (pool->curr_nr < max(1, pool->min_nr)) {
> +	while (pool->curr_nr < pool->min_nr) {
>  		void *element;
>  
>  		element = pool->alloc(gfp_mask, pool->pool_data);
> @@ -286,7 +286,7 @@ int mempool_init_noprof(struct mempool *pool, int min_nr,
>  		mempool_alloc_t *alloc_fn, mempool_free_t *free_fn,
>  		void *pool_data)
>  {
> -	return mempool_init_node(pool, min_nr, alloc_fn, free_fn,
> +	return mempool_init_node(pool, min_nr, min_nr * 2, alloc_fn, free_fn,
>  				 pool_data, GFP_KERNEL, NUMA_NO_NODE);
>  
>  }
> @@ -296,6 +296,7 @@ EXPORT_SYMBOL(mempool_init_noprof);
>   * mempool_create_node - create a memory pool
>   * @min_nr:    the minimum number of elements guaranteed to be
>   *             allocated for this pool.
> + * @max_nr:    the maximum capacity of the pool
>   * @alloc_fn:  user-defined element-allocation function.
>   * @free_fn:   user-defined element-freeing function.
>   * @pool_data: optional private data available to the user-defined functions.
> @@ -310,7 +311,7 @@ EXPORT_SYMBOL(mempool_init_noprof);
>   *
>   * Return: pointer to the created memory pool object or %NULL on error.
>   */
> -struct mempool *mempool_create_node_noprof(int min_nr,
> +struct mempool *mempool_create_node_noprof(int min_nr, int max_nr,
>  		mempool_alloc_t *alloc_fn, mempool_free_t *free_fn,
>  		void *pool_data, gfp_t gfp_mask, int node_id)
>  {
> @@ -320,7 +321,7 @@ struct mempool *mempool_create_node_noprof(int min_nr,
>  	if (!pool)
>  		return NULL;
>  
> -	if (mempool_init_node(pool, min_nr, alloc_fn, free_fn, pool_data,
> +	if (mempool_init_node(pool, min_nr, max_nr, alloc_fn, free_fn, pool_data,
>  			      gfp_mask, node_id)) {
>  		kfree(pool);
>  		return NULL;
> @@ -338,9 +339,8 @@ EXPORT_SYMBOL(mempool_create_node_noprof);
>   *              allocated for this pool.
>   *
>   * This function shrinks/grows the pool. In the case of growing,
> - * it cannot be guaranteed that the pool will be grown to the new
> - * size immediately, but new mempool_free() calls will refill it.
> - * This function may sleep.
> + * the pool will be grown to the new size immediately, but new mempool_free()
> + * calls will refill it.
>   *
>   * Note, the caller must guarantee that no mempool_destroy is called
>   * while this function is running. mempool_alloc() & mempool_free()
> @@ -351,11 +351,13 @@ EXPORT_SYMBOL(mempool_create_node_noprof);
>  int mempool_resize(struct mempool *pool, int new_min_nr)
>  {
>  	void *element;
> -	void **new_elements;
>  	unsigned long flags;
>  
> -	BUG_ON(new_min_nr <= 0);
> -	might_sleep();
> +	if (WARN_ON(new_min_nr < 0))
> +		return -EINVAL;
> +
> +	if (new_min_nr > pool->max_nr)
> +		return -ENOSPC;
>  
>  	spin_lock_irqsave(&pool->lock, flags);
>  	if (new_min_nr <= pool->min_nr) {
> @@ -366,45 +368,8 @@ int mempool_resize(struct mempool *pool, int new_min_nr)
>  			spin_lock_irqsave(&pool->lock, flags);
>  		}
>  		pool->min_nr = new_min_nr;
> -		goto out_unlock;
> -	}
> -	spin_unlock_irqrestore(&pool->lock, flags);
> -
> -	/* Grow the pool */
> -	new_elements = kmalloc_objs(*new_elements, new_min_nr);
> -	if (!new_elements)
> -		return -ENOMEM;
> -
> -	spin_lock_irqsave(&pool->lock, flags);
> -	if (unlikely(new_min_nr <= pool->min_nr)) {
> -		/* Raced, other resize will do our work */
> -		spin_unlock_irqrestore(&pool->lock, flags);
> -		kfree(new_elements);
> -		goto out;
> -	}
> -	memcpy(new_elements, pool->elements,
> -			pool->curr_nr * sizeof(*new_elements));
> -	kfree(pool->elements);
> -	pool->elements = new_elements;
> -	pool->min_nr = new_min_nr;
> -
> -	while (pool->curr_nr < pool->min_nr) {
> -		spin_unlock_irqrestore(&pool->lock, flags);
> -		element = pool->alloc(GFP_KERNEL, pool->pool_data);
> -		if (!element)
> -			goto out;
> -		spin_lock_irqsave(&pool->lock, flags);
> -		if (pool->curr_nr < pool->min_nr) {
> -			add_element(pool, element);
> -		} else {
> -			spin_unlock_irqrestore(&pool->lock, flags);
> -			pool->free(element, pool->pool_data);	/* Raced */
> -			goto out;
> -		}
>  	}
> -out_unlock:
>  	spin_unlock_irqrestore(&pool->lock, flags);
> -out:
>  	return 0;
>  }
>  EXPORT_SYMBOL(mempool_resize);


-- 
Damien Le Moal
Western Digital Research

