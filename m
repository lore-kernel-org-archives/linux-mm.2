Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50535E92FE3
	for <linux-mm@archiver.kernel.org>; Tue, 30 Dec 2025 02:41:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C4016B0088; Mon, 29 Dec 2025 21:41:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 247276B0089; Mon, 29 Dec 2025 21:41:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1536D6B008A; Mon, 29 Dec 2025 21:41:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 03CFA6B0088
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 21:41:35 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7ED025E564
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 02:41:34 +0000 (UTC)
X-FDA: 84274586508.06.F96AADF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id E54364000E
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 02:41:32 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VZg1G1wE;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767062492;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TgPDnL2FftS4uTK/Jto5OZqJryYXPh+AY6NxEKMVFvc=;
	b=4g5xu0Qy2BiVferQG0euBUpcNOw8TIBElpgpnd0vi2X7QUwMpGwGLSUGAbODvfSCxdIrfU
	tTQZMRA9bOT7bxcfS0ni2aJAFPic5ma/qZ+FBXlmaYTJLjsOMEMJ3wDP73mxCAvSjllPU+
	ETS2SPXhck9LPsr5JZD/LytzJP3vsZ0=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VZg1G1wE;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767062492; a=rsa-sha256;
	cv=none;
	b=qEg8ZIPv7nodTpTHMjc3S5D49spOf+nc9DVlpWXIKhquGu2dUUlaAa3ycnfprOhprwhvJW
	YW+PopPffDEjcVfFZnKmP0HVXdCPJQZW2Kcqb9R+/unJhspStYw3Uys6OZeDIKdwmG7NJc
	uo2RZNtLmayiKJc4RYhp9NRMv4xcvlw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 25D5D6000A;
	Tue, 30 Dec 2025 02:41:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B264AC4CEF7;
	Tue, 30 Dec 2025 02:41:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767062491;
	bh=E7R2JNPP0Sm+zHEC5831SvjLWutIcdgzGdYdaqNbxA0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VZg1G1wEqOMDnaRYx1lMVafjCwInzBKXz9x5AHA/6WN8a275yIh/MWHlGzC+/HzaP
	 QmTBKqR1TQS/seMWat8mfljG/YAQw1xKaiwVI0Rhc1DJot+/3GmP/g5tlY6yEPIEl1
	 8H08P3ySMRGtLe48DU8gBZIy4XXLweRDsp42xmcerGQKNIydDyrPkC7vaAMIbU8v7s
	 6KwMuLC39Soj4mjmqyr7Q0bcYkf4vPnkimWc/JCrpkKZcdeNwlBHk1nzflrk1Am5Gx
	 LSnrsru6IBazzZOY8IGlQZeSRQc4ZJLL8YTiHbVnZbIUlg9a5IlXcNFav6hSddu//i
	 4xXZ0eMHZP1iA==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	"# 6 . 14 . x" <stable@vger.kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	JaeJoon Jung <rgbi3307@gmail.com>
