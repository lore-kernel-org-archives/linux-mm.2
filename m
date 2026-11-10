Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6BEAF606A204
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 16:40:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NiJHgmnD
Received: by kanga.kvack.org (Postfix)
	id 8B23E6B05B8; Tue, 10 Nov 2026 11:39:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 862E66B05B9; Tue, 10 Nov 2026 11:39:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 79FDB6B05BA; Tue, 10 Nov 2026 11:39:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5AD9C6B05B8
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 11:39:59 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 77340A09BC
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 16:39:58 +0000 (UTC)
X-FDA: 85419771276.08.A715C8A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id C30D64000F
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 16:39:56 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NiJHgmnD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794328796;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V3wQUDCbz5WGhoG/NeGMkM84FaWuj5GPriNi9gVRFwY=;
	b=JmFNoMyEVgien81o1K3QBCMLtfluklpSootPCNbCCpFNymO8HH/Pt77GxeNqYMRdgxnJFb
	uxHy9F5XLSX2W+7NxdW/vRZPd2NZW0Vxd9c2eW4ImrS02IcquSEsu5zv/5KTVpX0wJUs1E
	YsNrtJ0OSNBLnNTBpYU94hQv8Voy/iw=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NiJHgmnD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794328796;
	b=jyvxvRg+5AlhSR/prOfuGyB9op2ee1yONNP3CuSpfTanB99M8IDmpGczbjdg2oEOU0rv1R
	AQWYt84DqXWscKJi+teePUyN7g5mJX0AMGn/1Kt2HxgXkbDpI4jkIvAK0qEWTvi1OwNsu7
	EFFzB8dtDlrbnaYmsWOP3/Tq5U8JvGQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1E95140759;
	Tue, 10 Nov 2026 16:39:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 776DE1F0089F;
	Tue, 10 Nov 2026 16:39:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794328796;
	bh=V3wQUDCbz5WGhoG/NeGMkM84FaWuj5GPriNi9gVRFwY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=NiJHgmnDww74FAeFIsbv4+tq/EeqvYG+bZKAr4d7/8YSmGKoSpdpPG46ETzA2ilqj
	 BHJSMVjnk/ffP59J5e5O7zGbra0IqtWpvbgdixT1oxlc1Tze8jUeTqK7xtlaWgzhK0
	 nlhUfVr5HUKmeVQG0WLvjudr7aFN5fIFomHIFhNjZr1Vv7rcUejmTvJPYIhWKqSBu1
	 hKrv+R/btHRAOY/cmSi7m8uxPaCRBPILRcWeXcMhyhuIwXzLy1sVnsYy0ThUI4qTEU
	 Gd3UM5JJowmSARk8hKzP4SdkuwFWhn2G7rSCLtMwRgMSEOjgFZRqGZlszEgEfhu7Fl
	 gfQ2UurT2EyKw==
Date: Tue, 10 Nov 2026 16:39:49 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
	Suren Baghdasaryan <surenb@google.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Lance Yang <lance.yang@linux.dev>, "David Hildenbrand (Arm)" <david@kernel.org>, 
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Seunghyun An <san55@wisc.edu>
Subject: Re: [PATCH] mm/vma: predicate vma_assert_stabilised() on
 CONFIG_DEBUG_VM
Message-ID: <avNIEdpUbihHULcm@gremlin>
References: <20261110-vma-fixup-debug-asserts-v1-1-0b2e0680cd7e@kernel.org>
 <avNAgtDzM0MYevV8@gremlin>
 <avNDjxZ9jeYiwdVh@gremlin>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <avNDjxZ9jeYiwdVh@gremlin>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: C30D64000F
