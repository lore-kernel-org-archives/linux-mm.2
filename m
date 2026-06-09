Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28083CD8CB2
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 17:11:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 653BE6B008A; Tue,  9 Jun 2026 13:11:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 62BB56B008C; Tue,  9 Jun 2026 13:11:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 51A406B0092; Tue,  9 Jun 2026 13:11:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 40F846B008A
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 13:11:21 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D50FC1C25F7
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 17:11:20 +0000 (UTC)
X-FDA: 84861015120.25.006AB80
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	by imf29.hostedemail.com (Postfix) with ESMTP id 98C3312000E
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 17:11:18 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=lIFGznzD;
	spf=pass (imf29.hostedemail.com: domain of surenb@google.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781025078;
	b=D5VVEsJ530JFjNyuYpvQw3CLhxeyc59iU81nQctpdc3LubwTGXIUWwTDV5HbsBKsUKHWwI
	9FlhEOlPN6GSKKZSvb8wq/5tURJ/rWfiJy8pZfXuFXEAkdRsXFACzt6OcgpDRvCE0YLQkO
	21Jw28w8RVQysTGa/UcutllFIV5tI7M=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=lIFGznzD;
	spf=pass (imf29.hostedemail.com: domain of surenb@google.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781025078;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zfGkBJ5Fm1NrFbMLvYuWYFCroOOz9I8fe5IPw1jVMW4=;
	b=r+9WKJzSnxXQ+riJIKVDfPpHreQbW5I0PX7LG3SHrQK83Bqvyx5T1bbkMAZKOVZc6VhqBE
	JJDwnpE58W6wIeI+1qLB7It/R7T72KOtQWuUZlXVMP8QzAOa7h/NNZDYE37+jye4O0QTDp
	6gEuw9m7K0HaZ9CUxMCfLd2Ivzbklto=
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-51765331535so2588961cf.1
        for <linux-mm@kvack.org>; Tue, 09 Jun 2026 10:11:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781025077; cv=none;
        d=google.com; s=arc-20240605;
        b=lWbzBkwc+C9gNGMWTflLsNDoUQSGcB18hn0uZ4+fnMkkwLgQaOkrn9Zl4r62KSrX93
         y+Yw0d1BbkLRNHtrdGIwv8jmzi0yXAsOW3kJD44AbT4i0zIFXQXJHUYHrSMPb78oUGF1
         NxPZNtaz23mboQQtWnjsdaG4SHlKJ4gTGwWWHVECACqjq79BF3tvfYE5esoR1hrTFIEK
         JUh1JVhq0Urf+3pVXSxjCh8xsW42kJnAwJ2U34hXO3NVhRG2j8xI3kyZxZbsY8Zwgqjp
         cy/GIFrNNVu7lwivpfo0rRSxWlLP4ceqbfm4ZxxX0TxY3wweij++TkJOSG1YYlKg8/Bj
         0a7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=zfGkBJ5Fm1NrFbMLvYuWYFCroOOz9I8fe5IPw1jVMW4=;
        fh=Oavt2XY7azyuDDRwflfNGESiVICb4pgn8gsNzC2unbc=;
        b=g122/pBW9b6l+ToVqHGuUgo4m4vzGMpWtobYw0Bbj43lQz6ZEViuCjcfuVVwXNBn+l
         xnM9kNtTzH8hsfrH7Efm6FWoVucSSv+m7EY/s+73SFPwBa2KoBlFCE+ShBJDVqNlfoRW
         itHplF8U20VwnQ6hllDEK0moQOmaiJtSagqV3MCp0ftnyvTIy06+cNSSZma6cFqKA8Mi
         tD6UD3h5JeLnBj25ohGmHPmxOr/HmkVUvhbNNpTllI0/iRfWiB1K1rIyRK+mJaU8BM3T
         Q9toykjAXSzuQ7xKxZb6qktT1SnsOHscVJdQNOlsHpXxo9OgksRAyYa+tGUppGRmWfSo
         LEIg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781025077; x=1781629877; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zfGkBJ5Fm1NrFbMLvYuWYFCroOOz9I8fe5IPw1jVMW4=;
        b=lIFGznzD5vWgKzeFhBuIAJwVaFpFNMafhVC/0StvMva6QrYEgCTdwAkr5qNII2wttt
         fsggOy0+AjHP3PPXYYXmNYpwl6L2AzSweF2IKfNUmwt//X0bx9lrobS3pjkFljfIFekN
         ZAzZee0X/kG5qxpmkOpj/QGP9mKtXwZrk/+gC9hAjqmtDAoqPnKMNiR1NwNsClpx/jPg
         8m2p2wBfWSi9GpRbUss0qazgME8zrWxbC8Bsxx9ph6jW3Z6zWfjLvv1jCb9RbnOiEe3L
         36qKOL+6TizCVKXYwEGrS832wcTKsSvBeSqID4EADKmio37yp7PMEc6YL+6a4FrLOeFC
         teoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781025077; x=1781629877;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=zfGkBJ5Fm1NrFbMLvYuWYFCroOOz9I8fe5IPw1jVMW4=;
        b=gPh3/qN4j8159ugI6i8+2FpK3pCtOphRtc1HKxoD49k9jVpKcTBA+3ktAaU1/qmO4a
         MZkXR2B0gV7dgro0F++ElTrGcXgf/oQFAyhEbpNR1iYhwpD30HbOjRAbiDYGmYUbX8nz
         RSh1P4AvpIfn+TL6WmwRqgaie+27FMKDvST9Vo61F7ACWDqlppWS+DhYKFXvmOQJbp8V
         z9029D7jOixVhiTBcrCEFFh1HNxGwo4Sci0hBUbDq7FGHURI7o0VhMKts25JQ8OiW21U
         Jh4226Q2JC0i4BaQzeDsEosi76+2NIWWRnvNi9lllFhEWf65iElhF/phvGUYYjWb/6M/
         gdbQ==
X-Forwarded-Encrypted: i=1; AFNElJ/ze8e7X3iWflCSE2jqjiuNCSCr/vTYzNb79bocLYNvOZCe60aNCZDDdLUPzdSiVFuWRnr4/+opNA==@kvack.org
X-Gm-Message-State: AOJu0YymTHSkKSQ3u8YOl2q27/1MDmGmy5mgmPsa25vbJgmSdaNrrDMy
	yzAP1+iQUEWrfqOwagFnpF8BSg2QmA/VzM/WJ9Sz1TkK5lUg+Iu5Cp9q7V1cZQ/frO3PauMIEdu
	9qsxfYAYR6svn2eVbW27ZReEWi67ifOObr4wcRnmF
X-Gm-Gg: Acq92OGlkWOHI9jN3Ja1cSOnDqs48NidnqdojhCorFRsfyQc+83SbXFomYqCQKmdpWa
	vm86sezd7Z41okqhzXV8InGk1+vP5OuyBknmgaD1Tdf1qF1IXfCkeJ0OskhLVkiPQT7BZ53pDPl
	4Apd10N0EXfzlVSWYjWBXUDq9eJzjU12kX+2TjLKiS8hNax6oxZTX+eCu5edx98TrwjgzeekfON
	sFc8hPKot98UhP+HvKS/cXIVvlp0o2Z0qYNK5xGqfjMVzhLipwpKv0y2eQch1TA6zKG/z6jmbNp
	0rWi355fsyrykC2HCi4f1oBMHNR0x47pwd8LRhHgB4VvVDDv
X-Received: by 2002:a05:622a:791a:10b0:50f:af60:3496 with SMTP id
 d75a77b69052e-51797ffc93amr34624171cf.1.1781025076678; Tue, 09 Jun 2026
 10:11:16 -0700 (PDT)
MIME-Version: 1.0
References: <20260606015729.1837935-1-surenb@google.com> <20260606015729.1837935-2-surenb@google.com>
 <aifO_rCurVhFRTcl@lucifer>
In-Reply-To: <aifO_rCurVhFRTcl@lucifer>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 9 Jun 2026 10:11:03 -0700
X-Gm-Features: AVVi8Cdb4sw7pcdyLxqv9_1tsBavo9y-1kuiXo0oLzRUxvha-xuFVAATc7XWfDw
Message-ID: <CAJuCfpFOpvNmV4aHnk3Vi0Jg4vF4Cmsm86h2vODZ84FVLXt9yw@mail.gmail.com>
Subject: Re: [PATCH 2/2] fs/proc/task_mmu: read proc/pid/smaps_rollup under
 per-vma lock
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: akpm@linux-foundation.org, liam@infradead.org, vbabka@kernel.org, 
	david@redhat.com, willy@infradead.org, jannh@google.com, paulmck@kernel.org, 
	pfalcato@suse.de, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, Dave Hansen <dave.hansen@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 98C3312000E
X-Rspam-User: 
X-Stat-Signature: b4u5ntb4ff3f3soz16ohcynnt7b4gmjt
X-HE-Tag: 1781025078-891192
X-HE-Meta: U2FsdGVkX19sI9TYvFyxdca4fHXd87Cng5enhB/8O2xsQ8tp2O4w9iT8BFpCh3pLc8KqRFJ912jZ+Ko8JTQL4tlJA6MZEUqv7o81tF5Wt8SWvOdB0G8LNlcGjMSFfJ/513sW70zm9nb6GEp3irKKYcTmv/ZHmWHjnTkhCK9qHIoffMF5t7yzR2lVWKwluWj/XWSVD0wmFw74Wtiu3skgFvFgi3xJnOmSofwhY7lmjDGcJS/68xH7ByZjW8/5lhlbtUCAx0T8F264ifV2tAi96jhmD26LvYmf/OMcqk8qQuQlDmj50PUs6ehVLcME+jAZZ6l7jamiUXwQG2JusV/Qm9QgJ3NYIzL5HOPf2et+82acfk5N8+KyqeG3AurJ78VJLfrM08C7a+THLOEAwFNHtc9VkKgkfn35RSHOBqZHWK2Ky4zeOb3YgZKILrjd6ayGToa0r58FY1aYWoyj/086o3VXl7mSrcGerVeGnX6NgIhjvkzo/PW6MaM8Zb825sTbkKEfdDr5KPmDo0GDu16WUPgUFGVTpwGd4iTqC24mZZo/qfD2EBOTB1D+teAI3tQrYrwCeMRgcPPcMbIaJ3tFVrnDGyn6jItOaQ0zTNIk0zgfzSaOLRnCLtcZwwb+0QZNemo+4St10V7++GKSq4zY0SqJ5o+yMC4mYccIsMB9qGrTNTkwUdFSQd7M2gwJ4UHeAC0lgN7o+uN9Bb9UpaXmrBWD3DzucptZ+HMS3mIQIaW3objfl/1uA8dty2Bk8KjUhhZtIt5buafuhyMGn021ZoiLd1DoeyzE6C37AbYbpdQMudWZzz4OcVxDhNHNFgQ3UjeTLlJyILUcJv7H1yKg2Iv9pK6Olsghkv922M0/NS+rBuvLupQCJ6GNTb44iHEqAQhrLjQ+iVtOIbkVP++BikEbA//V+Yob+ICwQ8RM+Jv346Ba3ffeGDSw53S25yTyPGGCYqFUhsQjta0q4Go
 j/OxxV4K
 S+jwvLOV4A9kseZXPeSvTxidsxMikcWmLX+MK4BqKhaCDV4BO3se8r+0+eTvb0aVX6VYlXcHhfh7630DhFmRHJ+xkquY20XwTzIwPcBA1iWhOacqFpk+hxeRp3ZlOWZIoQUwl+ed6pTKjX5WrG1i71LoAlywNIaEtxEUA0S6dKxyQwLXpGmzOj5gzRw/ADwYDYwiI8QiZnrN3RrAvQO6uOhX3JFuBP/Sm78YZ7oHMaOHmi0W2Fn6x3NDH8aZJ+m65T2k1mV8NLO9MB57YBJoSodfYKUmC7t9TKc3LwcmUnOBLwQOC1LNq6+ZoHXXiqsgkPmY7BwqpwozlqBNjkGHR4xu3XW71b5AsFkLPoUA/6EJ7KDw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 9, 2026 at 3:00=E2=80=AFAM Lorenzo Stoakes <ljs@kernel.org> wro=
te:
>
> On Fri, Jun 05, 2026 at 06:57:29PM -0700, Suren Baghdasaryan wrote:
> > proc/pid/smaps_rollup can be read using the combination of RCU and
> > VMA read locks, similar to proc/pid/{maps|smaps|numa_maps}. RCU is
> > required to safely traverse the VMA tree and VMA lock stabilizes the
> > VMA being processed and the pagetable walk.
> > Note that we have to keep the logic to drop mmap_lock on contention
> > because even when using per-VMA locks we might have to fall back to
> > holding the mmap_lock.
> >
> > Running Paul's contention benchmark [1] shows considerable improvement
> > both in median and in the worst case latencies:
> >
> > Execution command: run-proc-vs-map.sh --nsamples 20 --rawdata -- \
> > --busyduration 2 --procfile smaps_rollup
> >
> > Baseline:
> >
> >     0.174     0.161     2.553
> >     0.174     0.164     2.663
> >     0.174     0.165     2.664
> >     0.174     0.166     2.679
> >     0.174     0.167     2.691
> >     0.174     0.168     2.704
> >     0.174     0.169     2.729
> >     0.174     0.172     2.741
> >     0.174     0.174     2.745
> >     0.174     0.174     2.755
> >     0.174     0.175     2.790
> >     0.174     0.177     2.809
> >     0.174     0.179     3.096
> >     0.174     0.183     3.144
> >     0.174     0.184     3.158
> >     0.174     0.185     3.175
> >     0.174     0.185     4.568
> >     0.174     0.198     4.821
> >     0.174     0.214     5.143
> >     0.174     0.251     5.220
> >
> > Patched:
> >
> >     0.007     0.007     1.952
> >     0.007     0.007     1.955
> >     0.007     0.007     1.955
> >     0.007     0.007     1.955
> >     0.007     0.007     1.957
> >     0.007     0.007     1.969
> >     0.007     0.007     2.065
> >     0.007     0.007     2.075
> >     0.007     0.007     2.146
> >     0.007     0.007     2.195
> >     0.007     0.007     2.223
> >     0.007     0.007     2.259
> >     0.007     0.007     2.488
> >     0.007     0.007     2.562
> >     0.007     0.007     2.599
> >     0.007     0.007     2.697
> >     0.007     0.007     3.030
> >     0.007     0.007     3.075
> >     0.007     0.007     3.145
> >     0.007     0.007     3.225
>
> Ohhh lovely!
>
> >
> > [1] https://github.com/paulmckrcu/proc-mmap_sem-test
> >
> > Signed-off-by: Suren Baghdasaryan <surenb@google.com>
>
> Having looked through it carefully the logic looks correct to me, but I
> think we can improve how this is implemented, so attach a patch with my
> suggestions folded up to make life easier!
>
> > ---
> >  fs/proc/task_mmu.c | 134 ++++++++++++++++++++-------------------------
> >  1 file changed, 59 insertions(+), 75 deletions(-)
> >
> > diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> > index 023422fcee12..c2bd9f5bbbcd 100644
> > --- a/fs/proc/task_mmu.c
> > +++ b/fs/proc/task_mmu.c
> > @@ -233,6 +233,16 @@ static inline void reacquire_rcu(struct proc_maps_=
private *priv)
> >       vma_iter_set(&priv->iter, priv->lock_ctx.locked_vma->vm_end);
> >  }
> >
> > +static inline bool is_mmap_lock_contended(struct proc_maps_private *pr=
iv)
>
> Hmm seems David and I are saying the same things :) but yeah this name be=
ing
> very close to mmap_lock_is_contended() is suboptimal.
>
> Also the inline is pointless here and suppresses the compiler unused chec=
k which
> isn't helpful.

