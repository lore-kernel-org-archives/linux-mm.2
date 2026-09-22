Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3F71C982F1
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 11:16:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC76B6B00A6; Tue, 22 Sep 2026 07:16:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E9F1A6B00A7; Tue, 22 Sep 2026 07:16:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB5DD6B00A9; Tue, 22 Sep 2026 07:16:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B62F86B00A6
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 07:16:12 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4AE64140433
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 11:16:12 +0000 (UTC)
X-FDA: 85241144184.22.A37D5E8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 93A3840002
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 11:16:10 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Se83kj0b;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790075770;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EEvm8I6LeSgj4oQnMRC54w4ykScQkevg5Qz+kK3tQrQ=;
	b=DnTeZfRYoxi3IRr2rK9mfi3154LqktNJkVXk1tArXZGWAozhRHWmJDM+XsuvBF+XjxIwXe
	FTu91wdbzVKM+qOtjKv8BktzVKUjEANgbWt/zzDeYEajlc1w43znE+v1d0sXBr4KW8Zi2y
	7kaL83umUa1QjG7JUQhyWoP9J3eIBus=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Se83kj0b;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790075770;
	b=sHyvL01LwsV7uUBUEK65eysGayTldC7Ou4zA/Oz6njF9+awp+4Yafor187wfvc6IZY/yfW
	PHd6X0q3nSxv/EhGhFcRL4PM3fTgWTLVzcVdlytSBl5iXEhBim8ca5MYQm3tsBrDMVglaL
	PK6OKvtEOWoiZp/D5OzJTNfwLcTrAdc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 053CC40200;
	Tue, 22 Sep 2026 11:16:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2C8C1F000FF;
	Tue, 22 Sep 2026 11:16:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790075768;
	bh=EEvm8I6LeSgj4oQnMRC54w4ykScQkevg5Qz+kK3tQrQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Se83kj0bce8Luv8VgaV4OXVt0BG57bNUiY6iy+ogW0PIEouzPLNRjQZWWIp7cIwY9
	 jgrirBqgUjQ9cLp6Ln5o+UhFIwWuktEINx0nxFeVeR1QknrurTWHdvwA41+qItcQ86
	 rtBwUmvga789F3rFSd+49CsMVAhC5i0oFhxMyc06Ar3RApP/2Iy/lu/giWDb327AfI
	 o2nFyWKbp2YxKIYiwvWVe/LzqOt2MyB9xmrtUSoTja/X81fc5HD08cHaG27Jf4v28c
	 rMNkuggNvTYEWxdyvHwkU9MGrhAT06rUkmygYJpNYE98EinXS9XGrP78/L2sC6ra+K
	 RtKeCsXOnsmBA==
Date: Tue, 22 Sep 2026 12:15:58 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Barry Song <baohua@kernel.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, 
	Alexandre Ghiti <alex@ghiti.fr>, akpm@linux-foundation.org, willy@infradead.org, jack@suse.cz, 
	liam@infradead.org, vbabka@kernel.org, jannh@google.com, chrisl@kernel.org, 
	kasong@tencent.com, shikemeng@huaweicloud.com, nphamcs@gmail.com, 
	baoquan.he@linux.dev, youngjun.park@lge.com, qi.zheng@linux.dev, 
	shakeel.butt@linux.dev, axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, 
	hannes@cmpxchg.org, mhocko@kernel.org, yosry@kernel.org, chengming.zhou@linux.dev, 
	kunwu.chan@gmail.com, tz2294@columbia.edu, hch@lst.de, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: madvise: drop MADV_PAGEOUT folios at swap writeback
 completion
Message-ID: <arJi8RRxLM-1JiPV@gremlin>
References: <20260921152449.629486-1-alex@ghiti.fr>
 <70cae945-3a4a-40db-96ac-5ce66a3fa186@kernel.org>
 <CAGsJ_4y8-wD0yMV8GCtCz5MfNrOKqUaTd+UgH=8MoP_nuvPnGg@mail.gmail.com>
 <108487b7-0529-4282-b5f4-355804b4c0cf@kernel.org>
 <CAGsJ_4zGmGh70QtRBpnhueev3qt_bgB4ZiE9fkW-hgNjAVhv+w@mail.gmail.com>
 <arJcPIaqJOzLpkel@gremlin>
 <CAGsJ_4zLY6eZWUufuVqLgEVf93G1JoKtk9ObftkoTwbAimG8Yw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGsJ_4zLY6eZWUufuVqLgEVf93G1JoKtk9ObftkoTwbAimG8Yw@mail.gmail.com>
