Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CCA3FCD4F3C
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 09:35:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E4D16B0005; Wed, 20 May 2026 05:35:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 096546B0088; Wed, 20 May 2026 05:35:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EEDE76B008A; Wed, 20 May 2026 05:35:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DEDB96B0005
	for <linux-mm@kvack.org>; Wed, 20 May 2026 05:35:16 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6AA554024D
	for <linux-mm@kvack.org>; Wed, 20 May 2026 09:35:16 +0000 (UTC)
X-FDA: 84787289832.21.7C29867
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	by imf19.hostedemail.com (Postfix) with ESMTP id BBEB11A0004
	for <linux-mm@kvack.org>; Wed, 20 May 2026 09:35:13 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="oBaKEC/k";
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf19.hostedemail.com: domain of yuan1.liu@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=yuan1.liu@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779269714;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=74S38cP0BYdp9t+Qde6eRxVEc910ECMdcjWdefyaVq0=;
	b=IdV0ERJmgdEe0Z8u2JacRR+MPLSJddl1rMPJbhBqtio4oQZkNLV/cWKkuy7BR122e614Ay
	9jTgSVb2ZVa/+Scs3lCCFgjHfhvN08cIRZMtbNVli3TeHZ1yuP2m24LFLWX5QGnLfexTUX
	wyARDGIhrkldrebayFyk+LRwC5nz80Q=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779269714; a=rsa-sha256;
	cv=none;
	b=d8NdTqJsSJ6U8vWtWfMEYh1wBxGBNvZIFA1bQo2rKGtYUGIW5x7NwF3kOf028IUpQwZkI2
	JmKuaCup5vrHmjG5oM3ZeqBN0OS4Tjr9SWHJgqJyINyVTaA5p3PayZSzb8GIiiNekd7S/3
	9YWqG7gxU6zP1+qZRTcC9SIp57VkqG4=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="oBaKEC/k";
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf19.hostedemail.com: domain of yuan1.liu@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=yuan1.liu@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1779269714; x=1810805714;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=nFRZXqgGPfIgPBON0SJLaOpvx4uThcReRRlNS5e7KoI=;
  b=oBaKEC/kAzQl3R5jiFehuhx7nXbWKrz5dVIt93BVWyn52XlVGmSz15P7
   hsVuXwhKCNYkJEzXT8J0jYrQwito4jwD9gqbXqh4R9MwgdKZ5a2fnt2N4
   UCGAwZhcU+XSMYT9+U+HM1rj2VZOMA96wXS+mUgezhV57Pp+9zYl4f6ME
   0/D/PhdrLVtPI27pdTM7l4V31k4rxOnO8nx3gmppj2D79i4zF+ERcIqO1
   FB4p64uOVvciaW2KLxh3mml/BlngLeVQy43lenq4foT9vXAK0uGV6wFTh
   mhaXg+dWYTqxaB/cN5QxElX+idek0l2sRLBPY0JbmzrZkGnBvJwLrrnv9
   Q==;
X-CSE-ConnectionGUID: 95/IRcosSIuBTioxVAq6UA==
X-CSE-MsgGUID: CrN5i3RjSpqVjGVMXrg4Gg==
X-IronPort-AV: E=McAfee;i="6800,10657,11791"; a="90460999"
X-IronPort-AV: E=Sophos;i="6.23,244,1770624000"; 
   d="scan'208";a="90460999"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2026 02:35:12 -0700
X-CSE-ConnectionGUID: 9XB2cf0yS5SPn8XYVUodaQ==
X-CSE-MsgGUID: 4eCEJDTkQJ+WVB3jM/kzdA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,244,1770624000"; 
   d="scan'208";a="241925176"
Received: from spr10.sh.intel.com (HELO localhost) ([10.239.23.75])
  by fmviesa004.fm.intel.com with ESMTP; 20 May 2026 02:35:08 -0700
From: Yuan Liu <yuan1.liu@intel.com>
To: David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Mike Rapoport <rppt@kernel.org>,
	Wei Yang <richard.weiyang@gmail.com>
Cc: linux-mm@kvack.org,
	Yong Hu <yong.hu@intel.com>,
	Nanhai Zou <nanhai.zou@intel.com>,
	Yuan Liu <yuan1.liu@intel.com>,
	Tim Chen <tim.c.chen@linux.intel.com>,
	Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
	Yu C Chen <yu.c.chen@intel.com>,
	Pan Deng <pan.deng@intel.com>,
	Tianyou Li <tianyou.li@intel.com>,
	Chen Zhang <zhangchen.kidd@jd.com>,
	Jason Zeng <jason.zeng@intel.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v5 0/5] mm/memory_hotplug: optimize zone contiguous check when changing pfn range
