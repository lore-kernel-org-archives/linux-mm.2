Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28202F3ED59
	for <linux-mm@archiver.kernel.org>; Sat, 11 Apr 2026 18:03:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 41BDC6B0089; Sat, 11 Apr 2026 14:03:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3CCB36B008A; Sat, 11 Apr 2026 14:03:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E23B6B0092; Sat, 11 Apr 2026 14:03:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2178C6B0089
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 14:03:39 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B8977B6058
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 18:03:38 +0000 (UTC)
X-FDA: 84647047716.22.6FC6CAD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id F409E14000C
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 18:03:36 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KGHlTDeB;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775930617;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jXrzARzFMasYeWBVFe2wOQoT8fUHBXJT5xXbD1rsTho=;
	b=rVKxhkR/TMGdrgKfOBHM15n3jONOlq+iXyjIxoZRZmo2XNUTWXAU1UyIM6UPk5aF8GhpOA
	HOsuxOsD4w6DgeEKFJGEotxnl/B8WFxO3PyNCeY43gbdktItnN5hwO0ppxTShgT3k75GNt
	xA7yKwvHv5TwfHoZA03SR9l6k3rhCfo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775930617; a=rsa-sha256;
	cv=none;
	b=aN5+gueUTSjMi3U2JeRxtNRT3AZ0ee27UQmjzoRabOwEDH/LKAvzPMXp/J1FsrtdcchEbh
	+FzfG25EKnR8YdNRkfDAcdeN2zzMB9IFZ9cdBm3KtpmUlQGGKH2fdh+yEkL51+3hDLwZSC
	keR7cRw3hf8gnX5RkqBc/Fo5/Qzu1+A=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KGHlTDeB;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A671941A21
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 18:03:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52866C2BCAF;
	Sat, 11 Apr 2026 18:03:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775930615;
	bh=DBCgDKz+lnsk8HdK5nYVKKWSxqPwPqoy8Cf/9pXeUhc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KGHlTDeBJv8aIl5PRXUvhhoIvAfsZz0o1q/g7s8Tokd7fdo6E4hZhA5GTXNulfIOt
	 addZt98NFQ/M93/VMLKgvVRujpQTkDJHYnteW5eg3583RLJHaHSWv8vCBVERpHeIXP
	 IACPZ9UXa/VrxQb0O6PlIzZDKoQVPLwb5HsdJomszqlCPFak7WPFjfFd4R9meec29m
	 FFYTbZw1Han3B6t4FTpPa7d10rN2vI20G8G9dg6QgLcouTuGOIdOZMa6kd3KecBEqG
	 p7Ieti/WjikUiPEuJuGDqd0pT6nhpOo0G3pexqAH/IvAueN+bJdvBCHuG0xy8MYtRp
	 oaELcSv906k6Q==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: (sashiko review) [RFC PATCH v5.1 02/11] mm/damon/core: merge regions after applying DAMOS schemes
Date: Sat, 11 Apr 2026 11:03:32 -0700
Message-ID: <20260411180333.79709-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260411164908.77189-3-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: F409E14000C
X-Stat-Signature: tm6wu4qzdnpebikc4j89mrxizcunz7pz
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775930616-338126
X-HE-Meta: U2FsdGVkX18xAIyhd1ciE7QM/CUlMmiVJWnx4/x9CZ8ouMhDXeSfi1gEY8Uh1FGJwq1QDd+bxl9Mtdyjf+YtUkRz2cwbMYujENgIO9Iu9KrtjFXbK9lCMWLQ1Xc9pzTu+FoKqhqQGHUcj9degjSl/zX6lhI3fyGSwUhtgJFnXBIkRvP133DDBnhwc/udSJo1DI/5Et/IeK6PYkyzBik1TDJbwuld7xLMVTbTd3zWNMr6L1Tx9/I0BGt0GPGDZaKzxbs9ItVpYdTrRpuW0zrMxs+SaY91+cuQO94uVOOGWDTf7xM+QmeKvvjB03RV0QQjpn8nI5UYg5fgtf+PVSb3dsV91zuZUsahMmQmzcp+Tw0A3NYE5DtQJVmJVzIYWoMlCJnN2W57XukRWLybooeM1rXKjcrSgeAL65tfDkS54h9IMAj6Zif/Dl6LRARmMZxu7CxrSplprCSzkbolo45JbsF2W81Qj8Ae1kqf6HNhm7mPGZ5hLxtQQMZd8s8dcRIPPMkjIXR12ztAIshMWputHI7dmzjVwVZy1rYnk9E7aE9hI7Q3lX0dTAZawvtTU9GPAjanzbo7Z1xCPRriy3w+UKuLrKmiUDkdkondECqFf+wXgFQfHISSaV69INU8rtFLcn/oMIoHCeTGEemgO2RXrp40DMKJ3rb248GNimrN3+s9pqPOwMYFjbcgwlDnHJXdihEZsQbO8Fu9izyoP8mv64zGnhGp1ioViNePElCSmq3GgToY7EXr9mCU+8afdUiINa4a+M921RY0iYOiEB1XhkLueinP13wdDQ838e9djDcgB7uEoG0v76/uUWYWavB7G0eZC6dEk+CWXMKfAa5rRyyXq7tFJCpAYGdmju0TjrZg6Ay6JC2pUxe5GgYAwF9SjkJ0ovcEOZj7xILuuGmtS0qjdjXMfI1iC777AQTG533eNiTTvkk78FRe+RVBoD/FT/YBZWSE2znTj0ojRLQ
 fIPyCJu+
 1zRV7jFZWeu5B8GYjcBpLjGsxFdsTY9U6Jt2e0QzGfDdX1hohNi+7kIaH4bY13Ad47qiWi5Vd5NhPq5p+fstU3PuZFNR8w0tDKXocULOz60hc43ghNECY18N7KHWpr9Oh+0f2ZAtkIeUaSCijsmf261hZy8sePrtqZvmwvet+nujRnyk5/IS4pcQwWXIXNDn4kOpMIQF/pSLGMVTpCcl0gpmbnAYJ9CY7eYg4uqrmjTidoTu6qBPmyzqj/7WhWpiaOzSVt6JhVyB79aSQpyusOBW6fOFCtpt9yczhd0InWQ55Bdg//1L16fN3Y8U4Y/PQfVnrbA6QjboCh3WHLIbaebdgbU+p36v2Ujh99fEElPmAU5U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

