Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA4C4D38FF9
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 17:27:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B3A46B0088; Wed, 14 Jan 2026 12:27:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 338B86B008C; Wed, 14 Jan 2026 12:27:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 20C1C6B0093; Wed, 14 Jan 2026 12:27:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 096406B0088
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 12:27:07 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B5ED0BA2DC
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 17:27:06 +0000 (UTC)
X-FDA: 84331250052.30.21B201F
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	by imf19.hostedemail.com (Postfix) with ESMTP id D58A51A0006
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 17:27:04 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=XWNNcgqT;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf19.hostedemail.com: domain of surenb@google.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768411624; a=rsa-sha256;
	cv=pass;
	b=hnnaw+fCztbBO/aSu0pJlPlyxPP4tEA8UqXWt2O3YCuM78ayAlgR5fRvkC+wqOSrPCbZnm
	MYw3DzfsG06cBCxeVdzJEEefpjE5BMY54Pc/onHzqUBoVdSTDmwLdW84FmtWUNE8KWwj17
	gcOURWEVZwsY3Mv9CC8R+G+KuoOHAU4=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=XWNNcgqT;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf19.hostedemail.com: domain of surenb@google.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768411624;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sLeDyMmDUW/xg++BEnT1ybIr33HsfXJU0o1N9rdRuV4=;
	b=XemXBpfXqweymlY8CyEALc0BMreZNmGOzsadq6bFwvKB7Yg1V9MwDDVDPrzyJcUTIU81eU
	OqetPicXM8zNTX2xcrSawQdL/BaAllyeLA8+ceosD6wrKvrpR+aEIeCwfPeqezTbIq9UR/
	TzHKKqPXxIrWLOzpjwjexgc26mTL2rY=
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-5014b5d8551so377081cf.0
        for <linux-mm@kvack.org>; Wed, 14 Jan 2026 09:27:04 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768411624; cv=none;
        d=google.com; s=arc-20240605;
        b=JCBfrGbPDNWV4lNENg2DCOu2kQQc2f+Jm46dODzZPrL57avTbIMS4w2SUdP1bd7aww
         hmAP9gEuFSZP2U2q3+yMaHExnMl/TTdb0HsTddBzBs4e75YC2hUp3oVPovmuFQJ1Q10j
         H5dNhw5qRb3gaw8mndFuBP2PfFoiKkgKiYGjYxJBdgIbT1sD6+uru4Z/9Ulya2dgFNkq
         tLahoQADi6ZlSkrbyfA/l0FmC9xF59EN1oW9jD3TndkfoidJjcsIyywoDX9d4SAuyCJk
         z4vjMrEa3mUyY64UF6CjYWd2h8GQhckLdyQPbyj99/OvomiXHMOLEBSPbnLexPESGYOs
         dT8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=sLeDyMmDUW/xg++BEnT1ybIr33HsfXJU0o1N9rdRuV4=;
        fh=7MGxmDDh6XpNXpfauA4fKUITsoTSMvJw+pr35CONvTs=;
        b=ZbTHyOvwSSUolpvt3ysQNBgnGZrUdX5ghaNPTm734VqSDvj4o7LR1rZO1IRWiTRoD9
         4EF9uw6QZs4G7vIheX6gNBIpR8Ie0G6DyccdtrQosB/yzZQ25fI+yaP7u+xtf9rtdMK/
         kB6eYgNWwtEGFOMWGlDL9aLZ99ViccL0w0I9sqQGxd7zHlYM2j5yDhzZYICKQ7V6Nh3n
         82nUqQXgrBjkO/rj+xvLRk7X0dNmYsHDs/CXZ0Ep3H7sm8bG4HvQSAwOh+bxVmOc6xzG
         vM1eZhz7LaOolrxBMhWHD5EvDQW3ZDbRMLtztMzaS+a6ARZ+UjwoWTelviP7bFhB6HQo
         uFTw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768411624; x=1769016424; darn=kvack.org;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sLeDyMmDUW/xg++BEnT1ybIr33HsfXJU0o1N9rdRuV4=;
        b=XWNNcgqTcqoKvTnMlIAGX0qV8z233l/F0eVcT64bUZ0ZW0BaK8ONfqOZADcMpFROlX
         1umyxVqndGwEaKC193fD0pz+EZmezSL2/Hz6dyD1rdeX/qqlnQHgPQJf7thXnR5QcebV
         p3mSkOpnYRzW6mFYsvWvp50T/a61Ko/GynThQihRfjccFho8ONRkFUw9ZMy4qhIdK+4t
         DeeklovhoQ8Gv41GRyZCULUEKs+N4Bh69xAg+qAUZ5lVZqW73tL4Y+LOCq5qgT00CDtg
         J5li/HQnC9JYkusO61Ud0CGu3OboPrsfQ+i3AXcDcVC3glGHAsfFJmGD4rf2A6VBbxnp
         yVfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768411624; x=1769016424;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=sLeDyMmDUW/xg++BEnT1ybIr33HsfXJU0o1N9rdRuV4=;
        b=KsBgefPhxG4ds1Suo4QJxkjGIQJfHkevegzCnm0f1ri4IlDgVHU/oRCQ5IuQYCClfM
         hz1nUcjnSxp3S/DSTIkCrFL8kEHjfq3ID5hXz2MQoHkHjfnf17rH1YXFNsM4eNJNILut
         VZXoJqGYc5Wx47PnnZHaYl2xeWqgNvt6ajWKiOY+HA1n1imGO1ZGvSj6Kkb/fJfG3HVG
         FAXWyUpp9yPiZYmDST5u1epMKJKUsmvNErdy8rMMgz/mlwDfSZulEPko7JJiWWx/d4XN
         Z0f5y/zF27euDZH5aPWzRfLmvnOhc2wgjrM1eYl3swQJGWXNWy2rnsRElkTGYED7XfS7
         KCeQ==
