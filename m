Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0284606A331
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 07:05:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=f96OUurH
Received: by kanga.kvack.org (Postfix)
	id C343B6B05B7; Fri,  6 Nov 2026 02:05:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C0DCE6B05B8; Fri,  6 Nov 2026 02:05:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B486A6B05B9; Fri,  6 Nov 2026 02:05:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 981B76B05B7
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 02:05:10 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 202C7120C9A
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 07:05:10 +0000 (UTC)
X-FDA: 85403807580.27.56D5BC4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 64AC6100002
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 07:05:08 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=f96OUurH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793948708;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XtmmD+CnmiHCaSy3WS3xhSNzB5QJGEbQjevcnqHZ/Jg=;
	b=FF3uvy7zdJOYMzGYeJZRZdviASFldncib3JK/XAffV+yIA4IUpdcStGKCu1Dpqt5ViMjW2
	bSMrDnLzqQWFwrN2lJLEz1nbn15EXE3GBpn6r2Bky+7l19b5sjYxbhe13GmlkbEmZtn2f7
	L8rkqX0Cy6fxaIhfRbUikVZVlUcMyC4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=f96OUurH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793948708;
	b=8Vewdi29gIxq6b85Uw0qTyjCcz2o9NL3mFeyHisSHLdfnEtAH+F8WFjyU+Mlz5qPrhncRG
	NX3+fFyvyESeBsHpUesJXweRGqU0ERmiZ4ge4gwdU1i3MJJnTzUe9znHSmI+bV0EL7MwB9
	rTvCxsGE6+vTP2bc6oy/BfKLqWkdjF0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A0D85439EF;
	Fri,  6 Nov 2026 07:05:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 123CF1F0089F;
	Fri,  6 Nov 2026 07:05:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793948707;
	bh=XtmmD+CnmiHCaSy3WS3xhSNzB5QJGEbQjevcnqHZ/Jg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=f96OUurHo3aGPcUDptEsL8mM6ZFiE7la6RPVzyN9NTU7es1IP6lO+oaRw2y9TZHj2
	 2YC44/iudAP8ATlt2EqLIFWuG5dhWNYxbg17ZNDmiXFjUJbE1b59AlSVUfd1wuJQDo
	 LQxWDmXit/N5SykWDi5JDiSRLwhhsTXA3yhabAHonuotcxWldrBfl/znKyQ8SlD5fU
	 Qb3FOgCsznE87fJZGVJnhjwQZcX6uYB9Wyygko2fIxJ0pOVom/9O+sVhF1mqQ/gZ9j
	 gio8esZjCD77K/+r0UlYPrRteAexxqxB4qB4uAyKJ/gnEaOf7jdEVrbag4Q3aRy6BM
	 iw0ib/vUI43KQ==
Message-ID: <sashiko-outbox-200955@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 6.12] mm: replace free hugepage folios after migration
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mark Bundschuh" <mkbund@amazon.com>
Cc: linux-mm@kvack.org, david@kernel.org, yangge <yangge1116@126.com>, "Baolin
 Wang" <baolin.wang@linux.alibaba.com>, "Barry Song" <21cnbao@gmail.com>, "David
 Hildenbrand" <david@redhat.com>, "SeongJae Park" <sj@kernel.org>, "Andrew
 Morton" <akpm@linux-foundation.org>
