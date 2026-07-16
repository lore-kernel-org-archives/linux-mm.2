Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8894C44507
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 01:28:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF47C6B0092; Wed, 15 Jul 2026 21:28:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CCC826B0095; Wed, 15 Jul 2026 21:28:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BBB7C6B0096; Wed, 15 Jul 2026 21:28:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8D5866B0092
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 21:28:41 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1ADD2A04D4
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 01:28:41 +0000 (UTC)
X-FDA: 84992905242.26.5B00EF0
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	by imf12.hostedemail.com (Postfix) with ESMTP id 1A7E640005
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 01:28:38 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=GOuDJifm;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf12.hostedemail.com: domain of surenb@google.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784165319;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IyOfq6DxdgNPKsg0G50iBSVfW8A77Y1qMZ8SK8Dxrvk=;
	b=qmwwQz9jVaGrdGRoEhVF68yEwC37QFbXyMZsiEqKGNylFFUCQsTI/XmCpkMeJdxheXhUaM
	N1nEvbpKsRWMcffqfUok5HcG90TkbEsYmXFOu3jmoPOvjHJzvlazvVv9RZr0afUjIKbpxK
	8UwZGb65SlR2colSH+FZVBbkGrVu3oM=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=GOuDJifm;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf12.hostedemail.com: domain of surenb@google.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784165319;
	b=KEivRii2n6TKmzFu0dhhxlFILcuRBLHgSgSW4osnII1Dr527dV0j4cMJlQNR++XJnEd2pA
	XDw4CRtLcPqSFM31OmnMP/aLBGO2oxW+Rkh2uU55zSDObBrhfYiQ0MoXpkuhpkBlAnPJ5Z
	4jXp3AKKSDpnVHLY2TEx55J4Kn7MhkU=
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-51c10ed63c0so82681cf.1
        for <linux-mm@kvack.org>; Wed, 15 Jul 2026 18:28:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784165318; cv=none;
        d=google.com; s=arc-20260327;
        b=aeHis9nlNEsHsCJ1Alzo8Q4g1bUmihKANLs0lglqvz9Gl6TanyvT9H/RT4gRbOfd0a
         ajBLOtqtRSHn7EBUYQw/9nG2v4kyRSagnrqZ3kGhirq+Lstn9zf0yua/ssUb55rm5sro
         Bk/uaP3UUeJrn9IgoZRuruhI+Zc/pWNv/01d7K6lPT7TmfxQnTnV+q87W1BU1JAcjCiu
         ECDltOUO32NYUOqVbQMjoJ80LdrWyeoYMyq3n3juA5mTs7pB3TFLENy4wX4Ox11gCZDf
         rL3c0AYga5UTaYXxn5Gxe3pDsAJxoc1GACkVt/vS9Z4pDQ9iWBKJLUsjOPzVOmjlLZJA
         ZLCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=IyOfq6DxdgNPKsg0G50iBSVfW8A77Y1qMZ8SK8Dxrvk=;
        fh=DcLoVyHKf6YYldK6WcmPQAf2hhE22fdqVAuk3DPYiHg=;
        b=U1mdBpl4G/QRBlB2+RsEAykEz374kJ+eCN9rBqLPSWW8dN428mB+hIVBUC0GVOqW7N
         skov0Hn42ue9KKtpkaq+vkFHcsxc3zSoA/JocczCtTR8YvC5+1XW5wM3D+Hb/g9ix7Sd
         hfhniNLFXuOECvKKafA1oPOBLqTU2gkkbxFDrRwua2qed34WCX47U/zVzxSRpQp3aj5+
         mLBIu22vEn9A0gTQGem1TiSWvf+fnGP0DD326w7QsXF5ELSHkQcSdUyyrVwJX71dwGNm
         +h8/IOKWfmS+Tvy8ADUTxbhHqsLSXlRyHik7SS9tveFILy3kRgkGAX/pGqsA0QPYog75
         kGkg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784165318; x=1784770118; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=IyOfq6DxdgNPKsg0G50iBSVfW8A77Y1qMZ8SK8Dxrvk=;
        b=GOuDJifmbb4TvfslPnZgkpKPYgDm24W0Xfho/vrysNjkucIffKFaS0OAb/fr5aiFRF
         aIjGL+mDFvQfvL7Jhe6eYqdwRJ8xaN9FWkT7pgZBA7U3Bx7KfJLo7HU4C45+WeJXynar
         wJ1CeFBb4cSpKqCyf4v7W4QmDSHHb7WiErYYVCmlelO8EdRVNw3+8L/gs+U2x2+snF/k
         eUxh9/v6qnLhqbfv/nni8WdaNackPoU+93DFuixSFYuZxw/IGwTuq1wlaBNkSzyNpR7Y
         UWt9BeRsFztOKsHdaIUatAXdmBmPC+zxgQ/2Wk08nDltvlEIGeWEExduRaAmpiA9v6KZ
         0ijQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784165318; x=1784770118;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=IyOfq6DxdgNPKsg0G50iBSVfW8A77Y1qMZ8SK8Dxrvk=;
        b=aD2QxnCvWa7DPpL4vAXYPnI+OaEujBlA5jTXRQP60JOdYsSJ8CHvoLJtG+aw2RuuWX
         sDBzOe46bDbkc4rUL1ZW7zaR/EKYgDpkxaGN02A7BYwZ73sd3F7VuAVpBuRXpRJWd5uD
         BlWuAPRy3sfFSgk0FuWR45B1bJssQNQTApHnVqm1iZmNouj/YphVrtBS45gXh0y91D8j
         /jlbjj/tvkj4FAsct443SPnCK4Tm5bsD53kF6WG1QOIOl6IKgWSoiX9JEnctZbHH/PFp
         W6jyFJy9fEaw7kSFqeOHhmSjn4NKtwJuSkgtyDo4eo9YoNjzi27Mbylx7CoaD0aEy2NB
         vHpw==
