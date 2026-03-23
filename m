Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2CA8F483CC
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 17:06:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 26F0A6B0092; Mon, 23 Mar 2026 13:06:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 21EC96B0093; Mon, 23 Mar 2026 13:06:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E6F96B0095; Mon, 23 Mar 2026 13:06:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EDE446B0092
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 13:06:29 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A5C6D160C71
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 17:06:29 +0000 (UTC)
X-FDA: 84577956498.29.5FFC29F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id E1BB0100005
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 17:06:27 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gBrtZotL;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774285588; a=rsa-sha256;
	cv=none;
	b=B67GwSepbrUdM6pFToC2U2Kprgk63UWDrID01Q2vi5w6hdOSUn52/cRWPczXOnAxmOJzn3
	qnI02Wzz7RWrsJvzSh57T+U1kCxatRhGOpqyfBVv3uectgEXjZ9I8+rPU6E0jn18zAiUJm
	CxpPQ0+vyAEegUM9/10UYiMXPdotjEc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774285588;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7AbYXZVAo64yMv/t0GMlnyFCOuoGDEnAo2Edo1QAJ+A=;
	b=Bey3uo7zpLuTasEnS0+gvjgwaqNLTbIt0atHU9h7d+kBjS7O8rDO1GeP/45kyTJ21tCFPK
	RWh1Lk9+1apbZurB9SI0jTuy+b/gbvMKW7h3ztWCB6/wgMQ81DQj7Xo+b9filB1SSR6GDF
	HMZd1cjZROFl78WUwSVOLmudGMSkbxI=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gBrtZotL;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B440F4355A;
	Mon, 23 Mar 2026 17:06:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A2F4C4CEF7;
	Mon, 23 Mar 2026 17:06:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774285586;
	bh=yf/N67gBIH9jH5tj/eBx49WDNNHqQ6d8Xw/4r6JAHCM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gBrtZotLvmRDKY8PUXJxAp1tBrQUR32dB9tYBqsNEny19g53OQ97CArY/anhs9zIS
	 UZUfJEtN2iycEjxPmfE7T/4Qtx1BO5nDj5Uv4T6d5ECUvlLPIbJGcfKRjQ2brAtqOh
	 CBY8PBJiJEtvER62PyFGdjhsUaCI6jmLV0kuqmXaOTYLg3Zj7bxrVCERdYBwjNRXSf
	 G39opJMpfsEvC+DuINZiZ00MGyKg4yZk5OrpuKNQ29og8dXI13v2rdZovSgB9ID329
	 jGcJNl+HmB8DvfkJn2mSiLHYKCgwgTg7G9iZ7f2dSu4NFPLUQeNK/vuOgkHISiVfo1
	 KZaBDM/vav43A==
Date: Mon, 23 Mar 2026 17:06:21 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, david@kernel.org, 
	mhocko@kernel.org, zhengqi.arch@bytedance.com, yuzhao@google.com, 
	shakeel.butt@linux.dev, willy@infradead.org, Liam.Howlett@oracle.com, 
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] mm/vmscan: prevent MGLRU reclaim from pinning
 address space
Message-ID: <0f599835-9b99-4457-9ba7-a3eaeb0768d1@lucifer.local>
References: <20260322070843.941997-1-surenb@google.com>
 <f22cb9d9-7fc8-4a79-ada8-02d66a1155b2@lucifer.local>
 <CAJuCfpFqz3OvOrJOnYG8NF0gjzkzmSaiM0LZKD_aLoW9Br2srA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJuCfpFqz3OvOrJOnYG8NF0gjzkzmSaiM0LZKD_aLoW9Br2srA@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E1BB0100005
