Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31753CA1013
	for <linux-mm@archiver.kernel.org>; Sat,  6 Sep 2025 01:52:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4CFD48E0002; Fri,  5 Sep 2025 21:52:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 458478E0001; Fri,  5 Sep 2025 21:52:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F8EF8E0002; Fri,  5 Sep 2025 21:52:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1810F8E0001
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 21:52:12 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CD9721DE1DA
	for <linux-mm@kvack.org>; Sat,  6 Sep 2025 01:52:11 +0000 (UTC)
X-FDA: 83857150062.01.616E4BE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id CA9DD10000A
	for <linux-mm@kvack.org>; Sat,  6 Sep 2025 01:52:09 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=estJMMTy;
	spf=pass (imf05.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757123530; a=rsa-sha256;
	cv=none;
	b=5Zjti9fvPkIOc26xxOsyGs6Rq40LECDSwv0iifu6mTlGLWVY63DzW9BKbmLN2Q5ws8fSEH
	iin6zh+Ec/CQ6ojT2d1jImPnbPBUM/sh6DijrknA6OrNqr/Iwis5Y31XS4OTNf/zMdZ9Mp
	pTRJ3XjQXXea23veSjnkTnuFwP5P+Z8=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=estJMMTy;
	spf=pass (imf05.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757123530;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kksIHaHTSRrQSxRWLRJbxJG6eVjGex85haxM3kWr4qs=;
	b=TuEcoOogFa7bDM8ZxYZlc9qmnh01ni6VD7CNaGo5mWCuHflxoDbVIMuclopZ1whgyrL4jl
	pDJHoL1M+ETlXTrNcrwMp6mgs57v214fPGR9QZjYguSI4/1JFMOhZeVZjA+Z+DUTwwzrSt
	ykyiijTplr3ALcttyZHNKUjsQV/vlEM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8230A44CA8
	for <linux-mm@kvack.org>; Sat,  6 Sep 2025 01:52:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57593C4CEFB
	for <linux-mm@kvack.org>; Sat,  6 Sep 2025 01:52:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757123528;
	bh=ZLbf025TbCAVDMDw7jHKU6+3GLV2AL3hEjSNyCSVYUc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=estJMMTyTXmL1nm+XsscuMIpFgsVOr3n/GrHcTm3dR23L622KfMZdYNyZUqj0TU7q
	 q8MH9tKjcA8q84vBddmA3U+INxKJw3RhZgZ99uwdXFS6iyr9W/+z4Te30IdSMV+X5T
	 n7T+91najnbQuYqoy1rYeJjbMtyhVfDiFawWHxc/J/cFabsVRaxMPhp/CpIdAqSHzf
	 kVeVzbWdUnOvuic9jziQwWFOj9puVuqOroYwxLmZlkkomuKRSArnxQorETHUmTn1yB
	 SqqRmGmPQ8tO1OvnKovcDp/HhFicaqGAhtkHK1uDW4pAF4GLCz/UaSlIWhO5X2JsW0
	 rMwxq4mKoiryA==
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-45b886f92ccso37325e9.0
        for <linux-mm@kvack.org>; Fri, 05 Sep 2025 18:52:08 -0700 (PDT)
X-Gm-Message-State: AOJu0YxwTlwHb8MghsYGloGXVnmUbKY/xI72m4qOeK78vmLWq5umZMij
	gr1tuM6lc39aXBP/PMFqPhwZM/N18LDzEhFszw6uYqbuzFJy0ErL2gb1Ww/BYsOPHRFFBYX4H04
	yKWNwc9Gf9jIx/jQhRkoCH8WCYy6PGD7nVojPwDIb
X-Google-Smtp-Source: AGHT+IGjhaMGuFmKSOq65rNSbqau2mH4/CE4IKPEkkUp0bWy0sfHbOKtsF7sr8Su4snCzHDeblXqp/kDF3PezcaZFSo=
X-Received: by 2002:a05:600c:a406:b0:45b:74f7:9d30 with SMTP id
 5b1f17b1804b1-45dde17196dmr303035e9.1.1757123527039; Fri, 05 Sep 2025
 18:52:07 -0700 (PDT)
MIME-Version: 1.0
References: <20250905191357.78298-1-ryncsn@gmail.com> <20250905191357.78298-4-ryncsn@gmail.com>
In-Reply-To: <20250905191357.78298-4-ryncsn@gmail.com>
From: Chris Li <chrisl@kernel.org>
Date: Fri, 5 Sep 2025 18:51:55 -0700
X-Gmail-Original-Message-ID: <CAF8kJuNhLDovRO+8Y25ArdMBVFjXnYBVjmASzMBtdsdZkQ0NLQ@mail.gmail.com>
X-Gm-Features: Ac12FXyor9jYrHazaQfXv_bf0RLrytfgAReOG_V6sM-QISnVMBGJCjjC0Py78a8
Message-ID: <CAF8kJuNhLDovRO+8Y25ArdMBVFjXnYBVjmASzMBtdsdZkQ0NLQ@mail.gmail.com>
Subject: Re: [PATCH v2 03/15] mm, swap: fix swap cahe index error when
 retrying reclaim
To: Kairui Song <kasong@tencent.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Matthew Wilcox <willy@infradead.org>, Hugh Dickins <hughd@google.com>, Barry Song <baohua@kernel.org>, 
	Baoquan He <bhe@redhat.com>, Nhat Pham <nphamcs@gmail.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@redhat.com>, Yosry Ahmed <yosryahmed@google.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: CA9DD10000A
X-Stat-Signature: jf9dxyuamh3ip9tctraurgtacksn3nj6
X-Rspam-User: 
X-HE-Tag: 1757123529-732057
X-HE-Meta: U2FsdGVkX1+ap8IZudVv6QVIPIXCHs1g0G7EOoV8YGn3jcKYFsqmllQw5HQztXcmTJdKyM4aGEo5Ss+c783V0YKLKXCJRIM0TlO+k10Dy2X58Andwhtpxi8c70ck65X8YlQdIgWK+056WIGU/trEsFP50r/KgxHWyG3rpgMpZgKKieQ0qrAVWuyewZFHjr9qBc+09G+qNy6+NHO+eZx6pJrUA0vJd1Ha0N2+CqPTR4GfKaOeDCR3GHnEu3DhEb2ai0wZPcck2B9R6JLBMnB5CaonG5KgaHDanLWcmaPmGiXu7WzD/QU1SG+/Jhyfzmbl0/C3rWRzLnyHth87vYCqckJKo7P9nlXfMWqcjyzE+qGaRSAwKHGOHHZXvIezvGR5oO6mVmy9N0qqtHq+Hw68us5TtMKA8djA10YY9kMtdTJDtY9VhFr45qbDrUbxWWY/qru8meyoS/2nD4IGGCh8dkj68Z7SJILLV7BoURpHYqkMu3sfh9lgkFiBy4MeuyBI4YHYwmqhk8QDhnuuhtCtv3yLOv3JZYSflz9URjvDRWvENeP8uS0vAPDV9PsoP7+q5k3FIva/goLSbaWybtzfbhoU+n27Y0i7/d7lPwctuXmn4JTPpAvKxvT0GpRkJQCm/hBfEezeW7t8f6NlzWUvueAsmnCUCj0/NI2/6lsMLdn8c+hdIhWSQuZTE7A0zGqius5t79fG2eW9713g8uRZlEtP0tJMTCh0IjuoH0oDWOPFA52JAjUH3SOpB5qJe5QEtRDD80xdhcoqKMbhFhCiCPVaWS8CTHDNiVbp+BW1VZoBny/aIkA2mHTsVo4kbZluE1Jq+O4ME2PXije63BY4g5VnVx4+IsG/EASc1BbWG2hSqsypFHTghRo1FGtrUjvqQKUawe0xsBPtwE6kqxHUZKdAKXA53wN1rnKuTHldrOl+uJH6Plbmca0HVS3B8MyCMxfdgqdueRI0yoF4+7s
 3xk/+8aX
 3OVt/JKWxq53V6d94YAQJjBH/bqd2novUv+A5P883CugRmDv/ZQPF2vaDlA84i7ZtUMY9GunXFQ18YD45l0QCdx1iv5QPR/FSvlO0iX58pLZ6E5nFKkznL5NFemyCkgvdrvi9NDwQytAg0O5Wjlj3KQ5q+lgXB5nZz1xbZqZSjWrkclDHy3g2CPNRGXWHcQd2BERbGBh1xea/CmYIjDWZIyUaPZdK8r22dqUVg0E58nJZLMPqJlwu3uTENXkCr4AUTVRu8GRAuYzKt5jk9izYGTPVIe53V/0Y66Vq/eGlI6eB/RTF4c3RO6TOoU4PAjDZE/ciMUJLraDp9RnsSEIGHJWQn0JQ0le60cPBjIOxX3PCHys=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Kairui,

The patch looks obviously correct to me with some very minor nitpicks follo=
wing.

Acked-by: Chris Li <chrisl@kernel.org>

On Fri, Sep 5, 2025 at 12:14=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wrot=
e:
>
> From: Kairui Song <kasong@tencent.com>
>
> The allocator will reclaim cached slots while scanning. Currently, it
> will try again if the reclaim found a folio that is already removed from
> the swap cache due to a race. But the following lookup will be using the
> wrong index. It won't cause any OOB issue since the swap cache index is
> truncated upon lookup, but it may lead to reclaiming of an irrelevant
> folio.
>
> This should not cause a measurable issue, but we should fix it.
>
> Fixes: fae8595505313 ("mm, swap: avoid reclaiming irrelevant swap cache")
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  mm/swapfile.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 4b8ab2cb49ca..4c63fc62f4cb 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -240,13 +240,13 @@ static int __try_to_reclaim_swap(struct swap_info_s=
truct *si,
>          * Offset could point to the middle of a large folio, or folio
>          * may no longer point to the expected offset before it's locked.
>          */
> -       entry =3D folio->swap;
Nitpick:
This and the following reuse the folio->swap dereference and
swp_offset() many times.
You can use some local variables to cache the value into a register
and less function calls. I haven't looked into if the compiler will do
the same expression elimination on this, a good compiler should. The
following looks less busy and doesn't need the compiler to optimize it
for you.

           fe =3D folio->swap;
           eoffset =3D swp_offset(fe);
           if (offset < eoffset ) || offset >=3D eoffset + nr_pages) {
...
           }
           offset =3D eoffset;

This might generate better code due to less function code. If the
compiler does the perfect jobs the original code can generate the same
optimized code as well.

> -       if (offset < swp_offset(entry) || offset >=3D swp_offset(entry) +=
 nr_pages) {
> +       if (offset < swp_offset(folio->swap) ||
> +           offset >=3D swp_offset(folio->swap) + nr_pages) {
>                 folio_unlock(folio);
>                 folio_put(folio);
>                 goto again;
>         }
> -       offset =3D swp_offset(entry);
> +       offset =3D swp_offset(folio->swap);

So the first entry is only assigned once in the function and never changed?

You can use const to declare it.

Chris

>
>         need_reclaim =3D ((flags & TTRS_ANYWAY) ||
>                         ((flags & TTRS_UNMAPPED) && !folio_mapped(folio))=
 ||
> --
> 2.51.0
>
>

