Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56587EE369A
	for <linux-mm@archiver.kernel.org>; Fri, 13 Feb 2026 09:22:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 771586B0005; Fri, 13 Feb 2026 04:22:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 71EC96B0089; Fri, 13 Feb 2026 04:22:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 62ABC6B008A; Fri, 13 Feb 2026 04:22:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4E0816B0005
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 04:22:33 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EFE361C3EA
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 09:22:32 +0000 (UTC)
X-FDA: 84438892944.10.2D66486
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf01.hostedemail.com (Postfix) with ESMTP id B35A940006
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 09:22:28 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=none;
	spf=pass (imf01.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770974550;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=I4C01rrA2zD3ihVIrTYns4iRpT7Q5YLcTmxQjkn9W90=;
	b=oWLPG2YIGWy0D55zcZ5Xv2X6TFFc3aY+Xi43TJLsBkRVTV+1SKK8m2jjxNBbO8O3TcKvpi
	1RZCX4y83A9Fjb3e4XxFTtbizy7snau5l08fmD27x7CXxaFvoPXE0eTF3LYEHB+bru+H2F
	XUTjtIkEtTqyXFNtBVE7g/OWKOoBtx0=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=none;
	spf=pass (imf01.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770974550; a=rsa-sha256;
	cv=none;
	b=wx/Ck03Yi0h5diAKpxEulOynoPOFwLiHLugyy0EsH8g40GxsZwpAzOQJlhFKjjB8rNvPU7
	GCUYWfBl1dg1ep+1eBtovFqX5CvLbjV4r0IjyhkYvA7iH5rrirxIkXbby7jZVPF+2vaa8v
	XmxYlosfdDTnXMSkWVJyYB1DDIsfLVE=
Received: from mail.maildlp.com (unknown [172.18.224.107])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4fC6Bj4nnMzJ46Yd;
	Fri, 13 Feb 2026 17:22:21 +0800 (CST)
Received: from mscpeml500003.china.huawei.com (unknown [7.188.49.51])
	by mail.maildlp.com (Postfix) with ESMTPS id EC1AF40585;
	Fri, 13 Feb 2026 17:22:24 +0800 (CST)
Received: from [10.123.123.154] (10.123.123.154) by
 mscpeml500003.china.huawei.com (7.188.49.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 13 Feb 2026 12:22:24 +0300
Message-ID: <eebad564-10c1-4ce9-953d-c859cd87dc88@huawei-partners.com>
Date: Fri, 13 Feb 2026 12:22:23 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] mm/damon: remove unused code
To: SeongJae Park <sj@kernel.org>
CC: <artem.kuzin@huawei.com>, <stepanov.anatoly@huawei.com>,
	<wangkefeng.wang@huawei.com>, <yanquanmin1@huawei.com>, <zuoze1@huawei.com>,
	<damon@lists.linux.dev>, <akpm@linux-foundation.org>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>
References: <20260212154157.75372-1-sj@kernel.org>
Content-Language: en-US
From: Gutierrez Asier <gutierrez.asier@huawei-partners.com>
In-Reply-To: <20260212154157.75372-1-sj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.123.123.154]
X-ClientProxiedBy: mscpeml100003.china.huawei.com (10.199.174.67) To
 mscpeml500003.china.huawei.com (7.188.49.51)
X-Stat-Signature: xd96nt11pnhapxzgd5noi35i64ta3cd7
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B35A940006
X-HE-Tag: 1770974548-566117
X-HE-Meta: U2FsdGVkX19zKF26xMokeGYuZR0mgY1TYKV5foiJwL0fzf7E925gkLf8jLwrQEgT32yoRp5YiAPrCGYe8jum+HJLBm1vfso+pixMmaU+EU8PkgFTHZedkWEzNLvt2wKDob1OQaU1Bd66Avg3sKUs3FX6X6rVp4WSdiToLuFiGnUjEYVdzjSLuTQVoSVJtPhcuiUXvYFFxo9gNT4AxsCd7L5qGQn6WcuMiH6B+woo4kAnFKRdzqXZdSLg2H2pvxeB0UfJypB4S2vLQibd5fEa8LOKrDo/yPC3K3buRb4yKKdRUAXQN+CyP1jJQVYwQAw41DEr42NGoAecfMfb4R8DUI3cMkM+IPvndik5ZLhiv4Y2RG3RdJezvIjwtvDWHQDUcMdZ/gCCHOOJ0Cj3yKCNcUZBN011oC7gTn2pi3A49LR7TTxh7iRFhqCcq9wGUNE2HYEEX7wBpTwaw4kO67ckBZo47SGFPjNPvAqYD6iBT76ir0VcFeCow7xfHkrLgZh4YXUVNhQbAM+5vYEu1tTpH0ulVFZLLWLdGDufDQKeKFEhkDHjwkJyKOCXCkumR2gGR6bZPC10ZtoCBgfOW6szXDNki5C7SmBJ8n7FlxjilKdPvZZ9Av+nIhzeApvyzBBgiEMbER8XvNIDbeXqDoGIF0IXbUfQeXymqF9UVaTPznJ7XBI2Vt8C2ADHEzFm886LwdUy7bpdoxHgkuY93b42R84FBqxXBlpmUrnASjQgB3F1xiLrtl0AX0+43LyDSAE0L+fM5w+ruQPvGNoRCCA7WxT6W/3T/r37tf1zejktkP6vj8piSSW23K2W8kcKgMHaDwXCXzaxvKzI9w+qgXAMjJhHloRW+dlDeWUB7RSQ3x0ymZugP/lxSAk7AzsrMtMSzXIuUpJn9Hx+M2MjW8hdYZuT7V27V1PkYdvACJXRRlrhWdt+3zjjNT8CrbvjuDDhzOJnb+1uPLonh/iqbQv
 SWi4FzAa
 LjIZ43WDduID3a6Czkbtw6YTyeX4ayNy5X1If++k28mZlKyTdAJDqUOB0fNkTgc3HWz7cNOV1yzWRJB6g7I1T5nb61pYWgKlIpdG5Xai94OSdG1xSCed6x3oTM5Ugv1xFb0PnMXbzIreNjG+LxadguyEFDhbvseV/YUe56EEG1vfbUWNPuWaYoYhJWUUZUMuYDMqYCC/kLn4ypD3mLV/0o4nk9JdABoAgemNxa76nCLTyk2xaLQNl39AR6foGCA2EFqbiP6nCt4Sbq4KKGMrcbZQITirPzfHrn/D8KxABfc+7x2b5trLWJ+HqgJ0gFUhzbVdy/QDVpk9K3GpnchMqtZkwuMT8Sq5qCIewlzStWpntiPlpGzl9NMFsESQNptXEDfR9yD3ncf5heku1jKPjXB1hmSASeKLIyrU9
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On 2/12/2026 6:41 PM, SeongJae Park wrote:
> On Thu, 12 Feb 2026 09:43:26 +0000 <gutierrez.asier@huawei-partners.com> wrote:
> 
>> From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
>>
>> damon_target is not used by get_scheme_score operations, nor with
>> virtual neither with physical addresses.
> 
> Good finding, thank you for this patch, Asier!
> 
> The subject seems bit ambiguous, though.  What about "remove unused target
> param of get_scheme_score()" ?
> 
>>
>> Signed-off-by: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
> 
> Other than the subject,
> 
> Reviewed-by: SeongJae Park <sj@kernel.org>
> 
> Also, DAMON patches are recommended to use mm-new as thier baseline [1] unless
> there are other reasons to not to do so.  But I found 'git am' of this patch on
> the mm-new fails.  It works on the master of mm.git, which is a commit of
> Linus' tree, though.  So, maybe this patch is not using mm-new as the baseline?
> Please consider using mm-new as the baseline next time, or specify why you use
> choose different tree as the baseline.
> 
> Assuming you are ok to the subject change (let me know if you are not), I'm
> attaching a new version of this patch that has changed the subject with my
> suggestion, and manually resolved the conflicts on mm-new, for Andrew's
> convenience.  I also applied that to my tree (damon/next), and I will repost it
> if Andrew miss this (as we are in the middle of merge window, maintainers could
> miss many things).
> 
> [1] https://origin.kernel.org/doc/html/latest/mm/damon/maintainer-profile.html#scm-trees
> 
> 
> Thanks,
> SJ
> 
> [...]
> ======= >8 =======
> From e09d66bb116604c9dc5b22540641e991d977ea6b Mon Sep 17 00:00:00 2001
> From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
> Date: Thu, 12 Feb 2026 09:43:26 +0000
> Subject: [PATCH] mm/damon/: remove unused target param of get_scheme_score()
> 
> damon_target is not used by get_scheme_score operations, nor with
> virtual neither with physical addresses.
> 
> Signed-off-by: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
> 
> Link: https://patch.msgid.link/20260212094326.906497-1-gutierrez.asier@huawei-partners.com
> Signed-off-by: SeongJae Park <sj@kernel.org>
> ---
>  include/linux/damon.h |  3 +--
>  mm/damon/core.c       | 10 +++++-----
>  mm/damon/paddr.c      |  3 +--
>  mm/damon/vaddr.c      |  3 +--
>  4 files changed, 8 insertions(+), 11 deletions(-)
> 
> diff --git a/include/linux/damon.h b/include/linux/damon.h
> index a4fea23da8576..9a88cf8d152d8 100644
> --- a/include/linux/damon.h
> +++ b/include/linux/damon.h
> @@ -647,8 +647,7 @@ struct damon_operations {
>  	void (*prepare_access_checks)(struct damon_ctx *context);
>  	unsigned int (*check_accesses)(struct damon_ctx *context);
>  	int (*get_scheme_score)(struct damon_ctx *context,
> -			struct damon_target *t, struct damon_region *r,
> -			struct damos *scheme);
> +			struct damon_region *r, struct damos *scheme);
>  	unsigned long (*apply_scheme)(struct damon_ctx *context,
>  			struct damon_target *t, struct damon_region *r,
>  			struct damos *scheme, unsigned long *sz_filter_passed);
> diff --git a/mm/damon/core.c b/mm/damon/core.c
> index 5e2724a4f285e..925908415a041 100644
> --- a/mm/damon/core.c
> +++ b/mm/damon/core.c
> @@ -1679,15 +1679,15 @@ static bool __damos_valid_target(struct damon_region *r, struct damos *s)
>  		r->age <= s->pattern.max_age_region;
>  }
>  
> -static bool damos_valid_target(struct damon_ctx *c, struct damon_target *t,
> -		struct damon_region *r, struct damos *s)
> +static bool damos_valid_target(struct damon_ctx *c, struct damon_region *r,
> +		struct damos *s)
>  {
>  	bool ret = __damos_valid_target(r, s);
>  
>  	if (!ret || !s->quota.esz || !c->ops.get_scheme_score)
>  		return ret;
>  
> -	return c->ops.get_scheme_score(c, t, r, s) >= s->quota.min_score;
> +	return c->ops.get_scheme_score(c, r, s) >= s->quota.min_score;
>  }
>  
>  /*
> @@ -2011,7 +2011,7 @@ static void damon_do_apply_schemes(struct damon_ctx *c,
>  				s->max_nr_snapshots <= s->stat.nr_snapshots)
>  			continue;
>  
> -		if (damos_valid_target(c, t, r, s))
> +		if (damos_valid_target(c, r, s))
>  			damos_apply_scheme(c, t, r, s);
>  
>  		if (damon_is_last_region(r, t))
> @@ -2309,7 +2309,7 @@ static void damos_adjust_quota(struct damon_ctx *c, struct damos *s)
>  		damon_for_each_region(r, t) {
>  			if (!__damos_valid_target(r, s))
>  				continue;
> -			score = c->ops.get_scheme_score(c, t, r, s);
> +			score = c->ops.get_scheme_score(c, r, s);
>  			c->regions_score_histogram[score] +=
>  				damon_sz_region(r);
>  			if (score > max_score)
> diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
> index 9bfe488268407..5cdcc5037cbc1 100644
> --- a/mm/damon/paddr.c
> +++ b/mm/damon/paddr.c
> @@ -343,8 +343,7 @@ static unsigned long damon_pa_apply_scheme(struct damon_ctx *ctx,
>  }
>  
>  static int damon_pa_scheme_score(struct damon_ctx *context,
> -		struct damon_target *t, struct damon_region *r,
> -		struct damos *scheme)
> +		struct damon_region *r, struct damos *scheme)
>  {
>  	switch (scheme->action) {
>  	case DAMOS_PAGEOUT:
> diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
> index 83ab3d8c37920..4e3430d4191d1 100644
> --- a/mm/damon/vaddr.c
> +++ b/mm/damon/vaddr.c
> @@ -986,8 +986,7 @@ static unsigned long damon_va_apply_scheme(struct damon_ctx *ctx,
>  }
>  
>  static int damon_va_scheme_score(struct damon_ctx *context,
> -		struct damon_target *t, struct damon_region *r,
> -		struct damos *scheme)
> +		struct damon_region *r, struct damos *scheme)
>  {
>  
>  	switch (scheme->action) {

Yes, I will change the subject.

My bad, I didn't try the patch against mm-next. Indeed, as you
suggested, it doesn't compile. I will submit a new version
of this patch after checking it works with mm-next.

-- 
Asier Gutierrez
Huawei