Ack.

>
> But in general, given we already have the lock context I think we can do =
away
> with this altogether, see below.
>
>
> > +{
> > +     struct proc_maps_locking_ctx *lock_ctx =3D &priv->lock_ctx;
> > +
> > +     if (!lock_ctx->mmap_locked)
> > +             return false;
> > +
> > +     return !!mmap_lock_is_contended(lock_ctx->mm);
>
> As David said, !! is not a necessary incantation any more :)

Ack.

>
> > +}
> > +
> >  #else /* CONFIG_PER_VMA_LOCK */
> >
> >  static inline int lock_ctx_mm(struct proc_maps_locking_ctx *lock_ctx)
> > @@ -268,6 +278,11 @@ static inline bool fallback_to_mmap_lock(struct pr=
oc_maps_private *priv,
> >       return false;
> >  }
> >
> > +static inline bool is_mmap_lock_contended(struct proc_maps_private *pr=
iv)
> > +{
> > +     return !!mmap_lock_is_contended(priv->lock_ctx.mm);
>
> Similarly. But also as above I don't think we need this.

Sadly, for now we do (see my later comment).

>
> > +}
> > +
> >  static inline void drop_rcu(struct proc_maps_private *priv) {}
> >  static inline void reacquire_rcu(struct proc_maps_private *priv) {}
> >
> > @@ -1486,12 +1501,15 @@ static int show_smap(struct seq_file *m, void *=
v)
> >  static int show_smaps_rollup(struct seq_file *m, void *v)
> >  {
> >       struct proc_maps_private *priv =3D m->private;
> > +     struct proc_maps_locking_ctx *lock_ctx =3D &priv->lock_ctx;
> > +     struct mm_struct *mm =3D lock_ctx->mm;
> >       struct mem_size_stats mss =3D {};
> > -     struct mm_struct *mm =3D priv->lock_ctx.mm;
> >       struct vm_area_struct *vma;
> > -     unsigned long vma_start =3D 0, last_vma_end =3D 0;
> > +     unsigned long vma_start =3D 0;
> > +     unsigned long last_vma_end =3D 0;
>
> I mean I kinda prefer these separate but obviously not necessary :P

It looked nicer I think :)

