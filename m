Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E106C5AD44
	for <linux-mm@archiver.kernel.org>; Sat,  8 Aug 2026 20:20:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1665B6B00DC; Sat,  8 Aug 2026 16:20:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 11CD76B00DD; Sat,  8 Aug 2026 16:20:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF8E86B00DE; Sat,  8 Aug 2026 16:20:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A9CE96B00DC
	for <linux-mm@kvack.org>; Sat,  8 Aug 2026 16:20:37 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E32431C0F35
	for <linux-mm@kvack.org>; Sat,  8 Aug 2026 20:20:36 +0000 (UTC)
X-FDA: 85079220072.26.C2C3B6B
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	by imf15.hostedemail.com (Postfix) with ESMTP id 0A643A0009
	for <linux-mm@kvack.org>; Sat,  8 Aug 2026 20:20:34 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=D1ud2kcm;
	spf=pass (imf15.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786220435;
	b=ecrAJGUKN+QP0vcMVEtkY5VblIWOrFPAhrrGICryOCX9EbyV6l3ZxohRtbdiqzjP6cMcOM
	cqFbNyl7Z0HZjYhIV5SEOG3rot4NlB5ZbC3ZhNC7sIH/HN4th7ayVaDo2aps8eN1B8NvDt
	pcR7XKVdaHH2gnCX5xMbPiANlFWdlS4=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=D1ud2kcm;
	spf=pass (imf15.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786220435;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7USkv6HylUZV35VTqOcLUHAmyq0jYo/g+MvRgP6ozjs=;
	b=7auRb/vP0L2igpe740Tui+KVQf8VDMpPSfpt813AEa/XToR/Svkwx900V7+3I49YV1jpT4
	nY7DjtFt6e/XRqRmVIaRbnAHsotFGOSbYk+TGBr83hMRgG494fcaLtcgN3NjsTHVNeV5IH
	hn4EW1pYxq3PtYN0suzXlEAgZrlmPjk=
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-c1c4c7ddaf6so82467066b.3
        for <linux-mm@kvack.org>; Sat, 08 Aug 2026 13:20:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786220433; cv=none;
        d=google.com; s=arc-20260327;
        b=IXKDV4kFds8lcTQX8XZlxY7KT62SmtQScYNVhdK3P1V/00mR0sowlHUFyq7YqHFLky
         EI3EpFvcGUC6k6iiQNNFD8OmM3orNdT5eWnURsRmOHdj4PHkUGUpeOEUfMYCJk1fx6yI
         dSE0arxnMW5nsVP6og1byscr5m6qYTeAY/PTNd3JZ0xgBH3lfEePbhgLbLu9NpylUeJK
         E8XWUmhrwsWxs4+uYUT0vuZY4WbU0RThjU7whvm+5BBzhO+FZZd34R3l5z1htAK4VBqQ
         3R6c28e0RNF9yHiiWayKa4masWC7KIV7AmzVsumxAptTz0pAc+UMNVsr/sA8ryx1x49f
         MzYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=7USkv6HylUZV35VTqOcLUHAmyq0jYo/g+MvRgP6ozjs=;
        fh=3eK/jkbZOoHc15VoUJwOGUryFf50diLm6hH5FkYkqeM=;
        b=kgmAcDmM29+HxkND1C1lhwwdKipQXxVLuUs4tdpA0xJ+5lIxPz/ndunfRQyFh1MfxY
         F4kY60coR/uONFjRe8JB9SNb88CaqTe9G5bMsFz/Y44DSOVvBOtNSz49tNqK6KrmzFU/
         XnIDodxfXxYo/8pSsERMjdIFKogga4sLNtH5UtM9dqDQeJM1WEh4QcU5fDzcvRjuQk8t
         uB9SMLYOckRnVa09VzgrBt0tF+Xx3atrhanp9qSDg9Cw+VkfGNhR0qdNNeFGYZ9mNRGK
         /068EnWRUHX7WDp3LH/6F0q7cCsuxZYzf3GBGGAyCq/I2g874hpiv1gQWL+raS/tdRLA
         QUQg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786220433; x=1786825233; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=7USkv6HylUZV35VTqOcLUHAmyq0jYo/g+MvRgP6ozjs=;
        b=D1ud2kcmu0H3thANC5TiqfIzthvaPqnZMZMl92sOKBeTkH62TxBo2+wsZk2pqSDTnU
         AMs1vY1rhBJ7w+Xpqhy38gKKEJQJ3IoYzbosu+mD9MblRGT0SdwSaaqvxWbXzNKuhZN3
         Ia8saRNH9cYW+K50HCUSKpDTdMoHYKisp97xFHvoE2GAlnr9/Hqs3tppaBDJaKZWj5co
         AQb5IA4TEgbF+/ki0KzM2YX/vROPLOQusplpmsrXGv9458jKYFDhw51NocJDkhOzv8g7
         aFtWEa6AUogEQu0ElqVwpi12rHt4NfC4V3cbiJ+NKDYnLmepk/Th1wVghjF95DlAtlUd
         YEjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786220433; x=1786825233;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7USkv6HylUZV35VTqOcLUHAmyq0jYo/g+MvRgP6ozjs=;
        b=VOlhy1GrryA6+/rBXxSG5sUSCzajWdcs1+LNSwfoOUqWlRZw0R5xoDnQtTXYx/JaKi
         eDMaZ5Ed3Osshr2++JLiOWihvMsS8bHjuAgyzyCxv4c3fUDfATY91muOZcAXVd22aHN2
         SmCeq0F58L37rgq1QjCJX3SAaz+l1e2toI0w8HPWk3aDlu7sJN+yNupGkAiw48PoNEsp
         m9kLLKKKM0tkxI01xTt3KsBH2weW/LJVGvtABfpaI4twY6mJnMvBpK1lvAWRaFX0WI1W
         MRneU9swEYxvizXHX50yuQ+h/VvEL3pCN70YrLj18QRjxSlFjV4OPELqf8i9ijR0RYzR
         ltTg==
X-Gm-Message-State: AOJu0YyyPsj1+igh/pKN3lpx+Dp0Be4zH1c3R9POThI6/ozV0B7+m6Lw
	jnxT9zkK576LJL+vEJeUr/3/r/8fAdFVk6hcEV4FcEcpsFbyg7SBqKXrBIv3KUQnTFSrdqIKnHo
	68fCHRKXuj6cpAHPp9GG5pgTolKnWIbE=
X-Gm-Gg: AR+sD11Htg4Fnlt9GTI20Fy4ZvZy7gwSyEu7en0X4oV0M4tYwwjNcDH8TM5hiCxtYDO
	7NFvkvAVNMeG2o1Jl4ZeT/4axfUhhN3nQSNyU5WMG+ONUviU2mXnSO7SZU0nfNFbCnu9Vmu+0fq
	GjZSejdl+AFxLflcUV+3LDQzXtcgkTNhIGbEY/2Jf1tBSlyM4fkWLokD3RxTPSgilEmQMwDWARK
	8eOhKD9XsFa2ObP2YH/EkLjIc2RbQ7U82jSGzmlvM/aM0Lqkid8QjBktUmhwfztoWyoVFG4xUPs
	plrxqfHqdDR4pM/odRyVex0GDtT5pL6cPreOEIq+P/g4EKS55I6ALwpdte5cMtbjg8IQiI7N1Rh
	img==
X-Received: by 2002:a17:907:7ba5:b0:c1c:2c32:1163 with SMTP id
 a640c23a62f3a-c2039f3d9c8mr1598786466b.25.1786220433277; Sat, 08 Aug 2026
 13:20:33 -0700 (PDT)
MIME-Version: 1.0
References: <20260808-swap-thp-cleanup-v1-0-689939a7ccc3@tencent.com>
 <20260808-swap-thp-cleanup-v1-4-689939a7ccc3@tencent.com> <DKJSFCLP967N.YBR4DNK1NM2N@nvidia.com>
In-Reply-To: <DKJSFCLP967N.YBR4DNK1NM2N@nvidia.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Sun, 9 Aug 2026 04:19:56 +0800
X-Gm-Features: AUfX_mzNjTN_Rxq4mb3cky_t-BGkFmPLnT9Ij0u8xg3w9YMkKUv2ypY6R0Ri1Sc
Message-ID: <CAMgjq7Bb4tunWb8wxX+TwR2iLFub4dQciebSJUKwUrJ3udX9Bw@mail.gmail.com>
Subject: Re: [PATCH RFC 04/13] mm/huge_memory: split the routine for splitting
 anon and file folio
To: Zi Yan <ziy@nvidia.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Chris Li <chrisl@kernel.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>, 
	Youngjun Park <youngjun.park@lge.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 0A643A0009
X-Stat-Signature: 8pxs9bocjkg3u7gh8o3486fpsrhpag7c
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1786220434-438143
X-HE-Meta: U2FsdGVkX19hPDIyB68MY6HXCWcm3UbfEB8bH+jNqWn19nDlddg/0xtSpV+MYex1gmdhLh0eo4YklopEYirA67g3Qg1Spfgrp36q8FGPFzYOXzQWpyzoC4lFTH1JYcXyCEaUBcfNWiihYnZB8EnREaJ3bTwHWmYlEJ5bDBWzQlDecFhxYIrF0qnzmv+3oz6MCytGTsrlfvUFMzJbc/4KgmQ4b+7al+RN1FjYiU7yDirEf9q6oBAbMyXRgLqd4lG/uwnWwIUB66b56TdILfn/DqW2H7VR+LEkCOm9TTLbeH3GaRdNNeli8SKPokrcgMnZ1PmCkuHOORm+jmehYLaCa8/oOMFp5Upu12excBAX8C5QrEMXPTnvzi69ajehNMmJavUG/uPRu47g0ByOKOl4n1royLubf5wfP7GmcuIXBad7K9xhj5wJ9EUcBClU12dbJUVoRe4l89VyGcYck1LDfiBN5aKvQHLUukS9JT9uCWDvIhwA8+CUQkrexsBrUe9xTDdZ3UxWO4JtTNBeOTdCM1hiVqPFArCidesNYqsKy+z21Sf8E72hgp/6bm7qVwBO6+zN1tt7gQ/OSbzzbPm2Dx0aoIuI2SSMfN63mJWCoV5BHk/u6Ikx4gcM6QrEDorB6ABL9ji4X3C9vaDgP2+6LPx9rxbIv+L5jwJxDauNPZz6VSsmDyzinFXQ6Fhhx/fZN07CxFTszjAo0908rob7rj5kk/Wz8Qq4desXlIU9NmR2S1WdlpHH8bM/6kjgA0FmZk7rDWlTQ2Utwnj+UIXG0++5oQi1b3flmsz7hE3ONHoLqQ5yJgb9a0pqSF9G+6E4oPW7TaMkyHbngx5dz2y3+KMi8bp+u1maQpKkOO52ugeEb+dnFcNP3isZzlezl8cD+gCzaRe05fU+ldZ6wqdoK5J2SbcU06VdtvhrwZ5Ei3ii1Fuy8j5T6p8LY+AC0iDvooqOEX21dGz0ehEMk/F
 AO4LYUfJ
 xM7ceJDWy2QTviqWkAqoRHGCiSlAs8ngjuymCX97LEZctmoi/qmVkUae27CAybOrxYtq5XOIL6Utbzkw17xVfqX/GLBUAaelqA4IYoH5isI0YISaTpuuQHBiyl4rGhpARKa/SnO79hG2QQcaMPOn9OiOVyIxriXS+HtEtuGHsWhcvCr4Ltmgj93FbBHr8DrKseBjvdmV40wfjkNhA3kNNC4wWt7qQnVYNAvBBELX3dcE2a0Czsp4WX8/weC1UK/QsjS8k3lFYhhUI+rNmoIS5yJ7kLpLB/AN8WHv44rnqeLqA37FJEpDkBtwa7i/zq0B3HKwrNkTfdWamQI1Xh2yg5We+mwwvKhW6uzgxNCIpnPpoIPnQxkbjYCnT1+6T2bOp3Wo8T1AKWS1RXl384xdd8kfU2x83//60kkCH5GRyukmDsyrUBseq/eKEItzhDTDtVrcDdFICxxFfWCtR3bD6n8RI+lWadnWEhFiXwhXQlRy7lMxJ1Ru6YjnI1tMCRv8Sqcr3hVAZ2c9xzbxpYzTzqtPZnPvpJEKFR7x3NhZGWVh1T3Uddlf4mCL+fuVLs9q4Qwms
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Aug 9, 2026 at 2:52=E2=80=AFAM Zi Yan <ziy@nvidia.com> wrote:
>
> On Fri Aug 7, 2026 at 5:17 PM EDT, Kairui Song via B4 Relay wrote:
> > From: Kairui Song <kasong@tencent.com>
> >
> > No functional change intended. Before adding more logic, split
> > __folio_freeze_and_split_unmapped() into an anon and a file variant so
> > each path can evolve independently. The two paths shared little beyond
> > the folio freeze call, the LRU locking, and the unfreeze skeleton, but
> > differed in all other per-folio bookkeeping and routines.
>
> While at it, can you rename __split_unmapped_folio() to
> __split_frozen_folio() to reflect the actual folio state? It is causing
> confusion and people tried to use __split_unmapped_folio() on non frozen
> folios.

Will do.

> > @@ -3987,24 +3984,73 @@ static int __folio_freeze_and_split_unmapped(st=
ruct folio *folio, unsigned int n
> >               rcu_read_unlock();
> >       }
> >
> > -     if (mapping) {
> > +     if (folio_test_swapcache(folio))
> > +             ci =3D swap_cluster_get_and_lock(folio);
> > +
> > +     if (do_lru)
> > +             lruvec =3D folio_lruvec_lock(folio);
> > +
> > +     ret =3D __split_unmapped_folio(folio, new_order, split_at, NULL,
> > +                                  NULL, split_type);
> > +
> > +     /*
> > +      * Unfreeze the after-split folios and put them back to the right
> > +      * place, keeping the head @folio frozen until the end. While the
> > +      * folio is in the swap cache, the sub entries must be updated wi=
th
> > +      * their after-split folios before the head is unfrozen, so a
> > +      * concurrent swap_cache_get_folio() cannot return the head folio
> > +      * for a sub entry. Keeping the head frozen throughout also stops=
 a
> > +      * parallel folio_try_get() from observing a partially split foli=
o.
> > +      */
> > +     for (new_folio =3D folio_next(folio); new_folio !=3D end_folio;
> > +          new_folio =3D folio_next(new_folio)) {
>
> Please keep the existing for loop pattern by using next =3D
> folio_next(new_folio) in the loop buddy.
>
> Hugh pointed out an issue when I did the above for loop pattern[1].
> Basically, folio_next() reads folio_nr_pages() and relies on a stable
> new_folio input. In my old code, the input of folio_next() can be freed
> and causing oops. In your code, that does not apply, but it can bite
> people in the future the loop body changes and new_folio's lifetime ends
> before the for loop finishes.
>
> Maybe add a comment to explain why next =3D folio_next(new_folio) should
> be used.

Sure, I'll try if a macro can be used to deduplicate it.

>
> [1] https://lore.kernel.org/all/2fae27fe-6e2e-3587-4b68-072118d80cf8@goog=
le.com/
>

...

> > @@ -4231,10 +4259,14 @@ static int __folio_split(struct folio *folio, u=
nsigned int new_order,
> >                       ret =3D -EAGAIN;
> >                       goto fail;
> >               }
> > +             ret =3D __folio_freeze_split_unmapped_file(folio, new_ord=
er, split_at, &xas, mapping,
> > +                                                      true, list, spli=
t_type, end,
> > +                                                      &nr_shmem_droppe=
d);
> > +     } else {
> > +             ret =3D __folio_freeze_split_unmapped_anon(folio, new_ord=
er, split_at, true,
> > +                                                      list, split_type=
);
> >       }
> >
> > -     ret =3D __folio_freeze_and_split_unmapped(folio, new_order, split=
_at, &xas, mapping,
> > -                                             true, list, split_type, e=
nd, &nr_shmem_dropped);
> >  fail:
> >       if (mapping)
> >               xas_unlock(&xas);
> > @@ -4334,9 +4366,8 @@ int folio_split_unmapped(struct folio *folio, uns=
igned int new_order)
> >               return -EAGAIN;
> >
> >       local_irq_disable();
> > -     ret =3D __folio_freeze_and_split_unmapped(folio, new_order, &foli=
o->page, NULL,
> > -                                             NULL, false, NULL, SPLIT_=
TYPE_UNIFORM,
> > -                                             0, NULL);
> > +     ret =3D __folio_freeze_split_unmapped_anon(folio, new_order, &fol=
io->page,
> > +                                              false, NULL, SPLIT_TYPE_=
UNIFORM);
> >       local_irq_enable();
> >       return ret;
> >  }
>
> There are some code duplications but overall looks good to me. The lru
> lock, unfreeze loop, and the last unfreeze are replicated across two
> functions. I cannot think of an easy alternative. A tiny improvement
> might be instead of replicating unfreeze comments, changing one to point
> to the other one and asking the code should be in sync.

Good suggestion, thanks! I think code duplications could be further
reduced by a few macros or helpers. In following patches, removing
many if branches and streamlining the workflow actually improved it as
a whole, so I think it's worth it.

