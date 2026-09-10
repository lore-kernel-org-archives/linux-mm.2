Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D00EBC88E41
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 23:30:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E21E06B0095; Thu, 10 Sep 2026 19:30:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD2F76B0096; Thu, 10 Sep 2026 19:30:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7B266B0098; Thu, 10 Sep 2026 19:30:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 900426B0095
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 19:30:19 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B251440664
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 23:30:18 +0000 (UTC)
X-FDA: 85199448516.02.C7855E2
Received: from mail-qk2-f12.google.com (mail-qk2-f12.google.com [74.125.230.204])
	by imf11.hostedemail.com (Postfix) with ESMTP id A662D40003
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 23:30:16 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=KObVlcCS;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf11.hostedemail.com: domain of surenb@google.com designates 74.125.230.204 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=KObVlcCS;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf11.hostedemail.com: domain of surenb@google.com designates 74.125.230.204 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789083016;
	b=mBX5gSuTw2nEb9hDLm1esVe29IjFQ4sKZiyjsBr04abRDci3LA/vIyIgOUqy4z0DpYfEvf
	twR3FC1hegmQcUILoulFRiN7602kRR+BZDG/EAbIl7KImbAhL11ZcmiiR+x9uFlRhEoAnY
	Fdy4E/8hM3CtdU8wgj/BWYki3GKyfTY=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789083016;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KfEFjV7pufys+8nogVzTsTnHyxO087XXXuxAAwRJqeE=;
	b=VuNW4M0vl+DLJjeYSEm8EKOieEinlzBFIflOwbn3eclinY6ZCvEa6I5uiZVfMpZcUKrz/4
	S2Fp1e+B9XduLzcrYQI4te7ron4o5uzMolpNiAR29pu5J4f0pJubBH5QduzGPYc1MffLUP
	jXN1sMp/C3Y0yt8oHTNlYm5IAqdBjGE=
Received: by mail-qk2-f12.google.com with SMTP id d75a77b69052e-5306706e89dso61841cf.1
        for <linux-mm@kvack.org>; Thu, 10 Sep 2026 16:30:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789083016; cv=none;
        d=google.com; s=arc-20260327;
        b=UuPkbCf97BQ3WJpxVCr8CQU9qwf3K0yzMIxhtKk+t/rS3DVgNBRJcVcoo//g6eky3h
         Muf2D8PzqG/CNm+awx5r6PZ+W1bvCBQK+hhb0AJwwX+pFi94QgAGGisd+m2VReFks3//
         z/RBNO/iYECB3GX/c9Gf0wiJhuraSACar1PWDuuMNDkI+YiNHLWf4F4irsMkqpWeWVP9
         CIY0h0wlbpi7fnClzJ2HwoGfjQl3QkgSOgzqVcdANy01Yo5KKMfbEbIT/XdvtlBSDHok
         6cTA5UDXWswC3KMMsGC1uuwVs5BnGhf0A54XZvrleoxjo2cKEqTGZPQzK/hY2o30uRFd
         S8MA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=KfEFjV7pufys+8nogVzTsTnHyxO087XXXuxAAwRJqeE=;
        fh=wo6oABrwgihjpH9eiJn66/qEhrDSr5dRbNFxymhnHkM=;
        b=Af+mOTQTMW+RwD5NjKvg3pECGvNtjS64YD6+dOW0LWBWNV8wdoFUkNMbgjSPAuEvUr
         FjAhjf82WXTSW7gywu8s8ZqgnF/7dXn4u5w1r/WqR9vOTv+Sjz5y+NPmYJSa4DiK1D2c
         m9rU4ABsP+13/grq0ivxbD1OA7cB3yXP9TPC+5tG3ZC9yd6ZymgoJhLvrMZWedhPC4c8
         lphUGTnN0yBdWgBpmu2X+KQg8e8f8tNP09CpG0cZc1VI2YuaUkOf1QLNeSDthN7tRuuQ
         nCUXFKs/Mfdj0fS38jwb3klStUeapJLdN4s61gbnr49lTPf46akFPXl8kdT4x49HBHNV
         EBCg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789083016; x=1789687816; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=KfEFjV7pufys+8nogVzTsTnHyxO087XXXuxAAwRJqeE=;
        b=KObVlcCShLtukxARuEnQvnJ+++aub5Ix+fOCrsbImOILmdHaioG6wRFBzOkhjkh11H
         RHevHwFKayz2yOcvjAjQbkdfU5YUolVYFfb6CNCp98JPLfYOB/B/3plNitl/nqamdn25
         nEuyJ+TVHoeGFB+MSK4oKb7MFPiCQ1rP6zsQgmE5PoKjvucfiuPt3EXIjW1BcDA9EMQN
         SOotR9Fvx6QwXxjzLKkFym4IpzUtulXsAhXfqrjI/nmjodR47QckvDOzsr8bgGtSillK
         fH27xx0k3sbzB6GtnnanC+nxQEG3B6mvkpKLreKFka9GYaCWOU5OrssNLS5Vb+dgpQYu
         FYUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789083016; x=1789687816;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=KfEFjV7pufys+8nogVzTsTnHyxO087XXXuxAAwRJqeE=;
        b=KOh+7D53UdECeqrbOIif8Hf5MAMVyLcU6kRcm2J+4fOUYnt4zuGZdCIiqfA1UyK930
         jjjtDI+B9CZTfaQADgEt5gfZVCwABk/Ei3EjrOB90cXUUu8GwRuFZedFyNdnqDVkvd3p
         SxR513q84m40+SmwNecia4w1mtNPlK55Bmum/r3S9U6W2oDYqLKQWdhdunCXZUB+NmVZ
         8eS5SI0Eo1m1a1t51Ah8iJMIFzegNnhZ0Vlms8duCehbe4nU4T1kncaPwyWAXYdsicvp
         HPtJ49MhyAfpez0e7Jdajv+5j9Op5rIQYdp6ptwiHRrkOJzC7emIBG86nLC7+ki7uodL
         2lXg==
