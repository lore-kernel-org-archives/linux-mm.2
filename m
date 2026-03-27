Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 850D210F2865
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 19:19:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B30026B008C; Fri, 27 Mar 2026 15:19:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE0F16B0095; Fri, 27 Mar 2026 15:19:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9CF6F6B0096; Fri, 27 Mar 2026 15:19:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 877C66B008C
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 15:19:40 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 227128DECA
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 19:19:40 +0000 (UTC)
X-FDA: 84592807320.29.AC07666
Received: from mail-oi1-f172.google.com (mail-oi1-f172.google.com [209.85.167.172])
	by imf30.hostedemail.com (Postfix) with ESMTP id 595FD80005
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 19:19:38 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ir41fQmQ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.167.172 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774639178; a=rsa-sha256;
	cv=none;
	b=yvScelMwZQ5gQHcTzKXVii8sTFdObMFmuvsQlWXpcwcmalVGtDD1VGiDS1wx3hTy+IOpDZ
	20Sqoa4S7GC7nTvOKLxVCbr8r1PKHKkmNf73MOHDzb7oo8hkolEH8bCO2cri1iqrASxFUI
	eWCwJRrSik2Q19ueqwAM2Ozr+nFziYs=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ir41fQmQ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.167.172 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774639178;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=g36eDtHxaYoJojvs9L9tY/Cu0/ANeoyQ3rXoQcxOHvE=;
	b=gkBTl3ReAgLk07g82Yjyi6G0rxtbK4vdKSFrFrUYYh5QhNOIvQc4IWa0OaXTDT8+UC16m4
	fY5lzYCpG2BjlhjgAyIKjxusT3RkhPZLKPubaesSlcqHCw+bbhtdLA6SUNSXacXD03Nunh
	H1l//OoqyX3Ytv6xMHueV33yLpn4au8=
Received: by mail-oi1-f172.google.com with SMTP id 5614622812f47-467161c4a1cso859181b6e.3
        for <linux-mm@kvack.org>; Fri, 27 Mar 2026 12:19:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774639177; x=1775243977; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=g36eDtHxaYoJojvs9L9tY/Cu0/ANeoyQ3rXoQcxOHvE=;
        b=ir41fQmQuIa0ceWqros/IJy/XOh0RCc4GyUwRpVzsrOo2SR7CAhkLIhiJ6rMzsPYnn
         +kMbpr+HftoYrTvuQF5ros9rl+qLwKKmIY9fAEhPtcM9goFKbcqZenFoQcntVw/Z6Cih
         6HVdgQ8sXFPCDN6oR6L2ExzXuOjEpDvL94Q4gTETz0gjZLjohOsZEmoZzkpm+pAjdKMR
         97bJpFrJTNxhnaTilA+KY3JoacGV8kA2+hHqqygvWnOSCHvRuAj9no8BZ+OKoIjQcmTh
         GULE8YkaAMtBK4If5c2If3YxmAmrAJNjyNEjAgg2W5iPqxyEbCsA/SeEJ6/n8Eg2GtbM
         AW5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774639177; x=1775243977;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g36eDtHxaYoJojvs9L9tY/Cu0/ANeoyQ3rXoQcxOHvE=;
        b=Fe9zw8DJKVG07qSDQ5n8tNogOc5ZRNVrgQf/iuxBy+BeRdYffhZmH6hM+r30T0N5Kt
         2nZ2dKNrwCD/uIOAhxxsS7XR7XzZWjX5zTVs9VXdznIm48JJmqNVYnrMjSZKykDILh40
         tjMJvwVWI7+Dj08sehn4SFJKAM4NLrxtA4eeJResynMBqNyvqc99kecEZZ+TTaUc/Smy
         oNnFghZ5a+t7U4lu8gBT2EX7OK6lIsiJiuHO2RTc0QEWXycmTsAUmjE2JJxfbB+aWFAN
         vh3o1m/d+K1uwe5lkaZaOyTVGGs7d+K4LVqrrZdKQaNW3Znv0B1RI7yqpUOnk9afHrK8
         2OTA==
