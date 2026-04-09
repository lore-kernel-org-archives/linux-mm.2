Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2000FF364A6
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 18:03:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 25B0E6B0005; Thu,  9 Apr 2026 14:03:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 20C576B0089; Thu,  9 Apr 2026 14:03:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 122A46B008A; Thu,  9 Apr 2026 14:03:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 015D26B0005
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 14:03:47 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 53F101A0166
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 18:03:47 +0000 (UTC)
X-FDA: 84639790494.24.807DAA5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id B9BD2C0013
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 18:03:45 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fZj5N06X;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775757825;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/H2dWi1BsThheafcmx781nT7IuPmcwBrZFZzlDcfMCo=;
	b=TMvtzTU6TMl2FMJC11YPyY7k1OM0XrW+WLeW0biBqmK22i4VlWGZnSXu/rkLAY0XmZHnvP
	uzsVr1SRgUCsQs+SG5tqPB6dOrP1uCzcamZlOeYk3VH9hXB1oMVgsx64QuG4ct+WOWe9Pg
	l/DHqPMQyEXzoFXmE6OjcIUosntzJrk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775757825; a=rsa-sha256;
	cv=none;
	b=QVK3mhuc35FGCIoHwMxBwfN+ru+8bogMvgtWWcl12Te7g1i71a2zyOmntDqv/wax2bl96j
	nxQlXkqABTeytNKdN28MoebdT6v8hVfLFvEceBW/Kv9YUy3juYjnwqmrbvKL60uvhWy6rv
	NYKB3iJZyY5MWZ3kqPaINGFSNDBM5/I=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fZj5N06X;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 17A24600CB;
	Thu,  9 Apr 2026 18:03:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33E38C4CEF7;
	Thu,  9 Apr 2026 18:03:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775757824;
	bh=4dbCHZLjjXhxdr9gOsf+BIDy30Sqc5rBBMNQ7k7EzDo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fZj5N06XaWfYZYpq2na8TQKoYo3vPYHGjEucpEHkRv2YtNVXNDQe7mSmD46sopb9P
	 9uC5x1QvJyP0WgFrZBwT9Yqh2N0hbmaeQ/s+h55IEvCAVLnrkLKCAUm3OV7mE5MB8W
	 ELmqncnkrwmF7acIiIp/cAydEARB1UxlvqNH5DVN2xEZEcmVR7vcPmdt7T4+jUZZ92
	 k3k67yopanxGmZHy6T4a140EdqQtGvz1fycVAuTBuR1wLxrjHnnGySl4gapZoo5Vub
	 3Pzdz7i6ZOfFwHEk63iWcMhWzF3izYV7iydsgkRejhWscUy6Hm3aVXB/QxGNtjmoLR
	 Wi+5bOn2l0esw==
Date: Thu, 9 Apr 2026 19:03:41 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Hugh Dickins <hughd@google.com>
Cc: John Hubbard <jhubbard@nvidia.com>, 
	Joseph Salisbury <joseph.salisbury@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Peter Xu <peterx@redhat.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, 
	Barry Song <baohua@kernel.org>, linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] mm: stress-ng --mremap triggers severe lruvec lock
 contention in populate/unmap paths
Message-ID: <adfhGOHcg4AF3IFn@lucifer>
References: <a3474fcf-9f20-47ee-9d15-233e5c7e3f83@oracle.com>
 <4a4f5b48-8a1d-48f8-8760-0f5d43b5d483@nvidia.com>
 <982e5964-5ea6-eaf7-a11a-0692f14a6943@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <982e5964-5ea6-eaf7-a11a-0692f14a6943@google.com>