X-Forwarded-Encrypted: i=1; AJvYcCXVhrrf9c4NlIcnGdiQyBGrINiN8WzYV184K8EFDBsv9QuL83Nn3pJTBa9T/sfblw4uFTEyHHAXcw==@kvack.org
X-Gm-Message-State: AOJu0YyapQTzRGzK5cZbeVnag7YjCVonBbTtnaBsA9D+ndRSSFSaHeQ9
	g8iAisgZqXOKlq3YZJqmXQBasQTLdEbBVcBHpesbVicE09JvU7Nx1uykDVifC1bK7wkUoGwekIl
	YbtpjItEWpYTtZ9Zl0P5JJXfdNlpADbGFiXHCRsQd
X-Gm-Gg: AY/fxX7vcztQvQa8snnCFCgT0oxIAfA7gCRK4hD08fM0hGNUdAhfgQfQm0KPRwkRa/m
	T9DRCzVng4kuB17KygnVklJHZp/nYzb4tFev9XByMS3KSBIa1AqwbhMNgwHws8F4CJr573wzhmx
	00HVkJVIDo+9at+r6vexf2chIL0CNDHW+LgXxf/txjLzxzzSZP0ZBEeY851AKX9LK6hrrFTs2YJ
	egI3p/3yMKqafFh+kgIAlOgcrJlrKCCdIAZTT4XrvNZl/sgzQ68BqqbCNoSXKOMYeClT6PqGxTt
	oXTch0Mv/Pa+ILPoiHpc63Khzw==
X-Received: by 2002:a05:622a:1105:b0:4ff:c0be:f966 with SMTP id
 d75a77b69052e-50149347321mr11983171cf.9.1768411623329; Wed, 14 Jan 2026
 09:27:03 -0800 (PST)
MIME-Version: 1.0
References: <cover.1767711638.git.lorenzo.stoakes@oracle.com>
 <a4f87ba914697a47419f12901a995759fd977fdd.1767711638.git.lorenzo.stoakes@oracle.com>
 <oecut2v62gxlisp24gxgzwzxm3y3kiqcbkrheuxwkwyrb45apl@qtyhfsv34wi7>
