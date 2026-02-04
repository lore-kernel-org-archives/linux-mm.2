Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8672E9D40C
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 16:29:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3BC066B0098; Wed,  4 Feb 2026 11:29:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 37D226B009F; Wed,  4 Feb 2026 11:29:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2BE606B00A0; Wed,  4 Feb 2026 11:29:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 18EE66B0098
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 11:29:51 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C8D761A016D
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 16:29:50 +0000 (UTC)
X-FDA: 84407310540.16.2FC87E2
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	by imf19.hostedemail.com (Postfix) with ESMTP id 22CF01A000D
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 16:29:46 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DMV7DUMR;
	spf=pass (imf19.hostedemail.com: domain of yosry.ahmed@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770222589;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8qYvx1GtYjCClxfbUTV01lztTzcb1Hb83ur4kPsDPBs=;
	b=tbk/MrS1xXAXdld5JVrKTyyd6Ov1y/dREiM2KI0+bUYkrKdYp/mk91zJpCzUU3ldIgfHMC
	/2qskOZFyYhIcVw+qVee5LNydA6utiL2ImL1GE/eWy696b2AUjomugVej2ujEZhotMQpkF
	WKzWo7M/+S4GZRtkBiFKi6TUUq9exj0=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DMV7DUMR;
	spf=pass (imf19.hostedemail.com: domain of yosry.ahmed@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770222589; a=rsa-sha256;
	cv=none;
	b=hOa/hFIEPg6XblC0qrmI01xiMPyCdjUqGw1brJOmqg/zIEsypiBYzu/ZORvd+1s9bgWY6d
	RiofXfernMree/XOrzdgcG6zl8BgCp12yhtBEDhhnyCXZ1p4mNZpC6RltKbZWurBvZ2ZHR
	rYnzMN8/VuysHHH1cZOYIQuqQm+BUIY=
Date: Wed, 4 Feb 2026 16:29:35 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770222584;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8qYvx1GtYjCClxfbUTV01lztTzcb1Hb83ur4kPsDPBs=;
	b=DMV7DUMRAR7z/0AH16wZgLQPi2ssnlRKa67c7Jj0+sLwmS/ztdKIisnHaXgi2IuH18V+26
	PvG8SeWVJkESaqw61Jc2oAk5ZVJEh7gR4TA9c9bBrqfAeQE10ekHT5iNkw38OdejkonMqW
	I+gVQCu1/7bsfyjKwd0gkhnfu2SV0wg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, hannes@cmpxchg.org, 
	nphamcs@gmail.com, chengming.zhou@linux.dev, usamaarif642@gmail.com, 
	ryan.roberts@arm.com, 21cnbao@gmail.com, ying.huang@linux.alibaba.com, 
	akpm@linux-foundation.org, senozhatsky@chromium.org, sj@kernel.org, kasong@tencent.com, 
	linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au, davem@davemloft.net, 
	clabbe@baylibre.com, ardb@kernel.org, ebiggers@google.com, surenb@google.com, 
	kristen.c.accardi@intel.com, vinicius.gomes@intel.com, giovanni.cabiddu@intel.com, 
	wajdi.k.feghali@intel.com
Subject: Re: [PATCH v14 23/26] mm: zswap: Tie per-CPU acomp_ctx lifetime to
 the pool.
Message-ID: <ipuhkh3rrc6kt4d4dpkbvdngjle4qppjj3oalcffuhkh4cujya@it4u23a4sm3k>
References: <20260125033537.334628-1-kanchana.p.sridhar@intel.com>
 <20260125033537.334628-24-kanchana.p.sridhar@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260125033537.334628-24-kanchana.p.sridhar@intel.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 22CF01A000D
X-Stat-Signature: 6367hcempo38sfeh5k3nc1xegi8eyc1j
X-Rspam-User: 
X-HE-Tag: 1770222586-920265
X-HE-Meta: U2FsdGVkX19n6/JAFmYNf7palLWi0mh1BpO05icneU2sH6r2zo8W4tdw/WZ9YJ/twV7usLylh0V8iK+SLIp4kCrAQ1NdKpmSqraJ38sqB6GW/fsxDwwzJC2CDM4DMHC5Ocj38xCotkf5n3fxEbdsW/w0Fm14vcUM+Wo4zAgkDVgz8pK/0K63Vuj5ntIcqj3DO/ezIfKvApz+ZKD0MzrT8APUhQbNM/e7AH4aSxz78Xhalhf2nEa0EyFvBGeshGo0m5ld1XZ6AJubcBQpH9R4U1tTwjcAPbl5EKz3yRvJO3H2JV/Q+MMd5fegDpl0GOvDeveOWop+shoFk0LjcUfR7JE312IFQvhDZNutv+7TTQtUMUHP5F2PMhT12j1tpEkJyVEuyc+yHPOzWnZ959HDgBD6MnxygQ/XYlzIWf0bRAcW8AStOfDAc1OBPkb0ocYetZfvaaWd5qJXruPirR7boVDZ3VbNusoxPi4gaIEIAoi2OvdPNbLJ75CWJ18n7JYrTbWLog6S0OMAaX2IjWLwYb2dKxAeGWHFLwXIJbml2gZiLbN368WoNFmnb8Gzs3++KkUety8Otvt8GblrQuuxJ3454fqswfQcFdZ48t7kBGZvQm0PZ/bL96q8a8OUdtwgxVW3WG41pFdZd8+OjJbzQ1X1CJSK0L9j8P93Ac6+fAphmdFf5SH4vrDrOyY0yP5KOgLZN3/+mfaOhb+k7QdKhKhWarBdTeBWIWIMHd/sSy3kauTSzJOk/BJCzCaTl64zCpIz6v7EL5RMpWTUhXcssIBB2oD4gd7O4OV/PK5kOrG1tK4kNj56tNbq6w1TSdkbvgjL3krrcwo4QhtYbLe0T8FUZ0SATBYJGPL4aHE8uS8VTawtCOSFK4s1XkFnk8kECbDhAJD+9lhhODTyTZa0YjCF+YRKBH6ON057qah5WsSd1dvt3wOeWYxCUgW9fLmCUsIZxR0Lt3fFr/uGOHT
 YVnIZNU3
 SfyJsUKrAT5o7g35oUjle0bHfByFhjdRnnXRHQGYB2SFwiscZK5A4m4z+IfWi0J4cKuwpNE8sJmIaEyMHjrmd7RL4JzZQ0CTLpFS8r9uzbBLF3d5m7GFLzmbel7NrDmHRIlbIVCupz2xkOmYhoy4SSxHF25D+iL9Cjo2npOIdQn4NB6gyl2EumROEx2PpTBi8bn6T8qIE4JHsfQNm959tVr3F+8tehvkBdsHgksprHuCfzCJJtBYjYevi5qJkzMpYRtjJjHGBJAmPmd6XJDYrUurz9Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jan 24, 2026 at 07:35:34PM -0800, Kanchana P Sridhar wrote:
> Currently, per-CPU acomp_ctx are allocated on pool creation and/or CPU
> hotplug, and destroyed on pool destruction or CPU hotunplug. This
> complicates the lifetime management to save memory while a CPU is
> offlined, which is not very common.
> 
> Simplify lifetime management by allocating per-CPU acomp_ctx once on
> pool creation (or CPU hotplug for CPUs onlined later), and keeping them
> allocated until the pool is destroyed.
> 
> Refactor cleanup code from zswap_cpu_comp_dead() into
> acomp_ctx_dealloc() to be used elsewhere.
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
>     cpuhp_state".
> 
>   In both these cases, any recursions into zswap reclaim from
>   zswap_cpu_comp_prepare() will be handled by the old pool.
> 
> The above two observations enable the following simplifications:
> 
>  1) zswap_cpu_comp_prepare():
> 
>     a) acomp_ctx mutex locking:
> 
>        If the process gets migrated while zswap_cpu_comp_prepare() is
>        running, it will complete on the new CPU. In case of failures, we
>        pass the acomp_ctx pointer obtained at the start of
>        zswap_cpu_comp_prepare() to acomp_ctx_dealloc(), which again, can
>        only undergo migration. There appear to be no contention
>        scenarios that might cause inconsistent values of acomp_ctx's
>        members. Hence, it seems there is no need for
>        mutex_lock(&acomp_ctx->mutex) in zswap_cpu_comp_prepare().
> 
>     b) acomp_ctx mutex initialization:
> 
>        Since the pool is not yet on zswap_pools list, we don't need to
>        initialize the per-CPU acomp_ctx mutex in
>        zswap_pool_create(). This has been restored to occur in
>        zswap_cpu_comp_prepare().
> 
>     c) Subsequent CPU offline-online transitions:
> 
>        zswap_cpu_comp_prepare() checks upfront if acomp_ctx->acomp is
>        valid. If so, it returns success. This should handle any CPU
>        hotplug online-offline transitions after pool creation is done.
> 
>  2) CPU offline vis-a-vis zswap ops:
> 
>     Let's suppose the process is migrated to another CPU before the
>     current CPU is dysfunctional. If zswap_[de]compress() holds the
>     acomp_ctx->mutex lock of the offlined CPU, that mutex will be
>     released once it completes on the new CPU. Since there is no
>     teardown callback, there is no possibility of UAF.
> 
>  3) Pool creation/deletion and process migration to another CPU:
> 
>     During pool creation/deletion, the pool is not in the zswap_pools
>     list. Hence it cannot contend with zswap ops on that CPU. However,
>     the process can get migrated.
> 
>     a) Pool creation --> zswap_cpu_comp_prepare()
>                                 --> process migrated:
>                                     * Old CPU offline: no-op.
>                                     * zswap_cpu_comp_prepare() continues
>                                       to run on the new CPU to finish
>                                       allocating acomp_ctx resources for
>                                       the offlined CPU.
> 
>     b) Pool deletion --> acomp_ctx_dealloc()
>                                 --> process migrated:
>                                     * Old CPU offline: no-op.
>                                     * acomp_ctx_dealloc() continues
>                                       to run on the new CPU to finish
>                                       de-allocating acomp_ctx resources
>                                       for the offlined CPU.
> 
>  4) Pool deletion vis-a-vis CPU onlining:
> 
>     The call to cpuhp_state_remove_instance() cannot race with
>     zswap_cpu_comp_prepare() because of hotplug synchronization.
> 
> The current acomp_ctx_get_cpu_lock()/acomp_ctx_put_unlock() are
> deleted. Instead, zswap_[de]compress() directly call
> mutex_[un]lock(&acomp_ctx->mutex).
> 
> The per-CPU memory cost of not deleting the acomp_ctx resources upon CPU
> offlining, and only deleting them when the pool is destroyed, is as
> follows, on x86_64:
> 
>     IAA with 8 dst buffers for batching:    64.34 KB
>     Software compressors with 1 dst buffer:  8.28 KB
> 
> This cost is only paid when a CPU is offlined, until it is onlined
> again.
> 
> Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>

