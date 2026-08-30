Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64360C61DD9
	for <linux-mm@archiver.kernel.org>; Sun, 30 Aug 2026 03:34:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 538ED6B0095; Sat, 29 Aug 2026 23:34:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5105A6B0096; Sat, 29 Aug 2026 23:34:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4261D6B0098; Sat, 29 Aug 2026 23:34:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1B3146B0095
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 23:34:20 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 84BCF140223
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 03:34:19 +0000 (UTC)
X-FDA: 85156517838.25.3E6EF5B
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf04.hostedemail.com (Postfix) with ESMTP id 0E00040003
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 03:34:16 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=qtDavoRW;
	spf=pass (imf04.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788060858;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/6O7LuUtWYo+JIUJhcrpLcvGcaxdDNTc+S9TwjcblS8=;
	b=obuKdeaI0PWA3+9PeZRDwZfU3CzhaAy+iA4ohK11hHCJwamTdj/OpKZrN0f3JrcKHmrj3v
	B7HGHt5M6Xkpy/UmvQqe4aQ14IQeBex2V+Hh/0B09XkMMchDFh6GbuCSOFtJwXHoYfIj0J
	0sOx/ySe8Mwk0+LvUuT8nLfYbjl7GN4=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=qtDavoRW;
	spf=pass (imf04.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788060858;
	b=xw++vFz0QNjcYRBtyMJ5m8Lu1pBhQPYWZT4akW+2/BslwNAOLGYkETDvakPpZ/Ck5gKKZ8
	72UudleclkOooDfTCU7f4Op6kA1KNmsZ56PFOWbOxERCeo8g2eqld+S+jc7+mU6wfeZeEX
	c/jI/ivyQDiNdKrQsEf40TlpF5u/f6s=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=/6O7LuUtWYo+JIUJhcrpLcvGcaxdDNTc+S9TwjcblS8=; b=qtDavoRWQNl4/xLDeRUYevI+d5
	tZlZ6wQFdbe8+K+SChbV+LXRGlocEzl2mFjWCjLa++uxI5ApEf3Oaz/DAWWzjjnf4pQNbj7IfbAqL
	dbnJZ7gmvNrBfc1eB1sHMNvIaCJnDu90ESvVPVw/fqOR+Xu9mirNF76RFuujJL1avWZKl8ZdrYp3z
	TBlFAifGPFgdrmbHPVgn4ncGkKnXbn4pDQzPLDVvg5UY48GbhVytwKfbzh4wSbKERASNlI5wvN627
	GsXZbQlLPCsm9JBQe1wZOLW56bgsup0B3aXxbedptXhJZwZ2qg/YHhsFkk1HY8/JBNwmKML2EXDRK
	EoVsrPjQ==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x0WJ7-0000000HYEy-36qH;
	Sun, 30 Aug 2026 03:34:09 +0000
Date: Sun, 30 Aug 2026 04:34:09 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Guilherme Giacomo Simoes <trintaeoitogc@gmail.com>
Cc: akpm@linux-foundation.org, david@kernel.org, harry@kernel.org,
	jannh@google.com, lance.yang@linux.dev, liam@infradead.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, ljs@kernel.org,
	mhocko@suse.com, riel@surriel.com, rppt@kernel.org,
	surenb@google.com,
	syzbot+395b7abe9696862fc188@syzkaller.appspotmail.com,
	vbabka@kernel.org
Subject: Re: [PATCH] mm: fix the race on huge alloc failed
Message-ID: <apOkscUtVMpFqFjM@casper.infradead.org>
References: <apL8kdB0j561wl5G@casper.infradead.org>
 <20260829180234.435064-1-trintaeoitogc@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260829180234.435064-1-trintaeoitogc@gmail.com>
X-Stat-Signature: qr5r4tszazo5okoxzc16eupf15amxbuj
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 0E00040003
X-Rspam-User: 
X-HE-Tag: 1788060856-43131
X-HE-Meta: U2FsdGVkX1/8U8FYru+gQAj8KF2o+8DFIuoXJ9aLptZFfwHo62S6ChaVpWBpkFSN5cMhmgb6HI8jWz46PSS0gIYpWL077RneFNcRdsG3mRSgo6eD8I8/QoFwoZYbDO9Ogirn4ATDn1ZziqxrMMCtuJv/VVBJfubh9o50lSjkT+VFQJDd77yy/e2+zz2y85BYJGpMW8odJDgKcUdSRmcuLEhy97pFB/OkcGCUBWXJXOmSN/VuE5OIVaDQ8geSvhNtByLf2Gh+pyxfeb4GNA9InLsJ+hGG3aGAsvE2cCZaOCUModDqsrBKoY6o+86pQIFB4TP67327X7h9zRsT1AgONkvSXJS28oXkVFgISufi8S5pBrH2qYacti6BxO291BQkYMlnaqz33tBMOfeMA39y7wIDnx4tqzwvP6R/gU8gLwT/1KZpSOjzq0G95PJO38+ROuMScLyQc4c0kp0B/wct1IOCpYds/QMw8lGvVGGVjQWGEsPbimzlM08fn7Ixm/wMlWF4mc8Spp4XefPG7RInfYz/P1TJWfIEjh9O+U2nHb9we3gcz+kkFH/8uJbYKEo/uG4to1rcMhW3piDszrnwq1R8/Yl/uHt4od6U9ru33VmqgxhjlgdgKs9N/urF7f69o737z3fAPtonmZK93AmMnRj8l1mAp/mREHHVfgUm9U4zYxWfVgRRi9+o38M3rV+g7cEk4cvdyDL5I6Jp657catIc51jdGyq/QiesOuNk60SGa3YEVFycJ18FXrrABf02qXi7g+H0TdL8MGIAjWfxzpoSukbwTNuu42wBOl0XDjYb0omHkvRYyrWY0WFc8keDbKMkTGA5Ax6KK4dMTaZKC9YCzWHUMub5MtpFK9UMTjNfUSpj/4g9TpUWVgcq0iu9nBciYZoncIrENtITP76RVu5pP2eMbms1m2FlIxUldm5dhxsDZPb0ln68royOkbqXCfRT4OhLr/FkcCMugXc
 ovTuelW0
 fjZ9rlqG3zJstx0WyXXbQ6vNKTWYfyiGK/5szfKHJXjeZwCjQgxvOxazya0lVtTs2Tq5xf6xrT5sxZRctq29ZKOMwJcpEM+90+QIV0vMbXCFpE/clyDQXXAzFGJggXCsgyYPDWE0HqeULkRI2jySZYP7BRTBE2LsugUDXmxoAq8JGpH659w+30jnS5f/qBnrlyEj6/itXRNLjI9Hgj9yVGBkgfbyXBsTCPE1R9ptd6jmS7Fljs8OCXWD3oZ2oy3YYQOZx4xdm1q8Zpi7o9cBgXiiH6W65RtVOZYjmeJZj1DvfQ4vohPHGLC8d8DCngYSetMW6pYrZJ4SGnJf1WhaP8TU3c0WNr2e4CoaJoWSP/4zK3XtILD0R7WGcXhZLhov0+cmvfNwooulXNjf6FKbrXWR05eRdDDt7yfKLL8QQSwPYzN/2wwejNoCzzilfdtSl8BYDOfKvwqIyLH6vacg8JZd3LQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

First, I hope you're a human being and not just doing what an LLM tells
you, because I'm putting effort into this.  Second, for the same reason,
I hope you stick around and make further contributions.

On Sat, Aug 29, 2026 at 03:02:34PM -0300, Guilherme Giacomo Simoes wrote:
> Matthew Wilcox <willy@infradead.org> wrotes:
> >> Fixes: 164b06f238b9 ("mm: call wp_page_copy() under the VMA lock")
> >
> > what makes you think this is the right commit for fixes?
> Maybe I would should analyzed this better. I only seed the commit that introduce
> this function (and consequently this reader)

That was what I thought, but it's not enough to determine if that's the
start of the problem.  Look, that commit does:

-       if (unlikely(anon_vma_prepare(vma)))
-               goto oom;
+       ret = vmf_anon_prepare(vmf);
+       if (unlikely(ret))
+               goto out;

... and anon_vma_prepare() does:

        if (likely(vma->anon_vma))
                return 0;

so either this race was already present in 164b06f238b9 (and you need to
go back further) or it was actually introduced later (maybe the write
side was introduced later?)

> >> The race occurs because the reader (__vmf_anon_prepare()) checks
> >> `vma->anon->vma` without holding the mmap_lock and withou the
> >> READ_ONCE() macro. Since the writer (__anon_vma_prepare()) is holding the
> >> mmap_lock and updating the pointer, it creates a data race as the two
> >> access are not properly synchronized.
> >
> > also this explanation is bogus.  i don't have time to fix it right now.
> Hmm... I would like to say that the reader (__vmf_anon_prepare) access the same
> data that the writer (__anon_vma_prepare()), lead to a race condition problem.
> 
> When the huge page alloc failed, the asm_exc_page_fault interrupt is fired but
> on the same time the procces that was trying to alloc the huge page, try handle
> to this failed too..
> 
> How READ_ONCE() and WRITE_ONCE() is atomic, the race problem can be resolved.

The important thing to know is that the mmap_lock is a read-write lock.
That means that two readers can be present at the same time.  So this race
can happen when both threads hold the mmap_lock.  I don't know whether
they do in the syzbot reproducer; probably not, but it doesn't matter.

The other important thing is that _we don't care_ what the value of
vma->anon_vma is.  We only care whether it's NULL or not (this is a
sufficiently common case that I wonder whether KCSAN shouldn't special-case
it and decline to monitor it ...)  VMAs are created with a NULL anon_vma,
and then if needed, anon_vma is set.  Once set, it is never changed (uhh
... at least I don't think it is.  Lorenzo, could you check me on this?
I think all the places where we set vma->anon_vma to NULL are in
situations where the VMA is not yet exposed to the page fault handler,
like in the child side of fork()).

So it's inappropriate to use READ_ONCE() / WRITE_ONCE() to "solve"
this problem, because we don't need those semantics.  It's sufficient
to wrap the read side in data_race() to indicate to KCSAN that we know
what we're doing.

Also, as Lance said, I don't see how this is related to huge_page_alloc
failing.  All I see is two threads calling  __vmf_anon_prepare() at the
same time, which I presume is an attempt to COW a hugetlb page.

I don't think it's enough to just add a data_race() to this one read of
vma->anon_vma.  I think it's quite prevalent.  There's probably other
syzbot reports that mention it.

