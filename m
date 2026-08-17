Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 951AEC5DF66
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 14:46:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C1716B081B; Mon, 17 Aug 2026 10:46:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 772876B081C; Mon, 17 Aug 2026 10:46:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 661756B0820; Mon, 17 Aug 2026 10:46:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 403286B081B
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 10:46:35 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AE53E16075B
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 14:46:34 +0000 (UTC)
X-FDA: 85111037508.10.03F5531
Received: from relay4-d.mail.gandi.net (relay4-d.mail.gandi.net [217.70.183.196])
	by imf25.hostedemail.com (Postfix) with ESMTP id A7507A0006
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 14:46:32 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	spf=pass (imf25.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.196 as permitted sender) smtp.mailfrom=alex@ghiti.fr
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786977993;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=vuAgeslHmAUaE9dQyFBvwVRPv0diIVkjPobZLGUqLS8=;
	b=tXy7VpHI32YtbsLTLwr1OdZUiOjMyvzJTEaqHYaldajGi0sR7moxlcWztJ8WJmKqhc70vL
	Mjmu1L8f3AYhPnGqxo1r/UvYg6DRtoKBqLuCqEhBKT+v2+fPuAUxX6TeNLUU8GqcbvvBxJ
	4eXlAjErJKHobrNxx+0/wrN2h8keMbs=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.196 as permitted sender) smtp.mailfrom=alex@ghiti.fr
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786977993;
	b=N2C0JUDK6Lr5eEjmMSoOr8EU14UAVFyVCzQQkzuG9SVJJpRfvm6tqqLIZ1U4OL+Mxi8+DS
	yID27yKDGdIGr1Ke6DZs8Kxu1P6dPN+vZ6+7l04gD2rN7lXsWLpWfx2pO5F2J/mbq/Vp2Z
	0BfEDWZu8B5/Dn+WEO2+xAugh1Fw1Z4=
Received: by mail.gandi.net (Postfix) with ESMTPSA id A89FD3EE10;
	Mon, 17 Aug 2026 14:46:24 +0000 (UTC)
