Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B869C5CFE7
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 17:54:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 298956B00B9; Tue, 11 Aug 2026 13:54:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 270906B00BB; Tue, 11 Aug 2026 13:54:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 138246B00BC; Tue, 11 Aug 2026 13:54:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E945A6B00B9
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 13:54:54 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 70A874019B
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 17:54:54 +0000 (UTC)
X-FDA: 85089739308.30.7121011
Received: from out-178.mta1.migadu.com (mta1.migadu.com [37.59.57.117])
	by imf10.hostedemail.com (Postfix) with ESMTP id 6C6F8C000E
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 17:54:52 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=IAHxzHg3;
	spf=pass (imf10.hostedemail.com: domain of shakeel.butt@linux.dev designates 37.59.57.117 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786470892;
	b=AbIfWK253tP1XL8GpNzErdIDxyVCs0qB4h0EKXhw/rSuXGvHBoZ8z4K5GzsHFTLYx9TvQq
	cWn7kfuQSlLxrSL49MXFNB1kfTnD5ssh2pYTa9Tz46m2TIyz/uT0/pz6NFOLYNNd5bu08N
	5w1bDLWIOb6EcgXqtdnaRNqtzGinZTU=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=IAHxzHg3;
	spf=pass (imf10.hostedemail.com: domain of shakeel.butt@linux.dev designates 37.59.57.117 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786470892;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OlQGZdIlw8dZKOYB+3h54gW4Pow/7J1yzxtJDd3AvJo=;
	b=BXXUA4PIW7//TXLkkgGA0IR67dYkZnrqqAzoLG9Tn4jAaBSPt7PsjEK4TQRSlOy/1mloKw
	Ktrs64OD2Pu4Kt682UrdCEmm+hHsB6mJJtqWK5m52m3ZUtk54UtYsuPg0GOGW75E/Q5cDX
	yYBXRlKW+ihV/64A2+uozZvFJE0oh0E=
Date: Tue, 11 Aug 2026 10:54:23 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786470889;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OlQGZdIlw8dZKOYB+3h54gW4Pow/7J1yzxtJDd3AvJo=;
	b=IAHxzHg3SZAFfF7I0+DqOl4o5Jn88kzxU2J5dQxlDMgdAmfj+lR5fYQUx7uBaMsccKWTwO
	/MPhdZVkA5+ETCRy/MDoScErxkyKrbSJ/UrKxkLFs9QfP5kuDJosDgY40nnMT9HB4DzGLg
	sO3XvGk9zhDUuU8hKdb0c03qVuJbk9Q=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: "Paul E. McKenney" <paulmck@kernel.org>
Cc: Breno Leitao <leitao@debian.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, 
	Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com, 
	stable@vger.kernel.org
Subject: Re: [PATCH] mm/vmscan: report RCU-tasks quiescent states in
 shrink_lruvec()
Message-ID: <anthYiiYPuUYbj1Q@linux.dev>
References: <20260810-rcu_task_shrink_lruvec-v1-1-4d9f7d5251cb@debian.org>
 <anqnkZceNHyvbR5S@linux.dev>
 <e019296d-43f5-47bd-ab49-6dfd1d8da0cb@paulmck-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e019296d-43f5-47bd-ab49-6dfd1d8da0cb@paulmck-laptop>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 6C6F8C000E
X-Rspam-User: 
X-Stat-Signature: oz4mcw9shyx81zsrkea6zsmzaxyfhbg7
X-Rspamd-Server: rspam06
X-HE-Tag: 1786470892-175943
X-HE-Meta: U2FsdGVkX1/8md5fAnBFx7w/LYB+OwAsUbWx3Be20M1xKcZAS4yuycUD0fL8xg7J1KTXdo2w6AQH3yRB+ULbf0EeR84mbBfwqfxTLF8JFgVCeG1Y65YObY7T7085eqpIf1UQRplKtaP6MneiWeQcSQT0n4obYcKZ9NR0OCea+dQ98iz23WRFTs1/nVE0L6VFnwrz5Pgfty4irwRD5gg/C7rfyS6GsXaetlq3Z8/054WKlg4FMFbeElvFouN5vodZKF6/nErys8594+Askzpuf4tZW4SkTGgyrz8KV+gjgK2Q49DczlIPurrOUTqzmz9j/RchCQEWXO3RlAaC5K5OTXZrop4Eq3Wut9K/Uwk6+6DX/DqGt3mY3PXmxhP4joOcofVrLONtLrom1WFBgBpu8AtuGDADY2DZ/FeuzAPQRx/L4nO4YVD5IQX/XeEBK6AxIp4qVphsdET1baocy3YgdsjQHwagcmzDq9wkSoYEOdvgBAMGMKbmfH551Yzci8aFLa+/FXDx20YlK/fHQo48qY/AIHE8ZT/FqcmsE5T2hxDq/a9TC56XbBBnrdVyX+CcPieCNbvvSjOV9Q2iqmHYuPtrZLoBu6S3TvqwZGysb+uazo2adyC/sZyLyrhHz/khJsfur9KbYG5Ewn6d6pzHGjZugjRHgLcJjESs+4uQbUqnlNiVli5nmmkXcdVKsz3R0TsAbStYjugV4cZx5r/EDkMnYbSrgrK0KswMxtvhcz4vWly9v1GdygjLvv4HPh/sOpHd3co7/TaDvdAsx0TTOT//udcaXxVb3vQzDIme88JUKLG5qR9Micp6n7srf7BjgStXL633d3YbqsOKJvnwVVBXpeQv3eFjsz+xduMkLYEj3ePUCcKU/wxdYjnjFmYbzd3B1sHtwqMRmMOx5hTpKuOoSG7jwq+0wmIz2ujog9n04W+3NWPJq6cZzpwnFLFqyq4kyfRUEfixEegpJB0
 3Wm1cy5g
 aGKsCzfNiQXwM8yVvjm/UlUGnDADq46ycjMzDbWEcOD+nRGdXaduy+LtGTqIn7lv0TDFY9VdAbzEnWgL76D2BXJYSFrP0RQJlpYUOZcxHEdE/Y9UERMdBiEmkcehOgpzsVtEILgFwFO6uc9LY2JfiZmsuH6d44N6PLyDoDggtEGhEeau3Uknx1Jzo55xR+dvR93gIgalAqX6IQByPbqYCvuNCnw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 11, 2026 at 10:38:40AM -0700, Paul E. McKenney wrote:
> On Mon, Aug 10, 2026 at 09:43:03PM -0700, Shakeel Butt wrote:
> > On Mon, Aug 10, 2026 at 02:57:36AM -0700, Breno Leitao wrote:
> > > I am seeing some rcu_tasks stalls in the Meta fleet during reclaim.
> > > 
> > >   INFO: rcu_tasks detected stalls on tasks:
> > > 	0000000088620d09: .. nvcsw: 6735/6735 holdout: 1 idle_cpu: -1/8
> > > 	task:GlobalCPUThread state:R  running task  pid:2552016 tgid:2524552
> > >   Call Trace:
> > >    shrink_lruvec
> > >    mem_cgroup_iter
> > >    shrink_node
> > >    do_try_to_free_pages
> > >    try_to_free_pages
> > >    __alloc_frozen_pages_noprof
> > >    alloc_pages_noprof
> > >    pte_alloc_one
> > >    __pte_alloc
> > >    handle_mm_fault
> > > 
> > > Nothing promises direct reclaim returns in bounded time, and the scan
> > > loop in shrink_lruvec() only calls cond_resched(), which is a no-op on
> > > PREEMPTION kernels.  Involuntary preemption is not a Tasks-RCU
> > > quiescent state, so the reclaiming task never reports one and becomes a
> > > holdout.
> > 
> > I still don't understand why cond_resched() is being treated as involuntary
> > preemption but that is orthogonal to this patch.
> 
> The history is that cond_resched() was originally intended to be a
> preemption point in any otherwise non-preemptible kernel.  Therefore,
> because it is a preemption point, it counts as an involuntary context
> switch.

Thanks for the explanation. Is cond_resched_tasks_rcu_qs() voluntary or
involuntary context switch?


