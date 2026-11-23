Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C63AC606A690
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 18:18:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=RYA9bNuq
Received: by kanga.kvack.org (Postfix)
	id CF28E6B05B4; Mon, 23 Nov 2026 13:18:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C7CCF6B05B5; Mon, 23 Nov 2026 13:18:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF63B6B05B6; Mon, 23 Nov 2026 13:18:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 731CA6B05B4
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 13:18:37 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DB0ABC09ED
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 18:18:36 +0000 (UTC)
X-FDA: 85467194232.25.8287F60
Received: from mail-oi1-f180.google.com (mail-oi1-f180.google.com [209.85.167.180])
	by imf01.hostedemail.com (Postfix) with ESMTP id 15F5540002
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 18:18:34 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=RYA9bNuq;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.167.180 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795457915;
	b=QCcK6eK1SlNnjHaJzJbJlypnBxAVyyY0syZPOej3uJ6tISeTpWZzI4f73gVFVVkVebjjSE
	TFXk3RRUKig9m8SGmWKKLt5t/35CxJCGI7Q9+N42lm4wo9+j9g4sycQ8Y+6Hs7C9e3u4D8
	lg17jtGHIE2RYvT2DnhZxtQyCSL6LQs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795457915;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CClaM17d8fZmvymfnrpm1hCIobp2fJDyOViMllLO/qU=;
	b=GcDlryXwyBGDXVJFEmNRkHkqj/0J2KghbnD1Ph6oRaxy7NXuWRGCLLgNcZl/oWd5809ccl
	cO5RmfjDHKZxq0XXyouZM/LNumPBI0VHagux4RPvidFI0s5HIPmSfvCS3X8BwgGFiDzoKk
	6noQlX8LCwODtSjKgE4Xi1M6bWXcWMo=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=RYA9bNuq;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.167.180 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
Received: by mail-oi1-f180.google.com with SMTP id 5614622812f47-57728d859e9so1543088b6e.1
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 10:18:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795457914; x=1796062714; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=CClaM17d8fZmvymfnrpm1hCIobp2fJDyOViMllLO/qU=;
        b=RYA9bNuq3WqOrHNCRZ9bbKnaJOJ8emx8QyljhjmZtoI0LHCb46y8D6nijcAGCqbTFJ
         mk3JWoR5r4BwkJc6j0uSdUDf56tQ5ReAilMjzDiVNynWBsNrLa8lOEcO3POD8HWA7pnB
         TLH06rY/Sh/F3BAH79GNfdw5kNFh603QjoopmzdaQASsPFLDvIMite/kOzuJgKKIWNYL
         CYDA7U3zD+kPiErVAKsDXswDKIVlXmoxno/RHnkkHgSaKCzFZgnzPerFtQqvAJeH7eGH
         RJa5VD2QpR+PUijGPu/v8WBlL/+IQZUNA+5MuiEFBehwkKsedJYo5IiKRtmJRYmSIw2Z
         7A0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795457914; x=1796062714;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=CClaM17d8fZmvymfnrpm1hCIobp2fJDyOViMllLO/qU=;
        b=ymSk3GhMyP+WxbtzZAT0rj17PtzxcfnbtWzfvMiuVNNMcRMq4hkEIKVtThHc0IKaM/
         kwPpAcrsQVtoDxLqtNHTDOn58IwPo7+E0CNBH3KSTiP7Bn8P75kWvBw7VxyP64aEYOp6
         qPQMs5t730OyrEfLUb64gvq3UhxRgi8YUR8Xr/EeXyNV/JCUUXDfuqsKam4SFFQw7sVH
         vOd8VPNxfJS6iCg500iWjgj2PDuPu5PaLJPrwnhPNlZaIp145ImlxrYB80fLnCxqG+UD
         2VmvdW25Zxfw2Aej2XL/k9YXSpB7RhXTb8H+O4JfjF+MLH8PCXbWMymKkMWdJxnNQrlI
         s4MA==
