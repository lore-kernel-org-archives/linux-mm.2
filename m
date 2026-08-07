Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0EE5CC5AC7A
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 20:21:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F7786B009B; Fri,  7 Aug 2026 16:21:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 031B66B009D; Fri,  7 Aug 2026 16:21:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E3B296B009E; Fri,  7 Aug 2026 16:21:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AC6E36B009B
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 16:21:15 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 23168A01A0
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 20:21:15 +0000 (UTC)
X-FDA: 85075592910.03.1DA8C3C
Received: from mail-oa1-f43.google.com (mail-oa1-f43.google.com [209.85.160.43])
	by imf19.hostedemail.com (Postfix) with ESMTP id 55D201A0002
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 20:21:13 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=o5UmXaK7;
	spf=pass (imf19.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.160.43 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786134073;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PmLOPzI7usjs7Qmnspd34ZMOrobza2FnhZDO80Oyo7g=;
	b=p/3b+Srea88fGozy8TOosz022iP5RN12OZc/7eERKTDLXwd7H1Nm4/YLH313Hbl2n+ZYLP
	YnupzeMXGsMAnFvlQI4lD59ttmDjOwOvRrXLg1NQYhKkw0aCnG9LCv+5FzbHeAWhgwN471
	CL0lYh2LOBMwOd7gBOzQZPGV1ztdiZI=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=o5UmXaK7;
	spf=pass (imf19.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.160.43 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786134073;
	b=iVr6CtqIYNEfL6/Wc7igtsUKxayBB6lM792pOmaw5T2/uAxbr0PyM0E4Fwp69tggnXmEW8
	AAdo3iUfI0YoN/gM6BHbw7je1QmiCCUIoMk2WKsy/7qRLNlzl7LUL6CPpuJ0YZzBTvWQ1m
	tNpLZ9koSWAirTJe9QBN5T+hcD22xvs=
Received: by mail-oa1-f43.google.com with SMTP id 586e51a60fabf-455ca262ccbso2163218fac.1
        for <linux-mm@kvack.org>; Fri, 07 Aug 2026 13:21:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786134072; x=1786738872; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=PmLOPzI7usjs7Qmnspd34ZMOrobza2FnhZDO80Oyo7g=;
        b=o5UmXaK7qRaIoO49CkdvjdD3/a4B+LTsakcd3OrCXT7AW2hrhsv7gyA9SqRaSOvx9n
         eWAwSTk95Bq0VwydR8NdGlxRE5i/LfPiIIkoRiz2GhYWiOEXBnXmA+SFq1sX0Pes+w/w
         s1rxa3ZpQPSmKlKxzkwV/DA7q1yYGdKimr50GvpVKBCxNxkaKVoSvSLu6R9ZTMV0Z5Wy
         OoF0oGik04UDRKZd6qDpXuYsetg3wNYN+cu9AKajROU2L1iMRLU1dQE3pd5Ltg6Gs+Zt
         y5k8oHHoJf45ut44e5xHnXhUACSk3hOJd7r3YtPCw5eofuBg27luBlTrvMl2+y/YxSOI
         XuwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786134072; x=1786738872;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=PmLOPzI7usjs7Qmnspd34ZMOrobza2FnhZDO80Oyo7g=;
        b=jNOZZNk3mzYgGAS8umkZI19glylHR2S1zoC5W9V8NsyasEAqo0PWkflsQAsbEGHLn1
         naxnJG04+//Z7L6pCUGfFXsgRH0LqU6L2seLLHKJUsbMsG8Y3sFWDGGbT/2xaL90hfvD
         RCS7rRX4y9+NPuM72vef9QCn5Cuby/XRAztKvFFV8jQz2vv64Pb8qLgFu2l/g18WUsd8
         XAhwmgPdiB4tihaUgLQHAyPXrjfQsk7xeV2uUIx2s+NQpNQAdy2+XxYOXEEiUG0z5vs8
         B5IVd0Ch1cyR5LxE5yGhUnELog+6x9NQ5wkriEZ7D8nnjHFhr2d1ofPqav8UfyhKGfNa
         rDuA==
X-Forwarded-Encrypted: i=1; AHgh+RrXGUtjV3fHuc5z+a5EPhqmG6zoUnLcPRVQBC2070uitxSXeE+yn8n4k2Kf1jyLfo0bV4te+mWlRA==@kvack.org
X-Gm-Message-State: AOJu0YyuZn6Tp4Aea3Y/Xo4wZ2pSjaH5SZIff+kaeOsRMVLpQmGQYC0A
	exoEjMbSr1J7uyPtmkGw6tZ+GC8n9HJqjxu4YDBR2WEwfLgdd8yPmT+7
X-Gm-Gg: AR+sD10+Wa4GK0qq/lcYvtHyUl5njhaA8KKxs+cbBmbPTOQjPCCpC5eIZouPT95F0OU
	PqRMbc9lnB4+GVOEpbM6x11zTTU13Jd/YZr/BgjQ0/KyMr0sEkQe1Gy8BxPIB+H1Om6Ku9n9ssQ
	YrqFUM/fWD5QT0c98RE58dnw3NWpVVodA22TTnQsRcJVKsEwxeymu0BQohccf1yn1LX9/kV3oiJ
	T2X/3Of/Go8L1pUe5ySH9p6KjbMWlviLhDcMrJ9Zy9hQk4MYf44IIZA+p/f/5gQJuqKZyvAHyM7
	30CmNXq3HIkOvbfBezsCj/8NZ+M6KMVWRWoeCCOBiPitDq2Z3WmQOm5lxGqC9QVeTtTVe6Ns0Ic
	8tebQ8Z8dwGi/UWQhtr8VlGZ4upL8jdfsQNRSWIvA/qy7Wibh49tw0hPH0KSNUpwzUpn+dI9zNM
	cKobvmWrVWNWwjN8Q8apRU6Ht0t7MYC28E7znv2oJLnOMoOfQ3MdL+reSHMpV7WnXbv+QUUpZAG
	vgu+TK/rJUReAayVfE=
X-Received: by 2002:a05:6871:79a9:b0:455:d6a6:6fdf with SMTP id 586e51a60fabf-4599f0ef42dmr14021135fac.21.1786134072221;
        Fri, 07 Aug 2026 13:21:12 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:42::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-459f1e348d0sm2692743fac.16.2026.08.07.13.21.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Aug 2026 13:21:11 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Gregory Price <gourry@gourry.net>
Cc: Alistair Popple <apopple@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Barry Song <baohua@kernel.org>,
	Ben Segall <bsegall@google.com>,
	Brendan Jackman <jackmanb@google.com>,
	Byungchul Park <byungchul@sk.com>,
	David Hildenbrand <david@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	"Harry Yoo (Oracle)" <harry@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Kairui Song <kasong@tencent.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Matthew Brost <matthew.brost@intel.com>,
	Mel Gorman <mgorman@suse.de>,
	Michal Hocko <mhocko@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Peter Zijlstra <peterz@infradead.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Rakie Kim <rakie.kim@sk.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Steven Rostedt <rostedt@goodmis.org>,
	Suren Baghdasaryan <surenb@google.com>,
	"T.J. Mercier" <tjmercier@google.com>,
	Valentin Schneider <vschneid@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Wei Xu <weixugc@google.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Yosry Ahmed <yosry@kernel.org>,
	Yuanchu Xie <yuanchu@google.com>,
	Zi Yan <ziy@nvidia.com>,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	kernel-team@meta.com
Subject: [RFC PATCH v3 08/14] mm/memcontrol: Make memory.low and memory.min tier-aware
Date: Fri,  7 Aug 2026 13:20:51 -0700
Message-ID: <20260807202059.2620949-9-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260807202059.2620949-1-joshua.hahnjy@gmail.com>
References: <20260807202059.2620949-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 55D201A0002
X-Stat-Signature: kc1nqmiritbesqtjp5aqjgu9tbie9aek
X-HE-Tag: 1786134073-647938
X-HE-Meta: U2FsdGVkX1+D/khXmnZdIiEUy0l9InHMKAWmOTgE4VIy8JvYFrvlJKlsdgLAqmOWoC58SbHEBasIMDvRasbdURmS5xrfjWAfyvYhVf9belIrtjnPHHuzkiFbx9f0zpG4L7L7ba8UqOoaflJ9VxczM0ixd8261Et948Cf7qqY/+p3farqT7ikVLGMGqNTZfxng/iCndNZDzFV6K9Ik95Jzx99j2mLblz9yawg0TiP4K34qckDhcRcw1k8eNqlIy+2a3vbIfB6OniueVfEFJ7T4swrCC3pGp9mk8vocS/luey0jLLamYh3L8jem1SxmAMvKsk1uXQD13FnS5fUHb6nRnFA2Zmy1bTy8DKOINSIAr6l0RI7mzx5fDXTItpkpV6z4E390xA8mslMXIITT9wK0AzS57atNRGmAmgiDsE9acveteCNypJwpCfBsibniOqchg2bnyMf9mcgsCZPKtDPieJiYF+LI0+AsaB2CRBOQmF5ByGDNTdLsAg7NEluiLoELHF0b6YxDWld7jycOii2ikeskqfWn/dNK+0548XCudrq1qXvQlw06J5/lHvepXw4PoYuScTr5ycVEZBZnZiXI48u+VZffQpQ1N29K5Oa48YquRMJVM3ULPe8ONM7hENErQ7gZetnzN3ohDkT1UO62Ih5rFVASvFrjU/IUA2fB8/zjrd9rh5lR23Hyb1XE1synrvQsdesSlAZ0Z4WI99MVWFFMFxDyy+mX7IZior33TFzI+dsWPq9dJJl6j0oQaxOgfud750ZQ3tXXA9U3Ve0xZ2Itebhz09L5v/wXc35VrT4cyZmOhue6eDWsrEekcaUJrSVh1kteNIHBDuS5sOkyfuPSV7NxYKldHoWDATYu6ASsXI6ae5rMRKiIFuRzuv7K7sn5uJgtmOoCnruEZAPiy6K44c4/SdG3TbChuagKH7C6XAKTNFVasufVEMMqaI2Cnxv3rKBdHHPQBmodLQ
 GQIkUBUr
 hIXxpXuPv9SI1TwuBwdsqoC7dS7m6+5KN6FM9cWuvBfOlKvTW8Eo87zfHVVSbJN9oNerAUCWPbO4RkbUHpPALYohOtPzMOqs0M7iMfJLRNqC1RgcS2fhKIF1lYptgSytVkTkrQy3p46WhL+PZCi1S8exssVaGRz8mcYWJbxp4LiFmomek6uj8ctHJHZrdw+6Iw92VCiIPQu+nzwlJbi4w2PCypCH07Ew8EURl/WuLGct61dw4cF1rRKcTrd1gVCcCpwZVkcwxP6vWqSmAqzjcJt9h94nploZUTDsVtBMfyGnviI+agtFysxUYeXPyOTvyJ5Uc75JBCjRwrS8hRfy7sDWGv173z7nmNchuUy2rkqitRRz/573Maa9H++eSd7lcpjia04Lnn/X+URATswAtxVfYd97xLbT7qiqkjroxPPGZWbfBHFj2x7oDEi8R3z7doJc1vYDMPXP9/hwaPNxOXGZVMLRPGOBr0FS/Ne7J3bqmntOW5k/JfJ81bQFcTSBlg4q6qsef7f4Qutf6mQncJDAJ59aonCa62iBP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On machines serving multiple workloads whose memory is isolated via
the memory cgroup controller, it is currently impossible to enforce a
fair distribution of tiered memory among the workloads, as the only
enforceable limits have to do with total memory footprint, but not where
that memory resides.

This makes ensuring a consistent and baseline performance difficult, as
each workload's performance is heavily impacted by workload-external
factors such as which other workloads are co-located in the same host,
and the order at which different workloads are started.

Extend the existing memory.{low, min} protection to be tier-aware in
order to enforce proportional best-effort and guaranteed memory
protection of higher-tier memory.

No-op unless the system has tiered memcg limits enabled.

Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 include/linux/memcontrol.h | 25 +++++++++++++++++++++----
 mm/memcontrol.c            | 11 ++++++++++-
 mm/vmscan.c                | 15 +++++++++------
 3 files changed, 40 insertions(+), 11 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index f7a92b66330ec..ceba0fd6de184 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -18,6 +18,7 @@
 #include <linux/page_counter.h>
 #include <linux/vmpressure.h>
 #include <linux/eventfd.h>
+#include <linux/memory-tiers.h>
 #include <linux/mm.h>
 #include <linux/vmstat.h>
 #include <linux/writeback.h>
@@ -618,21 +619,37 @@ static inline bool mem_cgroup_unprotected(struct mem_cgroup *target,
 }
 
 static inline bool mem_cgroup_below_low(struct mem_cgroup *target,
-					struct mem_cgroup *memcg)
+					struct mem_cgroup *memcg, int nid)
 {
 	if (mem_cgroup_unprotected(target, memcg))
 		return false;
 
+	if (mem_cgroup_tiered_limits()) {
+		int slot = nid_tier_slot(nid);
+
+		if (slot >= 0)
+			return READ_ONCE(memcg->tier[slot].elow) >=
+				page_counter_read(&memcg->tier[slot]);
+	}
+
 	return READ_ONCE(memcg->memory.elow) >=
 		page_counter_read(&memcg->memory);
 }
 
 static inline bool mem_cgroup_below_min(struct mem_cgroup *target,
-					struct mem_cgroup *memcg)
+					struct mem_cgroup *memcg, int nid)
 {
 	if (mem_cgroup_unprotected(target, memcg))
 		return false;
 
+	if (mem_cgroup_tiered_limits()) {
+		int slot = nid_tier_slot(nid);
+
+		if (slot >= 0)
+			return READ_ONCE(memcg->tier[slot].emin) >=
+				page_counter_read(&memcg->tier[slot]);
+	}
+
 	return READ_ONCE(memcg->memory.emin) >=
 		page_counter_read(&memcg->memory);
 }
