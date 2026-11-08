Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3799F606A31C
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 22:15:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jNOAjJAU
Received: by kanga.kvack.org (Postfix)
	id 9F2076B05B0; Sun,  8 Nov 2026 17:15:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A3D06B05B1; Sun,  8 Nov 2026 17:15:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 86D336B05B2; Sun,  8 Nov 2026 17:15:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4DAFA6B05B0
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 17:15:07 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 982021C3DBA
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 22:15:06 +0000 (UTC)
X-FDA: 85413358212.07.AD18D01
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id B0CAA2000A
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 22:15:04 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jNOAjJAU;
	spf=pass (imf03.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794176104;
	b=PUack39dQ9iUvZTMgIXDtxH7mOwz1YBu42aoKkjPxSsmUj/4vBXfRl1yDyBtpitBz2yMSA
	M4jYv+9OfEE/U6Pb261Ys9JSch0ZWa/S++DvaoPIzJClZ5vZoXX4MrqtKyUfuXU5fFMmZa
	kQyjIlQwRio9Qy7nKg0CmvG5zd5OMeM=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jNOAjJAU;
	spf=pass (imf03.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794176104;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dYkSOS7lW77R25JXZ1I8J7Ye6eXp2ev/AWCnfjt0ivY=;
	b=eMX5Mvb7njqVcBE3shgN6weEvkS4/lTAeyuLT9adF9uL4TSlT1GYpb8EY9ax4Ocwy1LSwc
	KP0ugt2HwcLlF+EY8A05KGpAGgeG2Tx6ysG5Uf7JjRtbea8QdRXWm18x26hsuPZiFkw8SP
	Our+xg5xnRBN0rp+SVBNmJa9PR6G/ow=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 23F9444006
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 22:15:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6EF01F008A6
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 22:15:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794176102;
	bh=dYkSOS7lW77R25JXZ1I8J7Ye6eXp2ev/AWCnfjt0ivY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=jNOAjJAUB9a5aYsLRCJIKZOrkvp62x+LRh+SAJ6hq+z/ORHz60AAku0ZqnCL1nSWS
	 7VYzKUeoA57kkrXLINYL9o0nYQMBtMkVNuYbwXLsJ8nl5EUVvu4h+36JEgt4XZgi8D
	 DpPN+rSGyV5/kKS1HNQ20LjavR22Z7q7iAGmR8mjwFXg63qqkS/PwHnn8VYLwQEGmR
	 Zv9IwO18q6fTrgAqBiRwOKHoETQizGgNe2so8WecWkjjyb0zkgFj4prkS3el8iCOeF
	 0pu7ODqxBGoUedgqMMj2SfGn4jLuibGeEQ2hLPrXmvwm+6fVLRxn15vVUulCkWFUTM
	 8otq0ntBcjynw==
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-945ae2daa68so38142285a.1
        for <linux-mm@kvack.org>; Sun, 08 Nov 2026 14:15:02 -0800 (PST)
X-Gm-Message-State: APuU4Z9YiSVUDaqNnjADLv0eqd0aA2l3mLRkta39ACpLyHC+t3j1wX3i
	b4AT9K6IMmq+BIv3SoAydCW6bDqnvvYm1KHY6dLNsH82OQWJ4RyZsqs9aI9oqCjG0YJa9i1DXnk
	6mP2TeUUMevPdTHEa1GyN/pR3i4jZhPM=
X-Received: by 2002:a05:620a:458b:b0:945:c3b8:62f2 with SMTP id
 af79cd13be357-94604df4c5emr848358685a.34.1794176102003; Sun, 08 Nov 2026
 14:15:02 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261016-mglru-fg-v4-0-2106750c0bfa@tencent.com> <20261016-mglru-fg-v4-12-2106750c0bfa@tencent.com>
In-Reply-To: <20261016-mglru-fg-v4-12-2106750c0bfa@tencent.com>
From: Barry Song <baohua@kernel.org>
Date: Mon, 9 Nov 2026 06:14:50 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4y-7R07wFJTY2a8tMQ1xvG2kjuG0Q1rLjx8DOg4u3UwZA@mail.gmail.com>
X-Gm-Features: AclHuK8HmC-Mujf1pZixYM-Y1dMwxxenrB0ml0fO-vwqyERAvkVtIlGDnC9BHUE
Message-ID: <CAGsJ_4y-7R07wFJTY2a8tMQ1xvG2kjuG0Q1rLjx8DOg4u3UwZA@mail.gmail.com>
Subject: Re: [PATCH v4 12/17] mm/huge_memory: mark folio as accessed more
 accurately on split
To: kasong@tencent.com
Cc: linux-mm@kvack.org, "Liam R. Howlett" <liam@infradead.org>, SJ Park <sj@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Muchun Song <muchun.song@linux.dev>, Qi Zheng <qi.zheng@linux.dev>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Chris Li <chrisl@kernel.org>, 
	Baoquan He <baoquan.he@linux.dev>, Nico Pache <nico.pache@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>, 
	Gregory Price <gourry@gourry.net>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
	David Rientjes <rientjes@google.com>, Yu Zhao <yuzhao@google.com>, 
	Vernon Yang <vernon2gm@gmail.com>, Zicheng Wang <wangzicheng@honor.com>, 
	Chen Ridong <chenridong@xiaomi.com>, Tal Zussman <tz2294@columbia.edu>, 
	Kairui Song <ryncsn@gmail.com>, Xiang Liu <liuxiang.277@bytedance.com>, 
	Ehab Ababneh <ehab.ababneh@intel.com>, zhaozhengzhuo <zhaozhengzhuo@uniontech.com>, 
	Lian Wang <lianux.mm@gmail.com>, Kunwu Chan <kunwu.chan@gmail.com>, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org, damon@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 1kcixxk8iax6y8gi8cqkr57g9fn4fj99
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B0CAA2000A
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794176104-478217
X-HE-Meta: U2FsdGVkX19wru/qTBoFp+/5BpoH6sd6v5r4XuigWw600qvD+8phKwZ1I84j348ljvHlUzm0wMMfJhisf/YGHk5gtU+aVqJsTsocHzQAzDF4lp3zY0d4BOhGPksSNuGSzZT7k/pR4BDs3Gc/ZQ0/S1EETLpW4FFF8nRGfQ1R0Vor6Bsa9XQMpTu2MMuZLdq1Qz+9fYPh9zKEFKprOz4SioJZ89AqUVakYmTySagByXl2il2czSzKIH+lEQtFjXDTxYtS/uHdvWSabERXHcjuB8obdvM/X4YoHvXkU4R5/wkXAsq3tMYGADg02N8D2Ua9j8DJ+wVN3z8wZ5id3eVY14oj9rROvX67nvMz5dyJgawKrDRMSvch9NcHZEud2w7GpUjoPTBHMNu73AOnMsoxc3Z+N7vAxrOav/FNQpXijzyBtD41wHNrwikcxpdDUOykGrlXkptYKKAOBXTdnojiUrjnetGLc6m27WuMGRvq4N+tDA9HFe3jkYNILNFcejphSaiNi2owstNUrEF+fPu1IBoSxQP8rUiZ7Y3Fc4qeYE/OHKBwziEgi/itfu3XgU6kRC/2PIURYkwYrv2Ynms1ZQa7w7695iGJIq6ViOO9m28QD1A+HHCXzhjg2c/3UTCwxYn1/6iqBsnV9/It0dikvhizKjgdd/bJx7N4WBBFwtpVkfUaC3zi9epfOQZur7ii21BM8vbtHO8hixUS0W7kpY7jd/mZ/DveECxd6EN5z50ImS/WLOIcQb3s3kKAZd0IvvBFtgIdsyt0dn+9Tt4YEf1ByOmkWmrN2eynmpVlw2fKpUl4YPa2L5CLw16Dy6rCDgCTiS3WgAeC4gOuLfIpPtLXaE9JOec7u9wM1D0LZXqZvvIbeKUs6dTL8GLpuZY4NwesCmqF+5DvSNRhbSLgSNMcPKnHmPOiYHDO9wxftGvzSwBrggOWhg6Mlg5zGlZQE4te6Jz7uIcekcNRf/l
 /Hq1l6WA
 LrvEX+zKfJ6a4301wedFh7NkS2A/2QWFPBquX1oDkBkO2BzGS0uJB5Q4rNOH1v5GkCMeBezJkdInLUjAFKfEB2syNq1LOjJfiTycIlvuLLlU7wOmmsB8iz7pKP5D5xKRalKlKwly/tgr/wxC7uhbMxNwNNQN/WS9Rwn6St9JpYB/VlP8zsG1WqnnU4VW1/xGJyF/uV6yUWTg5+PCf+slmYrdb+zZ1uRyIBcoaV8b3tctLveHSDAOvOhfuBIfbXsfFJRX/L45kb3dOPGw+jxHl16gmrz+FOF+ay0P4P5WubgUVVJcqiGvxzkpYdQn9y3OqHO5nrCTxlNSj4MsCHRnKTREmGQa9tNS3BaxbUM0iH/tmceEjt/4FvSIHLctLKupGXtvBJp29F9wU0LqzcXa9nnjEWZGU2ZVlY/ct80lY5AWR6jbsuJHlBfGRx8HVgBSgtNK+NWfzkDm5iySDBAER7ECpjaTWLYcwRQ1q3RRItHOVPs369+Xfk3w+Dtz7G7da32Ym7i1PlvrewfeAt1hPpzfXgBS3IE0G5Vdf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Oct 16, 2026 at 2:16=E2=80=AFAM Kairui Song via B4 Relay
<devnull+kasong.tencent.com@kernel.org> wrote:
>
> From: Kairui Song <kasong@tencent.com>
>
> The behavior of updating the folio's access info isn't consistent for
> huge mapping splitting or ordinary unmapping. The page table's young
> flag has to be translated into folio's access info.
>
> Right now it only check and set folio's referenced flag, which isn't
> enough since folio flags update on access have its rules. Ordinary
> unmapping (zapping) calls folio_mark_accessed(), and it also checks
> if the VMA has recency to avoid false updates.

This might be a bit off-topic, but I once proposed
recency fading for the zapping case in Android workloads:

https://lore.kernel.org/linux-mm/20250514070820.51793-1-21cnbao@gmail.com/

folio_mark_accessed() might not be ideal for Android
apps that are being killed, as we expect them to be
relaunched only after a long period of time.

But for the splitting case, I guess there is no doubt
that the accessed state should be set.

>
> So first just use the right helper here to be more consistent.
>
> Tested-by: zhaozhengzhuo <zhaozhengzhuo@uniontech.com>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  mm/huge_memory.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index bd44d58e8684..1e2b6448c010 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -3093,8 +3093,8 @@ static void __split_huge_pud_locked(struct vm_area_=
struct *vma, pud_t *pud,
>
>         if (!folio_test_dirty(folio) && pud_dirty(old_pud))
>                 folio_mark_dirty(folio);
> -       if (!folio_test_referenced(folio) && pud_young(old_pud))
> -               folio_set_referenced(folio);
> +       if (pud_young(old_pud) && vma_has_recency(vma))
> +               folio_mark_accessed(folio);
>         folio_remove_rmap_pud(folio, page, vma);
>         add_mm_counter(vma->vm_mm, mm_counter_file(folio),
>                 -HPAGE_PUD_NR);
> @@ -3216,8 +3216,8 @@ static void __split_huge_pmd_locked(struct vm_area_=
struct *vma, pmd_t *pmd,
>                         folio =3D page_folio(page);
>                         if (!folio_test_dirty(folio) && pmd_dirty(old_pmd=
))
>                                 folio_mark_dirty(folio);
> -                       if (!folio_test_referenced(folio) && pmd_young(ol=
d_pmd))
> -                               folio_set_referenced(folio);
> +                       if (pmd_young(old_pmd) && vma_has_recency(vma))
> +                               folio_mark_accessed(folio);

We now have two inc_refs paths:

- folio_inc_lru_refs_walk() for mapped folios;
- folio_inc_lru_refs() for syscall accesses, or possibly
  mapped folios with the appropriate flags such as
  LRU_REF_MAPPED, LRU_REF_EXEC, LRU_REF_FORCE, etc.

The interface is:

void folio_inc_lru_refs(struct folio *folio, unsigned int flags);

Here we call folio_mark_accessed(folio), which is the
syscall path with flags =3D 0:

folio_inc_lru_refs(folio, 0);

Are we somehow applying the syscall access policy to
folios accessed through the page table?

This seems a bit strange to me, no?

>                         folio_remove_rmap_pmd(folio, page, vma);
>                         add_mm_counter(mm, mm_counter_file(folio), -HPAGE=
_PMD_NR);
>                         folio_put(folio);
>
> --
> 2.56.0

Thanks,
Barry

