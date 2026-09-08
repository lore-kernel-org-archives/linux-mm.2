Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11F20C79FA1
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 22:10:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE1856B0092; Tue,  8 Sep 2026 18:10:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB8D06B0093; Tue,  8 Sep 2026 18:10:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA7E56B0095; Tue,  8 Sep 2026 18:10:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B06B06B0092
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 18:10:22 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 24FFAC06F7
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 22:10:22 +0000 (UTC)
X-FDA: 85191989484.27.BEFC6F0
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	by imf03.hostedemail.com (Postfix) with ESMTP id A94B32000C
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 22:10:19 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Oo+2hz35;
	spf=pass (imf03.hostedemail.com: domain of ehab.ababneh@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=ehab.ababneh@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788905420;
	b=K/v+kcLyV/2BOqnLGKXmAQ19HiU1aN10/a2t3/V9MZ3hGbz//oPJ+AuQXkQMriu2wRpEkS
	kbz3Cbd67DYVvjT1aSdRd8Wg3atm/43OWkhZeFTkTF0D9JFkZcSRNbC9Yx7mZFdeEt3hRt
	4O2/aS4mUhH2HSwZMDxL4HA0ojc4M0I=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Oo+2hz35;
	spf=pass (imf03.hostedemail.com: domain of ehab.ababneh@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=ehab.ababneh@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788905420;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eQcF1AejhKlKOOUuXW0Q34lTgE6A/iraQP1t9Yzl5YQ=;
	b=nIgPuudJR/RV6zd8eyXuE4irMt0GvMfkgmfOBkX3jWuYAQzWOCS2gEfUHke4vhNCLoH8ey
	xMPQ3Jy3CDX3Zcn589sa+rzihXqn7ZU37g1gejQRLoZ1dNkjP2yDI4aEt9kAnn6xE159ac
	gx73FcgaYAM6Crbr3+MJ1XPGtQ6xvuc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788905420; x=1820441420;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=KDsH3EsfMj321HxAA8o+oYjYftYi1fopLf6hMlf8sZM=;
  b=Oo+2hz352Fxha3gH/XSuph0ArRD4MJrSiQ33lDwAZdc9rTmkXyn0xKnI
   qFZ4zzisrJrTcBJV9npVNIiy/4CUyyc4QGPy5/RF8xc+df57C+NyN60h2
   36GJGS8mPADj6PwwJACKZ4NCSFCtvrm9gk0GBPf4q6ll4JfyAg6jvcKtz
   YhHx8ZDeyydlzHTcwCeedPL9Ygpr73GGravLk8VBieBgOG5FriSmhoH3u
   OtEScp90luSTjJYvbBnd/gYu8SjGQJ6fxo31+cDWz3MwJiyJY/CEslC+E
   UCcI0lzjXfWh90VFVHl/G0OhPFZgeoP92Ji9BLUv7A5jz4XyhkgocDV7O
   A==;
X-CSE-ConnectionGUID: v0inj/xMQFSIYiKqlvTSbg==
X-CSE-MsgGUID: UpCRhbE3TN2wfnLKuZQmdg==
X-IronPort-AV: E=McAfee;i="6800,10657,11900"; a="93017389"
X-IronPort-AV: E=Sophos;i="6.25,269,1779174000"; 
   d="scan'208";a="93017389"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2026 15:10:19 -0700
X-CSE-ConnectionGUID: Q8qZ0svcRFiAvoUk4+IUiQ==
X-CSE-MsgGUID: qI9ok6oFQOypfQzru6OIyQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,269,1779174000"; 
   d="scan'208";a="296067793"
Received: from jf.intel.com ([10.165.154.102])
  by fmviesa001.fm.intel.com with ESMTP; 08 Sep 2026 15:10:18 -0700
From: Ehab Ababneh <ehab.ababneh@intel.com>
To: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Buddy Lumpkin <buddy.lumpkin@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Kairui Song <kasong@tencent.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>
Subject: [RFC PATCH 1/3] vmscan: Support multiple kswapd threads per node
Date: Tue,  8 Sep 2026 15:10:54 -0700
Message-ID: <20260908221059.14777-2-ehab.ababneh@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260908221059.14777-1-ehab.ababneh@intel.com>
References: <20260908221059.14777-1-ehab.ababneh@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: A94B32000C
X-Rspam-User: 
X-Stat-Signature: atma11d9mogd8yahr8sj7joffemwp4zo
X-HE-Tag: 1788905419-258371
X-HE-Meta: U2FsdGVkX1/yXTSRNGd/ga/67cdC+cB6orkdfHarnkQk1TpljpGbzKhK31MOU/tedhAEn8wv1yTkulgrAxhv3okGu3MCncOoiGZYFS3C7Dyq6jMaBzVrfyM2vSaUDVJlNKQNDEJGwJnnU6hu6ANUF3inohHfoMy/MugoIBrueQBAE/gVqf6iL8RbItRFanPQGw1VLp688JKjFFjLdkpAU5Hhc7jUy0cBPDy43hzy7BR//WSWHE4lizVguQZ5ub8xaoDwFK5NRlhc1lv/rA+LjaGv0uzR/bkOWHFQU4KQBjSkaLfZGnQxi4negIUuPIE7Sw/Wqr9gHVNA3pgwCGvntmK9LULbbX+nzAQZSo4UwD43khakcjSnXUtfdw2b+4v11RNYphpncPxs0NshMXt74aHuHvoF53eRU4tmR4GJBMvqxIKhMZRgPTgNohNdVX9a/MU6qxL8PH/bwNHucv3ZU2JfcBkxAa80O2KrC1UOXmG5LWzxNmmC9bokmX200vwHJtnCiD8es07DxTUZHwuV8sAr0FVjudm5x6W+ky81n1o8a8HaHscer7EHHhYzWmuCv6ha9Zo+9sofYRoQ++QKXiIIU2YSnXammOz7T6l7YQVSA1u3M11+FdNEzLRYyrUhLTBebs7i18sSG3KxB1iBww25mMB+mtkzIgq7wztjfsTneKKsNg6hbKXh5fbihe9R4Pwmr3D5kgdezR6wxIffwfSONE1k/GLucjG2k+QWJ4vsHQw0ceLHCLwaOYCB5WdisABwQjyrcVzUTLEfC65iCiPnBBHdZaazyO0A6zpixVMUl1s6d2mY6IB0ugH1KWdHJ9ZbSTxmAHEHTfaO9EZ5eO068PNR3KQRlvq5ziXOouaH/7JMrX9+F3Uans0fIntyk2vNLjcobLjCB7D8lHiBXDwwpCFQlCaYtnIFAUF4HzmU7f7QdToNuEAwPsUFXmmui1ryPt2Qu9Qhfb3JpW9
 NZ5k0O37
 Rb9o6ALueBTvTjCbX016hJ+jaz1n6KWRbBVggWBmRrorPjU/Cj0yvPoUolTY61fw7VgTP4XxYAs/WlLFZBnh12kvSi1TXqL+kqnrClLh1PVs7sLWFacru/dlCEM7iD/03Iww9GsnvwcdgpwnG9fzXhGzhSAIM96osE/zeVUhnZvegCdjczbNZQ6lebbq5Ij3p4nrkJ9AWt1+cCoU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Buddy Lumpkin <buddy.lumpkin@oracle.com>

Page replacement is handled in the Linux Kernel in one of two ways:

1) Asynchronously via kswapd
2) Synchronously, via direct reclaim

