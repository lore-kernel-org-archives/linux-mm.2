Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19559606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 23:05:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ooKburYy
Received: by kanga.kvack.org (Postfix)
	id 5F2396B062A; Wed, 18 Nov 2026 18:05:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 557C76B062C; Wed, 18 Nov 2026 18:05:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4448F6B062A; Wed, 18 Nov 2026 18:05:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EDC726B062A
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 18:05:45 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5D6A01A08FC
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 23:05:45 +0000 (UTC)
X-FDA: 85449773850.13.DE0F4CD
Received: from mail-oi1-f169.google.com (mail-oi1-f169.google.com [209.85.167.169])
	by imf13.hostedemail.com (Postfix) with ESMTP id 8C62F20003
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 23:05:43 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=ooKburYy;
	spf=pass (imf13.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.167.169 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795043143;
	b=xY4pLwbHL/FViHEeUI0gMRM83muWWF+O4d8M8q1crXDMS2qWKYmtpvtPM5IHIqQD+yz8zh
	LV4NDQ3kltuggmvch2QQmmI/anSGnI5e6qx/ZeFiY2LMQ1q1SxdUaaZA5bUHH4DeomKyLp
	8JA9kfF86EtkDFRjxD2q03so/wYRKR0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795043143;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zhtdKe7IzyQSMaL2wH5+FyLh/ssntw5xQsfVmpbTGVw=;
	b=j3ac0VJjM83vrt+43STIHRAXkFsZIgLnRT5nytIhaXA5jlH95Wmeq4OXVnUyh7G4BDTCSt
	PNvfEACNbe4/6ntfx25g3vDrJ0Nem1PRNtaazfMUtRrpZxzjktJqyscocepWvztVkKSzEo
	qTsQTcu5/D6qJCwtBZbnh4lEy2CV8Fc=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=ooKburYy;
	spf=pass (imf13.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.167.169 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-oi1-f169.google.com with SMTP id 5614622812f47-55e0090c580so654649b6e.3
        for <linux-mm@kvack.org>; Wed, 18 Nov 2026 15:05:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795043142; x=1795647942; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zhtdKe7IzyQSMaL2wH5+FyLh/ssntw5xQsfVmpbTGVw=;
        b=ooKburYyHzRZmgK8xW72a2q0uQK20zaFxWwucnxSO+s6xAkktD6IE0lCtZqHMllq0J
         yUSR36SrauYml8EngGP9P/i/edJjJLZMW3wzF9ol/XbdNivPF79Xi6HW+Z5dwc8b3G+H
         nnumXrkyEwOPiWPpufafV/0CW2qmEAntcgfKZ/kQHAG73y3LfJHSrkMDvIEOjLkgKrdw
         gPhlQHzh6SOtIGiNJ1eEwM/7+1mUYqEXGGvSmOr5z7fYf8MXpWvPW5ubr1SWCCFZSHOH
         lmedJ8K7ldJHBm3naWhApiaxsL+CwltPR4xZApv754dJd3qTIFBQDVdlY8EPblS19szm
         Nyhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795043142; x=1795647942;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=zhtdKe7IzyQSMaL2wH5+FyLh/ssntw5xQsfVmpbTGVw=;
        b=rYKWCsB0soaOUsTUKxPPt9x4NivTLzp6NJoYjod6UWvQwPa3y1ERU6orcqzV5LpRYJ
         TUCyTJLKb/C07ggXqe4I+YwHI9Yvc/CEjF1+RQdPpygdkYv/hb1A35podesx5bMg2Xkj
         uEfAqPejjq0eYDEH2uKkCQoC/U8KP1WAR01svtTSTm/IQBuAeLk2pQFYY/FqPQsA4+bz
         nkwwZJCDECyYGWzOga5qPN615Zfmck5UXDYg3YQs/GjRNVkI8fUyPgBiFatzbtoI4T7N
         6G4lqSEv7c8evUdWwW8HNKVg1C/6OobjGtQi8OYxHpmkVClQcubjnklGLKo7O0GpJFxm
         gViA==
X-Forwarded-Encrypted: i=1; AL+hErGAVqYAtBj50wj+jGMcWkkw/VjYegvPllZnbjb2hHTbPFaKeR6Vwljw06Cy17Rdmm/texouolHFUw==@kvack.org
X-Gm-Message-State: APuU4Z8nlrlAFxXm9puTtmoRTalpwX6yOLoFuIf+MqGe9ruZ72sMPXqk
	MZYNaAneZ2jHljt7CUpN+vqTfHKS6hq/dYLkn/iGAgThQdZdxxSeNVvk
X-Gm-Gg: AYBFou3sCuh5j4EnmStAoCSOxUBd9uE7Db+3fFHiYtu50p4v4tUL2XNZTtcBgwPRlpS
	Ighy7tEdj8CBHXVxvLbXmqI8Yx/jgx/5qcrg6wIW/SghOZ0ZyvG7JXcmbnxc32iG4s0m+p30UWW
	omrhLTGNMkFxEAA3O2Su2XahtA8kN/P40O8OpDPNseallr9m3Ufl29Da5o295DCfW5jn6ycQmsW
	w4ydevOoXzHWkRG1Y+x8eQYhFSSFpQNmdm+pGl/PA2juWHUzghqUVh6mG62I5uqmPNrwyLOz2+v
	ZO6E1NKZubAqi8Zb7H+aLMW1SBYf0Y2erstSW9M1EIiGgIEKXYsTjdlKEbONG2fvcPU6RovRN41
	JUreB4c0tB294qngk6dwsiYWgFshIy4o0jy+wa9q0hSnPkuMUW8u0jbbdIhLzHPGZVPbybJZW+t
	4BA4sg3C7EjWP/Scpv77sYJACaLCfoa97AXmmqAtbTp5NlguPox7IbjGdMRciAKPs20xMgiWfQ0
	gThQnyrT9ioJq0iy5dXlGcliH7DCiS/PMO3wqkq9jjSObjwSB/s2dMf4u5sVWSdyPG4tCTyGWtd
	YXW+cBvDllP4974LwqhJYbMCAaxfu564XRV/g25POM+NjXy0w/kXL2CMUnyW
X-Received: by 2002:a05:6808:c123:b0:4d3:6be7:c64a with SMTP id 5614622812f47-57736f96339mr4621068b6e.0.1795043142543;
        Wed, 18 Nov 2026 15:05:42 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:70::])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-5777ad9b96fsm2402083b6e.12.2026.11.18.15.05.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 15:05:42 -0800 (PST)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Dev Jain <dev.jain@arm.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH v3 2/2] mm/vmscan: consolidate promo vs. high watermark checks
