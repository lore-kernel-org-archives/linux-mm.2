Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B40FC61DD6
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 16:45:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E29A6B0088; Wed,  2 Sep 2026 12:45:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8BA376B00A1; Wed,  2 Sep 2026 12:45:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F7EF6B00A3; Wed,  2 Sep 2026 12:45:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5CC1B6B0088
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 12:45:54 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E079CC028D
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 16:45:53 +0000 (UTC)
X-FDA: 85169398986.17.187C37F
Received: from mta1.migadu.com (out-19.mta1.migadu.com [95.215.58.19])
	by imf08.hostedemail.com (Postfix) with ESMTP id 394A6160006
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 16:45:49 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=EzK0NrID;
	spf=pass (imf08.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.19 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788367552;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I5BIySFcfVau43GZvdffl6exV+9pdr5CG3WM35GfPus=;
	b=q7ioW/juXzXSxJTcWBO5FYItPQQ8gKstefC3S5bj5iwLDihlvl2ZNTC4mXPPOyQsUGiNPh
	fKHYvxA+UZnlOI/K6JH2YXeBays+oMWBa/1S37U+IiKULGcc3oYWPd3WXkrpDES1ASTIP5
	f3t9Bdcpa5czc9oxcm/KKo3FaWckU/w=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788367552;
	b=twOG1d+qvqkMf99IMQvCnrVt9dZPbAFyDjuV6z+sdmIkTDZJMImAgvOBiUU0PjQatg6OM/
	62wOUnr8gE9+sNNcsgwrzuhl14KWOp4UFuFV9e6v6n788s+AmD8mu02rap+Dno6vhDMZTe
	OM25k94sTpJjPerjHA6L6Mh2n6I5gjE=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=EzK0NrID;
	spf=pass (imf08.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.19 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=eBbY4iMBTmEAonlduKED6Icf9+LbGVlV12xAIrCk42s=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788367548; v=1; x=1788972348;
 b=EzK0NrIDej/JH7z8uxUn4qy2Z9j2Ozo5h3VjpfOv0oek/exCtwG55atrJvO9DYZzl5iaLYZW
 QzY6hZGmQfNavtJh5Qh9HjU8piCnG3OeRdAs6XwmiIE0WGW6CmPHCpebabDMO+q+pFY8CkGXOdF
 dM4PbO4TLeW522m5zDDvu/RI=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 7a7ca504685ebf88;
	Wed, 02 Sep 2026 16:45:48 +0000
X-Mizu-Trace-ID: 7a7ca504685ebf88
X-Migadu-Flow: FLOW_OUT
Date: Wed, 2 Sep 2026 09:45:43 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Hugh Dickins <hughd@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Vlastimil Babka <vbabka@kernel.org>, "Liam R . Howlett" <liam@infradead.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Matthew Wilcox <willy@infradead.org>, Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] mm/mlock: use the IRQ-safe accessor for NR_MLOCK in
 __munlock_folio()
Message-ID: <aphSajBg4a-e-Iyv@linux.dev>
References: <20260901180109.3797944-1-shakeel.butt@linux.dev>
 <1ddfa7dc-2dd8-406d-8454-59a349972106@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1ddfa7dc-2dd8-406d-8454-59a349972106@google.com>
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 394A6160006
X-Stat-Signature: 8knf4bxgtg6p31upw4g36ggrfa9ioki7
X-HE-Tag: 1788367549-440705
X-HE-Meta: U2FsdGVkX18FR5PFCwKQc0BT/zDjlt7KVQqZRHPx7OPTpuEnOxBE6L+uWk6dl/Xd+bugkLL4k9opUW76KxX6EbYJyw6uNrSobaxRNQxY4USJb8f8Opbach+VD8JoYCFlIUUHVKskVmPcuEQAO67lassWd6SO1tgBoJomOoWhXSSezc7GLgczGDj99kVpBfcPT83VfH/7iyrIWAoqpAT1D6hrqupCMOK0zOy0Kv82adPpVH4qOQ5MF2BXHSPxY1dl44CkQbFI5Lq+VCblNKWqyhokQI7bF2kr1eC0StFOszRebqpa+dpWYXQ1wpUXacnlkqfpzY4VFjvbWltjRNLoROsz8EAses/KvBiXoGthWnMbKklxorB0izDCYmRzoYjHv/KX97LYFSKEDl9GM4TF85QoQtVJDdF8WG7F8GrxIBJ22RykzAtgC6TMpOYIvxniC4gw4h1T78itFHdNIg1LQsKILwJMM98g5S0qQGeN3xUxeHeJfSlkSlV70P+TvNgVzmJVB0Jf2wtOgqz+kN9zs0W7arLV1om/RIntx4220WUFEDY+znhBbsTi3yTGOrtWfuC4GBS12B4K88HbExt57k34yJJVJcunkeS9ZELjNrvYADelBWfmaPz0jFnxiFAVZ+vtTQc3G7Id9yTpcOuewYuYW7eW1Pwo58aY0soIstX0XTkckw+7OSiFFlBR+a+1TyzZgeL5B7uHZSqDhU5mP9G8eJTDHYeS0V1UjmXTCWbsIVwxtyhpQTvmRY38EAtnEyLdZPvrLnW13otxNAiwed60pQveJTGMQv9027t2R2HyTSrJKsPoaNrBZp7qx+bG60O4T8HTreAn1PY1xdjnkYr7dHjq5D1hRTk2l30zkeaGPW6j/nEaHjS1rqu1r88oWfXy+qk5JrZi+uVN7i4yRVd3MCibzutvI5BFFMbnEWj2lBBIYPsh5kDSblnAllca6LELTnjM7G/RXn2m4PS
 xkCTSk9Q
 KG2lYoCj/hLB2rEpDqI7377+zOdhIcN44lcdi9C4P+wQOeDCtGa1rCoVA0H9Itr1aVBafFDB+7mBst7CeeRE0gqMIJYRjaTQjmC0WiGomGg4Dvf0/oYXFv0PBtMPbBb80LPHV3rl0R4mLhs387N+Rbh9e3SLE4Bl7rNorw7JhPSUwH8WZzzs82z/tor3vXUcjBokDdzG6d/NvUy82Rw8xOVGEYJTl01g7MLkrYPEJvIqShtylhqshH73DXMIg3OrpbfPlN9r0/x6YOUZM5ag9d/BsCbaVmw674FQ1FriqiFmn9Z1YrQCocLzByJZsSoZucH6R06HVPy7cvOijHtangJO7BYhmpaK0mnOp55Qs2jQbBaDl+3Er89nV4LCtvnAQkAdoCbw5RyKQA6cOq8MgN49CaPTHyWHy1sF2p+TL688RUtI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 01, 2026 at 06:27:06PM -0700, Hugh Dickins wrote:
> On Tue, 1 Sep 2026, Shakeel Butt wrote:
> 
> > NR_MLOCK is updated from interrupt context.  __free_pages_prepare() clears
> > a stray PG_mlocked and adjusts NR_MLOCK, and a folio can reach it with the
> > flag still set from a bio completion handler:
> > 
> >   __free_pages_ok+0x6af/0x7a0
> >   <IRQ>
> >   __bio_release_pages+0xde/0x260
> >   __iomap_dio_bio_end_io+0x16e/0x1a0
> >   blk_update_request+0x14b/0x3d0
> >   blk_mq_end_request+0x18/0x30
> >   blk_done_softirq+0x49/0x60
> > 
> > The folio gets there like this.  A MAP_SHARED file mapping is mlocked, so
> > its page cache folios carry PG_mlocked, and an O_DIRECT write sourced from
> > that mapping GUP-pins those same folios.  munlock() then runs
> > mlock_vma_pages_range(), which clears VM_LOCKED before walking the page
> > tables to munlock each folio.  A concurrent hole punch reaches the folio
> > through the rmap (i_mmap_rwsem, not mmap_lock) and can land inside that
> > window: __folio_remove_rmap() -> munlock_vma_folio() sees VM_LOCKED
> > already clear, so it neither queues the folio on the mlock batch nor takes
> > a reference, and the pte it clears makes the pending mlock_pte_range()
> > walk skip the folio at its !pte_present() check.  filemap_remove_folio()
> > then drops the page cache reference, leaving the bio's pin as the last
> > one, released from the completion handler above.
> 
> I'm hardly ashamed to admit that I've not tried to digest
> that paragraph. You're writing about the rare fallback cases when
> PG_mlocked is cleared late, and unevictable_pgs_cleared incremented to
> notify us of that defect: yes, I accept that might happen at interrupt
> time, and so we ought not to take the __shortcut in __munlock_folio()
> which you fix  below.
> 
> > 
> > So __zone_stat_mod_folio() here needs interrupts disabled, not merely
> > preemption, and __munlock_folio() has a path where they are not: when the
> > folio has already been taken off the LRU by somebody else the function
> > jumps straight to the counter update without taking the lruvec lock.  The
> > read-modify-write of the per-CPU NR_MLOCK diff can then be interrupted by
> > the softirq above, and one of the two decrements is lost, leaving Mlocked
> > in /proc/meminfo permanently overstated.
> > 
> > Use zone_stat_mod_folio().  mod_zone_state()'s this_cpu_try_cmpxchg() is
> > atomic against a same-CPU interrupt and retries, and on the path where the
> > lruvec lock is held its cost is negligible next to the lock itself.
> > 
> > The UNEVICTABLE_PG* events are deliberately left on the __ accessors:
> > they occupy different vm_event_states slots from the UNEVICTABLE_PGCLEARED
> > that __free_pages_prepare() bumps, and nothing updates those two from
> > interrupt context.
> > 
> > Fixes: 2fbb0c10d1e8 ("mm/munlock: mlock_page() munlock_page() batch by pagevec")
> > Cc: <stable@vger.kernel.org>
> 
> Okay: just a wrong stat, but it ought to go back to 0, so Cc stable yes.
> 
> > Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
> 
> Acked-by: Hugh Dickins <hughd@google.com>
> 
> But I do think you (or Andrew :-) should include
> 
> Reported-by: syzbot+cd2073ee6d958a8d0fcd@syzkaller.appspotmail.com
> Closes: https://lore.kernel.org/linux-mm/6a931c5a.08e933ee.dbf97.0093.GAE@google.com/
> 
> That was indeed reporting a different way to get a WARNING from this,
> when offlining a CPU: but it should be acknowledged for bringing you
> here, and we should tell syzbot it's fixed by this.
> 
> I've been trying to work out whether you're going to come back in a
> day or two, changing the __count_vm_events() too: and had raised in
> that thread the question of why lru_add_drain()'s __count_vm_events
> were not also reported by syzbot; but now I can see
>  * vm counters are allowed to be racy. Use raw_cpu_ops to avoid the
>  * local_irq_disable overhead.
> and realize that they're not a problem; so this looks complete, we
> shouldn't need local_lock()ing in mlock_drain_remote() after all.
> 

Thanks a lot Hugh for taking a look and Andrew has already added the syzbot
tags.


