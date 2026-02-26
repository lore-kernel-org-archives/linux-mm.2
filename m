Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED004FCE08C
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 19:30:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 49F276B014A; Thu, 26 Feb 2026 14:30:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 448CF6B014C; Thu, 26 Feb 2026 14:30:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 32B1B6B020F; Thu, 26 Feb 2026 14:30:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 162066B014A
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 14:30:00 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D14CA13A23B
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 19:29:56 +0000 (UTC)
X-FDA: 84487597992.28.C08EC34
Received: from mail-ot1-f47.google.com (mail-ot1-f47.google.com [209.85.210.47])
	by imf11.hostedemail.com (Postfix) with ESMTP id CA03C40006
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 19:29:54 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=CG5LVtz5;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.47 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772134194; a=rsa-sha256;
	cv=none;
	b=6eBNluNMz4RtTC/Kg7WiKtZCaukewB0SQi0pUbZjSKZJBj8Lj1b0+bcUt3PCumaA6gxA6l
	cwoquZkqoNmKIdw3TieAJPGHfGoeATd7kF07W7KTAO5cW6iN/tqIJ+1DAxjRZEntQIKXCE
	Y1wL59L7xn2MJBnciItuQfVNuoXuDC4=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=CG5LVtz5;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.47 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772134194;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DB+jMUpA86bxO+NhQL7ENpCNqUG0HUtrRjDNh//YUrM=;
	b=fYkUk9cSdtKIrXLvk3br+lebxodeA6RJ8sz+tzHLgn3JkGkT9+AxS8W1rzfhSJ+K2OqQaR
	qBto2sjoZwi1xo4Zp1bh0CbLUo68+FgsJR7v3M7m+WwHUMTjfY4Hxo/cNYaoUx/Ykjam9i
	/CkEyPvkrVUYB8kNaWYNmeygAIMyCAU=
Received: by mail-ot1-f47.google.com with SMTP id 46e09a7af769-7d4c307db9aso687066a34.3
        for <linux-mm@kvack.org>; Thu, 26 Feb 2026 11:29:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772134194; x=1772738994; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DB+jMUpA86bxO+NhQL7ENpCNqUG0HUtrRjDNh//YUrM=;
        b=CG5LVtz5NK0XjJIjqiF0/qpEs1IhMGIibBsJVyuUR+eYVlgIaV9Cawxwe0F2yE+QyM
         3qsogRC1/5bzEGmA2x8iKsBvHMoZCgmaZTLUfBIxSjgpDpS56orFhBT1d6AiKnhK4Wpq
         G4VgBIdmDJqjq0VyAelyBp0oZD9zVZdGsB3ziuQn6cCkDxuUs//JSwgGyFUfB1rhqdJV
         wUbihcvylKFxE0OVf53wx3WDOl4mi5+HdNIooa5ST2S1jZ1TuTu22+65EVWXEqWC2eQ5
         NJLjUw7ZkHksfnj1xfyrA/vP+UnHaMirNYc1eexc/zM+Bv4X0lSlxUfn7uSveUPAy7L2
         OOLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772134194; x=1772738994;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=DB+jMUpA86bxO+NhQL7ENpCNqUG0HUtrRjDNh//YUrM=;
        b=JuzySaNTqefQd0laAsm4bF0OCkD4SxcFlI73yeztD9KPm5+4uaUWVrFM261uxTnnnV
         cwgmYizrx1fy/vcmJ9fOnarUOasdtt92/2PhsOncw0Ku4ySrzF0Y602d4hqmFKXgCTwJ
         5bauTCHqFqvKAiUiiD7bmPnNZepfBsS3dWNE90o/HI+oeDlW9a9iukzLsoe+sco0TfNJ
         fDaTnQpx+cDvmn6ZPRUJvB4drXAJp+VYxjSwIG4oW/iymBRV6IN8FOKylwno0TuFuK0q
         kRfkYrUF2KxQw7Lhu0dykHQgOqkm6LDE9M7S761pP+fXyDHckcKEM+2/9/oPp6szcQxe
         yDsA==
