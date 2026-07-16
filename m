Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5D05C44511
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 15:33:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9BC876B0106; Thu, 16 Jul 2026 11:33:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9932D6B012E; Thu, 16 Jul 2026 11:33:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 883086B013F; Thu, 16 Jul 2026 11:33:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5EBE56B0106
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 11:33:11 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D29B4401DD
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 15:33:10 +0000 (UTC)
X-FDA: 84995033340.05.08D2DB1
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	by imf12.hostedemail.com (Postfix) with ESMTP id D1A7D40009
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 15:33:08 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=NfE0CG6a;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf12.hostedemail.com: domain of surenb@google.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784215988;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gqP+mYqeDojLhRDbRbXpVEiCGBcqs/tKJr25Bs+t6+0=;
	b=BX+KgkvNsXAfQ9UFkYm4yJBNeBzYKKNPsCXTnCbDpgZiLU+xl7x3SzHMCfsnz4emhtArYT
	lwgasFU4AjDjJUtX3LMvsyykCTAppnTuYztT0sJQH8DiBBYzwsnewaywTKIyQIaEg5Kf08
	3V8MhDOWjKJrMri9JzWNu2tEgPnJQEg=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=NfE0CG6a;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf12.hostedemail.com: domain of surenb@google.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784215988;
	b=IY8O0zhfwl0D2wkQlENkoOcZJuDHhHhMNaMG56SSY2kLPxpSpsocxo4PH6+xusuUmEi0Bv
	Yh75cS7s0a63zWVtffqkd5nJQ4CUP8zzWq6qFLRjk+GrceY6eXQ2/WPQ+d/0H2ZsWZQc0+
	W0Q6G25L7mvREywjVqUlCl575Z1e9p8=
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-51c10ed63c0so35391cf.1
        for <linux-mm@kvack.org>; Thu, 16 Jul 2026 08:33:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784215988; cv=none;
        d=google.com; s=arc-20260327;
        b=DjwYL+VmIwihOf850UXGHq9/pWXEMYqdfv0G7uQfbzWcka5aKYfF5dTUdh5Ir2TtDY
         JJwkkdH0Ftpzsmkziuw6bajjjdmWvc2yn7n3zhJjx2k7Z4yGfY4IlY/e8LmdcDSxyDZG
         vdCRXZFwimuHV4g61tjgq/tF3sSi651+DsK7AO8ZRvals5DPFbjL7qJ3JlEOtQO6f4nZ
         kvwxgMMVLTrf4v8JkLkYcxb7wvDK/+2MU0x2fdpu8+t4pT/Ye3PdfCMavthnGxV+DLoh
         +Pco4ESA8grRz8nBm6iizut19QBArczwiLWuZFf6Gx6eJ0lZ/bSPM2IEe8FYh0BRsn1h
         9abw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=gqP+mYqeDojLhRDbRbXpVEiCGBcqs/tKJr25Bs+t6+0=;
        fh=JxyN4PMFXY5mk9th7iFhoZloAvVfAg+aYE8I2Xei6Rg=;
        b=JwI7iyrnkXHsN5No/iDIdbjuYIufEafZAyWesQOdV/hTRyYKeSNnF3+Mape9mo+QUW
         XythUNDq6AqBP5z0aKEJLQ8sS1APNPjlyVwUsTCIVi8EclL0RZ3NnJJZc/qD+5cyVPuM
         D+zHrcmdCaXlt05YrYey0NvbAwbwahIsXGAkkQwlQGVfOP6QRegOXXnf/zr69JF1E2ze
         boU2VrqM/wKYbybI9EdLetqc8I1wmIwzFD+KRQlO8At7RuR7i3ZXY//yL6s661HJTJWR
         j7bAuUstGn/ze2cv+2viRYxpaVH8aXfoGjQ/NHWhW9irRYNgDEAK7iAwrCBJvAsLCA6B
         m+VA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784215988; x=1784820788; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=gqP+mYqeDojLhRDbRbXpVEiCGBcqs/tKJr25Bs+t6+0=;
        b=NfE0CG6aics15Kbi0PYIrzowXUWarSYHwvbwVTJjJlW6zGLjhBW8p3kIqjImVGoNuD
         4T6OwTQXUrYBz7xiPZ5ZlAa0esFuMgmtXS8LsWXtd+kw/cHjPQTUIdF7QLggEq73o3ss
         Cz53QeNjfLYmxKNuhqC2tEMFa3VhiWDP+GtOuONvd+W/TX+wEa9CANX5g0Ix67G7iJC8
         QX1gFOfIXHF4aupLcuT080c6WTuU0xUJEz85OYd2j3OzPzLBQ4yIWlaWBIzAtRhlCfZP
         qnkUUDv2yPfWEPQ2aJ/fNOJ8rzTrjUhbuxO9CVJd8s0wWLwwFGwhyeX1js3KF8Rso4aO
         FneQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784215988; x=1784820788;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gqP+mYqeDojLhRDbRbXpVEiCGBcqs/tKJr25Bs+t6+0=;
        b=dJz0mJbvmF1n4oLsh00NxcYpONA2tUmbGpMJZ+O7OyM1H58s9mFQvrZ8wh2qIX5YQr
         MyfDGddShIwvQM8c1bx9wehO9J8VmbCdzZCjli8UoLdtKPAmh8FhIbisGr7IA12CAGB4
         naP5iM+ugsBGk79+UPs5pwDcxEzfyVDRSRkbSdn9a4s7z4lcFP0lCMP4G/FPZoytXYOR
         dGobW0n91EjOGBbc+WKuH/vOXgw3Brn3U/aKoXCOL8i6AkbtZQVU+vUXgHkMs8MV/BcZ
         DmtdLAT54hfOKi5EpfUxSxbgpMzoOrOB3B9+S5BkMFB8t80arxZMOgVaGSQ3Ldg8E+ln
         0Tyg==
