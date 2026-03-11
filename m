Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE3741125875
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 19:51:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF2646B0005; Wed, 11 Mar 2026 15:51:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA03F6B0089; Wed, 11 Mar 2026 15:51:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B81B66B008A; Wed, 11 Mar 2026 15:51:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A49CF6B0005
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 15:51:57 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 59A611A03D7
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 19:51:57 +0000 (UTC)
X-FDA: 84534827874.07.B3CE1CD
Received: from mail-oi1-f173.google.com (mail-oi1-f173.google.com [209.85.167.173])
	by imf23.hostedemail.com (Postfix) with ESMTP id 70306140009
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 19:51:55 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LpVJW8jH;
	spf=pass (imf23.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.167.173 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773258715;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=7aHPhdDyOXpYHbCyzKIIDvUmbmQ3BcfB3tK1FnL3jrw=;
	b=6aSeNEmquMfgBGVq1dZ9R4u1S6qxNAiW2pR5J5UTfnm4cYZmXvDAbuqIzCU+BWbFoZyxYd
	3Gy/7g7djvUo7qnjNnk32lICsix2mTSy2xTNGWMCa80G97/gXwd6JaQuZ/ZhqGPg30Gm+Z
	ffUhVkAaC5b0zFwp16cVRuZSKWM5AvY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773258715; a=rsa-sha256;
	cv=none;
	b=yh5hRuCR4nsuS4cbk+xdXmg1Efh+lnMIwxxJx9/SgqagiJNxJmagfTvlJ+G5w8l6UCY1v5
	hSwXp/UCgitkjWwrVzNiQyUzDTOkYOpMyevVeE9w0uWXWXd06NwzUgr51DbUb2rYbdZmax
	IWi4rIVJB3rR04MTwwHs2cskA4YtYYI=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LpVJW8jH;
	spf=pass (imf23.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.167.173 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-oi1-f173.google.com with SMTP id 5614622812f47-4671cbce465so171448b6e.3
        for <linux-mm@kvack.org>; Wed, 11 Mar 2026 12:51:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773258714; x=1773863514; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=7aHPhdDyOXpYHbCyzKIIDvUmbmQ3BcfB3tK1FnL3jrw=;
        b=LpVJW8jHoKOqke4kswNAkinW0nwdjkd661E0zsHSz6PNo4uFcKv76xSTik17+Q1J2K
         ie8qKlpOimDBDg1wW0mJUm7A7AkOBOf+ERfiWORD6To0Ev8Q75eJ0y4VjmNWiiFN5T/0
         vWI4DyPHYnTXi9H4ltklNGl9nWFQ6r0Tg7iG5X0VGt4N/rM69OljGE1DRR1nbGcJkUgF
         x94yCAVpi0twQTC2X3rSXcuEIvXKObhyCCcwzGJGhng17VI1u5S7kjXcQyTVctLXLX/L
         czG2OdZ43e/oQ2VEW2hj9oS59P5o5vllkTEEIFbRtJYkmb2rNN4OnxJZqPuouz2+3kOE
         Zr7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773258714; x=1773863514;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7aHPhdDyOXpYHbCyzKIIDvUmbmQ3BcfB3tK1FnL3jrw=;
        b=wmBhkIZRetK+bYXz/yHMfbd3gEsXAcvc+lnV0xASW6O/ivtA61D0hN7LjR1xyjUHgt
         TdVspmWGrUNpz16POWlqSjPU4jwmTqMXaZH1vzwEAi0gfrZldxRQhaLfpln9YHZES0Td
         /IyxQgqS8QPXc0+FXceeL0En27HwU19cJdExa+gueNhtLmWWRXxeEbD//zPG7wLRZdf2
         s4nX9d4iKVl5FYyWv8/m8WxNaFgCEA6ckUOUogg2sWew2G5K9IiaoVB59KPGNUI6UXuk
         oSqOZed0gbz063Z8z0aVK2KjmheQuC7R5ECgVkX6umeHgXPqB3u8qaTD5VA0bJFjgJ+/
         MRXw==
X-Forwarded-Encrypted: i=1; AJvYcCW5fz9XUifdhz9shgfx7UsqDmcHQ43qmiX/UrL+U9bx6DcaVCiGd5/+uW5BrEpIjeIOUAjzD/AJng==@kvack.org
X-Gm-Message-State: AOJu0Yziloy2Pau2rXK3spOiH9D+zXYt7lbPHSGI6++VO5hQRWg1OHU9
	v1hHIAbSexwaQV9pYRqbClZ0rU0ul/AeF5X52Lj9IAHlYl1W7FkUvh8V
X-Gm-Gg: ATEYQzwLFGDwAr1IMrW2cISArrjmLimwwvEcRyH1AIaeyxGvmgTjqeU4bWqvHYfeNWi
	3E21P4e6NixI289ZOb9GIy11eD2oDq+ExDqznyNGhav+dxexy+PZ8+L7ZL4tUr8Ql22VGh8Ejgj
	NQ1n8GO98q9IshAcgHipMlXhb3RaYFRnjDhjoYbJEPsPqE/0SNKA4PUDODhehORHzZ2xNhnV00T
	q4lH2DwFsnaNpw44Pqquca6qsZMhscDhjRx2NkJaCEuycWA6Nba1OQqmFQpXXrEcMH5oq4TFX3D
	sAA+LRfnM9HDGzgWG9shDygg/Cz4MQzbow984uCnSUaKrqRQn5WpMbi4AfzEOPOXZsQllOIBylW
	CUPSk9eIVPgzv3FzSjSmsVogAvRB2VLHqTz9Ag3JtDyfjdRL7UP6hZi5Dh4TEQc5QuKlRFcpc6c
	7TJb2mEFE534GsE1EMSN1+
X-Received: by 2002:a05:6808:14c6:b0:467:e7b:6fd5 with SMTP id 5614622812f47-4673359a676mr2487176b6e.41.1773258714266;
        Wed, 11 Mar 2026 12:51:54 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:8::])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-46734125bdasm1805164b6e.1.2026.03.11.12.51.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Mar 2026 12:51:53 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Minchan Kim <minchan@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Nhat Pham <hoangnhat.pham@linux.dev>,
	Nhat Pham <nphamcs@gmail.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH 00/11] mm/zswap, zsmalloc: Per-memcg-lruvec zswap accounting
