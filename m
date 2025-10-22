Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80EDACCD1AB
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 18:38:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE09D8E0011; Wed, 22 Oct 2025 14:38:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B91148E0010; Wed, 22 Oct 2025 14:38:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A596A8E0011; Wed, 22 Oct 2025 14:38:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 90F9A8E0010
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 14:38:33 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 39BBA1408A1
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 18:38:33 +0000 (UTC)
X-FDA: 84026610906.21.6DDFD90
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf17.hostedemail.com (Postfix) with ESMTP id 571F840003
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 18:38:31 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=IIAmPaos;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf17.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761158311;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=sGrCfbpJbLZ7HRMa9iPXf+hCVuEsHMIDx0PfwK6yFh0=;
	b=Glav1upYWEE9gMDoYk7pyW91xNuZXTdyaPg2QEDo6MGXIr2Vpg229R24VGLJY8QQOT//K6
	07MjqNAU21JyyrjQ0gJw8gtptoSKxGvUBs3IsSU1HL1wZBOGS+UyfNAkXoydkuNmcA/ues
	yudQwe/pt6p8+O+z8+fX/oHdbL8FAVE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761158311; a=rsa-sha256;
	cv=none;
	b=Q215a0M6rOtfHsdSG1i+3ldejpfUvT/SukfjpTuMhWvxDqBWHdy0t3HUz9RxcGxcu9G+Qe
	3bSYhj+rBElP1nysKGIFZe2TeRKvoW3eRJvvO8CM1SlCLDM364VU2ZxvEFvvpV3UF+vzhS
	aMHwzHvabhSYmrvIA0uFAobs2uM3mV4=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=IIAmPaos;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf17.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761158310;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=sGrCfbpJbLZ7HRMa9iPXf+hCVuEsHMIDx0PfwK6yFh0=;
	b=IIAmPaosN0F3hNsbIV0jqPunIBjQdelQFan/EqwcL8SD5b3Oz6rNM1UD1Us0hnCysAYmaQ
	ooNak1CGywtHa36E5rF/kw7oKHjP5gqazy9HInT25plLIVaL93lNMoUFzjl+iuzCULX7hr
	LgPmjPRoBCalqgz8I3ya1cgx3wwOEsM=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-304-1eKGJ1J5OM-DligeSKwWCQ-1; Wed,
 22 Oct 2025 14:38:27 -0400
X-MC-Unique: 1eKGJ1J5OM-DligeSKwWCQ-1
X-Mimecast-MFC-AGG-ID: 1eKGJ1J5OM-DligeSKwWCQ_1761158300
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EAE2418002C9;
	Wed, 22 Oct 2025 18:38:15 +0000 (UTC)
Received: from h1.redhat.com (unknown [10.22.64.41])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id D1EB219560A2;
	Wed, 22 Oct 2025 18:38:02 +0000 (UTC)
From: Nico Pache <npache@redhat.com>
To: linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org
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
Subject: [PATCH v12 mm-new 00/15] khugepaged: mTHP support
Date: Wed, 22 Oct 2025 12:37:02 -0600
Message-ID: <20251022183717.70829-1-npache@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Rspamd-Server: rspam01
X-Stat-Signature: dif1tsk78sctytg5kweigqsyftw6ushx
X-Rspam-User: 
X-Rspamd-Queue-Id: 571F840003
X-HE-Tag: 1761158311-808776
X-HE-Meta: U2FsdGVkX1+XV6j5wn5/e919s3FVggIYxUVMUqw4BRaz6NUyw/zJ73hLD5sRyKJazTuydXgjI+Uem6p2avWwAhy3h7tTmoYmHvSZxt3xV2WmdnN9W79J9oz0y29KGxr42BIT+uoEoA2ESjTvLiMaxzfDMaDa7cYk3vyluAwsRV3aPBJPx0p4LvqUf46Eomaqo5mEPPbWlISgAwsHEF21TTRCQZiqCku79sudgY3plo9P10PBum9GS6JThwnW8TxiR2xUAZny9dOSh3p4ZxudbXrzcvnZz+V1NKdVNQlnUjLKa49yqSSOMGIeihqtd0/iXXftUHSzU35hNkC44bj69mEplw3APEUYaMXo9O2/2WwvfO40FfBR4WWhoNTw8+xhcO1VDHgkjXbRI7XnEFgZGW8W9QBmmzkPEoY9cKj6AV1XZVLNtW9WWqGutyIaaWIQTNIR+tL6gU4rq4P1gUjHClwBNjK6j3gSxiYOaMhCWu5/ByYKsOFF7SX4RZBB2YxQ3ehlsAni5+/uCxnxIXl0Adqw9j/76NVm3bTI8ysX5bkY2JmevLeyZv15QlUIJHA3rBs1Zn9KiDnL/QSE8LUlZtrJ6UgvuwHo8PLOpJsEmCZOTQT0ye3idW6WTw97ZxNFWqa+yKLOlHiprJqRpBEFF3hZiB04ihkimp4qEQi8XZqRAvY82YyzGQRwg03cV/P3XqFR3d6IcjieoP1rJCUwdkK8v1mNrv6uIL9c6PxnmAsfbueSZU2CTAphiroE2zY+enP6dv4Muha5WCHrrlxjXNubW+U5CR2SootFXLiraRL091fgZx1osB78+/ZJgJJfqoxJs+DCT9s/H+ssR+UssHYOjYZ4LrUitFITv/OHGQZGCmv0LrC4va+FO3wSowc6VFNcuPIwzJM0ddQGfGjljh2NEqk7+QGFKJhmw1C1IP7WgqvRpIWHgQcqgB6N0G3Cds4sMVceaLR5ovpRwaZ
 TgHeAD7G
 K8aJsKN1M8wuIKOT6WsFdhoF0JPG1OFekqZzHUHRtU3spE+zRTY+Mx5zbng1xw4udtbxIKchzjCVi3RqNsiWkFVp/lbyZYXmgQBZ84/XkmW5b9J4K+0asZahlZolM71gnWkQVzBRDQB2ujslTgs4OlQNgcZJRAiiAGOGGooXd7/sB0bwaajCYDFK3EITyfApKGe2TE59kY9zcRBdhSB20AccZbhvj9B7taEi/y/zwHUrF2xo8LbAK2Wi3bQr+bMBvlTOLT4zq+kzAFXtFtLpWM3foXagcEhTzKjRMLej5yKavaYurOV5xdvywqoPGD5k0WqyPeEWQq8dJfMIaDH3FOc09F+mCSkrO23BtNcMrdCaqhwq7e/kiJgCWXZnXrXuvAc4SIGY2QcYzYpzisWUmtMtc7C9K0Oxud/4iTIWZnXve0HSKH8GHU4IeMATWoOWR1g7Q
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

V12 Changes:
- variable cleanups & minor nits
- Documentation updates to be less specific about the internal workings
- Added Review by Baolin (thanks!)
- Improved readability of the collapse_max_ptes_none function
- Improved collapse_scan_pmd max_ptes_none logic using the helper

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

 Documentation/admin-guide/mm/transhuge.rst |  84 ++-
 include/linux/huge_mm.h                    |   5 +
 include/linux/khugepaged.h                 |   2 +
 include/trace/events/huge_memory.h         |  34 +-
 mm/huge_memory.c                           |  11 +
 mm/khugepaged.c                            | 614 +++++++++++++++------
 mm/mremap.c                                |   2 +-
 7 files changed, 539 insertions(+), 213 deletions(-)

-- 
2.51.0


