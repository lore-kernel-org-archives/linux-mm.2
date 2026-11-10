Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9C3460A3801
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 22:14:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IRuV1PXO
Received: by kanga.kvack.org (Postfix)
	id DBC816B00EF; Tue, 10 Nov 2026 17:14:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D6DBC6B05B1; Tue, 10 Nov 2026 17:14:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C5C5E6B05B3; Tue, 10 Nov 2026 17:14:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9A04F6B00EF
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 17:14:03 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 007DA4015D
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 22:14:02 +0000 (UTC)
X-FDA: 85420613166.04.7AA656E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 4C58D16000C
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 22:14:01 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IRuV1PXO;
	spf=pass (imf08.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794348841;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e2X8uGGa3LpVnubquZfEmJKCkFh5N6hopn2fqIaDT1w=;
	b=df4tc3zS+edIY4UwtsCgPtaDAL10zQ1RRgAqeTAQ5NWg0PgGnOnuJLDFu4/djMRyJL760h
	xnlYm9zwMlieWHAPqYcX45CWkXpGVid8ZrhTNlRnC2CC0eIZPho/pTlzYyLlmD/u+qnsJY
	/ay37MQVbI8q0jTI73L0DdLYkzyJWVw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794348841;
	b=hBgfNlbIuC+igz4vfyb7vj9ZmL4u3P1XpVC8Q6CrogwBjbK8TjunVslziyejll9B5tCy6w
	OHGuNjSZXMvEnPxpi0EsiSvAPuBSLE7sy/PuSbx2fFacyva29kSoMvHipW83umFtN9H97Y
	zWragP7Q1C0uzRwemdjjYsoc95I7FqY=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IRuV1PXO;
	spf=pass (imf08.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7484140E42;
	Tue, 10 Nov 2026 22:14:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72F6F1F008A4;
	Tue, 10 Nov 2026 22:13:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794348840;
	bh=e2X8uGGa3LpVnubquZfEmJKCkFh5N6hopn2fqIaDT1w=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=IRuV1PXO21yfhWNI9uNeSKcsJY9bvDdneo5t5f1cIh7jtt9bWlhyrgjWRU/qtgfAJ
	 vnaKT+nVUh8QFlNiptj2yE5UN+uK2T+zfKzpJHudmRgveaP/ty33UdChn9+SFX/cT1
	 rCz2YviWAXmXF14DrqeC/ytoBiXZ5sJeWjtqjj9ZHbRCCB/z9Ah3/9qywjaCJcmbyf
	 WRnOaYIjK5gtUE8bsBijXfQV3IfmA7FOFlWSR4Pa3dsh+L+PxQJ9RqMabws32eyO7h
	 ivAimgaQkXPMV8KZPNfh6GfrrZW9TFfVPiWppZOx0Cb++yDtadCvwiaULiOPHXu36T
	 Vym7Bjh8G3jsQ==
Message-ID: <sashiko-outbox-207814@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v1] mm/rmap: fix migration entries being treated as
 partial unmaps
Reply-To: sashiko-reviews@lists.linux.dev
To: "Joanne Koong" <joannelkoong@gmail.com>, "Andrew Morton" <akpm@linux-foundation.org>, "David
 Hildenbrand" <david@kernel.org>
Cc: "Kiryl Shutsemau" <kas@kernel.org>, "Usama Arif" <usama.arif@linux.dev>, "Barry
 Song" <baohua@kernel.org>, "Lance Yang" <lance.yang@linux.dev>, "Lorenzo
 Stoakes" <ljs@kernel.org>, "Rik van Riel" <riel@surriel.com>, "Liam R .
 Howlett" <liam@infradead.org>, "Vlastimil Babka" <vbabka@kernel.org>, "Harry
 Yoo" <harry@kernel.org>, "Jann Horn" <jannh@google.com>, "Zi Yan" <ziy@nvidia.com>, "SJ
 Park" <sj@kernel.org>, "Johannes Weiner" <hannes@cmpxchg.org>, linux-mm@kvack.org
In-Reply-To: <20261109220958.2071687-1-joannelkoong@gmail.com>
References: <20261109220958.2071687-1-joannelkoong@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 10 Nov 2026 22:13:58 +0000
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 4C58D16000C
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: 8erjpfops8o966qng3bjwh8dc1m643z5
X-Rspam-User: 
X-HE-Tag: 1794348841-689767
X-HE-Meta: U2FsdGVkX19DIj0zSnXif9h5n6jpBbfujA+qx+acmQjVQUVXJ4USl8sghdSf0DnrU0wAhsPMHH667lnLQYRTTSRb0/4KcJa0VI+Wb11NhBdbVNWvD4nlxVmmvebQzukPHtSOSUT1fY3eT/hsahbfJbNQKBaWfxVK7ts7EfcirnbbGgkkW9KuOvuJvoDZdwVf1yjvVsAGcvr/kNXG4EfMSQ/0nJOYCyTb6RyNwimg/l/k12HwFv3FKmaVOvs60MG/87Iq9a01fxwnd9SVbkUBS4yWIMNV6hF+yP4897KGIuNCHqGURCWVvkbajm55n2Z+lPfJBM07g5hNWOxgqHC1TCkc1OMYYOmzP+7a9B1kUQ/krGaVbx9ZsMjZIQICGft194I7Osaa4j223in/Mk04foPeqzzHP6WZtvzbv5h+fgmZQnC/2piUZs6FPuUyNbg+dAbxL1HqSkv9OAxvNTUfAFDe81MHbZpMiy8aQ9zoSJ6S9df8uDpPvsOeg3lGayDyfbb1WSmZiiTu/0v1DIJ1YOs49rhti0i2tod0powIVToJ89rCxT91R88frb5mzg/hkqPM9XCu88rvISJQpVsZk6+tpUVV5wGVz0ji3gDd6cSN4hwjk3gb+cfySaE7c4/0zPsOJmPSUAwl5jXdr6UxjsJzKPKG+k8R53KQ2lMGrjojxO8e4Rx946hgiUhYNiQlSDNod2i2GHas2yqIMMjYNvZ9fp2edgCseHOky01RzejEjOP28t+otLc6OyuD5nJ0h4gE//rKfs/6O4CcEHHBSgJtk5A9QgH+n2n3Q8ln2a3nQKz/l8Ah5ckX4EgPTfcwIfd5f/SY+G0IwBnGmML7CO6//d5RoccJ68T2HHf/nIaifuDXsxf65Rls7Zwmr2/yJmNf7aQj8A5kNMTE3x/RutuCzKXIUrd2mdkfh7eonwBz+YFy2MzrtL+mfPDwa3euN2Fgz0wIjZjtmXWqivj
 XHg1VEYT
 7cePU9GKo7H23tAmylGWT360itNBr8YPsdgSTJZGOiCFF9vYsRJCGpflDZRWnC6VL0maa5BzCbSxkbIuj+m8Heu6XABF3flssW+dDVx8LcsIR+fGaQHEaEK/uUuvPWXzxrBTI3Noo4yu2vNifNSFmSTx8LSAcz9eJ5CVxR4Uo+Q8IM2gdiP1xp4zBd5JSSwK8C7FchYt5tpDzCGmBixDh7F5NrZI8T5DWuQsizEY4RScBXPEJns8TncF04Ox7B7K6/ekmHFidgFBi2YvOupwM1k0H5R0AszIh/6QQV9JL1TWWEFhhWb1D+VtzqXxP+67uEHkD/sQpjD5Tw0VzKh0DiX84AFltH+e8l0Of06XSUhUHCyUVGgcRUJhtUs2nJqE89XwJ3TtFh4RLc7zFXEdC9wHfZDInTqzaECUd2Hu53VTT8qMtEKS/87bgtvRD2Y1Le+Eb437NmaE53yBUAdLYXLlkT0oYRwpKeBlm05E3hqf56xXJg06F+QoeXN0Q+txzDJ2gkY44uTgPjHjCsuSujksVH4sQIZRnGBOsMe/1A09PlLhd+XjyzmeJXTtto2kd+MP72BQAcMpv1lFhRi8fHGazcg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential
issues to consider:
- [Medium] mm/rmap: PMD migration entries still queue folios for
  deferred split
- [Low] mm/rmap: try_to_migrate_one() misses deferred split on last PTE
  unmap
--

commit 685cbbfa9eaed572b053e5452f3d93b8fec2771b
Author: Joanne Koong <joannelkoong@gmail.com>

mm/rmap: fix migration entries being treated as partial unmaps

This commit adds a may_defer_split parameter to __folio_remove_rmap() and
passes false from try_to_migrate_one() when installing PTE migration
entries, preventing temporary migration entries from queueing anonymous
large folios for deferred splitting.

> diff --git a/mm/rmap.c b/mm/rmap.c
> index fa34e1ccbd8f2..e5d17481c0c01 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
[ ... ]
> @@ -1938,7 +1943,8 @@ void folio_remove_rmap_pmd(struct folio *folio, str=
uct page *page,
>  		struct vm_area_struct *vma)
>  {
>  #ifdef CONFIG_TRANSPARENT_HUGEPAGE
> -	__folio_remove_rmap(folio, page, HPAGE_PMD_NR, vma, PGTABLE_LEVEL_PMD);
> +	__folio_remove_rmap(folio, page, HPAGE_PMD_NR, vma, PGTABLE_LEVEL_PMD,
> +			    true);
>  #else
>  	WARN_ON_ONCE(true);
>  #endif

[Severity: Medium]
Can replacing a PMD mapping with migration entries still queue a fully
mapped folio for deferred split?

When try_to_migrate_one() replaces a PMD via set_pmd_migration_entry() or
split_huge_pmd_locked(..., true) -> __split_huge_pmd_locked(), both paths
call folio_remove_rmap_pmd(), which unconditionally passes
may_defer_split =3D true to __folio_remove_rmap().

If the folio is PMD-mapped in a parent process after fork() and the child
has unmapped or CoW-faulted one subpage so its VMA holds 511 PTE mappings,
removing the parent's PMD rmap sees 0 < nr < nr_pmdmapped (or
last && nr < folio_large_nr_pages(folio) under CONFIG_NO_PAGE_MAPCOUNT)
and calls deferred_split_folio(folio, true).  migrate_folio_move() then
propagates PG_partially_mapped to the destination folio, causing the
shrinker to split the migrated THP even though all 512 pages remain mapped
in the parent.

[ ... ]
> @@ -2516,6 +2523,8 @@ static bool try_to_migrate_one(struct folio *folio,=
 struct vm_area_struct *vma,
>  	mmu_notifier_invalidate_range_start(&range);
> =20
>  	while (page_vma_mapped_walk(&pvmw)) {
> +		bool may_defer_split =3D true;
> +
>  		/* PMD-mapped THP migration entry */
>  		if (!pvmw.pte) {
>  			__maybe_unused unsigned long pfn;
> @@ -2772,12 +2781,20 @@ static bool try_to_migrate_one(struct folio *foli=
o, struct vm_area_struct *vma,
>  			 * No need to invalidate here it will synchronize on
>  			 * against the special swap migration pte.
>  			 */
> +
> +			/*
> +			 * The folio only looks partially unmapped while this PTE
> +			 * holds a migration entry, which is later turned back
> +			 * into a mapping. Don't queue it for deferred split.
> +			 */
> +			may_defer_split =3D false;
>  		}
> =20
>  		if (unlikely(folio_test_hugetlb(folio)))
>  			hugetlb_remove_rmap(folio);
>  		else
> -			folio_remove_rmap_pte(folio, subpage, vma);
> +			__folio_remove_rmap(folio, subpage, 1, vma,
> +					    PGTABLE_LEVEL_PTE, may_defer_split);

[Severity: Low]
Does try_to_migrate_one() miss queueing the folio for deferred split when
the last mapped PTE is unmapped via PageHWPoison(subpage) or
pte_unused(pteval)?

Each earlier PTE converted to a migration entry calls
__folio_remove_rmap() with may_defer_split =3D false, which still decrements
_nr_pages_mapped (and _large_mapcount).  When the final mapped PTE is
genuinely unmapped with may_defer_split =3D true, _nr_pages_mapped (or
_large_mapcount under CONFIG_NO_PAGE_MAPCOUNT) drops from 1 to 0, so
__folio_remove_rmap() sees the folio as completely unmapped and sets
partially_mapped =3D false.  Once remove_migration_ptes() restores the
earlier migration entries, the folio is left partially mapped without
PG_partially_mapped set or being queued on deferred_split_lru.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261109220958.2071=
687-1-joannelkoong@gmail.com?part=3D1

