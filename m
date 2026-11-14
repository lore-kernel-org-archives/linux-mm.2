Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A669606A327
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 14:50:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Sccli7hW
Received: by kanga.kvack.org (Postfix)
	id 36DD66B05BE; Sat, 14 Nov 2026 09:50:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 31DF46B05BF; Sat, 14 Nov 2026 09:50:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BEA06B05C0; Sat, 14 Nov 2026 09:50:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E0A806B05BE
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 09:50:42 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 69F13140427
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 14:50:42 +0000 (UTC)
X-FDA: 85434011124.26.632CDDC
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	by imf24.hostedemail.com (Postfix) with ESMTP id 8901B180004
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 14:50:40 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=Sccli7hW;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.210.180 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794667840;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=at5RjVFnb0nLG0yNWBL2prGnwvhHWrO+XxTNCCu9nPs=;
	b=HtlzP7rmDxdTMCARmBh2WFXGTxlpXnSlxh823biapNQbhuKt1zMrgsU5Az1B65CVaFDtYS
	s2ei/VD47jsFbEhNiBpF75U/3GdlrrxcaBAK+DeI1oI6c7f+SI+gYnbGp8i2/T5eO/btNa
	ZGFzddcCLldkzsKCQSOKnDxDPosyvgs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794667840;
	b=s4qDDKAfP34zKq2un92N6ReAvrX1aCA6vEQur9PGNfer81CXBbsgZWaiio1coOX9OzZQgB
	fJxIMCCKWKsQ10o+iQVEhi0IkK12VeGzIVqVzcukAHGy1phZ2YZN72pNmgCo08jZxqaV7U
	SxHgiNVHR5s35xUCKZH3p1HKOWZRIeA=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=Sccli7hW;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.210.180 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-8a07078200fso859250b3a.2
        for <linux-mm@kvack.org>; Sat, 14 Nov 2026 06:50:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794667839; x=1795272639; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=at5RjVFnb0nLG0yNWBL2prGnwvhHWrO+XxTNCCu9nPs=;
        b=Sccli7hW0ePfEpA9DCssDMG2tdE2STcQ3Nan/hBp8xR5PPDLbZ0RucKjbNQ2dt+Bq1
         Kx8kCOwJ2nbheuYNe9GAoaknkzqLvluifMyXrOlz9TuvSbD7U7d/8GT2pOi8xBnNIhRU
         PRUFP1EmVt9YTrG7CJPe/huunxgESqRm6O4x4rP4yq9DIaRTvO/hpj9VGAGTZ5G+iJfZ
         o9Ec7EyZKH9nLigER/xnuBcycgCLBXRgsGFd69T8MmuuE8ktgMl34yB4bcYpU0iuIY0w
         001WTzMbU1XFp+a+EjscVfi4CwxBdh/1g2MA6KMAqUL0VL5/erPxHB6I6+PmDRS7zvuj
         NPgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794667839; x=1795272639;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=at5RjVFnb0nLG0yNWBL2prGnwvhHWrO+XxTNCCu9nPs=;
        b=P4esnfZcmoqVnnqYTUYF7TSKljaUKzORRkHrKdVHyadVZjjvkW+zrq7KnqP/SQVgR1
         BLWaTLwEgBPje1UYsMPyYdGrPIYkUxVgIF5ebNI1cMzTgk2JjWdYrHgupeDAXFX+nmfr
         zqoSUkmz7b/LYlgqEPD5elSv4N/tM+K6W7hIkCVHpGRSB7wUOE2anTtk7kYN9hXVwUqd
         KcXwvajiNmxVrQHwMFUC79aDbCgyGFCpZPtjUpQup5Dkq7juQ+SGK+5XIhjud2uhrF2P
         YWIrWgRHaiyqqcOPcJ3qk7Izegj89mQnlJjPyEPjUVv0RUcPnPSdAsLEQ5WNpEggxaFv
         24Jg==
X-Gm-Message-State: APuU4Z8GM41kpDLNWR0iWt6Fp8xmYHcsBMj/hXzh1Rn8h+9/375riRYT
	h8odQYYrUW9ZEWvTiku4iey+sMf+EUlpTxqnD15kXRHhQXHNvwqmQa4qysfY6g==
