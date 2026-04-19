Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3453CEA71A2
	for <linux-mm@archiver.kernel.org>; Sun, 19 Apr 2026 18:58:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D7046B0334; Sun, 19 Apr 2026 14:58:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9AD806B0335; Sun, 19 Apr 2026 14:58:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C48F6B0336; Sun, 19 Apr 2026 14:58:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7AD2A6B0334
	for <linux-mm@kvack.org>; Sun, 19 Apr 2026 14:58:47 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0880C8C41D
	for <linux-mm@kvack.org>; Sun, 19 Apr 2026 18:58:47 +0000 (UTC)
X-FDA: 84676217094.12.91420C1
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf28.hostedemail.com (Postfix) with ESMTP id 1BF75C0007
	for <linux-mm@kvack.org>; Sun, 19 Apr 2026 18:58:44 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="h/pgu0VH";
	spf=pass (imf28.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776625125; a=rsa-sha256;
	cv=none;
	b=xB7BgSsVneqFYGqAqbuUQOV/+ojs7YPRvertxKOmgToKqu8FKF964ALoIQb0ZKW4Obq5hk
	a1yDWvr17ys9uNCfzih2UtAXKpm3i9hurYtNi+Zy5Re3nd8cvavObKLYQ18ydKk2OnP3Z6
	WJf2Rb1q9eFwY6GpzIM43n8NjeAFSTQ=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="h/pgu0VH";
	spf=pass (imf28.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776625125;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=yy5vk9Dp4ItrgUo2V4M7nrMoaDvOeSA2Soef+4DJRew=;
	b=x1SnSV/LAzPIiCURMTF6YCkVzfalcIYxIVkL3zkG9KQsN2eV96LYpP6HUP2T8nmmQlmJjX
	nLbwVdJm1+fUrDVtGDaf5VLNyKeTEq5xmWMv3dEwXN5jhNGxoxqPWxkkVZMYAI6Qr9CVr6
	6umugi4SewB1Cr+T3OGBOmnfY54xVcY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776625124;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=yy5vk9Dp4ItrgUo2V4M7nrMoaDvOeSA2Soef+4DJRew=;
	b=h/pgu0VHgJBzKj72xPzxMyQ4dh8OjDc+qw5oVnd5MiES+6xiJJGA1RjjP6rYxqvcbrSkC1
	+wtDyRGmBzmvp9HHvo8es+WCWLfyF99197btP0XW8UrxLatBAYYc+RlgMnDjST3Q+v0bzC
	flFo/Nv/GoBfM0zlQAWFBIjBGqPJtF4=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-711-__zVUkAEMZuEfsDs-hqQEA-1; Sun,
 19 Apr 2026 14:58:42 -0400
X-MC-Unique: __zVUkAEMZuEfsDs-hqQEA-1
X-Mimecast-MFC-AGG-ID: __zVUkAEMZuEfsDs-hqQEA_1776625117
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 076DB1800578;
	Sun, 19 Apr 2026 18:58:35 +0000 (UTC)
Received: from p1.redhat.com (unknown [10.22.74.5])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id B7F571956095;
	Sun, 19 Apr 2026 18:58:13 +0000 (UTC)
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
	Liam.Howlett@oracle.com,
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
Subject: [PATCH 7.2 v16 00/13] khugepaged: mTHP support
Date: Sun, 19 Apr 2026 12:57:37 -0600
Message-ID: <20260419185750.260784-1-npache@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: SuCL1jqCKfRJ1VyDgPSKDmPCENq8uNWiDuHRmLwAf9E_1776625117
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Queue-Id: 1BF75C0007
X-Stat-Signature: 4aiy34o8yp5as1wjtmzg3jrxc6qzor96
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1776625124-78979
X-HE-Meta: U2FsdGVkX1++O7/PcVT1YTSOG1udYz0eezEqwWQbXICmr8fBDg1oQHD4y4K751YlY7FQAGjCeMjRiQfkMOH7zV1cKyMt2ay2b4f7S8eNGey72p+MXo7d8aqtFQmNzgnd0duROYSnV2t44KYpUFi6p6gwnLqmtf27660garGMgIRV7oZI/WBsypMZ9/E3GL0z2TBe+Hi2vdVV4yEOqCMhGL6ESrXAzrhnxdWIAWW4IFVgn+iUW5neS330DHoXCiLFp9kAhGKBKaGDbIdOohmrcXYsM6/9OqCQJ8budXHiYMuUsSi7h+mMtNVQq+1xDy/Fs41gLQYtZ2kUmjqJrTIsB5qc924jPdUoAgoViFS9Cc8rph3muOXW9kJ5Jg95YawhRUzUy1eSN2rEvUVYq+nCNQi2gm/6IayX8xl6FvplBeFUPba1PPQ7tKm4uuFNJmBTgZfTdjpfUf6UIddmQDRweKlfUTN7rjZalWZIC12QqL/xeSLxHCkjKz22BpFyDRlMbLP2aAnfPAHapbHDF6aw/naNhzwghyGqooYosDv/WSQTNaxiQO1T/IyVtyETkpZI+56hxs6gOJIKloqlSUjCRJuitmJ4YYcv3n8mRYKa1Lf7lTmuPBVm2byg1tk70oPxuV2u96BmVYMsCq31sPcRBo4yQG/uKgBq08JJZ2M3yHKzHsw/EU0Oj9xfa5WaF5Y4ttnk4VxYdPnc9YFeB86jNSZq0zFG8B8scdjTsB++L+RAPbqIpdDRF5YOXwx6gJnx8aazkOIqs+hv94u/dRenzBaf7AqdAJlBmeEKJPJ/ZanrZU1cZsV/mAkOV496ZEfKYVHQyHirWyuVKjLiwSKfY6nuCNUAB37jA4wAm7zFhKky0pAEDrsQQLR3qqwNKdSY86WCKzQkIcZQBuxNd/ZQyc3Qd+/N6DRD5G1zFXftbNmHhvOv1mnwcHOz+yjvIXEaGhDVk9AyQhf0u+xpeO+
 +46MlCQM
 u7L/q1/ZeFrik9F6EbfiW2QHk7z7qm93AtT1nJn6UgC3H8cBJcECbFF9Sn6TLHlk/DSjXhNDgegn36RCCASFkTEXMWVvl7B4bcoDE5p/IkU2JoYWMtBT8BCVW4NeV3JOpSfMBrVEXLGXdj0IeUkcRsyBA9I5ww7etow92D4N3PrBnuRBA27gsF6buuJI2cttin1uRczgAxdHAApOngbcptnUhOnUkhfNt8L1CRiYJX2q9ThrxiXNNtxSaWhdOXLy2bvU/HwNmxIlhzCWs+sW2/z0W88YiKGBA8AOD+KlDeD6QQjuw+3Oy+Y35+YjZ9uO3yqlF7jPXVBVgMu0IIIxjsjqEsbbdHC67MynupmZEKjQ5WERKMo3h2zCdvwUHS5acm61s8bV+3nuvgRSvsqxtHxIFBriqNLLfA25IlVucjCV34YZkVNG6X0vdWFo/J8FyXD5TEiL2aoE86/M=
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
Patch 4-5:   Generalize __collapse_huge_page_* and collapse_huge_page
Patch 6:     Skip collapsing mTHP to smaller orders
Patch 7-8:   Add per-order mTHP statistics and tracepoints
Patch 9:     Introduce collapse_allowable_orders helper function
Patch 10-12: Introduce bitmap and mTHP collapse support, fully enabled
Patch 13:    Documentation

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

V16 Changes:
- This was quite the respin, so hopefully everything is ok! I dropped
  some acks/rb on patches that changed significantly. Major changes
  are related to the locking cleanup in collapse_huge_page().
  sorry if i missed any feedback there was quite a bit of minor requests
- New cleanup patch: introduce collapse_max_ptes_none/shared/swap()
  helpers, absorbing madvise_collapse special-casing (David)
- Merge "introduce collapse_max_ptes_none helper" into the generalize
  __collapse_huge_page_* patch, dropping the separate patch (David)
- Simplify collapse_huge_page() locking: move mmap_read_unlock() to
  caller, remove mmap_locked tracking parameter entirely (Lorenzo)
- Use enum tva_type instead of bool is_khugepaged in
  collapse_allowable_orders() (David, Lorenzo)
- collapse_allowable_orders() takes (vma, tva_flags), accesses
  vma->vm_flags internally (Lorenzo)
- Rename mthp_* functions to collapse_mthp_* prefix (David, Lorenzo)
- Use MAX_PTRS_PER_PTE consistently for bitmap ops (Lorenzo)
- Downgrade BUG_ON() to WARN_ON_ONCE() in collapse_huge_page() (Lorenzo)
- Add /*expect_anon=*/true annotation to revalidate calls (Lorenzo)
- Pull common spin_lock + WARN_ON_ONCE out of PMD/mTHP branch (Lorenzo)
- Fix pteval declaration style; use end_addr variable (Lorenzo)
- Use ternary for result assignment in collapse_scan_pmd() (Lorenzo)
- Improve anon_vma locking comment for mTHP case (Lorenzo)
- Document why skip-smaller-order isn't done in scan phase (David)
- Make documentation of max_ptes_none mTHP behavior (only 0 and
  HPAGE_PMD_NR-1 supported) in admin guide more apparent. (David, Lorenzo)
- Collect new Acks/RB tags from v15 review

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

A big thanks to everyone that has reviewed, tested, and participated in
the development process. Its been a great experience working with all of
you on this endeavor.

[1] - https://gitlab.com/npache/khugepaged_mthp_test
[2] - https://lore.kernel.org/lkml/20250515033857.132535-1-npache@redhat.com/

Baolin Wang (1):
  mm/khugepaged: run khugepaged for all orders

Dev Jain (1):
  mm/khugepaged: generalize alloc_charge_folio()

Nico Pache (11):
  mm/khugepaged: generalize hugepage_vma_revalidate for mTHP support
  mm/khugepaged: rework max_ptes_* handling with helper functions
  mm/khugepaged: generalize __collapse_huge_page_* for mTHP support
  mm/khugepaged: generalize collapse_huge_page for mTHP collapse
  mm/khugepaged: skip collapsing mTHP to smaller orders
  mm/khugepaged: add per-order mTHP collapse failure statistics
  mm/khugepaged: improve tracepoints for mTHP orders
  mm/khugepaged: introduce collapse_allowable_orders helper function
  mm/khugepaged: Introduce mTHP collapse support
  mm/khugepaged: avoid unnecessary mTHP collapse attempts
  Documentation: mm: update the admin guide for mTHP collapse

 Documentation/admin-guide/mm/transhuge.rst |  81 ++-
 include/linux/huge_mm.h                    |   5 +
 include/linux/khugepaged.h                 |   6 +-
 include/trace/events/huge_memory.h         |  34 +-
 mm/huge_memory.c                           |  13 +-
 mm/khugepaged.c                            | 623 ++++++++++++++++-----
 mm/vma.c                                   |   6 +-
 tools/testing/vma/include/stubs.h          |   3 +-
 8 files changed, 589 insertions(+), 182 deletions(-)


base-commit: 4569c01e84d440f1f6c79df1e13e9c86a9fb80ca
--
2.53.0


