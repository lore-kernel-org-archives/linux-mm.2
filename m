Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E297CD98D2
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 20:24:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A88C8E0009; Thu, 13 Nov 2025 15:24:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 880028E0003; Thu, 13 Nov 2025 15:24:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 795BA8E0009; Thu, 13 Nov 2025 15:24:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 646918E0003
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 15:24:39 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 027B912C276
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 20:24:38 +0000 (UTC)
X-FDA: 84106711878.09.08096CC
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	by imf02.hostedemail.com (Postfix) with ESMTP id 1283980011
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 20:24:36 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xqfxIfOF;
	spf=pass (imf02.hostedemail.com: domain of yosry.ahmed@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763065477;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jT/ew4lyAZdjduPWOHcjteBKICf50dJTobZNEHLjS+A=;
	b=XHFmerjmWFJZSqhEXJd7K9QUC5N0pMLXeezr8NNnJ7YV55v2FVs4sHhx4/IwrzjlQGIcwY
	q4pssqEruMvM/MH1ux3ouj5ROUX7vIjDnV4BOSilK+G/WGQyQviAt6d5mTzwRi52JpvJWY
	I8wmb4fItR8VJ6DUkr8qWi7eOyeVwl0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763065477; a=rsa-sha256;
	cv=none;
	b=iyLcQWkv3D8A5IqxyioXqMhHUeM/jzu/AI+atrFbOdGyTwCQY7BrDZveBdFC7Ta8Tb6/ZX
	E2SB8GTnHdAk9boCIbdubVpGHminGELi5YtJz24Me6pXCC5o9Jo6p/2ICoijutwePGjtfy
	aen3JeaeHcJRa3Xq4XJriN9oqEwJEL0=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xqfxIfOF;
	spf=pass (imf02.hostedemail.com: domain of yosry.ahmed@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Thu, 13 Nov 2025 20:24:23 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1763065473;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jT/ew4lyAZdjduPWOHcjteBKICf50dJTobZNEHLjS+A=;
	b=xqfxIfOFHqlzr4bODDqrWDXl7d/V2JzDrkJAG4mfkCMBnhYeRFqhwKuPehPQpRLWMRclII
	7R4a9RIYL/T32vumS+yVYWmSGtn7QM2CwNMi5RQqY0u47JIOV75F59VN6lZXt+/m5ha1Rx
	8rrmNCD7B6LUgs0MY862IxYraVu/2jo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, hannes@cmpxchg.org, 
	nphamcs@gmail.com, chengming.zhou@linux.dev, usamaarif642@gmail.com, 
	ryan.roberts@arm.com, 21cnbao@gmail.com, ying.huang@linux.alibaba.com, 
	akpm@linux-foundation.org, senozhatsky@chromium.org, sj@kernel.org, kasong@tencent.com, 
	linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au, davem@davemloft.net, 
	clabbe@baylibre.com, ardb@kernel.org, ebiggers@google.com, surenb@google.com, 
	kristen.c.accardi@intel.com, vinicius.gomes@intel.com, wajdi.k.feghali@intel.com, 
	vinodh.gopal@intel.com
Subject: Re: [PATCH v13 19/22] mm: zswap: Per-CPU acomp_ctx resources exist
 from pool creation to deletion.
Message-ID: <yf2obwzmjxg4iu2j3u5kkhruailheld4uodqsfcheeyvh3rdm7@w7mhranpcsgr>
References: <20251104091235.8793-1-kanchana.p.sridhar@intel.com>
 <20251104091235.8793-20-kanchana.p.sridhar@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251104091235.8793-20-kanchana.p.sridhar@intel.com>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: fnk9xbndi5h6e86qhbmraf6foun5ke8o
X-Rspam-User: 
X-Rspamd-Queue-Id: 1283980011
X-Rspamd-Server: rspam01
X-HE-Tag: 1763065476-55539
X-HE-Meta: U2FsdGVkX1/OqKYwvGTBJ+5vuNCUxzhVeqnD/by0UaLkC2PvRM4IpN+5VwpqmMIpEpaBfLMJcek1Ek99j+oZ6mmDgXy7RjIamhgSjbEY73NwHcWHVizz3vuoEDpmM6D6ls6i3jLNejsoyzdiwrzOwt/rUgFuC4qN4AGtOWtPbTCRQjzKhw28EuCkUxbb8RcRJ43p3JyfRhNWdvSy9mWa8qzvmohtI2ihxh3IEMDJIzC3yKPRkYvLLf9dFTDfDoHpfQ00DVI0Vo5dcLyIKQya6wjiYs0IANZXb+7GjxaZIUp170L5fdRQkJBUFECsw0ic+rQa5BTEcPgMiQgiqnq0TtW96qfRUFSiWUbm9DJcYGhN2pZvoz5f2F34GpF2UGfn04Ku9JNNCRYUcfEvjJZ1sAkQoPM/zshXT01PYMalrJIp/uiQRgFHrxV9WPQSKBD7jx0SIY/jGF70a01o6w6rhFJQqcfKnjBkE0WksNLHkmDeZhYHpNX7JIGtrqrFE8DJGQKdGJsMd15b3geSJPxw8h8GNbR4jyz2BFeDJNZElzcIg8nkCyewh+Lbnyia8x9vJprScG+ApTFXIyiJmF6NO8qYE6n8oE+ou0pXWsfAXDvYXb+6G+nKJ7cyrDfjGZZKDqCExmebHFsYbfVNPUDgwJreVHboI482AorB6VDE6pOy67Nvgj3sVd298/53cjS+bt678UGrwoLXvZ8P8LsBcjhCB3dA8dRM1QhafCvsPjknfjh7dHze9UnjmCW23SrKCe6uPFR7pLlCCs6zSo2MXohN+5DANX9ITprgK+BTGiPh+W5RuWcHAO6zgTSNpsOm10Qs/Jpk7VUa5TE1lpqOQN+umXfSNqIAoTmdKTeM/GoLhiFUQaAgw0KLmFqlMWzQwhxi2lxeMMGz96xKwc6Ar2OHGWdfDZIqr2fFV2Yc42gFIAOayel3/YNpmrKNtJjp3Jea+5M7dKXsWmIzf9P
 Lz9EiKPh
 xtkxicGXzq35ZXcSRwgPD/LCSt0mrFCn3bC+WC3Hc5wttoX6XjEumHTIocWNN/VnogQzSgVqX297MfjPtTE9+3uUurytQYTIxPivn9BN3BexMI4jkT82XM6qGrJtAukfOZPtGWN4RSV7MvPynsfl7mcBz3S0QUoLjqeiaUFVOd4EOZfF8aVr1C++xMD6JQxFuhiTOGmbPK8ZEi/WuAY2wp0fyTr1ARawDhfjlb31W+N9dPWI+xmxYtr/aFDw+/xotfkOzfO3cHTQ0hKIzFq90z0LHnuIDHr/ZO7/kX9TLnDAO9OTRcbQndrlw9MBzxOTb03EI
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 04, 2025 at 01:12:32AM -0800, Kanchana P Sridhar wrote:

The subject can be shortened to:

"mm: zswap: Tie per-CPU acomp_ctx lifetime to the pool"

> This patch simplifies the zswap_pool's per-CPU acomp_ctx resource
> management. Similar to the per-CPU acomp_ctx itself, the per-CPU
> acomp_ctx's resources' (acomp, req, buffer) lifetime will also be from
> pool creation to pool deletion. These resources will persist through CPU
> hotplug operations instead of being destroyed/recreated. The
> zswap_cpu_comp_dead() teardown callback has been deleted from the call
> to cpuhp_setup_state_multi(CPUHP_MM_ZSWP_POOL_PREPARE). As a result, CPU
> offline hotplug operations will be no-ops as far as the acomp_ctx
> resources are concerned.

Currently, per-CPU acomp_ctx are allocated on pool creation and/or CPU
hotplug, and destroyed on pool destruction or CPU hotunplug. This
complicates the lifetime management to save memory while a CPU is
offlined, which is not very common.

Simplify lifetime management by allocating per-CPU acomp_ctx once on
pool creation (or CPU hotplug for CPUs onlined later), and keeping them
allocated until the pool is destroyed.

> 
> This commit refactors the code from zswap_cpu_comp_dead() into a
> new function acomp_ctx_dealloc() that is called to clean up acomp_ctx
> resources from:
> 
> 1) zswap_cpu_comp_prepare() when an error is encountered,
> 2) zswap_pool_create() when an error is encountered, and
> 3) from zswap_pool_destroy().


