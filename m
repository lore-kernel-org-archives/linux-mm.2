Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BFB5ACCF9E9
	for <linux-mm@archiver.kernel.org>; Sun, 26 Oct 2025 17:42:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 848E28E0175; Sun, 26 Oct 2025 13:42:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7FA0D8E0150; Sun, 26 Oct 2025 13:42:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E87B8E0175; Sun, 26 Oct 2025 13:42:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5A5C18E0150
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 13:42:11 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DB89B13A70E
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 17:42:10 +0000 (UTC)
X-FDA: 84040984020.15.FC9C892
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	by imf28.hostedemail.com (Postfix) with ESMTP id DB8CEC0006
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 17:42:08 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=PemXXgGk;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf28.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761500529;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7hY9TwQ1CLJJR8gD9MPjIVFMc/sVRR1dOB+4vQ75ofU=;
	b=58jSHURnDfV8tsHa8POvChkeVmgVJc8VBS2kSgmEjJg2cUoO7/veYmK9xPBpGemqdYVNcJ
	FUHR2y73/6UIGf3dqGOHJ/2ejXjFplBboCQytGO7+JsqeybUPrhrbv3N12anwL6mBHqsgD
	JrFxZZ1dprba54SiXHLJpAIb+rDHyZk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761500529; a=rsa-sha256;
	cv=none;
	b=LbFKiT5o1Wtw+uDffKoC50GD9qsVAMdeV3BbBzx9V9HojjBIrHXGXXxiMcn0z/R0VDEj2U
	+/MVk89a34iB79DGZTLlgq3H8lJyKpusqgtLiAXILLgqdcb6J1gUI56eKWk6CcYhKbxS6m
	a04ryCwfVbCFYSujQmv3pS+zpH8S2jg=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=PemXXgGk;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf28.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-b6d5e04e0d3so598582866b.2
        for <linux-mm@kvack.org>; Sun, 26 Oct 2025 10:42:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1761500527; x=1762105327; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7hY9TwQ1CLJJR8gD9MPjIVFMc/sVRR1dOB+4vQ75ofU=;
        b=PemXXgGkyfXneij1JCszANssc1/tMkD/qpaFoXJfHl3auyhv3eOZCCIBHfYGzbl2Zt
         MEaV3GWWKnOQ0fnPQg6g5qOD9z90+ftd45zaDouPyVBh5ZDsCmwlpEIV7XV7GF+lIa+e
         a2mYUQ0KSMaPh10eYePrbrT7xf31hDKqyY+nOWH1aKhOq3QngDu7pzAwPI6jabRnn26n
         6Q3tptg5dopFQMhhUpjxQAeGEiIFAIxjMw5NGuX36drDoJK+bpp3/f+TW+Rm+kSzC9kE
         ohm0ycksT+CZwNvJ87Nj/p7WyxhLwP0Px26zpXfyvATmACWpme8iqTwneF+uqYX9AiNz
         mPcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761500527; x=1762105327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7hY9TwQ1CLJJR8gD9MPjIVFMc/sVRR1dOB+4vQ75ofU=;
        b=aUXWiCJuT7BTLIKG3nUrmAJ6z4FJYIur5fpYZvKvMoQXPYHfYF14mx7MpMgPDX7ABx
         TQigoG82K6kysbh8mVd9tRhR51H9WbJgENJNra94cd25+hUjruwG6RSRER9ISrtsexxV
         aPermKRnZAu7fmCjeNUNA/nMi7jweLQ+UEhTkj8wHCI76qMEX68bVkCVQmwKU/3Uxnag
         bbW/W/ln+5b8pWd1GJ/2Bmu/ashJB5+78GEwt6XZ48d60+9WUINslLW74unomnabVQvw
         C5zU+tiIDxTUZdNA5LFU2IsVdzhnWb9huCDRabZlNsBrNsY7/KbmWyvLYtl26b4BolM/
         s/OQ==
X-Forwarded-Encrypted: i=1; AJvYcCXEHKOH5FdIqoQ/yxhw59iNY1E1HJfCFudpHpRR4UAHRM6jVdYzA7NXvv0WXCdrJoKiAoUQuFtg9w==@kvack.org
X-Gm-Message-State: AOJu0YwckknC4sMuZWgQz1B5Zge8MKjT6OIveiwv9TCL64LBybPGQ0RK
	vaovyefy53SZFoWNyMzTkeeTkk2Cye/bHqUtNCItFKB0dtetta1ZXM+JNNI4gi3p/quXPZ/thpS
	pOHX3AHjhuAkAjGaQtW3oU2uPNd1Fx7m53qqRvcDHwQ==
X-Gm-Gg: ASbGncsdj7t5SkSo9yD/LQgDtDdUDDRc2F8BsL+bP0Xv5TXVgjbyxye6xONa9AWQ5cC
	jDMz+dRGYQ+3ESJQjMGtWExbt0FdEuzhQP4lWaMgA0ZiDSrdtdB3lWQHurTPqFlkLnCpiRzHDLm
	95JscRhbCCbECZ4bSxT3/Jm9LuUyuI/HD01gn9uRxCu7zxdXoC5cc8cjIzWPJyQpfAee7MCvqiM
	wSba0E5aSX2iPtCl3NCG/J0fI0KfoK2cf33QiwgPTR9uOJRXQhT9avf5eGUlLM3fg2K