X-Forwarded-Encrypted: i=1; AJvYcCU2+sYsqPm3n+2OZkgTQL+qAqkmX7xY9GJVoCLHFOO5IRHjYA66g+MQ3rjUqTnWTxarXHq2diB0+A==@kvack.org
X-Gm-Message-State: AOJu0Yy/KjUz547LhjlhFZiCfQE5tRj1UyQzXaCH94kC+XczTnfnyLn5
	9NL+aL+bS5bjz4Ift8y/nwsMkdjm6NLDwv8DMwXpyODKBlbBqyMuCW24
X-Gm-Gg: ATEYQzyw9nwiEenl7dRFZBZax9rN2Ie09aJ41QE2OZQnWeI2/ANfys++T6BXiZELw6y
	Xd8VzchlLky0Ui4luHZxEL3bO1cAmNN0hniJQKlwQ1AaCEmb6zT7E6rrG04U6nf8CPVMuUnR0pK
	mp4xuG1Lz+BoHFHBdNU/7g+A6QVakgVnGC3nmCH2KjaVvXmWUuCKXHgy96Sa46dqpZpi3A8TVf+
	6yIuahSZfauahBo5001EjQzESNAPQqM1omSoI6rxJxSBSZPKxXT9yNx9WCDhRZmvIzJXDK+R6D+
	JufD7gXYkOIumhMVNUW5Hk/kDjTncf/mtUoy5AUAwDZe0I595TUTsKybN6DVx7xZ2Q8PgEyG2qH
	ZGYfE83rmPFESG4Tdi8Ts3COO9rEhwhcfzm5OWGP71TEtYKvaRyRkP04Zf2O0WX+Y5qsug9mTxG
	svzauHuq2Ljt+bCceb4Q==
X-Received: by 2002:a05:6808:894c:b0:467:2be4:9e39 with SMTP id 5614622812f47-46a8a5a37a8mr1494347b6e.39.1774639177209;
        Fri, 27 Mar 2026 12:19:37 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-41d04cf9ceesm138877fac.15.2026.03.27.12.19.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Mar 2026 12:19:36 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH] mm/percpu, memcontrol: Per-memcg-lruvec percpu accounting
