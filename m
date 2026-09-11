Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 315A4C88E4D
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 19:48:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 473086B0088; Fri, 11 Sep 2026 15:47:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 424546B008C; Fri, 11 Sep 2026 15:47:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3137C6B0092; Fri, 11 Sep 2026 15:47:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 162BD6B0088
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 15:47:59 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8DB55120187
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 19:47:58 +0000 (UTC)
X-FDA: 85202517036.12.95EADE7
Received: from mail-qk2-f12.google.com (mail-qk2-f12.google.com [74.125.230.204])
	by imf29.hostedemail.com (Postfix) with ESMTP id A097712000D
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 19:47:56 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=MlaLKI5Q;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf29.hostedemail.com: domain of surenb@google.com designates 74.125.230.204 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789156076;
	b=DvcIJLIMuqcOmtvoemRP8LbPA9QE79bOTfs55KRfEH9jUS/07GM2Wsnl9HKa9ZJJUGGXNB
	mD/hl2Yzml+Ma1hqiqQnhIkHk8EeTMmCtElXZm+hOdV+zEmqLnWG3dWFZcv0awxDT/f+W4
	jeQFALCDXe//e5znEyOm6Sl+7S8Uv0I=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=MlaLKI5Q;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf29.hostedemail.com: domain of surenb@google.com designates 74.125.230.204 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789156076;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vrYQ8fif4AyPdCzj9gAZ4OwR6V4iYcgiDS5Z8k+S3YA=;
	b=2Rwj/pc1P2FmH1kGIMyxKGZk14iCqCXQFrOTO3hHLnQXXzt9UgmYaQPdEg90cJv+I6mAoi
	XQJDyBwFA9ux+01HvKPpOVyzYcNIyVidf/kxRwxreURHfCHcJdYKWkzXtXVW5kHZ1of0zr
	gPkFnaHMpAlO6IGt0BZVpRaQYNjscno=
Received: by mail-qk2-f12.google.com with SMTP id d75a77b69052e-530411c7ee1so127451cf.0
        for <linux-mm@kvack.org>; Fri, 11 Sep 2026 12:47:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789156076; cv=none;
        d=google.com; s=arc-20260327;
        b=Z490aufXOCvOhuV2dY/bt7ytmcFYy+0wbIKiImy8LcnjYutiqMNnjsrtegiZFUfOeO
         BH0kRdyCkbe/XDPqwUwvCmap0pTDZXHSyk2Bkzvd0JJurD4DPvkGd3bwg9fvIYb3WizE
         MufTN8fa1TfjYL93TzMkyLCwxoI9nmOz/qgtY7i4YqVrAZD+yTLNjx5CtSvuQNIwoI9s
         ke1uw9sPkhLKCQpn6oHdGXecw2O6fWKj0lSwSb0CNmsGDT/0ywa617Slf8MaxPMobBqx
         8Wc5UTZw/yJ7bPle+lYdnBBOgWhz2d0VZxoXAx4URN/2bv08hfRr2E1OjcIxQ8B//8Fu
         R0eQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=vrYQ8fif4AyPdCzj9gAZ4OwR6V4iYcgiDS5Z8k+S3YA=;
        fh=jatDWfCM3AX81TVAZO/4N1S37gTqh0NZN7d4k8/IXWM=;
        b=Kk8yCkUAo3t8SbxCJFonoW45DsFPzzJrynaFTrrZKJpjhaexDb9xFX8zmo6QsiNxBw
         es9SFIFyYSGrcnqFolH1aIHVD4szIapIKBaNCbOdh+q4tpLXahBTGXDv0RSNl6GN9QoH
         hfNtn690gKVphmcdPGYWoptPEs+mtND5XSOH86/+MFvbZOuoUqIMvOprlhWjhFPouxgU
         hUdhDW75QAd8BmctfgWYWWfSM89lW89pRuBfYjCoXiB3ntQDWhDqIhbUoKeEDlUPjiDg
         8PXH9kGw2fwnCyWR10psTJIunTwH7b2+H2Jw8Liqu2H08vwV+q6Zk0QxAzM7zDfDdBTG
         hJ+g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789156076; x=1789760876; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=vrYQ8fif4AyPdCzj9gAZ4OwR6V4iYcgiDS5Z8k+S3YA=;
        b=MlaLKI5Q0IuvkvcnWFkXtets5fIf2gtLMwMAGpUgFjtdEPS995GSgXw5XVWGyVXEDN
         RHZYbrHVTATd72NpeSzcEXioxJkiS+H0vcNb30NqRRGqWQaKJnlhwyiBs2STzGW8U1Rf
         Mgm3LAolI/oLV0HYYSj4ZN7r4To+Pl61ctrShD9pkvvU/vFb1jeVCHdaXhhBEtEsQ1Sa
         Tsd+pcSHPHpXs+pFyNt1W6VCZdTEmGbrfULwH4GlChVjFixzvH/2Mh1HKbHmSL6+R1Lx
         KaOlZIEOKdPfPM+tAme8nDnmC5EAF9MC4hu0p3+Q7gibAV18KuAxEIyY9Kltrww+I957
         R3aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789156076; x=1789760876;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vrYQ8fif4AyPdCzj9gAZ4OwR6V4iYcgiDS5Z8k+S3YA=;
        b=mA80XgmE2cycaluZ9Cii/Q/3bjy5xUV4zPaI7RMXJaalOUmnpng4G9jIMQ08gg9ZBP
         HPrnfS0T1B5q1ZltaKY7mk1LskG7YAGKembca9C5LQxalJNhKaJFBbSApCJOHke5FNy7
         t0xsuyXemLm/NtL/llyvJqRgdkLDjoZvO9WoQEay9KgxInse11AmHg0I2fdEmTazpppA
         LlzUgwBKIwvRdn/UNEEOCAzFV3ab4U3lkFkDmv39+05I4cagA2CDlZ6FDG6t8rDDPNni
         R8EmLnsQxd9m6Shnbq+8jm21Kv7ru9hk+hJkPqTZGTvaU5jh28g1qmIZLsbz83s6uqAJ
         pDHQ==
