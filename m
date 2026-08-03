Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 095EFC55838
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 15:00:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E60326B0099; Mon,  3 Aug 2026 11:00:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E10A26B009E; Mon,  3 Aug 2026 11:00:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D4DC36B009F; Mon,  3 Aug 2026 11:00:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A50BD6B0099
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 11:00:25 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2D8B61C12A0
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 15:00:25 +0000 (UTC)
X-FDA: 85060269210.29.B5E85EA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 848161A0002
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 15:00:23 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Vik1jTt9;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785769223;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DYHyaHJJHP3pEUUb5RArEn5q/XsXxIfPC78T9whGzr4=;
	b=endhB3YuXvC+4k6bQ1qdHmjko+ok5It9gC3G5BuHQb6dFxLTWv6UQeuWT/eci2InIbbdjl
	1xdlTpn3s7Dcf/m/Z7lgC3FK/UKD/FIlDpWozsV+P9szPFu97t+BGSVvwmsT3jA4F8/w8L
	eWAHJ5ThKqyXlDjFLcQMcZwSyYm9FTA=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Vik1jTt9;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785769223;
	b=LwTShET+fH+z7mTY9bGhSt7MiqZQAG0lbgCZ31bkt0LqioWg9e6pXJh+B5ZSJ+dofPQBte
	SGsbGdC88t682RnsEyYjIsOK8Rac5UKhg1S7f5VZztrcjCuqxnXZjQhQ+JYWdeN+Q3GA/O
	69TQvICZlok6+qBmcczTMNSh5cWkO8Y=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0869960DB6;
	Mon,  3 Aug 2026 15:00:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 497791F000E9;
	Mon,  3 Aug 2026 15:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785769222;
	bh=DYHyaHJJHP3pEUUb5RArEn5q/XsXxIfPC78T9whGzr4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Vik1jTt96uERvXxcpWMtBKyCMxM7oKJ8U3XxdDaLQjOA/eaiXi9ghWpojIC1nx5sj
	 SInRjLBNlBxYVLqGczOlWQMaFdN7nqiY+qvXjmqmdz8kz7VZbEWVD9poNGm+i26c2M
	 JK1AQu1n0NWlD/Cthka2vqxGKv+RqTy6RJCNnh4fGsjxYhe7JjkXDCFhonSQO/DjdM
	 7Wq3J1rNCZMF+d60g7RJOjJv9u1PMhlIym75jFvhPbqutLH5HW8cGvify3q8CTj5Y3
	 LSWGOaVywlWzPaS6TqltFmgDdeDHYBpn1Fz0VpobpJvslhtUb787FiEPCfDsP9oVun
	 HxVT9AwBzssKg==
Date: Mon, 3 Aug 2026 16:00:04 +0100
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
Message-ID: <anCst8u7ybHf39n8@lucifer>
References: <20260802215459.2769283-1-surenb@google.com>
 <20260802215459.2769283-4-surenb@google.com>
 <152ee467-b5e4-470c-ad95-c638aa9986bc@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <152ee467-b5e4-470c-ad95-c638aa9986bc@kernel.org>