Date: Wed, 18 Nov 2026 15:05:35 -0800
Message-ID: <20261118230539.3789231-3-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.1
In-Reply-To: <20261118230539.3789231-1-joshua.hahnjy@gmail.com>
References: <20261118230539.3789231-1-joshua.hahnjy@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Stat-Signature: jjomwcc9rh6xdyjow5pnbe3pu4d1hn1p
X-Rspamd-Queue-Id: 8C62F20003
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam08
X-HE-Tag: 1795043143-551094
X-HE-Meta: U2FsdGVkX1+uO4UO90NXtrfBS+cnX1/bX2uCnVbZWcoNtjypbvn0CDkk4QimEbnq0jpeaqA/BGVDsbBEHr+BjnfB1p31CKjmAjqHntsrtaej1kDWgrjqAWOOIxRBnpBhosDSJooFltHEaO3UJqL7NF5gFKtFAcc2XCXlenoa2HqKahx5lGf4V3K4NqlqW1x9ovoSjDDlxRswbw72v5UVb6AIEuED6ISznq2jB3WoGPlkvchcjy+32UczfwgVd2QENBjsjFv6n1/5DKGI8WAm5UfyLWTqO84+fjhvzBHoUzVLrS/r23oMRlHZZnsIdhR4JVVcrZV5GbeP8KIPRy6HDF9uyQz69eyRdGlDecvh4+OoS1eBFZN4h3hms0VvJRPtF8FkfUl+440J9WWndGTm+AdMJLUQdCYEtk6bflwfbOQ+ffCIiXySdZoppltNI0h5gD/zLYMoNDvHaFAASNC9nVCECq+alEwJMtqaC0qtqCBplKa9tcOq079wY0LU89FVUmnPV/LwqQzZU6kj368gevzVsh8YttfbGDjnkG3L2R7r4rY7r3aelKmCx3AojNAYF3gVO1GqBJg2NKwEBWOcDna9q39aYkTbPb1TpWpkFlduYHmWgfVjHAPLYm/Nf983dVs3XojZPRAhUEA3KBS04LFVNK41VN6obwfUYxGD4lzZsV5aVsxxqz2/SUSg82Y9bBu2YP72Hln1e0gPk8FEXbX6uQEvARHX+SMeGPKO2e+QH7Q4mV/D1/jJu3yI8A3pJWiH/0/1HexDTTF1jvrh2agCoHMCNNiC1IEvS2qxAhoob94UMIg9wgpAPqYdFNJYOo8xVCtDvHVZ0igOAL2+REZF7RftWV8tB5jBVFzmaLXOehnDR5KGgGqwBTrRN7Fz5cOtXlI4A32UiBWgIR03vIwdUNGGQDqIXr1xPxBxGyH+eboaVcmzlZMpiKr5xqdBJIjKKJ6sptxcapZwiRi
 I87WA34r
 E+0Z+kDzFou8obuIMYjrpvm4pHglDpylUUs4hxcZjUs8NlzpABGfQ6jDQ59JGrJ7wIyoY2qVoKf1/mhNRXinFnWXqjfRZ1E1RABp3SS0d0PM+IxioI0wIgDjcrettqasYOobdfKUd6OTHds5STE5ed67YrvMMUtWAcV/qHj9e08BepG487KoWWgp602HiTVe76aZtkNgOoeMGmQOn/1In3/2kLtzfA3Azls/027rLGhxRNtvg1umQaBPToJR8gRLjb+D6nqLyJatMEiirvSsXvW8puyZ6lPcNj4874vNlVkkCd10mi+W4QOLYSz+MWW0/fGJlKn1alChbSV9h/2sp5jlfBW/6NUTWGcp1I06pxopf36fBFN5Pme1bOmQRImzdfGt6Xmi8yYlDZIR63zVuohPsG0e9hNL0w/qeDhOppbIifMnaAay1j/BhcyHAjrg1RAiGVZ5VmQEexYzr/Ev+UYC/JxOw/t3fdd3mwlh6zbtkcZVdDPVLUPxp3TXqUSW6y98b6exZ9ejBoqWPVE9QRvRnL7EDDMZrrfedg2YOL1clVs5kqvSV26NuXL8Y/0Fqv8PlkKJWiTbdh9npRu3ctE4kbHyiJWqsssd8qw2yqNe++Uydia7hCZ3dC3zo8wkSMj3/WhpzMqvkTHb/vDck186pnEOu2hZsvTQufNEJKObK+8OSOhJWZ9XJRHYkYIm4eJRae1rwDcmAc4+PuFAy3NzEU74zsmAxMvScyXYxv6wx2XrfVkIyX7V5Nqp2Z3N+s/Mm1VR+MJ+KG7BOR4M/0w/MkNuUIQ5SIpTrqHp/HO/fYL02uapMMr5VonnYBjZcq3wO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