X-Forwarded-Encrypted: i=1; AKwUvBxPnjcTRbGHaTXvOy8oQOiq2KTQ2tYnAEr5bZIJ0OgzXSJ7Rm+9i/tiSqCif9A9dnT+gX5Xa6Tz0A==@kvack.org
X-Gm-Message-State: AFuF++nLa5t4zxkJfrVMFSrmgmYz3CsuMvkFODhwok7FMCaRP3oZdRBI
	i6PkOAsIKjjx0DQS/95fe7iWhA6Zo3ykY8e9R3ibu06P1fmNkPq5XiEPriGkhmogelHUpAIfMYG
	dnXd/Cag/FR0ukkFkj5CYMLUtJZ+755tJrqHrUC+G
X-Gm-Gg: AYBFou1Qgz4TOBZ8n2WyzfIkefP/TEjkHrP33IA+LMGv8743LGeUEVBUsR7AfikpfhF
	Gc7LC+h3b47iD9haIdoEO5SlUexdTVUbtCxIt+t9L09aBLxhG7DUJ6AaxX1nCzG8cv3/NFiWQIY
	2+kwfibCQBtQfEzpm9pAvlZ2785KEzvg59PH35j9SHtQvOor62SJ2/9XMipOU/rI4Tp3pC0PbhK
	+BX3dPnUWJqeQ8shJT18aHUWh8BI00/nchPgVxURqDVRwXcnZlSLF1IqjUMumgjLikjZ+yKojPz
	QsUp1vrCGqFICuRm/iUeUNuCmPgcGyXrWIMATKyZQa+D1QE7EA1wC+mYkFy1QO3lPVNckORCcvC
	HwEWC0wtjJw==
X-Received: by 2002:ac8:5749:0:b0:530:39d7:ef48 with SMTP id
 d75a77b69052e-530e612de23mr89771cf.3.1789156074760; Fri, 11 Sep 2026 12:47:54
 -0700 (PDT)
MIME-Version: 1.0
References: <20260911194145.1781926-1-surenb@google.com> <20260911194145.1781926-5-surenb@google.com>
 <aqRaONEiklcnblwQ@gremlin>
In-Reply-To: <aqRaONEiklcnblwQ@gremlin>
From: Suren Baghdasaryan <surenb@google.com>
Date: Fri, 11 Sep 2026 12:47:43 -0700
X-Gm-Features: AcwNN1XsaY36agWBMGEWlskBvCYjftnblVqAHV0x5LuDyqQXoH6GyBmbsL07NFo
Message-ID: <CAJuCfpFRmDJ=hu8et-M+tZtTmYoNcebaHgDqMz1V03eM7WL0LQ@mail.gmail.com>
Subject: Re: [PATCH v4 4/7] proc/task_mmu: remove special-casing of
 smap_gather_stats() start parameter
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: akpm@linux-foundation.org, liam@infradead.org, vbabka@kernel.org, 
	david@kernel.org, willy@infradead.org, jannh@google.com, paulmck@kernel.org, 
	pfalcato@suse.de, xueyuan.chen21@gmail.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A097712000D
