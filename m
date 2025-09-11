Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14E31CAC587
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 16:18:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D1AA6B000C; Thu, 11 Sep 2025 12:18:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A8C96B000E; Thu, 11 Sep 2025 12:18:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E5AB6B0010; Thu, 11 Sep 2025 12:18:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3DA166B000C
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 12:18:45 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DE550B9BE2
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 16:18:44 +0000 (UTC)
X-FDA: 83877477768.10.6865326
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	by imf30.hostedemail.com (Postfix) with ESMTP id 03CA280011
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 16:18:42 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=TV8yvN+J;
	spf=pass (imf30.hostedemail.com: domain of surenb@google.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757607523;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=24HW7/AsImkzQuXxyaG6On6aHykiQ1FfjR2dV0EigRA=;
	b=aikVM/Y0UzBycW1bVm28dppp3fDKiti1MI7pcOGVPpHWhIfTRr8AirmlZpPyuwS6fDerDJ
	wNQ380fQFE+JI7VW6znw+e+7nSTjJL7JpQ0Ccx745bgovOTfOcjHjuichdr4dfRyuTBSD/
	CKlulZa4QP/dhXQHNV7dFzUgrBElcWE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757607523; a=rsa-sha256;
	cv=none;
	b=oGJnrspxC4l8kOxBnFPoFu3llGTLkDSg/HBHyD/KLN+OAbs7tyToxK2OgYDGzgzt/5CKma
	TjZdyigxUI/1LMVdOhqoxiXB5S8TtaP3h5+grueJMLetiLJN1qCYkZgVF1ylf3ZdjJr/Ky
	lJz+iB1eMV9dPHGvIBlOmUFfMt8gsA0=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=TV8yvN+J;
	spf=pass (imf30.hostedemail.com: domain of surenb@google.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-4b350971a2eso143551cf.1
        for <linux-mm@kvack.org>; Thu, 11 Sep 2025 09:18:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757607522; x=1758212322; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=24HW7/AsImkzQuXxyaG6On6aHykiQ1FfjR2dV0EigRA=;
        b=TV8yvN+JKo1biYp+hpIWXrzFTgckPGOktsznbXZ7m9hFfIXVj3qtI+8goN6dKujDex
         k8Avu1cxxiYPvcli5z7Fheqd7/apUVxvU3xIyphu7AmTXrjCwhZI8RSp+PhiZ2Aw+bMD
         //hbI3lyTKR0pSorvPKIt9gW47zDNEGdbslorjP1eCXUij1DySTqTYREzsoKZ3tv3jcE
         UaezqsKjyE7sTKTzkneceDQ3VhJEfbCc6dvSiiGp9VZpDZ5pYYy63WMJosWPvM2baJrd
         U1pa7j0mCh3m+UonLH/0LI5mu3nWN5NyxudP68jw+fWc5EuJJ369/llIPmbBf7rvwXzd
         7zfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757607522; x=1758212322;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=24HW7/AsImkzQuXxyaG6On6aHykiQ1FfjR2dV0EigRA=;
        b=lzQ1rPASTRQYs7pMAz0FSWpr0U3HWaZLO0ArLrWPH4s6xMQhRbeA0jhTaW/CSNHjyr
         QDjkRul4vay6fLanmAuglcXkVbjsb18XHr5o2lqLgKj/ZUt29+qZTQ77qIMiKQ+KacvE
         gft8atejnFy/vvZRMjdGsybaqZzfMgBHdig0rbNAm2u4ZFgNqWXzXeHnND95rPu+fW7H
         r9dnVTvnlI4APgMLOJ6PtycR8IyH5Qy2Ocbk7HtSIa/x4fLVtTrtoOGYXMb/u+ACllPI
         n6Ii3BKDnctnEyWU8BRTwsfxZyQDhZOVuWsorCR27cBXz56NR9+NF7WDEDOLIHT3lJtu
         tuMg==
X-Forwarded-Encrypted: i=1; AJvYcCU1FX0ikXiZEhqNnn0JJHWR38On7LrGVpqWn7T+hJ7rOvXHiHiCu7wH9gU0uJTy+Ikqjq0IjvKo9g==@kvack.org
X-Gm-Message-State: AOJu0Yxi5y4/kOYzSw+JZcOU1Wfh9G3trSNkkuV2erJc/1USJmMVUMG+
	FeimhII9RsYRkBsDs3WiKWUD+B4dtEEKn/+k0po1fpfhOGopjL0qcooF/Dqa/I+faDw1oY5uKFj
	FrW/c9nalahXIaEnmQh8AyjaUlzIE6AIdAW7QPv5u
X-Gm-Gg: ASbGncsBvxtEHFuQEz1pUXkQyHO51xdFRXTv+B/efkHTJvEunCDhLc43vxwrZtgVUoN
	+XquGaVYbi4xvXFqgS+aGCvGTArI/6MuERK7hYjGlij2g20FKeLvGeaCu7vIw0mvbILIRqFvXuB
	ig5Ej3FRtf+SnH6EnEeY6waFYQeKF1v6MnY6dGHL8OSts7wZPKou8flSbxQIw/p0WLtzSUyCCLu
	wDPfRjYURMtJHputoyADbbnzVHXf/MdtK1AHeP/LGPaeadpy51XwME=
X-Google-Smtp-Source: AGHT+IFepjQyaeSo7RONPmZKnbu3ouTnjNwcjqHMB6uwq7dFF7AS+N9S9oBOBUO0kd+RV9Ps1ce594/bcKUPIM1z+ZA=
X-Received: by 2002:a05:622a:311:b0:4b0:85b7:ea77 with SMTP id
 d75a77b69052e-4b626dac8a6mr12181721cf.3.1757607521282; Thu, 11 Sep 2025
 09:18:41 -0700 (PDT)
MIME-Version: 1.0
References: <20250909234942.1104356-1-surenb@google.com> <20cafc1c.a658.199394de44e.Coremail.00107082@163.com>
 <aMLvCCZbmpSE/aql@devbig569.cln6.facebook.com> <902f5f32-2f03-4230-aab0-a886fd8e4793@gmail.com>
In-Reply-To: <902f5f32-2f03-4230-aab0-a886fd8e4793@gmail.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Thu, 11 Sep 2025 09:18:29 -0700
X-Gm-Features: AS18NWBuPzWz3lwq_X1O1VoJwliWLiyJCfV3kEGiBFilILnw1cC21z-lWQT3adQ
Message-ID: <CAJuCfpGezf06eR7WnzizpwTaxZ5Rm8jbeW4y87zcr6LZuJ9MZA@mail.gmail.com>
Subject: Re: [PATCH 1/1] alloc_tag: mark inaccurate allocation counters in
 /proc/allocinfo output
To: Usama Arif <usamaarif642@gmail.com>
Cc: Yueyang Pan <pyyjason@gmail.com>, David Wang <00107082@163.com>, akpm@linux-foundation.org, 
	kent.overstreet@linux.dev, vbabka@suse.cz, hannes@cmpxchg.org, 
	rientjes@google.com, roman.gushchin@linux.dev, harry.yoo@oracle.com, 
	shakeel.butt@linux.dev, pasha.tatashin@soleen.com, souravpanda@google.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 8c8uhd11yopmjh43sgrdth3r8hp7o8aw
X-Rspam-User: 
X-Rspamd-Queue-Id: 03CA280011
X-Rspamd-Server: rspam10
X-HE-Tag: 1757607522-173872
X-HE-Meta: U2FsdGVkX18hwKMmos3wjKucNt8yKnUm4qUpldROGmZFmRKqxQEO4MMxbGd9jkb8EmgRYx/wFbR7GcYksBZ5nPtoMbvrS3ww25BOMi5R9ihEVvFn0iDOX6Z27iatkH43jvkuKIqTKfdks7YjR3/KhHPpU8//jylA99G5XZGX+emKOVE7faV6Z6652y2cICp4XiOLOFwI2IE6griRbXUgFytM9zSXYe2BLN6+QyOMIrUhUxQFMmSMjZTzv4Q5V5E/wqMUCteBrZL573lhrts7yp67NlLt34zt8WehxboqOvL5qHMH7/JU6etxelrdOqI+U+BspGn1NkYIiIYARuZiYHP6no+ajxTYb/C0/xFa9dnt7OXxgjTJIqBy4MdngmyknyNkK4S6uOt8ZKXpHeq8KrUiKTmyUvMF0Uv4tLW+vQsKh7fYWH8B3qDkbAzRzPi5vx/mjtvUOpTBRt6oVvwp0GjFbTlHZXvhprwoIQ+hHhOMWcqw/HnZduSkWvSgT+jk/IEYsQWYJWWbVum8LMdxGANMvxe8NdsCx+fZzn/CJTlPMznz3Xig9Jc1HEcm7vHDhZHVKDQ94MthmFgq8P+C63ONGf9O2bXZoNyS0AcRsS5L2Ls+i+7ap0+xuQrbS9Fg2yyosZkyxgD8RhWTppFn6ysjs9fR7dtof50tgOhZ4RObGGIirZ2DW5VuCCkdFICNsDiuceqT3YVeLA5lWHG+N7ZHS0V2qa6Gu3sbe1M4SRdmHXNEBZEFe4jwP02PDwfmqQWdMXWx4mqBF7oHy0iIsNjwknit/PsGZtAf+Tnpqz7wWpxgIB2ZMzRV6bxzUX0hWmpmoOE2hugeQChmNJ4c4hD68pbzL6PWyiii/2r/MWWsejK9+yxireeyw6a+J2ZKDyM0268yjHa30HxPJzVD0UH0/9WNunj2kkCflQ/8Xp3X2RYIsyJZSxNusAz0q8i+QOiL57tYJfdbNreaQDT
 T4SPeY8b
 fkZTZF2LAimv1MoUpJjVc8kQbDZyx4yuzNpuTyZSdJ6CV9pqX8THsXFroavcBEyMVcZvlG9CrqwK+7zO2fKR8ZQuixZqFxvQcGnHTvXhDZ5Hb3/xqqTOzioHGIBJ4H6ts7tc6IgpUdAdG9EhTKW4kg7L+FAfzvQV1iqY9dPJnrLMYQyBvF68fOX8Cu7o2ffn1OnJjKCqAzG15dzDKoMMUC5yS28XbvFZEbMXZXFUVJr5dpEZGX5DroYB78ohxZ1Mk1QMF4o+6pgNqJb9YPYIr98YG8bfUNBsjKuib/Z1yCVTsabcWLAElrpGlO7wWCey3suxOdXEY5nwjpBbmpknmdD3+UcAfB6tTPY4k
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 11, 2025 at 9:00=E2=80=AFAM Usama Arif <usamaarif642@gmail.com>=
 wrote:
>
>
>
> On 11/09/2025 16:47, Yueyang Pan wrote:
> > On Thu, Sep 11, 2025 at 11:03:50PM +0800, David Wang wrote:
> >>
> >> At 2025-09-10 07:49:42, "Suren Baghdasaryan" <surenb@google.com> wrote=
:
> >>> While rare, memory allocation profiling can contain inaccurate counte=
rs
> >>> if slab object extension vector allocation fails. That allocation mig=
ht
> >>> succeed later but prior to that, slab allocations that would have use=
d
> >>> that object extension vector will not be accounted for. To indicate
> >>> incorrect counters, mark them with an asterisk in the /proc/allocinfo
> >>> output.
> >>> Bump up /proc/allocinfo version to reflect change in the file format.
> >>>
> >>> Example output with invalid counters:
> >>> allocinfo - version: 2.0
> >>>           0        0 arch/x86/kernel/kdebugfs.c:105 func:create_setup=
_data_nodes
> >>>           0        0 arch/x86/kernel/alternative.c:2090 func:alternat=
ives_smp_module_add
> >>>          0*       0* arch/x86/kernel/alternative.c:127 func:__its_all=
oc
> >>>           0        0 arch/x86/kernel/fpu/regset.c:160 func:xstateregs=
_set
> >>>           0        0 arch/x86/kernel/fpu/xstate.c:1590 func:fpstate_r=
ealloc
> >>>           0        0 arch/x86/kernel/cpu/aperfmperf.c:379 func:arch_e=
nable_hybrid_capacity_scale
> >>>           0        0 arch/x86/kernel/cpu/amd_cache_disable.c:258 func=
:init_amd_l3_attrs
> >>>      49152*      48* arch/x86/kernel/cpu/mce/core.c:2709 func:mce_dev=
ice_create
> >>>       32768        1 arch/x86/kernel/cpu/mce/genpool.c:132 func:mce_g=
en_pool_create
> >>>           0        0 arch/x86/kernel/cpu/mce/amd.c:1341 func:mce_thre=
shold_create_device
> >>>
> >>
> >> Hi,
> >> The changes may  break some client tools, mine included....
> >> I don't mind adjusting my tools, but still
> >> Is it acceptable  to change
> >>       49152*      48* arch/x86/kernel/cpu/mce/core.c:2709 func:mce_dev=
ice_create
> >> to
> >>       +49152      +48 arch/x86/kernel/cpu/mce/core.c:2709 func:mce_dev=
ice_create*
> >>
> >> The '+' sign make it still standout when view from a terminal, and cli=
ent tools, not all of them though, might not need any changes.
> >> And when client want to filter out inaccurate data items, it could be =
done by checking the tailing '*" of func name.
> >
> > I agree with David on this point. We already have monitoring tool built=
 on top
> > of this output across meta fleet. Ideally we would like to keep the for=
mat of
> > of size and calls the same, even for future version, because adding a *=
 will
> > change the format from int to str, which leads to change over the regex=
 parser
> > many places.
> >
> > I think simply adding * to the end of function name or filename is suff=
icient
> > as they are already str.
> >
>
> Instead of:
>
> 49152*      48* arch/x86/kernel/cpu/mce/core.c:2709 func:mce_device_creat=
e
>
> Could we do something like:
>
> 49152      48 arch/x86/kernel/cpu/mce/core.c:2709 func:mce_device_create(=
inaccurate)

If there is a postprocessing then this would break sometimes later
when the function name is parsed, right? So IMO that just postpones
the breakage.

>
> This should hopefully not require any changes to the tools that are consu=
ming this file.
> I think it might be better to use "(inaccurate)" (without any space after=
 function name) or
> some other text instead of "+" or "*" to prevent breaking such tools. I d=
ont think we need
> to even increment allocinfo version number as well then?

I'm wondering if we add a new column at the end like this:

49152      48 arch/x86/kernel/cpu/mce/core.c:2709
func:mce_device_create [inaccurate]

would that break the parsing tools?
Well-designed parsers usually throw away additional fields which they
don't know how to parse. WDYT?

>
> >>
> >> (There would be some corner cases, for example, the '+' sign may not n=
eeded when the value reach a negative value if some underflow bug happened)
> >>
> >>
> >> Thanks
> >> David.
> >>
> >>
> >>> Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
> >>> Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> >>> ---
> >>
> >
> > Thanks
> > Pan
>