X-Rspamd-Queue-Id: 848161A0002
X-Rspam-User: 
X-Stat-Signature: ma4p1jhc4wsqi6dgs5c1ohrk9tngmtn6
X-Rspamd-Server: rspam04
X-HE-Tag: 1785769223-829479
X-HE-Meta: U2FsdGVkX1/aq5OLRhN+OCKKQwTdLwkH3smFasE54rAFqP3QG52rrYR/ndir9YpR1jciI6KEUbC0rwRHXfTcBtmIt/EAvAgHONVld5lp3FO+RwvKbpyHS8kGhWdLd1dheR6rY1kivtm6/daiGUNpEMiStuhtH4/sK//NMPVVc9+VoLKYnDoOXBK/StNYUeAGy4rYm49t+ioz14stHiedbWhUkohL95lV17TjKt90NSJHraf1mVC30gxnNlqshBXTjtVjxcpRxLxTGNLD4MZo1Nfb8KEkfYtU8FoXfU3WScIwbkYVK5EGA5USe2T72+fVvFcF6lwSHc7diQZFlzCEVD9WKWya4eQks0deibUsjdW2b8pSdS/2P2+G6dNlGQ+WMOlGnj8mcBHtBxvHbxtS9EpBO5hr2i/DsKJzS8CxjlAckVSx6p/XOAxxBgQ8jwwGH6LdiKlAoHYInapwIt/WgdZUsyOfY7Knyx8Ck2GCUbyncCd/3dQ1//tWXBWouyIohQTDv6o+M3MTHSj+W6GdYkk/SkKJj6ooyBvbpIVmuucxE2NAjIcghsFQ1xdaBGN9zN09bW+7nFi9+UpbpnC/XtvojRxriZS4cn2mCSEx+Qd3UTJvDuMNzWmOjgrPLP3DnBCIbIC2e8HYW/1y55/32YQZjIbKdwcCYhxebdI1GJ118180CkE1aa3MPgCXXQQ2+id9q/jV5alVTd3GUCHVdSZGCVLyxVSzfAX1PLOfx8VWDHJoexqdB15YpqTZkVG/MdshYZKbSFJLixt+NW9fxn8AuMidW6mtdXSWB/TIk9fs1lxLbWn7J0H0A85Q3/Hcdq3ZfC619wHEVfQsKOZ++Hc61QcUsYU4CeESYkoq6SV4efxsmgdmzeqfpGnS4BpePDXqZS9YVuy35Dph8IYiyQSxf7DHuHp2tDv0m7Mso1WcXdHT/xzDjfF4bSgh6cOUg/x5luJykxbuy8hnJMF
 kJF2+gby
 euN7WwkSKxIYxv9Z7KsI7i4Mdvuf+voSlXVwRLzbuSiQ2HKtj5fkHkFjutdx6LAHuDuv9lT8QpcPoAw/KntgOWVD9ItTqv7qdM27zh29OKdrYfWgl1Ejjw9SMxkqPncImD1QamygMeXoi8u9S4K5rNBs0jNf/85PzoYUOHCXmKDVLhx/C+QfGGQwFT09sT9UCmJ7xTlF933Dw6Cd2cAID/0JxHpBtLMsYvVfRwkgPROSWjT34qfJMrYPdZllTwD3DFm0xa1H1tNNomKglf4+ZgkEfmAKwkIvmzUKJGgggM/7K/KRYfM1oG07arScRW72OUTQZUlCeKczI5WJG+Bt9mAO7KqvZNQd+6q/TVl6cwMBkae633j4AH8rVflAW2b6KWyjei7e8L1Cy02PobpR72BCY4U7MFNM3PXNBkqfxDxMvt+JTacGDiFvuIhCCPFeBVqZMtCoUpVeRWQkhvGHpHRX2BLms9/q3AmlmjdJVdSOQ/fVqNn8ScxbkvGwUpBP9zWSgDO96rdwDur+s7VmBJBuU/7I73O3JpGCsxHFBr61xdQnb1ZVDJQiuvb3yb0emfQRm5iUyHCvY1yGSV78rFt6En86nNNjDrlPZQ2CRjGQAyAv1VPBjehNG5x3Nwsdk+1+wEogNwO1+t+gWaDIjDrGIo5a/Gzl5dulD+TKpiinGTmc+zWfLTuKVKAAiET4Qp1bgCM+gmhCZNgg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 03, 2026 at 04:55:19PM +0200, Vlastimil Babka (SUSE) wrote:
> On 8/2/26 23:54, Suren Baghdasaryan wrote:
> > From: Dave Hansen <dave.hansen@linux.intel.com>
> >
> > == Background ==
> >
> > There are basically two parallel ways to look up a VMA: the
> > traditional way, which is protected by mmap_read_lock, and the RCU-based
> > per-VMA lock way which is based on RCU and refcounts.
> >
> > == Problem ==
> >
> > The mmap_lock one is more straightforward to use but it has a big
> > disadvantage in that it can not be mixed with page faults since those
> > can take mmap_lock for read, which can deadlock when mixed with nested
> > page faults and parallel writers.
> > For example:
> >
> > 	mmap_read_lock(mm);
> > 	// Another thread does mmap_write_lock().
> > 	// New mmap_lock readers are blocked.
> > 	vma = vma_lookup(mm, address);
> > 	// This deadlocks on mmap_read_lock() if it faults:
> > 	copy_from_user(address);
> > 	mmap_read_unlock(mm);
> >
> > The per-VMA lock can be mixed with faults, but they can fail and need to
> > be able to fall back to the traditional way.
> >
> > == Solution ==
> >
> > Add a variant of the RCU-based lookup that waits for writers. This is
> > basically the same as the existing RCU-based lookup, but on a failure to
> > lock it temporarily takes mmap_lock for read and waits for writers
> > to finish before locking the VMA, dropping the mmap_lock and returning
> > the locked VMA. This has some advantages:
>
> Maybe mention that the helper is called vma_start_read_unlocked()?
>
> >
> >  1. Callers do not need to have a fallback path for when they
> >     collide with writers.
> >  2. It can be used in contexts where page faults can happen because
> >     it can take the mmap_lock for read but never *holds* it.
> >  3. Its fast path does not require taking mmap_lock for read.
> >
> > Basically, when applied correctly, this approach results in faster
> > *and* simpler code.
> >
> > Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
> > Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> > Cc: Suren Baghdasaryan <surenb@google.com>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> > Cc: Lorenzo Stoakes <ljs@kernel.org>
> > Cc: Vlastimil Babka <vbabka@kernel.org>
> > Cc: Shakeel Butt <shakeel.butt@linux.dev>
> > Cc: linux-mm@kvack.org
> > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Cc: Arve Hjønnevåg <arve@android.com>
> > Cc: Todd Kjos <tkjos@android.com>
> > Cc: Christian Brauner <christian@brauner.io>
> > Cc: Carlos Llamas <cmllamas@google.com>
> > Cc: Alice Ryhl <aliceryhl@google.com>
> > Cc: "David S. Miller" <davem@davemloft.net>
> > Cc: David Ahern <dsahern@kernel.org>
> > Cc: netdev@vger.kernel.org
> > ---
> >  include/linux/mmap_lock.h | 15 +++++++++++----
> >  mm/mmap_lock.c            | 29 +++++++++++++++++++++++++++++
> >  mm/userfaultfd.c          |  6 ++++--
> >  3 files changed, 44 insertions(+), 6 deletions(-)
> >
> > diff --git a/include/linux/mmap_lock.h b/include/linux/mmap_lock.h
> > index eb32b482434e..fdd8f5cf5722 100644
> > --- a/include/linux/mmap_lock.h
> > +++ b/include/linux/mmap_lock.h
> > @@ -228,10 +228,12 @@ static inline void vma_refcount_put(struct vm_area_struct *vma)
> >  }
> >
> >  /*
> > - * Use only while holding mmap read lock which guarantees that locking will not
> > - * fail (nobody can concurrently write-lock the vma). vma_start_read() should
> > + * Use only while holding mmap read lock which guarantees that vma lock is not
> > + * contended (nobody can concurrently write-lock the vma). vma_start_read() should
> >   * not be used in such cases because it might fail due to mm_lock_seq overflow.
> >   * This functionality is used to obtain vma read lock and drop the mmap read lock.
> > + * VMA can't be detached while we are holding mmap lock, therefore in practice this
> > + * function can fail only when there are so many readers that vm_refcnt overflows.
> >   */
> >  static inline bool vma_start_read_locked_nested(struct vm_area_struct *vma, int subclass)
> >  {
> > @@ -247,16 +249,21 @@ static inline bool vma_start_read_locked_nested(struct vm_area_struct *vma, int
> >  }
> >
> >  /*
> > - * Use only while holding mmap read lock which guarantees that locking will not
> > - * fail (nobody can concurrently write-lock the vma). vma_start_read() should
> > + * Use only while holding mmap read lock which guarantees that vma lock is not
> > + * contended (nobody can concurrently write-lock the vma). vma_start_read() should
> >   * not be used in such cases because it might fail due to mm_lock_seq overflow.
> >   * This functionality is used to obtain vma read lock and drop the mmap read lock.
> > + * VMA can't be detached while we are holding mmap lock, therefore in practice this
> > + * function can fail only when there are so many readers that vm_refcnt overflows.
> >   */
> >  static inline bool vma_start_read_locked(struct vm_area_struct *vma)
> >  {
> >  	return vma_start_read_locked_nested(vma, 0);
> >  }
> >
> > +struct vm_area_struct *vma_start_read_unlocked(struct mm_struct *mm,
> > +					       unsigned long address);
> > +
> >  static inline void vma_end_read(struct vm_area_struct *vma)
> >  {
> >  	vma_refcount_put(vma);
> > diff --git a/mm/mmap_lock.c b/mm/mmap_lock.c
> > index e20d01e8d38f..6ff05e68e61b 100644
> > --- a/mm/mmap_lock.c
> > +++ b/mm/mmap_lock.c
> > @@ -338,6 +338,35 @@ struct vm_area_struct *lock_vma_under_rcu(struct mm_struct *mm,
> >  	return NULL;
> >  }
> >
> > +/*
> > + * Find the VMA covering 'address' and lock it for reading. Waits for writers to
> > + * finish if the VMA is being modified. Returns NULL if there is no VMA covering
> > + * 'address'.
>
> Hm but it can also return NULL when vm_refcnt overflows, in theory.
> Should we also return -EAGAIN (like uffd_lock_vma() below), or just retry in
> here and hope for the best? The latter would be simpler for the users.
> (AFAICS due to VM_REFCNT_LIMIT we never end up triggering the refcount
> saturation)

The problem is everything's unlocked so 'didn't find a VMA' doesn't really mean
much more than 'something went wrong' because hey maybe if you check again now
you'll find something :)

So I think this might be a feature more than a bug, especially given overflow is
not exactly likely.

>
> > + *
> > + * Use only in code paths where no mmap_lock and no VMA lock is held.
> > + *
> > + * The fast path does not take mmap_lock.
> > + */
> > +struct vm_area_struct *vma_start_read_unlocked(struct mm_struct *mm,
> > +					       unsigned long address)
> > +{
> > +	struct vm_area_struct *vma;
> > +
> > +	/* Fast path: return stable VMA covering 'address': */
> > +	vma = lock_vma_under_rcu(mm, address);
> > +	if (vma)
> > +		return vma;
> > +
> > +	/* Slow path: preclude VMA writers by temporarily getting mmap read lock. */
> > +	mmap_read_lock(mm);
> > +	vma = vma_lookup(mm, address);
> > +	if (vma && !vma_start_read_locked(vma))
> > +		vma = NULL;
> > +	mmap_read_unlock(mm);
> > +
> > +	return vma;
> > +}
> > +
> >  static struct vm_area_struct *lock_next_vma_under_mmap_lock(struct mm_struct *mm,
> >  							    struct vma_iterator *vmi,
> >  							    unsigned long from_addr)
> > diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> > index edd90892f8cc..c3a0c38a3dc3 100644
> > --- a/mm/userfaultfd.c
> > +++ b/mm/userfaultfd.c
> > @@ -129,8 +129,10 @@ struct vm_area_struct *find_vma_and_prepare_anon(struct mm_struct *mm,
> >   *
> >   * Should be called without holding mmap_lock.
> >   *
> > - * Return: A locked vma containing @address, -ENOENT if no vma is found, or
> > - * -ENOMEM if anon_vma couldn't be allocated.
> > + * Return: A locked vma containing @address, -ENOENT if no vma is found,
> > + * -ENOMEM if anon_vma couldn't be allocated, or -EAGAIN if vma refcount
> > + * overflow happened due to high number of readers and the caller should
> > + * retry later.
> >   */
> >  static struct vm_area_struct *uffd_lock_vma(struct mm_struct *mm,
> >  				       unsigned long address)
>

--
Cheers, Lorenzo

