Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49867FD9E2D
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 01:56:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 290276B0005; Thu, 26 Feb 2026 20:56:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 23B576B0088; Thu, 26 Feb 2026 20:56:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 12F466B0089; Thu, 26 Feb 2026 20:56:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id EE17D6B0005
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 20:56:18 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 606811B7409
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 01:56:18 +0000 (UTC)
X-FDA: 84488571636.11.EB17660
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 9DD65120008
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 01:56:16 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cA43YzXx;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772157376;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FDxqXhyl6b8BlIqyQ2uQKa3EZtt89RYwbAojcVhfrYc=;
	b=xS3ztTVc73EMok6J96owOdLEruouDPrdkpWQHudLXR1a+3RyGOfMdriFpcsXobVaHgyKzp
	jNwJ2wyu02ZpbPKZtwJVkh4xa1Ajcv/iE4ovxMs6nMOmg0bVj1hS219c/xiIxGkUNCPabB
	zfnNIE9takPVmAziMb0X7/JveMVci4M=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772157376; a=rsa-sha256;
	cv=none;
	b=tuGRDhouMgNmILOPhi/f4HcOA+vs8uXxrIMG52nEUqFhEYMJx5kDSnOFsj1LveUK3rPhRv
	WW2iZhG9Jrq/FD6zc8kbBbVvubJzpLO8+DzePdCJNsfLNzJDAEQn7Azpb4WAcBW4oRjxoj
	EWzpoc7hUZ3C+93NqyCJzK5P95oaoj0=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cA43YzXx;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 608AF4063D;
	Fri, 27 Feb 2026 01:56:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 192D2C116C6;
	Fri, 27 Feb 2026 01:56:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772157375;
	bh=+3NGDKoPMiK/X0YvkLCsM35GibtNp1pBwm8kbF/eqpE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cA43YzXx1Zbyf6taFSYkJjbamE5B1SW4NRtDdrh8qnAh3n3p3O+0AOhfY2n++5AYU
	 x9xJE8hLU4E4VsSZTQh6RuQCQcgbLuRJV88XcU1/VPedUoIw92IKNlTrJ1Mg7zeKP3
	 SwWt+oYVHIb6sHxGNQ69xiPCTyMNZMp/sGIrk4+czh3nSy/owVjHSNm99yOCrvLep2
	 LE8gkuHSbl9ZU3hLg2WSguA6XEJEbPf1emlin9lQpwtZ6SDsc5rm3Xa+h6BsDwsjYZ
	 XO3BA85sHXswgkZKwedIkxGiYQ1EAcieNXeoI9Qg6f7KScpqOdMSwSSl2eZqafkkjm
	 wMkmsOk5FP9lw==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Ravi Jonnalagadda <ravis.opensrc@gmail.com>
Subject: Re: [RFC PATCH 1/5] mm/damon/core: introduce damos_quota_goal_tuner
Date: Thu, 26 Feb 2026 17:56:13 -0800
Message-ID: <20260227015613.91346-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260212062314.69961-2-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 9DD65120008
X-Stat-Signature: tbtmittbgjbymkk6hzeymtpajt4rnuqb
X-Rspam-User: 
X-HE-Tag: 1772157376-882325
X-HE-Meta: U2FsdGVkX1/JbJpOu4R9k0/1wIKOaYsB3w0+/52XWpJxPeaAe5BUg5d+EyqmmumMg2zGg3sPqXG6iXDLqbv7vOjxeUGTdpxZLr6xLvzccDiJPpVDvv6As2n3V4KkCQsVKn+NTLrMMLbijWcy7qNDjZbXleLuOljSy9pDH5/dIk3BBlDLFXfV8ZlgHBHqFqxCWQftwV+nb1MTBaBJWXdqPDFMrW0VX1w2EM2ccYc2OndGfXuCc59BNF/eYkErPqWzsLAwAjXqOMqBypfV09pLroUaSsqwG3BF5fRoQh8jgk01FIZoltmCzsi2AKQeBiRjchVQNp3QJErH3ssy5PrV+4NHL/mCUNyb38YYhj1/W7pJuy8iPN9RaJ9CeHEKeXLWZ43UZBNz20VEfmbW8QYcSiIiBlF9Unot4b0vWolnwffiofB45/Bazjz4z9MLRRR3zayaLEk7fuIvteJwRvWxHD2vSU9xhItwMMMNXJzJUNn1AUZ/cABcW1oMj/wUdONfLl00xA4Z/qPtzWxHFH2yWjOZBE1uOT+VY0iPuAO6q6ScJIrdeegD/li9RilbLCA9hunvcQsYxkYzNuK7pzHUrLzQJ7GAF8S4M0Ilj0/G6dk+Rp/+TDdr+izp+4p/t8GccVS8C1hSn3He/8P7HLdVODRy3WIj6DrPNoNX7VPOoYhmoAidlyc1Dy9z3+j2UXHRv1c2K0mbhizBS9/Y8XU6a3mOm8HsqoUQrTiK9ddj2MijrIWw0Q1oF9CKzpm60gU/xmKCsKGeAMezQyZb+3RNz3HHUUeUggp67VimCRhnMdCpkAPm4CxJ1/eIZ/grD/y+C/jVzcc3H0lKitDkBNvbFKq8u3psAo1wTOFEcY4TBuA+u64/rTFDC+7w88nbX+E2vFYelBf0cBRs0LLH+hPMQzIWSwUSoe9R6RHXMUDQhYlReE3ECK9lS9tFbZNA3ZTD3GKsvGvscH0s+7FMgN9
 42W71bR3
 OGfXvyu0gCkk+YVZW7l57S/95TzlliSmfsqiL1Y1Ayeu5NYTRpoAcbW2Tv+lIwU6rGWz/XvLHmSSneCXwPptbjwJLB6o5qHDFQ14Iz8qB5GZ+6pcbE7/4XkDdVVYK3HZClMe3WaHLOT/j7SdlBiTih+iw2vSPHqn8nmjwnd7ZsozpNi7y2QbjeuEaWxtW1kCoCiIYJMMJBWCq3b+cVHGSKDmN4ZHOXwHl6jfeFbg8qb5v8xUvPA0bY/Wi7o56Lay1pLvEKqtzFDSl8eS/g2SYreH+hv6y0XhCFi+eHVaXHb9VWtnIMLpEU5oF2YA357Yw93UBtE7P8UMwswgERPvTDShUdqzZo7f8WWjpK5FyuBIAhv2YsDmCoLwKSO2tV4B03sh6pVaBeaQazoUtlum0oONusSaDhpk5lp4tK7B6b0gObYs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 11 Feb 2026 22:23:08 -0800 SeongJae Park <sj@kernel.org> wrote:

