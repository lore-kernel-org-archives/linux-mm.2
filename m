Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5469E10F92EC
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 01:24:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B61F66B0089; Tue, 31 Mar 2026 21:24:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B132C6B008A; Tue, 31 Mar 2026 21:24:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A28EF6B0092; Tue, 31 Mar 2026 21:24:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8E5286B0089
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 21:24:33 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3B9B01B81C7
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 01:24:33 +0000 (UTC)
X-FDA: 84608242026.23.7FF4B4C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id A28B440005
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 01:24:31 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SwC+x4ru;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775006671; a=rsa-sha256;
	cv=none;
	b=Dtf6hV7MRIWg6rbwKqVD4omzg5Ac0bo9EWy6ovLlxhpNIswsjHTphwHKzDcsRkWKc5xfQ9
	Z23QAa+evGmK/cVJBYnQWhg+S5yy7rQr9O+NrPSvX3ZExDN8CcFrj66dDBFuc9SRwsnO5T
	8zabMxkQ5qLQDrvFJnGlo8oipFnvSk4=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SwC+x4ru;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775006671;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FCl39dC8mMfCffky+raIn2HnqrwfrLfrssqClgKM5/M=;
	b=2z5ZUghwDmPmOOTUw+z77L8e88Zx0Aqve9X+5I6lX260zK8ham0Ss+WwIh7lAq7gpeijMo
	ICmCgxqKekplpaGnbSSF5Ktc1l8lDe9z48iJbj/AxleZq/sDZu0L1P6dJ7NShSfmrJzTsR
	AVSUnRXIo7zDT6X0DrFG0+WC0rOtISo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A695D60053;
	Wed,  1 Apr 2026 01:24:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 235E5C19423;
	Wed,  1 Apr 2026 01:24:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775006670;
	bh=YRD6SBhL8RFbYN6prTxOhdZb3eYyfArbtM+TmdXLaQs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SwC+x4ruefQNTi89jR1AoNqkmYryULMg29ZFfkYkd/987EGL4Nvat2caeyp6tVDMB
	 3grSbN7cPA/G8pmNkEFZG/3lZqpK0F4IBpi8cNQJVWgc/XVW/8av2YRnCNhPJDbxJS
	 fpOxIB31EHAd034nI/0vkbJkz8cyFJckLBzaR/1h5samuTP99zh71yB7YBhVfWU9ek
	 b/XofHQtaKAIDxPboCU2HwA+DXgeHBt0qBwv4ZdVNwMX1sMDegSKRzx0S+G/sw+GZ4
	 R/qi7tAvUj+HUy9kd2bnHW44sXIdpYo1Fe6NDMZKjodXkFhzNFYicMzKzgIMWiH2NK
	 m5VCx1zma/JHw==
From: SeongJae Park <sj@kernel.org>
To: Jackie Liu <liu.yun@linux.dev>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	damon@lists.linux.dev
Subject: Re: (sashiko review) [PATCH] mm/damon/stat: fix memory leak on damon_start() failure in damon_stat_start()
Date: Tue, 31 Mar 2026 18:24:28 -0700
Message-ID: <20260401012428.86694-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260331101553.88422-1-liu.yun@linux.dev>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: j5mrh19at6a4ozxim1ymeppwbxixt14m
X-Rspamd-Queue-Id: A28B440005
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775006671-383990
X-HE-Meta: U2FsdGVkX1/cMvpkxjo4PNQrXCOJHXvbMfEnHnp9Xv/af4WSM0+JTY0VIH5muU7jnCohot757OE0HU38F2+skRtolL+0XjRMl0HXLNGr3l2K1fuVmObJV1/4MAo3umb9kRooGhVBANBbZEOBeZPkJVnLAu3YRf+g0eQsZWPRdqftOVYyh8CnbQs69Qe2oCnvU+k7vx0mFIgfmR7ZrmzMKuqyoMj0fEP8G2+dz3jJ0WHLaQSe07joXlyW7Pb3GXkBIQIo3SdBLlMF8t6Py2QM2+r319E2RLVLb//YnV3GyF/HOMZnLxe5WhBbmB2W0HKm1hY+xZQXpNGNOIx2J1seYT1vZhujZjNdGdQrQyraNiPROJiBzqpa73B31n80JZuM5Vk7FUeqzGDSciuA2v25E+3sU+0AsLdEP4uf+5LS5pORNHq1BAPJvq5yPa/lNksgRmroji+I8glmGy8GFLzdUPDhL0ej7oP92xz/sT+fie19y4b1ksBOUp/apNFJJZUHzaB1xayfQ5XLNFq8BAoJPkUpE6Nu8h61qQP6Cj8Lqe0wk0HbYN7uaVPuPpZtmI+CHRhlhXNtvebiy1ERYG+BoaUL7dUHWOolXirrCkvcP97ZmliY4QRJKM/iSld+y+rqYS9mhNN/KLzmXs5C5pDBmtFUWK+Pi751wxNCzHb43JCCnmZZIAcH5EZ84cx8s5/M16o+aR8doVLuNQD7ww1Ch00XkebV3nrqHWR1XlJhuwgd7IqelnfeH1cyrexBbLxXN3lBul91s8Zc9kq8HkAnbw3w0g8YCHnp/+AJChOU5DBYDVPDAqBctdRr2zPv/1IJKDAzzZPj79VAsyT+WnCtc6Qd88/ldd1Cdy29xxcqvJ4iquxwyCIBPq/ReEXesBxaL0muBEWAzG9uBPs2B03nye9eG6qppWVQYMRkC0Ylw2BE1KsH5+EFIGsry1Vf9Y6fhkMPdMbTWW67GlPpsOg
 KMytszB1
 NC0WTToDfAzqq6+QY9gSamzMQD48HJNbM0QYZKL6ZdS8fjzjQZ4o2lpvYaqYLh9235QIvi46XAv7rwyk/1/z3diB9QqwBNG4KTmVs01T6HYgZ90sfeWHNWsX+BijIQY+VM0e9+VgoR2P/19aBm+EmQtxgDi8uft6YodQGZ3z/IUarCKgXA3SBMOnnffXvJbdsL4QA3Ai31EI9vwYiWRmxU/SO3coGSxR2ZHpwOFutejIWzHB5XDvJ3hcWvRP96l/2nkiw9A/F7xTYP7j5iw1uC1//SNVHV3Dnx48yrTSNMZroGQ90GbZt70skGmtWPBlTpO3zFuQg80k+IZfg5V/+d8IHFRpejtXbJ7fQcXzSo7aDtRc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Forwarding Sashiko review for doing discussions via mails, in form of reply,
