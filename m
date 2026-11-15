Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DBB8E606A327
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 02:46:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=126.com header.i=@126.com header.a=rsa-sha256 header.s=s110527 header.b=LsYG0WcT
Received: by kanga.kvack.org (Postfix)
	id BE5366B00EF; Sat, 14 Nov 2026 21:46:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BBB606B05B2; Sat, 14 Nov 2026 21:46:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD8B46B00EF; Sat, 14 Nov 2026 21:46:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7744A6B00EF
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 21:46:19 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4DE561A04DA
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 02:46:17 +0000 (UTC)
X-FDA: 85435814394.06.03D2585
Received: from m16.mail.126.com (m16.mail.126.com [117.135.210.8])
	by imf28.hostedemail.com (Postfix) with ESMTP id 58E70C0005
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 02:46:12 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=126.com header.s=s110527 header.b=LsYG0WcT;
	dmarc=fail reason="SPF not aligned (relaxed), DKIM not aligned (relaxed)" header.from=xiaomi.com (policy=quarantine);
	spf=pass (imf28.hostedemail.com: domain of nzzhao@126.com designates 117.135.210.8 as permitted sender) smtp.mailfrom=nzzhao@126.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794710775;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=xOzrbckJJcWh/pB8wxs7WLkmsYb8n7B8H0ZwNaayh7s=;
	b=aosRP4yfkn2CLEoIES4w+4ZNekGU0MfQgWHPyVkMIvvd+KINE/vpQOFi8KzzX5UPQ8W8dx
	30AH1qj3oMeTEzxhA1vRciSMKwkrTbmqC2SwmhdsSQKFhU0u+EMB3Un+VBRS0gzCTBPdSC
	Fxkk/IpNWTc4dnKgoeiOq56ZtvW/+Uk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794710775;
	b=ai8W/wDV9jSq5sFTNCB3XVCZmyDSM2r3uP2Boamnu4+Zg70FXGhcFo0zDSxuDxrk5whLPQ
	1wtJwprkLwQMmGTvTCkJOLynrWIh6qH7n1KdZ/zMJ8XcSwsQd3ZoTEdEm5kfummjk3E5i6
	DGiQ8E5psKE5blUXI5c4eUk1agvhdQk=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=126.com header.s=s110527 header.b=LsYG0WcT;
	dmarc=fail reason="SPF not aligned (relaxed), DKIM not aligned (relaxed)" header.from=xiaomi.com (policy=quarantine);
	spf=pass (imf28.hostedemail.com: domain of nzzhao@126.com designates 117.135.210.8 as permitted sender) smtp.mailfrom=nzzhao@126.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=xO
	zrbckJJcWh/pB8wxs7WLkmsYb8n7B8H0ZwNaayh7s=; b=LsYG0WcTGpFFEaj51w
	hx5+0yDbIhj1b9nLpCnXMGUFydIl67wncWDCWhaAWnYq4lkb5ZUKoQ6NEND2Khvt
	9frOsPnsa3M+Lk/1a5DTXZ0N2jwuhaZdLYeH9QUDnlp6qpAh5TSHCiOtQq20YpUK
	EmWzwXJcFREKNJeGC7/qp1BoU=
Received: from nzzhao-ThinkCentre-M760t.mioffice.cn (unknown [])
	by gzsmtp3 (Coremail) with SMTP id PikvCgD3H_OtHPlq+ob+DQ--.31738S2;
	Sun, 15 Nov 2026 10:45:03 +0800 (CST)
From: Nanzhe Zhao <zhaonanzhe@xiaomi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Nanzhe Zhao <zhaonanzhe@xiaomi.com>,
	linux-mm@kvack.org,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Minchan Kim <minchan@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Usama Arif <usama.arif@linux.dev>,
	Yosry Ahmed <yosry@kernel.org>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Chris Li <chrisl@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Ying Huang <ying.huang@intel.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Kanchana P Sridhar <kanchana.p.sridhar@intel.com>,
	Wajdi K Feghali <wajdi.k.feghali@intel.com>,
	Bala Seshasayee <bala.seshasayee@linux.intel.com>,
	Nick Terrell <terrelln@fb.com>,
	Barry Song <baohua@kernel.org>,
	Tangquan Zheng <zhengtangquan@oppo.com>,
	Bo Zhang <zhangbo56@xiaomi.com>