TL; DR: sashiko found a typo and a fact that I forgot adding a fixup that I
promised on the previous version.  I will fix those in the next spin.

Forwarding full sashiko review in a reply format with my 
inline comments below, for sharing details of my view and
doing followup discussions via mails if needed.

> # review url: https://sashiko.dev/#/patchset/20260411164908.77189-3-sj@kernel.org
> # start of sashiko.dev inline review
> commit 1a56d6af604a3fc86a23180a9619447641294a2f
> Author: SeongJae Park <sj@kernel.org>
> 
> mm/damon/core: merge regions after applying DAMOS schemes
> 
> This commit introduces a mechanism to merge regions after applying schemes
> to avoid overhead from regions split during quota-limited scheme application.
> 
> > --- a/mm/damon/core.c
> > +++ b/mm/damon/core.c
> [ ... ]
> > +static void damos_apply_target(struct damon_ctx *c, struct damon_target *t)
> > +{
> > +	struct damon_region *r;
> > +
> > +	damon_for_each_region(r, t) {
> 
> Is this list iteration pattern safe for long-term maintenance? 
> 
> This loop uses damon_for_each_region(), which is an unsafe list iterator,
> but destroys r inside the loop and reassigns r = prev_r to safely continue.
> 
> While this works by relying on internal macro expansion mechanics, if a future
> developer converts this to use damon_for_each_region_safe(), the cached
> next pointer would be evaluated before damon_do_apply_schemes() potentially
> splits the region.
> 
> Could this cause the loop to silently skip the newly inserted slices entirely?

Yes, such mistake could happen in future, and this code could be better written
for long term maitenance.  But that seems better to be revisited as a future
cleanup work.

> 
> > +		struct damon_region *prev_r;
> > +
> > +		damon_do_apply_schemes(c, t, r);
> > +		/*
> > +		 * damon_do_apply_scheems() could split the region for the
> 
> This isn't a bug, but there is a typo in the comment (scheems).

Good eyes!  I will fix this in the next spin.

> 
> > +		 * quota.  Keeping the new slices is an overhead.  Merge back
> > +		 * the slices into the previous region if it doesn't lose any
> > +		 * information.
> > +		 */
> > +		if (damon_first_region(t) == r)
> > +			continue;
> > +		prev_r = damon_prev_region(r);
> > +		if (prev_r->ar.end != r->ar.start)
> > +			continue;
> > +		if (prev_r->age != r->age)
> > +			continue;
> > +		if (prev_r->last_nr_accesses != r->last_nr_accesses)
> > +			continue;
> > +		if (prev_r->nr_accesses != r->nr_accesses)
> > +			continue;
> > +		prev_r->ar.end = r->ar.end;
> > +		damon_destroy_region(r, t);
> > +		r = prev_r;
> > +	}
> > +}
> 
> The commit message explicitly states the merge operation is made only if it
> keeps the min_nr_regions constraint. Does this inline merge logic bypass
> that constraint?

Argh, I forgot adding the fixup [1] to this patch.  I will add that in the next
version.

> 
> Earlier in the execution, damon_apply_min_nr_regions() enforces the limit by
> calculating a size limit and splitting any region larger than this limit into
> smaller sub-regions. These newly created sub-regions naturally inherit
> identical age and nr_accesses values from their parent.
> 
> When kdamond_apply_schemes() subsequently calls damos_apply_target(), this
> logic will immediately merge those freshly split regions back together
> because their age and nr_accesses match, entirely omitting the size limit
> check. 
> 
> Does this unintentionally destroy the spatial monitoring granularity every
> sample interval?
> 
> Additionally, when merging the regions, this code expands prev_r->ar.end and
> destroys r without accounting for r->nr_accesses_bp.
> 
> Since standard functions like damon_merge_two_regions() re-average metrics
> including nr_accesses_bp, could this inline discard of the fractional
> nr_accesses_bp tracking result in a slight precision loss, contrary to the
> commit message's goal of not losing monitoring information?

Yes, that's valid.
> 
> 
> # end of sashiko.dev inline review
> # review url: https://sashiko.dev/#/patchset/20260411164908.77189-3-sj@kernel.org

[1] https://lore.kernel.org/20260411163340.46397-1-sj@kernel.org


Thanks,
SJ