X-Forwarded-Encrypted: i=1; AL+hErEIrIkRGa3hWZfocuay2muTOPpN3IV0pHel5L86avOMb1Z6OLIIFcIDVGpAHeg9h8mZzSAbgBWt5w==@kvack.org
X-Gm-Message-State: APuU4Z/kw0CH3CYBpbolUev8fu4eNSgVOFSbzNGCK+sL+D6+d8lB+SVh
	YSPhorOZOoRjqA7n/xN5irVO2Se/iTH/o7PapQihPjkuKqyFoRdHzm9S
X-Gm-Gg: AZFdTZfcWmrQy0Wpr+mor83ave9dV63tfaxCTey2ztJEhHxOzh0p0Y1Y5znr/D6Idq3
	1r45PJi5kqQPkuRSY1vLI38cosWQPieyBVAkmqnJL5Dm23sEuu1SItrU0hnMlrfRzmxJvbPNhdz
	3B2Mz6lz/cbvTDG6KkmeAZ7NJA5jSGE1Cm7YXuVU/V6nbYYTi6Bja9Iz0vbPKKxUm1MxOPTQsNJ
	pFPwWpJWOdgkD6ByQri9p5ktEzLocFohaJafmM70+HQoozyq++ZmPLT4yTYNyYkEpavXFSd9LB/
	bGjZDu2QfTRgge+VpFVTr1LAvxpQ0KsTlMSOKrNTL3PVGuzHTWKcXXQC1xBYYgof3LQMUDOy73F
	ujlYhXavpspAB7+mrTnnqNve4GikErU/meFTMXeIDh8bDN1Zugzv1DIPtfRhs5s607NkJC/WMum
	G7ni9lvrKJBzQ6829t/ZJcA9nMbBwu57I2cu0hSX/KLmXBZWtFif9jQnryAdslFSUGeAwyQdph5
	pE4e/c4+aT1khnc/XfSDVTBFGtff/E6pfez2MWKtx6aKZbn96UvHPSLlhzo9PKSnxGTuF/Qb+Di
	cXhl2jCaktao+P72IbTpzfMNLDAyvSJxR6SHuGTW5C4YFG/oOMr3vOi2OTs=
