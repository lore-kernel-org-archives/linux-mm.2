Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72D3A1125876
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 19:52:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F4C36B009B; Wed, 11 Mar 2026 15:52:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 380746B009D; Wed, 11 Mar 2026 15:52:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1363C6B009E; Wed, 11 Mar 2026 15:52:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F229E6B009B
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 15:52:09 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BA48D888F9
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 19:52:09 +0000 (UTC)
X-FDA: 84534828378.19.2E05F9F
Received: from mail-oi1-f171.google.com (mail-oi1-f171.google.com [209.85.167.171])
	by imf29.hostedemail.com (Postfix) with ESMTP id E3B8312000D
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 19:52:07 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LmjL2AGJ;
	spf=pass (imf29.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.167.171 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773258727;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e4vnZsb9mXNhtrNGbaJxIgoiKf+xedfYV6/25GSFY7Q=;
	b=y9fcy7Xz97W7UzD9DZlLqRR+c7rHynuoLeu+xl5yPoIUeFGnXJzO9HELAf3GM+XVUwL2uY
	RKTwxDr1yWZwbYtv7HE3t/hFlGnhtR6BtcQXYckNRyJklBwbCU3CWTb23Q3m10sMwne1nh
	45rw8lwZ1Hyy6ZQCEHI+g8DyLtLfa3U=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773258728; a=rsa-sha256;
	cv=none;
	b=vWZU9QUWGLuKYQGMhoCFnBPMzm+PQjBCPMN/5068KV/oLJOAczR+h1Kng3QqEf8tHAZEVp
	THrz7B0R8Dq6pOGE3xaU4tYTma7J65hCsTUKcV9EkfcqGw7d6L7sSSZwL1vM27aHESN51X
	w9FYT9Eg5xXW9C3ZaNPhbYbg1vRweRQ=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LmjL2AGJ;
	spf=pass (imf29.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.167.171 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-oi1-f171.google.com with SMTP id 5614622812f47-466f00535cfso224577b6e.1
        for <linux-mm@kvack.org>; Wed, 11 Mar 2026 12:52:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773258727; x=1773863527; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e4vnZsb9mXNhtrNGbaJxIgoiKf+xedfYV6/25GSFY7Q=;
        b=LmjL2AGJUAPCpdlqUzEtSFcHmFMP4+5s28W8F8XPD38pDduzibmLvbrb8rutOZ9xQh
         VIDpbIXJFu8PwNPJ3DYj92PqfxSnrZ63Bsqx6nKdr4tcDIK08yIJTLWh5jOzq2CSCmIS
         ln5ViMxbXgTJGvS+I7uGstnS1FvRhuLC7EdtZSI+qCMUJE7kPKb75bbzOdHuix2bCPTv
         N8IiO/Za8nWAiTCYyha5knK/9sKnkxu5Vj1WzrTI8smVHOFwSWJ6zCgXg08hhU9y2bVF
         qU2mMTsg/2rIsbKF985wlCl3Cth/tGY2WkaG6+sgJEzW/ea7C5TzR/qokd/gCtfrDsWk
         5t0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773258727; x=1773863527;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=e4vnZsb9mXNhtrNGbaJxIgoiKf+xedfYV6/25GSFY7Q=;
        b=MXvrIqLlrri220b1o9hIpzLtcdHGIkNlpf1fJhd4GcgMHDaEXl1BRg31/0LoCLUNGw
         2wsKRT21MVRJY1NJKYCOvZ2FFUOP6POIFj8IsZf1KsNpFedU8spk8WBdDfZhDIJvlBTK
         KgphmPdLZpEbAgGsLvUVcyhwft57BAtbKltGOHPrgfaR83Ocj0WvpnUfvfSvGNuyAJIu
         Kp5V2UwvbSFd//IwKyi3McfT1M72y4dTzMy9UTA0YE5NNpTuu62bGwgSIn9MXLi73c2m
         1YiWsFbsGYgoRiPb4pPkEQ7dkuRA6tkQ099QK4Hb8wDIOftkpp4VXQcF7MFL86Id3bZE
         U57Q==
X-Forwarded-Encrypted: i=1; AJvYcCUV6vSlDCq8Bj9OfmVaGYJ5+zR2f0OMioDKSI4MjnPS+KZSePETAAh17NE1DMcQtMAXWDyQnnQKBg==@kvack.org
X-Gm-Message-State: AOJu0YxHRrMMzjbmIaZ0kKmFPf4cRWFYG8Yag2R+JEYTbUf/cZVzIbFw
	ZPVpntbd+8b3k+A/esiP1bSo6dsmqeULk/1EcltWftBwLYnAUG/Ipn4Z
X-Gm-Gg: ATEYQzz6hpdNCROoHNfKFKqTJSjxqOHo3NS5Z1oenOJEMD+HeKfiIqJOg7HFfUkX4Ac
	9exo0xqSHQkFwNzsmXon8AqG/GvcFDtLC4TYmf19gLdx5nqvhzjKZCvyy9tXQHC6IouhUOxHVRO
	Hvufm0xDpvmJuYOKwO7POo5mNmbG2q9S95wNAFuBMgLcU3bcvrZrspZb02L2DyOBtz0qztne1/e
	rCWQyCA9VlW9lO1gjwZs0omLMqXY3ey0e2EEVZdkStHdtWf0w7yO3e8Fl2ZbtvtJX93lPy0c4gf
	mFPJTcofS4oGpODUMtQsfTftQPAsa+J77vy3EkDR/jKY10Pv59jP/ppy8OcETxeK9YIpLCsKE/8
	BuQIQl+YLI7+ZYFZHQF7+KxOZX5REfUPHYU7/kBP/zDJ+xKAjdekAG7f6qipYZcgr2VBwSZ5FPW
	XpXxg7ilwKDu0QAcOs8LF1AGxeY1ntq2X8
X-Received: by 2002:a05:6820:c92:b0:67b:af79:4c1c with SMTP id 006d021491bc7-67bc887c1e1mr2569350eaf.2.1773258726845;
        Wed, 11 Mar 2026 12:52:06 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:47::])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-67bc9354e59sm1922332eaf.16.2026.03.11.12.52.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Mar 2026 12:52:06 -0700 (PDT)
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
Subject: [PATCH 09/11] mm/vmstat, memcontrol: Track ZSWAP_B, ZSWAPPED_B per-memcg-lruvec
Date: Wed, 11 Mar 2026 12:51:46 -0700
Message-ID: <20260311195153.4013476-10-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260311195153.4013476-1-joshua.hahnjy@gmail.com>
References: <20260311195153.4013476-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E3B8312000D
X-Stat-Signature: gm7ach3p6oy791sjyprqicn6a4ii3fwx
X-HE-Tag: 1773258727-845454
X-HE-Meta: U2FsdGVkX1/pJhX8m3C4L53Qqmn7L6RNso4P15q+nXcRm8nciGKmwX7RoCwoF1t31+/tVDzib7/psBRTTpwHQeKFFNeGLZYqBJ2K3hn+c3IONKgQrDDMN/hiv7ZxZhli0hx+HBFm+ClhFfSoVDkCmmuHxW43tPJBZpKbmECAuk8Efwqch7RrnYpjOLNyrRBDTmQZzCuBM+yhg1LzVwV4b7Gi/PGkV/spYilO+8rPGRXwEcceMnpFUXKHhkQto7FRP+PhvYtIEXCpI9bDmpTcilMaMa0dYgRTlP2jSZdnxJoOCxP0b/X1g7poGGXESfuIj7tH/3wPkRKBlUD6SJA3X/MJXkxSJzq1qX1C9cl6p9SxpTHwTH9eNRb8aoT1IZMwnlaUL6Eu3XeqQrWzstPQBwI8/o0jgd0hXLRvKR10kPoBZGNlCyoV1aQe/Kk2xMmecwM310D6PbuzZAayHYrA0suqF15GMWdy0rDc6tyENBN7wgqSUV3REYyzop0IfuUKgEtC4eCs93/3RWhK5M6soGQlT1s1IV/vXQC5WkUVLXGmKJPGaTEvPk9sqwVQOi5D8XPVUw5pAiYJ42d5rdOkUVzubp9GQ6w4+jzmANp9FdQ9Md9kIMABtWujsLH/eo77i/TZK5GsHeC4R/Kp2ZVn1VTXPPIpJfJhgNSp/cQvPin2nQvrDxloXSuDGI3krhqIbvkWHt1ADrMsnUYPyQT829AOnWANjG19efjHS6sK8i0Ky5g54i0lQH+1XEmM/1ZUbB0M5MNmjwC655WfCjZrejKr6QMxkFuGASuC2G7KanxW7efRjvb80R6efdUbECWY0/B9MvvKgzN3Su+tP+Rgk+sixw56Nf4p7d1mmrlzCx0GGY0wXf1he3V7q3Klcf0NyORZOjvi+0nruxJGyq35l8XaVgna9qjv26w3OXtlgppo4K8g3i0knShathwJzbLXIasu1Sk97fchHjcj4s2
 vO7VBd/k
 Adx2a6Qa32pFujHfqgoFNyJ80uQujKwKmx+E1RCpiQpCc0/5DF1XQyLHmZf8s++1+G7M9qkZ8vbIrztLcKSCigB8Y4cCoD/lrOWVmag+t6BnLOpHTLxtfPv2ukuIBzX33NU8gL0pROTI1qqngMgf0VZP1GYSclwilOE1buMIqFFOPAOv9TWgDtSWx/You9bW0G9KMrK3bYSPhQACCb7KLGhine174GAobwikYvCB+PwIBU0cSl1x05H5TCjuEqegtzLyMXzpMAeaC+q5YkXrj2S0M7YvISQqZiBHjjRamYTrffGMOXexWyA9b6MBOam9pqsOlkj3T+84xjVVb3kLn4qTi07o34k+nrwh9f5cXeBOQ+H6dPB3k/ygaYDkSuFjekReOeKPly+8MTv4O6oJ+eoT6xJyGQy8cO71LCFVtwV6+kL3PqQjlJ7P0gcmrkqQQRe2fC/GEBlX66uNuzHOheWTCw6gFeRkfa9T6dQdfCtfG/1vRyMUWRrl4Tpp14jtV4bK/5jN6U3MDXAFSxJadzX8s9+Wa5bffdLd+pywKF4Lf+4cDm7rfHLWtVFqfTy1sZbFJUiPqEGDgCZM9xcDOLwLmxnpVrNayMelq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that memcg charging happens in the zsmalloc layer where we have both
