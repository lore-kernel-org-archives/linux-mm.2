Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E4E0C531D0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 22:54:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4342F6B0088; Mon, 27 Jul 2026 18:54:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E4776B008A; Mon, 27 Jul 2026 18:54:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B5F66B008C; Mon, 27 Jul 2026 18:54:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F25FA6B0088
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 18:54:00 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 64F07C01A6
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 22:54:00 +0000 (UTC)
X-FDA: 85036061040.29.1A22582
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 0C4E980002
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 22:53:57 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="drUnlP/g";
	spf=pass (imf02.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785192838;
	b=E9Lvdk3EKHYPKca4djfuBqmbWfIS7CDOmAqTDkXXB2xN1t0Gf02LivZK1EGbZrOHyM8Yga
	oOp7ZLLGxDSKOeHgpwe0kUeR7nwitz6qs5N7wWbqYfhJsOV7c/IUi93GWkaRpQVCA/0gO0
	HZYPRCDhYDwvXVF2rYBHi1hfoNtjELM=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="drUnlP/g";
	spf=pass (imf02.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785192838;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gBx1sqPOi/sYxMgcMoA4vUh2Ha5IO4euZ+QG5rwNAXI=;
	b=hBP9dw/kiwuQqNZv42dDro1DrReWajaZO+54tWepYa8OeDXyBJoVIUR047Gonjgu6CWQry
	d3u4UD0GcIp87/CEWzPm39IH/2YMRYnPxSE2dT6PPMU3h8MAQgkBTGoGdCozLuTAXtwErp
	uz7lUYnsBs6XnC5YDC4SwtNuGfI9Gz8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4304B6013A;
	Mon, 27 Jul 2026 22:53:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 830781F000E9;
	Mon, 27 Jul 2026 22:53:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785192837;
	bh=gBx1sqPOi/sYxMgcMoA4vUh2Ha5IO4euZ+QG5rwNAXI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=drUnlP/gTpTNJGf3kSPuQsBGCK6KUDTIbN8ppYNrzSy4mH9fLmZBTM2YFav9YRT7A
	 umgV2laiKooA58w9Td7kAuFj003uCbfsViLfF/Wp7D5bsBXTJj9XKBn+mZzOLmPnju
	 NPUMhrljboSYiUJ+cWnZ8RkXY9ebJit2KojBiuGY=
Date: Mon, 27 Jul 2026 15:53:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>, Pratyush Yadav
 <pratyush@kernel.org>, David Hildenbrand <david@kernel.org>, Pasha Tatashin
 <pasha.tatashin@soleen.com>, Alexander Graf <graf@amazon.com>, Oscar
 Salvador <osalvador@suse.de>, Jason Miu <jasonmiu@google.com>, Jork Loeser
 <jloeser@linux.microsoft.com>, kexec@lists.infradead.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, Muchun Song
 <songmuchun@bytedance.com>
Subject: Re: [PATCH v4 16/21] mm/mm_init: simplify deferred_free_pages()
 migratetype init
Message-Id: <20260727155356.2b2d39657d1154f9400e69ea@linux-foundation.org>
In-Reply-To: <amcuEiLzIunJwZVx@kernel.org>
References: <20260725172133.4018491-1-pratyush@kernel.org>
	<20260725172133.4018491-17-pratyush@kernel.org>
	<amXelr2DcRRyZDY4@kernel.org>
	<20260726202522.e55861cc87fc3e0c6d030e1f@linux-foundation.org>
	<92E24479-07A8-4998-9607-87420A8BE04E@linux.dev>
	<amcuEiLzIunJwZVx@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 0C4E980002
X-Stat-Signature: on99cxuaexz1wexkaqdhqaksy1pqcu8h
X-Rspam-User: 
X-HE-Tag: 1785192837-458527
X-HE-Meta: U2FsdGVkX18rL9sfxEzDnLt+RRTa37ZS/RZpNf+iC5fHiDLbCdUBWL9ravIJZ1oOos5bySjSqnaryiOTZZ/8gH/sOn6bhy0kOYkFUdYcG7ZZAorKJXOK69YG2XQjbVlYV+OyLQlg0MuBMLjElX1UxExyExxBzbcg+ynTYbr8IhCQKKcaebFbAG721libNdQTt+YPLN1rZ8BkujfZayb7R2D+szK/hiXaVVVXnK30iCSm+mU6l8mPAQnPZAasGhnM0/sw5sdBqy3rp3OeRqc5M2ZAj5ttg9AQQ6NOL0KhFE3ERq53IN71e/7PQLXSJOKXjAd4kLF480RiHCntu2uU++ymWX9WV2cjLuUr5fq/KvN4xfYRkA2dj2lPiBh95VI7XCGHSVZ+iTeTeVoFO4H+AV2V1ILsgK2FzYBSR9kJwj/0YIUAd6ApLcntyTPbK7WdoWjx0367TAYcVT50ifSIrv+IFrOShlh3lP+DgpM77j88CEimnfttxNxFqxLxKG5bhzmGLJnRGGsrgVYr8I6RGacaeuE4rrKdhTc2m9hXfvGt2niCI1q5HzMC20Ooz/1FSj4hujqXKwVZcfpiF9HPQrGm61mOJ2gqAtaRA/4pj/W3oMKHE235vwXvZ703sjtLedcd6BU1j0le4Vphthu0dBaugKEvSnIsYGd9xQMZaL8wH8ZAo4okC8Xw9ElHEhEqDtlK6yGlJ+11sgwmUlvMmbFtWrAXnC/lXnbFe3OJyI2CfRfrnfQksBs3TAfMjpO2aBc6tpdoFxvBIekUwwuwy+Q6kMsfkFbL8KZ6ocgPDaU7iHCukqQPFI1wgRY80guy8dLI0FEP7trYifXGfmBIYJgNuohASBga9UPMT70TfvBHt/30IUoh4d9ryNh5GqEJqz8mH3c0Hw+Q6mbgqvtfFVPvI2df0MLhkk4P0tXzFndZWH9ASPGYosDAhxCTEctJ0DI2FkjwcZbIPfsbkwe
 /qAk6JUy
 NKiCxWFNRsNekQGjMqggMjAO7tGla6+T6PHScslsyIkEi3aGujctjvgnS46Puq6e+C5JqkVKQ4eeil6cl7OLy7fWrQExQ+4UExAOyR/pGiWdQHhQ7q+ia9msLu8HHlOBwGR8WxmLJjNUSJSM8bxPst88dTsg5JYCPmeXOaN1M7AEZl9PQwZzvu0j3YDkAZCBwlECXyddupgcSC0Fy1ehz+Yeua62N0eaGdw6ooXsd5OHDooLZaViBZYrXrRGnZz/7nSZNWbUM1cmVqRt16c/YT9vvXqSuX22cxRoJ2H5xuiiE/KJELHx81cf2o1hmCl7ZufxCU4CBFo7pXEMQqyDB23Ao7ZjgDoQc1B1LCQAubiNlyF2B2VJKSyPDaoSTUtHRAmubF7nCwZL+7TbU7IQ5OdJ4Ww==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 27 Jul 2026 13:08:18 +0300 Mike Rapoport <rppt@kernel.org> wrote:

> On Mon, Jul 27, 2026 at 11:43:31AM +0800, Muchun Song wrote:
> > 
> > 
> > > On Jul 27, 2026, at 11:25, Andrew Morton <akpm@linux-foundation.org> wrote:
> > > 
> > > On Sun, 26 Jul 2026 13:16:54 +0300 Mike Rapoport <rppt@kernel.org> wrote:
> > > 
> > >> On Sat, Jul 25, 2026 at 07:21:16PM +0200, Pratyush Yadav wrote:
> > >>> From: Muchun Song <songmuchun@bytedance.com>
> > >>> 
> > >>> deferred_free_pages() open-codes two loops to initialize the pageblock
> > >>> migratetype for a range of pages.
> > >>> 
> > >>> Replace them with pageblock_migratetype_init_range() to remove the
> > >>> duplication and make the code clearer (Note that deferred_free_pages() may
> > >>> be called from atomic context).
> > >>> 
> > >>> Link: https://lore.kernel.org/20260612035903.2468601-6-songmuchun@bytedance.com
> > >>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> > >>> Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> > >>> Acked-by: Oscar Salvador <osalvador@suse.de>
> > >>> Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
> > >>> ---
> > >>> 
> > >>> Notes:
> > >>>    This patch is taken from Muchun's series [0]. The patch as of today is
> > >>>    in mm-unstable.
> > >> 
> > >> @Andrew,
> > >> 
> > >> It looks like it'll take some time for this patch to get into mm-stable so
> > >> we can't base this work on a branch in the mm tree :(
> > > 
> > > I didn't know anyone was using mm-stable :(
> 
> Maybe nobody uses it because it's not really stable? ;-)

Well it's supposed to be.  Rebases are rare.

The larger problem is that it doesn't contain anything until -rc5ish
because we haven't stabilized anything yet!

> > I'd like to confirm that this is a completely independent cleanup patch,
> > so it can be merged on its own.
> 
> That's great, thanks for confirming!
> 
> Then I think the easiest would be to take "mm/mm_init: simplify
> deferred_free_pages() migratetype init" via liveupdate tree.

No probs, I'll drop it when Mark reports the duplicate.

