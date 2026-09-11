Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D01A1C88E53
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 18:06:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C40806B0095; Fri, 11 Sep 2026 14:06:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCA6D6B0096; Fri, 11 Sep 2026 14:06:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A6AD66B0098; Fri, 11 Sep 2026 14:06:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 734466B0095
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 14:06:44 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id ECF19C0325
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 18:06:43 +0000 (UTC)
X-FDA: 85202261886.01.D5EDFE6
Received: from mail-qk2-f12.google.com (mail-qk2-f12.google.com [74.125.230.204])
	by imf14.hostedemail.com (Postfix) with ESMTP id 02591100009
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 18:06:41 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=t746YEiK;
	spf=pass (imf14.hostedemail.com: domain of surenb@google.com designates 74.125.230.204 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789150002;
	b=1nc/zBbA2fwMZR2CI98+A+9nXu3ZrP+65m9p44AVCe9ALcdA7PAytnm1kqPe/KpJwPZg8d
	Z7azQ9Z1zc01H17g79G+RpQl62m1beZVkb2HG4T63aCiLUhoplpF0QnmlDCo+PqU9Sm1RZ
	fb4Ug0/IpEcJt2DeHxXrVviy9kgzrWc=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=t746YEiK;
	spf=pass (imf14.hostedemail.com: domain of surenb@google.com designates 74.125.230.204 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789150002;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L0Iac+7+1XRJVGRm7qhhyrQds1DwdpS7YmgEfvKp+Z4=;
	b=TtkLJtG3hYh7w0xeVgSpRCXJDwPpOYtpdhDf3nI0JvXDOpi01Uroucy58FgEG3EW1rUpg0
	1egI+qcBzRF4X5Cipv1GNnIBhUqCvArcs4VCkvcVXB6ZVFVeSVvWccOwgrxK7co9Jqgq7X
	aMrEUJpZHlCpYTQmC08b7kZdhnikruI=
Received: by mail-qk2-f12.google.com with SMTP id d75a77b69052e-530d5fc2cd8so74221cf.1
        for <linux-mm@kvack.org>; Fri, 11 Sep 2026 11:06:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789150001; cv=none;
        d=google.com; s=arc-20260327;
        b=UnGj/Cz2mUbtYU3lS8gnD3coJSTnagJ0UkV3M6PfSCF9OH+8XsUJz1knEORn9c0ek6
         Z8cwtDYVhaeWukyb7fV0EnVCoYVM1wzFlOyzwJspUkdF6ZHjOmrLKAzD089RiTYixDdz
         m00EmmM9jk0nIdOrKC1r8qV1of/mwiALamA5tY4CkxLQ7C84xFaXBH3DNueXcIe8y0yA
         h92huynvcJpgCxqCQltU+E4xVLpSnkeQZ24iChFr4UPiMQ5jKtczn/TRQK21/0DsnhZ/
         JvaThn80oiLa5wgQn0SMt9xlgHNSDAADkniukQ7OgyV20q1HE9hA9FBxWCcFm9u7SChp
         /G7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=L0Iac+7+1XRJVGRm7qhhyrQds1DwdpS7YmgEfvKp+Z4=;
        fh=RB523Ud3Oijd8a6EUS2NwFlNQXGNhJuJsiG53UkOAAE=;
        b=FT6b/ontlB2JGnFd/+UOHtLav5MU7gFlZihEmrjPxjqNuR5eGwT22Bhn9VD6DbfAUK
         8fzkaQDnoXufndBeW0GSCB1fDVKXqlgZMPv176/TMekOvvlXsP4F5RRqV1QvBY1ldXZU
         4xn9Yc5hvzl80cYEbJOd9K+ih3gFG8xORKgkv+4nIOFgoRc+xYDJJP/wBBUeOetU/K3m
         uvwoHIxDzO2Cqc2BN/o7kaaXQbE9QGKRqB1+QpfYjDvRt4l4Dol944DYRpbkEVVifnJ8
         P9B2J3WONPGp0n+rgfVmI/Xl7jSYc3Z+bmTowEHDZyToAv1zJmHtd8fbo0WAIC+seDRA
         nZUQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789150001; x=1789754801; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=L0Iac+7+1XRJVGRm7qhhyrQds1DwdpS7YmgEfvKp+Z4=;
        b=t746YEiKWizoBDJhEbjnKfvtKHCQGp7gnYJEFl5+BSdsEtNoENlii7TS3yZWckFE7s
         zPRC+biBh29Nfq1uIVeObwTIdD9hiG5y8FRLPQMcyPDF7Tc59RfM+gIqgqEVpjaYCtMR
         S9gFMZN3MdIWrR2SHdIOte1WalRyvqgx9lN0Z1EOWd3YxzpGt/2DpyZkQs8eVE5BBkOy
         dNAKwaZDZVyhTwyCSHCyWnzCEJx5uSMweeFpN0aZhP83HQzVuBWHcqZUqsRc7iUA79CZ
         mkH9I7lfZeqUu0sFiha9lxSzs1JpjG2z7LNk2NGwzo3VrzQoHpmxSTvXh1Axqih7tNrX
         YAxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789150001; x=1789754801;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=L0Iac+7+1XRJVGRm7qhhyrQds1DwdpS7YmgEfvKp+Z4=;
        b=pCfm9KCQjLJOpyoG2iljNNwOHqg6TASr5d4nx+R6ZX27nEgpyWk4ZhKISmnd1gy7jm
         YSoFmhYOW5VFGvgdsfmZ3NgyNPrTKFnSbEaN/Jxot0mleDWo2X1VGmDmtJNaoidHmlBV
         ZxlFfNPSzPw2aWpEJ/U91P8NmO2YZ1ygzzHzSIx0ay7sRo4+qa84lEm1gijRyjV6Pwfa
         6q6gYRD+xzd5/Jag/6sFDuwmNQoFzvWKrsl8pRTKJXaNGq2t4OiZdAgp1yfUbjROL0Vn
         ZE1/j0F24m26FEl+m0+hyEJ1k1Nur1sTiAur/ncqEmica11b1pDg08bgTh2NetQt+0NU
         bwsA==
X-Forwarded-Encrypted: i=1; AKwUvBwaRBKaa3sSm+awdTmOwosJRCubthUoJ+mYHvS2pPRDk3qiapOMcjCmefKCys3avufC8wXPbkfJMw==@kvack.org
X-Gm-Message-State: AFuF++nxJ+WRXpIqu8XLwkRut5j56Vu/1Sl+TLHHvwOsb8YHTEK/YVVd
	8x/+2bSLwcmdamDrnSgvTu4BtgDDCGqcuGO2U1p3btakLPDS7p6KIRbFHO09fIcTnQzylRDPfwJ
	bZXURTMCjAPNJh3PuqBxigQvo/wEz1Zw+d+tehGnS
X-Gm-Gg: AYBFou0hVshYpHMAwFUPk2vq1BkJy/fsEtdKZ+IodmY2sty+lmk8cUGid7lc3k3k/GT
	14b6+6BMBO5/Ck3ZvBMma+4FGdlXRgFBzcUw+leEMeDixbpfgN33HROmE1by5/RYen57UBjJYst
	SiX33pM7hJmLlveFXZ1iGFGfDuyXF6KUJ0ppfVmQzf0imUury39J0wf4YwVWBHZV3AiDmF/CzMf
	q3O5pUQEp2ZoL2j5GObqzTci5HOLx9xG7tRsFd2no1w/lufhgTJt3grM5HqLOvnPo104SRS2I/X
	nAysSkU7whBfMqgHpDohyQfL7zn7AsPekKVgp0QyEeSOC/6Q3/7T9uzlfZDnKJNDiXoQJRTfO7L
	TkByqCwof2g==
X-Received: by 2002:a05:622a:c0c:b0:51c:ca9:3d17 with SMTP id
 d75a77b69052e-530e468d6f2mr1048401cf.12.1789150000015; Fri, 11 Sep 2026
 11:06:40 -0700 (PDT)
MIME-Version: 1.0
References: <20260910234737.1340642-1-surenb@google.com> <20260910234737.1340642-5-surenb@google.com>
 <aqQsWNfrBSp4DY_N@gremlin> <CAJuCfpEEi-9ZqhKR536tJHywprb9RFcx92gK00qp_ecBGH9Fvw@mail.gmail.com>
 <aqQ2M5bZv4k43j91@gremlin>
In-Reply-To: <aqQ2M5bZv4k43j91@gremlin>
From: Suren Baghdasaryan <surenb@google.com>
Date: Fri, 11 Sep 2026 11:06:28 -0700
X-Gm-Features: AcwNN1XJcFI1qpSul5kFpPRx9O73QUYS1FieU23uJkjNgjnxdeFXxY6hqfMzzMg
Message-ID: <CAJuCfpG21qzef-yag3A9d22BUXnx2EFmbSvT=Zi5uRx_h7BxbA@mail.gmail.com>
Subject: Re: [PATCH v3 4/7] proc/task_mmu: remove special-casing of
 smap_gather_stats() start parameter
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: akpm@linux-foundation.org, liam@infradead.org, vbabka@kernel.org, 
	david@redhat.com, willy@infradead.org, jannh@google.com, paulmck@kernel.org, 
	pfalcato@suse.de, xueyuan.chen21@gmail.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 02591100009
X-Rspam-User: 
X-Stat-Signature: if3j18ddttuhrhof95scuginkqbq9oct
X-HE-Tag: 1789150001-966342
X-HE-Meta: U2FsdGVkX18oQ0DqMuUN0kYk37yDZeKGwUaLfxJJoITjpVXUJ4TIoeFRhhboYYlaJJMcbRxpx+HpKGbHv/xCLeC2UW1f0CQi41C3t75WzenlpgK7ISoX9RVmPnMtR0VEvZxrf+D8Q84soAio1Yy8nNXft0Pgf0dQ4WQnZLKmfx67goG1pC9JyO9O+t8Eeh71lgeKcidW5Mj9AfIz/b0LTwUAzZN04yuauMicTfHHZDhWFA4KRApbcgUeKnVRJbK8XVlSwRP+hmJXgUSHc6wbYKoBPuNTqENC6GGkKXEqovxOc2PCEj28HritWtFOOvxtNf95Wod35/zScP8YPAyIF50jX2z1gtTQLwJtwrK/F/NctVQSVDmIkEDOEPrBQzxto9nyTiONmJ1T6Fq/71k2LHhNwofyIskYkSs8Rb18xe+gCcQPDVKghULD+XZdVkT2tvDO0vHwJJMl2WFeu6Q0ANfZRUAQ086U52nFROYm0DpjSCnn3S5ol5/01Y+wnniEEeereWHiXKUfppyc9M/jiVd2FvwudFjZ+0yBKq+TI6KZ7ez2mHwkxlfuX7B6ciCBqBjido9Qn9oC5sCBtVrqt3P8mXVERpLlLqFw9Aicz8eq047l8cjaMQZbrgcQwC+OsWYu0Koczi81iXCtJ6+9qJA/8yoU1wZ1L2ql21lOp3MLMuKdM9yKq/6arm3vPAtWZhSx2WhJGFAXnTHzN3E8hKCZ04RNC087Diqo8/ncnj5yz3qMjcWRUqa3c8Ns4D9TUEY+oI2gbiP0qgy7Apxg59He2iscovG61uWURhtWGUKKFIyKXmgo/hUvKhZsNOILSbEp9isvHX8Gxunt5RcTd4+eHNmvzNqjtydkgwyy9qREFC7fRaKwUt+rKiueQxwrtVI1aFvrjLvBE+hjYvv4BGxIaGtkt50bhRQeim/EUvYh5H++CjuFyKlByVooor1++Bhh0neqi8wqTwM903w
 MPD4epnm
 AouYRNMhyftEKJcGfs6mp9HIe4SxaKfCYCJQKgM+U8J0q3P4rbRT9BAMmFGIwVxq5C7zb1Kkikuu9QXGojjUwFfEDjjl4dy3VqT5ck1Lxyv4yVu22OQtr/j7s9Uh/5Bdhffz1E8+wFchexv/SKpqNNWRzsn8A6160w6BorOqLq3o2QRI9uiyAeeBtrRjNtmUxtngmcqTOfcI/EeOlbPAfEcpedldtbWGUjkx1dq1jqnrodWQ7OWoxPE60DhlpiwBVbyJB0eyDxqFMFgfoTomgrpYneJ5wGhh6GZt2W5uedR8Jr51r1I0hrZmPL+dvRivlWtBOAHqiENM+D/bKhEqL8LNm8th9/7bHTRaHx3B6NLKy2a7Ki0VnO1k3QFe12rTcPq05IcitWJubZ1VZzpnJ2QCf30ZnO6yD/XOp2CfyApEdWAxDdycPjBvxR/jJKmLkMJJnQxN6xcfP85IhxeZ2JGm8qg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 11, 2026 at 10:49=E2=80=AFAM Lorenzo Stoakes (ARM) <ljs@kernel.=
org> wrote:
>
> On Fri, Sep 11, 2026 at 05:07:48PM +0000, Suren Baghdasaryan wrote:
> > On Fri, Sep 11, 2026 at 4:39=E2=80=AFPM Lorenzo Stoakes (ARM) <ljs@kern=
el.org> wrote:
> > >
> > > On Thu, Sep 10, 2026 at 04:47:34PM -0700, Suren Baghdasaryan wrote:
> > > > smap_gather_stats() interprets its start parameter to mean vma->vm_=
start
> > > > when it's set to 0. Eliminate this special interpretation and pass
> > > > vma->vm_start explicitly when needed.
> > > >
> > > > Since smap_gather_stats() operates within a single VMA, we can repl=
ace
> > > > walk_page_vma()/walk_page_range() calls with walk_page_range_vma()
> > > > which is simpler and also can be called while holding per-VMA lock.
> > > >
> > > > No functional change intended.
> > > >
> > > > Suggested by: Lorenzo Stoakes <ljs@kernel.org>
> > >
> > > Hmm did I? Where did I suggest this?... I guess a while ago?
> >
> > In [1] on June 9, 2026.
> >
> > [1] https://lore.kernel.org/all/aifO_rCurVhFRTcl@lucifer/
>
> Yup a while ago :)
>
> >
> > >
> > > I mean I also happen to suggest it in the previous patch review :) bu=
t that was
> > > sent after you sent this...
> > >
> > > > Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> > > > Reviewed-by: Liam R. Howlett (Oracle) <liam@infradead.org>
> > >
> > > I don't love hacking a hack for a patch and then unhack it in the nex=
t in a
> > > slightly roundabout way.
> > >
> > > Feels like this should be squashed. And a wrapper function for
> > > start=3Dvma->vm_start should be used rather than duplicating that par=
am
> > > constantly.
> > >
> > > > ---
> > > >  fs/proc/task_mmu.c | 29 ++++++++++++++++-------------
> > > >  1 file changed, 16 insertions(+), 13 deletions(-)
> > > >
> > > > diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> > > > index 3c40c9cbb9c9..ecce7ce116cb 100644
> > > > --- a/fs/proc/task_mmu.c
> > > > +++ b/fs/proc/task_mmu.c
> > > > @@ -1246,21 +1246,27 @@ get_smaps_shmem_walk_ops(struct proc_maps_p=
rivate *priv)
> > > >       return &smaps_shmem_walk_vma_lock_ops;
> > > >  }
> > > >
> > > > -/*
> > > > - * Gather mem stats from @vma with the indicated beginning
> > > > - * address @start, and keep them in @mss.
> > > > +/**
> > > > + * smap_gather_stats() - Gather mem stats from @vma.
> > > > + * @priv: proc maps private state.
> > > > + * @vma: The VMA to gather stats for.
> > > > + * @mss: The accumulated stats.
> > > > + * @start: The address from which to start.
> > > >   *
> > > > - * Use vm_start of @vma as the beginning address if @start is 0.
> > > > + * This gathers stats for the whole of the VMA unless the lock was=
 dropped
> > > > + * and VMA grew or got merged and we found it again, in which case=
 we only
> > > > + * gather stats for the remainder of the VMA range.
> > >
> > > This seems to be describing what callers do not what the function doe=
s unless
> > > I'm missing something? So that's really the wrong place for it.
> > >
> > > I think the description of why it might be a partial walk belongs to =
the bit of
> > > code that actually tries to do a partial walk.
> > >
> > > Anyway as per below I think separate partial/full functions make sens=
e and there
> > > it can simply be described as walking either the full or part of the =
VMA.
> >
> > This is verbatim of what you wrote at the end of [1]
>
> OK, I guess I disagree with myself of 3 months ago?
>
> The technical point being made here, which I think is the more constructi=
ve one
> to engage with, is that this is a function that can be called with differ=
ent
> parameters for whatever reason.
>
> Somebody might decide to call it for another reason, putting something in=
 the
> description of the function that assumes what callers will do when that c=
ode can
> change is asking for bit rot.

Yeah, that makes sense.

>
> So as I suggested above:
>
>         I think the description of why it might be a partial walk belongs=
 to the
>         bit of code that actually tries to do a partial walk.
>
> I.e. I guess past me's description is apt, but belongs with the partial c=
ase.

Ok, sounds like you want two separate functions supporting complete or
partial walk. I don't have a strong preference here and it's easy to
do like this:

staic void smap_gather_stats_range(priv, vma, &mss, start)
{
        ....
}

staic void smap_gather_stats(priv, vma, &mss)
{
        smap_gather_stats_range(priv, vma, &mss, vma->vm_start);
}

Does that sound good?

>
> >
> > >
> > > >   */
> > > >  static void smap_gather_stats(struct proc_maps_private *priv,
> > > >                             struct vm_area_struct *vma,
> > > > -                           struct mem_size_stats *mss, unsigned lo=
ng start)
> > > > +                           struct mem_size_stats *mss,
> > > > +                           unsigned long start)
> > > >  {
> > > >       const struct mm_walk_ops *ops =3D get_smaps_walk_ops(priv);
> > > >       const bool is_partial =3D start > vma->vm_start;
> > > >
> > > >       /* Invalid start */
> > > > -     if (start >=3D vma->vm_end)
> > > > +     if (start < vma->vm_start || start >=3D vma->vm_end)
> > > >               return;
> > > >
> > > >       if (vma =3D=3D get_gate_vma(priv->lock_ctx.mm))
> > > > @@ -1285,10 +1291,7 @@ static void smap_gather_stats(struct proc_ma=
ps_private *priv,
> > > >                       mss->swap +=3D shmem_swapped;
> > > >       }
> > > >
> > > > -     if (!start)
> > > > -             walk_page_vma(vma, ops, mss);
> > > > -     else
> > > > -             walk_page_range(vma->vm_mm, start, vma->vm_end, ops, =
mss);
> > > > +     walk_page_range_vma(vma, start, vma->vm_end, ops, mss);
> > >
> > > I mean obviously am in favour of this as I suggested it in the last p=
atch :)
> > >
> > > >
> > > >       reacquire_rcu(priv);
> > > >  }
> > > > @@ -1343,7 +1346,7 @@ static int show_smap(struct seq_file *m, void=
 *v)