and adding my comments inline.

TL; DR: No blocker for this patch.

The first one is nice finding but orthogonal to this patch (I start feeling
sashiko might be useful at finding potential bugs in existing code, like static
code analysis tools, more than reviewing patches).

The second one is just wrong.

> # review url: https://sashiko.dev/#/patchset/20260331101553.88422-1-liu.yun@linux.dev
> # start of sashiko.dev inline review
> commit 386810f9b0a1ae341b87a984b16b2a2e1bafab71
> Author: Jackie Liu <liuyun01@kylinos.cn>
> 
> mm/damon/stat: fix memory leak on damon_start() failure in damon_stat_start()
> 
> This commit fixes a memory leak by destroying the DAMON context and resetting
> the global pointer when damon_start() fails. This ensures the previously
> allocated context is not permanently lost on subsequent enable attempts.
> 
> > diff --git a/mm/damon/stat.c b/mm/damon/stat.c
> > --- a/mm/damon/stat.c
> > +++ b/mm/damon/stat.c
> > @@ -249,8 +249,11 @@ static int damon_stat_start(void)
> >  	if (!damon_stat_context)
> >  		return -ENOMEM;
> >  	err = damon_start(&damon_stat_context, 1, true);
> > -	if (err)
> > +	if (err) {
> > +		damon_destroy_ctx(damon_stat_context);
> > +		damon_stat_context = NULL;
> >  		return err;
> > +	}
> >  
> >  	damon_stat_last_refresh_jiffies = jiffies;
> >  	call_control.data = damon_stat_context;
> 
> Does this code still leak the context if the subsequent call to damon_call()
> fails?
> 
> If the newly spawned kdamond thread exits before the call gets processed (such
> as due to an internal allocation failure for regions_score_histogram in
> kdamond_fn()), damon_call() can return an error like -EINVAL or -ECANCELED.
> 
> When damon_stat_start() returns this error to its caller, the caller resets
> enabled = false and propagates the error, skipping damon_stat_stop().
> 
> Consequently, damon_stat_context is never destroyed, nor is the global
> pointer reset to NULL. The next time the module is enabled,
> damon_stat_start() overwrites damon_stat_context with a new context,
> permanently leaking the previously allocated struct damon_ctx.
> 
> To completely fix the memory leak, should the return value of damon_call() be
> checked and cleaned up similarly to the damon_start() error path?

This is correct, but orthogonal to this patch.  I will work on this.

> 
> This isn't a bug introduced by this patch, but is there a race condition
> between damon_stat_init() and the sysfs module parameter setter
> damon_stat_enabled_store()?
> 
> For loadable modules, sysfs parameter files are exposed to userspace before
> the module's init function completes. If the module is loaded with the
> parameter enabled=1, damon_stat_init() will begin executing
> damon_stat_start(), which allocates damon_stat_context.

This is not correct.  damon_initialized() check in the middle is there for
avoiding this.


Thanks,
SJ

> 
> Concurrently, if a userspace process writes 0 to the sysfs enabled
> parameter, this triggers damon_stat_enabled_store(), which sets
> enabled = false and immediately calls damon_stat_stop().
> 
> Because damon_stat_init() does not hold the kernel_param_lock, there is
> no mutual exclusion between these execution paths. damon_stat_stop()
> calls damon_destroy_ctx(), which frees the newly allocated
> damon_stat_context.
> 
> The damon_stat_start() function (still executing in the init thread)
> then proceeds to call damon_start(&damon_stat_context, 1, true),
> dereferencing the freed context pointer and causing a use-after-free.
> 
> 
> # end of sashiko.dev inline review
> # review url: https://sashiko.dev/#/patchset/20260331101553.88422-1-liu.yun@linux.dev
> #
> # hkml [1] generated a draft of this mail.  It can be regenerated
> # using below command:
> #
> #     hkml patch sashiko_dev --for_forwarding \
> #             20260331101553.88422-1-liu.yun@linux.dev
> #
> # [1] https://github.com/sjp38/hackermail

