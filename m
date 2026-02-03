Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D466E7FDE0
	for <linux-mm@archiver.kernel.org>; Tue,  3 Feb 2026 01:16:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B8346B0089; Mon,  2 Feb 2026 20:16:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 78C656B008A; Mon,  2 Feb 2026 20:16:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B9336B008C; Mon,  2 Feb 2026 20:16:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 595A96B0089
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 20:16:44 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CD8D31402E4
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 01:16:43 +0000 (UTC)
X-FDA: 84401380686.28.1C9D053
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 0D3B4100008
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 01:16:41 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FSBJQWqg;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770081402;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3ah9Nf9/WRIeEGi7zC7Ixl428WqgB6YLg8wPDvuAq/c=;
	b=10T5AU3eGPMxZn8P0L50Sf3tCmU/7xDjc4oYwrzv429B9DOlUC/Ml4UEOVqZiQJB+ygN56
	m1xrIbowc+0wXTaLO28qE/QOkmG2Wt3ZGKil7D0P1sU1yHH/kfQKRBG50aDnskiLj0422c
	0OcD4KMstZAUuE+dSFouiLz6cGifik8=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FSBJQWqg;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770081402; a=rsa-sha256;
	cv=none;
	b=kEmOKBQEDHNH4lOAfNrKcOfxNT1MHPdGke45GrFRtKaAtOLLZAr/sLgcycqQz8R65ubDXY
	7aOo1Fquq7lftNVeze0J6+8+HtO/28vDpC47qLgwWYRi/QA5MMCma72SCcUxMfzHFYZxuB
	S/GM420/Byq/9ZiwK2bgD/M4J1InKy8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0ADE243F37;
	Tue,  3 Feb 2026 01:16:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A46B6C116C6;
	Tue,  3 Feb 2026 01:16:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770081400;
	bh=kn7H58JeQWh7SXTUCnPWTlVxHhs2VbysDeSgAogieX8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FSBJQWqgZx9ncZ+q8r6q9LJjjl4q0vDNw41PBdMO8QBPcPsMzZsx8EtAva8NeJIRC
	 WQy3Tm4VK30PCyeOJJG/CQNA8FoMa++mWavvypEk0I3ZeGno4ryTSZ/7b9yfmF0KZA
	 4b+dY9TgPx94dsqp3V7WNSA/k+0spV4u73C3DGpA+I3lKLpKrjfuw9WPEwYB7v+aZS
	 pbrs96S4ZRAY3bJRxRWGdo/HbJF/NdKz0J+JyAK8NDF8JuzXcnS5iTRo5YJhUD4qZ9
	 IYPAKQ3+jCNXSj9rmFNGUYbliYxsvaJehpBkIRoxj7gdCLeYByVRxF/3NxhvAE5Ioi
	 GPigfEExHFgQw==
From: SeongJae Park <sj@kernel.org>
To: gutierrez.asier@huawei-partners.com
Cc: SeongJae Park <sj@kernel.org>,
	artem.kuzin@huawei.com,
	stepanov.anatoly@huawei.com,
	wangkefeng.wang@huawei.com,
	yanquanmin1@huawei.com,
	zuoze1@huawei.com,
	damon@lists.linux.dev,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v1 1/4] mm/damon: Generic context creation for modules