X-Forwarded-Encrypted: i=1; AJvYcCV8FglyY56vHKAf5ejrVimoxGpfBN60h0c2JBaMPN1JBcUtHfEI3S36M7TxMU5guMhOwzoUxXfZ3g==@kvack.org
X-Gm-Message-State: AOJu0YyYL9aS4Txm3khbN6l7CHvddLUgHg/C1CN8+goYcKDCdml15xMJ
	tA4eiYYL7oG+CwTwePbocbnR17Mt2DlL1AgO1zaT+2tnDHyXEOtW5mal
X-Gm-Gg: ATEYQzy81TmLUwN6aokEcyE31OoT7YH/RAYuxFK9Ap/kNIFwM3T0a6hRF6tF4UyRD/+
	P9HG5JPRJNQVa5wKwNOjXZqqwprCpgUY8wFHZm+rhUOt0bHeCCgVmEo6r1v1pPd3HnFCjPcrKSO
	7BE002sgk/6dz0As7r/QBO0HWxz40nJWRxHbeDPO63G8urbEHelXsGsjJs5CSxSetJz0LrdYYta
	uWeyQuLH+buIWJ9mhoemfXBu2lA61uZgEmFEmxqldBh2PZnqPJaKBCTYh4q/0PYSg+l5JbcK6PM
	QuCdKrvlYkcYktqK6nIlkjhE7mgYTIryxLeBgYWPKAJvpoXDBllOXJT5rtRaVaEgwC3AYauL8SE
	7j4Ce32wMfAHmYYuC/vYw9eB/AhXZsgGzQG2p8Dv9fXe9pJjeRT5bSStXX5J8ZNTq2ZLc5qGfez
	bBMfH78v7FqcB2XfUqI4ikaA==
X-Received: by 2002:a05:6830:8388:b0:7cb:125d:2a43 with SMTP id 46e09a7af769-7d591be4a4dmr307474a34.28.1772134193631;
        Thu, 26 Feb 2026 11:29:53 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:5e::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d5866557c6sm2419781a34.24.2026.02.26.11.29.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Feb 2026 11:29:53 -0800 (PST)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Minchan Kim <minchan@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Nhat Pham <hoangnhat.pham@linux.dev>,
	Nhat Pham <nphamcs@gmail.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R . Howlett" <liam.howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH 8/8] mm/vmstat, memcontrol: Track ZSWAP_B, ZSWAPPED_B per-memcg-lruvec