Date: Wed, 20 May 2026 05:34:52 -0400
Message-ID: <20260520093457.3719960-1-yuan1.liu@intel.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: BBEB11A0004
X-Stat-Signature: penrkiecz7whchxx37rf3kty1yu1e5r4
X-Rspam-User: 
X-HE-Tag: 1779269713-401159
X-HE-Meta: U2FsdGVkX19OF5OD9rZczRwjprtkK4cXKV3C/yQHzFlX7H0yXBQxJp8SCGigKhi1Jli+myQqV2Q3h4XWKKTwREHAdEPbKz6qPSeliNQ7IgIptj4XqLicAqYy9OBLfsjw2z6UavrduMDTNnouyv7J10zMHpaQ7+QZkVzmwIg2FTaP9I7LE8zc+aCEO8GDIrV0bv6RDr4prXPXeTemdXbHtAY9kql7cqTYywJESqJpaTj8eeoqGuo2GqFXzBwZdH3z7lrEv4w8lKgQW2XDNClIIrhy77JBa3Zy2VjjYYGLMcwroSD5gRcIcbiDfUFmMDVxjNCHJIXjeApwV+vGtqo+N/AjzAIGrLkQ5linVXjvJ9MrEaSqZ2JphHmbVK/YQGeFb4OErOrmz/ahNmhHTvb34LDPvK7WZg7oS0X4wZ946Mfz/l/ZMKaWj2F7FoEcaK2eshVoigTNK87M0XGUCdUugd1sY3NMZ4vyGFNjlIibcqg8ZOZ25Nkp0X9/XECQkcA4Pv5UUudaYU0xa+8+xl1ZFtrsNFKLJf3ZOLOdvasEIFYri3rnTMwHX5ExLu9Fg/kuM/k3aW2TwbFVO9clAn8VkO3wwehj/HSezty7mSscv40cBtodcMn65++7tVzQ8Vh/Dmw6otOy5eAyCc2hlaijgdrUEIHp6X4uTdilStit6F+NqzkyPKgywb48I//8aViCdGnpNVswFp6UGCCe6Po8Pm1cKZ9dXP/JPpXijBTEhAmJ8kDyF5A0rf0oGp5m6jXZERt1t+ghWtRzjpYxskdITLDhgaiPeG79zq1egtVHnL1hD4En4MYAQmbUUu44qr4VwteN2Vzq8yqxPp2Tl4NHwoBh9HVEX6EgCVcvHJYcNAMIyBKlmb9aZ8pcw9nmXuSniT97vfCyVTI/QO4v1peTn7z+70hTvwdiMHTRgESH7pv/LXqKXdBCZ27G56SA5+C28v0NAJFXoESUrQ+vvaT
 5hfOvWbF
 yjeYszdueVgUJZHwHD9Sv/5xF9pXRJ8mKE33Ulm+3N3hK4O2hbNcf472kpVk6BtoQSDaQWbx8goy8JSMN3/+qGxPg5UWyz/mEXPB0hTMI9bemlzvjpRk0UnL1MfYvuW6DTJaw+eUPQyct523K1ilUrlNLt8BEgyEmVyO/8imfm2J8/9ljtuAcGe302frG8fxgkfrcpCUs1d9BwfzfrgUtGIXZs3oQINMtHsChvHqbUIENNX9/GpThJC4i5hNat5TM279nBiMLqzxkSeUV1tMHCe+4Fg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series introduces a pages_with_online_memmap member into struct zone
to avoid pageblock-by-pageblock scans across the entire zone and improve
memory hotplug performance.

For VM hotplug performance data, please refer to Patch 4.
This series also benefits CXL hotplug. Performance results are as follows
https://lore.kernel.org/all/20260409023552.GA2807@AE/

Patches 1 and 2 avoid pages_with_online_memmap overcounting when
kernelcore=mirror is enabled.

Patch 3 avoids incorrect accounting of pages_with_online_memmap when
subsection holes exist in early sections.

pfn_valid() says early sections always have a full memmap, so even invalid
subsections have a memmap. pfn_to_online_page() says an invalid subsection
cannot be online and its content must be stale. for_each_valid_pfn() follows
pfn_valid() semantics, and we use it to initialize memmap that is not going
to be online and account it as pages_with_online_memmap, which is wrong.

The cleanest approach is to avoid allocating memmap for subsections, which
also removes the special early-section handling from pfn_valid() and
for_each_valid_pfn().

The price is another test_bit(idx, usage->subsection_map) check for early
sections. If that ever becomes a real problem, a future optimization could
cache "full valid section" in a section flag.

Patch 4 introduces pages_with_online_memmap to replace pageblock-by-pageblock
scans across the entire zone for zone contiguity checks

Patch 5 avoids incorrectly shrinking the zone span during memory unplug when
a memory or hole boundary falls in the middle of a subsection.

v3:
    https://lore.kernel.org/linux-mm/20260408031615.1831922-1-yuan1.liu@intel.com/

v4:
    https://lore.kernel.org/linux-mm/20260421125508.2317429-1-yuan1.liu@intel.com/

v4 changes:
  1. Address the pages_with_online_memmap overcounting when kernelcore=mirror

v5 changes:
  1. Rebase onto v7.1-rc3.
  2. Address incorrect pages_with_online_memmap accounting in several cases,
     including kernelcore=mirror, holes in early sections, and incorrect zone
     shrinking.

Yuan Liu (5):
  mm: move mirrored memory overlap checking to the outer loop
  mm: skip non-mirrored ZONE_NORMAL memory map init when
    kernelcore=mirror
  mm: remove the special early-section handling from pfn_valid() and
    for_each_valid_pfn()
  mm/memory_hotplug: optimize zone contiguous check when changing pfn
    range
  mm/memory_hotplug: improve shrink_zone_span() subsection boundary
    checks

 Documentation/mm/physical_memory.rst | 13 +++++
 drivers/base/memory.c                |  6 ++
 include/linux/mmzone.h               | 60 +++++++++++++++++---
 mm/internal.h                        |  8 +--
 mm/memory_hotplug.c                  | 54 +++++++++---------
 mm/mm_init.c                         | 83 +++++++++++-----------------
 mm/sparse-vmemmap.c                  |  4 +-
 7 files changed, 136 insertions(+), 92 deletions(-)

-- 
2.47.3


