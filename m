Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EFE54F531F8
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 07:52:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 58C3A6B0088; Tue, 14 Apr 2026 03:52:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 53CB96B008A; Tue, 14 Apr 2026 03:52:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 42BFB6B0092; Tue, 14 Apr 2026 03:52:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2CBDA6B0088
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 03:52:32 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CBFB5160485
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 07:52:31 +0000 (UTC)
X-FDA: 84656394102.07.2046EDA
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf30.hostedemail.com (Postfix) with ESMTP id 29D8A80008
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 07:52:29 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=XsS8wses;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf30.hostedemail.com: domain of BATV+c83a8b98330cc0662794+8269+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+c83a8b98330cc0662794+8269+infradead.org+hch@bombadil.srs.infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776153150;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NTxaoTWsYIT6XinpmC611FM9scC20rVnNKMI/IZpFxY=;
	b=EpfSvK9ekfykTySdWRdhPJILJIwVpIcT9BqZ3nSSmwhz74mJSW544eETWp/a8HaP1XtD5d
	amabdwcD5L0yhFLj5e/R3NLEXGzAp6wcEFt+QprqjkrRDUb+lUQ8+gRiHsOyloeJ5k4IAf
	5kbUknHkBkVrDNHQu60VQaLTpHfsT7s=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776153150; a=rsa-sha256;
	cv=none;
	b=jCNPsaPzT/usmoEu+mNNA13YTvnZB+jcCw/phGpciUasocsvrE3ectWW8Hn+HaDAyHiHDE
	AZ0H8nzCJskkSQJjlKh4xtRthnL8Yztvdf6tUQiZ+j7bFtnSIV/etdWmp2IQ3zQqHoFBRV
	Bi7H+FsEGGkZpn5wDoKummFQgYeDBEk=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=XsS8wses;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf30.hostedemail.com: domain of BATV+c83a8b98330cc0662794+8269+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+c83a8b98330cc0662794+8269+infradead.org+hch@bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=NTxaoTWsYIT6XinpmC611FM9scC20rVnNKMI/IZpFxY=; b=XsS8wsesxfQHJeuybXI9UlK1MH
	5Sksd8i1n8hsFjUjYeaSfkUHe0jE0+SqlsoUnoCGG8SErY8odbMf4TBWHD/CRawf0WlGVvTsbUt05
	l1xMx1w3D64214rmihWMGYe96OMd6PH7aZ5YcU9my2HHe/6AOtWlOF80RhZAEbPKm8m2ycaYZ+ukS
	d/OeQL8oHUpIdN9nIG54unA+EgsAkO8gihqjQKT6cQiC90JSgEhCRanOlc80xOFH5vLcnq70PrRWl
	PSgoPGw9CrKwYYK2Cmo6bbyRVDEx3mihLAWDPGHf2bpAMXou+5xrT9GLNEPXeq4m8g/VfWzeWnq/0
	zCmqhsLQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wCYZ4-0000000GvSy-0kII;
	Tue, 14 Apr 2026 07:52:06 +0000
Date: Tue, 14 Apr 2026 00:52:06 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Nhat Pham <nphamcs@gmail.com>
Cc: YoungJun Park <youngjun.park@lge.com>, kasong@tencent.com,
	Liam.Howlett@oracle.com, akpm@linux-foundation.org,
	apopple@nvidia.com, axelrasmussen@google.com, baohua@kernel.org,
	baolin.wang@linux.alibaba.com, bhe@redhat.com, byungchul@sk.com,
	cgroups@vger.kernel.org, chengming.zhou@linux.dev,
	chrisl@kernel.org, corbet@lwn.net, david@kernel.org,
	dev.jain@arm.com, gourry@gourry.net, hannes@cmpxchg.org,
	hughd@google.com, jannh@google.com, joshua.hahnjy@gmail.com,
	lance.yang@linux.dev, lenb@kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-pm@vger.kernel.org, lorenzo.stoakes@oracle.com,
	matthew.brost@intel.com, mhocko@suse.com, muchun.song@linux.dev,
	npache@redhat.com, pavel@kernel.org, peterx@redhat.com,
	peterz@infradead.org, pfalcato@suse.de, rafael@kernel.org,
	rakie.kim@sk.com, roman.gushchin@linux.dev, rppt@kernel.org,
	ryan.roberts@arm.com, shakeel.butt@linux.dev,
	shikemeng@huaweicloud.com, surenb@google.com, tglx@kernel.org,
	vbabka@suse.cz, weixugc@google.com, ying.huang@linux.alibaba.com,
	yosry.ahmed@linux.dev, yuanchu@google.com,
	zhengqi.arch@bytedance.com, ziy@nvidia.com, kernel-team@meta.com,
	riel@surriel.com
Subject: Re: [PATCH v5 00/21] Virtual Swap Space
Message-ID: <ad3yJiHuxT_-quHG@infradead.org>
References: <20260320192735.748051-1-nphamcs@gmail.com>
 <acQrQYHJgqof0yx4@yjaykim-PowerEdge-T330>
 <CAKEwX=NnHxpQKp9qBg2=r_euyjgxw2nHXjbgof3MymHTgJmRAQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKEwX=NnHxpQKp9qBg2=r_euyjgxw2nHXjbgof3MymHTgJmRAQ@mail.gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Queue-Id: 29D8A80008
