Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC2BCCCA490
	for <linux-mm@archiver.kernel.org>; Sun, 18 Oct 2026 22:13:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9481B6B00B1; Sun, 18 Oct 2026 18:13:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 91F856B00B2; Sun, 18 Oct 2026 18:13:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 835426B00B3; Sun, 18 Oct 2026 18:13:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5A28C6B00B1
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 18:13:45 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B9CB9A81BC
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 22:13:44 +0000 (UTC)
X-FDA: 85337149968.22.33B35EA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id B59C940009
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 22:13:40 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HuASiBCM;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792361620;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g1ox3F3vY0udjg1jNOYHLcMDmNuqPu327im69Kd+WlU=;
	b=C86/4Dw+NLmYK7IWrHyDGoUb3iROjh+Mjdg8dScx45Lpafuo+Qc7wNnVWeSdSGvXg4jb8D
	tjaKTt3rllwor2EtsjW+wYH3w/C38aRISvkAvb6o9Wy/VlzPuCayXg+ZMzLMYiW8cwSwV9
	8Pv+QsgcwKd3lhSAkfra2yNPDgYeyyM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792361620;
	b=XWCqb1xOc+xv3fAMwCTrCVSSsLvyi6PrxOWluY5mOQsYJN0LfQb1d/rNhHgxzZcfTauWGa
	SVNmWFchGVElTf0HNeD82KzQTjAXeGAAOOZjWQzG1FAE1frAy+bLG6zTgf9hfgeF107xv3
	7Q9nPMtkI0ri09LqmC7jMCCmSCFTZ+c=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HuASiBCM;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2665960DA0;
	Sun, 18 Oct 2026 22:13:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 962B51F000C4;
	Sun, 18 Oct 2026 22:13:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792361619;
	bh=g1ox3F3vY0udjg1jNOYHLcMDmNuqPu327im69Kd+WlU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HuASiBCMB0bQyh2+ueLSuaAWt4A9220/zXe5IvoBS28/Um4p6RspWEEGZpYxWlmFt
	 sOYWpsVy8xFQJBLtNCcT30hy0XUR9Vhsglho5WLN2WZJ5t4q6suaE9qX0rdh9hT6a7
	 +pk3zMBr2mHYlZ9qUePVgmsC9PKDXQuF4aG5t0xMtBsSlPB8hJGFPTuMkQK3tb2vQo
	 n0r6k+bLe1r4w6wwb+GqirnMOs3nefIbvDIta+LMTsURKA+nPGNhdxFIpcFL9oLnx8
	 XclIush3QgtCvi16GI1IEcHyoky0lRZ46P+h4VAotzFIcxfXldZ/Fc/lFVSvmD5C4b
	 32+YB4CZpLTLA==
From: SJ Park <sj@kernel.org>
To: sashiko-bot@kernel.org
Cc: SJ Park <sj@kernel.org>,
	"Andrew Morton" <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH] mm/damon/core: filter out damos address filter-split failed region
Date: Sun, 18 Oct 2026 15:13:31 -0700
Message-ID: <20261018221332.158824-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <sashiko-outbox-176425@kernel.org>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: qer9w9oqyu3875qrikxthx6mbtd17jrb
X-Rspam-User: 
X-Rspamd-Queue-Id: B59C940009
X-Rspamd-Server: rspam10
X-HE-Tag: 1792361620-69293
X-HE-Meta: U2FsdGVkX1/tj+qPjN/G4jngYiMoPwijCUVjtldTmZ9gsygYc7x/rsUki08B5OrfjXzfavR7eCeGV6omQ85JYnv6np564iFEnpPdwH+ZnLqwqd87T3ivxO5FW2gIXAxsIH/Xm1L/gYPsyon3gW+Q3CK3TcDAfjP+CdfNJNxAnyLmO73GteI+Hd2f3+6WIv6hU9iu05uril1g590pynoBuKTQwrdLZJdbqEHCLXz/pvwShabR6R07O/eXUBEOD2BpgzvCOo3bMabh4/UqKj+YWSrr0It2VnaO+aArEyyDu0HlDKy++jLCAZuiXjzXLX6KUoxEH7315iub2nJQighhlgzePRyVjq3Y0DSNPv5nWWtcDnQ6S28kfVmEWOu7KULtV7R+2zn6B8tQonEnysVg0pua5E2VH/Ah9dk7MTFdJQUiSIDj23ORCOih+2qTa4XOUm0lwPUWffb+46O8/6o3miOK2ufyOTqWDtIEbLfi0+vjJohC/yeJnO6O0QuKMn3DqBAA2qA95yq60f8wHCC/mMp5T/UvaWNRqG2BprgdxsDqUBqrGag8rnC7Q1G/IUisBcKOuA6hZuRQRq21TDlvExvA2nalEwGpckoYEtEmrhuYeG1vzk1mfNLUQfhJYUOCpf2QJA83HTDf/3OFPS5BSwjpKuZ0qwwEt+KEZAfGZssxZZcPt4+3kEFTP2EWlRR/auL5/NeImbrTg6XmR8EERkwgnahwercZUMxj3S+EST1KL/dRRjHJE8i37kD+yihbHVTU8qjV5ZQnAAs3T3ZkJ30JKIWUydtbA3n/J7t5DR9KMge4qDymCubjdj2YL2Srb+I0vztmT4R68tGZW/+t7PcFKf4+Z7Ob2tiHEEyAfJHn08pmLBdktFAZVbAuNEfqa54/WZLtPe3wQLgQhJNTBEluyeBFKL4kCtKHssiXpfKQj38VrAzICBHiJ4mNpT4H4ftSD13u5OivBtgZEIz
 KWCtAJOW
 8KqSOYaCyhrIb6sBt+AewpiMB7m3XlQIGCnX1QJvSixEysldGdiE1jbjqnGcVICa5/HYic9LlD3ocd/UL+m//9nP3PNQNAfT2E2jcR2vl0uiQo/V5IqMX7XvkQZoYF/9CBEqjIzgBi8lu8kAhISE5aiT6ek1SPrF54V8UwOZADRjQ6ukhfYVHgnrRdL+zBG1l8jmkiBuP8nCocc0BaKZHUD0H5rVeDmVihJHMha0WdwbU1xDNamqhtXvm4oXYoogbgFI2UhQGfW0oNGF/bNvlORtIv6zwBeNTn12usat40Ti/TdOanMGRBdJ9cLlWHRxosYNZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 18 Oct 2026 22:11:06 +0000 sashiko-bot@kernel.org wrote:

> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [Medium] mm/damon: unchecked damon_split_region_at() error in damos_filter_match()
> --
> 
> commit 881e287348e01011e3ec5442e7deb6f9c112db9c
> Author: SJ Park <sj@kernel.org>
> 
> mm/damon/core: filter out damos address filter-split failed region
> 
> This commit updates damos_filter_match() and damos_core_filter_out() to
> propagate errors from damon_split_region_at() and filter out the region if
> splitting fails during DAMOS_FILTER_TYPE_ADDR evaluation.
> 
> > diff --git a/mm/damon/core.c b/mm/damon/core.c
> > index b63e60ef89901..4d34587387456 100644
> > --- a/mm/damon/core.c
> > +++ b/mm/damon/core.c
> > @@ -2551,13 +2551,14 @@ static void damos_update_stat(struct damos *s,
> >  
> >  static bool damos_filter_match(struct damon_ctx *ctx, struct damon_target *t,
> >  		struct damon_region *r, struct damos_filter *filter,
> > -		unsigned long min_region_sz)
> > +		unsigned long min_region_sz, int *err)
> >  {
> >  	bool matched = false;
> >  	struct damon_target *ti;
> >  	int target_idx = 0;
> >  	unsigned long start, end, wsum;
> >  
> > +	*err = 0;
> >  	switch (filter->type) {
> >  	case DAMOS_FILTER_TYPE_TARGET:
> >  		damon_for_each_target(ti, ctx) {
> > @@ -2588,7 +2589,9 @@ static bool damos_filter_match(struct damon_ctx *ctx, struct damon_target *t,
> >  			break;
> >  		}
> >  		/* start inside the range */
> > -		damon_split_region_at(t, r, end - r->ar.start);
> > +		*err = damon_split_region_at(t, r, end - r->ar.start);
> > +		if (*err)
> > +			return false;
> >  		matched = true;
> >  		break;
> 
> [Severity: Medium]
> Should the earlier damon_split_region_at() call in damos_filter_match()
> when r->ar.start < start also propagate its return value via *err?
> 
> mm/damon/core.c:damos_filter_match() {
> 	case DAMOS_FILTER_TYPE_ADDR:
> 		...
> 		/* start before the range and overlap */
> 		if (r->ar.start < start) {
> 			damon_split_region_at(t, r, start - r->ar.start);
> 			matched = false;
> 			break;
> 		}
> }
> 
> When a region starts before the filter range and overlaps it (r->ar.start <
> start and r->ar.end > start), if damon_split_region_at(t, r, start -
> r->ar.start) fails with -ENOMEM, r remains unsplit across [r->ar.start,
> r->ar.end) while matched is set to false and *err remains 0.
> 
> If the filter is configured to exclude [start, end) (for example,
> filter->matching == true and filter->allow == false with
> s->core_filters_default_reject == false, or filter->matching == false and
> filter->allow == true), kdamond_apply_schemes() -> damos_apply_scheme() ->
> damos_core_filter_out() sees err == 0, does not reject r, and proceeds to
> call c->ops.apply_scheme() on the entire unsplit region including the
> excluded address range.

Good catch.  I will fix this in the next revision.

> 
> [ ... ]
> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20261018220253.158238-1-sj@kernel.org?part=1


Thanks,
SJ

