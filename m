Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 502D5E776FC
	for <linux-mm@archiver.kernel.org>; Thu, 25 Dec 2025 01:07:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7ECBD6B0088; Wed, 24 Dec 2025 20:07:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 79BD36B0089; Wed, 24 Dec 2025 20:07:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A6F06B008A; Wed, 24 Dec 2025 20:07:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5654A6B0088
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 20:07:33 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EA7B7590FD
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 01:07:32 +0000 (UTC)
X-FDA: 84256205544.13.EEFE23F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 2DD1D100003
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 01:07:30 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=A7n7o4qI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766624851; a=rsa-sha256;
	cv=none;
	b=CnRFIA2Q3Nzl4xlmH+I8At1pKoYdFN6vdsAjEUQ7yEZdhEb7+mtMHPHIquMvnC/BCiCnG0
	YbIbTnyW4G8QaYA9FYzl6/Jc9IoDRoquOGwKQxCvm3RyLCC+HVXU1eJ+C6IDqlWZzC9Zn0
	lTgMBMGpKGuIL5d52xLWyzxptoguJwQ=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=A7n7o4qI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766624851;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JYa+Is0jCuiC2GwAKkj6CRxyaNn50YQeURlP48oCBdg=;
	b=p9vTcrC19AC8WjqP0lxWWb/xIMuZ8jDw9cPnajQ8cTJ39gaA3Z5qjpwJINMipYmbwmdpcX
	7fPrEtTU5yb97yG0fW73Crlsz2QHBddoiphuo46y2Ttjk+MbJRs2ySggkC3547dBm4KjPE
	iDjiNKwNRab4AoxmWt2DTqx2D+GpP9w=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CD50640345;
	Thu, 25 Dec 2025 01:07:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A0F4C4CEF7;
	Thu, 25 Dec 2025 01:07:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766624849;
	bh=AI9rBkTfUwqknwjaDpIIAVHasx1YLalXCFloURsFIag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A7n7o4qIqBAS50cMbyAzX2vGXpbmTQTH8YAawbEinmTeKB/ThmYU5wKvETkRKsTyb
	 eeAjlx5DoF4vlDOh8Bw3QuN5nXIRPbE+zb3DAPAoyEQ6zBaFM11hV2n4o9LEUqgfby
	 26dq65ASK+wE4v2ajYjM42VZlN08X0scfGCWeCJRktJhHT9FwZFo3wFpKOcA+5mEGX
	 MDp8ja0uGqwKxqs3fPuOcCf3URFBfYogLMwSaY5FndsSlrodZ7CRQTsD+Hjo362dbn
	 9qFQze58t/Ur/qcTj36gnP++vHy9pJNozh2aOIJ4SZxVYIve3Q5bSug1jTc10UaNDe
	 wwbsqX8svz5NQ==
