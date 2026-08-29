Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 995A1C61DD7
	for <linux-mm@archiver.kernel.org>; Sat, 29 Aug 2026 07:48:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A8E856B00A3; Sat, 29 Aug 2026 03:48:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A3F356B00A4; Sat, 29 Aug 2026 03:48:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 956026B00A5; Sat, 29 Aug 2026 03:48:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 66AC36B00A3
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 03:48:06 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E28D81C17C2
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 07:48:05 +0000 (UTC)
X-FDA: 85153528530.07.A46722A
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	by imf01.hostedemail.com (Postfix) with ESMTP id 20EF040002
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 07:48:04 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=FeJq79XP;
	spf=pass (imf01.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787989684;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e3pO0sfpG3DfTZP/kIIBTuTwDNPHKJvFu4PoPkWSsN0=;
	b=7sRDEQOmiKftP+7Ud5jXzyQK9vSNbK8d+g96y/RdDu/2Dsb1Rwa89LvGW+v7Zpgl8wRj9N
	VL18gS0JsK7xhosZetustvkusmqLH8Lsi5Oq7JZJDRooyxLFGjLE1VJj8pB4RMMyM8Joqt
	/97+77kPC77wiJ/+1t6qBDKihuEgPzk=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=FeJq79XP;
	spf=pass (imf01.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787989684;
	b=V+DDIMQxgI4C8MxM4HkNWHtrgqU4xPjVTQUjXM4+48p5FLuDDdrrQ67OL5EPrG4EFaeGKr
	og4BU9vM2+2o2g8/IZ1frZdEqzdpJffvR7NFlLCuzLRY3PR6Xo0n4fh/oghGUBDPUDmgHx
	dXMEtnf7PmC3h102Vk7u+6b8kQELKQY=
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2d5cad1a6baso16732625ad.3
        for <linux-mm@kvack.org>; Sat, 29 Aug 2026 00:48:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787989683; x=1788594483; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=e3pO0sfpG3DfTZP/kIIBTuTwDNPHKJvFu4PoPkWSsN0=;
        b=FeJq79XPj+H5F8+kTbpAkm8VnZDeYhyzSwS+YCUTVo6iCGBBDbRoR0Yr6c368TlH14
         nqlaZ1IsJv+9xInD/FqA0kRNhYmK5WfC5h6F/ADB4tymy/qggq02wnY16hh6IN5FfhoQ
         1FC/2y0ABfyja2LrwXN8hdiEUk3nzEATKrp+QGUF9DkaZdynOwryPQQ7msqCBy8qimN2
         EGULkiGYFl6+YRr4a4+U4J8uJJS/MeiWOhnQ8LUkSX9DLKAHoBFR6AWxsTRFIE+2OZUv
         YLeAqhob0id9LGEoKlRwX+ZdWSiIg9zwSlO26tUDc2xRBqKaK7wmU7C4///AngudlXaG
         HzsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787989683; x=1788594483;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=e3pO0sfpG3DfTZP/kIIBTuTwDNPHKJvFu4PoPkWSsN0=;
        b=AJPXaW+T+Yl5nEml/tchlvC1c/ygOTXoKkYwyaq/wYKIoVQPRppXMSptzr0cfgIZ8E
         6vtXtL/+cPH6Yj64vDnixPYWSdhqpJ39iLYmxkrA2g/1A/QCgqu3wkH8UFZm7uUdqGZ2
         jFLgQo0arVFik8HzFFcZh9pmB1TSuZBNCBCIASwN+gwdl1DunFY0QU455tf6Hhq6MEkJ
         k8UTeH1+Ba9NLbgsdLgJPH0ut1/r+Nu0yGXO6s0V9TM+Tap3lNZey+3pTjK32qZsUJzq
         siDDSsm16JKmw8SYd1QBUE3lI+jsjm4p5Ii/HloZB4p/OtVlC1eGMAO5bj04g2utNjlW
         aiIQ==
X-Gm-Message-State: AFuF++nxL8oVlneozLm3m02Udn2D5D6F9Wqwq8baQfILqZkqdWncGU4W
	cGUdRvu1bFIYYWXC4pnd8aEDlaIx7acMw0blIzA4Q0CD4W13N9ybIK/hAA1Yug==
X-Gm-Gg: AYBFou3kbnuLB4ApyR5b8rMF+3W9AjX1kNMpz2NfAnpyri4wxMM9ZOM/11PELjJngC1
	eU3cyn1k4UV0f7UzAjPkgV4O3J1hhnP4I4efRtmRNQ5/Mn0WpMpiNz24g7iOvG1yxVXNQ8SnouM
	64ctw8eNHXIzvuhV9e+PmhIIZIXJlyeYZQgc/ebxuUAG7LrLtKzNvSVp6O6crrklUrkQDpQR0wq
	GpX2lM+QifcKbdsMyMxZOnwi2hGiQ0Pupr641Z9xFWPI0FTtSKzc6GO6GIyrFz/c6BUOzH69S7u
	HZh1fZLmc/yhXnMbWYyE9r/JiE3A68BDdr/6k/+xvYRonIqZcTP901eeYB/CnQWNLTBy4jAxIqL
	a8Yjham/OydWZCEcAIlXKDaocIpa9lTNINUaZroh6emtdcsNwLLydZsAEymyLH05pxQ4IdQ0b1x
	qsuDqUd4rqSEvw2YLBctcIfIJ/IjQx5KOBa4haZmMrdwbzF9bNZOr1Fti5RWgH8YeNda7P2+Zwy
	2rTEI2r/Xap/PIyeE9Hs+X2NaTh
X-Received: by 2002:a17:902:da89:b0:2d8:d4d3:da52 with SMTP id d9443c01a7336-2d8d4d3db4cmr65289365ad.22.1787989682717;
        Sat, 29 Aug 2026 00:48:02 -0700 (PDT)
Received: from localhost.localdomain (vmi2317720.contaboserver.net. [84.247.152.65])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d7594fb1c3sm12506505ad.1.2026.08.29.00.47.57
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 29 Aug 2026 00:48:02 -0700 (PDT)
From: "Lian Wang (ProcessMission)" <lianux.mm@gmail.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Kairui Song <kasong@tencent.com>,
	Jihan LIN <linjh22s@gmail.com>,
	Kunwu Chan <kunwu.chan@linux.dev>,
	Baoquan He <bhe@redhat.com>
Subject: [RESEND RFC PATCH v2 08/13] mm/swap: change back to use each swap device's percpu cluster
Date: Sat, 29 Aug 2026 15:47:54 +0800
Message-ID: <20260829-swap-pcp-priq-v2-resend-8-68d3d925578c@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260829-swap-pcp-priq-v2-resend-0-68d3d925578c@gmail.com>
References: <20260829-swap-pcp-priq-v2-resend-0-68d3d925578c@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: kwujs496f13r6o396bt77f96cjpfx1fj
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 20EF040002
X-Rspam-User: 
X-HE-Tag: 1787989684-320020
X-HE-Meta: U2FsdGVkX1/YobaEvbg0e+vFTWWdTDKnOmGDNcyK6syExEt5orWCrFns1yhayxWzIIBdtuGL+c60/AA0Y0r8/1Fq9+4ZkX1cVEhsz+yTMM/0TqkaOs1oK0LO0pb6G+kZB8VIo1jYgiKHIin+09HGZUBozsmSlpOU9+7y6/fMV/1ibG1GNhO95k7AktG/rZjSPK5Vd+wOA4A6DMCZXM5emKB2X1AMiB5OMhgJ/Z9/MGmA5r6nV3FKVWk9WaqM5IaIrls4uwsxffXa0i8tw4zkvow2MiiLfJmVql7oemOkTXs9YD7JCzKuCoJTzuMjut76UXQZtFbDgQt2tNPmfQ+NLiRqFwBsBhi+2bLN+QFuni6S0FnCF4MkCsaKCWOTgHxLzLKzpi2eD0UKVdW3udAu+6f55IPncvFUgtp9/FMKMEQAg3j/isGMtMbpljk17xkUf4orTryvASM1cfrrlX91OXa/s8VMofHcp3XL8fNFaTgv6eIgji1wpabN7w2NJeUyqEvieU0oMoiyHQ30yeWWeSqRXX9gV32W0LQJxp9N19OLVYFeQCtapcb9x/xXR6bWXWGNQEq8qJvPz4hG38jJ4WrDvmJWKkzI2hUjGhD+Ti3rp3OTLTX8Za/6h2iUYDlXjbaGP6wYha7E7KzFWju8ujwxPmtPD/lzE0L2pNgIHMMwYL/Al04DUUivi2izGTR/OpC7eccDRuS3DrQAtA9M0Mz+hH979C36rK+ALpz5U7qOcWsFHXBjgGBGNiW+GqGI61n/61mogor5Q4BNTDGUi96BCfm8O6ere9/ajZ1Of2N6mY92AuYIpDbMAuQyhFS8PKTwXKyn2nr6+zIMA20BsvhAoM+V32bUJtaLQWBdgdxDcOXBVKgOO4NOQcWSP+XT+bSl8AFBwYmuU3vlNlnwCUdWA+IPGqflE9JpirVeMTeuAVr8+LMrJklYrCPuY8nycDpx+1tEzYA+UVa6+nr
 QC+IMm5m
 8gu1ZjRmuJO/tioaH7PPSqEKC0AN4rRp0vrsCl1mL3m4oHlDKwWjid90gNlwmNTXOG+85HDj6WuhxQA87l8M/fLSyQbgh80YW4eSLDKqQTUzA6/ztCkbQRHEvWrM+zhmjBE+HbuL47MYPY7x8cDGfrgmuulQ/3cEzmJm9bVYA25FJQqoo75kyYffiUENZzcbO8TG1shOYTXGw6MpPdCjUewJwqcQZp4ZK2nxq+7lX7HYUTnFK8y5HvRgzSoPwfx6q2kqXvcXTiWUwaC0WQkO4XU8SfTShKhVLB7A6yGzTK2Z3WrVrieERTJj1fhIQDPoPg40wES3wJkflrvezRFvXOcRhZmc/fA/O0XUnC18olhxWhqe4RRlKj/Z0aqeCyKt1QoK3dhaPZsCn2S5euLlkJByQMTNdRKXvkUEJhuJYQxq4MRu8rxAOtM+HBXuXCBXcpvV3qbrwu0YAjDWhT/LoLJ5mt9C01Ax+m4QgwfFWg4miMmBvvCWNyK/MoQezNQW+X/1Bl4hWzfD9pzE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Youngjun Park <youngjun.park@lge.com>

This reverts commit 1b7e90020eb7 ("mm, swap: use percpu cluster as
allocation fast path").

The global percpu cluster causes several issues:

1) It prevents efficient swap allocation for users that do not want
   the default swap device policy.  Because the cluster cache sits
   above device selection, all allocation users must stick with the
   default allocation policy.  This fundamentally conflicts with
   incoming ideas like swap tiering.

2) It can cause priority inversion.  Consider two memcgs: memcg1 can
   access devices A and B, where A has higher priority; memcg2 can
   only access B.  Memcg2 can write the global percpu cluster with
   device B, then memcg1 takes B in the fast path even though
   higher-priority device A is not exhausted.

3) The fast-path / slow-path design bundled with the global per-CPU
   cache is problematic: only the fast path uses the global cache,
   and the slow path is forced to rotate the allocation list.  This
   complicates consumers like discard.

