Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35935606D81D
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 09:29:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VG9BxYMs
Received: by kanga.kvack.org (Postfix)
	id 50A386B05B0; Fri,  6 Nov 2026 04:29:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4BBD66B05B1; Fri,  6 Nov 2026 04:29:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D18E6B05B3; Fri,  6 Nov 2026 04:29:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0F4AC6B05B0
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 04:29:36 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AFAEB1A0D71
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 09:29:34 +0000 (UTC)
X-FDA: 85404171468.17.89DEADB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id B8A71160002
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 09:29:32 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VG9BxYMs;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793957372;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WneRI8zEINthMc9GHmH6/zD7m3iR83/KjXE9iSNfWjg=;
	b=N+HAAP2/uGG6nO7CY4VDQPkS2gQ+03Fzq37MtNp1aPPpKzyH/4h0P/wbP/L0iW36R/gKh+
	HDygED1Ieh7ckvp+YCeRxQyYNymO07isJ9U5HMeyiISuBRanQ0b/BDXQ6VLqIJb/ilsO3G
	PywqWpk6Jmg1odMvbQaLte0/2hpcVGM=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VG9BxYMs;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793957372;
	b=iT0k7PjHq3J1URMk67A383D5bQcB737LQG/TAXBU5XAJSz+9+33zPfUIdaTSdIViJyFsRQ
	ynLLrgDBIYbdYRhLwWd9vguLMgw8yFypejZ+HwSode7+bEZJLXx8ZkVmsgouuWtMwouagn
	8gFZ8qlU1qYIoe0euG5WhTan2sRrRNY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 97797438E2
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 09:29:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F13B1F00900
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 09:29:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793957371;
	bh=WneRI8zEINthMc9GHmH6/zD7m3iR83/KjXE9iSNfWjg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=VG9BxYMs/WkgcUa5xAMa0aimQAVFO9n94zvHJYAgPP0epXkE+GOOnJ1msivl/bciT
	 DUZEmeF1iutR2OZOcyFL3vTsN9QSHEyhoQVf06DYHVz0C1JoV72waTlB8LstOkBNpl
	 oHM0zmTMJsu9M0+4s8j6Z+D14jUy4kharCNQ/N5z1PTEmZJ96EMzyC3hsXkTC1jOL4
	 PgRVW8WwvINXHon1a6DRI+b4Uh0G7wSdxReZHUspA77FB8EiAnVJdvFydyv88Fn6EL
	 70skqzOxMLoLvm5qnVU5iJGn4zC0jJ0Y8pPl8IU1G+ZKaVBJikgaILeT23gjwFgaUP
	 FqtqZE86hsv+g==
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-93e64d52949so37938785a.1
        for <linux-mm@kvack.org>; Fri, 06 Nov 2026 01:29:31 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvBz62BO4tPM8sPM6qbf8nWExgJ6p2nfWRW7XPzrWYGQc4pijTmDEEg710qx+xiu0E6uLIiFO/X7WJw==@kvack.org
X-Gm-Message-State: APuU4Z+DW5viJTzJMGT7/+mb+HBuYCp+88KG3m8zCweg25ymL8hrZxmW
	Q35/JnCL8hH2Th7Bpyd6HYaTIVxMpJB5GR1hWQ000Oe7MdahzUK+qbZqnfBTAI6M1M1BdNealoK
	90/C/nYLnl1+87Rcc6MEOrtVn3LRDFxQ=
X-Received: by 2002:a05:620a:4143:b0:93e:c12c:f11e with SMTP id
 af79cd13be357-945f35fc301mr264775585a.74.1793957370683; Fri, 06 Nov 2026
 01:29:30 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261026084035.535989-1-hui.zhu@linux.dev> <CAMgjq7AJSU9jUBTHGcm05mtGBH4EMQ_ua9YNwuLOGVzhkdLKkA@mail.gmail.com>
 <CAGsJ_4zPZg6pCuhDtTpSkueS2EDSfWeYa23h7kC9hEU0iGB-+w@mail.gmail.com>
 <CAMgjq7DvmrwTu0vz7oHx7y7w1B9uA0AbS3YJ5CcrDVg9VwKqpw@mail.gmail.com>
 <CAMgjq7A6jJQ_Ncp0BCqjQJ8pJXrjr1PoOu0rdj0NJOivKp6e+A@mail.gmail.com>
 <CAGsJ_4zO5S5XFc6dd70wKEs_mzqu_QW2bGOPyhKo4w2cjZrWUQ@mail.gmail.com> <8e5956d5-ae03-40c0-b5a0-bd550f4c14b3@linux.dev>