From: Alexandre Ghiti <alex@ghiti.fr>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Alexandre Ghiti <alex@ghiti.fr>
Subject: [PATCH v1 0/2] mm: fix workingset refaults in the zswap writeback path
Date: Mon, 17 Aug 2026 16:46:11 +0200
Message-ID: <20260817144622.137133-1-alex@ghiti.fr>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-GND-Sasl: alex@ghiti.fr
X-GND-Cause: dmFkZTGUjkeGzsymjV3NjkiiE3tVH6yv4EmJTZUyCCmq6voginkV45d6QzS1PO9nmnrMCLepVqKoGpu4NphUdUpbju7Gdse2UXFdCN07mZpbTC+JOV3g91bAbjCgNqAbDDBxHNuPoOGpS72jeHejH/IQ4SSlJkc3E17i/NuMBekpkH6iX9agIh3DSZ+QzXkvXMqv1Obc64t8p27zNjztti4wckY7AHibflERfD8y8pUYkkLb8vZwJmLPvyp4cKycUeblGlmbwlaHWAXH6CuS6yrLZESsLtVX0PgRNIB3q8Tuab9sZMpdjaLxDuNWBf8IoFqN3BHhW29dv7ilJfJVbNHvkIRNGc7BZI2bn5oIv4TgZ80kPY8in24caXAf7rFecAdZH5HgNZwEgSwsaJBIuOHtRqyVJluzN+JaduXJe8AYL+KWVfRcNebtfXRt23rGc+0t1CkTgb4sTB26YH8DDEf28J0Kuunl66JtlrkPpvZ0Y69Ay6zJeQ563l2F1Zr3LyhSPm8MHAltNoWG9HwikVRQYp6hgr5xZmUK7BG3Gfjk5F7o5THmF50WDIzHm7D6nV5yPPb8APN2re/MgeHCXMpcMMuMDS/NKcWx7eqI8gBVmqb5vCQwDIvEv4UCdWP40rWrWyf8TWwH43/XF2ocHrkrbM7frNWN64JrBii7tIfSp1ZwHQ
X-GND-State: clean
X-GND-Score: -100
X-Rspam-User: 
X-Rspamd-Queue-Id: A7507A0006
X-Rspamd-Server: rspam07
X-Stat-Signature: recrzs34drtxpcmo6ak445p5i88u3g9s
X-HE-Tag: 1786977992-665953
X-HE-Meta: U2FsdGVkX1/xy+0s4zndfxdDs+bpZP0fjuuM/TiQDDbTmQKxYUTCiS0VmuJplOgy63Sa9K364PIzldvgMp4MTyq3QkZ9SXeQKqKU8S/QdB2kHbA2DqcehFFvCCFOP48b8UUfORAidlexXH5tYpvNx2WKNyABVuK9WeyAZB7jKsgcOl57ODONo3XK1Q/RGEg9/BmgQ9MyGptFPCzOMijUukAk6qudMHETSaIG6HyPy0tPEjZBYnG8L4d2ZlC/Mv9rM7SYNlKMpOjK8wf9x2e+O/M0jksqCpZiiaV1JDxKZhq6oje8SdBMK9FlIw7dIf9Vf/1ocNBOpH/RDxERa2T2zQret9v4mDOZu6qgLp3I/CrzZkCDPc+5UEremqTML3R8s/1cFHTFbV4+WPoGHFwQryKLpgkUyCiYqyeAHpeaKmX5fhl5nAc7ACpRd4acwxqIuuwBm4xLtUmNJKQyydHISnR6aLZ6MahX05G7HQKh0cGJ5qtFGx/34tHyXlS8p2w4LT4k5zMf4f0Ze8fsyg+ALxY+xZUTmrzEjLyntEiLga+sva/FnCr4U0dq8mkWHLw9E6yGz5daRDR+T/PrxPAheysUUEzJsixLu/1Tfa8kVzs9aOVFLOp/MVkmsBwMmdzn2zfedC5E9ka7zS+oBTFxJkGUouM7sbvjy8zSOX8wJV/RxT5i3bfF7CaXKDWCLpVfEiA+R075P/PxvKm+yEyM+rAjlYCtKC/2G8MUPAUV6HwodrYr09un6zzSBU+ZfJRCqHWFnIxdWGc4GMTL9r0tdKGyGEe5PzV/awRz4JTcb0stFxguH3Hvr+5/GnIeY+hv+XiFoxFjeWnTv/g7/wrWCElzZuYa0m2xthFDtpTeTvb3W6YHT3nx2jFg+t5TXbj0Gc0suJ8M+wwH08t+N6MnZtlaJGbFKFow8ZiFoJk1ws3h9GUnJVPzc0CU3MA+z2usV5JCf5Clq56cA7UD0kO
 Jz3E2aXo
 O6kJs
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When an anonymous folio is reclaimed, workingset_eviction() stores a
"shadow" (the eviction cookie) in the swap slot so that a later swap-in
can be recognised as a refault and, if the refault distance is short
enough, the page can be re-activated. This is how anon workingset/refault
detection has worked since commit aae466b0052e ("mm/swap: implement
workingset detection for anonymous LRU").

zswap writeback breaks this in two independent ways:

  - Over-count at writeback: the shrinker allocates a buffer folio in the
    swap cache, and the allocation path counts that folio as a refault.

  - Lost eviction cookie at reclaim: adding the buffer to the swap cache
    overwrites the slot's shadow, so the original cookie is lost; when the
    buffer folio is finally reclaimed a fresh, inaccurate cookie is minted
    in its place.

This series preserves the shadow within zswap itself, without any new
swap-table or swap-slot state. At writeback, instead of erasing the freed
zswap entry, the captured shadow is parked in the zswap tree in its place,
so it outlives the writeback buffer folio.

Finally, the refault evaluation is moved out of the swap-cache allocator
into the swap-in callers, so allocating the writeback buffer is no longer
miscounted as a refault.

Results
-------

Measured with a sysbench OLTP (MariaDB) workload in a memory cgroup sized
so the dataset and InnoDB buffer pool both overcommit it, with the zswap
shrinker on so entries are continuously written back to an NVMe swap
device (classic LRU; MGLRU off). Anon workingset counters over the
measured window, baseline vs this series, mean +/- stddev over 10 runs:

  workingset_refault_anon    383,242 +/- 59,345  ->  199,355 +/- 27,042   -48%
  workingset_activate_anon    54,890 +/- 11,742  ->   22,607 +/-  3,118   -59%
  workingset_restore_anon     16,212 +/-  4,590  ->    7,599 +/-  1,190   -53%

Writeback volume is comparable (zswpwb 183k +/- 16k -> 178k +/- 15k), so
the reduction is not from doing less work. Normalised per transaction the
reduction holds (-53%/-49%/-39%) while the swap work per transaction is
unchanged. A kernel build under the same pressure moves all three
counters in the same direction.

The run-to-run variance of these counters drops as well.

Throughput is unaffected: over the same 10 runs, transactions/s is
18.50 +/- 1.08 -> 18.65 +/- 0.94, i.e. +0.8% with a 95% confidence
interval of +/- 7.7%.

Alexandre Ghiti (2):
  mm/swap: refault on swap-in, not in the swap cache allocator
  mm/zswap: preserve the workingset shadow across writeback

 include/linux/zswap.h | 12 +++++++
 mm/memory.c           |  5 +++
 mm/shmem.c            |  5 +++
 mm/swap_state.c       | 30 ++++++++++++++--
 mm/vmscan.c           |  4 ++-
 mm/workingset.c       |  5 ++-
 mm/zswap.c            | 80 ++++++++++++++++++++++++++++++++++++++++++-
 7 files changed, 136 insertions(+), 5 deletions(-)


base-commit: 626acb37cd445144f321f1b64cac9a93760fa716
-- 
2.53.0-Meta


