Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F21F7606B59A
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 08:47:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=r768wm9Q
Received: by kanga.kvack.org (Postfix)
	id DD4266B05C0; Thu, 12 Nov 2026 03:47:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DAB976B05CA; Thu, 12 Nov 2026 03:47:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC25E6B05D4; Thu, 12 Nov 2026 03:47:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9B0586B05C0
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 03:47:19 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1F3C44046E
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 08:47:19 +0000 (UTC)
X-FDA: 85425837798.13.3B7311E
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	by imf07.hostedemail.com (Postfix) with ESMTP id 2D11640003
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 08:47:17 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=r768wm9Q;
	spf=pass (imf07.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.42 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794473237;
	b=uowygNvJ/nBtbvCbCHCnIXIkrvbgZaCrmxUQWx5EIzYgsdzb5tgZpc3dtZjLcsiEqJVQNS
	q840Zn9PPvi+5p87+T3MoJWTrP7Patlh1nH+Fuoj4PXC3UKFRCBpvPVu5Saf246rtsavOY
	kpP5Zn3ejO48PK+uSuwin4tNsHE7bRg=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=r768wm9Q;
	spf=pass (imf07.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.42 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794473237;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kVtvjLNQqVhAbmabkyBPJW5OAK7r3mnKjNng1ZW6k8Q=;
	b=YeICEiWM0xQMtXJRyPWCcCkvFlAj6YE1qMbeANESBqMeYVWIpoUQNxrBEBnI/zGlZ0uiNf
	rVOaqyS14u77QtgCxKXcEceQ2wCKUQefRSOOEcep4tE9CMj6XHCYOPwZt6BwhVXHzuAO4f
	lHgEiZOFTCzw7Op3bqatQEhBvTfYBEo=
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-c4cb6834eaaso646291766b.2
        for <linux-mm@kvack.org>; Thu, 12 Nov 2026 00:47:16 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794473236; cv=none;
        d=google.com; s=arc-20260327;
        b=FDji7zhndTZzmSqMMdcZG1klih2g+QZK5m+FqATFrtmm2jaKhMPsMH2ImUIUjQA9b3
         zWMQmYP9ws5swNBXEjFpZu7+LhFno2DfWrfOZ+oulFQLkFrq6FRfJVGBzjmahyaam3hw
         b7T3YGJrFxyxdjgWTsVICZb9fKUr6gmSzbNnU+bW53rCHhMoZf57F5FW4x4M3AbSNwuu
         vnq943lm6S+BUkTFYysYyFTTgJU5CqXcNiVh8g8a0IgJCZ6PO13LuQ+jTfpJ4ChsCsR+
         V3NaE/eDhnUhlE2METEdDQtDBmtDX9S2iKv2BNMY3y8Mb0/5CBav8a9Kas8d13eqjD9C
         fsig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=kVtvjLNQqVhAbmabkyBPJW5OAK7r3mnKjNng1ZW6k8Q=;
        fh=pfgUFwcmIc32fnWhW+lRfuOUqqYQM3n+khqMRrzhTSg=;
        b=sX61LfvuHCCcc7WlioydSv81m0aaFWruP2Lsqfr/5FH+R1qzclwoWPM81oheczy7cH
         bc1OHC+lzoKcmNDgnvPXY3GQzkHAvyPbSOTneA1ipkLjXppIwKwDg2242G3hvML24Aju
         C1C9aWZ1hRC7K+5cG27hAX0rGchm0kIojOfYpfY74lGw3UQFUFLe0Csi48h7163fJYu3
         9p9Vrr6gRrHMf9qObzGIVYwRa0r2dCKki8mcIyM8SUXZOhCisecu1pddG61Ini2A1pWR
         Pdxnv4gS0hA+kYiGtVJWpQZEh/bTwe4fy5Qslu2VxalsRwLV9nRiCdyy+Ql2FcLY1jTZ
         Xaaw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794473236; x=1795078036; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=kVtvjLNQqVhAbmabkyBPJW5OAK7r3mnKjNng1ZW6k8Q=;
        b=r768wm9Q6OHCQzSP9aH+QgCO41gHByJFHQWMui6ftgboHVWzIUu78I2dOPH8C8sd5g
         djmwQv10Z/h7j4XNX6ONH45mMxPUwWA4QsyAKT2D6PId9e6t7JZC1vVRxihTGtekaUFQ
         aNO4+fIQKgM+ASZFVRmaAU9hU+iUlPB4bZJ+km0ONgC+X/uYLs8TK8IBvEsgtaW3BMTl
         kOnzN9oIjQeO7MrMX0mEZmzXNswMhvj9VLq83BiYKSqpAonYlqUNAds0QS6BtpQE/GYG
         AnC8q1pOJzkA9THztS7cX5KvitXgzB2oPhKM/Ahdzc2kvkhaxq7Lz0bpKHevW1nmRMnv
         xevQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794473236; x=1795078036;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kVtvjLNQqVhAbmabkyBPJW5OAK7r3mnKjNng1ZW6k8Q=;
        b=KRPTTBXe4gkqCtlet/ORqoEsTkVwW5HP5Kw3KOn67yLIxj69uNN0LasYt1m0d8mvUN
         o1Um6t8s3keMj3TonR4LY3fdMSjZCn6XaO4C5sYweDKg5jBDb7+7YogCCEAaIHm1BTKn
         eOyISeaFRqbPnZFfoOmyyzzecSLqRCLdTvigF5twwycyMfFhgcKVPD6VwX8Eb5GGqvZE
         zJwkpZ7xBveJusL0yumrYb9xcWqd7j/agXK2zuwQ6hQzfwBxIXbSTGDLgK3qILDIz/VU
         ehpsmU5kunFLfD/7xUkigLVnAaO5JhHrzVucw0qVPFVj6vb3HhZ86NO1YznK3Y/XJd4j
         zO8Q==
X-Forwarded-Encrypted: i=1; AL+hErHwtJXFUp+8+kJ8NXkJ7OBPYf1PyTyfs/MM2eao7LwixxGSFKJn0lzurNSGAdvRVMrcuNVoL+rBwg==@kvack.org
X-Gm-Message-State: APuU4Z8UlhcelYAjDCl7nV99h2HHSe+5wqfg5t6NNH4WdGHbyEEfcGtg
	nDJo9e3W1PVp2RiiODs3DAj2YwKn9sMXN5Q+XOLzLTt+9WHTG85ZM7ATgCsulC5Ju7GX9Q1FLOd
	BBxqMId2K+17LSCU6m9MkkkCdpiA29CM=
X-Gm-Gg: AYBFou2oeeof8WIosB8ny9W8UEkwJPogHdIE+f1d5VICmohh7GJSPjcTJ8C/zoFim7s
	GtgftpLHQAnpP2q4SxJ+1q8d/Fo3Z4QqtCPXPa+e69EwMB1Cmwxgdq98uLBIbxhSVnQN+VU2TVB
	VB8LhQGZvCclfleKZNZZbxrJiSNeRfDmXxsC8nXm/OWMtilmRVF3n9rG8p6tjHlc2NSiFLovckf
	eJmkP47PuU91E06v6cvkpxSUCZxfyb8WJ/8jGNQIqGKDWegM5zevFrf1s6iNNk9TvSikGGkUirO
	IspTOLpOpeZHuY9DbxcWgIWQ4/FeV0DL4sLulsk1rmWPxWRe/mo8LYA1M3jS6wZcu3hke85Ox/W
	2Pw1hPvmzhTgWUK1mbvKQgDOnz2gKHRwlrcXZ1k9atr+WhZlaBIqWp6RfSPxlB/d4Iq5zZg==
X-Received: by 2002:a17:906:f59c:b0:c44:16ad:c31d with SMTP id
 a640c23a62f3a-c50668b84bemr390386166b.4.1794473235463; Thu, 12 Nov 2026
 00:47:15 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261112081928.3014946-1-ridong.chen@linux.dev>
 <avV52J2rD19cjM2J@KASONG-MC4> <CAGsJ_4yibOkJmi9niJ8svu2NdEkZ5Qyf98VO6qMrJMa_9wGFgQ@mail.gmail.com>
In-Reply-To: <CAGsJ_4yibOkJmi9niJ8svu2NdEkZ5Qyf98VO6qMrJMa_9wGFgQ@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Thu, 12 Nov 2026 16:46:38 +0800
X-Gm-Features: AclHuK_EcloF2JvrHuKv7xoNWQwKzuk5RGeSJlKLhscR6ySvKSoZqdKqRDkMuSU
Message-ID: <CAMgjq7Disoabm_4yyp60=AdaEH1RWfUpawc8vckV2e6c7g2RmA@mail.gmail.com>
Subject: Re: [PATCH] mm/mglru: deactivate anon folios into the oldest generation
To: Barry Song <baohua@kernel.org>
Cc: Ridong Chen <ridong.chen@linux.dev>, David Hildenbrand <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Yu Zhao <yuzhao@google.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Ridong Chen <chenridong@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 4bqeps8ywhdsodxp9j4u41ykxcm1zot6
X-Rspamd-Queue-Id: 2D11640003
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1794473237-144319
X-HE-Meta: U2FsdGVkX1/oZT2Ec1spGutmywX6GkZpG/UfJwNk8fzhz1DoV0JlOADlYPrPVEHO0aGCut5Y5PnNV32mTp37iYlwhotNZTLtYLnK2eI7mnQiXO6D0vo+Jo06s4akPJMWEKHhsAhZpCGW9lSrY4vq15LGUVzDC/DNgUVzeYdVnPttjPqpSwwKjpSbvGRKGzZwHzoQGqAXsechi5zpNGPxu+3GptxQTUe9T6Nly8s/RfKZ8x+CUZ7cRlQmZa7hihGqopK1kcyngdUP/ffGTbJ1j/bIgRJ9pMYtrDn44ZMxJxDRQibHI2/EjWOuXG5HdJzIlsX4d0qefNZ4+uMybJOEOcHGYOoWTU5KQ/2lkoRQ82zDtaFid3CDi7LThE51a+N4aKSDyV2ot97XKt7opLbbtdpqmpDf/JkE/MVM0kKikt0bgpglUjjRJbnV82h6kI9RxSTLsmiEvK0RxXV1ROE+tL+xoTaz+NL5DkVkdsPTPEjFGPRiBeZ5oki7A24BW2IEoPc0vos+b6HsXcVM8dsR94/j0HP6oya8DUH2lXrC97wrWPhYImyixXCbJdyD9qYiQRRJ1+C7Pj1hzV0GPjtjPxUiOiw/ombvjhm71zIP1g+3k4CbW9PFeo6WJenY9+bW+aYEIy4ne+GwxOO0EaGZDXW7RRty9nJ8M+KqrF6tOpvzhgrpR6ncSZCJ+QvbvAzQnrX0t5czwPPfSt3VtxgVHaXJrib12zl894Lm9TEXJkufNa3Ml/0YPJ3IdU3P+OTE8VuLVLcP/FHSSh4qC3CCr9/RDbdFInUeGk6gkG60d5QNmxXTZtScwv01uXiO7mXPXrRI6YwNBfAO6Hpmr8jul9OgOcKFzCnPa3X2Dy51k9ChZfQM0O3y9xYS/iMbW2G9f4DXB8XUSCuUgqxmTBaqdmVa9tO5KMY0flXG+q3nH2Inw58ieFVc46hEUhFfCUDpLIXPw9v0oJUcXRO8tnO
 PA0XnGs9
 ccfIJWdFvt5tuBUb7EZoufCmxq+kufexIkIHCVAzbmcGivDmwZFCbrX+CYloXZvq/PSBwIdFNsM7KlDv1GS3lHmFsXJHXLvYeAVTdoq9GAWFdXYFD+QfkvbPYmOZ4ObT5B1280+Dl8YQKv/ExuIzRwIddsUyVNljhV6Vk8GTXbAwRBTcVFI1J9luYZl4GjfTVE/S9BFqnNdseLFatvOru7oZPMHVY7BBnwYeZs/xMn5BiadPqLr6mYOMWCqxG/wSnbq06RgwfVS+rrapDGengvWEDTU0s97FLAvK1k2EkB5H8sdUvG9kYlF7FvMAi1yHCyg/QbjyxNEVAHZSCK+478BY6vE1RwH7HFmLRHgsvbTetTQVgWE9qozSCiq0f4BVEpsQvdXX5R7Ok2HTAE0xgL9sRf+2FNgzX7qq3K4UNqM4jh/8N5qmQHILHvfkuGXjyPo3M
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 12, 2026 at 4:42=E2=80=AFPM Barry Song <baohua@kernel.org> wrot=
e:
>
> On Thu, Nov 12, 2026 at 4:38=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wr=
ote:
> [...]
> > >  mm/folio.c | 11 ++++++++++-
> > >  1 file changed, 10 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/mm/folio.c b/mm/folio.c
> > > index ea3adb6a89d7..c412d9b398e4 100644
> > > --- a/mm/folio.c
> > > +++ b/mm/folio.c
> > > @@ -583,7 +583,16 @@ static void lru_deactivate(struct lruvec *lruvec=
, struct folio *folio)
> > >       lruvec_del_folio(lruvec, folio);
> > >       folio_clear_active(folio);
> > >       folio_clear_referenced(folio);
> > > -     lruvec_add_folio(lruvec, folio);
> > > +     /*
> > > +      * For MGLRU, lruvec_add_folio() places anon folios that are no=
t in
> > > +      * the swap cache into the second youngest generation, which is=
 an
> > > +      * active one. Add the folio to the oldest generation instead, =
like
> > > +      * lru_deactivate_file() does for clean folios.
> > > +      */
> > > +     if (lru_gen_enabled())
> > > +             lruvec_add_folio_tail(lruvec, folio);
> > > +     else
> > > +             lruvec_add_folio(lruvec, folio);
> >
> > Hi Ridong,
> >
> > One question here, why MGLRU/CLRU have to use two different ways to
> > add the folio back?  Will this cause over aggressive reclaim of the
> > folio?
>
> I guess that is because on mglru, that is lacing a way to add the folio t=
o
> the head of the oldest generation for anon folios while CLRU can do
> that :-)

Right, but lruvec_add_folio_tail also added the folio to the very tail
of the inactive / oldest list, could it be a gain or problem if we do
that too for CLRU?

