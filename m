Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B09EC982D0
	for <linux-mm@archiver.kernel.org>; Sun, 20 Sep 2026 08:46:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 459D66B0088; Sun, 20 Sep 2026 04:46:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 40A0A6B008A; Sun, 20 Sep 2026 04:46:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 320826B008C; Sun, 20 Sep 2026 04:46:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 119986B0088
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 04:46:29 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 03D611403A1
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 08:46:27 +0000 (UTC)
X-FDA: 85233509256.22.5AB557D
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	by imf03.hostedemail.com (Postfix) with ESMTP id 7B6C120004
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 08:46:25 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Q3a2QrBI;
	spf=pass (imf03.hostedemail.com: domain of yuan1.liu@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=yuan1.liu@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789893986;
	b=hllmc9YVKVsSSP5C9ro2+O/Fe5CW0rpMzMrSvKq0S1rb+hji83QkQjSS40Xfet6kkCEPWs
	hRWvyMokjrQDQIaXfqlLrIwByvSjR8TFCk7A6tg1QzugXAa1aQflciLnVyNLsqxIOyEN3j
	csQZkU3UUN52CHJW6iIreO72nEkrmbg=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Q3a2QrBI;
	spf=pass (imf03.hostedemail.com: domain of yuan1.liu@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=yuan1.liu@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789893986;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=oSOMI+G6GH4K81R7AZJpKBgbCbBD9midZkdG8xAIrdY=;
	b=tnx1weU4jibNj+XB2jNn6BILkQe50NGBKFoR7gbGN7mtO4Cf3ofKziuFJjcl/YzXXmESmQ
	2CkWliDlSSMCvekqpHd4gOGl5s48MHr6TxSyd8p58b0fhq19Qs/mxXhjt8cz/VOps25KQz
	tRQ/kpS4gegh/UN51+gmGOuRwE9FCqE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789893986; x=1821429986;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=z1vDkfqWC/qArC8TAhQtPYX2WZpjm0/+yhw7QmTP6nQ=;
  b=Q3a2QrBIfZr9wslx3w41mKK5yOHX1G3FYyGzP+hbOMpUwLhDfErnto2p
   z1NHdM1eI4+905Cl3Wv/vrG5yJ3M3UPhXAFU3C3sSfKOODNqNoP1tiYOB
   fuxqriQfyfoxPcrvREK11DMYwhj5/O1X70zwJLLmjz9PwdILKmClWfynh
   x72oJuNyAbqJrDzYt/oskgQPN0m42fM1sUhxcLyTKfedFCH1p4G2vPMCP
   JH5G9SX7eDxZKATNbI1SL4TiYcQniH9Svv6odOKYhAi7Lj2/pd2zFcrPi
   or0Huu25ewk3DStXWQvwgmsYSO5txcoR7UCyYZLcNQ3N317B3eJ5AUIct
   g==;
X-CSE-ConnectionGUID: ojfq9bfUSiqq0aYMjVu1Sw==
X-CSE-MsgGUID: gfxjSzr4RASQJV5bdux91Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11910"; a="94225742"
X-IronPort-AV: E=Sophos;i="6.27,111,1787036400"; 
   d="scan'208";a="94225742"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Sep 2026 01:46:24 -0700
X-CSE-ConnectionGUID: RKE+LWp9R1GHdaKoM8lWtw==
X-CSE-MsgGUID: R9yQhMTuRW+EKBIEOEGViQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,111,1787036400"; 
   d="scan'208";a="280281792"
Received: from spr10.sh.intel.com (HELO localhost) ([10.239.23.75])
  by fmviesa005.fm.intel.com with ESMTP; 20 Sep 2026 01:46:21 -0700
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
Subject: [PATCH v10 0/2] mm/memory_hotplug: optimize zone contiguous check when changing pfn range
Date: Sun, 20 Sep 2026 04:49:44 -0400
Message-ID: <20260920084946.3266279-1-yuan1.liu@intel.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 7B6C120004
X-Stat-Signature: 5ibk65fady7fzu8oy5r9h1pj83r69fao
X-Rspam-User: 
X-HE-Tag: 1789893985-363259
X-HE-Meta: U2FsdGVkX18CaYGmoInshoYqNGmjZW1P1gD1zaNiRFBbKgBljSa/JTbY6allY8HThcD/3rXsG1VHQ8q7ulEBA42Nxgpc8l4hKQ6+AVDoWVvcigsEMmeUDecXDIgaFze3WP7l8wkHyUY7YfQTGb6NX/+EKHQZJIDTY29OP2U7BlRg/bdXET0LJPG/XeIXIjw3qt9EkEI+hYF21en6CL8J8YEzJUKXKY2iaGQuo9Q9sPpaj76IZwv34WHKrnfvoFPfaHqS6MaChmrvQM7MijCUPx49Tk+HI7IiTRC8cDe3TW8NslEQg+yKCsrnc7eDdUE8wVuh1pMBJdRk4y5hE1jYjuFKmEhbWnrkpac0DNl06eIH4l0dgt4qHxt/Tt5biBz8xLMzOm9D5xfoRLbzcKuu7pe1QvvdFfIlArr6rEzkuIMxaUrgr4MIZzAVuukdQ/Ke2YJx6S9TllouQRkboNDUMWTpZno167vFaqHMjXbFFvv1ShMO60VfCo8bouCzHIR+xcx2mINgdFvGVHtFgWoql3kMUtr0OIZsc8dpQFPYf3C7M4P5HJLGp3dD01cU42oR0odobXPBAQTtmvK8dJ1LoFoo02VTPd+Lav8BzAr04sPIPzhiAYA1WFHxy/FnBivCBA9cCkvGPgfqN3XuibyHUjnJiNDWbrg77wiGAU0S8r6t8tSz3nyxE7B7xKm2bT5anhqY6fHmTDJ4StbHlxeFXmslowGYvPXQqZ9uFp3/JtcqYdNkA/zuAA6vvxUu4pB8h509YTJU+sKcsZHO/YW2Ot8+c44wlF7cDIvIxnwRhDRijMdzpakjzTDH3vfOXZBoTrLyNUZb3diFbu8IoI1HC2P+DTd2yaMkGtafsGsUlE5c3WYxiUBXVgLWogk7NH5R5QSMAy4xTkJ2BUvZR6yYWbS7is20bIglrAElv8zCHucrYo/nC8mGwqbEvmzQ0EqlY6zeZ8yzqrY7ZAUG0Hy
 hd9iSlJl
 W0dfIrZiWNXaBMLr0g/ll1abEO12eVx6mYng71sSAwBJuqp4NYllH0kwgv0rDIvjN+W+CPZWjxnLin6xGxWIv7szKwEcZeXM53heFHx7uVebBK7evCLZjnmuxqyujbzWoOsbUfHvf+4egkp7ZH7afS7Fre3E42pp0y6G1tJV+Tr8nxu9AGjy+iGt9s5Du3ZOLPl17CAFcZWyV8R6s2hL4/JwaHTPao63h1gO8hrWeTIcylg80czXmWLfE+YyfzY0lhzTrsiG+U2kD6zW2LITl5Drta3sCKhSEIAKgyLR4nJvRxgCBZncqk/xHRimmF+ia1iEyJgbE7u7G0ro=
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

Note: this counter may temporarily undercount when pages with an
online memory map exist outside the current zone span. Such pages
are only created during boot, when initializing the memory map of
pages that do not fall into any zone span. The undercount itself
can only happen after boot, during memory hotplug, when growing
the zone to cover such pages and later shrinking it back, which
may result in a "too small" value. This is safe: it merely
prevents detecting a contiguous zone.

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

v10 changes:
    1. Rebased onto v7.3-rc3.
    2. Added Acked-by: Mike Rapoport (Microsoft) on patch 2 and reworded
       the init_unavailable_range() comment as suggested.
v9:
    https://lore.kernel.org/linux-mm/20260914072929.1883794-1-yuan1.liu@intel.com/

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
 mm/mm_init.c                         | 64 ++++++++++++++-----------
 mm/mm_init.h                         |  6 ---
 mm/page_alloc.h                      |  2 +-
 7 files changed, 144 insertions(+), 81 deletions(-)


base-commit: fd73f4a6659897191fa0d40695fe370925dd3780
-- 
2.47.3


