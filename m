Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A854D10A62D5
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 13:43:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 190446B0089; Thu, 26 Mar 2026 09:43:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 13FE66B008C; Thu, 26 Mar 2026 09:43:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0562B6B0092; Thu, 26 Mar 2026 09:43:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EA1B96B0089
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 09:43:39 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 74A678D04A
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 13:43:39 +0000 (UTC)
X-FDA: 84588331758.20.9B2A770
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id DBB582000D
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 13:43:37 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BXFL1wlX;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774532617;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/wg7a6btFk1VmDMySpNEXAfDTU6wawmqxT+TsOczRZQ=;
	b=FkVAT+PO9dtci8tQNa1f7DVjFiwIS/PoxN3RnT44wyXq9Fu7Qprw0Z8kIp4QQ76RB7pOuE
	Crso3//48BzSfuYpV9+p4o5aZVqewxkPE9ZOUOJfARcurPgUg9JPEMRKBN0iDrE91JgTRj
	2Wno2ukzZNUbEGWfiKJhm5l9kZVG/V0=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BXFL1wlX;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774532617; a=rsa-sha256;
	cv=none;
	b=12pB6BP9k94F9Di8sgS0JwXFjt7P8JJcy/NGYV/YAZaXJazvRXnzZ2c7XS+Aqqck33XXjw
	W3K87uzu+9OYaxfE1WTZM07p4wOsjqV00p0SMdv87C6rg/aJsUyRD5RqDqO9VQwTF8xmSs
	ocsnZfIevQ1CXCbTDURDKtrvQr3n4Ho=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4B1A4600C4;
	Thu, 26 Mar 2026 13:43:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9781C116C6;
	Thu, 26 Mar 2026 13:43:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774532617;
	bh=nk0Mdre4v1viW8JBlbFncIzJhJccn/rmA5Bx5nxUNzY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BXFL1wlXJd4uxRJSa0WrDUDRqCzaFsXqiIKqhJFYJEZRbUCz2RRktkdm1waxjShwy
	 LQWSa/H6/KLntrERss9EHxpp3gBItF5uermP3OjPehZccDq79Kf4VPcW2Qv3qOFyKP
	 TWWZ50aaoQKAUMiDiz90vrKBrL6l/fu0R3R+0AWmG/r6dw0QyBhQeu8hRk28so4f/n
	 IgRdlADsEVsguMIVEqX9xAPFM9JRyQeUcrvlQxvjN9DpUTF01yp/FV/mZk9EBYlXOI
	 lMW0ObYiA+2gqCHIQLCfZF9Vrpz4Z22ajNBvtIDM7YB/Jor/ouBKU/KZqjB8Vy6g25
	 xNIBAVGEZQmUw==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: "# 6 . 14 . x" <stable@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: (sashiko review) [RFC PATCH 2/2] mm/damon/core: fix damon_call() vs kdamond_fn() exit race deadlock
Date: Thu, 26 Mar 2026 06:43:29 -0700
Message-ID: <20260326134330.90521-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260326062347.88569-3-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: DBB582000D
X-Stat-Signature: s46op6u6j3omcad5t1aoyq5rii6sd7jc
X-Rspamd-Server: rspam06
X-HE-Tag: 1774532617-244753
X-HE-Meta: U2FsdGVkX193qWg8D/fpuIWCE95V5Ktjex7m4Shh6Gohs6hsgVf5nNyoe8gfDV6ilLrgF3dyyot9hlRymav/2uw1E/jyUvHRXWqZmB8cOG3kWNZZHrtIdGXkUHSJsbmXasEk6cY9fANx2ACNnXWgyTD69i5kDdfbEMcZ+t/zRmJeN42WHfkN6Xb0HJupcd3VTWjTQIJ2werEwAu1HJ7pLpgU0gec6aZFtNeEiuWZ1Jy/+p7BuCfoSULC+CyU+TBE78fj1OaB80O2TKhCXHXFiIwgXHcGG/sCMmvwRvbgTIn5p1iRxNVFT2tum3Hqq1Aq9YtqAitGNWPtKnRlcJzyRqib+2MzKdhB/BPsYu+Tpfp68MxgJWa2YdN4EWaYeMGJ2ixXa1ux+efSaRS4NxnSMOHkJxVi9lLwrJjP+Ky3eqRc2FYzPnmcOzpQ8ANe6hpzq4qGFYS/N3sZxCsMV20bdxzt1FSvBHhBnNFyL1vCjo1GuXlCcsuoqPdByaGxKcsopAFIsDCSOudjPKcr4dtUn1IUkZPGNDl3TSvKAJMmQ64OQjZ7uFkZPOz+Ld2WAmsnZl9vKUJ/4Rd483ehQOswxZiRLV4MLbvmWTAxn/zr2UciJQZQEft82XnY22eLCtTV81lx2oWUZmRaqUI9betUpPR1j7JbxY6n1zn9Qh3c7EbDNUzTld/+WoBaE0+hzOG4C68mL9gW2mpPXWz+Ro7H/5Q9nBzNMeQPByY9P9U3aSn0QFzdtumT0HTx7CHgldBTotLOaEICaViXX+RL5UvZmATWb6r7X7Q0cvz/GQIasKYWJe9gJ1tpbiRPrQwJEvKX1GUrCkCZt+85kTy1IULa2DB1M+FT1+3lng0VhCgwe3TQKKSYPzBT+KEOPViGU4ra/etRetnS/77GtyfrYc+klraM9w1M6A3oJtX8wybhlC+znIM8H3kocZZR8OwChFCWAwpUtw13MgJsX3+/h0W
 cViT1mM6
 BjmlVBjKW2FfY1ak8AxKalkDN820rWWKHlQCXU4lrytRa0q6Q7jhsbBATfkGJKEz/gPXChh1mL+yzfvKlpoj3GyH73u4xUZ3WaUmjtPd8bKOl0G9whpAChPIhonnAb+bntWbtmFBEYbeiUiO7ZUD7PWEo0oeOilEQJalj/7EJB1xAM7kOXgcmhGrGxYQRchmUoPAGuzTL/QkAVvqtQ8q3MOvQ4LUSX6usU7dHarcyordqyP5Dm4yCo4ZjkJ9q357bLosrmKyoBtHbwo/8NNbdY6oFiHtzfetmLFd8xTo6Yru5ZdBRCXAXUXvd4XxVYRJ4gB1lsEiIQ9oWRi4kGzIsW91wUureGR3iCCkQCIG63dHjMTQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Forwarding Sashiko review for doing discussions via mails.

