Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A591ED2ECF7
	for <linux-mm@archiver.kernel.org>; Tue, 20 Jan 2026 13:33:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E0F5C6B03F7; Tue, 20 Jan 2026 08:33:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DBD1D6B03F8; Tue, 20 Jan 2026 08:33:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF3756B03F9; Tue, 20 Jan 2026 08:33:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BF7A46B03F7
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 08:33:30 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6764413B464
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 13:33:30 +0000 (UTC)
X-FDA: 84352434180.25.AB7F0AF
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	by imf11.hostedemail.com (Postfix) with ESMTP id 8AED44000A
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 13:33:27 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=hkOjPX+B;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf11.hostedemail.com: domain of tianyou.li@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=tianyou.li@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768916008; a=rsa-sha256;
	cv=none;
	b=RQhoplxCRWco3RGWh3JSJ9tgl78a3pN9JQVWPihbpwjrXGnKtZPni5tQuNTbpKUAoUAxax
	hdngMZKPjTAdw8khAEtAR+d8ZJC87EuWLtXdmE2u5plFaLy4mP+eair9CSjUwttb4xusDC
	+ufeLM7gP728ajG2WZkzX8Kf5YynSpY=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=hkOjPX+B;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf11.hostedemail.com: domain of tianyou.li@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=tianyou.li@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768916008;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=5P7CDzdbGqWbGZCdQ3jYtO8lMhKjw/IAhHiRc19mvGQ=;
	b=o5Am7gI+vfmIi+HvWcDmpPb3O8oxlgM3LjNjmcorGUI7fox/IcNYUu100o+n7h1khCiAV0
	2AeruxhpWOjoWtI6I0XM0PkIAgTx8t++oBq07xcYBT6br5GTiD8cGq7mpFxaLA+YRspP6G
	5rim5bAcccyP/H8T/rKOXDMFPMHXk1E=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768916007; x=1800452007;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=GIVLQonRnvNDAmphqJiHVZXAVdJFP0u7vX436lLj/YU=;
  b=hkOjPX+BWQ9F7IW2VbZ5hZLwEXIHMIFUUhVgaiyY6CA9b0iz5k3Ugi2L
   c9SpFHjg4y0Xid7bdGtybUNkIsyrSlS49nlmnmk8er4vJJpJomrSD21FH
   hfYhCDgjv2nVu1GBzYbmlRCK0h/17GyxBt7OniBrfrpsyrPXL28uvRPUO
   C9DhyAf1x+mFAZAaE7UKHMcWlsQg7l556L78qMpZaGPuon/u+cPGlM6MK
   RovzGfyJitcXTUmeWLpbMGbuuZ/rANxQKKyMtG6/Fecqd8DORKNc2TCH2
   ual64QXNBJMvb6SPnQFl7pX4Zq04oc+/UzoLIw9ZjQR0pN1AeCDoxzJ4Y
   w==;
X-CSE-ConnectionGUID: CTwGyURsQOGEHDNxTH+oRA==
X-CSE-MsgGUID: mEFjMu1NQ9iQ3Jqe/0VL4Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11676"; a="81494827"
X-IronPort-AV: E=Sophos;i="6.21,240,1763452800"; 
   d="scan'208";a="81494827"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2026 05:33:25 -0800
X-CSE-ConnectionGUID: 4zREZ3QUT3yfk3tYQQGl9A==
X-CSE-MsgGUID: Ke/QbYWMRKme+ihAlIqVpw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,240,1763452800"; 
   d="scan'208";a="210271999"
Received: from linux-pnp-server-27.sh.intel.com ([10.239.147.41])
  by orviesa003.jf.intel.com with ESMTP; 20 Jan 2026 05:33:22 -0800
