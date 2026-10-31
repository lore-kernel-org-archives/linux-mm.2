Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DDE65606A31A
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 20:49:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NF3x9qzp
Received: by kanga.kvack.org (Postfix)
	id E58D06B00EF; Sat, 31 Oct 2026 16:49:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E09A16B05B1; Sat, 31 Oct 2026 16:49:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1EA96B05B2; Sat, 31 Oct 2026 16:49:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A9E986B00EF
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 16:49:33 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 43732801CE
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 20:49:33 +0000 (UTC)
X-FDA: 85384112226.23.9C6EFC1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 8E8ED40003
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 20:49:31 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NF3x9qzp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793479771;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GfcB9TvOu6Mjj8+qufOnmdae3K58sylRc4kNrDjGfQQ=;
	b=pjnGaDJBha8KFIuiznD5D+TJ24IxAO3Ad9ziqZ0EX4TCdEEd7NV3jeVHdBvGzJxogza8QX
	DiThuceErrs6CH6KVXS611dNXqH/y1t9HbosQXWWc9TuCrKNjMIWFzVw1e/C6abvX1fcrc
	IkvnkeLyOzIrETMrybQbPLU3TZNbnXw=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NF3x9qzp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793479771;
	b=I/rokwzJpnaMdMijvHxtNudP9R2tqKbADVjZcrb3dTwzHbPG+lBQs7CseRYMR2Hlf94xJ/
	E9TyoEcjq/Upzcdsu5wz3GJg/H3Y+wQ4hI6qPcO7h/FCtgfZnFQzyZTbR1G03fM50evN+e
	zT3Q88ApJYSFiEtiwVO/GYSTJIm9JFw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B28EA4082D;
	Sat, 31 Oct 2026 20:49:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5186E1F000C1;
	Sat, 31 Oct 2026 20:49:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793479770;
	bh=GfcB9TvOu6Mjj8+qufOnmdae3K58sylRc4kNrDjGfQQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NF3x9qzpmt9KSRu9FegTUQncFR0lNXiplGIUK5tfIM7DStEB7TvANGiTkMivbrg1J
	 YY0E5M+pIUS+APOGc9F8vQOCmZ1bQ7wD571M8Fzoj40vPMJfGlx9ZIZPvwHKKNqLIS
	 59tK3arW76yF7DkUS4R+MI2EFUIp2J7ZfR8FCErTe8+N2zlJ2YAWuw3vNdChspJmsM
	 Wc/HC5mwBvVK+zCYpTvDN0tPiuS8BkGKfN52bb0y/7UzPsojMTkIY6qxvtbKK07+Gg
	 X7Kt78GRA+dj/jEVZjMiynqaQTa7yowLezXjGfGbXqvFvaYThFryjWiuVIqK6wK96D
	 DhWgdGJypBO0g==
From: SJ Park <sj@kernel.org>
To: sashiko-bot@kernel.org
Cc: SJ Park <sj@kernel.org>,
	"Andrew Morton" <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH 1/6] mm/damon/core: handle invalid target in damos_fix_stale_charge_pointers()
