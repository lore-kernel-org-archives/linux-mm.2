Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76CC6606A323
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 23:24:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=WVZhuVDs
Received: by kanga.kvack.org (Postfix)
	id 4230A6B05B1; Mon, 16 Nov 2026 18:23:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3AD876B05B4; Mon, 16 Nov 2026 18:23:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 29C5F6B05B5; Mon, 16 Nov 2026 18:23:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E94946B05B4
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 18:23:54 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 88F271A0160
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 23:23:54 +0000 (UTC)
X-FDA: 85442561988.06.6F0901D
Received: from mail-ot1-f41.google.com (mail-ot1-f41.google.com [209.85.210.41])
	by imf11.hostedemail.com (Postfix) with ESMTP id B7A6C40005
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 23:23:52 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=WVZhuVDs;
	spf=pass (imf11.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.41 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794871432;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a0qfedX4Kuy4esVXCLbI84Kj587H6iqaG79bdZhV1ao=;
	b=aHGeUoQhq/lmGWI6ePbhHBEqvT5p188Esb2LOslTdFiVYQ5Eh+i3jrMhhx12fJXhcnZCde
	WhG++zISa9hPpjKXeA8fIXqw3YUY5RjgECf9BAJOFzxDbDMSQpB0vTrujZc/gK6rYMypQV
	fP+DKv/h9WY2O16jScH753z33GHGFIY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794871432;
	b=eXJXsa/W/2C8V7igEHaQHYydNANdukk2Kahmy97WTpdB83K95SPUo2VGCU/V6fgex84a3R
	96pPi8h845UakTvqHOOM9Y2FDxc/dA4nPA35XZ9pEY432klWGo3eme3jnMVQLEg2muRj3u
	/eaaKUqw32RcQOVFMlJsdqNDVZxwR10=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=WVZhuVDs;
	spf=pass (imf11.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.41 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ot1-f41.google.com with SMTP id 46e09a7af769-847ac7ccd85so3130485a34.3
        for <linux-mm@kvack.org>; Mon, 16 Nov 2026 15:23:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794871432; x=1795476232; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=a0qfedX4Kuy4esVXCLbI84Kj587H6iqaG79bdZhV1ao=;
        b=WVZhuVDsO0/RmJI0dIHvRDK50XU1BkdSomXg94rkQkvHplaF1VD+ok3sNZtZ3UUf0a
         k3ZOarIDIxBhhQTy9PKZHprsVYweFWUrBC0ZhJGkDiwVsqWxoZ1e6a6i9u+4E+/BsXVk
         R5pro5KsEKBgjL82dbwggaZFzif+bAg4CMGi8vMHwZU5hLX1ldh33gSZI61pblv1bJaH
         FU2lbXJqma/BK0R+DExn/lp8a9Vjd5OxdObdLNBj6UVcKJjhsbWNfANRWt7KX1h+MkUy
         v/W0ghauw0KBgyImCZq3mghF5OniSImZCGEQUQ9Ahh6yIZWYBYW/BeggqEgThs6Mu74l
         xKUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794871432; x=1795476232;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=a0qfedX4Kuy4esVXCLbI84Kj587H6iqaG79bdZhV1ao=;
        b=TeYUFMnqWyahS/qMZr4wJcai33bmkO1vToFUr5y6tlP99McoD9LWA7wtc43rLniklR
         yBHzQpSRGeJPRJCAp+zx0ZplDjB7viSEC1t4dA6Q3Wgty5TvgmklM/zXKPEsB3HL5cuo
         JllTYPY0RqnrhFAaX7iLcHsCNnad4qRXxh5//juHqZc9zUmjfsu15JtOu3F3TOBM5/mh
         h/S1KuKN9UJfRdaGdf6pKSexRJ7Ful/mW3KzW+blyrQTdiZVEws4BjSu6vfroxWkbqd3
         94lN8jh+IRWqX+ImzcWB2ToUyFq8tL0mgmD0bGes0Co1jfKTGg379jVMtmgz2Yo7xX5u
         LedA==
X-Forwarded-Encrypted: i=1; AL+hErFgQptjCnmLA/T2y5lAPBjuEdq6TWQwkoZGheQlqu989gmX/6qvaX/vKnMiKtB9bhtZfh8w6BOmXA==@kvack.org
X-Gm-Message-State: APuU4Z9eL27toYxlQmGN6R6m/26gD55HflRdXuiQ6psfmVPZoe185ToR
	lyRXAjMpoUza9lOoU51Dz57qMTvL9Br1gUkaGVuG+7XrjLwrBeujZVLB
X-Gm-Gg: AYBFou0pQxyqwi/2/PhU89oVdA0WwTpPOnqCymsTFtli7FSZOXQT0D99gL+1FVoPWOz
	I+Tzr/PIXzQfAom4bXoyhg67PviqMQdNPgAY7g0l7huzob8hmwlFpJSKLc5GEPcT85bwgR8BX/k
	gHmSz2oqDl5ZSFImBfeexczs53yrb77K1bwBbYeSA346YuyprPwpgf3sDWtgooNZGI5Zn9Z3i7z
	ruIB/haeQjhSgrFc4/tKRibQ3gFwiWtozOmgiW4YWvvlYpXenSAYi2jDLO+eYqRuL+zjjws5p1I
	rvcH0wfHp8fpZeSxzi9OeI+FA0kXj81gzbdcZZRvJDU21UccrSvoXAYqBHwt61en/lBfOlqbNu2
	NYuOUSD5XtmavS5kCZ8mx29+3Sy89Gci7BwQkpp17uLULl6Z5lZEBKuwYp6MXCnJiatixrLVt+N
	kLTH1unv0uykRSpDA+2FliYIQpLsH5se+APcEmrE7UilVVLxeaV8equQGHKv9FH0oJ8X693Jp8B
	7kz2flX6bMg2pE9NvI6KQQPVvVCVzYT5OfrPARAAlqQ57413UUXtGa1G0uKLAI4P95UaKouqdFJ
	r/o7m7Fewe9VNjJuPXBoAyJb10pSYRJ8Gpm5Bx9W6Pqm/gxPF3miPv/iyIKt
X-Received: by 2002:a05:6830:854b:10b0:862:b9dc:183b with SMTP id 46e09a7af769-862b9dc1e62mr3704643a34.27.1794871431735;
        Mon, 16 Nov 2026 15:23:51 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:73::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-862880e779dsm11204093a34.11.2026.11.16.15.23.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 15:23:51 -0800 (PST)
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
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH v2 3/3] mm/vmscan: consolidate promo vs. high watermark checks
Date: Mon, 16 Nov 2026 15:23:45 -0800
Message-ID: <20261116232346.788145-4-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.1
In-Reply-To: <20261116232346.788145-1-joshua.hahnjy@gmail.com>
References: <20261116232346.788145-1-joshua.hahnjy@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: jx5rtpfatr9thkbne9sp3oqkzqjpdx1c
X-Rspam-User: 
X-Rspamd-Queue-Id: B7A6C40005
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1794871432-766761
X-HE-Meta: U2FsdGVkX1+GB2mj3QNTRR3TTAPYXqOWqb/kk7MrqLCZI2l+slVap0Sqa+pUc3rlHh5UdfoAWivR8zD4IyphiCmh+zWLpP2qC0lyA9E1Vz9Mj16CtbYo0D7AgRiR6QfwMO69ZL7GWNssA2V02G/+Oe7k3DVDjQ61MJCYVTbZVUh8lj01daPh8Tyj411uJklgKrGbY+h+i9e1fvCsh/2U+FveZDIKE0kOXVdSdv1WIw4Vd+6W3CwmFcwL0lLABMOkIideldlBEq0hVsArUdeF6rHAMHXWIinw7BI3ORDKvvpZXFPU/axfHCzz7aekA/v0GkrJIlwHpoGtPz2m3dsrDp8rTSqQ9Zux79D2StOUX0JMqTjEaCC7RHusuKFjBj7rZ7Lw+hkUSoRAkYz3ah7w5s2q80CP0w84cA7VWEwQigMnabFHKAVWxpjyZyGMFHy/C9o+gEvQjn1/hYt1hEkZmFYanl83nQAR3cIj3F4M45hzyhF6Y06JQ1RaxUH1bI+ECIlnuK4ztGBbjJmPX2xXJn0D7YBkdWrAlK3soB0oMVdSvrETZlLvyGbW0UHAFHqFQPctXtOjmSvijjfwouLDhXrSCMX4rAfSsmpTEf6kBBE4Jfp7taVC+NTJ5O5bpsDFR+QZ5lxQ83GK7ed4Fi3VsHxqkuYetH/PiwcXf60T9SQABWzhUsQT69PN1hKPaBmwLK4d+hAPCVSZSmxG3XygIxiV40v/F8qP164cuTGYnxv6Xok2Z1CARFQy3K4onpVze7WcsAQz5G4SvNU7ehMDHfAnnscjzbXjDGecuLDRq3HOlT2UuWp1Pmi5pcQ7xeGSvsZ+YHRsu1FoCgVO4M2BTVK/bMin6r6FGO5OQ2HNAYwld+wrnHjMJ2WV5VnSfNft3JYzIoI0WJmPiX6ytcAz2N+tcZBvEUGLX96qhB9Ji6BLwCSrd4p03/zU8wPyxDvmbpEOlkLCMXlCwqQixSV
 KRlo/jV6
 0BPdbirn0AxbEEUJOJVjNKDULBa+1rZ6SVXYvPPm4c+1h/OcdRnhDvT4ARWQzutklkKQC3ax55MC4Qf0hEKZJ4iReinSbi4T48TPpuMSDalm6fJZHncUJGIs5GIw3ZghAZDD0G5UeLea3jaFDre96bjatFNoXMGP98mwhyv3r/Rx1L2vHqPGWnRmVn7rA+DMY7tVCJtkpt8ofPwjW87adm8ltvDSlDApWGUqc9h/98KjjGKckzzrkjrDNemSGnidbpoqbRjt5Oo0/CFicpyaV2NoE1dzmPaoEotKITth53YXNvTOyNX+w/2n/lD47zT/WzM6Qn4gnW3gjTfS6ku5YpoLo42sTrc5APLx6L38fX3omco7C8jGt844WmcHFAYVEPRNVzfvnOCa7khEwmNOB5Iy6FpznDLrZPlM/0uCRwNYh1T8Q737jWy6tAAtL5Q+niAjJx+rp6n+jXHRE6qabGmkvDdQy5tuf7eB8v6Iyubip16TugvBMs3n94ypuJ5hn/eeNRmJxbAAcgOtVsnoU3FhnZmldjjSo+e8V+9sbXHbtc6o=
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
index 43929faffb989..d7320566a9509 100644
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
@@ -3804,10 +3803,7 @@ static bool should_skip_kswapd_zone(struct zone *zone, unsigned int order,
 	if (waitqueue_active(&zone->zone_pgdat->kswapd_wait))
 		return false;
 
-	if (sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING)
-		mark = promo_wmark_pages(zone);
-	else
-		mark = high_wmark_pages(zone);
+	mark = kswapd_wmark_pages(zone);
 	return !zone_watermark_fast(zone, order, mark, ac->highest_zoneidx, 0);
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


