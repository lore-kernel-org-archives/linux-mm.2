Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F4BA606A33B
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 09:33:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ejGkb/b5
Received: by kanga.kvack.org (Postfix)
	id 300946B05B1; Mon,  9 Nov 2026 04:33:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B0126B05B2; Mon,  9 Nov 2026 04:33:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C6DC6B05B5; Mon,  9 Nov 2026 04:33:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DA51D6B05B1
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 04:33:31 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5F75014060E
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 09:33:31 +0000 (UTC)
X-FDA: 85415067822.23.45050DC
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	by imf04.hostedemail.com (Postfix) with ESMTP id 6818840003
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 09:33:29 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="ejGkb/b5";
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf04.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.47 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794216809;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HqOJkLXd0wmKotueuMhbylT2sufy9bI1CVmczzNeuOY=;
	b=h//6RkHLV5rtxX3Jx3tusFNKpR9Crq/nxLKr4uSvO2LauS43MP1zTBzb/5qOkVS0UcGZOM
	yyDFRnVkrRFgFboUoROaK4mLhUlLma3KiJUnEw8qN/iqXXYnGhqyOF6zZR7v7vwgSBXwns
	6FUqHCLR0cZ+gours+gqy0jVzC+1w0I=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="ejGkb/b5";
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf04.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.47 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794216809;
	b=0chWRfigeIdILN1i//6gzZbcbjsgwlGcJMnV0PEidG39uXAeowCBRYd9W4QBnZipcosoSR
	eEfH0Gp0LS3iNyWVynumt5ZvsmyGfNB2eAAo7ozPNvQ7RVzkjO2amqsIO9GEIJmr3Wdkeo
	nLitl8sjwaGfer84Pqv4Q/yP7OGGsCQ=
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-c4d21051042so91415666b.0
        for <linux-mm@kvack.org>; Mon, 09 Nov 2026 01:33:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794216808; cv=none;
        d=google.com; s=arc-20260327;
        b=FuogcdFBpMV0k1FjnszAe6GPEq0XRE3GJlCYuEhK7X4KXPlI0yMIoBkx5y/s9/QCtl
         LrGFJBlDvr4tAPsoQfz1Flzevnn9v0Obesx7PbWGafOADB35QK7v4XzHl5dtV9ADCoIk
         W8u2Zmgf1KHQSjLrKHdq40f4ZsRb8H0THrckKMxNhWFQYD9l42Qm2hsRUahEUHWKHK/p
         9nierat+OIB4gIxCxqYcqOExUIV7x0DCVhIhWkqyTPSpShuBn/UINulmN4LKjfY8X7cI
         NTOLKIop8eOqZMavZ+MHoVXaxu+7CF030d7/sfrnTlVOK4nKEn5L1x+4WSZlsCtM5RIT
         eIrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=HqOJkLXd0wmKotueuMhbylT2sufy9bI1CVmczzNeuOY=;
        fh=BRswjrorPDJe59NAr7GLmCZa8wmOFuh7SgJhqrtZ+lE=;
        b=MQ1UQgWGuntShkJRBFHdbFRToURr0F9Jdi6Kjv+CUWRFNBEc9a0aMCDXlQjzD9dcWb
         pLH7YY5sIoeWoAzWUS3s3ZzqbtmefP0FyLMrRjz4vbioPJqvbHIPd/pZBfIJzwm3zbC0
         opkMHPAB7jVAgMlTNtoZXLq564fMbIJS+w6PsTqsxYxkpPr0XRvQpVwqD3ZRr1MbKg+U
         BcREtysvdbO/isylA1wEj56ikc7uxbRWPVfG47oKpcUUPJ+ogpY2cFyg3PYIWZ8RqUgS
         Dp7AHgM/+vWevtIJpzr4XTsWsKEnKPvnZ8n6WZQrgXtpnQlpnTstsB/PG+v06UkLC5mG
         /XsQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794216808; x=1794821608; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=HqOJkLXd0wmKotueuMhbylT2sufy9bI1CVmczzNeuOY=;
        b=ejGkb/b50uWfsGH4TcCdeuHTavK79ht7UUvga6tgSiypcHu0gHTCVEpLx3tmjQFQdR
         FwjeS4tULV7y4RnwHc+PyRTDSgmmcMcgR6wkC2Q32cAJfn8SND5SSC/Uhus02E4uuMdh
         5gBR5cigpIiwaZICx9oRNR13hBqWw5lYcoMl36ksy/Q3LN+zAPruYxmse+tF4yeISJ9S
         vvnwy0kXjlYC88MEzfi+Dsnu1NUgK6dryHuo2HgE1tZIvxPjepw6PrMQe66jPL84rzgY
         H4Z2Z37ahWTilsNw0occe/C5SSE+JwKxBbe0Ptt5ei+44apYYegeZSnose/9Qq45B7mc
         nCbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794216808; x=1794821608;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HqOJkLXd0wmKotueuMhbylT2sufy9bI1CVmczzNeuOY=;
        b=Wt385Ei1ny/KFoY8douxogu722v2ExWy/xMgWnhqXNrl/J+ZFFuJYKutcBcV3MDczL
         2R7P1ZUo5A9FeFQdlIEEAnSVc+SRX0wBxVFnpCug+i+fMiUqU8N9juthln7Gi5KLWpOq
         OwvVPI9lBOyPohp4zuXmoJqV6xTfseI85gEqM4NrW99wFDi4Ks9MLXCzL6U4iLE6X0Zw
         nCwVr6p4SPfMEDM2+VrFoOycTpoqAwWZVL0hpxuxyvL9UdaMPHxEk0epIHIuzSXPKvAy
         Pn96RsvN9UZdtVN+0hTu/oe0cfQmN1Bzk6ctx86nFKMQUglQeeD3AB64tcTIwmsz4mnB
         BMNw==
