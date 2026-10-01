Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 110DECA5FE1
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 23:02:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EDE536B008C; Thu,  1 Oct 2026 19:02:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E8FCB6B0092; Thu,  1 Oct 2026 19:02:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D7DBD6B0093; Thu,  1 Oct 2026 19:02:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AA5EA6B008C
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 19:02:27 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9E67F1C3492
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 23:02:25 +0000 (UTC)
X-FDA: 85275583050.07.1903D50
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com [209.85.215.197])
	by imf31.hostedemail.com (Postfix) with ESMTP id 08BAB20004
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 23:02:23 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=T5EbZN2K;
	spf=pass (imf31.hostedemail.com: domain of 3fua-agUKCKMSUDDQJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--praan.bounces.google.com designates 209.85.215.197 as permitted sender) smtp.mailfrom=3fua-agUKCKMSUDDQJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--praan.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790895744;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=7bxlv5ntBdZO0LQcKQEFlA8jL1mkcFGaYA5LZP7KTXI=;
	b=D0kMKs9kw5E66Hx4H2ehsuOajZI0xcyrJdXHWfCGw4bPvwjigrnTbJhfBgx6rgMM4xGyn3
	mMxObkGPclk3x5pxaXeqfBFUc4h9SJIFxxIjjFgzgOVSRXc1VtAGlSUFiGXEH5dGeg+jdv
	XB35fmxNK1gW69L3bjPygHJWlObmyZw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790895744;
	b=ZHXsPaa4buCUNdmpZDDCIYwf4wy5viC65GSnmt4Y7APRSjioLj9oSpOlvTbphm+75NaxpA
	0Bj0+Wf97vo9QnkqnXWCrbjLe8ZE5knzY38Gal/cPudnonz7bGSED5wVA/Xl2rxikIORZ/
	jxlz7FUX3H1zCG1llDb39v+AxgqhTwI=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=T5EbZN2K;
	spf=pass (imf31.hostedemail.com: domain of 3fua-agUKCKMSUDDQJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--praan.bounces.google.com designates 209.85.215.197 as permitted sender) smtp.mailfrom=3fua-agUKCKMSUDDQJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--praan.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-cc1ca15334cso7894634a12.1
        for <linux-mm@kvack.org>; Thu, 01 Oct 2026 16:02:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790895743; x=1791500543; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=7bxlv5ntBdZO0LQcKQEFlA8jL1mkcFGaYA5LZP7KTXI=;
        b=T5EbZN2K1Jp4OJFOPnGfzy/pdh8oxwD8sRpkQkXxbVsnrZwgKTiNc2zSEXCanzODfN
         KqzoeaxiExEo8Ha7wryMQb2zwBTj1HfCFsX9wi9xLdfMzX8m8Jr/9K7RaAbMCDIwMvwC
         OCnKTZHeNK28B23gicG41WyJFMuLEt/tbuo+JmkHoRxRLHNcyuz0gB2QJviMM8ihDwNx
         5+TFkIbbjNMVvW+QTxmu/dRqBJjKuL/F2p5+IGZj6y5CzKQ1AUD1f5zLjsT/kbPF3NKz
         rkwsz0dZvHJJik6yr9wH2Meki6dzv0v7LadAvKSCSctqRvQgOyTgL84UOoc0L8K9KVlx
         Bqnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790895743; x=1791500543;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7bxlv5ntBdZO0LQcKQEFlA8jL1mkcFGaYA5LZP7KTXI=;
        b=VPgOUV5gDM1dw4dcfnSUr+BHLR2e+qk7PcVcOnu9MgsMlOwGXXV9z6FiS/Z/ffF7rH
         qkFUXrsbeRIDab4uEtGgDFILXCeseBfC92v/M1H/F/FTRJwLzojFf4a3UTK9beVPjsSH
         JVXRPjiyl4eNnXCGMukXRzom3J8Og9dv0PoZoaTZRBm2IxKqZM/+OKEkfprtrM8e6rNV
         ntDphjz9IUcJmXrs9/3UM0WLAumKNbKboB+CWUD2xBPSGeR5EDv1K6NKFM06LGvvfvLt
         lzKSFxnCugFY5eL2sfmr9rL5UlUbcqGV7RtSeFX0xb4k9ljnWY2sFuMIxXyvyMhx5NzP
         2V6w==
X-Forwarded-Encrypted: i=1; AKwUvBw+qQt5Re5o/sjlzETjKgjWv/6Gj+N/Rh+g4gt9drWmMQPSkKzfo44+5qNFQV1jJXXPXDw9xdSEqQ==@kvack.org
X-Gm-Message-State: AFuF++nMJmerjhLtJtw9f6eqAa20fbchsw71icb3CQJO5QkMgXVMUBxx
	+xNBDom/npTISyIPtxWtk6ug4RS003+dkW0820chT7kdj6VtTHxYefvnNZXZaSRk60pU9IDrODU
	Juw==
