Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3551C5DF82
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 07:59:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 721946B00A1; Thu, 20 Aug 2026 03:59:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F5DE6B00A2; Thu, 20 Aug 2026 03:59:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5BFCB6B00A3; Thu, 20 Aug 2026 03:59:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 29E606B00A1
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 03:59:48 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D4961806A8
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 07:50:41 +0000 (UTC)
X-FDA: 85120875882.23.F36C344
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id DB0CEC0009
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 07:50:39 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=neAQbv1Q;
	spf=pass (imf28.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787212240;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4WJtv0jR6sStv5vxf0tCXJE/Qix9ltmJSQswWyWPHUg=;
	b=3rzwwOpXEj86lS05/MPIkTn1Axn+QJ/HkJDg2s7zGoNmbtIFQX01jTf/QBBuRik+aInKkK
	xBF/2tN/xigZ+NTr7Y7Krx0qjF3ajCSqJSNOfskamk7ozRc5wVatP/mEf979+74Z5P+ba/
	jlNxJdSqwCWKg8AyMqofEsqwqwDR6Jg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787212240;
	b=KiuMOw4grCsLfVBYiw3C7A0o60GKmkKB9H1DWlz0tAPcyADihe7jjC5afSqr1+CQrEG5QP
	l+HgPoA8IKgoNNg4I2rHTUaAGMt2TT6L6A8t5m/75obY7g7Sl3DFa1FWSQg47SAJgcAdvZ
	9GajMYwZ2HHtr/Nh17ivfIyfTHykR90=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=neAQbv1Q;
	spf=pass (imf28.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2634043E60
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 07:50:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D9AF1F01558
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 07:50:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787212239;
	bh=4WJtv0jR6sStv5vxf0tCXJE/Qix9ltmJSQswWyWPHUg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=neAQbv1Qjm73GEOQvCZhElj0H/BirpBxAP3xFBYL/IUh/9Q5O6umHfDhcnAceoSNN
	 kFETkhtjaaUreVRsOR+7qK19kPNr2DF7VIzBe2HC43j5ayW61vZqThvyvPW/9SJh4M
	 +CaEormIP15qbyQ9/jI1GdbarRNpCqiyCWZXgwu5euvGPNI9A2UwzhqySVtsTCIdF5
	 p6iAnStUkQOuXGk+4qKckmcyK92geTHS9FFjUEhZm6xj5cLR2bSfFcY2eZsJRgi/DS
	 RjKBgWiFiN+Ty2aRdXuidyvO/sUs8LPP2kySegiyu26LOtVkNvvaSB9OGYdM6dNao1
	 vLxjHg/ain/lA==
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-92e7632b193so132514685a.2
        for <linux-mm@kvack.org>; Thu, 20 Aug 2026 00:50:38 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RrAGiNUu5iXRz5hMrU/Bap5D5mqHxdLPg9zJwM4YjZEbuF24kjLDxE37Plzi/Zut8ylbRT9A60urw==@kvack.org
X-Gm-Message-State: AOJu0Yx+eOLg+n1CFE65ITorIBBI/tlbZ/KfgjEF2fEv/yW/eeH919Ut
	ul1qoeD6sLH3uQVopZuP2dq07usIOZPtHHZpvWmoZgKZNpPrz7IZN6ESPQF/k/r7UPJ8583XBFR
	Tp4io3d/rlSRNl/Embhssv7xYLPbhZvU=
X-Received: by 2002:a05:620a:172b:b0:915:a111:86ae with SMTP id
 af79cd13be357-9371e67b4bdmr1040292385a.35.1787212238275; Thu, 20 Aug 2026
 00:50:38 -0700 (PDT)
MIME-Version: 1.0
References: <20260820072641.253591-1-ridong.chen@linux.dev>
In-Reply-To: <20260820072641.253591-1-ridong.chen@linux.dev>
From: Barry Song <baohua@kernel.org>
Date: Thu, 20 Aug 2026 15:50:27 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4wq46FkDQ_MhvEvtgdUQN5A_+_P+b6gbDvfEadus3WAaA@mail.gmail.com>
X-Gm-Features: AcwNN1WpZKVRcGQYU4YLusRNzGFSPplkASha87Nqpx4DHOMQ0BueSEE8CgJPFcw
Message-ID: <CAGsJ_4wq46FkDQ_MhvEvtgdUQN5A_+_P+b6gbDvfEadus3WAaA@mail.gmail.com>
Subject: Re: [PATCH] mm/mglru: preserve inactive placement when enabling MGLRU
To: Ridong Chen <ridong.chen@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Steven Barrett <steven@liquorix.net>, 
	"Jan Alexander Steffens (heftig)" <heftig@archlinux.org>, Yu Zhao <yuzhao@google.com>, 
	Oleksandr Natalenko <oleksandr@natalenko.name>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Ridong Chen <chenridong@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: epquz357cficpg8f84nq59qeoqcuyjhf
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: DB0CEC0009
X-HE-Tag: 1787212239-777834
X-HE-Meta: U2FsdGVkX1/KW2QzjRRKRuf5BEDBKasVuKxOa6mCRJYOKzKfKCzdRmHuTIBZpXeQSyGLiKryeG+1D/4YJ1PL0jCFd8Gi210zQkGv6JTIUeS/xD59GvmGM00X4dvwKdwsylSH8dG+HLwqdjAXQsAWRZ1dqTpE4t7y55eGYbiF0fAfL4qmVHmkoGnVnaCpMymSB69JIRJqAKhM9TqVDXmd8MC0DZlu2xcgivrzdaWtD+5H5r1P9fJDpMgCmVxW2T4ckn/eoXAkwxuQf0RODiZaAhYKNq+x+MrmmRYSUS6d0PS57GnKnfw0dBWtkCRHUeNwGhjGHG+QO/Var9d4z5pCGbsOD5i8YaE84pJUlSl5L3Pop76+BGkWAns0Bvos8q66x4kZN7TdEPgcRJRXm1njeiTzbVrCgnUycJURsKGP5hb/a7ikjvtw/WxUifdY7rzYTExUc2T2hcJdb81i3iITwA9U2xHav7/s4htwxVj9+o75K4yCNdMLY3CbCAYhXcMJQBfl+9U+OPygkpxd5vj1bCKKRmAbJeY8NqDvWUoMUdh2VKe5KmIxTISlHoYPeX8h/53IhjFkZavQTMeUCMWwj6qysq2Zq6i0vzqivGAfohjT/DN9LYKFkG9VV3eLfKmIhTa60hL4Ju1MnUC0nhx7YGNTSP0f4UJwtmqsMjb4xfQUxCPFKwnVXVk0HVyXUW2Nn7GjX4KK4+PlCXHuQ85hQf0jHMPpAb65U/o++hlSgXho9O2r4sfMZuZww4qqb4fmE+yO2S7gsGXLF38KAVgcwaWHvm0GrVNQAQxWxoB/QJoAMnSnJhd94w4x51SyRT/+YLXZEsSAXqpRiNAj+ofXh4pQCmbEHlHFgyivApxYsjo3YQFqq+OcHuXl82KspCO/wmWN1mIQL6aSV/GA29Nmc2RqdFls5LcBDnXX+x4tKseqgcQH65VHwxaC2B8ZJoGhngI5oe1bRHBfo4rAzKD
 3u8XDIgb
 bNZMD/sjEWJla8HoJZq5riepmRdRviUQX++cu/AYC4Afz4xiHyfMSktjzGrjOI9wk+ufTS6J9DT0bf3jaSHbUG66GF6b01I0LArpDl+jsQA18iuo0hqHaGbjebQPjJd+xFo50KPq0nr2rYJ2egvm5BlVs+qA17SKfph9v0yCLU79Ktb6KXCAjZ169AB4ttDPphrjbJTmAjbPQmT3vnrbiMoC8VeEZ90XWwv0fC1gg1cDmMWeW2Cla29ufma8UXl7rZq3bCmw2E1jUcFmucUSuwBlTlHOIFQQcWVPUrJTE0qajR/Hg+1cz6K6N1IMMofUgcs06kvpbhm2eQLw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 20, 2026 at 3:27=E2=80=AFPM Ridong Chen <ridong.chen@linux.dev>=
 wrote:
>
> From: Ridong Chen <chenridong@xiaomi.com>
>
> When the LRU is switched to MGLRU (echo y > /sys/kernel/mm/lru_gen/
> enabled), fill_evictable() re-inserts every folio via
> lru_gen_add_folio(..., false).  With reclaiming hardcoded to false, an
> inactive anonymous folio (no PG_active, not in the swapcache) takes the
> "gen =3D MIN_NR_GENS" branch in lru_gen_folio_seq() and is seeded at
> seq =3D max_seq - 1, which lru_gen_is_active() treats as active.  Its
> inactive placement is lost and NR_INACTIVE_ANON is folded into
> NR_ACTIVE_ANON.
>
> Pass reclaiming=3D!active so a folio from an inactive list is seeded into
> an older generation.  Folios from the active list carry PG_active and
> hit the first branch either way, so they are unchanged.
>
> reclaiming also selects the insertion end in lru_gen_add_folio():
> list_add_tail() for inactive folios, list_add() for active ones.  Both
> the legacy LRU and a MGLRU generation keep the hottest folios at the
> head and the coldest at the tail, and reclaim takes from the tail.  To
> preserve that order the folio must be taken from the end matching the
> insertion end, so take inactive folios from the head and active folios
> from the tail; otherwise hot/cold would be reversed within the
> generation.
>
> Tested on x86_64, next-20260812, 2G VM + 1G swap, ~1.5G anon pushed onto
> the inactive list before enabling MGLRU:
>
>                          Active(anon)  Inactive(anon)
>   before switch (legacy)        2952         1548792   kB
>   after `echo y`, unpatched  1552052               0   kB
>   after `echo y`, patched      15144         1536636   kB
>
> Inactive file folios stay inactive either way (NR_INACTIVE_FILE is
> preserved).
>
> Fixes: 354ed5974429 ("mm: multi-gen LRU: kill switch")
> Suggested-by: Barry Song <baohua@kernel.org>
> Assisted-by: Claude:claude-opus-4-8
> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
> ---
>  mm/vmscan.c | 29 +++++++++++++++++++++++++++--
>  1 file changed, 27 insertions(+), 2 deletions(-)
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 94fc4f25e99f..7be4cec9a838 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -5311,7 +5311,23 @@ static bool fill_evictable(struct lruvec *lruvec)
>
>                 while (!list_empty(head)) {
>                         bool success;
> -                       struct folio *folio =3D lru_to_folio(head);
> +                       struct folio *folio;
> +
> +                       /*
> +                        * Both the legacy LRU and a MGLRU generation kee=
p the
> +                        * hottest folios at the head and the coldest at =
the
> +                        * tail, and reclaim takes from the tail.  To pre=
serve
> +                        * that order, the end we take from must match th=
e end
> +                        * lru_gen_add_folio() inserts at: inactive folio=
s use
> +                        * reclaiming=3Dtrue (list_add_tail), so take fro=
m the
> +                        * head; active folios use reclaiming=3Dfalse (li=
st_add),
> +                        * so take from the tail.  Taking from the wrong =
end
> +                        * would reverse hot/cold within the generation.
> +                        */

too many words, maybe just:

lru_gen_add_folio() uses list_add_tail() rather than list_add()
when reclaiming is true. Match its ordering to avoid cold/hot
Inversion.

> +                       if (active)
> +                               folio =3D lru_to_folio(head);
> +                       else
> +                               folio =3D list_first_entry(head, struct f=
olio, lru);
>
>                         VM_WARN_ON_ONCE_FOLIO(folio_test_unevictable(foli=
o), folio);
>                         VM_WARN_ON_ONCE_FOLIO(folio_test_active(folio) !=
=3D active, folio);
> @@ -5319,7 +5335,16 @@ static bool fill_evictable(struct lruvec *lruvec)
>                         VM_WARN_ON_ONCE_FOLIO(folio_lru_gen(folio) !=3D -=
1, folio);
>
>                         lruvec_del_folio(lruvec, folio);
> -                       success =3D lru_gen_add_folio(lruvec, folio, fals=
e);
> +                       /*
> +                        * With reclaiming=3Dfalse, lru_gen_folio_seq() w=
ould seed
> +                        * an inactive folio near max_seq, which
> +                        * lru_gen_is_active() reports as active, so its =
inactive
> +                        * placement would be lost.  Pass reclaiming=3D!a=
ctive to
> +                        * seed it into the oldest generation instead.  T=
his
> +                        * reuses reclaiming beyond its folio_rotate_recl=
aimable()
> +                        * meaning; it also picks list_add_tail() above.
> +                        */

Maybe that's too verbose. How about:

"Borrow reclaiming=3Dtrue to place inactive folios in the older gens"

> +                       success =3D lru_gen_add_folio(lruvec, folio, !act=
ive);
>                         VM_WARN_ON_ONCE(!success);
>
>                         if (!--remaining)

This is admittedly a bit ugly, but it seems to be the simplest
approach. Since switching MGLRU on and off is not a common scenario,
we probably don't want to over-engineer it. So, with the above change:

Acked-by: Barry Song <baohua@kernel.org>

