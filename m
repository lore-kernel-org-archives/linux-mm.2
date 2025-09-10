Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75C8FCAC58F
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 23:57:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB1FC8E0009; Wed, 10 Sep 2025 19:57:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A23F98E0001; Wed, 10 Sep 2025 19:57:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 913748E0009; Wed, 10 Sep 2025 19:57:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7DBBA8E0001
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 19:57:45 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2BFB41A02B2
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 23:57:45 +0000 (UTC)
X-FDA: 83875005690.17.19C113B
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	by imf05.hostedemail.com (Postfix) with ESMTP id 690F9100005
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 23:57:43 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=B5VMqb9M;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf05.hostedemail.com: domain of 3dRDCaAgKCOoWUZeQkTaSaaSXQ.OaYXUZgj-YYWhMOW.adS@flex--kinseyho.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3dRDCaAgKCOoWUZeQkTaSaaSXQ.OaYXUZgj-YYWhMOW.adS@flex--kinseyho.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757548663; a=rsa-sha256;
	cv=none;
	b=arduidnu665OPtx0j/3/BSipt9rWD5VwKh1FH7q5rDq0d7dRJk4qZCisLTDPFhvO/CM3XC
	L88Q2xtzjFdQvFa7dg9Yobf92R/NgzzKALzxjBekMIorThwUc8d7HyX1BxmmSM34brANd5
	mOBrECJjR83hrYbpiXHnHrXzovcPvsc=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=B5VMqb9M;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf05.hostedemail.com: domain of 3dRDCaAgKCOoWUZeQkTaSaaSXQ.OaYXUZgj-YYWhMOW.adS@flex--kinseyho.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3dRDCaAgKCOoWUZeQkTaSaaSXQ.OaYXUZgj-YYWhMOW.adS@flex--kinseyho.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757548663;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bGwQF+CXl3vYtzdP9mbgCIJA/DkcNggZlxUnpS7TgbA=;
	b=Yc6wIkPCiOo6Fpt14WdjE4mT2Zwowp5TRNhJrCmFaGUHEf8C1m3PCojxbmuxfQs1s38B4z
	SqGTiMEAi6apMQdmLTAzMq+VgrkY9VWUDCqLS0ycS54Bcm0VDrEuH56bpPGgJkOjlHmdvB
	UtKe/k4ec8ukbBtQ7x1bcPAsX2rCg2c=
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-24c8264a137so1012305ad.3
        for <linux-mm@kvack.org>; Wed, 10 Sep 2025 16:57:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757548662; x=1758153462; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=bGwQF+CXl3vYtzdP9mbgCIJA/DkcNggZlxUnpS7TgbA=;
        b=B5VMqb9MIBqM9xlOtGhTQCbUGNuHAic3o++7EHZrHWB5X9JKquF6KxUvarI14paJgO
         veE9rTjRF4xgPsuXC0FvK6IuvM4nPVpcAWad8M9QD4hGYB+y+PzzTmuJWpk22t6ShpwM
         +dJ1sOt7dvhVdBvLdxmo8i++sDCixLdVuMJbKs//gXBbBd4ZvMHbUE3QcbO/SB8oKltd
         XtErdGt990dk0nPbUr2Ek0Xkz77dVCStZj9AT8lNwFWFHfzprUzp/JccA1HnPMuYcKxD
         IZME0tYxyVLryAyDA7RTsTHjjNERKlit2Fn7rtRkr3bxOb8vLN3Jmgn61yqjOCCk8x7N
         310A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757548662; x=1758153462;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bGwQF+CXl3vYtzdP9mbgCIJA/DkcNggZlxUnpS7TgbA=;
        b=ThAotlwYLJ2/XYAjNVHuvM3rlDApbokun6HnQZrl7rvt80CYtJCcdLcUktnb8+z44W
         WvxU5td9ZWzFpJht0SUTc9hD4NH+R8hHWJBpBHwDjbCgnkv34hP+Q40rK3DoChZTioKf
         +j3jXmjtyFVpoXciGJQScYRHUiVBwYEGYsJvii0f/iU3FRkUsJvmiIGFHGhKGeZyhy0i
         GPQp6QKoaOmlq+uiB45BVGczk9De872j9ZlnJwQEUyPcKA6QY/hIU4LT3CTeJcQoIb8y
         XttloBMss5Y9OPQeh2doL+Hs1Wif5E7XupunbCSABAut9ceW3ZiWwfNSmTOB5r3uTjRA
         btcg==