X-Gm-Gg: AYBFou02m2uJk0rOneb/xA6uLS8e2JiQMoRb7UlCdM0bk2HbDEeNUT4BtwOqDmP4gat
	6yyxlA2L6dbAzrHNGEEdG4rzkfFUSAZeFpQUejPKMcopzEb7w70+egRM68ykuE1tA/xWgeUInNb
	CXUgNCR1VDZT9YU2dY0eJ9WDcKeXtEibcYlV4Nc3xjY30yMdDsYngA1rbREJ+uP1IOdw8iJO9YJ
	Rkfcoeq6ZJmVH3WfRd+BtLwythCjCBLUJLja2/plrzkYP3SGdifCL4v/iQQ9xLG/XQ8D9wPd0mU
	63W39jgdRA65+qbdyeK6VsYANEv4q0nWNczi4R9ctDzdzhbs2uMbXN7J5E8z20OcNazP3GDCO8E
	4vZZK5SgpUSVm5bfjdlMEHyZmnpODKkGQc3QmVs7xYo2+8iB0EsfEl0qteCGq1vb6DDIBxjboWo
	7vDc+LVjeMGkRXUfsKU/6nOhGL3LoSKL7IKvB1TUvVTb5CBdMcVKi+9Q9S0jqF+DzbrTbt2vzgA
	XxZx254JaLop3r6G5bZszlGlX7L1qShLONFqrdiAqh8M7nN7IDBVzx71wLEH7NyYUG7w88BuVgS
	fpenOx82ZCRcEH9Coi3bfzJsouSw8SLT+tn3rZpbl9rvue7qwzw3/a2rbHsf/7Xnm8CiwkXQEa6
	2lEk+TCofUHukEQ==
X-Received: by 2002:a05:6a00:1783:b0:8ac:3a71:38a6 with SMTP id d2e1a72fcca58-8beb76369e3mr5821665b3a.52.1794667839241;
        Sat, 14 Nov 2026 06:50:39 -0800 (PST)
