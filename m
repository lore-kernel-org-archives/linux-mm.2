Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0AD1CD4840
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 18:58:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B92766B00D0; Mon, 11 May 2026 14:58:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B44006B00D3; Mon, 11 May 2026 14:58:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A0B5E6B00D4; Mon, 11 May 2026 14:58:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8E0336B00D0
	for <linux-mm@kvack.org>; Mon, 11 May 2026 14:58:21 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1C4268B82C
	for <linux-mm@kvack.org>; Mon, 11 May 2026 18:58:21 +0000 (UTC)
X-FDA: 84756049602.19.258CCB6
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf14.hostedemail.com (Postfix) with ESMTP id 369A1100008
	for <linux-mm@kvack.org>; Mon, 11 May 2026 18:58:19 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=KJFJEjjj;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf14.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778525899;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=oNsjune8AgX3ZJqUXwC46MzLj/0i13SmM4jWdVs6uOE=;
	b=pp8A6/7DoE47JwaelbZuJGHq7vSQnDkAmaYUAI3+qQ/kEdPNClYDbl16XFb6UJcvM/AMDU
	vIlE2y6UDwtPHcWUqzVcT9qen3hxOxzm+OTYZLrL63dYW8itT6J+dhrfBb2do39XnGMVsJ
	9rLKcAvsw6T5bXkvYUn/NhLxCLcZVxo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778525899; a=rsa-sha256;
	cv=none;
	b=M69R9Xx2uGmrnKzWADgnaNLh7K1UAuys9UefgG8sk4TakSAnhUcp/7LHGsLqNoYycHWS1Q
	FsOIGe0up9grKL8Y7GTsXjyWxN2TG67iXDBd5bxz/29I6noYIYjjWGi1ExaXEGEnqTJ0QB
	RPAcNc3TibQ8MPZmyIVq5x0FGzB6wB4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=KJFJEjjj;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf14.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778525898;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=oNsjune8AgX3ZJqUXwC46MzLj/0i13SmM4jWdVs6uOE=;
	b=KJFJEjjjGJCFj++pZK3TNcp8/S4Zk0nYMqaWCcySHNLRx8t6adbrEjv+jQDKwV7Tg33xx9
	QVzNnNttQcwpsJmh+30ETMWG+BhSMp2j2XVokdLbachP9IbXGP4ehwTBuAU1zw/DRAMa58
	n6ekpM8KFIztxjRGJpe1pzxffjPtwe8=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-515-tt0echXXOgCZmqxLDI90bQ-1; Mon,
 11 May 2026 14:58:14 -0400
X-MC-Unique: tt0echXXOgCZmqxLDI90bQ-1
X-Mimecast-MFC-AGG-ID: tt0echXXOgCZmqxLDI90bQ_1778525889
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8D57C19560B5;
	Mon, 11 May 2026 18:58:06 +0000 (UTC)