X-Google-Smtp-Source: AGHT+IFJAqpY/Sj1GY1CdZ1JSZWZDxA7iqjdHseliH9UljNa62GLbYll8OXsWemDYxTy88s7miJZSL9cWjxUzUEcS/I=
X-Received: by 2002:a17:907:6d20:b0:b6d:6a35:99a0 with SMTP id
 a640c23a62f3a-b6d6a359c49mr1075496866b.33.1761500526636; Sun, 26 Oct 2025
 10:42:06 -0700 (PDT)
MIME-Version: 1.0
References: <20251024161002.747372-1-pasha.tatashin@soleen.com>
 <20251024161002.747372-9-pasha.tatashin@soleen.com> <aP5Mcr9WCt5CHon6@kernel.org>
In-Reply-To: <aP5Mcr9WCt5CHon6@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Sun, 26 Oct 2025 13:41:30 -0400
X-Gm-Features: AWmQ_blYAsXcjKX5BaK9UiO_G89LuikSynb9OAbAPmAuzXQ2h68_P6Ww_dBxOQA
Message-ID: <CA+CK2bCUc5Q5PxCy3jGN9CC48Zz_evq51d7Hps7=r9g28z7tig@mail.gmail.com>
Subject: Re: [PATCH v8 8/8] memblock: Unpreserve memory in case of error
To: Mike Rapoport <rppt@kernel.org>
Cc: akpm@linux-foundation.org, brauner@kernel.org, corbet@lwn.net, 
	graf@amazon.com, jgg@ziepe.ca, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, masahiroy@kernel.org, 
	ojeda@kernel.org, pratyush@kernel.org, rdunlap@infradead.org, tj@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam01
X-Stat-Signature: kt5ufo91497c3ut8q4f7hpgjpxpcnsmt
X-Rspam-User: 
X-Rspamd-Queue-Id: DB8CEC0006
X-HE-Tag: 1761500528-334563
X-HE-Meta: U2FsdGVkX19EtILcfomZxgnQKpAJyBhLnOUus+XOIFuWNf5pPaZu4CiT4rtrLOPBM6oBf5OAlWOSLRztu5pD0TRXlESsXJZ7eGpI8oK5XXTeGx1nLZWwFyTs7SEeb/cAOLhMdcoshdyhpTzJKwV+u3Qikhwcfkc40URX6XdoRc6cRAxeoeZJWF6IHE9OCAkvzjPbrBDumM6olM6PCfvcJ7NoTqp6e+nmVF5m+KyYUeyKde1aMwbMB+/4Yf6gl8aUYYPSHVRGO2ImLmze0nn9OYM17FjIGv2Csph9l1EABwBQLJz2jSlVtmPsWbUfy0vAZIvnrBe5YAJNgU4NM44xmMfnd3bUBQWc+twBZPv+EIJ421uD+9neV7Q3ZcXSfXenhgMjOqzQZZejNqn7wVuLlU0keOaDVzC+GwaGpCzQBnkxRv6fPmpmY1lX+fu7SfYx0HdUKHcY8kJ2qEpOx+H3iTMFYlv89ao7JUKeifwhWqDUvlZNT/q5dKa0Vr0vNavBZsNFBDIU13bBzjPXVkdcAMZyi+gxswX2Nuqnolj8COI6OnNiqcfYvKA0b+X80GvqXZqrY9nkJnDeRehF7EV7yhkCM+YwlUb6igVs3M7/SXtPQX2OFS2x7zDpC04SX6p0iR9qv2pQCNr/2/NWpCFNXlZlhTfcugEa2wyLWTgROHR3yhvh2pRu3EVMoBw+H2nq7DYQAwMdykKqnNA2C+307zNw+jCVJpeTnK+zwbbWtOVslfv3+D81p+2bcLQ94uiROh871TpAK5ExrE1R+d9iwnHMz6bKRies6Uhaqciw4IZueqEWoPD8NYNWC33vXNax7vZ21u3sxtzdvzsnfDJdmUmnEHO6fGLbeNn2W1cLaAXg4SUdZC3I9cLCBSaB/aZ74Y/TkAYx6nSbOwrgzI3K6m9b80njv8nvYVnY3m/0pqr4n+AO/HEfreHb6KWdxotU8wXx9TFu8kil8tExEXR
 JTyvQisj
 6rq9My0QIyHlTc8lbrNH/FPxQwtHj/RakUpN19KgDhRNHZIBGToseDOjrXqAmutXUH10FXnZKuAim+tmCK0PkeD+BwjFixnn3WmUIxB7WSoR4hjwRDmtWyLJkTnY5rngLiqLfinGUEyVKknRvQ8UtVzbvEUKaSUVw4CiSP2ZuqVksifKIAlb3qDvT7All0nuxTzZxsGVAur0fWiNkPBaFrhKx9smkrqzjrJDxftxpUZveVSE2IxBVo4rmv5Pg0F9kwKAMkzSl2emn1u30JNDT1NpUeg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Oct 26, 2025 at 12:29=E2=80=AFPM Mike Rapoport <rppt@kernel.org> wr=