Received: from localhost.localdomain (vmi2317719.contaboserver.net. [84.247.152.64])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8bed1e5ac38sm2159239b3a.31.2026.11.14.06.50.31
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 14 Nov 2026 06:50:38 -0800 (PST)
From: Lian Wang <lianux.mm@gmail.com>
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
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	linux-hardening@vger.kernel.org
Subject: [RFC PATCH v4 08/18] mm/swap: change back to use each swap device's percpu cluster
Date: Sat, 14 Nov 2026 22:50:26 +0800
Message-ID: <f9cb4b2c57360c07bb1ff0d305e089635cb7e56e.1794666741.git.lianux.mm@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1794666741.git.lianux.mm@gmail.com>
References: <cover.1794666741.git.lianux.mm@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: qtm1473k11ggsiyc61ni4tbc7n95tea5
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 8901B180004
X-HE-Tag: 1794667840-445478
X-HE-Meta: U2FsdGVkX1+NqzAFKWVuEVD6X9UAlAFcO12W0/pWDvxDd+VVrnZVgWazhS5f5X/8RdsGZ5kB70tRrzQeTPH/PpIg6j7+kXwHMam5/E+QCP9feFH2+ww1nP6mg08IEVbAH9AA1MhF6bn4Q1jmLF4KqsF1nQy96xh8GGdtGPoB2FoSIP+p5+E6lfgBsBivkulWt5xev1G8uVRffssFtOyqXXxcGY364zE/BjnPKKLwUSj19uYnCLn+L6nmtvRonNQ5bQ5qVKtI7ipzdjN8m3061pSYBDHZCQ/o0vnLfHQEDjgv6lT+LO4O7vAPaeev43TF/H5PHhrbp0I2zGNbQ4GmkmakiwEyfyFVc5c4Fstb27LXBPLdHJzGpSj6xx5m0YvMhm2Ttg9nrvnXaQrMYCKfxHGGnxi4nOT5gPKNTlLshIHYKlgg9glougqx6yh+1Wbo3lIfXWO0kqtRKMdsmOXCEj+FqPhL9rUXcHjgmOVMv5itw3UGEtbamkHymZ00JiiOvMN2a8TkytQV2pfC5bOquYW8tUOl3N0Lxu4KU2OlPZD/4N33vz+CvNqgmEpwDxOqrZkt8NQUZhTT81zcJB6JaUO6uMI/YBrOAduFN+fZbVmKYtJPMJiZTG8uIfqWdhejerY/plUNw6VBs6CRpqaWa9j/4PH1KlEs/Piqq8gLU1QGC1zM+7Ecp5BNFc6rEETWf4yDNn+9r1iNksrGy/c78M/uCfFhWa/YZJHnkA7gEpSWoNKWgvfbITvAuktO+8TXQCsL5uXg4DXI+bpMhoa+Is6gps4ztM/8G9niG8Mr0DC044yCLshDHiRFHaWkVyXw3DSjDSOsu3e+T/kRpimFDsHpHNdsHJc+TBHY0qe27nmeXBWg9/jf5bT7i0dwsTrAR9WngA1ZteyuAgRWrsrrQASkqh7SIdvTduQX1oGGbW0JClgT7m+9aBh3uVLHUWHHlNNVYQjjK3hQY86xEHE
 VGmik3bt
 rSxFiWZSqQbvR3FaRDDOFQeo+dEB+7HwbdEZWVhY/eoDXdsIlqPK7lfIYtW4cNuiSDl8dxlYvaNgXN+tYG1tDKeSu95kUBpd1lgcJyYIPjKzejAkaIysOTDQEb4R2EBTyIOVf8jyBI0HD8rtxn/OXXXRNw9XDqlWRqKDvmtbIs/UQwjN+u2wo5vtXpD7fKc4vGdI/apsa6h6FL/GrJo8H5i2oUZ66aNnkWBeU6QEWFbgK25dbTT15aMBnjxRvjWzCdqK/QF2ww+rWAkC4WTeIeQcjU1iueuECqWrV2bvM83SIfwI4tTSO018ghaqcfvg5l0NBMYFdZvVGQZRrJ8ICXUfbW9oSvCLAGrBy18/PaXBhtePvGXf5+/4jWJ77k575TYwuSiuPze1XNh362I3h10jGYopzsCzI+f2POO9IJaCFwEeyvNZtuR9pjCDrZLrZuT0m1ugeWJPvwOHSdMllzIWDh7x9C1AKeIbP842L2cSVsK5uPIGcCbfb8jJaVgHeFPdwDPOGKu3CKxA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Youngjun Park <youngjun.park@lge.com>

This reverts commit 1b7e90020eb7 ("mm, swap: use percpu cluster as
allocation fast path").

The global percpu cluster causes several issues:

1) It prevents efficient swap allocation for users that do not want
   the default swap device policy.  Because the cluster cache sits
   above device selection, users that need a different policy must
   bypass or replace the cache. This complicates incoming ideas like
   swap tiering.

