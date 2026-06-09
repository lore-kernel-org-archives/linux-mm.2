Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E641CD8CA4
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 13:20:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 19F756B009D; Tue,  9 Jun 2026 09:20:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1787D6B009E; Tue,  9 Jun 2026 09:20:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 018B66B00A0; Tue,  9 Jun 2026 09:20:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D44296B009D
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 09:20:17 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 92F78C1FC9
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 13:20:17 +0000 (UTC)
X-FDA: 84860432874.02.F97400D
Received: from mail-dy1-f170.google.com (mail-dy1-f170.google.com [74.125.82.170])
	by imf13.hostedemail.com (Postfix) with ESMTP id A51EB20002
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 13:20:15 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YcLiiZ6m;
	spf=pass (imf13.hostedemail.com: domain of ritesh.list@gmail.com designates 74.125.82.170 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781011215;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wSL5CmzTD1LjszwUA61HuGE+7rKiRm908LOwnsMCpzw=;
	b=k5E20CkgNEqIVxafq+P1vku9I1yuAHMiNcglsh+LIR7wXqGyrRw5Bi+JZY6IRhdOOqKe0n
	4Nnf2OUnmUCy6pgJNLPQPTaPAyRz2Lb4NyowbgPk3CxXoSsOD7Du1Oi5Ckx1Dw71JZDj32
	bOgr/mpiRnfvf/zFuBwvve2JzLX6mGw=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YcLiiZ6m;
	spf=pass (imf13.hostedemail.com: domain of ritesh.list@gmail.com designates 74.125.82.170 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781011215;
	b=IYSG+sy31gshwmExnFkWftC+W9M0tguZPznRFKb2HYbMy7+v6UewRHl60xcCtE6bX/pYda
	Ek3e99kXcmvNkTS+jJP7PJgFfLrfq9HXWE3apWdoYutctW8sbutVzcPApWBKQDxvo3fNpq
	yDx0YRpZ9AZnqkYIutQSb3hTAYB+50Y=
Received: by mail-dy1-f170.google.com with SMTP id 5a478bee46e88-304d7f31215so4820197eec.1
        for <linux-mm@kvack.org>; Tue, 09 Jun 2026 06:20:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781011214; x=1781616014; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wSL5CmzTD1LjszwUA61HuGE+7rKiRm908LOwnsMCpzw=;
        b=YcLiiZ6mkbdzxLNh8+v4ZKAbxGFNtgz3LEta10CiZqsd5PpAhEcQ2T3YA1SEYTzKVv
         uBzJWR9oruJsqlSgF18RfVjjf8BXCTgdzljssM+vZu+xXjedRQd0pK95MDdXPFr+3zMu
         86C2RjF8U3OdlZ3RR6tpQ5i1Iah2ykJ7sd67D/+wMhmD37/CuTjMMvSGMmse93tbtL2j
         osNKQ/+HZbE2GYmFCPU9MjHJoUPopkbfB1gKVsINVdS2UcapVeUx4VnMhGYhWfwOR9qp
         EwFy3pRwuzxZKri6aAfz2Mf+1gc2s5PGSymNUH9vEsZy6ZerFkIx2DAjSAcbmv0r11jB
         YqCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781011214; x=1781616014;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=wSL5CmzTD1LjszwUA61HuGE+7rKiRm908LOwnsMCpzw=;
        b=kL0Exs/67KQZKjIq8QUIEDyfFuW/HS+V7crJ0AjY+DlTATBqDFQu/yJr8AIAnTFJkp
         9+sPJAfkLOV4cAddz3ZH+T/Bd5AZKAwtd91Hl3XLTVnW1ulMI89JZvUxMtmkdODT1H3Z
         VgWLac/xAeWNjzOgte2j1DnGYfrEb/pUjdev94LW7ELk7kx/DSIZMmkU0O1jEJK9wNK8
         YY6Sv8qpcEAODVt9B4Oqqe9P5GZNBB1cgxkqvvqjCAxAys/OYXz+1v92s3aTt7pgESEv
         gZ+ugDyzt4oZSOWLj1nvUJtUz33vi0SWoHqo3C4eIZWYglUQ0UU3iu3T7tIOxK5Wqxeo
         IYVg==
X-Gm-Message-State: AOJu0YzJMu6svQ/5RB9XX4ZnLEozWX4FO/VylMAO46JgVhXTFS31jZJ0
	UTjY60LXxLSNAAXavWPHjM95f6dTbWZ0uLkuH85ks84hWAvjttsIJIhuISo+4Q==
X-Gm-Gg: Acq92OHK5FpqMKhvGZVbpyh+LmhysCA83PrtvdYAqvYeE44B/0FM8IPEapW9kdhNApA
	ZwtBumZMjPnynbrSQ4DpBXi0eRU2nkKma+870d5a+UCl2sLCKUdrWOxvEqin2dK2dGVP37tUd7D
	7l0ZAGlE1hGICa7WCKGN+mw0JsYF1t7+Tu+EWzT+H6URw/vgzimZ5q50jx7d+qp5mV/YvXzcZ5u
	EK6HMxYAZif8tQY9NOboHGd4poTKZvmDtbZydvfD/6QSHZ+NfyFGbQfJ673JIMZgOCDy6YJItiU
	dELP5Pp5Gb0LpUSr3PLoItR55M/YNV32TIWd+Kl5vqBAVqMJuv6xESwlYBjdqZYvhPkn8b7EIAC
	jr7QPr47quxOQ6jIfMIoHROztTBXfZcgX9rAonKvxPzrtaQojl6ZyJEFWEhmYJCDFz+QueFnGg9
	yMgAGqMlkGtY0wJ1GuXBFqiw+cew5o6u9LDB2AaMbukcwHuLogB80Hd8FG+Mf9
X-Received: by 2002:a05:7300:2311:b0:2f2:6dde:df66 with SMTP id 5a478bee46e88-3077b5a13cemr11222291eec.22.1781011214188;
        Tue, 09 Jun 2026 06:20:14 -0700 (PDT)
Received: from localhost.localdomain ([129.41.58.2])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3074db55f60sm27162467eec.6.2026.06.09.06.20.08
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 09 Jun 2026 06:20:13 -0700 (PDT)
From: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
To: linux-mm@kvack.org
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	David Hildenbrand <david@kernel.org>,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	Sayali Patil <sayalip@linux.ibm.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Subject: [RFC 3/4] mm, swap: make SWAP_NR_ORDERS runtime
Date: Tue,  9 Jun 2026 18:49:33 +0530
Message-ID: <19688ab5ab8017467749e003cf630c76a4b2b198.1781000840.git.ritesh.list@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1781000840.git.ritesh.list@gmail.com>
References: <cover.1781000840.git.ritesh.list@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A51EB20002
X-Stat-Signature: c87wmpnymz6677t5rytq95ae9oa95t1d
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1781011215-232863
X-HE-Meta: U2FsdGVkX1+TNP5SEDaGCl2zpz3/R7eeTiroXxR8pUSoOAhXz96ZrEZIlwZ8i2CUQlFKvZTYp7w9u8bgzrjAheyzyYKIN7dqsLoSOQTVlOCZQdwoI0ROAHRLgYPmYTMeD0YPm7YuH+WgH6oI343BbWwPT3GHJyLw1OtnadhuYwfdRjuq7cGJWqVFcKzGKfY+YpYbj6WckXOLzIXGcbflq3scweiw+oOjRVqsfVtdpbaja93KjcNywhw31MboDToL7HHt0Ruu7kl/vtM6BuKKjgX6d18ZwN0obq1/VLISqxjvMT7Y/iJyAvmph2hvqVPErtdE7AkBYwfShtE+ZCnWKAGhXuL2YxMQI5eAFD2db5FmfvVe+Q3H/mkJuNq9GavLEDy0WK8tWDEzESafhigxdwrlqCdgI0wP2drRtbkKhWFNfiK/PdN16avNR6+SqdO30FO1jWWxmA+bwNjv71O4RA7o+3+S/e1sQLXQy7e0TSI1bNlcC/5J+03xeYQYl/I2vg5oFbpGTNSR3PRiL4mMjTTq+6ZANHdbc6+upeScR6wb19Lkc7QoyM4t5nSeGx+1pDwk+WWe8XGUbNrOQwbEvr3h0mBY3atLV8EbVamBNgCo+/bGCKdPWmCDYKQsMYCM36i3kJyzx1R0yKHx6rwFivngTHSI9C3i3pC32e2xgEi1ShQad+W91d/ltDLU/CP+GL/UF7uw9XGEsyW+DTJv0V8fkKmoImq18Y9PSf7sk24ejPSRQEyM7Ly3p14wP2PLiNOJfznKEqxG0yJOZmhC9TsBWIjvZa+1G3AX/TpXMVpU3A1GE7evxsdiDq3AJZCOzkehJId266EnxaLvWPyCRCZTLx46PRcj4dVvimd+QUC3/kqTisgKd1prESgLHLbh6UP35UGpILWc3RlevlmzmoKvUtyrM5L4495tgxZOMnvrca8pmc/9XSQCDAZa87g6pOfRdO7AFnelC7d43kT
 b1TU7ryJ
 zvMvV+QUpaMY5lbKd0QC0SZbDlO7M45uCdOcMXXEzuVV3VfhcVg41vRYgrvOxursAU00UP/qteqT3x7WXoOQY2AmeOO/ydyeAEuoc6+9SCqggU0FCdrMQ8+7areiDi3RIAQZWf3dbxPXhgUVcQMBS2+4BctOFqrsz/MPXDds3Gv9Q85f7vMzYEby5euVf0GtTAQp366jxUXEuG++JcGAahQ/GH2jXhpC4iuICjskTZ22s3oa6nEOdxK3Bdf8TnkskeXfPvK5l8V2ISfcv63taVxyNR7M9+zsi8KfeA2WkosAKU9gXKqKY5uIwWU6mPlAWEEumH1quBiU0ILchL117COQIZgaeMkP1PO+kdQUuo2IFoGUU3XfpmSCfF0d0dMguq428uY4UB/jWz4x67/eDKv73EpV8tCdr6b71Q94frB9GVJkNcFcCLIUL6S06K0IRriSaOb/71XaTlYmScFHeArGxX2rcjD12WSQECqBxsOi8Kk9HvtHxcH+Y37X5CFatcXNbHNJy8KI8PtvDhID536cbst90J9bDMeFSReSWyqfWGI45vEe/1BzvzjYTNWsw7woCs1sz76ZQO4kkPr1JzQxweDDEnsi0GhBBEdSTIGUPpob92jRWNjMgfw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

SWAP_NR_ORDERS is currently a compile-time constant defined as PMD_ORDER
+ 1 when CONFIG_THP_SWAP=y, else 1.
This patch converts SWAP_NR_ORDERS and all the relevant code paths to
make it runtime dependent. This is needed for architectures like powerpc
book3s64, where PMD_ORDER is decided at runtime depending upon which MMU
is chosen (Radix / Hash).

One thing to note here is, if any of the allocations required in
swapfile_init() call (which is a subsys_initcall) fails, then we have no
option but to panic. This is inline with how memory allocation failures
in other subsys_initcall() are handled.

Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
---
 include/linux/swap.h |  10 ++---
 mm/swapfile.c        | 105 ++++++++++++++++++++++++++++++-------------
 2 files changed, 78 insertions(+), 37 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 46c25523d7b8..063ab7c4d4a5 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -224,9 +224,9 @@ enum {
 #define SWAP_ENTRY_INVALID	0

 #ifdef CONFIG_THP_SWAP
-#define SWAP_NR_ORDERS		(PMD_ORDER + 1)
+#define swap_nr_orders()	((unsigned int)(PMD_ORDER + 1))
 #else
-#define SWAP_NR_ORDERS		1
+#define swap_nr_orders()	(1U)
 #endif

 /*
@@ -234,7 +234,7 @@ enum {
  * The purpose is to optimize SWAP throughput on these device.
  */
 struct swap_sequential_cluster {
-	unsigned int next[SWAP_NR_ORDERS]; /* Likely next allocation offset */
+	DECLARE_FLEX_ARRAY(unsigned int, next); /* Likely next allocation offset */
 };

 /*
@@ -250,9 +250,9 @@ struct swap_info_struct {
 	struct swap_cluster_info *cluster_info; /* cluster info. Only for SSD */
 	struct list_head free_clusters; /* free clusters list */
 	struct list_head full_clusters; /* full clusters list */
-	struct list_head nonfull_clusters[SWAP_NR_ORDERS];
+	struct list_head *nonfull_clusters;
 					/* list of cluster that contains at least one free slot */
-	struct list_head frag_clusters[SWAP_NR_ORDERS];
+	struct list_head *frag_clusters;
 					/* list of cluster that are fragmented or contented */
 	unsigned int pages;		/* total of usable pages of swap */
 	atomic_long_t inuse_pages;	/* number of those currently in use */
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 016a5aa0cb93..0a78802528cf 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -118,16 +118,12 @@ static atomic_t proc_poll_event = ATOMIC_INIT(0);
 atomic_t nr_rotate_swap = ATOMIC_INIT(0);

 struct percpu_swap_cluster {
-	struct swap_info_struct *si[SWAP_NR_ORDERS];
-	unsigned long offset[SWAP_NR_ORDERS];
+	struct swap_info_struct **si;
+	unsigned long *offset;
 	local_lock_t lock;
 };

-static DEFINE_PER_CPU(struct percpu_swap_cluster, percpu_swap_cluster) = {
-	.si = { NULL },
-	.offset = { SWAP_ENTRY_INVALID },
-	.lock = INIT_LOCAL_LOCK(),
-};
+static struct percpu_swap_cluster __percpu *percpu_swap_cluster;

 unsigned int swap_slots_in_cluster __read_mostly;
 bool swap_table_use_page __read_mostly;
@@ -545,7 +541,7 @@ swap_cluster_populate(struct swap_info_struct *si,
 	 * Only cluster isolation from the allocator does table allocation.
 	 * Swap allocator uses percpu clusters and holds the local lock.
 	 */
-	lockdep_assert_held(&this_cpu_ptr(&percpu_swap_cluster)->lock);
+	lockdep_assert_held(&this_cpu_ptr(percpu_swap_cluster)->lock);
 	if (!(si->flags & SWP_SOLIDSTATE))
 		lockdep_assert_held(&si->global_cluster_lock);
 	lockdep_assert_held(&ci->lock);
@@ -562,7 +558,7 @@ swap_cluster_populate(struct swap_info_struct *si,
 	spin_unlock(&ci->lock);
 	if (!(si->flags & SWP_SOLIDSTATE))
 		spin_unlock(&si->global_cluster_lock);
-	local_unlock(&percpu_swap_cluster.lock);
+	local_unlock(&percpu_swap_cluster->lock);

 	ret = swap_cluster_alloc_table(ci, __GFP_HIGH | __GFP_NOMEMALLOC |
 					   GFP_KERNEL);
@@ -575,7 +571,7 @@ swap_cluster_populate(struct swap_info_struct *si,
 	 * could happen with ignoring the percpu cluster is fragmentation,
 	 * which is acceptable since this fallback and race is rare.
 	 */
-	local_lock(&percpu_swap_cluster.lock);
+	local_lock(&percpu_swap_cluster->lock);
 	if (!(si->flags & SWP_SOLIDSTATE))
 		spin_lock(&si->global_cluster_lock);
 	spin_lock(&ci->lock);
@@ -1016,8 +1012,10 @@ static unsigned int alloc_swap_scan_cluster(struct swap_info_struct *si,
 	relocate_cluster(si, ci);
 	swap_cluster_unlock(ci);
 	if (si->flags & SWP_SOLIDSTATE) {
-		this_cpu_write(percpu_swap_cluster.offset[order], next);
-		this_cpu_write(percpu_swap_cluster.si[order], si);
+		struct percpu_swap_cluster *pcp_sc = this_cpu_ptr(percpu_swap_cluster);
+
+		pcp_sc->offset[order] = next;
+		pcp_sc->si[order] = si;
 	} else {
 		si->global_cluster->next[order] = next;
 	}
@@ -1178,7 +1176,7 @@ static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si,
 		goto done;

 	/* Order 0 stealing from higher order */
-	for (int o = 1; o < SWAP_NR_ORDERS; o++) {
+	for (int o = 1; o < swap_nr_orders(); o++) {
 		/*
 		 * Clusters here have at least one usable slots and can't fail order 0
 		 * allocation, but reclaim may drop si->lock and race with another user.
@@ -1376,13 +1374,14 @@ static bool swap_alloc_fast(struct folio *folio)
 	struct swap_cluster_info *ci;
 	struct swap_info_struct *si;
 	unsigned int offset;
+	struct percpu_swap_cluster *pcp_sc = this_cpu_ptr(percpu_swap_cluster);

 	/*
 	 * Once allocated, swap_info_struct will never be completely freed,
 	 * so checking it's liveness by get_swap_device_info is enough.
 	 */
-	si = this_cpu_read(percpu_swap_cluster.si[order]);
-	offset = this_cpu_read(percpu_swap_cluster.offset[order]);
+	si = pcp_sc->si[order];
+	offset = pcp_sc->offset[order];
 	if (!si || !offset || !get_swap_device_info(si))
 		return false;

@@ -1770,10 +1769,10 @@ int folio_alloc_swap(struct folio *folio)
 	}

 again:
-	local_lock(&percpu_swap_cluster.lock);
+	local_lock(&percpu_swap_cluster->lock);
 	if (!swap_alloc_fast(folio))
 		swap_alloc_slow(folio);
-	local_unlock(&percpu_swap_cluster.lock);
+	local_unlock(&percpu_swap_cluster->lock);

 	if (!order && unlikely(!folio_test_swapcache(folio))) {
 		if (swap_sync_discard())
@@ -2166,6 +2165,7 @@ swp_entry_t swap_alloc_hibernation_slot(int type)
 	unsigned long pcp_offset, offset = SWAP_ENTRY_INVALID;
 	struct swap_cluster_info *ci;
 	swp_entry_t entry = {0};
+	struct percpu_swap_cluster *pcp_sc;

 	if (!si)
 		goto fail;
@@ -2174,9 +2174,10 @@ swp_entry_t swap_alloc_hibernation_slot(int type)
 	 * Try the local cluster first if it matches the device. If
 	 * not, try grab a new cluster and override local cluster.
 	 */
-	local_lock(&percpu_swap_cluster.lock);
-	pcp_si = this_cpu_read(percpu_swap_cluster.si[0]);
-	pcp_offset = this_cpu_read(percpu_swap_cluster.offset[0]);
+	local_lock(&percpu_swap_cluster->lock);
+	pcp_sc = this_cpu_ptr(percpu_swap_cluster);
+	pcp_si = pcp_sc->si[0];
+	pcp_offset = pcp_sc->offset[0];
 	if (pcp_si == si && pcp_offset) {
 		ci = swap_cluster_lock(si, pcp_offset);
 		if (cluster_is_usable(ci, 0))
@@ -2186,7 +2187,7 @@ swp_entry_t swap_alloc_hibernation_slot(int type)
 	}
 	if (!offset)
 		offset = cluster_alloc_swap_entry(si, NULL);
-	local_unlock(&percpu_swap_cluster.lock);
+	local_unlock(&percpu_swap_cluster->lock);
 	if (offset)
 		entry = swp_entry(si->type, offset);

@@ -3029,6 +3030,16 @@ static void wait_for_allocation(struct swap_info_struct *si)
 	}
 }

+static void free_swap_info_arrays(struct swap_info_struct *si)
+{
+	kfree(si->global_cluster);
+	si->global_cluster = NULL;
+	kfree(si->nonfull_clusters);
+	si->nonfull_clusters = NULL;
+	kfree(si->frag_clusters);
+	si->frag_clusters = NULL;
+}
+
 static void free_swap_cluster_info(struct swap_cluster_info *cluster_info,
 				   unsigned long maxpages)
 {
@@ -3057,17 +3068,17 @@ static void free_swap_cluster_info(struct swap_cluster_info *cluster_info,
 static void flush_percpu_swap_cluster(struct swap_info_struct *si)
 {
 	int cpu, i;
-	struct swap_info_struct **pcp_si;
+	struct percpu_swap_cluster *pcp_sc;

 	for_each_possible_cpu(cpu) {
-		pcp_si = per_cpu_ptr(percpu_swap_cluster.si, cpu);
+		pcp_sc = per_cpu_ptr(percpu_swap_cluster, cpu);
 		/*
 		 * Invalidate the percpu swap cluster cache, si->users
 		 * is dead, so no new user will point to it, just flush
 		 * any existing user.
 		 */
-		for (i = 0; i < SWAP_NR_ORDERS; i++)
-			cmpxchg(&pcp_si[i], si, NULL);
+		for (i = 0; i < swap_nr_orders(); i++)
+			cmpxchg(&pcp_sc->si[i], si, NULL);
 	}
 }

@@ -3179,8 +3190,7 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 	arch_swap_invalidate_area(p->type);
 	zswap_swapoff(p->type);
 	mutex_unlock(&swapon_mutex);
-	kfree(p->global_cluster);
-	p->global_cluster = NULL;
+	free_swap_info_arrays(p);
 	free_swap_cluster_info(cluster_info, maxpages);

 	inode = mapping->host;
@@ -3531,6 +3541,7 @@ static int setup_swap_clusters_info(struct swap_info_struct *si,
 	struct swap_cluster_info *cluster_info;
 	int err = -ENOMEM;
 	unsigned long i;
+	unsigned int nr_orders = swap_nr_orders();

 	cluster_info = kvzalloc_objs(*cluster_info, nr_clusters);
 	if (!cluster_info)
@@ -3539,11 +3550,19 @@ static int setup_swap_clusters_info(struct swap_info_struct *si,
 	for (i = 0; i < nr_clusters; i++)
 		spin_lock_init(&cluster_info[i].lock);

+	si->nonfull_clusters = kmalloc_objs(*si->nonfull_clusters, nr_orders);
+	if (!si->nonfull_clusters)
+		goto err;
+
+	si->frag_clusters = kmalloc_objs(*si->frag_clusters, nr_orders);
+	if (!si->frag_clusters)
+		goto err;
+
 	if (!(si->flags & SWP_SOLIDSTATE)) {
-		si->global_cluster = kmalloc_obj(*si->global_cluster);
+		si->global_cluster = kmalloc_flex(*si->global_cluster, next, nr_orders);
 		if (!si->global_cluster)
 			goto err;
-		for (i = 0; i < SWAP_NR_ORDERS; i++)
+		for (i = 0; i < nr_orders; i++)
 			si->global_cluster->next[i] = SWAP_ENTRY_INVALID;
 		spin_lock_init(&si->global_cluster_lock);
 	}
@@ -3579,7 +3598,7 @@ static int setup_swap_clusters_info(struct swap_info_struct *si,
 	INIT_LIST_HEAD(&si->full_clusters);
 	INIT_LIST_HEAD(&si->discard_clusters);

-	for (i = 0; i < SWAP_NR_ORDERS; i++) {
+	for (i = 0; i < nr_orders; i++) {
 		INIT_LIST_HEAD(&si->nonfull_clusters[i]);
 		INIT_LIST_HEAD(&si->frag_clusters[i]);
 	}
@@ -3599,6 +3618,7 @@ static int setup_swap_clusters_info(struct swap_info_struct *si,
 	si->cluster_info = cluster_info;
 	return 0;
 err:
+	free_swap_info_arrays(si);
 	free_swap_cluster_info(cluster_info, maxpages);
 	return err;
 }
@@ -3807,8 +3827,7 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 bad_swap_unlock_inode:
 	inode_unlock(inode);
 bad_swap:
-	kfree(si->global_cluster);
-	si->global_cluster = NULL;
+	free_swap_info_arrays(si);
 	inode = NULL;
 	destroy_swap_extents(si, swap_file);
 	free_swap_cluster_info(si->cluster_info, si->max);
@@ -3922,6 +3941,10 @@ void __folio_throttle_swaprate(struct folio *folio, gfp_t gfp)

 static int __init swapfile_init(void)
 {
+	unsigned int nr_orders = swap_nr_orders();
+	struct percpu_swap_cluster *pcp_sc;
+	int cpu;
+
 	swapfile_maximum_size = arch_max_swapfile_size();

 	swap_slots_in_cluster = generic_swap_slots_in_clusters();
@@ -3939,6 +3962,24 @@ static int __init swapfile_init(void)
 					    SWAPFILE_CLUSTER),
 				    0, SLAB_PANIC | SLAB_TYPESAFE_BY_RCU, NULL);

+	percpu_swap_cluster = alloc_percpu(struct percpu_swap_cluster);
+	if (!percpu_swap_cluster)
+		panic("%s: alloc_percpu failed for percpu_swap_cluster\n", __func__);
+
+	for_each_possible_cpu(cpu) {
+		int node = cpu_to_mem(cpu);
+
+		pcp_sc = per_cpu_ptr(percpu_swap_cluster, cpu);
+		local_lock_init(&pcp_sc->lock);
+		pcp_sc->si = kcalloc_node(nr_orders, sizeof(*pcp_sc->si),
+					GFP_KERNEL, node);
+		pcp_sc->offset = kcalloc_node(nr_orders, sizeof(*pcp_sc->offset),
+					    GFP_KERNEL, node);
+		if (!pcp_sc->si || !pcp_sc->offset)
+			panic("%s: per-CPU kcalloc failed for cpu:%d, node:%d\n",
+					__func__, cpu, node);
+	}
+
 #ifdef CONFIG_MIGRATION
 	if (swapfile_maximum_size >= (1UL << SWP_MIG_TOTAL_BITS))
 		swap_migration_ad_supported = true;
--
2.39.5


