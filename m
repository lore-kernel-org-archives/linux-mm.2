Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C6C4CD5BD0
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 12:21:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D566B6B00A0; Wed, 27 May 2026 08:21:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D2DF66B00A1; Wed, 27 May 2026 08:21:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C91F36B00A2; Wed, 27 May 2026 08:21:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BCB886B00A0
	for <linux-mm@kvack.org>; Wed, 27 May 2026 08:21:53 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5C8F91C0472
	for <linux-mm@kvack.org>; Wed, 27 May 2026 12:21:53 +0000 (UTC)
X-FDA: 84813111306.25.508004E
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf13.hostedemail.com (Postfix) with ESMTP id BC8682000D
	for <linux-mm@kvack.org>; Wed, 27 May 2026 12:21:51 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf13.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779884511;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vZ6RQjz0+0TeRC6Y+jXodjpS4887+zG/Tu1TBRTXu74=;
	b=opZMVeZEJlxaeQG8cUPObO8DCfsQh/g6dqP55ipgXb9B0mLm+KosI75Ik1s/tPO7Wd2YzC
	7ZbDg5X3qXUWC+wuN65qJZvM9cY6NYB3qNN8UJ1Vmktvgz0cCbKf9FfqPtntRNE51g/+s3
	SpyEJbHwxPDyOX2xCNqt2AWI6oFwPTI=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf13.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779884511; a=rsa-sha256;
	cv=none;
	b=OEw36Auc8ig2YOXTa/CadBKbrp7toy3ngdL/TOVeCgxsIGHr8x5bEGGURrGEulSeeFHUdb
	D0r3F25s+qZio/iOOBjxW6RgPnPzTf458Mu4sWKdmTG7oba4Q/NbSvabnE4KeyGzXvz8ey
	USDoQ9ZqglsbBZLzuOayXkLR/Pxrx28=
Received: by verein.lst.de (Postfix, from userid 2407)
	id EDFD668BEB; Wed, 27 May 2026 14:21:48 +0200 (CEST)
Date: Wed, 27 May 2026 14:21:48 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Harry Yoo <harry@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	linux-arm-msm@vger.kernel.org, dri-devel@lists.freedesktop.org,
	freedreno@lists.freedesktop.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, io-uring@vger.kernel.org,
	kasan-dev@googlegroups.com, bpf@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: improve the kmem_cache_alloc_bulk API
Message-ID: <20260527122148.GA6838@lst.de>
References: <20260527070239.2252948-1-hch@lst.de> <ee817070-cc7a-40d5-92a4-2bd8e9e65fbe@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ee817070-cc7a-40d5-92a4-2bd8e9e65fbe@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Stat-Signature: ryz8s4pf48kzjtz8cughafc4ddwdyfsw
X-Rspamd-Queue-Id: BC8682000D
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1779884511-152727
X-HE-Meta: U2FsdGVkX1/4MAfDSRbULR9mK08YfLWCfMzQyUtK7No5o2iJ/LyALXzbhQ3jiZBMh33v5VUzHLH0f+Jtq5NasgqB9g/hctcb/vSpPfvueH4rql+IGl+zHlkZx+mNjmwR2Nsv//TpA1tNzpa27sEdFoW4hbMeDUhEhFlq5Gk3A6l+I7/ClTUbPblA+H8yzda8tmzqkvH+0f4FakowpTkV/grb1xNWJGshhZjBRB20APbwisIRWDktiEU8/RBPhlZuHQV7z/xoJoE9NLbb1waf1k6WH4WalhZz7Bny0WM8zK0yCB0ikNg8rm53ypq+1TlBWwZ5ZBhKBurPfwi6bw1FxWe/W8BgBjBupdDJep7somY9rx40VHFAr5HNFpQDBuyD6fZZ4i025pDACHGwQIu1gJ8cxWh7zLIApBT7G8cBRP/OnNvH05+d7hGiFZZ0GQ/g/YPadZU2m8VQehbQ6lz1yKWC80l590qt9wXQMUJ+GbwmMdVXSRxrhYIcduGoN8jWP2LXCXuOdjt/DAECBbMgJa2lyV5Fsxy3mqRIeeT0ntN0eJ9bddQjIVclL9+seb4353ObXKH7HeAhWxY8qep2EMCKLew/Efdb5S0hEnzOGH306bZX5wbhxm58gyoJG4MriBmTmUOFV15DovFTgIyJE7WVMcPh4XksHvYyXJVy9l5JawhEiQjJvyOAtuOzQ2bZtFr0f41RwEPITO+qvh8L+ghduA/mtdnjDaRBnVkp6PWZIAVdboaZ+490sUR3/eF+n10M/kvyWJ9d6zrezC2BKAzraWCQexu2SpqrBLHYod9ddRS6M3CRwYGQveABQVYuU24GnIsBT9v3b83Mv/dTTdcpgbp7h9QH6cni1v8OFy9oWpOB8EZdnj/OUT7Qk5hmA3RJRZYhnBiySLKMzIGyxFsIBMqFDipNno77CB9O+a+O/hZzH3zkTwcuIv2H1g6MRKL8Lcl9EP/Fd/hQ2HD
 vl+zkK3o
 EUIAUOwA2nEVRxffbpZzvGzZYS7j9KE/OBkzmW6YsVttMuROixCLsabWvlzDZQfMRHE9I5UlI2zxvWsNh8C6uUEUqo4F9VQK42K/+S6ynBA5IlHWGJ9LrZZs0y4PKotGwCwksw9/erxd1+Ts=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 27, 2026 at 11:11:31AM +0200, Vlastimil Babka (SUSE) wrote:
> > value convention.  Fix that and add documentation.
> > 
> > Note that the few comments explaining it mention that the gfp flags
> > must allow "spinning".  That's not really a term used in the memory
> > allocator, is this supposed to mean "block" or "sleep"?
> 
> Page allocator now has alloc_pages_nolock() for when no spinning is
> possible, and it uses ALLOC_TRYLOCK internally.
> 
> Slab has kmalloc_nolock() relying on that when it needs new pages.

The comment long predates that, and it isn't expressed using gfp flags,
but by requiring separate functions so I somehow doubt that was meant.
But I could also not see why it would not support GFP_ATOMIC /
GFP_NOWAIT allocation, so I might just be confused.

