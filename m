Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4FEB9C88E53
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 17:11:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4FE306B008C; Fri, 11 Sep 2026 13:11:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4AE636B0098; Fri, 11 Sep 2026 13:11:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3EC226B0099; Fri, 11 Sep 2026 13:11:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1B1006B008C
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 13:11:00 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BB5111A0327
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 17:10:59 +0000 (UTC)
X-FDA: 85202121438.20.9F26E36
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 17E2714000E
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 17:10:57 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ILJKIini;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789146658;
	b=718Q6Pt633f6ZuEUC2Zhfzv87ygUME2CFfwI2JVzKdlH/DR8A/Chg+kRUFwbVf8tQlINUk
	SoIFHEkrjfK6cgAFdhsYTW08nX7tI+1u/SsyUaEhWKpE1i4LGKmjthkT4GMoPXwHHtoy+C
	8qUc4kEiNTf1wrwXGHL07PUC3bg1ezM=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ILJKIini;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789146658;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iabiJzFuMBssAfyHTa9WjeB2ndYSQf+7FBqT74/kVEM=;
	b=TQ68lOr7aHpVMg6zqff2R289b8vB1BcauOUbHveMh1P7DH2CO/lNIYl2+951J8MXuC1ha2
	wjMpv5AKfobCJPMZClYP6KANrEKCVX/EiRidHwyrBbRp+2EvwJFduX3zs50kXIltfERaSj
	ETqCpVXf/mGoJRYWOUJi+nEfwixsThE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A4D8560008;
	Fri, 11 Sep 2026 17:10:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 495361F00898;
	Fri, 11 Sep 2026 17:10:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789146657;
	bh=iabiJzFuMBssAfyHTa9WjeB2ndYSQf+7FBqT74/kVEM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ILJKIinisqw0ioqYDzn6nsffUP6igzwaiG1ztbYuzd1b9ozZoSM/Jq6t4GS11YyCI
	 ko5fTxgbqXI3kof2+Y1gZibK1BUQ7Nz/Z/zKkoOX74zEhLk2XSOqo4VVb0cyGWpxQG
	 v14SKBX0BFfg+VdskI0Ob+NYl/FWGXGsAcHc8QB5qBhe/3RCSFUHOgHpXI6PaJUATA
	 9K0aZxtzhkZMRdjvZIgXhuXRaILAxKp8L0EbCM35NHzAc1SVjXQrZT94PZu6LbrHOa
	 0SzJj7IvmXsPfSsrVbeg+EsdVOy9tP56jWCpJQgScjuhrdRIO0E3kyxLgqwx5PxpT/
	 biR9hxrgcu34A==
Date: Fri, 11 Sep 2026 18:10:51 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: akpm@linux-foundation.org, liam@infradead.org, vbabka@kernel.org, 
	david@redhat.com, willy@infradead.org, jannh@google.com, paulmck@kernel.org, 
	pfalcato@suse.de, xueyuan.chen21@gmail.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v3 3/7] proc/task_mmu: clarify shmem mapping walk
 conditions in smap_gather_stats()
Message-ID: <aqQzk2AT05r6rOyT@gremlin>
References: <20260910234737.1340642-1-surenb@google.com>
 <20260910234737.1340642-4-surenb@google.com>
 <aqQoPTTUC9M5HkYb@gremlin>
 <CAJuCfpEHeFSMamNhf=FLvFjh9D8DBwZtbKwL0zi=x-2g8B+ENw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJuCfpEHeFSMamNhf=FLvFjh9D8DBwZtbKwL0zi=x-2g8B+ENw@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 17E2714000E
