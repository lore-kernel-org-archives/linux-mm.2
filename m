Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 812DDC531CB
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 08:45:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7911B6B0151; Thu, 23 Jul 2026 04:45:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 742836B0153; Thu, 23 Jul 2026 04:45:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 65AA76B0154; Thu, 23 Jul 2026 04:45:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3494A6B0151
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 04:45:51 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B36361A0414
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 08:45:50 +0000 (UTC)
X-FDA: 85019408460.06.2DD6F46
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	by imf01.hostedemail.com (Postfix) with ESMTP id 2D64140008
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 08:45:47 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="n/83yfdB";
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf01.hostedemail.com: domain of yuan1.liu@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=yuan1.liu@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784796348;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Vq/G4Cv7vN8OHh0w0Ztjbc8kGt5Tj24H4OjTSconuEY=;
	b=VbDihmPKPGauWbknaKDi6ZRtPf0OJeyXxacH4GhSPNz3J24IvMedq6uMzfuohIyZFVPkFY
	ySw49XvKeLT2L0+VETpBgYmsFc7yiud+++cTgo4SDx9Biod7TQm2QwNTsqa0O23emGd6Rs
	Zrd+/cJlvmJyd32WeVN4pjp+lDzkbi8=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="n/83yfdB";
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf01.hostedemail.com: domain of yuan1.liu@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=yuan1.liu@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784796348;
	b=5NDlBJZ68quhM6BkqRmPyAL6BIgPyZP4eKs7bipx4E2XTTxcG1W+ccEoKB7jRt250VOmtk
	3rKmDdx6iKEJE5EjsQu5354Ly6hGuKuXkIjagQ+cJtgqymQRzBl2RYB0vp/Ab4vn7ugFB4
	egawhoWlN4m+I+Pjcsp5HzHxjcyTpV0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784796348; x=1816332348;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=wt/1Q/1Uc8s3JGUPFe4oh+yq/wTku+L5499+dfNpp+A=;
  b=n/83yfdBmW32T5W2EO/zq+s3UMiPLsgUS3hFFQda8MLZrLGaDHurSuNz
   vT0VU2UvK0YutlNntFeQLB1LgRis4BJO8eDP8kkXNxzeifJSupWY88/73
   zLrhJ0kBDmzkfxcWNR1AkuiaAB2uIYfClwGE8FGuRcEkQNbomtPf1a4B+
   s9P+kfeUvB97lWgNCdhqcODhC8vz/yB+8NucBgXMw5PPh5Ffdnm+0a42c
   0hJOqqJJkTV07HXVYyKHc/P8fQwThvZDzwnoiY0O04EINfYTtGPSmwpF/
   MFnNcPq0KqsPVOFE0lidyfShTF8L/N4ShRzbgZWcW1mO+1eZLm8D51Z4V
   A==;
X-CSE-ConnectionGUID: cWmPT471R9Ct5j+Xvpekhg==
X-CSE-MsgGUID: q6P/gG+jSCWcx5IOlktvFw==
X-IronPort-AV: E=McAfee;i="6800,10657,11854"; a="102854653"
X-IronPort-AV: E=Sophos;i="6.25,180,1779174000"; 
   d="scan'208";a="102854653"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2026 01:45:47 -0700
X-CSE-ConnectionGUID: amV6tR1LQq2BfEoLMkFrqA==
X-CSE-MsgGUID: 0Xxj1lxqTqW2HB+YmsYBiA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,180,1779174000"; 
   d="scan'208";a="258408727"
Received: from spr10.sh.intel.com (HELO localhost) ([10.239.23.75])
  by orviesa007.jf.intel.com with ESMTP; 23 Jul 2026 01:45:44 -0700
From: Yuan Liu <yuan1.liu@intel.com>
To: David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Mike Rapoport <rppt@kernel.org>,
	Wei Yang <richard.weiyang@gmail.com>
