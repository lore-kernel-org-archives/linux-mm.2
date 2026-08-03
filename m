Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D069C55184
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 16:44:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 45F726B007B; Mon,  3 Aug 2026 12:44:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4101E6B0088; Mon,  3 Aug 2026 12:44:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 32A276B008A; Mon,  3 Aug 2026 12:44:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 015386B007B
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 12:44:07 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7890140774
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 16:44:07 +0000 (UTC)
X-FDA: 85060530534.08.8542703
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id AF8AE1A0004
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 16:44:05 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Gbzyl6TM;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785775445;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pDZf4SngBouo87PecrZqHP+WwuuBB8S8PZVMhXw1zaI=;
	b=oyR1G5HD0pnVlYOL58aE7hQER10zlPzAI8Mq9/Wiw68f1WpWRbdCW4Vdv92dIzW6Y3Noz1
	Iw3i+jGiDP66+N6MbtsBijsUeyNfUVdUOsT8dX7eTl8w9UDqVciYjwHEIMV07x3ioV8e6A
	V4U1KeGwZDU5LmJK+S+nL6DJdLNRlEQ=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Gbzyl6TM;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785775445;
	b=y+T07t7a7h63suew5ZQGIeDAGLk5FQn6h7Z2n0sg77ka3VhXXo2bkWkkjlz036dDeTGf4q
	HB0NxT/diVGSA70U8VgHuYbc0nP7m0pAqjJnqVeiaLZToDkq0M+3wWu9t5GBavTy9ng45n
	U/7S9Q5AV/HD9IPdi0v9dr7seSdBdGY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 888D34172B;
	Mon,  3 Aug 2026 16:44:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 011E81F000E9;
	Mon,  3 Aug 2026 16:44:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785775444;
	bh=pDZf4SngBouo87PecrZqHP+WwuuBB8S8PZVMhXw1zaI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Gbzyl6TMQV2kG2YevL4XMFFo0GG8ANJPFq3PgX8brYQsbXFh/iS1AVUY6KwkgkdLy
	 Zq5UvtsyR/5zp2Xzsui+gxD9H/3wRopONhg6ZeyNOupJNlGhTQrpt+/ePBYA7R6pqQ
	 4tfgZDsUJrljnXZ3DQyVrZfgJrv3zJ4VZyJlp1ogVenv5mohq7HvtWU3KqzPT8ATl4
	 vpp/Mh46EKggX5i/TDJcp7MiesW3gSgRSXYCx2zFydzk6Hb21zuTnN1IxrgHpFQSBF
	 5OOxMyAXuzlAJrwnIy52QjyCTQA+uEmRf+Epx+zmQHvez1ha4Cp/FXDxJ2W74IK5Hn
	 Bsv6/ciUgNUlg==
Date: Mon, 3 Aug 2026 17:43:46 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>, akpm@linux-foundation.org, 
	dave.hansen@linux.intel.com, Liam.Howlett@oracle.com, david@redhat.com, willy@infradead.org, 
	shakeel.butt@linux.dev, jannh@google.com, aliceryhl@google.com, arve@android.com, 
	cmllamas@google.com, christian@brauner.io, tkjos@android.com, dsahern@kernel.org, 
	davem@davemloft.net, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, netdev@vger.kernel.org
Subject: Re: [PATCH v3 3/5] mm: Add RCU-based VMA lookup helper that waits
 for writers
Message-ID: <anDBVu0PIzy7dks-@lucifer>
References: <20260802215459.2769283-1-surenb@google.com>
 <20260802215459.2769283-4-surenb@google.com>
 <152ee467-b5e4-470c-ad95-c638aa9986bc@kernel.org>
 <anCst8u7ybHf39n8@lucifer>
 <9c301dd5-76cc-40dc-bbab-a79559d6db1a@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9c301dd5-76cc-40dc-bbab-a79559d6db1a@kernel.org>