Date: Fri, 27 Mar 2026 12:19:35 -0700
Message-ID: <20260327191936.1980054-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.52.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: nyfffbrfgrym5c6p7s1rzfstyf5e4kue
X-Rspamd-Queue-Id: 595FD80005
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774639178-735698
X-HE-Meta: U2FsdGVkX19De8vYIH01jqMFmZi8Ec4vPvnOSu5Xi86CA2MBUSmf1aFU8ERdmwUjzCbl+j/hKzBZ03msmka9CVCEze0frBJgMfw55ayp03sSUp/07XuUcIOqSttnN61dgauONa1I2dwz94YRg7LJeL5uBfuMi5U4/WIiXddR+/B+EQNDtsFzgX0Wbkht20QyKDImICkNhfbOU51gPXZH38n03RWNowXOVNfglyPedDCjKP4tJneJxkhKHzJbDTomGPxKzjg5or8PPk7f4aoVSTQ80df+fSE5pijZqg0ic4PwMM/aDEURuGItXM92U/UOxZP8zHCpDbODl8bka++bCGGaRwoDmFMA5V8bkAPrqByaXQXFAZGFHDr6zK0Et+0I+V4wPzVIXzCX8s9Yyg+sM3v0P2wTlHQcu90bkHlpdZgjHzwHEYSR6HPggKta9mEMG4+JlXFwf8EWfDYKTAwE0e3nNW6XXJyd8UlUu5v70YJcu+uJhPNMPhxlIuc79+RIkfoUxVpxbvRyfduc9Wi1ZH0H291z3hqqzX6E0dLyx10bkU5lJ3TFgskAUVPkBWKrZm9609+woMn0JAXeJqqtG8++dpyF9IFA78+WbLz0OBuBH/V4V5GmQoducL5DzFo66wiZfhHLgJHKxfGacUNqu6S6qS4S2DNgHwC7EzAEDXhkDp8iFF3EKn9L7s5x4ZLI3CgaoTOcGRLDOESo6/X/VmzVrdn643MWkkI6C523/A/g/dLH1qepDCD+eX5k/La0HHDkSzEIxBuVP8g93zA/JcQ0CnL1VewkbR/X5WpKAOLsOoi52+0p49jX2KRsJdryso/sUXebLCiQToQ0H6YDjzADkN3BZySkpW8DC7DVf/caYpb83GoT9jPDWbhX7GNksbluT97zc28/obX3PlO9ofVBpEp1wipdY7W9CuXc0DhGdPqWPKPpFmJs88BcPvROqWp61wGlCX3I9Bbls7s
 zt2sMV6d
 Bxhcivb3glFy7UNCVKt9/E7Np+JqUBwcz0Ta5CA/vo70SYXDa4m6qSbIR0LV6zfB2Yehd/mbf3iEOXEWoDq1UBjQ5m9Xb7kqn1zk+eSAinjpM3SpnfzgS1y+FTlpbT3xIAA3UxPfJ6r+DniJaddbeOAjx44wms8VlYzGAH8W+L+TNbGWkIWyXIFL5t5F2JKj3fQ4w5gkwk9lbRAM1GY3RKN4jRUJEO0oW9I/rxaHDPhKZT8YWs4vCk+Nn9M6H+2yUhXPyYPRWua7yNhN/kSwU1GOUC5OXJnQaXTMKP0PDyGwL6+JjiJXT+c2fhZB63xUJLE8TdUYBmpsz7p7zmFkohu7VtvLb4sB2LUskhXbF8gz5jxe0Y2xMGMYns52L+KRX18/EX+2KHvs07GBZdJP+jLZc8bMqUe3IU3hQQXhH2A3RixO3PE+YNvLwRD1o1HaFDKWyqN9PT8hTAXocnLP5G2Q7JdmDUQS7osPg7MnKdX41gyyioqChQlqGjA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Convert MEMCG_PERCPU_B from a memcg_stat_item to a memcg_node_stat_item
to give visibility into per-node breakdowns for percpu allocations and
turn it into NR_PERCPU_B.

Because percpu memory is accounted at a sub-PAGE_SIZE level, we must
account node level statistics (accounted in PAGE_SIZE units) and
memcg-lruvec statistics separately. Account node statistics when the pcpu
pages are allocated, and account memcg-lruvec statistics when pcpu
objects are handed out.

To do account these separately, expose mod_memcg_lruvec_state to be
used outside of memcontrol.

One functional change is that we do not account the 8 byte objcg
pointer per-memcg-lruvec. Since the objcg membership is tracked
per-memcg and not percpu, there is no appropriate lruvec to charge this
memory to (see pcpu_obj_full_size). Instead of adding additional
mechanisms to detect which lruvec the 8 byte pointer belongs to, let's
just simplify and account the pcpu objects' size.