In-Reply-To: <20261105070442.3101877-1-mkbund@amazon.com>
References: <20261105070442.3101877-1-mkbund@amazon.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 06 Nov 2026 07:05:06 +0000
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 64AC6100002
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: igou1csria3ixeu96a6s79tgzbx1knw9
X-HE-Tag: 1793948708-505602
X-HE-Meta: U2FsdGVkX1/cjRZRjGs29nLCNQRgXruxLtqZMf8S/r+Bw5kEs7Dzt5F+T/O1d+qeyEpiyJtp0RYAsDNCENqzpA9TFQvRzWnrTgB8qsVbU+4VMvsx2KNQ9YPtvMkT8kTtXXf1ShU8H5YQirFSoWGkyFpJPmSWjT9wjwWD1WaaQUD188YNDAjsyFoBYmtxPYd18ov1/Ll3cpfgX19wwj51RcNzrD/ouQulCftnHEf+42M0MAiS0wFGX/4IC2JCMqo4ZQyrf3dsp9cLcGZLqGEQVkO4Bh1iJe6zH9gijPe0YjdiLvUvDBXiMD30LKJkqKOIiMGW1RQSufvhqixGoRCQyNAgyrAiCbFsDtOuVRhSHeGOGV+JsDitBR7qd80KqowfM7uvqADoQ9P62sMIeEuCQbWgHkXQKD6wBsn36JREjrLC/zGmO6ax0kPlbGyUVixa5YOMn+ahy+s5IjvDgLIuWW4GsAn0cZbqp39hPeHL/ISTcTVBst44L5tddDxw5PRoM52LzLk8r+yKZVcl10TgnrloX67Z5sY11ktKKmtg8fT1y3/UYqu439XepWXRQqn0FsfHUpAIruzCJlyYpLvtujaIaiq5vG6X04oiGb1XMm4SNMiNtASN3a3UuOn98ueq0Lp72D7HvNdnUFULQZL4FexClrXpUrnDUMYdFSLlA/U1XT1JXOUDi0Oxfht3QcMF6LE5Mc9VmI7ftVNfMge6DH5tfzel0kj/tTTTRLoihZYHKC2ES68oCRoEESxHCtbMY+9XOnon2QklwQiq+3+xDeBWPcTNdLS+ROLsM5ZzzRjrVNgRpNWQqd7lnniT8Fc+xZnFzoOeci+2UEN13V+usGB3+PMG6f/aDBDmPVX4mWNSeX06iqtFihnQAxIaKOpgGK/ZXKz6/vdoNVZssozuepmkSsSl6IOoiXrd7c6okLE3oEJxNqdMIW4nnhIVMVeCvgP/XsPdIFzE9f5dBjF
 dW/Vv/0a
 KtrdjIp01hu2EsHtoqZFM38rctOinmkvukMn25z2z/TK4x6Bc29WcIO3iEBsmBE/7KXn2CObcgdupvVzIaPREoy5TwYMom9tdxekwsM+zMIX2egsDVq5eTSH+wJRUTt5Y+mWa9w1EIGmprTPtuV35BLdmL8OH3xq8pj+BKhyOOeuvdI24efE9GGKnmS4bM57VI/HFv+dHzkjNZRo3hwPUqLci/5CzAldko0oT5agP6GaP/CHMqdEUE8guzmOVerhU+/CK5FbYXwnejp7o8lH/A/X2WREkhA2HeNDnwjcT1/EXRFG8nHezRlK3T/uTYYMZqS2r9iI6S0J4UQGQOr52aRk5OEWDUIuXwWQCxXUxUISSdE2grFwXJHhYQp05sIVmoT2BkDGc08KNuttIv0UarWZy6TXZsnB6wafTthbE3eVUDKUdAlqFxepByHsgBFLTSGsIvl9M/D1wmLpOmQcz9LDd7kbQGhf4m75SlwMWOjQkBngyPNc6m34ul/lJOALQYJorN0tvqIEjjGfwUw7VNVY9LCJ+BVQMhuu0wK02+Ao88lcbAsfOFyvr8GvznuznJuBzXYeT5gt5aLh+gfMs21v6OhsQpcWNs9yegZ+XvHoERB28py+p8odtlI3wNPG6kEUfUOzvHXrNfIyUlmawcjVObObuTHR08rAI2eSe/AajA7nsaxRvZk2oi3/J42mDzoV2owdZUnrlqNn43R+jR0ZLrT9JPp/qQ7yWFn2J7h9GIy3VgNXto+2PASAdnA8hPTg2BzKbuYJJ9PZ84xTu4pucHTlH3orX78Wz3fH6yzp6sns=
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
- [High] mm: dequeue_hugetlb_folio_node_exact() skips isolated folios
  counted as free
- [Medium] mm: missing replace_free_hugepage_folios() breaks
  alloc_contig_range()
--

commit 90894e199378334e1089f01dd3d151f3b4957700
Author: yangge <yangge1116@126.com>

mm: replace free hugepage folios after migration

This backport takes only the dequeue_hugetlb_folio_node_exact() check from =
the
upstream commit to skip isolated free hugetlb folios when dequeuing from the
hugetlb freelist, while omitting replace_free_hugepage_folios() and its call
site in alloc_contig_range_noprof().

Link: https://lkml.kernel.org/r/1734503588-16254-1-git-send-email-yangge111=
6@126.com
Link: https://lkml.kernel.org/r/1736582300-11364-1-git-send-email-yangge111=
6@126.com

