Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47FEB606A31A
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 07:26:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=bQkNsL8N
Received: by kanga.kvack.org (Postfix)
	id 53D1E6B00EF; Sat, 31 Oct 2026 03:26:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 50DF56B05B1; Sat, 31 Oct 2026 03:26:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3FE3D6B05B2; Sat, 31 Oct 2026 03:26:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0ECB96B00EF
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 03:26:07 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 72CAD1C417D
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 07:26:06 +0000 (UTC)
X-FDA: 85382087532.18.9904140
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	by imf29.hostedemail.com (Postfix) with ESMTP id 79A2D120007
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 07:26:04 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=bQkNsL8N;
	spf=pass (imf29.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.53 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793431564;
	b=c2D3H9SEuJJiAfhWbYJv5iwKhzoUjjpRTDgQyZzSXBJPzCxZPJny7FyJ6afsO2Kg0Oit7I
	dLCWa8k1BpZV/4IK8AMlcK4TbVTiBPmdA1MIlc/squFFPNUZ1PvhHkZ+C6HRcJ8zHddskm
	K4OKQe/en4M+scpBl7/0h5VGHiijTFE=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=bQkNsL8N;
	spf=pass (imf29.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.53 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793431564;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F6WXP+mEDBqfSXhYu5dg3hwHsbs6lkoxCd/pRdVMPPk=;
	b=JwW8aRjAbqRRhwTOFD3cdhRleUxqLZKctJdColdtvTKJqhNMad9AARx53flfnqdmOJsxOI
	rXT/0dDKOqhauEJB3N6fU3S0vEOjBXyPOTtygIEI+m2Sfhtvmsnx2U21uBWNB2rIIfvjad
	BIWf7axOV+3BzO/foapxJTn3c2mjsnE=
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-c4697404c2bso180722066b.2
        for <linux-mm@kvack.org>; Sat, 31 Oct 2026 00:26:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793431563; cv=none;
        d=google.com; s=arc-20260327;
        b=k7l/ovPA4Y07xR+Q5fZJ+C5efyWJjZDsrIUTTSUIXCgsfE/2gcQ09znO4QvF3IrD8U
         jpZXk2TUO3sQsyROZlFgIZMlBc5q1YGAgi3eewPUoTYHuMie2TvjzblAAJAWKH9G+gyx
         k4RtT0keZuQXPaIfCYTJhRq1FZDA5RhWfyEeRtOVLOWCXwQmXWR25uR5He0XVjL+jEIF
         b9E7js4dJgGTOjvl8YH7SaJbb7s/E4B9bVxtzJ3sMZgIleAzQbzA/nr4DyBcbO9ZOmbb
         omY2JMiYeymHhFSv9bhX/3ZHL54mEUJqnpVv0Crl8SELrYlUJs5W590ioFBY8WQjK+9g
         GG7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=F6WXP+mEDBqfSXhYu5dg3hwHsbs6lkoxCd/pRdVMPPk=;
        fh=mktu7AdnJLzVzr4TlmI1Z61jah6dNwDcQ+PPMnQmPak=;
        b=gnn6hmf7DVMqOwh/+Jhn60VkuiNiFFasknDQ3lLBaUAl6utyUK4W/iOXKv0FzQ+kRG
         zrFfnl6qfwsOPvDbkAC3+O3DP/GoI/x24MPADM+BlKIVIBeDyMJ4fOW08USGl1OZuv/q
         C7mzS7H5v4qyF6z6EmF+jJY7e8bbNGxsfoxC8GRDDQ6wW8aW/U2+r8PNUTmJzXkWebUy
         W8kTIECxdjlzfgO71H+itzH+K4vaXV01jqE9A5U+ZD1O0pABnA16N9wDuo07awyZYfWd
         5P2iLcj6ILyjJcqHcwvXJWa3IXqeIwMVjb6sGv/rviOHUBuhHMh1EMdP+9F97E5Mx4mH
         OsdQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793431563; x=1794036363; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=F6WXP+mEDBqfSXhYu5dg3hwHsbs6lkoxCd/pRdVMPPk=;
        b=bQkNsL8NYmUrR5Q3QSWHPL1bJWVMOHXvwU9IT/EHgYxp244Wht7tMLDrx4TVxOBL2G
         b2hdH8VFjeG6kacYnBBGloJUbF5feuAs6iLTQGzbNv4s9xCkh0VFTHJESaxNNQbMaeQy
         RwmW2k9/fMeoW1b+xok5XtOHqtN/Tsh4cdwYBYK5FZQPJAiDQedxMifmtbjU/4leD6vy
         LOs4qrwXiQGXM1SHoNzTkFDqZw/YL+1mtVpm7/GPwX5clxlHjx/1T+5F3TgHuYajWbJg
         3gQvALV0bSCQZiMTj2uodVr55NOgznhO0HT5ZnyRrObtqgE5VIOMiCFGlmk5kNS7m1R9
         jwhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793431563; x=1794036363;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=F6WXP+mEDBqfSXhYu5dg3hwHsbs6lkoxCd/pRdVMPPk=;
        b=r29Hubk5Q0HrCOpfDMam7Id6dKe5M1XIozE/+bpon6KuI+A9Ob4gScz+ymZ/mAfg7X
         iSHZUuXHK4bYFfl1uNHjDizfOXYyRErdHKD37nXsjThSva0ipkRJkuNtds5abUtnai/y
         2n2qJjTpx79eM3kiJJqkgkf4E0lyd1CT6bb17eKFw6rrAvrIMWQR8bw8/lrBrkRycfsS
         50b6v3aHrl9m6C0v1uR/cYwpOJ8pODlelQNu1dGYAV6HlLrhJSfAXUI1kujN9RDbYpk0
         Yec1djf4WI/zkxoxPzFu14PKsR3iIX16PfP9C/FQfDnfDnrKvDiCVXQSKZ7XpbfO1gYa
         clMQ==
X-Forwarded-Encrypted: i=1; AKwUvBz8DtEODk8Ev9XK5q/kpoiMH27tZQVFOs5Z+qF6mq0+tXpkaIs+IASa6VvxQYd3zWhwHgN9AoH1hw==@kvack.org
X-Gm-Message-State: AFq9FYJlhN57OrKCHLW7pPKYHAwd5zXp7BKwil0cNzfH0ynhxCPlu+iY
	egjis/dte0gyE2mdTBuEHvrLguSOgtb82ZE73KoiC81UFfrirfS4nOnEV8/VNdntbDYLNHDCFhG
	pyngcLJPQ6WXne3XUo/2BgSc82YDoFKs=
X-Gm-Gg: AYBFou3Pmsqgx+jWLZPJultUJ8FNSS/kXq8F1wAP3Xl8wjRm3Xme2GFfQtnH1R/A0fj
	me+oTUrxg284UH1/VB9USDSRApuZjfaSTRJnGxu7ruZxsRAKQPxOc9bECWPAXoDZtATVNzBbXQh
	eZQ3xtgEBmQ9waiZQHZJcmzK/6jLLM2BcMJpCgmI61j0cVeeDjVf+EtIWwmgvYtFjgR0nVJCk+e
	4PZywZ5sLIn29tMTFKO3y575Bqwhuqol5scAfvZPAlA8XhOgNmKEGPGy10HlefTht/pAcb8Z1SP
	q3fqhCSR+SwMDbX+aAmiei7X/FwP11E/KS6ZeIMhV0qFpjRZZKpBWQxTAS6puiTFuuo1D79Ckb1
	dzDOAJtg3+rTlf0WfARhCxP7j2U08mTLW404u4w4vLxdrWe1n9CPsE1dG10Jr5AUz8O75/w==
X-Received: by 2002:a17:907:cbc7:b0:c40:19dc:a248 with SMTP id
 a640c23a62f3a-c4ca7a42046mr356741566b.15.1793431562780; Sat, 31 Oct 2026
 00:26:02 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261026084035.535989-1-hui.zhu@linux.dev> <CAMgjq7AJSU9jUBTHGcm05mtGBH4EMQ_ua9YNwuLOGVzhkdLKkA@mail.gmail.com>
 <CAGsJ_4zPZg6pCuhDtTpSkueS2EDSfWeYa23h7kC9hEU0iGB-+w@mail.gmail.com>
In-Reply-To: <CAGsJ_4zPZg6pCuhDtTpSkueS2EDSfWeYa23h7kC9hEU0iGB-+w@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Sat, 31 Oct 2026 15:25:26 +0800
X-Gm-Features: AclHuK-oRALqKn1jruGeRVlQNoYATQG78_2fhoUKQoQ-rHK8DD3zymOGsb6Ve4o
Message-ID: <CAMgjq7DvmrwTu0vz7oHx7y7w1B9uA0AbS3YJ5CcrDVg9VwKqpw@mail.gmail.com>
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
X-Rspamd-Queue-Id: 79A2D120007
X-Stat-Signature: n3ry3msxss8w76kgjtoai618yyfahpg3
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793431564-372767
X-HE-Meta: U2FsdGVkX19Y0RPofvoV0nbgISpLtHYOLIR/JMtsmb1eXFA32jsRPy6RFwvK7biUV515ZZJaDaZu58K74P58l7LLocq5T5GXaCCi50Ild+0Ygq1L/Z6E7cm3rCpW/9Q2rFWciQqkePdDvpyfl8HDKAfJ6iNILhfPTHQzVAEDB2tCnyhHlCAfTE8O/pMB53j8r+Mxc1S5AGCjXA7DOemylKHIhgDtPIA1DEI4ZO1tki9TDPK0RhdDqwUNErrrmQPdwEwQ64M2bmMDNZP+sbUWPo6sNSx3IYeHZJmd5+H04qbFpgYT1hFRESmd/d5lfNjg8zCAtZPBYx2QDHn7L2fYlr3KRSDE25pvDucF5PpPUzDadoaH0yFuwxRFjiLTKdIMCNNLfreV9J4BGiFh2DPuXxIjdjrrCviWOPN7RZ7sz58GHIv+RF6h4XYkFz9BOfylM8kFy76T2HVRag0QmVfQh1EJdz2pFSqFcgRowzKLvdFRR/Y4ZX2jBE7k2K6QKR5uFz7A84aapwN89p6yJaVVu53cKi+xeioqM/7LHkMYwJ5jURcdN8twgc5DFZ3t3tBCE+p0q6J269r143DgkgvgVoziAsk84b3ZiGEE7ZVW83zOpNRAHDfy8JLPEv7XtUBtZ99cR2pd66drRrbmqsPp7fRDXVRzSnXS7fM/xy9uvl0qhVsmWLiCdnl+hVzCdzdJ4Q2VQGzZdVeH8gbVVchz4etoZPdshm1fzfrdj4eOum3RWeSsyw3CZSpIGvX2tBLTKZCe4uPD0DL9DnFVRlLPw7S3YzcByZU7zj4LwoH9Daiw6WiOU4YUJmj2Lx9ZazpeAxc0ICsBujH1dM/kGTvMmdwMY6NXDTZfHk0idXgvYrlDZ5lIhDzJBrzh6irKrRjJbSthFmLkpjUrHIe2nikmbzRdRd3WE9jdLn9QCLAxtmi/0X4U7nXdq8MUlG008aoNsj3vX78U98qsNXJVzJd
 EOUhceZ7
 Bg4rM2p6hEhoxFY51YAK4wJKwzwhWuRzjG/nvoABjhCft/Vbt1eeccO8JKhiNFRSRlwCiY7wJ3HcUkUKl09MTdSMpe94UJLFmCRG4zMvurz+TDvOXm/sj/sMeG+88usUSdVmjBQPyUXw1beCoCEvXLW/PLvuDABIfeNSoIs//BjmTmtH5PEcC6akrmvczNehVSFuvzoqKgYSg8SlcwsGWt1coVHppnkAk+gNVLWaLSXrSmP3nqjVwcj3/GKI3Tv9MJR7nNiFGnDg5GIigEgwPzMJeQMoSp5pWt7UsFWsKlbHvfFqeByuR80A1cE7g/hoduYZcH3ivCyASeBgfnp9JvNkfxuGjqE4nQDwH7iPc/aptKo9OvP3iKnYtK9/RRQZ+lMNBl5lDmJ6O7AOOJkQleS1vJquzeT7v5xIXSG3Z2ZgfNpBAzAeQJ7McsG82RYg7A36ntAe5V4+Cd/vRtFRn41r+lMF/JNLhz4QvbfGtMAYK6R4R7ViC9nFxCA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, Oct 31, 2026 at 10:42=E2=80=AFAM Barry Song <baohua@kernel.org> wro=
te:
>
> On Tue, Oct 27, 2026 at 7:40=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wr=
ote:
> >
> > On Mon, Oct 26, 2026 at 4:41=E2=80=AFPM Hui Zhu <hui.zhu@linux.dev> wro=
te:
> > >
> > > From: Hui Zhu <zhuhui@kylinos.cn>
> > >
> > > lru_lazyfree() calls lru_gen_clear_refs() after lruvec_del_folio(), b=
ut
> > > lru_gen_del_folio() has already cleared LRU_GEN_MASK, so folio_lru_ge=
n()
> > > returns -1 and lru_gen_clear_refs() exits at its "gen < 0" check with=
out
> > > clearing the refs or PG_workingset.
> > >
> > > A MADV_FREE folio therefore keeps the state it had before madvise(2),
> > > even though madvise_free_pte_range() has already cleared the accessed=
 and
> > > dirty bits of its PTEs.  lru_gen_folio_seq() places it one generation
> > > younger, and PG_workingset puts it in the last tier, so sort_folio()
> > > promotes and protects it instead of evicting it and charges it to
> > > lrugen->protected[], which read_ctrl_pos() uses to balance anon again=
st
> > > file reclaim.  __folio_inc_gen() clears the refs but not PG_workingse=
t,
> > > so this repeats every time the folio reaches the oldest generation.  =
If
> > > the folio is redirtied first, ttu_anon_lazyfree_folio() keeps it and
> > > lru_gen_eviction() packs the stale state into the shadow entry, so a
> > > later refault is promoted to the youngest generation.
> > >
> > > Call lru_gen_clear_refs() while the folio is still on the generation
> > > list, as deactivate_file_folio() and folio_deactivate() already do.  =
Its
> > > return value only says whether the folio is in the oldest generation,
> > > which lru_lazyfree() does not need because it re-adds the folio below=
.
> > > Keep folio_clear_referenced() unconditional: the classic LRU needs it=
,
> > > and it also covers the folios that lru_gen_clear_refs() skips.
> > >
> > > Fixes: cc8ec7be78ff ("mm/mglru: optimize deactivation")
> > > Suggested-by: Barry Song <baohua@kernel.org>
> > > Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
> > > ---
> > > Changelog:
> > > v2:
> > > Call lru_gen_clear_refs() before lruvec_del_folio() instead of
> > > open-coding the flag clears; drop the lru_gen_enabled() branch and
> > > the comment (Barry Song).
> > >
> > >  mm/folio.c | 6 ++----
> > >  1 file changed, 2 insertions(+), 4 deletions(-)
> > >
> > > diff --git a/mm/folio.c b/mm/folio.c
> > > index 35e242b48870..ea3adb6a89d7 100644
> > > --- a/mm/folio.c
> > > +++ b/mm/folio.c
> > > @@ -597,12 +597,10 @@ static void lru_lazyfree(struct lruvec *lruvec,=
 struct folio *folio)
> > >             folio_test_swapcache(folio) || folio_test_unevictable(fol=
io))
> > >                 return;
> > >
> > > +       lru_gen_clear_refs(folio);
> > >         lruvec_del_folio(lruvec, folio);
> > >         folio_clear_active(folio);
> > > -       if (lru_gen_enabled())
> > > -               lru_gen_clear_refs(folio);
> > > -       else
> > > -               folio_clear_referenced(folio);
> > > +       folio_clear_referenced(folio);
> >
> > Why can't we just call folio_set_lru_refs(.., 0), and should we clear
> > PG_workingset? Keeping it helps PSI on refualt / redirty tracking (not
> > sure if meaningful but CLRU does this), clearing it makes eviction
> > better, but the eviction issue is MGLRU-only, CLRU keeps it.
>
> I recall that in v1 [1], Hui mentioned:
>
> "Use folio_clear_referenced() rather than
> folio_set_lru_refs(), which is not defined without
> CONFIG_LRU_GEN."
>

Or prehaps we can have a folio_clear_lru_refs() do in a unified way
for For both CLRU / MGLRU? (Just like folio_migrate_lru_refs).

PG_workingseet gets cleaned too, but if we thing carefully, it might
be actually the right move, even for CLRU. Stepping back: what
PG_referenced/PG_workingset encode is "this data has been accessed
repeatedly, so protect it". MADV_FREE is the caller saying those bytes
are garbage, the allocation that produced those accesses is gone, and
whoever gets the memory next, could be a different owner with a
different access pattern.