X-Rspam-User: 
X-Stat-Signature: xymfaj4nrxwn356u51rune4oys79xa1j
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 93A3840002
X-HE-Tag: 1790075770-476849
X-HE-Meta: U2FsdGVkX197ln0WsBb4erQ9j1ky8TRQHUkSRue2oFSR0ym4tNoFUpIms6aEGYhEqkGG96/laB0LZNzchgpZuxByRTfUEpRmzksWFjQx750coeSHufeVImgXFW/etrdsBnXm88qZRqLQAkYfP3qPCTfKLQadhnzLTR+WBz5xutVJx4cgHZXg+8Z86FQObRFtanPEDCF8iQmBemT934tuvb8SEUx7Bnii3A/DE2/AlSAOWWXKiOdnQbFSYFEKZx/rcIlcbol4KGteirnQaMNSbQ+LiiNo4CfKEXQEKknsRQxvwK3A5mI+/ihl/q1XEkuWtW/4xM9OUdeaJ3wXlgSGxxNz9TY7gu9Iqnx5MMQywWTr1P3aZcywZm9t1aknqzBVngVJiovrP/J3tpDUgE8Xuu8GIt+G+p8gpn3WfD5LdcDX4XRerDmkbUY/TV/yd238xWFc/5jGsGKcDmlhrwOndIc0zFmMnPpeLzbubL3tloG0kQHqptSEMEZpjASAqCBM2xZEjpW6mVd6z6QbZ5puvRrXXHoWLvj+kqi8SzbktKP6SZl6JCsrofRIsr7SoFwcoP2Pf9M4xHSOVJ7V147MUfGWXPOXTaD/mptX+QGltvCiRvsyorHUPg52MsqgeqZXspTjTwcYBYcECg7Mb36R2PvD0gClktXCVZt1gGrC0JoxQz6c83NmpwcGsZUr4A8ABdCTR2p8Y8nj19t/OFGCn0fRI9J3Yg9Wrl7nBP/k5pUuVNk+cS4dzVcWMYTsH8pQFWZuyEG0jvZpHu3RgNyt2bj3gZUsOC9SQBMjvO+GgPcFa/s0ZTLD0RpvHQYbZq+h/kSBni+81YratMQpBodURAxCHhRzwY2si69fLU6VgDDt1Tx91UAsR4DULAQylGSIzcPSITQdyf9cOVpyQ4GXfbKpYJfif/tOmsgBT+Uzhmn6iDpMSOxZn8q1zFD8GkPzZK0it+A+7IrlrKRJJLB
 PicKfTTe
 b9T6QyCwwglS+IFxob2pk1nHj8XTPZiGbRkeuls5I/x3ZFyouUaBPKLvnsQvsEa6eub2g6yQfBnaWTzfLI1JJzSs7N+D7i5Ef4fmEkyqQhTWqhYBR/BSgofXgYNjEijSdVVXk68JEZbCVan3nJ1sM/Zx0nEH0+8Faf/7MoeHE3RJPAo54eWhBwmR98TzXv4kcheL1Da9ZYWVEvE6J5JqPQrTF8qXs7lXsnBaoRHOkZ8eHf+qCuvS+1TWXa2zTmF5D7L0yg6yILICv9nmw8kI1wVLPcRmn3VkpZ8tgmLHsBOkW6f0RPZRhVuPLcn2fImdD/w6aatQ3S1keJxh5EuYIMzbznZ+trcZfoJEW5/GpwbYqOyPUPTqQ6zWOHte7T4BC2FV96mYdLUhLSZ5AV3ZQdDBaVKbOUQyMFMOxEMlrO5vbziM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 22, 2026 at 07:10:34PM +0800, Barry Song wrote:
> On Tue, Sep 22, 2026 at 6:47 PM Lorenzo Stoakes (ARM) <ljs@kernel.org> wrote:
> >
> > On Tue, Sep 22, 2026 at 06:37:38PM +0800, Barry Song wrote:
> > > On Tue, Sep 22, 2026 at 6:20 PM David Hildenbrand (Arm)
> > > <david@kernel.org> wrote:
> > > >
> > > > On 9/21/26 23:56, Barry Song wrote:
> > > > > On Mon, Sep 21, 2026 at 11:37 PM David Hildenbrand (Arm)
> > > > > <david@kernel.org> wrote:
> > > > >>
> > > > >> On 9/21/26 17:24, Alexandre Ghiti wrote:
> > > > >>> On an asynchronous swap device MADV_PAGEOUT only marks the folio
> > > > >>> PG_reclaim and rotates it to the tail of the inactive list once its
> > > > >>> writeback completes, so the memory is not actually freed until a later
> > > > >>> reclaim scan removes the by then clean swap cache folio.
> > > > >> But we have the same behavior when just reclaiming memory ordinarily? It's added
> > > > >> to the swapcache and only the next scan actually frees up the memory.
> > > > >>
> > > > >> Wouldn't we memory we reclaim ... just gone, like in the sync case?
> > > > >
> > > > > For synchronous I/O, such as zswap and zram, the memory is released
> > > > > immediately after sync I/O is done.
> > > > >
> > > > > For asynchronous I/O, such as NVMe, the swapcache is currently
> > > > > expected to be rotated back to the tail of the LRU and wait for
> > > > > another scan. Alexandre once mentioned that when he tried handling
> > > > > async I/O the same way as sync I/O—releasing the memory once the I/O
> > > > > completed—he saw some regression. So, delaying the release until a
> > > > > later scan may allow swapcache hits before the folios are eventually
> > > > > reclaimed.
> > > >
> > > > "may", do we have any evidence that this actually is relevant in practice?
> > > >
> > > > We asked to reclaim memory. We wrote the memory out to disk. We unmapped it from
> > > > the page tables. We made the workload the could, access the page immediately
> > > > again suffer already.
> > > >
> > > > We should just evict them as soon as possible to free up memory.
> > >
> > > I suggested this to Alexandre, and he found that it could regress some
> > > workloads [1]. That is why Alexandre is only making the folios
> > > immediately reclaimable for `MADV_PAGEOUT`.
> > >
> > > See Alexandre's description:
> > >
> > > "Future work
> > > -----------
> > > Barry suggested extending this to MADV_PAGEOUT and general reclaim. I
> > > prototyped dropbehind for all reclaimed swap folios and it regressed
> > > sysbench OLTP throughput by ~15% on NVMe swap: dropping the swap cache
> > > immediately turns cheap in-cache refaults into disk reads and collapses
> > > swap readahead clustering. Neither blk-wbt, mq-deadline nor a PG_workingset
> > > gate recovered it. MADV_PAGEOUT alone may still be worth it, since there
> > > userspace has explicitly declared the range cold, but I have not measured
> > > that case in isolation yet."
> > >
> > > [1] https://lore.kernel.org/linux-mm/20260921151306.625134-1-alex@ghiti.fr/
> > >
> > > Best Regards
> > > Barry
> >
> > This patch as-is is just way way way WAY too complicated and fragile IMO.
> >
> > Whatever cases you have found, they need to be fixed somewhere
> > fundamental. All of this feels like a hack.
> >
> > If you're having to write a comment like:
> >
> > /*
> >  * If X is Y, but not if B, and if Z is J but not if the moon's bright at
> >  * night, then maybe we will foo the bar, but only if the baz is blarghed,
> >  * ...
> >  */
> >
> > That usually means you're doing something horribly wrong.
> >
> > And this patch has multiple comments like that.
>
> I'm not quite sure if you've read the context carefully :-) or why
> you're angry with me.
>
> I did suggest that we should reclaim memory immediately after
> writeback completes, both for general memory reclaim and for
> `MADV_PAGEOUT`, while Alexandre was working on zswap dropbehind.
>
> Alexandre then found that this might not be a good idea for generic
> reclaim, but thought it might still be worth trying for `MADV_PAGEOUT`.
> That's why this patch came about.
>
> The discussion between David and me is whether we should do this for
> `MADV_PAGEOUT` only, or also apply the same approach to generic
> reclaim. So far, we haven't even gotten into the code details.
>
> And this is also the first day I've seen the code. I agree that I can
> work with Alexandre to improve the code through review, but please
> keep in mind that this is literally my first day looking at it,
> my respected Lorenzo. :-)

I'm not angry with anybody, I'm saying the patch feels like a (fragile)
hack and the issue needs addressing more fundamentally, echoing David's
suggestion.

I also pointed out that when comments need to be extremely specific about
exactly why you're doing something, that usually means something is wrong.

To expand on that - the reason why is that clearly the logic you are
adjusting is assuming something.

You are violating that assumption, which is why the comment is there.

Generally that means the assumptions are wrong and something more
fundamental needs to be changed.

>
> Best Regards
> Barry

--
Cheers, Lorenzo

