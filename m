Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AAEA3F3D5FB
	for <linux-mm@archiver.kernel.org>; Sun, 29 Mar 2026 15:36:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB9856B0092; Sun, 29 Mar 2026 11:36:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E91186B009B; Sun, 29 Mar 2026 11:36:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DCEBB6B009E; Sun, 29 Mar 2026 11:36:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C9BAF6B0092
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 11:36:52 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9C072140420
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 15:36:52 +0000 (UTC)
X-FDA: 84599503464.13.15861A5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 06F1AA0002
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 15:36:50 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tqmzShbM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774798611;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zqH9qAZvPWII5AD/YPCnw84oqpCqdBo5w/b0LVB4L20=;
	b=tY/ngvYQ1fKahK5wL3k8Srcm5HvdtoKU3O4KfFgnnYhyTAaoKI9F2hWm+KHwYrsR7v0YT0
	WD7o1bd2NcNbEI+9aSXF2VSn8l4FptxeX405pxg2HhlHj4UNwYZE9pJlIyLIC5/MP9yZJx
	LdKs3689kUNfxR3cJWPjJA48ElB/ohg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774798611; a=rsa-sha256;
	cv=none;
	b=o2I731npxvzqfbySwoeA4G5TqyMyc4RUyd692LMk0uOK+xphSizAn8DJBSarKxg87tKVFx
	CQfzffnxd1uDvKLHCyYfgkxXJBMjPYFuouz6r+8y/MAVzqcbfypdHaaVclIZtCuzf430x5
	igrCWO/iq93j3JIoyCV1pnIbs5BMgMY=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tqmzShbM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 725D860054;
	Sun, 29 Mar 2026 15:36:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A735CC116C6;
	Sun, 29 Mar 2026 15:36:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774798609;
	bh=wUEVhZoXsCyGZdr2zQUUKoIVCQrmq8kfzrwZor4bN08=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tqmzShbM7Qn6aXcqe5+c6k2E0aMzkgs5OaKlOYuCnEhRM/jUzgAiaapNguG2bJzVJ
	 LBxBoxQZLFWwyxHpC69+nTenFfwmxYsU9MOPRTZMH9Ev4YbIeWxa1IIg3tWWTSrOfY
	 +GvHaKnvsNdHUCyxUCtm7bQRdkWoSihjfKq2thLNCFM+aq2bNLdRWrfeIqr89J78Ce
	 TW//quEpKV/nGz2qrTGRcmTyROr0qhpBPdXc/jQJhQQXv5+zTQcfudzxIvJd6ce2GO
	 j95JxJSq0RKVHEmG7j7o61GGTf39ea24fUBFhabhUile9ikDzHhuUNhZe/Fq3eIO47
	 JQ2jFIEowUJ2w==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	"# 6 . 16 . x" <stable@vger.kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: (sashiko review) [PATCH 1/2] mm/damon/core: validate damos_quota_goal->nid for node_mem_{used,free}_bp
