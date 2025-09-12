Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9DB52CA101F
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 03:29:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A033E8E0005; Thu, 11 Sep 2025 23:29:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9DA858E0001; Thu, 11 Sep 2025 23:29:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F0088E0005; Thu, 11 Sep 2025 23:29:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 79E478E0001
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 23:29:37 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 295DBBA668
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 03:29:37 +0000 (UTC)
X-FDA: 83879168394.18.D4AA659
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf18.hostedemail.com (Postfix) with ESMTP id 1DB591C0009
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 03:29:34 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ALXlPibO;
	spf=pass (imf18.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757647775;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=XS6u33nxOdz8zmIuHpnx05q90XDI86YR6KQOnGvzeFk=;
	b=l4NWA/6s86gy4cWRzAE2H8DJyViBVUSgezSLmFMbXwKpFd5E9s2GDB4dKFKHOldOpkWP2X
	2bH1+bStMGDBaByEDzTuLSLyoNcDIAjtECT60wuLHQJcKJQdZC10Pm44NB7EZKnw9lwNxo
	/X+C1rzu7vYDaiLSnk9fVhnjj3P9BEQ=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ALXlPibO;
	spf=pass (imf18.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757647775; a=rsa-sha256;
	cv=none;
	b=ihMXE15fAvJbIseaiiz7mEOMIKx8PAkPkIjLApOna4sFCGB7YiK1bbt8Rd6xKmmlz2OmgR
	fpn3lQxBQp3FQHVKvr2G/on2n1Zm4+zhpvVMt+mxW1yoHdfatXT5snrjcWSRJ+nyc8oYQb
	k6t2jtEEFGDjYeEH+h89FMIC5rPUnGM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757647774;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=XS6u33nxOdz8zmIuHpnx05q90XDI86YR6KQOnGvzeFk=;
	b=ALXlPibOkCTUp7iUcs0umasaR3/IxrWteJWzC4CzABncWKvf11hx0YhdPfjF9dRmUDNb+k
	bewXJSO+1F5xDfUdPWdb+gWV/SR1jZqVNIDX7Gi374wCCg3BlCQfwukmMZj/LsuRNU/gOf
	zS9p07RHcpWY8lKjcQig/3kWebAtCK0=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-149-3TICFVZ8MR6u5KpFCsMWKg-1; Thu,
 11 Sep 2025 23:29:28 -0400
X-MC-Unique: 3TICFVZ8MR6u5KpFCsMWKg-1
X-Mimecast-MFC-AGG-ID: 3TICFVZ8MR6u5KpFCsMWKg_1757647759
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B15661955E88;
	Fri, 12 Sep 2025 03:29:17 +0000 (UTC)
Received: from h1.redhat.com (unknown [10.22.80.28])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 25C571800451;
	Fri, 12 Sep 2025 03:29:03 +0000 (UTC)
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
	kas@kernel.org,
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
	hughd@google.com,
	richard.weiyang@gmail.com,
	lance.yang@linux.dev,
	vbabka@suse.cz,
	rppt@kernel.org,
	jannh@google.com,
	pfalcato@suse.de
Subject: [PATCH v11 00/15] khugepaged: mTHP support
Date: Thu, 11 Sep 2025 21:27:55 -0600
Message-ID: <20250912032810.197475-1-npache@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Rspamd-Queue-Id: 1DB591C0009
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: 5zgexnmud1uxe1uunda87pehaux9714i
X-HE-Tag: 1757647774-160563
X-HE-Meta: U2FsdGVkX18X6NJV3WUKtVJheBh0UVB1cFnJISjmZDS5+0YDR6iXBjzm9lDFFJAumHETRBhytsKeOFavxhMSWu5lGZdFYNUdJzl4/T3v1zy9PcJOrWpjALDoVSaMIscnEkYjB02xl/aTBuo5W6BUoLeDBNOSd4XRAHefPIdkSC+ln/+IaYYjMVMNod4xKkdp9yBiU9AwtiXqCiCxoJrxXJfLjKR+zjAoAnVuOCqHFl12Lctq5Hpn84lyOYLd5jozXsAQNudMZtke0vd6XC8X2ClpnBilFSabMnAtXWyePEKf5oW/Q+Upm97nivCgJiObVO4V9lZUlCOIqRl0VzgxJI8FmW+GHSVRoqr+ZYhVRlDoto42wMT9W4VjHr0V+aS6OJUlwxSsXCqqz+WMj2cDueEU0XbCuCPATHw6K+Aasqpi7lF3SMC87avk+wwgUSG7Lgq/Gpu6j6jFoj4ZPltZk96WXSLubvVXk5c+dJ6SHrcyXJ2y7czLGt61rlNjzY5NOM47jcOoLghwaGO6aNyGvJgo2oe1mEzLXCXIeIADq/tLDwaddxLZYVuQEAlzINsFRpnHr+K0/qRbX2zf8wUqAUs4YTNsE0djN8wHLXm9biFWwbl7h7ms4yuzBJs/m5Y0gaMorMjgnglt2kuoQYdHLh6rf3iGcc+9J4i/0sBfLTJ/wkpXgfQkO9QbkWJOyGhAwLsvHEfElTmrGiGagzeWj3yYtayo9vbNpFETDMEu+FFU38DnHR+Fj1qpTvRVRxH/Q+C0flyVrLORWlMRpRvC7Qmi8jWOtxEtl0QMCjtJWnH0PqgwAzMWkNCQW0cFbhivtoDHhsR6OrsAfRBSPzEVyFlWB87LHwIk3OjJFSkBjU/oRIm02NTSJ8Ls2Rk7HsJvIJsT8QM5+ey4K5bQjymrGmtEQ+1iWn/TahCUMNGCDt3XdizJWVwNXBv+15w8kqtf+MkH6uxskJp+gFZgS/V
 idyY0qge
 Xmn4q4OPK7eB1QejFDkibbXZGqdciKO1a4T6nmMYPQLp5jtCR/Ks9OxPv1IJiPGHlau1Ra21R1rcsG1r7cn33teRtkyd7O5ZxVir6BBLaC2qwgRoVSasTTiNkwi2MWICtZkFsiy5bqA/M7uSLjITPrAAGXxAEcE6U1odZyASdHTenR2raAC3bjLS4Dc/FcKQuq5dMFqBSvQVReGKdLd5X0n24TB/LDhQkI0Gcx4cGwT96Wc5TMTsZqTHJAC+WhxzE+VRIPIrUAUKsyNQFwgzsHsK2p7Yt0b962axqnC4x7ybDSeLSepkLSN2d+6AZoYUdfaQNXVYlZIoGZJeZyxgrneoe5uVR/Osvr8qFCNhBhfagEabbQc7rMhfZSm7Fqf1c1wzTM3x6Ps94ce0/dqJ1NFbq6VtelqdHznr1ZVUxINdXpsNCVKsV7JEH5+3c6YTIYwpc
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
on PMD_ORDER. Then during the PMD scan, we use a bitmap to track individual
pages that are occupied (!none/zero). After the PMD scan is done, we do
binary recursion on the bitmap to find the optimal mTHP sizes for the PMD
range. The restriction on max_ptes_none is removed during the scan, to make
sure we account for the whole PMD range. When no mTHP size is enabled, the
legacy behavior of khugepaged is maintained. max_ptes_none will be scaled
by the attempted collapse order to determine how full a mTHP must be to be
eligible for the collapse to occur. If a mTHP collapse is attempted, but
contains swapped out, or shared pages, we don't perform the collapse. It is
now also possible to collapse to mTHPs without requiring the PMD THP size
to be enabled.

When enabling (m)THP sizes, if max_ptes_none >= HPAGE_PMD_NR/2 (255 on
4K page size), it will be automatically capped to HPAGE_PMD_NR/2 - 1 for
mTHP collapses to prevent collapse "creep" behavior. This prevents
constantly promoting mTHPs to the next available size, which would occur
because a collapse introduces more non-zero pages that would satisfy the
promotion condition on subsequent scans.

Patch 1:     Refactor/rename hpage_collapse
Patch 2:     Refactoring to combine madvise_collapse and khugepaged
Patch 3-7:   Generalize khugepaged functions for arbitrary orders
Patch 8:     skip collapsing mTHP to smaller orders
Patch 9-10:  Add per-order mTHP statistics and tracepoints
Patch 11:    Introduce collapse_allowable_orders
Patch 12-14: Introduce bitmap and mTHP collapse support
Patch 15:    Documentation

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
  (see followup [2] post for more details). We've decided to get the mTHP
  changes merged first before attempting the defer series.
- some basic testing on 64k page size.
- lots of general use.

V11 Changes:
- Minor nits and cleanup/refactoring
- commit messages updates
- split patches to make them easier to review
- added helper functions for checking allowable orders and max_ptes_none
- simplified anon_vma locking tracking to improve code readability
- Added automatic cap to max_ptes_none for mTHP collapse to prevent "creep"
- changed bitmap tracking to use page-level granularity instead of
  chunk-based this removes inaccuracies/complexity
- Improved documentation and comments throughout the series
- Refactored collapse_single_pmd() for better readability
- Added proper WARN_ON_ONCE() instead of BUG_ON() for better error handling
- reordered patches to make them easier to review
- merge Baolins patch to run khugepaged for all orders now that
  collapse_allowable_orders is available

V10: https://lore.kernel.org/lkml/20250819134205.622806-1-npache@redhat.com/
V9 : https://lore.kernel.org/lkml/20250714003207.113275-1-npache@redhat.com/
V8 : https://lore.kernel.org/lkml/20250702055742.102808-1-npache@redhat.com/
V7 : https://lore.kernel.org/lkml/20250515032226.128900-1-npache@redhat.com/
V6 : https://lore.kernel.org/lkml/20250515030312.125567-1-npache@redhat.com/
V5 : https://lore.kernel.org/lkml/20250428181218.85925-1-npache@redhat.com/
V4 : https://lore.kernel.org/lkml/20250417000238.74567-1-npache@redhat.com/
V3 : https://lore.kernel.org/lkml/20250414220557.35388-1-npache@redhat.com/
V2 : https://lore.kernel.org/lkml/20250211003028.213461-1-npache@redhat.com/
V1 : https://lore.kernel.org/lkml/20250108233128.14484-1-npache@redhat.com/

A big thanks to everyone that has reviewed, tested, and participated in
the development process. Its been a great experience working with all of
you on this long endeavour.

[1] - https://gitlab.com/npache/khugepaged_mthp_test
[2] - https://lore.kernel.org/lkml/20250515033857.132535-1-npache@redhat.com/

Baolin Wang (1):
  khugepaged: run khugepaged for all orders

Dev Jain (1):
  khugepaged: generalize alloc_charge_folio()

Nico Pache (13):
  khugepaged: rename hpage_collapse_* to collapse_*
  introduce collapse_single_pmd to unify khugepaged and madvise_collapse
  khugepaged: generalize hugepage_vma_revalidate for mTHP support
  khugepaged: generalize __collapse_huge_page_* for mTHP support
  khugepaged: introduce collapse_max_ptes_none helper function
  khugepaged: generalize collapse_huge_page for mTHP collapse
  khugepaged: skip collapsing mTHP to smaller orders
  khugepaged: add per-order mTHP collapse failure statistics
  khugepaged: improve tracepoints for mTHP orders
  khugepaged: introduce collapse_allowable_orders helper function
  khugepaged: Introduce mTHP collapse support
  khugepaged: avoid unnecessary mTHP collapse attempts
  Documentation: mm: update the admin guide for mTHP collapse

 Documentation/admin-guide/mm/transhuge.rst |  91 ++-
 include/linux/huge_mm.h                    |   5 +
 include/linux/khugepaged.h                 |   2 +
 include/trace/events/huge_memory.h         |  34 +-
 mm/huge_memory.c                           |  11 +
 mm/khugepaged.c                            | 612 ++++++++++++++-------
 mm/mremap.c                                |   2 +-
 7 files changed, 535 insertions(+), 222 deletions(-)

-- 
2.51.0


