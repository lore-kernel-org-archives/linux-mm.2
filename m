Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80794CD3442
	for <linux-mm@archiver.kernel.org>; Wed,  6 May 2026 03:33:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6FBBD6B0005; Tue,  5 May 2026 23:33:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6AB946B0088; Tue,  5 May 2026 23:33:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 573EF6B0092; Tue,  5 May 2026 23:33:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4226E6B0088
	for <linux-mm@kvack.org>; Tue,  5 May 2026 23:33:12 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BC1571C10EE
	for <linux-mm@kvack.org>; Wed,  6 May 2026 03:33:11 +0000 (UTC)
X-FDA: 84735574182.18.01D58AB
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	by imf22.hostedemail.com (Postfix) with ESMTP id 8F2CAC0010
	for <linux-mm@kvack.org>; Wed,  6 May 2026 03:33:08 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=EjCiZt0t;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf22.hostedemail.com: domain of matthew.brost@intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=matthew.brost@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778038389;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=0iuMOOE6IpEwGpEGfxB5CjP4eh6JjZYkmRP4mmzjmX4=;
	b=GTO+poBw9oo+TktRsSWHRgPrlHmo2F331FYUy8ITHo1jAJHLkH69NCTsFOIMEyJZsqzDn5
	iaGn4L7Lq8TcsBBFS5wa2mLwV+zCR5/U1bVmvCInVgLmxWMoNhdyldCdITBIrZv6NUJHBt
	Cs6/2jPf6D1vfzuoQrAI+kYmcN4dX78=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778038389; a=rsa-sha256;
	cv=none;
	b=IiRkz376Ow1WQyjNb+1Jcr6cNzOa9ahwVc10CWlLku/as0pSUBNY2gI4BfWfWB16lI7FAA
	V8XN+pA6/6hZ9xsISuXgSYG9I0g86LDtlNMBNOLichjsnm6U8DUEPQ9W1lZzrS+CHVeb8E
	BujZ59jl44zfyJgtBCj6DzTYEc2qAc4=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=EjCiZt0t;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf22.hostedemail.com: domain of matthew.brost@intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=matthew.brost@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778038390; x=1809574390;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=kfiSeyy6TX7E2Ycbz/YAGvO5z9U19PNK24VluwAir5s=;
  b=EjCiZt0tYTVE4Vr3F/1Ews23yxX3ZHZl2vVlGABmjHkbsmBZzeU3TlKg
   gPRHXsl8DyfDgVg0vTexn7NPFff4xdpolnDOOcUUzZka2NRta5PJ/j2PO
   yA8agz8V3HJRU0TYSRsZeSbnE/BwGKiuNbkxYkbqFUvb2m+qP+nbc54xK
   L3e3nQBuF/+rzN+DfiP/MERer72EHbNywvAVZ6vwnFf4BQUdoiyZE4hNd
   s/ryHzRuIr5rz7ifLNhIQwmT2ygo0UVVD+zaCqtq+RX/+eT1q9IOLHpyT
   tAb6qyL1R/cB213Hqu+nCgXnRrq+E3uKEKr+4cXQj7DA7Sp9kDKltKVyb
   A==;
X-CSE-ConnectionGUID: 9LrPSG6qTmiVLU0uulcvdA==
X-CSE-MsgGUID: tVMUjU6DSPOdmj1PxkEI4g==
X-IronPort-AV: E=McAfee;i="6800,10657,11777"; a="78829004"
X-IronPort-AV: E=Sophos;i="6.23,218,1770624000"; 
   d="scan'208";a="78829004"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2026 20:33:06 -0700
X-CSE-ConnectionGUID: WqzPK9p/RQ+MwU1h2N649A==
X-CSE-MsgGUID: Yugi3qNSSg28Cd6KFmMrlQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,218,1770624000"; 
   d="scan'208";a="266342145"