X-Stat-Signature: odix7743g33jjbmydd4shmnowhhegim3
X-HE-Tag: 1774285587-168860
X-HE-Meta: U2FsdGVkX18quNVdA7Gl/JXXMW6BORQo+NzyPZE4DuS4e1RdNGTka5C2mB3IusecDmk63o31Edc4AKKf57iJAib5NFTwl4T8N1sENlnVxRYsUrrKvDu18tVLrHCzWctl8s5lNXBxf+M2UD2E05grqiz++XkmB+ncQTqNbSH7MxAlYP1n5QYgQjTx3Rb/UZFE5qsYDdGSo5+NcxnaLMs+60Rcx1F+a37LdW0BG7q4QYm6ZTWvNOcy+KCUu9gxj59d25befVEgA8uEcbk5EdN9/P4l17dIYTctQBlKG5b7E5MitZzxzlsbFMnJg01Y45KJxJnEnKOj0QpMYM1YElT4/OxWUrxC3uzJooWHF4NU08g3NjK2n4Za6mkJtmyYzbIPBjzlMLEtGEsPS74oOe2FMC3sTW3wEZiM5DBp7VVT11HCn0Ed7gqlfu9983qaVlTUwf6Tpdiig7ar9FG2b/hltL32Ibs3wWsD/yh0+Ys+OpjcspQXym/5Vh2/vT7hsnMxImd+kzv0Y70pVSHtYYGJWCMFODy+AEn+X1OeoqNmjy6YT88kCXKQmGzjWo4BGXrAUrLDA2owqMVU1lpEGZnG+2/rbi7DpHhd2ErcXKG6WVFZ0NcDvznp7K9yec8BRJYnoVVFx/4oHff//eAlUk1aKOnp3+v0Q8aEQcYHGmIL3IjF2Tu0fBY9jlc/9fEVQeHT6OSuqYZkMwJyuIJXrB2mXiyo69pO99xb1g84Wo2qGCH/hC2n56/GmiEDJ3qFSa4RJKigyXRubEvytb/qmYOAvymXO+T8OjVHFkkn+T/2cRK7wi+N203sBRv7WW8f6cWGrx55Lt3JNiL/H+I86bizXFJRot7vTx0kyjXEwCDRDDyZOh4l4oypslqf7JEDXJbrLMASodN40uqxRJwsHvHny6CjwStaY4ydeE+tGEUMotS0wgkIMhTN2WgSPEULsWrWgHJUjkY5YmI3hPhG4Yn
 NwOmzS8A
 f5xoz6xojIxLg72OK20PjaxMRNJ8A/eja/fD23xnnlmTsctL+IxTTKlKPNVuuWj8gMHGSV/T2w4N91GyAfSbhNO6BonVvLDYHvtp7H0okGD9wiC/Rmi+KrrGKHwoejLux3xS/BMBV/tDXpP9LszbTkl3ISpcyEODgwsvzSUOJx08LH+QHg2IOW5MImB+ray8BIbrhzxZWwePBbAyJXGygmB9lRto6yNLgy2dZfacBW6Rdw+ySSc5lB3pU1qtTHqgRxahKi6hbsX560yoGCyB8KR14yNn4/f2XQlyNfR+mUqBFyKSnYvVyQd3mw4waqc85HIA91M00tOAsMEu1DS/YHHKjmw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 23, 2026 at 09:19:04AM -0700, Suren Baghdasaryan wrote:
> On Mon, Mar 23, 2026 at 6:43 AM Lorenzo Stoakes (Oracle) <ljs@kernel.org> wrote:
> >
> > On Sun, Mar 22, 2026 at 12:08:43AM -0700, Suren Baghdasaryan wrote:
> > > When shrinking lruvec, MGLRU pins address space before walking it.
> > > This is excessive since all it needs for walking the page range is
> > > a stable mm_struct to be able to take and release mmap_read_lock and
> > > a stable mm->mm_mt tree to walk. This address space pinning results
> >
> > Hmm, I guess exit_mmap() calls __mt_destroy(), but that'll just destroy
> > allocated state and leave the tree empty right, so traversal of that tree
> > at that point would just do nothing?
>
> Correct. And __mt_destroy() happens under mmap_write_lock while
> traversal under mmap_read_lock, so they should not race.

Yeah that's fair.

