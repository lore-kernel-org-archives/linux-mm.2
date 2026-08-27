Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A72C2C61DB9
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 17:36:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB1D26B0092; Thu, 27 Aug 2026 13:36:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A891D6B0095; Thu, 27 Aug 2026 13:36:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9794E6B0096; Thu, 27 Aug 2026 13:36:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5E6E76B0092
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 13:36:39 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8B93780141
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 17:36:38 +0000 (UTC)
X-FDA: 85147754076.22.93499A0
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	by imf03.hostedemail.com (Postfix) with ESMTP id 9774D20005
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 17:36:36 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=pVXvDvRo;
	spf=pass (imf03.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787852196;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9lkMm8lvYUjv5dpOxr25jt/qefHlkYagepcQl8vTMUc=;
	b=T9APYEpCf+Ps/HD12jklVtVzgJc/Nz7JgUW8Cl8sW2GG7aQW4kWu5cNTj2vS+qnSnZHp12
	kpYc2cEf0R5zTJgg9YacpXFJXfrQ8UQXXSg2jEGZ8sGKRJjFqMUPoJS8tcg26hvjTgFcFm
	AHkeASqCMtFFoEvbm7zCanqgU9myPeo=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787852196;
	b=QJdYY8VfnN5A/Pu3TOcXf5klGkrRu4cQ2WLqYG46OT24FertC8PDwyT1fJOCkqx7UAyZRG
	6lYyelnkNjEyxlzJ45l/EGmhXWRMhd7H6D6Sej3lqGJnEZli/rQmryhoqd8UVFcT307JGC
	CeahkOBJEai3C5jM7zhW3u/4HoLILF0=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=pVXvDvRo;
	spf=pass (imf03.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-6a5e329c0f2so53905a12.3
        for <linux-mm@kvack.org>; Thu, 27 Aug 2026 10:36:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787852195; cv=none;
        d=google.com; s=arc-20260327;
        b=fh0Hyu3gta73uCCwEohAyRpXEqrThJunTz3d29W5j1sk8drV5NuSWlYlftRjaOrQ+o
         c5MRlU24X+g/zuQbHu1We3WpVPawoFBnOjlFZgbWe4rt4VTJa49auZ3gUgEb6OzMxckR
         bEjnuAm6M0QE1cpvC3ISCpzk3nF7puU4ChNkf+7cLuUXSS+Z3zm4NXHjjzkHYDheKJiJ
         XDc9AhuX2O+/pVtEA65cE18wcbz0hvnyVRLxfk74xNFp92q7+RYPBHNdZueb+Vq/mKsJ
         PkmnVzSrdN03h/1PNklen7gSXmXUf7nDqG9/Qu1dJ+UXWrOMAGk9HOVDJdhHQk4qaZaT
         /Acg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=9lkMm8lvYUjv5dpOxr25jt/qefHlkYagepcQl8vTMUc=;
        fh=gW5ivs51vbjATpS7fTtCbsRWfHNWurt1lFXO5nnQLVM=;
        b=oZo2swNlqrUPCP2dAg8YBstLcvG9WvGPQgwmtRUQenWKE/IOmxbXd97d4ud24efSt1
         H20R6OkRwG0/hvQ1Ao9rRgl1S3tjKmWdv9sxzQRdtwImmqXPfxLoaUZr/0i7ZMRoqf1/
         KolxundHQTvHSLiWSqgNbT/XqDYBbF1qtwmuBVA7xFIe8hMlRsRfhi+BARhXtmemDx1a
         SJJNspo1PAe4xyxvYqmvpw6okuVF1mF6RmpGOq6whMSqiJCyWnbn3OwCtslcc5PAnr6k
         9VWRa3tRUJ05uv22A1k9nxbl7sgpsB4MROarqveSpAKo7nwD+2wao06p4ccN8mA9EfQT
         KmtQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787852195; x=1788456995; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=9lkMm8lvYUjv5dpOxr25jt/qefHlkYagepcQl8vTMUc=;
        b=pVXvDvRojInY4i9a111ZkqWmdz9tlrsnGGQWIFCjrF12Du+siShYJ9U1b9saq+nGpT
         t0n1SL1MZUOg0m4dlGfGwzwTWipJjClLVSvAmmlDDp8h8aa+K1aTnxANvWlmbT4o5lvC
         DIUVDxRQpn6B8w2G0dsOIxXdY+oynVJKNCxFBba5FU2rx/b/whnAkAwFmHPo3qGeVdIl
         XhjpizyQypVwb5qWHc3oD6VU2oO2p6aqz5Y00ybm2VSpDGju+Y1nF7bFZbMvKBBEP6yj
         NMMjAm0+qwtkM1f+Os+eljh/JipKartymy0K+f1YugOuQxGN+FBYIe1PiSeWMT63mk51
         oalA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787852195; x=1788456995;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9lkMm8lvYUjv5dpOxr25jt/qefHlkYagepcQl8vTMUc=;
        b=OhFgTw13nVMP8+Zgy0ZGyl2MTtE/r64qOPUcqkc88hZ11D7p+kbtjzFzPZJG30Vn1c
         4HEhYRPyTP/yY0XtdLuOIi+27Mxj1tE+idjxW7gY5Gjz9lybTtVgAuE6snQtymdS40gT
         eQUNGhmWxoSIke3W4MD0VvlDUVMwBDsIRWmY+CBmdDLgXfXz4S0pZOiFIv3rBbFV7YaA
         mGYaDJreYAenIteEMewKoMoyCkhoIB1/8jxcnTHqPIHu13mxJdYzJcnkGIL1dJPdYLOx
         3ALMA2GJPWNAMEAF9pF7MgxAAjaAe7s5NQbdJRkCQNDUhB12Yh7VviAXMNyx305lKfHB
         k0/w==
X-Gm-Message-State: AFuF++lTm7cRdbDetpj/+VaO1gSFmJX0aP2dm8qVmd40wuJmmN9Sbe2B
	C+F4rGcjD5EZTP3DQzFrfJLm828Ahz3ABcjQU62f68lbQqOuRTreOGNA678lH9p4I5ETX34xZIs
	AghmYDhLDN9Vvdh4+FlH/CZu1plrBUe4MbM5DtKc=
X-Gm-Gg: AR+sD11KoyqCigar7zXKcqOrmKORSUazwVL2PGPKDpF76xtKgK0UmFV+hITJMj9ELDy
	cX7jxWmGiLZBHhyHV5krUzVvJgt4LKg8IMrBr19gtR/hft20gAdZHnxMHOjgHzOSsYopy08A7bQ
	2JAOKKxQGWezFlXG6jyNeeMXCNS1eb9f5CJmAJ7LllBCneTM6FyaF2ItbVdgzkb1vJB8SPYBJi5
	pwIwCTQShoDKKSPsy2UQAUxiDGQ0grpoWDn53XoyFjCCCdI18LnhJLvFoydmZPpYrcMO5cqrXwS
	10rq/ktO5M7IIt9Gpm5vHCPzzvOVrdgr82oRJqaW3wXUp2Zz3M5xsqecuWS8qPf/O5T8BQ4g+fm
	jsRENc5K5yfU=
X-Received: by 2002:a17:906:9fc7:b0:c20:ff26:336e with SMTP id
 a640c23a62f3a-c25570191c9mr22400166b.14.1787852195125; Thu, 27 Aug 2026
 10:36:35 -0700 (PDT)
MIME-Version: 1.0
References: <20260821-swap-thp-cleanup-v3-0-9b43f5163238@tencent.com>
 <20260821-swap-thp-cleanup-v3-8-9b43f5163238@tencent.com> <a7f16d6b-217e-400e-812a-528493d45134@kernel.org>
In-Reply-To: <a7f16d6b-217e-400e-812a-528493d45134@kernel.org>
From: Kairui Song <ryncsn@gmail.com>
Date: Fri, 28 Aug 2026 01:35:58 +0800
X-Gm-Features: AcwNN1VEQiDmkFeAKmco0RotUE5B_rZNwsXG2Mgge4ASxKJzjjIY7BucqenQtDk
Message-ID: <CAMgjq7Ay3T6BRJ2E1kGD7BNq=4bMMOpw_EKOskM-9im_fjq-MQ@mail.gmail.com>
Subject: Re: [PATCH v3 08/18] mm/huge_memory: move unmap and remap into the
 split helpers
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Chris Li <chrisl@kernel.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>, 
	Youngjun Park <youngjun.park@lge.com>, Shivam Kalra <shivamkalra98@zohomail.in>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 9774D20005
X-Stat-Signature: fthpsmehrh6jd4udywyrbrk85q6npo7n
X-HE-Tag: 1787852196-693533
X-HE-Meta: U2FsdGVkX1+0ARQI7oRyk3AI0pC0aEeuXLY/L72Q3ycBCx1zJhjTcAnUloHP7UF9uh/AEnNKZekPa83z5ht+JR9ODA0LYX3Yz3fZnxSt8BdDodR53qiwO3Gk/YOrn7/RsC8hKJcCu6/zARIgzWktmpZiMkwgjnnlG68yYevFf0+PXLCyuko644TV19GQs3EHxooNF8bDpSN6H9YE4rpTqmsR8OPRBi6pdOLfJCY+yFoxwJc1NkIWTqjooANttOXS8TYa/g8WsjKdOMM7NFHq6n1r8saMCldTkCdGGs07cfyKYxX4jn4K1y5lu8iFdIuQmzzZDS5fMMwbqUcY/KLX/raTddn5mkIOBx7SA492XD91/yrdal23M0Zp4xyymPwqsRD7YMENgrOyGOD92wq9NI/ipMoDI3I1X/bPL+QZzIF3LpbOC9oflqghTax4M9X8K0QS8I4zwYKsxfBvX6eu+g1hP7aiGYyz4DGC8i7ogca0mavZl/r3vdsKBFGw1bcx5e1n4C6QXhMrZ8KuIHrHDCb/H8OB3cqC42ywbh5hMOPfCJqYi1SyQAF0IUdUVudSvfqPjx/r69NWutYQ5FLHS987EECzF/ha9WuvgVN6vG313oI1oinOjTWo9zx8//4bMVS6nl756PjhxJzXQOQHHe5JpA3cZh4UgnuqZUcBBdZC245m2amEBOKnTryfj0x1xruI6uIH+9j8jPk1WkjCJ2T7ghGz2CSN1Zpiprr5LiEnFPV3CFC4t5LHhCtzn58s/Z0cv0IDMjxMWugJ+1cal0ECJr9HlMnifCV2MFBrnzoIpgyWPMZesIPtgZ0Js1xmGjAEM7z/APHwejS7PwpXXNsKFLJKsJqU+y0KU4r3b6jQZ0Ua5Rcuvg/xneCJef3s10cFrYlXGdsO9bH/saulx3HTHlQ1Jp97xkvoViK5VnBvu3qTo7NfvsmIM7SvgzmUnPxIZnYt+jvL1AjEYC0
 vJvc2tSo
 a3fQcS+a6hzCjpB+N8VG/mFx4dhBDk7G1fQYyZBdisOqV2PbBO1BLuRd18tDQYkoF1Jf5Bxe+C2zWBJK4YphjbZon1m3kfoRo5Dz3XAkGSC1DCjzrdf6oEpYQ6mcu3sOsIAuge2vqq94WV+MAgHDSIN/jRnxLmSvbpyoXgx3my79P0+POIpGVrkCeR4QpTmQZjk0Kypsd1/3TfrsZrsxntZr5+6EDs9XHjqqWz+PPnbevF4AfPPNyIKQt3Lw2B5MlWwXH13gahX0Zm6bUnrZqVx6qot4IBKdi0S6FL7NcBCbJqPv6CmSoOjB2ZG4yDVNbjKznOd/4vuy+GvZo84ZCs70l/NL3+gh73n93KTr0JvBzIdwdVpAaC9m0hF3HGjst3RcuDh/6q03RmsZ95XPcUh3xNv2JWxaGxjsxfV1NOLh1RsfIgJ2xErmtmdXfyE4cdXbtXr329qv73wdk7jpjYIM4InXFEbjagPLhsiMcT++ylVULaoueCnnfmeWgiEgyB8f2kRImaGvlOZg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 28, 2026 at 12:32=E2=80=AFAM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 8/20/26 20:55, Kairui Song via B4 Relay wrote:
> > From: Kairui Song <kasong@tencent.com>
> >
> > To prepare for further cleanup, move the unmap/remap handling from
> > __folio_split() into the split helpers.  Only anon folios need to
> > be remapped, so remap_page() is now only called for anon splits and
> > the anon check in remap_page() is redundant and can be removed.
>
> I can understand why we would want to move the remap_page().
>
> But why the unmap_folio()?
>
> >
> > Reviewed-by: Zi Yan <ziy@nvidia.com>
> > Signed-off-by: Kairui Song <kasong@tencent.com>
> > ---
> >  mm/huge_memory.c | 58 ++++++++++++++++++++++++++++++------------------=
--------
> >  1 file changed, 31 insertions(+), 27 deletions(-)
> >
> > diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> > index 01c8cf428595..af9c2edd1fba 100644
> > --- a/mm/huge_memory.c
> > +++ b/mm/huge_memory.c
> > @@ -3589,9 +3589,6 @@ static void remap_page(struct folio *folio, unsig=
ned long nr, int flags)
> >  {
> >       int i =3D 0;
> >
> > -     /* If unmap_folio() uses try_to_migrate() on file, remove this ch=
eck */
> > -     if (!folio_test_anon(folio))
> > -             return;
> >       for (;;) {
> >               remove_migration_ptes(folio, folio, TTU_RMAP_LOCKED | fla=
gs);
> >               i +=3D folio_nr_pages(folio);
>
> I think we should rename that function now to unmap_folio, but likely bet=
ter
> unmap_anon_folio().
>
> > @@ -3933,19 +3930,23 @@ static unsigned int folio_cache_ref_count(const=
 struct folio *folio)
> >       return folio_nr_pages(folio);
> >  }
> >
> > -static int __folio_freeze_split_unmapped_anon(struct folio *folio, uns=
igned int new_order,
> > -                                           struct page *split_at, bool=
 do_lru,
> > -                                           struct list_head *list, enu=
m split_type split_type)
> > +static int __folio_split_unmap_and_freeze_anon(struct folio *folio, un=
signed int new_order,
> > +                                            struct page *split_at, boo=
l do_lru, bool unmap,
> > +                                            struct list_head *list, en=
um split_type split_type)
> >  {
> >       struct folio *end_folio =3D folio_next(folio);
> >       struct swap_cluster_info *ci =3D NULL;
> >       struct folio *new_folio, *next;
> >       int old_order =3D folio_order(folio);
> > +     enum ttu_flags ttu_flags =3D 0;
> >       struct list_lru_one *lru;
> >       struct lruvec *lruvec;
> >       bool dequeue_deferred;
> >       int ret =3D 0;
> >
> > +     if (unmap)
> > +             unmap_folio(folio);
>
> I really hate that "bool unmap" parameter.
>
> folio_split_unmapped() has this VM_WARN_ON_ONCE_FOLIO(folio_mapped(folio)=
, folio);
>
> So you can really just do
>
> if (folio_mapped())
>         unmap_folio(folio);
>
> Or have an early exit and hide it in unmap_folio().

The only special case here is device private memory, from folio_split_unmap=
ped.

Maybe I can just keep the unmap_folfio where it is, but
__folio_split_unmap_and_freeze_anon need to know if the folio need to
be remapped.

Will a "bool remap" parameter look good?