X-Rspamd-Queue-Id: AF8AE1A0004
X-Rspam-User: 
X-Stat-Signature: dm5odfgeogjkh3t7aygy3hgu86q9yqyi
X-Rspamd-Server: rspam04
X-HE-Tag: 1785775445-626196
X-HE-Meta: U2FsdGVkX1+m7keJK+Rq5gP4Upef9X8VQD2IehKRNuIayRdOzl3mUPhDdSC/yyfDjB9DzPLmBIflY//vNN1XWFvL3y9Ufm5qk20WYHClc1m/eIjoPEtB0Q1Rvpq0kcMcdvccmE3LePpCd4oTcUwFWboFXi2axCEZw05QYWXGLqD58gPTZymRDAxYUZZ8cYe5EMaHeC3VlYUTH3QKw4erDLTnDpaIo1rZfDk1A1WVUjvFci8HePD4iGqr1OwumzbNn+1o+M/JthaerOISaIjAqLhw1vVSiZ/JuEtJpWL4a4xLvCFQhG0ArUXfgqQu5A1ADxUA8xYgj1PJJgRFYM3Xf9CVSbk4d3BbAhkchlB7XCOl91RsHK601C2MYtsv3wlIWcdDe/2ZtpabwvuaGl/wC1gLiKWmHCM0UuYcPKtc8KwbNKHVlDVfJSsPercy+LwRtbb8/NXUfsUt6D0NbM3ZMvu1DEHOfuJnozaOv4XA4PI0+ZQn7P8rOvk0ED3ypxHMMtSKwH/ny88ffIAby2vvKSeDVwyvOa8V0U8Zc6jnPnG4hhbDSRrmyx1dBpzUSH/drRUnD7RBngBB1FCxAlm1F8FDp6vZZB2fYCCXcINNlv8+IJhvYoa3Oa9htcvZZZWJyLXZSvGQ7dwQZNDnt9UJPtxpmaDEeNT9i3QTQB1yy0FG9+7lDIQk0pxmpW7Nx/0GrA86ZHGphECkJPcdgCoz+VBYC9KO9Gnv6qHCIkBdDRrvo/EWVqWDfbHrUSuNHo7aTNSoPMjd8G+nouwMPZgAPIVOCiUaWBB8kxo/FNGbHaAaCAKXa6jFl73A8Jm8ALH3eRBvMlKTlTX8ETW7chVkKdJQrbm5HkwVdOVYTrN7WDZnFfQg/ICixIqTfSsplgsNq1j3wTQuCuMQhCDVWAEYUqjUvl7LXA/gkj0FuvqUYgR02w5e4Ms62eoX3hdzni/zSP4IXO8NU+tHIT5g030
 3TRju5zI
 oWYMjC1CXFLEgXzmVL2UWyuSV2uM/ISVgBhJPRXVbtUCVrVFNYgR6g5/5a5qs0YjM3maF0Kb6KeZssSlFC8XyIxP9DbsjEXrCwBiFZZWzK3fkjWZc2y27J6dNe9ojh/YnmwGzEWlc9lc8IkDctbsq5eUmYLOteZodqDYt87a0GmPP8xVUOMk2X39NYRyakN4NFuO9PQsaX+DkzoMjN1nq6GrMsPXuNovz/OlqK9fU2F/rh01HJeOuxCIbT5b6Tt4EwzN/BG3S7ownHGnre3LD4bxZHjpZQmIc2YXaJTKPxHpGiyO9ogxWD6PdO8sSF0FNwrQU03mXFs5Jgk1iOs4Or9zthvjR2exsDXxJHEbCl2deYBO+dJ8IwFBmI+k4bftDDQEG0CpWQww4gjungrF4fYDLsKcMWMGYTbj8xOnBUg2GnYRu8HB82qRSBzu/ZezRs2avyDzOKQ+KqtsDX/2jbO0dz26ApK6H44XPg+ybeUu5q6i9S+b+uXoZwgadz57zJaPw3MUw7zFjaCo1spwjHO+yeEt/zwuONZYlBtYLh7A0Ldm3Zn8E53LDYdMWMkIRdTVniNeuu8gqfnsIVLS2EQrw1UiRpdnGrBDPCGLieFY4BWv31R5rD97M9PVIi7y5bt9BRQgZmMwC2xTk9DsmgNvM95X+NDCPQwXiDCAhgyzNu6u1p6x/rYUWuIy68JOw7RjWs18kUneS7Ec=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 03, 2026 at 06:24:34PM +0200, Vlastimil Babka (SUSE) wrote:
> On 8/3/26 17:00, Lorenzo Stoakes (ARM) wrote:
> > On Mon, Aug 03, 2026 at 04:55:19PM +0200, Vlastimil Babka (SUSE) wrote:
> >> On 8/2/26 23:54, Suren Baghdasaryan wrote:
> >> > From: Dave Hansen <dave.hansen@linux.intel.com>
> >> >
> >> > == Background ==
> >> >
> >> > There are basically two parallel ways to look up a VMA: the
> >> > traditional way, which is protected by mmap_read_lock, and the RCU-based
> >> > per-VMA lock way which is based on RCU and refcounts.
> >> >
> >> > == Problem ==
> >> >
> >> > The mmap_lock one is more straightforward to use but it has a big
> >> > disadvantage in that it can not be mixed with page faults since those
> >> > can take mmap_lock for read, which can deadlock when mixed with nested
> >> > page faults and parallel writers.
> >> > For example:
> >> >
> >> > 	mmap_read_lock(mm);
> >> > 	// Another thread does mmap_write_lock().
> >> > 	// New mmap_lock readers are blocked.
> >> > 	vma = vma_lookup(mm, address);
> >> > 	// This deadlocks on mmap_read_lock() if it faults:
> >> > 	copy_from_user(address);
> >> > 	mmap_read_unlock(mm);
> >> >
> >> > The per-VMA lock can be mixed with faults, but they can fail and need to
> >> > be able to fall back to the traditional way.
> >> >
> >> > == Solution ==
> >> >
> >> > Add a variant of the RCU-based lookup that waits for writers. This is
> >> > basically the same as the existing RCU-based lookup, but on a failure to
> >> > lock it temporarily takes mmap_lock for read and waits for writers
> >> > to finish before locking the VMA, dropping the mmap_lock and returning
> >> > the locked VMA. This has some advantages:
> >>
> >> Maybe mention that the helper is called vma_start_read_unlocked()?
> >>
> >> >
> >> >  1. Callers do not need to have a fallback path for when they
> >> >     collide with writers.
> >> >  2. It can be used in contexts where page faults can happen because
> >> >     it can take the mmap_lock for read but never *holds* it.
> >> >  3. Its fast path does not require taking mmap_lock for read.
> >> >
> >> > Basically, when applied correctly, this approach results in faster
> >> > *and* simpler code.
> >> >
> >> > Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
> >> > Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> >> > Cc: Suren Baghdasaryan <surenb@google.com>
> >> > Cc: Andrew Morton <akpm@linux-foundation.org>
> >> > Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> >> > Cc: Lorenzo Stoakes <ljs@kernel.org>
> >> > Cc: Vlastimil Babka <vbabka@kernel.org>
> >> > Cc: Shakeel Butt <shakeel.butt@linux.dev>
> >> > Cc: linux-mm@kvack.org
> >> > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> >> > Cc: Arve Hjønnevåg <arve@android.com>
> >> > Cc: Todd Kjos <tkjos@android.com>
> >> > Cc: Christian Brauner <christian@brauner.io>
> >> > Cc: Carlos Llamas <cmllamas@google.com>
> >> > Cc: Alice Ryhl <aliceryhl@google.com>
> >> > Cc: "David S. Miller" <davem@davemloft.net>
> >> > Cc: David Ahern <dsahern@kernel.org>
> >> > Cc: netdev@vger.kernel.org
> >> > ---
> >> >  include/linux/mmap_lock.h | 15 +++++++++++----
> >> >  mm/mmap_lock.c            | 29 +++++++++++++++++++++++++++++
> >> >  mm/userfaultfd.c          |  6 ++++--
> >> >  3 files changed, 44 insertions(+), 6 deletions(-)
> >> >
> >> > diff --git a/include/linux/mmap_lock.h b/include/linux/mmap_lock.h
> >> > index eb32b482434e..fdd8f5cf5722 100644
> >> > --- a/include/linux/mmap_lock.h
> >> > +++ b/include/linux/mmap_lock.h
> >> > @@ -228,10 +228,12 @@ static inline void vma_refcount_put(struct vm_area_struct *vma)
> >> >  }
> >> >
> >> >  /*
> >> > - * Use only while holding mmap read lock which guarantees that locking will not
> >> > - * fail (nobody can concurrently write-lock the vma). vma_start_read() should
> >> > + * Use only while holding mmap read lock which guarantees that vma lock is not
> >> > + * contended (nobody can concurrently write-lock the vma). vma_start_read() should
> >> >   * not be used in such cases because it might fail due to mm_lock_seq overflow.
> >> >   * This functionality is used to obtain vma read lock and drop the mmap read lock.
> >> > + * VMA can't be detached while we are holding mmap lock, therefore in practice this
> >> > + * function can fail only when there are so many readers that vm_refcnt overflows.
> >> >   */
> >> >  static inline bool vma_start_read_locked_nested(struct vm_area_struct *vma, int subclass)
> >> >  {
> >> > @@ -247,16 +249,21 @@ static inline bool vma_start_read_locked_nested(struct vm_area_struct *vma, int
> >> >  }
> >> >
> >> >  /*
> >> > - * Use only while holding mmap read lock which guarantees that locking will not
> >> > - * fail (nobody can concurrently write-lock the vma). vma_start_read() should
> >> > + * Use only while holding mmap read lock which guarantees that vma lock is not
> >> > + * contended (nobody can concurrently write-lock the vma). vma_start_read() should
> >> >   * not be used in such cases because it might fail due to mm_lock_seq overflow.
> >> >   * This functionality is used to obtain vma read lock and drop the mmap read lock.
> >> > + * VMA can't be detached while we are holding mmap lock, therefore in practice this
> >> > + * function can fail only when there are so many readers that vm_refcnt overflows.
> >> >   */
> >> >  static inline bool vma_start_read_locked(struct vm_area_struct *vma)
> >> >  {
> >> >  	return vma_start_read_locked_nested(vma, 0);
> >> >  }
> >> >
> >> > +struct vm_area_struct *vma_start_read_unlocked(struct mm_struct *mm,
> >> > +					       unsigned long address);
> >> > +
> >> >  static inline void vma_end_read(struct vm_area_struct *vma)
> >> >  {
> >> >  	vma_refcount_put(vma);
> >> > diff --git a/mm/mmap_lock.c b/mm/mmap_lock.c
> >> > index e20d01e8d38f..6ff05e68e61b 100644
> >> > --- a/mm/mmap_lock.c
> >> > +++ b/mm/mmap_lock.c
> >> > @@ -338,6 +338,35 @@ struct vm_area_struct *lock_vma_under_rcu(struct mm_struct *mm,
> >> >  	return NULL;
> >> >  }
> >> >
> >> > +/*
> >> > + * Find the VMA covering 'address' and lock it for reading. Waits for writers to
> >> > + * finish if the VMA is being modified. Returns NULL if there is no VMA covering
> >> > + * 'address'.
> >>
> >> Hm but it can also return NULL when vm_refcnt overflows, in theory.
> >> Should we also return -EAGAIN (like uffd_lock_vma() below), or just retry in
> >> here and hope for the best? The latter would be simpler for the users.
> >> (AFAICS due to VM_REFCNT_LIMIT we never end up triggering the refcount
> >> saturation)
> >
> > The problem is everything's unlocked so 'didn't find a VMA' doesn't really mean
> > much more than 'something went wrong' because hey maybe if you check again now
> > you'll find something :)
>
> Well there might be use cases where you know that either there's a vma with
> your address and then you need to do something with it, or there's not and
> then you don't. And it can't suddenly appear after you check.

You don't hold a lock that prevents new VMAs appearing/disappearing
spontaneously at the point you call lock_vma_under_rcu(), or after you drop the
mmap read lock, only that at the point of checking a VMA spans address, so
there's nothing preventing a VMA suddenly appearing after you check right? Or it
not being the one you wanted?

And checking to see if it's 'really the one you meant' is itself fraught (see
the whole uffd saga on that).

Point I'm making is that in any case where you'd actually care you'd need to
take a stronger lock anyway, so it's actually potentially dangerous to
differentiate between the two.

Given the overflow is very very unlikely I think it's also not a big deal to not
differentiate anyway.

>
> So in that case treating that spurious NULL as "there's no vma so I don't
> need to do anything" would be wrong.
>
> The usages in 4/5 and 5/5 seem like they are not this case though. So it's
> fine. But perhaps worth just mentioning it in the comment then.

Agree this is worth spelling out in the comment (I raised similarly).

Maybe something like:

	If a VMA exists which spans @address, return that VMA, read-locked.

	If no VMA is mapped there or, very unlikely, a reference count overflow
	occurred, return NULL.

	Nothing prevents VMAs being unmapped/mapped before or after the VMA is
	looked up, if a stronger guarantee is required, take an mmap lock.

>
> > So I think this might be a feature more than a bug, especially given overflow is
> > not exactly likely.
> >
> >>
> >> > + *
> >> > + * Use only in code paths where no mmap_lock and no VMA lock is held.
> >> > + *
> >> > + * The fast path does not take mmap_lock.
> >> > + */
> >> > +struct vm_area_struct *vma_start_read_unlocked(struct mm_struct *mm,
> >> > +					       unsigned long address)
> >> > +{
> >> > +	struct vm_area_struct *vma;
> >> > +
> >> > +	/* Fast path: return stable VMA covering 'address': */
> >> > +	vma = lock_vma_under_rcu(mm, address);
> >> > +	if (vma)
> >> > +		return vma;
> >> > +
> >> > +	/* Slow path: preclude VMA writers by temporarily getting mmap read lock. */
> >> > +	mmap_read_lock(mm);
> >> > +	vma = vma_lookup(mm, address);
> >> > +	if (vma && !vma_start_read_locked(vma))
> >> > +		vma = NULL;
> >> > +	mmap_read_unlock(mm);
> >> > +
> >> > +	return vma;
> >> > +}
> >> > +
> >> >  static struct vm_area_struct *lock_next_vma_under_mmap_lock(struct mm_struct *mm,
> >> >  							    struct vma_iterator *vmi,
> >> >  							    unsigned long from_addr)
> >> > diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> >> > index edd90892f8cc..c3a0c38a3dc3 100644
> >> > --- a/mm/userfaultfd.c
> >> > +++ b/mm/userfaultfd.c
> >> > @@ -129,8 +129,10 @@ struct vm_area_struct *find_vma_and_prepare_anon(struct mm_struct *mm,
> >> >   *
> >> >   * Should be called without holding mmap_lock.
> >> >   *
> >> > - * Return: A locked vma containing @address, -ENOENT if no vma is found, or
> >> > - * -ENOMEM if anon_vma couldn't be allocated.
> >> > + * Return: A locked vma containing @address, -ENOENT if no vma is found,
> >> > + * -ENOMEM if anon_vma couldn't be allocated, or -EAGAIN if vma refcount
> >> > + * overflow happened due to high number of readers and the caller should
> >> > + * retry later.
> >> >   */
> >> >  static struct vm_area_struct *uffd_lock_vma(struct mm_struct *mm,
> >> >  				       unsigned long address)
> >>
> >
> > --
> > Cheers, Lorenzo
>

--
Cheers, Lorenzo