>
> >
> > > in delays when releasing the memory of a dying process. This also
> > > prevents mm reapers (both in-kernel oom-reaper and userspace
> > > process_mrelease()) from doing their job during MGLRU scan because
> > > they check task_will_free_mem() which will yield negative result due
> > > to the elevated mm->mm_users.
> > >
> > > Replace unnecessary address space pinning with mm_struct pinning by
> > > replacing mmget/mmput with mmgrab/mmdrop calls. mm_mt is contained
> > > within mm_struct itself, therefore it won't be freed as long as
> > > mm_struct is stable and it won't change during the walk because
> > > mmap_read_lock is being held.
> > >
> > > Fixes: bd74fdaea146 ("mm: multi-gen LRU: support page table walks")
> > > Signed-off-by: Suren Baghdasaryan <surenb@google.com>

Given you have cleared up my concerns, this LGTM, so:

Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

> > > ---
> > >  mm/vmscan.c | 5 +++--
> > >  1 file changed, 3 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > > index 33287ba4a500..68e8e90e38f5 100644
> > > --- a/mm/vmscan.c
> > > +++ b/mm/vmscan.c
> > > @@ -2863,8 +2863,9 @@ static struct mm_struct *get_next_mm(struct lru_gen_mm_walk *walk)
> > >               return NULL;
> >
> > Not related to this series, but I really don't like how coupled MGLRU is to
> > the rest of the 'classic' reclaim code.
> >
> > Just in the middle of vmscan you walk into generic mm walker logic and the
> > only hint it's MGLRU is you see lru_gen_xxx stuff (I'm also annoyed that we
> > call it MGLRU but it's called lru_gen_xxx in the kernel :)
>
> I don't have a strong opinion on this. Perhaps the naming can be
> changed outside of this series.

I was thinking more of a new file for mglru :>)

I believe we also need some more active maintainership also... but that's
another issue ;)

>
> >
> > >
> > >       clear_bit(key, &mm->lru_gen.bitmap);
> > > +     mmgrab(mm);
> >
> > Is the mm somehow pinned here or, on destruction, would move it from the mm
> > list meaning that we can safely assume we have something sane in mm-> to
> > grab? I guess this must have already been the case for mmget_not_zero() to
> > have been used before though.
>
> Yes, mm is stable because it's fetched from mm_list. When mm is added
> to this list via lru_gen_add_mm(mm) it is referenced and that
> reference is dropped only after lru_gen_del_mm(mm) removes the mm from
> this list (see https://elixir.bootlin.com/linux/v7.0-rc4/source/kernel/fork.c#L1185
> and https://elixir.bootlin.com/linux/v7.0-rc4/source/kernel/fork.c#L1187).
> Addition, removal and retrieval from that list happen under
> mm_list->lock which prevents races.

Ack, thanks!

>
> >
> > >
> > > -     return mmget_not_zero(mm) ? mm : NULL;
> > > +     return mm;
> > >  }
> > >
> > >  void lru_gen_add_mm(struct mm_struct *mm)
> > > @@ -3064,7 +3065,7 @@ static bool iterate_mm_list(struct lru_gen_mm_walk *walk, struct mm_struct **ite
> > >               reset_bloom_filter(mm_state, walk->seq + 1);
> > >
> > >       if (*iter)
> > > -             mmput_async(*iter);
> > > +             mmdrop(*iter);
> >
> > This will now be a blocking call that could free the mm (via __mmdrop()),
> > so could take a while, is that ok?
>
> mmdrop() should not be a heavy-weight operation. It simply destroys
> the metadata associated with mm_struct. mmput() OTOH will call
> exit_mmap() if it drops the last reference and that can take a while
> because that's when we free the memory of the process. I believe
> that's why mmput_async() was used here.

Yeah that's fair enough! Thanks.

>
> >
> > If before the code was intentionally deferring work here, doesn't that
> > imply that being slow here might be an issue, somehow? Or was it just
> > because they could? :)
>
> I think the reason was the possibility of calling mmput() -> __mmput()
> -> exit_mmap(mm) which could indeed block us for a while.

Yeah fair :)

>
> >
> > >
> > >       *iter = mm;
> > >
> > >
> > > base-commit: 8c65073d94c8b7cc3170de31af38edc9f5d96f0e
> > > --
> > > 2.53.0.1018.g2bb0e51243-goog
> > >
> >
> > Thanks, Lorenzo

Cheers, Lorenzo

