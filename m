Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55E18CCF2D4
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 09:47:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B72BD6B0151; Mon, 19 Jan 2026 04:47:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B49BB6B0153; Mon, 19 Jan 2026 04:47:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A4CA06B0154; Mon, 19 Jan 2026 04:47:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 935246B0151
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 04:47:39 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 33E961406DA
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 09:47:39 +0000 (UTC)
X-FDA: 84348236238.01.87B8C3C
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	by imf07.hostedemail.com (Postfix) with ESMTP id 3E1B440003
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 09:47:36 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Il7vDESU;
	spf=pass (imf07.hostedemail.com: domain of zhiguo.zhou@intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=zhiguo.zhou@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768816057; a=rsa-sha256;
	cv=none;
	b=oBNygJb+BUdTq8+PEsl4o/Oc1RrWScjxBOni7lR7BVDyphriUCP+RTnEHjaNF2zg/25Ewg
	EiK4NzjJP4w6QJ9CICbcVw+7iiC7BhMVVTeCTzw2otzjs0V1mUPgJBmrPhyo9Jwdo+OGsM
	UxtXVlDcKBFSSnr0gHXAJOZecpb7KkA=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Il7vDESU;
	spf=pass (imf07.hostedemail.com: domain of zhiguo.zhou@intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=zhiguo.zhou@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768816057;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R2QSvIEZ6dg0tqlorFrwUGflQc1Nu6QpvcnvZBz8gwc=;
	b=TLvHs5MkJaaBfjCCc0sHI4JVDgH2qVq0/QdWW5PtyHAHsRX4eJAEF+MdmcI8mpzjLT38M7
	yZcDtYmjoAoVy7VCERfZEZkePrcCnvKaC5LjGZ91xOmWqJ/dvXndpaY6GtskRRP2u1f3l/
	F9nu73nfnULZInDqPrYQGSKi7ljiwcs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768816056; x=1800352056;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=QbCHdqfLV2tvIBj/6ow9t/3s/bZUZIKilVJAAbBiIbI=;
  b=Il7vDESU0w4YxhxWTi0VPE+5t0qLNQjrrj++ZL5CcGN56PWvYPKow1Tf
   o2aeDiMJCD+CwtXfg1O5VMDhX73xGK9zLEI+mcJ8z5BYdF1T5C7+rn9IT
   J6J7+BRTw7LFbMOE+tYWPqB3ux4p63Vc8Te3ax2wdt6M/avtHkoK9ZLNF
   5p8Ronnu+3K9CUIvkdAL94LGto0qQiqTkauw17YaXdkruK7sqp0DkTMq3
   Zdm8i34Ib4EcoE/DtJiN7f65ZTSXuL13d2Ztz5xrX8JIW9x4VyaR7bW1Q
   umR4dedT2Mt+xBIqeaSTdhMgvFa6ID6dADNY4kC2EpkRt9nxqZX6qs5Hy
   Q==;
X-CSE-ConnectionGUID: r3sGzoDmQoydCz+vNoQ8NQ==
X-CSE-MsgGUID: EYqnoUoKRqCKOQyRxgll+w==
X-IronPort-AV: E=McAfee;i="6800,10657,11675"; a="70072765"
X-IronPort-AV: E=Sophos;i="6.21,237,1763452800"; 
   d="scan'208";a="70072765"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2026 01:47:35 -0800
X-CSE-ConnectionGUID: udMNvmChTgK/O6cOrLk3fg==
X-CSE-MsgGUID: OwYa3RcmQg+vQDP5kj86ZA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,237,1763452800"; 
   d="scan'208";a="204971967"
Received: from linux-pnp-server-15.sh.intel.com ([10.239.177.153])
  by orviesa006.jf.intel.com with ESMTP; 19 Jan 2026 01:47:31 -0800
From: Zhiguo Zhou <zhiguo.zhou@intel.com>
To: zhiguo.zhou@intel.com
Cc: Liam.Howlett@oracle.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	gang.deng@intel.com,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com,
	mhocko@suse.com,
	muchun.song@linux.dev,
	osalvador@suse.de,
	rppt@kernel.org,
	surenb@google.com,
	tianyou.li@intel.com,
	tim.c.chen@linux.intel.com,
	vbabka@suse.cz,
	willy@infradead.org
Subject: [PATCH v2 0/2] mm/readahead: batch folio insertion to improve performance
Date: Mon, 19 Jan 2026 18:02:57 +0800
Message-ID: <20260119100301.922922-1-zhiguo.zhou@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260119065027.918085-1-zhiguo.zhou@intel.com>
References: <20260119065027.918085-1-zhiguo.zhou@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 3E1B440003
X-Stat-Signature: 73grew7mqw6mjax9gwyxhaun6gz9cgyg
X-Rspam-User: 
X-HE-Tag: 1768816056-385934
X-HE-Meta: U2FsdGVkX1/5kT6kSyuxehexQxmZAy6ht+H9cO+qHAOYbJoZIrqBhK7PznCBjbMHT77iHLYm5jFxWFx5fpxuthGHqjXBYPOwuoFzavJfKnYYSSwB8iDM8RriOoukZCA9j+9e2v5mfEOUzg/vNKvijzXaXHa4tsDTfn5okd8J6DZZjF+rhUoZ9Nn8p2O/WqXaRNm9PaT8hr0mqBNPU2qy8zBdNsg5UL6sgqLftapiQ59smjgVqUaD+r2U1AtifZTrakrRBCRZEcAUhJi5uElHAPjI47dqrucguuCtyZA4cwTWv9Oy+6gq69ym8lrQSAVZ5cogabdg62bMGc3m9uOxVIDCtnq92uDC4CLD4XExbM+lvnR2vihAZHsUBKYTjzA+FkmhY3V2IKyBhJ/MJQLel7Su9chfk2bsdhbyWXvjlX7Hr8/ftg4Zn9JRNdTj2R5yKles9NHNgnX9D6fsBAoz0hclTibzTa6NfSmkIQilh1fHOdFy+XrH9nEEGzRk0gpVI22V2QXFMVW11kFLnNjmIJT/YU1/6FcK2B7AxpA/rBcTXQ8k2vc7f6okLmqofD6manczV3oS4PVjbVkX3e6TraempZCWo4FPcUucohmtvnkVtkHsigNjbBgHZQxMwWuBjPPtHF2RcNQtNT+yQUhXcRoDgay6c7PUh0qN6zWn+E4pLS0CrlQFUbTibKJOenlox84S7DPE+r9/54/g/JR90dn3rhPS5BMQ91Cz7wMHHMdh/8vvhii8wn3BbnMoGzYw9+t5MGwVI/4A9/mFdFfNMJkFaPI6hvlFHP2i3vV73/Gex3adi+RHdIhyn04v7LQCMBPgu12h9RSKT9w5swJwkQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch series improves readahead performance by batching folio
insertions into the page cache's xarray, reducing the cacheline transfers,
and optimizing the execution efficiency in the critical section.

PROBLEM
=======
When the `readahead` syscall is invoked, `page_cache_ra_unbounded`
currently inserts folios into the page cache individually. Each insertion
requires acquiring and releasing the `xa_lock`, which can lead to:
1. Significant lock contention when running on multi-core systems
2. Cross-core cacheline transfers for the lock and associated data
3. Increased execution time due to frequent lock operations

These overheads become particularly noticeable in high-throughput storage
workloads where readahead is frequently used.

SOLUTION
========
This series introduces batched folio insertion for contiguous ranges in
the page cache. The key changes are:

Patch 1/2: Refactor __filemap_add_folio to separate critical section
- Extract the core xarray insertion logic into
  __filemap_add_folio_xa_locked()
- Allow callers to control locking granularity via a 'xa_locked' parameter
- Maintain existing functionality while preparing for batch insertion

Patch 2/2: Batch folio insertion in page_cache_ra_unbounded
- Introduce filemap_add_folio_range() for batch insertion of folios
- Pre-allocate folios before entering the critical section
- Insert multiple folios while holding the xa_lock only once
- Update page_cache_ra_unbounded to use the new batching interface
- Insert folios individually when memory is under pressure

PERFORMANCE RESULTS
===================
Testing was performed using RocksDB's `db_bench` (readseq workload) on a
32-vCPU Intel Ice Lake server with 256GB memory:

1. Throughput improved by 1.51x (ops/sec)
2. Latency:
   - P50: 63.9% reduction (6.15 usec → 2.22 usec)
   - P75: 42.1% reduction (13.38 usec → 7.75 usec)
   - P99: 31.4% reduction (507.95 usec → 348.54 usec)
3. IPC of page_cache_ra_unbounded (excluding lock overhead) improved by
   2.18x

TESTING DETAILS
===============
- Kernel: v6.19-rc5 (0f61b1, tip of mm.git:mm-stable on Jan 14, 2026)
- Hardware: Intel Ice Lake server, 32 vCPUs, 256GB RAM
- Workload: RocksDB db_bench readseq
- Command: ./db_bench --benchmarks=readseq,stats --use_existing_db=1
           --num_multi_db=32 --threads=32 --num=1600000 --value_size=8192
           --cache_size=16GB

IMPLEMENTATION NOTES
====================
- The existing single-folio insertion API remains unchanged for
  compatibility
- Hugetlb folio handling is preserved through the refactoring
- Error injection (BPF) support is maintained for __filemap_add_folio

Zhiguo Zhou (2):
  mm/filemap: refactor __filemap_add_folio to separate critical section
  mm/readahead: batch folio insertion to improve performance

 include/linux/pagemap.h |   4 +-
 mm/filemap.c            | 238 ++++++++++++++++++++++++++++------------
 mm/hugetlb.c            |   3 +-
 mm/readahead.c          | 196 ++++++++++++++++++++++++++-------
 4 files changed, 325 insertions(+), 116 deletions(-)

-- 
2.43.0