Refactor cleanup code from zswap_cpu_comp_dead() into
acomp_ctx_dealloc() to be used elsewhere.

> 
> The main benefit of using the CPU hotplug multi state instance startup
> callback to allocate the acomp_ctx resources is that it prevents the
> cores from being offlined until the multi state instance addition call
> returns.
> 
>   From Documentation/core-api/cpu_hotplug.rst:
> 
>     "The node list add/remove operations and the callback invocations are
>      serialized against CPU hotplug operations."
> 
> Furthermore, zswap_[de]compress() cannot contend with
> zswap_cpu_comp_prepare() because:
> 
>   - During pool creation/deletion, the pool is not in the zswap_pools
>     list.
> 
>   - During CPU hot[un]plug, the CPU is not yet online, as Yosry pointed
>     out. zswap_cpu_comp_prepare() will be run on a control CPU,
>     since CPUHP_MM_ZSWP_POOL_PREPARE is in the PREPARE section of "enum
>     cpuhp_state". Thanks Yosry for sharing this observation!
> 
>   In both these cases, any recursions into zswap reclaim from
>   zswap_cpu_comp_prepare() will be handled by the old pool.
> 
> The above two observations enable the following simplifications:
> 
>  1) zswap_cpu_comp_prepare(): CPU cannot be offlined. Reclaim cannot use
>     the pool. Considerations for mutex init/locking and handling
>     subsequent CPU hotplug online-offline-online:
> 
>     Should we lock the mutex of current CPU's acomp_ctx from start to
>     end? It doesn't seem like this is required. The CPU hotplug
>     operations acquire a "cpuhp_state_mutex" before proceeding, hence
>     they are serialized against CPU hotplug operations.
> 
>     If the process gets migrated while zswap_cpu_comp_prepare() is
>     running, it will complete on the new CPU. In case of failures, we
>     pass the acomp_ctx pointer obtained at the start of
>     zswap_cpu_comp_prepare() to acomp_ctx_dealloc(), which again, can
>     only undergo migration. There appear to be no contention scenarios
>     that might cause inconsistent values of acomp_ctx's members. Hence,
>     it seems there is no need for mutex_lock(&acomp_ctx->mutex) in
>     zswap_cpu_comp_prepare().
> 
>     Since the pool is not yet on zswap_pools list, we don't need to
>     initialize the per-CPU acomp_ctx mutex in zswap_pool_create(). This
>     has been restored to occur in zswap_cpu_comp_prepare().
> 
>     zswap_cpu_comp_prepare() checks upfront if acomp_ctx->acomp is
>     valid. If so, it returns success. This should handle any CPU
>     hotplug online-offline transitions after pool creation is done.
> 
>  2) CPU offline vis-a-vis zswap ops: Let's suppose the process is
>     migrated to another CPU before the current CPU is dysfunctional. If
>     zswap_[de]compress() holds the acomp_ctx->mutex lock of the offlined
>     CPU, that mutex will be released once it completes on the new
>     CPU. Since there is no teardown callback, there is no possibility of
>     UAF.
> 
>  3) Pool creation/deletion and process migration to another CPU:
> 
>     - During pool creation/deletion, the pool is not in the zswap_pools
>       list. Hence it cannot contend with zswap ops on that CPU. However,
>       the process can get migrated.
> 
>       Pool creation --> zswap_cpu_comp_prepare()
>                                 --> process migrated:
>                                     * CPU offline: no-op.
>                                     * zswap_cpu_comp_prepare() continues
>                                       to run on the new CPU to finish
>                                       allocating acomp_ctx resources for
>                                       the offlined CPU.
> 
>       Pool deletion --> acomp_ctx_dealloc()
>                                 --> process migrated:
>                                     * CPU offline: no-op.
>                                     * acomp_ctx_dealloc() continues
>                                       to run on the new CPU to finish
>                                       de-allocating acomp_ctx resources
>                                       for the offlined CPU.
> 
>  4) Pool deletion vis-a-vis CPU onlining:
>     The call to cpuhp_state_remove_instance() cannot race with
>     zswap_cpu_comp_prepare() because of hotplug synchronization.
> 
> This patch deletes acomp_ctx_get_cpu_lock()/acomp_ctx_put_unlock().
> Instead, zswap_[de]compress() directly call
> mutex_[un]lock(&acomp_ctx->mutex).