X-Received: by 2002:a05:6808:308b:b0:55c:836:5950 with SMTP id 5614622812f47-57a0a91fc0dmr13549947b6e.27.1795457913993;
        Mon, 23 Nov 2026 10:18:33 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:8::])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-57a347636b9sm9601935b6e.7.2026.11.23.10.18.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2026 10:18:33 -0800 (PST)
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
Subject: [PATCH v4 1/2] mm/page_alloc: move the kswapd node skip check into a helper
Date: Mon, 23 Nov 2026 10:18:27 -0800
Message-ID: <20261123181829.4065581-2-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.1
In-Reply-To: <20261123181829.4065581-1-joshua.hahnjy@gmail.com>
References: <20261123181829.4065581-1-joshua.hahnjy@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspam-User:
X-Stat-Signature: pxw43mza8egqp5if9d15ciodhdxis58y
X-Rspamd-Queue-Id: 15F5540002
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795457914-801565
X-HE-Meta: U2FsdGVkX1/nkszb984elmecrKznNpmt4EnWmL3A8WvHC82aMX6+lphtftoXlhMETnmuye8dCQdStesuBvvOCvcE3oQ09WTSdXMq0ePhXxpMh8UZtgwEAOH/htFzmEwSaDSlv9pxZgf1Z6GPeQVqW6i1wLKt4X+bFznWTz+rEy86aA266l723YmEqhGT2QLc06ZP+3mMbq0Kca+/dXlKw9g6hbYm51XCAMG5JJbloi3hSMzHYK06wmwcX49JaUgAJqUpp4mZqm2/fQrBFMzfjho/+bRJO8dv25O1o1c1XRVCqTb8ytVbt35c1CEwm1fblj4v4c3ajH1SlwkUwM7hJc68h5WxKFg10mlEGV9Ce8BGPgQymezz+wUqCd0g+57JHv9za9h/c39Gzx7ErZU5e8RERxYxXCth03IzjvZM3O/6tWUw4IzhnP+OGFIdeRXxNZqsacSknG71JNRma6QuTaEOrbFaPrr3BaASqQ/UR+0iYCclZ6Yr4pcd1XLnIqxzTRU8OAEYeYutliPpfiur5HJsEu4lmwzxMcFZ4juMNNiZVMhGPPTsCwop+fiBqs1QBgubmZYV+CWj2phea30kjMay6DlEYh6ovM/hfDjpP0ZFRUMrPOr0doKIQGwDzm4YsheypTRbRT63yaseEoFecR7C8uqvjfCfNn2680aP7hAB0RFCcx9YYI+vPyrVBerVaOfkJmP1trg9jo8LuqxSm51D0lvWcH1OQfRbksxtdRe1JKE+vqyY4gZaytoOSX8qmmuw5oQuHJC69JKKZiwK2sVxn4wbYkT7pivV78IjYuA1Tevb3ucdRQVlf0fH7qVmgVzuvrjTRAnJRwJoLBALnjGpRk3eoQbcqWeBYMsFrS8CrCekeuCi9OHWoJTMqN0q/CeajmZRU+R4aCPaLU5UjRhlsfKGXzp56tGKqFDT8Ix4G//do8vR0nGcRex6KAA9uwjHmhw67VqLzQoUZtV
 wV143xBp
 NeEE352azJgIlzXu1Ph3+ImVn2p0s/8brBOk/SmvvV+gpwYjNne3jru1c+7nygYL1RH/uHBxCSoN91kX7cX6jaTa1YlvEiY67zsQ/SzsnYayftnd7pal/aJFRsyomT56iWMoPJJ5tcB7j2OIwvCgRPiYPFwOLyG5p4L8kdFh0WC+Syf9kFhCAQTZ4a6SnKr0edF/59hGO1yUB504r0FrTSosUziSmmh+nuiOp+qEYcK1uj6O6Rcn8FjqcalViyyN/pHwcP5REXio94vOnfnJ8FJdhsBnsAhmNCkfWiVjK014fPMiFFCvDFF2qKQgIfGRKXs6MCvdAH6//Sruc7pXDRuu3ZULY7VFFD0cbwXnFKRfT8962GtabxJIonfT3GLP+K0dw5ltxOLzd5EUnt691rAs6lv736WL0m6suToSv4K3T41Jk1GbJKmbZcLdwDHqRtbYoqHz2HzLbZD7mkHlwueMPVGAwyfRus8p3nfs8z7TF4mgdqTNye29Hmv20kTVDqzgL2YxyoboZgdWXw2F2MD88rp6AR88L6LItPXCaZXq2cchNpuiW0RlwKxfj8Gp00nA0cAfzVuvqZwzmdUqmPWShbqyJla2kBmuvxjS+KnB+5HGnXoWFoQhoKWaDWJCOJI/0q1pChmuagjSs4Qzwpn9tmGf9TfJA3zdMXy8pDeJEDAHFPxjAMb63ZTlPcoFPmVra4Q8MBHbvmOkzIQdf/6a/fec6dtTfIkRg6MmLCbczIQ+BZDM/HXo0PUYnJWRsMMScRhEfYmlVpjLlLHjeoOQ5oIdS333phvFDzQjcjfSFMwxwIgjHZPVQrnstCqMCIJ+uaPRwB8rOZOww7QUwaoXZTsrlqiw9dNmABf84fTzYPHz3bNqBzzT+ioOkT4+hF4KMlypByaGi6PltvDpuzxXV07bTP3A2P9NS/lF9W4lJAWXeG0488qcsgA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

