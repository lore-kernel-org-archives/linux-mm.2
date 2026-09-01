Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DCFFDC61DE4
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 05:26:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DFB566B009E; Tue,  1 Sep 2026 01:26:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DACA26B00BB; Tue,  1 Sep 2026 01:26:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC0FA6B00BC; Tue,  1 Sep 2026 01:26:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A2DFA6B009E
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 01:26:21 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8B28B40336
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 05:26:20 +0000 (UTC)
X-FDA: 85164057720.20.033D7EC
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	by imf30.hostedemail.com (Postfix) with ESMTP id 7B64580003
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 05:26:17 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=eYK9rBE9;
	spf=pass (imf30.hostedemail.com: domain of yuan1.liu@intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=yuan1.liu@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788240378;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=XrCpQrGWzeI/Ch5F6Wo+r32NlhBMxpeoqdcxpCUXiww=;
	b=miu0lXqCMFwUQ55HvxXyaKlePUXX59QE8ZnLLNixMsUEeNRWD6yeNNxKbMYD9KXFkQmzP9
	oayH651/zO7sfqHH0IL4+iRKnSpqPJ5kIc3DAbaqdKOinFiJOfHEwaBhX++VKi69WUPkZJ
	IXOVD3var9MpN9LDz1nkagCLy2vycAM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788240378;
	b=RFJOd8jgSx3TZnSf1IEIsif5AIGgfjWJ9suhl+fpFaHmxEDLRqrGu/qydWanxQCw3iq/Sk
	+VP4MBvu9uRwrgsdYFqnvfdbwGGmjnNg3OjmkDguR2HCXhjstjCxzz8kK/EH+yWDgdtm5f
	/b8zgV5pSW0laOeEGpHmIkIJfpvm/4U=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=eYK9rBE9;
	spf=pass (imf30.hostedemail.com: domain of yuan1.liu@intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=yuan1.liu@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788240377; x=1819776377;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=N9doQrAdYJRgqhikGvlydPHZSPDpWPePKaG5iU4gpEc=;
  b=eYK9rBE9RZfmt31GRFCA/9PNLJrkjqriio974Adj5fArl/1mvqnAubN9
   IZqyiBqG53B3f0VjtPp5HIoChsM9kjinbt70mVs4ytCFhhXtoKGT83eXD
   mmRuSSmkc4UIye+CgAsWFjHuMnSlwJurfoGglonCihH77rJMlQU/kM1+I
   OAepr69VekR8YgaolV3QvKjNPjrK8ROBhcz8bSPCBVbiak+kCy/BTwpPB
   uqKak0iclopvX/yfBH4C/PPRwD6mg2s3IVjel0IVRYZZ7MQcwqEyaqj4K
   izEUzibeg6GzRlk1zYX7HRLR9YtU6ehi3geTIF0ifFmhgxbFClsMP4iFJ
   w==;
X-CSE-ConnectionGUID: A+UAFaWHSmi6MP+5SdOb1A==
X-CSE-MsgGUID: CNZpqRJxTVWpCU5RgzEEyw==
X-IronPort-AV: E=McAfee;i="6800,10657,11892"; a="106178877"
X-IronPort-AV: E=Sophos;i="6.25,255,1779174000"; 
   d="scan'208";a="106178877"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2026 22:26:16 -0700
X-CSE-ConnectionGUID: n/Y+u54pR160aiAj107xJg==
X-CSE-MsgGUID: igrovkfsQWyjCntUdatlJw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,255,1779174000"; 
   d="scan'208";a="292482070"
Received: from spr10.sh.intel.com (HELO localhost) ([10.239.23.75])
  by fmviesa002.fm.intel.com with ESMTP; 31 Aug 2026 22:26:13 -0700
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
Subject: [PATCH v8 0/2] mm/memory_hotplug: optimize zone contiguous check when changing pfn range
Date: Tue,  1 Sep 2026 01:29:48 -0400
Message-ID: <20260901052950.3284540-1-yuan1.liu@intel.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 7B64580003
X-Stat-Signature: tduqbby6kfaw8c8mwg3uawt9yydgzkz9
X-HE-Tag: 1788240377-153584
X-HE-Meta: U2FsdGVkX1+80bG1zcbKyjcM8UA1dEEEdNrCFCB650r5EuOrAyfooxWN8/Xn7KUbiaYahuRU86QWkkSMH/SleQeSyHjT6vtT9TTkHAncTjQpNvus0UlZds/QwMmZ5b7LuV6yMay8Hcaq79YHiX6xqgMTMgWF2HYJ0vQ8PjojqL7LZkjiq90HgznnTXDs11HWXHiqvrtDqQ96eAsiX8haCgRtfJzwnGppM04+x9FFeYBy/bAMaVvCEmVjsMAGL5usCA9nc2m4fZHi0gMZEKt+AUvhMywQEhG4CsCiPqEaOsyCWwcfgcJs2Ts3IZgtZlQAinXvn39c/OtBAwnU21nThPkprzHVCemfGEfMVwZhMCs2xGPGhtw6FeyOcCKjcvv7+0t8qZKXYz3kz8Yi/gQveRgWBKaebtc5Edjdkn4jaj9V+JjTXsps0+XfNjqTFgiiEQwbhITpBru8nFnvaqTPd1nMjMliGx/ksZMzcC8E9xtQ7ticR9i+2pLTL6psRQkiLlgtzxFX6ios1Q3NyAAmzog7yxM52kqGSD17BQwAzG2kD0nfLhZQUwfft2n3MzP9qWIrBMb4sTrcCyqa5rcI5orqf0xq5ilOr+jzELMYQ3GDos0xkTfn7lpnYvsfA6xlzE/3gniLYCYezHEwzPp8fGKt1YAImbVSNPkEELrDYYarytjUpriiicyzrZnux0sGyRsrVtZZZLotSfueEAy3pPYXS4DndDyYr/qnuI/FixwJSD+2OHzJC5FuR2ydUHClFH8OhJiA9GJoQcgoSSYCEc/SEZkVmI5O3kWqfUvad81/4ZiJPkxk4a09y42tnz9flXAwI97ntEI+CRn1glLMHporxZremTVBz7XUoHyX762oIBWPPtI57nCRjx0vQ85YBflkClanRVAgc49cW/EISmfs9VV4ie5oXP5jvc9lP41OkOZeM2N63w3Ig1IQqYaI6j+9MV8JAFk6trgSP7J
 Jt9n0+td
 oBvLYLmzEg6jA0Xdb67p6p52tqRqIYoyTjTMf5WUPu+U/YVe+CMkmT5cHuanTjj7MAceL8GGUpLW6I6/IfdSvA7UiFvOp6zvhsGFu1xyREs5mcN1b/JX7nijzJKMCaWJYN7JOVsV/qZRxrHgS97HUM+cCI9zeQOdLIffErmjw6Uj30FpYmQv2wgx61UpxYcxakM4bs+koRzf7n1nz5C2S3uSavr43rW+DareAhfxCnjWyL/lv+x/rzuuVEnan3cBfspKBLICcRq1JHYYJBKdVPkQPadb+tGRJwR160WcOciOzVLGFq9H1gPX+mGQkQaBmIuvQODjv28JhSaA=
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
Patch 1 makes shrink_zone_span() more robust when memory/hole boundary
falls within a subsection. It checks the full subsection range to avoid
incorrectly shrinking the zone span during memory unplug.

Patch 2 introduces pages_with_online_memmap to replace
pageblock-by-pageblock scans across the entire zone for zone contiguity
checks.

v8 changes:
    1. Rebased onto v7.3-rc1.
    2. Based on David's suggestion, use pfn_section_valid() directly in
       init_unavailable_range() instead of pfn_to_online_page() to determine
       whether a PFN is online.
v7:
    https://lore.kernel.org/linux-mm/20260818085702.3395529-1-yuan1.liu@intel.com/

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

David Hildenbrand (Arm) (1):
  mm/memory_hotplug: make shrink_zone_span() more robust

Yuan Liu (1):
  mm/memory_hotplug: optimize zone contiguous check when changing pfn
    range

 Documentation/mm/physical_memory.rst |  6 +++
 drivers/base/memory.c                |  7 ++-
 include/linux/mmzone.h               | 48 +++++++++++++++++++
 mm/memory_hotplug.c                  | 71 ++++++++++------------------
 mm/mm_init.c                         | 63 +++++++++++++-----------
 mm/mm_init.h                         |  6 ---
 mm/page_alloc.h                      |  2 +-
 7 files changed, 122 insertions(+), 81 deletions(-)


base-commit: cee9395acd8043be0644b25c34bfa86623f2b935
-- 
2.47.3


