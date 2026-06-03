Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E6C4CD6E4A
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 12:41:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C144F6B008A; Wed,  3 Jun 2026 08:41:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC5306B008C; Wed,  3 Jun 2026 08:41:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADAA56B0092; Wed,  3 Jun 2026 08:41:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9D3EE6B008A
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 08:41:04 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 456598D455
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 12:41:04 +0000 (UTC)
X-FDA: 84838561248.17.C3056A3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 7825F14000E
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 12:41:02 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=I7pyiEBS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780490462;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AGwrdfa8qLYOzCYiYEBtpSv3/VKvDzE6dpVQrFCHUGU=;
	b=uaGFGBHgLK+dElN8wyOk05N/JYIdVNdqwsb9jJ2+NuNp5MqXY80CX0+WEyHQno5Io4FvL6
	cDW3EaA41UwNKdYNlt868dtl1KWR2D01EtUkTyRQamARCdUJRwfFXen0nzoHHLOnn1SLMc
	bvu0Vy00db59/azEE76pH9UHNtZJeiI=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=I7pyiEBS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780490462;
	b=Ix7H2tLK2tBRWLkakEaKvGQPuiMMftpk9s6y9e+XjbCyckLEEOA3aTLVD4lemvaBsNobxD
	pFPyQMkvQfmEw71ECVkVPO7gkkDBa8RYRu6QIfLbCqZTR0oHN2zyWdgnyg3ntfWfUYAcfe
	574Qk49u7lP25+sSpKcoKHPMaaUqVA8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A1E3C43DE7;
	Wed,  3 Jun 2026 12:41:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9D7C1F00893;
	Wed,  3 Jun 2026 12:40:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780490461;
	bh=AGwrdfa8qLYOzCYiYEBtpSv3/VKvDzE6dpVQrFCHUGU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=I7pyiEBSsv1qXzqFWZ1j+lm9f19zsfETib7kRZOKD6KyMC2Fehxe/pvG800JKwja/
	 RBMRd1Uv2JsJ37kLsOYyGScalYaE47SafqnVdazIm1I9cEezjd6dmL4f3H1oQwUKh+
	 5jVdIQ9vyRrcX77GX1zGUC+bv4zhldDOUiXqG+aZfi1qpklKzd9fT172cYUCeK1rUq
	 fLLUaqd2dzkV8VNecT31WnJcAk6excInWHEdWekLlZYsASRJwGKQR/Y36v6nPYKcmY
	 0u+Vt4sCqyvdrIbHJA2ZE07HrXIRM7lyDLDsYNIwht1f3fMFDr27VVHbdskcjaZqkg
	 6UPLDqyNIMPFg==
Date: Wed, 3 Jun 2026 13:40:51 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Jianyue Wu <wujianyue000@gmail.com>
Cc: Baoquan He <baoquan.he@linux.dev>, 
	Matthew Wilcox <willy@infradead.org>, Tal Zussman <tz2294@columbia.edu>, 
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
Message-ID: <aiAgvcS7b19G0wEu@lucifer>
References: <20260602-ch-swap-series-plus-folio-lru-cleanup-v3-0-5bbb567f8c99@gmail.com>
 <20260602-ch-swap-series-plus-folio-lru-cleanup-v3-2-5bbb567f8c99@gmail.com>
 <ah79c9IIuXt51ybs@casper.infradead.org>
 <aiAGrJsNm_uAf1qu@MiWiFi-R3L-srv>
 <aiAXwQQz0MeGrD1x@lucifer>
 <CAJxJ_jhTAS3gbo5AoLPGCUSchUPTsUVzkNVprg9pfzqXFpPEaA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJxJ_jhTAS3gbo5AoLPGCUSchUPTsUVzkNVprg9pfzqXFpPEaA@mail.gmail.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 7825F14000E