From: SeongJae Park <sj@kernel.org>
To: JaeJoon Jung <rgbi3307@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	rgbi3307@nate.com
Subject: Re: [PATCH] mm/damon/core: modified control->repeat loop at the kdamond_call()
Date: Wed, 24 Dec 2025 17:07:21 -0800
Message-ID: <20251225010722.14746-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251224124355.31667-1-rgbi3307@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 2DD1D100003
X-Stat-Signature: kppqergtd5ifoqd38b9jatnw4tq3jfye
X-Rspam-User: 
X-HE-Tag: 1766624850-183368
X-HE-Meta: U2FsdGVkX1+ppsqI5VlZIGX77E5Gd45Qop0dlw9OQattL5rMAW0VoonN6KDXuXMy9DxUyepetcNJWFM7ZI5cSqGBql1BPN6nSlGyPltpkKuAfLz24/PIIhd1ebsRsZMKb9k0DWFBfJO548lLw/+UGtjV3VwrvEadKtzl4nDbB8LalGxa6JCAxcPB5o5pKoWPSS/doCqzNDYjufy5jnED6BTQx5dOsyvD75RV8NAyJtcReT3p2Mufr6too+9LaLt7kvBzHo5sA5xG23nrFOqEXzIU/W55AlFtuzv/L5xQg4IW1rmK7FTUShRFa//RAKmBHSsjliN3A8VzYwQa/EPxhflwk8hAeDrnVbbYKuvMmLAHICG38UiNy+cFwPxcJ5nR1IpxjbXh2+WwSDSnIHyz7kqhEGyDYGNjSpyvgh5Mmn8UqtxUCzwciCOoTkDqCJPwR5TY3qaHZb6+bKFySHWnkfQe2Opb4DFEVTPvZm2GEf8s8UjTH9qNrGlmIsS2I9L48A8KdzqhnNHI+58DB8hAorsdz3P54fvbIr8HLXT92eBHbcMWNjrnnIxgmw73QkGe2KOq8KFKxNZT02Vxin0qWRVwWP1io4BHuB6PisewotISAQsf5m6rzduiIvKq7OxqvArDk0YbyvEH2GAvOchXe7QSW3q7FCvcbAQGo/f+rO83gjgxZadb6p5bhOVvijfJpoSlx9dBsrGgeQ764UP5S8QN92EM8r3dr/+UpckmubfDVzTY46yspoT8Ol653JvPNnTweWqbUqgUzizru+4cBaWgGOY9LWCBMB7sFl1h+uT0XC+78tm7MCiwJQQxxuUketdu8qK5eHwA1wVeombtUQs/d/hxKmCFBV/RWTIyx9KRP8dbsU2wM1r4W7Xes7h4lMpDtoosQqFUxhtjWxL0PdEJySoFfEc50+KTlCufxd6Q7dsBg9cTDFy+993g+Zdipw7ZvEnqWhGRFXyAXob
 lJQDHo79
 kElJpek8hL3HWidiMwm0BIhecrUYurTcdR8ZpFhgozb7sC7RDtezVmskxwW58VryPPfpX2QV6v1w/NdGNmCKVMs+JcUBcmo8xHHqThe5LEhkWptdw9k8XHCElwD6MnI6+hVpc1ohDQ7+8VrdKZiLAO8x1evcmoG8SJZAHDA5Sah45GBRN3pFiljDHVGFM9bl9VpvG6IMv/OZdO1RnHw/IxcrwF4nfOZD9S8/MheZj5fdeQgpdV1II0otZl6cXqxsWw4Mx2c6sdskR8L1D17DYDNA7iA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 24 Dec 2025 21:43:54 +0900 JaeJoon Jung <rgbi3307@gmail.com> wrote:

> The kdamond_call() function is executed repeatedly in the kdamond_fn()
> kernel thread.  The kdamond_call() function is implemented as a while loop.
> Therefore, it is important to improve the list processing logic here to
> ensure faster execution of control->fn().

That depends on how critical the performance is, and how much complexity the
optimization introduces.  I have no idea about if the performance of
kdamond_call() is really important.  If you have a realistic use case that
shows it, sharing it would be nice.

> For ease of explanation,
> the data structure names will be abbreviated as follows:
> 
> damon_call_control.list: C.list
> ctx->call_controls: CTX.head
> repeat_controls: R.head
> 
> the execution flow of the while loop of the kdamond_call() function,
> 
> Before modification:
> Old while loop:
> 
>         CTX.head <-----> C.list <-----> C.list <----> C.list
>         ^                   |                           |
>         |               if (C.repeat)            if (!C.repeat)
>    restore: only one        |                           |
>    list_add_tail()        list_del()                  list_del()
>         |                   |                           |
>         +                   |                       complete()
>         R.head <------ list_add()
> 
> To process C.repeat above, we use an additional list, repeat_controls.

Your above abbreviation didn't explain what C.repeat is.  Maybe you mean
'damon_call_control.repeat'?

> The process of adding C.list to repeat_controls and then restoring it back
> to CTX.head is complex and inefficient.

I agree.

> Furthermore, there's the problem
> of restoring only a single C.list to CTX.head.