Revert to per-device percpu clusters first.  A later patch will
introduce new infrastructure for a high-performance global
allocation path.

Suggested-by: Kairui Song <kasong@tencent.com>
Co-developed-by: Baoquan He <bhe@redhat.com>
Signed-off-by: Baoquan He <bhe@redhat.com>
Signed-off-by: Youngjun Park <youngjun.park@lge.com>
Signed-off-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Lian Wang (ProcessMission) <lianux.mm@gmail.com>
Tested-by: Kunwu Chan <kunwu.chan@linux.dev>
---
 include/linux/swap.h |  13 ++-
 mm/swapfile.c        | 184 +++++++++++++++----------------------------
 2 files changed, 72 insertions(+), 125 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 7b8ba0d1903f..aa66d8454186 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -245,10 +245,17 @@ enum {
 #endif
 
 /*
- * We keep using same cluster for rotational device so IO will be sequential.
- * The purpose is to optimize SWAP throughput on these device.
+ * We assign a cluster to each CPU, so each CPU can allocate swap entry from
+ * its own cluster and swapout sequentially. The purpose is to optimize swapout
+ * throughput.
  */
+struct percpu_cluster {
+	local_lock_t lock; /* Protect the percpu_cluster above */
+	unsigned int next[SWAP_NR_ORDERS]; /* Likely next allocation offset */
+};
+
 struct swap_sequential_cluster {
+	spinlock_t lock; /* Serialize usage of global cluster */
 	unsigned int next[SWAP_NR_ORDERS]; /* Likely next allocation offset */
 };
 
@@ -271,8 +278,8 @@ struct swap_info_struct {
 					/* list of cluster that are fragmented or contented */
 	unsigned int pages;		/* total of usable pages of swap */
 	atomic_long_t inuse_pages;	/* number of those currently in use */
+	struct percpu_cluster	__percpu *percpu_cluster; /* per cpu's swap location */
 	struct swap_sequential_cluster *global_cluster; /* Use one global cluster for rotating device */
-	spinlock_t global_cluster_lock;	/* Serialize usage of global cluster */
 	struct rb_root swap_extent_root;/* root of the swap extent rbtree */
 	struct block_device *bdev;	/* swap device or bdev of swap file */
 	struct file *swap_file;		/* seldom referenced */
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 1fa6945d6415..79ecff2d0bd3 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -146,18 +146,6 @@ static atomic_t proc_poll_event = ATOMIC_INIT(0);
 
 atomic_t nr_rotate_swap = ATOMIC_INIT(0);
 
-struct percpu_swap_cluster {
-	struct swap_info_struct *si[SWAP_NR_ORDERS];
-	unsigned long offset[SWAP_NR_ORDERS];
-	local_lock_t lock;
-};
-
-static DEFINE_PER_CPU(struct percpu_swap_cluster, percpu_swap_cluster) = {
-	.si = { NULL },
-	.offset = { SWAP_ENTRY_INVALID },
-	.lock = INIT_LOCAL_LOCK(),
-};
-
 /* May return NULL on invalid type, caller must check for NULL return */
 static struct swap_info_struct *swap_type_to_info(int type)
 {
@@ -562,9 +550,10 @@ swap_cluster_populate(struct swap_info_struct *si,
 	 * Only cluster isolation from the allocator does table allocation.
 	 * Swap allocator uses percpu clusters and holds the local lock.
 	 */
-	lockdep_assert_held(&this_cpu_ptr(&percpu_swap_cluster)->lock);
-	if (!(si->flags & SWP_SOLIDSTATE))
-		lockdep_assert_held(&si->global_cluster_lock);
+	if (si->flags & SWP_SOLIDSTATE)
+		lockdep_assert_held(this_cpu_ptr(&si->percpu_cluster->lock));
+	else
+		lockdep_assert_held(&si->global_cluster->lock);
 	lockdep_assert_held(&ci->lock);
 
 	if (!swap_cluster_alloc_table(ci, __GFP_HIGH | __GFP_NOMEMALLOC |
@@ -577,9 +566,10 @@ swap_cluster_populate(struct swap_info_struct *si,
 	 * the potential recursive allocation is limited.
 	 */
 	spin_unlock(&ci->lock);
-	if (!(si->flags & SWP_SOLIDSTATE))
-		spin_unlock(&si->global_cluster_lock);
-	local_unlock(&percpu_swap_cluster.lock);
+	if (si->flags & SWP_SOLIDSTATE)
+		local_unlock(&si->percpu_cluster->lock);
+	else
+		spin_unlock(&si->global_cluster->lock);
 
 	ret = swap_cluster_alloc_table(ci, __GFP_HIGH | __GFP_NOMEMALLOC |
 					   GFP_KERNEL);
@@ -592,9 +582,10 @@ swap_cluster_populate(struct swap_info_struct *si,
 	 * could happen with ignoring the percpu cluster is fragmentation,
 	 * which is acceptable since this fallback and race is rare.
 	 */
-	local_lock(&percpu_swap_cluster.lock);
-	if (!(si->flags & SWP_SOLIDSTATE))
-		spin_lock(&si->global_cluster_lock);
+	if (si->flags & SWP_SOLIDSTATE)
+		local_lock(&si->percpu_cluster->lock);
+	else
+		spin_lock(&si->global_cluster->lock);
 	spin_lock(&ci->lock);
 
 	if (ret) {
@@ -700,7 +691,7 @@ static bool swap_do_scheduled_discard(struct swap_info_struct *si)
 		ci = list_first_entry(&si->discard_clusters, struct swap_cluster_info, list);
 		/*
 		 * Delete the cluster from list to prepare for discard, but keep
-		 * the CLUSTER_FLAG_DISCARD flag, percpu_swap_cluster could be
+		 * the CLUSTER_FLAG_DISCARD flag, there could be percpu_cluster
 		 * pointing to it, or ran into by relocate_cluster.
 		 */
 		list_del(&ci->list);
@@ -1032,12 +1023,10 @@ static unsigned int alloc_swap_scan_cluster(struct swap_info_struct *si,
 out:
 	relocate_cluster(si, ci);
 	swap_cluster_unlock(ci);
-	if (si->flags & SWP_SOLIDSTATE) {
-		this_cpu_write(percpu_swap_cluster.offset[order], next);
-		this_cpu_write(percpu_swap_cluster.si[order], si);
-	} else {
+	if (si->flags & SWP_SOLIDSTATE)
+		this_cpu_write(si->percpu_cluster->next[order], next);
+	else
 		si->global_cluster->next[order] = next;
-	}
 	return found;
 }
 
@@ -1138,13 +1127,17 @@ static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si,
 	if (order && !(si->flags & SWP_BLKDEV))
 		return 0;
 
-	if (!(si->flags & SWP_SOLIDSTATE)) {
+	if (si->flags & SWP_SOLIDSTATE) {
+		/* Fast path using per CPU cluster */
+		local_lock(&si->percpu_cluster->lock);
+		offset = __this_cpu_read(si->percpu_cluster->next[order]);
+	} else {
 		/* Serialize HDD SWAP allocation for each device. */
-		spin_lock(&si->global_cluster_lock);
+		spin_lock(&si->global_cluster->lock);
 		offset = si->global_cluster->next[order];
-		if (offset == SWAP_ENTRY_INVALID)
-			goto new_cluster;
+	}
 
+	if (offset != SWAP_ENTRY_INVALID) {
 		ci = swap_cluster_lock(si, offset);
 		/* Cluster could have been used by another order */
 		if (cluster_is_usable(ci, order)) {
@@ -1158,7 +1151,6 @@ static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si,
 			goto done;
 	}
 
-new_cluster:
 	/*
 	 * If the device need discard, prefer new cluster over nonfull
 	 * to spread out the writes.
@@ -1215,8 +1207,10 @@ static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si,
 			goto done;
 	}
 done:
-	if (!(si->flags & SWP_SOLIDSTATE))
-		spin_unlock(&si->global_cluster_lock);
+	if (si->flags & SWP_SOLIDSTATE)
+		local_unlock(&si->percpu_cluster->lock);
+	else
+		spin_unlock(&si->global_cluster->lock);
 
 	return found;
 }
@@ -1371,41 +1365,8 @@ static bool get_swap_device_info(struct swap_info_struct *si)
 	return true;
 }
 
-/*
- * Fast path try to get swap entries with specified order from current
- * CPU's swap entry pool (a cluster).
- */
-static bool swap_alloc_fast(struct folio *folio)
-{
-	unsigned int order = folio_order(folio);
-	struct swap_cluster_info *ci;
-	struct swap_info_struct *si;
-	unsigned int offset;
-
-	/*
-	 * Once allocated, swap_info_struct will never be completely freed,
-	 * so checking it's liveness by get_swap_device_info is enough.
-	 */
-	si = this_cpu_read(percpu_swap_cluster.si[order]);
-	offset = this_cpu_read(percpu_swap_cluster.offset[order]);
-	if (!si || !offset || !get_swap_device_info(si))
-		return false;
-
-	ci = swap_cluster_lock(si, offset);
-	if (cluster_is_usable(ci, order)) {
-		if (cluster_is_empty(ci))
-			offset = cluster_offset(si, ci);
-		alloc_swap_scan_cluster(si, ci, folio, offset);
-	} else {
-		swap_cluster_unlock(ci);
-	}
-
-	put_swap_device(si);
-	return folio_test_swapcache(folio);
-}
-
 /* Rotate the device and switch to a new cluster */
-static void swap_alloc_slow(struct folio *folio)
+static void swap_alloc_entry(struct folio *folio)
 {
 	struct swap_info_struct *si, *next;
 
@@ -1775,10 +1736,7 @@ int folio_alloc_swap(struct folio *folio)
 	}
 
 again:
-	local_lock(&percpu_swap_cluster.lock);
-	if (!swap_alloc_fast(folio))
-		swap_alloc_slow(folio);
-	local_unlock(&percpu_swap_cluster.lock);
+	swap_alloc_entry(folio);
 
 	if (!order && unlikely(!folio_test_swapcache(folio))) {
 		if (swap_sync_discard())
@@ -2167,31 +2125,14 @@ void swap_put_entries_direct(swp_entry_t entry, int nr)
  */
 swp_entry_t swap_alloc_hibernation_slot(int type)
 {
-	struct swap_info_struct *pcp_si, *si = swap_type_to_info(type);
-	unsigned long pcp_offset, offset = SWAP_ENTRY_INVALID;
-	struct swap_cluster_info *ci;
+	struct swap_info_struct *si = swap_type_to_info(type);
+	unsigned long offset = SWAP_ENTRY_INVALID;
 	swp_entry_t entry = {0};
 
 	if (!si)
 		goto fail;
 
-	/*
-	 * Try the local cluster first if it matches the device. If
-	 * not, try grab a new cluster and override local cluster.
-	 */
-	local_lock(&percpu_swap_cluster.lock);
-	pcp_si = this_cpu_read(percpu_swap_cluster.si[0]);
-	pcp_offset = this_cpu_read(percpu_swap_cluster.offset[0]);
-	if (pcp_si == si && pcp_offset) {
-		ci = swap_cluster_lock(si, pcp_offset);
-		if (cluster_is_usable(ci, 0))
-			offset = alloc_swap_scan_cluster(si, ci, NULL, pcp_offset);
-		else
-			swap_cluster_unlock(ci);
-	}
-	if (!offset)
-		offset = cluster_alloc_swap_entry(si, NULL);
-	local_unlock(&percpu_swap_cluster.lock);
+	offset = cluster_alloc_swap_entry(si, NULL);
 	if (offset)
 		entry = swp_entry(si->type, offset);
 
@@ -3082,27 +3023,6 @@ static void free_swap_cluster_info(struct swap_cluster_info *cluster_info,
 	kvfree(cluster_info);
 }
 
-/*
- * Called after swap device's reference count is dead, so
- * neither scan nor allocation will use it.
- */
-static void flush_percpu_swap_cluster(struct swap_info_struct *si)
-{
-	int cpu, i;
-	struct swap_info_struct **pcp_si;
-
-	for_each_possible_cpu(cpu) {
-		pcp_si = per_cpu_ptr(percpu_swap_cluster.si, cpu);
-		/*
-		 * Invalidate the percpu swap cluster cache, si->users
-		 * is dead, so no new user will point to it, just flush
-		 * any existing user.
-		 */
-		for (i = 0; i < SWAP_NR_ORDERS; i++)
-			cmpxchg(&pcp_si[i], si, NULL);
-	}
-}
-
 SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 {
 	struct swap_info_struct *p = NULL;
@@ -3154,7 +3074,6 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 
 	flush_work(&p->discard_work);
 	flush_work(&p->reclaim_work);
-	flush_percpu_swap_cluster(p);
 
 	destroy_swap_extents(p, p->swap_file);
 
@@ -3175,6 +3094,8 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 	percpu_up_write(&swapon_rwsem);
 	arch_swap_invalidate_area(p->type);
 	zswap_swapoff(p->type);
+	free_percpu(p->percpu_cluster);
+	p->percpu_cluster = NULL;
 	kfree(p->global_cluster);
 	p->global_cluster = NULL;
 	free_swap_cluster_info(cluster_info, maxpages);
@@ -3523,7 +3444,7 @@ static int setup_swap_clusters_info(struct swap_info_struct *si,
 {
 	unsigned long nr_clusters = DIV_ROUND_UP(maxpages, SWAPFILE_CLUSTER);
 	struct swap_cluster_info *cluster_info;
-	int err = -ENOMEM;
+	int cpu, err = -ENOMEM;
 	unsigned long i;
 
 	cluster_info = kvzalloc_objs(*cluster_info, nr_clusters);
@@ -3533,13 +3454,26 @@ static int setup_swap_clusters_info(struct swap_info_struct *si,
 	for (i = 0; i < nr_clusters; i++)
 		spin_lock_init(&cluster_info[i].lock);
 
-	if (!(si->flags & SWP_SOLIDSTATE)) {
+	if (si->flags & SWP_SOLIDSTATE) {
+		si->percpu_cluster = alloc_percpu(struct percpu_cluster);
+		if (!si->percpu_cluster)
+			goto err;
+
+		for_each_possible_cpu(cpu) {
+			struct percpu_cluster *cluster;
+
+			cluster = per_cpu_ptr(si->percpu_cluster, cpu);
+			for (i = 0; i < SWAP_NR_ORDERS; i++)
+				cluster->next[i] = SWAP_ENTRY_INVALID;
+			local_lock_init(&cluster->lock);
+		}
+	} else {
 		si->global_cluster = kmalloc_obj(*si->global_cluster);
 		if (!si->global_cluster)
 			goto err;
 		for (i = 0; i < SWAP_NR_ORDERS; i++)
 			si->global_cluster->next[i] = SWAP_ENTRY_INVALID;
-		spin_lock_init(&si->global_cluster_lock);
+		spin_lock_init(&si->global_cluster->lock);
 	}
 
 	/*
@@ -3708,11 +3642,6 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 
 	maxpages = si->max;
 
-	/* Set up the swap cluster info */
-	error = setup_swap_clusters_info(si, swap_header, maxpages);
-	if (error)
-		goto bad_swap_unlock_inode;
-
 	if (si->bdev && bdev_stable_writes(si->bdev))
 		si->flags |= SWP_STABLE_WRITES;
 
@@ -3726,6 +3655,15 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 		inced_nr_rotate_swap = true;
 	}
 
+	/*
+	 * Set up the swap cluster info. This must run after SWP_SOLIDSTATE
+	 * is determined above, as it decides whether to allocate the per-CPU
+	 * cluster (solid state) or the global cluster (rotational).
+	 */
+	error = setup_swap_clusters_info(si, swap_header, maxpages);
+	if (error)
+		goto bad_swap_unlock_inode;
+
 	if ((swap_flags & SWAP_FLAG_DISCARD) &&
 	    si->bdev && bdev_max_discard_sectors(si->bdev)) {
 		/*
@@ -3807,6 +3745,8 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 bad_swap_unlock_inode:
 	inode_unlock(inode);
 bad_swap:
+	free_percpu(si->percpu_cluster);
+	si->percpu_cluster = NULL;
 	kfree(si->global_cluster);
 	si->global_cluster = NULL;
 	inode = NULL;
-- 
2.55.0


