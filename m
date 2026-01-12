Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BABA8C9EC6B
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 11:11:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 077DB6B0088; Mon, 12 Jan 2026 06:11:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 025846B008C; Mon, 12 Jan 2026 06:11:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E3FCD6B0092; Mon, 12 Jan 2026 06:11:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D242C6B0088
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 06:11:44 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 74857D0F85
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 11:11:44 +0000 (UTC)
X-FDA: 84323046528.28.E0B43CC
Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com [209.85.208.179])
	by imf10.hostedemail.com (Postfix) with ESMTP id 78CE7C0005
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 11:11:42 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Lljg3vUt;
	spf=pass (imf10.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.208.179 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768216302;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3H/jhqkcP9BgY3zEDKS/DS66uJsmBA42xS2DgBUImOQ=;
	b=gwXXa3TwLzhfDdkZGBfbNzGbvNxjkdLUOGESP2UkOkdKI8qUEPGab3cDvZY1fPY0VBnDWU
	tMN6EGe5qPJGB7VQpwu0PrF4KuVII22J7aq/js8DF7TsdxIALek0WbJCwwBTM6lJvxOahn
	aLcgRc00zSGEpfJ7K2biMWkTwpVFNyU=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Lljg3vUt;
	spf=pass (imf10.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.208.179 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768216302; a=rsa-sha256;
	cv=none;
	b=PadDoaxksY6gxTaThDb7EhfvlGydLqQldqUXY/eHLOzAhLoObceqHvbeaS6Iy06BNZNddT
	6n2TuSZa3HufbI6WPX8hC7PSjt2QloMhuuhoHIzGnJi1mLZGpXw9OnsEROQn8lUONw9Ogi
	nfjsoo5irQJRvV+1n8D+XJqM8AJ3AvY=
Received: by mail-lj1-f179.google.com with SMTP id 38308e7fff4ca-382fb2bb83dso31911441fa.1
        for <linux-mm@kvack.org>; Mon, 12 Jan 2026 03:11:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768216301; x=1768821101; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3H/jhqkcP9BgY3zEDKS/DS66uJsmBA42xS2DgBUImOQ=;
        b=Lljg3vUtiuyHRXUs6tU+2SSt98ldj49X94AbTEIY7CbEJlJ1Tg+3337vK01Tj8v+K3
         N3j3v0X7y8vKK1TwCvzsTVV2OjrmQvjhEODtlXES2u9BHpUt89oeOWTQINaovtf8qXeO
         Z7EbIEMlJjR56jL9XF3TDyfyjOi/YMMS8249N5jyaToBGDJsEA9Ub6jFjE/fQrQ5BRAP
         uYih20K6V6J77rEaEZFvt6+LqmtgdksDhqAnkIZzpEqXD7oI6tFcWF+dUVrHe+/IDyKg
         JdXKalU4AHcekttPCXjg63xmTxCwEnfJqgxDZKs2HhMm8EhrTJWcSMEqynFcZ6z4QbIj
         7ZNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768216301; x=1768821101;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3H/jhqkcP9BgY3zEDKS/DS66uJsmBA42xS2DgBUImOQ=;
        b=QIRnePjwWaGi2fjZQ5BRPlC++jViHgG1toVLf5E4YsdMOh17+7+7QTneahMz7lkHs6
         nJd+dz+7o7xs0FelFwwGm3c/UrhTsUMaHKVpAnuNdWL5p++zKGUqNaMoE9GZYiyFQqSP
         dEBgk8lg66T868K99WTAQhbieyWGA/vTmsFffqEpnYd4Te7I6wTS8TbVIHO1bTchwlEm
         RG4D8pt1rTvj5rBZBvEI0sUVKBXYbT3WxvwBLI75SVOWkL8Bz+GVKaML/OfMtHOzOREn
         tbp0BSzk+2x1Hw7sXZvl3ijyuL/a6NAJ52W9J7955iQu7CEZOFPIj/DJpzyPXeszkifa
         9bZQ==
X-Forwarded-Encrypted: i=1; AJvYcCUVTOhFtZAwOhD+A92QCF/MorUGLzmrcIphj8YoN/zqxIJS/3JzyluU2b6tONe6solrPCL2nd/i+w==@kvack.org
X-Gm-Message-State: AOJu0Yz0EMaBUDY1pV6Wm0hiu4nLseMkgOtHrLptIW2HX2xkM0TupL/m
	+6hz5UJPELDRlF21srT2S2l/VD4hhbSVO5vzPsEYVBCqtf7DBaSGEpjetvQwOnn50vdp+rug5M5
	6+c1r9RDnJEY3eqhzdqfIgUewGp1cAaw=
X-Gm-Gg: AY/fxX5ciGRloqaqOtuvL9xxzkEemDGurJ4faLJL9rl8JMDOym0j2sv0IZqmFH9RLER
	7Ivxhog5IrY7pWRyK9+f3vFLivVeFOzpAFinDuOyLZ7XqS5T3x591Qj6H20MzHlKFoFmacdLbG5
	yl3XhYNoD9Sagg0AbXpN2s7NQSFGWAjgyqF98zFzKj5H4OCixdG5HHOhqMhmdzFOvSCbBFe88+D
	SXdzP3fW3r7CkxW7shTRt6fz443Wypo9up3El8oxOjnW34VP3yYsHGDE+4s2yCLYlFYKdxD
X-Google-Smtp-Source: AGHT+IFwvvLXLHzfHGsx0J0ClHBWzcoNT27/MYcwYePkivh1q24g1i6nJw6tT3qBrBOKv54Q6LWAD20S1cgBDLFSieY=
X-Received: by 2002:a2e:be8f:0:b0:37f:c5ca:b734 with SMTP id
 38308e7fff4ca-382ff6682d4mr51504651fa.9.1768216300493; Mon, 12 Jan 2026
 03:11:40 -0800 (PST)
MIME-Version: 1.0
References: <20260111121909.8410-1-yanglincheng@kylinos.cn>
 <20260111121909.8410-5-yanglincheng@kylinos.cn> <78a2ab5b-5ece-4d82-a229-594fb8672108@linux.dev>
In-Reply-To: <78a2ab5b-5ece-4d82-a229-594fb8672108@linux.dev>
From: Vernon Yang <vernon2gm@gmail.com>
Date: Mon, 12 Jan 2026 19:11:29 +0800
X-Gm-Features: AZwV_QjfVX4UCzBKYRqYPacYDiIfngjLGdrYRQRDNHi_gbGfSKB5ZwPdEY-3X28
Message-ID: <CACZaFFOEkZqTFceV7mtC8RD890XgpCb_KZmcr_Mz7i3Jpj9SQA@mail.gmail.com>
Subject: Re: [PATCH mm-new v4 4/6] mm: add folio_is_lazyfree helper
To: Lance Yang <lance.yang@linux.dev>
Cc: lorenzo.stoakes@oracle.com, ziy@nvidia.com, akpm@linux-foundation.org, 
	dev.jain@arm.com, baohua@kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Vernon Yang <yanglincheng@kylinos.cn>, david@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 78CE7C0005
X-Stat-Signature: dipumeqedgf9u8zc989hrpybayxde8jb
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1768216302-724567
X-HE-Meta: U2FsdGVkX1/shNGCuufjJPZvYNA5kDcqI8nmi03R7bMILk+yiaGFowHzzk2DjtHgGG6HYhTZUmrRz2YAAWJmtq6QKAifurzZA2NwS0I5J/jNLjURqFh2yh5u+BWbD5RTfMO0EQ7RmzMi7Wmlvenv2HplhQ6gpZViPkUFlk5AiT2K4L4FAAeBAsoN9r4vAQvjaM3V6NOhIs8OClY484oU3SBR5j/dC79k4YCwgzOREFqt/sjgq/bKSMqghn2aMvlrcfqIiFDk1bzF4d6BiPUJb1XnTnMGz5iovUovH5q3mY564Hq0Y4IFTZwANdfx03kAgha2vvTtYSTqmJgdTqgR+xIQUvA5V3Zrm4NZHQYny3yNgMxpIlBBNVi4vyTw+ofNmSWp3ikykBcx/Z0b8k9+5TJHNq7Vo2QS8hECK7LdT8Z+VvviVsyAk8RqH1t6yOxpn/RIQvCODhDBzwzxz7lp5VDbQGjUFx8I5Dzrz3kVz84n9e3z2cGfaSNGIFNzOEuaELnrHlJrkce8NvZeluiuzSCSNDaIU41t0RybR6mqHvTKzuFM3Lo8LVT1ymY68vUtWYyeB2iue9ma2QQsyvFP2Y1HcIiOfezYxuiicrxNaO/JKYA298rTMAhGrNf8VJOaqAxAo5KsxWC7fSju5r+HizN3GV939wdRSOogiSdTB3nlz/jCM3aZvU1lBCRnFQBcA1K03pqMRbo9Fqn6T7hdYOjNZnmiwjJZpxfcmh94G2+Hw9FDpSCoEN3GmgiiMR2GmmyeQjsyeJmLD1y+Xl/vGBtAoJ15FBj2t0TB82E7z5QBdNXVY5/QRrBnhP0QlPj+7WMwj7ixQvA6sNBgpdFSqV7CLCqdcr336IZwBQZyYcgDb1f2sB69hwu2y+cm5y6bOmEefWOEzsXjXRfhquL0LISGFbtsmBibpkZHBByX3SOCn2rWuRmp4gmKQALA7eEYtkSl57oQdTXv+n9+sID
 xAPuVFAi
 I+91jWC1gGJl2kbhimFc/p/d2kN6we0j/RvsCHl3DWqqgz125foFW0mRyYnseWNZJNRJqdfSWv8p5kS/C9Ls8dQtaR6YedgBNNrttl0SxpTCTYUsqYzVsMFt1xQgiFnam1MMn9tCsaZa7r7IiRHhjRYaoGdlmEQDEWlpIxPU4SmCwJuocevj9GeQrNXfbu7ouDJhYxEQnHwRZfHCurNNDJK9x3000ePz5qGAMFEYN9Nq7IK6OjNP7s3FXtdO4Ih8fTSPH/b19K0Zy2pAXNaEUmeH8Xxgh4BTYbBmPkoB+2G8N1bNWeBexGbtlaSRieo1ZpfTm/vocdzrF6mceG7gIHX+r2eICeDbo66e4Kr/ZbyyAsHqfz+lLGL7ybXz2gUXvfeAP8dVridunwpe+7lARPJbD+wff19NGoWUMmxuWSAIY5wk0QXYLjLNH9Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Jan 11, 2026 at 9:42=E2=80=AFPM Lance Yang <lance.yang@linux.dev> w=
rote:
>
> On 2026/1/11 20:19, Vernon Yang wrote:
> > Add folio_is_lazyfree() function to identify lazy-free folios to improv=
e
> > code readability.
> >
> > Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
> > ---
> >   include/linux/mm_inline.h | 5 +++++
> >   mm/rmap.c                 | 2 +-
> >   mm/vmscan.c               | 5 ++---
> >   3 files changed, 8 insertions(+), 4 deletions(-)
> >
> > diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> > index fa2d6ba811b5..65a4ae52d915 100644
> > --- a/include/linux/mm_inline.h
> > +++ b/include/linux/mm_inline.h
> > @@ -35,6 +35,11 @@ static inline int page_is_file_lru(struct page *page=
)
> >       return folio_is_file_lru(page_folio(page));
> >   }
> >
> > +static inline int folio_is_lazyfree(const struct folio *folio)
> > +{
>
> It's 2026, could we use bool instead of int?

LGTM, I will do it in the next version.

Thank you for the review.

> Yeah, I see folio_is_file_lru() uses int but that's legacy ...
>
> > +     return folio_test_anon(folio) && !folio_test_swapbacked(folio);
> > +}
> > +
> >   static __always_inline void __update_lru_size(struct lruvec *lruvec,
> >                               enum lru_list lru, enum zone_type zid,
> >                               long nr_pages)
> > diff --git a/mm/rmap.c b/mm/rmap.c
> > index 336b27e00238..fd335b171ea7 100644
> > --- a/mm/rmap.c
> > +++ b/mm/rmap.c
> > @@ -2042,7 +2042,7 @@ static bool try_to_unmap_one(struct folio *folio,=
 struct vm_area_struct *vma,
> >               }
> >
> >               if (!pvmw.pte) {
> > -                     if (folio_test_anon(folio) && !folio_test_swapbac=
ked(folio)) {
> > +                     if (folio_is_lazyfree(folio)) {
> >                               if (unmap_huge_pmd_locked(vma, pvmw.addre=
ss, pvmw.pmd, folio))
> >                                       goto walk_done;
> >                               /*
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index 81828fa625ed..ad3516ff1381 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -964,8 +964,7 @@ static void folio_check_dirty_writeback(struct foli=
o *folio,
> >        * They could be mistakenly treated as file lru. So further anon
> >        * test is needed.
> >        */
> > -     if (!folio_is_file_lru(folio) ||
> > -         (folio_test_anon(folio) && !folio_test_swapbacked(folio))) {
> > +     if (!folio_is_file_lru(folio) || folio_is_lazyfree(folio)) {
> >               *dirty =3D false;
> >               *writeback =3D false;
> >               return;
> > @@ -1506,7 +1505,7 @@ static unsigned int shrink_folio_list(struct list=
_head *folio_list,
> >                       }
> >               }
> >
> > -             if (folio_test_anon(folio) && !folio_test_swapbacked(foli=
o)) {
> > +             if (folio_is_lazyfree(folio)) {
> >                       /* follow __remove_mapping for reference */
> >                       if (!folio_ref_freeze(folio, 1))
> >                               goto keep_locked;
>
> Otherwise, LGTM.
>
> Reviewed-by: Lance Yang <lance.yang@linux.dev>

