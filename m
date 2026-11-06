Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DF94606A32E
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 07:03:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JypEbKX2
Received: by kanga.kvack.org (Postfix)
	id A85DB6B05B3; Fri,  6 Nov 2026 02:03:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A34686B05B4; Fri,  6 Nov 2026 02:03:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 94A686B05B5; Fri,  6 Nov 2026 02:03:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 765BC6B05B3
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 02:03:57 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0D4FB140C88
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 07:03:57 +0000 (UTC)
X-FDA: 85403804514.26.AA7284B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 781B320002
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 07:03:55 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JypEbKX2;
	spf=pass (imf13.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793948635;
	b=3zMyfmjw0EmyfaL4yCw8UpTFTBzYBLBnBirgnVs/ujbkfKelD1LxMmSebqfYLQ47ROCk4f
	FDsnkeWjIRqvdnc0ZksbYO/xm6U0pJVWcIPiVYeAfg3CMbyIVI/P5sS/cEKXAPn+slEMnI
	ei0SuAz+Ltv73IudmEnmKXPypyCQi2Q=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JypEbKX2;
	spf=pass (imf13.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793948635;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XIgLAL3T/pcTVBjZB61XuR9F3WR3X77r0CBe+3C3s/E=;
	b=iGaqbM9nAHRtOkDV0M5nyB9M+NpRrlKVjqbN6Hm5rFNL83x9dfFxa+ptPqlp9s2EeboQX1
	aOaysPH1Xn876DSaKTpJwaIuALuDahumZArx38PfADOlotr08SZveiwFiOKZgnlJMzpYgY
	e3mbQczxkMSb7b+2mAXZoRynlpk54Xc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DBB09601D5;
	Fri,  6 Nov 2026 07:03:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22F4E1F008A2;
	Fri,  6 Nov 2026 07:03:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793948634;
	bh=XIgLAL3T/pcTVBjZB61XuR9F3WR3X77r0CBe+3C3s/E=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=JypEbKX20yQoBsvejyHponuvztK87EWJJJbwKyzvTaDNh3smXzUDx8dp9ulDfGWxH
	 K8oq8hh9XE/RQScdBdood2OLZfnlVY31RJa4+w16xTWGamso5xGp9NyJrAzac3vkYi
	 3LxV5bo7fSWcNib5FxaxQ6xfNoA+ZLawDJskrOfb0jYtISgSoOUHhA5GZsCL4yATA0
	 be+WOL61ugjodUFp+HR5413kiIr1pz67+zMaXk478y42HCvDsQ78RfYquunqpM+4HO
	 asgVZsKcdoxRnuqIKCXRHOnFMyhpTkh1rukC+BlVysIsG4dIebAJ1gpaqbVJ7xIl3H
	 xN5VoLtzKS/WQ==
Message-ID: <sashiko-outbox-200952@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 5.15] mm: replace free hugepage folios after migration
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mark Bundschuh" <mkbund@amazon.com>
Cc: linux-mm@kvack.org, david@kernel.org, yangge <yangge1116@126.com>, "Baolin
 Wang" <baolin.wang@linux.alibaba.com>, "Barry Song" <21cnbao@gmail.com>, "David
 Hildenbrand" <david@redhat.com>, "SeongJae Park" <sj@kernel.org>, "Andrew
 Morton" <akpm@linux-foundation.org>
In-Reply-To: <20261105070206.3094675-1-mkbund@amazon.com>
References: <20261105070206.3094675-1-mkbund@amazon.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 06 Nov 2026 07:03:53 +0000
X-Stat-Signature: ceu6kmqcd9kbx951t9999yqgn1u3kfky
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 781B320002
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793948635-877275
X-HE-Meta: U2FsdGVkX18rFvy0iHGK2MZydzqlpglgvMsa+7bLpDhZ05mI5EbANSJUngCqLsVb6fd6Oc8M8dkdTh+1AVJTUzd5A6wdY+YsYp0RuT6Jn+QMZbJs7168pFVOUZDoh8NG0ECpGjmawqt0+EM+l1xN+jvG3GtRBkKIqw7GDkh+MX+Nec2DGXZ6Y8x9MsUCuDdpWgyq01LnZPZmM66QXWdWdsg0lN6/z/4oane6JtG2yUhwXA3vCOp05eBizKeFQ2iJolmEPEf+arnlZkable4QzahUZdwO4r/SAXXE6/w4WnJXdY9Cy1/po3SFoPjuE+5mRx9ff/s4kzm85mLZI3DA/6NZZ1ZIQXD6J0Vd0gKpioeZXM/orkaRMZGERWrsmNg+WGsj6BmI2rFWPmN+uhyP3t0tB3NRsW1ndgfqPRozFFB7LsBhXV0sXYZpQtj05JONjK0SZRwgIbu3sNdVphFoiSy7q42qnTm33AR/8t6W3h69uokRrGyUWN87/w1pHRmEIxw6C7EAPp1j8BpUr7DIsiTrmDjCH9vjUTalVS8n+DTGz9nNggcwpT/FWLZPBy0+cqgdiGoWi2kaamND7Nt8GxkbLjIvSPWzmfzgTR9X71ppMcSwiMtS7vk5SVPhh+tHofCXvycXL8GThxYvvrDW+dwY/ory22bCJ90v0p/ka//+SoloaOdru+mhfX7YQeCLipi5QI9FQNhW/ZD/UY/T6r2gdu7bdUDg74hoNPtWFD4yoL5eqbxGz1yse4KDtXRLPA6wrP5WnC4+sZo7XHlGYCheh+IbosauI80wg5FCtbQEsm3ovwKXaM8Rl6SZYW9WyVQEQ8eumDVuFtB3kfiLTyGHh0A716YzIS+fguJRlfychQGY+XfD2akyXkIBdF2jspV0kyBAj6e+gFLMYSLeIQ+xEv0DyeOUjG8lFOfFR/Wd5S8L//9q+F9K8p0sJR62Slt31W7eyaw4HIqJLS3
 o/CPqQnG
 GynFgxiPBqE0bFSk79mrdLVmE0SGLj404AWzFO5STEVYha4o4WlkRPg3j/WGdww5etx4tq/BYXREo+E69jrMTcTawmfgmdgldvEvwtxnuPhl90/5BKP3EjsHVD8v6lKdkb114DQIspWR06eGquGV/hR986R65YP4MIzcZLgRs2Cbz1f2tLy2szJtWGX/yRRF4QfpH4nowI6rOCGYOS1gf2XB/FKhjS6ANw3vdElIRLp9ODZ3FsNKSmrV2Ht90j7jhpsgZ+W3AJl0ERC7LPdsYbPTMLfysFeKHXEE4hMku9wOcXkePKaJVpluwlAoZ4XCWA/ngxmMfU2nxOH2rrUxsMod5JSzrqHuQHdwilRt4uHNWOPrhUKwnoOqRaLfgW5ihac+4wY3vzLloJVG1AowJvgyr7B7UI8YSQOnePPsguxKpxlTWr67g01C4UGhmkmbRXxTx6ZrzYZKZWZLmiEaJ5+tslRrGWFshO9RJL9VHGO4VMPsy1XCXFh3jT6X1fhRbkD7kEt/R0glKm4tsTALmw1LuI9Vh1wJyye85IpnvACfsIxAfahBfE8A4X7muIrGLyzWFXm2cLV7efDHa78CspIsX5+Xj1FJiwFu0rpR0FBog+6DseY8yH4XZJDTIWvUhFyo1msp5jD1996lQkXhIcnhLfcOW6sDfxENF
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
- [High] mm/hugetlb: isolated free pages in free_huge_pages break
  reservations and offline
- [Medium] mm: missing free hugepage replacement after migration in
  alloc_contig_range()
--

commit c4fd411e1512176c3c86e8729268c9e64aee0792
Author: yangge <yangge1116@126.com>

mm: replace free hugepage folios after migration

This backport takes the dequeue_huge_page_node_exact() hunk from upstream
commit 04f13d241b8b146b23038bffd907cb8278391d07 so that free hugetlb pages
in MIGRATE_ISOLATE pageblocks are skipped when allocating from the hugetlb
pool.

Link: https://lkml.kernel.org/r/1734503588-16254-1-git-send-email-yangge111=
6@126.com
Link: https://lkml.kernel.org/r/1736582300-11364-1-git-send-email-yangge111=
6@126.com

[Severity: Medium]
In mm/hugetlb.c, dequeue_huge_page_node_exact() is updated to skip pages
where is_migrate_isolate_page(page) is true, while the commit subject and
changelog state that replace_free_hugepage_folios() is introduced and
invoked after migrating in-use hugetlb pages so cma_alloc() and
test_pages_isolated() succeed.

In 5.15, hugetlb pages are allocated with GFP_HIGHUSER_MOVABLE via
htlb_alloc_mask() and can reside in MIGRATE_CMA and MIGRATE_MOVABLE
pageblocks. During cma_alloc() -> alloc_contig_range() ->
__alloc_contig_migrate_range() in mm/page_alloc.c,
isolate_or_dissolve_huge_page() in mm/hugetlb.c dissolves free hugepages in
the target range via alloc_and_dissolve_huge_page(), but for in-use
hugepages (page_count(head) > 0) it isolates them onto cc->migratepages via
isolate_hugetlb() and advances cc->migrate_pfn past them.

When migrate_pages() migrates those in-use hugepages via
alloc_migration_target() -> alloc_huge_page_nodemask(), if unreserved free
hugepages exist in the pool (h->free_huge_pages - h->resv_huge_pages > 0),
dequeue_huge_page_nodemask() returns a free pool hugepage without
HPageTemporary set. Because HPageTemporary(newpage) is false,
move_hugetlb_state() does not set HPageTemporary on the old source page, so
free_huge_page() enqueues the old page back onto h->hugepage_freelists[nid]
inside the MIGRATE_ISOLATE range instead of returning it to the buddy
allocator.

Because this backport omits the post-migration replacement step after
__alloc_contig_migrate_range() (even though alloc_and_dissolve_huge_page()
already exists in mm/hugetlb.c), won't migrating in-use persistent hugetlb
pages still leave the freed source hugepages on h->hugepage_freelists
inside [start, end) and cause test_pages_isolated() in alloc_contig_range()
to fail with -EBUSY? Also, should the commit subject and message be updated
if only the dequeue_huge_page_node_exact() change is intended?

[Severity: High]
In mm/hugetlb.c, dequeue_huge_page_node_exact() skips pages where
is_migrate_isolate_page(page) is true, but those isolated pages remain on
h->hugepage_freelists[nid] and remain counted in h->free_huge_pages. Can
this cause both memory offlining (offline_pages()) and reserved hugetlb
page faults (alloc_huge_page()) to fail when free hugepages sit in a
MIGRATE_ISOLATE range?

Consider a memory block [start_pfn, end_pfn) being offlined via
offline_pages() that contains two in-use hugepages H0 and H1 (or one free
hugepage H0 and one in-use hugepage H1), while outside the block there is
one unreserved free hugepage F0 and one reserved free hugepage F1 backing
an existing reservation (h->free_huge_pages =3D=3D 2, h->resv_huge_pages =
=3D=3D 1):

1. offline_pages() calls start_isolate_page_range(), marking
   [start_pfn, end_pfn) as MIGRATE_ISOLATE, and then calls
   do_migrate_range().

2. Migrating H0 dequeues F0. When H0 is released via
   putback_active_hugepage() -> free_huge_page() -> enqueue_huge_page(), H0
   is placed onto h->hugepage_freelists[nid] inside the MIGRATE_ISOLATE
   range and increments h->free_huge_pages back to 2.

3. When migrating H1, alloc_huge_page_nodemask() in mm/hugetlb.c checks:

       if (h->free_huge_pages - h->resv_huge_pages > 0)

   Because the isolated page H0 is still counted in h->free_huge_pages,
   2 - 1 > 0 succeeds even though the only non-isolated free page (F1) is
   needed to back h->resv_huge_pages.

4. dequeue_huge_page_node_exact() skips H0 because
   is_migrate_isolate_page(H0) is true and dequeues the reserved page F1
   for H1. H1 is then freed onto h->hugepage_freelists[nid] inside the
   MIGRATE_ISOLATE range, leaving both free hugepages (H0 and H1) inside
   the MIGRATE_ISOLATE range while h->resv_huge_pages =3D=3D 1.

5. In offline_pages(), dissolve_free_huge_pages(start_pfn, end_pfn)
   dissolves H0 (reducing h->free_huge_pages to 1) and then calls
   dissolve_free_huge_page() on H1, which hits:

       if (h->free_huge_pages - h->resv_huge_pages =3D=3D 0)
           goto out;

   and fails with -EBUSY, aborting offline_pages().

In addition, gather_surplus_pages() in mm/hugetlb.c computes:

    needed =3D (h->resv_huge_pages + delta) - h->free_huge_pages;
    if (needed <=3D 0) {
        h->resv_huge_pages +=3D delta;
        return 0;
    }

which counts MIGRATE_ISOLATE free pages in h->free_huge_pages as usable to
satisfy reservations. Whenever the free pages backing h->resv_huge_pages
are in MIGRATE_ISOLATE pageblocks (either from migration swapping F1 with
H1 above, or from gather_surplus_pages()), a page fault on a VMA with a
valid reservation calls alloc_huge_page() -> dequeue_huge_page_vma(), which
skips the isolated pages in dequeue_huge_page_node_exact() and returns
NULL.

alloc_huge_page() then falls back to alloc_buddy_huge_page_with_mpol() ->
alloc_surplus_huge_page(), which fails when h->surplus_huge_pages >=3D
h->nr_overcommit_huge_pages (0 by default) or hstate_is_gigantic(h),
returning ERR_PTR(-ENOSPC) and delivering SIGBUS to a process faulting on a
reserved mapping.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261105070206.3094=
675-1-mkbund@amazon.com?part=3D1

