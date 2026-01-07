Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0421CFD658
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 16:13:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E1B466B008A; Wed,  7 Jan 2026 11:13:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DEF7B6B0093; Wed,  7 Jan 2026 11:13:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D0F326B0095; Wed,  7 Jan 2026 11:13:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BF19B6B008A
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 11:13:37 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3FE8C58A91
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 16:13:37 +0000 (UTC)
X-FDA: 84305663274.27.F9A2585
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	by imf14.hostedemail.com (Postfix) with ESMTP id 4661C100003
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 16:13:35 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=chFS53lF;
	spf=pass (imf14.hostedemail.com: domain of kent.overstreet@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=kent.overstreet@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767802415;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fPQWIADjQC4TwHC8EiEiCB9H2oAaqtO+F3440ryzkow=;
	b=GJpdo/fSea0p4q7zm4JWT+Uie9IepMVNVptoWBHAvNd4eoZd/LyMbYKLRlQbF+araaE1nP
	c3KniGpKo3O3HUTHtfXHIP7zM7JBxzhWwbRzZ9wShrXT5a/E1P4lpxBQ9PyhJ7f0udKVkg
	YZmcVFaEBjdAYSDTjpmBbfADCkO45N8=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=chFS53lF;
	spf=pass (imf14.hostedemail.com: domain of kent.overstreet@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=kent.overstreet@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767802415; a=rsa-sha256;
	cv=none;
	b=7MFyzX/fwhrKn6VwzFsX5yfRC/1xlXi5LbajTG8JzqMbxKMt2u8/fnQqwCtBcdPt8xQbnD
	T4XxvpmdQr/wFpR6qDmM3pIewFRxTNUit2chwF0I4vKI94bJdWooVqO7OSfyVdjOzoB9UH
	tBuGsk6WZCNDtZKyr1MJLusN6k1N53A=
Date: Wed, 7 Jan 2026 11:13:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1767802410;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fPQWIADjQC4TwHC8EiEiCB9H2oAaqtO+F3440ryzkow=;
	b=chFS53lFvbAgqR/F2l0q9UIIt5jKIUa8bUnrVWOreRvouZxaQlayxNBmeNT8oJ2QJFNftd
	Igbho/vMjGiYhwOWnd+IP23I2HreqRABjgaLhfODP+Gs3TfpAyDkksSxE2l0DlQlWufVpR
	zHC9GRuKYT9b9iXvSzgcPp3kdn/xJEE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: David Wang <00107082@163.com>
Cc: Suren Baghdasaryan <surenb@google.com>, akpm@linux-foundation.org, 
	hannes@cmpxchg.org, pasha.tatashin@soleen.com, souravpanda@google.com, 
	vbabka@suse.cz, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] alloc_tag: add option to pick the first codetag
 along callchain
Message-ID: <aV6BnhG9yjX10O27@moria.home.lan>
References: <20251216064349.74501-1-00107082@163.com>
 <CAJuCfpEtZ2Ncpa4goKUcerruB67fALJ2v2KrbWB1_PB7iwwjSQ@mail.gmail.com>
 <75285cc4.3c52.19b916d9490.Coremail.00107082@163.com>
 <aVzorksJEyI0wlxh@moria.home.lan>
 <37169c79.a0e5.19b93a2768f.Coremail.00107082@163.com>
 <aV2VWbY4Rb_w-QTs@moria.home.lan>
 <4736b304.38a2.19b96888104.Coremail.00107082@163.com>
 <aV3bykzqkyUcBJBf@moria.home.lan>
 <5b356cfa.4ab3.19b97196d49.Coremail.00107082@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5b356cfa.4ab3.19b97196d49.Coremail.00107082@163.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 4661C100003
X-Stat-Signature: dcrkwbhiedj7d7n6do97h76q45165qa4
X-Rspam-User: 
X-HE-Tag: 1767802415-129756
X-HE-Meta: U2FsdGVkX1+CsBDDxzIEkcD5HnecKy5BZo7Byaf9s0S2Dvg18jzY446m+jnv5PLEy1P70Vq8mtqwVPoH6wkaFzeX2aBV5ooNYuMo1Y1OqIt5gm7hksPTDzLg6oa/OmkVdnmK+7c3wBodquTaJFEoOllGxN9U1xs6qJHX2UpOzbSiBkEvcJx5n+0Ck3v0yt7erm4jUpkHZDRGwiPiZzprMPCfVz3gXbsRDX8HBfmCnaK2+z6tsAEyKGMTu6pXh+lFNVzLWcHo1EBfvEPlVvhJZRuC3ze1W+W2hj9jtyUkc9kghQwHOyLLt6SGpNYe4/L4pOOpPd1nx7tYqdLY49gIyGtRqVkLNzKTxikDgLO4n9nzt6RdkKG/IGx3GbGXw6y1AsH2EHBSxEBHBOixwxgE3Mcg4QlXKtBxU2FfZ/crH/yE0w+aUPhtqawLPpECJBqQ2AfWlLGPFISi6Wd3BPH967A9gRDIciCDQY71MhKedQ38TEwoSgGBjqG578wzYpOACIhp6oomon7b9fA08oODA8jfDnV2l8W3ubM39v7bPYjQAGloe2mHYLcHBl4DDXHM9+deViQkCJ2A5/FvE780w4DtPoHCgApbfmOMdszV0yOtB/X4kCDh0lKiMP9x3yADNgs6GI8JDvBqQuvtcbInvP+SC9F12GJ/qt9Cw3mCUKtEAtcpFOGmiiTF1TMnB++j4WJLc5hnDTHkK7DSEsv4Xg5MiOOftgYPgciZvbyAS/V3ppaAV/qwYS9Ta++rnMRhSQeEfbdyZdw4mFGZ+pbQNdoqe/YYb8p3wjWGDWP5Sr+/5dkC4xdQBZUJPtQdL11aCCwZ+IVzy0l2wdLQY0hJJf7gmK0gtEN1QY5uA0WYGHV0y6kbMpgxjb+ROU2BYNhSbWscDFS1+0DEQo+cDuR7exl77Jt0eZvVQOZRaC2TBi4Temzb3EJNoZ48YaU3lx29Yc3XMtR7ZbZg3hN4uZt
 rVPIkZ34
 uwIiOCEORQCncDcHQ/xqbV0+0OVVd+1udt1YMNxHuhJjJ2qb0lh9oVlootVZcGKlZrJXovrywPyIACLHoJMpdcBTrX5P9lKBft1vIxmjnj5ob2YgN37zu527/fMtWKJ2RnOua4BnsRnaAjOI/CFBf7w2Qd59zHWzNIE1BxuDahuzYj5ZtbiNoXsNbkdpZwSCMml3LCdpjZK4HHY08mfwZpOjKR+hcmoFfojjemtigknxR7qBS0nOes7QoBX4zgxDgYB6r2dW7UtlGcWHfE37VFF+1m0y89kT0twUTHtUEpcHSbQRzq/FmomdIhpawsZZYujqI
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 07, 2026 at 02:16:24PM +0800, David Wang wrote:
> 
> At 2026-01-07 12:07:34, "Kent Overstreet" <kent.overstreet@linux.dev> wrote:
> >I'm curious why you need to change __filemap_get_folio()? In filesystem
> >land we just lump that under "pagecache", but I guess you're doing more
> >interesting things with it in driver land?
> 
> Oh,  in [1],   there is a report about possible memory leak in cephfs, (The issue is still open, tracked in [2].), 
> large trunk of memory could not be released even after dropcache.
> memory allocation profiling shows those memory belongs to __filemap_get_folio,
> something like 
> >> ># sort -g /proc/allocinfo|tail|numfmt --to=iec
> >> >         12M     2987 mm/execmem.c:41 func:execmem_vmalloc 
> >> >         12M        3 kernel/dma/pool.c:96 func:atomic_pool_expand 
> >> >         13M      751 mm/slub.c:3061 func:alloc_slab_page 
> >> >         16M        8 mm/khugepaged.c:1069 func:alloc_charge_folio 
> >> >         18M     4355 mm/memory.c:1190 func:folio_prealloc 
> >> >         24M     6119 mm/memory.c:1192 func:folio_prealloc 
> >> >         58M    14784 mm/page_ext.c:271 func:alloc_page_ext 
> >> >         61M    15448 mm/readahead.c:189 func:ractl_alloc_folio 
> >> >         79M     6726 mm/slub.c:3059 func:alloc_slab_page 
> >> >         11G  2674488 mm/filemap.c:2012 func:__filemap_get_folio
> 
> After adding codetag to __filemap_get_folio, it shows
> 
> ># sort -g /proc/allocinfo|tail|numfmt --to=iec
> >         10M     2541 drivers/block/zram/zram_drv.c:1597 [zram]
> >func:zram_meta_alloc 12M     3001 mm/execmem.c:41 func:execmem_vmalloc 
> >         12M     3605 kernel/fork.c:311 func:alloc_thread_stack_node 
> >         16M      992 mm/slub.c:3061 func:alloc_slab_page 
> >         20M    35544 lib/xarray.c:378 func:xas_alloc 
> >         31M     7704 mm/memory.c:1192 func:folio_prealloc 
> >         69M    17562 mm/memory.c:1190 func:folio_prealloc 
> >        104M     8212 mm/slub.c:3059 func:alloc_slab_page 
> >        124M    30075 mm/readahead.c:189 func:ractl_alloc_folio 
> >        2.6G   661392 fs/netfs/buffered_read.c:635 [netfs] func:netfs_write_begin 
> >
> 
> Helpful or not, I am not sure. So far no bug has been spotted in the cephfs write path, yet.
> But at least, it provides more information and narrow down the scope of suspicious.
> 
> 
> https://lore.kernel.org/lkml/2a9ba88e.3aa6.19b0b73dd4e.Coremail.00107082@163.com/  [1]
> https://tracker.ceph.com/issues/74156   [2]

Well, my first thought when looking at that is that memory allocation
profiling is unlikely to be any more help there. Once you're dealing
with the page cache, if you're looking at a genuine leak it would pretty
much have to be a folio refcount leak, and the code that leaked the ref
could be anything that touched that folio - you're looking at a pretty
wide scope.

Unfortunately, we're not great at visibility and introspection in mm/,
and refcount bugs tend to be hard in general.

Better mm introspection would be helpful to say definitively that you're
looking at a refcount leak, but then once that's determined it's still
going to be pretty painful to track down.

The approach I took in bcachefs for refcount bugs was to write a small
library that in debug mode splits a refcount into sub-refcounts, and
then enumerate every single codepath that takes refs and gives them
distinct sub-refs - this means in debug mode we can instantly pinpoint
the function that's buggy (and even better, with the new CLASS() and
guard() stuff these sorts of bugs have been going away).

But grafting that onto folio refcounts would be a hell of a chore.

OTOH, converting code to CLASS() and guards is much more
straightforward - just a matter of writing little helpers if you need
them and then a bunch of mechanical conversions, and it's well worth it.

But, I'm reading through the Ceph code, and it has /less/ code involving
folio refcounts than I would expect.

Has anyone checked if the bug reproduces without zswap? I've definitely
seen a lot of bug reports involving that code.