Date: Mon,  2 Feb 2026 17:16:32 -0800
Message-ID: <20260203011633.67532-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260202145650.1795854-2-gutierrez.asier@huawei-partners.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 0D3B4100008
X-Stat-Signature: fjtporu5hm9nxb1x3bt489qb7jgu17qe
X-Rspam-User: 
X-HE-Tag: 1770081401-369751
X-HE-Meta: U2FsdGVkX1+OwEnxtIrCKCyzqtPwLaPCj6h8YUKKh5nzSOZ61PekOtg0sQX3UH23WN8w0eUsMbvgrdWtGXmRZKpDDgElH8zADO3//S2pJHymcm3C/ReJsBCP1uq4A5/hNVmYLOhpkpJHrJ32gN9IH5sA2bo9G4meyQnUfZ5IBkJlBZtk0zWJwcGRU91VJ2z9pEQ6wC+EhBgKeFpSRt0FdgMIFcbbV4sE4ecLGnFrl7gu0twIwFqJhqSsd3Dlt6Y5VPWuQCVs/cNJWZx5QqeBhGugVTkOHsnkc/HvMx2BMxj58Ejw0Azc7atOV7J3APlYzXDncX4jXMMXfbJyu7xhobdU+QU4roExV2CV/7AYLJjlM6u/uFrzOGS4Ij4SU0S5FExD+MZWnKdzy4u5f5Hg4sXl1GPTXjts+q1xnkg/mF2WHE0bp1EzmFL6sDLYMn7t1972dkwRsy9uV0hD4isQcJ1EO9r1D73DEolN+tipPBy6v5HS0mUXj8Cw7FBQELS3ryg9qyrfQL+DVvW7XIz/XrdWnvM+NNFU5Bh0NOC66+mD5T4gGCqfgVQ4mYSVHrHQJOqBUMLSbHlipBXAaFrwHYSpaFMoqOTJxPVFpqFGMbLDgAm2ii5X8hW3nNMbdz9nd7t29y45UKCkkhOc7XDb76sRSt/jcPkm/knXYgSreQLC+71nba7TZCTTviLomKQXozgfVAH68IRr3YBWc4ST3votZbPSb79vBnPjOrwvaeIIw+zlXZUAEzGxm7WtA8iYbuQ/q2F86Yqz5ey0Y0gg04fForoFmpao8ECOP6SstbcHoyQ6qQCpIDu4hPXQniQQuMUsIeuGMwmIfSiPi+Fr+KWmyGPFP7BSCuNjX1p5AEJL4fjHe/wjqplgNSjo/n2ZpWR4G8DXc/7DTS0SIqu88hu9YG5DFZrgGxkg2TjrwuMbA54PAPoOUTmrskMRuFN4MlErF9mTMGpxVH3EMlO
 N+WCa2jF
 stGrza3Xhx/Yac+OId8NNizwgV2sJOVdCHtuGMaFakdhxkVeo09hpej47cHQv6OP2SGZ5ufVWH4k7sYvQ6Nam2p13L7gcH15dQ7OqHPyBmbkKhQo2PTn8Dd8HDxUUwXYrDfF6p5n73tys7/wLa8WTkE4bwjBo6LUm8BY30RsdplBRsbXXYv5Svq9ROvJPsuLwwtKjHwYoLjakZCv65glfEyRUUtPVhJm22L1CPAmvgKDwdANodS6kxOydSvjE1ZdTMCPkrAjL74k/Nx3FhGA4Yr0zegRKPKcoEY7E
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Let's use 'mm/damon/modules-common:' as the commit subject prefix.

On Mon, 2 Feb 2026 14:56:46 +0000 <gutierrez.asier@huawei-partners.com> wrote:

> From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
> 
> Damon_modules_new_paddr_ctx_target. This works  only for physical contexts.

Let's be case-sensitive.  s/Damon_/damon_/ ?

> In case of virtual addresses, we should  duplicate the code.
> 
> It is more elegant to have a generic version of new context creation which
> receives the mode as a parameter.

Makes sense to me.