ote:
>
> On Fri, Oct 24, 2025 at 12:10:02PM -0400, Pasha Tatashin wrote:
> > If there is an error half way through KHO memory preservation, we shoul=
d
> > rollback and unpreserve everything that is partially preserved.
> >
> > Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> > Suggested-by: Pratyush Yadav <pratyush@kernel.org>
> > ---
> >  mm/memblock.c | 26 ++++++++++++++++++++++----
> >  1 file changed, 22 insertions(+), 4 deletions(-)
> >
> > diff --git a/mm/memblock.c b/mm/memblock.c
> > index e3bef9b35d63..5ceaa02af7d6 100644
> > --- a/mm/memblock.c
> > +++ b/mm/memblock.c
> > @@ -2447,6 +2447,7 @@ int reserve_mem_release_by_name(const char *name)
> >
> >  static int __init prepare_kho_fdt(void)
> >  {
> > +     bool fdt_folio_preserved =3D false;
>
> fdt_preserved is enough IMHO.
>
> >       int err =3D 0, i;
> >       struct page *fdt_page;
> >       void *fdt;
> > @@ -2462,12 +2463,14 @@ static int __init prepare_kho_fdt(void)
> >
> >       err |=3D fdt_begin_node(fdt, "");
> >       err |=3D fdt_property_string(fdt, "compatible", MEMBLOCK_KHO_NODE=
_COMPATIBLE);
> > -     for (i =3D 0; i < reserved_mem_count; i++) {
> > +     for (i =3D 0; !err && i < reserved_mem_count; i++) {
> >               struct reserve_mem_table *map =3D &reserved_mem_table[i];
> >               struct page *page =3D phys_to_page(map->start);
> >               unsigned int nr_pages =3D map->size >> PAGE_SHIFT;
> >
> > -             err |=3D kho_preserve_pages(page, nr_pages);
> > +             err =3D kho_preserve_pages(page, nr_pages);
> > +             if (err)
> > +                     break;
>
> Please
>
>         goto err_unpreserve;

While we can do that, we loose some symmetry of not performing
fdt_end_node() and fdt_finish() if fdt lib ever adds some debugging
facility to make sure that open nodes/trees are properly clodes, this
is going to flag that. I prefer my current implementation.

>
> >               err |=3D fdt_begin_node(fdt, map->name);
> >               err |=3D fdt_property_string(fdt, "compatible", RESERVE_M=
EM_KHO_NODE_COMPATIBLE);
> >               err |=3D fdt_property(fdt, "start", &map->start, sizeof(m=
ap->start));
>
>         if (err)
>                 goto err_unpreserve;
>
> and drop !err from the loop condition.

That is going to miss one 'nr_preserved++' . We cannot do that, we
could move it to the beginning of the loop, but I prefer keeping err
right in the condition.

>
> > @@ -2477,12 +2480,27 @@ static int __init prepare_kho_fdt(void)
> >       err |=3D fdt_end_node(fdt);
> >       err |=3D fdt_finish(fdt);
> >
> > -     err |=3D kho_preserve_folio(page_folio(fdt_page));
> > -
> >       if (!err)
> > +             err =3D kho_preserve_folio(page_folio(fdt_page));
> > +
> > +     if (!err) {
> > +             fdt_folio_preserved =3D true;
> >               err =3D kho_add_subtree(MEMBLOCK_KHO_FDT, fdt);
> > +     }
> >
> >       if (err) {
> > +             int nr_reserve_map_preserved =3D i;
>
> nr_preserved is clear enough.

Sure.

> Also let's declare it before the preservation loop and count it there. Th=
an
> we can make loop variable local which makes it safer against certain side
> channel attacks. I.e the loop that preserves the memory would be

Sure.

>
>         for (unsigned int i =3D 0; i < reserve_mem_count; i++ nr_preserve=
d++)
>
> > +
> > +             for (i =3D 0; i < nr_reserve_map_preserved; i++) {
> > +                     struct reserve_mem_table *map =3D &reserved_mem_t=
able[i];
> > +                     struct page *page =3D phys_to_page(map->start);
> > +                     unsigned int nr_pages =3D map->size >> PAGE_SHIFT=
;
> > +
> > +                     kho_unpreserve_pages(page, nr_pages);
> > +             }
> > +             if (fdt_folio_preserved)
> > +                     kho_unpreserve_folio(page_folio(fdt_page));
> > +
> >               pr_err("failed to prepare memblock FDT for KHO: %d\n", er=
r);
> >               put_page(fdt_page);
> >       }
> > --
> > 2.51.1.821.gb6fe4d2222-goog
> >
>
> --
> Sincerely yours,
> Mike.