Limit-checking is still done with the additional 8 bytes.

Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 include/linux/memcontrol.h |  4 +++-
 include/linux/mmzone.h     |  4 +++-
 mm/memcontrol.c            | 12 ++++++------
 mm/percpu-vm.c             | 14 ++++++++++++--
 mm/percpu.c                | 24 ++++++++++++++++++++----
 mm/vmstat.c                |  1 +
 6 files changed, 45 insertions(+), 14 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 086158969529..96dae769c60d 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -34,7 +34,6 @@ struct kmem_cache;
 enum memcg_stat_item {
 	MEMCG_SWAP = NR_VM_NODE_STAT_ITEMS,
 	MEMCG_SOCK,
-	MEMCG_PERCPU_B,
 	MEMCG_KMEM,
 	MEMCG_ZSWAP_B,
 	MEMCG_ZSWAPPED,
@@ -909,6 +908,9 @@ struct mem_cgroup *mem_cgroup_get_oom_group(struct task_struct *victim,
 					    struct mem_cgroup *oom_domain);
 void mem_cgroup_print_oom_group(struct mem_cgroup *memcg);
 
+void mod_memcg_lruvec_state(struct lruvec *lruvec, enum node_stat_item idx,
+			    int val);
+
 /* idx can be of type enum memcg_stat_item or node_stat_item */
 void mod_memcg_state(struct mem_cgroup *memcg,
 		     enum memcg_stat_item idx, int val);
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 7bd0134c241c..e38d8fe8552b 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -328,6 +328,7 @@ enum node_stat_item {
 #endif
 	NR_BALLOON_PAGES,
 	NR_KERNEL_FILE_PAGES,
+	NR_PERCPU_B,
 	NR_VM_NODE_STAT_ITEMS
 };
 
@@ -365,7 +366,8 @@ static __always_inline bool vmstat_item_in_bytes(int idx)
 	 * byte-precise.
 	 */
 	return (idx == NR_SLAB_RECLAIMABLE_B ||
-		idx == NR_SLAB_UNRECLAIMABLE_B);
+		idx == NR_SLAB_UNRECLAIMABLE_B ||
+		idx == NR_PERCPU_B);
 }
 
 /*
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index a47fb68dd65f..b320b6a42696 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -377,6 +377,7 @@ static const unsigned int memcg_node_stat_items[] = {
 	NR_UNEVICTABLE,
 	NR_SLAB_RECLAIMABLE_B,
 	NR_SLAB_UNRECLAIMABLE_B,
+	NR_PERCPU_B,
 	WORKINGSET_REFAULT_ANON,
 	WORKINGSET_REFAULT_FILE,
 	WORKINGSET_ACTIVATE_ANON,
@@ -428,7 +429,6 @@ static const unsigned int memcg_node_stat_items[] = {
 static const unsigned int memcg_stat_items[] = {
 	MEMCG_SWAP,
 	MEMCG_SOCK,
-	MEMCG_PERCPU_B,
 	MEMCG_KMEM,
 	MEMCG_ZSWAP_B,
 	MEMCG_ZSWAPPED,
@@ -920,9 +920,8 @@ static void __mod_memcg_lruvec_state(struct mem_cgroup_per_node *pn,
 	put_cpu();
 }
 
-static void mod_memcg_lruvec_state(struct lruvec *lruvec,
-				     enum node_stat_item idx,
-				     int val)
+void mod_memcg_lruvec_state(struct lruvec *lruvec, enum node_stat_item idx,
+			    int val)
 {
 	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
 	struct mem_cgroup_per_node *pn;
@@ -936,6 +935,7 @@ static void mod_memcg_lruvec_state(struct lruvec *lruvec,
 
 	get_non_dying_memcg_end();
 }
+EXPORT_SYMBOL(mod_memcg_lruvec_state);
 
 /**
  * mod_lruvec_state - update lruvec memory statistics
@@ -1535,7 +1535,7 @@ static const struct memory_stat memory_stats[] = {
 	{ "kernel_stack",		NR_KERNEL_STACK_KB		},
 	{ "pagetables",			NR_PAGETABLE			},
 	{ "sec_pagetables",		NR_SECONDARY_PAGETABLE		},
-	{ "percpu",			MEMCG_PERCPU_B			},
+	{ "percpu",			NR_PERCPU_B			},
 	{ "sock",			MEMCG_SOCK			},
 	{ "vmalloc",			NR_VMALLOC			},
 	{ "shmem",			NR_SHMEM			},
@@ -1597,7 +1597,7 @@ static const struct memory_stat memory_stats[] = {
 static int memcg_page_state_unit(int item)
 {
 	switch (item) {
-	case MEMCG_PERCPU_B:
+	case NR_PERCPU_B:
 	case MEMCG_ZSWAP_B:
 	case NR_SLAB_RECLAIMABLE_B:
 	case NR_SLAB_UNRECLAIMABLE_B:
diff --git a/mm/percpu-vm.c b/mm/percpu-vm.c
index 4f5937090590..e36b639f521d 100644
--- a/mm/percpu-vm.c
+++ b/mm/percpu-vm.c
@@ -55,7 +55,8 @@ static void pcpu_free_pages(struct pcpu_chunk *chunk,
 			    struct page **pages, int page_start, int page_end)
 {
 	unsigned int cpu;
-	int i;
+	int nr_pages = page_end - page_start;
+	int i, nid;
 
 	for_each_possible_cpu(cpu) {
 		for (i = page_start; i < page_end; i++) {
@@ -65,6 +66,10 @@ static void pcpu_free_pages(struct pcpu_chunk *chunk,
 				__free_page(page);
 		}
 	}
+
+	for_each_node(nid)
+		mod_node_page_state(NODE_DATA(nid), NR_PERCPU_B,
+				-1L * nr_pages * nr_cpus_node(nid) * PAGE_SIZE);
 }
 
 /**
@@ -84,7 +89,8 @@ static int pcpu_alloc_pages(struct pcpu_chunk *chunk,
 			    gfp_t gfp)
 {
 	unsigned int cpu, tcpu;
-	int i;
+	int nr_pages = page_end - page_start;
+	int i, nid;
 
 	gfp |= __GFP_HIGHMEM;
 
@@ -97,6 +103,10 @@ static int pcpu_alloc_pages(struct pcpu_chunk *chunk,
 				goto err;
 		}
 	}
+
+	for_each_node(nid)
+		mod_node_page_state(NODE_DATA(nid), NR_PERCPU_B,
+				    nr_pages * nr_cpus_node(nid) * PAGE_SIZE);
 	return 0;
 
 err:
diff --git a/mm/percpu.c b/mm/percpu.c
index b0676b8054ed..4ad3b9739eb9 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -1632,6 +1632,24 @@ static bool pcpu_memcg_pre_alloc_hook(size_t size, gfp_t gfp,
 	return true;
 }
 
+static void pcpu_mod_memcg_lruvec(struct obj_cgroup *objcg, int charge)
+{
+	struct mem_cgroup *memcg;
+	int nid;
+
+	memcg = obj_cgroup_memcg(objcg);
+	for_each_node(nid) {
+		struct lruvec *lruvec;
+		unsigned int nr_cpus = nr_cpus_node(nid);
+
+		if (!nr_cpus)
+			continue;
+
+		lruvec = mem_cgroup_lruvec(memcg, NODE_DATA(nid));
+		mod_memcg_lruvec_state(lruvec, NR_PERCPU_B, nr_cpus * charge);
+	}
+}
+
 static void pcpu_memcg_post_alloc_hook(struct obj_cgroup *objcg,
 				       struct pcpu_chunk *chunk, int off,
 				       size_t size)
@@ -1644,8 +1662,7 @@ static void pcpu_memcg_post_alloc_hook(struct obj_cgroup *objcg,
 		chunk->obj_exts[off >> PCPU_MIN_ALLOC_SHIFT].cgroup = objcg;
 
 		rcu_read_lock();
-		mod_memcg_state(obj_cgroup_memcg(objcg), MEMCG_PERCPU_B,
-				pcpu_obj_full_size(size));
+		pcpu_mod_memcg_lruvec(objcg, size);
 		rcu_read_unlock();
 	} else {
 		obj_cgroup_uncharge(objcg, pcpu_obj_full_size(size));
@@ -1667,8 +1684,7 @@ static void pcpu_memcg_free_hook(struct pcpu_chunk *chunk, int off, size_t size)
 	obj_cgroup_uncharge(objcg, pcpu_obj_full_size(size));
 
 	rcu_read_lock();
-	mod_memcg_state(obj_cgroup_memcg(objcg), MEMCG_PERCPU_B,
-			-pcpu_obj_full_size(size));
+	pcpu_mod_memcg_lruvec(objcg, -size);
 	rcu_read_unlock();
 
 	obj_cgroup_put(objcg);
diff --git a/mm/vmstat.c b/mm/vmstat.c
index b33097ab9bc8..d73c3355be71 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -1296,6 +1296,7 @@ const char * const vmstat_text[] = {
 #endif
 	[I(NR_BALLOON_PAGES)]			= "nr_balloon_pages",
 	[I(NR_KERNEL_FILE_PAGES)]		= "nr_kernel_file_pages",
+	[I(NR_PERCPU_B)]			= "nr_percpu",
 #undef I
 
 	/* system-wide enum vm_stat_item counters */
-- 
2.52.0