X-Forwarded-Encrypted: i=1; AHgh+RpbL+3ndX7g81sREfCGsCCi52VdjysXseN8uejh94hYBb0mPE0ujJFVbYNWY9V67dyPqHOEzYID3g==@kvack.org
X-Gm-Message-State: AOJu0Yw5fQTLzO7zaLdbecVeReiPWaBb03ZVYN+zbWGmuXO5AtCDISBJ
	cqOqSem3j0stkZcEFmezRAaiSOxYLCqEzU5G7QIVbtTjy1oLDPUWdsADAcPzq5I8x9y6KNcD1Tq
	UG+qj49KAxqiH834vUABne372cPlHkR3BUKlaDzQ2
X-Gm-Gg: AfdE7cmlG+gDuHouHoek28SiDC1/Oh/j6HeZwJF+fbYl7iFmgeb8FrqZQ6jFXEFqCJN
	1zOBWsiqvURrU9h9aeDM4vDyKPcRHGMcZ8z/qBoVdnLzcOzcIm2BCFh2sGMzNik80Pn8y/S0XR4
	p6HiEc9bv/WETpkl9E0GI9rkfofqpoR93DnTrZToX74zuGfeiSG8FkLKFFPKzFB5QPxPx+xW60U
	sIuPRVhvELxqrQKp2Rcgw+i50ZDyfSCrHkEVzc/po91mv5NM70+QCa/bZUhlPJ9ZBQwhzgNbKlG
	u4oqXxqibii5PQleaMlh8/QWOw==
X-Received: by 2002:ac8:5996:0:b0:517:5e32:2d14 with SMTP id
 d75a77b69052e-51f7e705596mr9599801cf.10.1784215987211; Thu, 16 Jul 2026
 08:33:07 -0700 (PDT)
