Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B741D6CFA3
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 19:30:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 45C656B031C; Thu, 22 Jan 2026 14:30:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 386C56B031F; Thu, 22 Jan 2026 14:30:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 221726B0320; Thu, 22 Jan 2026 14:30:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0A3086B031C
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 14:30:16 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AA18813C05B
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 19:30:15 +0000 (UTC)
X-FDA: 84360590790.27.F0457E3
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf24.hostedemail.com (Postfix) with ESMTP id A4355180003
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 19:30:13 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=OC6oKrhD;
	spf=pass (imf24.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769110214;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=FnDUt3RW6I9OygzbiFWmiLbnrhStZeMTCRjYZTatZWo=;
	b=rSmWCjywxs9eWbwm9/17t4HWfzOq3ryzEISdRkC6NA8wspGAfhpebN96p9XQjilUis4twJ
	jV64zHeTYiqDe+Q/uxcFcBo4dPXdlZGbO2pBCU68xW1oTfqKHkEsynMXkHPgmZbooB2i+s
	sDUNu/NmhcP5N/08cVHUF9P8Hugr9cw=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=OC6oKrhD;
	spf=pass (imf24.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769110214; a=rsa-sha256;
	cv=none;
	b=oqd586XoMglPT30exY4ZPhH/hkrQLPS4vwPBMoLNm59RDSC7RJP/3kktwhdBTbcaRFZtOG
	eFDmmBLXyqPu/s1DrXPzO7PwS0rtaU9i6HD+14eXGGc5sjnAXf65RCr2nHLY3POvpifo6u
	8byl8UiW5rye6eDnW1b7v8iRAKX7SYQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769110212;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=FnDUt3RW6I9OygzbiFWmiLbnrhStZeMTCRjYZTatZWo=;
	b=OC6oKrhD1BuDaWiWx7E3pZh6twyp1b515KPGX6Cc/nOb5h4zoD4ePKozy6ROEuTNXuFjq9
	jHizgUR6GbaJHMoeMvNjS4iVlaL4eOBZY6ZhyVV92No1/jV4FI6ZqlnsmnidjBzJXSYVGR
	j0mrbw4WteVknx0zod9nBeAkyjAfrok=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-662-V1w9qMd6O9mbalBXTb-9mg-1; Thu,
 22 Jan 2026 14:30:09 -0500
X-MC-Unique: V1w9qMd6O9mbalBXTb-9mg-1
X-Mimecast-MFC-AGG-ID: V1w9qMd6O9mbalBXTb-9mg_1769110204
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 95AC918005B4;
	Thu, 22 Jan 2026 19:30:01 +0000 (UTC)
Received: from h1.redhat.com (unknown [10.22.88.59])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 29BE41958DC1;
	Thu, 22 Jan 2026 19:29:46 +0000 (UTC)
From: Nico Pache <npache@redhat.com>
To: linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org
Cc: npache@redhat.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	corbet@lwn.net,
	rostedt@goodmis.org,
	mhiramat@kernel.org,
	mathieu.desnoyers@efficios.com,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	jannh@google.com,
	pfalcato@suse.de,
	jackmanb@google.com,
	hannes@cmpxchg.org,
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
	zokeefe@google.com,
	rientjes@google.com,
	rdunlap@infradead.org,
	hughd@google.com,
	richard.weiyang@gmail.com
Subject: [PATCH mm-unstable v14 00/16] khugepaged: mTHP support
Date: Thu, 22 Jan 2026 12:28:25 -0700
Message-ID: <20260122192841.128719-1-npache@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: sPuxSzAPhCPZKriaQhJNV-wsJ0A8s9Tc-ZipvaSvphk_1769110204
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam11
X-Stat-Signature: yiqwwiibu69xmpsrabefuc1kjjtewtcx
X-Rspam-User: 
X-Rspamd-Queue-Id: A4355180003
X-HE-Tag: 1769110213-398112
X-HE-Meta: U2FsdGVkX1/h01CETxc1ObwJkHzEJpgg8quW1svW6krdtHeJ7d1hb9bSyzPDU6fLX47u3NBf9Emw6Oj2s27dZT79Yrhemw/+3gwWnSm6PWgbD9R2e2q1O5R7HXVLUlG4QIvJdz/Ubzoqitn9EV7Pq0J0oInnEp6Ffk9SYbM3IInvRKJC53VXb3Uugb6McB+1ZOobhv7fIeIVB8rluwsactK9u1n/jzr/TLsbrqySU3bdwvU1bT3JlwRFoBbFvL3gm5bmdkJ+IpKhUCy6uuiEv6nyKnHHttDKLnarfkzpj0xE0iggeicEZ676mat0jYuNtwfo/3/N9FiPWWw99S7HL1XBl9WDmxdXVByKo0rKbAtLOS8JzuhUc8Gv5S2Dd+fijqAEVSZ29UhmfL57IQa2Nxw/bikKEx6UiwNyV1tu2BVrODYpscAizO7jobblihiAMLHrS6uoqShL7MEYXO4b0mqG7E+BLnJ4b47aEwSf2ETLJD1I69dWbXhdlehi5xnKMF1CRikjG+KVOCtY3CmwhA4IfM3LZl8JMawt7PIMoG0Gy92COJF2C9Cu1m6zQKk4Cwk1jxV4TzaHqxIVEGOWp+ABoYVRJoj+G+R+itgDEEqlUIK9SJqFQ7LWu2NXf/Qtkwo1z7w77EPxNIYBnCIsNTB7iVbsE+CbTqJJNe5F3P3wTfCDZ2HufMZtuSrZrk2yjGgqOnB0o9iGxOA5yxS6B3axlgcLgW6h59ujy7/bbc6yuGqWpMI/z4kcsUyPYbEilx73KnULyDTLSU80fbLzRtDHRpwZLAmXeOsnKECZiz45MFEJ2Foec4hwxjrO37ohQhhCfvkq/knNg8qiMscMMTNyRSwbAbzSLoP6R4a2EQwTmpPMPnp+n+J7x174jYHvB3+Wvy/ku2oNFYqYj44fpxZ5gnxQNd4R7X8tUjlEjIY73tOwo7N6MgbWjmRRJATH0vDZEBJ8GI8gpIfdhFZ
 cMPcqbVM
 tdp0ovB25/0TLzWWlEbnL4GefSvqhFAgfRWIJUYn2P1huU/uIC/kukCcLu8bbwC1q69dNAnSsWict0NGV3Ufk2xJymA==
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
size to be enabled. These limitiations are to prevent collapse "creep"
behavior. This prevents constantly promoting mTHPs to the next available
size, which would occur because a collapse introduces more non-zero pages
that would satisfy the promotion condition on subsequent scans.

Patch 1:     add is_pmd_order helper
Patch 2:     Refactor/rename hpage_collapse
Patch 3:     Refactoring to combine madvise_collapse and khugepaged
Patch 4-8:   Generalize khugepaged functions for arbitrary orders and
             introduce some helper functions
Patch 9:     skip collapsing mTHP to smaller orders
Patch 10-11: Add per-order mTHP statistics and tracepoints
Patch 12:    Introduce collapse_allowable_orders
Patch 13-15: Introduce bitmap and mTHP collapse support, fully enabled
Patch 16:    Documentation

---------
 Testing
---------
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
- redis testing. I tested these changes along with my defer changes
  (see followup [2] post for more details). We've decided to get the mTHP
  changes merged first before attempting the defer series.
- some basic testing on 64k page size.
- lots of general use.

V14 Changes:
- Added review tags
- refactored is_mthp_order() to is_pmd_order(), utilized it in more places, and
  moved it to the first commit of the series
- squashed fixup sent with v13
- rebased and handled conflicts with new madvise_collapse writeback retry logic [3]
- handled conflict with khugepaged cleanup series [4]

V13: https://lore.kernel.org/lkml/20251201174627.23295-1-npache@redhat.com/
V12: https://lore.kernel.org/lkml/20251022183717.70829-1-npache@redhat.com/
V11: https://lore.kernel.org/lkml/20250912032810.197475-1-npache@redhat.com/
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
you on this endeavour.

[1] - https://gitlab.com/npache/khugepaged_mthp_test
[2] - https://lore.kernel.org/lkml/20250515033857.132535-1-npache@redhat.com/
[3] - https://lore.kernel.org/lkml/20260118190939.8986-2-shivankg@amd.com/
[4] - https://lore.kernel.org/lkml/20260118192253.9263-4-shivankg@amd.com/

Baolin Wang (1):
  khugepaged: run khugepaged for all orders

Dev Jain (1):
  khugepaged: generalize alloc_charge_folio()

Nico Pache (14):
  mm: introduce is_pmd_order helper
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

 Documentation/admin-guide/mm/transhuge.rst |  80 ++-
 include/linux/huge_mm.h                    |  10 +
 include/trace/events/huge_memory.h         |  34 +-
 mm/huge_memory.c                           |  13 +-
 mm/khugepaged.c                            | 695 ++++++++++++++++-----
 mm/mempolicy.c                             |   2 +-
 mm/mremap.c                                |   2 +-
 mm/page_alloc.c                            |   2 +-
 8 files changed, 630 insertions(+), 208 deletions(-)

-- 
2.52.0