X-Rspamd-Queue-Id: B9BD2C0013
X-Stat-Signature: dfar16zdg8s4g4z4hc4fqn7rbp5aqmyi
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775757825-454376
X-HE-Meta: U2FsdGVkX19n2qcpNLhhQuwPpQl5hVBQrLWrLx31SwvVrBqQUh1eypT15ut07c65khj2qKubMzLRoTc7JcFMP/oUWRxRo19PAwa5a3PWqQxuz6jPkbWF9uAnhV3lmDmdam66Efn5X752fOivTsC0ZAfTdoWmwQlEO8rGPrkNGHfmBTYpTxnndhdR6DdM7iM2bhRtKpnp3E9ZDCaqSDBN8f+s0qYp4Dki2dg0eANnlVRYgN/ThiQOUWGgoVlCsJ2a6CweobxrZJaLML2ATA3EOHPBI6L7znl3dR25gZU/IvnEQASN99PU/FMoZ5CZqhZH+8QgzsMRXPWcDeMLRcRIlJfTSxQDegDXlm0xqOgQNM1bg4FQ2HS+qYR+SaMzYjoKavDv7vjCyg3jiDJtDMVvTIwldAu5M1kA+Ps+TXg9vNzOT17GUaqGXM1+68b1V6Gy8aOMxG/NNhl39iUzjUAck7MOZVz8Cl7cNUC/ud04SWyt9HRf+mGCDFq3+WwxO8mMNGG09NXDUN4/DiO1Kn1Minc+SeBhRrNSQicqtzXYTOzQ5G8rdM9O00C2pUtYFN5Uyt/zPKmVackvfs4thzdmoIVgkuoUnmFAfO/FlPx3xS3Zq7XMbaBtOk2/W6wYg7WsgibDslcifrW/+yzIVSEX5/0sGPo21P0iceFqqHAuy6Wb13dMYnjGyDdBY0AxbqFkLfo8guWOWoZrga5CBe/EFtzjIAzJh4w9kef/D7itawJtEaKvXqLTs/6xmUkH9xb5nKbDZShuDxZh3tdWtm4DWh1N3iqKxuCZia5vuu9SJez1SVdKChNstJaHu4RHvKasGyrRfYXz0fFAUZIvb8RVX4zwqYxkTXUcTE1BzxmSwTa4pt/kNU9TvX0WPaMiFweDYmzn2eiLSO9RCwJ3I+kxtaajpmKFeld8+peJXV5C7FKsb/00lhMKOlMWOXBRojXy43ibuLleJudorBbuXgy
 a/72BSmn
 Z+XV1mlNtF1AovjbJdjGbjJLPe7JCULQ4Ema0gJ2mhfkkmN/v0yyMDb1ElAWGbWPN22KQYsDXPN2ahyJeKIcPG/ZWux6Eefft+c7Zp3jZQ5/LXkSJfMHY02cvMvLVs2VWT+32KnMjVh1GXPyA4u3C7mJx6nS/5GvW3XYWln0s6ur4pTqFqZMDWCPMgI+owhQf2ofhA62/3WMchk2jKkG4niZ13CcRFzc+jmC7oxpXXALRH0XdxnlcpEExxANm5xCAzZ84n/jWrMCuBXw2Asri57bHJDELzixls3vfoHrC7sXgXck=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 07, 2026 at 05:35:18PM -0700, Hugh Dickins wrote:
> On Tue, 7 Apr 2026, John Hubbard wrote:
> > On 4/7/26 1:09 PM, Joseph Salisbury wrote:
> > > Hello,
> > >
> > > I would like to ask for feedback on an MM performance issue triggered by
> > > stress-ng's mremap stressor:
> > >
> > > stress-ng --mremap 8192 --mremap-bytes 4K --timeout 30 --metrics-brief
> > >
> > > This was first investigated as a possible regression from 0ca0c24e3211
> > > ("mm: store zero pages to be swapped out in a bitmap"), but the current
> > > evidence suggests that commit is mostly exposing an older problem for
> > > this workload rather than directly causing it.
> > >
> >
> > Can you try this out? (Adding Hugh to Cc.)
> >
> > From: John Hubbard <jhubbard@nvidia.com>
> > Date: Tue, 7 Apr 2026 15:33:47 -0700
> > Subject: [PATCH] mm/gup: skip lru_add_drain() for non-locked populate
> > X-NVConfidentiality: public
> > Cc: John Hubbard <jhubbard@nvidia.com>
> >
> > populate_vma_page_range() calls lru_add_drain() unconditionally after
> > __get_user_pages(). With high-frequency single-page MAP_POPULATE/munmap
> > cycles at high thread counts, this forces a lruvec->lru_lock acquire
> > per page, defeating per-CPU folio_batch batching.
> >
> > The drain was added by commit ece369c7e104 ("mm/munlock: add
> > lru_add_drain() to fix memcg_stat_test") for VM_LOCKED populate, where
> > unevictable page stats must be accurate after faulting. Non-locked VMAs
> > have no such requirement. Skip the drain for them.
> >
> > Cc: Hugh Dickins <hughd@google.com>
> > Signed-off-by: John Hubbard <jhubbard@nvidia.com>
>
> Thanks for the Cc.  I'm not convinced that we should be making such a
> change, just to avoid the stress that an avowed stresstest is showing;
> but can let others debate that - and, need it be said, I have no
> problem with Joseph trying your patch.

Yeah, the test case (as said by others also) is rather synthetic, and it's a
test designed to saturate, if not I/O throttled by swap then we hammer the
populate path. It feels like a micro-optimisation for something that is not (at
least not yet demonstrated to be) an actual problem.

stress-ng is not a benchmarking tool per se, it's designed to eek out bugs.

So really we need to see a real-world case I think.

>
> I tend to stand by my comment in that commit, that it's not just for
> VM_LOCKED: I believe it's in everyone's interest that a bulk faulting
> interface like populate_vma_page_range() or faultin_vma_page_range()
> should drain its local pagevecs at the end, to save others sometimes
> needing the much more expensive lru_add_drain_all().

I mean yeah, but I guess anywhere that _really_ needs to be sure of the drain
has to do an lru_add_drain_all(), because it'd be fragile to rely on
lru_add_drain()'s being done at the right time?

>
> But lru_add_drain() and lru_add_drain_all(): there's so much to be
> said and agonized over there  They've distressed me for years, and
> are a hot topic for us at present.  But I won't be able to contribute
> more on that subject, not this week.

Yeah they do feel rather delicate... :) sometimes you _really do_ need to know
everything's drained. But other times it feels a bit whack-a-mole.