X-Gm-Message-State: APuU4Z9ENadk/z/fikVzWrfMHu47n7KqdTY8P7JRgzGc8d709KnnGuwU
	MqK5t9PpAcoz4q9g4n9qbdQwaJ7MLMLD2BEU/hK+WXGONkL/cqP8/Auehvd7XEzZqm/XRwqQNY3
	/CqKPz3SwEFnWeOKHfpqDmR4JR1hYino=
X-Gm-Gg: AYBFou25Qt6sVeDYPLJHmguNnctdM646/Jz9kn41+WW2zP1PAnhvstHDswmu1RrzaHo
	Uf32hCSpmOS/7iOxglWTJoh07yKA/FY0G3qMH10YraY/f4c/ni/gbVSdVtCVRTgxkoLpCRzAWiD
	faBBzat4BROW2z09lrMNDT3Y2s1Wa2euUJnSNB3ASJG8yVINkH7w3E1KddFY/A0Ch9SfjviLITV
	N6EsPvfqoYUWTdGs12yP/sT/kQm4Be7K0hUnuGODqTjiSMct2u11UWLtlNvXN6/zuMaPBX99C/y
	8L3xs/RjwWN36m0IDrkeRS0z4uv32gNRNIW/s7cGYugPj6dIWIqu+zwja6jtkFcuVQcmbbSVJn8
	J5bKrS/KW+M69EAwriX3F4l+o0IaBqXhCOk/TC76PFOp5hZ4N9zJPGzROPxll7N0uoRke
X-Received: by 2002:a17:907:2d94:b0:c40:3a99:3f96 with SMTP id
 a640c23a62f3a-c4d6d35c245mr238537266b.10.1794216807560; Mon, 09 Nov 2026
 01:33:27 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261016-mglru-fg-v4-0-2106750c0bfa@tencent.com>
 <20261016-mglru-fg-v4-7-2106750c0bfa@tencent.com> <CAGsJ_4wSDOgCC9AmLS-z670W-nkF3DXB_cNvNFnptX5F95fGMA@mail.gmail.com>
