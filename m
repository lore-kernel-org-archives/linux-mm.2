Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A70FCAC5B8
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 15:49:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CBD9E8E000E; Tue, 30 Sep 2025 11:49:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C46988E0002; Tue, 30 Sep 2025 11:49:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE7388E000E; Tue, 30 Sep 2025 11:49:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 914F68E0002
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 11:49:36 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2B8DD160784
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 15:49:36 +0000 (UTC)
X-FDA: 83946351552.18.FC5D544
Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	by imf23.hostedemail.com (Postfix) with ESMTP id 30083140009
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 15:49:33 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MwgSYTPU;
	spf=pass (imf23.hostedemail.com: domain of yosry.ahmed@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759247374;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9wPH6wwQqSIxcr7X9Oo8NWI4UvG7fGAU6TYD6yDcIv0=;
	b=Bt3VQ33f7K+As6DnZtwnYT1dd05LYqM0DDqtv3GLU9zL9DtoQ05FLhrf8w0cGH+d4Jazo+
	IjkVAdobWaixjm4NZYCsdIjbqUHaFNaQaq6VjfukJAX8TVdFnavuCmmNXICQJ/2oW6wuue
	VB2eF2eQrgcTsZ5KD5SB7YVP8GnBu+4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759247374; a=rsa-sha256;
	cv=none;
	b=24XYGq8tfw+Mw3lzK0Eu7cS96psJWgYYgWd8i+Hj98xmlyaWyOPo28J4XciMrq/TS05uYZ
	DWb5UA4T75WEAbJFCiy3RRSgfqnBtI4xi1LMOZIJ3KdSCVbGM6QD1ULf0HWi0R99+9Q0NJ
	H6LpfHww7cd4zTLZ6cgQq6LaYixoBJg=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MwgSYTPU;
	spf=pass (imf23.hostedemail.com: domain of yosry.ahmed@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Tue, 30 Sep 2025 15:49:22 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1759247371;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9wPH6wwQqSIxcr7X9Oo8NWI4UvG7fGAU6TYD6yDcIv0=;
	b=MwgSYTPUL7adjksmBhQxp2WuuSY96pTGQlwQtd3HSZMa9Ln1QHS4QpsnzP9GGvZc4Y6OXG
	pUV9If8/2R8cwvdkCZ1zkgM3qqqCWMppi23nBM7fGeKALxswf3v+uJiYLNISX0hOqG1qDw
	DLZ1IUZPgrNLHRmd7Jiy1sS/52weqO0=
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
Subject: Re: [PATCH v12 20/23] mm: zswap: Per-CPU acomp_ctx resources exist
 from pool creation to deletion.
Message-ID: <j4o53f24yeegzrj7aj2mbu5c2xyqksnb6uz2fjkwgi3dbbtqsw@cwatjnrsgbco>
References: <20250926033502.7486-1-kanchana.p.sridhar@intel.com>
 <20250926033502.7486-21-kanchana.p.sridhar@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250926033502.7486-21-kanchana.p.sridhar@intel.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 30083140009
X-Stat-Signature: ohgzgs96d4dm7egg3s3sbzyb11e5eub7
X-Rspam-User: 
X-HE-Tag: 1759247373-608064
X-HE-Meta: U2FsdGVkX19DbgSaFhyBUV7/U99P4h9ckLwHnEEIq7YcdAvJ5bYq8GAcT70yhC5wsfefDKpgIFGeE/nwwvTtxBq0SyPRzKmCRgfdzUl9z2ImzNbozFK+hf8G5Rrn6CncAQsIMuNBJTkNDU3lNVCrGPjcIbYrqPh3gM1ku7w0F7Zt/cSUv6i2I2NZX4lT7UMrFkZIP3CowcWYKVkYQAv7G1iI3VaIMcbfkwVy8GHWFqEFmlG/1Dbh/6Nji+0d7DFuMRy7pfms7vA/ysy5N8NWOl1+unRAP/h3ISA4LyfA4tbaHD+7QR6R//ertu7xv9VWOBjWxQnfJtYJ9+zwRz8a3H67dzgpS9Fam3CQMgAmBRA+jmK0XvfIuaJqYAQqTcD5+C0Nrl6oeT4TDpKeL/ObtWb3O1TV6sb9zghFcdlKODINCzk22xVUIW/Ldzt6zk0h7FqCNw2Kop+bdcrBDcKxmDh8tdgyFn/aU3rg7TexRj+uaaqQyAKJQtfMqVZ1jFug6z9hh/wRAm2PsIzcLCC6uJj5jCofbInysuVuz/9lm3hnGLNosveuNCsGTMGq1jYYObvdNrVr1mc4NepaLGT0t5afOSlJfsHPLXQfejj/+lc/aRsTQYVZdKDj3+3ubneAozzWI+Cf2+ETuRG/IoSp9KupnVP0srEIh7V4L9O2jI4LzWI643lyGtzo4iP+XAjirFGTB9IKWpGxvqDodnh9YhpuVJTYP8etmuCrRCs0kw+PJopF8AOXXh/kQopVViH/ZQ+nEb8yK3at770C46aRDTqqgcjACwfkvWThezsuAjSdWN3ymS+Xn3o/ChzNvMeZOLOr0T7YM4BgfzqKuCB1JW9ECpWFW7MfiEnh2SUZnaKMZAHbFVMn/rNQcBJGUF4lVS2NkbtSQwXClb7w5Uevw6mO6JWPouye5ojAwnPS5bxWEho2Jpj+z7VBaJQzEWchNThqVIbY6mCG4maC7F6
 VXS8dqtS
 18NJA44QXoy6gu+ELxS+ptumoC2BxhIj19Nnr/XuuienwkLKVkU2JmRjyWbKPKQtIiDC8IA86b3hcHdUzDoKE1XL7c2gfS9Oz6u4MYHQRyXLeL2PwpO7Ak1tRYsJ3r0PTHzEr1Lzp4sRNNaifi7N/W0t9bP+u8UYxCHJ2xuSIm01X4SpJXwqNYG+Mz6F3zbFM7SAwHWWA+Zpco+FYJomMENaNmeALctge/FC4geb77VzYol7vLnKBR7L582xSMR0Ip18ANywJ214BRxywAUXBnIHo71Br3Twx5XZZASvxQLtH4zLPs2wG2NvrGHa87kW1dxgr
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 25, 2025 at 08:34:59PM -0700, Kanchana P Sridhar wrote:
> This patch simplifies the zswap_pool's per-CPU acomp_ctx resource
> management. Similar to the per-CPU acomp_ctx itself, the per-CPU
> acomp_ctx's resources' (acomp, req, buffer) lifetime will also be from
> pool creation to pool deletion. These resources will persist through CPU
> hotplug operations. The zswap_cpu_comp_dead() teardown callback has been
> deleted from the call to
> cpuhp_setup_state_multi(CPUHP_MM_ZSWP_POOL_PREPARE). As a result, CPU
> offline hotplug operations will be no-ops as far as the acomp_ctx
> resources are concerned.
> 
> This commit refactors the code from zswap_cpu_comp_dead() into a
> new function acomp_ctx_dealloc() that preserves the IS_ERR_OR_NULL()
> checks on acomp_ctx, req and acomp from the existing mainline
> implementation of zswap_cpu_comp_dead(). acomp_ctx_dealloc() is called
> to clean up acomp_ctx resources from all these procedures:
> 
> 1) zswap_cpu_comp_prepare() when an error is encountered,
> 2) zswap_pool_create() when an error is encountered, and
> 3) from zswap_pool_destroy().
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
>     out. zswap_cpu_comp_prepare() will be executed on a control CPU,
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
>     subsequent CPU hotplug online-offlines:
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
>     To prevent possibility of race conditions between
>     acomp_ctx_dealloc() freeing the acomp_ctx resources and the initial
>     check for a valid acomp_ctx->acomp in zswap_cpu_comp_prepare(), we
>     need to delete the multi state instance right after it is added, in
>     zswap_pool_create().
> 
>  Summary of changes based on the above:
>  --------------------------------------
>  1) Zero-initialization of pool->acomp_ctx in zswap_pool_create() to
>     simplify and share common code for different error handling/cleanup
>     related to the acomp_ctx.
> 
>  2) Remove the node list instance right after node list add function
>     call in zswap_pool_create(). This prevents race conditions between
>     CPU onlining after initial pool creation, and acomp_ctx_dealloc()
>     freeing the acomp_ctx resources.
> 
>  3) zswap_pool_destroy() will call acomp_ctx_dealloc() to de-allocate
>     the per-CPU acomp_ctx resources.
> 
>  4) Changes to zswap_cpu_comp_prepare():
> 
>     a) Check if acomp_ctx->acomp is valid at the beginning and return,
>        because the acomp_ctx is already initialized.
>     b) Move the mutex_init to happen in this procedure, before it
>        returns.
>     c) All error conditions handled by calling acomp_ctx_dealloc().
> 
>  5) New procedure acomp_ctx_dealloc() for common error/cleanup code.
> 
>  6) No more multi state instance teardown callback. CPU offlining is a
>     no-op as far as acomp_ctx resources are concerned.
> 
>  7) Delete acomp_ctx_get_cpu_lock()/acomp_ctx_put_unlock(). Directly
>     call mutex_lock(&acomp_ctx->mutex)/mutex_unlock(&acomp_ctx->mutex)
>     in zswap_[de]compress().
> 
> The per-CPU memory cost of not deleting the acomp_ctx resources upon CPU
> offlining, and only deleting them when the pool is destroyed, is as
> follows, on x86_64:
> 
>     IAA with 8 dst buffers for batching:    64.34 KB
>     Software compressors with 1 dst buffer:  8.28 KB
> 
> Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>