objcg and page information, we can specify which node's memcg lruvec
zswapped memory should be accounted to.

Move MEMCG_ZSWAP_B and MEMCG_ZSWAPPED_B from enum memcg_stat_item to
enum node_stat_item. Reanme their prefixes from MEMCG to NR to reflect
this move as well.

In addition, decouple the updates of node stats (vmstat) and
memcg-lruvec stats, since node stats can only track values at a
PAGE_SIZE granularity.

As a result of tracking zswap statistics at a finer granularity, the
charging from zsmalloc also gets more complicated to cover the cases
when the compressed object spans two zpdescs, which both live on
different nodes. In this case, the memcg-lruvec of both node-memcg
combinations are partially charged.

memcg-lruvec stats are now updated precisely and proportionally when
compressed objects are split across pages. Unfortunately for node stats,
only NR_ZSWAP_B can be kept accurate. NR_ZSWAPPED_B works as a good
best-effort value, but cannot proportionally account for compressed
objects split across nodes due to the coarse PAGE_SIZE granularity of
node stats. For such objects, NR_ZSWAPPED_B is accounted to the first
zpdesc's node stats.

Note that this is not a new inaccuracy, but one that is simply left
unable to be fixed as part of these changes. The small inaccuracy is
accepted in place of invasive changes across all of vmstat
infrastructure to begin tracking stats at byte granularity.

