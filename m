Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A51F5C79F80
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 06:36:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A90886B008A; Fri,  4 Sep 2026 02:36:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A40616B0095; Fri,  4 Sep 2026 02:36:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 908896B0096; Fri,  4 Sep 2026 02:36:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 72EEB6B008A
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 02:36:09 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 062BE1C236A
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 06:36:09 +0000 (UTC)
X-FDA: 85175120058.27.488AFEE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 45C7EA0007
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 06:36:07 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ccJvPGio;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788503767;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=757sSow4bZxacgFES5O5/6SYu86a200KKf1Pkw+peq0=;
	b=SRsbARPfbkFth7xu/UvpqcRYTBXUJ79xTGrIEp0PR0iOyvjdy5smpprQspuqPaoKCNK9vB
	JH3ZuVYio9ZGBWoI+XDR2HpR+B7uh+0DTve19GBgK0Ydpo72jUUpYuKPgFbZtKL97MYgvd
	ECfTJ8A28PgIs2PojSjgRMby1B2FS60=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788503767;
	b=qdATEpRD0SBWCBVT/iONUtV6o8JPYfJu0ygiAoLng+1xUQFPquQTy1+hZS2FotEolEY1Bn
	A4Z9fse3Im/u4xlEBANzZBYPDIAwhuUsoubZ6H2EpbuebH+iWgecr/blkdo8BLhebFcEOa
	69ju/CoZdJpIVGxy0iSqNn3Pn0fR4s8=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ccJvPGio;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7B97443622;
	Fri,  4 Sep 2026 06:36:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33DC91F00A3D;
	Fri,  4 Sep 2026 06:36:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788503765;
	bh=757sSow4bZxacgFES5O5/6SYu86a200KKf1Pkw+peq0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ccJvPGio6PTHW6jwkb7/NDj3fTlu3lr9EJCBIJjpKQYklYtlAbrbH/O9gf79D5Uxr
	 xBFRC2IXGv7MZMdykmWd0QUR8VoUYTdYz5LnSmhs8AfdZ2L/peo0LQasEbgmjJsL9g
	 vkEZOCMnBWyGxHKB5xmpfTDyCJeop+Nq4JuRMx44E+eZ1dgr3A3HByTGOWHUocewmy
	 REvebJ08P9SuUym90fBg4dfvn+IxEFocNw0ee5YHM3gap2AhvoE4KJDNQfGJFXekPP
	 jb8zsn7dBzviwnUfFpEZpBLIf4JfhvF6j/hXlP576HaZ+PynB/iRuCLjrkpjQLXy3B
	 iiU7L7tE2xa8Q==
Date: Thu, 3 Sep 2026 20:36:04 -1000
From: Tejun Heo <tj@kernel.org>
To: Julian Sun <sunjunchao@bytedance.com>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, hannes@cmpxchg.org,
	mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, akpm@linux-foundation.org, axboe@kernel.dk,
	jack@suse.cz
Subject: Re: [External] Re: [PATCH v2] writeback, memcg: skip foreign dirty
 tracking for bdev inodes
Message-ID: <appm1E4rzQQB_srX@slm.duckdns.org>
References: <20260903083303.2769873-1-sunjunchao@bytedance.com>
 <apnYouiUINQR-98e@slm.duckdns.org>
 <3a7ca3ba-d2e6-40a1-95b2-4d0ee93d4242@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3a7ca3ba-d2e6-40a1-95b2-4d0ee93d4242@bytedance.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 45C7EA0007