>     mm: replace free hugepage folios after migration
>    =20
>     [ Upstream commit 04f13d241b8b146b23038bffd907cb8278391d07 ]
>    =20
>     My machine has 4 NUMA nodes, each equipped with 32GB of memory.  I ha=
ve
>     configured each NUMA node with 16GB of CMA and 16GB of in-use hugetlb
>     pages.  The allocation of contiguous memory via cma_alloc() can fail
>     probabilistically.
>    =20
>     When there are free hugetlb folios in the hugetlb pool, during the
>     migration of in-use hugetlb folios, new folios are allocated from the=
 free
>     hugetlb pool.  After the migration is completed, the old folios are
>     released back to the free hugetlb pool instead of being returned to t=
he
>     buddy system.  This can cause test_pages_isolated() check to fail,
>     ultimately leading to the failure of cma_alloc().
>    =20
>     Call trace:
>    =20
>     cma_alloc()
>         __alloc_contig_migrate_range() // migrate in-use hugepage
>         test_pages_isolated()
>             __test_page_isolated_in_pageblock()
>                  PageBuddy(page) // check if the page is in buddy
>    =20
>     To address this issue, we introduce a function named
>     replace_free_hugepage_folios().  This function will replace the hugep=
age
>     in the free hugepage pool with a new one and release the old one to t=
he
>     buddy system.  After the migration of in-use hugetlb pages is complet=
ed,
>     we will invoke replace_free_hugepage_folios() to ensure that these
>     hugepages are properly released to the buddy system.  Following this =
step,
>     when test_pages_isolated() is executed for inspection, it will
>     successfully pass.
>    =20
>     Additionally, when alloc_contig_range() is used to migrate multiple i=
n-use
>     hugetlb pages, it can result in some in-use hugetlb pages being relea=
sed
>     back to the free hugetlb pool and subsequently being reallocated and =
used
>     again.  For example:
>    =20
>     [huge 0] [huge 1]
>    =20
>     To migrate huge 0, we obtain huge x from the pool.  After the migrati=
on is
>     completed, we return the now-freed huge 0 back to the pool.  When it's
>     time to migrate huge 1, we can simply reuse the now-freed huge 0 from=
 the
>     pool.  As a result, when replace_free_hugepage_folios() is executed, =
it
>     cannot release huge 0 back to the buddy system.  To address this issu=
e, we
>     should prevent the reuse of isolated free hugepages during the migrat=
ion
>     process.
>    =20
>     Link: https://lkml.kernel.org/r/1734503588-16254-1-git-send-email-yan=
gge1116@126.com
>     Link: https://lkml.kernel.org/r/1736582300-11364-1-git-send-email-yan=
gge1116@126.com
>     Signed-off-by: yangge <yangge1116@126.com>
>     Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
>     Cc: Barry Song <21cnbao@gmail.com>
>     Cc: David Hildenbrand <david@redhat.com>
>     Cc: SeongJae Park <sj@kernel.org>
>     Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>     [ 6.12: Take only the dequeue_hugetlb_folio_node_exact() hunk, so mem=
ory
>       offline stops migrating huge pages back into the isolated range. ]
>     Signed-off-by: Mark Bundschuh <mkbund@amazon.com>

[Severity: Medium]
The commit subject and message state that this patch introduces
replace_free_hugepage_folios() and invokes it after migrating in-use hugetlb
pages so that cma_alloc() and test_pages_isolated() succeed, but this backp=
ort
drops replace_free_hugepage_folios() and its call in
alloc_contig_range_noprof() even though the helper
alloc_and_dissolve_hugetlb_folio() is already present in mm/hugetlb.c.

When alloc_contig_range_noprof() runs on a range containing multiple in-use
hugetlb folios while non-isolated free hugetlb folios exist in
h->hugepage_freelists, migrate_pages() -> alloc_migration_target() ->
alloc_hugetlb_folio_nodemask() dequeues a persistent free pool folio (which
does not have HPG_temporary set). After migration, free_huge_folio() returns
the old source folio to h->hugepage_freelists instead of the buddy allocato=
r:

mm/hugetlb.c:free_huge_folio() {
    ...
	} else {
		arch_clear_hugetlb_flags(folio);
		enqueue_hugetlb_folio(h, folio);
		spin_unlock_irqrestore(&hugetlb_lock, flags);
	}
}