Date: Thu, 26 Feb 2026 11:29:31 -0800
Message-ID: <20260226192936.3190275-9-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260226192936.3190275-1-joshua.hahnjy@gmail.com>
References: <20260226192936.3190275-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: CA03C40006
X-Stat-Signature: g56xxpdgt6bwx5y396j317bi6wsg5fu7
X-HE-Tag: 1772134194-512788
X-HE-Meta: U2FsdGVkX19kollx9gSKgRh+7PRlVwxFDIwOiDWb6bQXaaRb3pswfD+CIbssvQcJ8dG1kadZMBtpn/ihVeP8MR5Unj1xAP3aiMIbMHKx3TM7dOCQ5kRsjYuWaXYu994YqsOeOYXPFeWDzW0tJp5tGr5D0zzB7x6kL8GErGjGvx0aIw4VMhCarFfy0HkZjOh98CCaKw2oViktn1x36H/ztSYH0z/qFULu27Z8Wvwhxn5/qaYweZMqBRLhUwk0xGy0Dsqp6Tpr8G5rBD8NjZCTzKx9VCHKZELRDIIHg8OarHEnHKUcazvXU09vXiE5JKR5rl4KmWyWjB7cFjpd0tJTuFJxCVGjwht4fAXGCiyp3kz+s4xAi+SxbZuNy/8SoCkbLNAg/dye7tpVMk80iPpJjyz/PtNaK1W3kYy+xWxaYZC2lyO6Bye9ct2z8Rf7ZrJGQlejgjieF4fgzBuhmL7axq1XfgCgOBbEv30pD8VYEMRCzBt986jPBGgkvrUUpijf8msj55nkx1hX6Z77uC4pw4J0RKDLLzqaRT53OWX2bmtgxiaaIsT7jQxsKZe/Q/jlHRB8TrIUKJXf3NA3cgzhfxxfBHl+9JJnMjPurKaq6iK8u+yBfDz1LwQOre03kmLw6tULzVum2PtbGCwI6A1zeGzuv+7qS2OatHzT0WLPxz/SWyvQkI6cMY852CL79BnmJ52s8ZY0QG2Gu5EcvGVMZS8Hrnly3AqDqVSOLvIiBBs90Uk3sTTNzBrIPYu9Ch+LePlqLIglFXx+Zy2dVITv8Qi9d8q4FAawl6aVKL+IdH4Rgo7+Ohl/I9gptvdk5LcNr47djaQCpGsigWEitUu+i0r1zYoZIAkLTDlE3IptbcHqOu3hDmZCXxHkFD+KOpfvRtGQtpjcjbKsWcCdInEZtX7Vf8PCHAHvba7XFgOX++7i9GsAx2OGJysjYeRnXJc8P65nz9B6ISZNXKbZT4F
 oroCEFfe
 aGSwc6tU94gjFFgor5hyKRc3aErL/CDN5rtxCHxvBGgF/wkWGL6ImXQeNkchiwEsx8LdFxOXdtgmdKOZDPCOYLktIlsii/g+ztMuUfYh25KJ5lkMGnFQKl+XzhLsxwh05Y41TD5bKt5KU+vcn1ym5FNESJKQEjf0sclV+KMzgKtasGBWMBgSlrRsgdR1q+eToXRq9BI6pTabrpEI3bk99QxN0MqC8aqd15HZXpXeI5k5/Xs23b3sBQFJRrmERF2ClngBBUccafJ/e6L4uFL8DxQVMqWvMQ99i0xg1k7sZQITchiZhyaQiuqRdGlcpO9b/VdEAj3gTSh7qv9+cXOErH+PaZzcvdryjOAs1dBTnkr5QM/3f0J0IS3nTbxgiq7LvDKt/JrvsVeoks7ZvYbEF5/ZFCUZO2JbRNly6VV8w32nvjO0K5I9LxSILsp519iIDbKChfpn88o61WzD5nL054qj5AZ4N5pGYisZz19d+smjwsWMaBThtN760JtIfTACfy/Vyabau0O7SSDvV/aZp7pHH0rE3HB0YnAAjJiW8QqlIsc1zvuwNpMKt0fnG285LRSnIiOGQywTfn2TM3w7TT4Txv143O/0Cl0nm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that memcg charging happens in the zsmalloc layer where we have both
objcg and page information, we can specify which node's memcg lruvec
zswapped memory should be accounted to.

Move MEMCG_ZSWAP_B and MEMCG_ZSWAPPED_B from enum_node_stat_item to
int memcg_node_stat_items. Rename their prefix from MEMCG to NR to
reflect this move as well.

In addition, decouple the updates of node stats (vmstat) and
memcg-lruvec stats, since node stats can only track values at a
PAGE_SIZE granularity.

Finally, track the moving charges whenever a compressed object migrates
from one zspage to another.

memcg-lruvec stats are now updated precisely and proportionally when
compressed objects are split across pages. Unfortunately for node stats,
only NR_ZSWAP_B can be kept accurate. NR_ZSWAPPED_B works as a good
best-effort value, but cannot proportionally account for compressed
objects split across pages due to the coarse PAGE_SIZE granularity
of node stats. For such objects, NR_ZSWAPPED_B is accounted to the first
zpdesc's node stats.

Note that this is not a new inaccuracy, but one that is simply left
unable to be fixed as part of these changes. The small inaccuracy is
accepted in place of invasive changes across all of vmstat
infrastructure to begin tracking stats at byte granularity.

Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 include/linux/memcontrol.h |  5 +--
 include/linux/mmzone.h     |  2 ++
 mm/memcontrol.c            | 18 +++++-----
 mm/vmstat.c                |  2 ++
 mm/zsmalloc.c              | 72 ++++++++++++++++++++++++++++++--------
 mm/zswap.c                 |  4 +--
 6 files changed, 76 insertions(+), 27 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index d3952c918fd4..ba97b86d9104 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -37,8 +37,6 @@ enum memcg_stat_item {
 	MEMCG_PERCPU_B,
 	MEMCG_VMALLOC,
 	MEMCG_KMEM,
-	MEMCG_ZSWAP_B,
-	MEMCG_ZSWAPPED_B,
 	MEMCG_NR_STAT,
 };
 
