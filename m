Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A7B8E9D800
	for <linux-mm@archiver.kernel.org>; Sun,  5 Apr 2026 19:25:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 141546B0005; Sun,  5 Apr 2026 15:25:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0CB956B0088; Sun,  5 Apr 2026 15:25:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED4E06B0089; Sun,  5 Apr 2026 15:25:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D8AC66B0005
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 15:25:12 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3136EE0201
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 19:25:12 +0000 (UTC)
X-FDA: 84625480464.01.3521D67
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 79DFE40002
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 19:25:10 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YkrWmJsr;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775417110;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3DRzF7HUjxUhxVxFkyHuw4run87YUD9u20xmIwBZOSM=;
	b=WMDK39eVXfz5q3m5yfssArfMRKTwvPuKjo5RMPdgrmRq+CZrodPWmtR+ILmhnvusXgEqA5
	Rg8Y2vl18dpG263jTaMLOpcUimZaYS1aQeZdWW3pJJ+KJwqDa0+4HIb3hWvaTqgEsFyu4S
	5bLB0PxPhkF6k1qRD8QttjVnBnsnW2I=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YkrWmJsr;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775417110; a=rsa-sha256;
	cv=none;
	b=lWr/ppbnvOYbMc+yMKlcBf1yyk6+XqREAxjc1qNBz6346pI8L7ih0HTf6xow11ym9NP/+G
	91MXah2Wl5L5WyBPMD/iAcZZiATLCu/yTm8VJFkzUb5KWGi0m8W3vHPxdl/rqDhcEMdFyy
	LBPuffnfD4rXNPK/qkDfCMhhXqieeYk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4816F418B8
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 19:25:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9CE5C116C6;
	Sun,  5 Apr 2026 19:25:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775417109;
	bh=u9kP4a9l9SG7iK+UKEF6ddVw+VEDMWRXTIAT5puUTYY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YkrWmJsri9ffoOu7ax1E1c3m08gjnDRCJOB8AZWvW9A6XcOp22MmVvAfihfGUpO+u
	 4tupmt/W3YbSWBHGq4uae2ZYIYzC/txvkPnpqn9bkz53ReLQTeaIZP0WL7TQiYQ7D0
	 3UW3wGusFNFdVuzyg5RTam64nCdHpP08ZvP0QdyXB8L2cYhr0t+04fgKeZY64QSh/d
	 LFZ2rZZc/R6Vhp4+Mor0niIUQB43JvmlI+JUqpY7LcKc0s3QKMK5i8biXxWQ/0CB33
	 WSQz8L03t/iUlvGGVJ/3IVMdhJXZfZlykRnnkhVLiLFvzTWngnHwGO52/NPmEPREGW
	 4pyoTxrsSHZDQ==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: (sashiko review) [RFC PATCH v2 1/9] mm/damon/core: introduce failed region quota charge ratio
