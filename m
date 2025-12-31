Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1BA0BEE642F
	for <linux-mm@archiver.kernel.org>; Wed, 31 Dec 2025 11:58:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB5106B0088; Wed, 31 Dec 2025 06:58:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E634D6B0089; Wed, 31 Dec 2025 06:58:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D65736B008A; Wed, 31 Dec 2025 06:58:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C79F96B0088
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 06:58:57 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 329A95C5E4
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 11:58:57 +0000 (UTC)
X-FDA: 84279619914.22.7D59FAC
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	by imf25.hostedemail.com (Postfix) with ESMTP id 14E15A0004
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 11:58:54 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=kqUWpXsK;
	spf=pass (imf25.hostedemail.com: domain of wale.zhang.ftd@gmail.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=wale.zhang.ftd@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767182335;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4k3KU4h3qfrT/tc7arEQ50iod5wOTjS4IaKdmgyXIxo=;
	b=1nvBmQU2/dcCw88y2WTogkWhecHYIuwNY5oiap37NJek2Cm9WbRkZP0GaH6pgOEcnnW31g
	qe+oWuTaoBMSz9BNCPWsMTdZiFFzoTbmDgf+akidqps9f0BxENOvEEXZxT1Xw6tRSBYoNE
	pBQj+Mx9kUv+oPSdzniGwTvQJRmj/N8=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=kqUWpXsK;
	spf=pass (imf25.hostedemail.com: domain of wale.zhang.ftd@gmail.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=wale.zhang.ftd@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767182335; a=rsa-sha256;
	cv=none;
	b=CrLWWcJMRTH1ruxPnTHLEaBsWP0CUj1hQK93/cyRgNzXoU+kyk9BU1ef1rJGaJ1U19T8zz
	daVfljDZpE1HHAG5FuByl+DxDt/upHOSOfW6KlclwIYeaBhemlRaYLfr/BwIIxzIZ8lLdk
	om7HjX6q4W5BniSUswN11xE6CoCxOww=
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-b79f8f7ea43so2401062066b.2
        for <linux-mm@kvack.org>; Wed, 31 Dec 2025 03:58:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767182333; x=1767787133; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4k3KU4h3qfrT/tc7arEQ50iod5wOTjS4IaKdmgyXIxo=;
        b=kqUWpXsKzCpvRWadtLqow24aNxtVv2KkCJgJlj3Q0GQH8VsNiXHXgMM9RWKM93Lr7+
         CsWwot61RmRl89PgPnW6H/B8OFHR2a04GSxZNHPDXIUk+/mt/5OpcisRvgLavjjAH2iW
         BcZUHiuuLzZCCAkR/6h3gqbhLt8ueXyeABegJRc++otbGe7NQhOwgxZ7/uZC+f/230PL
         SjgSH5T5yv1Xnpi3H8s2zF4PMyVHyeKIC2O7nDWSeWWBCyAYLA7vCAINmfqJIBCHff7D
         x2HFRTt/4KD/L83NqazxtKRrQZWZmcFS1PqhgjtwGCIGxxxvfW6RMHdFs7ehC2KS7ey0
         gDiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767182333; x=1767787133;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=4k3KU4h3qfrT/tc7arEQ50iod5wOTjS4IaKdmgyXIxo=;
        b=p4+xemZ0IEx6neO+Rh4IWDKuLhDR0WzvWlfBRBnfEJz2cDYPZtOTpB60tPTNG4aX0/
         iFZ945KPujcnbk6EDP2X1OnB0JFWuWAvrPXhhE7UZPYHlf9m2Tk1UnI6dHQkIXr4l3kQ
         ghC6Y/lMva48+tN8qYcdpBAXJWJJUoyxr+wtNnByDdIggSztjAEbev22/UfLRH6MgfpE
         3lAsmci1sKC/Nurlxk2LCMTzgadXV5fck7wFJ9U+eUyS/0eOlmDJ4LL+/89NY5TL6MFq
         khbiC8vX+EevS2ipbaUR43L36tRBouqLuatuL51Ipj7m59ZhswAkQS5mAunOY4BuBiWX
         U29g==
X-Forwarded-Encrypted: i=1; AJvYcCU43/1K0YmhFDRGwjZsrbQZgHqili4etWsOhmopA7q1u+VJbtskdkL9AiM+/5/jc2helt9sQ032MA==@kvack.org
X-Gm-Message-State: AOJu0YxnjX70nEjgnyKgDgeAdWuvZItojpVk/IcTg/QSvxSkUOMMR+3E
	3pSRo5SqmNoqO0LCA7GQN6SSOgIioIbITaH5fk+l1GQO5wbNPiK+guDpqw4Dl2wNL7xoOWdj/ln
	yBblft+cSVtshDfjlJaQNWK5pJXACsG4=
X-Gm-Gg: AY/fxX634ylsgJRfD6gha7xTwuomCUjnjusRiuRMXB+JxpqyQg96uLKt3vK+ZVjgjzb
	RMiKWX2kIM7uCRGA78jVsCtUBV1oLZHSXIHuHDf9A0AgyLHIj/ExExAWEenpQydUSJc6eLtjYm1
	u2LKvJdT0o7+cPGBxkMg+bj+g/PhTrnbJ2Fg49nkeroJoqYVowA0G4I/fibbTDZxqu64918i1ER
	aqkpN7typh4T0NQGpo9L7v5ILrWoOR3TBiuNQNmu3sKa6A4VPrGPTajzmYwO+rlpQUIRihlt+f1
	tgVLABg=
X-Google-Smtp-Source: AGHT+IHs2RJ70zU+U6poJpmrLBikwmu4kevTrstSv14lON2pVsR34blEV0dtVWcXoEv9SwWnFlise9uNvH/090DXIH8=
X-Received: by 2002:a17:907:6d12:b0:b76:bcf5:a388 with SMTP id
 a640c23a62f3a-b8037198f0cmr3834479766b.50.1767182333111; Wed, 31 Dec 2025
 03:58:53 -0800 (PST)
MIME-Version: 1.0
References: <20251230130110.1366374-1-wale.zhang.ftd@gmail.com>
 <cb69a1e7-e836-4115-8733-12d2de879f51@kernel.org> <CAGsJ_4w=KuVs5+p+3gZ=L7=rzA3qgnMVQOBJNBEPnMDWx2N+dg@mail.gmail.com>
 <20251230133522.e15135c3a17826428f472a2e@linux-foundation.org> <4029d13c-3bfc-4ace-8da0-3895dfc001b1@kernel.org>
In-Reply-To: <4029d13c-3bfc-4ace-8da0-3895dfc001b1@kernel.org>
From: wale zhang <wale.zhang.ftd@gmail.com>
Date: Wed, 31 Dec 2025 19:58:42 +0800
X-Gm-Features: AQt7F2rajMZpwYO3mGZI3qQme9AkDvPnyiBNkiZ4XBhzeI9RBf_SItQIKisH8-k
Message-ID: <CAHrEdetx_AUGa8Qk3JF-tgCZVJsfnfcLLSkkOVc_5ra6K6Q6Kg@mail.gmail.com>
Subject: Re: [PATCH v2] mm/swapops,rmap: remove should-never-be-compiled codes.
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Barry Song <21cnbao@gmail.com>, chrisl@kernel.org, 
	ziy@nvidia.com, lorenzo.stoakes@oracle.com, matthew.brost@intel.com, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: nzuoxfaynmbmwt7djqjd3f5idrrjqzub
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 14E15A0004
X-HE-Tag: 1767182334-512943
X-HE-Meta: U2FsdGVkX19VqDKzot1HC57SWS9C5+Pg1Nx74jGmtvg+b3dXB0W7uUvdacUaw+51DBfpRyT/9+aqDT7SYDSygH9cX8cyMXp//NJAtJUhPhoIeyCi6crYyM+QHWDtFLecvUPAekFLcprrNWXxKWGXKC71bJZ/BbGqUIMD0O2fsskTJ/Feao7AMCSmeat/pUjn0laOYQuy3Xsig3Gy+InR09bjI0e6vtPJd+Uci+kwAzDaj50nyAC3YMrvhw0od3Z48AfU/N5dee02ZdxDqL3TD0+W6Eo+3tVcIVs1qqH5a+0x+X7WLJPpBV2aydYhZKXCCQJBPUJcJBnWweLO5O8gS3sLZ6dwcE+zfwWRFAM2XQjHo/NafwWQ9LZFBEBFPnpM4QcsIRKiVxCmnZNo7t+SWLy/0ytPbBw8oUTuMg1zs6Qu2v+lFrqNGOqvpy1Ob9kjI7TARGwnpN8nfxt79hcFPl0wcGs/sGyPes5GjgitdJ7JlDk+BJp1hrUjk1ZbxOznzZzxDMEMA77Jhh4RfJzwek84U15efB3L6seHMG2E+Q+MCv7m6P4TgETKvvpfjlu7Q+tvk2RsIOjuGjfZ8/GldgGU+jzMXVRo39U+KOPCj0KPK02dIN5+bjVIyHq/6MEWaHEwtl940zZgMalH3xVlUEK3mS9x5Yhtps+RRw5Wcqvi5b8qj70U9uHGAnLe23jtfNI44Wl598D+CWYIRBWJt+BeXmY+K9wgNFX9riz3Ujc8u8+LoWdrOs2d6JiFtEzBbeCp77pj70P860OjRdVa+tDQarAi7zO1gLuy5iYcAvKJqMQMPv/BksnPNCdkMVF1a9lziRe0WLmg4rqIQUHuF5MH2ru5KOGV8SVj7DmjmNYTlWGrfFqeYod9t5u13ucunMt6+bON8JSwAyit5CJFgaVpot0qE7JKZ0Y1WpyeYHctYqUNRIN07JysTYdR6oNRrkAIiReltaL4OrJiw6O
 g/YZ7+vl
 s1aZdcIgmkoBkaPaRiHtQPNc77n+I0Pa5Rj/t+MsKr6eToMyG1OW+yVJuwHg5Y2Y9jcuEfC9fIj8nmb2p+lv/mG+8O5CUM+6vj79p4/GExxEEAJ2R6GqjhZAADgMUNzpaa7fzJZ/CuzqTEYrXJLw7llJGXCM1dSxky3nV/W6pPqiO7ElnUXAmFSo9NdR0PiSi20wsS+pRHfa64yW2e2GPb1nOy8ThTTWIgp2fYxAacbvv08kKLLzk6S0o4z27a1yhLhFzoaQeb4HiDVDbYyEsm1buRbJYEsUvWxVXMTm8vNhxeznR45eEaosGrumAmzEEcc5FdNP6Kl/yLQhSsXljl4USCpY+vKGO/7jPAZ0PdGhP2+x6ht5GREytYVrzp4IfZa6uFIudXvdK2yB9fzcYpRE8IbjwYBGmiEmmUQbFnBTYSH+6vlRgYPAbdg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 31, 2025 at 5:59=E2=80=AFAM David Hildenbrand (Red Hat)
<david@kernel.org> wrote:
>
> On 12/30/25 22:35, Andrew Morton wrote:
> > On Wed, 31 Dec 2025 10:28:25 +1300 Barry Song <21cnbao@gmail.com> wrote=
:
> >
> >> On Wed, Dec 31, 2025 at 8:50=E2=80=AFAM David Hildenbrand (Red Hat)
> >> <david@kernel.org> wrote:
> >>>
> >>>
> >>>> -                     break;
> >>>> +#ifdef CONFIG_NO_PAGE_MAPCOUNT
> >>>> +             last =3D atomic_add_negative(-1, &folio->_entire_mapco=
unt);
> >>>> +             if (level =3D=3D PGTABLE_LEVEL_PMD && last)
> >>>> +                     nr_pmdmapped =3D folio_large_nr_pages(folio);
> >>>> +             nr =3D folio_dec_return_large_mapcount(folio, vma);
> >>>> +             if (!nr) {
> >>>> +                     /* Now completely unmapped. */
> >>>> +                     nr =3D folio_large_nr_pages(folio);
> >>>> +             } else {
> >>>> +                     partially_mapped =3D last &&
> >>>> +                             nr < folio_large_nr_pages(folio);
> >>>> +                     nr =3D 0;
> >>>
> >>> The whole code was written to avoid ifdefs.
> >>
> >> The #ifdefs are only for -O0 builds, which are never a
> >> mainline requirement. However, dropping functions that
> >> contain nothing but a BUILD_BUG() seems reasonable?
> >
> > Let's not make -O0 an objective, please.  We often make assumptions
> > about dead code elimination in order to keep kernel code more pleasing
> > to read and to maintain.
> >
> >> If those functions were actually required, the compiler
> >> would fail anyway. In that case, there doesn=E2=80=99t seem to be
> >> much value in keeping wrapper functions whose sole purpose
> >> is to contain a single BUILD_BUG().
> >
> > I agree with that part of the patch - if the thing only does a
> > BUILD_BUG() then let's simply remove it.  If somehow the compiler tries
> > to reference the now-not-present function then we'll get an error messa=
ge
> > anyway.
> >
>
> The change
>
>         +#ifdef CONFIG_NO_PAGE_MAPCOUNT
>         +#define folio_inc_return_large_mapcount(folio, vma) \
>         +       folio_add_return_large_mapcount(folio, 1, vma)
>          #define folio_dec_return_large_mapcount(folio, vma) \
>                 folio_sub_return_large_mapcount(folio, 1, vma)
>         +#endif
>
> In the patch is wrong. It must be CONFIG_MM_ID.

Hello David,

folio_inc_return_large_mapcount and folio_dec_return_large_mapcount
are only used when CONFIG_NO_PAGE_MAPCOUNT is defined.

>
>
> So if the following makes compilers happy, fine with me:

Apart from the solution as below, I can't think of any other ways. Do
you have any good ideas?
+#ifdef CONFIG_NO_PAGE_MAPCOUNT
-               if (IS_ENABLED(CONFIG_NO_PAGE_MAPCOUNT)) {

> diff --git a/include/linux/rmap.h b/include/linux/rmap.h
> index daa92a58585d9..9d782826e8579 100644
> --- a/include/linux/rmap.h
> +++ b/include/linux/rmap.h
> @@ -336,6 +336,11 @@ static __always_inline int folio_sub_return_large_ma=
pcount(struct folio *folio,
>          return new_mapcount_val + 1;
>   }
>   #define folio_sub_large_mapcount folio_sub_return_large_mapcount
> +
> +#define folio_inc_return_large_mapcount(folio, vma) \
> +       folio_add_return_large_mapcount(folio, 1, vma)
> +#define folio_dec_return_large_mapcount(folio, vma) \
> +       folio_sub_return_large_mapcount(folio, 1, vma)
>   #else /* !CONFIG_MM_ID */
>   /*
>    * See __folio_rmap_sanity_checks(), we might map large folios even wit=
hout
> @@ -354,33 +359,17 @@ static inline void folio_add_large_mapcount(struct =
folio *folio,
>          atomic_add(diff, &folio->_large_mapcount);
>   }
>
> -static inline int folio_add_return_large_mapcount(struct folio *folio,
> -               int diff, struct vm_area_struct *vma)
> -{
> -       BUILD_BUG();
> -}
> -
>   static inline void folio_sub_large_mapcount(struct folio *folio,
>                  int diff, struct vm_area_struct *vma)
>   {
>          atomic_sub(diff, &folio->_large_mapcount);
>   }
> -
> -static inline int folio_sub_return_large_mapcount(struct folio *folio,
> -               int diff, struct vm_area_struct *vma)
> -{
> -       BUILD_BUG();
> -}
>   #endif /* CONFIG_MM_ID */
>
>   #define folio_inc_large_mapcount(folio, vma) \
>          folio_add_large_mapcount(folio, 1, vma)
> -#define folio_inc_return_large_mapcount(folio, vma) \
> -       folio_add_return_large_mapcount(folio, 1, vma)
>   #define folio_dec_large_mapcount(folio, vma) \
>          folio_sub_large_mapcount(folio, 1, vma)
> -#define folio_dec_return_large_mapcount(folio, vma) \
> -       folio_sub_return_large_mapcount(folio, 1, vma)
>
>   /* RMAP flags, currently only relevant for some anon rmap operations. *=
/
>   typedef int __bitwise rmap_t;
>
>
>
> Use a config with !CONFIG_TRANSPARENT_HUGEPAGE:
>
>   $ LANG=3DC make mm/rmap.o
>    CALL    scripts/checksyscalls.sh
>    DESCEND objtool
>    INSTALL libsubcmd_headers
>    DESCEND bpf/resolve_btfids
>    INSTALL libsubcmd_headers
>    CC      mm/rmap.o
> mm/rmap.c: In function '__folio_add_rmap':
> mm/rmap.c:1249:30: error: implicit declaration of function 'folio_add_ret=
urn_large_mapcount'; did you mean 'folio_add_large_mapcount'? [-Wimplicit-f=
unction-declaration]
>   1249 |                         nr =3D folio_add_return_large_mapcount(f=
olio, orig_nr_pages, vma);
>        |                              ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>        |                              folio_add_large_mapcount
> mm/rmap.c:1274:30: error: implicit declaration of function 'folio_inc_ret=
urn_large_mapcount'; did you mean 'folio_inc_large_mapcount'? [-Wimplicit-f=
unction-declaration]
>   1274 |                         nr =3D folio_inc_return_large_mapcount(f=
olio, vma);
>        |                              ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>        |                              folio_inc_large_mapcount
> mm/rmap.c: In function '__folio_remove_rmap':
> mm/rmap.c:1673:30: error: implicit declaration of function 'folio_sub_ret=
urn_large_mapcount'; did you mean 'folio_sub_large_mapcount'? [-Wimplicit-f=
unction-declaration]
>   1673 |                         nr =3D folio_sub_return_large_mapcount(f=
olio, nr_pages, vma);
>        |                              ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>        |                              folio_sub_large_mapcount
> mm/rmap.c:1702:30: error: implicit declaration of function 'folio_dec_ret=
urn_large_mapcount'; did you mean 'folio_dec_large_mapcount'? [-Wimplicit-f=
unction-declaration]
>   1702 |                         nr =3D folio_dec_return_large_mapcount(f=
olio, vma);
>        |                              ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>        |                              folio_dec_large_mapcount
> make[3]: *** [scripts/Makefile.build:287: mm/rmap.o] Error 1
> make[2]: *** [scripts/Makefile.build:556: mm] Error 2
> make[1]: *** [/home/dhildenb/git/linux/Makefile:2054: .] Error 2
> make: *** [Makefile:248: __sub-make] Error 2
>
>
>
> --
> Cheers
>
> David

Thanks
Wale

