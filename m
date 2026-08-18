Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37F93C5DF80
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 08:53:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3827F6B015A; Tue, 18 Aug 2026 04:53:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 332CE6B015B; Tue, 18 Aug 2026 04:53:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 248E16B015F; Tue, 18 Aug 2026 04:53:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F15386B015A
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 04:53:25 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8944D140B9F
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 08:53:25 +0000 (UTC)
X-FDA: 85113776370.25.2C82623
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	by imf31.hostedemail.com (Postfix) with ESMTP id E67E220004
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 08:53:22 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=WbJrML90;
	spf=pass (imf31.hostedemail.com: domain of yuan1.liu@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=yuan1.liu@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787043203;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=YE919YXp7OOLzc5Car5NFmLPwlfAO67FYAWV4OAG5F0=;
	b=u9RtiMREwnTrCWTvBVkXFL5EznJcqsgjZ0NpLXIK9daJeL6Pxfaer2W5ZPMq22IQ5WwBbl
	FHoxPHHoL8DyJGGE+DdvYI8EBfBXLBno1V4jIvjafEN8mspxI3zqsdQUZnoqmx8I7rZd54
	D0LYUo+g+EYeypGLQCe7lq4O5/DDOFE=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=WbJrML90;
	spf=pass (imf31.hostedemail.com: domain of yuan1.liu@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=yuan1.liu@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787043203;
	b=cNMDWj+TX0FjH12jPnhv+zySkDKYjq+fg339N4y5RJLmdDVOywEtq+C/AxYBK+1ocQXtBH
	NVK0BkcNtVFGIR3aLEjt3UWmFVCikQzZl9Om6cheeA7vnAdp9fZHwfAd7teyAK6l6nKfTI
	fn0CGa4940ZrvNeg3nbBsdgufrNvuxc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787043203; x=1818579203;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=YUqrhAClWKLoFyRN2QjLHIx3kymfEo0lh4vN3bABYNc=;
  b=WbJrML90rw+JYRU7qE1T0DgUkCOMoY9PpxFi5O2/I0E2Gn//spgNzZ8v
   tw4y/mmXXzxhrhdDDWJSSkiU/RjjfXFnTRdyjy1R1SJr3UcQbWz/cccwU
   ImLlwCRYNhi+mSdQ/MLe+/HkbOLSQLhGe0rWkdMLoFmpbDqbtJPPt/3te
   oFFjU9CfdLdvjMbvjoWrj865TfnzNXyYzEYXwTGmMCH7u5m7EcFHlUjGY
   puxVYbs3kTuFDtDRvlmHmGzbpMu6/ZguTRI/J+bohBvHPSK/LRQjeVpfc
   WnT/Ibpnunmm2GmO2litbNt6jdN8k+IH7dTYzEaz1CxIKy0oJJRm6XEBM
   Q==;
X-CSE-ConnectionGUID: +9JJ+oOpRcilDKGGnXpATQ==
X-CSE-MsgGUID: i3z1A+zWRqyBraYpFQKy7Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11878"; a="99047812"
X-IronPort-AV: E=Sophos;i="6.25,230,1779174000"; 
   d="scan'208";a="99047812"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2026 01:53:20 -0700
X-CSE-ConnectionGUID: 5Qgiwy9cQGGhVyVgDieCZA==
X-CSE-MsgGUID: 2Ycz6lLPQMmeqs9y1sihyw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,230,1779174000"; 
   d="scan'208";a="288674251"
Received: from spr10.sh.intel.com (HELO localhost) ([10.239.23.75])
  by fmviesa002.fm.intel.com with ESMTP; 18 Aug 2026 01:53:16 -0700
From: Yuan Liu <yuan1.liu@intel.com>
To: David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Mike Rapoport <rppt@kernel.org>,
	Wei Yang <richard.weiyang@gmail.com>
Cc: linux-mm@kvack.org,
	Nanhai Zou <nanhai.zou@intel.com>,
	Chen Zhang <zhangchen.kidd@jd.com>,
	Yuan Liu <yuan1.liu@intel.com>,
	Jason Zeng <jason.zeng@intel.com>,
	Chen Yu <yu.c.chen@intel.com>,
	Pan Deng <pan.deng@intel.com>,
	Tianyou Li <tianyou.li@intel.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v7 0/2] mm/memory_hotplug: optimize zone contiguous check when changing pfn range
Date: Tue, 18 Aug 2026 04:57:00 -0400
Message-ID: <20260818085702.3395529-1-yuan1.liu@intel.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E67E220004
X-Stat-Signature: 7w5zted6qeuszmsw8kdrpxermhyxjquj
X-Rspam-User: 
X-HE-Tag: 1787043202-728865
X-HE-Meta: U2FsdGVkX18R6+Lhgd6TdyAfh2gSIvtvqe0zgcFD07kTjjtejXrBvi1aM5tABalQTPEzwCsA/3B5fDUczTd98+ks9hNkEnuvA2Z2kjfPh3fJ9MttCDMQ3GAsWZSdukYSXyTLRZxWs/QCySMwHFNLnByYXTT4Nmy/UOUqjofn2nGLsc9tyW3t26Hdtdp0/iKH7KlTy50iyLQyQanD6Odq0l7u/r3KQQCU5LF5FH90MuzJhiEvDD+x2j0k9mCv/YutSNqg/b/QqFXnzzbcsO6WIfgOd2x1pMBuGSHN3u1hbAUBJRd6XJWPpfoR7tRO8I1ucHz+Mc8PqOYexXvEgsMtsw6CsKoCmnHt/8kdb9MElPSTmaMzPHFjEog1FnERI8F1d3zcV7o4Rc0W7y33TQlsLUvfgWZRVBeKbe2IjwzmWktuNS5E7fzlUvUoEwk3W4G2tJysYcmMJlnpaV4972nVFOvu3G6zM3vf+hveg5oMhNKEDwSJ1pNx569l8Kg6NPmBbZaE0qXSHPQcKK6QFNXP1wiHP9CfEFgbZ6AfNLGwIQ0++c8PUAVKZoRrgY9G2XDOFClNdCserMGn/wU/eP6o2fq8T7JGNUApF8jHaBDUmeZh7xA5CFdh3tJPbDYJQVBiAO1ahKuGM+aWVX6smaJIGMEt0cTD5Dg+rECkHnaI3dATUhGivOJmGovDN7GMXURPx1Ko5pQ9L9ddOFOb1Z3nSbYM3H3KYsYNQ3Mb6qW046H5cFutWNP80K0H4k412k2b9Ps+X+r6Avumt7/CoE1ELPtMJRsbeGO5OG7VS9Owcga++jvUves6/KOsphtD+YPEfbEK/yZ0825+qzt83nrp+gRNImHrp2Th6sFY1dzoeoezTBooK1m65Za34QqAs4bkvMvJBF9BECfFzWzbdahA76aEAua4f8g58TeokQNrpVca1I83u1L5qjLhCGUZHGc4CYdqNQxfQAugLiWLe1A
 R/QpbkP4
 1mEaQoaZuzBguDww+89Cw6VqDJCsgn/fPurMf1rJKlYTloc9DlWO46tuyzSsVbzgZSN/cQSNjzb8gk8viWy8/lBryIin4Q9vKjO99z/NVh/QJwCD9m9XP/LqkDf5qo7yanpqUzMGJ4WE+8n9fb8SJXIlqjraz2bNoJvm832X6k0+mDVkEU2E5xWPI5ddVsAKh+jA8RS9b0vC/bvAJogqIgmj72Lq8vuu46WBnL5lruCoj5ZBCIgznfajLwGhDTfhUJYTkxJlM55zfz8RRhlphCQlw5PXAfL6EJAlnpcDViLCj5y5J+4lN1AGPgYLyi0JfUfz1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series introduces a pages_with_online_memmap member into struct
zone to avoid pageblock-by-pageblock scans across the entire zone and
improve memory hotplug performance.

Approach
========
Add a new zone member, pages_with_online_memmap, that tracks the
number of pages within the zone span that have an online memory map,
including present pages and memory holes whose memory map has been
initialized and for which pfn_to_online_page() succeeds.

For early boot memory, pages_with_online_memmap is calculated in
memmap_init_zone_range(). PFNs initialized by memmap_init_range() are
included in pages_with_online_memmap, and hole PFNs for which
pfn_to_online_page() succeeds are also counted in
init_unavailable_range(). For hotplugged memory,
pages_with_online_memmap is updated through adjust_present_page_count(),
which is called during memory online and offline operations. When
spanned_pages == pages_with_online_memmap, every PFN in the zone span
has a valid memmap entry, so pfn_to_page() can be called for any PFN
within the zone span without an additional pfn_valid() check.

The counter may temporarily undercount when pages with an online
memory map exist outside the current zone span. This can only happen
during boot, when initializing the memory map of pages that do not
fall into any zone span. Growing the zone to cover such pages and
later shrinking it back may result in a value that is too small.
This is safe, as it merely prevents detecting a contiguous zone.

The contiguity check using pages_with_online_memmap is stricter than
the old pageblock-by-pageblock scan. The old set_zone_contiguous()
iterated at pageblock granularity via pageblock_pfn_to_page(), so a
zone could be marked contiguous even if a subsection-sized hole
existed within a pageblock. The new check requires
spanned_pages == pages_with_online_memmap, meaning every PFN in the
zone span must satisfy pfn_to_online_page().

Performance
===========
1. For VM hotplug performance data, please refer to Patch 2.
2. This series also benefits CXL hotplug. Performance results are
   as follows
   https://lore.kernel.org/all/20260409023552.GA2807@AE/

Tested cases
============
1. Hotplug/unplug correctness with both online_movable and online
   policies, including partial unplug, middle-block offline gaps, and
   edge-block span shrink.
2. Large scale (256G/512G) plug/unplug performance.
3. Boot-time subsection holes (aligned/unaligned, in-zone and
   cross-zone) with correct pages_with_online_memmap accounting.
4. kernelcore=mirror: verified no overcounting.

Patch overview
==============
This series is based on the kernelcore-mirror branch [1].

Patch 1 makes shrink_zone_span() more robust when memory/hole boundary
falls within a subsection. It checks the full subsection range to avoid
incorrectly shrinking the zone span during memory unplug.

Patch 2 introduces pages_with_online_memmap to replace
pageblock-by-pageblock scans across the entire zone for zone contiguity
checks.

v7 changes:
  1. Reordered the patches, moving the shrink_zone_span() robustness
     improvement to the first patch.
  2. Based on David's suggestion, moved the counting of hole PFNs that
     satisfy pfn_to_online_page() into init_unavailable_range().

v6:
    https://lore.kernel.org/linux-mm/20260723084946.189392-1-yuan1.liu@intel.com/

v5:
    https://lore.kernel.org/linux-mm/20260520093457.3719960-1-yuan1.liu@intel.com/

v4:
    https://lore.kernel.org/linux-mm/20260421125508.2317429-1-yuan1.liu@intel.com/

v3:
    https://lore.kernel.org/linux-mm/20260408031615.1831922-1-yuan1.liu@intel.com/

v2:
    https://lore.kernel.org/all/20260401070155.1420929-1-yuan1.liu@intel.com/

v1:
    https://lore.kernel.org/all/20260319095622.1130380-1-yuan1.liu@intel.com/

[1] https://git.kernel.org/pub/scm/linux/kernel/git/rppt/memblock.git/log/?h=kernelcore-mirror

David Hildenbrand (Arm) (1):
  mm/memory_hotplug: make shrink_zone_span() more robust

Yuan Liu (1):
  mm/memory_hotplug: optimize zone contiguous check when changing pfn
    range

 Documentation/mm/physical_memory.rst |  6 +++
 drivers/base/memory.c                |  7 ++-
 include/linux/mmzone.h               | 48 ++++++++++++++++++
 mm/internal.h                        |  8 +--
 mm/memory_hotplug.c                  | 71 ++++++++++-----------------
 mm/mm_init.c                         | 73 +++++++++++++++++-----------
 6 files changed, 132 insertions(+), 81 deletions(-)


base-commit: b69c2a1fa9beb4c3db24b4013e07f5cb7e7260aa
-- 
2.47.3