# review url: https://sashiko.dev/#/patchset/20260326062347.88569-3-sj@kernel.org
# start of sashiko.dev inline review
commit b886bf00a72b1462f29533c91c431cd2ba3fa3a6
Author: SeongJae Park <sj@kernel.org>
mm/damon/core: fix damon_call() vs kdamond_fn() exit race deadlock

This commit introduces a call_controls_obsolete flag to protect damon_call()
from racing with the kdamond termination sequence. This replaces the previous
after-registration damon_is_running() check.

Link: https://lore.kernel.org/20260325141956.87144-1-sj@kernel.org

> diff --git a/mm/damon/core.c b/mm/damon/core.c
> index db6c67e52d2b8..a2b553e2c5a81 100644
> --- a/mm/damon/core.c
> +++ b/mm/damon/core.c
[ ... ]
> @@ -1629,10 +1600,12 @@ int damon_call(struct damon_ctx *ctx, struct damon_call_control *control)
>  	INIT_LIST_HEAD(&control->list);
>  
>  	mutex_lock(&ctx->call_controls_lock);
> +	if (ctx->call_controls_obsolete) {
> +		mutex_unlock(&ctx->call_controls_lock);
> +		return -ECANCELED;
> +	}
>  	list_add_tail(&control->list, &ctx->call_controls);
>  	mutex_unlock(&ctx->call_controls_lock);
> -	if (!damon_is_running(ctx))
> -		return damon_call_handle_inactive_ctx(ctx, control);

Does this removal cause an indefinite wait if damon_call() is invoked on an
unstarted context?

For a newly allocated damon_ctx, call_controls_obsolete is zero-initialized
to false. Without the damon_is_running() check, if a caller invokes
damon_call() before damon_start(), it appears the request will be queued and
block on wait_for_completion() indefinitely since no kdamond thread is
running to handle or cancel it.

>  	if (control->repeat)
>  		return 0;
>  	wait_for_completion(&control->completion);
[ ... ]
> @@ -3062,6 +3038,9 @@ static int kdamond_fn(void *data)
>  	damon_destroy_targets(ctx);
>  
>  	kfree(ctx->regions_score_histogram);
> +	mutex_lock(&ctx->call_controls_lock);
> +	ctx->call_controls_obsolete = true;
> +	mutex_unlock(&ctx->call_controls_lock);
>  	kdamond_call(ctx, true);
>  	damos_walk_cancel(ctx);

Can this sequence also cause a spurious -ECANCELED failure when a context is
restarted?

When restarting a context, kdamond_fn() signals kdamond_started before
calling kdamond_init_ctx():

        complete(&ctx->kdamond_started);
        kdamond_init_ctx(ctx);

If damon_start() unblocks and immediately invokes damon_call(), couldn't it
observe the stale call_controls_obsolete == true from the previous run and
return -ECANCELED, since kdamond_init_ctx() has not yet reset the flag?

Also, is damos_walk() vulnerable to the same termination race being fixed
here for damon_call()?

In kdamond_fn(), damos_walk_cancel() processes cancellations before
ctx->kdamond is set to NULL. If damos_walk() is called during this window,
it checks damon_is_running() (which still returns true), sets the walk
control, and blocks on wait_for_completion().

Since cancellations are already processed, will it wait indefinitely?


# end of sashiko.dev inline review
# review url: https://sashiko.dev/#/patchset/20260326062347.88569-3-sj@kernel.org
#
# hkml [1] generated a draft of this mail.  It can be regenerated
# using below command:
#
#     hkml patch sashiko_dev --for_forwarding \
#             20260326062347.88569-3-sj@kernel.org
#
# [1] https://github.com/sjp38/hackermail

Sent using hkml (https://github.com/sjp38/hackermail)