@@ -1142,13 +1159,13 @@ static inline bool mem_cgroup_unprotected(struct mem_cgroup *target,
 	return true;
 }
 static inline bool mem_cgroup_below_low(struct mem_cgroup *target,
-					struct mem_cgroup *memcg)
+					struct mem_cgroup *memcg, int nid)
 {
 	return false;
 }
 
 static inline bool mem_cgroup_below_min(struct mem_cgroup *target,
-					struct mem_cgroup *memcg)
+					struct mem_cgroup *memcg, int nid)
 {
 	return false;
 }
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index f3714dfd85aa0..025496794cb91 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5310,7 +5310,16 @@ void mem_cgroup_calculate_protection(struct mem_cgroup *root,
 	if (!root)
 		root = root_mem_cgroup;
 
-	page_counter_calculate_protection(&root->memory, &memcg->memory, recursive_protection);
+	page_counter_calculate_protection(&root->memory, &memcg->memory,
+					  recursive_protection);
+
+	if (mem_cgroup_tiered_limits()) {
+		int nr_tier_slots = mt_nr_tier_slots();
+
+		for (int slot = 0; slot < nr_tier_slots; slot++)
+			page_counter_calculate_protection(&root->tier[slot],
+				&memcg->tier[slot], recursive_protection);
+	}
 }
 
 static int charge_memcg(struct folio *folio, struct mem_cgroup *memcg,
diff --git a/mm/vmscan.c b/mm/vmscan.c
index ffe7ea3c5aff6..29f3f12042650 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4190,7 +4190,7 @@ static bool lruvec_is_reclaimable(struct lruvec *lruvec, struct scan_control *sc
 	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
 	DEFINE_MIN_SEQ(lruvec);
 
-	if (mem_cgroup_below_min(NULL, memcg))
+	if (mem_cgroup_below_min(NULL, memcg, lruvec_pgdat(lruvec)->node_id))
 		return false;
 
 	if (!lruvec_is_sizable(lruvec, sc))
@@ -5057,6 +5057,7 @@ static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
 	bool need_rotate = false, should_age = false;
 	long nr_batch, nr_to_scan;
 	int swappiness = get_swappiness(lruvec, sc);
+	int nid = lruvec_pgdat(lruvec)->node_id;
 	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
 
 	nr_to_scan = get_nr_to_scan(lruvec, sc, memcg, swappiness);
@@ -5064,7 +5065,7 @@ static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
 		int delta;
 		DEFINE_MAX_SEQ(lruvec);
 
-		if (mem_cgroup_below_min(sc->target_mem_cgroup, memcg)) {
+		if (mem_cgroup_below_min(sc->target_mem_cgroup, memcg, nid)) {
 			need_rotate = true;
 			break;
 		}
@@ -5104,12 +5105,13 @@ static int shrink_one(struct lruvec *lruvec, struct scan_control *sc)
 	unsigned long reclaimed = sc->nr_reclaimed;
 	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
 	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
+	int nid = pgdat->node_id;
 
 	/* lru_gen_age_node() called mem_cgroup_calculate_protection() */
-	if (mem_cgroup_below_min(NULL, memcg))
+	if (mem_cgroup_below_min(NULL, memcg, nid))
 		return MEMCG_LRU_YOUNG;
 
-	if (mem_cgroup_below_low(NULL, memcg)) {
+	if (mem_cgroup_below_low(NULL, memcg, nid)) {
 		/* see the comment on MEMCG_NR_GENS */
 		if (READ_ONCE(lruvec->lrugen.seg) != MEMCG_LRU_TAIL)
 			return MEMCG_LRU_TAIL;
@@ -6168,6 +6170,7 @@ static void shrink_node_memcgs(pg_data_t *pgdat, struct scan_control *sc)
 	};
 	struct mem_cgroup_reclaim_cookie *partial = &reclaim;
 	struct mem_cgroup *memcg;
+	int nid = pgdat->node_id;
 
 	/*
 	 * In most cases, direct reclaimers can do partial walks
@@ -6197,13 +6200,13 @@ static void shrink_node_memcgs(pg_data_t *pgdat, struct scan_control *sc)
 
 		mem_cgroup_calculate_protection(target_memcg, memcg);
 
-		if (mem_cgroup_below_min(target_memcg, memcg)) {
+		if (mem_cgroup_below_min(target_memcg, memcg, nid)) {
 			/*
 			 * Hard protection.
 			 * If there is no reclaimable memory, OOM.
 			 */
 			continue;
-		} else if (mem_cgroup_below_low(target_memcg, memcg)) {
+		} else if (mem_cgroup_below_low(target_memcg, memcg, nid)) {
 			/*
 			 * Soft protection.
 			 * Respect the protection only as long as
-- 
2.53.0-Meta


