Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2028CC982C9
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 17:09:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 09AF06B0088; Wed, 16 Sep 2026 13:09:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 04C0B6B008C; Wed, 16 Sep 2026 13:09:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7C836B0092; Wed, 16 Sep 2026 13:09:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C19226B0088
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 13:09:30 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5129D160783
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 17:09:30 +0000 (UTC)
X-FDA: 85220261700.27.9206F3D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 5E9834000B
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 17:09:28 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LWqerj0a;
	spf=pass (imf17.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789578568;
	b=fNo4+0GmYXPPrGIGpOIQwhknNEdkwrmV6wf0d9ali1WIaEHDohTzMKc7jAf4t7UHwsrBE2
	Uap5+IYZUCfizdUGSBOsvo90wVwmEGiuNm+7P/IYyd9k2hzJFGcG5WN0KGEhRgy2YYLIX+
	ECbLqKNIwMIsB0/Y55Pn8qzVZWqrkfQ=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LWqerj0a;
	spf=pass (imf17.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789578568;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EYIPtNMDNyQ/6WY1hk2JBEVGtLHLfjG619n8HAgX2tw=;
	b=B+PlowtIAMHwm6N4PAi+3QUxvn9+Oyy6MmgIE+Ylz7tqEjzvfOq/fX5ayoOFmzSLONJBJ4
	gnhOB00QnDdMvHYV7IekPljlGdcJs73x5ttZ03dqmsvfp0s8zJ01FNGZFcmjqCqZsEMN7G
	S2uZMNm21QqvEDeqM50IkR2FENN1SEQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A576A602C5;
	Wed, 16 Sep 2026 17:09:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B33741F00898;
	Wed, 16 Sep 2026 17:09:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789578567;
	bh=EYIPtNMDNyQ/6WY1hk2JBEVGtLHLfjG619n8HAgX2tw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=LWqerj0asUBl5mtWNWo7n/nykCqCU502c2DJydmt2eMm7kzsEvMm9nPaKCKnYxFle
	 PtJ4nQtsfIWJrDtrDFpS4Ro3cO7+E5Fo7fC8y+ZE08Li+lRcdurVqgRlxM41vlWpvH
	 cPFaiYckAIS3XUTkkwbCtKT5yzSJ0NY15pBcj2+2sZVOK4jJmWZqJQwXpWUKBouDjU
	 VborlYuABqOtgaJHC4/qx6LFR/W6ZJAk+SXmbugszPA5iXmBsKbQslwn32WDORnPt0
	 q9Fhq5vhndQDxsJfruuRYAWGkZu+moIPwHBUWk5lffpo36mq4f0+8Ghe3NzOOOCcYJ
	 cFCxxhMTRfWWA==
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfauth.ams.internal (Postfix) with ESMTP id 37F4F198003A;
	Wed, 16 Sep 2026 13:09:20 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Wed, 16 Sep 2026 13:09:24 -0400
X-ME-Sender: <xms:P82qaiwtHNsjl1hytDOaqAe2_6EnrUrcXt0YfqaFCHBsC1kn_e4gAw>
    <xme:P82qavHnQFv0mIWxMbXrNw6e8CuhjHis_cEvFycaQtXEPGUBUZOZG0Nowg2VtLybu
    XKviAE09c-CjE4SKlyODnQZNoS8yGD-pLu1VLsUt1Cbqhw279yV4rZc>
X-ME-Received: <xmr:P82qai6IeaGYtne0hJP-GQQZwYeGGBBW7KK-J8g6wGh258to265jQr29PBk>
X-ME-Proxy-Cause: dmFkZTFV2UCcZr2GlXxYscRnpO5twby6pXhiHVdxeWgqRFx4KTYs3c1z/LJtw2pl3bmLGT
    SjKcaugx9MWXu+xOcXXwd3VtNepswxZmDVEUvi4lQHUKvURxNnarwj9loY6NXKq6Cmax9y
    wvcU8EkW3DVn16heKoIFJ9UsUjMtAoXK96bkebfHJeZRVjxqjgNOj5/kPQYwVdE6TQ023p
    CCMxllIHDMNupE3Ac77/LjqyVd4CZI78dRY4ZeB+OTMw0dQ5oQfzfZU3NzQDR3P7wW0c4C
    MR6zFt8bbwxRh8gyLQ4m2aFbkZWXqUilZTaeerE8U5TZFrY9Tu74f8LWMkHwlcVPKSEYI2
    ELt8rO+LmPoGRacMpaFK8VJNEhSga/OemsP/etzQg1NA43uDvwJZ0Q2iamr6+cOrrJOhhZ
    Ob/D4EoB7s9eGmNKK9Wz6Ql53fVTRhZz9hsfNDrz/iRxFYhzq1Oet95QNfTfSTAx8qRS12
    XoveBvdLrXUqsJgzaNLg5Xp6q9CDIweabgLMlRM8sT2kuNZr1P11u9NUfzslS40hwlG4mM
    BBJQCOEnxSthIZ6iy2lRp+l50IFyD/wYYuipel/bc7f2gdEIMGPIcUiJ0nRIi3ODY3yYAB
    l0dUjaHDx59hhDtjphJgpyQSHZMQNDMPfPiHlFmeY+TovoCEGh26+KFTIK+g
X-ME-Proxy: <xmx:P82qauV7CdE5fVc-RlAU-sFYarVXpHS9ezru3zj4s_TpDtcO4BmE0w>
    <xmx:P82qavJfqmCsNrsZp8GNVrYoFUI_uoM5FdBIHd_xHZAV57bSfl6d6Q>
    <xmx:P82qauQ2vQD3aUgol4h2WHHUmis3y1dwQGiZabPW3M1vGPioub3tXQ>
    <xmx:P82qaiBnhXmiTuoavJ0sd348dWGmzObwLtYoGHBva5EB2kMbIk800w>
    <xmx:P82qak-gvAifzihzhevXQjss8iKtVSzDLmJGWJhmOTU4yAarpr4l6OnL>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 16 Sep 2026 13:09:18 -0400 (EDT)
Date: Wed, 16 Sep 2026 18:09:17 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: akpm@linux-foundation.org, David Hildenbrand <david@kernel.org>, 
	Boris Burkov <boris@bur.io>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Jan Kara <jack@suse.cz>, Rik van Riel <riel@surriel.com>, 
	Harry Yoo <harry@kernel.org>, Lance Yang <lance.yang@linux.dev>, Jann Horn <jannh@google.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	"Darrick J. Wong" <djwong@kernel.org>, Carlos Maiolino <cem@kernel.org>, 
	Usama Arif <usama.arif@linux.dev>, Pedro Falcato <pfalcato@suse.de>, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kernel-team@meta.com
Subject: Re: [RFC PATCH 0/5] mm: sub-folio dirty tracking for PTE-mapped mmap
 writes
Message-ID: <aqrJAX6nMTIo6Vnn@thinkstation>
References: <20260903182943.662461-1-kirill@shutemov.name>
 <ap6LFvuOuWf_BkGi@thinkstation>
 <aqrDfoFFr8o0Mf0G@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqrDfoFFr8o0Mf0G@casper.infradead.org>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5E9834000B
X-Stat-Signature: mt98wypewajyhqw5mob66e38najyic7s
X-HE-Tag: 1789578568-377236
X-HE-Meta: U2FsdGVkX1/zm4CkuzbN42vtmH3NOFoFxfJRL4fVy4JpSTX39ptzrrdL+xdO0S7/X2ORc5igbYNQnvdInjnqSxauUmt/UaIJrJiAPvjixPdy0MXtuhkxGqHpxhNP9WYCamKxvTuWlYvBoqWRUqnwtuc/5+0ZgVJgrbS3dxl1561UOEUa3kY7XFuiz7+v9lumR7YhF7PpNg7SbuZE1HsvgDvB+mEagCQ4OqVl/Wt5D9ntUwQgc7WyrzeygUqOVPCKAcP85pgY06lA+xbP1u4errnHthg5iPXXtASMRAIPrzw6Xdme7TjY/9VlvnGpoFc4gp52GyB/M0LgAbAVNAdnoQt+H/Xr8cUZX/R1A195VBimRNQB+1LVBKuijrCCTT3gsXBpdR9ZunK9yuk2Wg/Q5WanosuU0gaoNSfJcN6wVN/RNtlVkrtiQxLuDanAkmatRPPzAwc6MLdwxfepcHJCK6oGYhyxXnkGUAnd1ngN0i/oy/eUDCWvDHvJvXfB4uVA6jk0JCeObOCrx5vy//oxMEjWzJl2H8uwKCW7TOYimzQPbmdLhTa6xhBlUfBIrV8swtXhhu+GrtyjaZk1z4/2QDvzEVzcbq62VZ17eaAYYNHKxMXEbzqZOED2KmNOL1k/eJErWyi8Un32UDAjsfDYDO6hUW3vzQZ2+9pwgjt3xX84YbKJaW+mSXmQ/t5QT+IFt+T6c7kEOjeuzwhb+McffyJ77fBbYNgbvgAYJJMcJJQEmaNb0cTyd4iLHuuDO+Jt6BRkNl441m+/2pNGH/Jnxj1ybTuk0fVV4QSgcbuoBytwNp4Xw3nLTJvdb9qxhwKoXRrC1hU/2oXECcwtU+mCzJqsaKyMDTWM+hfZqERT8kYkq7lr3cVVjJOOVJ+ejxNTdb9JPLe4R1PHN0Ot6etpmBukdbAHpEV/8xmHwd71S4430+V2yHS5EZqqs43Sb4saxLnytiQm+SIbaXlBIpz
 Wl98Syp2
 CRj/PP3b8t42ip1cppGmuKUFxGZ7UGHu4pazijmm/89/8mv7ZXYyPsyuQlX8Kw86RBnqL+maRlnou5pnIuyxAT6qUdZPOZnsTs2NYFmfnYzyI9xd3AGFLcv1nuwLaoJPuzag+LuG1sdb9Y6vNldbeIK14KS0kO9ctbYKXj56NvGfgOEHCj7+d5/73I67kFOmg2DD0cfOkbi0K3tYz90NJ/xpW8Wnug2KID0qvCZbf6feiLbjh63WNmz5dreBfPlFU7XqYcLYYiW+4HxPYxMQmdT+3U8jIEmXvp4Fa0Zhd9z6BKF+ZCi9y1H4RYlV4VO6PdS8SXOm+NzLuX2ffjaKL0HVXoi0Xxydh/miEU8EPVHb0MBZjW8qhkxZvYubnSyBvaLuaO7LSwfD38d6Rml9LldM8tw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 16, 2026 at 05:27:42PM +0100, Matthew Wilcox wrote:
> On Mon, Sep 07, 2026 at 11:15:15AM +0100, Kiryl Shutsemau wrote:
> > Boris pointed me to Matthew's proposal to remove ->dirty_folio:
> > 
> > https://lore.kernel.org/all/aoyWln-Gt-yvZQkE@casper.infradead.org
> 
> Thanks, Boris ;-)
> 
> > I agree that the current ->dirty_folio() makes little sense and that
> > dirtying the folio can be bundled into ->page_mkwrite(), as they are
> > matched 1-to-1.
> > 
> > My proposal makes the distinction between making the folio writable and
> > making it dirty meaningful. ->page_mkwrite() allocates whatever is needed
> > on the filesystem side to track dirty state and drive writeback for the
> > *folio*, while ->dirty_folio_range() marks part of the folio dirty.
> 
> Why do you think that's a meaningful distinction?  We create a writable
> PTE because we've taken a page fault for write.  There's probably a few
> naoseconds where the PTE is writable+clean before it becomes
> writable+dirty, but even then sometimes we do both pte_mkwrite() and
> pte_mkdirty() as an optimisation in the write fault path.

This is true for the PTE that the fault was for. But we don't necessarily
want to dirty the other 511 pages at the same time.

The basic idea is to make the whole folio writable at fault and shift
dirtying to be per-PTE on write to it.

> > We can still drop ->dirty_folio(). A filesystem can provide
> > ->dirty_folio_range() if it wants fine-grained (sub-folio) dirty
> > tracking.
> > 
> > A separate question is whether we want to avoid installing a writable PMD
> > entry for filesystems that want fine-grained dirty tracking. I have a
> > patch for this, but it deserves a separate discussion once we agree that we
> > want this for PTE-mapped folios first.
> > 
> > Any feedback?
> 
> It's very odd to be optimising for shared-writable-mmap.  This is a
> horrid model for I/O.  https://cs.brown.edu/people/acrotty/pubs/p13-crotty.pdf

Sure.

But not everybody got the memo[1] :P

I think it worth considering if we want to make large folio adoption
smoother.

[1] https://www.reddit.com/r/bcachefs/comments/1vepk4a/comment/p1sn4v1/

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