X-Forwarded-Encrypted: i=1; AHgh+Rq2awaeU0jO+gQhrPn+qDkietwSQIbEEEyLhbeqyU8VSZ7WiOTB88VJXYhHlF8/4/YhWdbRwvUaKA==@kvack.org
X-Gm-Message-State: AOJu0YxYRjyKlIiugRnLMT8Q+9WVIawIa0iBLahFGDFG66vXx3lE4+gw
	FVJ0Mle4b2DZHXitWsHKgQAPImIyKJLp7Em8oC9VSBIMFkWw8I0MKrvDJBg8+mBwodX5dC4jMPQ
	LGQaIclww5aM+Yp4Euk/ivet68WFiQKW3M1+PRMqM
X-Gm-Gg: AfdE7cmYibahqZydVasjMgD0BlsW6Q4JNqxhsyCaRXVZKO2HZK8Fd1vGuUeH446kuQh
	NJsw0HG1R3trGPtUxrq1PtFp8MJ08fcKdiTR38cdqYe0xF25X48TA2YuLhSgGj0bf/jzKgUWhmz
	nbWx4hJ3NTuAapK5IUawLXBPGaV09ksvBlIWSQysYyJBblvFHVtf+Yz4ebL/G0nJOgJlwJWhUyr
	n1b94APT/TCzOg/zx/Y7USYN5QEbbC9EobM+f3JqNWsSh5cDddscceAHm+do2vm92wER38=
X-Received: by 2002:a05:622a:1246:b0:51c:ba4f:9d19 with SMTP id
 d75a77b69052e-51fa4eac1dfmr2460461cf.19.1784165317618; Wed, 15 Jul 2026
 18:28:37 -0700 (PDT)
MIME-Version: 1.0
References: <20260715-b4-objext_split-v1-0-9a49c4ccf4c3@kernel.org> <20260715-b4-objext_split-v1-6-9a49c4ccf4c3@kernel.org>
In-Reply-To: <20260715-b4-objext_split-v1-6-9a49c4ccf4c3@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 15 Jul 2026 18:28:25 -0700
X-Gm-Features: AUfX_mwQH8Mlxnc5oTVolGJX11YQsGRkdly9lMd9axGSJ4lMqluk9IRUY26sPCQ
Message-ID: <CAJuCfpFDhV=O+TS2+A6s+gXagrNBnG3fWuFcS9Jk3g2BHLU8YA@mail.gmail.com>
Subject: Re: [PATCH RFC 06/12] mm/slab: abstract slabobj_ext.ref access
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Harry Yoo <harry@kernel.org>, Hao Li <hao.li@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Alexander Potapenko <glider@google.com>, 
	Marco Elver <elver@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1A7E640005