Subject: [RFC PATCH v4 0/4] mTHP-friendly compression in zsmalloc and zram based on multi-pages
Date: Sun, 15 Nov 2026 10:44:47 +0800
Message-ID: <20261115024455.1465726-1-zhaonanzhe@xiaomi.com>
X-Mailer: git-send-email 2.43.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PikvCgD3H_OtHPlq+ob+DQ--.31738S2
X-Coremail-Antispam: 1Uf129KBjvJXoW3WF1xGrW8Zr13GF15ur17ZFb_yoW3trW3pa
	yag3sxCF18ZFW7Arn7Cws2kryfG3yxXrW5Ga4Sgr10kFy5JF1IvF4DKF98XayUurs3WF47
	Zr45Gr1ruF1jvaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jIZXOUUUUU=
X-CM-SenderInfo: xq22xtbr6rjloofrz/xtbBsQ9LG2r5HK8qAAAA3k
X-Stat-Signature: m8yyhe1gpp6zq4my7iipxoya3kiaxkx8
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Pre-Result: action=add header;
	module=dmarc;
	Action set by DMARC
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 58E70C0005
X-Rspam: Yes
X-HE-Tag: 1794710772-857473
X-HE-Meta: U2FsdGVkX18GEPXxrvqSHJGw7HbBBxylb/sovhYVrMmhsphXr949wzA1dKm/+I3A0n7ghJmrqZV0TMgAgyLiThge92RhShnDr1rMCvhSjJwhn4j89eNImiePE217d+FxE8Tjzo6SnrO5J+L5DA0FHYa13JeqrTA13jbdBxjfnJeLZBs49rJawZI4Dk8SBbftCyp5PTKBIzQmdsWvlt4y+Z1+2aSggJx/7B1koE0yyF6SHR66sa+S7ARWsXU887LBzJwbgLSvpIFme0s+7I3Te8p8iPNkDMtYgc9CYYQFv01lrY6KwLzcVk9sbG0dbEGKbtNXpKYn80zPNrkBKISsOya4azoIs0VGjF/REJarGBPvp8wlZxwbsiZaAm9qyBBnP6y11qmrhmj7yqOgNstl9wjSrm1jBlT6AwPFARhXUOuXiJqREncZu4YFUYQ89KR3N/GH31aZAoeMq5dPqintZci2fiXZscMT97nLD2wfVaVEy0/fF3fE4SUJ08ypWVIk3JksGBVUWX9XD7uUE/Uqjwj6Lub2cqDb71gJlrqCcmM3WJWIRGqsRluxRVV+6RJLODYDW0kYAgLkuxepotbbtv+15SbBdmoggGBMn7wO4GrsYD+85Nu4S6dyiPPNMzbAap8JnqLRm6EOX8htj5VVIKdanCd2nTUYnsaFJSsRb4fJyM0fovf5szOmlyq5HiRNde36xM5UBYp+Th6fs5mysUqrm+vadtGqm9XjCNKcjIaXPBqMdyQJzyiY0jJjrJvRNY6fv5PHGn8U8IdBonaohRWW8nYNYgCJUx2afdx07AmLv+deeFbTr65B+Ka94Mkrj81w+zzFAJ9pBgjb9YnHvnYF19rKQV6cjwcrxc9/3OtGnqEhGTuap3r8bvjnvQT2RdYtuhBXP5RE71cPfGhPEUCwLHC08TF3CrHpx8JofI9rnpuhmUWMeXq207Wt+V2QNuySID3lALZisZR8fQQ
 ZklFF0cj
 99DOcyda950qOv2uLKmBQkV523x65trAjt3nXqEicgpTBSHopamEiXEvdIKFWei2V5RwIvgv7D0g9pspS8IrCPGHs14dBinOyu6mVGxgG+NAJ1rw1dS/lh9UXo6iw+dtlRUGHBZ91Ebytwe3AvK+K5O0g+MzlzG2ifaRU+x6iVF6C1qnKedyQ+nbvUo1FwG4Fqn/wMOCE4B+05/RCiEdCySfXohJDpY7zcNs/XjTerJPVdocmZTiIT7KRb55rEDQrrfcZCGkCqLEOe+MEYz30WKxgkEoLMJ3GrTCLvD/72L2vROry1t50iIAx5LJiSP8RGY71FdfCFTPG6d4ANgzgB8yWzx5ZBTNxC5p3rwDFOfq8t8fBQnaPbUxTMW7gnZFLa7CYmUedTss1Ykuu1C4z60RJT6fCjPDAfKO3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

When large folios are compressed at a larger granularity, we observe
a notable reduction in CPU usage and a significant improvement in
compression ratios.

mTHP's ability to be swapped out without splitting and swapped back in
as a whole allows compression and decompression at larger granularities.

This patchset enhances zsmalloc and zram by adding support for dividing
large folios into multi-page blocks, typically configured with a
2-order granularity. Without this patchset, a large folio is always
divided into nr_pages 4KiB blocks.

