Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BBD7FCD98E2
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 15:08:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 844746B0095; Wed, 17 Jun 2026 11:08:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 81B966B00A1; Wed, 17 Jun 2026 11:08:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 731A06B00A9; Wed, 17 Jun 2026 11:08:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 455E36B0095
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 11:08:41 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C16B71C45BB
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 15:08:40 +0000 (UTC)
X-FDA: 84889736400.08.D269C8E
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	by imf12.hostedemail.com (Postfix) with ESMTP id A8A2240016
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 15:08:38 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=iQ97aFeQ;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf12.hostedemail.com: domain of surenb@google.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781708918;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H9tseRqnP7TDkio6KWr0QuA9aNrzwe8EnrwXOovFL6Y=;
	b=X85Pib4pjlUWk2FRYLZDOPj9KkkDU51UgWAG9GAouM1YXa2gstoULv/aCYW4t2JJ+WOBit
	pX+UcLg7vaouPxBRYt7/gzXtWFhedsuoz85iuWZCt4xH/My+z6LLqmIeqcu4ozkMXL0D0I
	xsABZHbmU6k1Xj7TYkREYQ/laSRbVPc=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=iQ97aFeQ;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf12.hostedemail.com: domain of surenb@google.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781708918;
	b=emunGQIDmstFj4g+Ge7hUI3swN0aLsHmZ8WqRWG6uTSIsHZzMneP0kwSsyvZKqJ5ybmNXb
	XfGLA1JlTY/BJUoBb6Ntu31CVRPDvbkl4oD3/YLmI627YpMZZAbhW8d5TJd+w1GHc8tzQo
	RQEcjNTvEe1Y7ILJnjtN7vaWBGZSGko=
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-51765331535so277171cf.1
        for <linux-mm@kvack.org>; Wed, 17 Jun 2026 08:08:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781708918; cv=none;
        d=google.com; s=arc-20240605;
        b=BDkO/3Z+qzYPlE9EZ8mlQDlR1LBHaU4wJwxdMH6uQp+o+xHzrsDM7vmiYl5Xy4G54c
         zWKqVPuH9/ogZ12SYvs5an4+i6giwFuVFtkdPXNTyG9/uCFWJrQPRx9TugIb6nH9L0wj
         8slJgVuTl9Jkyl2h3CMMtO7zLOEPyei3wINndfFLAm8a2WxNDLP0n6h04fIw/jORwD13
         /GWqBhS8QmSNj9qC3wKAjryRGLYxA+G+nf2c3tJEsV7cSgITRfbXNHFpk4ORYhcPYHeQ
         mHqoB6wcImCEDFT7UDqfHNKJVM++co+GWGjMfQ14AcrV+zuazlFPUcC8YqX4MiF1E2bm
         iF3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=H9tseRqnP7TDkio6KWr0QuA9aNrzwe8EnrwXOovFL6Y=;
        fh=PKALt0PTBalY84Oq3m/tY1VA7qMHXTy5PSYkWhzU3yY=;
        b=I/sYvvbaymXCALz9boEqlen6UxchEu/bTZeLB6lryXNcIhQohqkIeD/PoiOH+iSnJ4
         /88SDMlrJH9KIhxRkDFhyFScJyaWbQVkSQ0MFShn/RCIlMEfv3cq8CP30gEZ2bnWyw9A
         6a2J6GI+gF1J73R7MxKAgobXkCVZmhfSMMy+JZp2e+Cw/pZHKkwEIN8uLHiKgs0wUk3/
         9movaHMKM/FjKaLDfzWeiRqelJVgFPNBOs5y6cZuwyEPrNlStcl/njtTqWAOlNAvpftB
         Ikb6Wzrt42P3q1N2hC1Si2kFQ/XwLtZXuNxQa+O4Jmpxqo4lHFdX/OV3nNFJ16a4k1si
         kl2g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781708918; x=1782313718; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=H9tseRqnP7TDkio6KWr0QuA9aNrzwe8EnrwXOovFL6Y=;
        b=iQ97aFeQ2yNMyxxLY43jbAFub6d/bsz7oy6cVvVPTPlBa7njJYKjf+xfbe0IQdfjPv
         zD1q5PtIC5QjjAnuQhRogByAojAjF9jdIXEJJDkcwTQNFUTX9SdLdHU9hCeAZiDlCBDA
         UPai0Sef/HNLzpSxZukq4pKtcDxjw5K81erwwf093J796SZHdnvfhnq1+SlpLjyisd4C
         MVINSweGaw5RK9cBHOqokWPx97Q8nNhbDIbrNdmfTnVdJCOUkI7Qg6oN+1oVyKNpz7ud
         kzjztIQnmdfihbMCBd77Okc1iMhcMXs5wpNf7epheLicxkyD2P4ZJRt2X02RsNidb6Q+
         buDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781708918; x=1782313718;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=H9tseRqnP7TDkio6KWr0QuA9aNrzwe8EnrwXOovFL6Y=;
        b=FUc0eO/+IEz1D5+VDfVK/bzhY9SO0jJH0GUYJ4hMXelqvKnoYG3BGvtOUh6ql2EWUF
         MItN+JGhhRdXq3K+WlU7WNLNH6v+ZVGBk02cGFQ7tUsIpWAEAkO9JicBUzFTRstseFvg
         azlFn3grOXoNj3qCIPbjiTv5QorBNboX7NYgnBk1XSAJSiFefY1iw2nyCXr4NvlG72ug
         z0jXds7WIxKH3gTNCzexYMpVkTb99fVAoqZv7DOq3UkCS/9qgsorgtj0aq1IGzCw3va+
         6m+Zml0IeWubtsOf5d2aWClGeWAXF5Wt4PH0WcAwKxZ19tzLsbUDIdFE1OLUDmCd0APu
         WUhw==