X-Forwarded-Encrypted: i=1; AKwUvBwN7anL4UWvBXKfvqqzTvEU8hxRolhwjdgx9rFuXQiALUCv3eipYc66mREkwZxjXRmpZGOHVeGi9w==@kvack.org
X-Gm-Message-State: AFuF++mB64ypim4wraFApAULk/vmdNIPdS8CmHZ/ytPW3YYJtXM/57eK
	zlTR5WDiODIYk2lbdMDsyp44TbeHPbBQFvnSHkIL/fMRw3G5kB/ZXBOVjvoEiajNWs0tNRslVTA
	zMPT7VuQwdBoQZzEoSatiu9byoRkChwWZf14tHzPO
X-Gm-Gg: AYBFou1U2xtY0SLaOhvzUPJkqdMGAwwteRx0v7Z1ltQ2/V/M2zQvTp2NpuLXeggJK6p
	v352hkC4AgA2UJFti6u1II0Fb0TA77P43iBDlriXFKJUEWHk1KmtRDWAhSKcV0jNSRleSbQP/X+
	btI4DYo3Vpsa7usy8HqBhoJrEVsY8WLbbkwg4wbYL2yiJIBajAd6Iy4lI1wdMs/kfm6aY5gy++a
	XDs/W1ZTdRnshzG9xymlKbhpmWvU3cLjsZxo7IpQZYhSCa+WTOh6XdCAMuvBVQexZ4bjMB0FeSE
	HehDb1qBzRXzlxllxvRNGw3W4aP0NkdBRpeAf3VNxJU3UqYETJLt0w9JE4jlqtES9hOuF6RPxmW
	lGILI1bnoXr0=
X-Received: by 2002:a05:622a:17c5:b0:51b:ff0a:2048 with SMTP id
 d75a77b69052e-530cb488208mr4688201cf.3.1789083014965; Thu, 10 Sep 2026
 16:30:14 -0700 (PDT)
MIME-Version: 1.0
References: <20260907063918.3432401-1-surenb@google.com> <20260907063918.3432401-4-surenb@google.com>
 <4825a2fe-f064-45d7-a7c9-e98de7efe86c@kernel.org> <CAJuCfpFL_g7tELjT8p8ExM3tX_v2gNDM9rRKwwefPV_KW=fHfA@mail.gmail.com>
 <8e643f51-a47f-428e-9443-678326288fa6@kernel.org> <aqLUqsoMDfVtjRuN@gremlin>
