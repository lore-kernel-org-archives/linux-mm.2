Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87350C61DCB
	for <linux-mm@archiver.kernel.org>; Sat, 29 Aug 2026 07:48:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 893386B00AB; Sat, 29 Aug 2026 03:48:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 86B456B00AC; Sat, 29 Aug 2026 03:48:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 780826B00AD; Sat, 29 Aug 2026 03:48:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 53E726B00AB
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 03:48:31 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EEB8E1C21ED
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 07:48:30 +0000 (UTC)
X-FDA: 85153529580.03.7F10C93
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	by imf28.hostedemail.com (Postfix) with ESMTP id 26D72C0009
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 07:48:29 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="lWRUP5/l";
	spf=pass (imf28.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787989709;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Zmu3XpqP05NRue2fBxvw9Ta0ua8JaiA5G6dY6hEI5XE=;
	b=IwZJQz7KCLcjdByDN8HLCTMzKWoOA+z+OLnTe3Tuny3/rdC0jzAu4a06SkCtIjILgOW3Bg
	/pXyXjQPgKWNiHuqWPGiprUY69MYAlqaefy5otFOLklTttbt3twBM2nBcz0dphyjYXQbsO
	1V47WpAInFKZAvxtm4GxwyY16sN/GqU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787989709;
	b=flYPzeGfzgSYYDZEL8x2VYZmoNXnNa6CYCZrUm3F6xoAXmDT1nioQEznrsQWxBocsoEaL9
	D4uFmsTQlN3D8q5EEAmJKSAmwK+Q3TYLx2ocGivpx0txyHlbTWan0T+hfZJObtfxWu5TUI
	7uQghcMlyUNeGA4Uj5t3kBOfnqYq+go=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="lWRUP5/l";
	spf=pass (imf28.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-3968e063f84so1357645a91.0
        for <linux-mm@kvack.org>; Sat, 29 Aug 2026 00:48:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787989708; x=1788594508; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Zmu3XpqP05NRue2fBxvw9Ta0ua8JaiA5G6dY6hEI5XE=;
        b=lWRUP5/llZzTMjffVmhzngdsXAyOKJ5jniY234h9BwD9/21IjewJ5II1Wg6RCYVu4c
         KZ9mwWatLvDUp9W9XXjHbYvz+ycDg8HBm99gJnjE94pWMH34ykkHeu7fC1FiYckeAWJV
         l6WYjBjGwtjJC+26kpUv5WH4NiDtB4mK8J73JQVhTyfkWTOXyCumilconXYpcFuw2xiC
         jvcvT3W9VGeg3Xz2crg1oNr4OLCI4a51e2xISw0lcKeqV46skqTD3m9yYHsriHaH3bpo
         l5VppEzCbBX1bilUdvqjNgTArIN92aYlXm2LYZqUOxFtzYsWolla3AsrE3MbQLKD63m6
         SZlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787989708; x=1788594508;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Zmu3XpqP05NRue2fBxvw9Ta0ua8JaiA5G6dY6hEI5XE=;
        b=fvMllXilzOjDfjw3eC7HOLvovx/nV/2JXVTICyCJzsKeGq3F1yP8odCcJZZEi1A/7J
         DkA9i/8mCc90gDibI7/sP1qzR8c/c/Pgk+ljBh2W7JhiEgXaYZzYAWT/VFXWvUvnT+mE
         jCC0Z1ATfFB381Kmlfj6dzPiX02dM1/Bttg+rxEH212wAFXhjbNtZ9KAkeBXgwtohdyf
         6tjTnXwJ445eTXX6KuMc2wAeNPyx1DNOYiP324R7HWwJ+DZZy9ONkO0/pYgpaB1Z9/7H
         7el5swJ92uVO9QPGPYMnVAmkI4W95CxDaWDWgQL8D9xGpK/hPduZ9J3UVo+PF9YnwQp0
         fmZQ==
X-Gm-Message-State: AFuF++nXQB6c+U0iJRxrLovBR5oCyXIED0WujVs4jyPEkhuP5R5jZdgW
	HUClMgDXeO38eNu7CXGTiBzpKKya0vOsUP7pi5lH5PYSt9J0U15SApcSMJEPaw==
X-Gm-Gg: AYBFou115OLBVetsdM8Vn+v7nE1n9LgD82R4oSaVgZm8OEZiAm0bp74+fNwxMEtsLda
	V1mjToBA+HHYwXdLtVo1QxRaELtcwBxCn2nZDUyIvtm1evlkRK9pp4Rj4p6ISRNARQP2NsRWDfs
	KjmaHmfY348UrQNNM2twJ/Dr+jcX/Qs/bX7H0uC9OOaV46jIE5sHEzQNxV8/2+bMyoGKAoMLBmv
	dkMI6pvDlNX8NmnljzqVkirUWO3z30NzeQP4tu0Bzs6urrgvWfFEdFbZXsGftUJEIKP3ZONm+qw
	PxBB42w2/1uN0mzLEjnR+cII/icu93HAxndrpkZH9P6q0FBV5twfB6BmoXW8ra9FHdLuQak4mi1
	NZ7QU+78dwcE12kDzjYe4bc9aaWGUw9sBQzUrcEx8lCTGqP1KmTyqWoMBFssFxK+yZcw5oPzbqW
	D1agq9vyhbf3e7VOUMkninmU2h0YS7eOFAs6rNxt0iZfdAnrBkKj8UB1sjJKnLrHPpmMW8sc77Q
	S1A6dxnE3C+iXPVTFdDBtflJbR9dDs5L2icKMM=
X-Received: by 2002:a17:90b:52c8:b0:398:9bd1:3214 with SMTP id 98e67ed59e1d1-3989bd13874mr6809369a91.21.1787989707985;
        Sat, 29 Aug 2026 00:48:27 -0700 (PDT)
Received: from localhost.localdomain (vmi2317720.contaboserver.net. [84.247.152.65])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-396b0fd5c34sm10702719a91.8.2026.08.29.00.48.24
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 29 Aug 2026 00:48:27 -0700 (PDT)
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
	Kunwu Chan <kunwu.chan@linux.dev>
Subject: [RESEND RFC PATCH v2 11/13] mm/swap: bound synchronous discard during allocation
Date: Sat, 29 Aug 2026 15:48:20 +0800
Message-ID: <20260829-swap-pcp-priq-v2-resend-11-68d3d925578c@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260829-swap-pcp-priq-v2-resend-0-68d3d925578c@gmail.com>
References: <20260829-swap-pcp-priq-v2-resend-0-68d3d925578c@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 26D72C0009
X-Stat-Signature: ykchjqpw6peo5chxyopduhn9jd5zoiar
X-HE-Tag: 1787989709-117801
X-HE-Meta: U2FsdGVkX18EMar8uOYO8cMvF2pHx1sIdkAQBwv/AZdaE7AesxyrKmrkvXEJ/wXW6GfqYygjvngyfJUfBhSIZfLPUgRP0EjnRtprjkwteTrB3vmY/GFBLrxRNwzvIHIX/5lgfpkuHTuoB6QWERGEWo5R7w+MprtsEtEtFvXiS648VH7Q2WnuwljXHBa82yd0RY5lb36++rkZqfoMm7I1jpwkT3uKzAVMoFTFHSpp5jFLZWAo1q2CqLRLXDnYEeKBnpq9bZBGlASFI37x7Dy13vBjOkAAsiYxYkXx9BDd4YpsLde57w+yGLbfQEra5XvgU9qL7yV9gefp23luQn7clHjbBDNwmfjmAzvvIi3Nl8EE7uIvYY8caip4SnYkL9La8KXNutfhX13jbpvT9nCgd58Rz8kPdvtDw54343YDTx69gce8JOQGwIPXdpgmpd9ALS/UBK4becYHfSMXsDwwT5ddg6wOsgcT+/nWMtGFecndRaf59VPofgK5TfUJQ4e4IlEYJ6ZCe3CGeW0pA68CE5D4/PuiqQBZiMA7XnpN6R3IYP/c5UUCNgyXTFBejfU5rPsYkBkO7zDqoOkajEkspxMu0aY4rpVyU3vXLKCE1EL9j+TIuqH3u+4dX6UVtD1oAppRCd8x/21zMLayRtTbrU2ClSO5vDQfWDL+akEGb+tQ77J66dzeuREHSpmhCwA1mhF70VnVxjBUwQ9JetC+2BuSEzheWeo67VCqiofS8kHLd6l44cSUNhq7vmyt5JICb81GhYOgXKD7KXhRMZ3ZwUlf0FUhByH51wjWoMEOLinv324IFv/29+wfYPIQzLJy5C9JdtRVMZP03VISO5Ah4GToUeaP7Z6snugyDk3GCd1bpoBKpaxBvZCR4pDyrFYA1/YA1AArg5J1qbkfW4V6fL97Yz/zTXbVkAfxtlDujKTE4gZD8bu8hKu110dny0GooRLMED3ckRNEQLg4RKx
 a1wScxkE
 8/OGVRdNXum9wi4cjVvGi0QbuT8JHj27765qCFdB9RmERap8CXNPYkmLAPjnim8ruPsvaZs7Vs/3P9QU5Kmh1G6bPXsu59wefVWohWde6YVo8fi3ZKCKh2wlu97djQ4fdGsYKw6EGs0QO74KLAkaFPAEevHpsWoQgII7RT2tFpKtPi2ml558FssG4BtycILtdU4MeYYUScWdKE656Pkr1Mwd0RsSSw5fU2iGMPOkObk56DtoHIXSiNMM8MdPCdl6Va0wq4uED6mjM+p+fSQ3LVQQrTKUfzuGhFl4ZnWJVuk9ywSSCZwa5F42bJlXwj3jom0xyuDBmO1yEyCX7e8mTMP4VRulz3ppoHWXNIowM1iSYNfjcvsJ64Upmiocgt42MBc05MeNvSsupAG1Ys8bv1r0jntWhxMetf96fkpDupPHG36fwshTrxgnqhCF+f77FDRWP7KoMBIOQmBHC0/ECGydK1nH0QBnhEtt1iYUznnL2oNxMyyR5N8dBEw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

The old global per-CPU cluster cache made it difficult to select a
specific device before handling its pending discards.  Now that cluster
state is per-device, let an allocator issue discard for that device when
its free-cluster list is drained instead of waiting for a global fallback
scan.

Do not drain the entire discard list from one allocation.  The list is
also updated by freeing paths, so an unlocked non-empty check races with
those writers, and a full synchronous drain has no fixed latency bound
when other CPUs continue to enqueue clusters.

Factor out swap_discard_one_cluster().  Isolate one cluster under
si->lock, retain CLUSTER_FLAG_DISCARD while I/O is in flight, and return
it to the free list after the discard completes.  The background worker
continues looping until the list is empty, while an allocator handles at
most one cluster before retrying allocation.

This keeps the proactive per-device policy while giving each allocation
a fixed synchronous discard budget.

Link: https://lore.kernel.org/all/CAMgjq7CsYhEjvtN85XGkrONYAJxve7gG593TFeOGV-oax++kWA@mail.gmail.com/
Signed-off-by: Kairui Song <kasong@tencent.com>
Co-developed-by: Lian Wang (ProcessMission) <lianux.mm@gmail.com>
Signed-off-by: Lian Wang (ProcessMission) <lianux.mm@gmail.com>
Tested-by: Kunwu Chan <kunwu.chan@linux.dev>
---
 mm/swapfile.c | 149 ++++++++++++++++++++++----------------------------
 1 file changed, 64 insertions(+), 85 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index e183dfad264e..cb27f2e246f0 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -528,6 +528,26 @@ static long swap_usage_in_pages(struct swap_info_struct *si)
 	return atomic_long_read(&si->inuse_pages) & SWAP_USAGE_COUNTER_MASK;
 }
 
+/*
+ * Serialize the allocation on single CPU or globally to avoid
+ * fragmentation and make the workflow easier to follow.
+ */
+static void swap_alloc_lock_device(struct swap_info_struct *si)
+{
+	if (si->flags & SWP_SOLIDSTATE)
+		local_lock(&si->percpu_cluster->lock);
+	else
+		spin_lock(&si->global_cluster->lock);
+}
+
+static void swap_alloc_unlock_device(struct swap_info_struct *si)
+{
+	if (si->flags & SWP_SOLIDSTATE)
+		local_unlock(&si->percpu_cluster->lock);
+	else
+		spin_unlock(&si->global_cluster->lock);
+}
+
 /* Reclaim the swap entry anyway if possible */
 #define TTRS_ANYWAY		0x1
 /*
@@ -914,10 +934,7 @@ swap_cluster_populate(struct swap_info_struct *si,
 	 * the potential recursive allocation is limited.
 	 */
 	spin_unlock(&ci->lock);
-	if (si->flags & SWP_SOLIDSTATE)
-		local_unlock(&si->percpu_cluster->lock);
-	else
-		spin_unlock(&si->global_cluster->lock);
+	swap_alloc_unlock_device(si);
 
 	ret = swap_cluster_alloc_table(ci, __GFP_HIGH | __GFP_NOMEMALLOC |
 					   GFP_KERNEL);
@@ -930,10 +947,7 @@ swap_cluster_populate(struct swap_info_struct *si,
 	 * could happen with ignoring the percpu cluster is fragmentation,
 	 * which is acceptable since this fallback and race is rare.
 	 */
-	if (si->flags & SWP_SOLIDSTATE)
-		local_lock(&si->percpu_cluster->lock);
-	else
-		spin_lock(&si->global_cluster->lock);
+	swap_alloc_lock_device(si);
 	spin_lock(&ci->lock);
 
 	if (ret) {
@@ -1023,44 +1037,40 @@ static struct swap_cluster_info *isolate_lock_cluster(
 }
 
 /*
- * Doing discard actually. After a cluster discard is finished, the cluster
- * will be added to free cluster list. Discard cluster is a bit special as
- * they don't participate in allocation or reclaim, so clusters marked as
- * CLUSTER_FLAG_DISCARD must remain off-list or on discard list.
+ * Discard one cluster. After the discard is finished, the cluster will be
+ * added to the free cluster list. Discard clusters are special because they
+ * don't participate in allocation or reclaim, so CLUSTER_FLAG_DISCARD must
+ * remain set while a cluster is either queued or being discarded.
  */
-static bool swap_do_scheduled_discard(struct swap_info_struct *si)
+static bool swap_discard_one_cluster(struct swap_info_struct *si)
 {
 	struct swap_cluster_info *ci;
-	bool ret = false;
 	unsigned int idx;
 
 	spin_lock(&si->lock);
-	while (!list_empty(&si->discard_clusters)) {
-		ci = list_first_entry(&si->discard_clusters, struct swap_cluster_info, list);
-		/*
-		 * Delete the cluster from list to prepare for discard, but keep
-		 * the CLUSTER_FLAG_DISCARD flag, there could be percpu_cluster
-		 * pointing to it, or ran into by relocate_cluster.
-		 */
-		list_del(&ci->list);
-		idx = cluster_index(si, ci);
+	if (list_empty(&si->discard_clusters)) {
 		spin_unlock(&si->lock);
-		discard_swap_cluster(si, idx * SWAPFILE_CLUSTER,
-				SWAPFILE_CLUSTER);
-
-		spin_lock(&ci->lock);
-		/*
-		 * Discard is done, clear its flags as it's off-list, then
-		 * return the cluster to allocation list.
-		 */
-		ci->flags = CLUSTER_FLAG_NONE;
-		__free_cluster(si, ci);
-		spin_unlock(&ci->lock);
-		ret = true;
-		spin_lock(&si->lock);
+		return false;
 	}
+
+	ci = list_first_entry(&si->discard_clusters,
+			      struct swap_cluster_info, list);
+	/*
+	 * Delete the cluster from the list, but keep CLUSTER_FLAG_DISCARD
+	 * set while the discard is in flight. A percpu cluster may still
+	 * point to it, or relocate_cluster() may encounter it.
+	 */
+	list_del(&ci->list);
+	idx = cluster_index(si, ci);
 	spin_unlock(&si->lock);
-	return ret;
+
+	discard_swap_cluster(si, idx * SWAPFILE_CLUSTER, SWAPFILE_CLUSTER);
+
+	spin_lock(&ci->lock);
+	ci->flags = CLUSTER_FLAG_NONE;
+	__free_cluster(si, ci);
+	spin_unlock(&ci->lock);
+	return true;
 }
 
 static void swap_discard_work(struct work_struct *work)
@@ -1069,7 +1079,8 @@ static void swap_discard_work(struct work_struct *work)
 
 	si = container_of(work, struct swap_info_struct, discard_work);
 
-	swap_do_scheduled_discard(si);
+	while (swap_discard_one_cluster(si))
+		cond_resched();
 }
 
 static void swap_users_ref_free(struct percpu_ref *ref)
@@ -1467,6 +1478,7 @@ static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si,
 	struct swap_cluster_info *ci;
 	unsigned int order = likely(folio) ? folio_order(folio) : 0;
 	unsigned int offset = SWAP_ENTRY_INVALID, found = SWAP_ENTRY_INVALID;
+	bool discarded = false;
 
 	/*
 	 * Swapfile is not block device so unable
@@ -1475,15 +1487,12 @@ static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si,
 	if (order && !(si->flags & SWP_BLKDEV))
 		return 0;
 
-	if (si->flags & SWP_SOLIDSTATE) {
-		/* Fast path using per CPU cluster */
-		local_lock(&si->percpu_cluster->lock);
+restart:
+	swap_alloc_lock_device(si);
+	if (si->flags & SWP_SOLIDSTATE)
 		offset = __this_cpu_read(si->percpu_cluster->next[order]);
-	} else {
-		/* Serialize HDD SWAP allocation for each device. */
-		spin_lock(&si->global_cluster->lock);
+	else
 		offset = si->global_cluster->next[order];
-	}
 
 	if (offset != SWAP_ENTRY_INVALID) {
 		ci = swap_cluster_lock(si, offset);
@@ -1507,6 +1516,15 @@ static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si,
 		found = alloc_swap_scan_list(si, &si->free_clusters, folio, false);
 		if (found)
 			goto done;
+
+		if (!discarded) {
+			swap_alloc_unlock_device(si);
+			if (swap_discard_one_cluster(si)) {
+				discarded = true;
+				goto restart;
+			}
+			swap_alloc_lock_device(si);
+		}
 	}
 
 	if (order < PMD_ORDER) {
@@ -1555,10 +1573,7 @@ static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si,
 			goto done;
 	}
 done:
-	if (si->flags & SWP_SOLIDSTATE)
-		local_unlock(&si->percpu_cluster->lock);
-	else
-		spin_unlock(&si->global_cluster->lock);
+	swap_alloc_unlock_device(si);
 
 	return found;
 }
@@ -1751,36 +1766,6 @@ static int swap_alloc_entry(struct folio *folio)
 	return ret;
 }
 
