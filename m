Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93698CD98E1
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 03:22:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B5C86B0005; Tue, 16 Jun 2026 23:22:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 666936B008A; Tue, 16 Jun 2026 23:22:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5561E6B009B; Tue, 16 Jun 2026 23:22:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 108A56B0005
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 23:22:30 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 86B8D165A71
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 03:22:29 +0000 (UTC)
X-FDA: 84887956818.28.D11F4FA
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	by imf14.hostedemail.com (Postfix) with ESMTP id 15F93100007
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 03:22:26 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=inB0RHD+;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf14.hostedemail.com: domain of matthew.brost@intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=matthew.brost@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781666547;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=0K6TLKQmteGqMPOjogTpyguO3OA0c6FcnunPrM8g9xU=;
	b=GLrMAT4+r70yauUx3cpJOofBX8uePo4+1cb4dMXXPux1KmWwcgTOJuELqwKmdlUdTL5Z0P
	hk/mGiuBY7iblW+QzinE13vwNBZDem0Qh3LOkhBSAxaRInOkS3n3CXn7b3UJK5do8MvysS
	ceIko3aen6PlQBEfxKnPGPGcPHy58bk=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=inB0RHD+;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf14.hostedemail.com: domain of matthew.brost@intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=matthew.brost@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781666547;
	b=r76kdL1Dy17I1P/M3LYAEswK6eJL0MaEyGVXpafNR+TW2LYBAVpQz6CkOTYtAtuLezvM6I
	nWnGzuZ+yWq+Zy0pVQpYeg0mgNkhayRC5zeIqIKa+eLRoqMatRO4az5ehD94bFfp7J/wgT
	yOhlJrcO8giSxLNfjcvEKtowOBNDJFA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1781666547; x=1813202547;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=84O97qTDilDn95yjtESFooPy0tR2mZAlQQWrqQIVeU8=;
  b=inB0RHD+y40yJUFyLTylnI8e1+IxemFlaTnLT9Si7lByIvAlX+c+2/Pp
   UQkIHTtZhEgvTIwpdp6vd8Os9YPPGX1LG5WFnNYwir1EHw1bgUdY0QYC9
   jKhKJWOS4gOgH9aviMh0Xeusaa7WGRWanj+NSZjaQxur/Mgr0oyS7L2BS
   CWnJv7vER7dMTm0kp5uzKTiPKq0mjnStt3aGY2ESbYnX/aQ3t8jL0hbDl
   OVjnJvbiSrzuhyf7mwBM44tQ7FzAhZ4ztrGznLqgpFzQXVhiALz+dRK2h
   +4pZSLFIa+HP5y7iqi/vrP+IhCMKnlS9qnf+3MSDt7+JCWtFFPJThEleY
   Q==;
X-CSE-ConnectionGUID: eS6wKQK9RGq0SvJldRYyuQ==
X-CSE-MsgGUID: iI073GjNS3yQlYW8z3zQow==
X-IronPort-AV: E=McAfee;i="6800,10657,11819"; a="107914542"
X-IronPort-AV: E=Sophos;i="6.24,209,1774335600"; 
   d="scan'208";a="107914542"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2026 20:22:26 -0700
X-CSE-ConnectionGUID: 9z/ROdvTT3aAhlYNvsMV2A==
X-CSE-MsgGUID: 4foYZTSmQPiUg06iRxuMUA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,209,1774335600"; 
   d="scan'208";a="248017805"
Received: from gsse-cloud1.jf.intel.com ([10.54.39.91])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2026 20:22:26 -0700
From: Matthew Brost <matthew.brost@intel.com>
To: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	intel-xe@lists.freedesktop.org,
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
	Michal Hocko <mhocko@suse.com>
