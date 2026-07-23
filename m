Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6DBAC4453D
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 02:59:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B4F5D6B00B7; Wed, 22 Jul 2026 22:59:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD8876B00BA; Wed, 22 Jul 2026 22:59:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9CD946B00B7; Wed, 22 Jul 2026 22:59:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 65BA96B00B7
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 22:59:32 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DE8261401B3
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 02:59:31 +0000 (UTC)
X-FDA: 85018535742.11.ABE0F8E
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	by imf22.hostedemail.com (Postfix) with ESMTP id 98F5CC0002
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 02:59:29 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nbuUfWiE;
	spf=pass (imf22.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784775570;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0SOk+2wuxM+/tduJon+sQwHZrA6VBn52w7NMlr/qhlA=;
	b=cwXn2R9Tlpz5oex4a2KrDkVBva66AVW8sGUFdVmCsC4DdsLTRX8v0rqc+h/jCl5a7U1fwY
	dEwNmjbydnM0FdXLOyG2KpgKgGEYiyZaC/PawE6c+R9ccp6/bvuxwqERSTbkviduQe2Zza
	Ic9ycSPg8VH8HY+dixEXmIm49sCFJCk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784775570;
	b=XV5llT7wjdoMA0F1XU0Ap3NxyzSiRzB4Sf+uI9zia6Bw/c7gQvkshr8w3z5P0XKQTDLTjB
	CPqQ2ouxVMlRlJpPsyfLqH7c6YqIxeNdGVOG93G6P02A1STrdLIH5vtmRjf2tepq/LpAGD
	yYahlBS+RLiTIjB3AGwQwbiQ2dAgtqs=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nbuUfWiE;
	spf=pass (imf22.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784775567;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0SOk+2wuxM+/tduJon+sQwHZrA6VBn52w7NMlr/qhlA=;
	b=nbuUfWiEWSSW5EiGD75R6v9aTGI42ZzAR8m+X9PWJW7jZsb6rY6DvgOmiaRS+lMDTRSFnG
	/+1ingQ+ioKBmrTXKOkQ26ms5tOq2U6WLAzqqvby2xw5w3GmAmDnN6QYyGy7A5AEN/cvis
	OWKlclMrbNEkLVBW1fpSOeQ7EI/P9XE=
From: Ridong <ridong.chen@linux.dev>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>
Cc: Muchun Song <muchun.song@linux.dev>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	David Hildenbrand <david@kernel.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Song Hu <husong@kylinos.cn>,
	Ridong Chen <ridong.chen@linux.dev>,
	Ridong Chen <chenridong@xiaomi.com>
Subject: [PATCH -v3 1/2] memcg: move mem_cgroup_swappiness and vm_swappiness to mm/swap.h
Date: Thu, 23 Jul 2026 10:58:57 +0800
Message-Id: <20260723025858.1956584-2-ridong.chen@linux.dev>
In-Reply-To: <20260723025858.1956584-1-ridong.chen@linux.dev>
References: <20260723025858.1956584-1-ridong.chen@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 98F5CC0002
X-Stat-Signature: 4utowp1ubpync3o9ag5fy5gxtxfsz3xj
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1784775569-774425
X-HE-Meta: U2FsdGVkX1//bXAblUwIlJbIgmDDi3dDrxjvXYVlDrW5cVcEu++SoBNOtQoPV02uq3Ak1CUt4LhYRUxfNTedGafGVL2u+SEPYWy+bAYIwxdeIzAgsa2Nu31cEVKcGkVv5POFowlNL8QoUUKvHykKng6eSQP1z02KCOQ2l/75vbp4zqjFp34JfNhjiaIXIsd3PvPPLJ7K75sscMwbgoOan8eZ9XglvPn7wu8bq+e4JqDuW44sENHt5rzmar3WQI1Sr4XsGUMrLRfmmHTmn+QNVF2+evWw/zWniS/ZMj8nNrHAnyMaR4w5jItXy3GiijIRPzSJMvFBzbYGucSteeDSIT4I3fscL2sMzBqwTtpr9Rfq+Q+wLYHioTFGrr23Bfmnt0aCJ85Z7/hC67Nq3yIHTGHRwuJKWFlq/yNr2ud0vv0pO0aXgsf/HUO6nqfMyQEO7H5q+xDtOKWHt5jEBt2spZofhfFFpM6G0X3xbdWeTMgyOQYCHXrLYyPsigctuxFMG0sjNB5a6Uq/n3oEVHwAviAMJid/qceUjJI/jI6UGGKpS3CXHQghp4dcTNjVF2NmbElpW+0S4i1MVuT8EJ7DIsJ2G865yQ5+dahEXafJeLLCHEIiVphBXzkZ7jwivwHn2CWhfv8S6oF4us4UZI6fpzzaWpvUBmCYhWHcVGHuIDONhUQh7GXIqKJOTdS10Cmo4hAeLpL+s7qkW2CO+zPc0HwkkTy6QPY2a3UHOKfuXVj//4YBvwlTVf7ym3KttZ5KleJbtAX/2A8QeQN9rMT+ZsicNQb8UHX7Fbm8sCNh25YraMoMn25zyVxTwviQAeNjcoQbC82eDpz9jgJwLOiU4XoRJxmmVIx4xQcmJOPxE5fozaE0jNwVNIF2MRODkA5tWZrWSbhn8O3UxUcIWQa1b4tJbvDprtfAYqhttB1hWe7UhalXRtF9IoSqjvENibZjEqAXdZjRhDikYnAsJoL
 gVY5Eca2
 Ljgoxf4BMEg2oUZMtd75ukk/4cAmweHmg1EEE4dz1QUwzUKLAljZOfUqEErcccq63EHJUH7JD+UpAJrMh94mrPE04avLOw/VFBMM9+lS/PdQ4NpPutKJQlr3BNc0X2QxEOKbR+crp7PgE4xnRTCZcKFMx3n8iP34UPicY12VMJsIHdhq+qRLY4NLrDcf/N+38EnI7FMoIXaHOsy59/dfNXHDgaoqspD+Rezcx48ZS2bObCMLAzsz9a7DF+hF0+4RjNHriwB6kovRAIrG60ZCTt0MCsDZIJrmbH6oTn3wPmbl2jVi+OzGr6Tx76QjI/2rq8uGnvgjE/8QGCUKCMCUeqWt6sywhcOk0tZTyawJsJlYIlRc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ridong Chen <chenridong@xiaomi.com>

The per-memcg swappiness knob is v1-only; v2 always uses global
vm_swappiness and ignores the per-cgroup field.

Both mem_cgroup_swappiness() and vm_swappiness are only used within
mm/ (memcontrol.c, memcontrol-v1.c, vmscan.c), so move them out of the
public include/linux/swap.h into the mm-private mm/swap.h. This keeps
unrelated declarations out of include/linux/swap.h.

Guard memcg->swappiness with CONFIG_MEMCG_V1 as well, so v2-only
kernels drop the unused field.

No functional change for v1; v2-only kernels drop the unused field.

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Song Hu <husong@kylinos.cn>
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
---
 include/linux/memcontrol.h |  4 ++--
 include/linux/swap.h       | 19 -------------------
 mm/memcontrol.c            |  4 ++--
 mm/swap.h                  | 13 +++++++++++++
 4 files changed, 17 insertions(+), 23 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 957260677678..e7a794dfb40e 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -239,8 +239,6 @@ struct mem_cgroup {
 	 */
 	bool oom_group;
 
-	int swappiness;
-
 	/* memory.events and memory.events.local */
 	struct cgroup_file events_file;
 	struct cgroup_file events_local_file;
@@ -318,6 +316,8 @@ struct mem_cgroup {
 	/* List of events which userspace want to receive */
 	struct list_head event_list;
 	spinlock_t event_list_lock;
+
+	int swappiness;
 #endif /* CONFIG_MEMCG_V1 */
 
 	struct mem_cgroup_per_node *nodeinfo[];
diff --git a/include/linux/swap.h b/include/linux/swap.h
index 0544b2ec4c56..45f301d73e2a 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -309,7 +309,6 @@ static inline bool lru_cache_disabled(void)
 }
 
 extern unsigned long shrink_all_memory(unsigned long nr_pages);
-extern int vm_swappiness;
 long remove_mapping(struct address_space *mapping, struct folio *folio);
 
 #if defined(CONFIG_SYSFS) && defined(CONFIG_NUMA)
@@ -473,25 +472,7 @@ static inline int add_swap_extent(struct swap_info_struct *sis,
 }
 #endif /* CONFIG_SWAP */
 #ifdef CONFIG_MEMCG
-static inline int mem_cgroup_swappiness(struct mem_cgroup *memcg)
-{
-	/* Cgroup2 doesn't have per-cgroup swappiness */
-	if (cgroup_subsys_on_dfl(memory_cgrp_subsys))
-		return READ_ONCE(vm_swappiness);
-
-	/* root ? */
-	if (mem_cgroup_disabled() || mem_cgroup_is_root(memcg))
-		return READ_ONCE(vm_swappiness);
-
-	return READ_ONCE(memcg->swappiness);
-}
-
 void lru_reparent_memcg(struct mem_cgroup *memcg, struct mem_cgroup *parent, int nid);
-#else
-static inline int mem_cgroup_swappiness(struct mem_cgroup *memcg)
-{
-	return READ_ONCE(vm_swappiness);
-}
 #endif
 
 #if defined(CONFIG_SWAP) && defined(CONFIG_MEMCG) && defined(CONFIG_BLK_CGROUP)
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 8319ad8c5c23..6864b76456fb 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -63,6 +63,7 @@
 #include <linux/sched/isolation.h>
 #include <linux/kmemleak.h>
 #include "internal.h"
+#include "swap.h"
 #include "swap_table.h"
 #include <net/sock.h>
 #include <net/ip.h>
@@ -4176,11 +4177,10 @@ mem_cgroup_css_alloc(struct cgroup_subsys_state *parent_css)
 #endif
 	page_counter_set_high(&memcg->swap, PAGE_COUNTER_MAX);
 	if (parent) {
-		WRITE_ONCE(memcg->swappiness, mem_cgroup_swappiness(parent));
-
 		page_counter_init(&memcg->memory, &parent->memory, memcg_on_dfl);
 		page_counter_init(&memcg->swap, &parent->swap, false);
 #ifdef CONFIG_MEMCG_V1
+		WRITE_ONCE(memcg->swappiness, mem_cgroup_swappiness(parent));
 		memcg->memory.track_failcnt = !memcg_on_dfl;
 		WRITE_ONCE(memcg->oom_kill_disable, READ_ONCE(parent->oom_kill_disable));
 		page_counter_init(&memcg->kmem, &parent->kmem, false);
diff --git a/mm/swap.h b/mm/swap.h
index abd26588abd2..b0488f7b68b5 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -4,6 +4,7 @@
 
 #include <linux/atomic.h> /* for atomic_long_t */
 #include <linux/mm.h> /* for PAGE_SHIFT */
+#include <linux/memcontrol.h> /* for mem_cgroup_swappiness() */
 
 struct mempolicy;
 struct swap_iocb;
@@ -99,6 +100,18 @@ struct swap_ops {
 	void (*submit_read)(struct swap_io_ctx *ctx);
 };
 
+extern int vm_swappiness;
+
+static inline int mem_cgroup_swappiness(struct mem_cgroup *memcg)
+{
+#ifdef CONFIG_MEMCG_V1
+	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys) &&
+	    !mem_cgroup_disabled() && !mem_cgroup_is_root(memcg))
+		return memcg->swappiness;
+#endif
+	return READ_ONCE(vm_swappiness);
+}
+
 #ifdef CONFIG_SWAP
 #include <linux/swapops.h> /* for swp_offset */
 #include <linux/blk_types.h> /* for bio_end_io_t */
-- 
2.34.1