At page allocation time the allocating task is immediately given a page
from the zone free list allowing it to go right back to work doing
whatever it was doing; Probably directly or indirectly executing business
logic.

Just prior to satisfying the allocation, free pages is checked to see if
it has reached the zone low watermark and if so, kswapd is awakened.
Kswapd will start scanning pages looking for inactive pages to evict to
make room for new page allocations. The work of kswapd allows tasks to
continue allocating memory from their respective zone free list without
incurring any delay.

When the demand for free pages exceeds the rate that kswapd tasks can
supply them, page allocation works differently. Once the allocating task
finds that the number of free pages is at or below the zone min watermark,
the task will no longer pull pages from the free list. Instead, the task
will run the same CPU-bound routines as kswapd to satisfy its own
allocation by scanning and evicting pages. This is called a direct reclaim.

The time spent performing a direct reclaim can be substantial, often
taking tens to hundreds of milliseconds for small order0 allocations to
half a second or more for order9 huge-page allocations. In fact, kswapd is
not actually required on a linux system. It exists for the sole purpose of
optimizing performance by preventing direct reclaims.

When memory shortfall is sufficient to trigger direct reclaims, they can
occur in any task that is running on the system. A single aggressive
memory allocating task can set the stage for collateral damage to occur in
small tasks that rarely allocate additional memory. Consider the impact of
injecting an additional 100ms of latency when nscd allocates memory to
facilitate caching of a DNS query.

