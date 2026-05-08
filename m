Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8D66CD3445
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 20:16:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 30A4E6B027B; Fri,  8 May 2026 16:16:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2BA526B027D; Fri,  8 May 2026 16:16:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 182816B027E; Fri,  8 May 2026 16:16:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 068586B027B
	for <linux-mm@kvack.org>; Fri,  8 May 2026 16:16:03 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 977911402E0
	for <linux-mm@kvack.org>; Fri,  8 May 2026 20:16:02 +0000 (UTC)
X-FDA: 84745358964.07.33F4E8B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 0E72D180007
	for <linux-mm@kvack.org>; Fri,  8 May 2026 20:16:00 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=u50BobTE;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778271361;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=demv1mqZnwNGl5Kj8AZTOMfQAd/QJ1SjuPDSgEm3lM4=;
	b=SRdrsp71WPQV/ccgkWz9yMF0+8a6+ZKT3yofRKdxj+YDApgV/Ez4pCnySPItwpnjKFTXOG
	wuBDtUcVpAWyTm6asYHKC9cb2UKONmeYMXR0sfqIaZmHdsS1P1OcMhe6lTvpi5gBrj7+KC
	ch/5yQR4ylrvC6vTtfLrMQ+Y13KQr8Y=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=u50BobTE;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778271361; a=rsa-sha256;
	cv=none;
	b=N9R9vz8iZ9OClYS/xUVUHiZaAcF5wzG604aFKgx8X6M1HbT8SIt6bqqtP0d48bmbMQaZwN
	lSLchCTqtfVLxSbb2D1g2jZrvjqes1vqYSvRcYp2uUcFm9eKDAALwbicziIG4s6l8i2d9a
	tonIFDnD+AzogbkM7XrQXJo8gWw+FYc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 91D8C6024D;
	Fri,  8 May 2026 20:16:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 305A7C2BCB0;
	Fri,  8 May 2026 20:15:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778271360;
	bh=EUVf7dVfM6XM6R0WF+nQvJgmitOqMSF+wWFDiR/8P30=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=u50BobTE1QWn5Dss5GpCc1Ihn3k46gGgAW7HalUO1pYsD2N+XIxnqiVJLnhBPtsFd
	 DSdsE4TAYeckiIBEBhrtp70KotUb3eYrsZ+LK+pNP/RlbZd1oJM4/iBK6iAbl80pKv
	 qdMZSBcTayhRWKTSPnR7uTJniE3Vn0y3cEz9o09EaUsTxTQTT+PAq2Kb0PHbk3kSv0
	 l3+Sx/iAkjLNZnC2dmKnXtYeMvRTi1M80HzEcbbJ0teC8gYrBZbEJqunXIG8J4u4k6
	 8jGPXLMylcnIRx4FeAeRQju8c4YFmIVKdsxVL+BDAqhuZitMus2mlrENPPy4M8+QV8
	 Nu2VCJiQeIh8g==
Date: Fri, 8 May 2026 21:15:54 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Dave Hansen <dave.hansen@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, linux-mm@kvack.org, 
	Shakeel Butt <shakeel.butt@linux.dev>, Suren Baghdasaryan <surenb@google.com>, 
	Vlastimil Babka <vbabka@kernel.org>
Subject: Re: [PATCH 3/6] mm: Add RCU-based VMA lookup that waits for writers
Message-ID: <af5C8bxEKEkQEjwV@lucifer>
References: <20260429181954.F50224AE@davehans-spike.ostc.intel.com>
 <20260429181959.BC9DABC5@davehans-spike.ostc.intel.com>
 <af4Zx0gJIWbdDeY2@lucifer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <af4Zx0gJIWbdDeY2@lucifer>
