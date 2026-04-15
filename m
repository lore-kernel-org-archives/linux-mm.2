Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A598CF41992
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 11:47:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 34EA36B008C; Wed, 15 Apr 2026 07:47:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B1646B0092; Wed, 15 Apr 2026 07:47:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1033C6B0093; Wed, 15 Apr 2026 07:47:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E7BF06B008C
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 07:47:04 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BE62DB91DB
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 11:47:04 +0000 (UTC)
X-FDA: 84660613968.06.4BC5443
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf11.hostedemail.com (Postfix) with ESMTP id BD90D40012
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 11:47:02 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of stepanov.anatoly@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=stepanov.anatoly@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776253623;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=I7Oa/p0wKQ6HeYYlLNj1f3mHKHQFXATVuHYf3nwieiA=;
	b=eg5akpmiAQCugfDJgBPL5jlvz4uxieoidblaTD5ESiWhZLXMPn3XbP8kknRv4CsUR7/QnJ
	/cph1DFjzl3vPsUG5gawGO2tMRkFaTZU2hBC/Jkq8p53YOogcgT0ptl37NvcIA3eAqVSm5
	kSa9Wc6WVB+9B4TzUNQSdLn0CcKpO2o=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of stepanov.anatoly@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=stepanov.anatoly@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776253623; a=rsa-sha256;
	cv=none;
	b=OsgkkLJ13kDgp0MFhnv3Pl8VYy3hSAN0r0tOxEmujbqF8iSc1ApIG6D20DZEIJY1pKE8fc
	/PvLzjzT0DsQp5t4SH50qJXtQc7gj+2JItAAHZu7M/sxXJkFXS7DE9VsIPJFgjJm3tuQ1w
	4tDqPRqjl08aLvK8oss6JvLlfRPswIY=
Received: from mail.maildlp.com (unknown [172.18.224.150])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4fwfW83RQ1zHnH79;
	Wed, 15 Apr 2026 19:46:44 +0800 (CST)
Received: from mscpeml500003.china.huawei.com (unknown [7.188.49.51])
	by mail.maildlp.com (Postfix) with ESMTPS id 733344056B;
	Wed, 15 Apr 2026 19:47:00 +0800 (CST)