Subject: Re: [PATCH] mm/damon/core: remove call_control in inactive contexts
Date: Mon, 29 Dec 2025 18:41:28 -0800
Message-ID: <20251230024129.47591-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251230014532.47563-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E54364000E
X-Stat-Signature: 9r5q8zcanr3z778ctebgnobcyncg8tzq
X-HE-Tag: 1767062492-603673
X-HE-Meta: U2FsdGVkX18PmhK7YlGUkJGKyfr7c5MsddtS04WmXIy5de4jOuZ3NekBuTT9Ovxj269pnPh+n8HUexW5vRTSkLPu0bA0YykSn9vjlIpKior8ht2ThGTi8E7SXUPNpx+2fsgrkRIg3Yqu0C9mNnHQsfCbkiSjiO+SD3Y76nixvNmlpdeIuCPQScq3e9pewEALavYtWmR3mr9Q+i0tEi+pYc+44r61VhJiRxxG0g5YsxRaljk+jH8vaZZQfytBeV+2cJmH4VC0yNmTF/VbgEg9Z2gTBz2sER8R+fdCftak/IpzbgYVZhhrdw5Qul06KjrG1RPVwYlvFTUVjktIsejgP0eBsklQcaNPxuu06iFwELxYAOwEOk4krFGnwJaxTqXYB/RUdrFmY8dOBWscXeZ8Frukw61beh2vnBKVDaRNbpcMN+MmcyHqxQcAIUsPSJVkGpsK0QSPfyU7B6dO3x43JlXnUDQLB67XXNkwscMUUVwft6Xd5QsYBf068VwCDkU+HK8mAU9530csKA5ksryBI1Pc+Eg2xawsStTJ9ZTQ6m9jBBt1FMGmfS4wnErd3h3ZEe9x9vIgIO1OGK6V9Al39lW5ShILQnNFDcTwjmnPEv5bFRPeQWTkyBYK1LKURZrijGe9Kg1tNjleDis96/ONobYhFZflZKGSjfGlpL+wov0Kmbu+9LBb42vRdsFUiOkwU5ZoTZlADcIft/fZlEriLVk32CePtFn59iJBZd0f/gq6IAUBUMI0JvMJjyAwaii5AY/K3fAHBrMAm3UTfNOHmGYNafvolRJgeoeUmX+dzqJ8jXsWTB4enzuq+ofx1P2wKZSFJDmrZxSsLYi/IVCcsi6R5Y1yXy76yVh+bVodOcoc8NMW2bBj2X6RmFBjXBNVGEmwgwC9UWOVHuH5eA5KCQT3kymTRINdZqHIYFssePBGed0hiTkcQmRUFHqEs17wgr7WyOg950iM+JWedbY
 mkEtnpxs
 Y0BW5lUsYMYwZ74+gRnWM/3oqIt5xpjZXgAi4rEmCkIaUVHNKbQYoXZt50DGotl1Bq1ThpelSMFKhcbqJpY0kR1CVa9HoCdKL2FMS8hCiUpRJElEtp23DwLqjmL8h9GwZysZbMJ0hnU7sHBHiKDGUwm8KXGtRVjvUA0yRvjIRATD2zLaunITHZ+7Nw8lIu22hPTVf1jVRMa66ZLPaYIY9FOYR6O625Vlr2HL1llMcn4UHoHPgH+VKj/z7I5IpQNfj5CCdCDhROHH+53nEsjjYHhAj4BDHXlQv/qrE30zCHsSBxr0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 29 Dec 2025 17:45:30 -0800 SeongJae Park <sj@kernel.org> wrote:

> On Sun, 28 Dec 2025 10:31:01 -0800 SeongJae Park <sj@kernel.org> wrote:
> 
> > If damon_call() is executed against a DAMON context that is not running,
> > the function returns error while keeping the damon_call_control object
> > linked to the context's call_controls list.  Let's suppose the object is
> > deallocated after the damon_call(), and yet another damon_call() is
> > executed against the same context.  The function tries to add the new
> > damon_call_control object to the call_controls list, which still has the
> > pointer to the previous damon_call_control object, which is deallocated.
> > As a result, use-after-free happens.
> > 
> > This can actually be triggered using the DAMON sysfs interface.  It is
> > not easily exploitable since it requires the sysfs write permission and
> > making a definitely weird file writes, though.  Please refer to the
> > report for more details about the issue reproduction steps.
> > 
> > Fix the issue by making damon_call() to cleanup the damon_call_control
> > object before returning the error.
> > 
> > Reported-by: JaeJoon Jung <rgbi3307@gmail.com>
> > Closes: https://lore.kernel.org/20251224094401.20384-1-rgbi3307@gmail.com
> > Fixes: 42b7491af14c ("mm/damon/core: introduce damon_call()")

The above Fixes: tag is wrong.  At the moment of the commit, only single
damon_call() request was allowed.  Hence only a pointer instead of the linked
list was used.  In the problematic scenario, repeated damon_call() would simply
return -EBUSY.

The correct Fixes: should be,

Fixes: 004ded6bee11 ("mm/damon: accept parallel damon_call() requests")
Cc: <stable@vger.kernel.org> # 6.17.x