X-Stat-Signature: 7br1ubw1q71r4yhqxxs8zbmtnhusef5g
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794328796-931157
X-HE-Meta: U2FsdGVkX19xaszixHCdr6ZmBwHh9Z9RY8vGz3lnQ8ToZjHvvnWaWHDHk9EyxtuzB8tPh3D5cSXv8ms62DhqLMuIUWDUzEqgILsFvwUL5ePJfZxRT2DPEdSgk+F3gppMaPthdCV10clU0MSC7IrhYrH+Xfh1fw8vWZHywfTvp7ApDtRL0OrKAInWnZljAVCTefODYFfuixCV7Ei6BUEBko402KioCdO1IzWDVN9jf4b0t6KPN7g0yXyDGDiLVc3Xf3EioXJtrXMBO1CQy4b7JgVb2Uex0NMLhGb8puFIgPvBtybEQZR/n021Yn7EZdt9D4hJ0cdUC9aQdOvrpnJLPMywOcgs2A8sElVHaJToGSwfE2AXPQiDLfP9wcObnFIICZrrhvRuvfYo/QgCEL1FPRISIceRwBJDwclvMAZ2HYvb0COAnwUBb+Dl0NFhdJ7hUTPHW+HnyZpUQaQPhWP7+agyy8BYzRJhVZcqprLJsHGO7cKA7OzbaIE1TqLJ4iGue5cLRJ6K0glsHKmteZB2+Qe/mFmjS47Zxt7is3TBnO1njFuJHVBAHHndkdvpzs3jDaOVyibDaf7bxYarO3bNSk2sSFCjMdmgD85t2VLZWwy73xbAp2VKKkBZ/Z0PNoApDROKVq5CFVOzmiO2bHzxvi9Xy9IMhUk+wA6xSYgU5bcg4ukyB5DFFdGMedO+fOWl4Dk4vsT/Pa/Vzx/0KHcLybhtCQ2A5r3mojoHD2icToeKF11jDw/f3RDvYwiKxSb11+skjt8+K0Kdw5aT0F3ZIDzrFsyhd74Ys1MdWoF4dlXQaDRV9fLbqlKjhn3xjJF7rEZMZePuVwIaZZonAvSgmIu4YjfB6yugny2XRl9cKPZFhonzf4qwT2eYB4U2pkAE9s3fbOXMwGYbKxC08CMsfSBcg8CVShXGzgDE1wvMT9coAwhTTK3uZrlS68pQEa3HYbEiN9Ga0JbucaAokGm
 dFEDPip1
 zbYuxY8j2IwXVhGRSL3yI0OVWP9jn1PWRMsstXS94HIn9eCs4lWQfx9MYLug3JHmmb3c9Pdq24byMGX2XSPoFo+PDoUEorIaDKEgBPmNguQYnm9Q+FD+NIHM7YT2wy6hgLvoDVL9ueawm+cZ4JV4n9ft9PtFrTuSJ1BjtYm5G3Pw3GHnCPcpPxHpTtOTghtyc3SBlCiFdE98xwL0gv15NLBuWzPCTx4QH2Nwo8U26zZ3eirfc+mqQXtgPc7X2rvjNW2l8E6g6MXzE6pOn/hfPdv4iUDskKc8Az3krQNGUo4BO7u8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 10, 2026 at 04:18:35PM +0000, Lorenzo Stoakes (ARM) wrote:
> On Tue, Nov 10, 2026 at 04:07:48PM +0000, Lorenzo Stoakes (ARM) wrote:
> > Andrew - could you update as below?
> >
> > Thanks!
> >
> > On Tue, Nov 10, 2026 at 03:10:40PM +0000, Lorenzo Stoakes (ARM) wrote:
> > [ ... ]
> > > diff --git a/include/linux/mmap_lock.h b/include/linux/mmap_lock.h
> > > index 9ccbbcbd7aca..9c3a9c6525c1 100644
> > > --- a/include/linux/mmap_lock.h
> > > +++ b/include/linux/mmap_lock.h
> > [ ... ]
> > >  /**
> > >   * vma_assert_stabilised() - assert that this VMA cannot be changed from
> > >   * underneath us either by having a VMA or mmap lock held.
> > > @@ -418,9 +423,18 @@ static inline void vma_assert_locked(const struct vm_area_struct *vma)
> > >   *
> > >   * With lockdep disabled we may sometimes race with other threads acquiring the
> > >   * mmap read lock simultaneous with our VMA read lock.
> > > + *
> > > + * Assert only if CONFIG_DEBUG_VM is set.
>
> Also this should say:
>
> 'Assert only if CONFIG_DEBUG_VM or CONFIG_LOCKDEP is set.'
>
> > >   */
> > >  static inline void vma_assert_stabilised(const struct vm_area_struct *vma)
> > >  {
> > > +	if (!IS_ENABLED(CONFIG_DEBUG_VM))
> >
> > Actually I think this should be:
> >
> > 	if (!IS_ENABLED(CONFIG_DEBUG_VM) || !IS_ENABLED(CONFIG_LOCKDEP))
>
> Sorry this should be...
>
> 	if (!IS_ENABLED(CONFIG_DEBUG_VM) && !IS_ENABLED(CONFIG_LOCKDEP))
>
> (I have a bit of a fever today, can you tell? :P)
>
> Thanks!

OK OK actually. Sorry. The change isn't required, it's fine :P

Please leave the patch as it is.

If !CONFIG_DEBUG_VM but CONFIG_LOCKDEP we don't actually assert anything.

Since this:

	if (IS_ENABLED(CONFIG_LOCKDEP)) {
		if (lockdep_is_held(&vma->vm_mm->mmap_lock))
			return;
	}

Is the only thing that would run in the functino and early-exit if the condition
is hit.

Then it defers to vma_assert_locked() which then reaches:

	if (IS_ENABLED(CONFIG_LOCKDEP)) {
		if (!lock_is_held(__vma_lockdep_map(vma)))
			vma_assert_write_locked(vma);
		return;
	}

And vma_assert_write_locked() uses VM_WARN_ON_ONCE_VMA().

(flu vaccine on sunday, seems to have impacted my brain :P)

--
Cheers, Lorenzo