2) It can bypass a caller's preferred device policy. Consider a future
   policy with per-memcg device restrictions: memcg1 can access devices
   A and B, where A has higher priority; memcg2 can only access B. Memcg2
   can write the global percpu cluster with device B, then memcg1 takes B
   in the fast path even though higher-priority device A is not exhausted.

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
Signed-off-by: Lian Wang <lianux.mm@gmail.com>
---
 include/linux/swap.h |  13 +++-
 mm/swapfile.c        | 170 ++++++++++++++-----------------------------
 2 files changed, 63 insertions(+), 120 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 717387e16a2d..c8a5684b2f4f 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -241,10 +241,17 @@ enum {
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
 
@@ -267,8 +274,8 @@ struct swap_info_struct {
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
index aa020f2706b4..c46b43414bf4 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -145,18 +145,6 @@ static atomic_t proc_poll_event = ATOMIC_INIT(0);
 
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
@@ -523,9 +511,10 @@ static int swap_cluster_alloc_table(struct swap_info_struct *si,
 lock:
 	if (!locked) {
 		if (si) {
-			local_lock(&percpu_swap_cluster.lock);
-			if (!(si->flags & SWP_SOLIDSTATE))
-				spin_lock(&si->global_cluster_lock);
+			if (si->flags & SWP_SOLIDSTATE)
+				local_lock(&si->percpu_cluster->lock);
+			else
+				spin_lock(&si->global_cluster->lock);
 		}
 		spin_lock(&ci->lock);
 	}
@@ -610,9 +599,10 @@ swap_cluster_populate(struct swap_info_struct *si,
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
 
 	if (!swap_cluster_alloc_table(si, ci, __GFP_HIGH | __GFP_NOMEMALLOC |
@@ -625,9 +615,10 @@ swap_cluster_populate(struct swap_info_struct *si,
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
 
 	ret = swap_cluster_alloc_table(si, ci, __GFP_HIGH | __GFP_NOMEMALLOC |
 					     GFP_KERNEL, false);
@@ -749,7 +740,7 @@ static bool swap_do_scheduled_discard(struct swap_info_struct *si)
 		ci = list_first_entry(&si->discard_clusters, struct swap_cluster_info, list);
 		/*
 		 * Delete the cluster from list to prepare for discard, but keep
-		 * the CLUSTER_FLAG_DISCARD flag, percpu_swap_cluster could be
+		 * the CLUSTER_FLAG_DISCARD flag, there could be percpu_cluster
 		 * pointing to it, or ran into by relocate_cluster.
 		 */
 		list_del(&ci->list);
@@ -1104,12 +1095,10 @@ static unsigned int alloc_swap_scan_cluster(struct swap_info_struct *si,
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
 
@@ -1210,13 +1199,17 @@ static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si,
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
@@ -1230,7 +1223,6 @@ static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si,
 			goto done;
 	}
 
-new_cluster:
 	if (swap_prefer_free_cluster(si)) {
 		found = alloc_swap_scan_list(si, &si->free_clusters, folio, false);
 		if (found)
@@ -1283,8 +1275,10 @@ static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si,
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
@@ -1440,41 +1434,8 @@ static bool get_swap_device_info(struct swap_info_struct *si)
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
 
@@ -1842,10 +1803,7 @@ int folio_alloc_swap(struct folio *folio)
 	}
 
 again:
-	local_lock(&percpu_swap_cluster.lock);
-	if (!swap_alloc_fast(folio))
-		swap_alloc_slow(folio);
-	local_unlock(&percpu_swap_cluster.lock);
+	swap_alloc_entry(folio);
 
 	if (!order && unlikely(!folio_test_swapcache(folio))) {
 		if (swap_sync_discard())
@@ -2251,31 +2209,14 @@ void swap_put_entries_direct(swp_entry_t entry, int nr)
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
 
@@ -3253,27 +3194,6 @@ static void free_swap_cluster_info(struct swap_cluster_info *cluster_info,
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
@@ -3325,7 +3245,6 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 
 	flush_work(&p->discard_work);
 	flush_work(&p->reclaim_work);
-	flush_percpu_swap_cluster(p);
 
 	destroy_swap_extents(p, p->swap_file);
 
@@ -3346,6 +3265,8 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 	percpu_up_write(&swapon_rwsem);
 	arch_swap_invalidate_area(p->type);
 	zswap_swapoff(p->type);
+	free_percpu(p->percpu_cluster);
+	p->percpu_cluster = NULL;
 	kfree(p->global_cluster);
 	p->global_cluster = NULL;
 	free_swap_cluster_info(cluster_info, maxpages);
@@ -3694,7 +3615,7 @@ static int setup_swap_clusters_info(struct swap_info_struct *si,
 {
 	unsigned long nr_clusters = DIV_ROUND_UP(maxpages, SWAPFILE_CLUSTER);
 	struct swap_cluster_info *cluster_info;
-	int err = -ENOMEM;
+	int cpu, err = -ENOMEM;
 	unsigned long i;
 
 	cluster_info = kvzalloc_objs(*cluster_info, nr_clusters);
@@ -3704,13 +3625,26 @@ static int setup_swap_clusters_info(struct swap_info_struct *si,
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
@@ -3984,6 +3918,8 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 bad_swap_unlock_inode:
 	inode_unlock(inode);
 bad_swap:
+	free_percpu(si->percpu_cluster);
+	si->percpu_cluster = NULL;
 	kfree(si->global_cluster);
 	si->global_cluster = NULL;
 	inode = NULL;