MIME-Version: 1.0
References: <20260715-b4-objext_split-v1-0-9a49c4ccf4c3@kernel.org>
 <20260715-b4-objext_split-v1-12-9a49c4ccf4c3@kernel.org> <CAJuCfpHuXu3BDf93zeBQWSW_k5wApegp44rHoZwk5Ym6xxbqEA@mail.gmail.com>
 <e126d6b1-bed7-46bb-a8a3-cc555707b516@kernel.org>
In-Reply-To: <e126d6b1-bed7-46bb-a8a3-cc555707b516@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Thu, 16 Jul 2026 08:32:55 -0700
X-Gm-Features: AUfX_mwOlgPh2vQsFfJAl8XC3VAb0x-hSX4wZUGMP4QuR9xJ87PvP5NzdSVYcPQ
Message-ID: <CAJuCfpFicmMa54V5qVY7BYQuNih9u+-bQ+x51VDza7zWPK_mOg@mail.gmail.com>
Subject: Re: [PATCH RFC 12/12] mm/slab: stop allocating objcg pointers when unnecessary
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Harry Yoo <harry@kernel.org>, Hao Li <hao.li@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Alexander Potapenko <glider@google.com>, 
	Marco Elver <elver@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: D1A7D40009
X-Stat-Signature: h34e11i3xfa5bt8r3urstcupk3hboeyu
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1784215988-935864
X-HE-Meta: U2FsdGVkX1/d9ICC6O4Ow4/4Wsd2/9v95hkz17LwHLcrT6zXS+lwEO8hWZWQPKMvj7BXDs4GAE7HA3pVlzywM1M2/6pSECc4ejdQgPpeshdsSOWzf7KGUu2chcZ8nXacX8yc0dqghVFFPviXlU5D2vfV9pG1LS6VrSlYhqaf1N/ty3VO914H6VBVeKqpo8ZjDPGUjYrHr+Xe3fml+kgEsginRtkLR4VcZUIQb8bKnifLpQ9ngP4a3L0hyTVHjvNuW6FZPLYuE8cauFOqQCO/0jLPUrxWQAnPyPEq/c82mvB0rlqSjOFjptJ+qjiTgOGfoFiAwDqjKNoxrtqYtMNd+t7VCDpvEBTOrElqWSsHmc/K/avxPnSwDLoXeSDl/WZfQS3fOVsS7H/9xl4JV4xd7stX4cONBF1LMQM/yiMXflGENIuPxXTNYBz7hALxWA1UmEHsWVj7MdAzHSEpVa1lIFe6uCvPmVlVkfeIicDKZPNjZHt9hbEn9WD7ddQDQj8Bh4r3+yotA4DoX1+SpNYcjtEG5B1EgSUf/94CL2WC5fNSaTk3igT7rU/xCJaMEbNx6nRKOfqlwnTUCbCq/EN1+63Yfmi9ETuFjQFYIIEK8rjMrTqLr8oU2rdd+FN/lCkOTi8AC1pbsacQQ188ps9KiXZiPRi6dB2SxKe2KY6xYlhyb/6C+aYsP4ZbZwotDqX6dD7k9QLnOWAMdtnlr+EDjeqjdjxIipsg15ot+8eqX0gNEMsd1xfW/tRRM6hulSRCw2/8BL2425RVBgdLMIL9+3Tp19++KGk3STPzZyxeKdHaUIX0lcwCrMgw4A4ZFLdsxI5uDRBJfn/REGWwyhn+RKU4dBae5PEWGarWisWp2WDEDz7KhQK5Q1eulBKp7Q6eXh4IyH5Pf9uVGX3a2p3Dp5GExyAmynvw8HZVkZUuo00i5WE+bT/MBxskmgUSkzT/ViodfsePWsZe05Gp2dI
 it2Oh2R3
 POCxR2+dQmi7ye/rNWvEPRlmsJitHs1/ml4vniOxe7cCxQHpOtVD+NMN25xbpCB2FG12JHCNeK51rovaHsWl0xHNZWV+FzjaqV+/K29nD+n7Vw7FksOueHH7rTf2JSEVT1gyA7GDxC2gDl6sfLXkEHPIyFtOfkcUo0hKS3bmBVimy9fvy8f3mB+Fhsf5+fbRXxu+xUjbjvfcvLr+X+u37eh0Lu4acIl3v3S3yOAOVe8+HOaspUzWORUvOxuCFmzDUeIqrHODOx95B01M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 16, 2026 at 8:08=E2=80=AFAM Vlastimil Babka (SUSE)
