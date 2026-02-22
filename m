Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20C38C624A6
	for <linux-mm@archiver.kernel.org>; Sun, 22 Feb 2026 08:49:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E57D6B008C; Sun, 22 Feb 2026 03:49:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B9F66B0092; Sun, 22 Feb 2026 03:49:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 664176B0093; Sun, 22 Feb 2026 03:49:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 549996B008C
	for <linux-mm@kvack.org>; Sun, 22 Feb 2026 03:49:08 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DCF7859807
	for <linux-mm@kvack.org>; Sun, 22 Feb 2026 08:49:07 +0000 (UTC)
X-FDA: 84471467934.24.6812BE6
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	by imf21.hostedemail.com (Postfix) with ESMTP id 091F11C000B
	for <linux-mm@kvack.org>; Sun, 22 Feb 2026 08:49:05 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="hPw7x/ul";
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.179 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771750146; a=rsa-sha256;
	cv=none;
	b=5PwiGa0Ci0Pjpwd0gOb617gpxg4V11l/JCz11ZXzgL15+ybdIfIWoQzFAA4oZ72iOa25LF
	aCAd++Q4qDasrIbt2MmPDoRVa8LWKuzNn+aVaRAWtmUEPh8HmiKKwRObzZQ61OAnU5oHna
	7tIcNi8xK0A6Mdb4e77aFDh2s/ljfN0=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="hPw7x/ul";
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.179 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771750146;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=84BLe7DIZgrLHIYUbF37QCRxTh9GXhBrS3ZeLS92Kiw=;
	b=7xFNiqU2QDHDi9YVq0aIxwBxOn0rLYy5sCU7ubiebnOrN2/SRCqtSTPza6nfdDIsQSox/F
	r8aQyqKBaMDEnV2p9ZRSAaUvmh7N3L5srHmN89+tf6KbFXK8YHM4iHFW/kCvPI2LmF/4Hy
	tAlQe8fhnOFUHKQHH3MT+6rcmO2KuDA=
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-506a747448dso28328521cf.0
        for <linux-mm@kvack.org>; Sun, 22 Feb 2026 00:49:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1771750145; x=1772354945; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=84BLe7DIZgrLHIYUbF37QCRxTh9GXhBrS3ZeLS92Kiw=;
        b=hPw7x/ulj0W5pVI6wBBZU1nlvxI1CSpk1m05vQdjgzIcOIfa4k56eqKjJkPMhNjOxu
         HMStU45jy2Xv49fQBwi8vGVRq02ZTs3wE6VEFhYMl13Oh4WkfMnZcfoxstUSaU7HSjYf
         9mysVWYuRGGVUmuq/KMO9PgJMVT4kpnqUSd2OLJFsvaQC6KKxMi+/qRFRD9KaPD3/1RZ
         zxrN+mFCiVhYIyHNCvhv3OOe/6iWB5Rli+VpDNdHLixIKp1Xf7K6JyrzJuSzsAhr9ZCv
         0rktm+xSPZ7AcNyV8Rn8+i3u0yemNQ0Mw8TbUUaT4JgKVjxuIFmcvtbxUpQ2InXh0DLc
         odew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771750145; x=1772354945;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=84BLe7DIZgrLHIYUbF37QCRxTh9GXhBrS3ZeLS92Kiw=;
        b=EPwqJ1wmephhWg9KP6BnVzPdF50hfCKCA1lrkKrzcxaKQBwt2r3Zow5UuHXJcunefw
         MFEC8HDARpC7hsZfwSmRtKkjPbZRNuJBQc34Iwp3Yc0bBw1kRr2VEjYCoiPMDDDh1qB5
         vmNtrhzDYq8O2oyICxRadcZtKllqzRMY4DqesVlY2vWt7WHpRM8pH+QJn/epP0ZvBKXL
         qz7934IUWfC92MK+JKjfE4I99m8cQwkOmpCcaw2WxYA8B3kpf+zcWXBe5gcS/oyjiaG1
         uOhBDJjEBm/3V/PHqoh+4u1iZ4N3zQ/ygFktBVh8q8be4Dp9uPSPrjEX73honPKkoQDO
         CGbg==
X-Forwarded-Encrypted: i=1; AJvYcCXOYqykeK7BAc3ts5G0HIZU/1HcZmD92qYf2wdnMJhcbehV5jsnYNzOPczJs7x4TD/H+Xf0Duthwg==@kvack.org
X-Gm-Message-State: AOJu0YyPaUjIrvIGidrgbGEFA8ZzZkmrKF4d2X/xtMCq852gtN6fDw9s
	rmBTrTxVxKT8WnzQ2hIIXY2MzmiMErB3hJiS7V0ExseZXaXnv+z052lYNFsEGAlxOck=
