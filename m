Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7473C88E4D
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 17:49:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 51EE86B0088; Fri, 11 Sep 2026 13:49:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4CE406B008C; Fri, 11 Sep 2026 13:49:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BCA06B0092; Fri, 11 Sep 2026 13:49:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0DD3F6B0088
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 13:49:44 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8CBE21202D1
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 17:49:43 +0000 (UTC)
X-FDA: 85202219046.05.E9A0B8A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id E687110000C
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 17:49:41 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=M4MufMKH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=M4MufMKH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789148981;
	b=WZKKficVQKKG05L95GrRyY0wwG9TvKW7kDvLahX7xogyrjEyFC59tK7jfZrBkENFCl0nB0
	V/ZT9PEYyeYuroxypmfdu52NQLsmfskjM5ej9gwQpI8mCGwDD3f/5dY9rYlDNnF93Vn6ak
	CDpRY3QUu2miAW6g9vhb7KC/wJOe5rI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789148981;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KhUmfw14OYrCY7IYDxm+oE9osdfjxhnvTL/bmLLDDXs=;
	b=m3EERvglHhak/VaAu3J/AWqmCoYTQDGPZ2jhRzVTuSp0c0DO3DPV/ehyfRGojMSA4bjumm
	4Njo447/BMGlE0F3lPDWtSnEZG5abEx/J57GyB9jK/dGcoqvRZ9nGCnfqsWmJuczOM0jqW
	HaQAwBOnM66rMMSZUk5/uQKO1/h+aBw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1984D60008;
	Fri, 11 Sep 2026 17:49:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B032F1F000FF;
	Fri, 11 Sep 2026 17:49:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789148980;
	bh=KhUmfw14OYrCY7IYDxm+oE9osdfjxhnvTL/bmLLDDXs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=M4MufMKHUE993PXmFUa5//tS1MwXXRI6RVYsEHwtGUtRTOmWBIADiF636pIJtIfsS
	 AWycC7rI/z172W22vhObsiUQCBLTomS5Yzl1uoLb5k30NaKuBd1uuNM2L7qPBtlcZW
	 DyellxC9QuDTLeV0nfksC+JHQ+Lwh/OkPhdPgroYgGyFQi651C0yFVjx99yaMcQhpu
	 jDssGCF/o4sMiabHw9KMHtV3bY/VRey1g1NlJR4EG6qrEEJmxTLbvuV9Yw+aKLXHgy
	 0jem5CyXSLwqujHjWKv0Hn+o7KhRqtWnfJLC70QH59GOABByK8dfkFarH5fzU7HHp7
	 iQDGeshUWiJaA==
Date: Fri, 11 Sep 2026 18:49:35 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: akpm@linux-foundation.org, liam@infradead.org, vbabka@kernel.org, 
	david@redhat.com, willy@infradead.org, jannh@google.com, paulmck@kernel.org, 
	pfalcato@suse.de, xueyuan.chen21@gmail.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v3 4/7] proc/task_mmu: remove special-casing of
 smap_gather_stats() start parameter
Message-ID: <aqQ2M5bZv4k43j91@gremlin>
References: <20260910234737.1340642-1-surenb@google.com>
 <20260910234737.1340642-5-surenb@google.com>
 <aqQsWNfrBSp4DY_N@gremlin>
 <CAJuCfpEEi-9ZqhKR536tJHywprb9RFcx92gK00qp_ecBGH9Fvw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJuCfpEEi-9ZqhKR536tJHywprb9RFcx92gK00qp_ecBGH9Fvw@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: E687110000C
