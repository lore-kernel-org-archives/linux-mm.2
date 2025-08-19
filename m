Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EEC2CA0EEB
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 13:43:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 762256B00E5; Tue, 19 Aug 2025 09:43:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 712EF6B00E8; Tue, 19 Aug 2025 09:43:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 601B26B00E9; Tue, 19 Aug 2025 09:43:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 46BFC6B00E5
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 09:43:08 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A92D483C2B
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 13:43:07 +0000 (UTC)
X-FDA: 83793623214.26.AE2223C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf19.hostedemail.com (Postfix) with ESMTP id 058521A0003
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 13:43:05 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=aj03gU+M;
	spf=pass (imf19.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755610986;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=FJ3ypUlMzXz2IhKZB9gKLujpc2LItSundB12cO28tq8=;
	b=2IBXEaLIEhdHMmNflyER8kk+9lHYNNjyI4SIZzJdiGDVWRUWQUlH+vdxcI1R7u2VdaJee8
	/QG8PStHziJgi4QOqD1KzaZ2UlnM00sJNQnI6r6+KcQ/S3q67PFN9vkfMeeP57dvdcNWf8
	h4zYnrEy5JdBJNxAD46PYIO0o4toiuY=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=aj03gU+M;
	spf=pass (imf19.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755610986; a=rsa-sha256;
	cv=none;
	b=nLRH7K1eUrv2E5nncD/FvdtvkWCL85TpXldQD8FeEnxIb9t/PwD+f0i4a5x2rvyc/UhJDl
	2o723qHtvpwNgv40fl8qq/iJ/oH+JSNC8zbxFoCQflIX4X0ny4bseLMjYy7VALLiZJSMLP
	nuxij2BE9svkp2dwdMTRVBZBLNStuc4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755610985;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=FJ3ypUlMzXz2IhKZB9gKLujpc2LItSundB12cO28tq8=;
	b=aj03gU+M7+lsNsTCidu6sNk9Q/XFR7fEtl/n2ELOS93UnsAe2K27jVrI4TCng198zcSrIl
	2RfIibzJmJVBNfDlBQTWvg+s/fCed5t3VujhH5W9ChjU1b94hlkY4aiC18cO8Oi6WfDzw9
	BtpUOQ1HtAnVSYV+whEM+rLk1gtAyVs=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-232-C-RlPLunMhS_zJhtzEPiHg-1; Tue,
 19 Aug 2025 09:42:57 -0400
X-MC-Unique: C-RlPLunMhS_zJhtzEPiHg-1
X-Mimecast-MFC-AGG-ID: C-RlPLunMhS_zJhtzEPiHg_1755610973
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 930E81955BE4;
	Tue, 19 Aug 2025 13:42:51 +0000 (UTC)
Received: from h1.redhat.com (unknown [10.22.64.137])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7B62319560AB;
	Tue, 19 Aug 2025 13:42:30 +0000 (UTC)
From: Nico Pache <npache@redhat.com>
To: linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org
Cc: david@redhat.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	corbet@lwn.net,
	rostedt@goodmis.org,
	mhiramat@kernel.org,
	mathieu.desnoyers@efficios.com,
	akpm@linux-foundation.org,
	baohua@kernel.org,
	willy@infradead.org,
	peterx@redhat.com,
	wangkefeng.wang@huawei.com,
	usamaarif642@gmail.com,
	sunnanyong@huawei.com,
	vishal.moola@gmail.com,
	thomas.hellstrom@linux.intel.com,
	yang@os.amperecomputing.com,
	kirill.shutemov@linux.intel.com,
	aarcange@redhat.com,
	raquini@redhat.com,
	anshuman.khandual@arm.com,
	catalin.marinas@arm.com,
	tiwai@suse.de,
	will@kernel.org,
	dave.hansen@linux.intel.com,
	jack@suse.cz,
	cl@gentwo.org,
	jglisse@google.com,
	surenb@google.com,
	zokeefe@google.com,
	hannes@cmpxchg.org,
	rientjes@google.com,
	mhocko@suse.com,
	rdunlap@infradead.org,
	hughd@google.com
Subject: [PATCH v10 00/13] khugepaged: mTHP support
Date: Tue, 19 Aug 2025 07:41:52 -0600
Message-ID: <20250819134205.622806-1-npache@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Rspamd-Queue-Id: 058521A0003
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: wemx4yg54cz7n7imkwkbapok8xrg7aks
X-HE-Tag: 1755610985-126601
X-HE-Meta: U2FsdGVkX1/GdTSROExXN29P2pMdR2GmerWKYbg4VVak1MWycMACASCPnb05vBBgjpIxixGLExmJP0Db5vju54B6ndfQ6sMJxHPA2nnMbWPoIUVjdpeeqq8X+pbXdlr7nJqghYAQ/q2kthnZ5yU3wCsMGUphjPV2khq3sMs38vCf8Fdv+Xzq++O2U6w2nM7byesPzWSaHZH3AVSyaWAOUPgrI2pZ372aCeruipGQxfXF+RCTOFuCIphZKed2J1Mu2j1+SFUT9N0pxSX4DUg4KAy61vLDqJBRcBu/FlmolqVSOVjKo7pHeLaKBEdT/ZSJGZPQyBSiNu/WXyxwpzRjyS0RxkpKwJ6WUs8AzBFOrmazakCyW6Z3HMa/aPFlxfbhl0UEmUlOn/p//MqTouWOCx0sFodWxSYmAm7LJbl/KRSv7MDMgysZZu6H8aeS1I70O8BF1sZfJmtJ+SKa3kNRGqY07n3qmBY7LMJRBZWLVGtKUyQ6b552t5egsUd3MRqVwfKsvf80xilScRxOHMJdcVl4sJhzvfxsQyc9g7KotNy55NUN0HWrYZmm+uJzTfldsCnMETqnpaYxlBtM3696VS7Zp7jR9/JPHvFkWQHDea8gHgdEgmkQj6+PYrrSX9N9EaW/wM2Ij/+VFTfcRLpphZsca4fnDi3CuT4gM7hh23fO26A/1rKqNSKvOo5LaMWVS0GojhMcJIBpPH1YHgthvmZMb1WOgSEbN/LqJMeNGmcyERpOqUYgrvsO+p6W+cbVH2GL23aAJlqa0wJI5XpgY80c83xt5ZNVDpaZUiYF8j1sPscUo1ZYyOdMcqaS900jI5B8ftXL9DlMS+WvlcvYszARn4Sspx0cXme999V+7apbor1S8qGrnQBNmE7OogXgKcl+zrgcZeI2SDIZqYlUcYA/GXbv7sopEcYMEV3LhNeGFw0U7zIpsDR9pDdIs6b0St+yY8a3hfyTTdsLiYp
 pEbZk6nF
 ynYJmmw07/9+m9MiMitHjsHJU1oEq9Ac887h32PpGJtyy+foqMY9U3WamS7TbI9xe2xGgg0ed4rJ0dgMG2b+NNSIa1xxHkrZgvLfmLKZDhxHeL43Vd4iXsDscT+Y2nhS+BDyyQMXrGXoJbwFfTUdt2FruvbqQi89GIMK6roYxBffSueW7K9dPvWKwpv3fZkoWrix3RTcTtWtbSXdWWbMK/22ZJ/zeHUeKWB5sCJf5iaWTxP4U8hC5I/H1OMfSSU54szM1WnbwEg0ku9D11dDJht0y8/D8W6Gb5LGIWzAIp6tiCyF+63UaS8gb2fQ7LJeAeyXDl5vL3S9wvjpNyrufs7Y3pzvG3+WTL28NpOG5iDWpP6CXU2gwG8J9TpSP7vBdreSXjt/2dBSng1yyWx4SHweh3s8q0tScQOBbMe1KRFJyI8ykGydCIV1QzTlRoVpHTcGl
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The following series provides khugepaged with the capability to collapse
anonymous memory regions to mTHPs.

To achieve this we generalize the khugepaged functions to no longer depend
on PMD_ORDER. Then during the PMD scan, we use a bitmap to track chunks of
pages (defined by KHUGEPAGED_MTHP_MIN_ORDER) that are utilized. After the
PMD scan is done, we do binary recursion on the bitmap to find the optimal
mTHP sizes for the PMD range. The restriction on max_ptes_none is removed
during the scan, to make sure we account for the whole PMD range. When no
mTHP size is enabled, the legacy behavior of khugepaged is maintained.
max_ptes_none will be scaled by the attempted collapse order to determine
how full a mTHP must be to be eligible for the collapse to occur. If a
mTHP collapse is attempted, but contains swapped out, or shared pages, we
don't perform the collapse. It is now also possible to collapse to mTHPs
without requiring the PMD THP size to be enabled.

With the default max_ptes_none=511, the code should keep its most of its
original behavior. When enabling multiple adjacent (m)THP sizes we need to
set max_ptes_none<=255. With max_ptes_none > HPAGE_PMD_NR/2 you will
experience collapse "creep" and constantly promote mTHPs to the next
available size. This is due the fact that a collapse will introduce at
least 2x the number of pages, and on a future scan will satisfy the
promotion condition once again.

Patch 1:     Refactor/rename hpage_collapse
Patch 2:     Some refactoring to combine madvise_collapse and khugepaged
Patch 3-5:   Generalize khugepaged functions for arbitrary orders
Patch 6-8:   The mTHP patches
Patch 9-10:  Allow khugepaged to operate without PMD enabled
Patch 11-12: Tracing/stats
Patch 13:    Documentation

---------
 Testing
---------
- Built for x86_64, aarch64, ppc64le, and s390x
- selftests mm
- I created a test script that I used to push khugepaged to its limits
   while monitoring a number of stats and tracepoints. The code is
   available here[1] (Run in legacy mode for these changes and set mthp
   sizes to inherit)
   The summary from my testings was that there was no significant
   regression noticed through this test. In some cases my changes had
   better collapse latencies, and was able to scan more pages in the same
   amount of time/work, but for the most part the results were consistent.
- redis testing. I tested these changes along with my defer changes
  (see followup [4] post for more details). We've decided to get the mTHP
  changes merged first before attempting the defer series.
- some basic testing on 64k page size.
- lots of general use.

V10 Changes:
- Fixed bug where bitmap tracking was off by one leading to weird behavior
  in some test cases.
- Track mTHP stats for PMD order too (Baolin)
- indentation cleanup (David)
- add review/ack tags
- Improve the control flow, readability, and result handling in
  collapse_scan_bitmap (Baolin)
- Indentation nits/cleanup (David)
- Converted u8 orders to unsigned int to be consistent with other folio
  callers (David)
- Handled conflicts with Devs work on pte batching
- Changed SWAP/SHARED restriction comments to a TODO comment (David)
- Squashed main mTHP patch and the introduce bitmap patch (David)
- Other small nits

V9 Changes: [3]
- Drop madvise_collapse support [2]. Further discussion needed.
- Add documentation entries for new stats (Baolin)
- Fix missing stat update (MTHP_STAT_COLLAPSE_EXCEED_SWAP) that was
  accidentally dropped in v7 (Baolin)
- Fix mishandled conflict noted in v8 (merged into wrong commit)
- change rename from khugepaged to collapse (Dev)

V8 Changes:
- Fix mishandled conflict with shmem config changes (Baolin)
- Add Baolin's patches for allowing collapse without PMD enabled
- Add additional patch for allowing madvise_collapse without PMD enabled
- Documentations nits (Randy)
- Simplify SCAN_ANY_PROCESS lock jumbling (Liam)
- Add a BUG_ON to the mTHP collapse similar to PMD (Dev)
- Remove doc comment about khugepaged PMD only limitation (Dev)
- Change revalidation function to accept multiple orders
- Handled conflicts introduced by Lorenzo's madvise changes

V7 (RESEND)

V6 Changes:
- Dont release the anon_vma_lock early (like in the PMD case), as not all
  pages are isolated.
- Define the PTE as null to avoid a uninitilized condition
- minor nits and newline cleanup
- make sure to unmap and unlock the pte for the swapin case
- change the revalidation to always check the PMD order (as this will make
  sure that no other VMA spans it)

V5 Changes:
- switched the order of patches 1 and 2
- fixed some edge cases on the unified madvise_collapse and khugepaged
- Explained the "creep" some more in the docs
- fix EXCEED_SHARED vs EXCEED_SWAP accounting issue
- fix potential highmem issue caused by a early unmap of the PTE

V4 Changes:
- Rebased onto mm-unstable
- small changes to Documentation

V3 Changes:
- corrected legacy behavior for khugepaged and madvise_collapse
- added proper mTHP stat tracking
- Minor changes to prevent a nested lock on non-split-lock arches
- Took Devs version of alloc_charge_folio as it has the proper stats
- Skip cases were trying to collapse to a lower order would still fail
- Fixed cases were the bitmap was not being updated properly
- Moved Documentation update to this series instead of the defer set
- Minor bugs discovered during testing and review
- Minor "nit" cleanup

V2 Changes:
- Minor bug fixes discovered during review and testing
- removed dynamic allocations for bitmaps, and made them stack based
- Adjusted bitmap offset from u8 to u16 to support 64k pagesize.
- Updated trace events to include collapsing order info.
- Scaled max_ptes_none by order rather than scaling to a 0-100 scale.
- No longer require a chunk to be fully utilized before setting the bit.
   Use the same max_ptes_none scaling principle to achieve this.
- Skip mTHP collapse that requires swapin or shared handling. This helps
   prevent some of the "creep" that was discovered in v1.

A big thanks to everyone that has reviewed, tested, and participated in
the development process. Its been a great experience working with all of
you on this long endeavour.

[1] - https://gitlab.com/npache/khugepaged_mthp_test
[2] - https://lore.kernel.org/all/23b8ad10-cd1f-45df-a25c-78d01c8af44f@redhat.com/
[3] - https://lore.kernel.org/lkml/20250714003207.113275-1-npache@redhat.com/
[4] - https://lore.kernel.org/lkml/20250515033857.132535-1-npache@redhat.com/

Baolin Wang (2):
  khugepaged: enable collapsing mTHPs even when PMD THPs are disabled
  khugepaged: kick khugepaged for enabling none-PMD-sized mTHPs

Dev Jain (1):
  khugepaged: generalize alloc_charge_folio()

Nico Pache (10):
  khugepaged: rename hpage_collapse_* to collapse_*
  introduce collapse_single_pmd to unify khugepaged and madvise_collapse
  khugepaged: generalize hugepage_vma_revalidate for mTHP support
  khugepaged: generalize __collapse_huge_page_* for mTHP support
  khugepaged: add mTHP support
  khugepaged: skip collapsing mTHP to smaller orders
  khugepaged: avoid unnecessary mTHP collapse attempts
  khugepaged: improve tracepoints for mTHP orders
  khugepaged: add per-order mTHP khugepaged stats
  Documentation: mm: update the admin guide for mTHP collapse

 Documentation/admin-guide/mm/transhuge.rst |  44 +-
 include/linux/huge_mm.h                    |   5 +
 include/linux/khugepaged.h                 |   4 +
 include/trace/events/huge_memory.h         |  34 +-
 mm/huge_memory.c                           |  11 +
 mm/khugepaged.c                            | 552 +++++++++++++++------
 6 files changed, 468 insertions(+), 182 deletions(-)

-- 
2.50.1