X-Gm-Gg: AZuq6aKE1ypHEoGmZcg3qe1oRba0nyD4S3glWmL/X0p3c0jBxW4//SuUHG/7nWPR6M5
	ki49ntll0/V+DEqvnSQFm47uMAdFR05340yOFn5wSvFI42fZdmOr9sSFYoxhDkhc5n66f6D7oVV
	2GG56IEJMzEWqOMGR7ttvER0s2g0YH49rWrh03hu0t5zJwtYw8AFIWaR3lPqqAvNyBb5U9VSmp5
	jtPe9zE0YgldN/xOfaaUAGPDVWjYVZrJydr009gmfGJc0haeCpKva4Z8pUvQ5R+f3qYGzi2psi4
	yUc6sKMniLmbPSB9N05pQdv5giwVcX1Sw5+OozvZrg4crBKJLMmQZeurbvlLpmKUU26Aw1ABzi3
	dhZEwVM0xLsHdkiP5hW2sS9iJJ8WcCaUYa5x0TrZ1X7kB/Lj+UZWywYyocXGVnhBqPBpf7DTMbY
	5kVPD9fVVI5o5LVHgJrvcSHA9TXcTEygAWpukeksthMZOkN49oe0F5cIjxAYIRQ5V6VH6+5xoVP
	Qv2/KyO6qdOzjI=