X-Stat-Signature: pkbcnj5azi6n4sj9jxy34wrw96gqaooj
X-Rspamd-Server: rspam01
X-HE-Tag: 1789148981-167265
X-HE-Meta: U2FsdGVkX19axyyX7XtTWQPRWUfrGbggLKZ+0Phlg8k7fxnxRibtA72zvYI1OD5FveEaVrW1rr+vplQR8+HVgBvQ0QxO21rjpcr278IHeJTQrj7RSAUabBrOBpuSeHgh9GMYwRQhkMTDKlhQpA5bz2USn55LsCeoeNf0pjtg4f4Il+7YNohyzUu7Jh/xjHxnrmOB4DEaL1kb1l09fI0+OB4ePN1g42Gp5iFy6jXbdj7X4djgLVJPsVTMMbVLqmxCYXrgmmxjF0yYVTyjUznoA9UsoHbqqg2v6W3CRZ4xqchnh4fVbxHvmIurbL6+L/dAXcZKebeWEvyyDUtixlnAtH/3L+yXXK6RQ4H9fBwcHemR1ebiS+guxT7e8s8imG8vegvgA+/OLwg7DiJ47RB3LecYhYFIQ1AWCBcbkxvCbdGE4LF93KtoiAMXAURz7k7rWs5RdVinRZPSpKiphMJBHr0xAEYXPSxyXK+3iWXhxymlYWGoB8YTt8NA6/FL/lxMDlVVmM6ujbcbC+m1ispyZeXj218Oqweb16mu9L6S7FxTrPBrF6crqvzyJCN77NjyXZ7de8LSI5uzTjmnlciKBv3IjRdZysSLxf0603W97m2H/Lpof4ZfvK8cnzg8V6u8wwjHHqDJy7FtaCsMbHEsdbl0AuFmRnl4VxdNwJY+lWNBAXAPkGaGjEOKDMD4bdVTGNIPUzdqESiUO+ivf9EnaxD5tsU2pSNvWvfg9wjrEhHOH+wEMEzTOZmgVxc2SQsUg1hUfEXFzNbcZl+Wp+Yv09x9jkGzoHATinS8Uqhxhe0pmv8LpkfFa7nVdyy/WNjUO3yP/1UAYKzsCUtR0YydoWBorHd+s+VqzghmNu7tb9uEtXSEfD0uSrZZmMWHgztHu5iBScP+8ZWoUQWH6f0B0C+sYehVJlMxa/Ib3MmHw8dxqQgE1egb3ExuW78r5OMTX1fK98U8Urd8cpp8SGn
 9YhgidZX
 5pAnedZwZttvQGf8QD8CXSQtfr7JoH33Sbq+cQ0MTDtzCzJwk94tqIkaTnDLWo2EZNGnE/WTHcZ2tuC/Tdr0Vl1biA9JAU/ffF6/ukHXfIxc1bVgEkeMyMwewpRpGpt6w0Uv0Nm8b0KwnR4Hm2Pe9cxb4uTyLT7x1G0zbgsaC7D0Uk3Ke+dU5rIt6tYTY9p0J+RRNMqIMBQ1Nv6r9zE4UXFwMp1WpXDLP8VhaBZGMCxNa2otTzlHLVSxfSXHxKUqkk+pdEmwlZmnevuoo3tVLVn20WU+etx+DJyhK4eWtJTvhrzXmxlMyIe5gg88k5CiMQ1N7C+5JeopJRLbZZQJ1c2TUBOrQ9Nlwoy4U4sRSrjQ0P1yxwGn7NIvlknpOE1f+nH9yWYE+uJ4lah5QOwSTSBLe0A/6yz1vuWHZwikHEKRyyDeMP3AkxaUSvKQBwA2xYGILTiBCxEv87nqYHUfOv/Ej4tWeyBYRu0Y3rnR7aZA2iPDwkI8MGaTNRTpFhLtjQ1dp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 11, 2026 at 05:07:48PM +0000, Suren Baghdasaryan wrote:
> On Fri, Sep 11, 2026 at 4:39 PM Lorenzo Stoakes (ARM) <ljs@kernel.org> wrote:
> >
> > On Thu, Sep 10, 2026 at 04:47:34PM -0700, Suren Baghdasaryan wrote:
> > > smap_gather_stats() interprets its start parameter to mean vma->vm_start
> > > when it's set to 0. Eliminate this special interpretation and pass
> > > vma->vm_start explicitly when needed.
> > >
> > > Since smap_gather_stats() operates within a single VMA, we can replace
> > > walk_page_vma()/walk_page_range() calls with walk_page_range_vma()
> > > which is simpler and also can be called while holding per-VMA lock.
> > >
> > > No functional change intended.
> > >
> > > Suggested by: Lorenzo Stoakes <ljs@kernel.org>
> >
> > Hmm did I? Where did I suggest this?... I guess a while ago?
>
> In [1] on June 9, 2026.
>
> [1] https://lore.kernel.org/all/aifO_rCurVhFRTcl@lucifer/

Yup a while ago :)

