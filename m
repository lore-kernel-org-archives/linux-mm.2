Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A5DD1088E43
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 22:30:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9BB3E6B0372; Wed, 18 Mar 2026 18:30:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 91DCE6B0374; Wed, 18 Mar 2026 18:30:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 722396B0375; Wed, 18 Mar 2026 18:30:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 548656B0372
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 18:30:34 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1FAD41A01DE
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 22:30:34 +0000 (UTC)
X-FDA: 84560629188.22.E6673F0
Received: from mail-oa1-f50.google.com (mail-oa1-f50.google.com [209.85.160.50])
	by imf25.hostedemail.com (Postfix) with ESMTP id 3FB08A0017
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 22:30:32 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=TcGHM6kt;
	spf=pass (imf25.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.160.50 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773873032;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v+iH5HFisohJxPO0eUw7yFv6IR/DWyPxYEiRGFSd7Iw=;
	b=N5YOVvksHiVHI9sZ0Tq2WoLtUnEV9T74zUFVMBxMzUwUszGbsePRPYZIk9KODpQ0NiH0Re
	HJgnhga2+f86oql452YNtpT1aaUZNNhhjaRFxwdkFTGvveE0Mzf55ENxEbsPlRPwIrMNxQ
	VjqgGp3dULJK1o4b395BGMy1Vdogae0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773873032; a=rsa-sha256;
	cv=none;
	b=QfXxeALJxtnp4sEMDW0WGVM6JrlLwCdvwDxLDIC5exncxo/H04VlioDBdWDX2lEtWaMvnx
	7YS6p/M0wlLZO8/w3ulL/UOvgb1xpgfqrwuKkmfUl/kwoPVbJ9ZKpRoWW0WLv6C65xqCDC
	sBQ+Aar2mkHEHl22WUXWiacWzCd2xXA=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=TcGHM6kt;
	spf=pass (imf25.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.160.50 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-oa1-f50.google.com with SMTP id 586e51a60fabf-41708f6aa5fso47096fac.2
        for <linux-mm@kvack.org>; Wed, 18 Mar 2026 15:30:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773873031; x=1774477831; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=v+iH5HFisohJxPO0eUw7yFv6IR/DWyPxYEiRGFSd7Iw=;
        b=TcGHM6ktdRwuZoR8mNa2FN5tifwu9Im7E41pqe91havVJpR4CE35iPaOrk+p3obr+Z
         9u+gnUNVwSrWeIv3BT2ESze3W9b09eO/245mzM7SltbeSjwgZpbTI23HxryDCIhfo/dw
         E48x6Dap3WMtC4qA0NVTKaGWwJoUikUVUGOubmilr65sSDURM8mF5IOwNapTFwbywAdp
         /lr40ecaIYsg1GG8x8MKWj5kCwf1QSBmqnGPd18teV+De4mPePKjbHGS36aP5oS0ytwq
         nt08NgjaY3VMlzxJIHUgGdnX0rbtSudE8wuPfVsVNw/Mfpwhd73jjZQAZvMFhivr5y0u
         K0/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773873031; x=1774477831;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=v+iH5HFisohJxPO0eUw7yFv6IR/DWyPxYEiRGFSd7Iw=;
        b=i9cA1GP3UIl9pKMc9nZKm6Ug06tWAYifsuxjY8HqwLqVhkkngImUoxlZ5VV9KHBJdN
         PpZny+1mvSxyT/rjXeP48yw+8Y/zm27LWOFHiocgDH9d2zMpxNKahK4Rs5Xda2LvIFWa
         2hgLpIoAcwR3kARkVWcWIbPEut/cAk6KMjOQgz0H/Y5ccNLLnYottylp4lrT29KOF8do
         7CJRc92xEBz6Mf9i9A6OzzAKSFKSlWL2Qb9XY/Oea4ZvJlJNhp4HWQqcN4WpzXYAi5O9
         PYZrV2CuTKxlB1uf6n3J7ymVZVuaebW4Z4nN0fNbXqgEgjorecIxekeTuDpPPnVzvod1
         maWg==
X-Forwarded-Encrypted: i=1; AJvYcCXspRatFjOhYLs/gfahOqYBkUXNLsae4X6KcUuZFut9JbnZdIZRdCT9Szl9vPUZg1YF2tuIXuS9OQ==@kvack.org
X-Gm-Message-State: AOJu0Yzt8UE7OegrzjMD+YDjY2aayqdRlpFIOIW/BKH1XmcgSVGVz8VZ
	gLe5rPf1f0ZUNp31hmsloWnIWfmNAZafLjxVdGGhd3JLkvfsaJ3+Wyg9
X-Gm-Gg: ATEYQzzu0lSpm4qDusXTJ5uSEuOoiQLx8X1brDm6q1tEF7ozs5nHZh/8R/ku31RX4sO
	4MqehbV5RYagltW9o9g9r3dJPrVrdLIFv3yh2AFyzUtaf2h2OlZLKaaF70cigWamQ5bfaq01OXY
	7Jko+t5h7dVNNs6yTpQQBXylk7L8DIOdiu/LeV0x/Fn0En6h2mUjU61qlwGkMKjAfMJrI9cgToE
	BrC+IYkpiPGffodeE/JR4rENovRA6diSSSLrikPf/5M6GbAVfCp2fQUTyK1bQO05a+M2hVN1xS5
	fQ3xbpBS1++aoI39lyPoj3s1qHu8HDheiI7V/pwlpuRQNrH6d6JIFUg7vlnI3d86cALxSoGflTw
	B3S6KLEs8Qu1po5U7KuZQEjTcnESTHtMHKQj0vmEiBKbv9h7FnDu8aMoT2+lB5lREXQM9AD/KJo
	BUovKTtaA+VwRaxeibiG4wwogXRfirF93qxXwmSfK6BWT6HQ==
X-Received: by 2002:a05:6871:286:b0:3e8:98e4:56d with SMTP id 586e51a60fabf-41bd421a979mr3698110fac.41.1773873031027;
        Wed, 18 Mar 2026 15:30:31 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:74::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-41bd2c3111dsm3703574fac.12.2026.03.18.15.30.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Mar 2026 15:30:30 -0700 (PDT)
From: Nhat Pham <nphamcs@gmail.com>
To: kasong@tencent.com
Cc: Liam.Howlett@oracle.com,
	akpm@linux-foundation.org,
	apopple@nvidia.com,
	axelrasmussen@google.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	bhe@redhat.com,
	byungchul@sk.com,
	cgroups@vger.kernel.org,
	chengming.zhou@linux.dev,
	chrisl@kernel.org,
	corbet@lwn.net,
	david@kernel.org,
	dev.jain@arm.com,
	gourry@gourry.net,
	hannes@cmpxchg.org,
	hughd@google.com,
	jannh@google.com,
	joshua.hahnjy@gmail.com,
	lance.yang@linux.dev,
	lenb@kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-pm@vger.kernel.org,
	lorenzo.stoakes@oracle.com,
	matthew.brost@intel.com,
	mhocko@suse.com,
	muchun.song@linux.dev,
	npache@redhat.com,
	nphamcs@gmail.com,
	pavel@kernel.org,
	peterx@redhat.com,
	peterz@infradead.org,
	pfalcato@suse.de,
	rafael@kernel.org,
	rakie.kim@sk.com,
	roman.gushchin@linux.dev,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	shakeel.butt@linux.dev,
	shikemeng@huaweicloud.com,
	surenb@google.com,
	tglx@kernel.org,
	vbabka@suse.cz,
	weixugc@google.com,
	ying.huang@linux.alibaba.com,
	yosry.ahmed@linux.dev,
	yuanchu@google.com,
	zhengqi.arch@bytedance.com,
	ziy@nvidia.com,
	kernel-team@meta.com,
	riel@surriel.com
Subject: [PATCH v4 21/21] vswap: batch contiguous vswap free calls
Date: Wed, 18 Mar 2026 15:29:52 -0700
Message-ID: <20260318222953.441758-22-nphamcs@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260318222953.441758-1-nphamcs@gmail.com>
References: <20260318222953.441758-1-nphamcs@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3FB08A0017
X-Stat-Signature: mkqtyik9ro4numf68ithxc4kb4ghorbm
X-HE-Tag: 1773873032-270865
X-HE-Meta: U2FsdGVkX19AokyddnjWjOz7WL6whpxiv7Gn8H+eZ3a+awEr9h3In2tg65+l4Fljg+1vh5Q9mnj4d23JLmuVqXbvxT/DGfcgTH5LghHjGG+l7LSDtFBgRCW+3bmrrxQ4PfoUQm8+OxvVhhvuNqeBO7l8ol2MM2xApizlWxhR0Eqfh9ylE+x/c4Z6MsYZz2cQxPavhQgA1U51NnBjCHACBqweJVMy//2j8coLeLFz25OABvZsaCYQ5z0YQu/UdqhFbucWJ7aBmnhflsFdjCceaFC8Zk25CInyk0qZo+yqxN1yi7cHd8LWxoqzHoARt/tFtsl9qXWVXCYBvTuPjonq5lQzS0QD2qkrAzLO/h5o4yhqwz2+jQ7fEVplFF2ctDbduss0aBMB8CPPrnNtrRNqHMaG/lTTZW53sb35tJ7+VgXqKqFa+JOjtCNssjzSC7nmESzOnA6ZJScaOP1tLClSSFb/wUha6dntfMUlSRXXXDB3EqRKS9Ol8wCMWsbGoBLF3ELoDHcj6W4Ai3exi/r3JU1J+a+xlMrG4+ZrcIWNy56hoKFQq8MxMb+7KMI52c2l5dWoBZY44tAta922E4GwybwPJD+7fl7JG8bVTWaqVbLZA8ND6qBDFiFkW16syrQCQqhazqn+Qbsa/3LSFc65OM+ZD/DnNG5HSmYORMrA/Kh/l3kNJeQxKM8MBWhd3bKL7OGTpUHt1fgG9DBfy3VaXwyAYTEXEv3Xp/PIHEy8yLTfYxCZv/CM8Q3HSuz+PZyM2l3m9oD9uDRCctg1GR/9NQJgVmLycLGEU5bkWMsaK4/ox+KHgDh0iXcqCZ6RyocSWKrIMsF743hn7SHc1LcVXtGIl53Gyy6wvfg8lOD5/5fy7/F09LvmKPQyiwG7vIKXHpPSwTyn2zzBty3vDHXARi3odclibGeEIFxsIqA33x0vT97B7nibBIcqKKWc/hPjZKIcjBchPNm+3PyHafJ
 qTwXU515
 Nl3aRp28j4JVNstmcHe3uuGpYj3cGAN82bTfd4ya54Qvxu/rm+9VE5MM6P5w4pi7c/nxbc4zAeHvpA8bbEtYels3ns5XVcAloSCQdIgKso76IwtY7ohNMcXQyy3k/3e8yTOAgMFM0HAPQtxNK6kc8t4BUaXp07rsDiae1NdQmZ7okta/Uj4+OOTZde80jViE/WbU/3hPpJc9jNVBK7tjyUCYwhH0pEqBrdl/bjmTRKk+GkTA3NNDFBjoEEIo8aaLslQJtXsoHb4AzAfV3p7lBxkidtuagk88xlnxRQEIssgb6riauf5U952juJuZ3fDmPL/L5KGts7+pwcpeSB3SWDq1uLhoAIPRPXC0JH+yBvz2YhIlA8+NIlWi1qU6hY6z9Dx5mEpNi5Iw7euG9zR+B8lgd2/b+o/RiCTUTxXcgnk4B0zq0GBoxrZ25/juYYXu1AGIFny2hWJD1xFE7Z5B8mX6Q0PKtRFHH7osRLB6kfPMv017IXCnw5VBC7/JFbRZ822r6l8lt1CURvj50pUzZGYEUdaOPjXbiX/Zv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In vswap_free(), we release and reacquire the cluster lock for every
single entry, even for non-disk-swap backends where the lock drop is
unnecessary. Batch consecutive free operations to avoid this overhead.

Signed-off-by: Nhat Pham <nphamcs@gmail.com>
---
 include/linux/memcontrol.h |   6 ++
 mm/memcontrol.c            |   2 +-
 mm/vswap.c                 | 215 +++++++++++++++++++++++++------------
 3 files changed, 151 insertions(+), 72 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 0651865a4564f..0f7f5489e1675 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -827,6 +827,7 @@ static inline unsigned short mem_cgroup_id(struct mem_cgroup *memcg)
 	return memcg->id.id;
 }
 struct mem_cgroup *mem_cgroup_from_id(unsigned short id);
+void mem_cgroup_id_put_many(struct mem_cgroup *memcg, unsigned int n);
 
 #ifdef CONFIG_SHRINKER_DEBUG
 static inline unsigned long mem_cgroup_ino(struct mem_cgroup *memcg)
@@ -1289,6 +1290,11 @@ static inline struct mem_cgroup *mem_cgroup_from_id(unsigned short id)
 	return NULL;
 }
 
