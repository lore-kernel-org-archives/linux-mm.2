Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30190606A31A
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 07:32:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=ZevAmix7
Received: by kanga.kvack.org (Postfix)
	id 325386B02AA; Thu, 22 Oct 2026 03:32:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D6EB6B08BD; Thu, 22 Oct 2026 03:32:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1ECA16B08BE; Thu, 22 Oct 2026 03:32:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F2D0B6B02AA
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 03:32:10 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 02D7A8072F
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 07:32:08 +0000 (UTC)
X-FDA: 85349443578.01.660DFAA
Received: from mta1.migadu.com (out-152.mta1.migadu.com [95.215.58.152])
	by imf13.hostedemail.com (Postfix) with ESMTP id D19202000E
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 07:32:06 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZevAmix7;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.152 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792654327;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=sZMaNUkUgOAGCf7vIUHWRsuT7fViPMeanwtTwml4kjU=;
	b=jb3HR8R1VZZu/K38WuVFzjmasEycRTVtYra0P+R4NUj7mEWIgHH6g5DcYx86mTuqFZXVqd
	N8GcjxZ/J7BKVbDa//yHeS3RpOEqciu8E7JzslJDL1q4ebZ6JMAtcOqZF8GuPBYELRJZcs
	uqYD3WMJJVlm7pzaBh5y9PFGmUxYz1g=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZevAmix7;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.152 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792654327;
	b=idoA9jQlbuQeoRli8HWsVN45zErfhAy1Vs5+/R7vNQvOxJ9tGa15Xz1J5spVUeU1e4uD6f
	W/cbLxnc6mzjYCYh7enBCQlaowBMJ/r1u0SAWVroiBeMUBh4dSkK8fLfrjT6pDnuWOm5qQ
	HqgCZyDbOCswN419wMUleMhzoPq8Yzw=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=pydGOxS/qlsFc5FYzisLlwLazgT7vx7cmXT+dA4dW9s=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792654322; v=1; x=1793259122;
 b=ZevAmix70kRA6dGAO0+YnwcPa2Kdnji5mfDSGP8MXGTeCoko2+iFgNkSiwaDkeFNNjxYyOx9
 i0Ts51ebWQrhtaX26/5cFin9Uq3/qJpCdTsaX9/Vf/djQmmv7olhEtMgUJgIUAdLzgV1VfMXYkP
 4f80aT323M0F1lYa/dlRPSFE=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id cf7a53a0e25b2323;
	Thu, 22 Oct 2026 07:32:02 +0000
X-Mizu-Trace-ID: cf7a53a0e25b2323
X-Migadu-Flow: FLOW_OUT
From: Qi Zheng <qi.zheng@linux.dev>
To: muchun.song@linux.dev,
	david@kernel.org,
	osalvador@suse.de,
	akpm@linux-foundation.org,
	azpijr@gmail.com
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v2 0/5] mm: hugetlb: add CMA support for PMD-sized pages
Date: Thu, 22 Oct 2026 15:31:44 +0800
Message-ID: <cover.1792651104.git.zhengqi.arch@bytedance.com>
X-Mailer: git-send-email 2.48.1
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D19202000E
X-Stat-Signature: to9p1cjkc8nebio1c79yuaw11ss4sa8k
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792654326-885992
X-HE-Meta: U2FsdGVkX1+VU28v5pyHy0Hzdp3crX2hWQJPSzh+3hwCJQvvQP95vOneyBg93BUT87a3qYeBwdzL7yC/yWhpVBIBVUreoDrN8keQOQcHUyz/Gn0rw4h0AXDhIpg9AMT6YyMtBng34iEKRTaZbbo7YpUK4ukODgMX7fqYl4w5TsuVlzQF5YXgQyiX/bXpTIcr6w+yvuYgUsV7mDc8aLRdTT/gV7lyZ4nGkFBAkvmKuXAm05KZ2GNvZjZHCPWcCzZur9wi11pJFoTl7RhKWegd5DBkXfWscHxBCF6DmqHmb8/rx3LP3e6ui0eiRQYj/XVlhQX0fmT1UGjAPqYFHsGbKEsiureiKT6N/xO9GJLc2SmiWSQmq+/G8slFRSngeXH4ZI0qqEgtzhJL8JWF/82gluan4Vw0e4HLfQcSqhKNb+Jd1/ZqR4tRLaEG8i4zLIz9B3gNCmTnQWKDZPBUq38dJ10uGnSgBZD4BkMXcd3zxAXwd6HMb2cPPlsc28ww8y2FQQqdHGpTCjZV+zEcn8n2v0TERT97VgvBhe0pP+K80Pya6mqS+NGuf0WMdTVMb6y9vW0y6O/hnipWEmsAoxqjgS0ue9g1ZB9+MnBesx6DvMyajlsFnuFNQr6m4MLmg/W5Dx/XQ7KbZ/oa7cOcY0+j1OC9u0dVAVhjXuHuN5dGS2FJfnAh4x98lXUmlOlr4889LmejbE9JUlFj+8tD/yozkRLUY1yOUwGMPFwRZXhYY1WbyN5VgjSF0/KHlEM0irXLfn0suUvsg0yFjBEstm+sr8IXyY5ZjjZxyr5ULmASaPt39rTEu3/bLSvarLZvEhM56rl9OivAw9F4TTujQ9okfdczKToBURq3lV4ZsuKlVVhkDV+5ttlO/vfLPeeC4n7t+wc9pz7uMwANS72N0MkjxB4Cf9XKWUAcBTzvsdrcB33l7ohSDIK1gbBgbm/w7Rx2QI/vu4Ht6IbH5r6Pxyn
 cfXjXoWD
 PghSFS+96tg/EhWYzC4cZf/rb1n7+VkhBio0Q1ghioVExjP2xWB2DduZFrSjhf+5Q5DT0SPu6Q38juwvEru+r7fpvlij90XVSTvW/AZ/B6gdDOuAeb42/VXINhnfrSCvOt3QF2PEWdGKuPVYCzqrV51rd6eVzvfvt2hpJSundCrgJW5Z+ubDHG7diqTHtovpGwcISr7v+b22BvAwMidG3rcU0euY8Hmvo8wFcffD5djkE0+M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Qi Zheng <zhengqi.arch@bytedance.com>

