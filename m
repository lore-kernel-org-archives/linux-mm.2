Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4912606A323
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 00:28:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AndzEtOi
Received: by kanga.kvack.org (Postfix)
	id DECFE6B05B1; Sun, 15 Nov 2026 19:28:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC3D66B05B2; Sun, 15 Nov 2026 19:28:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CDC436B05B3; Sun, 15 Nov 2026 19:28:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9F7936B05B1
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 19:28:42 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 87B97807F7
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 00:28:40 +0000 (UTC)
X-FDA: 85439096400.01.76699D6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 8293540002
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 00:28:38 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AndzEtOi;
	spf=pass (imf01.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794788918;
	b=G3VflpLuE6pdFjxRGbHLHhXm0h8fcAfi6GKJ4CdwT/ZaGsncpI7dC4eJxJzRs/5EL6vz74
	9F6ckxkmKyfJ85LnV6oPKYoxbm7AneSppvrPI5oWCYcUujWcuMAJ5QeOwlUXv9f9NAkCCs
	o95iFftiu/3QawLZoDqhAaH4F8V8Nv8=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AndzEtOi;
	spf=pass (imf01.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794788918;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vlb7g6V4pWyOd0zO2EPUK2XD3xyvl8j1Qdxp54r/T3c=;
	b=oiYzlkqz4KP+Emw5+T+JtZ3rA50kJTjoM14XkB7sdSkaMQFdjhGmr3aHXnjJ3Jm8qin/Fi
	HgcSK9/lMHJH0AMlWxAmdmEQfr0SmWemW1rrhowTvW+8ZvTumnEhAu1Wq1bfUX0JeCe9UN
	6GtkYJ8jwakQ/k0MuDYMFYe34qLtjtk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6E08F406F5
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 00:28:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5214B1F000C4
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 00:28:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794788917;
	bh=vlb7g6V4pWyOd0zO2EPUK2XD3xyvl8j1Qdxp54r/T3c=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=AndzEtOi7z7cZzg5NoaCCSeGXc7Aw6CARxM/9viahN7u1YCx75EsQ3oFhYCKViWaB
	 OVJ6lNQ8aE4CjAEwCl5fDsfViW9vqmSEJLR+u4yUP3X8NGxoYLvtkpQor/qmAq6Eu0
	 +p+st04SJbSnd3WEFAfw8wqbsFjUamBY+3XmM4ah9oXxT1cgCa456jvis8zml7ilJN
	 n/35Bi5/HwAwA4d0eLrIGQTcGo+B3mXFajaELi9SimK4izmoeCuYSu4YQP1IRgwe4G
	 EddrmH/ROtNglWsLLxtWMX0gWhba17bA9rb0r+h5fvSrKsfZ7u8uRpRRSp4fCalp6a
	 lVSpQG4DUku4w==
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-94965745d92so140765985a.2
        for <linux-mm@kvack.org>; Sun, 15 Nov 2026 16:28:37 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErH7YHNntMFv+qlzEPO3PqNKOhHrKOehZI3MQ4O6zuA9LkZKhWnJgFpBVzPIleCCKgqurfUkRQY05g==@kvack.org
X-Gm-Message-State: APuU4Z8AMa7fI0Nk0E+3Cr3d669Pc8ZPpPZL+rucWJ+qFgKl7WbpKHjY
	fmL7ru9TqwP7QuLmetCmX5SAgdVRgZolzfd9bDDUyBuJ63sUTpXbKOxh1H4WPWNcLrR6nqbVTdw
	bSijmViq5TpD4K91lbMvoXIp7zTVff6o=
X-Received: by 2002:a05:620a:6cc5:b0:93e:94f2:ada5 with SMTP id
 af79cd13be357-9494bb96c07mr1603501985a.25.1794788916691; Sun, 15 Nov 2026
 16:28:36 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261112081928.3014946-1-ridong.chen@linux.dev>
 <avV52J2rD19cjM2J@KASONG-MC4> <CAGsJ_4yibOkJmi9niJ8svu2NdEkZ5Qyf98VO6qMrJMa_9wGFgQ@mail.gmail.com>
 <c01ec177-da44-49bc-a542-35b64554526f@linux.dev>
In-Reply-To: <c01ec177-da44-49bc-a542-35b64554526f@linux.dev>
From: Barry Song <baohua@kernel.org>
Date: Mon, 16 Nov 2026 08:28:24 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4xx8ivDeh1d5pvJOEgndRL8rf=CO2==T480pAm=j2X0ZQ@mail.gmail.com>
X-Gm-Features: AclHuK-MUP8ZaH_AYwjIfA2I9NeM0NJE7zPqIV9E8LCJmYdS9SrrB7NPxzl6bIY
Message-ID: <CAGsJ_4xx8ivDeh1d5pvJOEgndRL8rf=CO2==T480pAm=j2X0ZQ@mail.gmail.com>
Subject: Re: [PATCH] mm/mglru: deactivate anon folios into the oldest generation
To: Ridong Chen <ridong.chen@linux.dev>
Cc: Kairui Song <ryncsn@gmail.com>, David Hildenbrand <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Yu Zhao <yuzhao@google.com>, 
	Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Baoquan He <baoquan.he@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Ridong Chen <chenridong@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: rxd8ibhh3o4nczt3iswketpr6cpb4hdm
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8293540002
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794788918-801261
X-HE-Meta: U2FsdGVkX1/uEjSflj6ydu/AGTvee/aX44e2Qio1UQyYtqj/w/XxTd4mmhRNAFq4kM9L2wtp4aXEi2XbRpOln7erH22lbWhwjLugbm3aD9IUAFMVxccb8KnQADWzifiQFDZ87lJy/jN7oQDVybheQAO3VKbNG/Fe2CEdbgSErVWYfY9wK0ez63flW+34PRTa6FEra40uHqi2vGp0iAWcvGr+2cWzEZ6b5DOtdUD+L2y/FTHb4o1YEsXt0SfQeF7DM+0K5+FCE4nlT1K9SJUvT3+PMovj0///ZKqPFBnHKrjBT2Glh/CsWm8pcpF46UNhwUWCDmMM2fMrXwAtVDGEB19SzWmEHqGAiiZIFu0jYfFa40jz+QkE6u5Sg4+K0q/Hlo5CyhJBXHTougN1ftHXrtzyfn/NpvXd6zvdcO3vHOOzlvOSAGQAJq0BuDdp3vbtz1Q/J6MNHEWF5vJ/iwDO6XamPu5f3qalbLKOD2WU6FaUnThQLiIu5QJz5z5jpIv3JAOXwtVNqZAwBAfKO9nHGYtjiQfFzHUPAkwXTle6yqF3OTRiOZMivYas3cq7vzUJHNjIVMlI/gWcD9NOaLcqLa5x9/GXlIYRfghvS84g8Uk+uKD8ug4ef2otkCiwUPsRzSK7SaBTw5WB95b8Tbvrsy7g3lWb4UzMvC9TGIka8bGTpkM2rPoNy6U5Qs6jq+7aZt1dzlw0Dzjf7olyLgcXVZEjza79+JCnTXRF+E2pEewDuDdf1sABkWfHBoervYjftRdZQMMKYslNvfImlcKLycyZguhjnmh91Jt2mc/s1mvV8z/lX3JOgNBqTl1ZyWUxzE08cXaEWntxwW4tDWhLukZO8zg3aFEoUYzsf5ghZW1nG40M/gr1da4L+MMEQduN5jnM9FQ9u6HHVe1uCRoJqVs554KCToQ/stkfmEaBE1zLuLeMC5e4955eUHNW7PGzcipFkH2Uo0gEbNbgtHy
 yC73G5yF
 jMoSbanJcS636zXTNbRprX/ZU9+GM0bJr5OikzaLXOlepvwPPC02athqNEgIj+fI02FdHeySczx4KmSnUxcZsCq2XMo5ynAlaeuJkwB6pvCZW3ly8Kse16VtN5G9P1IfXSjbvUNrxy5cpBn8vXmx6dDNOfC2YHhNklDLFBXfrlnZOwMQjz9DcM9MeWQLWvGaJx2AzAHNkRL2bDHg+UhhRTKVnH2JlEd4EVbr84KCHwnjoz5JPZ481SQ+BLU8QRPkBRc6YAcrR92XJjmlTnd3aD3XXnwc9Wpnhexf92bmzjp6xpeHTwXo60k9P5w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 12, 2026 at 4:55=E2=80=AFPM Ridong Chen <ridong.chen@linux.dev>=
 wrote:
>
>
>
> On 11/12/2026 4:41 PM, Barry Song wrote:
> > On Thu, Nov 12, 2026 at 4:38=E2=80=AFPM Kairui Song <ryncsn@gmail.com> =
wrote:
> > [...]
> >>>   mm/folio.c | 11 ++++++++++-
> >>>   1 file changed, 10 insertions(+), 1 deletion(-)
> >>>
> >>> diff --git a/mm/folio.c b/mm/folio.c
> >>> index ea3adb6a89d7..c412d9b398e4 100644
> >>> --- a/mm/folio.c
> >>> +++ b/mm/folio.c
> >>> @@ -583,7 +583,16 @@ static void lru_deactivate(struct lruvec *lruvec=
, struct folio *folio)
> >>>        lruvec_del_folio(lruvec, folio);
> >>>        folio_clear_active(folio);
> >>>        folio_clear_referenced(folio);
> >>> -     lruvec_add_folio(lruvec, folio);
> >>> +     /*
> >>> +      * For MGLRU, lruvec_add_folio() places anon folios that are no=
t in
> >>> +      * the swap cache into the second youngest generation, which is=
 an
> >>> +      * active one. Add the folio to the oldest generation instead, =
like
> >>> +      * lru_deactivate_file() does for clean folios.
> >>> +      */
> >>> +     if (lru_gen_enabled())
> >>> +             lruvec_add_folio_tail(lruvec, folio);
> >>> +     else
> >>> +             lruvec_add_folio(lruvec, folio);
> >>
> >> Hi Ridong,
> >>
> >> One question here, why MGLRU/CLRU have to use two different ways to
> >> add the folio back?  Will this cause over aggressive reclaim of the
> >> folio?
> >
> > I guess that is because on mglru, that is lacing a way to add the folio=
 to
> > the head of the oldest generation for anon folios while CLRU can do
> > that :-)
>
> Hi Kairui, Barry,
>
> Thanks for taking a look.
>
> Barry is right about the reason. With the classic LRU,
> lruvec_add_folio() adds the deactivated folio to the head of the
> inactive list. With MGLRU, lruvec_add_folio() can't put an anon folio
> into the oldest generation at all: lru_gen_folio_seq() places a
> swap-backed folio that is not in the swap cache into max_seq - 1,
> regardless of its refs. The only way to reach the oldest generation is
> the reclaiming path of lruvec_add_folio_tail(), and that path adds the
> folio to the tail.
>
> And you are right that this makes it more aggressive than the classic
> LRU. With this patch, a deactivated folio is evicted before the folios
> already in the oldest generation, while the classic LRU puts it behind
> the folios already on the inactive list. It also changes file folios:
> before this patch they are added to the head of the oldest generation,
> the same as the classic LRU, and now they go to the tail.
>
> So the problem in the current code is that a deactivated anon folio is
> promoted into an active generation, and with this patch it goes one
> step further than the classic LRU in the other direction.

I think MADV_COLD is fundamentally broken for anonymous folios
under MGLRU!

An anonymous folio may already be in an older generation, but
lru_deactivate() can actually promote it to the second-youngest
generation, effectively making it hotter instead of colder!

Right. For anonymous folios, we have no way to insert them at the
head of the oldest generation without introducing a new flag like
PG_cold, which is unlikely to be accepted.

If we instead insert them at the tail of the oldest generation,
I'm not sure whether that would be consistent with the historical
semantics of MADV_COLD.

But I've been thinking about how to insert a folio at the head
of the oldest generation. Why can't we simply move the folio
directly from its current generation to the head of the oldest
generation in lru_gen_deactivate_folio()?

For example, something along these lines:

lru_gen_deactivate_folio()
{
        int type =3D folio_is_file_lru(folio);
        int zone =3D folio_zonenum(folio);
        int gen =3D lru_gen_from_seq(lrugen->min_seq[type]);

        if (folio_lru_gen(folio) < 0)
                return false;

        folio_clear_active(folio);
        folio_clear_referenced(folio);

        list_move(&folio->lru, &lrugen->folios[gen][type][zone]);
}

Right now, lru_deactivate() seems unnecessarily complicated,
incurring additional CPU overhead and LRU lock contention:

1. Remove the folio from the LRU list.
2. Add the folio to the LRU cache.
3. Drain the LRU cache.
4. Add the folio back to the LRU list.

Why do we need all these intermediate steps instead of moving
the folio directly in a single operation, given that we're
already manipulating the LRU list?

Am I missing something?

Thanks,
Barry

