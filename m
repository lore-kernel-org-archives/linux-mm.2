Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5A7FC88E53
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 17:08:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D84A46B0092; Fri, 11 Sep 2026 13:08:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D5B0B6B0093; Fri, 11 Sep 2026 13:08:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C51246B0095; Fri, 11 Sep 2026 13:08:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A02CF6B0092
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 13:08:05 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3290C1A0332
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 17:08:05 +0000 (UTC)
X-FDA: 85202114130.23.382A01D
Received: from mail-qk2-f12.google.com (mail-qk2-f12.google.com [74.125.230.204])
	by imf12.hostedemail.com (Postfix) with ESMTP id 85DF440011
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 17:08:01 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=G266e7Yj;
	spf=pass (imf12.hostedemail.com: domain of surenb@google.com designates 74.125.230.204 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789146481;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FfqAnYs9QWvu4t/PRHSywLwXNZCW3SnEDtn5daAsEzM=;
	b=7tx5DYihVGNa5sUTpzOcn+nmVqq79fbxwDVWzC20Evhq8aYTDJFdD2ZCKAxwHS49/S3LOd
	QqRwZq8h0/FEd/DuFw0yfoJp0JqI6ZkgLlRFnk0IccBAM9mef8Bp0YvkEJ6Qr3ODhP37NP
	90d4elDk/TG7X24k8ZI4uLDGFwbeJGw=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789146481;
	b=5vahvpP1ceVdTAj9uKlbxLAEO9cXvu87NWaL79UBXipEffstbGCA1RH3eakYyZZqmpTQN+
	wk3ChMTZU6TuAKmuFMvfT4DO8yu52bLHTyoKg8s+gzSYom7p6RlcmuUOmKTckVh9QrazTP
	B6whbrKWkCyYx6jJtVn6d7y2s2ANCUQ=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=G266e7Yj;
	spf=pass (imf12.hostedemail.com: domain of surenb@google.com designates 74.125.230.204 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-qk2-f12.google.com with SMTP id d75a77b69052e-530d5fc2cd8so56381cf.1
        for <linux-mm@kvack.org>; Fri, 11 Sep 2026 10:08:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789146480; cv=none;
        d=google.com; s=arc-20260327;
        b=MZcE9eR4/kEQSWzZhDWie+VRQyOfGve19lXXAvSH9+eINxXN91rCI3KEj7SaMljpIJ
         qGY47EmNszVtH2zv0rKFRiVl2mFsiWlVzCeQPA8eNqI+CywK/Y/czo3oziy5r83XLHVO
         ylAshnV1RkyZAdCti8EDze6sS8ZtcJ/QDb3n7E2NKKWKU+4wSLs7cdQ2zo+xqsbtOE6N
         +6NCdEhnaSriNUD6svvRifn4k/LCPpDvDqMF6wXTf3gNHSLpM88jpg5vEcYSA9vKtKaj
         cAkgUFiQ+DXPGLhR/ouuBJd23GbfkftnXBKoX8S4h1rhGABfT3aoAuDjDa65XJWanQ5K
         h30w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=FfqAnYs9QWvu4t/PRHSywLwXNZCW3SnEDtn5daAsEzM=;
        fh=CWy1Hpcx87mAqRijSbX1Mxzus0A7Wx2Oh9peZc9yUXo=;
        b=Tam/CcXUstFwUSeHbSiDs4wjCLWhnvIlw1Wh4VFHsCoB7uqF/UGsOLPufjy/kXVXdS
         g6gNSxofwzeu1dnbGXcXm6DWbnFtmGQtsTyzeqQjN87ZTNzgP87lE4Qp0gmLSwYZyjZh
         kpPm8i98CCYPx829E/WjTFdX6qTdsB80oqr2ZVJgr/1YB6IOnKOt7Fm8wN67AnIDBKgn
         zfsGYQB/4104UHcrDM8BszSOVyZ2Ceeye5ZiC1M3C6hs6+Q1u+EBGoqaPpzF+SvQ2xot
         fkD2txVKWGD1sLX17KcUhn31kYdhOjm0+C1eunpFzTu6KgcIe+W7J1cMVeIdy3lnj/4Y
         keTQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789146480; x=1789751280; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=FfqAnYs9QWvu4t/PRHSywLwXNZCW3SnEDtn5daAsEzM=;
        b=G266e7Yjr9YzmzbvM4UyTmX3KAGuqga8+Hy/69ZnK66/+Ke/xaXKvheLo9FweMuVf2
         7IQVyXlPfbkzj/WUMg1u7RqOQea4VeMq3UhI16PNLigjeiJIFSoIaCMLQies7uYStKke
         ylWVbdBN2FKSQzrc6Xc1cS+C3v/4W3+mLZLawOzh9IUUIB3GLNN2jN7OlhCMz9WCXS0O
         kDH1UYImJ5kmzqGyQHIN6uR1V++L5VPra+lXafQDMeg2+BhV58aVjs86HhJz2a/YBXtF
         FZa7Hbx+OtnD927zTPSKEy9Cio2o4pDMKVThaJsGnDdzttcDe/Bk2xU4aOrNE3mCzTWq
         EeFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789146480; x=1789751280;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FfqAnYs9QWvu4t/PRHSywLwXNZCW3SnEDtn5daAsEzM=;
        b=cNPnu+nxuXAd1cwYEGy3zrp+BG0kuBNuhlqyEnjPlA8l2il6ntupBTIlFuIj9+u9xl
         AHtC++vCxNYO90fnDA+iRLhh7WeOGo6fhKU5HPwpcjLE63gjqX6oywThdNbj7KxzlwsX
         INfjSlgZixp1s0Inv6ar16yfU7jwP5lFk2fQUwmk4FiD2sH52v0CIrCiNDqdAOrLK3sI
         6CHnTSxOPzUUQDnYxaJXcas6ZJvi8VI7o0ozy4tWDmJCiNqkLNYHABuXKcWG125fp7bp
         Il+FL1V/Sgl8nz4wd1iLUuWSTEVJU4yy0IBD9uiZNnIh+Na3CnruCfnE3HRf8GWAlBtM
         N7lw==
X-Forwarded-Encrypted: i=1; AKwUvBz6U0CkCWIAORowoF3xRVZuTePdMkzEHe4Up1Y0l0JgR6648Vqecmpk3IAe437u/fFgxyQ8e3lzpQ==@kvack.org
X-Gm-Message-State: AFuF++kfHBemVIMspmgZXN+rPUgBlLSA/6uK1Fzhnv7GtZmzhCsv1k6z
	JsSJgSsi5+2MWijJ/EZqCP/jD9q9hX2WyHTYcNoS0gIGOpy5P1xSGU4N2D/jTnYKS4/dhiqBB6r
	MF7LU3iRXLMuAeAfwY0jy9ItEUMYlzNXOX7hgDPaR
X-Gm-Gg: AYBFou372fYlFvgXkF7FBJ/eTrYaJdGCfHrChTXUGFzcqdBO0N18pWPPX9xAIPKvr7m
	HawlVJbnzM87iCryxj2I+MGQgs8vx7/h47aREFGM4AtbVB/LlJz0SSc3CUNQXFNDKGkO5+BeYQ4
	/DGr/7q3tWDo+B/4oUGHxC+4Wc815QzMimZgIHLgFzoKtanOTGCm6YnERL9+MsxUxjvrgeWKeR5
	nHEHJTucrp1yMPAFi5eWTf8hRHUNGvlPQ8BC+9ZyTWJ7Aiyeg0RBE83UMhUwTo1TWRreHt0+dSm
	GnaOmdgaxDAHNEFX2mjJROuIUrxV0XUkiFmAz1Akp+rf1gCV3XjHs5CTwi+4j/dsEtbtulD0sKH
	tFas/jLc=
X-Received: by 2002:a05:622a:1b07:b0:527:f08f:56a2 with SMTP id
 d75a77b69052e-530e4652848mr184701cf.8.1789146479942; Fri, 11 Sep 2026
 10:07:59 -0700 (PDT)
MIME-Version: 1.0
References: <20260910234737.1340642-1-surenb@google.com> <20260910234737.1340642-5-surenb@google.com>
 <aqQsWNfrBSp4DY_N@gremlin>
In-Reply-To: <aqQsWNfrBSp4DY_N@gremlin>
From: Suren Baghdasaryan <surenb@google.com>
Date: Fri, 11 Sep 2026 17:07:48 +0000
X-Gm-Features: AcwNN1VmWwBwvdrrzfbSCfPBns6QLN3cVqhymRQ3A0LlyuwTeNE2s_Y0v9LoFOY
Message-ID: <CAJuCfpEEi-9ZqhKR536tJHywprb9RFcx92gK00qp_ecBGH9Fvw@mail.gmail.com>
Subject: Re: [PATCH v3 4/7] proc/task_mmu: remove special-casing of
 smap_gather_stats() start parameter
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: akpm@linux-foundation.org, liam@infradead.org, vbabka@kernel.org, 
	david@redhat.com, willy@infradead.org, jannh@google.com, paulmck@kernel.org, 
	pfalcato@suse.de, xueyuan.chen21@gmail.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 85DF440011
X-Stat-Signature: fi63x1g6k59qqbk1uiohqwt7jk6yny85
X-Rspam-User: 
X-HE-Tag: 1789146481-985818
X-HE-Meta: U2FsdGVkX1/Q5E46MTbED6/HqNGOiSFUJrh28IsnEFMeEFuI5wUuw9/o2wntLD7DzU0p57pS65ffVmbPL0bbGHV40CvNuBHDL3X4HUrjDGT2uvgcbK9pvWRXk4DGcjw1jxP5cktwj1zT0+UML60SmkUWONBseAhEABgoKCE6rieGK1gth/5AkXC3wNwA9agWNrUox3LRYZHiQzMP3eUBqJ8rJWhy5X8JBpPeYPe7AKAwK5SeVL7JZp3i8Bacdzw6ILtmZemS33H8m2OwGeXHGRqyeo7srKNT0P7ZC26AHWtCj2TfCppJq9WrKp2bhWlDs8Mf7YkvLGDsRrjun+XD3hpv/aDzBjAQFXSr8SDPAnXZlkqnIvFQXNLgspRUmdhO7MA4pQtZW6ZTVGtHapBEIpjcik+Egyf9jkqT0wA/I2kC3bgL54O9Yy2eKW2cWT7Pj5oNd1Xkt/L6Zq1x+B2fhPS7RDbFMNUFv8pBRGEGcifNVpoYsr2om2/yKxiAlJ96fr/iADO2f2cRTPE+P5lt4WuxNNoMUzXeliwCR7sb5mvEbyvqbCW5TssXSy/v/9JRXf6hj6w7nfz6z5Nhlk8SjzBbtArcra0N5L1XD3GUT9/Em/FmairCTlkHxoWQ6WDPdNm7t0i59nF+Y2C9pyz6pzUsCPvMhjxuGrpF8/9GoOHFQUeH92yZLuFqabz6q7kzacbup9dnOQaVp26orM0fP1BKV/X2BOC2S2aGhtJ9+nZNCL8TcYgjodk1jwaaV0gUKhPG60rBEjL66ghqvdFraG1ROyZwsHaVzNBPxPb1PEEFDuYEfXKQUb2hjOLUhG1nOdiXXu35eJXtFk2/WJtba6Z9uTbM4VEHOu0G3WcCIvxJODWqpeT+nkyafaTN5/T8p6GYei0gXxdM3bF7S4sppoTkjEL5hC/kL279otBpN+uyypSh3vZdQGDxiAndOpOiR36tiC2LMN8bwF8Gu7L
 h2prNnTF
 xtFNn8hQd+RgGapTOksyCig7luB6yrX0O5SrmoHAu4Vli0wW9eugeVM8+80179XeOxUunp6RcugMQasW8kpTIIRxnn+29pSlccUPmGFzPOCdRSqk5lNgBOn3mDlJZo2HvUMTE8E4JeJxHeXcjIraW6/B+2Hl0LXNsFCU1ARQ6bSRcf0qzXX3c8jANZvkIRCzrk01Us7ofa2ywBt/9ejLBBh0YDm6XVg7/LH0AzXjFxnuOhdHptEN74vUV3uIv+uIL2cuderjesPj2rG2e64UMtd6/Mj6zbk+PjmwQXV54ejJXcwKgi+M9NT12S8GlqvhLBUeF7I6ZHakiUx2YDOffDNq2a00ysjVZ+Ems8eIewTvUSosmRaPWsHYn/vlgb83Ayjb7wIEvcRKQaz5sueR07zIZUowM+K0d7lFkO8B+GBYQhwlQqVa/qqZAILz/y9PJWly3L3x+dBjuRddB2fdjKWSS1w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 11, 2026 at 4:39=E2=80=AFPM Lorenzo Stoakes (ARM) <ljs@kernel.o=
rg> wrote:
>
> On Thu, Sep 10, 2026 at 04:47:34PM -0700, Suren Baghdasaryan wrote:
> > smap_gather_stats() interprets its start parameter to mean vma->vm_star=
t
> > when it's set to 0. Eliminate this special interpretation and pass
> > vma->vm_start explicitly when needed.
> >
> > Since smap_gather_stats() operates within a single VMA, we can replace
> > walk_page_vma()/walk_page_range() calls with walk_page_range_vma()
> > which is simpler and also can be called while holding per-VMA lock.
> >
> > No functional change intended.
> >
> > Suggested by: Lorenzo Stoakes <ljs@kernel.org>
>
> Hmm did I? Where did I suggest this?... I guess a while ago?

In [1] on June 9, 2026.

[1] https://lore.kernel.org/all/aifO_rCurVhFRTcl@lucifer/

>
> I mean I also happen to suggest it in the previous patch review :) but th=
at was
> sent after you sent this...
>
> > Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> > Reviewed-by: Liam R. Howlett (Oracle) <liam@infradead.org>
>
> I don't love hacking a hack for a patch and then unhack it in the next in=
 a
> slightly roundabout way.
>
> Feels like this should be squashed. And a wrapper function for
> start=3Dvma->vm_start should be used rather than duplicating that param
> constantly.
>
> > ---
> >  fs/proc/task_mmu.c | 29 ++++++++++++++++-------------
> >  1 file changed, 16 insertions(+), 13 deletions(-)
> >
> > diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> > index 3c40c9cbb9c9..ecce7ce116cb 100644
> > --- a/fs/proc/task_mmu.c
> > +++ b/fs/proc/task_mmu.c
> > @@ -1246,21 +1246,27 @@ get_smaps_shmem_walk_ops(struct proc_maps_priva=
te *priv)
> >       return &smaps_shmem_walk_vma_lock_ops;
> >  }
> >
> > -/*
> > - * Gather mem stats from @vma with the indicated beginning
> > - * address @start, and keep them in @mss.
> > +/**
> > + * smap_gather_stats() - Gather mem stats from @vma.
> > + * @priv: proc maps private state.
> > + * @vma: The VMA to gather stats for.
> > + * @mss: The accumulated stats.
> > + * @start: The address from which to start.
> >   *
> > - * Use vm_start of @vma as the beginning address if @start is 0.
> > + * This gathers stats for the whole of the VMA unless the lock was dro=
pped
> > + * and VMA grew or got merged and we found it again, in which case we =
only
> > + * gather stats for the remainder of the VMA range.
>
> This seems to be describing what callers do not what the function does un=
less
> I'm missing something? So that's really the wrong place for it.
>
> I think the description of why it might be a partial walk belongs to the =
bit of
> code that actually tries to do a partial walk.
>
> Anyway as per below I think separate partial/full functions make sense an=
d there
> it can simply be described as walking either the full or part of the VMA.

This is verbatim of what you wrote at the end of [1]

>
> >   */
> >  static void smap_gather_stats(struct proc_maps_private *priv,
> >                             struct vm_area_struct *vma,
> > -                           struct mem_size_stats *mss, unsigned long s=
tart)
> > +                           struct mem_size_stats *mss,
> > +                           unsigned long start)
> >  {
> >       const struct mm_walk_ops *ops =3D get_smaps_walk_ops(priv);
> >       const bool is_partial =3D start > vma->vm_start;
> >
> >       /* Invalid start */
> > -     if (start >=3D vma->vm_end)
> > +     if (start < vma->vm_start || start >=3D vma->vm_end)
> >               return;
> >
> >       if (vma =3D=3D get_gate_vma(priv->lock_ctx.mm))
> > @@ -1285,10 +1291,7 @@ static void smap_gather_stats(struct proc_maps_p=
rivate *priv,
> >                       mss->swap +=3D shmem_swapped;
> >       }
> >
> > -     if (!start)
> > -             walk_page_vma(vma, ops, mss);
> > -     else
> > -             walk_page_range(vma->vm_mm, start, vma->vm_end, ops, mss)=
;
> > +     walk_page_range_vma(vma, start, vma->vm_end, ops, mss);
>
> I mean obviously am in favour of this as I suggested it in the last patch=
 :)
