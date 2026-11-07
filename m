Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D95A5606A32C
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 22:04:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UZHJ3xEu
Received: by kanga.kvack.org (Postfix)
	id D046C6B05B3; Sat,  7 Nov 2026 17:04:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB3EC6B05B7; Sat,  7 Nov 2026 17:04:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC9DA6B05B8; Sat,  7 Nov 2026 17:04:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 95CCB6B05B7
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 17:04:15 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1DC268020A
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 22:04:15 +0000 (UTC)
X-FDA: 85409702070.29.5F6BD2C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 64ACF2000B
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 22:04:13 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UZHJ3xEu;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794089053;
	b=dzWuebvPWpSOClY4BcLB7wZcX/WQ9GvamSOozfOSRYBeNRsGO8mFaoujLIbAFMxCyLuEc8
	vQnwh3vKwJ+X14k/Qr9Y0yS5kP07ih9Vdvu5rUyvePTssmTKQJjFgFm9j+23PXTaJCPv3F
	Ficy65zN1kvOb+ZyxNJMPASc5FqeQpc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794089053;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Vg96+k20fvX/TZK2PjIoa9UHuV5nYVYzfPAN/mfvW+Y=;
	b=4tU8eWXk7IeeA6FZF+OjFjzXIFZpy+H0UHEIMvsB8YVo4wt89MDIMaew03VGySsP9gyhp1
	kaGaCaC+oNOHhJ4S5/AvQs5FwfK5IVU5UfQeClitnsbq+KWqPH6f1WISCQ4bTcJqZjf76T
	l5M/cm4JfbjlKxpEthT0VQ609a9edTI=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UZHJ3xEu;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9809E423DD;
	Sat,  7 Nov 2026 22:04:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E71A1F0089F;
	Sat,  7 Nov 2026 22:04:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794089052;
	bh=Vg96+k20fvX/TZK2PjIoa9UHuV5nYVYzfPAN/mfvW+Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UZHJ3xEuIhHMsZtkYNVBHAy8+5oCG35WH89m+XvsWKCFP1u6UNCgFVJ745ypXfhZj
	 PtrYSvxFdg/DZT91rIUPRa49xRGLR/tSXr82PJ4F79UdIt2JA8hFa0gguN99tDLJpZ
	 S7MHgg81VsCXvGnBy5jDD+retWn6XTj/4I+YdDaHJ4dY7X+Y77yO6btFVyVCc1sStd
	 +R/ZU5CLl3UBPBGR6juZTFS8M10TyczjU/LlOVM1QFz1OL5O9aY1yP5jjgkq3uSCoc
	 GVnneDsuIqA9U2Kxjxk2eAW8fWlSgVpeVMVYbxufJ0kHas9Jph5qWphKZWIhz3fv/s
	 eW+qIeyVaWHLg==
From: SJ Park <sj@kernel.org>
To: sashiko-bot@kernel.org
Cc: SJ Park <sj@kernel.org>,
	"Andrew Morton" <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH 6.12.y 5/5] mm/damon/core: remove unreachable damos charge_{target,addr}_from
Date: Sat,  7 Nov 2026 14:04:04 -0800
Message-ID: <20261107220405.305058-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <sashiko-outbox-203351@kernel.org>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 64ACF2000B
X-Rspamd-Server: rspam12
X-Stat-Signature: 6h5d7ko6jmgthtixibkkononxxywkhfy
X-Rspam-User:
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794089053-310444
X-HE-Meta: U2FsdGVkX1/uXg4qDOrEpcILwRzN605XGJ+ilp6xINEtFSm1E7/4WHUgwKhBEyHbJk+jRhhyURMLluvOUUIYrrNXB4CA+1TLacK2gQqVLHqAqw4xhaGRBPBRsWdWZMWVBEkvsw5Xzc7CpGQmLLruNr/QPzQZtHZLlMojUdA+ORUlejIUxpVXcfMwEeFDGUUKEE9Jm8jv4MVeufl3c62tejuLkr/j2CxnpEfwLpHSTV2XeFt346MJVskN4h1rGEtvShHMt/7nwua0aK9L3M5neCM/AbrRuMeUHIobKQuDrveer19s0ZmTmX1XvZsxm4sSHFz8dAQRPB5anoHSzbJbZI9AYzd2nFngwc7FxQ5pC99yFOxWTyPo/qtk+0MWnLGTcvWkuD/A2dWZ2mJU3+sQtHj/rqwSK04zoBMyuCgzY5cRNxTssUkgxPGlfQjbfLJzNT9zX1M2BVxSEvcWR68eo1kFfD3PoBgvWa1wdAs8jsMAUfCN1gzalXdGi6DAtjP4nFAud8y9Sa6F+U2DiTQBGWtN2J/tSIA7Xh+2s2V7moG9V4sKJ9ILTL2/SiZPus0PuEfutEUQGiUYJIi0B33bs025p1M/btC/9bywc6FrhsqYTbuoYszrU+UtHwGC1KFSj6KTe8FNA4ipFL2AMjPpm1UXroni5v3UNN2ui4ndDdMDRErd3c8NNpqmCFKGLH6RR0quwIRCt2OoQ/HJ/29sOo8Kul3aRQXPunDfkkghmK43twvCKF4+R14ylxCbyEIdu9dYU+trQ4ckOB/GOTmfGtYIXy//DvfWB+tF4ihe9ZqbopbQGtUGjoeqM6ypOFXs1aVSpEKyXv3563j1mt4l/FbXYkFVKr2Vq30vHLnBkKMzf34XtBYcFJrVSpQn+bjS0Ibp5DlOw3NjOlSUjlcKf2rkpmGkJV+W4414ZCtspuAA5fK1sEp1iM38oO5W7I5DAchAAFfD510tRa9nBeJ
 G5SLb5xM
 +GE0DOUKIFjNCCUxZj5lnFFDS72RjrpnKSFeCdcCb6JKLX8aT0UrZ3otms76JazjDzStGksFEEJrjU15T24GkvoOUdu5U7C5Jd47yxGK3VHty8Ub75a0H5YAY7a8z6Rh9DBDmMVbeRhgyTeBfhizC+/im8zRSrDQAFJCR3pSOaemWhajiow2bCrRpydSYsFwmbl0VY0K3HzzNwSm6Xgg1WZS3OzPl6rIs7WZ5CHB8EvJuZlDeF6YMCNqEtXqPOJSFkM2lNi/hBEIKxS+DSWNQQVQdC4jPDefLZvLOal/gK+A8hm9+42jfLBtgYvsvOOEGHgLnclHgHh4+mfYoTgm4vL/uu8t7OHu4Q8uttBb4Bu7VT8Umo/ZTmgYcyT80vsVIAO8aLBrPlyE11lOdcU1nX36D9IX7ULlf8XOWh1bbiidTjiLNBkv+VI7lDLTCddzK41SUQ0r4tDJlv2AtmuZOzwlz5bb0V6v0bMQBcgxUegTnGR8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, 07 Nov 2026 21:58:17 +0000 sashiko-bot@kernel.org wrote:

> Thank you for your contribution! Sashiko AI review found 1 potential
> issue to consider:
> - [Medium] mm/damon/core: dangling charge_target_from ABA reuse in
>   damos_adjust_quota()
> --
> 
> commit 6429d6d07b9e92711137f889d5332896002d4342
> Author: SJ Park <sj@kernel.org>
> 
> mm/damon/core: remove unreachable damos charge_{target,addr}_from
> 
> This commit adds damos_fix_stale_charge_pointers() to damos_adjust_quota()
> to clear quota->charge_target_from and quota->charge_addr_from if the
> target was removed or has no regions left after a runtime parameter commit.
> 
> Link: https://lore.kernel.org/20261020023958.108276-1-sj@kernel.org
> 
> > diff --git a/mm/damon/core.c b/mm/damon/core.c
> > index 046c07b86a6e7..badd0628e5eb2 100644
> > --- a/mm/damon/core.c
> > +++ b/mm/damon/core.c
> > @@ -1686,6 +1686,26 @@ static void damos_set_effective_quota(struct damos_quota *quota)
> >  	quota->esz = esz;
> >  }
> >  
> > +static void damos_fix_stale_charge_pointers(struct damon_ctx *c,
> > +		struct damos *s)
> > +{
> > +	struct damos_quota *quota;
> > +	struct damon_target *t;
> > +
> > +	quota = &s->quota;
> > +	if (!quota->charge_target_from)
> > +		return;
> > +	damon_for_each_target(t, c) {
> > +		if (t == quota->charge_target_from) {
> > +			if (damon_nr_regions(t) > 0)
> > +				return;
> > +			break;
> > +		}
> > +	}
> > +	quota->charge_target_from = NULL;
> > +	quota->charge_addr_from = 0;
> > +}
> > +
> >  static void damos_adjust_quota(struct damon_ctx *c, struct damos *s)
> >  {
> >  	struct damos_quota *quota = &s->quota;
> > @@ -1714,6 +1734,8 @@ static void damos_adjust_quota(struct damon_ctx *c, struct damos *s)
> >  		damos_set_effective_quota(quota);
> >  	}
> >  
> > +	damos_fix_stale_charge_pointers(c, s);
> > +
> >  	if (!c->ops.get_scheme_score)
> >  		return;
> 
> [Severity: Medium]
> Can damos_fix_stale_charge_pointers() match a different target if
> quota->charge_target_from is left dangling until damos_adjust_quota()
> runs?
> 
> When damon_commit_targets() removes a target via damon_destroy_target(),
> it frees dst_target without clearing quota->charge_target_from, and
> damon_commit_ctx() then calls damon_set_attrs() ->
> damos_set_next_apply_sis(), deferring damos_adjust_quota() to a later
> interval.  If a newly committed target reuses the freed slab address
> before then (or if damon_commit_target() overwrites dst_target in place
> with a different target), t == quota->charge_target_from matches the new
> target and leaves the stale charge_target_from and charge_addr_from in
> place whenever damon_nr_regions(t) > 0, causing damos_skip_charged_region()
> to skip targets and regions up to the old address.
> 
> Clearing charge_target_from and charge_addr_from directly in
> damon_commit_targets() when a target is destroyed or updated would avoid
> comparing a dangling pointer later.

Good finding, but this is not a blocker of this patch.  Occasionally starting
quota charging from unexpected target is no real problem for real DAMOS usages.

> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20261107214525.304638-1-sj@kernel.org?part=5
> 


Thanks,
SJ

