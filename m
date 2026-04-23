Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C67EFAD41A
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 05:57:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E914E6B0005; Thu, 23 Apr 2026 01:57:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E419C6B008A; Thu, 23 Apr 2026 01:57:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D0A3C6B008C; Thu, 23 Apr 2026 01:57:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BE8C96B0005
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 01:57:08 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 24CA71B805F
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 05:57:08 +0000 (UTC)
X-FDA: 84688762536.30.B7FE063
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	by imf06.hostedemail.com (Postfix) with ESMTP id DE07E180005
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 05:57:04 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=NiIZtDCn;
	spf=pass (imf06.hostedemail.com: domain of matthew.brost@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776923826;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=3Wa1AsAHxu5Sw8uRW2SbaXqR99QmBMv0AzduGBkqr8Q=;
	b=JwiDs/Cqf/O12pUgUU8/dc7RGnR3IzKjgN/WI/yw3k8UDD1xhayYHyrWJwdLdDPHJkU7WJ
	FVximJNYbasnghzlvwIoC9rnawwVfl06RsNgWM0fHACYOHAtfPB+MGy40LSZ0JSBnpuwKg
	fxroHQj6VI2u6Fe4oqqI1r3QuxYTm68=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=NiIZtDCn;
	spf=pass (imf06.hostedemail.com: domain of matthew.brost@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776923826; a=rsa-sha256;
	cv=none;
	b=uhUHHNGNXjE800eMMTD6rjdLxZajpuOp0BZr1wBU+YvMsSThFoXUhbX9mdwiFoBRmTWrHX
	UAtoWNqNnqIo+B4g/cxhXX3uZ+PnH8W/sLHqPlfMOou9FfuSgC/me4j4h8YaygihlPUqve
	d7WqxaQuYVcVggI8RNlaJ/o3meNQaaQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1776923825; x=1808459825;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=btSIhHvrWGgObDTIWzYNVZ+z5jS6qcYXkXNJRF89AZY=;
  b=NiIZtDCnZNML+uqqtnjp3DnIsm06rxh93OIjSCG9uPLgIi+iNtl/emXA
   Gcmc2vlZRi1N5GZZg7iyan9cV+pwOgpDyHKHLJCf40rNHmaLZpYOYwS1F
   7jPEoGK/qWykS/ytvVksWv56+hPv6ZKtMB1+foqC+ytcn/7WJ75MfI7TP
   TUTj5FuXZ7W38n7c0T8lI1HztXxpXfFj2ahb9gm0WbRqJyM80Q7u7M/sK
   uBro/BIGRGYsM0dKf6AXQvh7QnfqA1QoTt3gF+V1ZBNfIdfR57KNNyVh+
   zkmhqKRSUmzrKVW/H15fOhMTYiaq58kb51EfxZ+Hjk1LEJr+KTx6DUxpE
   g==;
X-CSE-ConnectionGUID: LgEVORUdQQOU0gxME9Lytg==
X-CSE-MsgGUID: jSDD2hR9RlG3ULVe4+LDqQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11764"; a="89273747"
X-IronPort-AV: E=Sophos;i="6.23,194,1770624000"; 
   d="scan'208";a="89273747"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2026 22:57:02 -0700
X-CSE-ConnectionGUID: +hy0CQC5SiyNHR1QZ8u+FA==
X-CSE-MsgGUID: /E9ZSBlsTNWKC4NsB1t8gw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,194,1770624000"; 
   d="scan'208";a="255853889"
Received: from gsse-cloud1.jf.intel.com ([10.54.39.91])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2026 22:57:02 -0700
From: Matthew Brost <matthew.brost@intel.com>
To: intel-xe@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org
Cc: Tvrtko Ursulin <tvrtko.ursulin@igalia.com>,
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
Subject: [PATCH v2 0/5] mm, drm/ttm, drm/xe: Avoid reclaim/eviction loops under fragmentation
Date: Wed, 22 Apr 2026 22:56:51 -0700
Message-Id: <20260423055656.1696379-1-matthew.brost@intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 397air41k1o4bbeobxxnodyrfpy74c4r
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: DE07E180005
X-HE-Tag: 1776923824-630345
X-HE-Meta: U2FsdGVkX1/ugWP3Xr7NgrzDkk7olGEKT0tS9Er/AGVtVmvJtTKCG0JikPR5NvqBWZzKu83otT4HXBpOblo5Nu3LBB/Qk0YJ9wUvGaSDvNtaTpjylIVdjo0s76XHsf823ij1Hau1YBb7+mzZKbfrAlmVvKnnf+KTUVLM2ujf2Bb5jB0Z8lGahwcAEHjnZ2QACagzYOb7oOl1KWhuEmsIGmokeBjnjpkeXKz3xUoWgqtGGehIt/Z3ZtW+4rmsULgtrb258BOGkOrAi22ykD0F0CYLsOBC9ldnNl3+jF71Ttv0zNoMEgi+N4jbvmUpb/BE6MBPbvMoIYDlotZOTKZNKQIWQTlOJw2uzlEP4l8UqVv6hLhG2oeweckKDLApiFutD13AKXoTbtf2Wpw2cX0wOvdeNcl4hZHZqzHNIw+RoGGzyGI142H/hGnwsgQmlUDiDUt5pcISE1Z5nB3hr8iA6ArOnSETR0XXFrJ3YVwKPQ7WHbHn9bvta01yiZwIcVBLE/7seVLLq+4uMc55bffpA+L12q0eJxdMKqHEjYB9b8s1/MdXp+FpiMllEde9Z929B6jRM3DSoSkB4iYxDxT7uN4I/0TUnyvq1cK/mCLBAzT9qp6YdD5W/fOOfT1kugj+iEbxhS+5p1o7AHjei9tNCP7SBLAfjnNIVSAUhHXkCcYmY/a03xynayYThvy47Ejb5/YE3F+69UI3BueE/k1w+0ntNHhjplX6zVNngyNESl+4hq+GwvtXKswyfdtS+Z132c9OYJLkVPXZgP7XoPb9Rpo9BrajTFBgFVz//0qyY3UMlQ2MlReRsyds7cIsIjK0za4WJaEU4xAiFrB8r/SzveB1GtWq4cRT4+6xh7yqTKD6Lk5TIhUjwOHXPo7xEBzTqV+AJIf21EPLjMzJXSQSXSkKGEWDJd+bu3zjg2NPNcc+FMAFg6g34senG4Uo1clbdaXRjxaYxI6uMcFNVJU
 PtqlPn8y
 oM16V0PJ1FIehExqQOXOLh8wfvKyJYTn6iKDe0TK18T430N4dljyzTpl6vBYlNUO2ElN6YMiAe8LZRwnFa3pcoqLyK8ntw9sC2jc9f531g2SjmXtbcIDeivEjkrB1qTdbE41HQAuwFLX/OuGfkYJsKRwz0PZDmU1/ih8loBNxc4s0mMs/rl+EFf6mf8HrP0+oR3PAGiGKidh7OK/+HkRrmROT7D2zMbQdSe4mpJ2/7S6j6XgShQC2ibPXTMQuPFCY4Dkk546E8U4HOoI9BynR23vqff3Skt7s+zZBAiqUSfsZuDIqiaCC92XEHjsTbzCw6bQedl9XoxKuHtMDw7JeXSFo+xUoKg/v7vrjknCvphxS6IzgxVpCwjXgTRAAgftsu7hLkSoUpw/PUWAxKUfyBwR/rUEqXxoYrMtg1peVX+Y1rZs9NY11MWeGABpaKqc9yOEWvqhwzJHX+fDzduNqMLxJYykFG2FIAQZ4M8BxuzDzyRY4I5j3GdOvrlRDzSRn97xYfqbS2EavalNgRSFU7ENKwyupX0hokyELUD/3H/bJVXWTQaJqstZy5VNbySoi3PlQaAW1hndvL9hxlmL+cus7/H0WXjULa1d8hSni/gM0Wy4OhdpbGd1Gzg/+Iw0Mv4CA0EPzYtmWjgbnjNll4uHPWY53KokeBNTRErKlXz0r6Wez9mugYqKL1A==
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
  mm: Introduce zone_appears_fragmented()
  drm/ttm: Issue direct reclaim at beneficial_order
  drm/ttm: Introduce ttm_bo_shrink_kswap_fragmented()
  drm/xe: Set TTM device beneficial_order to 9 (2M)
  drm/xe: Avoid shrinker reclaim from kswapd under fragmentation

 drivers/gpu/drm/ttm/ttm_bo_util.c | 34 +++++++++++++++++++++++++++++++
 drivers/gpu/drm/ttm/ttm_pool.c    |  4 ++--
 drivers/gpu/drm/xe/xe_device.c    |  3 ++-
 drivers/gpu/drm/xe/xe_shrinker.c  |  3 +++
 include/drm/ttm/ttm_bo.h          |  2 ++
 include/linux/vmstat.h            | 13 ++++++++++++
 6 files changed, 56 insertions(+), 3 deletions(-)

-- 
2.34.1