>
> >
> >       reacquire_rcu(priv);
> >  }
> > @@ -1343,7 +1346,7 @@ static int show_smap(struct seq_file *m, void *v)
> >       struct vm_area_struct *vma =3D v;
> >       struct mem_size_stats mss =3D {};
> >
> > -     smap_gather_stats(priv, vma, &mss, 0);
> > +     smap_gather_stats(priv, vma, &mss, vma->vm_start);
> >
> >       show_map_vma(m, vma);
> >
> > @@ -1396,7 +1399,7 @@ static int show_smaps_rollup(struct seq_file *m, =
void *v)
> >
> >       vma_start =3D vma->vm_start;
> >       do {
> > -             smap_gather_stats(priv, vma, &mss, 0);
> > +             smap_gather_stats(priv, vma, &mss, vma->vm_start);
> >               last_vma_end =3D vma->vm_end;
> >
> >               /*
> > @@ -1455,7 +1458,7 @@ static int show_smaps_rollup(struct seq_file *m, =
void *v)
> >
> >                       /* Case 1 and 2 above */
> >                       if (vma->vm_start >=3D last_vma_end) {
> > -                             smap_gather_stats(priv, vma, &mss, 0);
> > +                             smap_gather_stats(priv, vma, &mss, vma->v=
m_start);
>
> I mean this is all horrible, having to pass vma->vm_start explicitly.
>
> Although better than the hack that gets compounded in patch 3.
>
> There 4 invocations of smap_gather_stats(), only one of them passes a
> non-vma->vm_start start.
>
> So it'd make more sense to just make smap_gather_stats() lose its 3rd par=
am and
> have it call smap_gather_stats_range(), then have 1 invocation of
> smaps_gather_stats_range() directly, as per suggestion in last patch.
>
> Or something similar to that.

Hmm. Ok, I'll wait for you to read your previous suggestions in [1]
and after that let's discuss what the final version should look like.
Thanks,
Suren.

>
>
> >                               last_vma_end =3D vma->vm_end;
> >                               continue;
> >                       }
> > --
> > 2.55.0.1007.g17ff1f9808-goog
> >
>
> --
> Cheers, Lorenzo

