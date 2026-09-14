Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E381EC88E64
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 07:26:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D3E1A6B008C; Mon, 14 Sep 2026 03:26:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D15CF6B0092; Mon, 14 Sep 2026 03:26:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C2BE26B0093; Mon, 14 Sep 2026 03:26:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9B9B06B008C
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 03:26:08 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D3F171211B4
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 07:26:07 +0000 (UTC)
X-FDA: 85211533974.14.0F55D99
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	by imf12.hostedemail.com (Postfix) with ESMTP id 6BE6040008
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 07:26:05 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="AAcDkV/n";
	spf=pass (imf12.hostedemail.com: domain of yuan1.liu@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=yuan1.liu@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789370766;
	b=1T4w+OvYHw6MURqZk4hXZxK3DTs5TZ6TB0704G3Mj5QJldGs08jQjgAHyJ4zNyzLFcLXko
	x+h3z5oX/UAvsP3UjLXIpNJgvzBtQWFYP+m5/xAHToj6AlrxQN7UNljHIAViheqly3wgdj
	ndF3SkwSt0olvo3QhTcEXandQi9jKHA=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="AAcDkV/n";
	spf=pass (imf12.hostedemail.com: domain of yuan1.liu@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=yuan1.liu@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789370766;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=7sV/pvvUVnm1r0tvVB1/v4Cu/e6Xg4CqFlosU+740Xs=;
	b=ORCfD8ixHVEAKsimxvaBgshAcf1Q01bCnEksVASoQCRT6J0PxixSoRRccbVJgJRqdPJU9z
	/d6YWRkhad0OHPU+OjEFGAn9J6MhkyHNkG8blojWWh1OLAsU5jEANNWoLT1tO0riy8t0u7
	SS7ugzzwzjO9uQbg38hk08Lm+xgZfxA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789370765; x=1820906765;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=NOfPHZ7ixuLkKXI9w0ZgyEaNoNvp5KgjURpRC8WgItI=;
  b=AAcDkV/nW5G835YYYb61d9xdP9xd4TZ/9MDRc2kIzMJOQbgSto1CoiE/
   ExwwiClDYauR8KOivmDjUXXR5ozxi37RSfYBcpnw/JbW/kJvLg75ZlZAy
   5NeG1QwJaudC51u2QEno70fmbjoqt5CSznykaQYM34tAEw73vgBrefh1Z
   oq6Hoo2YT1jkF3sHMHU41SBhqwDw8RuLgE6DO24is6+XZvI4Hz9o7nHKe
   QG1vwP+GLIDvDazxJS8Kp1A2LdqkTjdl/CKqmoPM7UXw0sXwQK57TEn9c
   5u7p7a2MK5xt6AOYWGghq6sdnXxTVgEMcV1rRKClRk/Ie97x6080b+0+f
   Q==;
X-CSE-ConnectionGUID: KytF3EmwQgGs5MO9eAEJRg==
X-CSE-MsgGUID: iDVahfzbSWaaDOV+ZQlKZA==
X-IronPort-AV: E=McAfee;i="6800,10657,11904"; a="101239027"
X-IronPort-AV: E=Sophos;i="6.27,102,1787036400"; 
   d="scan'208";a="101239027"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2026 00:26:04 -0700
X-CSE-ConnectionGUID: dQwj5KD7RCejXc61B7nuQA==
X-CSE-MsgGUID: d5aPZLlTRTaxm5Oak84Now==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,102,1787036400"; 
   d="scan'208";a="269937740"
Received: from spr10.sh.intel.com (HELO localhost) ([10.239.23.75])
  by fmviesa008.fm.intel.com with ESMTP; 14 Sep 2026 00:26:01 -0700
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
Subject: [PATCH v9 0/2] mm/memory_hotplug: optimize zone contiguous check when changing pfn range
Date: Mon, 14 Sep 2026 03:29:27 -0400
Message-ID: <20260914072929.1883794-1-yuan1.liu@intel.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6BE6040008
X-Stat-Signature: m7ym1mnegsgknr97fnmm3ohqirw957br
X-HE-Tag: 1789370765-719436
X-HE-Meta: U2FsdGVkX18DKeonyqMNetqVVK8yqkf99THyLvlj5O/qFRhLQ80eAsRes61VUl5wkV/2rfuc8YqrwWPtkfXMmlDR+wjKCOeI/CBvn/EqtuyzHiJAe4oYgMQX4M9LkZQQe/9O4b4G2lItveio+6agdNlL4dWw2AEj4A+nRIiblRd81cGHipnu8HquiBiuhznyPJ70IShW3p2ZAHZRVTldOV7pV8a0FtJ79r6AumY3zPyQDM3q6zgEBPsOi8do5ZeqctOcTWYf7Kee47KmZtee/5mE3Yf42a2H2jIL06hlS5E1Ircjuhw+uJBTRLsUZRRctJuCz83B+LuROqGapC0zxGIMY4rFeHj/0u6reN+75g+r4QsIvoeiH9HpbXoAa8p+xPUIx4Py5p0qoMF/eLOsLD4TK7KL8HQ5pRSDMGpP5mke5SbFXUpyBj8C1qYnH/dcd7SOqEkS91jlgYoSiuGfrZWo7uZLaUPd2eJOEYyhIWNsXV+SNONiPXgM1j+r9jpssSernHzCpBB0DC49KPWb+ls4u3qxER06Ss2L2llDYgJTAUmKRuayO+y0SfhasLXunmgx9x/UWM4N1n1O4YTox27VY9j99cDMEYFXv07iZo2hNDknA+KcckY/08Nh8ZwToX1Cr9j2ggcyEp5WlXd4zWtTh9y+/8lo74c6fEYjmFMDOXYs++Rjv0ZbZaRwdf1UqZjNByIxIXJOt/VaMAaWWYuX06SGn8TidT6L3dm40hCeaCkcgilPVQzSregfCBIaHKcb6FBPUBhlF66zkZjUIcI1IH3RdG4fQekL7HM/5Z2TD6UfZwo/dAWJQzlFKzvAiH/tK5mk52CbkileNoDvlmMGmUOmmvUJQn4xS671j837QNBr1N0uaBGpX4enumdFE1ZJtMx6tsfS2/F/EK8WQaSZ+t8Lw7Bq3UCAv2knDrSlpHhIgFx9Of7uDJ7PHU0AfGpAQxaNTBlollCCmnC
 gFQNyGqO
 P5rJCs3JsDKzrg8ViYQAcKlcHyMAzpMFZvoKCsr/ZOxHU69pWlfOjU7S5maz+J7GykHcpolaUVyETB4HJcvISHhA72G9xTTSIh3kQ9udDlkQEpgJ68w+n+q/UFhLTDtHC6JeOCXZMmJZnT4Cvgp5aClbxBBP1gHmDCXP8y5mC10t+EMO/sbHchILhfSoztWgtoMmmXlQv79FKyVZgU4zPdBg44iBIMR89+xPiuDr1kzJ2BWJJc2qMZx4FB4I5QQ1wqpN28oUmmzt6O+YnB3zNF2ZM4ZMJE4zwoX76jQb73JcLCDhDcqD0UlXJzaiJ/zffEQaV
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

v9 changes:
    1. Rebased onto v7.3-rc2.
    2. No code changes; refined the commit message and comments for clarity.

v8:
    https://lore.kernel.org/linux-mm/20260901052950.3284540-1-yuan1.liu@intel.com/

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
 include/linux/mmzone.h               | 69 +++++++++++++++++++++++++++
 mm/memory_hotplug.c                  | 71 ++++++++++------------------
 mm/mm_init.c                         | 63 +++++++++++++-----------
 mm/mm_init.h                         |  6 ---
 mm/page_alloc.h                      |  2 +-
 7 files changed, 143 insertions(+), 81 deletions(-)


base-commit: df2908090cda368b01ff43709f51890076c56157
-- 
2.47.3