>
> > +     loff_t pos =3D 0;
> >       int ret =3D 0;
> > -     VMA_ITERATOR(vmi, mm, 0);
> > +
>
> Yeah extra line as David said :)

Ack.

>
> >
> >       priv->task =3D get_proc_task(priv->inode);
> >       if (!priv->task)
> > @@ -1502,89 +1520,55 @@ static int show_smaps_rollup(struct seq_file *m=
, void *v)
> >               goto out_put_task;
> >       }
> >
> > -     ret =3D lock_ctx_mm(&priv->lock_ctx);
> > +     hold_task_mempolicy(priv);
> > +     ret =3D lock_vma_range(m, lock_ctx);
> >       if (ret)
> >               goto out_put_mm;
> >
> > -     hold_task_mempolicy(priv);
> > -     vma =3D vma_next(&vmi);
> > -
> > -     if (unlikely(!vma))
> > +     vma_iter_init(&priv->iter, mm, 0);
> > +     vma =3D proc_get_vma(m, &pos);
> > +     if (unlikely(!vma) || vma =3D=3D get_gate_vma(priv->lock_ctx.mm))
> >               goto empty_set;
>
> Is the gate VMA check here necessary? We already check it in the loop.

We need it to avoid resetting vma_start, which is being reported even
when no normal VMAs are present.

