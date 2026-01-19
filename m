Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 984BFCA5FEE
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 06:35:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC65B6B0114; Mon, 19 Jan 2026 01:35:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D9E0F6B0115; Mon, 19 Jan 2026 01:35:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC7216B0116; Mon, 19 Jan 2026 01:35:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B6BEF6B0114
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 01:35:03 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 623D48C27D
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 06:35:03 +0000 (UTC)
X-FDA: 84347750886.01.9B69964
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	by imf21.hostedemail.com (Postfix) with ESMTP id C3F421C0007
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 06:35:00 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=JtGpH3Ms;
	spf=pass (imf21.hostedemail.com: domain of zhiguo.zhou@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=zhiguo.zhou@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768804501;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=R2QSvIEZ6dg0tqlorFrwUGflQc1Nu6QpvcnvZBz8gwc=;
	b=swj7wHTlXWIKOT/1SzDtsXdkXFXnmSdzAd096Ql7gKAugrn8U1OyjvSi+ET+9CAyZ8Thhi
	yPbPpiiAr1fTR0i71HKMjhuZgauAWfEyeVY2IAiIfstENVUblgpe6YvDhzRz5sRWEyrSJ4
	0+udkde9P5Q2tjQBBKULWS1myJK1Tcs=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=JtGpH3Ms;
	spf=pass (imf21.hostedemail.com: domain of zhiguo.zhou@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=zhiguo.zhou@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768804501; a=rsa-sha256;
	cv=none;
	b=Iupez0l7orem/JlUrxcrco0wsKoU/1nHX2thniKBq8bD7QBsIKmMnH0QIRN/meyb4EAo4F
	TvE5BSNcD021Oc7oLmBTLOA1oeBkBscvg3By1jAoqELH7jKXFSTyUa6tvmJdMWJCGOCMPl
	Ruv9++704cJ5dFJQLluwVPi/8W8/E4Q=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768804501; x=1800340501;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=QbCHdqfLV2tvIBj/6ow9t/3s/bZUZIKilVJAAbBiIbI=;
  b=JtGpH3MsVrV+SMNoQHE+WHoJT2/DPVQuC/bx99+EbxWxcEpDtDCXzqRf
   fNP1NHLMYgkZX6xyBoqPp63K5VYQD7b/COtUiy2CV13oDKsqp+3H+Pnrm
   D05Vr9t91ewIy93htoFYGpRNEmKkKORBpx7dM9FI6cFLa4zXVy1qLvtqQ
   9Ay8+vj5Z19HA4jgnkVPohqOlaTzfN5UHAsbbYLfl4wu+9DW2sMMK8YkN
   rb6nsFS8IFkqmvul0N8AIjp3W/HOyiId8g8SSkoHaw0IV9eXonJF+XtPh
   6BX1z43DQiUt+TRrINd0eg9va/ct77EBy+2X0ollz7o1QZDEJq1JvvZU9
   Q==;
X-CSE-ConnectionGUID: JPkJOcutR6KuOuG57TbpZw==
X-CSE-MsgGUID: 1hlPw5VmQsWa9+PymWA4VA==
X-IronPort-AV: E=McAfee;i="6800,10657,11675"; a="57565273"
X-IronPort-AV: E=Sophos;i="6.21,237,1763452800"; 
   d="scan'208";a="57565273"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2026 22:34:59 -0800
X-CSE-ConnectionGUID: 0bVwmciUSAmUnZHQAnEeKA==
X-CSE-MsgGUID: 3fhQ+SwdTeuNErHLrsRYEQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,237,1763452800"; 
   d="scan'208";a="205824245"
Received: from linux-pnp-server-15.sh.intel.com ([10.239.177.153])
  by orviesa007.jf.intel.com with ESMTP; 18 Jan 2026 22:34:54 -0800
From: Zhiguo Zhou <zhiguo.zhou@intel.com>
To: linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org
Cc: willy@infradead.org,
	akpm@linux-foundation.org,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	muchun.song@linux.dev,
	osalvador@suse.de,
	linux-kernel@vger.kernel.org,
	tianyou.li@intel.com,
	tim.c.chen@linux.intel.com,
	gang.deng@intel.com,
	Zhiguo Zhou <zhiguo.zhou@intel.com>
Subject: [PATCH 0/2] mm/readahead: batch folio insertion to improve performance
Date: Mon, 19 Jan 2026 14:50:23 +0800
Message-ID: <20260119065027.918085-1-zhiguo.zhou@intel.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: hw6foxq1gjqcp57n8747ehzs4smr1j8u
X-Rspamd-Queue-Id: C3F421C0007
X-Rspamd-Server: rspam04
X-HE-Tag: 1768804500-965121
X-HE-Meta: U2FsdGVkX1/CNA1wsru2arrnHORnz/Egn9bbOdTIykVZ2yzmC3GePRrTVFwGRl/fcrDPSGYtjOSw56mwAswRtoxGHEkaelHhBAXtRC9iFNIK7mhA5WVNMD3AcXoOt9wgMHi+bIHRO4cGP/0wg+q7ODMfZCGjml0W8Pzyxj9E+LM2HJxhTrvm0XTFFdAUd6TrQqw43pimlO98x69R45kGIIBQ9cbPtdhjYl6GGwjlqDqBi6IPsAS5eZwRccxRM0zFoRDbnOBDtqZhAdwiD8ftmLwiwCkdzOdpFGgUZlnBsMbrjIdWMKDftHAJzoLA81jtvrMurv2c7jaga/C4wMKPlArak5f/sFkg7z1AMO2YdTZMs3Hrcdz0qdY6zQ2kW4qV+QD1Pn62rBpXtQBS9TkSYaXqCyvYwHn496HryX/XU42qIDHPup7Gg/iMl2Dp9nRcRyWq2jRWN9o602Psj70YBDXDUisYfLa1hRMc4IgRyk4ukXrre7VE40IUJKIAOZI2bqIMYA3MEgACzk1TSTFogAW+fOVvH5UPKC1pPWy3g/BS/ES4DWCQzhKYrH6U9ncBTANy0yewAjiE/NzO8jpOJNj+0Bn5x7hxezT+rwvF7FTh4zPGq2jKOHyMYWKC9qKVSgrvy/9iqDq2DiXmslPYE9PLVZgPtXcmXzWjTK3NSU19A1b3YR2CPSqtc6sX6d73qtstr48pIYZohd+1HqZZFZBSoUe2W08qZPMprZ/FRYZ9OLjGi3Vm95cZRCyhsTSyLE2pV+dZL6jE8M9uP5/x1724Z593ozpfSjw6xccV/3IIpNd+ADIKyHh5RjXgYSjU9IaOa8NG5rM9Gm+Pi83odYwDXBeQob8qP/Yf8QoabFCkKq7DC/L5L/Zn/LqqswxORiGnoHjcFXlusXEGxXeHdRNbfohaAWqyR3vPtlEBA2sflXOAC63oJKHgSEs5NUeTLrrkKfOO8oaQM+snI8P
 8iABs4SX
 SQe2OSQS+LPj8SYkuNLgwVyz7U7ImFlRidubGTPYGnc/K6XN+G+E15BGNsJM8zvoF7Fx9KiPd/5htf5KNupHXehwC/kWUy2z+AxAJMzZkWtAyb66Ur+UQSCGu5LQ2KzLQKq7OcDxSJCYo5Ji+yufYXiA1cdScGv5ziT/zScwsXMZ65QEnmVaX9zixq5uwrFYhd3Ap
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