get_page_from_freelist() checks many conditions for each zone, often
with a big comment block explaining the conditions.

Move the kswapd check and its comment into should_skip_kswapd_zone() to
make the zone iteration cleaner to read.

While moving this, also resolve a checkpatch warning which complains of
a waitqueue_active() call with no corresponding comment explaining why
the lockless use is OK in this case.

No functional change intended.

Reviewed-by: SJ Park <sj@kernel.org>
Reviewed-by: Chris Down <chris@chrisdown.name>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Gregory Price <gourry@gourry.net>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Tested-by: Chris Down <chris@chrisdown.name>
Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 mm/page_alloc.c | 49 +++++++++++++++++++++++++++++++------------------
 1 file changed, 31 insertions(+), 18 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 9e1261521b6a3..e7a7863e381ab 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3785,6 +3785,34 @@ static inline unsigned int alloc_flags_cma(gfp_t gfp_mask)
 	return ALLOC_DEFAULT;
 }
 
+/*
+ * If kswapd is already active on a node and the zone is below its kswapd
+ * watermark for this request, keep looking for other nodes that might be idle.
+ * This can happen if another process has NUMA bindings and is causing kswapd
+ * wakeups on only some nodes. Avoid accidental "node_reclaim_mode"-like
+ * behavior in this case.
+ */
+static inline bool
+should_skip_kswapd_zone(struct zone *zone, unsigned int order,
+			const struct alloc_context *ac, gfp_t gfp_mask)
+{
+	unsigned long mark;
+
+	/*
+	 * This means kswapd is asleep, so don't skip the zone. This is a
+	 * lockless check, since a stale result only affects zone selection.
+	 */
+	if (waitqueue_active(&zone->zone_pgdat->kswapd_wait))
+		return false;
+
+	if (sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING)
+		mark = promo_wmark_pages(zone);
+	else
+		mark = high_wmark_pages(zone);
+	return !zone_watermark_fast(zone, order, mark, ac->highest_zoneidx,
+				    0, gfp_mask);
+}
+
 /*
  * get_page_from_freelist goes through the zonelist trying to allocate
  * a page.
@@ -3796,9 +3824,6 @@ get_page_from_freelist(gfp_t gfp_mask, unsigned int order, int alloc_flags,
 	struct zoneref *z;
 	struct zone *zone;
 	struct pglist_data *last_pgdat = NULL;
-	enum zone_watermarks kswapd_watermark =
-		sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING ?
-		WMARK_PROMO : WMARK_HIGH;
 	bool last_pgdat_dirty_ok = false;
 	bool no_fallback;
 	bool skip_kswapd_nodes = nr_online_nodes > 1;
@@ -3865,22 +3890,10 @@ get_page_from_freelist(gfp_t gfp_mask, unsigned int order, int alloc_flags,
 			}
 		}
 
-		/*
-		 * If kswapd is already active on a node and the zone is below
-		 * its kswapd watermark for this request, keep looking for
-		 * other nodes that might be idle. This can happen if another
-		 * process has NUMA bindings and is causing kswapd wakeups on
-		 * only some nodes. Avoid accidental "node_reclaim_mode"-like
-		 * behavior in this case.
-		 */
 		if (skip_kswapd_nodes &&
-		    !waitqueue_active(&zone->zone_pgdat->kswapd_wait)) {
-			mark = wmark_pages(zone, kswapd_watermark);
-			if (!zone_watermark_fast(zone, order, mark,
-					ac->highest_zoneidx, 0, gfp_mask)) {
-				skipped_kswapd_nodes = true;
-				continue;
-			}
+		    should_skip_kswapd_zone(zone, order, ac, gfp_mask)) {
+			skipped_kswapd_nodes = true;
+			continue;
 		}
 
 		cond_accept_memory(zone, order, alloc_flags);
-- 
2.53.1-Meta


