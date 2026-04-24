Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3759FDEE28
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 01:36:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B92E6B0088; Thu, 23 Apr 2026 21:36:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 969E66B008A; Thu, 23 Apr 2026 21:36:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 87F646B008C; Thu, 23 Apr 2026 21:36:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 769B76B0088
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 21:36:33 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EC5561B8CC4
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 01:36:32 +0000 (UTC)
X-FDA: 84691734624.22.571C99F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 36852100009
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 01:36:30 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IQkyhRTR;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776994591;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DZquUcgLUouQMKqlLE2QEAXQ38XM8LJJiPAZrgnitX8=;
	b=aWsCflMy4k3hU48xHOia7T0g7TmlGDIMi1lSvPof0mxfhADoJJ9RwWvyzmX9pIeV2pB5aa
	2y4BODT+ScmvVIW0v6km2IhpgCdNzf8BYOTWfjiSB9Nag64x/7JHbZvSXTtusTqWxlzKNY
	Gr66CACYXqqLCRGBBWccvFdazstrS04=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776994591; a=rsa-sha256;
	cv=none;
	b=x8TEilmh6TWS0TAnRbGnBkDrF07WeXleIlE5boiwCa07mHdEwPeCHqWKyh11agZicOQGIe
	VLezscUysFV14AZjNYfMPgTqg7QibkiBvmXeGUdPCGAwbvNgQSDJ9jY/hwPlkWlIWwPNER
	nAgsdD3DsEa7MpGaZirnbrAGeJaWNek=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IQkyhRTR;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 013A3435AA;
	Fri, 24 Apr 2026 01:36:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85D98C2BCB3;
	Fri, 24 Apr 2026 01:36:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776994589;
	bh=XVkQMoIv9T5EMJuiraVTro4c/A5XtdO39uZDA8B1KhM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IQkyhRTRvA4Jg+k982OTOMksXB4t6KiNtF5cv5xam6onGTyNkdCkoySzlxa7s8l9h
	 SUrjpuoYeXgucLWWfwgkgl7XvDpHbEK1n6mfJe18t8DLx7/h9QQCpbbGtGkQJm3YHS
	 Vf0HAxBvp/30HQ+Z3iIbCK5W21gBv0ib4RE8u6UW86FVgmdyuC3g4iA+RXFDifSz4a
	 UfvCKFrwD05ISXZ/tClJPAY8xocV/DKS4rZvWLKu1c52eJJcgG9CAHZWJ9ddwOrWrI
	 8fQzUUoAgkjO9YBEfcELWmht6HeLjyaAzWtKdlJ4Wv1Qrhux1QtxkYbLKNqOW6ANzh
	 7wBJyGQY17ggA==
From: SeongJae Park <sj@kernel.org>
To: Jiayuan Chen <jiayuan.chen@linux.dev>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	Jiayuan Chen <jiayuan.chen@shopee.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mm/damon: introduce damon_rand_fast() for per-ctx PRNG
Date: Thu, 23 Apr 2026 18:36:20 -0700
Message-ID: <20260424013621.983-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260423122340.138880-1-jiayuan.chen@linux.dev>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 36852100009
X-Rspamd-Server: rspam07
X-Stat-Signature: 5o8rb31tcmfcap1jjk7iwqgduk4dynng
X-Rspam-User: 
X-HE-Tag: 1776994590-282188
X-HE-Meta: U2FsdGVkX19WnT5TWbeIAW99oOX5V9RLTPf157Ll/kX6H+VFjMsBnMCxgOdhR/uS5MkPcTwGdnH6WbocXfOIGx37NInzXju5BPTaAHAK30HW3P2QxULQjpeqaI6BBwQJ20JrskjTLxSpdIhF+bIbIVn2DEyYhU8OiXLKQPCc1KHpux6IA+AHFGQaXS4qWh7pw4rIe3FvfV00jJ/7TEEtbjIst9uIRQe4N418kBoCXsuL7IqD37OJdkWpgboCRYzjgnmAgG6dQX6rVm5oJqENfQo5X/OSC6QLdBiRySJ1vUnylGpQYysJ+f5Ggb/gxJMwQEfC+Xzn71fw/5pJn111UbK7Qs5OWEr4r28FNHF/hPf16U2WSn4uDw1uQcd3s2D2zC3OWOLa5C3bWsHyBU2RTEKuQFyBhvAkG0XX59ZECUJfaDZ4m5zHkdvRsTX7LkzTV8k83EdRHJe+3AbKCbtgtlS1lr7KR2mVGpVMOmRW1x9soczcB4Z/u4TPMQw9bD+CHsJNFel3F8iMgNKCRZGqKnEKymXiPgZ5HXtI3wkaONmddOa7EJYZrLfeT4fD2LCs5/bmd7cdv3RHfSqci616EYTOjoaRElLcKe/S4+fDpgM4m1EfvQWzXjgh+khNweU/2iY4cbIYlX5jgN4Lwq2uPcisALQNTnI8tr2RkYycqq3pBFFBZjKoLRqaS7kQ0EsDLhB2ScqbbFUuDPWkFme8ompeWBOW18BG9K8bYEok2svVH5WErr/oWJGvOQSnla0QA8T/uzprlLss3xxrHZukqtAs4wOzZ5XUGWMRTB2bdHda/FJu47mq/MWpU0kmfYT+8AgvYFkklRfDqMibNePxgp6mcDYqBbZ0ZJvXUMx9Ap2uth0Zwwtc7HLe4NApu/MbxW8OOI2gRoOvBlkW6xvGd/uDufyxsV0bEvZCcgh1XK0GCHsat4jpBgtpsURDufLHpnzbNPPD7GsOXWrZAx2
 LztqrvR3
 7Z4uLgD9DsIKAL+Z1Vy4tyCIVoSG3pYKdQn3gBuxj1DrIIpTA1gFOugv2ZT53q9DoK2GFi1c9WNT1pg+Z4SzWCelZ7SeAUFU3orMVdEP7czBEsi5CtBE1vt+STy1IoeT3SmsSt16Re3lwtgGyBwD11EjzKuOWzK11wv+zzCMiVcCvcyCUfTewFe2qCknSroAkM0kYDMx/ozwIbn0B9tctiAgN5KvO8oGS3nyBKRmVQkuWAqauLrgqK3n/cUr1PW1/XHdDNXpEBd04p81xOkxayg+xWM/S/L0lkjnWPIi6xJwVuPi+XX1bcUciMT7oWa7f6F1kGahTKiGNfQUQTVH0or/4UA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Jiayuan,