Please try to make the commit logs a bit more summarized. Details are
helpful, but it's easy to lose track of things when it gets too long.

> ---
>  mm/zswap.c | 194 +++++++++++++++++++++++++----------------------------
>  1 file changed, 93 insertions(+), 101 deletions(-)
> 
> diff --git a/mm/zswap.c b/mm/zswap.c
> index c1af782e54ec..27665eaa3f89 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -242,6 +242,30 @@ static inline struct xarray *swap_zswap_tree(swp_entry_t swp)
>  **********************************/
>  static void __zswap_pool_empty(struct percpu_ref *ref);
>  
> +/*
> + * The per-cpu pool->acomp_ctx is zero-initialized on allocation. This makes
> + * it easy for different error conditions/cleanup related to the acomp_ctx
> + * to be handled by acomp_ctx_dealloc():
> + * - Errors during zswap_cpu_comp_prepare().
> + * - Partial success/error of cpuhp_state_add_instance() call in
> + *   zswap_pool_create(). Only some cores could have executed
> + *   zswap_cpu_comp_prepare(), not others.
> + * - Cleanup acomp_ctx resources on all cores in zswap_pool_destroy().
> + */

Comments describing specific code paths go out of date really fast. The
comment is probably unnecessary, it's easy to check the allocation path
to figure out that these are zero-initialized.