In-Reply-To: <oecut2v62gxlisp24gxgzwzxm3y3kiqcbkrheuxwkwyrb45apl@qtyhfsv34wi7>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 14 Jan 2026 09:26:52 -0800
X-Gm-Features: AZwV_Qhs_oeZvSr6RSXK-nXDJyLWpxuOxda7ulGCeJjrS4nSNeuxokwph2K2yl4
Message-ID: <CAJuCfpHOJqrUw_rH6=-ykWGJvpGw-4_YyPgvTfhf2_2vpthVvQ@mail.gmail.com>
Subject: Re: [PATCH v2 8/8] mm/rmap: separate out fork-only logic on anon_vma_clone()
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Suren Baghdasaryan <surenb@google.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Shakeel Butt <shakeel.butt@linux.dev>, 
	David Hildenbrand <david@kernel.org>, Rik van Riel <riel@surriel.com>, Harry Yoo <harry.yoo@oracle.com>, 
	Jann Horn <jannh@google.com>, Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Pedro Falcato <pfalcato@suse.de>, Chris Li <chriscli@google.com>, 
	Barry Song <v-songbaohua@oppo.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: D58A51A0006
X-Rspamd-Server: rspam06
X-Stat-Signature: 44zxjw43i3be5mszag7751m7fhmomxxe
X-Rspam-User: 
X-HE-Tag: 1768411624-438563
X-HE-Meta: U2FsdGVkX19HfT+VUOVLizhcJSLB6kVyNQnrZS+Pth6I6rYlqCn1WhpVettE4HMRPCcaxlC6z2L+ZLuv1TafuHVGseQhrpTtWoMQZQVkWtOTxPUN8yz05d6AqKj5zyj/XuPC06/m5F/YBc+0ifyOXSTLaRPpICINTeDV+z0tmzN4emV3TaAPPknpaSicAdyVV6DIKA3aVBuMIDtB5YF2YzLUCgs69jBWq2Yt1ejH4ZrG5tpgAfk1MKZjQplvvA5sNTtmRAXD0rxGR1hAdylNkohM5gV7rRaJaDWOnWnZ0fgBlrUt1eyONh6yU7/9SrW7dv9hjnLYG7ShqyWaxQ0Fk8C+qhd+LVyfaXqeuZ4JVB1WW1sspbPGYy9VJ3Sa++VrlHdih/5ZXGIPhxWAu8kiDFLSplAwLrUJr3d9zKkVdWNsY65ml0D5mBO8D4R3EHeMfX2RuQEAfW58hKQWQ5uzt986Lc62jffH0vai+mvimb3uy/tqUuUM2jbrUkbu8n4AwdRAsiHPA2aXimdVLkaqsdvb77FCOphl+Ga1CX7j0a68ooNH5+HmftwQe1u6gaGz1MpxD3mCrY+ZrQH13wN3fKZxNcaHeSUkvM7NCQpsL+U3oUqfBDXF9drkO+pcz+BqbzQmZ5qCAbdBKdxwycS3Apxesu/r7cRQqqq1uWZixE18kZqm681VSFIpdkUPU+vn7gvkMZiGhArtUj2ygh/XSkvIVl+GDjSlJkEJLnrELN9QG1e5RxA052zJFgonxxaVzyIDNSeVmOqfr5GuewTPDSukL6xbHT2YCUEBqZwZ+N4MCn3jx7zftiDg3UvRy0y2NShFaUrhYG5jVTRFq05qzPmWmwGZEPIiOmvYSWyrjoUiiElkEmHan+cngKcCf9eh9leEJ2tOq1YFBGNq44wJex++VwuUHv1Z21ux1n0TIl5B0lJb2JzfRpUfgTWQnQ5RRRyHpDMN+Yx/XUX4bfb
 WYLGGfu1
 SoSDkOfxnW/yRlW+h77CEo/5SKL7QccaUwB4tWnYdr5QkatpVotMEWfx+tIpIBEJhCl97NR91QvZWKpEvAhVk5vy9KPOfJjCjfd6/Uk8YGIYDo8t/PAxsHJoeIDG/So9ygeOIfQsaVX6HemXNg8Yi9QycyaYXfJ0h2LyF35bpo3Z3foy7AkB+q9Bd/69j5JB/XLQJnEUVh7kdSNPZXzVrGfdksGX0mp5lnZWZT/jfV7wKS2ayVFdcyF7UnpXEe4kZWn4GzPvu8mZvaZ++C9LB/qV96EuMgfHACYoviYmWJ2Rr6Cg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 6, 2026 at 11:27=E2=80=AFAM Liam R. Howlett <Liam.Howlett@oracl=
