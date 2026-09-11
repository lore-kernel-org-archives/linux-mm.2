Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91DFBC88E53
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 18:11:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 78E816B0088; Fri, 11 Sep 2026 14:11:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 73F636B008C; Fri, 11 Sep 2026 14:11:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 62E016B0093; Fri, 11 Sep 2026 14:11:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3FF066B0088
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 14:11:10 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 73F52160306
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 18:11:09 +0000 (UTC)
X-FDA: 85202273058.08.525E8FD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id BEC9120004
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 18:11:07 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Qol0+QL5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Qol0+QL5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789150267;
	b=1z4jfRZHEVrRN77ThTS8RfPjJuHVi0RTSMRqil4QAqaVZMlJXzg0vv4/mEbfukhD0sCWm7
	Rsf7yWb4f/4+Lq2JB33K5EITds2ECgtIWh8LJVUc+CQdZaAdTVvKBleCK/NemGsx0qKFgt
	n0pOvM/7elrazJEzfkz5Aqf/sBJ8E84=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789150267;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zbceo/sKYCKvwSfA6gYi+fSUPm/FV0YzBbx3Kaa+7K4=;
	b=Jf53+Jbwx1zXXN+HVQ1p2NFpfTxfnk4hhS0NqsWtck9MFxdu4gp3g7uhPZ+LWgJI2u4kgN
	bIt4CtMz7oKTYvY8ySB4VLgzmr4IcCgIxzqjYYoIx2MHMTmsNZFycd+JgoJ9Z+ZMoYQBRU
	l0yAFtPMXHA86nc4eV0RzwcWj7Bi6H0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4775C41A80;
	Fri, 11 Sep 2026 18:11:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00A991F000FF;
	Fri, 11 Sep 2026 18:11:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789150266;
	bh=zbceo/sKYCKvwSfA6gYi+fSUPm/FV0YzBbx3Kaa+7K4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Qol0+QL5XFpE14QASX0HRNirwkB0icbiwkNEBhTU3gHzXlaNiHhxb2ttDVR/R2bOz
	 JrTM3vfpgNz3WdzEky0uyZd2uOcMps4oD0I+QFpROztnyhwu/5Wrt6dhJW8HBmCinn
	 p1432fKgICB9YHOSlqpRazo846ckBkh8YUlaXVQfIkp54bUF3iLHTf3Wa1V0ds/O/8
	 p4q3vJZlJuTOnZwqMLUNYYMRF+ab7L1L9hbSYjznQoM8WDhO8m8m5YWWERfff18o0d
	 Ry9fpTmkYd3NIg1GFCrdRWWnjd7OdXp/vU3V/VmYE54F6HGETOXGayp2qv5k7x384N
	 hTQEPusrLih0w==
Date: Fri, 11 Sep 2026 19:11:00 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: akpm@linux-foundation.org, liam@infradead.org, vbabka@kernel.org, 
	david@redhat.com, willy@infradead.org, jannh@google.com, paulmck@kernel.org, 
	pfalcato@suse.de, xueyuan.chen21@gmail.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v3 4/7] proc/task_mmu: remove special-casing of
 smap_gather_stats() start parameter
Message-ID: <aqREAsJK72xwXSzK@gremlin>
References: <20260910234737.1340642-1-surenb@google.com>
 <20260910234737.1340642-5-surenb@google.com>
 <aqQsWNfrBSp4DY_N@gremlin>
 <CAJuCfpEEi-9ZqhKR536tJHywprb9RFcx92gK00qp_ecBGH9Fvw@mail.gmail.com>
 <aqQ2M5bZv4k43j91@gremlin>
 <CAJuCfpG21qzef-yag3A9d22BUXnx2EFmbSvT=Zi5uRx_h7BxbA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJuCfpG21qzef-yag3A9d22BUXnx2EFmbSvT=Zi5uRx_h7BxbA@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: BEC9120004