>
> >
> > I mean I also happen to suggest it in the previous patch review :) but that was
> > sent after you sent this...
> >
> > > Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> > > Reviewed-by: Liam R. Howlett (Oracle) <liam@infradead.org>
> >
> > I don't love hacking a hack for a patch and then unhack it in the next in a
> > slightly roundabout way.
> >
> > Feels like this should be squashed. And a wrapper function for
> > start=vma->vm_start should be used rather than duplicating that param
> > constantly.
> >
> > > ---
> > >  fs/proc/task_mmu.c | 29 ++++++++++++++++-------------
> > >  1 file changed, 16 insertions(+), 13 deletions(-)
> > >
> > > diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> > > index 3c40c9cbb9c9..ecce7ce116cb 100644
> > > --- a/fs/proc/task_mmu.c
> > > +++ b/fs/proc/task_mmu.c
> > > @@ -1246,21 +1246,27 @@ get_smaps_shmem_walk_ops(struct proc_maps_private *priv)
> > >       return &smaps_shmem_walk_vma_lock_ops;
> > >  }
> > >
> > > -/*
> > > - * Gather mem stats from @vma with the indicated beginning
> > > - * address @start, and keep them in @mss.
> > > +/**
> > > + * smap_gather_stats() - Gather mem stats from @vma.
> > > + * @priv: proc maps private state.
> > > + * @vma: The VMA to gather stats for.
> > > + * @mss: The accumulated stats.
> > > + * @start: The address from which to start.
> > >   *
> > > - * Use vm_start of @vma as the beginning address if @start is 0.
> > > + * This gathers stats for the whole of the VMA unless the lock was dropped
> > > + * and VMA grew or got merged and we found it again, in which case we only
> > > + * gather stats for the remainder of the VMA range.
> >
> > This seems to be describing what callers do not what the function does unless
> > I'm missing something? So that's really the wrong place for it.
> >
> > I think the description of why it might be a partial walk belongs to the bit of
> > code that actually tries to do a partial walk.
> >
> > Anyway as per below I think separate partial/full functions make sense and there
> > it can simply be described as walking either the full or part of the VMA.
>
> This is verbatim of what you wrote at the end of [1]

OK, I guess I disagree with myself of 3 months ago?

The technical point being made here, which I think is the more constructive one
to engage with, is that this is a function that can be called with different
parameters for whatever reason.

Somebody might decide to call it for another reason, putting something in the
description of the function that assumes what callers will do when that code can
change is asking for bit rot.

So as I suggested above:

	I think the description of why it might be a partial walk belongs to the
	bit of code that actually tries to do a partial walk.

I.e. I guess past me's description is apt, but belongs with the partial case.

>
> >
> > >   */
> > >  static void smap_gather_stats(struct proc_maps_private *priv,
> > >                             struct vm_area_struct *vma,
> > > -                           struct mem_size_stats *mss, unsigned long start)
> > > +                           struct mem_size_stats *mss,
> > > +                           unsigned long start)
> > >  {
> > >       const struct mm_walk_ops *ops = get_smaps_walk_ops(priv);
> > >       const bool is_partial = start > vma->vm_start;
> > >
> > >       /* Invalid start */
> > > -     if (start >= vma->vm_end)
> > > +     if (start < vma->vm_start || start >= vma->vm_end)
> > >               return;
> > >
> > >       if (vma == get_gate_vma(priv->lock_ctx.mm))
> > > @@ -1285,10 +1291,7 @@ static void smap_gather_stats(struct proc_maps_private *priv,
> > >                       mss->swap += shmem_swapped;
> > >       }
> > >
> > > -     if (!start)
> > > -             walk_page_vma(vma, ops, mss);
> > > -     else
> > > -             walk_page_range(vma->vm_mm, start, vma->vm_end, ops, mss);
> > > +     walk_page_range_vma(vma, start, vma->vm_end, ops, mss);
> >
> > I mean obviously am in favour of this as I suggested it in the last patch :)
> >
> > >
> > >       reacquire_rcu(priv);
> > >  }
> > > @@ -1343,7 +1346,7 @@ static int show_smap(struct seq_file *m, void *v)
> > >       struct vm_area_struct *vma = v;
> > >       struct mem_size_stats mss = {};
> > >
> > > -     smap_gather_stats(priv, vma, &mss, 0);
> > > +     smap_gather_stats(priv, vma, &mss, vma->vm_start);
> > >
> > >       show_map_vma(m, vma);
> > >
> > > @@ -1396,7 +1399,7 @@ static int show_smaps_rollup(struct seq_file *m, void *v)
> > >
> > >       vma_start = vma->vm_start;
> > >       do {
> > > -             smap_gather_stats(priv, vma, &mss, 0);
> > > +             smap_gather_stats(priv, vma, &mss, vma->vm_start);
> > >               last_vma_end = vma->vm_end;
> > >
> > >               /*
> > > @@ -1455,7 +1458,7 @@ static int show_smaps_rollup(struct seq_file *m, void *v)
> > >
> > >                       /* Case 1 and 2 above */
> > >                       if (vma->vm_start >= last_vma_end) {
> > > -                             smap_gather_stats(priv, vma, &mss, 0);
> > > +                             smap_gather_stats(priv, vma, &mss, vma->vm_start);
> >
> > I mean this is all horrible, having to pass vma->vm_start explicitly.
> >
> > Although better than the hack that gets compounded in patch 3.
> >
> > There 4 invocations of smap_gather_stats(), only one of them passes a
> > non-vma->vm_start start.
> >
> > So it'd make more sense to just make smap_gather_stats() lose its 3rd param and
> > have it call smap_gather_stats_range(), then have 1 invocation of
> > smaps_gather_stats_range() directly, as per suggestion in last patch.
> >
> > Or something similar to that.
>
> Hmm. Ok, I'll wait for you to read your previous suggestions in [1]
> and after that let's discuss what the final version should look like.

I don't really think that's hugely constructive.

I'm sorry I'm (mildly) disagreeing with my past self, I've sent tens of
thousands of words of review since then so I think it can be forgiven.

In any case, I really do think:

	smap_gather_stats(priv, vma, &mss);
	smap_gather_stats(priv, vma, &mss);
	smap_gather_stats(priv, vma, &mss);
	smap_gather_stats_range(priv, vma, &mss, last_vma_end);

Works better than:

	smap_gather_stats(priv, vma, &mss, vma->vm_start);
	smap_gather_stats(priv, vma, &mss, vma->vm_start);
	smap_gather_stats(priv, vma, &mss, vma->vm_start);
	smap_gather_stats(priv, vma, &mss, last_vma_end);

?

I usually come back on review very quickly so I don't think this series
will be held up with any such change.

But let me know if you think it's not a good idea technically.

> Thanks,
> Suren.

--
Cheers, Lorenzo