Date: Sun, 29 Mar 2026 08:36:47 -0700
Message-ID: <20260329153648.47235-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260329153407.46989-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 06F1AA0002
X-Stat-Signature: 1i5xmj9ywiwxifqs5c8ey44kc9nc8emy
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774798610-836136
X-HE-Meta: U2FsdGVkX1+9Yqlo++0oetB6ksrvuqlJXQSirS34zYMV5oXddQZldr1TuVuAbzzaDERm0kGthIsvGyintTM2KtjA9pRKivfYfoK0afrrMfYehpsOnELEPBw4RfoYCdiJHPcff8fEk5H1HTlAx90b5kMht3IM6mSnUmcYs7r+2M30/geu5P17TiB5jjPCLmYthBBvoTNHSeiDRof700syDIkshP9X701A99NM3vdJ2mI6GMGDAw45mCBQF+A6qeqAq1HDzwipWmZZtIzxow6lFGAV+u26LQXZdn97qXP5xMi/e6DmUl7CFIIb2QLw/qd+niX5OnWUFSm1a1SDGndS/llWSeAlmzU75muDUd+/f78dLzIPKmWJHPZzkbqs35NhFE4vy/vQCppDpViFmaQmEz9ZaElGGr0JdrRQJXH6mPi3ldNsg5/9tsZgQS8GFXXpIymZDLQ3jsRrGz1bsUQKG8buzw/dbx1zxCtEsbPNwaWCwlOzxppCENHnOOfIJ6kigUuwj3yrna1tVM+15pwQpof+pPvSt9O8Ywb3cnHMuolhWXeSQQ43+O0z/tj4epA7+r4Qnu3duoZYlb8Gt21ulFsbcgBfy38FDDtOkukhS3QrJaCGiX18UwApwTCahJNkQoNKG/to69Bju8MusvghYEg2EUbiblgnODOwIUTCsWOeLLOleX0WoRsNTrR5ru/zUEexCIQKPV+BM6ChAt2LW/ILQyfRFv3NCNergX8CGyrLtVkIPe0rOMHNJlxh5ITx8CSx5o6dkMib+NzaRzOyEZuGWrFHTzpBaxPi+PRG6rN57AaIiys3W1fSP2shEf9nIfbZedgkBkAsNybmumVvW+EdQyiXjfyKAdh3jG/z1W0Be8/PTiX+qugzjFpxaqqONpo4CW7R17d6Ly4TWhn+sKBAixMjLl4S8f8FwiGDzbKtnT3O3HeMbH00bCHH63JHFAG0UgRVvvDYjB5i2vW
 RvXCXMO8
 ZidABAZ72tH2SkFPQ/Oid6lUjIRZAjsOzU+xKF8J6OPysYSKXiRsX4tS/YLIFz5YshVHAN9WBt4LDNmEAnXeEBGnxx/mmRWZmpAQXG3AJO+Qx3qU6Dy9LFJ7oA25FgYJZReuKMkiYPNkbteVf4c+SBUGRNgbosFUaFSE3lp1e8UxfUZemKOIuQqeZBGVcblS7Q8/5LYHOZ8BqkF3UacYooo1uzvzFrevcShYf8Cob1Poz0UiiCy6FO8jhjtpO71EHo9HFGMiBPP4bJ9LfPxTteKyKSgfcpaQsU7cXmyekB8uMxV6paIK92pdQQk8WPbskbtH0aUGMus+tlqQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 29 Mar 2026 08:34:06 -0700 SeongJae Park <sj@kernel.org> wrote:

> Forwarding Sashiko review for doing discussions via mails.
> 
> # review url: https://sashiko.dev/#/patchset/20260329043902.46163-2-sj@kernel.org
> # start of sashiko.dev inline review
> commit 8c40c45c57722526c25cf1114b386d19a693fc2d
> Author: SeongJae Park <sj@kernel.org>
> 
> mm/damon/core: validate damos_quota_goal->nid for node_mem_{used,free}_bp
> 
> This commit adds validation for the node ID in damos_quota_goal to prevent
> out of bounds memory access when calling si_meminfo_node(). If an invalid
> node ID is given, it defaults to returning 0% for used memory and 100% for
> free memory.
> 
> > diff --git a/mm/damon/core.c b/mm/damon/core.c
> > --- a/mm/damon/core.c
> > +++ b/mm/damon/core.c
> 
> [ ... ]
> 
> >  static __kernel_ulong_t damos_get_node_mem_bp(
> >  		struct damos_quota_goal *goal)
> >  {
> >  	struct sysinfo i;
> >  	__kernel_ulong_t numerator;
> >  
> > +	if (invalid_mem_node(goal->nid)) {
> > +		if (goal->metric == DAMOS_QUOTA_NODE_MEM_USED_BP)
> > +			return 0;
> > +		else	/* DAMOS_QUOTA_NODE_MEM_FREE_BP */
> > +			return 10000;
> > +	}
> > +
> >  	si_meminfo_node(&i, goal->nid);
> >  	if (goal->metric == DAMOS_QUOTA_NODE_MEM_USED_BP)
> >  		numerator = i.totalram - i.freeram;
> >  	else	/* DAMOS_QUOTA_NODE_MEM_FREE_BP */
> >  		numerator = i.freeram;
> >  	return mult_frac(numerator, 10000, i.totalram);
> 
> Does this code still risk a divide-by-zero kernel panic if a memory node
> has zero managed pages?
> 
> Even with the new invalid_mem_node() check ensuring node_state(nid, N_MEMORY)
> is true, a memory node can have present physical pages but zero managed pages
> if all its memory is reserved early in boot (for example, via memblock_reserve
> for crash kernels or firmware).
> 
> In this scenario, si_meminfo_node() sets i.totalram to 0. Since the
> mult_frac() macro directly evaluates division and modulo, passing
> i.totalram as 0 will cause a hardware divide-by-zero exception.
> 
> Should there be an explicit check for i.totalram == 0 before calling
> mult_frac() here and in other similar quota functions like
> damos_get_node_memcg_used_bp()?

As I mentioned to same previous comment, that's another bug that require
another patch.  I will work on it with a separate patch.


Thanks,
SJ

[...]

