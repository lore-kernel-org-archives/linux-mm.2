Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62736CD13D3
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 18:23:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB7C06B008A; Thu, 30 Apr 2026 14:23:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C8F4B6B008C; Thu, 30 Apr 2026 14:23:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA5236B0092; Thu, 30 Apr 2026 14:23:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A5B5B6B008A
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 14:23:45 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 69AA81C00C1
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 18:23:45 +0000 (UTC)
X-FDA: 84716045610.30.83BD45B
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	by imf26.hostedemail.com (Postfix) with ESMTP id 95C6B140004
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 18:23:42 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=cP1zoUm8;
	spf=pass (imf26.hostedemail.com: domain of matthew.brost@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777573423;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=26BrTLFAhZQUGNTgVZPzENgcQNgsjCp+IlekJy8UZsg=;
	b=n/uAHE33NIeSZqIeQflTMPrXv7PPJxJkgu3ssEqay+rcVIhYlwKeLtxnNyCpkVNJGoJ/WP
	azbI+Vh1HpI+fInpzkAlQOAJmooujlqpmU/qc6EjtZ49E5eFrlkyubNVYgdF92iJjYUz0M
	eHuE3fRSF8nPs5RUQlMntuWAmTLhSQA=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=cP1zoUm8;
	spf=pass (imf26.hostedemail.com: domain of matthew.brost@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777573423; a=rsa-sha256;
	cv=none;
	b=ZMUtAvtTYBGHhJZ86aR1eoQtrutd/wb9XBBQxCKGnekzkIV+hy0ghS76HiZ+uZO+DKbuQK
	pCCBuYn3jdL6H1fh9f5pA9Ffq3pBWZ22ObFTortp6TT4FcnjgT37ouV1/pSx95zBIltMxx
	zabx/P+8VjmYlce3Co/E8YruECcOnfU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1777573423; x=1809109423;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=FsO4JnVIDPP/jhBEsxzA3sSMGqcfLFwN82sfPvqecMg=;
  b=cP1zoUm8YpkYU5DVPhNUGOf60YLJZlQrtjWTahhYCta+ndzPgiQBGe0O
   O4LZPL0qk0osz8fXtf6TFkEt0k8JJz8I6dE3/GYMFlpS0UgzTtgkaYJ3h
   8KmNUQi++bjzJYKd129seXQFESb/8NsvdvlY+SoMUarPoER95fP/Ehd1I
   rainQHZx5+7H7voAqY86Y1q8Ii4aLhBa8Jd/Kvejjk2UoIghWcW7l9Y1/
   xkWgdNlmd0SSK/9N5jdVKl9ps58NhTa8taKjRfQCaQhZ3mOnWcWSpJ3s7
   9/UXj92XbgbvAXE+MaDi/D0KxkEIE9OSP7+Lt7UYqldmPGzf9iV0dp4hb
   g==;
X-CSE-ConnectionGUID: fVVHkuAcQq+1sNKQxAArDw==
X-CSE-MsgGUID: Gtxqf1K2Q5qGwx59XPSHSg==
X-IronPort-AV: E=McAfee;i="6800,10657,11772"; a="82388961"
X-IronPort-AV: E=Sophos;i="6.23,208,1770624000"; 
   d="scan'208";a="82388961"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2026 11:23:41 -0700
X-CSE-ConnectionGUID: kcv4hmzlROSQDxy3HqISew==
X-CSE-MsgGUID: OHgsn2/pQv65OzuH0ynSPQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,208,1770624000"; 
   d="scan'208";a="231532216"
Received: from gsse-cloud1.jf.intel.com ([10.54.39.91])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2026 11:23:40 -0700
From: Matthew Brost <matthew.brost@intel.com>
To: intel-xe@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org
Cc: Dave Chinner <david@fromorbit.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Kairui Song <kasong@tencent.com>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Tvrtko Ursulin <tvrtko.ursulin@igalia.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Carlos Santa <carlos.santa@intel.com>,
	Christian Koenig <christian.koenig@amd.com>,
	Huang Rui <ray.huang@amd.com>,
	Matthew Auld <matthew.auld@intel.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Daniel Colascione <dancol@dancol.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/6] mm, drm/ttm, drm/xe: Avoid reclaim/eviction loops under fragmentation
Date: Thu, 30 Apr 2026 11:23:29 -0700
Message-Id: <20260430182335.2132382-1-matthew.brost@intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: q456ftg85dum7jwtt3oh7u6i1fha6796
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 95C6B140004
X-Rspam-User: 
X-HE-Tag: 1777573422-240298
X-HE-Meta: U2FsdGVkX1+uNaUUv4ZM8xXjbdwLpWrnp/ED8ByBhE2FIc9PnYW4fgZoLJzL5X2syyh7lNerlJxBF56LUrnxuHHdDtswBvK2tczAAl+38Oo+hqo6vNSUSFJfqXopRmoBBQV4CI2vMEf9GMkkvvTrJ99N7nHFaSpWDP3AbJZ/kQABgKzJoIDr9UTcHcjfr/CNFnkL+GeXPjLbiRvLHPqsvNrW+M9JH0fUo5DubFAaNHYTTKGEdo053q/v86ZRJL1hpTIFE6JiavEpIcioyVX6xtO8qDY81GfDYR3/lzPczZegb1vKjX4HVzmquA6KbvjkQR0vf9EcQVtgt5IJ18qypzdsibac2wsktXH07XkrDYZ+igHeARyoAibQO8YzfuJU40UPyYRT9dzfGAjBpw4A5alo//L6bJmFuB4IOY7OOGLBXGdY/R/iqsmnhNX6QB/Hr8pNREVFtlkHSwexFee7C+tRha2mPDTid9PT2PdYNeTklBuJcwp+xtOrtmzdGzDsr+ZDqqQd6znq+XnlQqiCdfWNzTrvfLNC+kNxvp91MvSjgxtfWsDR6EpZmC7QltZUGv+rLychI1md54SrxR+HbUC/wOI+85cpUWperdXsTSAmbm4pkw4spu6eRHfRQAUEx18SBH503H+xuoKLoARMU8RbVrbKTHIvxbrDwp77Ga9mdfRtsJMT6HLfDc3wUAoHMwj67TVRr3RheduLfPdl66IrPu6YqJAu8OyTUt1s6TDnxRfN5aX4ZeuAz3pQ6PrWnDCp+10B4a/mOK+GEvUh0f+kvByzKmRQq/AJ6suwyQsm1AJiI4CDRJNiriylVqg5QFG/PfGIfLaH2yz27S2OXESHKdXLk9ywPtEG7RokE1wI11QTZcaAECmN6SJBrJ2b2Su/xLmfuGAll1iK9N7DDDHyTYl16pDURcZCBVS1UM7BrHxQOcHA07MZDiz3W6OdHoPkEEqF9dqi1bn/sMP
 yv05KQp1
 3LzUibcjBsCmjicbLh/EyzFd2vl/q3jkfhWwvhc4dwMmkfRdWwD0BMr8eJcwm5t3e5K5Zl/2mESRPT5sdDAjhQ+Qew75pVIeQuKFLxKYNpu+f4EOe4eqcaNTc0JiguTVtOTo0llsHsOGwqBuAV1RYAyPM6jRxZF6dP5zXsVfcaMLTyUw/kl/0ezwQGTvprEfuhSAj+jtTeK8bKGJNNq7SptvFsyTQJM3x1qS4E5Jfhl5vG4xe8cDkzbkFDGe90ynFNWl9DkH3yLRVrQkPNOlnQpTG093FRSDRln5BQUMyGMEmfNl0ERIkAp04yAJjL+mNR//NxKzfn2wHuHUmtWl2ZKvbhpiwd4aMAFX3kUp0dtNfDu1y7NfcR5wQm4dyQdrkdXgGT8yDepK2Ey1XixUyGXSRTYXunYg5pCz1a9LRKZNuZ24G0q47G0o6ul+joGYgnnCB38sR+Lu2kNNS4PFLWJJwhIB6/5JMTi9aW7gL7DXCCoCr/Ypz8cYHMbH8DyQ/2T0YuaFVCA6m+ny2XfeVGBWk/kC7lx5VABMSsKxkGNUVZBcAsFdjGaNpXAtNU1ViO5cGEIJJE0q6J+o9ii8oxmi23cAvCu+eLe9UjGgyEYvL9ytHPTlcwLSuzOJT9krI+6AVT79qZ+roWQp1u8hLxf9RdAlPTW6uaMWcQKxj+f6EeS9Fdd/bcrDfREDd2oE7E9ssGKufAiNeARynkLIELtKcECuBEfJQPUQ3CHoUCKlBVJKtZs0iRoEfLImHj/53uIIzQb8LGgbWa7tPli6+VYxlKuSdLnZQpGz3P5tBK3sE8KkH5jcyF24VfC6f/uCYspjXCjSZTDO+KgpWO0+rOkj7QMmvYzDvXbqn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

TTM allocations at higher orders can drive Xe into a pathological
reclaim loop when memory is fragmented:

kswapd → shrinker → eviction → rebind (exec ioctl) → repeat

In this state, reclaim is triggered despite substantial free memory,
but fails to produce contiguous higher-order pages. The Xe shrinker then
evicts active buffer objects, increasing faulting and rebind activity
and further feeding the loop. The result is high CPU overhead and poor
GPU forward progress.

This issue was first reported in [1] and independently observed
internally and by Google.

A simple reproducer is:

- Boot an iGPU system with mem=8G
- Launch 10 Chrome tabs running the WebGL aquarium demo
- Configure each tab with ~5k fish

Under this workload, ftrace shows a continuous loop of:

xe_shrinker_scan (kswapd)
xe_vma_rebind_exec

Performance degrades significantly, with each tab dropping to ~2 FPS on
PTL (Ubuntu 24.04).

At the same time, /proc/buddyinfo shows substantial free memory but no
higher-order availability. For example, the Normal zone:

Count: 4063 4595 3455 3400 3139 2762 2293 1655 643 0 0

This corresponds to ~2.8GB free memory, but no order-9 (2MB) blocks,
indicating severe fragmentation.

This series addresses the issue in two ways:

TTM: Restrict direct reclaim to beneficial_order. Larger allocations
use __GFP_NORETRY to fail quickly rather than triggering reclaim.

Xe: Introduce a heuristic in the shrinker to avoid eviction when
running under kswapd and the system appears memory-rich but
fragmented.

With these changes, the reclaim/eviction loop is eliminated. The same
workload improves to ~10 FPS per tab (Ubuntu 24.04) or ~15 FPS per tab
(Ubuntu 24.10), and kswapd activity subsides.

Buddyinfo after applying this series shows restored higher-order
availability:

Count: 8526 7067 3092 1959 1292 660 194 28 20 13 1

Matt

v2:
 - Layer with core MM / TTM helpers (Thomas)

[1] https://patchwork.freedesktop.org/patch/716404/?series=164353&rev=1

Cc: Dave Chinner <david@fromorbit.com>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Kairui Song <kasong@tencent.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Cc: Carlos Santa <carlos.santa@intel.com>
Cc: Christian Koenig <christian.koenig@amd.com>
Cc: Huang Rui <ray.huang@amd.com>
Cc: Matthew Auld <matthew.auld@intel.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: David Airlie <airlied@gmail.com>
Cc: Simona Vetter <simona@ffwll.ch>
CC: dri-devel@lists.freedesktop.org
Cc: Daniel Colascione <dancol@dancol.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org

Matthew Brost (6):
  mm: Wire up order in shrink_control
  mm: Introduce zone_maybe_fragmented_in_shrinker()
  drm/ttm: Issue direct reclaim at beneficial_order
  drm/ttm: Introduce ttm_bo_shrink_kswap_maybe_fragmented()
  drm/xe: Set TTM device beneficial_order to 9 (2M)
  drm/xe: Avoid shrinker reclaim from kswapd under fragmentation

 drivers/gpu/drm/ttm/ttm_bo_util.c | 38 +++++++++++++++++++++++++++++++
 drivers/gpu/drm/ttm/ttm_pool.c    |  4 ++--
 drivers/gpu/drm/xe/xe_device.c    |  3 ++-
 drivers/gpu/drm/xe/xe_shrinker.c  |  3 +++
 include/drm/ttm/ttm_bo.h          |  2 ++
 include/linux/shrinker.h          |  3 +++
 include/linux/vmstat.h            | 12 ++++++++++
 mm/internal.h                     |  4 ++--
 mm/shrinker.c                     | 11 +++++----
 mm/vmscan.c                       |  7 +++---
 10 files changed, 75 insertions(+), 12 deletions(-)

-- 
2.34.1


