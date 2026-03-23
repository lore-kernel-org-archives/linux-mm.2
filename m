Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96BE7F483DC
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 17:24:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C9C7A6B0005; Mon, 23 Mar 2026 13:24:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C74296B0088; Mon, 23 Mar 2026 13:24:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B89FD6B008A; Mon, 23 Mar 2026 13:24:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A6ACF6B0005
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 13:24:44 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 74C901B9329
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 17:24:44 +0000 (UTC)
X-FDA: 84578002488.03.07A9AC7
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	by imf06.hostedemail.com (Postfix) with ESMTP id 776C5180015
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 17:24:42 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=bpoXOPvP;
	spf=pass (imf06.hostedemail.com: domain of surenb@google.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774286682;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EENMDJuPt1/wC+9AwgZxeJeO2jus0zq24DCPRVPT7Ao=;
	b=BV0q9m22TYSa46a3S4U8fL59s4kv/x5GuHqR2QAr3Y0VazjbOmFLp4u/BZEOpghRFPw4Ve
	SsFtf/xCHmjIZqwg19HFV9w/rE4c8atSBu/T58NLV7IWVoAHFkLioBOuvdDIEHfUbv6y9c
	6oVjmvAlafiLBWOSvw2aR+4L36SlcEY=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=bpoXOPvP;
	spf=pass (imf06.hostedemail.com: domain of surenb@google.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774286682; a=rsa-sha256;
	cv=pass;
	b=2NDue41OGdfpK4KnT6tgBSPSJ7rF+CEd9x8/jmyUKVGxULrQFREOYKNeeDaPOoHLaDlDvS
	92pVdFKF0zALXiZhK5Dj7a3rBSUM+lFAApxFkClnNpIFJ2VxZViMWqNyKgjNIdZutHv7cF
	clhUvWszFvOhdBgfFNb5pSREX18U0UY=
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-509062d829dso37061cf.1
        for <linux-mm@kvack.org>; Mon, 23 Mar 2026 10:24:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774286681; cv=none;
        d=google.com; s=arc-20240605;
        b=J9gDnDroS9JeMK6ogLtMug7VWP28evjjPJtS7vyAtAkqJjwP8PS3od693k7VuR/NM5
         KDrtC6bRU3pYK/1sBByo8oxN+93+u8sGNnEAAYGC4cqjzNd9EVM8S2ayQ4JSGkRKa8/F
         x5zR/9id3gW457xLmQmXaOK/JH0Ly25/Cjsqfy6Yl6sKQ4dJMvklruFUcGzU6ucMX3m9
         tLyMLm+r4jTZqN4vGze+nf/PVHaj9gfOQg97Ib/bpsW+Kg1pjEWZ8aC2WaSP5+9U96i6
         1TeD/q6Uci9fEl1SXm22gJxNHnq39JDb1P7GOFgswN8utYpGpH9ibvp4DehnNWfK/kQu
         gYvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=EENMDJuPt1/wC+9AwgZxeJeO2jus0zq24DCPRVPT7Ao=;
        fh=eyzYRebPgjEPdbIrZXjhg+r3R1GK2vbIC2onrYnzXHA=;
        b=bSI1eNWZ31lOM0DYMee6PeSrkEYdhjSHzwo7PCkhH+E+FIRVDoVhpVf29Pfw1n4cqe
         fcpuHQ2+p7zdh4Bdz6V5jjAqnFnMtoqtsVuLdk5OFRDOCwsPObvNkDCcrnAg/pS3zI/p
         fjcNlcoyWBSWjgjone71ViV74HaUXZoPyKbsnJg7Ykhlp8vVK0iWZFJjXwGXwBWiTg83
         p7C6U+oT5e7yfCBHTZmuFtzdT5c1l3Ix1Ho5nygofARC7/3i/4k0G1Esrz8Loge/rkUP
         Oe+fuGTeShv23Mw54yWk48P2FLAWTKSE8XNsxLMZBy1i1EvHsJav8RL3romwljiIX93y
         yvEQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774286681; x=1774891481; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EENMDJuPt1/wC+9AwgZxeJeO2jus0zq24DCPRVPT7Ao=;
        b=bpoXOPvPJDO6HNw8XHqrg87h+JjVDeUS78KN3HrN/2OaqBMsBcK9QMxu0x6XJbjCtN
         HVG+axeXkK11vhwTgTa7Q3jXlY5kHEdTNw3mFNlENCILmalKSTASpKSCDifDcpKl2wsH
         lz/IDK9ixkip7fVbcaKsQfVQua/nxvxoirfuIDyp4T5cb7Y2ecwJjj+h0u3wCZavAX5l
         WjkO2vle/4mZ+sdNXdDYjDAtIxvzEd7dnnhv786s3g+kJryFbPEQeQQR2H1tTQ2hucLd
         Ph+MIYqvlrTAbp6DjcbvwXxWVlHSMUuss4j4xwENLqCFimRGFkWzKNNu0ASoZ4JGV+Sd
         TvIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774286681; x=1774891481;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=EENMDJuPt1/wC+9AwgZxeJeO2jus0zq24DCPRVPT7Ao=;
        b=PXA52J/d0chW4nBPwn31fOhYy7dzTVESCW2exbmOpl7p7g+GSlXxewBDjO4K2MSc1s
         gGKyFlEMZ+kZ1fzY4I/5qVlJfaVk/bs1CfeoS41A3kgSF2UZz7T88aQch31H3gMtsbVk
         fznJ1lQTTLCsbNoBLFlzBdtaAnJ+12HDqebYUtT1s2rsHtdVbUZX5wrXmw6/M6/2RzdU
         d5S0D5Cm6yhpcWSP3TOUmA8MbFcHKMhKsd3tljgJ0MevkSIZzsQdQIJ6WDuUjF1uL78C
         QHMm/ukiHg6JMRAqwAwqm5m5P1N8dWt6C8XbUlT6dKHdvoV4lE2LLnOiyRyM41eeKKvF
         XIRA==
X-Forwarded-Encrypted: i=1; AJvYcCWpF01CQwOPbpkD745WwK9Hnj4DUSm14sGXNqpTZ9Mjq6grbjXbb0nc0WGefcTGRIKMRYHcUkxbSQ==@kvack.org
X-Gm-Message-State: AOJu0Yx8qyc+xZGplUjNTHdaVPih58Wn2lG43NbMxpbhkG+8PlWZHOeG
	blhLxZWSUOW9ZkZ8YFDr08CtMOK+dWOS3ApVPk9TffcWB/rk3ZB5c++EkJ3BsOSH6Xv5DjypA43
	4YJ7BLAeHjvkHg+roxxqwURX7etmccwvbLhf3xACV
X-Gm-Gg: ATEYQzzOwLIJnLxXOOtp+b82tnvMMUGuaQ16vGgoTSlHSF9s8LfG9/pqfgsyMcTWcPP
	Bn5JJbYYVYwW+Ac/l+V4nCam/b9aGtyisDsGnurKLGQqgj+qUQUc8eEMqgpq2x0RZCO5vAq/p98
	tQhxjfg6gp3Luwv0wCi6XWP4zloSvIxccXrdEkqI9lwsZfdwFUWDWO1WBi34cxfcOe1eL6hoUJY
	ROP8wnPZM+Uc20VG9OpqYTrQIiCFyvb/uP3YXpQEvZO6DInXIg6+WJcgnA161IgSKwWYRbnj796
	96j9lJDUr26SVKh/
X-Received: by 2002:a05:622a:8c17:b0:4e8:aa24:80ec with SMTP id
 d75a77b69052e-50b6fbdc5a5mr421821cf.14.1774286680828; Mon, 23 Mar 2026
 10:24:40 -0700 (PDT)
MIME-Version: 1.0
References: <20260322070843.941997-1-surenb@google.com> <f22cb9d9-7fc8-4a79-ada8-02d66a1155b2@lucifer.local>
 <CAJuCfpFqz3OvOrJOnYG8NF0gjzkzmSaiM0LZKD_aLoW9Br2srA@mail.gmail.com> <0f599835-9b99-4457-9ba7-a3eaeb0768d1@lucifer.local>
In-Reply-To: <0f599835-9b99-4457-9ba7-a3eaeb0768d1@lucifer.local>
From: Suren Baghdasaryan <surenb@google.com>
Date: Mon, 23 Mar 2026 10:24:29 -0700
X-Gm-Features: AQROBzATtRMQC7P98aqgjFqe-Vkzt8p74uDwcOgaEGZGmzrPdqys3EnKbBzfF6o
Message-ID: <CAJuCfpFs8zD0Xmh3=Z8MwgOxBzzHPhpGzm3XOMHqk715qN=qQA@mail.gmail.com>
Subject: Re: [PATCH 1/1] mm/vmscan: prevent MGLRU reclaim from pinning address space
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, david@kernel.org, 
	mhocko@kernel.org, zhengqi.arch@bytedance.com, yuzhao@google.com, 
	shakeel.butt@linux.dev, willy@infradead.org, Liam.Howlett@oracle.com, 
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 776C5180015
X-Stat-Signature: bi61fyobim7zj7ia9nx6sfzu978eegc9
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774286682-636265
X-HE-Meta: U2FsdGVkX19UApMZbXridjUmhpM0EPQFTjcT1+SDgNwAfqPskhePDqcThShI744rU2aMC3XGpnG/hwXgyDaKpW0X+fD57/9vY91fNBwcRZDDJ/CHQ//UW7ysQOZaJi9SG2qrqQxYoMmnr2GYTYklYeYMfudHuoSB+W520LJC9AmH/niiWGcCAWed2aJvRH0MFqmEQs49ZyLb4t7G/HwQscNE5+XQl4HTht19lUqSYNeN8XAJvQXkXS2QhnhlTeX0ek+73nw3NTX0BZuFrjgfCP3n9ZwqIMT0CLOgFMxmiurcSpjfrlvXB9RkYYtp78uXDFvjd+P3b/CdjK+dy452x9oE83G8Hc5lxJa2dcHilVLbZQtVjGvzUd3FSTmoyNs3uxHCv6sZm1vm+dm9gVIYBZKhZ8Y4WaFxQjWYtuwVm312RM7Y0Mpo5ndFdEVdfOutVx2P9rf7KAi91Nk2QCADoZSvYOcX5b9YI0sKOzIYXJJnR9pEsD0OpIjyFgbTDKk0Vv/nMRZJ+NfFNCJi/vIkM6TDk8Jx8t9bwI8ONEFEGcpYorCEvuKGQyaUaM0YAhkJ3/NC9S9CqOYiSRTzdj31ij6wJ8mGe9dC3rT+lPvJkYyddobxzvT3oW5BSxt6sn5gTRFKvCHCILjQp4aqjyk75xgZGRel1DzgOfd3hKixtMWNZwDQ06VeqnWnwJe8ydpyAoKhF5fYRB3mipcTwXrhVQh4dgbHhT3vrS84MZPn2RIwOS4pT20P/9mazPAiPEYgPEvhS6HEI1WZsHnU0OptXmd+qgH85vjqpGb5XjjlOn/DSD9V9hF05r4Q+gI68j+pFgRs6xu6C1ufv/HRS1LmmlgfZg/wDMLA30MAvoNi1fx3qUs4KLURM0gu+AQE0f4RJj4yjl+3qsT06vES/tz4d8ptG9+0fZKHpSrT7zXYjB/t7bp6pzLExL9UvRs6/LQNbUVQIbscF383dZrzrZV
 4lnd2qqk
 irXOgkhUHs9TvrldziDRLTbbpFmoL4ESpyIidKCbDpN986y52R8GDuzVKSjiTIAvcJSSEhuXteaRr9t0eMEx1H11YPTzXA/EX103dvzs/mxlqeVv0TUtSxtZczvDiMFmWEOmi7bA8qI+k4G17ewWm1pkvZ/oLnD8X4cAeaYKniNqTxDRX6rGGF2pLtFVC+nzb+8TX5QrOC86YIpHj2Z3UDEElCR2MMh+vcfjd9IZu/N5Wy7ePYMtIzWNppqC0CN8nApnMUfWOdcHK/iwMANY5iGdYlbhKaBF30GhOGoJokovhF4b+c08lh2N70gqG15AFQ2LgCMX8Ej0HK+RNhOrZmTi1kQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 23, 2026 at 10:06=E2=80=AFAM Lorenzo Stoakes (Oracle)
<ljs@kernel.org> wrote:
>
> On Mon, Mar 23, 2026 at 09:19:04AM -0700, Suren Baghdasaryan wrote:
> > On Mon, Mar 23, 2026 at 6:43=E2=80=AFAM Lorenzo Stoakes (Oracle) <ljs@k=
ernel.org> wrote:
> > >
> > > On Sun, Mar 22, 2026 at 12:08:43AM -0700, Suren Baghdasaryan wrote:
> > > > When shrinking lruvec, MGLRU pins address space before walking it.
> > > > This is excessive since all it needs for walking the page range is
> > > > a stable mm_struct to be able to take and release mmap_read_lock an=
d
> > > > a stable mm->mm_mt tree to walk. This address space pinning results
> > >
> > > Hmm, I guess exit_mmap() calls __mt_destroy(), but that'll just destr=
oy
> > > allocated state and leave the tree empty right, so traversal of that =
tree
> > > at that point would just do nothing?
> >
> > Correct. And __mt_destroy() happens under mmap_write_lock while
> > traversal under mmap_read_lock, so they should not race.
>
> Yeah that's fair.
>
> >
> > >
> > > > in delays when releasing the memory of a dying process. This also
> > > > prevents mm reapers (both in-kernel oom-reaper and userspace
> > > > process_mrelease()) from doing their job during MGLRU scan because
> > > > they check task_will_free_mem() which will yield negative result du=
e
> > > > to the elevated mm->mm_users.
> > > >
> > > > Replace unnecessary address space pinning with mm_struct pinning by
> > > > replacing mmget/mmput with mmgrab/mmdrop calls. mm_mt is contained
> > > > within mm_struct itself, therefore it won't be freed as long as
> > > > mm_struct is stable and it won't change during the walk because
> > > > mmap_read_lock is being held.
> > > >
> > > > Fixes: bd74fdaea146 ("mm: multi-gen LRU: support page table walks")
> > > > Signed-off-by: Suren Baghdasaryan <surenb@google.com>
>
> Given you have cleared up my concerns, this LGTM, so:
>
> Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

Thanks!

>
> > > > ---
> > > >  mm/vmscan.c | 5 +++--
> > > >  1 file changed, 3 insertions(+), 2 deletions(-)
> > > >
> > > > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > > > index 33287ba4a500..68e8e90e38f5 100644
> > > > --- a/mm/vmscan.c
> > > > +++ b/mm/vmscan.c
> > > > @@ -2863,8 +2863,9 @@ static struct mm_struct *get_next_mm(struct l=
ru_gen_mm_walk *walk)
> > > >               return NULL;
> > >
> > > Not related to this series, but I really don't like how coupled MGLRU=
 is to
> > > the rest of the 'classic' reclaim code.
> > >
> > > Just in the middle of vmscan you walk into generic mm walker logic an=
d the
> > > only hint it's MGLRU is you see lru_gen_xxx stuff (I'm also annoyed t=
hat we
> > > call it MGLRU but it's called lru_gen_xxx in the kernel :)
> >
> > I don't have a strong opinion on this. Perhaps the naming can be
> > changed outside of this series.
>
> I was thinking more of a new file for mglru :>)
>
> I believe we also need some more active maintainership also... but that's
> another issue ;)

