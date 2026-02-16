Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 649E0E83821
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 18:57:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 31A4D6B0088; Mon, 16 Feb 2026 13:57:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C8656B0089; Mon, 16 Feb 2026 13:57:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A9B06B008A; Mon, 16 Feb 2026 13:57:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 062576B0088
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 13:57:52 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 685BEC428A
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 18:57:51 +0000 (UTC)
X-FDA: 84451229142.30.CD341B8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id C4C02160002
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 18:57:49 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rW8J7eWF;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771268269;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UYJ+oXnvu6tJyXsLMjUOW8mQfyvATea4vw2Nrcc5YlE=;
	b=zTytCyBAdvzS22LeGg08dDYMBUH7ysPZelnyjVTR4F9EYlxjxsrQadttR0kSvoRKQjLtNf
	qC/t6xBVR05fho9TTcZdQPzWEeaDXBw7jxyZcqxDgN63tM7M7a7c8W7ueJkSONTQCBqzqm
	/jiOYL1Xu9Rv34Glk3KGLy1e555pKes=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771268269; a=rsa-sha256;
	cv=none;
	b=F8RE/eAtBI41zXvw4P+lNpWzSPqkrSRA60/3NR7Ak/RiYEVqUtzh0JAG/k0LEoN9k6L2Ia
	yAEtcKrECCsKNZ5FQxVdRJFAFXYEJkU7cIHpD1wqdmzGCwNaH9tpGxS7EILnpyIfFBvmTD
	RfrCC5bpSvlGBPUX+k/HmxCMPw1Ch8k=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rW8J7eWF;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E9BFB6013F;
	Mon, 16 Feb 2026 18:57:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B6EBC116C6;
	Mon, 16 Feb 2026 18:57:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771268268;
	bh=lQ2xyyBLXyHLyreiYyKcm6LlV+Vy+ZHITtyVg+hPIgg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rW8J7eWFtzv1ZCG2v/ALJTmtLtZEVya180Dgfva2dYVX3PjHEjHg71QpvT8BVRtF4
	 hyHW6tcINHuH7LFFbmSsPp5RmBp4V6+hTf/qK3akLn4aazKKh/g+I2pbRmmuV8ioJJ
	 x4dbgreuc2NcmjhQ1m7zkZhrJzz3p1wT1ow61OeEv+eHY/WIIHvmvVSriRWobFUzt1
	 XwXv2x/Zb6NHY5EjArVB+AdRKjxz2XxNyorXMQKnB4pcjrY7eguoxVraM1PCRFOKB+
	 r+1Bt5AQ5dXf6oWtxNPgYH9kmT2nFH+E7WZDxbPzWn0a35zVmAE7K80g/X4BkshOJM
	 zSDV3W7k1Unqg==
From: SeongJae Park <sj@kernel.org>
To: Raul Pazemecxas De Andrade <raul_pazemecxas@hotmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	Greg KH <gregkh@linuxfoundation.org>,
	"security@kernel.org" <security@kernel.org>,
	"damon@lists.linux.dev" <damon@lists.linux.dev>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] mm/damon/core: dangling walk_control pointer in damos_walk() on inactive context