X-Forwarded-Encrypted: i=1; AFNElJ+XpMKbq6NkagrR/MuQ69qNWZQ52ADAGjRM5syH0WRVC5Jfm3q2BmpC/Xj8nHgm8p04gRGmYznKsg==@kvack.org
X-Gm-Message-State: AOJu0YwlReiUgQp1cX5fSBic8rq3rMqU9i7yxBK6fkd2y9NVSNjXzSMv
	w9SuED6ysQhavCX0v/SkQFRgDuQ0L78DABmOILrAc5IciojccGYU3k2BOxWOcaMtzRUo5BtrZHd
	hXVk23jvyupn57yof42xKUEorcZRXQDJwNXyfZ9R5
X-Gm-Gg: Acq92OFDEDA9SVe7iTBrQ+0xpsoJpA43bUBgmLFqVVaPOU3JjP2WQhwDHKOqzX/SVvW
	YqrOvlJh4ZNrBstoaNAg3vX/S1IoE3dca92edWUZp4/b+V3O5qL/iRWphqI9u/V+eA96wUU1arR
	tj6lWSC/DmsLks4dFkeVXaKW/27H5WPOuAUxO/HnpFersKL0yVaqfVGtaQ8z4mNSfet6CHdVP2Y
	/w+DbW4XLEEcqwO6rXHgj5z8Jt24IT/pT+LSJ6YPXhvQa63bpmKvBN+n05YrWB6GzhZXF5oA2wo
	zsUArx7EURpd3EemFg3jAsRhH/w=
X-Received: by 2002:ac8:7f56:0:b0:517:6010:7c71 with SMTP id
 d75a77b69052e-519aa973f19mr9381451cf.4.1781708916916; Wed, 17 Jun 2026
 08:08:36 -0700 (PDT)
MIME-Version: 1.0
References: <20260615-slab_alloc_flags-v3-0-ce1146d140fb@kernel.org>
 <20260615-slab_alloc_flags-v3-14-ce1146d140fb@kernel.org> <78b67a9b-44e5-4649-957a-9d42bfaa098e@kernel.org>
 <26c29e4b-09b1-424a-b4e4-3358aac20115@kernel.org> <1bf749a4-1519-4d14-a0a7-6d8a56a6c850@kernel.org>