Received: from localhost.localdomain (10.123.70.40) by
 mscpeml500003.china.huawei.com (7.188.49.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 15 Apr 2026 14:46:59 +0300
From: Anatoly Stepanov <stepanov.anatoly@huawei.com>
To: <willy@infradead.org>, <akpm@linux-foundation.org>, <david@kernel.org>,
	<ljs@kernel.org>, <Liam.Howlett@oracle.com>, <vbabka@kernel.org>,
	<rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>,
	<wangkefeng.wang@huawei.com>, <yanquanmin1@huawei.com>, <zuoze1@huawei.com>,
	<artem.kuzin@huawei.com>, <gutierrez.asier@huawei-partners.com>
CC: <linux-fsdevel@vger.kernel.org>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, Anatoly Stepanov
	<stepanov.anatoly@huawei.com>
Subject: [RFC PATCH 2/2] filemap: use high-order folios in filemap sync RA
Date: Thu, 16 Apr 2026 03:28:53 +0800
Message-ID: <20260415192853.3470423-3-stepanov.anatoly@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260415192853.3470423-1-stepanov.anatoly@huawei.com>
References: <20260415192853.3470423-1-stepanov.anatoly@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.123.70.40]
X-ClientProxiedBy: mscpeml500003.china.huawei.com (7.188.49.51) To
 mscpeml500003.china.huawei.com (7.188.49.51)
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: BD90D40012
X-Stat-Signature: t6gdusjo7yh48mpaa49k8ggijrh4kbht
X-Rspam-User: 
X-HE-Tag: 1776253622-864944
X-HE-Meta: U2FsdGVkX1/bd+sQoFf/NWxvcE8Bck2Zqbb+aYap7dSZGY24i4Y5f/MDLj7grkxuxcVqI199e91msIB7J05qMpyCFM6LBbWJQ0Na08ITyuW/8JDlKsFeaZbm513Wau9FHIrSONvapwqYSIlNtOlOCkJyhER9ZVpkJ5oKFwRwH3hvsCdeXZiixaAYa5Apo2Bfo4mpXGyEyKf5BV8qgp8CyOYnW0JZ6a0s3WLv0Kwmfo0Ng/Qt5lGWNbMDGXfWVhDGGXOPzxE3qADArzTJKTQAhN3ajz3cmWfz5po0p9Clfm+NM91pdhOv7emd7OANwCd8ABUGwfcAb7YxDdyRz/cQzbGH2pK8UDq0viJ82LBhD/Xrl1LZANat8DOEQr9nGlZORuGlsaakxIA/4Qwsax2z17yD4WmgU5hhRtZTj2zyePY1MvfVWUfXOsvdFZyTaUXYNU8BYnyWFEcuwtdhO2z8qu7uqVRXroHoyUzDMm1wAU1FdumCMLhDd7jFOqprenfZWE4gHpgwgvyeCUhkDygN56w4xf2GEb7n5s088srIqipwDB7t3h0PyCZWD8d9En8GdS5yAK00xaWjmGIEpO5sjJ6TfOsGzFNIITxMfMGpy32YMd7XpGnJobIVRf5Iu+f099Px3+p2L6Ur35Yc+JJ5DqoKnEg6StNdROiUFuC5KIUll/q9J6Ydd5I7hQNsXWHSUufZ569IhPMvbkA3rFcXx396xBD4OTtd2DpF95TmUV6ltRDO5KpfUL/9CrmpH3XRLY1u7MdeVocWCUgjLK5OF6+0oIS2v3GhdEJERUv/R6QjpFpy5973KUGG3MtbAWdU3rqRyfpykbjj57TD+DwH5B74jmYO/f8MRWf0bgAy0jctnlllqjRCzeVMkpfuAirJn3x243OoEgwJ09IJa21aJxSca5vcMvLaLKjsZCTjzsmtdlC8X3xcf5UmTXu2rhvgsHgmX3oryQnQC2mVNFp
 aHu7PxGN
 i0rmrwn296xsusICmOYRa/gxve5UBaMh3Eh0frE3mAQyt6xlXFWuHr4K33yn0ukmMANrFJn8K2NIMHgv5bnAVsr8j9FCcdE9N+xlW8oT4ZJlvqGrNX0CW8h7ZApYSofmuMLqyzYZQsgo1msh3zGGNZD1ChTxuX/9J+SfFIYRPXFkJ9jrAUZ2tuNVRmejPqTQmB5eG2ZOiDImZNo9yHeyGakiNYbsluVv3a0po
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

[Idea]

If a mmap'ed file being accessed such that async RA never
kicks in, we might end up with only 0-order folios in the page cache.

if fault_around_bytes is larger than 1 single page, then
it's beneficial to use high-order folios, which brings significant
filemap_map_pages() speedup.
So, let's just use fault_around_bytes as a starting point here.

if an arch supports PTE-coalescing we can get more of those for free.
(see arm64 example below)

We don't save the new order to "ra->order", so if async RA will happen
it would normally start from order-0.

[Things to be discussed]

But at the same time, i can see drawback for 16K, 64K pages, in this case fault_around will still be 64K by default.
In this case, it seems makes sense to make the fault_around_bytes be like order-N of PAGE_SIZE, not fixed bytes number.

Another issue is - when fault_around=0, but we'd like to use high-order folios for sync_RA, for cont-PTE for example,
For this we can use kind of "max(fault_around_order, cont_pte_order)".

Or introduce some dedicated tunable like "sync_mmap_order".

[Benchmark]

Simple benchmark below reading 100M file in 4M (RA size) chunks
such that async RA doesn't kick in and the page cache ends up being
filled up with 0-order folios.

The patched kernel gives ~3 times increase in throughput,
considering the page cache is filled up at the moment.

The main speedup comes from filemap_map_pages() due to high-order
folios usage.

As a bonus, we get better cont_pte bit coverage for Arm64.

Example:
// Open 100M file and read every 4M chunk, given max_ra=4M
// Perform 10 runs, measure the throughput.
...
 char *map = mmap(NULL, filesize, PROT_READ, MAP_PRIVATE, fd, 0);
    if (map == MAP_FAILED) {
        perror("Error mapping file");
        close(fd);
        return 1;
    }

    struct timespec start, end;
    clock_gettime(CLOCK_MONOTONIC, &start);

    unsigned int size_4M = 4*1024*1024;
    unsigned int num_reads = filesize / size_4M;
    volatile char val;
    for (int i = 0; i < num_reads; i++) {
        off_t offset = (off_t)i * size_4M;
        val = map[offset];
    }

    clock_gettime(CLOCK_MONOTONIC, &end);
