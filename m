Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 543D0F36B97
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 00:12:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7AEDB6B0005; Thu,  9 Apr 2026 20:12:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 75F496B0089; Thu,  9 Apr 2026 20:12:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 69C196B008A; Thu,  9 Apr 2026 20:12:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5B5166B0005
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 20:12:05 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0ADA38AD20
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 00:12:05 +0000 (UTC)
X-FDA: 84640718610.28.58B897A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 5E4851A0007
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 00:12:03 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Li6mSTkb;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775779923; a=rsa-sha256;
	cv=none;
	b=KdDd+AG8ajQ3wULta5mnzIFjy0kNsj737U5AFb7X7gTGD2tLFJt65685kzJOwiNwpE9Ap4
	3R8DS6jjs8+MKRV9H4Hzg9E/mBFBT+DLtZbDRDU2/JjZmjoQtw4oSbFlotNL1A5iIHgC+X
	taGT+3ikOvA+JtsTVZRbfXoZwsSvjEE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775779923;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qalelU2OVFIi9vg/MxI809u/9MRYVd9xJrSdW3f1vXA=;
	b=47S7bmOWt4t9gWROQGQWW3jiDkkzyvc6pFXM1Tvr5qoBREZ60PYfJXNPg9en5u1+2rxr7/
	enAAaF2pTB0veqbBuUH2csNkv8jdqghSyIlFsYLFA87/yjRAU1GzOcVYc3snAE8ypKR2Eo
	5mvIbwjP1C4yRqTx1u7BDbghObq+gGo=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Li6mSTkb;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B04AB600CB;
	Fri, 10 Apr 2026 00:12:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 391B8C4CEF7;
	Fri, 10 Apr 2026 00:12:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775779922;
	bh=Dyj6DdBLJ8yRouWJ2nAzD7cNHqNhbULuYxPjo7BULS0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Li6mSTkbLPgUlVnGG42ioTKx9YBJ9oGfyO2hE5zOWffSBlOCa9c7K//W/Wc6IxYYr
	 4d7BE1jEs9wV5qobdskJxM99JHfB2OFCdUo/6x4/VNRQ5xwTcHF0noP7gNwFvQLjDq
	 6NGlshdm2m3Wtrw9v/GYubdo0T/l9/qNtMArKzyJD3NFJ81owy9+fdTE3VPwN6x4h+
	 pXS9c1RS+xFoGRQg5p0e7KW49Ch/yxyCHJ13qthmdxcbT5XZCwYVp4PDYgxmCuOI5U
	 c4fT5jxhXB4sq+m3FbdbEUrysuynpma1hIG1Mh+fTM0ULKeGPhvrNpX7IRvNanmmDs
	 7qyap3l9d+Ang==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: (sashiko review) [RFC PATCH v4 03/11] mm/damon/core: introduce failed region quota charge ratio