Date: Mon, 16 Feb 2026 10:57:40 -0800
Message-ID: <20260216185741.74145-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To:  <CPUPR80MB81718B12798BCF9959535B05956CA@CPUPR80MB8171.lamprd80.prod.outlook.com>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C4C02160002
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: mniuqq3swrzx9qy6egahsgrinw9s86cp
X-HE-Tag: 1771268269-679952
X-HE-Meta: U2FsdGVkX1+bK6fb8aKph/6aL1lNIdBVEjtqIJuBiUcNGlTy9fOUL0O+42D1e8cuQbTF0XBQdaTlSYdX/rcz16N4SGyk8y6y8CtV6JGn8tgx1TrLUci5CJUqad8s9oQo7lFl1Utik0FF3Hjl9rOMw+w4ADRQCAyOjDTKaHq+t+Mg6jTElNMEKvPrGy/oUgglS5L5jsNFz9cZa8TZnUyC3/ql0PiD1dG3KY69GvRKzxVM0WXji10Yd+ISMCvD9/YioYpTHd0D17eY/71ibOFSQm9h/R+aJ/Y5TO1uXH0DIAIULZpiPcbhMwlUae52piK7N49Xte6Vft0/YsncdK+GCth0gsapdahWopTzOwdShWl9iG8ZnVEnQFhaZgElZlzLR/aqAOx5pGrD5Ux7vQzudF+FiOuYhdRd+uHNsmF+AMVGJd+iXR4ZyQJASq7/pnodvZV//AKeJ5Jpp3seIYx9RaLEDogH/nRN7s2ay/ZQ71kvHoLhDr53OpHggDs2DjL/oyPg3qmKfuGhYeTWMIeERI8q72GAMYZbEPJatCpCNTKFrEx5/1GCAWsdDlkaQbgUAAY1V039bHAoa2iy9mekU9Ya4dG3PthOSEXTxFjPDMjUW4070rrv8tddzeGFxu4tDyKqVpKq5Pg4UvPausx5RUYwStQv7hlJbKN6WiaEXrlbI9dhFct90LNQuCYHuLMU1LwqL4QGCfotW7SN+bPRsWjWAzyvsdSYYiGedJZ4sG8oedJOt9Pncc9w/qmVSaQHHuiFOV+5aZPoL+g/WylIqB/NVupiY9TALNTo9AXdoC8s0LRcjRb/rLr7d4Xtjw9y9vL2dsCIiTU/EvS58F3l9IiqZsEF7MUSkrohw6UwE3T6MIMnQR4ECVmo+qpazoasaPjHVjx1jHRXqM96ARebbFaqDlrnUhwDjAMHokjL9VtxCqeXNxfc3pMQVlQBgJjkkYdsb/tPPKcBfEJNUKp
 Q1Dl0W5y
 AS7/w7Vf0SjEvOkt2u+fuIqdRzE3xu1DUqSCnBCoa183istj+4wL3Ks7QjFAAcQt9JpkeuEYdSBgHuvoGdyOjyVeZL/SZYWkgJOO4KlyBpZJuVhGfmGdeuVAYvv2YV+pfvoyyZppfFGUp94t4MDdUQzd/3iLItk1z0L/BP0ZKnfzmwEsYcvUiCBBKT/adzJak/tuZx9j0ExepcHS02kUgF/69sXH8pHphLZGEiLFKInUPPJe1pVokHzRyiQ/KqOEcL9s+/L2bATGU9H7P8kYbch4fHi5WCZMhRM7rDO99rP1nyuCKf0HrkZwECydRiI+lreM8a67NoNNKlNT/2jUXenVzRYnTrbjlwRXfoxH5aSGJ8Br53TBZVhfmvVAAt1iDbCwoqXvT3c1ZUzv24Yz2MSLUMKNG7xczHXWs0Il7IjhY+2s=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Hello Raul,

On Mon, 16 Feb 2026 16:26:22 +0000 Raul Pazemecxas De Andrade <raul_pazemecxas@hotmail.com> wrote:

> From 7d82f231f99949d041045789d3ed912ad7e25546 Mon Sep 17 00:00:00 2001
> From: Raul Pazemecxas De Andrade <raul_pazemecxas@hotmail.com>
> Date: Mon, 16 Feb 2026 13:06:04 -0300
> Subject: [PATCH] mm/damon/core: clear walk_control on inactive context in
>  damos_walk()

Seems you copy-pasted this patch on your email body.  It is more usual to send
the patch as a complete new mail thread, using 'git send-email'.  Please
consider doing so if you send a patch again, next time.

> 
> damos_walk() sets ctx->walk_control to the caller-provided control
> structure before checking whether the context is running. If the context
> is inactive (damon_is_running() returns false), the function returns
> -EINVAL without clearing ctx->walk_control. This leaves a dangling
> pointer to a stack-allocated structure that will be freed when the
> caller returns.

Nice catch!

> 
> This is structurally identical to the bug fixed in commit f9132fbc2e83
> ("mm/damon/core: remove call_control in inactive contexts") for
> damon_call(), which had the same pattern of linking a control object
> and returning an error without unlinking it.

Correct.  Nonetheless, the user impact is prettry trivial compared to the
damon_call() bug.  Let me explain why I think so below.

> 
> The dangling walk_control pointer can cause:
> 1. Use-after-free if the context is later started and kdamond
>    dereferences ctx->walk_control (e.g., in damos_walk_cancel()
>    which writes to control->canceled and calls complete())

