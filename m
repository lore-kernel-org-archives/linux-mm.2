Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E41A2606A31C
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 07:27:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=VpVX4uss
Received: by kanga.kvack.org (Postfix)
	id 55EB36B05B2; Sat, 31 Oct 2026 03:27:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 536C36B05B3; Sat, 31 Oct 2026 03:27:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 44E7C6B05B4; Sat, 31 Oct 2026 03:27:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 153646B05B2
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 03:27:31 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0E1911C42B1
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 07:27:30 +0000 (UTC)
X-FDA: 85382091060.13.E44A6BE
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	by imf18.hostedemail.com (Postfix) with ESMTP id 226FE1C0005
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 07:27:27 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=VpVX4uss;
	spf=pass (imf18.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.52 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793431648;
	b=sXUEZ/a9twtSXNaf9KjqG2BpNKyo9hk82t6eubtUF+5fntnnnHJBGMPBy0a55pln7NI0GH
	jDq3mG61QRhOXb9XgrKfal/irnhEJyTh0nIY7HacKA5gvsHIRMDLJJJxDupCPhCNRzxtAY
	gAmxeXGio9WPfKZyRts6sHHEExuM1dA=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=VpVX4uss;
	spf=pass (imf18.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.52 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793431648;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P3XWvG238gH7dkSgQ74A3SG60T6iclJBQql1w995p9U=;
	b=y8QItMTdLC/VPplikCqKj2SyYReQ205CA8834NRmS4mrJmFWP8TfE5nU/OR2LSeEua+O7u
	6jFiM57FE/RJASaKxpEZ7GCR+B9uzcnLfnEs/yoJk6oLCLz9Odt5pq8iQrfhxOfhtq2lsX
	yxAIzACEhyDr/qJUcWqylhCpltyryAU=
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-c468bd799ecso177097266b.1
        for <linux-mm@kvack.org>; Sat, 31 Oct 2026 00:27:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793431647; cv=none;
        d=google.com; s=arc-20260327;
        b=DKtWJja4TY+/Om6AvRQj9i6w9J3XpaGGJw7O0uifF6XrA86IyDvlcIYdzqp+HE3g7O
         NJ0GA+lOQqJOMJ1C1XNSp9KovTiHSvD4FaRUhbc+yK87CJcV7l1ufLuJukTe3N++hlWE
         7vtKXZJulYPIyS+4wOCHQi0p5oAro6kQbUVKqiX5Hx383NZohRI4Y83Yoyp+yh3tK80u
         eRmAk/7zO2KwDSblWWwkD1UPcKREuHE/Iy1pSTbG89qWgVefpLGJ4lJM+jBlcKmlVGoQ
         /kGo0TAhbhmCFd5MF3/s57fw6/s+1BwFq3Aan11jMKnc+Ow+lnSwB/4rXWSHCEd3PpxF
         oRrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=P3XWvG238gH7dkSgQ74A3SG60T6iclJBQql1w995p9U=;
        fh=LjhQpJCyLXI6namr4BmJWBL1cvtO0XpmB4+f+iBs4Lg=;
        b=SSYn6m559B73/2qJssSXZ9Teg67rqj96oeu6F+9e2RPKwkpMo+J/nqfYsUhsNq5sIk
         BAkxCQZ9uJeB0rdIfqoSC8KD5+xOP1sW50czj3Msvd4BF5A1Jkd5V0GUuwi1k3QijQ11
         X49n9klwIbiU2+3guPo2wg8cDv2ykiSfq573Zt23JIn3Ai84bef1hVYciY6A4iPGL4wh
         kB01/RmnfmVf3DS18jkVZRC1pwUWd0meYxoSC3UweihCni2yhBHPNN1g89uf7kMEygC4
         312V1QDU6U/+/ADr0W1uEHOmjFU1gUSm/F8YNndU3glDV7p7xQdEV6rFkLpHOQS24/NQ
         ac2Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793431647; x=1794036447; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=P3XWvG238gH7dkSgQ74A3SG60T6iclJBQql1w995p9U=;
        b=VpVX4ussblJxNUslesdDpRCZt1OSjCl8mgPLRwZUJfL7WYb3e3srh+AKQlNFSEWIVM
         U/j9FslD3xJ9OFFNmfoprVxo8GuoMsTsMxBYFpaNYMk1X44htJwo04EWdCM7EXskG8Us
         MuVKjygwlXxUHv0RPHtaDWGaNfNi/hhtTZzeXlCKDaHGltirn09//4Vz2w4Cv1lPvA3j
         ymrM9jPAjKuFm9WrM4wEQVCITKVbjhZ3iColq3xBye1dvWlN1vARyjzND4G134cib4Br
         2+1WE+jOS91Czb4GMtWOM1wxmX4revQeqMJRKTTGrrAp/h9ZtBl0D0gjl6YV1FAt/sYJ
         /NmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793431647; x=1794036447;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=P3XWvG238gH7dkSgQ74A3SG60T6iclJBQql1w995p9U=;
        b=tj+VSWRDIjAH9x0gXVeYLaqWnJfEA720gI+Y4iAbnEhfVoD7MU62LYbabb2EGkbPSk
         yg2pbKp459FK5VJAl1Tn7ttb1FOx9k7XL9/igWoF1GXOrCZ50jczz8lrT+2dbMjefqlp
         s5P7gFGnY4rJ+pp/p3791bJdsKkasY0DRIgPyZL4z1YGPIkNN5aOSVw5qbTbgYUxu8M+
         1YVmkZCaaEJggm82S5YdIVcPr2fQDsT+AHCknXM+FAo9yBiL7zNRApB7M0sTg5Rk3+xQ
         8bLbRQpIu9S9j0KEU1QmOFFxbB+tFCfYNlv9qWb6Zy85c3OSF7E+VESsAUq6WTNqZBMD
         2kaA==
X-Forwarded-Encrypted: i=1; AKwUvBwnd2+L1IGVsf2XifmyyIqg67caTA4lDuJXqME0FmCGISbqh+r2d3eAHgjNi3H8uqWvy0C3FC/G6A==@kvack.org
X-Gm-Message-State: AFq9FYI3AlTbWItKNBUgsVOu51EOTwS4O3YWXPB1+ETkJmNnRlX6nrn7
	JJe2zT9IGCXLeVUjIb70ZFHdbO4vq7irus7slwvZpUESAqB3MOZQt06rqgDG4jiMC4WM5LGRRFK
	3IOS/leWWOcFkkjAXXLc6rmhututgWq4=
X-Gm-Gg: AYBFou322/BS9QiCk56ADL/wOJcDEwz6sT4sMbFE2MIy01TL46F52EP8LBrLIq7IlVh
	lEQmSOGyvIJHV8snZ/D4+pYgSpt1WK4ZVgzgT741/aBEXhDCZgOudksQvSwErGfLGbullSJw7xK
	6zkoLA4gCLrL2u3tdeTiSybL6ZIdoHXxyQ+2gYT3NOHuYBTMJQJHUQoOib10yiqd5IeGJ2gHzUT
	biz/hbKcqObSXqVXTKbK33mE95JXlB5aDz/Z2+CHAGsrurOSH2SVbpA9audnuoX0KDuX1SZt7Pt
	vl2qpVh+cTkx9lVrF4cCLEbTrlEzUe3LFbaWurTuoky5XpsvrL35VvaUaCQ3QeUq33680gcRlo6
	nBfPk+/d4aNiBjuZP6wdJVvuVXky4MkmvczX6I+Mf2iPWVcy2N5oNT5RYpXk9i7FF2jix+g==
X-Received: by 2002:a17:907:9446:b0:c49:a571:c4f9 with SMTP id
 a640c23a62f3a-c4ca7a4205emr379272166b.13.1793431646490; Sat, 31 Oct 2026
 00:27:26 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261026084035.535989-1-hui.zhu@linux.dev> <CAMgjq7AJSU9jUBTHGcm05mtGBH4EMQ_ua9YNwuLOGVzhkdLKkA@mail.gmail.com>
 <CAGsJ_4zPZg6pCuhDtTpSkueS2EDSfWeYa23h7kC9hEU0iGB-+w@mail.gmail.com> <CAMgjq7DvmrwTu0vz7oHx7y7w1B9uA0AbS3YJ5CcrDVg9VwKqpw@mail.gmail.com>
In-Reply-To: <CAMgjq7DvmrwTu0vz7oHx7y7w1B9uA0AbS3YJ5CcrDVg9VwKqpw@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Sat, 31 Oct 2026 15:26:50 +0800
X-Gm-Features: AclHuK9LzX3HeYvpy2ZEmMy_v4dhENNFHAe1DOS4WkMeFjZGEVQnRuR5VhkzfvY
Message-ID: <CAMgjq7A6jJQ_Ncp0BCqjQJ8pJXrjr1PoOu0rdj0NJOivKp6e+A@mail.gmail.com>
Subject: Re: [PATCH v2] mm/mglru: fix a no-op lru_gen_clear_refs() call in lru_lazyfree()
To: Barry Song <baohua@kernel.org>
Cc: Hui Zhu <hui.zhu@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Yu Zhao <yuzhao@google.com>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, Hui Zhu <zhuhui@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 226FE1C0005
X-Stat-Signature: s7h4oc1aq684ueagkdh9w4633e7xtaxc
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793431647-756287
X-HE-Meta: U2FsdGVkX1//MIE7sH86Q681zlEIF7WBbEjdaHR5uLdv4BhvOcGDNovYQcZMHKya+2C00ROr/MInkw87eS3dol2NY6Jr7aW9uexDrzSe9hy4bq1WhFomag6/NE6Cds66FwyYyHQhFPRDGGJcrQ4DoRXqXbas52QmtvFNU9RNEtH5z4lrDWHMitxcvoVmlm1wOKQ25P3EZDIISG2QPhTjSAHWfOCrYSy4aIA6R7N8AxNWwvlPKNTAX2dxO2MUC4+HGoisTKZEyy7PyJQ/Y/yf9ND/RJfdEX3R/p/sJKsSsdUfWyx3GzVHO7I/nX/0BF4FHI36447NrCc1kIb5GIpntr8QKtEsY2oXHYCN2n/SnjVSZ43huTvJbxLZafBMMhZXqBdgmLY5uYqFi8Nx+BEsqKV0Hr8Z6YsAN7lwGoop3G8vKoJgDAxzJYIg7cr5r5rOG4XW8eCAlVIb2IC1KRtBk0yqbw6/eIvo1TWkrbFsuCgobk7AQB6a+D++rUq09W6m019y30hU1dPUzV6U19C8NmIALUKxgnoslEgJZJAB8HdkEYyKokAWa+cN5rfuiJRG9O3Fw9nlUqQ2C5DjwfJB10Bo02keLNSQ4Y0rdhuwopK2cPwYJoykplivaNHrL4QGPREFjjAdx/+pTfF+pfkO32Kz54ir6F2OtklP0wR/GWVra3iOmCqL5eqbQLIv/DkIkEOfLUgLApMWvs0eHFMMu8CcixTOncigpVW4I+3ZB/5+a8iqzKgbNYS764GfMwQ+V6u40vUf3fjt/slYqzfzjS6SMNK0lY7EPBStrobMouXZ0/eVSXhOJ0OZkZHSneVwBailvWUOjfxCp6qD30OhSuipeg8DxuH+isiIGmnAQpGLV7huVEOpU/Ohr9j50YQHnWEtoO8i8KyuEe0BYHfzxrPUsHpWphy6N4ynrZW5rQKQE1SQXhc6/90c7ppzYM6GDD6O4ry8lrgkJ70fTkj
 ebdkwCix
 IGYoWbn8w4Y5jW7LAKkTdG7RV4fB7yWXUQ68FZsggSqlSZ1IUnIHdnbZDAp18T4SERbAA8A20EH6r7PxL9p20oofn/BHoMd7KZXX+FU6neZSkerpOfFaEw0eCSLM/yO3JNOYIDMG5hmmXE81bI0aMs70dNziCUMccVbqQ60rueL020ysiRuFDELd0gSNKfLJ3bBYl5aBWwCP9Lvm+fwYaSOKIgE3eTfGlM6syz54stwaeOd5ZqmbFHQAFl0ndphfBwrFT+2YMxaZ8Ut85spUAdCO8KG/RJcWI02E6IecCsg2HV+QqPzw9UlU7Jgw9NA3CuOn37IfTjqvCRZTFZbTOm73XLmJZfpwnrGNI9o0TKwI90qA+e5VqWJFgIF1UVNydFUxmV1ANASrYQi95xv1/lOtTs+3Fyd8EowZZWPueIpWwiC3sMT7+kYSguDnalk9tNrkQzE4fME40NlXryvOFZnDjeAnAZCnxHDz42jKIqay4LF0nE3LCdQ1COQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, Oct 31, 2026 at 3:25=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wrot=
e:
>
> On Sat, Oct 31, 2026 at 10:42=E2=80=AFAM Barry Song <baohua@kernel.org> w=
rote:
> >
> > On Tue, Oct 27, 2026 at 7:40=E2=80=AFPM Kairui Song <ryncsn@gmail.com> =
wrote:
> > >
> > > On Mon, Oct 26, 2026 at 4:41=E2=80=AFPM Hui Zhu <hui.zhu@linux.dev> w=
rote:
> > > >
> > > > From: Hui Zhu <zhuhui@kylinos.cn>
> > > >
> > > > lru_lazyfree() calls lru_gen_clear_refs() after lruvec_del_folio(),=
 but
> > > > lru_gen_del_folio() has already cleared LRU_GEN_MASK, so folio_lru_=
gen()
> > > > returns -1 and lru_gen_clear_refs() exits at its "gen < 0" check wi=
thout
> > > > clearing the refs or PG_workingset.
> > > >
> > > > A MADV_FREE folio therefore keeps the state it had before madvise(2=
),
> > > > even though madvise_free_pte_range() has already cleared the access=
ed and
> > > > dirty bits of its PTEs.  lru_gen_folio_seq() places it one generati=
on
> > > > younger, and PG_workingset puts it in the last tier, so sort_folio(=
)
> > > > promotes and protects it instead of evicting it and charges it to
> > > > lrugen->protected[], which read_ctrl_pos() uses to balance anon aga=
inst
> > > > file reclaim.  __folio_inc_gen() clears the refs but not PG_working=
set,
> > > > so this repeats every time the folio reaches the oldest generation.=
  If
> > > > the folio is redirtied first, ttu_anon_lazyfree_folio() keeps it an=
d
> > > > lru_gen_eviction() packs the stale state into the shadow entry, so =
a
> > > > later refault is promoted to the youngest generation.
> > > >
> > > > Call lru_gen_clear_refs() while the folio is still on the generatio=
n
> > > > list, as deactivate_file_folio() and folio_deactivate() already do.=
  Its
> > > > return value only says whether the folio is in the oldest generatio=
n,
> > > > which lru_lazyfree() does not need because it re-adds the folio bel=
ow.
> > > > Keep folio_clear_referenced() unconditional: the classic LRU needs =
it,
> > > > and it also covers the folios that lru_gen_clear_refs() skips.
> > > >
> > > > Fixes: cc8ec7be78ff ("mm/mglru: optimize deactivation")
> > > > Suggested-by: Barry Song <baohua@kernel.org>
> > > > Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
> > > > ---
> > > > Changelog:
> > > > v2:
> > > > Call lru_gen_clear_refs() before lruvec_del_folio() instead of
> > > > open-coding the flag clears; drop the lru_gen_enabled() branch and
> > > > the comment (Barry Song).
> > > >
> > > >  mm/folio.c | 6 ++----
> > > >  1 file changed, 2 insertions(+), 4 deletions(-)
> > > >
> > > > diff --git a/mm/folio.c b/mm/folio.c
> > > > index 35e242b48870..ea3adb6a89d7 100644
> > > > --- a/mm/folio.c
> > > > +++ b/mm/folio.c
> > > > @@ -597,12 +597,10 @@ static void lru_lazyfree(struct lruvec *lruve=
c, struct folio *folio)
> > > >             folio_test_swapcache(folio) || folio_test_unevictable(f=
olio))
> > > >                 return;
> > > >
> > > > +       lru_gen_clear_refs(folio);
> > > >         lruvec_del_folio(lruvec, folio);
> > > >         folio_clear_active(folio);
> > > > -       if (lru_gen_enabled())
> > > > -               lru_gen_clear_refs(folio);
> > > > -       else
> > > > -               folio_clear_referenced(folio);
> > > > +       folio_clear_referenced(folio);
> > >
> > > Why can't we just call folio_set_lru_refs(.., 0), and should we clear
> > > PG_workingset? Keeping it helps PSI on refualt / redirty tracking (no=
t
> > > sure if meaningful but CLRU does this), clearing it makes eviction
> > > better, but the eviction issue is MGLRU-only, CLRU keeps it.
> >
> > I recall that in v1 [1], Hui mentioned:
> >
> > "Use folio_clear_referenced() rather than
> > folio_set_lru_refs(), which is not defined without
> > CONFIG_LRU_GEN."
> >
>
> Or prehaps we can have a folio_clear_lru_refs() do in a unified way
> for For both CLRU / MGLRU? (Just like folio_migrate_lru_refs).

And it will be better if we can keep this operation off-list just like
right now :), some later works could benefit from it.