> > > >       struct vm_area_struct *vma =3D v;
> > > >       struct mem_size_stats mss =3D {};
> > > >
> > > > -     smap_gather_stats(priv, vma, &mss, 0);
> > > > +     smap_gather_stats(priv, vma, &mss, vma->vm_start);
> > > >
> > > >       show_map_vma(m, vma);
> > > >
> > > > @@ -1396,7 +1399,7 @@ static int show_smaps_rollup(struct seq_file =
*m, void *v)
> > > >
> > > >       vma_start =3D vma->vm_start;
> > > >       do {
> > > > -             smap_gather_stats(priv, vma, &mss, 0);
> > > > +             smap_gather_stats(priv, vma, &mss, vma->vm_start);
> > > >               last_vma_end =3D vma->vm_end;
> > > >
> > > >               /*
> > > > @@ -1455,7 +1458,7 @@ static int show_smaps_rollup(struct seq_file =
*m, void *v)
> > > >
> > > >                       /* Case 1 and 2 above */
> > > >                       if (vma->vm_start >=3D last_vma_end) {
> > > > -                             smap_gather_stats(priv, vma, &mss, 0)=
;
> > > > +                             smap_gather_stats(priv, vma, &mss, vm=
a->vm_start);
> > >
> > > I mean this is all horrible, having to pass vma->vm_start explicitly.
> > >
> > > Although better than the hack that gets compounded in patch 3.
> > >
> > > There 4 invocations of smap_gather_stats(), only one of them passes a
> > > non-vma->vm_start start.
> > >
> > > So it'd make more sense to just make smap_gather_stats() lose its 3rd=
 param and
> > > have it call smap_gather_stats_range(), then have 1 invocation of
> > > smaps_gather_stats_range() directly, as per suggestion in last patch.
> > >
> > > Or something similar to that.
> >
> > Hmm. Ok, I'll wait for you to read your previous suggestions in [1]
> > and after that let's discuss what the final version should look like.
>
> I don't really think that's hugely constructive.

I wasn't trying to offend in any way. Just wanted to give you some
time to recall previous conversation and consolidate your position.

>
> I'm sorry I'm (mildly) disagreeing with my past self, I've sent tens of
> thousands of words of review since then so I think it can be forgiven.

Definitely. Again, I wasn't trying to blame or anything like that.
Just pointing out our previous discussion and want to make sure we are
on the same page (while having some fun in the process).

>
> In any case, I really do think:
>
>         smap_gather_stats(priv, vma, &mss);
>         smap_gather_stats(priv, vma, &mss);
>         smap_gather_stats(priv, vma, &mss);
>         smap_gather_stats_range(priv, vma, &mss, last_vma_end);
>
> Works better than:
>
>         smap_gather_stats(priv, vma, &mss, vma->vm_start);
>         smap_gather_stats(priv, vma, &mss, vma->vm_start);
>         smap_gather_stats(priv, vma, &mss, vma->vm_start);
>         smap_gather_stats(priv, vma, &mss, last_vma_end);
>
> ?
>
> I usually come back on review very quickly so I don't think this series
> will be held up with any such change.
>
> But let me know if you think it's not a good idea technically.

TBH I don't have strong preference but if you like it this way, it will be =
done.
I'll post an update today since I don't think there will be more
controversial parts. The biggest blunder on my part was the way I
split patch 3 and 4.
Thanks for the review!

>
> > Thanks,
> > Suren.
>
> --
> Cheers, Lorenzo

