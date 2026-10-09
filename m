Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC809CA9EBB
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 20:30:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C0C76B0095; Fri,  9 Oct 2026 16:30:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 64AE36B0096; Fri,  9 Oct 2026 16:30:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3FE226B0098; Fri,  9 Oct 2026 16:30:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0DB386B0095
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 16:30:51 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 87F5EA050F
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 20:30:50 +0000 (UTC)
X-FDA: 85304231460.14.FA74122
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	by imf02.hostedemail.com (Postfix) with ESMTP id C8F8E80008
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 20:30:47 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=N0HLiU3o;
	spf=pass (imf02.hostedemail.com: domain of ehab.ababneh@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=ehab.ababneh@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791577848;
	b=3oVM8g7JhLJGBChfZIU7yGn5a2R+tRqc6fOYE4wmHGQTBknZQmhBGp6MOQ54kiWiT84wrB
	Gx399Cvc7fVW7cO5mMJS6ATSFROeRVlJw4NyAzLmptGr7jiZ2fOT4KhmrKCCdFLIGKzNx2
	GlERv/v+JYE7GaPgKZi1d1i9Pyc6T6Y=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=N0HLiU3o;
	spf=pass (imf02.hostedemail.com: domain of ehab.ababneh@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=ehab.ababneh@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791577848;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=soLP1CQFk6AYIXOPk9Cdl6s21EpFl+qf1LqegK6Ez4Q=;
	b=uOnZrcprrAfjK4oMFF+igtoiIo60xHWbSpsILoRwIomGZHu/CbRhrFcBuvteuoa4nBug+n
	ltJb4sGH2dB200zlJX8Uup4xIrelTmySs78mLaCQOqBDfR7sPDsZzBP7Rr9OZcOhM8JNdO
	LUxGiXRjhFfN3uVVEbGIV1x1EgAD+7U=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791577848; x=1823113848;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=nuh4glhE5+tZTkrwlf3buOXcyGtsns2k4tvQ8GrOqRQ=;
  b=N0HLiU3oJubBdszN/JVkVaLjYjsxYPhXyxsVLSBkWWS5SDVCss44wKjz
   KsokP2Q14nLdA2LvlazUVF231ZApgPcJP/5+HfO/LAqZRZpBjj5g+vxvw
   r/vCP3GoLBq4JH5c64FckACrPY2mzdS00He5xeTvBiggXQ2xXsXxnUy+x
   xgIZDU/PyFe0/Dg/+tYqTD7nsowjWDWRTMex7QQ93cf0KqzdxcmblsB8o
   GgOQ9pXH5GzEcupfQQEOgIQzRBa+yTSFCUMiveZ6/hJliEVQ5RYPogGvz
   K7KgYcD4LVrUi4M+G+uwfYqfh3CPYrHjP+02VIAvLEmRANQY7qzr9la16
   w==;
X-CSE-ConnectionGUID: GSnCfySEQAWrBP0e6IafxA==
X-CSE-MsgGUID: UTTQGYQ0R6i5N2YA0hWjBA==
X-IronPort-AV: E=McAfee;i="6800,10657,11930"; a="284536"
X-IronPort-AV: E=Sophos;i="6.27,149,1787036400"; 
   d="scan'208";a="284536"
Received: from fmviesa012.fm.intel.com ([10.60.135.152])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Oct 2026 13:30:46 -0700
X-CSE-ConnectionGUID: nuGkKXm7S7mFQaq40c30Eg==
X-CSE-MsgGUID: vfEWBJ+8Qha1WLUiSh0zrg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,149,1787036400"; 
   d="scan'208";a="2193180"
Received: from jf.intel.com ([10.165.154.102])
  by fmviesa012.fm.intel.com with ESMTP; 09 Oct 2026 13:30:45 -0700
From: Ehab Ababneh <ehab.ababneh@intel.com>
To: ziy@nvidia.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: buddy.lumpkin@oracle.com,
	akpm@linux-foundation.org,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	baoquan.he@linux.dev,
	baolin.wang@linux.alibaba.com,
	Ehab Ababneh <ehab.ababneh@intel.com>
Subject: [RFC PATCH v2 1/5] vmscan: Support multiple kswapd threads per node
Date: Fri,  9 Oct 2026 13:33:00 -0700
Message-ID: <ca68c5188e133af575302f797e7e8bd9f054709a.1791577417.git.ehab.ababneh@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1791577417.git.ehab.ababneh@intel.com>
References: <SJ1PR11MB6105E073723CFEEE8C8EDBF48C832@SJ1PR11MB6105.namprd11.prod.outlook.com> <cover.1791577417.git.ehab.ababneh@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: q4hkoghoow9wfc8upoqd5qcth1p7y5y9
X-Rspamd-Queue-Id: C8F8E80008
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1791577847-551140
X-HE-Meta: U2FsdGVkX1/kWipXUyY27mRLJS7DRcjgcEXbiLqt2u9l4M9+hwTc/2chzmQ+a2GpbXcZ5/1nqdD23W03PKNwJWbgMJx1h9sWK8melnmxJs74LpxvYitYkPApqNd61lczDVmh2AgdMd9KGoRDshvS/Wr+9Mfjwl6fz5OYxkMxIvK58buWHVRSCg7DKVwfyjnvMIKtfycq9P4dFfrZ6ORSkGr9BeOP739x0djopgr4GGkRSi3uHI2S1P2gZ9Ju/KVr/WIoARIQRPN/Zht8CVcHY5VMq2UYBKYc7erBp3ck+3wwBGafgPWGFB0iHP7UrYnejQNF5Un2gX8uj3EPrytl9n0EYSSTDN9NQSow1ix6bvh0x3jEFnDVkqNTv+aG0Y8LpnkKuSBg8D9+tQ12WN/JB5J9LvFWKhy1UPkybvJuBWWgq/XgV83qBYGjEkDohs1yEMek2nFDhMMja1ta9XVkZ+AZM4q5P17urIVWRdt0PG4JpjJDjKwb+xzfQHQxAsTGgG2TwBItGqLHdNWMpsyNctYzNSgzwUZBhHiMbLDuuLpigK0slZ3jYNNFfMdraqcIY67VANtg/fcEm+tV7tR0CBdTh9AUy5dxiZR05HfS1OsyECH4+0hYMUXqAThYn60GCCc+75r2/Qp1pcEWbpgYn9SE9C3GNO4NQrayhGhGz+LxjLU/SeRsiPy+9C0LBiLAM0cuQu/GBHkrMiEr0wR54MzZXyyv/BKVqMb9fqjOs5nL1hmLI544YNyRbe8Az/cZII4Zn9qPYNZMpp/4P6Es2ZPtcYD3cMwIGK8yTX6G4BVJOuRI/ftrvpTZ5hXitWTZF0+XjpMqACvafvPqIxNMsvkwQCNMZWgNySbybFYuPuEalCZqT3+2vAYgcyuuNLXO2VTyshgqGOyJcSSsNYrooj9LJeWhzrp5WGLsgZLoecduOwTNo1/EfoYdEuKYgFwcVQdJgkyfxnPeaUO/KLG
 oPVqssjD
 9lu0cq5GbIFD+i25eX0sNRZIwTKONL9SHS8gM/jYqZCssEnVqI9JYdPnX0HtiCY0DPZc1gX6apJ0ZmgqPw2qARTMMHTAQCcv5ssrVCibtIUWX6JyGrrrQZaBG5Bu3IeEU/C5gHFKfyND+x02vBdKrZS063BvgFtLa7fBQZO8maVIUfsRlc45nSfVaS0j7qXhIUjj/j4TRDpocVl0=
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
(cherry picked from commit 9ca50cb821f07627d555d31311f1c296bcd415d0)
---
 include/linux/mmzone.h |   5 +-
 mm/compaction.c        |   8 +++-
 mm/internal.h          |   3 ++
 mm/page_alloc.c        |  26 +++++++++++
 mm/vmscan.c            | 104 +++++++++++++++++++++++++++++++++++------
 5 files changed, 128 insertions(+), 18 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 94f9c3ff5416..3f0ae2b08835 100644
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
@@ -1529,7 +1531,8 @@ typedef struct pglist_data {
 #ifdef CONFIG_MEMORY_HOTPLUG
 	struct mutex kswapd_lock;
 #endif
-	struct task_struct *kswapd;	/* Protected by kswapd_lock */
+	/* Protected by kswapd_lock */
+	struct task_struct *kswapd[MAX_KSWAPD_THREADS];
 	int kswapd_order;
 	enum zone_type kswapd_highest_zoneidx;
 
diff --git a/mm/compaction.c b/mm/compaction.c
index a049415512c6..5db7d94aefc2 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -2198,9 +2198,13 @@ static isolate_migrate_t isolate_migratepages(struct compact_control *cc)
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
index 38b1165212c9..37f8ccfd661a 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -717,10 +717,13 @@ void set_recommended_min_free_kbytes(void);
 
 extern char * const zone_names[MAX_NR_ZONES];
 
+extern int kswapd_threads;
+extern int max_kswapd_threads;
 extern int min_free_kbytes;
 extern int defrag_mode;
 
 void setup_per_zone_wmarks(void);
+void update_kswapd_threads(void);
 void calculate_min_free_kbytes(void);
 int __meminit init_per_zone_wmark_min(void);
 
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 12fac9084c48..8c8da506ac50 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -277,6 +277,7 @@ int user_min_free_kbytes = -1;
 static int watermark_boost_factor __read_mostly = 15000;
 static int watermark_scale_factor = 10;
 int defrag_mode;
+int max_kswapd_threads = MAX_KSWAPD_THREADS;
 
 /* movable_zone is the "real" zone pages in ZONE_MOVABLE are taken from */
 int movable_zone;
@@ -6777,6 +6778,22 @@ static int min_free_kbytes_sysctl_handler(const struct ctl_table *table, int wri
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
@@ -6950,6 +6967,15 @@ static const struct ctl_table page_alloc_sysctl_table[] = {
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
index aa500ae9371a..37ce6860c215 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -181,6 +181,13 @@ struct scan_control {
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
@@ -7676,26 +7683,91 @@ unsigned long shrink_all_memory(unsigned long nr_to_reclaim)
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
 
@@ -7706,13 +7778,15 @@ void __meminit kswapd_run(int nid)
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