<vbabka@kernel.org> wrote:
>
> On 7/16/26 06:46, Suren Baghdasaryan wrote:
> > Maybe now we should rename static_obj_ext_size() to
> > static_obj_ext_max_size() as it reflects the max possible size of
> > slabobj_ext?
>
> Hm with _max_size() it doesn't have to be called static_ anymore?

Yeah, static_ is an implementation detail anyway.

>
> But maybe we can get rid of it completely.
>
> The only caller is calculate_sizes():

I was thinking the same but either way sounds fine to me. Keeping
obj_ext_max_size() would be a bit more self-documenting I think.

>
> #if defined(CONFIG_SLAB_OBJ_EXT) && defined(CONFIG_64BIT)
>         if (slab_args_unmergeable(args, s->flags) &&
>                         (aligned_size - size >=3D static_obj_ext_size()))
>                 s->flags |=3D SLAB_OBJ_EXT_IN_OBJ;
> #endif
>
> We don't have slab pointer to pass to static_obj_ext_max_size().
> But we should be able to figure it out from the cache via
> cache_needs_objcg().
>
> So we'd need cache_obj_ext_size()?
>
> The static max size here works, but may prevent SLAB_OBJ_EXT_IN_OBJ
> needlessly if padding can only fit codetag_ref and not objcg, but
> we don't need objcg.
> Which is probably only theoretical at this point as kmalloc_normal
> caches (that have no objcg) have no padding, at least without
> slab_debug. But still.

Maybe keep it simple as is for now and then we can optimize it further?

>
> >> +       size_t sz =3D 0;
> >> +
> >> +       if (slab_needs_objcg(slab))
> >> +               sz +=3D 1;
> >> +
> >> +       if (slab_obj_ext_has_codetag())
> >> +               sz +=3D 1;
> >> +
> >> +       return sizeof(struct slabobj_ext) * sz;
> >>  }
> >>
> >>  #ifdef CONFIG_SLAB_OBJ_EXT
> >> @@ -741,7 +749,7 @@ static inline struct obj_cgroup **slab_obj_ext_obj=
cgp(struct slabobj_ext *obj_ex
> >>  static inline union codetag_ref *
> >>  slab_obj_ext_codetag_ref(struct slab *slab, struct slabobj_ext *obj_e=
xt)
> >>  {
> >> -       if (IS_ENABLED(CONFIG_MEMCG))
> >> +       if (slab_needs_objcg(slab))
> >>                 obj_ext +=3D 1;
> >>
> >>         return &obj_ext->_ctref;
> >> diff --git a/mm/slub.c b/mm/slub.c
> >> index 771d73abacb6..09c4931e5435 100644
> >> --- a/mm/slub.c
> >> +++ b/mm/slub.c
> >> @@ -2503,6 +2503,9 @@ void memcg_slab_free_hook(struct kmem_cache *s, =
struct slab *slab, void **p,
> >>         if (likely(!obj_exts))
> >>                 return;
> >>
> >> +       if (!slab_needs_objcg(slab))
> >> +               return;
> >> +
> >>         get_slab_obj_exts(obj_exts);
> >>         __memcg_slab_free_hook(s, slab, p, objects, obj_exts);
> >>         put_slab_obj_exts(obj_exts);
> >>
> >> --
> >> 2.55.0
> >>
>

