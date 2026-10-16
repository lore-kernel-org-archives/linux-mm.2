Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9700BCCA463
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 03:00:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 377AF6B008C; Thu, 15 Oct 2026 23:00:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 301CB6B0092; Thu, 15 Oct 2026 23:00:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1CA1F6B0095; Thu, 15 Oct 2026 23:00:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D93996B008C
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 23:00:28 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7F667A7B45
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 03:00:27 +0000 (UTC)
X-FDA: 85326986094.26.672A74B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id BA058160008
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 03:00:25 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=dUFq5q6m;
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792119625;
	b=VO/OP/miazeiz9OrsCOcuCb/xiZGV8AfIJC5E8oyi2p9fpYJZbyC5GM5Dudl1qwKHsNaL3
	f6x8+2/0w9uOxhrSQm9QJqSaELKTQe/uwDk7cUOhpA4KkQItQhikgnTQn2Dn2aGRZv/bRb
	NUmNMmsqiReJGoRU2pj5ewFES4PPNX4=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=dUFq5q6m;
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792119625;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9GkQXqNuCXyuXNoJMzMidl3PLgLW9/DoYWi7RsIGJVc=;
	b=Vg1ApXS17rtIh3lny4YMNATTtnHNdmFAJJLZZTEwE8FEQQ0LLBuAFn9KPSztjcUooggrYD
	ThCwqvVilfLsQZobhoBd9tVeF83FNfe2jilPBQB0X1KRDT5k5VAamVBdcOUickh/kzU/Ug
	GSwRcYmjSCETIK3lPMpB/BtfNgkx3EY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 52463600D4;
	Fri, 16 Oct 2026 03:00:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF8741F000C4;
	Fri, 16 Oct 2026 03:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792119624;
	bh=9GkQXqNuCXyuXNoJMzMidl3PLgLW9/DoYWi7RsIGJVc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=dUFq5q6mtNryr/WDRuojfUOLSENM4RFeSK9Dof4XhD7rt9BLpHW2NVYyerHAid1qW
	 UqAymulNpZ+2lPmdD2YgL4iOOQYj7Blv8GicM/+0VG5wPj8QsWuOTEy8vIofhHEvND
	 IX7kVUMEOBi/7tH1fUhEBrQ6b42PralDlPbkmKKA=
Date: Thu, 15 Oct 2026 20:00:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kairui Song <ryncsn@gmail.com>
Cc: Jiayuan Chen <jiayuan.chen@linux.dev>, linux-mm@kvack.org, Jiayuan Chen
 <jiayuan.chen@shopee.com>, Chris Li <chrisl@kernel.org>, Kemeng Shi
 <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He
 <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>, Youngjun Park
 <youngjun.park@lge.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/swap: fix swap_cache_get_folio() returning a folio
 that left the swap cache