LGTM with a small nit below:

Acked-by: Yosry Ahmed <yosry.ahmed@linux.dev>

> ---
>  mm/zswap.c | 164 +++++++++++++++++++++--------------------------------
>  1 file changed, 66 insertions(+), 98 deletions(-)
> 
> diff --git a/mm/zswap.c b/mm/zswap.c
> index 038e240c03dd..9480d54264e4 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -241,6 +241,20 @@ static inline struct xarray *swap_zswap_tree(swp_entry_t swp)
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

Should we set acomp_ctx->req, acomp_ctx->acomp, and acomp_ctx->buffer to
NULL here?

zswap_cpu_comp_prepare() uses NULL to detect that we need to initialize
acomp_ctx.

> +
> +	kfree(acomp_ctx->buffer);
> +}
> +
>  static struct zswap_pool *zswap_pool_create(char *compressor)
>  {
>  	struct zswap_pool *pool;
> @@ -262,19 +276,27 @@ static struct zswap_pool *zswap_pool_create(char *compressor)
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
> +	 */
>  	ret = cpuhp_state_add_instance(CPUHP_MM_ZSWP_POOL_PREPARE,
>  				       &pool->node);
> +
> +	/*
> +	 * cpuhp_state_add_instance() will not cleanup on failure since
> +	 * we don't register a hotunplug callback.
> +	 */
>  	if (ret)
> -		goto error;
> +		goto cpuhp_add_fail;
>  
>  	/* being the current pool takes 1 ref; this func expects the
>  	 * caller to always add the new pool as the current pool
> @@ -291,6 +313,10 @@ static struct zswap_pool *zswap_pool_create(char *compressor)
>  
>  ref_fail:
>  	cpuhp_state_remove_instance(CPUHP_MM_ZSWP_POOL_PREPARE, &pool->node);
> +
> +cpuhp_add_fail:
> +	for_each_possible_cpu(cpu)
> +		acomp_ctx_dealloc(per_cpu_ptr(pool->acomp_ctx, cpu));
>  error:
>  	if (pool->acomp_ctx)
>  		free_percpu(pool->acomp_ctx);
> @@ -321,9 +347,15 @@ static struct zswap_pool *__zswap_pool_create_fallback(void)
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
> @@ -735,39 +767,36 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
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
> +	/*
> +	 * To handle cases where the CPU goes through online-offline-online
> +	 * transitions, we return if the acomp_ctx has already been initialized.
> +	 */
> +	if (acomp_ctx->acomp) {
> +		WARN_ON_ONCE(IS_ERR(acomp_ctx->acomp));
> +		return 0;
>  	}
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
> @@ -775,83 +804,19 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
>  	 * crypto_wait_req(); if the backend of acomp is scomp, the callback
>  	 * won't be called, crypto_wait_req() will return without blocking.
>  	 */
> -	acomp_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
> +	acomp_request_set_callback(acomp_ctx->req, CRYPTO_TFM_REQ_MAY_BACKLOG,
>  				   crypto_req_done, &acomp_ctx->wait);
>  
> -	acomp_ctx->buffer = buffer;
> -	acomp_ctx->acomp = acomp;
> -	acomp_ctx->req = req;
> -
>  	acomp_request_set_unit_size(acomp_ctx->req, PAGE_SIZE);
>  
> -	mutex_unlock(&acomp_ctx->mutex);
> +	mutex_init(&acomp_ctx->mutex);
>  	return 0;
>  
>  fail:
> -	if (!IS_ERR_OR_NULL(acomp))
> -		crypto_free_acomp(acomp);
> -	kfree(buffer);
> +	acomp_ctx_dealloc(acomp_ctx);
>  	return ret;
>  }
>  
[..]