Received: from gsse-cloud1.jf.intel.com ([10.54.39.91])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2026 20:33:06 -0700
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
Subject: [PATCH v5 0/5] mm, drm/ttm, drm/xe: Avoid reclaim/eviction loops under fragmentation
Date: Tue,  5 May 2026 20:32:55 -0700
Message-Id: <20260506033300.3534883-1-matthew.brost@intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 8F2CAC0010
X-Stat-Signature: 5mwa9b1c89hrkse5gthug8gbwh4hgsy3
X-Rspam-User: 
X-HE-Tag: 1778038388-228730
X-HE-Meta: U2FsdGVkX198K42CxIHVJU/X1Ve3T8x7tlm0XLgYc1pL2qfBXoS0nsDZu1c63Z4CspAts1ZCWvWxedHDOrexZJUjpbycC9d+69YKDEM2OcSR5u2IdU7nCNMxE91xZhqf/37Z7dD6VGVfFurgyTHVspKr3GAXAJCfUvsM7GBPAnowwgmOdMdTtPiUOQeqCn6o+jt792ntCU6wOgaW+tm6orjKyDIAdjaJVOi3qblBv36gDe2X62nFE7NqxJfotn5pV6fMxHzpFc24OfEmW/P3ziY6KdTOLECLpPQzu2wojIfkXzgqMkNqrjgTNvb53Q9/EluGu8FED7KLSyr4yKSh+pOKvL9BT/6jF5SjtTAwSw/5JrM9zb5GwWtHR/185+FTPBOen3PHp1c8ep+d4wLgSbOz34W3z7WYJESvgxUr+Y91VPqzPaXAUQyc8naRyPT+Wm9V8ZG1g51oic2KuvdVH+aRyeAGWD58kwcF4p2MS6/yLO4DRSzloYbDvCoXIS0mdBflbpO+rnS8PDEluM+0ja7x7tN+zHyYu1TW7rSElYp94QwgysjVaTBUuFGQJcZ7TIP5BQ8XyerqHfCeVNfX9AzL+xlocxc3kdSohsK5t4+Omosjbyyh7CHGRAA6NwkrQk67PrIpN1OAUrB1QhtbEOiPrTfe1q+wmhHXxlE7KTYHLl0BNlPxNhN8Dk0lybDiFMapem4ATjry6uqfBmDusEduWI7YvEapkrHdiOq1GSPhoBSoukiK0u+CDsQ6VaT1edSimAylmEEQK0Cd0f7FpYqME4RWX5wlM/o+bNvTUvCmU9G7OT7/YL86Ou9pn39ep4K1/VYXB5FrPm9C5NEdF0npvpeHNWGpLy87as1r0caKAHlS0EjOV/4SeKtCNPdXhJjLtHUI22Xh0oIzljkuos1b5yFSoFUeLj362bDLr+fbKT8eaqb0C3F3dTD8WEQg8XuUVoKX/TSKVlspCf+
 5AAnFVee
 0pF2t6Mj9+OSaeDT70b5hST1zU6IqsVnf6HOuBqNkqMmLdwuWlBBI6TS0YLjHgr2wvbKSTFlo5UY9iLDK8eRnLliijEsRAho95Bvgg9C8UVOn0vKquss/CTEmfpoVggFBoP2aMzChu68jEd0fo20MobIl73JYbNrHPJtTXgN/lRij1vaDmYafKevw/tqIXbCX8ljVPgRU2QNjKrAO+MFqhj744XCvfwqX6ZdBdG1D0iB1wtF96I1NCNTl5+gKPYP1fqU5wQX41+6P5nvgD0kYUq/ByAmOKU6PJm1Ghuk78FknX1mUewzaHnvAiuhWSWm2Vn57ih3aH9lYA0CRMJs5iAcQELKEwlOE9/P++Su24RlM2pR/dE/hFVSxkRwsrJqb2zBoqyPlOpHbfan/ukrUcUc6dmNwC9fVDk93Vyjnu7+QRQi9ErF3T5MSKkQPDOmic2BKFwzW4GRZ74zD9fCReLZanYZR8Vz5rNLiM9biDLiHq27ES+JGFKBFY7/ah7j8h/SbEHIzLeLNQDPCqSGK4DUIWYIqp9z0ZXE4jgUF8QKEbtHMNne8MvW7f5YOerPdNE74YNu3XPupj8F1nEw481uvCjsrKT3ooMbMOMB02vfHxPEI93OQuffisBTUIKUIiPKIJUDuQJU21UbjamflVQmJHPjpzLTLAsjMgse3q8cwTjyRRtOigy5SWsA6kMD0t+2Pw32DAmfNUnckZMaDvuSCEsH942pl31RCGeaW0ndCk4EJqwq5XeGXgfF2a0YbPm1Qzybpi44eBgH/VZVce7kAfwsmxLEO3oERKWIR4KwRAppUgIYlWkFRoNq9DIIstQHQ+Mdceg2a/857D9a7Vg5NbBh/X1bCba8Z
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Alternative approach to [1].

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