In-Reply-To: <CAGsJ_4wSDOgCC9AmLS-z670W-nkF3DXB_cNvNFnptX5F95fGMA@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Mon, 9 Nov 2026 17:32:51 +0800
X-Gm-Features: AclHuK-CEIJ-OmAap_Q_FmrC7aIH9q-wRCoxV2MMC7FO6jMxD0d_umEF-d1s_Ho
Message-ID: <CAMgjq7Dw6QtM_VgTuReNs5duPeAZbRukVFZkGuDgbQOXLm7Mjg@mail.gmail.com>
Subject: Re: [PATCH v4 07/17] mm/mglru, gup: mark folios referenced via a fast helper
To: Barry Song <baohua@kernel.org>
Cc: linux-mm@kvack.org, "Liam R. Howlett" <liam@infradead.org>, SJ Park <sj@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Muchun Song <muchun.song@linux.dev>, Qi Zheng <qi.zheng@linux.dev>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Chris Li <chrisl@kernel.org>, 
	Baoquan He <baoquan.he@linux.dev>, Nico Pache <nico.pache@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>, 
	Gregory Price <gourry@gourry.net>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
	David Rientjes <rientjes@google.com>, Yu Zhao <yuzhao@google.com>, 
	Vernon Yang <vernon2gm@gmail.com>, Zicheng Wang <wangzicheng@honor.com>, 
	Chen Ridong <chenridong@xiaomi.com>, Tal Zussman <tz2294@columbia.edu>, 
	Xiang Liu <liuxiang.277@bytedance.com>, Ehab Ababneh <ehab.ababneh@intel.com>, 
	zhaozhengzhuo <zhaozhengzhuo@uniontech.com>, Lian Wang <lianux.mm@gmail.com>, 
	Kunwu Chan <kunwu.chan@gmail.com>, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org, damon@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 6818840003
X-Stat-Signature: gsai3ojgg38798gcunmbi5ztxi44qbtc
X-Rspam-User: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794216809-36700
X-HE-Meta: U2FsdGVkX19gPXvtloRWWyEGi02SWDQSUQwgQUv5Cv1CR+fBtspgDN3Y1wsvwg3S7+a4EAoSaw6Zmmf6oox56sgdp4pgtKKk6/gLJVJy8KfkHfqfVVTYpGrm6qdrrFVgqOkYB+toECQdlHRh3fLiJMxdfKmMOMr2WDKX+LyVxYrAuoBq9uz5dMSmTDC82BJcT4tCQFfNten6w6WAv6L+OFf3o7z3YTrDoCUp5h20QEW28Hw7cBh72wPABH2yBptkpo15C02rYdPDofOp5uePvPDZFQDuZeRpz/k9OcX9FFjX+7uIOMx2WajT8+Sc07nPU8mYV/QvfU2/O4bjBr/aKUp6yfJuyg1P3HqfNzLp0RwWHzuHRPZSnCG6eDU3drI5/ri/IOmDQx/Yo4wcMjBGVXOfp4HLkDf2TyQ3e8BmfL+1lwz2g0kvQdMgHOHQRTHs+m5/t/01PBW9teMigqXxhlKvKK9F1ilfocXxIoUt0pOH2jJf/hpKF192j50lWePaNv3N6ipCU5WFV+KbTNjESrNckCVi/QcUHmAaL2h7VFjB6Hn7dI+oMifX86aIOeTX7R5jnSdoCbImGQF23ssWLJATQboU2w+QNJPMAUjExkbEQaVDvyvbF7qvivy1dOolEFQ0UinjGH/1r77gDlnb5ET90CIR403Vq02/Y0YR+tc81EbWI7jdII+Igk48TUnS/TZnwWirDMfFVks0j0v5wkNKmFe8rsRWuW1ttNL5VH00QCcbsoKazHEk+usY6ZTBaJ6GkHBM7AXMEN/OxfwF3k0C8l/1u4cnWHEolUIP+cE7K7A5pnn8LoBJkK2Tiqesp+a4KcuuGIrDTdnTeMnoYnYws9jSIApHja9pH6Zx3X/andzIlP9SXWjdH1DcD3EhYj4WtVddAGViaYC+qfDHVTabUpgA1h25RP8UPxYDSq6e7zRS/wNOngtTiaX0w4dcOmQQkuJiUxFS1IW8QIq
 MKYSQu5w
 mwar5Tp+ipNQciZC4L/i1Cm82ncXqhg2wR9OVJXDPkrUf0+HDp8cdfHDE+6aKI+5tXdfhUgAqrS4nfeJv6RnpffeFiTmeIUegxJgN3RTTzJgwvWwS3TshDk786xsmiuaShb+o9E92Q13XjIoot3lwYkh6mkxInc69ERZNfZz1gqDrKb7JVP2OFN1lWtlIw/royyzd3iNK8Oh52k2GPKEjXz8aVTJt9tn3F676QFQfANEAbP7Pb9a65tJUeXZjOSFlq01R6RG7Bfjv4xeZ5lmWR1D8mWkFdyWE7UajgAp+rahdAgrY8KLJE1m+98F1wSo8kCwfk3xqJXzOeQMfjnvAztmIECIxlHwWItu8q4tGsevMmbWNEK2RcvXKLMBwEKH4lFn8rkDf2SZ/bN5GWFEKm8kuCx2WZrJNf9wVmGVjuEbDxmqX672i4RjHmkMFFD4/sOkPcpP2sCfQUf3VcQtai8ru4J/XaSJGt+KD3o5fHixMG3sulSc72R3G6P2ob1rDv5MCi0PYTmOFkDTXfW1FqvJIqu0Yadg68BqInsatz8DJAars6TapGFOoEBWsIzx2IH1pTRB1tqQ2SXY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 9, 2026 at 5:04=E2=80=AFAM Barry Song <baohua@kernel.org> wrote=