Message-Id: <20261015200023.49685b4cba9d514d1f3ac374@linux-foundation.org>
In-Reply-To: <CAMgjq7AGRP3B0UZ9-wJKtz8D-ayivhV0gn2WxsrJ1Q=Qm4TVWQ@mail.gmail.com>
References: <20261015060528.302634-1-jiayuan.chen@linux.dev>
	<20261015184014.715dcdd3a25e18fd4df49e95@linux-foundation.org>
	<b2f925b6-93e6-4b44-bc18-c94a34b381eb@linux.dev>
	<CAMgjq7AGRP3B0UZ9-wJKtz8D-ayivhV0gn2WxsrJ1Q=Qm4TVWQ@mail.gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: psd8tmak459xaupp6fgxzoynqimpnxua
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: BA058160008
X-HE-Tag: 1792119625-302486
X-HE-Meta: U2FsdGVkX18YctDMuyh6voce0vl7mD4kHQleKydfrhNGV1h+76X5CqZlulJmzKrVy0P2piJmEZZni5VPGtLrZ6t0zqi2/BORSeE8MBCcW6bhd0ngURJdZ3wQ9BRS9jxR0fvxywHWfy7PzH0LXYHmWtQlzA2o9N+u95uxdf7/NOSu5n40zb2suVspX02BotU9Fm9qL9yEZC/wJ2Ir0rpBqgoh66rmawkrG4B+2Pme2MdzIHYKes3pow6zaaweaSlEUAEzrkzoYhiROuuqwirhV2C5bqLCebKuRljGM6lfg+e2Y6onXEmucDyH+ES90/Ew0q4vJZ2LFAK0Tr2i0fhds712SbNXpW2NSGLxpCPZzOAqG01COP/tSQ0Ie/ij3DeXndfZRf0cAsveAL/WGt1J9V7LQdEuAiihchyWXTZfnrwJRMvRMy6ZlEjpCI7AaDOSGW6HBRit4C/MZFyqdI2icTkEL43Nk5ch7Mx4mZBbforr1BYm5xqI7Rak/e/kfA1SSjUPoakwqUANZMhxPX+4olczsJiuj3Em4yEYb3VQV0zc+XwXqkIfHR7qh36s20tLK9pJPmt0PFKOJOZxedI5gWuQ2mYqqFsix9tjspKeSilOEJehj0I5jv6KQ3kPWx9n5pioxBtZIiHVSsZ2hTlAmgF6yHrX1D7QumGgE6spTEOGwDpdzmrHSsTLlETNJf8xyzla5lnEwCqNlfxcClQurPQ11DqpdIcCSoJSMGmpxNKHF1SeTDBJU/57gfLw9WNYvoPDB4ndkWu07tw+CoJUEGv0kfhPEzY+SJil8UtFM+bD8sDxA5eAuuRobJ2zou3j0+arP77rZ4ucGzwTZ0DVEvxGyYfq3Ve2h88ZYDKziehookoSEq8nmRxS/slGMH54cEm6v4jKBzqxjVu09rpBB2bcIMbPK0VwnqSYDYt5FXw80w6wz3UW8R2b7j3KkQoj6yu6REHWFFSWwe6rN+N
 f38Strbn
 JRO/Vr9O/JLaINDxJfN058jiIWW3w6eYD+alVuTAk0eM6TVe/s1t3NwzT/Fexh5TClykhx6EUZdi/Hk9ODum5Y2t0hdOBNMpZZljHe1KJozMy9Mv2ZDT+jWRaZuV/45mTVbctPVfgy3IkxGnyPvl+RsSlSVXYUIaos/wsMkHRpYHejmaZz2orubmGVjq9XCz743moN3pvF8VUlb3hC0G2uPSyCPm6VSRU+Os5lwqj94rWNpDfts7G9YzCQDOCha80rt7FaFYLbaVUuoqoiLTnNcTSOia/IO2fHe12eW8sPpSEAbjQmIoCYfZsJdsiJtPSDjoKTKDaY2xWFGOaIBc7AhPt7Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 16 Oct 2026 10:22:20 +0800 Kairui Song <ryncsn@gmail.com> wrote:

> On Fri, Oct 16, 2026 at 10:16 AM Jiayuan Chen <jiayuan.chen@linux.dev> wrote:
> >
> > Hi Andrew,
> >
> > On 10/16/26 9:40 AM, Andrew Morton wrote:
> > > On Thu, 15 Oct 2026 14:05:27 +0800 Jiayuan Chen <jiayuan.chen@linux.dev> wrote:
> > >
> > [...]
> 
> Hi all,
> 
> > >
> > > So CPU 0 writes to a folio it doesn't own: it may clear PG_readahead and
> > > takes the folio lock of someone else's page, before
> > > folio_matches_swap_entry() finds out the folio is not ours.
> > >
> > > Recheck the slot after folio_try_get() and retry if it no longer holds
> > > this folio.
> > > Thanks.
> > >
> > > As always, when fixing a bug please fully describe the worst-case
> > > userspace-visible runtime effects of that bug.
> > >
> > > I asked $LLM for this and was told
> > >
> > > : When the race occurs, a swap fault can acquire a reference to a
> > > : physical page that has been freed and reused for an unrelated purpose,
> > > : potentially by another process.  The fault handler may then clear that
> > > : page's PG_readahead/PG_reclaim flag, wait on or acquire its folio lock,
> > > : and potentially attempt to remove it from an unrelated swap cache.
> > > :
> > > : These operations can interfere with unrelated workloads and may cause
> > > : unexpected stalls, impaired reclaim or writeback, and potentially
> > > : system hangs.  The subsequent swap-entry validation normally prevents
> >
> >
> > I don't see a way to a system hang: the folio lock waiter is woken when
> > the real owner unlocks, so the worst case is a stall. I suggest
> > dropping "and potentially system hangs".