The presence of direct reclaims 10 years ago was a fairly reliable
indicator that too much was being asked of a Linux system. Kswapd was
likely wasting time scanning pages that were ineligible for eviction.
Adding RAM or reducing the working set size would usually make the problem
go away. Since then hardware has evolved to bring a new struggle for
kswapd. Storage speeds have increased by orders of magnitude while CPU
clock speeds stayed the same or even slowed down in exchange for more
cores per package. This presents a throughput problem for a single
threaded kswapd that will get worse with each generation of new hardware.

Test Details

NOTE: The tests below were run with shadow entries disabled. See the
associated patch and cover letter for details

The tests below were designed with the assumption that a kswapd bottleneck
is best demonstrated using filesystem reads. This way, the inactive list
will be full of clean pages, simplifying the analysis and allowing kswapd
to achieve the highest possible steal rate. Maximum steal rates for kswapd
are likely to be the same or lower for any other mix of page types on the
system.

Tests were run on a 2U Oracle X7-2L with 52 Intel Xeon Skylake 2GHz cores,
756GB of RAM and 8 x 3.6 TB NVMe Solid State Disk drives. Each drive has
an XFS file system mounted separately as /d0 through /d7. SSD drives
require multiple concurrent streams to show their potential, so I created
eleven 250GB zero-filled files on each drive so that I could test with
parallel reads.

The test script runs in multiple stages. At each stage, the number of dd
tasks run concurrently is increased by 2. I did not include all of the
test output for brevity.

During each stage dd tasks are launched to read from each drive in a round
robin fashion until the specified number of tasks for the stage has been
reached. Then iostat, vmstat and top are started in the background with 10
second intervals. After five minutes, all of the dd tasks are killed and
the iostat, vmstat and top output is parsed in order to report the
following:

CPU consumption
- sy - aggregate kernel mode CPU consumption from vmstat output. The value
       doesn't tend to fluctuate much so I just grab the highest value.
       Each sample is averaged over 10 seconds
- dd_cpu - for all of the dd tasks averaged across the top samples since
           there is a lot of variation.

Throughput
- in Kbytes
- Command is iostat -x -d 10 -g total

This first test performs reads using O_DIRECT in order to show the maximum
throughput that can be obtained using these drives. It also demonstrates
how rapidly throughput scales as the number of dd tasks are increased.

The dd command for this test looks like this:

Command Used: dd iflag=direct if=/d${i}/$n of=/dev/null bs=4M

