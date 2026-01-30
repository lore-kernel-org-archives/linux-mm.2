Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94AE7E6BF1F
	for <linux-mm@archiver.kernel.org>; Fri, 30 Jan 2026 15:37:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB00E6B0005; Fri, 30 Jan 2026 10:37:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B463E6B0089; Fri, 30 Jan 2026 10:37:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A488C6B008A; Fri, 30 Jan 2026 10:37:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 91C0E6B0005
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 10:37:31 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 34F8BC20B2
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 15:37:31 +0000 (UTC)
X-FDA: 84389034702.22.DADE2A2
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	by imf12.hostedemail.com (Postfix) with ESMTP id 67F1740003
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 15:37:28 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=FXneCOsu;
	spf=pass (imf12.hostedemail.com: domain of tianyou.li@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=tianyou.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769787449;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=XDQLDt4mN6BL/JQ1/gXfRWLzjV6DeuG8IAbUOps0l8g=;
	b=CE2uTdUt1DDNaPLikhPFqwS1/5NK7cs9bJrzpC1XLh5D9V2rnU01uBz7yDwsfTHTJGoMPZ
	6ozsDtjd4LNzQI0KYsxNp1w6bU5MGd0c9Y5MlrvmGwqiLiJR1SgBY07eRF4e1XIvUBbKfE
	MSUJ0isDqHW+Z8kDHECIGfFSnEMQnLs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769787449; a=rsa-sha256;
	cv=none;
	b=syC73rtg7ZnAhBPaSIr0KVa6K4XJrGUuPmSKAvYI0hcy9+3w7tHTRh/AmR1aZWZiFwmMuu
	Uj6BrHk0uZTAetvwG7eBOWHcfvPuR+xNUaV57qZCO9Q3TxdKcJlh5c/cvVykaALJ7fkXTX
	Tf/v1oPIcxP+TeXL9HQL2oYheKZL/3s=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=FXneCOsu;
	spf=pass (imf12.hostedemail.com: domain of tianyou.li@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=tianyou.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769787448; x=1801323448;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=uSb4t7pnsOqvxu0VMSD/Ba2NeQ5REWSQ7aHHa7N/Xzs=;
  b=FXneCOsuQvAHH5DO/pfsz9RFdw0kUhsuBxV+zfajt9rl5Me6RXzBzlUt
   3je1sMfXhOd5LsZgbTbqEIeIpHdsSEOuwpfYhU8uzEvgxwyHKXyty2DsA
   6jWX8OPAwkQ1vvLJ/DcsjfqwB26x/LrhVjrPiihD0+NfX98xQfLR8pOiN
   zuO1VRCuUzKdogfyNUxddumMCxERNfGGNivSY6wVcESRiTKUBLXQuK6PH
   lYmGtTSq//JQmwRrkhcH2nZY9rtfdThMVAMN0pRHNRO3qDWD/Fxh2nbZT
   Uqls2P/mWz9z0FVQA/OGQvHSWCdLKJ2BzDqK7lLy/mVaVPS2GedI+PYfs
   w==;
X-CSE-ConnectionGUID: urFyNmFEQQ+zs2usNkARfQ==
X-CSE-MsgGUID: kKJnQZUQSaaNXqSK9DLyTg==
X-IronPort-AV: E=McAfee;i="6800,10657,11686"; a="71124502"
X-IronPort-AV: E=Sophos;i="6.21,263,1763452800"; 
   d="scan'208";a="71124502"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jan 2026 07:37:26 -0800
X-CSE-ConnectionGUID: Ur4XIj3iQpOTBSjjx52ftA==
X-CSE-MsgGUID: v0WOKj+IRwSyuIgLO9agLg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,263,1763452800"; 
   d="scan'208";a="208989042"
Received: from linux-pnp-server-27.sh.intel.com ([10.239.147.41])
  by orviesa007.jf.intel.com with ESMTP; 30 Jan 2026 07:37:24 -0800
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
Subject: [PATCH v9 0/2] Optimize zone->contiguous update
Date: Sat, 31 Jan 2026 00:37:54 +0800
Message-ID: <20260130163756.2674225-1-tianyou.li@intel.com>
X-Mailer: git-send-email 2.47.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 67F1740003
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 9nj51y4p3yr8q94gykt41spsjobcuixf
X-HE-Tag: 1769787448-389768
X-HE-Meta: U2FsdGVkX19R55MnNqIDyXQptfFXtai+sFuif7rIcJjoICVB0bbzFomS23ugPUbRBLmTRu/5b8u+ndA0BL72tsxyGi2Cg0iwTFfwsqnr7CY6Wfrn0+L4HajlIktz6thj9qoGAdBLAcE6gx9Hv2L1oK21mLbbeYsnbtfySP01ahxO2zuN2LRxNFuV8D+0Xs9GC5Img6YtSeRDnJMIHGUGL371yG0W7RcwL3UtRNMatCkn9fAINAZqD94wWh/+5Qy83heikuxEYHstX31uy5RVb07xreCPP/gn+PYR+cLHWQeCRJ0mfZYZyBMHPFF+uItJ/zi6Jp8MOBhNUyDiPAIyourTG+JF0Xb6JpNKU8+ZkfutityYm9T9u8s+I3uSAyzpLQ1mmIP/flFGKzAFyg73UbkGrUG2iGEXjTcT839pXf4v73DHGf12wuSVaQfT+NHk9cwAbo8rRyQIewgmBVcgUpLf07F3aN3ihfgB1lPgLRpUkasYaKdtAjRrDwniyZShJmRuHy3+i6kgtAv+CATLTD+oE2qb5RllVZdeQw+6s7kLKwi2EWqD6AYrP0vaJ3f1jufPfop4d3SKpuZUoaFuvdYYwJDTVkXzVtaSDA/RPUVKM3OrfW0Tt7j6GjyIQsA/G3TM1aX9pGYP4RiW+KOHjtOwx6h9lUsWAAk718VpDk6ABMZLQOgTRMHHvXIo3qdKQjp6vTCsbLsYfgRA2wIw1tJpiT4GkckcENKswxzComerh10xvaXaOpEduaGaVvt5Tk/VMM0FGUjZmyWAdN1TN0NsImakg440qUfsGcrNUkE3IUVk0SPz9o8hFL12hghnd+pRKRh0cpeppV+CUOJDweX9nnCyx9I4xR8oboRJn0QzDoAYBr9UlgKK9loKw+D9SeG3lm/BXPLpvPYCjx5AdPqqTu59Hi8u3/VNjC6Q+Omi7bDjqIFtcZmngQJCkOY8+bYXq2PEt5MsQHL9Cej
 F6TiPJrw
 QlAeRFNYYMrBkKSPvAOKojXfE/kxGEGOlXJ6lt5tZ51b5xl4zIVOS/KSKV/XIdgQ97TiEiErDKWSDf9qR8w+DYKuR45tDozMX6VT0ou2WVZHtKBnBINV9zZxFqfl0V8GD3bG4tlCkGEZi/27CZsCpBsb8ec4yFxfBWctvTg2aqlFVlubmN4hiAmMT0agzAC8ULQFNIP+L91abt/16vGDv+Jv737qKJR7BeOm7waTjID5mARR1C6hEZmZAXZFqr0ye22PIlzxcvbyyfKezvtat9H/g4A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series contains 2 patches. The first one encapsulate the
mhp_init_memmap_on_memory() and online_pages() into
online_memory_block_pages(), the mhp_deinit_memmap_on_memory()
and offline_pages() into offline_memory_block_pages(). Then
move most of memory_block_online() to the new function
mhp_block_online(struct memory_block *block) and correspondingly
memory_block_offline() to mhp_block_offline(struct memory_block *block).
The second one add a fast path to check the zone->contiguous.

Changes History
===============
v9 changes:
   1. Separate the bug fix and optimization into two patches.
   2. This patchset depends on the https://lore.kernel.org/linux-mm/20260130160938.2671462-1-tianyou.li@intel.com/.
   3. Refactor the code to move most of memory_block_online() to
      mhp_block_online() and correspondingly memory_block_offline() to
      mhp_block_offline().

v8 changes:
   1. Rebased to 6.19-rc6
   2. Add online_memory_block_pages() and offline_memory_block_pages()

v7 changes:
   1. Rebased to 6.19-rc1
   2. Reorder the patches so that the fix will be the first in the series.

v6 changes:
   1. Improve coding style.
   2. Add comments.

v5 changes:
   1. Improve coding style.
   2. Fix a issue in which zone->contiguous was always false when adding
      new memory, leveraging the fast path optimization.

v4 changes:
   1. Improve coding style.
   2. Add fast path for zone contiguity check in memory unplugged cases,
      and update test results.
   3. Refactor set_zone_contiguous: the new set_zone_contiguous updates
      zone contiguity based on the fast path results.

v3 changes:
   Add zone contiguity check for empty zones.

v2 changes:
   Add check_zone_contiguous_fast function to check zone contiguity for
   new  memory PFN ranges.

Tianyou Li (2):
  mm/memory hotplug/unplug: Add online_memory_block_pages() and
    offline_memory_block_pages()
  mm/memory hotplug/unplug: Optimize zone->contiguous update when
    changes pfn range

 drivers/base/memory.c          | 115 +-----------------
 include/linux/memory_hotplug.h |  13 +--
 include/linux/mm.h             |   6 +
 mm/internal.h                  |   8 +-
 mm/memory_hotplug.c            | 208 ++++++++++++++++++++++++++++++---
 mm/mm_init.c                   |  15 ++-
 6 files changed, 228 insertions(+), 137 deletions(-)

-- 
2.47.1