>
> >
> > +     if (IS_ERR(vma)) {
> > +             ret =3D PTR_ERR(vma);
> > +             goto out_unlock;
> > +     }
>
> Again this is duplicated.
>
> > +
> >       vma_start =3D vma->vm_start;
>
> Could just drop the gate check, and replace this with:
>
>         vma_start =3D IS_ERR(vma) ? 0 : vma->vm_start;

Yeah, that would work. I don't have a strong preference but avoiding
the loop on error seemed cleaner to me. Will change.

>
> > -     do {
> > -             smap_gather_stats(priv, vma, &mss, 0);
> > +     while (vma) {
> > +             if (IS_ERR(vma)) {
> > +                     ret =3D PTR_ERR(vma);
> > +                     goto out_unlock;
> > +             }
> > +
> > +             if (vma =3D=3D get_gate_vma(priv->lock_ctx.mm))
> > +                     break;
> > +
> > +             /*
> > +              * If after retaking mmap_lock, already reported VMA grew=
 or
> > +              * merged with the next one, then iterate from last_vma_e=
nd.
> > +              */
>
> Hmm, but if the already reported VMA grew, vma->vm_start would not be <
> last_vma_end would it?

The scenario is: we reported the VMA before it grew, we set
last_vma_end to its vm_end then dropped the lock. Later after VMA grew
we searched past the last_vma_end and found the same VMA because now
it spans past last_vma_end. In this case vma->vm_start will be less
than last_vma_end and I think this would happen either if the VMA grew
or got merged with its upper neighbor.

>
> So surely this is only covering the merge case?
>
> > +             smap_gather_stats(priv, vma, &mss,
> > +                               vma->vm_start < last_vma_end ? last_vma=
_end : 0);
>
> I don't love how compressed this is.
>
> I also don't love that 0 is taken to be 'start from vma->vm_start' and I
> also don't love that the code in smap_gather_stats() actually special cas=
es
> this...
>
> How about passing last_vma_end and making smap_gather_stats() more sane? =
In
> the other invocation of smap_gather_stats() we could pass vma->vm_start
> here.
>
> We can then move the comment into smap_gather_stats(). E.g.:
>
>                 /* Handles the case of VMA merged since mmap locked drop =
too. */
>                 smap_gather_stats(priv, vma, &mss, last_vma_end);
>
> To make life easier I put all of my suggestions into a patch which I've
> attached :) (though it is untested) let me know what you think.

I was trying to minimize changes to the current logic but that would
be cleaner. I think it would be better to make this logical change as
a separate prerequisite patch. If you agree then I'll do that in my
next version.

>
>
> >               last_vma_end =3D vma->vm_end;
> >
> >               /*
> >                * Release mmap_lock temporarily if someone wants to
> > -              * access it for write request.
> > +              * take it for write request.
>
> I think this is better rewritten to reflect the changes. E.g.:
>
>                 /*
>                  * If the VMA lock is not taken, we hold the often conten=
ded
>                  * mmap lock. This can be because the arch doesn't suppor=
t VMA
>                  * locks,or we had to fall back to the mmap lock.

I intend to postpone this patchset until after Dave's patchset lands
into mm-unstable, so this "arch doesn't support VMA locks" part will
not be there, but othereise SGTM.

>                  *
>                  * To relieve pressure, check if it is indeed contended, =
then
>                  * temporarily release it.
>                  */
>
> >                */
> > -             if (mmap_lock_is_contended(mm)) {
> > -                     vma_iter_invalidate(&vmi);
> > -                     unlock_ctx_mm(&priv->lock_ctx);
> > -                     ret =3D lock_ctx_mm(&priv->lock_ctx);
> > -                     if (ret) {
> > -                             release_task_mempolicy(priv);
> > +             if (is_mmap_lock_contended(priv)) {
>
> We have both mm and lock_ctx already.
>
> So we could instead do:
>
>                 if (lock_ctx->mmap_locked && mmap_lock_is_contended(mm)) =
{
>                         ...
>
> Right?

Unfortunately not. If you look at the struct proc_maps_locking_ctx
definition, mmap_locked will not be there if CONFIG_PER_VMA_LOCK=3Dn.
That's why I have to introduce versions of is_mmap_lock_contended()
for both CONFIG_PER_VMA_LOCK and !CONFIG_PER_VMA_LOCK configs. And
that's why I'm leaning towards waiting for Dave's cleanup to be posted
which will eliminate CONFIG_PER_VMA_LOCK. It will clean up many other
similar helpers in this file.

I just realized I did not CC Dave to this series before, so adding him now.

>
> > +                     unlock_vma_range(&priv->lock_ctx);
>
> OK this confuses me - we're gated on lock_ctx->mmap_locked, so this is ex=
actly
> the same as unlock_ctx_mm(lock_ctx) right?
>
> There's no situation here where the VMA lock would be unlocked.
>
> Surely it'd therefore be clearer to just call unlock_ctx_mm(lock_ctx)
> direct?

Technically yes but one thing I forgot to do here is to remove the
lock_ctx_mm()/unlock_ctx_mm() helpers because after this change there
are no direct users for them.

>
> > +                     ret =3D lock_vma_range(m, lock_ctx);
> > +                     if (ret)
> >                               goto out_put_mm;
>
>
> In the case of VMA locks being supported, but we fell back to mmap locks,=
 this
> seems to just be getting us back to the invariant that the RCU read lock =
is
> held.
>
> However, it's a bit confusing given we're explicitly checking for the
> mmap_locked case, so I think it's worth a comment explaining that we migh=
t have
> fallen back to mmap lock, but could still get the VMA lock on the next VM=
A.
>
> E.g.:
>
>         /*
>          * If we are using VMA locks but fell back to an mmap lock, we ma=
y
>          * be able to VMA lock the next VMA, so reset the lock and try ag=
ain.
>          *
>          * Otherwise, if the arch doesn't support VMA locks, this simply
>          * retakes the mmap lock.
>          */

Yeah, I can see now that this case is quite confusing and needs more
comments. Will do in the next rev.

>
>
> > -                     }
> > -
> > -                     /*
> > -                      * After dropping the lock, there are four cases =
to
> > -                      * consider. See the following example for explan=
ation.
> > -                      *
> > -                      *   +------+------+-----------+
> > -                      *   | VMA1 | VMA2 | VMA3      |
> > -                      *   +------+------+-----------+
> > -                      *   |      |      |           |
> > -                      *  4k     8k     16k         400k
> > -                      *
> > -                      * Suppose we drop the lock after reading VMA2 du=
e to
> > -                      * contention, then we get:
> > -                      *
> > -                      *      last_vma_end =3D 16k
> > -                      *
> > -                      * 1) VMA2 is freed, but VMA3 exists:
> > -                      *
> > -                      *    vma_next(vmi) will return VMA3.
> > -                      *    In this case, just continue from VMA3.
> > -                      *
> > -                      * 2) VMA2 still exists:
> > -                      *
> > -                      *    vma_next(vmi) will return VMA3.
> > -                      *    In this case, just continue from VMA3.
> > -                      *
> > -                      * 3) No more VMAs can be found:
> > -                      *
> > -                      *    vma_next(vmi) will return NULL.
> > -                      *    No more things to do, just break.
> > -                      *
> > -                      * 4) (last_vma_end - 1) is the middle of a vma (=
VMA'):
> > -                      *
> > -                      *    vma_next(vmi) will return VMA' whose range
> > -                      *    contains last_vma_end.
> > -                      *    Iterate VMA' from last_vma_end.
> > -                      */
> > -                     vma =3D vma_next(&vmi);
> > -                     /* Case 3 above */
> > -                     if (!vma)
> > -                             break;
> > -
> > -                     /* Case 1 and 2 above */
> > -                     if (vma->vm_start >=3D last_vma_end) {
> > -                             smap_gather_stats(priv, vma, &mss, 0);
> > -                             last_vma_end =3D vma->vm_end;
> > -                             continue;
> > -                     }
> >
> > -                     /* Case 4 above */
> > -                     if (vma->vm_end > last_vma_end) {
> > -                             smap_gather_stats(priv, vma, &mss, last_v=
ma_end);
> > -                             last_vma_end =3D vma->vm_end;
> > -                     }
>
> OK so you're rolling all this up into the 'if after retaking mmap_lock'
> bit.

Yep, because Cases 1-3 and quite natural. Case 4 is the only "special"
case here IMO, so we handle it separately with separate comments
added.

>
> I don't love that we're losing this information, but also it's maybe a
> little more than we need here and it's making
>
> But perhaps could we transfer this into the commit message as a
> later-findable justification?

Sure, that I can do.

>
> > +                     /* Resume from the last position. */
> > +                     pos =3D last_vma_end;
> > +                     vma_iter_init(&priv->iter, mm, pos);
> >               }
> > -     } for_each_vma(vmi, vma);
> > +             vma =3D proc_get_vma(m, &pos);
> > +     }
> >
> >  empty_set:
> >       show_vma_header_prefix(m, vma_start, last_vma_end, 0, 0, 0, 0);
> > @@ -1593,10 +1577,10 @@ static int show_smaps_rollup(struct seq_file *m=
, void *v)
> >
> >       __show_smap(m, &mss, true);
> >
> > -     release_task_mempolicy(priv);
> > -     unlock_ctx_mm(&priv->lock_ctx);
> > -
> > +out_unlock:
> > +     unlock_vma_range(&priv->lock_ctx);
> >  out_put_mm:
> > +     release_task_mempolicy(priv);
>
> Previously this was done under the mmap lock, now it's not. I don't think
> this should be an issue but just highlighting.

Yeah, I looked into that but found no evidence that it's a problem. If
anyone knows otherwise please let me know.

Thanks for the review, Lorenzo! Much appreciated.

>
> >       mmput(mm);
> >  out_put_task:
> >       put_task_struct(priv->task);
> > --
> > 2.54.0.1032.g2f8565e1d1-goog
> >
>
> Cheers, Lorenzo
>
> ----8<----
> From d94e7a192242f2cefb10bbfa12495e46c3d4c973 Mon Sep 17 00:00:00 2001
> From: Lorenzo Stoakes <ljs@kernel.org>
> Date: Tue, 9 Jun 2026 10:39:39 +0100
> Subject: [PATCH] ideas
>
> ---
>  fs/proc/task_mmu.c | 89 ++++++++++++++++++++++------------------------
>  1 file changed, 42 insertions(+), 47 deletions(-)
>
> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> index c2bd9f5bbbcd..16bf3cd8c7c7 100644
> --- a/fs/proc/task_mmu.c
> +++ b/fs/proc/task_mmu.c
> @@ -233,16 +233,6 @@ static inline void reacquire_rcu(struct proc_maps_pr=
ivate *priv)
>         vma_iter_set(&priv->iter, priv->lock_ctx.locked_vma->vm_end);
>  }
>
> -static inline bool is_mmap_lock_contended(struct proc_maps_private *priv=
)
> -{
> -       struct proc_maps_locking_ctx *lock_ctx =3D &priv->lock_ctx;
> -
> -       if (!lock_ctx->mmap_locked)
> -               return false;
> -
> -       return !!mmap_lock_is_contended(lock_ctx->mm);
> -}
> -
>  #else /* CONFIG_PER_VMA_LOCK */
>
>  static inline int lock_ctx_mm(struct proc_maps_locking_ctx *lock_ctx)
> @@ -278,11 +268,6 @@ static inline bool fallback_to_mmap_lock(struct proc=
_maps_private *priv,
>         return false;
>  }
>
> -static inline bool is_mmap_lock_contended(struct proc_maps_private *priv=
)
> -{
> -       return !!mmap_lock_is_contended(priv->lock_ctx.mm);
> -}
> -
>  static inline void drop_rcu(struct proc_maps_private *priv) {}
>  static inline void reacquire_rcu(struct proc_maps_private *priv) {}
>
> @@ -1375,17 +1360,24 @@ get_smaps_shmem_walk_ops(struct proc_maps_private=
 *priv)