X-Stat-Signature: otzncy5swxmnzox53j6fymf91owamcke
X-Rspam-User: 
X-HE-Tag: 1789156076-488901
X-HE-Meta: U2FsdGVkX1/yU1jXbw8cKRmf3B2TgovQywL/1tt/zrpHxbUq/B2m6p6e3yKT365zRC+cfg2+G17VIVX+bvbcwjM/7LhZ8T4v+4t7lB4Av2MI7XZJyK7G8n+Q/s0ZoOpvVqO6MHcYl4itQrqDEhnau+3lzVoEt8wj6ObLeVC+mBN9R+o5X3MbmEdUavsi45wmc60W7UQ0dr8sLzqN033NWDn0ONLNa/CbPl33Qm785OzGDyYwmV3WLpTNVaC86M3W4os2iiGR+ofjHSzABBrnoaU6N5ccFaAC0SXU/Nw2gkerX4tDRP+7mxCbthlmujG+/L3vzhxgzKHYSECieZjG/ZyAYedCMlRWYCfQrKLOwMbdJnELoPcYTXQYKfcjxsSKnrRn1jsFRh2emZhJKYqk00ZGR/aP/0bTaSYOZuO1qJagt/D1r6wH12h61ulqI0LZ04U3VxI5nw2dARQj7x+gt+3ACooP1Y7ZGZLGDHl+FJtc4l0jFoM0+7oHxc5Bkk5fJ8N0m1McWB1tBWQEtSksmXf8VhjZrj1jeO2LrkryFnbpzyHb9N/l4BXGyM4dXDmpXqZ/rwhhABhT0HroJ7gHu4W4418RSCPjvAQ2IBp6YrdPh8iACld3KrBTCAnSDg7nXYNyU1s7hQU2LU4EF8LPoT2tMJrCQuk/kfsQvwlk8Gf2zRNJHa9VVyr995cMY1X/VSPN9twIejNXnRhv53JobXfSSCgFvqcu3sV0koG0yeoISWivafdG3nETIhkbRyYoTY1lLxWRnqfglS93Wa4UqdKjEMyPrUajx8PueDl5aSgX/2EtUglTUUcztRur04T+9A8sIY5WGCF9gYbrNH5JExGoOF2204dVn4j4PVssgazUbInv5Kg+YpqESs6ZvmvedGxe2MMoCEva+QAXU94iP2TwGFY5k6Dvx1I8W/QlnswAxuqjSVAD2qtGVrBAqMMenMZEmFCttfm4BN/Iljk
 NlZCAASB
 Jbyn8ogSEJ2/wtuSBRzTNfhI2HiisRuNOdas8eSgZJXXLyMHn78XMXPMNnTtraIvBVeUvgU22jzc9ri6mFTKjzyHI6xcWxZm/mbgvfZN7kh4oj74//SDc9CkbEbZvAFlKOCJBtBPcqJzesejmHNjrnJtLIlwBeC+IMNA+ddIPvY8IoXyu47+JXL4MV3Mj5bhlFRGbNF3zBAI+8M+3o3DuEUErHsVArK4Uyp8V+wA9hZo+UN8pzVseDVL43+deASKMSUKajWgJgZOalvObVGMcrOzlMBTYgJ6ksuUhDMCwUCxOeSmr2aq5v2t20BsEId1X4ekNWamNb08J16uIX/R5w1bBIU6BM1d2YN65fCitGNau74y4uqn4Gc2i412IvogHbvj4tN7ayEA+FP8zWs4fZifRfA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 11, 2026 at 12:45=E2=80=AFPM Lorenzo Stoakes (ARM) <ljs@kernel.=
org> wrote:
>
> On Fri, Sep 11, 2026 at 12:41:42PM -0700, Suren Baghdasaryan wrote:
> > smap_gather_stats() interprets its start parameter to mean vma->vm_star=
t
> > when it's set to 0. Eliminate this special interpretation and provide t=
wo
> > separate functions for a partial and complete VMA walk.
> >
> > Since smap_gather_stats() operates within a single VMA, we can replace
> > walk_page_vma()/walk_page_range() calls with walk_page_range_vma()
> > which is simpler and also can be called while holding per-VMA lock.
> >
> > No functional change intended.
> >
> > Suggested by: Lorenzo Stoakes <ljs@kernel.org>
> > Signed-off-by: Suren Baghdasaryan <surenb@google.com>
>
> LGTM so:
>
> Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Thanks!

