Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2BE1AC531C9
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 05:43:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D01996B007B; Fri, 24 Jul 2026 01:43:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C8B5A6B0088; Fri, 24 Jul 2026 01:43:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B2E2F6B008A; Fri, 24 Jul 2026 01:43:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6EF976B007B
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 01:43:23 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C6B314022E
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 05:43:22 +0000 (UTC)
X-FDA: 85022577444.29.7337C95
Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	by imf05.hostedemail.com (Postfix) with ESMTP id 949E210000D
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 05:43:20 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZBlFDwU7;
	spf=pass (imf05.hostedemail.com: domain of cui.tao@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=cui.tao@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784871801;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=WN4Rv67wT+Zm0X2Y2iPxniSvUeDNwworrnfhHDaXBV4=;
	b=dtBM4NPt+MtIdStG5XOkHiA6h/p//3PHM/OxEKVFE2d6IW4KetltSwo5jRSjzb7WpjZy5L
	2TeiQQGHOuVeyeOwuTsudZxO8M5tLKMEqTnzIEq4Qi8CwR3KGaZynYK7bRiabvFY2SEm8V
	GaRxEpBY2xDV+8TzkZdOEqVnZ4tnNVc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784871801;
	b=vWpf8AHIGs/DyQId0cjW2Q3NZN1Y/S+USlknaeTybN+X/A/kJM6ro98MfZ8rQS6lKur9GJ
	UGr7Nn5lWtysr4e+fHJcvuikxZmMl4aHavwCxkGmhRXcixlgKYZl4X844LRND5ts9Z5l+B
	8yt6ITzojJ7gYuQOc6W5n11w5X1Aejo=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZBlFDwU7;
	spf=pass (imf05.hostedemail.com: domain of cui.tao@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=cui.tao@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784871798;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=WN4Rv67wT+Zm0X2Y2iPxniSvUeDNwworrnfhHDaXBV4=;
	b=ZBlFDwU7OC0cdAAWcB/mjlOKOY4b7AJDiYXymsXjb663Tc7xCo7hOAEjCz4k6kxhmxB3wX
	arUCaxdjP7a7k13aLHy84HaLlIxro5T3Lzz+yWoriwhsGwuDT4Yg1Fj+qJdcHhPBQ4RHwI
	312R+TNR6z1lo3R8Xp45LBDL3aXPoas=
From: Tao Cui <cui.tao@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	linux-kernel@vger.kernel.org,
	Tao Cui <cuitao@kylinos.cn>,
	cui.tao@linux.dev
Subject: [PATCH] mm/vmpressure: scale the vmpressure window with machine size
Date: Fri, 24 Jul 2026 13:43:05 +0800
Message-ID: <20260724054305.516126-1-cui.tao@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 949E210000D
X-Stat-Signature: gjnchmpf7knfr9bzqcd4sw5djoj83euz
X-HE-Tag: 1784871800-172453
X-HE-Meta: U2FsdGVkX19xHjhKymfBugEkwE4zVn0PWe9whVWl+T/Iun1qPzSik+IoU7IDeTcF0B8B2NCXoxGP9M5Yu3YoNyh+TnqUOchvN2XxH6An3MEecavj1M706eaBJ+bzZ1Eob/ZGzZZXszS1AxFK66jReInwQppHlzouHd+Hru38dsZ4N0ZfYKd/6txOZL2r5m7wNNi2d2o+TsQ++JqMxewqN8ITak5ann1yiM8891p9Ij7zwy7DvnKDqja9ZOPRy6TRqZMDV4igqFqNRy2srC8FQ2lLqtU2qFUvB6WEVlPQ3MQxzbvBW8mduQE7r1t2Rs29LbCz/7aglQIbqxH+nvySAVFSJCxthjvPwNjp3E2NpHWlx1VGQKX460ujv/KBPpO7dgXoznKf9pj/EHKjeS+gzYa3uZ9P7vzKfFNujnns5ncsN/TV7sCn9U6wBpyVTWujN7DuZ93tdeF4O6dJAyfxHE82DyNqm18jXBN9ypyZws2czw0SBSWKr+pqCoGFkl0UrQPG2p27MYVgO1Z4XKknm/nEEnIEGdsRjr6jracfICEukSHh/RMLl0jezqFSngMk+E8hiUHA0WZRILh+AUpex7VYtR7sxXT1SK764OLofJagghKHWs/CC8B630dybZti5rGgxd0Xvu+cr1zv5pgVvGSOIHbSJ/ZONPl8lH2dvXwhDEvexH0VH5J3l1F3Ghn7uL78LrXydCFmkVIzIdEHh4YrS8fJn/sh82zx8lEWs0Xf1VmiuwvvvLiS2cmkxbUXMld0xNg8nFoUhMPmjoTvxePJpFq6ztEjPICv3PkueOj/7y/8TrcG1Bm2XxSgjHkX/5oWb8tsoh2sD9uv6w4Gbr2iDGEsf+FAVoUA6NrjXzmSXkSHY3eShuI7lKzDvvQfTp5FyOjGL5eDgx7BYXO1KX43RgPhOayMxh3AxnRyhm1YK80hb4yU+yheCvSs6muC2Ag2FcTeazee/Y9C+nj
 YpXerOlb
 ycTnuGsvSZeJu73movRUJaLV/tAABRznWa0GL5VL3jNmUWVW3OM6BJ346WFKy5BuBihS/4zrDHzDjsuRoDzpQJW4EH6LTwI7fpnRBRlH2a/FZImKPUgAmrFr3iY4B/7lSK+DGDw/Lb/yhk6xjkIV6KHGaNLiYQomA4eo+wOhGDdrPctWgaPEgdSFcCAi7t0Mn94AVWlwFBxCJXuQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Tao Cui <cuitao@kylinos.cn>

vmpressure_win -- the number of pages the reclaimer must scan before
socket pressure is re-evaluated -- has been a fixed 512 pages (2 MB) since
vmpressure was introduced.  The reclaimer scans more pages on a larger
machine, so the window is reached far more often there and socket pressure
is re-armed every handful of scanned pages.  The comment at the definition
has asked for the window to scale with machine size "as we do for vmstat
thresholds" for over a decade.

Scale it the same way calculate_normal_threshold() does: logarithmically
with memory (fls of memory in 128 MB units), computed once in a
subsys_initcall once totalram_pages() is known.  A machine under 128 MB
keeps the historical 512 pages; the window then grows by SWAP_CLUSTER_MAX
* 16 per doubling of memory.

Why this matters: the scanned/reclaimed ratio that drives socket pressure
is averaged over the window, and the window rate-limits the evaluation.
With a fixed 2 MB window the evaluation runs the same number of times
regardless of machine size, which is disproportionately many on a large
machine.  Measured by cold-booting one VM at each size and running the
same cgroup-bound reclaim workload (so the page count is identical across
sizes):

    config   scaled_win   pages scanned   512-win evals   scaled evals
    4 GB     3072         11.9 M          23267           3877
    8 GB     3584         11.9 M          23306           3329
    16 GB    4096         11.9 M          23281           2910
    32 GB    4608         11.9 M          23268           2585
    64 GB    5120         11.9 M          23281           2328

For the same reclaim work the fixed window evaluates ~23k times at every
machine size; the scaled window evaluates fewer times the larger the
machine -- a 6x reduction at 4 GB growing to 10x at 64 GB (and the
logarithmic growth continues: ~11x projected at 128 GB).  Each evaluation
takes the per-memcg sr_lock and may write the socket_pressure seqlock, so
on larger machines with more memcgs under pressure this is real overhead
the fixed window pays needlessly.

The default stays 512 until the initcall runs, so early-boot reclaim is
unchanged.

Signed-off-by: Tao Cui <cuitao@kylinos.cn>
---
 include/linux/vmpressure.h |  2 +-
 mm/vmpressure.c            | 20 +++++++++++++++++---
 2 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/include/linux/vmpressure.h b/include/linux/vmpressure.h
index b4d13457bc2a..09111f5bdc88 100644
--- a/include/linux/vmpressure.h
+++ b/include/linux/vmpressure.h
@@ -51,7 +51,7 @@ extern struct vmpressure *memcg_to_vmpressure(struct mem_cgroup *memcg);
 extern struct mem_cgroup *vmpressure_to_memcg(struct vmpressure *vmpr);
 
 /* Shared with the v1 vmpressure block in mm/memcontrol-v1.c. */
-extern const unsigned long vmpressure_win;
+extern unsigned long vmpressure_win;
 extern enum vmpressure_levels vmpressure_calc_level(unsigned long scanned,
 						    unsigned long reclaimed);
 
diff --git a/mm/vmpressure.c b/mm/vmpressure.c
index 9629240d77ad..4c8671273c79 100644
--- a/mm/vmpressure.c
+++ b/mm/vmpressure.c
@@ -31,10 +31,24 @@
  * As the vmscan reclaimer logic works with chunks which are multiple of
  * SWAP_CLUSTER_MAX, it makes sense to use it for the window size as well.
  *
- * TODO: Make the window size depend on machine size, as we do for vmstat
- * thresholds. Currently we set it to 512 pages (2MB for 4KB pages).
+ * Scale the window with machine size, the way vmstat thresholds do: on a
+ * larger machine the reclaimer scans more pages, so a fixed window would
+ * re-evaluate pressure every handful of pages. The scaling is logarithmic
+ * (fls, like calculate_normal_threshold()), keeping the growth moderate.
+ * The default is the historical 512 pages; an early initcall applies the
+ * scaling once totalram_pages() is known.
  */
-const unsigned long vmpressure_win = SWAP_CLUSTER_MAX * 16;
+unsigned long vmpressure_win __read_mostly = SWAP_CLUSTER_MAX * 16;
+
+static int __init vmpressure_init_window(void)
+{
+	unsigned long mem128m;	/* machine memory in 128MB units */
+
+	mem128m = totalram_pages() >> (27 - PAGE_SHIFT);
+	vmpressure_win = SWAP_CLUSTER_MAX * 16 * (1 + fls(mem128m));
+	return 0;
+}
+subsys_initcall(vmpressure_init_window);
 
 /*
  * These thresholds are used when we account memory pressure through
-- 
2.43.0


