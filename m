Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63C1ECA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 16:09:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B92148E0032; Wed, 10 Sep 2025 12:09:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B41E28E0005; Wed, 10 Sep 2025 12:09:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A09228E0032; Wed, 10 Sep 2025 12:09:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8B3588E0005
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 12:09:54 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4A5051D9A83
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 16:09:54 +0000 (UTC)
X-FDA: 83873826708.19.533E4DC
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	by imf08.hostedemail.com (Postfix) with ESMTP id 61CE8160012
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 16:09:52 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VF++DM71;
	spf=pass (imf08.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757520592;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=su4PnDYf8OUfLgI2Lrokhalmhp7VgFbGjYZtLVCSA2o=;
	b=z6wJFm+ybYdfr51sO3cpjUMK9xbGgZVtd009Ulqis+ih32UmI9im7vRO8DkVp7gbVt5GSO
	sRRJmRaiXu5E05RCkc4GMAPSpY3y8xutOKeLP5DNgfLrc9Yy9IFiDR2UFPlL8xS1sq46yD
	WhYqHJx6uj6P7hhMTYrhoMXsLaqayQo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757520592; a=rsa-sha256;
	cv=none;
	b=kCN0WxQAXbwIzGTBgS7fYEhg8R1/R/uUdqGdt93dlHHoY2iCbTB33pc3a70I1gTkYTjT39
	+KF7LGnTRQWBfjBvGMRaJqCDDT2ng75llGih0lI525I9kLa9frvFcVHTkoD0jMSdK0DRqO
	mVnKkZFR5hQQfq2ss4QlDQZBqlMefJY=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VF++DM71;
	spf=pass (imf08.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-7723cf6e4b6so5374718b3a.3
        for <linux-mm@kvack.org>; Wed, 10 Sep 2025 09:09:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757520591; x=1758125391; darn=kvack.org;
        h=content-transfer-encoding:mime-version:reply-to:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to;
        bh=su4PnDYf8OUfLgI2Lrokhalmhp7VgFbGjYZtLVCSA2o=;
        b=VF++DM71k21qUKtdsxJjMoeaOw/H84zEV0g8vBgaH3iJe0RIzzUQ/cAhWS40GSzCn+
         6Y8XylCXon2BEp60cCkttGoyaebOi50yZj0nSn00f9h9DA34sT7OqFzifvjtBNWancti
         Dw9A3nwVbeoEixkr+3hA7Q8XdVMda48U8oSHzu3dYQaCKh4D7BNtdChv4bJvP4UVNn2t
         1bYEw0puGOdtorBTj4ST1spwlArPMm5wN+wjgizr+WMoDgBmOgkA2yVqNb6NX8nWrIEP
         ueFR/qt4iFEv4tEx+z0U2jZOOO0SeQrrGl8uk3gdYGL5nwANKbURqqfHz2CPd2FdXe8W
         Cfpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757520591; x=1758125391;
        h=content-transfer-encoding:mime-version:reply-to:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=su4PnDYf8OUfLgI2Lrokhalmhp7VgFbGjYZtLVCSA2o=;
        b=vFtwyg6g4zt7XiAyS6gQCEnHNuDTLuuCvyXDQtJhc9skR30DTydf2Pz2ze/diUzyc3
         sGDSw+8dZCv/5zkxZxxXbggCyEbsuC95piQC0DSyEcSljTKKZUutDIKEhMjLmYSEB23a
         QG1s8ijkRDIX/pa+7GDIUTshKJhqS1ba1qG2YtJw3StMcv5rIWyUCpOMaEOeRBeZ7KPF
         mee8r6Jzm91gPwiF8w9bZeuZTdL1zjds1hyrAv8oqh9neCx4ip0Yi0k4ROQz24tcNchw
         SEKc/lyvik09K2nHSed36UtVDXSjIsEpfLXvQQoUiEakWGyiU9mx3hTxxrYQgv/fcMF7
         MvCw==
X-Gm-Message-State: AOJu0Yxz/eOHtCkb6VP7M098Q7kTvsTbziMMUCXAhErYhlERkH5QHdWT
	7q7E4YsVBC7u6ITwLvk/1RiO6Y6fLP5jQRYNTMUFH2ztn9ifyBcsM71ayNqcb9Ay5Mc=
X-Gm-Gg: ASbGncs8tYCTtg7NUu5645CuHgvqsOpP634hHgqDjL/XpwzNCyC1MEMjKJWABuhuiNs
	bwwn3XTke4dIGRWuFox4jusKdPWTh+e6/nunBb6cCIB8XZhiFQ7JXaVkCdoeDIpjWkYSvIvPDJh
	4UcFw3afYn2PLUwr3NhjNuKVRJ8DmdZlITEfU68Mt4h9IKqShcoLJAn5acmetE29s88CSjtGMHx
	64CILcXct23X7nZ9v5uBOG8ty56j+uHPF2UHBQI+3neI+b/k5olPBTMS1Mdjrm3G9Pw2LrYv0Z/
	jISI4SrOidyJ850w4JZWQQPaCqeh3tjC6X0FXmoYJZhVYNKmn6SlX+fr8jHHGyJ2q90aE7SXBfq
	/7de9llZGrZpHMblSV5RqbuwXNa1hEak0DoZMvmRjebkWBvw=
X-Google-Smtp-Source: AGHT+IEXDaG6nULakGwHLuDrhEcX+0zJ4/JSzZr8GFi2sn5vxnMvwdyigmF9NkrFHeceSC2DScxt2A==
X-Received: by 2002:a05:6a20:1584:b0:246:1e3:1f6f with SMTP id adf61e73a8af0-2533dcc0596mr25473628637.12.1757520590541;
        Wed, 10 Sep 2025 09:09:50 -0700 (PDT)
Received: from KASONG-MC4.tencent.com ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b54998a1068sm1000142a12.31.2025.09.10.09.09.45
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 10 Sep 2025 09:09:50 -0700 (PDT)
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
Subject: [PATCH v3 13/15] mm, swap: remove contention workaround for swap cache
Date: Thu, 11 Sep 2025 00:08:31 +0800
Message-ID: <20250910160833.3464-14-ryncsn@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250910160833.3464-1-ryncsn@gmail.com>
References: <20250910160833.3464-1-ryncsn@gmail.com>
Reply-To: Kairui Song <ryncsn@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 61CE8160012
X-Stat-Signature: xbdxehgfgf9bioa3yjzcg8y7953wyo6y
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1757520592-708176
X-HE-Meta: U2FsdGVkX18AXi1SlJ+eie/PFjKUqbl+yeUdclzPKKqO6V2Jjsp/olYuR1tgKAXpTmy0XE/VWk3S/PzclLLjWvTtEC48GuvizyRPhmB0lNfm11NUdVy14CSKJoTBb+J15NloiQErvtQ1X/tpD8LJ1MoS9DAblcJYHccpH1iqLfL9y6lZJEO0Ho3MpuSc3nNNzcOmnMJWASYlz9pQOwt6sRAn8ej7THCNXz2RYr1n9UiLLT5sfiPSL7DKbIQjDXt2VsXScYvT0yHgfoleTPO7s/GF3rvI0boHgNICPFZVUJLCZF/kj2jSvU7uZKxSLpdXiMccoW5lFhAcfPgDjyYmhubINwQKdcI1SwYJ8PrQ5jlCJoTEOqEW/GVheIuu9D7oAh0Y+mbGPoUsMo7mcZ8t8XPzjsdHuc8zX69C3l/BBgoZOtnef71s/xGxsTW/1Vds6dqi+W6IwZinlR5zK0x4a8EH+6Ve6X5J0eokUUBFuK+awvkfT02EVWrYLFLnmrn9OlDGwBsvduuW9ksHM8b3/s55ruWCHenm1Qh7IKMD4fOlxFfi64PJod9NwhW31D1gnHYPNOSwt5jmmbI7wa3Uoqy3/Qwd5PajVQxQPvONjRIG1i3bfAARbZy+0BIWv/f1/nS130BXaCaNfFC0dKsxVhQHLxWlWoZ9245FnsX7QGn0fl0ivtS+PIeM6ZZeO77hDUBurMZCtCOfm/Wi7iUpcavbu+Q37qFHiQSqqudct8wsX2fE5JeqJZvAcQvGYlIUGSGt0T1mc95xZkex1VR2WPW1yUub4q1Wf1yJQUuY62+PJOzEd23RjK0tQt1RznYnbpgZqALGbiXMjdusiA5VUX/mLISmHsYpHyAg44qcC1v/bq2A/cKIVCdO1zVf+pquND2DfvIa3i/PztIhxTJEnnJyP9V1w0Q31Aq+Bcx9iWCnPFyv0yxHU6UFoWD8YFpeTNnKaBYarar8PhVMOpS
 cZhW+FWl
 DcaH5MQ+Fkx6MAWysw05cpyEFi9wgM0qdUqijx5BzL7EyU/9Q0qJrVeSCqHtt0Xxo17ttOBowuE3wWehkSxuHrol0BnydYC+XoqUx+eAGG03pLpQV2gvMZg2tpHOmKT+bv+SvjH/XRwOnowS0QGo2P7MrSuUcWXl/47LIY4yPZldUPWFqJhKC4sK3kYYYPvosL2lcZD71Jg98mjtjS9Wr9YUTLCB1oZlzl1dqcJzEbRTdFBn933Gqlanhf1KTgoA3OU6IYXap5507iGhyLyg/dpYK6wEZR51sep0yGX7Ci9Ty3zLe0K7GVQ/tkdIghCSufmm4NVyPgr+UmY6P5NaNWkKU1kwT/xyPsrrSK3uZISECQ4hfHEjGTXxZDu/LTHuEIg/HrckeZh6AvaasYKDIuZ2PnUX2Ij8ZVET1HYUVGL72LLLl33pA6v6vchNiVCznplI1znJsLVm3ju8iE0fWlcMEKAKy7Wa+hLZdZIAKjLY91Y1dxh0PXdNCmDBY+oF8+9zSMfMI24ZRRK3RAxlEgyw4Pj2LpcVBULqKQmaHh19anO5R/PiTWpOWuZuCvCU4/cVeFzczeN8hywsW+1pV0W2uzz2J3E5nQIfOgpXqzKveaAsf3y0aJZ05wqFWxHMBdSkAq27mClSEO28LsXIqE/VGvQkJ+JhZYWSHomfutHbrDko2HVjk1lZKlw==
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
index a81ada4a361d..89659928465e 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -3203,21 +3203,14 @@ static int setup_swap_map(struct swap_info_struct *si,
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
@@ -3266,22 +3259,13 @@ static struct swap_cluster_info *setup_clusters(struct swap_info_struct *si,
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
index 3dda4310099e..cba7077fda40 100644
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


