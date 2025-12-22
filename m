Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3633E674B6
	for <linux-mm@archiver.kernel.org>; Mon, 22 Dec 2025 13:59:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B32A6B0088; Mon, 22 Dec 2025 08:59:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1614C6B0089; Mon, 22 Dec 2025 08:59:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0436C6B008A; Mon, 22 Dec 2025 08:59:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E6FCA6B0088
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 08:59:43 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7CDD41389E1
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 13:59:43 +0000 (UTC)
X-FDA: 84247265046.19.65CD62F
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	by imf02.hostedemail.com (Postfix) with ESMTP id 1730680017
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 13:59:40 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=b0J2Diym;
	spf=pass (imf02.hostedemail.com: domain of tianyou.li@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=tianyou.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766411981;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=pn2aOZftvcgRs8lZpiNNgEEXLBXOWZDpE2in4GsqCEY=;
	b=WINFNsXNzuwRkKKRF1dZvRuWoBSEv4Fi35Z0n1bhifSg6CiSBy2BlKTtqkRxD/+2mLvf3d
	TfE4leiO/SXR4pZTpxY4OUxO2BOB8nxCOUVhlPsdIesWCakIbQfn6uaKd+QrEhIj9D7tPr
	j+/9fSpAPMNCqAuI5lIOeg+CXgMeecQ=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=b0J2Diym;
	spf=pass (imf02.hostedemail.com: domain of tianyou.li@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=tianyou.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766411981; a=rsa-sha256;
	cv=none;
	b=8F2BuS/FQZLXfU3w5XfxH/8pEHgIssOSA75s/HC0x5NFNn/XnlRC7b90nhEs3fTAg6C0hK
	Yiju68xDVqIzHReI2c99VMR9cKgludfICsL0yoQ0Z1uQl3li3qsxKoyjo4L5t05PGSERHN
	P7R2daHIGt4dkLDOXYGfM1bQl3/sHcE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1766411982; x=1797947982;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=ttnN8DnjS7+7l4nt/Oo/8W2L/gNpnNAqaQsDPJ3baxs=;
  b=b0J2Diym3WLkHD4IqmJGW9ZoEFDKm3Nx2lMn6JvC4fy5lWfxB0Sn9GvK
   SLEkSKCAnQqWvJayKUR4eHnPjaof0tPUfig9wwiRF4UVn3DbFh25XezKs
   Zme6nSpFW3KflZRzqi34iHu/U+EoU+AFj3qg8BIFh5QFPkbSezflK1xxh
   OhlYjopLEjggb6HggQoTH+hWkDqPiSeRsEklECfTIipCOphdye4MWdGQR
   VhvK004LDzSrVQdiijyYE+L0xrcMZ3XxzfMeGSw9vIZDaevVp4jJLiDV6
   Bq+MQ4/VlN2tHnn9geqGztQfZBL9dpcLOU8UiZpt1TNlPEMzizKaIqdb1
   A==;
X-CSE-ConnectionGUID: RYBnpMCAQ4yw/AqjP5DjxQ==
X-CSE-MsgGUID: m6+di7YEQvWMGwh5behkbA==
X-IronPort-AV: E=McAfee;i="6800,10657,11650"; a="68248498"
X-IronPort-AV: E=Sophos;i="6.21,168,1763452800"; 
   d="scan'208";a="68248498"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Dec 2025 05:59:40 -0800
X-CSE-ConnectionGUID: GbB7OL2ERy+gGAte1jW/Rg==
X-CSE-MsgGUID: PhkXS6MJSe638PA73GlRTw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,168,1763452800"; 
   d="scan'208";a="230189533"
Received: from linux-pnp-server-27.sh.intel.com ([10.239.147.41])
  by orviesa002.jf.intel.com with ESMTP; 22 Dec 2025 05:59:36 -0800
From: Tianyou Li <tianyou.li@intel.com>
To: David Hildenbrand <david@redhat.com>,
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
	linux-kernel@vger.kernel.org
Subject: [PATCH v7 0/2] Optimize zone->contiguous update and issue fix
Date: Mon, 22 Dec 2025 22:58:05 +0800
Message-ID: <20251222145807.11351-1-tianyou.li@intel.com>
X-Mailer: git-send-email 2.47.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: twz947qa5sah4swknnqy7krpihjh9nmf
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 1730680017
X-HE-Tag: 1766411980-166476
X-HE-Meta: U2FsdGVkX18XVmf0WbXIvJmYqzslVxKCAqeULT8YGvlkS6eawO4bHkQpJtfvhXK7NfpJ0V3vppGhYMpHJWKyGRf/Hg3XemU+cmHWfJLaPMExropd0JGZi1c7h+QlVs0RyfRG3w3+9vhoRskQ1ijwdgp3NsGnwr5FH5prBbfbgK4OCEYsnLRAnn6iTX1tbbkDRKfJOHU7Or5O5iSCOGRQX2H+r+FxMJ+xQut81fdZ44J67/ehPqZPOPjtK5z+hPPxGNW4zJKNz/nAH3JNsae9NpqUymtxhYfhhQTPPHeg4HeOD1beBVq5sGZqhJIW9QxOhvq9dX38j+m6BGBfkiR9H8MpySrqGdNW6JL0w1ygm4kWCXLFa2MoDeNzrGBIWzn0Gej6YCKuXxbq+N1909zK5ZVgQLDl3geeSS2iYrHJpG9dT1g/jRI2aV1UuqOA8NvtIF0Qs/hbZ/vozJmEuLh/N7twQF+sAcvLZmYTUT4cB+hYWlegQhEJN1+VDnf0XyyfQVEvwVBdduxLe/cn2B825dmFIdXoFfkEK+sh8zI51ysgJvxPwwi7aJNcr/6vXtNM31bYJz7Cd1l+gMxUJ1dVaf6ApFplNdq7kczOzHElyBxFiEnln49d6K8pYZbdDWjzP+LKQyQhmf/L5N7y9K7EvObSyUxRD8QcqzvX/tPbaH2ryBgLd8Evso6NqOpsREbcKNdcRumfCaBDW/8ruYhMfyiGutLCSoUln/6+L1yKd09R39hpR9TmXcOmAntoQ6R/9LsuTnV2GsGEpl6NqxoPGsQBNm3lllGXnP8S7CdnQqNAMFCysLHbNAWIKNVNatzAMb9XJROA4lBwAbSYpEoQH2tv7WpXLqCd4RFbFbi1sJLDLT4kcVSDsnOZNmB8Yk7Js1wCCjhrpqCVT+yiy86o5p+ensZ5utfAqpHPzaP+Q18s1TjGUxYAk0N5qUuVF7OM
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series contains 2 patches, the first one fix an issue when check
the zone->contiguous during zone grows, the second one add a fast path
to check the zone->contiguous.  The issue fixed by the first patch can
be found in the original code path without the second patch.

Yuan Liu (1):
  mm/memory hotplug: fix zone->contiguous always false when hotplug

Tianyou Li (1):
  mm/memory hotplug/unplug: Optimize zone->contiguous update when
    changes pfn range


Changes History
===============
v2 changes:
   Add check_zone_contiguous_fast function to check zone contiguity for
   new  memory PFN ranges.

v3 changes:
   Add zone contiguity check for empty zones.

v4 changes:
   1. Improve coding style.
   2. Add fast path for zone contiguity check in memory unplugged cases,
      and update test results.
   3. Refactor set_zone_contiguous: the new set_zone_contiguous updates
      zone contiguity based on the fast path results.

v5 changes:
   1. Improve coding style.
   2. Fix a issue in which zone->contiguous was always false when adding
      new memory, leveraging the fast path optimization.

v6 changes:
   1. Improve coding style.
   2. Add comments.

v7 changes:
   1. Rebased to 6.19-rc1
   2. Reorder the patches so that the fix will be the first in the series. 

Tianyou Li (2):
  mm/memory hotplug: fix zone->contiguous always false when hotplug
  mm/memory hotplug/unplug: Optimize zone->contiguous update when
    changes pfn range

 mm/internal.h       |  8 ++++-
 mm/memory_hotplug.c | 75 +++++++++++++++++++++++++++++++++++++++++++--
 mm/mm_init.c        | 12 ++++++--
 3 files changed, 89 insertions(+), 6 deletions(-)

-- 
2.47.1