Test #1: Direct IO
dd sy dd_cpu throughput
6  0  2.33   14726026.40
10 1  2.95   19954974.80
16 1  2.63   24419689.30
22 1  2.63   25430303.20
28 1  2.91   26026513.20
34 1  2.53   26178618.00
40 1  2.18   26239229.20
46 1  1.91   26250550.40
52 1  1.69   26251845.60
58 1  1.54   26253205.60
64 1  1.43   26253780.80
70 1  1.31   26254154.80
76 1  1.21   26253660.80
82 1  1.12   26254214.80
88 1  1.07   26253770.00
90 1  1.04   26252406.40

Throughput was close to peak with only 22 dd tasks. Very little system CPU
was consumed as expected as the drives DMA directly into the user address
space when using direct IO.

In this next test, the iflag=direct option is removed and we only run the
test until the pgscan_kswapd from /proc/vmstat starts to increment. At
that point metrics are parsed and reported and the pagecache contents are
dropped prior to the next test. Lather, rinse, repeat.

Test #2: standard file system IO, no page replacement
dd sy dd_cpu throughput
6  2  28.78  5134316.40
10 3  31.40  8051218.40
16 5  34.73  11438106.80
22 7  33.65  14140596.40
28 8  31.24  16393455.20
34 10 29.88  18219463.60
40 11 28.33  19644159.60
46 11 25.05  20802497.60
52 13 26.92  22092370.00
58 13 23.29  22884881.20
64 14 23.12  23452248.80
70 15 22.40  23916468.00
76 16 22.06  24328737.20
82 17 20.97  24718693.20
88 16 18.57  25149404.40
90 16 18.31  25245565.60

Each read has to pause after the buffer in kernel space is populated while
those pages are added to the pagecache and copied into the user address
space. For this reason, more parallel streams are required to achieve peak
throughput. The copy operation consumes substantially more CPU than direct
IO as expected.

The next test measures throughput after kswapd starts running. This is the
same test only we wait for kswapd to wake up before we start collecting
metrics. The script actually keeps track of a few things that were not
mentioned earlier. It tracks direct reclaims and page scans by watching
the metrics in /proc/vmstat. CPU consumption for kswapd is tracked the
same way it is tracked for dd.

Since the test is 100% reads, you can assume that the page steal rate for
kswapd and direct reclaims is almost identical to the scan rate.

Test #3: 1 kswapd thread per node
dd sy dd_cpu kswapd0 kswapd1 throughput  dr    pgscan_kswapd pgscan_direct
10 4  26.07  28.56   27.03   7355924.40  0     459316976     0
16 7  34.94  69.33   69.66   10867895.20 0     872661643     0
22 10 36.03  93.99   99.33   13130613.60 489   1037654473    11268334
28 10 30.34  95.90   98.60   14601509.60 671   1182591373    15429142
34 14 34.77  97.50   99.23   16468012.00 10850 1069005644    249839515
40 17 36.32  91.49   97.11   17335987.60 18903 975417728     434467710
46 19 38.40  90.54   91.61   17705394.40 25369 855737040     582427973
52 22 40.88  83.97   83.70   17607680.40 31250 709532935     724282458
58 25 40.89  82.19   80.14   17976905.60 35060 657796473     804117540
64 28 41.77  73.49   75.20   18001910.00 39073 561813658     895289337
70 33 45.51  63.78   64.39   17061897.20 44523 379465571     1020726436
76 36 46.95  57.96   60.32   16964459.60 47717 291299464     1093172384
82 39 47.16  55.43   56.16   16949956.00 49479 247071062     1134163008
88 42 47.41  53.75   47.62   16930911.20 51521 195449924     1180442208
90 43 47.18  51.40   50.59   16864428.00 51618 190758156     1183203901

In the previous test where kswapd was not involved, the system-wide kernel
mode CPU consumption with 90 dd tasks was 16%. In this test CPU consumption
with 90 tasks is at 43%. With 52 cores, and two kswapd tasks (one per NUMA
node), kswapd can only be responsible for a little over 4% of the increase.
The rest is likely caused by 51,618 direct reclaims that scanned 1.2
billion pages over the five minute time period of the test.

Same test, more kswapd tasks:

Test #4: 4 kswapd threads per node
dd sy dd_cpu kswapd0 kswapd1 throughput  dr    pgscan_kswapd pgscan_direct
10 5  27.09  16.65   14.17   7842605.60  0     459105291     0
16 10 37.12  26.02   24.85   11352920.40 15    920527796     358515
22 11 36.94  37.13   35.82   13771869.60 0     1132169011     0
28 13 35.23  48.43   46.86   16089746.00 0     1312902070     0
34 15 33.37  53.02   55.69   18314856.40 0     1476169080     0
40 19 35.90  69.60   64.41   19836126.80 0     1629999149     0
46 22 36.82  88.55   57.20   20740216.40 0     1708478106     0
52 24 34.38  93.76   68.34   21758352.00 0     1794055559     0
58 24 30.51  79.20   82.33   22735594.00 0     1872794397     0
64 26 30.21  97.12   76.73   23302203.60 176   1916593721     4206821
70 33 32.92  92.91   92.87   23776588.00 3575  1817685086     85574159
76 37 31.62  91.20   89.83   24308196.80 4752  1812262569     113981763
82 29 25.53  93.23   92.33   24802791.20 306   2032093122     7350704
88 43 37.12  76.18   77.01   25145694.40 20310 1253204719     487048202
90 42 38.56  73.90   74.57   22516787.60 22774 1193637495     545463615

By increasing the number of kswapd threads, throughput increased by ~50%
while kernel mode CPU utilization decreased or stayed the same, likely due
to a decrease in the number of parallel tasks at any given time doing page
replacement.

Signed-off-by: Buddy Lumpkin <buddy.lumpkin@oracle.com>
Signed-off-by: Ehab Ababneh <ehab.ababneh@intel.com>
---
 include/linux/mmzone.h |   5 +-
 mm/compaction.c        |   8 +++-
 mm/internal.h          |   3 ++
 mm/page_alloc.c        |  26 +++++++++++
 mm/vmscan.c            | 104 +++++++++++++++++++++++++++++++++++------
 5 files changed, 128 insertions(+), 18 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index ca2712187147..5b06a6bc9c82 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -62,6 +62,8 @@
  */
 #define PAGE_ALLOC_COSTLY_ORDER 3
 
+#define MAX_KSWAPD_THREADS 16
+
 #if !defined(CONFIG_HAVE_GIGANTIC_FOLIOS)
 /*
  * We don't expect any folios that exceed buddy sizes (and consequently
@@ -1516,7 +1518,8 @@ typedef struct pglist_data {
 #ifdef CONFIG_MEMORY_HOTPLUG
 	struct mutex kswapd_lock;
 #endif
-	struct task_struct *kswapd;	/* Protected by kswapd_lock */
+	/* Protected by kswapd_lock */
+	struct task_struct *kswapd[MAX_KSWAPD_THREADS];
 	int kswapd_order;
 	enum zone_type kswapd_highest_zoneidx;
 