Date: Sat, 31 Oct 2026 13:49:21 -0700
Message-ID: <20261031204923.96778-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <sashiko-outbox-192118@kernel.org>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 8E8ED40003
X-Stat-Signature: dp8d39p6rnxr8emrihotx797i6ff9h49
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793479771-698849
X-HE-Meta: U2FsdGVkX1+OKf+LeB3Ovmqgys8gIdY/bPixgctgIsyOrc2VKFJhB8W8rJnwb+U9by8tEAw2VXKidd5/Fru5GgJezqfgXp8tmI/YtdrtPf8CwV/v+nQJemKR/Egfz2pEImonZFfIrnYSq2rKM3p37nZ2pCuWg5wbf+g+9Y/vVxFhzQ+FtsyycRUynrgVzTr9siRa/z0XAcz/NNJsdKpIbhgAYMZXR9asecA+Ay4U0nJphT2p/yY/VYtoQaaGNaB/JrdCEUuV57B6/dz6BL/MIJW3b2CPdEnV3m+4NwELbbO1o+hSiurn+InvQXfVlwRwyxgQijKkHEHTL48ZIMvGpR1uzUWypXlLb4Wm5RBv3b2fmyNmydCY0TKjAQgb6UA4ZUI4tNv0/ACuRGQXqDu3MogsqDK87A2C8IHg2YfEHwevwPRsjnbSt5bdZzhfaz00BUZfQbfGDkdWdmeccvR1nvVYsU/hBoGNOyyceLM8woVLREN+7QM5ztNWozp74Bpo7nUHfMtsLC7ahXt8IhxICxKuJUd0m1tTzAku84tfRXd+FFvlAqeqSnU70u4akSEn25m1oNIq8lYR3Y0cig2E7gk1xdD0yO6XW22uNt55UHlRyRqAnZj1m8jdZGruVvmysVxyCEb3CJb/ltdCkiwTbnq6/gWpjx6O4DBfQQgxT3Ae24msstqJK/N3QY0Bm6m13vsIadI/GaPoA+Wn87zcprm6fvYwdbampAiATKXv6mzZH6AWVNP/aDIE5h+kQeUPQNm6qOKqaL+P7kU+NDb3T8Ie/RV9PTUrTuveTO4qYOlmQ2G6oP4X8UEAEkdsFFxuJYS2OvBMWICR2sitVdKMPFdOmqU/PZLBA/x9pQPAZDYC3Rz8u01V2hGiN82B/gHMu8rCRgc2ZrqfF414MXPjWcyWAZvHKcEO8yhFaUHo8tKo6W5VUnKcMHrMaeAbxfMOjBporT0vGL41UiRTHqA
 K/uGcsN5
 BVzP9fJwdNsnzz6riWND+dcAu/H5qAlLfeFm4Xb98phrUX4hci5QDnuzV32tbT7WhuMkjAPcaXCUGvPIHVpILjPCOG1/6TR1SXIyP32928VDRxXRcc4vtlFB1U1TjELyN0+omUv3BMNif8dSgjfy2B4i+DlYbZcsSjQgcpFikxTlyIfspaT6GeH1hm6LejaeRf5gG00nrS0Kc//W+9SDpqWxat0hGS5iOgE0Bsv1K3SofCh6dJtSQQQ9WnJJpQ0XT9qRPigK9Wh1dfntYIeLN9/6cpfsQz40CuKXOwtpG2bFNuLTiPtQ795nWDDz133oSNj/i//MNMTZF9AfkObucexCro6bjJYdPe78hAWdFUyli/wDImBy7Vm5Bpg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, 31 Oct 2026 20:36:25 +0000 sashiko-bot@kernel.org wrote:

> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [Medium] mm/damon/core: stale charge_target_from and skip regression on invalid target
> --
> 
> commit 3b1cac25b68197d5c2819d4a16dbde02446b2d07
> Author: SJ Park <sj@kernel.org>
> 
> mm/damon/core: handle invalid target in damos_fix_stale_charge_pointers()
> 
> This commit moves the DAMOS quota charge pointer fixup for invalid targets
> from kdamond_apply_schemes() into damos_fix_stale_charge_pointers().
> 
> > diff --git a/mm/damon/core.c b/mm/damon/core.c
> > index 73b571b429cb3..ce75db510a9d3 100644
> > --- a/mm/damon/core.c
> > +++ b/mm/damon/core.c
> > @@ -3394,7 +3394,11 @@ static void damos_fix_stale_charge_pointers(struct damon_ctx *c,
> >  		return;
> >  	damon_for_each_target(t, c) {
> >  		if (t == quota->charge_target_from) {
> > -			if (damon_nr_regions(t) > 0)
> > +			bool valid_target = true;
> > +
> > +			if (c->ops.target_valid && !c->ops.target_valid(t))
> > +				valid_target = false;
> > +			if (valid_target && damon_nr_regions(t) > 0)
> >  				return;
> >  			break;
> >  		}
> > @@ -3513,15 +3517,8 @@ static noinline_for_stack void kdamond_apply_schemes(struct damon_ctx *c)
> >  	max_region_sz = damon_region_sz_limit(c);
> >  	mutex_lock(&c->walk_control_lock);
> >  	damon_for_each_target(t, c) {
> > -		if (c->ops.target_valid && c->ops.target_valid(t) == false) {
> > -			damon_for_each_scheme(s, c) {
> > -				if (s->quota.charge_target_from != t)
> > -					continue;
> > -				s->quota.charge_target_from = NULL;
> > -				s->quota.charge_addr_from = 0;
> > -			}
> > +		if (c->ops.target_valid && c->ops.target_valid(t) == false)
> >  			continue;
> > -		}
> 
> [Severity: Medium]
> Can moving the invalid-target reset from kdamond_apply_schemes() into
> damos_fix_stale_charge_pointers() cause stale quota->charge_target_from
> pointers and alter round-robin target skipping across multiple targets?
> 
> First, in kdamond_apply_schemes(), damos_adjust_quota() (which calls
> damos_fix_stale_charge_pointers()) runs for all schemes before the
> damon_for_each_target() application loop.  For virtual address space
> monitoring, c->ops.target_valid(t) is damon_va_target_valid(), which
> checks whether the target PID still has a live task_struct.
> 
> If the target referenced by s->quota.charge_target_from is valid when
> damos_fix_stale_charge_pointers() checks it, but the process exits while
> damos_adjust_quota() builds the score histogram or while
> damos_apply_target() applies schemes to earlier targets, the target loop
> in kdamond_apply_schemes() will see c->ops.target_valid(t) == false and
> skip t without clearing s->quota.charge_target_from.  For all remaining
> targets after t in c->adaptive_targets, damon_do_apply_schemes() calls
> damos_skip_charged_region():
> 
> mm/damon/core.c:damos_skip_charged_region() {
> 	if (quota->charge_target_from) {
> 		if (t != quota->charge_target_from)
> 			return true;
> ...
> }
> 
> which will skip every subsequent target for that apply interval.

This race can happen even in the current code.  That is, the target could be
terminated between the current check and damos_apply_target() call.  The race
can happen more easily, but I don't think this is a regression.

> 
> Second, damos_adjust_quota() returns early before calling
> damos_fix_stale_charge_pointers() whenever damos_quota_is_set(quota) is
> false:
> 
> mm/damon/core.c:damos_adjust_quota() {
> 	if (!damos_quota_is_set(quota))
> 		return;
> 	...
> 	damos_fix_stale_charge_pointers(c, s);
> }
> 
> whereas damon_do_apply_schemes() calls damos_skip_charged_region()
> unconditionally.  If damos_quota_is_set(quota) becomes false while
> quota->charge_target_from is still set to a target t (for example, when a
> quota is disabled or its goal is removed via online commit in
> damos_commit_quota(), which preserves quota->charge_target_from, and
> quota->esz becomes 0), and t exits before kdamond_apply_schemes() reaches
> t, neither damos_adjust_quota() nor kdamond_apply_schemes() will ever
> clear quota->charge_target_from, causing damos_skip_charged_region() to
> skip all other targets permanently.

Good finding.  I will drop this patch from the next version of this series for
now.

> 
> Finally, when monitoring multiple targets [t0, t1, t2] where the previous
> quota window stopped at charge_target_from = t1 and t1 has since exited,
> kdamond_apply_schemes() previously skipped t0 via
> damos_skip_charged_region(), cleared charge_target_from upon reaching t1,
> and resumed applying the scheme at t2.  With charge_target_from cleared
> upfront in damos_fix_stale_charge_pointers() before the target loop
> starts, won't kdamond_apply_schemes() restart charging from t0 instead of
> advancing to t2?

Again, good finding.  This is only a corner case that happen only for one
cycle.  I think it is a reasonable tradeoff for code simplicity.  But since I
decided to drop this patch for now, I will think about this again, too.

> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20261031202614.96036-1-sj@kernel.org?part=1
> 


Thanks,
SJ