...

Before patch (last 3 runs):
...
Throughput: 127942.68 operations per second
Throughput: 133646.96 operations per second
Throughput: 134321.94 operations per second

// filemap_map_pages(), fault_around_bytes = 64K
Time per 10 runs: ~2000 usec

// "smaps" numbers for the test file:
Rss:                1600 kB
Private_Clean:      1600 kB
Referenced:         1540 kB
ContPTE:	    0 kB

Patched kernel (last 3 runs):
...
Throughput: 366515.17 operations per second
Throughput: 404465.30 operations per second
Throughput: 370535.05 operations per second

// filemap_map_pages(), fault_around_bytes = 64K
Time per 10 runs: ~730 usec

// "smaps" numbers for the test file:
Rss:                1600 kB
Private_Clean:      1600 kB
Referenced:         1540 kB
ContPTE(Rss):       1536 kB

Signed-off-by: Anatoly Stepanov <stepanov.anatoly@huawei.com>
---
 include/linux/pagemap.h | 1 +
 mm/filemap.c            | 1 +
 mm/internal.h           | 1 +
 mm/memory.c             | 2 +-
 mm/readahead.c          | 5 +++--
 5 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index ec442af3f..e133a3a6b 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -1359,6 +1359,7 @@ struct readahead_control {
 	struct file *file;
 	struct address_space *mapping;
 	struct file_ra_state *ra;
+	unsigned int sync_mmap_order;
 /* private: use the readahead_* accessors instead */
 	pgoff_t _index;
 	unsigned int _nr_pages;
diff --git a/mm/filemap.c b/mm/filemap.c
index 406cef06b..1ed5a0688 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -3398,6 +3398,7 @@ static struct file *do_sync_mmap_readahead(struct vm_fault *vmf)
 		ra->size = ra->ra_pages;
 		ra->async_size = ra->ra_pages / 4;
 		ra->order = 0;
+		ractl.sync_mmap_order = __ffs(fault_around_pages);
 	}
 
 	fpin = maybe_unlock_mmap_for_io(vmf, fpin);
diff --git a/mm/internal.h b/mm/internal.h
index cb0af847d..96157c82b 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1770,4 +1770,5 @@ static inline int io_remap_pfn_range_complete(struct vm_area_struct *vma,
 	return remap_pfn_range_complete(vma, addr, pfn, size, prot);
 }
 
+extern unsigned long fault_around_pages;
 #endif	/* __MM_INTERNAL_H */
diff --git a/mm/memory.c b/mm/memory.c
index 2f815a34d..57ae027dd 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -5670,7 +5670,7 @@ vm_fault_t finish_fault(struct vm_fault *vmf)
 	return ret;
 }
 
-static unsigned long fault_around_pages __read_mostly =
+unsigned long fault_around_pages __read_mostly =
 	65536 >> PAGE_SHIFT;
 
 #ifdef CONFIG_DEBUG_FS
diff --git a/mm/readahead.c b/mm/readahead.c
index 7b05082c8..322bc115b 100644
--- a/mm/readahead.c
+++ b/mm/readahead.c
@@ -476,7 +476,7 @@ void page_cache_ra_order(struct readahead_control *ractl,
 	unsigned int nofs;
 	int err = 0;
 	gfp_t gfp = readahead_gfp_mask(mapping);
-	unsigned int new_order = ra->order;
+	unsigned int new_order = max(ra->order, ractl->sync_mmap_order);
 
 	trace_page_cache_ra_order(mapping->host, start, ra);
 	if (!mapping_large_folio_support(mapping)) {
@@ -490,7 +490,8 @@ void page_cache_ra_order(struct readahead_control *ractl,
 	new_order = min_t(unsigned int, new_order, ilog2(ra->size));
 	new_order = max(new_order, min_order);
 
-	ra->order = new_order;
+	if (ra->order >= ractl->sync_mmap_order)
+		ra->order = new_order;
 
 	/* See comment in page_cache_ra_unbounded() */
 	nofs = memalloc_nofs_save();
-- 
2.34.1