There are three sites which all check the watermark that kswapd reclaims
zones up to, which is the promo watermark when NUMA balancing memory
tiering is enabled, and the high watermark otherwise.

Consolidate the pattern into a helper function. While at it, remove the
include for <linux/sched/sysctl.h> in mm/page_alloc.c now that the
dependency on sysctl_numa_balancing_mode has been abstracted into
vmscan code.

No functional changes intended.

Reviewed-by: SJ Park <sj@kernel.org>
Reviewed-by: Chris Down <chris@chrisdown.name>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Gregory Price <gourry@gourry.net>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Tested-by: Chris Down <chris@chrisdown.name>
Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 mm/internal.h   |  1 +
 mm/page_alloc.c |  6 +-----
 mm/vmscan.c     | 22 +++++++++++++---------
 3 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index 566cbd2dce485..8beb5b263ca1f 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -68,6 +68,7 @@ unsigned long try_to_free_pages(struct zonelist *zonelist, int order,
 				gfp_t gfp_mask, const nodemask_t *mask);
 unsigned long lruvec_lru_size(struct lruvec *lruvec, enum lru_list lru,
 			      int zone_idx);
+unsigned long kswapd_wmark_pages(const struct zone *zone);
 
 #define MEMCG_RECLAIM_MAY_SWAP (1 << 1)
 #define MEMCG_RECLAIM_PROACTIVE (1 << 2)
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index e7a7863e381ab..31a670eb4832c 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -45,7 +45,6 @@
 #include <linux/mmu_notifier.h>
 #include <linux/migrate.h>
 #include <linux/sched/mm.h>