X-Received: from pgqs2.prod.google.com ([2002:a65:6902:0:b0:cc7:58af:e212])
 (user=praan job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:4a97:b0:3c3:a3f4:5485
 with SMTP id adf61e73a8af0-3e0bc9f8cc2mr744551637.6.1790895742383; Thu, 01
 Oct 2026 16:02:22 -0700 (PDT)
Date: Thu,  1 Oct 2026 23:02:14 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20261001230219.818128-1-praan@google.com>
Subject: [RFC PATCH 0/5] iommupt: Introduce IO page table shrinker
From: Pranjal Shrivastava <praan@google.com>
To: Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>, 
	Robin Murphy <robin.murphy@arm.com>, Jason Gunthorpe <jgg@ziepe.ca>, Kevin Tian <kevin.tian@intel.com>
Cc: Mostafa Saleh <smostafa@google.com>, Daniel Mentz <danielmentz@google.com>, 
	Samiullah Khawaja <skhawaja@google.com>, Logan Odell <loganodell@google.com>, iommu@lists.linux.dev, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Pranjal Shrivastava <praan@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 08BAB20004
X-Stat-Signature: y4csbhnk6j1871dhw7h5dozj5ecffwar
X-Rspam-User: 
X-HE-Tag: 1790895743-563373
X-HE-Meta: U2FsdGVkX1/Zvza+7zT3KHDq7GNj/jZS5bvrZnzmGZhbTX5veB9L9O3gcmUUyjISfgSR1K4OwzLKJ2MBBplEJYsw61O9Z75FFQ5v/J3k8S8YC0Y92QYnQTL95G3sewOLcifyxS5zpAYwXT/nUD7HeCVnyLCQ2192B5f2UnQZey6s5T8weFyb3Ko0YCk0OfDwW7QuOFhmwRE8Lr4IZ8dT/T4FJ+qkByU9AOUIPiXN0J7tmLzB6eeusdXomQmaSU86/+fmIuDRkUDXK6gLR3iU4YdfuUGqcD2+s6xSoR4nWDA8YHeDnX0se1N0rU7PNUtgg77JwvQEU6QUhiSoPGb7tsyRIJLS/gTDvst1IUEtLHrgDT26HBHWCJQYA+NMYXvQYZoxo1xKZhnPQKuSGixWycwrVOEbfhXAk/zpF/QWt72qcaYC5bWNwaE/bdfBa8/z2eR8oBMhxnU2uT1EbcZTPo9/zeddcISRdHl1XGv1y+MaVpwd6ghFBTdZliMRAg+1q5Pe1/vxy0seW5v0OXEfj0jPCanjz5zrNi7cj/4LdrvwXjOC4ybVCx92x2lEEOFMv/kidqpCN95ZdkjGJ2ReFeXkLNDX2zQHy3WSJYRZSE4GWMJ2RPmYAsrpfn+q4NUhLvdkc+COXPLRmG38NhdYJgv1bcPfNSv9gCfK6UTHVTZGyRVWiDL1sO2SztjWPj5GjrGJ3TeeZIV+aEJDz0rTzKG9LCPgv9ld/xKzYWKC5uQxiRuyI/c3uvBaN7ilbXG01rr+KY6yYKUoQjeZCzIfBxz23n+1thpY1O0OG2jYBQiemXw8h31CBFGs4BgvDwy4OT2ajYQxpEN/MAMn1j2o0/OLPP3/6ct2xtZCMCvXyyyE0jpcGc0tRgAIDueTImqUiVk7RXCbAHxSohR5m2xcT7y7wdHHG2NYxb18hE5v8yVA5RSvn5WcebOHsEPdfxtF6IUfWXT++hgy4uotRaF
 CInLHlBi
 X0WCP6uM7+6H9t1gfC64JwLmzguCwDkZog6WXQGrX6c4z6Yqdnu98Gq/lWHYav16sGjoieSTikAnoPfMpPNRhs3ySV3NZUqeg6cqwW6a0RSZeOek8OcVVUYIxMUdOE90JejEblKV+akJsL3fPv4YHQGS67mdpFIE+mH2Iqr8ovCjcEyR0+alteFMIu8Vf3FrzkmY0iDRYnW7qDzleVHY1aijnGRWa+Ao9rPB+h/sYWvw5ZJcnsXyqVBeGDRUq92GFuEzzPkhSvdJOfzasIkkSqA/+/6e85aOmrxqcVevBBBYZemLKdoWxO/EKF0Q7ZfTvAfQgXyOHq8R47axhIsUut7YU8kbhI6Zfqnfg9vFF0Wx7uOR+cSpAdw/xX/77KPSsqSnPffw9VZqOI6JCpHSJ2QcYwt0ozRuBhJALaMYl8utRmhtTEulI65qWjgSNmJO+jqrO3Csp780u3XKice4Voxse1aNt483OtHt3IrNt0cn9YQzf0Z6v3n//Q2okgg5rBB638t4t+LPubOBAafHdh5Ydrcc0hj9YguDctF4Dk5Fvff+HZXPD3a8SWZ1xeEFV9yi8iWVP82Dv1M91sNQ1qkzNjpKZ/GsQ9CUvajeM36r7QFUN3IzEOMgCj2o0uEzdLPNAW4ZEr211kv5iwExqaQFqciMkMHIvK9Hw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce a lockless, deferred reclamation framework for IOMMU page tables
built on the generic_pt library. As VMMs and userspace drivers map and
unmap large, sparse IOVA regions through VFIO and iommufd, page table
directories are often left allocated but completely empty. generic_pt
frees a table when a single unmap covers it entirely, but tables that
empty through a series of partial unmaps stay allocated until the domain
is destroyed. Under memory pressure, this *stranded* memory cannot be
reclaimed and has resulted in OOMs.

This series refcounts leaf directories natively in struct ioptdesc and
registers a domain-aware MM shrinker that prunes empty directories under
system memory pressure.

This is an RFC to align on the design. It has known issues, listed below,
and is not intended for merging as-is.

Design
======
 - Refcounting: the __page_refcount of a leaf directory's struct ioptdesc
   counts its valid leaf entries, plus one for the table itself. Map takes
   a reference with atomic_inc_not_zero() before installing a leaf, and
   unmap drops it after clearing one. Leaf entries are counted only in the
   table that holds them, so map and unmap never update refcounts on the
   shared tables above it.
 - Queueing: when the refcount drops to 1, the directory is empty and is
   logged with its IOVA into a per-domain xarray (reclaim_list). Only
   non-DMA domains are queued.
 - Claim: under memory pressure, the shrinker walks the queued directories
   and claims each with atomic_cmpxchg(refcount, 1, 0). A map that finds
   the refcount at 0 fails atomic_inc_not_zero() and retries, so it never
   reuses a claimed directory.
 - Sever: a format-agnostic top-down walk (sever_branch) clears the parent
   slot with cmpxchg, severing the dead branch from the live tree.
 - Free: the domain's IOTLB is flushed so the IOMMU drops any cached
   pointers to the severed tables. A single synchronize_srcu() then waits
   for in-flight map walkers before the pages are freed.

The cost is one atomic operation per leaf entry on map and unmap, plus an
xarray insert when a directory becomes empty.

Known issues
============
These are understood and will be addressed in the next version:

 - Map vs. shrinker retry: on a claimed directory, map returns -EAGAIN,
   which __map_range() already uses to re-descend into the cached table
   pointer, i.e. the dead directory. It needs a distinct error and a retry
   from the top.
 - Unmap vs. shrinker hand-off: an unmap that fully covers a queued
   directory, or a large-page map over an empty range, frees it directly
   while the xarray still references it.
 - xarray keys: the key is the IOVA where the emptying unmap started, so a
   directory can be queued under several keys and nr_reclaimable
   over-counts. Keying by the table's PFN makes entries unique.
 - A failed sever leaves the refcount at 0 instead of restoring it to 1.
   The top-level table, which has no parent, should never be queued.
 - iommufd allocates paging domains without iommu_domain_init(), so their
   reclaim_list is not initialised.
 - Combined with the observability series, pages must be uncharged from
   their domain at sever time, as they are freed after the domain may be
   gone.

Open questions
==============
 - Leaf directories with child tables: a leaf directory above the last
   level (e.g. one holding a 2M leaf) can gain a child table, which is not
   counted, and could then be reclaimed while the child is live. Should
   child tables be counted at install, or counting be restricted to
   last-level directories?
 - SRCU in reclaim context: the shrinker can run from direct reclaim
   inside a map's SRCU read section, where synchronize_srcu() would wait on
   itself. Should the free be deferred (work item / call_srcu), or is a
   different scheme preferred?
 - IOTLB flush granularity: flush_iotlb_all() is used after severing.
   Would a range-based paging-structure flush be preferred?
 - DMA-API domains are excluded since their unmap can run in IRQ context.
   Should the per-leaf atomics also be skipped for them?

Upcoming Work / Roadmap
=======================
An IO page table observability series, which attributes page table memory
to its domain and exposes it via fdinfo, is posted separately as an RFC.
The two series are independent; this one applies on v7.3-rc5 by itself.

There's an alignment session at Linux Plumbers Conference 2026 for these [1].

[1] https://lpc.events/event/20/contributions/2624/

Pranjal Shrivastava (5):
  iommu: Add reclaim_list xarray to struct iommu_domain
  iommupt: Implement refcounting logic for Leaf entries
  iommupt: Add lockless sever_branch helper
  iommupt: Introduce lockless page table shrinker
  iommupt: Return real page count to the shrinker core

 drivers/iommu/Makefile              |   2 +-
 drivers/iommu/generic_pt/iommu_pt.h |  81 ++++++++++++++++-
 drivers/iommu/generic_pt/shrinker.c | 135 ++++++++++++++++++++++++++++
 drivers/iommu/iommu.c               |   2 +
 include/linux/generic_pt/iommu.h    |  29 ++++++
 include/linux/iommu.h               |   3 +
 6 files changed, 249 insertions(+), 3 deletions(-)
 create mode 100644 drivers/iommu/generic_pt/shrinker.c


base-commit: 72d3fcf802c45d00b300f25b848a93c3a2bd7c7e
-- 
2.56.0.rc1.315.gc6ed9934b7-goog