X-Received: by 2002:a05:622a:113:b0:4f4:a9cf:5d40 with SMTP id d75a77b69052e-5070bba20d9mr79750811cf.11.1771750145024;
        Sun, 22 Feb 2026 00:49:05 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F.lan (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5070d53f0fcsm38640631cf.9.2026.02.22.00.49.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Feb 2026 00:49:04 -0800 (PST)
From: Gregory Price <gourry@gourry.net>
To: lsf-pc@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	damon@lists.linux.dev,
	kernel-team@meta.com,
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
	longman@redhat.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	osalvador@suse.de,
	ziy@nvidia.com,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	yury.norov@gmail.com,
	linux@rasmusvillemoes.dk,
	mhiramat@kernel.org,
	mathieu.desnoyers@efficios.com,
	tj@kernel.org,
	hannes@cmpxchg.org,
	mkoutny@suse.com,
	jackmanb@google.com,
	sj@kernel.org,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	muchun.song@linux.dev,
	xu.xin16@zte.com.cn,
	chengming.zhou@linux.dev,
	jannh@google.com,
	linmiaohe@huawei.com,
	nao.horiguchi@gmail.com,
	pfalcato@suse.de,
	rientjes@google.com,
	shakeel.butt@linux.dev,
	riel@surriel.com,
	harry.yoo@oracle.com,
	cl@gentwo.org,
	roman.gushchin@linux.dev,
	chrisl@kernel.org,
	kasong@tencent.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	bhe@redhat.com,
	zhengqi.arch@bytedance.com,
	terry.bowman@amd.com
Subject: [RFC PATCH v4 03/27] mm/page_alloc: add numa_zone_allowed() and wire it up
Date: Sun, 22 Feb 2026 03:48:18 -0500
Message-ID: <20260222084842.1824063-4-gourry@gourry.net>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260222084842.1824063-1-gourry@gourry.net>
References: <20260222084842.1824063-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 091F11C000B
X-Stat-Signature: w99cjgryy6a4wgq4aerpx9bjpxo6dwqt
X-HE-Tag: 1771750145-38605
X-HE-Meta: U2FsdGVkX19+sI+JFRHe5HBLWf1wAkX0u5T7zMqlnQGm0dt4EbWzCX/lVrppewmA8r6AEe4iTHsbIiweU01vjU+gSydStDc4/zl1eDzokmPBhWWJ/mKhwPVeMFBVdM8JA5EFfpSmYEcm0dVWPRfjb3s3qbxcf7C/4MCry4HojT7ipwbOT3+j0mq14n1fQQHfxC3UXGU+BjbIFpeMGZnff5gGNTU9kBn3PpXAh0KQNCz7OtrQYk5grjhZQLGhf+ml2fzMV9rOCOstYyhGm3ZOphsPCiz6Bzb+XGr7rZL6kQm/Vdxpnl221QRPofRhgoqFHlzuxJ3WFULTomU07abwuzL9Ellln+f60v01PvR1r+zvJPoLvWjWD0VJdXvtQa2YCmM10YsHewwKxLke2oX/87bBXuNJFUQRcvYue72e1RqXmmDJ+EUpgZGqnF8y+izVXXLZHS9IHoK6eeaYZYseB3fQO50Q+G8l92tVb476xvXpDchQkt95q15gzD+2hv0n6w6vfuCqoo2/PCkjNkAdGkXUN68IyUAB9vROnEFfkuT93ViEO6LIhHrALHoXjHYxim1XTv1Ssah1jZOV7MmrFu5IA3f7Eu6U30iWJBp9XUxjV6K456gv6svY6RU9giwjCJW1KW4C2JU5qofjcZeT8quNnAoqdWqAl+7xAk0FmYYmPQ12XehYqC+hFUC6frCghVGNvR/YGrpgy6a8aEGrG4Z1/hUvQVnQTSIkzaOlskJ0XrHKArLazZTrlcfsf1Wz9ViWIIyXdaeFhWIpha7/9iar/WRNm5696yu/eLOCp6kpIPmCvaCNOhy979bmLm53UWXZS79oilE6H9qo9p46L6QGRONe0AgcHElzhcUiwH/c51Ww9q2VCZBodkV6DZiwqndlOhr26Uaef3m6dFcmvN/xaj50OhMHsEW3B/blqM2bmylXwuV55GBqx2P8H6GYE40hGS+QWPSAufT7M8T
 UBckMa/R
 JeQOcuEGd20D0lBCg25PnMtv3LoONrPkNrcS0QYn2kGwQ5n8dceU+ihTHUfjg0+5dEUao9S4UH4HAzT+Q5JWFOEQ5+hZsJW9wnJxptEi+245rzePaNG7OUpb/ACFCYG35y79Wg/X/CEmVrm8P4nSRohZLmcKpt5b266stIgdmbWbyge+/GqSuNw0DYNt0Vk1L8kBmQ9R8QTRq3tx+SsSJd2jeEIf/ZhVv8kXhe2IlQYHNggyg34OYjlcXQmKbZR5wYq3UeRQ4YZRUtjagzEFv+4+d3qUEI2610dk+qTWLub9RekIt30UUsCEJv7WYuYCub8Me0MqbYXWyDA+hydYErZ0mKbYj/ZseOVhKYIxwtvcxrRh0rVtGShazevFHKAYBERx07siPa8H0qCZrDbUffjNCqjpQkNMsFHrb9sZ3jE6tao2e7aDe4Ae7z6wKL5qWenoAESD9Zq464Yo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Various locations in mm/ open-code cpuset filtering with:

  cpusets_enabled() && ALLOC_CPUSET && !__cpuset_zone_allowed()

This pattern does not account for N_MEMORY_PRIVATE nodes on systems
without cpusets, so private-node zones can leak into allocation
paths that should only see general-purpose memory.

Add numa_zone_allowed() which consolidates zone filtering. It checks
cpuset membership when cpusets are enabled, and otherwise gates
N_MEMORY_PRIVATE zones behind __GFP_PRIVATE globally.

Replace the open-coded patterns in mm/ with the new helper.

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 mm/compaction.c |  6 ++----
 mm/hugetlb.c    |  2 +-
 mm/internal.h   |  7 +++++++
 mm/page_alloc.c | 31 ++++++++++++++++++++-----------
 mm/slub.c       |  3 ++-
 5 files changed, 32 insertions(+), 17 deletions(-)

diff --git a/mm/compaction.c b/mm/compaction.c
index 1e8f8eca318c..6a65145b03d8 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -2829,10 +2829,8 @@ enum compact_result try_to_compact_pages(gfp_t gfp_mask, unsigned int order,
 					ac->highest_zoneidx, ac->nodemask) {
 		enum compact_result status;
 
-		if (cpusets_enabled() &&
-			(alloc_flags & ALLOC_CPUSET) &&
-			!__cpuset_zone_allowed(zone, gfp_mask))
-				continue;
+		if (!numa_zone_alloc_allowed(alloc_flags, zone, gfp_mask))
+			continue;
 
 		if (prio > MIN_COMPACT_PRIORITY
 					&& compaction_deferred(zone, order)) {
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 51273baec9e5..f2b914ab5910 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1353,7 +1353,7 @@ static struct folio *dequeue_hugetlb_folio_nodemask(struct hstate *h, gfp_t gfp_
 	for_each_zone_zonelist_nodemask(zone, z, zonelist, gfp_zone(gfp_mask), nmask) {
 		struct folio *folio;
 
-		if (!cpuset_zone_allowed(zone, gfp_mask))
+		if (!numa_zone_alloc_allowed(ALLOC_CPUSET, zone, gfp_mask))
 			continue;
 		/*
 		 * no need to ask again on the same node. Pool is node rather than
diff --git a/mm/internal.h b/mm/internal.h
index 23ee14790227..97023748e6a9 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1206,6 +1206,8 @@ extern int node_reclaim_mode;
 
 extern int node_reclaim(struct pglist_data *, gfp_t, unsigned int);
 extern int find_next_best_node(int node, nodemask_t *used_node_mask);
+extern bool numa_zone_alloc_allowed(int alloc_flags, struct zone *zone,
+			      gfp_t gfp_mask);
 #else
 #define node_reclaim_mode 0
 
@@ -1218,6 +1220,11 @@ static inline int find_next_best_node(int node, nodemask_t *used_node_mask)
 {
 	return NUMA_NO_NODE;
 }
+static inline bool numa_zone_alloc_allowed(int alloc_flags, struct zone *zone,
+				     gfp_t gfp_mask)
+{
+	return true;
+}
 #endif
 
 static inline bool node_reclaim_enabled(void)
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 2facee0805da..47f2619d3840 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3690,6 +3690,21 @@ static bool zone_allows_reclaim(struct zone *local_zone, struct zone *zone)
 	return node_distance(zone_to_nid(local_zone), zone_to_nid(zone)) <=
 				node_reclaim_distance;
 }
+
+/* Returns true if allocation from this zone is permitted */
+bool numa_zone_alloc_allowed(int alloc_flags, struct zone *zone, gfp_t gfp_mask)
+{
+	/* Gate N_MEMORY_PRIVATE zones behind __GFP_PRIVATE */
+	if (!(gfp_mask & __GFP_PRIVATE) &&
+	    node_state(zone_to_nid(zone), N_MEMORY_PRIVATE))
+		return false;
+
+	/* If cpusets is being used, check mems_allowed */
+	if (cpusets_enabled() && (alloc_flags & ALLOC_CPUSET))
+		return cpuset_zone_allowed(zone, gfp_mask);
+
+	return true;
+}
 #else	/* CONFIG_NUMA */
 static bool zone_allows_reclaim(struct zone *local_zone, struct zone *zone)
 {
@@ -3781,10 +3796,8 @@ get_page_from_freelist(gfp_t gfp_mask, unsigned int order, int alloc_flags,
 		struct page *page;
 		unsigned long mark;
 
-		if (cpusets_enabled() &&
-			(alloc_flags & ALLOC_CPUSET) &&
-			!__cpuset_zone_allowed(zone, gfp_mask))
-				continue;
+		if (!numa_zone_alloc_allowed(alloc_flags, zone, gfp_mask))
+			continue;
 		/*
 		 * When allocating a page cache page for writing, we
 		 * want to get it from a node that is within its dirty
@@ -4585,10 +4598,8 @@ should_reclaim_retry(gfp_t gfp_mask, unsigned order,
 		unsigned long min_wmark = min_wmark_pages(zone);
 		bool wmark;
 
-		if (cpusets_enabled() &&
-			(alloc_flags & ALLOC_CPUSET) &&
-			!__cpuset_zone_allowed(zone, gfp_mask))
-				continue;
+		if (!numa_zone_alloc_allowed(alloc_flags, zone, gfp_mask))
+			continue;
 
 		available = reclaimable = zone_reclaimable_pages(zone);
 		available += zone_page_state_snapshot(zone, NR_FREE_PAGES);
@@ -5084,10 +5095,8 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 	for_next_zone_zonelist_nodemask(zone, z, ac.highest_zoneidx, ac.nodemask) {
 		unsigned long mark;
 
-		if (cpusets_enabled() && (alloc_flags & ALLOC_CPUSET) &&
-		    !__cpuset_zone_allowed(zone, gfp)) {
+		if (!numa_zone_alloc_allowed(alloc_flags, zone, gfp))
 			continue;
-		}
 
 		if (nr_online_nodes > 1 && zone != zonelist_zone(ac.preferred_zoneref) &&
 		    zone_to_nid(zone) != zonelist_node_idx(ac.preferred_zoneref)) {
diff --git a/mm/slub.c b/mm/slub.c
index 861592ac5425..e4bd6ede81d1 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -3595,7 +3595,8 @@ static struct slab *get_any_partial(struct kmem_cache *s,
 
 			n = get_node(s, zone_to_nid(zone));
 
-			if (n && cpuset_zone_allowed(zone, pc->flags) &&
+			if (n && numa_zone_alloc_allowed(ALLOC_CPUSET, zone,
+						   pc->flags) &&
 					n->nr_partial > s->min_partial) {
 				slab = get_partial_node(s, n, pc);
 				if (slab) {
-- 
2.53.0


