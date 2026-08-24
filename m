Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E03D5C5DF81
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 21:28:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E22B96B0095; Mon, 24 Aug 2026 17:28:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DABAB6B0096; Mon, 24 Aug 2026 17:28:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C73EF6B0099; Mon, 24 Aug 2026 17:28:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9C2F36B0095
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 17:28:00 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1D39180253
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 21:28:00 +0000 (UTC)
X-FDA: 85137450720.18.AD24A26
Received: from fout-a3-smtp.messagingengine.com (fout-a3-smtp.messagingengine.com [103.168.172.146])
	by imf20.hostedemail.com (Postfix) with ESMTP id 0688F1C0003
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 21:27:57 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=bur.io header.s=fm1 header.b="TmvqfSW/";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="a/bi+feu";
	spf=pass (imf20.hostedemail.com: domain of boris@bur.io designates 103.168.172.146 as permitted sender) smtp.mailfrom=boris@bur.io;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787606878;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eq5n8E8wl0gyQwxvErlBbHpGRNVBAbx8V0rwwpNu/V8=;
	b=N4uoGE0s066s1xazR0Lul6jp0YEQDAR3kyte8ZXmUCfpk4/2ODQfTBcxGp8Dqg613ykMPC
	1Jg1PFeMIM+ZowreYASsP1zCUHPI5pCHjnM6aYvq4CZ5jkcJCeX1DFJj6i4UD7Fqm0l3Nx
	ST5zguAatX7PoTiH41jmgIOkNl7nznQ=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=bur.io header.s=fm1 header.b="TmvqfSW/";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="a/bi+feu";
	spf=pass (imf20.hostedemail.com: domain of boris@bur.io designates 103.168.172.146 as permitted sender) smtp.mailfrom=boris@bur.io;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787606878;
	b=AP14ZXejizohqXuGiv+VArf35XTUbZuW+2evXHtiTi82JdKE4DvcxWK+cW/b1c08zEgRw2
	6b+l62pa3Wz6pKJP3VR0zhBI+NI0fTq54VDJPMBLviYNl/7ifw/Cb42dUa7ElfKhwLod6n
	yJ4GWALNobOYQSkN37+Ck7Qm8TsobCk=
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfout.phl.internal (Postfix) with ESMTP id 6E8C2EC04EF;
	Mon, 24 Aug 2026 17:27:57 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Mon, 24 Aug 2026 17:27:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm1; t=1787606877; x=1787693277; bh=eq5n8E8wl0
	gyQwxvErlBbHpGRNVBAbx8V0rwwpNu/V8=; b=TmvqfSW/oL//OTbI/BVMWYFWHk
	/phtGJrF1nVRL5gPwBv3K7229FmUqy/tRjRWqAnFWOzjfFqv1KcLh4xv3ieFgD/y
	w+WhNksRVEkE5VAwPFuYvJSF9mtt+DCrjPVQZyOIZqhWiry8fDV3SvyZKIB4ORkB
	EGxoKdNjdLQ9klpXMT0oeEhSOxaS1khtpUJyMBeqIIrE27is2tsiZHB4EcFg/7N0
	3MFcHy5fQtETo70wi4czm/m1NHyOaScTMsKGPCp92ry7lsRRFqtQOtNWjR/EINsB
	YAUzybZBbjbJ7hIhOPtVXUzKUZ13q/r377lk6lO4td60zlewwT7B7rv25Ucg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1787606877; x=1787693277; bh=eq5n8E8wl0gyQwxvErlBbHpGRNVBAbx8V0r
	wwpNu/V8=; b=a/bi+feuoThbSSco9FLu3VH6Iq9UAXx/oL5JAglVy2A2deo5f+k
	uP2lwViM4rNHyTnhjOBxGChv+SeAwKvvmokCPEUdrvP3qRXGvQAdo67Ff7ElcyiG
	DbNycu5zorPwKlk/LGXP2zHNm1lUXyiQx083Nv2sNOg/UnmeVU4KMJGHwI/uNAdY
	PtHBq48Mza05cHb/BxjxYMxaEyFHBP6wRRjO+n5ucFDauh30kFskDhQ8QVKCMYtA
	FSPRBaE4AWL76LhDA81T07KjCNBzfBIDUR+uJOR5PwoK9Wf6vukQPjD5DKGCjjt1
	8qEu/1FVo2Nh4aQDezH3VvPjpYeBoAU8TnQ==
X-ME-Sender: <xms:W7eMai3ylPceQrVWY5iXwhlDUp7OC4-aTcn11JjNf2LKXKO2DLZ6Vw>
    <xme:W7eMakrKmSFMhRwYWAwjHZ8FT8e1t6VrnNR0ZLy-2nb_A-cwKzOlo177wgjLZCZOz
    KCI34qLTD7SBbB9jsdFMGO0t_0d4TTf6GzL67PzIgi1mpzN-P0MN1Y>
