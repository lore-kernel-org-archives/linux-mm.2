Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D699FD88D3
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 00:58:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 745B06B0088; Tue, 10 Mar 2026 20:58:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6FD996B0089; Tue, 10 Mar 2026 20:58:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 629526B008A; Tue, 10 Mar 2026 20:58:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 50F7F6B0088
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 20:58:10 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C52C314044E
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 00:58:09 +0000 (UTC)
X-FDA: 84531970698.22.A9FEACA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 3B235100006
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 00:58:08 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="fh99KE/D";
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773190688;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NyGQ5dR6ufUZwybMRm5DyNHlKZGKM9L/kGC4D90p0wU=;
	b=TvWPvwWhyW8bux7WyO0gqr9Lb/UgMNGy/1Mi3UEBTWWbSkFcJSiV8tXetVKh58uMyvXWj4
	ICxo7nSVaA0n3/pZURe9paJ7b5vg9FUlza7M12CwfTU1oSmFlnY/G9Y2dHk6vBoEMvl5q3
	z/UYEa6DFzlIlX689C4nPOsl5s/Gtx0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773190688; a=rsa-sha256;
	cv=none;
	b=L2rVXw6n01CsYSBA5j5nbZ3Qn0oh7vdU3g1AwKsHc8awQb4Mt+Wu+IvncVmiLA+B6CyM4T
	g2v0qLL140Q0bpxa17/n6wb0hciz00csqpxgnnLb/iuX1D1oVN6mzZFF11B+RWOCbWqtLX
	AI+IwjOodKENyaMyB+6TRzcq9523+VA=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="fh99KE/D";
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7609660054;
	Wed, 11 Mar 2026 00:58:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4997C19423;
	Wed, 11 Mar 2026 00:58:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773190687;
	bh=jyg5ElLYxunJ9I3b0E/TajPaalo5BRYveddxz/HEQK4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fh99KE/DhqnrDJho6eon65biSO44MQZEs0C3Ky4ulaN/ck1bLEcEXZKqU8CUvb0K2
	 eTumhiImvvduF9CQizkpz4Vg+2r/1MGAX90yLGY82Z6TFHXU03jyTk5ZELr5p5PX5Z
	 Y+swA5AryIcvp+s+HOyzNNrWSG3SjFiImhdbKODKjNYSAzM7MVfFxoPixD3bGzykAk
	 RHSHceifRiZOwbRxdM1GlCGMlEGleeNw6acQ6HNj8yEcJFY3dMqc7qAaZrgEAgKxg7
	 ZYEhOSJG7b+AG+pcmMKAK8gZPTCgYK+kNfRP3yAmhQZ9uaP35yld8XDi+Tdv4VUBtW
	 KFg0AFeycYz9Q==
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
Subject: Re: [RFC PATCH v2 1/4] mm/damon: Generic context creation for modules
Date: Tue, 10 Mar 2026 17:57:58 -0700
Message-ID: <20260311005759.90440-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260310162420.4180562-2-gutierrez.asier@huawei-partners.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 6pf4ymu1cwuypam5bjccamz7oo5x56wf
X-Rspamd-Queue-Id: 3B235100006
X-Rspamd-Server: rspam03
X-HE-Tag: 1773190688-801267
X-HE-Meta: U2FsdGVkX197LuBhtMdZZxY/IHJA4uUlVhsyot50dTaMWyQQVGUdhuOfq+nYFjFTcla6AnuqSKjddhOC/MWN969DF3+NzuKCirbDR/10sfmfwHYH8VAahMHLHGvzcBBaKU8+8i2Nl7mKT7d7VsLJD7M4GjpPeMGgoytueNS3RpUfi57kJzlMpP3oNqPvD7k6PbY5Q0Ku1GqvVNH4ivnLuWQ50KB+c/41qfDM0zY9YDDsc9aqI4W/3UEO9lOrI3XAQg+eY8H6QR42FeS8BgyNlY3FleYfbwb0Gv1SYsBcvA/M5oNj3zQy4doX1QgSu9Z2K5m4laVzyK/m4Ty4QIqfjJyXV7R9HqV3IwSKr99OXGdq6InqEwaRi2trf30uKtTy7o22dIMwSeChj7BeCfX1w/tj90ePqAsgTwAHLBFrzrtFOsJCMd9s3oaOoW4dNgZfWiMYSt/q15HbkJLnGXSUHuuRAUOKNEooAcNvcOFzFYOc6v5Zi2xAaYCBnhzSDnOisgHhkP4hrlNkBxo7Pl43uvSAdereP/Dhnxzh9Ms/DpFV7OyKQv2mU4mSwFylYnqYgiiF4+h4A2qfZtkLYPoWu7xEGxbg2UiWbxiVZjf4aa1ujQw0EG/a7QvVu2Vq+T+JjwFBXIh4lMvWbW7Zjmy8c/pDEdQMEILvuXfxM+aJbOxnvk6AFzL64NXcvmDFtC6lRxB0naO88/mCRqmTh3tjZhBVwd71gsEv8AbWc3CQmAP0AHqzII8AVF8TSBtAe4OSbuLV9tbOYSmX8cJW1KGL2BHgYB8SpzUPckZpPA09aQ4WgjM2QFmGVKYbh+LqK82E2bOR8Q4t+sS/nuZqPjC0tg+JDg9WyBm+4WRlZzeD5INvcsXa35p/ypL/azgmilXXGUNjGhNkXpJ7nipyia/mMwnQ08sfusgPNS0IWNj/2X4PGjPJj5M8NgIsN4A40jaHvxOi1fuKkOnGOxen6zI
 FLRfMNco
 G7lWvGHDa22yI0hHHJ+8Ju4EoCTLj5d3wm3Cv03YnGboGQ11Gj98sWsjkiwYx+vrD4LQppdlXgygroWsyvyV56pG3sV49U8BeSNLvMANlHUoUi/258IzTwJ5sdZO6ymI892dJdBvJlFOVRdgv57hJZIJ6Y4gU5oTaigktvZJnw6GJETu5bII9m/UWiqz2mrPv7+zPS/d79WsXEw3Qfogp1UhZ5toP9QiUw230swMK0a6RW8DuoA46IU9Mg8YHgsn3L8f4LqtkDPhNFLAwDrLtAPITDKfUB6ntUZ2c
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 10 Mar 2026 16:24:17 +0000 <gutierrez.asier@huawei-partners.com> wrote:

> From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
> 
> It is more elegant to have a generic version of new context creation
> which receives the mode as a parameter.
> 
> Signed-off-by: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
> Co-developed-by: Anatoly Stepanov <stepanov.anatoly@huawei.com>
> ---
>  mm/damon/lru_sort.c       | 5 +++--
>  mm/damon/modules-common.c | 6 +++---
>  mm/damon/modules-common.h | 4 ++--
>  mm/damon/reclaim.c        | 5 +++--
>  4 files changed, 11 insertions(+), 9 deletions(-)
> 
> diff --git a/mm/damon/lru_sort.c b/mm/damon/lru_sort.c
> index 7bc5c0b2aea3..143ee0b21da6 100644
> --- a/mm/damon/lru_sort.c
> +++ b/mm/damon/lru_sort.c
> @@ -287,7 +287,8 @@ static int damon_lru_sort_apply_parameters(void)
>  	unsigned int hot_thres, cold_thres;
>  	int err;
>  
> -	err = damon_modules_new_paddr_ctx_target(&param_ctx, &param_target);
> +	err = damon_modules_new_ctx_target(&param_ctx, &param_target,
> +				DAMON_OPS_PADDR);

I like the name of the function is becoming shorter.  But I'm not happy with
the fact the resulting calling code becomes longer.

I understand you are doing this extension because you want a version of the
function for vaddr.  What about introducing another dedicated function, say,
damon_modules_new_vaddr_ctx_target() ?

And you can avoid duplicates between damon_modules_new_{p,v}addr_ctx_target()
by implementing internal function, say, damon_modules_new_ctx_target() that
receives the damon_ops_id.  And damon_modules_new_{P,v}addr_ctx_target() will
just wrappers of damon_modules_new_ctx_target().

>  	if (err)
>  		return err;
>  
> @@ -479,7 +480,7 @@ static int __init damon_lru_sort_init(void)
>  		err = -ENOMEM;
>  		goto out;
>  	}
> -	err = damon_modules_new_paddr_ctx_target(&ctx, &target);
> +	err = damon_modules_new_ctx_target(&ctx, &target, DAMON_OPS_PADDR);

Ditto.

>  	if (err)
>  		goto out;
>  
> diff --git a/mm/damon/modules-common.c b/mm/damon/modules-common.c
> index 86d58f8c4f63..ae50b2fa3a86 100644
> --- a/mm/damon/modules-common.c
> +++ b/mm/damon/modules-common.c
> @@ -14,8 +14,8 @@
>   * @ctxp:	Pointer to save the point to the newly created context
>   * @targetp:	Pointer to save the point to the newly created target
>   */
> -int damon_modules_new_paddr_ctx_target(struct damon_ctx **ctxp,
> -		struct damon_target **targetp)
> +int damon_modules_new_ctx_target(struct damon_ctx **ctxp,
> +		struct damon_target **targetp, enum damon_ops_id mode)

Nit.  I'd suggest 'ops_id' as the parameter name, instead of 'mode'.

>  {
>  	struct damon_ctx *ctx;
>  	struct damon_target *target;
> @@ -24,7 +24,7 @@ int damon_modules_new_paddr_ctx_target(struct damon_ctx **ctxp,
>  	if (!ctx)
>  		return -ENOMEM;
>  
> -	if (damon_select_ops(ctx, DAMON_OPS_PADDR)) {
> +	if (damon_select_ops(ctx, mode)) {
>  		damon_destroy_ctx(ctx);
>  		return -EINVAL;
>  	}
> diff --git a/mm/damon/modules-common.h b/mm/damon/modules-common.h
> index f103ad556368..379b49c6a617 100644
> --- a/mm/damon/modules-common.h
> +++ b/mm/damon/modules-common.h
> @@ -45,5 +45,5 @@
>  	module_param_named(nr_##qt_exceed_name, stat.qt_exceeds, ulong,	\
>  			0400);
>  
> -int damon_modules_new_paddr_ctx_target(struct damon_ctx **ctxp,
> -		struct damon_target **targetp);
> +int damon_modules_new_ctx_target(struct damon_ctx **ctxp,
> +		struct damon_target **targetp, enum damon_ops_id mode);
> diff --git a/mm/damon/reclaim.c b/mm/damon/reclaim.c
> index 43d76f5bed44..24786a58683a 100644
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
> @@ -381,7 +382,7 @@ static int __init damon_reclaim_init(void)
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


Thanks,
SJ