The granularity can be set using the ZSMALLOC_MULTI_PAGES_ORDER
setting, where the default of 2 allows all anonymous THP to benefit.

Examples include:
* A 16KiB large folio will be compressed and stored as a single 16KiB
  block.
* A 64KiB large folio will be compressed and stored as four 16KiB
  blocks.

We captured anonymous pages from four Android applications on a Pixel 6.
To evaluate throughput, we allocate a buffer via mmap(MAP_PRIVATE |
MAP_ANONYMOUS), populate it with the captured pages, and invoke
madvise(MADV_PAGEOUT) to swap the buffer out to zram, measuring the
pageout duration. We then sequentially touch every 4 KiB page to fault
them back in from zram, measuring the swapin duration.

For example, testing the 143 MiB WeChat corpus (times in seconds;
w/o: without the patch, w/: with the patch):

Algorithm  pageout w/o (s)  pageout w/            swapin w/o (s)  swapin w/
lz4        0.247            0.210 (-14.8%)        0.137           0.113 (-17.6%)
lzo-rle    0.240            0.207 (-13.7%)        0.149           0.123 (-17.5%)
zstd       0.567            0.452 (-20.4%)        0.258           0.192 (-25.6%)

v3 left two issues to discuss:

The first issue is internal fragmentation. A compressed 16 KiB block
is rounded up to the next size-class boundary. If it lands in a class
with a large gap, the gap becomes per-object padding.

On all four applications, unused pages in partially filled zspages
increase by ~1.8 to 2.4 MiB, and the per-object class gap is wider.
However, because the number of allocated objects drops by ~74% (from
four 4 KiB objects to one 16 KiB object), total rounding waste
actually falls by 13% to 31%. Combined with 5% to 15% better
compression ratios from multi-page compression, total zsmalloc memory
occupancy (mem_used_total) is reduced across all applications.

For example, below is the memory breakdown under lz4 for our four apps
(lzo-rle and zstd show the same trend, saving 3.8% to 9.3% total memory):

App          objects (w/o -> w/)        rounding waste (MiB)    unused pages (MiB)      mem_used_total (MiB)
WPS          27,530 ->  7,285 (-73.5%)  0.80 -> 0.56 (-29.8%)   1.07 -> 3.35 (+214.0%)   36.4 ->  34.9 (-4.0%)
WeChat       32,460 ->  8,450 (-74.0%)  0.89 -> 0.62 (-30.6%)   1.35 -> 3.32 (+145.8%)   42.8 ->  40.0 (-6.7%)
Douyin lite  62,668 -> 16,218 (-74.1%)  2.07 -> 1.61 (-22.3%)   1.37 -> 3.78 (+176.0%)  100.8 ->  93.6 (-7.1%)
JK chess     71,950 -> 18,584 (-74.2%)  1.75 -> 1.52 (-13.0%)   1.43 -> 3.28 (+129.7%)  117.0 -> 112.7 (-3.6%)

Here, objects is obj_allocated, rounding waste is total class padding
across all objects, unused pages is memory left in partially filled
zspages, and mem_used_total is the total memory allocated by zsmalloc
(including fragmentation and metadata).

We also built a 256 MiB lz4 synthetic extreme case: 16 KiB blocks with
the first K bytes random and the rest zero, with K tuned so the object
lands one byte above the previous class. Below is the code to generate
this pattern:

#define BLOCK 16384

static void make_block(unsigned char *buf, size_t k)
{
	size_t i;

	for (i = 0; i < k; i++)
		buf[i] = rand();
	memset(buf + k, 0, BLOCK - k);
}

static void write_corpus(int fd, size_t k, size_t nblocks)
{
	unsigned char *buf = malloc(BLOCK);
	size_t i;

	make_block(buf, k);
	for (i = 0; i < nblocks; i++)
		write(fd, buf, BLOCK);
}

With the default CONFIG_ZSMALLOC_CHAIN_SIZE=8, the largest non-huge
class gap is 576 bytes. Setting K to 10,781 bytes lands the object in
class 11,456 with a 575 B/object padding, increasing total memory by
5.0% over the baseline without the patch (179.3 MiB vs 170.7 MiB).

With CONFIG_ZSMALLOC_CHAIN_SIZE=10, the classes are denser and the
largest gap drops to 448 bytes. At K=10,781 bytes, the memory overhead
falls to 3.9% (177.3 MiB vs 170.7 MiB).

A potential future optimization is during size-class merging: we can
avoid merging classes if the resulting gap exceeds a threshold (e.g.
ZS_MAX_MERGE_GAP = 256 bytes), for example:

--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ can_merge() @@
+#define ZS_MAX_MERGE_GAP	256
+
+	if (prev->size - size > ZS_MAX_MERGE_GAP)
+		return false;
+
 	if (prev->zpdescs_per_zspage == zpdescs_per_zspage &&
 		prev->objs_per_zspage == objs_per_zspage)
 		return true;

The second issue is partial read. If the order-2 allocation for the
swapped-in folio fails and falls back to order-0, we must decompress
the entire 16 KiB block just for a 4 KiB swapin.

v3's 4/4 ("mm: fall back to four small folios if mTHP allocation
fails") handled this by building four small folios. Usama asked whether
defrag=always could replace this patch. But we only need direct reclaim
for the do_swap_page order-2 allocation; otherwise all anonymous mTHP
allocations would enter direct reclaim. So the new 4/4 adds
__GFP_RECLAIM to the order-2 swapin allocation in do_swap_page().

We measured the cost of entering direct reclaim in the swapin path on
an i7-14700HX with no_turbo=1: a 1 GiB memcg, zram (zstd), 16 KiB mTHP,
and an arm64 defconfig vmlinux build with -j20 in the background. The
bench was pinned to one CPU and the build to the rest. We compared
forcing direct reclaim with the existing behavior, 10 totals per case,
each total 30 rounds of 100 MiB anonymous pageout/swapin.

#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <sys/mman.h>
#include <time.h>

static double now(void)
{
	struct timespec ts;

	clock_gettime(CLOCK_MONOTONIC, &ts);
	return ts.tv_sec + ts.tv_nsec / 1e9;
}

int main(void)
{
	const size_t size = 100UL << 20;
	unsigned long *p, sum = 0;
	size_t i, off;
	double t0, t1;

	p = mmap(NULL, size, PROT_READ | PROT_WRITE,
		 MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
	if (p == MAP_FAILED) {
		perror("mmap");
		return 1;
	}

	for (i = 0; i < size / sizeof(*p); i++)
		p[i] = i & 0xfff;

	t0 = now();
	if (madvise(p, size, MADV_PAGEOUT)) {
		perror("madvise(MADV_PAGEOUT)");
		return 1;
	}
	t1 = now();
	printf("pageout %.6f\n", t1 - t0);

	t0 = now();
	for (off = 0; off < size; off += 4096)
		sum += *(volatile unsigned long *)((char *)p + off);
	t1 = now();
	printf("swapin %.6f sum %lu\n", t1 - t0, sum);

	return 0;
}

                         w/o DR          DR
partial reads            235,832         218
swapin total (s)         24.85 +/- 0.56    22.80 +/- 0.73
pswpout (pages)          11.4M           11.3M

Here, partial reads is the zram_bio_read_multi_pages_partial counter.
The direct-reclaim case did not show a measurable cost. Almost all
partial decompressions were eliminated, making swapin 8.3% faster.

-v4:
 * Rebased onto latest akpm mm-new.
 * Patch 1: Fixed multi-page page accounting (NR_ZSPAGES, zs_compact,
   and debugfs) to use physical pages via class_pages_per_zspage().
 * Patch 2: Adapted to upstream's new zcomp read/write stream separation;
   added a preallocated decomp_buf in zcomp_dstrm for partial reads to
   avoid memory allocation in the swapin path.
 * Patch 3: Updated zstd backend to pass ZCOMP_MULTI_PAGES_SIZE to
   zstd_setup_params().
 * Patch 4: Dropped v3's 4/4 fallback and added a new patch to allow
   direct reclaim for synchronous multi-page swapin.

[1] v3: https://lore.kernel.org/all/20241121222521.83458-1-21cnbao@gmail.com/

Barry Song (1):
  zram: backend_zstd: use multi-page size for zstd parameter setup

Nanzhe Zhao (1):
  mm: swap: allow direct reclaim for synchronous multi-page swapin

Tangquan Zheng (2):
  mm: zsmalloc: support objects compressed based on multiple pages
  zram: support compression at the granularity of multi-pages

 drivers/block/zram/Kconfig        |   9 +
 drivers/block/zram/backend_zstd.c |   4 +-
 drivers/block/zram/zcomp.c        |  31 +-
 drivers/block/zram/zcomp.h        |  19 +-
 drivers/block/zram/zram_drv.c     | 499 +++++++++++++++++++++++++++---
 drivers/block/zram/zram_drv.h     |  43 +++
 include/linux/zsmalloc.h          |  10 +-
 mm/Kconfig                        |  29 +-
 mm/swap_state.c                   |   7 +
 mm/zsmalloc.c                     | 242 ++++++++++-----
 10 files changed, 757 insertions(+), 136 deletions(-)

-- 
2.43.0