I also do agree it makes sense to drain locally after a batch operation.

It all comes down to whether this manifests in a real-world case, at which point
maybe this is a more useful change?

>
> Hugh
>
> > ---
> >  mm/gup.c | 13 ++++++++++++-
> >  1 file changed, 12 insertions(+), 1 deletion(-)
> >
> > diff --git a/mm/gup.c b/mm/gup.c
> > index 8e7dc2c6ee73..2dd5de1cb5b9 100644
> > --- a/mm/gup.c
> > +++ b/mm/gup.c
> > @@ -1816,6 +1816,7 @@ long populate_vma_page_range(struct vm_area_struct *vma,
> >  	struct mm_struct *mm = vma->vm_mm;
> >  	unsigned long nr_pages = (end - start) / PAGE_SIZE;
> >  	int local_locked = 1;
> > +	bool need_drain;
> >  	int gup_flags;
> >  	long ret;
> >
> > @@ -1857,9 +1858,19 @@ long populate_vma_page_range(struct vm_area_struct *vma,
> >  	 * We made sure addr is within a VMA, so the following will
> >  	 * not result in a stack expansion that recurses back here.
> >  	 */
> > +	/*
> > +	 * Read VM_LOCKED before __get_user_pages(), which may drop
> > +	 * mmap_lock when FOLL_UNLOCKABLE is set, after which the vma
> > +	 * must not be accessed. The read is stable: mmap_lock is held
> > +	 * for read here, so mlock() (which needs the write lock)
> > +	 * cannot change VM_LOCKED concurrently.
> > +	 */

BTW, not to nitpick (OK, maybe to nitpick :) this comments feels a bit
redundant. Maybe useful to note that the lock might be dropped (but you don't
indicate why it's OK to still assume state about the VMA), and it's a known
thing that you need a VMA write lock to alter flags, if we had to comment this
each time mm would be mostly comments :)

So if you want a comment here I'd say something like 'the lock might be dropped
due to FOLL_UNLOCKABLE, but that's ok, we would simply end up doing a redundant
drain in this case'.

But I'm not sure it's needed?

> > +	need_drain = vma->vm_flags & VM_LOCKED;

Please use the new VMA flag interface :)

	need_drain = vma_test(VMA_LOCKED_BIT);

> > +
> >  	ret = __get_user_pages(mm, start, nr_pages, gup_flags,
> >  			       NULL, locked ? locked : &local_locked);
> > -	lru_add_drain();
> > +	if (need_drain)
> > +		lru_add_drain();
> >  	return ret;
> >  }
> >
> >
> > base-commit: 3036cd0d3328220a1858b1ab390be8b562774e8a
> > --
> > 2.53.0
> >
> >
> > thanks,
> > --
> > John Hubbard
>

Cheers, Lorenzo