Received: from p1.redhat.com (unknown [10.44.22.3])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 49CDC30001BE;
	Mon, 11 May 2026 18:57:43 +0000 (UTC)
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
Subject: [PATCH mm-unstable v17 00/14] khugepaged: mTHP support
Date: Mon, 11 May 2026 12:58:00 -0600
Message-ID: <20260511185817.686831-1-npache@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: oE2ke4fKEuOfGOiUrtR2LTtxAd62gVubj6kiHvzpEOs_1778525889
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 369A1100008
X-Stat-Signature: cbc9exei6o9ccgsj9nqcr55fh3389ugs
X-Rspam-User: 
X-HE-Tag: 1778525899-890466
X-HE-Meta: U2FsdGVkX18eVtYyIkTblDZ/69OfN1lEtXRGM+SVjHCNaRpQx7j3qRptAFcufvrYMVkdKY6Dd08qasgVrufDxxwG5vdfDOVFSdmhDpyXN2m/nvtGzUZMlxYK1A7NrjFGIHZcrboPuEJnbNyRm1Avp616loFnEenl7LKLTaXus3RrP98LilMEvHefYl5jR3lJSoWWAQlTTMEK23K0+uEkqAh4QCneCfzGFd6A130iefRivYvmzgRZ363X5yLOS/2Hh2WVaZqo8vyvSOew3Mjiss7LLyZ1dq6EpwK8tDHxo2gckz4AsJEn97ZXZcJa1OA/rux5ebv/l5zmByUMtOjnvIoxvxlhj4oYRTeWyGJapJ5t7Ivh7vQ78Gg6Gfko5j0VLxs2O3xjvcV+KL79d+sQ3BsupMoOCQEhm/dBjJfEntW/u65TJqZSF5WI116iCex9mE7tx6B2LOgd1uUOt1pDyWxex3rPuQXXbcUBl2S8Vn9pysM70wdrGo+Iz/HjQwEyUnaNFnxuXXrJeuSN1b4WI/EhL6xZfOLNnloaADO8g6Gqbc0Nsk48qFlTEw2qt5q8HvWE5/NQ9Z4mf8C0iE9er2gE0mgbHuGPqISA81ddQG+hl94nAyuudJY6m5gdNsWuDQ5gmVVU81t8TTVr+eUxBkKsquLSC1hXTVcQl3GwV4ZPoGwM3DS8IiNgBGgAbtSr2kb2dCmRIXdLw9Fx0NoTJA2ngZzGWdP7QVJRQzonhZ83U4zDRbleIc4dS2p5yCaE/phifoDoOka4u2EC/UuDqgJM5x19ktYPa1Q3oL+lVn6ixRcl89iEQdpOW59RO9c2hEJkuyLPifcJ49qRChM3umTBMQePZEpIl94u/WQ7KxDGl+/nCXlfJfkn/NMJsxmpc7FIYUQqB5D4p4T+unN1ryqFie+J82gT0XjDz8oXkMBpO3xhzDmkGLYe+Oi5fqlqS8FyKQJn5gXJp0jAypH
 3t1mjvjQ
 FgoKnji/00gfQpnUEPtkNhrVqHoo5f5w1WLUZymTDABLTGL7/lmiJ1aVRzOKYnpTY7vbh+RCwaR5TyWXYQTjdydi/uCmrjnQNpSVdV8MqS6+ECubQLkbjJMRSWpdvX37r9uaVQil7MrihEms2uMe9mbhCC/PCbglvdRb2LNiNah4Wq4lP1Uul8NTZGkzcVsdXo40gkkOWMPrGJRHvMPZqPBSMv/J2ewNY/XSKpDuiemwJ8REbsrCNJHsFrlXRnhgeDW0VkI8HC1tR1ajXxC2BtmLFFyrRhPLI/tWYg5eSfviOWOncfUKyGY0JthzMUHu/vTq0zxvd4Hc8UoqxF1nMWwK7iprxXc90/2x8JxzMi4VZJJG6Nz96iCbYSdgusHnEXWQPCvsVzzuxzgBjdL0eYsaJajBrBBgTwMX2OnWWDLEYEC41zeKftC4QftKMFWE3kVKItccvTcuPIRw=
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
and no mTHP collapse will be attempted. If a mTHP collapse is attempted,
but contains swapped out, or shared pages, we don't perform the collapse.
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
Patch 10:    Introduce collapse_allowable_orders helper function
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

V17 Changes:
- Added Acks/RB
- New patch(5): split the mmap_read_unlock() locking contract change out of
  "generalize collapse_huge_page" into its own patch; add a comment
  documenting the enter/exit-with-lock-dropped contract (Usama, David)
- [patch 03] Add const to max_ptes_none/shared/swap variables; improve the
  three helper docstrings; replace the paragraphs with inline comments;
  note that sysctl values are now snapshotted once per scan (Usama, David)