But, there is no such use case to my understanding.  DAMON sysfs interface is
the only damos_walk() user.  And when a user asks it to turn DAMON on with a
context that was used before and now stopped, it does not use the damon_ctx
object that was used before.  Instead, it deallocates the damon_ctx object that
was used before, allocates a new damon_ctx object, and use the new one.  The
new one doesn't have the stale pointer, so no real issue happens.  Please let
me know if I'm missing something.

So this is a good theory for potential future bugs.  Nonetheless, this is not
what can happen right now in the real world.  I agree the pointer is better to
be cleared as this patch suggests, to reduce such potential future risks.

> 2. Permanent -EBUSY from subsequent damos_walk() calls, since the
>    stale pointer is non-NULL

This is the real bug.  Returning -EBUSY while DAMON is turned off may confuse
users.  Nonetheless, this happens only while the DAMON context is turned off.
If you starts it again, DAMON sysfs interface starts it with newly allocated
internal damon_ctx object as I mentioned above.  The new object doesn't have
the stale pointer, so works normally.

For example, after the reproducer steps in your bug report [1], you can show
below:

    # echo on > $DAMON/0/state
    # echo "update_schemes_tried_regions" > $DAMON/0/state
    # echo $?
    # 0

Again, I think this is a real bug that could make users be confused, and
therefore better to be fixed.  Nonetheless, calling damos_walk() against
stopped DAMON context seems not a common use case.  So I think the real impact
is trivial.

> 
> Fix this by clearing ctx->walk_control under walk_control_lock before
> returning -EINVAL, mirroring the fix pattern from f9132fbc2e83.

Sounds reasonable.

> 
> Reported-by: Raul Pazemecxas De Andrade <raul_pazemecxas@hotmail.com>

Closes: https://lore.kernel.org/CPUPR80MB8171025468965E583EF2490F956CA@CPUPR80MB8171.lamprd80.prod.outlook.com

> Fixes: bf0eaba0ff9c ("mm/damon/core: implement damos_walk()")
> Cc: stable@vger.kernel.org
> Signed-off-by: Raul Pazemecxas De Andrade <raul_pazemecxas@hotmail.com>

Reviewed-by: SeongJae Park <sj@kernel.org>

> ---
>  mm/damon/core.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/damon/core.c b/mm/damon/core.c
> index 5e2724a4f..fb00879af 100644
> --- a/mm/damon/core.c
> +++ b/mm/damon/core.c
> @@ -1559,8 +1559,13 @@ int damos_walk(struct damon_ctx *ctx, struct damos_walk_control *control)
>       }
>       ctx->walk_control = control;
>       mutex_unlock(&ctx->walk_control_lock);
> -     if (!damon_is_running(ctx))
> +     if (!damon_is_running(ctx)) {
> +           mutex_lock(&ctx->walk_control_lock);
> +           if (ctx->walk_control == control)
> +                 ctx->walk_control = NULL;
> +           mutex_unlock(&ctx->walk_control_lock);
>             return -EINVAL;
> +     }
>       wait_for_completion(&control->completion);
>       if (control->canceled)
>             return -ECANCELED;
> -- 
> 2.51.2

I also found 'git am' of this patch is not cleanly working on mm-new.  Please
consider using mm-new as the baseline [2] next time.

To ensure this is not forgotten and merged into the mainline, I added this
patch to my tree, after manually rebasing on mm-new, adding a note about the
user impact, and adding the above tags that I offered.  Unless I find something
on this patch needs to be changed, and you mind, I will post it again after the
current merge window, to make sure it goes to the mainline.  So no additional
work from your side is required.

Nonetheless, if you prefer to make a new revision of this patch and repost on
your own, please do so.

[1] https://lore.kernel.org/CPUPR80MB8171025468965E583EF2490F956CA@CPUPR80MB8171.lamprd80.prod.outlook.com
[2] https://origin.kernel.org/doc/html/latest/mm/damon/maintainer-profile.html#scm-trees
[3] https://git.kernel.org/pub/scm/linux/kernel/git/sj/damon-hack.git/tree/patches/next/mm-damon-core-clear-walk_control-on-inactive-context.patch?id=398e6f536b37de82f789d74ea93815dfcb129d99


Thanks,
SJ

[...]