e.com> wrote:
>
> * Lorenzo Stoakes <lorenzo.stoakes@oracle.com> [260106 10:05]:
> > Specify which operation is being performed to anon_vma_clone(), which
> > allows us to do checks specific to each operation type, as well as to
> > separate out and make clear that the anon_vma reuse logic is absolutely
> > specific to fork only.
> >
> > This opens the door to further refactorings and refinements later as we
> > have more information to work with.
> >
> > Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>
> A few minor things, but this looks correct.
>
> Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

>
> > ---
> >  mm/internal.h                    | 11 ++++-
> >  mm/rmap.c                        | 74 ++++++++++++++++++++++----------
> >  mm/vma.c                         |  6 +--
> >  tools/testing/vma/vma_internal.h | 11 ++++-
> >  4 files changed, 74 insertions(+), 28 deletions(-)
> >
> > diff --git a/mm/internal.h b/mm/internal.h
> > index 4ba784023a9f..8baa7bd2b8f7 100644
> > --- a/mm/internal.h
> > +++ b/mm/internal.h
> > @@ -244,7 +244,16 @@ static inline void anon_vma_unlock_read(struct ano=
n_vma *anon_vma)
> >
> >  struct anon_vma *folio_get_anon_vma(const struct folio *folio);
> >
> > -int anon_vma_clone(struct vm_area_struct *dst, struct vm_area_struct *=
src);
> > +/* Operations which modify VMAs. */
> > +enum vma_operation {
> > +     VMA_OP_SPLIT,
> > +     VMA_OP_MERGE_UNFAULTED,
> > +     VMA_OP_REMAP,
> > +     VMA_OP_FORK,
> > +};
> > +
> > +int anon_vma_clone(struct vm_area_struct *dst, struct vm_area_struct *=
src,
> > +     enum vma_operation operation);
> >  int anon_vma_fork(struct vm_area_struct *vma, struct vm_area_struct *p=
vma);
> >  int  __anon_vma_prepare(struct vm_area_struct *vma);
> >  void unlink_anon_vmas(struct vm_area_struct *vma);
> > diff --git a/mm/rmap.c b/mm/rmap.c
> > index 8f4393546bce..336b27e00238 100644
> > --- a/mm/rmap.c
> > +++ b/mm/rmap.c
> > @@ -233,12 +233,13 @@ int __anon_vma_prepare(struct vm_area_struct *vma=
)
> >  }
> >
> >  static void check_anon_vma_clone(struct vm_area_struct *dst,
> > -                              struct vm_area_struct *src)
> > +                              struct vm_area_struct *src,
> > +                              enum vma_operation operation)
>
> You could save a line here by putting src and operation on the same line
> and tabbing only twice, but sure.  This is true in earlier patches as
> well.
>
> >  {
> >       /* The write lock must be held. */
> >       mmap_assert_write_locked(src->vm_mm);
> > -     /* If not a fork (implied by dst->anon_vma) then must be on same =
mm. */
> > -     VM_WARN_ON_ONCE(dst->anon_vma && dst->vm_mm !=3D src->vm_mm);
> > +     /* If not a fork then must be on same mm. */
> > +     VM_WARN_ON_ONCE(operation !=3D VMA_OP_FORK && dst->vm_mm !=3D src=
->vm_mm);
> >
> >       /* If we have anything to do src->anon_vma must be provided. */
> >       VM_WARN_ON_ONCE(!src->anon_vma && !list_empty(&src->anon_vma_chai=
n));
> > @@ -250,6 +251,40 @@ static void check_anon_vma_clone(struct vm_area_st=
ruct *dst,
> >        * must be the same across dst and src.
> >        */
> >       VM_WARN_ON_ONCE(dst->anon_vma && dst->anon_vma !=3D src->anon_vma=
);
> > +     /*
> > +      * Essentially equivalent to above - if not a no-op, we should ex=
pect
> > +      * dst->anon_vma to be set for everything except a fork.
> > +      */
> > +     VM_WARN_ON_ONCE(operation !=3D VMA_OP_FORK && src->anon_vma &&
> > +                     !dst->anon_vma);
> > +     /* For the anon_vma to be compatible, it can only be singular. */
> > +     VM_WARN_ON_ONCE(operation =3D=3D VMA_OP_MERGE_UNFAULTED &&
> > +                     !list_is_singular(&src->anon_vma_chain));
> > +#ifdef CONFIG_PER_VMA_LOCK
> > +     /* Only merging an unfaulted VMA leaves the destination attached.=
 */
> > +     VM_WARN_ON_ONCE(operation !=3D VMA_OP_MERGE_UNFAULTED &&
> > +                     vma_is_attached(dst));
> > +#endif
> > +}
> > +
>
> try seems to imply we can return something saying it didn't work out,
> but this is void.  Naming is hard.  reuse_anon_vma_if_necessary seems
> insane, so I don't really have anything better.
>
> > +static void try_to_reuse_anon_vma(struct vm_area_struct *dst,
> > +                               struct anon_vma *anon_vma)
> > +{
> > +     /* If already populated, nothing to do.*/
> > +     if (dst->anon_vma)
> > +             return;
>
> This is only used on VMA_OP_FORK, how is it populated?
>
> I assume this is a later refinement?
>
> > +
> > +     /*
> > +      * We reuse an anon_vma if any linking VMAs were unmapped and it =
has
> > +      * only a single child at most.
> > +      */
> > +     if (anon_vma->num_active_vmas > 0)
> > +             return;
> > +     if (anon_vma->num_children > 1)
> > +             return;
> > +
> > +     dst->anon_vma =3D anon_vma;
> > +     anon_vma->num_active_vmas++;
> >  }
> >
> >  static void cleanup_partial_anon_vmas(struct vm_area_struct *vma);
> > @@ -259,6 +294,7 @@ static void cleanup_partial_anon_vmas(struct vm_are=
a_struct *vma);
> >   * all of the anon_vma objects contained within @src anon_vma_chain's.
> >   * @dst: The destination VMA with an empty anon_vma_chain.
> >   * @src: The source VMA we wish to duplicate.
> > + * @operation: The type of operation which resulted in the clone.
> >   *
> >   * This is the heart of the VMA side of the anon_vma implementation - =
we invoke
> >   * this function whenever we need to set up a new VMA's anon_vma state=
.
> > @@ -281,17 +317,17 @@ static void cleanup_partial_anon_vmas(struct vm_a=
rea_struct *vma);
> >   *
> >   * Returns: 0 on success, -ENOMEM on failure.
> >   */
> > -int anon_vma_clone(struct vm_area_struct *dst, struct vm_area_struct *=
src)
> > +int anon_vma_clone(struct vm_area_struct *dst, struct vm_area_struct *=
src,
> > +                enum vma_operation operation)
> >  {
> >       struct anon_vma_chain *avc, *pavc;
> > +     struct anon_vma *active_anon_vma =3D src->anon_vma;
> >
> > -     check_anon_vma_clone(dst, src);
> > +     check_anon_vma_clone(dst, src, operation);
> >
> > -     if (!src->anon_vma)
> > +     if (!active_anon_vma)
> >               return 0;
> >
> > -     check_anon_vma_clone(dst, src);
> > -
> >       /*
> >        * Allocate AVCs. We don't need an anon_vma lock for this as we
> >        * are not updating the anon_vma rbtree nor are we changing
> > @@ -317,22 +353,14 @@ int anon_vma_clone(struct vm_area_struct *dst, st=
ruct vm_area_struct *src)
> >               struct anon_vma *anon_vma =3D avc->anon_vma;
> >
> >               anon_vma_interval_tree_insert(avc, &anon_vma->rb_root);
> > -
> > -             /*
> > -              * Reuse existing anon_vma if it has no vma and only one
> > -              * anon_vma child.
> > -              *
> > -              * Root anon_vma is never reused:
> > -              * it has self-parent reference and at least one child.
> > -              */
> > -             if (!dst->anon_vma && src->anon_vma &&
> > -                 anon_vma->num_children < 2 &&
> > -                 anon_vma->num_active_vmas =3D=3D 0)
> > -                     dst->anon_vma =3D anon_vma;
> > +             if (operation =3D=3D VMA_OP_FORK)
> > +                     try_to_reuse_anon_vma(dst, anon_vma);
> >       }
> > -     if (dst->anon_vma)
> > +
> > +     if (operation !=3D VMA_OP_FORK)
> >               dst->anon_vma->num_active_vmas++;
> > -     anon_vma_unlock_write(src->anon_vma);
> > +
> > +     anon_vma_unlock_write(active_anon_vma);
> >       return 0;
> >
> >   enomem_failure:
> > @@ -362,7 +390,7 @@ int anon_vma_fork(struct vm_area_struct *vma, struc=
t vm_area_struct *pvma)
> >        * First, attach the new VMA to the parent VMA's anon_vmas,
> >        * so rmap can find non-COWed pages in child processes.
> >        */
> > -     error =3D anon_vma_clone(vma, pvma);
> > +     error =3D anon_vma_clone(vma, pvma, VMA_OP_FORK);
> >       if (error)
> >               return error;
> >
> > diff --git a/mm/vma.c b/mm/vma.c
> > index 4294ecdc23a5..2a063d6568d9 100644
> > --- a/mm/vma.c
> > +++ b/mm/vma.c
> > @@ -528,7 +528,7 @@ __split_vma(struct vma_iterator *vmi, struct vm_are=
a_struct *vma,
> >       if (err)
> >               goto out_free_vmi;
> >
> > -     err =3D anon_vma_clone(new, vma);
> > +     err =3D anon_vma_clone(new, vma, VMA_OP_SPLIT);
> >       if (err)
> >               goto out_free_mpol;
> >
> > @@ -626,7 +626,7 @@ static int dup_anon_vma(struct vm_area_struct *dst,
> >
> >               vma_assert_write_locked(dst);
> >               dst->anon_vma =3D src->anon_vma;
> > -             ret =3D anon_vma_clone(dst, src);
> > +             ret =3D anon_vma_clone(dst, src, VMA_OP_MERGE_UNFAULTED);
> >               if (ret)
> >                       return ret;
> >
> > @@ -1899,7 +1899,7 @@ struct vm_area_struct *copy_vma(struct vm_area_st=
ruct **vmap,
> >               vma_set_range(new_vma, addr, addr + len, pgoff);
> >               if (vma_dup_policy(vma, new_vma))
> >                       goto out_free_vma;
> > -             if (anon_vma_clone(new_vma, vma))
> > +             if (anon_vma_clone(new_vma, vma, VMA_OP_REMAP))
> >                       goto out_free_mempol;
> >               if (new_vma->vm_file)
> >                       get_file(new_vma->vm_file);
> > diff --git a/tools/testing/vma/vma_internal.h b/tools/testing/vma/vma_i=
nternal.h
> > index 93e5792306d9..7fa56dcc53a6 100644
> > --- a/tools/testing/vma/vma_internal.h
> > +++ b/tools/testing/vma/vma_internal.h
> > @@ -600,6 +600,14 @@ struct mmap_action {
> >       bool hide_from_rmap_until_complete :1;
> >  };
> >
> > +/* Operations which modify VMAs. */
> > +enum vma_operation {
> > +     VMA_OP_SPLIT,
> > +     VMA_OP_MERGE_UNFAULTED,
> > +     VMA_OP_REMAP,
> > +     VMA_OP_FORK,
> > +};
> > +
> >  /*
> >   * Describes a VMA that is about to be mmap()'ed. Drivers may choose t=
o
> >   * manipulate mutable fields which will cause those fields to be updat=
ed in the
> > @@ -1157,7 +1165,8 @@ static inline int vma_dup_policy(struct vm_area_s=
truct *src, struct vm_area_stru
> >       return 0;
> >  }
> >
> > -static inline int anon_vma_clone(struct vm_area_struct *dst, struct vm=
_area_struct *src)
> > +static inline int anon_vma_clone(struct vm_area_struct *dst, struct vm=
_area_struct *src,
> > +                              enum vma_operation operation)
> >  {
> >       /* For testing purposes. We indicate that an anon_vma has been cl=
oned. */
> >       if (src->anon_vma !=3D NULL) {
> > --
> > 2.52.0
> >

