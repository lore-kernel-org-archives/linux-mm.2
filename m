Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A467C4452B
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 03:25:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C97E6B00C5; Wed, 22 Jul 2026 23:25:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A1206B00C6; Wed, 22 Jul 2026 23:25:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B70A6B00C7; Wed, 22 Jul 2026 23:25:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C66E96B00C5
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 23:25:06 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1E5911C083D
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 03:25:06 +0000 (UTC)
X-FDA: 85018600212.13.3DEA272
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by imf11.hostedemail.com (Postfix) with ESMTP id 5958640003
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 03:25:04 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gykCpbqN;
	spf=pass (imf11.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784777104;
	b=magck33aLboAmtlFkFAP5bBNeCRV+K2UrjigBSbzpi/hpf+2qZqndtF1U83ssRuGTAHnaQ
	vXcPhNYg5J3gV6vS7uAolJrE9kflwKp03/RLa5qC+TkFB7UoKHElKTYRDeb6OqDo9UNEl8
	cZuc7jKaBMl/dLuO1+Y8U39BBHdCtQA=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gykCpbqN;
	spf=pass (imf11.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784777104;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t47mgjsy2KATKhTslu3AP/jd8ifMIeJbuWQDv9xr0N8=;
	b=Whx8YYqgD5XzInpUntwJZJRER617xq1KG8DP4cZfRgq4bb1P847R6Gp9T1+niHHVJ0xvxV
	C1CIQ9ygtl13HVfIWCp1CajfL4YqhWNzTq3/c3w0OI5DrAC6o6pNIoM5cXSp0xdlJgyQvN
	/V8M6XvbwZ9F8IH6unRofYv9PcYwLMg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784777102;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=t47mgjsy2KATKhTslu3AP/jd8ifMIeJbuWQDv9xr0N8=;
	b=gykCpbqNsx4BiZ36b+UTQGtY+ftHVgYOSP8swT3LMfmfhdE0M4m4FkiWOu7gTEKoKrv/Nr
	wKPC82RRw9bJ0XZNiur+JqNtAzBkesSdIgYJ8hUSDhf01VdoqTAAGATmEKcNmkMz4rouDE
	iIuriFNDDi41duWXaSkBR/sMyyPEHJ4=
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
Subject: [PATCH -v4 1/2] memcg: move mem_cgroup_swappiness and vm_swappiness to mm/swap.h
Date: Thu, 23 Jul 2026 11:24:33 +0800
Message-Id: <20260723032434.2016749-2-ridong.chen@linux.dev>
In-Reply-To: <20260723032434.2016749-1-ridong.chen@linux.dev>
References: <20260723032434.2016749-1-ridong.chen@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 5958640003
X-Stat-Signature: 9mxpcmp9mhkbsmqtiqownkrehsibpi6w
X-Rspam-User: 
X-HE-Tag: 1784777104-24676
X-HE-Meta: U2FsdGVkX19E+l2DEmEY/SkYRG1V2sdPZuI08NyUgPbA8EAj2ca32aEpO4+CJvxGrcAsNB5yTYNzjEslZaCnTffOrLGD6gcMCu76+jC7+B1uZ0EuYHj2X2CT7XfOcxiyIo+iJV2wt0sPODYOx7Sh1cwLLiHtjRqktUXUtOfiAF+jVBfdov1qGkw6FLS64q/XTyWmnEk4EXE2gVC7ezv5dz5KoW/DM8ZSQDTfEOiJyQkrAW+XFN6mAEo5VGfy++hFa79iAAiTHkeulcOlZQ+VuBN9DtOpPX7qr7g6px7wF5BJX8bRgkU4SRz2XkPKB5jfGW6G2Y6P2bvWdINWKBtKdD5hqkuxOMCxgHZ+majW1BnRQ5nzP74mlhhJrc+Bza8/LiCcgjEsqCnNaH0gDxRi55C2kf6mKO2vK1Bs1Rykf1C1BwfgHBw2jYgvZ00b7Gl4gkNMzbIOMMuXICRIDY46YeGSss7Jfn97iJP7IqXBxQvCDTBAx54t3k5+q34R+aLh0U1yBWi/8oVDbmzsZwe5cG13BcSu7wPrjVAlg3VZyuGsinf5kLJ1i81T+XElwL/FoN8c/QhLg/ynB1HFI2xq4M7eJ1DR7FYDLP8WNyWb/eUumIfgTiU1PLOCO72hWqGzvOVvzFLR6HvjO7QGzs5Qpojoq6jbBsy0LDiNkjKCLPSWqiYWZxHd0hnPMgEiShWA5utkKPmpDEZgofUT+3s80z6vhcolzX1iIjGPJowIltCfPewbb8/Em/3IbOqtYZeMazWbQbu3EjYHDHGXXLJsTnpnQOj/Nm521Af/s+yasJ3aDvm664HvhfSiyxk68UOT6BQs5j2TB/L89RZxkeRACFCFF9YXS6DF8jCMN67vKGteaMO4pE+hs1V1r2D8AqOq+WzQ0y/BdrpcvbwzHd/QKV4UX6LPWCCVT6oJZ6MPhO8xiZniZh09XdDbtmKyACmhHbxpwfQIkiWPWRYtNN2
 BdvMyzuN
 ZLL38A2xC4ASGJmil6yBKjNRcAe5Q8s6/czhrqXY22gY6jZHZmuiiZMW7QeiAxvkoBbjtqUtkgFWP/B9Tqc1DjqYVqypsi0RRqWKhbmLpebftAyHKwvtQUEs+AxcgwL2BeiUsJgBTsHMJrqiifc2IXF0qVmz511bJA60UP/ecIP/PF+W90bcCIjONfvweGAHkjYgDjM9rnTXWDTh+QtsBReeHTu/6WjzzDplyfWvuCA6l26LyiB6GY1/LkOUyjkq5k48WUTuMcqhOVnacSG92FN71+At7nlU4iXQq5AX8Zvnx/y3hvDv3hoTbQ4BBf1SakeO0r3aa+qUZVIiRgF/jEhUSbZ+CDSouAZeU9H8uXGBAfPo=
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
index abd26588abd2..d077e5893a42 100644
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
+		return READ_ONCE(memcg->swappiness);
+#endif
+	return READ_ONCE(vm_swappiness);
+}
+
 #ifdef CONFIG_SWAP
 #include <linux/swapops.h> /* for swp_offset */
 #include <linux/blk_types.h> /* for bio_end_io_t */
-- 
2.34.1


