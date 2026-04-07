Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73A1CFF5109
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 15:51:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A3E96B00B6; Tue,  7 Apr 2026 11:51:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 82D886B00B7; Tue,  7 Apr 2026 11:51:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F4F26B00B8; Tue,  7 Apr 2026 11:51:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 599946B00B6
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 11:51:15 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0D98B1B8C08
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 15:51:15 +0000 (UTC)
X-FDA: 84632198910.04.7246861
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 6731B20011
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 15:51:13 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HZC7Jh9Z;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775577073;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XpXiaySqyR7vLnbBM0FTJayRSz9w3B7Mzgl6a0u5EA8=;
	b=io5RZ9gbhwF/UoRWxznkPtba7wzFwJRFe4Xwzvy2oaINDGi4SKzsk1WR9ibm3NBCpQWSyZ
	o9CiXc2iUHTd5e/Wrjc96r3o2vlYiEvUB8q1BWY2RdCfP7o2b05/x83jouSjqJX7qpEgjK
	lPuA8FFEqQbLMMoPTKm5luzjZzyCbCc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775577073; a=rsa-sha256;
	cv=none;
	b=FFpT8oKOo2dPLYbbPfX4ONrhb1PqGLQkHnWfH1c2Sw78w/mrw33WO7jsl6bwUxwYmgeUJA
	uC50qH/y3tmh5RpWPgJRFcrnzetZpGhrWxRXJ/AZF54Xj7yw3oJWgO7CbqD4JwcVSDQbpQ
	a1fgMIt/3Om7jpeUpvitN7QZUV3omWM=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HZC7Jh9Z;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D93C1600CB;
	Tue,  7 Apr 2026 15:51:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E9F1C116C6;
	Tue,  7 Apr 2026 15:51:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775577072;
	bh=PVB4oUNgvplVh0sIGtSAENl6g2YTWKTdP79gh7Iu9MI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HZC7Jh9Z2fhH5MT81IG8BgioiW8NAjCj+YxlgMIis1KBye0qobofQtyEJ1f1m2WFW
	 Vb/6Y23No4Cj+UyhgnTAOyZ7qleIrHa2B9+PpVVX5qWOlH+5UprHT4W7kdsyqG2YNf
	 3e4+Nj2S+QgNhZyyjoJHJCRAPlXacBOtF1T3GxWU/4hXde3XXks8EVI3wBuwG2xvWg
	 rCngPYOyBtoMn9hqKarg+xkfgF85v0dp3gPJ+cxOYtgOkLH61DVPUidhVw5sY9vGk/
	 bIZ+ngZit2BfycvFCt3VKus/v32eosGgSNak3qNlfFS4Pf+dmgQJ8YIdL9wdhIrRBN
	 ZQINORuobxLMA==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: (sashiko review) [RFC PATCH v3 02/10] mm/damon/core: introduce failed region quota charge ratio
Date: Tue,  7 Apr 2026 08:51:10 -0700
Message-ID: <20260407155110.51749-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260407010536.83603-3-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 6731B20011
X-Stat-Signature: 9n1tmgzpf46eorffoownmiejuqwyacmr
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775577073-179209
X-HE-Meta: U2FsdGVkX19aPJMBZq9mxjBfBv2bz5Sbf5kNmfUhg4aMGqu19hd0j2DhFNqlJW3U/HXzqs6NYnzqDG4zyN28h5qmNVdcLQllYrdRIvEVlrWbu7PCFEVRymUaH0hTKs+/MGoeyWbaJBTEaYyAMr1QaWRdrcagf4ENOlbswxxFajR1iqfkwJI6wDmpiXG77I1vMgelfETdfyM2iBbbeG62pfWRbXu6nkmWLv5i9jUWQqGkQ1Ep4SZtXpqZ1JIaSuurVAK6FZx9w2eEwrZmktzzWtMnu1wjE8fl+91L1NFCD0wXdIAkKL68TRwSJnV8n7n/eHXC8NEUrEoSD8/5I5y5sZJWt/EbMdnVTeS+SbaZvcW7RKpgq7Ue0jZS78jp+kMumyJhzadjx1vTeFNuin1eYFsdks1YGkUAukGDb4sTfPGPyFgwVBIeRRI5H7gJJtEMSeCZri5qnL+fsvU/ho5xjfqZQTMT+gGQxjAwb/s2XgN5ZH1Zyx1GvzEdonh+Fkeu73csQlIPBrjsXd5EKNCLoxR3YapE+cZO9o/PUk2tqzjAh1CX31ZVLiMSCeGtY165thQyT5JV4jK0/muCk4nPFjJ2AruOUdIlkLbiVMo94mbBzJ01ruRjeqe2cCa/TE4keGIfxbI3TgKds5W7AEJcegI2UXBj+JYuhmJSPxAs+G/bHi+G6IR2jbZoIgR5qoxiHM4Z/ksZQg4BMLGYi9v2sKj/6zhvscU6PEGe3hMzMHw/cZ/PQT592jt39K8KgPbK7Hd5W5esndZ2990/SDqb1jmAND3lw49Yku9G/MuSqXAGgoB2hZQuWxQtbrOsasYPsy0ileOuN1S1+7GmsbQxd9FFSxkkKS0WkLC7NrrVQVy1NMq3M5W0F0iwzLbftm+saf5uG4QoBsT4eWM3NmOBTiBm48sdsS9bkVh5vNpm/TYZVBi+3cUgUh20YLWqb/nuwR/mV6j3RW7rsGlxp2H
 hXwATj4j
 CUzhju1rJK+32HHoKdcagaF+EkKYoplykg9Gb6XCDT2Qb+r1+redzxFN1Quw+wJ0zc3HAH4eU3OVrgaBRszpEjTO8mnu5klG8IbgXmID8+RNyMAgyjpoIfQcgrVgIqpptpJTJiFG/SLgxhhkBhpwe2KxXJGWXohK0wVOLryTvUWa6qgjeyBwARUiwdkIinu4DN84g6idz4NpKXAbYfzVHg82xZ85XLnnK2HiqISX2VnphQflgIKCe181gdg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