In-Reply-To: <1bf749a4-1519-4d14-a0a7-6d8a56a6c850@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 17 Jun 2026 08:08:25 -0700
X-Gm-Features: AVVi8CefVPn3P9FAIjVd3OjYJYXvkX-ZXLKpOt3BkEW1wHmD4yyLF5UmdjrpubY
Message-ID: <CAJuCfpFacu+j_sWPSxUyEbG_9=o=GycZ1Y8bVob+sGSGO2cDLw@mail.gmail.com>
Subject: Re: [PATCH v3 14/15] mm/slab: remove __GFP_NO_OBJ_EXT usage from alloc_slab_obj_exts()
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Harry Yoo <harry@kernel.org>, Hao Li <hao.li@linux.dev>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Alexei Starovoitov <ast@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>, 
	kasan-dev@googlegroups.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: A8A2240016
X-Stat-Signature: ywptif3iwr6utdh8ujnr83arnasi6wbe
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1781708918-143363
X-HE-Meta: U2FsdGVkX18zRfSHkuFDCPwvBuED8IgPprORhnh6+JwcAHqGa5WfVfNdZKJhrVvrt/azvyvASF+3LM4+tPxM83dqvGZdMjVDLt39bKAp28DdxgQqkpiUovs49S3+IFoE6ypGT6JwvaWXRf+VdVsmZH3QWh27861Y4HOkTs778TwjV7zZ59Kgm3FBg+qJqH6NrIj9xfqQmA7SPiGbBwqpap8OMNuRGW2toj0HitPfKKC3ep+jsrp9g2Hw721EAYKPeeXxK5qm1/sMNIku4WjLiZuMTtXlc4UmK4U+Ipquo93/ejP4x1BWJhXjRnhGpc1l4HDjwkfVdYJFLX3LzP7GfZGuvwd/UGuGh9shq14occDq8ljTvhtm3Xb6roGEnng8gQonH8woA6GqVeGHhpWxR3YrEOD+DqSpvtvHWDAcQxTcgOPc6s1XwdfLT8b7Yt0dh9uWoKVrCu+eMvuHc5IY7zRCwBGk97l9vNVqMgxtUVABK0IZAApN9+A72m9mhbDcixDwrCfoLDGQ4KzSgskT4CGph83D03Po0y4D6vlK0Ntjy4IXYrk0qk9FCHW3+Ziaplt91Y7q/pt03hkg28nYA1XMav+rTavjKOjxmnlTic/hGBx4ARIYxa9+y3oWmvooZPQl8mF6lJSK6JxmXlzB5Bla9Eos30VU16s3DoHR1UUcZkKcCWDknk17y4J096aoK+uPQP++4GX1BvKL6HzExemXopR/1hamMEMDHvwH3Q5ixM0fpuw9yzw/xMdS+b4MeA5e16CXiTZ//djcVBrK3k8dMbBxQNGFb3VtObSDQfrI5fAIQ1e6A/kX+CDjJlhZma48gfi/n7bSV68nsFH7G01aOrPuyj+xqH/8usK/dQpMbe0YC6yR4jyZkiFQnXeTYMVjMR4OKKc1LsiIeTq/OgkYpBJnxCsGGLfAYZzb7088pbqSI/t61/B4a+HLOARnDmY3xTeFbFzUgawE9/L
 ynzPonKl
 Eo1nDxk5jh8TnhRaNnt7Juifm2Sf5F+IDlNPzDT75OFu+nEpoWW8GdZ9lfMJ7tXNZl6RSavtZwJIBlYxQUwnZd7dr1iAs4ZQwbLjgUbSzA2eJG10cDpKYTsVbq9XmzdUKsr6p79df+7IZ5Ns0bH0vuTVgNtbHDa7NlaIYB2r8DL0up25wb33ma1DL44qMjxzcKkY0hIyJFwofuHp9DM8DguUPub619UX2Rt8DZN/DYaGvIabx/gAlySJW7XxQQHDt2Eb+RJn18Oe9v/1q3L6PCRPsds0KgOvf4SE9Cpuk3wSBPE9rhUTF1FrvxB+VCorkTdOPozDKZBN7Dsg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 17, 2026 at 7:57=E2=80=AFAM Vlastimil Babka (SUSE)