X-Stat-Signature: 8konmauskkj1rsjyomh3yx13e5qb1ji6
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1776153149-885751
X-HE-Meta: U2FsdGVkX18B5dQUucj3Kw25fJ7vlijQLcK2dLfN10qOF8TeC1ZCsr4Ce3LtmJdy2w3+hVwjmg/8ne+EkksOIPnmz03VQOwk1UlHscUsx19HGKKID8BqjsAx18MCGsF8FHMo7YeML7XEQ1qi/Rf4m5LxxdHAvp8GIrf5OBByB05T2Ba9LeMfgwmRwzvqAZVPuYZKrumYpiB7RwGuzewxQWUTue/ZTvc6LOeVEMXquUutcwzKwbJrnCu+ETs3Xb44DQNNUNhRFgK6f4JqmdU0Rn4BlJqcGhwX8jZtwqOV9lEQ4PWdCrgqR1HnJV0Hum0Ka704XSacHlD7OdJvuxd/FPXwgFCSXst3mCLiShvsciOtB1VDqBB1sh1+5ltCqQ7MwfxAAlQgzCR3E3skIp+Z6TqF/X/UXM75W4POwQ2pkLQDfZ8Us1PqukZrR4vvfU9R1jVzdEbC1kkGDIDIdgvqOql3OJ743CWrlHLfwVTRHNd9vUukFjbXCJPaoiJ4A7iUixQqKIn5ScMHPd9uO0aNn1W/1uiqKR4PELY237feB1yoFvwDBdgkxe+su5RdjXoPKZdsr6oDOuq6Edu7qmfzBrtPhndqbTXYZZxOKDnV4woBJSX3FXy/hC99W/6c2o7gV9pIuqqP5eH497OaNsnxGy9V5mPFdUASqhMyIFf9n5jjHvGCRPTbjrQmjGJRChmhs+zXgCn4D9CgWNFKY3N4Z2ygOOvf/CQJHtIK4v418c8vknme2LDokzlNDdZDgI4Vq/4nRvXMrSJWVWKSHGcnKb9JVhNNP43udC/pDMh1t8jRxWudeP0edi3YbCd3YA6TlpinGgZz4/go9CQv1TASz3XCdf7Hp7eAUvtiHqgLWMKhb+IQiym62WiM8v3O3wwVod6yd+5TMktoAV9fXOhsbNyZeZ/zVxegZQ82NQc/8HQe7WaPuqtL++Q4fFtDRcc6PcgqnFmk0bGUN+Dogk5
 DlwP6Ob5
 CH3WFQZ3ZoMMPtMxoml7kKTtkfIaXy0Qxpn5wOeCuSM++xP2vGT+PnN9D0oOw6pCA3yWHsG9rJh0GJeXbxEZHASQlukmqXnCQRx6ImmQV68DAi82xW2jRMFXtyKgzoqjpFm96YH2lgQa4qFzAnVmaz03NytEL7uf2r62CcKEEimf4ts50gwKPTENoyJ9Hz/rJCK54JEE8NbOUKuFOUSDh6mzwcw21juwUEosf6aNEKLL98Od82Ipy+9mnlENaP2is9BjkVgeJiwxk4dDWQMp5G0wy6TcI9JkdGi9yEa7U19iWpFLee4hP9KI02mCD5v2HssxfYaQOeGnFT8zpgs7ivPUPnY1q3YLUI1e25fTGrpDGHTJwOaxogoVEMV3Vz5yZ2di35wtrXvfmNAZjoaSu6dn5/mZd4MHG2fB+wsDYsFfI6j1Qv7ibXhBfBVwHHS41q/J4hMTcCJra6CUc2jH+TqzEFvcA7yjXjREY5X+cBIIzL+K6BTcrEtXHp8CAluam6Y3xRUbrkrDuEMmGwmVKPLFvei5DvscdsyTJZTb2HpXF2G3YHpccQycxph4TK3B8oJJ8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Apr 11, 2026 at 06:40:44PM -0700, Nhat Pham wrote:
> > However, if the modularization from point 1 is achieved and
> > vswap acts as a swap device itself, then we can cleanly
> > establish a:
> >
> >   virtual -> physical
> 
> I read that thread sometimes ago. Some remarks:
> 
> 1. I think Christoph has a point. Seems like some of your ideas ( are
> broadly applicable to swap in general. Maybe fixing swap infra
> generally would make a lot of sense?

I think a first step would be a dump of that code, even if it is against
an old kernel so that everyone knows what we are talking about.

> 2. Why do we need to do two virtual layers here? For example, If you
> want to buffer multiple swap outs and turn them into a sequential
> request, you can:
> 
> a. Allocate virtual swap space for them as you wish. They don't even
> need to be sequential.
> 
> b. At swap_writeout() time, don't allocate physical swap space for
> them right away. Instead, accumulate them into a buffer. You can add a
> new virtual swap entry type to flag it if necessary.
> 
> c. Once that buffer reaches a certain size, you can now allocate
> contiguous physical swap space for them. Then flush etc. You can flush
> at swap_writeout() time, or use a dedicated threads etc.

That matches what file systems do with delalloc, where space 2 just
adjust an in-memory counter for space reservations.

> Deduplication sounds like something that should live at a lower layer
> - I was thinking about it for zswap/zsmalloc back then. I mean, I
> assume you don't want content sharing across different swap media? :)
> Something along the line of:

Does dedup in swap really make much sense?  If you want to dedup you
also want to do that in-memory, i.e. using ksm.


