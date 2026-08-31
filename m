Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EDCBBC61DD3
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 20:12:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C83906B0088; Mon, 31 Aug 2026 16:12:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C342E6B008A; Mon, 31 Aug 2026 16:12:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B226F6B008C; Mon, 31 Aug 2026 16:12:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 722936B0088
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 16:12:09 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 574F3140235
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 20:12:07 +0000 (UTC)
X-FDA: 85162661094.05.CB8B58E
Received: from mta0.migadu.com (out-148.mta0.migadu.com [91.218.175.148])
	by imf06.hostedemail.com (Postfix) with ESMTP id 27B7618000B
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 20:12:04 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VEODYCcv;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf06.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.148 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788207125;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ERndITL89h+GYiI6vyzgJACUUCx8XqZQpXd5qj7QXs0=;
	b=GQk72a87MUzKbDupBy8y3UCPKZRbekcTZv1HZrARaG2hHV+S52nJA49GKyJ/vvl3nK6HVm
	MSNaQgHUsi++j/1AnbfFCzjvcZewvWTGLNYROPNhVtyGAMRMmWWL48dLOB05Up445e/36F
	eMxzkFIaFj/yaHOaD65H+pfo0sJNQgM=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VEODYCcv;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf06.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.148 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788207125;
	b=AfF2KUk3MEb93rOHQGEBU73Tqvo+vkHLd34R7pBMozsOZCNQXC9xK1DX6nZxnVqR+cPKtu
	eLGmjKhWkgem0uq9wMQBGTueGJYEMZLGUtHfX4LEV5eeG4dMb8DQoKF+Ol9fMCGhRc6Qs/
	p1uMLbj7m7B7YhZtTUwFcIz5dY3FPUI=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=pO9WzaMlnDtRmhi6xRUcfdA0+B48EsQ07ONaGw0vVg4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788207123; v=1; x=1788811923;
 b=VEODYCcvAXYWoy5wUYNUNbRzFlGkwO+e+9TRLpRXQBdIbV841TFiyNG1BmlRbc6tX9py23gh
 YnbLcTVpqo4IESupSFIMGJ+rtou4Xv+K6XZq6GlNvcyT4i1+/WIErpnXm/b89mIbwkIp9Q1sktm
 KTJn15nwxQolIUm7HcKeZJaY=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 26b7e198d83c3824;
	Mon, 31 Aug 2026 20:11:53 +0000
X-Mizu-Trace-ID: 26b7e198d83c3824
X-Migadu-Flow: FLOW_OUT
Date: Mon, 31 Aug 2026 13:11:52 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Hugh Dickins <hughd@google.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
	syzbot <syzbot+cd2073ee6d958a8d0fcd@syzkaller.appspotmail.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [mm?] WARNING in __mod_zone_page_state
Message-ID: <apXJaU38jQaLr3aO@linux.dev>
References: <6a931c5a.08e933ee.dbf97.0093.GAE@google.com>
 <apNjw0HRyr1Oj7q4@linux.dev>
 <apOAF5CPFWUUH9du@linux.dev>
 <a2288e73-5001-2104-1e7a-2b383e7edd61@google.com>
 <apO7GDwIgyhdn3t7@linux.dev>
 <4793259a-00da-ea31-8cbd-a6cb5bf48692@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4793259a-00da-ea31-8cbd-a6cb5bf48692@google.com>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 27B7618000B