> > Cc: <stable@vger.kernel.org> # 6.14.x
> > Signed-off-by: SeongJae Park <sj@kernel.org>
> > ---
> >  mm/damon/core.c | 31 ++++++++++++++++++++++++++++++-
> >  1 file changed, 30 insertions(+), 1 deletion(-)
> > 
> > diff --git a/mm/damon/core.c b/mm/damon/core.c
> > index 2d3e8006db50..65482a0ce20b 100644
> > --- a/mm/damon/core.c
> > +++ b/mm/damon/core.c
> > @@ -1442,6 +1442,35 @@ bool damon_is_running(struct damon_ctx *ctx)
> >  	return running;
> >  }
> >  
> > +/*
> > + * damon_call_handle_inactive_ctx() - handle DAMON call request that added to
> > + *				      an inactive context.
> > + * @ctx:	The inactive DAMON context.
> > + * @control:	Control variable of the call request.
> > + *
> > + * This function is called in a case that @control is added to @ctx but @ctx is
> > + * not running (inactive).  See if @ctx handled @control or not, and cleanup
> > + * @control if it was not handled.
> > + *
> > + * Returns 0 if @control was handled by @ctx, negative error code otherwise.
> > + */
> > +static int damon_call_handle_inactive_ctx(
> > +		struct damon_ctx *ctx, struct damon_call_control *control)
> > +{
> > +	struct damon_call_control *c;
> > +
> > +	mutex_lock(&ctx->call_controls_lock);
> > +	list_for_each_entry(c, &ctx->call_controls, list) {
> > +		if (c == control) {
> > +			list_del(&control->list);
> > +			mutex_unlock(&ctx->call_controls_lock);
> > +			return -EINVAL;
> > +		}
> > +	}
> > +	mutex_unlock(&ctx->call_controls_lock);
> > +	return 0;
> > +}
> > +
> >  /**
> >   * damon_call() - Invoke a given function on DAMON worker thread (kdamond).
> >   * @ctx:	DAMON context to call the function for.
> > @@ -1472,7 +1501,7 @@ int damon_call(struct damon_ctx *ctx, struct damon_call_control *control)
> >  	list_add_tail(&control->list, &ctx->call_controls);
> >  	mutex_unlock(&ctx->call_controls_lock);
> >  	if (!damon_is_running(ctx))
> > -		return -EINVAL;
> > +		return damon_call_handle_inactive_ctx(ctx, control);
> >  	if (control->repeat)
> >  		return 0;
> >  	wait_for_completion(&control->completion);
> 
> TL; DR: This patch introduces another UAF bug under a race condition.  I will
> send a new version of the fix that solves the another issue.  Andrew, could you
> please remove this from mm tree for now?
> 
> kdamond_fn() resets ->kdamond, which is read by damon_is_running(), and then
> make the final kdamond_call() for cancelling any remaining damon_call()
> requests.  Hence, if the above damon_is_running() was invoked between the
> ->kdamond reset and the final kdamond_call() invocation,
> damon_call_handle_inactive_ctx() and the final kdamond_call() could
> concurrently run.
> 
> kdamond_call() safely get a pointer to a damon_call_control object in
> ctx->call_controls, and then access it without a lock.  Only after that, it
> removes the object from the list while holding the lock.  The intermediate
> lock-less access is safe because kdamond_call() is the only code that removes
> items from ctx->call_controls.  But this patch makes it no more safe, because
> this patch is introducing another ctx->call_controls item removing code, namely
> damon_call_handle_inactive_ctx().
> 
> To see this in details, let's suppose kdamond_call() got the pointer, and
> released the call_controls_lock.  After that, damon_call_handle_inactive_ctx()
> shows the object is still in the ctx->call_controls, and removes it from the
> list.  The damon_call() caller further deallocates the object.  Then, continued
> execution of kdamond_call() accesses the already deallocated object.
> 
> I will send a new version of this fix soon.

So far, I got two fixup ideas.

The first one is keeping the current code as is, and additionally modifying
kdamond_call() to protect all call_control object accesses under
ctx->call_controls_lock protection.

The second one is reverting this patch, and doing the DAMON running status
check before adding the damon_call_control object, but releasing the
kdamond_lock after the object insertion is done.

I'm in favor of the second one at the moment, as it seems more simple.


Thanks,
SJ