>
>  #endif /* CONFIG_PER_VMA_LOCK */
>
> -/*
> - * Gather mem stats from @vma with the indicated beginning
> - * address @start, and keep them in @mss.
> +/**
> + * smap_gather_stats() - Gather mem stats from @vma.
> + * @priv: proc maps private state.
> + * @vma: The VMA whoms stats we wish to gather.
> + * @mss: The accumulated stats.
> + * @start: The address from which to start.
>   *
> - * Use vm_start of @vma as the beginning address if @start is 0.
> + * This gathers stats for the whole of the VMA unless the mmap lock was =
dropped
> + * and we raced a VMA merge, in which case we only gather stats for the
> + * remainder of the merged range.
>   */
>  static void smap_gather_stats(struct proc_maps_private *priv,
>                               struct vm_area_struct *vma,
> -                             struct mem_size_stats *mss, unsigned long s=
tart)
> +                             struct mem_size_stats *mss,
> +                             unsigned long start)
>  {
>         const struct mm_walk_ops *ops =3D get_smaps_walk_ops(priv);
> +       const bool is_partial =3D start > vma->vm_start;
>
>         /* Invalid start */
>         if (start >=3D vma->vm_end)
> @@ -1408,20 +1400,20 @@ static void smap_gather_stats(struct proc_maps_pr=
ivate *priv,
>                  * Unless we know that the shmem object (or the part mapp=
ed by
>                  * our VMA) has no swapped out pages at all.
>                  */
> -               unsigned long shmem_swapped =3D shmem_swap_usage(vma);
> +               const unsigned long shmem_swapped =3D shmem_swap_usage(vm=
a);
> +               const bool shared_or_ro =3D vma_test(vma, VMA_SHARED_BIT)=
 ||
> +                       !vma_test(vma, VMA_WRITE_BIT);
>
> -               if (!start && (!shmem_swapped || (vma->vm_flags & VM_SHAR=
ED) ||
> -                                       !(vma->vm_flags & VM_WRITE))) {
> +               if (!is_partial && (!shmem_swapped || shared_or_ro))
>                         mss->swap +=3D shmem_swapped;
> -               } else {
> +               else
>                         ops =3D get_smaps_shmem_walk_ops(priv);
> -               }
>         }
>
> -       if (!start)
> -               walk_page_vma(vma, ops, mss);
> -       else
> +       if (is_partial)
>                 walk_page_range(vma->vm_mm, start, vma->vm_end, ops, mss)=
;
> +       else
> +               walk_page_vma(vma, ops, mss);
>
>         reacquire_rcu(priv);
>  }
> @@ -1476,7 +1468,7 @@ static int show_smap(struct seq_file *m, void *v)
>         struct vm_area_struct *vma =3D v;
>         struct mem_size_stats mss =3D {};
>
> -       smap_gather_stats(priv, vma, &mss, 0);
> +       smap_gather_stats(priv, vma, &mss, vma->vm_start);
>
>         show_map_vma(m, vma);
>
> @@ -1510,7 +1502,6 @@ static int show_smaps_rollup(struct seq_file *m, vo=
id *v)
>         loff_t pos =3D 0;
>         int ret =3D 0;
>
> -
>         priv->task =3D get_proc_task(priv->inode);
>         if (!priv->task)
>                 return -ESRCH;
> @@ -1527,15 +1518,10 @@ static int show_smaps_rollup(struct seq_file *m, =
void *v)
>
>         vma_iter_init(&priv->iter, mm, 0);
>         vma =3D proc_get_vma(m, &pos);
> -       if (unlikely(!vma) || vma =3D=3D get_gate_vma(priv->lock_ctx.mm))
> +       if (unlikely(!vma))
>                 goto empty_set;
>
> -       if (IS_ERR(vma)) {
> -               ret =3D PTR_ERR(vma);
> -               goto out_unlock;
> -       }
> -
> -       vma_start =3D vma->vm_start;
> +       vma_start =3D IS_ERR(vma) ? 0 : vma->vm_start;
>         while (vma) {
>                 if (IS_ERR(vma)) {
>                         ret =3D PTR_ERR(vma);
> @@ -1545,20 +1531,29 @@ static int show_smaps_rollup(struct seq_file *m, =
void *v)
>                 if (vma =3D=3D get_gate_vma(priv->lock_ctx.mm))
>                         break;
>
> -               /*
> -                * If after retaking mmap_lock, already reported VMA grew=
 or
> -                * merged with the next one, then iterate from last_vma_e=
nd.
> -                */
> -               smap_gather_stats(priv, vma, &mss,
> -                                 vma->vm_start < last_vma_end ? last_vma=
_end : 0);
> +               /* Handles the case of VMA merged since mmap locked drop =
too. */
> +               smap_gather_stats(priv, vma, &mss, last_vma_end);
>                 last_vma_end =3D vma->vm_end;
>
>                 /*
> -                * Release mmap_lock temporarily if someone wants to
> -                * take it for write request.
> +                * If the VMA lock is not taken, we hold the often conten=
ded
> +                 * mmap lock. This can be because the arch doesn't suppo=
rt VMA
> +                 * locks,or we had to fall back to the mmap lock.
> +                *
> +                * To relieve pressure, check if it is indeed contended, =
then
> +                 * temporarily release it.
>                  */
> -               if (is_mmap_lock_contended(priv)) {
> -                       unlock_vma_range(&priv->lock_ctx);
> +               if (lock_ctx->mmap_locked && mmap_lock_is_contended(mm)) =
{
> +                       unlock_ctx_mm(lock_ctx);
> +
> +                       /*
> +                        * If we are using VMA locks but fell back to an =
mmap
> +                        * lock, we may be able to VMA lock the next VMA,=
 so
> +                        * reset the lock and try again.
> +                        *
> +                        * Otherwise, if the arch doesn't support VMA loc=
ks,
> +                        * this simply retakes the mmap lock.
> +                        */
>                         ret =3D lock_vma_range(m, lock_ctx);
>                         if (ret)
>                                 goto out_put_mm;
> --
> 2.54.0

