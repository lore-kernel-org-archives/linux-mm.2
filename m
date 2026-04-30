Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA393CD3427
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 19:18:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 519FE6B008A; Thu, 30 Apr 2026 15:18:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F11E6B008C; Thu, 30 Apr 2026 15:18:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 404736B0092; Thu, 30 Apr 2026 15:18:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2EC386B008A
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 15:18:21 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D7133A011F
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 19:18:20 +0000 (UTC)
X-FDA: 84716183160.26.F1091D3
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	by imf05.hostedemail.com (Postfix) with ESMTP id ABD9310000D
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 19:18:18 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="dCts/pjW";
	spf=pass (imf05.hostedemail.com: domain of matthew.brost@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777576698;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=mfJ+PaHPHYmZj5wOsuSC2weJi+AnKJQjze5K2g1rG40=;
	b=gtuL9RtSI+1gskLY5Kd3ITwPt8o17C4MsUBNQT4L6MaRG/6aq4sRRyfU1zxXUgz5WGTgRt
	5KsFTxRpzzEgZ6TpK3P9rilzewh7qQaH9fdvj5U3ucL8mStinB1NtkqldAlhrHmFZPfsLu
	an4f63/XWRSChxzlpSMU0NIF6fvcJbU=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="dCts/pjW";
	spf=pass (imf05.hostedemail.com: domain of matthew.brost@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777576698; a=rsa-sha256;
	cv=none;
	b=LUmkdNlfsA8HXjOe8vsilsd6WUsyfVBksb3e0bmQJLAQajvJWRfAipMDYb5Yd3ruOPDUVc
	MyqNwVDZ6PLsL9Az5J+2FuM++Iiq+7RUMfyHO3OGxO6IIxc7TbsPPZGkznwN8xDyE1Q4FP
	CnLhb4BvvU9KSw6bF1EqouuWRTyOQvk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1777576699; x=1809112699;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=L42AqUAT3K2YUIBwfKldplRFGyIb5HBQqwcfYoydKXo=;
  b=dCts/pjWhChAWXGE5xNsok7ihdXW59S75IcNFv82PA2OHfdneW0gpsN3
   nootZP8Dy/83V4E2v4x+SMvtEkdcmmXl8J39kpDT2VUP9uZEyB5o24M4f
   k9m51h6rfoPI6lQF57CdEjJMQ8iKAPAG4nFmMPP5+3WOYJ4d8XEGAs8+B
   2oKNEjFtU9eJJ1otsdDtTFfZ43TcVUu7qNJl6JGfEJU1MeBpSfTZgm5iq
   r4IwJ2uL1JelvnlkQVhRC+v00QdH+AmDfcx7zWmhpCVImTRW8ATUjgmUM
   GerWSeUUIJtZnC/En3VKsnDgO+7GYmSDKbeSX3fAdHHnxiw7bfzNDdH24
   w==;
X-CSE-ConnectionGUID: +bgTOUmkQmGzMC8dg1bb5Q==
X-CSE-MsgGUID: RFI2Gf0FQsKaHW/w2UOXyA==
X-IronPort-AV: E=McAfee;i="6800,10657,11772"; a="77706708"
X-IronPort-AV: E=Sophos;i="6.23,208,1770624000"; 
   d="scan'208";a="77706708"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2026 12:18:14 -0700
X-CSE-ConnectionGUID: GvPf6uxBSM6MkFg5UrhPnA==
X-CSE-MsgGUID: dEMwV383Q5yUPDG4MwmODw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,208,1770624000"; 
   d="scan'208";a="233801143"
Received: from gsse-cloud1.jf.intel.com ([10.54.39.91])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2026 12:18:14 -0700
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
Subject: [PATCH v4 0/6] mm, drm/ttm, drm/xe: Avoid reclaim/eviction loops under fragmentation
Date: Thu, 30 Apr 2026 12:18:03 -0700
Message-Id: <20260430191809.2142544-1-matthew.brost@intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: ABD9310000D
X-Stat-Signature: wopa7f5g6fbhermozxrm8gjebskdyzx3
X-HE-Tag: 1777576698-407825
X-HE-Meta: U2FsdGVkX185aIgvWvao2BH4tZfNsmLRUGzPgYp2ywMTV3er0oD2BvZsjb2TTjs76pLAMbFaoo3iukOgOvdH8ZRDBfdUxAbn7BtQz6t4NdnsVv8MbDcPlp7d6c9MBshfUIVUN/27sSiejmXS+HFJYXJRrzCQIkC8Mh4PfwSKPSJ+2vskl9YeeCZRmrAUfRi4svvxmULJS7cwDouH9qiFxyga4vJOxoa8/+utq0GwyCYDKVJN9DEY+IdPNH+YMSjPKik8UaNNi0Ba4WJIDAe7Cn5iWLb1IRqhvObKDdhPpo8ilfDaAYG4Bi5wFbipHIThyMEykRe0Wg2n9dQBJ1LZrQE7ZDX5lHQSZUXWrWVKo8sqGLL97Hjbgzj6y7Lrp8b4CaL9YRI3c01g5j6oyyeKDn87WVh3FOQ6+FFO2wih+VJ+Y4bX3RQwAx/rfde9BGdei9bhHFX1Pjzm4HCulo8CeIbqeG1pOpCGXzl3wjhKsHoVMSLMq8WLYua1mf28fkwA3vQg4zeCDWE8rP0m1+XtZdSCBjugiCznTpjNF2yggwolwt8VJbvOgJlFN/RvFnqO2MEX3D+9zzLKfKt9d2Yy1Q4E72Q9uzzVrkVlP2PD8XnFCtepbdATrzu9onLCx5ZAOkMjYVhD5sI+oIjzXWYZE36rT78Nk2VnCBo/nSA6V8YGRhPoFNtecqaqSBHI1W4jedRbtxaLFCJcLbgk7lf263H/UA8QwIjftJfGa2kEfgb6jEBUwEH+pQQJ9KxRIlS0AwEtFe8E9dSLE0Lnj+0V3PkLvE0jIXtdJ/z+rU5k3REhEumjf8srXmyGja0eOwcyrQNCDMc8PVOxfaC7CPEec7PYUAdgZCRWxUuSiXy0yDuUaNhvzx0kCq2juDUkSeWMWu2WsEFD3O9/UZThqocOiGLAMgrHNTTmyl2htTHzW98iBW8+rJjRkPClMaLoSiTTIC87cdqXN64suj6wASI
 23ti8KAJ
 pWQUB3eFDKoHATecHpopfjt6M45Iw1a63hjZbO680GT/lr+htp9iv3v3HKV2yI0uxnK4pwU+2S2dyCBO3pce38WJlLqBt0Q5aHmnbSOSOBZJcIEXNzMrwQw3cobOZiYQm9vvLug/hSsPwV5uXBYRNp8iApMJ2Fqv4IcnNsoT7hFhf3xVNw+ip5ZdwPIzj7o+LPtOfpTUqdSQuGalBDYlVQSbEE5lJglbW+nU2lb3opPXZ28rSJridjByMAORMbgRexROIcL39WAYdwtjKqs41CAn3f22+QvKPXUEMPgswmNWosm48MLsLXpCMcakQ9O4Awf6ghzLdbT9kZGcEbXXHk9N9MwkDbspNRbw3NUdhXNa5RUUP1h15bZi5OGdQXPhlNu6gAZqskR1iywzMqEY1r9eyksg0Nq70s87n8xFCEMYkFjVY4INiCOG8ViS4d7YCtDengJocKbO7RPOo6XLiTEmufaTUqm0HrtkqgNJ5WbPyRbs+cxTWlAbpiRePazzGO+jA9bSt99Ts8sdbj14+nEQE3FGYOKct9mJvOeJeabDu4wW4Q4aEhs69AN22A0+7Ugh+fPNeXuvzyQZxImR2dsjaOnbPLlnCnMSGiTTEDVJaxeuFClAM/sEtE1T7wl6yx7qvDRMXeZo5Sa2MaBCtHk2qTeaTEFe7ZtCz+jcwehRRVy8cDIvIFyEvKyUglaneLm+BX4pdqF3kF+5aGV9dRSAPbUFIQYdKKGGssfEnDnhaeKKsT4YcBHs42Bd6cXgH3hLHXsZWTcyMHsFohRr7sArkgV67Tc4w5gKx6Yp/PGWQmizEs1YGTQkPJw5jQiq0Oj78XKsWBGGQlaDPvBtvla5p29eDyA4NY5d6
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
v4:
 - Fix build (CI)

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
 mm/shrinker.c                     | 13 +++++++----
 mm/vmscan.c                       |  7 +++---
 10 files changed, 76 insertions(+), 13 deletions(-)

-- 
2.34.1