Thank you for sharing this patch with us!

On Thu, 23 Apr 2026 20:23:36 +0800 Jiayuan Chen <jiayuan.chen@linux.dev> wrote:

> From: Jiayuan Chen <jiayuan.chen@shopee.com>
> 
> damon_rand() on the sampling_addr hot path calls get_random_u32_below(),
> which takes a local_lock_irqsave() around a per-CPU batched entropy pool
> and periodically refills it with ChaCha20.  On workloads with large
> nr_regions (20k+), this shows up as a large fraction of kdamond CPU
> time: the lock_acquire / local_lock pair plus __get_random_u32_below()
> dominate perf profiles.

Could you please share more details about the use case?  I'm particularly
curious how you ended up setting 'nr_regiions' that high, while the upper limit
of nr_regions is set to 1,0000 by default.

I know some people worry if the limit is too low and it could result in poor
monitoring accuracy.  Therefore we developed [1] monitoring intervals
auto-tuning.  From multiple tests on real environment it showed somewhat
convincing results, and therefore I nowadays suggest DAMON users to try that if
they didn't try.

I'm bit concerned if this is over-engineering.  It would be helpful to know if
it is, if you could share the more detailed use case.

> 
> Introduce damon_rand_fast(), which uses a lockless lfsr113 generator
> (struct rnd_state) held per damon_ctx and seeded from get_random_u64()
> in damon_new_ctx().  kdamond is the sole consumer of a given ctx, so no
> synchronization is required.  Range mapping uses Lemire's
> (u64)rnd * span >> 32 to avoid a 64-bit division; residual bias is
> bounded by span / 2^32, negligible for statistical sampling.
> 
> The new helper is intended for the sampling-address hot path only.
> damon_rand() is kept for call sites that run outside the kdamond loop
> and/or have no ctx available (damon_split_regions_of(), kunit tests).
> 
> Convert the two hot callers:
> 
>   - __damon_pa_prepare_access_check()
>   - __damon_va_prepare_access_check()
> 
> lfsr113 is a linear PRNG and MUST NOT be used for anything
> security-sensitive.  DAMON's sampling_addr is not exposed to userspace
> and is only consumed as a probe point for PTE accessed-bit sampling, so
> a non-cryptographic PRNG is appropriate here.
> 
> Tested with paddr monitoring and max_nr_regions=20000: kdamond CPU
> usage reduced from ~72% to ~50% of one core.
> 
> Cc: Jiayuan Chen <jiayuan.chen@linux.dev>
> Signed-off-by: Jiayuan Chen <jiayuan.chen@shopee.com>
> ---
>  include/linux/damon.h | 28 ++++++++++++++++++++++++++++
>  mm/damon/core.c       |  2 ++
>  mm/damon/paddr.c      | 10 +++++-----
>  mm/damon/vaddr.c      |  9 +++++----
>  4 files changed, 40 insertions(+), 9 deletions(-)
> 
> diff --git a/include/linux/damon.h b/include/linux/damon.h
> index f2cdb7c3f5e6..0afdc08119c8 100644
> --- a/include/linux/damon.h
> +++ b/include/linux/damon.h
> @@ -10,6 +10,7 @@
>  
>  #include <linux/memcontrol.h>
>  #include <linux/mutex.h>
> +#include <linux/prandom.h>
>  #include <linux/time64.h>
>  #include <linux/types.h>
>  #include <linux/random.h>
> @@ -843,8 +844,35 @@ struct damon_ctx {
>  
>  	struct list_head adaptive_targets;
>  	struct list_head schemes;
> +
> +	/*
> +	 * Per-ctx lockless PRNG state for damon_rand_fast(). Seeded from
> +	 * get_random_u64() in damon_new_ctx(). Owned exclusively by the
> +	 * kdamond thread of this ctx, so no locking is required.
> +	 */
> +	struct rnd_state rnd_state;
>  };
>  
> +/*
> + * damon_rand_fast - per-ctx PRNG variant of damon_rand() for hot paths.
> + *
> + * Uses the lockless lfsr113 state kept in @ctx->rnd_state. Safe because
> + * kdamond is the single consumer of a given ctx, so no synchronization
> + * is required. Quality is sufficient for statistical sampling; do NOT
> + * use for any security-sensitive randomness.
> + *
> + * Range mapping uses Lemire's (u64)rnd * span >> 32 to avoid a division;
> + * bias is bounded by span / 2^32, negligible for DAMON.
> + */
> +static inline unsigned long damon_rand_fast(struct damon_ctx *ctx,
> +					    unsigned long l, unsigned long r)
> +{
> +	u32 rnd = prandom_u32_state(&ctx->rnd_state);
> +	u32 span = (u32)(r - l);
> +
> +	return l + (unsigned long)(((u64)rnd * span) >> 32);
> +}