+static inline void mem_cgroup_id_put_many(struct mem_cgroup *memcg,
+					  unsigned int n)
+{
+}
+
 #ifdef CONFIG_SHRINKER_DEBUG
 static inline unsigned long mem_cgroup_ino(struct mem_cgroup *memcg)
 {
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 4525c21754e7f..c6d307b8127a8 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3597,7 +3597,7 @@ void __maybe_unused mem_cgroup_id_get_many(struct mem_cgroup *memcg,
 	refcount_add(n, &memcg->id.ref);
 }
 
-static void mem_cgroup_id_put_many(struct mem_cgroup *memcg, unsigned int n)
+void mem_cgroup_id_put_many(struct mem_cgroup *memcg, unsigned int n)
 {
 	if (refcount_sub_and_test(n, &memcg->id.ref)) {
 		mem_cgroup_id_remove(memcg);
diff --git a/mm/vswap.c b/mm/vswap.c
index 96f4615f29a95..f3634449f5427 100644
--- a/mm/vswap.c
+++ b/mm/vswap.c
@@ -482,18 +482,18 @@ static void vswap_cluster_free(struct vswap_cluster *cluster)
 	kvfree_rcu(cluster, rcu);
 }
 
-static inline void release_vswap_slot(struct vswap_cluster *cluster,
-		unsigned long index)
+static inline void release_vswap_slot_nr(struct vswap_cluster *cluster,
+		unsigned long index, int nr)
 {
 	unsigned long slot_index = VSWAP_IDX_WITHIN_CLUSTER_VAL(index);
 
 	VM_WARN_ON(!spin_is_locked(&cluster->lock));
-	cluster->count--;
+	cluster->count -= nr;
 
-	bitmap_clear(cluster->bitmap, slot_index, 1);
+	bitmap_clear(cluster->bitmap, slot_index, nr);
 
 	/* we only free uncached empty clusters */
-	if (refcount_dec_and_test(&cluster->refcnt))
+	if (refcount_sub_and_test(nr, &cluster->refcnt))
 		vswap_cluster_free(cluster);
 	else if (cluster->full && cluster_is_alloc_candidate(cluster)) {
 		cluster->full = false;
@@ -506,7 +506,7 @@ static inline void release_vswap_slot(struct vswap_cluster *cluster,
 		}
 	}
 
-	atomic_dec(&vswap_used);
+	atomic_sub(nr, &vswap_used);
 }
 
 /*
@@ -528,23 +528,33 @@ void vswap_rmap_set(struct swap_cluster_info *ci, swp_slot_t slot,
 }
 
 /*
- * Caller needs to handle races with other operations themselves.
+ * release_backing - release the backend storage for a given range of virtual
+ * swap slots.
+ *
+ * Entered with the cluster locked, but might drop the lock in between.
+ * This is because several operations, such as releasing physical swap slots
+ * (i.e swap_slot_free_nr()) require the cluster to be unlocked to avoid
+ * deadlocks.
  *
- * Specifically, this function is safe to be called in contexts where the swap
- * entry has been added to the swap cache and the associated folio is locked.
- * We cannot race with other accessors, and the swap entry is guaranteed to be
- * valid the whole time (since swap cache implies one refcount).
+ * This is safe, because:
  *
- * We cannot assume that the backends will be of the same type,
- * contiguous, etc. We might have a large folio coalesced from subpages with
- * mixed backend, which is only rectified when it is reclaimed.
+ * 1. Callers ensure no concurrent modification of the swap entry's internal
+ *    state can occur. This is guaranteed by one of the following:
+ *    - For vswap_free_nr() callers: the swap entry's refcnt (swap count and
+ *      swapcache pin) is down to 0.
+ *    - For vswap_store_folio(), swap_zeromap_folio_set(), and zswap_entry_store()
+ *      callers: the folio is locked and in the swap cache.
+ *
+ * 2. The swap entry still holds a refcnt to the cluster, keeping the cluster
+ *    itself valid.
+ *
+ * We will exit the function with the cluster re-locked.
  */
- static void release_backing(swp_entry_t entry, int nr)
+static void release_backing(struct vswap_cluster *cluster, swp_entry_t entry,
+		int nr)
 {
-	struct vswap_cluster *cluster = NULL;
 	struct swp_desc *desc;
 	unsigned long flush_nr, phys_swap_start = 0, phys_swap_end = 0;
-	unsigned long phys_swap_released = 0;
 	unsigned int phys_swap_type = 0;
 	bool need_flushing_phys_swap = false;
 	swp_slot_t flush_slot;
@@ -552,9 +562,8 @@ void vswap_rmap_set(struct swap_cluster_info *ci, swp_slot_t slot,
 
 	VM_WARN_ON(!entry.val);
 
-	rcu_read_lock();
 	for (i = 0; i < nr; i++) {
-		desc = vswap_iter(&cluster, entry.val + i);
+		desc = __vswap_iter(cluster, entry.val + i);
 		VM_WARN_ON(!desc);
 
 		/*
@@ -574,7 +583,6 @@ void vswap_rmap_set(struct swap_cluster_info *ci, swp_slot_t slot,
 		if (desc->type == VSWAP_ZSWAP && desc->zswap_entry) {
 			zswap_entry_free(desc->zswap_entry);
 		} else if (desc->type == VSWAP_SWAPFILE) {
-			phys_swap_released++;
 			if (!phys_swap_start) {
 				/* start a new contiguous range of phys swap */
 				phys_swap_start = swp_slot_offset(desc->slot);
@@ -590,56 +598,49 @@ void vswap_rmap_set(struct swap_cluster_info *ci, swp_slot_t slot,
 
 		if (need_flushing_phys_swap) {
 			spin_unlock(&cluster->lock);
-			cluster = NULL;
 			swap_slot_free_nr(flush_slot, flush_nr);
+			mem_cgroup_uncharge_swap(entry, flush_nr);
+			spin_lock(&cluster->lock);
 			need_flushing_phys_swap = false;
 		}
 	}
-	if (cluster)
-		spin_unlock(&cluster->lock);
-	rcu_read_unlock();
 
 	/* Flush any remaining physical swap range */
 	if (phys_swap_start) {
 		flush_slot = swp_slot(phys_swap_type, phys_swap_start);
 		flush_nr = phys_swap_end - phys_swap_start;
+		spin_unlock(&cluster->lock);
 		swap_slot_free_nr(flush_slot, flush_nr);
+		mem_cgroup_uncharge_swap(entry, flush_nr);
+		spin_lock(&cluster->lock);
 	}
+}
 
-	if (phys_swap_released)
-		mem_cgroup_uncharge_swap(entry, phys_swap_released);
- }
+static void __vswap_swap_cgroup_clear(struct vswap_cluster *cluster,
+		swp_entry_t entry, unsigned int nr_ents);
 
 /*
- * Entered with the cluster locked, but might unlock the cluster.
- * This is because several operations, such as releasing physical swap slots
- * (i.e swap_slot_free_nr()) require the cluster to be unlocked to avoid
- * deadlocks.
- *
- * This is safe, because:
- *
- * 1. The swap entry to be freed has refcnt (swap count and swapcache pin)
- *    down to 0, so no one can change its internal state
- *
- * 2. The swap entry to be freed still holds a refcnt to the cluster, keeping
- *    the cluster itself valid.
- *
- * We will exit the function with the cluster re-locked.
+ * Entered with the cluster locked. We will exit the function with the cluster
+ * still locked.
  */
-static void vswap_free(struct vswap_cluster *cluster, struct swp_desc *desc,
-	swp_entry_t entry)
+static void vswap_free_nr(struct vswap_cluster *cluster, swp_entry_t entry,
+		int nr)
 {
-	/* Clear shadow if present */
-	if (xa_is_value(desc->shadow))
-		desc->shadow = NULL;
-	spin_unlock(&cluster->lock);
+	struct swp_desc *desc;
+	int i;
+
+	for (i = 0; i < nr; i++) {
+		desc = __vswap_iter(cluster, entry.val + i);
+		/* Clear shadow if present */
+		if (xa_is_value(desc->shadow))
+			desc->shadow = NULL;
+	}
 
-	release_backing(entry, 1);
-	mem_cgroup_clear_swap(entry, 1);
+	release_backing(cluster, entry, nr);
+	__vswap_swap_cgroup_clear(cluster, entry, nr);
 
-	/* erase forward mapping and release the virtual slot for reallocation */
-	spin_lock(&cluster->lock);
-	release_vswap_slot(cluster, entry.val);
+	/* erase forward mapping and release the virtual slots for reallocation */
+	release_vswap_slot_nr(cluster, entry.val, nr);
 }
 
 /**
@@ -818,18 +819,32 @@ static bool vswap_free_nr_any_cache_only(swp_entry_t entry, int nr)
 	struct vswap_cluster *cluster = NULL;
 	struct swp_desc *desc;
 	bool ret = false;
-	int i;
+	swp_entry_t free_start;
+	int i, free_nr = 0;
 
+	free_start.val = 0;
 	rcu_read_lock();
 	for (i = 0; i < nr; i++) {
+		/* flush pending free batch at cluster boundary */
+		if (free_nr && !VSWAP_IDX_WITHIN_CLUSTER_VAL(entry.val)) {
+			vswap_free_nr(cluster, free_start, free_nr);
+			free_nr = 0;
+		}
 		desc = vswap_iter(&cluster, entry.val);
 		VM_WARN_ON(!desc);
 		ret |= (desc->swap_count == 1 && desc->in_swapcache);
 		desc->swap_count--;
-		if (!desc->swap_count && !desc->in_swapcache)
-			vswap_free(cluster, desc, entry);
+		if (!desc->swap_count && !desc->in_swapcache) {
+			if (!free_nr++)
+				free_start = entry;
+		} else if (free_nr) {
+			vswap_free_nr(cluster, free_start, free_nr);
+			free_nr = 0;
+		}
 		entry.val++;
 	}
+	if (free_nr)
+		vswap_free_nr(cluster, free_start, free_nr);
 	if (cluster)
 		spin_unlock(&cluster->lock);
 	rcu_read_unlock();
@@ -952,19 +967,33 @@ void swapcache_clear(swp_entry_t entry, int nr)
 {
 	struct vswap_cluster *cluster = NULL;
 	struct swp_desc *desc;
-	int i;
+	swp_entry_t free_start;
+	int i, free_nr = 0;
 
 	if (!nr)
 		return;
 
+	free_start.val = 0;
 	rcu_read_lock();
 	for (i = 0; i < nr; i++) {
+		/* flush pending free batch at cluster boundary */
+		if (free_nr && !VSWAP_IDX_WITHIN_CLUSTER_VAL(entry.val)) {
+			vswap_free_nr(cluster, free_start, free_nr);
+			free_nr = 0;
+		}
 		desc = vswap_iter(&cluster, entry.val);
 		desc->in_swapcache = false;
-		if (!desc->swap_count)
-			vswap_free(cluster, desc, entry);
+		if (!desc->swap_count) {
+			if (!free_nr++)
+				free_start = entry;
+		} else if (free_nr) {
+			vswap_free_nr(cluster, free_start, free_nr);
+			free_nr = 0;
+		}
 		entry.val++;
 	}
+	if (free_nr)
+		vswap_free_nr(cluster, free_start, free_nr);
 	if (cluster)
 		spin_unlock(&cluster->lock);
 	rcu_read_unlock();
@@ -1105,11 +1134,13 @@ void vswap_store_folio(swp_entry_t entry, struct folio *folio)
 	VM_BUG_ON(!folio_test_locked(folio));
 	VM_BUG_ON(folio->swap.val != entry.val);
 
-	release_backing(entry, nr);
-
 	rcu_read_lock();
+	desc = vswap_iter(&cluster, entry.val);
+	VM_WARN_ON(!desc);
+	release_backing(cluster, entry, nr);
+
 	for (i = 0; i < nr; i++) {
-		desc = vswap_iter(&cluster, entry.val + i);
+		desc = __vswap_iter(cluster, entry.val + i);
 		VM_WARN_ON(!desc);
 		desc->type = VSWAP_FOLIO;
 		desc->swap_cache = folio;
@@ -1134,11 +1165,13 @@ void swap_zeromap_folio_set(struct folio *folio)
 	VM_BUG_ON(!folio_test_locked(folio));
 	VM_BUG_ON(!entry.val);
 
-	release_backing(entry, nr);
-
 	rcu_read_lock();
+	desc = vswap_iter(&cluster, entry.val);
+	VM_WARN_ON(!desc);
+	release_backing(cluster, entry, nr);
+
 	for (i = 0; i < nr; i++) {
-		desc = vswap_iter(&cluster, entry.val + i);
+		desc = __vswap_iter(cluster, entry.val + i);
 		VM_WARN_ON(!desc);
 		desc->type = VSWAP_ZERO;
 	}
@@ -1773,11 +1806,10 @@ void zswap_entry_store(swp_entry_t swpentry, struct zswap_entry *entry)
 	struct vswap_cluster *cluster = NULL;
 	struct swp_desc *desc;
 
-	release_backing(swpentry, 1);
-
 	rcu_read_lock();
 	desc = vswap_iter(&cluster, swpentry.val);
 	VM_WARN_ON(!desc);
+	release_backing(cluster, swpentry, 1);
 	desc->zswap_entry = entry;
 	desc->type = VSWAP_ZSWAP;
 	spin_unlock(&cluster->lock);
@@ -1824,17 +1856,22 @@ bool zswap_empty(swp_entry_t swpentry)
 #endif /* CONFIG_ZSWAP */
 
 #ifdef CONFIG_MEMCG
-static unsigned short vswap_cgroup_record(swp_entry_t entry,
-				unsigned short memcgid, unsigned int nr_ents)
+/*
+ * __vswap_cgroup_record - record mem_cgroup for a set of swap entries
+ *
+ * Entered with the cluster locked. We will exit the function with the cluster
+ * still locked.
+ */
+static unsigned short __vswap_cgroup_record(struct vswap_cluster *cluster,
+				swp_entry_t entry, unsigned short memcgid,
+				unsigned int nr_ents)
 {
-	struct vswap_cluster *cluster = NULL;
 	struct swp_desc *desc;
 	unsigned short oldid, iter = 0;
 	int i;
 
-	rcu_read_lock();
 	for (i = 0; i < nr_ents; i++) {
-		desc = vswap_iter(&cluster, entry.val + i);
+		desc = __vswap_iter(cluster, entry.val + i);
 		VM_WARN_ON(!desc);
 		oldid = desc->memcgid;
 		desc->memcgid = memcgid;
@@ -1842,6 +1879,37 @@ static unsigned short vswap_cgroup_record(swp_entry_t entry,
 			iter = oldid;
 		VM_WARN_ON(iter != oldid);
 	}
+
+	return oldid;
+}
+
+/*
+ * Clear swap cgroup for a range of swap entries.
+ * Entered with the cluster locked. Caller must be under rcu_read_lock().
+ */
+static void __vswap_swap_cgroup_clear(struct vswap_cluster *cluster,
+				      swp_entry_t entry, unsigned int nr_ents)
+{
+	unsigned short id;
+	struct mem_cgroup *memcg;
+
+	id = __vswap_cgroup_record(cluster, entry, 0, nr_ents);
+	memcg = mem_cgroup_from_id(id);
+	if (memcg)
+		mem_cgroup_id_put_many(memcg, nr_ents);
+}
+
+static unsigned short vswap_cgroup_record(swp_entry_t entry,
+				unsigned short memcgid, unsigned int nr_ents)
+{
+	struct vswap_cluster *cluster = NULL;
+	struct swp_desc *desc;
+	unsigned short oldid;
+
+	rcu_read_lock();
+	desc = vswap_iter(&cluster, entry.val);
+	VM_WARN_ON(!desc);
+	oldid = __vswap_cgroup_record(cluster, entry, memcgid, nr_ents);
 	spin_unlock(&cluster->lock);
 	rcu_read_unlock();
 
@@ -1909,6 +1977,11 @@ unsigned short lookup_swap_cgroup_id(swp_entry_t entry)
 	rcu_read_unlock();
 	return ret;
 }
+#else /* !CONFIG_MEMCG */
+static void __vswap_swap_cgroup_clear(struct vswap_cluster *cluster,
+				      swp_entry_t entry, unsigned int nr_ents)
+{
+}
 #endif /* CONFIG_MEMCG */
 
 int vswap_init(void)
-- 
2.52.0