With the new check in dequeue_hugetlb_folio_node_exact() skipping that newly
freed isolated folio, each subsequent in-use hugetlb folio migrated out of =
the
range consumes another non-isolated free pool folio from outside the range =
and
leaves its old folio on h->hugepage_freelists inside the isolated range.

Because alloc_contig_range_noprof() never calls
replace_free_hugepage_folios(start, end) after __alloc_contig_migrate_range=
():

mm/page_alloc.c:alloc_contig_range_noprof() {
    ...
	ret =3D __alloc_contig_migrate_range(&cc, start, end, migratetype);
	if (ret && ret !=3D -EBUSY)
		goto done;
	ret =3D 0;

	outer_start =3D find_large_buddy(start);

	/* Make sure the range is really isolated. */
	if (test_pages_isolated(outer_start, end, 0)) {
		ret =3D -EBUSY;
		goto done;
	}
}

doesn't test_pages_isolated() still fail with -EBUSY on those freed hugetlb
folios, while pulling additional free hugetlb pool folios into the isolated
CMA/contiguous range?

> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 68e0cc0748cac..b4c6c926a71e2 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c

[ ... ]

> @@ -1350,6 +1351,9 @@ static struct folio *dequeue_hugetlb_folio_node_exa=
ct(struct hstate *h,
>  		if (folio_test_hwpoison(folio))
>  			continue;
> =20
> +		if (is_migrate_isolate_page(&folio->page))
> +			continue;

[Severity: High]
Can unconditionally skipping isolated folios in
dequeue_hugetlb_folio_node_exact() while they remain counted in
h->free_huge_pages break hugetlb reservation accounting during memory
offlining and page faults?

Specifically, available_huge_pages(h) computes:

    h->free_huge_pages - h->resv_huge_pages

which still counts MIGRATE_ISOLATE folios on h->hugepage_freelists[nid] as
available.

During offline_pages(), start_isolate_page_range() marks the range
MIGRATE_ISOLATE and do_migrate_range() runs before
dissolve_free_hugetlb_folios(). If there are unreserved free hugetlb folios=
 in
the isolated range (either initially free or placed on h->hugepage_freelists
when an earlier in-use hugetlb folio in the range was migrated into an
unreserved free pool folio) and non-isolated free folios outside the range
backing h->resv_huge_pages, available_huge_pages(h) is greater than 0. When
do_migrate_range() migrates another in-use hugetlb folio in the range:

mm/hugetlb.c:alloc_hugetlb_folio_nodemask() {
    ...
	spin_lock_irq(&hugetlb_lock);
	if (available_huge_pages(h)) {
		struct folio *folio;

		folio =3D dequeue_hugetlb_folio_nodemask(h, gfp_mask,
						preferred_nid, nmask);
    ...
}

dequeue_hugetlb_folio_node_exact() skips the isolated free folios and steals
one of the non-isolated free folios backing h->resv_huge_pages, while
free_huge_folio() places the old folio onto h->hugepage_freelists inside the
isolated range. When dissolve_free_hugetlb_folios() then runs on the isolat=
ed
range, after dissolving the unreserved count, the remaining isolated free
folio hits:

mm/hugetlb.c:dissolve_free_hugetlb_folio() {
    ...
		if (!available_huge_pages(h))
			goto out;
    ...
}

returning -EBUSY and failing offline_pages() after persistent hugepages have
already been dissolved.

Similarly, if the free folios backing h->resv_huge_pages happen to lie in a
MIGRATE_ISOLATE pageblock, alloc_hugetlb_folio() ->
dequeue_hugetlb_folio_vma() -> dequeue_hugetlb_folio_node_exact() and
alloc_hugetlb_folio_reserve() will skip them and return NULL:

mm/hugetlb.c:alloc_hugetlb_folio() {
    ...
	folio =3D dequeue_hugetlb_folio_vma(h, vma, addr, gbl_chg);
	if (!folio) {
		spin_unlock_irq(&hugetlb_lock);\
		folio =3D alloc_buddy_hugetlb_folio_with_mpol(h, vma, addr);
		if (!folio)
			goto out_uncharge_cgroup;
    ...
}

Won't that cause reserved page faults to fail with -ENOSPC (SIGBUS) whenever
surplus overcommit is disabled (nr_overcommit_huge_pages =3D=3D 0) or the h=
state
is gigantic?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261105070442.3101=
877-1-mkbund@amazon.com?part=3D1