I am not sure why all of this is needed. We should just describe why
it's safe to drop holding the mutex while initializing per-CPU
acomp_ctx:

It is no longer possible for CPU hotplug to race against allocation or
usage of per-CPU acomp_ctx, as they are only allocated once before the
pool can be used, and remain allocated as long as the pool is used.
Hence, stop holding the lock during acomp_ctx initialization, and drop
acomp_ctx_get_cpu_lock()//acomp_ctx_put_unlock().

> 
> The per-CPU memory cost of not deleting the acomp_ctx resources upon CPU
> offlining, and only deleting them when the pool is destroyed, is as
> follows, on x86_64:
> 
>     IAA with 8 dst buffers for batching:    64.34 KB
>     Software compressors with 1 dst buffer:  8.28 KB

This cost is only paid when a CPU is offlined, until it is onlined
again.

> 
> Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
> ---
>  mm/zswap.c | 164 +++++++++++++++++++++--------------------------------
>  1 file changed, 64 insertions(+), 100 deletions(-)
> 
> diff --git a/mm/zswap.c b/mm/zswap.c
> index 4897ed689b9f..87d50786f61f 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -242,6 +242,20 @@ static inline struct xarray *swap_zswap_tree(swp_entry_t swp)
>  **********************************/
>  static void __zswap_pool_empty(struct percpu_ref *ref);
>  
> +static void acomp_ctx_dealloc(struct crypto_acomp_ctx *acomp_ctx)
> +{
> +	if (IS_ERR_OR_NULL(acomp_ctx))
> +		return;
> +
> +	if (!IS_ERR_OR_NULL(acomp_ctx->req))
> +		acomp_request_free(acomp_ctx->req);
> +
> +	if (!IS_ERR_OR_NULL(acomp_ctx->acomp))
> +		crypto_free_acomp(acomp_ctx->acomp);
> +
> +	kfree(acomp_ctx->buffer);
> +}
> +
>  static struct zswap_pool *zswap_pool_create(char *compressor)
>  {
>  	struct zswap_pool *pool;
> @@ -263,19 +277,26 @@ static struct zswap_pool *zswap_pool_create(char *compressor)
>  
>  	strscpy(pool->tfm_name, compressor, sizeof(pool->tfm_name));
>  
> -	pool->acomp_ctx = alloc_percpu(*pool->acomp_ctx);
> +	/* Many things rely on the zero-initialization. */
> +	pool->acomp_ctx = alloc_percpu_gfp(*pool->acomp_ctx,
> +					   GFP_KERNEL | __GFP_ZERO);
>  	if (!pool->acomp_ctx) {
>  		pr_err("percpu alloc failed\n");
>  		goto error;
>  	}
>  
> -	for_each_possible_cpu(cpu)
> -		mutex_init(&per_cpu_ptr(pool->acomp_ctx, cpu)->mutex);
> -
> +	/*
> +	 * This is serialized against CPU hotplug operations. Hence, cores
> +	 * cannot be offlined until this finishes.
> +	 * In case of errors, we need to goto "ref_fail" instead of "error"
> +	 * because there is no teardown callback registered anymore, for
> +	 * cpuhp_state_add_instance() to de-allocate resources as it rolls back
> +	 * state on cores before the CPU on which error was encountered.
> +	 */

Do we need to manually call acomp_ctx_dealloc() on each CPU on failure
because cpuhp_state_add_instance() relies on the hotunplug callback for
cleanup, and we don't have any?

If that's the case:

	/*
	 * cpuhp_state_add_instance() will not cleanup on failure since
	 * we don't register a hotunplug callback.
	 */

Describing what the code does is not helpful, and things like "anymore"
do not make sense once the code is merged.

>  	ret = cpuhp_state_add_instance(CPUHP_MM_ZSWP_POOL_PREPARE,
>  				       &pool->node);
>  	if (ret)
> -		goto error;
> +		goto ref_fail;

IIUC we shouldn't call cpuhp_state_remove_instance() on failure, we
probably should add a new label.

>  
>  	/* being the current pool takes 1 ref; this func expects the
>  	 * caller to always add the new pool as the current pool
> @@ -292,6 +313,9 @@ static struct zswap_pool *zswap_pool_create(char *compressor)
>  
>  ref_fail:
>  	cpuhp_state_remove_instance(CPUHP_MM_ZSWP_POOL_PREPARE, &pool->node);
> +
> +	for_each_possible_cpu(cpu)
> +		acomp_ctx_dealloc(per_cpu_ptr(pool->acomp_ctx, cpu));
>  error:
>  	if (pool->acomp_ctx)
>  		free_percpu(pool->acomp_ctx);
> @@ -322,9 +346,15 @@ static struct zswap_pool *__zswap_pool_create_fallback(void)
>  
>  static void zswap_pool_destroy(struct zswap_pool *pool)
>  {
> +	int cpu;
> +
>  	zswap_pool_debug("destroying", pool);
>  
>  	cpuhp_state_remove_instance(CPUHP_MM_ZSWP_POOL_PREPARE, &pool->node);
> +
> +	for_each_possible_cpu(cpu)
> +		acomp_ctx_dealloc(per_cpu_ptr(pool->acomp_ctx, cpu));
> +
>  	free_percpu(pool->acomp_ctx);
>  
>  	zs_destroy_pool(pool->zs_pool);
> @@ -736,39 +766,35 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
>  {
>  	struct zswap_pool *pool = hlist_entry(node, struct zswap_pool, node);
>  	struct crypto_acomp_ctx *acomp_ctx = per_cpu_ptr(pool->acomp_ctx, cpu);
> -	struct crypto_acomp *acomp = NULL;
> -	struct acomp_req *req = NULL;
> -	u8 *buffer = NULL;
> -	int ret;
> +	int ret = -ENOMEM;
>  
> -	buffer = kmalloc_node(PAGE_SIZE, GFP_KERNEL, cpu_to_node(cpu));
> -	if (!buffer) {
> -		ret = -ENOMEM;
> -		goto fail;
> -	}
> +	/*
> +	 * To handle cases where the CPU goes through online-offline-online
> +	 * transitions, we return if the acomp_ctx has already been initialized.
> +	 */
> +	if (!IS_ERR_OR_NULL(acomp_ctx->acomp))
> +		return 0;

Is it possible for acomp_ctx->acomp to be an ERR value here? If it is,
then zswap initialization should have failed. Maybe WARN_ON_ONCE() for
that case?

>  
> -	acomp = crypto_alloc_acomp_node(pool->tfm_name, 0, 0, cpu_to_node(cpu));
> -	if (IS_ERR(acomp)) {
> +	acomp_ctx->buffer = kmalloc_node(PAGE_SIZE, GFP_KERNEL, cpu_to_node(cpu));
> +	if (!acomp_ctx->buffer)
> +		return ret;
> +
> +	acomp_ctx->acomp = crypto_alloc_acomp_node(pool->tfm_name, 0, 0, cpu_to_node(cpu));
> +	if (IS_ERR(acomp_ctx->acomp)) {
>  		pr_err("could not alloc crypto acomp %s : %ld\n",
> -				pool->tfm_name, PTR_ERR(acomp));
> -		ret = PTR_ERR(acomp);
> +				pool->tfm_name, PTR_ERR(acomp_ctx->acomp));
> +		ret = PTR_ERR(acomp_ctx->acomp);
>  		goto fail;
>  	}
> +	acomp_ctx->is_sleepable = acomp_is_async(acomp_ctx->acomp);
>  
> -	req = acomp_request_alloc(acomp);
> -	if (!req) {
> +	acomp_ctx->req = acomp_request_alloc(acomp_ctx->acomp);
> +	if (!acomp_ctx->req) {
>  		pr_err("could not alloc crypto acomp_request %s\n",
>  		       pool->tfm_name);
> -		ret = -ENOMEM;
>  		goto fail;
>  	}
>  
> -	/*
> -	 * Only hold the mutex after completing allocations, otherwise we may
> -	 * recurse into zswap through reclaim and attempt to hold the mutex
> -	 * again resulting in a deadlock.
> -	 */
> -	mutex_lock(&acomp_ctx->mutex);
>  	crypto_init_wait(&acomp_ctx->wait);
>  
>  	/*
[..]