> 
> Signed-off-by: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
> Co-developed-by: Anatoly Stepanov <stepanov.anatoly@huawei.com>
> ---
>  mm/damon/lru_sort.c       | 6 ++++--
>  mm/damon/modules-common.c | 7 ++++---
>  mm/damon/modules-common.h | 5 +++--
>  mm/damon/reclaim.c        | 5 +++--
>  4 files changed, 14 insertions(+), 9 deletions(-)
> 
> diff --git a/mm/damon/lru_sort.c b/mm/damon/lru_sort.c
> index 49b4bc294f4e..ac34b02dace8 100644
> --- a/mm/damon/lru_sort.c
> +++ b/mm/damon/lru_sort.c
> @@ -201,7 +201,8 @@ static int damon_lru_sort_apply_parameters(void)
>  	unsigned int hot_thres, cold_thres;
>  	int err;
>  
> -	err = damon_modules_new_paddr_ctx_target(&param_ctx, &param_target);
> +	err = damon_modules_new_ctx_target(&param_ctx, &param_target,
> +				DAMON_OPS_PADDR);
>  	if (err)
>  		return err;
>  
> @@ -375,7 +376,8 @@ static int __init damon_lru_sort_init(void)
>  		err = -ENOMEM;
>  		goto out;
>  	}
> -	err = damon_modules_new_paddr_ctx_target(&ctx, &target);
> +	err = damon_modules_new_ctx_target(&ctx, &target,
> +				DAMON_OPS_PADDR);

You could put the above line on the line before that without violating the 80
columns limit :)

>  	if (err)
>  		goto out;
>  
> diff --git a/mm/damon/modules-common.c b/mm/damon/modules-common.c
> index 86d58f8c4f63..5ba24e0ad9a1 100644
> --- a/mm/damon/modules-common.c
> +++ b/mm/damon/modules-common.c
> @@ -14,8 +14,9 @@
>   * @ctxp:	Pointer to save the point to the newly created context
>   * @targetp:	Pointer to save the point to the newly created target
>   */
> -int damon_modules_new_paddr_ctx_target(struct damon_ctx **ctxp,
> -		struct damon_target **targetp)
> +int damon_modules_new_ctx_target(struct damon_ctx **ctxp,
> +				struct damon_target **targetp,
> +				enum damon_ops_id mode)

You should also update the kernel-doc comments for the new parameter.

>  {
>  	struct damon_ctx *ctx;
>  	struct damon_target *target;
> @@ -24,7 +25,7 @@ int damon_modules_new_paddr_ctx_target(struct damon_ctx **ctxp,
>  	if (!ctx)
>  		return -ENOMEM;
>  
> -	if (damon_select_ops(ctx, DAMON_OPS_PADDR)) {
> +	if (damon_select_ops(ctx, mode)) {
>  		damon_destroy_ctx(ctx);
>  		return -EINVAL;
>  	}
> diff --git a/mm/damon/modules-common.h b/mm/damon/modules-common.h
> index f103ad556368..87d8058d7d85 100644
> --- a/mm/damon/modules-common.h
> +++ b/mm/damon/modules-common.h
> @@ -45,5 +45,6 @@
>  	module_param_named(nr_##qt_exceed_name, stat.qt_exceeds, ulong,	\
>  			0400);
>  
> -int damon_modules_new_paddr_ctx_target(struct damon_ctx **ctxp,
> -		struct damon_target **targetp);
> +int damon_modules_new_ctx_target(struct damon_ctx **ctxp,
> +				struct damon_target **targetp,
> +				enum damon_ops_id mode);
> diff --git a/mm/damon/reclaim.c b/mm/damon/reclaim.c
> index 36a582e09eae..b64fb810e096 100644
> --- a/mm/damon/reclaim.c
> +++ b/mm/damon/reclaim.c
> @@ -197,7 +197,8 @@ static int damon_reclaim_apply_parameters(void)
>  	struct damos_filter *filter;
>  	int err;
>  
> -	err = damon_modules_new_paddr_ctx_target(&param_ctx, &param_target);
> +	err = damon_modules_new_ctx_target(&param_ctx, &param_target,
> +				DAMON_OPS_PADDR);
>  	if (err)
>  		return err;
>  
> @@ -379,7 +380,7 @@ static int __init damon_reclaim_init(void)
>  		err = -ENOMEM;
>  		goto out;
>  	}
> -	err = damon_modules_new_paddr_ctx_target(&ctx, &target);
> +	err = damon_modules_new_ctx_target(&ctx, &target, DAMON_OPS_PADDR);
>  	if (err)
>  		goto out;
>  
> -- 
> 2.43.0

Overall, looks good for RFC.


Thanks,
SJ