Hi all,

Allocating PMD-sized HugeTLB pages at runtime can become slow or fail
as physical memory becomes fragmented. Reserving HugeTLB pages at boot
avoids this problem, but keeps unused pages unavailable to ordinary
allocations.

Live upgrades are one example: they need additional HugeTLB pages only
during the upgrade. HugeTLB already supports CMA for gigantic pages,
but allocating a 1 GiB page from CMA may require migrating movable pages
out of a large contiguous range. Pages that cannot be migrated can prevent
the allocation from succeeding.

Extend CMA support to PMD-sized pages so their backing memory can be
reserved at boot while remaining usable for movable allocations until
needed. This relaxes the reservation alignment requirement and reduces
the contiguous range required per allocation.

The series adds an optional @<page-size> suffix to hugetlb_cma and a
separate PMD-sized pool. For example, on x86-64:

        hugetlb_cma=4G hugetlb_cma=1G@2M

This reserves 4G for the default pool and 1G for the PMD-sized pool.
Unsuffixed parameters continue to configure the default pool. Other
gigantic sizes still share that pool, as do gigantic PMD sizes when
no separate PMD pool is reserved. The new size follows the architecture's
PMD size rather than being fixed at 2M.

Non-gigantic PMD allocations try buddy first and fall back to CMA.
Gigantic allocations retain CMA-first behavior at runtime. With
hugetlb_cma_only=1, sizes with a reserved CMA pool remain restricted to CMA.

The preparatory patches introduce two fixed pool slots and pass an
allow_cma flag through the common allocation helpers to prevent recursive
CMA allocation during migration and free HugeTLB folio replacement.

Changes in v2:
 - Replace the order-keyed CMA pool array with two fixed pools for the
   default and PMD sizes. (suggested by Jose A. Perez de Azpillaga)
 - Pass allow_cma through the common fresh HugeTLB allocation helpers,
   removing the separate helper that bypassed CMA.
   (suggested by Jose A. Perez de Azpillaga)
 - Try buddy allocation before CMA for non-gigantic PMD pages, while
   preserving CMA-only policy and CMA-first allocation for gigantic pages.
   (suggested by Jose A. Perez de Azpillaga)
 - Preserve default-pool access for gigantic PMD sizes when no separate
   PMD pool is reserved.
 - Collect Reviewed-by tags
 - Rebase onto next-20261020

v1: https://lore.kernel.org/all/cover.1792136742.git.zhengqi.arch@bytedance.com/

Thanks,
Qi

Qi Zheng (5):
  mm: hugetlb: add explicit page size to hugetlb_cma
  mm: hugetlb: group CMA pool and reservation state
  mm: hugetlb: track CMA reservations by pool
  mm: hugetlb: avoid recursive CMA allocation during migration
  mm: hugetlb: enable CMA allocation for PMD-sized pages

 .../admin-guide/kernel-parameters.txt         |  40 ++-
 include/linux/hugetlb.h                       |   4 +-
 mm/hugetlb.c                                  |  67 ++--
 mm/hugetlb_cma.c                              | 328 ++++++++++++------
 mm/hugetlb_cma.h                              |  11 +-
 mm/mempolicy.c                                |   2 +-
 mm/migrate.c                                  |   3 +-
 7 files changed, 288 insertions(+), 167 deletions(-)


base-commit: 8f7df005a7564bd7ffa75da9c3085d5b996f1e16
-- 
2.54.0