This series addresses the issue in three layers:

MM: Introduce an opportunistic_compaction hint in shrink_control.
kswapd folds the gfp flags of its wakers into a per-pgdat tri-state
(see enum kswapd_opportunistic_compaction_type) and forwards it to
shrinkers. The hint is set when every waker for a kswapd run is a
failable high-order allocation (__GFP_NORETRY or __GFP_RETRY_MAYFAIL,
without __GFP_NOFAIL) — i.e. callers that would rather see the
allocation fail than have working sets torn down to satisfy it. Any
order-0 or non-failable waker clears the hint for that run, so normal
memory pressure is unaffected.

TTM: Restrict direct reclaim to beneficial_order. Larger allocations
use __GFP_NORETRY so they fail fast (and feed the opportunistic hint
above) rather than synchronously triggering reclaim that is unlikely
to produce a contiguous higher-order block.

Xe: Consume shrink_control::opportunistic_compaction in the Xe
shrinker. When the hint is set for a high-order pass, the shrinker
skips advertising and performing TTM backup work — which operates at
native page order and would not help compaction — and avoids tearing
down active GPU working sets. Order-0 and non-opportunistic reclaim
behaviour is unchanged, so the shrinker still participates fully
under genuine memory pressure.

With these changes, the reclaim/eviction loop is eliminated. The same
workload improves to ~10 FPS per tab (Ubuntu 24.04) or ~15 FPS per tab
(Ubuntu 24.10), and kswapd activity subsides.

Buddyinfo after applying this series shows restored higher-order
availability:

Count: 8526 7067 3092 1959 1292 660 194 28 20 13 1

Matt

v2:
 - Layer with core MM / TTM helpers (Thomas)
v4:
 - Fix build (CI)
v5:
 - Use shrinker based heurstics (Dave Chinner, Thomas's GFP idea)
 - Rename lazy_compaction → opportunistic_compaction

[1] https://patchwork.freedesktop.org/series/165330/#rev3
[2] https://patchwork.freedesktop.org/patch/716404/?series=164353&rev=1

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

Matthew Brost (5):
  mm: Wire up order in shrink_control
  mm: Introduce opportunistic_compaction concept to vmscan and shrinkers
  drm/ttm: Issue direct reclaim at beneficial_order
  drm/xe: Set TTM device beneficial_order to 9 (2M)
  drm/xe: Make use of shrink_control::opportunistic_compaction hint

 drivers/gpu/drm/ttm/ttm_pool.c   |  4 +-
 drivers/gpu/drm/xe/xe_device.c   |  3 +-
 drivers/gpu/drm/xe/xe_shrinker.c | 20 +++++++--
 include/linux/mmzone.h           | 40 +++++++++++++++++
 include/linux/shrinker.h         | 23 ++++++++++
 mm/internal.h                    |  5 ++-
 mm/shrinker.c                    | 23 +++++++---
 mm/vmscan.c                      | 73 +++++++++++++++++++++++++++++---
 8 files changed, 170 insertions(+), 21 deletions(-)

-- 
2.34.1


