Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE1F5CA5FF1
	for <linux-mm@archiver.kernel.org>; Wed,  7 Oct 2026 13:50:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E0276B0088; Wed,  7 Oct 2026 09:50:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 690D06B008C; Wed,  7 Oct 2026 09:50:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A6AF6B0092; Wed,  7 Oct 2026 09:50:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 348CF6B0088
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 09:50:33 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C7F2880239
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 13:50:32 +0000 (UTC)
X-FDA: 85295965104.27.515BB45
Received: from mta0.migadu.com (out-165.mta0.migadu.com [91.218.175.165])
	by imf27.hostedemail.com (Postfix) with ESMTP id 94EE24000D
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 13:50:30 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=KzrD+7k+;
	spf=pass (imf27.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.165 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791381031;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pGJzaicDXcFiTzhE1TXYZiRofP6B5tO3fuFEa+krkzA=;
	b=LTw9RoxEKZy7LDjPhYIv0Id/DXv4gssBjAYd7jfQYnrNbE231aRnFEcnTYyCMY4RwAF8nN
	6l8/XO2nIaWnJhf2ScjHZaoQ3txJD9JExIdFIqHcz2hFc+lEUQElXxq1VElzFvssdtrPUm
	EbS/JXM6NY+FdMy8Bmq99rwLN9xjblg=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=KzrD+7k+;
	spf=pass (imf27.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.165 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791381031;
	b=i9i2M/pm9PCDALogatQqOiJ2gJlrlIqREUyd3AOIoxTI2iLJqXdq11JowSfgosNV50xaZd
	x8jFIxTZqPwdbDirnvhsvFv9BMuuYTVhaSNBtVtAnrOUkfyXH3sFJBqpEVjtVk3675RFJ4
	smzoDzgtZT4v/vBO9HXEd9/XzHEmQUY=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=9uh3YtH2vzcWNChlP5JxXc/8qcNZiQgtmlGLwUVnUpM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791381028; v=1; x=1791985828;
 b=KzrD+7k+cGR/+ZK2b6WPEjfG25roXKg2RBwp3QeXmimK+kD8m/wD8i8eoeOy2Vv+KBeVFm4c
 mXVY/5agMvJ+Iw2/iErz4eE8fXt+ApuyazZqvr2yYXAkNMiCWD7YSJ7uLbYfeaZ8xdigpl42pMh
 6gCgA6DzU0uFdQENtgfZCrow=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 2f3032bb5f9bba28;
	Wed, 07 Oct 2026 13:50:27 +0000
X-Mizu-Trace-ID: 2f3032bb5f9bba28
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.12\))
Subject: Re: [PATCH v3] mm/hugetlb: fix max-only subpool accounting on
 alloc_hugetlb_folio failure
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260428113037.88766-2-enderaoelyther@gmail.com>
Date: Wed, 7 Oct 2026 15:50:12 +0200
Cc: Andrew Morton <akpm@linux-foundation.org>,
 mawupeng1@huawei.com,
 Oscar Salvador <osalvador@suse.de>,
 David Hildenbrand <david@kernel.org>,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <B83FA5F4-740F-4CEF-B9C2-6ED51C893A92@linux.dev>
References: <20260427145247.84157-2-enderaoelyther@gmail.com>
 <20260428030712.66256-2-enderaoelyther@gmail.com>
 <20260428113037.88766-2-enderaoelyther@gmail.com>