Yes, in my team I volunteered one developer to actively review and
support MGLRU. Over time I hope he will be in a position to help with
maintenance.

>
> >
> > >
> > > >
> > > >       clear_bit(key, &mm->lru_gen.bitmap);
> > > > +     mmgrab(mm);
> > >
> > > Is the mm somehow pinned here or, on destruction, would move it from =
the mm
> > > list meaning that we can safely assume we have something sane in mm->=
 to
> > > grab? I guess this must have already been the case for mmget_not_zero=
() to
> > > have been used before though.
> >
> > Yes, mm is stable because it's fetched from mm_list. When mm is added
> > to this list via lru_gen_add_mm(mm) it is referenced and that
> > reference is dropped only after lru_gen_del_mm(mm) removes the mm from
> > this list (see https://elixir.bootlin.com/linux/v7.0-rc4/source/kernel/=
fork.c#L1185
> > and https://elixir.bootlin.com/linux/v7.0-rc4/source/kernel/fork.c#L118=
7).
> > Addition, removal and retrieval from that list happen under
> > mm_list->lock which prevents races.
>
> Ack, thanks!
>
> >
> > >
> > > >
> > > > -     return mmget_not_zero(mm) ? mm : NULL;
> > > > +     return mm;
> > > >  }
> > > >
> > > >  void lru_gen_add_mm(struct mm_struct *mm)
> > > > @@ -3064,7 +3065,7 @@ static bool iterate_mm_list(struct lru_gen_mm=
_walk *walk, struct mm_struct **ite
> > > >               reset_bloom_filter(mm_state, walk->seq + 1);
> > > >
> > > >       if (*iter)
> > > > -             mmput_async(*iter);
> > > > +             mmdrop(*iter);
> > >
> > > This will now be a blocking call that could free the mm (via __mmdrop=
()),
> > > so could take a while, is that ok?
> >
> > mmdrop() should not be a heavy-weight operation. It simply destroys
> > the metadata associated with mm_struct. mmput() OTOH will call
> > exit_mmap() if it drops the last reference and that can take a while
> > because that's when we free the memory of the process. I believe
> > that's why mmput_async() was used here.
>
> Yeah that's fair enough! Thanks.
>
> >
> > >
> > > If before the code was intentionally deferring work here, doesn't tha=
t
> > > imply that being slow here might be an issue, somehow? Or was it just
> > > because they could? :)
> >
> > I think the reason was the possibility of calling mmput() -> __mmput()
> > -> exit_mmap(mm) which could indeed block us for a while.
>
> Yeah fair :)
>
> >
> > >
> > > >
> > > >       *iter =3D mm;
> > > >
> > > >
> > > > base-commit: 8c65073d94c8b7cc3170de31af38edc9f5d96f0e
> > > > --
> > > > 2.53.0.1018.g2bb0e51243-goog
> > > >
> > >
> > > Thanks, Lorenzo
>
> Cheers, Lorenzo

