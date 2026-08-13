Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3CBEC5CFEB
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 11:38:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B40846B028F; Thu, 13 Aug 2026 07:38:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B19A16B0295; Thu, 13 Aug 2026 07:38:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A049E6B028F; Thu, 13 Aug 2026 07:38:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6F0976B028F
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 07:38:07 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id ED64180118
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 11:38:06 +0000 (UTC)
X-FDA: 85096047372.22.2F4B921
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 01530C0009
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 11:38:04 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="SwlA/jCU";
	spf=pass (imf22.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786621085;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=adlJbA0oaSn+S7Y45QNhJp5OJ498lEOPjLHwxOmP7Lc=;
	b=UyTtQk1/5Okq+/gVX5pOwWWHK+nU7tkZPn4nA0vJfEG7xc1TrKGMzKBm1VindJu65ykK5J
	h+2BOXVIlw8YHzsI9TqZCcQMbmqex7FxmeuSXAGl9BkV6KQmsCRVrsET3y6TbbrwpFEfiV
	Up3KJyt5/M4ioqu5HnUjpruLzf/WNQw=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="SwlA/jCU";
	spf=pass (imf22.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786621085;
	b=G5NRoL1n9/KGJfONn0P0LqejWmziSn1721341FW+4ijijZ8b5xMNAnF4yathc+XkcZ/7Px
	KSDDo8scxhyCH5+vsqgsNbft/NdJZy7yTQyjIsGgiPHFQxEUv7cc1OlHrlPgENVmv8jry4
	sZlZzhcQlJjGTHyGHtoJIsOVK3MFKEI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 32AE743FD3
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 11:38:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18AF91F01558
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 11:38:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786621084;
	bh=adlJbA0oaSn+S7Y45QNhJp5OJ498lEOPjLHwxOmP7Lc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=SwlA/jCU2ny8YNT9aeA1qT29Qi8hmnB52WRspet2Zb52LyF3rqyT4SxXns8nkL52j
	 MWjvyaBlXHm5/BJ7dJYoQvg0PXivZy8vSmxoerrivRACVGvQELr7sFZme0CeUzIq1G
	 +Q0OjHTPWW3CFUT/KJ0oiBt0SZnVQI5qgr0D/tvTiAqRYvk76jaZwI4kYy7DclVz75
	 WQwtOyH0coa3VeV0suXHNHrdypaxkCdMYraqSSpg/e8mk+FoHVupThTfLu9GZTr3k1
	 O5DfySutwRzByBCmL/8SSK1X10qa/wr+4MpuYj2jQLCZ+0o0M6k653F3Qrl4Arz7PT
	 PF5hC68WK/C0g==
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-8efcfdb2b43so3959356d6.3
        for <linux-mm@kvack.org>; Thu, 13 Aug 2026 04:38:04 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RpJFC1fnkBfPxqK6u3RFmLexzho3uU5qhdIua5Iwpt7px6RajmilikkpNTGcueTYbH6aMb2StEnaA==@kvack.org
X-Gm-Message-State: AOJu0YyaR3NU5MB/kLfEu2jfqNybwM2DfU0+8FtOfSU4uNeG1ALc7w/b
	86eW3BZ3IbhsbyFgCxqcZW6qXkibYhJ+ipqz1fKFZgFVAbjN7w0txHj3zoa28Vn4LYN8q2aq8aG
	Zc7cPkQ1ryld1KKbNsetMMdn4IjhgNCU=
X-Received: by 2002:a05:6214:5413:b0:8f3:ba0f:e7b9 with SMTP id
 6a1803df08f44-90a80bc7819mr52629926d6.18.1786621083366; Thu, 13 Aug 2026
 04:38:03 -0700 (PDT)
MIME-Version: 1.0
References: <20260813110230.2124785-1-ridong.chen@linux.dev> <CAGsJ_4xBQ1r7_rzmu7fBvuy6c3eZCW0Xq=puXtoiGf=JeVnjvA@mail.gmail.com>
In-Reply-To: <CAGsJ_4xBQ1r7_rzmu7fBvuy6c3eZCW0Xq=puXtoiGf=JeVnjvA@mail.gmail.com>
From: Barry Song <baohua@kernel.org>
Date: Thu, 13 Aug 2026 19:37:51 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4wEpmxZyDFj5eXwEDY_Rbveue552OqqiyZ2MOJw2TTrrA@mail.gmail.com>
X-Gm-Features: AUfX_mxabC0D3mw0VEfr0gnEFCVW5M-5DcqkQmHPx7eQGVOJ-Gb1_jpPgL9GkGk
Message-ID: <CAGsJ_4wEpmxZyDFj5eXwEDY_Rbveue552OqqiyZ2MOJw2TTrrA@mail.gmail.com>
Subject: Re: [RFC PATCH] mm/mglru: preserve inactive placement when enabling MGLRU
To: Ridong Chen <ridong.chen@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Brian Geffon <bgeffon@google.com>, 
	"Jan Alexander Steffens (heftig)" <heftig@archlinux.org>, Steven Barrett <steven@liquorix.net>, Yu Zhao <yuzhao@google.com>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Ridong Chen <chenridong@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 01530C0009
X-Stat-Signature: mp4cq8chmuh4j1s3xn5ou97dzi1456d1
X-Rspam-User: 
X-HE-Tag: 1786621084-14672
X-HE-Meta: U2FsdGVkX1+ChpH3uVAy8GIC/8dbFbAmtfJJArFUTZUzVEjy1rUexfduExIK+bg5QlLiFBovB8hLmatFHCtQ7A3Bo18RWCkoolThgVn06cFmGhkJUb/mJbIdUiAI9ZBcIOAVHlRtWXmgPrAf51TiLhwvhFdm2gP1PjJkOd1j1j2M4E4FwETb2y3ozxHUCvZWrJa3Dq9KkgaUqFowJ5Id4qczWo+44P+hVrhcNXjMuubLpzE31L9VefqryCDwfTrrMrrZbksUP+BrJNlVx+V74Ta42vbHMsyKK0hSwv3MeNsmX2GSTUhQqQGzRKwRhqGEtXsaq33ro/uaGmCNhAdbiEVsnNNTKt7gqKLv9W3bp+MqsOO8FVxjyO98jozzuX49se9WSelQsI6cHFG3nWLMiD5jp7B3RmrK0OtDW+5RTn35AWZPaA8Jp3B+st98NYgiXQhqeI9Fc/f8CoTndy7TZsQhMrECsk1ZadE7qXmP2HpYBRZBboBKJyrZbHclcwza+A0Bi6cbiDxJxmAbSO+ci/5/eL9F8x3PDQ8VOTvognU5yzxcHxLYC6rkyjttnba3unuOWhi1zUzPuFpVwT0Zxg9oUpOcCcyfr5kK72kug4TphcM2JWd9+focuKvcCT8YwMVQ5+uZUE+K8j9JiWFHqc42OHTYOySkR0xaIgSbmJ0ZeiH/0IBKDkVfe25VKKL69p2FADyNhI9XGaHWf/mb+SLOMi0vG9uw/NcDpxhqIZIDEponNN4zOO73OnzfocwYiLUMTJzZkzveR+B4SDl1quifM1zlrHoMrFC09T2fS0Wkh1oR+WYKHzhvnRRDbkj/zagnWrsojgZWCSyWMU66lSoJK4gXd9/9JLqzz7nz5zoqzEVl+NVqGhE625a+OzgrCSuB8AbPSDCH/FdwCCGJlhMEe1p305zN1cTMgdP0jx23PZGjHfMe9o6sUJbhHW57Y+86JT6vg/mfEq4DuR9
 bfFbHzAL
 38XKC/O/4ivKnwtJ09a52mQung5pGEb3hb4Iima9jr00vyMHDY3YzrjM8sXdkU48le3QgQTDjT0OrO3J0oRztgQ8/63dlatPlcZrrXfVvpkf30lOziFrhk0qhjOuoJlohtB2dn49Iq1QcI6c69HIkQbLsxco5YpHHOwFsctw4zhiLI6etGkqsughmIpSgWZRpgM8kYyCSds8vLnF9bfL+hiWl/SQKXWxCH6e13RXC/kz3iWPThrxLBGW2Ltjm2Ur2+5fXruWbnPBJLD8pWzFkyspBjOuDVD0YK3km6UUonXru8WkKGuE0oHnLKseSN/MrStDqywpKyWdCxg8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 13, 2026 at 7:24=E2=80=AFPM Barry Song <baohua@kernel.org> wrot=
e:
>
> On Thu, Aug 13, 2026 at 7:02=E2=80=AFPM Ridong Chen <ridong.chen@linux.de=
v> wrote:
> >
> > From: Ridong Chen <chenridong@xiaomi.com>
> >
> > When the LRU is switched to MGLRU (echo y > /sys/kernel/mm/lru_gen/
> > enabled), fill_evictable() re-inserts every folio via
> > lru_gen_add_folio(..., false).  With reclaiming hardcoded to false, an
> > inactive anonymous folio (no PG_active, not in the swapcache) takes the
> > "gen =3D MIN_NR_GENS" branch in lru_gen_folio_seq() and is seeded at
> > seq =3D max_seq - 1, which lru_gen_is_active() treats as active.  Its
> > inactive placement is lost and NR_INACTIVE_ANON is folded into
> > NR_ACTIVE_ANON.
> >
> > Pass reclaiming=3D!active so a folio from an inactive list is seeded in=
to
> > an older generation.  Folios from the active list carry PG_active and
> > hit the first branch either way, so they are unchanged.
> >
> > Tested on x86_64, next-20260812, 2G VM + 1G swap, ~1.5G anon pushed ont=
o
> > the inactive list before enabling MGLRU:
> >
> >                          Active(anon)  Inactive(anon)
> >   before switch (legacy)        2952         1548792   kB
> >   after `echo y`, unpatched  1552052               0   kB
> >   after `echo y`, patched      15144         1536636   kB
> >
> > Inactive file folios stay inactive either way (NR_INACTIVE_FILE is
> > preserved).
> >
> > Fixes: 354ed5974429 ("mm: multi-gen LRU: kill switch")
> > Assisted-by: Claude:claude-opus-4-8
> > Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
> > ---
> >  mm/vmscan.c | 7 ++++++-
> >  1 file changed, 6 insertions(+), 1 deletion(-)
> >
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index 94fc4f25e99f..2befc8d7dd3f 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -5319,7 +5319,12 @@ static bool fill_evictable(struct lruvec *lruvec=
)
> >                         VM_WARN_ON_ONCE_FOLIO(folio_lru_gen(folio) !=3D=
 -1, folio);
> >
> >                         lruvec_del_folio(lruvec, folio);
> > -                       success =3D lru_gen_add_folio(lruvec, folio, fa=
lse);
> > +                       /*
> > +                        * Keep a folio from the inactive list inactive=
:
> > +                        * pass reclaiming=3D!active so it is not seede=
d as
> > +                        * active.  See lru_gen_folio_seq().
> > +                        */
> > +                       success =3D lru_gen_add_folio(lruvec, folio, !a=
ctive);
>
> This is a very interesting use of the reclaim argument, as it is not
> intended to serve this MGLRU switch purpose. It is really only meant
> for `folio_rotate_reclaimable()`.
>
> However, the change itself seems to be *partially* correct and
> *partially* wrong.
>
> One real issue is that inactive is always placed in the oldest
> generation, while we have two old generations. Maybe we can ignore
> this for now.
>
> but somehow, are we also inverting the cold/hot ordering in the
> inactive list?
>
> `lru_to_folio(head)` always takes the tail, but now we are putting the
> tail before the head folios.
>
> Because reclaim =3D=3D true will use list_add_tail().
>
> if (reclaiming)
> list_add_tail(&folio->lru, &lrugen->folios[gen][type][zone]);

I guess we can fix this by iterating in `fill_evictable()` from head
to tail order.

  struct list_head *pos =3D head->next;

  while (pos !=3D head) {
   struct folio *folio =3D list_entry(pos, struct folio, lru);
    ...
 }

Then the oldest generation will maintain the same folio order as the
inactive list.

Thanks
Barry

