Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C26ACD6E7D
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 16:13:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F0826B0005; Fri,  5 Jun 2026 12:13:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C8896B0088; Fri,  5 Jun 2026 12:13:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6DDF56B008C; Fri,  5 Jun 2026 12:13:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 625F66B0005
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 12:13:56 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2C11EA01FF
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 16:13:56 +0000 (UTC)
X-FDA: 84846355272.03.AD0AEF0
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf01.hostedemail.com (Postfix) with ESMTP id 11F434001E
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 16:13:53 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="Icrj/jfx";
	spf=pass (imf01.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780676034;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=A4y+MelSbX2M+ZZatm09vxhIOL+bctnk296UHynr2zs=;
	b=B6ImytBV0EQwzYAyLF72jQbCkRrGVDGOC2JyNgumhM0g9iKvLtDb9/B2uOqxrysBdNW4/R
	PG7jxjcvxvwU5mehJdSIjXhanVI1bNePkpe85rP2dxdbQ72Ww0g6nAeW2Rkl+N50nNgtT6
	/CcR53xyHYRx5/gQ4T9Zk71oS6M4lbc=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="Icrj/jfx";
	spf=pass (imf01.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780676034;
	b=cgHhi0CYWONtAUyct7qaUYBcTz/5Cr+zVmijB/Yvhm7EPm+bFuKJwwaK1S1X7AY6n26egh
	TG8bwoNIHpu+NEC82auD6Yafbb8OuNhgkzE3fci6PVrM08QOLE9H7/rcxbhvJ9UjTnfPYA
	JHkkPcUtujuptYHhLZowSyBn9WXxNRQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780676033;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=A4y+MelSbX2M+ZZatm09vxhIOL+bctnk296UHynr2zs=;
	b=Icrj/jfxAteqQu06E+EJNEZPsTllzSNWf7K46zE1cRE8Uk4EjsnxuuTiCck29d7oEueVVx
	EHu/4NEzehDEH0eS5lILj4WKRO8yuYX/FtpvdxVSvxi6SJVddoplfgztQl/2M6wCTwplWI
	w2/BYALvTSQGIrFagnjsyLWABcrosBU=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-186-t79gN7dFPhahnH4Tg2nCeA-1; Fri,
 05 Jun 2026 12:13:49 -0400
X-MC-Unique: t79gN7dFPhahnH4Tg2nCeA-1
X-Mimecast-MFC-AGG-ID: t79gN7dFPhahnH4Tg2nCeA_1780676024
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 17C1B1956050;
	Fri,  5 Jun 2026 16:13:42 +0000 (UTC)
Received: from p1.redhat.com (unknown [10.44.22.9])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id CF35C180049F;
	Fri,  5 Jun 2026 16:13:17 +0000 (UTC)
From: Nico Pache <npache@redhat.com>
To: linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org
Cc: aarcange@redhat.com,
	akpm@linux-foundation.org,
	anshuman.khandual@arm.com,
	apopple@nvidia.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	byungchul@sk.com,
	catalin.marinas@arm.com,
	cl@gentwo.org,
	corbet@lwn.net,
	dave.hansen@linux.intel.com,
	david@kernel.org,
	dev.jain@arm.com,
	gourry@gourry.net,
	hannes@cmpxchg.org,
	hughd@google.com,
	jack@suse.cz,
	jackmanb@google.com,
	jannh@google.com,
	jglisse@google.com,
	joshua.hahnjy@gmail.com,
	kas@kernel.org,
	lance.yang@linux.dev,
	liam@infradead.org,
	ljs@kernel.org,
	mathieu.desnoyers@efficios.com,
	matthew.brost@intel.com,
	mhiramat@kernel.org,
	mhocko@suse.com,
	npache@redhat.com,
	peterx@redhat.com,
	pfalcato@suse.de,
	rakie.kim@sk.com,
	raquini@redhat.com,
	rdunlap@infradead.org,
	richard.weiyang@gmail.com,
	rientjes@google.com,
	rostedt@goodmis.org,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	shivankg@amd.com,
	sunnanyong@huawei.com,
	surenb@google.com,
	thomas.hellstrom@linux.intel.com,
	tiwai@suse.de,
	usamaarif642@gmail.com,
	vbabka@suse.cz,
	vishal.moola@gmail.com,
	wangkefeng.wang@huawei.com,
	will@kernel.org,
	willy@infradead.org,
	yang@os.amperecomputing.com,
	ying.huang@linux.alibaba.com,
	ziy@nvidia.com,
	zokeefe@google.com
Subject: [PATCH mm-unstable v19 00/14] khugepaged: add mTHP collapse support
Date: Fri,  5 Jun 2026 10:14:07 -0600
Message-ID: <20260605161422.213817-1-npache@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: BkvDDIBRLju3j73I_lAtCvx81eiOmZ89k-9h19uw-o0_1780676024
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 11F434001E
X-Stat-Signature: aifb9kcrgseya8tcwwdjojyaztokpk16
X-Rspam-User: 
X-HE-Tag: 1780676033-431965
X-HE-Meta: U2FsdGVkX19yURg27O6qg5QHQp76DMh5LoAWU9HLv++2cOo1hgVJuni0KqwXMb1b0sORVsahHtB+mlpHweA93Y6+N/1I75pimW0shi3Hg9/7kgRqSfKD5UYunNjM/pMTiPPB34qNuW4g306dHWA5RX6+DBrBPwB1A44YLLdXlEjvmivfB3yA/zDOi3xPMB6ExbAcnwXoE3M0xkkvyp97W9RneJSIKB/m1MgQbp0XFABjryjLVW7Je5JHcfNOcBmzL7dUVOgxqTCfX/Q3xBkR7512gEQOFydJmbbIplBy73XyXAhQotdzgjWtaCyj9ZXmtP67V7XcDHrRUwK0XD07dLvBdR757GEyxeXyU0MlOm8RKnqcQHUta2jNNor5uPtrErxr5RN0oEuDnY+oHghZlGwe2PkBShw/dZzxkpll+Gmw58EAp1iLlCKyZDzElU+OCQry5xbvEJni3SAXPR/O5Oppi9Sceh3xSolWA1ccNatKViitTaIGF71oGS0EFfV9rlmle1qbpQz24R3gpF3rMAVtJbzorAF12XvsBGo9qexPyg2lrNdfqct3YU/TjzJ/Z2bs+2msS0Wt/uJjaarI7veKSk51Qz/k66ELYDC3sRyiU/RXEJi8pfRKnbLvhpFdyRHuqxWhpw+R9pG1uzBKOSQkkXxy+neRWztdTC7fdz3w8bqKjD061BdmqonGNgiMWUbihM96VGxm4Hfi8iK/GbUpwbI07WJVJUE3q099CEchMFfqpa9I5aAE0JnKFPV0rfaf8rAQzAmAcjWZxniry41yjaskK04vjXQptcIzDl1FiQwBK7ywrg1E2gbBCb1PFEHfZtaiktkft9nTwWoPiEyrBxAZRc6VUfDlG0ohKA/QZ9AjUgbALprRjuAA8KIAR+Aez06jWc2ijDRwU6UH/4KPz5z/hV22UpjY3xh7ZlD+XXPOwt40DBNUBAO1NwWdUD1sLwkVdpktVFbxgu6
 4Ply+M7m
 b3NCMPwysAUQYg2d0bBr1JaAsCBRkCmdbQqsaMFA/6WG+ott4BFMCdrfBoymtwMJ8YMSYSduIbS/xfXCb3cqnJMaAcZSVuqTbX6YUKlwEnLXE8P76nmUx81hhGeEKFXKVcInbnRJgfYt4dLNjBm/+hVOEsiMBTrlGkt04beCZk6+LxHj003PJzOvMCeIbrNSNbAPrwfcX7D7e95LGGbdIzmyucH4rDgThMTh4FkczwCiL+T+Fdulvm/ku5oPjfq5RaNRNFUeZXBreECsvIRVudf/zl4dnVgvJcbm7qOAM+wO1p6sEODA6hCUrkLfdrPKQNHKqrTYE62HHRtYzM2nI8mRQYzboiTUMlTT9cyovkYIVqTreO2hYnfV5wpP8xOPQl45kM87D0rBYIImJ0uyjxbXfH8zTutZlKaR+6i8tsdKfER5bXGFIIsqamYOh+TTRLr5Ro9uUi0xNDAQidPFJL1SGqg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The following series provides khugepaged with the capability to collapse
anonymous memory regions to mTHPs.

To achieve this we generalize the khugepaged functions to no longer depend
on PMD_ORDER. Then during the PMD scan, we use a bitmap to track individual
pages that are occupied (!none/zero). After the PMD scan is done, we use
the bitmap to find the optimal mTHP sizes for the PMD range. The
restriction on max_ptes_none is removed during the scan, to make sure we
account for the whole PMD range in the bitmap. When no mTHP size is
enabled, the legacy behavior of khugepaged is maintained.

We currently only support max_ptes_none values of 0 or HPAGE_PMD_NR - 1
(ie 511). If any other value is specified, the kernel will emit a warning
and mTHP collapse will default to max_ptes_none=0. If a mTHP collapse is
attempted, but contains swapped out, or shared pages, we don't perform
the collapse.
It is now also possible to collapse to mTHPs without requiring the PMD THP
size to be enabled. These limitations are to prevent collapse "creep"
behavior. This prevents constantly promoting mTHPs to the next available
size, which would occur because a collapse introduces more non-zero pages
that would satisfy the promotion condition on subsequent scans.

Patch 1-2:   Generalize hugepage_vma_revalidate and alloc_charge_folio
             for arbitrary orders.
Patch 3:     Rework max_ptes_* handling into helper functions
Patch 4:     Generalize __collapse_huge_page_* for mTHP support
Patch 5:     Require collapse_huge_page to enter/exit with the lock dropped
Patch 6:     Generalize collapse_huge_page for mTHP collapse
Patch 7:     Skip collapsing mTHP to smaller orders
Patch 8-9:   Add per-order mTHP statistics and tracepoints
Patch 10:    Introduce collapse_possible_orders helper functions
Patch 11-13: Introduce bitmap and mTHP collapse support, fully enabled
Patch 14:    Documentation

Testing:
- Built for x86_64, aarch64, ppc64le, and s390x
- ran all arches on test suites provided by the kernel-tests project
- internal testing suites: functional testing and performance testing
- selftests mm
- I created a test script that I used to push khugepaged to its limits
   while monitoring a number of stats and tracepoints. The code is
   available here[1] (Run in legacy mode for these changes and set mthp
   sizes to inherit)
   The summary from my testings was that there was no significant
   regression noticed through this test. In some cases my changes had
   better collapse latencies, and was able to scan more pages in the same
   amount of time/work, but for the most part the results were consistent.
- redis testing. I did some testing with these changes along with my defer
  changes (see followup [2] post for more details). We've decided to get
  the mTHP changes merged first before attempting the defer series.
- some basic testing on 64k page size.
- lots of general use.

[1] - https://gitlab.com/npache/khugepaged_mthp_test
[2] - https://lore.kernel.org/lkml/20250515033857.132535-1-npache@redhat.com/

V19 Changes:
- Rebased onto mm-unstable (base: 9282f9bdbdf2, where v18 was based)
- Added RBs/Acks
- [patch 04] Make max_ptes_none const; guard pr_warn_once with
  check so we only warn for non-zero intermediate values and use a single
  "return 0" path (David)
- [patch 06] Add comment explaining the mmu_notifier_range covers only
  the modified PTE range (David); change BUG_ON to VM_WARN_ON_ONCE
  (David); fix update_mmu_cache_range() arch safety issue: reinstall
  PMD via pmd_populate() before calling map_anon_folio_pte_nopf() and
  hold the PTE lock nested inside pmd_ptl during the operation (David,
  Lance); drop the now-unnecessary smp_wmb() as __folio_mark_uptodate()
  provides the required ordering (David, Lance)
- [patch 07] Clarify commit message: "mTHP to a folio of equal or
  smaller size, possibly resulting in a partially mapped source folio"
  (David)
- [patch 08] Add Lorenzo's RB and David's Ack; move TODO comment about
  shared pages to patch 4 (David)
- [patch 10] Rename collapse_allowable_orders() to
  collapse_possible_orders() and add collapse_possible() boolean wrapper
  for callers that only need a yes/no answer (David)
- [patch 11] Major rework: replace the DFS stack-based algorithm with a
  simpler linear forward-walking approach using offset + order (David);
  remove mthp_range struct, mthp_bitmap_stack[], stack push/pop
  functions, and MTHP_STACK_SIZE; add max_order_from_offset() helper
  using __ffs(offset) for natural alignment; rename mthp_bitmap to
  mthp_present_ptes (David); remove temporary mthp_bitmap_mask and use
  bitmap_weight_from() directly (David); fix result propagation so
  mthp_collapse() returns enum scan_result and properly propagates
  SCAN_ALLOC_HUGE_PAGE_FAIL and SCAN_PTE_MAPPED_HUGEPAGE to callers
  (Lance); fold in v18 fixup for potential use-after-free of vma in
  mthp_collapse() by passing NULL to collapse_max_ptes_none()
- [patch 12] Rework to match new linear algorithm; expand the set of
  failures that allow retrying at a lower order
- [patch 14] Re-add note about file/shmem still only collapsing to
  PMD-sized THPs (David)

Baolin Wang (1):
  mm/khugepaged: run khugepaged for all orders

Dev Jain (1):
  mm/khugepaged: generalize alloc_charge_folio()

Nico Pache (12):
  mm/khugepaged: generalize hugepage_vma_revalidate for mTHP support
  mm/khugepaged: rework max_ptes_* handling with helper functions
  mm/khugepaged: generalize __collapse_huge_page_* for mTHP support
  mm/khugepaged: require collapse_huge_page to enter/exit with the lock
    dropped
  mm/khugepaged: generalize collapse_huge_page for mTHP collapse
  mm/khugepaged: skip collapsing mTHP to smaller orders
  mm/khugepaged: add per-order mTHP collapse failure statistics
  mm/khugepaged: improve tracepoints for mTHP orders
  mm/khugepaged: introduce collapse_possible_orders helper functions
  mm/khugepaged: Introduce mTHP collapse support
  mm/khugepaged: avoid unnecessary mTHP collapse attempts
  Documentation: mm: update the admin guide for mTHP collapse

 Documentation/admin-guide/mm/transhuge.rst |  71 ++-
 include/linux/huge_mm.h                    |   5 +
 include/trace/events/huge_memory.h         |  34 +-
 mm/huge_memory.c                           |  11 +
 mm/khugepaged.c                            | 616 ++++++++++++++++-----
 5 files changed, 569 insertions(+), 168 deletions(-)


base-commit: 9282f9bdbdf22a1914f0b085f2fe5e8141cbc3de
-- 
2.54.0


