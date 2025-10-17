Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE7FBCCD195
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 21:53:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 149AE8E0010; Fri, 17 Oct 2025 17:53:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0FA3F8E0008; Fri, 17 Oct 2025 17:53:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F03C08E0010; Fri, 17 Oct 2025 17:53:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D9C7D8E0008
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 17:53:12 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 918F61A01ED
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 21:53:12 +0000 (UTC)
X-FDA: 84008957424.15.1CE3DF4
Received: from mail-il1-f177.google.com (mail-il1-f177.google.com [209.85.166.177])
	by imf13.hostedemail.com (Postfix) with ESMTP id BA41A20006
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 21:53:10 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=IXcJljnd;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf13.hostedemail.com: domain of surenb@google.com designates 209.85.166.177 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760737990;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zg+LvDgyn3hse8ECOJ3X3R84bc7PJRNWcq+EOuKGoKs=;
	b=NnovJxQW1CyR6viNps2yK5fSN7iWnXBk2qMv0BwkrfJvtSNeTq3D1DKKt4hzWGzb0epi1e
	8HYlhCbDuihmk344YHGlPhbJQ0DMESKEjXcYbFLKD4VwxjM8LLMnoACDpiiWDZurRS50ht
	FwUM3HF7fOX9UW3PSt9ZrpFOBM2dyJ8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760737990; a=rsa-sha256;
	cv=none;
	b=08+dqgNuOfm75xXcD1qgRB//mXrT2D3foP7AHSYrYRpEoshSZwLpr3J9gh2KoOadogaCS/
	aZIGrrhMtjMcu8yPNEAcoSsFwmF4TUOddcl3PK0kvH4JlrEUt1/K/TL+rENrlQOYPHjlEA
	5+iB6JNtHz7zbghGaCUdh33Zkh2rnEY=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=IXcJljnd;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf13.hostedemail.com: domain of surenb@google.com designates 209.85.166.177 as permitted sender) smtp.mailfrom=surenb@google.com
Received: by mail-il1-f177.google.com with SMTP id e9e14a558f8ab-4308afd43f0so208605ab.0
        for <linux-mm@kvack.org>; Fri, 17 Oct 2025 14:53:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760737989; x=1761342789; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zg+LvDgyn3hse8ECOJ3X3R84bc7PJRNWcq+EOuKGoKs=;
        b=IXcJljnd9G+/vCsvWi1mSllgjAHtzS/+nov4NajEYSgPsmup7h0pCft5UkrmrKDGyY
         UVYXMqXBoR3w1xIXGtBbU8VcBYrCfC3Xu8VoYjuTW84tCNrEODVphTGR7g06jDuNYola
         e76xB9/wOpLw1PPL3p8BLvem3QYz49fHKrzB74E0wAcQ2Zxm+srqU7cQjIFVGBvrk7FO
         XAh/ThM/f2SzYU15IAhx4aDOoVueq4Qa6AAU8k4E7B4SVkWqm7vJOAsAU9RquhlV/qmJ
         lcor5swmvLutzK6MXGR+atBpUKgLhzAZt/AkDa5FRAegcttcJSS69qiw2+FjU0pa4Kav
         kLcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760737989; x=1761342789;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zg+LvDgyn3hse8ECOJ3X3R84bc7PJRNWcq+EOuKGoKs=;
        b=bNmRy8UHGISrr+yHyL83cC7aEUULCluzRCkvNBZeAMMKnUKh8ZSEKOY+96ta+TeuEW
         XBzJ/uwiGL4kIup6e3TEzExiAlrXG+Cc5484nWWWuShABVRL6NE/ZpuDuhFK02Eb7jMj
         NcfsmhnkRnDBBlWmQd7yA3S1yAxmj+QI6O6O19Qewvk1+m4ME53EVsmY468cb9kF6WO6
         JJs597oqIx+6TxW5PQzdNJL1L5TOlzGI7oZwYihnwrRto9eR+ME2MhPZObo2k2av/BpP
         +TZNeCsdp+K5Zze7kaPvmp8455gflJyNwx0YbJ+WRIGu+AotqR2XH7cJAjjSAMISH7wD
         xP3A==
X-Forwarded-Encrypted: i=1; AJvYcCUzP6SAwUEIkiLjZkNw0c5RconPytihLZYrmqqqkeuhAcmtTAaIZ8srILgio2XVFHuJPOUxlAcT5g==@kvack.org
X-Gm-Message-State: AOJu0Yysg58Jzh3ECQ8flZfqhH/zXH3mxwA8Iym4qY3irVwqB+WL4Qdb
	gRBsTgCC8UE9DEjWc2XRNQs4Aw6LfjL10yZpIM9gsz/5vr0FX3wKpXLM5b+dICdbnQ3btA1gR46
	mNGBD8Zxo2jMCftp2rfdQcli+O4zdgifcwTenJJoP