In-Reply-To: <aqLUqsoMDfVtjRuN@gremlin>
From: Suren Baghdasaryan <surenb@google.com>
Date: Thu, 10 Sep 2026 16:30:03 -0700
X-Gm-Features: AcwNN1W4yJUYStTy2CGNJdnxaH7FRdF38u1M6kpzgz8yoKPhhVSmpMzOaXNoWCY
Message-ID: <CAJuCfpH_t5xOm_=QkKJs+GWH92ThKwifC7Ruo8xx5LKRp6gjaQ@mail.gmail.com>
Subject: Re: [PATCH v2 3/5] proc/task_mmu: remove special-casing of
 smap_gather_stats() start parameter
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, akpm@linux-foundation.org, liam@infradead.org, 
	vbabka@kernel.org, willy@infradead.org, jannh@google.com, paulmck@kernel.org, 
	pfalcato@suse.de, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: A662D40003
X-Stat-Signature: jczpcfpu3ex3qi9jxtbk7qikiko5mbo5
X-Rspamd-Server: rspam01
X-HE-Tag: 1789083016-575339
X-HE-Meta: U2FsdGVkX18NLRU5j0HauatV+6OO6vB/xPijaKmy1WtDKlR3xkvidCURiU8pq4b2YN7Q3YAc7bi5bgt6chXil/XWSR7VVWKqF3uV52XzXN7gNGWB+hM9Irjl4lU+dDimS42fJRBU1yOzmOywoWGoJdTX3SasgA7AYJj9Am1SHqyaI08RvCr69iQLToPwwYSwQ+5KZnMWpM3JsTA2RB/vxrSHho4k7xiyGGnmy0QrBbn7auL8TnHY4GeWCbxoBvf6LC2DC4+/ddvmYraXQqXHBzJh3keXSOkL4Fs81UVzUOjhjddtQ0SVkn1rIXNaVAX/tQ9jTxBt7Tkc3LTXzl5N1O8aRnUUGv9WnTKH3lQaBnz1qqrz36v2FyUzSbgSYClkoHrI2kym3pvm/d3UsM5lbkKR7y9fLU9syr0oNO8NyFMWszi/58HSQEtcpOM+euQDHU45vPtMP5NU+syV1mgCVieEJ4HO+ITxsaVcIAQKrR9lun9aVO2QkHYm4yKrMf6meM+T7LKziQUmhL/dPAPkyRYUb6PvaeGe6tgomtZRAkVP1aJilWYilrLnUaxRCKktkOuXPIYiiMi0ZlYdsxs2KwTf+MAYbyH+FXOFSHxyYPZQP3L3Lg8bGY8wUeesEg0pXZODMTJKJHBGXzfVlZdmdKKhfHdEM6Wr3TiNIoUEtee5y1o9tOv25huS3oMW5BXUHRs7RS8ZNXN3XqbFrF7K/2e1j4XQm0YxqZhDGcFuCVQh0RGXG5kYANm+Md7r5Xpf/H+IC2SjrJmfx6G/7z9uNMdYswY5XLgq7vsmCutirzXmiVv/UegARpuB6i5HVGwqbl9f2bg2dU0em5SOZAkzaY1CaLaVvth/NVF9E0RAKppdV63tCERTXp6RcaYUf10S2la8arAblwBYcIxGdfkZBkQ2jHBSyevdwXH6G6wZwSSMqJw1XKkMl3kr7OZmAtbUdR93p8iAaN1t6hdQCzt
 h8AuwJEc
 +NSa4sZFV2NjJzEZ1ie8QHHdZ3WaPuzJll9PeAx1G8yeC+432f0tf9l6L6FTCw5hOafqoAtsyy9GLpgKmn5MCHfBu2JiYGGKbXuq/Ub0GPAY5qc66MFZaTTC4naoGrrvEauOwOWxeFMe4qgMUc+H4XM4jLT+Z8lfc0pWwar0SOYsF7N+xNZG/2reh9JHP7TybIqfrZbBZ4Eqcue7u6R9JcgZjBgVNEdGP8ZM2wWWBxNehbtqSUG4teZKUeyV3oUFOT1M4kc9bSpzMOnmUYqqoMcf1s0IXAXbZT0gpNq7cBkNHz8WrXOCaVlMsuHHIO+uHmYH1DbLVRljgDZ4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 10, 2026 at 9:27=E2=80=AFAM Lorenzo Stoakes (ARM) <ljs@kernel.o=