X-Stat-Signature: y3ru5t1g3hgwhp7ffacuztc9366hku3e
X-Rspam-User: 
X-HE-Tag: 1780490462-163779
X-HE-Meta: U2FsdGVkX19XjWNeko2mfmTjFoyr74f46Fo8hlv61uHXxF7MtJXRBqC+lNIWMicXpnQKoNZU5Czp0laOOWw6Q+LebHSWRBueyb3b7LBbUvKX92n5xTqVALEJIWRg2MUTpjnc9J3FQqfuVnGlmSbmN5Zo+/xhSF744yebbE9a06QVEeDFMqDpqV12dYms76ZjUe+miW1NvEM4i2f5XTKVRsg859zIU/WVQgO7dtaEb4E1YFn0CNN1dPxmK98wUcub8z3wbIFFjsrTz8LDegVWFzC3+ntDDO5oUnG/po72PyrPeMvp0N7wLh4Ooa0b9jJ4/wUhTvE1OVOtcFTOshsT1Oy2FK9guqyCEgH+GN0i4fjDyzAG6mzC/ref7GpEUl/ECVDIKMy0EO8FEeJhmQwPnlW/8ksMtqKRvPQ8l4UeeqPLCNQ29PRWUfTClKtWEYlZ3he9dgvZkxGYc8NMsfg1hLQxM+JWkIVEyKTf7W3ZXd3LPCuMNoozT9uWYuENOIuEm6qKHuLBRJe5FMBlJj3emvf/aTNh7yNMp10Fscve5DkDtDsXt1S4PlY3krzFMOXdnN05HMZri6HgCJ0K7cZcipwLrYKTYomsalEBW5j6lptJtDXj9zPJLg+QNqAEnD7WZaKZbMzXzgiQajzTrhYrG9u+PwEEnbOneDhMOXtSjWQY6yGGu178iuJwNevRpA2rINsVH2r4qevrwFctIuVVdDDnMVviFFoHdTEHL/scFip77qqB1nqk+eJRCCxQNY49XhYb61pzialPVkJRFAOCT6eqRM5MgcJhPvB7U7N9vrd69qrRHHFPzSyvHOKdLgEpiPvdQ5x/klxu/Sv7OwJ3ANsxfOWJ/jbxbG0pQbxKe2ZuSlt7jcbzvxikZdXnwKhm1ZD630DOaHevdbGCzxEl2Qsy5V951zavefMNKlvDSIUuc6mmEts54sUnqFdCeebF67d1o4dXp68Ig1TzJPM
 ac0YNQO3
 T/guH9+Wj38wEyYvA6P5+zIukBme4OA7ughnapMW3c7pcfJ+XC/ZYsqHMies3hz4SeUYP18Qs0Cjv56fvDe/nVI/owzZ18Zt5k4rUinbmVBJuVAWEzDpfsoPttoSwq+wr3zU/wOMhFjVnsaiTg1kBDtKbsS4d2OPK9AS+0N7/HSogF3pQrRRwb2E4lUejMJb2wdLGONxJhYvPk/D+Z4pn3ZoLlkCeWssGQSZD8KzBhlyLPLH2BJbpisqwj242kGc/Cm7ajXx4lq0pJ3HS74s5TDGz1i7GdPZ1IAeSbqzIB4S/j28=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 03, 2026 at 08:29:44PM +0800, Jianyue Wu wrote:
> On Wed, Jun 3, 2026 at 8:03 PM Lorenzo Stoakes <ljs@kernel.org> wrote:
> >
> > On Wed, Jun 03, 2026 at 06:49:16PM +0800, Baoquan He wrote:
> > > On 06/02/26 at 04:57pm, Matthew Wilcox wrote:
> > > > On Tue, Jun 02, 2026 at 09:01:16AM +0800, Jianyue Wu wrote:
> > > > > Rename mm/swap.c to mm/folio_lru.c so the filename better matches
> > > > > the code's main responsibility.
> > > > >
> > > > > This keeps the implementation split from swap-specific code without
> > > > > changing the published LRU helper interfaces.
> > > >
> > > > At the same time, we have Tal trying to split folio_wait.c out
> > > > of filemap.c.  https://lore.kernel.org/linux-mm/20260520-filemap-split-v1-0-c36ddc2b6cf2@columbia.edu/
> > > >
> > > > I wonder if instead of folio_lru.c and folio_wait.c, we shouldn't simply
> > > > have folio.c.  Tal has 700 lines in his diffstat, you'll have about 1100
> > > > lines, so that's about 1800 llines which seems like a good size.
> > > > There's some functions from mm/util.c that would fit nicely too --
> > > > folio_mapping(), folio_anon_vma(), folio_copy(), flush_dcache_folio()
> > >
> > > I think folio_lru.c and folio_wait.c are better than a single folio.c.
> > >
> > > A single folio.c with all of them would have no clear boundary for what
> > > belongs there and what doesn't. For comparison, page_alloc.c isn't called
> > > page.c (we have files called mm/page*.c).
> >
> > Well page_alloc.c doesn't only contain things that operate on struct page *
> > right?
> >
> > Whereas folio.c is strictly operations literally performed on folios which seems
> > like a good match to me.
> >
> > I find folio_lru.c and folio_wait.c far more difficult to figure out what goes
> > where and there'll be a bunch of miscellaneous stuff all over the place.
> >
> > I vote for folio.c.
> >
> > >
> > > >
> > > > Other people have thoughts?
> > > >
> >
> > Thanks, Lorenzo
>
> Thanks Matthew, Baoquan and Lorenzo for the naming discussion.
>
> I'm posting v4 shortly. It keeps the rename to mm/folio_lru.c so this
> series stays a small cleanup on top of the swap_ops work. A broader
> mm/folio.c (together with Tal's folio_wait split and the util.c
> helpers Matthew mentioned) will be a separate follow-up
> once there is maintainer consensus on the file boundaries.

Agreed! :) Let's get this in first.

>
> Happy to help on that follow-up.

Thanks!

>
> Thanks,
> Best regards,
> Jianyue

Cheers, Lorenzo