>
> > ---
> >  fs/proc/task_mmu.c | 52 +++++++++++++++++++++++++++++++---------------
> >  1 file changed, 35 insertions(+), 17 deletions(-)
> >
> > diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> > index 0e53eb065a3e..a6026ffd07f1 100644
> > --- a/fs/proc/task_mmu.c
> > +++ b/fs/proc/task_mmu.c
> > @@ -1246,20 +1246,26 @@ get_smaps_shmem_walk_ops(struct proc_maps_priva=
te *priv)
> >       return &smaps_shmem_walk_vma_lock_ops;
> >  }
> >
> > -/*
> > - * Gather mem stats from @vma with the indicated beginning
> > - * address @start, and keep them in @mss.
> > +/**
> > + * smap_gather_stats_range() - Gather mem stats from a portion of the =
@vma.
> > + * @priv: proc maps private state.
> > + * @vma: The VMA to gather stats for.
> > + * @mss: The accumulated stats.
> > + * @start: The address from which to start.
> >   *
> > - * Use vm_start of @vma as the beginning address if @start is 0.
> > + * This gathers stats for the portion of the VMA starting at the @star=
t
> > + * address.
> >   */
> > -static void smap_gather_stats(struct proc_maps_private *priv,
> > -                           struct vm_area_struct *vma,
> > -                           struct mem_size_stats *mss, unsigned long s=
tart)
> > +static void smap_gather_stats_range(struct proc_maps_private *priv,
> > +             struct vm_area_struct *vma,
> > +             struct mem_size_stats *mss,
> > +             unsigned long start)
> >  {
> >       const struct mm_walk_ops *ops =3D get_smaps_walk_ops(priv);
> > +     const bool is_partial =3D start > vma->vm_start;
> >
> >       /* Invalid start */
> > -     if (start >=3D vma->vm_end)
> > +     if (start < vma->vm_start || start >=3D vma->vm_end)
> >               return;
> >
> >       if (vma =3D=3D get_gate_vma(priv->lock_ctx.mm))
> > @@ -1278,20 +1284,31 @@ static void smap_gather_stats(struct proc_maps_=
private *priv,
> >               const unsigned long shmem_swapped =3D shmem_swap_usage(vm=
a);
> >               const bool is_cow =3D vma_is_cow_mapping(vma);
> >
> > -             if (start || (shmem_swapped && is_cow))
> > +             if (is_partial || (shmem_swapped && is_cow))
> >                       ops =3D get_smaps_shmem_walk_ops(priv);
> >               else
> >                       mss->swap +=3D shmem_swapped;
> >       }
> >
> > -     if (!start)
> > -             walk_page_vma(vma, ops, mss);
> > -     else
> > -             walk_page_range(vma->vm_mm, start, vma->vm_end, ops, mss)=
;
> > +     walk_page_range_vma(vma, start, vma->vm_end, ops, mss);
> >
> >       reacquire_rcu(priv);
> >  }
> >
> > +/**
> > + * smap_gather_stats() - Gather mem stats from the entire @vma.
> > + * @priv: proc maps private state.
> > + * @vma: The VMA to gather stats for.
> > + * @mss: The accumulated stats.
> > + *
> > + * This gathers stats for the whole of the VMA.
> > + */
> > +static void smap_gather_stats(struct proc_maps_private *priv,
> > +             struct vm_area_struct *vma, struct mem_size_stats *mss)
> > +{
> > +     smap_gather_stats_range(priv, vma, mss, vma->vm_start);
> > +}
> > +
> >  #define SEQ_PUT_DEC(str, val) \
> >               seq_put_decimal_ull_width(m, str, (val) >> 10, 8)
> >
> > @@ -1342,7 +1359,7 @@ static int show_smap(struct seq_file *m, void *v)
> >       struct vm_area_struct *vma =3D v;
> >       struct mem_size_stats mss =3D {};
> >
> > -     smap_gather_stats(priv, vma, &mss, 0);
> > +     smap_gather_stats(priv, vma, &mss);
> >
> >       show_map_vma(m, vma);
> >
> > @@ -1395,7 +1412,7 @@ static int show_smaps_rollup(struct seq_file *m, =
void *v)
> >
> >       vma_start =3D vma->vm_start;
> >       do {
> > -             smap_gather_stats(priv, vma, &mss, 0);
> > +             smap_gather_stats(priv, vma, &mss);
> >               last_vma_end =3D vma->vm_end;
> >
> >               /*
> > @@ -1454,14 +1471,15 @@ static int show_smaps_rollup(struct seq_file *m=
, void *v)
> >
> >                       /* Case 1 and 2 above */
> >                       if (vma->vm_start >=3D last_vma_end) {
> > -                             smap_gather_stats(priv, vma, &mss, 0);
> > +                             smap_gather_stats(priv, vma, &mss);
> >                               last_vma_end =3D vma->vm_end;
> >                               continue;
> >                       }
> >
> >                       /* Case 4 above */
> >                       if (vma->vm_end > last_vma_end) {
> > -                             smap_gather_stats(priv, vma, &mss, last_v=
ma_end);
> > +                             smap_gather_stats_range(priv, vma, &mss,
> > +                                                     last_vma_end);
> >                               last_vma_end =3D vma->vm_end;
> >                       }
> >               }
> > --
> > 2.55.0.1007.g17ff1f9808-goog
> >
>
> --
> Cheers, Lorenzo