Date: Wed, 11 Mar 2026 12:51:37 -0700
Message-ID: <20260311195153.4013476-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.52.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: q5fcy13y7jzub74tdncwry6ebdymctsb
X-Rspamd-Queue-Id: 70306140009
X-Rspamd-Server: rspam03
X-HE-Tag: 1773258715-724311
X-HE-Meta: U2FsdGVkX1/uXwrOwq1F9oSYTepvhUaXgwa/nAD2fCBYmtSHR6W2SDBynXEmLI6Fr9U9H1QQ0kuzUk7g/P3y3I+I8RjkK3wNWqxGclD2n4G76RjaDfORi9ctUfH0u1ZexUXcQFMdI9Qv4GqIGyxgRtbV0EWtO8nuc2VqZYzpRGcjJewxSoiRZDd8H/CAO4S9RNGJFn2jBW6tMTVSuV7GT08h/62eJNCC4fvm05Qiqnc/p02yw14r4hRXK+IB/RrN4INKxJZ1HTc3YvviPPxzuhpoeqVOcuVpHa9XD0PwVHmY5hJAyHKpXLByN6sSP+Da+La0y779QLoFTIT88+Yd8Ac0td3CuLLuuhAyrCYxtqkWsXGg+PkAtVoiXZJbXpM4MqRtc8YTppBf3kLyFZnbBy/xXQ9leEym9oTRTpXxSWwb9+CV0uPjBUN/T/JtZxGI+vA8GV/b6xs23cY1nO136XblvM+2xrqpAp7RrHUxqMSnl3BkSuqUQDm2RiKROVRVlbiIW0/XbsJo8O0tSrLmJC0xFk3QKEhVIsrq1qCKZqJQbOyaXLkY83zIX8tMtXnm3wUhvGvTVR1ekt/tzMP/YDH/p+OQOKarWlmLOX1GcUrLqRBFx9VewO3buNNFH6HSKkzmVxBW0fHltjRHC7r/sJ4nwg4j3BbzGG4McMc0KueOfeFDIS1Q1itlyr13Z4M1TQpDa33rJLAnJlqP8TkkRfQEE3TRumJTq3SjgMABebP7D76glSloywl5jTGj1dUEqTNUzbw4NWk7caH4pNGXwNfTYCWAB9nC8egwjBkTPra1PQZgtKYTUrZMVk/P6BTbzTM7Pp+vTMkj3jIjAN+8apOPWuM1wiot39y6ouxY+lDS/BPxE4mioNrQzRweF3kAy5mdWXPWVYqcY9yZIxnVgbjHQkAEXLcDPerswZBx/PfMGpIDmPLIZSbkLr7yfAARMpI7DZI2ZGavcM5pwkc
 /4EP09eS
 WhCwEBTeRFyy+r2VW/mvwkkwMXhv0U0p8YIM7zVvn3Egck1Pyq5C8djnvNyqEaGf/06UglTiQXCN4I23ux/Klnpacx0ADkAXg7M7qeasVffP9ayRDKvtGlst120LRa9Ib6QfzWWnjxkPAzUJwWXIgKwES8flyGBB6MZwR0gaVf3C9OYmKkR+H/ZCDlXyAjn9hVs8IakE78mSo7GK9AXpte4taICpUM2uOdUnwuFo2rm8ZKHCZcvhcmehkhPbgE0lK3ZFRnz7tmfxMNXqv2FyWeRp+41XGOCVR1kjK1H95PsjhGETqJEyN540KPCRxqPcm4QEh1/tNSaPgxy+0AGxMNBnqdHTGiFjc+an5exyjRThTFvvCl+EaA/v7o5DfCK1QEcDERBOL5ObJ6AHK5AwSkL5Mue0pO9dYFmeZbPWMKw4ASKIGs5AfMCxEVXok+GHiNsvynlo+GR/L+5ZUt4G6xTD5sXyXEZ+hxYcGSEJwUVGMLdZblSiC/j7l2nzMp2VseAsw6gY5UoroPjTJr4P54fR9BZJTYW5o2Td1RKwACFlTt7s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