- [patch 04] Add SCAN_INVALID_PTES_NONE result code and return it instead
  of SCAN_FAIL when collapse_max_ptes_none() returns -EINVAL (Usama);
  snapshot khugepaged_max_ptes_none into a local variable to fix race on
  the two comparisons (Usama); clean up mTHP docstring paragraphs into
  inline comments; fix commit message wording (David)
- [patch 06] Remove /* PMD collapse */ and /* mTHP collapse */ comments
  (David); move const declarations to top of variable list (David); add
  comment explaining that map_anon_folio_pte_nopf() calls set_ptes under
  pmd_ptl and is safe because PMD is expected to be none (Usama)
- [patch 08] Shorten sysfs counter documentation for
  collapse_exceed_swap/shared_pte to concise one-liners; trim
  collapse_exceed_none_pte description; fix "dont" → "do not" (David)
- [patch 10] Keep vm_flags parameter in khugepaged_enter_vma() and
  collapse_allowable_orders() rather than dropping it and reading
  vma->vm_flags internally; pass vm_flags explicitly at all three
  collapse_allowable_orders() call sites (David, sashskio)
- [patch 11] Fix MTHP_STACK_SIZE: was exponential (~128); correct formula
  is (height + 1) for a DFS on a binary tree rewrite comment to explain
  the DFS sizing (sashskio)
- [patch 12] Replace SCAN_PAGE_LRU with SCAN_PAGE_LAZYFREE in the
  "goto next_order" early-bail cases; non-LRU page failures cannot be
  recovered at any order and belong in the default (return) path
- [patch 13] Use tva_flags == TVA_KHUGEPAGED (strict equality) instead of
  tva_flags & TVA_KHUGEPAGED; flatten nested if into single condition;
  retain vm_flags parameter; pass vm_flags to collapse_allowable_orders()

V16: https://lore.kernel.org/all/20260419185750.260784-1-npache@redhat.com
V15: https://lore.kernel.org/all/20260226031741.230674-1-npache@redhat.com
V14: https://lore.kernel.org/all/20260122192841.128719-1-npache@redhat.com
V13: https://lore.kernel.org/all/20251201174627.23295-1-npache@redhat.com
V12: https://lore.kernel.org/all/20251022183717.70829-1-npache@redhat.com
V11: https://lore.kernel.org/all/20250912032810.197475-1-npache@redhat.com
V10: https://lore.kernel.org/all/20250819134205.622806-1-npache@redhat.com
V9 : https://lore.kernel.org/all/20250714003207.113275-1-npache@redhat.com
V8 : https://lore.kernel.org/all/20250702055742.102808-1-npache@redhat.com
V7 : https://lore.kernel.org/all/20250515032226.128900-1-npache@redhat.com
V6 : https://lore.kernel.org/all/20250515030312.125567-1-npache@redhat.com
V5 : https://lore.kernel.org/all/20250428181218.85925-1-npache@redhat.com
V4 : https://lore.kernel.org/all/20250417000238.74567-1-npache@redhat.com
V3 : https://lore.kernel.org/all/20250414220557.35388-1-npache@redhat.com
V2 : https://lore.kernel.org/all/20250211003028.213461-1-npache@redhat.com
V1 : https://lore.kernel.org/all/20250108233128.14484-1-npache@redhat.com

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
  mm/khugepaged: introduce collapse_allowable_orders helper function
  mm/khugepaged: Introduce mTHP collapse support
  mm/khugepaged: avoid unnecessary mTHP collapse attempts
  Documentation: mm: update the admin guide for mTHP collapse

 Documentation/admin-guide/mm/transhuge.rst |  71 ++-
 include/linux/huge_mm.h                    |   5 +
 include/trace/events/huge_memory.h         |  37 +-
 mm/huge_memory.c                           |  11 +
 mm/khugepaged.c                            | 625 ++++++++++++++++-----
 5 files changed, 579 insertions(+), 170 deletions(-)


base-commit: e9dd96806dbc2d50a66770b6a86962bd5d601153
-- 
2.54.0