In-Reply-To: <8e5956d5-ae03-40c0-b5a0-bd550f4c14b3@linux.dev>
From: Barry Song <baohua@kernel.org>
Date: Fri, 6 Nov 2026 17:29:19 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4wzDCqBsbQyAUiY=+iHNzDw0+qRvuKLQ_FWpc9CunSmvA@mail.gmail.com>
X-Gm-Features: AclHuK_055utCAu_emgM4jBlSxIibsKx9PY20xKuJpfTBMPvN5423Jhekgjf2qY
Message-ID: <CAGsJ_4wzDCqBsbQyAUiY=+iHNzDw0+qRvuKLQ_FWpc9CunSmvA@mail.gmail.com>
Subject: Re: [PATCH v2] mm/mglru: fix a no-op lru_gen_clear_refs() call in lru_lazyfree()
To: Hui Zhu <hui.zhu@linux.dev>
Cc: Kairui Song <ryncsn@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Yu Zhao <yuzhao@google.com>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, Hui Zhu <zhuhui@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B8A71160002
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: i5we9w17eowbzafu46w6sszzfwhd3mit
X-HE-Tag: 1793957372-178362
X-HE-Meta: U2FsdGVkX1+EgBDFW9lfFYDkIJy+MhniPk5dO2HrDGZeYAqhROr7O0ORTZyO4dPPhlzsQ3CIYhHNBfnTbBF0/A3CMPZQ7WOrDAUGImTrK8hYL0Jj/4a/KTbY4rFFK2UoQziGWkN2gGcyte01Pz78ktvTA/eJsI6kT5xz1RlDShtR3ZJsMY0B64A5iOPV8Xribf2ZVFm0W60CyKSPzaMN1rr6CwbyOdj3V+0fB7+vsWaHTqQkTMOSzRuQacZUvdxaB+0ppMVQv/OyiT8/zVYQQGNroaRfolroUWqSBdCqP7WVewc3cPcKvkeuq1xE7jETasYKztcUBcJbcPjpLQ4LmFttHcjNsO17mOzXFbpOyRgyjz/PIszMteSa5J/KnBAMvyqAnsvqFjvQaQvzwhjaNuE0k+SLjzsrY4CN5k2LIxj6jBeKPo7bNzCoeISFb0X+tWL2dTWUJPbioJfvcZ+FuAyLbTZiu4wlP/kGshIDUFylj23Gx+UEgOc/gvEFawmqFhZhMvlOFyWfGrsr8GvljwfycCBidvSqaUIt8VnBoyNOA34xYilkgyyPlwxh4O67k3EmcBBlFPuv50CmgZ5nn44HqXv/wQumzKfJyO6gTbvZJSCG8Rfy0aMJ8IbMT5NxM+KizXdCi5BFNcVhmayA9X+Sx8AijHDreELp7wJ8UpTE0iJdLu/G8N494nXRTVnTCygVsJVEl/W52hPO0aHqkafJujvUMwU5nt89hFVvRU3ixgWCEhW8YEPrnss9D3RVy059n9CdoTCCLQMmWOHEXJMT2Eezcws5rz4qh0ytlPO/Nju3lF304F9qcFDfFCf5PFf6GweoHd31BYR+1xJdAC0xEsgzHvNEr/crwfCPey0G9LbkWWXq9S8uyoGQjHEtlODT1heoIGB1DuvZKTPJI3mp3r5QJpjvfYMw2siA2i3QbwxhZO6QqHNUryua2z2U5kEFzLIBcxcbtIBf/O3
 S5ogTU82
 DJOz8+pVQT7oVDX2neQ7U8hByvPUzfYEmcbEx1hpsyayZPLeONyaPWjWLkI1ZW7z4dry9pXl0D2UbKBj+3H/bpTm5pxh+qw8Wi3KA3+fkYzkwx+NaK6AOub/N7hA+1/lL1JuLOBD/bGjMQbRfc0NEYT4d7QGcoXBU+LPsaSY+sMhz6j4uZBYVYjLxHY36Pi4iBbm/GqRN7xYi3vprII6DWqdTiZAgjp23SuL6Di00uNf6D7k6gQNhtnsnGRnBUiaw0gUWZoSdDePDYlHcKtLUYQlahPXhJT05AfRd5A1YeGyQ/S98omF+c5ccOrXLrG4gptj+szjkA5ona3Adaf7BTkLOAkrbr2jjFYzpHivQowFwHumKQix6N+OWwle0cLCKvwxvEYun3IgcoaWATlWB1pBHD0Uo5Z+6dWVOfjK06pbcTx/kBX8xL3/rUg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 6, 2026 at 4:38=E2=80=AFPM Hui Zhu <hui.zhu@linux.dev> wrote:
>
>
> 2026/11/6 05:13, Barry Song:
> > On Sat, Oct 31, 2026 at 3:27=E2=80=AFPM Kairui Song <ryncsn@gmail.com> =
wrote:
> > [...]
> >>>>>>   mm/folio.c | 6 ++----
> >>>>>>   1 file changed, 2 insertions(+), 4 deletions(-)
> >>>>>>
> >>>>>> diff --git a/mm/folio.c b/mm/folio.c
> >>>>>> index 35e242b48870..ea3adb6a89d7 100644
> >>>>>> --- a/mm/folio.c
> >>>>>> +++ b/mm/folio.c
> >>>>>> @@ -597,12 +597,10 @@ static void lru_lazyfree(struct lruvec *lruv=
ec, struct folio *folio)
> >>>>>>              folio_test_swapcache(folio) || folio_test_unevictable=
(folio))
> >>>>>>                  return;
> >>>>>>
> >>>>>> +       lru_gen_clear_refs(folio);
> >>>>>>          lruvec_del_folio(lruvec, folio);
> >>>>>>          folio_clear_active(folio);
> >>>>>> -       if (lru_gen_enabled())
> >>>>>> -               lru_gen_clear_refs(folio);
> >>>>>> -       else
> >>>>>> -               folio_clear_referenced(folio);
> >>>>>> +       folio_clear_referenced(folio);
> >>>>> Why can't we just call folio_set_lru_refs(.., 0), and should we cle=
ar
> >>>>> PG_workingset? Keeping it helps PSI on refualt / redirty tracking (=
not
> >>>>> sure if meaningful but CLRU does this), clearing it makes eviction
> >>>>> better, but the eviction issue is MGLRU-only, CLRU keeps it.
> >>>> I recall that in v1 [1], Hui mentioned:
> >>>>
> >>>> "Use folio_clear_referenced() rather than
> >>>> folio_set_lru_refs(), which is not defined without
> >>>> CONFIG_LRU_GEN."
> >>>>
> >>> Or prehaps we can have a folio_clear_lru_refs() do in a unified way
> >>> for For both CLRU / MGLRU? (Just like folio_migrate_lru_refs).
> >> And it will be better if we can keep this operation off-list just like
> >> right now :), some later works could benefit from it.
> > lru_gen_clear_refs() is currently multifunctional. It clears
> > refs/workingset, but also returns true to skip
> > folio_batch_add_and_move() in both deactivate_file_folio()
> > and folio_deactivate().
> >
> > This actually looks a bit weird. However, following the current
> > logic, I've drafted a version that we can use as a starting point
> > for discussion:
> >
> > diff --git a/mm/folio.c b/mm/folio.c
> > index dc2c796a4ea7..bc17cd3b6b6c 100644
> > --- a/mm/folio.c
> > +++ b/mm/folio.c
> > @@ -444,12 +444,12 @@ static bool lru_gen_clear_refs(struct folio *foli=
o)
> >          int type =3D folio_is_file_lru(folio);
> >          unsigned long seq;
> >
> > -       if (gen < 0)
> > -               return true;
> > -
> >          folio_set_lru_refs(folio, 0);
> >          folio_clear_workingset(folio);
> >
> > +       if (gen < 0)
> > +               return true;
> > +
> >          rcu_read_lock();
> >          seq =3D READ_ONCE(folio_lruvec(folio)->lrugen.min_seq[type]);
> >          rcu_read_unlock();
> > @@ -465,6 +465,8 @@ static void lru_gen_inc_refs(struct folio *folio)
> >
> >   static bool lru_gen_clear_refs(struct folio *folio)
> >   {
> > +       folio_clear_referenced(folio);
> > +       folio_clear_workingset(folio);
> >          return false;
> >   }
> >
> > The another option is:
> >
> > diff --git a/mm/folio.c b/mm/folio.c
> > index dc2c796a4ea7..8d1fd788188c 100644
> > --- a/mm/folio.c
> > +++ b/mm/folio.c
> > @@ -438,6 +438,12 @@ static void lru_gen_inc_refs(struct folio *folio)
> >          } while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_f=
lags));
> >   }
> >
> > +static inline void __lru_gen_clear_refs(struct folio *folio)
> > +{
> > +       folio_set_lru_refs(folio, 0);
> > +       folio_clear_workingset(folio);
> > +}
> > +
> >   static bool lru_gen_clear_refs(struct folio *folio)
> >   {
> >          int gen =3D folio_lru_gen(folio);
> > @@ -447,8 +453,7 @@ static bool lru_gen_clear_refs(struct folio *folio)
> >          if (gen < 0)
> >                  return true;
> >
> > -       folio_set_lru_refs(folio, 0);
> > -       folio_clear_workingset(folio);
> > +       __lru_gen_clear_refs(folio);
> >
> >          rcu_read_lock();
> >          seq =3D READ_ONCE(folio_lruvec(folio)->lrugen.min_seq[type]);
> > @@ -463,9 +468,10 @@ static void lru_gen_inc_refs(struct folio *folio)
> >   {
> >   }
> >
> > -static bool lru_gen_clear_refs(struct folio *folio)
> > +static inline void __lru_gen_clear_refs(struct folio *folio)
> >   {
> > -       return false;
> > +       folio_clear_referenced(folio);
> > +       folio_clear_workingset(folio);
> >   }
> >
> >   #endif /* CONFIG_LRU_GEN */
> > @@ -659,10 +665,7 @@ static void lru_lazyfree(struct lruvec *lruvec,
> > struct folio *folio)
> >
> >          lruvec_del_folio(lruvec, folio);
> >          folio_clear_active(folio);
> > -       if (lru_gen_enabled())
> > -               lru_gen_clear_refs(folio);
> > -       else
> > -               folio_clear_referenced(folio);
> > +       __lru_gen_clear_refs(folio);
> >          /*
> >           * Lazyfree folios are clean anonymous folios.  They have
> >           * the swapbacked flag cleared, to distinguish them from norma=
l
>
>
> Hi Barry, Kairui,
>
> >
> > I would personally prefer the latter. What do you think, Hui and Kairui=
?
>
> I prefer option B too: it keeps the flag clearing independent of the
> list state and leaves the two deactivate callers untouched.
>
> But I'd suggest splitting this in two:
>
> 1. Take v2 as the fix now. If that is acceptable, I will respin it
>     with Cc: stable added.
>
> 2. Follow up with option B as a pure cleanup, no Fixes tag. The
>     lazyfree site then becomes the off-list __lru_gen_clear_refs()
>     call that Kairui wants for later work.

Makes sense to me. I also personally hope this can be merged
into mainline soon so that we can backport it to the Android
common kernel. Having lazyfree folios with hotness information
sitting on the file LRU really makes little sense.

I recall I once did the below to ensure that lazyfree folios get
higher reclaim priority:

https://lore.kernel.org/linux-mm/20240914063746.46290-1-21cnbao@gmail.com/

And it significantly improves Android performance, according
to Gaoxu from Honor:

https://lore.kernel.org/linux-mm/7dcd3446cd8c4da69242e5d6680c1429@honor.com=
/

I didn't pursue that approach further, but at least yours
should address part of the problem.

Best,
Barry