Also in general, please keep the comments as summarized as possible, and
only when the logic is not clear from the code.

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
> @@ -263,19 +287,43 @@ static struct zswap_pool *zswap_pool_create(char *compressor)
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
>  	ret = cpuhp_state_add_instance(CPUHP_MM_ZSWP_POOL_PREPARE,
>  				       &pool->node);
> +
> +	/*
> +	 * We only needed the multi state instance add operation to invoke the
> +	 * startup callback for all cores without cores getting offlined. Since
> +	 * the acomp_ctx resources will now only be de-allocated when the pool
> +	 * is destroyed, we can safely remove the multi state instance. This
> +	 * minimizes (but does not eliminate) the possibility of
> +	 * zswap_cpu_comp_prepare() being invoked again due to a CPU
> +	 * offline-online transition. Removing the instance also prevents race
> +	 * conditions between CPU onlining after initial pool creation, and
> +	 * acomp_ctx_dealloc() freeing the acomp_ctx resources.
> +	 * Note that we delete the instance before checking the error status of
> +	 * the node list add operation because we want the instance removal even
> +	 * in case of errors in the former.
> +	 */
> +	cpuhp_state_remove_instance(CPUHP_MM_ZSWP_POOL_PREPARE, &pool->node);
> +

I don't understand what's wrong with the current flow? We call
cpuhp_state_remove_instance() in pool deletion before freeing up the
per-CPU resources. Why is this not enough?