@@ -932,6 +930,9 @@ void mem_cgroup_print_oom_group(struct mem_cgroup *memcg);
 void mod_memcg_state(struct mem_cgroup *memcg,
 		     enum memcg_stat_item idx, int val);
 
+void mod_memcg_lruvec_state(struct lruvec *lruvec, enum node_stat_item idx,
+			    int val);
+
 static inline void mod_memcg_page_state(struct page *page,
 					enum memcg_stat_item idx, int val)
 {
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 3e51190a55e4..ae16a90491ac 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -258,6 +258,8 @@ enum node_stat_item {
 #ifdef CONFIG_HUGETLB_PAGE
 	NR_HUGETLB,
 #endif
+	NR_ZSWAP_B,
+	NR_ZSWAPPED_B,
 	NR_BALLOON_PAGES,
 	NR_KERNEL_FILE_PAGES,
 	NR_VM_NODE_STAT_ITEMS
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index b662902d4e03..dc7cfff97296 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -331,6 +331,8 @@ static const unsigned int memcg_node_stat_items[] = {
 #ifdef CONFIG_HUGETLB_PAGE
 	NR_HUGETLB,
 #endif
+	NR_ZSWAP_B,
+	NR_ZSWAPPED_B,
 };
 
 static const unsigned int memcg_stat_items[] = {
@@ -339,8 +341,6 @@ static const unsigned int memcg_stat_items[] = {
 	MEMCG_PERCPU_B,
 	MEMCG_VMALLOC,
 	MEMCG_KMEM,
-	MEMCG_ZSWAP_B,
-	MEMCG_ZSWAPPED_B,
 };
 
 #define NR_MEMCG_NODE_STAT_ITEMS ARRAY_SIZE(memcg_node_stat_items)
@@ -726,7 +726,7 @@ unsigned long memcg_page_state_local(struct mem_cgroup *memcg, int idx)
 }
 #endif
 
-static void mod_memcg_lruvec_state(struct lruvec *lruvec,
+void mod_memcg_lruvec_state(struct lruvec *lruvec,
 				     enum node_stat_item idx,
 				     int val)
 {
@@ -1344,8 +1344,8 @@ static const struct memory_stat memory_stats[] = {
 	{ "vmalloc",			MEMCG_VMALLOC			},
 	{ "shmem",			NR_SHMEM			},
 #ifdef CONFIG_ZSWAP
-	{ "zswap",			MEMCG_ZSWAP_B			},
-	{ "zswapped",			MEMCG_ZSWAPPED_B		},
+	{ "zswap",			NR_ZSWAP_B			},
+	{ "zswapped",			NR_ZSWAPPED_B			},
 #endif
 	{ "file_mapped",		NR_FILE_MAPPED			},
 	{ "file_dirty",			NR_FILE_DIRTY			},
@@ -1392,8 +1392,8 @@ static int memcg_page_state_unit(int item)
 {
 	switch (item) {
 	case MEMCG_PERCPU_B:
-	case MEMCG_ZSWAP_B:
-	case MEMCG_ZSWAPPED_B:
+	case NR_ZSWAP_B:
+	case NR_ZSWAPPED_B:
 	case NR_SLAB_RECLAIMABLE_B:
 	case NR_SLAB_UNRECLAIMABLE_B:
 		return 1;
@@ -5424,7 +5424,7 @@ bool obj_cgroup_may_zswap(struct obj_cgroup *objcg)
 
 		/* Force flush to get accurate stats for charging */
 		__mem_cgroup_flush_stats(memcg, true);
-		pages = memcg_page_state(memcg, MEMCG_ZSWAP_B) / PAGE_SIZE;
+		pages = memcg_page_state(memcg, NR_ZSWAP_B) / PAGE_SIZE;
 		if (pages < max)
 			continue;
 		ret = false;
@@ -5453,7 +5453,7 @@ static u64 zswap_current_read(struct cgroup_subsys_state *css,
 	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
 
 	mem_cgroup_flush_stats(memcg);
-	return memcg_page_state(memcg, MEMCG_ZSWAP_B);
+	return memcg_page_state(memcg, NR_ZSWAP_B);
 }
 
 static int zswap_max_show(struct seq_file *m, void *v)
diff --git a/mm/vmstat.c b/mm/vmstat.c
index 99270713e0c1..4b10610bd999 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -1279,6 +1279,8 @@ const char * const vmstat_text[] = {
 #ifdef CONFIG_HUGETLB_PAGE
 	[I(NR_HUGETLB)]				= "nr_hugetlb",
 #endif
+	[I(NR_ZSWAP_B)]				= "zswap",
+	[I(NR_ZSWAPPED_B)]			= "zswapped",
 	[I(NR_BALLOON_PAGES)]			= "nr_balloon_pages",
 	[I(NR_KERNEL_FILE_PAGES)]		= "nr_kernel_file_pages",
 #undef I
diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index 6794927c60fb..548e7f4b8bf6 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -810,6 +810,7 @@ static void __free_zspage(struct zs_pool *pool, struct size_class *class,
 				struct zspage *zspage)
 {
 	struct zpdesc *zpdesc, *next;
+	bool objcg = !!zpdesc_objcgs(zspage->first_zpdesc);
 
 	assert_spin_locked(&class->lock);
 
@@ -823,6 +824,8 @@ static void __free_zspage(struct zs_pool *pool, struct size_class *class,
 		reset_zpdesc(zpdesc);
 		zpdesc_unlock(zpdesc);
 		zpdesc_dec_zone_page_state(zpdesc);
+		if (objcg)
+			dec_node_page_state(zpdesc_page(zpdesc), NR_ZSWAP_B);
 		zpdesc_put(zpdesc);
 		zpdesc = next;
 	} while (zpdesc != NULL);
@@ -963,11 +966,45 @@ static bool alloc_zspage_objcgs(struct size_class *class, gfp_t gfp,
 	return true;
 }
 
-static void zs_charge_objcg(struct zpdesc *zpdesc, struct obj_cgroup *objcg,
-			    int size, unsigned long offset)
+static void __zs_mod_memcg_lruvec(struct zpdesc *zpdesc,
+				  struct obj_cgroup *objcg, int size,
+				  int sign, unsigned long offset)
 {
 	struct mem_cgroup *memcg;
+	struct lruvec *lruvec;
+	int compressed_size = size, original_size = PAGE_SIZE;
+	int nid = page_to_nid(zpdesc_page(zpdesc));
+	int next_nid = nid;
+
+	if (offset + size > PAGE_SIZE) {
+		struct zpdesc *next_zpdesc = get_next_zpdesc(zpdesc);
+
+		next_nid = page_to_nid(zpdesc_page(next_zpdesc));
+		if (nid != next_nid) {
+			compressed_size = PAGE_SIZE - offset;
+			original_size = (PAGE_SIZE * compressed_size) / size;
+		}
+	}
+
+	rcu_read_lock();
+	memcg = obj_cgroup_memcg(objcg);
+	lruvec = mem_cgroup_lruvec(memcg, NODE_DATA(nid));
+	mod_memcg_lruvec_state(lruvec, NR_ZSWAP_B, sign * compressed_size);
+	mod_memcg_lruvec_state(lruvec, NR_ZSWAPPED_B, sign * original_size);
+
+	if (nid != next_nid) {
+		lruvec = mem_cgroup_lruvec(memcg, NODE_DATA(next_nid));
+		mod_memcg_lruvec_state(lruvec, NR_ZSWAP_B,
+				       sign * (size - compressed_size));
+		mod_memcg_lruvec_state(lruvec, NR_ZSWAPPED_B,
+				       sign * (PAGE_SIZE - original_size));
+	}
+	rcu_read_unlock();
+}
 
+static void zs_charge_objcg(struct zpdesc *zpdesc, struct obj_cgroup *objcg,
+			    int size, unsigned long offset)
+{
 	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
 		return;
 
@@ -977,28 +1014,30 @@ static void zs_charge_objcg(struct zpdesc *zpdesc, struct obj_cgroup *objcg,
 	if (obj_cgroup_charge(objcg, GFP_KERNEL, size))
 		VM_WARN_ON_ONCE(1);
 
-	rcu_read_lock();
-	memcg = obj_cgroup_memcg(objcg);
-	mod_memcg_state(memcg, MEMCG_ZSWAP_B, size);
-	mod_memcg_state(memcg, MEMCG_ZSWAPPED_B, 1);
-	rcu_read_unlock();
+	__zs_mod_memcg_lruvec(zpdesc, objcg, size, 1, offset);
+
+	/*
+	 * Node-level vmstats are charged in PAGE_SIZE units. As a
+	 * best-effort, always charge NR_ZSWAPPED_B to the first zpdesc.
+	 */
+	inc_node_page_state(zpdesc_page(zpdesc), NR_ZSWAPPED_B);
 }
 
 static void zs_uncharge_objcg(struct zpdesc *zpdesc, struct obj_cgroup *objcg,
 			      int size, unsigned long offset)
 {
-	struct mem_cgroup *memcg;
-
 	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
 		return;
 
 	obj_cgroup_uncharge(objcg, size);
 
-	rcu_read_lock();
-	memcg = obj_cgroup_memcg(objcg);
-	mod_memcg_state(memcg, MEMCG_ZSWAP_B, -size);
-	mod_memcg_state(memcg, MEMCG_ZSWAPPED_B, -1);
-	rcu_read_unlock();
+	__zs_mod_memcg_lruvec(zpdesc, objcg, size, -1, offset);
+
+	/*
+	 * Node-level vmstats are uncharged in PAGE_SIZE units. As a
+	 * best-effort, always uncharge NR_ZSWAPPED_B to the first zpdesc.
+	 */
+	dec_node_page_state(zpdesc_page(zpdesc), NR_ZSWAPPED_B);
 }
 
 static void migrate_obj_objcg(unsigned long used_obj, unsigned long free_obj,
@@ -1135,6 +1174,8 @@ static struct zspage *alloc_zspage(struct zs_pool *pool,
 		__zpdesc_set_zsmalloc(zpdesc);
 
 		zpdesc_inc_zone_page_state(zpdesc);
+		if (objcg)
+			inc_node_page_state(zpdesc_page(zpdesc), NR_ZSWAP_B);
 		zpdescs[i] = zpdesc;
 	}
 
@@ -1149,6 +1190,9 @@ static struct zspage *alloc_zspage(struct zs_pool *pool,
 err:
 	while (--i >= 0) {
 		zpdesc_dec_zone_page_state(zpdescs[i]);
+		if (objcg)
+			dec_node_page_state(zpdesc_page(zpdescs[i]),
+					    NR_ZSWAP_B);
 		free_zpdesc(zpdescs[i]);
 	}
 	cache_free_zspage(zspage);
diff --git a/mm/zswap.c b/mm/zswap.c
index 97f38d0afa86..9e845e1d7214 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -1214,9 +1214,9 @@ static unsigned long zswap_shrinker_count(struct shrinker *shrinker,
 	 */
 	if (!mem_cgroup_disabled()) {
 		mem_cgroup_flush_stats(memcg);
-		nr_backing = memcg_page_state(memcg, MEMCG_ZSWAP_B);
+		nr_backing = memcg_page_state(memcg, NR_ZSWAP_B);
 		nr_backing >>= PAGE_SHIFT;
-		nr_stored = memcg_page_state(memcg, MEMCG_ZSWAPPED_B);
+		nr_stored = memcg_page_state(memcg, NR_ZSWAPPED_B);
 		nr_stored >>= PAGE_SHIFT;
 	} else {
 		nr_backing = zswap_total_pages();
-- 
2.47.3