Cc: linux-mm@kvack.org,
	Nanhai Zou <nanhai.zou@intel.com>,
	Yuan Liu <yuan1.liu@intel.com>,
	Pan Deng <pan.deng@intel.com>,
	Tianyou Li <tianyou.li@intel.com>,
	Chen Zhang <zhangchen.kidd@jd.com>,
	Jason Zeng <jason.zeng@intel.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v6 0/2] mm/memory_hotplug: optimize zone contiguous check when changing pfn range
Date: Thu, 23 Jul 2026 04:49:44 -0400
Message-ID: <20260723084946.189392-1-yuan1.liu@intel.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2D64140008
X-Rspam-User: 
X-Stat-Signature: ky5tiwqan815ufsza39qfyxe1of5r98e
X-HE-Tag: 1784796347-604492
X-HE-Meta: U2FsdGVkX19YbpzEEA1yCLhCHf7zTiib/fangk+kuFzFM5qTCVqcy4h/paHp8br/nCNBw8h+pVIto1JXdqCeE0xhJBwgbfyJgD/5LQBE9AOTrRyvB9JzUNEw9uXn6stQ0cG6W4A+HCSfGdaGgnYBLIiWEhzKucniwAsiuUh7wanTvMWB4RUyQP1UgQSSrvus1gaBBim1s6VmrIhxJ5odFapCv6r22Ty6x6SDQeMjOAyM6/GwbPuMbS6SEoMAn8rRtNRq3HXs15abOigBljimBG6KYWcDT6vgsKbHax5rmbEYfqFDEJUO/8pBUIxbeV8R9vmKGN43pLMgqI72SF4crxdQJerNeopN9AyRNtqOjInC32f+5GlTmxtGfXNrF+EuiVONovzh2kG9qTkyfZPinF8vOUC9rMaU4SigOwx6Zbsf7zT+s9/OTqZLYqHCp/0c7675WrYBc5k6vmsTRBu8vvf0PMZtS+4Q9O5VXfzNPViy4DG4ERRg2vT2vRA0jUJOljXVPZi6zUi28mDhGTRpdtVQdsBvbrB3AdPE7McGlDKeWf1rH37/agwHVPqOHANVQERw1gFYsMDA+RyUw6nM4IBMosP0/fxGS2780gHm1UJEEjkTfWfDJ3veH0EOJwE0N1bjyrLrX+selHxd1dULgC97rpl6YM/IMRmakOY8h426NzF9hiCTUiiRuuN+FHXaGe8qDg/vVm+ZMaVPxFUSnTs6/6ALcGLyv940cA6CJoAHFkAe4rJKWKtYNLd7RSk25Yk9+bVMIbOJMOorn7kYnFEueSQID5X5SALdunsVSQna5ntK6jhT+LY42hQI7WupaQlHRKo2cPYZzOcK7k6KVy9fNpIenP08MfiXo9uzRHgJbIYcvEVbDo1NdBEA0WyCDYit5ZqoOs9Y7Wh4gQYX3JyAnlOB0zDvwL6Bld5Pr0o4CqQS4BnzSRTSz6SvO1Chb3LFCYYz7MgCODfkQpN
 EH6tfobN
 bwR3rCvJtgHR7pjvt1MQKcHxW5Sd8181zebo3yJj9cI64gJko6INYMPaZlBfdWxlID7/KsgRYmtiexzvc5m7owDeN/NB5jgoNvdvxG2TTCCwRcAYvOoHAXOxyQmSK/zssp4u7ZpBMSeUxTZoD9r+FRCGflo/DlvKGwuo8s8bL4yvnfSZRjV0j2AIQ0aQBEUkkAXroBA3YewjPRwvFhAQwqpj8qCIyOusvlXHD/BA12ak7DznpE7SrHzjl9CoNek1wd2O3tZIYfOhKJq6ih/aSJVriZK79aizUVn+cJFqY4XHtIxZKlHUjkBtyTFO4rV2UEzMkyxuHEihZTpXo+yNOQGJSK60GuLSrNjl3+wcdbtd2Q3IRNd1eHnuUZ8yuOvB1/31s
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series introduces a pages_with_online_memmap member into struct
zone to avoid pageblock-by-pageblock scans across the entire zone and
improve memory hotplug performance.