diff --git a/mm/compaction.c b/mm/compaction.c
index f08765ade014..e72112e2716e 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -2168,9 +2168,13 @@ static isolate_migrate_t isolate_migratepages(struct compact_control *cc)
 static bool kswapd_is_running(pg_data_t *pgdat)
 {
 	bool running;
-
+	int i;
 	pgdat_kswapd_lock(pgdat);
-	running = pgdat->kswapd && task_is_running(pgdat->kswapd);
+	for (i = 0; i < MAX_KSWAPD_THREADS; ++i) {
+		running = pgdat->kswapd[i] && task_is_running(pgdat->kswapd[i]);
+		if (running)
+			break;
+	}
 	pgdat_kswapd_unlock(pgdat);
 
 	return running;
diff --git a/mm/internal.h b/mm/internal.h
index 181e79f1d6a2..1c4cc3b7492b 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -645,10 +645,13 @@ extern char * const zone_names[MAX_NR_ZONES];
 /* perform sanity checks on struct pages being allocated or freed */
 DECLARE_STATIC_KEY_MAYBE(CONFIG_DEBUG_VM, check_pages_enabled);
 
+extern int kswapd_threads;
+extern int max_kswapd_threads;
 extern int min_free_kbytes;
 extern int defrag_mode;
 
 void setup_per_zone_wmarks(void);
+void update_kswapd_threads(void);
 void calculate_min_free_kbytes(void);
 int __meminit init_per_zone_wmark_min(void);
 void page_alloc_sysctl_init(void);
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index ee902a468c2f..abecf96a599b 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -273,6 +273,7 @@ int user_min_free_kbytes = -1;
 static int watermark_boost_factor __read_mostly = 15000;
 static int watermark_scale_factor = 10;
 int defrag_mode;
+int max_kswapd_threads = MAX_KSWAPD_THREADS;
 
 /* movable_zone is the "real" zone pages in ZONE_MOVABLE are taken from */
 int movable_zone;
@@ -6614,6 +6615,22 @@ static int min_free_kbytes_sysctl_handler(const struct ctl_table *table, int wri
 	return 0;
 }
 
+static int kswapd_threads_sysctl_handler(const struct ctl_table *table,
+					 int write, void __user *buffer,
+					 size_t *length, loff_t *ppos)
+{
+	int rc;
+
+	rc = proc_dointvec_minmax(table, write, buffer, length, ppos);
+	if (rc)
+		return rc;
+
+	if (write)
+		update_kswapd_threads();
+
+	return 0;
+}
+
 static int watermark_scale_factor_sysctl_handler(const struct ctl_table *table, int write,
 		void *buffer, size_t *length, loff_t *ppos)
 {
@@ -6776,6 +6793,15 @@ static const struct ctl_table page_alloc_sysctl_table[] = {
 		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= SYSCTL_ZERO,
 	},
+	{
+		.procname       = "kswapd_threads",
+		.data           = &kswapd_threads,
+		.maxlen         = sizeof(kswapd_threads),
+		.mode           = 0644,
+		.proc_handler   = kswapd_threads_sysctl_handler,
+		.extra1         = SYSCTL_ONE,
+		.extra2         = &max_kswapd_threads,
+	},
 	{
 		.procname	= "watermark_scale_factor",
 		.data		= &watermark_scale_factor,
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 35c3bb15ae96..fbb04848f59b 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -179,6 +179,13 @@ struct scan_control {
 	struct reclaim_state reclaim_state;
 };
 
+/*
+ * Number of active kswapd threads
+ */
+#define DEF_KSWAPD_THREADS_PER_NODE 1
+int kswapd_threads = DEF_KSWAPD_THREADS_PER_NODE;
+int kswapd_threads_current = DEF_KSWAPD_THREADS_PER_NODE;
+
 #ifdef ARCH_HAS_PREFETCHW
 #define prefetchw_prev_lru_folio(_folio, _base, _field)			\
 	do {								\
@@ -7587,26 +7594,91 @@ unsigned long shrink_all_memory(unsigned long nr_to_reclaim)
 }
 #endif /* CONFIG_HIBERNATION */
 
+static void update_kswapd_threads_node(int nid)
+{
+	pg_data_t *pgdat;
+	int drop, increase;
+	int last_idx, start_idx, hid;
+	int nr_threads = kswapd_threads_current;
+
+	pgdat = NODE_DATA(nid);
+	pgdat_kswapd_lock(pgdat);
+	last_idx = nr_threads - 1;
+	if (kswapd_threads < nr_threads) {
+		drop = nr_threads - kswapd_threads;
+		for (hid = last_idx; hid > (last_idx - drop); hid--) {
+			if (pgdat->kswapd[hid]) {
+				kthread_stop(pgdat->kswapd[hid]);
+				pgdat->kswapd[hid] = NULL;
+			}
+		}
+	} else {
+		increase = kswapd_threads - nr_threads;
+		start_idx = last_idx + 1;
+		for (hid = start_idx; hid < (start_idx + increase); hid++) {
+			pgdat->kswapd[hid] = kthread_run(kswapd, pgdat, "kswapd%d:%d",
+							 nid, hid);
+			if (IS_ERR(pgdat->kswapd[hid])) {
+				pr_err("Failed to start kswapd%d on node %d\n", hid, nid);
+				pgdat->kswapd[hid] = NULL;
+				/*
+				 * We are out of resources. Do not start any
+				 * more threads.
+				 */
+				break;
+			}
+		}
+	}
+	pgdat_kswapd_unlock(pgdat);
+}
+
+void update_kswapd_threads(void)
+{
+	int nid;
+
+	if (kswapd_threads_current == kswapd_threads)
+		return;
+
+	/*
+	 * Hold the memory hotplug lock to avoid racing with memory
+	 * hotplug initiated updates
+	 */
+	mem_hotplug_begin();
+	for_each_node_state(nid, N_MEMORY)
+		update_kswapd_threads_node(nid);
+
+	pr_info("kswapd_thread count changed, old:%d new:%d\n",
+		kswapd_threads_current, kswapd_threads);
+	kswapd_threads_current = kswapd_threads;
+	mem_hotplug_done();
+}
+
 /*
  * This kswapd start function will be called by init and node-hot-add.
  */
 void __meminit kswapd_run(int nid)
 {
 	pg_data_t *pgdat = NODE_DATA(nid);
+	int hid, nr_threads;
 
 	pgdat_kswapd_lock(pgdat);
-	if (!pgdat->kswapd) {
-		pgdat->kswapd = kthread_create_on_node(kswapd, pgdat, nid, "kswapd%d", nid);
-		if (IS_ERR(pgdat->kswapd)) {
-			/* failure at boot is fatal */
-			pr_err("Failed to start kswapd on node %d, ret=%pe\n",
-				   nid, pgdat->kswapd);
-			BUG_ON(system_state < SYSTEM_RUNNING);
-			pgdat->kswapd = NULL;
-		} else {
-			wake_up_process(pgdat->kswapd);
+	nr_threads = kswapd_threads;
+	for (hid = 0; hid < nr_threads; hid++) {
+		if (!pgdat->kswapd[hid]) {
+			pgdat->kswapd[hid] =
+				kthread_create_on_node(kswapd, pgdat, nid,
+						       "kswapd%d:%d", nid, hid);
+			if (IS_ERR(pgdat->kswapd[hid])) {
+				/* failure at boot is fatal */
+				pr_err("Failed to start kswapd%d on node %d, ret=%pe\n", hid,
+				       nid, pgdat->kswapd[hid]);
+				pgdat->kswapd[hid] = NULL;
+			} else {
+				wake_up_process(pgdat->kswapd[hid]);
+			}
 		}
 	}
+	kswapd_threads_current = nr_threads;
 	pgdat_kswapd_unlock(pgdat);
 }
 
@@ -7617,13 +7689,15 @@ void __meminit kswapd_run(int nid)
 void __meminit kswapd_stop(int nid)
 {
 	pg_data_t *pgdat = NODE_DATA(nid);
-	struct task_struct *kswapd;
+	int hid;
+	int nr_threads = kswapd_threads_current;
 
 	pgdat_kswapd_lock(pgdat);
-	kswapd = pgdat->kswapd;
-	if (kswapd) {
-		kthread_stop(kswapd);
-		pgdat->kswapd = NULL;
+	for (hid = 0; hid < nr_threads; hid++) {
+		if (pgdat->kswapd[hid]) {
+			kthread_stop(pgdat->kswapd[hid]);
+			pgdat->kswapd[hid] = NULL;
+		}
 	}
 	pgdat_kswapd_unlock(pgdat);
 }
-- 
2.43.0