X-Gm-Message-State: AOJu0Yzc4CMVkqfMUNkMOSM5aIfGxOzm1FbZ3/5qZ/3QhRc31SB74onC
	/VET8sRKCeG8YIoxvDawIbpwvQyWRrvTM47GJfsZR3CXSgP1uyPIJz9mSDNVQHUG9RFaz7fnaWP
	ffU03/IVBZs2g4Di2Is4NYMpyeBwqdkoa9g4quyATmW+NlqsVR9uHmjTCEV3mv7xeYBVlQ6i8Fw
	CbtwZKMHLc2SsiNKdRFKgr1H07eiU9+k5dtYTTUByCrQ==
X-Google-Smtp-Source: AGHT+IFgMc9+BRlDZ/xcmHEhHQ3WZP/Hvgh8+t59rNiHJPd+WEnbMa1Kj1RSd0TLn33KhEA3jAl11A/Teaqamg==
X-Received: from pljf9.prod.google.com ([2002:a17:902:ff09:b0:24c:b6ae:fcb0])
 (user=kinseyho job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:3d05:b0:24c:a417:4490 with SMTP id d9443c01a7336-2516ce60006mr244218345ad.5.1757548661978;
 Wed, 10 Sep 2025 16:57:41 -0700 (PDT)
Date: Wed, 10 Sep 2025 16:51:21 -0700
In-Reply-To: <20250910235121.2544928-1-kinseyho@google.com>
Mime-Version: 1.0
References: <20250910235121.2544928-1-kinseyho@google.com>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Message-ID: <20250910235121.2544928-3-kinseyho@google.com>
Subject: [RFC PATCH v2 2/2] mm: klruscand: use mglru scanning for page promotion
From: Kinsey Ho <kinseyho@google.com>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: Jonathan.Cameron@huawei.com, dave.hansen@intel.com, gourry@gourry.net, 
	hannes@cmpxchg.org, mgorman@techsingularity.net, mingo@redhat.com, 
	peterz@infradead.org, raghavendra.kt@amd.com, riel@surriel.com, 
	rientjes@google.com, sj@kernel.org, weixugc@google.com, willy@infradead.org, 
	ying.huang@linux.alibaba.com, ziy@nvidia.com, dave@stgolabs.net, 
	nifan.cxl@gmail.com, xuezhengchu@huawei.com, yiannis@zptcorp.com, 
	akpm@linux-foundation.org, david@redhat.com, byungchul@sk.com, 
	kinseyho@google.com, joshua.hahnjy@gmail.com, yuanchu@google.com, 
	balbirs@nvidia.com, alok.rathore@samsung.com, lorenzo.stoakes@oracle.com, 
	axelrasmussen@google.com, Liam.Howlett@oracle.com, vbabka@suse.cz, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, 
	zhengqi.arch@bytedance.com, shakeel.butt@linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 690F9100005
X-Stat-Signature: w48jbeybsnqmjm51y4y5wkpz4yh7m5t1
X-Rspam-User: 
X-HE-Tag: 1757548663-904959
X-HE-Meta: U2FsdGVkX18lA0DhxtI9LT8x0oSfcSxhsaDbHBo5S2CHhzyiVBkjULzSd/97N1vLD2Ezgt9wrOIkNEfmYrqaxG8JYvmUHzDml3TliNvdGKo9sc7ZlmmdoR4IdGXdSGqa5UVwxYJHR75aFXlsRmdJQ816R72pzEYA+A/DxBFhJhytga1ISV5FLsRBB1E6RjBMk7lpm5kSnxw07wZrkiae1PLMCjIpFXkoUcU8S9JbGzOskaHqWZa9cXYjqHw4vLroSKwPhWSEeOX95rs97aB93zk5qWvkZ3G+foU6DmatSq03MTsOCFs7lfuVs0Km9+/lpKSVu7LTfeUVOKQzLVhvxe6u0UZnAS5UaOi/rUF09kSqOG5FCtI6M5PS+xbrGDX7bDlbWOBTAgOeywzbOqlEldUjaiwocEYj7MZ2YbWt3zKacspBR40cq5zf6y44CzkLfj4sZI9/zUaWZr0sgTKawaYI3wNP35G1IGD5zMR3TvkdiSZFx2q27n9utvlzRIyYutyUwyBRTWp9eQeXgrVN+jU5HfebVxkqeSLcXAcjkdMFdlxPMIE8rFFD20DVWGqA+eYShhcKz4rCe3kblrX+J+3jeg928tmL8wzphupGvN2T8PjoY6erY9KD+KaPc5UG1eWsK3VQJ4/VXwBv+XHfXrq2x7DWIHWeUc1bAQkqDA+IrzSdQ/hUBd2RzJfPq87MPnoIAyjNrb8A+FGchMjxqFYAGoIWMFW/1IDEb7rjMNEs1jUepQoxKpYY6H9Rr+2RoAk5Nju5R6L4bLqgHg3kcogcSfqVNOn+unfCFaB/mTmVZB3/ukmnzUt3UuKPFjCp5/kBfMJNwzEYpqLb+Sxza2od6qnZF3R06lD9XG82s1td4S3zPKLfxHC/2n6mZLb5+4NT1ZO30LNCcJFiXe83wiXHFZJV+s5vpSSQnTBI2pMVm1iIYitFP6mU52YF9kebPytmXhUxPlNWoqlIpey
 dgVmRdyx
 3KnBA5lc2gT4++YGQ2y9hx7SEymMS7nwPgQqJfwyhDgvmfhIeOEUPX52y4fmd3o8XZjVR92x/Hd8snPjKeX/A3obS66PcHqf0BXli7i5uAADDKWem9uA0ExBhpe9WT3MBw5tClq0RvBzB3xy+2sFd2nokAhPizN+EeOqrhwHm0GWbCtXTC+4JfRhpBUvYfyAjKR36nkfOVVgOZlvnYwlhzoWO6lghL0Y1ln43Wl4J5W5Sr/QobwJyhQJt6iGAaHiVqSuw+5PdnlYo6Z0iZexqvcRqYH+pHtF2ViHpnpez8Nmk17CHgc2mp73wwS4RKUBxWv5xtF1hFd/wrEbz3qJFglPRkVlf8nXZRz3wcjhpP8dcgJjjWOJMqHgDJZ3U6eDqk1lFf9/aKaQJy6L0tzQ3f6ji6TxajANPwiNGKc+6A/l8sBp6xBu2exUnKiFhREeDcFyYBNG+IaN+cnDO5Vi6KVUpn8W8rzjJ0I5ItG/kwD1cAI4V/lTLpEHy9s5gAui/VXui+bDzCSnsn9AERZhliRRlc4qfJYnQ7LDluaLzmsSNE1GNYfDwBNXwLB8+m9Kojc9jP6s4HXK/HOculx7aETx9uUnU5oOVN9jlvY4BgTy2t4/lrqjdKz/UyfVWcX11DKfx3ku1p9VbhjLY8IkoTiWGw3z+2Qyo4xEe
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce a new kernel daemon, klruscand, that periodically invokes the
MGLRU page table walk. It leverages the new callbacks to gather access
information and forwards it to the kpromoted daemon for promotion
decisions.

This benefits from reusing the existing MGLRU page table walk
infrastructure, which is optimized with features such as hierarchical
scanning and bloom filters to reduce CPU overhead.

As an additional optimization to be added in the future, we can tune
the scan intervals for each memcg.

Signed-off-by: Kinsey Ho <kinseyho@google.com>
Signed-off-by: Yuanchu Xie <yuanchu@google.com>
---
 mm/Kconfig     |   8 ++++
 mm/Makefile    |   1 +
 mm/klruscand.c | 118 +++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 127 insertions(+)
 create mode 100644 mm/klruscand.c

diff --git a/mm/Kconfig b/mm/Kconfig
index 8b236eb874cf..6d53c1208729 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -1393,6 +1393,14 @@ config PGHOT
 	  by various sources. Asynchronous promotion is done by per-node
 	  kernel threads.
 
+config KLRUSCAND
+	bool "Kernel lower tier access scan daemon"
+	default y
+	depends on PGHOT && LRU_GEN_WALKS_MMU
+	help
+	  Scan for accesses from lower tiers by invoking MGLRU to perform
+	  page table walks.
+
 source "mm/damon/Kconfig"
 
 endmenu
diff --git a/mm/Makefile b/mm/Makefile
index ecdd5241bea8..05a96ec35aa3 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -148,3 +148,4 @@ obj-$(CONFIG_EXECMEM) += execmem.o
 obj-$(CONFIG_TMPFS_QUOTA) += shmem_quota.o
 obj-$(CONFIG_PT_RECLAIM) += pt_reclaim.o
 obj-$(CONFIG_PGHOT) += pghot.o
+obj-$(CONFIG_KLRUSCAND) += klruscand.o
diff --git a/mm/klruscand.c b/mm/klruscand.c
new file mode 100644
index 000000000000..1ee2ac906771
--- /dev/null
+++ b/mm/klruscand.c
@@ -0,0 +1,118 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#include <linux/memcontrol.h>
+#include <linux/kthread.h>
+#include <linux/module.h>
+#include <linux/vmalloc.h>
+#include <linux/random.h>
+#include <linux/migrate.h>
+#include <linux/mm_inline.h>
+#include <linux/slab.h>
+#include <linux/sched/clock.h>
+#include <linux/memory-tiers.h>
+#include <linux/sched/mm.h>
+#include <linux/sched.h>
+#include <linux/pghot.h>
+
+#include "internal.h"
+
+#define KLRUSCAND_INTERVAL 2000
+#define BATCH_SIZE (2 << 16)
+
+static struct task_struct *scan_thread;
+static unsigned long pfn_batch[BATCH_SIZE];
+static int batch_index;
+
+static void flush_cb(void)
+{
+	int i;
+
+	for (i = 0; i < batch_index; i++) {
+		unsigned long pfn = pfn_batch[i];
+
+		pghot_record_access(pfn, NUMA_NO_NODE,
+					PGHOT_PGTABLE_SCAN, jiffies);
+
+		if (i % 16 == 0)
+			cond_resched();
+	}
+	batch_index = 0;
+}
+
+static bool accessed_cb(unsigned long pfn)
+{
+	WARN_ON_ONCE(batch_index == BATCH_SIZE);
+
+	if (batch_index < BATCH_SIZE)
+		pfn_batch[batch_index++] = pfn;
+
+	return batch_index == BATCH_SIZE;
+}
+
+static int klruscand_run(void *unused)
+{
+	struct lru_gen_mm_walk *walk;
+
+	walk = kzalloc(sizeof(*walk),
+		       __GFP_HIGH | __GFP_NOMEMALLOC | __GFP_NOWARN);
+	if (!walk)
+		return -ENOMEM;
+
+	while (!kthread_should_stop()) {
+		unsigned long next_wake_time;
+		long sleep_time;
+		struct mem_cgroup *memcg;
+		int flags;
+		int nid;
+
+		next_wake_time = jiffies + msecs_to_jiffies(KLRUSCAND_INTERVAL);
+
+		for_each_node_state(nid, N_MEMORY) {
+			pg_data_t *pgdat = NODE_DATA(nid);
+			struct reclaim_state rs = { 0 };
+
+			if (node_is_toptier(nid))
+				continue;
+
+			rs.mm_walk = walk;
+			set_task_reclaim_state(current, &rs);
+			flags = memalloc_noreclaim_save();
+
+			memcg = mem_cgroup_iter(NULL, NULL, NULL);
+			do {
+				struct lruvec *lruvec =
+					mem_cgroup_lruvec(memcg, pgdat);
+				unsigned long max_seq =
+					READ_ONCE((lruvec)->lrugen.max_seq);
+
+				lru_gen_scan_lruvec(lruvec, max_seq, accessed_cb, flush_cb);
+				cond_resched();
+			} while ((memcg = mem_cgroup_iter(NULL, memcg, NULL)));
+
+			memalloc_noreclaim_restore(flags);
+			set_task_reclaim_state(current, NULL);
+			memset(walk, 0, sizeof(*walk));
+		}
+
+		sleep_time = next_wake_time - jiffies;
+		if (sleep_time > 0 && sleep_time != MAX_SCHEDULE_TIMEOUT)
+			schedule_timeout_idle(sleep_time);
+	}
+	kfree(walk);
+	return 0;
+}
+
+static int __init klruscand_init(void)
+{
+	struct task_struct *task;
+
+	task = kthread_run(klruscand_run, NULL, "klruscand");
+
+	if (IS_ERR(task)) {
+		pr_err("Failed to create klruscand kthread\n");
+		return PTR_ERR(task);
+	}
+
+	scan_thread = task;
+	return 0;
+}
+module_init(klruscand_init);
-- 
2.51.0.384.g4c02a37b29-goog


