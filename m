Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DF1D606A31A
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 09:13:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Gf0hWT+S
Received: by kanga.kvack.org (Postfix)
	id 6815E6B08E5; Thu, 22 Oct 2026 05:13:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 62A7D6B08E6; Thu, 22 Oct 2026 05:13:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 517F56B08E7; Thu, 22 Oct 2026 05:13:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 15FF26B08E5
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 05:13:09 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A32ABA845E
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 09:13:08 +0000 (UTC)
X-FDA: 85349698056.16.BC46C93
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 097FE80009
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 09:13:06 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Gf0hWT+S;
	spf=pass (imf02.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792660387;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hATo3DMTpQ0X7N+H6fzS91u6XcHTdRSqM0j0c/rawLY=;
	b=BX0TIlYM5sE2mQh3uTyaGo4GA5e98v31oLDhCJyvsHx/yD9WJlup+lAbWtP0bA3ql536wv
	QoHT9ofNjInKVGLhS7BO3ghOHyb8XecIh3l2qPqh8fAiYd3sYrQpUNS6PbgAqNXWLxfjYk
	GuaXeHpwdKJ7i2oRjbBZ1TnNecmy+xg=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Gf0hWT+S;
	spf=pass (imf02.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792660387;
	b=MbopjIj3WaW9Xx5XN+ghVmZaGyPDA0motoKJC6kdBg3tjFyYlEtaNbUZ7fT4Wntu64ov0j
	Q5KRMNOxVe5PaRHyaIp7wjupu2win6GFkz9RUEPfFe5FxWwEa9kPmIarpD8MFLz/uXZnJC
	4P1xw+z4fIWN4Bg/p3hheQv6yIx0KIk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4408A41955;
	Thu, 22 Oct 2026 09:13:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9CF71F000C1;
	Thu, 22 Oct 2026 09:13:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792660386;
	bh=hATo3DMTpQ0X7N+H6fzS91u6XcHTdRSqM0j0c/rawLY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Gf0hWT+SJB3tVJytql1rg+BnzUx+nuVxPRO0N/x4D5lq9DrYb2khrkcV2Vb3EXPQl
	 Qc6ue0kLvg23lP/Z8+zZu8A00A/iwZvbWCzPZNHsCpJ1neolPCiBk+4C0uumoYKHdd
	 25WIEo1Sd7ou8/DJ381pkC+Wh7a5OliIFowHRNXPwKBOwRP0FowQPmYB43slYRztN/
	 iiQLvAQDpLuoUrfzT8tQrBZb5BxDeiQO/hdkTry+IqOjUn6ue93WKeZpGylZH2j+k6
	 HLIq8yeqJA5gti0QTBlcIBJ6qOgR8pXNqD2u4UzSWGyKfECqNB5UXLNxIla5xVpDQU
	 C6VTT92GgEKjw==
Message-ID: <sashiko-outbox-181243@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 5/5] mm: hugetlb: enable CMA allocation for PMD-sized
 pages
Reply-To: sashiko-reviews@lists.linux.dev
To: "Qi Zheng" <qi.zheng@linux.dev>, muchun.song@linux.dev, david@kernel.org, osalvador@suse.de, akpm@linux-foundation.org, azpijr@gmail.com
Cc: linux-mm@kvack.org, "Qi Zheng" <zhengqi.arch@bytedance.com>
In-Reply-To: <5edd1dc82bd3b0b09005c0b36cafa2f7baea6d3d.1792651104.git.zhengqi.arch@bytedance.com>
References: <cover.1792651104.git.zhengqi.arch@bytedance.com>
 <5edd1dc82bd3b0b09005c0b36cafa2f7baea6d3d.1792651104.git.zhengqi.arch@bytedance.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 22 Oct 2026 09:13:05 +0000
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 097FE80009
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: dqfkozxhzktqua6txp4q6qy6jfj6mhd6
X-HE-Tag: 1792660386-61016
X-HE-Meta: U2FsdGVkX1/8JzWSrWb9IseEZPNSUbHwLxU4HFipBkDBilupC4dxvwCNGtUAnU4lCh1dBc1G72awIHbUM8vCWO9EtyKtEVJQ+K0XQeQs0KaLAcrX0C2GDbOPHI2LtdtZyvMdgSLqQ51chzWcvIEdzPkrJY8J5fgDleIPBTqbTUN9JTrwIDNRoL4wAxH5HR8Go5FUYNAwLUR5ndWjsomyzGbuuTPEbw1hfU8tc0dUfClf/iOQwYz8uKMofYJoXmbydRVbyjMUAL+i30tQH9EPv2DwbmxKNCiyiVLkCidlSNbo4u6DBX1x6y6kVAjipP86xm3DddZl/TXHp/lDGmPxYRD8xnRbK6ExVXvBlB00AMEyZzUb+QwQ6cxks3/UKcp2MX7IFIHvXtrKUN1DwMLrPhKuDvF1Ciou35ELQboSJkaGLZyOiXxcYQXwSWkWGxEvdlpMbrWkl+5NkUf/IGUupUsWPI8WamqcW8mYmgLg+MttKibtmBTEl/4uoznTKvmJ60wZj5b7wTFgYxApJ/xJxlxYldr75xhnjnqFgA2BiSSo3LNM5vGWf9uOYaMJ4w2XxJtUJUVlIOyHasMz8hDXvnatachqFZ6Vluwv9IZgAz/fPqqg83b/UR/Byi/CRdAaQ4TFnNtJmy6e9IThZdbTwf+brx2VoZX+Ql91xupUeE5TlxFvdcxDRfkJQS64CWPcnSYUt312/pmNp0JIrXBZNLZrKBvTkuWIPajh/+BiH7/12P0Bwz/Lild6DCcxLGc8uFEiKS84nYgt1xbfxEkq3B2AZNvfnwzErgsZBmIgj39gArOZ33joklQ58sMaSC0G+cSCQAOSxT9EfSEk5l+oy7LjSrXbTTwLpBu1IZD5RjLmXCGxauiTPUAhBl79FTHmvlb5XRE8IWuLXLPyy7NLMgQsA+/CtO5Jdgj29f4VbShICwIYvZ88qcVNa1ifPUTnblxQSlA6yrrO4ZYVgXg
 EqrlRhH7
 gETNB51Cd4cL4gfKhpdh8j+4dWAnkAj3S42zsX4kiX6XMKjo946Zj+teSkL1qyZTqEM9YbTd8kVE/kexbCCa+oprBHyZI8UxoCARqoL0CRFwwVXLoKPdMIS78LHgAjON/jIlX32wXHJpVu6sOK2dLojbXZx/1UglAIScn9NJaO0F5obPRMINjeWNYHobn119O0EQL/remeF+5nlCLok1GN1m1Jo2rdeVm7eEtiFAhOq+SHLThe2EsOETW8WoXPmRV4TW9LiT0XntBgVrj6NRf5elTAiq03Aip0YivNOfYz0SDuqpyPQR2iU4LUEDYBJTUwGQAcXkgzEpuY/TbayMTQRRZWWbsJVRwB0goO/7pz/1OqYXjpJ2ajt0lHqg8QPhBrvufaJ8tfJtXw0dDDP7EODRWDDEi4ooWVSxWXc94Weoez72+Mnx9BO2tzOyKM9jmtcYog6EMBtPY52c9oZy0+GHRlTnS5SCV/8KzHNBiYLK8dMV8kjj/euDFkRnuCakUDE2vTFDo81uVrMNT/OGQfqGNRjvKkdiNcWGmXrZwKsZfk8p5I6fRmgoYhIvj9xvhYUMVFSNKfn9MrS1Uf7pyRf7HtA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [High] mm: hugetlb: infinite FOLL_LONGTERM migration loop for PMD CMA fol=
ios
- [High] mm: hugetlb: alloc_buddy_frozen_folio() consumes CMA pages without=
 bitmap bits
- [High] mm: hugetlb: folio_lock deadlock in CMA alloc for PMD hugetlb faul=
ts
--

commit 9cf077a849a76f9279657f4fa6aef60b1b9348ba
Author: Qi Zheng <qi.zheng@linux.dev>

mm: hugetlb: enable CMA allocation for PMD-sized pages

This commit enables configuring a dedicated CMA pool for PMD-sized HugeTLB
pages via hugetlb_cma=3D<capacity>@<page-size>, trying buddy allocation fir=
st
for non-gigantic PMD pages before falling back to CMA.

> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index c1a8d00be11ac..bad5cd4978c5e 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -1835,22 +1835,20 @@ static struct folio *only_alloc_fresh_hugetlb_fol=
io(struct hstate *h,
>  {
>  	struct folio *folio =3D NULL;
>  	int order =3D huge_page_order(h);
> +	bool cma_only =3D hugetlb_cma_exclusive_alloc(order);
> =20
>  	if (nid =3D=3D NUMA_NO_NODE)
>  		nid =3D numa_mem_id();
> =20
> -	if (allow_cma && order_is_gigantic(order))
> +	if (!order_is_gigantic(order) && !cma_only)
> +		folio =3D alloc_buddy_frozen_folio(order, gfp_mask, nid, nmask,
> +						 node_alloc_noretry);

[Severity: High]
When hugetlb_cma=3D<size>@<pmd-size> is configured without hugetlb_cma_only=
=3D1,
can calling alloc_buddy_frozen_folio() first consume pages from the reserved
CMA pool without marking the CMA bitmap, leading to a livelock in
alloc_and_dissolve_hugetlb_folio() or premature failure in cma_range_alloc(=
)?

For non-gigantic PMD hstates where hugepage_movable_supported(h) is true,
htlb_alloc_mask(h) includes GFP_HIGHUSER_MOVABLE. In
__alloc_frozen_pages_noprof(), prepare_alloc_pages() and
alloc_flags_slowpath() set ALLOC_CMA via alloc_flags_cma(gfp_mask), which
allows mm/page_alloc.c:__rmqueue() to allocate PMD-sized folios directly
from the MIGRATE_CMA freelists of the hugetlb_cma pool without setting bits
in cmr->bitmap:

mm/page_alloc.c:__rmqueue()
	case RMQUEUE_CMA:
		if (alloc_flags & ALLOC_CMA) {
			page =3D __rmqueue_cma_fallback(zone, order);
			if (page) {
				*mode =3D RMQUEUE_CMA;
				return page;
			}
		}

Once completely free PMD-order buddy blocks are exhausted,
only_alloc_fresh_hugetlb_folio() falls back to
hugetlb_cma_alloc_frozen_folio() -> cma_alloc_frozen_compound() ->
cma_range_alloc(). Because the bitmap bits for the buddy-allocated PMD
HugeTLB folios are still zero, cma_range_alloc() selects those ranges and
calls alloc_contig_frozen_range() -> isolate_migratepages_block() ->
isolate_or_dissolve_huge_folio() -> alloc_and_dissolve_hugetlb_folio().

During batch pool allocation in hugetlb_hstate_alloc_pages_onenode(),
hugetlb_pages_alloc_boot_node(), or set_max_huge_pages(), the earlier
buddy-allocated folios are still held on the caller's local list with
refcount 0 and without the hugetlb_freed flag set until
prep_and_add_allocated_folios() runs after the loop. When
alloc_and_dissolve_hugetlb_folio() encounters one of those folios, it spins
indefinitely waiting for the current task to enqueue it on the freelist:

mm/hugetlb.c:alloc_and_dissolve_hugetlb_folio()
	} else if (!folio_test_hugetlb_freed(old_folio)) {
		spin_unlock_irq(&hugetlb_lock);
		cond_resched();
		goto retry;
	} else {
		h =3D folio_hstate(old_folio);
		if (!new_folio) {
			spin_unlock_irq(&hugetlb_lock);
			gfp_mask =3D htlb_alloc_mask(h) | __GFP_THISNODE;
			new_folio =3D alloc_fresh_hugetlb_folio(h, gfp_mask, nid,
							      NULL, false);
			if (!new_folio)
				return -ENOMEM;

Even when old_folio is already on the HugeTLB freelist (or in use when no
free pool pages remain), alloc_and_dissolve_hugetlb_folio() or
unmap_and_move_hugetlb_folio() -> alloc_migration_target() calls
alloc_fresh_hugetlb_folio() with allow_cma set to false. That retries the
same alloc_buddy_frozen_folio() call that just failed and returns -ENOMEM,
causing mm/cma.c:cma_range_alloc() to break out of the bitmap scan loop
immediately without trying the remaining CMA pageblocks:

mm/cma.c:cma_range_alloc()
		mutex_lock(&cma->alloc_mutex);
		ret =3D alloc_contig_frozen_range(pfn, pfn + count, ACR_FLAGS_CMA, gfp);
		mutex_unlock(&cma->alloc_mutex);
		if (!ret)
			break;

		cma_clear_bitmap(cma, cmr, pfn, count);
		if (ret !=3D -EBUSY)
			break;

> +
> +	if (!folio && allow_cma)
>  		folio =3D hugetlb_cma_alloc_frozen_folio(order, gfp_mask, nid, nmask);

[Severity: High]
Can this cause an infinite migration loop when a userspace process pins a
PMD-sized HugeTLB mapping with FOLL_LONGTERM via __gup_longterm_locked() or
memfd_pin_folios()?

Folios allocated by hugetlb_cma_alloc_frozen_folio() are placed in
MIGRATE_CMA pageblocks, so folio_is_longterm_pinnable() returns false. When
pinning with FOLL_LONGTERM, mm/gup.c:__gup_longterm_locked() (and
memfd_pin_folios()) sets PF_MEMALLOC_PIN via memalloc_pin_save() and loops
while check_and_migrate_movable_pages() returns -EAGAIN:

mm/gup.c:__gup_longterm_locked()
	flags =3D memalloc_pin_save();
	do {
		nr_pinned_pages =3D __get_user_pages_locked(mm, start, nr_pages,
							  pages, locked,
							  gup_flags);
		if (nr_pinned_pages <=3D 0) {
			rc =3D nr_pinned_pages;
			break;
		}

		/* FOLL_LONGTERM implies FOLL_PIN */
		rc =3D check_and_migrate_movable_pages(nr_pinned_pages, pages);
	} while (rc =3D=3D -EAGAIN);

Previously, only gigantic folios were allocated from hugetlb_cma, and
alloc_migrate_hugetlb_folio() rejected gigantic hstates, terminating the
loop with -ENOMEM. With non-gigantic PMD folios now allocated from CMA,
migrate_longterm_unpinnable_folios() calls migrate_pages() with
alloc_migration_target() and MR_LONGTERM_PIN, which passes allow_cma as true
(mtc->reason !=3D MR_CONTIG_RANGE):

mm/migrate.c:alloc_migration_target()
	if (folio_test_hugetlb(src)) {
		struct hstate *h =3D folio_hstate(src);

		gfp_mask =3D htlb_modify_alloc_mask(h, gfp_mask);
		return alloc_hugetlb_folio_nodemask(h, nid,
						mtc->nmask, gfp_mask,
						htlb_allow_alloc_fallback(mtc->reason),
						mtc->reason !=3D MR_CONTIG_RANGE);
	}

When dequeue_hugetlb_folio_node_exact() skips free CMA folios in the pool
because PF_MEMALLOC_PIN is set and falls back to
alloc_migrate_hugetlb_folio() -> alloc_fresh_hugetlb_folio() ->
only_alloc_fresh_hugetlb_folio(), if cma_only is true or if
alloc_buddy_frozen_folio() fails to find a non-movable buddy block,
hugetlb_cma_alloc_frozen_folio() in mm/hugetlb_cma.c does not check
PF_MEMALLOC_PIN and allocates another MIGRATE_CMA folio. Migration then
succeeds into the new CMA folio, check_and_migrate_movable_pages() returns
-EAGAIN, and the pin path loops indefinitely migrating between CMA folios.

Should hugetlb_cma_alloc_frozen_folio() or only_alloc_fresh_hugetlb_folio()
skip CMA allocation when current->flags & PF_MEMALLOC_PIN is set?

[Severity: High]
Could falling back to hugetlb_cma_alloc_frozen_folio() for non-gigantic PMD
pages during a HugeTLB page fault also deadlock on folio_lock?

During a HugeTLB fault (hugetlb_fault() -> hugetlb_wp() or
hugetlb_no_page()), alloc_hugetlb_folio() is called while holding
hugetlb_fault_mutex_table[hash] and hugetlb_vma_lock_read(vma). In the
copy-on-write path in mm/hugetlb.c:hugetlb_wp(), the faulting task also
holds folio_lock(old_folio) with HPG_migratable set on old_folio:

mm/hugetlb.c:hugetlb_wp()
	spin_unlock(vmf->ptl);
	new_folio =3D alloc_hugetlb_folio(vma, vmf->address, cow_from_owner);

When surplus allocation in alloc_surplus_hugetlb_folio() ->
only_alloc_fresh_hugetlb_folio() falls back to
hugetlb_cma_alloc_frozen_folio() -> cma_alloc_frozen_compound() ->
cma_range_alloc() -> alloc_contig_frozen_range(), if the target CMA range
contains an in-use buddy-allocated PMD HugeTLB folio src,
mm/hugetlb.c:isolate_or_dissolve_huge_folio() only rejects gigantic folios
and isolates src onto cc.migratepages:

mm/hugetlb.c:isolate_or_dissolve_huge_folio()
	if (order_is_gigantic(folio_order(folio)))
		return -ENOMEM;

	if (folio_ref_count(folio) && folio_isolate_hugetlb(folio, list))
		ret =3D 0;

__alloc_contig_migrate_range() then calls migrate_pages() ->
migrate_hugetlbs() -> unmap_and_move_hugetlb_folio() with mode set to
MIGRATE_SYNC. Once alloc_migration_target() obtains a replacement folio, on
pass > 2 (force =3D=3D 1) mm/migrate.c:unmap_and_move_hugetlb_folio() perfo=
rms a
blocking folio_lock(src):

mm/migrate.c:unmap_and_move_hugetlb_folio()
	if (!folio_trylock(src)) {
		if (!force)
			goto out;
		switch (mode) {
		case MIGRATE_SYNC:
			break;
		default:
			goto out;
		}
		folio_lock(src);
	}

In hugetlb_wp(), if src is old_folio, the current task already holds
folio_lock(old_folio) and will self-deadlock. Even if src is a different
folio (or in hugetlb_no_page()), blocking on folio_lock(src) while holding
hugetlb_fault_mutex_table[hash] and hugetlb_vma_lock_read(vma) inverts the
hugetlb_fault_mutex -> vma_lock -> folio_lock lock ordering against a
concurrent task in hugetlb_wp() on src, which holds folio_lock(src) while
dropping and re-acquiring hugetlb_fault_mutex_table[hash] and
hugetlb_vma_lock_read(vma) around unmap_ref_private().

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1792651104.gi=
t.zhengqi.arch@bytedance.com?part=3D5