Subject: [PATCH v6 0/2] mm, drm/xe: Avoid reclaim/eviction loops under fragmentation
Date: Tue, 16 Jun 2026 20:22:16 -0700
Message-Id: <20260617032218.1165929-1-matthew.brost@intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: 4cbycedd3knzq8jibiq896rw4imixani
X-Rspamd-Queue-Id: 15F93100007
X-HE-Tag: 1781666546-947805
X-HE-Meta: U2FsdGVkX1+KLHp1ybiSzf1lLLaqBSJ53/L9H5Ot34NgDjG+jRNrPndEJa/EErOJJQ7uXYO80/nW6Ty0D4Om23a8FRw+q7OFyydJ8D3fVP2Pee7WDIZkzMmD9T9SRY9lGFayxU461N15RRCfyYBkssx/4CQ3m9znNF3L407VI6N/6hIhjxjQN9X0+DwVMeb56/kvmV/lWDt6XHQzfpfykbrQe4ZDIG0Xx9/Rvl/U8GypQZdWa1AcitB7tfvy6TND2TMlm6vWbI2PLNxgKCKipfAItvR6cleYhSN3R70j1uB6EfqfkpYnE2TkB0jm3BCjn5ytne39p12ZGiFPAZqMHXsW4s0ffZvoCFCOPPZWVqWV7TkMFQanklXAYsmyPQK3gdA6l3cCRCYFRy8F6MRdZRVH+AMQXR78EnCGeUaD2oZP4z5n5KolyRiQICOwijwbb14hWoBjAm2rzSbAqZOzqP+AghPxwXIRiaqrkKtNRvoSjTrNkSxb+InxmtwFLOiXDgKPocRtCgmDYPHl/uD2jmmtXMSQ9+a7XFPMeI/NbUj8ex9XdnGXsfb9EvwX8RHi6wnR3ANakAN4aP2Oj0tOTZEsDHub7vk6h8k60d5SdJF9P1yxXKdnhyOFfye2Gms6OFW3XEXpP1YBS6P0nr9M6wAiJJu4CVzBLIfHPJJnTPxrZ6v2MlSp8L0BvbY8y2L5eVqznMDK3tgu6BNYSKdtYd94CDS3i003IqvvbWbpsqNVPCci9kHHyV8HKd8636/SEawQmhGsYqOrr0Gn8Hg//C6wejYsh9NmCQJ86Ngdf4fxOHiIovuILOqoCXrf4uhzF+dfAKQu4vSYuIBdg+tRXBaqtGqq9RkaTLnUhv4PmkQf/nsYMDD/ypxNkJgmM2onZ63hcqXsnsJqyDJFNaiZ307pkfBJ0u6xBSvUidB6lT784No7ytYWTJU4c50amAI/z0nhHdre2eI5nY8ouQY
 Bx9RKjy/
 fnVJRA/wC1nxJU0uz2EPDZWN7xf4eYfJAKUcdxuRF9E5b8mmvwGe5nlH+ORttTRAC0xfWIaM6Z1ETyuhld2URA7KyTy0I1jY2frJbgCx2cEomnQPcf2Avod5Gz1lijvpAzqij90uIIAmVQrTREdBIDQWat4DELgF7Wd0GhFZ5eWPgw4eNodDWP3NuVjANOmzP5wJmXunmpqRGXEFpEverxpNF/CsX4wJPQKlZ0JvR1yYHyANu8ab7756d/P1Rsz8UqXXdQ23mCH7SkDDf0o5Pg8jTu3I6UavEECgww0ohZlqNWz4TPGakFQzOuYYvGjiENEzxOCaFoPu+QDYe/nIZbIYZl/1KlmIOqeivi/4IM9N+ndJzDJSosygPHs5q1kjb8u1ilJY+twsecL3TSODe6vQtfRhr+uYPd5dIGgFgVi4D4TlP95m/51mIguVz9xXAXksSV2eQn5MwPWzCcMkrlsNTLlVQsWBN8LYojfqGfA9lNTsK5cm5pUyJAYaPXGQU/L+PvEkVJ64J4ErOvBAA+Bkzr/1LLsNr85WrhqzaSpNp319u6yKEj3ybboTLj8t/DQLwd/byaOmNzVFUvfrZm/5pkDK2FtYYTjFKdU4eLwM6qjhqgs41SZ3FZCObnnyjdU0hOfKJ29D1uLQktHDDs20KeWzHmKLJ1hLdzs+3mfzOcUa/fGsUB+QEEKYQY8GEoPyvKPmyt/mZBhDSg+4MAwcx78CNHuPX6PCAdYoSHXW6lZe6jXwfh6MDfyQw/JOY/hPxW+HpOmxkVwud4g+cDIrb6hh/Cwouc9yeK1ZP3MOAygVyG2vBHONlANSV5vp09YhDgM8kCpEhdXx3qL3m84Y/2dihFpthNgRH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Continuation of [1].