X-Stat-Signature: h6mkjunxq9xy8sgzu8bqx9uto99nrwg5
X-Rspam-User: 
X-HE-Tag: 1788503767-730404
X-HE-Meta: U2FsdGVkX1+Tj0LZPDU2zMQsb5mPhGy673I6d2DHcMhRRO/4SvU4XJIsiCk0T/yAIvjUZDZrEEY6gJfw80Ihc0AuFu1T21NCAbf6HxfEPjdKF88c2zvmxdvWACV+zq6L5HwfcvApC1sQLFQiGJ+edfECieMpBOChtBN+OvsaiFFbIxGdPSh+XnE5DaecI1P8cPq2HACD7D4ehc8MoYjITLbBz1d3qNjffVKjqa/2/fxYAddjQE+Kw4I2G4kwDu9DwYDQR41R4HWtLyJkqHQ6FNaKoQhpTNnSHcFHtpsTOeoVvUbSgpW8wXvEN1U6H2qOaVL2YNuhU1fWT0Wx6Z75wUWsZb3deRz4rhcPHntkC0Q8/ISmjFOOZW/j1mvkAMTxlHb0ma3oay4ZmkfhCQ2jN4AT/0M+8HhFUJ1Qr5R3UYG7NQ5a4chi/kw1FDtHLmcqrsBDzuSqFKoNC6SUpoEv+Cnu5WUD8AjUGlcdd3LWO8v+7ZARvK+0nncLunyRoZ30ZKnwjUJwDTI+n7xKd2ehyVWy2ZPORcOZhv3LVvHeSVJPpByhKLhtaTvpt5XtqR/1keOW45u11wkr/FykiUfHqqNmGy2CBHqnExNhKu4r0EsWMrbfkb/A/Cpbn/Kl3IoraM0Q//EMo12gB5qz+x9hVOFPo1yqLTkMGaF58SFw/bq163fliCZ8djhRU5IkiCXdy4A7+BKl1Z+EylgoC+fyppHvj76K4cKT23H+WFyq5m2okYpUmBVnbjdaHiuQ3BMf6bqHB3RVBe8dbn8ht1E0Pwng8fhMX63AQ+tTeNo10VmPMquFxrE2i8qJlHYk0gv0eCRoP+1fv5dIuoVchZvXmuV+l7JHOav/6/yNZisUJjFOq8jTIQcU69qbV77YvxjmIxitCLfmWHURTnZ5J8GQ4m0YAt2taSksAyBUG68hDrnaCLYMcrzvpR2mo2UcASPeQSPXyBIHCqG/PYppxhC
 iPiJfy3R
 gIZc0IyJ7jvIoENWoJt+AjLuHYNOvv+C3Pmk2qmFS2aEizp3+UhDVeqiNNKm7V75jRARqHMqyykMVAyUOF6OTjWl5Au0QAaU9FbR/xtoZKZRPdo2Qs7/Ke+7QGqGYSiFumlb1c4LGeZ6ByfU1hbvslC3B74l/QWzPbO0GdgsgMVC8BFkUvZJ304ajTvPfKstVC+yXQsPd6wwdWBjjQmPEZOZGqw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

On Fri, Sep 04, 2026 at 12:34:27PM +0800, Julian Sun wrote:
...
> > Was this reproduced from an actual workload with adverse effects? If so, can
> > you please explain the workload and effects with concrete details?
> 
> Yes, this can be reproduced on many production machines. On one production
> machine, we observed 102 wb works with WB_REASON_FOREIGN_FLUSH as their
> reason, 101 of which belonged to the same wb. This wb was the owner of the
> bdev inode, and dirty pages were continuously being generated for it.

This is the mechanism triggering.

> The logic here is that, Once a memcg has recorded the owner wb of a bdev
> inode as foreign, any task in that memcg that reaches the throttling path in
> balance_dirty_pages() may queue one WB_REASON_FOREIGN_FLUSH work item for
> each recently recorded foreign wb, up to four in total, without checking
> whether those target wbs caused the current dirty throttling.
> 
> On this machine, the total nr_pages of the foreign-flush works was
> 630,681,285, or about 2.4 TiB, while the machine had only 400 GiB of memory.
> Although nr_pages does not represent the number of dirty pages that will
> ultimately be written back, the actual number of pages written back may
> still be very large because the corresponding wb was continuously
> accumulating dirty pages.

Is this necessarily an adverse effect tho? These are all metadata flushes,
right? When they're gonna get written might change but do the extra flushes
change how much is going to be written? If so, how? If not, are the extra
flushes adding noticeable overhead in terms of cpu or io?

> > > Skip foreign dirty tracking when the folio mapping's host inode is on the
> > > blockdev pseudo superblock. This prevents bdev-originated records from
> > > triggering later foreign flushes.
> > 
> > If you do this, tho, that means now cgroups that accumulated a lot of
> > metadata writes on ext4 and crunched for memory don't have a way to relieve
> > the pressure outside of periodic or other lucky flushes. ie. I have a hard
> > time judging whether this is net plus or not without learning more about how
> > this patch came to be.
> 
> How about this approach? Before queuing a WB_REASON_FOREIGN_FLUSH work item,
> check the target wb and avoid queuing another one if it already has an
> unfinished WB_REASON_FOREIGN_FLUSH work item.
> 
> This approach can eliminate a large number of duplicate foreign flushes, but
> one issue remains: a memcg may dirty only a small number of pages in a bdev
> inode, and when that memcg enters dirty throttling, the throttling may be
> completely unrelated to the wb that owns the bdev inode, yet a foreign flush
> is still queued to that wb. This problem becomes more pronounced when the wb
> has a large number of dirty pages. Perhaps we should track the number of
> foreign pages in the memcg and avoid issuing a foreign flush when the number
> is below a certain percentage?

Yeah, maybe, but I'm kinda having a hard time evaluating anything as the
mental picture I have of the problem is too incomplete. Please fill us in.

Thanks.

-- 
tejun