Finally, note that handling of objcg migrations across zspages (and
their subsequent migrations across nodes) are handled in the next patch.

Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 include/linux/memcontrol.h |   5 +-
 include/linux/mmzone.h     |   2 +
 include/linux/zsmalloc.h   |   6 +--
 mm/memcontrol.c            |  22 ++++----
 mm/vmstat.c                |   2 +
 mm/zsmalloc.c              | 104 +++++++++++++++++++++++++++----------
 mm/zswap.c                 |   7 ++-
 7 files changed, 102 insertions(+), 46 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index ce2e598b5963..b03501e0c09b 100644
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
 
@@ -927,6 +925,9 @@ struct mem_cgroup *mem_cgroup_get_oom_group(struct task_struct *victim,
 					    struct mem_cgroup *oom_domain);
 void mem_cgroup_print_oom_group(struct mem_cgroup *memcg);
 
+void mod_memcg_lruvec_state(struct lruvec *lruvec, enum node_stat_item idx,
+			    int val);
+
 /* idx can be of type enum memcg_stat_item or node_stat_item */
 void mod_memcg_state(struct mem_cgroup *memcg,
 		     enum memcg_stat_item idx, int val);
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
diff --git a/include/linux/zsmalloc.h b/include/linux/zsmalloc.h
index 6010d8dac9ff..fd79916c7740 100644
--- a/include/linux/zsmalloc.h
+++ b/include/linux/zsmalloc.h
@@ -24,11 +24,11 @@ struct zs_pool_stats {
 struct zs_pool;
 struct scatterlist;
 struct obj_cgroup;
-enum memcg_stat_item;
+enum node_stat_item;
 
 struct zs_pool *zs_create_pool(const char *name, bool memcg_aware,
-			       enum memcg_stat_item compressed_stat,
-			       enum memcg_stat_item uncompressed_stat);
+			       enum node_stat_item compressed_stat,
+			       enum node_stat_item uncompressed_stat);
 void zs_destroy_pool(struct zs_pool *pool);
 
 unsigned long zs_malloc(struct zs_pool *pool, size_t size, gfp_t flags,
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 1cb02d2febe8..d87bc4beff16 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -333,6 +333,8 @@ static const unsigned int memcg_node_stat_items[] = {
 #ifdef CONFIG_HUGETLB_PAGE
 	NR_HUGETLB,
 #endif
+	NR_ZSWAP_B,
+	NR_ZSWAPPED_B,
 };
 
 static const unsigned int memcg_stat_items[] = {
@@ -341,8 +343,6 @@ static const unsigned int memcg_stat_items[] = {
 	MEMCG_PERCPU_B,
 	MEMCG_VMALLOC,
 	MEMCG_KMEM,
-	MEMCG_ZSWAP_B,
-	MEMCG_ZSWAPPED_B,
 };
 
 #define NR_MEMCG_NODE_STAT_ITEMS ARRAY_SIZE(memcg_node_stat_items)
@@ -737,9 +737,8 @@ unsigned long memcg_page_state_local(struct mem_cgroup *memcg, int idx)
 }
 #endif
 
-static void mod_memcg_lruvec_state(struct lruvec *lruvec,
-				     enum node_stat_item idx,
-				     int val)
+void mod_memcg_lruvec_state(struct lruvec *lruvec, enum node_stat_item idx,
+			    int val)
 {
 	struct mem_cgroup_per_node *pn;
 	struct mem_cgroup *memcg;
@@ -766,6 +765,7 @@ static void mod_memcg_lruvec_state(struct lruvec *lruvec,
 
 	put_cpu();
 }
+EXPORT_SYMBOL(mod_memcg_lruvec_state);
 
 /**
  * mod_lruvec_state - update lruvec memory statistics
@@ -1363,8 +1363,8 @@ static const struct memory_stat memory_stats[] = {
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
@@ -1411,8 +1411,8 @@ static int memcg_page_state_unit(int item)
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
@@ -5482,7 +5482,7 @@ bool obj_cgroup_may_zswap(struct obj_cgroup *objcg)
 
 		/* Force flush to get accurate stats for charging */
 		__mem_cgroup_flush_stats(memcg, true);
-		pages = memcg_page_state(memcg, MEMCG_ZSWAP_B) / PAGE_SIZE;
+		pages = memcg_page_state(memcg, NR_ZSWAP_B) / PAGE_SIZE;
 		if (pages < max)
 			continue;
 		ret = false;
@@ -5511,7 +5511,7 @@ static u64 zswap_current_read(struct cgroup_subsys_state *css,
 	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
 
 	mem_cgroup_flush_stats(memcg);
-	return memcg_page_state(memcg, MEMCG_ZSWAP_B);
+	return memcg_page_state(memcg, NR_ZSWAP_B);
 }
 
 static int zswap_max_show(struct seq_file *m, void *v)
diff --git a/mm/vmstat.c b/mm/vmstat.c
index 86b14b0f77b5..389ff986ceac 100644
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
index 24665d7cd4a9..ab085961b0e2 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -216,8 +216,8 @@ struct zs_pool {
 	struct work_struct free_work;
 #endif
 	bool memcg_aware;
-	enum memcg_stat_item compressed_stat;
-	enum memcg_stat_item uncompressed_stat;
+	enum node_stat_item compressed_stat;
+	enum node_stat_item uncompressed_stat;
 	/* protect zspage migration/compaction */
 	rwlock_t lock;
 	atomic_t compaction_in_progress;
@@ -823,6 +823,9 @@ static void __free_zspage(struct zs_pool *pool, struct size_class *class,
 		reset_zpdesc(zpdesc);
 		zpdesc_unlock(zpdesc);
 		zpdesc_dec_zone_page_state(zpdesc);
+		if (pool->memcg_aware)
+			dec_node_page_state(zpdesc_page(zpdesc),
+					    pool->compressed_stat);
 		zpdesc_put(zpdesc);
 		zpdesc = next;
 	} while (zpdesc != NULL);
@@ -974,6 +977,9 @@ static struct zspage *alloc_zspage(struct zs_pool *pool,
 		__zpdesc_set_zsmalloc(zpdesc);
 
 		zpdesc_inc_zone_page_state(zpdesc);
+		if (pool->memcg_aware)
+			inc_node_page_state(zpdesc_page(zpdesc),
+					    pool->compressed_stat);
 		zpdescs[i] = zpdesc;
 	}
 
@@ -985,6 +991,9 @@ static struct zspage *alloc_zspage(struct zs_pool *pool,
 err:
 	while (--i >= 0) {
 		zpdesc_dec_zone_page_state(zpdescs[i]);
+		if (pool->memcg_aware)
+			dec_node_page_state(zpdesc_page(zpdescs[i]),
+					    pool->compressed_stat);
 		free_zpdesc(zpdescs[i]);
 	}
 	if (pool->memcg_aware)
@@ -1029,10 +1038,48 @@ static bool zspage_empty(struct zspage *zspage)
 }
 
 #ifdef CONFIG_MEMCG
-static void zs_charge_objcg(struct zs_pool *pool, struct obj_cgroup *objcg,
-			    int size)
+static void __zs_mod_memcg_lruvec(struct zs_pool *pool, struct zpdesc *zpdesc,
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
+	mod_memcg_lruvec_state(lruvec, pool->compressed_stat,
+			       sign * compressed_size);
+	mod_memcg_lruvec_state(lruvec, pool->uncompressed_stat,
+			       sign * original_size);
+
+	if (nid != next_nid) {
+		lruvec = mem_cgroup_lruvec(memcg, NODE_DATA(next_nid));
+		mod_memcg_lruvec_state(lruvec, pool->compressed_stat,
+				       sign * (size - compressed_size));
+		mod_memcg_lruvec_state(lruvec, pool->uncompressed_stat,
+				       sign * (PAGE_SIZE - original_size));
+	}
+	rcu_read_unlock();
+}
+
+static void zs_charge_objcg(struct zs_pool *pool, struct zpdesc *zpdesc,
+			    struct obj_cgroup *objcg, int size,
+			    unsigned long offset)
+{
 
 	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
 		return;
@@ -1044,18 +1091,19 @@ static void zs_charge_objcg(struct zs_pool *pool, struct obj_cgroup *objcg,
 	if (obj_cgroup_charge(objcg, GFP_KERNEL, size))
 		VM_WARN_ON_ONCE(1);
 
-	rcu_read_lock();
-	memcg = obj_cgroup_memcg(objcg);
-	mod_memcg_state(memcg, pool->compressed_stat, size);
-	mod_memcg_state(memcg, pool->uncompressed_stat, PAGE_SIZE);
-	rcu_read_unlock();
+	__zs_mod_memcg_lruvec(pool, zpdesc, objcg, size, 1, offset);
+
+	/*
+	 * Node-level vmstats are charged in PAGE_SIZE units. As a best-effort,
+	 * always charge the uncompressed stats to the first zpdesc.
+	 */
+	inc_node_page_state(zpdesc_page(zpdesc), pool->uncompressed_stat);
 }
 
-static void zs_uncharge_objcg(struct zs_pool *pool, struct obj_cgroup *objcg,
-			      int size)
+static void zs_uncharge_objcg(struct zs_pool *pool, struct zpdesc *zpdesc,
+			      struct obj_cgroup *objcg, int size,
+			      unsigned long offset)
 {
-	struct mem_cgroup *memcg;
-
 	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
 		return;
 
@@ -1063,20 +1111,24 @@ static void zs_uncharge_objcg(struct zs_pool *pool, struct obj_cgroup *objcg,
 
 	obj_cgroup_uncharge(objcg, size);
 
-	rcu_read_lock();
-	memcg = obj_cgroup_memcg(objcg);
-	mod_memcg_state(memcg, pool->compressed_stat, -size);
-	mod_memcg_state(memcg, pool->uncompressed_stat, -(int)PAGE_SIZE);
-	rcu_read_unlock();
+	__zs_mod_memcg_lruvec(pool, zpdesc, objcg, size, -1, offset);
+
+	/*
+	 * Node-level vmstats are charged in PAGE_SIZE units. As a best-effort,
+	 * always uncharged the uncompressed stats from the first zpdesc.
+	 */
+	dec_node_page_state(zpdesc_page(zpdesc), pool->uncompressed_stat);
 }
 #else
-static void zs_charge_objcg(struct zs_pool *pool, struct obj_cgroup *objcg,
-			    int size)
+static void zs_charge_objcg(struct zs_pool *pool, struct zpdesc *zpdesc,
+			    struct obj_cgroup *objcg, int size,
+			    unsigned long offset)
 {
 }
 
-static void zs_uncharge_objcg(struct zs_pool *pool, struct obj_cgroup *objcg,
-			      int size)
+static void zs_uncharge_objcg(struct zs_pool *pool, struct zpdesc *zpdesc,
+			      struct obj_cgroup *objcg, int size,
+			      unsigned long offset)
 {
 }
 #endif
@@ -1298,7 +1350,7 @@ void zs_obj_write(struct zs_pool *pool, unsigned long handle,
 		WARN_ON_ONCE(!pool->memcg_aware);
 		zspage->objcgs[obj_idx] = objcg;
 		obj_cgroup_get(objcg);
-		zs_charge_objcg(pool, objcg, class->size);
+		zs_charge_objcg(pool, zpdesc, objcg, class->size, off);
 	}
 
 	if (!ZsHugePage(zspage))
@@ -1477,7 +1529,7 @@ static void obj_free(int class_size, unsigned long obj)
 	if (pool->memcg_aware && zspage->objcgs[f_objidx]) {
 		struct obj_cgroup *objcg = zspage->objcgs[f_objidx];
 
-		zs_uncharge_objcg(pool, objcg, class_size);
+		zs_uncharge_objcg(pool, f_zpdesc, objcg, class_size, f_offset);
 		obj_cgroup_put(objcg);
 		zspage->objcgs[f_objidx] = NULL;
 	}
@@ -2191,8 +2243,8 @@ static int calculate_zspage_chain_size(int class_size)
  * otherwise NULL.
  */
 struct zs_pool *zs_create_pool(const char *name, bool memcg_aware,
-			       enum memcg_stat_item compressed_stat,
-			       enum memcg_stat_item uncompressed_stat)
+			       enum node_stat_item compressed_stat,
+			       enum node_stat_item uncompressed_stat)
 {
 	int i;
 	struct zs_pool *pool;
diff --git a/mm/zswap.c b/mm/zswap.c
index d81e2db4490b..2e9352b46693 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -256,8 +256,7 @@ static struct zswap_pool *zswap_pool_create(char *compressor)
 
 	/* unique name for each pool specifically required by zsmalloc */
 	snprintf(name, 38, "zswap%x", atomic_inc_return(&zswap_pools_count));
-	pool->zs_pool = zs_create_pool(name, true, MEMCG_ZSWAP_B,
-				       MEMCG_ZSWAPPED_B);
+	pool->zs_pool = zs_create_pool(name, true, NR_ZSWAP_B, NR_ZSWAPPED_B);
 	if (!pool->zs_pool)
 		goto error;
 
@@ -1214,9 +1213,9 @@ static unsigned long zswap_shrinker_count(struct shrinker *shrinker,
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
2.52.0