TTM allocations at higher orders can drive Xe into a pathological
reclaim loop when memory is fragmented:

kswapd → shrinker → eviction → rebind (exec ioctl) → repeat

In this state, reclaim is triggered despite substantial free memory,
but fails to produce contiguous higher-order pages. The Xe shrinker then
evicts active buffer objects, increasing faulting and rebind activity
and further feeding the loop. The result is high CPU overhead and poor
GPU forward progress.

This issue was first reported in [2] and independently observed
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

This series addresses the issue in two layers:

MM: Introduce an opportunistic_compaction hint in shrink_control.
kswapd folds the gfp flags of its wakers into a per-pgdat tri-state
(see enum kswapd_opportunistic_compaction_type) and forwards it to
shrinkers. The hint is set when every waker for a kswapd run is a
failable high-order allocation (__GFP_NORETRY or __GFP_RETRY_MAYFAIL,
without __GFP_NOFAIL) — i.e. callers that would rather see the
allocation fail than have working sets torn down to satisfy it. Any
order-0 or non-failable waker clears the hint for that run, so normal
memory pressure is unaffected. Similarly direct recliam sets the
opportunistic_compaction hint based caller's gfp_mask and order.

Xe: Consume shrink_control::opportunistic_compaction in the Xe
shrinker. When the hint is set for a high-order pass, the shrinker
skips advertising and performing TTM backup work — which operates at
native page order and would not help compaction — and avoids tearing
down active GPU working sets.

With these changes, the reclaim/eviction loop is eliminated. The same
workload improves to ~10 FPS per tab (Ubuntu 24.04) or ~15 FPS per tab
(Ubuntu 24.10), and kswapd activity subsides.

Buddyinfo after applying this series shows restored higher-order
availability:

Count: 8526 7067 3092 1959 1292 660 194 28 20 13 1

In addition various 3D benchmarks show signicant improvement memory is
fragmented.

v2:
 - Layer with core MM / TTM helpers (Thomas)
v4:
 - Fix build (CI)
v5:
 - Use shrinker based heurstics (Dave Chinner, Thomas's GFP idea)
 - Rename lazy_compaction → opportunistic_compaction
v6:
 - Drop order in shrink_control rely only on opportunistic_compaction
   hint (Testing)
 - Set opportunistic_compaction in direct reclaim (Testing)
 - Drop unrelated TTM which merged independently

[1] https://patchwork.freedesktop.org/series/165329/
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

Matthew Brost (2):
  mm: Introduce opportunistic_compaction concept to vmscan and shrinkers
  drm/xe: Make use of shrink_control::opportunistic_compaction hint

 drivers/gpu/drm/xe/xe_shrinker.c | 20 ++++++-
 include/linux/mmzone.h           | 40 ++++++++++++++
 include/linux/shrinker.h         | 20 +++++++
 mm/internal.h                    |  2 +-
 mm/shrinker.c                    | 13 +++--
 mm/vmscan.c                      | 95 +++++++++++++++++++++++++++++---
 6 files changed, 174 insertions(+), 16 deletions(-)

-- 
2.34.1