X-Gm-Gg: ASbGncvsG5WbaEu6a68QOlh2MhhmhwHjKIoamzc+kNUggVhiNMQKTb71MjW5JM5IKzn
	TQ9ciLtscZocVt8bnOWqMQT50Pi7q+N4zJhgP05oSLNESANDjLzeZnseyxudjz0WvDmbfHdPOr7
	mr8uFYsnCmt45NOI+hNo6J9DdSdvTJnUq8DFRRylV6g0NWgpyArTeQz9/7oz/ycz/1ojAn97923
	ygvnSGGTUkNPui8FSh0toSFCk0a8r/TAOJoAdYeI9Fq/91lMTXT2zuBAA7SQujX37OR1w==
X-Google-Smtp-Source: AGHT+IGc1sSOMmFv/ySY9gPGtIvXBGAMeSfkuZRIHXUrnxuhNCj4FV55NlOQ5imUZ2wq+v2IIFWpN2r0Mv6Ppw9CH8I=
X-Received: by 2002:a05:622a:5449:b0:4d1:c31e:1cc7 with SMTP id
 d75a77b69052e-4e882ee5ef8mr30328921cf.14.1760737989222; Fri, 17 Oct 2025
 14:53:09 -0700 (PDT)
MIME-Version: 1.0
References: <a9ca7cc6-f4d1-4fba-a9aa-2826b9a604bc@suse.cz> <8F4AE1E9-7412-40D6-B383-187021266174@linux.dev>
 <7791b2b8-5db8-458c-89e2-49a0876c13a3@suse.cz>
In-Reply-To: <7791b2b8-5db8-458c-89e2-49a0876c13a3@suse.cz>
From: Suren Baghdasaryan <surenb@google.com>
Date: Fri, 17 Oct 2025 14:52:58 -0700
X-Gm-Features: AS18NWBsbKz6L11KPx77elhvnrS5C-2MyEz2rs7vkZo8yWn-AnXc8Z7KatI8Ytw
Message-ID: <CAJuCfpEWGujJe3JOjmiKLOUr49Hw_3smT6iatY7kaRBPPCWpNg@mail.gmail.com>
Subject: Re: [PATCH] slab: Avoid race on slab->obj_exts in alloc_slab_obj_exts
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Hao Ge <hao.ge@linux.dev>, Harry Yoo <harry.yoo@oracle.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Hao Ge <gehao@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: BA41A20006
X-Rspamd-Server: rspam02
X-Stat-Signature: anoyertwzgez11fcrk8hptqrxqsybne7
X-HE-Tag: 1760737990-153305
X-HE-Meta: U2FsdGVkX18cpqPBQitB+oXNYy1/wTaeCl5oXK1whUfhWnTarrznob/oa0T2LWCBvgKIA449gQvhoymhyOhR1iG+0o5KOIGlVQnFmsKRRw+BxGOOrta+fMI3rqLIyWO4T1yHHjNL9EZQqXM10y/9mcSnbwrOpJkl2pY0SrYRwEo4pLnTiteybx9MXvAiS724qmImeEJEkalMfXKW3+M6EADaARjClvfQAeAWFVcdF4yXpL/iOOveKLp/35uh/xGBGt9CnSc1CrVyXGgR8bUr2xMxwT4TZmjYrOOJEdG5FluRhrnm9fUfzD0FISmKaDtVdfdi52oooCmLj4w5oTrrUpu9QT6v3F3JuATg+utuEZQfcAUH9UlTMEoT2/6ojeEKCnVZaV3X+aaEClRuv5EF1WB0FBCye6/t05z0C4GQhAy31FGNe+1ND62jhhI+hwUDf+RBeK8e3TDGLW0Vpg71VjbRq2/I9MZBF+tKkAPlO6W1nPvTyre25faupVKszdHJL3idtMCREQ7zmTvi2Mb56jbdtB8V2C572RWGe1ZrD4U6XlkaUfhRm6NHThQSvUR8aYspOOZSU45EZl6BOsAjXaMUpIoji4abfDbHMwMNNfYJR0WEy02OXzgc6n4wYag+XAPm7UZ9CLaIejvh0lMJe7GhNnrTRXbxXeUQnltleh18JItXa+yaWd9QuTrGOH/nCLODmmUMoMgKS98Qghik8gfULyXslkxk1r6isyQ09IpaSCMscdmv2wcqAwgdhkK0f/et2C0EgEi7P2RpampqAfGyoDx2urEzkOTfHMs/aV3RRB53PZEDGGl1zbXJRt62oRMG6jYqa2iwxqbxcoryVayaBKilLrOm3zdGKmsc84neSO2wiUC7h0e9L0TBd8hls9AoL6VRPBCQwjLJbHP+NwSi65eznXc2PMM9Ua08+Pt/pHfZeeWhfVgvfCszPLgSXLR5JbE7li5zMYBk253
 noWSJoHh
 dcIrF0TOvNtCdvyo7giwvLKC1cPaxGC2OmQ2SQlhAvelAaYdVOkeJ0OEHPKZH0x/ZRDmBMw0wHZ2cO95FMG6MnAwE69IZpSQo/N5yJ1/YTNpdS+Uv5kO8G+ikso1YyXrFQpGGi8IcT+vngJquNsgtV2W/c9PgqwWl8EGAkFdH3IzcLPb1xWhfxarcaRZg8FzIq7BCGK08JHsGVpo6VPV7+kVuXSHczsU/BKm49ZJDpHLHeRw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 17, 2025 at 3:40=E2=80=AFAM Vlastimil Babka <vbabka@suse.cz> wr=