rg> wrote:
>
> On Wed, Sep 09, 2026 at 09:16:23PM +0200, David Hildenbrand (Arm) wrote:
> > On 9/9/26 20:28, Suren Baghdasaryan wrote:
> > > On Wed, Sep 9, 2026 at 10:16=E2=80=AFAM David Hildenbrand (Arm)
> > > <david@kernel.org> wrote:
> > >>
> > >> On 9/7/26 08:39, Suren Baghdasaryan wrote:
> > >>> smap_gather_stats() interprets its start parameter to mean vma->vm_=
start
> > >>> when it's set to 0. Eliminate this special interpretation and pass
> > >>> vma->vm_start explicitly when needed.
> > >>>
> > >>> Since smap_gather_stats() operates within a single VMA, we can repl=
ace
> > >>> walk_page_vma()/walk_page_range() calls with walk_page_range_vma()
> > >>> which is simpler and also can be called while holding per-VMA lock.
> > >>>
> > >>> No functional change intended.
> > >>>
> > >>> Suggested by: Lorenzo Stoakes <ljs@kernel.org>
> > >>> Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> > >>> ---
> > >>>  fs/proc/task_mmu.c | 40 ++++++++++++++++++++++------------------
> > >>>  1 file changed, 22 insertions(+), 18 deletions(-)
> > >>>
> > >>> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> > >>> index 9908ba32f180..3351decd1172 100644
> > >>> --- a/fs/proc/task_mmu.c
> > >>> +++ b/fs/proc/task_mmu.c
> > >>> @@ -1246,20 +1246,27 @@ get_smaps_shmem_walk_ops(struct proc_maps_p=
rivate *priv)
> > >>>       return &smaps_shmem_walk_vma_lock_ops;
> > >>>  }
> > >>>
> > >>> -/*
> > >>> - * Gather mem stats from @vma with the indicated beginning
> > >>> - * address @start, and keep them in @mss.
> > >>> +/**
> > >>> + * smap_gather_stats() - Gather mem stats from @vma.
> > >>> + * @priv: proc maps private state.
> > >>> + * @vma: The VMA to gather stats for.
> > >>> + * @mss: The accumulated stats.
> > >>> + * @start: The address from which to start.
> > >>>   *
> > >>> - * Use vm_start of @vma as the beginning address if @start is 0.
> > >>> + * This gathers stats for the whole of the VMA unless the lock was=
 dropped
> > >>> + * and VMA grew or got merged and we found it again, in which case=
 we only
> > >>> + * gather stats for the remainder of the VMA range.
> > >>>   */
> > >>>  static void smap_gather_stats(struct proc_maps_private *priv,
> > >>>                             struct vm_area_struct *vma,
> > >>> -                           struct mem_size_stats *mss, unsigned lo=
ng start)
> > >>> +                           struct mem_size_stats *mss,
> > >>> +                           unsigned long start)
> > >>>  {
> > >>>       const struct mm_walk_ops *ops =3D get_smaps_walk_ops(priv);
> > >>> +     const bool is_partial =3D start > vma->vm_start;
> > >>>
> > >>>       /* Invalid start */
> > >>> -     if (start >=3D vma->vm_end)
> > >>> +     if (start < vma->vm_start || start >=3D vma->vm_end)
> > >>>               return;
> > >>>
> > >>>       if (vma =3D=3D get_gate_vma(priv->lock_ctx.mm))
> > >>> @@ -1279,20 +1286,17 @@ static void smap_gather_stats(struct proc_m=
aps_private *priv,
> > >>>                * Unless we know that the shmem object (or the part =
mapped by
> > >>>                * our VMA) has no swapped out pages at all.
> > >>>                */
> > >>> -             unsigned long shmem_swapped =3D shmem_swap_usage(vma)=
;
> > >>> +             const unsigned long shmem_swapped =3D shmem_swap_usag=
e(vma);
> > >>> +             const bool shared_or_ro =3D vma_test(vma, VMA_SHARED_=
BIT) ||
> > >>> +                                       !vma_test(vma, VMA_WRITE_BI=
T);
> > >>>
> > >>> -             if (!start && (!shmem_swapped || (vma->vm_flags & VM_=
SHARED) ||
> > >>> -                                     !(vma->vm_flags & VM_WRITE)))=
 {
> > >>> +             if (!is_partial && (!shmem_swapped || shared_or_ro))
> > >>>                       mss->swap +=3D shmem_swapped;
> > >>> -             } else {
> > >>> +             else
> > >>>                       ops =3D get_smaps_shmem_walk_ops(priv);
> > >>> -             }
> > >>
> > >> Horrible, horrible code, really. But not your fault :)
> > >>
> > >> I think we can just make the shared_or_ro less odd by just checking =
for cow
> > >> mappings (as described in the comment).
> > >>
> > >>         const bool is_cow =3D vma_is_cow_mapping(vma);
> > >>
> > >> ...
> > >>
> > >>         if (is_partial || (shmem_swapped && is_cow))
> > >>                 ops =3D get_smaps_shmem_walk_ops(priv);
> > >>         else
> > >>                 mss->swap +=3D shmem_swapped;
> > >>
> > >> That's almost in a form that I could understand what's happening.
> > >
> > > Hmm. So, are you saying that !is_cow always implies shared_or_ro? Or
> > > maybe you are stating that vma_is_cow_mapping() was the actual intent
> > > here?
> >
> > So the comment says:
> >
> > "For private writable mappings, we might have COW pages that  .."
> >
> > Which translates to:
> >
> >       private writable =3D=3D vma_is_cow_mapping()
> >
> > >
> > > shared_or_ro =3D VMA_SHARED_BIT || !VMA_WRITE_BIT
> > >
> > > is_cow =3D !VMA_SHARED_BIT && VMA_MAYWRITE_BIT
> > > !is_cow =3D VMA_SHARED_BIT || !VMA_MAYWRITE_BIT
> > >
> > > so, !is_cow would impy shared_or_ro only if !VMA_MAYWRITE_BIT always
> > > implies !VMA_WRITE_BIT. But I think it's possible to have a VMA that
> > > has VMA_WRITE_BIT but not VMA_MAYWRITE_BIT, right?
> >
> > VMA_WRITE should imply VMA_MAYWRITE
>
> Yup it's illegal to set VMA_WRITE_BIT without VMA_MAYWRITE_BIT.
>
> >
> > (in sanitize_fault_flags() we even disallow write faults entirely if VM=
_MAYWRITE
> > is missing)
> >
> > For example, a
> > > driver can create such a VMA to allow writing to the VMA but to lock
> > > its content once mprotect(PROT_READ) gets called.
>
> I'm not even sure how a driver would achieve that but drivers in general =
are not
> permitted to alter VMA flags after map time.
>
> >
> > I don't think that would be valid for a driver to do. But it wouldn't m=
atter
> > here because
> >
> >       shmem_mapping(vma->vm_file->f_mapping)
>
> Yup :)
>
> >
> >
> > I think we could simplify the comment as well to:
> >
> > diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> > index e671b4fd8dedd..4b7e7089cafa7 100644
> > --- a/fs/proc/task_mmu.c
> > +++ b/fs/proc/task_mmu.c
> > @@ -1303,12 +1303,10 @@ static void smap_gather_stats(struct proc_maps_=
private
> > *priv,
> >
> >         if (vma->vm_file && shmem_mapping(vma->vm_file->f_mapping)) {
> >                 /*
> > -                * For shared or readonly shmem mappings we know that a=
ll
> > -                * swapped out pages belong to the shmem object, and we=
 can
> > -                * obtain the swap value much more efficiently. For pri=
vate
> > -                * writable mappings, we might have COW pages that are
> > -                * not affected by the parent swapped out pages of the =
shmem
> > -                * object, so we have to distinguish them during the pa=
ge walk.
> > +                * In CoW mappings, we might have anon folios that are
> > +                * independent of the shmem object. So fallback to the =
less
> > +                * efficient mechanism in such mappings.
> > +                *
>
> Maybe tweak to 'CoW mappings might map anon folios that do not belong to =
shmem,
> so perform a less efficient page table walk in this situation' or somethi=
ng like
> that?

I ended up with this:

/*
 * CoW mappings might map anon folios that do not belong to
 * shmem. Perform a less efficient page table walk in this
 * situation, unless we know that the shmem object (or the
 * part mapped by our VMA) has no swapped out pages at all.
 */

Hope this explains the condition clearly.

>
>
> >                  * Unless we know that the shmem object (or the part ma=
pped by
> >                  * our VMA) has no swapped out pages at all.
> >                  */
>
>
>
> >
> > --
> > Cheers,
> >
> > David
>
> --
> Cheers, Lorenzo

