Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3DC46F4385A
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 16:47:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5AB9B6B0089; Wed, 15 Apr 2026 12:47:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55C106B008C; Wed, 15 Apr 2026 12:47:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 498C96B0092; Wed, 15 Apr 2026 12:47:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3A29D6B0089
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 12:47:33 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A2050160578
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 16:47:32 +0000 (UTC)
X-FDA: 84661371144.02.7C75821
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf25.hostedemail.com (Postfix) with ESMTP id 340A6A000D
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 16:47:29 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=none;
	spf=pass (imf25.hostedemail.com: domain of fedorov.nikita@h-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=fedorov.nikita@h-partners.com;
	dmarc=pass (policy=quarantine) header.from=h-partners.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776271651;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=Zea3HjUgRWG/fBmALUWnqq0TgzKXGLOrbiT8m5uaTMM=;
	b=8qGuPC8KUYK+LaWjno91pXL6GpobNMmoLUpqkTtbVMFjxJ41zUSOLp04FGO2D56s3HZCSf
	rBQN7v5nGkDh9knBmYXM7GYfwE/N6K2qARQbun81HcduU1P6cAGoY6oqmDKiGTYWMA7Aio
	FTDUKWa/zp1rOMdC49BC1MTZIXCmk0U=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776271651; a=rsa-sha256;
	cv=none;
	b=pH0uGzucnNEeFbFXwFI9UiRQXOcDueJkATeBb2WIkEIt/Qsekb1qEl2NI7zEc1xiIiaTRT
	FxvSlM6LT4KOUnlOuieyKNa8mOMgx+zRdotn6s6YHHSf+zHFkp1wJKgty6REqHTTDrSj1A
	tM3qy4wuDFVNrxEOm/zdxttTYmfurk4=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	spf=pass (imf25.hostedemail.com: domain of fedorov.nikita@h-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=fedorov.nikita@h-partners.com;
	dmarc=pass (policy=quarantine) header.from=h-partners.com
Received: from mail.maildlp.com (unknown [172.18.224.83])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4fwn9p1RZ4zHnGjl;
	Thu, 16 Apr 2026 00:47:10 +0800 (CST)
Received: from mscpeml500003.china.huawei.com (unknown [7.188.49.51])
	by mail.maildlp.com (Postfix) with ESMTPS id 8C8F340569;
	Thu, 16 Apr 2026 00:47:26 +0800 (CST)
Received: from localhost.localdomain (10.123.66.205) by
 mscpeml500003.china.huawei.com (7.188.49.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 15 Apr 2026 19:47:25 +0300
From: Fedorov Nikita <fedorov.nikita@h-partners.com>
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav
 Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, Juergen Gross <jgross@suse.com>, Ajay
 Kaher <ajay.kaher@broadcom.com>, Alexey Makhalov
	<alexey.makhalov@broadcom.com>, <bcm-kernel-feedback-list@broadcom.com>, Arnd
 Bergmann <arnd@arndb.de>, Peter Zijlstra <peterz@infradead.org>, Boqun Feng
	<boqun@kernel.org>, Waiman Long <longman@redhat.com>, Darren Hart
	<dvhart@infradead.org>, Davidlohr Bueso <dave@stgolabs.net>,
	<andrealmeid@igalia.com>, Andrew Morton <akpm@linux-foundation.org>, David
 Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, Matthew Brost
	<matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim
	<rakie.kim@sk.com>, <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple
	<apopple@nvidia.com>, Anatoly Stepanov <stepanov.anatoly@huawei.com>
CC: Nikita Fedorov <fedorov.nikita@h-partners.com>,
	<linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<virtualization@lists.linux.dev>, <linux-arch@vger.kernel.org>,
	<linux-mm@kvack.org>, <guohanjun@huawei.com>, <wangkefeng.wang@huawei.com>,
	<weiyongjun1@huawei.com>, <yusongping@huawei.com>, <leijitang@huawei.com>,
	<artem.kuzin@huawei.com>, <kang.sun@huawei.com>, <chenjieping3@huawei.com>
Subject: [RFC PATCH v3 0/7]
Date: Thu, 16 Apr 2026 00:44:52 +0800
Message-ID: <20260415164459.2904963-1-fedorov.nikita@h-partners.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.123.66.205]
X-ClientProxiedBy: mscpeml500003.china.huawei.com (7.188.49.51) To
 mscpeml500003.china.huawei.com (7.188.49.51)
X-Rspamd-Queue-Id: 340A6A000D
X-Rspamd-Server: rspam07
X-Stat-Signature: rjc7z6aeofkgadm15yafxhifm7hk9aue
X-Rspam-User: 
X-HE-Tag: 1776271649-256889
X-HE-Meta: U2FsdGVkX1+6qStEl1YRL5zYtuUUE/lJ4XcIvCK9n8+ejaT9vw83hlOSa6IXouOny6Gfc1TpDgcK/ZbMuDnCCkbQLjOb6chw8cc4Z09Dk1tETO2UUDfXRTqf3XMLPL+AcOtROY9k6iSCsK8ueMXNjZ5nOdrwDFbnwdTvHef8cymzDeMSp0sWxgQl1j9SjQK2GGz6rUybzsZYA9LDn2rhqnqS11efYs2liuRktTjZ7Enu5FDEucaq/OYTATAws2az45Js1k7zHB5zyi941JQHMjT2npGeKY/pJ4ofRat7qx9QCHn9speS8ecVWGd2mnozF2xn5TpOxDq/t290AOBvaEDO/n2lPceVpIy50jqeOcUGeDd3RfS5C0G4TofsXvKO7o7vlvs0PcDn5AvCAD7J2/0qIM+EQeU4jRVnZdx3FWWsCFs2NArJ0yfhx/u1USWGnX066bI3kIBSBpunCxP5vpQEdiRl3BgqejX9eqnIMCkE6xwVTWdDh5BfsOThDBpNunLUq6w6WQo1COK4nwFIlP6ekG3yjQFXIdDhaqfwxAs54BZ9l2/dbIdzm2V4kUCego3HPh8vZMmDCgAo4WfGj6rjxSOprwEy/h+u6PhkXCnCXRUZiiPXGUCM2YEVtznhqcjEkWn0MwOwRuRgXcGH4HCB08cfutNE7e39vuXFtrh41NWRpg1tH+UE2U3n8+ju5Z1CWqssUxNEpOWbGfBu8Kn1RwxxZCykuNq7/gdKed4j/mJ3fcDe7klCj50tqMHY0Ar7VuADlclFKE3YKLiMcPfQQ0L8Qg/jPjvXQfchgRsckCuqrNCrONwHpVA/1mQy7dNfTfUE7k0e6y2Rz2NmVmp2cFI2kt29heL/DZi/svqVWAD4sBqVhAh7ueeWLc13k9Bogu1Muhykkj1JkKGYAHrGFvUp9gjZAdsX8DAh33NtpWfj8yXi1Xf/EIj9Y7PQ62JwIw3O/iELa4XprFI
 K5y1m8Py
 7K10aVgfYBZZ4C7JpoEgNgbclrdNBEr0IBLW/QV6VaeXhbioV/kIoZGbCZ9v+Oywib0CaTfbo2TYjJqA4giNORgpwWiQ0iugs0gjhPdJs9Dq+RjrYwEIriqC0ue6zYFgbucu2Hy7XMZzOTwQRJDYTvxtmmx9KtbMzVErZEBp005+w50mkMxIM4ElnhI7No4JsGj6n0q49k0Xy6nlPF9TQcMqzChv5nO/I3ZTOUSXOrDtfTqKu7/4QrejiHrjDtacSVm4X6UO5UlEpq7CiWnWWe3eLudBJWd0fKjBOIqgjqkP/QrKzbx8TkL6K4w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Changes since v2:
  - split the patch into a smaller patch series,
  though it is still hard to split the hqlock internal logic itself
  - remove some unused code
  - rebased onto Linux v7.0
  - allocate hq-spinlock metadata with kvmalloc instead of memblock
  - added contention detection and verified we have no performance degradation in low contention scenario

[Motivation]

In a high contention case, existing Linux kernel spinlock implementations can become
inefficient on modern NUMA systems due to frequent and expensive
cross-NUMA cacheline transfers. 

This might happen due to following reasons:
 - on "contender enqueue" each lock contender updates a shared lock structure
 - on "MCS handoff" cross-NUMA cache-line transfer occurs when
two contenders are from different NUMA nodes.

Previous work regarding NUMA-aware spinlock in Linux kernel is CNA-lock:
https://lore.kernel.org/lkml/20210514200743.3026725-1-alex.kogan@oracle.com/

It reduces cross-NUMA cacheline traffic during handoff, but does not reduce it during enqueuing.
CNA design also requires the first contender to do additional work during global spinning
and keeps threads from all nodes other than the first one in the single secondary queue. 
In our measurements, we only saw benefits from using it on Kunpeng;
on x86 platforms, CNA behaved the same as a regular qspinlock.
Thus, there is still quite a lot of potential for optimization.

HQ-lock has completely different design concept: kind of cohort-lock and
queued-spinlock hybrid.

If someone wants to try the HQ-lock in some subsystem, just
change lock initialization code from `spin_lock_init()` to `spin_lock_init_hq()`,
or change `DEFINE_SPINLOCK()` macro to `DEFINE_SPINLOCK_HQ()` if the lock is static.
The dedicated bit in the lock structure is used to distiguish between the two lock types.

[Performance measurements]

Performance measurements were done on x86 (AMD EPYC) and arm64 (Kunpeng 920)
platforms with the following scenarious:
- Locktorture benchmark
- Memcached + memtier benchmark
- Ngnix + Wrk benchmark

[Locktorture]

NPS stands for "Nodes per socket"
+------------------------------+-----------------------+-------+-------+--------+
| AMD EPYC 9654									|
+------------------------------+-----------------------+-------+-------+--------+
| 192 cores (x2 hyper-threads) |                       |       |       |        |
| 2 sockets                    |                       |       |       |        |
| Locktorture 60 sec.          | NUMA nodes per-socket |       |       |        |
| Average gain (single lock)   | 1 NPS                 | 2 NPS | 4 NPS | 12 NPS |
| Total contender threads      |                       |       |       |        |
| 8                            | 19%                   | 21%   | 12%   | 12%    |
| 16                           | 13%                   | 18%   | 34%   | 75%    |
| 32                           | 8%                    | 14%   | 25%   | 112%   |
| 64                           | 11%                   | 12%   | 30%   | 152%   |
| 128                          | 9%                    | 17%   | 37%   | 163%   |
| 256                          | 2%                    | 16%   | 40%   | 168%   |
| 384                          | -1%                   | 14%   | 44%   | 186%   |
+------------------------------+-----------------------+-------+-------+--------+

+-----------------+-------+-------+-------+--------+
| Fairness factor | 1 NPS | 2 NPS | 4 NPS | 12 NPS |
+-----------------+-------+-------+-------+--------+
| 8               | 0.54  | 0.57  | 0.57  | 0.55   |
| 16              | 0.52  | 0.53  | 0.60  | 0.58   |
| 32              | 0.53  | 0.53  | 0.53  | 0.61   |
| 64              | 0.52  | 0.56  | 0.54  | 0.56   |
| 128             | 0.51  | 0.54  | 0.54  | 0.53   |
| 256             | 0.52  | 0.52  | 0.52  | 0.52   |
| 384             | 0.51  | 0.51  | 0.51  | 0.51   |
+-----------------+-------+-------+-------+--------+

+-------------------------+--------------+
| Kunpeng 920 (arm64)     |              |
+-------------------------+--------------+
| 96 cores (no MT)        |              |
| 2 sockets, 4 NUMA nodes |              |
| Locktorture 60 sec.     |              |
|                         |              |
| Total contender threads | Average gain |
| 8                       | 93%          |
| 16                      | 142%         |
| 32                      | 129%         |
| 64                      | 152%         |
| 96                      | 158%         |
+-------------------------+--------------+

[Memcached]

+---------------------------------+-----------------+-------------------+
| AMD EPYC 9654                   |                 |                   |
+---------------------------------+-----------------+-------------------+
| 192 cores (x2 hyper-threads)    |                 |                   |
| 2 sockets, NPS=4                |                 |                   |
|                                 |                 |                   |
| Memtier+memcached 1:1 R/W ratio |                 |                   |
| Workers                         | Throughput gain | Latency reduction |
| 32                              | 1%              | -1%               |
| 64                              | 1%              | -1%               |
| 128                             | 3%              | -4%               |
| 256                             | 7%              | -6%               |
| 384                             | 10%             | -8%               |
+---------------------------------+-----------------+-------------------+

+---------------------------------+-----------------+-------------------+
| Kunpeng 920 (arm64)             |                 |                   |
+---------------------------------+-----------------+-------------------+
| 96 cores (no MT)                |                 |                   |
| 2 sockets, 4 NUMA nodes         |                 |                   |
|                                 |                 |                   |
| Memtier+memcached 1:1 R/W ratio |                 |                   |
| Workers                         | Throughput gain | Latency reduction |
| 32                              | 4%              | -3%               |
| 64                              | 6%              | -6%               |
| 80                              | 8%              | -7%               |
| 96                              | 8%              | -8%               |
+---------------------------------+-----------------+-------------------+

[Nginx]

+-----------------------------------------------------------------------+-----------------+
| Kunpeng 920 (arm64)                                                   |                 |
+-----------------------------------------------------------------------+-----------------+
| 96 cores (no MT)                                                      |                 |
| 2 sockets, 4 NUMA nodes                                               |                 |
|                                                                       |                 |
| Nginx + WRK benchmark, single file (lockref spinlock contention case) |                 |
| Workers                                                               | Throughput gain |
| 32                                                                    | 1%              |
| 64                                                                    | 68%             |
| 80                                                                    | 72%             |
| 96                                                                    | 78%             |
+-----------------------------------------------------------------------+-----------------+
Despite, the test is a single-file test, it can be related to real-life cases, when some
html-pages are accessed much more frequently than others (index.html, etc.)

[Low contention remarks]
After adding contention detection scheme, we do not see performance degradation in low contention scenario (< 8 threads),
throughput of HQspinlock is equal to qspinlock,
while still having practically the same improvement in high contention case as mentioned above.

Previous version:
https://lore.kernel.org/lkml/20251206062106.2109014-1-stepanov.anatoly@huawei.com/

Anatoly Stepanov (7):
  kernel: add hq-spinlock types
  hq-spinlock: implement inner logic
  hq-spinlock: add contention detection
  hq-spinlock: add hq-spinlock tunables and debug statistics
  kernel: introduce general hq-spinlock support
  lockref: use hq-spinlock
  futex: use hq-spinlock for hash buckets

 arch/arm64/include/asm/qspinlock.h       |  37 +
 arch/x86/include/asm/hq-spinlock.h       |  34 +
 arch/x86/include/asm/paravirt-spinlock.h |   3 +-
 arch/x86/include/asm/qspinlock.h         |   6 +-
 include/asm-generic/qspinlock.h          |  23 +-
 include/asm-generic/qspinlock_types.h    |  44 +-
 include/linux/lockref.h                  |   2 +-
 include/linux/spinlock.h                 |  26 +
 include/linux/spinlock_types.h           |  26 +
 include/linux/spinlock_types_raw.h       |  20 +
 kernel/Kconfig.locks                     |  29 +
 kernel/futex/core.c                      |   2 +-
 kernel/locking/hqlock_core.h             | 850 +++++++++++++++++++++++
 kernel/locking/hqlock_meta.h             | 487 +++++++++++++
 kernel/locking/hqlock_proc.h             | 164 +++++
 kernel/locking/hqlock_types.h            | 122 ++++
 kernel/locking/qspinlock.c               |  65 +-
 kernel/locking/qspinlock.h               |   4 +-
 kernel/locking/spinlock_debug.c          |  20 +
 mm/mempolicy.c                           |   4 +
 20 files changed, 1939 insertions(+), 29 deletions(-)
 create mode 100644 arch/arm64/include/asm/qspinlock.h
 create mode 100644 arch/x86/include/asm/hq-spinlock.h
 create mode 100644 kernel/locking/hqlock_core.h
 create mode 100644 kernel/locking/hqlock_meta.h
 create mode 100644 kernel/locking/hqlock_proc.h
 create mode 100644 kernel/locking/hqlock_types.h

-- 
2.34.1