Date: Sun,  5 Apr 2026 12:25:03 -0700
Message-ID: <20260405192504.110014-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260405151232.102690-2-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 79DFE40002
X-Stat-Signature: jnkc1csuyoowjzs78x6khbg8fetfkm9k
X-Rspamd-Server: rspam06
X-HE-Tag: 1775417110-345043
X-HE-Meta: U2FsdGVkX1+DQ2/5Irqj8uksVTNZqWjLehW54DVhSM+ZS4ZB1usC1KoSz9HXJi/jfpzSsu9/f4FQMH6Ta+ir110FxkfZrPRjVF5dNgJOsO21rNSTAWaUelr+pY+1JxrgofXC4dcQ7D34YM/1zc7JvPApclaAU1Zdic9ovyh6t7yF/ytNVVv4iNmIEBYbZSeu2Iy+kZ738VCEw729V1fxsz95vZALkO8rlFdosjYfzF07QZaMIxxEgremTFSLTVQv1OMJeHUXP3QStoV+uMtZNc1ercp4U8O6s6HCc2QevIGlknSmsJx3CyMcYItgzvdVd4MFqYb1m0XQ6Af7keOTt6434s4R3OtDRRaNA48iN04Hf115CIAMTMEuecdsUYlnxVCNuLmmD1la0ogphxjCuXatqb5007bfE9yHhBUE0D5ogw8tUXZNBRXQktcsD20vM7bGdykaf+rRTrDtrNBFqabZEAcFiqWg9boN0PGFLwvU5TIzZqDGe4d5ey2nFq9D68qpK+E/U/aWODVWgm75KMyQrSOFrS4hMjZ87sVgfQEIgTv6pw1cR3um7jJ3KlFm5K6YgPf/gkh+ISvqFwnHOvNV8wQiJPa+lfveBDh97I9czx1szGLF8CMOgVgh2Jxq+c81HQZijSyCXzamPx6A8BQjG6sr9ebdiuDMJXG4qkqznQnw4UysLWSXPK4v7pvweyCuf4acD963GXFdpGMOqoofMHhKf7VPhNvwGzCQB0e3mnSVsZnxwV6odxQXKzE9abWQDvpLT2xrmGzsyB5PB7HHyvi25bx+3U1caaNxyrqQqfzDWdyuQ/1mI0r4b4nqzLdfPbJWAFG4i+sXoUR6JD4kyY1UNV7FQb+QhZbwasJ3lPhUOZdzvPokbpOxDECeHoGP/s3m2f3Mr2pXZORqKb8LUYx3RpVE75nUwTtvUs1HXHrOTNuliyiS46UcIeOgiotUtlU6pLuzIm06bWW
 y4xltnD5
 LKsF0wqDPNbXfbVqJMAdOuUeLZxqTdApxk/myVVv8bxmqFYEAopvAY0Qd2YgdTEol13Ca2ut+OQv4bfdQrqQ6I3snQhDr2KPvu4IcM3jlruU4tPTxvNXEjpLa4l/pHw0WaSFgzGbMA9+99VWSX0G+Yalq4KXXygsKeR8MhG9qC/eaQXZpwAHpdnMYJW7MSBD8YrpyjW5K0A1zbSduSdLmgSfnv3WWIdP0mnNrTkWTErrLmRJz/QL++agu/TbTqWc4lR6K4BVz9YYaEeqXHdhRRai0ae12WeptApOKb+2OP/ajvsP4+V0WJ4ai/pSmfJDxOnioiSW8z7MZ6u/CTSnHndyEhIoKIeIdu6xB4MqZ1zY8iLCT9W4LPJnjiwp8SH8/4iPd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

TL;DR: sashiko found one minor issue that better not to be fixed, one issue
that orthogonal to this patch, and one minor issue that better to be fixed.  I
will separately work on the hotfix of the second issue and address the third
issue in the next revision of this series.

Forwarding sashiko review in a reply format with my inline comments below, for
sharing details of my view and the revision plan, and also doing followup
discussions via mails if needed.

> # review url: https://sashiko.dev/#/patchset/20260405151232.102690-2-sj@kernel.org
> # start of sashiko.dev inline review
> commit feec6568732fbe7a81b21aa5fac5c470ce0f7381
> Author: SeongJae Park <sj@kernel.org>
> Subject: mm/damon/core: introduce failed region quota charge ratio
> 
> This commit introduces a configurable ratio to charge memory quota for
> DAMOS actions that failed, aiming for fairer quota accounting when actions
> do not fully succeed.
> 
> > diff --git a/mm/damon/core.c b/mm/damon/core.c
> > --- a/mm/damon/core.c
> > +++ b/mm/damon/core.c
> 
> [ ... ]
> 
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
> Can mult_frac() overflow here?
> 
> If a user configures fail_charge_num to a large value, the multiplication of
> the failed region size (which could be terabytes) and fail_charge_num could
> exceed ULONG_MAX on 64-bit systems, resulting in a truncated value added to
> charged_sz.

It can indeed make DAMOS work in an odd manner, but it doesn't break something
in real.  Also, the real world privileged users ain't set such large value.
I'd not make change for this, as I prefer code simplicity here rather than
handling the weird user inputs.  We can revisit this later if a real issue from
this is reported, or a simple fix is found.

> 
> Also, if fail_charge_num is 0 and actions fail, charged_sz increases by 0,
> leaving total_charged_sz at 0.
> 
> If total_charged_ns continues to accumulate the time spent attempting these
> actions, throughput in damos_set_effective_quota() would evaluate to 0:
> 
> throughput = mult_frac(quota->total_charged_sz, 1000000,
>                        quota->total_charged_ns);
> 
> If throughput is 0, the effective size quota (esz) becomes 0.
> When esz is 0, damos_apply_scheme() calculates sz as 0:
> 
> sz = ALIGN_DOWN(quota->esz - quota->charged_sz, c->min_region_sz);
> 
> This triggers the if (!sz) goto update_stat; condition, skipping time
> measurement entirely. Does this cause the scheme to permanently lock up with
> 0 throughput and 0 quota?

Nice finding.  But the issue exists even before this patch, because throughput
could be zero if 'total_charged_sz < total_charged_ns / 1000000'.

I will fix this with a separate hotfix, like below:

'''
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2683,7 +2683,7 @@ static void damos_set_effective_quota(struct damos_quota *quota)
        }

        if (quota->ms) {
-               if (quota->total_charged_ns)
+               if (quota->total_charged_ns && quota->total_charged_sz)
                        throughput = mult_frac(quota->total_charged_sz,
                                        1000000, quota->total_charged_ns);
                else
'''

> 
> [ ... ]
> 
> > @@ -2097,7 +2116,7 @@ static void damos_apply_scheme(struct damon_ctx *c, struct damon_target *t,
> >  		ktime_get_coarse_ts64(&end);
> >  		quota->total_charged_ns += timespec64_to_ns(&end) -
> >  			timespec64_to_ns(&begin);
> > -		quota->charged_sz += sz;
> > +		damos_charge_quota(quota, sz, sz_applied);
> >  		if (damos_quota_is_set(quota) &&
> >  				quota->charged_sz >= quota->esz) {
> >  			quota->charge_target_from = t;
> 
> Since the new fractional charging logic can produce unaligned charged_sz
> values, what happens if the remaining quota drops below min_region_sz?
> 
> In damos_apply_scheme(), sz is calculated as:
> 
> sz = ALIGN_DOWN(quota->esz - quota->charged_sz, c->min_region_sz);
> 
> If esz - charged_sz < c->min_region_sz, sz evaluates to 0. It then skips the
> charge update and jumps to update_stat.
> 
> Because charged_sz doesn't increase, this skip condition evaluates to true
> for every subsequent region, iterating through the remaining address space
> without doing anything.
> 
> Furthermore, the loop exits without ever satisfying charged_sz >= esz.
> Without satisfying this condition, charge_target_from is never set, causing
> the next charge window to start from the beginning of the address space
> again. Does this prevent tail regions from ever being processed?

Good finding.  Not a critical issue for a quite rare case, but I agree this
(charge_target_from never set) is better to be fixed.  This happens because the
quota exceed check logic is not aware of this case.  I will address this in the
next version by updating the quota exceed check to aware of this case, like
below.

'''
diff --git a/mm/damon/core.c b/mm/damon/core.c
index 47770221abe29..42e444b48634f 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2320,6 +2320,14 @@ static void damos_charge_quota(struct damos_quota *quota,
 				quota->fail_charge_denom);
 }
 
+static bool damos_quota_is_full(struct damos_quota *quota,
+		unsigned long min_region_sz)
+{
+	if (!damos_quota_is_set(quota))
+		return false;
+	return quota->charged_sz + min_region_sz > quota->esz;
+}
+
 static void damos_apply_scheme(struct damon_ctx *c, struct damon_target *t,
 		struct damon_region *r, struct damos *s)
 {
@@ -2377,8 +2385,7 @@ static void damos_apply_scheme(struct damon_ctx *c, struct damon_target *t,
 		quota->total_charged_ns += timespec64_to_ns(&end) -
 			timespec64_to_ns(&begin);
 		damos_charge_quota(quota, sz, sz_applied);
-		if (damos_quota_is_set(quota) &&
-				quota->charged_sz >= quota->esz) {
+		if (damos_quota_is_full(quota, c->min_region_sz)) {
 			quota->charge_target_from = t;
 			quota->charge_addr_from = r->ar.end + 1;
 		}
@@ -2406,8 +2413,7 @@ static void damon_do_apply_schemes(struct damon_ctx *c,
 			continue;
 
 		/* Check the quota */
-		if (damos_quota_is_set(quota) &&
-				quota->charged_sz >= quota->esz)
+		if (damos_quota_is_full(quota, c->min_region_sz))
 			continue;
 
 		if (damos_skip_charged_region(t, r, s, c->min_region_sz))
@@ -2736,8 +2742,7 @@ static void damos_adjust_quota(struct damon_ctx *c, struct damos *s)
 	if (!time_in_range_open(jiffies, quota->charged_from,
 				quota->charged_from +
 				msecs_to_jiffies(quota->reset_interval))) {
-		if (damos_quota_is_set(quota) &&
-				quota->charged_sz >= quota->esz)
+		if (damos_quota_is_full(quota, c->min_region_sz))
 			s->stat.qt_exceeds++;
 		quota->total_charged_sz += quota->charged_sz;
 		if (quota->total_charged_sz > ULONG_MAX / 2 ||
'''


> 
> 
> # end of sashiko.dev inline review
> # review url: https://sashiko.dev/#/patchset/20260405151232.102690-2-sj@kernel.org


Thanks,
SJ

# hkml [1] generated a draft of this mail.  You can regenerate
# this using below command:
#
#     hkml patch sashiko_dev --for_forwarding \
#             20260405151232.102690-2-sj@kernel.org
#
# [1] https://github.com/sjp38/hackermail

