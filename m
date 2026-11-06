Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BABCE606A329
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 07:04:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IQG2BxQr
Received: by kanga.kvack.org (Postfix)
	id D6CE76B05B5; Fri,  6 Nov 2026 02:04:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D43556B05B6; Fri,  6 Nov 2026 02:04:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C808A6B05B7; Fri,  6 Nov 2026 02:04:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A35216B05B5
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 02:04:48 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2D677120C98
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 07:04:48 +0000 (UTC)
X-FDA: 85403806656.22.74E7A0A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 859F1100010
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 07:04:46 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IQG2BxQr;
	spf=pass (imf05.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793948686;
	b=fyOEdZP7G5cJ2TdJllZBLU2VZa2kf+kw+MfRpBOOK6ZG9bri2faDbc92nFySnTPPngDp/o
	71w3Yzk7szKpJvcV1aKblVoLDS1S/hd/VnUAaeUlv/gvJuz/zIQKGpuMJsM5kRi9yVmXl4
	CcAoltBA5hBwZpcFocl8vUBKC6cNEdA=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IQG2BxQr;
	spf=pass (imf05.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793948686;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zkWSEF3JjPGyKhkbeSaRitsFGRfwe5De57BGkHIE5uM=;
	b=3S6Gz2iOwqio8HS+KvWi6KubxqAJNqm98BqfRfAPwQSn1hbImLLwz2oX3LX1TywyqRojO7
	utljqkxU72HcZKpx/3MMbh055YDrvQ7RBwv3Hei2aBF+b+wBZhPFZrTdjyEipU7XjAeex+
	WibyywWYLrn3y7/V2tfplfbP8h+7w+A=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B628F406B3;
	Fri,  6 Nov 2026 07:04:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31C801F0089F;
	Fri,  6 Nov 2026 07:04:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793948685;
	bh=zkWSEF3JjPGyKhkbeSaRitsFGRfwe5De57BGkHIE5uM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=IQG2BxQrjjLTTFieNDP+y6zSALmjmmJjINPaYp3+3nFPhrH+W2lH0r9yDW4Rj+FRi
	 D83wDAHQ53ZBSvDiuO1z7JMltTeLbAha00EvzAFQ4MXeGcbRqSNDTyBwGTA4RwuERn
	 S2BKOBlB1U/HObQPakDPdvO7tb2ckGEqib3H65mhXgtYlcimT8hWV1hO+VJOb2fa8q
	 ZPB9KhfLKgiw0z59XTCRBI/AhOChqX2t5z7wRKJNCk0nkz28w/5gJmCidpP+/+K19i
	 6tVfW2tx3HbzxnRYX397KiTSm7qwriIcEKHdUj3QSx4rGOtJnddwBWFBv4RIymgDGl
	 /3wt2BwveicVQ==
Message-ID: <sashiko-outbox-200953@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 6.1] mm: replace free hugepage folios after migration
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mark Bundschuh" <mkbund@amazon.com>
Cc: linux-mm@kvack.org, david@kernel.org, yangge <yangge1116@126.com>, "Baolin
 Wang" <baolin.wang@linux.alibaba.com>, "Barry Song" <21cnbao@gmail.com>, "David
 Hildenbrand" <david@redhat.com>, "SeongJae Park" <sj@kernel.org>, "Andrew
 Morton" <akpm@linux-foundation.org>
In-Reply-To: <20261105070346.3099207-1-mkbund@amazon.com>
References: <20261105070346.3099207-1-mkbund@amazon.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 06 Nov 2026 07:04:44 +0000
X-Stat-Signature: 4ine6iokg9g3hgjdzi6d44mfseyo45r5
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 859F1100010
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793948686-221705
X-HE-Meta: U2FsdGVkX18u/xGYVtryO365wqbGsnSRjsSHRER4yHc50OsX1eMAtzkpzKLpKFGU/ZFDMMcOikw3JMTI3ZD7AyVIgECZuXapdgodPwuq21vGz5dyEaAWuN6XDIKfposRyioaaCr/iEnspekDDeNXIdUNYBg/KwicDrmoRLKPou6FbYIz6oLy/o31g0LSNLfh6YLV0yQvjJIs97VnvOtQKwsYImicum3XmhfFwc1Dao4kx/cRWbv+A9B/EPqWgh24njLdB7xHLuxCIVOC8FZEDTlOBXsoA7caXMdrB+iv4jJREsRvk/88keb7vCt5grqA28XAv9v2LE27VYe45hNRf5BtJciWsWy7j3xMQ77HPQUjtD5R88t6SPMhLRtV95pf2Bgb6iBYitSkAqNuaamC8/Xdi4WClza+Ga74TSZYYZ1hEW/ZzZMC2uQfZ2WpVZlHhiB9NS7dCO0VHeyrstTLrAg1ZV8DdCph3fBrnGXW+AVRSkhOhpU7KGgtK6fp1rO7bpvwQyUH4rcbz9wMey+65+Kkl4DUqvaEFQY+GPpI08yTV9att1l6wVrBX2+lIHZfmX1ZajksrOS6TzY2rGtuzzvSt+XJgE9phRwDllFxcUFj6vtis2LF0/LWDHu3dqsG5WV8qQ8QVLNV+cXwWyc7K+nJUp5UmtNdIA+M1f4+iq6W/k7jC8RowUcUHX6Svhuhy+aCtrAue7IpRAI+Y+bt8WC2hzrZFiPvayR3WcL+J3IHBbl8OFnRtFLQBD+YcZs2wpB9HXi9Azb6AnqJNvO7vbwCPDDv74JPmgB+CNZUeoQvXpWvezQgA/EiuOvKmUvjz0zSz26GTB45P66u+PUaSoXRxLhZ2/qeqqSGx1LmyPXxyAV+Agx/oIZMX+rTci7YVmFUBltA0tVLj1P8GL04q8OPovuu2lJelNi0RklCrBE/4sOVLIqlLHV7zPW65DvmsrJ3Cviw1iAYvbEQbN0
 mP0sugle
 W0rAobD9rsax61W02fCD+Nq6sXNDUZmYmiCwt4H0xMtxIxuKy6Wd/PPpOsdqjb/p0f5YiyC5eYRlP0e2QOV/OWwvobjKXDYkBEPDwP1MNVkLyMqWChjua0JW4yAY+hlq1fR8s6ZfD/vFvgK7CEuC2xgeYQrxz6JFH1NwylDNI4YTG7a4DUlemwyRM3D7Et09UiLHtDQ8u+yFTHotkjwt0XYIQ8lAl+0hRbi1NnZKZkXG/MmRDjMaJ9R8xL8SR14LJQXPnQ51/SRtpj4YBNKv9p572egkVWg6Uov+IjUWIfOjGjoE8jN6/BRFAUwJFsccL3HYsC97cEnk2StrZUXpfoXd/T+exxnXcV6yJPlunWqyj6XicZ7GUVnNFs/2PBqh1Io81Pw7dY7ZHd+KVb2YKhE+C6kYNJ6b41V0hKmtL/3oVpPwNw3Z2z2oJm3Vo10L8tBqeD4ZiDh+fPHXh6Y4NFC3KEmy2hYmEVM69o8pORJotAT2kp4Ld1xZsNhDwhbXiFoua6vflI8vHYaKr3xJypY6HIcojgp7c7FKrA7ClckxMo2ireoUEeCS/+fvIEhNUYPK1jYgS31qxnW8UZiIHH/BlNn4qPsu1zsDxgnI5OJPBtH5qjPRXNSUWz51jUA97SdVXSELt7+XwiebBirKJLx4j8KnG+P6czEFQ
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
- [High] mm: hugetlb: skipping isolated free pages in
  dequeue_huge_page_node_exact() breaks reservation accounting
- [Medium] mm: omitted replace_free_hugepage_folios() leaves cma_alloc()
  broken
--

commit dac0c7128f296db4178dac403221b3262724e8f6
Author: yangge <yangge1116@126.com>

mm: replace free hugepage folios after migration

This backport of upstream commit 04f13d241b8b146b23038bffd907cb8278391d07
updates dequeue_huge_page_node_exact() in mm/hugetlb.c to skip free hugepag=
es
located in MIGRATE_ISOLATE pageblocks so that isolated free hugepages are n=
ot
reused during migration.

Link: https://lkml.kernel.org/r/1734503588-16254-1-git-send-email-yangge111=
6@126.com
Link: https://lkml.kernel.org/r/1736582300-11364-1-git-send-email-yangge111=
6@126.com

[Severity: Medium]
The commit title and changelog describe introducing and calling
replace_free_hugepage_folios() after migrating in-use hugetlb pages in
__alloc_contig_migrate_range(), but this 6.1 backport only keeps the
is_migrate_isolate_page(page) check in dequeue_huge_page_node_exact() at
mm/hugetlb.c:1347.

In __alloc_contig_migrate_range() at mm/page_alloc.c:9231, when an in-use
hugetlb page in the target range [start, end) is migrated while
available_huge_pages(h) > 0 and a non-isolated free hugepage exists on
h->hugepage_freelists, alloc_migration_target() -> alloc_huge_page_nodemask=
()
dequeues that persistent pool page without HPageTemporary set. When migrati=
on
completes, free_huge_page() at mm/hugetlb.c:1978 enqueues the old source pa=
ge
back onto h->hugepage_freelists[nid] instead of freeing it to the buddy
allocator.

Because replace_free_hugepage_folios() was omitted from this backport (even
though 6.1 already has __alloc_contig_migrate_range() in mm/page_alloc.c and
alloc_and_dissolve_huge_page() in mm/hugetlb.c), the old source page remain=
s a
PageHuge page rather than PageBuddy inside [start, end). Won't
test_pages_isolated() in alloc_contig_range() at mm/page_alloc.c:9366 and t=
he
!PageBuddy(pfn_to_page(outer_pfn)) check in isolate_single_pageblock() at
mm/page_isolation.c:439 still fail with -EBUSY, leaving the cma_alloc()
failure described in the commit message unresolved?

[Severity: High]
In dequeue_huge_page_node_exact() at mm/hugetlb.c:1347, skipping pages where
is_migrate_isolate_page(page) is true leaves those isolated free hugepages =
on
h->hugepage_freelists[nid] and still counted in h->free_huge_pages.

However, available_huge_pages() at mm/hugetlb.c:1397 still computes
h->free_huge_pages - h->resv_huge_pages without discounting isolated free
hugepages. Can this cause two regressions in reservation accounting?

First, when a free hugepage backing h->resv_huge_pages lies in a
MIGRATE_ISOLATE pageblock (either isolated in place by
start_isolate_page_range() during offline_pages() or alloc_contig_range(), =
or
placed there after migration), a page fault on a VMA with a valid reservati=
on
calls hugetlb_no_page() -> alloc_huge_page() at mm/hugetlb.c:3139 ->
dequeue_huge_page_vma() -> dequeue_huge_page_node_exact(). Because
dequeue_huge_page_node_exact() skips the isolated page, dequeue_huge_page_v=
ma()
returns NULL and alloc_huge_page() falls back to
alloc_buddy_huge_page_with_mpol() -> alloc_surplus_huge_page() at
mm/hugetlb.c:2456. When h->surplus_huge_pages >=3D h->nr_overcommit_huge_pa=
ges
(which is 0 by default) or hstate_is_gigantic(h), alloc_huge_page() returns
ERR_PTR(-ENOSPC), delivering SIGBUS to a process faulting on a reserved map=
ping.

Second, during offline_pages(), suppose an unreserved free hugepage H0 is in
the MIGRATE_ISOLATE range (for example, after an in-use hugepage H0 was
migrated to an unreserved pool page and freed via free_huge_page() ->
enqueue_huge_page()) and another free hugepage F2 outside the isolated range
backs a reservation (h->free_huge_pages =3D=3D 2, h->resv_huge_pages =3D=3D=
 1).
Because H0 is still counted in h->free_huge_pages, available_huge_pages(h)
remains 1. When migrating a second in-use hugepage H1 via
alloc_huge_page_nodemask() at mm/hugetlb.c:2546 (or during a concurrent
unreserved fault in dequeue_huge_page_vma() at mm/hugetlb.c:1417),
available_huge_pages(h) is non-zero, so dequeue_huge_page_nodemask() is cal=
led,
skips the isolated H0 in dequeue_huge_page_node_exact(), and consumes the
non-isolated reserved page F2 instead of falling back to
alloc_migrate_huge_page(). H1 is then freed onto h->hugepage_freelists insi=
de
the isolated range, leaving only isolated pages on the freelist to back
h->resv_huge_pages. When offline_pages() subsequently calls
dissolve_free_huge_pages() -> dissolve_free_huge_page() at mm/hugetlb.c:235=
9,
won't it dissolve H0 and then fail on H1 with -EBUSY because
!available_huge_pages(h)?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261105070346.3099=
207-1-mkbund@amazon.com?part=3D1