I had to take some time on understanding what this mean.  And it seems you are
working on an old version of the tree, and therefore saying about an issue that
already fixed by commit 592e5c5f8ec6 ("mm/damon/core: fix memory leak of repeat
mode damon_call_control objects").

Please use mm-new as a baseline of DAMON patches, unless there are special
reasons.  If there are special reasons, please explicitly specify.

> 
> Below, repeat_controls is removed and the existing CTX.head is modified to
> loop once(1st rotation).  This simplifies list processing and creates a
> more efficient structure.
> 
> Modified while loop:
> Not used repeat_controls:
> 
>         CTX.head <-----> C.list <-----> C.list <----> C.list <-------+
>                             |                           |            |
>                         if (C.repeat)            if (!C.repeat)      |
>                             |                           |            |
>                           list_del()                  list_del()     |
>                             |                           |            |
>                             |                       complete()       |
>                             |                                        |
>                           first --------> list_add_tail() -----------+
> 
>         if (C.list == first) break;
> 
> Signed-off-by: JaeJoon Jung <rgbi3307@gmail.com>
> ---
>  mm/damon/core.c | 37 +++++++++++++++++++------------------
>  1 file changed, 19 insertions(+), 18 deletions(-)
> 
> diff --git a/mm/damon/core.c b/mm/damon/core.c
> index 824aa8f22db3..babad37719b6 100644
> --- a/mm/damon/core.c
> +++ b/mm/damon/core.c
> @@ -2554,42 +2554,43 @@ static void kdamond_usleep(unsigned long usecs)
>   */
>  static void kdamond_call(struct damon_ctx *ctx, bool cancel)
>  {
> -	struct damon_call_control *control;
> -	LIST_HEAD(repeat_controls);
> -	int ret = 0;
> +	struct damon_call_control *control, *first = NULL;
> +	unsigned int idx = 0;
> 
>  	while (true) {
>  		mutex_lock(&ctx->call_controls_lock);
>  		control = list_first_entry_or_null(&ctx->call_controls,
>  				struct damon_call_control, list);
>  		mutex_unlock(&ctx->call_controls_lock);
> -		if (!control)
> +
> +		/* check control empty or 1st rotation */
> +		if (!control || control == first)
>  			break;
> -		if (cancel) {
> +
> +		if (++idx == 1)
> +			first = control;
> +
> +		if (cancel)
>  			control->canceled = true;
> -		} else {
> -			ret = control->fn(control->data);
> -			control->return_code = ret;
> -		}
> +		else
> +			control->return_code = control->fn(control->data);
> +
>  		mutex_lock(&ctx->call_controls_lock);
>  		list_del(&control->list);
>  		mutex_unlock(&ctx->call_controls_lock);
> +
>  		if (!control->repeat) {
> +			/* run control->fn() one time */
>  			complete(&control->completion);
>  		} else if (control->canceled && control->dealloc_on_cancel) {
>  			kfree(control);
> -			continue;
>  		} else {
> -			list_add(&control->list, &repeat_controls);
> +			/* to repeat next time */
> +			mutex_lock(&ctx->call_controls_lock);
> +			list_add_tail(&control->list, &ctx->call_controls);
> +			mutex_unlock(&ctx->call_controls_lock);
>  		}
>  	}

Let's suppose there are two damon_call_control objects on the
ctx->call_controls.  The first one has ->repeat unset, while the second one
has.  Then, it seems the 'break' condition will never met and therefore this
loop will never finished.  Am I missing something?

> -	control = list_first_entry_or_null(&repeat_controls,
> -			struct damon_call_control, list);
> -	if (!control || cancel)
> -		return;
> -	mutex_lock(&ctx->call_controls_lock);
> -	list_add_tail(&control->list, &ctx->call_controls);
> -	mutex_unlock(&ctx->call_controls_lock);

As I mentioned above, apparently you are using an old version of the tree that
not having commit 592e5c5f8ec6 ("mm/damon/core: fix memory leak of repeat mode
damon_call_control objects") that modified this part.  Please use mm-new as a
baseline, or specify reasons why you cannot do so.

>  }
> 
>  /* Returns negative error code if it's not activated but should return */
> --
> 2.43.0


Thanks,
SJ