-/*
- * Discard pending clusters in a synchronized way when under high pressure.
- * Return: true if any cluster is discarded.
- */
-static bool swap_sync_discard(void)
-{
-	bool ret = false;
-	struct swap_info_struct *si, *next;
-
-	percpu_down_read(&swapon_rwsem);
-start_over:
-	plist_for_each_entry_safe(si, next, &swap_active_head, list) {
-		percpu_up_read(&swapon_rwsem);
-		if (get_swap_device_info(si)) {
-			if (si->flags & SWP_PAGE_DISCARD)
-				ret = swap_do_scheduled_discard(si);
-			put_swap_device(si);
-		}
-		if (ret)
-			return true;
-
-		percpu_down_read(&swapon_rwsem);
-		if (plist_node_empty(&next->list))
-			goto start_over;
-	}
-	percpu_up_read(&swapon_rwsem);
-
-	return false;
-}
-
 static int swap_extend_table_alloc(struct swap_info_struct *si,
 				   struct swap_cluster_info *ci,
 				   unsigned int ci_off, gfp_t gfp)
@@ -2085,14 +2070,8 @@ int folio_alloc_swap(struct folio *folio)
 		}
 	}
 
-again:
 	ret = swap_alloc_entry(folio);
 
-	if (!order && unlikely(!folio_test_swapcache(folio))) {
-		if (swap_sync_discard())
-			goto again;
-	}
-
 	/* Need to call this even if allocation failed, for MEMCG_SWAP_FAIL. */
 	if (unlikely(mem_cgroup_try_charge_swap(folio)))
 		swap_cache_del_folio(folio);
-- 
2.55.0