X-Stat-Signature: wimnamzpsi9hkk4s6wy7jgge3nu5cdr5
X-Rspam-User: 
X-HE-Tag: 1788207124-781187
X-HE-Meta: U2FsdGVkX1/bRSjyXR6UGgFs1DqualDbGzZnnHyUgGC230dTRQQGN3VKbXUKRpTybOfp1bBx8zdKksBq9vEiaG2dimJ6iLphSQdrM4PRd+6QXpr1ZJ1bWS+BK7nywd5XEzpJ+/e4UWIlxp/39ABrtiAe9jpqfOnwQKkbjaz+mQmOMk4XOslyvtl/ACmkBhH7TritUtSQToApsUPcg8VsIs+8zbBsFCyNPwrx3U1B+tq+7GsbTsVaaIdQqvLWF4M51JAz6OyAELWiK9oE41WFc9gFSIZv6CnzrbctsLFsRO0JXV58pe4CSHbAkZ4+B2mRYpFs2T/551g1jLdSFLn/SrIv8FkapMUKucQb8aSprYHU1U7d4bGYwVRfeTtHSKpBW1qjZ68WouEavwHnxM+DsmAM3x8FIIiLCVbTwIRml3N+CvfR9QqnVU9RPbsSnUG3jBgkILxirfWy6tjd7fJiigJwM7vtB+504j85qpyNQ6R5Lft8JUr2teygfnYDIKFdcztJhNc43JI1FQ5Nv5MyFuxXSKNrkEdFeW/Zacy25NjV/QSf0gd6+FzwnSQNhiBvYhlivN/Wf7B7Cw/8vk8xGVAV7TTYPzo4lPfB7lGLbLBPY8R3CMx6xYkA430j43pTITJvIXbLULz9a8dbcLe2jQezoSzZwT+Y0WaK2sIXWm01LJKiQrk6NWijgAln6bhleTm4GEWVm/SiHrcvAwMCxAhr8G03AHCw9LrjB4u7IloOQefuDOwKVUhMZy4ekuMR2nsU8NVfI6OuHbDrmkE1CXtUTeHR2KuobaRyjlFj7SQC3u5jx1fd3IfmjUZkDpLrZIFzumk52pMQ9bO7pZlluvRaOb0z+meW0sQ2BfK3i5vgYLEe/sEPmXFn+vPC2oE0yxa+w8YauXZe2qh5c8Aae9nqzsZ+SgGqWP9VHYD3bhSeXRVyxEj1i8JPGQKV6+VxSsMA4wr9/qTfNBxpPZB
 hUj8+FF6
 VZRMl35m4LIDIUlxaeH/GdBXZ/X7Sa4x89SClQTOVwZ4zxtX8vFyXc5wMWr//v+k1CFwD7ME9xpbLJFwEhsEWEDnkupO0NVUckJuqYjwiyIz9wvFRBOm9g4jOWCi14ZnbvstPCdsRwJ07P/68ngGJt1iiKxwX8ZidhioHTgj8+aoPlN+lugc9v+VXM3BQf6SRh1OUm3JFxoRrpsligWruYjdsNNyRtGq/Vkdl4zhG5eX0Ej7xPQHRVO16cn4zO/2gj+xzefk4g0A5OVpVG4p643ZVra8cZHTswPujp7wCyxvHlaiKFU8DcOAH/b33DVGmdOnYakCBxa7i8aMHvapJPSzEVhY39dRV5v93EMFxapDh34gE4gSPXLrQtKro1EnfWPbg269pcBc9dROUDw3LLzCjShU/z1q1ftWbu7T8dqJoTk3577s62+L+68Qh+e96IOqHQQMrXBneTQrzS82lmPlBrcUr0PttMzH2Ru3kbhSP2qm4QnQFjUTprvPgcPYS+Bci1CPQzQ2mI90=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Aug 30, 2026 at 10:29:46AM -0700, Hugh Dickins wrote:
> On Sat, 29 Aug 2026, Shakeel Butt wrote:
> > On Sat, Aug 29, 2026 at 08:26:02PM -0700, Hugh Dickins wrote:
> ...
> > > 
> > > Thanks for looking into this, Shakeel, but I don't think complicating
> > > __munlock_folio() is at all the right fix. This is peculiar to the use
> > > by mlock_drain_remote(), isn't it? Which is not taking the usual local_lock
> > > because the CPU is going offline. I would say, just take the local_lock in
> > > mlock_drain_remote(), but (I haven't read the history) for all I know,
> > > there may be PREEMPT_RT reasons why that would be completely wrong.
> > > 
> > > Hugh
> > 
> > Thanks Hugh, I will explore the local_lock approach.
> 
> Please do. But we may need input from Sebastian. So far as I can see,
> page_alloc_cpu_dead()'s neighbouring use of lru_add_drain_cpu(cpu)
> would suffer from the exact same issue, there are __counts there too.
> Maybe syzbot has not discovered that yet, or maybe I'm confused.
> 
> (But you'll understand that I don't particularly welcome a reorg of
> the local_locking around the lru_add_drains at the moment; and there's
> at least one among them which takes advantage of the fbatch local_lock
> to lock something else too.)
> 
> Oh for the good old days when we were allowed to say preempt_disable()!
> 
> > BTW I simplified the
> > fix to the following. is this still making things more complicated?
> 
> That is less distracting than your first one, but it's still not the
> right fix: the right fix is to have the function called under the
> proper conditions in all cases.
> 
> > 
> > diff --git a/mm/mlock.c b/mm/mlock.c
> > index efa6716e4dfb..fa30ffed76ab 100644
> > --- a/mm/mlock.c
> > +++ b/mm/mlock.c
> > @@ -141,11 +141,16 @@ static struct lruvec *__munlock_folio(struct folio *folio, struct lruvec *lruvec
> >  
> >  munlock:
> >  	if (folio_test_clear_mlocked(folio)) {
> > -		__zone_stat_mod_folio(folio, NR_MLOCK, -nr_pages);
> > +		/*
> > +		 * This runs both with and without the lruvec lock held, and
> > +		 * mlock_drain_remote() reaches it fully preemptible, so use
> > +		 * the accessors that serialize themselves.
> 
> I'm very far from being a good advisor on PREEMPT_RT,
> but I think that comment about lruvec lock would be wrong there.
> 

(Let me appologize upfront on dumping a lot of text)

I think I have a more important question:

I see other than __munlock_folio, we always update NR_MLOCK with irq-safe
variant of zone stat update function i.e. zone_stat_mod_folio(). This led me to
a rabbit hole of proving or disproving that NR_MLOCK can be updated from irq
context.

Disclaimer: I took full benefit of AI/LLM to create reproducers.

First scenario I gave AI to create reproducer was for a mlocked region, initiate
a direct IO (DIO) from it and then madvise(MADV_DONTNEED_LOCKED) on it. I was
hoping that I will see last folio reference in IO completion context and
NR_MLOCK getting updated then but AI came up with code paths on why it is
possible:

	MADV_DONTNEED_LOCKED -> NR_MLOCK decrement:

	madvise(MADV_DONTNEED_LOCKED)
	  madvise_dontneed_free()                 mm/madvise.c   (VM_LOCKED not in `forbidden`)
	    madvise_dontneed_single_vma()
	      zap_vma_range_batched() -> zap_pte_range() -> zap_present_folio_ptes()
		folio_remove_rmap_ptes()          mm/memory.c    (or via tlb_flush_rmaps() if delay_rmap)
		  __folio_remove_rmap()
		    munlock_vma_folio(folio, vma) mm/rmap.c -> mm/internal.h
		      if (vma->vm_flags & VM_LOCKED)      <-- STILL SET
			munlock_folio(folio)      mm/mlock.c
			  folio_get(folio)                <-- reference taken
			  folio_batch_add(&mlock_fbatch.fbatch, folio)

	  ... later, process context ...
	  mlock_folio_batch()                     mm/mlock.c
	    __munlock_folio()
	      folio_test_clear_mlocked(folio)             <-- PG_mlocked cleared
	      zone_stat_mod_folio(folio, NR_MLOCK, -nr)   <-- the decrement
	    folios_put(fbatch)                            <-- that reference dropped


However AI came up with a different scenario where NR_MLOCK can be decremented
in the irq context through free path. Just replace madvise(MADV_DONTNEED_LOCKED)
with munlock()+truncate. There is a race where munlock() resets VM_LOCKED from
vma and then table table traversal to call munlock_folio() on individual folios
and fallocate(PUNCH_HOLE) jumping in between that window and calling
try_to_unmap_one() and not able to call munlock_folio() due to lack of VM_LOCKED
in the vma.

AI was able to get the reproducer as well and the full stack traces are below:

Path A — the one the WARN caught

	blk completion softirq:

	blk_done_softirq()                              block/blk-mq.c:1225   (open_softirq(BLOCK_SOFTIRQ,...))
	  blk_complete_reqs(this_cpu_ptr(&blk_cpu_done))
	    blk_mq_end_request()                        block/blk-mq.c
	      blk_update_request()
		bio_endio(bio)
		  iomap_dio_bio_end_io()                fs/iomap/direct-io.c:278
		    __iomap_dio_bio_end_io()            fs/iomap/direct-io.c:241
		      bio_release_pages(bio, false)     fs/iomap/direct-io.c:255
			__bio_release_pages()           block/bio.c:1165
			  bio_for_each_folio_all(fi, bio)
			    unpin_user_folio(fi.folio, nr_pages)   mm/gup.c:434
			      gup_put_folio(folio, npages, FOLL_PIN)  mm/gup.c:102
				folio_put_refs(folio, refs)          include/linux/mm.h:2177
				  folio_ref_sub_and_test() -> true   <-- LAST REFERENCE
				  __folio_put(folio)                 mm/folio.c:100
				    free_frozen_pages()              mm/page_alloc.c:2997
				      __free_pages_ok()              (order > PAGE_ALLOC_COSTLY_ORDER: ext4 large folio)
					__free_pages_prepare()       mm/page_alloc.c
					  if (unlikely(folio_test_mlocked(folio))) {
						  __folio_clear_mlocked(folio);
						  zone_stat_mod_folio(folio, NR_MLOCK, -nr_pages);   <-- HERE
						  count_vm_events(UNEVICTABLE_PGCLEARED, nr_pages);
					  }

	The precondition — why PG_mlocked is still set when it gets there

	task 1:  mmap(MAP_SHARED, victim) ; mlock()          -> page cache folios get PG_mlocked
	task 1:  pwrite(O_DIRECT_fd, region, len)            -> iov_iter_extract_pages() FOLL_PIN
								pins those same mlocked folios
	task 2:  munlock(region)
		   mlock_fixup()                              mm/mlock.c
		     mlock_vma_pages_range()                  mm/mlock.c:428
		       vma_flags_reset_once(vma, ...)         line 451  <-- VM_LOCKED CLEARED
		       walk_page_range_vma(mlock_walk_ops)    line 454  <-- per-folio munlock walk
									    (holds mmap_lock for WRITE)
	task 3:  fallocate(PUNCH_HOLE) on the same range      <-- reaches the folio via i_mmap_rwsem,
		   truncate_inode_pages_range()                   NOT mmap_lock, so it is not excluded
		     truncate_cleanup_folio() -> unmap_mapping_folio()
		       try_to_unmap_one() -> folio_remove_rmap_pte()
			 __folio_remove_rmap()                mm/rmap.c:1889
			   munlock_vma_folio(folio, vma)      mm/internal.h:983
			     if (vma->vm_flags & VM_LOCKED)   <-- FALSE, window at line 451..454
				 munlock_folio(folio);        <-- NOT taken: nothing queued,
								  no folio_get() reference
		     filemap_remove_folio()                   <-- page cache reference dropped

	The bio's pin is now the only reference, PG_mlocked is still set, and it is released by Path A in softirq.


The reason I am sharing this information is that a simple lock_lock is
not sufficient and we definitely need to change __zone_stat_mod_folio(NR_MLOCK)
to zone_stat_mod_folio(NR_MLOCK) in __munlock_folio.