X-Stat-Signature: q6hshia1ue6r7m88ddisx7m3hr3sdads
X-Rspamd-Queue-Id: 0E72D180007
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778271360-246662
X-HE-Meta: U2FsdGVkX19yQHIFjXthnXYLRx983bTawXa5HW1jlUhIg7ub0m/puACDX8uc/Fkv1Jq/9bSNteaZ83Zp83cwwF++EmZiawgbGANDIvMSDAHdoOSIXOB6BObKmvnObjfXHK6MmxktgRhlLaWORBcSAeCQDbkNqnE/UAn8wpXlKhnVCeo2jTK9kPV9X9MZ9uKtZvC5t1PApatwP/3U1MK+t75NDkOPHHAzwX2Km0I/CtVwZq0SPNQVFsQYRlA5ak1RCDCDYmFuIw44c+iklz1yJngW2UGbIUm4qzuwVvNbVAiEWG5jp00DNh1+VpiJnTUoShImBZeq37BXQu1PpAzqLcxmYnSjK2+pCdQb+n6LxIKdlAHvrLfbakad/LEcijQgrIfpy7Okw+xwuwmdTd9UOgOhei7UEcY6vIXVPWJhhG4U6QcM8W5ERJDwutMecMVTxARE1qY7+FALONt2tAx+fwpEe26qgiLQzo8MTT8w3zn8PuqKYFesEjsv9rj2TVYHRhegqMMuHqJHAtIo9KgwmoK/qfhBGh9QObMV+0f7LC1d1NSvdK16+5rjzKsm6Fr3cpEhAXu8BAkW+vvCWVjS/QWc6mm/Ioius9YsKluLtoQZUAgzOgSlsjkR9BMYDlLRCbiu6LicE/wp5ggafuJZD0vaAVY/JeefDzAch3bDMJBvESMyebVdqgNyfjMqiYBLnKKGlq7SLYrHIrd7G9IWECH21dsyuH/XT91XIY5Nq0LQnUrh3OLbfCwY5BlHnTuWeGGyilU6gQ6sbC/xFpevGj+UHhMKGjgoYAVx2HSVIKz0ChfVZbv4D8w4pIBUrOKI2yihUs1tJiqOGlPbPz7f5E5iZactcslF1W3FMsCCSswjzutSudfANbHVFuIVceSo/ZInrzexHLvoUlP9pa6za89Q0Gz0WnSusH+KQUJYgZvflnLmg/HwAVpEq5jsoH1mpKq0MDY1lKbWiUbJwjG
 Pn85G9+C
 sbdynW79PWEerHYpp1QRFMiG+6WcBZR2Nmxm7qw4VGT793t4A3+6Bq1fICx2seXE2P2VVz8UbUbPrkOVuEOTS6tTVH1ein5BROawegDH8osZefaWaByjH5Cfpp6FR9dOwEJVJJX9l+Vzp4pNjAxxUdLSH15JJAU44OQnfksbDm4Oeq4uRRvkwj2PG4gMlLsdxMf0E1lNonZsiVr3jkq6OOhPa2LtLTNgZseYnsbgZzTyU7SvQq5n/76gSZEBe6nYr0BnpuBWoh88QJ20j9AobWPVcHY3jIN7J3Eml2YRiV8apdyEWiM3vnYkDrJJ67fl3oyh97CTw0zNFQNK4AqVp3uZ9bmQz2yQAI6qT/y4YTvzDtlqA715Gk7xewo3JByMAKtU7P/GYSrEn71c8Oylsm2P7chq3YBvR6czJpEwMBoYSWqQAnpod1yuXzsQaTQALutGMqY25oydrdDI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 08, 2026 at 06:26:57PM +0100, Lorenzo Stoakes wrote:
> On Wed, Apr 29, 2026 at 11:19:59AM -0700, Dave Hansen wrote:
> >
> > From: Dave Hansen <dave.hansen@linux.intel.com>
> >
> > == Background ==
> >
> > There are basically two parallel ways to look up a VMA: the
> > traditional way, which is protected by mmap_lock, and the RCU-based
> > per-VMA lock way which is based on RCU and refcounts.
> >
> > == Problems ==
> >
> > The mmap_lock one is more straightforward to use but it has a big
> > disadvantage in that it can not be mixed with page faults since those
> > can take mmap_lock for read.
> >
> > The RCU one can be mixed with faults, but it is not available in all
> > configs, so all RCU users need to be able to fall back to the
> > traditional way.
> >
> > == Solution ==
> >
> > Add a variant of the RCU-based lookup that waits for writers. This is
> > basically the same as the existing RCU-based lookup, but it also takes
> > mmap_lock for read and waits for writers to finish before returning
> > the VMA. This has two big advantages:
> >
> >  1. Callers do not need to have a fallback path for when they
> >     collide with writers.
> >  2. It can be used in contexts where page faults can happen because
> >     it can take the mmap_lock for read but never *holds* it.
> >
> > == Discussion ==
> >
> > I am not married to the naming here at all. Naming suggestions would
> > be much appreciated.
> >
> > This basically uses mmap_lock to wait for writers, nothing else. The
> > VMA is obviously stable under mmap_read_lock() and the code _can_
> > likely take advantage of that and possibly even remove the goto. For
> > instance, it could (probably) bump the VMA refcount and exclude future
> > writers. That would eliminate the goto.
> >
> > But the approach as-is is probably the smallest line count and
> > arguably the simplest approach. It is a good place to start a
> > conversation if nothing else.
> >
> > Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
> > Cc: Suren Baghdasaryan <surenb@google.com>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> > Cc: Lorenzo Stoakes <ljs@kernel.org>
> > Cc: Vlastimil Babka <vbabka@kernel.org>
> > Cc: Shakeel Butt <shakeel.butt@linux.dev>
> > Cc: linux-mm@kvack.org
> > ---
> >
> >  b/include/linux/mmap_lock.h |    2 ++
> >  b/mm/mmap_lock.c            |   43 +++++++++++++++++++++++++++++++++++++++++++
> >  2 files changed, 45 insertions(+)
> >
> > diff -puN include/linux/mmap_lock.h~lock-vma-under-rcu-wait include/linux/mmap_lock.h
> > --- a/include/linux/mmap_lock.h~lock-vma-under-rcu-wait	2026-04-29 11:18:50.633628887 -0700
> > +++ b/include/linux/mmap_lock.h	2026-04-29 11:18:50.707631737 -0700
> > @@ -470,6 +470,8 @@ static inline void vma_mark_detached(str
> >
> >  struct vm_area_struct *lock_vma_under_rcu(struct mm_struct *mm,
> >  					  unsigned long address);
> > +struct vm_area_struct *lock_vma_under_rcu_wait(struct mm_struct *mm,
> > +					  unsigned long address);
> >
> >  /*
> >   * Locks next vma pointed by the iterator. Confirms the locked vma has not
> > diff -puN mm/mmap_lock.c~lock-vma-under-rcu-wait mm/mmap_lock.c
> > --- a/mm/mmap_lock.c~lock-vma-under-rcu-wait	2026-04-29 11:18:50.704631622 -0700
> > +++ b/mm/mmap_lock.c	2026-04-29 11:18:50.707631737 -0700
> > @@ -340,6 +340,49 @@ inval:
> >  	return NULL;
> >  }
> >
> > +/*
> > + * Find the VMA covering 'address' and lock it for reading. Waits for writers to
> > + * finish if the VMA is being modified. Returns NULL if there is no VMA covering
> > + * 'address'.
> > + *
> > + * The fast path does not take mmap lock.
> > + */
> > +struct vm_area_struct *lock_vma_under_rcu_wait(struct mm_struct *mm,
> > +					       unsigned long address)
> > +{
> > +	struct vm_area_struct *vma;
> > +
> > +retry:
> > +	vma = lock_vma_under_rcu(mm, address);
> > +	/* Fast path: return stable VMA covering 'address': */
> > +	if (vma)
> > +		return vma;
> > +
> > +	/*
> > +	 * Slow path: the VMA covering 'address' is being modified.
> > +	 * or there is no VMA covering 'address'. Rule out the
> > +	 * possibility that the VMA is being modified:
> > +	 */
> > +	mmap_read_lock(mm);
> > +	vma = vma_lookup(mm, address);
> > +	mmap_read_unlock(mm);
> > +
> > +	/* There was for sure no VMA covering 'address': */
> > +	if (!vma)
> > +		return NULL;
> > +
> > +	/*
> > +	 * VMA was likely being modified during RCU lookup. Try again.
> > +	 * mmap_read_lock() waited for the writer to complete and the
> > +	 * writer is now done.
> > +	 *
> > +	 * There is no guarantee that any single retry will succeed,
> > +	 * and it is possible but highly unlikely this will loop
> > +	 * forever.
> > +	 */
> > +	goto retry;
> > +}
>
> Hmm yeah this is not ideal :)
>
> You don't have to do any of this we already have logic to help out here -
> vma_start_read_locked().
>
> That uses the fact the mmap read lock is held to pin the VMA lock, because VMA
> write locks require an mmap write lock, and the mmap read lock prevents them.
>
> That way you can eliminate the retry.
>
> So instead:
>
> /*
>  * Tries to lock under RCU, failing that it acquires the VMA lock with the mmap
>  * read lock held.
>  */
> struct vm_area_struct *vma_start_read_unlocked(struct mm_struct *mm,
> 					       unsigned long address)
> {
> 	struct vm_area_struct *vma;
>
> 	might_sleep();
>
> 	vma = lock_vma_under_rcu(mm, address);
> 	if (vma)
> 		return vma;
>
> 	/* Slow path: preclude VMA writers by getting mmap read lock. */
> 	guard(rwsem_read)(&mm->mmap_lock);

Actually we'd possibly want the killable version of this? So a fatal signal can
interrupt and not indefinitely block others.

> 	vma = vma_lookup(mm, address);
> 	/* VMA isn't there. */
> 	if (!vma)
> 		return NULL;
>
> 	return vma_start_read_locked(vma);

Sorry this should be:

 	if (!vma_start_read_locked(vma))
		return NULL;
	return vma;

But as per below not sure we will actually see vma_start_read_locked() fail, it
doesn't touch the write side sequence number so overflow shouldn't be a problem.

> }
>
> (Untested, not even build tested code)
>
> Not sure if we can use the linux/cleanup.h guard here, because mmap_read_lock()
> also does some trace stuff, but the guard makes it WAY nicer so (when it goes
> out of scope the mmap read lock is dropped).
>
> Maybe we could add a custom mmap lock guard to cover that too?
>
> Suren - I actually wonder if vma_start_read_locked() actually needs to return a
> boolean? The failure cases for __refcount_inc_not_zero_limited_acquire() are -
> detached or excluding readers on write/detach.
>
> But in both of those cases, vma_lookup() would surely not find the VMA, and
> since we're precluding writers (so no write lock, no detach possible) that means
> we should never hit it?
>
> Wonder if we should make it a void and add a VM_WARN_ON_ONCE()?
>
>
> > +
> >  static struct vm_area_struct *lock_next_vma_under_mmap_lock(struct mm_struct *mm,
> >  							    struct vma_iterator *vmi,
> >  							    unsigned long from_addr)
> > _
>
> Cheers, Lorenzo