X-Stat-Signature: j5pmto6ic846mmmt8f5u7u5bq9nyfrde
X-HE-Tag: 1784165318-411086
X-HE-Meta: U2FsdGVkX1/5R+Mtl4XCPNxVRb5+vopEhOkDuIby9W3NncEbZi6+UD9iLub13ZNgPNPRLDDCdWAu0zVYwyNCXRRUPNbn6oJ898Wg2mmBlUl2jt5Rw/BBbk1QjFol76KL8vJrnzT1A5uRR2k1LTBHBdRx96vDoa2CzJgamKb/Fc0cnIALNa7RMOOXMKkrCqPio/ucYCD2b6lc49c4GDq1tHL67XfRY9yHNuFEI0n37QBb8jR5a4+DDWrEYnwUvQkH2H+wwmKpfW0ww1z1ugeE+zYYSpOyAtGUaXYS/cYU8XRrMKwkwQh0k1SSbveAJ6Fm7i4QxsCHyfAR+5ahJxmEQo9VjSl00LNXzuq92+/7e2sEPl1KUUgApZZEqHXwppa9tZMTrtEAfKzdhJiI6dZdRmFFtTmF6kuQw9z4SqmMJi+GXdpRa5ZlVsVZXnC0Z3bSGDZS5Lndpq6grw/GLDZYX+LxCjmamFUUnC/2iI6A9FPtEvwMFO4h+v/zGkjJGZHNO8z/IDbPp0Jr3PhltSDBSNc/eZwOUi232Z8kyhMvmCWRjMWZ39ufwOW0x/iHadDglA1duDHqtRzAydQO5dXsmzDM6xDtxWlFAevyEijZuiMf+0boDdw27epR2oLM2khrRy/H1+yGwYRtHhZfwqFB5zz6zdreZAbxKXeJVthvbgMB1AZ3IChf/2d+wvOOubsF7YSUtuJY+18oU8bXW9zWaCk/aGb9sWUBIHh90hFPvYGZHa00BRe/6uPKfWqj4gzWZEYlF0ptAnRK2dkaDh1F+vzAVIhL0uijCJbrVJT7cAYbMStRgcoNe/uYw8W6zJoacgz7qu0JVW5ZI2QbAtVDJbg3y3o8nVtzDqHIz7lPUXxTsKbMHSEr5uHdG419sVl5OKlDdouCVJiHJTwh9MBpwdje+GQ44HPDPROScEH3+3yHsWV0FiWuSbhij/i8+pRUsB/9LBE7vUWpAP/rD46
 spmMHsgr
 wLms9RteBWlOTryFa9b4GsMFrbLyHg6J/lmmzwxhUEKEXyprUD5vA9AiopPlZV4CabYMSaoCmkKZ+wZxkD9GRTB7gTgDgM9FK3eAilWBObO55KLgo4MGTFJ94urqZ2xO0KWdencTApN1y4xeA0Q2JQbELFdRcScNC3+CwydcwxTE7WK2JCtqZJ7LOc4Wf35fFYr4H2HRoYGby867/cFaZ24Fvg0+U6PhOZzWBMzKfK/Kukv52pGqpmvfumQXq9BjCpbg5XMaFZWVU2iNONk0IyLKFuksXFzDb0EjvHPAhRica8YrKOqFijHWvbwZ5CNlcdEnT0gHTvXS/wnU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 15, 2026 at 3:11=E2=80=AFAM Vlastimil Babka (SUSE)
<vbabka@kernel.org> wrote:
>
> In preparation for changes to the structure, abstract access to the ref
> field with a slab_obj_ext_codetag_ref() function. Rename the field to
> _ctref to make an unexpected direct access a compile error.
>
> No functional change intended.
>
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