To: Zhao Li <enderaoelyther@gmail.com>
X-Mailer: Apple Mail (2.3901.100.1.1.12)
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 94EE24000D
X-Rspam-User: 
X-Stat-Signature: 6t35xyjwh7cufe86ud6sw841emor35iu
X-HE-Tag: 1791381030-381632
X-HE-Meta: U2FsdGVkX18AnQLpALbN45JgMFX9zdPDRZjuac0luKOv2GebsMMV5V1r6lZLW1z2XcekTWRJ4PyZ4K1ihUNeFr+WFBawixgpBoknY0GiC+Nf+yC+XClEbKIeWWsBHjE3QtTENuGpqYM3EMP0UIjWB01rMbpjQmS53AcIt/B2l8WA6Q20lcxA0B0JDoJ34ZrdWrT4eg214+yF26sk9NjpBuX5JTTCp82RjN8pSnI/8KiXXLyzQJ46yCxuSm/hDrAkVsE8q+AViFcq7/keO+c+l853465HlySnt4fu6qNP+rBYXjhvxlXp4ZXzMUacc8OV5dGfxBEklPMHENI004h9IgWZDUItjCQL7C5FqMWW6gn1a8Mks62ac4KXbsC5VjWSLjLQ/4LOn4B6qEuKsnEkZE7kfU1+/vm+rR22gTbfoisH2xkEZ2aT8L5pvYM+TmYvBCnfafKVjYvodz40K53YX82UZPTx26RSn9f9kBC/UEUSEG36d1i/1H/cDMPANTEPZz1HmsWlFE8ROk54200dzK+xWxT53H+1cHXcetEyNgqm1r1gCcyWiGbkSPh7ZzflyUGA4Ge/j3IJWYHzGSNuYHANrvoo/EThJ3t/6JUrKFv3PlQ9WwiWiVebqx63c+taErr2EJfb1EgrOnsd7ttKIZLtHHPlW8K5H1X5E7YA8+fFb04YLl0cgCEswBBYV1/3gv73DJzf34SGl5REyguLs9uXlBdAsXQUNlN1Od/llSBoaVfU5SAWOvD4JE56UxNmPErrPoqbptReAryYlKv+/h20gzZK8z2fGz9dK+uq012ECLfigZyxK+v9f9VOlBJrW8E4MJk7g/ozejInyjdi7qqyd0g8GGeTfE75680fWNgCZaAxqvR0qj/5/Cd8LDnp1rdjL0n6rYRj0shdUo83HOiyCWzxr1wFKa0VfVTxztgp2Z+YhoaFrDuyz9ZSf87KjZBsRXX6CW/7m17dZBH
 7eFS94qz
 qvMqp+xqzgTMdHlS5fd183R2ZCK4cob8smonvOS1b0aKMVeehCMl2oHzlAsYiAmgTkSOKRJHZ0tyWYL9xJb9591EVh8NyRfzB0jNCj/Fl+qC6d0oSS7IC8bzphcYB/1kCRPn0EgOoC2PIxLgmM9OZeaKOTyDfub/kuGRsKTS6fdADniTMg/cxHYDnp+awrq1xG0ixD7SYL7BVd7hPpyym+b7BO4vBGpcR5bRdlZ4dgUPSjj0RVAQi9VprXOPgNsk2fhz3KC0Pzgp8uGzfT5P7+5yG+7SKqF/jCIR+j2sTXzIKsvwPi+SVemLEMUsYyPynw9scaJw4wqe83LYMaLmfijmIUsKp/CpZwKcvFBdkxnHZ4nU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Apr 28, 2026, at 13:30, Zhao Li <enderaoelyther@gmail.com> wrote:
>=20
> alloc_hugetlb_folio() calls hugepage_subpool_get_pages() when map_chg
> is set.  For a subpool with max_hpages !=3D -1, that bumps used_hpages
> regardless of whether it returns gbl_chg =3D 0 (rsv slot consumed) or
> gbl_chg > 0 (used_hpages slot only).  If the allocation later fails
> before a folio is returned, the unwind must undo the used_hpages
> bump.  The old cleanup only ran for !gbl_chg, leaking used_hpages on
> the gbl_chg > 0 path.
>=20
> For gbl_chg > 0 on max-only subpools (max_hpages !=3D -1, min_hpages
> =3D=3D -1), hugepage_subpool_get_pages() took only a speculative
> used_hpages slot.  Drop that slot directly under spool->lock.  In
> that configuration hugepage_subpool_put_pages() cannot restore
> rsv_hpages, so the direct decrement is the exact inverse and is
> race-free against concurrent puts.  This matches the used_hpages-only
> part of hugetlb_reserve_pages()'s out_put_pages cleanup, but
> restricts it to the max-only case where no rsv_hpages restoration is
> possible.
>=20
> Mounts with min_hpages !=3D -1 are left unchanged for now.  v2's
> approach (hugepage_subpool_put_pages() + h->resv_huge_pages++ to
> back a restored rsv_hpages slot) double-counts global backing under
> concurrent free_huge_folio() and creates phantom reservations under
> concurrent hugetlb_unreserve_pages().  Safe cleanup of that quadrant
> needs a coordinated fix across multiple call sites.
>=20
> Reproduced on size=3D20M hugetlbfs with the faulting task in a hugetlb
> cgroup whose limit is exceeded.  Vanilla leaks 6/8 hugepages of
> subpool quota; this patch leaks 0/8.  Verified under QEMU.
>=20
> Fixes: a833a693a490 ("mm: hugetlb: fix incorrect fallback for =
subpool")
> Cc: stable@vger.kernel.org # v6.15+
> Signed-off-by: Zhao Li <enderaoelyther@gmail.com>
> ---
> Changes in v3:
> - Replace v2's hugepage_subpool_put_pages() + h->resv_huge_pages++ on
>  the gbl_chg > 0 branch with a direct used_hpages-- under spool->lock.
> - Restrict the cleanup to (max_hpages !=3D -1, min_hpages =3D=3D -1) =
where
>  the direct decrement is the exact inverse of the speculative bump.
>=20
> Changes in v2:
> - Skip the gbl_chg > 0 cleanup when max_hpages is unset.
> - Add hugepage_subpool_put_pages() + h->resv_huge_pages++ on the
>  gbl_chg > 0 branch.
>=20
> mm/hugetlb.c | 25 ++++++++++++++++++-------
> 1 file changed, 18 insertions(+), 7 deletions(-)
>=20
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index f24bf49be047e..cfdeaf6394c5b 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -3025,13 +3025,24 @@ struct folio *alloc_hugetlb_folio(struct =
vm_area_struct *vma,
> hugetlb_cgroup_uncharge_cgroup_rsvd(idx, pages_per_huge_page(h),
>    h_cg);
> out_subpool_put:
> - 	/*
> -	 * put page to subpool iff the quota of subpool's rsv_hpages is =
used
> -	 * during hugepage_subpool_get_pages.
> -	 */
> - 	if (map_chg && !gbl_chg) {
> - 		gbl_reserve =3D hugepage_subpool_put_pages(spool, 1);
> - 		hugetlb_acct_memory(h, -gbl_reserve);
> + 	if (map_chg) {
> + 		if (!gbl_chg) {
> + 			/* Full inverse when subpool_get_pages() =
consumed rsv_hpages. */
> + 			gbl_reserve =3D =
hugepage_subpool_put_pages(spool, 1);
> +			hugetlb_acct_memory(h, -gbl_reserve);
> + 		} else if (gbl_chg > 0 && spool && spool->min_hpages =3D=3D=
 -1 &&

The gbl_chg > 0 check can be dropped: negative values jump directly to
out_end_reservation, while zero is handled by the preceding if =
(!gbl_chg).

> +   			spool->max_hpages !=3D -1) {
> + 			unsigned long flags;
> +
> + 			/*
> +			 * For max-only subpools, subpool_get_pages() =
took only a
> +			 * speculative used_hpages slot. Drop that slot =
directly.
> +			 */
> + 			spin_lock_irqsave(&spool->lock, flags);
> + 			if (spool->used_hpages > 0)
> + 				spool->used_hpages--;
> + 			unlock_or_release_subpool(spool, flags);

Could we use hugepage_subpool_put_pages(spool, 1) here?

With the max-only check in place, the helper cannot restore rsv_hpages, =
so it already
performs the required used_hpages decrement and subpool lifetime =
handling under the
appropriate lock.

Thanks,
Muchun

> + 		}
> }
>=20
>=20
> --
> 2.50.1 (Apple Git-155)