Date: Thu,  9 Apr 2026 17:11:54 -0700
Message-ID: <20260410001154.77757-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260409142148.60652-4-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5E4851A0007
X-Stat-Signature: hursmw95mwnweianpo3jcbkf73rx5bqz
X-HE-Tag: 1775779923-33150
X-HE-Meta: U2FsdGVkX19e8P3pTpMiPYYgLpeMoef10LzXKlZVocaRQSB2vwDzPWonRGmjqCQ4f7r/H7SAUGk+ze9AwGtXaFYd2iah5M1UhKz6/JLNEfxmWTtMEfh7VG6k/zTwfIDWzcoUZEpkqxqo3zpIEXVdD8MMEvafKkJ6/7b6UO4T1WnGkZQMrrwqH8jIJQM7z/GbGL9DKPo/Q+HtxZ8/3X7lgUY+iuNJnynV0ytUsBiY3QhqCypIZxoOt4iCrF9+t7razE8DoHedGNQU1l8vlOjc5AkK+PFFhvZ3MvJBHVP0Fvkv8V+EyPprznr6zCYKz8AiVMhbGJwDOH261hRQRvt/kNyq33T5QayfJY7eiIkx6GT58XEnV8bFBgIbdttI87IxgE5CQQOeNwI7JZxSFcLkAvV//7BhTNSM3rsTbq9t0ZTx6Y5eUxCV9hJdfZsm9+KVY+BursNlrxujV7ITbTS0mqUFHMW36N9HJxtKkPJ4aZNWj4AleDEhcqxn0YmiZ/fX85ktO4tCUkVGDKfgSdULMag6riA30bdlGUsRwLGAE0O6wZP1SU0K3/+xfSH5kuJNtS8cSSXjsbSNSPd5Vfb6R3C0ROpFZlSmqrg3Zc19OtNzOHD7PfcjwuJdnMQm6Mk/GzdPbAMSLn9XEIu8HanwUeA7kHcn6tcmy949MfIHbZJT0cA3A6uRJjnt+3BjTxIceDMJekRsKFuus46CQagSgcXcxGe+YdPsiz/2xIZ+dMaKAntp3FKGhN2zNYZbCMNBblMkDUikt8Lo6sfDDHZDIBOPxqLt9UCU/qUIw5MB9TGstnNlag808P+rFf2Y+xhve+R6Woeym7lzreAbaKOyO+aJA2Pv0TdKzg7PP9pmfD0plR/uPpLoWeTn+ZnDl5+EhwSE7Ga0SI5wmeXE5LyLSATQQygGBIvVhLEEoBd4pT3k+afr1dndnjnkyj47z3kapGyURnZPsEEhx9woXoa
 XZ9tbXz2
 8+lSPsnF60TFeQYLKF97RP7CnFpKVHH12wp3MZd2GDaxNytesUJNdsZduEVolR32SZ88TQ4LfV0AU4XOrpvPIUB7XEtD4jUPv7YVfF6AgyJek9/eeCqsc7BkWvgFbC04Q7nW+npOVPZkypvrcTLUls6tw7juJufQhetHjbs5lCx/GPIKzaWfORiEvvHwCXa9oWb7gP4O6zFzUtA22S5cmVVAQA4CrY/0TSB7YKd6NTkGMcDOZ96HoZSZ2aSjWgugspSjpnkQsf3LzncmiGpgttc8FpPsJ9OYTwSgy2e7iy+UcNuZO7OgoBzMpIw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

# sashiko review suggestions
#
# 1. Consider reducing recipients.  Maybe the author,
#    maintainers, reviewers, and mailing list of the
#    direct subsystem and parent susystem mailing lists
#    could be a starting point.
# 2. Add short summary of your opinion at the beginning.
#    For example:
#
#      TL;DR: sashiko found an issue.  I will respin.
#      TL;DR: sashiko found no issue on this patch.
#
# Please DON'T FORGET removing this comment block before
# sending this!

Forwarding full sashiko review in a reply format with my 
inline comments below, for sharing details of my view and
doing followup discussions via mails if needed.