-#include <linux/sched/sysctl.h>
 #include <linux/page_owner.h>
 #include <linux/page_table_check.h>
 #include <linux/memcontrol.h>
@@ -3805,10 +3804,7 @@ should_skip_kswapd_zone(struct zone *zone, unsigned int order,
 	if (waitqueue_active(&zone->zone_pgdat->kswapd_wait))
 		return false;
 
-	if (sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING)
-		mark = promo_wmark_pages(zone);
-	else
-		mark = high_wmark_pages(zone);
+	mark = kswapd_wmark_pages(zone);
 	return !zone_watermark_fast(zone, order, mark, ac->highest_zoneidx,
 				    0, gfp_mask);
 }
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 9959ca158ce83..9af50783fc824 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -478,6 +478,17 @@ unsigned long lruvec_lru_size(struct lruvec *lruvec, enum lru_list lru, int zone
 	return size;
 }
 
+/*
+ * The watermark kswapd reclaims zones up to. With NUMA balancing memory
+ * tiering, kswapd keeps room above the high watermark for promotions.
+ */
+unsigned long kswapd_wmark_pages(const struct zone *zone)
+{
+	if (sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING)
+		return promo_wmark_pages(zone);
+	return high_wmark_pages(zone);
+}
+
 static unsigned long drop_slab_node(int nid)
 {
 	unsigned long freed = 0;
@@ -5212,7 +5223,6 @@ static long get_nr_to_scan(struct lruvec *lruvec, struct scan_control *sc,
 static bool should_abort_scan(struct lruvec *lruvec, struct scan_control *sc)
 {
 	int i;
-	enum zone_watermarks mark;
 
 	if (unlikely(sc->proactive && signal_pending(current)))
 		return true;
@@ -5224,12 +5234,9 @@ static bool should_abort_scan(struct lruvec *lruvec, struct scan_control *sc)
 	if (!current_is_kswapd() || sc->order)
 		return false;
 
-	mark = sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING ?
-	       WMARK_PROMO : WMARK_HIGH;
-
 	for (i = 0; i <= sc->reclaim_idx; i++) {
 		struct zone *zone = lruvec_pgdat(lruvec)->node_zones + i;
-		unsigned long size = wmark_pages(zone, mark) + MIN_LRU_BATCH;
+		unsigned long size = kswapd_wmark_pages(zone) + MIN_LRU_BATCH;
 
 		if (managed_zone(zone) && !zone_watermark_ok(zone, 0, size, sc->reclaim_idx, 0))
 			return false;
@@ -7131,10 +7138,7 @@ static bool pgdat_balanced(pg_data_t *pgdat, int order, int highest_zoneidx)
 		enum zone_stat_item item;
 		unsigned long free_pages;
 
-		if (sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING)
-			mark = promo_wmark_pages(zone);
-		else
-			mark = high_wmark_pages(zone);
+		mark = kswapd_wmark_pages(zone);
 
 		/*
 		 * In defrag_mode, watermarks must be met in whole
-- 
2.53.1-Meta


