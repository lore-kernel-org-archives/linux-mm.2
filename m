Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 672861099B39
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 19:28:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 853116B0005; Fri, 20 Mar 2026 15:28:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 82A526B0172; Fri, 20 Mar 2026 15:28:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7192D6B0174; Fri, 20 Mar 2026 15:28:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 53E856B0005
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 15:28:11 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 108BB13A7E3
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 19:28:11 +0000 (UTC)
X-FDA: 84567427182.06.52F6DF9
Received: from mail-ot1-f42.google.com (mail-ot1-f42.google.com [209.85.210.42])
	by imf17.hostedemail.com (Postfix) with ESMTP id 38E9140010
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 19:28:09 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Z65MBeSR;
	spf=pass (imf17.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.210.42 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774034889;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VRQf7iywx8TRv6dj+dUpDGMfIu8qRC23MBFf4aVP63g=;
	b=18Qyha/QkCQc6LoYchvvT9uVp3N6c6i9OtY9c0Fah9+xXWZ7kdoEjs/hoJOf6XwxP+6QU/
	cCf86FF4vyi7eJ3sDcSO+iNWaz1dqyRTRIzJRtcWEUUME8mrRkndWn5v3b2yI4LzD0mW9W
	HuHc22keloyEAzP89ogKEF7th2k6VmI=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Z65MBeSR;
	spf=pass (imf17.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.210.42 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774034889; a=rsa-sha256;
	cv=none;
	b=1gO6uBYZY4wX9Z1IjyMO6+phlXiCPAK8a7WJVRNrqUyG8iOp8QKAEVzpFRLqRd8tRoNzHS
	Asl/rjrVPp5QLXojPbuF2GQE+ZQMVVvWCBoOFThOXoZbpoPSwhFx1Dc4sfF/d/GN+/f2kX
	6V/3pJMh45+isPO2m0el8OEgQrqkuXg=
Received: by mail-ot1-f42.google.com with SMTP id 46e09a7af769-7d7f09aa39fso907860a34.0
        for <linux-mm@kvack.org>; Fri, 20 Mar 2026 12:28:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1774034888; x=1774639688; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VRQf7iywx8TRv6dj+dUpDGMfIu8qRC23MBFf4aVP63g=;
        b=Z65MBeSRK/aLHOLDuwf3ZjlsuCVq4m46S/8iAVtvZYDIjp3N44rjSh50OSgj8xvaq4
         K8ra+WiLbXpqqX3vPsjquCzaH01zrKpg7/i6M8Bn+MWVFfhAEnJ2UocLKCpNVbOnJ4oL
         yPkM2ybcY1BcUzgjD7Fg0AfoPkiFycY+gvC3n5adJ8XqVKavENq+cro3+a32/A/WZ11M
         W3LS5wsFwUYq/yQ0nmDXcO8Mz8Mr2dQo2r8sM9zUFH+X+8s476Hr8N6sTIVN61uJsRjz
         gFHVg+GmQBMa8iGvlDy5InIJjH2H36pDdTg4+DhGpegt+//IKpIMLMYuaF3b59paInZx
         aynw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774034888; x=1774639688;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=VRQf7iywx8TRv6dj+dUpDGMfIu8qRC23MBFf4aVP63g=;
        b=cPSx+GK6eLlwV+F/8m6as01KDX0NYfljokvD69fCP0clbZYYoT+WrXx+xUIknZ0SN6
         aBOXPxx7gPK7HpgfDYtusXhl3P/27NOjfoOWWyMG8Lrnu1wSECVhxjci+0fQ5Vxq9RQ/
         OOa5XWBQR7NyQAEw8ZV8blVeyoka64aMmcU00p2QPsurisgPxyc1ZBa2i6o+QVhTqRV6
         kmEhqR1JXoELMgcCX5FVThHVQk+N/TTyl5/G9K4qtKNDN2hTujVmMQyJP4l0cRkg9pzZ
         dF4zhaMDYC5tkNWWYThrHO/TIHG1EVGf1QhYBFlJawjr0T6MXSuH6qkb8evIXFZ+E5yJ
         VXWw==
X-Forwarded-Encrypted: i=1; AJvYcCVWQ8sUAaOQpImNxNbrwVGVXoUHVdwlWTB30EGgqprs/Ete9PNrtoVye9pzarnOFg0+lpBhfJ6f+w==@kvack.org
X-Gm-Message-State: AOJu0Yz2AY9QmkK3hY26BXHRsNbLaVqW4dx9G5LhO7aS6GH1CFgHmKXp
	Wi/Sh2/OqSwOoc37kUe9zB+/LfQ4Y0nOZQBZ0cWD8xQ08gqZePowHYzb
X-Gm-Gg: ATEYQzzu57qVczgG7S8rMYmC8+IBxSVZ4TLYk/gC/GfR5Vtr5RMLD7y3a1UnHgxBdPC
	ylDMfEwg4OsxtGkVqtNSpLHfyfxzUgXi8/uSPNDfUxUBkxel0QermeE6d4jIo8mkXIfTgoKF5hh
	6sbQm4OAncxOBH5n2f6pAOZwaOJPOTxy0AYvk+QB4HxIX1n4bzGXovGDMHmMIabJTwnKUFsWcyt
	sXgO334HuOtFwLHkTChdc4Dwu6UTnHkohL4cLELTE6wR79DBtifLLCMEd/gyyMbpf1XT2uAEAh/
	bu/CLnR3aTZZAnroMJYDuhxYJl2eTjlFSXX8CuQwTWDm7wgp7tgCuLrwQIXFbDOkxHK0+7Rvf7k
	zMjMLqzijzw8XcjKOvv/10l1eCgsnWTGbAgSLwAJXcL+TvuN4Qq9G4plCb0MP6DKX1Bk8my384n
	Puwj10jaHsLF3TobD376suhgERwlN9zHgF0nNMjsmpbzZ2NA==
X-Received: by 2002:a05:6830:730c:b0:7d7:fcdd:3f8c with SMTP id 46e09a7af769-7d7fcdd510fmr146495a34.34.1774034888110;
        Fri, 20 Mar 2026 12:28:08 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:45::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d7eabe90f6sm2860154a34.6.2026.03.20.12.28.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Mar 2026 12:28:07 -0700 (PDT)
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
Subject: [PATCH v5 21/21] vswap: batch contiguous vswap free calls
Date: Fri, 20 Mar 2026 12:27:35 -0700
Message-ID: <20260320192735.748051-22-nphamcs@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260320192735.748051-1-nphamcs@gmail.com>
References: <20260320192735.748051-1-nphamcs@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 38E9140010
X-Rspamd-Server: rspam08
X-Stat-Signature: pnihgzf3fwexjhtn6eg5mmp6rmw1657i
X-HE-Tag: 1774034889-126006
X-HE-Meta: U2FsdGVkX18fV9RzyjYi7zpNabZ5VRYL3EapP4cr2Ud9aE/utUPtdvw0aqmy5wAkjuo75lewCZMNwo5ZALjDyfvYZEbHMQbKSZKXQI4pKeGoGCqcTR9YGCWFG8TvcbNOBB8Zipg6uIEqtbFMT5m5N85uvumOriJMZYWV1T1BxCcsr/byt9TjEo8UWRGLhKhCJ8e7cC8Ihc940KmOW6ycfioKhH1LdrOibG0w02sj9sycoxIsZ9Y5y1Tt7d+C3NgcxN1g61zxvWSFrR7U/GTrqfIkQDEtl9vk9txDzDkxewnBQB69qW03NVtsiRbxG55/fSHf0fh/px0FHgc5GnBde7yTFobixKVloOslju0X6W8Y3aCrRY1qxDg2kPlbBlfA8bV344a5Y4kahlVEbKC2GV6aX0lPAx5hjCnWCmjt4FWV/RFl0U78qPxiFFKy0LLEHspMgah2aWXJS6JOEMH5D0nTr8GwUnYaTaILfFaJnLnH9pD7TFoszTvUF2kPHP2RkMONyYsvCQLw3bvnVcXL5Rd0P+xRO38iNfsdRcyko00VppxkjibVXgNCpmhpjDDpSr8qqvFaT9GOEIQl4Sf985wqrcv6nfFM4aihq71N7BDit1QjGQtqmxWy4G9AS3fftjJ+f7W+iaAS9hbgKqIowu0jhx3dq1MpFMCMO36WmmGDoIarDVpOSAs6Lw3L5voDUOB9AYGfeWEz3YvdVmR/dI6YK7Fm53hce6eyXYmxzyLDizz9TvOyGph+xXgdLBuaB6+ZaJo3t/pPhzyqyzP5Dv39yBCKVp2SN+ZwJWonDU2HobmcodaLo8OaeqDEgucuQQ5+72RXieJQUBZZsVgfess9XCi0qJZGQtllP2uMTzc5PWObo6hVQJNwL3yAzRBJ6J+2ozLssW97IWVkGPC98AZsTLc1+uCqba3y++R7+/vlwdpKhT9+fh1c0MKGHOHx0Ozs7KqVFkqSKPle/3S
 vRlfqU2s
 lAtzSP5wgTBcEpiWKRaWqO5QdK2R8esxUQKmHYLkE+mDxe8B2PbO/sikQRMwxyYQU78usjHgbeasmpa+9g0BCOuiEEE1Gq7Z8WMTOD2l8j03s++q4ofG0BjmNHOy77IyzeMTc0UPHfKWNxTU614UPakjgmCXIKQdBF7aX3Nj4+0Bb/p8nKpg2i3mKZui8OZtRlslJTY7EU4D+2E2P+yn7GE/T+5/GGemYQAKPqY9CjwULDp+2e6OcD4wnKznd42Ts4ZHASDE/Q6ez6CkbVV9yJO/13Pz7Npq54asOw/RhGl9kSA4W6LlzvQ4cDKpBhb0/tI+OTJJRZMPrEtfD497j7SRfWY05SGMZuyOdwKDkp4wRsuKt7sSB+L6SK77xdwv55oBpRNu3RBZXIcONxat0zsLBiifXu8fIjtBYD8Gko6V8iU1392WGtbrsOXtXxoIhXaKR6urrm4Lv107y9jE6KFGBa9KvXLfMAbQqBE2vF7uRn85k89a/OJlg1g==
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
 mm/vswap.c                 | 185 ++++++++++++++++++++++++-------------
 3 files changed, 126 insertions(+), 67 deletions(-)

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
index fa37165cb10d0..82092502130a6 100644
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
 
 	lockdep_assert_held(&cluster->lock);
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
  *
- * Specifically, this function is safe to be called in contexts where the swap
- * entry has been added to the swap cache and the associated folio is locked.
- * We cannot race with other accessors, and the swap entry is guaranteed to be
- * valid the whole time (since swap cache implies one refcount).
+ * Entered with the cluster locked, but might drop the lock in between.
+ * This is because several operations, such as releasing physical swap slots
+ * (i.e swap_slot_free_nr()) require the cluster to be unlocked to avoid
+ * deadlocks.
  *
- * We cannot assume that the backends will be of the same type,
- * contiguous, etc. We might have a large folio coalesced from subpages with
- * mixed backend, which is only rectified when it is reclaimed.
+ * This is safe, because:
+ *
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
-static void release_backing(swp_entry_t entry, int nr)
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
@@ -552,9 +562,8 @@ static void release_backing(swp_entry_t entry, int nr)
 
 	VM_WARN_ON(!entry.val);
 
-	rcu_read_lock();
 	for (i = 0; i < nr; i++) {
-		desc = vswap_iter(&cluster, entry.val + i);
+		desc = __vswap_iter(cluster, entry.val + i);
 		VM_WARN_ON(!desc);
 
 		/*
@@ -574,7 +583,6 @@ static void release_backing(swp_entry_t entry, int nr)
 		if (desc->type == VSWAP_ZSWAP && desc->zswap_entry) {
 			zswap_entry_free(desc->zswap_entry);
 		} else if (desc->type == VSWAP_SWAPFILE) {
-			phys_swap_released++;
 			if (!phys_swap_start) {
 				/* start a new contiguous range of phys swap */
 				phys_swap_start = swp_slot_offset(desc->slot);
@@ -590,56 +598,49 @@ static void release_backing(swp_entry_t entry, int nr)
 
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
-
-	if (phys_swap_released)
-		mem_cgroup_uncharge_swap(entry, phys_swap_released);
 }
 
+static void __vswap_swap_cgroup_clear(struct vswap_cluster *cluster,
+		swp_entry_t entry, unsigned int nr_ents);
+
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
 
-	release_backing(entry, 1);
-	mem_cgroup_clear_swap(entry, 1);
+	for (i = 0; i < nr; i++) {
+		desc = __vswap_iter(cluster, entry.val + i);
+		/* Clear shadow if present */
+		if (xa_is_value(desc->shadow))
+			desc->shadow = NULL;
+	}
 
-	/* erase forward mapping and release the virtual slot for reallocation */
-	spin_lock(&cluster->lock);
-	release_vswap_slot(cluster, entry.val);
+	release_backing(cluster, entry, nr);
+	__vswap_swap_cgroup_clear(cluster, entry, nr);
+
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
@@ -1772,11 +1805,10 @@ void zswap_entry_store(swp_entry_t swpentry, struct zswap_entry *entry)
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
@@ -1850,6 +1882,22 @@ static unsigned short __vswap_cgroup_record(struct vswap_cluster *cluster,
 	return oldid;
 }
 
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
 static unsigned short vswap_cgroup_record(swp_entry_t entry,
 				unsigned short memcgid, unsigned int nr_ents)
 {
@@ -1955,6 +2003,11 @@ unsigned short lookup_swap_cgroup_id(swp_entry_t entry)
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


