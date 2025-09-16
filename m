Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3BB04CAC599
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 16:02:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 946E68E0025; Tue, 16 Sep 2025 12:02:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F7318E0001; Tue, 16 Sep 2025 12:02:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E6248E0025; Tue, 16 Sep 2025 12:02:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 683568E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 12:02:41 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 269E016022B
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 16:02:41 +0000 (UTC)
X-FDA: 83895581322.17.1509880
Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	by imf01.hostedemail.com (Postfix) with ESMTP id 293E74000D
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 16:02:39 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ciViJbes;
	spf=pass (imf01.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.222.175 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758038559;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pkwwb9fXA+gLzNSIgeAnWPrfVwxN4Hwjf/rN/U/6eIw=;
	b=wMUALFzU+ZEeqdKuNMMEmV8iiAHinwGXOKvXT7abAigRpzwLUlaYFpA3u91Gg+t3hNORQm
	XFxGyGbxMofCm5utYjcmaxlqvjiltoFWcXl4IvtS1Ub5NkFyVNvsurnLj5Q4mBI96mZtba
	xwN6XtLzXdML2lovTeT53iw4lnqm2hI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758038559; a=rsa-sha256;
	cv=none;
	b=symNTq75d9Rc8PTsTUynSNWGUdUIw5vs9w4KNOMtYx3R+ILNIfBPGtp0P+jA6MPKH94CAD
	TBZkHWKUH0LgfRU526y0wDzNj6KDzTY6Q67utcvtpPHyOotU7WHSgzXdXyRSkOWVQtxlcD
	bH6l+b4qVR64uJ8FrjgbcrBGpMiKy4U=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ciViJbes;
	spf=pass (imf01.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.222.175 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-826fe3b3e2bso360744585a.0
        for <linux-mm@kvack.org>; Tue, 16 Sep 2025 09:02:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758038558; x=1758643358; darn=kvack.org;
        h=content-transfer-encoding:mime-version:reply-to:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to;
        bh=pkwwb9fXA+gLzNSIgeAnWPrfVwxN4Hwjf/rN/U/6eIw=;
        b=ciViJbesD+mUUu7LWgShqtp2TXLHbrgu3GIB6RKMk9v7hsCqWkIEFqJY8/TggWEtuL
         ANVdodVCLPjrL5Mj8esCLZLbOLBDgjys/caxW/RhRRzd/leQKd5gUSDODmOeyas5V9Mt
         WX+tQEf2z8Nhnl1k2fQlquIpi3foyQnnSX/AeVtpmse0x5lRBFsJ2KXJcghY2lEZiPXQ
         Awav3r+o38mbj1Iq06dDlV95Ns4u8HndEXOHHueSo3cHuB2GD00djlA4haO6Oq2MQTWn
         EUvsKG+odFJZE8LZXCpx/mPNyrO5BITDO9izOwYdt+X9VxmB+U3UofvQOlufP7wEdZWH
         QuCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758038558; x=1758643358;
        h=content-transfer-encoding:mime-version:reply-to:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pkwwb9fXA+gLzNSIgeAnWPrfVwxN4Hwjf/rN/U/6eIw=;
        b=rUO8CqSnNNK9xWElUlG1RIzinCkmL+PmJG2OXTDjWTny3nMstAbM0Ch0A1o9Ej/Ze5
         QacLjoBapCCp1L9oWWYrLO2ySHM7J7MY6uiBGqmCEuZYoIG5tz/JpS1fON6ZGpbqIULo
         A5RYKIl8EPuUpCzcLWFASbEmq1gObHIbWctmU0yM3LFTplHOClmENUbVIQamaF1Y0onr
         LaEBQIrX780LHiUF6vbVXobo3HesWBgiPi++S+TPqF3mlw6qNOEv2gmzMQXKorULVH9z
         MhcNTfpIVj9m5hO4k+GxCciZEC4PTo0fubn9QvnYw1aXXS/TTVf0odDnVAoPFV5WLGgc
         iuVA==
X-Gm-Message-State: AOJu0YwRzF+22wD6asQn06Y5o2wkQ4kqIipAsvVV/+FHLsXh0gD3r8sv
	zNIDM9LoBYQaCJmK5onFgN91RY5MrtkH9PRyiQ0McyNJStqFBkcKlPflLvv+UMRVnKU=
X-Gm-Gg: ASbGncth5EHx1+2uSQJWqblGkq+QPrf0vkhWlCb1qriLBSoE4vDY7fIW3a3xvMwEuJh
	pTq5+7OPEXEAESmY9WAHkX7IK5ErRhz4PrkykT/+cdvuLZ19xe0CGRYtKwFMldF5wWW2izxNEcu
	Wd3sqpo9v6XDMR6urQtgWRso7F1643T8g5Dd6MN8L2xjJFTKX1cTl00dFun4vJFXzliihHrsgIc
	sjGDBQd6Tad93k7mRB2NAPOr9KDSDji/w1ByolYTbGVIJfLqivmKJUFjULQ9gcYFL4tSdbSiqwv
	qd9RCUet7CxEKSf3oQyKisPLPZmts/R8QHiXtARG5+vwDrvHbykWOGDSMWz1nOSGTgZK/ncXeV0
	Xfdv6ezoMNfMo8gjyqSj5il7caKJ3G/GcnPVKe+0G3l/9Mdo=
X-Google-Smtp-Source: AGHT+IF8fLd2lfO76mR7R/AGarFeTdp4W9G3W6ewW3fPGy6m/l7ACES3YArLw4+tmP3lQvR1ygglaQ==
X-Received: by 2002:a05:620a:a48d:b0:811:bc35:7016 with SMTP id af79cd13be357-82400753708mr2020881185a.58.1758038557353;
        Tue, 16 Sep 2025 09:02:37 -0700 (PDT)
Received: from KASONG-MC4.tencent.com ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-820cd703f54sm969765485a.37.2025.09.16.09.02.30
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 16 Sep 2025 09:02:36 -0700 (PDT)
From: Kairui Song <ryncsn@gmail.com>
To: linux-mm@kvack.org
Cc: Kairui Song <ryncsn@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Matthew Wilcox <willy@infradead.org>,
	Hugh Dickins <hughd@google.com>,
	Chris Li <chrisl@kernel.org>,
	Barry Song <baohua@kernel.org>,
	Baoquan He <bhe@redhat.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@redhat.com>,
	Yosry Ahmed <yosryahmed@google.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org,
	Kairui Song <kasong@tencent.com>,
	kernel test robot <oliver.sang@intel.com>
Subject: [PATCH v4 13/15] mm, swap: remove contention workaround for swap cache
Date: Wed, 17 Sep 2025 00:00:58 +0800
Message-ID: <20250916160100.31545-14-ryncsn@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250916160100.31545-1-ryncsn@gmail.com>
References: <20250916160100.31545-1-ryncsn@gmail.com>
Reply-To: Kairui Song <ryncsn@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: m3n9e1asmd7945ia4oc84idkdnu4bopq
X-Rspam-User: 
X-Rspamd-Queue-Id: 293E74000D
X-Rspamd-Server: rspam10
X-HE-Tag: 1758038559-37065
X-HE-Meta: U2FsdGVkX19daFeojC4KYUtv5YkSOaMkiWh4n8LFfuW9SUM73HfsvbZMgJbgyyHDxxXhv20z8GDlW0pWfvT1q/biFpQDBb4vIok5HR7PE3Rn6EZGMN3ABblolw43UZBNeg9H1xieYOGWkoaNhec2AOZLG2BcVEOfRAAYfSK53WOPgkN7ErVHun8CUVpBlW9vKH7FG4AiDYz9DWOvgfntuEqx0xMfrNjquzgj4YZJtR2LVoqwH50nN7tSyiqKikkaaniKJN4WaC7NzWVPBURadizyBOWTXUNhsolhXAGXe5UlP+T5MTM9zPhWmxXgdlzt6gEXb+BNK9YxNncOAQ58pivZ7Xf76MrNda4BpMmMKjBzzZGt/cvVsPsY/7+1gRsRYNvN1UsribWQn5klPpBDY0HxTWsY7eZtIKRSTCqODY/s6q7TJ9eccP+P3XURAQ1YHT3BucFnVIhx0MrBMfkcd1qTwmqVVXfReNDk64Y1xl3DToaOWR1m73jJV3VsUuTf8svOG1NQKaPQMkAlZQq9vqzwlkS5Y84SYj+lInTcSl5DyAg4YVjLpALDVxaerCISeeVLvtPiBB9ARucZWMbvZLZlg2IM8C9XcGF3uL9MMUaMgnsvepmIPnUt5RgDseUiPFsemkgIlVHmiihdV5pg49OSX0Ht7ZHe08WUwOARbWYu1PVTToaIHZ8xILtfxvdrWpeGLHwJMqPNMNkFMrxZ/ln1iS3pYs/4I3LPYoOvQVkz3CYRS0JhuwrvQyDmgNVgzv/+PYysKQPGCjnyVsRljpmAuxU4k6eaiKxZGkzu+p6wb3atiS1AOfbMw38Ul9h5JmRAwb/7+QMaBXGAsCEaDaXtnifFWCz20znhaGosnUC0orkMnbZNLt3eDnCpE0HwLOqo0hRgwbrMrK7/jCdlNCU4BbXYXHuvrkbI1DE1p9PIt3La72l3WR3DNnxV+M8vpZB41VbP858fY+6Jrx2
 9Tl02cVa
 yAmq/0gY288A179JJaocSPTwUO4nVvNkM37KlNXVxku/bkaJKi2rMbO2c42f+mFj0doXEiOkV6vQykfnWsl92tPGDg3L4SeBTo4UIQW+9fKP8KGI1H2bjo8NGU0XhBq3sLUNPgAS4ghIg6ShS1ob+JkODGUHCnCgKP/oXNmsJQ44NgJ7Rd+TZriPPfbpdny7n6HsisHAdkxCF3D/VJis03maD400vCYTVy4UdDC90enL1Rej/7CpYE3S3MjYi+LOlaaDXDEHaGTKW91Exwdq7YMsluqbxYztTdZYjq35jt/EBM1IV31Zv7ZcuPOoItN89dTYrPII0IBR270rXc918vvEGi9mjrYNIEPpNBoBdoH3BGNjSGphF9R0dbd8nHBORftYMOynixqnI314B97RDOOmmAuz81rur6ynQk2wRgoVXZnnkXTgNOkzoUlHJXxBsrR4da086umXCnIUf2VMbdrHReapCigWa72hLaIw0BhGfPXXMY7T9eo1pvL51cj+K0j/39UmAUVO2DhfMecpyhrpZwAi0bvy+7os+qh5ACzEiefhcEDnmtRBPFFzXUDFeXhkkswdVkNMRSGiTwHNr5aIVDy9hjP0lX3wwM+5QohtFUcc1bfALE5KeCs+6LGZ80LYCpY1gwlNHn5BDiIsptGaGs0QXdNQp/bloBh+maTbCWRRYKggj4z8DLA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Swap cluster setup will try to shuffle the clusters on initialization.
It was helpful to avoid contention for the swap cache space. The cluster
size (2M) was much smaller than each swap cache space (64M), so
shuffling the cluster means the allocator will try to allocate swap
slots that are in different swap cache spaces for each CPU, reducing the
chance of two CPUs using the same swap cache space, and hence reducing
the contention.

Now, swap cache is managed by swap clusters, this shuffle is pointless.
Just remove it, and clean up related macros.

This also improves the HDD swap performance as shuffling IO is a bad
idea for HDD, and now the shuffling is gone. Test have shown a ~40%
performance gain for HDD [1]:

Doing sequential swap in of 8G data using 8 processes with usemem,
average of 3 test runs:

Before: 1270.91 KB/s per process
After:  1849.54 KB/s per process

Link: https://lore.kernel.org/linux-mm/CAMgjq7AdauQ8=X0zeih2r21QoV=-WWj1hyBxLWRzq74n-C=-Ng@mail.gmail.com/ [1]
Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202504241621.f27743ec-lkp@intel.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Acked-by: Chris Li <chrisl@kernel.org>
Reviewed-by: Barry Song <baohua@kernel.org>
Acked-by: David Hildenbrand <david@redhat.com>
---
 mm/swap.h     |  4 ----
 mm/swapfile.c | 32 ++++++++------------------------
 mm/zswap.c    |  7 +++++--
 3 files changed, 13 insertions(+), 30 deletions(-)

diff --git a/mm/swap.h b/mm/swap.h
index adcd85fa8538..fe5c20922082 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -198,10 +198,6 @@ int swap_writeout(struct folio *folio, struct swap_iocb **swap_plug);
 void __swap_writepage(struct folio *folio, struct swap_iocb **swap_plug);
 
 /* linux/mm/swap_state.c */
-/* One swap address space for each 64M swap space */
-#define SWAP_ADDRESS_SPACE_SHIFT	14
-#define SWAP_ADDRESS_SPACE_PAGES	(1 << SWAP_ADDRESS_SPACE_SHIFT)
-#define SWAP_ADDRESS_SPACE_MASK		(SWAP_ADDRESS_SPACE_PAGES - 1)
 extern struct address_space swap_space __ro_after_init;
 static inline struct address_space *swap_address_space(swp_entry_t entry)
 {
diff --git a/mm/swapfile.c b/mm/swapfile.c
index b183e96be289..314c5c10d3bd 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -3204,21 +3204,14 @@ static int setup_swap_map(struct swap_info_struct *si,
 	return 0;
 }
 
-#define SWAP_CLUSTER_INFO_COLS						\
-	DIV_ROUND_UP(L1_CACHE_BYTES, sizeof(struct swap_cluster_info))
-#define SWAP_CLUSTER_SPACE_COLS						\
-	DIV_ROUND_UP(SWAP_ADDRESS_SPACE_PAGES, SWAPFILE_CLUSTER)
-#define SWAP_CLUSTER_COLS						\
-	max_t(unsigned int, SWAP_CLUSTER_INFO_COLS, SWAP_CLUSTER_SPACE_COLS)
-
 static struct swap_cluster_info *setup_clusters(struct swap_info_struct *si,
 						union swap_header *swap_header,
 						unsigned long maxpages)
 {
 	unsigned long nr_clusters = DIV_ROUND_UP(maxpages, SWAPFILE_CLUSTER);
 	struct swap_cluster_info *cluster_info;
-	unsigned long i, j, idx;
 	int err = -ENOMEM;
+	unsigned long i;
 
 	cluster_info = kvcalloc(nr_clusters, sizeof(*cluster_info), GFP_KERNEL);
 	if (!cluster_info)
@@ -3267,22 +3260,13 @@ static struct swap_cluster_info *setup_clusters(struct swap_info_struct *si,
 		INIT_LIST_HEAD(&si->frag_clusters[i]);
 	}
 
-	/*
-	 * Reduce false cache line sharing between cluster_info and
-	 * sharing same address space.
-	 */
-	for (j = 0; j < SWAP_CLUSTER_COLS; j++) {
-		for (i = 0; i < DIV_ROUND_UP(nr_clusters, SWAP_CLUSTER_COLS); i++) {
-			struct swap_cluster_info *ci;
-			idx = i * SWAP_CLUSTER_COLS + j;
-			ci = cluster_info + idx;
-			if (idx >= nr_clusters)
-				continue;
-			if (ci->count) {
-				ci->flags = CLUSTER_FLAG_NONFULL;
-				list_add_tail(&ci->list, &si->nonfull_clusters[0]);
-				continue;
-			}
+	for (i = 0; i < nr_clusters; i++) {
+		struct swap_cluster_info *ci = &cluster_info[i];
+
+		if (ci->count) {
+			ci->flags = CLUSTER_FLAG_NONFULL;
+			list_add_tail(&ci->list, &si->nonfull_clusters[0]);
+		} else {
 			ci->flags = CLUSTER_FLAG_FREE;
 			list_add_tail(&ci->list, &si->free_clusters);
 		}
diff --git a/mm/zswap.c b/mm/zswap.c
index 1b1edecde6a7..c1af782e54ec 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -225,10 +225,13 @@ static bool zswap_has_pool;
 * helpers and fwd declarations
 **********************************/
 
+/* One swap address space for each 64M swap space */
+#define ZSWAP_ADDRESS_SPACE_SHIFT 14
+#define ZSWAP_ADDRESS_SPACE_PAGES (1 << ZSWAP_ADDRESS_SPACE_SHIFT)
 static inline struct xarray *swap_zswap_tree(swp_entry_t swp)
 {
 	return &zswap_trees[swp_type(swp)][swp_offset(swp)
-		>> SWAP_ADDRESS_SPACE_SHIFT];
+		>> ZSWAP_ADDRESS_SPACE_SHIFT];
 }
 
 #define zswap_pool_debug(msg, p)			\
@@ -1674,7 +1677,7 @@ int zswap_swapon(int type, unsigned long nr_pages)
 	struct xarray *trees, *tree;
 	unsigned int nr, i;
 
-	nr = DIV_ROUND_UP(nr_pages, SWAP_ADDRESS_SPACE_PAGES);
+	nr = DIV_ROUND_UP(nr_pages, ZSWAP_ADDRESS_SPACE_PAGES);
 	trees = kvcalloc(nr, sizeof(*tree), GFP_KERNEL);
 	if (!trees) {
 		pr_err("alloc failed, zswap disabled for swap type %d\n", type);
-- 
2.51.0


