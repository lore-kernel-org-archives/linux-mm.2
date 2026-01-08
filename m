Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71D66D1D493
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 20:38:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D92856B0093; Thu,  8 Jan 2026 15:38:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D5D216B0095; Thu,  8 Jan 2026 15:38:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C4C016B0096; Thu,  8 Jan 2026 15:38:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B5C996B0093
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 15:38:53 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6E74214028A
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 20:38:53 +0000 (UTC)
X-FDA: 84309960546.16.68EF94B
Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	by imf13.hostedemail.com (Postfix) with ESMTP id 8ACCB20003
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 20:38:51 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=WdRBR7a7;
	spf=pass (imf13.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.47 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767904731;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HzEtunsMdBn4IQoHvFlHCM71GQRUPpw4LtA2vMizqz0=;
	b=d2SweCTK4fYpH0f00h8fCkagPplpWBbXcIJ5SaXQAMPSPtqy7rhv4lGiMH2DbCWvMIIMrT
	ucEHGRgDH7HQSqmmuui2pFoYSHWUjarSaTTL23ngyCIzgZrxmCP7jaqkzzDE19jiYE47l2
	1ZSX9omDPF6nx7sk9z/ueAp5jySL/kA=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=WdRBR7a7;
	spf=pass (imf13.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.47 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767904731; a=rsa-sha256;
	cv=none;
	b=DBJxm841xAFxv+0OGmYd6YC38kHOycZrTpKGd+yj8ViWo93kCqh4aaWwRAfUQ8VnqbU2ml
	qiHEqpikAMzCoCHLMBT3nN1+gbcYQZ3D1YZE7IQDvUWdhklpyNFsSfuw+9nktfHb0JGLAI
	V3DYGqWSGG0ajSLpfjQZDOikG2yst/M=
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-8888a1c50e8so42370416d6.0
        for <linux-mm@kvack.org>; Thu, 08 Jan 2026 12:38:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1767904730; x=1768509530; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HzEtunsMdBn4IQoHvFlHCM71GQRUPpw4LtA2vMizqz0=;
        b=WdRBR7a7fIT6qZIacnLMRB9x02UfvZB0ac2nmyMBxRmX+pwu6+qBKBlZpbQ+KrGdTR
         YkYdzS1Qh6r+aIV1qV7cINHIxc6H6L2fkqA3XlI8N1/ns+RnDkuwZE5LViTAF4oj3jSv
         P1u8TtATyYvKsHO5t/1W9aOtZENvLsw96+tNkxkg2HxNNXmH9eEYoo6YQkCNdydX3rDX
         pLU+opsvcukv0NShxZSoVxb7F7prSNavTa2UrOcv/YL8YPs5t69M9k1Emenqd7HIHynn
         riD5ojMnxkwQU+uvPvkzLOQaj+88rULlDVzyxEgYSK7KG4tJY8TyYU46xFaOojeQpv1Y
         PZCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767904730; x=1768509530;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=HzEtunsMdBn4IQoHvFlHCM71GQRUPpw4LtA2vMizqz0=;
        b=QuiW9bLpV0h65dAu6TSi31eIp3krIkzP8b738o0nKXA+u6OchDnvghWnkAb+K3ixNh
         Vm712lhYnazqD3Q2iZPvpb0LNnvJmbWq/tXvKPaIjCbaLFimqL811nAQV6qaXHBkrkHc
         hOj4OGIsxMEsQqPX1LgWtOsTtiSCHFmoesKLJ2PJzoXoCK51r3TAYG6t6avPQ0vTm6Iq
         Qq1+49Eig06yoC6B7gy1F91L+W392Lsljnp8RAAnkXFFQCyj2xaRomJsKgNr/eqsa1Jh
         bJN93D7e1czLKGrnOyaptPoCSs5Mam+YcOYUzi2zOsTfpw7oJuwl4KDsMVLcWEo1z5eC
         +bfg==
X-Gm-Message-State: AOJu0Yx/qvPBbtU9QFvqxwz8rmBPDMS6TCpKPbWQPiLvvYPlco3crTku
	6r5zyG9GYp0+2TbHt19R4hBYkyMSMumsEIivSrsxPB+OvS4bLO0k4lVt2Od7rYeUMkIBoxuKely
	9h6X2
X-Gm-Gg: AY/fxX4qNhYWnPzcBgAwmNOhY04FgRLrqj2atxpc9SljnwlGEF8iBtQBbQKhyCD60rU
	kezQur7HyWX1f8gUt1BkuIWwqQCTtJRaRhPOO0LzI9AOOFjbIpR8FnMRMA4Z8dE5wfWa2l6pCnl
	nqQIcN9VNkTdzMMqKsKRISuH7njm1+Tpkzzo8tVtb40o4AmxgxWqPqv9jnlJ+CfYgADb+tgfZwT
	0cEY96nAGi0Ea7XVqhuphKNYPV0D3MaCOVqPsWnXiASH/YGqTYs/oMJ2aryzjDO5zJaAg36kRXm
	tcl4i/WFzzNob+UQrK/rqv8ksaVrMruSY/Sb3/zk/zxcUJ5PtzUS3jitQj9aNdh+a9GNVVmta7k
	v5joJGSbBjBMW+OyXYo3n2cVkmi2zy2x9O9J7ajCcTildLlKlkw2BqcJ3KggcH0FYWEdtzr0U1T
	45+qGSUEKvP+EChbbBGZ18e/LHaxNkvI/F2Ym+WoCc/uM7MTcjAtMrfWbiQzDmyLZcMUwy4jvW3
	Ao=
X-Google-Smtp-Source: AGHT+IF3fWiGbPzGJ2jrA579ah6au0pY7RZhvW9wnxA0yziJvwGxMvsH3haaiag/Ap3aYN6F9CC0+g==
X-Received: by 2002:a05:6214:29c1:b0:890:19d1:532c with SMTP id 6a1803df08f44-890842311f3mr108761396d6.34.1767904730313;
        Thu, 08 Jan 2026 12:38:50 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F.lan (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-890770e472csm60483886d6.23.2026.01.08.12.38.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jan 2026 12:38:49 -0800 (PST)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-cxl@vger.kernel.org
Cc: linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	kernel-team@meta.com,
	longman@redhat.com,
	tj@kernel.org,
	hannes@cmpxchg.org,
	mkoutny@suse.com,
	corbet@lwn.net,
	gregkh@linuxfoundation.org,
	rafael@kernel.org,
	dakr@kernel.org,
	dave@stgolabs.net,
	jonathan.cameron@huawei.com,
	dave.jiang@intel.com,
	alison.schofield@intel.com,
	vishal.l.verma@intel.com,
	ira.weiny@intel.com,
	dan.j.williams@intel.com,
	akpm@linux-foundation.org,
	vbabka@suse.cz,
	surenb@google.com,
	mhocko@suse.com,
	jackmanb@google.com,
	ziy@nvidia.com,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	rppt@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	yury.norov@gmail.com,
	linux@rasmusvillemoes.dk,
	rientjes@google.com,
	shakeel.butt@linux.dev,
	chrisl@kernel.org,
	kasong@tencent.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	bhe@redhat.com,
	baohua@kernel.org,
	yosry.ahmed@linux.dev,
	chengming.zhou@linux.dev,
	roman.gushchin@linux.dev,
	muchun.song@linux.dev,
	osalvador@suse.de,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	cl@gentwo.org,
	harry.yoo@oracle.com,
	zhengqi.arch@bytedance.com
Subject: [RFC PATCH v3 3/8] mm: restrict slub, compaction, and page_alloc to sysram
Date: Thu,  8 Jan 2026 15:37:50 -0500
Message-ID: <20260108203755.1163107-4-gourry@gourry.net>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260108203755.1163107-1-gourry@gourry.net>
References: <20260108203755.1163107-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 386e1rh67t5976wjfzbe196hg4ecqu3k
X-Rspam-User: 
X-Rspamd-Queue-Id: 8ACCB20003
X-Rspamd-Server: rspam08
X-HE-Tag: 1767904731-516784
X-HE-Meta: U2FsdGVkX18AvRwYm2oy+ktMXvDg1Qb5p476QDcRYUKm6K6zkRlbzeLNOWud+yGCPz4amTQSPTWFr79bis1ImG9n9yfY336mjRfg2TRrI9Y33STh/r3XKOayF0B2vleF+j2+fG+oUi0BZ5+w7WMdnantQu3WGmo3a7to6wZS17UPXa/H2niH6WSgkhODJL21vSVy0e72IhTeSGYU8r+fiTuHq4Gab7lPTerkwE8bXfF0y7effjSiGnskImtB1ayavlc7h1JzO5uelOZVwtXdwCCZ7AfKubbMuPaBGcI1Cp2Uj7TP3BR7BCA0tXg7CZRAMa5ppMSbQHK9dlYtrkV97KnFXJEERibs0Wj2utjP11hHaQ1Q81bfaKxNNwvPKjZ/7f2Qs48TwDOfXAKzFHEzcrYVcsSsQNaGJexQsfwwVe0q9YVv35PbDl9dTAOJc9q0mXdLtCvvemB/+SbGpj1EB8ZRjyLSkWE2LdpuMt+eCvxL76e6iWmUgzBLUHmM7ega/jtCaB3/qRaL0pYUP22sJyL1vSGOF7V+2VKL3/l7pd1DNtrQI7K6LJzviDvkFrE4/BZvCNm0klhD0+npw3ozUpPj2isY5GSDV5IX6QssqnajZVqYnODkj2kcg6eHvrItqC4Fjzz6l31AoyOz3ZgijHIj8NHWMBTxbl+RPQhvKZtkIEG/5zihxdAB86tUS8HOhr7nU65PClRqRddG1knIceJNrJX+YpH96YXrp85Nda297kUUxeQiLghmwoKRZQfC0dDasXzxpFp12EQa3ymUzJn175ctz9g9WwN+ppuB2ZSU1s0yaYXFIYshDyttG/C4uo3pcXdYhRpFVBRzbEOnioae3ouNTDzFD8J6/vp8eUxSLCT8S3RlnzVhMycJ2/ktMzTyVeDblZ8FUQXw4VRgpRyWkHg97NwQwtDk/mM32q8xH5yv1o/FGToUpQ1wWwYsKUKeXA0OHRJVqOif/Qm
 KlYZbsF6
 AGU7EgGIol8gDkV1f7lWtOeGwTreVIv9r3E/+mkIb++X/hHOVBasg/0Ji1/6p/Z/LSyag1Run6zzR5zJCAw1Ym4Q9QNo5mreN/EfIjDf14i0sl14OKX6/47TkAe61JvBydZdpkE5ekAJjjWJOPsDTWj50R1IsdEbmIWP0Vlq8lXSvzl3n7QGWASDeZErfcyuAe/rxVSKNuoKIhAHxDp5bK212qBUx1Yo6SNuc4SgmoFeRSz/MRkZ1EeFYYNI3qHcfXebONnfVsc596EceeU2OvwmVAYIQYOrO+nikQo4yRTAshFEUR9zvMKFI8uuaQX1ZIYfpYg+8Ap+WpbUqFFDz0HeTem9PMgFE0ueTpWDearMu4M2VnCYM/BcUzJHNuaWnc3EUMXKAQSKaStMSrek99OgMkVSiXbDlgNaUfEjc5RKrDgVl+dYx0WdBna6vxtD+t+dSaWSehmvXYQU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Restrict page allocation and zone iteration to N_MEMORY nodes via
cpusets - or node_states[N_MEMORY] when cpusets is disabled.

__GFP_THISNODE allows N_PRIVATE nodes to be used explicitly (all
nodes become valid targets with __GFP_THISNODE).

This constrains core users of nodemasks to the node_states[N_MEMORY],
which is guaranteed to at least contain the set of nodes with sysram
memory blocks present at boot.

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 include/linux/gfp.h |  6 ++++++
 mm/compaction.c     |  6 ++----
 mm/page_alloc.c     | 27 ++++++++++++++++-----------
 mm/slub.c           |  8 ++++++--
 4 files changed, 30 insertions(+), 17 deletions(-)

diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index b155929af5b1..0b6cdef7a232 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -321,6 +321,7 @@ struct folio *folio_alloc_mpol_noprof(gfp_t gfp, unsigned int order,
 		struct mempolicy *mpol, pgoff_t ilx, int nid);
 struct folio *vma_alloc_folio_noprof(gfp_t gfp, int order, struct vm_area_struct *vma,
 		unsigned long addr);
+bool numa_zone_allowed(int alloc_flags, struct zone *zone, gfp_t gfp_mask);
 #else
 static inline struct page *alloc_pages_noprof(gfp_t gfp_mask, unsigned int order)
 {
@@ -337,6 +338,11 @@ static inline struct folio *folio_alloc_mpol_noprof(gfp_t gfp, unsigned int orde
 }
 #define vma_alloc_folio_noprof(gfp, order, vma, addr)		\
 	folio_alloc_noprof(gfp, order)
+static inline bool numa_zone_allowed(int alloc_flags, struct zone *zone,
+				     gfp_t gfp_mask)
+{
+	return true;
+}
 #endif
 
 #define alloc_pages(...)			alloc_hooks(alloc_pages_noprof(__VA_ARGS__))
diff --git a/mm/compaction.c b/mm/compaction.c
index 1e8f8eca318c..63ef9803607f 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -2829,10 +2829,8 @@ enum compact_result try_to_compact_pages(gfp_t gfp_mask, unsigned int order,
 					ac->highest_zoneidx, ac->nodemask) {
 		enum compact_result status;
 
-		if (cpusets_enabled() &&
-			(alloc_flags & ALLOC_CPUSET) &&
-			!__cpuset_zone_allowed(zone, gfp_mask))
-				continue;
+		if (!numa_zone_allowed(alloc_flags, zone, gfp_mask))
+			continue;
 
 		if (prio > MIN_COMPACT_PRIORITY
 					&& compaction_deferred(zone, order)) {
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index bb89d81aa68c..76b12cef7dfc 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3723,6 +3723,16 @@ static bool zone_allows_reclaim(struct zone *local_zone, struct zone *zone)
 	return node_distance(zone_to_nid(local_zone), zone_to_nid(zone)) <=
 				node_reclaim_distance;
 }
+bool numa_zone_allowed(int alloc_flags, struct zone *zone, gfp_t gfp_mask)
+{
+	/* If cpusets is being used, check mems_allowed or sysram_nodes */
+	if (cpusets_enabled() && (alloc_flags & ALLOC_CPUSET))
+		return cpuset_zone_allowed(zone, gfp_mask);
+
+	/* Otherwise only allow N_PRIVATE if __GFP_THISNODE is present */
+	return (gfp_mask & __GFP_THISNODE) ||
+		node_isset(zone_to_nid(zone), node_states[N_MEMORY]);
+}
 #else	/* CONFIG_NUMA */
 static bool zone_allows_reclaim(struct zone *local_zone, struct zone *zone)
 {
@@ -3814,10 +3824,9 @@ get_page_from_freelist(gfp_t gfp_mask, unsigned int order, int alloc_flags,
 		struct page *page;
 		unsigned long mark;
 
-		if (cpusets_enabled() &&
-			(alloc_flags & ALLOC_CPUSET) &&
-			!__cpuset_zone_allowed(zone, gfp_mask))
-				continue;
+		if (!numa_zone_allowed(alloc_flags, zone, gfp_mask))
+			continue;
+
 		/*
 		 * When allocating a page cache page for writing, we
 		 * want to get it from a node that is within its dirty
@@ -4618,10 +4627,8 @@ should_reclaim_retry(gfp_t gfp_mask, unsigned order,
 		unsigned long min_wmark = min_wmark_pages(zone);
 		bool wmark;
 
-		if (cpusets_enabled() &&
-			(alloc_flags & ALLOC_CPUSET) &&
-			!__cpuset_zone_allowed(zone, gfp_mask))
-				continue;
+		if (!numa_zone_allowed(alloc_flags, zone, gfp_mask))
+			continue;
 
 		available = reclaimable = zone_reclaimable_pages(zone);
 		available += zone_page_state_snapshot(zone, NR_FREE_PAGES);
@@ -5131,10 +5138,8 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 	for_next_zone_zonelist_nodemask(zone, z, ac.highest_zoneidx, ac.nodemask) {
 		unsigned long mark;
 
-		if (cpusets_enabled() && (alloc_flags & ALLOC_CPUSET) &&
-		    !__cpuset_zone_allowed(zone, gfp)) {
+		if (!numa_zone_allowed(alloc_flags, zone, gfp))
 			continue;
-		}
 
 		if (nr_online_nodes > 1 && zone != zonelist_zone(ac.preferred_zoneref) &&
 		    zone_to_nid(zone) != zonelist_node_idx(ac.preferred_zoneref)) {
diff --git a/mm/slub.c b/mm/slub.c
index 861592ac5425..adebbddc48f6 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -3594,9 +3594,13 @@ static struct slab *get_any_partial(struct kmem_cache *s,
 			struct kmem_cache_node *n;
 
 			n = get_node(s, zone_to_nid(zone));
+			if (!n)
+				continue;
+
+			if (!numa_zone_allowed(ALLOC_CPUSET, zone, pc->flags))
+				continue;
 
-			if (n && cpuset_zone_allowed(zone, pc->flags) &&
-					n->nr_partial > s->min_partial) {
+			if (n->nr_partial > s->min_partial) {
 				slab = get_partial_node(s, n, pc);
 				if (slab) {
 					/*
-- 
2.52.0