X-Stat-Signature: atcqc6tymwqu7fw51oqutmxiiq5g5as7
X-Rspamd-Server: rspam01
X-HE-Tag: 1789150267-781378
X-HE-Meta: U2FsdGVkX1+aViCjtRduyxwIMtdSwSAnfEscCQZgGiOHp75qWPK5gwWvhjRSMPpVXJod1JC6Z7XR0+cHE1TNevxrO78xlih8hs3QlLPJPYepXgoGqx7JheWy43MXjxPVnuWMYkFsh9Al078TXJoCMgQkcfkmCAX6H0+eWrnX5aO+iIGpOQFQyLtS46zBT1QI87mir9961QiIfFNxc+FSoAAu+ldzPp6pfPrB0ZtFo0xwGcOFfcS0CKhUIHGv8i8LZnO4GYiA0Q5ZdgbPACMNlEFDadZ4nuazBT5LhYYkfoxDU6zFFnoY+XY92z2rpxtGOTNuBoFjc9KZQNz73A2wjm09YOObwjDeb34pY1XAkUXodBxwgdaww/cYBsg+SwB7zLW5lX81iDCuDUGGlt1G0otkM++K4+oF+zRUpRV61+iPK3AdiSi5IGYcLBV4S9uDVd4wbhHwnt77oMuLO3X6rrZaLUv2jhoQsjd0szK+IApvHwfHOkiirDqcX6SyHNaryIdRVqxFyeccZyBmScaH32wMQY/SxuQ/IowkjHXT071Y7cgC6WAQsAoz/A5+EU2GKRoao6ye7L0YrOnXGCklxx4PGMbSQgckONC0BgtAkWMpnSNwRQimQOjk5kRuo52nc/dXItHSgrzHiyASj7ClO9Gq5evHwBE/xxCgx5lubtGML+s3Yy3STHeHm9R+VJ7TUE93uWylHcllEHrZbaAwgl+kK07L1FKu4c0WSbpEAmhabMuJnnv8j8ZUj5A0k5uv3ZQqrJhJVJailBeG1ZOJZD2rTQmCdxlcL/R8YegCISOKRFzlXcb4NeWUtOdjwDOZMQQqT0K4pt3X0CClfWTfyDo3dJ4I26WKDSRUYUbxoYfKatDgDxnx8UhEhEUyMSl+gAKgcH4fukX/S3T1kk/JAWjGCawU5WdvGh2WVqhjwi2Pll89RCl2fXbiEGNvHx0TNjKNKUZvBT7Wd6TA6d8
 guoljNR/
 qzrhLZzpFkvMRU8ScEyvpCrZH6foqpjoTFKZKSV2l48SIgpFde3LfWJWflDVpTu+YbtX1chCJrZ4eTrnvJYDTdrf0GOr7x37hnzld8xlt2cRnQaL0B3ux2a/0Q9leGv7Wv2D3a2sTgi5hRry8/TeKTHztNgMoey/GHbWi3P6J3jok0t2N0Ixep/umTlwr1J1gOPu/dnop8zlDjcgjy9Np6zOVOsfaYca2kymewD5XGiTgxiXIPpPlh8+raKn2jmW/NxKi7Rb0YjxoeC1SUxCtQO1/zOkZE/X1IyIanLH+DR/MvWAOmsiv+3QOak9afY/x5cMa7CLZL6YmegGmxR2qDdZhQF91266V9qWFbvt4wKNBdt5vynUcqNc0PQtqW8KsH6iizLZ4em/hI8CnH5IHuBthJZKXYhhDuCLliOiTf3FOgeT/nwBDIZqv+l7COniKNdq3Hufs6efCYQCAqgXaau8Hv+HWgEPjuV6XbJhifTTRGhQ0FHvYWk3qhzMXU9YMRUZv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 11, 2026 at 11:06:28AM -0700, Suren Baghdasaryan wrote:
> On Fri, Sep 11, 2026 at 10:49 AM Lorenzo Stoakes (ARM) <ljs@kernel.org> wrote:
> >
> > On Fri, Sep 11, 2026 at 05:07:48PM +0000, Suren Baghdasaryan wrote:
> > > On Fri, Sep 11, 2026 at 4:39 PM Lorenzo Stoakes (ARM) <ljs@kernel.org> wrote:
> > > >
> > > > On Thu, Sep 10, 2026 at 04:47:34PM -0700, Suren Baghdasaryan wrote:
> > > > > smap_gather_stats() interprets its start parameter to mean vma->vm_start
> > > > > when it's set to 0. Eliminate this special interpretation and pass
> > > > > vma->vm_start explicitly when needed.
> > > > >
> > > > > Since smap_gather_stats() operates within a single VMA, we can replace
> > > > > walk_page_vma()/walk_page_range() calls with walk_page_range_vma()
> > > > > which is simpler and also can be called while holding per-VMA lock.
> > > > >
> > > > > No functional change intended.
> > > > >
> > > > > Suggested by: Lorenzo Stoakes <ljs@kernel.org>
> > > >
> > > > Hmm did I? Where did I suggest this?... I guess a while ago?
> > >
> > > In [1] on June 9, 2026.
> > >
> > > [1] https://lore.kernel.org/all/aifO_rCurVhFRTcl@lucifer/
> >
> > Yup a while ago :)
> >
> > >
> > > >
> > > > I mean I also happen to suggest it in the previous patch review :) but that was
> > > > sent after you sent this...
> > > >
> > > > > Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> > > > > Reviewed-by: Liam R. Howlett (Oracle) <liam@infradead.org>
> > > >
> > > > I don't love hacking a hack for a patch and then unhack it in the next in a
> > > > slightly roundabout way.
> > > >
> > > > Feels like this should be squashed. And a wrapper function for
> > > > start=vma->vm_start should be used rather than duplicating that param
> > > > constantly.
> > > >
> > > > > ---
> > > > >  fs/proc/task_mmu.c | 29 ++++++++++++++++-------------
> > > > >  1 file changed, 16 insertions(+), 13 deletions(-)
> > > > >
> > > > > diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> > > > > index 3c40c9cbb9c9..ecce7ce116cb 100644
> > > > > --- a/fs/proc/task_mmu.c
> > > > > +++ b/fs/proc/task_mmu.c
> > > > > @@ -1246,21 +1246,27 @@ get_smaps_shmem_walk_ops(struct proc_maps_private *priv)
> > > > >       return &smaps_shmem_walk_vma_lock_ops;
> > > > >  }
> > > > >
> > > > > -/*
> > > > > - * Gather mem stats from @vma with the indicated beginning
> > > > > - * address @start, and keep them in @mss.
> > > > > +/**
> > > > > + * smap_gather_stats() - Gather mem stats from @vma.
> > > > > + * @priv: proc maps private state.
> > > > > + * @vma: The VMA to gather stats for.
> > > > > + * @mss: The accumulated stats.
> > > > > + * @start: The address from which to start.
> > > > >   *
> > > > > - * Use vm_start of @vma as the beginning address if @start is 0.
> > > > > + * This gathers stats for the whole of the VMA unless the lock was dropped
> > > > > + * and VMA grew or got merged and we found it again, in which case we only
> > > > > + * gather stats for the remainder of the VMA range.
> > > >
> > > > This seems to be describing what callers do not what the function does unless
> > > > I'm missing something? So that's really the wrong place for it.
> > > >
> > > > I think the description of why it might be a partial walk belongs to the bit of
> > > > code that actually tries to do a partial walk.
> > > >
> > > > Anyway as per below I think separate partial/full functions make sense and there
> > > > it can simply be described as walking either the full or part of the VMA.
> > >
> > > This is verbatim of what you wrote at the end of [1]
> >
> > OK, I guess I disagree with myself of 3 months ago?
> >
> > The technical point being made here, which I think is the more constructive one
> > to engage with, is that this is a function that can be called with different
> > parameters for whatever reason.
> >
> > Somebody might decide to call it for another reason, putting something in the
> > description of the function that assumes what callers will do when that code can
> > change is asking for bit rot.
>
> Yeah, that makes sense.

Thanks.

>
> >
> > So as I suggested above:
> >
> >         I think the description of why it might be a partial walk belongs to the
> >         bit of code that actually tries to do a partial walk.
> >
> > I.e. I guess past me's description is apt, but belongs with the partial case.
>
> Ok, sounds like you want two separate functions supporting complete or
> partial walk. I don't have a strong preference here and it's easy to
> do like this:
>
> staic void smap_gather_stats_range(priv, vma, &mss, start)
> {
>         ....
> }
>
> staic void smap_gather_stats(priv, vma, &mss)
> {
>         smap_gather_stats_range(priv, vma, &mss, vma->vm_start);
> }
>
> Does that sound good?

Yeah that's the idea.

>
> >
> > >
> > > >
> > > > >   */
> > > > >  static void smap_gather_stats(struct proc_maps_private *priv,
> > > > >                             struct vm_area_struct *vma,
> > > > > -                           struct mem_size_stats *mss, unsigned long start)
> > > > > +                           struct mem_size_stats *mss,
> > > > > +                           unsigned long start)
> > > > >  {
> > > > >       const struct mm_walk_ops *ops = get_smaps_walk_ops(priv);
> > > > >       const bool is_partial = start > vma->vm_start;
> > > > >
> > > > >       /* Invalid start */
> > > > > -     if (start >= vma->vm_end)
> > > > > +     if (start < vma->vm_start || start >= vma->vm_end)
> > > > >               return;
> > > > >
> > > > >       if (vma == get_gate_vma(priv->lock_ctx.mm))
> > > > > @@ -1285,10 +1291,7 @@ static void smap_gather_stats(struct proc_maps_private *priv,
> > > > >                       mss->swap += shmem_swapped;
> > > > >       }
> > > > >
> > > > > -     if (!start)
> > > > > -             walk_page_vma(vma, ops, mss);
> > > > > -     else
> > > > > -             walk_page_range(vma->vm_mm, start, vma->vm_end, ops, mss);
> > > > > +     walk_page_range_vma(vma, start, vma->vm_end, ops, mss);
> > > >
> > > > I mean obviously am in favour of this as I suggested it in the last patch :)
> > > >
> > > > >
> > > > >       reacquire_rcu(priv);
> > > > >  }
> > > > > @@ -1343,7 +1346,7 @@ static int show_smap(struct seq_file *m, void *v)
> > > > >       struct vm_area_struct *vma = v;
> > > > >       struct mem_size_stats mss = {};
> > > > >
> > > > > -     smap_gather_stats(priv, vma, &mss, 0);
> > > > > +     smap_gather_stats(priv, vma, &mss, vma->vm_start);
> > > > >
> > > > >       show_map_vma(m, vma);
> > > > >
> > > > > @@ -1396,7 +1399,7 @@ static int show_smaps_rollup(struct seq_file *m, void *v)
> > > > >
> > > > >       vma_start = vma->vm_start;
> > > > >       do {
> > > > > -             smap_gather_stats(priv, vma, &mss, 0);
> > > > > +             smap_gather_stats(priv, vma, &mss, vma->vm_start);
> > > > >               last_vma_end = vma->vm_end;
> > > > >
> > > > >               /*
> > > > > @@ -1455,7 +1458,7 @@ static int show_smaps_rollup(struct seq_file *m, void *v)
> > > > >
> > > > >                       /* Case 1 and 2 above */
> > > > >                       if (vma->vm_start >= last_vma_end) {
> > > > > -                             smap_gather_stats(priv, vma, &mss, 0);
> > > > > +                             smap_gather_stats(priv, vma, &mss, vma->vm_start);
> > > >
> > > > I mean this is all horrible, having to pass vma->vm_start explicitly.
> > > >
> > > > Although better than the hack that gets compounded in patch 3.
> > > >
> > > > There 4 invocations of smap_gather_stats(), only one of them passes a
> > > > non-vma->vm_start start.
> > > >
> > > > So it'd make more sense to just make smap_gather_stats() lose its 3rd param and
> > > > have it call smap_gather_stats_range(), then have 1 invocation of
> > > > smaps_gather_stats_range() directly, as per suggestion in last patch.
> > > >
> > > > Or something similar to that.
> > >
> > > Hmm. Ok, I'll wait for you to read your previous suggestions in [1]
> > > and after that let's discuss what the final version should look like.
> >
> > I don't really think that's hugely constructive.
>
> I wasn't trying to offend in any way. Just wanted to give you some
> time to recall previous conversation and consolidate your position.
>
> >
> > I'm sorry I'm (mildly) disagreeing with my past self, I've sent tens of
> > thousands of words of review since then so I think it can be forgiven.
>
> Definitely. Again, I wasn't trying to blame or anything like that.
> Just pointing out our previous discussion and want to make sure we are
> on the same page (while having some fun in the process).
>
> >
> > In any case, I really do think:
> >
> >         smap_gather_stats(priv, vma, &mss);
> >         smap_gather_stats(priv, vma, &mss);
> >         smap_gather_stats(priv, vma, &mss);
> >         smap_gather_stats_range(priv, vma, &mss, last_vma_end);
> >
> > Works better than:
> >
> >         smap_gather_stats(priv, vma, &mss, vma->vm_start);
> >         smap_gather_stats(priv, vma, &mss, vma->vm_start);
> >         smap_gather_stats(priv, vma, &mss, vma->vm_start);
> >         smap_gather_stats(priv, vma, &mss, last_vma_end);
> >
> > ?
> >
> > I usually come back on review very quickly so I don't think this series
> > will be held up with any such change.
> >
> > But let me know if you think it's not a good idea technically.
>
> TBH I don't have strong preference but if you like it this way, it will be done.
> I'll post an update today since I don't think there will be more
> controversial parts. The biggest blunder on my part was the way I
> split patch 3 and 4.
> Thanks for the review!

I'd quite like to have a look through the rest of the series first.

>
> >
> > > Thanks,
> > > Suren.
> >
> > --
> > Cheers, Lorenzo

--
Cheers, Lorenzo