INTRODUCTION
============
The current design for zswap and zsmalloc leaves a clean divide between
layers of the memory stack. At the higher level, we have zswap, which
interacts directly with memory consumers, compression algorithms, and
handles memory usage accounting via memcg limits. At the lower level,
we have zsmalloc, which handles the page allocation and migration of
physical pages.

While this logical separation simplifies the codebase, it leaves
problems for accounting that requires both memory cgroup awareness and
physical memory location. To name a few:

 - On tiered systems, it is impossible to understand how much toptier
   memory a cgroup is using, since zswap has no understanding of where
   the compressed memory is physically stored.
   + With SeongJae Park's work to store incompressible pages as-is in
     zswap [1], the size of compressed memory can become non-trivial,
     and easily consume a meaningful portion of memory.

 - cgroups that restrict memory nodes have no control over which nodes
   their zswapped objects live on. This can lead to unexpectedly high
   fault times for workloads, who must eat the remote access latency
   cost of retrieving the compressed object from a remote node.
   + Nhat Pham addressed this issue via a best-effort attempt to place
     compressed objects in the same page as the original page, but this
     cannot guarantee complete isolation [2].

 - On the flip side, zsmalloc's ignorance of cgroup also makes its
   shrinker memcg-unaware, which can lead to ineffective reclaim when
   pressure is localized to a single cgroup.

Until recently, zpool acted as another layer of indirection between
zswap and zsmalloc, which made bridging memcg and physical location
difficult. Now that zsmalloc is the only allocator backend for zswap and
zram [3], it is possible to move memory-cgroup accounting to the
zsmalloc layer.

Introduce a new per-zspage array of objcg pointers to track
per-memcg-lruvec memory usage by zswap, while leaving zram users
mostly unaffected.

In addition, move the accounting of memcg charges from the consumer
layer (zswap, zram) to the zsmalloc layer. Stat indices are
parameterized at pool creation time, meaning future consumers that wish
to account memory statistics can do so using the compressed object
memory accounting infrastructure introduced here.

PERFORMANCE
===========
The experiments were performed across 5 trials on a 2-NUMA machine.

Experiment 1
Node-bound workload, churning memory by allocating 2GB in 1GB cgroup.
0.638% regression, standard deviation: +/- 0.603%

Experiment 2:
Writeback with zswap pressure
0.295% gain, standard deviation: +/- 0.456%

Experiment 3:
1 cgroup, 2 workloads each bound to a NUMA node.
2.126% regression, standard deviation: +/- 3.008%

Experiment 4:
Reading memory.stat 10000x
1.464% gain, standard deviation: +/- 2.239%

Experiment 5:
Reading memory.numa_stat 10000x
0.281% gain, standard deviation: +/- 1.878%

It seems like all of the gains or regressions are mostly within the
standard deviation. I would like to note that workloads that span NUMA
nodes may see some contention as the zsmalloc migration path becomes
more expensive.

PATCH OUTLINE
=============
Patches 1 and 2 are small cleanups that make the codebase consistent and
easier to digest.

Patch 3 introduces memcg accounting-awareness to struct zs_pool, and
allows consumers to provide the memcg stat item indices that should be
accounted. The awareness is not functional at this point.

