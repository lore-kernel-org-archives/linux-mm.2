Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01DABCD6E55
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 15:10:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 61C106B009F; Wed,  3 Jun 2026 11:10:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5CC3E6B00A0; Wed,  3 Jun 2026 11:10:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4BBF76B00A1; Wed,  3 Jun 2026 11:10:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 36D266B009F
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 11:10:42 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E8C561C199D
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 15:10:41 +0000 (UTC)
X-FDA: 84838938282.20.0558CF6
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf18.hostedemail.com (Postfix) with ESMTP id EE2111C0002
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 15:10:39 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=S+4Z2CjW;
	spf=pass (imf18.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780499440;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UwyE00rrj7YKUAiyH8ti6NE4tmnyPUBdLYn07MV8MEM=;
	b=3DHGIi9PiEBqaEhCBqGuINe24/89lAOXeNT/H4QPddtrLCgHI+Ggk0fN3pNjDwSavrwBGq
	/YSqo2db2kbnpD6HjSnXXt3XAzw5sxwdhdrjzEssvK2dVnXLhduRBCdWCMosIa+th7HK+s
	uBS3idBk7grUrP+hglFpukZt6iiuqh8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780499440;
	b=dnIRLca04/+2MPmQf1M6qgV9xiFuEO/eXEAGSSNGVahpW7x8qdaL+C6f859Y9ZQiEi1o8r
	Eb1Pcb1Xmqz4zJk3HxqzAEuaLu7ZwnyMeKVSuVm+PGVoGXGjh5tUm7ICheaQTz6CpvJvJS
	nXRWvRUZRDPjm9VgO4BcfEXj+NWj/Ew=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=S+4Z2CjW;
	spf=pass (imf18.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Wed, 3 Jun 2026 23:10:27 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780499437;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UwyE00rrj7YKUAiyH8ti6NE4tmnyPUBdLYn07MV8MEM=;
	b=S+4Z2CjWVwdImKKTlKF0PC/QctyLevgRJcGkXte8oq9tHbfSwMeMtof58D48AcISbCXwO7
	kHtRFU0/IMPtKalsGQ8q8BUdGcAURSZUKoYpOqfBTMqVzKvE/sDndypwSAKGr/VWMB7u8N
	9uIAUtYNT7sBZBjABJrkEkE5PKx7HTY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Baoquan He <baoquan.he@linux.dev>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>,
	Jianyue Wu <wujianyue000@gmail.com>,
	Tal Zussman <tz2294@columbia.edu>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/3] mm: move folio LRU code out of swap
Message-ID: <aiBD41GnZtyrkVfB@MiWiFi-R3L-srv>
References: <20260602-ch-swap-series-plus-folio-lru-cleanup-v3-0-5bbb567f8c99@gmail.com>
 <20260602-ch-swap-series-plus-folio-lru-cleanup-v3-2-5bbb567f8c99@gmail.com>
 <ah79c9IIuXt51ybs@casper.infradead.org>
 <aiAGrJsNm_uAf1qu@MiWiFi-R3L-srv>
 <aiAXwQQz0MeGrD1x@lucifer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aiAXwQQz0MeGrD1x@lucifer>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: EE2111C0002
X-Rspam-User: 
X-Stat-Signature: 4pxexbnr5ues6mjx7zwcmdmkppf19kq3
X-Rspamd-Server: rspam08
X-HE-Tag: 1780499439-831501
X-HE-Meta: U2FsdGVkX1+h1++823K5eUgaptdYPtiY/NB2CdCni8Wi925uMDE+S71pybtEsTG10j4X08Ju72noo1yjwWdMzFqpT0MDbOpywB3Gh1jYmFwt5IiHOBwI6eYHXL5VnfeTUS06hQdwui3UR/I18ktVGxoK42QUgU5gst7dt89suGhMPMJ3qqpHp4XvWi1g9AdIuJ4CXnm+DkUHHbK9Lsh8eIioX196zmIzTlee00L03U1VwQnCay0rfogYgdIF8xaKR5zn7cWDC+i9NVEaOWZLadYcE00qzbTSuRwSvATekrw00V9G2kfMU+crqyxoTKEvSydJsF/uIXw6dHB4hciPDdGVmu7s3jnolghyi8pBDn3xY0hOGUbYGntJqb5CxD6Bt+OIHKw7TYkVR0Ef2AuTRgVHgnnjUqWZHmZ6MbKLGF1Z+HE0TC1zGc16YCf+PCjYV9TE072SoYX5F3NYiR71SIVVOEtXK2I23QJpN29ETw4i+szhXodK0/n/0Qb+lEtftnQw6suW2Mm7/FhwFtJwb54NfGgpeXoZmSqtN/rMuJy//UNlBCaJuVPNW/PxNy58/6Wv5ZEFP5bD9fnxzsw9JfTEbfWPyi5jYwaUCxr3opWnGiAcnIkGEqZ415ixCiPF6adFjTKaMqrPQ3bDbbX7tKA4QArkWwZEcyUa27AUH2O3Ox1xOYzCGNbOozP8UQhezf1SPoV0JvaOWcgnwcwJbu0gzw3+ogTw17Hp6bNCxKgMfA34JZnM94bIbJ0pACJmxcM6usn3FYSM/S7dMZmCDxLdbXm+NjBBjCb5JDeKHLPrXMTd0u6ovDLoThItDMsLbrX7PUG2BQ9ZXhiB/MOU+gVH7IoQaR14DQ7LUErvGA+Go8PkQzE+YIdE9Zwy8zuXgiK+AIWOOhBM8yeEgV9+CjRzG3YFDz5EYT5MFN1qnQRoXYfluY0kyhS56Zq9Q28P/IVBo/mbo6z6Wc4xxEt
 rECb9VLD
 4h1jjIMM47XNQVMVwIpA3L9d3+ZAnFRxojfCW8Q9jUx9knvJuc5G7v7phuzCrN3Gm4Olz/mCH42FgWfF9nqUeTaYyQE3ukZSRuvhSP2wFRDSESvMeSkxnUW4VdvX5xQWM6rkesoPhp3pj+mHLxHJnswM2HMlI//ZWjOB7U7Nr/y7c6EWTrJ6m/WMIx6+ph5D/LIw6MB2mzYMzifTo8+3sAnoyUisiIOtEAKVcKQQmMZP+lvBEGoSnmLFEjmPq3fc9un4GH4pf4TVUKhvkhLBk1Hy4Kw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 06/03/26 at 01:03pm, Lorenzo Stoakes wrote:
> On Wed, Jun 03, 2026 at 06:49:16PM +0800, Baoquan He wrote:
> > On 06/02/26 at 04:57pm, Matthew Wilcox wrote:
> > > On Tue, Jun 02, 2026 at 09:01:16AM +0800, Jianyue Wu wrote:
> > > > Rename mm/swap.c to mm/folio_lru.c so the filename better matches
> > > > the code's main responsibility.
> > > >
> > > > This keeps the implementation split from swap-specific code without
> > > > changing the published LRU helper interfaces.
> > >
> > > At the same time, we have Tal trying to split folio_wait.c out
> > > of filemap.c.  https://lore.kernel.org/linux-mm/20260520-filemap-split-v1-0-c36ddc2b6cf2@columbia.edu/
> > >
> > > I wonder if instead of folio_lru.c and folio_wait.c, we shouldn't simply
> > > have folio.c.  Tal has 700 lines in his diffstat, you'll have about 1100
> > > lines, so that's about 1800 llines which seems like a good size.
> > > There's some functions from mm/util.c that would fit nicely too --
> > > folio_mapping(), folio_anon_vma(), folio_copy(), flush_dcache_folio()
> >
> > I think folio_lru.c and folio_wait.c are better than a single folio.c.
> >
> > A single folio.c with all of them would have no clear boundary for what
> > belongs there and what doesn't. For comparison, page_alloc.c isn't called
> > page.c (we have files called mm/page*.c).
> 
> Well page_alloc.c doesn't only contain things that operate on struct page *
> right?
> 
> Whereas folio.c is strictly operations literally performed on folios which seems
> like a good match to me.

If so, then maybe folio.c is a better name. Maybe in the future it
becomes much bigger when more and more folio related codes are added
in, surely that's another story.

> 
> I find folio_lru.c and folio_wait.c far more difficult to figure out what goes
> where and there'll be a bunch of miscellaneous stuff all over the place.
> 
> I vote for folio.c.
> 
> >
> > >
> > > Other people have thoughts?
> > >
> 
> Thanks, Lorenzo
> 

