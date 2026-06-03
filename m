Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B29D5CD6E4A
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 12:03:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 28C4B6B008A; Wed,  3 Jun 2026 08:03:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 23D4B6B008C; Wed,  3 Jun 2026 08:03:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 17A186B0092; Wed,  3 Jun 2026 08:03:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0770C6B008A
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 08:03:19 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 94505C17DB
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 12:03:18 +0000 (UTC)
X-FDA: 84838466076.13.C0F34C8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id EA75FC0010
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 12:03:16 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MoOFKsN7;
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780488197;
	b=Z9S6TtDk1wpwjI3knBbVRE8DHX2z/y0EqKjotYAXDmELAXmNh2DEVYuaw7VHwZFYx1tie4
	7phLveEWemdCuvjs2halAGg8Y1viXjO3Mx/tOiV9QRx52NThe1J39NI+3v9d5EGB7arNL9
	LmBf68+4zMyxeL3c+WlJVTFeOWrkSoc=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MoOFKsN7;
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780488197;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5d4xRFPbP4Xfog839Pinex43yBWGt94sNmIfZBMoWz0=;
	b=IJC4jCcJwxwVVxDuI92yXBxGqI8Bmqd4zJ3BxQeGCOoPSLPY3bPuV4+UeJzYKXgswtgdHI
	AJkl0ovRWwRfPsEcbSoFRG86m/CLsn2OMy1R9NGZGI6lr/BiLW7ZsFoXYBVceA2KKXnEq2
	OhDqVF6drXLf21H8kcBQCMnfK058pK0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 25F2E41A10;
	Wed,  3 Jun 2026 12:03:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 335FB1F00893;
	Wed,  3 Jun 2026 12:03:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780488196;
	bh=5d4xRFPbP4Xfog839Pinex43yBWGt94sNmIfZBMoWz0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MoOFKsN7iFLlD2JoCjCFxOTgfgpJv1D0eJNUp4QNUqw6CrVwonSbGD7FY3NAOHMt/
	 FS/x8cDFTtbLvduRxbQSfG46Smzaj2FMiY6/0n0U9AL6vBrK88UIjX2pIUBUcu9pzw
	 e+ekA7HEqgVcPf5yIl73tlAFj+pa7bMl9Jz/d8aBxHrHAIULOjJ1QV5Xl3DNtlQVa+
	 w5pFbuF5CdCdQ1I9drd6+2BKkBw06QtfPbClInhXPH6DTeREfESyTFBicevQ/YFFys
	 rPCvapVR/0KQiFm1A235nhA2qDMQjleyJEIiKszfPAUz8RI3mkaxUPFHm2q08b38/v
	 /ijZ94/SwkA4g==
Date: Wed, 3 Jun 2026 13:03:06 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Baoquan He <baoquan.he@linux.dev>
Cc: Matthew Wilcox <willy@infradead.org>, 
	Jianyue Wu <wujianyue000@gmail.com>, Tal Zussman <tz2294@columbia.edu>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, 
	Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, 
	Michal Hocko <mhocko@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/3] mm: move folio LRU code out of swap
Message-ID: <aiAXwQQz0MeGrD1x@lucifer>
References: <20260602-ch-swap-series-plus-folio-lru-cleanup-v3-0-5bbb567f8c99@gmail.com>
 <20260602-ch-swap-series-plus-folio-lru-cleanup-v3-2-5bbb567f8c99@gmail.com>
 <ah79c9IIuXt51ybs@casper.infradead.org>
 <aiAGrJsNm_uAf1qu@MiWiFi-R3L-srv>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aiAGrJsNm_uAf1qu@MiWiFi-R3L-srv>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: EA75FC0010
