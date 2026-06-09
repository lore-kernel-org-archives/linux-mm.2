Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E31D2CD8C9D
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 00:29:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D4716B0088; Mon,  8 Jun 2026 20:29:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6AD276B008A; Mon,  8 Jun 2026 20:29:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59A5D6B008C; Mon,  8 Jun 2026 20:29:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4AC196B0088
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 20:29:28 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 032B48D7A7
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 00:29:27 +0000 (UTC)
X-FDA: 84858490416.17.6D47CE2
Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	by imf23.hostedemail.com (Postfix) with ESMTP id 4217E140004
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 00:29:26 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Z9u86Thi;
	spf=pass (imf23.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.176 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780964966;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=6OuP5xJRvipAvyXVi1m7B0jtySHplOxvFb6PPG4kpb8=;
	b=oH30YJtud+leEWsBHPelN39LNGPnBMj1/wTI+LEEwSy+YIfo2cL1ANFN76QwuVqEAcZD0t
	xytFLk7wyNDDht0IJD+f7kLC5DyrJOSWTUdL4XiOv2CIfFc1CJzmtfHSttg/ek4CfjsLty
	uQXt2MRZleoexPXLb06bqlt0Djg3w5M=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Z9u86Thi;
	spf=pass (imf23.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.176 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780964966;
	b=fB10O1/O34E6ndcE2iBcNDbd/a4alz26eNW5OZ8lb8TTrnSf8cWahVzK4tu7Nmx3AbNmVm
	HdZgfbhlGzZczKjRwNjBXW/49TlIP9fSHa8AMelFyG2WX1qHeXKnwKOIGDlRgcmkGej8Bc
	0xmud+Npk1nPBVNItV3lcclRN1HRAOY=
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-9157d3f2098so596966785a.3
        for <linux-mm@kvack.org>; Mon, 08 Jun 2026 17:29:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1780964965; x=1781569765; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=6OuP5xJRvipAvyXVi1m7B0jtySHplOxvFb6PPG4kpb8=;
        b=Z9u86ThiSDJXOlTfZoOj9m3XjQnqLbx9b8XeNTJhMVF0ZiVo/D9pptHoAUNOUMF1A+
         A5q1aoc3JBMyIdjtJf6ifz+C1FQNpNrlJ+Q32DU/hFqJkVwGVAeyDinrAUL7+kEHqu9g
         07xEwUz7VI2RZ4j6VC+Q6/V0SVbBh0m9HgfVbzTxS4wlankW/YLEWhKCbqtfrYxj/QVu
         LTnd7ozw5+rpzx5Ky4TobBuEWdpmLCftcbTsBOYvdTyNyw/d9RD7ryTr+kB4p5wbZYPq
         WboOqKShqfZ+0ltdDbmvG0NyEwYSyQ3V741oG5zdrDjkfk5EL/bqj/eFO4NRfFrMS0Ub
         3G/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780964965; x=1781569765;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6OuP5xJRvipAvyXVi1m7B0jtySHplOxvFb6PPG4kpb8=;
        b=JuLBMqnk7nGxLARmwqohRntLn409jrqYUGKRay9q2HkJ3HQ0KnxzCnq11WoNAeX617
         4hlNylzD+eajvDZ5uAd0PCfuXtfZrwYYw9TWbNkQlRA/Qvhvxm307be8NIDKzTwzxvG0
         1Rhfkh99DV0bs69aqLJfSPCjS6Jm9Ll663b11jtVmkpJZXi0jQAsn5f9/st8J/PlZjCL
         hnVAJ20Py4ugJMmv2GDNZNiUy3k1z4pSqLrScAIT3Qrqil/EGbkpOggSpBBUEgMK4hyg
         XKOh5DJDs6rasyVSuI05puXE9UWx6HDFr99p7zvjcyZ5dV+25hyIS0wEF+Hys+m/j0fy
         2FeQ==
X-Gm-Message-State: AOJu0YzROL3nLLaHx3KL/U20gtUMjvLu5PMTTfO2P86BArBERVcvMsVG
	wgdOcf1VL/F2OmN15bawuz6DSJ9SjNAaBBompa438S6i2taoGXmXHNFQwC6V/9Q8WW5Pt+oM0zf
	0Bk8x
X-Gm-Gg: Acq92OEzpF3yRF+CmjjXHv+Bzr42Ui9S01+zof8JDe2Y8NaQNKiXCoBTIVO/yYnPbX6
	kU8u4IdEwnjDovQlat2r8D7z+q5P5ZrkY3mQamjhjZqqiz2IsRd5MHBx8u3u8A2IyqOx4FcnSRe
	sed6CHtTjLwz3k/1WhaRiaGhc20Se2A0azs8NqzvGK7K4z2Tn4vqHZTu+oDQCCSamiDk9JtGRJA
	AWAM5dnW83A9VCjQ8lsz8UINaNKXSGyx0pbDuyb+MLeeQvkD9x7bfyxfUsC8zxHTOKrPOrIeE88
	j5Bm1t+V65xfRf85B6b1GcnnJB0iEeVVprZ5Nn0I1tzWNMuechYnjujDamzIdKNUB5aKKulUDWE
	eqyoWxQuYxZkdrqUoM16T/3jMncJpaLhLzUd/iCu1DQ1Sd/fyjZfhMVNP3ZnrL7pYMKjfM7vzeK
	VKsVCBX3cua0SUbypkeLCIsBrqV0fTA8h0QFdBr8aEeLzZ/s0Vs1HVz398i+yX2Ad41V6vCMdcM
	hzPxNCI3Pu/PHCGR5gIhRU=
X-Received: by 2002:a05:620a:270d:b0:8cd:9033:1724 with SMTP id af79cd13be357-915a9c29334mr2833428885a.9.1780964965287;
        Mon, 08 Jun 2026 17:29:25 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9158a3d7280sm1909268085a.41.2026.06.08.17.29.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2026 17:29:24 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	kernel-team@meta.com,
	longman@redhat.com,
	chenridong@huaweicloud.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	rientjes@google.com,
	chrisl@kernel.org,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	baoquan.he@linux.dev,
	youngjun.park@lge.com,
	tj@kernel.org,
	hannes@cmpxchg.org,
	mkoutny@suse.com,
	jackmanb@google.com,
	ziy@nvidia.com
Subject: [PATCH] mm: constify oom_control, scan_control, and alloc_context nodemask
Date: Mon,  8 Jun 2026 20:29:19 -0400
Message-ID: <20260609002919.3967782-1-gourry@gourry.net>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 4217E140004
X-Stat-Signature: zzrsjo41c7xwkkpyrcsgbkipqq6kg1kn
X-Rspam-User: 
X-HE-Tag: 1780964966-477124
X-HE-Meta: U2FsdGVkX1/s5lU764EhfFvGt6aKsO94yFwbc+rPc8PgWQoibf5JK0UlKj8ti0cW6OuStrXkhoE5moS3Ec5adKT2G8jNEomx4Yzxi91RQH4AYDkFblxcxljEAtRAdNI07VA9Zp6pYCxog3zUSZc3vHIGTtJUYTVwniywc7N9rWRH6DKpE5N9/BixaPEo+4f8eO3WtLc8fhYVH6BznsSUVaMdcOVq46Bro6qYupfIGx7MYkheQQ2KF/I4yXMVapGHcq8EAvLHdj6YzCoaqITN8p+e9fH75A3V13HiMHZ7M4fD2aFp9HQPugqladTtuKukmsKSiIZYDBxIfh2jwwr1NZ6nxUoNExblwOLyAsxLQGLf1WcvMEqo2bOgts2CXf30lmN1cYw7NmivrJxibiVUICGlnaprjLAQeO7FAdksaqydkFvUHVY7qPl93GsKoj8yIjN8hZL2Mf79mDqorzNVFEJBPHvlXf1WbNxdFl7zKjItoKafoUXacpKHup3OIAkfM3mC50gnv5QatYJh8Qi5uDH+3GE2mT11kc5rPqgthBjZ8MXmLksEF7mnHi0Gub8a1iNXXrBV9hmMs38jh8BlFH68S3iG5Hp7+YQbV1BIeHqsinn/KX3Rg5cTcPN7XYHi4N1BJ3gsyS7cC0fGaYuWfKqUC674HeX7I1uLAyLk6K0OKNzfda5dVp8ZQwBMByui8ReAh5LxNBdtwJ3NTHb23FrGtarfR0nT4paO3uBfNc+qkEC7lFXn1j8nBJciN61t1bJbFreumzX5rlRjZPk/RKYgBtzwOeSdH8kRrQ84JI4WhELsE5DOeG030Ipqu058mlxUd75OzahV87w+yNct5MRgBesm+8DU887QzeQCni9WnwsM8oQ89f43+grpdEP0CRxXVl/OECkyymUBPoH1KUdhXqbOyl1gWLfgimrDE7DvQiWUNt8ma+ZgoKq5RNhStQDkILrv/vMSjMl1ImZ
 gXEQSTGR
 JvPAUIPzVJKjesdGhLEFxlCksT4XjoNKsPuYkR5ly/2jXcBjXNhO21Ye77yyFjDYpzVUeGCdFm4gU3NfAUD0OpYYWroAPO71pyfy5ZAdTKFoi8MeG3JkCA/7v3bwnmUmHbZC7xo9WOYm+eaMOc4lcwaPVKJULou9AQYvkoPjt/PhSAEzU+LcbU7xqvEN7iI0GQOwd7vCkpNusHRz+v4GFVbRmebR03xndDzlNTGFnxUrUQ2Ik3uvSBtvWGRK+XcMxO9Ch3L6hPmxmealAWHe15FF8+ytRBdiBVgcI8lYStL+IaH3d1F7kdTYJFEgqTSi1kcOdOxvXGifbILnKmor/TAckYvhz50vhNzld/8is3qcSlpEGFnJHOx5LLDcihn7fNAa3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The nodemasks in these structures may come from a variety of sources,
including tasks and cpusets - and should never be modified by any code
when being passed around inside another context.

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 include/linux/cpuset.h | 4 ++--
 include/linux/mm.h     | 4 ++--
 include/linux/mmzone.h | 6 +++---
 include/linux/oom.h    | 2 +-
 include/linux/swap.h   | 2 +-
 kernel/cgroup/cpuset.c | 2 +-
 mm/internal.h          | 2 +-
 mm/mmzone.c            | 5 +++--
 mm/page_alloc.c        | 6 +++---
 mm/show_mem.c          | 9 ++++++---
 mm/vmscan.c            | 6 +++---
 11 files changed, 26 insertions(+), 22 deletions(-)

diff --git a/include/linux/cpuset.h b/include/linux/cpuset.h
index 65d76a38974b..a80d38e752d2 100644
--- a/include/linux/cpuset.h
+++ b/include/linux/cpuset.h
@@ -83,7 +83,7 @@ extern bool cpuset_cpus_allowed_fallback(struct task_struct *p);
 extern nodemask_t cpuset_mems_allowed(struct task_struct *p);
 #define cpuset_current_mems_allowed (current->mems_allowed)
 void cpuset_init_current_mems_allowed(void);
-int cpuset_nodemask_valid_mems_allowed(nodemask_t *nodemask);
+int cpuset_nodemask_valid_mems_allowed(const nodemask_t *nodemask);
 
 extern bool cpuset_current_node_allowed(int node, gfp_t gfp_mask);
 
@@ -224,7 +224,7 @@ static inline nodemask_t cpuset_mems_allowed(struct task_struct *p)
 #define cpuset_current_mems_allowed (node_states[N_MEMORY])
 static inline void cpuset_init_current_mems_allowed(void) {}
 
-static inline int cpuset_nodemask_valid_mems_allowed(nodemask_t *nodemask)
+static inline int cpuset_nodemask_valid_mems_allowed(const nodemask_t *nodemask)
 {
 	return 1;
 }
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 485df9c2dbdd..2101e5205fc0 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -4042,7 +4042,7 @@ extern int __meminit early_pfn_to_nid(unsigned long pfn);
 extern void mem_init(void);
 extern void __init mmap_init(void);
 
-extern void __show_mem(unsigned int flags, nodemask_t *nodemask, int max_zone_idx);
+extern void __show_mem(unsigned int flags, const nodemask_t *nodemask, int max_zone_idx);
 static inline void show_mem(void)
 {
 	__show_mem(0, NULL, MAX_NR_ZONES - 1);
@@ -4052,7 +4052,7 @@ extern void si_meminfo(struct sysinfo * val);
 extern void si_meminfo_node(struct sysinfo *val, int nid);
 
 extern __printf(3, 4)
-void warn_alloc(gfp_t gfp_mask, nodemask_t *nodemask, const char *fmt, ...);
+void warn_alloc(gfp_t gfp_mask, const nodemask_t *nodemask, const char *fmt, ...);
 
 extern void setup_per_cpu_pageset(void);
 
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index ca2712187147..919be0d9b4fa 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -1815,7 +1815,7 @@ static inline int zonelist_node_idx(const struct zoneref *zoneref)
 
 struct zoneref *__next_zones_zonelist(struct zoneref *z,
 					enum zone_type highest_zoneidx,
-					nodemask_t *nodes);
+					const nodemask_t *nodes);
 
 /**
  * next_zones_zonelist - Returns the next zone at or below highest_zoneidx within the allowed nodemask using a cursor within a zonelist as a starting point
@@ -1834,7 +1834,7 @@ struct zoneref *__next_zones_zonelist(struct zoneref *z,
  */
 static __always_inline struct zoneref *next_zones_zonelist(struct zoneref *z,
 					enum zone_type highest_zoneidx,
-					nodemask_t *nodes)
+					const nodemask_t *nodes)
 {
 	if (likely(!nodes && zonelist_zone_idx(z) <= highest_zoneidx))
 		return z;
@@ -1860,7 +1860,7 @@ static __always_inline struct zoneref *next_zones_zonelist(struct zoneref *z,
  */
 static inline struct zoneref *first_zones_zonelist(struct zonelist *zonelist,
 					enum zone_type highest_zoneidx,
-					nodemask_t *nodes)
+					const nodemask_t *nodes)
 {
 	return next_zones_zonelist(zonelist->_zonerefs,
 							highest_zoneidx, nodes);
diff --git a/include/linux/oom.h b/include/linux/oom.h
index 7b02bc1d0a7e..00da05d227e6 100644
--- a/include/linux/oom.h
+++ b/include/linux/oom.h
@@ -30,7 +30,7 @@ struct oom_control {
 	struct zonelist *zonelist;
 
 	/* Used to determine mempolicy */
-	nodemask_t *nodemask;
+	const nodemask_t *nodemask;
 
 	/* Memory cgroup in which oom is invoked, or NULL for global oom */
 	struct mem_cgroup *memcg;
diff --git a/include/linux/swap.h b/include/linux/swap.h
index 8f0f68e245ba..bf76356d94fe 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -351,7 +351,7 @@ extern void swap_setup(void);
 /* linux/mm/vmscan.c */
 extern unsigned long zone_reclaimable_pages(struct zone *zone);
 extern unsigned long try_to_free_pages(struct zonelist *zonelist, int order,
-					gfp_t gfp_mask, nodemask_t *mask);
+					gfp_t gfp_mask, const nodemask_t *mask);
 unsigned long lruvec_lru_size(struct lruvec *lruvec, enum lru_list lru, int zone_idx);
 
 #define MEMCG_RECLAIM_MAY_SWAP (1 << 1)
diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 5c33ab20cc20..536ce591c7ba 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -4153,7 +4153,7 @@ nodemask_t cpuset_mems_allowed(struct task_struct *tsk)
  *
  * Are any of the nodes in the nodemask allowed in current->mems_allowed?
  */
-int cpuset_nodemask_valid_mems_allowed(nodemask_t *nodemask)
+int cpuset_nodemask_valid_mems_allowed(const nodemask_t *nodemask)
 {
 	return nodes_intersects(*nodemask, current->mems_allowed);
 }
diff --git a/mm/internal.h b/mm/internal.h
index 181e79f1d6a2..a2ef9512b5bc 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -668,7 +668,7 @@ void page_alloc_sysctl_init(void);
  */
 struct alloc_context {
 	struct zonelist *zonelist;
-	nodemask_t *nodemask;
+	const nodemask_t *nodemask;
 	struct zoneref *preferred_zoneref;
 	int migratetype;
 
diff --git a/mm/mmzone.c b/mm/mmzone.c
index 0c8f181d9d50..59dc3f2076a6 100644
--- a/mm/mmzone.c
+++ b/mm/mmzone.c
@@ -43,7 +43,8 @@ struct zone *next_zone(struct zone *zone)
 	return zone;
 }
 
-static inline int zref_in_nodemask(struct zoneref *zref, nodemask_t *nodes)
+static inline int zref_in_nodemask(struct zoneref *zref,
+				   const nodemask_t *nodes)
 {
 #ifdef CONFIG_NUMA
 	return node_isset(zonelist_node_idx(zref), *nodes);
@@ -55,7 +56,7 @@ static inline int zref_in_nodemask(struct zoneref *zref, nodemask_t *nodes)
 /* Returns the next zone at or below highest_zoneidx in a zonelist */
 struct zoneref *__next_zones_zonelist(struct zoneref *z,
 					enum zone_type highest_zoneidx,
-					nodemask_t *nodes)
+					const nodemask_t *nodes)
 {
 	/*
 	 * Find the next suitable zone to use for the allocation.
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 81a9d4d1e6c0..586524bbde9c 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3979,7 +3979,7 @@ get_page_from_freelist(gfp_t gfp_mask, unsigned int order, int alloc_flags,
 	return NULL;
 }
 
-static void warn_alloc_show_mem(gfp_t gfp_mask, nodemask_t *nodemask)
+static void warn_alloc_show_mem(gfp_t gfp_mask, const nodemask_t *nodemask)
 {
 	unsigned int filter = SHOW_MEM_FILTER_NODES;
 
@@ -3999,7 +3999,7 @@ static void warn_alloc_show_mem(gfp_t gfp_mask, nodemask_t *nodemask)
 	mem_cgroup_show_protected_memory(NULL);
 }
 
-void warn_alloc(gfp_t gfp_mask, nodemask_t *nodemask, const char *fmt, ...)
+void warn_alloc(gfp_t gfp_mask, const nodemask_t *nodemask, const char *fmt, ...)
 {
 	struct va_format vaf;
 	va_list args;
@@ -4687,7 +4687,7 @@ check_retry_cpuset(int cpuset_mems_cookie, struct alloc_context *ac)
 	return false;
 }
 
-static void check_alloc_stall_warn(gfp_t gfp_mask, nodemask_t *nodemask,
+static void check_alloc_stall_warn(gfp_t gfp_mask, const nodemask_t *nodemask,
 				unsigned int order, unsigned long alloc_start_time)
 {
 	static DEFINE_SPINLOCK(alloc_stall_lock);
diff --git a/mm/show_mem.c b/mm/show_mem.c
index 43aca5a2ac99..1b721a8ade67 100644
--- a/mm/show_mem.c
+++ b/mm/show_mem.c
@@ -116,7 +116,8 @@ void si_meminfo_node(struct sysinfo *val, int nid)
  * Determine whether the node should be displayed or not, depending on whether
  * SHOW_MEM_FILTER_NODES was passed to show_free_areas().
  */
-static bool show_mem_node_skip(unsigned int flags, int nid, nodemask_t *nodemask)
+static bool show_mem_node_skip(unsigned int flags, int nid,
+			       const nodemask_t *nodemask)
 {
 	if (!(flags & SHOW_MEM_FILTER_NODES))
 		return false;
@@ -177,7 +178,8 @@ static bool node_has_managed_zones(pg_data_t *pgdat, int max_zone_idx)
  * SHOW_MEM_FILTER_NODES: suppress nodes that are not allowed by current's
  *   cpuset.
  */
-static void show_free_areas(unsigned int filter, nodemask_t *nodemask, int max_zone_idx)
+static void show_free_areas(unsigned int filter, const nodemask_t *nodemask,
+			    int max_zone_idx)
 {
 	unsigned long free_pcp = 0;
 	int cpu, nid;
@@ -402,7 +404,8 @@ static void show_free_areas(unsigned int filter, nodemask_t *nodemask, int max_z
 	show_swap_cache_info();
 }
 
-void __show_mem(unsigned int filter, nodemask_t *nodemask, int max_zone_idx)
+void __show_mem(unsigned int filter, const nodemask_t *nodemask,
+		int max_zone_idx)
 {
 	unsigned long total = 0, reserved = 0, highmem = 0;
 	struct zone *zone;
diff --git a/mm/vmscan.c b/mm/vmscan.c
index e8a90911bf88..47d3f3361fb9 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -79,7 +79,7 @@ struct scan_control {
 	 * Nodemask of nodes allowed by the caller. If NULL, all nodes
 	 * are scanned.
 	 */
-	nodemask_t	*nodemask;
+	const nodemask_t *nodemask;
 
 	/*
 	 * The memory cgroup that hit its limit and as a result is the
@@ -6599,7 +6599,7 @@ static bool allow_direct_reclaim(pg_data_t *pgdat)
  * happens, the page allocator should not consider triggering the OOM killer.
  */
 static bool throttle_direct_reclaim(gfp_t gfp_mask, struct zonelist *zonelist,
-					nodemask_t *nodemask)
+				    const nodemask_t *nodemask)
 {
 	struct zoneref *z;
 	struct zone *zone;
@@ -6679,7 +6679,7 @@ static bool throttle_direct_reclaim(gfp_t gfp_mask, struct zonelist *zonelist,
 }
 
 unsigned long try_to_free_pages(struct zonelist *zonelist, int order,
-				gfp_t gfp_mask, nodemask_t *nodemask)
+				gfp_t gfp_mask, const nodemask_t *nodemask)
 {
 	unsigned long nr_reclaimed;
 	struct scan_control sc = {
-- 
2.54.0


