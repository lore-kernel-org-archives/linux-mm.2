Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A96CC5AD7B
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 00:20:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B9DF6B0096; Mon, 10 Aug 2026 20:20:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5974A6B0098; Mon, 10 Aug 2026 20:20:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A78A6B0099; Mon, 10 Aug 2026 20:20:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2D4AD6B0096
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 20:20:07 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CEDB41A02BB
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 00:20:06 +0000 (UTC)
X-FDA: 85087081212.19.C5A7C76
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 1BDC5140011
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 00:20:04 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MsvQaDP1;
	spf=pass (imf23.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786407605;
	b=BF9spZXFJCWZx/9+xTP4CTAV/7+x8GRBldAM8IGhdKH1bCAw8ceiNVKtxq3i/mFoiUtY4t
	z8AxscmTemOd4mOGb5IyNySdlL6uiE3njpHi0X/LOJnb2Cf8CVabEH76UpkPRyMcu2Nvi8
	kxgpL3CKp52sg3rDk0HUd49lqmcqDNQ=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MsvQaDP1;
	spf=pass (imf23.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786407605;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cryaumeVoeRHiTcn7Qll1wUbNn7JyWDDqdD+Hq0Hrec=;
	b=6M3dyCo98B4yTZ1FUlfxaVKsPLjZnQad4XBfmNnvcuP3yhqxt3lfEEbnihPQ9BZL+hrKpA
	aqJXQ3SAsOt64OnQuRjAbCjxPN7kjAKUKykAVadT/C+iqOODLoFILDsYhIGxh24ezUlKT/
	uhyKwDBrVIqVGOszcBJr6NhHRgdsSrw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4D2AD429D8;
	Tue, 11 Aug 2026 00:20:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E076F1F00A3D;
	Tue, 11 Aug 2026 00:20:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786407604;
	bh=cryaumeVoeRHiTcn7Qll1wUbNn7JyWDDqdD+Hq0Hrec=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MsvQaDP1RTtw8rHYgfjJUO/5UXJUveGiJDdFR7VhgB5+Y/GSwdqMxNqS3jnj4aD6y
	 5lYfDWchuwApdcE1z8Yl3FSB2xoIK8tprYuEGXj14Po8zF9eHtdNPoomWftT7hKlEi
	 ZWZP81lMM/CNkkyklotI3LlpqeqsqZgtT/PvPFYi+bF+mGGdQtg0J6I2qbLUG+PAre
	 s3aVoiRxeETlyLs0mGL8i867UMSSBW+klgiCbseFJ1r1fOZn1Qc5rgpVdqrR71+Glu
	 KaIJRjSYCOb5BFO8m9mRq9v9TLZJ2aOS4BQB7moZj0m9iGZQEt1rpbHPHAKr80zDmQ
	 uqf2bcCMWICEg==
Date: Tue, 11 Aug 2026 00:20:02 +0000
From: Yosry Ahmed <yosry@kernel.org>
To: Jianyue Wu <wujianyue000@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Johannes Weiner <hannes@cmpxchg.org>, Nhat Pham <nphamcs@gmail.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Chris Li <chrisl@kernel.org>
Subject: Re: [PATCH RFC v2 2/2] mm/zswap: reference the pool by index to
 shrink struct zswap_entry
Message-ID: <anpqSQ3dSpTgNPl0@google.com>
References: <20260731-shrink_zswap_entry_v2-0-0-v2-0-e72083aa8734@gmail.com>
 <20260731-shrink_zswap_entry_v2-0-0-v2-2-e72083aa8734@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260731-shrink_zswap_entry_v2-0-0-v2-2-e72083aa8734@gmail.com>
X-Rspamd-Queue-Id: 1BDC5140011
X-Stat-Signature: 9me9axhzw88z367p9nm4ywgzhbnp6uho
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1786407604-695338
X-HE-Meta: U2FsdGVkX18b9qIReehKTwiXaQJd2KlpNvgh3jSvwvhFscVkY7Yvyi+QSZKFD/U7C18Pla3LX8vJXCTyPdQfLP5S5s8zCV9BqSL3WTg6Z7wkxLg/FIhn7U+f9nfsNsxwyCwsUJm0G9itq1nXgxrwqJ3woCs6MDCczB27UQEe+P0BmSMnH93in3oH5Lz5Gd8xfDgUxQtwWnDik2pvwgdlRWQ5H7JhiIxb9M9b5Rzx96Eolz3zw3mbmucSzODcfh2Roscrfen1hCB/A5rTf1R+/6EHakwe/2MwPzzHo+EO4/akASlgdKxbYsT4/dFr50d1DQC2HYNR+DI6L0oHwrb4WZcm9FvxbV7oTauQ8oJ/p38Zs7fkxdt0RsDWndWshBgM/unl2XAASAOuU57E3mqhkvyVbx5Vx7MLwpEvmsT0FGGys+UcxaIZDVqgiATTyNcVFre3VI8yoXNfnjwBjp4iReITXC8Zu8Ryb6bvkU/DkV/xB8R2pWlR7XjSxSShWpObZyiCPWnnU9YrdM/2irz9kyDnbGhDLiUw0e0rLwppgctUnr23XRp1xNCJlxIIVRlw1Nd06fsK3lrzeYHpnQ4ykLBR2EpWbAeIPWgNVClkQ/9nD9xC87mG08qSsuvP8pGbCK9yBD/cKue3xx9DKTfvWwwfviCuz3ap2zgxKKZ1DM0M2bnvrCO6ktDlXZtIBmenHgIaA512Ke9ecr4/9MBZJdc6V/ZFXfyMmrK7RCJxQ4GpVecUywjBOLtqX1jM2MbgxF1wA9obhsGqS8dn3vEy7BIGYKppqCMI8JdZxb+xjV8UMk60QC566eUIlLfT968RCxp5MirCFXyndRzn5YjWW0W6Upg1yYcNNhOdLJaN0HBlbDwcIkc5Yof3q4PcWBNw6GlnYbg0iE7Qac8f8Ptj2fYcZppkAb8YkPs0RTx/Wp2qzHV0AXu8HB87LVGNSGmLM7B6HVPgz7gmU1aJHnH
 8It56jbC
 8Rye0qSYsSVeIS9uY8yWO67a7rmUchWGLHyYTtgp/P5QcM7t0QY7d+dg6dEFz7WqNWjaB/tezjP6c4/fp6w7C7T0QcY5iG1Tk8okRL1fFplsqCRmeEbbdDbtmNhlCCk9IIRUSU3+11OqSWyAEt6v30cigi4gmaUBRZB7372ynUA03qp8sLiZVf0IqDrE2X5Tm6eLoSebs2KMKdyxNPrGe0qt9ZwVYzAcBq9vMTafWpuwIZDYJhuW/XSr1YescqkRIzYUzky9GvvVHn8fH0bD/isa2luWUR1Xm/tgoCjrLlQLwqVUu7I5/fNMXMvwmALZxSNyFJfdEvN+zr6p6G2O2+Oh4Cg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 31, 2026 at 08:32:48AM +0800, Jianyue Wu wrote:
> struct zswap_entry is one allocation per stored page, so its size is pure
> overhead.  It currently embeds an 8-byte pool pointer, even though the
> live pools now sit in a small fixed array indexed by a u8 slot number.
> 
> Replace the per-entry pool pointer with that u8 slot index and resolve it
> through a zswap_entry_pool() helper.  A live entry holds a reference to
> its pool, so the slot cannot be reused under it; the lookup therefore
> needs no RCU read-side section (rcu_dereference_protected(..., true)).
> 
> The u8 fits in the padding after the bool referenced field, shrinking the
> entry from 56 to 48 bytes on x86_64.  This raises objs_per_slab from 73
> to 85 and saves about 2MiB of metadata per 1GiB of data held in zswap.
> 
> Suggested-by: Chris Li <chrisl@kernel.org>
> Signed-off-by: Jianyue Wu <wujianyue000@gmail.com>
> ---
>  mm/zswap.c | 33 +++++++++++++++++++++++++--------
>  1 file changed, 25 insertions(+), 8 deletions(-)
> 
> diff --git a/mm/zswap.c b/mm/zswap.c
> index b203934d3be8..d4f4db2999f2 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -190,7 +190,7 @@ static struct shrinker *zswap_shrinker;
>   *              writeback logic. The entry is only reclaimed by the writeback
>   *              logic if referenced is unset. See comments in the shrinker
>   *              section for context.
> - * pool - the zswap_pool the entry's data is in
> + * pool_idx - slot of the zswap_pool that the entry's data is in.
>   * handle - zsmalloc allocation handle that stores the compressed page data
>   * objcg - the obj_cgroup that the compressed memory is charged to
>   * lru - handle to the pool's lru used to evict pages.
> @@ -199,12 +199,22 @@ struct zswap_entry {
>  	swp_entry_t swpentry;
>  	unsigned int length;
>  	bool referenced;
> -	struct zswap_pool *pool;
> +	u8 pool_idx;
>  	unsigned long handle;
>  	struct obj_cgroup *objcg;
>  	struct list_head lru;
>  };
>  
> +static struct zswap_pool *zswap_entry_pool(struct zswap_entry *entry)
> +{
> +	/*
> +	 * A live entry holds a reference to its pool, so the slot cannot be
> +	 * cleared or reused under it.  This is not an RCU read-side walk.
> +	 */
> +	return rcu_dereference_protected(zswap_pools[entry->pool_idx],
> +					 true /* entry pins pool */);

Probably doesn't matter in practice, but maybe entry->handle or
something instead of 'true' to make it clear we are checking for an
"active" entry?

> +}
> +
>  static struct xarray *zswap_trees[MAX_SWAPFILES];
>  static unsigned int nr_zswap_trees[MAX_SWAPFILES];
>  
> @@ -807,9 +817,13 @@ static void zswap_entry_cache_free(struct zswap_entry *entry)
>   */
>  static void zswap_entry_free(struct zswap_entry *entry)
>  {
> +	struct zswap_pool *pool = zswap_entry_pool(entry);
> +
>  	zswap_lru_del(&zswap_list_lru, entry);
> -	zs_free(entry->pool->zs_pool, entry->handle);
> -	zswap_pool_put(entry->pool);
> +	if (!WARN_ON_ONCE(!pool)) {
> +		zs_free(pool->zs_pool, entry->handle);
> +		zswap_pool_put(pool);
> +	}
>  	if (entry->objcg) {
>  		obj_cgroup_uncharge_zswap(entry->objcg, entry->length);
>  		obj_cgroup_put(entry->objcg);
> @@ -966,12 +980,15 @@ static bool zswap_compress(struct page *page, struct zswap_entry *entry,
>  
>  static bool zswap_decompress(struct zswap_entry *entry, struct folio *folio)
>  {
> -	struct zswap_pool *pool = entry->pool;
> +	struct zswap_pool *pool = zswap_entry_pool(entry);
>  	struct scatterlist input[2]; /* zsmalloc returns an SG list 1-2 entries */
>  	struct scatterlist output;
>  	struct crypto_acomp_ctx *acomp_ctx;
>  	int ret = 0, dlen;
>  
> +	if (WARN_ON_ONCE(!pool))
> +		return false;
> +
>  	acomp_ctx = raw_cpu_ptr(pool->acomp_ctx);
>  	mutex_lock(&acomp_ctx->mutex);
>  	zs_obj_read_sg_begin(pool->zs_pool, entry->handle, input, entry->length);
> @@ -1007,7 +1024,7 @@ static bool zswap_decompress(struct zswap_entry *entry, struct folio *folio)
>  	pr_alert_ratelimited("Decompression error from zswap (%d:%lu %s %u->%d)\n",
>  						swp_type(entry->swpentry),
>  						swp_offset(entry->swpentry),
> -						entry->pool->tfm_name,
> +						pool->tfm_name,
>  						entry->length, dlen);
>  	return false;
>  }
> @@ -1500,7 +1517,7 @@ static bool zswap_store_page(struct page *page,
>  	 *    The publishing order matters to prevent writeback from seeing
>  	 *    an incoherent entry.
>  	 */
> -	entry->pool = pool;
> +	entry->pool_idx = pool->idx;
>  	entry->swpentry = page_swpentry;
>  	entry->objcg = objcg;
>  	entry->referenced = true;
> @@ -1806,7 +1823,7 @@ static int zswap_setup(void)
>  	struct zswap_pool *pool;
>  	int ret;
>  
> -	/* Slot indices are stored in a u8 (pool->idx). */
> +	/* Slot indices are stored in a u8 (pool->idx and entry->pool_idx). */
>  	BUILD_BUG_ON(ZSWAP_MAX_POOLS - 1 > U8_MAX);
>  
>  	zswap_entry_cache = KMEM_CACHE(zswap_entry, 0);
> 
> -- 
> 2.43.0
> 

