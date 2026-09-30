Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19DF0CA5FB1
	for <linux-mm@archiver.kernel.org>; Wed, 30 Sep 2026 12:35:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 25B9D6B0088; Wed, 30 Sep 2026 08:35:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 232B46B008A; Wed, 30 Sep 2026 08:35:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 121E86B0093; Wed, 30 Sep 2026 08:35:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DD92F6B0088
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 08:35:07 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6FC0E407A5
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 12:35:07 +0000 (UTC)
X-FDA: 85270373454.06.247B175
Received: from fhigh-b8-smtp.messagingengine.com (fhigh-b8-smtp.messagingengine.com [202.12.124.159])
	by imf03.hostedemail.com (Postfix) with ESMTP id 61ECF20009
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 12:35:05 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="H vinTYn";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=hNxrDK1f;
	spf=pass (imf03.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.159 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790771705;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8GSERcGj3ZPDBj8Cio+ClQgF2tiUgKwW6CxMvKtRxZw=;
	b=KSPyn8wFBxNDy6X/ub4jLnc6pG9MVKHGLKDbcZWhZ1letRAL34eK1HuFGZLPfJH+PYZf3J
	JMu4cAfB7aDFXkDqhKiLqmIYTHYM04JuGl7OKIOaIGG1rCjs2pXl6lE2Y2DymWtwXuHguj
	bW+BLeYdikN9Nc7vz2YVRWpBB8A+OJY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790771705;
	b=a9h7XVn07NGFK/ONb77TuW6np1zCNrZiSIW8MjtIFt8TGWj+FKTMINxuaIacZl+5NUStoi
	BaNW+q25nkeGpPL1DPdh8Uvkv36N8wvZX1C4bRSb/HneljkLfydJoaqhMjYpgRr2wKg4Y7
	vrCyMl2HV5bIPDsJb2G7lx3vIhV8Whk=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="H vinTYn";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=hNxrDK1f;
	spf=pass (imf03.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.159 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfhigh.stl.internal (Postfix) with ESMTP id E84EA7A00B9;
	Wed, 30 Sep 2026 08:35:03 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Wed, 30 Sep 2026 08:35:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1790771703; x=
	1790858103; bh=8GSERcGj3ZPDBj8Cio+ClQgF2tiUgKwW6CxMvKtRxZw=; b=H
	vinTYn7N9NFC/lrxWjb2Yx3b+fLwlqpb9vR0vbV9QV6p0HRTxXXlK7KnDuUtN8Vx
	+bARqB743AoghNsKn2QAdZ5pyQBgsR6xUB2181hpMIWDCzfqX36VuKmE1/S7B028
	1bs8Vewb8Deb9LTAnu/GI7vZLdmb/TF0mnUO0+F4qa2d+y1gjoo10lFIzS/MQ/XV
	uOuYl6dVKQRrrE8BLNLiKuwRM67DSh03mhRGUOT6Xq1Ydid0tYCzdcxZ/ywK53iu
	aZNPXR+hprv+y/aDcgEIEYn1HJM6ELE/eaHsO95EKtSAt9nL58usK+crcs6lp79v
	Jy3kuxQbuXdT78Jerpkyw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1790771703; x=1790858103; bh=8GSERcGj3ZPDBj8Cio+ClQgF2tiUgKwW6Cx
	MvKtRxZw=; b=hNxrDK1f7ToxT0DuHw7zY3vMvHJ3nfL9dWKOoOFMvmkdmHy4O5a
	WKTrtKknBxdecWpu6CH9/78K8EZXSYBDTYtputhW0qe8UAxRux4+Yevwwjeidk8k
	ii1E9//dJfxDx30C/F5XduZWqy3D/WRBH7kcm3e0EmQr3DL/1WjsD3wNHwMYndTB
	d92EcrJPH1ZDKDQRcQ8jxAYJ7wiqX1ihuXrMUZRenTTNgQDHslweHWY9tfw5gPd2
	AwdlDWQ9lKV5xKD3TxAwIJL5ODEqbpKb8ajXoFeQ2/4VXt/9r7mE2cukWRxrhtUN
	5M2jiHGNrYj3QgF8s+RAa2ZM8irdyCIH/OQ==
X-ME-Sender: <xms:9wG9at4LqA3lQDg2fDTn7aj6EaEIrXfaZRB6DtLBYXnYqbZO-Nk2Gg>
    <xme:9wG9aip1ZO92wCYvVisdTU29yq_u62DRvdTwUnyTMtgO5YERaCTffkSV1jMctgYJ5
    xDn-Mmd56VGzrJ3qt22Zjnm9dvJyCwCRiF8cLY6spxUBn5VBbkGO34j>
X-ME-Received: <xmr:9wG9ajDFM4FzyDyXnpTlqlTnFsomSSYrzErX6zatuT4xORgpVSnudlqQ0Cs>
X-ME-Proxy-Cause: dmFkZTEL7TThQOaOF3FaiEQpbUh3RUYIvhHrP+VB69hyCNpeezulGTZnijh2t4LZPkoAqf
    jbRnDI/qi8ECq88mhKG9goja4578cDRZGaSOICis/fcT3/13u2RkSlNuh96r2W9FjK19h9
    rE5o/rnSTBI54ntwSdzJW8pFZAPjh9AbnHj3P4k+xzC7OQGSG6yOnSNtiJnTW7dQA7NiIB
    0Njg+rT/VKG4TRLEQAwCHSg5OqX/nKILpos0uxNOJELgix54o7wgobBEMnaQZQ3wbv9rvf
    SoRgDfU5qhZAA7Hp2Irv2PUVwiC0bPlhYbb34EgkfBph1/BAKQ4YZa+LR6myVjs8aC+8Ka
    wOSQHh5wmcp4W+2MpAqVTipg1pVZ39W9I1Yf29TLXB71YP+RRLIO+YygZuOyHQ2VBHDxb/
    orS4wFT7oqq7YXOmz++b7SPtAnX18HSDnHn239hrWLlrs9sh/ToxesY4xmH9ePB0NzR7IS
    SHmsrXuM2ES26b8/xzVUUTlicNOLop451lEGXhGUOYCcUOH4OGDXUpH1cdcjXL2jddGUqo
    kXmT5S16GY3om4/xRluvAec2NmT0YQWv4kNPg4xVKTREpH4+KyCc5bQ9c36KEV2MTOefoR
    Nb/ARKceiXIbMWlrt3CIac9++BGXLXb7zmRbs7ZxdlZKMf7NNfI9VxcQ8N4Q
X-ME-Proxy: <xmx:9wG9agcXB-j54LdqND22bVnimufnHTI2jOLHqLu4ErR1OUxvlCqofQ>
    <xmx:9wG9alDD6QHfCK5PqZAXa9JZSl5WEUMhtKgWAVIDFtwzgiO3Tmy6Uw>
    <xmx:9wG9akQSNYXZKbSJEokvjWXQ_bR7PRxmS3Mdg716fPSyWBf7_kDgeA>
    <xmx:9wG9apcOd2K6A9G_Byv_ELaK-gweT6DXkPu0oiCqJxS6I58FBg2FDg>
    <xmx:9wG9arVjfyhFMda6Ammn2TvTyqFG_OPB8v9WN9vohHpgARX-Xv9bBDn0>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 30 Sep 2026 08:35:03 -0400 (EDT)
Date: Wed, 30 Sep 2026 13:35:01 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Vlastimil Babka <vbabka@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Harry Yoo <harry@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH] mm: page_alloc: make defrag_mode retries follow the
 promoted order
Message-ID: <ar0AiPWwfcZtksPu@thinkstation>
References: <20260929174553.175333-1-kirill@shutemov.name>
 <20260929125816.5a846a62943eeaf63725b525@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260929125816.5a846a62943eeaf63725b525@linux-foundation.org>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 61ECF20009
X-Stat-Signature: 7fcbhup8ygepe1erj7ri4htgkr91w41p
X-HE-Tag: 1790771705-450609
X-HE-Meta: U2FsdGVkX1/t32JITQEuhc67q7mNKmrOFDB/ovYOa4twsAzGazLaO0VC5PNAB9qf7qXBQosirC2QGzeSulVruZEZVGlF4Wg2zw6E2BPi80C7i/y9pBrgP8Y+9TIbIqltqUtch5r4StfBGqqX2HefYLdPFmt+V/soGymM9giLdDryTuL8gmxVkWGFFb6cqNMaKdVJ9SbgpMf3OrzSEgw7amrFwwAKNahF9N4Q82SIyR44JuOyeVtq/siYTCcsRKHJs0RgOHQRegoEJeLmog293sW9y1QQyANpGovimz1p76xLAhM49+jtNT1aw9DyRE49BWggnxMDS/ypWaN5+HxmtQM9wy0sE94TjMrU4yA+aibITAb7Kt8pL3A3W6LkTqluuksN1jTnINMQe7iuk4D6y4jOqIunfYzKrl60+srlX8RAcNVoohXDSaDwTGM7soKV5KKPoSti1Sgc6LCZwRJ97tEdr3FhmEPadFkjg9Aw5o1hPrQeqlifHb+2mGQJTBL9ipBmsRCbOdUxWzc6VUoWdiM7arRLu4E8lQyUxebpiAaVE/eErgl/jC7hupYHLAmPiMowLBofepc35TfC5K3e1KZs81Ky4rSn4YHKZDFoZWaYssLovd4iXLTrM1uaeVbn6dHu5QC8xxyO3IgHG/yw8tBa3vrxCrDUPNI4ezErLsfYSnDc2y1RIrEdcJ7gO9s0mv3q2vROS9m9tm/oHmCErbfAXeHM/tkghLwfQNnzgpS4tGt59rfucBMdeIIHWKqQp577mNJW9bv2B+ldpqvsib6FM8FwMtJxfbgT0natRHtUGdDuOtVG11KehFQtOeCj7h7fLn2uXTVfFvBWkRI9q7D26ggCQfLMDh7PpMbCLj20HZQcMY+XbtXNfhzx67xz1PCkqmu4JgZDlsR3Z1QK9k3LZoRdY+a9PwFxF+SjtT/W+Z+OU8UNkadpvIHbB2SSurE7FDJYaZGWfcw17M3
 jdE5Ipmc
 TIeBslis6QN+OL1xJ0eOrzZgIEuHcMzYTXGrogeEcMX1ddUJCeMdJswofhweYVOAYDjGte2Qsi5RTpU9AX9LVm1/39Olo8UVJ1zNJl+eAoggwqaq65hgNlfmJoXDrg6bAHlx4Tm3TWakZZlddUu9jWFAFYNvNDniyHZWxpK5LZZC3+Kj4uvco/B1CMvUT6ZjbUiLW2d/efFZVDk0zZP+1mb0GQJzzcamWMI8txgiq3IaDifCymslieSgO9XDhih1uHy90IWIMt+N/VvyTfP3ymyG4ObMFlSwQlS94erSZLDx6QKr9st9lE9vesRP/5+5I1dxnvszbkQZ7W0NBIoOD5Et4Xo8KvkIcY+s586c/fBUxK1hykBOtTaVtjLDb30LhNpOvskSi6x44iupUJwHKvK7ouXLULBxeShgUmZBuVz/Kb4O6t8G5kuA4dwA8d4QpSoYGcp+ihvvMqYAIOPPoJURcdAwpVpfnnvMUj1cYN3qFWBc0cVaiN/dKQfOGVMXnrAbX9a0vexwkBGA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 29, 2026 at 12:58:16PM -0700, Andrew Morton wrote:
> On Tue, 29 Sep 2026 18:45:51 +0100 Kiryl Shutsemau <kirill@shutemov.name> wrote:
> 
> > From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
> > 
> > Since commit 7e8756d7ad22 ("mm: page_alloc: fix non-movable reclaim
> > storm in defrag_mode"), direct reclaim and compaction for non-movable
> > requests under defrag_mode run at pageblock_order, to produce the whole
> > blocks that ALLOC_NOFRAGMENT needs. The retry decisions that follow
> > still use the request order. An order-0 request can therefore retry
> > indefinitely without ever reaching the ALLOC_NOFRAGMENT fallback:
> 
> 7e8756d7ad22 is new in 7.3-rcX, so no cc:stable needed.

The commit itself has cc:stable. And it is in 6.18.50 and 7.2.4.
The fix needs to follow it there.

> > - Reclaim at pageblock_order gives up after one pass as soon as a zone
> >   looks compaction_ready(), and do_try_to_free_pages() then returns 1
> >   even though nothing was reclaimed. It returns before the retry that
> >   would reclaim memory.low-protected cgroups, so when most memory is
> >   protected, the pass that did run finds next to nothing.
> > 
> > - Compaction at pageblock_order fails or is deferred.
> > 
> > - should_reclaim_retry() takes the reported progress as progress for
> >   the order-0 request and resets no_progress_loops. The request
> >   retries.
> > 
> > Order 1-3 requests loop the same way, and should_compact_retry() also
> > checks their pageblock_order compaction result against the request
> > order.
> > 
> > On a production host (64G, defrag_mode, memory.low covering most of the
> > workload), 95% of direct reclaim runs were order-9 runs that returned 1
> > with nothing reclaimed, at up to 60k runs per second. Across ~200M
> > should_reclaim_retry() calls in a day, no_progress_loops never left 0.
> > The spinning allocations were SLUB slab refills for inode and dentry
> > caches. The time spent registers as memory pressure, and pressure-based
> > OOM killing takes down both workloads and system services.
> 
> A production host running latest -rc?

We are running 7.1 with 7e8756d7ad22 backported. We found defrag mode
crucial if we want to use large folios in page cache.

But nobody besides us seems to test it :/

Can we make it default pretty please? :P

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

