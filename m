Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 110E9606A326
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 07:05:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mtpRkca8
Received: by kanga.kvack.org (Postfix)
	id 333796B05B6; Fri,  6 Nov 2026 02:05:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E3416B05B7; Fri,  6 Nov 2026 02:05:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 220496B05B8; Fri,  6 Nov 2026 02:05:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F202C6B05B6
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 02:04:59 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EFDFC402CC
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 07:04:58 +0000 (UTC)
X-FDA: 85403807076.09.4DDC024
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 56AE81C0005
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 07:04:57 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mtpRkca8;
	spf=pass (imf21.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793948697;
	b=hK8KJzc/kx2apPRMRVbf86BNGPklUzCw70ulPipO+lFLmmk9wNMS4UKgZh8ozeqzfa5/WR
	i+BKOIkhBX1lAZPDMXXy180f4XvN9cT6pInY2IrulIfnxZyY7Ne3JI6M6ZUXAZk722gM6u
	xy1hdaGDLzdwcEEDgCb9DKjaeV3nfqU=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mtpRkca8;
	spf=pass (imf21.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793948697;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gKruOE7Fi0Bd2chLADYya0ZBum/jyd36keRj4caMYsA=;
	b=hNR3ARarjPoGQM5G0vmxFlGgV8731AdAyzwJhlUQ/2jYz1/t4GkqUhaiVuehn1uHqJNnb7
	sGS/lOuYE7sf0U+Wdfk+zg2QA2sHyE2cQpEslTWHu4kVUGbdYTW/o7KuCbEeC1KbqPyulP
	EBicVhYbLj1C7RCn/ADZowLiVGCODNo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A3EEF42AC7;
	Fri,  6 Nov 2026 07:04:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D1481F0089F;
	Fri,  6 Nov 2026 07:04:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793948696;
	bh=gKruOE7Fi0Bd2chLADYya0ZBum/jyd36keRj4caMYsA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=mtpRkca8/hRapQm9zK6rw1oC49xxQ/eDkE5GX9Aa0Tn9GJnIPzaKL9r49XkznVbU1
	 hVG1gJCIY3g7XD5M06/jC/IbFzgye7CsY4q7bQU0CNHNrUK4FliuRuWtTEqdRnOLKk
	 2wnD8WgWJH1K0YWQNZlKvViENA/FVLMJ2SJ3ggU3Spx8njS+AW/nq/Ae5zbP5mSi7y
	 AIqDpPZGV0vu2chn8PmjBiXEGLkAlxAEX5CN6fyvkNvhtgaNHdQObY7r+Fo6pGNbJQ
	 Yr4W4ANJ4um7PwPd0/EkEJTvOOOclYmERliAfxObZnLk1DXTL/6/cBoFHaT0ZmZ0QQ
	 5RAWHH9PsgbOg==
Message-ID: <sashiko-outbox-200954@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 6.6] mm: replace free hugepage folios after migration
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mark Bundschuh" <mkbund@amazon.com>
Cc: linux-mm@kvack.org, david@kernel.org, yangge <yangge1116@126.com>, "Baolin
 Wang" <baolin.wang@linux.alibaba.com>, "Barry Song" <21cnbao@gmail.com>, "David
 Hildenbrand" <david@redhat.com>, "SeongJae Park" <sj@kernel.org>, "Andrew
 Morton" <akpm@linux-foundation.org>
In-Reply-To: <20261105070431.3100950-1-mkbund@amazon.com>
References: <20261105070431.3100950-1-mkbund@amazon.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 06 Nov 2026 07:04:55 +0000
X-Stat-Signature: 9qugo8x55qzarfybuogdx9nb4a55m5mi
X-Rspamd-Queue-Id: 56AE81C0005
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793948697-789869
X-HE-Meta: U2FsdGVkX18Njobv4qwkOZ9/XTgIz2DfmoAYRJWVYSqR5mZnyMiTiVgSONE0LmSdOSNffwwDzTqcmiaNmYML+FmgWGWEDKHnGXcoZ7Z3QDh/aWNWoWsipm4YovZJtW743wXOJT1DT9PPgqA+R4UEhiUSPGoex0PfEknpKBn04WJSW4C2kAsEjkpR/TV5wbEQVU8rE+Sxcc+whB2BVzFj/GsmkZeDhGGqIXs8L8sMhYSd2WIM8eAijRYrEn7LS33AiWLyAgctHiz8edw7TckLzFiLFrOHaKOY2DOkDLsIp2hxk+L137W/Es58sDGOlf8whH0mdQqpTnGno+0XQ+DVKMqPByPiGCPG3tA3RnPpJgu5s1V3QfkgwOPsYcAr1g9tbRdU+oB/Tu9HsBo/WSO0zhJU2stPvyl/vgU8y7jQllOUcK+JjcXj7xTPuJWgTkY1RXqneQBFHLxLnkeSB4XuLBnJadXs/rXzJeWAZ++85H4qtABMvWFH8zpHAF7H6Rc569gZU6GYdQ2nOWCRhjLlGKYSp/2d0iEvpnR2DXftCCPgsXYqrQzs0f7XVxzvf9+ewLbGiUi+nIkYHP0ju/w1mMFGTCK0NVrhSsNPs8WUIfD+fbBBwScWkagj/sOIWJeUNjGW4AyFL8seKrITG3DEG2PufPpQA4K6H45p4HCJIdxy7zvqOpSK70yyZZgPitY2xDbh9GISdnmtrIQsAb7TPEzcz1+1vDN7GHtIj3mo28ZRizHCMbOeTPrHK6a8Qm259wgLFet4uSj7VJlSDrTru2ITAwnKcXgLRUequEntA+umYvucv/wJ5DA/TpY6NN0Ituna8FZRE4L0EyoWPFu1rJfQoBnZl+FFd3K+wDmbwrnohM65tGbUpEJF/TiluDzCRL2yH56+QOaUgL228YQfMmvc6m1298IYsgtZZfDMTrkWlE98isGjF10whiYSDRvee8/OutpBE+HtkRZkKVh
 qQWBCYGG
 n2W8LFX4fD961hAc5zmSNbiCYJF58H9qU/GlBeAR3GzYAMHqlfX8EWFQlt46y9L2xVGB7xikjMLkAQvAQtTGdaBFOwKHxX4hqwrDPjYSeyXebtc9RQhDkrX5f+pdDss7lrXbUpUcbmzyDOAbIpB0z1TYInVTsg6TfwFfyRIS5T/zYzA7z2Nn97jwoSiJORXafZ9sFrAu3hIdp/NwsnPHBgc3HlgD+HgtWVNcoLyixGbt4WJeLV3Gnjdq+MbQ5kZu4pf5qEXSDWaRCXSEoCi0Sm9XpuLtfoDA4XrECrzPudVxtiCzv73V0RzUL9El0uwI7HodXnQ6iA+Af2Z7t60+XmUsDbO0kqYUnxyKUicdrtk8Szx/V6jX2ULgHPbPOnPkCDQ/1za0DgPWmyCgftNLcVeyYhTjXGLsZbRwJbqp9SGp2FtJi8S7U9fJa3oJ1h33Z1FfuY9ozuNuAOG/K/OOwQf6cQCC1dSlqzLHLnNVQCa0DErESNsccKtpnT3vcb1Fa8ofY8GeJrvbBgprCl2QUIItLaV1NOFEDtdClec4uoofewNASnJ76FSSgtPZTa6c0ku5WKfg7qCDJguLlioWvZjNq2tayCBpunlCvg/llnWZZyQCmsGKzIbVl2s5v4wAp10MAevXFV1yV1J64dg3k1luYxdyM1wh9v+kQ
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
- [High] mm: missing replace_free_hugepage_folios() breaks
  alloc_contig_range()
- [High] mm: hugetlb: skipping isolated folios in dequeue breaks resv
  accounting
--

commit bc6da6c8bf105f6ed6558b1313cb2fed9d8b04a8
Author: yangge <yangge1116@126.com>

mm: replace free hugepage folios after migration

This backport updates dequeue_hugetlb_folio_node_exact() in mm/hugetlb.c to
skip free hugetlb folios located in MIGRATE_ISOLATE pageblocks so migration
does not reuse isolated hugepages. However, it omits the
replace_free_hugepage_folios() implementation and call site from the upstre=
am
commit while retaining the upstream commit title and changelog.

Link: https://lkml.kernel.org/r/1734503588-16254-1-git-send-email-yangge111=
6@126.com
Link: https://lkml.kernel.org/r/1736582300-11364-1-git-send-email-yangge111=
6@126.com

[Severity: High]
In mm/hugetlb.c at dequeue_hugetlb_folio_node_exact() (line 1348), this
backport only takes the check for is_migrate_isolate_page(&folio->page) and
omits replace_free_hugepage_folios() along with its call after
__alloc_contig_migrate_range() in alloc_contig_range() (mm/page_alloc.c, li=
ne
6267). Does omitting replace_free_hugepage_folios() leave
alloc_contig_range() and cma_alloc() broken while also shrinking the
persistent hugetlb pool during memory offlining?

When alloc_contig_range() calls start_isolate_page_range() and
__alloc_contig_migrate_range() on a range containing in-use hugetlb folios,
alloc_migration_target() -> alloc_hugetlb_folio_nodemask() (mm/hugetlb.c,
line 2488) checks available_huge_pages(h) and dequeues a free folio from
h->hugepage_freelists[nid] instead of allocating a temporary folio via
alloc_migrate_hugetlb_folio(). Because HPG_temporary is not set on the sour=
ce
folio, when migration finishes and free_huge_folio() (mm/hugetlb.c, line
1945) releases the old folio in the isolated range, enqueue_hugetlb_folio()
places it back onto h->hugepage_freelists[nid] rather than freeing it to the
buddy allocator.

Because isolate_migratepages_block() in mm/compaction.c already advanced pa=
st
the migrated folio and replace_free_hugepage_folios() is never called (even
though alloc_and_dissolve_hugetlb_folio() is already available in
mm/hugetlb.c at line 3050), the freed source folio remains on
h->hugepage_freelists when test_pages_isolated() runs in alloc_contig_range=
()
at line 6297, causing alloc_contig_range() and cma_alloc() to still fail wi=
th
-EBUSY. Moreover, when multiple in-use hugetlb folios are migrated, skipping
MIGRATE_ISOLATE folios in dequeue_hugetlb_folio_node_exact() without
replacing the freed source folios causes each migration to pull another free
pool folio from outside the range into use and leave multiple freed folios =
on
hugepage_freelists inside the isolated range before test_pages_isolated()
fails.

Similarly, during offline_pages() in mm/memory_hotplug.c, when an in-use
hugetlb folio in the offlined range is migrated into a free persistent folio
outside the range, the old source folio is returned to h->hugepage_freelists
inside the offlined range and then dissolved by dissolve_free_huge_pages() =
->
dissolve_free_huge_page() (mm/hugetlb.c, line 2305), which decrements
h->max_huge_pages and shrinks the persistent hugetlb pool. Finally, the
commit subject and changelog still state that replace_free_hugepage_folios()
is introduced and called after migration, which no longer matches the patch.

[Severity: High]
In mm/hugetlb.c at dequeue_hugetlb_folio_node_exact() (line 1348),
is_migrate_isolate_page(&folio->page) skips isolated folios on
h->hugepage_freelists[nid], but those folios remain counted in
h->free_huge_pages. Can this mismatch with available_huge_pages()
(mm/hugetlb.c, line 1398) cause migration to consume reserved free folios,
breaking offline_pages() and causing SIGBUS on reserved hugetlb faults?

Because available_huge_pages(h) returns h->free_huge_pages -
h->resv_huge_pages, any free hugetlb folio in a MIGRATE_ISOLATE pageblock
(either isolated beforehand by start_isolate_page_range() or placed on
h->hugepage_freelists[nid] by free_huge_folio() after migrating an in-use
folio) still inflates available_huge_pages(h) even though
dequeue_hugetlb_folio_node_exact() refuses to dequeue it.

Suppose h->resv_huge_pages is R (backed by R non-isolated free folios) and
1 unreserved free folio is in a MIGRATE_ISOLATE pageblock, so
h->free_huge_pages is R + 1 and available_huge_pages(h) is 1. When
alloc_hugetlb_folio_nodemask() (mm/hugetlb.c, line 2490) runs to migrate the
next in-use hugetlb folio, available_huge_pages(h) is non-zero, so it calls
dequeue_hugetlb_folio_nodemask() -> dequeue_hugetlb_folio_node_exact(), whi=
ch
skips the MIGRATE_ISOLATE folio and dequeues one of the R non-isolated foli=
os
backing h->resv_huge_pages instead of falling back to
alloc_migrate_hugetlb_folio(). Once the migrated source folio is freed into
the MIGRATE_ISOLATE range, available_huge_pages(h) remains 1, allowing
subsequent migrations to move all R reserved folios into the MIGRATE_ISOLATE
range.

When offline_pages() later calls dissolve_free_huge_pages(),
dissolve_free_huge_page() (mm/hugetlb.c, line 2305) dissolves the first
unreserved folio (reducing available_huge_pages(h) to 0 and decrementing
h->max_huge_pages) and then fails with -EBUSY on the remaining isolated free
folios because available_huge_pages(h) is now 0, aborting memory offlining.

In addition, while the free folios backing h->resv_huge_pages sit in
MIGRATE_ISOLATE pageblocks, a page fault on a VMA with a valid reservation
calls alloc_hugetlb_folio() -> dequeue_hugetlb_folio_vma() (mm/hugetlb.c,
line 3113), which returns NULL because dequeue_hugetlb_folio_node_exact()
skips the isolated folios. alloc_hugetlb_folio() then falls back to
alloc_buddy_hugetlb_folio_with_mpol() -> alloc_surplus_hugetlb_folio(), whi=
ch
fails when h->surplus_huge_pages >=3D h->nr_overcommit_huge_pages (0 by
default, and always 0 for gigantic pages), returning -ENOSPC and delivering
SIGBUS to a process faulting on validly reserved hugepages.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261105070431.3100=
950-1-mkbund@amazon.com?part=3D1