X-Rspam-User: 
X-Stat-Signature: ujnsrefcrg34x9xtf4s4iery3dizoyz6
X-HE-Tag: 1780488196-630245
X-HE-Meta: U2FsdGVkX18iMPBIhVNApVrSpsfNbTCB2PnAN6fd7krUosBC9tAsAqbtrd6+JEl90hMxE/CYsGY1/WMSBn8H3UXPyGJpXg6cxNo9KUMINdRFURwFJod0t2AvdmwCar5Q8zYucXJSF/ACbZJpBl8l3XtQebDYiphzn9zAFTzUfLLJ8qu9jJ71lIvDB3dc0wGfzwQZ0TVUpJGrY8VC2AfMnIw1vY74esXCCKL2K723voUqIv/+s6j0F3pY8sHiHn3AwwWB0ZGxDHANvAQkfGsyvhR5yd+MNzwaxdv3GAhGo5zBWRYQISGR9+Foq/1V1A5E9+0f1ufXU7ZKLP2d8/O1c4ogna3dIlC1rVM0KdBA66fBtyVX3lAkIKj1woA5hEjgk9qxqv8trQToFe/tpjxoLIRZna4xqKwDuq1p0AwUDEIVmrcmo0sZobeiKZMZuzX0CL6EFF0fXEnYfeKh94CNBgfCgLQeWV3fXP/hwH1ftqZs9a9tJuQxHcbqDXbfD8l09GkscOZ6BiC5wBA4iF9uM6JEAXXcKbMsl7Wvn2hbCHklCrRqmYEYKX+Ej73SeHUkrIW5XLuAKUp8HbwaCjZcOAke+V+wk71E+HRlgIkGlrQ/SrcYi8w6N2h3rv75atTUbnjFX9ZHnYGEoBP5HwQKWdVknpDK2tPvJw9PQcxo2zLf55xPHh13h/geVzeXmy6Q3qQ2FnkGB2/azfTDnw64bT1uP+qiZ67nCmFt40wJVFSUlM+F6z2tfi57gHzmaG8cqZYsC4hDc0Hnyn1d54ZNYoer8d57ANM0rVdMUzkIkW55d8jeu+F0s6UDdszFaJQHfgOPeTGuTSPlNrMdPH30b1JR1jjnKrdtxxa71f93dc/quAQLjAQwTp0KY9eo3rFOF+ZUiv1X2xn64IJEuh2c708WflZj+rj+VpErTE4xIYE+3u57QAzI01ml2e7dBDdb9WPYXkun838JyRQ900K
 xNQoYKFD
 ooqB5hgHBntj7xPcazhJ51Kzno8CUCzg/kPEMiN91Yuw0x/rQ3HYXkqL/b2ju9MJ5a5tsqB6ZTJJesrh08M0+Vv4zU9A7a6yLpb2uGjikFL72KdDJ2juPFXpGxiDkKUeTeF79RQK45ojDyIPYxT3mXYvtaPr9MwPOkF8+z1vESO30BBjVO/97Vnc6j05fGyGmJR7KlmrN7DALT+Q2PtXo686tmU/6TjWaUjmYcFD3wjZFtFXRkJSBx9sawPQTs81Fwee/OOwZBoM3DAqihcZbs6KYtw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 03, 2026 at 06:49:16PM +0800, Baoquan He wrote:
> On 06/02/26 at 04:57pm, Matthew Wilcox wrote:
> > On Tue, Jun 02, 2026 at 09:01:16AM +0800, Jianyue Wu wrote:
> > > Rename mm/swap.c to mm/folio_lru.c so the filename better matches
> > > the code's main responsibility.
> > >
> > > This keeps the implementation split from swap-specific code without
> > > changing the published LRU helper interfaces.
> >
> > At the same time, we have Tal trying to split folio_wait.c out
> > of filemap.c.  https://lore.kernel.org/linux-mm/20260520-filemap-split-v1-0-c36ddc2b6cf2@columbia.edu/
> >
> > I wonder if instead of folio_lru.c and folio_wait.c, we shouldn't simply
> > have folio.c.  Tal has 700 lines in his diffstat, you'll have about 1100
> > lines, so that's about 1800 llines which seems like a good size.
> > There's some functions from mm/util.c that would fit nicely too --
> > folio_mapping(), folio_anon_vma(), folio_copy(), flush_dcache_folio()
>
> I think folio_lru.c and folio_wait.c are better than a single folio.c.
>
> A single folio.c with all of them would have no clear boundary for what
> belongs there and what doesn't. For comparison, page_alloc.c isn't called
> page.c (we have files called mm/page*.c).

Well page_alloc.c doesn't only contain things that operate on struct page *
right?

Whereas folio.c is strictly operations literally performed on folios which seems
like a good match to me.

I find folio_lru.c and folio_wait.c far more difficult to figure out what goes
where and there'll be a bunch of miscellaneous stuff all over the place.

I vote for folio.c.

>
> >
> > Other people have thoughts?
> >

Thanks, Lorenzo