X-ME-Received: <xmr:W7eMavMw7QQoazijFzrVpA_xt6ttGuHmT2LPaVar_JPdh8kFrDMCsMRdEg5ETMJbZXooksJEyG5kx7zu4c1KW_IajPM>
X-ME-Proxy-Cause: dmFkZTFbQH54V+ttwf82sKhBlgJAGbLwoiQs8PwPHRJwZdDII33T6XgyYMrgg9uI/w+FXC
    eGzpYGS+ehYXdSfGZnBNxeLMbUDJ/Fw58Jr6skYiTZeMFqbzE+rvL9QpDW3N3EoEZuEb8U
    3csuH6q3LC2pPBx53SjdV37SaBmp0ntx7GjHnQkbbF8MELke2xAhZJsy6DqZoC7gMfjsU7
    8r46bKQDYLobOBnnP2Axy7GGNwK46pYe62wph8/B24HvsOg/BXrQqQT2arLkhOVlH+uwFE
    vd6lLBNmx6MqtemmJ0P1cm/i/ve6GPeVzOwSGCrjtYivYstgToBolzn/l2lFhc8ihyyRs2
    CMh1MHG9VrGN+i27vgbNdARFvloSbad/XqQ+r47iE/s2df9gvMhZ17adn06sX5fmyxGsSP
    IjvMqcxYHk09Doeb62DXrikOPbkvku8awlJ/hlz3Yniddkv5CVzgbGJYNUwUB7xbJpqFhT
    lnyYpJEYDR9CnAhQBL+Yh2E5m80Ga4DoJ6p17gWoke5WNXHS9sVhuxWCust7PKXc25Esy7
    xlnTtxhy2dH01DS1ElpMLLZDH3ptpHX0OtK2XJFM3tGebtwSD7+CcoE4VBMEO1awQXb278
    /V9n5/8t0SUFRUNcgEwJJTFsiu9cBlAJE7KsjTMGfY+2SvDOC7uakAEXcfLA
X-ME-Proxy: <xmx:W7eMamWp3E2gQ95wfBsXgHFNJD98xNF4v_FdTcA-Yp1mhujVTh199g>
    <xmx:W7eMaitv_GgGlPnVFnTMTKSQZekGlnGuqY3RBKkdpXlObAxrRY7W3g>
    <xmx:W7eMah0MNcyBWakR4J4OOgrW6LiuUFJEOeTfIHKh5w7GN_Qn4XKLCQ>
    <xmx:W7eMaj7W-pgrd6JZ5SLX28m1Z9ktbCY-UcR_dDOhLmMBcxx7QvRNvQ>
    <xmx:XbeMat-vLWBU2G_LlOobSUYfwkPYFvs8UUntDC2kVSoljJ3K-vj8oIi0>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 24 Aug 2026 17:27:55 -0400 (EDT)
Date: Mon, 24 Aug 2026 14:27:27 -0700
From: Boris Burkov <boris@bur.io>
To: Matthew Wilcox <willy@infradead.org>
Cc: Pedro Falcato <pfalcato@suse.de>, Christoph Hellwig <hch@lst.de>,
	Jann Horn <jannh@google.com>, David Howells <dhowells@redhat.com>,
	John Hubbard <jhubbard@nvidia.com>, Jan Kara <jack@suse.cz>,
	Rik van Riel <riel@surriel.com>, Qu Wenruo <wqu@suse.com>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-btrfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-xfs@vger.kernel.org
Subject: Re: Removing ->dirty_folio
Message-ID: <20260824212727.GA3664690@zen.localdomain>
References: <aoyWln-Gt-yvZQkE@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aoyWln-Gt-yvZQkE@casper.infradead.org>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 0688F1C0003
X-Stat-Signature: mgzm9txryag3b6np9k6z9xud4g6tbx6j
X-Rspam-User: 
X-HE-Tag: 1787606877-301743
X-HE-Meta: U2FsdGVkX18F76Rg+lMaAKzeRdw1r2cAOd9g55/BnKlTqdnr9lbMjeUs+FGXDvN68Wc+/tpWj4XKOdUncT+Dh5dDzKwbQKZB3Tsj5dqRhwihSXIzbIEEzoJsNztyJ88pgobTQAxlDUO6Ax8f95ILMOv/dX+bzZM5cuzGGdmGd0KUDvMNTTwrs8VRNWjxQ2ZHZpMcKbf4RLpOw8ZjOIFqBBzZXQ3wT161ZN2ALV7YQkjTA1LbQ+oh+QuZzylcKFodyalGr5nQNh7A45q5Bkpq5Z/tgWDl0UQrGkAymKMYceQ1qObSo9THWHnUjfM2n7GpjVJB+CgCzdKOtte9FflPAgWDRLGHxdLqhsONvWG16591mFelpQU2yidin8aHheZRVPsk2jtIWVOjL0JaaUP5Z+t1QEc6Gf6fj1cfN1aOTf6E8gXHpBTcINqZC1lmJYsKNyUqZSByNTjtLO7EjzNNGKebglZxS051ygENvpR85oobG/F0JIHVl1yn/ihQrW0XB4Ft04T8U4iE4tnl2efz6AK9pf3oFV3VI4J7CBL5vKIF6h3kN/9qsl2dPOKRFlywzU4cw/QhX6e3TMFUM2kBSxFzrZKtvrC26jgqC0ynllLeQJOJsgnCyMjzmNTe+Ymhb5ZgTngXI2VTdLKvGI8p63FQQsdiLWbTtjOAXtgoVoiwxjofXjYOrbNKgvVisUtfGtFW/ZvjDdVvuc1j3ca7a4q/hBZKIn0/CJuWUu08o9GLMEXjZ/ebSrGs7ZfNmVuYmScULo4M2kk3Y+qLKJTEg4KeZCXEbotqyWe5Q6/fkuz3gERdRoKfxft4f2iww0bWiWtDFq8Zfgw9+Uuf9iKtFrjTXfGb/zBZjOy31DMyHh2Kxy+dQUNb7ozkn5oQLvJUFoer0sHY6zmo0Zzk2gOJTxSEz519CT3Ev3tCuRi0777FEXVM8ixu8ykkIUqqPe6P22KaK9VoZCXIu0LImYa
 hLXCZr+K
 qylyWkizlvcW9eWyuhnljs2Fcgi/QO5Rcmbf/CTMzk/ocmxyxvRTK9e0inMWd6YraIwMSAyezFWUiqCbHueg1byPSK70BRMOhGHl4Ga1UgDg9oz5ZdY+41cS6YrhQiMP2NLnAdDnkyXXvCFOlHIYdBrBpt9bwMeCb69RswOylAcBKQCCuSYkRKzhmjyoxVkuuAi56/nlDwih8O0IJTKQ4Paoj2+9LUfl6jO4+dtSzvVc7EXjbcjm8DD9Q4B7HhrgKjEQtRLpyVF+gkgme08oJyl4E0lfl3tTtxXnJd2fx4VDZNBfdFat+j+xHArZQRg8EOxpzaHO07IiGgR7rxPf3+rx+uU7VTDLmXQi9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 24, 2026 at 08:08:06PM +0100, Matthew Wilcox wrote:
> I think it's time to remove folio_mark_dirty(), ->dirty_folio() and so on.
> 
> This is not how filesystems want to be informed of folio dirtying.
> It was fine for ext2, but anything that's journalled or COW has work
> to do before the folio is made dirty, and it's hard to do that work
> under the page table spinlock (not all callers hold that lock, but the
> filesystem has to be able to handle the cases where it is.
> 
> Filesystems want the page_mkwrite() entry point to be how they find out
> about a folio being dirtied -- and that works great!  Except that we
> can writeback the folio for a number of reasons.  If it's been dirtied
> due to a shared writable mmap, that's fine; we map the folio read-only
> and any subsequent writes will re-enter the page_mkwrite path.

Can you elaborate on this part a bit more? I can't tell if you are
proposing a change or saying the existing behavior is fine if we drop
->dirty_folio(). I am also confused about exactly what sort of folio
dirtying you are referring to. Sorry if I am being obtuse.

When I was recently adding ->dirty_folio() to btrfs, one of the main
cases was the call to folio_mark_dirty() that came via
__iomap_dio_bio_end_io() calling bio_check_pages_dirty() which schedules
bio_dirty_fn(). (i.e., completion of a dio read into a shared mmap)

Is that the case you are referring to here, or are you referring to
someone just modifying a byte they faulted in from a shared mmap? The
latter I would expect to have called page_mkwrite in the fault and done
fs-specific work, so I assume it's the former that you are referring to?

Either way, I do believe that for the dio read endio case pinning is not
involved and btrfs relies on the ->dirty_folio() call, so I think
something would need to be done about that case too.

I believe you saw this patch since it was your idea for us to use
->dirty_folio(), but just for reference for anyone else who didn't see
it, the btrfs patch adding ->dirty_folio():
https://lore.kernel.org/linux-btrfs/69d0043e0f6a3d17048dfde857127ab0bf331154.1785190866.git.boris@bur.io/

Thanks,
Boris

> 
> The problem is GUP.  We have no way to force the GUP caller to go
> through page_mkwrite again.  So instead we make the GUP caller call
> folio_mark_dirty_lock() which many just don't, and generally we get away
> with it.  But it's a bug, and a bad interface.
> 
> There's also the problem that GUP users bypass the folio_wait_stable()
> mechanism.  If a page is written to while somebody is creating a
> checksum over that page, the checksum will be corrupted.  If we want
> to fix this, we have to bounce-buffer the page.  There's no way to
> prevent or delay a GUP user from writing to the page.  Enjoy your RAID.
> 
> My proposal is this:
> 
>  - Fileystems take note of folio_maybe_dma_pinned() during writeback.
>    If it's true, do the writeback, but retain/recreate whatever data
>    structures you need in order to write the folio again; behave as if
>    ->page_mkdirty() had been called again for each page in the folio is
>    marked as dirty.
>  - The MM behaves similarly; we do not clear the writeback flag for
>    folio_maybe_dma_pinned().
> 
> This will have the effect of writing pinned folios back every time the
> inode is scheduled for writeback.  But since we have no idea whether
> the folio is actually dirty (because the GUP user won't tell us),
> this is the correct behaviour.
> 
> I'm probably missing some stuff here.  Let me know.