As Sashiko pointed out [2], we may better to return 'unsigned long' from this
function.  Can this algorithm be extended for that?

> +
>  static inline struct damon_region *damon_next_region(struct damon_region *r)
>  {
>  	return container_of(r->list.next, struct damon_region, list);
> diff --git a/mm/damon/core.c b/mm/damon/core.c
> index 3dbbbfdeff71..c3779c674601 100644
> --- a/mm/damon/core.c
> +++ b/mm/damon/core.c
> @@ -607,6 +607,8 @@ struct damon_ctx *damon_new_ctx(void)
>  	INIT_LIST_HEAD(&ctx->adaptive_targets);
>  	INIT_LIST_HEAD(&ctx->schemes);
>  
> +	prandom_seed_state(&ctx->rnd_state, get_random_u64());
> +
>  	return ctx;
>  }
>  
> diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
> index 5cdcc5037cbc..b5e1197f2ba2 100644
> --- a/mm/damon/paddr.c
> +++ b/mm/damon/paddr.c
> @@ -48,12 +48,12 @@ static void damon_pa_mkold(phys_addr_t paddr)
>  	folio_put(folio);
>  }
>  
> -static void __damon_pa_prepare_access_check(struct damon_region *r,
> -		unsigned long addr_unit)
> +static void __damon_pa_prepare_access_check(struct damon_ctx *ctx,
> +					    struct damon_region *r)

Let's keep 'r' on the first line, and update the second line without indent
change.

>  {
> -	r->sampling_addr = damon_rand(r->ar.start, r->ar.end);
> +	r->sampling_addr = damon_rand_fast(ctx, r->ar.start, r->ar.end);
>  
> -	damon_pa_mkold(damon_pa_phys_addr(r->sampling_addr, addr_unit));
> +	damon_pa_mkold(damon_pa_phys_addr(r->sampling_addr, ctx->addr_unit));
>  }
>  
>  static void damon_pa_prepare_access_checks(struct damon_ctx *ctx)
> @@ -63,7 +63,7 @@ static void damon_pa_prepare_access_checks(struct damon_ctx *ctx)
>  
>  	damon_for_each_target(t, ctx) {
>  		damon_for_each_region(r, t)
> -			__damon_pa_prepare_access_check(r, ctx->addr_unit);
> +			__damon_pa_prepare_access_check(ctx, r);
>  	}
>  }
>  
> diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
> index b069dbc7e3d2..6cf06ffdf880 100644
> --- a/mm/damon/vaddr.c
> +++ b/mm/damon/vaddr.c
> @@ -332,10 +332,11 @@ static void damon_va_mkold(struct mm_struct *mm, unsigned long addr)
>   * Functions for the access checking of the regions
>   */
>  
> -static void __damon_va_prepare_access_check(struct mm_struct *mm,
> -					struct damon_region *r)
> +static void __damon_va_prepare_access_check(struct damon_ctx *ctx,
> +					    struct mm_struct *mm,
> +					    struct damon_region *r)

Let's keep the first line and the the indentation as were, and add 'ctx'
argument to the end.

>  {
> -	r->sampling_addr = damon_rand(r->ar.start, r->ar.end);
> +	r->sampling_addr = damon_rand_fast(ctx, r->ar.start, r->ar.end);
>  
>  	damon_va_mkold(mm, r->sampling_addr);
>  }
> @@ -351,7 +352,7 @@ static void damon_va_prepare_access_checks(struct damon_ctx *ctx)
>  		if (!mm)
>  			continue;
>  		damon_for_each_region(r, t)
> -			__damon_va_prepare_access_check(mm, r);
> +			__damon_va_prepare_access_check(ctx, mm, r);
>  		mmput(mm);
>  	}
>  }
> -- 
> 2.43.0
> 
> 

[1] https://lkml.kernel.org/r/20250303221726.484227-1-sj@kernel.org
[2] https://lore.kernel.org/20260423190841.821E4C2BCAF@smtp.kernel.org


Thanks,
SJ