Yes, I think it's assuming the other-owned folio never gets unlocked.

> >
> > Writeback itself is not affected, only the PG_reclaim hint on where to
> > put the folio after writeback. So "impaired reclaim or writeback" ->
> > "impaired reclaim".
> >
> > So I'd suggest:
> >
> >    : When the race occurs, a swap fault can acquire a reference to a
> >    : physical page that has been freed and reused for an unrelated purpose,
> >    : potentially by another process.  The fault handler may then clear that
> >    : page's PG_readahead/PG_reclaim flag, wait on or acquire its folio lock,
> >    : and potentially attempt to remove it from an unrelated swap cache.
> >    :
> >    : These operations can interfere with unrelated workloads and may cause
> >    : unexpected stalls and impaired reclaim.  The subsequent swap-entry
> >    : validation normally prevents the wrong folio from being mapped into
> 
> It's documented that caller always double checks the folio so this
> part is harmless from the aspect of data corruption or crash.

OK, thanks, adjustment made.

> > >> Fixes: 8578e0c00dcf ("mm, swap: use the swap table for the swap cache and switch API")
> > > Given the above, I suggest adding cc:stable.
> > >
> > > Do you and maintainers agree?
> >
> > Agreed for me.
> >
> 
> This is more like a optimization than a bug fix, but it's clean and
> easy to follow, Cc'ing stable is fine to me.

Was that an ack ;)


Here's what I now have:

: swap_cache_get_folio() reads the folio from the swap table and takes a
: reference with folio_try_get(), without any lock.  If the folio is removed
: from the swap cache and freed in between, and its memory gets reused,
: folio_try_get() still succeeds and we return a page that has nothing to do
: with the swap entry:
: 
:   CPU 0                                  CPU 1
:   do_swap_page()
:     swap_cache_get_folio()
:       swp_tb = swap_table_get()
:       folio = swp_tb_to_folio(swp_tb)
:                                          madvise(MADV_DONTNEED)
:                                            zap_nonpresent_ptes()
:                                              swap_put_entries_direct()
:                                                swap_put_entries_cluster()
:                                                  __try_to_reclaim_swap()
:                                                    swap_cache_del_folio()
:                                                    folio_put()   <- freed
:                                          page reused, e.g. as an anon
:                                          folio of another task
:       folio_try_get(folio)               <- succeeds
:       return folio
:     swap_update_readahead()              <- may clear PG_readahead on it
:     folio_lock_or_retry()                <- locks it
:     folio_matches_swap_entry() fails, unlock and put
: 
: filemap_get_entry() does the same lockless lookup for the page cache, and
: after folio_try_get() it rechecks the xarray, because the folio may have
: been freed and reused in between.  swap_cache_get_folio() lost that
: recheck when the swap cache moved to the swap table.
: 
: So CPU 0 writes to a folio it doesn't own: it may clear PG_readahead and
: takes the folio lock of someone else's page, before
: folio_matches_swap_entry() finds out the folio is not ours.
: 
: When the race occurs, a swap fault can acquire a reference to a
: physical page that has been freed and reused for an unrelated purpose,
: potentially by another process.  The fault handler may then clear that
: page's PG_readahead/PG_reclaim flag, wait on or acquire its folio lock,
: and potentially attempt to remove it from an unrelated swap cache.
: 
: These operations can interfere with unrelated workloads and may cause
: unexpected stalls and impaired reclaim.  The subsequent swap-entry
: validation normally prevents the wrong folio from being mapped into the
: faulting process.
: 
: It's documented that caller always double checks the folio so this part
: is harmless from the aspect of data corruption or crash.
: 
: Recheck the slot after folio_try_get() and retry if it no longer holds
: this folio.


