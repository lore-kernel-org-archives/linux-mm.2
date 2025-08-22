Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2326DCA0EEB
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 19:21:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6AAAB8E000E; Fri, 22 Aug 2025 15:21:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 65B5E8E000D; Fri, 22 Aug 2025 15:21:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 571478E000E; Fri, 22 Aug 2025 15:21:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1EC398E0003
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 15:21:31 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B337C1384C5
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 19:21:30 +0000 (UTC)
X-FDA: 83805362340.12.397D2B2
Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	by imf25.hostedemail.com (Postfix) with ESMTP id D9363A0004
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 19:21:28 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=FOaEa4l8;
	spf=pass (imf25.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.219.44 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755890488;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r+1HQ2TlvwxlBkr62a2H4qwZSY6nsOPwAVU1BBwtoJE=;
	b=1LcbdtgF01yA6qW/29GjkB2MklupOgE//9qD+IJrQPKIYCFIg5MaL6H6JEgG1JM9EFrJzY
	4oKdygn0sHmUuMr7CvtbEdoIU04nbpElJsipIDM75Yo8cowFSkT0IzY0jl6Ep7cwzckvZ8
	QaMZYcireHLUHmYiX6lye/YRd58HfZY=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=FOaEa4l8;
	spf=pass (imf25.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.219.44 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755890488; a=rsa-sha256;
	cv=none;
	b=PryuhQNpAoKDuTkao8qbZXRd5O/oN7ZZftT9tTPsoDhrggcU4LXCxQIt8Bdo10yy1P12tA
	tlBqwpujl2XnTyMakn4dyYjdu0FtDvL9zuhzhepqu0qm2ORMan12pBtiTofy99+XRrIAAp
	XJvBsuHHwUphTMnFRB1+/kNqqHfsZro=
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-70d9eb2e96fso7508236d6.0
        for <linux-mm@kvack.org>; Fri, 22 Aug 2025 12:21:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755890487; x=1756495287; darn=kvack.org;
        h=content-transfer-encoding:mime-version:reply-to:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to;
        bh=r+1HQ2TlvwxlBkr62a2H4qwZSY6nsOPwAVU1BBwtoJE=;
        b=FOaEa4l8xV9SH8oGuS0NNQ5j12R21cucQUjR8sSZie3ftat+x6TrPtYKDVAX/T6760
         QhnhOM4akzfj2LLgGgSyqmzvOqoXMlEqe+sActn86DQsudS52SlErJxxlNNv7j9lnMQr
         czw454UJhTbc1qhT23hm8zH45fbGdUcKDBGnKB98ACCuoGLYm45ztWTEHoJ2BdoKed/T
         vj4zeJUH+CoOj+0ZL+jiJlfVg3IBqtNNhz+PF0DxHMDGknJcYp8bZ9tdGHrsMmLSMkVc
         TOAqzoIqqDegpK7fYHFsE0EJyvrwMZKkEoNHzozezxWoKH71iFT68x38svRVX83lVc+X
         9tTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755890487; x=1756495287;
        h=content-transfer-encoding:mime-version:reply-to:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=r+1HQ2TlvwxlBkr62a2H4qwZSY6nsOPwAVU1BBwtoJE=;
        b=St9+GY+pqh0gqUnHUpKVWW/qoYw5KtauzcmBULkNVf/Yof+MoBKDCHHVi5lvs/Z9rj
         gGK2ZQtGPNY3Flr5hhLUtX3rnqP7lVdbtUaSRONz+QjfrsGXZJmf6iW6IVkcj4Rwgc4/
         W/4EqlioXiDxkoPeW09XXYLkc7xliqpSoVi5txaSXkFGc62O0uG8OYCxXovXbcoWFWvL
         QsZIbQiBAzvmVviB95djS+V+7P8Wx9cxj7Sm0r1agb+UwdHhobuoLsOjYzilIVp0Yqx/
         tuJ83oyp2dUfewMqVp2nWYj5g7t826L2/OMgbcBSxkb1kOigV2DY2iu7MZ6OE2G6vlo/
         KpXw==
X-Gm-Message-State: AOJu0Yyh3sLIuBpj/u4kwECcxpDx3i0Q8xuSCWoj/3btU+6cSInLjEQ2
	P6gFeQm7aLiOkF8tAx3SxsIrl8O/7jHUoNiVK28x6nyUG3wMcMv1/JUmAqfji1VXY8s=
X-Gm-Gg: ASbGncui5YQivxJPk28Cgu1eIAcel0mYY0xw7siksvIX3EZQAtaQe6FZz0CRU33Fg0R
	m82RJTfeDnIwtQqNzqV4kI26i7HhH7YX4oUR5YIHVz6P9Etfvo9gFAHFsrfKAN/QqBh9QJmucaO
	ENWHsZDOmZRl5+7vDmVu8+AnfUz5UFAKF8vTeWCU+STvtn6Wf5/cKP95OQjR3K5AqHsKIzjPl8X
	Yytzxoy+E/uSMDNdUC+NxKyfkG6dumExPZTlBGMbraWtX/szak3uCw70hRDOp1mSkb8iDyupv7Y
	zPZUk2gfwslST9VcTb1snAJupwwroT904fNHamH+RxkLd6l7JoKYrRWwL58sRngyTHzPvxkuX+O
	VIdVv7iccdNNjMaCzS4FLc/Sa56KXlQziYx3A05hK2vQ=
X-Google-Smtp-Source: AGHT+IH2C/F6240WS4qBX1hA2FSLdhdG7hDUn141EwNBrggCl5LiHjq5wCWAwNtJS6EQdWBtk4nPzQ==
X-Received: by 2002:a05:6214:1d2b:b0:70b:ab14:d827 with SMTP id 6a1803df08f44-70d89327451mr75340296d6.7.1755890487565;
        Fri, 22 Aug 2025 12:21:27 -0700 (PDT)
Received: from KASONG-MC4.tencent.com ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-70da72b04a6sm3843656d6.52.2025.08.22.12.21.21
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 22 Aug 2025 12:21:27 -0700 (PDT)
From: Kairui Song <ryncsn@gmail.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
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
Subject: [PATCH 7/9] mm, swap: remove contention workaround for swap cache
Date: Sat, 23 Aug 2025 03:20:21 +0800
Message-ID: <20250822192023.13477-8-ryncsn@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250822192023.13477-1-ryncsn@gmail.com>
References: <20250822192023.13477-1-ryncsn@gmail.com>
Reply-To: Kairui Song <kasong@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D9363A0004
X-Stat-Signature: atrwbkzhs9wpzcehyqdpc9kg4wtjszwi
X-Rspam-User: 
X-HE-Tag: 1755890488-942190
X-HE-Meta: U2FsdGVkX1/vPHiy2EM6zeHPPbC22I8N7qWaDNJFrt/aoEXoPyeU+hn+Ac/AD1bjzrzP3AClAIliACgoQx75azUTR7/zh2XjkKEIVJceYdBQLLda9tJEyFsLr3fbhVw/+1I94ARetgUFBlvTo2LaCwyAt/axr7MrkOP3xS3HMh3dWNTVoEM6m1eSYXDQCpXjeq2J0jMTfDurWB3pCi4GmPEw2Gubqxw2Hpfs2ASzwLFaiHowtKvWM+8XM8+u/a3V3wBcQOo5EfxXSStwgMoYfbKssupLYfuBvjHK8zfrQh2eQPp0mVCTHwgp0UkWR82KRnnYHdFTUJtFz69sL+Lbowqahfi83mwxYRF4MOFl0Usx5kUB1DTXKPqvT9gnNhm9S2ZHh51SFoskzjtwCNWp9WrzB2682OwOvPvA9zp0zoTnJXtIjL0PTIXZeZEk58Erg3zwYL45cYN//i3hdl1nkr3oacmFEP2Q1qWrcKWEkFipwxhWCi7Uz/1eG619LVq+MwmeB01wka5zhYvxQp3g++0hWe0h0Ecf+AZsM4SVocFeWMvy0Q/JEmaOulXlB/sA9p0KPGk2/pgCn/Wq2Lh3Ev96EVCwP1qdlanBLB9UkDMg6KQbzgVgF5k/ugynfT+xJ3zM+FzGn3Ms/MhoCQMtU2QQxYEiMmgVv/XYwaELOYLsT4KUcqx8yEDsB8TcnJAXIj10bPRy47O6MKOIA/D0CuOss0ahz+1hhZAdo8DYsCcODcx1tbLZxklmuVk2G9TkBzqVzsU4af5nifJGa/uVDhNVl7rkM3T0L03pVH/j4sNhihmTMV3d6ji4RPVBUAoSMhicbB/RBKtKonou4IJvpNOaAf7ScbddgcmIrdxBpttnEj631f40vdVAfdDoDtj8drafWsDvwfbf1CeS8zWLkOfa/ED4UrhQrSc9yH+5gtA7s6xtACSfLFXGhBB0VHemtmCYoDUGtCR67cHaTaD
 HejHd8/1
 ShdfaS4e5lJWLnMdttiYG3I766+jHkU9m1aNbwL4/JPzpY8XDhRsy9qfzsE9bXWJC2UaP/zFzohPlkw8xBvL/KfF0vTXOwkudxIep8U0DJwanKOue9GcAgQ87jFaGSaTEcswGEVkSmdRTKcuxpUjhP5+30huMdqWtRRIJGm1wdmITFE7IDp6k3l17cYAG7OeEntk9praA1hF8BkmCbpXYwHDkMBvfXdld1sPgiVxPBaVRBs6090iFtPuOyzTsZdXg08IdiJRx3LOS/+u6i1osIYadlbprsgJkB5Ss2wptotiIZEHBryCeQ40Zt7PML/dYh2cR587tqn+V652Kf/Jdbpuo07GyRIqTH4ouipFUtJqiWYJPq109nku/MU/sn/J3+UL7IbbTSfvAPJlbSp2tNebxGmzwSvdz/DuA1xcubWnnCYNBnW5nnYh2eKs2TQl7Jg3ZjsxOgelBpxGgKLHsoJUdIARD8h8VFiCWk65SbWRtNE9dI2Q9SzuxkeWjcAK73yGpYW7varz5ARIDJbWyUWXCGC1jhVEpEg0Y7x/Aal658IrMCvmMtarhH13L8n7F3S0uVitFrOXAeoQp6Cm6G0xuaiCFSHcviOKHL2IUh4AXrili1gKPS37Mwotd2aZllwnDJDxw+IipTYqP/4/MQGQsQV6lSKQ8pJ2j3LsYk/saqSOxnT3fd9MLXA==
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
size (2M) was much smaller than each swap cache space (64M), so shuffling
the cluster means the allocator will try to allocate swap slots that are
in different swap cache spaces for each CPU, reducing the chance of two
CPUs using the same swap cache space, and hence reducing the contention.

Now, swap cache is managed by swap clusters, this shuffle is pointless.
Just remove it, and clean up related macros.

This should also improve the HDD swap performance as shuffling IO is a
bad idea for HDD, and now the shuffling is gone.

Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202504241621.f27743ec-lkp@intel.com
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/swap.h     |  4 ----
 mm/swapfile.c | 32 ++++++++------------------------
 mm/zswap.c    |  7 +++++--
 3 files changed, 13 insertions(+), 30 deletions(-)

diff --git a/mm/swap.h b/mm/swap.h
index 4af42bc2cd72..ce3ec62cc05e 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -153,10 +153,6 @@ int swap_writeout(struct folio *folio, struct swap_iocb **swap_plug);
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
index df68b5e242a6..0c8001c99f30 100644
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
index c869859eec77..c0a9be14a725 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -237,10 +237,13 @@ static bool zswap_has_pool;
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
 
 #define zswap_pool_debug(msg, p)				\
@@ -1771,7 +1774,7 @@ int zswap_swapon(int type, unsigned long nr_pages)
 	struct xarray *trees, *tree;
 	unsigned int nr, i;
 
-	nr = DIV_ROUND_UP(nr_pages, SWAP_ADDRESS_SPACE_PAGES);
+	nr = DIV_ROUND_UP(nr_pages, ZSWAP_ADDRESS_SPACE_PAGES);
 	trees = kvcalloc(nr, sizeof(*tree), GFP_KERNEL);
 	if (!trees) {
 		pr_err("alloc failed, zswap disabled for swap type %d\n", type);
-- 
2.51.0