Patches 4, 5, and 6 allocate and populate the new zspage->objcgs field
with compressed objects' obj_cgroups. zswap_entry->objcgs is removed
and redirected to look at the zspage for memcg information.

Patch 7 moves the charging and lifetime management of obj_cgroups to the
zsmalloc layer, which leaves zswwap only as a plumbing layer to hand
cgroup information to zsmalloc at compression time.

Patches 8 and 9 introduce node counters and memcg-lruvec counters for
zswap.

Patches 10 and 11 handle charge migrations for the two types of compressed
object migration in zsmalloc. Special care is taken for compressed
objects that span multiple nodes.

CHANGELOG V1 [4] --> V2
=======================
A lot has changed from v1 and v2, thanks to the generous suggestions
from reviewers.
- Harry Yoo's suggestion to make the objcgs array per-zspage instead of
  per-zpdesc simplified much of the code needed to handle boundary
  cases. By moving the array to be per-zspage, much of the index
  translation (from per-zspage to per-zpdesc) has been simplified. Note
  that this does make the reverse true (per-zpdesc to per-zspage is
  harder now), but the only case this really matters is during the
  charge migration case in patch 10. Thank you Harry!

- Yosry Ahmed's suggestion to make memcg awareness a per-zspool decision
  has simplified much of the #ifdef casing needed, which makes the code
  a lot easier to follow (and makes changes less invasive for zram).

- Yosry Ahmed's suggestion to parameterize the memcg stat indices as
  zs_pool parameter makes the awkward hardcoding of zswap stat indices
  in zsmalloc code more natural & leaves room for future consumers to
  follow. Thank you Yosry!

- Shakeel Butt's suggestion to turn the objcgs array from an unsigned
  long to an objcgs ** pointer made the code much cleaner. However,
  after moving the pointer from zpdesc to zspage, there is now no longer
  a need to tag the pointer. Thank you, Shakeel!

- v1 only handled the migration case for single compressed objects.
  Patch 10 in v2 is written to handle the migration case for zpdesc
  replacement.
  + Special-casing compressed objects living at the boundary are a tad
    bit harder with per-zspage objcgs. I felt that this difficulty was
    outweighed by the simplification in the "typical" write/free case,
    though. 

REVIEWERS NOTE
==============
Patches 10 and 11 are a bit hairy, since they have to deal with special
casing scenarios for objects that span pages. I originally implemented a
very simple approach which uses the existing zs_charge_objcg functions,
but later realized that these migration paths take spin locks and
therefore cannot accept obj_cgroup_charge going to sleep.

The workaround is less elegant, but gets the job done. Feedback on these
two commits would be greatly appreciated!

[1] https://lore.kernel.org/linux-mm/20250822190817.49287-1-sj@kernel.org/
[2] https://lore.kernel.org/linux-mm/20250402204416.3435994-1-nphamcs@gmail.com/#t3
[3] https://lore.kernel.org/linux-mm/20250829162212.208258-1-hannes@cmpxchg.org/
[4] https://lore.kernel.org/all/20260226192936.3190275-1-joshua.hahnjy@gmail.com/

Joshua Hahn (11):
  mm/zsmalloc: Rename zs_object_copy to zs_obj_copy
  mm/zsmalloc: Make all obj_idx unsigned ints
  mm/zsmalloc: Introduce conditional memcg awareness to zs_pool
  mm/zsmalloc: Introduce objcgs pointer in struct zspage
  mm/zsmalloc: Store obj_cgroup pointer in zspage
  mm/zsmalloc, zswap: Redirect zswap_entry->objcg to zspage
  mm/zsmalloc, zswap: Handle objcg charging and lifetime in zsmalloc
  mm/memcontrol: Track MEMCG_ZSWAPPED in bytes
  mm/vmstat, memcontrol: Track ZSWAP_B, ZSWAPPED_B per-memcg-lruvec
  mm/zsmalloc: Handle single object charge migration in migrate_zspage
  mm/zsmalloc: Handle charge migration in zpdesc substitution

 drivers/block/zram/zram_drv.c |  10 +-
 include/linux/memcontrol.h    |  20 +-
 include/linux/mmzone.h        |   2 +
 include/linux/zsmalloc.h      |   9 +-
 mm/memcontrol.c               |  75 ++-----
 mm/vmstat.c                   |   2 +
 mm/zsmalloc.c                 | 381 ++++++++++++++++++++++++++++++++--
 mm/zswap.c                    |  66 +++---
 8 files changed, 431 insertions(+), 134 deletions(-)

-- 
2.52.0


