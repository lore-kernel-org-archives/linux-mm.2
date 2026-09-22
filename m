Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DABC8C982FA
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 12:08:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BCFA96B009D; Tue, 22 Sep 2026 08:08:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA7626B00A1; Tue, 22 Sep 2026 08:08:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE49A6B00A2; Tue, 22 Sep 2026 08:08:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 910896B009D
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 08:08:52 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1CDA212044B
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 12:08:52 +0000 (UTC)
X-FDA: 85241276904.18.D1E5D25
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 8D1D640005
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 12:08:50 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aBmK4h4l;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790078930;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lq/wHdaSQa/z2s8nS/PetepYnkUErjugT93n4BkcV9A=;
	b=XkasB8FyRP7A2iXSPX/z5t3DXI1Skuj3gFLZ33bUCFcbz2Hh9Xf6OCF0tQ/VG6WKO9Bxx+
	+OLfA7YgayifeMgxgUG4hX7pTD1zL0sSeW26xf6ipq2eqt9E+AGNVJk1dczJZTfPBIbYcx
	OHoChPRkvu+cAAg5yWlDNKOxU4PTJj8=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aBmK4h4l;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790078930;
	b=Y2DX5b/eId++AvPhOcTgZilEiubw0xfoPtChVRB44174tshmQ/WvVxdlsgsv6l34GrTgOM
	QJItXD6jwOmLNk8ACvOZMLH4o1QsMBS9s4n4K/ZLHQ/R4TduGBoESeomnAFQ2SATnVzCdt
	GP9gAHE+mFkKw0+agOQoVskT4iEZiG8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2105A601F7;
	Tue, 22 Sep 2026 12:08:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BE741F000FF;
	Tue, 22 Sep 2026 12:08:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790078929;
	bh=lq/wHdaSQa/z2s8nS/PetepYnkUErjugT93n4BkcV9A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aBmK4h4lv074Tbs7davGM/gGOn1tHm/rDVnAuFCAPjfC+IsjX1ePCgSAo2QpdvvVV
	 4ISfCrc27gfBne3DCyk/AHODwXJBHIURepOZyTluOEhE2SWagb1WeFEb8lgZgNVjEZ
	 uYpTIEQ/4iiumdSl5gbjRqmbaBmhLkwkebDklTJB/f72STau2droEilZlsp3/JE/4z
	 5GEDGnE0Tm2SVNE8m/ersTxjC7Zxq+jh5YNDwmoEUj9tcdRIsz7+1CZXAvaN4Ju6vv
	 7JbwvmeHLnQvyMXT+QSAKTA35T0aMySRYhOUdOszJ5Xg784AIBEKT8PWtwXL93//ut
	 9+wZRV22Uni8g==
From: SJ Park <sj@kernel.org>
To: SJ Park <sj@kernel.org>
Cc: Karl Mehltretter <kmehltretter@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mm/damon/core: preserve the caller's quota in damon_new_scheme()
Date: Tue, 22 Sep 2026 05:08:44 -0700
Message-ID: <20260922120845.44460-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260921171155.3359-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 8D1D640005
X-Stat-Signature: owpjrgxmh6br1iudhcu4q8wyfat1dqn5
X-HE-Tag: 1790078930-980104
X-HE-Meta: U2FsdGVkX19DjV4IQAJRiya3VsQNisqQp6z9F2IKBZLW1cTL4COOjMFCjQU6my8NDeVVnuhc2LBxqZc0Uj5OSowpc2IC0snkWNtH1cnb4nYYH6Mdq7FBXMqIa1gimMxG9IT/XpFNyXsraNpenATbxEOfdOyxusNKYUG6fseAP5cVS6XqNzxftilcBOdK65ab+ceBSxft22L7rkJ0IUxqxtakcllKHiYwqPhEyQtw+2/FZKpJH8OeiBu9YbekZJAD7yGo2/gyUan3hQrWMZ1xG61UHBhcfYIS1es2LEnF2qphqQV425tPXUj+MnolYoJT3kSdBqTbP3fJx/hUm7OLflt/5ECZEElvFxgJBRg6JJRpLAwWI4pefdMJ51lcg/bDEQCh4/GSItLyeaZE2d3ubaJ20KNpJrnBDpTqHJz7xTlnML7kf8rYNPvuxYED4ZexAnRSqOtmvIoZZnymUs0yQZTbUnuyPtUjyZO+gpXsAk6BIppicSQV2HJOJE0qozpgiZKRnwnbawC4w2tH6dQy1gKPVK1nMPPfw+31epZOnU3p73EUht57EZEvfib+NtZ+rhPKcgOWnIq8K8DCECH0g8jEJXp0nQLru/9U4RQEy3lTsarkTYVDwR2mYFQnvhReEbJm+4TNspOXOjk22VjniIyW3qJfkeBm1NyMwzoBGNXciQU2Qts0/147yPHI6SOgLxycpK07TJ0Rt8mgJx1vQvUE0/B4TmWRThaoEs46S3FNGXl46dIPZc4N3VSlrWpAC/FOoV1i7nXw4tsMWX2bWrku8Ug5g9AjX5Uy0pMtzVQemdblZitjOm2QvpGqFkmpZCZYHwKy9tPKsbmFx5xrkgphefDu14BiUjabOvnZ8A0yGCZL+fbXpNnQ87PvQdM2krROYmZ+xc2vBtIraGIIj0rp3nYubia9KjHTJck/XRcjBwyIKTm1WPf8qMWwOy/SyGNIzFT58RuULBvkFEk
 snx3sczd
 IYkPrGMpXF6j98ReSwZlrhbJQh6FVFsniFrezZgC9N96rEjr6Bi/Mk8syPvtxdX+4Bho+RWk0BhgrBu3Cfl2tGPBdy78E08W8z+BEJ/dhYj5C6q8culDBRko0Elkga7vjd/aS5pZTMIU//TFcSOsqyIk82CWipvUQmfNYQmvzdh5cOwT0GVbv0diEs2xKYE1i+0rVd07blqXcVIF5Io0JklOgTcf6h5j+6amgse32jukTZ9WfGYH+y30sSFREjM8yRdER8sExWsfsn1IEcz0u11LPHzOrDB1RRsE7d6IOJftO0w5wwKwWcwKe6ovEazgYX6b4KMemEXHlN8A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 21 Sep 2026 10:11:54 -0700 SJ Park <sj@kernel.org> wrote:

> On Mon, 21 Sep 2026 02:30:46 +0200 Karl Mehltretter <kmehltretter@gmail.com> wrote:
> 
> > damon_new_scheme() calls damos_quota_init() on the caller's quota before
> > copying it to the new scheme. This clears the caller's effective quota,
> > feedback input and charging state as a side effect.
> 
> Apparently the above paragraph assumes it is called under damon_commit_ctx().
> Lack of the context makes this quite confusing.  Could you please rewrite?

To calrify my opinion more, "caller's quota" feels unclear to me.  I hope it to
be more clear that it means "the quota that is passed as a parameter to the
function".

> 
> > 
> > damon_commit_ctx() first copies the running context into a temporary
> > context for validating the proposed parameters.

I'd prefer using the term, 'commit' instead of 'copies' for clarity.

> > When
> > damon_commit_schemes() creates the temporary schemes, it passes the quota
> > of each running scheme to damon_new_scheme(). The quota pointer therefore
> > refers to the running scheme, and damos_quota_init() clears that scheme's
> > state before it is copied to the temporary scheme. Even an update
> > rejected with -EINVAL loses the running quota state.
> > 
> > For a size quota, this discards the bytes already charged and allows the
> > scheme to use a fresh quota before the reset interval has elapsed. For a
> > goal-driven quota, the consist tuner loses its accumulated input and
> > restarts from its minimum input. A time quota loses its throughput
> > estimate and falls back to the initial estimate.
> > 
> > The constructor side effect was introduced by commit 70e0c1d1bf94
> > ("mm/damon/core: factor out 'damos_quota' private fileds initialization").
> > Commit 60bd24f272d0 ("mm/damon/sysfs: test commit input against realistic
> > destination"), merged in v6.19, exposed it when
> > validating sysfs updates against a copy of the running context. Commit
> > b90408ef1163 ("mm/damon/core: safely validate src on damon_commit_ctx()")
> > later moved that validation into the core API.

I overlooked this part in the previous reply, sorry.  And thank you for adding
this detailed context.

> > 
> > Sashiko reported the same side effect [1] on the RFC of the core API
> > change.

Nice catch, I misunderstood Sashiko's point.  Thank you for catching this,
Karl.

> > 
> > Copy the quota to the new scheme first, then initialize that copy. Make
> > damos_quota_init() return void, since its return value is no longer needed.
> > 
> > Fixes: 70e0c1d1bf94 ("mm/damon/core: factor out 'damos_quota' private fileds initialization")
> > Cc: <stable@vger.kernel.org> # 6.19.x
> 
> The Fixes commit was introduced in 6.1.  So the comment on Cc: stable@ line
> should be fixed.  Also, at the time of the commit, validation purpose running
> ctx committing didn't exist.  So, the issue you are explaining cannot happen on
> the commit.  Or, am I missing something?  If I'm not incorrect, could you
> please find the proper Fixes: commit and fix it?
> 
> Also, are you using LLM for Fixes...?  If so, the LLM seems not good at that.
> Your previous patch also made a similar mistake.  Please manually work on
> Fixes: tag or double check LLM's output.

Now I understand you added the comment for commit 60bd24f272d0.  I think Fixes:
should also be 60bd24f272d0.


Thanks,
SJ

[...]