X-Stat-Signature: t8s4eu9e76icduwq9rjni7gbcn9wk7qf
X-HE-Tag: 1789146657-86703
X-HE-Meta: U2FsdGVkX1+momSMmvsgqq93Pn9siM77NDx/c50rwk7ZPmslkVv2N5OsW71GAEXJtqNYdKPvPwMPFuCAp8CgdJgXxWeHIiTKOpFFkr5EzshoAPdP+1l7WcRpzWG1d8qd+O8Oo6lrXop+2e2mpD+8QRsJVqWkhCTa7HOFlaZkZDdhytdh+mp29xUjk97BIyDXT4opHqTG+jhhkEWf9yfXMUd5Vow0YZruIR/i7+35K96B3YxOGsAPqkOfIZau5cZKkuzKdE6N/PpUFObdBONL4CrVQZEdk3I+Mo5LXKhYf9oSf2erbO0axYyGFsPLsfAdfoCpcNtcLrh/Um54feDU1jpMyn9VIWFgvf/erxNfcmX8lEgD/0X4ngKH0EodWw3x2QA/0geI7j6jzgRVsErUZTmAEPYIPqk+RRq5AbWjwChFCSSBmNfqjLnFUMaHlWnFNYl3H1XAXJScPFwufzqIqKytGLurd/B3gqGI0tE9fsrk3tkDVGr3fcSR/mSJAqQY/kkJzdKC3LDIHsQD1Niv8tkJpS6eR2uqHd/vmIg0UTa4JaZfDGtGUM+Zgij6NooruJQMABHvUmAk3DwDmvcCLlA4PQr2J1SbWN0E10G+T+KvwUCnqPNZnia5r6QdZka/2nc8OUhzFP7f108lJpiM0BJdQHRstsemFROG3uOLLsjUVFkuhf9yZ2hYBHD0o7D7hlNciBYoDZ65GTxTGhbC7uvYIxqlhJsA2MRR1FWnhcaFptKk3zAAGEmLsTFlWNFtWoyDs9lGBfhidPgqk5NY7LZhOz5RPRy2NIvYeQGLu5N6EFoRTO99eYkeliu36Jg8hewJGEO06wazY1bIieKKtsnPLOVmSVo6FgltApR6SBMfHChNcXEwskeHzLLRTnutE0MXzVxJ8AR66tMUTcXwleD9w2NCbGL5aPJmtKoq2GGaqq/jQzo0mMGyjN5JGrQD0mrcwkdVtV2MXo/M2+A
 mXmNUB8u
 slrGtlfcYX6U7gK6a1l+xtsrM/Or22mp2nMiXzP2O9losB3EsEoMTog5Bkt1W79Dm7LhiGxtdgDKJJjw4VNnNMipTCeB2x9UjsNF6hwqAcdB6CAND1GPiLqxwqS3QS4X/jkbh1UCZ/uWTFRCkLqUmRydk1bB/Wbhtdb/tCAepCQiI6ObHCfZ1/LM1upk+dyC7/tBMl1dxiWK6yli+Yp8LDPHKBl8DwGemhyEn2hVi8VanQf9zMOmVMXcRGHHfgQYlk3epNVfywS7JEjSkEHsacWKFAK+e/C+nZn/2soO9zFgP9zVsPi2qb3P8YEork0V733oG/hatzGiIywMcVtHxNfOA/3oBs847yPhUKahhoA1fTZh2p9wv46TMFcIfiLtuSGL9TGTy9bSK15IpHjnk+Y227r5wjKWJNsNQcPbaT2GjlAePKg3PMonCfjCi14941pX3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 11, 2026 at 04:58:40PM +0000, Suren Baghdasaryan wrote:
> On Fri, Sep 11, 2026 at 4:28 PM Lorenzo Stoakes (ARM) <ljs@kernel.org> wrote:
> >
> > On Thu, Sep 10, 2026 at 04:47:33PM -0700, Suren Baghdasaryan wrote:
> > > smap_gather_stats() optimizes stats gathering by skipping the walk for
> > > shmem mappings in certain conditions. Update the comment to clarify
> > > these conditions and use vma_is_cow_mapping() for COW identification
> > > instead of open-coding it.
> > > Instead of using (start != 0) condition to identify partial walks, use
> > > more semantically correct (start > vma->vm_start) check.
> >
> > I don't agree what you're doing is semantically correct, it's a hack really.
> >
> > Callers are passing start=0 to indicate that the entire VMA should be
> > processed and that happens to fulfil your criteria but in a surprising way.
> >
> > And the start in these cases is corrupted.
>
> Well, the "other" Lorenzo does not agree with you and suggested this
> approach in [1]. Specifically, see the comment:
> ```
> I also don't love that 0 is taken to be 'start from vma->vm_start' and I
> also don't love that the code in smap_gather_stats() actually special cases
> this...

I'm not sure what part of this is disagreement?

It's saying passing 0 is a hack, which is one that is still in place and which
this patch makes worse, because instead of explicitly calling out the invalid
value, you're treating it as if it were valid.

>
> How about passing last_vma_end and making smap_gather_stats() more sane? In
> the other invocation of smap_gather_stats() we could pass vma->vm_start
> here.

Yup, well me of 3 months ago should have suggested what I suggested re: wrapper
(I think you cut that suggestion out of my reply).

> ```
>
> [1] https://lore.kernel.org/all/aifO_rCurVhFRTcl@lucifer/