ote:
>
> On 10/17/25 12:02, Hao Ge wrote:
> >
> >
> >> On Oct 17, 2025, at 16:22, Vlastimil Babka <vbabka@suse.cz> wrote:
> >>
> >> =EF=BB=BFOn 10/17/25 09:40, Harry Yoo wrote:
> >>>> On Fri, Oct 17, 2025 at 02:42:56PM +0800, Hao Ge wrote:
> >>>> Hi Harry
> >>>>
> >>>>
> >>>> Thank you for your quick response.
> >>>>
> >>>>
> >>>> On 2025/10/17 14:05, Harry Yoo wrote:
> >>>>> On Fri, Oct 17, 2025 at 12:57:49PM +0800, Hao Ge wrote:
> >>>>>> From: Hao Ge <gehao@kylinos.cn>
> >>>>>>
> >>>>>> In the alloc_slab_obj_exts function, there is a race condition
> >>>>>> between the successful allocation of slab->obj_exts and its
> >>>>>> setting to OBJEXTS_ALLOC_FAIL due to allocation failure.
> >>>>>>
> >>>>>> When two threads are both allocating objects from the same slab,
> >>>>>> they both end up entering the alloc_slab_obj_exts function because
> >>>>>> the slab has no obj_exts (allocated yet).
> >>>>>>
> >>>>>> And One call succeeds in allocation, but the racing one overwrites
> >>>>>> our obj_ext with OBJEXTS_ALLOC_FAIL. The threads that successfully
> >>>>>> allocated will have prepare_slab_obj_exts_hook() return
> >>>>>> slab_obj_exts(slab) + obj_to_index(s, slab, p), where slab_obj_ext=
s(slab)
> >>>>>> already sees OBJEXTS_ALLOC_FAIL and thus it returns an offset base=
d
> >>>>>> on the zero address.
> >>>>>>
> >>>>>> And then it will call alloc_tag_add, where the member codetag_ref =
*ref
> >>>>>> of obj_exts will be referenced.Thus, a NULL pointer dereference oc=
curs,
> >>>>>> leading to a panic.
> >>>>>>
> >>>>>> In order to avoid that, for the case of allocation failure where
> >>>>>> OBJEXTS_ALLOC_FAIL is assigned, we use cmpxchg to handle this assi=
gnment.
> >>>>>>
> >>>>>> Thanks for Vlastimil and Suren's help with debugging.
> >>>>>>
> >>>>>> Fixes: f7381b911640 ("slab: mark slab->obj_exts allocation failure=
s unconditionally")
> >>>>> I think we should add Cc: stable as well?
> >>>>> We need an explicit Cc: stable to backport mm patches to -stable.
> >>>> Oh sorry, I missed this.
> >>>>>
> >>>>>> Signed-off-by: Hao Ge <gehao@kylinos.cn>
> >>>>>> ---
> >>>>>>  mm/slub.c | 2 +-
> >>>>>>  1 file changed, 1 insertion(+), 1 deletion(-)
> >>>>>>
> >>>>>> diff --git a/mm/slub.c b/mm/slub.c
> >>>>>> index 2e4340c75be2..9e6361796e34 100644
> >>>>>> --- a/mm/slub.c
> >>>>>> +++ b/mm/slub.c
> >>>>>> @@ -2054,7 +2054,7 @@ static inline void mark_objexts_empty(struct=
 slabobj_ext *obj_exts)
> >>>>>>  static inline void mark_failed_objexts_alloc(struct slab *slab)
> >>>>>>  {
> >>>>>> -    slab->obj_exts =3D OBJEXTS_ALLOC_FAIL;
> >>>>>> +    cmpxchg(&slab->obj_exts, 0, OBJEXTS_ALLOC_FAIL);
> >>>>>>  }
> >>>>> A silly question:
> >>>>>
> >>>>> If mark_failed_objexts_alloc() succeeds and a concurrent
> >>>>> alloc_slab_obj_exts() loses, should we retry cmpxchg() in
> >>>>> alloc_slab_obj_exts()?
> >>>>
> >>>> Great point.
> >>>>
> >>>> We could modify it like this, perhaps?
> >>>>
> >>>>  static inline void mark_failed_objexts_alloc(struct slab *slab)
> >>>>  {
> >>>> +       unsigned long old_exts =3D READ_ONCE(slab->obj_exts);
> >>>> +       if( old_exts =3D=3D 0 )
> >>>> +               cmpxchg(&slab->obj_exts, 0, OBJEXTS_ALLOC_FAIL);
> >>>>  }
> >>>
> >>> I don't think this makes sense.
> >>> cmpxchg() fails anyway if old_exts !=3D 0.
> >
> > Aha, sorry I misunderstood what you meant.
> >
> >>>
> >>>> Do you have any better suggestions on your end?
> >>>
> >>> I meant something like this.
> >>>
> >>> But someone might argue that this is not necessary anyway
> >>> if there's a severe memory pressure :)
> >>>
> >>> diff --git a/mm/slub.c b/mm/slub.c
> >>> index a585d0ac45d4..4354ae68b0e1 100644
> >>> --- a/mm/slub.c
> >>> +++ b/mm/slub.c
> >>> @@ -2139,6 +2139,11 @@ int alloc_slab_obj_exts(struct slab *slab, str=
uct kmem_cache *s,
> >>>        slab->obj_exts =3D new_exts;
> >>>    } else if ((old_exts & ~OBJEXTS_FLAGS_MASK) ||
> >>>           cmpxchg(&slab->obj_exts, old_exts, new_exts) !=3D old_exts)=
 {
> >>> +
> >>> +        old_exts =3D READ_ONCE(slab->obj_exts);
> >>> +        if (old_exts =3D=3D OBJEXTS_ALLOC_FAIL &&
> >>> +            cmpxchg(&slab->obj_exts, old_exts, new_exts) =3D=3D old_=
exts)
> >>> +            goto out;
> >>
> >> Yeah, but either we make it a full loop or we don't care.
> >> Maybe we could care because even without a severe memory pressure, one=
 side
> >> might be using kmalloc_nolock() and fail more easily. I'd bet it's wha=
t's
> >> making this reproducible actually.
> >
> > From my understanding, it only affected the obj_ext associated with thi=
s allocation, which was subsequently deallocated, leading to the loss of th=
is count. Is this correct?
>
> Yes.

I think retrying like this should work:

+retry:
         old_exts =3D READ_ONCE(slab->obj_exts);
         handle_failed_objexts_alloc(old_exts, vec, objects);
         if (new_slab) {
@@ -2145,8 +2146,7 @@ int alloc_slab_obj_exts(struct slab *slab,
struct kmem_cache *s,
                  * be simply assigned.
                  */
                 slab->obj_exts =3D new_exts;
-        } else if ((old_exts & ~OBJEXTS_FLAGS_MASK) ||
-                   cmpxchg(&slab->obj_exts, old_exts, new_exts) !=3D old_e=
xts) {
+        } else if (old_exts & ~OBJEXTS_FLAGS_MASK) {
                 /*
                  * If the slab is already in use, somebody can allocate an=
d
                  * assign slabobj_exts in parallel. In this case the exist=
ing
@@ -2158,6 +2158,8 @@ int alloc_slab_obj_exts(struct slab *slab,
struct kmem_cache *s,
                 else
                         kfree(vec);
                 return 0;
+        } else if (cmpxchg(&slab->obj_exts, old_exts, new_exts) !=3D old_e=
xts) {
+                goto retry;
         }

>
> >
> >>
> >>>        /*
> >>>         * If the slab is already in use, somebody can allocate and
> >>>         * assign slabobj_exts in parallel. In this case the existing
> >>> @@ -2152,6 +2157,7 @@ int alloc_slab_obj_exts(struct slab *slab, stru=
ct kmem_cache *s,
> >>>        return 0;
> >>>    }
> >>>
> >>> +out:
> >>>    kmemleak_not_leak(vec);
> >>>    return 0;
> >>> }
> >>>
> >>>>>
> >>>>>> --
> >>>>>> 2.25.1
> >>>>
> >>>
> >>
>