<vbabka@kernel.org> wrote:
>
> On 6/17/26 16:36, Vlastimil Babka (SUSE) wrote:
> >
> >> With some comments below.
> >>
> >> I was worried that perhaps replacing SLAB_ALLOC_NO_RECURSE with
> >> __GFP_NO_OBJ_EXT will create a cycle of
> >>
> >> alloc_slab_obj_exts(SLAB_ALLOC_DEFAULT)
> >> -> kmalloc_flags(SLAB_ALLOC_NO_RECURSE)
> >> -> alloc_from_pcs(SLAB_ALLOC_NO_RECURSE)
> >> -> refill_objects(SLAB_ALLOC_DEFAULT)
> >> -> new_slab(SLAB_ALLOC_DEFAULT)
> >> -> account_slab(SLAB_ALLOC_DEFAULT)
> >> -> alloc_slab_obj_exts(SLAB_ALLOC_DEFAULT)
> >>
> >> with __GFP_NO_OBJ_EXT, it would have been passed to refill_objects(),
> >> but SLAB_ALLOC_NO_RECURSE is not. However this cycle does not exist
> >> because alloc_slab_obj_exts() clears __GFP_ACCOUNT (as part of
> >> OBJCG_CLEAR_MASK) and memory profiling itself does not invoke
> >> alloc_slab_obj_exts() when allocating new slabs if SLAB_ACCOUNT is not
> >> set (which is interesting, by the way).
> >
> > Hm yeah I think we should propagate alloc_flags to refill_objects() etc=
, to
> > avoid later surprise. But can be done as a later cleanup.
>
> It's also not a new hazard I think because while previously gfp flags wit=
h
> __GFP_NO_OBJ_EXT would could be propagated more thoroughly than alloc_fla=
gs
> for obj_exts only __alloc_tagging_slab_alloc_hook() looks at them, and
> alloc_slab_obj_exts() (from account_slab()) didn't either, so the amount =
of
> (finite) recursion is the same I think.

True but I think we should clean that up anyway after this change.

With the fixup you showed, LGTM.
Reviewed-by: Suren Baghdasaryan <surenb@google.com>

>
> >> Also alloc_slab_obj_exts() propagating SLAB_ALLOC_NEW_SLAB to
> >> kmalloc_flags() is little bit confusing because it does not have any
> >> effect due to SLAB_ALLOC_NO_RECURSE.
> >
> > OK let's address this one by this fixup:
> >
> > diff --git a/mm/slub.c b/mm/slub.c
> > index fc5b8c85b690..dc4b4ae874ce 100644
> > --- a/mm/slub.c
> > +++ b/mm/slub.c
> > @@ -2164,6 +2164,7 @@ int alloc_slab_obj_exts(struct slab *slab, struct=
 kmem_cache *s,
> >  {
> >       const bool allow_spin =3D alloc_flags_allow_spinning(alloc_flags)=
;
> >       unsigned int objects =3D objs_per_slab(s, slab);
> > +     bool new_slab =3D alloc_flags & SLAB_ALLOC_NEW_SLAB;
> >       unsigned long new_exts;
> >       unsigned long old_exts;
> >       struct slabobj_ext *vec;
> > @@ -2173,6 +2174,7 @@ int alloc_slab_obj_exts(struct slab *slab, struct=
 kmem_cache *s,
> >       /* Prevent recursive extension vector allocation */
> >       gfp |=3D __GFP_NO_OBJ_EXT;
> >       alloc_flags |=3D SLAB_ALLOC_NO_RECURSE;
> > +     alloc_flags &=3D ~SLAB_ALLOC_NEW_SLAB;
> >
> >       sz =3D obj_exts_alloc_size(s, slab, gfp);
> >
> > @@ -2203,7 +2205,7 @@ int alloc_slab_obj_exts(struct slab *slab, struct=
 kmem_cache *s,
> >       old_exts =3D READ_ONCE(slab->obj_exts);
> >       handle_failed_objexts_alloc(old_exts, vec, objects);
> >
> > -     if (alloc_flags & SLAB_ALLOC_NEW_SLAB) {
> > +     if (new_slab) {
> >               /*
> >                * If the slab is brand new and nobody can yet access its
> >                * obj_exts, no synchronization is required and obj_exts =
can
> >
>