> Currently DAMOS quota goal feature utilizes a single feedback loop based
> algorithm for automatic tuning of the effective quota.  It is proven to
> be useful on dynamic environments that operate systems with only
> kernels.  But, no one fits all, and we got multiple reports [1,2] of
> cases that the algorithm is not optimum.
> 
> Introduce a new field of 'struct damos_quotas', namely 'goal_tuner'.  It
> specifies what tuning algorithm the given scheme should use, and allows
> DAMON API callers to set it as they want.  Nonetheless, this commit does
> not introduce a new tuning algorithm but only the interface.  This
> commit hence makes no behavioral change.  A new algorithm will be added
> by the following commit.
> 
> [1] https://lore.kernel.org/CALa+Y17__d=ZsM1yX+MXx0ozVdsXnFqF4p0g+kATEitrWyZFfg@mail.gmail.com
> [2] https://lore.kernel.org/20260204022537.814-1-yunjeong.mun@sk.com
> 
> Signed-off-by: SeongJae Park <sj@kernel.org>
> ---
>  include/linux/damon.h | 9 +++++++++
>  mm/damon/core.c       | 4 +++-
>  2 files changed, 12 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/damon.h b/include/linux/damon.h
> index a4fea23da8576..25345b5f821b9 100644
> --- a/include/linux/damon.h
> +++ b/include/linux/damon.h
> @@ -213,6 +213,14 @@ struct damos_quota_goal {
>  	struct list_head list;
>  };
>  
> +/**
> + * enum damos_quota_goal_tuner - Goal-based quota tuning logic.
> + * @DAMOS_QUOTA_GOAL_TUNER_CONSIST:	Aim long term consistent quota.
> + */
> +enum damos_quota_goal_tuner {
> +	DAMOS_QUOTA_GOAL_TUNER_CONSIST,
> +};
> +
>  /**
>   * struct damos_quota - Controls the aggressiveness of the given scheme.
>   * @reset_interval:	Charge reset interval in milliseconds.
> @@ -260,6 +268,7 @@ struct damos_quota {
>  	unsigned long ms;
>  	unsigned long sz;
>  	struct list_head goals;
> +	enum damos_quota_goal_tuner goal_tuner;
>  	unsigned long esz;
>  
>  	unsigned int weight_sz;
> diff --git a/mm/damon/core.c b/mm/damon/core.c
> index 0ff190ed8a599..1c126d910fe62 100644
> --- a/mm/damon/core.c
> +++ b/mm/damon/core.c
> @@ -405,8 +405,9 @@ struct damos *damon_new_scheme(struct damos_access_pattern *pattern,
>  	INIT_LIST_HEAD(&scheme->list);
>  
>  	scheme->quota = *(damos_quota_init(quota));
> -	/* quota.goals should be separately set by caller */
> +	/* quota.goals and .goal_tuner should be separately set by caller */
>  	INIT_LIST_HEAD(&scheme->quota.goals);
> +	scheme->quota.goal_tuner = DAMOS_QUOTA_GOAL_TUNER_CONSIST;

Ravi found this is resetting tuner setup in damon_sysfs_add_quota_score() in
sysfs-schemes.c.  As a result, users were unable to use goal_tuner feature.
Ravi further suggested a fix that sets the goal_tuner after damon_new_scheme(),
as suggested here.

I was thinking that's the right fix assuming the comment is right.  I was also
thinking I entirely forgot setting the goal_tuner field in sysfs-schemes.c.
But I now find I didn't entirely forget it, as the third patch of this series
does set it on the quota struct that is passed to damon_new_scheme().  However
I was stupidly forgetting the fact that damon_new_scheme() overwrites the
field, and I asked callers to set it after the call.

Now I think the above initialization and the instruction on the comment is just
wrong.  There is no reason to refuse the caller-set value in the parameter
struct.  Rather, it only confuses callers.

I will fix the issue by simply dropping the above diff.

[1] https://lore.kernel.org/20260223123232.12851-2-ravis.opensrc@gmail.com


Thanks,
SJ

[...]

