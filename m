Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 009FEEE3698
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 16:51:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6785E6B0005; Thu, 12 Feb 2026 11:51:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 621FE6B0088; Thu, 12 Feb 2026 11:51:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54FB16B008A; Thu, 12 Feb 2026 11:51:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 466C46B0005
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 11:51:44 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EF7A056F6B
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 16:51:43 +0000 (UTC)
X-FDA: 84436396086.16.B303613
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 3582F14000B
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 16:51:42 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QecM5KFX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770915102; a=rsa-sha256;
	cv=none;
	b=DCyb4IRIKwlRb4np2XEYb5anlbxDy/71XmVUByrlMOr7fgBBzIKozpqXxZora/QTkwXHV/
	sg8RspLbAiT3g4QleI/bsnQC5vgNNltO5Hw/AcNccV3uruOolZz2/b9PqRgxd9mvv5kwPN
	Yce8MQqnRYXKHxD22mGFXodZ5k/1UkU=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QecM5KFX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770915102;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SoXGKJitXtEfJxnrMiFt262gYsfAdaNXd+LJOhXiPKA=;
	b=w8dbblpwMGL01TbT+IJSvB3Y7rFn5Udm97S56T0eAbt84s4DfUtkUQ+/NP+hVqSb2yBQ4l
	Ig8YA8eOSGHsYbS7Q/rJYNg+YBBvlPgH/kFePEX4mXEDMYlHA9V0NXLaHWzn1Y9wL+8UMG
	9mylcx5YmtnmrMObLUF4tCP2g29JkdU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0FC654386C;
	Thu, 12 Feb 2026 16:51:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F655C4CEF7;
	Thu, 12 Feb 2026 16:51:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770915100;
	bh=0Tmwn34HgUslYUvP6qlQX3bMzbD4sMxV/6/jElQ4/+s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QecM5KFXi86YDdrbPZ0f7tNdAolbHfUbqAofTXm2hWRh66PB4515vmkKgXGyfQ4I3
	 KcNAkuDbnAzC3+XjAlYIWwwtSgXkEf5NnGKbVQ+hC9rOhj31jInqzuFsbhs0X/aV+A
	 +SDUVY5jgmd1Gl+1UQ61ak9/jijhj+yOQS300FVXjh4L3O8vt6TTJgO7VPnXEW21B/
	 yigYv3+WaefpM+QgFenKhX/ijhywsuC0bsbfgI8d64RzYN6GrZATE4xg82ZPDDoyxc
	 em6nMXgrZUO+NEa8SYs26w01KDiF52OhNbN0q3OPEW1zdFyUD5JOBWH8/fl6CtJwfX
	 TAKC6GLJsNtQQ==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: gutierrez.asier@huawei-partners.com,
	artem.kuzin@huawei.com,
	stepanov.anatoly@huawei.com,
	wangkefeng.wang@huawei.com,
	yanquanmin1@huawei.com,
	zuoze1@huawei.com,
	damon@lists.linux.dev,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] mm/damon: remove unused code
Date: Thu, 12 Feb 2026 08:51:37 -0800
Message-ID: <20260212165138.60213-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260212154157.75372-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 3582F14000B
X-Stat-Signature: xao1ycyt3rnkfdzwrno7d3q6n1bgykyu
X-HE-Tag: 1770915102-907729
X-HE-Meta: U2FsdGVkX18CiUj7GzR6ytM/F2CH1UAb47hsVaCvCOm8P0AjYi+Z7iX+FhE9tSqKh0fSY2GGqvaPC9TEgMW6RGSO+LmDKoPDYu2fYezXifQi2TcOZhNnWkQ2CiHtfvnjA1Id36BBlCNYz5dJBwv+igV7NxHvIAujK41axJYAtOoTvqW6t0jcubbZUGnDlyE5ZGG5crus0N5z111wIzu2VOiIB/vFIEkGv0Gnn/8GysVTyNa4EODxGWr/Hayq1qd9NvSCLaxkcGpgPiAgxjrY6YBWOa27Q7PpgbT2SN41wYvK9C/po0wJ4ESxrBZRO5dC/QL0Z7LJic7W8ibUsRDkR6/MM/7/x3bji33Aj6uWWk3aGiHEdS9fmevU9nFDjR+GdbCCHLXA2LkpPlihl9S6dCZZy8YkIdJfob73D/ElNm9UFFrPpC4eLiFsK+1+oYwPHFl4HQllHbjBd9gAGmjK+3fgF3MHuR36RDpZiDlgTJ7vneQJjqFvfA8PxH+T2/DOt8JbOQQzwN+RplVrKXKIwR6tg7e3puZ7ybJG5Kl9N5wgTlVN9oelrYP2cq9MT39TZlIV9aG4YGhLW0bkeQBFKFheF/qPpbKou+itSLVW6XSVn27QOECthePMNu3X9Gd/ZguTxs1+b0QkZxj+AU/Pwh4xGFXUbdrLCZUwJaHUpapu4p53OF/cXclB2C0rV/puatZobh50cFuLuH6Wf7d80gl5L+7uy2X2KesSHtDpSDESIvSQNaofwxBb+Sqx+BTGQCoKCCISjnQr+oL4auNIBOFvkp32eKJzZJcCpZMDPA6EUkk7fmB0WADTlEwKnjYBuROSlae+nu84pBUmRr7oV4+mvASHk1PCYePG9KKiklz7cjpQ10wfLFKu2eP5B850yMGZYDJ2QtYyk6rca1hhyRPQF2UELPNmFn7ujKE2eIxMiLjaOfgFqTKziK/XOhbu9rmqFWoUpa4SIbzT9fd
 LztVj3c4
 Eq6UoEj/M41emozs4oNVo8KoeMGSZRwPA2J7wGwTqyKsz6zCuu7BchWONfy7MOubl5MboJwvPZdVJL5GZ8MyqSxIajXdesKi6FJ4evNbPHCkVVQOQOT4GiX6/mQgDI+ne0ThWJ8OCkHFyTyZ5j5fsQbjtHa/zzxbb7LNPiBeu+kqxV1fYxZFZfkv+ptd32Y2ozUfo5bZufKHANvpt/K0oKe0B4gGoBey0Bm/0oYBbU7jgcUVaiGBp69kbXCYMAGvDUOiFqWLtcGZI8e6AVu9KAhnvx2VAyZieU5gREwgtKaMWEhIQChlnIxUa4rnulpfZlnqv4VTOlXOWatd0zz5r6CShwNz0Q/DL8rA6VsfMIUQTBXX7TbQTsvfmNj9i3/L+LKP6LVShLlH/9u1pRT27cv+Yh8wMvpL+xN4DI6K/dEmbGnM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 12 Feb 2026 07:41:56 -0800 SeongJae Park <sj@kernel.org> wrote:

> On Thu, 12 Feb 2026 09:43:26 +0000 <gutierrez.asier@huawei-partners.com> wrote:
> 
> > From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
> > 
> > damon_target is not used by get_scheme_score operations, nor with
> > virtual neither with physical addresses.
> 
> Good finding, thank you for this patch, Asier!
> 
> The subject seems bit ambiguous, though.  What about "remove unused target
> param of get_scheme_score()" ?
> 
> > 
> > Signed-off-by: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
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

Oops, I attached an old version of the modified patch that not adjusted this
tags area.  Andrew, if you pick this up, could you please add below together:

Reviewed-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

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
> -- 
> 2.47.3

Sent using hkml (https://github.com/sjp38/hackermail)