> # review url: https://sashiko.dev/#/patchset/20260409142148.60652-4-sj@kernel.org
> # start of sashiko.dev inline review
> commit 55afcaa519ab8046d8aa94af44973c3cff0c2a26
> Author: SeongJae Park <sj@kernel.org>
> 
> mm/damon/core: introduce failed region quota charge ratio
> 
> DAMOS quota is charged to all DAMOS action application attempted memory,
> regardless of how much of the memory the action was successful and
> failed.  This makes understanding quota behavior without DAMOS stat but
> only with end level metrics (e.g., increased amount of free memory for
> DAMOS_PAGEOUT action) difficult.  Also, charging action-failed memory
> same as action-successful memory is somewhat unfair, as successful
> action application will induce more overhead in most cases.
> 
> Introduce DAMON core API for setting the charge ratio for such
> action-failed memory.  It allows API callers to specify the ratio in a
> flexible way, by setting the numerator and the denominator.
> 
> > diff --git a/mm/damon/core.c b/mm/damon/core.c
> > index 31ba739d28e2f..1f171665509b8 100644
> > --- a/mm/damon/core.c
> > +++ b/mm/damon/core.c
> [ ... ]
> > @@ -2041,6 +2043,23 @@ static void damos_walk_cancel(struct damon_ctx *ctx)
> >  	mutex_unlock(&ctx->walk_control_lock);
> >  }
> >  
> > +static void damos_charge_quota(struct damos_quota *quota,
> > +		unsigned long sz_region, unsigned long sz_applied)
> > +{
> > +	/*
> > +	 * sz_applied could be bigger than sz_region, depending on ops
> > +	 * implementation of the action, e.g., damos_pa_pageout().  Charge only
> > +	 * the region size in the case.
> > +	 */
> > +	if (!quota->fail_charge_denom || sz_applied > sz_region)
> > +		quota->charged_sz += sz_region;
> > +	else
> > +		quota->charged_sz += sz_applied + mult_frac(
> > +				(sz_region - sz_applied),
> > +				quota->fail_charge_num,
> > +				quota->fail_charge_denom);
> 
> Could this calculation lead to an integer overflow?
> 
> The mult_frac() macro evaluates the numerator multiplication internally
> using the type of the first argument, which is unsigned long. The sysfs
> interface in the subsequent patch ("mm/damon/sysfs-schemes: implement
> fail_charge_{num,denom} files") populates these values using kstrtouint,
> allowing inputs up to UINT_MAX.
> 
> If a user configures large values for fail_charge_num, could the
> multiplication silently overflow the 32-bit unsigned long result on 32-bit
> platforms, or on 64-bit platforms for sufficiently large memory regions?
> 
> This might produce a wrapped-around charged_sz and affect quota enforcement.

Sashiko asked same question in the previous version.  I decided to keep this as
is for code simplicity, as the issue is quite minor, unless other humans make
some voices.

> 
> > +}
> > +
> >  static bool damos_quota_is_full(struct damos_quota *quota,
> >  		unsigned long min_region_sz)
> >  {
> > @@ -2111,7 +2130,7 @@ static void damos_apply_scheme(struct damon_ctx *c, struct damon_target *t,
> >  		ktime_get_coarse_ts64(&end);
> >  		quota->total_charged_ns += timespec64_to_ns(&end) -
> >  			timespec64_to_ns(&begin);
> > -		quota->charged_sz += sz;
> > +		damos_charge_quota(quota, sz, sz_applied);
> 
> Does discounting charged_sz for failed actions affect time quota enforcement?
> 
> DAMON converts the time quota (ms) into an effective size quota (esz) using
> throughput. If fail_charge_num is small or 0, the charged bytes accumulate
> very slowly, which could drive the throughput estimate to near zero.
> 
> This would cause esz to bottom out at min_region_sz. Since kdamond stops
> only when charged_sz >= esz, and charged_sz increases only by heavily
> discounted bytes, is it possible that charged_sz never reaches esz? This
> might cause kdamond to endlessly process the entire target memory space in a
> single cycle and consume unbounded CPU time.

Action failure is expected to be faster than successful action applying.  Hence
the denominator of the throughput, the total time took for the charging, should
also be reduced.  Users may set the ratio based on their expected overhead
difference between the time for failure and success of the actions.  So, this
is an intended behavior, not a bug.

> 
> Additionally, does the discounting affect region splitting earlier in
> damos_apply_scheme()?
> 
> The region is split using:
> 
>     sz = ALIGN_DOWN(quota->esz - quota->charged_sz, c->min_region_sz);
> 
> Here, esz and charged_sz track discounted bytes, but the resulting sz is
> passed to damon_split_region_at() to split the physical memory region.
> Could using a discounted byte limit as a physical byte size cause the action
> to be unnecessarily restricted to a tiny chunk, preventing the scheme from
> being applied to the full allowed physical area?

Yes.  And therefore the previous patch is made, though the current version of
the patch is completely wrong.

> 
> >  		if (damos_quota_is_full(quota, c->min_region_sz)) {
> >  			quota->charge_target_from = t;
> >  			quota->charge_addr_from = r->ar.end + 1;
> 
> As a separate note regarding a preceding patch ("mm/damon/core: merge
> quota-sliced regions back"), are regions split due to quota limits being
> skipped and orphaned during the target loop?
> 
> In damos_apply_target(), the loop uses damon_for_each_region_safe(r, next, t)
> which fetches next before executing the body. If damon_do_apply_schemes()
> splits r, damon_split_region_at() inserts the new remainder region
> immediately after r.
> 
> Because next was pre-fetched to the original next region, the newly inserted
> remainder appears to be bypassed by the iterator. This might prevent the
> remainder region from being processed by other schemes in the current cycle,
> and the intended merge-back logic might not execute for it.

Yes, as I mentioned to the earlier question just above.

> 
> 
> # end of sashiko.dev inline review
> # review url: https://sashiko.dev/#/patchset/20260409142148.60652-4-sj@kernel.org


Thanks,
SJ

# hkml [1] generated a draft of this mail.  You can regenerate
# this using below command:
#
#     hkml patch sashiko_dev --for_forwarding \
#             20260409142148.60652-4-sj@kernel.org
#
# [1] https://github.com/sjp38/hackermail