> ---
>  mm/slab.h | 10 +++++++++-
>  mm/slub.c | 42 ++++++++++++++++++++++++++++--------------
>  2 files changed, 37 insertions(+), 15 deletions(-)
>
> diff --git a/mm/slab.h b/mm/slab.h
> index 789bd292075f..e3f8e42070f1 100644
> --- a/mm/slab.h
> +++ b/mm/slab.h
> @@ -558,7 +558,7 @@ struct slabobj_ext {
>         struct obj_cgroup *_objcg;
>  #endif
>  #ifdef CONFIG_MEM_ALLOC_PROFILING
> -       union codetag_ref ref;
> +       union codetag_ref _ctref;
>  #endif
>  } __aligned(8);
>
> @@ -668,6 +668,14 @@ static inline struct obj_cgroup **slab_obj_ext_objcg=
p(struct slabobj_ext *obj_ex
>  }
>  #endif
>
> +#ifdef CONFIG_MEM_ALLOC_PROFILING
> +static inline union codetag_ref *
> +slab_obj_ext_codetag_ref(struct slab *slab, struct slabobj_ext *obj_ext)
> +{
> +       return &obj_ext->_ctref;
> +}
> +#endif
> +
>  int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
>                         gfp_t gfp, unsigned int alloc_flags);
>
> diff --git a/mm/slub.c b/mm/slub.c
> index 48e10198a3ce..2bfcabc4c51a 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -2071,18 +2071,20 @@ static inline void mark_obj_codetag_empty(const v=
oid *obj)
>         slab_exts =3D slab_obj_exts(obj_slab);
>         if (slab_exts) {
>                 struct slabobj_ext *ext;
> +               union codetag_ref *ref;
>
>                 get_slab_obj_exts(slab_exts);
>                 ext =3D slab_obj_ext(obj_slab->slab_cache, obj_slab, slab=
_exts, obj);
> +               ref =3D slab_obj_ext_codetag_ref(obj_slab, ext);
>
> -               if (unlikely(is_codetag_empty(&ext->ref))) {
> +               if (unlikely(is_codetag_empty(ref))) {
>                         put_slab_obj_exts(slab_exts);
>                         return;
>                 }
>
>                 /* codetag should be NULL here */
> -               WARN_ON(ext->ref.ct);
> -               set_codetag_empty(&ext->ref);
> +               WARN_ON(ref->ct);
> +               set_codetag_empty(ref);
>                 put_slab_obj_exts(slab_exts);
>         }
>  }
> @@ -2092,19 +2094,22 @@ static inline bool mark_failed_objexts_alloc(stru=
ct slab *slab)
>         return cmpxchg(&slab->obj_exts, 0, OBJEXTS_ALLOC_FAIL) =3D=3D 0;
>  }
>
> -static inline void handle_failed_objexts_alloc(unsigned long obj_exts,
> -                       struct slabobj_ext *vec, unsigned int objects)
> +static inline void handle_failed_objexts_alloc(struct slab *slab,
> +               unsigned long obj_exts, struct slabobj_ext *vec)
>  {
>         /*
>          * If vector previously failed to allocate then we have live
>          * objects with no tag reference. Mark all references in this
>          * vector as empty to avoid warnings later on.
>          */
> -       if (obj_exts =3D=3D OBJEXTS_ALLOC_FAIL) {
> -               unsigned int i;
> +       if (obj_exts !=3D OBJEXTS_ALLOC_FAIL)
> +               return;
> +
> +       for (unsigned int i =3D 0; i < slab->objects; i++) {
> +               union codetag_ref *ref =3D slab_obj_ext_codetag_ref(slab,=
 vec);
>
> -               for (i =3D 0; i < objects; i++)
> -                       set_codetag_empty(&vec[i].ref);
> +               set_codetag_empty(ref);
> +               vec++;
>         }
>  }
>
> @@ -2112,8 +2117,8 @@ static inline void handle_failed_objexts_alloc(unsi=
gned long obj_exts,
>
>  static inline void mark_obj_codetag_empty(const void *obj) {}
>  static inline bool mark_failed_objexts_alloc(struct slab *slab) { return=
 false; }
> -static inline void handle_failed_objexts_alloc(unsigned long obj_exts,
> -                       struct slabobj_ext *vec, unsigned int objects) {}
> +static inline void handle_failed_objexts_alloc(struct slab *slab,
> +               unsigned long obj_exts, struct slabobj_ext *vec) {}
>
>  #endif /* CONFIG_MEM_ALLOC_PROFILING_DEBUG */
>
> @@ -2181,7 +2186,7 @@ int alloc_slab_obj_exts(struct slab *slab, struct k=
mem_cache *s,
>  #endif
>  retry:
>         old_exts =3D READ_ONCE(slab->obj_exts);
> -       handle_failed_objexts_alloc(old_exts, vec, slab->objects);
> +       handle_failed_objexts_alloc(slab, old_exts, vec);
>
>         if (new_slab) {
>                 /*
> @@ -2361,9 +2366,15 @@ __alloc_tagging_slab_alloc_hook(struct kmem_cache =
*s, void *object, gfp_t flags,
>          * check should be added before alloc_tag_add().
>          */
>         if (obj_exts) {
> +               union codetag_ref *ref;
> +
>                 get_slab_obj_exts(obj_exts);
> +
>                 obj_ext =3D slab_obj_ext(s, slab, obj_exts, object);
> -               alloc_tag_add(&obj_ext->ref, current->alloc_tag, s->size)=
;
> +               ref =3D slab_obj_ext_codetag_ref(slab, obj_ext);
> +
> +               alloc_tag_add(ref, current->alloc_tag, s->size);
> +
>                 put_slab_obj_exts(obj_exts);
>         } else {
>                 alloc_tag_set_inaccurate(current->alloc_tag);
> @@ -2395,10 +2406,13 @@ __alloc_tagging_slab_free_hook(struct kmem_cache =
*s, struct slab *slab, void **p
>
>         get_slab_obj_exts(obj_exts);
>         for (int i =3D 0; i < objects; i++) {
> +               struct slabobj_ext *ext;
> +
>                 if (is_kfence_address(p[i]))
>                         continue;
>
> -               alloc_tag_sub(&slab_obj_ext(s, slab, obj_exts, p[i])->ref=
, s->size);
> +               ext =3D slab_obj_ext(s, slab, obj_exts, p[i]);
> +               alloc_tag_sub(slab_obj_ext_codetag_ref(slab, ext), s->siz=
e);
>         }
>         put_slab_obj_exts(obj_exts);
>  }
>
> --
> 2.55.0
>