Reworked how pages_with_online_memmap accounts for PFNs in early
boot memory in response to Sashiko's review comments [2], which
identified potential issues with the previous implementation.

Approach
========
Add a new zone member pages_with_online_memmap that tracks the number of
pages within the zone span that have an online memory map (including
present pages and memory holes smaller than a subsection whose memory
map has been initialized). When spanned_pages == pages_with_online_memmap
the zone is contiguous and pfn_to_page() can be called on any PFN in the
zone span without further pfn_valid() checks.

For early boot memory, pages_with_online_memmap is calculated in
memmap_init_zone_range(). Since every PFN within a memblock region
satisfies pfn_to_online_page(), the calculation aligns both boundaries
of each memblock range to PAGES_PER_SUBSECTION and counts the aligned
pages that fall within the zone span. If two adjacent memblock regions
share a subsection (i.e. the hole between them is smaller than a
subsection), the overlapping subsection pages are counted only once.
For hotplugged memory, pages_with_online_memmap is updated through
adjust_present_page_count(), which is called during memory online and
offline.

Only pages that fall within the current zone span are accounted towards
pages_with_online_memmap. A "too small" value is safe, it merely
prevents detecting a contiguous zone.

The contiguity check using pages_with_online_memmap is stricter than the
old pageblock-by-pageblock scan. The old set_zone_contiguous() iterated
at pageblock granularity via pageblock_pfn_to_page(), so a zone could be
marked contiguous even if a subsection-sized hole existed within a
pageblock. The new check requires spanned_pages == pages_with_online_memmap,
meaning every PFN in the zone span must satisfy pfn_to_online_page().

Performance
===========
1. For VM hotplug performance data, please refer to Patch 1.
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

Patch 1 introduces pages_with_online_memmap to replace
pageblock-by-pageblock scans across the entire zone for zone contiguity
checks.

Patch 2 avoids incorrectly shrinking the zone span during memory unplug
when a memory or hole boundary falls in the middle of a subsection.

v6 changes:
  1. Dropped patches 1-3 from v5. The kernelcore=mirror overlap issue
     that caused pages_with_online_memmap to be overcounted has been
     resolved by the series [1].
  2. Reworked pages_with_online_memmap accounting during early boot.

v5:
    https://lore.kernel.org/linux-mm/20260520093457.3719960-1-yuan1.liu@intel.com/

v4:
    https://lore.kernel.org/linux-mm/20260421125508.2317429-1-yuan1.liu@intel.com/

v3:
    https://lore.kernel.org/linux-mm/20260408031615.1831922-1-yuan1.liu@intel.com/

[1] https://git.kernel.org/pub/scm/linux/kernel/git/rppt/memblock.git/log/?h=kernelcore-mirror
[2] https://sashiko.dev/#/patchset/20260520093457.3719960-3-yuan1.liu@intel.com

Yuan Liu (2):
  mm/memory_hotplug: optimize zone contiguous check when changing pfn
    range
  mm/memory_hotplug: improve shrink_zone_span() subsection boundary
    checks

 Documentation/mm/physical_memory.rst | 13 +++++++
 drivers/base/memory.c                |  6 +++
 include/linux/mmzone.h               | 47 ++++++++++++++++++++++
 mm/internal.h                        |  8 +---
 mm/memory_hotplug.c                  | 54 ++++++++++++++------------
 mm/mm_init.c                         | 58 +++++++++++++++++-----------
 6 files changed, 132 insertions(+), 54 deletions(-)


base-commit: b69c2a1fa9beb4c3db24b4013e07f5cb7e7260aa
-- 
2.47.3