>
> >
> > >
> > > No functional change intended.
> > >
> > > Suggested by: David Hildenbrand (Arm) <david@kernel.org>
> > > Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> > > ---
> > >  fs/proc/task_mmu.c | 24 ++++++++++--------------
> > >  1 file changed, 10 insertions(+), 14 deletions(-)
> > >
> > > diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> > > index cfc7af1b551d..3c40c9cbb9c9 100644
> > > --- a/fs/proc/task_mmu.c
> > > +++ b/fs/proc/task_mmu.c
> > > @@ -1257,6 +1257,7 @@ static void smap_gather_stats(struct proc_maps_private *priv,
> > >                             struct mem_size_stats *mss, unsigned long start)
> > >  {
> > >       const struct mm_walk_ops *ops = get_smaps_walk_ops(priv);
> > > +     const bool is_partial = start > vma->vm_start;
> >
> > Yeah not in love with this, without changing how it's called.
>
> See [1]. This is exactly how you wrote it at the end of that reply.

Assuming you passed vma->vm_start, not 0? Passing 0 makes it really strange.

I see that in the patch I suggested I didn't update the other callers like I
said you should in the reply, my bad from 3 months ago, but I don't think that
invalidates what's been raised here.

>
> >
> > If you're reworking it all already, the actually semantically correct thing
> > I think would be to do something like:
> >
> > static void smap_gather_stats_range(struct proc_maps_private *priv,
> >                 struct vm_area_struct *vma, struct mem_size_stats *mss,
> >                 unsigned long start)
> > {
> >         ...
> > }
> >
> > Then to drop a parameter in smap_gather_stats() like:
> >
> > static void smap_gather_stats_range(struct proc_maps_private *priv,
> >                 struct vm_area_struct *vma, struct mem_size_stats *mss)
> > {
> >         smap_gather_stats_range(priv, vma, mss, vma->vm_start);
> > }
> >
> > And then you remove the hack and make is_partial not be accidentally true for an
> > invalid start parameter.
> >
> > >
> > >       /* Invalid start */
> > >       if (start >= vma->vm_end)
> > > @@ -1270,23 +1271,18 @@ static void smap_gather_stats(struct proc_maps_private *priv,
> > >
> > >       if (vma->vm_file && shmem_mapping(vma->vm_file->f_mapping)) {
> > >               /*
> > > -              * For shared or readonly shmem mappings we know that all
> > > -              * swapped out pages belong to the shmem object, and we can
> > > -              * obtain the swap value much more efficiently. For private
> > > -              * writable mappings, we might have COW pages that are
> > > -              * not affected by the parent swapped out pages of the shmem
> > > -              * object, so we have to distinguish them during the page walk.
> > > -              * Unless we know that the shmem object (or the part mapped by
> > > -              * our VMA) has no swapped out pages at all.
> > > +              * CoW mappings might map anon folios that do not belong to
> > > +              * shmem. Perform a less efficient page table walk in this
> > > +              * situation, unless we know that the shmem object (or the
> > > +              * part mapped by our VMA) has no swapped out pages at all.
> > >                */
> > > -             unsigned long shmem_swapped = shmem_swap_usage(vma);
> > > +             const unsigned long shmem_swapped = shmem_swap_usage(vma);
> > > +             const bool is_cow = vma_is_cow_mapping(vma);
> >
> > Nice to see this helper naturally slot in to new stuff :)
> >
> > >
> > > -             if (!start && (!shmem_swapped || (vma->vm_flags & VM_SHARED) ||
> > > -                                     !(vma->vm_flags & VM_WRITE))) {
> > > -                     mss->swap += shmem_swapped;
> > > -             } else {
> > > +             if (is_partial || (shmem_swapped && is_cow))
> > >                       ops = get_smaps_shmem_walk_ops(priv);
> > > -             }
> > > +             else
> > > +                     mss->swap += shmem_swapped;
> > >       }
> > >
> > >       if (!start)
> >
> > Also not absolutely in love with the fact you only use is_partial above and
> > leave:
> >
> >         if (!start)
> >                 walk_page_vma(vma, ops, mss);
> >         else
> >                 walk_page_range(vma->vm_mm, start, vma->vm_end, ops, mss);
> >
> > As-is.
> >
> > Should be:
> >
> >         if (is_partial)
> >                 walk_page_range(vma->vm_mm, start, vma->vm_end, ops, mss);
> >         else
> >                 walk_page_vma(vma, ops, mss);
>
> True, that can be changed here too. This whole block is replaced in
> the next patch though.

Yep I think that should be squashed into this one, as I say there.

>
> >
> > But I also wonder whether, with start not being corrupted (!) you could
> > just replace this with:
> >
> >         walk_page_range_vma(vma, start, vma->vm_end, ops, mss);
>
> Yep, that's done in the very next patch.

As above.

>
> >
> > Looking at the pagewalk.c implementations I don't know why
> > walk_page_range_vma() doesn't just forward [vma->vm_start, vma->vm_end) to
> > walk_page_range_vma()... but that's another thing :)
> >
> > > --
> > > 2.55.0.1007.g17ff1f9808-goog
> > >
> >
> > --
> > Cheers, Lorenzo

--
Cheers, Lorenzo