:
>
> On Fri, Oct 16, 2026 at 2:15=E2=80=AFAM Kairui Song via B4 Relay
> <devnull+kasong.tencent.com@kernel.org> wrote:
> >
> > From: Kairui Song <kasong@tencent.com>
> >
> > Introduce folio_inc_lru_refs_fast(): raise refs from 0 to
> > LRU_REFS_REFERENCED via cmpxchg, or just set PG_referenced for the
> > classical LRU as before. No counter update, promotion, and guarteens
> > no other complex operations in following commits.
> >
> > Convert the gup fast-path sites. No behavior change for classical LRU.
> >
> > Tested-by: zhaozhengzhuo <zhaozhengzhuo@uniontech.com>
> > Signed-off-by: Kairui Song <kasong@tencent.com>
> > ---
> >  include/linux/mm_inline.h | 25 +++++++++++++++++++++++++
> >  mm/gup.c                  |  6 +++---
> >  2 files changed, 28 insertions(+), 3 deletions(-)
> >
> > diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> > index 65415eeac802..effa13c63632 100644
> > --- a/include/linux/mm_inline.h
> > +++ b/include/linux/mm_inline.h
> > @@ -454,6 +454,31 @@ static inline bool lru_gen_del_folio(struct lruvec=
 *lruvec, struct folio *folio,
> >  }
> >  #endif /* CONFIG_LRU_GEN */
> >
> > +/**
> > + * folio_inc_lru_refs_fast - Bump folio refs count without promotion.
> > + * @folio: the folio
> > + *
> > + * Raise refs from 0 to LRU_REFS_REFERENCED and leave hotter folios
> > + * untouched. For the classical LRU, a plain PG_referenced set.
> > + */
> > +static __always_inline void folio_inc_lru_refs_fast(struct folio *foli=
o)
> > +{
> > +       unsigned long new_flags, old_flags;
> > +
> > +       if (!lru_gen_enabled()) {
> > +               folio_set_referenced(folio);
> > +               return;
> > +       }
> > +
> > +       old_flags =3D READ_ONCE(*folio_flags(folio, 0));
> > +       do {
> > +               if (lru_get_refs_flags(old_flags))
> > +                       break;
> > +               new_flags =3D old_flags;
> > +               lru_set_refs_flags(&new_flags, LRU_REFS_REFERENCED);
> > +       } while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_fl=
ags));
> > +}
>
> What is the actual purpose of this patch? Is it to skip
> cmpxchg() when the folio already has non-zero refs for
> better performance?

Right, as the name suggests, it's a faster helper, sacrificing some
recency accuracy (limited to LRU_REFS_REFERENCED, so it never touch
any counter). But the low bar for this helper is still equal to
mainline so I think it's fine at this point. I can add more commit
message or comment on this.