TL; DR: sashiko made a good finding that better to be addressed.  I will
address it in the next revision.  sashiko also made two findings but I will
ignore those.

Forwarding full sashiko review in a reply format with my inline comments below,
for sharing details of my view and doing followup discussions via mails if
needed.

> # review url: https://sashiko.dev/#/patchset/20260407010536.83603-3-sj@kernel.org
> # start of sashiko.dev inline review
> commit 09593130776383947d3d32b60b59b00c4bc2e692
> Author: SeongJae Park <sj@kernel.org>
> 
> mm/damon/core: introduce failed region quota charge ratio
> 
> This patch introduces a configuration to charge a different quota ratio
> for memory regions where DAMOS actions failed. It aims to improve fairness
> in quota accounting between successful and failed actions.
> 
> > diff --git a/mm/damon/core.c b/mm/damon/core.c
> > index c29f70bcce894..2a09d6bdf5f3e 100644
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
> > +}
> 
> Can this cause an integer overflow on 32-bit architectures?
> 
> The fail_charge_num and fail_charge_denom are unsigned int and can be set
> to arbitrary values by userspace.
> 
> If a user configures a large numerator (e.g., close to UINT_MAX), the
> multiplications inside mult_frac() could overflow the 32-bit unsigned long
> boundary on 32-bit architectures, leading to an incorrectly truncated value
> being added to quota->charged_sz.

sashiko is asking a same question again.  As I replied on the previous version
thread, I will keep this as is for simplicity of the code, unless a human
argues differently.

> 
> [ ... ]
> > @@ -2105,7 +2124,7 @@ static void damos_apply_scheme(struct damon_ctx *c, struct damon_target *t,
> >  		ktime_get_coarse_ts64(&end);
> >  		quota->total_charged_ns += timespec64_to_ns(&end) -
> >  			timespec64_to_ns(&begin);
> > -		quota->charged_sz += sz;
> > +		damos_charge_quota(quota, sz, sz_applied);
> 
> Could this permanently disable a scheme if actions completely fail during the
> first time window?
> 
> If fail_charge_num is 0 and all actions fail across all regions in the first
> charge window, quota->charged_sz evaluates to 0.
> 
> At the end of the window, total_charged_sz becomes 0, while total_charged_ns
> records the actual time spent attempting. The calculated throughput
> becomes 0, which sets the effective size quota (esz) to 0 for the
> next window.
> 
> With esz = 0, damos_quota_is_full() always evaluates to true, causing DAMON
> to skip applying the scheme to any regions.  Since no regions are processed,
> total_charged_ns and total_charged_sz never increase again, permanently
> bricking the scheme.

sashiko is asking a same question again.  As I replied to the previous
question, this is not cuased by this patch.  So I'm working separately for the
issue.  I recently posted the fix:
https://lore.kernel.org/20260407003153.79589-1-sj@kernel.org

> 
> Does this code create an infinite region splitting loop if an action fails
> near the quota limit?
> 
> In damos_apply_scheme(), if the current region size exceeds the remaining
> quota, it splits the region into sz and the remainder:
> 
>     sz = ALIGN_DOWN(quota->esz - quota->charged_sz, c->min_region_sz);
>     damon_split_region_at(t, r, sz);
> 
> If the action on the split region fails, and fail_charge_num is less than
> fail_charge_denom, charged_sz increases by less than sz (or by 0).
> Because charged_sz did not increase fully, the remaining quota remains at
> least min_region_sz, so damos_quota_is_full() evaluates to false.
> 
> When the scheme loop proceeds to the remainder of the region, it will split
> it again by the same sz.  Could this repeat until the entire target memory
> is shattered into tiny regions, causing a massive increase in allocations
> and a kernel lockup?

Good finding.  Yes, this can increase number of region splits on the code path.
I think it should be safe from lockup, since each DAMOS action implementation
uses cond_resched().  But the increased number of regions makes me worried.  I
think we should merge the splitted region back, after DAMOS action is applied.
I will add the change in the next revision.

> 
> >  		if (damos_quota_is_full(quota, c->min_region_sz)) {
> >  			quota->charge_target_from = t;
> >  			quota->charge_addr_from = r->ar.end + 1;
> >  		}
> 
> 
> # end of sashiko.dev inline review
> # review url: https://sashiko.dev/#/patchset/20260407010536.83603-3-sj@kernel.org


Thanks,
SJ