From: Tianyou Li <tianyou.li@intel.com>
To: David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Mike Rapoport <rppt@kernel.org>,
	Wei Yang <richard.weiyang@gmail.com>,
	Michal Hocko <mhocko@suse.com>
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
Subject: [PATCH v8 0/3] Optimize zone->contiguous update and issue fix
Date: Tue, 20 Jan 2026 22:33:43 +0800
Message-ID: <20260120143346.1427837-1-tianyou.li@intel.com>
X-Mailer: git-send-email 2.47.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 8AED44000A
X-Rspamd-Server: rspam06
X-Stat-Signature: nr3f9te87mqfkutossmx9ijsfj3u5gzd
X-Rspam-User: 
X-HE-Tag: 1768916007-19973
X-HE-Meta: U2FsdGVkX1+vWkCZmfapETI4eaChAUQlf7dcGyovVUHdtfkKgJvVhIPlZ1QZJsq1XYoWOpRY/Pq8TyveT7ii9llXTRG17+RMP8NthzKuDWqQUbU3T7WHIX9ARdWKiLEpqV5DlLw9zmjXaZvI8DmMJyOgaHPPCQ4hw9HoSU7QqS2HaPWQDNGHr8FSDc6mkoDxlsFAaoXk08mXNeVygf6F6KHsb8XXtKk5My9uPWNPmkyDWsGsnQKc7VuhF2bTu+fI1bCDi9Ove8lepghRAdb8/DCEPJqTotrvBfztCo3XbWBCc5Iwt8ZgRlhm0iju3czs0K4NEJG5I6JoUPB4xBDWM1nPc1nebXJu3UAbzC7Qnf4ilfBndl2qqr+UYHUa3ghJoY6PO/p6zGLrnGFGN03pPo+m3vH7WN03qz4FyYJujCqTXxmLiOxkkCc28l7mmAPQp2rKCsMmekU4K/c3KgEnTdb6obmpYd8ckwpLPJhGfaUoGoaeOYsQvVt7zQ86+Zbxsv1mumcMmErZqaOdEQJhIUtS27072FB+3A+SZzxP1UZb/Pf/KiWna/6nGoD1GD/gVqSP+50YXu5obXWimvyHIKl+oG9QO7EN1y1PJCYXm/y9Yh9/ecBEXJDmnZhtlz56IXs9fTEahBsZwh1yb6BX+Ekl0MAxrNGd1jmZ/bF18eWDqxGJSSOco8xw6cIAaqG4SYyzMNMDHn5frMet7bhDRjE2HQeOY6xCXR0Eh1dM5Mzl888+FMAWlSag4DpQmTwXrTvBGMoB20V2HBjNcHonBIC7kbGxt2qXQYRLalwZxzlSlST0ZRSieyB7izP8ByZ3zZjJ2wH+l7Pn2tAT3leLdCcR4XuL9JIHn0HpxHWUfDkq4J1/lrvwPiBkTnJfe8WtFXdSi0RYFgTfau9RfpXpH6ecNvrtqPo39YlM++QFaoS67IHClywCBNDttkz0HHBJ8BuEGwrds05vXQ+0owx
 FypJbsMV
 SUfWOHrsxgNuvrAVSWU5XNlo4ggooLowk0QHFDAwY+7vzy4+bQqKNM7RQl9uwLVNtgm3NAeFGdFd3JRPpZeMBMSUEwUkmDdElrIHirl2UPROR725iEtJqmOQERFAT6qXZIqF/eqOljimHCYKStl9l4gjfAAcaCzks2xZmEJBWsbOeag77ZyejQDORUsr02ObohUrBKJ3bd76k5DK+E8NLBE4ky7wUeerjLGzI
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series contains 3 patches. The first one fix an issue when check
the zone->contiguous during zone grows. The second one encapsulate the
mhp_init_memmap_on_memory() and online_pages() into
online_memory_block_pages(), the mhp_deinit_memmap_on_memory() and
offline_pages() into offline_memory_block_pages(). The last one add a
fast path to check the zone->contiguous. The issue fixed by the first
patch can be found in the original code path.

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

v8 changes:
   1. Rebased to 6.19-rc6
   2. Add online_memory_block_pages() and offline_memory_block_pages()

Tianyou Li (2):
  mm/memory hotplug/unplug: Add online_memory_block_pages() and
    offline_memory_block_pages()
  mm/memory hotplug/unplug: Optimize zone->contiguous update when
    changes pfn range

Yuan Liu (1):
  mm/memory hotplug: Fix zone->contiguous always false when hotplug


 drivers/base/memory.c          |  53 +++----------
 include/linux/memory_hotplug.h |  18 ++---
 mm/internal.h                  |   8 +-
 mm/memory_hotplug.c            | 136 +++++++++++++++++++++++++++++++--
 mm/mm_init.c                   |  15 +++-
 5 files changed, 167 insertions(+), 63 deletions(-)

-- 
2.47.1


